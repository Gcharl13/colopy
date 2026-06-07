; ============================================================================
; func_0211F7_unknown
; Region   : load_image
; Bytes    : file 0x0211F7..0x02127A  (131 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0211F7  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
0211FB  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
021200  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
021203  A3 88 82              MOV    word ptr [0x8288], ax        ; UNKNOWN
021206  8B 4E 08              MOV    cx, word ptr [bp + 8]        ; UNKNOWN
021209  89 0E 8A 82           MOV    word ptr [0x828a], cx        ; UNKNOWN
02120D  8B D8                 MOV    bx, ax                       ; UNKNOWN
02120F  8B C1                 MOV    ax, cx                       ; UNKNOWN
021211  F7 EB                 IMUL   bx                           ; UNKNOWN
021213  A3 F0 82              MOV    word ptr [0x82f0], ax        ; UNKNOWN
021216  89 16 F2 82           MOV    word ptr [0x82f2], dx        ; UNKNOWN
02121A  0E                    PUSH   cs                           ; UNKNOWN
02121B  E8 54 FD              CALL   0x20f72                      ; UNKNOWN
02121E  0B C0                 OR     ax, ax                       ; UNKNOWN
021220  75 53                 JNE    0x21275                      ; UNKNOWN
021222  39 06 0A 0B           CMP    word ptr [0xb0a], ax         ; UNKNOWN
021226  75 3F                 JNE    0x21267                      ; UNKNOWN
021228  FF 36 F0 82           PUSH   word ptr [0x82f0]            ; UNKNOWN
02122C  6A 19                 PUSH   0x19                         ; UNKNOWN
02122E  FF 36 0E 0B           PUSH   word ptr [0xb0e]             ; UNKNOWN
021232  FF 36 0C 0B           PUSH   word ptr [0xb0c]             ; UNKNOWN
021236  9A 06 15 65 5F        LCALL  0x5f65, 0x1506               ; UNKNOWN
02123B  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02123E  FF 36 F0 82           PUSH   word ptr [0x82f0]            ; UNKNOWN
021242  6A 00                 PUSH   0                            ; UNKNOWN
021244  FF 36 12 0B           PUSH   word ptr [0xb12]             ; UNKNOWN
021248  FF 36 10 0B           PUSH   word ptr [0xb10]             ; UNKNOWN
02124C  9A 06 15 65 5F        LCALL  0x5f65, 0x1506               ; UNKNOWN
021251  83 C4 08              ADD    sp, 8                        ; UNKNOWN
021254  FF 36 F0 82           PUSH   word ptr [0x82f0]            ; UNKNOWN
021258  6A 00                 PUSH   0                            ; UNKNOWN
02125A  FF 36 16 0B           PUSH   word ptr [0xb16]             ; UNKNOWN
02125E  FF 36 14 0B           PUSH   word ptr [0xb14]             ; UNKNOWN
021262  9A 06 15 65 5F        LCALL  0x5f65, 0x1506               ; UNKNOWN
021267  2B C0                 SUB    ax, ax                       ; UNKNOWN
021269  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02126C  A3 08 0B              MOV    word ptr [0xb08], ax         ; UNKNOWN
02126F  C7 06 02 0B 04 00     MOV    word ptr [0xb02], 4          ; UNKNOWN
021275  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
021278  C9                    LEAVE                               ; UNKNOWN
021279  CB                    RETF                                ; UNKNOWN
