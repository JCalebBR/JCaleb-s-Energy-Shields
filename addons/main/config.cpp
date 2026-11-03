class CfgPatches {
    class jces_main {
        name = "JCaleb's Energy Shields - Main";
        author = "JCaleb2014";
        requiredVersion = 2.18;
        requiredAddons[] = {"cba_main", "ace_interact_menu", "JCalebs_Energy_Shields"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class jces_main {
        class main {
            file = "\CalebsShields\addons\main\functions";
            class activate {};
            class aiTrigger {};
            class canActivate {};
            class damageShield {};
            class deactivate {};
            class dreadnoughtHitPart {};
            class getAmmoDamage {};
            class getAttachTarget {};
            class getAvailableItems {};
            class getDeviceConfig {};
            class getHealthColorIndex {};
            class getShieldDevice {};
            class getShieldItems {};
            class getUnitType {};
            class handleHitPart {};
            class isActive {};
            class isExplosiveAmmo {};
            class playHitEffect {};
            class playSound {};
            class removeAttachedShields {};
            class toggle {};
        };
    };
};

class Extended_PreInit_EventHandlers {
    class jces_main {
        init = "call compileScript ['\CalebsShields\addons\main\XEH_preInit.sqf']";
    };
};

class Extended_PostInit_EventHandlers {
    class jces_main {
        init = "call compileScript ['\CalebsShields\addons\main\XEH_postInit.sqf']";
    };
};

// HitPart fires on the shooter's machine, XEH adds the handler to every shield on every machine.
class Extended_HitPart_EventHandlers {
    class JCES_Shield_Oval_Base {
        class jces_main {
            hitPart = "_this call jces_main_fnc_handleHitPart";
        };
    };
};

class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class jces_main_activate {
                displayName = "Activate Shield";
                condition = "[_player] call jces_main_fnc_canActivate";
                statement = "[_player] call jces_main_fnc_activate";
                exceptions[] = {"isNotSwimming", "isNotSitting"};
                icon = "\CalebsShields\addons\main\data\logo.paa";
            };
            class jces_main_deactivate: jces_main_activate {
                displayName = "Deactivate Shield";
                condition = "[_player] call jces_main_fnc_isActive";
                statement = "[_player] call jces_main_fnc_deactivate";
                exceptions[] = {"isNotSwimming", "isNotSitting", "isNotInside", "notOnMap"};
            };
        };
    };
};
