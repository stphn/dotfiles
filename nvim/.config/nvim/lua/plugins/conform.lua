-- Formatting with conform.nvim
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    -- Define formatters by filetype
    formatters_by_ft = {
      javascript = { 'biome' },
      javascriptreact = { 'biome' },
      typescript = { 'biome' },
      typescriptreact = { 'biome' },
      json = { 'biome' },
      jsonc = { 'biome' },
      html = { 'biome' },
      css = { 'biome' },
      htmldjango = { 'djlint' },
      lua = { 'stylua' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      python = { 'ruff_format', 'ruff_organize_imports' },
    },
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { '-i', '4' },
      },
      ruff_organize_imports = {
        command = 'ruff',
        args = { 'check', '--select', 'I', '--fix', '--stdin-filename', '$FILENAME' },
        stdin = true,
      },
    },
    -- Format on save
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
