import json, pathlib, sys
from playwright.sync_api import sync_playwright

HTML = pathlib.Path('/home/user/colopy/port/dist/colonization.html').as_uri()
SHOT = pathlib.Path('/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad')

with sync_playwright() as p:
    b = p.chromium.launch(executable_path="/opt/pw-browsers/chromium")
    pg = b.new_page(viewport={'width': 1400, 'height': 900})
    errs = []
    pg.on('pageerror', lambda e: errs.append(str(e)))
    pg.goto(HTML)
    pg.wait_for_timeout(1200)
    # get into a game with colonies so the tables have content
    # Stage the same colony the `colony` screenshot uses, so the Colonies tab
    # has a real, fully-stocked record to size its tables against.
    pg.evaluate("""() => {
      beginGame(); G.screen='map';
      const sh=G.units[0];
      for(let i=0;i<25&&!G.dialog;i++){sh.movesLeft=9;moveSel(-1,0);}
      closeDialog(1); onClick(-1,-1); dialogKey('Enter');
      G.sel=G.units.findIndex(u=>!u.ship); const f=G.units[G.sel];
      G.natives=G.natives.filter(n=>Math.abs(n.x-f.x)>2||Math.abs(n.y-f.y)>2);
      G.villages=G.villages.filter(v=>Math.abs(v.x-f.x)>2||Math.abs(v.y-f.y)>2);
      buildColony(); closeDialog('Curacao');
      const c=G.colonies[0];
      for(let i=0;i<8;i++)c.colonists.push({type:'Colonists',job:null,cell:null});
      for(const d of [[-1,-1],[0,-1],[1,-1],[-1,0],[1,0],[-1,1],[0,1],[1,1]])
        onClick(224+12+24*(d[0]+1),32+12+24*(d[1]+1));
      c.stock=c.stock.map((v,i)=>[16,3,0,0,3,6,8,3,4,0,0,6,0,0,6,0][i]);
      c.sol=6; G.screen='colony';
    }""")
    pg.wait_for_timeout(400)
    names = pg.evaluate("() => DBG_TABS.map(t => t.name)")
    print('tabs:', names)
    report = []
    for i, n in enumerate(names):
        pg.evaluate(f"() => {{ dbgTab = {i}; _dbgLast=''; dbgRender(); }}")
        pg.wait_for_timeout(120)
        info = pg.evaluate("""() => {
          const pane = document.getElementById('dbgpane');
          const tw = [...pane.querySelectorAll('.tw')];
          const over = tw.filter(w => w.scrollWidth > w.clientWidth + 1)
                         .map(w => { const t = w.querySelector('table');
                                     const hs = [...t.querySelectorAll('th')].map(h=>h.textContent);
                                     return {over: w.scrollWidth - w.clientWidth, cols: hs}; });
          return {
            rows: pane.querySelectorAll('tbody tr').length,
            kv: pane.querySelectorAll('.kv .row').length,
            paneClipped: pane.scrollWidth > pane.clientWidth + 1,
            overflowing: over,
          };
        }""")
        report.append((n, info))
        flag = ''
        if info['overflowing']:
            flag = '  OVERFLOW: ' + '; '.join(
                f"+{o['over']}px {o['cols']}" for o in info['overflowing'])
        print(f"  {n}: rows={info['rows']} kv={info['kv']} "
              f"pane-clipped={info['paneClipped']}{flag}")
        if n in (sys.argv[1:] or []):
            pg.locator('#debug').screenshot(path=str(SHOT / f'tab_{n.lower()}.png'))
    print('errors:', errs)
    b.close()
