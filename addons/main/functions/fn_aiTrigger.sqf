/*
 * Author: JCaleb2014
 * Rolls whether an AI unit raises its shield in reaction to danger.
 * Each trigger has its own chance setting and its own re-roll interval, so a failed roll on a near miss
 * doesn't block a roll on an actual hit. Zeus and scripts calling jces_main_fnc_activate are not affected.
 * Only acts where the unit is local.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Trigger, "Hit", "Explosion" or "Suppressed" <STRING>
 *
 * Return Value:
 * Shield raised <BOOL>
 *
 * Example:
 * [_unit, "Hit"] call jces_main_fnc_aiTrigger
 *
 * Public: No
 */
params [["_unit", objNull, [objNull]], ["_trigger", "", [""]]];

if (!jces_main_aiEnabled || {!local _unit} || {isPlayer _unit}) exitWith {false};
// Mission makers can opt single units out.
if !(_unit getVariable ["jces_main_aiEnabled", true]) exitWith {false};
// Remote controlled by Zeus, the player decides.
if (!isNull (_unit getVariable ["bis_fnc_moduleRemoteControl_owner", objNull])) exitWith {false};

// Suppressed fires on every near miss, without a re-roll interval even a low chance would pass within a second.
private _nextRollVar = "jces_main_aiNextRoll" + _trigger;
if (CBA_missionTime < (_unit getVariable [_nextRollVar, 0])) exitWith {false};
if !([_unit] call jces_main_fnc_canActivate) exitWith {false};

_unit setVariable [_nextRollVar, CBA_missionTime + jces_main_aiRollInterval];
if (random 1 >= (missionNamespace getVariable ["jces_main_aiChance" + _trigger, 0])) exitWith {false};

[_unit] call jces_main_fnc_activate
