; ============================================================================
; func_012676_unknown
; Region   : load_image
; Bytes    : file 0x012676..0x012A09  (915 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012676  C8 A4 00 00           ENTER  0xa4, 0                      ; UNKNOWN
01267A  57                    PUSH   di                           ; UNKNOWN
01267B  56                    PUSH   si                           ; UNKNOWN
01267C  2B C0                 SUB    ax, ax                       ; UNKNOWN
01267E  89 86 64 FF           MOV    word ptr [bp - 0x9c], ax     ; UNKNOWN
012682  89 86 62 FF           MOV    word ptr [bp - 0x9e], ax     ; UNKNOWN
012686  89 86 66 FF           MOV    word ptr [bp - 0x9a], ax     ; UNKNOWN
01268A  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
01268D  89 46 8E              MOV    word ptr [bp - 0x72], ax     ; UNKNOWN
012690  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
012693  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
012696  89 46 94              MOV    word ptr [bp - 0x6c], ax     ; UNKNOWN
012699  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
01269C  89 46 88              MOV    word ptr [bp - 0x78], ax     ; UNKNOWN
01269F  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
0126A2  89 46 84              MOV    word ptr [bp - 0x7c], ax     ; UNKNOWN
0126A5  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
0126A8  89 46 8C              MOV    word ptr [bp - 0x74], ax     ; UNKNOWN
0126AB  EB 0B                 JMP    0x126b8                      ; UNKNOWN
0126AD  8B 76 8C              MOV    si, word ptr [bp - 0x74]     ; UNKNOWN
0126B0  C6 82 68 FF 00        MOV    byte ptr [bp + si - 0x98], 0 ; UNKNOWN
0126B5  FF 46 8C              INC    word ptr [bp - 0x74]         ; UNKNOWN
0126B8  83 7E 8C 19           CMP    word ptr [bp - 0x74], 0x19   ; UNKNOWN
0126BC  7C EF                 JL     0x126ad                      ; UNKNOWN
0126BE  C7 46 8C 00 00        MOV    word ptr [bp - 0x74], 0      ; UNKNOWN
0126C3  E9 A8 00              JMP    0x1276e                      ; UNKNOWN
0126C6  FF 46 90              INC    word ptr [bp - 0x70]         ; UNKNOWN
0126C9  83 7E 90 05           CMP    word ptr [bp - 0x70], 5      ; UNKNOWN
0126CD  7C 03                 JL     0x126d2                      ; UNKNOWN
0126CF  E9 88 00              JMP    0x1275a                      ; UNKNOWN
0126D2  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0126D6  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
0126D9  2A E4                 SUB    ah, ah                       ; UNKNOWN
0126DB  8B 36 38 73           MOV    si, word ptr [0x7338]        ; UNKNOWN
0126DF  8A 4C 01              MOV    cl, byte ptr [si + 1]        ; UNKNOWN
0126E2  2A ED                 SUB    ch, ch                       ; UNKNOWN
0126E4  2B C1                 SUB    ax, cx                       ; UNKNOWN
0126E6  03 46 8A              ADD    ax, word ptr [bp - 0x76]     ; UNKNOWN
0126E9  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
0126EC  48                    DEC    ax                           ; UNKNOWN
0126ED  48                    DEC    ax                           ; UNKNOWN
0126EE  50                    PUSH   ax                           ; UNKNOWN
0126EF  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
0126F1  2A E4                 SUB    ah, ah                       ; UNKNOWN
0126F3  8A 0C                 MOV    cl, byte ptr [si]            ; UNKNOWN
0126F5  2B C1                 SUB    ax, cx                       ; UNKNOWN
0126F7  03 46 90              ADD    ax, word ptr [bp - 0x70]     ; UNKNOWN
0126FA  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0126FD  48                    DEC    ax                           ; UNKNOWN
0126FE  48                    DEC    ax                           ; UNKNOWN
0126FF  50                    PUSH   ax                           ; UNKNOWN
012700  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
012705  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012708  0B C0                 OR     ax, ax                       ; UNKNOWN
01270A  74 BA                 JE     0x126c6                      ; UNKNOWN
01270C  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
012710  7C B4                 JL     0x126c6                      ; UNKNOWN
012712  83 7E FC 05           CMP    word ptr [bp - 4], 5         ; UNKNOWN
012716  7D AE                 JGE    0x126c6                      ; UNKNOWN
012718  83 7E A6 00           CMP    word ptr [bp - 0x5a], 0      ; UNKNOWN
01271C  7C A8                 JL     0x126c6                      ; UNKNOWN
01271E  83 7E A6 05           CMP    word ptr [bp - 0x5a], 5      ; UNKNOWN
012722  7D A2                 JGE    0x126c6                      ; UNKNOWN
012724  83 7E 90 02           CMP    word ptr [bp - 0x70], 2      ; UNKNOWN
012728  75 06                 JNE    0x12730                      ; UNKNOWN
01272A  83 7E 8A 02           CMP    word ptr [bp - 0x76], 2      ; UNKNOWN
01272E  74 12                 JE     0x12742                      ; UNKNOWN
012730  FF 76 8A              PUSH   word ptr [bp - 0x76]         ; UNKNOWN
012733  FF 76 90              PUSH   word ptr [bp - 0x70]         ; UNKNOWN
012736  9A 96 06 5F 24        LCALL  0x245f, 0x696                ; UNKNOWN
01273B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01273E  0A C0                 OR     al, al                       ; UNKNOWN
012740  7C 84                 JL     0x126c6                      ; UNKNOWN
012742  8B 76 8A              MOV    si, word ptr [bp - 0x76]     ; UNKNOWN
012745  8B C6                 MOV    ax, si                       ; UNKNOWN
012747  C1 E6 02              SHL    si, 2                        ; UNKNOWN
01274A  03 F0                 ADD    si, ax                       ; UNKNOWN
01274C  03 76 90              ADD    si, word ptr [bp - 0x70]     ; UNKNOWN
01274F  89 76 92              MOV    word ptr [bp - 0x6e], si     ; UNKNOWN
012752  C6 82 68 FF 01        MOV    byte ptr [bp + si - 0x98], 1 ; UNKNOWN
012757  E9 6C FF              JMP    0x126c6                      ; UNKNOWN
01275A  FF 46 8A              INC    word ptr [bp - 0x76]         ; UNKNOWN
01275D  83 7E 8A 05           CMP    word ptr [bp - 0x76], 5      ; UNKNOWN
012761  7D 08                 JGE    0x1276b                      ; UNKNOWN
012763  C7 46 90 00 00        MOV    word ptr [bp - 0x70], 0      ; UNKNOWN
012768  E9 5E FF              JMP    0x126c9                      ; UNKNOWN
01276B  FF 46 8C              INC    word ptr [bp - 0x74]         ; UNKNOWN
01276E  A1 16 3E              MOV    ax, word ptr [0x3e16]        ; UNKNOWN
012771  39 46 8C              CMP    word ptr [bp - 0x74], ax     ; UNKNOWN
012774  7D 12                 JGE    0x12788                      ; UNKNOWN
012776  FF 76 8C              PUSH   word ptr [bp - 0x74]         ; UNKNOWN
012779  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
01277E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
012781  C7 46 8A 00 00        MOV    word ptr [bp - 0x76], 0      ; UNKNOWN
012786  EB D5                 JMP    0x1275d                      ; UNKNOWN
012788  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
01278C  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
01278F  2A E4                 SUB    ah, ah                       ; UNKNOWN
012791  48                    DEC    ax                           ; UNKNOWN
012792  48                    DEC    ax                           ; UNKNOWN
012793  89 46 8A              MOV    word ptr [bp - 0x76], ax     ; UNKNOWN
012796  E9 CC 01              JMP    0x12965                      ; UNKNOWN
012799  FF 46 A4              INC    word ptr [bp - 0x5c]         ; UNKNOWN
01279C  83 46 A8 02           ADD    word ptr [bp - 0x58], 2      ; UNKNOWN
0127A0  E9 BB 00              JMP    0x1285e                      ; UNKNOWN
0127A3  83 7E 82 19           CMP    word ptr [bp - 0x7e], 0x19   ; UNKNOWN
0127A7  74 06                 JE     0x127af                      ; UNKNOWN
0127A9  83 7E 82 1A           CMP    word ptr [bp - 0x7e], 0x1a   ; UNKNOWN
0127AD  75 20                 JNE    0x127cf                      ; UNKNOWN
0127AF  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
0127B3  8A 47 02              MOV    al, byte ptr [bx + 2]        ; UNKNOWN
0127B6  2A E4                 SUB    ah, ah                       ; UNKNOWN
0127B8  40                    INC    ax                           ; UNKNOWN
0127B9  01 46 88              ADD    word ptr [bp - 0x78], ax     ; UNKNOWN
0127BC  83 7E 88 03           CMP    word ptr [bp - 0x78], 3      ; UNKNOWN
0127C0  7D 03                 JGE    0x127c5                      ; UNKNOWN
0127C2  E9 99 00              JMP    0x1285e                      ; UNKNOWN
0127C5  83 46 94 02           ADD    word ptr [bp - 0x6c], 2      ; UNKNOWN
0127C9  83 6E 88 03           SUB    word ptr [bp - 0x78], 3      ; UNKNOWN
0127CD  EB ED                 JMP    0x127bc                      ; UNKNOWN
0127CF  83 7E 82 08           CMP    word ptr [bp - 0x7e], 8      ; UNKNOWN
0127D3  7C 03                 JL     0x127d8                      ; UNKNOWN
0127D5  E9 86 00              JMP    0x1285e                      ; UNKNOWN
0127D8  83 7E 82 05           CMP    word ptr [bp - 0x7e], 5      ; UNKNOWN
0127DC  75 04                 JNE    0x127e2                      ; UNKNOWN
0127DE  83 46 AA 04           ADD    word ptr [bp - 0x56], 4      ; UNKNOWN
0127E2  83 7E 82 07           CMP    word ptr [bp - 0x7e], 7      ; UNKNOWN
0127E6  75 04                 JNE    0x127ec                      ; UNKNOWN
0127E8  83 46 AA 02           ADD    word ptr [bp - 0x56], 2      ; UNKNOWN
0127EC  83 7E 82 04           CMP    word ptr [bp - 0x7e], 4      ; UNKNOWN
0127F0  75 04                 JNE    0x127f6                      ; UNKNOWN
0127F2  83 46 84 04           ADD    word ptr [bp - 0x7c], 4      ; UNKNOWN
0127F6  83 7E 82 06           CMP    word ptr [bp - 0x7e], 6      ; UNKNOWN
0127FA  75 04                 JNE    0x12800                      ; UNKNOWN
0127FC  83 46 84 02           ADD    word ptr [bp - 0x7c], 2      ; UNKNOWN
012800  83 7E 82 03           CMP    word ptr [bp - 0x7e], 3      ; UNKNOWN
012804  75 04                 JNE    0x1280a                      ; UNKNOWN
012806  83 46 9A 04           ADD    word ptr [bp - 0x66], 4      ; UNKNOWN
01280A  83 7E 82 00           CMP    word ptr [bp - 0x7e], 0      ; UNKNOWN
01280E  75 04                 JNE    0x12814                      ; UNKNOWN
012810  83 46 9C 02           ADD    word ptr [bp - 0x64], 2      ; UNKNOWN
012814  83 7E 82 02           CMP    word ptr [bp - 0x7e], 2      ; UNKNOWN
012818  75 07                 JNE    0x12821                      ; UNKNOWN
01281A  FF 46 9A              INC    word ptr [bp - 0x66]         ; UNKNOWN
01281D  83 46 94 02           ADD    word ptr [bp - 0x6c], 2      ; UNKNOWN
012821  83 7E 82 01           CMP    word ptr [bp - 0x7e], 1      ; UNKNOWN
012825  7E 21                 JLE    0x12848                      ; UNKNOWN
012827  83 46 94 02           ADD    word ptr [bp - 0x6c], 2      ; UNKNOWN
01282B  83 7E 82 06           CMP    word ptr [bp - 0x7e], 6      ; UNKNOWN
01282F  7D 12                 JGE    0x12843                      ; UNKNOWN
012831  FF 46 94              INC    word ptr [bp - 0x6c]         ; UNKNOWN
012834  F6 46 82 04           TEST   byte ptr [bp - 0x7e], 4      ; UNKNOWN
012838  75 03                 JNE    0x1283d                      ; UNKNOWN
01283A  E9 5F FF              JMP    0x1279c                      ; UNKNOWN
01283D  83 46 98 02           ADD    word ptr [bp - 0x68], 2      ; UNKNOWN
012841  EB 1B                 JMP    0x1285e                      ; UNKNOWN
012843  FF 46 9C              INC    word ptr [bp - 0x64]         ; UNKNOWN
012846  EB 16                 JMP    0x1285e                      ; UNKNOWN
012848  83 7E 82 01           CMP    word ptr [bp - 0x7e], 1      ; UNKNOWN
01284C  75 06                 JNE    0x12854                      ; UNKNOWN
01284E  83 46 98 04           ADD    word ptr [bp - 0x68], 4      ; UNKNOWN
012852  EB 0A                 JMP    0x1285e                      ; UNKNOWN
012854  83 7E 82 00           CMP    word ptr [bp - 0x7e], 0      ; UNKNOWN
012858  75 04                 JNE    0x1285e                      ; UNKNOWN
01285A  83 46 A8 03           ADD    word ptr [bp - 0x58], 3      ; UNKNOWN
01285E  FF 46 90              INC    word ptr [bp - 0x70]         ; UNKNOWN
012861  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
012865  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
012867  2A E4                 SUB    ah, ah                       ; UNKNOWN
012869  40                    INC    ax                           ; UNKNOWN
01286A  40                    INC    ax                           ; UNKNOWN
01286B  3B 46 90              CMP    ax, word ptr [bp - 0x70]     ; UNKNOWN
01286E  7D 03                 JGE    0x12873                      ; UNKNOWN
012870  E9 EF 00              JMP    0x12962                      ; UNKNOWN
012873  FF 76 8A              PUSH   word ptr [bp - 0x76]         ; UNKNOWN
012876  FF 76 90              PUSH   word ptr [bp - 0x70]         ; UNKNOWN
012879  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
01287E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012881  0B C0                 OR     ax, ax                       ; UNKNOWN
012883  74 D9                 JE     0x1285e                      ; UNKNOWN
012885  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
012889  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
01288C  2A E4                 SUB    ah, ah                       ; UNKNOWN
01288E  2B 46 8A              SUB    ax, word ptr [bp - 0x76]     ; UNKNOWN
012891  F7 D8                 NEG    ax                           ; UNKNOWN
012893  40                    INC    ax                           ; UNKNOWN
012894  40                    INC    ax                           ; UNKNOWN
012895  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
012898  8B C8                 MOV    cx, ax                       ; UNKNOWN
01289A  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
01289D  03 C1                 ADD    ax, cx                       ; UNKNOWN
01289F  8A 0F                 MOV    cl, byte ptr [bx]            ; UNKNOWN
0128A1  2A ED                 SUB    ch, ch                       ; UNKNOWN
0128A3  2B 4E 90              SUB    cx, word ptr [bp - 0x70]     ; UNKNOWN
0128A6  F7 D9                 NEG    cx                           ; UNKNOWN
0128A8  41                    INC    cx                           ; UNKNOWN
0128A9  41                    INC    cx                           ; UNKNOWN
0128AA  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
0128AD  03 C1                 ADD    ax, cx                       ; UNKNOWN
0128AF  89 46 92              MOV    word ptr [bp - 0x6e], ax     ; UNKNOWN
0128B2  8B F0                 MOV    si, ax                       ; UNKNOWN
0128B4  80 BA 68 FF 00        CMP    byte ptr [bp + si - 0x98], 0 ; UNKNOWN
0128B9  75 A3                 JNE    0x1285e                      ; UNKNOWN
0128BB  FF 76 8A              PUSH   word ptr [bp - 0x76]         ; UNKNOWN
0128BE  FF 76 90              PUSH   word ptr [bp - 0x70]         ; UNKNOWN
0128C1  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
0128C6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0128C9  89 46 82              MOV    word ptr [bp - 0x7e], ax     ; UNKNOWN
0128CC  83 F8 1B              CMP    ax, 0x1b                     ; UNKNOWN
0128CF  75 04                 JNE    0x128d5                      ; UNKNOWN
0128D1  FF 86 62 FF           INC    word ptr [bp - 0x9e]         ; UNKNOWN
0128D5  83 F8 1C              CMP    ax, 0x1c                     ; UNKNOWN
0128D8  75 04                 JNE    0x128de                      ; UNKNOWN
0128DA  FF 86 66 FF           INC    word ptr [bp - 0x9a]         ; UNKNOWN
0128DE  83 F8 18              CMP    ax, 0x18                     ; UNKNOWN
0128E1  75 04                 JNE    0x128e7                      ; UNKNOWN
0128E3  83 46 A8 04           ADD    word ptr [bp - 0x58], 4      ; UNKNOWN
0128E7  83 F8 08              CMP    ax, 8                        ; UNKNOWN
0128EA  7C 05                 JL     0x128f1                      ; UNKNOWN
0128EC  83 F8 10              CMP    ax, 0x10                     ; UNKNOWN
0128EF  7C 10                 JL     0x12901                      ; UNKNOWN
0128F1  83 F8 10              CMP    ax, 0x10                     ; UNKNOWN
0128F4  7D 03                 JGE    0x128f9                      ; UNKNOWN
0128F6  E9 AA FE              JMP    0x127a3                      ; UNKNOWN
0128F9  83 F8 18              CMP    ax, 0x18                     ; UNKNOWN
0128FC  7C 03                 JL     0x12901                      ; UNKNOWN
0128FE  E9 A2 FE              JMP    0x127a3                      ; UNKNOWN
012901  FF 46 94              INC    word ptr [bp - 0x6c]         ; UNKNOWN
012904  83 F8 08              CMP    ax, 8                        ; UNKNOWN
012907  7C 0C                 JL     0x12915                      ; UNKNOWN
012909  83 F8 10              CMP    ax, 0x10                     ; UNKNOWN
01290C  7D 07                 JGE    0x12915                      ; UNKNOWN
01290E  83 E8 08              SUB    ax, 8                        ; UNKNOWN
012911  89 86 64 FF           MOV    word ptr [bp - 0x9c], ax     ; UNKNOWN
012915  83 7E 82 10           CMP    word ptr [bp - 0x7e], 0x10   ; UNKNOWN
012919  7C 10                 JL     0x1292b                      ; UNKNOWN
01291B  83 7E 82 18           CMP    word ptr [bp - 0x7e], 0x18   ; UNKNOWN
01291F  7D 0A                 JGE    0x1292b                      ; UNKNOWN
012921  8B 46 82              MOV    ax, word ptr [bp - 0x7e]     ; UNKNOWN
012924  83 E8 10              SUB    ax, 0x10                     ; UNKNOWN
012927  89 86 64 FF           MOV    word ptr [bp - 0x9c], ax     ; UNKNOWN
01292B  83 BE 64 FF 03        CMP    word ptr [bp - 0x9c], 3      ; UNKNOWN
012930  7D 03                 JGE    0x12935                      ; UNKNOWN
012932  E9 64 FE              JMP    0x12799                      ; UNKNOWN
012935  FF 46 8E              INC    word ptr [bp - 0x72]         ; UNKNOWN
012938  FF 46 98              INC    word ptr [bp - 0x68]         ; UNKNOWN
01293B  83 BE 64 FF 05        CMP    word ptr [bp - 0x9c], 5      ; UNKNOWN
012940  75 04                 JNE    0x12946                      ; UNKNOWN
012942  83 46 AA 02           ADD    word ptr [bp - 0x56], 2      ; UNKNOWN
012946  83 BE 64 FF 04        CMP    word ptr [bp - 0x9c], 4      ; UNKNOWN
01294B  75 04                 JNE    0x12951                      ; UNKNOWN
01294D  83 46 84 02           ADD    word ptr [bp - 0x7c], 2      ; UNKNOWN
012951  83 BE 64 FF 03        CMP    word ptr [bp - 0x9c], 3      ; UNKNOWN
012956  74 03                 JE     0x1295b                      ; UNKNOWN
012958  E9 03 FF              JMP    0x1285e                      ; UNKNOWN
01295B  83 46 9A 02           ADD    word ptr [bp - 0x66], 2      ; UNKNOWN
01295F  E9 FC FE              JMP    0x1285e                      ; UNKNOWN
012962  FF 46 8A              INC    word ptr [bp - 0x76]         ; UNKNOWN
012965  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
012968  2A E4                 SUB    ah, ah                       ; UNKNOWN
01296A  40                    INC    ax                           ; UNKNOWN
01296B  40                    INC    ax                           ; UNKNOWN
01296C  3B 46 8A              CMP    ax, word ptr [bp - 0x76]     ; UNKNOWN
01296F  7C 0C                 JL     0x1297d                      ; UNKNOWN
012971  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
012973  2A E4                 SUB    ah, ah                       ; UNKNOWN
012975  48                    DEC    ax                           ; UNKNOWN
012976  48                    DEC    ax                           ; UNKNOWN
012977  89 46 90              MOV    word ptr [bp - 0x70], ax     ; UNKNOWN
01297A  E9 E4 FE              JMP    0x12861                      ; UNKNOWN
01297D  8A 47 04              MOV    al, byte ptr [bx + 4]        ; UNKNOWN
012980  2A E4                 SUB    ah, ah                       ; UNKNOWN
012982  40                    INC    ax                           ; UNKNOWN
012983  89 86 5E FF           MOV    word ptr [bp - 0xa2], ax     ; UNKNOWN
012987  8B C8                 MOV    cx, ax                       ; UNKNOWN
012989  F7 E9                 IMUL   cx                           ; UNKNOWN
01298B  89 86 60 FF           MOV    word ptr [bp - 0xa0], ax     ; UNKNOWN
01298F  C7 46 8C 00 00        MOV    word ptr [bp - 0x74], 0      ; UNKNOWN
012994  2B C0                 SUB    ax, ax                       ; UNKNOWN
012996  8B 5E 8C              MOV    bx, word ptr [bp - 0x74]     ; UNKNOWN
012999  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01299B  89 87 3C 82           MOV    word ptr [bx - 0x7dc4], ax   ; UNKNOWN
01299F  89 87 5C 82           MOV    word ptr [bx - 0x7da4], ax   ; UNKNOWN
0129A3  FF 46 8C              INC    word ptr [bp - 0x74]         ; UNKNOWN
0129A6  83 7E 8C 10           CMP    word ptr [bp - 0x74], 0x10   ; UNKNOWN
0129AA  7C E8                 JL     0x12994                      ; UNKNOWN
0129AC  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
0129B0  8A 47 02              MOV    al, byte ptr [bx + 2]        ; UNKNOWN
0129B3  8B C8                 MOV    cx, ax                       ; UNKNOWN
0129B5  2A E4                 SUB    ah, ah                       ; UNKNOWN
0129B7  BE 07 00              MOV    si, 7                        ; UNKNOWN
0129BA  2B F0                 SUB    si, ax                       ; UNKNOWN
0129BC  03 86 5E FF           ADD    ax, word ptr [bp - 0xa2]     ; UNKNOWN
0129C0  F7 6E 94              IMUL   word ptr [bp - 0x6c]         ; UNKNOWN
0129C3  99                    CDQ                                 ; UNKNOWN
0129C4  F7 FE                 IDIV   si                           ; UNKNOWN
0129C6  01 06 5C 82           ADD    word ptr [0x825c], ax        ; UNKNOWN
0129CA  89 8E 5C FF           MOV    word ptr [bp - 0xa4], cx     ; UNKNOWN
0129CE  80 F9 01              CMP    cl, 1                        ; UNKNOWN
0129D1  76 04                 JBE    0x129d7                      ; UNKNOWN
0129D3  B1 01                 MOV    cl, 1                        ; UNKNOWN
0129D5  EB 02                 JMP    0x129d9                      ; UNKNOWN
0129D7  2A C9                 SUB    cl, cl                       ; UNKNOWN
0129D9  8B 86 60 FF           MOV    ax, word ptr [bp - 0xa0]     ; UNKNOWN
0129DD  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
0129E0  D3 F8                 SAR    ax, cl                       ; UNKNOWN
0129E2  A3 3C 82              MOV    word ptr [0x823c], ax        ; UNKNOWN
0129E5  80 BE 5C FF 01        CMP    byte ptr [bp - 0xa4], 1      ; UNKNOWN
0129EA  72 5E                 JB     0x12a4a                      ; UNKNOWN
0129EC  80 BE 5C FF 02        CMP    byte ptr [bp - 0xa4], 2      ; UNKNOWN
0129F1  72 3C                 JB     0x12a2f                      ; UNKNOWN
0129F3  8B 47 0C              MOV    ax, word ptr [bx + 0xc]      ; UNKNOWN
0129F6  8B 1E 3A 82           MOV    bx, word ptr [0x823a]        ; UNKNOWN
0129FA  8A 8F 6F 88           MOV    cl, byte ptr [bx - 0x7791]   ; UNKNOWN
0129FE  80 E9 01              SUB    cl, 1                        ; UNKNOWN
012A01  1A D2                 SBB    dl, dl                       ; UNKNOWN
012A03  F6 D2                 NOT    dl                           ; UNKNOWN
012A05  22 CA                 AND    cl, dl                       ; UNKNOWN
012A07  80                    DB     0x80                         ; UNKNOWN (raw)
012A08  C1                    DB     0xC1                         ; UNKNOWN (raw)
