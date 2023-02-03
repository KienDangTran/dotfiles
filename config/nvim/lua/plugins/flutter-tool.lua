return {
  "akinsho/flutter-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "dart" },
  ---@param opts PluginLspOpts
  config = function(plugin, opts)
    require("flutter-tools").setup({
      debugger = { -- integrate with nvim dap + install dart code debugger
        enabled = true,
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
