local M = {}

M.setup = function()
	local dap = require("dap")
	dap.adapters.node2 = {
		type = "executable",
		command = "node",
		args = { os.getenv("HOME") .. "/dev/tools/vscode-node-debug2/out/src/nodeDebug.js" },
	}

	dap.configurations.typescript = {
		{
			name = "node2:typescript:launch",
			type = "node2",
			request = "launch",
			program = "${file}",
			runtimeArgs = { "--inspect" },
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			smartStep = true,
			protocol = "inspector",
			console = "integratedTerminal",
			outFiles = { "./build/**/*.js" },
		},
		{
			-- For this to work you need to make sure the node process is started with the `--inspect` flag.
			name = "node2:typescript:attach-to-process",
			type = "node2",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			skipFiles = { "<node_internals>/**" },
			sourceMaps = true,
			smartStep = true,
			protocol = "inspector",
			processId = require "dap.utils".pick_process,
		},
	}

end

return M
