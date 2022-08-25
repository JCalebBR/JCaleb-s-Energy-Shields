params["_player"];
private["_goggles", "_cooldown", "_bronze", "_iron", "_gold", "_items"];

_cooldown = -1;
_bronze = missionNamespace getVariable "jces_halo_bronze";
_iron = missionNamespace getVariable "jces_halo_iron";
_gold = missionNamespace getVariable "jces_halo_gold";

_goggles = goggles _player;
_items = items _player;

if (_bronze findIf {
	_x == _goggles || "JCES_Personal_Shield_Bronze" in _items;
} != -1) then {
	_cooldown = missionNamespace getVariable ['jces_zen_shieldCooldownBronze', -1];
	systemChat "-> Detected Bronze Tier";
};
if (_iron findIf {
	_x == _goggles || "JCES_Personal_Shield_Iron" in _items;
} != -1) then {
	_cooldown = missionNamespace getVariable ['jces_zen_shieldCooldownIron', -1];
	systemChat "-> Detected Iron Tier";
};
if (_gold findIf {
	_x == _goggles || "JCES_Personal_Shield_Gold" in _items;
} != -1) then {
	_cooldown = missionNamespace getVariable ['jces_zen_shieldCooldownGold', -1];
	systemChat "-> Detected Gold Tier";
};

uiNamespace setVariable ['jces_shield_cooldown', (diag_tickTime + _cooldown)];
systemChat format ["Shield cooldown: %1 seconds", _cooldown];