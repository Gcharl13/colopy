#!/usr/bin/env python3
"""Drive the bundled port headlessly and dump one PNG per screen.

Renders at 1x into port/_shots/ so the output can be diffed pixel-for-pixel
against the DOSBox captures in docs/screens/.
"""
import sys
from pathlib import Path

from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[2]
DIST = ROOT / "port" / "dist" / "colonization.html"
OUT = ROOT / "port" / "_shots"

# (name, state to force before the frame is grabbed)
SHOTS = [
    ("title", "G.screen='title'"),
    ("difficulty", "G.screen='difficulty'"),
    ("nation", "G.screen='nation'"),
    ("name", "G.screen='name';G.leader=DATA.nations[0].leader"),
    ("briefing", "G.screen='briefing';G.briefPage=0"),
    ("cards", "G.screen='cards';G.card=0"),
    ("king", "G.screen='king'"),
    ("map", "beginGame();G.screen='map'"),
    ("landho", "beginGame();G.screen='map';openDialog('LANDHO',()=>{})"),
    ("landfall", "beginGame();G.screen='map';openDialog('LANDFALL',()=>{})"),
    ("woodcut", "G.screen='woodcut';G.woodcut=1"),
    ("ashore", "beginGame();G.screen='map';sailToLand()"),
    # The old one called sailToLand()/makeColony(), neither of which exists --
    # it threw and silently left the map on screen. This is the real sequence,
    # then the colony is stocked to roughly the live Curacao frame (eight
    # workers out on the fields, a carpenter indoors, a full warehouse) so the
    # shot exercises the tile panel, the plaza pack and all three strip rows.
    ("colony",
     "beginGame();G.screen='map';"
     "(()=>{const sh=G.units[0];"
     "for(let i=0;i<25&&!G.dialog;i++){sh.movesLeft=9;moveSel(-1,0);}"
     "closeDialog(1);onClick(-1,-1);dialogKey('Enter');"
     "G.sel=G.units.findIndex(u=>!u.ship);const f=G.units[G.sel];"
     "G.natives=G.natives.filter(n=>Math.abs(n.x-f.x)>2||Math.abs(n.y-f.y)>2);"
     "G.villages=G.villages.filter(v=>Math.abs(v.x-f.x)>2||Math.abs(v.y-f.y)>2);"
     "buildColony();closeDialog('Curacao');"
     "const c=G.colonies[0];"
     "for(let i=0;i<8;i++)c.colonists.push({type:'Colonists',job:null,cell:null});"
     # A field click moves the SELECTED colonist, so walk the selection along
     # with the cells -- otherwise the same man is dragged around all eight.
     "for(const [k,d] of [[-1,-1],[0,-1],[1,-1],[-1,0],[1,0],[-1,1],[0,1],[1,1]]"
     "  .entries()){G.colonistSel=k+1;"
     "  onClick(224+12+24*(d[0]+1),32+12+24*(d[1]+1));}"
     "G.colonistSel=0;"
     "c.stock=c.stock.map((v,i)=>[16,3,0,0,3,6,8,3,4,0,0,6,0,0,6,0][i]);"
     "c.sol=6;G.screen='colony';})()"),
    ("europe", "beginGame();G.screen='map';G.europe=[{type:'Caravel',icon:5,cargo:[],state:'port'}];G.screen='europe'"),
    ("options",
     "beginGame();G.screen='map';openOptions('game')"),
    # The 15-row @PICKMUSIC picker, preselected on Hole In The Wall (id 0x3A,
    # row 11) to show the id->row table at work.
    ("pickmusic",
     "beginGame();G.screen='map';G.tune=0x3A;pickMusic()"),
    ("pickmusic_indian",
     "beginGame();G.screen='map';pickMusic();G.dialog.sel=14;dialogKey('Enter')"),
    ("exitdos", "beginGame();G.screen='map';exitToDos()"),
    ("traderoute",
     "beginGame();G.screen='map';"
     "G.colonies=[{name:'Boston',x:20,y:20,nation:0,colonists:[],stock:DATA.cargo.map(()=>0),"
     "buildings:[],hammers:0,building:null,sol:0},"
     "{name:'Salem',x:24,y:20,nation:0,colonists:[],stock:DATA.cargo.map(()=>0),"
     "buildings:[],hammers:0,building:null,sol:0}];"
     "openTradeMenu('create');G.trade.stops=[0];"),
    ("parley",
     "beginGame();G.screen='map';G.turn=60;"
     "(()=>{const r=G.rivals[0];r.met=true;r.attitude=10;r.gold=9000;openParley(r);})()"),
    ("fog",
     "beginGame();G.screen='map';"
     "(()=>{const s=G.units[0];for(let i=0;i<12;i++){s.movesLeft=99;moveSel(-1,0);}"
     "centerOn(s.x+3,s.y);})()"),
    # The two map markers that were broken, side by side on one land patch:
    # a colony of each power (so the pennant can be checked against the flag
    # baked into the marker sprite) and every Lost City Rumour in range.
    ("map_markers",
     "beginGame();G.screen='map';"
     "(()=>{"
     "  let land=null;"
     "  for(let y=2;y<MAP.h-2&&!land;y++)for(let x=2;x<MAP.w-2&&!land;x++){"
     "    let n=0;"
     "    for(let dy=0;dy<6;dy++)for(let dx=0;dx<10;dx++)"
     "      if(!tileWater(at(x+dx,y+dy)))n++;"
     "    if(n>=54)land=[x,y];}"
     "  const [lx,ly]=land;"
     "  centerOn(lx+5,ly+3);"
     "  for(let dy=-2;dy<VIEW_ROWS()+2;dy++)for(let dx=-2;dx<VIEW_COLS()+2;dx++)"
     "    reveal(G.view.x+dx,G.view.y+dy,0);"
     "  G.colonies=[0,1,2,3].map((n,k)=>({name:['Boston','Quebec','Havana','Nieuw'][n],"
     "    x:lx+1+k*2,y:ly+3,nation:n,colonists:[],stock:DATA.cargo.map(()=>0),"
     "    buildings:n>1?['Stockade']:[],hammers:0,building:null,sol:0}));"
     "  G.dialog=null;G.eventQueue=[];G.units=[];G.natives=[];G.villages=[];"
     "})()"),
    ("treasure",
     "beginGame();G.screen='map';G.tax=15;"
     "G.colonies=[{name:'Boston',x:G.units[0].x,y:G.units[0].y,nation:0,colonists:[],"
     "stock:DATA.cargo.map(()=>0),buildings:[],hammers:0,building:null,sol:0}];"
     "(()=>{const t=mkUnit('Treasure',G.colonies[0].x,G.colonies[0].y);t.treasure=45;"
     "G.units.push(t);checkTreasure();})()"),
    ("fatigue",
     "beginGame();sailToLand();"
     "(()=>{const p=G.units[1];G.sel=1;p.movesLeft=p.moves-1;"
     "const d=[[1,0],[0,1],[-1,0],[0,-1]].find(([dx,dy])=>!tileWater(at(p.x+dx,p.y+dy)));"
     "G.natives.push({type:'Braves',icon:unit('Braves').icon,x:p.x+d[0],y:p.y+d[1],"
     "tribe:0,orders:0,nation:-1});moveSel(d[0],d[1]);})();"),
    ("combat",
     "beginGame();sailToLand();"
     "(()=>{const p=G.units[1];G.sel=1;p.profession='Veteran Soldiers';"
     "const foe={type:'Braves',icon:unit('Braves').icon,x:p.x,y:p.y,"
     "tribe:0,orders:6,nation:-1};G.natives.push(foe);"
     "resolveAttack(p,foe);})();G.screen='map'"),
    ("kingtax",
     "beginGame();G.screen='map';G.tax=12;G.gold=3000;G.turn=taxInterval()*4;"
     "G.colonies=[{name:'Boston',x:20,y:20,nation:0,colonists:[],"
     "stock:DATA.cargo.map((_,i)=>i===2?140:0),buildings:[],hammers:0,building:null,sol:20}];"
     "for(let k=0;k<40&&!G.dialog;k++){kingTaxDemand();if(!G.dialog)G.turn+=1;}"),
    ("lostcity",
     "beginGame();G.screen='map';G.rumourFloor=3;"
     "showEvent('LOSTCITY3',{NUMBER0:180})"),
    ("declare",
     "beginGame();G.screen='map';"
     "G.colonies=[{name:'Boston',x:G.units[0].x,y:G.units[0].y,nation:G.nation,"
     "colonists:[{type:'Colonists',profession:null,job:null,cell:null}],"
     "stock:DATA.cargo.map(()=>0),buildings:STARTING_BUILDINGS.slice(),hammers:0,"
     "building:null,sol:80}];declareIndependence()"),
    ("score",
     "beginGame();G.screen='map';G.gold=4200;G.bellsTotal=9000;"
     "G.fathersOwned=['Adam Smith','Simon Bolivar'];"
     "G.colonies=[{name:'Boston',x:20,y:20,nation:0,colonists:["
     "{profession:null},{profession:'Expert Farmers'},{profession:'Petty Criminals'}],"
     "stock:DATA.cargo.map(()=>0),buildings:[],hammers:0,building:null,sol:64}];"
     "G.report='F10';G.screen='report'"),
    ("roads",
     "beginGame();G.screen='map';"
     "(()=>{let bx=-1,by=-1;"
     "for(let y=8;y<60&&bx<0;y++)for(let x=8;x<44;x++){"
     "let ok=true;for(let k=0;k<6;k++)if(tileWater(at(x+k,y))||tileWater(at(x+k,y+1)))ok=false;"
     "if(ok){bx=x;by=y;break;}}"
     "for(let k=0;k<6;k++)IMPROVE[by*MAP.w+bx+k]|=ROAD_BIT;"
     "IMPROVE[(by+1)*MAP.w+bx+2]|=ROAD_BIT;IMPROVE[(by+2)*MAP.w+bx+2]|=ROAD_BIT;"
     "for(let k=0;k<4;k++)IMPROVE[(by+1)*MAP.w+bx+3+k]|=PLOW_BIT;"
     "centerOn(bx+3,by+1);})()"),
    ("colony_production",
     "beginGame();sailToLand();makeColony();"
     "(()=>{const c=G.colonies[0];"
     "for(let i=0;i<5;i++)c.colonists.push({type:'Colonists',profession:null,job:null,cell:null});"
     "c.stock[5]=100;c.stock[1]=100;c.stock[6]=100;"
     "c.buildings.push(\"Rum Distiller's House\",\"Blacksmith's House\");"
     "const cells=[[-1,-1],[0,-1],[1,0],[-1,1]];"
     "cells.forEach((cell,i)=>{c.colonists[i].cell=cell;c.colonists[i].job=bestFieldJob(c,c.colonists[i]);});"
     "c.colonists[4].job='Distiller';c.colonists[5].job='Carpenter';"
     "c.building='Docks';G.colonyView=2;})();G.screen='colony'"),
    ("village_actions",
     "beginGame();enterVillage(G.villages[0], mkUnit('Missionaries',G.villages[0].x-1,G.villages[0].y))"),
    ("village_trade",
     "beginGame();enterVillage(G.villages[0], mkUnit('Wagon Train',G.villages[0].x-1,G.villages[0].y));"
     "G.villageVisitor.hold=[{good:4,qty:100}];G.villageMode='trade'"),
    ("event_mission",
     "beginGame();G.screen='map';showEvent('MISSION0',{STRING0:DATA.missionpre[0],"
     "STRING1:G.tribes[0].singular,STRING2:G.tribes[0].name+' Camp',STRING3:G.tribes[0].name,NUMBER0:1502})"),
    ("map_mission",
     "beginGame();G.screen='map';G.villages[0].mission={power:0,expert:false};"
     "G.villages[1].mission={power:1,expert:true};centerOn(G.villages[0].x,G.villages[0].y)"),
    ("village_scout",
     "beginGame();enterVillage(G.villages[0], mkUnit('Scouts',G.villages[0].x-1,G.villages[0].y))"),
    ("learn_offer",
     "beginGame();G.screen='map';liveAmong(G.villages[0], mkUnit('Colonists',0,0))"),
    ("tribute",
     "beginGame();G.screen='map';G.units.push(mkUnit('Soldiers',0,0));"
     "G.villages[0].tributePaid=false;for(let i=0;i<40&&!G.villages[0].tributePaid;i++)"
     "demandTribute(G.villages[0], null)"),
    ("attack_village",
     "beginGame();G.screen='map';attackVillage(G.villages[0], mkUnit('Dragoons',0,0))"),
    ("event_raid",
     "beginGame();G.screen='map';showEvent('RAIDSTORES',{STRING0:G.tribes[0].name,"
     "STRING1:'Jamestown',STRING2:'Furs',STRING3:DATA.nations[0].adjective})"),
    # The three adviser reports rebuilt from live DOSBox frames. Each is set up
    # to match the state its capture was taken in -- one colony, one ship, one
    # tribe met -- so port/_shots/report_F*.png diffs directly against
    # docs/screens/live_2026-08-05/7[456]_report_*.png.
    # F2 staged at the live frame's own state: 6 crosses toward a 9-cross
    # threshold, which is what 21_report_F2_religious.png shows.
    ("report_F2",
     "beginGame();G.screen='map';G.crosses=6;"
     "window.immigrationThreshold=()=>9;G.report='F2';G.screen='report'"),
    ("report_F5",
     "beginGame();sailToLand();makeColony();G.report='F5';G.screen='report'"),
    ("report_F7",
     "beginGame();sailToLand();makeColony();G.report='F7';G.screen='report'"),
    # F9 lists only tribes whose settlements the player has found, so reveal one
    # Tupi camp -- the same single-tribe state 76_report_F9_indian.png was taken in.
    ("report_F9",
     "beginGame();sailToLand();makeColony();"
     "(()=>{const ti=G.tribes.findIndex(t=>t.singular==='Tupi');"
     "G.villages.filter(v=>v.tribe===ti).forEach(v=>{SEEN[v.y*MAP.w+v.x]|=SEEN_BIT();});})();"
     "G.report='F9';G.screen='report'"),
]


