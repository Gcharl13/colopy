; ============================================================================
; func_01180C_unknown
; Region   : load_image
; Bytes    : file 0x01180C..0x01183A  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01180C  55                    PUSH   bp ; STACK_PUSH
01180D  8B EC                 MOV    bp, sp ; MOV
01180F  57                    PUSH   di ; STACK_PUSH
011810  56                    PUSH   si ; STACK_PUSH
011811  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
011814  33 C0                 XOR    ax, ax ; LOGIC
011816  99                    CDQ ; ARITH
011817  33 DB                 XOR    bx, bx ; LOGIC
011819  AC                    LODSB  al, byte ptr [si] ; STR
01181A  3C 20                 CMP    al, 0x20 ; CMP
01181C  74 FB                 JE     0x11819 ; CJUMP
01181E  3C 09                 CMP    al, 9 ; CMP
011820  74 F7                 JE     0x11819 ; CJUMP
011822  50                    PUSH   ax ; STACK_PUSH
011823  3C 2D                 CMP    al, 0x2d ; CMP
011825  74 04                 JE     0x1182b ; CJUMP
011827  3C 2B                 CMP    al, 0x2b ; CMP
011829  75 01                 JNE    0x1182c ; CJUMP
01182B  AC                    LODSB  al, byte ptr [si] ; STR
01182C  3C 39                 CMP    al, 0x39 ; CMP
01182E  77 1F                 JA     0x1184f ; CJUMP
011830  2C 30                 SUB    al, 0x30 ; ARITH
011832  72 1B                 JB     0x1184f ; CJUMP
011834  D1 E3                 SHL    bx, 1 ; LOGIC
011836  D1 D2                 RCL    dx, 1 ; LOGIC
011838  8B CB                 MOV    cx, bx ; MOV
