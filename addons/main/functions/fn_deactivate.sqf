/*
 * Author: JCaleb2014
 * Lowers the unit's shield and starts its cooldown. The cooldown is shortened by what the shield had left:
 * its health fraction, or its time fraction if that is lower (time limited shields). A broken or expired
 * shield gets the full cooldown, one turned off with everything left gets the minimum cooldown.
 * Remote units are forwarded to the machine they are local to.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Shield was broken <BOOL> (default: false)
 * 2: Delete the shield object <BOOL> (default: true)
 *
 * Return Value:
 * Shield lowered on this machine <BOOL>
 *
 * Example:
 * [player] call jces_main_fnc_deactivate
 *
 * Public: Yes
 */
params [["_unit", objNull, [objNull]], ["_broken", false, [false]], ["_deleteShield", true, [true]]];

if (isNull _unit) exitWith {false};
if (!local _unit) exitWith {
    ["jces_main_deactivate", [_unit, _broken], _unit] call CBA_fnc_targetEvent;
    false
};

private _shield = _unit getVariable ["jces_main_shieldObject", objNull];
if (isNull _shield) exitWith {false};

(_unit getVariable ["jces_main_shieldInfo", [1, "Personal"]]) params ["_tier", "_type"];
private _cooldown = missionNamespace getVariable [format ["jces_main_cooldown%1%2", _type, jces_main_tierNames select (_tier - 1)], 120];
if (!_broken) then {
    private _left = (_unit getVariable ["jces_main_health", 0]) / ((_unit getVariable ["jces_main_maxHealth", 1]) max 1);
    private _duration = _unit getVariable ["jces_main_shieldDuration", -1];
    if (_duration > 0) then {
        _left = _left min (((_unit getVariable ["jces_main_shieldEnd", 0]) - CBA_missionTime) / _duration);
    };
    _left = 0 max _left min 1;
    // Nothing left means it ran out (expired), which costs the full cooldown like breaking does.
    if (_left > 0) then {
        _cooldown = (_cooldown * (1 - _left)) max (jces_main_minimumCooldown min _cooldown);
    };
};
private _cooldownEnd = CBA_missionTime + _cooldown;

// Cleared before deleting so the Deleted handler knows this was intended.
_unit setVariable ["jces_main_shieldObject", objNull];
_unit setVariable ["jces_main_cooldownEnd", _cooldownEnd];
_unit setVariable ["jces_main_cooldownDuration", _cooldown];

if (_unit getVariable ["jces_main_suppressionDisabled", false]) then {
    _unit setVariable ["jces_main_suppressionDisabled", nil];
    _unit enableAI "SUPPRESSION";
};

{
    _shield deleteVehicleCrew _x;
} forEach crew _shield;
if (_deleteShield) then {
    deleteVehicle _shield;
};

[_unit, ["Deactivate", "Depleted"] select _broken] call jces_main_fnc_playSound;

if (hasInterface) then {
    [{
        params ["_unit", "_cooldownEnd"];
        // Skipped if a newer cooldown replaced this one.
        if ((_unit getVariable ["jces_main_cooldownEnd", 0]) == _cooldownEnd) then {
            [_unit, "Ready"] call jces_main_fnc_playSound;
        };
    }, [_unit, _cooldownEnd], _cooldown] call CBA_fnc_waitAndExecute;
};

["jces_main_shieldDeactivated", [_unit, _broken, _cooldown]] call CBA_fnc_localEvent;

true
