local persist_file = vim.fn.stdpath("data") .. "/colorscheme.txt"
local default_color = "rose-pine-main"

local function save_color(name)
    local f = io.open(persist_file, "w")
    if f then
        f:write(name)
        f:close()
    end
end

local function load_color()
    local f = io.open(persist_file, "r")
    if not f then
        return default_color
    end
    local name = f:read("*l")
    f:close()
    if name == nil or name == "" then
        return default_color
    end
    return name
end

local function apply_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- Reapply transparency and persist the choice whenever the colorscheme changes
-- (covers both the Telescope picker and manual :colorscheme calls).
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function(args)
        apply_transparency()
        save_color(args.match)
    end,
})

-- Open Telescope's colorscheme picker with live preview.
vim.keymap.set("n", "<leader>cs", function()
    require("telescope.builtin").colorscheme({ enable_preview = true })
end, { desc = "Pick colorscheme" })

-- Restore the last chosen colorscheme on startup.
local ok = pcall(vim.cmd.colorscheme, load_color())
if not ok then
    vim.cmd.colorscheme(default_color)
end
