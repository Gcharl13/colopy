# CLOSING.EXE — RTLink overlay segment names (Phase 1)

Strings ending in `.obj` found inside the executable. Under Pocket Soft RTLink Plus these are the linker object files that became overlay segments at link time. The runtime loader uses this list to demand-load each segment when its code is called. Phase 2 will tie each entry to the segment's byte range in the overlay.

Total: **6**

| File offset | Region    | XRefs | Name         |
|-------------|-----------|------:|--------------|
| 0x00F546 | overlay   |     0 | `closing.obj` |
| 0x00F55E | overlay   |     0 | `picture2.obj` |
| 0x00F577 | overlay   |     0 | `env_1.obj` |
| 0x00F58D | overlay   |     0 | `driver.obj` |
| 0x00F5A4 | overlay   |     0 | `picture.obj` |
| 0x00F619 | overlay   |     0 | `error_1.obj` |
