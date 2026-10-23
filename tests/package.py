"""Build and read back only the addon files, preserving existing music bytes."""
import hashlib
import json
from pathlib import Path
import re
import zipfile

root = Path(__file__).resolve().parents[1]
toc = (root / "500miles.toc").read_text()
version = re.search(r"^## Version: ([0-9]+\.[0-9]+\.[0-9]+)$", toc, re.M).group(1)
interfaces = set(map(int, re.search(r"^## Interface: (.+)$", toc, re.M).group(1).split(",")))
targets = json.loads((root / ".github/wow-targets.json").read_text())
assert interfaces == {target["interface"] for target in targets}, "TOC must cover every reviewed live client"
assert [line.strip() for line in toc.splitlines() if line.strip() and not line.startswith("#")] == ["500miles.lua"]
files = ["500miles.toc", "500miles.lua", "music1.mp3", "music2.mp3", "music3.mp3", "README.MD", "COMPATIBILITY.md"]
dist = root / "dist"
dist.mkdir(exist_ok=True)
archive = dist / f"500miles-{version}.zip"
with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as package:
    for name in files:
        data = (root / name).read_bytes()
        assert data, f"Empty distribution file: {name}"
        info = zipfile.ZipInfo("500miles/" + name, (2026, 1, 1, 0, 0, 0))
        info.compress_type = zipfile.ZIP_DEFLATED
        info.external_attr = 0o100644 << 16
        package.writestr(info, data)
with zipfile.ZipFile(archive) as package:
    assert package.testzip() is None
    assert package.namelist() == ["500miles/" + name for name in files]
    for name in files:
        assert package.read("500miles/" + name) == (root / name).read_bytes(), f"Changed bytes: {name}"
digest = hashlib.sha256(archive.read_bytes()).hexdigest()
(dist / (archive.name + ".sha256")).write_text(digest + "  " + archive.name + "\n")
print(f"PASS: {archive.name}, {len(files)} files, {archive.stat().st_size} bytes, SHA256 {digest}")
