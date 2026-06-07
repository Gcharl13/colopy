; ============================================================================
; func_0254C0_unknown
; Region   : overlay
; Bytes    : file 0x0254C0..0x0255A5  (229 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0254C0  C8 1C 00 00           ENTER  0x1c, 0 ; PROLOGUE
0254C4  B3 22                 MOV    bl, 0x22 ; CONST_LOAD
0254C6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0254C8  9A 28 00 00 46        LCALL  0x4600, 0x28 ; LCALL
0254CD  28 00                 SUB    byte ptr [bx + si], al ; ARITH
0254CF  00 27                 ADD    byte ptr [bx], ah ; ARITH
0254D1  2B 00                 SUB    ax, word ptr [bx + si] ; ARITH
0254D3  00 0A                 ADD    byte ptr [bp + si], cl ; ARITH
0254D5  2D 00 00              SUB    ax, 0 ; ARITH
0254D8  8D 2C                 LEA    bp, [si] ; ADDR
0254DA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0254DC  33 49 00              XOR    cx, word ptr [bx + di] ; LOGIC
0254DF  00 52 46              ADD    byte ptr [bp + si + 0x46], dl ; ARITH
0254E2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0254E4  86 61 00              XCHG   byte ptr [bx + di], ah ; MOV
0254E7  00 79 60              ADD    byte ptr [bx + di + 0x60], bh ; ARITH
0254EA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0254EC  55                    PUSH   bp ; STACK_PUSH
0254ED  07                    POP    es ; STACK_POP
0254EE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0254F0  30 1C                 XOR    byte ptr [si], bl ; LOGIC
0254F2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0254F4  BE 1B 00              MOV    si, 0x1b ; CONST_LOAD
0254F7  00 FC                 ADD    ah, bh ; ARITH
0254F9  23 00                 AND    ax, word ptr [bx + si] ; LOGIC
0254FB  00 DE                 ADD    dh, bl ; ARITH
0254FD  39 00                 CMP    word ptr [bx + si], ax ; CMP
0254FF  00 87 3C 00           ADD    byte ptr [bx + 0x3c], al ; ARITH
025503  00 7A 52              ADD    byte ptr [bp + si + 0x52], bh ; ARITH
025506  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025508  D3 57 00              RCL    word ptr [bx], cl ; LOGIC
02550B  00 7F 5B              ADD    byte ptr [bx + 0x5b], bh ; ARITH
02550E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025510  F6 5A 00              NEG    byte ptr [bp + si] ; ARITH
025513  00 9C 08 00           ADD    byte ptr [si + 8], bl ; ARITH
025517  00 06 4A 00           ADD    byte ptr [0x4a], al ; ARITH
02551B  00 5E 64              ADD    byte ptr [bp + 0x64], bl ; ARITH
02551E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025520  E9 6D 00              JMP    0x25590 ; JUMP
025523  00 5F 6F              ADD    byte ptr [bx + 0x6f], bl ; ARITH
025526  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025528  F3 6E                 REP OUTSB dx, byte ptr [si] ; STR
02552A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02552C  15 2F 00              ADC    ax, 0x2f ; ARITH
02552F  00 C1                 ADD    cl, al ; ARITH
025531  2E 00 00              ADD    byte ptr cs:[bx + si], al ; ARITH
025534  7D 4D                 JGE    0x25583 ; CJUMP
025536  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025538  52                    PUSH   dx ; STACK_PUSH
025539  4D                    DEC    bp ; ARITH
02553A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02553C  4A                    DEC    dx ; ARITH
02553D  4C                    DEC    sp ; ARITH
02553E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025540  F3 4B                 DEC    bx ; ARITH
025542  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025544  96                    XCHG   si, ax ; MOV
025545  4B                    DEC    bx ; ARITH
025546  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025548  AC                    LODSB  al, byte ptr [si] ; STR
025549  4F                    DEC    di ; ARITH
02554A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02554C  F3 4D                 DEC    bp ; ARITH
02554E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025550  CC                    INT3 ; SYS
025551  51                    PUSH   cx ; STACK_PUSH
025552  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025554  A1 51 00              MOV    ax, word ptr [0x51] ; GLOBAL_LOAD
025557  00 59 15              ADD    byte ptr [bx + di + 0x15], bl ; ARITH
02555A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02555C  0C 14                 OR     al, 0x14 ; LOGIC
02555E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025560  03 45 00              ADD    ax, word ptr [di] ; ARITH
025563  00 C9                 ADD    cl, cl ; ARITH
025565  06                    PUSH   es ; STACK_PUSH
025566  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025568  DE 09                 FIMUL  word ptr [bx + di]           ; UNKNOWN
02556A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02556C  E0 07                 LOOPNE 0x25575 ; CJUMP
02556E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025570  0C 36                 OR     al, 0x36 ; LOGIC
025572  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025574  04 4D                 ADD    al, 0x4d ; ARITH
025576  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025578  04 51                 ADD    al, 0x51 ; ARITH
02557A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02557C  99                    CDQ ; ARITH
02557D  4E                    DEC    si ; ARITH
02557E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025580  D6                    SALC                                ; UNKNOWN
025581  54                    PUSH   sp ; STACK_PUSH
025582  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025584  BB 54 00              MOV    bx, 0x54 ; CONST_LOAD
025587  00 F7                 ADD    bh, dh ; ARITH
025589  55                    PUSH   bp ; STACK_PUSH
02558A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02558C  EF                    OUT    dx, ax ; IO
02558D  59                    POP    cx ; STACK_POP
02558E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025590  BE 59 00              MOV    si, 0x59 ; CONST_LOAD
025593  00 30                 ADD    byte ptr [bx + si], dh ; ARITH
025595  61                    POPAW                               ; UNKNOWN
025596  00 00                 ADD    byte ptr [bx + si], al ; ARITH
025598  FE                    DB     0xFE ; DATA_BYTE
025599  64                    DB     0x64 ; DATA_BYTE
02559A  00                    DB     0x00 ; DATA_BYTE
02559B  00                    DB     0x00 ; DATA_BYTE
02559C  B8                    DB     0xB8 ; DATA_BYTE
02559D  0D                    DB     0x0D ; DATA_BYTE
02559E  00                    DB     0x00 ; DATA_BYTE
02559F  00                    DB     0x00 ; DATA_BYTE
0255A0  49                    DB     0x49 ; DATA_BYTE
0255A1  0F                    DB     0x0F ; DATA_BYTE
0255A2  00                    DB     0x00 ; DATA_BYTE
0255A3  00                    DB     0x00 ; DATA_BYTE
0255A4  CF                    DB     0xCF ; DATA_BYTE
