# TSP — Threshold Acceptance

Implementation of the Traveling Salesman Problem (TSP) using the Threshold Acceptance metaheuristic in Nim.

## Requirements

* Nim 2.x
* Nimble
* SQLite
* `db_connector`

Project dependencies are declared in `tsp.nimble`.

## Project Structure

```text
tsp/
├── data/
│   ├── tsp.db
│   └── instances/
│       ├── input-40.tsp
│       └── input-150.tsp
│
├── src/
│   ├── main.nim
│   ├── models/
│   │   ├── city.nim
│   │   ├── connection.nim
│   │   └── graph.nim
│   ├── persistence/
│   │   └── database.nim
│   └── tsp/
│       ├── distance.nim
│       ├── graph.nim
│       ├── weights.nim
│       └── cost.nim
│
├── tests/
│   ├── test_distance.nim
│   ├── test_graph.nim
│   ├── test_weights.nim
│   ├── test_cost.nim
│   └── test_reference_instances.nim
│
├── .gitignore
├── README.md
└── tsp.nimble
```

## Architecture

The project separates its responsibilities into three main layers.

## Running

Run the program from the project root:

```bash
nimble run
```

Run the complete test suite:

```bash
nimble test
```

## Current Status

Now implemented:

* Database access
* Domain models
* Undirected graph representation
* Natural distance
* Maximum distance
* Augmented weight
* Normalizer
* Cost function
* Unit tests

