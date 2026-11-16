#!/bin/bash

# Push_swap tester made for students of 42 by students of 42Barcelona, by rmarrero

cd ..
make re
./push_swap > /dev/null 2>&1
cd ./push_swap_tester
clear

# Assign the number of attempts from the first argument (default: 100)
NUM_ATTEMPTS=${1:-100}

# Title
show_title() {
    echo -e "\033[1;36m"
    echo "  _____    ____ "
    echo " |  __ \  / ____|"
    echo " | |__) | | (___  "
    echo " |  ___/   \___ \ "
    echo " | |       ____) | "
    echo " |_|      |_____/  Tester"
    echo -e "\033[0m"
    echo -e "\033[1;35m Project: Push Swap, by: rmarrero \033[0m"
    echo
}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Spinner frames array
SPINNER=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

# Function to show a loading animation with colors for tests
show_loading() {
    while true; do
        for c in "${SPINNER[@]}"; do
            echo -ne "\r${CYAN}$c${NC} Processing... "
            sleep 0.1
        done
    done
}

# Function to safely stop loading animation
stop_loading() {
    if [ ! -z "$1" ]; then
        kill "$1" 2>/dev/null
        wait "$1" 2>/dev/null
    fi
    echo -ne "\r\033[K"
}

# Function to show a celebration animation with colors
show_celebration() {
    echo -e "\n${MAGENTA}🎉 Process completed! 🎉${NC}"
    for idx in {1..5}; do
        echo -ne "\r${YELLOW}✨✨✨✨✨${NC}"
        sleep 0.2
        echo -ne "\r    ${YELLOW}✨✨✨✨${NC}"
        sleep 0.2
        echo -ne "\r      ${YELLOW}✨✨✨${NC}"
        sleep 0.2
        echo -ne "\r        ${YELLOW}✨✨${NC}"
        sleep 0.2
        echo -ne "\r          ${YELLOW}✨${NC}"
        sleep 0.2
    done
    echo -e "\r${GREEN}✅ All done! ✅${NC}"
}

# Initial base score
BASE=80

# Thresholds
THRESHOLD_3=2
THRESHOLD_5=12

# Show title
show_title

# ==========================================
# 0. Test loop from 1 to 500 random arguments (Animated & [OK] info)
# ==========================================
echo "--- Evaluating incremental random sizes (1 to 500) ---"

for ((i = 1; i <= 500; i++)); do
    rm -f test.txt checker.txt

    # Selecciona el icono dinámico según el índice 'i' para que rote de verdad
    SPIN_CHAR="${SPINNER[$((i % ${#SPINNER[@]}))]}"
    echo -ne "\r${CYAN}$SPIN_CHAR${NC} Testing size: ${WHITE}$i/500${NC}\r"

    ARG=$(awk -v n="$i" -v seed="$i" 'BEGIN { srand(seed); for (j = 0; j < n; j++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')

    ../push_swap $ARG > test.txt
    ../push_swap $ARG | ./checker $ARG > checker.txt
    
    VAR=$(wc -l < test.txt)
    LAST_LINE=$(tail -n 1 checker.txt)
    
    if [ "$LAST_LINE" != "OK" ]; then
        echo -ne "\033[2K\r"
        echo -e "${RED}[KO] Size $i failed! Mov: ${WHITE}$VAR${NC} | Arg: $ARG"
        exit 1
    fi
done

echo -ne "\033[2K\r"
echo -e "${GREEN}✅ [OK] Incremental tests (1 to 500) passed successfully!${NC}\n"

# ==========================================
# 1. Evaluate cases of 3 numbers
# ==========================================
echo "--- Evaluating $NUM_ATTEMPTS cases of 3 numbers ---"
MIN_3=1000000
MAX_3=0
SUM_3=0

show_loading &
LOADING_PID_3=$!

