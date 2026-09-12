import unittest
import std/random

import ../src/models/city
import ../src/models/graph
import ../src/tsp/cost
import ../src/heuristics/threshold_acceptance/initial_temperature

const Epsilon = 1e-7

suite "Initial Temperature":

    test "High temperature accepts all sampled neighbors":
        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 20.0],
                @[10.0, 0.0, 30.0],
                @[20.0, 30.0, 0.0]
        ]
        )

        var solution = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]

        let maxDist = 30.0
        let norm = 60.0

        proc tspCost(path: seq[City]): float =
            cost(path, graph, maxDist, norm)

        proc tspNeighborCost(path: seq[City], currentCost: float, i: int, j: int): float =
            tspCost(path)

        let currentCost = tspCost(solution)
        var rng = initRand(123)

        let result = calculateAcceptanceRate(
            solution,
            currentCost,
            temperature = 1000.0,
            sampleSize = 20,
            rng = rng,
            neighborCostFunction = tspNeighborCost
        )

        check abs(result.rate - 1.0) <= Epsilon
        check abs(result.currentCost - tspCost(solution)) <= Epsilon


    test "Same seed produces the same acceptance result":
        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 20.0],
                @[10.0, 0.0, 30.0],
                @[20.0, 30.0, 0.0]
            ]
        )

        var solution1 = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]

        var solution2 = solution1[0 .. ^1]

        let maxDist = 30.0
        let norm = 60.0

        proc tspCost(path: seq[City]): float =
            cost(path, graph, maxDist, norm)

        proc tspNeighborCost(path: seq[City], currentCost: float, i: int, j: int): float =
            tspCost(path)

        let currentCost1 = tspCost(solution1)
        let currentCost2 = tspCost(solution2)

        var rng1 = initRand(123)
        var rng2 = initRand(123)

        let result1 = calculateAcceptanceRate(
            solution1,
            currentCost1,
            temperature = 0.1,
            sampleSize = 20,
            rng = rng1,
            neighborCostFunction = tspNeighborCost
        )

        let result2 = calculateAcceptanceRate(
            solution2,
            currentCost2,
            temperature = 0.1,
            sampleSize = 20,
            rng = rng2,
            neighborCostFunction = tspNeighborCost
        )

        check abs(result1.rate - result2.rate) <= Epsilon
        check abs(result1.currentCost - result2.currentCost) <= Epsilon
        check solution1 == solution2


    test "Binary search returns a temperature inside the bounds":
        var solution = @[1, 2, 3, 4]

        proc neighborCost(path: seq[int], currentCost: float, i: int, j: int): float =
                currentCost + float(abs(i - j))

        var rng = initRand(123)

        let result = binarySearchTemperature(
            solution,
            currentCost = 0.0,
            lower = 0.0,
            upper = 10.0,
            targetAcceptance = 0.50,
            sampleSize = 100,
            rng = rng,
            neighborCostFunction = neighborCost
        )

        check result.temperature >= 0.0
        check result.temperature <= 10.0


    test "Initial temperature search is reproducible with same seed":
        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 20.0, 40.0],
                @[10.0, 0.0, 30.0, 15.0],
                @[20.0, 30.0, 0.0, 25.0],
                @[40.0, 15.0, 25.0, 0.0]
            ]
        )

        let maxDist = 40.0
        let norm = 100.0

        var solution1 = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4)
        ]

        var solution2 = solution1[0 .. ^1]

        proc tspCost(path: seq[City]): float =
                cost(path, graph, maxDist, norm)

        proc tspNeighborCost(path: seq[City], currentCost: float, i: int, j: int): float =
                tspCost(path)

        var rng1 = initRand(123)
        var rng2 = initRand(123)

        let result1 = initialTemperature(
            solution1,
            tspCost,
            initialGuess = 0.1,
            targetAcceptance = 0.80,
            sampleSize = 100,
            rng = rng1,
            neighborCostFunction = tspNeighborCost
        )

        let result2 = initialTemperature(
            solution2,
            tspCost,
            initialGuess = 0.1,
            targetAcceptance = 0.80,
            sampleSize = 100,
            rng = rng2,
            neighborCostFunction = tspNeighborCost
        )

        check abs(result1.temperature - result2.temperature) <= Epsilon
        check abs(result1.currentCost - result2.currentCost) <= Epsilon
        check solution1 == solution2


    test "Returned current cost matches the modified solution":
        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 20.0, 40.0],
                @[10.0, 0.0, 30.0, 15.0],
                @[20.0, 30.0, 0.0, 25.0],
                @[40.0, 15.0, 25.0, 0.0]
            ]
        )

        let maxDist = 40.0
        let norm = 100.0

        var solution = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4)
        ]

        proc tspCost(path: seq[City]): float =
            cost(path, graph, maxDist, norm)

        proc tspNeighborCost(path: seq[City], currentCost: float, i: int, j: int): float =
                tspCost(path)

        var rng = initRand(123)

        let result = initialTemperature(
            solution,
            tspCost,
            initialGuess = 0.1,
            targetAcceptance = 0.80,
            sampleSize = 100,
            rng = rng,
            neighborCostFunction = tspNeighborCost
        )

        check result.temperature > 0.0
        check abs(result.currentCost - tspCost(solution)) <= Epsilon