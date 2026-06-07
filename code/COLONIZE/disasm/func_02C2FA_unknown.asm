; ============================================================================
; func_02C2FA_unknown
; Region   : load_image
; Bytes    : file 0x02C2FA..0x02C326  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02C2FA  55                    PUSH   bp                           ; UNKNOWN
02C2FB  8B EC                 MOV    bp, sp                       ; UNKNOWN
02C2FD  6B 46 06 4C           IMUL   ax, word ptr [bp + 6], 0x4c  ; UNKNOWN
02C301  83 C0 0A              ADD    ax, 0xa                      ; UNKNOWN
02C304  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02C307  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
02C309  83 7E 08 01           CMP    word ptr [bp + 8], 1         ; UNKNOWN
02C30D  7E 05                 JLE    0x2c314                      ; UNKNOWN
02C30F  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02C312  EB 02                 JMP    0x2c316                      ; UNKNOWN
02C314  2B C0                 SUB    ax, ax                       ; UNKNOWN
02C316  6B 4E 08 3C           IMUL   cx, word ptr [bp + 8], 0x3c  ; UNKNOWN
02C31A  03 C1                 ADD    ax, cx                       ; UNKNOWN
02C31C  83 C0 10              ADD    ax, 0x10                     ; UNKNOWN
02C31F  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
02C322  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
02C324  C9                    LEAVE                               ; UNKNOWN
02C325  CB                    RETF                                ; UNKNOWN
