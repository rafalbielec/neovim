require("paq")({
	{ "rafalbielec/paq-nvim", as = "paq" }, -- package manager
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "lewis6991/gitsigns.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "romgrk/barbar.nvim" },
	{ "nvim-telescope/telescope.nvim", branch = "master" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "folke/which-key.nvim" },
	{ "rafamadriz/friendly-snippets", branch = "main" },
	{ "leath-dub/snipe.nvim" },
	{ "folke/noice.nvim" },
	{ "MunifTanjim/nui.nvim" },
	{ "rafalbielec/hop.nvim", branch = "v2.0" },
	{ "norcalli/nvim-colorizer.lua" },

	-- mini plugins
	{ "echasnovski/mini.nvim", branch = "main" },

	-- LSP
	{ "neovim/nvim-lspconfig" },
	{ "seblj/roslyn.nvim" },
	{ "stevearc/conform.nvim" },
})

require("neovim.plugins.telescope")
require("neovim.plugins.treesitter")
require("neovim.plugins.snipe")
require("neovim.plugins.lsp")
-- require("neovim.plugins.noice")
require("neovim.plugins.mini-setup")
require("neovim.plugins.hop")
