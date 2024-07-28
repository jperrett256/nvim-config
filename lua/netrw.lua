-- hides the banner (can still get help at any time with <F1>)
vim.g.netrw_banner = 0

-- prevents netrw from appearing in the buffer list when hidden
-- local netrw = vim.api.nvim_create_augroup("netrw", {})
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "netrw",
--   group = netrw,
--   callback = function()
--     vim.opt_local.bufhidden = 'wipe'
--   end
-- })

