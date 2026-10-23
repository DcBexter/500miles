"""Detect live client patch drift; never claim compatibility by bumping TOCs alone."""
import json
from pathlib import Path
import urllib.request

root = Path(__file__).resolve().parents[1]
targets = json.loads((root / ".github/wow-targets.json").read_text())


def fetch(url):
    with urllib.request.urlopen(url, timeout=30) as response:
        return response.read().decode("utf-8")


for target in targets:
    rows = fetch(f"https://us.version.battle.net/{target['product']}/versions").splitlines()
    # Blizzard's pipe-separated manifest: Region, BuildConfig, CDNConfig,
    # KeyRing, BuildId, VersionsName, ProductConfig.
    live = {".".join(row.split("|")[5].split(".")[:3]) for row in rows if row and not row.startswith(("Region!", "##"))}
    assert live == {target["version"]}, f"Review {target['name']} before changing TOC: current patches {live}"
    base = f"https://raw.githubusercontent.com/Gethe/wow-ui-source/{target['uiRef']}/Interface/AddOns/"
    cv = fetch(base + "Blizzard_APIDocumentationGenerated/CVarDocumentation.lua")
    assert 'Namespace = "C_CVar"' in cv and 'Name = "GetCVar"' in cv and 'Name = "SetCVar"' in cv
    bindings = fetch(base + "Blizzard_FrameXML/" + target["bindings"])
    for api in ("ToggleAutoRun", "StartAutoRun", "StopAutoRun", "MoveForwardStart", "MoveBackwardStart", "MoveAndSteerStart", "CameraOrSelectOrMoveStart", "TurnOrActionStart"):
        assert api + "(" in bindings, f"Missing binding API {api}: {target['name']}"
    print(f"PASS: {target['name']} {target['version']} / {target['interface']}: live manifest and pinned Blizzard UI API source")
