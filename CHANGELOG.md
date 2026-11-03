# Changelog

## 2.0.0 (unreleased)

Full rewrite following the ACE3 coding guidelines without macros, unscheduled only, built with HEMTT.

### Added
- Scripted shield health per type and tier, drained by bullets (penetration-based kinetic damage) and explosions (with splash falloff).
- Optional per-tier time limit (default 15 s, 5-60).
- Cooldown scaled by what the shield had left when turned off early; full when broken or expired; minimum cooldown setting.
- Shield colour by health: blue, yellow, red.
- Personal tiers Plasteel, Ceramite, Auramite; Terminator shields (Bronze, Iron, Gold) with their own items.
- HUD in the style of Space Marine 2, with terminator and dreadnought icons.
- Hit effects: lightning sweep on the personal shield's Hit layer (UV animation), texture flash on the other shields.
- CBA settings for health, cooldown, time limit, damage multipliers, friendly fire, HUD, effects and sounds (custom sound file paths).
- Single Toggle Shield keybind (Ctrl+Shift+K).
- ZEN context menu: Energy Shields → Toggle / Add / Remove.
- Public API functions and CBA events (`jces_main_shieldActivated`, `jces_main_shieldDamaged`, `jces_main_shieldDeactivated`).
- `jces_shieldTier` / `jces_shieldType` config properties so other mods can add shield devices.
- AI raise their shields on their own when hit, when an enemy fires an explosive nearby or when suppressed, each with its own chance setting ("AI" settings category). Zeus and scripts are unaffected by the toggle.
- AI inside a raised shield ignore suppression, so they keep firing while the dome is being shot.
- Deleting a shielded unit also deletes its dome and crew.

### Changed
- Every tier uses the Gold models; shields no longer let rounds through, tiers differ by health.
- Shield crew joins the owner's side instead of separate OPFOR classes; AI treat the shield as a soft target (`type = 0`) instead of an aircraft.
- Shield vehicles are script-only (hidden from Eden/Zeus) with no name tag.
- Items are based on `CBA_MiscItem` (were ACE UAV batteries); ground items hold the right item.
- Sounds only play for the shield owner.
- Project converted to HEMTT (`addons/`, `$PBOPREFIX$`), mod.cpp at the root.

### Removed
- Duration based shields and the Eden/Zeus duration/cooldown module (replaced by CBA settings).
- `_OP` shield classes, separate activate/deactivate keybinds, debug system chat messages.
