require("viniciusth.remap")
require("viniciusth.set")
vim.g.copilot_filetypes = { ['*'] = false }

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})
local formattingGroup = augroup('AutoFormatting', {});

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd({ "BufWritePre" }, {
    group = formattingGroup,
    pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
    callback = function ()
        vim.cmd("EslintFixAll")
    end,
})

autocmd({ "BufWritePost" }, {
    group = formattingGroup,
    pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
    callback = function ()
        local path = vim.api.nvim_buf_get_name(0)
        local command_args = { "pnpm", "prettier", "--write", path }
        vim.system(command_args, {}):wait()
        vim.cmd("edit");
    end,
})

