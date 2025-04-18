require'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = {"nix", "python", "gdscript", "javascript", "typescript", "c", "lua", "vim", "vimdoc", "go", "rust" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = false,

	highlight = {
		enable = true,
        disable = { "latex" },
		additional_vim_regex_highlighting = { "latex", "markdown" }
	},
}
