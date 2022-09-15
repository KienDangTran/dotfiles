-- Install packer
vim.cmd("packadd packer.nvim")

local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim" .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

-- plugins
require("packer").startup({
	function(use)
		use "wbthomason/packer.nvim" -- Package manager

		use {
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup()
			end,
		}

		-- theme
		use {
			"glepnir/zephyr-nvim",
			config = function()
				vim.cmd "colorscheme zephyr"
			end
		}

		-- Status bar
		use {
			"nvim-lualine/lualine.nvim",
			requires = {
				"kyazdani42/nvim-web-devicons",
			},
			config = function()
				require("plugins.lualine").setup()
			end,
		}

		-- files explorer
		use {
			"kyazdani42/nvim-tree.lua",
			requires = { "kyazdani42/nvim-web-devicons", opt = true, },
			config = function()
				require("plugins.nvim-tree").setup()
			end,
		}

		-- git ui
		use {
			"kdheepak/lazygit.nvim",
			config = function()
				vim.g.lazygit_floating_window_scaling_factor = 1.0
			end,
		}

		-- git indicator in editor
		use {
			"lewis6991/gitsigns.nvim",
			config = function()
				require("plugins.gitsigns").setup()
			end,
		}

		-- Tabs
		use {
			"akinsho/bufferline.nvim",
			tag = "v2.*",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("plugins.bufferline").setup()
			end,
		}

		-- completion
		use {
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-vsnip",
				"hrsh7th/vim-vsnip",
			},
			config = function()
				require("plugins.cmp").setup()
			end,
		}

		-- neovim language server configs
		use {
			"nvim-treesitter/nvim-treesitter",
			run = function()
				require('nvim-treesitter.install').update({ with_sync = true })
			end,
			config = function()
				require("plugins.treesitter").setup()
			end,
		}
		use { "neovim/nvim-lspconfig" }
		use({
			"glepnir/lspsaga.nvim",
			branch = "main",
		})

		-- java ls
		use { "mfussenegger/nvim-jdtls" }

		-- typescript ls
		use { "jose-elias-alvarez/nvim-lsp-ts-utils" }
		use { "p00f/nvim-ts-rainbow" }

		-- simple access to json-language-server schemae
		use { "b0o/schemastore.nvim" }

		-- lua ls
		use { "folke/lua-dev.nvim" }

		-- sql
		use "nanotee/sqls.nvim"

		-- DAP (Debug Adapter Protocol)
		use {
			"mfussenegger/nvim-dap",
			requires = {
				"rcarriga/nvim-dap-ui",
				"theHamsta/nvim-dap-virtual-text",
				"microsoft/vscode-node-debug2",
				"nvim-telescope/telescope-dap.nvim",
			},
			config = function()
				require("dap-config").setup()
			end,
		}

		use { "RRethy/vim-illuminate", }

		use {
			"folke/trouble.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("trouble").setup {
					auto_preview = false,
					auto_fold = true,
				}
			end
		}

		use {
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup {
					show_current_context = true,
					show_current_context_start = true,
				}
			end
		}

		use { "windwp/nvim-ts-autotag", }
		use {
			"windwp/nvim-autopairs",
			config = function()
				require("nvim-autopairs").setup {
					fast_wrap = {
						map = "<M-e>",
						chars = { "{", "[", "(", "\"", "\"" },
						pattern = string.gsub([[ [%"%"%)%>%]%)%}%,] ]], "%s+", ""),
						end_key = "$",
						keys = "qwertyuiopzxcvbnmasdfghjkl",
						check_comma = true,
						highlight = "Search",
						highlight_grey = "Comment"
					},
				}
			end
		}

		-- UI to select things (files, grep results, open buffers...)
		use {
			"nvim-telescope/telescope.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
				{ "nvim-telescope/telescope-dap.nvim" },
			},
			config = function()
				require("plugins.telescope").setup()
			end,
		}

		use { "gpanders/editorconfig.nvim" }

		use { "rcarriga/nvim-notify" }

	end,
})
