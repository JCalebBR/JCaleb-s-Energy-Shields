/*
 * Author: JCaleb2014
 * Returns what kind of unit this is, used for the HUD icon (the shield type comes from the device). Terminators inherit from the space marine
 * base class, so they are checked before falling back to "Personal". Cached per class.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * "Dreadnought", "Terminator" or "Personal" <STRING>
 *
 * Example:
 * [player] call jces_main_fnc_getUnitType
 *
 * Public: Yes
 */
params [["_unit", objNull, [objNull]]];

jces_main_unitTypeCache getOrDefaultCall [typeOf _unit, {
    switch (true) do {
        case (_unit isKindOf "WBK_DT_Cont_1");
        case (_unit isKindOf "WBK_DT_1"): {"Dreadnought"};
        case (_unit isKindOf "TDA_Base_Man"): {"Terminator"};
        default {"Personal"};
    }
}, true]
