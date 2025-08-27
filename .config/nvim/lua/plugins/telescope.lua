return {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- See `:help telescope.builtin`

        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = '[L]ive [G]rep' })
        vim.keymap.set('n', '<leader>lb', builtin.buffers, { desc = 'Telescope buffers' })

        require("telescope").setup{
            defaults = {
                layout_strategy = "vertical",
                layout_config = {
                    vertical = {
                        width = 0.99,
                        height = 0.99,
                    },
                },
                vimgrep_arguments = {
                   "rg",
                   "--color=never",
                   "--no-heading",
                   "--with-filename",
                   "--line-number",
                   "--column",
                   "--smart-case",
                   "--no-ignore-vcs",  -- Search inside .gitignore files
               },
               find_command = {
                   'fd',
                   '--type',
                   'f',
                   '--no-ignore-vcs',
                   '--hidden',
                   '--follow'
               },

            },
        }

    end,
}

