class CfgPatches {
    class jces_ui {
        name = "JCaleb's Energy Shields - UI";
        author = "JCaleb2014";
        requiredVersion = 2.18;
        requiredAddons[] = {"A3_Ui_F", "cba_main", "jces_main"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class jces_ui {
        class ui {
            file = "\CalebsShields\addons\ui\functions";
            class hudLayout {};
            class hudUpdate {};
        };
    };
};

class Extended_PreInit_EventHandlers {
    class jces_ui {
        init = "call compileScript ['\CalebsShields\addons\ui\XEH_preInit.sqf']";
    };
};

class Extended_PostInit_EventHandlers {
    class jces_ui {
        init = "call compileScript ['\CalebsShields\addons\ui\XEH_postInit.sqf']";
    };
};

class RscPicture;
class RscText;
class RscControlsGroupNoScrollbars;

// Positions are all set by jces_ui_fnc_hudLayout and jces_ui_fnc_hudUpdate.
class RscTitles {
    class jces_ui_hud {
        idd = -1;
        duration = 1e+011;
        fadeIn = 0;
        fadeOut = 0;
        movingEnable = 0;
        onLoad = "uiNamespace setVariable ['jces_ui_hud', _this select 0]";
        class controls {
            class Root: RscControlsGroupNoScrollbars {
                idc = 100;
                x = 0;
                y = 0;
                w = 0;
                h = 0;
                class controls {
                    class Background: RscPicture {
                        idc = 101;
                        text = "\CalebsShields\addons\ui\data\diamond_background_ca.paa";
                        colorText[] = {0.05, 0.04, 0.03, 0.7};
                        x = 0;
                        y = 0;
                        w = 0;
                        h = 0;
                    };
                    // Clips the fill diamond from the top to show the current fraction.
                    class FillGroup: RscControlsGroupNoScrollbars {
                        idc = 102;
                        x = 0;
                        y = 0;
                        w = 0;
                        h = 0;
                        class controls {
                            class Fill: RscPicture {
                                idc = 103;
                                text = "\CalebsShields\addons\ui\data\diamond_fill_ca.paa";
                                x = 0;
                                y = 0;
                                w = 0;
                                h = 0;
                            };
                        };
                    };
                    class Frame: RscPicture {
                        idc = 104;
                        text = "\CalebsShields\addons\ui\data\diamond_frame_ca.paa";
                        x = 0;
                        y = 0;
                        w = 0;
                        h = 0;
                    };
                    class Icon: RscPicture {
                        idc = 105;
                        text = "\CalebsShields\addons\ui\data\shield_icon_ca.paa";
                        x = 0;
                        y = 0;
                        w = 0;
                        h = 0;
                    };
                    class Label: RscText {
                        idc = 108;
                        font = "PuristaMedium";
                        shadow = 1;
                        x = 0;
                        y = 0;
                        w = 0;
                        h = 0;
                    };
                };
            };
        };
    };
};
