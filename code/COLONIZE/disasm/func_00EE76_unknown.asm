; ============================================================================
; func_00EE76_unknown
; Region   : load_image
; Bytes    : file 0x00EE76..0x00EE9E  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EE76  C8 40 03 00           ENTER  0x340, 0                     ; UNKNOWN
00EE7A  57                    PUSH   di                           ; UNKNOWN
00EE7B  56                    PUSH   si                           ; UNKNOWN
00EE7C  2B C0                 SUB    ax, ax                       ; UNKNOWN
00EE7E  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
00EE81  89 86 DC FC           MOV    word ptr [bp - 0x324], ax    ; UNKNOWN
00EE85  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
00EE88  89 86 C4 FC           MOV    word ptr [bp - 0x33c], ax    ; UNKNOWN
00EE8C  EB 77                 JMP    0xef05                       ; UNKNOWN
00EE8E  6A 20                 PUSH   0x20                         ; UNKNOWN
00EE90  53                    PUSH   bx                           ; UNKNOWN
00EE91  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
00EE96  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00EE99  89 86 C2 FC           MOV    word ptr [bp - 0x33e], ax    ; UNKNOWN
00EE9D  0B                    DB     0x0B                         ; UNKNOWN (raw)
