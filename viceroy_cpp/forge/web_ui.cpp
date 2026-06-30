// forge/web_ui.cpp -- the whole front-end, embedded. Assembled from several raw
// string chunks: a single literal would exceed MSVC's per-literal cap, so we
// concatenate chunks into one static std::string at first use.
#include "web_ui.hpp"

#include <string>

namespace forge {

const char* forge_index_html() {
    static const std::string html =
        // ---- chunk 1: head + styles ----
        std::string(R"HTML(<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Viceroy Forge</title>
<style>
  :root { color-scheme: dark; }
  body { margin:0; font:14px/1.4 system-ui,sans-serif; background:#16181d; color:#dfe3ea; }
  header { background:#0f1115; padding:10px 16px; border-bottom:1px solid #2a2e37; }
  header b { color:#e8b94b; }
  nav { display:flex; gap:4px; padding:0 12px; background:#0f1115; border-bottom:1px solid #2a2e37; flex-wrap:wrap; }
  nav button { background:none; border:none; color:#9aa3b2; padding:10px 16px; cursor:pointer; font:inherit; border-bottom:2px solid transparent; }
  nav button.active { color:#fff; border-bottom-color:#e8b94b; }
  main { padding:16px; }
  .tab { display:none; } .tab.active { display:block; }
  textarea { width:100%; min-height:120px; background:#0f1115; color:#dfe3ea; border:1px solid #2a2e37; border-radius:6px; padding:8px; font-family:ui-monospace,monospace; }
  input[type=text],select { background:#0f1115; color:#dfe3ea; border:1px solid #2a2e37; border-radius:6px; padding:6px 8px; }
  input[type=text] { width:380px; }
  button.act { background:#2b3140; color:#fff; border:1px solid #3a4151; border-radius:6px; padding:7px 14px; cursor:pointer; }
  button.act:hover { background:#39415480; }
  table { border-collapse:collapse; width:100%; margin-top:10px; }
  th,td { text-align:left; padding:4px 10px; border-bottom:1px solid #23262e; }
  th { color:#9aa3b2; font-weight:600; }
  .pass { color:#5fd38a; } .fail { color:#ff6b6b; } .warn { color:#e8b94b; }
  .delta { color:#e8b94b; } .muted { color:#6b7280; }
  .row { display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-bottom:10px; }
  .pal { display:flex; gap:4px; flex-wrap:wrap; margin:8px 0; }
  .sw { width:26px; height:26px; border:2px solid #2a2e37; border-radius:4px; cursor:pointer; }
  .sw.sel { border-color:#e8b94b; }
  canvas { border:1px solid #2a2e37; image-rendering:pixelated; background:#0b0d11; }
  .pill { display:inline-block; padding:2px 8px; border-radius:10px; font-size:12px; }
  .ok { background:#13391f; color:#5fd38a; } .bad { background:#3a1414; color:#ff6b6b; }
  .fcard { border-left:2px solid #2a2e37; padding:4px 10px; margin:8px 0; }
  .ftitle { font-weight:600; color:#e8b94b; }
  .fexpr { font-family:ui-monospace,monospace; white-space:pre-wrap; background:#0f1115;
           padding:6px 8px; border-radius:4px; margin:4px 0; color:#bfe3c9; }
  #formulas code { background:#1d2128; padding:1px 5px; border-radius:3px; color:#e8b94b; }
  .gallery { display:flex; flex-wrap:wrap; gap:10px; }
  .thumb { margin:0; width:144px; cursor:pointer; background:#0f1115; border:1px solid #2a2e37; border-radius:6px; padding:6px; text-align:center; }
  .thumb:hover { border-color:#e8b94b; }
  .thumb img { max-width:130px; max-height:96px; image-rendering:pixelated; background:#000; }
  .thumb figcaption { font-size:11px; color:#9aa3b2; margin-top:4px; word-break:break-all; }
  .full { image-rendering:pixelated; max-width:86vw; max-height:78vh; background:#000; }
  .stage { position:relative; display:inline-block; border:1px solid #2a2e37; background:#000; }
  .stage .bg { display:block; width:640px; image-rendering:pixelated; }
  .hotspot { position:absolute; transform:translate(-50%,-50%); background:#e8b94bdd; color:#16181d;
             border:none; border-radius:4px; padding:3px 8px; font:inherit; font-size:12px; cursor:pointer; box-shadow:0 1px 4px #000a; }
  #modal { position:fixed; inset:0; background:#000b; display:none; align-items:center; justify-content:center; z-index:50; }
  #modal.show { display:flex; }
  .modalbox { background:#16181d; border:1px solid #3a4151; border-radius:8px; max-width:92vw; max-height:92vh; overflow:auto; box-shadow:0 10px 40px #000a; }
  .modalhead { display:flex; justify-content:space-between; align-items:center; gap:20px; padding:8px 14px; border-bottom:1px solid #2a2e37; background:#0f1115; }
  .modalhead b { color:#e8b94b; }
  .modalbody { padding:14px; }
  .x { cursor:pointer; color:#9aa3b2; font-size:20px; background:none; border:none; line-height:1; }
  #toast { position:fixed; bottom:18px; left:50%; transform:translateX(-50%); background:#2b3140; border:1px solid #3a4151; padding:8px 16px; border-radius:6px; opacity:0; pointer-events:none; transition:opacity .2s; z-index:60; }
  #toast.show { opacity:1; }
  /* node-graph editor */
  .glayout { display:flex; gap:8px; height:72vh; }
  .gpalette { width:170px; overflow:auto; background:#0f1115; border:1px solid #2a2e37; border-radius:6px; padding:6px; flex:none; }
  .gpalette h4 { margin:8px 4px 4px; color:#9aa3b2; font-size:11px; text-transform:uppercase; letter-spacing:.04em; }
  .gpitem { padding:5px 8px; margin:2px 0; background:#1c2026; border:1px solid #2a2e37; border-radius:4px; cursor:grab; font-size:12px; }
  .gpitem:hover { border-color:#e8b94b; }
  .gcanvas { flex:1; position:relative; overflow:hidden; background:#101216; border:1px solid #2a2e37; border-radius:6px; }
  #gworld { position:absolute; left:0; top:0; transform-origin:0 0; }
  #gwires { position:absolute; left:0; top:0; width:4000px; height:3000px; pointer-events:none; overflow:visible; }
  .gnode { position:absolute; min-width:128px; background:#1b1f27; border:1px solid #3a4151; border-radius:6px; box-shadow:0 2px 8px #0007; font-size:12px; user-select:none; }
  .gnode.sel { border-color:#e8b94b; }
  .gnhdr { padding:4px 8px; background:#262c38; border-radius:6px 6px 0 0; cursor:grab; font-weight:600; color:#e8b94b; }
  .gnhdr.trig { color:#7ad08a; } .gnhdr.act { color:#7ab8ff; } .gnhdr.flow { color:#e8b94b; } .gnhdr.data { color:#c9a6ff; } .gnhdr.dlg { color:#ff9bb0; }
  .gnbody { padding:4px 2px; }
  .gprow { display:flex; justify-content:space-between; align-items:center; gap:6px; padding:1px 4px; min-height:16px; }
  .gpin { width:11px; height:11px; border-radius:50%; border:2px solid #6b7280; background:#11141a; cursor:crosshair; flex:none; }
  .gpin.exec { border-radius:2px; border-color:#cdd3df; }
  .gpin.hot { border-color:#e8b94b; background:#e8b94b; }
  .gplabel { color:#aeb6c2; font-size:11px; }
  .gprops { width:210px; background:#0f1115; border:1px solid #2a2e37; border-radius:6px; padding:8px; flex:none; overflow:auto; }
  .gprops label { display:block; font-size:11px; color:#9aa3b2; margin:6px 0 2px; }
  .gprops input,.gprops select,.gprops textarea { width:100%; box-sizing:border-box; background:#0f1115; color:#dfe3ea; border:1px solid #2a2e37; border-radius:4px; padding:4px; font:inherit; }
  .wire { stroke:#cdd3df; stroke-width:2; fill:none; } .wire.data { stroke:#c9a6ff; }
  /* screen designer */
  .sstage { position:relative; width:640px; height:400px; background:#000; border:1px solid #2a2e37; image-rendering:pixelated; flex:none; }
  .sstage img.bg { position:absolute; left:0; top:0; width:640px; height:400px; image-rendering:pixelated; }
  .swidget { position:absolute; box-sizing:border-box; cursor:move; white-space:pre; overflow:hidden; }
  .swidget.sel { outline:1px solid #e8b94b; outline-offset:0; z-index:5; }
  .swspr { width:100%; height:100%; display:flex; align-items:center; justify-content:center; font-size:9px; color:#e8b94b; border:1px dashed #e8b94b80; background:#0008; }
</style>
</head>
)HTML")
        // ---- chunk 2: body markup ----
        + R"HTML(<body>
<header><b>Viceroy Forge</b> &mdash; game-engine workbench (rules, assets, maps, screens)</header>
<nav>
  <button data-tab="rules" class="active">Rules</button>
  <button data-tab="map">Map</button>
  <button data-tab="data">Data</button>
  <button data-tab="tables">Tables</button>
  <button data-tab="formulas">Formulas</button>
  <button data-tab="assets">Assets</button>
  <button data-tab="screens">Screens</button>
  <button data-tab="logic">Logic</button>
  <button data-tab="play">Play</button>
</nav>
<main>
  <section id="rules" class="tab active">
    <div class="row">
      <button class="act" onclick="loadFullRules()">Load full ruleset</button>
      <button class="act" onclick="applyRules()">Apply &amp; inspect</button>
      <button class="act" onclick="downloadOverlay()">Download overlay</button>
      <span id="rinv"></span>
    </div>
    <p class="muted"><b>Load full ruleset</b> dumps every value (all units, terrain, balance
      constants) into the box to view/edit. Or paste a sparse <code>rules.json</code> overlay
      (leave empty for the default ruleset):</p>
    <textarea id="overlay" placeholder='{ "cfg": { "warehouse_cap_base": 150 }, "units": { "Soldiers": { "attack": 3 } } }'></textarea>
    <div id="rwarn"></div>
    <div id="rcurves"></div>
  </section>

  <section id="map" class="tab">
    <div class="row">
      <input type="text" id="mappath" value="data_extracted/map/AMER2.MP" placeholder="path/to/map.mp">
      <button class="act" onclick="loadMap()">Load</button>
      <button class="act" onclick="saveMap()">Save</button>
      <span id="minfo" class="muted"></span>
    </div>
    <div class="row">
      <label><input type="checkbox" id="realtiles" checked onchange="drawMap()"> real tiles</label>
      <label><input type="checkbox" id="river"> paint river</label>
      <label><input type="checkbox" id="forest"> paint forest</label>
      <span id="mrep"></span>
    </div>
    <div class="pal" id="palette"></div>
    <canvas id="cv" width="640" height="480"></canvas>
  </section>

  <section id="data" class="tab">
    <div class="row">
      <input type="text" id="datapath" value="data_extracted/tables/names_tables.json">
      <button class="act" onclick="checkData()">Check</button>
      <span id="dinfo"></span>
    </div>
    <div id="dout"></div>
  </section>

  <section id="tables" class="tab">
    <div class="row"><span id="tinfo" class="muted">Loading the game tables&hellip;</span>
      <input type="text" id="tfilter" placeholder="filter rows" oninput="tShow(TCUR)"></div>
    <div style="display:flex; gap:12px; align-items:flex-start">
      <div class="gpalette" id="tlist" style="width:200px; max-height:72vh"></div>
      <div id="tgrid" style="flex:1; overflow:auto; max-height:72vh"></div>
    </div>
  </section>

  <section id="formulas" class="tab">
    <p class="muted">Every formula the sim computes &mdash; the <b>logic</b> behind the data.
      Tags like <code>warehouse_cap_base</code> are knobs you can edit on the Rules tab;
      formulas marked <span class="muted">(fixed code logic)</span> are structural.</p>
    <div id="fout"></div>
  </section>

  <section id="assets" class="tab">
    <div class="row">
      <input type="text" id="assetfilter" placeholder="filter: ICONS, CC-, KING, EUROPE, PHYS0..." oninput="renderAssets()">
      <label><input type="radio" name="atype" value="sprites" checked onchange="renderAssets()"> sprite sheets</label>
      <label><input type="radio" name="atype" value="backgrounds" onchange="renderAssets()"> backgrounds</label>
      <span id="ainfo" class="muted"></span>
    </div>
    <p class="muted">All 206 sprite sheets + 35 full-screen images, served from the bundle. Click any to view full size.</p>
    <div id="agallery" class="gallery"></div>
  </section>

  <section id="screens" class="tab">
    <div class="row">
      <select id="scrpick" onchange="scrLoad()"></select>
      <button class="act" onclick="scrNew()">New</button>
      <button class="act" onclick="scrSave()">Save</button>
      <button class="act" onclick="scrRefresh()">Refresh</button>
      <button class="act" onclick="scrPreview()">&#9654; Preview</button>
      <span class="muted">Click a widget to select, drag to move; edit it on the right. The
        State Inspector tweaks the live game and the screen reacts. <code>{game.year}</code>-style
        tokens in text bind to game state.</span>
    </div>
    <div style="display:flex; gap:12px; align-items:flex-start; flex-wrap:wrap">
      <div id="sstage" class="sstage"></div>
      <div style="display:flex; flex-direction:column; gap:10px">
        <div class="gprops" id="sprops" style="width:224px"><span class="muted">No widget selected.</span></div>
        <div class="gprops" id="sinspect" style="width:224px"></div>
      </div>
      <div class="gpalette" id="spalette" style="width:120px"></div>
    </div>
  </section>

  <section id="play" class="tab">
    <div class="row">
      <button class="act" onclick="newGame()">New game</button>
      <button class="act" onclick="stepGame()">End turn &#9654;</button>
      <button class="act" id="foundbtn" onclick="foundColony()" disabled>Found colony</button>
      <span class="muted">Click a unit to select it, then click a tile to send it (it routes
        around coastline over the following turns). End turn advances the whole world.</span>
    </div>
    <div class="row"><span id="selinfo" class="muted">No unit selected.</span></div>
    <div class="row">
      <select id="evpick"></select>
      <button class="act" onclick="fireEvent()">Fire event</button>
      <span class="muted">Fire an authored event graph (from the Logic tab) against this live game.</span>
    </div>
    <div style="display:flex; gap:16px; align-items:flex-start; flex-wrap:wrap">
      <canvas id="gcv" width="640" height="480"></canvas>
      <div id="ghud" style="min-width:250px"></div>
    </div>
  </section>

  <section id="logic" class="tab">
    <div class="row">
      <select id="graphpick" onchange="loadGraph()"></select>
      <button class="act" onclick="newGraph()">New</button>
      <button class="act" onclick="saveGraph()">Save</button>
      <button class="act" onclick="runGraph()">&#9654; Run</button>
      <span class="muted">Drag a node from the palette; drag pin&rarr;pin to wire. Click a node to edit it.</span>
      <span id="ginfo" class="muted"></span>
    </div>
    <div class="glayout">
      <div class="gpalette" id="gpalette"></div>
      <div class="gcanvas" id="gcanvas">
        <div id="gworld"><svg id="gwires"></svg></div>
      </div>
      <div class="gprops" id="gprops"><span class="muted">No node selected.</span></div>
    </div>
    <div id="grun" class="muted" style="margin-top:8px"></div>
  </section>
</main>

<div id="modal"><div class="modalbox">
  <div class="modalhead"><b id="modaltitle"></b><button class="x" onclick="ui.close()">&times;</button></div>
  <div class="modalbody" id="modalbody"></div>
</div></div>
<div id="toast"></div>
)HTML"
        // ---- chunk 3: script -- framework, rules, map ----
        + R"HTML(<script>
const $ = s => document.querySelector(s);
function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');}

// ---- tabs ----
document.querySelectorAll('nav button').forEach(b => b.onclick = () => {
  document.querySelectorAll('nav button').forEach(x => x.classList.remove('active'));
  document.querySelectorAll('.tab').forEach(x => x.classList.remove('active'));
  b.classList.add('active'); $('#'+b.dataset.tab).classList.add('active');
});

// ---- UI framework: popups, toasts, event handling ----
const ui = {
  _tt:null,
  popup(title, html){ $('#modaltitle').innerHTML=title; $('#modalbody').innerHTML=html; $('#modal').classList.add('show'); },
  close(){ $('#modal').classList.remove('show'); },
  toast(msg){ const t=$('#toast'); t.textContent=msg; t.classList.add('show'); clearTimeout(ui._tt); ui._tt=setTimeout(()=>t.classList.remove('show'),1800); }
};
$('#modal').addEventListener('click', e=>{ if(e.target===$('#modal')) ui.close(); });
window.addEventListener('keydown', e=>{ if(e.key==='Escape') ui.close(); });
function demoPopup(){
  ui.popup('Popup system', '<p>Buttons, modal popups and toasts are all wired and reusable.</p>'
    +'<button class="act" id="demobtn">Fire a toast</button>');
  $('#demobtn').onclick = ()=> ui.toast('Button press handled ✓');
}

// ---- Rules ----
let lastOverlay = {};
async function applyRules() {
  const txt = $('#overlay').value.trim();
  let res;
  try { res = await fetch('/api/rules', {method:'POST', body: txt}); }
  catch(e) { $('#rinv').innerHTML = '<span class="fail">request failed</span>'; return; }
  const d = await res.json();
  if (d.error) { $('#rinv').innerHTML = '<span class="fail">'+d.error+'</span>'; return; }
  lastOverlay = d.overlay || {};
  $('#rinv').innerHTML = d.invariants.ok
    ? '<span class="pill ok">invariants PASS</span>'
    : '<span class="pill bad">invariants FAIL</span>';
  $('#rwarn').innerHTML = (d.invariants.violations||[]).map(v=>'<div class="fail">! '+v+'</div>').join('')
    + (d.warnings||[]).map(v=>'<div class="warn">~ '+v+'</div>').join('');
  let h = '<table><tr><th>section</th><th>metric</th><th>value</th><th>vs base</th></tr>';
  let sec = '';
  for (const c of d.curves) {
    if (c.section !== sec) { sec = c.section; h += '<tr><th colspan=4>'+sec+'</th></tr>'; }
    const dl = c.delta ? '<span class="delta">'+(c.delta>0?'+':'')+c.delta+'</span>' : '<span class="muted">-</span>';
    h += '<tr><td></td><td>'+c.label+'</td><td>'+c.cur+'</td><td>'+dl+'</td></tr>';
  }
  $('#rcurves').innerHTML = h + '</table>';
}
function downloadOverlay() {
  const blob = new Blob([JSON.stringify(lastOverlay, null, 2)], {type:'application/json'});
  const a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = 'rules.json'; a.click();
}
async function loadFullRules() {
  $('#rinv').innerHTML = '<span class="muted">loading...</span>';
  let res;
  try { res = await fetch('/api/rules/full'); }
  catch(e) { $('#rinv').innerHTML = '<span class="fail">request failed</span>'; return; }
  const d = await res.json();
  if (d.error) { $('#rinv').innerHTML = '<span class="fail">'+d.error+'</span>'; return; }
  $('#overlay').value = JSON.stringify(d, null, 2);
  applyRules();
}

// ---- Map ----
let MAP = null; const CELL = 16;
// real terrain tileset (16x16 strip, frame i at x=i*16) cropped from TERRAIN.SS
const TILESET = new Image(); let TILES_READY = false;
TILESET.onload = () => { TILES_READY = true; if (MAP) drawMap(); if (typeof GAME!=='undefined' && GAME) drawGame(); };
TILESET.src = '/assets/tileset/terrain16.png';
// PHYS0 overlays (forest canopy, coast beaches, rivers) composited OVER the ground,
// selected per a tile's neighbours -- ported from viceroy_cpp/src/mapview.cpp.
const PHYS = new Image(); let PHYS_READY = false;
PHYS.onload = () => { PHYS_READY = true; if (MAP) drawMap(); if (typeof GAME!=='undefined' && GAME) drawGame(); };
PHYS.src = '/assets/tileset/phys0.png';
const CDX8=[0,1,1,1,0,-1,-1,-1], CDY8=[-1,-1,0,1,1,1,0,-1];   // N,NE,E,SE,S,SW,W,NW
function baseFrame(i){ return i<=7?i : (i<=23?((i&7)===1?8:(i&7)) : (i===24?9:i===25?10:i===26?11:2)); }
// Compose the whole terrain plane: TERRAIN.SS base ground + PHYS0 forest/coast/river.
function composeMap(g, terr, w, h, cell, useTiles){
  g.imageSmoothingEnabled=false;
  const bAt=(x,y)=> (x<0||y<0||x>=w||y>=h)?26:terr[y*w+x];
  const tid=(x,y)=> bAt(x,y)&0x1F;
  const water=i=>i===25||i===26;
  const overlay = useTiles && TILES_READY && PHYS_READY;
  const fnb=(x,y)=>{ const b=tid(x,y); return (b>=8&&b<=23&&(b&7)!==1) || ((bAt(x,y)&0x40)&&!water(b)); };
  for(let y=0;y<h;y++) for(let x=0;x<w;x++){
    const b=bAt(x,y), i=b&0x1F;
    if(useTiles && TILES_READY) g.drawImage(TILESET, baseFrame(i)*16,0,16,16, x*cell,y*cell,cell,cell);
    else { g.fillStyle=terrColor(i); g.fillRect(x*cell,y*cell,cell,cell); }
    if(!overlay) continue;
    if(water(i)){                                     // coastline: beaches / shore sub-tiles
      let cfg=[0,0,0,0], conn=0;
      for(let dr=0;dr<8;dr++){ if(water(tid(x+CDX8[dr],y+CDY8[dr]))) continue; conn|=(1<<dr);
        if(dr&1) cfg[((dr+1)&6)>>1]|=2; else { cfg[dr>>1]|=4; cfg[((dr>>1)+1)&3]|=1; } }
      if(!conn) continue;
      let pat=-1;
      if((conn&0xDD)===0xC1)pat=0; if((conn&0x77)===0x07)pat=1; if((conn&0x77)===0x70)pat=2; if((conn&0xDD)===0x1C)pat=3;
      const frames = pat>=0 ? [0x96+pat] : [0,1,2,3].map(q=>0x6C+cfg[q]*4+q);
      for(const f of frames) g.drawImage(PHYS, f*16,0,16,16, x*cell,y*cell,cell,cell);
    } else {
      if((i>=8&&i<=23&&(i&7)!==1) || (b&0x40)){       // forest canopy (id band or painted bit)
        let k=0; if(fnb(x,y-1))k|=8; if(fnb(x,y+1))k|=4; if(fnb(x-1,y))k|=2; if(fnb(x+1,y))k|=1;
        g.drawImage(PHYS, (0x40+k)*16,0,16,16, x*cell,y*cell,cell,cell);
      }
      if(b&0x20){                                     // river band
        let k=0; if(bAt(x,y-1)&0x20)k|=8; if(bAt(x,y+1)&0x20)k|=4; if(bAt(x-1,y)&0x20)k|=2; if(bAt(x+1,y)&0x20)k|=1;
        g.drawImage(PHYS, (0x10+(k||0xF))*16,0,16,16, x*cell,y*cell,cell,cell);
      }
    }
  }
}
// our terrain id (0..28) -> TERRAIN.SS base-ground frame (0..11)
function terrFrame(id) {
  if (id <= 7)  return id;            // 8 base terrains, 1:1
  if (id <= 23) return id & 7;        // forest variant -> its ground tile
  if (id === 24) return 9;            // arctic
  if (id === 25) return 10;           // ocean
  if (id === 26) return 11;           // sea lane
  if (id === 27) return 8;            // mountains (ground stand-in)
  if (id === 28) return 4;            // hills (ground stand-in)
  return 2;
}
function terrColor(id) {
  if (id===25||id===26) return '#285aaa';
  if (id===24) return '#e6ebf5';
  if (id===27) return '#6e6964';
  if (id===28) return '#967850';
  if (id===1)  return '#d2c878';
  if (id===6||id===7) return '#5a785a';
  if (id>=8 && id<=23) return '#1e6428';
  return '#5aa046';
}
const PAL_IDS = [25,26,2,4,5,1,6,8,28,27,24];
function buildPalette() {
  const p = $('#palette'); p.innerHTML = '';
  PAL_IDS.forEach((id,i) => {
    const d = document.createElement('div'); d.className='sw'+(i===2?' sel':'');
    d.style.background = terrColor(id); d.title = 'id '+id; d.dataset.id = id;
    d.onclick = () => { document.querySelectorAll('.sw').forEach(s=>s.classList.remove('sel')); d.classList.add('sel'); };
    p.appendChild(d);
  });
}
function selId() { const s = document.querySelector('.sw.sel'); return s ? +s.dataset.id : 2; }
function drawMap() {
  if (!MAP) return;
  const cv = $('#cv'); cv.width = MAP.w*CELL; cv.height = MAP.h*CELL;
  const g = cv.getContext('2d');
  const useTiles = !($('#realtiles') && !$('#realtiles').checked);
  composeMap(g, MAP.terrain, MAP.w, MAP.h, CELL, useTiles);
}
function paintAt(ev) {
  if (!MAP) return;
  const r = $('#cv').getBoundingClientRect();
  const x = Math.floor((ev.clientX-r.left)/CELL), y = Math.floor((ev.clientY-r.top)/CELL);
  if (x<0||x>=MAP.w||y<0||y>=MAP.h) return;
  let b = selId() & 0x1F;
  if ($('#river').checked) b |= 0x20;
  if ($('#forest').checked) b |= 0x40;
  MAP.terrain[y*MAP.w+x] = b; drawMap();
}
let painting=false;
$('#cv').addEventListener('mousedown', e=>{painting=true; paintAt(e);});
$('#cv').addEventListener('mousemove', e=>{ if(painting) paintAt(e); });
window.addEventListener('mouseup', ()=>painting=false);
function showRep(rep) {
  $('#mrep').innerHTML = rep ? ('<span class="pill '+(rep.ok?'ok':'bad')+'">'+(rep.ok?'valid':'issues')
    +'</span> land '+rep.land_masses+' / ocean '+rep.oceans
    + (rep.issues||[]).map(i=>'<div class="fail">! '+i+'</div>').join('')
    + (rep.warnings||[]).map(w=>'<div class="warn">~ '+w+'</div>').join('')) : '';
}
async function loadMap() {
  const p = encodeURIComponent($('#mappath').value);
  const res = await fetch('/api/map?path='+p); const d = await res.json();
  if (d.error) { $('#minfo').innerHTML='<span class="fail">'+d.error+'</span>'; return; }
  MAP = {w:d.w, h:d.h, terrain:d.terrain};
  $('#minfo').textContent = d.w+'x'+d.h+' ('+d.rest+' trailing bytes preserved)';
  buildPalette(); drawMap(); showRep(d.report);
}
async function saveMap() {
  if (!MAP) { ui.toast('Load a map first'); return; }
  const body = JSON.stringify({path:$('#mappath').value, terrain:MAP.terrain});
  const res = await fetch('/api/map/save', {method:'POST', body});
  const d = await res.json();
  $('#minfo').innerHTML = d.ok ? '<span class="pass">saved</span>' : '<span class="fail">'+(d.error||'save failed')+'</span>';
}
</script>
)HTML"
        // ---- chunk 3b: script -- node-graph editor (Logic tab) ----
        + R"HTML(<script>
// ===== Node-graph editor (Blueprint-inspired) =====
let CAT=[], NDEF={}, CATOF={}, G={id:'untitled',name:'Untitled',nodes:[],edges:[]};
let selNode=null, wiring=null, GINIT=false; const PAN={x:30,y:30}; let ZOOM=1;
const NW=152, HEAD=24, ROW=18;
const BINDS=['game.year','game.season','game.turn','game.difficulty','power0.gold','power0.tax',
  'power0.royal_money','power0.crosses','ref.regulars','ref.cavalry','ref.manowar','ref.artillery',
  'colonies.count','units.count','colony0.population','colony0.sol','price.1'];
const SVGNS='http://www.w3.org/2000/svg';
function catClass(c){return c==='Triggers'?'trig':c==='Actions'?'act':c==='Flow'?'flow':c==='Data'?'data':c==='Dialog'?'dlg':'';}
function nodeById(id){return G.nodes.find(n=>n.id===id);}
function isExec(type,pin){const d=NDEF[type];if(!d)return false;const p=d.pins.find(x=>x.name===pin);return p&&p.kind==='exec';}
function worldXform(){$('#gworld').style.transform='translate('+PAN.x+'px,'+PAN.y+'px) scale('+ZOOM+')';}
function toWorld(ev){const r=$('#gcanvas').getBoundingClientRect();return {x:(ev.clientX-r.left-PAN.x)/ZOOM,y:(ev.clientY-r.top-PAN.y)/ZOOM};}
function toWorldCenter(){const r=$('#gcanvas').getBoundingClientRect();return {x:(r.width/2-PAN.x)/ZOOM,y:(r.height/2-PAN.y)/ZOOM};}
function pinPos(node,pinName){
  const def=NDEF[node.type]; if(!def) return {x:node.x,y:node.y};
  const ins=def.pins.filter(p=>p.dir==='in'), outs=def.pins.filter(p=>p.dir==='out');
  let ii=ins.findIndex(p=>p.name===pinName); if(ii>=0) return {x:node.x, y:node.y+HEAD+ii*ROW+ROW/2};
  let oi=outs.findIndex(p=>p.name===pinName); if(oi>=0) return {x:node.x+NW, y:node.y+HEAD+oi*ROW+ROW/2};
  return {x:node.x,y:node.y};
}
async function gInit(){
  const r=await fetch('/api/nodes'); CAT=(await r.json()).categories; NDEF={}; CATOF={};
  for(const c of CAT) for(const n of c.nodes){ NDEF[n.type]=n; CATOF[n.type]=c.name; }
  if(!$('#bindlist')){ const dl=document.createElement('datalist'); dl.id='bindlist';
    dl.innerHTML=BINDS.map(b=>'<option value="'+b+'">').join(''); document.body.appendChild(dl); }
  buildPalette(); await gLoadList();
  if($('#graphpick').value){ await loadGraph(); } else newGraph();
}
function buildPalette(){
  let h=''; for(const c of CAT){ h+='<h4>'+esc(c.name)+'</h4>'; for(const n of c.nodes) h+='<div class="gpitem" data-t="'+n.type+'">'+esc(n.title)+'</div>'; }
  $('#gpalette').innerHTML=h;
  $('#gpalette').querySelectorAll('.gpitem').forEach(el=>el.onclick=()=>addNode(el.dataset.t));
}
async function gLoadList(){ const ids=await (await fetch('/api/graphs')).json();
  $('#graphpick').innerHTML=ids.map(i=>'<option'+(i===G.id?' selected':'')+'>'+esc(i)+'</option>').join(''); }
async function loadGraph(){ const id=$('#graphpick').value; if(!id)return;
  G=await (await fetch('/api/graph?id='+encodeURIComponent(id))).json(); G.nodes=G.nodes||[]; G.edges=G.edges||[];
  selNode=null; gProps(); gRender(); $('#ginfo').textContent=G.nodes.length+' nodes'; }
function newGraph(){ G={id:'untitled',name:'Untitled',nodes:[],edges:[]}; selNode=null; gProps(); gRender(); }
function gClean(){ return {id:G.id,name:G.name,nodes:G.nodes.map(n=>({id:n.id,type:n.type,x:n.x,y:n.y,params:n.params||{}})),edges:G.edges}; }
async function saveGraph(){
  if(!G.id||G.id==='untitled'){ const id=prompt('Graph id (filename):','my_graph'); if(!id)return; G.id=id; if(G.name==='Untitled')G.name=id; }
  const d=await (await fetch('/api/graph',{method:'POST',body:JSON.stringify(gClean())})).json();
  if(d.ok){ ui.toast('Saved '+G.id); gLoadList(); } else ui.toast('Save failed');
}
function addNode(type){
  const def=NDEF[type]; const params={};
  if(def) for(const p of def.params) params[p.name]= p.kind==='number'?0:(p.options?p.options[0]:'');
  const w=toWorldCenter();
  const n={id:'n'+(Date.now()%100000)+Math.floor(Math.random()*99), type, x:Math.round(w.x), y:Math.round(w.y), params};
  G.nodes.push(n); selNode=n; gProps(); gRender();
}
function delNode(){ if(!selNode)return; const id=selNode.id;
  G.edges=G.edges.filter(e=>e.from.node!==id&&e.to.node!==id); G.nodes=G.nodes.filter(n=>n!==selNode); selNode=null; gProps(); gRender(); }
function gRender(){
  const world=$('#gworld'); [...world.querySelectorAll('.gnode')].forEach(e=>e.remove());
  const svg=$('#gwires'); svg.innerHTML='';
  for(const e of G.edges){
    const fn=nodeById(e.from.node), tn=nodeById(e.to.node); if(!fn||!tn) continue;
    const a=pinPos(fn,e.from.pin), b=pinPos(tn,e.to.pin), data=!isExec(fn.type,e.from.pin);
    const p=document.createElementNS(SVGNS,'path'); p.setAttribute('class','wire'+(data?' data':''));
    p.setAttribute('d','M'+a.x+','+a.y+' C'+(a.x+60)+','+a.y+' '+(b.x-60)+','+b.y+' '+b.x+','+b.y);
    p.style.pointerEvents='stroke'; p.style.cursor='pointer'; p.onclick=()=>{ G.edges=G.edges.filter(x=>x!==e); gRender(); };
    svg.appendChild(p);
  }
  for(const n of G.nodes) world.appendChild(makeNode(n));
  worldXform();
}
function makeNode(n){
  const def=NDEF[n.type]||{pins:[],title:n.type,params:[]};
  const d=document.createElement('div'); d.className='gnode'+(n===selNode?' sel':'');
  d.style.left=n.x+'px'; d.style.top=n.y+'px'; d.style.width=NW+'px';
  const hdr=document.createElement('div'); hdr.className='gnhdr '+catClass(CATOF[n.type]); hdr.textContent=def.title||n.type;
  hdr.onmousedown=ev=>startDragNode(ev,n); d.appendChild(hdr);
  d.onclick=ev=>{ if(ev.target!==hdr){ selNode=n; gProps(); gRender(); } };
  const body=document.createElement('div'); body.className='gnbody';
  const ins=def.pins.filter(p=>p.dir==='in'), outs=def.pins.filter(p=>p.dir==='out');
  for(let i=0;i<Math.max(ins.length,outs.length);i++){
    const row=document.createElement('div'); row.className='gprow';
    const L=document.createElement('div'); L.style.cssText='display:flex;align-items:center;gap:4px';
    if(ins[i]){ L.appendChild(mkPin(n,ins[i])); const s=document.createElement('span'); s.className='gplabel'; s.textContent=ins[i].name; L.appendChild(s); }
    const R=document.createElement('div'); R.style.cssText='display:flex;align-items:center;gap:4px';
    if(outs[i]){ const s=document.createElement('span'); s.className='gplabel'; s.textContent=outs[i].name; R.appendChild(s); R.appendChild(mkPin(n,outs[i])); }
    row.appendChild(L); row.appendChild(R); body.appendChild(row);
  }
  d.appendChild(body); return d;
}
function mkPin(n,p){
  const e=document.createElement('div'); e.className='gpin'+(p.kind==='exec'?' exec':''); e.title=p.kind+' '+p.name;
  e.onmousedown=ev=>{ ev.stopPropagation(); wiring={node:n,pin:p}; document.onmousemove=wireMove; document.onmouseup=wireCancel; };
  e.onmouseup=ev=>{ ev.stopPropagation(); endWire(n,p); };
  return e;
}
function wireMove(ev){ if(!wiring)return; const a=pinPos(wiring.node,wiring.pin.name), w=toWorld(ev);
  let p=$('#gtemp'); if(!p){ p=document.createElementNS(SVGNS,'path'); p.id='gtemp'; $('#gwires').appendChild(p); }
  p.setAttribute('class','wire'+(wiring.pin.kind==='data'?' data':''));
  p.setAttribute('d','M'+a.x+','+a.y+' C'+(a.x+60)+','+a.y+' '+(w.x-60)+','+w.y+' '+w.x+','+w.y); }
function wireCancel(){ document.onmousemove=null; document.onmouseup=null; const t=$('#gtemp'); if(t)t.remove(); wiring=null; }
function endWire(n2,p2){
  if(!wiring){ return; } const a=wiring;
  let out,inp;
  if(a.pin.dir==='out'&&p2.dir==='in'){ out=a; inp={node:n2,pin:p2}; }
  else if(a.pin.dir==='in'&&p2.dir==='out'){ out={node:n2,pin:p2}; inp=a; }
  if(out&&inp&&out.pin.kind===inp.pin.kind&&out.node!==inp.node){
    G.edges=G.edges.filter(e=>!(e.to.node===inp.node.id&&e.to.pin===inp.pin.name));
    G.edges.push({from:{node:out.node.id,pin:out.pin.name},to:{node:inp.node.id,pin:inp.pin.name}});
  }
  wireCancel(); gRender();
}
function startDragNode(ev,n){ ev.preventDefault(); selNode=n; gProps();
  const s=toWorld(ev), ox=n.x-s.x, oy=n.y-s.y;
  document.onmousemove=e=>{ const w=toWorld(e); n.x=Math.round(w.x+ox); n.y=Math.round(w.y+oy); gRender(); };
  document.onmouseup=()=>{ document.onmousemove=null; document.onmouseup=null; }; }
function gProps(){
  if(!selNode){ $('#gprops').innerHTML='<span class="muted">No node selected. Click a node, or a palette item to add one.</span>'; return; }
  const def=NDEF[selNode.type]; let h='<b>'+(def?esc(def.title):esc(selNode.type))+'</b>';
  h+='<div class="muted" style="margin:3px 0 6px">'+(def?esc(def.summary):'')+'</div>';
  if(def) for(const p of def.params){ const v=selNode.params[p.name]!==undefined?selNode.params[p.name]:'';
    h+='<label>'+esc(p.name)+'</label>';
    if(p.kind==='select') h+='<select data-p="'+p.name+'">'+p.options.map(o=>'<option'+(String(o)===String(v)?' selected':'')+'>'+esc(o)+'</option>').join('')+'</select>';
    else if(p.kind==='text') h+='<textarea data-p="'+p.name+'" rows="2">'+esc(String(v))+'</textarea>';
    else if(p.kind==='binding') h+='<input data-p="'+p.name+'" list="bindlist" value="'+esc(String(v))+'">';
    else h+='<input type="number" data-p="'+p.name+'" value="'+esc(String(v))+'">';
  }
  h+='<button class="act" style="margin-top:10px" onclick="delNode()">Delete node</button>';
  $('#gprops').innerHTML=h;
  $('#gprops').querySelectorAll('[data-p]').forEach(el=>el.onchange=()=>{ selNode.params[el.dataset.p]=(el.type==='number')?+el.value:el.value; gRender(); });
}
async function runGraph(){ const d=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify(gClean())})).json(); showRun(d); }
async function resumeGraph(node,choice){ ui.close();
  const d=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify(Object.assign(gClean(),{from_node:node,choice}))})).json(); showRun(d); }
function showRun(d){
  let h='<b>log:</b> '+((d.log||[]).map(esc).join(' &rarr; ')||'(nothing ran)');
  if(d.effects&&d.effects.length) h+='<br><b>effects:</b> '+d.effects.map(esc).join('; ');
  $('#grun').innerHTML=h;
  if(d.popup){ const p=d.popup; ui.popup(esc(p.title), '<p>'+esc(p.body)+'</p><div id="pchoices"></div>');
    const box=$('#pchoices'); (p.choices||[]).forEach(c=>{ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent=c; b.onclick=()=>resumeGraph(p.node,c); box.appendChild(b); }); }
}
addEventListener('keydown',e=>{ const t=document.activeElement&&document.activeElement.tagName;
  if((e.key==='Delete'||e.key==='Backspace')&&selNode&&t!=='INPUT'&&t!=='TEXTAREA'&&t!=='SELECT'){ delNode(); } });
function gPanWheelSetup(){
  const cv=$('#gcanvas');
  cv.addEventListener('mousedown',ev=>{ if(!['gcanvas','gworld','gwires'].includes(ev.target.id))return;
    const sx=ev.clientX-PAN.x, sy=ev.clientY-PAN.y;
    document.onmousemove=e=>{ PAN.x=e.clientX-sx; PAN.y=e.clientY-sy; worldXform(); };
    document.onmouseup=()=>{ document.onmousemove=null; document.onmouseup=null; }; });
  cv.addEventListener('wheel',ev=>{ ev.preventDefault(); ZOOM=Math.min(2,Math.max(0.4,ZOOM*(ev.deltaY<0?1.1:0.9))); worldXform(); },{passive:false});
}
document.querySelector('nav button[data-tab=logic]').addEventListener('click',()=>{ if(!GINIT){ GINIT=true; gPanWheelSetup(); gInit(); } });
</script>
)HTML"
        // ---- chunk 4: script -- data, formulas, assets, screens, init ----
        + R"HTML(<script>
// ---- Data ----
async function checkData() {
  const p = encodeURIComponent($('#datapath').value);
  const res = await fetch('/api/data/check?path='+p); const d = await res.json();
  if (d.error) { $('#dinfo').innerHTML='<span class="fail">'+d.error+'</span>'; $('#dout').innerHTML=''; return; }
  $('#dinfo').innerHTML = '<span class="pill '+(d.ok?'ok':'bad')+'">'+(d.ok?'OK':'ISSUES')+'</span> '
    + d.sections+' sections, '+d.rows+' rows';
  $('#dout').innerHTML = (d.issues||[]).map(i=>'<div class="fail">! '+i+'</div>').join('')
    + (d.warnings||[]).map(w=>'<div class="warn">~ '+w+'</div>').join('');
}

// ---- Tables (browse every @section of the game data) ----
let TABLES=null, TCUR=null;
async function tInit(){
  try { TABLES=await (await fetch('/api/tables')).json(); }
  catch(e){ $('#tinfo').innerHTML='<span class="fail">tables unavailable</span>'; return; }
  const keys=Object.keys(TABLES).filter(k=>TABLES[k]&&typeof TABLES[k]==='object');
  $('#tinfo').textContent=keys.length+' tables (NAMES.TXT)';
  $('#tlist').innerHTML=keys.map(k=>{ const rc=TABLES[k].row_count!==undefined?TABLES[k].row_count:(TABLES[k].rows?TABLES[k].rows.length:0);
    return '<div class="gpitem" data-k="'+esc(k)+'">'+esc(k)+' <span class="muted">'+rc+'</span></div>'; }).join('');
  $('#tlist').querySelectorAll('.gpitem').forEach(el=>el.onclick=()=>tShow(el.dataset.k));
  if(keys.length) tShow(keys[0]);
}
function tShow(k){
  if(!k||!TABLES||!TABLES[k]) return; TCUR=k; const s=TABLES[k];
  const rows=s.rows||[]; const cols=s.columns||(rows[0]?Object.keys(rows[0]):[]);
  const f=($('#tfilter').value||'').toLowerCase();
  const show=f?rows.filter(r=>cols.some(c=>String(r[c]).toLowerCase().includes(f))):rows;
  let h='<h3>'+esc(k)+' <span class="muted" style="font-weight:400">'+esc(s.source||'')+' &middot; '+show.length+'/'+rows.length+' rows</span></h3>';
  if(s.legend) h+='<div class="muted" style="margin-bottom:6px">'+esc([].concat(s.legend).join(' ')).slice(0,160)+'</div>';
  h+='<table><tr><th>#</th>'+cols.map(c=>'<th>'+esc(c)+'</th>').join('')+'</tr>';
  show.forEach((r,i)=>{ h+='<tr><td class="muted">'+i+'</td>'+cols.map(c=>'<td>'+esc(String(r[c]!==undefined&&r[c]!==null?r[c]:''))+'</td>').join('')+'</tr>'; });
  $('#tgrid').innerHTML=h+'</table>';
}
document.querySelector('nav button[data-tab=tables]').addEventListener('click',()=>{ if(!window._tinit){ window._tinit=true; tInit(); } });
)HTML"
        // ---- chunk 4b ----
        + R"HTML(
// ---- Formulas ----
async function loadFormulas() {
  let res;
  try { res = await fetch('/api/formulas'); }
  catch(e) { $('#fout').innerHTML = '<span class="fail">request failed</span>'; return; }
  const d = await res.json();
  let h = '';
  for (const s of d.systems) {
    h += '<h3>'+esc(s.name)+' <span class="muted" style="font-weight:400">'+esc(s.source)+'</span></h3>';
    for (const f of s.formulas) {
      h += '<div class="fcard"><div class="ftitle">'+esc(f.title)+'</div>';
      h += '<div class="fexpr">'+esc(f.expr)+'</div>';
      h += (f.knobs && f.knobs.length)
        ? '<div>knobs: '+f.knobs.map(k=>'<code>'+esc(k)+'</code>').join(' ')+'</div>'
        : '<div class="muted">(fixed code logic - not data-tunable)</div>';
      h += '<div class="muted">'+esc(f.note)+'</div></div>';
    }
  }
  $('#fout').innerHTML = h;
}

// ---- Assets ----
let ASSETS = null;
function assetType(){ const r=document.querySelector('input[name=atype]:checked'); return r?r.value:'sprites'; }
function assetURL(type, name){ return '/assets/'+(type==='backgrounds'?'pik':'sprites')+'/'+name; }
async function loadAssets(){
  try { const r=await fetch('/api/assets'); ASSETS=await r.json(); }
  catch(e){ $('#ainfo').innerHTML='<span class="fail">assets unavailable (run from repo root)</span>'; return; }
  renderAssets();
}
function renderAssets(){
  if(!ASSETS) return;
  const type=assetType(); const list=ASSETS[type]||[];
  const f=$('#assetfilter').value.trim().toUpperCase();
  const shown=list.filter(n=>!f || n.toUpperCase().includes(f));
  $('#ainfo').textContent=shown.length+' / '+list.length;
  $('#agallery').innerHTML=shown.map(n=>{
    const label=esc(n.replace(/^atlas_/,'').replace(/\.png$/,''));
    const u=assetURL(type,n);
    return '<figure class="thumb" data-url="'+u+'" data-label="'+label+'">'
      +'<img loading="lazy" src="'+u+'"><figcaption>'+label+'</figcaption></figure>';
  }).join('');
}
$('#agallery').addEventListener('click', e=>{
  const fig=e.target.closest('.thumb'); if(!fig) return;
  ui.popup(fig.dataset.label, '<img class="full" src="'+fig.dataset.url+'">');
});

)HTML"
        // ---- chunk 4c: screen designer + play ----
        + R"HTML(
let SCR={id:'untitled',name:'Untitled',background:'COLONY',size:[320,200],widgets:[]}, selW=null, BINDV={}, SINIT=false; const SS=2;
async function scrInit(){
  if(!$('#graphlist')){ const dl=document.createElement('datalist'); dl.id='graphlist';
    const ids=await (await fetch('/api/graphs')).json(); dl.innerHTML=ids.map(i=>'<option value="'+i+'">').join(''); document.body.appendChild(dl); }
  scrPalette(); scrInspector(); await scrList(); if($('#scrpick').value) scrLoad(); else scrRender();
}
async function scrList(){ const ids=await (await fetch('/api/screens')).json();
  $('#scrpick').innerHTML=ids.map(i=>'<option'+(i===SCR.id?' selected':'')+'>'+esc(i)+'</option>').join(''); }
async function scrLoad(){ const id=$('#scrpick').value; if(!id)return;
  SCR=await (await fetch('/api/screen?id='+encodeURIComponent(id))).json(); SCR.widgets=SCR.widgets||[]; selW=null; scrProps(); await scrRefresh(); }
function scrNew(){ SCR={id:'untitled',name:'Untitled',background:'COLONY',size:[320,200],widgets:[]}; selW=null; scrProps(); scrRender(); }
async function scrSave(){ if(!SCR.id||SCR.id==='untitled'){ const id=prompt('Screen id:','my_screen'); if(!id)return; SCR.id=id; if(SCR.name==='Untitled')SCR.name=id; }
  const d=await (await fetch('/api/screen',{method:'POST',body:JSON.stringify(SCR)})).json();
  if(d.ok){ ui.toast('Saved '+SCR.id); scrList(); } else ui.toast('Save failed'); }
async function scrRefresh(){
  const paths=new Set();
  for(const w of SCR.widgets){ (String(w.text||'').match(/\{[^}]+\}/g)||[]).forEach(m=>paths.add(m.slice(1,-1))); }
  BINDV={};
  await Promise.all([...paths].map(async p=>{ try{ BINDV[p]=(await (await fetch('/api/bind?path='+encodeURIComponent(p))).json()).value; }catch(e){} }));
  scrRender();
}
function interp(t){ return String(t||'').replace(/\{([^}]+)\}/g,(m,p)=> (BINDV[p]!==undefined&&BINDV[p]!==null)?BINDV[p]:m); }
function scrRender(){
  const st=$('#sstage'); st.innerHTML='';
  if(SCR.background){ const img=document.createElement('img'); img.className='bg'; img.src='/assets/pik/'+SCR.background+'.png'; img.onerror=()=>img.style.display='none'; st.appendChild(img); }
  for(const w of SCR.widgets){
    const r=w.rect||[0,0,40,8]; const d=document.createElement('div'); d.className='swidget'+(w===selW?' sel':'');
    d.style.left=(r[0]*SS)+'px'; d.style.top=(r[1]*SS)+'px'; d.style.width=(r[2]*SS)+'px'; d.style.height=(r[3]*SS)+'px';
    if(w.type==='rect'){ d.style.background='rgb('+(w.color||'0,0,0')+')'; }
    else if(w.type==='sprite'){ const s=document.createElement('div'); s.className='swspr'; s.textContent=(w.sheet||'?')+' #'+(w.frame||0); d.appendChild(s); }
    else { d.style.color='rgb('+(w.color||'255,255,255')+')'; const fs=Math.max(8,Math.min(16,r[3]*SS-2));
      d.style.font=fs+'px ui-monospace,monospace'; d.style.lineHeight=(r[3]*SS)+'px';
      d.textContent=(w.type==='button')?('[ '+interp(w.text)+' ]'):interp(w.text); }
    d.onmousedown=ev=>scrDrag(ev,w);
    st.appendChild(d);
  }
}
function scrDrag(ev,w){ ev.preventDefault(); selW=w; scrProps();
  const st=$('#sstage').getBoundingClientRect(), ox=w.rect[0]-(ev.clientX-st.left)/SS, oy=w.rect[1]-(ev.clientY-st.top)/SS;
  document.onmousemove=e=>{ w.rect[0]=Math.max(0,Math.round((e.clientX-st.left)/SS+ox)); w.rect[1]=Math.max(0,Math.round((e.clientY-st.top)/SS+oy)); scrRender(); };
  document.onmouseup=()=>{ document.onmousemove=null; document.onmouseup=null; }; scrRender();
}
function scrProps(){
  if(!selW){ $('#sprops').innerHTML='<span class="muted">No widget selected. Add one from the palette &rarr;</span>'; return; }
  const w=selW; let h='<b>Widget</b> <span class="muted">'+esc(w.type)+'</span>';
  h+='<label>type</label><select data-w="type">'+['text','button','rect','sprite'].map(t=>'<option'+(t===w.type?' selected':'')+'>'+t+'</option>').join('')+'</select>';
  h+='<label>rect (x,y,w,h)</label><input data-w="rect" value="'+(w.rect||[]).join(',')+'">';
  h+='<label>color (r,g,b)</label><input data-w="color" value="'+esc(w.color||'255,255,255')+'">';
  if(w.type==='text'||w.type==='button') h+='<label>text (use {binding})</label><textarea data-w="text" rows="2">'+esc(w.text||'')+'</textarea>';
  if(w.type==='sprite'){ h+='<label>sheet</label><input data-w="sheet" value="'+esc(w.sheet||'ICONS')+'"><label>frame</label><input type="number" data-w="frame" value="'+(w.frame||0)+'">'; }
  if(w.type==='button') h+='<label>onClick &rarr; graph</label><input data-w="onClick" list="graphlist" value="'+esc(w.onClick||'')+'">';
  h+='<button class="act" style="margin-top:8px" onclick="scrDel()">Delete widget</button>';
  $('#sprops').innerHTML=h;
  $('#sprops').querySelectorAll('[data-w]').forEach(el=>el.onchange=()=>{ const k=el.dataset.w; let v=el.value;
    if(k==='rect') v=v.split(',').map(x=>+x.trim()); else if(k==='frame') v=+v;
    selW[k]=v; if(k==='type') scrProps(); scrRefresh(); });
}
function scrDel(){ if(!selW)return; SCR.widgets=SCR.widgets.filter(x=>x!==selW); selW=null; scrProps(); scrRender(); }
function scrPalette(){ const t=[['text','Text'],['button','Button'],['rect','Rect'],['sprite','Sprite']];
  $('#spalette').innerHTML='<h4>Add widget</h4>'+t.map(x=>'<div class="gpitem" data-t="'+x[0]+'">'+x[1]+'</div>').join('');
  $('#spalette').querySelectorAll('.gpitem').forEach(el=>el.onclick=()=>scrAdd(el.dataset.t)); }
function scrAdd(type){ const w={id:'w'+(Date.now()%100000),type,rect:[20,20,90,10],color:'255,255,255'};
  if(type==='text'||type==='button') w.text=(type==='button')?'OK':'New text {game.year}';
  if(type==='sprite'){ w.sheet='BUILDING'; w.frame=1; }
  SCR.widgets.push(w); selW=w; scrProps(); scrRefresh(); }
function scrInspector(){
  const F=[['game.year','Year'],['game.season','Season'],['power0.gold','Gold'],['power0.tax','Tax %'],['colony0.population','Colony pop']];
  $('#sinspect').innerHTML='<b>State Inspector</b><div class="muted" style="margin:3px 0">Tweak the live game &mdash; the screen reacts.</div>'
    + F.map(f=>'<label>'+f[1]+'</label><input type="number" data-s="'+f[0]+'" id="si_'+f[0].replace(/\W/g,'_')+'">').join('');
  $('#sinspect').querySelectorAll('[data-s]').forEach(el=>el.onchange=async()=>{
    await fetch('/api/bind/set',{method:'POST',body:JSON.stringify({path:el.dataset.s,value:+el.value})}); scrRefresh(); });
  F.forEach(async f=>{ try{ const v=(await (await fetch('/api/bind?path='+encodeURIComponent(f[0]))).json()).value;
    const el=$('#si_'+f[0].replace(/\W/g,'_')); if(el&&v!==null)el.value=v; }catch(e){} });
}
// preview: render the screen read-only with active buttons that fire their graphs
async function scrPreview(){
  await scrRefresh();
  ui.popup('Preview: '+esc(SCR.name), '<div id="pvstage" class="sstage"></div>');
  const st=$('#pvstage');
  if(SCR.background){ const img=document.createElement('img'); img.className='bg'; img.src='/assets/pik/'+SCR.background+'.png'; img.onerror=()=>img.style.display='none'; st.appendChild(img); }
  for(const w of SCR.widgets){
    const r=w.rect||[0,0,40,8]; const d=document.createElement('div'); d.className='swidget';
    d.style.cssText='left:'+(r[0]*SS)+'px;top:'+(r[1]*SS)+'px;width:'+(r[2]*SS)+'px;height:'+(r[3]*SS)+'px;cursor:'+((w.type==='button'&&w.onClick)?'pointer':'default');
    if(w.type==='rect') d.style.background='rgb('+(w.color||'0,0,0')+')';
    else if(w.type==='sprite'){ const s=document.createElement('div'); s.className='swspr'; s.textContent=(w.sheet||'?')+' #'+(w.frame||0); d.appendChild(s); }
    else { d.style.color='rgb('+(w.color||'255,255,255')+')'; const fs=Math.max(8,Math.min(16,r[3]*SS-2)); d.style.font=fs+'px ui-monospace,monospace'; d.style.lineHeight=(r[3]*SS)+'px'; d.textContent=(w.type==='button')?('[ '+interp(w.text)+' ]'):interp(w.text); }
    if(w.type==='button'&&w.onClick) d.onclick=()=>pvFire(w.onClick);
    st.appendChild(d);
  }
}
async function pvNav(id){ ui.close(); $('#scrpick').value=id; await scrLoad(); scrPreview(); }
async function pvFire(graphId){
  const d=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id:graphId})})).json();
  if(d.goto){ pvNav(d.goto); return; }
  if((d.effects||[]).length) ui.toast(d.effects.join('; '));
  if(d.popup){ const p=d.popup; ui.popup(esc(p.title),'<p>'+esc(p.body)+'</p><div id="pvch"></div>');
    (p.choices||[]).forEach(c=>{ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent=c;
      b.onclick=async()=>{ const r=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id:graphId,from_node:p.node,choice:c})})).json();
        if(r.goto){ pvNav(r.goto); } else { ui.close(); if((r.effects||[]).length) ui.toast(r.effects.join('; ')); scrPreview(); } };
      $('#pvch').appendChild(b); }); }
}
document.querySelector('nav button[data-tab=screens]').addEventListener('click',()=>{ if(!SINIT){ SINIT=true; scrInit(); } });

)HTML"
        // ---- chunk 4d: play ----
        + R"HTML(
// ---- Play (the engine loop) ----
let GAME = null, SEL = -1; const GCELL = 14;
const GOODS = ['Food','Sugar','Tobacco','Cotton','Furs','Lumber','Ore','Silver',
               'Horses','Rum','Cigars','Cloth','Coats','Trade goods','Tools','Muskets'];
function ownerColor(o){ return ['#d94f4f','#4f7fd9','#56b96a','#d9b84f'][o&3]; }
// real on-map unit sprites (32px cells, cell t = unit type), cropped from ICONS.SS
const UNITSET = new Image(); let UNITS_READY = false;
UNITSET.onload = () => { UNITS_READY = true; if (GAME) drawGame(); };
UNITSET.src = '/assets/tileset/units.png';
async function newGame(){
  SEL=-1;
  try { const r=await fetch('/api/game/new',{method:'POST'}); GAME=await r.json(); }
  catch(e){ $('#ghud').innerHTML='<span class="fail">game unavailable</span>'; return; }
  drawGame(); showSel(); fillEvents(); ui.toast('New game ('+GAME.year+')');
}
async function fillEvents(){ try{ const ids=await (await fetch('/api/graphs')).json();
  $('#evpick').innerHTML=ids.map(i=>'<option>'+esc(i)+'</option>').join(''); }catch(e){} }
async function refreshGame(){ GAME=await (await fetch('/api/game/state')).json(); drawGame(); showSel(); }
async function fireEvent(){
  const id=$('#evpick').value; if(!id) return;
  const d=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id})})).json();
  await refreshGame();
  if((d.effects||[]).length) ui.toast(d.effects.join('; '));
  if(d.popup){ const p=d.popup; ui.popup(esc(p.title),'<p>'+esc(p.body)+'</p><div id="evch"></div>');
    (p.choices||[]).forEach(c=>{ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent=c;
      b.onclick=async()=>{ ui.close(); const r=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id,from_node:p.node,choice:c})})).json();
        await refreshGame(); if((r.effects||[]).length) ui.toast(r.effects.join('; ')); }; $('#evch').appendChild(b); }); }
}
async function stepGame(){
  if(!GAME){ await newGame(); return; }
  const r=await fetch('/api/game/turn',{method:'POST'}); GAME=await r.json();
  drawGame(); showSel(); ui.toast('Year '+GAME.year);
  if(GAME.events && GAME.events.length) eventQueue(GAME.events.slice());
}
function eventQueue(q){
  if(!q.length) return; const e=q.shift(), p=e.report.popup;
  if(!p){ eventQueue(q); return; }
  ui.popup(esc(p.title), '<p>'+esc(p.body)+'</p><div id="eqch"></div>');
  const box=$('#eqch'), ch=p.choices||[];
  if(!ch.length){ const b=document.createElement('button'); b.className='act'; b.textContent='Continue'; b.onclick=()=>{ ui.close(); refreshGame(); eventQueue(q); }; box.appendChild(b); return; }
  ch.forEach(c=>{ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent=c;
    b.onclick=async()=>{ await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id:e.graph,from_node:p.node,choice:c})}); ui.close(); await refreshGame(); eventQueue(q); }; box.appendChild(b); });
}
function selUnit(){ return SEL<0 ? null : (GAME&&GAME.units.find(u=>u.id===SEL)); }
async function orderMove(tx,ty){
  const r=await fetch('/api/game/order',{method:'POST',body:JSON.stringify({unit:SEL,tx,ty})});
  GAME=await r.json(); drawGame(); showSel(); ui.toast('Order set — end turn to move');
}
async function foundColony(){
  const u=selUnit(); if(!u) return;
  const r=await fetch('/api/game/found',{method:'POST',body:JSON.stringify({unit:SEL})});
  const d=await r.json();
  if(d.error){ ui.toast(d.error); return; }
  GAME=d; SEL=-1; drawGame(); showSel(); ui.toast('Colony founded');
}
function showSel(){
  const u=selUnit();
  $('#foundbtn').disabled = !(u && !u.naval);
  if(!u){ SEL = u===undefined ? -1 : SEL; $('#selinfo').innerHTML='No unit selected. Click a unit to select it.'; return; }
  const ord=['idle','fortified','sentry','moving'][u.order]||'?';
  $('#selinfo').innerHTML='Selected: <b>'+u.name+'</b> at ('+u.x+','+u.y+') &middot; moves '+u.moves
    +' &middot; '+ord+(u.order===3?(' → ('+u.target_x+','+u.target_y+')'):'')
    +(u.naval?' &middot; <span class="muted">ship</span>':' &middot; click a tile to send it, or Found colony');
}
function drawGame(){
  if(!GAME || !GAME.w) return;
  const cv=$('#gcv'); cv.width=GAME.w*GCELL; cv.height=GAME.h*GCELL;
  const g=cv.getContext('2d');
  composeMap(g, GAME.terrain, GAME.w, GAME.h, GCELL, true);   // base ground + forest/coast overlays
  // colonies (settlement marker: owner-ringed block + population)
  for(const c of GAME.colonies){
    const X=c.x*GCELL, Y=c.y*GCELL;
    g.fillStyle=ownerColor(c.owner); g.fillRect(X,Y,GCELL,GCELL);
    g.fillStyle='#2a1c10'; g.fillRect(X+2,Y+2,GCELL-4,GCELL-4);
    g.fillStyle='#ffe9b0'; g.font='bold 10px sans-serif'; g.textAlign='center'; g.textBaseline='middle';
    g.fillText(String(c.population), X+GCELL/2, Y+GCELL/2+1);
  }
  // selected unit's GOTO line + target marker
  const sel=selUnit();
  if(sel && sel.order===3 && sel.target_x>=0){
    const SX=sel.x*GCELL+GCELL/2, SY=sel.y*GCELL+GCELL/2;
    const TX=sel.target_x*GCELL+GCELL/2, TY=sel.target_y*GCELL+GCELL/2;
    g.strokeStyle='rgba(255,226,122,.55)'; g.lineWidth=1.5;
    g.beginPath(); g.moveTo(SX,SY); g.lineTo(TX,TY); g.stroke();
    g.strokeStyle='#ffe27a'; g.lineWidth=2;
    g.beginPath(); g.moveTo(TX-4,TY-4); g.lineTo(TX+4,TY+4); g.moveTo(TX+4,TY-4); g.lineTo(TX-4,TY+4); g.stroke();
  }
  // units (real sprites; disc fallback for the unused slot or before load)
  const DS=Math.round(GCELL*1.7);
  for(const u of GAME.units){
    const cx=u.x*GCELL+GCELL/2, cy=u.y*GCELL+GCELL/2;
    if(UNITS_READY && u.type<23){
      g.drawImage(UNITSET, u.type*32,0,32,32, cx-DS/2, cy-DS/2, DS, DS);
    } else {
      g.beginPath(); g.arc(cx,cy,GCELL*0.4,0,7); g.fillStyle=ownerColor(u.owner); g.fill();
      g.lineWidth=1; g.strokeStyle='#000'; g.stroke();
      g.fillStyle='#fff'; g.font='bold 9px sans-serif'; g.textAlign='center'; g.textBaseline='middle';
      g.fillText((u.name||'?')[0], cx, cy+1);
    }
  }
  // selection ring on top
  if(sel){ g.strokeStyle='#ffe27a'; g.lineWidth=2; g.strokeRect(sel.x*GCELL+1, sel.y*GCELL+1, GCELL-2, GCELL-2); }
  drawHud();
}
$('#gcv').addEventListener('click', e=>{
  if(!GAME) return;
  const r=$('#gcv').getBoundingClientRect();
  const x=Math.floor((e.clientX-r.left)/GCELL), y=Math.floor((e.clientY-r.top)/GCELL);
  if(x<0||y<0||x>=GAME.w||y>=GAME.h) return;
  const here=GAME.units.find(u=>u.x===x&&u.y===y);
  if(here){ SEL=here.id; drawGame(); showSel(); return; }   // select a unit
  const col=GAME.colonies.find(c=>c.x===x&&c.y===y);
  if(col && SEL<0){ ui.popup('Colony', '<p>Population '+col.population+', Sons of Liberty '+col.sol+'%, at ('+col.x+','+col.y+').</p>'); return; }
  if(SEL>=0){ orderMove(x,y); }                             // send the selected unit here
});
function drawHud(){
  let h='<h3 style="margin:0 0 6px">Year '+GAME.year+(GAME.season?' (Autumn)':'')+'</h3>';
  h+='<div>turn '+GAME.turn+' &middot; gold <b>'+GAME.gold+'</b></div>';
  h+='<div class="muted">King\'s army: '+GAME.ref.regulars+' reg / '+GAME.ref.cavalry+' cav / '
     +GAME.ref.manowar+' man-o-war / '+GAME.ref.artillery+' art &middot; treasury '+GAME.royal_money+'</div>';
  h+='<table><tr><th>colony</th><th>pop</th><th>SoL%</th></tr>';
  GAME.colonies.forEach((c,i)=>{ h+='<tr><td>#'+(i+1)+' ('+c.x+','+c.y+')</td><td>'+c.population+'</td><td>'+c.sol+'</td></tr>'; });
  h+='</table><table><tr><th>good</th><th>price</th></tr>';
  GAME.prices.forEach((p,i)=>{ h+='<tr><td>'+GOODS[i]+'</td><td>'+p+'</td></tr>'; });
  h+='</table>';
  $('#ghud').innerHTML=h;
}

// ---- init ----
applyRules();
loadFormulas();
loadAssets();
newGame();
</script>
</body>
</html>
)HTML";
    return html.c_str();
}

} // namespace forge
