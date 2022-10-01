local M = {}

M.setup = function()
	require 'nvim-treesitter'.define_modules {
		fold = {
			attach = function()
				vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
				vim.opt.foldmethod = 'expr'
				vim.cmd.normal 'zx' -- recompute folds
			end,
			detach = function() end,
		}
	}

	-- require 'treesitter-context'.setup {
	-- 	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	-- 	max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
	-- 	trim_scope = 'outer',
	-- }

	require("nvim-treesitter.install").prefer_git = true

	require("nvim-treesitter.configs").setup {
		ensure_installed = "all",
		ignore_install = { "phpdoc", "slint" },
		auto_install = true,
		sync_install = true,
		highlight = { enable = true },
		incremental_selection = { enable = true },
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
	}

end

return M
