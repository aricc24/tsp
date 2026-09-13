import std/sets
import ../models/city
import ../models/connection
import ../models/graph
import ./distance
import std/algorithm

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

proc augmentedWeight*(u: City, v:City, graph: Graph, maxDist: float): float =
    
    let i = u.id - 1
    let j = v.id - 1

    let weight = graph. adjacencyMatrix[i][j]

    if weight > 0.0: 
        return weight

    return naturalDistance(u, v) * maxDist

proc normalizer*(cities: seq[City], graph: Graph): float =
    var weights: seq[float] = @[]

    for i in 0 ..< cities.len: 
        for j in i + 1 ..< cities.len: 

            let u = cities[i].id - 1
            let v = cities[j].id - 1

            let weight = graph.adjacencyMatrix[u][v]

            if weight > 0.0:
                weights.add(weight)

    weights.sort(SortOrder.Descending)

    let numbersOfEdges = cities.len - 1

    var norm = 0.0

    for i in 0 ..< numbersOfEdges: 
        norm += weights[i]

    return norm

proc buildAugmentedWeights*(cities: seq[City], graph: Graph, maxDist: float):
            seq[seq[float]] =


    let n = graph. adjacencyMatrix.len
    result = newSeq[seq[float]](n)

    for i in 0 ..< n: 
        result[i] = newSeq[float](n)

    for i in 0 ..< cities.len:
        for j in i + 1 ..< cities.len: 

            let u = cities[i]
            let v = cities[j]

            let uIndex = u.id - 1
            let vIndex = v.id - 1

            let weight = graph.adjacencyMatrix[uIndex][vIndex]

            let value = 
                if weight > 0.0: 
                    weight
                else: 
                    naturalDistance(u, v) * maxDist

            result[uIndex][vIndex] = value
            result[vIndex][uIndex] = value 
    
            
