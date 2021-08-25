local M = {}

-- ------------------------------------
-- Utilities
-- ------------------------------------
function rm_whitespace(instring)
	return string.gsub(instring, "%s", "");
end

-- Remove brackets and extraneous whitespace
function strip(arrayAsString)
	arrayAsString = string.gsub(arrayAsString, "%[", "");
	arrayAsString = string.gsub(arrayAsString, "%]", "");

	return arrayAsString
end

-- Takes a supercolldier array as string, eg "[1, 2, 3]" and spits out a lua table
function split_string_to_array(arrayAsString)
	local t = {};

	arrayAsString = rm_whitespace(arrayAsString)
	arrayAsString = strip(arrayAsString)

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
			local t = split_string_to_array(returnVal)
			local sinkFunction = function (val)
				require'scnvim'.send(string.format(callback_sc_code, val))
			end;

			vim.fn["fzf#run"]({["source"] = t, ["sink"] = sinkFunction})
		end
	);
end

-- ------------------------------------
-- Commands
-- ------------------------------------

function reg_command(str)
	vim.cmd("command! " .. str)
end

-- Quarks
function M.fzf_sc_quark_install()
	local sc_code = [[Quarks.fetchDirectory; Quarks.all.collect{|q| q.name}]];
	local supercollider_return_code = "Quarks.install(\"%s\");";

	M.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("Quarks lua require'fzf-supercollider'.fzf_sc_quark_install()")

function M.fzf_sc_quark_uninstall()
	local sc_code = [[Quarks.installed.collect{|q| q.name}]];
	local supercollider_return_code = "Quarks.install(\"%s\");";

	M.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("Quarks lua require'fzf-supercollider'.fzf_sc_quark_install()")
reg_command("QuarksUninstall lua require'fzf-supercollider'.fzf_sc_quark_uninstall()")

-- SynthDefs
function M.fzf_sc_play_synthdef()
	local sc_code = [[SynthDescLib.default.synthDescs.keys.asArray]];
	local supercollider_return_code = "Synth(\'%s\');";

	M.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("SCPlaySynth lua require'fzf-supercollider'.fzf_sc_play_synthdef()")

return M
