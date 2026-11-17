import NoncommutativeAMGM
import Lean.Util.CollectAxioms

open Lean

-- Check every declaration originating in a project module, including private helpers.
run_cmd do
  let env ← getEnv
  let moduleNames := env.allImportedModuleNames
  let mut count : Nat := 0
  for (name, _) in env.constants.toList do
    let fromProject := match env.getModuleIdxFor? name with
      | none => false
      | some idx => (`NoncommutativeAMGM).isPrefixOf moduleNames[idx.toNat]!
    if fromProject then
      let axioms ← collectAxioms name
      for ax in axioms do
        unless #[`propext, `Classical.choice, `Quot.sound].contains ax do
          throwError "{name} depends on forbidden axiom {ax}"
      count := count + 1
  if count == 0 then
    throwError "No project declarations were audited"
  logInfo m!"Audited {count} project declarations; only standard axioms occur."
