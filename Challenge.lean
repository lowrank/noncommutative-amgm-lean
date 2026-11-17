module

public import Mathlib

/-!
# Noncommutative AM-GM: independently stated Palomar challenge

For arbitrary real positive semidefinite matrices whose sum is at most `n I`,
these statements bound the uniform average of all ordered distinct-index products.
The natural number `(m + 1) / 2` is exactly `ceil(m/2)`.

Only Mathlib is imported here. Every definition has its concrete mathematical body.
Each theorem below has a deliberately unproved Challenge specification, represented
by a private axiom. These statements are not proof assumptions: `Solution` never
imports this module and gives genuine proofs of the identically named theorems.
Comparator checks only those solution proofs against these independent statement
types, using the permitted standard axioms. No proof library or Solution declaration
contains a proof placeholder or imports a specification axiom.
-/

@[expose] public section
namespace AMGMSubmission
open scoped BigOperators

/-- Average of all ordered products of `m` distinct members of `A`, normalized by
`(n-m)!/n!`. All compared statements assume `1 ≤ m ≤ n`. -/
noncomputable def withoutReplacementMean {n dim : ℕ} (m : ℕ)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ) : Matrix (Fin dim) (Fin dim) ℝ :=
  (((n - m).factorial : ℝ) / (n.factorial : ℝ)) •
    ∑ f : Fin m ↪ Fin n, (List.ofFn fun j ↦ A (f j)).prod

/-- Theorem 1.2: the full two-sided noncommutative AM-GM bound at `n ≥ 2 ceil(m/2)²`. -/
private axiom quadratic_bounds_spec {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : 2 * ((m + 1) / 2) ^ 2 ≤ n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + 1).PosSemidef ∧
      (1 - withoutReplacementMean m A).PosSemidef

theorem quadratic_bounds {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : 2 * ((m + 1) / 2) ^ 2 ≤ n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + 1).PosSemidef ∧
      (1 - withoutReplacementMean m A).PosSemidef :=
  quadratic_bounds_spec hm hmn hsize A hPSD hmean

/-- Theorem 1.1: the lower bound improves to `-1 + 1/(2m)` when `n ≥ 4m²`. -/
private axiom strengthened_lower_spec {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : 4 * m ^ 2 ≤ n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + (1 - 1 / (2 * (m : ℝ))) • 1).PosSemidef

theorem strengthened_lower {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : 4 * m ^ 2 ≤ n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + (1 - 1 / (2 * (m : ℝ))) • 1).PosSemidef :=
  strengthened_lower_spec hm hmn hsize A hPSD hmean

/-- A stronger endpoint-retaining bound `-1+1/m`, at the quadratic threshold. -/
private axiom endpoint_lower_spec {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : 2 * ((m + 1) / 2) ^ 2 ≤ n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + (1 - 1 / (m : ℝ)) • 1).PosSemidef

theorem endpoint_lower {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : 2 * ((m + 1) / 2) ^ 2 ≤ n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + (1 - 1 / (m : ℝ)) • 1).PosSemidef :=
  endpoint_lower_spec hm hmn hsize A hPSD hmean

/-- Theorem 3.5: the original sine-node criterion, without a quadratic size assumption. -/
private axiom sine_bounds_spec {n m dim : ℕ} (hm : 1 ≤ m) (_hmn : m ≤ n)
    (hsize : 2 * ((m + 1) / 2) ≤ n)
    (hsine : (((m + 1) / 2 : ℕ) : ℝ) - 1 ≤
      (n : ℝ) * Real.sin (Real.pi / (2 * (m : ℝ))) ^ 2)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + 1).PosSemidef ∧
      (1 - withoutReplacementMean m A).PosSemidef

theorem sine_bounds {n m dim : ℕ} (hm : 1 ≤ m) (_hmn : m ≤ n)
    (hsize : 2 * ((m + 1) / 2) ≤ n)
    (hsine : (((m + 1) / 2 : ℕ) : ℝ) - 1 ≤
      (n : ℝ) * Real.sin (Real.pi / (2 * (m : ℝ))) ^ 2)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + 1).PosSemidef ∧
      (1 - withoutReplacementMean m A).PosSemidef :=
  sine_bounds_spec hm _hmn hsize hsine A hPSD hmean

/-- Corollary 3.6: the cubic criterion `m³ ≤ 2n` implies both bounds. -/
private axiom cubic_bounds_spec {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : m ^ 3 ≤ 2 * n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + 1).PosSemidef ∧
      (1 - withoutReplacementMean m A).PosSemidef

theorem cubic_bounds {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : m ^ 3 ≤ 2 * n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + 1).PosSemidef ∧
      (1 - withoutReplacementMean m A).PosSemidef :=
  cubic_bounds_spec hm hmn hsize A hPSD hmean

end AMGMSubmission
