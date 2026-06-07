; ============================================================================
; func_015428_unknown
; Region   : load_image
; Bytes    : file 0x015428..0x015466  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015428  55                    PUSH   bp ; STACK_PUSH
015429  8B EC                 MOV    bp, sp ; MOV
01542B  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
01542E  57                    PUSH   di ; STACK_PUSH
01542F  56                    PUSH   si ; STACK_PUSH
015430  BE CE 46              MOV    si, 0x46ce ; CONST_LOAD
015433  56                    PUSH   si ; STACK_PUSH
015434  E8 65 0F              CALL   0x1639c ; CALL_NEAR
015437  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
01543A  8B F8                 MOV    di, ax ; MOV
01543C  8D 46 08              LEA    ax, [bp + 8] ; ADDR
01543F  50                    PUSH   ax ; STACK_PUSH
015440  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
015443  B8 CE 46              MOV    ax, 0x46ce ; CONST_LOAD
015446  50                    PUSH   ax ; STACK_PUSH
015447  9A A6 16 88 13        LCALL  0x1388, 0x16a6 ; LCALL
01544C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
01544F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
015452  B8 CE 46              MOV    ax, 0x46ce ; CONST_LOAD
015455  50                    PUSH   ax ; STACK_PUSH
015456  57                    PUSH   di ; STACK_PUSH
015457  E8 B5 0F              CALL   0x1640f ; CALL_NEAR
01545A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
01545D  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
015460  5E                    POP    si ; STACK_POP
015461  5F                    POP    di ; STACK_POP
015462  8B E5                 MOV    sp, bp ; MOV
015464  5D                    POP    bp ; STACK_POP
015465  CB                    RETF ; RETURN
