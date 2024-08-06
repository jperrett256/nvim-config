require("set")
require("autocommands")
require("remap")
require("netrw")

if vim.g.neovide then
  if vim.fn.has("win32") == 1 then
    vim.o.guifont = "Cascadia Mono:h11"
  end
  vim.g.neovide_scroll_animation_length = 0.05
  -- vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0.3
  vim.g.neovide_cursor_animate_command_line = false
end

-- TODO should maybe consider using the structure suggested by lazy.nvim
-- (as opposed to using after/), might make execution ordering a little
-- bit easier to handle (not a big issue yet).

require("lazy-bootstrap")
require("lazy").setup({
  spec = {
    {
      'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = {'nvim-lua/plenary.nvim'}
    },
    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    {'ThePrimeagen/harpoon', dependencies = {'nvim-lua/plenary.nvim'}},
    {'mbbill/undotree' },
    {'tpope/vim-fugitive' },
    -- {
    --   "tyrannicaltoucan/vim-quantum",
    --   config = function()
    --     -- NOTE vim.opt.background is 'dark' by default
    --     vim.g.quantum_black=1
    --     vim.cmd("colorscheme quantum")
    --   end
    -- },
    {
      "rose-pine/neovim", name = "rose-pine",
      config = function()
        local palette = require("rose-pine.palette")

        require("rose-pine").setup({
          styles = {
            -- NOTE some terminals (e.g. cmd.exe) can't render bold/italics anyway,
            -- but I am not interested even if they are available.
            bold = false,
            italic = false,
          },
          highlight_groups = {
            -- NOTE there doesn't seem to be a way to tell rose-pine to do nothing with
            -- a highlight group already included in the internal defaults (which is why
            -- we still have to link LineNr if we want it linked, even though the
            -- treesitter-context plugin already did this)

            -- NOTE inherit indicates if the fields left unspecified should be filled with
            -- those from the internal default

            -- version 1: subtle highlighting (optionally with border)
            -- TreesitterContext = { inherit = false, link = "Normal" },
            -- -- TreesitterContextLineNumber = { inherit = false, link = "LineNr" },
            -- TreesitterContextLineNumber = { inherit = false, fg = "White" },
            -- TreesitterContextBottom = { underline = true, sp = palette.subtle },
            -- TreesitterContextLineNumberBottom = { underline = true, sp = palette.subtle },

            -- version 2: keep different bg color, but change line number colors
            -- TreesitterContextLineNumber = { fg = 'White' },
            -- TreesitterContextLineNumber = { fg = palette.text },
            TreesitterContextLineNumber = { fg = palette.subtle },
          }
        })
        vim.cmd("colorscheme rose-pine")
      end
    },
    {
      'itchyny/lightline.vim',
      opts = {},
      config = function()
        vim.g.lightline = {
          ['colorscheme'] = 'rosepine'
          -- ['colorscheme'] = 'one'
        }
        vim.opt.laststatus = 3
        -- NOTE vim.opt.background is 'dark' by default
      end
    },
    -- TODO not sure I really need this - will see
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      }
    },
    {'tpope/vim-surround'},
    {
      'numToStr/Comment.nvim',
      opts = {}
    },
    -- used to define comment text objects for easy block uncommenting (with Comment.nvim)
    {'nvim-treesitter/nvim-treesitter-textobjects'},
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        max_lines = 2,
        trim_scope = 'inner',
      }
    },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    {
      'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
      dependencies = {
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},
        {'neovim/nvim-lspconfig'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/nvim-cmp'},
        {'L3MON4D3/LuaSnip'},
      }
    },
    {'ThePrimeagen/vim-be-good'}, -- NOTE misc plugin for learning vim
  },
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "rosepine" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

