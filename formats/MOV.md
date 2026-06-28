# .MOV — MicroProse Cinematic Script

A small index/script file that drives the opening cinematic. References
sprite sequences from .SS files plus audio cues from COLDIG.BIN.

**1 .MOV file in COLONIZE/**:
- `AMERICA.MOV` — 572 bytes (suspiciously small for a real video)

---

## Layout

The 572-byte size confirms this is NOT raw video data — it's a script
that **references** other assets. Inferred structure (TBD Phase CV6):

```
[header — small]
[per-frame entry:
    timestamp_ms: word
    ss_filename_id: byte
    sprite_index: byte
    audio_cue_id: byte
    duration_ms: word
]
[end-of-script marker]
```

The cinematic player in OPENING.EXE walks through these entries on a
timer, drawing each referenced sprite at its scheduled time.

---

## Round-trip

Byte-identity.

---

## Decoding plan (Phase CV6)

1. Annotate the cinematic player function in OPENING.EXE (Phase E).
2. Decode the .MOV script → `assets/movies/AMERICA/timeline.json`
   listing (frame_offset_ms, ss_filename, sprite_index, audio_cue,
   duration_ms).
3. Optionally render the cinematic as a sequence of PNG frames at
   `assets/movies/AMERICA/frames/NNNN.png` for visual verification.
