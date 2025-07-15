return {
  "neovim/nvim-lspconfig",
  keys = {
    { "gsh", "<cmd>Lspsaga lsp_finder<CR>", desc = "Lspsaga finder - Find the symbol's definition" },
    { "gsp", "<cmd>Lspsaga peek_definition<CR>", desc = "Lspsaga - Peek definition" },
    { "gst", "<cmd>Lspsaga peek_type_definition<CR>", desc = "Lspsaga - Peek type definition" },
    { "gsd", "<cmd>Lspsaga goto_definition<CR>", desc = "Lspsaga - Go to definition" },
    { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Lspsaga - Hover Doc" },
    { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
  },
}
