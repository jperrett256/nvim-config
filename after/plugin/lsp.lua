local lsp_zero = require('lsp-zero')

-- lsp.preset("recommended")

lsp_zero.on_attach(function(client, bufnr)
  -- NOTE setting mappings explicitly, for ease of checking and modification
  -- lsp_zero.default_keymaps({
  --   buffer = bufnr,
  --   -- preserve_mappings = false,
  --   -- exclude = { 'gl', 'K' }
  -- })
  local opts = {buffer = bufnr} -- NOTE remap = false by default (remap is not recursive)

  vim.keymap.set('n', 'K', function () vim.lsp.buf.hover() end, opts)
  vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end, opts)
  vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
  vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({async = true}) end, opts)
  vim.keymap.set('n', '<F4>', function() vim.lsp.buf.code_action() end, opts)

  vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)

  -- TODO should see which of these mappings from ThePrimeagen I like
  -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

vim.api.nvim_create_user_command(
  'LspFormat',
  function(opts)
    vim.lsp.buf.format()
  end,
  {} -- NOTE nargs = 0 is the default
)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- add the language servers you want to install
  -- helpful list available at: https://github.com/williamboman/mason-lspconfig.nvim
  -- NOTE no luck with biome on Windows, so using jsonls at the moment
  ensure_installed = { 'rust_analyzer', 'lua_ls', 'tsserver', 'clangd', 'zls', 'jsonls' },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
    -- not sure if needed:
    -- ["rust_analyzer"] = function ()
    --   require("rust-tools").setup({})
    -- end,
    ["lua_ls"] = function ()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      })
    end,
  }
})

-- lsp_zero.set_sign_icons({})
vim.diagnostic.config({
  signs = false
})

local cmp = require('cmp')
cmp.setup({
  sources = {
     {
       name = 'nvim_lsp',
       -- disable Text autocompletes for Lua
       entry_filter = function(entry, ctx)
         return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
       end
     },
  },
  -- NOTE <C-Space> does not seem to work properly (at least on Windows)
  mapping = cmp.mapping.preset.insert({
    -- NOTE {select = true} means will default to first option if none selected
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<C-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
   }),
   snippet = {
     expand = function(args)
       require('luasnip').lsp_expand(args.body)
     end,
   },
   enabled = function()
     -- keep command mode completion enabled when cursor is in a comment
     -- (means pressing TAB in command mode will still list possible completions)
     if vim.api.nvim_get_mode().mode == 'c' then return true end

     -- disable autocompletion in prompt
     -- (was preventing <C-p>/<C-n> mappings from working in telescope)
     local buftype = vim.api.nvim_buf_get_option(0, "buftype")
     if buftype == "prompt" then return false end

     local context = require 'cmp.config.context'

     -- disable completion in comments
     return not context.in_treesitter_capture("comment")
       and not context.in_syntax_group("Comment")
   end
})

local ls = require("luasnip")

-- vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = false})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = false})

-- vim.keymap.set({"i", "s"}, "<C-E>", function()
--   if ls.choice_active() then
--     ls.change_choice(1)
--   end
-- end, {silent = true})

