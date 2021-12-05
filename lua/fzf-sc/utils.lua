local M = {}

-- ------------------------------------
-- Utilities
-- ------------------------------------
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
-- callback_sc_code is a format string with the supercollider code
-- that will be executed with the chosen item insert, eg "Quarks.install(\"%s\");"
function M.fzf_sc_eval(sc_code, callback_sc_code)
	require'scnvim'.eval(sc_code,
		function (returnVal)
			local scReturnVal = M.split_string_to_array(returnVal)

			-- Callback function
			local sinkFunction = function (val)
				local formatted = string.format(callback_sc_code, val)
				-- print(formatted)
				require'scnvim'.send(formatted)
			end;

			-- If using nvim-fzf
			if require'fzf-sc'.search_plugin == "nvim-fzf" then
				coroutine.wrap(function()
					local result = require'fzf'.fzf(scReturnVal);
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

return M
