import ../models/city
import ../models/connection
import ../models/graph
import ./distance

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

