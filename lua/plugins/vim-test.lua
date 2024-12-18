return {
    "vim-test/vim-test",
    dependencies = {
        "preservim/vimux"
    },
    config = function()
        -- Define key mappings for vim-test commands
        local map = function(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.silent = opts.silent ~= false
            vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
        end

        -- Mappings for vim-test
        map('n', '<leader>tn', ':TestNearest<CR>', { silent = true }) -- Run the nearest test
        map('n', '<leader>tf', ':TestFile<CR>', { silent = true })    -- Run tests in the current file
        map('n', '<leader>ts', ':TestSuite<CR>', { silent = true })   -- Run the entire test suite
        map('n', '<leader>tl', ':TestLast<CR>', { silent = true })    -- Re-run the last test
        map('n', '<leader>tv', ':TestVisit<CR>', { silent = true })   -- Visit the test file

        vim.cmd("let test#strategy = 'vimux'")
    end,
}
