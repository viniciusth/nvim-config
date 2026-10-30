require("nvim-treesitter.install").install({
  "vimdoc",
  "javascript",
  "typescript",
  "svelte",
  "html",
  "css",
  "c",
  "lua",
  "rust",
  "cpp",
  "typst",
})

-- Parser installation and highlighting are separate in Neovim's native API.
-- Start highlighting for every filetype that has an installed parser.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

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
