/*
 * Author: JCaleb2014
 * Builds the Add Shield submenu: every shield item that fits the unit (space marine sized for regular units,
 * terminator ones for terminators, dreadnought ones for dreadnoughts), lowest tier first.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * ZEN context menu actions <ARRAY>
 *
 * Example:
 * _hoveredEntity call jces_zen_fnc_getAddActions
 *
 * Public: No
 */
params [["_unit", objNull, [objNull]]];

([[_unit] call jces_main_fnc_getUnitType] call jces_main_fnc_getAvailableItems) apply {
    _x params ["_class", "_name", "_picture"];
    private _action = [
        _class,
        _name,
        _picture,
        {
            ["jces_main_addShieldItem", [_hoveredEntity, _args], _hoveredEntity] call CBA_fnc_targetEvent;
            ["Added %1 to %2", getText (configFile >> "CfgWeapons" >> _args >> "displayName"), name _hoveredEntity] call zen_common_fnc_showMessage;
        },
        {true},
        _class
    ] call zen_context_menu_fnc_createAction;
    [_action, [], 0]
}
