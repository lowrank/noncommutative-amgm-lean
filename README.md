# When the noncommutative AM-GM inequality holds — Lean

Formalization project for Yimin Zhong,
[arXiv:2610.04874v1](https://arxiv.org/abs/2610.04874v1), using **Lean 4.35.0**.

**Status: complete formalization of the paper's results, including the supporting estimates and appendices.**

The full quadratic bound is `NoncommutativeAMGM.quadraticBoundTarget` in
[QuadraticBound.lean](NoncommutativeAMGM/QuadraticBound.lean), with the original
arbitrary-PSD and sum-at-most-`nI` assumptions. The strengthened lower bound is
`NoncommutativeAMGM.lowerBoundTarget` in
[StrengthenedLowerBound.lean](NoncommutativeAMGM/StrengthenedLowerBound.lean).
Retaining the root-grid endpoint proves the stronger lower bound `−1+1/m`
already under Theorem 1.2's quadratic threshold.
The repository contains only completed declarations: no proof placeholders or custom axioms.
An absence of placeholders does not establish coverage of the paper.
See [the coverage ledger](docs/COVERAGE.md) for the exact boundary.

## Palomar package

The repository root is the Lean project. The independently stated
[Challenge](Challenge.lean) imports only Mathlib and contains the full concrete
ordered-product average. [Solution](Solution.lean) proves the same five statements
from the complete proof library. [comparator.json](comparator.json) selects:

| Declaration in `AMGMSubmission` | Result |
| --- | --- |
| `quadratic_bounds` | Theorem 1.2, both bounds at `n ≥ 2⌈m/2⌉²` |
| `strengthened_lower` | Theorem 1.1, `−1+1/(2m)` at `n ≥ 4m²` |
| `endpoint_lower` | Stronger `−1+1/m` at the quadratic threshold |
| `sine_bounds` | Theorem 3.5, original sine-node criterion |
| `cubic_bounds` | Corollary 3.6, `m³ ≤ 2n` |

Challenge theorem bodies use five private specification axioms. These are deliberately
unproved statements of record, and are never imported by Solution. The concrete average
has no definition hole. All Solution and library proofs use only `propext`,
`Classical.choice`, and `Quot.sound`, with no `sorry` or custom proof assumptions.
The remaining supporting results and appendices are built and axiom-audited; they
are not separate registry claims in this Comparator configuration.

[formalization.yaml](formalization.yaml) records provenance, classification, AI
assistance, source alignment and review scope. To prepare a submission at
<https://submit.palomar-registry.org/>, use:

* Repository: `lowrank/noncommutative-amgm-lean`
* Commit: the full 40-character SHA from `git rev-parse HEAD`
* Project path: repository root (leave the project-path field empty)
* Comparator path: `comparator.json`
* Metadata path: `formalization.yaml` (the default)

Packaging and CI do not submit or register the project with Palomar.

## Build and audit

```sh
python3 -m venv .lake/metadata-venv
.lake/metadata-venv/bin/pip install -r scripts/requirements-palomar.txt
.lake/metadata-venv/bin/python scripts/check_palomar.py
lake exe cache get
python3 scripts/check_imports.py
lake build
lake env lean -DwarningAsError=true scripts/Audit.lean
scripts/verify_comparator.sh
```

The pinned Lean 4.35.0 toolchain supplies Comparator and its kernels. The verification
script uses the default sandbox and replays selected proofs with Lean, NanoDa and
con-ron; con-ron runs with one worker to bound memory. On hosts whose user-namespace
policy prevents bubblewrap from starting, `scripts/verify_comparator.sh
--inadvisably-no-sandbox` is an explicitly untrusted local diagnostic, not a sandboxed
verification result. CI configures bubblewrap and uses the default sandbox.

The toolchain and dependency manifest are pinned. CI checks Palomar metadata, all Lean
module headers and size limits, complete library import coverage, the build, the
transitive axioms of every library/Solution declaration, and Comparator. Ordinary
CI builds retain writable Lake caching; isolated comparison disables artifact-cache
writes so it also works with frozen dependency trees.

## Mathematical target

For real PSD matrices `A₁, …, Aₙ` with `∑ Aᵢ ⪯ nI`, let `W(m,n)` be the average of
the ordered products of length `m` with distinct indices. The main targets are:

* Theorem 1.1: if `1 ≤ m ≤ n` and `n ≥ 4m²`, then `W(m,n) ⪰ −(1 − 1/(2m))I`.
* Theorem 1.2: if `1 ≤ m ≤ n` and `n ≥ 2⌈m/2⌉²`, then `−I ⪯ W(m,n) ⪯ I`.

Theorem 1.1 is also proved by its original rounded-node argument in
[RoundedLowerBound.lean](NoncommutativeAMGM/RoundedLowerBound.lean).
Theorem 1.2 is proved by constructing the harmonic decomposition, positive root quadratures,
Chebyshev matrix Gram factors, and exact ordered-product coefficient extraction. Matrix inequalities use
the Loewner order (positive semidefiniteness of the difference), never entrywise order.

The real scalar class follows the paper's definition of `ℙ_m`. Appendix C's incidence
adjoints and orthogonal splitting are proved over arbitrary `RCLike` fields, including
`ℂ`. Integer slices are identified with uniform averages over actual Boolean vertices.
Appendix A includes the concrete PSD construction, eigenvalue formula, exact threshold,
and an exact seven-matrix counterexample to the unrestricted inequality.
