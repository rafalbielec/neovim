local lsp = require("lspconfig")
local util = require("lspconfig/util")

-- lsp hints
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- configure virtual_text
local function setup_diags()
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		signs = true,
		update_in_insert = false,
		underline = true,
	})

	vim.diagnostic.config({
		virtual_text = false,
		signs = true,
		underline = true,
		update_in_insert = true,
		severity_sort = false,
	})
end
setup_diags()

-- lsp capabilities
local function getcap()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	-- this is for the roslyn lsp
	capabilities = vim.tbl_deep_extend("force", capabilities, {
		textDocument = {
			diagnostic = {
				dynamicRegistration = true,
			},
		},
	})

	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

	return capabilities
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local bufnr = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and vim.tbl_contains({ "null-ls" }, client.name) then
			return
		end

		require("lsp_signature").on_attach({}, bufnr)

		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { silent = true, buffer = event.buf, desc = "[L]SP: " .. desc })
		end

		map("<leader>ls", vim.lsp.buf.signature_help, "signature")
		map("<leader>lh", vim.lsp.buf.hover, "hover")
		map("<leader>lf", vim.lsp.buf.format, "format")
		map("<leader>la", vim.lsp.buf.code_action, "code action")
		map("<leader>le", vim.lsp.buf.definition, "definition")
		map("<leader>lc", vim.lsp.buf.declaration, "declaration")
		map("<leader>lt", vim.lsp.buf.type_definition, "type inspection")
		map("<leader>li", vim.lsp.buf.implementation, "implementation")
		map("<leader>lr", vim.lsp.buf.references, "references")
		map("<leader>ln", vim.lsp.buf.rename, "rename")

		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			-- Show inlay_hint by default unless in Insert mode
			vim.lsp.inlay_hint.enable(true)

			local cmd1 = vim.api.nvim_create_autocmd({ "InsertEnter" }, {
				callback = function()
					vim.lsp.inlay_hint.enable(false)
				end,
			})

			local cmd2 = vim.api.nvim_create_autocmd({ "InsertLeavePre" }, {
				callback = function()
					vim.lsp.inlay_hint.enable(true)
				end,
			})

			-- If supported by the client, then highlight all the words that the cursor is
			if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
				local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})
			end

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					pcall(function()
						vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
						vim.api.nvim_del_autocmd(cmd1)
						vim.api.nvim_del_autocmd(cmd2)
					end)
				end,
			})
		end
	end,
})

-- lsp diagnostics
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	group = vim.api.nvim_create_augroup("float_diagnostic_cursor", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	end,
})

-- XML formatting and validation
lsp.lemminx.setup({
	capabilities = getcap(),
	filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
	cmd = { "lemminx-osx-aarch_64" },
})

lsp.html.setup({
	capabilities = getcap(),
	filetypes = { "html" },
})

require("tailwind-tools").setup({
	capabilities = getcap(),
	root_dir = function(fname)
		return util.root_pattern("tailwind.config.mjs")(fname)
	end,
})

local function root_pattern_excludes(opt)
	local root = opt.root
	local exclude = opt.exclude

	local function matches(path, pattern)
		return 0 < #vim.fn.glob(util.path.join(path, pattern))
	end

	return function(startpath)
		return util.search_ancestors(startpath, function(path)
			return matches(path, root) and not matches(path, exclude)
		end)
	end
end

lsp.denols.setup({
	capabilities = getcap(),
	root_dir = root_pattern_excludes({
		root = "deno.json",
		exclude = "package.json",
	}),
})

