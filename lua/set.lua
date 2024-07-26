-- vim.opt.guicursor = "" -- makes insert cursor fat

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- TODO I think this only applies to swapfiles (which we've disabled)?
vim.opt.updatetime = 50

-- vim.opt.hlsearch = false
-- vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

-- no idea what these are
-- vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")

-- vim.opt.colorcolumn = "80"

-- NOTE vim.opt.backspace is set to "indent,eol,start" by default

-- horizontal and vertical splits place focus in the right/bottom window instead
vim.opt.splitright = true
vim.opt.splitbelow = true

