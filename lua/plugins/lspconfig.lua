return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x',
        lazy = true,
        config = false,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true }) -- Accept currently selected item
                        else
                            cmp.complete() -- Trigger completion menu
                        end
                    end, { 'i', 's' }),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                }),
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')

            -- lsp_attach is where you enable features that only work
            -- if there is a language server active in the file
            local lsp_attach = function(client, bufnr)
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "<leader>gf", function() require('telescope.builtin').lsp_references() end, opts)
                vim.keymap.set("n", "<leader>gi", function() vim.lsp.buf.implementation() end, opts)
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            end

            lsp_zero.extend_lspconfig({
                sign_text = true,
                lsp_attach = lsp_attach,
                capabilities = require('cmp_nvim_lsp').default_capabilities()
            })
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls', 'ts_ls', 'rust_analyzer', 'gopls'},
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        if server_name == 'rust_analyzer' then
                            require('lspconfig')[server_name].setup({
                                settings = {
                                    ["rust-analyzer"] = {
                                        cargo = {
                                            allFeatures = true,
                                        },
                                        procMacro = {
                                            enable = true,
                                        },
                                        rustfmt = {
                                            enable = true, -- Use rustfmt for formatting
                                        },
                                    },
                                },
                                on_attach = function(client, bufnr)
                                    client.server_capabilities.documentFormattingProvider = true
                                    local opts = { buffer = bufnr }
                                    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format() end, opts)
                                end,
                            })
                        elseif server_name == 'ts_ls' then
                            require('lspconfig')[server_name].setup({
                                on_attach = function(client, bufnr)
                                    -- TypeScript formatting settings
                                    client.server_capabilities.documentFormattingProvider = true
                                    local opts = { buffer = bufnr }
                                    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format() end, opts)
                                end,
                            })
                        elseif server_name == 'gopls' then
                            require('lspconfig')[server_name].setup({
                                on_attach = function(client, bufnr)
                                    -- Go formatting settings
                                    client.server_capabilities.documentFormattingProvider = true
                                    local opts = { buffer = bufnr }
                                    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format() end, opts)
                                end,
                            })
                        else
                            require('lspconfig')[server_name].setup({})
                        end
                    end,
                },
            })
            -- These are just examples. Replace them with the language
            -- servers you have installed in your system
            -- require('lspconfig').tsserver.setup({})  -- JavaScript/TypeScript
            -- require('lspconfig').gopls.setup({})     -- Golang
            -- require('lspconfig').rust_analyzer.setup({})  -- Rust
            -- require('lspconfig').gleam.setup({})
            -- require('lspconfig').ocamllsp.setup({})
        end
    }
}
