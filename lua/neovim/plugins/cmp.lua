local cmp = require("cmp")

require("cmp").setup({
	snippet = {
		expand = function() end,
	},
	completion = {
		autocomplete = { require("cmp.types").cmp.TriggerEvent.InsertEnter },
		completeopt = "menu,menuone,popup,fuzzy,noselect,noinsert",
	},
	preselect = cmp.PreselectMode.None,
	window = {
		completion = {
			border = "rounded",
			winhighlight = "Normal:Cmp,CursorLine:CmpLine",
		},
		documentation = {
			border = "rounded",
			-- winhighlight = "Normal:Cmp",
		},
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),

		["<Tab>"] = cmp.mapping.scroll_docs(4),
		["<S-Tab>"] = cmp.mapping.scroll_docs(-4),

		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete({}),
	}),
	sources = {
		{ name = "tailwindcss" },
		{ name = "html-css", keyword_length = 2 },
		{ name = "nvim_lsp", keyword_length = 3 },
		{ name = "treesitter", keyword_length = 3 },
		{ name = "path", keyword_length = 3 },
		{ name = "rg", keyword_length = 3 },
		{ name = "buffer", keyword_length = 3 },
	},
	formatting = {
		expandable_indicator = true,
		fields = { "menu", "abbr", "kind" },
		format = require("lspkind").cmp_format({
			before = require("tailwind-tools.cmp").lspkind_format,
			menu = {
				buffer = "buf",
				nvim_lsp = "lsp",
				nvim_lsp_signature_help = "sign",
				path = "path",
				treesitter = "tree",
				latext_symbols = "lxt",
				tailwindcss = "tw",
				js = " ",
				rg = "rg",
			},
		}),
	},
})
