; ============================================================================
; func_069156_unknown
; Region   : overlay
; Bytes    : file 0x069156..0x0691A4  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069156  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
06915A  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06915D  B9 18 00              MOV    cx, 0x18 ; CONST_LOAD
069160  99                    CDQ ; ARITH
069161  F7 F9                 IDIV   cx ; ARITH
069163  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
069166  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
069169  99                    CDQ ; ARITH
06916A  F7 F9                 IDIV   cx ; ARITH
06916C  2B 06 AC A5           SUB    ax, word ptr [0xa5ac] ; ARITH
069170  78 05                 JS     0x69177 ; CJUMP
069172  3D 02 00              CMP    ax, 2 ; CMP
069175  7E 0B                 JLE    0x69182 ; CJUMP
069177  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
06917A  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
06917D  89 07                 MOV    word ptr [bx], ax ; MOV
06917F  EB 1C                 JMP    0x6919d ; JUMP
069181  90                    NOP ; NOP
069182  6B C0 64              IMUL   ax, ax, 0x64 ; ARITH
069185  05 05 00              ADD    ax, 5 ; ARITH
069188  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
06918B  89 07                 MOV    word ptr [bx], ax ; MOV
06918D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
069190  8B C8                 MOV    cx, ax ; MOV
069192  D1 E0                 SHL    ax, 1 ; LOGIC
069194  03 C1                 ADD    ax, cx ; ARITH
069196  D1 E0                 SHL    ax, 1 ; LOGIC
069198  03 C1                 ADD    ax, cx ; ARITH
06919A  05 19 00              ADD    ax, 0x19 ; ARITH
06919D  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
0691A0  89 07                 MOV    word ptr [bx], ax ; MOV
0691A2  C9                    LEAVE ; EPILOGUE
0691A3  CB                    RETF ; RETURN
