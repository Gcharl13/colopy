#!/usr/bin/env python3
"""Generate a complete, searchable HTML catalog of EVERY GAME.TXT event/message
in VICEROY.EXE, joined with its emitter function and auto-categorised by domain.

Inputs : COLONIZE/GAME.TXT, tools/rtlink/event_emitters.json
Outputs: viceroy_source/docs/event_catalog.html, viceroy_source/docs/event_catalog.json
"""
import json, os, re, html
HERE = os.path.dirname(__file__)
GAME = os.path.join(HERE, "..", "..", "raw", "COLONIZE", "GAME.TXT")
EMIT = os.path.join(HERE, "event_emitters.json")
OUTDIR = os.path.join(HERE, "..", "..", "viceroy_source", "docs")

# ---- parse GAME.TXT into ordered [(key, message_text)] -----------------------
def parse_game():
    txt = open(GAME, encoding="utf-8", errors="replace").read().split("\n")
    out, key, buf = [], None, []
    DIR = re.compile(r"^@(width|height|align|x|y)\b")
    for line in txt:
        m = re.match(r"^@([A-Z][A-Z0-9_]+)\s*$", line)
        if m:
            if key is not None:
                out.append((key, "\n".join(buf).strip()))
            key, buf = m.group(1), []
        elif key is not None:
            if DIR.match(line):
                continue
            buf.append(line)
    if key is not None:
        out.append((key, "\n".join(buf).strip()))
    return out

# ---- categorisation ----------------------------------------------------------
CATS = [
 ("King, Taxes & Revolution", "king",
  r"KING|TORY|REBEL|REVOLUT|INDEPEND|SUCCESSION|SEIZURE|INVASION|INTERVEN|MERCENAR|MOBILIZE|CONTINENTAL|EXPEDITION|\bTAX|BOYCOTT|TEAPARTY|PARLIAMENT|CROWN|UTRECHT|DECLARE|MAJORITY|MULTIREV|SCREWED|EXPLOITS|FRIEND|REDCOAT"),
 ("Natives", "native",
  r"INDIAN|TRIBE|VILLAGE|MISSION|CONVERT|BURIAL|CHIEF|BRAVE|SCALP|TENSION|RAID|NATIVE|TEPEE|LONGHOUSE|POWHATAN|CHEROKEE|IROQUOIS|AZTEC|INCA|TUPI|ARAWAK|SIOUX|APACHE|CHIEFKILL|DEMAND|ATTACK.*VILLAGE|SKELET"),
 ("Combat & Siege", "combat",
  r"COMBAT|ATTACK|SIEGE|AMBUSH|DEFEAT|CAPTUR|DEMOTE|PROMOTE|ARTILLERY|DAMAGED|SUNK|BOMBARD|RETREAT|WOUNDED|FORTRESS|BATTLE|PIRATE|PRIVATEER|HOSTIL"),
 ("Exploration & Lost Cities", "explore",
  r"RUMOR|RUMOUR|FOUNTAIN|CIBOLA|RUINS|TREASURE|SURVIVOR|LEARNED|EXPLOR|CHEST|GRAVE|FRINGE|NOTHING|VANISH|TRINKET|MOUNDS|DESERT|SEASONED|MAPS"),
 ("Founding Fathers", "ff",
  r"FATHER|CONGRESS|FOUNDING|STATESMAN|\bELECT|JEFFERSON|FRANKLIN|WASHINGTON|REVERE|SMITH|BOLIVAR|POCAHONTAS|MINUIT|BREWSTER|STUYVESANT|MAGELLAN|CORONADO|\bFF\b"),
 ("Europe, Docks & Trade", "europe",
  r"EUROPE|DOCK|RECRUIT|MERCANTIL|\bPRICE|MARKET|GALLEON|IMMIGRA|RELIGIOUS|DUES|EMIGRA|WHARF|CUSTOM|CARGO|SHIP|SAIL|PORT|MERCHANT|GOODS|MANUFACT|TRADEMERC"),
 ("Colony & Buildings", "colony",
  r"COLONY|BUILD|BUILT|WAREHOUSE|STOCKADE|\bFORT|STARV|\bFOOD|\bBELL|\bCROSS|HAMMER|TEACHER|COLLEGE|UNIVERSITY|\bTRAIN|SONS|LIBERTY|FACTORY|SCHOOL|RENAME|ABANDON|UNREST|FULL|TEACH|PRODUCT|CITY|LANDFALL|LANDHO"),
 ("Units & Movement", "unit",
  r"\bUNIT|\bMOVE|PIONEER|SCOUT|SOLDIER|DRAGOON|WAGON|COLONIST|VETERAN|HARDY|EXPERT|ELDER|FIREBRAND|CLEAR|PLOW|ROAD|DISBAND|FORTIFY|SENTRY"),
 ("Score & Endgame", "score",
  r"SCORE|RETIRE|VICEROY|HALLFAME|\bRANK|CONGRATU|FAME"),
 ("Setup, Menus & System", "sys",
  r"^DOS|MENU|SAVE|LOAD|OPTION|NATION|DIFFICULTY|LEADER|MULTI|BEGIN|\bMAP|TUTORIAL|AMERICA|PICK|YES|^NO$|QUIT|ABORT|ERROR|DISK|SOUND|GAMEOPT"),
]
def categorise(key, text):
    """Key-name is the reliable signal; fall back to message text only if the
    key matches nothing (avoids over-greedy text matches)."""
    ku = key.upper()
    for name, cls, pat in CATS:        # pass 1: match on the @KEY name
        if re.search(pat, ku):
            return name, cls
    hay = text.upper()
    for name, cls, pat in CATS:        # pass 2: weak text fallback
        if re.search(pat, hay):
            return name, cls
    return "Miscellaneous", "misc"

