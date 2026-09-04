import std/random
import ./batch
import ./config

proc thresholdAcceptance*[T](solution: var seq[T], config: ThresholdConfig, rng: var Rand, costFunction: proc(solution: seq[T]): float): 
       float = 
    
    var temperature = config.initialTemperature
    var currentAverage = 0.0

    while temperature > config.epsilon: 
        var previousAverage = Inf

        while currentAverage <= previousAverage: 
            previousAverage = currentAverage

            let batchResult = calculateBatch(
                solution, 
                temperature, 
                config, 
                rng,
                costFunction
            )

            currentAverage = batchResult.average
        
        temperature *= config.coolingFactor