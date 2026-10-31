#!/usr/bin/env python3
"""
Simple utility to convert time strings (e.g., '1h 20m', '90m', '1:20') into decimal hours.
"""

import re
import sys


def parse_time_to_hours(time_str: str) -> float:
    time_str = time_str.strip()
    if not time_str:
        raise ValueError("Input cannot be empty.")

    # Remove optional leading "INPUT:" or "input:"
    time_str = re.sub(r"^input\s*:\s*", "", time_str, flags=re.IGNORECASE).strip()

    # Format: HH:MM or HH:MM:SS (e.g., 1:20 or 1:20:30)
    colon_match = re.fullmatch(r"(\d+):(\d{1,2})(?::(\d{1,2}(?:\.\d+)?))?", time_str)
    if colon_match:
        hours = float(colon_match.group(1))
        minutes = float(colon_match.group(2))
        seconds = float(colon_match.group(3) or 0)
        return hours + (minutes / 60) + (seconds / 3600)

    # Unit format: e.g. "1h 20m", "90 mins", "2 hours 15 min 30 sec", "1d 2h"
    pattern = re.compile(
        r"(\d+(?:\.\d+)?)\s*(days?|d|hours?|hrs?|h|minutes?|mins?|m|seconds?|secs?|s)",
        re.IGNORECASE,
    )
    matches = pattern.findall(time_str)

    if not matches:
        # Check if user passed a plain number
        try:
            return float(time_str)
        except ValueError:
            raise ValueError(
                f"Invalid time format: '{time_str}'. Expected formats like '1h 20m', '90m', or '1:20'."
            )

    total_hours = 0.0
    for value_str, unit in matches:
        val = float(value_str)
        unit = unit.lower()
        if unit.startswith("d"):
            total_hours += val * 24
        elif unit.startswith("h"):
            total_hours += val
        elif unit.startswith("m"):
            total_hours += val / 60
        elif unit.startswith("s"):
            total_hours += val / 3600

    return total_hours


def format_hours(hours: float) -> str:
    # Round to 2 decimal places if it's clean, or trim trailing zeros if whole
    formatted = f"{hours:.2f}h"
    return formatted


def main():
    if len(sys.argv) > 1:
        raw_input = " ".join(sys.argv[1:])
    else:
        try:
            raw_input = input("INPUT: ").strip()
        except (KeyboardInterrupt, EOFError):
            print()
            return

    try:
        hours = parse_time_to_hours(raw_input)
        print(f"OUTPUT: {format_hours(hours)}")
    except ValueError as err:
        print(f"Error: {err}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
