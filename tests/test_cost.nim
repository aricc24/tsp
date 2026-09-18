#[
Tests the cost evaluation utilities used by the TSP implementation.

The tests verify the calculation of complete path costs, the use of augmented
weights for missing connections, the identification of edges affected by a swap,
and the correctness of incremental cost updates compared with full reevaluation.
]#

import unittest
import ../src/models/city
import ../src/models/graph
import ../src/tsp/cost
import ../src/tsp/weights
import ../src/tsp/distance
import ../src/heuristics/threshold_acceptance/neighbor
import ../src/models/matrix

const Epsilon = 1e-7

#[
Test suite for complete path cost evaluation.

It verifies costs using existing connections, augmented weights for missing
connections, and confirms that the path is evaluated without adding a return
edge from the last city to the first.
]#
suite "Cost": 

    test "Compute cost using existing connections": 
        let cities = @[
            City(id:1), 
            City(id:2), 
            City(id:3)
        ]
        let path = @[0, 1, 2]

        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 100.0, 0.0],
                @[100.0, 0.0, 200.0],
                @[0.0, 200.0, 0.0]
            ])
        )

        let maxDist = 200.0
        let norm = 300.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        let result = cost(path, augmentedWeights, norm)
        let expected = 1.0

        check abs(result - expected) <= Epsilon

    test "Uses augmented weight for missimg conections": 
        let cities = @[
            City(
                id: 1, 
                latitude: 0.0, 
                longitude: 0.0
            ),
            City(
                id: 2, 
                latitude: 0.0, 
                longitude: 90.0
            )
        ]
        let path = @[0, 1]

        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 0.0], 
                @[0.0, 0.0]
            ]    )    
        )

        let maxDist = 2.0
        let norm = 10.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        let expected = (naturalDistance(cities[0], cities[1]) * maxDist) / norm
        let result = cost(path, augmentedWeights, norm)
        check abs(result - expected) <= 0
    
    test "Does not add an edge from last city back to fist": 
        let cities = @[
            City(id:1),
            City(id:2), 
            City(id:3)
        ]
        let path = @[0, 1, 2]

        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 100.0, 1000.0],
                @[100.0, 0.0, 200.0],
                @[1000.0, 200.0, 0.0]
            ])
        )
        
        let maxDist = 1000.0
        let norm = 300.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        let expected = 1.0
        let result = cost(path, augmentedWeights, norm)

        check abs(result - expected) <= Epsilon

#[
Test suite for the identification of edges affected by a swap.

It checks different swap configurations, including internal positions,
endpoints, and adjacent positions.
]#
suite "Affected edges":

    test "two internal non-adjacent positions":
        check affectedEdges(6, 1, 4) == @[0, 1, 3, 4]

    test "one endpoint and one internal position":
        check affectedEdges(5, 0, 3) == @[0, 2, 3]

    test "two endpoints":
        check affectedEdges(5, 0, 4) == @[0, 3]

    test "two adjacent internal positions":
        check affectedEdges(5, 1, 2) == @[0, 1, 2]

#[
Test suite for incremental cost evaluation.

It verifies that the incremental cost obtained after a swap matches the cost
computed by reevaluating the complete path for different swap configurations.
]#
suite "Incremental cost":

    test "matches full cost for two internal non-adjacent positions":
        let cities = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]
        var path = @[0, 1, 2, 3, 4]

        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ])
        )

        let maxDist = 100.0
        let norm = 300.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        let currentCost = cost(path, augmentedWeights, norm)

        swapPositions(path, 1, 3)

        let incremental = incrementalCost(path, currentCost, 1, 3, augmentedWeights, norm)
        let full = cost(path, augmentedWeights, norm)

        check abs(incremental - full) <= 0

    test "matches full cost for one endpoint and one internal position":
        let cities = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]
        var path = @[0, 1, 2, 3, 4]

        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ])
        )

        let maxDist = 100.0
        let norm = 300.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        let currentCost = cost(path, augmentedWeights, norm)

        swapPositions(path, 0, 3)

        let incremental = incrementalCost(path, currentCost, 0, 3, augmentedWeights, norm)
        let full = cost(path, augmentedWeights, norm)

        check abs(incremental - full) <= Epsilon

    test "matches full cost for two endpoints":
        let cities = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]
        var path = @[0, 1, 2, 3, 4]

        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ])
        )

        let maxDist = 100.0
        let norm = 300.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        let currentCost = cost(path, augmentedWeights, norm)

        swapPositions(path, 0, 4)

        let incremental = incrementalCost(path, currentCost, 0, 4, augmentedWeights, norm)
        let full = cost(path, augmentedWeights, norm)

        check abs(incremental - full) <= Epsilon

    test "matches full cost for adjacent internal positions":
        let cities = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]
        var path = @[0, 1, 2, 3, 4]

        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ])
        )

        let maxDist = 100.0
        let norm = 300.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        let currentCost = cost(path, augmentedWeights, norm)

        swapPositions(path, 1, 2)

        let incremental = incrementalCost(path, currentCost, 1, 2, augmentedWeights, norm)
        let full = cost(path, augmentedWeights, norm)

        check abs(incremental - full) <= Epsilon

    test "matches full cost for adjacent endpoint and internal position":
        let cities = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]
        var path = @[0, 1, 2, 3, 4]

        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ])
        )

        let maxDist = 100.0
        let norm = 300.0
        let augmentedWeights = buildAugmentedWeights(cities, graph, maxDist)

        let currentCost = cost(path, augmentedWeights, norm)

        swapPositions(path, 0, 1)

        let incremental = incrementalCost(path, currentCost, 0, 1, augmentedWeights, norm)
        let full = cost(path, augmentedWeights, norm)

        check abs(incremental - full) <= Epsilon