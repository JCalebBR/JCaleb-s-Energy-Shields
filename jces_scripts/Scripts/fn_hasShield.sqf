#include "script_component.hpp"

params["_player"];
private["_res", "_valid", "_obj"];

_res = false;
_valid = ["JCES_Shield_Oval_Bronze", "JCES_Shield_Oval_Iron", "JCES_Shield_Oval_Gold"];
_obj = attachedObjects _player;
if (count _obj > 0) then {
	{
		if ((typeOf _x) in _valid) then {
			_res = true;
		};
	} forEach (_obj);
};
if (_res == true) then {
	true;
} else {
	false;
};