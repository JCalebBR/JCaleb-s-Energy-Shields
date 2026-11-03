/*
 * Author: JCaleb2014
 * HitPart handler for shields, added to every shield on every machine by XEH.
 * HitPart only fires on the shooter's machine, so the damage is worked out here and sent to the
 * shield owner's machine. One call per projectile, only the first entry is used.
 *
 * Arguments:
 * 0: HitPart entries <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * _this call jces_main_fnc_handleHitPart
 *
 * Public: No
 */
(_this select 0) params ["_shield", "_shooter", "_projectile", "_position", "", "", "_ammo", "", "", "", ["_isDirect", true], ["_instigator", objNull]];
_ammo params ["", "", "_indirectHitRange", "", "_ammoClass"];

private _falloff = 1;
if (!_isDirect && {!isNull _projectile} && {_indirectHitRange > 0}) then {
    // Full damage inside indirectHitRange, dropping off with distance squared outside it.
    private _distance = (getPosASL _projectile) vectorDistance _position;
    _falloff = ((_indirectHitRange / (_distance max 0.01)) ^ 2) min 1;
};

private _damage = [_ammoClass, _isDirect, _falloff] call jces_main_fnc_getAmmoDamage;
if (_damage <= 0) exitWith {};

if (isNull _instigator) then {
    _instigator = _shooter;
};
["jces_main_shieldHit", [_shield, _damage, _instigator, _ammoClass], _shield] call CBA_fnc_targetEvent;
