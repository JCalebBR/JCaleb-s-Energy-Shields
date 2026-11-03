/*
 * Author: JCaleb2014
 * Plays the sound file set in the Sounds settings for a shield action. Only the unit's player hears it.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Action ("Activate", "Deactivate", "Depleted" or "Ready") <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "Ready"] call jces_main_fnc_playSound
 *
 * Public: No
 */
params [["_unit", objNull, [objNull]], ["_action", "", [""]]];

if (!hasInterface || {!jces_main_soundsEnabled} || {_unit isNotEqualTo ace_player} || {!alive _unit}) exitWith {};

private _path = trim (missionNamespace getVariable [format ["jces_main_sound%1", _action], ""]);
if (_path isNotEqualTo "") then {
    playSoundUI [_path];
};