def main():
    OUT.mkdir(exist_ok=True)
    with sync_playwright() as pw:
        b = pw.chromium.launch(executable_path="/opt/pw-browsers/chromium")
        pg = b.new_page(viewport={"width": 420, "height": 320})
        pg.goto(DIST.as_uri())
        pg.wait_for_function("typeof G !== 'undefined' && Object.keys(IMG).length > 5")
        pg.wait_for_timeout(400)
        # Walk the ship west until it is beside land, then put the cargo ashore
        # -- the same path the player takes, so the shot proves the real flow.
        pg.evaluate("""() => { window.sailToLand = () => {
          const s = G.units[0];
          for (let i = 0; i < 40; i++) {
            for (const [dx, dy] of [[-1,0],[0,-1],[0,1]]) {
              if (!tileWater(at(s.x+dx, s.y+dy))) {
                landfall(s, s.x+dx, s.y+dy); closeDialog(1);
                G.screen = 'map'; G.dialog = null; return;   // skip the woodcut/naming for this shot
              }
            }
            s.movesLeft = 9; moveSel(-1, 0);
            if (G.dialog) closeDialog(G.dialog.opts ? 1 : 'America');
          }
        }; }""")
        pg.evaluate("""() => { window.makeColony = () => {
          const p = G.units[1]; G.sel = 1;
          buildColony(); closeDialog(G.dialog.entry);
          G.screen = 'colony';
        }; }""")
        for name, setup in SHOTS:
            # Pin the active-unit blink to its visible phase, and the colour
            # cycle to phase 0 -- the phase the DOSBox captures were taken at --
            # so map shots are deterministic frame to frame.
            pg.evaluate(f"() => {{ {setup}; G.tick = 0; G.cyclePhase = 0; }}")
            pg.wait_for_timeout(120)
            # Grab the logical 320x200 frame, not the upscaled canvas.
            data = pg.evaluate("""() => {
              const cv = document.getElementById('screen');
              const o = document.createElement('canvas');
              o.width = 320; o.height = 200;
              const g = o.getContext('2d');
              g.imageSmoothingEnabled = false;
              g.drawImage(cv, 0, 0, cv.width, cv.height, 0, 0, 320, 200);
              return o.toDataURL('image/png');
            }""")
            import base64
            (OUT / f"{name}.png").write_bytes(base64.b64decode(data.split(",", 1)[1]))
            print("  ", name)
        b.close()
    print(f"wrote {OUT}")


if __name__ == "__main__":
    sys.exit(main())
