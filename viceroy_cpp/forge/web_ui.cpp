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
  <button data-tab="systems">Systems</button>
  <button data-tab="logic">Logic</button>
  <button data-tab="turn">Turn</button>
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
      <label><input type="radio" name="atype" value="individual" checked onchange="renderAssets()"> individual sprites</label>
      <label><input type="radio" name="atype" value="sprites" onchange="renderAssets()"> sprite sheets</label>
      <label><input type="radio" name="atype" value="backgrounds" onchange="renderAssets()"> backgrounds</label>
      <span id="ainfo" class="muted"></span>
    </div>
    <p class="muted">Every sprite cut out of the sheets and labelled (ICONS units, buildings, terrain, PHYS0 overlays) &mdash; filter by name/sheet. Click any to view full size.</p>
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

  <section id="turn" class="tab">
    <div class="row">
      <button class="act" onclick="turnSave()">Save pipeline</button>
      <button class="act" onclick="turnLoad()">Reload</button>
      <span class="muted">The turn loop is data (turn.json). Toggle a phase off to skip it,
        drag order with &#9650;/&#9660;; the next End turn uses the edited pipeline. run_turn
        iterates this; a golden-master test proves the default order == the reference sim.</span>
    </div>
    <div id="turnlist" style="max-width:760px"></div>
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
      <button class="act" onclick="openingPlay()" title="The OPENING.EXE title pageant (cinematics.md 6)">&#9654; Opening</button>
      <button class="act" onclick="newGameSetup()">New game&hellip;</button>
      <button class="act" onclick="stepGame()">End turn &#9654;</button>
      <button class="act" id="foundbtn" onclick="foundColony()" disabled>Found colony</button>
      <button class="act" onclick="euOpen()" title="The Royal port: market, docks, recruiting (spec/ui/europe_screen.md)">Europe (E)</button>
      <button class="act" onclick="nvOpen()" title="The game's main screen at native 320x200 (spec/ui/map_view.md)">Native HUD</button>
      <button class="act" onclick="trOpen()" title="Define automated cargo routes for ships and wagon trains (spec/systems/trade_routes.md)">Trade routes</button>
      <button class="act" onclick="saveGame()">Save</button>
      <button class="act" onclick="loadGame()">Load</button>
      <span class="muted">Click a unit to select it, then click a tile to send it (it routes
        around coastline over the following turns). End turn advances the whole world.</span>
    </div>
    <div class="row" id="reportbar">
      <span class="muted" style="margin-right:4px">Reports (F1&ndash;F10):</span>
    </div>
    <div class="row"><span id="selinfo" class="muted">No unit selected.</span></div>
    <div class="row">
      <select id="evpick"></select>
      <button class="act" onclick="fireEvent()">Fire event</button>
      <span class="muted">Fire an authored event graph (from the Logic tab) against this live game.</span>
    </div>
    <div style="display:flex; gap:16px; align-items:flex-start; flex-wrap:wrap">
      <canvas id="gcv" width="640" height="480"></canvas>
      <div style="min-width:250px">
        <div id="ghud"></div>
        <h4 style="margin:10px 0 2px">History</h4>
        <canvas id="ghist" width="250" height="90" style="background:#0f1520;border:1px solid #333"></canvas>
        <div class="muted" style="font-size:11px"><span style="color:#e2c14a">&#9632;</span> gold
          &nbsp;<span style="color:#6cc06c">&#9632;</span> Sons of Liberty</div>
      </div>
    </div>
  </section>

  <section id="systems" class="tab">
    <div class="row">
      <input id="sysfilter" placeholder="filter: name / knob / column&hellip;" style="width:260px" oninput="sysRender()">
      <button class="act" onclick="sysTrace()">&#9654; Step 1 turn &mdash; trace writes</button>
      <span class="muted">Every mechanic as its spec formula: what it reads (knobs editable live), what it writes,
        the live value, and &mdash; after a traced turn &mdash; exactly which cells it changed.</span>
    </div>
    <div id="systrace" style="margin-top:8px"></div>
    <div id="syscards" style="margin-top:8px"></div>
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
$('#modal').addEventListener('click', e=>{ if(e.target===$('#modal')){ if(CONGRESS_VIEW){congressClose();} else ui.close(); } });
window.addEventListener('keydown', e=>{ if(e.key==='Escape'){ if(CONGRESS_VIEW){congressClose();} else ui.close(); } });
// F opens the Continental Congress from the Sandbox tab (the game's F-key report), unless typing.
window.addEventListener('keydown', e=>{ const t=document.activeElement&&document.activeElement.tagName;
  if((e.key==='f'||e.key==='F')&&t!=='INPUT'&&t!=='TEXTAREA'&&t!=='SELECT'
     && $('#sandbox') && $('#sandbox').classList.contains('active')){
    if(CONGRESS_VIEW) congressAdvance(); else congressOpen(); } });
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
let ASSETS = null, SLICED = null;
const SPR_SCALE = 3;   // common display scale: a 16px map tile -> 48px; a 32px unit -> 96px (true ratio)
function assetType(){ const r=document.querySelector('input[name=atype]:checked'); return r?r.value:'individual'; }
function assetURL(type, name){ return '/assets/'+(type==='backgrounds'?'pik':'sprites')+'/'+name; }
async function loadAssets(){
  try { const r=await fetch('/api/assets'); ASSETS=await r.json(); }
  catch(e){ $('#ainfo').innerHTML='<span class="fail">assets unavailable (run from repo root)</span>'; }
  try { SLICED=(await (await fetch('/api/sprites/sliced')).json()).sprites||[]; }catch(e){ SLICED=[]; }
  renderAssets();
}
function renderAssets(){
  const type=assetType(); const f=$('#assetfilter').value.trim().toUpperCase();
  if(type==='individual'){
    const list=SLICED||[];
    const shown=list.filter(s=>!s.blank && (!f || (s.label+' '+s.sheet).toUpperCase().includes(f)));
    $('#ainfo').textContent=shown.length+' / '+list.length+' sprites (scale: 16px map tile ×'+SPR_SCALE+')';
    // one common scale so relative sizes are true (16px tile -> a 32px unit is 2 tiles tall).
    // checkerboard background makes the transparent areas read as transparent, not black.
    const CHECK='background-image:linear-gradient(45deg,#bbb 25%,transparent 25%,transparent 75%,#bbb 75%),linear-gradient(45deg,#bbb 25%,#eee 25%,#eee 75%,#bbb 75%);background-size:8px 8px;background-position:0 0,4px 4px';
    $('#agallery').innerHTML=shown.map(s=>{
      const u='/assets/sliced/'+s.file.replace('data_extracted/sprites/','');
      const w=(s.w||16)*SPR_SCALE, h=(s.h||16)*SPR_SCALE;
      return '<figure class="thumb" data-url="'+u+'" data-label="'+esc(s.sheet+' #'+s.index+' — '+s.label+' ('+s.w+'×'+s.h+')')+'">'
        +'<div style="'+CHECK+';display:inline-block;padding:2px"><img loading="lazy" style="image-rendering:pixelated;width:'+w+'px;height:'+h+'px;display:block" src="'+u+'"></div>'
        +'<figcaption>'+esc(s.label)+'<br><span class="muted" style="font-size:9px">'+s.sheet+' #'+s.index+' &middot; '+s.w+'×'+s.h+'</span></figcaption></figure>';
    }).join('');
    return;
  }
  if(!ASSETS) return;
  const list=ASSETS[type]||[];
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
// ICONS is the FULL ICONS.SS (131 frames at native size; per-frame rects lazy-loaded from
// icons.json, frame = ssdec index = EXE sprite id - 1). UNITS/UNIT = the 24 32x32 unit crops.
const SHEETS={
  BUILDING:{url:'/assets/tileset/buildings.png',cw:56,ch:48,n:48},
  UNIT:{url:'/assets/tileset/units.png',cw:32,ch:32,n:24},
  UNITS:{url:'/assets/tileset/units.png',cw:32,ch:32,n:24},
  ICONS:{url:'/assets/tileset/icons.png',rectsUrl:'/assets/tileset/icons.json',n:131}};
const SHEETIMG={};
// Per-frame rects for variable-width sheets (ICONS): frame -> {x,w,h}, loaded once on demand.
function sheetRects(sh,then){
  if(sh.rects) return then();
  if(sh._loading){ sh._loading.push(then); return; }
  sh._loading=[then];
  fetch(sh.rectsUrl).then(r=>r.json()).then(d=>{
    sh.rects={}; d.frames.forEach(f=>sh.rects[f.frame]={x:f.x,w:f.w,h:f.h});
    sh._loading.forEach(fn=>fn()); sh._loading=null;
  });
}
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
    const rc=sh.rects?sh.rects[f]:null;
    const sx=rc?rc.x:f*sh.cw, sw=rc?rc.w:sh.cw, shh=rc?rc.h:sh.ch;
    const sc=Math.min(cv.width/sw,cv.height/shh),dw=sw*sc,dh=shh*sc;
    g.drawImage(img,sx,0,sw,shh,(cv.width-dw)/2,(cv.height-dh)/2,dw,dh); };
  const kick=()=>{ if(img.complete&&img.naturalWidth) draw(); else img.addEventListener('load',draw); };
  if(sh.rectsUrl) sheetRects(sh,kick); else kick();
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
let SB=null, SBBUILDINGS=[], SBFATHERS=[];
// assignable jobs: a colonist can work a ring tile (raw good, on the given terrain) or a building.
const SBJOBS=[
  {label:'Farmer → Food (Plains)',      prof:0,  good:0,  tile:0, terrain:2},
  {label:'Fisherman → Food (Ocean)',    prof:8,  good:0,  tile:1, terrain:25},
  {label:'Lumberjack → Lumber (Forest)',prof:5,  good:5,  tile:2, terrain:8},
  {label:'Ore Miner → Ore (Hills)',     prof:6,  good:6,  tile:3, terrain:28},
  {label:'Fur Trapper → Furs (Forest)', prof:4,  good:4,  tile:4, terrain:8},
  {label:'Sugar Planter → Sugar',       prof:1,  good:1,  tile:5, terrain:5},
  {label:'Cotton Planter → Cotton',     prof:3,  good:3,  tile:6, terrain:3},
  {label:'Tobacco Planter → Tobacco',   prof:2,  good:2,  tile:7, terrain:4},
  {label:'Statesman → Bells (Town Hall)',prof:17, good:18, tile:-1},
  {label:'Carpenter → Hammers (from Lumber)',prof:13,good:16,tile:-1},
  {label:'Preacher → Crosses (Church)', prof:16, good:17, tile:-1},
  {label:'Distiller → Rum (from Sugar)',prof:9,  good:9,  tile:-1},
  {label:'Blacksmith → Tools (from Ore)',prof:14,good:14, tile:-1},
];
async function sbInit(){
  if(!SBBUILDINGS.length){ try{ const names=await (await fetch('/api/tables?file=names')).json();
    SBBUILDINGS=(names['@BUILDING']&&names['@BUILDING'].rows)||[]; }catch(e){}
    $('#sbbuild').innerHTML=SBBUILDINGS.map((r,i)=>'<option value="'+i+'">'+esc(r.name)+' ('+r.cost+'h, min '+r.min_colony+')</option>').join(''); }
  if(!SBFATHERS.length){ try{ SBFATHERS=await (await fetch('/api/fathers')).json(); }catch(e){} }
  if(!SB) await sbLoad();
}
async function sbLoad(){ SB=await (await fetch('/api/sandbox/state')).json(); sbRender(); }
async function sbAssign(){ const j=SBJOBS[+$('#sbjob').value]||SBJOBS[0]; const expert=$('#sbexpert').checked?1:0;
  SB=await (await fetch('/api/sandbox/assign',{method:'POST',body:JSON.stringify({profession:j.prof,good:j.good,tile:j.tile,terrain:j.terrain||0,expert})})).json();
  sbRender(); ui.toast('Assigned '+j.label); }
async function sbUnassign(i){ SB=await (await fetch('/api/sandbox/unassign',{method:'POST',body:JSON.stringify({worker:i})})).json(); sbRender(); }
async function sbSell(){ const gd=+$('#sbsellgood').value; const qty=+($('#sbsellqty').value||0);
  const r=await (await fetch('/api/sandbox/sell',{method:'POST',body:JSON.stringify({good:gd,qty})})).json();
  if(r.error){ ui.toast(r.error); return; } SB=r; sbRender(); ui.toast(r.msg||'sold'); }
async function sbNew(){ SB=await (await fetch('/api/sandbox/new',{method:'POST',body:JSON.stringify({pop:3})})).json(); sbRender(); ui.toast('Fresh colony (pop 3)'); }
async function sbAddPop(){ SB=await (await fetch('/api/sandbox/addpop',{method:'POST',body:'{}'})).json(); sbRender(); }
async function sbStep(n){ SB=await (await fetch('/api/sandbox/step',{method:'POST',body:JSON.stringify({n})})).json(); sbRender(); ui.toast('Year '+SB.year); }
async function sbSet(path,value){ SB=await (await fetch('/api/sandbox/set',{method:'POST',body:JSON.stringify({path,value:+value})})).json(); sbRender(); }
async function sbBuild(){ const bid=+$('#sbbuild').value;
  const r=await (await fetch('/api/sandbox/build',{method:'POST',body:JSON.stringify({building:bid})})).json(); SB=r; sbRender(); ui.toast(r.msg||''); }
async function sbRush(){ const r=await (await fetch('/api/sandbox/rush',{method:'POST',body:'{}'})).json();
  if(r.error){ ui.toast(r.error); return; } SB=r; sbRender(); ui.toast(r.msg||''); }
// what a building does, for the ones that drive production (shown in the Buildings table).
const BLD_ROLE={9:'Statesmen &rarr; Bells',35:'Carpenters &rarr; Hammers (from Lumber)',37:'Preachers &rarr; Crosses',
  27:'Rum &larr; Sugar',24:'Cigars &larr; Tobacco',21:'Cloth &larr; Cotton',32:'Coats &larr; Furs',
  39:'Tools &larr; Ore',3:'Muskets &larr; Tools',17:'Horses &larr; Food surplus',
  18:'Custom House &rarr; auto-sell surplus to Europe (needs Peter Stuyvesant)'};
