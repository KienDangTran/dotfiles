return {
  "nvim-neotest/neotest",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
  },
  opts = { adapters = { "neotest-plenary", "neotest-jest", "neotest-vitest" } },
}
