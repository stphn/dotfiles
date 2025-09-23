-- Keymaps for better default experience

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- For conciseness
local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Allow moving the cursor through wrapped lines with j, k
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- clear highlights
vim.keymap.set('n', '<Esc>', ':noh<CR>', opts)

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', { noremap = true, silent = true, desc = 'Save without formatting' })

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Resize splits with Shift + Arrow keys
vim.keymap.set('n', '<S-Up>', ':resize -2<CR>', { desc = 'Resize split up' })
vim.keymap.set('n', '<S-Down>', ':resize +2<CR>', { desc = 'Resize split down' })
vim.keymap.set('n', '<S-Left>', ':vertical resize -2<CR>', { desc = 'Resize split left' })
vim.keymap.set('n', '<S-Right>', ':vertical resize +2<CR>', { desc = 'Resize split right' })

-- Navigate also with arrows for Colemak D-H
vim.keymap.set('n', '<left>', 'h')
vim.keymap.set('n', '<down>', 'j')
vim.keymap.set('n', '<up>', 'k')
vim.keymap.set('n', '<right>', 'l')

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
--vim.keymap.set('n', '<C-i>', '<C-i>', opts) -- to restore jump forward
vim.keymap.set('n', '<leader>x', ':Bdelete!<CR>', { noremap = true, silent = true, desc = 'Close buffer' })
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', { noremap = true, silent = true, desc = 'New buffer' })

-- Increment/decrement numbers
vim.keymap.set('n', '<leader>+', '<C-a>', { noremap = true, silent = true, desc = 'Increment number' })
vim.keymap.set('n', '<leader>-', '<C-x>', { noremap = true, silent = true, desc = 'Decrement number' })

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', { noremap = true, silent = true, desc = 'Split vertically' })
vim.keymap.set('n', '<leader>h', '<C-w>s', { noremap = true, silent = true, desc = 'Split horizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { noremap = true, silent = true, desc = 'Equal splits' })
vim.keymap.set('n', '<leader>xs', ':close<CR>', { noremap = true, silent = true, desc = 'Close split' })

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- ── Jump list (moved off <C-o>/<C-i>) ────────────────────────────────────────
vim.keymap.set('n', '<leader>o', '<C-o>', { desc = 'Jump back', silent = true })
vim.keymap.set('n', '<leader>i', '<C-i>', { desc = 'Jump fwd', silent = true })

-- ── Colemak home-row split navigation (normal mode only) ────────────────────
-- left / down / up / right
vim.keymap.set('n', '<C-n>', '<C-w>h', { desc = 'Win left', silent = true })
vim.keymap.set('n', '<C-e>', '<C-w>j', { desc = 'Win down', silent = true })
vim.keymap.set('n', '<C-i>', '<C-w>k', { desc = 'Win up', silent = true })
vim.keymap.set('n', '<C-o>', '<C-w>l', { desc = 'Win right', silent = true })

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', { noremap = true, silent = true, desc = 'New tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { noremap = true, silent = true, desc = 'Close tab' })
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { noremap = true, silent = true, desc = 'Next tab' })
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { noremap = true, silent = true, desc = 'Previous tab' })

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', { noremap = true, silent = true, desc = 'Toggle line wrap' })

-- Press jk fast to exit insert mode
vim.keymap.set('i', 'jk', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)

-- Colemak-friendly fast exit insert mode (home row fingers)
vim.keymap.set('i', 'ne', '<ESC>', opts)
vim.keymap.set('i', 'en', '<ESC>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Move text up and down
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Replace word under cursor
vim.keymap.set('n', '<leader>j', '*``cgn', { noremap = true, silent = true, desc = 'Replace word under cursor' })

-- Explicitly yank to system clipboard (highlighted and entire row)
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank line to system clipboard' })

-- Toggle diagnostics
local diagnostics_active = true

vim.keymap.set('n', '<leader>do', function()
  diagnostics_active = not diagnostics_active

  if diagnostics_active then
    vim.diagnostic.enable(true)
  else
    vim.diagnostic.enable(false)
  end
end, { desc = 'Toggle diagnostics' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Save and load session
vim.keymap.set('n', '<leader>ss', ':mksession! .session.vim<CR>', { noremap = true, silent = false, desc = 'Save session' })
vim.keymap.set('n', '<leader>sl', ':source .session.vim<CR>', { noremap = true, silent = false, desc = 'Load session' })
