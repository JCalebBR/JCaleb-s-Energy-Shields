params [
	["_module", objNull, [objNull]],
	["_units", [], [[]]],
	["_activated", true, [true]]
];

if (!isServer) exitWith {};

if (_activated) then {
	systemChat "Initializing module settings...";
	private _shieldDurationBronze = _module getVariable "ShieldDurationBronze";
	private _shieldCooldownBronze = _module getVariable "ShieldCooldownBronze";
	private _shieldDurationIron = _module getVariable "ShieldDurationIron";
	private _shieldCooldownIron = _module getVariable "ShieldCooldownIron";
	private _shieldDurationGold = _module getVariable "ShieldDurationGold";
	private _shieldCooldownGold = _module getVariable "ShieldCooldownGold";

	jces_zen_shieldDurationBronze = _shieldDurationBronze;
	jces_zen_shieldCooldownBronze = _shieldCooldownBronze;
	jces_zen_shieldDurationIron = _shieldDurationIron;
	jces_zen_shieldCooldownIron = _shieldCooldownIron;
	jces_zen_shieldDurationGold = _shieldDurationGold;
	jces_zen_shieldCooldownGold = _shieldCooldownGold;

	publicVariable "jces_zen_shieldDurationBronze";
	publicVariable "jces_zen_shieldCooldownBronze";
	publicVariable "jces_zen_shieldDurationIron";
	publicVariable "jces_zen_shieldCooldownIron";
	publicVariable "jces_zen_shieldDurationGold";
	publicVariable "jces_zen_shieldCooldownGold";
	systemChat "Module initialized";
};