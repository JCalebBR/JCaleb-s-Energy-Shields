#define _ARMA_
class CfgPatches {
    class JCalebs_Energy_Shields {
        name = "JCaleb's Energy Shields";
        author = "JCaleb2014";
        requiredVersion = 1.6;
        units[] = {"JCES_Shield_Oval_Bronze", "JCES_Shield_Oval_Iron", "JCES_Shield_Oval_Gold"};
        requiredAddons[] = {"ace_field_rations", "A3_Drones_F"};
    };
};

class CfgFactionClasses {
    class JCES_Faction_BLUFOR {
        displayName = "JCaleb's Energy Shields";
        priority = 1;
        side = 1;
    };
    class JCES_Faction_OPFOR {
        displayName = "JCaleb's Energy Shields";
        priority = 1;
        side = 0;
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
class UniformInfo;
class SlotsInfo;
class UniformSlotInfo;
class HitPoints;
class CfgVehicles {
    class B_Helipilot_F;
    class JCES_Shield_Crew : B_Helipilot_F {
        scope = 1;
        scopeCurator = 0;
        genericNames = "JCesNames";
        author = "JCaleb2014";
        displayName = "";
        simulation = "UAVPilot";
        model = "\A3\characters_F\Common\invisibleMan.p3d";
        weapons[] = {};
        magazines[] = {};
        identityTypes[] = {"jces_identity"};
    };

    class House;
    class UAV_01_base_F;
    class JCES_Shield_Oval_Base : UAV_01_base_F {
        scope = 0;
        armor = 3;
        cost = 110000;
        camouflage = 100;
        driveThroughEnabled = 1;
        displayName = "Shield Oval";
        faction = "BLU_F";
        vehicleClass = "Autonomous";
        editorCategory = "JCES_Props";
        editorSubcategory = "JCES_Shields";
        destrType = "DestructNone";
        audible = 60;
        canBeShot = true;
        irTarget = true;
        threat[] = {1, 1, 1};
        accuracy = 0.1;
        featureType = 1;
        crew = "JCES_Shield_Crew";
        isUav = 1;
        side = 1;
        typicalCargo[] = {""};
        class EventHandlers {
            // clang-format off
            killed = "_s = _this select 0;deleteVehicle _s;";
            init = "_s = _this select 0;createVehicleCrew _s;";
            handledamage = "";
            // clang-format on
            class CBA_Extended_EventHandlers : CBA_Extended_EventHandlers_base {};
        };
        class UserActions {};
        hitSound1[] = {"CalebsShields\jces_shields\Sounds\shield_hit0.ogg", 70, 20};
        hitSound2[] = {"CalebsShields\jces_shields\Sounds\shield_hit1.ogg", 70, 20};
        hitSound3[] = {"CalebsShields\jces_shields\Sounds\shield_hit2.ogg", 70, 20};
        hitSound4[] = {"CalebsShields\jces_shields\Sounds\shield_hit3.ogg", 70, 20};
        hitSound5[] = {"CalebsShields\jces_shields\Sounds\shield_hit4.ogg", 70, 20};
        hitSound6[] = {"CalebsShields\jces_shields\Sounds\shield_hit5.ogg", 70, 20};
        hitSounds[] = {"hitSound1", 0.05, "hitSound2", 0.05, "hitSound3", 0.05, "hitSound4", 0.05, "hitSound5", 0.05, "hitSound6", 0.05};
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
    class JCES_Shield_Oval_Bronze_OP : JCES_Shield_Oval_Bronze {
        faction = "OPF_F";
        side = 0;
    };
    class JCES_Shield_Oval_Iron_OP : JCES_Shield_Oval_Iron {
        faction = "OPF_F";
        side = 0;
    };
    class JCES_Shield_Oval_Gold_OP : JCES_Shield_Oval_Gold {
        faction = "OPF_F";
        side = 0;
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

class CfgWorlds {
    class GenericNames {
        class JCesNames {
            class FirstNames {
                None = "";
            };
            class LastNames {
                None = "";
            };
        };
    };
};

class CfgIdentities {
    class jces_identity {
        name = "";
        nameSound = "Ghost";
        face = "Default";
        pitch = 1.0;
        glasses = "None";
        speaker = "NoVoice";
    };
};

class CfgSFX {
    class jces_shield_sfx {
        sound0[] = {"CalebsShields\jces_shields\Sounds\shield_hit0.ogg", 1, 1.0, 50, 0.2, 0, 15, 30};
        sound1[] = {"CalebsShields\jces_shields\Sounds\shield_hit1.ogg", 1, 1.0, 50, 0.2, 0, 15, 30};
        sound2[] = {"CalebsShields\jces_shields\Sounds\shield_hit2.ogg", 1, 1.0, 50, 0.2, 0, 15, 30};
        sound3[] = {"CalebsShields\jces_shields\Sounds\shield_hit3.ogg", 1, 1.0, 50, 0.2, 0, 15, 30};
        sound4[] = {"CalebsShields\jces_shields\Sounds\shield_hit4.ogg", 1, 1.0, 50, 0.2, 0, 15, 30};
        sound5[] = {"CalebsShields\jces_shields\Sounds\shield_hit5.ogg", 1, 1.0, 50, 0.2, 0, 15, 30};
        sounds[] = {sound0, sound1, sound2, sound3, sound4, sound5};
        empty[] = {"", 0, 0, 0, 0, 0, 0, 0};
    };
};

class CfgSounds {
    sounds[] = {"jces_shield_sfx_on", "jces_shield_sfx_off", "jces_shield_sfx_hit_zero"};
    class jces_shield_sfx_on {
        name = "jces_shield_sfx_on";
        sound[] = {"CalebsShields\jces_shields\Sounds\shield_on.ogg", db-5, 1, 10};
        titles[] = {0,""};
    };
    class jces_shield_sfx_off {
        name = "jces_shield_sfx_off";
        sound[] = {"CalebsShields\jces_shields\Sounds\shield_off.ogg", db-5, 1, 10};
        titles[] = {0,""};
    };
    class jces_shield_sfx_hit_zero {
        name = "jces_shield_sfx_hit_zero";
        sound[] = {"CalebsShields\jces_shields\Sounds\shield_hit0.ogg", db-5, 1, 100};
        titles[] = {0,""};
    };
};