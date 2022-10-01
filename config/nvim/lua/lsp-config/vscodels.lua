local M = {}
M.setup = function(on_attach, capabilities, handlers)
	local lspconfig = require("lspconfig")

	lspconfig.eslint.setup({
		root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json"),
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
		settings = {
			format = {
				enable = true,
			},
		},
		capabilities = capabilities,
		handlers = handlers,
	})

	require 'lspconfig'.cssls.setup {
		on_attach = on_attach,
		capabilities = capabilities,
		handlers = handlers,
	}

	require 'lspconfig'.html.setup {
		on_attach = on_attach,
		capabilities = capabilities,
		handlers = handlers,
	}
end

return M
