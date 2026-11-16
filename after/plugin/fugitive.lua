local function buf_name_os_agnostic(bufnr)
  return (vim.api.nvim_buf_get_name(bufnr):gsub("\\", "/"))
end

-- label fugitive buffers by what they represent (index, merge side, commit)
-- (used by lightline)
function _G.FugitiveBufLabel()
  local rev = buf_name_os_agnostic(0):match("^fugitive://.-//(%x+)")
  if not rev then return "" end
  local stages = { ["0"] = "INDEX", ["1"] = "BASE", ["2"] = "OURS", ["3"] = "THEIRS" }
  return stages[rev] or ("COMMIT " .. rev:sub(1, 7))
end


-- keymaps

vim.keymap.set("n", "<leader>gs", "<cmd>Gedit :<CR>")
vim.keymap.set("n", "<leader>gt", "<cmd>Gtabedit :<CR>")

vim.keymap.set("n", "<leader>gdh", "<cmd>Ghdiffsplit<CR>")
vim.keymap.set("n", "<leader>gdv", "<cmd>Gvdiffsplit<CR>")

-- NOTE using ':' instead of <cmd> is important for only applying to selected region
vim.keymap.set("x", "<leader>dp", ":diffput<CR>")
vim.keymap.set("x", "<leader>do", ":diffget<CR>")

-- fugitive adds `y<C-G>` for copying the filename / commit hash in a commit buffer
-- this adds easier mapping for copying to system clipboard
vim.keymap.set("n", "<leader>y<C-G>", "\"+y<C-G>", { remap = true })


-- autocommands

local group_fugitive = vim.api.nvim_create_augroup("user-fugitive", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group_fugitive,
  pattern = "fugitive",
  callback = function(ev)

    -- make diffsplits fullscreen and focus on index side
    local function open_diff(key)
      local status_win = vim.api.nvim_get_current_win()
      local initial_win_count = vim.fn.winnr('$')

      vim.cmd([[execute "normal \<Plug>fugitive:]]..key..[["]])

      if vim.fn.winnr('$') <= initial_win_count then return end

      -- close status window
      if vim.api.nvim_win_is_valid(status_win)
        and vim.api.nvim_win_get_buf(status_win) == ev.buf then
        vim.api.nvim_win_close(status_win, false)
      end

      -- select index window
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if buf_name_os_agnostic(vim.api.nvim_win_get_buf(win)):match("^fugitive://.*//0/") then
          vim.api.nvim_set_current_win(win)
          break
        end
      end
    end
    for _, key in ipairs({ "dv", "dh", "dd", "ds" }) do
      vim.keymap.set("n", key, function() open_diff(key) end, { buffer = ev.buf })
    end

    -- stage mappings

    -- TODO prevent s/u/- when there are a mix of staged and unstaged changes?
    -- TODO use `<` / `>` for opening / closing inline diffs?

    -- disable `-` for toggle staged/unstaged (right next to `=`, for inline diffs);
    -- use s/u/I instead (direction is also always deliberate)
    vim.keymap.set({ "n", "x" }, "-", "<Nop>", { buffer = ev.buf })

    -- stash mappings

    -- czz still stashes but ignores counts, czu for --include-untracked
    vim.keymap.set("n", "czz", "<cmd>Git stash push<CR>", { buffer = ev.buf })
    vim.keymap.set("n", "czu", "<cmd>Git stash push --include-untracked<CR>", { buffer = ev.buf })

    -- disable czP (flattens the stash's index AND loses the stash)
    vim.keymap.set("n", "czP", "<Nop>", { buffer = ev.buf })

    -- czp/cza restore the stash's index, and czA can lead to merge conflicts;
    -- refuse if something is already staged, to protect staged changes
    -- (can use manual `:Git stash` commands, but want to prevent mistakes with shortcuts)
    local function stash_restore(cmd, keep_index)
      if vim.fn.FugitiveExecute({ "diff", "--cached", "--quiet" }).exit_status == 1 then
        vim.notify("Index has staged changes; commit or unstage them first", vim.log.levels.WARN)
        return
      end
      local index_flag = keep_index and "--index" or ""
      vim.cmd(("Git stash %s --quiet %s stash@{%d}"):format(cmd, index_flag, vim.v.count))
    end
    vim.keymap.set("n", "czp", function() stash_restore("pop", true) end, { buffer = ev.buf })
    vim.keymap.set("n", "cza", function() stash_restore("apply", true) end, { buffer = ev.buf })
    vim.keymap.set("n", "czA", function() stash_restore("apply", false) end, { buffer = ev.buf })
  end
})

-- don't trim whitespace for index buffers (fugitive fires BufWritePre before staging)
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group_fugitive,
  pattern = "fugitive://*",
  callback = function(ev)
    vim.b[ev.buf].trim_whitespace = false
  end
})

