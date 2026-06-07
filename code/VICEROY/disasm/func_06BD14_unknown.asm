; ============================================================================
; func_06BD14_unknown
; Region   : overlay
; Bytes    : file 0x06BD14..0x06BD69  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06BD14  C8 01 00 00           ENTER  1, 0 ; PROLOGUE
06BD18  49                    DEC    cx ; ARITH
06BD19  27                    DAA ; ARITH
06BD1A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD1C  8E 00                 MOV    es, word ptr [bx + si] ; MOV
06BD1E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD20  82 23 00              AND    byte ptr [bp + di], 0 ; LOGIC
06BD23  00 5E 23              ADD    byte ptr [bp + 0x23], bl ; ARITH
06BD26  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD28  6C                    INSB   byte ptr es:[di], dx ; IO
06BD29  06                    PUSH   es ; STACK_PUSH
06BD2A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD2C  B5 0B                 MOV    ch, 0xb ; CONST_LOAD
06BD2E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD30  03 13                 ADD    dx, word ptr [bp + di] ; ARITH
06BD32  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD34  60                    PUSHAW                              ; UNKNOWN
06BD35  1D 00 00              SBB    ax, 0 ; ARITH
06BD38  A6                    CMPSB  byte ptr [si], byte ptr es:[di] ; STR
06BD39  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
06BD3B  00 B1 01 00           ADD    byte ptr [bx + di + 1], dh ; ARITH
06BD3F  00 37                 ADD    byte ptr [bx], dh ; ARITH
06BD41  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD43  00 98 04 00           ADD    byte ptr [bx + si + 4], bl ; ARITH
06BD47  00 E7                 ADD    bh, ah ; ARITH
06BD49  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
06BD4B  00 17                 ADD    byte ptr [bx], dl ; ARITH
06BD4D  0E                    PUSH   cs ; STACK_PUSH
06BD4E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD50  2F                    DAS ; ARITH
06BD51  0D 00 00              OR     ax, 0 ; LOGIC
06BD54  34 0B                 XOR    al, 0xb ; LOGIC
06BD56  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD58  64 10 00              ADC    byte ptr fs:[bx + si], al ; ARITH
06BD5B  00 61 1E              ADD    byte ptr [bx + di + 0x1e], ah ; ARITH
06BD5E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD60  5D                    POP    bp ; STACK_POP
06BD61  2F                    DAS ; ARITH
06BD62  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD64  76 03                 JBE    0x6bd69 ; CJUMP
06BD66  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06BD68  CB                    RETF ; RETURN
