#include "script_component.hpp"

params["_player"];

if (diag_tickTime < (uiNamespace getVariable ['jces_shield_cooldown', -1])) exitWith {
	false;
};
true;