/*
 * Author: JCaleb2014
 * Returns the colour (index into jces_main_healthColors) for a health fraction.
 *
 * Arguments:
 * 0: Health fraction, 0 to 1 <NUMBER>
 *
 * Return Value:
 * Colour index <NUMBER>
 *
 * Example:
 * [0.5] call jces_main_fnc_getHealthColorIndex
 *
 * Public: Yes
 */
params [["_fraction", 1, [0]]];

private _index = jces_main_healthThresholds findIf {_fraction >= _x};
[_index, count jces_main_healthThresholds] select (_index == -1)
