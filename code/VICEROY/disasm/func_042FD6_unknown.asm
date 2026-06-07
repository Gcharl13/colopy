; ============================================================================
; func_042FD6_unknown
; Region   : overlay
; Bytes    : file 0x042FD6..0x04304C  (118 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042FD6  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
042FDA  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
042FDE  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
042FE2  98                    CWDE ; ARITH
042FE3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
042FE6  8A 8F 46 31           MOV    cl, byte ptr [bx + 0x3146] ; MOV
042FEA  2A ED                 SUB    ch, ch ; ARITH
042FEC  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
042FEF  3D 1C 00              CMP    ax, 0x1c ; CMP
042FF2  75 05                 JNE    0x42ff9 ; CJUMP
042FF4  C7 46 FE 13 00        MOV    word ptr [bp - 2], 0x13 ; LOCAL_STORE
042FF9  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
042FFC  C1 E3 03              SHL    bx, 3 ; LOGIC
042FFF  8B 87 A2 8E           MOV    ax, word ptr [bx - 0x715e] ; MOV
043003  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
043006  0B C9                 OR     cx, cx ; LOGIC
043008  74 1A                 JE     0x43024 ; CJUMP
04300A  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
04300E  75 14                 JNE    0x43024 ; CJUMP
043010  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
043013  9A 9A 0C 1F 18        LCALL  0x181f, 0xc9a ; THUNK -> 0x05EB:0x0002 (thunk @file 0x01B28A type B) overlay @file 0x026FF2
043018  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04301B  0B C0                 OR     ax, ax ; LOGIC
04301D  75 05                 JNE    0x43024 ; CJUMP
04301F  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
043024  83 7E FC 01           CMP    word ptr [bp - 4], 1 ; CMP
043028  74 06                 JE     0x43030 ; CJUMP
04302A  83 7E FC 04           CMP    word ptr [bp - 4], 4 ; CMP
04302E  75 0C                 JNE    0x4303c ; CJUMP
043030  83 7E FE 15           CMP    word ptr [bp - 2], 0x15 ; CMP
043034  75 06                 JNE    0x4303c ; CJUMP
043036  A1 3C 2E              MOV    ax, word ptr [0x2e3c] ; GLOBAL_LOAD
043039  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
04303C  83 7E FC 05           CMP    word ptr [bp - 4], 5 ; CMP
043040  75 0C                 JNE    0x4304e ; CJUMP
043042  83 7E FE 16           CMP    word ptr [bp - 2], 0x16 ; CMP
043046  75 06                 JNE    0x4304e ; CJUMP
043048  A1 C2 2D              MOV    ax, word ptr [0x2dc2] ; GLOBAL_LOAD
04304B  89                    DB     0x89 ; DATA_BYTE
