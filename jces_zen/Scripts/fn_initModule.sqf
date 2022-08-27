["JCaleb's Modules", "Cooldown Settings", {
	params [["_position", [0, 0, 0], [[]], 3], ["_attachedObject", objNull, [objNull]]];

	private _shieldDurationBronze = missionNamespace getVariable "jces_zen_shieldDurationBronze";
	private _shieldCooldownBronze = missionNamespace getVariable "jces_zen_shieldCooldownBronze";
	private _shieldDurationIron = missionNamespace getVariable "jces_zen_shieldDurationIron";
	private _shieldCooldownIron = missionNamespace getVariable "jces_zen_shieldCooldownIron";
	private _shieldDurationGold = missionNamespace getVariable "jces_zen_shieldDurationGold";
	private _shieldCooldownGold = missionNamespace getVariable "jces_zen_shieldCooldownGold";

	if (isNil "_shieldDurationBronze") then {
		jces_zen_shieldDurationBronze = 30;
	};
	if (isNil "_shieldCooldownBronze") then {
		jces_zen_shieldCooldownBronze = 120;
	};
	if (isNil "_shieldDurationIron") then {
		jces_zen_shieldDurationIron = 40;
	};
	if (isNil "_shieldCooldownIron") then {
		jces_zen_shieldCooldownIron = 150;
	};
	if (isNil "_shieldDurationGold") then {
		jces_zen_shieldDurationGold = 60;
	};
	if (isNil "_shieldCooldownGold") then {
		jces_zen_shieldCooldownGold = 180;
	};

	[
		"Configure Shield Settings", // title
		[ // array of controls for dialog
			["EDIT",
				["Bronze Shield - Duration", "The duration (active) of the Bronze tier shield in seconds."],
				[ // control args
					jces_zen_shieldDurationBronze, // default text
					{}, // sanitise function
					1 // edit box height (only for multi line)
				],
				true // force default
			],
			["EDIT",
				["Bronze Shield - Cooldown", "The cooldown (to activate) of the Bronze tier shield in seconds."],
				[
					jces_zen_shieldCooldownBronze,
					{},
					1
				], true
			],
			["EDIT",
				["Iron Shield - Duration", "The duration (active) of the Iron tier shield in seconds."],
				[ // control args
					jces_zen_shieldDurationIron, // default text
					{}, // sanitise function
					1 // edit box height (only for multi line)
				],
				true // force default
			],
			["EDIT",
				["Iron Shield - Cooldown", "The cooldown (to activate) of the Iron tier shield in seconds."],
				[
					jces_zen_shieldCooldownIron,
					{},
					1
				], true
			],
			["EDIT",
				["Gold Shield - Duration", "The duration (active) of the Gold tier shield in seconds."],
				[ // control args
					jces_zen_shieldDurationGold, // default text
					{}, // sanitise function
					1 // edit box height (only for multi line)
				],
				false // force default
			],
			["EDIT",
				["Gold Shield - Cooldown", "The cooldown (to activate) of the Gold tier shield in seconds."],
				[
					jces_zen_shieldCooldownGold,
					{},
					1
				],
				false
			]
		],
		{
			// code run on dialog closed (only run if OK is clicked)
			params ["_dialogResult", "_args"];

			jces_zen_shieldDurationBronze = parseNumber (_dialogResult#0);
			jces_zen_shieldCooldownBronze = parseNumber (_dialogResult#1);
			jces_zen_shieldDurationIron = parseNumber (_dialogResult#2);
			jces_zen_shieldCooldownIron = parseNumber (_dialogResult#3);
			jces_zen_shieldDurationGold = parseNumber (_dialogResult#4);
			jces_zen_shieldCooldownGold = parseNumber (_dialogResult#5);

			{
				publicVariable _x;
				} forEach [
				"jces_zen_shieldDurationBronze", "jces_zen_shieldCooldownBronze", "jces_zen_shieldDurationIron", "jces_zen_shieldCooldownIron", "jces_zen_shieldDurationGold", "jces_zen_shieldCooldownGold" ];
			}, {}, []
		] call zen_dialog_fnc_create;
	}, "CalebsShields\jces_meta\logo.paa"] call zen_custom_modules_fnc_register;