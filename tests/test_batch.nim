#[
Tests the batch-processing behavior of the Threshold Acceptance heuristic.

The tests verify that batches can be completed when the temperature allows
enough accepted moves, that execution stops when the maximum number of attempts
is reached, and that rejected neighbors correctly restore the previous solution.
]#

import unittest
import std/random
import ../src/models/city
import ../src/models/graph
import ../src/tsp/cost
import ../src/tsp/weights
import ../src/heuristics/threshold_acceptance/batch
import ../src/heuristics/threshold_acceptance/config
import ../src/models/matrix

const Epsilon = 1e-7

#[
Test suite for the batch execution used by the Threshold Acceptance heuristic.

It checks batch completion, the maximum-attempt stopping condition,
and the restoration of the solution after a rejected neighbor.
]#

suite "Batch":

    test "Completes a batch when temperature is high enough":
        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 100.0, 400.0],
                @[100.0, 0.0, 200.0],
                @[400.0, 200.0, 0.0]
            ])
        )

        let cities = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]
        var solution = @[0, 1, 2]

        let maxDist = 400.0
        let norm = 500.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        proc tspCost(path: seq[int]): float =
            cost(path, augmentedWeights, norm)
        
        proc tspNeighborCost(path: seq[int], currentCost: float, i: int, j: int): float =
            tspCost(path)
        

        let config = ThresholdConfig(
            initialTemperature: 10.0,
            epsilon: 1e-6,
            coolingFactor: 0.95,
            batchSize: 3,
            maxAttempts: 20
        )

        var rng = initRand(123)

        let currentCost = tspCost(solution)
        var bestSolution = solution[0 .. ^1]
        var bestCost = currentCost

        let result = calculateBatch(
            solution,
            temperature = 10.0,
            config = config,
            rng = rng,
            currentCost = currentCost,
            bestSolution = bestSolution,
            bestCost = bestCost,
            neighborCostFunction = tspNeighborCost
        )

        check result.accepted == 3
        check result.average >= 0.0
        check abs(result.currentCost - tspCost(solution)) <= Epsilon

    test "Stops when maximum attempts is reached":
        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 1.0, 1000.0],
                @[1.0, 0.0, 1.0],
                @[1000.0, 1.0, 0.0]
            ])
        )

        let cities = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]
        var solution = @[0, 1, 2]

        let maxDist = 1000.0
        let norm = 2.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        proc tspCost(path: seq[int]): float =
            cost(path, augmentedWeights, norm)
    
        proc tspNeighborCost(path: seq[int], currentCost: float, i: int, j: int): float =
            tspCost(path)

        let config = ThresholdConfig(
            initialTemperature: 0.0,
            epsilon: 1e-6,
            coolingFactor: 0.95,
            batchSize: 100,
            maxAttempts: 2
        )

        var rng = initRand(123)

        let currentCost = tspCost(solution)
        var bestSolution = solution[0 .. ^1]
        var bestCost = currentCost

        let result = calculateBatch(
            solution,
            temperature = 0.0,
            config = config,
            rng = rng,
            currentCost = currentCost,
            bestSolution = bestSolution,
            bestCost = bestCost,
            neighborCostFunction = tspNeighborCost
        )

        check result.accepted <= 2
        check abs(result.currentCost - tspCost(solution)) <= Epsilon

    test "Restores solution when neighbor is rejected":
        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 1.0, 1000.0],
                @[1.0, 0.0, 1.0],
                @[1000.0, 1.0, 0.0]
            ])
        )

        let cities = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]
        var solution = @[0, 1, 2]

        let original = solution

        let maxDist = 1000.0
        let norm = 2.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        proc tspCost(path: seq[int]): float =
            cost(path, augmentedWeights, norm)
        
        proc tspNeighborCost(path: seq[int], currentCost: float, i: int, j: int): float =
            tspCost(path)

        let config = ThresholdConfig(
            initialTemperature: 0.0,
            epsilon: 1e-6,
            coolingFactor: 0.95,
            batchSize: 1,
            maxAttempts: 1
        )

        var rng = initRand(7)

        let currentCost = tspCost(solution)
        var bestSolution = solution[0 .. ^1]
        var bestCost = currentCost

        let result = calculateBatch(
            solution,
            temperature = 0.0,
            config = config,
            rng = rng,
            currentCost = currentCost,
            bestSolution = bestSolution,
            bestCost = bestCost,
            neighborCostFunction = tspNeighborCost

        )

        check result.accepted == 0
        check solution == original
        check abs(result.currentCost - currentCost) <= Epsilon