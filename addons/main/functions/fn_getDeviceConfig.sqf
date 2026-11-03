/*
 * Author: JCaleb2014
 * Reads the shield tier and type of an item or facewear class.
 * Uses jces_shieldTier and jces_shieldType from CfgWeapons or CfgGlasses, then jces_main_facewearTiers.
 *
 * Arguments:
 * 0: Classname <STRING>
 *
 * Return Value:
 * [Tier (0 if not a shield device), Type] <ARRAY>
 *
 * Example:
 * ["JCES_Personal_Shield_Iron"] call jces_main_fnc_getDeviceConfig
 *
 * Public: No
 */
params [["_class", "", [""]]];

private _config = configFile >> "CfgWeapons" >> _class;
if (!isClass _config) then {
    _config = configFile >> "CfgGlasses" >> _class;
};

private _tier = getNumber (_config >> "jces_shieldTier");
if (_tier == 0) then {
    _tier = jces_main_facewearTiers getOrDefault [toLowerANSI _class, 0];
};

private _type = getText (_config >> "jces_shieldType");
if !(_type in jces_main_typeTiers) then {
    _type = "Personal";
};

[0 max (floor _tier) min (count jces_main_tierNames), _type]
