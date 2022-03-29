local M = {}
local action = require("fzf.actions").action

-- ------------------------------------
-- Utilities
-- ------------------------------------

-- @FIXME Only works for initial boot
M.booted = false;
function M.serverHasBooted()
	require"scnvim".eval("s.hasBooted", function(result)
		if result then
			M.booted = result
		end
	end)

	return M.booted

end

function M.rm_whitespace(instring)
	return string.gsub(instring, "%s", "");
end

-- Remove brackets and extraneous whitespace
function M.strip(arrayAsString)
	arrayAsString = string.gsub(arrayAsString, "%[", "");
	arrayAsString = string.gsub(arrayAsString, "%]", "");

	return arrayAsString
end

-- Takes a supercolldier array as string, eg "[1, 2, 3]" and spits out a lua table
function M.split_string_to_array(arrayAsString)
	local t = {};

	arrayAsString = M.rm_whitespace(arrayAsString)
	arrayAsString = M.strip(arrayAsString)

	local sep = ",";

	for str in string.gmatch(arrayAsString, "([^"..sep.."]+)") do
		table.insert(t, str);
	end;

	return t
end

-- sc_code is a string containing supercollider code that produces an array, eg [[Quarks.all]]
-- callback_sc_code is a format string with the supercollider code that will be executed with the chosen item insert, eg "Quarks.install(\"%s\");"
-- prompt is a string that will be displayed as the prompt
-- preview is a function that will be used as callback for the preview. It's return value is displayed in the preview window. If nil, then no preview window is displayed.
-- preview_size is the size of the preview window. Default is 10. If you only need the preview function as a callback, set this to 0
function M.fzf_sc_eval(sc_code, callback, prompt, preview, preview_size)
	assert(sc_code)
	assert(callback)

	if not require"scnvim/sclang".is_running() then
		print("[fzf-sc] sclang is not running")
	end

	require'scnvim'.eval(sc_code,
		function (returnVal)
			local scReturnVal = M.split_string_to_array(returnVal)

			-- Callback function
			local sinkFunction;

			if type(callback) == "string" then
				sinkFunction = function (val)
					local formatted = string.format(callback, val)
					-- print(formatted)
					require'scnvim'.send(formatted)
				end;
			elseif type(callback) == "function" then
				sinkFunction = function (val)
					callback(val)
				end
			else
				print("[fzf-sc] callback is wrong type")
				return
			end

			-- If using nvim-fzf
			if require'fzf-sc'.search_plugin == "nvim-fzf" then
				-- Preview
				-- Inspiration: https://github.com/vijaymarupudi/nvim-fzf-commands/blob/master/lua/fzf-commands/bufferpicker.lua
				local preview_function

				if not prompt then prompt = "fzf-sc: " end
				-- if not header then header = "" end
-- "--header " .. header ..
				local fzfopts =  "--ansi --prompt " .. prompt .. " "
				if preview then
					-- coroutine.wrap(function ()
					preview_function = action(preview)
					-- end)

					if not preview_size then preview_size = "10" end
					fzfopts = fzfopts .. "--preview=" .. preview_function .. " --preview-window bottom:" .. preview_size .. " "
				end

				coroutine.wrap(function()
					local result = require'fzf'.fzf(scReturnVal, fzfopts, require"fzf-sc".options);
					if result then
						-- print(result[1])
						sinkFunction(result[1])
					end;
				end)();

				-- If using fzf.vim
			elseif require'fzf-sc'.search_plugin == "fzf.vim" then
				local specs = {["source"] = scReturnVal, ["sink"] = sinkFunction}
				vim.fn["fzf#run"](specs)
			else
				error("fzf-sc: No fzf plugin defined")
			end

		end
	)
end

function scnvim_unpack_tags_table()
	local root = require'scnvim.utils'.get_scnvim_root_dir()
	local classes = root .. "/scnvim-data/tags"
	local tagsfile = io.open(classes)
	local help = {}

	for line in tagsfile:lines() do
		local tagname, tagpath, _, _= line:match("%s*(.-)\t%s*(.-)\t%s*(.-)\t%s*(.-)")
		help[tostring(tagname)] = tagpath
		-- print(tagname)
	end

	return help
end

function M.definitions()
	local help = scnvim_unpack_tags_table()
	local help_keys = {};

	for k,_ in pairs(help) do
		table.insert(help_keys, k)
	end

	local lookup_func = function(class_name)
		local key = tostring(class_name)
		local lookup_path = help[key]
		vim.cmd("spl " .. lookup_path)
	end

	if require'fzf-sc'.search_plugin == "nvim-fzf" then
		coroutine.wrap(function()
			local result = require'fzf'.fzf(help_keys);
			if result then
				lookup_func(result[1])
			end;
		end)();
	else
		error("fzf-sc: Only supported for nvim-fzf")
	end
end

return M
