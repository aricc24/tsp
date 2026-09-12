
type
  ThresholdConfig* = object
    initialTemperature*: float
    searchTemperature*: bool
    targetAcceptance*: float
    epsilon*: float
    coolingFactor*: float
    batchSize*: int
    maxAttempts*: int
    maxBatchesPerTemperature*: int