-- NOTE FileType <-> treesitter parser mappings aren't always 1:1
local parsers = {
  'query', 'c', 'cpp', 'lua', 'rust', 'go', 'vim',
  {
    ft = { 'bash', 'sh', 'zsh' },
    ts = { 'bash' }, -- TODO use 'zsh' parser for 'zsh' ft?
  },
  {
    ft = { 'help' },
    ts = { 'vimdoc' },
  },
  {
    ft = { 'markdown' },
    ts = { 'markdown', 'markdown_inline' },
  },
}
-- TODO make bash/zsh OS-specific additions?

-- install parsers
require('nvim-treesitter').install(
  vim.iter(parsers)
    :map(function(item) return type(item) == 'table' and item.ts or { item } end)
    :flatten()
    :totable()
)

-- create filetype->parser mappings
-- NOTE nvim/nvim-treesitter already seems to do a pretty good job of this,
-- but leaving here to keep mappings explicit
for _, item in pairs(parsers) do
  if type(item) == 'table' then
    -- NOTE even for cases where there are multiple parsers, only map first one in entry array
    vim.treesitter.language.register(item.ts[1], item.ft)
  end
end

local group_ts = vim.api.nvim_create_augroup('user-treesitter', { clear = true })

-- enable highlighting for relevant filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = group_ts,
  pattern = vim.iter(parsers)
    :map(function(item) return type(item) == 'table' and item.ft or { item } end)
    :flatten()
    :totable(),
  callback = function() vim.treesitter.start() end,
})

-- NOTE use `:h mapmode-x` or `:h mapmode-o` to get more info about mode abbreviations
vim.keymap.set({ 'x', 'o' }, 'uc', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@comment.outer', 'textobjects')
end, { desc = 'Select outer comment' })
