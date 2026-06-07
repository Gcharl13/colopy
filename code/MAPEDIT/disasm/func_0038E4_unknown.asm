; ============================================================================
; func_0038E4_unknown
; Region   : load_image
; Bytes    : file 0x0038E4..0x003936  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0038E4  55                    PUSH   bp ; STACK_PUSH
0038E5  8B EC                 MOV    bp, sp ; MOV
0038E7  57                    PUSH   di ; STACK_PUSH
0038E8  56                    PUSH   si ; STACK_PUSH
0038E9  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0038EC  9A 06 01 42 08        LCALL  0x842, 0x106 ; LCALL
0038F1  9A C8 01 42 08        LCALL  0x842, 0x1c8 ; LCALL
0038F6  8B DF                 MOV    bx, di ; MOV
0038F8  C1 E3 04              SHL    bx, 4 ; LOGIC
0038FB  89 87 E6 4E           MOV    word ptr [bx + 0x4ee6], ax ; MOV
0038FF  8B F3                 MOV    si, bx ; MOV
003901  9A 98 01 42 08        LCALL  0x842, 0x198 ; LCALL
003906  88 84 E8 4E           MOV    byte ptr [si + 0x4ee8], al ; MOV
00390A  9A 98 01 42 08        LCALL  0x842, 0x198 ; LCALL
00390F  88 84 E9 4E           MOV    byte ptr [si + 0x4ee9], al ; MOV
003913  9A 98 01 42 08        LCALL  0x842, 0x198 ; LCALL
003918  88 84 EA 4E           MOV    byte ptr [si + 0x4eea], al ; MOV
00391C  2B F6                 SUB    si, si ; ARITH
00391E  9A 98 01 42 08        LCALL  0x842, 0x198 ; LCALL
003923  8B DF                 MOV    bx, di ; MOV
003925  C1 E3 04              SHL    bx, 4 ; LOGIC
003928  88 80 ED 4E           MOV    byte ptr [bx + si + 0x4eed], al ; MOV
00392C  46                    INC    si ; ARITH
00392D  83 FE 09              CMP    si, 9 ; CMP
003930  7C EC                 JL     0x391e ; CJUMP
003932  5E                    POP    si ; STACK_POP
003933  5F                    POP    di ; STACK_POP
003934  C9                    LEAVE ; EPILOGUE
003935  CB                    RETF ; RETURN
