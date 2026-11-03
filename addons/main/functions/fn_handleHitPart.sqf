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
if (_damage <= 0) exitWith {
    ["handleHitPart", "%1 hit by %2 deals no damage", _shield, _ammoClass] call jces_main_fnc_log;
};

if (isNull _instigator) then {
    _instigator = _shooter;
};
["handleHitPart", "%1 hit by %2 from %3: direct %4, falloff %5, %6 damage, sending to the shield's owner", _shield, _ammoClass, _instigator, _isDirect, _falloff, _damage] call jces_main_fnc_log;
["jces_main_shieldHit", [_shield, _damage, _instigator, _ammoClass], _shield] call CBA_fnc_targetEvent;
