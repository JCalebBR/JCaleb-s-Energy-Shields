/*
 * Author: JCaleb2014
 * Raises the unit's shield, or lowers it if it is already up.
 * Remote units are forwarded to the machine they are local to, which knows the shield's state.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Shield raised or lowered on this machine <BOOL>
 *
 * Example:
 * [player] call jces_main_fnc_toggle
 *
 * Public: Yes
 */
params [["_unit", objNull, [objNull]]];

if (isNull _unit) exitWith {false};
if (!local _unit) exitWith {
    ["jces_main_toggle", [_unit], _unit] call CBA_fnc_targetEvent;
    false
};

if ([_unit] call jces_main_fnc_isActive) exitWith {
    [_unit] call jces_main_fnc_deactivate
};

[_unit] call jces_main_fnc_activate
