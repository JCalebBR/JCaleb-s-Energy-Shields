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
        // Add and Remove act on the unit under the cursor, only one of them shows at a time.
        class Add {
            displayName = "Add Shield";
            icon = "\a3\3den\data\displays\display3den\panelright\customcomposition_add_ca.paa";
            condition = "_hoveredEntity call jces_zen_fnc_canEditShield && {([_hoveredEntity] call jces_main_fnc_getShieldItems) isEqualTo []}";
            insertChildren = "_hoveredEntity call jces_zen_fnc_getAddActions";
        };
        class Remove {
            displayName = "Remove Shield";
            icon = "\a3\3den\data\displays\display3den\panelleft\entitylist_delete_ca.paa";
            condition = "_hoveredEntity call jces_zen_fnc_canEditShield && {([_hoveredEntity] call jces_main_fnc_getShieldItems) isNotEqualTo []}";
            statement = "['jces_main_removeShieldItems', [_hoveredEntity], _hoveredEntity] call CBA_fnc_targetEvent; ['Removed shield from %1', name _hoveredEntity] call zen_common_fnc_showMessage";
        };
    };
};
