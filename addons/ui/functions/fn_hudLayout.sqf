/*
 * Author: JCaleb2014
 * Positions the shield HUD controls from the HUD settings. The diamond is square in pixels.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call jces_ui_fnc_hudLayout
 *
 * Public: No
 */
private _display = uiNamespace getVariable ["jces_ui_hud", displayNull];
if (isNull _display) exitWith {};

private _size = 18 * pixelGrid * jces_ui_scale;
private _width = _size * pixelW;
private _height = _size * pixelH;
// Relative to the root group, which covers the safe zone.
private _left = safeZoneW * jces_ui_positionX - _width / 2;
private _top = safeZoneH * jces_ui_positionY - _height / 2;

private _labelHeight = _height * 0.3;

{
    _x params ["_idc", "_position"];
    private _control = _display displayCtrl _idc;
    _control ctrlSetPosition _position;
    _control ctrlCommit 0;
} forEach [
    [100, [safeZoneX, safeZoneY, safeZoneW, safeZoneH]],
    [101, [_left, _top, _width, _height]],
    [104, [_left, _top, _width, _height]],
    [105, [_left + _width * 0.17, _top + _height * 0.17, _width * 0.66, _height * 0.66]],
    [108, [_left + _width + 4 * pixelW, _top + (_height - _labelHeight) / 2, _width * 2.5, _labelHeight]]
];
(_display displayCtrl 108) ctrlSetFontHeight (_height * 0.22);

// Read by jces_ui_fnc_hudUpdate to size the fill diamond.
uiNamespace setVariable ["jces_ui_hudRect", [_left, _top, _width, _height]];