function sbRender(){
  if(!SB) return;
  let h='<h3 style="margin:2px 0">Colony &middot; '+SB.year+'</h3>';
  h+='<table><tr><td>Population</td><td><b>'+SB.population+'</b></td></tr>';
  const solb=SB.sol_bonus||0;
  h+='<tr><td>Sons of Liberty</td><td>'+SB.sol+'% <span class="muted">'+(solb?'(+'+solb+'/colonist production bonus)':'(no production bonus below 50%)')+'</span></td></tr>';
  h+='<tr><td>Bells / Hammers / Food / Crosses</td><td>'+SB.bells+' / '+SB.hammers+' / '+SB.food+' / '+SB.crosses+'</td></tr>';
  const bn=SB.building_name||'';
  h+='<tr><td>Under construction</td><td>'+(SB.build_target<0?'<span class="muted">idle</span>':(esc(bn)+' &mdash; '+SB.build_bank+' of '+SB.build_cost+' hammers ('+SB.build_remaining+' left)'))+'</td></tr>';
  // food-growth progress: 200 stored food -> a new colonist (USER RULING + warehousing.md); the
  // full food surplus banks in the warehouse each turn.
  if(SB.food_threshold){ const fa=SB.food_accum||0, thr=SB.food_threshold, rate=Math.max(0,SB.food||0);
    const left=rate>0?Math.max(0,Math.ceil((thr-fa)/rate)):null;
    h+='<tr><td>Food &rarr; growth</td><td>'+fa+' / '+thr+' &nbsp;<span class="muted">(+'+rate+'/turn'+(left!=null?', ~'+left+' turns to next colonist':', no surplus')+')</span></td></tr>'; }
  h+='</table>';
  // the colonist roster -- who is here, their specialty, and where they work (the mechanics behind the numbers)
  const cols=SB.colonists||[];
  h+='<h4 style="margin:10px 0 2px">Colonists ('+cols.length+')</h4>';
  if(!cols.length){ h+='<div class="muted">no colonists</div>'; }
  else{ h+='<table style="width:100%"><tr><th>#</th><th>Colonist</th><th>Working</th><th>Produces</th><th>Expert</th><th></th></tr>';
    cols.forEach((w,i)=>{ h+='<tr><td>'+(i+1)+'</td><td><b>'+esc(w.name)+'</b></td><td>'+esc(w.where)
      +'</td><td>'+esc(w.produces)+'</td><td style="text-align:center">'+(w.expert?'&#10003;':'')
      +'</td><td><button class="act" title="unassign" onclick="sbUnassign('+i+')">&times;</button></td></tr>'; });
    h+='</table>'; }
  // assign a new colonist (tile or building) and watch production recompute
  h+='<div class="row" style="margin:4px 0;gap:4px"><select id="sbjob" style="max-width:230px">'
    +SBJOBS.map((j,i)=>'<option value="'+i+'">'+esc(j.label)+'</option>').join('')+'</select>'
    +'<label style="font-size:11px"><input type="checkbox" id="sbexpert"> expert</label>'
    +'<button class="act" onclick="sbAssign()">Assign colonist</button></div>';
  // buildings constructed in this colony (the "which buildings have been built" view)
  const blt=SB.built||[];
  h+='<h4 style="margin:10px 0 2px">Buildings built ('+blt.length+')</h4>';
  if(!blt.length){ h+='<div class="muted">none built</div>'; }
  else{ h+='<table style="width:100%"><tr><th>#</th><th>Building</th><th>Effect</th></tr>';
    blt.forEach(b=>{ const nm=(SBBUILDINGS[b]||{}).name||('building #'+b);
      h+='<tr><td>'+b+'</td><td><b>'+esc(nm)+'</b></td><td class="muted">'+(BLD_ROLE[b]||'')+'</td></tr>'; });
    h+='</table>'; }
  h+='<h4 style="margin:10px 0 2px">Warehouse</h4><table><tr>';
  (SB.stockpile||[]).forEach((v,i)=>{ h+='<td style="padding:1px 6px">'+GOODS[i]+':<b>'+v+'</b></td>'; if(i%4===3)h+='</tr><tr>'; });
  h+='</tr></table>';
  // Europe market (the byte-verified model): each good has a HIDDEN SUPPLY VOLUME -- the seeded
  // base (price_base 600..1000) plus this turn's sell volume (trade +0xFC). Selling builds it,
  // buying drains it; the published price level derives from it (the four finished goods price
  // off the pooled S_pair), clamped to the @CARGO band; bid = level-1, ask = bid+burden+1.
  const mk=SB.market||[]; const pr=SB.prices||[];
  h+='<h4 style="margin:10px 0 2px">Europe market</h4>';
  h+='<div class="'+(SB.custom_house?'':'muted')+'" style="font-size:11px">'
    +(SB.custom_house?'&#10003; Custom House: surplus auto-sells to Europe each turn.'
      :'No Custom House &mdash; over-cap goods spoil; ship &amp; sell below.')
    +' <span class="muted">tax '+(SB.tax||0)+'% (the King\'s cut funds the REF) &middot; selling floods the hidden supply &rarr; price falls</span></div>';
  // horizontal price strip: one cell per tradeable good; bar height = where the bid sits in the
  // good's @CARGO band; the tooltip carries the hidden volume behind it.
  h+='<div style="display:flex;gap:2px;align-items:flex-end;height:60px;margin:4px 0;border-bottom:1px solid #555">';
  mk.forEach((m,i)=>{ if(i<1) return; const lo=m.low||0,hi=m.high||1; const frac=Math.max(0.06,Math.min(1,(m.bid-lo)/Math.max(1,hi-lo)));
    h+='<div title="'+GOODS[i]+' bid '+m.bid+' / ask '+m.ask+' (level '+m.level+', band '+lo+'-'+hi+', supply '+m.supply+' = base '+m.base+' + trade '+m.trade+')" style="flex:1;text-align:center;font-size:9px">'
      +'<div style="height:'+Math.round(frac*44)+'px;background:#8ab;margin:0 1px"></div>'
      +'<div><b>'+m.bid+'</b></div><div class="muted">'+GOODS[i].slice(0,3)+'</div></div>'; });
  h+='</div>';
  h+='<div class="row" style="margin:3px 0;gap:4px"><span style="font-size:11px">Ship &amp; sell</span>'
    +'<select id="sbsellgood">'+GOODS.map((g,i)=> i>=1?('<option value="'+i+'">'+g+' @'+(pr[i]||0)+'g</option>'):'').join('')+'</select>'
    +'<input id="sbsellqty" type="number" placeholder="qty (all)" style="width:80px">'
    +'<button class="act" onclick="sbSell()">Sell to Europe</button></div>';
  // the model's actual drivers per good: the hidden volume and how it becomes the published price
  h+='<details style="margin-top:2px"><summary style="font-size:11px;cursor:pointer">price drivers &mdash; hidden volume &rarr; published price (base | trade | supply | pool share | level | band | bid | ask)</summary>'
    +'<div class="muted" style="font-size:10px;margin:2px 0">supply = base + this turn\'s sold volume; the finished goods (Rum/Cigars/Cloth/Coats) price off the pooled S<sub>pair</sub>='+(SB.s_pair||0)+' as level = S<sub>pair</sub>&times;3 / supply, clamped to the band; bid = level&minus;1; ask = bid + burden + 1</div>'
    +'<table style="width:100%;font-size:10px"><tr><th>Good</th><th>base</th><th>trade</th><th>supply</th><th>share</th><th>level</th><th>band</th><th>burden</th><th>bid</th><th>ask</th></tr>';
  const spair=SB.s_pair||1;
  mk.forEach((m,i)=>{ if(i<1) return;
    const pool=(i>=9&&i<=12)||(i>=1&&i<=4);
    const share=pool?Math.round(100*m.supply/Math.max(1,spair))+'%':'&mdash;';
    h+='<tr'+(m.boycott?' style="opacity:.4"':'')+'><td>'+GOODS[i]+(m.boycott?' (boycott)':'')+'</td><td>'+m.base+'</td><td>'+m.trade+'</td><td><b>'+m.supply+'</b></td><td>'+share+'</td><td>'+m.level+'</td><td>'+m.low+'-'+m.high+'</td><td>'+m.burden+'</td><td><b>'+m.bid+'</b></td><td>'+m.ask+'</td></tr>'; });
  h+='</table></details>';
  // Continental Congress: a compact status line + a button that opens the two-screen report flow
  // (Activities -> portrait view -> back), mirroring the game's F-key cycle.
  const cg=SB.congress||{};
  h+='<h4 style="margin:12px 0 2px">Continental Congress</h4>';
  h+='<div style="font-size:11px">'+(cg.ff_count||0)+'/25 fathers &middot; '+(cg.bells_per_turn||0)
    +' bells/turn &middot; pool '+(cg.bells_pool||0)+'/'+(cg.threshold||0)+'</div>';
  h+='<button class="act" style="margin:4px 0" onclick="congressOpen()">Continental Congress (F)</button>';
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

// ==== Native-screen framework (the baseline for EVERY advisor/game screen) ====
// A native 320x200 (mode 13h) stage over its PIK background, scaled by NS_SC, with widgets
// placed at native (x,y). Palette constants are the byte-resolved REPORT-PIK indices
// (spec/ui/advisor_reports.md 2.3): 0x90 title pale-yellow, 0x92 label bright-yellow,
// 0x61 value cream, 0x91 strength yellow, 0x77 separator dark-red, 0x0F white. Body text is
// FONTTINY (6px glyphs, line pitch 8 -- spec/ui/continental_congress.md "Fonts & colors").
const NS_SC=2.4;
const NS={title:'#FFFFBE', label:'#FFF35D', value:'#F7F3C7', strength:'#FFFF8E',
          rule:'#860000', white:'#FFFFFF', green:'#559634', gold:'#C7A220'};
const NS_PITCH=8;   // FONTTINY line pitch (glyph height 6 + 2)
function nsScreen(bg,inner,extra){
  return '<div '+(extra||'')+' style="position:relative;width:'+(320*NS_SC)+'px;height:'+(200*NS_SC)+'px;'
    +'background:#101014 url(/assets/'+bg+') top left / '+(320*NS_SC)+'px '+(200*NS_SC)+'px no-repeat;'
    +'image-rendering:pixelated;font-family:monospace;overflow:hidden;user-select:none">'+inner+'</div>';
}
// text at native (x,y). opts: col, size (native px, default 6=FONTTINY), w (native), center,
// right (right-align in w), bold, wrap
function nsT(x,y,html,opts){ opts=opts||{};
  const col=opts.col||NS.label, sz=(opts.size||6)*NS_SC;
  const w=opts.w!=null?('width:'+(opts.w*NS_SC)+'px;'):'';
  return '<div style="position:absolute;left:'+(x*NS_SC)+'px;top:'+(y*NS_SC)+'px;'+w
    +(opts.center?'text-align:center;':'')+(opts.right?'text-align:right;':'')
    +(opts.bold?'font-weight:bold;':'')
    +(opts.wrap?'white-space:normal;':'white-space:nowrap;')
    +'color:'+col+';font-size:'+sz+'px;line-height:1.2;text-shadow:1px 1px 0 #000,0 0 3px #000">'+html+'</div>';
}
// a 1px horizontal separator rule (the 0x191F:0x8BC line-fill; F4/F5/F8 use color 0x77)
function nsRule(x0,x1,y,col){
  return '<div style="position:absolute;left:'+(x0*NS_SC)+'px;top:'+(y*NS_SC)+'px;'
    +'width:'+((x1-x0)*NS_SC)+'px;height:'+Math.max(1,Math.round(NS_SC))+'px;background:'+(col||NS.rule)+'"></div>';
}
// the advisor title bar: fill (0,0,320,~7) color 0x90 + the centered verbatim title string
function nsTitle(text){
  return '<div style="position:absolute;left:0;top:0;width:'+(320*NS_SC)+'px;height:'+(7*NS_SC)+'px;'
    +'background:#00000055"></div>'
    + nsT(0,1,esc(text),{col:NS.title,w:320,center:true,bold:true});
}
// the OK button at its spec rect (290,184,26,14); onclickJs runs on click (label = @MISC 46)
function nsOK(onclickJs,label){
  return '<div onclick="event.stopPropagation();'+onclickJs+'" style="position:absolute;'
    +'left:'+(289*NS_SC)+'px;top:'+(183*NS_SC)+'px;width:'+(27*NS_SC)+'px;height:'+(14*NS_SC)+'px;'
    +'border:1px solid '+NS.label+';color:'+NS.label+';font-size:'+(6*NS_SC)+'px;font-weight:bold;'
    +'display:flex;align-items:center;justify-content:center;cursor:pointer;background:#000a;'
    +'text-shadow:1px 1px 0 #000">'+(label||'OK')+'</div>';
}
// one ICONS.SS frame at its native size, drawn at native (x,y) from the packed icons strip
// (per-frame rects in icons.json, lazy-loaded). scale multiplies on top of NS_SC.
let NS_ICONS=null;   // {frames:{frame:{x,w,h}}, width, height} once loaded
function nsIconsReady(then){
  if(NS_ICONS) return then();
  fetch('/assets/tileset/icons.json').then(r=>r.json()).then(d=>{
    const m={}; let W=0; d.frames.forEach(f=>{ m[f.frame]=f; W=Math.max(W,f.x+f.w); });
    NS_ICONS={frames:m,width:W,height:d.height}; then();
  });
}
function nsIcon(frame,x,y,opts){ opts=opts||{};
  const f=NS_ICONS&&NS_ICONS.frames[frame]; if(!f) return '';
  const s=NS_SC*(opts.scale||1);
  return '<div title="'+esc(opts.title||('ICONS '+frame))+'" style="position:absolute;'
    +'left:'+(x*NS_SC)+'px;top:'+(y*NS_SC)+'px;width:'+(f.w*s)+'px;height:'+(f.h*s)+'px;'
    +'background:url(/assets/tileset/icons.png) no-repeat;'
    +'background-size:'+(NS_ICONS.width*s)+'px '+(NS_ICONS.height*s)+'px;'
    +'background-position:-'+(f.x*s)+'px 0;image-rendering:pixelated"></div>';
}
// one crop of a 928px-wide contact-sheet atlas (docs/atlas/sprites/atlas_<sheet>.png;
// frame 0 content starts at (0,16) under the 16px header row), drawn at native (x,y).
// The small baked "0/0x00" cell label is the accepted contact-sheet artifact -- the
// raw .SS files are not in the repo (see wfPortrait).
function nsSheet(sheet,sx,sy,w,h,x,y){
  const S=NS_SC;
  return '<div style="position:absolute;left:'+(x*S)+'px;top:'+(y*S)+'px;'
    +'width:'+(w*S)+'px;height:'+(h*S)+'px;image-rendering:pixelated;'
    +'background:url(/assets/sprites/atlas_'+sheet+'.png) '+(-sx*S)+'px '+(-sy*S)+'px;'
    +'background-size:'+(928*S)+'px auto"></div>';
}
// the shared 0x181F:0x236 PROPORTIONAL filled/empty icon strip (span 300, pitch
// (span-w)/(count-1) clamped [1, w+1]): `value` filled sprites then `max-value` empty ones.
// NOT a fill bar -- the game has none; fullness reads as filled-vs-empty count.
function nsIconStrip(filledFrame,emptyFrame,value,max,x,y,span){
  span=span||300;
  const f=NS_ICONS&&NS_ICONS.frames[filledFrame]; if(!f||max<1) return '';
  const w=f.w, count=Math.max(1,max);
  let pitch=count>1?Math.floor((span-w)/(count-1)):w+1;
  pitch=Math.max(1,Math.min(w+1,pitch));
  let h='';
  for(let i=0;i<count;i++)
    h+=nsIcon(i<value?filledFrame:emptyFrame, x+i*pitch/1, y,
              {title:(i<value?'filled':'empty')+' '+(i+1)+'/'+count});
  return h;
}
// the 0x181F:0x222/0x22C count-badge row: N columns across a span, each an icon + its count
function nsIconRow(items,x,y,span){
  span=span||300;
  const cols=items.length||1, cw=span/cols;
  let h='';
  items.forEach((it,i)=>{
    h+=nsIcon(it.frame, x+i*cw+2, y, {title:it.title||''});
    h+=nsT(x+i*cw, y+20, '<b>'+it.count+'</b>'+(it.label?'<br>'+esc(it.label):''),
           {w:cw, center:true, size:5, col:NS.value});
  });
  return h;
}
// verbatim LABELS.TXT lines by section (cached; index = the spec-cited line number)
const NS_LABELS={};
function nsLabels(section,then){
  if(NS_LABELS[section]) return then(NS_LABELS[section]);
  fetch('/api/labels?section='+section).then(r=>r.json()).then(d=>{ NS_LABELS[section]=d.lines||[]; then(NS_LABELS[section]); });
}
function nsLbl(section,idx,fb){ const L=NS_LABELS[section]; return (L&&L[idx])||fb||''; }

// ---- Continental Congress: the two-screen report flow, drawn to the spec layout ----
// The game's F report cycles map -> screen 1 (the Activities report) -> screen 2 (the portrait view)
// -> map. Both are drawn at the native 320x200 over the CCBKGD.PIK hall backdrop, with widgets at the
// byte-verified band coordinates and colours in spec/ui/continental_congress.md §2 / "Fonts & colors":
// title 0x90 = (255,255,190) pale-yellow, all body text 0x92 = (255,243,93) bright-yellow, FONTTINY.
const SBCATS=['Trade','Exploration','Military','Political','Religious'];
const SBCATCOL=['#c9a227','#3d9bd6','#c0504d','#8064a2','#4f9d69'];  // one accent per category row
let CONGRESS_VIEW=0;   // 0 closed, 1 Activities, 2 portrait view
function congressById(){ const m={}; SBFATHERS.forEach(f=>m[f.id]=f); return m; }
// (legacy aliases -- the Congress screens were the framework prototype; they now ride ns*)
const CC_SC=NS_SC, CC_TITLE=NS.title, CC_BODY=NS.label;
const ccScreen=nsScreen, ccT=nsT;
function ccOK(){ return nsOK('congressAdvance()'); }

// The verbatim @MISC label (pulled by the backend from LABELS.TXT), with a fallback.
function ccLbl(k,fb){ const L=(SB.congress||{}).labels||{}; return (L[k]||fb); }

// Screen 1 -- the Continental Congress Activities report (spec §2 bands, native coords).
function congressActivities(){
  const c=SB.congress||{}, byId=congressById();
  const off=(c.offered!=null?c.offered:-1), offName=(off>=0&&byId[off])?byId[off].name:'—';
  const sol=Math.max(0,Math.min(100,c.national_sol||0));
  const ref=c.ref||{regulars:0,cavalry:0,manowar:0,artillery:0};
  const bpt=c.bells_per_turn||0;
  const owned=(SB.fathers||[]).slice().sort((a,b)=>a-b);
  let h='';
  // Title band (0,0,320,10): centred, pale-yellow -- @MISC[37]
  h+=ccT(0,2,esc(ccLbl('title','CONTINENTAL CONGRESS ACTIVITIES')),{col:CC_TITLE,w:320,center:true,bold:true});
  // Session subtitle band (0,10,320,20): "@MISC[112]: (<FF>) (NN in MM)" -- progress is TEXT, not a bar
  h+=ccT(4,14, c.ff_count>=25 ? 'All 25 '+esc(ccLbl('fathers','Founding Fathers'))+' have joined.'
      : esc(ccLbl('session','Next Continental Congress Session'))+': '+esc(offName)
        +'   ('+(c.remaining||0)+' in '+(c.threshold||0)+')', {w:312});
  // Sentiment strip band (0,36,320,8): "@MISC Rebel Sentiment / Tory Sentiment"
  const sen=esc(ccLbl('sentiment','Sentiment'));
  h+=ccT(4,36,esc(ccLbl('rebel','Rebel'))+' '+sen+': '+sol+'%      '+esc(ccLbl('tory','Tory'))+' '+sen+': '+(100-sol)+'%');
  // Bell icons row band (0,44,320,32): one discrete bell per bell/turn (spec: discrete sprites)
  h+=ccT(4,46,'Liberty Bells / turn: '+bpt);
  h+=ccT(4,55,(bpt>0?'&#128276;'.repeat(Math.min(bpt,30)):'&mdash;'),{size:8});
  // REF band (0,76,320,40): "@MISC[85] Expeditionary Force", four unit groups (spec §5 order)
  h+=ccT(4,72,esc(ccLbl('ref','Expeditionary Force'))+':');
  const badge=(x,label,n)=>ccT(x,84,label+'<br><span style="font-size:'+(9*CC_SC)+'px;font-weight:bold">'+n+'</span>',{w:76,center:true});
  h+=badge(6,'Regulars',ref.regulars)+badge(84,'Cavalry',ref.cavalry)
    +badge(162,'Artillery',ref.artillery)+badge(240,'Man-O-War',ref.manowar);
  // Founding Fathers list band (0,116,320,60): "@MISC[89]", acquired names as text (not portraits)
  h+=ccT(4,112,esc(ccLbl('fathers','Founding Fathers'))+' ('+owned.length+'/25):');
  h+=ccT(4,122,(owned.length? owned.map(id=>esc((byId[id]||{}).name||('#'+id))).join(',  ') : 'none yet'),
        {w:312,wrap:true,size:5});
  h+=ccOK();
  return ccScreen('pik/CCBKGD.png',h);
}

// The founding fathers' fixed positions in the CCBKGD congress hall (native 320x200 coords, portrait
// top-left), authored to reproduce the game's group-portrait crowd: they stand shoulder-to-shoulder in
// three depth rows (drawn back-to-front), Franklin seated centre-front, Cortes (silver armour) centre-
// back, Washington & the naval officers to the right, Pocahontas far right. Each father appears in HIS
// spot as acquired -- the hall fills up. (The original bakes these coords in each CC-NN.SS; not in repo.)
const CC_POS=[
  // {id, x, y}  -- back row (higher up), then middle, then front (nearer, drawn on top)
  {id:20,x:4,y:24},{id:2,x:36,y:22},{id:6,x:70,y:20},{id:5,x:104,y:20},{id:10,x:140,y:16},
  {id:18,x:176,y:20},{id:4,x:210,y:20},{id:23,x:244,y:22},{id:22,x:278,y:24},
  {id:9,x:16,y:54},{id:1,x:52,y:56},{id:7,x:88,y:54},{id:15,x:124,y:54},{id:11,x:162,y:52},
  {id:14,x:198,y:52},{id:12,x:234,y:54},{id:3,x:270,y:56},
  {id:0,x:2,y:90},{id:8,x:40,y:92},{id:17,x:80,y:92},{id:19,x:120,y:96},{id:13,x:160,y:92},
  {id:16,x:198,y:92},{id:21,x:236,y:90},{id:24,x:274,y:92}
];
// Screen 2 -- the Continental Congress portrait view: the founding fathers gathered as a CROWD in the
// hall (not a grid), each revealed in his fixed spot once acquired. Click a father to grant/revoke.
function congressPortraits(){
  const c=SB.congress||{}, owned=new Set(SB.fathers||[]), byId=congressById();
  const offered=(c.offered!=null?c.offered:-1), last=(c.last_ff!=null?c.last_ff:-1);
  let h=ccT(0,2,esc(ccLbl('congress','Continental Congress')).toUpperCase(),{col:CC_TITLE,w:320,center:true,bold:true});
  if(last>=0&&byId[last]) h+=ccT(0,11,'&#9733; '+esc(byId[last].name)+' has joined!',{w:320,center:true,size:5});
  // the crowd: absolutely-positioned portraits at their baked spots, drawn back-to-front (CC_POS order)
  for(const p of CC_POS){
    const f=byId[p.id]; if(!f) continue;
    const on=owned.has(p.id), isOff=(p.id===offered), isNew=(p.id===last);
    // acquired = full colour; not-yet = a dim shadow standing in his spot (lights up on acquire)
    const filt=on?'':'filter:grayscale(1) brightness(.22);opacity:.5';
    const ring=isNew?'outline:2px solid #ffe27a;box-shadow:0 0 8px 2px #ffe27a':(isOff?'outline:2px solid #6cf':'');
    const tip=esc(f.name)+' — '+esc(f.category)+(f.production?' [affects production]':'')+'\n'+esc(f.effect)
      +(on?'':(isOff?'\n(the Congress is working toward this father)':'\n(not yet acquired)'));
    h+='<img src="/assets/'+f.portrait+'" title="'+tip+'" loading="lazy" '
      +'onclick="event.stopPropagation();congressFather('+p.id+','+(on?'false':'true')+')" '
      +'style="position:absolute;left:'+(p.x*CC_SC)+'px;top:'+(p.y*CC_SC)+'px;height:'+(84*CC_SC)+'px;'
      +'width:auto;image-rendering:pixelated;cursor:pointer;'+filt+';'+ring+'">';
  }
  h+=ccOK();
  return ccScreen('pik/CCBKGD.png',h);
}

// The F-key cycle: closed -> Activities -> portraits -> closed. Each screen is a self-contained
// 320x200 stage; clicking anywhere (or OK) advances.
function congressRender(){
  const inner=CONGRESS_VIEW===1?congressActivities():congressPortraits();
  ui.popup('Continental Congress (F) — click to continue',
    '<div onclick="congressAdvance()" style="cursor:pointer">'+inner+'</div>');
}
function congressOpen(){ if(!SB) return; CONGRESS_VIEW=1; congressRender(); }
function congressAdvance(){ if(CONGRESS_VIEW===1){ CONGRESS_VIEW=2; congressRender(); } else congressClose(); }
function congressClose(){ CONGRESS_VIEW=0; ui.close(); sbRender(); }
// Grant/revoke a father from the portrait view and re-render in place (stay on screen 2).
async function congressFather(id,on){
  SB=await (await fetch('/api/sandbox/father',{method:'POST',body:JSON.stringify({id,on})})).json();
  congressRender();
}

// ==== Advisor reports F1-F10 (spec/ui/advisor_reports.md) ====
// Each report is a native 320x200 page over its REPORT<N>.PIK: title fill 0x90 + centered
// verbatim @MISC title, FONTTINY body (x=4, y-seed 25, pitch 8), colors from the byte-resolved
// palette, OK at (289,183). PIK mapping carries the USER RULING: F6 Colony -> REPORT6 (the
// fort/colony art), F7 Naval -> REPORT7 (the ship) -- "colony and naval reports are labeled
// backwards" (RULING note in the spec). Live rows come from /api/report/state.
const REPORTS_DEF=[
  {key:'F1', pik:'pik/REPORT1.png',  title:79,  body:repTerrain},
  {key:'F2', pik:'pik/REPORT2.png',  title:30,  body:repReligious},
  {key:'F3', pik:'pik/REPORT3.png',  title:37,  body:repCongressBody},
  {key:'F4', pik:'pik/REPORT4.png',  title:49,  body:repLabor},
  {key:'F5', pik:'pik/REPORT5.png',  title:50,  body:repEconomic},
  {key:'F6', pik:'pik/REPORT6.png',  title:51,  body:repColony},   // USER RULING: fort art
  {key:'F7', pik:'pik/REPORT7.png',  title:52,  body:repNaval},    // USER RULING: ship art
  {key:'F8', pik:'pik/REPORT8.png',  title:93,  body:repForeign},
  {key:'F9', pik:'pik/REPORT9.png',  title:29,  body:repIndian},
  {key:'F10',pik:'pik/WOODPAN2.png', title:114, body:repScore},
];
let RS=null, REPORT_IDX=-1, F8_VIEW=-1;
async function reportOpen(i){
  RS=await (await fetch('/api/report/state')).json();
  // F8 runs the nested "View Whose Report?" power picker first (the verbatim
  // DEBUG.TXT @SETREPORT dialog; dispatcher block @0x23810, SETVIEW @0x023D52).
  if(i===7 && !RS.woi_declared){
    let rec='';
    try{ const d=await (await fetch('/api/text?file=DEBUG')).json(); rec=d['@SETREPORT']||''; }catch(e){}
    if(rec){
      const parts=rec.split('\n').filter(Boolean);
      const body=parts[0]||'View Whose Report?', opts=parts.slice(1);
      wfShow({key:'@SETREPORT', body:body, choices:opts}, c=>{
        F8_VIEW=Math.max(0,opts.indexOf(c));
        nsIconsReady(()=>nsLabels('MISC',()=>{ REPORT_IDX=i; reportRender(); }));
      }, null);
      return;
    }
  }
  nsIconsReady(()=>nsLabels('MISC',()=>{ REPORT_IDX=i; reportRender(); }));
}
function reportRender(){
  const def=REPORTS_DEF[REPORT_IDX];
  const title=nsLbl('MISC',def.title,def.key);
  const inner=nsTitle(title)+def.body(RS)+nsOK('reportClose()',esc(nsLbl('MISC',46,'OK')));
  ui.popup(def.key+' &mdash; '+esc(title),
    '<div onclick="reportClose()" style="cursor:pointer">'+nsScreen(def.pik,inner)+'</div>');
}
function reportClose(){ REPORT_IDX=-1; ui.close(); }

// F1 Terrain (the encyclopedia): one row per base ground -- name left, the @UNFORESTED numbers
// right-justified toward x=0x136=310 (spec F1 geometry; the per-terrain icon id is not pinned to
// a verified ICONS frame, so rows are text-only).
function repTerrain(s){
  let h=nsT(25,14,'Terrain',{col:NS.label,bold:true})
       +nsT(130,14,'Move',{col:NS.label})+nsT(165,14,'Def%',{col:NS.label})
       +nsT(200,14,'Food',{col:NS.label})+nsT(230,14,'Value',{col:NS.label})
       +nsT(258,14,'Units',{col:NS.label})+nsT(288,14,'Cols',{col:NS.label});
  let y=25;                                     // body y-seed 0x19 (spec)
  (s.terrain||[]).forEach(t=>{
    h+=nsT(25,y,esc(t.name),{col:NS.value})
      +nsT(120,y,String(t.move),{w:30,right:true,col:NS.value})
      +nsT(155,y,String(t.defense),{w:30,right:true,col:NS.value})
      +nsT(190,y,String(t.food),{w:30,right:true,col:NS.value})
      +nsT(220,y,String(t.value),{w:30,right:true,col:NS.value})
      // this-nation counts, right-justified toward x=0x136=310 (func_3744A)
      +nsT(250,y,String(t.units),{w:30,right:true,col:NS.white})
      +nsT(280,y,String(t.colonies),{w:30,right:true,col:NS.white});
    y+=14;                                      // spec F1 row advance ~0x1E/2 glyph bands
  });
  return h;
}
// F2 Religious: the crosses gauge -- the shared proportional filled/empty strip. The spec ids
// 0x39 filled / 0x38 empty ARE the ICONS frames 57/56 (57 = the gold cross, 56 = the dull one --
// visually confirmed; the goods' png=EXE-1 shift does not apply to this band) + the byte-verified
// "(N of M)" text. The strip sprite COUNT is capped for the DOM; (N of M) is the exact conveyance.
function repReligious(s){
  const r=s.religious||{accum:0,threshold:1};
  let h=nsT(10,16,'Crosses: ('+r.accum+' of '+r.threshold+')',{col:NS.label});
  const max=Math.max(1,r.threshold), cap=Math.min(max,40);
  const filled=Math.round(Math.min(1,r.accum/max)*cap);
  h+='<div style="position:absolute;left:'+(10*NS_SC)+'px;top:'+(25*NS_SC)+'px">'
    +'</div>'+nsIconStripAt(57,56,filled,cap,10,25,300);
  // The waiting dock immigrants (func_37958's optional next-immigrant text; the
  // @0x11A9 template string is unextracted, so the raw @JOB names render alone).
  if((r.dock||[]).length)
    h+=nsT(10,52,esc(r.dock.join(', ')),{col:NS.white,size:6});
  let y=70;
  h+=nsT(4,y-10,'Colony crosses / turn:',{col:NS.label});
  (r.colonies||[]).forEach(c=>{ h+=nsT(10,y,'Colony '+c.colony,{col:NS.value})
                                 +nsT(120,y,String(c.crosses),{w:30,right:true,col:NS.value}); y+=NS_PITCH; });
  return h;
}
// helper: nsIconStrip placed at (x,y) native
function nsIconStripAt(f,e,v,n,x,y,span){ return nsIconStrip(f,e,v,n,x,y,span); }
// F3 Congress body over REPORT3.PIK: session subtitle, bell strip (bells filled = EXE 0x3F ->
// png 62 / empty png 55), sentiment TEXT (continental_congress.md: no bar), REF badge row
// (png 125 Regulars / 126 Cavalry / 9 Artillery / 127 Man-O-War), acquired-father names.
// The CCBKGD portrait crowd remains screen 2 of the Congress cycle (the sandbox flow).
function repCongressBody(s){
  const c=s.congress||{}; const byId=congressById();
  const offName=(c.offered>=0&&byId[c.offered])?byId[c.offered].name:'—';
  let h=nsT(4,14, c.ff_count>=25?'All 25 Founding Fathers have joined.'
      : esc(nsLbl('MISC',112,'Next Continental Congress Session'))+': '+esc(offName)
        +'  ('+(c.remaining||0)+' in '+(c.threshold||0)+')',{w:312});
  const sol=Math.max(0,Math.min(100,c.national_sol||0));
  h+=nsT(4,36,esc(nsLbl('MISC',69,'Rebel'))+' '+esc(nsLbl('MISC',71,'Sentiment'))+': '+sol+'%    '
           +esc(nsLbl('MISC',70,'Tory'))+' '+esc(nsLbl('MISC',71,'Sentiment'))+': '+(100-sol)+'%');
  // bell row (0,44,320,32): count = bells needed, filled = the pool (sprite count DOM-capped).
  // The spec's exact ids: bell filled 0x3F = frame 63, empty 0x38 = frame 56 (the atlas decode
  // of frame 63 is a plain red box -- it may have lost the bell art; ids kept as byte-cited).
  const need=Math.max(1,c.threshold||1), cap=Math.min(need,30);
  const filled=Math.round(Math.min(1,(c.bells_pool||0)/need)*cap);
  h+=nsIconStrip(63,56,filled,cap,10,46,300);
  // REF band (0,76,320,40): the 4-column count-badge row (spec 5 order incl. the swap)
  const ref=c.ref||{};
  h+=nsT(4,72,esc(nsLbl('MISC',85,'Expeditionary Force'))+':');
  h+=nsIconRow([{frame:125,count:ref.regulars||0,label:'Regulars'},
                {frame:126,count:ref.cavalry||0,label:'Cavalry'},
                {frame:9,  count:ref.artillery||0,label:'Artillery'},
                {frame:127,count:ref.manowar||0,label:'Man-O-War'}],10,82,300);
  // FF list band (0,116,320,60): plain text names
  const owned=(c.fathers||[]);
  h+=nsT(4,118,esc(nsLbl('MISC',89,'Founding Fathers'))+' ('+owned.length+'/25):');
  h+=nsT(4,128,owned.map(id=>esc((byId[id]||{}).name||('#'+id))).join(',  ')||'none yet',
        {w:312,wrap:true,size:5,col:NS.value});
  return h;
}
// F4 Labor: the occupation matrix -- job name x=2 color 0x92, count color 0x61, y=42 pitch 8,
// header separator rule x 2..311 color 0x77 (all spec-cited).
function repLabor(s){
  let h=nsT(2,30,'Occupation',{col:NS.label,bold:true})+nsT(200,30,'Colonists',{col:NS.label});
  h+=nsRule(2,311,40,NS.rule);
  let y=42;
  (s.labor||[]).forEach(r=>{ h+=nsT(2,y,esc(r.job),{col:NS.label})
                              +nsT(200,y,String(r.count),{w:40,right:true,col:NS.value}); y+=NS_PITCH; });
  if(!(s.labor||[]).length) h+=nsT(2,42,'No colonists.',{col:NS.value});
  return h;
}
// F5 Economic: goods rows with their real ICONS (frames 22..37), stock, and the PUBLISHED
// market bid/ask (@MISC 203/204 labels); rows stride 17 per the spec, two columns of 8.
function repEconomic(s){
  let h=nsT(140,25,esc(nsLbl('MISC',203,'Bid Price')),{col:NS.label})
       +nsT(210,25,esc(nsLbl('MISC',204,'Ask Price')),{col:NS.label})
       +nsT(270,25,'Stock',{col:NS.label});
  let y=34;
  (s.economic||[]).forEach((r,gd)=>{
    h+=nsIcon(22+gd,2,y-2,{scale:0.5,title:r.good});
    h+=nsT(22,y,esc(r.good)+(r.boycott?' (boycott)':''),{col:r.boycott?NS.rule:NS.label,size:5});
    h+=nsT(140,y,String(r.bid),{w:40,right:true,col:NS.value,size:5})
      +nsT(210,y,String(r.ask),{w:40,right:true,col:NS.value,size:5})
      +nsT(262,y,String(r.stock),{w:40,right:true,col:NS.value,size:5});
    y+=9;
  });
  return h;
}
// F6 Colony (REPORT6 per USER RULING): one row per colony, pitch 17, 9/page; the 4 caption
// columns sit at x=2/82/162/242 (spec) -- caption words are not spec-pinned (reconstructed).
function repColony(s){
  let h=nsT(2,27,'Colony',{col:NS.label})+nsT(82,27,esc(nsLbl('MISC',96,'Population')),{col:NS.label})
       +nsT(162,27,'Sons of Liberty',{col:NS.label})+nsT(242,27,'Buildings',{col:NS.label});
  let y=40;
  (s.colonies||[]).slice(0,9).forEach(c=>{
    h+=nsT(2,y,'Colony '+c.i+' ('+c.x+','+c.y+')',{col:NS.value})
      +nsT(82,y,String(c.population),{w:40,right:true,col:NS.value})
      +nsT(162,y,c.sol+'%',{w:40,right:true,col:NS.value})
      +nsT(242,y,String(c.buildings),{w:40,right:true,col:NS.value});
    y+=17;                                       // spec pitch 17, 9 per page
  });
  return h;
}
// F7 Naval (REPORT7 per USER RULING): the 4-column ship table y=42 pitch 20, 7/page --
// name x=26, location centered in a box at x=162 w=80, destination x=242 w=76 (spec).
function repNaval(s){
  // Headers = the verbatim @MISC 61..64 rows (Ship / Cargo / Location /
  // Destination); the cargo column renders one cell per hold -- a laden hold
  // shows its good's icon (EXE frames 0x17+good -> png 22+good), an empty hold
  // the 0x27 empty-hold frame (-> png 38) per @0x39574.
  let h=nsT(6,30,esc(nsLbl('MISC',61,'Ship')),{col:NS.label})
       +nsT(96,30,esc(nsLbl('MISC',62,'Cargo')),{w:90,center:true,col:NS.label})
       +nsT(192,30,esc(nsLbl('MISC',63,'Location')),{w:56,center:true,col:NS.label})
       +nsT(252,30,esc(nsLbl('MISC',64,'Destination')),{w:66,center:true,col:NS.label});
  let y=42;
  (s.naval||[]).slice(0,7).forEach(u=>{
    h+=nsT(6,y,esc(u.name),{col:NS.value});
    const cap=Math.min(u.cap||0,6), laden=u.cargo||[];
    for(let k=0;k<cap;k++){
      const fr=k<laden.length?22+laden[k]:38;    // good icon / empty hold
      h+=nsIcon(fr,96+k*15,y-3,{h:12});
    }
    h+=nsT(192,y,'('+u.x+','+u.y+')',{w:56,center:true,col:NS.value})
      +nsT(252,y,u.order==='GOTO'?('('+u.tx+','+u.ty+')'):esc(u.order),{w:66,center:true,col:NS.value});
    y+=20;                                       // spec pitch 20, 7 per page
  });
  if(!(s.naval||[]).length) h+=nsT(6,42,'No ships.',{col:NS.value});
  h+=nsRule(0,320,178,NS.rule);                  // footer rule only (spec)
  return h;
}
// F8 Foreign Affairs: the verbatim @MISC 95..100 strength rows down x=2 (color 0x91), one
// column per power at x=13/80/160/240; full-width separator rules color 0x77; War/Peace
// (@MISC 101/102) as the last row.
function repForeign(s){
  // Revolution gate (@0x39892 test [0x5382]&1): once independence is declared the
  // 4-power table is unavailable -- the verbatim @FOREIGNNOTAVAIL text shows instead.
  if(s.woi_declared){
    let h='';
    (s.foreign_notavail||'Foreign affairs reports are not available during the War of Independence.')
      .split('\n').forEach((ln,i)=>{ h+=nsT(10,30+i*(NS_PITCH+2),esc(ln),{col:NS.value,size:5}); });
    return h;
  }
  const rows=[['colonies',95],['population',96],['avg_colony',97],['military',98],['naval',99],['merchant',100]];
  const colx=[13,80,160,240];
  let h=''; const fp=s.foreign||[];
  const vw=(typeof F8_VIEW==='number')?F8_VIEW:-1;   // the @SETREPORT picked power
  fp.forEach((p,i)=>{ h+=nsT(colx[i]+10,25,esc(p.name)+(p.seceded?' *':''),
    {col:i===vw?NS.white:NS.label,bold:true}); });
  h+=nsRule(0,320,34,NS.rule);
  let y=40;
  rows.forEach(rw=>{
    h+=nsT(2,y,esc(nsLbl('MISC',rw[1],rw[0])),{col:NS.strength,size:5});
    fp.forEach((p,i)=>{ h+=nsT(colx[i]+30,y,String(p[rw[0]]),{w:34,right:true,col:NS.value,size:5}); });
    y+=NS_PITCH+2;
  });
  h+=nsRule(0,320,y,NS.rule); y+=6;
  h+=nsT(2,y,'Status',{col:NS.strength,size:5});
  fp.forEach((p,i)=>{ h+=nsT(colx[i]+30,y,i===0?'—':esc(nsLbl('MISC',p.at_war?101:102,p.at_war?'War':'Peace')),
                            {w:34,right:true,col:p.at_war?NS.rule:NS.value,size:5}); });
  return h;
}
// F9 Indian: tribe rows (x=16 name / +72 position / +20 stats per the spec offsets); text in
// the @COLORS slots (green cells, gold title already in the chrome).
function repIndian(s){
  // The dispatcher gates the body pre-contact (@0x0238D1: [DS:0x5383] bit 0x20,
  // natives discovered -- no body draws until then).
  if(s.natives_discovered===false) return '';
  let h=nsT(16,27,'Tribe',{col:NS.gold})+nsT(120,27,'Village',{col:NS.gold})
       +nsT(200,27,'Size',{col:NS.gold})+nsT(240,27,'Alarm',{col:NS.gold})+nsT(280,27,'Mission',{col:NS.gold});
  let y=40;
  (s.indian||[]).forEach(t=>{
    h+=nsT(16,y,esc(t.tribe)+(t.capital?' (capital)':''),{col:NS.green})
      +nsT(120,y,'('+t.x+','+t.y+')',{col:NS.green})
      +nsT(200,y,String(t.population),{w:30,right:true,col:NS.green})
      +nsT(240,y,String(t.alarm),{w:30,right:true,col:t.alarm>=128?NS.rule:NS.green})
      +nsT(280,y,t.mission>=0?'✝':'-',{w:30,center:true,col:NS.green});
    y+=NS_PITCH+2;
  });
  if(!(s.indian||[]).length) h+=nsT(16,40,'No known villages.',{col:NS.green});
  return h;
}
// F10 Score: WOODPAN2 with the verbatim @MISC scoring lines (115 Citizens / 116 Independence
// + 118 Declared / 117 Villages Burned / 120 Foreign Recognition / 121 Total Score) and the
// live component breakdown; figures larger (the F10 body is FONTTINY labels + FONTINTR figures).
function repScore(s){
  const sc=s.score||{};
  // The rating band plate over WOODPAN2 (func_03A9C0 @0x3AAAA: filename = "SCORE"
  // + ("0" if panel<9) + (panel+1), panel = the Hall-of-Fame rank from the i*i/3
  // selector = sc.rank). Frame content = atlas (0,16) 101x66; the on-screen x/y
  // of the plate is not byte-pinned -- top-centered (RECONSTRUCTED).
  const nn=String(Math.min(Math.max(sc.rank||0,0),23)+1).padStart(2,'0');
  let h=nsSheet('SCORE'+nn,0,16,100,66,110,10);
  const line=(y,idx,fb,val)=>nsT(20,y,esc(nsLbl('MISC',idx,fb)),{col:NS.label})
                            +nsT(220,y,String(val),{w:60,right:true,col:NS.white,size:8});
  let y=82;
  h+=line(y,115,'Citizens',sc.population); y+=12;
  h+=nsT(20,y,esc(nsLbl('MISC',89,'Founding Fathers')),{col:NS.label})
    +nsT(220,y,String(sc.fathers),{w:60,right:true,col:NS.white,size:8}); y+=12;
  h+=nsT(20,y,esc(nsLbl('MISC',71,'Sentiment')),{col:NS.label})
    +nsT(220,y,String(sc.sentiment),{w:60,right:true,col:NS.white,size:8}); y+=12;
  h+=line(y,117,'Villages Burned',sc.razed); y+=12;
  h+=nsT(20,y,'Gold / 1000',{col:NS.label})
    +nsT(220,y,String(sc.gold),{w:60,right:true,col:NS.white,size:8}); y+=12;
  h+=line(y,113,'Intervention',sc.war_bells); y+=12;
  h+=line(y,116,'Independence',sc.revolution); y+=14;
  h+=nsRule(20,300,y,NS.gold); y+=6;
  h+=line(y,121,'Total Score',sc.total); y+=14;
  h+=nsT(20,y,'Rank',{col:NS.label})+nsT(220,y,String(sc.rank),{w:60,right:true,col:NS.gold,size:8});
  return h;
}
// The Play tab's report button bar (one per F-report, labeled with the verbatim titles once loaded).
(function(){ const bar=document.getElementById('reportbar'); if(!bar) return;
  REPORTS_DEF.forEach((d,i)=>{ const b=document.createElement('button'); b.className='act';
    b.textContent=d.key; b.title=d.key+' report'; b.onclick=()=>reportOpen(i); bar.appendChild(b); });
  nsLabels('MISC',L=>REPORTS_DEF.forEach((d,i)=>{ bar.children[i+1].title=L[d.title]||d.key; }));
})();
// The F1-F10 keys open the advisor reports from the Play or Sandbox tab (the game's report keys).
window.addEventListener('keydown',e=>{
  const t=document.activeElement&&document.activeElement.tagName;
  if(t==='INPUT'||t==='TEXTAREA'||t==='SELECT') return;
  const m=/^F(\d+)$/.exec(e.key); if(!m) return;
  const n=+m[1]; if(n<1||n>10) return;
  const tab=document.querySelector('nav button.active');
  if(!tab||(tab.dataset.tab!=='play'&&tab.dataset.tab!=='sandbox')) return;
  e.preventDefault();
  if(REPORT_IDX===n-1) reportClose(); else reportOpen(n-1);
});
document.querySelector('nav button[data-tab=sandbox]').addEventListener('click',()=>{ sbInit(); });

// ==== Native colony screen (spec/ui/colony_screen.md -- composer func_028592, 12 panels) ====
// Layout anchored to the byte-cited rects (spec 0.2/3.x/4) + the live capture
// docs/screens/colony_live_1505.png: terrain scene + buildings on top, the COLONY.PIK
// 320x72 street strip at the bottom, the panel band (plaza SoL / port / cargo / flag)
// composited over the strip at y=130, the 16-cell stockpile bar at (0,179,320,21).
const COL_PLOTS=[            // 15 plots: x, y (drawn at y+8), category -- DS:0x266 + 0x8D62
  [56,13,0],[145,15,0],[173,18,0],[8,41,0],[37,45,0],[67,54,0],[96,53,0],
  [6,14,1],[128,53,1],[10,76,1],[15,102,1],[87,11,2],[66,87,2],[123,106,3],[123,55,4]];
const COL_CAT_START=[0,7,11,13,14], COL_CAT_COUNT=[7,4,2,1,1];  // 0x22A starts / 0x224 counts
const COL_EMPTY_FRAME=[44,43,42,-1,45];  // empty plot = BUILDING DS:0x260[cat]-1; cat 3 draws none
// Building def -> plot category. The EXE builds this map at runtime (func_025D34 step 4) and
// the table is not in NAMES.TXT, so it is RECONSTRUCTED from the RAM-verified Jamestown
// sample (spec 0.2): production "...House" -> 0; Stockade/Fort/Fortress -> 3 (the fort plot);
// Docks/Drydock/Shipyard -> 4 (waterfront); Town Hall + Church/Cathedral -> 2; the rest -> 1.
function colCategory(id,name){
  if(id<=2) return 3;
  if(id>=6&&id<=8) return 4;
  if(/house/i.test(name)) return 0;
  if(id===9||/church|cathedral/i.test(name)) return 2;
  return 1;
}
// Within-category placement shuffle (func_025D34 step 3: plot = random(count[cat])+start[cat],
// retry while occupied, seeded per colony) -- seeded from the colony index so it is stable.
function colPlace(built){
  let seed=((COL.index+1)*2654435761)>>>0;
  const rnd=n=>{ seed=(seed*1103515245+12345)>>>0; return (seed>>>16)%n; };
  const plot=new Array(15).fill(null);      // plot -> building record, null = empty (0xFF)
  for(const b of built){
    const cat=colCategory(b.id,b.name||''), s=COL_CAT_START[cat], n=COL_CAT_COUNT[cat];
    let p=-1;
    for(let t=0;t<n*4&&p<0;t++){ const q=s+rnd(n); if(!plot[q])p=q; }
    if(p<0) for(let i=s;i<s+n;i++) if(!plot[i]){p=i;break;}
    if(p>=0) plot[p]=b;
  }
  return plot;
}
let COL=null;
let COL_CI=-1;
async function colOpen(ci){
  COL_CI=ci;
  COL=await (await fetch('/api/colony/screen?colony='+ci)).json();
  if(COL.error){ ui.toast(COL.error); COL=null; return; }
  nsIconsReady(()=>nsLabels('MISC',()=>nsLabels('CMISC',()=>nsLabels('CTITLE',()=>colRender()))));
}
function colClose(){ COL=null; ui.close(); }
function colFill(x,y,w,h,col){
  return '<div style="position:absolute;left:'+(x*NS_SC)+'px;top:'+(y*NS_SC)+'px;width:'+(w*NS_SC)
    +'px;height:'+(h*NS_SC)+'px;background:'+(col||'#181c7d')+'"></div>';
}
// one BUILDING.SS cell (56x48 grid sheet) at native (x,y); onclickJs optional
function colBld(frame,x,y,title,onclickJs){
  const sh=SHEETS.BUILDING;
  return '<div title="'+esc(title||('BUILDING '+frame))+'"'
    +(onclickJs?' onclick="event.stopPropagation();'+onclickJs+'" ':'')
    +' style="position:absolute;left:'+(x*NS_SC)+'px;top:'+(y*NS_SC)+'px;'
    +'width:'+(sh.cw*NS_SC)+'px;height:'+(sh.ch*NS_SC)+'px;'
    +(onclickJs?'cursor:pointer;':'')
    +'background:url('+sh.url+') no-repeat;'
    +'background-size:'+(sh.n*sh.cw*NS_SC)+'px '+(sh.ch*NS_SC)+'px;'
    +'background-position:-'+(frame*sh.cw*NS_SC)+'px 0;image-rendering:pixelated"></div>';
}
// one UNITS-sheet sprite (32x32) at native (x,y) -- the ships-in-port slots
function colShip(type,x,y,title){
  const sh=SHEETS.UNITS;
  return '<div title="'+esc(title||'')+'" style="position:absolute;left:'+(x*NS_SC)+'px;top:'+(y*NS_SC)
    +'px;width:'+(32*NS_SC)+'px;height:'+(32*NS_SC)+'px;background:url('+sh.url+') no-repeat;'
    +'background-size:'+(sh.n*32*NS_SC)+'px '+(32*NS_SC)+'px;'
    +'background-position:-'+(type*32*NS_SC)+'px 0;image-rendering:pixelated"></div>';
}
function colRender(){
  const c=COL, GI=g=>22+g;   // ICONS 22..37 = Food..Muskets (Food FIRST -- spec 0.3/0.6)
  let h='';
  // Steps 3+4: the terrain scene around the colony tile (16-px pitch, func_026374),
  // drawn onto a canvas after insert; the buildings + title paint over it.
  h+='<canvas id="colscene" width="320" height="128" style="position:absolute;left:0;top:0;'
    +'width:'+(320*NS_SC)+'px;height:'+(128*NS_SC)+'px;image-rendering:pixelated"></canvas>';
  // COLONY.PIK = a 320x72 street-scene STRIP (build-verified, spec 5), at the screen bottom
  // under the panel band per the live capture.
  h+='<img src="/assets/pik/COLONY.png" style="position:absolute;left:0;top:'+(128*NS_SC)+'px;'
    +'width:'+(320*NS_SC)+'px;height:'+(72*NS_SC)+'px;image-rendering:pixelated">';
  // Step 12: the 15 building plots (spec 0.2). Occupied = bundle frame def_id (def_id 0 ->
  // frame 16, the byte-read special case); empty = DS:0x260[category]-1 decoration.
  const plots=colPlace(c.built||[]);
  COL_PLOTS.forEach((p,i)=>{
    const b=plots[i];
    if(b&&b.id>=0) h+=colBld(b.id===0?16:b.id, p[0], p[1]+8, b.name);
    else if(COL_EMPTY_FRAME[p[2]]>=0)
      h+=colBld(COL_EMPTY_FRAME[p[2]], p[0], p[1]+8, 'empty plot (build here)', 'colBuildMenu()');
  });
  // Working colonist + hammer strip on the hammer-producing plot (spec 0.4: colonist ICONS 81
  // at plot+27,+9; production icons ICONS 54 at plot x pitch 6, y+1; count = live per-turn state).
  const carp=(c.built||[]).find(b=>/carpenter/i.test(b.name||''));
  if(carp&&(c.production||{}).hammers>0){
    const pi=plots.findIndex(b=>b===carp);
    if(pi>=0){ const p=COL_PLOTS[pi];
      h+=nsIcon(81,p[0]+27,p[1]+9,{title:'working colonist'});
      const n=Math.min(c.production.hammers,5);   // atlas hammer cell is 24x30 -> ~6px glyph
      for(let i=0;i<n;i++) h+=nsIcon(54,p[0]+i*6,p[1]+1,{scale:0.25,title:'hammer production'});
    }
  }
  // Step 5: title -- "Name.  Season, Year.  Gold: N" (spec 3.1, all fields oracle-confirmed;
  // green FONTTINY per the capture; "Gold:" is the verbatim @CTITLE line).
  h+=nsT(0,1,esc(c.name)+'.  '+esc(c.season_name)+', '+c.year+'.  '
        +esc(nsLbl('CTITLE',1,'Gold:'))+' '+c.gold,
        {col:NS.green,w:320,center:true,bold:true});
  // Step 6: field-production panel (224,32,72,72) -- the 3x3 surrounding-tile work view
  // (canvas) + the center tile's auto-yield and each field worker's good icon (spec 3.2).
  h+=nsT(224,25,esc(nsLbl('CMISC',0,'Harvest / Resources')),{size:5,col:NS.label,w:96});
  h+='<canvas id="colfield" width="72" height="72" style="position:absolute;'
    +'left:'+(224*NS_SC)+'px;top:'+(32*NS_SC)+'px;width:'+(72*NS_SC)+'px;height:'+(72*NS_SC)
    +'px;image-rendering:pixelated;outline:1px solid #000"></canvas>';
  const GPOS=[[0,0],[1,0],[2,0],[0,1],[2,1],[0,2],[1,2],[2,2]];   // ring tile -> 3x3 cell
  if(c.center){
    h+=nsIcon(GI(0),224+24+2,32+24+1,{scale:0.55,title:'center food'})
      +nsT(224+24+13,32+24+13,String(c.center.food),{size:5,col:NS.white});
    if(c.center.good>0&&c.center.count>0)
      h+=nsIcon(GI(c.center.good),224+24+2,32+24+11,{scale:0.55,title:'center good'});
  }
  (c.colonists||[]).forEach(w=>{
    if(w.tile>=0&&w.tile<8){ const gp=GPOS[w.tile];
      h+=nsIcon(GI(w.good),224+gp[0]*24+2,32+gp[1]*24+1,
                {scale:0.55,title:esc(w.name)+(w.expert?' (expert)':'')});
    }
  });
  // Step 7 + capture: the panel band over the strip. The dark fill spans the band row;
  // the SoL line "N% (M)" is white at (75,133) (spec 0.5, digits not letters).
  h+=colFill(0,130,302,17);
  h+='<div title="'+esc(nsLbl('MISC',209,'Sons of Liberty'))+'">'
    +nsT(75,133,c.sol+'% ('+c.sol_members+')',{col:NS.white})+'</div>';
  // Plaza colonist row (func_0270D0): x-origin 143 walking LEFT at y=+10 over the street
  // strip; inter-colonist gap starts 2 and shrinks until the row fits the 96-px budget.
  {
    const n=Math.max(0,c.population|0), fw=(NS_ICONS&&NS_ICONS.frames[81])?NS_ICONS.frames[81].w:12;
    let gap=2; while(n>1&&gap>0&&gap*(n-1)+4+fw*n>=96) gap--;
    let x=143;
    for(let i=0;i<n&&x-fw>0;i++){ x-=fw; h+=nsIcon(81,x,138,{title:'colonist'}); x-=gap; }
  }
  // Step 10: the port panel (121,130,84,48): ships in port, or the shared empty-panel
  // caption -- verbatim @MISC[11] "No Ships In Port" (oracle-confirmed string, spec 3.5).
  const ships=c.ships||[];
  if(ships.length===0)
    h+=nsT(121,132,esc(nsLbl('MISC',11,'No Ships In Port')),{w:84,center:true,col:NS.white});
  else ships.slice(0,6).forEach((s,i)=>{ h+=colShip(s.type,125+i*12,140,s.name); });
  // Step 11: the SoL/cargo/msg panel (211,130,91,48), cargo+build mode (func_027BB6):
  // build-project caption + the 0x236 hammer strip (ICONS 54) + shortage marks --
  // Lumber(27)/Hammers(54) each under a red X (ICONS 55) when production is stalled.
  const b=c.build||{};
  if(b.target>=0&&b.name){
    h+=nsT(213,132,esc(b.name)+' ('+b.bank+'/'+b.cost+')',{size:5,col:NS.white,w:88});
    const filled=Math.max(0,Math.min(10,Math.round((b.bank/(b.cost||1))*10)));
    for(let i=0;i<filled;i++) h+=nsIcon(54,213+i*6,148,{scale:0.3,title:'build progress'});
    if((c.production||{}).hammers===0){
      h+=nsIcon(27,254,160,{scale:0.4,title:'Lumber shortage'})+nsIcon(55,254,158,{scale:0.4,title:'shortage'})
        +nsIcon(54,272,158,{scale:0.4,title:'Hammer shortage'})+nsIcon(55,272,158,{scale:0.4,title:'shortage'});
    }
  } else {
    h+='<div onclick="event.stopPropagation();colBuildMenu()" style="cursor:pointer">'
      +nsT(213,132,esc(nsLbl('CTITLE',4,'Select An Item To Build')),{size:5,col:NS.label,w:88,wrap:true})
      +'</div>';
  }
  // Step 9: flag panel (303,132,17,45). The EXE draws ICONS sprite 0x44 with frame = the
  // nation byte [0x337]; the packed strip's only verified flag art is frame 123 (identity
  // "(unverified)" in the catalog) -- drawn here, not invented as per-nation art.
  h+=nsIcon(123,306,135,{title:'flag (ICONS sprite 0x44, frame = nation -- atlas identity unverified)'});
  // Step 8: stockpile bar (0,179,320,21), 16 cells pitch 19 (0x13), icons at y=181,
  // Food FIRST; qty white 0x0F, RED 0x0C when over the warehouse cap (all byte-cited).
  h+=colFill(0,179,320,21);
  const cap=c.warehouse_cap||100;
  // USER RULING (2026-07-02): with a Custom House, clicking a stockpile cell
  // toggles that good's auto-sell selection; selected goods sell over 50 each
  // turn. Selected cells show a gold marker + gold qty.
  (c.stockpile||[]).forEach((s,g)=>{
    const sel=c.custom_house&&g>0&&((c.export_mask>>g)&1);
    const click=c.custom_house&&g>0
      ?'<div onclick="event.stopPropagation();colExport('+g+')" style="cursor:pointer" '
        +'title="'+esc(s.good)+(sel?' -- auto-selling over 50 (click to stop)':' -- click to auto-sell over 50')+'">'
      :'<div>';
    h+=click+nsIcon(GI(g),g*19+3,181,{scale:0.5,title:s.good})
      +(sel?nsT(g*19+1,180,'&#9679;',{size:4,col:NS.gold}):'')
      +nsT(g*19,194,String(s.qty),{w:19,center:true,size:5,
           col:(s.qty>cap?'#e04040':(sel?NS.gold:NS.white))})
      +'</div>';
  });
  // The build tool button (the blue anvil in the capture's bottom-right corner).
  h+='<div onclick="event.stopPropagation();colBuildMenu()" style="cursor:pointer" title="Build">'
    +nsIcon(69,306,181,{title:'Build'})+'</div>';
  const stage='<div style="position:relative;width:'+(320*NS_SC)+'px;height:'+(200*NS_SC)+'px;'
    +'background:#101014;image-rendering:pixelated;font-family:monospace;overflow:hidden;'
    +'user-select:none">'+h+'</div>';
  ui.popup(esc(c.name)+' &mdash; colony', stage);
  setTimeout(colDrawCanvases,0);
}
// The two live canvases: the 16-px scene window centered on the colony tile, and the
// 3x3 24-px surrounding-tile field view (center row 1 col 1; ring order NW..SE).
function colDrawCanvases(){
  const c=COL; if(!c) return;
  const sc=document.getElementById('colscene');
  if(sc&&typeof GAME!=='undefined'&&GAME&&GAME.terrain){
    const W=20,H=8,t=[];
    for(let y=0;y<H;y++) for(let x=0;x<W;x++){
      const mx=c.x-10+x, my=c.y-4+y;
      t.push((mx<0||my<0||mx>=GAME.w||my>=GAME.h)?25:GAME.terrain[my*GAME.w+mx]);
    }
    composeMap(sc.getContext('2d'),t,W,H,16,true);
  }
  const fc=document.getElementById('colfield');
  if(fc&&c.ring&&TILES_READY){
    const g=fc.getContext('2d'); g.imageSmoothingEnabled=false;
    const draw=(tid,cx,cy)=>g.drawImage(TILESET,baseFrame(tid&0x1F)*16,0,16,16,cx*24,cy*24,24,24);
    const GPOS=[[0,0],[1,0],[2,0],[0,1],[2,1],[0,2],[1,2],[2,2]];
    c.ring.forEach((tid,i)=>draw(tid,GPOS[i][0],GPOS[i][1]));
    draw((c.center||{}).terrain||0,1,1);
  }
}
// "Select An Item To Build": the eligible @BUILDING rows (name, cost, min_colony gate)
// -> POST /api/colony/build, then re-open the screen with the new project.
// Toggle a good's Custom-House auto-sell selection (USER RULING 2026-07-02).
async function colExport(g){
  try{ const r=await (await fetch('/api/colony/export',{method:'POST',
      body:JSON.stringify({colony:COL_CI,good:g})})).json();
    if(r.error){ ui.toast(r.error); return; }
    ui.toast((r.selected?'Auto-selling over 50: ':'Auto-sell stopped: ')+'good '+g);
    colOpen(COL_CI);
  }catch(e){ ui.toast('failed'); }
}
async function colBuildMenu(){
  const ci=COL?COL.index:0;
  // the byte-verified func_0B900 gate (size/prereq/supersede/FF) runs server-side
  let mr; try{ mr=await (await fetch('/api/colony/buildmenu?colony='+ci)).json(); }
  catch(e){ ui.toast('build menu unavailable'); return; }
  const elig=(mr.buildable||[]).map(e=>({i:e.id,name:e.name,cost:+e.cost,min:+e.min_colony}))
    .sort((a,b)=>a.cost-b.cost);
  let body='<h3 style="margin:0 0 6px">'+esc(nsLbl('CTITLE',4,'Select An Item To Build'))+'</h3>';
  if(!elig.length) body+='<div class="muted">Nothing new to build here.</div>';
  body+='<div style="max-height:340px;overflow:auto">'+elig.map(e=>
    '<div style="display:flex;justify-content:space-between;gap:10px;padding:2px 0">'
    +'<span>'+esc(e.name)+' <span class="muted">('+e.cost+'h, pop&ge;'+e.min+')</span></span>'
    +'<button class="act" onclick="colBuild('+e.i+')">Build</button></div>').join('')+'</div>';
  ui.popup('Construction &mdash; '+esc(COL?COL.name:''), body);
}
async function colBuild(bid){
  const ci=COL?COL.index:0;
  try{ const r=await (await fetch('/api/colony/build',{method:'POST',
      body:JSON.stringify({colony:ci,building:bid})})).json();
    ui.toast(r.msg||'started'); }catch(e){ ui.toast('build failed'); }
  colOpen(ci);
}

// ==== Native Europe screen (spec/ui/europe_screen.md) -- rendered from the EXTRACTED layout ====
// The geometry comes from /api/layout?screen=europe_screen: tools/extract_layouts.py lifts the
// spec's byte-cited element table into data, so NO coordinate here is hand-transcribed -- a spec
// correction re-extracts straight into this screen. Prices are the live 1.3 market model.
let EU=null, EULAY=null;
async function euOpen(){
  EU=await (await fetch('/api/europe')).json();
  if(!EULAY) EULAY=await (await fetch('/api/layout?screen=europe_screen')).json();
  nsIconsReady(()=>nsLabels('MISC',()=>nsLabels('EUROLABEL',()=>euRender())));
}
// look an element's byte-cited rect up by (partial) name in the extracted layout
function euRect(sub,fb){
  const e=(EULAY&&EULAY.elements||[]).find(e=>e.rect&&e.name.toLowerCase().indexOf(sub)>=0);
  return e?e.rect:fb;
}
function euRender(){
  const GI=g=>22+g;
  let h='';
  // market bar: extracted rect (0,179,320,21); icons stride 19, prices y=194 (spec rows)
  const mb=euRect('market bar fill',[0,179,320,21]);
  h+=colFill(mb[0],mb[1],mb[2],mb[3]);
  (EU.prices||[]).forEach((p,g)=>{
    const x=mb[0]+1+g*19;
    h+='<div onclick="event.stopPropagation();euTrade('+g+')" style="cursor:pointer" title="'
      +esc(p.good)+' — bid '+p.bid+' / ask '+p.ask+' (click to trade)">'
      +nsIcon(GI(g),x+2,mb[1]+2,{scale:0.5})+'</div>';
    h+=nsT(x-2,194,p.bid+'/'+p.ask,{w:19,center:true,size:4,col:p.boycott?'#e04040':NS.white});
    if(p.boycott) h+=nsIcon(55,x+2,mb[1]+1,{scale:0.4,title:'boycotted after the Tax Party'});
  });
  // dock (extracted rect) + the 3-slot immigrant pool on the quay
  const dk=euRect('dock fill',[143,118,81,60]);
  h+=colFill(dk[0],dk[1],dk[2],dk[3],'#181c7d88');
  (EU.dock||[]).forEach((t,i)=>{
    if(t<0) return;                                 // empty dock slot
    h+='<div onclick="event.stopPropagation();euRecruitSlot('+i+')" style="cursor:pointer" '
      +'title="waiting immigrant — click to bring ashore">'
      +nsIcon(81,147+i*12,165,{})+'</div>';         // slots x=147+slot*12, y=165 (spec row)
  });
  // caption box (extracted rect): verbatim @MISC[10] "Bound For"
  const cb=euRect('caption box',[143,81,120,69]);
  h+=nsT(cb[0],cb[1]+28,esc(nsLbl('MISC',10,'Bound For')),{w:cb[2],center:true,col:NS.white});
  // recruit panel (extracted rect (281,89,37,32)): the three verbatim @EUROLABEL rows
  const rp=euRect('recruit',[281,89,37,32]);
  h+=colFill(rp[0],rp[1],rp[2],rp[3],'#000000aa');
  ['RECRUIT','PURCHASE','TRAIN'].forEach((fb,r)=>{
    h+='<div onclick="event.stopPropagation();euAction('+r+')" style="cursor:pointer">'
      +nsT(rp[0],rp[1]+3+r*9,esc(nsLbl('EUROLABEL',r,fb)),{w:rp[2],center:true,size:4,col:NS.white})
      +'</div>';
  });
  // warehouse-bar right readout: verbatim @MISC[209] "Sons of Liberty" (spec x=306,y=179)
  h+=nsT(230,171,esc(nsLbl('MISC',209,'Sons of Liberty')),{size:5,col:NS.white,w:88,right:true});
  // header band: gold + tax (the "Selling ..." banner is runtime-formatted per spec)
  h+=nsT(0,1,esc(nsLbl('CTITLE',1,'Gold:'))+' '+EU.gold+'   '
        +esc(nsLbl('CTITLE',9,'Tax:'))+' '+EU.tax+'%',{col:NS.green,w:320,center:true,bold:true});
  ui.popup('Europe &mdash; the Royal port',
    '<div>'+nsScreen('pik/EUROPE.png',h+nsOK('ui.close()',esc(nsLbl('MISC',46,'OK'))))+'</div>');
}
async function euTrade(g){
  const p=(EU.prices||[])[g]||{};
  ui.popup('Trade &mdash; '+esc(p.good||('good '+g)),
    '<p>bid <b>'+p.bid+'</b> / ask <b>'+p.ask+'</b> &middot; hidden supply '+p.supply
    +' &middot; this turn\'s volume '+p.trade+'</p>'
    +'<div class="row">'
    +'<button class="act" onclick="euDo(\'sell\','+g+')">Sell 10 (from colony 0)</button>'
    +'<button class="act" onclick="euDo(\'buy\','+g+')">Buy 10 (to colony 0)</button></div>');
}
async function euDo(op,g){
  try{ const r=await (await fetch('/api/europe/'+op,{method:'POST',
      body:JSON.stringify({colony:0,good:g,qty:10})})).json();
    if(r.boycotted){
      // The back-tax pay-or-abort dialog (@KISSUP verbatim, boycotts.md): the
      // record's two option lines are the abort / pay choices.
      const parts=(r.msg||'').split('\n\n');
      const opts=(parts[1]||'Unfair!\nPay.').split('\n');
      wfShow({key:'@KISSUP', body:parts[0]||'', choices:opts}, async c=>{
        if(opts.indexOf(c)===1){
          const d=await (await fetch('/api/europe/liftboycott',{method:'POST',
              body:JSON.stringify({good:g})})).json();
          ui.toast(d.error||('Boycott lifted for '+d.paid+' gold in back taxes'));
        }
        euOpen();
      }, null);
      return;
    }
    ui.toast(r.msg||r.error||op+' done'); }catch(e){ ui.toast(op+' failed'); }
  euOpen();
}
async function euRecruitSlot(i){
  try{ const r=await (await fetch('/api/europe/recruit',{method:'POST',
      body:JSON.stringify({slot:i,colony:0})})).json();
    ui.toast(r.error||'immigrant ashore'); }catch(e){ ui.toast('recruit failed'); }
  euOpen(); if(typeof GAME!=='undefined'&&GAME) refreshGame();
}
function euAction(r){
  if(r===0){ const i=(EU.dock||[]).findIndex(t=>t>=0);
    if(i<0) ui.toast('no immigrant waiting'); else euRecruitSlot(i); }
  else if(r===1) euPurchase();
  else ui.toast('TRAIN: pick a profession via /api/europe/train (see the Tables tab @JOB europe_value)');
}
// PURCHASE (artillery): cost = base + bought*100 (the +0x1E escalation counter,
// @0x035124/@0x035282; base = the cfg.artillery_base_cost knob).
async function euPurchase(){
  try{
    const r=await (await fetch('/api/europe/purchase',{method:'POST',body:JSON.stringify({colony:0})})).json();
    if(r.error){ ui.toast(r.error); return; }
    ui.toast('Artillery purchased for '+r.purchase_cost+' gold (next: '+r.next_cost+')');
  }catch(e){ ui.toast('purchase failed'); }
  euOpen(); if(typeof GAME!=='undefined'&&GAME) refreshGame();
}

// ==== Native map HUD (spec/ui/map_view.md) -- the game's MAIN screen, from the EXTRACTED layout ====
// Geometry from /api/layout?screen=map_view: the byte-verified region rects (viewport (0,8,240,192),
// minimap (241,8,79,41), sidebar B/C) AND the pixel-measured sidebar line table (tier R, cited) --
// nothing hand-transcribed. Menu titles = the verbatim MENU.TXT sections; sidebar strings = the
// verbatim @INFO/@MISC/@SEASONS/@UNIT lines; minimap dot colors = NAMES @COLORS palette indices.
let NV=false, NVX=0, NVY=0, NVZ=0, NVH=false, NVLAY=null, NVMENU=null, NVPAL=null;
// VIEW zoom state [0x184] 0..3 (map_view.md 6.2, render_frame_setup @0x6787C):
// SPAN_W[0x8544]=0xF<<zoom, SPAN_H[0x8546]=0xC<<zoom, TILE_PX[0x5AD4]=0x10>>zoom
// -> 15x12@16px / 30x24@8px / 60x48@4px / 120x96@2px (the four @VIEW rows).
function nvSpan(){ return {W:15<<NVZ, H:12<<NVZ, px:16>>NVZ}; }
function nvRefresh(){                                  // redraw in place, or re-open the HUD if a
  if(document.getElementById('nvview')) nvDraw();      // menu popup replaced it (nvMenu path)
  else nvRender();
}
function nvZoom(z){                                    // clamp + keep the view center fixed
  z=Math.max(0,Math.min(3,z)); if(z===NVZ){ nvRefresh(); return; }
  const o=nvSpan(); const cx=NVX+(o.W>>1), cy=NVY+(o.H>>1);
  NVZ=z; const n=nvSpan();
  NVX=Math.max(0,Math.min(GAME.w-n.W,cx-(n.W>>1))); NVY=Math.max(0,Math.min(GAME.h-n.H,cy-(n.H>>1)));
  nvRefresh();
}
function nvCenter(){                                   // ~Center View (accel C): on the active unit
  const u=selUnit(); if(!u){ nvRefresh(); return; }
  const s=nvSpan();
  NVX=Math.max(0,Math.min(GAME.w-s.W,u.x-(s.W>>1))); NVY=Math.max(0,Math.min(GAME.h-s.H,u.y-(s.H>>1)));
  nvRefresh();
}
// @ORDERS accelerators (input.md map-command table; verbatim MENU.TXT rows).
async function nvOrder(o){                             // F/S/P/R standing orders, '-' activate, 'D' disband
  const u=selUnit(); if(!u){ ui.toast('No active unit'); return; }
  const r=await fetch('/api/game/order',{method:'POST',body:JSON.stringify({unit:SEL,order:o})});
  const d=await r.json(); if(d.error){ ui.toast(d.error); return; }
  GAME=d; if(o==='D') SEL=-1;
  nvRefresh();
}
async function nvBuild(){                              // ~Build Colony / Join Colony (~B)
  const u=selUnit(); if(!u){ ui.toast('No active unit'); return; }
  const r=await fetch('/api/game/found',{method:'POST',body:JSON.stringify({unit:SEL})});
  const d=await r.json(); if(d.error){ ui.toast(d.error); return; }
  GAME=d; SEL=-1; nvRefresh();
}
function nvNext(){                                     // ~Wait for next unit / No Orders (space)
  const alive=(GAME.units||[]).filter(u=>u.owner===0&&u.alive!==false);
  const ready=alive.filter(u=>u.moves>0);              // moves refresh inside the turn step, so
  const pool=ready.length?ready:alive;                 // at turn 0 every unit still cycles
  if(!pool.length){ SEL=-1; nvRefresh(); return; }
  const i=pool.findIndex(u=>u.id===SEL);
  SEL=pool[(i+1)%pool.length].id;
  nvCenter();
}
async function nvOpen(){
  if(!GAME||!GAME.w) await refreshGame();
  if(!NVLAY) NVLAY=await (await fetch('/api/layout?screen=map_view')).json();
  if(!NVMENU){ try{ NVMENU=await (await fetch('/api/text?file=MENU')).json(); }catch(e){ NVMENU={}; } }
  if(!NVPAL){ try{ NVPAL=await (await fetch('/assets/palette.json')).json(); }catch(e){ NVPAL=[]; } }
  const c=(GAME.colonies||[]).find(c=>c.owner===0)||{x:20,y:22};
  const sp=nvSpan();
  NVX=Math.max(0,c.x-(sp.W>>1)); NVY=Math.max(0,c.y-(sp.H>>1)); // center the viewport on colony 0
  NV=true;
  nsIconsReady(()=>nsLabels('MISC',()=>nsLabels('INFO',()=>nsLabels('SEASONS',
    ()=>nsLabels('UNFORESTED',()=>nsLabels('FORESTED',()=>nsLabels('OTHER',()=>nvRender())))))));
}
function nvClose(){ NV=false; ui.close(); }
function nvPal(i){ const c=(NVPAL||[])[i]; return c&&c.hex?c.hex:'#888'; }
function nvRect(sub,fb){
  const e=(NVLAY&&NVLAY.elements||[]).find(e=>e.rect&&e.name.toLowerCase().indexOf(sub)>=0);
  return e?e.rect:fb;
}
function nvLine(sub){ return (NVLAY&&NVLAY.lines||[]).find(l=>l.name.toLowerCase().indexOf(sub)>=0); }
function nvRender(){
  const vp=nvRect('viewport',[0,8,240,192]), mm=nvRect('minimap',[241,8,79,41]);
  let h='';
  // sidebar wood backdrop (WOODPANL) under the right 80px, then the top menu strip
  h+='<img src="/assets/pik/WOODPANL.png" style="position:absolute;left:'+(240*NS_SC)+'px;top:0;'
    +'width:'+(80*NS_SC)+'px;height:'+(200*NS_SC)+'px;image-rendering:pixelated;object-fit:cover">';
  h+=colFill(0,0,320,9,'#4a2f18');
  { // menu titles: the verbatim MENU.TXT section titles (~NAME first line), FONTTINY green
    let x=11;                                          // GAME@11 (spec R x-origins; width-driven)
    ['@GAME','@VIEW','@ORDERS','@REPORTS','@TRADE','@CUP','@PEDIA'].forEach(k=>{
      const sec=String((NVMENU||{})[k]||k.slice(1));
      const title=sec.split('\n')[0].replace(/^~/,'');
      h+='<div onclick="event.stopPropagation();nvMenu(\''+k+'\')" style="cursor:pointer">'
        +nsT(x,1,esc(title),{size:5,col:'#528A31'})+'</div>';
      x+=title.length*4+8;                             // glyph-grid: x advances by title width
    });
    h+='<div onclick="event.stopPropagation();nvEndTurn()" style="cursor:pointer" title="End turn">'
      +nsT(305,1,'&#9654;',{size:5,col:'#FFF35D'})+'</div>';
  }
  // viewport + minimap canvases (drawn after insert)
  h+='<canvas id="nvview" width="'+vp[2]+'" height="'+vp[3]+'" onclick="nvClick(event)" '
    +'style="position:absolute;left:'+(vp[0]*NS_SC)+'px;top:'+(vp[1]*NS_SC)+'px;'
    +'width:'+(vp[2]*NS_SC)+'px;height:'+(vp[3]*NS_SC)+'px;image-rendering:pixelated;cursor:crosshair"></canvas>';
  h+='<canvas id="nvmini" width="'+mm[2]+'" height="'+mm[3]+'" '
    +'style="position:absolute;left:'+(mm[0]*NS_SC)+'px;top:'+(mm[1]*NS_SC)+'px;'
    +'width:'+(mm[2]*NS_SC)+'px;height:'+(mm[3]*NS_SC)+'px;image-rendering:pixelated"></canvas>';
  // sidebar B: season/year + gold + tax at the EXTRACTED line coords (tier R, cited)
  const seas=nsLbl('SEASONS',GAME.season?1:0,GAME.season?'Autumn':'Spring');
  const l1=nvLine('season')||{x:244,y:58}, l2=nvLine('gold')||{x:244,y:66}, l3=nvLine('tax')||{x:290,y:66};
  h+=nsT(l1.x,l1.y,esc(seas)+' '+GAME.year,{size:5,col:NS.white});
  h+=nsT(l2.x,l2.y,esc(nsLbl('CTITLE',1,'Gold:'))+' '+GAME.gold,{size:5,col:NS.white});
  h+=nsT(l3.x,l3.y,esc(nsLbl('CTITLE',9,'Tax:'))+' '+(GAME.tax||0)+'%',{size:5,col:NS.white});
  // sidebar C: the selected-unit panel at the extracted line coords
  const u=selUnit();
  if(u){
    const ls=nvLine('unit sprite')||{x:244,y:80};
    h+='<div style="position:absolute;left:'+(ls.x*NS_SC)+'px;top:'+(ls.y*NS_SC)+'px;'
      +'width:'+(16*NS_SC)+'px;height:'+(16*NS_SC)+'px;background:url(/assets/tileset/units.png) no-repeat;'
      +'background-size:'+(24*16*NS_SC)+'px '+(16*NS_SC)+'px;'
      +'background-position:-'+(u.type*16*NS_SC)+'px 0;image-rendering:pixelated"></div>';
    const lm=nvLine('moves')||{x:270,y:82}, ll=nvLine('locat')||{x:270,y:92};
    h+=nsT(lm.x,lm.y,esc(nsLbl('INFO',0,'Moves:'))+' '+(Math.floor(u.moves/3))+(u.moves%3?' '+(u.moves%3)+'/3':''),{size:5,col:NS.white});
    h+=nsT(ll.x,ll.y,esc(nsLbl('INFO',1,'Locat:'))+' ('+u.x+','+u.y+')',{size:5,col:NS.white});
    const lt=nvLine('unit type')||{x:244,y:104}, lk=nvLine('skill')||{x:244,y:112};
    h+=nsT(lt.x,lt.y,esc(u.name),{size:5,col:NS.white});
    const cls=className(u.profession); if(cls) h+=nsT(lk.x,lk.y,esc(cls),{size:5,col:NS.white});
    const lo=nvLine('orders')||{x:244,y:120};
    h+=nsT(lo.x,lo.y,esc(['No Orders','Fortified','Sentry','Go To','Plowing','Building Road'][u.order]||''),
          {size:5,col:NS.white});
    const lr=nvLine('terrain')||{x:244,y:128};
    const tid=(GAME.terrain[u.y*GAME.w+u.x]||0)&0x1F;
    const tname=(nsLbl(tid>=8&&tid<=23?'FORESTED':(tid>=24?'OTHER':'UNFORESTED'),
                       tid>=24?tid-24:(tid&7),'')||'').split(',')[0];
    h+=nsT(lr.x,lr.y,'('+esc(tname||('terrain '+tid))+')',{size:5,col:NS.white});
  }
  const stage='<div style="position:relative;width:'+(320*NS_SC)+'px;height:'+(200*NS_SC)+'px;'
    +'background:#04060c;image-rendering:pixelated;font-family:monospace;overflow:hidden;'
    +'user-select:none">'+h+'</div>';
  ui.popup('Map view &mdash; native HUD (arrows scroll, click to select/move)',stage);
  setTimeout(nvDraw,0);
}
// the zoomed viewport window + the 1px/tile minimap with the @COLORS owner-dot palette
function nvDraw(){
  const vcv=document.getElementById('nvview'); if(!vcv||!GAME) return;
  const sp=nvSpan(), W=sp.W,H=sp.H,px=sp.px,t=[];
  for(let y=0;y<H;y++) for(let x=0;x<W;x++){
    const mx=NVX+x,my=NVY+y;
    t.push((mx<0||my<0||mx>=GAME.w||my>=GAME.h)?25:GAME.terrain[my*GAME.w+mx]);
  }
  const g=vcv.getContext('2d');
  composeMap(g,t,W,H,px,true);
  const inWin=(x,y)=>x>=NVX&&y>=NVY&&x<NVX+W&&y<NVY+H;
  for(let y=0;y<H;y++) for(let x=0;x<W;x++)            // fog inside the viewport
    if(!fogSeen(Math.min(GAME.w-1,NVX+x),Math.min(GAME.h-1,NVY+y))){ g.fillStyle='#04060c'; g.fillRect(x*px,y*px,px,px); }
  if(!NVH){                                            // Show ~Hidden Terrain (accel H) hides the
                                                       // piece/colony overlays so the terrain
                                                       // beneath shows (RECONSTRUCTED from the row name)
  (GAME.settlements||[]).forEach(s=>{ if(!inWin(s.x,s.y)||!fogSeen(s.x,s.y)) return;
    const X=(s.x-NVX)*px,Y=(s.y-NVY)*px;
    g.fillStyle='#c9a227'; g.beginPath(); g.moveTo(X+(px>>1),Y+(px>>3)); g.lineTo(X+px-(px>>3),Y+px-(px>>3)); g.lineTo(X+(px>>3),Y+px-(px>>3)); g.closePath(); g.fill(); });
  if(GAME.rumors&&PHYS_READY) for(const [rx,ry] of GAME.rumors)      // rumor medallions
    if(inWin(rx,ry)&&fogSeen(rx,ry)) g.drawImage(PHYS,103*16,0,16,16,(rx-NVX)*px,(ry-NVY)*px,px,px);
  (GAME.colonies||[]).forEach(c=>{ if(!inWin(c.x,c.y)||!fogSeen(c.x,c.y)) return;
    const X=(c.x-NVX)*px,Y=(c.y-NVY)*px;
    g.fillStyle=ownerColor(c.owner); g.fillRect(X,Y,px,px);
    if(px>=8){
      g.fillStyle='#2a1c10'; g.fillRect(X+(px>>3),Y+(px>>3),px-(px>>2),px-(px>>2));
      g.fillStyle='#ffe9b0'; g.font='bold '+Math.max(6,px-7)+'px sans-serif'; g.textAlign='center'; g.textBaseline='middle';
      g.fillText(String(c.population),X+(px>>1),Y+(px>>1)+1);
    } });
  (GAME.units||[]).forEach(u=>{ if(!inWin(u.x,u.y)) return;
    if(u.owner!==0&&!fogSeen(u.x,u.y)) return;
    if(UNITS_READY&&u.type<23) g.drawImage(UNITSET,u.type*32,0,32,32,(u.x-NVX)*px-(px>>1),(u.y-NVY)*px-(px>>1),px*2,px*2); });
  const s=selUnit();
  if(s&&inWin(s.x,s.y)){ g.strokeStyle='#ffe27a'; g.lineWidth=Math.max(1,px>>3); g.strokeRect((s.x-NVX)*px+1,(s.y-NVY)*px+1,px-2,px-2); }
  }                                                    // end !NVH overlay block
  // minimap: a 1px/tile scrolling window; dot colors = NAMES @COLORS palette indices
  // (0x830 ocean/coast=68, 0x831 land=149, fog=8, owned=128 -- resolved via VICEROY.PAL)
  const mcv=document.getElementById('nvmini'); if(!mcv) return;
  const mg=mcv.getContext('2d'), MW=mcv.width, MH=mcv.height;
  const ox=Math.max(0,Math.min(GAME.w-MW,NVX+(W>>1)-(MW>>1))), oy=Math.max(0,Math.min(GAME.h-MH,NVY+(H>>1)-(MH>>1)));
  for(let y=0;y<MH;y++) for(let x=0;x<MW;x++){
    const mx=ox+x,my=oy+y;
    let col='#000';
    if(mx<GAME.w&&my<GAME.h){
      if(!fogSeen(mx,my)) col=nvPal(8);
      else{ const id=GAME.terrain[my*GAME.w+mx]&0x1F;
        col=(id===25||id===26)?nvPal(68):nvPal(149);
        if((GAME.colonies||[]).some(c=>c.x===mx&&c.y===my)) col=nvPal(128); }
    }
    mg.fillStyle=col; mg.fillRect(x,y,1,1);
  }
  mg.strokeStyle=nvPal(15); mg.lineWidth=1;            // the white viewport rect (idx 0x0F)
  mg.strokeRect(NVX-ox+0.5,NVY-oy+0.5,W,H);
}
function nvClick(ev){
  const r=ev.target.getBoundingClientRect(), px=nvSpan().px;
  const x=NVX+Math.floor((ev.clientX-r.left)/(px*NS_SC)), y=NVY+Math.floor((ev.clientY-r.top)/(px*NS_SC));
  ev.stopPropagation();
  const here=(GAME.units||[]).findIndex(u=>u.x===x&&u.y===y&&u.alive!==false);
  if(here>=0&&GAME.units[here].owner===0){ SEL=GAME.units[here].id; nvRender(); return; }
  const ci=(GAME.colonies||[]).findIndex(c=>c.x===x&&c.y===y);
  if(ci>=0&&SEL<0){ if(GAME.colonies[ci].owner===0){ NV=false; colOpen(ci); } return; }
  if(SEL>=0){ fetch('/api/game/order',{method:'POST',body:JSON.stringify({unit:SEL,tx:x,ty:y})})
    .then(r=>r.json()).then(d=>{ GAME=d; nvRender(); }); }
}
async function nvEndTurn(){ GAME=await (await fetch('/api/game/step',{method:'POST',body:'{}'})).json(); nvRender(); }
function nvMenu(k){
  const sec=String((NVMENU||{})[k]||''); const items=sec.split('\n').slice(1).map(s=>s.trim()).filter(Boolean);
  if(k==='@REPORTS'){                                  // the one live pulldown: F1-F10 advisors
    ui.popup('REPORTS',items.map((it,i)=>'<div style="padding:2px 0"><a href="#" onclick="ui.close();reportOpen('
      +Math.min(i,9)+');return false">'+esc(it)+'</a></div>').join(''));
    return;
  }
  if(k==='@GAME'){                                     // DECLARE INDEPENDENCE is live
    ui.popup(esc(k.slice(1)),items.map(it=>{
      if(/DECLARE INDEPENDENCE/i.test(it))
        return '<div style="padding:2px 0"><a href="#" onclick="ui.close();declareIndependence();return false">'+esc(it)+'</a></div>';
      return '<div class="muted" style="padding:1px 0">'+esc(it)+'</div>';
    }).join('')||'<i>empty</i>');
    return;
  }
  if(k==='@ORDERS'){                                   // unit-order rows dispatch to the backend
    const live=[                                       // [regex, onclick] per verbatim row
      [/Activate/i,      "nvOrder('-')"],
      [/Wait for next/i, "nvNext()"],
      [/^~?Fortify/i,    "nvOrder('F')"],
      [/Sentry/i,        "nvOrder('S')"],
      [/Build Colony|Join Colony/i, "nvBuild()"],
      [/Clear Forest|Plow Fields/i, "nvOrder('P')"],
      [/Build ~?Road/i,  "nvOrder('R')"],
      [/Return to Europe/i, "NV=false;euOpen()"],
      [/No Orders/i,     "nvNext()"],
      [/Disband/i,       "nvOrder('D')"],
    ];
    ui.popup('ORDERS',items.map(it=>{
      const m=live.find(l=>l[0].test(it.replace(/~/g,'')));
      if(m) return '<div style="padding:2px 0"><a href="#" onclick="ui.close();'+m[1]+';return false">'
        +esc(it.replace(/~/g,''))+'</a></div>';
      return '<div class="muted" style="padding:1px 0">'+esc(it)+'</div>';
    }).join(''));
    return;
  }
  if(k==='@VIEW'){                                     // zoom rows are live (map_view.md 6.2)
    // menu order 120x96..15x12 = zoom 3..0; the current level gets the # mark slot highlighted
    ui.popup('VIEW',items.map(it=>{
      let m;
      if(/Zoom In/i.test(it))  return '<div style="padding:2px 0"><a href="#" onclick="ui.close();nvZoom(NVZ-1);return false">'+esc(it)+'</a></div>';
      if(/Zoom Out/i.test(it)) return '<div style="padding:2px 0"><a href="#" onclick="ui.close();nvZoom(NVZ+1);return false">'+esc(it)+'</a></div>';
      if((m=it.match(/Zoom Level\s*#?(\d+)/i))){
        const z={120:3,60:2,30:1,15:0}[+m[1]];
        const cur=(z===NVZ)?' &#10004;':'';
        return '<div style="padding:2px 0"><a href="#" onclick="ui.close();nvZoom('+z+');return false">'+esc(it)+cur+'</a></div>';
      }
      if(/Center View/i.test(it)) return '<div style="padding:2px 0"><a href="#" onclick="ui.close();nvCenter();return false">'+esc(it)+'</a></div>';
      return '<div class="muted" style="padding:1px 0">'+esc(it)+'</div>';
    }).join(''));
    return;
  }
  ui.popup(esc(k.slice(1))+' &mdash; verbatim MENU.TXT items',
    items.map(it=>'<div class="muted" style="padding:1px 0">'+esc(it)+'</div>').join('')||'<i>empty</i>');
}
// ---- OPENING title cinematic (spec/ui/cinematics.md 6, OPENING.EXE) ----
// Committed data drives it: the @OPENING anim table (col1 sheet-idx / col2
// activation tick / col4 X-base, parsed by _load_anims @0xDD2), @CREDITS
// (start/end tick + OPENCRD sheet/frame, plates centered x=160/y=183
// per _do_credit @0xFB6), OPENING.PIK -- the 960x132 panorama panned 640->0
// at 1 px per 18.2Hz tick (_pan @0x113E) inside the OPENBORD.PIK window
// (rows 24..155) -- and PATH.DAT's ship track (only the endpoint runs are
// committed; the middle is interpolated, RECONSTRUCTED). Per-sprite Y anchors
// live in the .SS frame headers (asset-derived, A-tier; lost in the contact
// sheets) -- element Y here is placed against the panorama art
// (RECONSTRUCTED). A click early-outs (func_001522's kbhit poll).
let OPEN_SHEETS={};
// Masked frames from a docs/atlas contact sheet. Exact geometry (verified by
// pixel scan across the OPEN*/DEC-*/CLOS-* generations): 24px title header,
// then 58px-pitch cell rows (H = 24 + 58*rows); each cell row = ~15px baked
// blue label band + content; cell width 58 (content x in [c*58+1, c*58+56]);
// black = transparency, (70,70,80) = the grid rule color. Skipping the label
// band by geometry removes the label text without color heuristics (blue
// sprite ink, e.g. MPSLOGO, stays intact).
function openSheet(name){
  if(OPEN_SHEETS[name]) return OPEN_SHEETS[name];
  OPEN_SHEETS[name]=new Promise(res=>{
    const img=new Image();
    img.onload=()=>{
      const W=img.width,H=img.height;
      const cv=document.createElement('canvas'); cv.width=W; cv.height=H;
      const g=cv.getContext('2d'); g.drawImage(img,0,0);
      const all=g.getImageData(0,0,W,H).data;
      const ink=o=>{
        const r=all[o],gg=all[o+1],b=all[o+2];
        if(r+gg+b<50) return false;                          // black bg / dark noise
        if(Math.abs(r-70)<14&&Math.abs(gg-70)<14&&Math.abs(b-80)<14) return false; // grid rule
        return true;
      };
      const frames=[];
      const rows=Math.max(1,Math.round((H-24)/58)), cols=Math.floor(W/58);
      let stop=false;
      for(let r=0;r<rows&&!stop;r++){
        const top=24+r*58;
        const cy0=top+15, cy1=Math.min(top+56,H-1);          // skip the label band
        let empty=0;
        for(let c=0;c<cols;c++){
          const cx0=c*58+1;
          let x0=56,x1=-1,y0=1e4,y1=-1;
          for(let y=cy0;y<=cy1;y++) for(let x=0;x<56;x++){
            if(ink(((y*W)+(cx0+x))*4)){
              if(x<x0)x0=x; if(x>x1)x1=x; if(y<y0)y0=y; if(y>y1)y1=y; }
          }
          if(x1<0){ if(++empty>1&&frames.length){ stop=true; break; } else continue; }
          empty=0;
          const w=x1-x0+1,h=y1-y0+1;
          const fc=document.createElement('canvas'); fc.width=w; fc.height=h;
          const out=fc.getContext('2d').createImageData(w,h);
          for(let y=y0;y<=y1;y++) for(let x=x0;x<=x1;x++){
            const o=((y*W)+(cx0+x))*4;
            if(ink(o)){
              const q=((y-y0)*w+(x-x0))*4;
              out.data[q]=all[o]; out.data[q+1]=all[o+1]; out.data[q+2]=all[o+2]; out.data[q+3]=255;
            }
          }
          fc.getContext('2d').putImageData(out,0,0);
          frames.push({cv:fc,w:w,h:h});
        }
      }
      res({frames:frames});
    };
    img.onerror=()=>res({frames:[]});
    img.src='/assets/sprites/atlas_'+name+'.png';
  });
  return OPEN_SHEETS[name];
}
// ---- CLOSING retirement pageant (spec/ui/cinematics.md 4/9, CLOSING.EXE) ----
// The committed @CLOSING actor table (CLOSING_sections.json, parsed like
// func_000A00 @0xA00: col1 sheet-idx / col2 count / col5 Y) runs actors over
// CLOS-BKG.PIK to the "-1 End of closing" sentinel at time 390 (the pacer
// func_000E4C @0xE4C). Sheet map from the table's own row comments (Hat/Lady/
// Man/Military/Fireworks/Rock/Liberty Bell); the actors' X anchors live in the
// .SS headers (not in the contact sheets) -- placement against the scene art
// is RECONSTRUCTED. A click early-outs; the flow continues to the Score screen.
const CLOS_ORDER=['CLOS-HAT','CLOS-LDY','CLOS-MAN','CLOS-MIL','CLOS-FWK','CLOS-ROC','CLOS-BEL'];
const CLOS_POS={0:[40,168],1:[110,166],2:[180,166],3:[248,166],4:[70,8],5:[230,60],6:[128,28]};
let CLOS_SKIP=false;
async function closingPlay(then){
  CLOS_SKIP=false;
  let actors=[];
  try{ const d=await (await fetch('/api/text?file=CLOSING')).json();
    (d['@CLOSING']||'').split('\n').forEach(l=>{
      const m=l.split(';')[0].trim(); if(!m) return;
      const c=m.split(',').map(v=>parseInt(v,10));
      if(c.length>=5&&!isNaN(c[0])&&c[0]>=0) actors.push({sheet:c[0],y:c[4]});
    });
  }catch(e){}
  const S=NS_SC;
  ui.popup('CLOSING',
    '<div onclick="CLOS_SKIP=true" style="cursor:pointer">'
    +'<div style="position:relative;width:'+(320*S)+'px;height:'+(200*S)+'px;'
    +'background:#000;image-rendering:pixelated;overflow:hidden">'
    +'<canvas id="clcv" width="'+(320*S)+'" height="'+(200*S)+'" '
    +'style="position:absolute;left:0;top:0;background:transparent;border:none"></canvas></div>'
    +'<div class="muted" style="font-size:11px;margin-top:4px">click to skip</div></div>');
  const cv=document.getElementById('clcv'); if(!cv){ if(then) then(); return; }
  const g=cv.getContext('2d'); g.imageSmoothingEnabled=false;
  const bkg=await new Promise(r=>{ const i=new Image(); i.onload=()=>r(i); i.onerror=()=>r(null);
    i.src='/assets/pik/CLOS-BKG.png'; });
  const sheets=[]; for(const n of CLOS_ORDER) sheets.push(await openSheet(n));
  for(let t=0;t<390&&!CLOS_SKIP;t++){                 // the sentinel time (@CLOSING row -1,390)
    g.clearRect(0,0,cv.width,cv.height);
    if(bkg) g.drawImage(bkg,0,0,320*S,200*S);
    for(const a of actors){
      const sh=sheets[a.sheet]; if(!sh||!sh.frames.length) continue;
      const fr=sh.frames[Math.floor(t/5)%sh.frames.length];
      const pos=CLOS_POS[a.sheet]||[160,100];
      const y=a.y>0?a.y:pos[1];
      g.drawImage(fr.cv,(pos[0]-(fr.w>>1))*S,(y-fr.h)*S,fr.w*S,fr.h*S);
    }
    await new Promise(r=>setTimeout(r,55));
  }
  ui.close();
  if(then) then();
}
// anim-table sheet index -> sheet name (the _opening load order @0x1e0e..0x1ebe)
const OPEN_ORDER=['OPENWND1','OPENSUN','OPENMON1','OPENWND2','OPENMON2','OPENMON3',
                  'OPENFISH','OPENGUY','OPENLOGO','OPENBONK'];
// Panorama-space Y per sheet (RECONSTRUCTED -- the .SS y-anchors are not in the
// contact sheets; placed against the baked panorama art).
const OPEN_Y={0:2,1:6,2:18,3:2,4:64,5:20,6:84,7:56,8:36,9:56};
let OPEN_SKIP=false;
async function openingPlay(){
  OPEN_SKIP=false;
  let table=[],credits=[];
  try{ const d=await (await fetch('/api/text?file=OPENING')).json();
    (d['@OPENING']||'').split('\n').forEach(l=>{
      const m=l.split(';')[0].trim(); if(!m) return;
      const c=m.split(',').map(v=>parseInt(v,10));
      if(c.length>=4&&!isNaN(c[0])) table.push({sheet:c[0],tick:c[1],fset:c[2],xbase:c[3]});
    });
    (d['@CREDITS']||'').split('\n').forEach(l=>{
      const m=l.split(';')[0].trim(); if(!m) return;
      const c=m.split(',').map(v=>parseInt(v,10));
      if(c.length>=4&&!isNaN(c[0])) credits.push({t0:c[0],t1:c[1],sheet:c[2],frame:c[3]});
    });
  }catch(e){}
  const S=NS_SC;
  ui.popup('OPENING',
    '<div onclick="OPEN_SKIP=true" style="cursor:pointer">'
    +'<div id="opstage" style="position:relative;width:'+(320*S)+'px;height:'+(200*S)+'px;'
    +'background:#000;image-rendering:pixelated;overflow:hidden">'
    +'<canvas id="opcv" width="'+(320*S)+'" height="'+(200*S)+'" '
    +'style="position:absolute;left:0;top:0;background:transparent;border:none"></canvas></div>'
    +'<div class="muted" style="font-size:11px;margin-top:4px">click to skip</div></div>');
  const cv=document.getElementById('opcv'); if(!cv) return;
  const g=cv.getContext('2d'); g.imageSmoothingEnabled=false;
  const imload=src=>new Promise(r=>{ const i=new Image(); i.onload=()=>r(i); i.onerror=()=>r(null); i.src=src; });
  const pano=await imload('/assets/pik/OPENING.png');
  const bord=await imload('/assets/pik/OPENBORD.png');
  const sheets=[]; for(const n of OPEN_ORDER) sheets.push(await openSheet(n));
  const crd=[await openSheet('OPENCRD1'),await openSheet('OPENCRD2'),await openSheet('OPENCRD3')];
  const mps1=await openSheet('MPSLOGO'), mps2=await openSheet('MPSNAME'), ship=await openSheet('OPENSHIP');
  const draw=(fr,x,y)=>{ if(fr) g.drawImage(fr.cv,x*S,y*S,fr.w*S,fr.h*S); };
  // MPS logo -> name intro (schedule RECONSTRUCTED ~1.5s each; the demo follows)
  for(const sh of [mps1,mps2]){
    if(OPEN_SKIP) break;
    const n=sh.frames.length||1;                 // both logos are stroke animations
    for(let f=0;f<n&&!OPEN_SKIP;f++){
      g.clearRect(0,0,cv.width,cv.height);
      const fr=sh.frames[f];
      if(fr) draw(fr,160-(fr.w>>1),100-(fr.h>>1));
      await new Promise(r=>setTimeout(r,Math.max(60,1500/n)));
    }
    if(!OPEN_SKIP) await new Promise(r=>setTimeout(r,700));
  }
  // The panned demo: pan_x 640 -> 0 (1 px/tick), ship along the PATH.DAT track
  // (endpoints committed: (868,89) -> (~170,87); interpolated), anim elements
  // activate at their table ticks, credits at x=160/y=183 between their ticks.
  const TICKS=760;
  for(let t=0;t<TICKS&&!OPEN_SKIP;t++){
    const pan=Math.max(0,640-t);
    g.clearRect(0,0,cv.width,cv.height);
    if(pano) g.drawImage(pano, pan,0,320,132, 0,24*S,320*S,132*S);
    // active anim elements (frame cycles ~1/8 ticks, RECONSTRUCTED cycling)
    for(const a of table){
      if(t<a.tick) continue;
      const sh=sheets[a.sheet]; if(!sh||!sh.frames.length) continue;
      const fr=sh.frames[Math.floor((t-a.tick)/8)%sh.frames.length];
      const x=a.xbase-(fr.w>>1)-pan, y=24+(OPEN_Y[a.sheet]||40);
      if(x>-fr.w&&x<320) draw(fr,x,y);
    }
    // the ship (PATH.DAT: 701 points 868->170, y~89; X -= sheetW>>2 + pan @0xF6E)
    if(ship.frames.length){
      const p=Math.min(t,700), sx=868-(868-170)*p/700, sy=89-2*Math.sin(p/9);
      const fr=ship.frames[Math.floor(t/6)%ship.frames.length];
      const x=sx-(fr.w>>2)-pan;
      if(x>-fr.w&&x<320) draw(fr,x,24+sy-(fr.h>>1));
    }
    // credits (plates centered x=160 / y=183 over the bottom border)
    for(const c of credits){
      if(t<c.t0||t>c.t1) continue;
      const sh=crd[c.sheet]||crd[0]; const fr=sh.frames[c.frame%Math.max(1,sh.frames.length)];
      if(fr) draw(fr,160-(fr.w>>1),183-(fr.h>>1));
    }
    if(bord) g.drawImage(bord, 0,0,320,24, 0,0,320*S,24*S),
             g.drawImage(bord, 0,156,320,44, 0,156*S,320*S,44*S);
    await new Promise(r=>setTimeout(r,55));           // one 18.2 Hz tick
  }
  ui.close();
  newGameSetup();                                     // the boot flow continues into setup
}

// ---- Declaration of Independence cinematic (spec/ui/declaration_independence.md) ----
// func_03DA2A: DECOIND.PIK fills (0,0,320,200); the leader signature (the name at
// 0x540E + rebel*0x34 = @LEADERNAME) is composed glyph-by-glyph from the
// DEC-UPP*/DEC-LOW* cursive sprites. Pen geometry BYTE-VERIFIED inline: seed
// 0x94/0x7E, primary advance += glyph width (es:[sprite+0x4A]), cross kern
// {-1..-4} by glyph class, run ends at 0xDC (220). The end test at 220 exceeds
// the 200-line screen, so the RUNNING axis is x (126 -> 220) and the kern axis
// is y (seed 148, drifting up along the document's tilt) -- the spec's inline
// x/y labels are swapped by that constraint (noted). Per-glyph delay 10/7 ticks
// by class; a click skips (the kbhit/getch poll @0x3DD7A). Glyph widths are
// measured from the atlas frames at runtime (the .SS width word is not in the
// contact sheets); kern RECONSTRUCTED as -2 uppercase / -1 lowercase.
// Each DEC-*.SS is a progressive STROKE animation (e.g. DEC-UPPW = 11 frames,
// the last = the complete cursive letter): the signing "typewriter" draws the
// letter stroke by stroke. The contact-sheet cells are 58px-pitch with baked
// blue index labels + gray borders; the glyph ink is yellow-green, so frames
// are isolated by color (g dominant) inside each cell interior.
const DEC_CACHE={};
function decGlyph(ch){            // -> Promise<{img,frames:[{sx,sy,w,h,dx,dy}]}> | null
  if(!/[a-zA-Z]/.test(ch)) return Promise.resolve(null);
  const up=ch===ch.toUpperCase();
  const sheet='DEC-'+(up?'UPP':'LOW')+ch.toUpperCase();
  if(DEC_CACHE[sheet]) return DEC_CACHE[sheet];
  DEC_CACHE[sheet]=new Promise(res=>{
    const img=new Image();
    img.onload=()=>{
      const cv=document.createElement('canvas'); cv.width=img.width; cv.height=img.height;
      const g=cv.getContext('2d'); g.drawImage(img,0,0);
      const frames=[];
      for(let c=0;c<15;c++){
        const cx0=c*58+1; if(cx0+56>img.width) break;
        const d=g.getImageData(cx0,17,56,img.height-18).data;
        let x0=56,x1=-1,y0=99,y1=-1;
        for(let y=0;y<img.height-18;y++) for(let x=0;x<56;x++){
          const o=(y*56+x)*4;
          const r=d[o],gg=d[o+1],b=d[o+2];
          if(gg>70&&gg>b+30){                        // the yellow-green ink only
            if(x<x0)x0=x; if(x>x1)x1=x; if(y<y0)y0=y; if(y>y1)y1=y; }
        }
        if(x1<0){ if(frames.length) break; else continue; }   // trailing empty = done
        // mask the frame to the ink pixels only (the cell background/labels
        // inside the bbox stay transparent)
        const w=x1-x0+1, h=y1-y0+1;
        const fc=document.createElement('canvas'); fc.width=w; fc.height=h;
        const fg=fc.getContext('2d');
        const out=fg.createImageData(w,h);
        for(let y=y0;y<=y1;y++) for(let x=x0;x<=x1;x++){
          const o=(y*56+x)*4;
          const gg=d[o+1],b=d[o+2];
          if(gg>70&&gg>b+30){
            const q=((y-y0)*w+(x-x0))*4;
            out.data[q]=d[o]; out.data[q+1]=gg; out.data[q+2]=b; out.data[q+3]=255;
          }
        }
        fg.putImageData(out,0,0);
        frames.push({cv:fc, w:w, h:h, dx:x0, dy:y0});
      }
      res(frames.length?{frames:frames}:null);
    };
    img.onerror=()=>res(null);
    img.src='/assets/sprites/atlas_'+sheet+'.png';
  });
  return DEC_CACHE[sheet];
}
let DECL_SKIP=false;
async function declareIndependence(){
  let r;
  try{ r=await (await fetch('/api/game/declare',{method:'POST',body:'{}'})).json(); }
  catch(e){ ui.toast('declare failed'); return; }
  if(r.error){ ui.toast(r.error); return; }
  GAME=r; drawGame&&drawGame();
  let leader='';
  try{ const t=await (await fetch('/api/tables?file=names')).json();
    leader=(((t['@LEADERNAME']||{}).rows||[])[(GAME&&GAME.nation)||0]||{}).name||''; }catch(e){}
  DECL_SKIP=false;
  const S=NS_SC;
  const inner='<canvas id="declcv" width="'+(320*S)+'" height="'+(200*S)+'" '
    +'style="position:absolute;left:0;top:0;background:transparent;border:none"></canvas>';
  ui.popup('DECLARATION OF INDEPENDENCE',
    '<div onclick="DECL_SKIP=true" style="cursor:pointer">'
    +nsScreen('pik/DECOIND.png',inner)
    +'<div class="muted" style="font-size:11px;margin-top:4px">click to skip the signing; close when done'
    +(r.continentals?(' &mdash; '+r.continentals+' veterans promoted to the Continental line'):'')+'</div></div>');
  const cv=document.getElementById('declcv'); if(!cv||!leader) return;
  const g=cv.getContext('2d'); g.imageSmoothingEnabled=false;
  let x=126, y=148;                                  // pen seed (@0x3DC3C/@0x3DC42)
  for(const ch of leader){
    if(x>=220) break;                                // end test 0xDC (@0x3DE04)
    const gl=await decGlyph(ch);
    if(!gl){ x+=3; continue; }                       // space/non-letter: gap RECONSTRUCTED
    const last=gl.frames[gl.frames.length-1];
    // per-stroke animation: each frame replaces the letter as it grows. Stroke
    // frames position relative to the FINAL frame's bbox (the complete letter);
    // the contact-sheet cell padding is layout, not a glyph metric.
    for(let f=0;f<gl.frames.length;f++){
      const fr=gl.frames[f];
      g.clearRect((x-1)*S,(y-last.h-2)*S,(last.w+3)*S,(last.h+6)*S);
      g.drawImage(fr.cv, (x+fr.dx-last.dx)*S,(y-last.h+(fr.dy-last.dy))*S, fr.w*S,fr.h*S);
      if(!DECL_SKIP&&f<gl.frames.length-1)
        await new Promise(rs=>setTimeout(rs,55));    // ~1 PIT tick per stroke
    }
    x+=last.w+1;                                     // primary advance = glyph width (@0x3DDD9)
    y-=(ch===ch.toUpperCase())?2:1;                  // cross kern (@0x3DDE0, class RECONSTRUCTED)
    if(!DECL_SKIP) await new Promise(rs=>setTimeout(rs, (ch===ch.toUpperCase()?10:7)*55));
  }                                                  // ~55ms/tick (18.2Hz PIT, class 0xA/7)
}
// arrow keys scroll the native viewport while it is open
window.addEventListener('keydown',e=>{
  if(!NV||!document.querySelector('#modal.show')) return;
  const t=document.activeElement&&document.activeElement.tagName;
  if(t==='INPUT'||t==='TEXTAREA'||t==='SELECT') return;
  const k=e.key.toLowerCase();
  if(k==='z'){ e.preventDefault(); nvZoom(NVZ-1); return; }   // @VIEW Zoom In# ~Z
  if(k==='x'){ e.preventDefault(); nvZoom(NVZ+1); return; }   // @VIEW Zoom Out ~X
  if(k==='c'){ e.preventDefault(); nvCenter(); return; }      // @VIEW ~Center View
  if(k==='h'){ e.preventDefault(); NVH=!NVH; nvDraw(); return; }         // Show ~Hidden Terrain
  // @ORDERS accelerators (input.md map-command table, manual L63-103)
  if(k==='a'){ e.preventDefault(); nvOrder('-'); return; }    // ~Activate unit
  if(k==='w'){ e.preventDefault(); nvNext(); return; }        // ~Wait for next unit
  if(k===' '){ e.preventDefault(); nvNext(); return; }        // No Orders (space bar)
  if(k==='f'){ e.preventDefault(); nvOrder('F'); return; }    // ~Fortify
  if(k==='s'){ e.preventDefault(); nvOrder('S'); return; }    // ~Sentry
  if(k==='b'){ e.preventDefault(); nvBuild(); return; }       // ~Build Colony / Join Colony (~B)
  if(k==='p'){ e.preventDefault(); nvOrder('P'); return; }    // Clear Forest (~P) / Plow Fields (~P)
  if(k==='r'){ e.preventDefault(); nvOrder('R'); return; }    // Build ~Road
  if(k==='d'&&e.shiftKey){ e.preventDefault(); nvOrder('D'); return; }   // Disband Unit (shift-D)
  if(k==='e'){ e.preventDefault(); ui.close(); NV=false; euOpen(); return; }  // ~Return to Europe
  const d={ArrowLeft:[-2,0],ArrowRight:[2,0],ArrowUp:[0,-2],ArrowDown:[0,2]}[e.key];
  if(!d) return;
  e.preventDefault();
  const s=nvSpan();
  NVX=Math.max(0,Math.min(GAME.w-s.W,NVX+d[0])); NVY=Math.max(0,Math.min(GAME.h-s.H,NVY+d[1]));
  nvDraw();
});

// ---- Turn tab (B5): edit the data-driven turn pipeline (turn.json) ----
let TURN=null;
async function turnLoad(){ TURN=await (await fetch('/api/turn')).json(); TURN.phases=TURN.phases||[]; turnRender(); }
function turnRender(){
  if(!TURN){ $('#turnlist').innerHTML='<span class="muted">loading…</span>'; return; }
  let h='<table style="width:100%"><tr><th></th><th>Phase</th><th>Function</th><th>Scope</th><th>Reads &rarr; Writes</th><th></th></tr>';
  TURN.phases.forEach((p,i)=>{
    const en=p.enabled!==false;
    h+='<tr style="opacity:'+(en?1:.45)+'">'
      +'<td><input type="checkbox" '+(en?'checked':'')+' onchange="turnToggle('+i+',this.checked)"></td>'
      +'<td><b>'+esc(p.id||'')+'</b></td>'
      +'<td><code style="font-size:11px">'+esc(p.function||'')+'</code></td>'
      +'<td>'+esc(p.scope||'')+'</td>'
      +'<td class="muted" style="font-size:10px">'+esc((p.reads||[]).length)+' &rarr; '+esc((p.writes||[]).length)+'</td>'
      +'<td><button class="act" onclick="turnMove('+i+',-1)">&#9650;</button>'
      +'<button class="act" onclick="turnMove('+i+',1)">&#9660;</button></td></tr>';
    if(p.note) h+='<tr style="opacity:'+(en?1:.45)+'"><td></td><td colspan="5" class="muted" style="font-size:10px">'+esc(p.note)+'</td></tr>';
  });
  h+='</table>';
  $('#turnlist').innerHTML=h;
}
function turnToggle(i,on){ TURN.phases[i].enabled=on; turnRender(); }
function turnMove(i,d){ const j=i+d; if(j<0||j>=TURN.phases.length) return;
  const a=TURN.phases; [a[i],a[j]]=[a[j],a[i]]; turnRender(); }
async function turnSave(){ const d=await (await fetch('/api/turn',{method:'POST',body:JSON.stringify(TURN)})).json();
  ui.toast(d.saved?'Turn pipeline saved — next End turn uses it':(d.error||'save failed')); }
document.querySelector('nav button[data-tab=turn]').addEventListener('click',()=>{ if(!TURN) turnLoad(); });

// ---- Systems browser (3.1): the understand/adjust surface over every game mechanic ----
// One card per formula (functions.json): the spec expression + note + spec cite; the cfg
// knobs it reads, editable live (read-modify-write of the active rules overlay -- the same
// validated /api/rules/save path the Rules tab uses, so an invariant-breaking edit is
// rejected); its declared writes with live cell values; and, from the reverse index, every
// other function that also writes those columns. "Step 1 turn" advances the REAL game via
// /api/turn/trace and shows exactly which cells each stage changed.
let SYSD=null, SYSKNOBS={}, SYSTRACE=null;
async function sysInit(){
  if(!SYSD){ SYSD=await (await fetch('/api/functions')).json(); await sysKnobRefresh(); }
  sysRender(); sysLive();
}
async function sysKnobRefresh(){
  const ks=new Set();
  (SYSD.systems||[]).forEach(s=>(s.formulas||[]).forEach(f=>(f.knobs||[]).forEach(k=>ks.add(k))));
  await Promise.all([...ks].map(async k=>{
    try{ SYSKNOBS[k]=(await (await fetch('/api/cell?path=cfg.'+k)).json()).value; }catch(e){}
  }));
}
// a declared write pattern -> one concrete sample cell path against the live game
function sysSample(w){
  if(w.indexOf('market.price')===0) return 'price.0';
  let p=w.replace('colony<N>','colony0').replace('power<N>','power0').replace('unit<N>','unit0')
         .replace('.<good>','.0');
  if(p.indexOf('<')>=0) return null;      // unexpanded pattern (built.<id> etc.)
  return p;
}
function sysRender(){
  if(!SYSD) return;
  const q=($('#sysfilter').value||'').toLowerCase();
  const hit=t=>String(t||'').toLowerCase().indexOf(q)>=0;
  let h='';
  (SYSD.systems||[]).forEach(s=>{
    const fs=(s.formulas||[]).filter(f=> !q || hit(f.title)||hit(f.fn)||hit(f.expr)
      ||(f.knobs||[]).some(hit)||(f.writes||[]).some(hit));
    if(!fs.length) return;
    h+='<div style="margin:14px 0 6px"><b style="font-size:14px">'+esc(s.name)+'</b>'
      +' <span class="muted" style="font-size:11px">'+esc(s.source||'')+'</span>'
      +(s.spec?'<div class="muted" style="font-size:11px">contract: '+esc(s.spec)+'</div>':'')+'</div>';
    h+='<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(430px,1fr));gap:8px">';
    fs.forEach(f=>{
      h+='<div style="border:1px solid #2a2f3a;border-radius:6px;padding:8px;background:#12161f">';
      h+='<div><b>'+esc(f.title||f.fn)+'</b> <code class="muted" style="font-size:10px">'+esc(f.fn)+'</code></div>';
      h+='<pre style="white-space:pre-wrap;background:#0d1117;border:1px solid #232936;border-radius:4px;'
        +'padding:6px;margin:6px 0;font-size:11.5px;color:#9fd0ff">'+esc(f.expr||'')+'</pre>';
      if(f.note) h+='<div class="muted" style="font-size:11px;margin-bottom:6px">'+esc(f.note)+'</div>';
      (f.knobs||[]).forEach(k=>{
        h+='<div style="display:flex;gap:6px;align-items:center;margin:2px 0">'
          +'<code style="font-size:11px;min-width:170px">cfg.'+esc(k)+'</code>'
          +'<input type="number" value="'+(SYSKNOBS[k]!==undefined?SYSKNOBS[k]:'')+'" style="width:90px"'
          +' onchange="sysSetKnob(\''+esc(k)+'\',this.value)"></div>';
      });
      (f.writes||[]).forEach(w=>{
        const sp=sysSample(w);
        const others=((SYSD.reverse_index||{})[w]||[]).filter(x=>x!==f.fn);
        h+='<div style="font-size:11px;margin:2px 0">&rarr; writes <code>'+esc(w)+'</code>'
          +(sp?' = <span class="syslive" data-path="'+esc(sp)+'" style="color:#e2c14a">&hellip;</span>':'')
          +(others.length?' <span class="muted">(also written by '+esc(others.join(', '))+')</span>':'')
          +'</div>';
      });
      h+='</div>';
    });
    h+='</div>';
  });
  $('#syscards').innerHTML=h||'<span class="muted">no formulas match</span>';
}
// fill every live-value span from the cell store (colony0/power0 samples of the write columns)
async function sysLive(){
  const els=[...document.querySelectorAll('#syscards .syslive')];
  await Promise.all(els.map(async el=>{
    try{ const v=(await (await fetch('/api/cell?path='+encodeURIComponent(el.dataset.path))).json()).value;
      el.textContent=(v===null||v===undefined)?'—':String(v);
      el.title=el.dataset.path;
    }catch(e){ el.textContent='—'; }
  }));
}
async function sysSetKnob(k,v){
  let act; try{ act=await (await fetch('/api/rules/active')).json(); }
  catch(e){ ui.toast('rules API unavailable'); return; }
  const ov=act.overlay&&act.overlay.obj!==undefined?act.overlay:(act.overlay||{});
  ov.cfg=ov.cfg||{}; ov.cfg[k]=+v;
  const r=await (await fetch('/api/rules/save',{method:'POST',body:JSON.stringify(ov)})).json();
  if(r.saved){ SYSKNOBS[k]=+v; ui.toast('cfg.'+k+' = '+v+' — active mod saved, sim uses it now'); }
  else ui.toast('rejected: the edit violates a rules invariant');
  sysRender(); sysLive();
}
// advance ONE real game turn, stage by stage, and show exactly what each stage wrote
async function sysTrace(){
  $('#systrace').innerHTML='<span class="muted">stepping one traced turn&hellip;</span>';
  let d; try{ d=await (await fetch('/api/turn/trace',{method:'POST',body:'{}'})).json(); }
  catch(e){ $('#systrace').innerHTML='<span class="muted">trace failed</span>'; return; }
  SYSTRACE=d;
  let h='<div style="border:1px solid #3a4152;border-radius:6px;padding:8px;background:#151a26">'
    +'<b>Turn '+d.turn+' &mdash; year '+d.year+(d.season?' Autumn':' Spring')+'</b>'
    +' <span class="muted" style="font-size:11px">(the Play game advanced; each stage below lists the cells it changed)</span>';
  (d.stages||[]).forEach(st=>{
    const ch=st.changes||[];
    h+='<div style="margin-top:6px"><b>'+esc(st.id)+'</b> <code class="muted" style="font-size:10px">'
      +esc(st.function||'')+'</code>'
      +(ch.length?'':' <span class="muted" style="font-size:11px">— no visible writes</span>');
    if(st.note) h+='<span class="muted" style="font-size:10px"> &middot; '+esc(st.note)+'</span>';
    h+='</div>';
    if(ch.length){
      h+='<table style="font-size:11px;margin:2px 0 2px 14px"><tr><th style="text-align:left">cell</th>'
        +'<th>before</th><th></th><th>after</th></tr>';
      ch.forEach(c=>{ h+='<tr><td><code>'+esc(c.path)+'</code></td><td style="text-align:right">'
        +esc(JSON.stringify(c.before))+'</td><td>&rarr;</td><td style="text-align:right;color:#e2c14a">'
        +esc(JSON.stringify(c.after))+'</td></tr>'; });
      h+='</table>';
    }
  });
  h+='</div>';
  $('#systrace').innerHTML=h;
  sysLive();                       // refresh the card live values
  if(typeof GAME!=='undefined'&&GAME) refreshGame();   // the Play map advanced too
}
document.querySelector('nav button[data-tab=systems]').addEventListener('click',()=>sysInit());
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
// ---- The shared popup FRAME engine (spec/ui/popups.md 2, BYTE-VERIFIED geometry) ----
// Every gameplay popup renders through one engine: WOODPANL-tiled body inside a
// 3px wood border + 2px inset (func_06C520 +0x46/+0x48), content width
// max(80, longest_line+10, @width) (func_06D316 @0x06D392, body margin +10
// @0x06CCE3), centered on (160,100) unless the record pins @x/@y, clamped to
// 320x200 (@0x06D563/71). The speaker-portrait channels (2.7): KING1.SS /
// IND<tribe>A0.SS / MSS<n>.SS / MYR<n>.SS -- the landing pixel is runtime in the
// EXE (2.7.1), here anchored above the box's top-left corner (adaptation).
// {braces} in GAME.TXT bodies mark highlighted words -- rendered as emphasis.
let MSGREC=null;   // @KEY -> {text, box_w, x, y, sprite, speaker} (messages.json)
async function wfRecs(){
  if(MSGREC) return MSGREC;
  MSGREC={};
  try{ const d=await (await fetch('/api/messages')).json();
    (d.messages||d).forEach(r=>{ MSGREC[r.key]=r; }); }catch(e){}
  return MSGREC;
}
// Portrait sheet frame 0 = atlas cell (1,17)..(57,81) of the standard 58px-pitch
// label atlas. The cell's small "0/0x00" index label is BAKED over the sprite
// pixels (a debug-render artifact of the committed contact sheets -- the raw .SS
// files are not in the repo, so it cannot be cropped away without losing the
// face; same accepted artifact as the extracted Founding-Father portraits, see
// tools/extract_cc_portraits.py). Native-scaled portrait div, above the frame.
function wfPortrait(sheet){
  const S=NS_SC;
  return '<div style="position:absolute;left:'+(-8*S)+'px;top:'+(-58*S)+'px;'
    +'width:'+(56*S)+'px;height:'+(64*S)+'px;image-rendering:pixelated;'
    +'background:url(/assets/sprites/atlas_'+sheet+'.png) '+(-1*S)+'px '+(-17*S)+'px;'
    +'background-size:'+(928*S)+'px '+(82*S)+'px;z-index:2"></div>';
}
// Show one popup with the wood chrome. p: {key, body, choices[], tribe?}.
// onChoice(choiceText) fires on a pick; onClose() when a no-choice box is
// dismissed. The record's speaker/box_w/x/y drive the chrome.
async function wfShow(p, onChoice, onClose){
  const recs=await wfRecs();
  const rec=recs[p.key]||{box_w:0,x:-1,y:-1,speaker:'',sprite:''};
  const S=NS_SC;
  const body=(p.body||'').replace(/\r/g,'');
  const lines=body?body.split('\n'):[];
  const ch=p.choices||[];
  // measure the longest line in native px (FONTTINY = 6px monospace rows)
  const cv=document.createElement('canvas').getContext('2d');
  cv.font=(6*S)+'px monospace';
  let longest=0;
  lines.concat(ch).forEach(l=>{ const w=cv.measureText(l.replace(/[{}]/g,'')).width/S;
    if(w>longest) longest=w; });
  const contentW=Math.max(80, Math.ceil(longest)+10, rec.box_w||0);   // @0x06D392
  const rowH=8;                                                        // FONTTINY row pitch
  const boxW=contentW+6;                                               // +border(3)+pad
  const boxH=lines.length*rowH + (ch.length?ch.length*(rowH+3)+3:0) + 6 + 10;
  let X=rec.x>=0?rec.x:Math.round((320-boxW)/2);                       // @0x06D522
  let Y=rec.y>=0?rec.y:Math.round((200-boxH)/2);                       // @0x06D53B
  if(X+boxW>320) X=320-boxW; if(Y+boxH>200) Y=200-boxH;                // clamp @0x06D563
  if(X<0) X=0; if(Y<0) Y=0;
  // speaker channel -> sheet name (2.7); IND needs the tribe index
  let sheet='';
  if(rec.speaker==='KING1') sheet='KING1';
  else if(rec.speaker==='IND') sheet='IND'+(p.tribe||0)+'A0';
  else if(rec.speaker==='MYR') sheet='MYR0';
  else if(rec.speaker&&rec.speaker.startsWith('MSS')) sheet=rec.speaker;
  // {highlight} braces -> emphasized words (the glyph-engine highlight color)
  const mark=t=>esc(t).replace(/\{([^}]*)\}/g,'<span style="color:#fff6d8;font-weight:bold">$1</span>');
  let inner='';
  lines.forEach((l,i)=>{ inner+='<div style="position:absolute;left:'+(5*S)+'px;top:'
    +((5+i*rowH)*S)+'px;font-size:'+(6*S)+'px;line-height:1;white-space:pre;color:#1a1206">'
    +mark(l)+'</div>'; });
  const chTop=5+lines.length*rowH+3;
  ch.forEach((c,i)=>{ inner+='<div class="wfopt" data-i="'+i+'" style="position:absolute;left:'
    +(5*S)+'px;top:'+((chTop+i*(rowH+3))*S)+'px;width:'+((contentW-10)*S)+'px;text-align:center;'
    +'font-size:'+(6*S)+'px;line-height:'+(rowH*S)+'px;color:#2a1c08;cursor:pointer;'
    +'border:1px solid #00000033;background:#ffffff14">'+mark(c)+'</div>'; });
  const ov=document.createElement('div');
  ov.id='wfov';
  ov.style.cssText='position:fixed;inset:0;background:#0008;z-index:70;display:flex;'
    +'align-items:center;justify-content:center';
  ov.innerHTML='<div style="position:relative;width:'+(320*S)+'px;height:'+(200*S)+'px">'
    +'<div id="wfbox" style="position:absolute;left:'+(X*S)+'px;top:'+(Y*S)+'px;'
    +'width:'+(boxW*S)+'px;height:'+(boxH*S)+'px;'
    +'background:url(/assets/pik/WOODPANL.png);background-size:'+(320*S)+'px '+(200*S)+'px;'
    +'image-rendering:pixelated;font-family:monospace;'
    +'border:'+(3*S)+'px solid #5a3d20;box-shadow:inset 0 0 0 '+(2*S)+'px #2e1f10,0 '+(4*S)+'px '+(8*S)+'px #000c;'
    +'cursor:'+(ch.length?'default':'pointer')+'">'
    +inner+'</div>'
    +(sheet?('<div style="position:absolute;left:'+(X*S)+'px;top:'+(Y*S)+'px">'+wfPortrait(sheet)+'</div>'):'')
    +'</div>';
  document.body.appendChild(ov);
  const done=()=>{ ov.remove(); };
  if(ch.length){
    // @default pre-highlight (the GAME.TXT @default directive, 1-based): the
    // recorded choice starts highlighted and Enter accepts it.
    const defi=parseInt(rec.default,10)-1;
    ov.querySelectorAll('.wfopt').forEach(el=>{
      if(+el.dataset.i===defi) el.style.background='#fff6d84d';
      el.onmouseenter=()=>{ el.style.background='#fff6d84d'; };
      el.onmouseleave=()=>{ el.style.background=(+el.dataset.i===defi)?'#fff6d84d':'#ffffff14'; };
      el.onclick=()=>{ done(); if(onChoice) onChoice(ch[+el.dataset.i]); };
    });
    if(defi>=0&&defi<ch.length){
      const onkey=e=>{ if(e.key==='Enter'){ e.preventDefault();
        window.removeEventListener('keydown',onkey); done(); if(onChoice) onChoice(ch[defi]); } };
      window.addEventListener('keydown',onkey);
      ov.addEventListener('click',()=>window.removeEventListener('keydown',onkey));
    }
  } else {
    ov.onclick=()=>{ done(); if(onClose) onClose(); };   // modal wait (0x181F:0x3C0)
  }
}
// Render an event popup and, on a choice, resume the graph -- re-rendering ANY further popup the
// resume returns (a chained ShowPopup) so a multi-stage event is not silently truncated. cache:p._cache
// keeps rolled/offered values stable across each choice.
function playPopup(id, p){
  const resume=async(c)=>{
    const r=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id,from_node:p.node,choice:c,cache:p._cache})})).json();
    await refreshGame();
    if(r.popup) playPopup(id, r.popup);
    else if((r.effects||[]).length) ui.toast(r.effects.join('; ')); };
  wfShow({key:p.title, body:p.body, choices:p.choices||[]}, resume, null);
}
async function saveGame(){
  if(!GAME){ ui.toast('No active game'); return; }
  const d=await (await fetch('/api/game/save',{method:'POST',body:'{}'})).json();
  ui.toast(d.saved?'Game saved':(d.error||'save failed'));
}
async function loadGame(){
  const d=await (await fetch('/api/game/load',{method:'POST',body:'{}'})).json();
  if(d.error){ ui.toast(d.error); return; }
  GAME=d; SEL=-1; drawGame(); showSel(); fillEvents(); ui.toast('Game loaded ('+GAME.year+')');
}
async function stepGame(){
  if(!GAME){ await newGame(); return; }
  const r=await fetch('/api/game/turn',{method:'POST'}); GAME=await r.json();
  drawGame(); showSel(); drawHistory(); ui.toast('Year '+GAME.year);
  if(GAME.events && GAME.events.length) eventQueue(GAME.events.slice());
  if(GAME.endgame && GAME.endgame.over) showEndgame(GAME.endgame);
}
// Endgame. A revolution conclusion shows the King-defeats screen first
// (spec/ui/cinematics.md 3): player wins -> KINGLSS1.PIK + GAME @KINGLOSE at its
// GAME.TXT directives (@x=232 @y=31 @width=68, the upper-right scroll); player
// loses -> KINGLSS2.PIK + @KINGWIN (@x=202 @y=125 @width=90, the lower-right
// scroll), %STRING0 = the mother country (@COUNTRY). Then the Score plate screen
// (the F10 report), per the cinematic order. NOT drawn: the ENGLND/FRANCE/SPAIN/
// DUTCH nation art + KING sprite overlays -- the extracted contact sheets carry
// only partial 66px bands of those tall .SS frames (an asset gap, not a spec
// gap; positions also unpinned). Text ink: FONTKING fg = pixel index 3 of the
// loaded PIK palette (A-tier, palette not in repo) -- dark ink on the parchment
// scrolls (adaptation); GAME.TXT hard wraps re-flow into the @width box.
function showEndgame(e){
  const woi=GAME&&GAME.war&&GAME.war.declared;
  if(!woi){
    ui.toast(e.reason);
    if(e.won) closingPlay(()=>reportOpen(9));   // retirement -> the CLOSING pageant -> Score
    else reportOpen(9);                          // colonial collapse: straight to the score
    return;
  }
  kingDefeats(e);
}
async function kingDefeats(e){
  const R=await wfRecs();
  const rec=R[e.won?'@KINGLOSE':'@KINGWIN']||{};
  let body=rec.text||'';
  if(body.indexOf('%STRING0')>=0){
    let nm='?';
    try{ const t=await (await fetch('/api/tables?file=names')).json();
      nm=(((t['@COUNTRY']||{}).rows||[])[(GAME&&GAME.nation)||0]||{}).name||'?'; }catch(err){}
    body=body.split('%STRING0').join(nm);
  }
  const x=rec.x>=0?rec.x:(e.won?232:202), y=rec.y>=0?rec.y:(e.won?31:125),
        w=rec.box_w||(e.won?68:90);
  nsLabels('MISC',()=>{
    const txt='<div style="position:absolute;left:'+(x*NS_SC)+'px;top:'+(y*NS_SC)+'px;'
      +'width:'+(w*NS_SC)+'px;color:#1a1008;font-size:'+(5*NS_SC)+'px;line-height:1.3;'
      +'font-family:serif;font-weight:bold">'+esc(body.replace(/\n/g,' '))+'</div>';
    const inner=txt+nsOK('ui.close();reportOpen(9)',esc(nsLbl('MISC',46,'OK')));
    ui.popup('Endgame &mdash; '+esc(e.reason),
      nsScreen('pik/KINGLSS'+(e.won?1:2)+'.png',inner));
  });
}
async function drawHistory(){
  let h=[]; try{ h=await (await fetch('/api/game/history')).json(); }catch(e){ return; }
  const cv=$('#ghist'); if(!cv) return; const g=cv.getContext('2d'); const W=cv.width, H=cv.height;
  g.clearRect(0,0,W,H); if(h.length<2) return;
  const line=(key,color)=>{ const vals=h.map(p=>p[key]); const mn=Math.min(...vals), mx=Math.max(...vals);
    const rng=(mx-mn)||1; g.strokeStyle=color; g.beginPath();
    h.forEach((p,i)=>{ const x=i/(h.length-1)*(W-4)+2, y=H-2-((p[key]-mn)/rng)*(H-4);
      i?g.lineTo(x,y):g.moveTo(x,y); }); g.stroke(); };
  line('gold','#e2c14a'); line('sol','#6cc06c');
}
function eventQueue(q){
  if(!q.length) return; const e=q.shift(), p=e.report.popup;
  if(!p){ eventQueue(q); return; }
  showEventPopup(e.graph, p, q);
}
// Like playPopup, but for the per-turn event batch: a chained popup within one event re-renders
// (staying on this event's graph); when the chain ends, advance to the next queued event.
function showEventPopup(id, p, q){
  const resume=async(c)=>{
    const r=await (await fetch('/api/graph/run',{method:'POST',body:JSON.stringify({id,from_node:p.node,choice:c,cache:p._cache})})).json();
    await refreshGame();
    if(r.popup) showEventPopup(id, r.popup, q);
    else eventQueue(q); };
  wfShow({key:p.title, body:p.body, choices:p.choices||[]}, resume,
         ()=>{ refreshGame(); eventQueue(q); });
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
// The +0x315B class byte, displayed (training.md: veteran/hardy/seasoned + the dock classes).
function className(p){
  return {0x14:'Hardy Pioneer',0x15:'Veteran',0x16:'Seasoned Scout',0x18:'Missionary',
          0x19:'Petty Criminal',0x1A:'Indentured Servant',0x1C:'Free Colonist'}[p]||null;
}
// Issue a named standing order (unit_orders.md status letters: P clear/plow, R road,
// F fortify, S sentry, - clear). The improvement executors run on End turn.
async function orderNamed(o){
  if(SEL<0) return;
  GAME=await (await fetch('/api/game/order',{method:'POST',body:JSON.stringify({unit:SEL,order:o})})).json();
  drawGame(); showSel();
}
// "Live among the Indians" (training.md 3): ask the adjacent village to teach. The
// response text is the VERBATIM GAME.TXT @LEARN* record.
async function nativeLearn(){
  if(SEL<0) return;
  try{ const d=await (await fetch('/api/native/learn',{method:'POST',body:JSON.stringify({unit:SEL})})).json();
    const u=selUnit();
    const vil=u&&(GAME.settlements||[]).find(s=>Math.abs(s.x-u.x)<=1&&Math.abs(s.y-u.y)<=1);
    wfShow({key:d.key||'', body:d.msg||'', tribe:vil?vil.tribe:0}, null, null);
  }catch(e){ ui.toast('no village will receive us'); }
  await refreshGame();
}
// The native-village action menu (context_dialogs.md 6): the verbatim @ACTIONS
// rows, each shown per its byte-verified func_04B308 predicate; wired rows run
// their routes, the rest are shown disabled until their backends land.
async function villageMenu(){
  const u=selUnit(); if(!u) return;
  const sv=(GAME.settlements||[]).map((s,i)=>({s,i})).find(e=>Math.abs(e.s.x-u.x)<=1&&Math.abs(e.s.y-u.y)<=1);
  if(!sv){ ui.toast('no village adjacent'); return; }
  let d; try{ d=await (await fetch('/api/native/actions?unit='+SEL+'&settlement='+sv.i)).json(); }
  catch(e){ ui.toast('village menu unavailable'); return; }
  const disp={0:'villageTrade',1:'villageHostile',2:'villageMission',3:'villageDenounce',
              4:'nativeLearn',5:'villageChief',6:'villageIncite',7:'villageTribute',8:'villageAttack',9:''};
  let body='<div style="display:flex;flex-direction:column;gap:4px">'+(d.rows||[]).map(r=>{
    const fn=disp[r.id];
    if(r.id===9) return '<button class="act" onclick="ui.close()">'+esc(r.label)+'</button>';
    if(!r.wired||fn===undefined) return '<button class="act" disabled style="opacity:.45" title="backend pending">'+esc(r.label)+'</button>';
    return '<button class="act" onclick="ui.close();'+fn+'('+sv.i+')">'+esc(r.label)+'</button>';
  }).join('')+'</div>';
  ui.popup('Village &mdash; '+esc(sv.s.name||'natives'), body);
}
async function villageMission(si){
  try{ const r=await (await fetch('/api/native/mission',{method:'POST',
      body:JSON.stringify({unit:SEL,settlement:si})})).json();
    if(r.msg) playPopup(r.key||'@MISSION0', r.msg); else ui.toast(r.error||'failed');
  }catch(e){ ui.toast('failed'); }
  refresh();
}
async function villageTribute(si){
  try{ const r=await (await fetch('/api/native/tribute',{method:'POST',
      body:JSON.stringify({unit:SEL,settlement:si})})).json();
    ui.toast(r.ok?('Tribute paid: '+r.gold+' gold'):'They refuse -- and remember the insult.');
  }catch(e){ ui.toast('failed'); }
  refresh();
}
async function villageAttack(si){
  try{ const r=await (await fetch('/api/native/attack',{method:'POST',
      body:JSON.stringify({unit:SEL,settlement:si})})).json();
    ui.toast(r.razed?('Village razed! Treasure: '+r.gold+' gold'):'The villagers escaped with their wealth.');
  }catch(e){ ui.toast('failed'); }
  refresh();
}
// r0 Trade: sells the unit's laden holds at the byte-verified percent (func_05C878).
async function villageTrade(si){
  try{ const r=await (await fetch('/api/native/trade',{method:'POST',
      body:JSON.stringify({unit:SEL,settlement:si})})).json();
    if(r.ok) ui.toast('Traded '+(r.deals||[]).map(d=>d.qty+' '+d.name).join(', ')+' for '+r.gold+' gold ('+r.pct+'%)');
    else ui.toast(r.error||'no deal');
  }catch(e){ ui.toast('failed'); }
  refresh();
}
// r1 Enter Hostile: a moderate trespass (@0x4A319); the natives will not trade.
async function villageHostile(si){
  try{ const r=await (await fetch('/api/native/hostile',{method:'POST',
      body:JSON.stringify({unit:SEL,settlement:si})})).json();
    ui.toast(r.war?'The village is at WAR with you.':'The village turns you away (alarm '+r.alarm+').');
  }catch(e){ ui.toast('failed'); }
  refresh();
}
// r3 Denounce Heresy: verbatim @HERESY0/@HERESY1 outcome.
async function villageDenounce(si){
  try{ const r=await (await fetch('/api/native/denounce',{method:'POST',
      body:JSON.stringify({unit:SEL,settlement:si})})).json();
    if(r.msg) playPopup(r.key||'@HERESY1', r.msg); else ui.toast(r.error||'failed');
  }catch(e){ ui.toast('failed'); }
  refresh();
}
// r5 Speak With Chief: verbatim @CHIEF* outcome (howdy/gift/tales/bored/kill).
async function villageChief(si){
  try{ const r=await (await fetch('/api/native/chief',{method:'POST',
      body:JSON.stringify({unit:SEL,settlement:si})})).json();
    if(r.msg) playPopup(r.key||'@CHIEFBORED', r.msg); else ui.toast(r.error||'failed');
  }catch(e){ ui.toast('failed'); }
  refresh();
}
// r6 Incite Indians: quote the price (manual's three factors), then confirm.
async function villageIncite(si){
  const t=prompt('Incite against which power? (1..3)','1'); if(t===null) return;
  const target=+t;
  try{
    const q=await (await fetch('/api/native/incite',{method:'POST',
      body:JSON.stringify({unit:SEL,settlement:si,target:target})})).json();
    if(q.error){ ui.toast(q.error); return; }
    if(!confirm('The tribe asks '+q.price+' gold to move against power '+target+'. Pay?')) return;
    const r=await (await fetch('/api/native/incite',{method:'POST',
      body:JSON.stringify({unit:SEL,settlement:si,target:target,confirm:true})})).json();
    ui.toast(r.ok?('The tribe turns on '+r.target+' (tension '+r.tension_target+').'):(r.error||'failed'));
  }catch(e){ ui.toast('failed'); }
  refresh();
}
function villageAdjacent(u){
  return (GAME.settlements||[]).some(s=>Math.abs(s.x-u.x)<=1&&Math.abs(s.y-u.y)<=1);
}
function foreignColonyAdjacent(u){
  return (GAME.colonies||[]).some(c=>c.owner!==0&&Math.abs(c.x-u.x)<=1&&Math.abs(c.y-u.y)<=1);
}
// Scout at a foreign colony (exploration.md 3, func_05A20E): the verbatim
// 4-option @SCOUTCOLONY dialog -- Meet With Mayor / Infiltrate / Attack / Nothing.
async function scoutColony(){
  if(SEL<0) return;
  const d=await (await fetch('/api/scout/colony',{method:'POST',body:JSON.stringify({unit:SEL})})).json();
  if(d.error){ ui.toast(d.error); return; }
  const parts=(d.msg||'').split('\n\n');                     // text, then the option lines
  const opts=(parts[1]||'Meet With Mayor\nInfiltrate Colony\nAttack Colony\nNothing').split('\n');
  wfShow({key:'@SCOUTCOLONY', body:parts[0]||'', choices:opts},
         c=>scoutChoice(opts.indexOf(c)), null);
}
async function scoutChoice(i){
  const d=await (await fetch('/api/scout/colony',{method:'POST',body:JSON.stringify({unit:SEL,choice:i})})).json();
  if(d.error){ ui.toast(d.error); return; }
  if(d.msg){ wfShow({key:d.key||'', body:d.msg}, null, null); }
  else if(d.info){
    const inf=d.info;
    let h='<p><b>'+esc(inf.owner)+'</b> colony &middot; population '+inf.population+'</p>';
    if(inf.stockpile)
      h+='<p class="muted">stores: '+(inf.stockpile.map((q,g)=>q?q+' '+GOODS[g]:'').filter(Boolean).join(', ')||'empty')
        +'</p><p class="muted">'+inf.buildings+' buildings built</p>';
    ui.popup('Colony intelligence', h);
  }
  await refreshGame();
}
// ---- Trade routes (spec/systems/trade_routes.md; the @TRADE* GAME.TXT dialogs) ----
// A route = up to 4 stops (colony or Europe), each with a load list and an unload
// list; a ship/wagon on order "T" ferries the cargo automatically each turn.
function trDestName(d){
  if(d===999) return 'Europe';                    // dest 0x3E7
  if(d===1000) return '—';                   // 0x3E8 = none
  const c=(GAME.colonies||[])[d];
  return c?('#'+(d+1)+' ('+c.x+','+c.y+')'):('colony '+d);
}
function trOpen(){
  if(!GAME){ ui.toast('start a game first'); return; }
  const rts=GAME.routes||[];
  let h='';
  if(!rts.length){
    h+='<p class="muted">You have not yet defined any trade routes.</p>';  // @TRADENONE verbatim
  } else {
    h+='<table class="tbl"><tr><th>route</th><th>type</th><th>stops (load &rarr; unload)</th><th></th></tr>';
    rts.forEach((r,i)=>{
      const stops=r.stops.map(s=>trDestName(s.dest)
        +(s.load.length?' +['+s.load.map(g=>GOODS[g]).join(', ')+']':'')
        +(s.unload.length?' &minus;['+s.unload.map(g=>GOODS[g]).join(', ')+']':'')).join(' &rarr; ');
      h+='<tr><td><b>'+esc(r.name)+'</b></td><td>'+(r.type===0?'Sea route':'Land route')  /* @TRADETYPE */
        +'</td><td>'+stops+'</td>'
        +'<td><button class="act" onclick="trDelete('+i+')">delete</button></td></tr>';
    });
    h+='</table>';
  }
  // create form (@TRADETYPE / @TRADENAME; the @TRADENAMES presets seed the name box)
  const presets=['Run','Ferry','Cargo','Transport','Triangle'];               // @TRADENAMES
  const dests=['<option value="1000">—</option>']
    .concat((GAME.colonies||[]).map((c,i)=>'<option value="'+i+'">'+trDestName(i)+'</option>'))
    .concat(['<option value="999">Europe</option>']).join('');
  const goodsSel=n=>'<select multiple size="3" id="'+n+'" style="min-width:90px">'
    +GOODS.map((g,i)=>'<option value="'+i+'">'+g+'</option>').join('')+'</select>';
  h+='<hr><p><b>Enter the name for this trade route.</b></p>'                 // @TRADENAME
    +'<div class="row">Name: <input id="trname" value="'+presets[(GAME.routes||[]).length%5]+'" maxlength="31"> '
    +'<select id="trtype"><option value="0">Sea route</option><option value="1">Land route</option></select></div>'
    +'<table class="tbl"><tr><th>stop</th><th>destination</th><th>load</th><th>unload</th></tr>';
  for(let s=0;s<4;s++)
    h+='<tr><td>'+(s+1)+'</td><td><select id="trd'+s+'">'+dests+'</select></td>'
      +'<td>'+goodsSel('trl'+s)+'</td><td>'+goodsSel('tru'+s)+'</td></tr>';
  h+='</table><div class="row"><button class="act" onclick="trCreate()">Create route</button>'
    +'<span class="muted"> max 12 routes &middot; 4 stops &middot; 6 goods per list</span></div>';
  ui.popup('Trade routes', h);
}
async function trCreate(){
  const picks=id=>Array.from($('#'+id).selectedOptions).map(o=>+o.value).slice(0,6);
  const stops=[];
  for(let s=0;s<4;s++){
    const d=+$('#trd'+s).value;
    if(d===1000) continue;                        // skip "none" rows
    stops.push({dest:d, load:picks('trl'+s), unload:picks('tru'+s)});
  }
  if(!stops.length){ ui.toast('pick at least one destination'); return; }
  const r=await (await fetch('/api/route/create',{method:'POST',
    body:JSON.stringify({name:$('#trname').value,type:+$('#trtype').value,stops})})).json();
  if(r.error){ ui.toast(r.error); return; }
  GAME=r; ui.close(); trOpen();
}
async function trDelete(i){
  const r=await (await fetch('/api/route/delete',{method:'POST',body:JSON.stringify({route:i})})).json();
  if(r.error){ ui.toast(r.error); return; }
  GAME=r; ui.close(); trOpen(); drawGame(); showSel();
}
// Assign the selected carrier to a route (@TRADESELECT "Select a trade route:").
function trAssign(){
  const u=selUnit(); if(!u) return;
  const rts=(GAME.routes||[]).map((r,i)=>({r,i}))
    .filter(x=>x.r.type===(u.naval?0:1));
  if(!rts.length){ ui.toast('You have not yet defined any '+(u.naval?'sea':'land')+' trade routes.'); return; }  // @TRADENONE2
  let h='<p><b>Select a trade route:</b></p>';    // @TRADESELECT verbatim
  rts.forEach(x=>{ h+='<button class="act" style="margin:3px" onclick="trDoAssign('+x.i+')">'
    +esc(x.r.name)+' ('+x.r.stops.map(s=>trDestName(s.dest)).join(' → ')+')</button>'; });
  ui.popup('Trade route', h);
}
async function trDoAssign(i){
  const r=await (await fetch('/api/game/order',{method:'POST',
    body:JSON.stringify({unit:SEL,order:'T',route:i})})).json();
  if(r.error){ ui.toast(r.error); return; }
  GAME=r; ui.close(); drawGame(); showSel(); ui.toast('Trade route assigned — end turn to run it');
}
function showSel(){
  const u=selUnit();
  $('#foundbtn').disabled = !(u && !u.naval);
  if(!u){ SEL = u===undefined ? -1 : SEL; $('#selinfo').innerHTML='No unit selected. Click a unit to select it.'; return; }
  const ord=['idle','fortified','sentry','moving','clear/plow','building road','trade route'][u.order]||'?';
  const cls=className(u.profession);
  let h='Selected: <b>'+esc(u.name)+'</b>'+(cls?' <span style="color:#e2c14a">('+cls+')</span>':'')
    +' at ('+u.x+','+u.y+') &middot; moves '+u.moves+' &middot; '+ord
    +(u.order===3?(' → ('+u.target_x+','+u.target_y+')'):'')
    +((u.order===4||u.order===5)?(' <span class="muted">('+(u.work||0)+' turns in)</span>'):'')
    +(u.order===6&&(GAME.routes||[])[u.route]
      ?(' <b>'+esc(GAME.routes[u.route].name)+'</b> &rarr; '
        +trDestName((GAME.routes[u.route].stops[u.route_stop]||{dest:1000}).dest)):'')
    +(!u.naval&&u.tools!==undefined?' &middot; tools '+u.tools:'')
    +(u.naval?' &middot; <span class="muted">ship</span>':'');
  if(u.cargo_cap>0)
    h+=' &middot; cargo '+((u.cargo&&u.cargo.length)
      ?u.cargo.map(p=>p[1]+' '+GOODS[p[0]]).join(', '):'empty')
      +' <span class="muted">('+(u.cargo?u.cargo.length:0)+'/'+u.cargo_cap+' holds)</span>';
  // trade-route assignment (@ORDERS row 2 "Trade Route, T") for any cargo carrier
  const tbtn=u.cargo_cap>0
    ?'<button class="act" onclick="trAssign()" title="Automate this carrier over a defined route (trade_routes.md)">Trade route (T)</button>':'';
  // standing-order buttons (the game's P/R/F/S keys) + the village-learning command
  if(!u.naval){
    h+='<div class="row" style="margin-top:4px">'
      +'<button class="act" onclick="orderNamed(\'P\')" title="Clear forest / plow (20 tools; Pioneers work faster as Hardy)">Plow/Clear (P)</button>'
      +'<button class="act" onclick="orderNamed(\'R\')" title="Build road (20 tools)">Road (R)</button>'
      +'<button class="act" onclick="orderNamed(\'F\')" title="Fortify (+50% defense)">Fortify (F)</button>'
      +'<button class="act" onclick="orderNamed(\'S\')">Sentry (S)</button>'
      +tbtn
      +'<button class="act" onclick="orderNamed(\'-\')">Clear order</button>'
      +(villageAdjacent(u)
        ?'<button class="act" style="border-color:#4f9d69" onclick="villageMenu()" '
         +'title="The 10-action village menu (context_dialogs.md 6, func_04B308 row gating)">Village...</button>'
        :'')
      +(u.type===5&&foreignColonyAdjacent(u)
        ?'<button class="act" style="border-color:#4f9d69" onclick="scoutColony()" '
         +'title="Meet the mayor, infiltrate, or attack the foreign colony (exploration.md 3)">Scout colony</button>'
        :'')
      +'</div>';
  } else if(tbtn){
    h+='<div class="row" style="margin-top:4px">'+tbtn
      +'<button class="act" onclick="orderNamed(\'-\')">Clear order</button></div>';
  }
  $('#selinfo').innerHTML=h;
}
// Fog of war (exploration.md): the player's sticky visibility bit is 0x10 (player 0).
function fogSeen(x,y){ return !GAME.fog || (GAME.fog[y*GAME.w+x]&0x10)!==0; }
function drawGame(){
  if(!GAME || !GAME.w) return;
  const cv=$('#gcv'); cv.width=GAME.w*GCELL; cv.height=GAME.h*GCELL;
  const g=cv.getContext('2d');
  composeMap(g, GAME.terrain, GAME.w, GAME.h, GCELL, true);   // base ground + forest/coast overlays
  // terrain improvements (terrain_improvement.md): plow furrows (0x40) + roads (0x08)
  if(GAME.improve){
    for(let y=0;y<GAME.h;y++) for(let x=0;x<GAME.w;x++){
      const b=GAME.improve[y*GAME.w+x]; if(!b) continue;
      const X=x*GCELL, Y=y*GCELL;
      if(b&0x40){ g.strokeStyle='rgba(94,62,28,.85)'; g.lineWidth=1;
        for(let i=3;i<GCELL;i+=4){ g.beginPath(); g.moveTo(X+2,Y+i); g.lineTo(X+GCELL-2,Y+i); g.stroke(); } }
      if(b&0x08){ g.strokeStyle='#b08a52'; g.lineWidth=2;
        g.beginPath(); g.moveTo(X,Y+GCELL/2); g.lineTo(X+GCELL,Y+GCELL/2); g.stroke(); }
    }
  }
  // active Lost-City rumor sites (procedural hash): the PHYS0 rumor medallion (frame 103)
  if(GAME.rumors&&PHYS_READY) for(const [rx,ry] of GAME.rumors)
    if(fogSeen(rx,ry)) g.drawImage(PHYS,103*16,0,16,16,rx*GCELL,ry*GCELL,GCELL,GCELL);
  // native villages (first-class settlements; hidden until explored)
  for(const s of (GAME.settlements||[])){
    if(!fogSeen(s.x,s.y)) continue;
    const X=s.x*GCELL, Y=s.y*GCELL;
    g.fillStyle='#c9a227'; g.beginPath();
    g.moveTo(X+GCELL/2,Y+2); g.lineTo(X+GCELL-2,Y+GCELL-2); g.lineTo(X+2,Y+GCELL-2);
    g.closePath(); g.fill();
    g.strokeStyle='#5e3e1c'; g.lineWidth=1; g.stroke();
    if(s.capital){ g.fillStyle='#5e3e1c'; g.fillRect(X+GCELL/2-1,Y+GCELL/2,2,GCELL/2-2); }
  }
  // unexplored tiles render hidden (the game's black fog; "Unexplored" per @OTHER_NAMES)
  if(GAME.fog){ g.fillStyle='#04060c';
    for(let y=0;y<GAME.h;y++) for(let x=0;x<GAME.w;x++)
      if(!fogSeen(x,y)) g.fillRect(x*GCELL,y*GCELL,GCELL,GCELL);
  }
  // colonies (settlement marker: owner-ringed block + population)
  for(const c of GAME.colonies){
    if(!fogSeen(c.x,c.y)) continue;                     // hidden until explored
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
  // units (real sprites; disc fallback for the unused slot or before load). A unit sprite is 32px
  // on a 16px map tile, so it draws at 2x the tile size -- the SAME pixel scale as the terrain.
  const DS=GCELL*2;
  for(const u of GAME.units){
    if(u.owner!==0 && !fogSeen(u.x,u.y)) continue;      // rivals visible only in explored tiles
    const cx=u.x*GCELL+GCELL/2, cy=u.y*GCELL+GCELL/2;
    if(UNITS_READY && u.type<23){
      g.drawImage(UNITSET, u.type*32,0,32,32, cx-DS/2, cy-DS/2, DS, DS);
    } else {
      g.beginPath(); g.arc(cx,cy,GCELL*0.4,0,7); g.fillStyle=ownerColor(u.owner); g.fill();
      g.lineWidth=1; g.strokeStyle='#000'; g.stroke();
      g.fillStyle='#fff'; g.font='bold 9px sans-serif'; g.textAlign='center'; g.textBaseline='middle';
      g.fillText((u.name||'?')[0], cx, cy+1);
    }
    // the AI mission char (ai.md 4 state alphabet) -- the game's F8 "Show
    // Strategy" cheat overlay, drawn as a small badge on rival units
    if(u.ai_state && u.ai_state!=='X' && u.ai_state!=='0'){
      g.fillStyle='#111'; g.fillRect(cx+GCELL*0.15, cy-GCELL*0.85, GCELL*0.55, GCELL*0.55);
      g.fillStyle='#ffe27a'; g.font='bold '+Math.round(GCELL*0.45)+'px monospace';
      g.textAlign='center'; g.textBaseline='middle';
      g.fillText(u.ai_state, cx+GCELL*0.42, cy-GCELL*0.56);
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
  const ci=GAME.colonies.findIndex(c=>c.x===x&&c.y===y);
  if(ci>=0 && SEL<0){
    const col=GAME.colonies[ci];
    // an own colony opens the native colony screen (spec entry chain: click own colony
    // tile -> set_active_colony -> colony-screen open); foreign ones just report.
    if(col.owner===0) colOpen(ci);
    else ui.popup('Colony', '<p>Foreign colony: population '+col.population+' at ('+col.x+','+col.y+').</p>');
    return;
  }
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
