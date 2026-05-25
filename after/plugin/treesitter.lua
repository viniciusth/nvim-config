require("nvim-treesitter.install").install({
  "vimdoc",
  "javascript",
  "typescript",
  "c",
  "lua",
  "rust",
  "cpp",
})

-- Highlight is built-in via vim.treesitter in Neovim 0.11+

require("treesitter-context").setup({
  enable = true,
  max_lines = 3,
  min_window_height = 16,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = "outer",
  mode = "cursor",
  separator = nil,
  zindex = 20,
  on_attach = nil,
})
