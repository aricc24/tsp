#!/usr/bin/env bash

DB="$1"
INSTANCE="$2"
BASE_SEED="$3"
RUNS="$4"
JOBS="$5"

for ((i = 0; i < RUNS; i++)); do
    SEED=$((BASE_SEED + i))

    while (( $(jobs -r -p | wc -l) >= JOBS )); do
        wait -n
    done

    echo "Launching run $((i + 1))/$RUNS with seed $SEED"

    ./src/main \
        --db:"$DB" \
        --instance:"$INSTANCE" \
        --runs:1 \
        --seed:"$SEED" &
done

wait

echo "All runs finished."