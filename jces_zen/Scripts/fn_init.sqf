if (!isClass (configFile >> "CfgPatches" >> "zen_main")) exitWith {
	systemChat "ZEN Addon is not present";
};

[] call jces_zen_fnc_initModule;