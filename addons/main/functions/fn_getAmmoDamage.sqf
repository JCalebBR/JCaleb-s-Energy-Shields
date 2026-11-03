/*
 * Author: JCaleb2014
 * Estimates how much shield health a hit removes.
 * Kinetic part: the round's penetration in mm of RHA, typicalSpeed * (typicalSpeed / 1000) * caliber * 15 / 1000 * (1 - explosive),
 * which grows with speed squared and calibre like kinetic energy does.
 * Explosive part: explosive * hit for direct hits, explosive * indirectHit for splash, reduced by distance.
 * Ammo values are cached per class.
 *
 * Arguments:
 * 0: Ammo class <STRING>
 * 1: Direct hit <BOOL> (default: true)
 * 2: Splash falloff, 0 to 1 <NUMBER> (default: 1)
 *
 * Return Value:
 * Shield damage <NUMBER>
 *
 * Example:
 * ["B_556x45_Ball"] call jces_main_fnc_getAmmoDamage
 *
 * Public: Yes
 */
params [["_ammo", "", [""]], ["_directHit", true, [true]], ["_falloff", 1, [0]]];

(jces_main_ammoCache getOrDefaultCall [_ammo, {
    private _config = configFile >> "CfgAmmo" >> _ammo;
    private _speed = getNumber (_config >> "typicalSpeed");
    private _explosive = getNumber (_config >> "explosive");
    private _penetration = _speed * (_speed / 1000) * getNumber (_config >> "caliber") * 15 / 1000 * (1 - _explosive);
    [_penetration, _explosive * getNumber (_config >> "hit"), _explosive, getNumber (_config >> "indirectHit")]
}, true]) params ["_penetration", "_directBlast", "_explosive", "_indirectHit"];

if (_directHit) exitWith {
    _penetration * jces_main_kineticMultiplier + _directBlast * jces_main_explosiveMultiplier
};

_explosive * _indirectHit * _falloff * jces_main_explosiveMultiplier
