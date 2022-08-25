#define _ARMA_
class CfgPatches {
    class JCalebs_Energy_Shields_GUI {
        name = "JCaleb's Energy Shields (GUI)";
        author = "JCaleb2014";
        requiredVersion = 1.6;
        requiredAddons[] = {"cba_keybinding", "JCalebs_Energy_Shields_Scripts"};
        units[] = {};
    };
};

class CfgFunctions {
    class jces_gui {
        class jces_gui_scripts {
            file = "\CalebsShields\jces_gui\Scripts";
            class setKeybinds {
                postInit = 1;
            };
        };
    };
};
