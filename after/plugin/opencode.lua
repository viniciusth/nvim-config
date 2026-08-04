vim.g.opencode_opts = {}
vim.o.autoread = true

vim.keymap.set({ "n", "x" }, "<leader>oa", function()
    require("opencode").ask("@this: ")
end, { desc = "OpenCode: ask about this" })

vim.keymap.set({ "n", "x" }, "<leader>os", function()
    require("opencode").select()
end, { desc = "OpenCode: select action" })
