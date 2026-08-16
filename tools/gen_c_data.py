#!/usr/bin/env python3
"""Generate cport/data/ C tables from the SAME source the JS port bundles.

Imports build_data() from port/tools/bundle.py — the function that assembles
the JS port's DATA object from the byte-verified data_extracted/ JSON — and
serialises the sim-relevant subset to C. Because both targets consume the
same function, the C tables cannot drift from the JS ones; regenerate after
any data fix.

Outputs:
  cport/data/colopy_data.h      extern declarations + struct typedefs
  cport/data/colopy_data.c      const definitions (flash-resident on Teensy)
  cport/host/fixtures.h         the .SAV test fixtures as byte arrays
  cport/data/MANIFEST.md        every DATA member: emitted or excluded + why

Serialisation rules (generic, so new DATA members flow through):
  str                 -> const char []
  list[str]           -> const char *const [N]
  list[int]           -> const int32_t [N]
  list[list[int]]     -> const int32_t [N][M]   (uniform M)
  list[list[str]]     -> const char *const [N][M]
  list[dict]          -> typedef struct + const array (int/str/bool/list[int]
                         fields; None -> NULL)
  dict[str -> str]    -> sorted key[]/val[] pair + count (bsearch by strcmp)
  dict[str -> other]  -> recurse with joined name (dat_yields_forested ...)
Inner lists of strings inside dicts are '\n'-joined to one string, mirroring
how GAME.TXT carried them and how the JS splits them back.
"""
import base64
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "port/tools"))
import bundle  # noqa: E402

OUT_DIR = ROOT / "cport/data"
HOST_DIR = ROOT / "cport/host"

# Render/present-only members: no game rule reads them. Everything else is
# emitted. Listed in the manifest with this reason.
EXCLUDE = {
    "palette": "render: VGA palette",
    "palettes": "render: per-screen palettes",
    "sheets": "render: sprite-sheet geometry",
    "fonts": "render: glyph atlases",
    "cycle": "render: palette-cycling animation",
    # "menus" moved to the UI unit (Phase 7 cluster C) — see UI_MEMBERS
    # briefings/cards/viceroy/myleader moved to TEXT_MEMBERS (Phase 9:
    # the briefing/king/cards boot screens render them on-board)
}
FIXTURES = {"sav1653", "savRaleigh", "savStart", "savNewColony"}

# Display-text members: the SIM never reads them -- only the future interface
# layer does, to render event/pedia/dialog bodies.  They are emitted into a
# SEPARATE translation unit (colopy_text.c) so the Teensy build can link it
# into flash OR leave it out and serve the same content from microSD; the
# host build always links it.  The sim sources must not reference these
# (enforced below).
TEXT_MEMBERS = {"events", "pedia", "dialogs", "text", "diplotext",
                "briefings", "cards", "viceroy", "myleader",
                "woodcuts", "scorenames"}

# Interface-layout members: consumed by the render layer (cport/render),
# never by the sim.  Emitted into their own unit (colopy_ui.c) so the sim
# link stays clean; the pulldown painter reads these tables.
UI_MEMBERS = {"menus"}


def cid(name):
    n = re.sub(r"[^A-Za-z0-9_]", "_", str(name)).lower()
    return "_" + n if n[0].isdigit() else n


def cstr(s):
    if s is None:
        return "NULL"
    out = s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
    # "??" opens a trigraph ("(????-1611)" in Hudson's pedia entry); "\?" is
    # the standard escape that breaks it.
    out = out.replace("?", "\\?")
    return '"%s"' % out


def is_strmapish(v):
    return all(isinstance(x, str) or
               (isinstance(x, list) and all(isinstance(e, str) for e in x))
               for x in v.values())


