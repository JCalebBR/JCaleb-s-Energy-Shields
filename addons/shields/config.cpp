class CfgPatches {
    // Class name kept from 1.x so missions that placed shields keep loading.
    class JCalebs_Energy_Shields {
        name = "JCaleb's Energy Shields - Shields";
        author = "JCaleb2014";
        requiredVersion = 2.18;
        requiredAddons[] = {"A3_Data_F_Decade_Loadorder", "cba_main"};
        units[] = {
            "JCES_Shield_Oval_Bronze",
            "JCES_Shield_Oval_Iron",
            "JCES_Shield_Oval_Gold",
            "JCES_Shield_Oval_Plasteel",
            "JCES_Shield_Oval_Ceramite",
            "JCES_Shield_Oval_Auramite",
            "JCES_Shield_Oval_Dreadnought_Bronze",
            "JCES_Shield_Oval_Dreadnought_Iron",
            "JCES_Shield_Oval_Dreadnought_Gold",
            "JCES_Shield_Oval_Terminator_Bronze",
            "JCES_Shield_Oval_Terminator_Iron",
            "JCES_Shield_Oval_Terminator_Gold",
            "JCES_Personal_Shield_Bronze_Item",
            "JCES_Personal_Shield_Iron_Item",
            "JCES_Personal_Shield_Gold_Item",
            "JCES_Personal_Shield_Plasteel_Item",
            "JCES_Personal_Shield_Ceramite_Item",
            "JCES_Personal_Shield_Auramite_Item",
            "JCES_Personal_Shield_Dreadnought_Bronze_Item",
            "JCES_Personal_Shield_Dreadnought_Iron_Item",
            "JCES_Personal_Shield_Dreadnought_Gold_Item",
            "JCES_Personal_Shield_Terminator_Bronze_Item",
            "JCES_Personal_Shield_Terminator_Iron_Item",
            "JCES_Personal_Shield_Terminator_Gold_Item"
        };
        weapons[] = {
            "JCES_Personal_Shield_Bronze",
            "JCES_Personal_Shield_Iron",
            "JCES_Personal_Shield_Gold",
            "JCES_Personal_Shield_Plasteel",
            "JCES_Personal_Shield_Ceramite",
            "JCES_Personal_Shield_Auramite",
            "JCES_Personal_Shield_Dreadnought_Bronze",
            "JCES_Personal_Shield_Dreadnought_Iron",
            "JCES_Personal_Shield_Dreadnought_Gold",
            "JCES_Personal_Shield_Terminator_Bronze",
            "JCES_Personal_Shield_Terminator_Iron",
            "JCES_Personal_Shield_Terminator_Gold"
        };
    };
};

class CBA_Extended_EventHandlers_base;

class CfgVehicles {
    class B_Helipilot_F;
    class JCES_Shield_Crew: B_Helipilot_F {
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

    // The shield is a crewed UAV so AI engage the dome instead of ignoring the unit inside it.
    // Health is scripted (see jces_main_fnc_handleHitPart), the engine damage is always discarded.
    class UAV_01_base_F;
    class JCES_Shield_Oval_Base: UAV_01_base_F {
        scope = 0;
        author = "JCaleb2014";
        // Air (inherited) is type 2, which AI infantry mostly won't engage. 0 is the same target type as Man.
        type = 0;
        nameSound = "veh_man";
        armor = 3;
        cost = 110000;
        camouflage = 100;
        driveThroughEnabled = 1;
        // Empty so the friendly name tag doesn't show while looking out from inside the shield.
        displayName = "";
        faction = "BLU_F";
        vehicleClass = "Autonomous";
        destrType = "DestructNone";
        audible = 60;
        canBeShot = 1;
        irTarget = 1;
        threat[] = {1, 1, 1};
        accuracy = 0.1;
        featureType = 1;
        crew = "JCES_Shield_Crew";
        isUav = 1;
        side = 1;
        typicalCargo[] = {""};
        hiddenSelections[] = {"Outside", "Inside"};
        // Healthy (blue) colour, matches jces_main_healthColors.
        hiddenSelectionsTextures[] = {
            "#(argb,8,8,3)color(0,0.55,0.68,0.15,ca)",
            "#(argb,8,8,3)color(0,0.55,0.68,0.1,ca)"
        };
        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
        };
        class UserActions {};
        hitSound1[] = {"CalebsShields\jces_shields\Sounds\shield_hit0.ogg", 70, 20};
        hitSound2[] = {"CalebsShields\jces_shields\Sounds\shield_hit1.ogg", 70, 20};
        hitSound3[] = {"CalebsShields\jces_shields\Sounds\shield_hit2.ogg", 70, 20};
        hitSound4[] = {"CalebsShields\jces_shields\Sounds\shield_hit3.ogg", 70, 20};
        hitSound5[] = {"CalebsShields\jces_shields\Sounds\shield_hit4.ogg", 70, 20};
        hitSound6[] = {"CalebsShields\jces_shields\Sounds\shield_hit5.ogg", 70, 20};
        hitSounds[] = {"hitSound1", 1, "hitSound2", 1, "hitSound3", 1, "hitSound4", 1, "hitSound5", 1, "hitSound6", 1};
    };

