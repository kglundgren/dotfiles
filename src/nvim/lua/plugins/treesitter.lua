local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",  -- Automatically run `:TSUpdate` after installation.
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "c_sharp" },  -- List of languages to automatically install.
            sync_install = false,  -- Install languages synchronously (only applied to `ensure_installed`).
            highlight = {
                enable = true,  -- Enable syntax highlighting.
            },
            indent = {
                enable = true,  -- Enable indentation based on treesitter.
            },
        })
    end,
}

return { M }

