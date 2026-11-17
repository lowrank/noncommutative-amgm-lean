module

public import NoncommutativeAMGM.Basic

/-! # The inverse-square distance sum in the interpolation perturbation estimate -/

@[expose] public section

namespace NoncommutativeAMGM
open scoped BigOperators

/-- Basel's sum, counted on both sides of a fixed index in a finite interval. -/
theorem inverseSquare_gap_sum {m j : ℕ} (hj : j ≤ m) :
    (∑ l ∈ (Finset.range (m + 1)).erase j, 1 / ((j : ℝ) - l) ^ 2) ≤
      Real.pi ^ 2 / 3 := by
  classical
  let s := Finset.range (m + 1)
  let f := fun l : ℕ ↦ 1 / ((j : ℝ) - l) ^ 2
  have hleft : (∑ l ∈ s.filter (fun l ↦ l < j), f l) ≤ Real.pi ^ 2 / 6 := by
    let t := s.filter (fun l ↦ l < j)
    have hinj : Set.InjOn (fun l ↦ j - l) t := by
      intro a ha b hb he
      have ha' := (Finset.mem_filter.mp ha).2
      have hb' := (Finset.mem_filter.mp hb).2
      dsimp only at he
      omega
    have he : (∑ k ∈ t.image (fun l ↦ j - l), 1 / (k : ℝ) ^ 2) = ∑ l ∈ t, f l := by
      rw [Finset.sum_image hinj]
      apply Finset.sum_congr rfl
      intro l hl
      rw [Nat.cast_sub (Nat.le_of_lt (Finset.mem_filter.mp hl).2)]
    rw [← he]
    exact sum_le_hasSum _ (fun _ _ ↦ by positivity) hasSum_zeta_two
  have hright : (∑ l ∈ s.filter (fun l ↦ ¬l < j), f l) ≤ Real.pi ^ 2 / 6 := by
    let t := s.filter (fun l ↦ ¬l < j)
    have hinj : Set.InjOn (fun l ↦ l - j) t := by
      intro a ha b hb he
      have ha' := (Finset.mem_filter.mp ha).2
      have hb' := (Finset.mem_filter.mp hb).2
      dsimp only at he
      omega
    have he : (∑ k ∈ t.image (fun l ↦ l - j), 1 / (k : ℝ) ^ 2) = ∑ l ∈ t, f l := by
      rw [Finset.sum_image hinj]
      apply Finset.sum_congr rfl
      intro l hl
      rw [Nat.cast_sub (by have := (Finset.mem_filter.mp hl).2; omega)]
      dsimp [f]
      rw [show ((l : ℝ) - j) ^ 2 = ((j : ℝ) - l) ^ 2 by ring]
    rw [← he]
    exact sum_le_hasSum _ (fun _ _ ↦ by positivity) hasSum_zeta_two
  have hsplit := Finset.sum_filter_add_sum_filter_not s (fun l ↦ l < j) f
  have herase := Finset.sum_erase_add s f (by simp [s]; omega : j ∈ s)
  have hzero : f j = 0 := by simp [f]
  rw [hzero, add_zero] at herase
  change (∑ l ∈ s.erase j, f l) ≤ _
  linarith

end NoncommutativeAMGM
