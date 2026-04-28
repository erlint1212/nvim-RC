local lint = require("lint")

-- 1. Assign golangcilint to Go files
lint.linters_by_ft = {
    go = { "golangcilint" },
    python = { "ruff" },
}

-- 2. Create an autocommand to trigger the linter automatically
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        -- This tells nvim-lint to run the linter associated with the current filetype
        lint.try_lint()
    end,
})

-- Optional: Add a manual keymap to trigger linting just in case
vim.keymap.set("n", "<leader>l", function()
    lint.try_lint()
    print("Linting complete")
end, { desc = "Trigger linting for current file" })
