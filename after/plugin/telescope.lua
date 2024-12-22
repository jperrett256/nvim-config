local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})

local utils = require('telescope.utils')

vim.keymap.set('n', '<leader>fdf', function ()
  builtin.find_files({ cwd = utils.buffer_dir() })
end, {})

vim.keymap.set('n', '<leader>fds', function ()
  builtin.live_grep({ cwd = utils.buffer_dir() })
end, {})

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        -- NOTE still not sure when to use actions.move_selection_worse/better
        -- over actions.move_selection_previous/next
        ["<Tab>"] = actions.toggle_selection,
        ["<S-Tab>"] = actions.nop,
      },
      n = {
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,

        ["<Tab>"] = actions.toggle_selection,
        ["<S-Tab>"] = actions.nop,

        ["<Esc>"] = actions.nop,
        ["<C-c>"] = actions.close,
      }
    }
  }
})

