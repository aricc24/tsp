#[
Provides graph construction utilities for the TSP problem.

This module builds an undirected weighted graph from the collection of cities
and their connections, storing the distances in an adjacency matrix.
]#

import ../models/city
import ../models/connection
import ../models/graph
import ../models/matrix

#[
Builds an undirected weighted graph using the given cities and connections.

Each connection is stored in both directions of the adjacency matrix using
its associated distance.

Returns the resulting graph.
]#
proc buildGraph*(cities: seq[City], connections: seq[Connection]) : Graph =
    let n = cities.len
    var matrix = newMatrix(n)

    for connection in connections: 
        let i = connection.city1Id - 1
        let j = connection.city2Id - 1

        matrix[i, j] = connection.distance
        matrix[j, i] = connection.distance

    return Graph(
        adjacencyMatrix: matrix
    )


