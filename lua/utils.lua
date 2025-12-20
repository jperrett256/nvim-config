function GotoFile(file, line, col)
  vim.cmd("tabedit "..file)
  vim.fn.cursor(line, col)
end

user_functions = {}

-- like telescope.utils.buffer_dir(), but also works
-- (consistently) with directories open in netrw
function user_functions.get_buffer_dir()
  local buffer_base_path
  if vim.bo.filetype == "netrw" then
    buffer_base_path = vim.b.netrw_curdir
  else
    buffer_base_path = vim.fn.expand("%:p:h")
  end
  return buffer_base_path
end

