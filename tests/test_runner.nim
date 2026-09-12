import unittest

import ../src/models/city
import ../src/models/graph
import ../src/tsp/cost
import ../src/heuristics/threshold_acceptance/config
import ../src/runner/runner
import ../src/tsp/feasibility

let testGraph = Graph(
  adjacencyMatrix: @[
    @[0.0, 1.0, 1000.0, 1000.0],
    @[1.0, 0.0, 1.0, 1000.0],
    @[1000.0, 1.0, 0.0, 1.0],
    @[1000.0, 1000.0, 1.0, 0.0]
  ]
)

let initialSolution = @[
  City(id: 1),
  City(id: 3),
  City(id: 2),
  City(id: 4)
]

let maxDist = 1000.0
let norm = 3000.0

proc tspCost(path: seq[City]): float =
  cost(path, testGraph, maxDist, norm)


proc testFeasible(path: seq[City]): bool =
    isFeasible(path, testGraph)

proc tspNeighborCost(path: seq[City], currentCost: float, i: int, j: int): float =
          tspCost(path)
      

let cfg = ThresholdConfig(
  initialTemperature: 1.0,
  epsilon: 0.01,
  coolingFactor: 0.5,
  batchSize: 5,
  maxAttempts: 50,
  maxBatchesPerTemperature: 20
)


suite "Runner":

  test "Same base seed produces the same result":
    let result1 = runMultiple(initialSolution, cfg, 5, 123, 0, tspCost, testFeasible, tspNeighborCost)
    let result2 = runMultiple(initialSolution, cfg, 5, 123, 0, tspCost, testFeasible, tspNeighborCost)

    check result1.bestCost == result2.bestCost
    check result1.bestSeed == result2.bestSeed
    check result1.bestSolution == result2.bestSolution

  test "Best result is not worse than initial solution":
    let initialCost = tspCost(initialSolution)
    let result = runMultiple(initialSolution, cfg, 5, 123, 0, tspCost, testFeasible, tspNeighborCost)

    check result.bestCost <= initialCost