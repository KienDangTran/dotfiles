return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter").define_modules({
        fold = {
          attach = function()
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt.foldmethod = "expr"
            vim.cmd.normal("zx") -- recompute folds
          end,
          detach = function() end,
        },
      })

      -- require 'treesitter-context'.setup {
      -- 	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      -- 	max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
      -- 	trim_scope = 'outer',
      -- }

      require("nvim-treesitter.install").prefer_git = true

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "clojure",
          "comment",
          "cpp",
          "css",
          "dart",
          "diff",
          "dockerfile",
          "git_rebase",
          "gitattributes",
          "gitignore",
          "go",
          "graphql",
          "hcl",
          "help",
          "html",
          "http",
          "java",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "kotlin",
          "lua",
          "markdown",
          "markdown_inline",
          "proto",
          "python",
          "regex",
          "ruby",
          "rust",
          "scss",
          "solidity",
          "sql",
          "swift",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        ignore_install = { "phpdoc", "slint" },
        auto_install = true,
        sync_install = true,
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          init_selection = "gnn", -- set to `false` to disable one of the mappings
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
        -- plugins
        autopairs = { enable = true },
        autotag = { enable = true },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        textsubjects = {
          enable = true,
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
          },
        },
        endwise = { enable = true },
        indent = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
        },
      })
    end,
  },
}
