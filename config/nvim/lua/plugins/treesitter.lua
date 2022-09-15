local M = {}

M.setup = function()
	require("nvim-treesitter.install").prefer_git = true

	require("nvim-treesitter.configs").setup {
		ensure_installed = "all",
		ignore_install = { "phpdoc" },
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
		}
	}

end

return M
