; ============================================================================
; func_070FF8_unknown
; Region   : overlay
; Bytes    : file 0x070FF8..0x07105C  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

070FF8  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
070FFC  50                    PUSH   ax ; STACK_PUSH
070FFD  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
071002  83 3E 5A 01 00        CMP    word ptr [0x15a], 0 ; CMP
071007  74 0F                 JE     0x71018 ; CJUMP
071009  C7 06 80 01 B4 2E     MOV    word ptr [0x180], 0x2eb4 ; GLOBAL_LOAD
07100F  C7 06 82 01 00 00     MOV    word ptr [0x182], 0 ; GLOBAL_LOAD
071015  EB 10                 JMP    0x71027 ; JUMP
071017  90                    NOP ; NOP
071018  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
07101B  F7 2E 3A 85           IMUL   word ptr [0x853a] ; ARITH
07101F  99                    CDQ ; ARITH
071020  A3 80 01              MOV    word ptr [0x180], ax ; GLOBAL_LOAD
071023  89 16 82 01           MOV    word ptr [0x182], dx ; GLOBAL_LOAD
071027  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
07102B  74 0C                 JE     0x71039 ; CJUMP
07102D  C7 06 80 01 E0 2E     MOV    word ptr [0x180], 0x2ee0 ; GLOBAL_LOAD
071033  C7 06 82 01 00 00     MOV    word ptr [0x182], 0 ; GLOBAL_LOAD
071039  C7 06 50 85 F0 00     MOV    word ptr [0x8550], 0xf0 ; GLOBAL_LOAD
07103F  C7 06 52 85 C0 00     MOV    word ptr [0x8552], 0xc0 ; GLOBAL_LOAD
071045  A1 80 01              MOV    ax, word ptr [0x180] ; GLOBAL_LOAD
071048  8B 16 82 01           MOV    dx, word ptr [0x182] ; GLOBAL_LOAD
07104C  9A 9A 02 1F 18        LCALL  0x181f, 0x29a ; THUNK -> 0x0000:0x01A0 (thunk @file 0x01A88A type A) overlay @file 0x025AA0
071051  A3 5C 01              MOV    word ptr [0x15c], ax ; GLOBAL_LOAD
071054  89 16 5E 01           MOV    word ptr [0x15e], dx ; GLOBAL_LOAD
071058  8B C2                 MOV    ax, dx ; MOV
07105A  0B                    DB     0x0B ; DATA_BYTE
07105B  06                    DB     0x06 ; DATA_BYTE
