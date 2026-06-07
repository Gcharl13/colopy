; ============================================================================
; func_078CB2_unknown
; Region   : overlay
; Bytes    : file 0x078CB2..0x078D3E  (140 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078CB2  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
078CB6  57                    PUSH   di ; STACK_PUSH
078CB7  56                    PUSH   si ; STACK_PUSH
078CB8  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
078CBB  26 83 7F 10 00        CMP    word ptr es:[bx + 0x10], 0 ; CMP
078CC0  7F 09                 JG     0x78ccb ; CJUMP
078CC2  7C 69                 JL     0x78d2d ; CJUMP
078CC4  26 83 7F 0E 10        CMP    word ptr es:[bx + 0xe], 0x10 ; CMP
078CC9  72 62                 JB     0x78d2d ; CJUMP
078CCB  26 8B 47 0A           MOV    ax, word ptr es:[bx + 0xa] ; MOV
078CCF  26 8B 57 0C           MOV    dx, word ptr es:[bx + 0xc] ; MOV
078CD3  26 2B 47 0E           SUB    ax, word ptr es:[bx + 0xe] ; ARITH
078CD7  26 1B 57 10           SBB    dx, word ptr es:[bx + 0x10] ; ARITH
078CDB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
078CDE  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
078CE1  26 8B 4F 02           MOV    cx, word ptr es:[bx + 2] ; MOV
078CE5  26 8B 77 04           MOV    si, word ptr es:[bx + 4] ; MOV
078CE9  89 4E F8              MOV    word ptr [bp - 8], cx ; LOCAL_STORE
078CEC  89 76 FA              MOV    word ptr [bp - 6], si ; LOCAL_STORE
078CEF  05 0F 00              ADD    ax, 0xf ; ARITH
078CF2  83 D2 00              ADC    dx, 0 ; ARITH
078CF5  D1 FA                 SAR    dx, 1 ; LOGIC
078CF7  D1 D8                 RCR    ax, 1 ; LOGIC
078CF9  D1 FA                 SAR    dx, 1 ; LOGIC
078CFB  D1 D8                 RCR    ax, 1 ; LOGIC
078CFD  D1 FA                 SAR    dx, 1 ; LOGIC
078CFF  D1 D8                 RCR    ax, 1 ; LOGIC
078D01  D1 FA                 SAR    dx, 1 ; LOGIC
078D03  D1 D8                 RCR    ax, 1 ; LOGIC
078D05  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
078D08  B4 4A                 MOV    ah, 0x4a ; CONST_LOAD
078D0A  C4 7E F8              LES    di, ptr [bp - 8] ; MOV_FAR
078D0D  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
078D10  CD 21                 INT    0x21 ; SYS
078D12  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
078D15  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
078D18  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
078D1B  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
078D1F  26 89 57 0C           MOV    word ptr es:[bx + 0xc], dx ; MOV
078D23  2B C0                 SUB    ax, ax ; ARITH
078D25  26 89 47 10           MOV    word ptr es:[bx + 0x10], ax ; MOV
078D29  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
078D2D  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
078D30  26 8B 47 0A           MOV    ax, word ptr es:[bx + 0xa] ; MOV
078D34  26 8B 57 0C           MOV    dx, word ptr es:[bx + 0xc] ; MOV
078D38  5E                    POP    si ; STACK_POP
078D39  5F                    POP    di ; STACK_POP
078D3A  C9                    LEAVE ; EPILOGUE
078D3B  CA 04 00              RETF   4 ; RETURN
