import persistence/database
import models/city
import tsp/distance
import tsp/weights

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