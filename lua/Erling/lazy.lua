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

-- Filter out the "position_encoding" warning from llm.nvim/neovim
-- local default_notify = vim.notify
-- vim.notify = function(msg, level, opts)
--     -- specific string matching to ignore the warning
--     if msg and msg:find("position_encoding param is required") then
--         return
--     end
--     default_notify(msg, level, opts)
-- end

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
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        -- version = "v2.*", 
        -- install jsregexp (optional!).
        -- This compiles the library needed for the warning you saw
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
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
    'ThePrimeagen/vim-be-good',
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- usage:
        -- press ( -> (|)
        -- press { -> {|}
        -- press " -> "|"
    },
    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      }
    },
    { 
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                override_vim_notify = true,
            },
        },
    },
    { "lewis6991/gitsigns.nvim" }, -- See git changes in the sidebar
    { "stevearc/conform.nvim" }, -- Auto-formatting
    { 
        "kylechui/nvim-surround", -- ysiw)
        event = "VeryLazy",
        config = true,
    }, -- Change surrounding quotes/brackets easily
    { 
        "lukas-reineke/indent-blankline.nvim", -- Line identation visualizer
        main = "ibl", -- This is important for version 3+
        opts = {},
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "black",   -- Python formatter
                    "isort",   -- Python import sorter
                    "stylua",  -- Lua formatter
                    -- "prettier", -- JS/TS formatter
                    "sqlfluff", -- SQL dbt formatter
                },
            })
        end,
    },
    { 
        "nvim-pack/nvim-spectre",
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    }
}

require("lazy").setup(plugins, {})
