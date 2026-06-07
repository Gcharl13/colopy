#!/usr/bin/env python3
"""Generate an interactive NETWORK GRAPH of the whole game: every event wired to
the state VARIABLES it reads/writes and clustered by category. Draggable,
filterable (vis-network). Output: viceroy_source/docs/event_graph.html

Model: CATEGORY hubs --(membership)--> EVENT nodes; VARIABLE --(read)--> EVENT;
EVENT --(write)--> VARIABLE.  Shared variables connect events across categories,
so the graph is the game's state-transition function.
"""
import json, os, re, html
HERE = os.path.dirname(__file__)
OUTDIR = os.path.join(HERE, "..", "..", "viceroy_source", "docs")
CAT = os.path.join(OUTDIR, "event_catalog.json")
ENRICHDIR = os.path.join(OUTDIR, "enrich")
INLINE = {}  # seeds also live in make_event_catalog.ENRICH; enrich/*.json dominate

# canonical game-state variables: name -> (group, [alias regexes])
VARS = {
 # Economy
 "Gold / Treasury":      ("Economy", r"gold|treasur|money|cash|silver"),
 "Tax rate":             ("Economy", r"tax rate|\btax\b|taxation"),
 "Market price":         ("Economy", r"market price|sell price|buy price|\bprice\b|price drift"),
 "Boycott":              ("Economy", r"boycott"),
 "Colony stockpile / cargo": ("Economy", r"stockpile|warehouse|cargo|commodit|goods|trade good"),
 # Revolution
 "Rebel sentiment %":    ("Revolution", r"rebel sentiment|sons of liberty|sons-of-liberty|\bsol\b|rebel support|rebel %|independence movement"),
 "Liberty bells":        ("Revolution", r"\bbells?\b|liberty bell"),
 "Royal Expeditionary Force": ("Revolution", r"\bref\b|expeditionary force|royal (army|navy)|regular|men-o-war|man-o-war|dragoon.*king"),
 "King's anger":         ("Revolution", r"king'?s? anger|king anger|royal (anger|displeasure)"),
 "War-of-Independence flag": ("Revolution", r"war of independence|revolution flag|war-of-independence|independence declared|at war with (the )?king"),
 "Tory %":               ("Revolution", r"tory"),
 # Colony
 "Colony food":          ("Colony", r"\bfood\b|starv|granary"),
 "Colony population":    ("Colony", r"population|colonist count|number of colonists|\bpopulace"),
 "Buildings":            ("Colony", r"building|stockade|\bfort\b|fortress|church|school|college|university|warehouse expansion|factory"),
 "Production / hammers": ("Colony", r"hammer|production|construction|\btools?\b|manufactur"),
 # Military
 "Attack / defense":     ("Military", r"attack|defen[cs]e|combat strength|\bguns?\b|\bhull\b|firepower|bombard"),
 "Veteran status":       ("Military", r"veteran|promot|demot|continental army"),
 "Unit moves / orders":  ("Military", r"unit (type|state|order|move)|\bmoves\b|fortif|sentry"),
 # Native
 "Native alarm / tension": ("Native", r"alarm|tension|provocat|native anger"),
 "Native settlement pop": ("Native", r"settlement (population|size)|village (size|population)|tribe (size|population)"),
 "Mission":              ("Native", r"mission|missionar|convert|heresy"),
 "Tribe attitude":       ("Native", r"attitude|content|restless|tribe.*(mood|relation)"),
 # Diplomacy
 "War / treaty matrix":  ("Diplomacy", r"war (bit|matrix|status)|treaty|\bpeace\b|alliance|declare war|at war with"),
 # Meta / engine
 "Difficulty":           ("Meta", r"difficulty"),
 "Turn / year":          ("Meta", r"turn count|\bturn\b|\byear\b|season|end of turn|end-of-turn"),
 "Multiplayer flag":     ("Meta", r"multiplayer|multi-player|multi player"),
 "Active power":         ("Meta", r"active power|current (player|power)|the player'?s power"),
 "RNG roll":             ("Meta", r"random|\broll\b|\bdice\b|chance|probabilit"),
 "Map / terrain":        ("Meta", r"terrain|\btile\b|\bmap\b|adjacent|coast"),
 "Founding Fathers":     ("Revolution", r"founding father|congress|statesman"),
}
GROUP_COLORS = {
 "Economy":"#3fb950","Revolution":"#f85149","Colony":"#79c0ff","Military":"#ff7b72",
 "Native":"#d2a8ff","Diplomacy":"#39c5cf","Meta":"#e3b341",
}
CAT_CLS = {  # event category -> short colour class (matches catalog)
 "King, Taxes & Revolution":"#f85149","Natives":"#d2a8ff","Colony & Buildings":"#3fb950",
 "Europe, Docks & Trade":"#a5d6ff","Combat & Siege":"#ff7b72","Units & Movement":"#79c0ff",
 "Exploration & Lost Cities":"#39c5cf","Founding Fathers":"#e3b341","Score & Endgame":"#ffa657",
 "Setup, Menus & System":"#8b949e","Miscellaneous":"#6e7681",
}
COMPILED = {k:(g,re.compile(p, re.I)) for k,(g,p) in VARS.items()}

