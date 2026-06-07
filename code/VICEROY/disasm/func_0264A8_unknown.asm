; ============================================================================
; func_0264A8_unknown
; Region   : overlay
; Bytes    : file 0x0264A8..0x026580  (216 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0264A8  C8 20 00 00           ENTER  0x20, 0 ; PROLOGUE
0264AC  56                    PUSH   si ; STACK_PUSH
0264AD  A0 36 03              MOV    al, byte ptr [0x336] ; GLOBAL_LOAD
0264B0  2A E4                 SUB    ah, ah ; ARITH
0264B2  A3 70 00              MOV    word ptr [0x70], ax ; GLOBAL_LOAD
0264B5  B8 18 00              MOV    ax, 0x18 ; CONST_LOAD
0264B8  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
0264BB  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
0264BE  A0 35 08              MOV    al, byte ptr [0x835] ; GLOBAL_LOAD
0264C1  2A E4                 SUB    ah, ah ; ARITH
0264C3  50                    PUSH   ax ; STACK_PUSH
0264C4  6A 78                 PUSH   0x78 ; PUSH_CONST
0264C6  6A 78                 PUSH   0x78 ; PUSH_CONST
0264C8  6A 08                 PUSH   8 ; STACK_PUSH
0264CA  B8 C8 00              MOV    ax, 0xc8 ; CONST_LOAD
0264CD  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
0264D0  50                    PUSH   ax ; STACK_PUSH
0264D1  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0264D5  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0264D9  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0264DD  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0264E1  9A 06 05 1F 18        LCALL  0x181f, 0x506 ; THUNK -> 0x02DD:0x0064 (thunk @file 0x01AAF6 type B) overlay @file 0x033778
0264E6  83 C4 12              ADD    sp, 0x12 ; STACK_CLEANUP
0264E9  6A 48                 PUSH   0x48 ; PUSH_CONST
0264EB  6A 48                 PUSH   0x48 ; PUSH_CONST
0264ED  6A 20                 PUSH   0x20 ; PUSH_CONST
0264EF  68 E0 00              PUSH   0xe0 ; PUSH_CONST
0264F2  0E                    PUSH   cs ; STACK_PUSH
0264F3  E8 CD 65              CALL   0x2cac3 ; CALL_NEAR
0264F6  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0264F9  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0264FD  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
026501  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
026505  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
026509  68 80 00              PUSH   0x80 ; PUSH_CONST
02650C  6A 00                 PUSH   0 ; STACK_PUSH
02650E  B8 C7 00              MOV    ax, 0xc7 ; CONST_LOAD
026511  BA 07 00              MOV    dx, 7 ; MOV
026514  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
026517  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
02651C  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
026520  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
026524  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
026528  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
02652C  6A 68                 PUSH   0x68 ; PUSH_CONST
02652E  6A 00                 PUSH   0 ; STACK_PUSH
026530  B8 DF 00              MOV    ax, 0xdf ; CONST_LOAD
026533  BA 1F 00              MOV    dx, 0x1f ; CONST_LOAD
026536  BB 28 01              MOV    bx, 0x128 ; CONST_LOAD
026539  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
02653E  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0 ; LOCAL_STORE
026543  E9 57 03              JMP    0x2689d ; JUMP
026546  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
026549  8B C6                 MOV    ax, si ; MOV
02654B  C1 E6 02              SHL    si, 2 ; LOGIC
02654E  03 F0                 ADD    si, ax ; ARITH
026550  8B 5E EC              MOV    bx, word ptr [bp - 0x14] ; LOCAL_LOAD
026553  8A 80 F0 8D           MOV    al, byte ptr [bx + si - 0x7210] ; MOV
026557  2A E4                 SUB    ah, ah ; ARITH
026559  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02655C  A8 40                 TEST   al, 0x40 ; LOGIC
02655E  74 29                 JE     0x26589 ; CJUMP
026560  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
026564  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
026568  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
02656C  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
026570  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
026573  05 17 00              ADD    ax, 0x17 ; ARITH
026576  50                    PUSH   ax ; STACK_PUSH
026577  6A 0C                 PUSH   0xc ; PUSH_CONST
026579  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
02657C  8B D8                 MOV    bx, ax ; MOV
02657E  83                    DB     0x83 ; DATA_BYTE
02657F  C3                    DB     0xC3 ; DATA_BYTE
