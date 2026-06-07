; ============================================================================
; func_05AC34_unknown
; Region   : overlay
; Bytes    : file 0x05AC34..0x05AC8D  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05AC34  C8 2E 00 00           ENTER  0x2e, 0 ; PROLOGUE
05AC38  48                    DEC    ax ; ARITH
05AC39  1C 00                 SBB    al, 0 ; ARITH
05AC3B  00 F5                 ADD    ch, dh ; ARITH
05AC3D  27                    DAA ; ARITH
05AC3E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AC40  6E                    OUTSB  dx, byte ptr [si] ; IO
05AC41  11 00                 ADC    word ptr [bx + si], ax ; ARITH
05AC43  00 DF                 ADD    bh, bl ; ARITH
05AC45  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AC47  00 5E 1E              ADD    byte ptr [bp + 0x1e], bl ; ARITH
05AC4A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AC4C  AF                    SCASW  ax, word ptr es:[di] ; STR
05AC4D  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
05AC4F  00 5B 02              ADD    byte ptr [bp + di + 2], bl ; ARITH
05AC52  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AC54  39 26 00 00           CMP    word ptr [0], sp ; CMP
05AC58  4F                    DEC    di ; ARITH
05AC59  05 00 00              ADD    ax, 0 ; ARITH
05AC5C  F1                    INT1                                ; UNKNOWN
05AC5D  0C 00                 OR     al, 0 ; LOGIC
05AC5F  00 A3 19 00           ADD    byte ptr [bp + di + 0x19], ah ; ARITH
05AC63  00 38                 ADD    byte ptr [bx + si], bh ; ARITH
05AC65  31 00                 XOR    word ptr [bx + si], ax ; LOGIC
05AC67  00 50 07              ADD    byte ptr [bx + si + 7], dl ; ARITH
05AC6A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AC6C  02 07                 ADD    al, byte ptr [bx] ; ARITH
05AC6E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AC70  E5 06                 IN     ax, 6 ; IO
05AC72  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AC74  C1 06 00 00 A5        ROL    word ptr [0], 0xa5 ; LOGIC
05AC79  05 00 00              ADD    ax, 0 ; ARITH
05AC7C  8F 05                 POP    word ptr [di] ; STACK_POP
05AC7E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AC80  15 0A 00              ADC    ax, 0xa ; ARITH
05AC83  00 F8                 ADD    al, bh ; ARITH
05AC85  09 00                 OR     word ptr [bx + si], ax ; LOGIC
05AC87  00 E2                 ADD    dl, ah ; ARITH
05AC89  09 00                 OR     word ptr [bx + si], ax ; LOGIC
05AC8B  00 CF                 ADD    bh, cl ; ARITH
