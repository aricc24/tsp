import unittest
import std/random
import ../src/models/city
import ../src/models/graph
import ../src/tsp/cost
import ../src/heuristics/threshold_acceptance/batch
import ../src/heuristics/threshold_acceptance/neighbor

suite "Batch":

    test "Completes a batch when temperature is high enough":
        let graph = Graph(
        adjacencyMatrix: @[
            @[0.0, 100.0, 400.0],
            @[100.0, 0.0, 200.0],
            @[400.0, 200.0, 0.0]
        ]
        )

        var solution = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]

        let maxDist = 400.0
        let norm = 500.0

        proc tspCost(path: seq[City]): float =
            cost(path, graph, maxDist, norm)

        var rng = initRand(123)

        let result = calculateBatch(
            solution,
            temperature = 10.0,
            batchSize = 3,
            maxAttempts = 20,
            rng = rng,
            costFunction = tspCost
        )

        check result.accepted == 3
        check result.average >= 0.0

    test "Stops when maximum attempts is reached":
        let graph = Graph(
        adjacencyMatrix: @[
            @[0.0, 1.0, 1000.0],
            @[1.0, 0.0, 1.0],
            @[1000.0, 1.0, 0.0]
        ]
        )

        var solution = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]

        let maxDist = 1000.0
        let norm = 2.0

        proc tspCost(path: seq[City]): float =
            cost(path, graph, maxDist, norm)

        var rng = initRand(123)

        let result = calculateBatch(
            solution,
            temperature = 0.0,
            batchSize = 100,
            maxAttempts = 2,
            rng = rng,
            costFunction = tspCost
        )

        check result.accepted <= 2

    test "Restores solution when neighbor is rejected":
        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 1.0, 1000.0],
                @[1.0, 0.0, 1.0],
                @[1000.0, 1.0, 0.0]
            ]
        )

        var solution = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]

        let original = solution

        let maxDist = 1000.0
        let norm = 2.0

        proc tspCost(path: seq[City]): float =
            cost(path, graph, maxDist, norm)

        var rng = initRand(7)

        let result = calculateBatch(
            solution,
            temperature = 0.0,
            batchSize = 1,
            maxAttempts = 1,
            rng = rng,
            costFunction = tspCost
        )

        check result.accepted == 0
        check solution == original