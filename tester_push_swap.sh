# Push_swap tester made for students of 42 by students of 42Barcelona, by rmarrero

cd ..
make re
cd ./push_swap_tester
clear

# Assign the number of attempts from the first argument
NUM_ATTEMPTS=${1:-1000}  # If not provided, the default value is 1,000

# Title
show_title() {
    echo -e "\033[1;36m"
    echo "  _____   ____ "
    echo " |  __ \/ ____|"
    echo " | |__) | (___  "
    echo " |  ___/ \___ \ "
    echo " | |     ____) | "
    echo " |_|    |_____/  Tester"
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

# Function to show a loading animation with colors
show_loading() {
    echo -n "Processing... "
    while true; do
        for c in "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"; do
            echo -ne "\r${CYAN}$c${NC} Processing... "
            sleep 0.1
        done
    done
}

# Function to show a celebration animation with colors
show_celebration() {
    echo -e "\n${MAGENTA}🎉 Process completed! 🎉${NC}"
    for i in {1..5}; do
        echo -ne "\r${YELLOW}✨✨✨✨✨${NC}"
        sleep 0.2
        echo -ne "\r  ${YELLOW}✨✨✨✨${NC}"
        sleep 0.2
        echo -ne "\r    ${YELLOW}✨✨✨${NC}"
        sleep 0.2
        echo -ne "\r      ${YELLOW}✨✨${NC}"
        sleep 0.2
        echo -ne "\r        ${YELLOW}✨${NC}"
        sleep 0.2
    done
    echo -e "\r${GREEN}✅ All done! ✅${NC}"
}

# Initial base
BASE=80

ALL_VALID_3=true
ALL_VALID_5=true

# Threshold for 3 and 5
THRESHOLD_3=2
THRESHOLD_5=12

# Counter
COUNTER_3=0
COUNTER_5=0

# Show title
show_title

# Evaluate cases of 3 numbers
echo "--- Evaluating $NUM_ATTEMPTS cases of 3 numbers ---"
MIN_3=1000000
MAX_3=0
SUM_3=0
COUNTER_3=0

show_loading &
LOADING_PID_3=$!

for ((i = 1; i <= NUM_ATTEMPTS; i++)); do
    ARG=$(awk -v n="3" -v seed="$i" 'BEGIN { srand(seed); for (i = 0; i < n; i++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')
    
    # Run push_swap and count moves
    MOVES=$(../push_swap $ARG | wc -l)
    
    # Verify if the moves are correct using the checker
    CHECKER_RESULT=$(../push_swap $ARG | ./checker $ARG)

    # Increment the counter for 3-number cases
    COUNTER_3=$((COUNTER_3 + 1))

    # Update min, max, and sum
    if [ "$MOVES" -lt "$MIN_3" ]; then
        MIN_3=$MOVES
    fi
    if [ "$MOVES" -gt "$MAX_3" ]; then
        MAX_3=$MOVES
    fi
    SUM_3=$((SUM_3 + MOVES))
    
    # Verify the number of moves and the checker result
    if [ "$MOVES" -gt "$THRESHOLD_3" ] || [ "$CHECKER_RESULT" != "OK" ]; then
        echo -e "\033[41m [FAIL] Failed combination: $ARG\033[0m"
        echo "Running error visualization..."
        ARG=$(echo "$ARG" | tr -d '\n')
        python3 visual.py $ARG
        kill $LOADING_PID_3 2>/dev/null
        exit 1
    # See the combinations passing through each case
    # else
    #     echo -e "${GREEN}[OK] Attempt $i: $MOVES moves${NC} | Combination: $ARG"
    fi
done

# Calculate average for 3 numbers
AVERAGE_3=$((SUM_3 / NUM_ATTEMPTS))

# Allocate points according to the average number of moves for 3 numbers
if [ "$AVERAGE_3" -le 2 ]; then
    POINTS_3=5
else
    POINTS_3=0
fi

BASE=$((BASE + POINTS_3))

# Stop loading animation and display completion message
kill $LOADING_PID_3 2>/dev/null
echo -ne "${GREEN}\r✅ Processed.    ${NC} \n"

# Evaluate cases of 5 numbers
echo "--- Evaluating $NUM_ATTEMPTS cases of 5 numbers ---"
MIN_5=1000000
MAX_5=0
SUM_5=0
COUNTER_5=0

show_loading &
LOADING_PID_5=$!

for ((i = 1; i <= NUM_ATTEMPTS; i++)); do
    ARG=$(awk -v n="5" -v seed="$i" 'BEGIN { srand(seed); for (i = 0; i < n; i++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')
    
    # Run push_swap and count moves
    MOVES=$(../push_swap $ARG | wc -l)
    
    # Verify if the moves are correct using the checker
    CHECKER_RESULT=$(../push_swap $ARG | ./checker $ARG)

    # Increment the counter for 5-number cases
    COUNTER_5=$((COUNTER_5 + 1))

    # Update min, max, and sum
    if [ "$MOVES" -lt "$MIN_5" ]; then
        MIN_5=$MOVES
    fi
    if [ "$MOVES" -gt "$MAX_5" ]; then
        MAX_5=$MOVES
    fi
    SUM_5=$((SUM_5 + MOVES))
    
    # Verify the number of moves and the checker result
    if [ "$MOVES" -gt "$THRESHOLD_5" ] || [ "$CHECKER_RESULT" != "OK" ]; then
        echo -e "\033[41m [FAIL] Failed combination: $ARG\033[0m"
        echo "Running error visualization..."
        ARG=$(echo "$ARG" | tr -d '\n')
        python3 visual.py $ARG
        kill $LOADING_PID_5 2>/dev/null
        exit 1
    # See the combinations passing through each case
    # else
    #     echo -e "${GREEN}[OK] Attempt $i: $MOVES moves${NC} | Combination: $ARG"
    fi
done

# Calculate average for 5 numbers
AVERAGE_5=$((SUM_5 / NUM_ATTEMPTS))

# Allocate points according to the average number of moves for 5 numbers
if [ "$AVERAGE_5" -le 12 ]; then
    POINTS_5=5
else
    POINTS_5=0
fi

BASE=$((BASE + POINTS_5))

# Stop loading animation and display completion message
kill $LOADING_PID_5 2>/dev/null
echo -ne "${GREEN}\r✅ Processed.    ${NC} \n"

# Evaluate cases of 100 numbers
echo "--- Evaluating $NUM_ATTEMPTS cases of 100 numbers ---"
MIN_100=1000000
MAX_100=0
SUM_100=0
ALL_VALID_100=true

show_loading &
LOADING_PID_100=$!

for ((i = 1; i <= NUM_ATTEMPTS; i++)); do
    ARG_100=$(awk -v n="100" -v seed="$i" 'BEGIN { srand(seed); for (i = 0; i < n; i++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')
    MOVES_100=$(../push_swap $ARG_100 | wc -l)
    CHECKER_RESULT_100=$(../push_swap $ARG_100 | ./checker $ARG_100)

    # Update min, max, and sum
    if [ "$MOVES_100" -lt "$MIN_100" ]; then
        MIN_100=$MOVES_100
    fi
    if [ "$MOVES_100" -gt "$MAX_100" ]; then
        MAX_100=$MOVES_100
    fi
    SUM_100=$((SUM_100 + MOVES_100))

    # Verify if the checker result is valid
    if [ "$CHECKER_RESULT_100" != "OK" ]; then
        echo -e "\033[41m [FAIL] Failed combination: $ARG_100\033[0m"
        echo "Running error visualization..."
        ARG_100=$(echo "$ARG_100" | tr -d '\n')
        python3 visual.py $ARG_100
        kill $LOADING_PID_100 2>/dev/null
        exit 1
    # See the combinations passing through each case
    # else
    #     echo -e "${GREEN}[OK] Attempt $i: $MOVES moves${NC} | Combination: $ARG_100"
    fi
done

# Calculate average for 100 numbers
AVERAGE_100=$((SUM_100 / NUM_ATTEMPTS))

# Allocate points according to the average number of moves for 100 numbers
if [ "$AVERAGE_100" -lt 700 ]; then
    POINTS_100=5
elif [ "$AVERAGE_100" -lt 900 ]; then
    POINTS_100=4
elif [ "$AVERAGE_100" -lt 1100 ]; then
    POINTS_100=3
elif [ "$AVERAGE_100" -lt 1300 ]; then
    POINTS_100=2
elif [ "$AVERAGE_100" -lt 1500 ]; then
    POINTS_100=1
else
    POINTS_100=0
fi

BASE=$((BASE + POINTS_100))

# Stop loading animation and display completion message
kill $LOADING_PID_100 2>/dev/null
echo -ne "${GREEN}\r✅ Processed.    ${NC} \n"

# Evaluate cases of 500 numbers
echo "--- Evaluating $NUM_ATTEMPTS cases of 500 numbers ---"
MIN_500=1000000
MAX_500=0
SUM_500=0
ALL_VALID_500=true

show_loading &
LOADING_PID_500=$!

for ((i = 1; i <= NUM_ATTEMPTS; i++)); do
    ARG_500=$(awk -v n="500" -v seed="$i" 'BEGIN { srand(seed); for (i = 0; i < n; i++) printf("%d ", int(-2147483648 + rand() * (2147483647 - -2147483648 + 1))) }')
    MOVES_500=$(../push_swap $ARG_500 | wc -l)
    CHECKER_RESULT_500=$(../push_swap $ARG_500 | ./checker $ARG_500)

    # Update min, max, and sum
    if [ "$MOVES_500" -lt "$MIN_500" ]; then
        MIN_500=$MOVES_500
    fi
    if [ "$MOVES_500" -gt "$MAX_500" ]; then
        MAX_500=$MOVES_500
    fi
    SUM_500=$((SUM_500 + MOVES_500))

    # Verify if the checker result is valid
    if [ "$CHECKER_RESULT_500" != "OK" ]; then
        echo -e "\033[41m [FAIL] Failed combination: $ARG_500\033[0m"
        echo "Running error visualization..."
        ARG_500=$(echo "$ARG_500" | tr -d '\n')
        python3 visual.py $ARG_500
        kill $LOADING_PID_500 2>/dev/null
        exit 1
    # See the combinations passing through each case
    # else
    #     echo -e "${GREEN}[OK] Attempt $i: $MOVES moves${NC} | Combination: $ARG_500"
    fi
done

# Calculate average for 500 numbers
AVERAGE_500=$((SUM_500 / NUM_ATTEMPTS))

# Allocate points according to the average number of moves for 500 numbers
if [ "$AVERAGE_500" -lt 5500 ]; then
    POINTS_500=5
elif [ "$AVERAGE_500" -lt 7000 ]; then
    POINTS_500=4
elif [ "$AVERAGE_500" -lt 8500 ]; then
    POINTS_500=3
elif [ "$AVERAGE_500" -lt 10000 ]; then
    POINTS_500=2
elif [ "$AVERAGE_500" -lt 11500 ]; then
    POINTS_500=1
else
    POINTS_500=0
fi

BASE=$((BASE + POINTS_500))

# Stop loading animation and display completion message
kill $LOADING_PID_500 2>/dev/null
echo -ne "${GREEN}\r✅ Processed.    ${NC} \n"

# Function to show the final score in large and with colors
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

# Show final results in a single line per case
echo -e "${BLUE}--- Results for 3 numbers ---${NC}"
echo -e "${WHITE}Min: ${GREEN}$MIN_3${NC} | Max: ${GREEN}$MAX_3${NC} | Average: ${GREEN}$AVERAGE_3${NC} | Points: ${GREEN}$POINTS_3${NC}"

echo -e "${BLUE}--- Results for 5 numbers ---${NC}"
echo -e "${WHITE}Min: ${GREEN}$MIN_5${NC} | Max: ${GREEN}$MAX_5${NC} | Average: ${GREEN}$AVERAGE_5${NC} | Points: ${GREEN}$POINTS_5${NC}"

echo -e "${BLUE}--- Results for 100 numbers ---${NC}"
echo -e "${WHITE}Min: ${GREEN}$MIN_100${NC} | Max: ${GREEN}$MAX_100${NC} | Average: ${GREEN}$AVERAGE_100${NC} | Points: ${GREEN}$POINTS_100${NC}"

echo -e "${BLUE}--- Results for 500 numbers ---${NC}"
echo -e "${WHITE}Min: ${GREEN}$MIN_500${NC} | Max: ${GREEN}$MAX_500${NC} | Average: ${GREEN}$AVERAGE_500${NC} | Points: ${GREEN}$POINTS_500${NC}"

# Show celebration animation at the end
show_celebration

# Show the final score in large and with colors
show_final_score