# ---- enriched (deeply byte-verified) overrides -------------------------------
ENRICH = {
 "SUCCESSION": dict(trigger="Single-player; 2+ European powers; chosen by the per-turn European-politics check, shown via dispatcher func_0235D6",
   inputs="Each crown's weighted strength score; multiplayer flag",
   outputs="Strongest crown ANNEXES the weakest crown's New World colonies"),
 "DECLARE": dict(trigger="Player chooses 'Declare Independence'",
   inputs="National rebel-sentiment % (Sons of Liberty); multiplayer flag",
   outputs="If support >= 50% & single-player -> confirm -> declaration; else blocked"),
 "TOOTORY": dict(trigger="Declare-independence attempt with rebel sentiment below 50%",
   inputs="National rebel-sentiment %", outputs="Blocks the declaration (need the majority)"),
 "INDEPENDENCE": dict(trigger="Confirmed declaration (after the 50% gate)",
   inputs="Active power; king state", outputs="King dispatches the Royal Expeditionary Force; war begins"),
 "KINGTAX": dict(trigger="Periodic Crown demand (king-anger driven)",
   inputs="Current tax rate; king anger", outputs="Raises your tax rate by N%"),
 "KINGBUY": dict(trigger="Rebel sentiment grows (pre/during war)",
   inputs="Difficulty; current REF; rebel sentiment", outputs="Adds units to the Royal Expeditionary Force"),
}

def _dehex(s):
    """Strip any hex addresses / '(string handle 0xNNNN)' provenance tags from a
    displayed value (the catalog must be address-free)."""
    if not isinstance(s, str):
        return s
    s = re.sub(r"\s*\((?:string(?:\s+handle)?|str|@?asm|handle|offset|file)?[^()]*0x[0-9A-Fa-f]+[^()]*\)", "", s)
    s = re.sub(r"\s*0x[0-9A-Fa-f]{2,}", "", s)
    return re.sub(r"\s{2,}", " ", s).strip()

def load_enrich():
    """Merge the inline seeds with every docs/enrich/*.json the tracing agents
    produce.  Each file is {KEY: {trigger, inputs, outputs[, func, verified]}}.
    Metadata keys (leading '_') are skipped; values are de-hexed defensively."""
    merged = dict(ENRICH)
    d = os.path.join(OUTDIR, "enrich")
    if os.path.isdir(d):
        import glob as _g
        for p in sorted(_g.glob(os.path.join(d, "*.json"))):
            try:
                for k, v in json.load(open(p, encoding="utf-8")).items():
                    if k.startswith("_") or not isinstance(v, dict):
                        continue
                    for f in ("trigger", "inputs", "outputs"):
                        if f in v:
                            v[f] = _dehex(v[f])
                    merged[k.lstrip("@").upper()] = v
            except Exception as e:
                print(f"  WARN: {os.path.basename(p)}: {e}")
    return merged

def first_line(text):
    for ln in text.split("\n"):
        ln = ln.strip()
        if ln and not ln.startswith("@"):
            return ln
    return "(no text)"

