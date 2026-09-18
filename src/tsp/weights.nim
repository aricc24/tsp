#[
Provides weight-related utilities for the TSP problem.

This module computes the maximum existing distance, assigns augmented weights
to missing connections, calculates the normalization factor, and builds the
augmented weight matrix used to evaluate TSP solutions.
]#

import std/sets
import ../models/city
import ../models/connection
import ../models/graph
import ./distance
import ../models/matrix
import std/algorithm

#[
Finds the maximum distance among the connections whose cities belong to
the given TSP instance.
]#
proc maximumDistance*(cities: seq[City], connections: seq[Connection]): float =

    var cityIds = initHashSet[int]()

    for city in cities: 
        cityIds.incl(city.id)

    var maximum = 0.0
    for connection in connections:
        if connection.city1Id in cityIds and
            connection.city2Id in cityIds:

            if connection.distance > maximum: 
                maximum = connection.distance

    return maximum

#[
Returns the weight between two cities.

If the connection exists in the original graph, its stored distance is used.
Otherwise, an augmented weight is computed from the natural distance and
the maximum distance of the instance.
]#
proc augmentedWeight*(u: City, v:City, graph: Graph, maxDist: float): float =
    
    let i = u.id - 1
    let j = v.id - 1

    let weight = graph.adjacencyMatrix[i, j]

    if weight > 0.0: 
        return weight

    return naturalDistance(u, v) * maxDist


#[
Calculates the normalization factor for a TSP instance.

The normalizer is obtained by summing the largest existing edge weights
required by the instance.
]#
proc normalizer*(cities: seq[City], graph: Graph): float =
    var weights: seq[float] = @[]

    for i in 0 ..< cities.len: 
        for j in i + 1 ..< cities.len: 

            let u = cities[i].id - 1
            let v = cities[j].id - 1

            let weight = graph.adjacencyMatrix[u, v]

            if weight > 0.0:
                weights.add(weight)

    weights.sort(SortOrder.Descending)

    let numbersOfEdges = cities.len - 1

    var norm = 0.0

    for i in 0 ..< numbersOfEdges: 
        norm += weights[i]

    return norm

#[
Builds the augmented weight matrix for the cities in a TSP instance.

Existing connections keep their original weights, while missing connections
receive a weight based on their natural distance and the maximum distance.
]#
proc buildAugmentedWeights*(cities: seq[City], graph: Graph, maxDist: float):
            Matrix =


    let n = graph.adjacencyMatrix.n
    result = newMatrix(n)

    for i in 0 ..< cities.len:
        for j in i + 1 ..< cities.len: 

            let u = cities[i]
            let v = cities[j]

            let uIndex = u.id - 1
            let vIndex = v.id - 1

            let weight = graph.adjacencyMatrix[uIndex, vIndex]

            let value = 
                if weight > 0.0: 
                    weight
                else: 
                    naturalDistance(u, v) * maxDist

            result[uIndex, vIndex] = value
            result[vIndex, uIndex] = value 
    
            
