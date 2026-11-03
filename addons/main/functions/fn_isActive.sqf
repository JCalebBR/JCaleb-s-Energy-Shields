/*
 * Author: JCaleb2014
 * Checks if the unit's shield is up. Only valid where the unit is local.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Shield is up <BOOL>
 *
 * Example:
 * [player] call jces_main_fnc_isActive
 *
 * Public: Yes
 */
params [["_unit", objNull, [objNull]]];

!isNull (_unit getVariable ["jces_main_shieldObject", objNull])
