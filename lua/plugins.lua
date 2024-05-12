-- Initialize packer.nvim
require('packer').startup(function()
    -- Plugin Manager
    use 'wbthomason/packer.nvim'

    -- LSP and Autocompletion
    use 'neovim/nvim-lspconfig'             -- LSP configurations
    use 'williamboman/mason.nvim'           -- LSP installer
    use 'williamboman/mason-lspconfig.nvim' -- Mason integration for lspconfig
    use 'hrsh7th/nvim-cmp'                  -- Autocompletion engine
    use 'hrsh7th/cmp-nvim-lsp'              -- LSP source for nvim-cmp
    use 'L3MON4D3/LuaSnip'                   -- Snippet engine
    use 'simrat39/rust-tools.nvim'
    use "rafamadriz/friendly-snippets"
    use {
        "pmizio/typescript-tools.nvim",
        requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    }
    use '/windwp/nvim-ts-autotag'
    use { "zbirenbaum/copilot.lua" }
    use {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function ()
            require("copilot_cmp").setup()
        end
    }

    -- Formatting and Utilities
    use 'mhartington/formatter.nvim'
    use 'sitiom/nvim-numbertoggle'

    -- UI Enhancements
    use {'dracula/vim', as = 'dracula'}  -- Dracula theme
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use {
        'fei6409/log-highlight.nvim',
        config = function()
            require('log-highlight').setup {}
        end,
    }
    use {'stevearc/dressing.nvim'}
    use {'nvim-telescope/telescope-ui-select.nvim' }

    -- Navigation and Search
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        requires = {'nvim-lua/plenary.nvim'}
    }

    -- Syntax Highlighting and Git Integration
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    })
    use 'mbbill/undotree'
    use 'tpope/vim-fugitive'
    use 'idanarye/vim-merginal'

    -- Commenting and Editing Enhancements
    use 'terrortylor/nvim-comment'
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'tpope/vim-surround'
    use 'stevearc/oil.nvim'

    -- Additional Utilities
    use 'gennaro-tedesco/nvim-peekup'
    use {
        'junegunn/fzf',
        run = function() vim.fn['fzf#install']() end
    }
    use 'junegunn/fzf.vim'
    use 'mboughaba/i3config.vim'
    use 'tweekmonster/django-plus.vim'
    use {
        'CopilotC-Nvim/CopilotChat.nvim',
        branch = "canary",
    }
    use {
        'nmac427/guess-indent.nvim',
        config = function() require('guess-indent').setup {} end,
    }
    use {
        'm4xshen/hardtime.nvim',
        requires = {
            'MunifTanjim/nui.nvim',
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('hardtime').setup({})
        end
    }
    use {
        'norcalli/nvim-colorizer.lua',
        config = function() require('colorizer').setup() end
    }
end)

