-- Set up language servers
local lsp_settings = require("lsp-config.common-lsp-settings")

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
	"sumneko_lua",
	"tsserver",
	"vscodels",
	"jsonls",
	"yamlls",
	"bashls",
	"dockerls",
}
for _, server in pairs(servers) do
	require("lsp-config." .. server).setup(
		lsp_settings.on_attach,
		lsp_settings.capabilities,
		lsp_settings.handlers
	)
end

-- Customizing how diagnostics are displayed
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		focusable = false,
		header = { " " .. " DIAGNOSTICS:", "Normal" },
		source = "always",
	},
	virtual_text = {
		spacing = 4,
		source = "always",
		prefix = "● ",
		update_in_insert = true,
		severity = {
			min = vim.diagnostic.severity.WARN,
		},
	},
})

vim.cmd [[
  augroup jdtls_lsp
    autocmd!
    autocmd FileType java lua require("lsp-config.jdtls").setup()
  augroup end
]]
