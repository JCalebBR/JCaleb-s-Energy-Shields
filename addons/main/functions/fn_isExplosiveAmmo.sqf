/*
 * Author: JCaleb2014
 * Checks if an ammo class explodes with splash damage (grenades, launchers, shells), as opposed to bullets.
 * Results are cached per class.
 *
 * Arguments:
 * 0: Ammo class <STRING>
 *
 * Return Value:
 * Explosive with splash <BOOL>
 *
 * Example:
 * ["GrenadeHand"] call jces_main_fnc_isExplosiveAmmo
 *
 * Public: No
 */
params [["_ammo", "", [""]]];

jces_main_explosiveAmmoCache getOrDefaultCall [_ammo, {
    private _config = configFile >> "CfgAmmo" >> _ammo;
    // Some HE autocannon and tracer rounds have a tiny splash, they're closer to bullets.
    getNumber (_config >> "explosive") > 0 && {getNumber (_config >> "indirectHitRange") >= 2}
}, true]
