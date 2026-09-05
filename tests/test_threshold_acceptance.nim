import unittest
import random
import ../src/models/city
import ../src/models/graph
import ../src/tsp/cost
import ../src/heuristics/threshold_acceptance/config
import ../src/heuristics/threshold_acceptance/threshold_acceptance

const Epsilon = 1e-7


suite "Threshold Acceptance":

    test "Best solution is not worse than initial solution":
        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 1.0, 1000.0, 1000.0],
                @[1.0, 0.0, 1.0, 1000.0],
                @[1000.0, 1.0, 0.0, 1.0],
                @[1000.0, 1000.0, 1.0, 0.0]
            ]
        )

        var solution = @[
            City(id: 1),
            City(id: 3),
            City(id: 2),
            City(id: 4)
        ]

        let maxDist = 1000.0
        let norm = 3000.0

        proc tspCost(path: seq[City]): float =
            cost(path, graph, maxDist, norm)

        let initialCost = tspCost(solution)

        let config = ThresholdConfig(
            initialTemperature: 1.0,
            epsilon: 0.01,
            coolingFactor: 0.5,
            batchSize: 5,
            maxAttempts: 50,
            maxBatchesPerTemperature: 20
        )

        var rng = initRand(123)

        let result = thresholdAcceptance(
            solution,
            config,
            rng,
            tspCost
        )

        check result.bestCost <= initialCost