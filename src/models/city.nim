#[
Defines the data structure used to represent cities in the TSP problem.

Each city stores its identifier, descriptive information, population,
and geographic coordinates.
]#

type
  City* = object
    id*: int
    name*: string
    country*: string
    population*: int
    latitude*: float
    longitude*: float
