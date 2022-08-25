#define _ARMA_
class CfgPatches {
    class JCalebs_Energy_Shields {
        name = "JCaleb's 40K Energy Shields";
        author = "JCaleb2014";
        requiredVersion = 1.6;
        units[] = {"JCES_Shield_Oval_Bronze", "JCES_Shield_Oval_Iron", "JCES_Shield_Oval_Gold"};
        requiredAddons[] = {"ace_field_rations"};
    };
};

class CfgEditorCategories {
    class JCES_Props {
        displayName = "JCaleb's Energy Shields";
        priority = 1;
        side = 1;
    };
};

class CfgEditorSubcategories {
    class JCES_Shields {
        displayName = "Shields";
    };
};

class CBA_Extended_EventHandlers_base;
class CfgVehicles {
    class House;
    class JCES_Shield_Oval_Base : House {
        scope = 0;
        armor = 10000;
        cost = 1;
        camouflage = 100;
        driveThroughEnabled = 1;
        displayName = "Shield Oval";
        faction = "Empty";
        vehicleClass = "Objects";
        editorCategory = "JCES_Props";
        editorSubcategory = "JCES_Shields";
        destrType = "DestructNone";
        simulation = "house";
        accuracy = 0.1;
        audible = 6;

        class EventHandlers {
            killed = "_s = _this select 0;deleteVehicle _s;";
            class CBA_Extended_EventHandlers : CBA_Extended_EventHandlers_base {};
        };
    };
    class JCES_Shield_Oval_Bronze : JCES_Shield_Oval_Base {
        scope = 2;
        scopeCurator = 2;
        scopeArsenal = 2;
        displayName = "Shield Oval (Bronze)";
        model = "\CalebsShields\jces_shields\Models\JCES_Shield_Oval_Bronze.p3d";
        hiddenSelections[] = {"Outside", "Inside"};
        hiddenSelectionsTextures[] = {"\CalebsShields\jces_shields\Textures\JCES_Shield_Bronze_Outside_CA.paa", "\CalebsShields\jces_shields\Textures\JCES_Shield_Bronze_Inside_CA.paa"};
    };
    class JCES_Shield_Oval_Iron : JCES_Shield_Oval_Bronze {
        displayName = "Shield Oval (Iron)";
        hiddenSelections[] = {"Outside", "Inside"};
        model = "\CalebsShields\jces_shields\Models\JCES_Shield_Oval_Iron.p3d";
        hiddenSelectionsTextures[] = {"\CalebsShields\jces_shields\Textures\JCES_Shield_Iron_Outside_CA.paa", "\CalebsShields\jces_shields\Textures\JCES_Shield_Iron_Inside_CA.paa"};
    };
    class JCES_Shield_Oval_Gold : JCES_Shield_Oval_Bronze {
        displayName = "Shield Oval (Gold)";
        hiddenSelections[] = {"Outside", "Inside"};
        model = "\CalebsShields\jces_shields\Models\JCES_Shield_Oval_Gold.p3d";
        hiddenSelectionsTextures[] = {"\CalebsShields\jces_shields\Textures\JCES_Shield_Gold_Outside_CA.paa", "\CalebsShields\jces_shields\Textures\JCES_Shield_Gold_Inside_CA.paa"};
    };

    // Items
    class ACE_Sunflower_Seeds_Item;
    class JCES_Personal_Shield_Base_Item : ACE_Sunflower_Seeds_Item {
        scope = 0;
        author = "JCaleb2014";
        displayName = "Personal Shield";
        faction = "Empty";
        vehicleClass = "Items";
        picture = "\CalebsShields\jces_meta\logosmall.paa";
    };
    class JCES_Personal_Shield_Bronze_Item : JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeArsenal = 2;
        scopeCurator = 2;
        displayName = "Personal Shield (Bronze)";
    };
    class JCES_Personal_Shield_Iron_Item : JCES_Personal_Shield_Bronze_Item {
        displayName = "Personal Shield (Iron)";
    };
    class JCES_Personal_Shield_Gold_Item : JCES_Personal_Shield_Iron_Item {
        displayName = "Personal Shield (Gold)";
    };
};

class CfgWeapons {
    class ACE_UAVBattery;
    class JCES_Personal_Shield_Base : ACE_UAVBattery {
        scope = 0;
        author = "JCaleb2014";
        displayName = "Personal Shield";
        weight = 0;
        mass = 1;
        picture = "\CalebsShields\jces_meta\logosmall.paa";
    };
    class JCES_Personal_Shield_Bronze : JCES_Personal_Shield_Base {
        scope = 2;
        scopeArsenal = 2;
        scopeCurator = 2;
        displayName = "Personal Shield (Bronze)";
        descriptionShort = "Personal Shield (Bronze) - Overrides the facewear selected";
    };
    class JCES_Personal_Shield_Iron : JCES_Personal_Shield_Bronze {
        displayName = "Personal Shield (Iron)";
        descriptionShort = "Personal Shield (Iron) - Overrides the facewear selected";
    };
    class JCES_Personal_Shield_Gold : JCES_Personal_Shield_Iron {
        displayName = "Personal Shield (Gold)";
        descriptionShort = "Personal Shield (Gold) - Overrides the facewear selected";
    };
};