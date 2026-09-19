# TSP — Threshold Acceptance

Implementation of the Traveling Salesman Problem (TSP) using the Threshold Acceptance metaheuristic in Nim.

## Requirements

* Nim 2.x
* Nimble
* SQLite
* `db_connector`
* Python 3
* Matplotlib

Project dependencies are declared in `tsp.nimble`.

## Installation

### 1. Install Nim

The recommended way to install Nim on Linux is using `choosenim`.

```bash
curl https://nim-lang.org/choosenim/init.sh -sSf | sh
```

After the installation, restart the terminal or add Nim to the current shell:

```bash
export PATH="$HOME/.nimble/bin:$PATH"
```

Verify the installation:

```bash
nim --version
nimble --version
```

The project requires Nim 2.2.10 or newer.

### 2. Install SQLite

On Fedora:

```bash
sudo dnf install sqlite sqlite-devel
```

Verify the installation:

```bash
sqlite3 --version
```

### 3. Clone the repository

```bash
git clone https://github.com/aricc24/tsp.git
cd tsp
```

### 4. Install project dependencies

Install the dependencies declared in `tsp.nimble`:

```bash
nimble install -d
```

If `db_connector` is not installed automatically, it can be installed with:

```bash
nimble install db_connector
```

### 5. Install Python plotting dependencies

The project includes a Python script for plotting the evaluations generated during an experiment.

Install Matplotlib with:

```bash
python3 -m pip install matplotlib
```

## Project Structure

```text
tsp/
├── config/
│   └── experiment.conf
├── data/
│   ├── tsp.db
│   └── instances/
│       ├── input-40.tsp
│       └── input-150.tsp
├── scripts/
│   └── tsp.sh
├── src/
│   ├── main.nim
│   ├── models/
│   │   ├── city.nim
│   │   ├── connection.nim
│   │   ├── graph.nim
│   │   └── matrix.nim
│   ├── persistence/
│   │   ├── database.nim
│   │   └── instance_file.nim
│   ├── tsp/
│   │   ├── distance.nim
│   │   ├── graph.nim
│   │   ├── weights.nim
│   │   ├── cost.nim
│   │   └── feasibility.nim
│   ├── heuristics/
│   │   └── threshold_acceptance/
│   │       ├── config.nim
│   │       ├── neighbor.nim
│   │       ├── batch.nim
│   │       ├── initial_temperature.nim
│   │       └── threshold_acceptance.nim
│   └── runner/
│       └── runner.nim
├── tests/
├── plot.py
├── .gitignore
├── README.md
└── tsp.nimble
```

## Architecture

The project separates its responsibilities into three main layers.

## Configuration

Experiments are configured in:

```text
config/experiment.conf
```

Example:

```conf
DB=data/tsp.db
BASE_SEED=231231231223124311
TOTAL_RUNS=25
PROCESSES=4
INITIAL_TEMPERATURE=77000
SEARCH_TEMPERATURE=true
TARGET_ACCEPTANCE=0.90
EPSILON=0.00001
COOLING_FACTOR=0.9995
BATCH_SIZE=4500
MAX_ATTEMPTS=44000
MAX_BATCHES_PER_TEMPERATURE=50
```

When:

```conf
SEARCH_TEMPERATURE=false
```

`INITIAL_TEMPERATURE` is used directly by Threshold Acceptance.

When:

```conf
SEARCH_TEMPERATURE=true
```

`INITIAL_TEMPERATURE` is used as the initial value for the automatic temperature search. The algorithm searches for a temperature whose neighbor acceptance rate is close to `TARGET_ACCEPTANCE`.

## Compilation

Compile the program from the project root:

```bash
nim c -d:release src/main.nim
```

The executable will be generated as:

```text
src/main
```

## Running

The recommended way to run an experiment is through the provided script.

First, make sure it has execution permissions:

```bash
chmod +x scripts/tsp.sh
```

Then run:

```bash
./scripts/tsp.sh data/instances/input-150.tsp
```

The script reads the parameters from:

```text
config/experiment.conf
```

and distributes the requested runs among the configured number of processes.

### Running directly

The executable can also be invoked directly:

```bash
./src/main \
    --db:data/tsp.db \
    --instance:data/instances/input-150.tsp \
    --runs:1 \
    --seed:67 \
    --temperature:77000 \
    --search-temperature:true \
    --target-acceptance:0.90 \
    --epsilon:0.00001 \
    --cooling:0.9995 \
    --batch-size:4500 \
    --max-attempts:44000 \
    --max-batches:50
```

## Evaluation Logging

The program can generate an `evaluations.txt` file while running an experiment.

This file stores the evaluations of the solutions that are accepted by the Threshold Acceptance heuristic during the search process.

The generated data can be used to inspect how the objective function changes throughout the execution and to analyze the behavior of the heuristic.

The file is generated as:

```text
evaluations.txt
```

Each stored value corresponds to an accepted evaluation during the execution of the algorithm.

Because this file can become very large during long experiments, it should normally not be committed to the repository.

It is recommended to include it in `.gitignore`:

```gitignore
evaluations.txt
```

## Plotting the Evaluations

The project includes the Python script:

```text
plot.py
```

This script reads the evaluations stored in:

```text
evaluations.txt
```

and generates a graph that can be used to inspect the behavior of the Threshold Acceptance heuristic throughout the experiment.

After generating `evaluations.txt`, run:

```bash
python3 plot.py
```

The resulting graph allows the evolution of the accepted evaluations to be visualized, making it easier to observe how the heuristic explores the solution space and how the cost changes during the execution.

This visualization is mainly intended for experimental analysis and for studying the convergence behavior of the heuristic.

## Tests

Run the complete test suite with:

```bash
nimble test
```

Individual tests can also be compiled and executed directly. For example:

```bash
nim c -r tests/test_cost.nim
```

## Author

**Ariadna García**
