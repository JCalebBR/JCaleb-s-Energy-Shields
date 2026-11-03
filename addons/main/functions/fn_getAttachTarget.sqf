/*
 * Author: JCaleb2014
 * Returns where a shield attaches to the unit. Dreadnought shields go on the dreadnought's hitbox object.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Shield type <STRING>
 *
 * Return Value:
 * [Object, Offset, Memory point ("" for none)] <ARRAY>
 *
 * Example:
 * [player, "Personal"] call jces_main_fnc_getAttachTarget
 *
 * Public: No
 */
params [["_unit", objNull, [objNull]], ["_type", "Personal", [""]]];

if (_type == "Personal") exitWith {
    [_unit, [0, 0.2, -0.4], "spine3"]
};
// Terminators use the dreadnought model for now, centred a metre above the unit's feet.
if (_type == "Terminator") exitWith {
    [_unit, [0, 0, 1], ""]
};

private _attached = (attachedObjects _unit) select {!(_x isKindOf "JCES_Shield_Oval_Base")};
private _index = _attached findIf {(_x getVariable ["HitBox_Param_Parent", objNull]) isEqualTo _unit};
// Older dreadnoughts don't set HitBox_Param_Parent, their hitbox is the first attached object.
if (_index == -1 && {_attached isNotEqualTo []}) then {
    _index = 0;
};

private _target = _unit;
if (_index != -1) then {
    _target = _attached select _index;
};

[_target, [0, 0, -1], ""]
