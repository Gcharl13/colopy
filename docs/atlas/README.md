# Visual Asset Atlas — every sprite sheet & screen image

Rendered from the original game assets via `tools/sprite_atlas.py` (decoder `tools/ssdec.py`). **Regenerate:** `python3 tools/sprite_atlas.py --all --out docs/atlas` (needs the sheets unzipped from `col.zip` into `raw/COLONIZE/`).

- **`sprites/`** — 206 sprite-sheet contact sheets (`atlas_<NAME>.png`); each cell labeled **`decimal/0xHEX`** = the sprite index the specs cite.
- **`pik/`** — 35 full-screen `.PIK` images (`<NAME>.png`).

> These PNGs are committed as a deliberate exception to the repo's "decoded binaries stay regenerable" rule, for at-a-glance visual reference.

## Sprite sheets (`sprites/`)

### Terrain
[PHYS0](sprites/atlas_PHYS0.png)

### Terrain (ORPHAN — never loaded, CLAUDE.md #5)
[BDARK](sprites/atlas_BDARK.png) · [TERRAIN](sprites/atlas_TERRAIN.png)

### Icons / goods / units / HUD
[ICONS](sprites/atlas_ICONS.png)

### Colony buildings
[BUILDING](sprites/atlas_BUILDING.png)

### Founding Father portraits (CC-NN = @FATHERS index)
[CC-00](sprites/atlas_CC-00.png) · [CC-01](sprites/atlas_CC-01.png) · [CC-02](sprites/atlas_CC-02.png) · [CC-03](sprites/atlas_CC-03.png) · [CC-04](sprites/atlas_CC-04.png) · [CC-05](sprites/atlas_CC-05.png) · [CC-06](sprites/atlas_CC-06.png) · [CC-07](sprites/atlas_CC-07.png) · [CC-08](sprites/atlas_CC-08.png) · [CC-09](sprites/atlas_CC-09.png) · [CC-10](sprites/atlas_CC-10.png) · [CC-11](sprites/atlas_CC-11.png) · [CC-12](sprites/atlas_CC-12.png) · [CC-13](sprites/atlas_CC-13.png) · [CC-14](sprites/atlas_CC-14.png) · [CC-15](sprites/atlas_CC-15.png) · [CC-16](sprites/atlas_CC-16.png) · [CC-17](sprites/atlas_CC-17.png) · [CC-18](sprites/atlas_CC-18.png) · [CC-19](sprites/atlas_CC-19.png) · [CC-20](sprites/atlas_CC-20.png) · [CC-21](sprites/atlas_CC-21.png) · [CC-22](sprites/atlas_CC-22.png) · [CC-23](sprites/atlas_CC-23.png) · [CC-24](sprites/atlas_CC-24.png)

### Native portraits (IND<tribe>A<pose>)
[IND0A0](sprites/atlas_IND0A0.png) · [IND0A1](sprites/atlas_IND0A1.png) · [IND0A2](sprites/atlas_IND0A2.png) · [IND0A3](sprites/atlas_IND0A3.png) · [IND1A0](sprites/atlas_IND1A0.png) · [IND1A1](sprites/atlas_IND1A1.png) · [IND1A2](sprites/atlas_IND1A2.png) · [IND1A3](sprites/atlas_IND1A3.png) · [IND2A0](sprites/atlas_IND2A0.png) · [IND2A1](sprites/atlas_IND2A1.png) · [IND2A2](sprites/atlas_IND2A2.png) · [IND2A3](sprites/atlas_IND2A3.png) · [IND3A0](sprites/atlas_IND3A0.png) · [IND3A1](sprites/atlas_IND3A1.png) · [IND3A2](sprites/atlas_IND3A2.png) · [IND3A3](sprites/atlas_IND3A3.png) · [IND4A0](sprites/atlas_IND4A0.png) · [IND4A1](sprites/atlas_IND4A1.png) · [IND4A2](sprites/atlas_IND4A2.png) · [IND4A3](sprites/atlas_IND4A3.png) · [IND5A0](sprites/atlas_IND5A0.png) · [IND5A1](sprites/atlas_IND5A1.png) · [IND5A2](sprites/atlas_IND5A2.png) · [IND5A3](sprites/atlas_IND5A3.png) · [IND6A0](sprites/atlas_IND6A0.png) · [IND6A1](sprites/atlas_IND6A1.png) · [IND6A2](sprites/atlas_IND6A2.png) · [IND6A3](sprites/atlas_IND6A3.png) · [IND7A0](sprites/atlas_IND7A0.png) · [IND7A1](sprites/atlas_IND7A1.png) · [IND7A2](sprites/atlas_IND7A2.png) · [IND7A3](sprites/atlas_IND7A3.png)

