#!/usr/bin/env python3
"""churn_metric.py — measure the re-litigation loop so we can see it shrink.

The project's problem is churn: the same facts decided, corrected, and re-decided. This
prints a few blunt numbers and a per-week trend, so "are we still looping?" stops being a
feeling and becomes a line that should go DOWN.

Metrics:
  - RULINGS.md entries per ISO week (dated `## YYYY-MM-DD` headers).
  - "correction-language" ruling entries (superseded/overturned/corrected/was wrong/revert/
    stale/misdiagnos/false negative/burned).
  - git commits per week whose subject carries fix/revert/correct/wrong/stale.
  - current static surface: TBD count, doc line count, doc file count.

Run: python3 tools/churn_metric.py
"""
import os
import re
import subprocess
import sys
from collections import Counter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RULINGS = os.path.join(ROOT, "notes/rulings/RULINGS.md")
DOC_DIRS = ["docs", "spec", "notes"]
CHURN_WORDS = re.compile(
    r"supersed|overturn|corrected|was wrong|\brevert|stale|misdiagnos|false negative|burned",
    re.I)
COMMIT_CHURN = re.compile(r"\b(fix|revert|correct|wrong|stale|regress)", re.I)


def iso_week(date):  # 'YYYY-MM-DD' -> 'YYYY-Www'
    import datetime
    y, m, d = (int(x) for x in date.split("-"))
    return "%04d-W%02d" % datetime.date(y, m, d).isocalendar()[:2]


def rulings_by_week():
    if not os.path.exists(RULINGS):
        return Counter(), Counter(), 0
    per_week, churn_week = Counter(), Counter()
    total = 0
    cur = None
    body = []
    text = open(RULINGS, encoding="utf-8", errors="replace").read()
    # split into entries on dated headers
    for line in text.splitlines():
        m = re.match(r"^##\s+(\d{4}-\d{2}-\d{2})", line)
        if m:
            if cur:
                wk = iso_week(cur)
                per_week[wk] += 1
                if CHURN_WORDS.search("\n".join(body)):
                    churn_week[wk] += 1
            cur = m.group(1)
            body = []
            total += 1
        else:
            body.append(line)
    if cur:
        wk = iso_week(cur)
        per_week[wk] += 1
        if CHURN_WORDS.search("\n".join(body)):
            churn_week[wk] += 1
    return per_week, churn_week, total


def commits_by_week():
    try:
        out = subprocess.check_output(
            ["git", "log", "--no-merges", "--date=short", "--pretty=%ad\t%s"],
            cwd=ROOT, text=True, errors="replace")
    except Exception:
        return Counter(), Counter()
    per_week, churn_week = Counter(), Counter()
    for line in out.splitlines():
        if "\t" not in line:
            continue
        date, subj = line.split("\t", 1)
        try:
            wk = iso_week(date)
        except Exception:
            continue
        per_week[wk] += 1
        if COMMIT_CHURN.search(subj):
            churn_week[wk] += 1
    return per_week, churn_week


def static_surface():
    tbd = 0
    lines = 0
    files = 0
    for d in DOC_DIRS:
        base = os.path.join(ROOT, d)
        for dirpath, _, names in os.walk(base):
            if os.sep + "archive" in dirpath:   # archived docs don't count against the surface
                continue
            for n in names:
                if not n.endswith(".md"):
                    continue
                files += 1
                p = os.path.join(dirpath, n)
                try:
                    t = open(p, encoding="utf-8", errors="replace").read()
                except Exception:
                    continue
                lines += t.count("\n") + 1
                tbd += len(re.findall(r"\bTBD\b", t))
    return tbd, lines, files


def main():
    rper, rchurn, rtotal = rulings_by_week()
    cper, cchurn = commits_by_week()
    tbd, lines, files = static_surface()

    weeks = sorted(set(rper) | set(cper))
    print("== churn by ISO week (recent last) ==")
    print("%-9s %8s %8s %9s %9s" % ("week", "rulings", "r-churn", "commits", "c-churn"))
    for wk in weeks[-10:]:
        print("%-9s %8d %8d %9d %9d" % (wk, rper[wk], rchurn[wk], cper[wk], cchurn[wk]))

    print("\n== static surface (excludes docs/**/archive) ==")
    print("  RULINGS entries (all time): %d" % rtotal)
    print("  open TBDs:                  %d" % tbd)
    print("  doc lines (docs+spec+notes):%d" % lines)
    print("  doc files:                  %d" % files)
    print("\nGoal: rulings/r-churn/c-churn trend DOWN; TBD + doc lines/files shrink as the\n"
          "Ghidra decode retires guesses and the consolidation archives duplicates.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
