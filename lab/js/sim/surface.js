// sim/surface.js — an indexed framebuffer, the JS twin of surface.hpp.
//
// The DOS game renders into ONE 256-colour indexed surface (mode 13h) with a
// single active palette; we mirror that. The compositor writes palette INDICES
// (0xFD = transparent, skipped on blit); we resolve to RGB only at the end via
// the active palette — exactly the C++ `Surface` → `to_rgb`. Size is a ctor
// param so the lab can composite an entire map (not just the 320×200 screen).

import { SS_TRANSPARENT } from './sheet.js';

export class Surface {
  constructor(w, h, clear = 0) {
    this.w = w; this.h = h;
    this.idx = new Uint8Array(w * h).fill(clear);
  }

  put(x, y, color) {
    if (x < 0 || y < 0 || x >= this.w || y >= this.h) return;
    this.idx[y * this.w + x] = color;
  }

  fillRect(x, y, w, h, color) {
    for (let yy = y; yy < y + h; yy++)
      for (let xx = x; xx < x + w; xx++) this.put(xx, yy, color);
  }

  rectOutline(x, y, w, h, color) {
    for (let i = 0; i < w; i++) { this.put(x + i, y, color); this.put(x + i, y + h - 1, color); }
    for (let i = 0; i < h; i++) { this.put(x, y + i, color); this.put(x + w - 1, y + i, color); }
  }

  // Blit an indexed frame at (dx,dy); skip transparent pixels (= C++ blit_frame).
  blitFrame(f, dx, dy) {
    for (let y = 0; y < f.h; y++)
      for (let x = 0; x < f.w; x++) {
        const p = f.px[y * f.w + x];
        if (p === SS_TRANSPARENT) continue;
        this.put(dx + x, dy + y, p);
      }
  }

  // Resolve to an ImageData using a 256×3 palette (index 0xFD shown as the
  // palette's own colour — the surface never leaves a 0xFD pixel since clear=0).
  toImageData(pal) {
    const img = new ImageData(this.w, this.h);
    const d = img.data;
    for (let i = 0; i < this.idx.length; i++) {
      const c = this.idx[i] * 3, o = i * 4;
      d[o] = pal[c]; d[o + 1] = pal[c + 1]; d[o + 2] = pal[c + 2]; d[o + 3] = 255;
    }
    return img;
  }
}
