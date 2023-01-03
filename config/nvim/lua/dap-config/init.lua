local M = {}

local dap = require "dap"
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

	local dapui = require "dapui"

	dapui.setup {
		layouts = {
			{
				elements = {
					"scopes",
					"breakpoints",
					"watches",
				},
				size = 0.25, -- 25% of total lines
				position = "right",
			},
		},
	} -- use default
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
		dap.set_exception_breakpoints({})
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end
end

local function configure_keymaps()
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }

	keymap("n", "<leader>dR", [[<cmd>lua require"dap".run_to_cursor()<CR>]], opts)
	keymap("n", "<leader>dE", [[<cmd>lua require"dapui".eval(vim.fn.input "[Expression] > ")<CR>]], opts)
	keymap("n", "<leader>dC", [[<cmd>lua require"dap".set_breakpoint(vim.fn.input "[Condition] > ")<CR>]], opts)
	keymap("n", "<leader>dU", [[<cmd>lua require"dapui".toggle()<CR>]], opts)
	keymap("n", "<leader>db", [[<cmd>lua require"dap".step_back()<CR>]], opts)
	keymap("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]], opts)
	keymap("n", "<leader>dd", [[<cmd>lua require"dap".disconnect()<CR>]], opts)
	keymap("n", "<leader>de", [[<cmd>lua require"dapui".eval()<CR>]], opts)
	keymap("n", "<leader>dg", [[<cmd>lua require"dap".session()<CR>]], opts)
	keymap("n", "<leader>dh", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]], opts)
	keymap("n", "<leader>dS", [[<cmd>lua require"dap.ui.widgets".scopes()<CR>]], opts)
	keymap("n", "<leader>di", [[<cmd>lua require"dap".step_into()<CR>]], opts)
	keymap("n", "<leader>do", [[<cmd>lua require"dap".step_over()<CR>]], opts)
	keymap("n", "<leader>du", [[<cmd>lua require"dap".step_out()<CR>]], opts)
	keymap("n", "<leader>dp", [[<cmd>lua require"dap".pause.toggle()<CR>]], opts)
	keymap("n", "<leader>dq", [[<cmd>lua require"dap".close()<CR>]], opts)
	keymap("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]], opts)
	keymap("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]], opts)
	keymap("n", "<leader>dx", [[<cmd>lua require"dap".terminate()<CR>]], opts)
end

function M.setup()
	configure() -- Configuration
	configure_exts() -- Extensions
	configure_keymaps() -- keymap
end

return M