for ((i = 1; i <= NUM_ATTEMPTS; i++)); do
    ARG=$(awk -v n="3" -v seed="$i" 'BEGIN { srand(seed); for (j = 0; j < n; j++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')
    
    MOVES=$(../push_swap $ARG | wc -l)
    CHECKER_RESULT=$(../push_swap $ARG | ./checker $ARG)

    if [ "$MOVES" -lt "$MIN_3" ]; then MIN_3=$MOVES; fi
    if [ "$MOVES" -gt "$MAX_3" ]; then MAX_3=$MOVES; fi
    SUM_3=$((SUM_3 + MOVES))
    
    if [ "$MOVES" -gt "$THRESHOLD_3" ] || [ "$CHECKER_RESULT" != "OK" ]; then
        stop_loading $LOADING_PID_3
        echo -e "\033[41m [FAIL] Failed combination: $ARG\033[0m"
        echo "Running error visualization..."
        ARG=$(echo "$ARG" | tr -d '\n')
        python3 visual.py $ARG
        exit 1
    fi
done

AVERAGE_3=$((SUM_3 / NUM_ATTEMPTS))
[ "$AVERAGE_3" -le 2 ] && POINTS_3=5 || POINTS_3=0
BASE=$((BASE + POINTS_3))
stop_loading $LOADING_PID_3
echo -e "${GREEN}✅ [OK] Processed. 3 numbers average moves: $AVERAGE_3${NC}"

# ==========================================
# 2. Evaluate cases of 5 numbers
# ==========================================
echo "--- Evaluating $NUM_ATTEMPTS cases of 5 numbers ---"
MIN_5=1000000
MAX_5=0
SUM_5=0

show_loading &
LOADING_PID_5=$!

for ((i = 1; i <= NUM_ATTEMPTS; i++)); do
    ARG=$(awk -v n="5" -v seed="$i" 'BEGIN { srand(seed); for (j = 0; j < n; j++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')
    
    MOVES=$(../push_swap $ARG | wc -l)
    CHECKER_RESULT=$(../push_swap $ARG | ./checker $ARG)

    if [ "$MOVES" -lt "$MIN_5" ]; then MIN_5=$MOVES; fi
    if [ "$MOVES" -gt "$MAX_5" ]; then MAX_5=$MOVES; fi
    SUM_5=$((SUM_5 + MOVES))
    
    if [ "$MOVES" -gt "$THRESHOLD_5" ] || [ "$CHECKER_RESULT" != "OK" ]; then
        stop_loading $LOADING_PID_5
        echo -e "\033[41m [FAIL] Failed combination: $ARG\033[0m"
        echo "Running error visualization..."
        ARG=$(echo "$ARG" | tr -d '\n')
        python3 visual.py $ARG
        exit 1
    fi
done

AVERAGE_5=$((SUM_5 / NUM_ATTEMPTS))
[ "$AVERAGE_5" -le 12 ] && POINTS_5=5 || POINTS_5=0
BASE=$((BASE + POINTS_5))
stop_loading $LOADING_PID_5
echo -e "${GREEN}✅ [OK] Processed. 5 numbers average moves: $AVERAGE_5${NC}"

# ==========================================
# 3. Evaluate cases of 100 numbers
# ==========================================
echo "--- Evaluating $NUM_ATTEMPTS cases of 100 numbers ---"
MIN_100=1000000
MAX_100=0
SUM_100=0

show_loading &
LOADING_PID_100=$!

for ((i = 1; i <= NUM_ATTEMPTS; i++)); do
    ARG_100=$(awk -v n="100" -v seed="$i" 'BEGIN { srand(seed); for (j = 0; j < n; j++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')
    MOVES_100=$(../push_swap $ARG_100 | wc -l)
    CHECKER_RESULT_100=$(../push_swap $ARG_100 | ./checker $ARG_100)

    if [ "$MOVES_100" -lt "$MIN_100" ]; then MIN_100=$MOVES_100; fi
    if [ "$MOVES_100" -gt "$MAX_100" ]; then MAX_100=$MOVES_100; fi
    SUM_100=$((SUM_100 + MOVES_100))

    if [ "$CHECKER_RESULT_100" != "OK" ]; then
        stop_loading $LOADING_PID_100
        echo -e "\033[41m [FAIL] Failed combination: $ARG_100\033[0m"
        echo "Running error visualization..."
        ARG_100=$(echo "$ARG_100" | tr -d '\n')
        python3 visual.py $ARG_100
        exit 1
    fi
done

AVERAGE_100=$((SUM_100 / NUM_ATTEMPTS))