def load_enrich():
    m = {}
    import glob
    for p in glob.glob(os.path.join(ENRICHDIR, "*.json")):
        for k,v in json.load(open(p,encoding="utf-8")).items():
            if not k.startswith("_") and isinstance(v,dict):
                m[k.lstrip("@").upper()] = v
    return m

def match_vars(text):
    if not text: return set()
    return {name for name,(g,rx) in COMPILED.items() if rx.search(text)}

def build():
    cat = json.load(open(CAT))
    enr = load_enrich()
    nodes, edges = [], []
    seen_var, seen_cat = set(), set()
    cats = sorted({r["cat"] for r in cat})
    # category hub nodes
    for c in cats:
        cid = "cat::"+c
        nodes.append({"id":cid,"label":c,"group":"category","shape":"box",
                      "color":CAT_CLS.get(c,"#888"),"font":{"size":20,"color":"#fff"},
                      "value":40,"cat":c,"ntype":"category"})
        seen_cat.add(c)
    n_evt=n_read=n_write=0
    for r in cat:
        key=r["key"]; e=enr.get(key.upper())
        if not e:   # only graph events we have enriched (the 292 traced)
            continue
        eid="ev::"+key
        nodes.append({"id":eid,"label":key,"group":r["cat"],
                      "color":CAT_CLS.get(r["cat"],"#888"),"shape":"dot","value":6,
                      "cat":r["cat"],"ntype":"event","func":r.get("func"),
                      "summary":r.get("summary",""),
                      "trigger":e.get("trigger",""),"inputs":e.get("inputs",""),
                      "outputs":e.get("outputs",""),"verified":bool(e.get("verified"))})
        edges.append({"from":"cat::"+r["cat"],"to":eid,"color":{"color":"#2b3340"},
                      "etype":"member","width":1,"dashes":True})
        n_evt+=1
        reads=match_vars(e.get("trigger","")+" "+e.get("inputs",""))
        writes=match_vars(e.get("outputs",""))
        for v in reads:
            seen_var.add(v); edges.append({"from":"var::"+v,"to":eid,"arrows":"to",
                "color":{"color":"#3a6ea5"},"etype":"read","width":1}); n_read+=1
        for v in writes:
            seen_var.add(v); edges.append({"from":eid,"to":"var::"+v,"arrows":"to",
                "color":{"color":"#b06a2c"},"etype":"write","width":1.5}); n_write+=1
    # variable nodes (only referenced ones)
    for v in sorted(seen_var):
        g=VARS[v][0]
        nodes.append({"id":"var::"+v,"label":v,"group":"var:"+g,"shape":"diamond",
                      "color":GROUP_COLORS[g],"value":18,"font":{"size":15,"color":"#fff"},
                      "ntype":"variable","vgroup":g})
    data={"nodes":nodes,"edges":edges,
          "cats":cats,"catColors":CAT_CLS,"varGroups":GROUP_COLORS,
          "stats":{"events":n_evt,"vars":len(seen_var),"reads":n_read,"writes":n_write}}
    open(os.path.join(OUTDIR,"event_graph.json"),"w").write(json.dumps(data))
    html_out = TEMPLATE.replace("{{DATA}}", json.dumps(data))
    open(os.path.join(OUTDIR,"event_graph.html"),"w",encoding="utf-8").write(html_out)
    print(f"nodes={len(nodes)} (events={n_evt}, vars={len(seen_var)}, cats={len(cats)})  edges={len(edges)} (read={n_read}, write={n_write})")

