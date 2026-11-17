import NoncommutativeAMGM
import Lean.Util.CollectAxioms

open Lean

-- Check every declaration in the project namespace, including definitions and helpers.
run_cmd do
  let env ← getEnv
  let mut count : Nat := 0
  for (name, _) in env.constants.toList do
    if (`NoncommutativeAMGM).isPrefixOf name then
      let axioms ← collectAxioms name
      for ax in axioms do
        unless #[`propext, `Classical.choice, `Quot.sound].contains ax do
          throwError "{name} depends on forbidden axiom {ax}"
      count := count + 1
  if count == 0 then
    throwError "No project declarations were audited"
  logInfo m!"Audited {count} project declarations; only standard axioms occur."
