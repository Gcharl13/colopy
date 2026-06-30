// forge/web_ui.cpp -- see web_ui.hpp. The whole front-end as one embedded string.
#include "web_ui.hpp"

namespace forge {

const char* forge_index_html() {
    return R"HTML(<!doctype html>
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
  nav { display:flex; gap:4px; padding:0 12px; background:#0f1115; border-bottom:1px solid #2a2e37; }
  nav button { background:none; border:none; color:#9aa3b2; padding:10px 16px; cursor:pointer; font:inherit; border-bottom:2px solid transparent; }
  nav button.active { color:#fff; border-bottom-color:#e8b94b; }
  main { padding:16px; }
  .tab { display:none; } .tab.active { display:block; }
  textarea { width:100%; min-height:120px; background:#0f1115; color:#dfe3ea; border:1px solid #2a2e37; border-radius:6px; padding:8px; font-family:ui-monospace,monospace; }
  input[type=text] { background:#0f1115; color:#dfe3ea; border:1px solid #2a2e37; border-radius:6px; padding:6px 8px; width:380px; }
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
</style>
</head>
<body>
<header><b>Viceroy Forge</b> &mdash; balance laboratory &amp; content editor</header>
<nav>
  <button data-tab="rules" class="active">Rules</button>
  <button data-tab="map">Map</button>
  <button data-tab="data">Data</button>
  <button data-tab="formulas">Formulas</button>
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
    <textarea id="overlay" placeholder='{ "cfg": { "warehouse_cap_base": 150, "ref_accrue_offset": 20 }, "units": { "Soldiers": { "attack": 3 } } }'></textarea>
    <div id="rwarn"></div>
    <div id="rcurves"></div>
  </section>

  <section id="map" class="tab">
    <div class="row">
      <input type="text" id="mappath" placeholder="path/to/map.mp">
      <button class="act" onclick="loadMap()">Load</button>
      <button class="act" onclick="saveMap()">Save</button>
      <span id="minfo" class="muted"></span>
    </div>
    <div class="row">
      <label><input type="checkbox" id="river"> river</label>
      <label><input type="checkbox" id="forest"> forest</label>
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
      formulas with <span class="muted">(fixed code logic)</span> are structural (the math
      shape, enums, the demotion/capture ladder) and aren't data-tunable.</p>
    <div id="fout"></div>
  </section>
</main>
<script>
const $ = s => document.querySelector(s);
document.querySelectorAll('nav button').forEach(b => b.onclick = () => {
  document.querySelectorAll('nav button').forEach(x => x.classList.remove('active'));
  document.querySelectorAll('.tab').forEach(x => x.classList.remove('active'));
  b.classList.add('active'); $('#'+b.dataset.tab).classList.add('active');
});

// ---- Rules ----
let lastOverlay = {};
async function applyRules() {
  const txt = $('#overlay').value.trim();
  let res;
  try {
    res = await fetch('/api/rules', {method:'POST', body: txt});
  } catch(e) { $('#rinv').innerHTML = '<span class="fail">request failed</span>'; return; }
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
  try {
    res = await fetch('/api/rules/full');
  } catch(e) { $('#rinv').innerHTML = '<span class="fail">request failed</span>'; return; }
  const d = await res.json();
  if (d.error) { $('#rinv').innerHTML = '<span class="fail">'+d.error+'</span>'; return; }
  $('#overlay').value = JSON.stringify(d, null, 2);   // the whole real ruleset, editable
  applyRules();                                       // chart it (all deltas zero until you edit)
}

// ---- Map ----
let MAP = null; const CELL = 10;
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
  for (let y=0;y<MAP.h;y++) for (let x=0;x<MAP.w;x++) {
    const b = MAP.terrain[y*MAP.w+x];
    g.fillStyle = terrColor(b & 0x1F);
    g.fillRect(x*CELL, y*CELL, CELL-1, CELL-1);
    if (b & 0x20) { g.strokeStyle='#6cf'; g.beginPath(); g.moveTo(x*CELL,y*CELL); g.lineTo(x*CELL+CELL-1,y*CELL+CELL-1); g.stroke(); }
    if (b & 0x40) { g.strokeStyle='#063'; g.strokeRect(x*CELL+0.5,y*CELL+0.5,CELL-2,CELL-2); }
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
  if (!MAP) return;
  const body = JSON.stringify({path:$('#mappath').value, terrain:MAP.terrain});
  const res = await fetch('/api/map/save', {method:'POST', body});
  const d = await res.json();
  $('#minfo').innerHTML = d.ok ? '<span class="pass">saved</span>' : '<span class="fail">'+(d.error||'save failed')+'</span>';
}

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
function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
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

applyRules();
loadFormulas();
</script>
</body>
</html>
)HTML";
}

} // namespace forge
