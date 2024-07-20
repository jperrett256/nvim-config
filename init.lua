require("set")
require("autocommands")
require("remap")

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
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- print(vim.fn.stdpath("config") .. "/init.lua" .. " loaded successfully!") -- DEBUG

