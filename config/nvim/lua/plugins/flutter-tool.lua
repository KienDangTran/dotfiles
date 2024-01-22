return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
    "Kuchteq/flutter-riverpod-snippets-luasnip-compatible",
  },
  ft = { "dart" },
  config = function()
    require("flutter-tools").setup({
      debugger = { -- integrate with nvim dap + install dart code debugger
        enabled = true,
        run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
        -- make sure .metadata dire exists in flutter project root dir
        -- https://github.com/akinsho/flutter-tools.nvim/blob/b65ad58462116785423d81aeb2ee6c8c16f78679/lua/flutter-tools/dap.lua#L20
      },
      fvm = true,
      widget_guides = {
        enabled = true,
      },
      lsp = {
        color = {
          enabled = true,
        },
      },
    })
  end,
}
