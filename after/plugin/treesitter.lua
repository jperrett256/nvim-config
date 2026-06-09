local parsers = { 'c', 'cpp', 'lua', 'rust', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' }

require('nvim-treesitter').install(parsers)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'lua', 'rust', 'vim', 'help', 'query', 'markdown' },
  callback = function() vim.treesitter.start() end,
})

-- NOTE use `:h mapmode-x` or `:h mapmode-o` to get more info about mode abbreviations
vim.keymap.set({ 'x', 'o' }, 'uc', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@comment.outer', 'textobjects')
end, { desc = 'Select outer comment' })
