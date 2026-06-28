# .GIF — Standard CompuServe GIF

Standard GIF87a format files. The only one in COLONIZE/ is
`INSTALL.GIF` — the install-screen splash image.

**1 .GIF file in COLONIZE/**:
- `INSTALL.GIF` — 125,667 bytes

---

## Layout

Per CompuServe GIF87a spec (well-documented elsewhere). Magic bytes
`GIF87a` at file offset 0.

Used only by INSTALL.EXE during installation; no in-game reference.

---

## Round-trip

Byte-identity. Standard PIL/Pillow can decode/encode if needed.
