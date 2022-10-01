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
			callSnippet = "Disable",
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
	local luadev = require("lua-dev").setup({
		lspconfig = {
			settings = settings,
			flags = {
				debounce_text_changes = 150,
			},
			on_attach = on_attach,
			capabilities = capabilities,
			handlers = handlers,
		},
	})
	require("lspconfig").sumneko_lua.setup(luadev)
end

return M
