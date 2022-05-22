local M = {}
local scpath = require "scnvim/path"

-- Unpack csv file with tags into lua table
function M.scnvim_unpack_tags_table()
	local root = scpath.get_plugin_root_dir()
	local classes = scpath.get_cache_dir() .. "/tags"
	local tagsfile = io.open(classes)
	local help = {}

	for line in tagsfile:lines() do
		local tagname, tagpath, _, _= line:match("%s*(.-)\t%s*(.-)\t%s*(.-)\t%s*(.-)")
		help[tostring(tagname)] = tagpath
		-- print(tagname)
	end

	return help
end

function M.scnvim_help_keys()
	local help = M.scnvim_unpack_tags_table()
	local help_keys = {};

	for k,_ in pairs(help) do
		table.insert(help_keys, tostring(k))
	end

	return help_keys
end

function M.fzf_sc_help()
	local scnvim_help_open = require"scnvim/help".prepare_help_for

	local help = M.scnvim_unpack_tags_table()
	local help_keys = {};

	for k,_ in pairs(help) do
		table.insert(help_keys, tostring(k))
	end

	local specs = {["source"] = help_keys, ["sink"] = scnvim_help_open}

	vim.fn["fzf#run"](specs)

end

return M
