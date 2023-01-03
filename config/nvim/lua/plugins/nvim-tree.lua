local M = {}

M.setup = function()
	-- each of these are documented in `:help nvim-tree.OPTION_NAME`
	require "nvim-tree".setup {
		open_on_tab = true,
		hijack_unnamed_buffer_when_opening = true,
		actions = {
			open_file = {
				resize_window = true,
			},
		},
		diagnostics = {
			enable = true,
		},
		update_focused_file = {
			enable = true,
		},
		view = {
			adaptive_size = true,
			centralize_selection = true,
			preserve_window_proportions = true
		},
		renderer = {
			group_empty = true,
			highlight_git = true,
			highlight_opened_files = "all",
			indent_markers = {
				enable = true,
			},
			icons = {
			},
		},
		trash = {
			cmd = "trash",
			require_confirm = true
		},
		git = {
			ignore = false,
		}
	}

	vim.api.nvim_set_keymap("n", "<Leader>t", [[<cmd>lua require"nvim-tree".toggle(false,true)<CR>]],
		{ silent = true, noremap = true }) -- toggle NvimTree

	-- automatically close the tab/vim when nvim-tree is the last window in the tab
	-- vim.api.nvim_create_autocmd("BufEnter", {
	-- 	nested = true,
	-- 	callback = function()
	-- 		if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
	-- 			vim.cmd "quit"
	-- 		end
	-- 	end
	-- })
end

return M
