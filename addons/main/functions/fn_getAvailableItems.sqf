/*
 * Author: JCaleb2014
 * Returns every shield item of a type in CfgWeapons (scope 2 with jces_shieldTier), lowest tier first.
 * Includes other mods' items. Cached per type.
 *
 * Arguments:
 * 0: Shield type ("Personal", "Dreadnought" or "Terminator") <STRING>
 *
 * Return Value:
 * [[Classname, Display name, Picture, Tier], ...] <ARRAY>
 *
 * Example:
 * ["Terminator"] call jces_main_fnc_getAvailableItems
 *
 * Public: Yes
 */
params [["_type", "Personal", [""]]];

jces_main_availableItemsCache getOrDefaultCall [_type, {
    private _items = ("getNumber (_x >> 'scope') == 2 && {getNumber (_x >> 'jces_shieldTier') > 0}" configClasses (configFile >> "CfgWeapons")) apply {
        private _device = [configName _x] call jces_main_fnc_getDeviceConfig;
        [_device select 0, _device select 1, configName _x, getText (_x >> "displayName"), getText (_x >> "picture")]
    } select {(_x select 1) == _type};
    _items sort true;
    _items apply {
        _x params ["_tier", "", "_class", "_name", "_picture"];
        [_class, _name, _picture, _tier]
    }
}, true]
