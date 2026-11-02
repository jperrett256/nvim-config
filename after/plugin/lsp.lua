vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local bufnr = event.buf
    local opts = {buffer = bufnr} -- NOTE remap = false by default (remap is not recursive)

    -- NOTE ctrl-x + ctrl-o triggers code completion in insert mode
    -- NOTE ctrl-s displays type signature under cursor

    -- TODO gq vs = for format selected text

    vim.keymap.set('n', 'K', function () vim.lsp.buf.hover() end, opts)
    -- NOTE default is ctrl-]
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
    -- TODO default is gri
    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
    -- TODO default is grt
    vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end, opts)
    -- TODO default is grr
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)

    -- TODO what is Select mode ('s')
    -- TODO ctrl-s in insert mode already does this?
    vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end, opts)
    -- TODO is this grn by default?
    vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end, opts)
    -- TODO why do I have this keymap, what does async mean
    vim.keymap.set({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({async = true}) end, opts)
    -- TODO is this gra by default?
    vim.keymap.set('n', '<F4>', function() vim.lsp.buf.code_action() end, opts)

    -- TODO what does gO do? list all symbols? vim.lsp.buf.document_symbol()?

    -- TODO what is this
    vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float() end, opts)

    -- TODO apparently ctrl-w + d shows error/warning on line under cursor
    vim.keymap.set('n', '[d', function()
      vim.diagnostic.jump({ count=-1, float=true })
    end, opts)
    vim.keymap.set('n', ']d', function()
      vim.diagnostic.jump({ count=1, float=true })
    end, opts)
    vim.keymap.set('n', '[e', function()
      vim.diagnostic.jump({
        count=-1,
        float=true,
        severity = { min = vim.diagnostic.severity.ERROR }
      })
    end, opts)
    vim.keymap.set('n', ']e', function()
      vim.diagnostic.jump({
        count=1,
        float=true,
        severity = { min = vim.diagnostic.severity.ERROR }
      })
    end, opts)
  end,
})

vim.api.nvim_create_user_command(
  'LspFormat',
  function(opts)
    vim.lsp.buf.format()
  end,
  {} -- NOTE nargs = 0 is the default
)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- helpful list available at: https://github.com/williamboman/mason-lspconfig.nvim
  -- NOTE no luck with biome on Windows, so using jsonls at the moment
  ensure_installed = { 'rust_analyzer', 'lua_ls', 'ts_ls', 'clangd', 'zls', 'jsonls', 'gopls', 'basedpyright' },
})


-- NOTE see: https://github.com/neovim/nvim-lspconfig
-- TODO can put these in a special directory I think? lsp/ or after/lsp/?
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    -- NOTE this prevents clangd from inserting headers automatically
    -- 1. often inserts the originating header file, even if already transitively included
    -- 2. for cpp files, will include cpp headers where the c headers might be preferred
    -- (whether these behaviours are desired depends on context, would rather handle manually)
    "--header-insertion=never",
  }
})

local type_diagnostic_severity = "none"
-- local type_diagnostic_severity = "information"
vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportUnknownParameterType = type_diagnostic_severity,
          reportMissingParameterType = type_diagnostic_severity,
          reportUnknownArgumentType = type_diagnostic_severity,
          reportUnknownVariableType = type_diagnostic_severity,
          reportUnknownLambdaType = type_diagnostic_severity,
          reportUnknownMemberType = type_diagnostic_severity,
          reportUnusedCallResult = type_diagnostic_severity,
          reportAny = type_diagnostic_severity,
        }
      }
    }
  }
})


-- TODO what is this again?
vim.diagnostic.config({
  signs = false
})

local cmp = require('cmp')
cmp.setup({
  -- NOTE some LSPs (like gopls) will suggest autocompletes to preselect - disable this
  preselect = cmp.PreselectMode.None,
  sources = {
     {
       name = 'nvim_lsp',
       -- disable Text autocompletes for Lua
       entry_filter = function(entry, ctx)
         return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
       end
     },
     { name = 'luasnip' },
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

-- NOTE expand binding is strictly unnecessary now that luasnip snippets appear
-- in autocomplete suggestions (but leaving here in case it ends up being convenient)
vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = false})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = false})

-- TODO haven't encountered snippets with choice nodes yet, should probably uncomment?
-- vim.keymap.set({"i", "s"}, "<C-E>", function()
--   if ls.choice_active() then
--     ls.change_choice(1)
--   end
-- end, {silent = true})

