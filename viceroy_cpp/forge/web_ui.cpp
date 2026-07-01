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
  <button data-tab="schema">Schema</button>
  <button data-tab="map">Map</button>
  <button data-tab="data">Data</button>
  <button data-tab="tables">Tables</button>
  <button data-tab="formulas">Formulas</button>
  <button data-tab="assets">Assets</button>
  <button data-tab="screens">Screens</button>
  <button data-tab="logic">Logic</button>
  <button data-tab="sandbox">Sandbox</button>
  <button data-tab="play">Play</button>
</nav>
<main>
  <section id="rules" class="tab active">
    <div class="row">
      <button class="act" onclick="loadFullRules()">Reload values</button>
      <button class="act" onclick="applyRules()">Apply raw overlay</button>
      <button class="act" onclick="saveActiveMod()">Save as active mod</button>
      <button class="act" onclick="resetActiveMod()">Reset to default</button>
      <button class="act" onclick="downloadOverlay()">Download overlay</button>
      <span id="rinv"></span> <span id="ractive" class="muted"></span>
    </div>
    <p class="muted">Edit any value in the grid below &mdash; changes apply live and
      <b>Save as active mod</b> makes them bite the Play game + events. Overridden cells are
      highlighted; the raw overlay is mirrored in the box (paste a sparse <code>rules.json</code>
      there too).</p>
    <div id="rgrid"></div>
    <details style="margin:8px 0"><summary class="muted">raw overlay JSON</summary>
      <textarea id="overlay" placeholder='{ "cfg": { "warehouse_cap_base": 150 }, "units": { "Soldiers": { "attack": 3 } } }'></textarea></details>
    <div id="rwarn"></div>
    <details style="margin-top:6px"><summary class="muted">balance curves &mdash; live preview of what your edits do</summary>
      <div id="rcurves"></div></details>
  </section>

  <section id="schema" class="tab">
    <div class="row">
      <button class="act" onclick="schemaInit(true)">Reload schema</button>
      <input type="text" id="schfilter" placeholder="filter tables/columns..." oninput="schemaRender()" style="min-width:220px">
      <span id="schsummary" class="muted"></span>
    </div>
    <p class="muted">The game is a <b>database</b>. This is the authoritative schema (DDL) the whole engine
      runs on: <b>reference</b> tables (rules data), <b>state</b> tables (dynamic per-turn records), and
      <b>config</b> scalars. Every column is addressable by the one path grammar
      (<code>game.turn</code>, <code>power&lt;N&gt;.gold</code>, <code>colony&lt;N&gt;.stockpile.&lt;good&gt;</code>,
      <code>@SECTION[row].col</code>, <code>cfg.&lt;name&gt;</code>). Functions update columns each turn; the
      reverse index (column &rarr; which functions write it) is shown per column.</p>
    <div id="schbody"></div>
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
    <div class="row">
      <select id="tfile" onchange="tLoadFile(this.value)">
        <option value="names">NAMES.TXT</option>
        <option value="dgroup">DGROUP (memory map)</option>
        <option value="tribe">TRIBE.TXT</option>
      </select>
      <button class="act" onclick="tSave()">Save edits</button>
      <button class="act" onclick="tReset()">Revert to original</button>
      <span id="tinfo" class="muted">Loading the game tables&hellip;</span>
      <input type="text" id="tfilter" placeholder="filter rows" oninput="tRender()"></div>
    <p class="muted">Every game-data table. Edit any cell; <b>Save edits</b> persists them as an
      overlay (the original extraction is kept pristine), <b>Revert</b> restores it.</p>
    <div style="display:flex; gap:12px; align-items:flex-start">
      <div class="gpalette" id="tlist" style="width:220px; max-height:70vh"></div>
      <div id="tgrid" style="flex:1; overflow:auto; max-height:70vh"></div>
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
      <button class="act" onclick="scrTest()">&#129514; Test values</button>
      <span class="muted">Click a widget to select, drag to move; edit it on the right. The
        State Inspector tweaks the live game and the screen reacts. <code>{game.year}</code>-style
        tokens in text bind to game state.</span>
    </div>
    <div style="display:flex; gap:12px; align-items:flex-start; flex-wrap:wrap">
      <div id="sstage" class="sstage"></div>
      <div style="display:flex; flex-direction:column; gap:10px">
        <div class="gprops" id="sprops" style="width:224px"><span class="muted">No widget selected.</span></div>
        <div class="gprops" id="stest" style="width:224px"></div>
        <div class="gprops" id="sinspect" style="width:224px"></div>
      </div>
      <div class="gpalette" id="spalette" style="width:120px"></div>
    </div>
  </section>

  <section id="sandbox" class="tab">
    <div class="row">
      <button class="act" onclick="sbNew()">Fresh colony</button>
      <button class="act" onclick="sbAddPop()">+ Colonist</button>
      <button class="act" onclick="sbStep(1)">Run 1 turn &#9654;</button>
      <button class="act" onclick="sbStep(5)">Run 5 turns &#9654;&#9654;</button>
      <span class="muted">An isolated colony: grow it, build in it, run turns, and edit every
        outside variable &mdash; nothing here touches the Play game.</span>
    </div>
    <div style="display:flex; gap:20px; align-items:flex-start; flex-wrap:wrap">
      <div id="sbcol" style="min-width:340px"></div>
      <div style="min-width:280px">
        <h4 style="margin:4px 0">Outside variables</h4>
        <div id="sbvars"></div>
        <h4 style="margin:12px 0 4px">Build</h4>
        <div class="row"><select id="sbbuild"></select>
          <button class="act" onclick="sbBuild()">Start</button>
          <button class="act" onclick="sbRush()">Rush (gold)</button></div>
      </div>
    </div>
  </section>

  <section id="play" class="tab">
    <div class="row">
      <button class="act" onclick="newGameSetup()">New game&hellip;</button>
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

// ---- sprite catalog (loaded once; id -> {label,kind,sheet,frame|file,w,h}) ----
let SPRITECAT=null;
async function loadSprites(){ if(SPRITECAT) return SPRITECAT;
  try{ const d=await (await fetch('/api/sprites')).json(); SPRITECAT={}; (d.sprites||[]).forEach(s=>SPRITECAT[s.id]=s); }
  catch(e){ SPRITECAT={}; } return SPRITECAT; }
