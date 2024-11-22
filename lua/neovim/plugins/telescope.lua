require("telescope").setup({
	pickers = {
		colorscheme = {
			enable_preview = true,
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		},
	},
	defaults = {
		mappings = {
			i = {
				["<Esc>"] = require("telescope.actions").close,
			},
		},
		file_ignore_patterns = {
			-- Files
			"%.mkv",
			"%.mp4",
			"%.avi",
			"%.out",
			"%.pdf",
			"%.zip",
			".DS_Store",
			-- Directories
			".vscode",
			".cache",
			".git/",
			".github/",
			"node_modules/",
			"obj/",
			"bin/",
		},
	},
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local b = require("telescope.builtin")
local k = vim.keymap.set

k("n", "<leader>d", b.find_files, { noremap = true, silent = true, desc = "[D]o file search" })
k("n", "<leader><leader>", b.buffers, { noremap = true, silent = true, desc = "Switch buffers" })
k("n", "<leader>g", b.live_grep, { noremap = true, silent = true, desc = "[G]rep files" })
k("n", "<leader>r", b.registers, { noremap = true, silent = true, desc = "[R]registers" })
k("n", "<leader>s", b.lsp_document_symbols, { noremap = true, silent = true, desc = "[S]ymbols" })
k("n", "<leader>t", b.treesitter, { noremap = true, silent = true, desc = "[T]reesitter symbols" })
k("n", "<leader>x", b.diagnostics, { noremap = true, silent = true, desc = "Show diagnostics" })
