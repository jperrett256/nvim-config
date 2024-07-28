vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- TODO not sure which I prefer yet
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>rw", vim.cmd.Ex)

-- clearing highlighting after search
local function clear_hl()
  vim.cmd("nohl")
end

vim.keymap.set("n", "<Esc>", clear_hl)
vim.keymap.set("n", "<C-c>", clear_hl)

-- allow using <C-C> to exit visual block multi-line editing
vim.keymap.set("i", "<C-c>", "<Esc>")

-- move visual block and indent (and keep selection after)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- allows merging lines without changing cursor position
vim.keymap.set("n", "J", "mzJ`z")

-- scroll half page down/up while keeping cursor vertically centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keeps cursor vertically centered during searching
-- (TODO zv seems to relate to folding, whatever that is)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste in visual mode without overwriting paste data with replaced text
vim.keymap.set("x", "<leader>p", "\"_dp")
-- NOTE needed/helpful when pasting entire lines (although V"0p may be a useful alternative)
vim.keymap.set("x", "<leader>P", "\"_dP")

-- utilities: yank to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>yy", "\"+yy")
vim.keymap.set("n", "<leader>Y", "\"+Y")
-- prevents space (our leader key) affecting size of visual selection
vim.keymap.set("v", " ", "")

-- TODO not sure if needed yet
-- vim.keymap.set("n", "Q", "<nop>")

-- QuickFix
-- TODO add something for :cfirst/crewind? Maybe :crewind followed by :cfirst?
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-p>", "<cmd>cprev<CR>zz")
-- TODO not sure I understand lnext/lprev
vim.keymap.set("n", "<leader>n", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>p", "<cmd>lprev<CR>zz")

-- replace all instances of the word under the cursor
-- (TODO not totally sure how, but CTRL-R CTRL-W gets the word under the cursor)
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- make current file executable (Unix only)
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- make leaving terminal mode easier
-- NOTE use :terminal to create a new terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

