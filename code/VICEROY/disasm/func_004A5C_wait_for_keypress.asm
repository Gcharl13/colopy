; ============================================================================
; func_004A5C_wait_for_keypress
; Region   : load_image
; Bytes    : file 0x004A5C..0x004A80  (36 bytes)
; Purpose  : Block until the user presses a key, calling a periodic-refresh helper between polls. The loop body is: (1) call helper at 0x029F:0x00F6 (cursor blink / status-bar refresh / screensaver-defeat — to be confirmed when that function is annotated); (2) call kbhit (file 0xD272) — if no key pending, loop back; (3) call getch (file 0xD286) to consume the key; (4) return AX = the key value. Used wherever the game wants 'press any key to continue' input — title screen, end-of-turn prompt, message-box dismiss.
; Args     : (none)
; Returns  : AX = the key value returned by getch (ASCII in AL, scan code in AH for ext keys; AH cleared for ordinary ASCII).
; Callers  : TBD (xrefs not yet captured by the call graph; reached from overlay code)
; Callees  : 0x029F:0x00F6 (per-iteration helper — to be identified), kbhit at 0xD272 (LCALL 0xAE7:0x02), getch at 0xD286 (LCALL 0xAE7:0x16)
; Verified : Boundary: PUSH BP / MOV BP, SP at 0x4A5C; LEAVE / RETF at 0x4A7E-0x4A7F. Loop structure cleanly visible.
; Source   : manually identified — discovered as a caller of kbhit and getch via callgraph.json
; ============================================================================

004A5C  55                    PUSH   bp                           ; standard frame prologue
004A5D  8B EC                 MOV    bp, sp                       ; BP = SP
004A5F  56                    PUSH   si                           ; save SI (callee-preserved per the C calling convention)
004A60  2B F6                 SUB    si, si                       ; SI = 0 — accumulator for the key value (will exit loop when nonzero)
004A62  9A F6 00 9F 02        LCALL  0x29f, 0xf6                  ; per-iteration refresh helper (file 0x4EE6) — likely cursor blink / status-bar tick
004A67  9A 02 00 E7 0A        LCALL  0xae7, 2                     ; call kbhit at 0xD272 (segment 0xAE7, offset 0x02) — AX=0 if no key, AX=key if pending
004A6C  0B C0                 OR     ax, ax                       ; test "did kbhit see a key?"
004A6E  74 07                 JE     0x4a77                       ; no key: jump past getch — loop will retest SI and repoll
004A70  9A 16 00 E7 0A        LCALL  0xae7, 0x16                  ; call getch at 0xD286 (segment 0xAE7, offset 0x16) — consumes the key, returns AX = key value
004A75  8B F0                 MOV    si, ax                       ; SI = the key value (will exit loop unless this is 0)
004A77  0B F6                 OR     si, si                       ; SI = key (0 means we still don't have one)
004A79  74 E7                 JE     0x4a62                       ; if SI=0, repeat the poll
004A7B  8B C6                 MOV    ax, si                       ; AX = the consumed key value
004A7D  5E                    POP    si                           ; restore caller's SI
004A7E  C9                    LEAVE                               ; tear down the frame (MOV SP,BP; POP BP)
004A7F  CB                    RETF                                ; far-return to caller
