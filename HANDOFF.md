# Hand-off: JCaleb's Energy Shields 2.0

Status as of 2026-10-29. Version 2.0.0 is a full rewrite of the 1.x mod (last 1.x commit `0ed4340`).
**Nothing of 2.0 is committed yet**: the whole rewrite is in the working tree (renames are staged, new files untracked).
`hemtt check` is clean and `hemtt build` produces 4 PBOs. Several parts have only been verified to build, see "Open items" and `HUMAN_TESTING.md`.

**Latest session (2026-10-29):** added automatic AI shield use (`fn_aiTrigger`, `fn_isExplosiveAmmo`, "AI" settings category), fixed shielded AI not firing back (suppression is disabled while an AI's shield is up), and fixed a deleted unit leaving its dome behind (unit `Deleted` class handler). The firing problem was diagnosed in game with debug console scripts, the final one is kept as `tools/debug_ai_shield_fire.sqf`. Neither fix has been re-tested in game yet (open items 11-13).

## What the mod does

- A unit carrying a **shield device** (an inventory item, or a supported Iron Halo facewear) can raise a dome shield with ACE self-interaction or the **Toggle Shield** keybind (Ctrl+Shift+K).
- The shield blocks incoming fire (the unit inside can shoot out) and has **health** drained by hits. It also has an optional **time limit**. It changes colour **blue → yellow (<60%) → red (<25%)** and breaks at 0.
- After it goes down there is a **cooldown**: full when broken or expired, shortened by what was left when turned off early, never below the minimum cooldown. Shields always come back at full health.
- A **HUD** diamond shows ready / active (health fill, health % and seconds left) / recharging (progress, seconds left), with a different icon for terminators and dreadnoughts.
- **Zeus (ZEN)** context menu: Energy Shields → Toggle / Add / Remove.

## Shield types and tiers

| Type | Tiers | Items | Model | Attached to |
| --- | --- | --- | --- | --- |
| Personal | Bronze, Iron, Gold, Plasteel, Ceramite, Auramite (1-6) | `JCES_Personal_Shield_<Tier>` + Iron Halo facewear (1-3) | `JCES_Shield_Oval_Gold.p3d` (all tiers) | unit, `spine3`, offset `[0, 0.2, -0.4]` |
| Dreadnought | Bronze, Iron, Gold (1-3) | `JCES_Personal_Shield_Dreadnought_<Tier>` | `JCES_Shield_Oval_Gold_Dreadnought.p3d` | dreadnought hitbox (attached object with `HitBox_Param_Parent`, else the first attached object), offset `[0, 0, -1]` |
| Terminator | Bronze, Iron, Gold (1-3) | `JCES_Personal_Shield_Terminator_<Tier>` | dreadnought model (placeholder) | unit, no bone, offset `[0, 0, 1]` (a guess, tune in game) |

- **The shield type comes from the item.** The unit's class only picks the HUD icon and the Zeus "Add Shield" list (`jces_main_fnc_getUnitType`: `WBK_DT_Cont_1`/`WBK_DT_1` → Dreadnought, `TDA_Base_Man` → Terminator, checked before the space marine base `TIOW_SpaceMarine_Base`, everything else → Personal).
- **Highest tier wins** across everything carried. The tier is capped at what the item's type has (`jces_main_typeTiers`).
- **Third-party devices:** other mods can add `jces_shieldTier` (1-6) and `jces_shieldType` ("Personal", "Dreadnought", "Terminator") to `CfgWeapons` or `CfgGlasses` classes. Halos without config are mapped in `jces_main_facewearTiers` (XEH_preInit).
- **Shield vehicle classes** are `JCES_Shield_Oval_<Tier>`, `JCES_Shield_Oval_Dreadnought_<Tier>` and `JCES_Shield_Oval_Terminator_<Tier>`. They are `scope = 1` (only spawned by script) with an empty `displayName`, which stops the friendly name tag showing from inside.

## Defaults (CBA settings)

Personal health grows ~35% per tier, dreadnought is 4x personal, terminator is 2x personal. Every tier of every type defaults to a 67 s cooldown, Time Limit on and a 15 s Maximum Duration (5-60).

| Tier | Personal | Dreadnought | Terminator |
| --- | --- | --- | --- |
| Bronze | 600 | 2400 | 1200 |
| Iron | 810 | 3240 | 1620 |
| Gold | 1093 | 4372 | 2186 |
| Plasteel | 1475 | - | - |
| Ceramite | 1992 | - | - |
| Auramite | 2690 | - | - |

Categories (CBA sorts them alphabetically, so tier subcategories are named "Tier N: Name"):
- **JCaleb's Energy Shields - Core**
  - **Damage** (server, global): minimum cooldown 10 s; kinetic and explosive damage multipliers 1 (0-20); ignore friendly fire on; rapid fire reduction on, window 1 s (0.1-5), factor 1 (0.05-3).
  - **Effects** (client): Hit Effects on.
  - **HUD** (client): enabled, show text, X 0.05, Y 0.85, scale 1.
  - **Debug** (client, per machine): Debug Logging (`jces_main_debug`) off. A dedicated server or headless client turns it on in its own `cba_settings.sqf`.
- **JCaleb's Energy Shields - Personal / Dreadnought / Terminator** (global): per tier `jces_main_health<Type><Tier>`, `jces_main_cooldown<Type><Tier>`, `jces_main_timeLimit<Type><Tier>`, `jces_main_maxDuration<Type><Tier>`.
- **JCaleb's Energy Shields - Sounds** (client, only the owner hears them): `jces_main_soundsEnabled`, plus `jces_main_sound<Activate|Deactivate|Depleted|Ready>`, each an EDITBOX holding a `.wss`/`.ogg`/`.wav` path (empty = none). The defaults are the mod's own `\CalebsShields\jces_shields\Sounds\*.ogg` files, played with `playSoundUI`.

## Architecture

All logic is unscheduled and CBA based. Per-unit shield state lives in **local** object variables on the machine where the unit is local, and every public entry point forwards itself there with a CBA target event.

### Lifecycle

1. **Activate**: `fn_activate` (from ACE action, keybind, `fn_toggle` or Zeus).
   1. Checks `fn_canActivate`: alive, on foot, has a device, no shield up, cooldown over.
   2. Creates the shield vehicle and attaches it (`fn_getAttachTarget`).
   3. Runs `createVehicleCrew`, moves the crew to a group on the unit's side and disables their AI.
   4. Adds `HandleDamage {0}` and `Killed`/`Deleted` handlers.
   5. Sets the unit variables.
   6. Arms the time limit with `CBA_fnc_waitAndExecute`.
   7. Plays the activate sound and removes the shield and its crew from every Zeus curator (server event, plus a second pass after 1 s to undo auto add scripts such as ZEN's "Auto Add Objects").
   8. For dreadnoughts, patches the hitbox HitPart handler (global JIP event).
2. **Hit**:
   1. **`fn_handleHitPart`** (XEH class handler on every shield, on every machine) runs on the **shooter's** machine. It computes damage (`fn_getAmmoDamage`) and sends `jces_main_shieldHit` to the shield owner.
   2. **`fn_damageShield`** runs on the **owner**. It skips self hits, plays the hit effect, skips friendly fire (if set), applies the rapid fire reduction, subtracts health, recolours on threshold change (`setObjectTextureGlobal` + public `jces_main_colorIndex` on the shield) and, at 0, breaks the shield next frame.
3. **Deactivate**: `fn_deactivate` (toggle, timer, broken, unit killed, entering a vehicle, Zeus remove).
   1. Computes the cooldown.
   2. Clears `jces_main_shieldObject` *before* deleting, so the `Deleted` handler knows the deletion was intended. A deletion by anything else (e.g. Zeus) counts as broken.
   3. Deletes the crew and the shield.
   4. Plays the deactivate or depleted sound and schedules the ready sound.
4. **Server cleanup**: on `HandleDisconnect`, `fn_removeAttachedShields` deletes orphaned shields.
5. **Unit deleted**: a `CAManBase` `Deleted` class handler deactivates where the unit is local, then runs `fn_removeAttachedShields` on whichever machine the event fired on (it may not be the owner). Attached objects outlive their parent, so without this a deleted unit left its dome behind.

### Damage model (`fn_getAmmoDamage`, cached per ammo class)

- **Direct:** `penetration * kineticMultiplier + explosive * hit * explosiveMultiplier`, where `penetration = typicalSpeed * (typicalSpeed / 1000) * caliber * 15 / 1000 * (1 - explosive)` (mm RHA, the user's formula; ~11 for 5.56, ~16 for 7.62, ~30 for .50).
- **Splash:** `explosive * indirectHit * falloff * explosiveMultiplier`, with falloff 1 inside `indirectHitRange` and `(range / distance)^2` outside. Distance is measured from the exploding projectile to the hit position (HitPart data).
- **Rapid fire reduction** (on the owner, in `fn_damageShield`): each hit is divided by `1 + repeats * factor`, where repeats is how many hits of the same ammo class landed on that shield within the window (`jces_main_recentHits` on the shield, ammo class → hit times). Sustained fire at N rounds per window settles at 1/N per round with factor 1, while one heavy hit keeps full damage. It counts per ammo class, not per shooter, so a squad firing the same rounds shares the reduction, and shotgun pellets count as repeats of each other.
- **Why HitPart:** in testing, `HandleDamage` never fired on the shield vehicle. `HitPart` does fire, but only on the shooter's machine, hence the shooter → owner event.

### Hit effects

- **Personal (all tiers):** the model has a `Hit` overlay layer (duplicated outside faces, pushed out, UVs squeezed into a thin strip at u ≈ 0.798-0.814 in every visual LOD; the top and bottom pole faces stay at u 0.53-0.6). The config has a `jces_hit` user source (0.6 s) and a `UVAnimations` translation of `{1, 0}` on section `Hit`, the TIOW Warhound void shield technique. On a hit the owner calls `animateSource ["jces_hit", 0, true]` then `animateSource ["jces_hit", 1]`, and a running sweep is not restarted. The texture `jces_shield_hitlayer_<colour>_ca.paa` (2048×512) encodes the flash over time along u: clear at the strip, peak just past it, faded out by 70% of the slide. Gated by `jces_hitLayer = 1` in the shield config.
- **Dreadnought and terminator (no Hit layer):** the owner broadcasts `jces_main_shieldHitEffect` (throttled to 0.15 s per shield). Every client (`fn_playHitEffect`) swaps local textures to `jces_shield_hit_<colour>_<step>_ca.paa` in 3 fade steps over about 0.3 s, then restores the colour from the shield's public `jces_main_colorIndex`. Only this path obeys the Hit Effects setting.
- **Textures** come from `tools/generate_hit_textures.py` (constants at the top: strip position, vein frequencies, envelope).

### AI behaviour

- The shield is a crewed UAV so AI engage it. It uses `type = 0` (the Man target type), because the inherited Air `type = 2` made infantry AI ignore it, plus `nameSound = "veh_man"`, high camouflage/audible and high cost/threat.
- The crew joins the owner's side so allies ignore it.
- The models' view geometry is a 1 cm box with `canOcclude = 0`, so AI can see the unit inside.

### AI shield use

- `XEH_postInit` adds `Hit`, `FiredNear` and `Suppressed` handlers to every `CAManBase` on every machine (CBA class `init`, retroactive), plus a handler for ACE's `ace_medical_woundReceived` because ACE medical returns 0 from `HandleDamage` and the vanilla `Hit` may not fire.
- `FiredNear` only counts enemy explosives (`fn_isExplosiveAmmo`: `explosive > 0` and `indirectHitRange >= 2`, cached). `FiredNear` and `Suppressed` ignore friendly shooters (`getFriend >= 0.6`).
- `fn_aiTrigger` (local units, not players, not Zeus remote controlled, not opted out with `jces_main_aiEnabled` false on the unit) rolls `jces_main_aiChance<Hit|Explosion|Suppressed>`. Each trigger has its own re-roll timer (`jces_main_aiNextRoll<Trigger>` on the unit, `jces_main_aiRollInterval`), so a failed Suppressed roll doesn't block a Hit roll. The chance is per roll, so under sustained fire the odds stack up over time.
- AI never lower shields themselves, the time limit or breaking does it.
- **Suppression is off while an AI's shield is up** (`fn_activate` disables `"SUPPRESSION"` if it was on and sets `jces_main_suppressionDisabled`, `fn_deactivate` turns it back on). Hits on the dome land ~1 m from the unit and count as near misses: in testing an AI shielded and shot at reached suppression 0.99 and stopped firing completely, while with suppression disabled first it kept firing. Disabling it only after the AI was already pinned did not seem to bring it back, so it's done at activation. This applies to any AI shield, also ones raised by Zeus.

### Dreadnought compatibility

The WebKnight dreadnought keeps scripted health (`DT_Health`) in a HitPart handler on its hitbox. `jces_main_patchDreadnoughtHitbox` (run once per hitbox on every machine, JIP, removed when the hitbox is deleted) swaps handler index 0 for `fn_dreadnoughtHitPart`. That replacement keeps the same rules (ignore hit < 100, -8 below 500, -25 at 500 or more) but ignores hits while a shield is attached. It's ported from 1.x and is fragile by design: it assumes their handler is index 0.

### State variables

- **On the unit (local to its owner):**
  - `jces_main_shieldObject`, `jces_main_shieldInfo` `[tier, type]`, `jces_main_health`, `jces_main_maxHealth`, `jces_main_colorIndex`
  - `jces_main_shieldEnd`, `jces_main_shieldDuration` (-1 when there's no time limit)
  - `jces_main_cooldownEnd`, `jces_main_cooldownDuration` (all times are `CBA_missionTime`)
- **On the shield:**
  - `jces_main_owner`, `jces_main_broken`, `jces_main_nextHitEffect`, `jces_main_recentHits` (local to the owner)
  - `jces_main_colorIndex` (public)
  - `jces_main_effectToken` (per client)

### Events

| Event | Where | Purpose |
| --- | --- | --- |
| `jces_main_activate`, `jces_main_deactivate`, `jces_main_toggle` | target (unit owner) | forwarding from remote callers |
| `jces_main_shieldHit` | target (shield owner) | `[shield, damage, instigator, ammoClass]` from the shooter |
| `jces_main_shieldHitEffect` | global | texture flash for shields without a Hit layer |
| `jces_main_addShieldItem`, `jces_main_removeShieldItems` | target (unit owner) | Zeus Add/Remove (inventory commands need locality) |
| `jces_main_removeFromCurators` | server | `removeCuratorEditableObjects` on the shield and crew, now and after 1 s |
| `jces_main_patchDreadnoughtHitbox` | global JIP | dreadnought compatibility |
| `jces_main_shieldActivated` / `jces_main_shieldDamaged` / `jces_main_shieldDeactivated` | local (API for missions) | `[unit, shield]` / `[unit, shield, damage, healthLeft]` / `[unit, broken, cooldown]` |

### Public functions (`Public: Yes`)

`activate`, `deactivate`, `toggle`, `canActivate`, `isActive`, `getShieldDevice`, `getShieldItems`, `getAvailableItems`, `getUnitType`, `getAmmoDamage`, `getHealthColorIndex`, `log` (all `jces_main_fnc_*`).

### Debug logging (`fn_log`)

- **Usage:** `["<source>", "<format string>", args...] call jces_main_fnc_log`. Does nothing unless `jces_main_debug` is on for that machine, then writes `[JCES] <mission time> frame <n> <host|server|client|hc> #<clientOwner> <source>: <message>` to the RPT.
- **Objects** in the arguments (also arrays of objects) are expanded to `name (class, netId, local|remote)`, so the same unit or shield can be followed across the RPTs of several machines by its `netId`.
- **What's logged:** activation (success, refusal with the reasons, forwarding to the owner), deactivation (cause, health, cooldown), time limit, cooldown over, every hit on the shooter's machine (`handleHitPart`) and on the owner's (`damageShield`: damage before/after rapid fire, ignored hits, colour changes, breaking), AI rolls, dreadnought hitbox hits and patching, curator removal, cleanup of left-behind shields, killed/vehicle/deleted/disconnect with the shield up, sounds, HUD creation and the Zeus actions. The per-frame HUD update and the hit flash animation are not logged.

### HUD (`addons/ui`)

- **Structure:** `RscTitles` `jces_ui_hud` on its own layer. It's (re)created by `fn_hudUpdate` (a 10 Hz PFH on `ace_player`) and positioned by `fn_hudLayout` (from settings, squares sized with `pixelGrid`/`pixelW`/`pixelH`).
- **Controls:** background, a fill diamond clipped from the bottom by a controls group, the frame, the icon (Personal/Terminator/Dreadnought), and a label. The progress bar was removed on request.
- **When it's hidden:** with no device, while dead, with the map open or in the Zeus camera.

### Zeus (`addons/zen`)

- **The menu:** `zen_context_menu_actions >> jces_zen_energyShields` with children Toggle (`fn_toggleShields`), Add (`insertChildren` → `fn_getAddActions`, items from `jces_main_fnc_getAvailableItems` for the units' types) and Remove (`fn_removeShields`; lowers the shield and removes **all** shield items in the inventory). All three act on `_objects`, which ZEN fills with the selection plus the unit under the cursor.
- **Visibility:** Add acts on the units without a shield item, Remove on the units with one, based on `jces_main_fnc_getShieldItems` (inventory only, halos excluded). For a single unit they're mutually exclusive; a mixed selection shows both.
- **Mixed unit types:** if the units for Add have more than one type, the item list is split into one submenu per type (Personal / Terminator / Dreadnought), and each item only goes to the units of its type.

## Decisions worth knowing

- **Gold model for every tier, no pass-through:** health and time replace the old per-tier penetration materials. The Bronze and Iron `.p3d` files are unused but still packed.
- **Expiring costs the full cooldown;** otherwise an undamaged shield would expire and be back in 10 s.
- **Removed from 1.x:**
  - the duration/cooldown Eden/Zeus module (old `jces_zen`); missions with it placed will report a missing addon
  - the `_OP` side variants (crew side is set by script)
  - the hard-coded per-shield-class arrays
  - `ACE_UAVBattery` as the item base (items are `CBA_MiscItem` now)
- The ground item holders used to spawn sunflower seeds; they now hold the right item.
- **CfgPatches `JCalebs_Energy_Shields`** keeps its 1.x name for mission compatibility.

## Open items

1. **Not tested in game since the change** (all build clean):
   - Terminator shields and their attach offset
   - terminator/dreadnought icons
   - the ZEN Add/Remove menu
   - sound path settings
   - the hit effects (both paths)
   - the strip-based Hit layer texture
   - the HUD without the progress bar
   - the AI `type = 0` change
2. **Hit layer sweep direction is assumed.** If the flash plays backwards (slow build-up, sudden cut), flip `offset1[] = {1, 0}` to `{-1, 0}` in the personal `UVAnimations`.
3. **Hit layer only on the personal Gold model.** The Gold Dreadnought model (used by dreadnoughts and terminators) needs the same `Hit` layer (strip at the same u, or update `HIT_STRIP_START` and give it its own texture), plus `jces_hitLayer` / `UVAnimations` / `hiddenSelections` on the dreadnought base class and `"Hit"` in its `model.cfg` section list.
4. **Terminators have no model of their own** (they use the dreadnought dome).
5. **Res 5 of the personal Gold model was removed** by the user (5 visual LODs now). The ViewPilot LOD has no `Hit` faces, which doesn't matter since it's only used by the crew.
6. **Dreadnought hitbox patch** relies on the other mod's handler being index 0.
7. **Zeus remote control edge case:** state lives where the unit is local, so a Zeus-remote-controlled AI's shield state isn't visible to the Zeus client's HUD.
8. **CBA keeps changed settings in profiles:** testers who changed values earlier must press Reset to see the new defaults (multipliers, cooldowns, sounds, which changed from LIST to EDITBOX).
9. **Unused 1.x assets in `addons/shields/Textures`** (tier and OP textures, `_OP` rvmat) and the old Bronze/Iron models are still packed and could be removed. `addons/shields/Models/JCES_Shield_Oval_Gold.p3d.bak` is an untracked user backup.
10. **`README.steamworkshop` is still 1.x text.**
11. **AI suppression fix not re-tested in the real flow.** The debug test disabled suppression *before* raising the shield and the AI kept firing. With the automatic trigger, the shield usually goes up *because* the AI is already being shot at, so it may already be pinned; one earlier run where suppression was disabled late showed 0 shots (inconclusive, the AI may have been reloading or unconscious, lifeState wasn't logged). If AI still go quiet: disable suppression for shield carriers permanently, or require a few suppression events before the trigger fires.
12. **Unit `Deleted` cleanup not tested in game**, especially the multiplayer cases (Zeus deleting a unit owned by another machine) where it relies on `fn_removeAttachedShields` running wherever the event fires.
13. **AI auto trigger not balanced in game:** defaults (Hit 75%, explosive 50%, suppressed 25%, 3 s re-roll) are first guesses. `FiredNear` reacts to the enemy firing an explosive within ~70 m, not to where it lands.

## Files

- `README.md`: user-facing documentation (kept up to date with every change).
- `AGENTS.md` / `CLAUDE.md`: working rules for agents.
- `HUMAN_TESTING.md`: in-game checklist.
- `CHANGELOG.md`: 2.0.0 changes.
- `deploy.sh`: added by the user, releases and installs locally.
- `tools/debug_ai_shield_fire.sqf`: debug console test for shielded AI firing back (instructions in its header).
