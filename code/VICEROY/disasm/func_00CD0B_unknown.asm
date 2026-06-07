; ============================================================================
; func_00CD0B_unknown
; Region   : load_image
; Bytes    : file 0x00CD0B..0x00CD4E  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CD0B  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00CD0F  33 DB                 XOR    bx, bx ; LOGIC
00CD11  83 3E F8 92 00        CMP    word ptr [0x92f8], 0 ; CMP
00CD16  74 0C                 JE     0xcd24 ; CJUMP
00CD18  8B 0E FC 92           MOV    cx, word ptr [0x92fc] ; GLOBAL_LOAD
00CD1C  8B 16 FE 92           MOV    dx, word ptr [0x92fe] ; GLOBAL_LOAD
00CD20  33 DB                 XOR    bx, bx ; LOGIC
00CD22  51                    PUSH   cx ; STACK_PUSH
00CD23  52                    PUSH   dx ; STACK_PUSH
00CD24  83 3E AC 83 00        CMP    word ptr [0x83ac], 0 ; CMP
00CD29  74 08                 JE     0xcd33 ; CJUMP
00CD2B  B8 03 00              MOV    ax, 3 ; MOV
00CD2E  CD 33                 INT    0x33 ; SYS
00CD30  E8 B8 FF              CALL   0xcceb ; CALL_NEAR
00CD33  83 3E F8 92 00        CMP    word ptr [0x92f8], 0 ; CMP
00CD38  74 02                 JE     0xcd3c ; CJUMP
00CD3A  5A                    POP    dx ; STACK_POP
00CD3B  59                    POP    cx ; STACK_POP
00CD3C  53                    PUSH   bx ; STACK_PUSH
00CD3D  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00CD40  89 0F                 MOV    word ptr [bx], cx ; MOV
00CD42  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00CD45  89 17                 MOV    word ptr [bx], dx ; MOV
00CD47  58                    POP    ax ; STACK_POP
00CD48  0B 06 FA 92           OR     ax, word ptr [0x92fa] ; LOGIC
00CD4C  C9                    LEAVE ; EPILOGUE
00CD4D  CB                    RETF ; RETURN
