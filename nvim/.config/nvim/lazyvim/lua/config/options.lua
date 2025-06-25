-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local cmd = vim.cmd
local opt = vim.opt
local hl = vim.api.nvim_set_hl
local fn = vim.fn
local api = vim.api
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

vim.g.python3_host_prog = "~/.nvim-venv/bin/python3"

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append("sI")
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
  "did_install_default_menus",
  "loaded_netrw",
  "loaded_netrwPlugin",
  "loaded_2html_plugin",
  "loaded_zipPlugin",
  "loaded_gzip",
  "loaded_tarPlugin",
  "loaded_sql_completion",
  "loaded_tutor_mode_plugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

vim.loader.enable()
vim.g.logging_level = vim.log.levels.INFO

vim.g.loaded_perl_provider = 0 -- Disable perl provider
vim.g.loaded_ruby_provider = 0 -- Disable ruby provider
vim.g.loaded_node_provider = 0 -- Disable node provider
vim.g.vimsyn_embed = "l"

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Copy/paste to system clipboard
opt.swapfile = false -- Don't use swapfile
opt.completeopt = "menuone,noinsert,noselect" -- Autocomplete options

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true -- Show line number
opt.relativenumber = true -- Show relative Numbers
opt.showmatch = true -- Highlight matching parenthesis
opt.foldmethod = "marker" -- Enable folding (default 'foldmarker')
opt.colorcolumn = "80" -- Line lenght marker at 80 columns
opt.splitright = true -- Vertical split to the right
opt.splitbelow = true -- Horizontal split to the bottom
opt.ignorecase = true -- Ignore case letters when search
opt.smartcase = true -- Ignore lowercase for the whole pattern
opt.linebreak = true -- Wrap on word boundary
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.laststatus = 3 -- PLACEHOLDER TODO, Set global statusline, optimal for avante
opt.cursorline = true
vim.g.have_nerd_font = true

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.autoindent = true -- copy indent from current line when starting new one

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true -- Enable background buffers
opt.history = 100 -- Remember N lines in history
-- opt.lazyredraw = true       -- Faster scrolling
opt.synmaxcol = 240 -- Max column for syntax highlight
opt.updatetime = 250 -- ms to wait for trigger an event

vim.g.health = { style = nil }
vim.wo.signcolumn = "yes" -- ?
opt.breakindent = true -- Keeps indentation on wrapped lines (visual improvement)
opt.undofile = true
opt.hlsearch = true -- Default = true / Highlight all matching searches
opt.timeoutlen = 300
opt.backup = false
opt.writebackup = false

