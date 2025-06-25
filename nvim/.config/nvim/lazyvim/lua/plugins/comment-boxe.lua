-- lua/plugins/comment-box.lua
return {
  "LudoPinelli/comment-box.nvim",
  event = "VeryLazy", -- Or "BufReadPost", "BufNewFile" if you want it sooner
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<localleader>cb",
      "<Cmd>CBccbox<CR>",
      mode = { "n", "v" },
      desc = "Box: Title", -- Short and descriptive for which-key
    },
    {
      "<localleader>ct",
      "<Cmd>CBllline<CR>",
      mode = { "n", "v" },
      desc = "Box: Titled Line",
    },
    {
      "<localleader>cl",
      "<Cmd>CBline<CR>",
      mode = "n", -- This command is normal mode only in plugin examples
      desc = "Box: Simple Line",
    },
    {
      "<localleader>cm",
      "<Cmd>CBllbox14<CR>",
      mode = { "n", "v" },
      desc = "Box: Marked",
    },
    {
      "<localleader>cd",
      "<Cmd>CBd<CR>",
      mode = { "n", "v" },
      desc = "Box: Delete", -- For removing a comment box
    },
  },
  config = function()
    -- Register <localleader>c prefix for which-key
    local wk = require("which-key")
    wk.add({
      { "<localleader>c", group = "Comment Box" }, -- Group description for <localleader>c
    })
  end,
  -- This plugin doesn't require a .setup() call.
  -- Its commands are globally available once loaded.
  -- ── config = false, -- Explicitly state no config function is needed ──
}

