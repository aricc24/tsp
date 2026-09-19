#[
Provides the command-line entry point for the TSP solver.

This module parses and validates execution parameters, loads the database and
TSP instance, builds the graph and cost structures, configures the Threshold
Acceptance heuristic, executes multiple runs, and displays the best result.
]#

import parseopt
import strutils
import os

import ./persistence/database
import ./tsp/graph
import ./tsp/weights
import ./tsp/cost
import ./tsp/feasibility
import ./heuristics/threshold_acceptance/config
import ./persistence/instance_file
import ./runner/runner



#[
Stores the command-line options and heuristic parameters used during execution.
]#
type CliOptions = object
    databasePath: string
    instancePath: string
    runs: int
    seed: int
    processId: int

    initialTemperature: float
    searchTemperature*: bool
    targetAcceptance*: float
    epsilon: float
    coolingFactor: float
    batchSize: int
    maxAttempts: int
    maxBatchesPerTemperature: int


#[
Parses the command-line arguments and assigns default values to optional
execution and heuristic parameters.

Returns the resulting command-line configuration.
]#
proc parseArguments(): CliOptions = 
    result.runs = 100
    result.seed = 67
    result.processId = 0

    result.initialTemperature = 75000
    result.searchTemperature = false
    result.targetAcceptance = 0.90
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
            
            of "search-temperature":
                result.searchTemperature = parseBool(value)

            of "target-acceptance":
                result.targetAcceptance = parseFloat(value)

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

#[
Validates the required command-line options before starting the execution.
]#
proc validateArguments(options: CliOptions) =
    if options.databasePath.len == 0:
        raise newException(
            ValueError,
            "Missing required option: --db"
        )

    if not fileExists(options.databasePath):
        raise newException(
            ValueError,
            "Database file not found: " & options.databasePath
        )

    if options.instancePath.len == 0:
        raise newException(
            ValueError,
            "Missing required option: --instance"
        )

    if not fileExists(options.instancePath):
        raise newException(
            ValueError,
            "Instance file not found: " & options.instancePath
        )

    if options.runs <= 0:
        raise newException(
            ValueError,
            "Runs must be greater than zero"
        )

    if options.processId < 0:
        raise newException(
            ValueError,
            "Process ID cannot be negative"
        )

    if options.initialTemperature <= 0.0:
        raise newException(
            ValueError,
            "Initial temperature must be greater than zero"
        )

    if options.targetAcceptance <= 0.0 or
            options.targetAcceptance >= 1.0:
        raise newException(
            ValueError,
            "Target acceptance must be between 0 and 1"
        )

    if options.epsilon <= 0.0:
        raise newException(
            ValueError,
            "Epsilon must be greater than zero"
        )

    if options.coolingFactor <= 0.0 or
            options.coolingFactor >= 1.0:
        raise newException(
            ValueError,
            "Cooling factor must be between 0 and 1"
        )

    if options.batchSize <= 0:
        raise newException(
            ValueError,
            "Batch size must be greater than zero"
        )

    if options.maxAttempts <= 0:
        raise newException(
            ValueError,
            "Maximum attempts must be greater than zero"
        )

    if options.maxBatchesPerTemperature <= 0:
        raise newException(
            ValueError,
            "Maximum batches per temperature must be greater than zero"
        )



#[
Executes the complete TSP solving process.

It loads the problem data, constructs the required graph and weight structures,
configures the Threshold Acceptance heuristic, performs the requested runs,
and prints the best solution found.
]#
proc main() =
    let options = parseArguments()
    validateArguments(options)

    let cities = getCities(options.databasePath)
    let connections = getConnections(options.databasePath)

    let graph = buildGraph(cities, connections)
    let citySolution = loadInstance(options.instancePath, cities)
    let maxDist = maximumDistance(citySolution, connections)
    let augmentedWeights = buildAugmentedWeights(citySolution, graph, maxDist)
    let norm = normalizer(citySolution, graph)

    var solution = newSeq[int](citySolution.len)

    for i in 0 ..< citySolution.len:
        solution[i] = citySolution[i].id - 1

    proc tspCost(path: seq[int]): float =
        cost(path, augmentedWeights, norm)
    
    proc tspFeasible(path: seq[int]): bool =
        isFeasible(path, graph)

    proc tspNeighborCost(path: seq[int], currentCost: float, i: int, j: int): float =
            incrementalCost(path, currentCost, i, j, augmentedWeights, norm)

    let initialCost = tspCost(solution)

    let config = ThresholdConfig(
        initialTemperature: options.initialTemperature,
        searchTemperature: options.searchTemperature,
        targetAcceptance: options.targetAcceptance,
        epsilon: options.epsilon,
        coolingFactor: options.coolingFactor,
        batchSize: options.batchSize,
        maxAttempts: options.maxAttempts,
        maxBatchesPerTemperature: options.maxBatchesPerTemperature
    )



    let result = runMultiple(solution, config, options.runs, 
                 options.seed, options.processId, tspCost, tspFeasible, 
                 tspNeighborCost)


    var route = ""

    for i in 0 ..< result.bestSolution.len:
        if i > 0:
            route.add(",")
        if i > 0 and i mod 35 == 0:
            route.add("\n                ")

        route.add($(result.bestSolution[i] + 1))

    echo ""
    echo "========================================"
    echo " Process ", options.processId, " finished"
    echo "========================================"
    echo "Instance:         ", options.instancePath
    echo "Base seed:        ", options.seed
    echo "Initial cost:     ", initialCost
    echo "Best cost:        ", result.bestCost
    echo "Best seed:        ", result.bestSeed
    echo "Feasible runs:    ", result.feasibleRuns, "/", options.runs
    echo "Best solution:    ", route
    echo "Feasible:         ",
        if isFeasible(result.bestSolution, graph):
            "YES"
        else:
            "NO"
    echo "========================================"

when isMainModule:
    main()