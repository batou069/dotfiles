-- plugins/yanky.lua
return {
  "gbprod/yanky.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim" }, -- Required for yank_history picker
  },
  opts = {
    ring = {
      history_length = 100,
      storage = "shada",
      sync_with_numbered_registers = true,
      cancel_event = "update",
      ignore_registers = { "_" },
      update_register_on_cycle = false,
    },
    picker = {
      select = {
        action = nil, -- Default put action
      },
      telescope = {
        use_default_mappings = true, -- Use default Telescope mappings
        mappings = nil,
      },
    },
    system_clipboard = {
      sync_with_ring = true,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 300, -- 300ms highlight duration
    },
    preserve_cursor_position = {
      enabled = true,
    },
    textobj = {
      enabled = true, -- Enable text object for last put
    },
  },
  keys = {
    -- Yank and history navigation
    { "<leader>p", "<cmd>Telescope yank_history<cr>", mode = { "n", "x" }, desc = "Open Yank History" },
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
    { "<c-p>", "<Plug>(YankyPreviousEntry)", mode = { "n" }, desc = "Previous yank history" },
    { "<c-n>", "<Plug>(YankyNextEntry)", mode = { "n" }, desc = "Next yank history" },
    -- Basic puts
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before cursor" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after selection" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before selection" },
    -- Linewise puts
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", mode = { "n" }, desc = "Put indented after (linewise)" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", mode = { "n" }, desc = "Put indented before (linewise)" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", mode = { "n" }, desc = "Put indented after (linewise)" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", mode = { "n" }, desc = "Put indented before (linewise)" },
    -- Indent shift puts
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", mode = { "n" }, desc = "Put and indent right" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", mode = { "n" }, desc = "Put and indent left" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", mode = { "n" }, desc = "Put before and indent right" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", mode = { "n" }, desc = "Put before and indent left" },
    -- Filter puts
    { "=p", "<Plug>(YankyPutAfterFilter)", mode = { "n" }, desc = "Put after with reindent" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", mode = { "n" }, desc = "Put before with reindent" },
    -- Text object for last put
    {
      "iy",
      function()
        require("yanky.textobj").last_put()
      end,
      mode = { "o", "x" },
      desc = "Select last put text",
    },
  },
  config = function(_, opts)
    require("yanky").setup(opts)
    -- Load Telescope yank_history extension
    pcall(require("telescope").load_extension, "yank_history")
  end,
}
