/*
 * Author: JCaleb2014
 * Checks if Zeus can manage the shield of this object: an alive infantry unit.
 *
 * Arguments:
 * 0: Object <OBJECT>
 *
 * Return Value:
 * Can manage <BOOL>
 *
 * Example:
 * _hoveredEntity call jces_zen_fnc_canEditShield
 *
 * Public: No
 */
params [["_unit", objNull, [objNull, grpNull, ""]]];

_unit isEqualType objNull && {_unit isKindOf "CAManBase"} && {alive _unit}