### King (audience / win / lose)
[KING](sprites/atlas_KING.png) · [KING1](sprites/atlas_KING1.png) · [KING2](sprites/atlas_KING2.png) · [KINGLOSE](sprites/atlas_KINGLOSE.png) · [KINGWIN](sprites/atlas_KINGWIN.png)

### Nation soldiers
[DUTCH1](sprites/atlas_DUTCH1.png) · [DUTCH2](sprites/atlas_DUTCH2.png) · [ENGLND1](sprites/atlas_ENGLND1.png) · [ENGLND2](sprites/atlas_ENGLND2.png) · [FRANCE1](sprites/atlas_FRANCE1.png) · [FRANCE2](sprites/atlas_FRANCE2.png) · [SPAIN1](sprites/atlas_SPAIN1.png) · [SPAIN2](sprites/atlas_SPAIN2.png)

### Advisor portraits (MSS0..5)
[MSS0](sprites/atlas_MSS0.png) · [MSS1](sprites/atlas_MSS1.png) · [MSS2](sprites/atlas_MSS2.png) · [MSS3](sprites/atlas_MSS3.png) · [MSS4](sprites/atlas_MSS4.png) · [MSS5](sprites/atlas_MSS5.png)

### Missionary portraits (MYR0..3)
[MYR0](sprites/atlas_MYR0.png) · [MYR1](sprites/atlas_MYR1.png) · [MYR2](sprites/atlas_MYR2.png) · [MYR3](sprites/atlas_MYR3.png)

### Event woodcuts (WDCUT01..13)
[WDCUT01](sprites/atlas_WDCUT01.png) · [WDCUT02](sprites/atlas_WDCUT02.png) · [WDCUT03](sprites/atlas_WDCUT03.png) · [WDCUT04](sprites/atlas_WDCUT04.png) · [WDCUT05](sprites/atlas_WDCUT05.png) · [WDCUT06](sprites/atlas_WDCUT06.png) · [WDCUT07](sprites/atlas_WDCUT07.png) · [WDCUT08](sprites/atlas_WDCUT08.png) · [WDCUT09](sprites/atlas_WDCUT09.png) · [WDCUT10](sprites/atlas_WDCUT10.png) · [WDCUT11](sprites/atlas_WDCUT11.png) · [WDCUT12](sprites/atlas_WDCUT12.png) · [WDCUT13](sprites/atlas_WDCUT13.png)

### Score rating plates (SCORE01..24)
[SCORE01](sprites/atlas_SCORE01.png) · [SCORE02](sprites/atlas_SCORE02.png) · [SCORE03](sprites/atlas_SCORE03.png) · [SCORE04](sprites/atlas_SCORE04.png) · [SCORE05](sprites/atlas_SCORE05.png) · [SCORE06](sprites/atlas_SCORE06.png) · [SCORE07](sprites/atlas_SCORE07.png) · [SCORE08](sprites/atlas_SCORE08.png) · [SCORE09](sprites/atlas_SCORE09.png) · [SCORE10](sprites/atlas_SCORE10.png) · [SCORE11](sprites/atlas_SCORE11.png) · [SCORE12](sprites/atlas_SCORE12.png) · [SCORE13](sprites/atlas_SCORE13.png) · [SCORE14](sprites/atlas_SCORE14.png) · [SCORE15](sprites/atlas_SCORE15.png) · [SCORE16](sprites/atlas_SCORE16.png) · [SCORE17](sprites/atlas_SCORE17.png) · [SCORE18](sprites/atlas_SCORE18.png) · [SCORE19](sprites/atlas_SCORE19.png) · [SCORE20](sprites/atlas_SCORE20.png) · [SCORE21](sprites/atlas_SCORE21.png) · [SCORE22](sprites/atlas_SCORE22.png) · [SCORE23](sprites/atlas_SCORE23.png) · [SCORE24](sprites/atlas_SCORE24.png)

