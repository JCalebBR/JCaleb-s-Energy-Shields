// Runs on every machine, the handlers only act where the unit is local.

["CAManBase", "Killed", {
    params ["_unit"];
    if (local _unit) then {
        [_unit, true] call jces_main_fnc_deactivate;
    };
}] call CBA_fnc_addClassEventHandler;

// The shield is attached to the unit, it can't follow it into a vehicle.
["CAManBase", "GetInMan", {
    params ["_unit"];
    if (local _unit) then {
        [_unit] call jces_main_fnc_deactivate;
    };
}] call CBA_fnc_addClassEventHandler;

// Attached objects outlive their parent, a deleted unit (Zeus, scripts, cleanup) would leave its dome behind.
["CAManBase", "Deleted", {
    params ["_unit"];
    if (local _unit) then {
        [_unit] call jces_main_fnc_deactivate;
    };
    // Deleted may only fire on the machine that deleted the unit, which isn't always the owner. Attached objects are global.
    [_unit] call jces_main_fnc_removeAttachedShields;
}] call CBA_fnc_addClassEventHandler;

if (isServer) then {
    // A disconnecting client's shield becomes the server's, nobody would remove it otherwise.
    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit"];
        [_unit] call jces_main_fnc_removeAttachedShields;
        false
    }];
};

// AI shield use. Added on every machine since units can change locality, jces_main_fnc_aiTrigger only acts where the unit is local.
["CAManBase", "init", {
    params ["_unit"];
    _unit addEventHandler ["Hit", {
        params ["_unit"];
        [_unit, "Hit"] call jces_main_fnc_aiTrigger;
    }];
    // Fires for every shot within ~70 m, including the unit's own, so the cheap checks go first.
    _unit addEventHandler ["FiredNear", {
        params ["_unit", "_firer", "", "", "", "", "_ammo", "_gunner"];
        if (!jces_main_aiEnabled || {_firer == _unit} || {!local _unit} || {!([_ammo] call jces_main_fnc_isExplosiveAmmo)}) exitWith {};
        if (isNull _gunner || {(side group _unit) getFriend (side group _gunner) >= 0.6}) exitWith {};
        [_unit, "Explosion"] call jces_main_fnc_aiTrigger;
    }];
    _unit addEventHandler ["Suppressed", {
        params ["_unit", "", "_shooter"];
        if (isNull _shooter || {(side group _unit) getFriend (side group _shooter) >= 0.6}) exitWith {};
        [_unit, "Suppressed"] call jces_main_fnc_aiTrigger;
    }];
}, true, [], true] call CBA_fnc_addClassEventHandler;

// ACE medical returns 0 from HandleDamage, so the vanilla Hit handler may never fire on its units.
["ace_medical_woundReceived", {
    params ["_unit"];
    [_unit, "Hit"] call jces_main_fnc_aiTrigger;
}] call CBA_fnc_addEventHandler;
