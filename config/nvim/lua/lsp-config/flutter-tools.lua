local M = {}

M.setup = function()
	local lsp_settings = require("lsp-config.common-lsp-settings");

	require("flutter-tools").setup {
		debugger = { -- integrate with nvim dap + install dart code debugger
			enabled = true,
			run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
			register_configurations = function(paths)
				require("dap-config.dart").setup()
			end,
		},
		dev_log = {
			enabled = false,
		},
		fvm = true,
		widget_guides = {
			enabled = true,
		},
		lsp = {
			on_attach = lsp_settings.on_attach,
			capabilities = lsp_settings.capabilities,
			handlers = lsp_settings.handlers,
			settings = {
				showTodos = false,
			},
		},
	}
end

return M