loadSprites();  // eager, so popups can render their sprite synchronously
function spriteImg(id, maxw){
  const s=SPRITECAT&&SPRITECAT[id]; if(!s) return '';
  const w=maxw||160;
  if(s.file) return '<img src="/assets/'+esc(s.file)+'" style="max-width:'+w+'px;max-height:'+Math.round(w*0.7)+'px;image-rendering:pixelated;border:1px solid #2a2f3a" onerror="this.style.display=\'none\'">';
  return '';  // frame-based atlas sprites are drawn on canvas elsewhere
}

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
// Persist the textarea overlay as the ACTIVE mod -- the Play game + event graphs run on it.
async function saveActiveMod(){
  const txt=$('#overlay').value.trim();
  let res; try{ res=await fetch('/api/rules/save',{method:'POST',body:txt||'{}'}); }
  catch(e){ ui.toast('save failed'); return; }
  const d=await res.json();
  if(d.saved){ ui.toast('Active mod saved — Play game + events now use it'); applyRules(); refreshActive(); }
  else { $('#rinv').innerHTML='<span class="pill bad">invalid ruleset — not saved</span>';
    $('#rwarn').innerHTML=((d.invariants&&d.invariants.violations)||[]).map(v=>'<div class="fail">! '+v+'</div>').join(''); }
}
async function resetActiveMod(){
  try{ await fetch('/api/rules/reset',{method:'POST',body:'{}'}); }catch(e){ ui.toast('reset failed'); return; }
  ui.toast('Reset to the default ruleset'); refreshActive();
}
async function refreshActive(){
  try{ const d=await (await fetch('/api/rules/active')).json();
    const n=Object.keys(d.overlay||{}).length;
    $('#ractive').textContent=n?('active mod: applied ('+n+' section'+(n>1?'s':'')+')'):'active mod: none (default ruleset)';
  }catch(e){}
}
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
  if (RULES_FULL) rulesGrid();   // keep the editable grid in sync with the overlay
}
function downloadOverlay() {
  const blob = new Blob([JSON.stringify(lastOverlay, null, 2)], {type:'application/json'});
  const a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = 'rules.json'; a.click();
}

// ---- editable ruleset grid: shows every value (default ∪ your overlay), edits write a sparse overlay ----
let RULES_FULL=null, RULES_SEC='cfg';
function rulesOverlay(){ try{ return JSON.parse($('#overlay').value||'{}')||{}; }catch(e){ return null; } }
async function rulesInitGrid(){
  try{ RULES_FULL=await (await fetch('/api/rules/full')).json(); }catch(e){ return; }
  rulesGrid(RULES_SEC);
}
function rulesGrid(section){
  if(!RULES_FULL){ rulesInitGrid(); return; }
  RULES_SEC=section||RULES_SEC;
  const ov=rulesOverlay();
  if(ov===null){ $('#rgrid').innerHTML='<span class="fail">overlay JSON is invalid &mdash; fix the raw box</span>'; return; }
  const tabs=[['cfg','Config'],['units','Units'],['terrain','Terrain']];
  let h='<div class="row" style="margin:4px 0">'+tabs.map(t=>'<button class="act'+(t[0]===RULES_SEC?'':' ')+'" style="'+(t[0]===RULES_SEC?'border-color:#e8b94b':'')+'" onclick="rulesGrid(\''+t[0]+'\')">'+t[1]+'</button>').join('')+'</div>';
  const cell=(p,k,c,def,cur)=>{ const over=cur!==undefined&&cur!==def;
    return '<td'+(over?' style="background:#3a3520"':'')+'><input class="rcell" data-p="'+p+'" data-k="'+esc(String(k))+'"'+(c?' data-c="'+c+'"':'')+' value="'+esc(cur!==undefined?cur:def)+'"></td>'; };
  if(RULES_SEC==='cfg'){
    h+='<table><tr><th>config scalar</th><th>value</th></tr>';
    for(const k of Object.keys(RULES_FULL.cfg||{}).sort()){ const def=RULES_FULL.cfg[k];
      const cur=(ov.cfg&&k in ov.cfg)?ov.cfg[k]:undefined;
      const dv=Array.isArray(def)?def.join(','):def, cv=cur===undefined?undefined:(Array.isArray(cur)?cur.join(','):cur);
      h+='<tr><td>'+esc(k)+'</td>'+cell('cfg',k,'',dv,cv)+'</tr>'; }
    h+='</table>';
  } else if(RULES_SEC==='units'){
    const cols=['attack','defense','movement','cargo','move_class'];
    h+='<table><tr><th>unit</th>'+cols.map(c=>'<th>'+c+'</th>').join('')+'</tr>';
    for(const k of Object.keys(RULES_FULL.units||{})){ const u=RULES_FULL.units[k]||{};
      h+='<tr><td>'+esc(k)+'</td>'+cols.map(c=>{ const cur=(ov.units&&ov.units[k]&&c in ov.units[k])?ov.units[k][c]:undefined;
        return cell('units',k,c,u[c]!=null?u[c]:0,cur); }).join('')+'</tr>'; }
    h+='</table>';
  } else {
    const ids=Object.keys(RULES_FULL.terrain_defense||{}).sort((a,b)=>(+a)-(+b));
    h+='<table><tr><th>terrain id</th><th>defense</th><th>move cost</th></tr>';
    for(const id of ids){ const cd=(ov.terrain_defense&&id in ov.terrain_defense)?ov.terrain_defense[id]:undefined;
      const cm=(ov.terrain_move&&id in ov.terrain_move)?ov.terrain_move[id]:undefined;
      h+='<tr><td>'+id+'</td>'+cell('terrain_defense',id,'',RULES_FULL.terrain_defense[id],cd)
        +cell('terrain_move',id,'',RULES_FULL.terrain_move[id],cm)+'</tr>'; }
    h+='</table>';
  }
  $('#rgrid').innerHTML=h;
  $('#rgrid').querySelectorAll('.rcell').forEach(el=>el.onchange=()=>rulesCellEdit(el));
}
function rulesParse(v){ v=String(v).trim(); if(v==='') return 0;
  if(v.includes(',')) return v.split(',').map(x=>+x.trim()); return isNaN(+v)?v:+v; }
