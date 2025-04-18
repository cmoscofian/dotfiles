local handlers = require("cmoscofian.lsp.handlers")

local M = {}

local set_diagnostics = function()
	local signs = {
		{ "DiagnosticSignError", "▶" },
		{ "DiagnosticSignWarn", "▶" },
		{ "DiagnosticSignHint", "▷" },
		{ "DiagnosticSignInfo", "▷" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign[1], {
			texthl = sign[1],
			text = sign[2],
			numhl = "" ,
		})
	end

	vim.diagnostic.config({
		virtual_text = false,
		signs = true,
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			border = "rounded",
			focusable = false,
			header = { "Diagnostics", "Title" },
			prefix = "",
			source = true,
		},
	})
end

local set_hover_handlers = function()
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

local set_highlight_document = function(client)
	if client.server_capabilities.documentHighlightProvider then
		local group_name = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
		vim.api.nvim_create_autocmd("CursorHold", {
			group = group_name,
			buffer = 0,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = group_name,
			buffer = 0,
			callback = vim.lsp.buf.clear_references,
		})
	end

	client.server_capabilities.semanticTokensProvider = nil
end

local set_keybinds_and_options = function(bufnr)
	local opts = { silent = true }

	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", {
		buf = bufnr,
	})

	vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<c-n>", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<c-p>", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "<leader>r", handlers.on_rename, opts)
	vim.keymap.set("n", "<leader>R", function() handlers.on_rename(true) end, opts)
	vim.keymap.set("n", "gh", vim.lsp.buf.format, opts)

	local status, telescope = pcall(require, "telescope.builtin")
	if status then
		vim.keymap.set("n", "gt", telescope.lsp_type_definitions, opts)
		vim.keymap.set("n", "gi", telescope.lsp_implementations, opts)
		vim.keymap.set("n", "gs", telescope.lsp_dynamic_workspace_symbols, opts)
		vim.keymap.set("n", "gr", handlers.on_reference, opts)
		vim.keymap.set("n", "gR", function() handlers.on_reference(true) end, opts)
	else
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end
end

M.set_capabilities = function()
	local std_capabilities = vim.lsp.protocol.make_client_capabilities()
	local status, cmp = pcall(require, "cmp_nvim_lsp")
	if not status then
		return std_capabilities
	end

	return cmp.default_capabilities(std_capabilities)
end

M.on_attach = function(client, bufnr)
	vim.cmd("command! -buffer -nargs=* RenameHandler lua require('cmoscofian.lsp.handlers').on_rename(<args>)")
	vim.cmd("command! -buffer -nargs=* ReferencesHandler lua require('cmoscofian.lsp.handlers').on_reference(<args>)")
	set_diagnostics()
	set_highlight_document(client)
	set_hover_handlers()
	set_keybinds_and_options(bufnr)
end

return M
