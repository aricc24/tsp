#[
Defines the configuration parameters used by the Threshold Acceptance heuristic.

The configuration includes the initial temperature, temperature search settings,
acceptance target, stopping tolerance, cooling factor, batch size, maximum
attempts per batch, and maximum number of batches for each temperature.
]#

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