function rulesCellEdit(el){
  const ov=rulesOverlay(); if(ov===null) return;
  const p=el.dataset.p, k=el.dataset.k, c=el.dataset.c, val=rulesParse(el.value);
  if(p==='cfg'){ ov.cfg=ov.cfg||{}; ov.cfg[k]=val; }
  else if(p==='units'){ ov.units=ov.units||{}; ov.units[k]=ov.units[k]||{}; ov.units[k][c]=val; }
  else { ov[p]=ov[p]||{}; ov[p][k]=val; }
  $('#overlay').value=JSON.stringify(ov,null,2);
  applyRules();        // refresh invariants + curves + re-render grid (highlights overrides)
}
// "Show all values" -- (re)load the editable grid of every default value. The grid always
// shows default ∪ overlay, so this just (re)fetches defaults; the overlay box stays sparse.
async function loadFullRules() {
  RULES_FULL = null; await rulesInitGrid(); applyRules();
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
  'colonies.count','units.count','colony0.population','colony0.sol','price.1',
  'natives.tension','ff.count','ff.16','boycott.2','war.0.1',
  'power0.colonies','power0.units','power0.strength','power1.strength','power2.strength','power3.strength',
  'power1.mil_strength','power1.econ_strength','power2.mil_strength','power2.econ_strength','power3.mil_strength','power3.econ_strength',
  'unit0.attack','unit0.defense','unit0.terraindef','unit0.profession','revolution.sol','game.score',
  'congress.bells','congress.cost','congress.era_band','congress.count'];
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
  await gLoadGameText();
  buildPalette(); await gLoadList();
  if($('#graphpick').value){ await loadGraph(); } else newGraph();
}
function buildPalette(){
  let h=''; for(const c of CAT){ h+='<h4>'+esc(c.name)+'</h4>'; for(const n of c.nodes) h+='<div class="gpitem" data-t="'+n.type+'">'+esc(n.title)+'</div>'; }
  $('#gpalette').innerHTML=h;
  $('#gpalette').querySelectorAll('.gpitem').forEach(el=>el.onclick=()=>addNode(el.dataset.t));
}
// The real game strings (GAME.TXT) -> a datalist so ShowPopup's textKey/textKeys autocomplete.
let GAMETEXT={};
async function gLoadGameText(){
  try{ GAMETEXT=await (await fetch('/api/text?file=GAME')).json(); }catch(e){ GAMETEXT={}; return; }
  if(!$('#gametextkeys')){ const dl=document.createElement('datalist'); dl.id='gametextkeys';
    dl.innerHTML=Object.keys(GAMETEXT).map(k=>'<option value="'+esc(k)+'">'+esc(String(GAMETEXT[k]).replace(/\n/g,' ').slice(0,60))+'</option>').join('');
    document.body.appendChild(dl); }
  // woodcut scene names (WOODCUT.TXT) + a small speaker-portrait list, for the popup sprite channels.
  if(!$('#woodcutlist')){ let names=[];
    try{ const w=await (await fetch('/api/text?file=WOODCUT')).json(); names=String(w['@WOODCUT']||'').split('\n').filter(Boolean); }catch(e){}
    const wd=document.createElement('datalist'); wd.id='woodcutlist';
    const wdcut=Array.from({length:14},(_,i)=>'WDCUT'+String(i).padStart(2,'0'));
    wd.innerHTML=wdcut.concat(names).map(n=>'<option value="'+esc(n)+'">').join(''); document.body.appendChild(wd);
    const sp=document.createElement('datalist'); sp.id='speakerlist';
    sp.innerHTML=['King','Native Chief','Continental Congress','Tax Man','Foreign Power'].map(n=>'<option value="'+esc(n)+'">').join(''); document.body.appendChild(sp); }
}
// Preview the real message(s) a textKey/textKeys param resolves to.
function gameTextPreview(name, val){
  const keys=String(val||'').split(/[\s,]+/).filter(Boolean);
  if(!keys.length) return '';
  const lines=keys.map(k=>{ const s=GAMETEXT[k]; return s
    ? '<div style="margin:2px 0"><code>'+esc(k)+'</code>: '+esc(s).replace(/\n/g,'<br>')+'</div>'
    : '<div class="warn">'+esc(k)+' &mdash; not found in GAME.TXT</div>'; });
  return '<div class="muted" style="border-left:2px solid #3a4151;padding-left:6px;margin:4px 0">'
    +(name==='textKeys'?'one picked per run:':'real game text:')+lines.join('')+'</div>';
}
async function gLoadList(){ const ids=await (await fetch('/api/graphs')).json();
  $('#graphpick').innerHTML=ids.map(i=>'<option'+(i===G.id?' selected':'')+'>'+esc(i)+'</option>').join('');
  let dl=$('#graphlist'); if(!dl){ dl=document.createElement('datalist'); dl.id='graphlist'; document.body.appendChild(dl); }
  dl.innerHTML=ids.map(i=>'<option value="'+esc(i)+'">').join(''); }
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
  if(!ins.length && !outs.length){ const c=document.createElement('div');
    c.style.cssText='padding:4px 8px;color:#aeb6c2;font-size:11px;white-space:pre-wrap';
    c.textContent=(n.params&&n.params.text)||'(comment)'; body.appendChild(c); }
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
    if(p.name==='textKey'||p.name==='textKeys'){
      h+='<input data-p="'+p.name+'" list="gametextkeys" placeholder="@LOSTCITY3'+(p.name==='textKeys'?',@RAIDGOLD,...':'')+'" value="'+esc(String(v))+'">';
      h+='<div data-prev="'+p.name+'">'+gameTextPreview(p.name,v)+'</div>';
    }
    else if(p.name==='woodcut') h+='<input data-p="woodcut" list="woodcutlist" placeholder="WDCUT04 / Colony Burning" value="'+esc(String(v))+'">';
    else if(p.name==='speaker') h+='<input data-p="speaker" list="speakerlist" placeholder="King / Native Chief" value="'+esc(String(v))+'">';
    else if(p.name==='graph') h+='<input data-p="graph" list="graphlist" placeholder="event graph id" value="'+esc(String(v))+'">';
    else if(p.kind==='select') h+='<select data-p="'+p.name+'">'+p.options.map(o=>'<option'+(String(o)===String(v)?' selected':'')+'>'+esc(o)+'</option>').join('')+'</select>';
    else if(p.kind==='text') h+='<textarea data-p="'+p.name+'" rows="2">'+esc(String(v))+'</textarea>';
    else if(p.kind==='binding') h+='<input data-p="'+p.name+'" list="bindlist" value="'+esc(String(v))+'">';
    else h+='<input type="number" data-p="'+p.name+'" value="'+esc(String(v))+'">';
  }
  h+='<button class="act" style="margin-top:10px" onclick="delNode()">Delete node</button>';
  $('#gprops').innerHTML=h;
  $('#gprops').querySelectorAll('[data-p]').forEach(el=>el.onchange=()=>{ selNode.params[el.dataset.p]=(el.type==='number')?+el.value:el.value;
    const pv=$('#gprops').querySelector('[data-prev="'+el.dataset.p+'"]'); if(pv) pv.innerHTML=gameTextPreview(el.dataset.p,el.value);
    gRender(); });
}
async function runGraph(){ const d=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify(gClean())})).json(); showRun(d); }
async function resumeGraph(node,choice,cache){ ui.close();
  const d=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify(Object.assign(gClean(),{from_node:node,choice,cache}))})).json(); showRun(d); }
