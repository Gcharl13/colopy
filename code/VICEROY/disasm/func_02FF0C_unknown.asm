; ============================================================================
; func_02FF0C_unknown
; Region   : overlay
; Bytes    : file 0x02FF0C..0x02FF7B  (111 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02FF0C  C8 26 00 00           ENTER  0x26, 0 ; PROLOGUE
02FF10  96                    XCHG   si, ax ; MOV
02FF11  26 00 00              ADD    byte ptr es:[bx + si], al ; ARITH
02FF14  62 26 00 00           BOUND  sp, dword ptr [0] ; SYS
02FF18  46                    INC    si ; ARITH
02FF19  26 00 00              ADD    byte ptr es:[bx + si], al ; ARITH
02FF1C  0A 26 00 00           OR     ah, byte ptr [0] ; LOGIC
02FF20  74 40                 JE     0x2ff62 ; CJUMP
02FF22  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF24  57                    PUSH   di ; STACK_PUSH
02FF25  43                    INC    bx ; ARITH
02FF26  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF28  14 43                 ADC    al, 0x43 ; ARITH
02FF2A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF2C  E9 42 00              JMP    0x2ff71 ; JUMP
02FF2F  00 B1 49 00           ADD    byte ptr [bx + di + 0x49], dh ; ARITH
02FF33  00 6A 4C              ADD    byte ptr [bp + si + 0x4c], ch ; ARITH
02FF36  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF38  2D 4C 00              SUB    ax, 0x4c ; ARITH
02FF3B  00 0A                 ADD    byte ptr [bp + si], cl ; ARITH
02FF3D  4A                    DEC    dx ; ARITH
02FF3E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF40  E0 55                 LOOPNE 0x2ff97 ; CJUMP
02FF42  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF44  52                    PUSH   dx ; STACK_PUSH
02FF45  2D 00 00              SUB    ax, 0 ; ARITH
02FF48  FC                    CLD ; FLAG
02FF49  3A 00                 CMP    al, byte ptr [bx + si] ; CMP
02FF4B  00 4E 5D              ADD    byte ptr [bp + 0x5d], cl ; ARITH
02FF4E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF50  FD                    STD ; FLAG
02FF51  20 00                 AND    byte ptr [bx + si], al ; LOGIC
02FF53  00 B9 24 00           ADD    byte ptr [bx + di + 0x24], bh ; ARITH
02FF57  00 A6 29 00           ADD    byte ptr [bp + 0x29], ah ; ARITH
02FF5B  00 51 05              ADD    byte ptr [bx + di + 5], dl ; ARITH
02FF5E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF60  BA 04 00              MOV    dx, 4 ; MOV
02FF63  00 B1 2E 00           ADD    byte ptr [bx + di + 0x2e], dh ; ARITH
02FF67  00 7B 2E              ADD    byte ptr [bp + di + 0x2e], bh ; ARITH
02FF6A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF6C  D0 2D                 SHR    byte ptr [di], 1 ; LOGIC
02FF6E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF70  B6 41                 MOV    dh, 0x41 ; CONST_LOAD
02FF72  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF74  6A 4D                 PUSH   0x4d ; PUSH_CONST
02FF76  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02FF78  CA 5F 00              RETF   0x5f ; RETURN
