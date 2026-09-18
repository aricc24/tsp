#[
Provides utilities for executing multiple independent runs of the
Threshold Acceptance heuristic.

This module manages random seeds, initializes each run, tracks the best
solution found across all executions, and counts how many runs produce
feasible solutions.
]#


import std/random
import ../heuristics/threshold_acceptance/config
import ../heuristics/threshold_acceptance/threshold_acceptance


#[
Stores the result of multiple heuristic executions, including the best
solution, its cost, the seed that produced it, and the number of
feasible runs.
]#
type 
    RunResult*[T] = object
        bestSolution*: seq[T]
        bestCost*: float
        bestSeed*: int
        feasibleRuns*: int

#[
Executes the Threshold Acceptance heuristic multiple times using consecutive
random seeds.

Each run starts from a shuffled copy of the initial solution. The procedure
tracks the best solution found, its corresponding seed, and the total number
of feasible runs.

Returns the aggregated result of all executions.
]#
proc runMultiple*[T](
        initialSolution: seq[T],heuristicConfig: ThresholdConfig, 
        runs: int, baseSeed: int, processId:int, 
        costFunction: proc(solution: seq[T]): float,
        feasibilityFunction: proc(solution: seq[T]): bool,         
        neighborCostFunction: proc(solution: seq[T], currentCost: float, i: int, j: int): float
        ): 
            RunResult[T] =

    var globalBestSolution = initialSolution[0 .. ^1]
    var globalBestCost = costFunction(initialSolution)
    var globalBestSeed = baseSeed
    var feasibleRuns = 0
    
    for runIndex in 0 ..< runs:
        let seed = baseSeed + runIndex

        var solution = initialSolution[0 .. ^1]
        var rng = initRand(seed)
        rng.shuffle(solution)

        let runResult = thresholdAcceptance(solution, heuristicConfig, rng, 
                        costFunction, neighborCostFunction)
        let runIsFeasible = feasibilityFunction(runResult.bestSolution)

        if runIsFeasible: 
            inc feasibleRuns

        if runResult.bestCost < globalBestCost:
            globalBestCost = runResult.bestCost
            globalBestSolution = runResult.bestSolution[0 .. ^1]
            globalBestSeed = seed

            echo "[Process ", processId, "] ",
                "New best: ", globalBestCost,
                " | Seed: ", globalBestSeed,
                " | Feasible runs: ", feasibleRuns, "/", runIndex + 1,
                " | Run: ", runIndex + 1, "/", runs,
                " | Is feasible: ",
                if runIsFeasible:
                    "YES"
                else:
                    "NO"


    return RunResult[T](bestSolution: globalBestSolution,
                        bestCost: globalBestCost,
                        bestSeed: globalBestSeed, 
                        feasibleRuns: feasibleRuns
                    )