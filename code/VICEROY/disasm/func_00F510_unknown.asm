; ============================================================================
; func_00F510_unknown
; Region   : load_image
; Bytes    : file 0x00F510..0x00F52C  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F510  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00F514  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00F517  A3 AA 83              MOV    word ptr [0x83aa], ax ; GLOBAL_LOAD
00F51A  EB 01                 JMP    0xf51d ; JUMP
00F51C  90                    NOP ; NOP
00F51D  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
00F521  74 07                 JE     0xf52a ; CJUMP
00F523  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00F526  32 E4                 XOR    ah, ah ; LOGIC
00F528  CD 10                 INT    0x10 ; SYS
00F52A  C9                    LEAVE ; EPILOGUE
00F52B  CB                    RETF ; RETURN
