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
	{ "leath-dub/snipe.nvim" },
	{ "MunifTanjim/nui.nvim" },
	{ "rafalbielec/hop.nvim", branch = "v2.0" },
	{ "brenoprata10/nvim-highlight-colors" },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
	{ "MeanderingProgrammer/render-markdown.nvim" },
	{ "sharkdp/fd" },

	-- mini plugins
	{ "echasnovski/mini.nvim", branch = "main" },

	-- LSP
	{ "neovim/nvim-lspconfig" },
	{ "seblj/roslyn.nvim" },
	{ "stevearc/conform.nvim" },
	{ "luckasRanarison/tailwind-tools.nvim", build = ":UpdateRemotePlugins" },
	{ "onsails/lspkind-nvim" },
	{ "ray-x/lsp_signature.nvim" },

	-- code completion via cmp
	{ "rafalbielec/nvim-cmp" }, -- removes the markdown from the LSP pop-up
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "lukas-reineke/cmp-rg" },
})

require("neovim.plugins.telescope")
require("neovim.plugins.treesitter")
require("neovim.plugins.snipe")
require("neovim.plugins.markdown")
require("neovim.plugins.lsp")
require("neovim.plugins.mini-setup")
require("neovim.plugins.cmp")
require("neovim.plugins.hop")
