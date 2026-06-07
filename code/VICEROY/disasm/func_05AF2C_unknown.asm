; ============================================================================
; func_05AF2C_unknown
; Region   : overlay
; Bytes    : file 0x05AF2C..0x05AF70  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05AF2C  C8 19 00 00           ENTER  0x19, 0 ; PROLOGUE
05AF30  6C                    INSB   byte ptr es:[di], dx ; IO
05AF31  27                    DAA ; ARITH
05AF32  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF34  42                    INC    dx ; ARITH
05AF35  33 00                 XOR    ax, word ptr [bx + si] ; LOGIC
05AF37  00 92 35 00           ADD    byte ptr [bp + si + 0x35], dl ; ARITH
05AF3B  00 9F 27 00           ADD    byte ptr [bx + 0x27], bl ; ARITH
05AF3F  00 05                 ADD    byte ptr [di], al ; ARITH
05AF41  2C 00                 SUB    al, 0 ; ARITH
05AF43  00 9E 12 00           ADD    byte ptr [bp + 0x12], bl ; ARITH
05AF47  00 77 2D              ADD    byte ptr [bx + 0x2d], dh ; ARITH
05AF4A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF4C  7A 2C                 JP     0x5af7a ; CJUMP
05AF4E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF50  9D                    POPF ; STACK_POP
05AF51  1C 00                 SBB    al, 0 ; ARITH
05AF53  00 DD                 ADD    ch, bl ; ARITH
05AF55  19 00                 SBB    word ptr [bx + si], ax ; ARITH
05AF57  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF59  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF5B  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF5D  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF5F  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF61  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF63  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF65  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF67  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF69  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF6B  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF6D  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF6F  00                    DB     0x00 ; DATA_BYTE
