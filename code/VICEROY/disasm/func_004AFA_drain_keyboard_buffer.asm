; ============================================================================
; func_004AFA_drain_keyboard_buffer
; Region   : load_image
; Bytes    : file 0x004AFA..0x004B16  (28 bytes)
; Purpose  : Discard every pending keystroke. Loops: kbhit; if AX=0, exit; else getch to consume it, then kbhit again. Used at points where the game wants to ignore keystrokes that arrived during a long-running operation (animation, file load) — common in DOS games to prevent 'stuck' input from advancing dialogs unintentionally.
; Args     : (none)
; Returns  : (no useful return value)
; Callers  : TBD
; Callees  : kbhit at 0xD272 (LCALL 0xAE7:0x02), getch at 0xD286 (LCALL 0xAE7:0x16)
; Verified : boundary verified: PUSH BP/MOV BP,SP at 0x4AFA; LEAVE/RETF at 0x4B14-0x4B15. Inner loop kbhit/getch/kbhit until kbhit returns 0.
; Source   : manually identified — discovered as a caller of kbhit and getch via callgraph.json
; ============================================================================

004AFA  55                    PUSH   bp                           ; standard frame prologue
004AFB  8B EC                 MOV    bp, sp                       ; BP = SP
004AFD  9A 02 00 E7 0A        LCALL  0xae7, 2                     ; call kbhit at 0xD272 — AX=0 means buffer is empty
004B02  0B C0                 OR     ax, ax                       ; check for "no keys"
004B04  74 0E                 JE     0x4b14                       ; if buffer was already empty, skip straight to LEAVE
004B06  9A 16 00 E7 0A        LCALL  0xae7, 0x16                  ; call getch at 0xD286 — consume one key (we discard the return value)
004B0B  9A 02 00 E7 0A        LCALL  0xae7, 2                     ; call kbhit again — AX=0 means buffer is now empty
004B10  0B C0                 OR     ax, ax                       ; test for "more keys?"
004B12  75 F2                 JNE    0x4b06                       ; if more pending, loop back and consume the next one
004B14  C9                    LEAVE                               ; tear down the frame
004B15  CB                    RETF                                ; far-return
