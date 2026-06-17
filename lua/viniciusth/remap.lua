vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- copy file path to clipboard
vim.keymap.set("n", "<leader>yp", function()
    local path = vim.fn.expand("%:p:.")
    vim.fn.setreg("+", path)
    print("Copied file path: " .. path)
end)

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- override python format with black
local viniciusth_ihatepython = vim.api.nvim_create_augroup("viniciusth_ihatepython", {})
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufEnter", {
    group = viniciusth_ihatepython,
    pattern = "*.py",
    callback = function()
        local path = vim.api.nvim_buf_get_name(0)
        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            vim.cmd("silent !black " .. path)
        end)
    end,
})

-- override typescript format with prettier
local viniciusth_ihatets = vim.api.nvim_create_augroup("viniciusth_ihatets", {})
autocmd("BufEnter", {
    group = viniciusth_ihatets,
    pattern = "*.ts,*.tsx,*.js,*.jsx",
    callback = function()
        local path = vim.api.nvim_buf_get_name(0)
        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            vim.cmd("silent !yarn prettier --write " .. path)
            vim.cmd("silent !pnpm prettier --write " .. path)
        end)
    end,
})
vim.keymap.set({ "n", "v" }, "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- doesnt work with multiline:
vim.keymap.set("v", "<leader>s", "y:%s/<C-r>0/<C-r>0/gc<left><left><left>")

-- open file under cursor in vertical/horizontal split
vim.keymap.set("n", "gfs", "<cmd>split<CR>gF")
vim.keymap.set("n", "gfv", "<cmd>vsplit<CR>gF")

-- remap split navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
if vim.fn.has("mac") == 1 then
    vim.keymap.set("n", "<C-S-h>", "<C-w>H")
    vim.keymap.set("n", "<C-S-j>", "<C-w>J")
    vim.keymap.set("n", "<C-S-k>", "<C-w>K")
    vim.keymap.set("n", "<C-S-l>", "<C-w>L")
else
    vim.keymap.set("n", "<M-S-h>", "<C-w>H")
    vim.keymap.set("n", "<M-S-j>", "<C-w>J")
    vim.keymap.set("n", "<M-S-k>", "<C-w>K")
    vim.keymap.set("n", "<M-S-l>", "<C-w>L")
end
-- resizing
vim.keymap.set("n", "<M-S-Up>", "<C-w>5+")
vim.keymap.set("n", "<M-S-Down>", "<C-w>5-")
vim.keymap.set("n", "<M-S-Left>", "<C-w>5>")
vim.keymap.set("n", "<M-S-Right>", "<C-w>5<")
vim.keymap.set("n", "<leader>eq", "<C-w>=")

vim.keymap.set("n", "<C-q>", [[:q<CR>]])

-- terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- proto formatting
local viniciusth_iloveproto = vim.api.nvim_create_augroup("viniciusth_iloveproto", {})
autocmd("BufEnter", {
    group = viniciusth_iloveproto,
    pattern = "*.proto",
    callback = function()
        local path = vim.api.nvim_buf_get_name(0)
        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            vim.cmd("silent !buf format -w " .. path)
            vim.cmd("e!")
        end)
    end,
})

-- switch up some tabsizing
vim.keymap.set("n", "<leader>th", function()
    ---@diagnostic disable-next-line: undefined-field
    local val = vim.opt.tabstop._value
    vim.opt.tabstop = math.max(val - 2, 2)
    ---@diagnostic disable-next-line: undefined-field
    val = vim.opt.shiftwidth._value
    vim.opt.shiftwidth = math.max(val - 2, 2)
end)

vim.keymap.set("n", "<leader>tl", function()
    ---@diagnostic disable-next-line: undefined-field
    local val = vim.opt.tabstop._value
    vim.opt.tabstop = math.min(val + 2, 8)
    ---@diagnostic disable-next-line: undefined-field
    val = vim.opt.shiftwidth._value
    vim.opt.shiftwidth = math.min(val + 2, 8)
end)

vim.keymap.set("n", "<leader>gb", "<cmd>Git blame -w -C -C -C<CR>")
vim.keymap.set("n", "<Leader>dof", "<cmd>Neogen func<CR>")
vim.keymap.set("n", "<Leader>doc", "<cmd>Neogen class<CR>")
vim.keymap.set("n", "<Leader>dot", "<cmd>Neogen type<CR>")

vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<CR>")

vim.keymap.set("n", "<leader>lp", function()
    local current_file = vim.fn.expand("%:p")
    local output_file = vim.fn.expand("%:p:r") .. ".pdf"
    local command = "pandoc " .. vim.fn.shellescape(current_file) .. " -o " .. vim.fn.shellescape(output_file) .. " && open " .. vim.fn.shellescape(output_file)
    vim.fn.system(command)
    print("Converted to PDF: " .. output_file)
end)

vim.keymap.set('i', '<C-.>', '<Plug>(copilot-suggest)')
