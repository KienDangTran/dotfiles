local settings = {
	Lua = {
		diagnostics = {
			globals = {
				"vim",
				"use",
				"describe",
				"it",
				"assert",
				"before_each",
				"after_each",
			},
		},
		completion = {
			showWord = "Disable",
			callSnippet = "Replace",
			keywordSnippet = "Disable",
		},
		workspace = {
			checkThirdParty = false,
			library = {
				["${3rd}/love2d/library"] = true,
			},
		},
	},
}

local M = {}

M.setup = function(on_attach, capabilities, handlers)
	require("neodev").setup()
	require("lspconfig").sumneko_lua.setup({
		settings = settings,
		flags = {
			debounce_text_changes = 150,
		},
		on_attach = on_attach,
		capabilities = capabilities,
		handlers = handlers,
	})
end

return M
