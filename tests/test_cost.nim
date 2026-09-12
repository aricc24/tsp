import unittest
import ../src/models/city
import ../src/models/graph
import ../src/tsp/cost
import ../src/tsp/distance
import ../src/heuristics/threshold_acceptance/neighbor

const Epsilon = 1e-7

suite "Cost": 

    test "Compute cost using existing connections": 
        let path = @[
            City(id:1), 
            City(id:2), 
            City(id:3)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 100.0, 0.0],
                @[100.0, 0.0, 200.0],
                @[0.0, 200.0, 0.0]
            ]
        )

        let maxDist = 200.0
        let norm = 300.0

        let result = cost(path, graph, maxDist, norm)
        let expected = 1.0

        check abs(result - expected) <= Epsilon

    test "Uses augmented weight for missimg conections": 
        let path = @[
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

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 0.0], 
                @[0.0, 0.0]
            ]        
        )

        let maxDist = 2.0
        let norm = 10.0

        let expected = (naturalDistance(path[0], path[1]) * maxDist) / norm
        let result = cost(path, graph, maxDist, norm)
        check abs(result - expected) <= 0
    
    test "Does not add an edge from last city back to fist": 
        let path = @[
            City(id:1),
            City(id:2), 
            City(id:3)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 100.0, 1000.0],
                @[100.0, 0.0, 200.0],
                @[1000.0, 200.0, 0.0]
            ]
        )
        
        let maxDist = 1000.0
        let norm = 300.0

        let expected = 1.0
        let result = cost(path, graph, maxDist, norm)

        check abs(result - expected) <= Epsilon

suite "Affected edges":

    test "two internal non-adjacent positions":
        check affectedEdges(6, 1, 4) == @[0, 1, 3, 4]

    test "one endpoint and one internal position":
        check affectedEdges(5, 0, 3) == @[0, 2, 3]

    test "two endpoints":
        check affectedEdges(5, 0, 4) == @[0, 3]

    test "two adjacent internal positions":
        check affectedEdges(5, 1, 2) == @[0, 1, 2]

suite "Incremental cost":

    test "matches full cost for two internal non-adjacent positions":
        var path = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ]
        )

        let maxDist = 100.0
        let norm = 300.0

        let currentCost = cost(path, graph, maxDist, norm)

        swapPositions(path, 1, 3)

        let incremental = incrementalCost(path, currentCost, 1, 3, graph, maxDist, norm)
        let full = cost(path, graph, maxDist, norm)

        check abs(incremental - full) <= 0

    test "matches full cost for one endpoint and one internal position":
        var path = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ]
        )

        let maxDist = 100.0
        let norm = 300.0

        let currentCost = cost(path, graph, maxDist, norm)

        swapPositions(path, 0, 3)

        let incremental = incrementalCost(path, currentCost, 0, 3, graph, maxDist, norm)
        let full = cost(path, graph, maxDist, norm)

        check abs(incremental - full) <= Epsilon

    test "matches full cost for two endpoints":
        var path = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ]
        )

        let maxDist = 100.0
        let norm = 300.0

        let currentCost = cost(path, graph, maxDist, norm)

        swapPositions(path, 0, 4)

        let incremental = incrementalCost(path, currentCost, 0, 4, graph, maxDist, norm)
        let full = cost(path, graph, maxDist, norm)

        check abs(incremental - full) <= Epsilon

    test "matches full cost for adjacent internal positions":
        var path = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ]
        )

        let maxDist = 100.0
        let norm = 300.0

        let currentCost = cost(path, graph, maxDist, norm)

        swapPositions(path, 1, 2)

        let incremental = incrementalCost(path, currentCost, 1, 2, graph, maxDist, norm)
        let full = cost(path, graph, maxDist, norm)

        check abs(incremental - full) <= Epsilon

    test "matches full cost for adjacent endpoint and internal position":
        var path = @[
            City(id: 1),
            City(id: 2),
            City(id: 3),
            City(id: 4),
            City(id: 5)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 20.0, 30.0, 40.0],
                @[10.0, 0.0, 50.0, 60.0, 70.0],
                @[20.0, 50.0, 0.0, 80.0, 90.0],
                @[30.0, 60.0, 80.0, 0.0, 100.0],
                @[40.0, 70.0, 90.0, 100.0, 0.0]
            ]
        )

        let maxDist = 100.0
        let norm = 300.0

        let currentCost = cost(path, graph, maxDist, norm)

        swapPositions(path, 0, 1)

        let incremental = incrementalCost(path, currentCost, 0, 1, graph, maxDist, norm)
        let full = cost(path, graph, maxDist, norm)

        check abs(incremental - full) <= Epsilon

