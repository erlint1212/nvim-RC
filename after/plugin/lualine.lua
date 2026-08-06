local lualine = require("lualine")

local function nix_shell()
	if not vim.env.IN_NIX_SHELL then
		return ""
	end

	-- `nix develop` sets $name to the mkShell `name` attribute (e.g. "finods-rag")
	-- Legacy `nix-shell` sets it to "nix-shell" by default.
	local name = vim.env.name

	if name and name ~= "" and name ~= "nix-shell" then
		return "󱄅 " .. name
	else
		return "󱄅 nix-shell"
	end
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto", -- This will automatically match your rose-pine theme!
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = {
			{
				nix_shell,
				color = { fg = "#e0def4", bg = "#31748f", gui = "bold" },
                separator = {left = "", right=""},
			},
			"encoding",
			"fileformat",
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
