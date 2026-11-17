module

public import NoncommutativeAMGM.HomogeneousSpace

/-! # The raising operator as multiplication by the total Boolean variable -/

@[expose] public section
namespace NoncommutativeAMGM
open scoped BigOperators

theorem sum_insert_indicator {n : ℕ} (S T : Finset (Fin n)) (a : ℝ) :
    (∑ i : Fin n, if insert i S = T then a else 0) =
      (if T = S then (S.card : ℝ) * a else 0) +
        (if S ⊆ T ∧ S.card + 1 = T.card then a else 0) := by
  classical
  by_cases hTS : T = S
  · subst T
    have hi (i : Fin n) : insert i S = S ↔ i ∈ S := Finset.insert_eq_self
    simp_rw [hi]
    simp
  · simp only [hTS, ite_false, zero_add]
    by_cases hST : S ⊆ T ∧ S.card + 1 = T.card
    · obtain ⟨i, hi, hiT⟩ := Finset.exists_eq_insert_iff.mpr hST
      rw [ite_eq_left hST]
      calc
        _ = ∑ j : Fin n, if j = i then a else 0 := by
          apply Finset.sum_congr rfl
          intro j _
          have he : insert j S = T ↔ j = i := by
            rw [← hiT]
            constructor
            · intro he
              have : i ∈ insert j S := he.symm ▸ Finset.mem_insert_self i S
              simpa [hi, eq_comm] using this
            · rintro rfl
              rfl
          simp only [he]
        _ = a := by simp
    · rw [ite_eq_right hST]
      apply Finset.sum_eq_zero
      intro i _
      rw [ite_eq_right]
      intro he
      have hi : i ∉ S := by
        intro hi
        exact hTS (he.symm.trans (Finset.insert_eq_of_mem hi))
      exact hST (Finset.exists_eq_insert_iff.mp ⟨i, hi, he⟩)

set_option backward.isDefEq.respectTransparency false in
theorem booleanMonomial_coeff {n : ℕ} (S T : Finset (Fin n)) (a : ℝ) :
    (booleanMonomial S a).coeff (show BooleanMonomial n from T) =
      if S = T then a else 0 := by
  classical
  change (Finsupp.single (show BooleanMonomial n from S) a) T = _
  exact Finsupp.single_apply

set_option backward.isDefEq.respectTransparency false in
theorem homogeneousPolynomial_eq_sum {n r : ℕ} (c : HomogeneousSpace n r) :
    homogeneousPolynomial c = ∑ S : HomogeneousIndex n r, booleanMonomial S.val (c S) := by
  classical
  apply MonoidAlgebra.ext
  ext T
  rw [homogeneousPolynomial_coeff, MonoidAlgebra.coeff_sum, Finsupp.finsetSum_apply]
  have hmono (S : HomogeneousIndex n r) :
      (booleanMonomial S.val (c S)).coeff T = if S.val = (T : Finset (Fin n)) then c S else 0 :=
    booleanMonomial_coeff S.val T (c S)
  simp_rw [hmono]
  by_cases hT : (T : Finset (Fin n)).card = r
  · simp only [homogeneousCoefficient, dite_eq_left hT]
    symm
    have hsum := Finset.sum_eq_single (s := Finset.univ) ⟨(T : Finset (Fin n)), hT⟩
      (f := fun S : HomogeneousIndex n r ↦ if S.val = T then c S else 0)
    calc
      _ = if (⟨(T : Finset (Fin n)), hT⟩ : HomogeneousIndex n r).val = T then
          c ⟨(T : Finset (Fin n)), hT⟩ else 0 := by
        apply hsum
        · intro S _ hne
          exact ite_eq_right (by intro he; exact hne (Subtype.ext he))
        · simp
      _ = _ := by simp
  · have hne (S : HomogeneousIndex n r) : S.val ≠ (T : Finset (Fin n)) := by
      intro he
      exact hT (he ▸ S.property)
    simp [homogeneousCoefficient, hT, hne]

set_option backward.isDefEq.respectTransparency false in
theorem totalVariable_mul_monomial_coeff {n : ℕ} (S T : Finset (Fin n)) (a : ℝ) :
    (totalVariable n * booleanMonomial S a).coeff (show BooleanMonomial n from T) =
      (if T = S then (S.card : ℝ) * a else 0) +
        (if S ⊆ T ∧ S.card + 1 = T.card then a else 0) := by
  classical
  simp only [totalVariable, Finset.sum_mul, MonoidAlgebra.coeff_sum,
    Finsupp.finsetSum_apply, booleanVar, booleanMonomial_mul, one_mul,
    Finset.singleton_union, booleanMonomial_coeff]
  exact sum_insert_indicator S T a

set_option backward.isDefEq.respectTransparency false in
/-- Multiplication by `Z` splits into the diagonal degree and the raising operator. -/
theorem totalVariable_mul_homogeneous {n r : ℕ} (c : HomogeneousSpace n r) :
    totalVariable n * homogeneousPolynomial c =
      (r : ℝ) • homogeneousPolynomial c + homogeneousPolynomial (homogeneousUp n r c) := by
  classical
  apply MonoidAlgebra.ext
  ext T
  have hsum : (∑ S : HomogeneousIndex n r,
      if S.val = (T : Finset (Fin n)) then c S else 0) = homogeneousCoefficient c T := by
    have he := congrArg (fun p : BooleanPolynomial n ↦ p.coeff T)
      (homogeneousPolynomial_eq_sum c)
    simpa only [homogeneousPolynomial_coeff, MonoidAlgebra.coeff_sum,
      Finsupp.finsetSum_apply, booleanMonomial_coeff] using he.symm
  conv_lhs => rw [homogeneousPolynomial_eq_sum c]
  rw [Finset.mul_sum, MonoidAlgebra.coeff_sum, Finsupp.finsetSum_apply]
  simp only [totalVariable_mul_monomial_coeff, MonoidAlgebra.coeff_add,
    Finsupp.add_apply, MonoidAlgebra.coeff_smul, Finsupp.smul_apply,
    smul_eq_mul, homogeneousPolynomial_coeff]
  rw [Finset.sum_add_distrib]
  have hdiag : (∑ S : HomogeneousIndex n r,
      if (T : Finset (Fin n)) = S.val then (S.val.card : ℝ) * c S else 0) =
      (r : ℝ) * homogeneousCoefficient c T := by
    rw [← hsum, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro S _
    simp only [S.property]
    by_cases hS : S.val = (T : Finset (Fin n))
    · simp [hS]
    · simp [hS, Ne.symm hS]
  rw [hdiag]
  congr 1
  by_cases hT : (T : Finset (Fin n)).card = r + 1
  · simp only [homogeneousCoefficient, dite_eq_left hT, homogeneousUp_apply]
    apply Finset.sum_congr rfl
    intro S _
    simp [S.property, hT]
  · simp [homogeneousCoefficient, hT, Ne.symm hT]

theorem homogeneousPolynomial_up {n r : ℕ} (c : HomogeneousSpace n r) :
    homogeneousPolynomial (homogeneousUp n r c) =
      (totalVariable n - (r : ℝ) • 1) * homogeneousPolynomial c := by
  rw [sub_mul, smul_mul_assoc, one_mul, totalVariable_mul_homogeneous]
  abel

end NoncommutativeAMGM
