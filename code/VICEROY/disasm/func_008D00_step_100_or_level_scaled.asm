; ============================================================================
; func_008D00_step_100_or_level_scaled
; Region   : load_image
; Bytes    : file 0x008D00..0x008D26  (38 bytes)
; Purpose  : Returns 100 by default, or `(struct.byte[+0x95] + 1) * 100` if that byte is non-zero. The struct is *(0x8542) (current-context struct). Pattern is a "step / increment value" scaled by a level/stage counter at +0x95: stage 0 → 100, stage 1 → 200, stage 2 → 300, etc. Likely used as a per-turn step delta in some accumulating calculation (score, treasury, attribute drift).
; Args     : (none — purely reads the global struct)
; Returns  : AX = 100 if *(0x8542)+0x95 == 0; otherwise AX = (byte+1)*100
; Callers  : TBD
; Callees  : (none — leaf accessor)
; Verified : Boundary verified: ENTER 2 / LEAVE / RETF, 38 bytes. The IMUL by 0x64 (=100) is the signature constant.
; Source   : Pattern: zero-check + level-scaled-by-100 — a per-stage step value.
; ============================================================================

008D00  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame for [bp-2] = result
008D04  C7 46 FE 64 00        MOV    word ptr [bp - 2], 0x64      ; result = 100 (default)
008D09  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
008D0D  80 BF 95 00 00        CMP    byte ptr [bx + 0x95], 0      ; struct.byte[+0x95] == 0?
008D12  74 0D                 JE     0x8d21                       ; if zero, keep default 100
008D14  8A 87 95 00           MOV    al, byte ptr [bx + 0x95]     ; AL = struct.byte[+0x95] (level / stage counter)
008D18  2A E4                 SUB    ah, ah                       ; zero-extend AL → AX (unsigned byte → word)
008D1A  40                    INC    ax                           ; AX = byte+1 (so stage 0 would be 1, 1→2, ...)
008D1B  6B C0 64              IMUL   ax, ax, 0x64                 ; AX = (byte+1) * 100
008D1E  89 46 FE              MOV    word ptr [bp - 2], ax        ; result = scaled value
008D21  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; AX = result
008D24  C9                    LEAVE                               ; teardown
008D25  CB                    RETF                                ; far-return: AX = 100 or (byte+1)*100