function showRun(d){
  let h='<b>log:</b> '+((d.log||[]).map(esc).join(' &rarr; ')||'(nothing ran)');
  if(d.effects&&d.effects.length) h+='<br><b>effects:</b> '+d.effects.map(esc).join('; ');
  $('#grun').innerHTML=h;
  if(d.popup){ const p=d.popup; ui.popup(esc(p.title), '<p>'+esc(p.body).replace(/\n/g,'<br>')+'</p>'+popupSprites(p)+'<div id="pchoices"></div>');
    const box=$('#pchoices'); (p.choices||[]).forEach(c=>{ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent=c; b.onclick=()=>resumeGraph(p.node,c,p._cache); box.appendChild(b); }); }
}
// Show the sprite channels a popup carries (spec/ui/popups.md): woodcut scene + speaker portrait.
function popupSprites(p){
  let h='';
  // the message record's associated sprite (a catalog id like woodcut.wdcut04) -> real image
  if(p.sprite){ const img=spriteImg(p.sprite,180); if(img){ const s=SPRITECAT[p.sprite];
    h+='<div style="text-align:center;margin:6px 0">'+img+'<div class="muted" style="font-size:11px">'+esc(s.label||p.sprite)+'</div></div>'; } }
  // legacy node sprite channels (woodcut/speaker), if any
  if(p.woodcut||p.speaker) h+='<div class="muted" style="margin:4px 0;font-size:11px;border-top:1px solid #2a2f3a;padding-top:4px">'
    +(p.woodcut?'&#x1F5BC; '+esc(p.woodcut)+' ':'')+(p.speaker?'&#x1F464; '+esc(p.speaker):'')+'</div>';
  // the box geometry the message record specifies
  if(p.box_w) h+='<div class="muted" style="font-size:10px;text-align:right">box '+p.box_w+'px'+(p.box_x>=0?' @'+p.box_x+','+p.box_y:' (centered)')+'</div>';
  return h;
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

// ---- Tables (browse + EDIT every game-data table; edits persist as an overlay) ----
let TBL={file:'names', data:null, grids:[], cur:0};
async function tInit(){ await tLoadFile(($('#tfile')&&$('#tfile').value)||'names'); }
async function tLoadFile(file){
  TBL.file=file; TBL.cur=0;
  try{ TBL.data=await (await fetch('/api/tables?file='+file)).json(); }
  catch(e){ $('#tinfo').innerHTML='<span class="fail">tables unavailable</span>'; return; }
  TBL.grids=tDecompose(file, TBL.data);
  $('#tlist').innerHTML=TBL.grids.map((g,i)=>'<div class="gpitem" data-i="'+i+'">'+esc(g.name)+' <span class="muted">'+g.rows.length+'</span></div>').join('');
  $('#tlist').querySelectorAll('.gpitem').forEach(el=>el.onclick=()=>tShowGrid(+el.dataset.i));
  await tStatus();
  if(TBL.grids.length) tShowGrid(0); else $('#tgrid').innerHTML='<span class="muted">no rows</span>';
}
// Break a table file into named editable grids. names/tribe = one grid per @section
// (its rows); dgroup = the scalars table + one grid per record (its memory-layout fields).
function tDecompose(file, F){
  const grids=[];
  if(file==='dgroup'){
    if(F&&Array.isArray(F.scalars)) grids.push({name:'scalars', rows:F.scalars.map(s=>(s&&s.row)?s.row:s)});
    if(F&&Array.isArray(F.records)) F.records.forEach(rec=>{ if(Array.isArray(rec.fields))
      grids.push({name:String(rec.record||'record').slice(0,42), rows:rec.fields, cols:rec.header}); });
  } else if(F&&typeof F==='object'){
    for(const k of Object.keys(F)){ const s=F[k];
      if(s&&typeof s==='object'&&Array.isArray(s.rows)) grids.push({name:k, rows:s.rows, cols:s.columns, meta:s}); }
  }
  return grids;
}
function tCols(g){ if(g.cols&&g.cols.length) return g.cols;
  const set=[]; for(const r of g.rows) if(r&&typeof r==='object') for(const k of Object.keys(r)) if(!set.includes(k)) set.push(k); return set; }
function tShowGrid(i){ TBL.cur=i;
  $('#tlist').querySelectorAll('.gpitem').forEach(el=>el.classList.toggle('sel', +el.dataset.i===i)); tRender(); }
function tRender(){
  const g=TBL.grids[TBL.cur]; if(!g){ $('#tgrid').innerHTML=''; return; }
  const cols=tCols(g); const f=($('#tfilter').value||'').toLowerCase();
  let h='<h3>'+esc(g.name)+' <span class="muted" style="font-weight:400">'+g.rows.length+' rows &middot; click a cell to edit</span></h3>';
  if(g.meta&&g.meta.legend) h+='<div class="muted" style="margin-bottom:6px">'+esc([].concat(g.meta.legend).join(' ')).slice(0,160)+'</div>';
  h+='<table><tr><th>#</th>'+cols.map(c=>'<th>'+esc(c)+'</th>').join('')+'</tr>';
  g.rows.forEach((r,ri)=>{
    if(!r||typeof r!=='object') return;
    if(f && !cols.some(c=>String(r[c]==null?'':r[c]).toLowerCase().includes(f))) return;
    h+='<tr><td class="muted">'+ri+'</td>'+cols.map(c=>{ const v=r[c];
      return (v!=null && typeof v==='object')
        ? '<td class="muted">'+esc(JSON.stringify(v)).slice(0,40)+'</td>'
        : '<td><input class="tcell" data-ri="'+ri+'" data-c="'+esc(c)+'" value="'+esc(v==null?'':String(v))+'"></td>';
    }).join('')+'</tr>';
  });
  $('#tgrid').innerHTML=h+'</table>';
  $('#tgrid').querySelectorAll('.tcell').forEach(el=>el.onchange=()=>{ g.rows[+el.dataset.ri][el.dataset.c]=el.value; });
}
async function tStatus(){
  try{ const list=await (await fetch('/api/tables/list')).json(); const e=list.find(x=>x.file===TBL.file);
    $('#tinfo').innerHTML=(e&&e.edited?'<span class="pill ok">edited</span> ':'')+TBL.grids.length+' tables in '+TBL.file;
  }catch(e){}
}
async function tSave(){
  try{ const r=await (await fetch('/api/tables/save?file='+TBL.file,{method:'POST',body:JSON.stringify(TBL.data)})).json();
    if(r.error){ ui.toast('save failed: '+r.error); return; } ui.toast('Saved edits to '+TBL.file); tStatus();
  }catch(e){ ui.toast('save failed'); }
}
async function tReset(){
  if(!confirm('Revert all edits to '+TBL.file+' back to the original extraction?')) return;
  await fetch('/api/tables/reset?file='+TBL.file,{method:'POST',body:'{}'});
  ui.toast('Reverted '+TBL.file); tLoadFile(TBL.file);
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
// sprite sheets a screen 'sprite' widget can draw (horizontal strips under /assets/tileset).
const SHEETS={
  BUILDING:{url:'/assets/tileset/buildings.png',cw:56,ch:48,n:48},
  UNIT:{url:'/assets/tileset/units.png',cw:32,ch:32,n:24},
  ICONS:{url:'/assets/tileset/units.png',cw:32,ch:32,n:24}};
const SHEETIMG={};
// Render a sprite widget: a canvas drawing frame f of its sheet, contain-fit + centered,
// crisp (no smoothing). Falls back to the old text placeholder for an unknown sheet/frame.
function spriteEl(w){
  const r=w.rect||[0,0,32,32]; const f=w.frame||0;
  const sh=SHEETS[String(w.sheet||'').toUpperCase()];
  if(!sh || f<0 || f>=sh.n){ const s=document.createElement('div'); s.className='swspr'; s.textContent=(w.sheet||'?')+' #'+f; return s; }
  const cv=document.createElement('canvas');
  cv.width=Math.max(1,Math.round(r[2]*SS)); cv.height=Math.max(1,Math.round(r[3]*SS));
  cv.style.cssText='width:100%;height:100%;image-rendering:pixelated';
  const img=SHEETIMG[sh.url]||(SHEETIMG[sh.url]=Object.assign(new Image(),{src:sh.url}));
  const g=cv.getContext('2d');
  const draw=()=>{ g.imageSmoothingEnabled=false; g.clearRect(0,0,cv.width,cv.height);
    const sc=Math.min(cv.width/sh.cw,cv.height/sh.ch),dw=sh.cw*sc,dh=sh.ch*sc;
    g.drawImage(img,f*sh.cw,0,sh.cw,sh.ch,(cv.width-dw)/2,(cv.height-dh)/2,dw,dh); };
  if(img.complete&&img.naturalWidth) draw(); else img.addEventListener('load',draw);
  return cv;
}
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
// ---- per-screen test harness: drive every value + sprite the screen consumes, watch it react ----
function screenBindPaths(){ const s=new Set();
  for(const w of SCR.widgets){ (String(w.text||'').match(/\{[^}]+\}/g)||[]).forEach(m=>s.add(m.slice(1,-1))); } return [...s]; }
async function scrTest(){
  await scrRefresh();  // seed values from the live game so you start from a real state
  const paths=screenBindPaths();
  const sprites=SCR.widgets.filter(w=>w.type==='sprite');
  const menus=SCR.widgets.filter(w=>w.type==='buildmenu');
  let h='<div style="font-weight:bold">&#129514; Test harness</div>';
  h+='<div class="muted" style="font-size:11px;margin-bottom:4px">Drive every column this screen binds; it re-renders live. Confirms which values + sprites influence it.</div>';
  h+='<div style="font-weight:bold;font-size:12px">Bound columns ('+paths.length+')</div>';
  if(!paths.length) h+='<div class="muted" style="font-size:11px">(none)</div>';
  for(const p of paths){ const v=BINDV[p];
    h+='<div style="display:flex;justify-content:space-between;gap:6px;align-items:center;margin:1px 0">'
      +'<code style="font-size:10px">'+esc(p)+'</code>'
      +'<input data-tp="'+esc(p)+'" value="'+esc(v===undefined||v===null?'':v)+'" style="width:76px;font-size:11px"></div>'; }
  h+='<div style="font-weight:bold;font-size:12px;margin-top:6px">Sprites ('+sprites.length+')</div>';
  for(const s of sprites) h+='<div class="muted" style="font-size:10px">'+esc(s.sheet||'?')+' #'+(s.frame||0)+'</div>';
  if(menus.length) h+='<div class="muted" style="font-size:10px">+ '+menus.length+' dynamic build-menu</div>';
  if(!sprites.length&&!menus.length) h+='<div class="muted" style="font-size:11px">(none)</div>';
  const box=$('#stest'); box.innerHTML=h;
  box.querySelectorAll('[data-tp]').forEach(el=>el.oninput=()=>{ const p=el.dataset.tp; const n=parseFloat(el.value);
    BINDV[p]=(el.value!==''&&!isNaN(n))?n:el.value; scrRender(); });
}
function scrRender(){
  const st=$('#sstage'); st.innerHTML='';
  if(SCR.background){ const img=document.createElement('img'); img.className='bg'; img.src='/assets/pik/'+SCR.background+'.png'; img.onerror=()=>img.style.display='none'; st.appendChild(img); }
  for(const w of SCR.widgets){
    const r=w.rect||[0,0,40,8]; const d=document.createElement('div'); d.className='swidget'+(w===selW?' sel':'');
    d.style.left=(r[0]*SS)+'px'; d.style.top=(r[1]*SS)+'px'; d.style.width=(r[2]*SS)+'px'; d.style.height=(r[3]*SS)+'px';
    if(w.type==='rect'){ d.style.background='rgb('+(w.color||'0,0,0')+')'; }
    else if(w.type==='sprite'){ d.appendChild(spriteEl(w)); }
    else if(w.type==='buildmenu'){ d.style.color='#8ad'; d.style.font='11px ui-monospace,monospace'; d.style.border='1px dashed #456'; d.textContent='[dynamic build menu: colony '+(w.colony||0)+']'; }
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
  const F=[['game.year','Year'],['game.season','Season'],['game.turn','Turn'],['game.difficulty','Difficulty'],['power0.gold','Gold'],['power0.tax','Tax %'],['colony0.population','Colony pop'],['natives.tension','Native tension'],['revolution.sol','Sons of Liberty'],['congress.bells','Congress bells'],
    ['power1.mil_strength','P1 military'],['power1.econ_strength','P1 economy'],['power2.mil_strength','P2 military'],['power2.econ_strength','P2 economy'],['power3.mil_strength','P3 military'],['power3.econ_strength','P3 economy']];
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
    else if(w.type==='sprite'){ d.appendChild(spriteEl(w)); }
    else if(w.type==='buildmenu'){ d.style.overflow='auto'; d.style.color='rgb('+(w.color||'220,220,220')+')'; d.style.font='11px ui-monospace,monospace'; renderBuildMenu(d, w); }
    else { d.style.color='rgb('+(w.color||'255,255,255')+')'; const fs=Math.max(8,Math.min(16,r[3]*SS-2)); d.style.font=fs+'px ui-monospace,monospace'; d.style.lineHeight=(r[3]*SS)+'px'; d.textContent=(w.type==='button')?('[ '+interp(w.text)+' ]'):interp(w.text); }
    if(w.type==='button'&&w.onClick) d.onclick=()=>pvFire(w.onClick);
    st.appendChild(d);
  }
}
// Dynamic build menu: lists the @BUILDING rows this colony can actually construct right now
// (population >= min_colony, not already built, not the current target) with a working Build button.
async function renderBuildMenu(host, w){
  const ci = w.colony||0;
  host.textContent='Loading construction options...';
  let tbl, pop, target;
  try {
    tbl = await (await fetch('/api/tables?file=names')).json();
    pop = (await (await fetch('/api/bind?path=colony'+ci+'.population')).json()).value;
    target = (await (await fetch('/api/bind?path=colony'+ci+'.build_target')).json()).value;
  } catch(e){ host.textContent='build menu unavailable'; return; }
  const sec = tbl['@BUILDING']||tbl.BUILDING||{}; const rows = sec.rows||[];
  const elig=[];
  await Promise.all(rows.map(async (r,i)=>{
    let built=0; try{ built=(await (await fetch('/api/bind?path=colony'+ci+'.built.'+i)).json()).value; }catch(e){}
    if(!built && pop>=(+r.min_colony) && i!==target) elig.push({i, name:r.name, cost:+r.cost, min:+r.min_colony});
  }));
  elig.sort((a,b)=>a.cost-b.cost);
  host.innerHTML='<div style="opacity:.7;margin-bottom:3px">Available construction (pop '+pop+'):</div>';
  if(!elig.length){ host.innerHTML+='<div style="opacity:.6">Nothing new to build here.</div>'; return; }
  for(const e of elig){
    const row=document.createElement('div'); row.style.cssText='display:flex;justify-content:space-between;align-items:center;gap:8px;padding:1px 0';
    row.innerHTML='<span>'+esc(e.name)+' <span style="opacity:.6">('+e.cost+'h)</span></span>';
    const b=document.createElement('button'); b.className='act'; b.style.cssText='padding:0 6px;font-size:11px'; b.textContent='Build';
    b.onclick=async()=>{ try{ const r=await (await fetch('/api/colony/build',{method:'POST',body:JSON.stringify({colony:ci,building:e.i})})).json(); ui.toast(r.msg||'built'); }catch(e){ ui.toast('build failed'); } scrPreview(); };
    row.appendChild(b); host.appendChild(row);
  }
}
async function pvNav(id){ ui.close(); $('#scrpick').value=id; await scrLoad(); scrPreview(); }
async function pvFire(graphId){
  const d=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id:graphId})})).json();
  if(d.goto){ pvNav(d.goto); return; }
  if((d.effects||[]).length) ui.toast(d.effects.join('; '));
  if(d.popup) pvPopup(graphId, d.popup);
}
// Screen-preview popup: resume re-renders any chained popup (staying on this graph) so a
// multi-stage screen action isn't truncated; cache:p._cache keeps rolled values stable.
function pvPopup(graphId, p){
  ui.popup(esc(p.title),'<p>'+esc(p.body).replace(/\n/g,'<br>')+'</p>'+popupSprites(p)+'<div id="pvch"></div>');
  const box=$('#pvch'), ch=p.choices||[];
  const resume=async(c)=>{
    const r=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id:graphId,from_node:p.node,choice:c,cache:p._cache})})).json();
    if(r.goto){ pvNav(r.goto); return; }
    if(r.popup){ pvPopup(graphId, r.popup); return; }
    ui.close(); if((r.effects||[]).length) ui.toast(r.effects.join('; ')); scrPreview(); };
  if(!ch.length){ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent='Continue'; b.onclick=()=>{ ui.close(); scrPreview(); }; box.appendChild(b); return; }
  ch.forEach(c=>{ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent=c; b.onclick=()=>resume(c); box.appendChild(b); });
}
document.querySelector('nav button[data-tab=screens]').addEventListener('click',()=>{ if(!SINIT){ SINIT=true; scrInit(); } });

