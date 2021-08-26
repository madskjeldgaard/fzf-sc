local utils = require"fzf-sc/utils"

local M = {}

-- ------------------------------------
-- Commands
-- ------------------------------------

local function reg_command(str)
	vim.cmd("command! " .. str)
end

-- Help tags search
reg_command("SCHelp lua require'fzf-sc/help'.fzf_sc_help()")

-- Quarks
function M.fzf_sc_quark_install()
	local sc_code = [[Quarks.fetchDirectory; Quarks.all.collect{|q| q.name}]];
	local supercollider_return_code = "Quarks.install(\"%s\");";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("QuarksInstall lua require'fzf-sc'.fzf_sc_quark_install()")

function M.fzf_sc_quark_uninstall()
	local sc_code = [[Quarks.installed.collect{|q| q.name}]];
	local supercollider_return_code = "Quarks.install(\"%s\");";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("QuarksUninstall lua require'fzf-sc'.fzf_sc_quark_uninstall()")

-- SynthDefs
function M.fzf_sc_play_synthdef()
	local sc_code = [[SynthDescLib.default.synthDescs.keys.asArray]];
	local supercollider_return_code = "Synth(\'%s\');";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("SCPlaySynth lua require'fzf-sc'.fzf_sc_play_synthdef()")

-- Nodeproxy
function M.fzf_sc_stop_nodeproxy()
local sc_code = [[Ndef.all['localhost'].monitors.asArray]];
local supercollider_return_code = "%s.stop;";

utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("NodeProxyStop lua require'fzf-sc'.fzf_sc_stop_nodeproxy()")

function M.fzf_sc_play_nodeproxy()
local sc_code = [[Ndef.all['localhost'].existingProxies.asArray]];
	local supercollider_return_code = "Ndef(\'%s\').play;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("NodeProxyPlay lua require'fzf-sc'.fzf_sc_play_nodeproxy()")

-- Pdef
function M.fzf_sc_play_pdef()
	local sc_code = [[Pdef.all.keys]];
	local supercollider_return_code = "Pdef(\'%s\').play;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("PdefPlay lua require'fzf-sc'.fzf_sc_play_pdef()")

function M.fzf_sc_stop_pdef()
	local sc_code = [[Pdef.all.keys.asArray.select{|k| Pdef(k).isPlaying};]];
	local supercollider_return_code = "Pdef(\'%s\').stop;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("PdefStop lua require'fzf-sc'.fzf_sc_stop_pdef()")

-- Introspect environment
function M.fzf_sc_current_environment()
	local sc_code = [[currentEnvironment.keys.asArray]];
	local supercollider_return_code = "currentEnvironment[\'%s\'].postln;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("CurrentEnvironment lua require'fzf-sc'.fzf_sc_current_environment()")

-- Introspect scales
function M.fzf_sc_scales()
	local sc_code = [[Scale.names;]];
	local supercollider_return_code = "~fzf_scale=\\%s;Pbind(\\scale, Scale.at(~fzf_scale), \\degree, Pseq((0..Scale.at(~fzf_scale).degrees.size-1),1), \\dur, 0.25).play;Scale.at(~fzf_scale).postln;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

reg_command("Scale lua require'fzf-sc'.fzf_sc_scales()")

-- Help files: Classes
-- Too big for osc
-- function M.fzf_sc_help_ext()
-- 	local sc_code = [[SCDoc.documents.collect{|doc, key| doc.title}]];
-- 	local supercollider_return_code = "HelpBrowser.openHelpFor(\"%s\")";

-- 	utils.fzf_sc_eval(sc_code, supercollider_return_code)
-- end

-- reg_command("SCHelp lua require'fzf-sc'.fzf_sc_help_ext()")

return M
