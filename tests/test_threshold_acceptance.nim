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
    
    test "Same seed produces the same result":
        let graph = Graph(
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

        var solution1 = initialSolution
        var solution2 = initialSolution

        let maxDist = 1000.0
        let norm = 3000.0

        proc tspCost(path: seq[City]): float =
            cost(path, graph, maxDist, norm)

        let config = ThresholdConfig(
            initialTemperature: 1.0,
            epsilon: 0.01,
            coolingFactor: 0.5,
            batchSize: 5,
            maxAttempts: 50,
            maxBatchesPerTemperature: 20
        )

        var rng1 = initRand(123)
        var rng2 = initRand(123)

        let result1 = thresholdAcceptance(
            solution1,
            config,
            rng1,
            tspCost
        )

        let result2 = thresholdAcceptance(
            solution2,
            config,
            rng2,
            tspCost
        )

        check abs(result1.bestCost - result2.bestCost) <= Epsilon
        check result1.bestSolution == result2.bestSolution