// ---- Schema tab: browse the game database (reference/state/config tables + the reverse index) ----
let SCHEMA=null, SCHREV={};
async function schemaInit(force){
  if(SCHEMA && !force){ schemaRender(); return; }
  try{
    SCHEMA=await (await fetch('/api/schema')).json();
    const fn=await (await fetch('/api/functions')).json(); SCHREV=fn.reverse_index||{};
  }catch(e){ $('#schbody').innerHTML='<span class="fail">schema unavailable</span>'; return; }
  schemaRender();
}
function schemaRender(){
  if(!SCHEMA) return;
  const q=($('#schfilter').value||'').toLowerCase();
  const tabs=SCHEMA.tables||{}; const kc=SCHEMA.kind_counts||{};
  $('#schsummary').textContent=Object.keys(tabs).length+' tables ('+(kc.reference||0)+' reference, '+(kc.state||0)+' state, '+(kc.config||0)+' config)';
  const order={state:0,config:1,reference:2};
  const names=Object.keys(tabs).sort((a,b)=>(order[tabs[a].kind]-order[tabs[b].kind])||a.localeCompare(b));
  let h='';
  for(const name of names){
    const t=tabs[name]; const cols=t.columns||[];
    const hit=name.toLowerCase().includes(q)||cols.some(c=>c.name.toLowerCase().includes(q));
    if(q && !hit) continue;
    const badge={state:'#8ad',config:'#da8',reference:'#8d8'}[t.kind]||'#999';
    h+='<details style="margin:4px 0;border:1px solid #2a2f3a;border-radius:6px;padding:4px 8px"'+(q?' open':'')+'>';
    h+='<summary><b>'+esc(name)+'</b> <span style="color:'+badge+'">'+t.kind+'</span> '
      +'<span class="muted">'+(t.cardinality||'')+(t.index?' &middot; '+esc(t.index):'')+' &middot; '+cols.length+' cols</span></summary>';
    h+='<table style="width:100%;border-collapse:collapse;font-size:12px;margin:4px 0">';
    h+='<tr class="muted"><td>column</td><td>type</td><td>rw</td><td>tier</td><td>meaning</td><td>updated by</td></tr>';
    for(const c of cols){
      // path form for the reverse index (state tables use the index prefix)
      let key=c.name;
      if(t.kind==='state'&&t.index&&t.index!==''&&!c.name.includes('.')) key=t.index+'.'+c.name;
      else if(t.kind==='state'&&t.index) { const cn=c.name; key=(t.index?t.index+'.':'')+cn; }
      const writers=SCHREV[key]||SCHREV[c.name]||[];
      h+='<tr><td><code>'+esc(c.name)+'</code></td><td>'+esc(c.type||'')+'</td><td>'+esc(c.rw||'')
        +'</td><td>'+esc(c.tier||'')+'</td><td class="muted">'+esc(c.meaning||'')+'</td>'
        +'<td class="muted">'+(writers.length?esc(writers.join(', ')):'')+'</td></tr>';
    }
    h+='</table></details>';
  }
  $('#schbody').innerHTML=h||'<span class="muted">no tables match</span>';
}
document.querySelector('nav button[data-tab=schema]').addEventListener('click',()=>schemaInit());

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
// #68 opening flow: pick a nation + difficulty (from @COUNTRY / @LEADERNAME / @DIFFICULTY),
// then POST /api/game/setup to seed the scenario. The cards are data, not authored strings.
let SETUP={nation:0,difficulty:1,country:[],leaders:[],diff:[]};
async function newGameSetup(){
  let names={}; try{ names=await (await fetch('/api/tables?file=names')).json(); }catch(e){}
  SETUP.country=(names['@COUNTRY']&&names['@COUNTRY'].rows)||[];
  SETUP.leaders=(names['@LEADERNAME']&&names['@LEADERNAME'].rows)||[];
  SETUP.diff=(names['@DIFFICULTY']&&names['@DIFFICULTY'].rows)||[];
  const gc='display:inline-block;min-width:120px;margin:4px;padding:8px 10px;border-radius:6px;background:#1c2330;cursor:pointer;border:1px solid #555;vertical-align:top';
  const natCard=(r,i)=>'<span class="gc nat" data-i="'+i+'" onclick="pickNation('+i+')" style="'+gc+'">'
    +'<b>'+esc(r.name)+'</b><br><span class="muted" style="font-size:11px">'+esc((SETUP.leaders[i]&&SETUP.leaders[i].name)||'')+'</span></span>';
  const difCard=(r,i)=>'<span class="gc dif" data-i="'+i+'" onclick="pickDiff('+i+')" style="'+gc+';min-width:96px">'+esc(r.name)+'</span>';
  const html='<div class="muted" style="max-width:520px">Choose your nation and difficulty. Starting gold, colonies and the King\'s expeditionary force are seeded from the scenario and the difficulty level.</div>'
    +'<h4 style="margin:10px 0 2px">Nation</h4><div id="nats">'+SETUP.country.map(natCard).join('')+'</div>'
    +'<h4 style="margin:10px 0 2px">Difficulty</h4><div id="difs">'+SETUP.diff.map(difCard).join('')+'</div>'
    +'<div class="row" style="margin-top:12px"><button class="act" onclick="beginGame()">Begin in the New World &#9654;</button></div>';
  ui.popup('New Game', html);
  pickNation(SETUP.nation); pickDiff(SETUP.difficulty);
}
function pickNation(i){ SETUP.nation=i;
  document.querySelectorAll('#nats .gc').forEach(e=>{ e.style.outline=(+e.dataset.i===i)?'2px solid #e2aa28':'none'; }); }
