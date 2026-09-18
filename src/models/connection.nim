#[
Defines the data structure used to represent connections between cities.

Each connection stores the identifiers of the two connected cities and
the distance between them.
]#

type
    Connection* = object
        city1Id*: int
        city2Id*: int
        distance*: float