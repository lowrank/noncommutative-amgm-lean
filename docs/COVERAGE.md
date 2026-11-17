# Paper coverage

Source: arXiv:2610.04874v1, 25 pages. Status entries refer to compiled Lean declarations.

| Paper item | Status | Lean location |
| --- | --- | --- |
| Equations (1), (5): ordered product sum and normalization | Compiled definitions | `Basic.lean` |
| Arithmetic-mean case and constant-identity equality | Proved | `Basic.lean`, `MatrixOrder.lean` |
| Theorem 1.1 / Lemma 2.3: strengthened lower bound | Pending | |
| Lemma 2.2: rounded Chebyshev nodes are distinct | Pending | |
| Lemma 3.1: matrix coefficient identification with ordered product sum | Pending | |
| Difference of signed root averages extracts the top real-polynomial coefficient | Proved | `RootCoefficientExtraction.lean`: `rootPolynomialAverage_difference` |
| Exact Chebyshev moments on the signed root grids | Proved | `ChebyshevRootAverage.lean`: `rootRealAverage_chebyshev` |
| Lemma 3.1: scalar Boolean extraction from moment constraints | Proved | `Extraction.lean`: `sliceQuadrature_extracts` |
| Boolean algebra and slice moment rule | Proved / constructed | `Boolean.lean` |
| Lemma 3.2: scalar even and odd Chebyshev square identities and factor degrees | Proved | `ChebyshevSquares.lean` |
| Lemma 3.2: actual Chebyshev matrix Gram factors for both signs and parities | Proved | `ChebyshevEvenGram.lean`, `ChebyshevOddGram.lean` |
| Lemma 3.2: degree bounds for matrix polynomial evaluation and input/complement factors | Proved | `BooleanMatrixPolynomial.lean`, `BooleanInputGram.lean` |
| Real PSD Gram factors and rectangular contraction defect | Proved | `MatrixGramFactor.lean` |
| Actual normalized input variance `B-B²` has a degree-one Boolean Gram factor | Proved | `BooleanMatrixInput.lean`: `booleanLinearMatrix_variance_factor` |
| Scalar square positivity extended to actual Boolean matrix Gram sums | Proved | `MatrixSlicePositivity.lean`: `rootSlice_gram_posSemidef` |
| Theorem 3.3: slice functional positivity | Proved for real Boolean polynomials | `SlicePositivity.lean`: `sliceFunctional_square_nonneg` |
| Lemma 3.4: complete falling-factorial harmonic expansion | Proved | `HarmonicExpansion.lean`: `boolean_harmonic_expansion` |
| Lemma 3.4: uniform harmonic replacement preserving the slice second moment | Proved | `SliceSubstitution.lean`: `exists_uniform_harmonic_slice_replacement` |
| Lemma 3.4: orthogonality and norm identity (28) | Proved for real Boolean polynomials | `HarmonicNorm.lean`, `SlicePositivity.lean` |
| Lemma 3.4: harmonic coefficient polynomials, degree at most `d-k` | Proved | `SliceCoefficientPolynomial.lean`: `exists_harmonic_norm_polynomials` |
| Theorem 3.5 / Corollary 3.6: cubic threshold | Pending | |
| Lemma 3.7: root-node quadrature coefficient formula | Proved | `Quadrature.lean`: `rootQuadrature_three_coefficients` |
| Cosine-parity quadrature / root-node identification | Pending | |
| Lemma 3.8: falling factorial factorization | Proved | `FallingFactorial.lean`: `slice_weight_factorization` |
| Nonnegativity of the scalar weights in (28) | Proved | `FallingFactorial.lean`: `harmonic_weight_nonneg` |
| Lemma 3.9: polynomial remainder coefficient norm, root-node form | Proved | `Parseval.lean`: `root_remainder_coefficientNormSq` |
| Lemma 3.10: coefficient norm estimate | Pending | |
| Equation (38), invariant subspace, self-adjointness and weighted energy | Proved | `CoefficientOperator.lean`, `CoefficientEnergy.lean` |
| Lemma 3.10 with a fixed ambient degree and padded endpoint deletion | Proved | `CoefficientTail.lean`: `coefficient_norm_step_padded` |
| Even/odd recurrences, degree bounds, full norm split and endpoint deletion | Proved | `ParityCoefficients.lean` |
| Equation (39), actual `Pⱼ = R(X²-1)ʲ`, before normalization | Proved | `DifferenceFamily.lean`: `differenceFamily_norm_step` |
| Endpoint protection under the final polynomial remainder | Proved | `RemainderSafety.lean` |
| Adjacent estimates in (40), for the actual normalized remainder energies | Proved | `RemainderEnergy.lean`: `remainderEnergy_step` |
| Section 3.6 positivity for the actual remainder energies, without norm hypotheses | Proved | `RemainderEnergy.lean`: `actual_remainder_expansion_nonneg` |
| Equation (42), recurrence-ratio bound, alternating-sum closing step | Proved from explicit scalar estimates | `ScalarEstimate.lean`, `Alternating.lean` |
| Equation (41), actual symmetric sums, and scalar closure from norm estimates | Proved | `SymmetricSums.lean`: `symmetricBeta_expansion_nonneg` |
| Actual remainder energies identified with the root-node averages | Proved | `RealRootQuadrature.lean`: `remainderEnergy_eq_rootRealAverage` |
| Weighted root-node positivity under the quadratic threshold | Proved | `RootPositivity.lean`: `root_weighted_square_nonneg` |
| Real polynomial lift to the unit circle, with degree and evaluation identities | Proved | `UnitCircleLift.lean` |
| Scalar weighted real-polynomial quadrature underlying (29), in root parametrization | Proved | `UnitCircleLift.lean`: `real_polynomial_quadrature_nonneg` |
| Root-grid slice quadrature positivity for actual Boolean squares, quadratic threshold | Proved | `SliceQuadraturePositivity.lean`: `rootSliceFunctional_square_nonneg` |
| Quadratic-threshold PSD root quadratures of both signed Chebyshev matrix expressions | Proved | `ChebyshevQuadrature.lean`: `rootSlice_chebyshev_posSemidef` |
| Theorem 1.2: quadratic threshold, arbitrary PSD matrices | Pending | |
| Appendix A: counterexample eigenvalue | Pending | |
| Appendix B: Chebyshev interpolation weights | Pending | |
| Appendix C: actual up/down incidence operators, adjoints and harmonic splitting | Proved | `HomogeneousSpace.lean` |
| Appendix C: raising is multiplication by `Z-r` | Proved | `HarmonicRaising.lean`: `homogeneousPolynomial_up` |
| Appendix C: intersection-pattern cancellation and harmonic orthogonality | Proved | `HarmonicIntersection.lean`, `HarmonicNorm.lean` |
| Appendix C: alternating coefficient equals the falling-factorial ratio | Proved | `SliceDifference.lean`: `powerset_harmonic_weight` |
| Lemma C.1, first identity `(Z-s)f` | Proved | `Boolean.lean`: `slice_total_sub_mul` |
| Lemma C.1, mixed-moment identity | Proved | `MixedMoments.lean`: `sliceFunctional_mixedMonomial` |
| Lemma C.2, cancellation from harmonic coefficient equations | Proved | `HarmonicCoefficients.lean`: `harmonicCoefficients_upperSum_zero` |
| Motivational sampling probability bound | Corrected and certified | `Sampling.lean` |

