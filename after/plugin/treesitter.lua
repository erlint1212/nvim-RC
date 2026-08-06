-- Install parsers (idempotent, runs async; needs a C compiler)
require("nvim-treesitter").install({
	"nix",
	"python",
	"gdscript",
	"javascript",
	"typescript",
	"c",
	"lua",
	"vim",
	"vimdoc",
	"go",
	"rust",
	"css",
	"templ",
	"dockerfile",
	"html",
	"kotlin",
	"markdown",
	"markdown_inline",
})

-- Start treesitter highlighting per filetype.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = args.match

		-- Let VimTeX own tex/latex highlighting (your old disable = {"latex"})
		if ft == "tex" or ft == "latex" or ft == "plaintex" then
			return
		end

		local lang = vim.treesitter.language.get_lang(ft)
		if lang and vim.treesitter.language.add(lang) then
			vim.treesitter.start(args.buf, lang)
		end
	end,
})
