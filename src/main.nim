import parseopt
import random
import strutils
import ./models/city
import ./persistence/database
import ./tsp/graph
import ./tsp/weights
import ./tsp/cost
import ./tsp/feasibility
import ./heuristics/threshold_acceptance/config
import ./persistence/instance_file
import ./runner/runner

type CliOptions = object
    databasePath: string
    instancePath: string
    runs: int
    seed: int


proc parseArguments(): CliOptions = 
    var parser = initOptParser()

    for kind, key, value in parser.getopt():
        case kind

        of cmdLongOption, cmdShortOption: 
            case key
            of "db", "d": 
                result.databasePath = value
            
            of "instance", "i": 
                result.instancePath = value
           
            of "runs", "r":
                result.runs = parseInt(value)
                
            of "seed", "s":
                result.seed = parseInt(value)
            
            else: 
                raise newException(ValueError, "Unknown flag" & key)

        of cmdArgument: 
            discard

        of cmdEnd: 
            discard

proc validateArguments(options: CliOptions) =
    if options.databasePath.len == 0:
        raise newException(
            ValueError,
            "Missing required option: --db"
        )

    if options.instancePath.len == 0:
        raise newException(
            ValueError,
            "Missing required option: --instance"
        )

proc main() =
    let options = parseArguments()
    validateArguments(options)

    let cities = getCities(options.databasePath)
    let connections = getConnections(options.databasePath)

    let graph = buildGraph(cities, connections)
    var solution = loadInstance(options.instancePath, cities)
    let maxDist = maximumDistance(solution, connections)
    let norm = normalizer(solution,graph)

    proc tspCost(path: seq[City]): float =
        cost(path, graph, maxDist, norm)

    let config = ThresholdConfig(
        initialTemperature: 1.0,
        epsilon: 0.0001,
        coolingFactor: 0.99,
        batchSize: 2000,
        maxAttempts: 10 * solution.len,
        maxBatchesPerTemperature: 200
    )


    let initialCost = tspCost(solution)

    let result = runMultiple(solution, config, options.runs, options.seed, tspCost)

    echo "Instance: ", options.instancePath
    echo "Runs:", options.runs
    echo "Base seed:", options.seed
    echo "Initial cost: ", initialCost
    echo "Best cost: ", result.bestCost
    echo "Best seed:", result.bestSeed
    echo "Feasible: ",
        if isFeasible(result.bestSolution, graph):
            "YES"
        else:
            "NO"
        
when isMainModule:
    main()