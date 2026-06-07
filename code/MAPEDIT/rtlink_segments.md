# MAPEDIT.EXE — RTLink overlay segment names (Phase 1)

Strings ending in `.obj` found inside the executable. Under Pocket Soft RTLink Plus these are the linker object files that became overlay segments at link time. The runtime loader uses this list to demand-load each segment when its code is called. Phase 2 will tie each entry to the segment's byte range in the overlay.

Total: **12**

| File offset | Region    | XRefs | Name         |
|-------------|-----------|------:|--------------|
| 0x01BE1E | overlay   |     3 | `mapedit.obj` |
| 0x01BE36 | overlay   |     1 | `env_1.obj` |
| 0x01BE4C | overlay   |     0 | `map.obj` |
| 0x01BE8D | overlay   |     7 | `popup.obj` |
| 0x01BEE3 | overlay   |     0 | `map_2.obj` |
| 0x01BEF9 | overlay   |     0 | `map_5.obj` |
| 0x01BF0F | overlay   |     0 | `write.obj` |
| 0x01BF25 | overlay   |     0 | `vicemisc.obj` |
| 0x01BF3E | overlay   |     0 | `terrain.obj` |
| 0x01BF56 | overlay   |     3 | `compass.obj` |
| 0x01BF6E | overlay   |     0 | `map_6.obj` |
| 0x01BFB0 | overlay   |     0 | `me_mini.obj` |
