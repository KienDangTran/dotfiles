local M = {}

M.setup = function(on_attach, capabilities, handlers)
	require("lspconfig").bashls.setup {
		on_attach = on_attach,
		capabilities = capabilities,
		handlers = handlers,
	}
end

return M
