params["_player"];
private["_goggles", "_cooldown", "_bronze", "_iron", "_gold", "_items", "_duration"];

_cooldown = -1;
_bronze = missionNamespace getVariable "jces_halo_bronze";
_iron = missionNamespace getVariable "jces_halo_iron";
_gold = missionNamespace getVariable "jces_halo_gold";

_goggles = goggles _player;
_items = items _player;
_duration = "";

if (_bronze findIf {
	_x == _goggles || "JCES_Personal_Shield_Bronze" in _items;
} != -1) then {
	_duration = missionNamespace getVariable ['jces_zen_shieldDurationBronze', -1];
	_cooldown = missionNamespace getVariable ['jces_zen_shieldCooldownBronze', -1];
	systemChat "JCES -> Bronze Tier";
};
if (_iron findIf {
	_x == _goggles || "JCES_Personal_Shield_Iron" in _items;
} != -1) then {
	_duration = missionNamespace getVariable ['jces_zen_shieldDurationIron', -1];
	_cooldown = missionNamespace getVariable ['jces_zen_shieldCooldownIron', -1];
	systemChat "JCES -> Iron Tier";
};
if (_gold findIf {
	_x == _goggles || "JCES_Personal_Shield_Gold" in _items;
} != -1) then {
	_duration = missionNamespace getVariable ['jces_zen_shieldDurationGold', -1];
	_cooldown = missionNamespace getVariable ['jces_zen_shieldCooldownGold', -1];
	systemChat "JCES -> Gold Tier";
};
systemChat format ["Duration %1 seconds | Cooldown %2 seconds", _duration,_cooldown];
uiNamespace setVariable ['jces_shield_cooldown', (diag_tickTime + _cooldown)];