class Emitter:
    def __init__(self):
        self.h, self.c, self.manifest = [], [], []

    def emit(self, name, v):
        n = "dat_" + cid(name)
        if v is None:
            self._def("const char *const %s" % n, "NULL")
        elif isinstance(v, str):
            self._def("const char %s[]" % n, cstr(v))
        elif isinstance(v, bool):
            self._def("const uint8_t %s" % n, "1" if v else "0")
        elif isinstance(v, int):
            self._def("const int32_t %s" % n, str(v))
        elif isinstance(v, list):
            self._list(n, v)
        elif isinstance(v, dict):
            self._dict(name, n, v)
        else:
            raise SystemExit("unhandled type for %s: %r" % (name, type(v)))

    def _def(self, decl, val):
        self.h.append("extern " + decl + ";")
        self.c.append(decl + " = " + val + ";")

    def _count(self, n, k):
        self.h.append("#define %s_COUNT %d" % (n.upper(), k))

    def _list(self, n, v):
        if not v:
            # An empty list is legitimate data (e.g. a dialog with no tail
            # paragraph): count 0 and a NULL pointer, so C code that iterates
            # by _COUNT never dereferences it.
            self._count(n, 0)
            self.h.append("#define %s NULL" % n)
            return
        e = v[0]
        self._count(n, len(v))
        if all(isinstance(x, str) for x in v):
            self._def("const char *const %s[%d]" % (n, len(v)),
                      "{\n  " + ",\n  ".join(cstr(x) for x in v) + "\n}")
        elif all(isinstance(x, int) for x in v):
            self._def("const int32_t %s[%d]" % (n, len(v)),
                      "{" + ",".join(str(x) for x in v) + "}")
        elif isinstance(e, list) and all(isinstance(y, int) for x in v for y in x):
            m = len(e)
            assert all(len(x) == m for x in v), n + ": ragged int matrix"
            rows = ",\n  ".join("{" + ",".join(str(y) for y in x) + "}" for x in v)
            self._def("const int32_t %s[%d][%d]" % (n, len(v), m),
                      "{\n  " + rows + "\n}")
        elif isinstance(e, list) and all(isinstance(y, str) for x in v for y in x):
            m = max(len(x) for x in v)
            rows = ",\n  ".join(
                "{" + ",".join(cstr(y) for y in (x + [None] * (m - len(x)))) + "}"
                for x in v)
            self._def("const char *const %s[%d][%d]" % (n, len(v), m),
                      "{\n  " + rows + "\n}")
        elif isinstance(e, dict):
            self._structs(n, v)
        else:
            raise SystemExit("unhandled list shape: " + n)

    def _structs(self, n, v):
        keys = sorted(v[0])
        assert all(sorted(x) == keys for x in v), n + ": non-uniform dicts"
        ty = n + "_t"
        fields, fmt = [], []
        for k in keys:
            samples = [x[k] for x in v]
            if all(isinstance(s, bool) for s in samples):
                fields.append("uint8_t %s;" % cid(k))
                fmt.append(lambda s: "1" if s else "0")
            elif all(isinstance(s, int) for s in samples):
                fields.append("int32_t %s;" % cid(k))
                fmt.append(str)
            elif all(isinstance(s, str) or s is None for s in samples):
                fields.append("const char *%s;" % cid(k))
                fmt.append(cstr)
            elif all(isinstance(s, list) and
                     all(isinstance(y, int) for y in s) for s in samples):
                m = len(samples[0])
                assert all(len(s) == m for s in samples)
                fields.append("int32_t %s[%d];" % (cid(k), m))
                fmt.append(lambda s: "{" + ",".join(str(y) for y in s) + "}")
            elif all(isinstance(s, list) and
                     all(isinstance(y, str) for y in s) for s in samples):
                # inner string list -> one '\n'-joined string (GAME.TXT shape)
                fields.append("const char *%s;" % cid(k))
                fmt.append(lambda s: cstr("\n".join(s)))
            else:
                raise SystemExit("unhandled field %s.%s" % (n, k))
        self.h.append("typedef struct {\n  " + "\n  ".join(fields) + "\n} " + ty + ";")
        rows = ",\n  ".join(
            "{" + ", ".join(f(x[k]) for k, f in zip(keys, fmt)) + "}" for x in v)
        self._def("const %s %s[%d]" % (ty, n, len(v)),
                  "{\n  " + rows + "\n}")

    def _dict(self, name, n, v):
        if is_strmapish(v) and len(v) > 6:
            keys = sorted(v)
            self._count(n, len(keys))
            self._def("const char *const %s_keys[%d]" % (n, len(keys)),
                      "{\n  " + ",\n  ".join(cstr(k) for k in keys) + "\n}")
            vals = ["\n".join(v[k]) if isinstance(v[k], list) else v[k]
                    for k in keys]
            self._def("const char *const %s_vals[%d]" % (n, len(keys)),
                      "{\n  " + ",\n  ".join(cstr(x) for x in vals) + "\n}")
        else:
            for k in v:
                self.emit("%s_%s" % (name, k), v[k])


