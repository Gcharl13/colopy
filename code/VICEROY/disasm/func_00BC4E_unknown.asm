; ============================================================================
; func_00BC4E_unknown
; Region   : load_image
; Bytes    : file 0x00BC4E..0x00BC80  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BC4E  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00BC52  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00BC55  C1 E0 02              SHL    ax, 2 ; LOGIC
00BC58  FF 36 66 03           PUSH   word ptr [0x366] ; PUSH_GLOBAL
00BC5C  FF 36 64 03           PUSH   word ptr [0x364] ; PUSH_GLOBAL
00BC60  FF 36 62 03           PUSH   word ptr [0x362] ; PUSH_GLOBAL
00BC64  FF 36 60 03           PUSH   word ptr [0x360] ; PUSH_GLOBAL
00BC68  6A 04                 PUSH   4 ; STACK_PUSH
00BC6A  8A 4E 0A              MOV    cl, byte ptr [bp + 0xa] ; LOCAL_LOAD
00BC6D  51                    PUSH   cx ; STACK_PUSH
00BC6E  8B D0                 MOV    dx, ax ; MOV
00BC70  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00BC73  C1 E0 02              SHL    ax, 2 ; LOGIC
00BC76  BB 04 00              MOV    bx, 4 ; MOV
00BC79  9A 0A 00 9E 0B        LCALL  0xb9e, 0xa ; LCALL
00BC7E  C9                    LEAVE ; EPILOGUE
00BC7F  CB                    RETF ; RETURN
