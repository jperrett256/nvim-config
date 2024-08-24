function GotoFile(file, line, col)
  vim.cmd("tabedit " .. file)
  vim.fn.cursor(line, col)
end

