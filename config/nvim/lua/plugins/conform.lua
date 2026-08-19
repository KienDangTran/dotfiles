return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- Hook for format-on-save
  opts = {
    formatters_by_ft = {
      java = { "spotless" },
    },
    formatters = {
      spotless = {
        -- Invoke your build system wrapper script or command directly
        command = function()
          if vim.fn.filereadable("gradlew") == 1 then
            return "./gradlew"
          elseif vim.fn.filereadable("mvnw") == 1 then
            return "./mvnw"
          end
          return "spotless" -- fallback to global if available
        end,
        -- Arguments matching your build tool execution requirements
        args = function()
          if vim.fn.filereadable("gradlew") == 1 then
            return { "spotlessApply" }
          elseif vim.fn.filereadable("mvnw") == 1 then
            return { "spotless:apply" }
          end
          return {}
        end,
        stdin = false, -- Spotless modifies files on disk rather than reading stdin
        tmpfile_format = ".conform.$RANDOM.$FILENAME",
      },
    },
    format_on_save = {
      lsp_fallback = false, -- Disable fallback to JDTLS formatting
      timeout_ms = 1000,
    },
  },
}
