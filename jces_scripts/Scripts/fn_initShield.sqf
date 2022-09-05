#include "script_component.hpp"
[{
	params["_player"];
	private ["_shield", "_bronze", "_iron", "_gold", "_type", "_items", "_obj", "_offset", "_bone"];

	_bronze = missionNamespace getVariable "jces_halo_bronze";
	_iron = missionNamespace getVariable "jces_halo_iron";
	_gold = missionNamespace getVariable "jces_halo_gold";

	_goggles = goggles _player;
	_items = items _player;
	_offset = [0, 0.2, -0.4];
	_bone = "spine3";
	_obj = _player;

	if (_bronze findIf {
		_x == _goggles || "JCES_Personal_Shield_Bronze" in _items || "JCES_Personal_Shield_Dreadnought_Bronze" in _items;
	} != -1) then {
		_type = "JCES_Shield_Oval_Bronze";
		if ("JCES_Personal_Shield_Dreadnought_Bronze" in _items) then {
			_type = "JCES_Shield_Oval_Dreadnought_Bronze";
			_offset = [0, 0, -1];
			_bone = "";
			_obj = attachedObjects _player;
			_obj = _obj select 0;
			_player call jces_shield_fnc_dreadEH;
		};
	};
	if (_iron findIf {
		_x == _goggles || "JCES_Personal_Shield_Iron" in _items || "JCES_Personal_Shield_Dreadnought_Iron" in _items;
	} != -1) then {
		_type = "JCES_Shield_Oval_Iron";
		if ("JCES_Personal_Shield_Dreadnought_Iron" in _items) then {
			_type = "JCES_Shield_Oval_Dreadnought_Iron";
			_offset = [0, 0, -1];
			_bone = "";
			_obj = attachedObjects _player;
			_obj = _obj select 0;
			_player call jces_shield_fnc_dreadEH;
		};
	};
	if (_gold findIf {
		_x == _goggles || "JCES_Personal_Shield_Gold" in _items || "JCES_Personal_Shield_Dreadnought_Gold" in _items;
	} != -1) then {
		_type = "JCES_Shield_Oval_Gold";
		if ("JCES_Personal_Shield_Dreadnought_Gold" in _items) then {
			_type = "JCES_Shield_Oval_Dreadnought_Gold";
			_offset = [0, 0, -1];
			_bone = "";
			_obj = attachedObjects _player;
			_obj = _obj select 0;
			_player call jces_shield_fnc_dreadEH;
		};
	};

	if (str side _player == "EAST") then {
		_type = _type + "_OP"
	};

	_shield = _type createVehicle getPosWorld _player;
	detach _shield;
	_shield attachTo [_obj, _offset, _bone];
	_shield allowDamage true;

	createVehicleCrew _shield;

	{
		_x addCuratorEditableObjects [[_shield], false];
	} forEach allCurators;
}, _this] call CBA_fnc_execNextFrame;