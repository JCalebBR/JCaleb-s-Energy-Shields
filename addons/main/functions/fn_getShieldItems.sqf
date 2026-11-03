/*
 * Author: JCaleb2014
 * Returns the shield device items in the unit's inventory (not facewear), without duplicates.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Item classnames <ARRAY>
 *
 * Example:
 * [player] call jces_main_fnc_getShieldItems
 *
 * Public: Yes
 */
params [["_unit", objNull, [objNull]]];

(items _unit arrayIntersect items _unit) select {
    ((jces_main_deviceCache getOrDefaultCall [_x, {[_x] call jces_main_fnc_getDeviceConfig}, true]) select 0) > 0
}
