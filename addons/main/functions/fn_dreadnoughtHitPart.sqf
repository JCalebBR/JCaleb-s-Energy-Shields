/*
 * Author: JCaleb2014
 * Replacement for the dreadnought hitbox's scripted health HitPart handler. Same damage rules,
 * but hits are ignored while a shield is attached to the hitbox. Runs on the shooter's machine.
 *
 * Arguments:
 * 0: HitPart entries, only the first is used <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * _hitbox addEventHandler ["HitPart", {_this call jces_main_fnc_dreadnoughtHitPart}]
 *
 * Public: No
 */
(_this select 0) params ["_target", "_shooter", "", "", "", "", "_ammo"];

if (isNull _shooter) exitWith {};
if ((attachedObjects _target) findIf {_x isKindOf "JCES_Shield_Oval_Base"} != -1) exitWith {
    ["dreadnoughtHitPart", "Hit on hitbox %1 from %2 blocked by its shield", _target, _shooter] call jces_main_fnc_log;
};

private _hitValue = _ammo select 0;
if (_hitValue < 100) exitWith {};

private _parent = _target getVariable ["HitBox_Param_Parent", objNull];
private _health = _parent getVariable "DT_Health";
if (isNil "_health") exitWith {};

_health = _health - ([8, 25] select (_hitValue >= 500));
_parent setVariable ["DT_Health", _health, true];
["dreadnoughtHitPart", "%1 hit by %2, DT_Health now %3", _parent, _shooter, _health] call jces_main_fnc_log;
if (_health <= 0) then {
    _parent setDamage 1;
    deleteVehicle _target;
};
