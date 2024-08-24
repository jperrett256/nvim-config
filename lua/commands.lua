local function get_nvim_server()
  local env_name = "NVIM_SERVER_ADDRESS"
  local server_addr = os.getenv(env_name)
  if server_addr == nil then
    error("Attempted to read from unset environment variable: \"" .. env_name .. "\"")
  end
  return server_addr
end

vim.api.nvim_create_user_command('ServerStart', function()
  local server_addr = get_nvim_server()
  vim.fn.serverstart(server_addr)
end, { desc = "Start the neovim server." })

vim.api.nvim_create_user_command('ServerStop', function()
  local server_addr = get_nvim_server()
  vim.fn.serverstop(server_addr)
end, { desc = "Stop the neovim server." })

-- NOTE command with args (for future reference)
-- vim.api.nvim_create_user_command('CommandName',
-- function (opts)
--   print(#opts.fargs)
--   print(opts.fargs)
-- end,
-- { nargs = '*' })

vim.api.nvim_create_user_command('ConfigExplore', function()
  vim.cmd("Ex " .. vim.fn.stdpath("config"))
end, { desc = "Open the user configuration directory with Netrw." })