-- ASK AI for Difference
opt.whichwrap = "b,s,<,>,[,],h,l"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.listchars = {
  tab = "→ ",
  -- space = "·",
  trail = "•",
  -- eol = "¬",
  nbsp = "␣",
  extends = "⟩",
  precedes = "⟦",
}
opt.scrolloff = 999
opt.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`
opt.numberwidth = 4 -- set number column width to 2 {default 4}
opt.smartindent = true
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 1 -- 1: Show tabs from 2+ open ones, 2: always show tabs
opt.backspace = "indent,eol,start" -- allow backspace on
opt.pumheight = 10 -- pop up menu height
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.cmdheight = 1 -- more space in the neovim command line for displaying messages

cmd([[language en_US.UTF-8]])

local config_dir = fn.stdpath("config")
---@cast config_dir string
vim.g.netrw_liststyle = 3

opt.inccommand = "split"

-- https://github.com/hendrikmi/dotfiles/blob/main/nvim/lua/core/options.lua
opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
opt.iskeyword:append("-,_") -- Makes hyphenated words (e.g., self-hosted) treated as single words in searches, motions (like w), and other word-based operations
opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
-- opt.runtimepath:remove("/usr/share/vim/vimfiles") -- separate vim plugins from neovim in case vim still in use
-- views can only be fully collapsed with the global statusline
-- PLACEHOLDER TODO

--          ╭─────────────────────────────────────────────────────────╮
--          │        api.nvim_create_autocmd("TextYankPost", {        │
--          │     desc = "Highlight when yanking (copying) text",     │
--          │                         group =                         │
--          │  api.nvim_create_augroup("kickstart-highlight-yank", {  │
--          │                    clear = true }),                     │
--          │                  callback = function()                  │
--          │                 vim.highlight.on_yank()                 │
--          │                          end,                           │
--          │                           })                            │
--          ╰─────────────────────────────────────────────────────────╯

opt.autochdir = true
opt.virtualedit = "block"
opt.cursorcolumn = false
opt.wrapscan = false
opt.fillchars = { eob = " " }

-- cmd("let g:netrw_liststyle = 3")
-- cmd([[highlight WinSeparator guibg = None]])
-- cmd([[highlight CursorLine guibg = None]])
-- cmd([[highlight CursorLineNr guifg = #d8a657]])
-- -- changing bg and border colors
-- hl(0, "FloatBorder", { link = "Normal" })
-- hl(0, "LspInfoBorder", { link = "Normal" })
-- hl(0, "NormalFloat", { link = "Normal" })
-- hl(0, "Pmenu", { link = "Normal" })
-- hl(0, "PmenuSel", { link = "Search" })

-- -- blink cmp
-- hl(0, "BlinkCmpMenu", { link = "Normal" })
-- hl(0, "BlinkCmpMenuBorder", { link = "Normal" })
-- hl(0, "BlinkCmpMenuSelection", { link = "Search" })
-- hl(0, "BlinkCmpLabelMatch", { link = "Search" })

-- -- snacks dashboard
-- hl(0, "SnacksDashboardHeader", { fg = "#d8a657" })
-- hl(0, "SnacksDashboardDesc", { fg = "#83a598" })
-- hl(0, "SnacksDashboardFooter", { fg = "#d8a657" })
--]]

-- snacks indentline
-- hl(0, "SnacksIndent1", { fg = "#ea6962" })
-- hl(0, "SnacksIndent2", { fg = "#d8a657" })
-- hl(0, "SnacksIndent3", { fg = "#458588" })
-- hl(0, "SnacksIndent4", { fg = "#8ec07c" })
-- hl(0, "SnacksIndent5", { fg = "#d3869b" })
-- hl(0, "SnacksIndent6", { fg = "#e78a4e" })
-- hl(0, "SnacksIndent7", { fg = "#83a598" })

-- snacks picker
-- hl(0, "SnacksPickerDir", { fg = "#928374" })

-- rainbow delimiter
hl(0, "RainbowDelimiter1", { fg = "#ea6962" })
hl(0, "RainbowDelimiter2", { fg = "#d8a657" })
hl(0, "RainbowDelimiter3", { fg = "#458588" })
hl(0, "RainbowDelimiter4", { fg = "#8ec07c" })
hl(0, "RainbowDelimiter5", { fg = "#d3869b" })
hl(0, "RainbowDelimiter6", { fg = "#e78a4e" })
hl(0, "RainbowDelimiter7", { fg = "#83a598" })

-- enabled with `:LazyExtras`
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.lazyvim_picker = "fzf"

-- The setup below will automatically configure connections without the need for manual input each time.

-- Example configuration using dictionary with keys:
--    vim.g.dbs = {
--      dev = "Replace with your database connection URL.",
--      staging = "Replace with your database connection URL.",
--    }
-- or
-- Example configuration using a list of dictionaries:
vim.g.dbs = {
  { name = "mysql", url = "mysql://root:123@localhost:3306/" },
  -- { name = "staging", url = "Replace with your database connection URL." },
}
vim.opt_local.conceallevel = 2
-- or
-- Create a `.lazy.lua` file in your project and set your connections like this:
-- ```lua
--    vim.g.dbs = {...}
--
--    return {}
-- ```

-- Alternatively, you can also use other methods to inject your environment variables.

-- Finally, please make sure to add `.lazy.lua` to your `.gitignore` file to protect your secrets.

--          ╭─────────────────────────────────────────────────────────╮
--          │      Add this block somewhere near the top of your      │
--          │          init.lua, after any global settings.           │
--          │        vim.api.nvim_create_autocmd("VimEnter", {        │
--          │   once = true, -- Ensures this autocmd only runs once   │
--          │                   per Neovim session                    │
--          │                  callback = function()                  │
--          │               math.randomseed(os.time())                │
--          │    local fg_color_code = math.random(0, 15) -- Using    │
--          │               standard 16 terminal colors               │
--          │          vim.cmd("hi AlphaHeader ctermfg=" ..           │
--          │                tostring(fg_color_code))                 │
--          │  local gui_colors = { "#FF0000", "#00FF00", "#0000FF",  │
--          │  "#FFFF00", "#00FFFF", "#FF00FF" } -- Add more colors   │
--          │local gui_color = gui_colors[math.random(1, #gui_colors)]│
--          │      vim.cmd("hi AlphaHeader guifg=" .. gui_color)      │
--          │                          end,                           │
--          │                           })                            │
--          ╰─────────────────────────────────────────────────────────╯
