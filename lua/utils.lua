local M = {}

function M.goto_file(file, line, col)
  vim.cmd("tabedit "..vim.fn.fnameescape(file))
  vim.fn.cursor(line, col)
end

-- like telescope.utils.buffer_dir(), but also works
-- (consistently) with directories open in netrw
function M.get_buffer_dir()
  local buffer_base_path
  if vim.bo.filetype == "netrw" then
    buffer_base_path = vim.b.netrw_curdir
  else
    buffer_base_path = vim.fn.expand("%:p:h")
  end
  return buffer_base_path
end

return M