TX_LIT = re.compile(r'"(?:[^"\\\n]|\\.)*"')
TX_CHARARR = re.compile(r'^const char [A-Za-z0-9_]+\[\] = ')


def flashify_text(src):
    """Make the whole text unit flash-resident on the Teensy 4.x.

    Its linker copies every unmarked .rodata byte into DTCM RAM, and the
    ~127 KB of display strings do not fit beside the engine (caught on
    user hardware: DTCM overflow).  Every string literal moves into a
    named char array and every top-level definition gains COLOPY_TXMEM
    (= section .progmem on the IMXRT — kept in flash, read in place —
    and empty elsewhere, so host builds are unchanged: same bytes,
    named).  Duplicated strings pool to one array as a side effect. """
    pool, order = {}, []

    def to_sym(m):
        s = m.group(0)
        if s not in pool:
            pool[s] = "tx_s%d" % len(pool)
            order.append(s)
        return pool[s]

    out = []
    for ln in src.split("\n"):
        if ln.startswith(("#", "typedef", "/*", " *")):
            out.append(ln)
            continue
        if TX_CHARARR.match(ln):
            # a char ARRAY holds its bytes itself — tag, keep the literal
            out.append(ln.replace("] = ", "] COLOPY_TXMEM = ", 1))
            continue
        ln = TX_LIT.sub(to_sym, ln)
        if ln.startswith("const ") and " = " in ln:
            ln = ln.replace(" = ", " COLOPY_TXMEM = ", 1)
        out.append(ln)
    head = [
        "/* COLOPY_TXMEM: on the Teensy 4.x the linker copies .rodata to",
        " * DTCM; .progmem stays in the 8 MB program flash (memory-mapped,",
        " * read in place — no pgm_read_* needed on ARM). */",
        "#if defined(__IMXRT1062__)",
        '#define COLOPY_TXMEM __attribute__((section(".progmem")))',
        "#else",
        "#define COLOPY_TXMEM",
        "#endif",
        "",
        "/* the pooled string bytes */",
    ]
    head += ["static const char %s[] COLOPY_TXMEM = %s;" % (pool[s], s)
             for s in order]
    return "\n".join(head) + "\n\n" + "\n".join(out)


def emit_fixtures(D):
    lines = ["/* .SAV fixtures — generated by tools/gen_c_data.py. */",
             "#ifndef COLOPY_FIXTURES_H", "#define COLOPY_FIXTURES_H",
             "#include <stdint.h>", ""]
    for k in sorted(FIXTURES):
        raw = base64.b64decode(D[k])
        body = ",".join(str(b) for b in raw)
        lines.append("static const uint8_t %s[%d] = {%s};"
                     % (cid(k), len(raw), body))
    lines += ["", "#endif"]
    HOST_DIR.mkdir(parents=True, exist_ok=True)
    (HOST_DIR / "fixtures.h").write_text("\n".join(lines) + "\n")


