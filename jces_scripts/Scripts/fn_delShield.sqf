#include "script_component.hpp"
[{
	params["_player"];
	private["_res", "_valid", "_obj", "_objj"];

	_valid = missionNamespace getVariable "jces_shield_valid";
	_obj = attachedObjects _player;
	_objj = attachedObjects (_obj select 0);

	if (count _obj > 0) then {
		{
			if ((typeOf _x) in _valid) then {
				deleteVehicle _x;
				_res = true;
			};
		} forEach (_obj);
		{
			if ((typeOf _x) in _valid) then {
				deleteVehicle _x;
				_res = true;
			};
		} forEach (_objj);
		if (_res == true) then {
			ace_player call jces_shield_fnc_setCooldown;
		};
	};
}, _this] call CBA_fnc_execNextFrame;