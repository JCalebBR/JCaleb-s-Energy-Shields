/*
 * Author: JCaleb2014
 * Applies damage to a shield, recolouring or breaking it. Runs where the shield's owner is local,
 * sent there by jces_main_fnc_handleHitPart through the jces_main_shieldHit event.
 *
 * Arguments:
 * 0: Shield <OBJECT>
 * 1: Damage <NUMBER>
 * 2: Instigator <OBJECT>
 * 3: Ammo class, for the rapid fire reduction <STRING> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_shield, 10, _shooter, "B_556x45_Ball"] call jces_main_fnc_damageShield
 *
 * Public: No
 */
params [["_shield", objNull, [objNull]], ["_damage", 0, [0]], ["_instigator", objNull, [objNull]], ["_ammo", "", [""]]];

if (_damage <= 0 || {_shield getVariable ["jces_main_broken", false]}) exitWith {};

private _unit = _shield getVariable ["jces_main_owner", objNull];
if ((_unit getVariable ["jces_main_shieldObject", objNull]) isNotEqualTo _shield) exitWith {};

if (_instigator isEqualTo _unit) exitWith {};

// Everyone sees the hit effect, even for hits that do no damage (friendly fire).
private _hasHitLayer = getNumber (configOf _shield >> "jces_hitLayer") == 1;
if (_hasHitLayer) then {
    // Sweep the Hit layer's UVs from 0 to 1, the engine syncs it. A running sweep is left to finish.
    private _phase = _shield animationSourcePhase "jces_hit";
    if (_phase == 0 || {_phase >= 1}) then {
        _shield animateSource ["jces_hit", 0, true];
        _shield animateSource ["jces_hit", 1];
    };
} else {
    // Texture swap flash on every client, throttled per shield.
    if (CBA_missionTime >= (_shield getVariable ["jces_main_nextHitEffect", 0])) then {
        _shield setVariable ["jces_main_nextHitEffect", CBA_missionTime + 0.15];
        ["jces_main_shieldHitEffect", [_shield]] call CBA_fnc_globalEvent;
    };
};
if (jces_main_ignoreFriendlyFire && {!isNull _instigator} && {((side group _unit) getFriend (side group _instigator)) >= 0.6}) exitWith {};

// Rapid fire reduction: every earlier hit of the same ammo within the window adds the factor to the divisor,
// so sustained fast fire is worth far less per round while a single heavy hit keeps its full damage.
if (jces_main_rapidFireEnabled && {_ammo isNotEqualTo ""}) then {
    private _recentHits = _shield getVariable "jces_main_recentHits";
    if (isNil "_recentHits") then {
        _recentHits = createHashMap;
        _shield setVariable ["jces_main_recentHits", _recentHits];
    };
    private _cutoff = CBA_missionTime - jces_main_rapidFireWindow;
    private _times = (_recentHits getOrDefault [_ammo, []]) select {_x > _cutoff};
    _damage = _damage / (1 + count _times * jces_main_rapidFireFactor);
    _times pushBack CBA_missionTime;
    _recentHits set [_ammo, _times];
};

private _maxHealth = _unit getVariable ["jces_main_maxHealth", 1];
private _health = ((_unit getVariable ["jces_main_health", 0]) - _damage) max 0;
_unit setVariable ["jces_main_health", _health];

["jces_main_shieldDamaged", [_unit, _shield, _damage, _health]] call CBA_fnc_localEvent;

if (_health == 0) exitWith {
    _shield setVariable ["jces_main_broken", true];
    // Hits arrive from inside HitPart handlers, deleting the shield there is unsafe, wait a frame.
    [jces_main_fnc_deactivate, [_unit, true]] call CBA_fnc_execNextFrame;
};

private _colorIndex = [_health / _maxHealth] call jces_main_fnc_getHealthColorIndex;
if (_colorIndex != (_unit getVariable ["jces_main_colorIndex", 0])) then {
    _unit setVariable ["jces_main_colorIndex", _colorIndex];
    // Public so the hit flash on other machines can fade back to the right colour.
    _shield setVariable ["jces_main_colorIndex", _colorIndex, true];
    (jces_main_shieldTextures select _colorIndex) params ["_outside", "_inside"];
    _shield setObjectTextureGlobal [0, _outside];
    _shield setObjectTextureGlobal [1, _inside];
    if (_hasHitLayer) then {
        _shield setObjectTextureGlobal [2, jces_main_hitLayerTextures select _colorIndex];
    };
};
