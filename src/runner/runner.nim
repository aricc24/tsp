import std/random
import ../heuristics/threshold_acceptance/config
import ../heuristics/threshold_acceptance/threshold_acceptance

type 
    RunResult*[T] = object
        bestSolution*: seq[T]
        bestCost*: float
        bestSeed*: int
        feasibleRuns*: int

proc runMultiple*[T](initialSolution: seq[T],heuristicConfig: ThresholdConfig, runs: int, baseSeed: int, processId:int,
    costFunction: proc(solution: seq[T]): float,     feasibilityFunction: proc(solution: seq[T]): bool): RunResult[T] =

    var globalBestSolution = initialSolution[0 .. ^1]
    var globalBestCost = costFunction(initialSolution)
    var globalBestSeed = baseSeed
    var feasibleRuns = 0
    
    for runIndex in 0 ..< runs:
        let seed = baseSeed + runIndex

        var solution = initialSolution[0 .. ^1]
        var rng = initRand(seed)
        rng.shuffle(solution)

        let runResult = thresholdAcceptance(solution, heuristicConfig, rng, costFunction)
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
                        bestSeed: globalBestSeed
                    )