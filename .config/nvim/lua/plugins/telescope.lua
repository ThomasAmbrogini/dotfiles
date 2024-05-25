return {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.6',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- See `:help telescope.builtin`
         
        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })

    end,
}

