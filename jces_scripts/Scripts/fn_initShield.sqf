#include "script_component.hpp"
[{
	params["_player"];
	private ["_shield", "_bronze", "_iron", "_gold", "_type", "_items"];

	_bronze = missionNamespace getVariable "jces_halo_bronze";
	_iron = missionNamespace getVariable "jces_halo_iron";
	_gold = missionNamespace getVariable "jces_halo_gold";

	_goggles = goggles _player;
	_items = items _player;

	if (_bronze findIf {
		_x == _goggles || "JCES_Personal_Shield_Bronze" in _items;
	} != -1) then {
		_type = "JCES_Shield_Oval_Bronze";
	};
	if (_iron findIf {
		_x == _goggles || "JCES_Personal_Shield_Iron" in _items;
	} != -1) then {
		_type = "JCES_Shield_Oval_Iron";
	};
	if (_gold findIf {
		_x == _goggles || "JCES_Personal_Shield_Gold" in _items;
	} != -1) then {
		_type = "JCES_Shield_Oval_Gold";
	};

	if (str side _player == "EAST") then {
		_type = _type + "_OP"
	};

	_shield = _type createVehicle getPosWorld _player;
	detach _shield;
	_shield attachTo [_player, [0, 0.2, -0.4], "spine3"];
	_shield allowDamage true;

	createVehicleCrew _shield;

	{
		_x addCuratorEditableObjects [[_shield], false];
	} forEach allCurators;
}, _this] call CBA_fnc_execNextFrame;