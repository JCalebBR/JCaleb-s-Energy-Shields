#include "script_component.hpp"

params["_player"];
private["_duration", "_bronze", "_iron", "_gold", "_items"];

_bronze = missionNamespace getVariable "jces_halo_bronze";
_iron = missionNamespace getVariable "jces_halo_iron";
_gold = missionNamespace getVariable "jces_halo_gold";

_goggles = goggles _player;
_items = items _player;

_duration = 0;

if (_bronze findIf {
	_x == _goggles || "JCES_Personal_Shield_Bronze" in _items;
} != -1) then {
	_duration = missionNamespace getVariable ['jces_zen_shieldDurationBronze', -1];
};
if (_iron findIf {
	_x == _goggles || "JCES_Personal_Shield_Iron" in _items;
} != -1) then {
	_duration = missionNamespace getVariable ['jces_zen_shieldDurationIron', -1];
};
if (_gold findIf {
	_x == _goggles || "JCES_Personal_Shield_Gold" in _items;
} != -1) then {
	_duration = missionNamespace getVariable ['jces_zen_shieldDurationGold', -1];
};
systemChat format ["Shield duration: %1 seconds", _duration];
["", {
	ace_player call jces_shield_fnc_delShield;
}, _duration] call BIS_fnc_runLater;