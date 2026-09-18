#[
Defines the data structure used to represent the graph of cities.

The graph stores the connections between cities using an adjacency matrix.
]#

import ./matrix

type 
    Graph* = object 
        adjacencyMatrix*: Matrix