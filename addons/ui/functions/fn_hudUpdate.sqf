/*
 * Author: JCaleb2014
 * Per frame handler (10 Hz) that draws the player's shield state:
 * ready (gold, full), active (fill shows health in the shield's colour, the text the time left if the
 * shield has a time limit) or recharging (grey, fill shows progress, the text the seconds left).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [jces_ui_fnc_hudUpdate, 0.1] call CBA_fnc_addPerFrameHandler
 *
 * Public: No
 */
private _unit = ace_player;
private _display = uiNamespace getVariable ["jces_ui_hud", displayNull];
private _active = [_unit] call jces_main_fnc_isActive;

private _show = jces_ui_enabled
    && {alive _unit}
    && {!visibleMap}
    && {isNull curatorCamera}
    && {_active || {([_unit] call jces_main_fnc_getShieldDevice) isNotEqualTo []}};

if (!_show) exitWith {
    if (!isNull _display) then {
        (_display displayCtrl 100) ctrlShow false;
    };
};

if (isNull _display) then {
    ("jces_ui_hud" call BIS_fnc_rscLayer) cutRsc ["jces_ui_hud", "PLAIN", -1, false];
    _display = uiNamespace getVariable ["jces_ui_hud", displayNull];
    call jces_ui_fnc_hudLayout;
};
(_display displayCtrl 100) ctrlShow true;

private _fraction = 1;
private _fillColor = +jces_ui_colorReady;
private _frameColor = jces_ui_colorReady;
private _iconColor = jces_ui_colorReady;
private _label = "READY";

if (_active) then {
    _fraction = (_unit getVariable ["jces_main_health", 0]) / ((_unit getVariable ["jces_main_maxHealth", 1]) max 1);
    _fillColor = +(jces_main_healthColors select ([_fraction] call jces_main_fnc_getHealthColorIndex));
    _fillColor pushBack 1;
    _frameColor = jces_ui_colorActiveFrame;
    _label = format ["%1%2", round (_fraction * 100), "%"];
    if ((_unit getVariable ["jces_main_shieldDuration", -1]) > 0) then {
        private _timeLeft = 0 max ((_unit getVariable ["jces_main_shieldEnd", 0]) - CBA_missionTime);
        _label = format ["%1  %2s", _label, ceil _timeLeft];
    };
} else {
    private _remaining = (_unit getVariable ["jces_main_cooldownEnd", 0]) - CBA_missionTime;
    if (_remaining > 0) then {
        _fraction = 1 - _remaining / ((_unit getVariable ["jces_main_cooldownDuration", 1]) max 0.1);
        _fillColor = +jces_ui_colorRecharging;
        _frameColor = jces_ui_colorRecharging;
        _iconColor = jces_ui_colorRecharging;
        _label = format ["%1s", ceil _remaining];
    };
};
_fraction = 0 max _fraction min 1;

(uiNamespace getVariable ["jces_ui_hudRect", [0, 0, 0, 0]]) params ["_left", "_top", "_width", "_height"];

// Grow the clipping group up from the bottom, shifting the fill so it stays in place.
private _hidden = _height * (1 - _fraction);
private _fillGroup = _display displayCtrl 102;
_fillGroup ctrlSetPosition [_left, _top + _hidden, _width, _height - _hidden];
_fillGroup ctrlCommit 0;
private _fill = _display displayCtrl 103;
_fill ctrlSetPosition [0, -_hidden, _width, _height];
_fill ctrlCommit 0;

// The diamond fill is translucent so the icon stays readable on top of it.
_fillColor set [3, 0.45];
_fill ctrlSetTextColor _fillColor;
(_display displayCtrl 104) ctrlSetTextColor _frameColor;
private _icon = _display displayCtrl 105;
private _iconPath = jces_ui_icons get ([_unit] call jces_main_fnc_getUnitType);
if (ctrlText _icon != _iconPath) then {
    _icon ctrlSetText _iconPath;
};
_icon ctrlSetTextColor _iconColor;

private _labelControl = _display displayCtrl 108;
_labelControl ctrlShow jces_ui_showLabel;
_labelControl ctrlSetText _label;
_labelControl ctrlSetTextColor _frameColor;
