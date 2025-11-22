-- Linting with nvim-lint
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')

    -- Define linters by filetype
    lint.linters_by_ft = {
      make = { 'checkmake' },
      -- Add other linters here as needed
      -- Most linting is handled by LSP servers (like ruff for Python via LSP)
    }

    -- Create autocommand to trigger linting
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Optional: Add a keymap to manually trigger linting
    vim.keymap.set('n', '<leader>l', function()
      lint.try_lint()
    end, { desc = 'Trigger linting for current file' })
  end,
}
