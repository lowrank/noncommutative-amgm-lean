# Paper coverage

Source: arXiv:2610.04874v1, 25 pages. Status entries refer to compiled Lean declarations.

| Paper item | Status | Lean location |
| --- | --- | --- |
| Equations (1), (5): ordered product sum and normalization | Compiled definitions | `Basic.lean` |
| Theorem 1.1 / Lemma 2.3: strengthened lower bound | Pending | |
| Lemma 2.2: rounded Chebyshev nodes are distinct | Pending | |
| Lemma 3.1: coefficient extraction | Pending | |
| Lemma 3.2: Boolean matrix sum of squares | Pending | |
| Theorem 3.3: slice functional positivity | Pending | |
| Lemma 3.4: harmonic decomposition and norm identity | Pending | |
| Theorem 3.5 / Corollary 3.6: cubic threshold | Pending | |
| Lemma 3.7: parity quadrature coefficient formula | Pending | |
| Lemma 3.8: falling factorial factorization | Pending | |
| Lemma 3.9: polynomial remainder norm | Pending | |
| Lemma 3.10: coefficient norm estimate | Pending | |
| Section 3.6: scalar alternating-sum estimate | Pending | |
| Theorem 1.2: quadratic threshold, arbitrary PSD matrices | Pending | |
| Appendix A: counterexample eigenvalue | Pending | |
| Appendix B: Chebyshev interpolation weights | Pending | |
| Appendix C, Lemmas C.1–C.3 and harmonic proof | Pending | |

## Source fidelity notes

* In Lemma 3.2 the final displayed definitions of the odd-degree `F₊` and `F₋`
  appear exchanged relative to their preceding identities. Follow the identities.
* The first line of the proof of Theorem 3.5 uses `sin²(jπ/m)`; the nodes throughout
  are `sin²(jπ/(2m))`.
* Equations (11)–(12) suppress repeated-index word terms after Boolean reduction.
  A formal coefficient-extraction argument must retain them until extraction.
* Appendix C's second displayed orthogonality equivalence interchanges the roles of
  its variables. The required assertion is `(range Δ*)ᗮ = ker Δ`.
* Section 3.5 contains missing squares and shifted remainder coefficients in intermediate
  displays. The target is the stated inequality in Lemma 3.10 and equation (40).

These notes are proof-development observations, not refutations of the main theorem.
