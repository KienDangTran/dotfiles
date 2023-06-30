return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    -- LSP Server Settings
    ---@type lspconfig.options
    servers = {
      eslint = {},
      solargraph = {
        settings = {
          solargraph = {
            useBundler = true,
            diagnostic = true,
            completion = true,
            hover = true,
            formatting = true,
            symbols = true,
            definitions = true,
            rename = true,
            references = true,
            folding = true,
          },
        },
      },
    },
    setup = {
      eslint = function()
        require("lazyvim.util").on_attach(function(client)
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,
    },
  },
  keys = {
    { "gh", "<cmd>Lspsaga lsp_finder<CR>", desc = "Lspsaga finder - Find the symbol's definition" },
    { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Lspsaga - Peek definition" },
    { "gt", "<cmd>Lspsaga peek_type_definition<CR>", desc = "Lspsaga - Peek type definition" },
    -- { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "Lspsaga - Go to definition" },
    { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Lspsaga - Hover Doc" },
    { "<leader>cs", "<cmd>Lspsaga outline<CR>", desc = "Lspsaga - Toggle outline" },
  },
}
