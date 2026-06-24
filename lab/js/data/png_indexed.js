// png_indexed.js — decode a palette (color-type-3) PNG back to its INDEX plane.
//
// Why this exists: the bundle's atlas PNGs are written by the C++
// `write_png_indexed(... sheet.pal, SS_TRANSPARENT)`, so each pixel's stored
// value IS the game palette index (0xFD = transparent). The map compositor
// keys off those indices (index 0 = ocean cutout, 0xFD = land side), so a
// canvas2d RGBA decode is no good — we must recover the raw indices. The
// browser can't read PNG indices directly, so we parse the PNG ourselves:
// IHDR/PLTE/tRNS/IDAT → inflate (DecompressionStream) → un-filter → index plane.
//
// Returns { w, h, idx:Uint8Array(w*h), pal:Uint8Array(256*3), trns:Uint8Array(256) }.
// Only color type 3, bit depth 8 is supported (what the bundle emits) — anything
// else throws, loudly, rather than guessing.

function u32(b, o) { return (b[o] << 24 | b[o + 1] << 16 | b[o + 2] << 8 | b[o + 3]) >>> 0; }

async function inflate(bytes) {
  // PNG IDAT is zlib-wrapped deflate → DecompressionStream('deflate').
  const ds = new DecompressionStream('deflate');
  const stream = new Response(bytes).body.pipeThrough(ds);
  const buf = await new Response(stream).arrayBuffer();
  return new Uint8Array(buf);
}

// Reconstruct scanlines for color-type-3 depth-8 (1 byte/pixel → bpp=1).
function unfilter(raw, w, h) {
  const stride = w;            // 1 byte per pixel
  const out = new Uint8Array(w * h);
  let pos = 0;
  for (let y = 0; y < h; y++) {
    const ft = raw[pos++];     // per-scanline filter type
    const row = out.subarray(y * stride, y * stride + stride);
    const prev = y > 0 ? out.subarray((y - 1) * stride, (y - 1) * stride + stride) : null;
    for (let x = 0; x < stride; x++) {
      const v = raw[pos++];
      const a = x >= 1 ? row[x - 1] : 0;        // bpp = 1
      const b = prev ? prev[x] : 0;
      const c = prev && x >= 1 ? prev[x - 1] : 0;
      let r;
      switch (ft) {
        case 0: r = v; break;                    // None
        case 1: r = v + a; break;                // Sub
        case 2: r = v + b; break;                // Up
        case 3: r = v + ((a + b) >> 1); break;   // Average
        case 4: {                                // Paeth
          const p = a + b - c, pa = Math.abs(p - a), pb = Math.abs(p - b), pc = Math.abs(p - c);
          r = v + (pa <= pb && pa <= pc ? a : pb <= pc ? b : c); break;
        }
        default: throw new Error(`PNG: bad filter type ${ft} at row ${y}`);
      }
      row[x] = r & 0xff;
    }
  }
  return out;
}

export async function decodeIndexedPNG(url) {
  const ab = await (await fetch(url)).arrayBuffer();
  const d = new Uint8Array(ab);
  const SIG = [137, 80, 78, 71, 13, 10, 26, 10];
  for (let i = 0; i < 8; i++) if (d[i] !== SIG[i]) throw new Error(`${url}: not a PNG`);

  let w = 0, h = 0, bitDepth = 0, colorType = 0;
  const pal = new Uint8Array(256 * 3);
  const trns = new Uint8Array(256).fill(255);
  const idatParts = [];
  let p = 8;
  while (p < d.length) {
    const len = u32(d, p), type = String.fromCharCode(d[p + 4], d[p + 5], d[p + 6], d[p + 7]);
    const body = p + 8;
    if (type === 'IHDR') {
      w = u32(d, body); h = u32(d, body + 4); bitDepth = d[body + 8]; colorType = d[body + 9];
    } else if (type === 'PLTE') {
      for (let i = 0; i < len; i++) pal[i] = d[body + i];
    } else if (type === 'tRNS') {
      for (let i = 0; i < len; i++) trns[i] = d[body + i];
    } else if (type === 'IDAT') {
      idatParts.push(d.subarray(body, body + len));
    } else if (type === 'IEND') break;
    p = body + len + 4;       // +4 CRC
  }
  if (colorType !== 3 || bitDepth !== 8)
    throw new Error(`${url}: expected indexed 8-bit PNG (got colorType=${colorType} depth=${bitDepth})`);

  // Concatenate IDAT, inflate, un-filter.
  let total = 0; for (const c of idatParts) total += c.length;
  const comp = new Uint8Array(total);
  let off = 0; for (const c of idatParts) { comp.set(c, off); off += c.length; }
  const raw = await inflate(comp);
  const idx = unfilter(raw, w, h);
  return { w, h, idx, pal, trns };
}
