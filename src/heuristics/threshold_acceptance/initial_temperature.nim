import std/random
import ./neighbor

const TemperatureTolerance* = 1e-6
const AcceptanceTolerance* = 0.01


proc calculateAcceptanceRate*[T](
        solution: var seq[T], currentCost: float, temperature: float, sampleSize: int, rng: var Rand, 
                neighborCostFunction: proc(solution: seq[T], currentCost: float, i: int, j: int): float):
                        tuple[rate: float, currentCost: float] =

    var currentCost = currentCost
    var accepted = 0

    for _ in 0 ..< sampleSize:
        let move = neighbor(solution, rng)
        let neighborCost = neighborCostFunction(solution, currentCost, move.i, move.j)

        if neighborCost <= currentCost + temperature:
            currentCost = neighborCost
            inc accepted
        else:
            swapPositions(solution, move.i, move.j)

    return (rate: float(accepted)/float(sampleSize), currentCost: currentCost)


proc binarySearchTemperature*[T](
        solution: var seq[T], currentCost: float, lower: float, upper: float, targetAcceptance: float, 
            sampleSize: int, rng: var Rand, 
                neighborCostFunction: proc(solution: seq[T], currentCost: float, i: int, j: int): float): 
                    tuple[temperature: float, currentCost: float] =

    var currentCost = currentCost
    var lower = lower
    var upper = upper

    while upper - lower > TemperatureTolerance:
        let middle = (lower + upper)/2.0

        let acceptanceResult = calculateAcceptanceRate(solution, currentCost, middle, sampleSize, 
                                    rng, neighborCostFunction)

        currentCost = acceptanceResult.currentCost
        let acceptanceRate = acceptanceResult.rate

        if abs(targetAcceptance - acceptanceRate) <= AcceptanceTolerance:
            return (temperature: middle, currentCost: currentCost)

        if acceptanceRate > targetAcceptance:
            upper = middle
        else:
            lower = middle

    return (temperature: (lower + upper)/2.0, currentCost: currentCost)


proc initialTemperature*[T](
        solution: var seq[T], costFunction: proc(solution: seq[T]): float, initialGuess: float,
            targetAcceptance: float, sampleSize: int, rng: var Rand, 
                neighborCostFunction: proc(solution: seq[T], currentCost: float, i: int, j: int): float): 
                        tuple[temperature: float, currentCost: float] =

    var t = initialGuess
    var currentCost = costFunction(solution)     

    var sample = calculateAcceptanceRate(solution, currentCost, t, sampleSize, rng, neighborCostFunction)

    if abs(targetAcceptance - sample.rate) <= AcceptanceTolerance:
        return (temperature: t, currentCost: sample.currentCost)

    var lower, upper: float

    if sample.rate < targetAcceptance:
        while sample.rate < targetAcceptance:
            t *= 2.0
            sample = calculateAcceptanceRate(solution, sample.currentCost, t, 
                            sampleSize, rng, neighborCostFunction)
        lower = t/2.0
        upper = t
    else:
        while sample.rate > targetAcceptance:
            t /= 2.0
            sample = calculateAcceptanceRate(solution, sample.currentCost, t, 
                                sampleSize, rng, neighborCostFunction)
        lower = t
        upper = t * 2.0

    let final = binarySearchTemperature(solution, sample.currentCost, lower, upper, 
                    targetAcceptance, sampleSize, rng, neighborCostFunction)

    return (temperature: final.temperature, currentCost: final.currentCost)