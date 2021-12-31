local util = require('util')

vim.g.suda_smart_edit = 0
util.nmap('<C-l>', ':TagbarToggle<CR>')
util.nmap('<F6>', ':ColorizerToggle<CR>')
util.nmap('<C-g>', ':SignifyToggle<CR>')

require('packer').startup(function()
    use { 'wbthomason/packer.nvim' }
    use { 'gentoo/gentoo-syntax' }

    use { 'lambdalisue/suda.vim', cmd = { 'SudaWrite' } }
    use { 'chaoren/vim-wordmotion' }
    use { 'tpope/vim-surround' }
    use { 'norcalli/nvim-colorizer.lua', config = "require('colorizer').setup {'*'}", cmd = { 'ColorizerToggle' } }
    use { 'iamcco/markdown-preview.nvim', run = 'cd app && npm install', ft = { "markdown" }, cmd = { 'MarkdownPreview' } }

    use { 'kyazdani42/nvim-tree.lua', config = "require('plugin-config/nvim-tree')" }
    use { 'preservim/tagbar', cmd = { 'TagbarToggle' } }
    use { 'mhinz/vim-signify', cmd = { 'SignifyToggle' } }
    use { 'tpope/vim-fugitive' }

    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'windwp/nvim-ts-autotag',
        },
        run = ':TSUpdate',
        config = "require('plugin-config/nvim-treesitter')",
    }
    use { 'ludovicchabant/vim-gutentags', config = "require('plugin-config/gutentags')" }
    use { 'Yggdroot/LeaderF', run = ':LeaderfInstallCExtension', config = "require('plugin-config/LeaderF')" }
    use { 'dense-analysis/ale', config = "require('plugin-config/ale')" }
    use { 'vim-latex/vim-latex', ft = { 'tex', 'latex', 'bib' }, config = "require('plugin-config/vim-latex')" }
    use { 'neovim/nvim-lspconfig', config = "require('plugin-config/nvim-lspconfig')" }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
        },
        config = "require('plugin-config/nvim-cmp')"
    }
end)
