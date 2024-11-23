require("render-markdown").setup({
	render_modes = { "n", "c" },
	file_types = { "markdown", "mdx" },
	anti_conceal = { enabled = false },
	code = {
		enabled = true,
		sign = false,
		style = "full",
		position = "left",
		language_pad = 0,
		language_name = true,
		disable_background = { "diff" },
		width = "full",
		left_margin = 0,
		left_pad = 0,
		right_pad = 0,
		min_width = 0,
		border = "thin",
		above = "▄",
		below = "▀",
		highlight = "RenderMarkdownCode",
		highlight_inline = "RenderMarkdownCodeInline",
		highlight_language = nil,
	},
})

local key = vim.keymap.set
key("n", "<leader>m", require("render-markdown").toggle, { silent = true, desc = "Render markdown" })
