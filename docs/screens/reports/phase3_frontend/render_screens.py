#!/usr/bin/env python3
"""Phase-3 render-and-diff: rebuild difficulty/nation screens from spec facts.

Spec sources:
  docs/FRONTEND_SCREENS_VICEROY_DECODE.md sect.3 (nation) / sect.4 (difficulty)
  docs/UI_AUDIT_TRACKER.md rows 10/11
Byte-cited facts used: PIK backgrounds full-screen (0,0,320,200); grid math
  difficulty: idx=i+1, x=(idx%3)*105+23, y=(idx//3)*96+7, cell 90x68 (AS WRITTEN)
  nation:     x=(i%2)*99+112, y=(i//2)*91+13, cell 82x88 (AS WRITTEN)
Everything font/ink/title-position related is TBD in the spec -> rendered from
flagged assumptions (see ASSUMPTIONS in report).
"""
import sys, struct
sys.path.insert(0, '/home/user/colopy/tools')
from ssdec import madspack_load
from pathlib import Path
import numpy as np
from PIL import Image

SCR = Path('/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad')
A = SCR / 'assets'

# ---------- loaders ----------
def load_pik(name):
    secs = madspack_load((A / f'{name}.PIK').read_bytes())
    pix = np.frombuffer(secs[1][1], np.uint8).reshape(200, 320).copy()
    pal6 = np.frombuffer(secs[2][1], np.uint8).reshape(256, 3).astype(int)
    return pix, pal6

