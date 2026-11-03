/*
 * Author: JCaleb2014
 * Checks if the unit can raise a shield: alive, on foot, carrying a shield device, no shield up and no cooldown.
 * Only valid where the unit is local.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Can raise a shield <BOOL>
 *
 * Example:
 * [player] call jces_main_fnc_canActivate
 *
 * Public: Yes
 */
params [["_unit", objNull, [objNull]]];

alive _unit
&& {isNull objectParent _unit}
&& {!([_unit] call jces_main_fnc_isActive)}
&& {CBA_missionTime >= (_unit getVariable ["jces_main_cooldownEnd", 0])}
&& {([_unit] call jces_main_fnc_getShieldDevice) isNotEqualTo []}
