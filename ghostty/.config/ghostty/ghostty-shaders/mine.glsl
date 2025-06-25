// Title: Trippy Rain Ripples
// Author: AI Assistant (Claude) for Ghostty
// Date: 2023-10-27
// Description: Creates subtle, expanding monochrome ripples like raindrops
//              on a dark surface, blending behind terminal text.
//              Requires Ghostty's background-opacity < 1.0.

// --- Configurable Parameters ---

// Ripples
#define GRID_SCALE 8.0        // How many grid cells across the screen height. Larger = smaller, more numerous potential drops.
#define RIPPLE_SPEED 0.8      // How fast the ripples expand outwards.
#define RIPPLE_FREQUENCY 15.0 // How dense the waves are within a ripple (spatial frequency). Higher = more rings.
#define RIPPLE_DURATION 3.5   // How long a single ripple lasts in seconds.
#define RIPPLE_FADE_TIME 1.0  // How long it takes for a ripple to fade out at the end of its duration.
#define CYCLE_DURATION 5.0    // Ripples trigger randomly within this time window (secs). Controls overall density.

// Visuals & Blending
#define GLOBAL_INTENSITY 0.15 // Maximum brightness of the ripple effect (lower is less distracting).
#define BASE_BRIGHTNESS 0.01  // Minimum background brightness (very dark grey). Set to 0.0 for pure black.
#define BACKGROUND_LUMA_THRESHOLD_LOW 0.03  // Terminal pixels darker than this are background.
#define BACKGROUND_LUMA_THRESHOLD_HIGH 0.2 // Terminal pixels brighter than this are foreground. Adjust for theme.
// -----------------------------

// --- Helper Functions ---

// Simple pseudo-random hash functions
vec2 hash22(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float hash12(vec2 p) {
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

// Function to calculate aspect-corrected UV coordinates
vec2 aspect_correct_uv(vec2 uv, vec2 resolution) {
    if (resolution.y <= 0.0) return uv - 0.5; // Failsafe
    vec2 corrected_uv = uv;
    corrected_uv.x *= resolution.x / resolution.y;
    corrected_uv -= 0.5 * vec2(resolution.x / resolution.y, 1.0); // Center
    return corrected_uv;
}


// --- Main Shader ---
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // --- Coordinate Setup ---
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 uv_aspect = aspect_correct_uv(uv, iResolution.xy); // UV centered and aspect corrected

    // --- Ripple Calculation ---
    float total_ripple_effect = 0.0;
    vec2 base_grid_id = floor(uv * GRID_SCALE); // ID of the grid cell this pixel is in

    // Iterate over a 3x3 grid area around the current pixel's cell
    // Ripples from neighboring cells can affect this pixel
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 cell_id = base_grid_id + vec2(x, y);

            // --- Ripple Generation within this Cell ---
            // Use cell_id to generate consistent random values for this cell
            float random_val = hash12(cell_id); // Base random value for timing etc.
            vec2  random_offset = hash22(cell_id + 0.5) * 0.4; // Random offset within the cell (-0.4 to 0.4)

            // Calculate when this cell's ripple should start within the cycle
            float time_offset = random_val * CYCLE_DURATION;
            float start_time = floor((iTime - time_offset) / CYCLE_DURATION) * CYCLE_DURATION + time_offset;

            // Check if the ripple is currently active
            float time_since_start = iTime - start_time;

            if (time_since_start > 0.0 && time_since_start < RIPPLE_DURATION) {
                // Calculate ripple center position (aspect corrected)
                 vec2 ripple_center_norm = (cell_id + 0.5 + random_offset) / GRID_SCALE; // Center in [0,1] space
                 vec2 ripple_center_aspect = aspect_correct_uv(ripple_center_norm, iResolution.xy);

                // Calculate distance from current pixel to ripple center
                float dist = distance(uv_aspect, ripple_center_aspect);

                // --- Wave Calculation ---
                // Basic sinusoidal wave moving outwards
                float wave_phase = dist * RIPPLE_FREQUENCY - time_since_start * RIPPLE_SPEED;
                // Use (1 + sin)/2 to map wave to [0, 1] range (only crests visible)
                float wave = (1.0 + sin(wave_phase)) * 0.5;

                // --- Falloff Calculation ---
                // Ripple fades out over time during the last RIPPLE_FADE_TIME seconds of its life
                float time_falloff = smoothstep(RIPPLE_DURATION, RIPPLE_DURATION - RIPPLE_FADE_TIME, time_since_start);

                // Ripple also fades slightly at the very beginning (optional, prevents harsh start)
                 float start_fade = smoothstep(0.0, 0.2, time_since_start);

                // Combine wave and falloffs
                // Using pow enhances the peaks slightly
                total_ripple_effect += pow(wave, 1.5) * time_falloff * start_fade;
            }
        }
    }

    // Clamp the combined effect to prevent excessive brightness from overlaps
    total_ripple_effect = clamp(total_ripple_effect, 0.0, 1.0);

    // --- Monochrome Color Mapping ---
    // Map the ripple intensity to a grayscale value, scaled by global intensity
    vec3 pattern_color = vec3(BASE_BRIGHTNESS + total_ripple_effect * GLOBAL_INTENSITY);
    pattern_color = clamp(pattern_color, 0.0, 1.0); // Final safety clamp

    // --- Compositing using Brightness Mask ---
    vec4 terminal_tex = texture(iChannel0, uv);

    // Calculate luminance (perceived brightness) of the terminal pixel
    float terminal_luma = dot(terminal_tex.rgb, vec3(0.299, 0.587, 0.114));

    // Create mask: 1.0 where terminal is dark (background), 0.0 where bright (text)
    float background_mask = 1.0 - smoothstep(BACKGROUND_LUMA_THRESHOLD_LOW, BACKGROUND_LUMA_THRESHOLD_HIGH, terminal_luma);

    // Mix between terminal color and pattern color based on the mask
    vec3 blended_color = mix(terminal_tex.rgb, pattern_color, background_mask);

    // Final Output: Blended color, fully opaque alpha.
    // Ghostty's `background-opacity` handles final window transparency.
    fragColor = vec4(blended_color, 1.0);

     // --- Debugging (Uncomment ONE line if needed) ---
    // fragColor = vec4(vec3(total_ripple_effect * GLOBAL_INTENSITY), 1.0); // Show raw ripple pattern only
    // fragColor = vec4(vec3(terminal_luma), 1.0); // Show terminal luminance
    // fragColor = vec4(vec3(background_mask), 1.0); // Show the background mask
    // fragColor = terminal_tex; // Show terminal texture only
}
