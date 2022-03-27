local M = {}

function M.setup(user_settings)

	local settings = user_settings or {}

	M.search_plugin = settings.search_plugin or "fzf.vim"

	local default_options = {
		height = 50,
		width = 50,
		-- row = 4,
		-- col = 4,
		relative = 'editor',
		border = false,
		fzf_binary = "fzf"
	}

	M.options = settings.options or {}
	for opt_name,v in pairs(default_options) do
		M.options[opt_name] = M.options[opt_name] or v
	end

	M.register_command()
end

function M.register_command()
vim.cmd[[
function s:fzfsc_complete(arg,line,pos)
	let l:commands = luaeval("require'fzf-sc.cmd'.get_command_names()")
    return join(sort(commands), "\n")
endfunction

command! -nargs=? -complete=custom,s:fzfsc_complete FzfSC lua require('fzf-sc.cmd').load_command(<f-args>)
]]
end

return M
