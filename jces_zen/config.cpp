#define _ARMA_

class CfgPatches {
    class JCalebs_Energy_Shields_ZEN {
        name = "JCaleb's 40K Energy Shields (ZEN)";
        author = "JCaleb2014";
        requiredVersion = 1.6;
        units[] = {"jces_zen_settings"};
        requiredAddons[] = {"A3_Modules_F", "zen_main", "JCalebs_Energy_Shields_Scripts"};
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jces_zen_modules : NO_CATEGORY {
        displayName = "JCaleb's Modules";
        author = "JCaleb2014";
    };
};

class CfgFunctions {
    class jces_zen {
        class jces_zen_scripts {
            file = "\CalebsShields\jces_zen\Scripts";
            class init {
                postInit = 1;
            };
            class initModule {};
            class moduleSettings {};
        };
    };
};

class CfgVehicles {
    class Logic;
    class Module_F : Logic {
        class AttributesBase {
            class Default;
            class Edit;
            class Combo;
            class Checkbox;
            class CheckboxNumber;
            class ModuleDescription;
            class Units;
        };
        class ModuleDescription;
    };
    class jces_zen_module : Module_F {
        scope = 0;
        scopeCurator = 0;
        is3DEN = 0;
        isDisposable = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        functionPriority = 1;
        author = "JCaleb2014";
        displayName = "JC.E.S Module";
        vehicleClass = "Modules";
        category = "jces_zen_modules";
        icon = "\CalebsShields\jces_meta\logo.paa";
        picture = "\CalebsShields\jces_meta\logo.paa";
        portrait = "\CalebsShields\jces_meta\logo.paa";
    };
    class jces_zen_settings : jces_zen_module {
        scope = 2;
        scopeCurator = 2;
        displayName = "Cooldown Settings";
        function = "jces_zen_fnc_moduleSettings";
        class Attributes : AttributesBase {
            class ShieldDurationBronze : Edit {
                property = "jces_zen_settings_shieldDurationBronze";
                displayName = "Bronze Shield - Duration";
                tooltip = "The duration (active) of the bronze tier shield in seconds.";
                typeName = "NUMBER";
                defaultValue = "30";
            };
            class ShieldCooldownBronze : Edit {
                property = "jces_zen_settings_shieldCooldownBronze";
                displayName = "Bronze Shield - Cooldown";
                tooltip = "The cooldown (to activate) of the bronze tier shield in seconds.";
                typeName = "NUMBER";
                defaultValue = "120";
            };
            class ShieldDurationIron : Edit {
                property = "jces_zen_settings_shieldDurationIron";
                displayName = "Iron Shield - Duration";
                tooltip = "The duration (active) of the iron tier shield in seconds.";
                typeName = "NUMBER";
                defaultValue = "45";
            };
            class ShieldCooldownIron : Edit {
                property = "jces_zen_settings_shieldCooldownIron";
                displayName = "Iron Shield - Cooldown";
                tooltip = "The cooldown (to activate) of the iron tier shield in seconds.";
                typeName = "NUMBER";
                defaultValue = "150";
            };
            class ShieldDurationGold : Edit {
                property = "jces_zen_settings_shieldDurationGold";
                displayName = "Gold Shield - Duration";
                tooltip = "The duration (active) of the gold tier shield in seconds.";
                typeName = "NUMBER";
                defaultValue = "60";
            };
            class ShieldCooldownGold : Edit {
                property = "jces_zen_settings_shieldCooldownGold";
                displayName = "Gold Shield - Cooldown";
                tooltip = "The cooldown (to activate) of the gold tier shield in seconds.";
                typeName = "NUMBER";
                defaultValue = "180";
            };
            class ModuleDescription : ModuleDescription {};
        };
        class ModuleDescription : ModuleDescription {
            description = "This module allows you to set the cooldowns and durations of the energy shields.";
        };
    };
};