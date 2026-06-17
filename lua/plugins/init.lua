return {
  {
    "nvim-telescope/telescope.nvim",
    -- master (not a tag): 0.1.8 still calls the removed `ft_to_lang`,
    -- which breaks previews on Neovim 0.12. The fix only landed on master.
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  },

  "lukas-reineke/indent-blankline.nvim",
  "echasnovski/mini.nvim",

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  "rose-pine/neovim",
  "morhetz/gruvbox",

  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        auto_preview = false,
        auto_fold = true,
      })
    end,
  },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "theprimeagen/harpoon",
  "theprimeagen/refactoring.nvim",
  "mbbill/undotree",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "vim-test/vim-test",
  "nvim-treesitter/nvim-treesitter-context",
  "airblade/vim-gitgutter",
  "kristijanhusak/vim-carbon-now-sh",

  {
    "numToStr/Comment.nvim",
    config = function()
      local U = require("Comment.utils")
      local ft = require("Comment.ft")

      -- Comment.nvim's treesitter-based resolution (Comment.ft.calculate) breaks on
      -- Neovim 0.12 for filetypes whose parser isn't installed (e.g. zig), so even
      -- line comments fail with "[Comment.nvim] nil". This pre_hook resolves the
      -- commentstring from the plugin's filetype table (falling back to Neovim's
      -- native 'commentstring'), bypassing that path. For block comments in languages
      -- without block syntax (zig), it falls back to the line commentstring instead of
      -- erroring. Trade-off: embedded-language detection (e.g. JS inside HTML) is
      -- skipped in favour of the top-level filetype.
      local function resolve_commentstring(ctx)
        local filetype = vim.bo.filetype
        local line = ft.get(filetype, U.ctype.linewise) or vim.bo.commentstring
        local block = ft.get(filetype, U.ctype.blockwise)
        if ctx.ctype == U.ctype.blockwise then
          return block or line
        end
        return line
      end

      local sysname = vim.loop.os_uname().sysname
      sysname = string.lower(sysname)
      sysname = string.sub(sysname, 1, 3)
      local is_windows = sysname == "win"
      if is_windows then
        require("Comment").setup({
          pre_hook = resolve_commentstring,
          toggler = {
            line = "<C-_>",
          },
          opleader = {
            line = "<C-_>",
          },
        })
      else
        require("Comment").setup({
          pre_hook = resolve_commentstring,
          toggler = {
            line = "<C-/>",
            block = "<C-?>",
          },
          opleader = {
            line = "<C-/>",
            block = "<C-?>",
          },
        })
      end
    end,
  },

  -- LSP, completion and tooling (native mason-lspconfig setup; configured in after/plugin/lsp.lua)
  { "neovim/nvim-lspconfig", tag = "v2.5.0" },
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
  "marilari88/twoslash-queries.nvim",

  -- AI assistant (configured in after/plugin/codecompanion.lua)
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
        },
      })
    end,
  },

  "folke/zen-mode.nvim",

  {
    "lervag/vimtex",
    config = function()
      local sysname = vim.loop.os_uname().sysname
      sysname = string.lower(sysname)
      sysname = string.sub(sysname, 1, 3)
      local is_windows = sysname == "win"
      if is_windows then
        vim.g.vimtex_view_method = "general"
        vim.g.vimtex_view_general_viewer = "sumatrapdf"
      else
        vim.g.vimtex_view_method = "zathura"
      end
    end,
  },

  {
    "j-hui/fidget.nvim",
    opts = {},
  },

  "joechrisellis/lsp-format-modifications.nvim",

  {
    "danymat/neogen",
    opts = {},
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "echasnovski/mini.nvim" },
    opts = {},
  },

  "godlygeek/tabular",
  "preservim/vim-markdown",
}
