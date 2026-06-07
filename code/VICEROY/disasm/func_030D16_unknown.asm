; ============================================================================
; func_030D16_unknown
; Region   : overlay
; Bytes    : file 0x030D16..0x030D6C  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030D16  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
030D1A  C7 06 2A 9E 00 00     MOV    word ptr [0x9e2a], 0 ; GLOBAL_LOAD
030D20  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
030D23  2D 14 00              SUB    ax, 0x14 ; ARITH
030D26  8B D0                 MOV    dx, ax ; MOV
030D28  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
030D2D  EB 1E                 JMP    0x30d4d ; JUMP
030D2F  90                    NOP ; NOP
030D30  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
030D33  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
030D38  72 07                 JB     0x30d41 ; CJUMP
030D3A  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
030D3F  76 04                 JBE    0x30d45 ; CJUMP
030D41  FF 06 2A 9E           INC    word ptr [0x9e2a] ; ARITH
030D45  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
030D48  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
030D4D  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
030D50  0B C0                 OR     ax, ax ; LOGIC
030D52  7D DC                 JGE    0x30d30 ; CJUMP
030D54  83 3E 2A 9E 00        CMP    word ptr [0x9e2a], 0 ; CMP
030D59  74 0F                 JE     0x30d6a ; CJUMP
030D5B  A1 2A 9E              MOV    ax, word ptr [0x9e2a] ; GLOBAL_LOAD
030D5E  39 06 2C 9E           CMP    word ptr [0x9e2c], ax ; CMP
030D62  7C 06                 JL     0x30d6a ; CJUMP
030D64  C7 06 2C 9E 00 00     MOV    word ptr [0x9e2c], 0 ; GLOBAL_LOAD
030D6A  C9                    LEAVE ; EPILOGUE
030D6B  CB                    RETF ; RETURN