    // Every tier uses the Gold models (impenetrable fire geometry), tiers differ by health only.
    // Only spawned by jces_main_fnc_activate, a placed shield would have no health.
    class JCES_Shield_Oval_Bronze: JCES_Shield_Oval_Base {
        scope = 1;
        scopeCurator = 0;
        model = "\CalebsShields\jces_shields\Models\JCES_Shield_Oval_Gold.p3d";
        // The personal model has a Hit overlay layer, a hit slides its UVs so a lightning band sweeps across
        // (see jces_main_fnc_damageShield). Models without one fall back to texture swaps.
        jces_hitLayer = 1;
        hiddenSelections[] = {"Outside", "Inside", "Hit"};
        hiddenSelectionsTextures[] = {
            "#(argb,8,8,3)color(0,0.55,0.68,0.15,ca)",
            "#(argb,8,8,3)color(0,0.55,0.68,0.1,ca)",
            "\CalebsShields\jces_shields\Textures\Hit\jces_shield_hitlayer_0_ca.paa"
        };
        class AnimationSources {
            class jces_hit {
                source = "user";
                animPeriod = 0.6;
                initPhase = 0;
            };
        };
        class UVAnimations {
            class jces_hit {
                type = "translation";
                source = "jces_hit";
                section = "Hit";
                sourceAddress = "clamp";
                minValue = 0;
                maxValue = 1;
                offset0[] = {0, 0};
                offset1[] = {1, 0};
            };
        };
    };
    class JCES_Shield_Oval_Iron: JCES_Shield_Oval_Bronze {};
    class JCES_Shield_Oval_Gold: JCES_Shield_Oval_Bronze {};
    class JCES_Shield_Oval_Plasteel: JCES_Shield_Oval_Gold {};
    class JCES_Shield_Oval_Ceramite: JCES_Shield_Oval_Gold {};
    class JCES_Shield_Oval_Auramite: JCES_Shield_Oval_Gold {};
    class JCES_Shield_Oval_Dreadnought_Bronze: JCES_Shield_Oval_Base {
        scope = 1;
        scopeCurator = 0;
        model = "\CalebsShields\jces_shields\Models\JCES_Shield_Oval_Gold_Dreadnought.p3d";
    };
    class JCES_Shield_Oval_Dreadnought_Iron: JCES_Shield_Oval_Dreadnought_Bronze {};
    class JCES_Shield_Oval_Dreadnought_Gold: JCES_Shield_Oval_Dreadnought_Bronze {};
    // Terminators have no model of their own yet, they use the dreadnought one.
    class JCES_Shield_Oval_Terminator_Bronze: JCES_Shield_Oval_Dreadnought_Bronze {};
    class JCES_Shield_Oval_Terminator_Iron: JCES_Shield_Oval_Terminator_Bronze {};
    class JCES_Shield_Oval_Terminator_Gold: JCES_Shield_Oval_Terminator_Bronze {};

