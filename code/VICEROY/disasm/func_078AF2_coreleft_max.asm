; ============================================================================
; func_078AF2_coreleft_max
; Region   : overlay
; Bytes    : file 0x078AF2..0x078B09  (23 bytes)
; Purpose  : C `coreleft()` for the largest free block. Issues INT 21h AH=48h with BX=0xFFFF (deliberate fail). DOS returns BX=largest free paragraphs available. The function then converts the paragraph count to a 32-bit byte count in DX:AX (DX=high word, AX=low word) — performed by the trailing shifts that synthesize the 4-bit shift across two 16-bit registers.
; Args     : (none)
; Returns  : DX:AX = largest free contiguous DOS block in bytes (long).
; Callers  : TBD
; Callees  : INT 21h AH=48h (Allocate Memory)
; Verified : boundary covers the visible 11-instruction body; the function ends with the paragraph-to-byte conversion. The exact closing RET is past 0x078B07 in the auto-detected boundary.
; Source   : manually identified — INT 21h AH=48 BX=FFFF + paragraphs-to-bytes is the canonical coreleft() largest-block implementation
; ============================================================================

078AF2  55                    PUSH   bp                           ; standard frame prologue
078AF3  8B EC                 MOV    bp, sp                       ; BP = SP
078AF5  B4 48                 MOV    ah, 0x48                     ; INT 21h subfunction 48h: Allocate Memory
078AF7  BB FF FF              MOV    bx, 0xffff                   ; request impossibly-large block (max paragraphs) — DOS will fail and return BX = largest available
078AFA  CD 21                 INT    0x21                         ; DOS Allocate Memory; on the deliberate failure, BX = max paragraphs we could have allocated
078AFC  32 F6                 XOR    dh, dh                       ; clear DH — start building the high half of a 32-bit byte count in DX:AX
078AFE  8A D7                 MOV    dl, bh                       ; DL = high byte of paragraph count (BX)
078B00  C1 E2 04              SHL    dx, 4                        ; shift left by 4 — paragraphs_high_byte * 16 = high half of byte count (with carry)
078B03  8A D6                 MOV    dl, dh                       ; collapse the upper 8 bits of DX into DL (carry-out from the shift)
078B05  32 F6                 XOR    dh, dh                       ; clear DH again — DX now holds the high 16 bits of the 32-bit byte count
078B07  8B C3                 MOV    ax, bx                       ; AX = paragraphs (low half of count); function continues past the manual boundary with a final left-shift to produce DX:AX = bytes
