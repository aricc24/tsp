set -e

if [ "$#" -ne 5 ]; then
    echo "Uso:"
    echo "$0 <db> <instance> <base_seed> <total_runs> <processes>"
    exit 1
fi

DB="$1"
INSTANCE="$2"
BASE_SEED="$3"
TOTAL_RUNS="$4"
PROCESSES="$5"

RUNS_PER_PROCESS=$((TOTAL_RUNS / PROCESSES))
REMAINDER=$((TOTAL_RUNS % PROCESSES))

echo "Executing $TOTAL_RUNS runs $PROCESSES proccess"
echo

CURRENT_SEED=$BASE_SEED

for ((i=0; i<PROCESSES; i++)); do
    RUNS=$RUNS_PER_PROCESS

    if [ "$i" -lt "$REMAINDER" ]; then
        RUNS=$((RUNS + 1))
    fi

    echo "Lunching process $i:"
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