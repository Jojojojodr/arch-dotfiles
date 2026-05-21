return {
	"nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
	build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        local languages = {
            "bash",
            "c",
            "diff",
            "html",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "query",
            "vim",
            "vimdoc",
            "go",
            "ruby",
            "python",
            "typescript",
            "javascript",
            "tsx",
            "css",
            "json",
            "rust",
            "dockerfile",
            "yaml",
        }

        local ok_legacy, treesitter = pcall(require, "nvim-treesitter.configs")
        if ok_legacy then
            treesitter.setup({
                ensure_installed = languages,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "go" },
                },
                indent = { enable = true },
                autotag = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<c-b>",
                        node_incremental = "<c-b>",
                        scope_incremental = "<c-s>",
                        node_decremental = "<c-backspace>",
                    },
                },
            })

            if not pcall(vim.treesitter.language.add, "go") then
                vim.schedule(function()
                    vim.cmd("silent! TSInstall go")
                end)
            end
            return
        end

        local ok_new, ts = pcall(require, "nvim-treesitter")
        if not ok_new then
            vim.notify("nvim-treesitter failed to load", vim.log.levels.ERROR)
            return
        end

        ts.setup({})
        ts.install(languages)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "go",
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
}