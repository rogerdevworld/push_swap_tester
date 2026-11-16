#!/bin/bash

# Colors
WHITE='\033[1;37m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Tester for multiple cases and to generate the average
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: sh $0 <range> <moves_threshold> [number_of_cases]"
    exit 1
fi

RANGE=$1
THRESHOLD=$2
CASES=${3:-10000}  # If not provided, the default value is 10,000
SUM=0
ATTEMPTS=0
POINTS=0
MIN=2147483647
MAX=0

for ((i = 1; i <= CASES; i++)); do
    rm -f test.txt checker.txt

    # Generate random numbers with a unique seed in each iteration
    ARG=$(awk -v n="$RANGE" 'BEGIN { srand(); for (j = 0; j < n; j++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')

    ../push_swap $ARG > test.txt
    ../push_swap $ARG | ./checker $ARG > checker.txt

    VAR=$(wc -l < test.txt)
    SUM=$((SUM + VAR))
    ATTEMPTS=$((ATTEMPTS + 1))

    # Update minimum and maximum
    if [ "$VAR" -lt "$MIN" ]; then
        MIN=$VAR
    fi
    if [ "$VAR" -gt "$MAX" ]; then
        MAX=$VAR
    fi

    AVERAGE=$((SUM / ATTEMPTS))
    LAST_LINE=$(tail -n 1 checker.txt)
    
    # MODIFICADO: Ahora el [OK] muestra solo el movimiento y la media, sin imprimir $ARG
    if [ "$VAR" -le "$THRESHOLD" ] && [ "$LAST_LINE" = "OK" ]; then
        echo -e "${GREEN}[OK] $VAR (Average: $AVERAGE)${NC}"
        POINTS=$((POINTS + 1))
    else
        # Si falla (KO), mantiene $ARG visible para que puedas depurarlo
        echo -e "${RED}[KO] $VAR (Average: $AVERAGE)${NC} $ARG"
    fi
done

# Show final results
echo -e "\n${WHITE}Summary for range $RANGE:${NC}"
echo -e "${WHITE}Minimum: ${GREEN}$MIN${NC} | Maximum: ${GREEN}$MAX${NC} | Average: ${GREEN}$AVERAGE${NC} | Points: ${GREEN}$POINTS/$CASES${NC}"