// sim/compose.js — paint a full map onto a canvas via the M3 pipeline (indexed
// Surface → terrain_compose every tile → resolve through PHYS0's palette). Shared
// by the Map tab (AMER2) and the World Gen tab (generated maps) so both render
// through the exact same byte-faithful compositor.
import { Surface } from './surface.js';
import { renderMapRegion } from './mapview.js';

export function compositeToCanvas(canvas, map, terr, phys) {
  const surf = new Surface(map.width * 16, map.height * 16, 0);
  renderMapRegion(surf, terr, phys, map, 0, 0, map.width, map.height);
  canvas.width = surf.w;
  canvas.height = surf.h;
  canvas.getContext('2d').putImageData(surf.toImageData(phys.pal), 0, 0);
  return { w: surf.w, h: surf.h };
}

// Render a cols×rows tile region (16px tiles) through the same compositor and return
// an offscreen canvas. Used by the colony-screen minimap so it reuses mapview.js
// instead of a parallel renderer.
export function compositeRegion(map, terr, phys, x0, y0, cols, rows) {
  const surf = new Surface(cols * 16, rows * 16, 0);
  renderMapRegion(surf, terr, phys, map, x0, y0, cols, rows);
  const cv = document.createElement('canvas');
  cv.width = surf.w; cv.height = surf.h;
  cv.getContext('2d').putImageData(surf.toImageData(phys.pal), 0, 0);
  return cv;
}
