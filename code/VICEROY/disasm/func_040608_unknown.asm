; ============================================================================
; func_040608_unknown
; Region   : overlay
; Bytes    : file 0x040608..0x040656  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "USEDUPTOOLS"  (auto-named via string xrefs)
; ============================================================================

040608  55                    PUSH   bp ; STACK_PUSH
040609  8B EC                 MOV    bp, sp ; MOV
04060B  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04060F  80 AF 59 31 14        SUB    byte ptr [bx + 0x3159], 0x14 ; ARITH
040614  80 BF 59 31 14        CMP    byte ptr [bx + 0x3159], 0x14 ; CMP
040619  73 39                 JAE    0x40654 ; CJUMP
04061B  2A C0                 SUB    al, al ; ARITH
04061D  88 87 59 31           MOV    byte ptr [bx + 0x3159], al ; MOV
040621  88 87 46 31           MOV    byte ptr [bx + 0x3146], al ; MOV
040625  80 BF 5B 31 18        CMP    byte ptr [bx + 0x315b], 0x18 ; CMP
04062A  75 05                 JNE    0x40631 ; CJUMP
04062C  C6 87 46 31 03        MOV    byte ptr [bx + 0x3146], 3 ; MOV
040631  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040635  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
040639  24 0F                 AND    al, 0xf ; LOGIC
04063B  3C 04                 CMP    al, 4 ; CMP
04063D  73 15                 JAE    0x40654 ; CJUMP
04063F  2A E4                 SUB    ah, ah ; ARITH
040641  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
040644  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah ; CMP
040648  75 0A                 JNE    0x40654 ; CJUMP
04064A  6A 03                 PUSH   3 ; STACK_PUSH
04064C  68 5A 14              PUSH   0x145a                       ; STRING: "USEDUPTOOLS"
04064F  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
040654  C9                    LEAVE ; EPILOGUE
040655  CB                    RETF ; RETURN
