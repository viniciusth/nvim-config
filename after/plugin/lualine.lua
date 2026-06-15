require('lualine').setup {
    sections = {
        lualine_b = { "diff", "diagnostics" },
        lualine_c = {{
            'filename',
            path = 1,
        }},
        lualine_x = {},
        lualine_y = {},
    },
}
