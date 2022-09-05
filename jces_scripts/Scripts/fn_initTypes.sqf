private["_bronze", "_iron", "_gold", "_valid"];

_bronze = [];
_bronze pushBack "iron_halo_dos_s_3";
_bronze pushBack "iron_halo_dos_3";
_bronze pushBack "JCES_Personal_Shield_Bronze";

_iron = [];
_iron pushBack "iron_halo_dos_s";
_iron pushBack "iron_halo_dos";
_iron pushBack "JCES_Personal_Shield_Iron";

_gold = [];
_gold pushBack "da_halo1";
_gold pushback "iron_halo_dos_s_2";
_gold pushback "iron_halo_dos_2";
_gold pushBack "bt_iron_halo_gold";
_gold pushBack "bt_ironhalo1";
_gold pushBack "JCES_Personal_Shield_Gold";

_valid = ["JCES_Shield_Oval_Bronze", "JCES_Shield_Oval_Iron", "JCES_Shield_Oval_Gold", "JCES_Shield_Oval_Bronze_OP", "JCES_Shield_Oval_Iron_OP", "JCES_Shield_Oval_Gold_OP", "JCES_Shield_Oval_Dreadnought_Bronze", "JCES_Shield_Oval_Dreadnought_Iron", "JCES_Shield_Oval_Dreadnought_Gold", "JCES_Shield_Oval_Dreadnought_Bronze_OP", "JCES_Shield_Oval_Dreadnought_Iron_OP", "JCES_Shield_Oval_Dreadnought_Gold_OP"];

jces_halo_bronze = _bronze;
jces_halo_iron = _iron;
jces_halo_gold = _gold;
jces_shield_valid = _valid;

publicVariable "jces_halo_bronze";
publicVariable "jces_halo_iron";
publicVariable "jces_halo_gold";
publicVariable "jces_shield_valid";
{
	private _shieldDurationBronze = missionNamespace getVariable "jces_zen_shieldDurationBronze";
	private _shieldCooldownBronze = missionNamespace getVariable "jces_zen_shieldCooldownBronze";
	private _shieldDurationIron = missionNamespace getVariable "jces_zen_shieldDurationIron";
	private _shieldCooldownIron = missionNamespace getVariable "jces_zen_shieldCooldownIron";
	private _shieldDurationGold = missionNamespace getVariable "jces_zen_shieldDurationGold";
	private _shieldCooldownGold = missionNamespace getVariable "jces_zen_shieldCooldownGold";

	if (isNil "_shieldDurationBronze") then {
		jces_zen_shieldDurationBronze = 30;
	};
	if (isNil "_shieldCooldownBronze") then {
		jces_zen_shieldCooldownBronze = 120;
	};
	if (isNil "_shieldDurationIron") then {
		jces_zen_shieldDurationIron = 40;
	};
	if (isNil "_shieldCooldownIron") then {
		jces_zen_shieldCooldownIron = 150;
	};
	if (isNil "_shieldDurationGold") then {
		jces_zen_shieldDurationGold = 60;
	};
	if (isNil "_shieldCooldownGold") then {
		jces_zen_shieldCooldownGold = 180;
	};
	if (isServer) then {
		{
			publicVariable _x;
		} forEach ["jces_zen_shieldDurationBronze", "jces_zen_shieldCooldownBronze", "jces_zen_shieldDurationIron", "jces_zen_shieldCooldownIron", "jces_zen_shieldDurationGold", "jces_zen_shieldCooldownGold"];
	};
	if (!hasInterface) exitWith {};
	ace_player call jces_shield_fnc_setCooldown;
} remoteExecCall ["call", 0, true];