local M = {}

local finders = require"scnvim._extensions.fzf-sc.finders"

function M.get_command_names()
	local keys = vim.tbl_keys(finders)
	table.sort(keys)
	return keys
end

-- This will fuzzy over all available commands
function M.fuzzy_commands()
	coroutine.wrap(function()
		local result = require'fzf'.fzf(M.get_command_names(), "", M.options);
		if result then
			M.load_command(result[1])
			-- sinkFunction(result[1])
		end;
	end)();

	vim.cmd[[startinsert]]
end

function M.load_command(command)
	-- if not require"scnvim/sclang".is_running() then
	-- 	print("[fzf-sc] sclang not running")
	-- 	return
	-- else
		if command ~= nil then
			finders[command]()
		else
			M.fuzzy_commands()
		end
	-- end
end

return M
