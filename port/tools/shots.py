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