### Declaration cursive letters (DEC-*)
[DEC-LOWA](sprites/atlas_DEC-LOWA.png) · [DEC-LOWB](sprites/atlas_DEC-LOWB.png) · [DEC-LOWC](sprites/atlas_DEC-LOWC.png) · [DEC-LOWD](sprites/atlas_DEC-LOWD.png) · [DEC-LOWE](sprites/atlas_DEC-LOWE.png) · [DEC-LOWF](sprites/atlas_DEC-LOWF.png) · [DEC-LOWG](sprites/atlas_DEC-LOWG.png) · [DEC-LOWH](sprites/atlas_DEC-LOWH.png) · [DEC-LOWI](sprites/atlas_DEC-LOWI.png) · [DEC-LOWJ](sprites/atlas_DEC-LOWJ.png) · [DEC-LOWK](sprites/atlas_DEC-LOWK.png) · [DEC-LOWL](sprites/atlas_DEC-LOWL.png) · [DEC-LOWM](sprites/atlas_DEC-LOWM.png) · [DEC-LOWN](sprites/atlas_DEC-LOWN.png) · [DEC-LOWO](sprites/atlas_DEC-LOWO.png) · [DEC-LOWP](sprites/atlas_DEC-LOWP.png) · [DEC-LOWQ](sprites/atlas_DEC-LOWQ.png) · [DEC-LOWR](sprites/atlas_DEC-LOWR.png) · [DEC-LOWS](sprites/atlas_DEC-LOWS.png) · [DEC-LOWT](sprites/atlas_DEC-LOWT.png) · [DEC-LOWU](sprites/atlas_DEC-LOWU.png) · [DEC-LOWV](sprites/atlas_DEC-LOWV.png) · [DEC-LOWW](sprites/atlas_DEC-LOWW.png) · [DEC-LOWX](sprites/atlas_DEC-LOWX.png) · [DEC-LOWY](sprites/atlas_DEC-LOWY.png) · [DEC-LOWZ](sprites/atlas_DEC-LOWZ.png) · [DEC-SQIG](sprites/atlas_DEC-SQIG.png) · [DEC-UPPA](sprites/atlas_DEC-UPPA.png) · [DEC-UPPB](sprites/atlas_DEC-UPPB.png) · [DEC-UPPC](sprites/atlas_DEC-UPPC.png) · [DEC-UPPD](sprites/atlas_DEC-UPPD.png) · [DEC-UPPE](sprites/atlas_DEC-UPPE.png) · [DEC-UPPF](sprites/atlas_DEC-UPPF.png) · [DEC-UPPG](sprites/atlas_DEC-UPPG.png) · [DEC-UPPH](sprites/atlas_DEC-UPPH.png) · [DEC-UPPI](sprites/atlas_DEC-UPPI.png) · [DEC-UPPJ](sprites/atlas_DEC-UPPJ.png) · [DEC-UPPK](sprites/atlas_DEC-UPPK.png) · [DEC-UPPL](sprites/atlas_DEC-UPPL.png) · [DEC-UPPM](sprites/atlas_DEC-UPPM.png) · [DEC-UPPN](sprites/atlas_DEC-UPPN.png) · [DEC-UPPO](sprites/atlas_DEC-UPPO.png) · [DEC-UPPP](sprites/atlas_DEC-UPPP.png) · [DEC-UPPQ](sprites/atlas_DEC-UPPQ.png) · [DEC-UPPR](sprites/atlas_DEC-UPPR.png) · [DEC-UPPS](sprites/atlas_DEC-UPPS.png) · [DEC-UPPT](sprites/atlas_DEC-UPPT.png) · [DEC-UPPU](sprites/atlas_DEC-UPPU.png) · [DEC-UPPV](sprites/atlas_DEC-UPPV.png) · [DEC-UPPW](sprites/atlas_DEC-UPPW.png) · [DEC-UPPX](sprites/atlas_DEC-UPPX.png) · [DEC-UPPY](sprites/atlas_DEC-UPPY.png) · [DEC-UPPZ](sprites/atlas_DEC-UPPZ.png)

