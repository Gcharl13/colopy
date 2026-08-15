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
    "menus": "interface: pulldown layout/accelerators (menu ACTIONS are core commands, defined in colopy_core.h)",
    "briefings": "interface: intro briefing text",
    "cards": "interface: score-card art captions",
    "viceroy": "interface: title strings",
    "myleader": "interface: name-entry prompts",
}
FIXTURES = {"sav1653", "savRaleigh", "savStart", "savNewColony"}


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
    manifest = []
    for k in D:
        if k in FIXTURES:
            manifest.append((k, "fixture -> cport/host/fixtures.h"))
            continue
        if k in EXCLUDE:
            manifest.append((k, "EXCLUDED: " + EXCLUDE[k]))
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
    emit_fixtures(D)
    (OUT_DIR / "MANIFEST.md").write_text(
        "# DATA -> C manifest (generated)\n\n"
        "Every member of the JS port's DATA object and what the C build did\n"
        "with it. Nothing is dropped silently.\n\n| Member | Disposition |\n|---|---|\n"
        + "\n".join("| `%s` | %s |" % (k, d) for k, d in manifest) + "\n")
    print("emitted   :", sum(1 for _, d in manifest if d.startswith("emitted")))
    print("excluded  :", sum(1 for _, d in manifest if d.startswith("EXCLUDED")))
    print("fixtures  :", len(FIXTURES))
    for f in ("colopy_data.h", "colopy_data.c"):
        print("-> %s  (%d KB)" % (OUT_DIR / f, (OUT_DIR / f).stat().st_size // 1024))


if __name__ == "__main__":
    main()
