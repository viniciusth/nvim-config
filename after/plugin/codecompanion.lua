require("codecompanion").setup({
    interactions = {
        -- CLI-only setup: drives the real `claude` binary in a terminal buffer,
        -- so it uses your existing OAuth login (no ANTHROPIC_API_KEY needed).
        cli = {
            agent = "claude_code",
            agents = {
                claude_code = {
                    cmd = "claude",
                    args = {},
                    description = "Claude Code CLI",
                    provider = "terminal",
                },
            },
        },
    },
})

-- Keybindings (<leader>c* family) — all routed through the CLI interaction
vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionCLI<CR>", { desc = "CodeCompanion: open CLI agent" })

vim.keymap.set({ "n", "v" }, "<leader>ct", function()
    return require("codecompanion").cli()
end, { desc = "CodeCompanion: toggle CLI agent" })

vim.keymap.set({ "n", "v" }, "<leader>cp", function()
    return require("codecompanion").cli({ prompt = true })
end, { desc = "CodeCompanion: prompt the CLI agent" })

vim.keymap.set({ "n", "v" }, "<leader>cd", function()
    return require("codecompanion").cli("#{this}", { focus = false })
end, { desc = "CodeCompanion: add buffer/selection to CLI agent" })

vim.keymap.set("n", "<leader>cx", function()
    return require("codecompanion").cli("#{diagnostics} Can you fix these?", { focus = false, submit = true })
end, { desc = "CodeCompanion: send diagnostics to CLI agent" })