def load_ff(name):
    secs = madspack_load((A / f'{name}.FF').read_bytes())
    pay = secs[0][1]
    H = pay[0]
    widths = pay[2:130]
    offs = struct.unpack_from('<128H', pay, 130)
    glyphs = {}
    for code in range(1, 129):
        j = code - 1
        w = widths[j]; off = offs[j]
        rb = (w * 2 + 7) // 8
        g = np.zeros((H, w), np.uint8)
        for r in range(H):
            for c in range(w):
                byte = pay[off + r * rb + (c * 2) // 8]
                g[r, c] = (byte >> (6 - (c * 2) % 8)) & 3
        glyphs[code] = g
    return dict(H=H, widths=widths, glyphs=glyphs)

def text_width(ff, s):
    return sum(ff['widths'][ord(ch) - 1] for ch in s)

def draw_text(img, ff, x, y, s, lut):
    """lut: dict level(1..3) -> palette index (None = skip)."""
    cx = x
    for ch in s:
        g = ff['glyphs'][ord(ch)]
        H, w = g.shape
        for r in range(H):
            for c in range(w):
                v = g[r, c]
                if v and lut.get(v) is not None:
                    yy, xx = y + r, cx + c
                    if 0 <= yy < 200 and 0 <= xx < 320:
                        img[yy, xx] = lut[v]
        cx += w
    return cx - x

def draw_text_shadow(img, ff, x, y, s, ink, shadow):
    """label style fitted vs reference: shadow at (1,0),(0,1),(1,1), ink on top"""
    for ox, oy in ((1, 0), (0, 1), (1, 1)):
        draw_text(img, ff, x + ox, y + oy, s, {1: shadow, 2: shadow, 3: shadow})
    draw_text(img, ff, x, y, s, {1: ink, 2: ink, 3: ink})

def rect_outline(img, x, y, w, h, color):
    x1 = min(x + w, 320); y1 = min(y + h, 200)   # clip (spec-as-written difficulty rect exceeds screen!)
    img[y, x:x1] = color
    if y + h - 1 < 200: img[y + h - 1, x:x1] = color
    img[y:y1, x] = color
    if x + w - 1 < 320: img[y:y1, x + w - 1] = color

def to_rgb(pix, pal6):
    pal8 = (pal6 << 2)
    return pal8[pix].astype(np.uint8)

def to565(rgb):
    q = rgb.astype(int).copy()
    q[..., 0] &= ~7; q[..., 2] &= ~7; q[..., 1] &= ~3
    return q

FT = load_ff('FONTTINY')
FI = load_ff('FONTINTR')

# ---------- difficulty screen ----------
def render_difficulty(cell_wh):
    pix, pal6 = load_pik('DIFFICUL')
    img = pix.copy()
    sel = 1  # Explorer, matches reference capture state (runtime value)
    # grid math (spec sect.4.3, B)
    idx = sel + 1
    cx = (idx % 3) * 105 + 23
    cy = (idx // 3) * 96 + 7
    w, h = cell_wh
    rect_outline(img, cx, cy, w, h, 9)          # ink idx 9 (ASSUMPTION: per-level ink, observed)
    # title (position/font/ink = ASSUMPTION; literals = LABELS.TXT @MISC 162/163)
    for line, ty in [('Choose', 16), ('Difficulty Level', 29)]:
        tw = text_width(FI, line)
        draw_text(img, FI, 58 - tw // 2, ty, line, {1: 254, 2: 253, 3: 0})
    # finish prompt (LABELS @MISC 161, parens ASSUMED from reference)
    s = '(Click Here When Finished)'
    tw = text_width(FT, s)
    draw_text(img, FT, 58 - tw // 2, 81, s, {1: 254})
    # selected-cell label = @DIFFICULTY row uppercased + ':' (ASSUMPTION: case/colon/pos)
    # + level descriptor = LABELS @MISC 166 'Easy' (row 164+1+sel)
    lab = 'EXPLORER:'
    tw = text_width(FT, lab)
    draw_text_shadow(img, FT, cx + (w - tw + 1) // 2 + 1, 45, lab, 9, 0)
    lab2 = 'Easy'
    tw2 = text_width(FT, lab2)
    draw_text_shadow(img, FT, cx + (w - tw2 + 1) // 2 + 1, 54, lab2, 9, 0)
    return img, pal6

# ---------- nation screen ----------
def render_nation(cell_wh):
    pix, pal6 = load_pik('NATIONS')
    img = pix.copy()
    sel = 0  # England, matches reference
    cx = (sel % 2) * 99 + 112
    cy = (sel // 2) * 91 + 13
    w, h = cell_wh
    rect_outline(img, cx, cy, w, h, 12)         # red idx 12 (ASSUMPTION: per-nation ink, observed)
    # nation name = @PICKNATION row uppercased + ':' , red ink + black shadow (ASSUMPTION)
    lab = 'ENGLAND:'
    tw = text_width(FT, lab)
    draw_text_shadow(img, FT, cx + (w - tw + 1) // 2 + 1, cy + 2, lab, 12, 0)
    # trait label at bottom (LABELS @MISC 173 'Immigration'; red ink black shadow ASSUMED)
    lab2 = 'Immigration'
    tw2 = text_width(FT, lab2)
    draw_text_shadow(img, FT, cx + (w - tw2 + 1) // 2, cy + h - 8, lab2, 12, 0)
    # titles (ASSUMPTION: pos/font/ink; literals LABELS @MISC 170/171)
    for line, ty in [('Select', 36), ('European Power', 49)]:
        tw = text_width(FI, line)
        draw_text(img, FI, 56 - tw // 2, ty, line, {1: 254, 2: 253, 3: 0})
    s = '(Click Here When Finished)'
    tw = text_width(FT, s)
    draw_text(img, FT, 57 - tw // 2, 182, s, {1: 254})
    return img, pal6

# ---------- diff machinery ----------
def compare(tag, img, pal6, refname, elements, cursor_rect=None):
    rgb = to_rgb(img, pal6)
    Image.fromarray(rgb).save(SCR / f'{tag}_render.png')
    ref = np.asarray(Image.open(SCR / refname)).astype(int)
    q = to565(rgb)
    d = np.abs(q - ref).sum(axis=2)
    if cursor_rect:  # mouse pointer in live capture; we do not render it
        x, y, w, h = cursor_rect
        d[y:y + h, x:x + w] = 0
    print(f'--- {tag}: global mean-abs-err(sumRGB) {d.mean():.3f}  identical {np.mean(d==0)*100:.2f}%')
    for name, (x, y, w, h) in elements.items():
        sub = d[y:y + h, x:x + w]
        print(f'    {name:34s} rect=({x},{y},{w},{h})  MAE {sub.mean():7.2f}  ident {np.mean(sub==0)*100:5.1f}%  maxerr {sub.max()}')
    # side-by-side with heat
    heat = np.zeros((200, 320, 3), np.uint8)
    hv = np.clip(d, 0, 255).astype(np.uint8)
    heat[..., 0] = hv
    heat[..., 1] = (hv // 4)
    sbs = np.concatenate([rgb, np.full((200, 4, 3), 255, np.uint8),
                          ref.astype(np.uint8), np.full((200, 4, 3), 255, np.uint8), heat], axis=1)
    Image.fromarray(sbs).resize((sbs.shape[1] * 2, 800), Image.NEAREST).save(SCR / f'{tag}_sidebyside.png')
    return d

if __name__ == '__main__':
    # spec-as-written cell sizes
    print('================ SPEC AS WRITTEN ================')
    img, pal = render_difficulty((90, 68))
    compare('difficulty_specWH', img, pal, 'ref_diff_native.png', {
        'highlight rect (spec w90 h68)': (233, 7, 90, 68),
        'cell region col2row0 (68x90)': (233, 7, 68, 90),
        'title area': (20, 14, 80, 26),
        'finish prompt': (10, 78, 96, 10),
        'label EXPLORER:': (248, 43, 40, 9),
        'background outside overlays': (0, 100, 200, 100),
    })
    img, pal = render_nation((82, 88))
    compare('nation_specWH', img, pal, 'ref_nat_native.png', {
        'highlight rect (spec w82 h88)': (112, 13, 82, 88),
        'cell region (88x82)': (112, 13, 88, 82),
        'title area': (15, 34, 85, 26),
        'finish prompt': (10, 179, 96, 10),
        'ENGLAND band': (113, 13, 86, 8),
        'Immigration label': (130, 85, 55, 10),
        'background outside overlays': (0, 100, 100, 75),
    })
    print('================ W/H SWAPPED (corrected hypothesis) ================')
    img, pal = render_difficulty((68, 90))
    compare('difficulty_render', img, pal, 'ref_diff_native.png', {
        'highlight rect (68x90)': (233, 7, 68, 90),
        'title line 1+2': (20, 14, 80, 26),
        'finish prompt': (10, 78, 96, 10),
        'label EXPLORER:': (244, 43, 50, 9),
        'label Easy (cursor-masked)': (250, 52, 40, 10),
        'bg row0 cell1 area': (128, 7, 68, 90),
        'bg row1 cells': (23, 103, 280, 90),
        'background left strip': (0, 100, 20, 100),
    }, cursor_rect=(255, 50, 21, 18))
    img, pal = render_nation((88, 82))
    compare('nation_render', img, pal, 'ref_nat_native.png', {
        'highlight rect (88x82)': (112, 13, 88, 82),
        'title line 1+2': (15, 34, 85, 26),
        'finish prompt': (10, 179, 96, 10),
        'label ENGLAND:': (135, 13, 55, 9),
        'label Immigration': (130, 85, 55, 10),
        'bg cell1 (France)': (211, 13, 88, 82),
        'bg cells 2+3 row': (112, 104, 187, 82),
        'background left strip': (0, 100, 100, 75),
    }, cursor_rect=(50, 80, 22, 18))
