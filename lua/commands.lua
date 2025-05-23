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

vim.api.nvim_create_user_command(
  'OSExplore',
  function(opts)
    -- TODO like the telescope utility function, this doesn't work perfectly for directories open in netrw sometimes
    -- TODO use vim.b.netrw_curdir when netrw is being used?
    local buffer_base_path = "%:p:h"

    if vim.fn.has("win32") == 1 then
      vim.cmd("silent !start \"\" \""..buffer_base_path.."\"")
    elseif vim.fn.has("mac") == 1 then -- TODO supposedly unreliable method for detecting OS is MacOS (should use uname)
      vim.cmd("silent !open \""..buffer_base_path.."\"")
    end
    -- TODO linux support? (nautilus)
  end,
  {}
)

vim.api.nvim_create_user_command(
  'ShadaClear',
  function(opts)
    -- NOTE tried using :wshada!, but did not remove all files, so adding this command instead

    -- checked, appears to be standard location for both windows and unix
    local paths = vim.fn.split(vim.fn.glob(vim.fn.stdpath('state')..'/shada/*'), '\n')
    for _, file in pairs(paths) do
      if not string.find(file, ".shada") then
        error("Unexpected file in shada directory: \""..file.."\"")
      end
      print(file)
      if os.remove(file) == nil then
        error("Failed to remove shada file: \""..file.."\"")
      end
    end
  end,
  {} -- NOTE nargs = 0 is the default
)

