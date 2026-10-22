-- init.lua — Neovim 0.12
-- Uses native vim.pack, vim.lsp.enable(), built-in autocomplete

vim.g.mapleader = ' '

-- 1. Plugins (vim.pack)
vim.pack.add({
  -- Theme
  'https://github.com/craftzdog/solarized-osaka.nvim',
  -- Git
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/lewis6991/gitsigns.nvim',
  -- FZF
  'https://github.com/junegunn/fzf',
  'https://github.com/junegunn/fzf.vim',
  -- LSP configs (provides lsp/*.lua definitions for common servers)
  'https://github.com/neovim/nvim-lspconfig',
  -- Treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  -- Utilities
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/stevearc/oil.nvim',
}, { confirm = not vim.g.dotfiles_bootstrap })

-- 2. Basic settings
vim.o.termguicolors = true
vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.clipboard = 'unnamedplus'

-- 3. Colorscheme
vim.o.background = 'dark'
pcall(function()
  require('solarized-osaka').setup({})
  vim.cmd('colorscheme solarized-osaka')
end)

-- 4. Built-in autocomplete (replaces nvim-cmp)
--    'autocomplete' (boolean) makes the popup appear automatically in insert mode.
--    Adding 'o' to 'complete' includes omnifunc (LSP) as a completion source.
--    Adding 'F' includes other function-based sources.
vim.o.completeopt = 'menuone,noselect,fuzzy,popup'
vim.o.complete = vim.o.complete .. ',o,F'
vim.o.autocomplete = true

-- Confirm completion with <CR>, navigate with <C-n>/<C-p>
vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  end
  return '<CR>'
end, { expr = true })

-- 5. Treesitter
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'python', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'markdown' },
  callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
})

-- 6. LSP (native 0.12 approach)
--    nvim-lspconfig provides the config definitions in its lsp/ directory.
--    vim.lsp.enable() discovers and activates them by name.
vim.lsp.enable({ 'lua_ls', 'ts_ls', 'oxlint', 'oxfmt', 'tailwindcss' })

-- Common keymaps on LSP attach (grn, gra, grr, gri, gO, K, CTRL-S are defaults)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- 7. Plugin setup calls
pcall(function() require('gitsigns').setup() end)
pcall(function() require('Comment').setup() end)
pcall(function() require('oil').setup() end)

-- 8. Keymaps

-- Oil file browser
vim.keymap.set('n', '-', '<CMD>Oil<CR>')

-- FZF
vim.keymap.set('n', '<leader>p', ':Files<CR>')
vim.keymap.set('n', '<leader>g', ':Rg<CR>')
vim.keymap.set('n', '<leader>b', ':Buffers<CR>')

-- Optional private project or machine settings, outside the tracked config.
local local_config = vim.fn.stdpath('config') .. '/local.lua'
if vim.fn.filereadable(local_config) == 1 then dofile(local_config) end
