-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use { 'morhetz/gruvbox' }

    use({
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                auto_preview = false,
                auto_fold = true,
                icons = false,
            }
        end
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use("theprimeagen/harpoon")
    use("theprimeagen/refactoring.nvim")
    use("mbbill/undotree")
    use("tpope/vim-fugitive")
    use("tpope/vim-rhubarb")
    use("vim-test/vim-test")
    use("nvim-treesitter/nvim-treesitter-context")
    use("airblade/vim-gitgutter")
    use {
        'numToStr/Comment.nvim',
        config = function()
---@diagnostic disable-next-line: undefined-field
            local sysname = vim.loop.os_uname().sysname
            sysname = string.lower(sysname)
            sysname = string.sub(sysname, 1, 3)
            local is_windows = sysname == "win"
            if is_windows then
                require('Comment').setup {
                    ---LHS of toggle mappings in NORMAL mode
                    toggler = {
                        ---Line-comment toggle keymap
                        line = '<C-_>',
                    },
                    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
                    opleader = {
                        ---Line-comment keymap
                        line = '<C-_>',
                    },
                }
            else
                require('Comment').setup {
                    ---LHS of toggle mappings in NORMAL mode
                    toggler = {
                        ---Line-comment toggle keymap
                        line = '<C-/>',
                        ---Block-comment toggle keymap
                        block = '<C-?>',
                    },
                    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
                    opleader = {
                        ---Line-comment keymap
                        line = '<C-/>',
                        ---Block-comment keymap
                        block = '<C-?>',
                    },
                }
            end
        end
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use({
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup()
        end,
    })

    use("folke/zen-mode.nvim")
    use("github/copilot.vim")
end)
