local group_general = vim.api.nvim_create_augroup("General", { clear = true })

-- File Specific Settings
vim.api.nvim_create_autocmd("FileType", {
  group = group_general,
  pattern = {"lua", "json", "dosbatch", "sh", "zsh"},
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = group_general,
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
  end
})

-- trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group_general,
  pattern = "*",
  callback = function()
    -- NOTE two trailing spaces in markdown is considered a line break,
    -- but I have no intention of making use of this feature.
    -- if vim.bo.filetype == "markdown" then return end

    -- can disable for specific buffers (nil/unset = should trim)
    if vim.b.trim_whitespace == false then return end

    -- apply trim, preserving search history and cursor position
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
  desc = "Trim Trailing Whitespace"
})

-- from: https://github.com/Alexis12119/nvim-config/blob/main/lua/core/autocommands.lua
vim.api.nvim_create_autocmd("BufEnter", {
  group = group_general,
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

