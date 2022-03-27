local utils = require"fzf-sc/utils"
local M = {}

-- Quarks
function M.install_quark()
	local sc_code = [[Quarks.fetchDirectory; Quarks.all.collect{|q| q.name}.sort]];
	local supercollider_return_code = "Quarks.install(\"%s\");";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.uninstall_quark()
	local sc_code = [[Quarks.installed.collect{|q| q.name}.sort]];
	local supercollider_return_code = "Quarks.uninstall(\"%s\");";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- SynthDefs
function M.play_synthdef()
	local sc_code = [[SynthDescLib.default.synthDescs.keys.asArray.sort]];
	local supercollider_return_code = "Synth(\'%s\');";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.postinfo_synthdescs()

	local sc_code = [[SynthDescLib.global.synthDescs.keys.asArray.sort;]];

	local supercollider_return_code = [[
{
var synthName = "%s";
var synthDesc = SynthDescLib.global.synthDescs.at(synthName.asSymbol);
var controlNames = synthDesc.controls;

var outString = "";
controlNames.do{|ctrl, index|
	var name = ctrl.name;
	var default = ctrl.defaultValue;
	var break = if(index != (controlNames.size - 1), { "\n" }, { "" });

	outString = outString ++ "\\" ++ name ++ "," ++ default ++ ",\n";
};

("------------\n
These are the arguments for SynthDef: " ++ synthName.asString ++ "\n\n").postln;
outString.postln;
}.value();
]]

utils.fzf_sc_eval(sc_code, supercollider_return_code)

end

function M.postinfo_controlspecs()
	local sc_code = [[ Spec.specs.keys.asArray.sort ]];

	local returncode = [[
	{
	var specIndex = '%s';
	var outString = "-----------";
	var spec = ControlSpec.specs[specIndex];

	outString = outString ++ "ControlSpec " ++ specIndex ++ ":\n";
	outString = outString ++ "default: " ++ spec.default ++ "\n";
	outString = outString ++ "min: " ++ spec.minval ++ "\n";
	outString = outString ++ "max: " ++ spec.maxval ++ "\n";
	outString = outString ++ "step: " ++ spec.step ++ "\n";
	outString = outString ++ "warp: " ++ spec.warp ++ "\n";
	outString = outString ++ "units: " ++ spec.units ++ "\n";

	outString.postln;
	}.value();
	]]

	require"fzf-sc/finders".controlspecs = function() require"fzf-sc/utils".fzf_sc_eval(sc_code, returncode) end
end

-- Nodeproxy
function M.stop_nodeproxy()
	local sc_code = [[Ndef.all['localhost'].monitors.asArray.sort]];
local supercollider_return_code = "%s.stop;";

utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.play_nodeproxy()
	local sc_code = [[Ndef.all['localhost'].existingProxies.asArray.sort]];
	local supercollider_return_code = "Ndef(\'%s\').play;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.clear_ndef()
	local sc_code = [[Ndef.all['localhost'].existingProxies.asArray.sort]];
	local supercollider_return_code = "Ndef(\'%s\').clear(1);";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.ndef_gui()
	local sc_code = [[Ndef.all['localhost'].existingProxies.asArray.sort]];
	local supercollider_return_code = "Ndef(\'%s\').gui();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- Pdef
function M.play_pdef()
	local sc_code = [[Pdef.all.keys.sort]];
	local supercollider_return_code = "Pdef(\'%s\').play;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.stop_pdef()
	local sc_code = [[Pdef.all.keys.asArray.select{|k| Pdef(k).isPlaying}.sort;]];
	local supercollider_return_code = "Pdef(\'%s\').stop;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.clear_pdef()
	local sc_code = [[Pdef.all.keys.sort]];
	local supercollider_return_code = "Pdef(\'%s\').clear;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- Introspect environment
function M.current_environment()
	local sc_code = [[currentEnvironment.keys.asArray.sort]];
	local supercollider_return_code = "currentEnvironment[\'%s\'].postln;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- Introspect scales
function M.play_scales()
	local sc_code = [[Scale.names.sort;]];
	local supercollider_return_code = "~fzf_scale=\\%s;Pbind(\\scale, Scale.at(~fzf_scale), \\degree, Pseq((0..Scale.at(~fzf_scale).degrees.size-1),1), \\dur, 0.25).play;Scale.at(~fzf_scale).postln;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- MidiDef
function M.free_mididef()
	local sc_code = [[MIDIdef.all.keys.asArray.sort]];
	local supercollider_return_code = "MIDIdef(\'%s\').free();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.disable_mididef()
	local sc_code = [[MIDIdef.all.keys.asArray.sort]];
	local supercollider_return_code = "MIDIdef(\'%s\').disable();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.enable_mididef()
	local sc_code = [[MIDIdef.all.keys.asArray.sort]];
	local supercollider_return_code = "MIDIdef(\'%s\').enable();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.fix_mididef()
	local sc_code = [[MIDIdef.all.keys.asArray.sort]];
	local supercollider_return_code = "MIDIdef(\'%s\').fix();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- OSCdef
function M.free_oscdef()
	local sc_code = [[OSCdef.all.keys.asArray.sort]];
	local supercollider_return_code = "OSCdef(\'%s\').free();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.disable_oscdef()
	local sc_code = [[OSCdef.all.keys.asArray.sort]];
	local supercollider_return_code = "OSCdef(\'%s\').disable();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.enable_oscdef()
	local sc_code = [[OSCdef.all.keys.asArray.sort]];
	local supercollider_return_code = "OSCdef(\'%s\').enable();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.fix_oscdef()
	local sc_code = [[MIDIdef.all.keys.asArray.sort]];
	local supercollider_return_code = "MIDIdef(\'%s\').fix();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

-- Server stuff
function M.setvolume_localserver()
	local sc_code = [[ (0..(-120)); ]];
	local supercollider_return_code = "Server.local.volume = %s;";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.setmute_localserver()
	local sc_code = [[ if(Server.local.volume.isMuted, { ['unmute'] }, {['mute']});]];
	local supercollider_return_code = "Server.local.%s();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.control_localserver()
	local sc_code = [[ ['boot', 'reboot', 'quit', 'freeAll', 'queryAllNodes', 'makeGui'].sort;]];
	local supercollider_return_code = "Server.local.%s();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.control_allservers()
	local sc_code = [[ ['quitAll', 'killAll', 'freeAll', 'hardFreeAll'].sort;]];
	local supercollider_return_code = "Server.%s();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.switch_localserver()
	local sc_code = [[ ['scsynth', 'supernova'];]];
	local supercollider_return_code = "Server.local.%s();";

	utils.fzf_sc_eval(sc_code, supercollider_return_code)
end

function M.help()
	require'fzf-sc/help'.fzf_sc_help()
end

function M.definitions()
	utils.definitions()
end

return M
