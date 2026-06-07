; ============================================================================
; func_026FF2_unknown
; Region   : overlay
; Bytes    : file 0x026FF2..0x02701B  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026FF2  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
026FF6  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
026FF9  8A 87 60 02           MOV    al, byte ptr [bx + 0x260] ; MOV
026FFD  98                    CWDE ; ARITH
026FFE  0B C0                 OR     ax, ax ; LOGIC
027000  74 17                 JE     0x27019 ; CJUMP
027002  FF 36 44 08           PUSH   word ptr [0x844] ; PUSH_GLOBAL
027006  FF 36 42 08           PUSH   word ptr [0x842] ; PUSH_GLOBAL
02700A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
02700D  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
027011  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
027014  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
027019  C9                    LEAVE ; EPILOGUE
02701A  CB                    RETF ; RETURN
