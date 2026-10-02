local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	-- Jumps to the definition of the symbol under the cursor
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)

	-- Displays hover information (documentation/types) for the symbol under the cursor
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)

	-- Searches for a symbol (variable/function) across the entire project/workspace
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)

	-- Opens a floating window showing the error/warning diagnostic for the current line
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)

	-- Jumps to the NEXT diagnostic (error/warning) in the buffer
	-- (Note: Standard Vim convention usually puts 'next' on ']', but your code has it on '[')
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)

	-- Jumps to the PREVIOUS diagnostic (error/warning) in the buffer
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)

	-- Opens "Code Actions" menu (quick fixes, imports, refactors)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)

	-- Lists all references to the symbol under the cursor (where it is used)
	vim.keymap.set("n", "<leader>vrr", function()
		vim.lsp.buf.references()
	end, opts)

	-- Renames the symbol under the cursor across the whole project
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)

	-- [Insert Mode] Shows help for the current function signature (parameters) while typing
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"rust_analyzer",
		"lua_ls",
		"pyright", -- Python
		"gopls", -- Go
		"cssls", -- CSS
		"html", -- HTML
	},
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
	},
})

vim.lsp.config("rust_analyzer", {})
vim.lsp.config("lua_ls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("gopls", {})
vim.lsp.config("cssls", {})
vim.lsp.config("html", {})
vim.lsp.config("nil_ls", {})

vim.lsp.enable({ "rust_analyzer", "lua_ls", "pyright", "gopls", "cssls", "html", "nil_ls" })

-- Show diagnostics inline at end of line. Off by default since nvim 0.11.
vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
		prefix = "■",
		source = "if_many", -- show "[gopls]" only when several sources hit the buffer
		format = function(d)
			return d.message:match("[^\n]*") -- first line only, keeps it to one row
		end,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		},
	},
	underline = true,
	severity_sort = true, -- error wins over warning on the same line
	update_in_insert = false, -- don't redraw while typing; updates on leaving insert
	float = { border = "rounded", source = true }, -- <leader>vd still shows full message
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- this is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip", keyword_length = 2 },
		{ name = "buffer", keyword_length = 3 },
		{ name = "kotlin-language-server" },
	},
	formatting = lsp_zero.cmp_format({ details = false }),
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})

