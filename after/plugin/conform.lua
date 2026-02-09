local conform = require("conform")

conform.setup({

    log_level = vim.log.levels.DEBUG,

    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        go = { "goimports", "gofmt" },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        sql = { "sqlfluff" },
    },

    formatters = {
        sqlfluff = {
            -- 1. Standard args (removed --force since it's deprecated)
            args = { 
                "fix", 
                "--dialect", "snowflake", 
                "--templater", "jinja",
                "--ignore", "parsing,templating",  -- Ignore the scary stuff
                "-" 
            },
            
            -- 2. THE FIX: Tell Conform that exit code 1 is NOT a crash.
            --    0 = Perfect run
            --    1 = Fixed some things, but left others (This is what you have)
            exit_codes = { 0, 1 },
        },
    },
})

-- Define the keymap here manually
vim.keymap.set("", "<leader>f", function()
    conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
