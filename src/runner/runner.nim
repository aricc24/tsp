import std/random
import ../heuristics/threshold_acceptance/config
import ../heuristics/threshold_acceptance/threshold_acceptance

type 
    RunResult*[T] = object
        bestSolution*: seq[T]
        bestCost*: float
        bestSeed*: int

proc runMultiple*[T](initialSolution: seq[T],heuristicConfig: ThresholdConfig, runs: int, baseSeed: int,
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

    return RunResult[T](bestSolution: globalBestSolution,
                        bestCost: globalBestCost,
                        bestSeed: globalBestSeed
                    )