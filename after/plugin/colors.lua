
local colors = { "rose-pine-main", "gruvbox" }
local selected = 1

local function getColor(add)
    if add then
        selected = (selected % #colors + 1)
    end

    return colors[selected]
end

function ColorMyPencils(add)
    local color = getColor(add)
    vim.cmd.colorscheme(color)
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

vim.keymap.set("n", "<leader>cs", function() ColorMyPencils(true) end)
ColorMyPencils(false)
