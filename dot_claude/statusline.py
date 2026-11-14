import glob
import json
import os
import subprocess
import sys

CAVEMAN_GLOB = os.path.expanduser("~/.claude/plugins/cache/caveman/caveman/*/**/caveman-statusline.sh")

raw = sys.stdin.read()

base = ""
caveman = sorted(glob.glob(CAVEMAN_GLOB, recursive=True), key=os.path.getmtime)
if caveman:
    try:
        base = subprocess.run(
            ["bash", caveman[-1]], input=raw, capture_output=True, text=True, timeout=2
        ).stdout.strip()
    except Exception:
        pass


def fmt(n):
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M"
    if n >= 1000:
        return f"{n / 1000:.0f}k"
    return str(int(n))


ctx = ""
try:
    window = json.loads(raw).get("context_window") or {}
    size = window.get("context_window_size")
    if size:
        pct = window.get("used_percentage") or 0
        used = window.get("total_input_tokens") or 0
        color = "\033[91m" if used > 140_000 else "\033[92m"
        ctx = f"{color}{pct:.0f}% ({fmt(used)}/{fmt(size)})\033[0m"
except Exception:
    pass

print(" | ".join(part for part in (base, ctx) if part), end="")
