/*
 * Author: JCaleb2014
 * Returns the best shield device the unit carries, from its inventory items or facewear.
 * The shield type comes from the device, the tier is capped at what that type has.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * [Tier (index into jces_main_tierNames + 1), Type ("Personal", "Dreadnought" or "Terminator")], empty if none <ARRAY>
 *
 * Example:
 * [player] call jces_main_fnc_getShieldDevice
 *
 * Public: Yes
 */
params [["_unit", objNull, [objNull]]];

private _best = [0, ""];
{
    private _device = jces_main_deviceCache getOrDefaultCall [_x, {[_x] call jces_main_fnc_getDeviceConfig}, true];
    if ((_device select 0) > (_best select 0)) then {
        _best = _device;
    };
} forEach (items _unit + [goggles _unit]);

_best params ["_tier", "_type"];
if (_tier == 0) exitWith {[]};

[_tier min (jces_main_typeTiers getOrDefault [_type, 1]), _type]
