; ============================================================================
; func_043DF5_unknown
; Region   : load_image
; Bytes    : file 0x043DF5..0x043E55  (96 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043DF5  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
043DF9  50                    PUSH   ax                           ; UNKNOWN
043DFA  56                    PUSH   si                           ; UNKNOWN
043DFB  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
043E00  39 16 34 0B           CMP    word ptr [0xb34], dx         ; UNKNOWN
043E04  7F 49                 JG     0x43e4f                      ; UNKNOWN
043E06  C4 1E 9E C1           LES    bx, ptr [0xc19e]             ; UNKNOWN
043E0A  2B 1E 94 82           SUB    bx, word ptr [0x8294]        ; UNKNOWN
043E0E  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
043E11  2A E4                 SUB    ah, ah                       ; UNKNOWN
043E13  85 46 FC              TEST   word ptr [bp - 4], ax        ; UNKNOWN
043E16  74 04                 JE     0x43e1c                      ; UNKNOWN
043E18  83 46 FE 08           ADD    word ptr [bp - 2], 8         ; UNKNOWN
043E1C  8B 1E 9E C1           MOV    bx, word ptr [0xc19e]        ; UNKNOWN
043E20  8B 36 94 82           MOV    si, word ptr [0x8294]        ; UNKNOWN
043E24  26 8A 00              MOV    al, byte ptr es:[bx + si]    ; UNKNOWN
043E27  2A E4                 SUB    ah, ah                       ; UNKNOWN
043E29  85 46 FC              TEST   word ptr [bp - 4], ax        ; UNKNOWN
043E2C  74 04                 JE     0x43e32                      ; UNKNOWN
043E2E  83 46 FE 04           ADD    word ptr [bp - 2], 4         ; UNKNOWN
043E32  26 8A 47 FF           MOV    al, byte ptr es:[bx - 1]     ; UNKNOWN
043E36  2A E4                 SUB    ah, ah                       ; UNKNOWN
043E38  85 46 FC              TEST   word ptr [bp - 4], ax        ; UNKNOWN
043E3B  74 04                 JE     0x43e41                      ; UNKNOWN
043E3D  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
043E41  26 8A 47 01           MOV    al, byte ptr es:[bx + 1]     ; UNKNOWN
043E45  2A E4                 SUB    ah, ah                       ; UNKNOWN
043E47  85 46 FC              TEST   word ptr [bp - 4], ax        ; UNKNOWN
043E4A  74 03                 JE     0x43e4f                      ; UNKNOWN
043E4C  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
043E4F  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
043E52  5E                    POP    si                           ; UNKNOWN
043E53  C9                    LEAVE                               ; UNKNOWN
043E54  C3                    RET                                 ; UNKNOWN
