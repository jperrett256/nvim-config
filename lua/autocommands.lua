-- File Specific Settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = {"lua", "json", "dosbatch"},
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
  end
})

-- trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- NOTE two trailing spaces in markdown is considered a line break,
    -- but I have no intention of making use of this feature.
    -- if vim.bo.filetype == "markdown" then return end
    vim.cmd("%s/\\s\\+$//e")
  end,
  desc = "Trim Trailing Whitespace"
})

-- from: https://github.com/Alexis12119/nvim-config/blob/main/lua/core/autocommands.lua
-- TODO not sure what autocmd groups are for
local general = vim.api.nvim_create_augroup("General", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern="*",
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
  group = general,
  desc = "Disable New Line Comment",
})

