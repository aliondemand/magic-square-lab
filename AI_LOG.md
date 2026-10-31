# AI Usage Log

Group 29 - Members: Shoukat Aziz (SP25-BED-087), Syed Ali Ameer Hussain (SP25-BED-089), Avaiz Asim (SP25-BED-020)
Course: Data Structures and Algorithms (Theory), Fall 2026, Assignments 1 and 2

This log is updated after every phase. "Tested" below means what was actually run;
anything not yet run is marked as such.

| # | Tool | Date | Main prompt / task | Used in | Accepted | Modified | Rejected | How it was tested |
|---|------|------|--------------------|---------|----------|----------|----------|-------------------|
| 1 | Claude (Anthropic) | 2026-10-25 | Read the assignment PDF, list requirements and marking scheme, point out the deadline conflict (1 Nov vs 30 Oct) | Planning only | Requirements checklist | - | - | Checked against the PDF text |
| 2 | Claude | 2026-10-25 | Design the project: structure, event system, algorithms, GUI layout, test plan | Planning only | Whole design; Strachey's method for singly-even; GUI maximum order 12 (student's decision) | Maximum order changed from the proposed 20 to 12 by the student | - | - |
| 3 | Claude | 2026-10-25 | Implement odd (Siamese), doubly-even (diagonal/complement), singly-even (Strachey) algorithms and the event system | `algorithms/` | All three algorithms | - | - | 20 unit tests; all orders 3-12 (and larger) validated; events replayed from an empty grid equal the final square. Run by Claude in its own sandbox (Python 3.12.3). |
| 4 | Claude | 2026-10-25 | Implement validator, input checking and their tests | `algorithms/validation.py`, `algorithms/input_check.py`, `tests/test_validation.py`, `tests/test_input_check.py` | Validator and input checker | One AI-written test used a bad mutation (swapping rows 0 and 3 of a 4x4 square leaves it magic); the TEST was fixed, the validator was not changed | - | 45 tests total passed after the fix |
| 5 | Claude | 2026-10-25 | Implement naive search, backtracking with pruning, and a thread runner with cancel/time limit | `brute_force/`, `tests/test_brute_force.py`, `tests/test_search_runner.py` | Both searches and the runner | - | - | 80 tests (1 optional slow test). Pruning checked by finding exactly 8 squares for n=3 and exactly 7,040 for n=4. Run in Claude's sandbox. |
| 6 | Claude | 2026-10-26 | Build the Tkinter GUI: grid, controls, algorithm panel, results panel, simulation controller, brute-force integration with a worker thread | `gui/`, `main.py`, `tests/test_gui_logic.py`, `tests/test_gui_app.py` | Overall architecture (controller without tkinter, message queue for the search thread) | Fixed during development: (a) the speed slider fired its callback before the app was built, causing an AttributeError; (b) first layout clipped the Simulation box and results text, found by looking at screenshots, so the layout was restructured and labels made to wrap; (c) the long search note made the results panel too tall, so it was shortened | - | 22 logic tests with a fake scheduler; 29 tests that drive the real window; screenshots taken and viewed on a Linux virtual display (NOT Windows). |
| 7 | Claude | 2026-10-26 | Benchmark script, table and graphs | `benchmarks/` | Script, table and graph code | Two sloppy lines in my own tests were corrected: a stray meaningless assignment and an assertion that compared a number with a boolean | - | 9 tests. The full benchmark was run in Claude's sandbox (1 logical CPU, Python 3.12.3); those numbers are NOT yours. Re-run on your own PC for the report. |
| 8 | Claude | 2026-10-26 | README.md, requirements.txt, AI_LOG.md | project root | Drafts | - | - | README commands should be run by you on Windows; they have not been tried on Windows. |

## Still to be done by the student
- Run the tests on your own Windows computer and note the result here.
- Write down anything you changed yourself in the code.
- Run the manual GUI checklist in README.md section 13 and write the result here.
- Re-run the benchmarks on your own computer before writing the report.
- Add later entries (report, anything you change yourself) as they happen.
