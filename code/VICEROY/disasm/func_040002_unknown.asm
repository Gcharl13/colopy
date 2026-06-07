; ============================================================================
; func_040002_unknown
; Region   : overlay
; Bytes    : file 0x040002..0x04002C  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040002  55                    PUSH   bp ; STACK_PUSH
040003  8B EC                 MOV    bp, sp ; MOV
040005  C7 06 72 53 00 00     MOV    word ptr [0x5372], 0 ; GLOBAL_LOAD
04000B  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
04000E  A2 74 53              MOV    byte ptr [0x5374], al ; GLOBAL_LOAD
040011  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
040014  A2 77 53              MOV    byte ptr [0x5377], al ; GLOBAL_LOAD
040017  A2 78 53              MOV    byte ptr [0x5378], al ; GLOBAL_LOAD
04001A  2A C0                 SUB    al, al ; ARITH
04001C  A2 79 53              MOV    byte ptr [0x5379], al ; GLOBAL_LOAD
04001F  A2 76 53              MOV    byte ptr [0x5376], al ; GLOBAL_LOAD
040022  A2 7D 53              MOV    byte ptr [0x537d], al ; GLOBAL_LOAD
040025  C6 06 7B 53 01        MOV    byte ptr [0x537b], 1 ; GLOBAL_LOAD
04002A  C9                    LEAVE ; EPILOGUE
04002B  CB                    RETF ; RETURN
