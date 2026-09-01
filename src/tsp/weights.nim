import ../models/city
import ../models/connection
import ../models/graph
import ./distance
import std/algorithm

#de momento
proc containsCity(cities: seq[City], cityId: int): bool =
    for city in cities: 
        if city.id == cityId: 
            return true
    return false

proc maximumDistance*(cities: seq[City], connections: seq[Connection]): float =
    var maximum = 0.0
    for connection in connections:
        if containsCity(cities, connection.city1Id) and containsCity(cities, connection.city2Id): 

            if connection. distance > maximum: 
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
            
