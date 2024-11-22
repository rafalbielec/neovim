-- General settings

vim.g.editorconfig = true

require("conform").setup({
	notify_on_error = true,
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "biome" },
		json = { "biome" },
	},
	format_on_save = function(bufnr)
		local disable_filetypes = {
			astro = true,
			html = true,
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