function pickDiff(i){ SETUP.difficulty=i;
  document.querySelectorAll('#difs .gc').forEach(e=>{ e.style.outline=(+e.dataset.i===i)?'2px solid #e2aa28':'none'; }); }
async function beginGame(){
  ui.close(); SEL=-1;
  try{ const r=await fetch('/api/game/setup',{method:'POST',body:JSON.stringify({nation:SETUP.nation,difficulty:SETUP.difficulty})}); GAME=await r.json(); }
  catch(e){ $('#ghud').innerHTML='<span class="fail">game unavailable</span>'; return; }
  drawGame(); showSel(); fillEvents();
  const nn=(SETUP.country[SETUP.nation]||{}).name||'?', dn=(SETUP.diff[SETUP.difficulty]||{}).name||'?';
  ui.toast('New game — '+nn+', '+dn+' ('+GAME.year+')');
}

// ---- #67 isolated colony sandbox: a self-contained colony over the real sim ----
let SB=null, SBBUILDINGS=[];
async function sbInit(){
  if(!SBBUILDINGS.length){ try{ const names=await (await fetch('/api/tables?file=names')).json();
    SBBUILDINGS=(names['@BUILDING']&&names['@BUILDING'].rows)||[]; }catch(e){}
    $('#sbbuild').innerHTML=SBBUILDINGS.map((r,i)=>'<option value="'+i+'">'+esc(r.name)+' ('+r.cost+'h, min '+r.min_colony+')</option>').join(''); }
  if(!SB) await sbLoad();
}
async function sbLoad(){ SB=await (await fetch('/api/sandbox/state')).json(); sbRender(); }
async function sbNew(){ SB=await (await fetch('/api/sandbox/new',{method:'POST',body:JSON.stringify({pop:3})})).json(); sbRender(); ui.toast('Fresh colony (pop 3)'); }
async function sbAddPop(){ SB=await (await fetch('/api/sandbox/addpop',{method:'POST',body:'{}'})).json(); sbRender(); }
async function sbStep(n){ SB=await (await fetch('/api/sandbox/step',{method:'POST',body:JSON.stringify({n})})).json(); sbRender(); ui.toast('Year '+SB.year); }
async function sbSet(path,value){ SB=await (await fetch('/api/sandbox/set',{method:'POST',body:JSON.stringify({path,value:+value})})).json(); sbRender(); }
async function sbBuild(){ const bid=+$('#sbbuild').value;
  const r=await (await fetch('/api/sandbox/build',{method:'POST',body:JSON.stringify({building:bid})})).json(); SB=r; sbRender(); ui.toast(r.msg||''); }
