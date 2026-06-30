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
  <button data-tab="formulas">Formulas</button>
  <button data-tab="assets">Assets</button>
  <button data-tab="screens">Screens</button>
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
      <select id="screenpick" onchange="loadScreen()"></select>
      <button class="act" onclick="demoPopup()">Demo: button + popup + toast</button>
      <button class="act" onclick="clearSpots()">Clear hotspots</button>
      <span class="muted">Click the screen to drop a clickable hotspot button.</span>
    </div>
    <div id="stage" class="stage"></div>
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
TILESET.onload = () => { TILES_READY = true; if (MAP) drawMap(); };
TILESET.src = '/assets/tileset/terrain16.png';
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
  const g = cv.getContext('2d'); g.imageSmoothingEnabled = false;
  const useTiles = TILES_READY && $('#realtiles') && $('#realtiles').checked;
  for (let y=0;y<MAP.h;y++) for (let x=0;x<MAP.w;x++) {
    const b = MAP.terrain[y*MAP.w+x], id = b & 0x1F;
    if (useTiles) {
      g.drawImage(TILESET, terrFrame(id)*16, 0, 16, 16, x*CELL, y*CELL, CELL, CELL);
    } else {
      g.fillStyle = terrColor(id); g.fillRect(x*CELL, y*CELL, CELL-1, CELL-1);
    }
    // forest cue (id 8..23 = a forest variant, or the painted forest bit 0x40)
    if ((id>=8 && id<=23) || (b & 0x40)) {
      g.fillStyle = 'rgba(8,46,20,.5)';
      g.beginPath(); g.moveTo(x*CELL+CELL*0.5, y*CELL+CELL*0.2);
      g.lineTo(x*CELL+CELL*0.78, y*CELL+CELL*0.7); g.lineTo(x*CELL+CELL*0.22, y*CELL+CELL*0.7);
      g.closePath(); g.fill();
    }
    if (b & 0x20) { g.strokeStyle='#7cdcff'; g.lineWidth=2; g.beginPath();
      g.moveTo(x*CELL, y*CELL+CELL/2); g.lineTo(x*CELL+CELL, y*CELL+CELL/2); g.stroke(); }
  }
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
  fillScreenPicker(); renderAssets();
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

// ---- Screens (compositor) ----
let SCREEN={img:null, spots:[]};
function fillScreenPicker(){
  if(!ASSETS) return;
  $('#screenpick').innerHTML=(ASSETS.backgrounds||[]).map(n=>{
    const l=n.replace(/\.png$/,''); return '<option value="'+n+'">'+l+'</option>';
  }).join('');
  if (ASSETS.backgrounds && ASSETS.backgrounds.length) loadScreen();
}
function loadScreen(){
  const n=$('#screenpick').value; if(!n) return;
  SCREEN={img:'/assets/pik/'+n, spots:[]}; drawStage();
}
function clearSpots(){ SCREEN.spots=[]; drawStage(); }
function drawStage(){
  const st=$('#stage');
  if(!SCREEN.img){ st.innerHTML=''; return; }
  st.innerHTML='<img class="bg" src="'+SCREEN.img+'">';
  SCREEN.spots.forEach((s,i)=>{
    const b=document.createElement('button'); b.className='hotspot'; b.textContent=s.label;
    b.style.left=s.x+'px'; b.style.top=s.y+'px';
    b.onclick=ev=>{ ev.stopPropagation(); ui.popup(esc(s.label),'<p>Hotspot '+(i+1)+' &mdash; this is where a screen action would fire.</p>'); };
    st.appendChild(b);
  });
}
$('#stage').addEventListener('click', e=>{
  if(!SCREEN.img || e.target.tagName!=='IMG') return;
  const r=e.target.getBoundingClientRect();
  const x=Math.round(e.clientX-r.left), y=Math.round(e.clientY-r.top);
  const label=prompt('Hotspot button label:','Button');
  if(label===null) return;
  SCREEN.spots.push({x,y,label}); drawStage(); ui.toast('Hotspot added');
});

// ---- init ----
applyRules();
loadFormulas();
loadAssets();
</script>
</body>
</html>
)HTML";
    return html.c_str();
}

} // namespace forge