-- :CopyDiagnostics          -> warnings + errors in current buffer
-- :CopyDiagnostics ERROR    -> only errors
-- :CopyDiagnostics WARN     -> only warnings
-- :CopyDiagnostics! WARN    -> bang = all buffers, not just current
vim.api.nvim_create_user_command("CopyDiagnostics", function(opts)
	local severity = nil
	if opts.args ~= "" then
		severity = vim.diagnostic.severity[opts.args:upper()]
		if not severity then
			vim.notify("Unknown severity: " .. opts.args, vim.log.levels.ERROR)
			return
		end
	else
		severity = { min = vim.diagnostic.severity.WARN }
	end

	-- bang -> all buffers (nil), otherwise current buffer (0)
	local bufnr = opts.bang and nil or 0
	local diags = vim.diagnostic.get(bufnr, { severity = severity })

	if #diags == 0 then
		vim.notify("No matching diagnostics", vim.log.levels.INFO)
		return
	end

	-- stable ordering: file, then line, then col
	table.sort(diags, function(a, b)
		if a.bufnr ~= b.bufnr then
			return a.bufnr < b.bufnr
		end
		if a.lnum ~= b.lnum then
			return a.lnum < b.lnum
		end
		return a.col < b.col
	end)

	local lines = {}
	for _, d in ipairs(diags) do
		local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(d.bufnr), ":.")
		local sev = vim.diagnostic.severity[d.severity] -- number -> "WARN" etc.
		local src = d.source and (" [" .. d.source .. "]") or ""
		local msg = d.message:gsub("\n", " ")
		table.insert(lines, string.format("%s:%d:%d: %s: %s%s", file, d.lnum + 1, d.col + 1, sev, msg, src))
	end

	local text = table.concat(lines, "\n")
	vim.fn.setreg("+", text)
	vim.notify(string.format("Copied %d diagnostics to clipboard", #diags))
end, {
	nargs = "?",
	bang = true,
	complete = function()
		return { "ERROR", "WARN", "INFO", "HINT" }
	end,
})

-- :CopyDiagnostics          -> warnings + errors, whole project
-- :CopyDiagnostics ERROR    -> only errors
-- :CopyDiagnostics!         -> keep the loaded buffers around instead of wiping them
vim.api.nvim_create_user_command("CopyDiagnosticsProject", function(opts)
	local severity
	if opts.args ~= "" then
		severity = vim.diagnostic.severity[opts.args:upper()]
		if not severity then
			vim.notify("Unknown severity: " .. opts.args, vim.log.levels.ERROR)
			return
		end
	else
		severity = { min = vim.diagnostic.severity.WARN }
	end

	-- 1. Enumerate tracked files. Adjust to taste; empty = every tracked file.
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
		"*.go",
		"*.tf",
		"*.tfvars",
		"*.hcl",
		"*.tofu",
		"*.tofuvars",
	}
	local quoted = {}
	for _, p in ipairs(patterns) do
		table.insert(quoted, "'" .. p .. "'")
	end
	local handle = io.popen("git ls-files -- " .. table.concat(quoted, " "))
	if not handle then
		vim.notify("Failed to run git ls-files", vim.log.levels.ERROR)
		return
	end
	local out = handle:read("*a")
	handle:close()

	local files = {}
	for f in out:gmatch("[^\r\n]+") do
		table.insert(files, f)
	end
	if #files == 0 then
		vim.notify("No files found", vim.log.levels.WARN)
		return
	end

	local LIMIT = 500
	if #files > LIMIT then
		local ok = vim.fn.confirm(
			string.format("%d files. Loading all of them may be slow. Continue?", #files),
			"&Yes\n&No",
			2
		)
		if ok ~= 1 then
			return
		end
	end

	-- 2. Track which buffers we create so we can clean up afterwards.
	local pre_existing = {}
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		pre_existing[b] = true
	end

	local created = {}
	for _, file in ipairs(files) do
		local bufnr = vim.fn.bufadd(file)
		if not pre_existing[bufnr] then
			table.insert(created, bufnr)
		end
		vim.fn.bufload(bufnr) -- fires FileType -> LSP attaches
		-- nvim-lint doesn't hook bufload, so kick it manually
		pcall(function()
			vim.api.nvim_buf_call(bufnr, function()
				require("lint").try_lint()
			end)
		end)
	end

	-- 3. Wait for diagnostics to settle: poll until the count stops changing.
	vim.notify(string.format("Loaded %d files, waiting for diagnostics...", #files))
	local last, stable = -1, 0
	vim.wait(30000, function()
		local n = #vim.diagnostic.get(nil)
		if n == last then
			stable = stable + 1
		else
			last, stable = n, 0
		end
		return stable >= 6 -- ~1.2s with no change
	end, 200)

	-- 4. Collect.
	local diags = vim.diagnostic.get(nil, { severity = severity })
	if #diags == 0 then
		vim.notify("No matching diagnostics", vim.log.levels.INFO)
	else
		table.sort(diags, function(a, b)
			local fa = vim.api.nvim_buf_get_name(a.bufnr)
			local fb = vim.api.nvim_buf_get_name(b.bufnr)
			if fa ~= fb then
				return fa < fb
			end
			if a.lnum ~= b.lnum then
				return a.lnum < b.lnum
			end
			return a.col < b.col
		end)

		local lines = {}
		for _, d in ipairs(diags) do
			local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(d.bufnr), ":.")
			local sev = vim.diagnostic.severity[d.severity]
			local src = d.source and (" [" .. d.source .. "]") or ""
			local msg = d.message:gsub("%s*\n%s*", " ")
			table.insert(lines, string.format("%s:%d:%d: %s: %s%s", file, d.lnum + 1, d.col + 1, sev, msg, src))
		end

		vim.fn.setreg("+", table.concat(lines, "\n"))
		vim.notify(string.format("Copied %d diagnostics from %d files", #diags, #files))
	end

	-- 5. Clean up buffers we opened, unless bang.
	if not opts.bang then
		for _, b in ipairs(created) do
			if vim.api.nvim_buf_is_valid(b) and not vim.bo[b].modified then
				pcall(vim.api.nvim_buf_delete, b, { force = false })
			end
		end
	end
end, {
	nargs = "?",
	bang = true,
	complete = function()
		return { "ERROR", "WARN", "INFO", "HINT" }
	end,
})
