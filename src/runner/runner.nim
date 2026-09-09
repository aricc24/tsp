import std/random
import ../heuristics/threshold_acceptance/config
import ../heuristics/threshold_acceptance/threshold_acceptance

type 
    RunResult*[T] = object
        bestSolution*: seq[T]
        bestCost*: float
        bestSeed*: int

proc runMultiple*[T](initialSolution: seq[T],heuristicConfig: ThresholdConfig, runs: int, baseSeed: int, processId:int,
    costFunction: proc(solution: seq[T]): float): RunResult[T] =

    var globalBestSolution = initialSolution[0 .. ^1]
    var globalBestCost = costFunction(initialSolution)
    var globalBestSeed = baseSeed

    for runIndex in 0 ..< runs:
        let seed = baseSeed + runIndex

        var solution = initialSolution[0 .. ^1]
        var rng = initRand(seed)

        let runResult = thresholdAcceptance(solution, heuristicConfig, rng, costFunction)

        if runResult.bestCost < globalBestCost:
            globalBestCost = runResult.bestCost
            globalBestSolution = runResult.bestSolution[0 .. ^1]
            globalBestSeed = seed
        
        if (runIndex + 1) mod 5 == 0 or runIndex + 1 == runs:
                        echo "[Process ", processId, "] ",
                            runIndex + 1, "/", runs, 
                            " process seeds. Last Seed", seed

    return RunResult[T](bestSolution: globalBestSolution,
                        bestCost: globalBestCost,
                        bestSeed: globalBestSeed
                    )