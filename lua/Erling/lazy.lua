-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local plugins = {
    {
      "lervag/vimtex",
      lazy = false,     -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "general"
      end
    },
	 {
		'nvim-telescope/telescope.nvim', --  version = "0.1.6",
		-- or                            , branch = '0.1.x',
		dependencies = { {'nvim-lua/plenary.nvim'}, }
	}, --pf, find files in dir
	{
		'rose-pine/neovim',
		name = 'rose-pine',
        -- fun(LazyPlugin)
        config = function()
			vim.cmd('colorscheme rose-pine')
		end
	}, --visual

	'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', --visual
	'nvim-treesitter/playground', --change visual
	'theprimeagen/harpoon', --quickly get between files
	'mbbill/undotree', --See log and go back
	'tpope/vim-fugitive', --See current git state
	 {
		'VonHeikemen/lsp-zero.nvim',
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lua'},

			-- Snippets
			{'L3MON4D3/LuaSnip'},
			{'rafamadriz/friendly-snippets'},
		},
	},
    'ThePrimeagen/vim-be-good'
}

require("lazy").setup(plugins, {})
