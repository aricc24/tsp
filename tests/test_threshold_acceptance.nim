import unittest
import random
import ../src/models/city
import ../src/models/graph
import ../src/tsp/cost
import ../src/tsp/weights
import ../src/heuristics/threshold_acceptance/config
import ../src/heuristics/threshold_acceptance/threshold_acceptance


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
        let augmentedWeights = buildAugmentedWeights(solution, graph, maxDist)

        proc tspCost(path: seq[City]): float =
            cost(path, augmentedWeights, norm)

        proc tspNeighborCost(path: seq[City], currentCost: float, i: int, j: int): float =
                tspCost(path)
            


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
            tspCost, 
            tspNeighborCost
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
        let augmentedWeights = buildAugmentedWeights(initialSolution, graph, maxDist)

        proc tspCost(path: seq[City]): float =
            cost(path, augmentedWeights, norm)

        proc tspNeighborCost(path: seq[City], currentCost: float, i: int, j: int): float =
                tspCost(path)
            


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
            tspCost, 
            tspNeighborCost
        )

        let result2 = thresholdAcceptance(
            solution2,
            config,
            rng2,
            tspCost, 
            tspNeighborCost
        )

        check abs(result1.bestCost - result2.bestCost) == 0
        check result1.bestSolution == result2.bestSolution

    test "Returns initial solution when temperature is already below epsilon":
        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 100.0, 300.0],
                @[100.0, 0.0, 200.0],
                @[300.0, 200.0, 0.0]
            ]
        )

        var solution = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]

        let original = solution

        let maxDist = 300.0
        let norm = 300.0
        let augmentedWeights = buildAugmentedWeights(solution, graph, maxDist)

        proc tspCost(path: seq[City]): float =
            cost(path, augmentedWeights, norm)

        proc tspNeighborCost(path: seq[City], currentCost: float, i: int, j: int): float =
                tspCost(path)
            


        let initialCost = tspCost(solution)

        let config = ThresholdConfig(
            initialTemperature: 0.01,
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
            tspCost, 
            tspNeighborCost
        )

        check result.bestSolution == original
        check abs(result.bestCost - initialCost) == 0

    test "Best solution preserves the original permutation":
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

        let original = solution

        let maxDist = 1000.0
        let norm = 3000.0
        let augmentedWeights = buildAugmentedWeights(solution, graph, maxDist)

        proc tspCost(path: seq[City]): float =
            cost(path, augmentedWeights, norm)
        
        proc tspNeighborCost(path: seq[City], currentCost: float, i: int, j: int): float =
                tspCost(path)
            


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
            tspCost, 
            tspNeighborCost
        )

        check result.bestSolution.len == original.len

        for city in original:
            check city in result.bestSolution