## Source fidelity notes

* The probability display on page 2 has the exponential inequality reversed. At `n=m=2`,
  the probability is `1/2 < exp(-1/2)`. `printed_sampling_lower_bound_fails` certifies
  this; `noRepetitionProbability_le_exp` proves the valid upper-bound direction.
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
* The pairing display in Section 3.6 double-counts the last positive term when `k` is odd.
  `alternating_sum_ge_neg_first` supplies the intended inequality without that display.

These notes are proof-development observations, not refutations of the main theorem.

## Remaining proof dependencies

1. Identify the ordered-product matrix extracted by the two root quadratures, with the
   exact Chebyshev leading coefficient and falling-factorial normalization, and close
   Theorem 1.2. The signed quadratures already extract the top coefficient of actual
   real polynomials, and both signed Chebyshev matrix expressions have PSD quadratures
   at the quadratic threshold with constructed Gram factors.
2. Relate the root-grid rules to the paper's cosine parity quadratures and complete the
   supporting interpolation-weight statements. A direct root-grid route can be used
   for Theorem 1.2 without first translating to cosine nodes.
3. Write the all-length product bound in (40), and the exact actual-degree endpoint
   variant of Lemma 3.10. The proved adjacent estimate and padded endpoint version
   already suffice for the constructed quadrature positivity.
4. Complete the rounded-node perturbation estimates for Theorem 1.1, the cubic-threshold
   results, and Appendices A and B. The harmonic and slice-positivity statements are
   currently formalized for real scalar Boolean polynomials; the real matrix
   application has been constructed.

Neither `LowerBoundTarget` nor `QuadraticBoundTarget` currently has a proof. They are
definitions of the requested propositions, not assumed axioms or established theorems.
