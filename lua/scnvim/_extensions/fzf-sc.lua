-- local fzf-sc = require 'scnvim._extensions.fzf-sc.main'
local commands = require 'scnvim._extensions.fzf-sc.main'

local function register_command()
vim.cmd[[
function s:fzfsc_coplete(arg,line,pos)
	let l:commands = luaeval("require'scnvim._extensions.fzf-sc.main'.get_command_names()")
    return join(sort(commands), "\n")
endfunction

command! -nargs=? -complete=custom,s:fzfsc_complete FzfSC lua require('scnvim._extensions.fzf-sc.main').load_command(<f-args>)
]]
end

return require'scnvim'.register_extension {
setup = function(ext_config, user_config)
	commands.search_plugin = ext_config.search_plugin or "nvim-fzf"

	local default_options = {
		height = 50,
		width = 50,
		-- row = 4,
		-- col = 4,
		relative = 'editor',
		border = false,
		fzf_binary = "fzf"
	}

	commands.options = default_options

	for opt_name,v in pairs(default_options) do
		if ext_config.options then
			commands.options[opt_name] = ext_config.options[opt_name] or v
		end
	end

	register_command()
end,

exports = {
	-- List all finders if no argument added.
	-- If a string is added as argument, it will use that string as the name of a finder, eg. SCNvimExt fzf-sc.fuzz help
	fuzz = commands.load_command,
},

--- Health checks
--- This function will be executed by :checkhealth scnvim
health = function()
	local health = require 'health'
	health.report_ok 'all is good'
end,
}
