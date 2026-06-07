; ============================================================================
; func_05E7E0_unknown
; Region   : overlay
; Bytes    : file 0x05E7E0..0x05E887  (167 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05E7E0  C8 03 00 00           ENTER  3, 0 ; PROLOGUE
05E7E4  6D                    INSW   word ptr es:[di], dx ; IO
05E7E5  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
05E7E7  00 6A 09              ADD    byte ptr [bp + si + 9], ch ; ARITH
05E7EA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E7EC  23 08                 AND    cx, word ptr [bx + si] ; LOGIC
05E7EE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E7F0  7C 07                 JL     0x5e7f9 ; CJUMP
05E7F2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E7F4  98                    CWDE ; ARITH
05E7F5  0E                    PUSH   cs ; STACK_PUSH
05E7F6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E7F8  F6 0D 00              TEST   byte ptr [di], 0 ; LOGIC
05E7FB  00 54 0D              ADD    byte ptr [si + 0xd], dl ; ARITH
05E7FE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E800  B3 0C                 MOV    bl, 0xc ; CONST_LOAD
05E802  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E804  10 0C                 ADC    byte ptr [si], cl ; ARITH
05E806  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E808  6F                    OUTSW  dx, word ptr [si] ; IO
05E809  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
05E80B  00 2A                 ADD    byte ptr [bp + si], ch ; ARITH
05E80D  10 00                 ADC    byte ptr [bx + si], al ; ARITH
05E80F  00 90 0F 00           ADD    byte ptr [bx + si + 0xf], dl ; ARITH
05E813  00 FA                 ADD    dl, bh ; ARITH
05E815  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
05E817  00 C4                 ADD    ah, al ; ARITH
05E819  06                    PUSH   es ; STACK_PUSH
05E81A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E81C  BB 05 00              MOV    bx, 5 ; MOV
05E81F  00 1A                 ADD    byte ptr [bp + si], bl ; ARITH
05E821  05 00 00              ADD    ax, 0 ; ARITH
05E824  77 04                 JA     0x5e82a ; CJUMP
05E826  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E828  D5 03                 AAD    3 ; ARITH
05E82A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E82C  7A 0A                 JP     0x5e838 ; CJUMP
05E82E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E830  77 09                 JA     0x5e83b ; CJUMP
05E832  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E834  30 08                 XOR    byte ptr [bx + si], cl ; LOGIC
05E836  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E838  89 07                 MOV    word ptr [bx], ax ; MOV
05E83A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E83C  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
05E83D  0E                    PUSH   cs ; STACK_PUSH
05E83E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E840  03 0E 00 00           ADD    cx, word ptr [0] ; ARITH
05E844  61                    POPAW                               ; UNKNOWN
05E845  0D 00 00              OR     ax, 0 ; LOGIC
05E848  C0 0C 00              ROR    byte ptr [si], 0 ; LOGIC
05E84B  00 1D                 ADD    byte ptr [di], bl ; ARITH
05E84D  0C 00                 OR     al, 0 ; LOGIC
05E84F  00 7C 0B              ADD    byte ptr [si + 0xb], bh ; ARITH
05E852  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E854  22 00                 AND    al, byte ptr [bx + si] ; LOGIC
05E856  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E858  3B 03                 CMP    ax, word ptr [bp + di] ; CMP
05E85A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E85C  76 02                 JBE    0x5e860 ; CJUMP
05E85E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E860  BA 01 00              MOV    dx, 1 ; MOV
05E863  00 05                 ADD    byte ptr [di], al ; ARITH
05E865  07                    POP    es ; STACK_POP
05E866  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E868  FC                    CLD ; FLAG
05E869  05 00 00              ADD    ax, 0 ; ARITH
05E86C  5B                    POP    bx ; STACK_POP
05E86D  05 00 00              ADD    ax, 0 ; ARITH
05E870  B8 04 00              MOV    ax, 4 ; MOV
05E873  00 16 04 00           ADD    byte ptr [4], dl ; ARITH
05E877  00 BB 0A 00           ADD    byte ptr [bp + di + 0xa], bh ; ARITH
05E87B  00 B8 09 00           ADD    byte ptr [bx + si + 9], bh ; ARITH
05E87F  00 71 08              ADD    byte ptr [bx + di + 8], dh ; ARITH
05E882  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05E884  CA 07 00              RETF   7 ; RETURN
