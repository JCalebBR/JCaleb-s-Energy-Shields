/*
 * Author: JCaleb2014
 * Flashes a lightning pattern over a shield that was hit, fading back to its normal texture.
 * Runs on every client (jces_main_shieldHitEffect event), the texture swaps are local only.
 * A new hit restarts the flash, so a shield under sustained fire keeps flickering.
 *
 * Arguments:
 * 0: Shield <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_shield] call jces_main_fnc_playHitEffect
 *
 * Public: No
 */
params [["_shield", objNull, [objNull]]];

if (!hasInterface || {!jces_main_hitEffects} || {isNull _shield}) exitWith {};
if ((positionCameraToWorld [0, 0, 0]) distance _shield > 1000) exitWith {};

private _token = (_shield getVariable ["jces_main_effectToken", 0]) + 1;
_shield setVariable ["jces_main_effectToken", _token];

private _steps = jces_main_hitTextures select (_shield getVariable ["jces_main_colorIndex", 0]);
private _lastStep = count _steps - 1;

// [delay, fade step], -1 restores the normal texture.
{
    _x params ["_delay", "_step"];
    [{
        params ["_shield", "_token", "_steps", "_step", "_lastStep"];
        // Skipped once the shield is gone or a newer hit took over.
        if (isNull _shield || {(_shield getVariable ["jces_main_effectToken", 0]) != _token}) exitWith {};
        if (_step < 0) exitWith {
            (jces_main_shieldTextures select (_shield getVariable ["jces_main_colorIndex", 0])) params ["_outside", "_inside"];
            _shield setObjectTexture [0, _outside];
            _shield setObjectTexture [1, _inside];
        };
        // The inside is one step dimmer so the flash doesn't blind the unit in it.
        _shield setObjectTexture [0, _steps select _step];
        _shield setObjectTexture [1, _steps select ((_step + 1) min _lastStep)];
    }, [_shield, _token, _steps, _step, _lastStep], _delay] call CBA_fnc_waitAndExecute;
} forEach [[0, 0], [0.08, 1], [0.16, 2], [0.28, -1]];
