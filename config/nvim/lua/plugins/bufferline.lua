local M = {}

M.setup = function()
	require("bufferline").setup {
		options = {
			mode = "buffers",
			modified_icon = "✎",
			separator_style = "thick",
			show_tab_indicators = true,
			enforce_regular_tabs = false,
			show_buffer_close_icons = true,
			always_show_bufferline = true,
			right_mouse_command = "Bdelete! %d",
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,
			offsets = {
				{
					filetype = "NvimTree",
					text = "",
					highlight = "Directory",
					text_align = "left",
					padding = 1,
				},
				{
					filetype = "Outline",
					text = "",
					highlight = "Directory",
					text_align = "left",
					padding = 1,
				},
			},
		},
	}

	-- move through buffers
	vim.api.nvim_set_keymap("n", "<Leader>[", ":bp!<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<Leader>]", ":bn!<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<leader><esc>", ":nohlsearch<cr>", { noremap = true })

end

return M
