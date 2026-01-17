return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local previewers = require('telescope.previewers')

    telescope.setup({
      defaults = {
        -- Use Telescope's BUILT-IN treesitter previewer (safe)
        buffer_previewer_maker = previewers.buffer_previewer_maker,
        
        layout_strategy = "horizontal",
        layout_config = { height = 0.95, width = 0.95 },
      },
    })

    -- Your keymaps (unchanged)
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
  end,
}
