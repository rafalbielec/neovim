vim.treesitter.language.register("markdown", "mdx")
require("nvim-treesitter.configs").setup({
	modules = { "highlight" },
	sync_install = false,
	ignore_install = {},
	ensure_installed = {
		"json",
		"lua",
		"luadoc",
		"vim",
		"vimdoc",
		"markdown",
		"markdown_inline",
		"xml",
		"c_sharp",
		"regex",
		"html",
		"css",
		"javascript",
		"typescript",
		"astro",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "ruby" },
	},
	indent = { enable = true, disable = { "ruby" } },
	incremental_selection = { enable = true },
	autotag = { enable = true },
	rainbow = { enable = true, disable = { "html" }, extended_mode = false },
	auto_install = true,
})