def build():
    events = parse_game()
    emap = json.load(open(EMIT))
    enrich = load_enrich()
    cat_counts, rows, n_enriched = {}, [], 0
    for key, text in events:
        cat, cls = categorise(key, text)
        cat_counts[cat] = cat_counts.get(cat, 0) + 1
        em = emap.get(key, {}).get("emitters", [])
        func = em[0]["func"] if em else None
        page = em[0]["page"] if em else None
        reach = em[0]["reachable"] if em else None
        e = enrich.get(key.upper())
        if e:
            n_enriched += 1
        rows.append(dict(key=key, cat=cat, cls=cls, text=text, summary=first_line(text),
                         func=func, page=page, reachable=reach, enrich=e))
    rows.sort(key=lambda r: (r["cat"], r["key"]))
    n_emit = sum(1 for r in rows if r["func"])
    # JSON dump
    json.dump([{k: r[k] for k in ("key", "cat", "func", "page", "reachable", "summary")} for r in rows],
              open(os.path.join(OUTDIR, "event_catalog.json"), "w"), indent=1)
    # HTML
    chips = "".join(f'<button class="chip" data-cat="{html.escape(c)}">{html.escape(c)} <em>{n}</em></button>'
                    for c, n in sorted(cat_counts.items()))
    cards = []
    for r in rows:
        fn = (f'<span class="fn mono">{html.escape(r["func"])}</span>' if r["func"]
              else '<span class="fn mono none">UI / no traced emitter</span>')
        disp = ''
        if r["func"] and r["reachable"] is False:
            disp = '<span class="badge disp" title="reached only through the report/event dispatcher func_0235D6">dispatch-only</span>'
        en = ''
        vbadge = ''
        if r["enrich"]:
            e = r["enrich"]
            ver = e.get("verified")
            vbadge = ('<span class="badge ver">byte-verified</span>' if ver
                      else '<span class="badge inf">from message</span>')
            en = ('<div class="kv"><b>Trigger</b> ' + html.escape(e.get("trigger", "")) + '</div>'
                  '<div class="kv"><b>Inputs</b> ' + html.escape(e.get("inputs", "")) + '</div>'
                  '<div class="kv"><b>Outputs</b> ' + html.escape(e.get("outputs", "")) + '</div>')
        msg = html.escape(r["text"])[:600]
        cards.append(
          f'<div class="card {r["cls"]}" data-cat="{html.escape(r["cat"])}" '
          f'data-text="{html.escape((r["key"]+" "+r["summary"]+" "+(r["func"] or "")).lower())}">'
          f'{fn}<div class="role">{html.escape(r["summary"])[:90]}</div>'
          f'<div class="kv"><b>Event</b> <span class="tag">@{html.escape(r["key"])}</span> '
          f'<span class="cat-badge {r["cls"]}">{html.escape(r["cat"])}</span>{disp}{vbadge}</div>'
          f'{en}<pre class="msg">{msg}</pre></div>')
    htmlout = TEMPLATE.replace("{{CHIPS}}", chips).replace("{{CARDS}}", "\n".join(cards)) \
                      .replace("{{TOTAL}}", str(len(rows))).replace("{{NEMIT}}", str(n_emit)) \
                      .replace("{{NENRICH}}", str(n_enriched))
    open(os.path.join(OUTDIR, "event_catalog.html"), "w", encoding="utf-8").write(htmlout)
    print(f"events={len(rows)}  with-emitter={n_emit}  enriched(trigger/IO)={n_enriched}")
    for c, n in sorted(cat_counts.items(), key=lambda x: -x[1]):
        print(f"  {c}: {n}")

