# Client compatibility evidence

Reviewed 24 October 2026. Targets all currently live official client families listed below. This is source/API review plus Lua 5.1 mock testing, **not an in-game certification**. No usable local WoW installation was found at standard install locations or Blizzard registry keys. Actual playback, combat/taint behavior, mouse bindings and logout must still be checked in each game client.

| Client | Blizzard version endpoint | Live build reviewed | Interface |
| --- | --- | --- | --- |
| Retail / Midnight | [wow](https://us.version.battle.net/wow/versions) | 12.1.5.70575 | 120105 |
| Mists of Pandaria Classic | [wow_classic](https://us.version.battle.net/wow_classic/versions) | 5.5.4.70579 | 50504 |
| Classic Era / Hardcore / Season of Discovery | [wow_classic_era](https://us.version.battle.net/wow_classic_era/versions) | 1.15.9.70003 | 11509 |
| Burning Crusade Anniversary | [wow_anniversary](https://us.version.battle.net/wow_anniversary/versions) | 2.5.6.70006 | 20506 |
| Titan Reforged (China) | [wow_classic_titan](https://us.version.battle.net/wow_classic_titan/versions) | 3.80.2.70522 | 38002 |

Live builds come directly from Blizzard's version service, including all advertised regions. Interface IDs were cross-checked against actual client `GetBuildInfo()` dumps: [Retail](https://github.com/Ketho/BlizzardInterfaceResources/blob/f3b334b33bd19fa6a0250f7922ecfa83db7fe356/README.md), [Mists](https://github.com/Ketho/BlizzardInterfaceResources/blob/877c67e9e0a64b5daae348a7b72b7a64bfaab90f/README.md), [Era](https://github.com/Ketho/BlizzardInterfaceResources/blob/1f1dec331d23927fefe3d50c3d7f6e0915cda96f/README.md), [Anniversary](https://github.com/Ketho/BlizzardInterfaceResources/blob/d6d4a8f445f198c5c73ff5f8f5002ad8f04451e4/README.md). These community-maintained dumps have earlier build numbers within the same current patch. Titan's `38002` is corroborated by [Myslot's maintained Titan TOC](https://github.com/tg123/myslot/blob/3b6f5ef65821de808971f4c950f80e3db5d1b915/Myslot.toc), not a locally obtained client dump.

Blizzard's UI code is reviewed through [Gethe's source mirror](https://github.com/Gethe/wow-ui-source). Exact commit references and binding filenames for each target are pinned in `.github/wow-targets.json`. `tests/check-wow-targets.py` checks each target's actual `Bindings_*.xml` movement calls and generated `C_CVar.GetCVar`/`SetCVar` namespace. It also checks live Blizzard patch versions, failing on patch drift so a future interface bump requires review. Current PlaySoundFile/StopSound globals were checked in the client API dumps; Titan has source/API review but no separate sound-runtime dump or game run.

WoW: Forever is [announced for 4 November 2026](https://worldofwarcraft.blizzard.com/en-gb/news/24302093), so it is not claimed as a live supported client in this package. PTR, beta, closed historical clients and private-server binaries require separate evidence; a future release can add them after review.

## In-game verification checklist

For each installed target: enable the addon, set Ambience volume, start/stop autorun through toggle and explicit bindings, cancel with forward/backward/both mouse buttons, verify original game-music preference stays unchanged after stopping and logout, then repeat in combat with Lua errors enabled. Test with game music initially both enabled and disabled. Missing custom files must not mute game music or cause a nil-handle error.
