-- telescope
local M = {}

M.setup = function()
	local telescope = require("telescope")
	local action_layout = require("telescope.actions.layout")
	local previewers = require("telescope.previewers")

	-- Dont preview binaries
	local Job = require("plenary.job")
	local new_maker = function(filepath, bufnr, opts)
		filepath = vim.fn.expand(filepath)
		Job:new({
			command = "file",
			args = { "--mime-type", "-b", filepath },
			on_exit = function(j)
				local mime_type = vim.split(j:result()[1], "/")[1]
				if mime_type == "text" then
					previewers.buffer_previewer_maker(filepath, bufnr, opts)
				else
					-- maybe we want to write something to the buffer here
					vim.schedule(function()
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
					end)
				end
			end
		}):sync()
	end

	telescope.setup({
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
			},
		},
		defaults = {
			buffer_previewer_maker = new_maker,
			mappings = {
				n = {
					["<f4>"] = action_layout.toggle_preview
				},
				i = {
					["<f4>"] = action_layout.toggle_preview
				},
			},
			file_ignore_patterns = {
				"node_modules/",
				".git/",
				"yarn.lock",
				"coverage/"
			}
		},
		pickers = {
			find_files = {
				themes = "dropdown",
				find_command = { "fd", "--type", "f", "--hidden", "--follow", "--strip-cwd-prefix" }
			},
		}
	})

	-- Enable telescope fzf native
	telescope.load_extension("fzf")
	telescope.load_extension("dap")
	telescope.load_extension("lazygit")
	telescope.load_extension("flutter")

	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "<leader><space>", [[<cmd>lua require("telescope.builtin").buffers()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>ff", [[<cmd>lua require("telescope.builtin").find_files({previewer = false})<CR>]]
		, opts)
	vim.api.nvim_set_keymap("n", "<leader>sb", [[<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>]],
		opts)
	vim.api.nvim_set_keymap("n", "<leader>sh", [[<cmd>lua require("telescope.builtin").help_tags()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>st", [[<cmd>lua require("telescope.builtin").tags()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>sd", [[<cmd>lua require("telescope.builtin").grep_string()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>sp", [[<cmd>lua require("telescope.builtin").live_grep()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>so",
		[[<cmd>lua require("telescope.builtin").tags{ only_current_buffer = true }<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>?", [[<cmd>lua require("telescope.builtin").oldfiles()<CR>]], opts)

	-- wrap previewer
	vim.cmd([[
		augroup telescope
			autocmd User TelescopePreviewerLoaded setlocal wrap
		augroup END
	]])

end

M.project_files = function()
	local opts = {} -- define here if you want to define something
	local ok = pcall(require "telescope.builtin".git_files, opts)
	if not ok then require "telescope.builtin".find_files(opts) end
end

return M
