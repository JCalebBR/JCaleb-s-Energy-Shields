# In-game Testing Checklist

Build with `./deploy.sh` (or the Deploy task), launch with CBA, ACE and optionally ZEN, TIOW/TDA/WebKnight dreadnoughts.
If you tested earlier builds, press **Reset** on the mod's CBA settings first, CBA keeps old changed values.
Watch field for live state: `[player getVariable "jces_main_health", player getVariable "jces_main_maxHealth", player getVariable "jces_main_cooldownEnd", CBA_missionTime]`.

## Core

- [x] Personal shield item in inventory → ACE self action "Activate Shield" and Ctrl+Shift+K raise the dome, sound plays (only for you).
- [x] Highest tier wins with several items or a halo. Halo facewear alone works.
- [x] Enemy fire drains health (the HUD % drops), the colour goes blue → yellow (<60%) → red (<25%), it breaks at 0 with the depleted sound.
- [x] You can shoot out from inside, and your own shots don't drain it.
- [ ] Friendly fire doesn't drain it with Ignore Friendly Fire on, but does when it's off.
- [x] Explosions (grenade close and far, launcher) drain it, and less at distance.
- [ ] Rapid fire reduction: a full-auto burst or a minigun drains much less per round than single aimed shots spaced over 1 s apart; a single heavy round (tank, launcher) still takes its full chunk. With Rapid Fire Reduction off, the burst drains at full damage. Watch `jces_main_shieldDamaged` or the HUD %.
- [x] The time limit drops it after 15 s (full cooldown). With Time Limit off it stays up until broken.
- [x] Turning it off early: at ~50% left the cooldown is ~50% of 67 s. Right after raising it, it's 10 s. The ready sound plays when it recharges.
- [ ] Getting into a vehicle drops it. Dying drops it.
- [ ] Deleting a shielded unit (Zeus delete, `deleteVehicle`) also deletes its dome and crew: for a local AI, a server AI from a Zeus client, an AI owned by another player, and a dreadnought (dome on the hitbox).
- [x] No green "Shield Oval" name tag while looking out from inside.
- [x] AI enemies engage you or the dome (not ignoring you), friendly AI don't shoot the dome.

## AI shield use

`tools/debug_ai_shield_fire.sqf` (debug console, Eden preview) logs a shielded AI's shots and suppression per second while you shoot its dome.

- [x] An enemy AI with a shield item raises its shield when shot (most of the time), with and without ACE medical.
- [ ] Throwing a grenade or firing a launcher near shielded enemy AI often makes them raise it, firing bullets nearby doesn't (unless they're suppressed).
- [ ] Sustained fire past them (suppression) eventually makes them raise it, slower than hitting them.
- [ ] AI inside a raised shield keep shooting back, also while you shoot the dome (suppression is disabled while the shield is up). Afterwards they react to suppression normally again.
- [ ] With "AI Uses Shields" off, AI never raise it on their own, but Zeus Toggle Shield still works on them.
- [ ] Friendly fire and friendly grenades near them don't trigger it. Players never get an automatic shield, also not while Zeus remote controls an AI.
- [ ] Works for AI local to the server, a headless client and a player's group (AI local to that player).

## Types

- [x] Terminator unit (`TDA_Base_Man`) + Terminator item → big dome, terminator health (1200/1620/2186). **Check the dome position** (`fn_getAttachTarget`, offset `[0, 0, 1]`).
- [x] Dreadnought + Dreadnought item → dome on the hitbox, the dreadnought takes no scripted damage while it's up and does again after it drops.
- [x] Plasteel / Ceramite / Auramite items work (tiers 4-6).

## HUD

- [x] Gold diamond and READY when carrying a device, hidden without one.
- [x] Active: health fill in the shield colour, text `75%  8s`. Recharging: grey with seconds.
- [x] Terminator and dreadnought units show their own icon, space marines the standard one.
- [x] Position/scale/text settings apply live.

## Hit effects

- [x] Personal shield: a hit sweeps lightning across the dome (about 0.4 s), nothing is visible on the Hit layer at rest, no flicker between layers up close. **If the flash looks reversed**, flip `offset1[]` to `{-1, 0}`.
- [x] The overlay colour follows the health colour.
- [x] Dreadnought/terminator shields: texture flash in 3 steps, returning to the right colour. The Hit Effects setting turns it off.
- [ ] MP: other players see both effects.

## Sounds

- [x] Default sounds play for turning on, turning off, depleted and ready. An empty field gives silence, a custom `.ogg` path works.

## Zeus (ZEN)

- [x] Right-click a unit → Energy Shields → Toggle / Add / Remove.
- [x] Add lists only the fitting items (personal for space marines, terminator for terminators, dreadnought for dreadnoughts), and the item is added (or dropped at its feet if full).
- [x] With an item, only Remove shows, and it lowers the shield and removes the item. Without one, only Add shows.
- [ ] Works on remote players and server AI.
- [ ] With several units selected, Toggle / Add / Remove act on all of them (Add only on the ones without a shield, Remove only on the ones with one), and the message shows the unit count.
- [ ] Selecting space marines and terminators together, Add shows a Personal and a Terminator submenu, and each item only goes to the matching units.
- [x] Raised shields (dome and its crew) never show up in Zeus: no icon, no entry in the entity list, not selectable, also with ZEN's "Auto Add Objects" on and on AI raised by Zeus. The unit itself stays editable.

## Multiplayer

- [ ] Colour changes and the shield itself are visible to everyone, including JIP players.
- [ ] A player disconnecting with the shield up leaves no floating dome.
- [ ] With Debug Logging on, `[JCES]` lines show up in the RPT (the setting change itself logs one), and nothing is logged with it off. Raise, get hit and lower a shield and check the lines read sensibly, also on the server RPT for a remote unit.
