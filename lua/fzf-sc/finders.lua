local utils = require"fzf-sc/utils"
local M = {}

-- Quarks
function M.quark_install()
	local sc_code = [[Quarks.fetchDirectory; Quarks.all.collect{|q| q.name}]];
	local supercollider_return_code = "Quarks.install(\"%s\");";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.quark_uninstall()
	local sc_code = [[Quarks.installed.collect{|q| q.name}]];
	local supercollider_return_code = "Quarks.uninstall(\"%s\");";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- SynthDefs
function M.play_synthdef()
	local sc_code = [[SynthDescLib.default.synthDescs.keys.asArray]];
	local supercollider_return_code = "Synth(\'%s\');";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- Nodeproxy
function M.stop_nodeproxy()
	local sc_code = [[Ndef.all['localhost'].monitors.asArray]];
local supercollider_return_code = "%s.stop;";

utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.play_nodeproxy()
	local sc_code = [[Ndef.all['localhost'].existingProxies.asArray]];
	local supercollider_return_code = "Ndef(\'%s\').play;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.clear_ndef()
	local sc_code = [[Ndef.all['localhost'].existingProxies.asArray]];
	local supercollider_return_code = "Ndef(\'%s\').clear(1);";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- Pdef
function M.ndef_gui()
	local sc_code = [[Ndef.all['localhost'].existingProxies.asArray]];
	local supercollider_return_code = "Ndef(\'%s\').gui();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- Pdef
function M.play_pdef()
	local sc_code = [[Pdef.all.keys]];
	local supercollider_return_code = "Pdef(\'%s\').play;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.stop_pdef()
	local sc_code = [[Pdef.all.keys.asArray.select{|k| Pdef(k).isPlaying};]];
	local supercollider_return_code = "Pdef(\'%s\').stop;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.clear_pdef()
	local sc_code = [[Pdef.all.keys]];
	local supercollider_return_code = "Pdef(\'%s\').clear;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- Introspect environment
function M.current_environment()
	local sc_code = [[currentEnvironment.keys.asArray]];
	local supercollider_return_code = "currentEnvironment[\'%s\'].postln;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- Introspect scales
function M.scales()
	local sc_code = [[Scale.names;]];
	local supercollider_return_code = "~fzf_scale=\\%s;Pbind(\\scale, Scale.at(~fzf_scale), \\degree, Pseq((0..Scale.at(~fzf_scale).degrees.size-1),1), \\dur, 0.25).play;Scale.at(~fzf_scale).postln;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.help()
	require'fzf-sc/help'.fzf_sc_help()
end

function M.definitions()
	utils.definitions()
end

return M
