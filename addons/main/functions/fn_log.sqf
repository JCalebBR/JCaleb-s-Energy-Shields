/*
 * Author: JCaleb2014
 * Writes a debug line to the RPT when Debug Logging is on. Objects in the arguments are expanded to
 * name, class, netId and locality, so lines from different machines' RPTs can be matched up.
 *
 * Arguments:
 * 0: Source, usually the function name <STRING>
 * 1: Message, format string <STRING>
 * 2+: Format arguments <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["activate", "Raised shield on %1", player] call jces_main_fnc_log
 *
 * Public: Yes
 */
if !(missionNamespace getVariable ["jces_main_debug", false]) exitWith {};

params [["_source", "", [""]], ["_message", "", [""]]];

private _describe = {
    if (isNull _this) exitWith {"<null>"};
    private _name = [typeOf _this, name _this] select (_this isKindOf "CAManBase");
    format ["%1 (%2, %3, %4)", _name, typeOf _this, netId _this, ["remote", "local"] select (local _this)]
};

private _args = (_this select [2]) apply {
    switch (true) do {
        case (_x isEqualType objNull): {_x call _describe};
        case (_x isEqualType [] && {_x isNotEqualTo []} && {_x isEqualTypeAll objNull}): {_x apply {_x call _describe}};
        default {_x};
    };
};

private _machine = switch (true) do {
    case (isServer && {hasInterface}): {"host"};
    case isServer: {"server"};
    case hasInterface: {"client"};
    default {"hc"};
};

diag_log text format [
    "[JCES] %1 frame %2 %3 #%4 %5: %6",
    CBA_missionTime toFixed 2,
    diag_frameNo,
    _machine,
    clientOwner,
    _source,
    format ([_message] + _args)
];
