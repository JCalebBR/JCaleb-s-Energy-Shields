# Agent Instructions: JCaleb's Energy Shields

Arma 3 mod: Iron Halo style energy shields with scripted health, a time limit, cooldowns, a HUD and Zeus (ZEN) actions.
Read `HANDOFF.md` for the current state and design, `HUMAN_TESTING.md` for what still needs checking in game.

## Rules

- **Coding guidelines:** [ACE3 coding guidelines](https://ace3.acemod.org/wiki/development/coding-guidelines) and [BI Code Optimisation](https://community.bistudio.com/wiki/Code_Optimisation), but **no macros**: no `#define`, no `GVAR`/`QFUNC`/`PREP`, no `script_component.hpp`, no DIK code headers (write raw key codes with a comment, e.g. `37` for K). `#include` of plain config files is not used either.
- **Unscheduled only:** no `spawn`, `sleep`, `waitUntil`, `execVM`, `BIS_fnc_runLater` or `remoteExec "spawn"`. Use CBA: `CBA_fnc_addPerFrameHandler`, `CBA_fnc_waitAndExecute`, `CBA_fnc_execNextFrame`, CBA events.
- **Networking:** CBA events (`CBA_fnc_targetEvent`, `CBA_fnc_globalEvent`, `CBA_fnc_serverEvent`, `CBA_fnc_globalEventJIP`), never `remoteExec` with code. Inventory and unit-state changes run where the unit is local.
- **Style:** 4 spaces, `params` with types and defaults, `private` on declaration, lazy `&& {}` / `|| {}`, `isEqualTo`/`isNotEqualTo`, early `exitWith`, ACE function header block on every function (`Author: JCaleb2014`, Arguments, Return Value, Example, Public). Match surrounding comment density: short comments explaining *why*.
- **Naming:** functions `jces_<addon>_fnc_<name>` in `addons/<addon>/functions/fn_<name>.sqf`, registered in that addon's `CfgFunctions` (keep the list alphabetical). Globals, object variables, events and settings are prefixed `jces_main_` / `jces_ui_` / `jces_zen_`.
- **Assets:** textures are authored as PNGs under `addons/` (PNGs are git-ignored and excluded from PBOs) and converted with the user's converter (below). Never overwrite the user's hand-made PNGs (`addons/ui/data/*.png`, `halo_icon.xcf`) with generated ones.
- **`.p3d` files are git-ignored**, so they have no history. Back one up before any scripted edit. The user edits models in Blender (Arma Toolbox) or Object Builder.
- Don't commit unless asked. Attribution lines are added by the harness when a commit is requested.

## Build, check, deploy

| Task | Command |
| --- | --- |
| Lint configs and SQF | `hemtt check` |
| Dev build (`.hemttout/build`) | `hemtt build` |
| Release zip (`releases/CalebsShields-latest.zip`) | `hemtt release` |
| PNG → PAA (changed PNGs under `addons/`, cached in `png_to_paa_cache.json`) | `bash /home/jcaleb/scripts/convert_to_paa.sh "$PWD"` (ImageToPAA through Wine) |
| PAA → PNG | `bash /home/jcaleb/scripts/convert_to_png.sh "$PWD"` |
| Release and install into `/home/jcaleb/Mods/JCaleb's Energy Shields` | `./deploy.sh` |
| Regenerate hit flash textures (then convert) | `python3 -I tools/generate_hit_textures.py [seed]` |

The same tasks exist in `.vscode/tasks.json` (local only, `.vscode/` is ignored); Build, Release and Deploy run the PNG conversion first.

- `hemtt check` must stay clean. The only accepted warning is `INVALID-PBOPREFIX` for `shields`: its prefix stays `CalebsShields\jces_shields` because the `.p3d` models have that path baked in.
- HEMTT refuses to overwrite existing files in `hemtt utils paa convert`, delete the target first.
- Building is not runtime verification. Gameplay testing is the user's job, say so when reporting.

## Layout

```
addons/shields/  models, materials, sounds, textures, shield vehicles, items   prefix CalebsShields\jces_shields
addons/main/     logic, settings, keybind, ACE self-actions, events          prefix CalebsShields\addons\main
addons/ui/       HUD (RscTitles), icons                                       prefix CalebsShields\addons\ui
addons/zen/      Zeus Enhanced context menu (skipWhenMissingDependencies)     prefix CalebsShields\addons\zen
tools/           texture generator, debug console test scripts (excluded from PBOs)
mod.cpp          mod metadata, logos live in addons/main/data
```

## Useful local references

- Installed Arma: `/mnt/Games/SteamLibrary/steamapps/common/Arma 3` (vanilla configs can be read with `hemtt utils pbo unpack` + `hemtt utils config derapify`).
- Workshop: `/mnt/Games/SteamLibrary/steamapps/workshop/content/107410/` (CBA `450814997`, ZEN `1779063631`, TIOW `1160452826`).
- The user's other HEMTT projects for conventions: `/home/jcaleb/Code/TDA_Scripts`, `/home/jcaleb/Mods/CTR_Scripts`.
