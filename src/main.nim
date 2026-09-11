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
import ./heuristics/threshold_acceptance/threshold_acceptance

type CliOptions = object
    databasePath: string
    instancePath: string
    runs: int
    seed: int
    processId: int

    initialTemperature: float
    epsilon: float
    coolingFactor: float
    batchSize: int
    maxAttempts: int
    maxBatchesPerTemperature: int



#./src/main   --db:data/tsp.db   --instance:data/instances/input-40.tsp   --runs:10000   --seed:2005

proc parseArguments(): CliOptions = 
    result.runs = 100
    result.seed = 67
    result.processId = 0

    result.initialTemperature = 75000
    result.epsilon = 0.00001
    result.coolingFactor = 0.9995
    result.batchSize = 4500
    result.maxAttempts = 75000
    result.maxBatchesPerTemperature = 3000

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
            
            of "process", "p":
                result.processId = parseInt(value)
            
            of "temperature":
                result.initialTemperature = parseFloat(value)

            of "epsilon":
                result.epsilon = parseFloat(value)

            of "cooling":
                result.coolingFactor = parseFloat(value)

            of "batch-size":
                result.batchSize = parseInt(value)

            of "max-attempts":
                result.maxAttempts = parseInt(value)

            of "max-batches":
                result.maxBatchesPerTemperature = parseInt(value)
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
    
    proc tspFeasible(path: seq[City]): bool =
        isFeasible(path, graph)


    let config = ThresholdConfig(
        initialTemperature: options.initialTemperature,
        epsilon: options.epsilon,
        coolingFactor: options.coolingFactor,
        batchSize: options.batchSize,
        maxAttempts: options.maxAttempts,
        maxBatchesPerTemperature: options.maxBatchesPerTemperature
    )


    let initialCost = tspCost(solution)
    
    #let result = thresholdAcceptance(solution, config, rng, tspCost)

    let result = runMultiple(solution, config, options.runs, options.seed, options.processId, tspCost, tspFeasible)

    #echo options.seed, ",", result.bestCost, ",", isFeasible(result.bestSolution, graph)

    echo "Process", options.processId, "finished" 
    echo "Instance: ", options.instancePath
    echo "Runs:", options.runs
    echo "Base seed:", options.seed
    echo "Initial cost: ", initialCost
    echo "Best cost: ", result.bestCost
    echo "Best seed:", result.bestSeed
    echo "Feasible runs: ", result.feasibleRuns, "/", options.runs
    echo "Feasible: ",
        if isFeasible(result.bestSolution, graph):
            "YES"
        else:
            "NO"
    
        
when isMainModule:
    main()