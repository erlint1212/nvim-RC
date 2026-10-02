-- Teach Neovim about OpenTofu-specific extensions
vim.filetype.add({
	extension = {
		tofu = "terraform",
		tofuvars = "terraform-vars",
	},
})

local conform = require("conform")

conform.setup({

	log_level = vim.log.levels.DEBUG,

	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		go = { "goimports", "gofmt" },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		sql = { "sqlfluff" },
		tex = { "latexindent" },
		css = { "prettier" },
		html = { "prettier" },
		kotlin = { "ktlint" },
		nix = { "nixfmt" },
		markdown = { "mdformat" },
		terraform = { "tofu_fmt" },
		["terraform-vars"] = { "tofu_fmt" },
		hcl = { "tofu_fmt" },
	},

	formatters = {
		sqlfluff = function(bufnr)
			local util = require("conform.util")

			-- local dbt_root = util.root_file({ "dbt_project.yml" })(bufnr)
			local dbt_root = vim.fs.find("dbt_project.yml", {
				upward = true,
				path = vim.api.nvim_buf_get_name(bufnr),
			})[1]
			local args = { "fix", "--dialect", "snowflake" }

			if dbt_root then
				vim.list_extend(args, { "--templater", "dbt" })
			end
			vim.list_extend(args, { "--ignore", "parsing,templating", "-" })

			return {
				args = args,
				exit_codes = { 0, 1 },
				cwd = util.root_file({ "dbt_project.yml", ".sqlfluff", ".git" }),
				require_cwd = false,
			}
		end,
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
	local patterns = {
		"*.lua",
		"*.py",
		"*.js",
		"*.ts",
		"*.rs",
		"*.kt",
		"*.kts",
		"*.sql",
		"*.nix",
		"*.tf",
		"*.tfvars",
		"*.hcl",
		"*.tofu",
		"*.tofuvars",
	}

	-- 3. Build the find command
	-- Note: Using 'git ls-files' is usually safer than 'find' if you use git,
	-- because it respects .gitignore automatically.
	-- Patterns are quoted and passed after '--' so git (not the shell) expands
	-- them, which also makes them match in nested directories.
	local quoted = {}
	for _, p in ipairs(patterns) do
		table.insert(quoted, "'" .. p .. "'")
	end
	local command = "git ls-files -- " .. table.concat(quoted, " ")

	-- 4. Get the list of files
	local handle = io.popen(command)
	if not handle then
		return
	end
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
			async = false,
			lsp_fallback = true,
		})

		-- Save the buffer
		vim.api.nvim_buf_call(bufnr, function()
			vim.cmd("write")
		end)
	end

	print("Project formatting complete!")
end, {})
