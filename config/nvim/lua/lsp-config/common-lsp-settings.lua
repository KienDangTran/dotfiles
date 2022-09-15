local M = {}

-- after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)

	-- Mappings.
	-- Use an on_attach function to only map the following keys
	local opts = { noremap = true, silent = true }
	local keymap = vim.keymap.set

	-- illuminate
	require("illuminate").on_attach(client)
	vim.api.nvim_command [[hi def link LspReferenceText CursorLine]]
	vim.api.nvim_command [[hi def link LspReferenceWrite CursorLine]]
	vim.api.nvim_command [[hi def link LspReferenceRead CursorLine]]
	keymap("n", "<M-n>", [[<cmd>lua require"illuminate".next_reference{wrap=true}<cr>]], opts)
	keymap("n", "<M-p>", [[<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>]], opts)

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- lspsaga
	local lspsaga = require("lspsaga")
	lspsaga.init_lsp_saga({
		-- your configuration
		border_style = "bold",
		max_preview_lines = 20,
		move_in_saga = { prev = '<C-b>', next = '<C-f>' },
		code_action_keys = {
			quit = "<C-c>",
		},
		definition_action_keys = {
			quit = "<C-c>",
		},
		finder_action_keys = {
			quit = "<C-c>",
		},
		finder_request_timeout = 5000,
		show_outline = {
			auto_preview = false,
		},
	})

	-- scroll in hover doc or  definition preview window
	keymap("n", "<C-f>", function() lspsaga.action.smart_scroll_with_saga(1) end, opts)
	keymap("n", "<C-b>", function() lspsaga.action.smart_scroll_with_saga(-1) end, opts)
	-- Only jump to error
	keymap("n", "[E", function()
		lspsaga.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, opts)
	keymap("n", "]E", function()
		lspsaga.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, opts)

	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	keymap("n", "<leader>e", [[<cmd>lua vim.diagnostic.open_float()<CR>]], opts)
	keymap("n", "[e", [[<cmd>Lspsaga diagnostic_jump_next<CR>]], opts)
	keymap("n", "]e", [[<cmd>Lspsaga diagnostic_jump_prev<CR>]], opts)
	keymap("n", "<leader>q", [[<cmd>lua vim.diagnostic.setloclist()<CR>]], opts)

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	keymap("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
	keymap("n", "gd", [[<cmd>Lspsaga peek_definition<CR>]], opts)
	keymap("n", "<leader>gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts)
	keymap("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]], opts)
	keymap("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]], opts)
	keymap("n", "<leader>gs", [[<cmd>Lspsaga signature_help<CR>]], opts)
	keymap("n", "K", [[<cmd>Lspsaga hover_doc<CR>]], opts)
	keymap("n", "<leader>wa", [[<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>]], opts)
	keymap("n", "<leader>wr", [[<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>]], opts)
	keymap("n", "<leader>wl", [[<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>]], opts)
	keymap("n", "<leader>D", [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
	keymap("n", "<leader>rn", [[<cmd>Lspsaga rename<CR>]], opts)
	keymap("n", "<leader>ca", [[<cmd>Lspsaga code_action<CR>]], opts)
	keymap("v", "<leader>ca", [[<cmd><C-U>Lspsaga range_code_action<CR>]], opts)
	keymap("n", "<leader>f", [[<cmd>lua vim.lsp.buf.formatting()<CR>]], opts)
	keymap("n", "<leader>gh", [[<cmd>Lspsaga lsp_finder<CR>]], opts)
	keymap("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", { silent = true })

	if client.resolved_capabilities.document_formatting then
		vim.cmd([[
			augroup LspFormatting
				autocmd! * <buffer>
				autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
			augroup END
		]])
	end

end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

return M
