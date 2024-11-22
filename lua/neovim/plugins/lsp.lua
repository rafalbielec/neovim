local lsp = require("lspconfig")

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

	return capabilities
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { silent = true, buffer = event.buf, desc = "[L]SP: " .. desc })
		end

		map("<leader>ls", vim.lsp.buf.signature_help, "signature")
		map("<leader>lh", vim.lsp.buf.hover, "hover")
		map("<leader>la", vim.lsp.buf.code_action, "code action")
		map("<leader>le", vim.lsp.buf.definition, "definition")
		map("<leader>lc", vim.lsp.buf.declaration, "declaration")
		map("<leader>lt", vim.lsp.buf.type_definition, "type inspection")
		map("<leader>li", vim.lsp.buf.implementation, "implementation")
		map("<leader>lr", vim.lsp.buf.references, "references")
		map("<leader>ln", vim.lsp.buf.rename, "rename")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
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
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
					vim.api.nvim_del_autocmd(cmd1)
					vim.api.nvim_del_autocmd(cmd2)
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
			-- diagnostics = { disable = { 'missing-fields' } },
		},
	},
})

-- biome.js formatting and validation tool
lsp.biome.setup({
	cmd = { "biome", "lsp-proxy" },
	root_dir = function(fname)
		local util = require("lspconfig.util")
		return util.root_pattern("biome.json", "biome.jsonc")(fname)
			or util.find_package_json_ancestor(fname)
			or util.find_node_modules_ancestor(fname)
			or util.find_git_ancestor(fname)
	end,
	single_file_support = false,
	filetypes = {
		"astro",
		"css",
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
	},
})

require("roslyn").setup({
	filewatching = true,
	exe = {
		"dotnet",
		"/Users/personal/lsp/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll",
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
