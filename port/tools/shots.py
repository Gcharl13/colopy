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
    ("colony", "beginGame();sailToLand();makeColony();G.screen='colony'"),
    ("europe", "beginGame();G.screen='map';G.europe=[{type:'Caravel',icon:5,cargo:[],state:'port'}];G.screen='europe'"),
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
            # Pin the active-unit blink to its visible phase so map shots are
            # deterministic frame to frame.
            pg.evaluate(f"() => {{ {setup}; G.tick = 0; }}")
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
