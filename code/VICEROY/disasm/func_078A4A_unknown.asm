; ============================================================================
; func_078A4A_unknown
; Region   : overlay
; Bytes    : file 0x078A4A..0x078A77  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078A4A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
078A4E  52                    PUSH   dx ; STACK_PUSH
078A4F  50                    PUSH   ax ; STACK_PUSH
078A50  D1 FA                 SAR    dx, 1 ; LOGIC
078A52  D1 D8                 RCR    ax, 1 ; LOGIC
078A54  D1 FA                 SAR    dx, 1 ; LOGIC
078A56  D1 D8                 RCR    ax, 1 ; LOGIC
078A58  D1 FA                 SAR    dx, 1 ; LOGIC
078A5A  D1 D8                 RCR    ax, 1 ; LOGIC
078A5C  D1 FA                 SAR    dx, 1 ; LOGIC
078A5E  D1 D8                 RCR    ax, 1 ; LOGIC
078A60  40                    INC    ax ; ARITH
078A61  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
078A64  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
078A67  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
078A6A  B4 4A                 MOV    ah, 0x4a ; CONST_LOAD
078A6C  CD 21                 INT    0x21 ; SYS
078A6E  D0 D8                 RCR    al, 1 ; LOGIC
078A70  98                    CWDE ; ARITH
078A71  8A C4                 MOV    al, ah ; MOV
078A73  C9                    LEAVE ; EPILOGUE
078A74  CA 04 00              RETF   4 ; RETURN
