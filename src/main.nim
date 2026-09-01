import persistence/database
import models/city
import tsp/distance
import tsp/weights
import tsp/graph

let cities = getCities("data/tsp.db")
let connections = getConnections("data/tsp.db")

echo "no ciudades:", cities.len
echo "Primera ciudad", cities[0].name

echo "no. conexiones", connections.len
echo "primera conexion:"
echo connections[0].city1Id
echo connections[0].city2Id
echo connections[0].distance

let dn = naturalDistance(cities[0], cities[1])
echo "Ciudad1", cities[0].name
echo "Ciudad2", cities[1].name
echo "dn", dn

let instance = cities[0 .. 9]
let maxDistance = maximumDistance(instance, connections)
echo "tamaño s: ", instance.len
echo "dist max: ", maxDistance

let graphi = buildGraph(cities, connections)

echo "d1", graphi.adjacencyMatrix[0][6]
echo "d2", graphi.adjacencyMatrix[6][0]
echo "d3", graphi.adjacencyMatrix[0][0]

let u = cities[0]
let v = cities[6]

let weight = augmentedWeight(u, v, graphi, maxDistance)
echo "aw: ", weight

let u1 = cities[0]  
let v1 = cities[1] 

let naturalDist = naturalDistance(u1, v1)
let expected = naturalDist * maxDistance
let result = augmentedWeight(u1, v1, graphi, maxDistance)

echo "dist nat: ", naturalDist
echo "idst max: ", maxDistance
echo "expected: ", expected
echo "aw: ", result
echo "diff: ", abs(result - expected)


let testInstance = @[cities[0],cities[6], cities[8]]

let a = testInstance[0].id - 1
let b = testInstance[1].id - 1
let c = testInstance[2].id - 1

echo "1-7: ", graphi.adjacencyMatrix[a][b]
echo "1-9: ", graphi.adjacencyMatrix[a][c]
echo "7-9: ", graphi.adjacencyMatrix[b][c]

let norm = normalizer(testInstance, graphi)

echo "norm: ", norm