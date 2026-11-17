module

public import NoncommutativeAMGM

/-!
# Proved Palomar solutions

This module supplies proofs of all five independently stated comparison claims.
It imports the complete proof library, never the Challenge specifications.
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
theorem quadratic_bounds {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : 2 * ((m + 1) / 2) ^ 2 ≤ n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + 1).PosSemidef ∧
      (1 - withoutReplacementMean m A).PosSemidef := by
  change (NoncommutativeAMGM.withoutReplacementMean n m A + 1).PosSemidef ∧
    (1 - NoncommutativeAMGM.withoutReplacementMean n m A).PosSemidef
  simpa only [NoncommutativeAMGM.LoewnerLE, sub_neg_eq_add] using
    NoncommutativeAMGM.withoutReplacementMean_quadratic_bounds hm hmn hsize A ⟨hPSD, hmean⟩

/-- Theorem 1.1: the lower bound improves to `-1 + 1/(2m)` when `n ≥ 4m²`. -/
theorem strengthened_lower {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : 4 * m ^ 2 ≤ n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + (1 - 1 / (2 * (m : ℝ))) • 1).PosSemidef := by
  change (NoncommutativeAMGM.withoutReplacementMean n m A +
    (1 - 1 / (2 * (m : ℝ))) • 1).PosSemidef
  simpa only [NoncommutativeAMGM.LoewnerLE, neg_smul, sub_neg_eq_add] using
    NoncommutativeAMGM.withoutReplacementMean_rounded_lower hm hmn hsize A ⟨hPSD, hmean⟩

/-- A stronger endpoint-retaining bound `-1+1/m`, at the quadratic threshold. -/
theorem endpoint_lower {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : 2 * ((m + 1) / 2) ^ 2 ≤ n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + (1 - 1 / (m : ℝ)) • 1).PosSemidef := by
  change (NoncommutativeAMGM.withoutReplacementMean n m A +
    (1 - 1 / (m : ℝ)) • 1).PosSemidef
  simpa only [NoncommutativeAMGM.LoewnerLE, neg_smul, sub_neg_eq_add] using
    NoncommutativeAMGM.withoutReplacementMean_endpoint_lower hm hmn hsize A ⟨hPSD, hmean⟩

/-- Theorem 3.5: the original sine-node criterion, without a quadratic size assumption. -/
theorem sine_bounds {n m dim : ℕ} (hm : 1 ≤ m) (_hmn : m ≤ n)
    (hsize : 2 * ((m + 1) / 2) ≤ n)
    (hsine : (((m + 1) / 2 : ℕ) : ℝ) - 1 ≤
      (n : ℝ) * Real.sin (Real.pi / (2 * (m : ℝ))) ^ 2)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + 1).PosSemidef ∧
      (1 - withoutReplacementMean m A).PosSemidef := by
  change (NoncommutativeAMGM.withoutReplacementMean n m A + 1).PosSemidef ∧
    (1 - NoncommutativeAMGM.withoutReplacementMean n m A).PosSemidef
  simpa only [NoncommutativeAMGM.LoewnerLE, sub_neg_eq_add] using
    NoncommutativeAMGM.withoutReplacementMean_sine_bounds hm hsize hsine A ⟨hPSD, hmean⟩

/-- Corollary 3.6: the cubic criterion `m³ ≤ 2n` implies both bounds. -/
theorem cubic_bounds {n m dim : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (hsize : m ^ 3 ≤ 2 * n)
    (A : Fin n → Matrix (Fin dim) (Fin dim) ℝ)
    (hPSD : ∀ i, (A i).PosSemidef)
    (hmean : ((n : ℝ) • 1 - ∑ i, A i).PosSemidef) :
    (withoutReplacementMean m A + 1).PosSemidef ∧
      (1 - withoutReplacementMean m A).PosSemidef := by
  change (NoncommutativeAMGM.withoutReplacementMean n m A + 1).PosSemidef ∧
    (1 - NoncommutativeAMGM.withoutReplacementMean n m A).PosSemidef
  simpa only [NoncommutativeAMGM.LoewnerLE, sub_neg_eq_add] using
    NoncommutativeAMGM.withoutReplacementMean_cubic_bounds hm hmn hsize A ⟨hPSD, hmean⟩

end AMGMSubmission
