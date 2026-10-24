500miles
------------------
### A music player that plays a song randomly from a selected set of music files, when you start auto running.
Easy to customize it to play your own music. Simply replace the 3 included Files or add your own!
Source code and instructions on [GitHub](https://github.com/DcBexter/500miles "https://github.com/DcBexter/500miles")
## Install
- Go to your WoW Installation folder and navigate to ./Interface/addons/
- Extract the files so that you have a folder in ./addons/ called 500miles which contains the .toc, .lua and .mp3 files.
`Example: E:\World of Warcraft\_classic_\Interface\AddOns\500miles\500miles.lua`
- It plays music on the "Ambience" channel, so turn that up if you have turned it down.
## Customize
- Replace the included files with your files or put your own music in the folder and edit the musicList array in the `musicList` declaration in 500miles.lua
`Example: local musicList = {"myFavouriteSong1.mp3", "myCatSnoring.mp3"}`
## Recommended Songs:
- The Proclaimers - I'm Gonna Be
- Nancy Sinatra - These Boots Are Made for Walkin'
- Katrina &amp; The Waves - Walking On Sunshine
- Israel Kamakawiwo'ole - Somewhere Over the Rainbow
## Credits
All music included is made by friends and me in our Band called Widrir

Example Music:
- Widrir - Symphonie des Todes
- Widrir - Das Gelage
- Widrir - Die Letzten Heiden

&copy; Widrir - All Rights Reserved
## Current client targets (1.2.0)

Retail 12.1.5, Mists of Pandaria Classic 5.5.4, Classic Era/Hardcore/Season of Discovery 1.15.9, Burning Crusade Anniversary 2.5.6, and Titan Reforged (China) 3.80.2. One folder/package includes the reviewed interface IDs for every current live family. Install into each client's `Interface/AddOns/500miles` directory. See [compatibility evidence and limitations](COMPATIBILITY.md).

This update uses the current `C_CVar` API, handles explicit Start/Stop Auto Run and Move And Steer bindings, keeps helper functions local, and only stops its own valid sound handle. Failed playback leaves game music untouched. If the addon temporarily disabled game music, it restores the original setting on stop/logout; music that you had already disabled stays disabled. Existing Widrir recordings are unchanged.

Lua behavior and package contents are checked automatically. In-game testing is still required; this package does not claim verified playback in each game client. Future/PTR/beta and historical private-server clients are outside the current live-target list.

## Development and maintenance

With Lua 5.1 and Python 3 installed:

```sh
luac5.1 -p 500miles.lua tests/test.lua
lua5.1 tests/test.lua
python3 tests/check-wow-targets.py
python3 tests/package.py
```

The last command builds `dist/500miles-1.2.0.zip`, reads every member back, checks TOC targets, preserves exact music bytes, and writes SHA256. ZIP contains a single `500miles` directory ready for `Interface/AddOns`, including README and compatibility notes.

GitHub Actions runs on PRs, master pushes and weekly. It checks current Blizzard client patches/API references, Lua behavior and installable ZIP. A new WoW patch fails compatibility check until reviewed; CI never publishes a new compatibility claim or release automatically. Renovate updates actual pinned GitHub Actions dependencies: all dependency updates including major/minor/patch, pins/digests, submodules and security updates can merge only after branch-required checks. A metadata-only workflow queues Dependabot automatic merges; product PRs are excluded. Lua is supplied by Ubuntu's maintained package repository for 5.1 syntax testing. No runtime libraries are bundled with this addon.

GitHub vulnerability alerts/security fixes, secret scanning/push protection and private reporting are repository settings. CodeQL scans Python maintenance tools and GitHub Actions workflows. Lua itself is unsupported by CodeQL; no supported application package manifest exists for dependency submission. Dependency review covers supported manifests such as Actions. Music rights remain **Copyright Widrir, all rights reserved**. Packaging changes do not grant additional music permissions.
