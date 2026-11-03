/*
 * Author: JCaleb2014
 * Debug console test: does a shielded AI keep firing while the player shoots its dome?
 * Not part of the mod. Paste into the debug console in Eden singleplayer preview, Local Exec, then close the menu
 * (the game is paused while it's open). Takes ~13 s: 3 s hold fire, then shoot the dome until "Done".
 * Logs once per second to chat, the RPT (prefix "JCES DBG") and the clipboard at the end.
 *
 * Picks the unit named ai1, otherwise the nearest enemy AI within 300 m that carries a shield device.
 * The player is invulnerable during the test. The AI's automatic shield use is paused and its cooldown reset.
 *
 * Columns: shots fired in the last second, suppression (-1 = disabled, expected while the shield is up),
 * how much of the player the AI can see (0-1), stance, lifeState (an unconscious AI can't fire, which
 * invalidates the run).
 *
 * History (2026-10-29): with suppression enabled, shooting the dome took the AI to suppression 0.99 and 0 shots;
 * with suppression disabled before the shield went up it kept firing ~10 rounds/s. The shield blocks all damage
 * to the unit inside and its own rounds exit the dome.
 */
private _ai = missionNamespace getVariable ["ai1", objNull];
if (isNull _ai) then {
    private _enemies = (player nearEntities ["CAManBase", 300]) select {
        alive _x && {!isPlayer _x} && {(side group player) getFriend (side group _x) < 0.6} && {([_x] call jces_main_fnc_getShieldDevice) isNotEqualTo []}
    };
    _enemies = _enemies apply {[_x distance player, _x]};
    _enemies sort true;
    if (_enemies isNotEqualTo []) then {_ai = _enemies select 0 select 1};
};
if (isNull _ai || {!local _ai}) exitWith {systemChat "JCES DBG: no local enemy AI with a shield device found"};

jces_dbg_log = [];
jces_dbg_shots = 0;
jces_dbg_phase = "hold fire";
jces_dbg_say = {
    private _line = format ["[%1] %2", CBA_missionTime toFixed 1, _this];
    jces_dbg_log pushBack _line;
    systemChat ("JCES DBG " + _line);
    diag_log text ("JCES DBG " + _line);
};

private _firedEh = _ai addEventHandler ["Fired", {jces_dbg_shots = jces_dbg_shots + 1}];
private _samplePfh = [{
    params ["_ai"];
    format ["  %1 | shots %2 | supp %3 | sees you %4 | stance %5 | %6",
        jces_dbg_phase, jces_dbg_shots, getSuppression _ai toFixed 2,
        ([_ai, "VIEW", player] checkVisibility [eyePos _ai, eyePos player]) toFixed 2,
        stance _ai, lifeState _ai] call jces_dbg_say;
    jces_dbg_shots = 0;
}, 1, _ai] call CBA_fnc_addPerFrameHandler;

player allowDamage false;
_ai setVariable ["jces_main_aiEnabled", false];
if ([_ai] call jces_main_fnc_isActive) then {[_ai] call jces_main_fnc_deactivate};
_ai setVariable ["jces_main_cooldownEnd", 0];
format ["Testing %1 at %2 m, shield up (activate %3). HOLD FIRE",
    typeOf _ai, round (_ai distance player), [_ai] call jces_main_fnc_activate] call jces_dbg_say;
hint "HOLD FIRE";

[{
    jces_dbg_phase = "you shoot";
    "SHOOT THE DOME" call jces_dbg_say;
    hint "SHOOT THE DOME";
}, [], 3] call CBA_fnc_waitAndExecute;

[{
    params ["_ai", "_firedEh", "_samplePfh"];
    [_samplePfh] call CBA_fnc_removePerFrameHandler;
    [_ai] call jces_main_fnc_deactivate;
    _ai setVariable ["jces_main_cooldownEnd", 0];
    _ai setVariable ["jces_main_aiEnabled", nil];
    _ai removeEventHandler ["Fired", _firedEh];
    player allowDamage true;
    hint "";
    format ["Done, suppression feature after deactivate: %1 (expected true)", _ai checkAIFeature "SUPPRESSION"] call jces_dbg_say;
    copyToClipboard (jces_dbg_log joinString endl);
}, [_ai, _firedEh, _samplePfh], 13] call CBA_fnc_waitAndExecute;
