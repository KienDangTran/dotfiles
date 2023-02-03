return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "stylua",
      "shellcheck",
      "shfmt",
      "dockerfile-language-server",
      "yaml-language-server",
      "terraform-ls",
      "tflint",
    },
  },
}
