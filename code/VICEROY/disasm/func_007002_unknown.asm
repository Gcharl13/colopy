; ============================================================================
; func_007002_unknown
; Region   : load_image
; Bytes    : file 0x007002..0x00701C  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007002  55                    PUSH   bp ; STACK_PUSH
007003  8B EC                 MOV    bp, sp ; MOV
007005  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
007008  0B DB                 OR     bx, bx ; LOGIC
00700A  7C 0E                 JL     0x701a ; CJUMP
00700C  8A 4E 08              MOV    cl, byte ptr [bp + 8] ; LOCAL_LOAD
00700F  B0 10                 MOV    al, 0x10 ; CONST_LOAD
007011  D2 E0                 SHL    al, cl ; LOGIC
007013  6B DB 1C              IMUL   bx, bx, 0x1c ; ARITH
007016  08 87 47 31           OR     byte ptr [bx + 0x3147], al ; LOGIC
00701A  C9                    LEAVE ; EPILOGUE
00701B  CB                    RETF ; RETURN
