params["_player"];
private ["_nobjs", "_hitbox"];
systemChat "Replacing default dreadnought script";
_nobjs = attachedObjects _player;
_hitbox = _nobjs select 0;
_hitbox removeEventHandler ["HitPart", 0];
[_hitbox, {
	_unit = _this;
	_unit addEventHandler ["HitPart", {
		_objs = attachedObjects ((_this select 0) select 0);
		_valid = ["JCES_Shield_Oval_Bronze", "JCES_Shield_Oval_Iron", "JCES_Shield_Oval_Gold", "JCES_Shield_Oval_Bronze_OP", "JCES_Shield_Oval_Iron_OP", "JCES_Shield_Oval_Gold_OP", "JCES_Shield_Oval_Dreadnought_Bronze", "JCES_Shield_Oval_Dreadnought_Iron", "JCES_Shield_Oval_Dreadnought_Gold", "JCES_Shield_Oval_Dreadnought_Bronze_OP", "JCES_Shield_Oval_Dreadnought_Iron_OP", "JCES_Shield_Oval_Dreadnought_Gold_OP"];
		(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"];
		if (count _objs > 0 && typeOf(_objs select 0) in _valid) exitWith {};
		_partOfTheBody = _selection select 0;
		_penemParam = _ammo select 0;
		if (isNull _shooter) exitWith {};
		if ((_penemParam >= 100) and (_penemParam < 500)) exitWith {
			_par = _target getVariable "HitBox_Param_Parent";
			_health = _par getVariable "DT_Health";
			_health = _health - 8;
			_par setVariable ["DT_Health", _health, true];
			if (_health <= 0) exitWith {
				_par setDamage 1;
				deleteVehicle _target;
			};
		};
		if ((_penemParam >= 500)) exitWith {
			_par = _target getVariable "HitBox_Param_Parent";
			_health = _par getVariable "DT_Health";
			_health = _health - 25;
			_par setVariable ["DT_Health", _health, true];
			if (_health <= 0) exitWith {
				_par setDamage 1;
				deleteVehicle _target;
			};
		};
	}];
}] remoteExec ["spawn", 0];