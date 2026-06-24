// sim/sheet.js — load a bundle sheet as INDEXED frames, exactly like the C++
// `load_bundle` (bundle.cpp): decode the atlas PNG to its index plane, then cut
// each frame's w×h index block out of the atlas at (ax,ay). The result is a
// Sheet whose frames carry raw palette indices — the same `Frame.px` the C++
// compositor reads — so the lab can run the real layered render, not a recolor.

import { loadSheetFrames, sheetImageURL } from '../data/loaders.js';
import { decodeIndexedPNG } from '../data/png_indexed.js';

export const SS_TRANSPARENT = 0xFD;   // 253 — ss.hpp

// loadSheet(name) -> { nframes, atlas:{w,h}, pal:Uint8Array(768), trns,
//                      frames:[{i,x,y,w,h,ax,ay, px:Uint8Array(w*h)}] }
export async function loadSheet(name) {
  const meta = await loadSheetFrames(name);          // {sheet,nframes,atlas,frames}
  const png = await decodeIndexedPNG(sheetImageURL(name));

  const frames = new Array(meta.nframes);
  for (const f of meta.frames) {
    const px = new Uint8Array(f.w * f.h).fill(SS_TRANSPARENT);
    for (let y = 0; y < f.h; y++) {
      const ay = f.ay + y;
      if (ay < 0 || ay >= png.h) continue;
      for (let x = 0; x < f.w; x++) {
        const ax = f.ax + x;
        if (ax < 0 || ax >= png.w) continue;
        px[y * f.w + x] = png.idx[ay * png.w + ax];
      }
    }
    frames[f.i] = { ...f, px };
  }
  return { nframes: meta.nframes, atlas: meta.atlas, pal: png.pal, trns: png.trns, frames };
}
