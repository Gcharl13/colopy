# Boot-path audit (ROUTE_B Phase 6.3) — protection/doc-check byte-proof

**Verdict: VICEROY.EXE has NO in-game copy-protection, manual/doc-check, or
disk-check gate.** The entry→title path is pure hardware/runtime init. Recorded
here as the byte-proof Phase 6.3 calls for.

## Entry → title path (no gate)

`boot/entry.c` (byte-traced):

1. `entry_point` (MZ entry) → far-call `system_init` (`110D:0727` = file
   `0x13BF7`, 1368 bytes).
2. `system_init` = boot-time **DOS version / EMS / XMS / heap** initialization
   (+ `dos_version_check_stub`). No prompt, no lookup, no disk read.
3. → title screen.

There is no branch in this path that gates on a manual page/word, a password,
a serial, or a disk/CD presence check.

## Byte-proof of absence

- **Strings**: a scan of `re_work/strings.json` for `manual | copy.?protect |
  password | serial | "what year" | "look up" | "page N" | paragraph | disk |
  cd.?key | registration` returns **0 hits**. A manual-lookup or password gate
  always carries its prompt strings; none exist.
- **No `INT 13h`** (BIOS disk) usage anywhere in the disassembly (`re_work/disasm`
  has 0 references) — no low-level disk/copy check.
- `system_init` touches only DOS/EMS/XMS/heap (cited in `boot/entry.c`); the
  decoded body has no protection branch.

This matches the DOS Colonization reality: any protection was install-time
(`INSTALL.EXE`), not in the game executable. Nothing to port — the modern
`main_modern.c` boot (dgroup init → data load → title) is faithful to the
original's gate-free entry→title flow.

## Related Phase-6 flags (honored in the port)

- **Autoload slot `[0x104]`** — honored: title-screen boot-intro gate
  (`g_boot_flag_104`, `title_screen.c`) and the autoload quick-path
  (`overlay_0745F0_077A6A.c` @asm `0x075A14`).
- **Scenario flag `[0x828]`** — honored: `overlay_024342_027B62.c` @asm
  `0x0268F8` (`cmp [0x828],0`).
