local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")
local lsp_format_modifications = require("lsp-format-modifications")

lsp.preset("recommended")

lsp.ensure_installed({
    'rust_analyzer',
    'pyright',
    'typos_lsp',
    'vtsls',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gv", function()
        vim.cmd('vs')
        vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "gs", function()
        vim.cmd('sp')
        vim.lsp.buf.definition()
    end, opts)

    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    vim.keymap.set("n", "<leader>fc", function()
        lsp_format_modifications.format_modifications(client, bufnr)
    end)

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
    end, opts)
end)


lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

-- lspconfig.gopls.setup({
--     settings = {
--         gopls = {
--             ["ui.inlayhint.hints"] = {
--                 compositeLiteralFields = true,
--                 constantValues = true,
--                 parameterNames = true
--             },
--             gofumpt = true,
--         },
--     },
-- })

lspconfig.solargraph.setup({})

lspconfig.typos_lsp.setup({
    init_options = {
        diagnosticSeverity = "Information",
        logLevel = "Information",
    }
})

