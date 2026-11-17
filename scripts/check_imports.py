"""Ensure every library source is reachable from the audited root module."""

from pathlib import Path
import re

root = Path(__file__).resolve().parent.parent
library = "NoncommutativeAMGM"
sources = {library: root / f"{library}.lean"}
sources.update(
    (".".join(p.relative_to(root).with_suffix("").parts), p)
    for p in (root / library).rglob("*.lean")
)
visited = set()
pending = [library]
while pending:
    module = pending.pop()
    if module in visited:
        continue
    visited.add(module)
    imports = re.findall(
        r"^(?:public\s+)?import\s+([\w.]+)", sources[module].read_text(), re.MULTILINE
    )
    pending.extend(name for name in imports if name in sources and name not in visited)
missing = sorted(sources.keys() - visited)
if missing:
    raise SystemExit("Library modules omitted from root imports: " + ", ".join(missing))
print(f"All {len(sources)} library modules are reachable from the audited root.")

audit_imports = set(re.findall(r"^import all ([\w.]+)",
                              (root / "scripts/Audit.lean").read_text(), re.MULTILINE))
missing_audits = sorted((set(sources) | {"Solution"}) - audit_imports)
if missing_audits:
    raise SystemExit("Missing private-declaration audit imports: " + ", ".join(missing_audits))
print("All library modules and Solution have full private-declaration audit imports.")
