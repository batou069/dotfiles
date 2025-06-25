-- ~/.config/nvim/lua/plugins/background.lua
-- Initialize global background settings
vim.g.bg_settings = {
  transparent = false, -- Default transparency state
  opacity = 0.8,      -- Default opacity (matches Ghostty's config)
  blur_enabled = false, -- Default blur state (controlled by Ghostty)
}

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- Ensure it loads with LazyVim's colorscheme
    priority = 1000,
    opts = function(_, opts)
      -- Extend existing Catppuccin opts from colorscheme.lua
      return vim.tbl_deep_extend("force", opts, {
        transparent_background = vim.g.bg_settings.transparent,
      })
    end,
    config = function(_, opts)
      -- Function to send OSC sequences to Ghostty
      local function send_ghostty_osc(code, value)
        local esc = "\x1b]" .. code .. ";" .. value .. "\x1b\\"
        io.stdout:write(esc)
        io.stdout:flush()
      end

      -- Function to update Ghostty background settings
      local function update_ghostty_background()
        if vim.g.bg_settings.transparent then
          -- Set opacity when transparent
          send_ghostty_osc("11", string.format("rgba(0,0,0,%.2f)", vim.g.bg_settings.opacity))
          -- Blur is controlled by Ghostty keybindings, but sync state
          if vim.g.bg_settings.blur_enabled then
            send_ghostty_osc("705", "gaussian")
          else
            send_ghostty_osc("705", "none")
          end
        else
          -- Reset to fully opaque, no blur
          send_ghostty_osc("11", "rgb(0,0,0)")
          send_ghostty_osc("705", "none")
        end
      end

      -- Function to toggle transparency globally
      local function toggle_transparency()
        vim.g.bg_settings.transparent = not vim.g.bg_settings.transparent
        if vim.g.bg_settings.transparent then
          vim.o.background = "dark" -- Ensure dark background for transparency
          vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
          vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
        else
          -- Reset to theme's default background
          vim.api.nvim_set_hl(0, "Normal", {})
          vim.api.nvim_set_hl(0, "NormalFloat", {})
          vim.api.nvim_set_hl(0, "SignColumn", {})
          vim.api.nvim_set_hl(0, "LineNr", {})
        end
        -- Update Catppuccin if active
        if vim.g.colors_name and vim.g.colors_name:find("catppuccin") then
          require("catppuccin").setup(vim.tbl_deep_extend("force", opts, {
            transparent_background = vim.g.bg_settings.transparent,
          }))
          vim.cmd.colorscheme("catppuccin")
        end
        update_ghostty_background()
        require("lazy.core.util").notify(
          "Transparency " .. (vim.g.bg_settings.transparent and "enabled" or "disabled"),
          { title = "Background", level = vim.log.levels.INFO }
        )
      end

      -- Apply Catppuccin setup
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- Set initial background state
      if vim.g.bg_settings.transparent then
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
      end
      update_ghostty_background()

      -- Keybinding for transparency toggle
      vim.keymap.set("n", "<leader>ub", toggle_transparency, { desc = "Toggle Background Transparency", noremap = true, silent = true })
    end,
  },
}