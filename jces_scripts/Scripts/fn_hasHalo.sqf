#include "script_component.hpp"

params["_player"];
private ["_goggles", "_bronze", "_iron", "_gold", "_items"];

_bronze = missionNamespace getVariable "jces_halo_bronze";
_iron = missionNamespace getVariable "jces_halo_iron";
_gold = missionNamespace getVariable "jces_halo_gold";

_goggles = goggles _player;
_items = items player;

if (_bronze findIf {
	_x == _goggles || "JCES_Personal_Shield_Bronze" in _items;
} != -1) exitWith {
	true;
};
if (_iron findIf {
	_x == _goggles || "JCES_Personal_Shield_Iron" in _items;
} != -1) exitWith {
	true;
};
if (_gold findIf {
	_x == _goggles || "JCES_Personal_Shield_Gold" in _items;
} != -1) exitWith {
	true;
};
false;