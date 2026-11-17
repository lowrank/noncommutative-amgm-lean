"""Check this repository's Palomar source, configuration and metadata contract."""

from pathlib import Path
import json
import re
import subprocess
from urllib.request import urlopen

import jsonschema
import yaml

ROOT = Path(__file__).resolve().parent.parent
AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
SCHEMA_URL = (
    "https://raw.githubusercontent.com/mathlib-initiative/formalization.yaml/"
    "99c678e569c7c4c0772db297c5ddd5e4c9b6322e/schema/v0.4.schema.json"
)


def require(condition, message):
    if not condition:
        raise SystemExit(message)


class UniqueLoader(yaml.SafeLoader):
    """Reject duplicate YAML keys and merge keys before constructing mappings."""


def unique_mapping(loader, node):
    result = {}
    for key_node, value_node in node.value:
        require(key_node.value != "<<", "YAML merge keys are not allowed")
        key = loader.construct_object(key_node)
        require(key not in result, f"Duplicate YAML key: {key}")
        result[key] = loader.construct_object(value_node)
    return result


UniqueLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, unique_mapping)
metadata = yaml.load((ROOT / "formalization.yaml").read_text(), Loader=UniqueLoader)
with urlopen(SCHEMA_URL, timeout=30) as response:
    schema = json.load(response)
jsonschema.Draft7Validator(schema).validate(metadata)

project = metadata["project"]
require(project.get("responsible_maintainers"), "A responsible maintainer is required")
require(project.get("description", "").strip(), "A factual project description is required")
classification = metadata.get("classification", {})
require(1 <= len(classification.get("arxiv", [])) <= 2, "Use 1-2 arXiv subject codes")
require(1 <= len(classification.get("msc2020", [])) <= 8, "Use 1-8 MSC 2020 subject codes")
require(
    all(re.fullmatch(r"[0-9]{2}[A-Z][0-9]{2}", c) for c in classification["msc2020"]),
    "MSC codes must have five characters",
)
require(metadata["status"]["sorry_count"] == 0, "The proof development must have no placeholders")
require(set(metadata["status"]["axioms"]) <= AXIOMS, "Nonstandard solution axioms")

licenses = [
    p for p in ROOT.iterdir()
    if re.fullmatch(r"(?:license|licence|copying|unlicense|ofl)(?:\.(?:md|markdown|txt))?",
                    p.name, flags=re.IGNORECASE)
]
require(len(licenses) == 1, "Palomar requires exactly one repository-root licence file")
license_file = licenses[0]
require(not license_file.is_symlink(), "The licence must be a regular file")
license_text = license_file.read_text()
license_id = project["license"]
if license_id == "Apache-2.0":
    require("Apache License" in license_text and "Version 2.0" in license_text,
            "LICENSE does not contain the Apache 2.0 text")
elif license_id == "MIT":
    require("Permission is hereby granted, free of charge" in license_text,
            "LICENSE does not contain the MIT text")
else:
    raise SystemExit(f"Add an explicit licence check for {license_id}")

config = json.loads((ROOT / "comparator.json").read_text())
required = {"challenge_module", "solution_module", "theorem_names", "permitted_axioms"}
require(required <= config.keys(), "Comparator is missing required fields")
require(config.keys() <= required | {"definition_names", "enable_nanoda"},
        "Comparator contains a field not accepted by Palomar")
require(config["challenge_module"] == "Challenge" and config["solution_module"] == "Solution",
        "This package expects distinct root Challenge and Solution modules")
require(config["theorem_names"] and not config.get("definition_names"),
        "Select proved theorems and keep all definition bodies concrete")
require(set(config["permitted_axioms"]) == AXIOMS, "Unexpected Comparator axiom allowlist")
require(config.get("enable_nanoda") is True, "Enable the independent NanoDa checker")
require(
    {r["declaration"] for r in metadata["status"]["main_results"]} == set(config["theorem_names"]),
    "Metadata and Comparator must advertise exactly the same declarations",
)

files = subprocess.check_output(
    ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"], cwd=ROOT
).decode().split("\0")
files = sorted(set(f for f in files if f))
source_count = 0
size = 0
for name in files:
    path = ROOT / name
    require(not path.is_symlink(), f"Submitted symlink: {name}")
    require(path.is_file(), f"Missing submitted file: {name}")
    size += path.stat().st_size
    require(path.suffix not in {".olean", ".ilean", ".a", ".bc", ".dll", ".dylib",
                                ".o", ".obj", ".so", ".trace"},
            f"Generated artifact outside .lake: {name}")
    if path.suffix != ".lean":
        continue
    source_count += 1
    text = path.read_text()
    require(text.startswith("module\n"), f"Missing Lean module header: {name}")
    require(len(text.splitlines()) <= 10000, f"Lean source exceeds 10000 lines: {name}")
    require(not re.search(r"\b(?:sorry|admit)\b", text), f"Proof placeholder in {name}")
    if name != "Challenge.lean":
        require(not re.search(r"^\s*(?:(?:private|public|protected)\s+)?axiom\s", text, flags=re.MULTILINE),
                f"Custom proof axiom in {name}")
require(size <= 500 * 1024 * 1024, "Submitted source exceeds 500 MiB")
challenge = (ROOT / "Challenge.lean").read_text()
solution = (ROOT / "Solution.lean").read_text()
require(len(challenge.splitlines()) <= 1000 and len(challenge.encode()) <= 100 * 1024,
        "Challenge exceeds its source limit")
imports = re.findall(r"^(?:public\s+)?import\s+([\w.]+)", challenge, re.MULTILINE)
require(imports and all(i == "Mathlib" or i.startswith("Mathlib.") for i in imports),
        "Challenge must import only Mathlib, with no project dependencies")
require(not re.search(r"^(?:public\s+)?import\s+Challenge\b", solution, re.MULTILINE),
        "Solution must not import Challenge specifications")
challenge_names = re.findall(r"^theorem\s+(\w+)", challenge, re.MULTILINE)
solution_names = re.findall(r"^theorem\s+(\w+)", solution, re.MULTILINE)
expected = {n.removeprefix("AMGMSubmission.") for n in config["theorem_names"]}
require(set(challenge_names) == set(solution_names) == expected,
        "Challenge and Solution must contain exactly the selected specifications and proofs")

manifest = json.loads((ROOT / "lake-manifest.json").read_text())
mathlib = None
for package in manifest["packages"]:
    require(package["type"] == "git", "Only pinned Git dependencies are supported")
    require(re.fullmatch(r"[0-9a-f]{40}", package["rev"]), "Dependency is not commit-pinned")
    require(re.fullmatch(r"https://github\.com/[^/]+/[^/?#]+(?:\.git)?", package["url"]),
            "Dependency URL must be public and credential-free")
    if package["name"] == "mathlib":
        mathlib = package
require(mathlib is not None, "Mathlib dependency missing")
require(mathlib["url"].removesuffix(".git") == "https://github.com/leanprover-community/mathlib4",
        "Challenge must use canonical Mathlib")
with urlopen(
    "https://raw.githubusercontent.com/leanprover-community/mathlib4/"
    + mathlib["rev"] + "/lean-toolchain", timeout=30
) as response:
    require(response.read().decode().strip() == (ROOT / "lean-toolchain").read_text().strip(),
            "Lean toolchain does not exactly match pinned Mathlib")
print(f"Palomar format checks passed: {source_count} Lean files, "
      f"{len(expected)} compared theorems, {size} source bytes, {license_id}.")
