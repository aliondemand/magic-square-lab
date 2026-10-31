# Magic Square Simulation and Algorithm Analysis

Data Structures and Algorithms (Theory), Fall 2026 - Assignments 1 and 2
Group 29 - Members: Shoukat Aziz (SP25-BED-087), Syed Ali Ameer Hussain (SP25-BED-089), Avaiz Asim (SP25-BED-020)

A Python desktop application that builds magic squares of order 3 to 12 step by step,
shows the algorithm being used, verifies the result, and compares the constructive
algorithms with two brute-force searches.

## 1. Main features

- Three constructive algorithms, chosen automatically from the order n:
  odd (Siamese method), doubly even (diagonal / complement method) and
  singly even (Strachey's method). Orders 3 to 12 are supported in the window.
- Step-by-step simulation with **Start, Pause (and Resume), Step, Reset** and a speed slider.
  The current cell is highlighted; swaps also highlight the partner cell.
- Algorithm panel: name, case (odd / doubly even / singly even), pseudocode with the
  current line highlighted, "Step i / total" and a sentence describing the current event.
- Results panel: n, algorithm, magic constant M(n), time taken, every row sum, every
  column sum, both diagonal sums, and a VALID / NOT valid verdict.
- "Solve using brute force" option with two strategies (naive permutation search and
  backtracking with pruning), a time limit, a Stop button, node / arrangement counts and
  honest reporting when a limit is reached.
- The window never freezes: brute force runs in a worker thread.
- Input validation with clear messages (empty, letters, decimals, negatives, 0, 1, 2, above 12).
- Automated tests and a benchmark script that writes a table and graphs.

## 2. Technologies

Python 3.10 or newer, Tkinter / ttk (Canvas for the grid), `time.perf_counter()` for timing,
`threading` + `queue` for the search thread, `unittest` for tests, Matplotlib (graphs only).

## 3. Prerequisites

1. Python 3.10 or newer from <https://www.python.org/downloads/>.
   **On Windows, keep "tcl/tk and IDLE" ticked in the installer** (it is on by default).
2. Visual Studio Code with the "Python" extension (optional but recommended).

Check your setup in a terminal:

```
python --version
python -c "import tkinter; print(tkinter.TkVersion)"
```

The second command should print a number such as `8.6`. If `python` is not found on Windows, try `py`.

## 4. Installation

Unzip the project. Nothing needs installing to run the program or the tests.
Only for the benchmark graphs:

```
pip install -r requirements.txt
```

Optional virtual environment (Windows PowerShell):

```
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

If PowerShell refuses to run the activate script, use the Command Prompt instead
(`.venv\Scripts\activate.bat`) or run `Set-ExecutionPolicy -Scope Process RemoteSigned` first.

## 5. Open the project in Visual Studio Code

1. Start VS Code.
2. **File -> Open Folder...** and choose the `magic_square_project` folder (the one that contains `main.py`).
3. Open a terminal with **Terminal -> New Terminal**. It opens inside the project folder.
4. If VS Code asks for a Python interpreter, press `Ctrl+Shift+P`, type
   **Python: Select Interpreter** and pick your Python 3.10+.

## 6. Run the application

```
python main.py
```

How to use it:

1. Type an order n (3 to 12). The case ("Order 6 is SINGLY EVEN") and the algorithm text appear immediately.
2. Press **Construct Magic Square**. The program prepares the construction and shows the time it took.
3. Press **Start** to watch it run, or **Step** to advance exactly one event. **Pause** stops, **Start/Resume** continues,
   **Reset** goes back to the beginning. The slider changes the delay between events.
4. When the last event is applied, the square on the screen is verified and the sums are shown.
5. For brute force: tick **Solve using brute force**, choose a strategy, set a time limit, press **Construct Magic Square**.
   Use **Stop / Cancel search** to cancel. Brute-force results are shown immediately (no animation).

Changing the order, the method or the strategy discards the current simulation and shows an empty grid.

## 7. Run the tests

```
python -m unittest discover -s tests -t . -v
```

- The GUI tests open real windows for a few seconds. If no display exists they are skipped, not failed.
- One slow test (about 1-2 minutes) checks that backtracking finds exactly 7,040 magic squares of order 4.
  It is off by default. To run it:
  - Command Prompt: `set RUN_SLOW_TESTS=1` then `python -m unittest tests.test_brute_force -v`
  - PowerShell: `$env:RUN_SLOW_TESTS="1"` then `python -m unittest tests.test_brute_force -v`

## 8. Run the benchmarks

```
python benchmarks/run_benchmarks.py
python benchmarks/plot_results.py
```

- `run_benchmarks.py` takes about one to two minutes (searches that cannot finish get 10 s each; change with `--limit 20`;
  `--quick` is a short test run that is NOT suitable for the report).
- It writes `results.csv`, `estimates.csv` and `environment.txt` (your Python version, operating system and CPU count are
  recorded automatically).
- `plot_results.py` writes `timing_table.md`, `time_vs_order.png` and `constructive_scaling.png`.
- **The result files that came with this ZIP were produced on the AI assistant's test machine (see `environment.txt`).
  For your report, run the benchmarks on your own computer and use those files.**

## 9. Project structure

```
magic_square_project/
  main.py                      starts the program
  algorithms/
    odd_magic_square.py        Siamese method
    doubly_even_magic_square.py  diagonal / complement method
    singly_even_magic_square.py  Strachey's method
    simulation_events.py       the Event record (PLACE / COMPLEMENT / SWAP) and replay
    validation.py              independent validator and magic_constant(n)
    input_check.py             checks the text typed into the order box
    dispatcher.py              chooses the algorithm for n and times it
  brute_force/
    naive_search.py            permutation search
    backtracking_search.py     backtracking with pruning
    search_runner.py           worker thread, cancel, time limit, stale-result protection
    search_result.py           result record and status values
  gui/
    app.py                     main window, wires everything together
    controls.py                inputs and buttons
    grid_view.py               Canvas drawing of the grid
    algorithm_panel.py         pseudocode and current step
    results_panel.py           sums, constant, time, verdict, search statistics
    simulation_controller.py   Start / Pause / Step / Reset logic (no tkinter, easy to test)
    formatting.py              small text helpers
  tests/                       automated tests
  benchmarks/                  run_benchmarks.py, plot_results.py and their output files
  README.md, requirements.txt, AI_LOG.md
```

The algorithms never touch the GUI, and the GUI never calculates a magic square. The algorithms write down what
they do as a list of events; the GUI replays those events one at a time.

## 10. The constructive algorithms

All three run in O(n^2) time, because every cell is written a constant number of times.

**Odd - Siamese method.** Put 1 in the top row, middle column. For each next number move one row up and one column right,
wrapping around the edges. If that cell is already filled, move one row down from the previous cell instead.

**Doubly even (n = 4, 8, 12) - diagonal / complement method.** Write 1 to n*n in reading order. In every 4 x 4 block, the cells
on the block's two diagonals are replaced by n*n + 1 - k. All other cells keep their number.

**Singly even (n = 6, 10) - Strachey's method.** With m = n/2 and k = (m-1)/2: build an odd magic square A of order m with the
Siamese method; place A in the top-left quarter, A + m*m bottom-right, A + 2m*m top-right, A + 3m*m bottom-left. Then swap the
leftmost k columns between the top-left and bottom-left quarters (in the middle row, use columns 1 to k instead of 0 to k-1) and
the rightmost k-1 columns between the top-right and bottom-right quarters. The tests confirm it for n = 6, 10 and many larger orders.

## 11. The brute-force methods

**Naive permutation search.** Tries the permutations of 1..n*n one after another until one is magic. For n = 3 there are
9! = 362,880 arrangements. For n >= 4 the number (n*n)! is astronomically large (16! is about 2.1 x 10^13), so the GUI shows a warning and the
search can only end at a safety limit (5,000,000 arrangements) or the time limit. It will not find a square.

**Backtracking with pruning.** Fills the cells row by row. For every line (row, column, diagonal) through the current cell, the
cells still empty must hold different numbers, so their sum is at least 1+2+...+k and at most the sum of the k largest numbers.
Any value that makes the line unable to reach M(n) is skipped; when only one cell of a line is left, its value is forced.
These rules are logically necessary, so no real solution is lost (the tests confirm this: exactly 8 squares for n = 3, and 7,040 for n = 4
in the optional slow test). Nodes (numbers written into cells) and pruned candidates are counted.

Both searches check for cancellation and the time limit regularly, and always end with an honest status:
FOUND, EXHAUSTED, CANCELLED, TIME_LIMIT, COUNT_LIMIT or ERROR. A search that hits a limit is **never** reported as a success.

## 12. Known limitations

- **The GUI was tested automatically and by screenshot on Linux with a virtual display (Tk 8.6). It has not been
  tested on Windows by the author of the code.** Fonts and spacing may differ slightly on Windows. Please run the manual checklist below.
- Brute force on larger orders: naive search cannot go beyond order 3. Backtracking finds order 4 quickly but, in the
  benchmark runs here, orders 5 to 8 did not finish within the limit. Larger orders may take hours or never finish; this is expected.
- The window supports orders 3 to 12 only. The algorithms themselves work for larger orders (the benchmarks use up to 100).
- Brute-force results are displayed instantly, without animation. Only constructive runs are animated.
- "Time taken" for constructive runs measures only the algorithm (microseconds to a fraction of a millisecond), not the animation.
- Only one search or simulation can run at a time. Timings vary a little from run to run and depend on what else the computer is doing.
- The theoretical estimates for naive search assume a constant speed and the worst case; they are estimates, not measurements.

## 13. Manual GUI checklist (please do this once on your computer)

- [ ] `python main.py` opens the window; the order box shows 5 and "Order 5 is ODD".
- [ ] Construct, Start: grid fills, amber cell moves, pseudocode line highlights, validation turns green at the end.
- [ ] Pause then Start (Resume) continues; Step adds exactly one cell; Reset empties the grid.
- [ ] Orders 3 to 12 each finish with a green VALID verdict (6 and 10 show swap steps with a blue partner cell).
- [ ] Bad input (empty, `abc`, `4.5`, `-3`, `0`, `1`, `2`, `13`) shows a red message and nothing starts.
- [ ] Brute force, backtracking, order 4: finds a square in well under a second.
- [ ] Brute force, naive, order 3: finds a square. Naive, order 4: asks for confirmation and ends at the limit with "NOT finished".
- [ ] Brute force, backtracking, order 6 with a 60 s limit: window stays responsive; Stop cancels it.
- [ ] Change the order after a run: the grid and algorithm text switch to the new order.

## 14. Troubleshooting

| Problem | What to do |
|---|---|
| `python` is not recognised | Try `py main.py`, or reinstall Python and tick "Add python.exe to PATH". |
| `ModuleNotFoundError: No module named 'tkinter'` | Re-run the Python installer, choose Modify, tick "tcl/tk and IDLE". On Linux: `sudo apt install python3-tk`. |
| `ModuleNotFoundError: algorithms` or `gui` | Run the command from the project folder (the one containing `main.py`). |
| `No module named matplotlib` when plotting | `pip install -r requirements.txt` (only the graphs need it). |
| Tests print many `s` (skipped) | No display was available, so the GUI tests were skipped. Run them on a desktop session. |
| A brute-force search seems stuck | Press Stop / Cancel. Searches always end at the time limit anyway. |
| Text looks too small or large | The window can be resized; the grid scales with it. |