require("typescript-tools").setup({
	capabilities = getcap(),
	single_file_support = false,
	root_dir = root_pattern_excludes({
		root = "package.json",
		exclude = "deno.json",
	}),
	settings = {
		-- spawn additional tsserver instance to calculate diagnostics on it
		separate_diagnostic_server = true,
		-- "change"|"insert_leave" determine when the client asks the server about diagnostic
		publish_diagnostic_on = "insert_leave",
		-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
		-- "remove_unused_imports"|"organize_imports") -- or string "all"
		-- to include all supported code actions
		-- specify commands exposed as code_actions
		expose_as_code_action = {},
		-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
		-- not exists then standard path resolution strategy is applied
		tsserver_path = nil,
		-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
		-- (see 💅 `styled-components` support section)
		tsserver_plugins = {},
		-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
		-- memory limit in megabytes or "auto"(basically no limit)
		tsserver_max_memory = "auto",
		-- described below
		tsserver_format_options = {},
		tsserver_file_preferences = {},
		-- locale of all tsserver messages, supported locales you can find here:
		-- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
		tsserver_locale = "en",
		-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
		complete_function_calls = false,
		include_completions_with_insert_text = true,
		-- CodeLens
		-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
		-- possible values: ("off"|"all"|"implementations_only"|"references_only")
		code_lens = "off",
		-- by default code lenses are displayed on all referencable values and for some of you it can
		-- be too much this option reduce count of them by removing member references from lenses
		disable_member_code_lens = true,
		-- JSXCloseTag
		-- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
		-- that maybe have a conflict if enable this feature. )
		jsx_close_tag = {
			enable = false,
			filetypes = { "javascriptreact", "typescriptreact" },
		},
	},
})

-- npm install -g @astrojs/language-server
lsp.astro.setup({
	capabilities = getcap(),
	filetypes = { "astro" },
})

lsp.cssls.setup({
	capabilities = getcap(),
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		less = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		scss = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
	filetypes = { "css", "scss", "less", "sass" },
})

lsp.lua_ls.setup({
	capabilities = getcap(),
	on_init = function(client)
		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				-- library = { vim.env.VIMRUNTIME },
				library = vim.api.nvim_get_runtime_file("", true),
			},
		})
	end,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				disable = { "redundant-parameter" },
			},
		},
	},
})

-- biome.js formatting and validation tool
lsp.biome.setup({
	cmd = { "biome", "lsp-proxy" },
	root_dir = function(fname)
		return util.root_pattern("biome.json", "biome.jsonc")(fname)
			or util.find_package_json_ancestor(fname)
			or util.find_node_modules_ancestor(fname)
			or util.find_git_ancestor(fname)
	end,
	single_file_support = false,
	filetypes = {
		"graphql",
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"typescript",
		"jsx",
		"tsx",
		"typescript",
		"typescriptreact",
		"vue",
		"astro",
	},
})

require("roslyn").setup({
	filewatching = true,
	exe = {
		"dotnet",
		"/Users/raf/lsp/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll",
	},
	args = { "--logLevel=Warning", "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()) },
	config = {
		single_file_support = false,
		capabilities = getcap(),
		filetypes = { "cs", "csproj", "sln", "csharp" },
		cmd = {},
		autostart = true,
		settings = {
			["csharp|background_analysis"] = {
				dotnet_analyzer_diagnostics_scope = "fullSolution",
				dotnet_compiler_diagnostics_scope = "fullSolution",
			},
			["csharp|inlay_hints"] = {
				csharp_enable_inlay_hints_for_implicit_object_creation = true,
				csharp_enable_inlay_hints_for_implicit_variable_types = true,
				csharp_enable_inlay_hints_for_lambda_parameter_types = true,
				csharp_enable_inlay_hints_for_types = true,
				dotnet_enable_inlay_hints_for_indexer_parameters = true,
				dotnet_enable_inlay_hints_for_literal_parameters = true,
				dotnet_enable_inlay_hints_for_object_creation_parameters = true,
				dotnet_enable_inlay_hints_for_other_parameters = true,
				dotnet_enable_inlay_hints_for_parameters = true,
				dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
				dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
				dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
			},
			["csharp|code_lens"] = {
				dotnet_enable_references_code_lens = true,
			},
		},
	},
})
