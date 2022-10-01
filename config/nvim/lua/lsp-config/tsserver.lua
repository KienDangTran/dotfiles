local M = {}

M.setup = function(on_attach, capabilities, handlers)
	local lspconfig = require("lspconfig")
	local ts_utils = require("nvim-lsp-ts-utils")

	lspconfig.tsserver.setup({
		root_dir = lspconfig.util.root_pattern("package.json"),
		init_options = ts_utils.init_options,
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)

			ts_utils.setup({
				-- debug = true,
				import_all_scan_buffers = 100,
				update_imports_on_move = true,
				-- filter out dumb module warning
				filter_out_diagnostics_by_code = { 80001 },
			})
			ts_utils.setup_client(client)

			local opts = { noremap = true, silent = true }
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", ":TSLspRenameFile<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "go", ":TSLspImportAll<CR>", opts)

			if client.server_capabilities.documentFormattingProvider then
				vim.cmd([[
          augroup LspFormatting
              autocmd! * <buffer>
              autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
              autocmd BufWritePre <buffer> lua require("nvim-lsp-ts-utils").organize_imports_sync()
          augroup END
        ]])
			end
		end,
		flags = {
			debounce_text_changes = 150,
		},
		capabilities = capabilities,
		handlers = handlers
	})

	-- DAP
	require("dap-config.node2").setup()

end

return M