### Opening cinematic
[MPSLOGO](sprites/atlas_MPSLOGO.png) · [MPSNAME](sprites/atlas_MPSNAME.png) · [OPENBONK](sprites/atlas_OPENBONK.png) · [OPENCRD1](sprites/atlas_OPENCRD1.png) · [OPENCRD2](sprites/atlas_OPENCRD2.png) · [OPENCRD3](sprites/atlas_OPENCRD3.png) · [OPENFISH](sprites/atlas_OPENFISH.png) · [OPENGUY](sprites/atlas_OPENGUY.png) · [OPENLOGO](sprites/atlas_OPENLOGO.png) · [OPENMON1](sprites/atlas_OPENMON1.png) · [OPENMON2](sprites/atlas_OPENMON2.png) · [OPENMON3](sprites/atlas_OPENMON3.png) · [OPENSHIP](sprites/atlas_OPENSHIP.png) · [OPENSUN](sprites/atlas_OPENSUN.png) · [OPENTILE](sprites/atlas_OPENTILE.png) · [OPENWND1](sprites/atlas_OPENWND1.png) · [OPENWND2](sprites/atlas_OPENWND2.png)

### Closing cinematic
[CLOS-BEL](sprites/atlas_CLOS-BEL.png) · [CLOS-FWK](sprites/atlas_CLOS-FWK.png) · [CLOS-HAT](sprites/atlas_CLOS-HAT.png) · [CLOS-LDY](sprites/atlas_CLOS-LDY.png) · [CLOS-MAN](sprites/atlas_CLOS-MAN.png) · [CLOS-MIL](sprites/atlas_CLOS-MIL.png) · [CLOS-ROC](sprites/atlas_CLOS-ROC.png)

### UI chrome (frames / panels / cursor)
[CURSOR](sprites/atlas_CURSOR.png) · [NAMEPLAT](sprites/atlas_NAMEPLAT.png) · [PARCH](sprites/atlas_PARCH.png) · [WIN](sprites/atlas_WIN.png) · [WIN-FWRK](sprites/atlas_WIN-FWRK.png) · [WOODFRAM](sprites/atlas_WOODFRAM.png) · [WOODTILE](sprites/atlas_WOODTILE.png)

## Full-screen images (`pik/`)

[CCBKGD](pik/CCBKGD.png) · [CLOS-BKG](pik/CLOS-BKG.png) · [COLONY](pik/COLONY.png) · [CUSTOMIZ](pik/CUSTOMIZ.png) · [DECLARAT](pik/DECLARAT.png) · [DECOIND](pik/DECOIND.png) · [DIFFICUL](pik/DIFFICUL.png) · [EUROPE](pik/EUROPE.png) · [KINGLSS1](pik/KINGLSS1.png) · [KINGLSS2](pik/KINGLSS2.png) · [LEVN0001](pik/LEVN0001.png) · [LEVN0002](pik/LEVN0002.png) · [LEVN0003](pik/LEVN0003.png) · [LEVN0004](pik/LEVN0004.png) · [LEVN0005](pik/LEVN0005.png) · [LEVN0006](pik/LEVN0006.png) · [LEVN0007](pik/LEVN0007.png) · [LEVN0008](pik/LEVN0008.png) · [LEVN0009](pik/LEVN0009.png) · [LEVN0010](pik/LEVN0010.png) · [NATIONS](pik/NATIONS.png) · [OPENBORD](pik/OPENBORD.png) · [OPENING](pik/OPENING.png) · [OPENMENU](pik/OPENMENU.png) · [REPORT1](pik/REPORT1.png) · [REPORT2](pik/REPORT2.png) · [REPORT3](pik/REPORT3.png) · [REPORT4](pik/REPORT4.png) · [REPORT5](pik/REPORT5.png) · [REPORT6](pik/REPORT6.png) · [REPORT7](pik/REPORT7.png) · [REPORT8](pik/REPORT8.png) · [REPORT9](pik/REPORT9.png) · [WOODPAN2](pik/WOODPAN2.png) · [WOODPANL](pik/WOODPANL.png)