def main():
    D, _man = bundle.build_data()
    # the map: tiles as bytes, w/h as defines
    em = Emitter()
    tx = Emitter()
    ui = Emitter()
    manifest = []
    for k in D:
        if k in FIXTURES:
            manifest.append((k, "fixture -> cport/host/fixtures.h"))
            continue
        if k in EXCLUDE:
            manifest.append((k, "EXCLUDED: " + EXCLUDE[k]))
            continue
        if k in UI_MEMBERS:
            # menus: 6 x {title, accel, rows[{label, accel|null, disabled}]}
            # flattened into dat_menus[] + dat_menu_rows[] (row_start/count)
            rows_flat = []
            menus_meta = []
            for mn in D[k]:
                menus_meta.append((mn["title"], mn["accel"] or "",
                                   len(rows_flat), len(mn["rows"])))
                for r in mn["rows"]:
                    rows_flat.append((r["label"], r.get("accel") or "",
                                      1 if r.get("disabled") else 0))
            ui.h.append("#define DAT_MENUS_COUNT %d" % len(menus_meta))
            ui.h.append("typedef struct {\n  const char *title;\n"
                        "  const char *accel;\n  int32_t row_start;\n"
                        "  int32_t row_count;\n} dat_menus_t;")
            ui.h.append("extern const dat_menus_t dat_menus[%d];"
                        % len(menus_meta))
            ui.h.append("#define DAT_MENU_ROWS_COUNT %d" % len(rows_flat))
            ui.h.append("typedef struct {\n  const char *label;\n"
                        "  const char *accel;\n  uint8_t disabled;\n"
                        "} dat_menu_rows_t;")
            ui.h.append("extern const dat_menu_rows_t dat_menu_rows[%d];"
                        % len(rows_flat))
            ui.c.append("const dat_menus_t dat_menus[%d] = {\n%s\n};" % (
                len(menus_meta),
                ",\n".join("  {%s, %s, %d, %d}" % (cstr(t), cstr(a), st, n)
                            for t, a, st, n in menus_meta)))
            ui.c.append("const dat_menu_rows_t dat_menu_rows[%d] = {\n%s\n};" % (
                len(rows_flat),
                ",\n".join("  {%s, %s, %d}" % (cstr(l), cstr(a), d)
                            for l, a, d in rows_flat)))
            manifest.append((k, "emitted -> colopy_ui.c (interface layout; "
                                "render-layer only)"))
            continue
        if k in TEXT_MEMBERS:
            tx.emit(k, D[k])
            # events/dialogs also get a runtime-keyed index table so the
            # render layer (Phase 7 dialog framework) can look a key up at
            # runtime — the per-key symbols alone are link-time only.
            if k in ("events", "dialogs") and isinstance(D[k], dict):
                keys = sorted(D[k])
                ty = "dat_%s_entry_t" % k
                tx.h.append("typedef struct {\n  const char *key;\n"
                            "  const char *const *body;\n  int32_t n_body;\n"
                            "  const char *const *tail;\n  int32_t n_tail;\n"
                            "  int32_t width;\n  const char *dflt;\n"
                            "  uint8_t small;\n} %s;" % ty)
                tx.h.append("#define DAT_%s_INDEX_COUNT %d"
                            % (k.upper(), len(keys)))
                tx.h.append("extern const %s dat_%s_index[%d];"
                            % (ty, k, len(keys)))
                rows_ = []
                for key in keys:
                    e = D[k][key]
                    sym = "dat_%s_%s" % (k, cid(key))
                    body = e.get("body") or []
                    tail = e.get("tail") or []
                    d = e.get("default")
                    rows_.append("  {%s, %s, %d, %s, %d, %d, %s, %d}" % (
                        cstr(key),
                        sym + "_body" if body else "NULL", len(body),
                        sym + "_tail" if tail else "NULL", len(tail),
                        int(e.get("width") or 0),
                        cstr(str(d)) if d is not None else "NULL",
                        1 if e.get("small") else 0))
                tx.c.append("const %s dat_%s_index[%d] = {\n%s\n};"
                            % (ty, k, len(keys), ",\n".join(rows_)))
            manifest.append((k, "emitted -> colopy_text.c (display text; "
                                "SD-able on Teensy)"))
            continue
        if k == "map":
            em.h.append("#define DAT_MAP_W %d" % D["map"]["w"])
            em.h.append("#define DAT_MAP_H %d" % D["map"]["h"])
            tiles = D["map"]["tiles"]
            em._def("const uint8_t dat_map_tiles[%d]" % len(tiles),
                    "{" + ",".join(str(t) for t in tiles) + "}")
            manifest.append((k, "emitted (uint8 tiles + W/H)"))
            continue
        em.emit(k, D[k])
        manifest.append((k, "emitted"))

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    guard = "COLOPY_DATA_H"
    (OUT_DIR / "colopy_data.h").write_text(
        "/* Generated by tools/gen_c_data.py — DO NOT hand-edit.\n"
        " * Source of truth: port/tools/bundle.py build_data() over\n"
        " * data_extracted/ (byte-verified). Regenerate after any data fix. */\n"
        "#ifndef %s\n#define %s\n#include <stdint.h>\n#include <stddef.h>\n\n"
        % (guard, guard) + "\n".join(em.h) + "\n\n#endif\n")
    (OUT_DIR / "colopy_data.c").write_text(
        "/* Generated by tools/gen_c_data.py — DO NOT hand-edit. */\n"
        '#include "colopy_data.h"\n\n' + "\n".join(em.c) + "\n")
    tguard = "COLOPY_TEXT_H"
    (OUT_DIR / "colopy_text.h").write_text(
        "/* Generated — DISPLAY TEXT ONLY (events/pedia/dialog bodies).\n"
        " * The sim never reads these; the interface layer does. On the\n"
        " * Teensy this unit may be left out of the link and the same\n"
        " * content served from microSD. */\n"
        "#ifndef %s\n#define %s\n#include <stdint.h>\n#include <stddef.h>\n\n"
        % (tguard, tguard) + "\n".join(tx.h) + "\n\n#endif\n")
    (OUT_DIR / "colopy_text.c").write_text(
        "/* Generated by tools/gen_c_data.py — DO NOT hand-edit. */\n"
        '#include "colopy_text.h"\n\n' + flashify_text("\n".join(tx.c)) + "\n")
    uguard = "COLOPY_UI_H"
    (OUT_DIR / "colopy_ui.h").write_text(
        "/* Generated — INTERFACE LAYOUT ONLY (pulldown menus). The sim\n"
        " * never reads these; the render layer (cport/render) does. */\n"
        "#ifndef %s\n#define %s\n#include <stdint.h>\n#include <stddef.h>\n\n"
        % (uguard, uguard) + "\n".join(ui.h) + "\n\n#endif\n")
    (OUT_DIR / "colopy_ui.c").write_text(
        "/* Generated by tools/gen_c_data.py — DO NOT hand-edit. */\n"
        '#include "colopy_ui.h"\n\n' + "\n".join(ui.c) + "\n")
    emit_fixtures(D)
    (OUT_DIR / "MANIFEST.md").write_text(
        "# DATA -> C manifest (generated)\n\n"
        "Every member of the JS port's DATA object and what the C build did\n"
        "with it. Nothing is dropped silently.\n\n| Member | Disposition |\n|---|---|\n"
        + "\n".join("| `%s` | %s |" % (k, d) for k, d in manifest) + "\n")
    print("emitted   :", sum(1 for _, d in manifest if d.startswith("emitted")))
    print("excluded  :", sum(1 for _, d in manifest if d.startswith("EXCLUDED")))
    print("fixtures  :", len(FIXTURES))
    # Guard: sim sources must not reach into the text unit, or the Teensy
    # build could not drop it.
    core = ROOT / "cport/core"
    text_syms = [l.split()[-1].split("[")[0].rstrip(";").lstrip("*")
                 for l in tx.h if l.startswith("extern")]
    offenders = []
    for cfile in sorted(core.glob("*.c")):
        body = cfile.read_text()
        for sym in text_syms:
            if sym and sym in body:
                offenders.append("%s uses %s" % (cfile.name, sym))
    if offenders:
        raise SystemExit("REFUSING TO WRITE: sim sources reference display "
                         "text:\n    " + "\n    ".join(offenders))

    for f in ("colopy_data.h", "colopy_data.c", "colopy_text.c"):
        print("-> %s  (%d KB)" % (OUT_DIR / f, (OUT_DIR / f).stat().st_size // 1024))


if __name__ == "__main__":
    main()
