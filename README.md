# Push_swap Tester

This is a testing script for the **Push_swap** project at 42 School, developed by **rmarrero** from 42 Barcelona. The script allows you to evaluate the performance of your `push_swap` implementation with different list sizes (3, 5, 100, and 500 numbers) and a configurable number of attempts.

---

## Requirements

1. **Push_swap Project**: Ensure your `push_swap` project is compiled and ready to use.
2. **Checker**: The script uses a `checker` program to verify if the operations performed by `push_swap` are correct. Make sure the `checker` is in the same directory as the script.
3. **Python 3**: The script uses a visualization script (`visual.py`) that requires Python 3 to display errors graphically.

---

## Usage Instructions

1. **Clone the repository** or download the script to your working environment.
2. **Compile your `push_swap` project**:
   ```bash
   cd /path/to/your/push_swap
   make re
   ```
3. **Navigate to the tester directory**:
   ```bash
   cd /path/to/push_swap_tester
   ```
4. **Run the script**:
   ```bash
   ./push_swap_tester.sh [NUMBER_OF_ATTEMPTS]
   ```
   - If you don't provide a number of attempts, the default value is **1000**.

---

## Script Features

### 1. **Evaluation of 3-number Lists**
   - The script generates random lists of 3 numbers and runs your `push_swap`.
   - It verifies that the number of moves does not exceed the allowed threshold (2 moves).
   - If the result is incorrect, an error visualization is displayed.

### 2. **Evaluation of 5-number Lists**
   - Similar to the 3-number case, but with a threshold of 12 moves.

### 3. **Evaluation of 100-number Lists**
   - Generates random lists of 100 numbers.
   - Assigns points based on the average number of moves:
     - Less than 700 moves: 5 points.
     - Less than 900 moves: 4 points.
     - Less than 1100 moves: 3 points.
     - Less than 1300 moves: 2 points.
     - Less than 1500 moves: 1 point.
     - More than 1500 moves: 0 points.

### 4. **Evaluation of 500-number Lists**
   - Generates random lists of 500 numbers.
   - Assigns points based on the average number of moves:
     - Less than 5500 moves: 5 points.
     - Less than 7000 moves: 4 points.
     - Less than 8500 moves: 3 points.
     - Less than 10000 moves: 2 points.
     - Less than 11500 moves: 1 point.
     - More than 11500 moves: 0 points.

### 5. **Error Visualization**
   - If the `checker` detects an error, the script runs a visualizer (`visual.py`) to display the failed combination.

### 6. **Animations and Colors**
   - The script includes loading animations and colorful completion messages for a better user experience.

---

## Results

At the end of the execution, the script displays:
- The minimum, maximum, and average number of moves for each list size.
- The points earned in each category.
- A final score based on the accumulated points.

Example output:
```
--- Final Result ---
Points for 3 numbers:   5
Points for 5 numbers:   5
Points for 100 numbers: 4
Points for 500 numbers: 3

==================================
==   Final Score: 17!           ==
==================================
```

---

## Notes

- The script stops immediately if an error is detected in any test case.
- You can adjust the number of attempts by passing a different value as an argument when running the script.
- The visualizer (`visual.py`) is optional but helpful for debugging failed combinations.

---

## Credits

- Developed by **rmarrero** from 42 Barcelona.
- Designed for 42 School students to test their `push_swap` projects efficiently.

Enjoy testing your `push_swap`! 🚀


# **Tester 2** 

# Push Swap Tester Script Documentation

This script is designed to test the `push_swap` program, which is a sorting algorithm project. The script generates random numbers, runs the `push_swap` program with these numbers, and checks the results using the `checker` program. It then calculates statistics such as the minimum, maximum, and average number of operations, as well as the success rate.

## Table of Contents
1. [Script Overview](#script-overview)
2. [Usage](#usage)
3. [Parameters](#parameters)
4. [How It Works](#how-it-works)
5. [Output](#output)
6. [Dependencies](#dependencies)
7. [Example](#example)

---

## Script Overview

The script performs the following tasks:
- Generates random numbers within a specified range.
- Runs the `push_swap` program with the generated numbers.
- Checks the output of `push_swap` using the `checker` program.
- Calculates statistics such as the minimum, maximum, and average number of operations.
- Displays the results in a colored format for better readability.

---

## Usage

To use the script, run the following command in your terminal:

```bash
./script_name.sh <range> <moves_threshold> [number_of_cases]
```

---

## Parameters

| Parameter           | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `<range>`           | The number of random integers to generate.                                 |
| `<moves_threshold>` | The maximum number of moves allowed for the `push_swap` program to be considered successful. |
| `[number_of_cases]` | (Optional) The number of test cases to run. Default is 10,000.             |

---

## How It Works

1. **Input Validation**:
   - The script checks if the correct number of arguments is provided. If not, it displays a usage message and exits.

2. **Random Number Generation**:
   - For each test case, the script generates a set of random integers within the specified range using `awk` and a unique seed.

3. **Running `push_swap`**:
   - The generated numbers are passed to the `push_swap` program, and the output is saved to `test.txt`.

4. **Checking Results**:
   - The output of `push_swap` is piped into the `checker` program, which verifies if the sorting was successful. The result is saved to `checker.txt`.

5. **Statistics Calculation**:
   - The script calculates the number of operations performed by `push_swap`.
   - It updates the minimum, maximum, and average number of operations.
   - It also tracks the number of successful test cases.

6. **Output**:
   - The script prints the results of each test case in colored text (green for success, red for failure).
   - At the end, it displays a summary of the statistics.

---

## Output

The script outputs the following:
- For each test case:
  - `[OK]` or `[KO]` indicating success or failure.
  - The number of operations performed.
  - The current average number of operations.
  - The generated numbers.

- At the end of the script:
  - A summary with the minimum, maximum, and average number of operations.
  - The success rate (number of successful test cases / total test cases).

---

## Dependencies

- **`push_swap`**: The program to be tested. It should be located in the parent directory (`../push_swap`).
- **`checker`**: The program used to verify the output of `push_swap`. It should be located in the current directory (`./checker`).
- **`awk`**: Used for generating random numbers.
- **`wc`**: Used to count the number of lines in the output file.

---

## Example

To test `push_swap` with 100 random numbers, a move threshold of 700, and 500 test cases, run:

```bash
./script_name.sh 100 700 500
```

### Sample Output:
```
[OK] 650 (Promedio: 655) 123 456 789 ...
[KO] 710 (Promedio: 660) 987 654 321 ...
...

Resumen para rango 100:
Mínimo: 600 | Máximo: 720 | Promedio: 655 | Puntos: 480/500
```

---

## Notes
- Ensure that `push_swap` and `checker` are compiled and accessible from the script's location.
- The script uses colored output for better readability. If your terminal does not support colors, you may see escape codes instead.
```