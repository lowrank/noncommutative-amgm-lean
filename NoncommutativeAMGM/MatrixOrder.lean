module

public import NoncommutativeAMGM.Basic

/-!
# Loewner order and matrix target statements

The order used here is positivity of the difference. The statements of the main
theorems are predicates, not asserted theorems; their proofs remain to be constructed.
-/

public section

namespace NoncommutativeAMGM

open scoped BigOperators

/-- Loewner order on real square matrices. -/
def LoewnerLE {ι : Type*} (A B : Matrix ι ι ℝ) : Prop := (B - A).PosSemidef

scoped infix:50 " ⪯ " => LoewnerLE

theorem loewner_refl {ι : Type*} (A : Matrix ι ι ℝ) : A ⪯ A := by
  simpa [LoewnerLE] using (Matrix.PosSemidef.zero (n := ι) (R := ℝ))

theorem loewner_trans {ι : Type*} {A B C : Matrix ι ι ℝ}
    (hAB : A ⪯ B) (hBC : B ⪯ C) : A ⪯ C := by
  have h := hBC.add hAB
  simpa only [LoewnerLE, sub_add_sub_cancel] using h

theorem loewner_smul {ι : Type*} {A B : Matrix ι ι ℝ} {c : ℝ}
    (h : A ⪯ B) (hc : 0 ≤ c) : c • A ⪯ c • B := by
  simpa only [LoewnerLE, smul_sub] using h.smul hc

/-- The hypotheses of equation (1), with no commutativity or mean-identity assumption. -/
def Admissible {n d : ℕ} (A : Fin n → Matrix (Fin d) (Fin d) ℝ) : Prop :=
  (∀ i, (A i).PosSemidef) ∧ (∑ i, A i) ⪯ (n : ℝ) • 1

/-- Theorem 1.1's full mathematical target. This definition is not a proof of it. -/
def LowerBoundTarget : Prop :=
  ∀ (n m d : ℕ), 1 ≤ m → m ≤ n → 4 * m ^ 2 ≤ n →
    ∀ A : Fin n → Matrix (Fin d) (Fin d) ℝ, Admissible A →
      (-(1 - 1 / (2 * (m : ℝ)))) • 1 ⪯ withoutReplacementMean n m A

/-- Theorem 1.2's full mathematical target, with `⌈m/2⌉ = (m+1)/2`. -/
def QuadraticBoundTarget : Prop :=
  ∀ (n m d : ℕ), 1 ≤ m → m ≤ n → 2 * ((m + 1) / 2) ^ 2 ≤ n →
    ∀ A : Fin n → Matrix (Fin d) (Fin d) ℝ, Admissible A →
      (-(1 : Matrix (Fin d) (Fin d) ℝ) ⪯ withoutReplacementMean n m A) ∧
      (withoutReplacementMean n m A ⪯ 1)

/-- The normalized one-factor sum is PSD. -/
theorem mean_one_posSemidef {n d : ℕ} (hn : 0 < n)
    (A : Fin n → Matrix (Fin d) (Fin d) ℝ) (hA : ∀ i, (A i).PosSemidef) :
    (withoutReplacementMean n 1 A).PosSemidef := by
  rw [withoutReplacementMean_one hn]
  exact (Matrix.posSemidef_sum _ (fun i _ ↦ hA i)).smul (by positivity)

/-- The full two-sided inequality at length one, for arbitrary PSD input matrices. -/
theorem mean_one_bounds {n d : ℕ} (hn : 0 < n)
    (A : Fin n → Matrix (Fin d) (Fin d) ℝ) (hA : Admissible A) :
    (-(1 : Matrix (Fin d) (Fin d) ℝ) ⪯ withoutReplacementMean n 1 A) ∧
    (withoutReplacementMean n 1 A ⪯ 1) := by
  have hn0 : (n : ℝ) ≠ 0 := by positivity
  constructor
  · simpa [LoewnerLE, sub_neg_eq_add] using
      (mean_one_posSemidef hn A hA.1).add Matrix.PosSemidef.one
  · have h := loewner_smul hA.2 (show 0 ≤ (n : ℝ)⁻¹ by positivity)
    simpa [withoutReplacementMean_one hn, smul_smul, hn0] using h

end NoncommutativeAMGM
