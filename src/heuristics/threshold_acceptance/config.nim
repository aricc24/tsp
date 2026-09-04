
type
  ThresholdConfig* = object
    initialTemperature*: float
    epsilon*: float
    coolingFactor*: float
    batchSize*: int
    maxAttempts*: int