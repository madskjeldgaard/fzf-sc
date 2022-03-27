local M = {}
local finders = require"fzf-sc/finders"

-- This will fuzzy over all available commands
function M.fuzzy_commands()
	if require'fzf-sc'.search_plugin == "nvim-fzf" then
		coroutine.wrap(function()
			local result = require'fzf'.fzf(M.get_command_names(), "", require"fzf-sc".options);
			if result then
				M.load_command(result[1])
				-- sinkFunction(result[1])
			end;
		end)();

	  vim.cmd[[startinsert]]

		-- If using fzf.vim
	elseif require'fzf-sc'.search_plugin == "fzf.vim" then
		-- TODO: Not tested
		local specs = {["source"] = M.get_command_names(), ["sink"] = M.load_command}
		vim.fn["fzf#run"](specs)
	else
		error("fzf-sc: No fzf plugin defined")
	end
end

function M.load_command(command)
	if command ~= nil then
		-- FIXME: This is a hack. When the command is chosen using fuzzy_commands, vim will go into normal mode before opening up the chosen fuzzy finder.
		finders[command]()
	else
		M.fuzzy_commands()
	end
end

function M.get_command_names()
	local keys = vim.tbl_keys(require"fzf-sc/finders")
	table.sort(keys)
	return keys
end

return M
