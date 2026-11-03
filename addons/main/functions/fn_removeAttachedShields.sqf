/*
 * Author: JCaleb2014
 * Deletes any shield attached to the unit or its attached objects (e.g. a dreadnought hitbox) without
 * touching shield state. Used on the server when the owner disconnects.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit] call jces_main_fnc_removeAttachedShields
 *
 * Public: No
 */
params [["_unit", objNull, [objNull]]];

private _attached = attachedObjects _unit;
private _candidates = +_attached;
{
    _candidates append (attachedObjects _x);
} forEach _attached;

{
    if (_x isKindOf "JCES_Shield_Oval_Base") then {
        private _shield = _x;
        ["removeAttachedShields", "Deleting %1 left on %2", _shield, _unit] call jces_main_fnc_log;
        {
            _shield deleteVehicleCrew _x;
        } forEach crew _shield;
        deleteVehicle _shield;
    };
} forEach _candidates;
