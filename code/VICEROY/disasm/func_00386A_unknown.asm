; ============================================================================
; func_00386A_unknown
; Region   : load_image
; Bytes    : file 0x00386A..0x0038CE  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00386A  C8 46 00 00           ENTER  0x46, 0 ; PROLOGUE
00386E  53                    PUSH   bx ; STACK_PUSH
00386F  52                    PUSH   dx ; STACK_PUSH
003870  50                    PUSH   ax ; STACK_PUSH
003871  57                    PUSH   di ; STACK_PUSH
003872  56                    PUSH   si ; STACK_PUSH
003873  8B F0                 MOV    si, ax ; MOV
003875  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0 ; LOCAL_STORE
00387A  80 66 B6 DF           AND    byte ptr [bp - 0x4a], 0xdf ; LOGIC
00387E  8B 56 B6              MOV    dx, word ptr [bp - 0x4a] ; LOCAL_LOAD
003881  83 E2 40              AND    dx, 0x40 ; LOGIC
003884  8D 5E D6              LEA    bx, [bp - 0x2a] ; ADDR
003887  0E                    PUSH   cs ; STACK_PUSH
003888  E8 33 FF              CALL   0x37be ; CALL_NEAR
00388B  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00388E  F6 46 B6 80           TEST   byte ptr [bp - 0x4a], 0x80 ; LOGIC
003892  74 18                 JE     0x38ac ; CJUMP
003894  8B C6                 MOV    ax, si ; MOV
003896  9A 02 00 27 04        LCALL  0x427, 2 ; LCALL
00389B  9A 4A 00 27 04        LCALL  0x427, 0x4a ; LCALL
0038A0  0B C0                 OR     ax, ax ; LOGIC
0038A2  7C 08                 JL     0x38ac ; CJUMP
0038A4  C7 46 E4 01 00        MOV    word ptr [bp - 0x1c], 1 ; LOCAL_STORE
0038A9  EB 06                 JMP    0x38b1 ; JUMP
0038AB  90                    NOP ; NOP
0038AC  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0 ; LOCAL_STORE
0038B1  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
0038B6  6B 5E D6 1C           IMUL   bx, word ptr [bp - 0x2a], 0x1c ; ARITH
0038BA  89 5E C0              MOV    word ptr [bp - 0x40], bx ; LOCAL_STORE
0038BD  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
0038C1  8B C8                 MOV    cx, ax ; MOV
0038C3  2A E4                 SUB    ah, ah ; ARITH
0038C5  8B F0                 MOV    si, ax ; MOV
0038C7  80 F9 0D              CMP    cl, 0xd ; CMP
0038CA  73 03                 JAE    0x38cf ; CJUMP
0038CC  E9                    DB     0xE9 ; DATA_BYTE
0038CD  CF                    DB     0xCF ; DATA_BYTE
