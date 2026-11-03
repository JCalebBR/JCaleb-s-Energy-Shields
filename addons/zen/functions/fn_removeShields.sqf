/*
 * Author: JCaleb2014
 * Zeus context menu action: lowers the shield of every selected unit and removes all its shield items.
 * The removal runs where the unit is local.
 *
 * Arguments:
 * Selected objects <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit] call jces_zen_fnc_removeShields
 *
 * Public: No
 */
private _units = _this select {
    _x call jces_zen_fnc_canEditShield && {([_x] call jces_main_fnc_getShieldItems) isNotEqualTo []}
};

["zen", "Zeus removing the shield of %1", _units] call jces_main_fnc_log;
{
    ["jces_main_removeShieldItems", [_x], _x] call CBA_fnc_targetEvent;
} forEach _units;

private _target = [format ["%1 unit(s)", count _units], name (_units select 0)] select (count _units == 1);
["Removed shield from %1", _target] call zen_common_fnc_showMessage;
