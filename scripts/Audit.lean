module

import all NoncommutativeAMGM
import all NoncommutativeAMGM.Alternating
import all NoncommutativeAMGM.Basic
import all NoncommutativeAMGM.MatrixOrder
import all NoncommutativeAMGM.FallingFactorial
import all NoncommutativeAMGM.ScalarEstimate
import all NoncommutativeAMGM.Boolean
import all NoncommutativeAMGM.Extraction
import all NoncommutativeAMGM.Quadrature
import all NoncommutativeAMGM.Parseval
import all NoncommutativeAMGM.Sampling
import all NoncommutativeAMGM.MixedMoments
import all NoncommutativeAMGM.SymmetricSums
import all NoncommutativeAMGM.CoefficientOperator
import all NoncommutativeAMGM.CoefficientEnergy
import all NoncommutativeAMGM.SpectralLower
import all NoncommutativeAMGM.CoefficientSpace
import all NoncommutativeAMGM.CoefficientTail
import all NoncommutativeAMGM.HarmonicCoefficients
import all NoncommutativeAMGM.ParityCoefficients
import all NoncommutativeAMGM.DifferenceFamily
import all NoncommutativeAMGM.RemainderSafety
import all NoncommutativeAMGM.RemainderEnergy
import all NoncommutativeAMGM.RealRootQuadrature
import all NoncommutativeAMGM.RootPositivity
import all NoncommutativeAMGM.UnitCircleLift
import all NoncommutativeAMGM.HomogeneousSpace
import all NoncommutativeAMGM.HarmonicRaising
import all NoncommutativeAMGM.HarmonicExpansion
import all NoncommutativeAMGM.BooleanDegree
import all NoncommutativeAMGM.SliceSubstitution
import all NoncommutativeAMGM.HarmonicIntersection
import all NoncommutativeAMGM.SliceDifference
import all NoncommutativeAMGM.HarmonicNorm
import all NoncommutativeAMGM.SlicePositivity
import all NoncommutativeAMGM.SliceCoefficientPolynomial
import all NoncommutativeAMGM.SliceQuadraturePositivity
import all NoncommutativeAMGM.MatrixSlicePositivity
import all NoncommutativeAMGM.MatrixGramFactor
import all NoncommutativeAMGM.BooleanMatrix
import all NoncommutativeAMGM.BooleanVariance
import all NoncommutativeAMGM.BooleanMatrixInput
import all NoncommutativeAMGM.ChebyshevSquares
import all NoncommutativeAMGM.BooleanMatrixPolynomial
import all NoncommutativeAMGM.ChebyshevEvenGram
import all NoncommutativeAMGM.BooleanInputGram
import all NoncommutativeAMGM.ChebyshevOddGram
import all NoncommutativeAMGM.ChebyshevQuadrature
import all NoncommutativeAMGM.ChebyshevRootAverage
import all NoncommutativeAMGM.RootCoefficientExtraction
import all NoncommutativeAMGM.OrderedWords
import all NoncommutativeAMGM.MatrixCoefficientExtraction
import all NoncommutativeAMGM.RootSliceExtraction
import all NoncommutativeAMGM.ChebyshevCoefficient
import all NoncommutativeAMGM.ProductScaling
import all NoncommutativeAMGM.QuadraticBound
import all NoncommutativeAMGM.RootEndpoint
import all NoncommutativeAMGM.ZeroSlice
import all NoncommutativeAMGM.EndpointChebyshev
import all NoncommutativeAMGM.StrengthenedLowerBound
import all NoncommutativeAMGM.ActualCoefficientNorm
import all NoncommutativeAMGM.CubicBound
import all NoncommutativeAMGM.IteratedRemainderEnergy
import all NoncommutativeAMGM.CosineGap
import all NoncommutativeAMGM.RoundedNodes
import all NoncommutativeAMGM.CosineRootNodes
import all NoncommutativeAMGM.CosineGridFold
import all NoncommutativeAMGM.CosineQuadrature
import all NoncommutativeAMGM.ChebyshevWeights
import all NoncommutativeAMGM.OneSlice
import all NoncommutativeAMGM.SineNodeBounds
import all NoncommutativeAMGM.ChebyshevImage
import all NoncommutativeAMGM.CosineSlicePositivity
import all NoncommutativeAMGM.SineBound
import all NoncommutativeAMGM.SimplexRecurrence
import all NoncommutativeAMGM.SimplexVectors
import all NoncommutativeAMGM.SimplexMatrices
import all NoncommutativeAMGM.SimplexTransfer
import all NoncommutativeAMGM.SimplexWords
import all NoncommutativeAMGM.SimplexSymmetry
import all NoncommutativeAMGM.SimplexEigenvalue
import all NoncommutativeAMGM.SimplexCounterexample
import all NoncommutativeAMGM.InterpolationWeights
import all NoncommutativeAMGM.RoundedCosineNodes
import all NoncommutativeAMGM.NodePerturbation
import all NoncommutativeAMGM.InverseSquareGaps
import all NoncommutativeAMGM.RoundedWeights
import all NoncommutativeAMGM.RoundedEndpoint
import all NoncommutativeAMGM.RoundedWeightSigns
import all NoncommutativeAMGM.ArccosMargin
import all NoncommutativeAMGM.CosineNodeMargin
import all NoncommutativeAMGM.ChebyshevRounding
import all NoncommutativeAMGM.RoundedVariation
import all NoncommutativeAMGM.IntegerSlices
import all NoncommutativeAMGM.ScalarHomogeneousSpace
import all NoncommutativeAMGM.InterpolationSliceExtraction
import all NoncommutativeAMGM.BinomialInterpolation
import all NoncommutativeAMGM.RoundedLowerBound
import all NoncommutativeAMGM.SimplexThreshold
import all Solution
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
      | some idx => (`NoncommutativeAMGM).isPrefixOf moduleNames[idx.toNat]! ||
          moduleNames[idx.toNat]! == `Solution
    if fromProject then
      let axioms ← collectAxioms name
      for ax in axioms do
        unless #[`propext, `Classical.choice, `Quot.sound].contains ax do
          throwError "{name} depends on forbidden axiom {ax}"
      count := count + 1
  if count == 0 then
    throwError "No project declarations were audited"
  logInfo m!"Audited {count} project declarations; only standard axioms occur."
