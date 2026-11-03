/*
 * Author: JCaleb2014
 * Builds the Add Shield submenu for the selected units that have no shield yet: every shield item that fits them
 * (space marine sized for regular units, terminator ones for terminators, dreadnought ones for dreadnoughts),
 * lowest tier first. A selection with several unit types gets one submenu per type.
 *
 * Arguments:
 * Selected objects <ARRAY>
 *
 * Return Value:
 * ZEN context menu actions <ARRAY>
 *
 * Example:
 * _objects call jces_zen_fnc_getAddActions
 *
 * Public: No
 */
private _unitsByType = createHashMap;
{
    if (_x call jces_zen_fnc_canEditShield && {([_x] call jces_main_fnc_getShieldItems) isEqualTo []}) then {
        _unitsByType getOrDefault [[_x] call jces_main_fnc_getUnitType, [], true] pushBack _x;
    };
} forEach _this;

private _typeActions = [];
{
    private _units = _y;
    private _itemActions = ([_x] call jces_main_fnc_getAvailableItems) apply {
        _x params ["_class", "_name", "_picture"];
        private _action = [
            _class,
            _name,
            _picture,
            {
                _args params ["_class", "_units"];
                ["zen", "Zeus adding %1 to %2", _class, _units] call jces_main_fnc_log;
                {
                    ["jces_main_addShieldItem", [_x, _class], _x] call CBA_fnc_targetEvent;
                } forEach _units;
                private _target = [format ["%1 unit(s)", count _units], name (_units select 0)] select (count _units == 1);
                ["Added %1 to %2", getText (configFile >> "CfgWeapons" >> _class >> "displayName"), _target] call zen_common_fnc_showMessage;
            },
            {true},
            [_class, _units]
        ] call zen_context_menu_fnc_createAction;
        [_action, [], 0]
    };
    _typeActions pushBack [_x, _itemActions];
} forEach _unitsByType;

// One unit type: list its items directly, otherwise group them so each unit only gets items that fit it
if (count _typeActions == 1) exitWith {
    _typeActions select 0 select 1
};

_typeActions apply {
    _x params ["_type", "_itemActions"];
    private _action = [
        _type,
        _type,
        "\CalebsShields\addons\main\data\logo.paa",
        {},
        {true}
    ] call zen_context_menu_fnc_createAction;
    [_action, _itemActions, 0]
}
