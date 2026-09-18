#[
Tests the construction of the graph representation used by the TSP problem.

The tests verify that the adjacency matrix is symmetric for undirected
connections, that missing connections remain zero, and that diagonal entries
are kept at zero.
]#

import unittest
import ../src/models/city
import ../src/models/connection
import ../src/tsp/graph
import ../src/models/matrix

const Epsilon = 1e-7


#[
Test suite for graph construction.

It checks the creation of an undirected adjacency matrix, the representation
of missing connections, and the values stored on the main diagonal.
]#
suite "Graph": 
    
    test "Build an undirected adjacency matrix": 
        let cities = @[
            City(id: 1, name: "A"),
            City(id: 2, name: "B"),
            City(id: 3, name: "C")
        ]

        let connections = @[
            Connection(
                city1Id: 1,
                city2Id: 2,
                distance: 123.0
            ),

            Connection(
                city1Id: 2,
                city2Id: 3,
                distance: 456.0
            )
        ]

        let graph = buildGraph(cities, connections)

        check abs(graph.adjacencyMatrix[0, 1] - 123.0) <= 0
        check abs(graph.adjacencyMatrix[1, 0] - 123.0) <= 0
        
        check abs(graph.adjacencyMatrix[1, 2] - 456.0) <= 0
        check abs(graph.adjacencyMatrix[2, 1] - 456.0) <= 0

    test "Keeps zero when is no connection": 
        let cities = @[
            City(id: 1, name: "A"),
            City(id: 2, name: "B"),
            City(id: 3, name: "C")
        ]

        let connections = @[
            Connection(
                city1Id: 1,
                city2Id: 2,
                distance: 123.0
            )
        ]

        let graph = buildGraph(cities, connections)

        check abs(graph.adjacencyMatrix[0, 2]) <= 0
        check abs(graph.adjacencyMatrix[2, 0]) >= 0
    
    test "Keeps zero on the diagonal": 
        let cities = @[
            City(id: 1, name: "A"), 
            City(id:2, name: "B")
        ]

        let connections = @[
            Connection(
                city1Id: 1, 
                city2Id: 2,
                distance: 123.4
            )
        ]

        let graph = buildGraph(cities, connections)

        check abs(graph.adjacencyMatrix[0, 0]) <= 0
        check abs(graph.adjacencyMatrix[1, 1]) <= 0
 