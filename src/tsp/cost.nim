#[
Provides cost evaluation utilities for TSP solutions.

This module computes normalized edge costs, evaluates complete paths, identifies
the edges affected by a swap, and updates the solution cost incrementally
without recalculating the entire path.
]#

import ../models/matrix

#[
Returns the normalized cost of an edge between two cities.
]#
proc edgeCost*(u: int, v: int, augmentedWeights: Matrix, norm: float): float =
    augmentedWeights[u, v] / norm

#[
Returns the indices of the path edges affected by swapping two positions.
]#
proc affectedEdges*(pathLen: int, i: int, j: int): seq[int] =
    var edges: seq[int] = @[]

    proc addEdge(index: int) =
        if index >= 0 and index < pathLen - 1 and index notin edges:
            edges.add(index)

    addEdge(i - 1)
    addEdge(i)
    addEdge(j - 1)
    addEdge(j)

    return edges

#[
Calculates the total normalized cost of a complete path.
]#
proc cost*(path: seq[int], augmentedWeights: Matrix, norm: float): float =
    var cost = 0.0

    for i in 1 ..< path.len: 
        let u = path[i - 1]
        let v = path[i]

        cost += edgeCost(u, v, augmentedWeights, norm)

    return cost

#[
Returns the city that occupied a given position before swapping positions i and j.
]#
proc swappedCity(path: seq[int], index: int, i: int, j: int): int =
    if index == i:
        return path[j]

    if index == j:
        return path[i]

    return path[index]

#[
Calculates the cost after a swap by updating only the affected edges.

The procedure subtracts the previous cost of the affected edges and adds
their new cost, avoiding a complete reevaluation of the path.
]#
proc incrementalCost*(path: seq[int], currentCost: float, i: int, j:int, 
        augmentedWeights:Matrix, norm: float): float = 
     
     var oldEdgesCost = 0.0
     var newEdgesCost = 0.0

     let edges = affectedEdges(path.len, i, j)

     for edge in edges: 
        let newU = path[edge]
        let newV = path[edge + 1]

        newEdgesCost += edgeCost(newU, newV, augmentedWeights, norm)

        let oldU = swappedCity(path, edge, i, j)
        let oldV = swappedCity(path, edge + 1, i, j)

        oldEdgesCost += edgeCost(oldU, oldV, augmentedWeights, norm)

     return currentCost - oldEdgesCost + newEdgesCost