async function sbRush(){ const r=await (await fetch('/api/sandbox/rush',{method:'POST',body:'{}'})).json();
  if(r.error){ ui.toast(r.error); return; } SB=r; sbRender(); ui.toast(r.msg||''); }
function sbRender(){
  if(!SB) return;
  const built=(SB.built||[]).map(b=>esc((SBBUILDINGS[b]||{}).name||('#'+b))).join(', ')||'&mdash;';
  let h='<h3 style="margin:2px 0">Colony &middot; '+SB.year+'</h3>';
  h+='<table><tr><td>Population</td><td><b>'+SB.population+'</b></td></tr>';
  h+='<tr><td>Sons of Liberty</td><td>'+SB.sol+'%</td></tr>';
  h+='<tr><td>Bells / Hammers / Food / Crosses</td><td>'+SB.bells+' / '+SB.hammers+' / '+SB.food+' / '+SB.crosses+'</td></tr>';
  const bn=SB.building_name||'';
  h+='<tr><td>Building</td><td>'+(SB.build_target<0?'<span class="muted">idle</span>':(esc(bn)+' &mdash; '+SB.build_bank+' of '+SB.build_cost+' hammers ('+SB.build_remaining+' left)'))+'</td></tr>';
  h+='<tr><td>Built</td><td>'+built+'</td></tr></table>';
  h+='<h4 style="margin:10px 0 2px">Warehouse</h4><table><tr>';
  (SB.stockpile||[]).forEach((v,i)=>{ h+='<td style="padding:1px 6px">'+GOODS[i]+':<b>'+v+'</b></td>'; if(i%4===3)h+='</tr><tr>'; });
  h+='</tr></table>';
  $('#sbcol').innerHTML=h;
  // outside variables (each writes a real binding on the sandbox store)
  const row=(label,path,val)=>'<div class="row" style="margin:2px 0"><span style="display:inline-block;width:90px">'+label+'</span>'
    +'<input type="number" value="'+val+'" style="width:90px" onchange="sbSet(\''+path+'\',this.value)"></div>';
  $('#sbvars').innerHTML=
     row('Gold','power0.gold',SB.gold)
    +row('Tax %','power0.tax',SB.tax)
    +row('Population','colony0.population',SB.population)
    +row('Sugar stock','colony0.stockpile.1',(SB.stockpile||[])[1]||0)
    +row('Ore stock','colony0.stockpile.6',(SB.stockpile||[])[6]||0);
}
document.querySelector('nav button[data-tab=sandbox]').addEventListener('click',()=>{ sbInit(); });
async function fillEvents(){ try{ const ids=await (await fetch('/api/graphs')).json();
  $('#evpick').innerHTML=ids.map(i=>'<option>'+esc(i)+'</option>').join(''); }catch(e){} }
