// Runs on every machine, the settings are per client.

jces_ui_colorReady = [1, 0.76, 0.2, 1];
jces_ui_colorActiveFrame = [0.75, 0.6, 0.3, 1];
jces_ui_colorRecharging = [0.6, 0.6, 0.6, 1];

// Icon by jces_main_fnc_getUnitType.
jces_ui_icons = createHashMapFromArray [
    ["Personal", "\CalebsShields\addons\ui\data\shield_icon_ca.paa"],
    ["Terminator", "\CalebsShields\addons\ui\data\shield_icon_terminator_ca.paa"],
    ["Dreadnought", "\CalebsShields\addons\ui\data\shield_icon_dreadnought_ca.paa"]
];

private _category = ["JCaleb's Energy Shields - Core", "HUD"];

[
    "jces_ui_enabled",
    "CHECKBOX",
    ["Show Shield HUD", "Shows the shield's state, health and recharge progress while carrying a shield device."],
    _category,
    true,
    0
] call CBA_fnc_addSetting;

[
    "jces_ui_showLabel",
    "CHECKBOX",
    ["Show Health / Time Text", "Shows the remaining health percentage, time left or recharge seconds next to the icon."],
    _category,
    true,
    0
] call CBA_fnc_addSetting;

[
    "jces_ui_positionX",
    "SLIDER",
    ["Horizontal Position", "Centre of the shield icon, 0 is the left edge of the screen, 1 the right."],
    _category,
    [0, 1, 0.05, 2],
    0,
    {call jces_ui_fnc_hudLayout}
] call CBA_fnc_addSetting;

[
    "jces_ui_positionY",
    "SLIDER",
    ["Vertical Position", "Centre of the shield icon, 0 is the top of the screen, 1 the bottom."],
    _category,
    [0, 1, 0.85, 2],
    0,
    {call jces_ui_fnc_hudLayout}
] call CBA_fnc_addSetting;

[
    "jces_ui_scale",
    "SLIDER",
    ["Scale", "Size of the shield HUD."],
    _category,
    [0.5, 2, 1, 2],
    0,
    {call jces_ui_fnc_hudLayout}
] call CBA_fnc_addSetting;
