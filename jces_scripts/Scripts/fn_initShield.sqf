#include "script_component.hpp"
[{
	params["_player"];
	private ["_shield", "_bronze", "_iron", "_gold", "_type", "_items", "_obj", "_offset", "_bone", "_duration", "_cooldown"];

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
		_duration = missionNamespace getVariable ['jces_zen_shieldDurationBronze', -1];
		_cooldown = missionNamespace getVariable ['jces_zen_shieldCooldownBronze', -1];
		systemChat "JCES -> Bronze Tier";
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
		_duration = missionNamespace getVariable ['jces_zen_shieldDurationIron', -1];
		_cooldown = missionNamespace getVariable ['jces_zen_shieldCooldownIron', -1];
		systemChat "JCES -> Iron Tier";
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
		_duration = missionNamespace getVariable ['jces_zen_shieldDurationGold', -1];
		_cooldown = missionNamespace getVariable ['jces_zen_shieldCooldownGold', -1];
		systemChat "JCES -> Gold Tier";
	};

	if (str side _player == "EAST") then {
		_type = _type + "_OP"
	};

	systemChat format ["Duration %1 seconds | Cooldown %2 seconds", _duration, _cooldown];

	_shield = _type createVehicle getPosWorld _player;
	detach _shield;
	_shield attachTo [_obj, _offset, _bone];
	_shield allowDamage true;

	createVehicleCrew _shield;

	{
		_x addCuratorEditableObjects [[_shield], true];
	} forEach allCurators;
}, _this] call CBA_fnc_execNextFrame;