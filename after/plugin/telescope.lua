local actions = require('telescope.actions')

-- TODO what I *want* is to get <C-p> and <C-n> working again,
-- after which I do not need to map <Tab>/<S-Tab> (temporary)

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<C-p>"] = actions.move_selection_previous, -- TODO not working?
        ["<C-n>"] = actions.move_selection_next, -- TODO not working?
        ["<Tab>"] = actions.move_selection_previous,
        ["<S-Tab>"] = actions.move_selection_next,
      },
      n = {
        ["<C-p>"] = actions.move_selection_previous, -- TODO not working?
        ["<C-n>"] = actions.move_selection_next, -- TODO not working?
        ["<Tab>"] = actions.move_selection_previous,
        ["<S-Tab>"] = actions.move_selection_next,
      }
    }
  },
  pickers = {
    find_files = {
      mappings = {}
    }
  }
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})

-- NOTE I could only imagine this would be useful if you don't want to respect .gitignore files
-- vim.keymap.set('n', '<leader>ps', function()
--     builtin.grep_string({ search = vim.fn.input("grep > ") })
-- end)

