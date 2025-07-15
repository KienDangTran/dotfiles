return {
  "mfussenegger/nvim-jdtls",
  opts = {
    jdtls = function(opts)
      opts.settings = {
        java = {
          format = {
            enabled = false,
          },
        },
      }

      return opts
    end,
  },
}
