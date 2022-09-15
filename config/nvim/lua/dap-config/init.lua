local M = {}

local function configure()
	vim.fn.sign_define(
		"DapBreakpoint",
		{ text = "🛑", texthl = "", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"DapStopped",
		{ text = "🟢", texthl = "", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = "🟡", texthl = "", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"DapLogPoint",
		{ text = "🔵", texthl = "", linehl = "", numhl = "" }
	)
end

local function configure_exts()
	require("nvim-dap-virtual-text").setup {
		commented = true,
	}

	local dap, dapui = require "dap", require "dapui"
	dapui.setup {} -- use default
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end
end

local function configure_debuggers()
	require("dap-config.node2").setup()
end

local function configure_keymaps()
	local opts = { noremap = true, silent = true }

	vim.api.nvim_set_keymap("n", "<leader>dR", [[<cmd>lua require"dap".run_to_cursor()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dE", [[<cmd>lua require"dapui".eval(vim.fn.input "[Expression] > ")<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dC", [[<cmd>lua require"dap".set_breakpoint(vim.fn.input "[Condition] > ")<CR>]],
		opts)
	vim.api.nvim_set_keymap("n", "<leader>dU", [[<cmd>lua require"dapui".toggle()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>db", [[<cmd>lua require"dap".step_back()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dd", [[<cmd>lua require"dap".disconnect()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>de", [[<cmd>lua require"dapui".eval()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dg", [[<cmd>lua require"dap".session()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dh", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dS", [[<cmd>lua require"dap.ui.widgets".scopes()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>di", [[<cmd>lua require"dap".step_into()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>do", [[<cmd>lua require"dap".step_over()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>du", [[<cmd>lua require"dap".step_out()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dp", [[<cmd>lua require"dap".pause.toggle()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dq", [[<cmd>lua require"dap".close()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]], opts)
	vim.api.nvim_set_keymap("n", "<leader>dx", [[<cmd>lua require"dap".terminate()<CR>]], opts)
end

function M.setup()
	configure() -- Configuration
	configure_exts() -- Extensions
	configure_debuggers() -- Debugger
	configure_keymaps() -- keymap
end

configure_debuggers()

return M
