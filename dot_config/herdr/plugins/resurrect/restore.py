"""Relaunch nvim/lazygit in restored herdr panes (the herdr resurrect plugin's startup hook).

Each state file in ~/.local/state/herdr-resurrect holds three lines, written by the zsh
wrappers in ~/.zshrc: pane id, working directory, shell-quoted command.

For each file:
  1. Find the pane: same pane id, else an unclaimed pane with the same cwd.
  2. Skip it unless the pane sits idle at its shell (live handoff keeps processes running).
  3. `herdr pane run` the command. The wrapper then records the pane again.
A plain `nvim` relaunches with persistence.nvim's session for the cwd.
"""

import json
import os
import shlex
import subprocess
import sys
import time

HERDR = os.environ.get("HERDR_BIN_PATH") or "herdr"
STATE_DIR = os.path.join(
    os.environ.get("XDG_STATE_HOME") or os.path.expanduser("~/.local/state"),
    "herdr-resurrect",
)
NVIM_SESSION = "nvim -c 'lua require(\"persistence\").load()'"
WAIT_SECONDS = 15  # how long to wait for restored shells to come up
SETTLE_SECONDS = 1.5  # extra time for zsh to finish loading before typing into it


def log(msg):
    print(f"resurrect: {msg}", file=sys.stderr, flush=True)


def herdr(*args):
    out = subprocess.run([HERDR, *args], capture_output=True, text=True, check=True).stdout
    return json.loads(out)["result"]


def idle(pane_id):
    """True when the pane's foreground process is its own shell."""
    try:
        info = herdr("pane", "process-info", "--pane", pane_id)["process_info"]
    except (subprocess.CalledProcessError, KeyError, ValueError):
        return False
    shell = info.get("shell_pid")
    return shell is not None and info.get("foreground_process_group_id") == shell


def read_entries():
    entries = []
    try:
        names = sorted(os.listdir(STATE_DIR))
    except FileNotFoundError:
        return entries
    for name in names:
        path = os.path.join(STATE_DIR, name)
        try:
            with open(path) as f:
                pane_id, cwd, command = f.read().split("\n")[:3]
        except (OSError, ValueError):
            log(f"skipping unreadable {path}")
            continue
        if command.strip():
            entries.append({"path": path, "pane": pane_id, "cwd": cwd, "command": command.strip()})
    return entries


def main():
    entries = read_entries()
    if not entries:
        return

    # Wait until every pane we need is idle at its shell, or the timeout passes.
    deadline = time.monotonic() + WAIT_SECONDS
    while True:
        panes = {p["pane_id"]: p for p in herdr("pane", "list")["panes"]}
        if all(e["pane"] in panes and idle(e["pane"]) for e in entries) or time.monotonic() > deadline:
            break
        time.sleep(0.5)
    time.sleep(SETTLE_SECONDS)

    claimed = set()
    for e in entries:
        pane = e["pane"] if e["pane"] in panes else None
        if pane is None:  # pane id changed: fall back to an unclaimed pane in the same cwd
            pane = next(
                (pid for pid, p in panes.items()
                 if pid not in claimed and e["cwd"] in (p.get("cwd"), p.get("foreground_cwd"))),
                None,
            )
        if pane is None:
            log(f"no pane for {e['pane']} ({e['cwd']}): dropping {e['command']!r}")
            os.remove(e["path"])
            continue
        claimed.add(pane)
        if not idle(pane):
            log(f"{pane} busy: leaving it alone")
            continue

        command = NVIM_SESSION if e["command"] == "nvim" else e["command"]
        p = panes[pane]
        if e["cwd"] not in (p.get("cwd"), p.get("foreground_cwd")):
            command = f"cd -- {shlex.quote(e['cwd'])} && {command}"
        if pane != e["pane"]:
            os.remove(e["path"])  # the wrapper writes a new file under the new pane id
        log(f"{pane}: {command}")
        subprocess.run([HERDR, "pane", "run", pane, command], check=False)


if __name__ == "__main__":
    main()
