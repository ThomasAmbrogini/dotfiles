return {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- See `:help telescope.builtin`

        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = '[L]ive [G]rep' })

    end,
}

