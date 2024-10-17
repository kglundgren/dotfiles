return {{
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',  -- Automatically run `:TSUpdate` after installation.
    opts = {
        ensure_installed = { -- List of languages to automatically install.
            'c',
            'lua',
            'vim',
            'vimdoc',
            'query',
            'javascript',
            'html',
            'c_sharp'
        },
        sync_install = false,  -- Install languages synchronously (only applied to `ensure_installed`).
        highlight = {
            enable = true,  -- Enable syntax highlighting.
        },
        indent = {
            enable = true,  -- Enable indentation based on treesitter.
        },
    }
}}

