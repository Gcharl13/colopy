# OPENING.EXE — RTLink overlay segment names (Phase 1)

Strings ending in `.obj` found inside the executable. Under Pocket Soft RTLink Plus these are the linker object files that became overlay segments at link time. The runtime loader uses this list to demand-load each segment when its code is called. Phase 2 will tie each entry to the segment's byte range in the overlay.

Total: **9**

| File offset | Region    | XRefs | Name         |
|-------------|-----------|------:|--------------|
| 0x0106DC | overlay   |     0 | `opening.obj` |
| 0x0106F4 | overlay   |     1 | `picture2.obj` |
| 0x01070D | overlay   |     0 | `env_1.obj` |
| 0x010723 | overlay   |     1 | `driver.obj` |
| 0x01073A | overlay   |     1 | `picture.obj` |
| 0x010752 | overlay   |     1 | `text.obj` |
| 0x010767 | overlay   |     0 | `strings.obj` |
| 0x01077F | overlay   |     6 | `stuff_5.obj` |
| 0x010797 | overlay   |     0 | `stuff_3.obj` |
