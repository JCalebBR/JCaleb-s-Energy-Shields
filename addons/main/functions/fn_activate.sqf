/*
 * Author: JCaleb2014
 * Raises the unit's shield, using the highest tier shield device it carries.
 * Remote units are forwarded to the machine they are local to.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Shield raised on this machine <BOOL>
 *
 * Example:
 * [player] call jces_main_fnc_activate
 *
 * Public: Yes
 */
params [["_unit", objNull, [objNull]]];

if (isNull _unit) exitWith {false};
if (!local _unit) exitWith {
    ["activate", "%1 is remote, sending to its owner", _unit] call jces_main_fnc_log;
    ["jces_main_activate", [_unit], _unit] call CBA_fnc_targetEvent;
    false
};
if !([_unit] call jces_main_fnc_canActivate) exitWith {
    [
        "activate", "Can't raise on %1: alive %2, vehicle %3, active %4, cooldown left %5, device %6",
        _unit, alive _unit, objectParent _unit, [_unit] call jces_main_fnc_isActive,
        ((_unit getVariable ["jces_main_cooldownEnd", 0]) - CBA_missionTime) max 0, [_unit] call jces_main_fnc_getShieldDevice
    ] call jces_main_fnc_log;
    false
};

([_unit] call jces_main_fnc_getShieldDevice) params ["_tier", "_type"];
private _tierName = jces_main_tierNames select (_tier - 1);
private _class = (["JCES_Shield_Oval_" + _type + "_", "JCES_Shield_Oval_"] select (_type == "Personal")) + _tierName;
private _settingSuffix = _type + _tierName;
private _maxHealth = missionNamespace getVariable ["jces_main_health" + _settingSuffix, 400];

private _shield = createVehicle [_class, getPosATL _unit, [], 0, "CAN_COLLIDE"];
// Opts out of ZEN's "Auto Add Objects" if the variable reaches the server in time, jces_main_removeFromCurators covers the rest.
_shield setVariable ["zen_common_autoAddObject", false, true];
([_unit, _type] call jces_main_fnc_getAttachTarget) params ["_target", "_offset", "_bone"];
if (_bone isEqualTo "") then {
    _shield attachTo [_target, _offset];
} else {
    _shield attachTo [_target, _offset, _bone];
};

// Crew joins the unit's side so its allies ignore the shield while its enemies engage it.
createVehicleCrew _shield;
private _crew = crew _shield;
if (_crew isNotEqualTo []) then {
    private _crewGroup = group (_crew select 0);
    private _side = side group _unit;
    if (side _crewGroup != _side) then {
        private _group = createGroup [_side, true];
        if (!isNull _group) then {
            _crew joinSilent _group;
            deleteGroup _crewGroup;
        };
    };
    {
        _x disableAI "ALL";
    } forEach _crew;
};

_shield setVariable ["jces_main_owner", _unit];
// Health is scripted (see jces_main_fnc_handleHitPart), the engine never damages the shield itself.
_shield addEventHandler ["HandleDamage", {0}];
_shield addEventHandler ["Killed", {
    params ["_shield"];
    ["activate", "Shield %1 was killed", _shield] call jces_main_fnc_log;
    [jces_main_fnc_deactivate, [_shield getVariable ["jces_main_owner", objNull], true]] call CBA_fnc_execNextFrame;
}];
_shield addEventHandler ["Deleted", {
    params ["_shield"];
    private _unit = _shield getVariable ["jces_main_owner", objNull];
    // Removed by something other than jces_main_fnc_deactivate (e.g. Zeus), count it as broken.
    if ((_unit getVariable ["jces_main_shieldObject", objNull]) isEqualTo _shield) then {
        ["activate", "Shield %1 of %2 was deleted externally, counting it as broken", _shield, _unit] call jces_main_fnc_log;
        [_unit, true, false] call jces_main_fnc_deactivate;
    };
}];

_unit setVariable ["jces_main_shieldObject", _shield];
_unit setVariable ["jces_main_shieldInfo", [_tier, _type]];
_unit setVariable ["jces_main_health", _maxHealth];
_unit setVariable ["jces_main_maxHealth", _maxHealth];
_unit setVariable ["jces_main_colorIndex", 0];

// Hits on the dome land right next to the unit and count as near misses, a suppressed AI would cower
// inside an invulnerable shield and stop firing. Only undone later if it was on to begin with.
if (!isPlayer _unit && {_unit checkAIFeature "SUPPRESSION"}) then {
    _unit setSuppression 0;
    _unit disableAI "SUPPRESSION";
    _unit setVariable ["jces_main_suppressionDisabled", true];
};

private _duration = -1;
if (missionNamespace getVariable ["jces_main_timeLimit" + _settingSuffix, true]) then {
    _duration = missionNamespace getVariable ["jces_main_maxDuration" + _settingSuffix, 15];
    [{
        params ["_unit", "_shield"];
        // Skipped if this shield already went down (a newer one won't match).
        if ((_unit getVariable ["jces_main_shieldObject", objNull]) isEqualTo _shield && {!isNull _shield}) then {
            ["activate", "Time limit reached for %1", _unit] call jces_main_fnc_log;
            [_unit] call jces_main_fnc_deactivate;
        };
    }, [_unit, _shield], _duration] call CBA_fnc_waitAndExecute;
};
_unit setVariable ["jces_main_shieldEnd", [-1, CBA_missionTime + _duration] select (_duration > 0)];
_unit setVariable ["jces_main_shieldDuration", _duration];

[_unit, "Activate"] call jces_main_fnc_playSound;
["jces_main_removeFromCurators", [_shield]] call CBA_fnc_serverEvent;

if (_type == "Dreadnought" && {_target != _unit} && {!(_target getVariable ["jces_main_hitPartPatched", false])}) then {
    ["activate", "Patching dreadnought hitbox %1 on every machine", _target] call jces_main_fnc_log;
    private _jipId = ["jces_main_patchDreadnoughtHitbox", [_target], format ["jces_main_hitbox_%1", netId _target]] call CBA_fnc_globalEventJIP;
    [_jipId, _target] call CBA_fnc_removeGlobalEventJIP;
};

["activate", "Raised %1 on %2: health %3, duration %4, attached to %5 %6 %7, crew %8", _shield, _unit, _maxHealth, _duration, _target, _offset, _bone, crew _shield] call jces_main_fnc_log;
["jces_main_shieldActivated", [_unit, _shield]] call CBA_fnc_localEvent;

true
