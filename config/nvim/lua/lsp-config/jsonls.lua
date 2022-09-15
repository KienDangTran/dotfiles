local M = {}

M.setup = function(on_attach, capabilities, handlers)
	require("lspconfig").jsonls.setup({
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
			},
		},
		setup = {
			commands = {
				Format = {
					function()
						vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
					end,
				},
			},
		},
		on_attach = on_attach,
		capabilities = capabilities,
		handlers = handlers,
	})
end

return M
