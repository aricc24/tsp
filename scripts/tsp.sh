# Executes multiple runs of the TSP heuristic in parallel.
# The script loads the experiment parameters from the configuration file,
# distributes the total number of runs among the available processes,
# and assigns a different range of seeds to each process.
#
# Usage:
#   ./scripts/tsp.sh <instance>

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "$0 <instance>"
    exit 1
fi

INSTANCE="$1"
CONFIG="config/experiment.conf"

if [ ! -f "$CONFIG" ]; then
    echo "Configuration file not found: $CONFIG"
    exit 1
fi

source "$CONFIG"

RUNS_PER_PROCESS=$((TOTAL_RUNS / PROCESSES))
REMAINDER=$((TOTAL_RUNS % PROCESSES))

echo "Executing $TOTAL_RUNS runs in $PROCESSES processes"
echo

CURRENT_SEED=$BASE_SEED

for ((i=0; i<PROCESSES; i++)); do
    RUNS=$RUNS_PER_PROCESS

    if [ "$i" -lt "$REMAINDER" ]; then
        RUNS=$((RUNS + 1))
    fi

    ./src/main \
        --db:"$DB" \
        --instance:"$INSTANCE" \
        --runs:"$RUNS" \
        --seed:"$CURRENT_SEED" \
        --process:"$i" \
        --temperature:"$INITIAL_TEMPERATURE" \
        --search-temperature:"$SEARCH_TEMPERATURE" \
        --target-acceptance:"$TARGET_ACCEPTANCE" \
        --epsilon:"$EPSILON" \
        --cooling:"$COOLING_FACTOR" \
        --batch-size:"$BATCH_SIZE" \
        --max-attempts:"$MAX_ATTEMPTS" \
        --max-batches:"$MAX_BATCHES_PER_TEMPERATURE" &

    CURRENT_SEED=$((CURRENT_SEED + RUNS))
done

wait

echo
echo "Finished :)."