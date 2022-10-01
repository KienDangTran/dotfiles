local M = {}

M.setup = function()
	local dap = require("dap")
	-- local dartCodeRepoPath =
	local flutterSdkPath = "${workspaceFolder}/.fvm/flutter_sdk"

	dap.adapters.dart = {
		type = "executable",
		command = "node",
		args = { os.getenv("HOME") .. "/_dev/repos/Dart-Code/out/dist/debug.js", "flutter" },
	}
	dap.configurations.dart = {
		{
			name = "Launch flutter",
			type = "dart",
			request = "launch",
			cwd = "${workspaceFolder}",
			dartSdkPath = flutterSdkPath .. "/bin/cache/dart-sdk/",
			flutterSdkPath = flutterSdkPath,
			program = "${workspaceFolder}/lib/main.dart",
			flutterMode = "debug",
		}
	}

end

return M
