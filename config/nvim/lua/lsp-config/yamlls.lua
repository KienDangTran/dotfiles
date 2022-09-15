local M = {}

M.setup = function(on_attach, capabilities, handlers)
	require("lspconfig").yamlls.setup {
		settings = {
			yaml = {
				schemas = {
					kubernetes = { "/*.k8s.yaml", "/*.k8s.yml" },
					["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
					["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = {
						"/*.openapi.yml",
						"/*.openapi.yaml",
						"/*.swagger.yml",
						"/*.swagger.yaml",
					}
				},
				schemaDownload = { enable = true },
				validate = true,
				format = { enable = true },
			},
		},
		on_attach = on_attach,
		capabilities = capabilities,
		handlers = handlers,
	}
end

return M
