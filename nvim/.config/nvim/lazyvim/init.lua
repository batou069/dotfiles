-- bootstrap lazy.nvim, LazyVim and your plugins

--          ╭─────────────────────────────────────────────────────────╮
--          │        vim.api.nvim_create_autocmd("VimEnter", {        │
--          │                      once = true,                       │
--          │                  callback = function()                  │
--          │               math.randomseed(os.time())                │
--          │      local fg_color = tostring(math.random(0, 12))      │
--          │       local hi_setter = "hi AlphaHeader ctermfg="       │
--          │             vim.cmd(hi_setter .. fg_color)              │
--          │                          end,                           │
--          │                           })                            │
--          │                                                         │
--          ╰─────────────────────────────────────────────────────────╯

require("config.lazy")
