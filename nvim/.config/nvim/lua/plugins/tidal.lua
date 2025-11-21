return {
  'thgrund/tidal.nvim',
  opts = {
    mappings = {
      send_line = { mode = { "i", "n" }, key = "<S-CR>" },
      send_visual = { mode = { "x" }, key = "<S-CR>" },
      send_block = { mode = { "i", "n", "x" }, key = "<M-CR>" },
      send_node = false, -- Disable this mapping since it doesn't work
      send_silence = { mode = "n", key = "<leader>d" },
      send_hush = { mode = "n", key = "<leader><Esc>" },
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'haskell', 'supercollider' } },
  },
}