TEMPLATE = r"""<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>VICEROY.EXE - Game Function Network</title>
<script src="https://unpkg.com/vis-network/standalone/umd/vis-network.min.js"></script>
<style>
:root{--bg:#0d1117;--panel:#161b22;--line:#30363d;--ink:#e6edf3;--muted:#9aa7b4;--accent:#58a6ff}
*{box-sizing:border-box}html,body{margin:0;height:100%;background:var(--bg);color:var(--ink);font:13px/1.45 -apple-system,Segoe UI,Roboto,Arial,sans-serif;overflow:hidden}
#net{position:absolute;inset:0;left:300px}
#side{position:absolute;top:0;left:0;bottom:0;width:300px;background:var(--panel);border-right:1px solid var(--line);overflow:auto;padding:14px}
h1{font-size:17px;margin:0 0 2px}.sub{color:var(--muted);font-size:11.5px;margin:0 0 10px}
.grp{font-size:11px;text-transform:uppercase;letter-spacing:.06em;color:var(--muted);margin:14px 0 5px}
#q{width:100%;padding:7px 9px;background:#0d1117;border:1px solid var(--line);border-radius:7px;color:var(--ink);font-size:13px}
.chip{display:inline-flex;align-items:center;gap:6px;width:100%;text-align:left;background:#0d1117;border:1px solid var(--line);color:var(--ink);border-radius:6px;padding:5px 8px;margin:3px 0;cursor:pointer;font-size:12px}
.chip .dot{width:11px;height:11px;border-radius:3px;flex:0 0 auto}.chip.off{opacity:.32}
.chip .n{margin-left:auto;color:var(--muted);font-size:11px}
.btn{background:#21304a;border:1px solid #34507e;color:#cfe2ff;border-radius:6px;padding:6px 10px;font-size:12px;cursor:pointer;margin:2px 3px 2px 0}
#info{position:absolute;right:12px;top:12px;width:340px;max-height:84%;overflow:auto;background:rgba(22,27,34,.97);border:1px solid var(--line);border-radius:10px;padding:14px 16px;display:none;z-index:9}
#info h3{margin:0 0 6px;font-size:15px}#info .kv{margin:5px 0}#info .kv b{color:var(--accent);min-width:58px;display:inline-block;vertical-align:top}
#info .x{float:right;cursor:pointer;color:var(--muted)}
.badge{border-radius:5px;padding:0 6px;font-size:10.5px;margin-left:4px}.badge.ver{background:#10261a;border:1px solid #1f5133;color:#7ee2a8}.badge.inf{background:#2a2410;border:1px solid #5a4d1c;color:#e8d48a}
.msg{margin-top:7px;padding:6px 8px;background:#0b1722;border:1px solid #1b2a3a;border-radius:6px;color:#bcd;white-space:pre-wrap;font-size:11.5px;max-height:140px;overflow:auto}
.mono{font-family:ui-monospace,Consolas,monospace}
.hint{color:var(--muted);font-size:11px;margin-top:10px;line-height:1.5}
</style></head><body>
<div id="side">
  <h1>Game Function Network</h1>
  <p class="sub">VICEROY.EXE events wired to the state they read/write. Drag nodes; click for detail.</p>
  <input id="q" placeholder="Search events / variables&hellip;" autocomplete="off">
  <div class="grp">Event categories <span id="catstat"></span></div>
  <div id="cats"></div>
  <div class="grp">State variables</div>
  <div id="vgroups"></div>
  <div class="grp">View</div>
  <button class="btn" id="phys">Physics: on</button>
  <button class="btn" id="fit">Fit</button>
  <button class="btn" id="rw">Edges: read+write</button>
  <div class="hint" id="legend"></div>
</div>
<div id="net"></div>
<div id="info"><span class="x" onclick="document.getElementById('info').style.display='none'">&times;</span><div id="infobody"></div></div>
<script>
const D = {{DATA}};
const allNodes = new vis.DataSet(D.nodes);
const allEdges = new vis.DataSet(D.edges.map((e,i)=>({id:"e"+i,...e})));
const container = document.getElementById('net');
const data = {nodes:allNodes, edges:allEdges};
const options = {
  physics:{enabled:true, solver:"barnesHut",
    barnesHut:{gravitationalConstant:-9000, springLength:120, springConstant:0.02, damping:0.5, avoidOverlap:0.3},
    stabilization:{iterations:300}},
  interaction:{hover:true, tooltipDelay:150, multiselect:true},
  nodes:{borderWidth:0, scaling:{min:5,max:45}, font:{color:"#c9d4df",size:12}},
  edges:{smooth:{type:"continuous"}, selectionWidth:2},
};
const net = new vis.Network(container, data, options);

// ---- category filter chips ----
const catState = {}; const vgState = {};
const cstat = document.getElementById('catstat');
const catsDiv = document.getElementById('cats');
const catCounts = {};
D.nodes.forEach(n=>{ if(n.ntype==="event") catCounts[n.cat]=(catCounts[n.cat]||0)+1; });
D.cats.forEach(c=>{ catState[c]=true;
  const b=document.createElement('button'); b.className='chip'; b.dataset.cat=c;
  b.innerHTML=`<span class="dot" style="background:${D.catColors[c]||'#888'}"></span>${c}<span class="n">${catCounts[c]||0}</span>`;
  b.onclick=()=>{catState[c]=!catState[c]; b.classList.toggle('off',!catState[c]); applyFilter();};
  catsDiv.appendChild(b);
});
const vgDiv = document.getElementById('vgroups');
Object.keys(D.varGroups).forEach(g=>{ vgState[g]=true;
  const b=document.createElement('button'); b.className='chip'; b.dataset.vg=g;
  b.innerHTML=`<span class="dot" style="background:${D.varGroups[g]};transform:rotate(45deg)"></span>${g} variables`;
  b.onclick=()=>{vgState[g]=!vgState[g]; b.classList.toggle('off',!vgState[g]); applyFilter();};
  vgDiv.appendChild(b);
});
let showWrite=true, showRead=true;
function visible(n){
  if(n.ntype==="event") return catState[n.cat];
  if(n.ntype==="category") return catState[n.cat];
  if(n.ntype==="variable") return vgState[n.vgroup];
  return true;
}
function applyFilter(){
  const hid={};
  allNodes.forEach(n=>{ const h=!visible(n); hid[n.id]=h; });
  allNodes.update(D.nodes.map(n=>({id:n.id, hidden:hid[n.id]})));
  allEdges.update(D.edges.map((e,i)=>{
    const eh = hid[e.from]||hid[e.to] || (e.etype==="read"&&!showRead) || (e.etype==="write"&&!showWrite);
    return {id:"e"+i, hidden:eh};
  }));
}
document.getElementById('phys').onclick=function(){ const on=!net.physics.options.enabled; net.setOptions({physics:{enabled:on}}); this.textContent="Physics: "+(on?"on":"off"); };
document.getElementById('fit').onclick=()=>net.fit({animation:true});
document.getElementById('rw').onclick=function(){
  // cycle: read+write -> write only -> read only -> read+write
  if(showRead&&showWrite){showRead=false;showWrite=true;this.textContent="Edges: write only";}
  else if(showWrite&&!showRead){showRead=true;showWrite=false;this.textContent="Edges: read only";}
  else {showRead=true;showWrite=true;this.textContent="Edges: read+write";}
  applyFilter();
};
// ---- search highlight ----
document.getElementById('q').addEventListener('input',function(){
  const s=this.value.trim().toLowerCase();
  if(!s){ allNodes.update(D.nodes.map(n=>({id:n.id,opacity:undefined}))); return; }
  const upd=D.nodes.map(n=>({id:n.id, opacity:(n.label.toLowerCase().includes(s)||(n.summary||"").toLowerCase().includes(s))?1:0.15}));
  allNodes.update(upd);
  const hit=D.nodes.find(n=>n.label.toLowerCase().includes(s));
  if(hit) net.focus(hit.id,{scale:1.0,animation:true});
});
// ---- click detail ----
net.on("click", p=>{
  if(!p.nodes.length){ return; }
  const n=allNodes.get(p.nodes[0]); const box=document.getElementById('info'); const b=document.getElementById('infobody');
  if(n.ntype==="event"){
    const vb = n.verified?'<span class="badge ver">byte-verified</span>':'<span class="badge inf">from message</span>';
    b.innerHTML=`<h3>@${n.label} ${vb}</h3>`+
      `<div class="kv"><b>Role</b> ${esc(n.summary)}</div>`+
      `<div class="kv"><b>Func</b> <span class="mono">${n.func||'(UI)'}</span> &middot; ${esc(n.cat)}</div>`+
      (n.trigger?`<div class="kv"><b>Trigger</b> ${esc(n.trigger)}</div>`:'')+
      (n.inputs?`<div class="kv"><b>Inputs</b> ${esc(n.inputs)}</div>`:'')+
      (n.outputs?`<div class="kv"><b>Outputs</b> ${esc(n.outputs)}</div>`:'');
    box.style.display='block';
  } else if(n.ntype==="variable"){
    // list events that read/write this var
    const reads=[],writes=[];
    D.edges.forEach(e=>{ if(e.from===n.id&&e.etype==="read") reads.push(e.to.slice(4));
                         if(e.to===n.id&&e.etype==="write") writes.push(e.from.slice(4)); });
    b.innerHTML=`<h3>${esc(n.label)}</h3><div class="kv"><b>Type</b> state variable (${n.vgroup})</div>`+
      `<div class="kv"><b>Written by</b> ${writes.length} events: ${esc(writes.slice(0,30).join(', '))||'&mdash;'}</div>`+
      `<div class="kv"><b>Read by</b> ${reads.length} events: ${esc(reads.slice(0,30).join(', '))||'&mdash;'}</div>`;
    box.style.display='block';
  } else { box.style.display='none'; }
});
function esc(s){return (s||"").replace(/[&<>]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;'}[c]));}
document.getElementById('legend').innerHTML =
  `<b>${D.stats.events}</b> events &middot; <b>${D.stats.vars}</b> state variables &middot; `+
  `<b>${D.stats.reads}</b> reads + <b>${D.stats.writes}</b> writes.<br>`+
  `Diamonds = state variables (hubs = central state like Gold / Rebel sentiment). `+
  `Blue edge = event reads a variable; orange edge = event writes it. `+
  `Toggle categories/variable-groups at left; drag to rearrange.`;
cstat.textContent = "("+D.cats.length+")";
net.once("stabilizationIterationsDone",()=>net.fit());
</script></body></html>"""

if __name__ == "__main__":
    build()
