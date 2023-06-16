return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  ---@param opts PluginLspOpts
  config = function(plugin, opts)
    local lsp_settings = require("lazyvim.util")
    local jdtls = require("jdtls")
    -- local lsp_settings = require("lsp-config.common-lsp-settings")

    local root_markers = { ".git", "gradlew", "mvnw" }
    local root_dir = jdtls.setup.find_root(root_markers)
    local home = os.getenv("HOME")
    local jdt_dir = home .. "/.local/share/nvim/mason/packages/jdtls"
    local jdtls_jar_path = vim.fn.glob(jdt_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    local lombok_jar_path = jdt_dir .. "/plugins/lombok.jar"
    local jdtls_config_path = jdt_dir .. "/config_mac"
    local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

    -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
    local config = {}

    config.flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 80,
      server_side_fuzzy_completion = true,
    }

    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    config.cmd = {
      home .. "/.sdkman/candidates/java/17.0.4-oracle/bin/java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "-Xmx2G",
      "-javaagent:" .. lombok_jar_path,
      "-Xbootclasspath/a:" .. lombok_jar_path,
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      jdtls_jar_path,
      "-configuration",
      jdtls_config_path,
      "-data",
      workspace_dir,
    }

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    config.settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
        },
      },
    }

    config.on_init = function(client, _)
      client.notify("workspace/didChangeConfiguration", { settings = config.settings })
    end

    settings = {
      java = {
        configuration = {
          -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
          -- And search for `interface RuntimeOption`
          -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
          runtimes = {
            {
              name = "javaSE-17",
              path = home .. "/.sdkman/candidates/java/17.0.4-oracle",
            },
            {
              name = "JavaSE-11",
              path = home .. "/.sdkman/candidates/java/11.0.18-amzn",
            },
          },
        },
      },
    }

    config.on_attach = function(client, bufnr)
      jdtls.setup.add_commands()
      lsp_settings.on_attach(client, bufnr)
      -- java
      local opts = { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<m-o>", [[<cmd>lua require("jdtls").organize_imports()<cr>]], opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>df", [[<cmd>lua require("jdtls").test_class()<cr>]], opts)
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>dn",
        [[<cmd>lua require("jdtls").test_nearest_method()<cr>]],
        opts
      )
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "v",
        "crv",
        [[<esc><cmd>lua require("jdtls").extract_variable(true)<cr>]],
        opts
      )
      vim.api.nvim_buf_set_keymap(bufnr, "n", "crv", [[<cmd>lua require("jdtls").extract_variable()<cr>]], opts)
      vim.api.nvim_buf_set_keymap(bufnr, "v", "crm", [[<esc><cmd>lua require("jdtls").extract_method(true)<cr>]], opts)

      if client.server_capabilities.documentformattingprovider then
        vim.cmd([[
            augroup lspformatting
      			autocmd! * <buffer>
      			autocmd bufwritepre <buffer> lua vim.lsp.buf.formatting_sync()
      			autocmd bufwritepre <buffer> lua require("jdtls").organize_imports()
            augroup end
          ]])
      end

      -- UI
      local finders = require("telescope.finders")
      local sorters = require("telescope.sorters")
      local actions = require("telescope.actions")
      local pickers = require("telescope.pickers")
      jdtls.ui.pick_one_async = function(items, prompt, label_fn, cb)
        local pickerOpts = {}
        pickers
          .new(pickerOpts, {
            prompt_title = prompt,
            finder = finders.new_table({
              results = items,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = label_fn(entry),
                  ordinal = label_fn(entry),
                }
              end,
            }),
            sorter = sorters.get_generic_fuzzy_sorter(),
            attach_mappings = function(prompt_bufnr)
              actions.goto_file_selection_edit:replace(function()
                local selection = actions.get_selected_entry(prompt_bufnr)
                actions.close(prompt_bufnr)

                cb(selection.value)
              end)

              return true
            end,
          })
          :find()
      end

      -- nvim-dap setup
      -- With `hotcodereplace = "auto" the debug adapter will try to apply code changes
      -- require("jdtls").setup_dap({ hotcodereplace = "auto" })
    end

    config.capabilities = lsp_settings.capabilities
    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    config.init_options = {
      bundles = bundles,
      extendedClientCapabilities = extendedClientCapabilities,
    }

    -- config.handlers = lsp_settings.handlers

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    -- local bundles = {
    --   vim.fn.glob(
    --     home .. "/.config/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
    --   ),
    -- }
    --
    -- vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.config/vscode-java-test/server/*.jar"), "\n"))
    -- config.init_options = {
    --   bundles = bundles,
    -- }

    -- This starts a new client & server,
    -- or attaches to an existing client & server depending on the `root_dir`.
    jdtls.start_or_attach(config)
  end,
}
