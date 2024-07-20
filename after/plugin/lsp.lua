local lsp_zero = require('lsp-zero')

-- lsp.preset("recommended")

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({
    buffer = bufnr,
    -- preserve_mappings = false,
    -- exclude = { 'gl', 'K' }
  })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- add the language servers you want to install
  -- helpful list available at: https://github.com/williamboman/mason-lspconfig.nvim
  ensure_installed = { 'rust_analyzer', 'lua_ls', 'tsserver', 'clangd', 'zls' },
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
     -- disable completion in comments
     local context = require 'cmp.config.context'
     -- keep command mode completion enabled when cursor is in a comment
     -- NOTE means pressing TAB in command mode will still list possible completions
     if vim.api.nvim_get_mode().mode == 'c' then
       return true
     else
       return not context.in_treesitter_capture("comment")
        and not context.in_syntax_group("Comment")
     end
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

