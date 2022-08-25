#include "script_component.hpp"
[{
	params["_player"];
	private["_res", "_valid", "_obj"];

	_valid = ["JCES_Shield_Oval_Bronze", "JCES_Shield_Oval_Iron", "JCES_Shield_Oval_Gold"];
	_obj = attachedObjects _player;

	if (count _obj > 0) then {
		{
			if ((typeOf _x) in _valid) then {
				deleteVehicle _x;
				_res = true;
			};
		} forEach (_obj);
		if (_res == true) then {
			ace_player call jces_shield_fnc_setCooldown;
		};
	};
}, _this] call CBA_fnc_execNextFrame;