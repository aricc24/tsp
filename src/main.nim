import persistence/database
import models/city

let cities = getCities("data/tsp.db")

echo "no ciudades:", cities.len
echo "Primera ciudad", cities[0].name