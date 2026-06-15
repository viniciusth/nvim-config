-- Reserve a space in the opt set
local opts = { noremap = true, silent = true }

-- Keybindings are set via a native LspAttach autocmd so they fire for *every*
-- LSP client, including servers configured outside mason-lspconfig (e.g. zls,
-- solargraph). A per-server on_attach silently skips those, which previously
-- broke `gd` and friends for ZLS/rust-analyzer/etc.
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        if not client then return end
        local bufopts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, bufopts)
        vim.keymap.set("n", "gv", function()
            vim.cmd('vs')
            vim.lsp.buf.definition()
        end, bufopts)
        vim.keymap.set("n", "gs", function()
            vim.cmd('sp')
            vim.lsp.buf.definition()
        end, bufopts)

        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, bufopts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, bufopts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, bufopts)
        vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, bufopts)

        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, bufopts)
        vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, bufopts)
        vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, bufopts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, bufopts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, bufopts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", function() vim.lsp.buf.code_action() end, bufopts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, bufopts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, bufopts)

        vim.keymap.set("n", "<leader>fc", function()
            require("lsp-format-modifications").format_modifications(client, bufnr)
        end, bufopts)

        vim.g.inlay_hints_visible = false
        vim.keymap.set("n", "<leader>ih", function()
            if vim.g.inlay_hints_visible then
                vim.g.inlay_hints_visible = false
                vim.lsp.inlay_hint.enable(false)
            else
                if client.server_capabilities.inlayHintProvider then
                    vim.g.inlay_hints_visible = true
                    vim.lsp.inlay_hint.enable(true)
                else
                    print("no inlay hints available")
                end
            end
        end, bufopts)
    end,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'rust_analyzer',
        'pyright',
        'typos_lsp',
        'ts_ls',
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({
                capabilities = capabilities,
            })
        end,
        typos_lsp = function()
            require('lspconfig').typos_lsp.setup({
                capabilities = capabilities,
                init_options = {
                    diagnosticSeverity = "Information",
                    logLevel = "Information",
                }
            })
        end,
        ts_ls = function()
            require('lspconfig').ts_ls.setup({
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false

                    require("twoslash-queries").attach(client, bufnr)
                    vim.api.nvim_set_keymap('n', "<leader>K", "<cmd>TwoslashQueriesInspect<CR>", {})

                    if client.server_capabilities.workspace then
                        client.server_capabilities.workspace.fileOperations = nil
                    end
                end,
                capabilities = capabilities,
                init_options = {
                    maxTsServerMemory = 8192,
                    preferences = {
                        disableAutomaticTypingAcquisition = true,
                    },
                    watchOptions = {
                        watchFile = "useFsEvents",
                        watchDirectory = "useFsEvents",
                        fallbackPolling = "dynamicPriority",
                        synchronousWatchDirectory = true,
                        excludeDirectories = { "**/node_modules", "**/.git", "**/dist", "**/build" },
                    },
                },
                cmd = { "node", "--max-old-space-size=8192", vim.fn.exepath("typescript-language-server"), "--stdio" },
                flags = {
                    debounce_text_changes = 300,
                    allow_incremental_sync = true,
                },
            })
        end,
    },
})

-- Servers installed outside mason are set up manually. Keymaps still attach via
-- the LspAttach autocmd above, so go-to-definition etc. work here too.
require('lspconfig').solargraph.setup({
    capabilities = capabilities,
})

require('lspconfig').zls.setup({
    capabilities = capabilities,
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer', keyword_length = 3 },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
    }),
    completion = {
        completeopt = 'menu,menuone,noinsert',
    },
    preselect = cmp.PreselectMode.Item,
})

vim.diagnostic.config({
    virtual_text = true,
    float = {
        border = "single",
    },
})
