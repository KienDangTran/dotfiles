return {
  "mfussenegger/nvim-jdtls",
  branch = "master",
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
