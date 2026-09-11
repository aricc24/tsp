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

    echo "Launching process $i:"
    echo "  Runs: $RUNS"
    echo "  Base seed: $CURRENT_SEED"
    echo

    ./src/main \
        --db:"$DB" \
        --instance:"$INSTANCE" \
        --runs:"$RUNS" \
        --seed:"$CURRENT_SEED" \
        --process:"$i" &

    CURRENT_SEED=$((CURRENT_SEED + RUNS))
done

wait

echo
echo "Finished :)."