    // Ground item holders
    class Item_Base_F;
    class JCES_Personal_Shield_Base_Item: Item_Base_F {
        scope = 0;
        scopeCurator = 0;
        author = "JCaleb2014";
        displayName = "Personal Shield";
        vehicleClass = "Items";
        editorCategory = "EdCat_Equipment";
        editorSubcategory = "EdSubcat_InventoryItems";
        editorPreview = "";
    };
    class JCES_Personal_Shield_Bronze_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Personal Shield (Bronze)";
        class TransportItems {
            class JCES_Personal_Shield_Bronze {
                name = "JCES_Personal_Shield_Bronze";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Iron_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Personal Shield (Iron)";
        class TransportItems {
            class JCES_Personal_Shield_Iron {
                name = "JCES_Personal_Shield_Iron";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Gold_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Personal Shield (Gold)";
        class TransportItems {
            class JCES_Personal_Shield_Gold {
                name = "JCES_Personal_Shield_Gold";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Plasteel_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Personal Shield (Plasteel)";
        class TransportItems {
            class JCES_Personal_Shield_Plasteel {
                name = "JCES_Personal_Shield_Plasteel";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Ceramite_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Personal Shield (Ceramite)";
        class TransportItems {
            class JCES_Personal_Shield_Ceramite {
                name = "JCES_Personal_Shield_Ceramite";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Auramite_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Personal Shield (Auramite)";
        class TransportItems {
            class JCES_Personal_Shield_Auramite {
                name = "JCES_Personal_Shield_Auramite";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Dreadnought_Bronze_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Dreadnought Personal Shield (Bronze)";
        class TransportItems {
            class JCES_Personal_Shield_Dreadnought_Bronze {
                name = "JCES_Personal_Shield_Dreadnought_Bronze";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Dreadnought_Iron_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Dreadnought Personal Shield (Iron)";
        class TransportItems {
            class JCES_Personal_Shield_Dreadnought_Iron {
                name = "JCES_Personal_Shield_Dreadnought_Iron";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Dreadnought_Gold_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Dreadnought Personal Shield (Gold)";
        class TransportItems {
            class JCES_Personal_Shield_Dreadnought_Gold {
                name = "JCES_Personal_Shield_Dreadnought_Gold";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Terminator_Bronze_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Terminator Personal Shield (Bronze)";
        class TransportItems {
            class JCES_Personal_Shield_Terminator_Bronze {
                name = "JCES_Personal_Shield_Terminator_Bronze";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Terminator_Iron_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Terminator Personal Shield (Iron)";
        class TransportItems {
            class JCES_Personal_Shield_Terminator_Iron {
                name = "JCES_Personal_Shield_Terminator_Iron";
                count = 1;
            };
        };
    };
    class JCES_Personal_Shield_Terminator_Gold_Item: JCES_Personal_Shield_Base_Item {
        scope = 2;
        scopeCurator = 2;
        displayName = "Terminator Personal Shield (Gold)";
        class TransportItems {
            class JCES_Personal_Shield_Terminator_Gold {
                name = "JCES_Personal_Shield_Terminator_Gold";
                count = 1;
            };
        };
    };
};

// Shield emitters. jces_shieldTier (1 Bronze, 2 Iron, 3 Gold, 4 Plasteel, 5 Ceramite, 6 Auramite)
// and jces_shieldType ("Personal", "Dreadnought" or "Terminator", the latter two only have tiers 1-3).
// are read by jces_main_fnc_getDeviceConfig, other mods can add them to their own CfgWeapons or CfgGlasses classes.
class CfgWeapons {
    class CBA_MiscItem;
    class CBA_MiscItem_ItemInfo;
    class JCES_Personal_Shield_Base: CBA_MiscItem {
        scope = 0;
        author = "JCaleb2014";
        displayName = "Personal Shield";
        descriptionShort = "Personal Shield";
        picture = "\CalebsShields\addons\main\data\logosmall.paa";
        jces_shieldTier = 0;
        jces_shieldType = "Personal";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };
    class JCES_Personal_Shield_Bronze: JCES_Personal_Shield_Base {
        scope = 2;
        scopeArsenal = 2;
        scopeCurator = 2;
        displayName = "Personal Shield (Bronze)";
        descriptionShort = "Personal Shield (Bronze)";
        jces_shieldTier = 1;
    };
    class JCES_Personal_Shield_Iron: JCES_Personal_Shield_Bronze {
        displayName = "Personal Shield (Iron)";
        descriptionShort = "Personal Shield (Iron)";
        jces_shieldTier = 2;
    };
    class JCES_Personal_Shield_Gold: JCES_Personal_Shield_Bronze {
        displayName = "Personal Shield (Gold)";
        descriptionShort = "Personal Shield (Gold)";
        jces_shieldTier = 3;
    };
    class JCES_Personal_Shield_Plasteel: JCES_Personal_Shield_Bronze {
        displayName = "Personal Shield (Plasteel)";
        descriptionShort = "Personal Shield (Plasteel)";
        jces_shieldTier = 4;
    };
    class JCES_Personal_Shield_Ceramite: JCES_Personal_Shield_Bronze {
        displayName = "Personal Shield (Ceramite)";
        descriptionShort = "Personal Shield (Ceramite)";
        jces_shieldTier = 5;
    };
    class JCES_Personal_Shield_Auramite: JCES_Personal_Shield_Bronze {
        displayName = "Personal Shield (Auramite)";
        descriptionShort = "Personal Shield (Auramite)";
        jces_shieldTier = 6;
    };
    class JCES_Personal_Shield_Dreadnought_Bronze: JCES_Personal_Shield_Bronze {
        displayName = "Dreadnought Personal Shield (Bronze)";
        descriptionShort = "Dreadnought Personal Shield (Bronze)";
        jces_shieldType = "Dreadnought";
    };
    class JCES_Personal_Shield_Dreadnought_Iron: JCES_Personal_Shield_Dreadnought_Bronze {
        displayName = "Dreadnought Personal Shield (Iron)";
        descriptionShort = "Dreadnought Personal Shield (Iron)";
        jces_shieldTier = 2;
    };
    class JCES_Personal_Shield_Dreadnought_Gold: JCES_Personal_Shield_Dreadnought_Bronze {
        displayName = "Dreadnought Personal Shield (Gold)";
        descriptionShort = "Dreadnought Personal Shield (Gold)";
        jces_shieldTier = 3;
    };
    class JCES_Personal_Shield_Terminator_Bronze: JCES_Personal_Shield_Bronze {
        displayName = "Terminator Personal Shield (Bronze)";
        descriptionShort = "Terminator Personal Shield (Bronze)";
        jces_shieldType = "Terminator";
    };
    class JCES_Personal_Shield_Terminator_Iron: JCES_Personal_Shield_Terminator_Bronze {
        displayName = "Terminator Personal Shield (Iron)";
        descriptionShort = "Terminator Personal Shield (Iron)";
        jces_shieldTier = 2;
    };
    class JCES_Personal_Shield_Terminator_Gold: JCES_Personal_Shield_Terminator_Bronze {
        displayName = "Terminator Personal Shield (Gold)";
        descriptionShort = "Terminator Personal Shield (Gold)";
        jces_shieldTier = 3;
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
