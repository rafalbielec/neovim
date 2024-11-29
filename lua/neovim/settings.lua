-- General settings

require("conform").setup({
	notify_on_error = true,
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "biome" },
		json = { "biome" },
		typescript = { "biome" },
		typescriptreact = { "biome" },
		javascript = { "biome" },
		javascriptreact = { "biome" },
	},
	format_on_save = function(bufnr)
		local disable_filetypes = {
			astro = true,
			markdown = true,
			md = true,
		}
		local lsp_format_opt
		if disable_filetypes[vim.bo[bufnr].filetype] then
			lsp_format_opt = "never"
		else
			lsp_format_opt = "fallback"
		end
		return {
			timeout_ms = 500,
			lsp_format = lsp_format_opt,
		}
	end,
})

require("neoscroll").setup({
	mappings = { -- Keys to be mapped to their corresponding default scrolling animation
		"<C-u>",
		"<C-d>",
		"<C-b>",
		"<C-f>",
		"<C-y>",
		"<C-e>",
		"zt",
		"zz",
		"zb",
	},
	hide_cursor = true, -- Hide cursor while scrolling
	stop_eof = true, -- Stop at <EOF> when scrolling downwards
	respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	duration_multiplier = 1.0, -- Global duration multiplier
	easing = "linear", -- Default easing function
	pre_hook = nil, -- Function to run before the scrolling animation starts
	post_hook = nil, -- Function to run after the scrolling animation ends
	performance_mode = false, -- Disable "Performance Mode" on all buffers.
	ignored_events = { -- Events ignored while scrolling
		"WinScrolled",
		"CursorMoved",
	},
})

require("smear_cursor").setup({
	-- Smear cursor color. Defaults to Cursor GUI color if not set.
	-- Set to "none" to match the text color at the target cursor position.
	cursor_color = "#d3cdc3",

	-- Background color. Defaults to Normal GUI background color if not set.
	normal_bg = "#282828",

	-- Smear cursor when switching buffers.
	smear_between_buffers = true,

	-- Smear cursor when moving within line or to neighbor lines.
	smear_between_neighbor_lines = true,

	-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
	-- Smears will blend better on all backgrounds.
	legacy_computing_symbols_support = false,
})
