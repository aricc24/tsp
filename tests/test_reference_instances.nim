import std/[unittest, strutils]

import ../src/models/city
import ../src/persistence/database
import ../src/tsp/graph
import ../src/tsp/weights
import ../src/tsp/cost

const Epsilon = 1e-6
const DatabasePath = "data/tsp.db"


proc loadInstance(path: string, cities: seq[City]): seq[City] =
  let content = readFile(path).strip()
  let values = content.split(",")
  result = newSeq[City](values.len)

  for i in 0 ..< values.len:
    let cityId = parseInt(values[i].strip())
    result[i] = cities[cityId - 1]


let cities = getCities(DatabasePath)
let connections = getConnections(DatabasePath)
let graphi = buildGraph(cities, connections)


suite "Reference instances":

  test "input-40 matches results":
    let instance = loadInstance("data/instances/input-40.tsp",cities)
    let maxDist = maximumDistance(instance,connections)
    let norm = normalizer(instance,graphi)

    let evaluation = cost(instance,graphi,maxDist,norm)

    let refMaxDist = 4970123.960000000
    let refNorm = 181500915.920000017
    let refEvaluation = 4037072.073965357
    
    #[
    echo "\ninput-40:"
    echo "Maximum:"
    echo "mine:", maxDist
    echo "ref:",refMaxDist
    echo "diff:", abs(maxDist - refMaxDist)
    
    echo "Normalizer:"
    echo "mine:", norm
    echo "ref:", refNorm
    echo "diff:", abs(norm - refNorm)
    
    echo "Evaluation:"
    echo "mine:", evaluation
    echo "ref:", refEvaluation
    echo  "diff", abs(evaluation - refEvaluation)
    ]#

    check abs(maxDist - 4970123.960000000) <= Epsilon
    check abs(norm - 181500915.920000017) <= Epsilon
    check abs(evaluation - 4037072.073965357) <= Epsilon
    


  test "input-150 matches results":
    let instance = loadInstance("data/instances/input-150.tsp", cities)
    let maxDist = maximumDistance(instance, connections)
    let norm = normalizer(instance, graphi)

    let evaluation = cost(instance, graphi, maxDist, norm)

    let refMaxDist = 4978506.480000000
    let refNorm = 722598785.020000100
    let refEvaluation = 6092371.483582111

    #[
    echo "\ninput-150:"
    echo "Maximum:"
    echo "mine:", maxDist
    echo "ref:",refMaxDist
    echo "diff:", abs(maxDist - refMaxDist)
    
    echo "Normalizer:"
    echo "mine:", norm
    echo "ref:", refNorm
    echo "diff:", abs(norm - refNorm)
    
    echo "Evaluation:"
    echo "mine:", evaluation
    echo "ref:", refEvaluation
    echo  "diff", abs(evaluation - refEvaluation)
    ]#

    check abs(maxDist - 4978506.480000000) <= Epsilon
    check abs(norm - 722598785.020000100) <= Epsilon
    check abs(evaluation - 6092371.483582111) <= Epsilon
