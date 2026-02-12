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
        tex = { "latexindent" },
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

vim.api.nvim_create_user_command("FormatProject", function(args)
  -- 1. Get the current working directory
  local cwd = vim.fn.getcwd()
  
  -- 2. Define patterns to match (Edit these!)
  local patterns = { "*.lua", "*.py", "*.js", "*.ts", "*.rs" }
  
  -- 3. Build the find command
  -- Note: Using 'git ls-files' is usually safer than 'find' if you use git,
  -- because it respects .gitignore automatically.
  local command = "git ls-files " .. table.concat(patterns, " ")
  
  -- 4. Get the list of files
  local handle = io.popen(command)
  if not handle then return end
  local result = handle:read("*a")
  handle:close()

  -- 5. Split into a table
  local files = {}
  for file in result:gmatch("[^\r\n]+") do
    table.insert(files, file)
  end

  if #files == 0 then
    print("No files found to format.")
    return
  end

  print("Formatting " .. #files .. " files...")

  -- 6. Loop and format
  for _, file in ipairs(files) do
    -- Open the file in a buffer (if not open), format, save
    local bufnr = vim.fn.bufadd(file)
    vim.fn.bufload(bufnr)
    
    require("conform").format({
      bufnr = bufnr,
      lsp_fallback = true,
    })
    
    -- Save the buffer
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("write")
    end)
  end

  print("Project formatting complete!")
end, {})
