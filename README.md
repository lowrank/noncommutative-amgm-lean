# When the noncommutative AM-GM inequality holds — Lean

Formalization project for Yimin Zhong,
[arXiv:2610.04874v1](https://arxiv.org/abs/2610.04874v1), using **Lean 4.35.0**.

**Status: in progress. Theorems 1.1 and 1.2 are not yet formalized.**
The repository contains only completed declarations: no proof placeholders or custom axioms.
An absence of placeholders does not establish coverage of the paper.
See [the coverage ledger](docs/COVERAGE.md) for the exact boundary.

## Build and audit

```sh
lake exe cache get
python3 scripts/check_imports.py
lake build
lake env lean -DwarningAsError=true scripts/Audit.lean
```

The toolchain and dependency manifest are pinned. CI compiles the library and checks the
transitive axioms of every declaration originating in a project module, including private
declarations and declarations outside the principal namespace. The allowlist is
`propext`, `Classical.choice`, and `Quot.sound`.

## Mathematical target

For real PSD matrices `A₁, …, Aₙ` with `∑ Aᵢ ⪯ nI`, let `W(m,n)` be the average of
the ordered products of length `m` with distinct indices. The main targets are:

* Theorem 1.1: if `1 ≤ m ≤ n` and `n ≥ 4m²`, then `W(m,n) ⪰ −(1 − 1/(2m))I`.
* Theorem 1.2: if `1 ≤ m ≤ n` and `n ≥ 2⌈m/2⌉²`, then `−I ⪯ W(m,n) ⪯ I`.

The intended scope includes the supporting lemmas and appendices. Generic scalar lemmas
are recorded as components, not as proofs of these matrix targets. Matrix inequalities use
the Loewner order (positive semidefiniteness of the difference), never entrywise order.
