/*
 * Author: JCaleb2014
 * Zeus context menu action: toggles the shield of every selected unit that carries a shield device.
 * Each toggle runs where the unit is local, it can still fail there (cooldown, in a vehicle).
 *
 * Arguments:
 * Selected objects <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit] call jces_zen_fnc_toggleShields
 *
 * Public: No
 */
private _units = _this select {
    _x call jces_zen_fnc_canEditShield && {([_x] call jces_main_fnc_getShieldDevice) isNotEqualTo []}
};

{
    [_x] call jces_main_fnc_toggle;
} forEach _units;

["Toggled shield on %1 unit(s)", count _units] call zen_common_fnc_showMessage;
