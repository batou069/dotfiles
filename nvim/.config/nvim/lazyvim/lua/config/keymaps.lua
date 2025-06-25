-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Find and center
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- save w/o auto-formatting
map("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

map("n", "<localleader>r", ":w<CR>:term python3 %:p<CR>", { desc = "Run Python File", noremap = true, silent = true })
map("n", "<localleader>t", ":w<CR>:term pytest -s %:p<CR>", { desc = "PyTest", noremap = true, silent = true })

map("n", "<leader><leader>S", ":source %<cr>", { desc = "Source Buffer", noremap = true, silent = true })

-- Terminal: <C-q> toggles a floating terminal; <Space>t opens a terminal in a small horizontal split.
map("n", "<C-q>", ":Lspsaga term_toggle<cr>", { desc = "Floating Terminal", noremap = true, silent = true })
map("n", "<leader>t", ":sp<bar>term<cr>:resize 10<cr>", { desc = "Split Terminal", noremap = true, silent = true })

-- inc rename\
vim.keymap.set("n", "<leader>rn", ":IncRename ")
