; ============================================================================
; func_00A02A_unknown
; Region   : load_image
; Bytes    : file 0x00A02A..0x00A088  (94 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A02A  55                    PUSH   bp ; STACK_PUSH
00A02B  8B EC                 MOV    bp, sp ; MOV
00A02D  8D 46 0C              LEA    ax, [bp + 0xc] ; ADDR
00A030  50                    PUSH   ax ; STACK_PUSH
00A031  8D 4E 0A              LEA    cx, [bp + 0xa] ; ADDR
00A034  51                    PUSH   cx ; STACK_PUSH
00A035  8D 56 08              LEA    dx, [bp + 8] ; ADDR
00A038  52                    PUSH   dx ; STACK_PUSH
00A039  8D 5E 06              LEA    bx, [bp + 6] ; ADDR
00A03C  53                    PUSH   bx ; STACK_PUSH
00A03D  9A 4A 00 7B 08        LCALL  0x87b, 0x4a ; LCALL
00A042  8B E5                 MOV    sp, bp ; MOV
00A044  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00A047  6A FF                 PUSH   -1 ; STACK_PUSH
00A049  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00A04C  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00A04F  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
00A052  9A 66 0D 47 0A        LCALL  0xa47, 0xd66 ; LCALL
00A057  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00A05A  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00A05D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A060  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A063  9A C0 00 7B 08        LCALL  0x87b, 0xc0 ; LCALL
00A068  8B E5                 MOV    sp, bp ; MOV
00A06A  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00A06D  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00A070  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A073  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A076  9A 34 02 7B 08        LCALL  0x87b, 0x234 ; LCALL
00A07B  8B E5                 MOV    sp, bp ; MOV
00A07D  6A FF                 PUSH   -1 ; STACK_PUSH
00A07F  6A 01                 PUSH   1 ; STACK_PUSH
00A081  9A B4 03 56 0B        LCALL  0xb56, 0x3b4 ; LCALL
00A086  C9                    LEAVE ; EPILOGUE
00A087  CB                    RETF ; RETURN
