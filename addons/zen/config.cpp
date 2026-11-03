class CfgPatches {
    class jces_zen {
        name = "JCaleb's Energy Shields - ZEN Compatibility";
        author = "JCaleb2014";
        requiredVersion = 2.18;
        requiredAddons[] = {"jces_main", "zen_context_menu"};
        // Optional, only loads when Zeus Enhanced is present.
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class jces_zen {
        class zen {
            file = "\CalebsShields\addons\zen\functions";
            class canEditShield {};
            class getAddActions {};
            class removeShields {};
            class toggleShields {};
        };
    };
};

// Zeus context menu (V by default).
class zen_context_menu_actions {
    class jces_zen_energyShields {
        displayName = "Energy Shields";
        icon = "\CalebsShields\addons\main\data\logo.paa";
        condition = "_objects findIf {_x call jces_zen_fnc_canEditShield} != -1";
        priority = 30;
        class Toggle {
            displayName = "Toggle Shield";
            icon = "\CalebsShields\addons\main\data\logo.paa";
            condition = "_objects findIf {_x call jces_zen_fnc_canEditShield && {([_x] call jces_main_fnc_getShieldDevice) isNotEqualTo []}} != -1";
            statement = "_objects call jces_zen_fnc_toggleShields";
        };
        // Add only shows units without a shield, Remove only units with one, a mixed selection shows both.
        class Add {
            displayName = "Add Shield";
            icon = "\a3\3den\data\displays\display3den\panelright\customcomposition_add_ca.paa";
            condition = "_objects findIf {_x call jces_zen_fnc_canEditShield && {([_x] call jces_main_fnc_getShieldItems) isEqualTo []}} != -1";
            insertChildren = "_objects call jces_zen_fnc_getAddActions";
        };
        class Remove {
            displayName = "Remove Shield";
            icon = "\a3\3den\data\displays\display3den\panelleft\entitylist_delete_ca.paa";
            condition = "_objects findIf {_x call jces_zen_fnc_canEditShield && {([_x] call jces_main_fnc_getShieldItems) isNotEqualTo []}} != -1";
            statement = "_objects call jces_zen_fnc_removeShields";
        };
    };
};