TEMPLATE = r"""<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>VICEROY.EXE - Complete Event Catalog</title>
<style>
:root{--bg:#0d1117;--panel:#161b22;--panel2:#1c2330;--ink:#e6edf3;--muted:#9aa7b4;--line:#30363d;--accent:#58a6ff}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font:14px/1.5 -apple-system,Segoe UI,Roboto,Arial,sans-serif}
.wrap{max-width:1280px;margin:0 auto;padding:24px 20px 80px}
h1{font-size:26px;margin:0 0 4px}.sub{color:var(--muted);margin:0 0 14px}
a{color:var(--accent)}code,.mono{font-family:ui-monospace,Consolas,monospace;font-size:.86em}
.bar{position:sticky;top:0;background:rgba(13,17,23,.96);backdrop-filter:blur(6px);padding:12px 0;border-bottom:1px solid var(--line);z-index:5}
#q{width:100%;padding:9px 12px;background:var(--panel);border:1px solid var(--line);border-radius:8px;color:var(--ink);font-size:15px}
.chips{display:flex;flex-wrap:wrap;gap:7px;margin-top:10px}
.chip{background:var(--panel2);border:1px solid var(--line);color:var(--muted);border-radius:20px;padding:4px 11px;font-size:12.5px;cursor:pointer}
.chip em{color:var(--accent);font-style:normal}.chip.on{background:#243049;color:#fff;border-color:#3b537e}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(310px,1fr));gap:12px;margin-top:16px}
.card{background:var(--panel);border:1px solid var(--line);border-radius:10px;padding:12px 14px;border-left:3px solid #444}
.card.king{border-left-color:#f85149}.card.native{border-left-color:#d2a8ff}.card.combat{border-left-color:#ff7b72}
.card.explore{border-left-color:#39c5cf}.card.ff{border-left-color:#e3b341}.card.europe{border-left-color:#a5d6ff}
.card.colony{border-left-color:#3fb950}.card.unit{border-left-color:#79c0ff}.card.score{border-left-color:#ffa657}.card.sys{border-left-color:#6e7681}.card.misc{border-left-color:#8b949e}
.role{font-weight:600;margin:2px 0 4px}.fn{float:right;color:var(--muted);font-size:11px}.fn.none{color:#5a636e}
.kv{margin:4px 0;font-size:13px}.kv b{color:var(--accent);min-width:58px;display:inline-block}
.tag{background:var(--panel2);border:1px solid var(--line);border-radius:5px;padding:0 6px;font-size:11.5px;color:var(--muted)}
.cat-badge{font-size:11px;color:var(--muted)}.badge{border-radius:5px;padding:0 6px;font-size:11px;margin-left:4px}
.badge.disp{background:#3a1d1d;border:1px solid #6b2b2b;color:#ffb4ab}
.badge.ver{background:#10261a;border:1px solid #1f5133;color:#7ee2a8}
.badge.inf{background:#2a2410;border:1px solid #5a4d1c;color:#e8d48a}
.msg{margin:8px 0 0;padding:7px 9px;background:#0b1722;border:1px solid #1b2a3a;border-radius:6px;color:#bcd;white-space:pre-wrap;font-size:12px;max-height:120px;overflow:auto}
.count{color:var(--muted);font-size:13px;margin-top:12px}
</style></head><body><div class="wrap">
<h1>Sid Meier&rsquo;s Colonization &mdash; Complete Event Catalog</h1>
<p class="sub">Every message/event in <code>GAME.TXT</code> ({{TOTAL}} total; {{NEMIT}} traced to an emitter
function; {{NENRICH}} with verified trigger/inputs/outputs). Plain-English, address-free. See the
process-flow diagrams in <a href="event_flow.html">event_flow.html</a>, or the whole-game
<a href="event_graph.html"><b>interactive network</b></a> (events wired to the state they read/write).
Built from <code>VICEROY.EXE</code>.</p>
<div class="bar">
  <input id="q" placeholder="Search events by name, message, or function&hellip;" autocomplete="off">
  <div class="chips" id="chips"><button class="chip on" data-cat="*">All</button>{{CHIPS}}</div>
</div>
<div class="count" id="count"></div>
<div class="grid" id="grid">{{CARDS}}</div>
</div><script>
const grid=document.getElementById('grid'),q=document.getElementById('q'),count=document.getElementById('count');
const cards=[...grid.children];let cat='*';
function apply(){const s=q.value.trim().toLowerCase();let n=0;
 for(const c of cards){const okC=cat==='*'||c.dataset.cat===cat;
  const okS=!s||c.dataset.text.includes(s)||c.querySelector('.msg').textContent.toLowerCase().includes(s);
  const show=okC&&okS;c.style.display=show?'':'none';if(show)n++;}
 count.textContent=n+' events shown';}
document.getElementById('chips').addEventListener('click',e=>{const b=e.target.closest('.chip');if(!b)return;
 cat=b.dataset.cat;[...document.querySelectorAll('.chip')].forEach(x=>x.classList.toggle('on',x===b));apply();});
q.addEventListener('input',apply);apply();
</script></body></html>"""

if __name__ == "__main__":
    build()
