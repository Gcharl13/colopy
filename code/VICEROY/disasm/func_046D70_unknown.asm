; ============================================================================
; func_046D70_unknown
; Region   : overlay
; Bytes    : file 0x046D70..0x046DE0  (112 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046D70  C8 39 00 00           ENTER  0x39, 0 ; PROLOGUE
046D74  22 48 00              AND    cl, byte ptr [bx + si] ; LOGIC
046D77  00 99 16 00           ADD    byte ptr [bx + di + 0x16], bl ; ARITH
046D7B  00 98 1F 00           ADD    byte ptr [bx + si + 0x1f], bl ; ARITH
046D7F  00 E4                 ADD    ah, ah ; ARITH
046D81  15 00 00              ADC    ax, 0 ; ARITH
046D84  92                    XCHG   dx, ax ; MOV
046D85  28 00                 SUB    byte ptr [bx + si], al ; ARITH
046D87  00 81 28 00           ADD    byte ptr [bx + di + 0x28], al ; ARITH
046D8B  00 70 28              ADD    byte ptr [bx + si + 0x28], dh ; ARITH
046D8E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046D90  A6                    CMPSB  byte ptr [si], byte ptr es:[di] ; STR
046D91  36 00 00              ADD    byte ptr ss:[bx + si], al ; ARITH
046D94  95                    XCHG   bp, ax ; MOV
046D95  36 00 00              ADD    byte ptr ss:[bx + si], al ; ARITH
046D98  84 36 00 00           TEST   byte ptr [0], dh ; LOGIC
046D9C  83 3C 00              CMP    word ptr [si], 0 ; CMP
046D9F  00 C1                 ADD    cl, al ; ARITH
046DA1  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DA3  00 08                 ADD    byte ptr [bx + si], cl ; ARITH
046DA5  1C 00                 SBB    al, 0 ; ARITH
046DA7  00 0A                 ADD    byte ptr [bp + si], cl ; ARITH
046DA9  19 00                 SBB    word ptr [bx + si], ax ; ARITH
046DAB  00 DF                 ADD    bh, bl ; ARITH
046DAD  38 00                 CMP    byte ptr [bx + si], al ; CMP
046DAF  00 01                 ADD    byte ptr [bx + di], al ; ARITH
046DB1  46                    INC    si ; ARITH
046DB2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DB4  60                    PUSHAW                              ; UNKNOWN
046DB5  13 00                 ADC    ax, word ptr [bx + si] ; ARITH
046DB7  00 B7 11 00           ADD    byte ptr [bx + 0x11], dh ; ARITH
046DBB  00 1A                 ADD    byte ptr [bp + si], bl ; ARITH
046DBD  28 00                 SUB    byte ptr [bx + si], al ; ARITH
046DBF  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DC1  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DC3  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DC5  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DC7  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DC9  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DCB  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DCD  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DCF  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DD1  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DD3  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DD5  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DD7  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DD9  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DDB  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DDD  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046DDF  00                    DB     0x00 ; DATA_BYTE