async function refreshGame(){ GAME=await (await fetch('/api/game/state')).json(); drawGame(); showSel(); }
async function fireEvent(){
  const id=$('#evpick').value; if(!id) return;
  const d=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id})})).json();
  await refreshGame();
  if((d.effects||[]).length) ui.toast(d.effects.join('; '));
  if(d.popup) playPopup(id, d.popup);
}
// Render an event popup and, on a choice, resume the graph -- re-rendering ANY further popup the
// resume returns (a chained ShowPopup) so a multi-stage event is not silently truncated. cache:p._cache
// keeps rolled/offered values stable across each choice.
function playPopup(id, p){
  ui.popup(esc(p.title),'<p>'+esc(p.body).replace(/\n/g,'<br>')+'</p>'+popupSprites(p)+'<div id="evch"></div>');
  const box=$('#evch'), ch=p.choices||[];
  const resume=async(c)=>{ ui.close();
    const r=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id,from_node:p.node,choice:c,cache:p._cache})})).json();
    await refreshGame();
    if(r.popup) playPopup(id, r.popup);
    else if((r.effects||[]).length) ui.toast(r.effects.join('; ')); };
  if(!ch.length){ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent='Continue'; b.onclick=()=>ui.close(); box.appendChild(b); return; }
  ch.forEach(c=>{ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent=c; b.onclick=()=>resume(c); box.appendChild(b); });
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
  showEventPopup(e.graph, p, q);
}
// Like playPopup, but for the per-turn event batch: a chained popup within one event re-renders
// (staying on this event's graph); when the chain ends, advance to the next queued event.
function showEventPopup(id, p, q){
  ui.popup(esc(p.title), '<p>'+esc(p.body).replace(/\n/g,'<br>')+'</p>'+popupSprites(p)+'<div id="eqch"></div>');
  const box=$('#eqch'), ch=p.choices||[];
  const resume=async(c)=>{ ui.close();
    const r=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id,from_node:p.node,choice:c,cache:p._cache})})).json();
    await refreshGame();
    if(r.popup) showEventPopup(id, r.popup, q);
    else eventQueue(q); };
  if(!ch.length){ const b=document.createElement('button'); b.className='act'; b.textContent='Continue'; b.onclick=()=>{ ui.close(); refreshGame(); eventQueue(q); }; box.appendChild(b); return; }
  ch.forEach(c=>{ const b=document.createElement('button'); b.className='act'; b.style.margin='3px'; b.textContent=c; b.onclick=()=>resume(c); box.appendChild(b); });
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
refreshActive();
rulesInitGrid();
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
