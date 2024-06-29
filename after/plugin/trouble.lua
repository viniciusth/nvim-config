vim.keymap.set("n", "<leader>we", function () require("trouble").open("diagnostics") end,
  {silent = true, noremap = true}
)

