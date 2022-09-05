#define _ARMA_
class CfgPatches {
    class JCalebs_Energy_Shields_Scripts {
        name = "JCaleb's Energy Shields (Scripts)";
        author = "JCaleb2014";
        requiredVersion = 1.6;
        requiredAddons[] = {"ace_interaction"};
        units[] = {};
    };
};

class ACE_SelfActions;
class ACE_Actions;
class ACE_MainActions;

class CfgFunctions {
    class jces_shield {
        class jces_shield_scripts {
            file = "\CalebsShields\jces_scripts\Scripts";
            class initTypes {
                postInit = 1;
            };
            class hasShield {};
            class hasHalo {};
            class checkShieldCooldown {};
            class setCooldown {};
            class initShield {};
            class delShield {};
            class delShieldAfterCooldown {};
            class dreadEH {};
        };
    };
};

class CfgVehicles {
    class CAManBase {
        class ACE_SelfActions : ACE_SelfActions {
            class sm_halo_shield_on {
                displayName = "Activate Shield";
                condition = "(ace_player call jces_shield_fnc_hasHalo) && !(ace_player call jces_shield_fnc_hasShield) && (ace_player call jces_shield_fnc_checkShieldCooldown)";
                statement = "ace_player call jces_shield_fnc_initShield;ace_player call jces_shield_fnc_delShieldAfterCooldown;";
                exceptions[] = {"isNotSwimming", "isNotInside", "notOnMap", "isNotSitting"};
                icon = "CalebsShields\jces_meta\logo.paa";
            };
            class sm_halo_shield_off : sm_halo_shield_on {
                displayName = "Deactivate Shield";
                condition = "(ace_player call jces_shield_fnc_hasHalo)  && (ace_player call jces_shield_fnc_hasShield)";
                statement = "ace_player call jces_shield_fnc_delShield";
            };
        };
    };
};