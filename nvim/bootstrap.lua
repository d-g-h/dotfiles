-- Install parsers synchronously so bootstrap failures have a nonzero exit code.
local ok, err = pcall(function()
  assert(vim.v.errmsg == '', vim.v.errmsg)
  require('nvim-treesitter').install({
    'lua', 'python', 'javascript', 'typescript', 'tsx', 'markdown', 'markdown_inline',
  }):wait(300000)
  for _, lang in ipairs({ 'lua', 'python', 'javascript', 'typescript', 'tsx', 'markdown', 'markdown_inline' }) do
    assert(pcall(vim.treesitter.language.add, lang), 'Missing Treesitter parser: ' .. lang)
  end
end)
if not ok then
  vim.api.nvim_err_writeln(tostring(err))
  vim.cmd('cquit 1')
end
