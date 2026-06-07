; ============================================================================
; func_064916_unknown
; Region   : load_image
; Bytes    : file 0x064916..0x0649A2  (140 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064916  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
06491A  57                    PUSH   di                           ; UNKNOWN
06491B  56                    PUSH   si                           ; UNKNOWN
06491C  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
06491F  26 83 7F 10 00        CMP    word ptr es:[bx + 0x10], 0   ; UNKNOWN
064924  7F 09                 JG     0x6492f                      ; UNKNOWN
064926  7C 69                 JL     0x64991                      ; UNKNOWN
064928  26 83 7F 0E 10        CMP    word ptr es:[bx + 0xe], 0x10 ; UNKNOWN
06492D  72 62                 JB     0x64991                      ; UNKNOWN
06492F  26 8B 47 0A           MOV    ax, word ptr es:[bx + 0xa]   ; UNKNOWN
064933  26 8B 57 0C           MOV    dx, word ptr es:[bx + 0xc]   ; UNKNOWN
064937  26 2B 47 0E           SUB    ax, word ptr es:[bx + 0xe]   ; UNKNOWN
06493B  26 1B 57 10           SBB    dx, word ptr es:[bx + 0x10]  ; UNKNOWN
06493F  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
064942  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
064945  26 8B 4F 02           MOV    cx, word ptr es:[bx + 2]     ; UNKNOWN
064949  26 8B 77 04           MOV    si, word ptr es:[bx + 4]     ; UNKNOWN
06494D  89 4E F8              MOV    word ptr [bp - 8], cx        ; UNKNOWN
064950  89 76 FA              MOV    word ptr [bp - 6], si        ; UNKNOWN
064953  83 C0 0F              ADD    ax, 0xf                      ; UNKNOWN
064956  83 D2 00              ADC    dx, 0                        ; UNKNOWN
064959  D1 FA                 SAR    dx, 1                        ; UNKNOWN
06495B  D1 D8                 RCR    ax, 1                        ; UNKNOWN
06495D  D1 FA                 SAR    dx, 1                        ; UNKNOWN
06495F  D1 D8                 RCR    ax, 1                        ; UNKNOWN
064961  D1 FA                 SAR    dx, 1                        ; UNKNOWN
064963  D1 D8                 RCR    ax, 1                        ; UNKNOWN
064965  D1 FA                 SAR    dx, 1                        ; UNKNOWN
064967  D1 D8                 RCR    ax, 1                        ; UNKNOWN
064969  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
06496C  B4 4A                 MOV    ah, 0x4a                     ; UNKNOWN
06496E  C4 7E F8              LES    di, ptr [bp - 8]             ; UNKNOWN
064971  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
064974  CD 21                 INT    0x21                         ; UNKNOWN
064976  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
064979  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
06497C  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
06497F  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax   ; UNKNOWN
064983  26 89 57 0C           MOV    word ptr es:[bx + 0xc], dx   ; UNKNOWN
064987  2B C0                 SUB    ax, ax                       ; UNKNOWN
064989  26 89 47 10           MOV    word ptr es:[bx + 0x10], ax  ; UNKNOWN
06498D  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax   ; UNKNOWN
064991  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
064994  26 8B 47 0A           MOV    ax, word ptr es:[bx + 0xa]   ; UNKNOWN
064998  26 8B 57 0C           MOV    dx, word ptr es:[bx + 0xc]   ; UNKNOWN
06499C  5E                    POP    si                           ; UNKNOWN
06499D  5F                    POP    di                           ; UNKNOWN
06499E  C9                    LEAVE                               ; UNKNOWN
06499F  CA 04 00              RETF   4                            ; UNKNOWN
