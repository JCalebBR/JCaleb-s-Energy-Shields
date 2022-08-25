#include "\a3\editor_f\Data\Scripts\dikCodes.h"

private _modName = "JCaleb's Energy Shields";

[_modName, "jces_gui_shield_on_key", "Activate Shield", {
	if ((ace_player call jces_shield_fnc_hasHalo) && !(ace_player call jces_shield_fnc_hasShield) && (ace_player call jces_shield_fnc_checkShieldCooldown)) then {
		ace_player call jces_shield_fnc_initShield;
		ace_player call jces_shield_fnc_delShieldAfterCooldown;
	};
}, "", [DIK_K, [true, true, false]]] call CBA_fnc_addKeybind;

[_modName, "jces_gui_shield_off_key", "Deactivate Shield", {
	if ((ace_player call jces_shield_fnc_hasHalo) && (ace_player call jces_shield_fnc_hasShield)) then {
		ace_player call jces_shield_fnc_delShield
	};
}, "", [DIK_L, [true, true, false]]] call CBA_fnc_addKeybind;