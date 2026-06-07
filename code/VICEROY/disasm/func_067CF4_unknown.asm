; ============================================================================
; func_067CF4_unknown
; Region   : overlay
; Bytes    : file 0x067CF4..0x067D54  (96 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067CF4  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
067CF8  50                    PUSH   ax ; STACK_PUSH
067CF9  56                    PUSH   si ; STACK_PUSH
067CFA  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
067CFF  39 16 84 01           CMP    word ptr [0x184], dx ; CMP
067D03  7F 49                 JG     0x67d4e ; CJUMP
067D05  C4 1E 94 A5           LES    bx, ptr [0xa594] ; MOV_FAR
067D09  2B 1E 48 85           SUB    bx, word ptr [0x8548] ; ARITH
067D0D  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
067D10  2A E4                 SUB    ah, ah ; ARITH
067D12  85 46 FC              TEST   word ptr [bp - 4], ax ; LOGIC
067D15  74 04                 JE     0x67d1b ; CJUMP
067D17  83 46 FE 08           ADD    word ptr [bp - 2], 8 ; ARITH
067D1B  8B 1E 94 A5           MOV    bx, word ptr [0xa594] ; GLOBAL_LOAD
067D1F  8B 36 48 85           MOV    si, word ptr [0x8548] ; GLOBAL_LOAD
067D23  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
067D26  2A E4                 SUB    ah, ah ; ARITH
067D28  85 46 FC              TEST   word ptr [bp - 4], ax ; LOGIC
067D2B  74 04                 JE     0x67d31 ; CJUMP
067D2D  83 46 FE 04           ADD    word ptr [bp - 2], 4 ; ARITH
067D31  26 8A 47 FF           MOV    al, byte ptr es:[bx - 1] ; MOV
067D35  2A E4                 SUB    ah, ah ; ARITH
067D37  85 46 FC              TEST   word ptr [bp - 4], ax ; LOGIC
067D3A  74 04                 JE     0x67d40 ; CJUMP
067D3C  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
067D40  26 8A 47 01           MOV    al, byte ptr es:[bx + 1] ; MOV
067D44  2A E4                 SUB    ah, ah ; ARITH
067D46  85 46 FC              TEST   word ptr [bp - 4], ax ; LOGIC
067D49  74 03                 JE     0x67d4e ; CJUMP
067D4B  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
067D4E  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
067D51  5E                    POP    si ; STACK_POP
067D52  C9                    LEAVE ; EPILOGUE
067D53  C3                    RET ; RETURN