if [ "$AVERAGE_100" -lt 700 ]; then POINTS_100=5
elif [ "$AVERAGE_100" -lt 900 ]; then POINTS_100=4
elif [ "$AVERAGE_100" -lt 1100 ]; then POINTS_100=3
elif [ "$AVERAGE_100" -lt 1300 ]; then POINTS_100=2
elif [ "$AVERAGE_100" -lt 1500 ]; then POINTS_100=1
else POINTS_100=0
fi

BASE=$((BASE + POINTS_100))
stop_loading $LOADING_PID_100
echo -e "${GREEN}✅ [OK] Processed. 100 numbers average moves: $AVERAGE_100${NC}"

# ==========================================
# 4. Evaluate cases of 500 numbers
# ==========================================
echo "--- Evaluating $NUM_ATTEMPTS cases of 500 numbers ---"
MIN_500=1000000
MAX_500=0
SUM_500=0

show_loading &
LOADING_PID_500=$!

for ((i = 1; i <= NUM_ATTEMPTS; i++)); do
    ARG_500=$(awk -v n="500" -v seed="$i" 'BEGIN { srand(seed); for (j = 0; j < n; j++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')
    MOVES_500=$(../push_swap $ARG_500 | wc -l)
    CHECKER_RESULT_500=$(../push_swap $ARG_500 | ./checker $ARG_500)

    if [ "$MOVES_500" -lt "$MIN_500" ]; then MIN_500=$MOVES_500; fi
    if [ "$MOVES_500" -gt "$MAX_500" ]; then MAX_500=$MOVES_500; fi
    SUM_500=$((SUM_500 + MOVES_500))

    if [ "$CHECKER_RESULT_500" != "OK" ]; then
        stop_loading $LOADING_PID_500
        echo -e "\033[41m [FAIL] Failed combination: $ARG_500\033[0m"
        echo "Running error visualization..."
        ARG_500=$(echo "$ARG_500" | tr -d '\n')
        python3 visual.py $ARG_500
        exit 1
    fi
done

AVERAGE_500=$((SUM_500 / NUM_ATTEMPTS))

if [ "$AVERAGE_500" -lt 5500 ]; then POINTS_500=5
elif [ "$AVERAGE_500" -lt 7000 ]; then POINTS_500=4
elif [ "$AVERAGE_500" -lt 8500 ]; then POINTS_500=3
elif [ "$AVERAGE_500" -lt 10000 ]; then POINTS_500=2
elif [ "$AVERAGE_500" -lt 11500 ]; then POINTS_500=1
else POINTS_500=0
fi

BASE=$((BASE + POINTS_500))
stop_loading $LOADING_PID_500
echo -e "${GREEN}✅ [OK] Processed. 500 numbers average moves: $AVERAGE_500${NC}"

# ==========================================
# Results & Final Score
# ==========================================
echo -e "\n${BLUE}--- Results Summary ---${NC}"
echo -e "${WHITE}3 numbers   -> Min: $MIN_3 | Max: $MAX_3 | Avg: $AVERAGE_3 | Points: ${GREEN}$POINTS_3${NC}"
echo -e "${WHITE}5 numbers   -> Min: $MIN_5 | Max: $MAX_5 | Avg: $AVERAGE_5 | Points: ${GREEN}$POINTS_5${NC}"
echo -e "${WHITE}100 numbers -> Min: $MIN_100 | Max: $MAX_100 | Avg: $AVERAGE_100 | Points: ${GREEN}$POINTS_100${NC}"
echo -e "${WHITE}500 numbers -> Min: $MIN_500 | Max: $MAX_500 | Avg: $AVERAGE_500 | Points: ${GREEN}$POINTS_500${NC}"

show_celebration

show_final_score() {
    echo -e "\n${BLUE}--- Final Result ---${NC}"
    echo -e "${WHITE}Points for 3 numbers:   ${GREEN}$POINTS_3${NC}"
    echo -e "${WHITE}Points for 5 numbers:   ${GREEN}$POINTS_5${NC}"
    echo -e "${WHITE}Points for 100 numbers: ${GREEN}$POINTS_100${NC}"
    echo -e "${WHITE}Points for 500 numbers: ${GREEN}$POINTS_500${NC}"
    echo -e "\n${MAGENTA}==================================${NC}"
    echo -e "${MAGENTA}==   ${CYAN}Final Score: ${RED}${BASE}${CYAN}!   ${MAGENTA}==${NC}"
    echo -e "${MAGENTA}==================================${NC}"
}

show_final_score