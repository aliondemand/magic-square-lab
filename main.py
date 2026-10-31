"""Start the program with:   python main.py"""

import sys


def main() -> None:
    try:
        import tkinter  # noqa: F401  (only checking that it is installed)
    except ImportError:
        print("Tkinter is not installed for this Python.\n"
              "On Windows, re-run the Python installer, choose 'Modify' and tick 'tcl/tk and IDLE'.\n"
              "On Linux: sudo apt install python3-tk")
        sys.exit(1)
    from gui.app import run
    run()


if __name__ == "__main__":
    main()
