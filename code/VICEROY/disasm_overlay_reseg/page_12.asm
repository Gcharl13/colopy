; ============================================================
; VICEROY.EXE overlay page 0x12 (record 17) -- RE-SEGMENTED
; file_offset (disk image) = 0x05FAD0
; code_offset (first insn) = 0x05FE60
; code_end (next reloc hdr)= 0x061CA0  [resident size 484 para -> nominal_end 0x061910; on-disk code spills past it]
; reloc_count = 218  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x05FAD0)
; functions in page = 25
; ============================================================

; ---- func_05FE60  size=26  insns=10  prologue=push bp;mov bp,sp  terminal=RETF ----
  05FE60  0390: 55               push bp
  05FE61  0391: 8bec             mov bp, sp
  05FE63  0393: 8b4606           mov ax, word ptr [bp + 6]
  05FE66  0396: a35ca1           mov word ptr [0xa15c], ax
  05FE69  0399: 6bc04a           imul ax, ax, 0x4a
  05FE6C  039C: 050000           add ax, 0
  05FE6F  039F: a3149e           mov word ptr [0x9e14], ax
  05FE72  03A2: c706169e221b     mov word ptr [0x9e16], 0x1b22
  05FE78  03A8: c9               leave 
  05FE79  03A9: cb               retf 

; ---- func_05FE7A  size=38  insns=15  prologue=push bp;mov bp,sp  terminal=RETF ----
  05FE7A  03AA: 55               push bp
  05FE7B  03AB: 8bec             mov bp, sp
  05FE7D  03AD: 8b4606           mov ax, word ptr [bp + 6]
  05FE80  03B0: a35ea1           mov word ptr [0xa15e], ax
  05FE83  03B3: 8bc8             mov cx, ax
  05FE85  03B5: c1e002           shl ax, 2
  05FE88  03B8: 03c1             add ax, cx
  05FE8A  03BA: d1e0             shl ax, 1
  05FE8C  03BC: 0306149e         add ax, word ptr [0x9e14]
  05FE90  03C0: 8b16169e         mov dx, word ptr [0x9e16]
  05FE94  03C4: 052200           add ax, 0x22
  05FE97  03C7: a3189e           mov word ptr [0x9e18], ax
  05FE9A  03CA: 89161a9e         mov word ptr [0x9e1a], dx
  05FE9E  03CE: c9               leave 
  05FE9F  03CF: cb               retf 

; ---- func_05FEA0  size=83  insns=31  prologue=ENTER 0x0004,0  terminal=RETF ----
  05FEA0  03D0: c8040000         enter 4, 0
  05FEA4  03D4: 56               push si
  05FEA5  03D5: 8b7606           mov si, word ptr [bp + 6]
  05FEA8  03D8: 8bc6             mov ax, si
  05FEAA  03DA: c1e602           shl si, 2
  05FEAD  03DD: 03f0             add si, ax
  05FEAF  03DF: d1e6             shl si, 1
  05FEB1  03E1: c41e149e         les bx, ptr [0x9e14]
  05FEB5  03E5: 26817822e703     cmp word ptr es:[bx + si + 0x22], 0x3e7
  05FEBB  03EB: 751b             jne 0x408
  05FEBD  03ED: 8b1e9453         mov bx, word ptr [0x5394]
  05FEC1  03F1: d1e3             shl bx, 1
  05FEC3  03F3: ffb78c83         push word ptr [bx - 0x7c74]
  05FEC7  03F7: 9a22001f18       lcall 0x181f, 0x22
  05FECC  03FC: 83c402           add sp, 2
  05FECF  03FF: 8956fe           mov word ptr [bp - 2], dx
  05FED2  0402: 8b56fe           mov dx, word ptr [bp - 2]
  05FED5  0405: 5e               pop si
  05FED6  0406: c9               leave 
  05FED7  0407: cb               retf 
  05FED8  0408: 8bf0             mov si, ax
  05FEDA  040A: c1e602           shl si, 2
  05FEDD  040D: 03f0             add si, ax
  05FEDF  040F: d1e6             shl si, 1
  05FEE1  0411: 26694022ca00     imul ax, word ptr es:[bx + si + 0x22], 0xca
  05FEE7  0417: 05485d           add ax, 0x5d48
  05FEEA  041A: 8c5efe           mov word ptr [bp - 2], ds
  05FEED  041D: 8b56fe           mov dx, word ptr [bp - 2]
  05FEF0  0420: 5e               pop si
  05FEF1  0421: c9               leave 
  05FEF2  0422: cb               retf 

; ---- func_05FEF4  size=306  insns=112  prologue=ENTER 0x0004,0  terminal=RETF ----
  05FEF4  0424: c8040000         enter 4, 0
  05FEF8  0428: 56               push si
  05FEF9  0429: c746fe0000       mov word ptr [bp - 2], 0
  05FEFE  042E: 817e06e703       cmp word ptr [bp + 6], 0x3e7
  05FF03  0433: 741a             je 0x44f
  05FF05  0435: ff7606           push word ptr [bp + 6]
  05FF08  0438: 9ae6091f18       lcall 0x181f, 0x9e6
  05FF0D  043D: 83c402           add sp, 2
  05FF10  0440: a09453           mov al, byte ptr [0x5394]
  05FF13  0443: 8b1e4285         mov bx, word ptr [0x8542]
  05FF17  0447: 38471a           cmp byte ptr [bx + 0x1a], al
  05FF1A  044A: 7403             je 0x44f
  05FF1C  044C: e90101           jmp 0x550
  05FF1F  044F: 837e0800         cmp word ptr [bp + 8], 0
  05FF23  0453: 7d03             jge 0x458
  05FF25  0455: e9f300           jmp 0x54b
  05FF28  0458: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05FF2C  045C: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05FF31  0461: 7303             jae 0x466
  05FF33  0463: e9b000           jmp 0x516
  05FF36  0466: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05FF3B  046B: 7603             jbe 0x470
  05FF3D  046D: e9a600           jmp 0x516
  05FF40  0470: 8a874531         mov al, byte ptr [bx + 0x3145]
  05FF44  0474: 2ae4             sub ah, ah
  05FF46  0476: 50               push ax
  05FF47  0477: 8a874431         mov al, byte ptr [bx + 0x3144]
  05FF4B  047B: 50               push ax
  05FF4C  047C: 9a02031f18       lcall 0x181f, 0x302
  05FF51  0481: 83c404           add sp, 4
  05FF54  0484: 0bc0             or ax, ax
  05FF56  0486: 750a             jne 0x492
  05FF58  0488: 6a01             push 1
  05FF5A  048A: a13a85           mov ax, word ptr [0x853a]
  05FF5D  048D: 48               dec ax
  05FF5E  048E: 48               dec ax
  05FF5F  048F: 50               push ax
  05FF60  0490: eb34             jmp 0x4c6
  05FF62  0492: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05FF66  0496: 8a874531         mov al, byte ptr [bx + 0x3145]
  05FF6A  049A: 2ae4             sub ah, ah
  05FF6C  049C: 50               push ax
  05FF6D  049D: 8a874431         mov al, byte ptr [bx + 0x3144]
  05FF71  04A1: 50               push ax
  05FF72  04A2: 8bf3             mov si, bx
  05FF74  04A4: 9a120d1f18       lcall 0x181f, 0xd12
  05FF79  04A9: 83c404           add sp, 4
  05FF7C  04AC: 0bc0             or ax, ax
  05FF7E  04AE: 750e             jne 0x4be
  05FF80  04B0: 8a844531         mov al, byte ptr [si + 0x3145]
  05FF84  04B4: 2ae4             sub ah, ah
  05FF86  04B6: 50               push ax
  05FF87  04B7: 8a844431         mov al, byte ptr [si + 0x3144]
  05FF8B  04BB: ebd2             jmp 0x48f
  05FF8D  04BD: 90               nop 
  05FF8E  04BE: ff36bc8d         push word ptr [0x8dbc]
  05FF92  04C2: ff36ba8d         push word ptr [0x8dba]
  05FF96  04C6: 9ab4061f18       lcall 0x181f, 0x6b4
  05FF9B  04CB: 83c404           add sp, 4
  05FF9E  04CE: 2ae4             sub ah, ah
  05FFA0  04D0: 8946fc           mov word ptr [bp - 4], ax
  05FFA3  04D3: 817e06e703       cmp word ptr [bp + 6], 0x3e7
  05FFA8  04D8: 7432             je 0x50c
  05FFAA  04DA: 8b1e4285         mov bx, word ptr [0x8542]
  05FFAE  04DE: 8a4701           mov al, byte ptr [bx + 1]
  05FFB1  04E1: 50               push ax
  05FFB2  04E2: 8a07             mov al, byte ptr [bx]
  05FFB4  04E4: 50               push ax
  05FFB5  04E5: 9a120d1f18       lcall 0x181f, 0xd12
  05FFBA  04EA: 83c404           add sp, 4
  05FFBD  04ED: 0bc0             or ax, ax
  05FFBF  04EF: 745f             je 0x550
  05FFC1  04F1: ff36bc8d         push word ptr [0x8dbc]
  05FFC5  04F5: ff36ba8d         push word ptr [0x8dba]
  05FFC9  04F9: 9ab4061f18       lcall 0x181f, 0x6b4
  05FFCE  04FE: 83c404           add sp, 4
  05FFD1  0501: 3a46fc           cmp al, byte ptr [bp - 4]
  05FFD4  0504: 7445             je 0x54b
  05FFD6  0506: 8b46fe           mov ax, word ptr [bp - 2]
  05FFD9  0509: 5e               pop si
  05FFDA  050A: c9               leave 
  05FFDB  050B: cb               retf 
  05FFDC  050C: 6a01             push 1
  05FFDE  050E: a13a85           mov ax, word ptr [0x853a]
  05FFE1  0511: 48               dec ax
  05FFE2  0512: 48               dec ax
  05FFE3  0513: eb28             jmp 0x53d
  05FFE5  0515: 90               nop 
  05FFE6  0516: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05FFEA  051A: 8a874531         mov al, byte ptr [bx + 0x3145]
  05FFEE  051E: 2ae4             sub ah, ah
  05FFF0  0520: 50               push ax
  05FFF1  0521: 8a874431         mov al, byte ptr [bx + 0x3144]
  05FFF5  0525: 50               push ax
  05FFF6  0526: 9ab4061f18       lcall 0x181f, 0x6b4
  05FFFB  052B: 83c404           add sp, 4
  05FFFE  052E: 2ae4             sub ah, ah
  060000  0530: 8946fc           mov word ptr [bp - 4], ax
  060003  0533: 8b1e4285         mov bx, word ptr [0x8542]
  060007  0537: 8a4701           mov al, byte ptr [bx + 1]
  06000A  053A: 50               push ax
  06000B  053B: 8a07             mov al, byte ptr [bx]
  06000D  053D: 50               push ax
  06000E  053E: 9ab4061f18       lcall 0x181f, 0x6b4
  060013  0543: 83c404           add sp, 4
  060016  0546: 3a46fc           cmp al, byte ptr [bp - 4]
  060019  0549: 7505             jne 0x550
  06001B  054B: c746fe0100       mov word ptr [bp - 2], 1
  060020  0550: 8b46fe           mov ax, word ptr [bp - 2]
  060023  0553: 5e               pop si
  060024  0554: c9               leave 
  060025  0555: cb               retf 

; ---- func_060026  size=810  insns=276  prologue=ENTER 0x0068,0  terminal=RETF ----
  060026  0556: c8680000         enter 0x68, 0
  06002A  055A: 56               push si
  06002B  055B: 2bc0             sub ax, ax
  06002D  055D: 8946a4           mov word ptr [bp - 0x5c], ax
  060030  0560: 8946a2           mov word ptr [bp - 0x5e], ax
  060033  0563: 8946a8           mov word ptr [bp - 0x58], ax
  060036  0566: 8946fc           mov word ptr [bp - 4], ax
  060039  0569: 89469c           mov word ptr [bp - 0x64], ax
  06003C  056C: eb15             jmp 0x583
  06003E  056E: ff7606           push word ptr [bp + 6]
  060041  0571: 50               push ax
  060042  0572: 0e               push cs
  060043  0573: e8eb13           call 0x1961
  060046  0576: 83c404           add sp, 4
  060049  0579: 0bc0             or ax, ax
  06004B  057B: 7403             je 0x580
  06004D  057D: ff46fc           inc word ptr [bp - 4]
  060050  0580: ff469c           inc word ptr [bp - 0x64]
  060053  0583: 8b469c           mov ax, word ptr [bp - 0x64]
  060056  0586: 39069e53         cmp word ptr [0x539e], ax
  06005A  058A: 7fe2             jg 0x56e
  06005C  058C: c746a60100       mov word ptr [bp - 0x5a], 1
  060061  0591: c746fa0000       mov word ptr [bp - 6], 0
  060066  0596: 837efc0a         cmp word ptr [bp - 4], 0xa
  06006A  059A: 7e14             jle 0x5b0
  06006C  059C: 8b46fc           mov ax, word ptr [bp - 4]
  06006F  059F: 050900           add ax, 9
  060072  05A2: b90a00           mov cx, 0xa
  060075  05A5: 99               cdq 
  060076  05A6: f7f9             idiv cx
  060078  05A8: 8946a6           mov word ptr [bp - 0x5a], ax
  06007B  05AB: 894ea0           mov word ptr [bp - 0x60], cx
  06007E  05AE: eb07             jmp 0x5b7
  060080  05B0: 8b46fc           mov ax, word ptr [bp - 4]
  060083  05B3: 40               inc ax
  060084  05B4: 8946a0           mov word ptr [bp - 0x60], ax
  060087  05B7: 837e0600         cmp word ptr [bp + 6], 0
  06008B  05BB: 7c27             jl 0x5e4
  06008D  05BD: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  060091  05C1: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  060096  05C6: 7212             jb 0x5da
  060098  05C8: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  06009D  05CD: 770b             ja 0x5da
  06009F  05CF: 8d1e7c08         lea bx, [0x87c]
  0600A3  05D3: 8d06ee1c         lea ax, [0x1cee]
  0600A7  05D7: eb13             jmp 0x5ec
  0600A9  05D9: 90               nop 
  0600AA  05DA: 8d1e7c08         lea bx, [0x87c]
  0600AE  05DE: 8d06f71c         lea ax, [0x1cf7]
  0600B2  05E2: eb08             jmp 0x5ec
  0600B4  05E4: 8d1e7c08         lea bx, [0x87c]
  0600B8  05E8: 8d06031d         lea ax, [0x1d03]
  0600BC  05EC: 2bd2             sub dx, dx
  0600BE  05EE: 9a82011f19       lcall 0x191f, 0x182
  0600C3  05F3: 8946a2           mov word ptr [bp - 0x5e], ax
  0600C6  05F6: 8956a4           mov word ptr [bp - 0x5c], dx
  0600C9  05F9: 8bc2             mov ax, dx
  0600CB  05FB: 0b46a2           or ax, word ptr [bp - 0x5e]
  0600CE  05FE: 7503             jne 0x603
  0600D0  0600: e96302           jmp 0x866
  0600D3  0603: 8b46a0           mov ax, word ptr [bp - 0x60]
  0600D6  0606: f76efa           imul word ptr [bp - 6]
  0600D9  0609: 89469a           mov word ptr [bp - 0x66], ax
  0600DC  060C: 0346a0           add ax, word ptr [bp - 0x60]
  0600DF  060F: 48               dec ax
  0600E0  0610: 8946fe           mov word ptr [bp - 2], ax
  0600E3  0613: c746980000       mov word ptr [bp - 0x68], 0
  0600E8  0618: c45ea2           les bx, ptr [bp - 0x5e]
  0600EB  061B: 26c747220a00     mov word ptr es:[bx + 0x22], 0xa
  0600F1  0621: 26804f0a01       or byte ptr es:[bx + 0xa], 1
  0600F6  0626: 837efa00         cmp word ptr [bp - 6], 0
  0600FA  062A: 7e1f             jle 0x64b
  0600FC  062C: 68e503           push 0x3e5
  0600FF  062F: ff36aa93         push word ptr [0x93aa]
  060103  0633: 9a22001f18       lcall 0x181f, 0x22
  060108  0638: 83c402           add sp, 2
  06010B  063B: 52               push dx
  06010C  063C: 50               push ax
  06010D  063D: ff76a4           push word ptr [bp - 0x5c]
  060110  0640: ff76a2           push word ptr [bp - 0x5e]
  060113  0643: 9a76011f19       lcall 0x191f, 0x176
  060118  0648: 83c40a           add sp, 0xa
  06011B  064B: 837e0600         cmp word ptr [bp + 6], 0
  06011F  064F: 7d03             jge 0x654
  060121  0651: e9ba00           jmp 0x70e
  060124  0654: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  060128  0658: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  06012D  065D: 7303             jae 0x662
  06012F  065F: e9ac00           jmp 0x70e
  060132  0662: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  060137  0667: 7603             jbe 0x66c
  060139  0669: e9a200           jmp 0x70e
  06013C  066C: ff7606           push word ptr [bp + 6]
  06013F  066F: 68e703           push 0x3e7
  060142  0672: 0e               push cs
  060143  0673: e8eb12           call 0x1961
  060146  0676: 83c404           add sp, 4
  060149  0679: 0bc0             or ax, ax
  06014B  067B: 7503             jne 0x680
  06014D  067D: e98e00           jmp 0x70e
  060150  0680: 837efa00         cmp word ptr [bp - 6], 0
  060154  0684: 7403             je 0x689
  060156  0686: e98200           jmp 0x70b
  060159  0689: c646aa00         mov byte ptr [bp - 0x56], 0
  06015D  068D: 8b1e9453         mov bx, word ptr [0x5394]
  060161  0691: d1e3             shl bx, 1
  060163  0693: ffb78c83         push word ptr [bx - 0x7c74]
  060167  0697: 8d46aa           lea ax, [bp - 0x56]
  06016A  069A: 50               push ax
  06016B  069B: 9a6e011f18       lcall 0x181f, 0x16e
  060170  06A0: 83c404           add sp, 4
  060173  06A3: 8d46aa           lea ax, [bp - 0x56]
  060176  06A6: 50               push ax
  060177  06A7: 9a78011f18       lcall 0x181f, 0x178
  06017C  06AC: 83c402           add sp, 2
  06017F  06AF: 8d46aa           lea ax, [bp - 0x56]
  060182  06B2: 50               push ax
  060183  06B3: 9a1e011f18       lcall 0x181f, 0x11e
  060188  06B8: 83c402           add sp, 2
  06018B  06BB: 8b1e9453         mov bx, word ptr [0x5394]
  06018F  06BF: d1e3             shl bx, 1
  060191  06C1: ffb7428d         push word ptr [bx - 0x72be]
  060195  06C5: 8d46aa           lea ax, [bp - 0x56]
  060198  06C8: 50               push ax
  060199  06C9: 9a6e011f18       lcall 0x181f, 0x16e
  06019E  06CE: 83c404           add sp, 4
  0601A1  06D1: 8d46aa           lea ax, [bp - 0x56]
  0601A4  06D4: 50               push ax
  0601A5  06D5: 9a28011f18       lcall 0x181f, 0x128
  0601AA  06DA: 83c402           add sp, 2
  0601AD  06DD: 68e803           push 0x3e8
  0601B0  06E0: 8d46aa           lea ax, [bp - 0x56]
  0601B3  06E3: 16               push ss
  0601B4  06E4: 50               push ax
  0601B5  06E5: ff76a4           push word ptr [bp - 0x5c]
  0601B8  06E8: ff76a2           push word ptr [bp - 0x5e]
  0601BB  06EB: 9a76011f19       lcall 0x191f, 0x176
  0601C0  06F0: 83c40a           add sp, 0xa
  0601C3  06F3: 817e08e703       cmp word ptr [bp + 8], 0x3e7
  0601C8  06F8: 7511             jne 0x70b
  0601CA  06FA: 68e803           push 0x3e8
  0601CD  06FD: ff76a4           push word ptr [bp - 0x5c]
  0601D0  0700: ff76a2           push word ptr [bp - 0x5e]
  0601D3  0703: 9aec081f19       lcall 0x191f, 0x8ec
  0601D8  0708: 83c406           add sp, 6
  0601DB  070B: ff4698           inc word ptr [bp - 0x68]
  0601DE  070E: c7469c0000       mov word ptr [bp - 0x64], 0
  0601E3  0713: eb22             jmp 0x737
  0601E5  0715: 90               nop 
  0601E6  0716: 8b4608           mov ax, word ptr [bp + 8]
  0601E9  0719: 39469c           cmp word ptr [bp - 0x64], ax
  0601EC  071C: 7513             jne 0x731
  0601EE  071E: 8b469c           mov ax, word ptr [bp - 0x64]
  0601F1  0721: 40               inc ax
  0601F2  0722: 50               push ax
  0601F3  0723: ff76a4           push word ptr [bp - 0x5c]
  0601F6  0726: ff76a2           push word ptr [bp - 0x5e]
  0601F9  0729: 9aec081f19       lcall 0x191f, 0x8ec
  0601FE  072E: 83c406           add sp, 6
  060201  0731: ff4698           inc word ptr [bp - 0x68]
  060204  0734: ff469c           inc word ptr [bp - 0x64]
  060207  0737: 8b469c           mov ax, word ptr [bp - 0x64]
  06020A  073A: 39069e53         cmp word ptr [0x539e], ax
  06020E  073E: 7f03             jg 0x743
  060210  0740: e99d00           jmp 0x7e0
  060213  0743: ff7606           push word ptr [bp + 6]
  060216  0746: 50               push ax
  060217  0747: 0e               push cs
  060218  0748: e81612           call 0x1961
  06021B  074B: 83c404           add sp, 4
  06021E  074E: 0bc0             or ax, ax
  060220  0750: 74e2             je 0x734
  060222  0752: 8b4698           mov ax, word ptr [bp - 0x68]
  060225  0755: 39469a           cmp word ptr [bp - 0x66], ax
  060228  0758: 7fd7             jg 0x731
  06022A  075A: 3946fe           cmp word ptr [bp - 2], ax
  06022D  075D: 7cd2             jl 0x731
  06022F  075F: c7469e0000       mov word ptr [bp - 0x62], 0
  060234  0764: 8b1e4285         mov bx, word ptr [0x8542]
  060238  0768: 8a07             mov al, byte ptr [bx]
  06023A  076A: 6b76061c         imul si, word ptr [bp + 6], 0x1c
  06023E  076E: 38844431         cmp byte ptr [si + 0x3144], al
  060242  0772: 750e             jne 0x782
  060244  0774: 8a4701           mov al, byte ptr [bx + 1]
  060247  0777: 38844531         cmp byte ptr [si + 0x3145], al
  06024B  077B: 7505             jne 0x782
  06024D  077D: c7469e0100       mov word ptr [bp - 0x62], 1
  060252  0782: 837e0a00         cmp word ptr [bp + 0xa], 0
  060256  0786: 7505             jne 0x78d
  060258  0788: c7469e0000       mov word ptr [bp - 0x62], 0
  06025D  078D: 837e9e00         cmp word ptr [bp - 0x62], 0
  060261  0791: 7412             je 0x7a5
  060263  0793: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  060267  0797: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  06026C  079C: 7293             jb 0x731
  06026E  079E: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  060273  07A3: 778c             ja 0x731
  060275  07A5: 8b469c           mov ax, word ptr [bp - 0x64]
  060278  07A8: 40               inc ax
  060279  07A9: 50               push ax
  06027A  07AA: 8b0e4285         mov cx, word ptr [0x8542]
  06027E  07AE: 41               inc cx
  06027F  07AF: 41               inc cx
  060280  07B0: 1e               push ds
  060281  07B1: 51               push cx
  060282  07B2: ff76a4           push word ptr [bp - 0x5c]
  060285  07B5: ff76a2           push word ptr [bp - 0x5e]
  060288  07B8: 8bf0             mov si, ax
  06028A  07BA: 9a76011f19       lcall 0x191f, 0x176
  06028F  07BF: 83c40a           add sp, 0xa
  060292  07C2: 837e9e00         cmp word ptr [bp - 0x62], 0
  060296  07C6: 7503             jne 0x7cb
  060298  07C8: e94bff           jmp 0x716
  06029B  07CB: 6a01             push 1
  06029D  07CD: 56               push si
  06029E  07CE: ff76a4           push word ptr [bp - 0x5c]
  0602A1  07D1: ff76a2           push word ptr [bp - 0x5e]
  0602A4  07D4: 9ab6011f19       lcall 0x191f, 0x1b6
  0602A9  07D9: 83c408           add sp, 8
  0602AC  07DC: e952ff           jmp 0x731
  0602AF  07DF: 90               nop 
  0602B0  07E0: 8b46a6           mov ax, word ptr [bp - 0x5a]
  0602B3  07E3: 48               dec ax
  0602B4  07E4: 3b46fa           cmp ax, word ptr [bp - 6]
  0602B7  07E7: 7e09             jle 0x7f2
  0602B9  07E9: 68e603           push 0x3e6
  0602BC  07EC: ff36aa93         push word ptr [0x93aa]
  0602C0  07F0: eb0d             jmp 0x7ff
  0602C2  07F2: 837e0c00         cmp word ptr [bp + 0xc], 0
  0602C6  07F6: 741f             je 0x817
  0602C8  07F8: 68e903           push 0x3e9
  0602CB  07FB: ff36ee93         push word ptr [0x93ee]
  0602CF  07FF: 9a22001f18       lcall 0x181f, 0x22
  0602D4  0804: 83c402           add sp, 2
  0602D7  0807: 52               push dx
  0602D8  0808: 50               push ax
  0602D9  0809: ff76a4           push word ptr [bp - 0x5c]
  0602DC  080C: ff76a2           push word ptr [bp - 0x5e]
  0602DF  080F: 9a76011f19       lcall 0x191f, 0x176
  0602E4  0814: 83c40a           add sp, 0xa
  0602E7  0817: c45ea2           les bx, ptr [bp - 0x5e]
  0602EA  081A: 26837f0201       cmp word ptr es:[bx + 2], 1
  0602EF  081F: 7c45             jl 0x866
  0602F1  0821: 06               push es
  0602F2  0822: 53               push bx
  0602F3  0823: 9a6a011f19       lcall 0x191f, 0x16a
  0602F8  0828: 8946a8           mov word ptr [bp - 0x58], ax
  0602FB  082B: ff76a4           push word ptr [bp - 0x5c]
  0602FE  082E: ff76a2           push word ptr [bp - 0x5e]
  060301  0831: 9aa8011f19       lcall 0x191f, 0x1a8
  060306  0836: 2bc0             sub ax, ax
  060308  0838: 8946a4           mov word ptr [bp - 0x5c], ax
  06030B  083B: 8946a2           mov word ptr [bp - 0x5e], ax
  06030E  083E: 817ea8e503       cmp word ptr [bp - 0x58], 0x3e5
  060313  0843: 7503             jne 0x848
  060315  0845: ff4efa           dec word ptr [bp - 6]
  060318  0848: 817ea8e603       cmp word ptr [bp - 0x58], 0x3e6
  06031D  084D: 7503             jne 0x852
  06031F  084F: ff46fa           inc word ptr [bp - 6]
  060322  0852: 817ea8e503       cmp word ptr [bp - 0x58], 0x3e5
  060327  0857: 7503             jne 0x85c
  060329  0859: e95bfd           jmp 0x5b7
  06032C  085C: 817ea8e603       cmp word ptr [bp - 0x58], 0x3e6
  060331  0861: 7503             jne 0x866
  060333  0863: e951fd           jmp 0x5b7
  060336  0866: 8b46a4           mov ax, word ptr [bp - 0x5c]
  060339  0869: 0b46a2           or ax, word ptr [bp - 0x5e]
  06033C  086C: 740b             je 0x879
  06033E  086E: ff76a4           push word ptr [bp - 0x5c]
  060341  0871: ff76a2           push word ptr [bp - 0x5e]
  060344  0874: 9aa8011f19       lcall 0x191f, 0x1a8
  060349  0879: 8b46a8           mov ax, word ptr [bp - 0x58]
  06034C  087C: 48               dec ax
  06034D  087D: 5e               pop si
  06034E  087E: c9               leave 
  06034F  087F: cb               retf 

; ---- func_060350  size=50  insns=18  prologue=ENTER 0x0004,0  terminal=RETF ----
  060350  0880: c8040000         enter 4, 0
  060354  0884: 837e0606         cmp word ptr [bp + 6], 6
  060358  0888: 7c16             jl 0x8a0
  06035A  088A: 836e0606         sub word ptr [bp + 6], 6
  06035E  088E: 8b4606           mov ax, word ptr [bp + 6]
  060361  0891: d1f8             sar ax, 1
  060363  0893: 0306189e         add ax, word ptr [0x9e18]
  060367  0897: 8b161a9e         mov dx, word ptr [0x9e1a]
  06036B  089B: 050300           add ax, 3
  06036E  089E: c9               leave 
  06036F  089F: cb               retf 
  060370  08A0: 8b4606           mov ax, word ptr [bp + 6]
  060373  08A3: d1f8             sar ax, 1
  060375  08A5: 0306189e         add ax, word ptr [0x9e18]
  060379  08A9: 8b161a9e         mov dx, word ptr [0x9e1a]
  06037D  08AD: 050600           add ax, 6
  060380  08B0: c9               leave 
  060381  08B1: cb               retf 

; ---- func_060382  size=37  insns=15  prologue=ENTER 0x0002,0  terminal=RETF ----
  060382  08B2: c8020000         enter 2, 0
  060386  08B6: 837e0600         cmp word ptr [bp + 6], 0
  06038A  08BA: 740e             je 0x8ca
  06038C  08BC: c41e189e         les bx, ptr [0x9e18]
  060390  08C0: 268a4702         mov al, byte ptr es:[bx + 2]
  060394  08C4: c0f804           sar al, 4
  060397  08C7: 98               cwde 
  060398  08C8: c9               leave 
  060399  08C9: cb               retf 
  06039A  08CA: c41e189e         les bx, ptr [0x9e18]
  06039E  08CE: 268a4702         mov al, byte ptr es:[bx + 2]
  0603A2  08D2: 240f             and al, 0xf
  0603A4  08D4: 98               cwde 
  0603A5  08D5: c9               leave 
  0603A6  08D6: cb               retf 

; ---- func_0603A8  size=50  insns=18  prologue=push bp;mov bp,sp  terminal=RETF ----
  0603A8  08D8: 55               push bp
  0603A9  08D9: 8bec             mov bp, sp
  0603AB  08DB: 837e0600         cmp word ptr [bp + 6], 0
  0603AF  08DF: 7415             je 0x8f6
  0603B1  08E1: c41e189e         les bx, ptr [0x9e18]
  0603B5  08E5: 268067020f       and byte ptr es:[bx + 2], 0xf
  0603BA  08EA: 8a4608           mov al, byte ptr [bp + 8]
  0603BD  08ED: c0e004           shl al, 4
  0603C0  08F0: 26084702         or byte ptr es:[bx + 2], al
  0603C4  08F4: c9               leave 
  0603C5  08F5: cb               retf 
  0603C6  08F6: c41e189e         les bx, ptr [0x9e18]
  0603CA  08FA: 26806702f0       and byte ptr es:[bx + 2], 0xf0
  0603CF  08FF: 8a4608           mov al, byte ptr [bp + 8]
  0603D2  0902: 240f             and al, 0xf
  0603D4  0904: 26084702         or byte ptr es:[bx + 2], al
  0603D8  0908: c9               leave 
  0603D9  0909: cb               retf 

; ---- func_0603DA  size=47  insns=18  prologue=ENTER 0x0002,0  terminal=RETF ----
  0603DA  090A: c8020000         enter 2, 0
  0603DE  090E: ff7606           push word ptr [bp + 6]
  0603E1  0911: 0e               push cs
  0603E2  0912: e85b10           call 0x1970
  0603E5  0915: 83c402           add sp, 2
  0603E8  0918: 8ec2             mov es, dx
  0603EA  091A: 8bd8             mov bx, ax
  0603EC  091C: 268a07           mov al, byte ptr es:[bx]
  0603EF  091F: 8846fe           mov byte ptr [bp - 2], al
  0603F2  0922: f6460601         test byte ptr [bp + 6], 1
  0603F6  0926: 7406             je 0x92e
  0603F8  0928: c06efe04         shr byte ptr [bp - 2], 4
  0603FC  092C: eb04             jmp 0x932
  0603FE  092E: 8066fe0f         and byte ptr [bp - 2], 0xf
  060402  0932: 8a46fe           mov al, byte ptr [bp - 2]
  060405  0935: 2ae4             sub ah, ah
  060407  0937: c9               leave 
  060408  0938: cb               retf 

; ---- func_06040A  size=66  insns=26  prologue=ENTER 0x0006,0  terminal=RETF ----
  06040A  093A: c8060000         enter 6, 0
  06040E  093E: ff7606           push word ptr [bp + 6]
  060411  0941: 0e               push cs
  060412  0942: e82b10           call 0x1970
  060415  0945: 83c402           add sp, 2
  060418  0948: 8ec2             mov es, dx
  06041A  094A: 8bd8             mov bx, ax
  06041C  094C: 268a07           mov al, byte ptr es:[bx]
  06041F  094F: 8846fa           mov byte ptr [bp - 6], al
  060422  0952: f6460601         test byte ptr [bp + 6], 1
  060426  0956: 7410             je 0x968
  060428  0958: 240f             and al, 0xf
  06042A  095A: 8a4e08           mov cl, byte ptr [bp + 8]
  06042D  095D: c0e104           shl cl, 4
  060430  0960: 0ac1             or al, cl
  060432  0962: 8846fa           mov byte ptr [bp - 6], al
  060435  0965: eb0d             jmp 0x974
  060437  0967: 90               nop 
  060438  0968: 8066faf0         and byte ptr [bp - 6], 0xf0
  06043C  096C: 8a4608           mov al, byte ptr [bp + 8]
  06043F  096F: 240f             and al, 0xf
  060441  0971: 0846fa           or byte ptr [bp - 6], al
  060444  0974: 8a46fa           mov al, byte ptr [bp - 6]
  060447  0977: 268807           mov byte ptr es:[bx], al
  06044A  097A: c9               leave 
  06044B  097B: cb               retf 

; ---- func_06044C  size=33  insns=16  prologue=push bp;mov bp,sp  terminal=RETF ----
  06044C  097C: 55               push bp
  06044D  097D: 8bec             mov bp, sp
  06044F  097F: 8b4606           mov ax, word ptr [bp + 6]
  060452  0982: c41e189e         les bx, ptr [0x9e18]
  060456  0986: 268907           mov word ptr es:[bx], ax
  060459  0989: 6a00             push 0
  06045B  098B: 6a01             push 1
  06045D  098D: 0e               push cs
  06045E  098E: e8ee0f           call 0x197f
  060461  0991: 8be5             mov sp, bp
  060463  0993: 6a00             push 0
  060465  0995: 6a00             push 0
  060467  0997: 0e               push cs
  060468  0998: e8e40f           call 0x197f
  06046B  099B: c9               leave 
  06046C  099C: cb               retf 

; ---- func_06046E  size=180  insns=72  prologue=ENTER 0x0008,0  terminal=RETF ----
  06046E  099E: c8080000         enter 8, 0
  060472  09A2: 57               push di
  060473  09A3: 56               push si
  060474  09A4: c746fc0000       mov word ptr [bp - 4], 0
  060479  09A9: eb5d             jmp 0xa08
  06047B  09AB: 90               nop 
  06047C  09AC: 6bd81c           imul bx, ax, 0x1c
  06047F  09AF: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  060483  09B3: 80e10f           and cl, 0xf
  060486  09B6: 3a0e9453         cmp cl, byte ptr [0x5394]
  06048A  09BA: 7549             jne 0xa05
  06048C  09BC: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  060490  09C0: 2aff             sub bh, bh
  060492  09C2: 8bcb             mov cx, bx
  060494  09C4: d1e3             shl bx, 1
  060496  09C6: 03d9             add bx, cx
  060498  09C8: d1e3             shl bx, 1
  06049A  09CA: 03d9             add bx, cx
  06049C  09CC: d1e3             shl bx, 1
  06049E  09CE: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  0604A3  09D3: 7430             je 0xa05
  0604A5  09D5: 50               push ax
  0604A6  09D6: 9a58081f18       lcall 0x181f, 0x858
  0604AB  09DB: 83c402           add sp, 2
  0604AE  09DE: 39065ca1         cmp word ptr [0xa15c], ax
  0604B2  09E2: 7521             jne 0xa05
  0604B4  09E4: ff76fc           push word ptr [bp - 4]
  0604B7  09E7: 9a76081f18       lcall 0x181f, 0x876
  0604BC  09EC: 83c402           add sp, 2
  0604BF  09EF: 3b4606           cmp ax, word ptr [bp + 6]
  0604C2  09F2: 7c11             jl 0xa05
  0604C4  09F4: 48               dec ax
  0604C5  09F5: 7902             jns 0x9f9
  0604C7  09F7: 2bc0             sub ax, ax
  0604C9  09F9: 50               push ax
  0604CA  09FA: ff76fc           push word ptr [bp - 4]
  0604CD  09FD: 9ab2081f18       lcall 0x181f, 0x8b2
  0604D2  0A02: 83c404           add sp, 4
  0604D5  0A05: ff46fc           inc word ptr [bp - 4]
  0604D8  0A08: 8b46fc           mov ax, word ptr [bp - 4]
  0604DB  0A0B: 39069c53         cmp word ptr [0x539c], ax
  0604DF  0A0F: 7f9b             jg 0x9ac
  0604E1  0A11: 8b4606           mov ax, word ptr [bp + 6]
  0604E4  0A14: 8946fe           mov word ptr [bp - 2], ax
  0604E7  0A17: eb21             jmp 0xa3a
  0604E9  0A19: 90               nop 
  0604EA  0A1A: 8b46fe           mov ax, word ptr [bp - 2]
  0604ED  0A1D: 8bc8             mov cx, ax
  0604EF  0A1F: c1e002           shl ax, 2
  0604F2  0A22: 03c1             add ax, cx
  0604F4  0A24: d1e0             shl ax, 1
  0604F6  0A26: 03d8             add bx, ax
  0604F8  0A28: 1e               push ds
  0604F9  0A29: 8d7f22           lea di, [bx + 0x22]
  0604FC  0A2C: 8d772c           lea si, [bx + 0x2c]
  0604FF  0A2F: 06               push es
  060500  0A30: 1f               pop ds
  060501  0A31: b90500           mov cx, 5
  060504  0A34: f3a5             rep movsw word ptr es:[di], word ptr [si]
  060506  0A36: 1f               pop ds
  060507  0A37: ff46fe           inc word ptr [bp - 2]
  06050A  0A3A: c41e149e         les bx, ptr [0x9e14]
  06050E  0A3E: 268a4721         mov al, byte ptr es:[bx + 0x21]
  060512  0A42: 2ae4             sub ah, ah
  060514  0A44: 48               dec ax
  060515  0A45: 3b46fe           cmp ax, word ptr [bp - 2]
  060518  0A48: 7fd0             jg 0xa1a
  06051A  0A4A: 26fe4f21         dec byte ptr es:[bx + 0x21]
  06051E  0A4E: 5e               pop si
  06051F  0A4F: 5f               pop di
  060520  0A50: c9               leave 
  060521  0A51: cb               retf 

; ---- func_060522  size=211  insns=80  prologue=ENTER 0x0006,0  terminal=RETF ----
  060522  0A52: c8060000         enter 6, 0
  060526  0A56: 57               push di
  060527  0A57: 56               push si
  060528  0A58: c746fa0000       mov word ptr [bp - 6], 0
  06052D  0A5D: eb1c             jmp 0xa7b
  06052F  0A5F: 90               nop 
  060530  0A60: 8b4606           mov ax, word ptr [bp + 6]
  060533  0A63: 3946fe           cmp word ptr [bp - 2], ax
  060536  0A66: 7e10             jle 0xa78
  060538  0A68: 8b46fe           mov ax, word ptr [bp - 2]
  06053B  0A6B: 48               dec ax
  06053C  0A6C: 50               push ax
  06053D  0A6D: ff76fa           push word ptr [bp - 6]
  060540  0A70: 9ab2081f18       lcall 0x181f, 0x8b2
  060545  0A75: 83c404           add sp, 4
  060548  0A78: ff46fa           inc word ptr [bp - 6]
  06054B  0A7B: 8b46fa           mov ax, word ptr [bp - 6]
  06054E  0A7E: 39069c53         cmp word ptr [0x539c], ax
  060552  0A82: 7e66             jle 0xaea
  060554  0A84: 6bd81c           imul bx, ax, 0x1c
  060557  0A87: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  06055B  0A8B: 80e10f           and cl, 0xf
  06055E  0A8E: 3a0e9453         cmp cl, byte ptr [0x5394]
  060562  0A92: 75e4             jne 0xa78
  060564  0A94: 8bcb             mov cx, bx
  060566  0A96: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  06056A  0A9A: 2aff             sub bh, bh
  06056C  0A9C: 8bd3             mov dx, bx
  06056E  0A9E: d1e3             shl bx, 1
  060570  0AA0: 03da             add bx, dx
  060572  0AA2: d1e3             shl bx, 1
  060574  0AA4: 03da             add bx, dx
  060576  0AA6: d1e3             shl bx, 1
  060578  0AA8: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  06057D  0AAD: 74c9             je 0xa78
  06057F  0AAF: 50               push ax
  060580  0AB0: 8bf1             mov si, cx
  060582  0AB2: 9a58081f18       lcall 0x181f, 0x858
  060587  0AB7: 83c402           add sp, 2
  06058A  0ABA: 8946fe           mov word ptr [bp - 2], ax
  06058D  0ABD: 3b4606           cmp ax, word ptr [bp + 6]
  060590  0AC0: 759e             jne 0xa60
  060592  0AC2: 6a00             push 0
  060594  0AC4: ff76fa           push word ptr [bp - 6]
  060597  0AC7: 9a62081f18       lcall 0x181f, 0x862
  06059C  0ACC: 83c404           add sp, 4
  06059F  0ACF: 6a00             push 0
  0605A1  0AD1: ff76fa           push word ptr [bp - 6]
  0605A4  0AD4: 9ab2081f18       lcall 0x181f, 0x8b2
  0605A9  0AD9: 83c404           add sp, 4
  0605AC  0ADC: 80bc4c3102       cmp byte ptr [si + 0x314c], 2
  0605B1  0AE1: 7595             jne 0xa78
  0605B3  0AE3: c6844c3100       mov byte ptr [si + 0x314c], 0
  0605B8  0AE8: eb8e             jmp 0xa78
  0605BA  0AEA: 8b4606           mov ax, word ptr [bp + 6]
  0605BD  0AED: 8946fc           mov word ptr [bp - 4], ax
  0605C0  0AF0: eb22             jmp 0xb14
  0605C2  0AF2: 6b46fc4a         imul ax, word ptr [bp - 4], 0x4a
  0605C6  0AF6: 8bc8             mov cx, ax
  0605C8  0AF8: 054a00           add ax, 0x4a
  0605CB  0AFB: ba221b           mov dx, 0x1b22
  0605CE  0AFE: 8bd9             mov bx, cx
  0605D0  0B00: 8ec2             mov es, dx
  0605D2  0B02: 1e               push ds
  0605D3  0B03: 8dbf0000         lea di, [bx]
  0605D7  0B07: 8bf0             mov si, ax
  0605D9  0B09: 8eda             mov ds, dx
  0605DB  0B0B: b92500           mov cx, 0x25
  0605DE  0B0E: f3a5             rep movsw word ptr es:[di], word ptr [si]
  0605E0  0B10: 1f               pop ds
  0605E1  0B11: ff46fc           inc word ptr [bp - 4]
  0605E4  0B14: a1a053           mov ax, word ptr [0x53a0]
  0605E7  0B17: 48               dec ax
  0605E8  0B18: 3b46fc           cmp ax, word ptr [bp - 4]
  0605EB  0B1B: 7fd5             jg 0xaf2
  0605ED  0B1D: ff0ea053         dec word ptr [0x53a0]
  0605F1  0B21: 5e               pop si
  0605F2  0B22: 5f               pop di
  0605F3  0B23: c9               leave 
  0605F4  0B24: cb               retf 

; ---- func_0605F6  size=371  insns=129  prologue=ENTER 0x005C,0  terminal=RETF ----
  0605F6  0B26: c85c0000         enter 0x5c, 0
  0605FA  0B2A: 56               push si
  0605FB  0B2B: c746feffff       mov word ptr [bp - 2], 0xffff
  060600  0B30: c746a60000       mov word ptr [bp - 0x5a], 0
  060605  0B35: 2bc0             sub ax, ax
  060607  0B37: 8946aa           mov word ptr [bp - 0x56], ax
  06060A  0B3A: 8946a8           mov word ptr [bp - 0x58], ax
  06060D  0B3D: 833ea05301       cmp word ptr [0x53a0], 1
  060612  0B42: 7d12             jge 0xb56
  060614  0B44: 8d1e7c08         lea bx, [0x87c]
  060618  0B48: 8d060e1d         lea ax, [0x1d0e]
  06061C  0B4C: 2bd2             sub dx, dx
  06061E  0B4E: 9a98091f18       lcall 0x181f, 0x998
  060623  0B53: e92a01           jmp 0xc80
  060626  0B56: 8d1e7c08         lea bx, [0x87c]
  06062A  0B5A: 8b460a           mov ax, word ptr [bp + 0xa]
  06062D  0B5D: 2bd2             sub dx, dx
  06062F  0B5F: 9a82011f19       lcall 0x191f, 0x182
  060634  0B64: 8946a8           mov word ptr [bp - 0x58], ax
  060637  0B67: 8956aa           mov word ptr [bp - 0x56], dx
  06063A  0B6A: 0bd0             or dx, ax
  06063C  0B6C: 7503             jne 0xb71
  06063E  0B6E: e90f01           jmp 0xc80
  060641  0B71: c45ea8           les bx, ptr [bp - 0x58]
  060644  0B74: 26804f0a01       or byte ptr es:[bx + 0xa], 1
  060649  0B79: 26c747220a00     mov word ptr es:[bx + 0x22], 0xa
  06064F  0B7F: c746a40000       mov word ptr [bp - 0x5c], 0
  060654  0B84: eb76             jmp 0xbfc
  060656  0B86: 2ac0             sub al, al
  060658  0B88: c41e149e         les bx, ptr [0x9e14]
  06065C  0B8C: 263a4720         cmp al, byte ptr es:[bx + 0x20]
  060660  0B90: 7567             jne 0xbf9
  060662  0B92: c646ae00         mov byte ptr [bp - 0x52], 0
  060666  0B96: 8b46a4           mov ax, word ptr [bp - 0x5c]
  060669  0B99: 40               inc ax
  06066A  0B9A: 50               push ax
  06066B  0B9B: 8d4eae           lea cx, [bp - 0x52]
  06066E  0B9E: 16               push ss
  06066F  0B9F: 51               push cx
  060670  0BA0: 8bf0             mov si, ax
  060672  0BA2: 9a82011f18       lcall 0x181f, 0x182
  060677  0BA7: 83c406           add sp, 6
  06067A  0BAA: 8d46ae           lea ax, [bp - 0x52]
  06067D  0BAD: 50               push ax
  06067E  0BAE: 9adc011f18       lcall 0x181f, 0x1dc
  060683  0BB3: 83c402           add sp, 2
  060686  0BB6: ff36169e         push word ptr [0x9e16]
  06068A  0BBA: ff36149e         push word ptr [0x9e14]
  06068E  0BBE: 8d46ae           lea ax, [bp - 0x52]
  060691  0BC1: 16               push ss
  060692  0BC2: 50               push ax
  060693  0BC3: 9ab4111d0d       lcall 0xd1d, 0x11b4
  060698  0BC8: 83c408           add sp, 8
  06069B  0BCB: 56               push si
  06069C  0BCC: 8d46ae           lea ax, [bp - 0x52]
  06069F  0BCF: 16               push ss
  0606A0  0BD0: 50               push ax
  0606A1  0BD1: ff76aa           push word ptr [bp - 0x56]
  0606A4  0BD4: ff76a8           push word ptr [bp - 0x58]
  0606A7  0BD7: 9a76011f19       lcall 0x191f, 0x176
  0606AC  0BDC: 83c40a           add sp, 0xa
  0606AF  0BDF: ff46a6           inc word ptr [bp - 0x5a]
  0606B2  0BE2: 8b46a4           mov ax, word ptr [bp - 0x5c]
  0606B5  0BE5: 394608           cmp word ptr [bp + 8], ax
  0606B8  0BE8: 750f             jne 0xbf9
  0606BA  0BEA: 56               push si
  0606BB  0BEB: ff76aa           push word ptr [bp - 0x56]
  0606BE  0BEE: ff76a8           push word ptr [bp - 0x58]
  0606C1  0BF1: 9aec081f19       lcall 0x191f, 0x8ec
  0606C6  0BF6: 83c406           add sp, 6
  0606C9  0BF9: ff46a4           inc word ptr [bp - 0x5c]
  0606CC  0BFC: 8b46a4           mov ax, word ptr [bp - 0x5c]
  0606CF  0BFF: 3906a053         cmp word ptr [0x53a0], ax
  0606D3  0C03: 7e1f             jle 0xc24
  0606D5  0C05: 50               push ax
  0606D6  0C06: 0e               push cs
  0606D7  0C07: e8160d           call 0x1920
  0606DA  0C0A: 83c402           add sp, 2
  0606DD  0C0D: 837e0600         cmp word ptr [bp + 6], 0
  0606E1  0C11: 7503             jne 0xc16
  0606E3  0C13: e97cff           jmp 0xb92
  0606E6  0C16: 837e0602         cmp word ptr [bp + 6], 2
  0606EA  0C1A: 7403             je 0xc1f
  0606EC  0C1C: e967ff           jmp 0xb86
  0606EF  0C1F: b001             mov al, 1
  0606F1  0C21: e964ff           jmp 0xb88
  0606F4  0C24: 837ea600         cmp word ptr [bp - 0x5a], 0
  0606F8  0C28: 7540             jne 0xc6a
  0606FA  0C2A: 837e0602         cmp word ptr [bp + 6], 2
  0606FE  0C2E: 7506             jne 0xc36
  060700  0C30: b80100           mov ax, 1
  060703  0C33: eb03             jmp 0xc38
  060705  0C35: 90               nop 
  060706  0C36: 2bc0             sub ax, ax
  060708  0C38: c41e149e         les bx, ptr [0x9e14]
  06070C  0C3C: 268a4f20         mov cl, byte ptr es:[bx + 0x20]
  060710  0C40: 2aed             sub ch, ch
  060712  0C42: 3bc1             cmp ax, cx
  060714  0C44: 7506             jne 0xc4c
  060716  0C46: bb0300           mov bx, 3
  060719  0C49: eb04             jmp 0xc4f
  06071B  0C4B: 90               nop 
  06071C  0C4C: bb0400           mov bx, 4
  06071F  0C4F: d1e3             shl bx, 1
  060721  0C51: ffb7de93         push word ptr [bx - 0x6c22]
  060725  0C55: 6a00             push 0
  060727  0C57: 9a38041f18       lcall 0x181f, 0x438
  06072C  0C5C: 83c404           add sp, 4
  06072F  0C5F: 8d1e7c08         lea bx, [0x87c]
  060733  0C63: 8d06181d         lea ax, [0x1d18]
  060737  0C67: e9e2fe           jmp 0xb4c
  06073A  0C6A: ff76aa           push word ptr [bp - 0x56]
  06073D  0C6D: ff76a8           push word ptr [bp - 0x58]
  060740  0C70: 9a6a011f19       lcall 0x191f, 0x16a
  060745  0C75: 8946ac           mov word ptr [bp - 0x54], ax
  060748  0C78: 0bc0             or ax, ax
  06074A  0C7A: 7e04             jle 0xc80
  06074C  0C7C: 48               dec ax
  06074D  0C7D: 8946fe           mov word ptr [bp - 2], ax
  060750  0C80: 8b46aa           mov ax, word ptr [bp - 0x56]
  060753  0C83: 0b46a8           or ax, word ptr [bp - 0x58]
  060756  0C86: 740b             je 0xc93
  060758  0C88: ff76aa           push word ptr [bp - 0x56]
  06075B  0C8B: ff76a8           push word ptr [bp - 0x58]
  06075E  0C8E: 9aa8011f19       lcall 0x191f, 0x1a8
  060763  0C93: 8b46fe           mov ax, word ptr [bp - 2]
  060766  0C96: 5e               pop si
  060767  0C97: c9               leave 
  060768  0C98: cb               retf 

; ---- func_06076A  size=208  insns=73  prologue=ENTER 0x000A,0  terminal=RETF ----
  06076A  0C9A: c80a0000         enter 0xa, 0
  06076E  0C9E: 56               push si
  06076F  0C9F: c746feffff       mov word ptr [bp - 2], 0xffff
  060774  0CA4: 2bc0             sub ax, ax
  060776  0CA6: 8946fa           mov word ptr [bp - 6], ax
  060779  0CA9: 8946f8           mov word ptr [bp - 8], ax
  06077C  0CAC: c41e149e         les bx, ptr [0x9e14]
  060780  0CB0: 26807f2000       cmp byte ptr es:[bx + 0x20], 0
  060785  0CB5: 740b             je 0xcc2
  060787  0CB7: 8d1e7c08         lea bx, [0x87c]
  06078B  0CBB: 8d06231d         lea ax, [0x1d23]
  06078F  0CBF: eb09             jmp 0xcca
  060791  0CC1: 90               nop 
  060792  0CC2: 8d1e7c08         lea bx, [0x87c]
  060796  0CC6: 8d062c1d         lea ax, [0x1d2c]
  06079A  0CCA: 2bd2             sub dx, dx
  06079C  0CCC: 9a82011f19       lcall 0x191f, 0x182
  0607A1  0CD1: 8946f8           mov word ptr [bp - 8], ax
  0607A4  0CD4: 8956fa           mov word ptr [bp - 6], dx
  0607A7  0CD7: 8bc2             mov ax, dx
  0607A9  0CD9: 0b46f8           or ax, word ptr [bp - 8]
  0607AC  0CDC: 7473             je 0xd51
  0607AE  0CDE: c45ef8           les bx, ptr [bp - 8]
  0607B1  0CE1: 26804f0a01       or byte ptr es:[bx + 0xa], 1
  0607B6  0CE6: 26c747220a00     mov word ptr es:[bx + 0x22], 0xa
  0607BC  0CEC: c746f60000       mov word ptr [bp - 0xa], 0
  0607C1  0CF1: eb3c             jmp 0xd2f
  0607C3  0CF3: 90               nop 
  0607C4  0CF4: 8b46f6           mov ax, word ptr [bp - 0xa]
  0607C7  0CF7: 40               inc ax
  0607C8  0CF8: 50               push ax
  0607C9  0CF9: ff76f6           push word ptr [bp - 0xa]
  0607CC  0CFC: 8bf0             mov si, ax
  0607CE  0CFE: 0e               push cs
  0607CF  0CFF: e85a0c           call 0x195c
  0607D2  0D02: 83c402           add sp, 2
  0607D5  0D05: 52               push dx
  0607D6  0D06: 50               push ax
  0607D7  0D07: ff76fa           push word ptr [bp - 6]
  0607DA  0D0A: ff76f8           push word ptr [bp - 8]
  0607DD  0D0D: 9a76011f19       lcall 0x191f, 0x176
  0607E2  0D12: 83c40a           add sp, 0xa
  0607E5  0D15: 8b4606           mov ax, word ptr [bp + 6]
  0607E8  0D18: 3946f6           cmp word ptr [bp - 0xa], ax
  0607EB  0D1B: 750f             jne 0xd2c
  0607ED  0D1D: 56               push si
  0607EE  0D1E: ff76fa           push word ptr [bp - 6]
  0607F1  0D21: ff76f8           push word ptr [bp - 8]
  0607F4  0D24: 9aec081f19       lcall 0x191f, 0x8ec
  0607F9  0D29: 83c406           add sp, 6
  0607FC  0D2C: ff46f6           inc word ptr [bp - 0xa]
  0607FF  0D2F: c41e149e         les bx, ptr [0x9e14]
  060803  0D33: 268a4721         mov al, byte ptr es:[bx + 0x21]
  060807  0D37: 2ae4             sub ah, ah
  060809  0D39: 3b46f6           cmp ax, word ptr [bp - 0xa]
  06080C  0D3C: 7fb6             jg 0xcf4
  06080E  0D3E: ff76fa           push word ptr [bp - 6]
  060811  0D41: ff76f8           push word ptr [bp - 8]
  060814  0D44: 9a6a011f19       lcall 0x191f, 0x16a
  060819  0D49: 0bc0             or ax, ax
  06081B  0D4B: 7e04             jle 0xd51
  06081D  0D4D: 48               dec ax
  06081E  0D4E: 8946fe           mov word ptr [bp - 2], ax
  060821  0D51: 8b46fa           mov ax, word ptr [bp - 6]
  060824  0D54: 0b46f8           or ax, word ptr [bp - 8]
  060827  0D57: 740b             je 0xd64
  060829  0D59: ff76fa           push word ptr [bp - 6]
  06082C  0D5C: ff76f8           push word ptr [bp - 8]
  06082F  0D5F: 9aa8011f19       lcall 0x191f, 0x1a8
  060834  0D64: 8b46fe           mov ax, word ptr [bp - 2]
  060837  0D67: 5e               pop si
  060838  0D68: c9               leave 
  060839  0D69: cb               retf 

; ---- func_06083A  size=1017  insns=356  prologue=ENTER 0x0060,0  terminal=RETF ----
  06083A  0D6A: c8600000         enter 0x60, 0
  06083E  0D6E: 56               push si
  06083F  0D6F: ff36ae2d         push word ptr [0x2dae]
  060843  0D73: ff36ac2d         push word ptr [0x2dac]
  060847  0D77: ff36aa2d         push word ptr [0x2daa]
  06084B  0D7B: ff36a82d         push word ptr [0x2da8]
  06084F  0D7F: b022             mov al, 0x22
  060851  0D81: 9a84041f18       lcall 0x181f, 0x484
  060856  0D86: ff36de93         push word ptr [0x93de]
  06085A  0D8A: 9a22001f18       lcall 0x181f, 0x22
  06085F  0D8F: 83c402           add sp, 2
  060862  0D92: 52               push dx
  060863  0D93: 50               push ax
  060864  0D94: 8d46b0           lea ax, [bp - 0x50]
  060867  0D97: 16               push ss
  060868  0D98: 50               push ax
  060869  0D99: 9a7e111d0d       lcall 0xd1d, 0x117e
  06086E  0D9E: 83c408           add sp, 8
  060871  0DA1: 8d46b0           lea ax, [bp - 0x50]
  060874  0DA4: 50               push ax
  060875  0DA5: 9a78011f18       lcall 0x181f, 0x178
  06087A  0DAA: 83c402           add sp, 2
  06087D  0DAD: a1149e           mov ax, word ptr [0x9e14]
  060880  0DB0: 2d0000           sub ax, 0
  060883  0DB3: b94a00           mov cx, 0x4a
  060886  0DB6: 99               cdq 
  060887  0DB7: f7f9             idiv cx
  060889  0DB9: 40               inc ax
  06088A  0DBA: 50               push ax
  06088B  0DBB: 8d46b0           lea ax, [bp - 0x50]
  06088E  0DBE: 16               push ss
  06088F  0DBF: 50               push ax
  060890  0DC0: 9a82011f18       lcall 0x181f, 0x182
  060895  0DC5: 83c406           add sp, 6
  060898  0DC8: 6a0f             push 0xf
  06089A  0DCA: 6a05             push 5
  06089C  0DCC: 684001           push 0x140
  06089F  0DCF: 6a00             push 0
  0608A1  0DD1: 8d46b0           lea ax, [bp - 0x50]
  0608A4  0DD4: 16               push ss
  0608A5  0DD5: 50               push ax
  0608A6  0DD6: 9a00011f18       lcall 0x181f, 0x100
  0608AB  0DDB: 83c40c           add sp, 0xc
  0608AE  0DDE: c646b000         mov byte ptr [bp - 0x50], 0
  0608B2  0DE2: ff36e093         push word ptr [0x93e0]
  0608B6  0DE6: 8d46b0           lea ax, [bp - 0x50]
  0608B9  0DE9: 50               push ax
  0608BA  0DEA: 9a6e011f18       lcall 0x181f, 0x16e
  0608BF  0DEF: 83c404           add sp, 4
  0608C2  0DF2: 8d46b0           lea ax, [bp - 0x50]
  0608C5  0DF5: 50               push ax
  0608C6  0DF6: 9a78011f18       lcall 0x181f, 0x178
  0608CB  0DFB: 83c402           add sp, 2
  0608CE  0DFE: 6a0f             push 0xf
  0608D0  0E00: 6a19             push 0x19
  0608D2  0E02: b80a00           mov ax, 0xa
  0608D5  0E05: 8946ac           mov word ptr [bp - 0x54], ax
  0608D8  0E08: 50               push ax
  0608D9  0E09: 8d46b0           lea ax, [bp - 0x50]
  0608DC  0E0C: 16               push ss
  0608DD  0E0D: 50               push ax
  0608DE  0E0E: 9a3c011f18       lcall 0x181f, 0x13c
  0608E3  0E13: 83c40a           add sp, 0xa
  0608E6  0E16: 8946a4           mov word ptr [bp - 0x5c], ax
  0608E9  0E19: 6a0f             push 0xf
  0608EB  0E1B: 6a19             push 0x19
  0608ED  0E1D: 50               push ax
  0608EE  0E1E: ff36169e         push word ptr [0x9e16]
  0608F2  0E22: ff36149e         push word ptr [0x9e14]
  0608F6  0E26: 9a3c011f18       lcall 0x181f, 0x13c
  0608FB  0E2B: 83c40a           add sp, 0xa
  0608FE  0E2E: c41e9e08         les bx, ptr [0x89e]
  060902  0E32: 268a07           mov al, byte ptr es:[bx]
  060905  0E35: 2ae4             sub ah, ah
  060907  0E37: 051b00           add ax, 0x1b
  06090A  0E3A: 8946aa           mov word ptr [bp - 0x56], ax
  06090D  0E3D: c646b000         mov byte ptr [bp - 0x50], 0
  060911  0E41: ff36e293         push word ptr [0x93e2]
  060915  0E45: 8d46b0           lea ax, [bp - 0x50]
  060918  0E48: 50               push ax
  060919  0E49: 9a6e011f18       lcall 0x181f, 0x16e
  06091E  0E4E: 83c404           add sp, 4
  060921  0E51: 8d46b0           lea ax, [bp - 0x50]
  060924  0E54: 50               push ax
  060925  0E55: 9a78011f18       lcall 0x181f, 0x178
  06092A  0E5A: 83c402           add sp, 2
  06092D  0E5D: 6a0f             push 0xf
  06092F  0E5F: ff76aa           push word ptr [bp - 0x56]
  060932  0E62: 6a0a             push 0xa
  060934  0E64: 8d46b0           lea ax, [bp - 0x50]
  060937  0E67: 16               push ss
  060938  0E68: 50               push ax
  060939  0E69: 9a3c011f18       lcall 0x181f, 0x13c
  06093E  0E6E: 83c40a           add sp, 0xa
  060941  0E71: c646b000         mov byte ptr [bp - 0x50], 0
  060945  0E75: c41e149e         les bx, ptr [0x9e14]
  060949  0E79: 26807f2001       cmp byte ptr es:[bx + 0x20], 1
  06094E  0E7E: 1bdb             sbb bx, bx
  060950  0E80: 83e301           and bx, 1
  060953  0E83: 83c303           add bx, 3
  060956  0E86: d1e3             shl bx, 1
  060958  0E88: ffb7de93         push word ptr [bx - 0x6c22]
  06095C  0E8C: 8d46b0           lea ax, [bp - 0x50]
  06095F  0E8F: 50               push ax
  060960  0E90: 9a6e011f18       lcall 0x181f, 0x16e
  060965  0E95: 83c404           add sp, 4
  060968  0E98: 6a0f             push 0xf
  06096A  0E9A: ff76aa           push word ptr [bp - 0x56]
  06096D  0E9D: ff76a4           push word ptr [bp - 0x5c]
  060970  0EA0: 8d46b0           lea ax, [bp - 0x50]
  060973  0EA3: 16               push ss
  060974  0EA4: 50               push ax
  060975  0EA5: 9a3c011f18       lcall 0x181f, 0x13c
  06097A  0EAA: 83c40a           add sp, 0xa
  06097D  0EAD: c41e9e08         les bx, ptr [0x89e]
  060981  0EB1: 268a07           mov al, byte ptr es:[bx]
  060984  0EB4: 2ae4             sub ah, ah
  060986  0EB6: 2d3700           sub ax, 0x37
  060989  0EB9: f7d8             neg ax
  06098B  0EBB: 8946aa           mov word ptr [bp - 0x56], ax
  06098E  0EBE: 1e               push ds
  06098F  0EBF: 68381d           push 0x1d38
  060992  0EC2: 9a14011f18       lcall 0x181f, 0x114
  060997  0EC7: 83c404           add sp, 4
  06099A  0ECA: 050a00           add ax, 0xa
  06099D  0ECD: 8946a4           mov word ptr [bp - 0x5c], ax
  0609A0  0ED0: 6a0f             push 0xf
  0609A2  0ED2: ff76aa           push word ptr [bp - 0x56]
  0609A5  0ED5: 50               push ax
  0609A6  0ED6: ff36e893         push word ptr [0x93e8]
  0609AA  0EDA: 9a22001f18       lcall 0x181f, 0x22
  0609AF  0EDF: 83c402           add sp, 2
  0609B2  0EE2: 52               push dx
  0609B3  0EE3: 50               push ax
  0609B4  0EE4: 9a3c011f18       lcall 0x181f, 0x13c
  0609B9  0EE9: 83c40a           add sp, 0xa
  0609BC  0EEC: 6a0f             push 0xf
  0609BE  0EEE: ff76aa           push word ptr [bp - 0x56]
  0609C1  0EF1: 6a7d             push 0x7d
  0609C3  0EF3: ff36ea93         push word ptr [0x93ea]
  0609C7  0EF7: 9a22001f18       lcall 0x181f, 0x22
  0609CC  0EFC: 83c402           add sp, 2
  0609CF  0EFF: 52               push dx
  0609D0  0F00: 50               push ax
  0609D1  0F01: 9a3c011f18       lcall 0x181f, 0x13c
  0609D6  0F06: 83c40a           add sp, 0xa
  0609D9  0F09: 6a0f             push 0xf
  0609DB  0F0B: ff76aa           push word ptr [bp - 0x56]
  0609DE  0F0E: 68d000           push 0xd0
  0609E1  0F11: ff36ec93         push word ptr [0x93ec]
  0609E5  0F15: 9a22001f18       lcall 0x181f, 0x22
  0609EA  0F1A: 83c402           add sp, 2
  0609ED  0F1D: 52               push dx
  0609EE  0F1E: 50               push ax
  0609EF  0F1F: 9a3c011f18       lcall 0x181f, 0x13c
  0609F4  0F24: 83c40a           add sp, 0xa
  0609F7  0F27: c746aa3d00       mov word ptr [bp - 0x56], 0x3d
  0609FC  0F2C: c746a80000       mov word ptr [bp - 0x58], 0
  060A01  0F31: ff36ae2d         push word ptr [0x2dae]
  060A05  0F35: ff36ac2d         push word ptr [0x2dac]
  060A09  0F39: ff36aa2d         push word ptr [0x2daa]
  060A0D  0F3D: ff36a82d         push word ptr [0x2da8]
  060A11  0F41: 6a00             push 0
  060A13  0F43: 6b5ea814         imul bx, word ptr [bp - 0x58], 0x14
  060A17  0F47: 035eaa           add bx, word ptr [bp - 0x56]
  060A1A  0F4A: 895ea2           mov word ptr [bp - 0x5e], bx
  060A1D  0F4D: 2bc0             sub ax, ax
  060A1F  0F4F: ba3f01           mov dx, 0x13f
  060A22  0F52: 9abc081f19       lcall 0x191f, 0x8bc
  060A27  0F57: ff46a8           inc word ptr [bp - 0x58]
  060A2A  0F5A: 837ea804         cmp word ptr [bp - 0x58], 4
  060A2E  0F5E: 7ed1             jle 0xf31
  060A30  0F60: ff36ae2d         push word ptr [0x2dae]
  060A34  0F64: ff36ac2d         push word ptr [0x2dac]
  060A38  0F68: ff36aa2d         push word ptr [0x2daa]
  060A3C  0F6C: ff36a82d         push word ptr [0x2da8]
  060A40  0F70: 6a00             push 0
  060A42  0F72: 8b56aa           mov dx, word ptr [bp - 0x56]
  060A45  0F75: 8bda             mov bx, dx
  060A47  0F77: 83c350           add bx, 0x50
  060A4A  0F7A: b87300           mov ax, 0x73
  060A4D  0F7D: 8bf3             mov si, bx
  060A4F  0F7F: 9ab2081f19       lcall 0x191f, 0x8b2
  060A54  0F84: ff36ae2d         push word ptr [0x2dae]
  060A58  0F88: ff36ac2d         push word ptr [0x2dac]
  060A5C  0F8C: ff36aa2d         push word ptr [0x2daa]
  060A60  0F90: ff36a82d         push word ptr [0x2da8]
  060A64  0F94: 6a00             push 0
  060A66  0F96: 8b56aa           mov dx, word ptr [bp - 0x56]
  060A69  0F99: 8bde             mov bx, si
  060A6B  0F9B: b8c600           mov ax, 0xc6
  060A6E  0F9E: 9ab2081f19       lcall 0x191f, 0x8b2
  060A73  0FA3: c746a80000       mov word ptr [bp - 0x58], 0
  060A78  0FA8: e9bf00           jmp 0x106a
  060A7B  0FAB: 90               nop 
  060A7C  0FAC: 50               push ax
  060A7D  0FAD: 0e               push cs
  060A7E  0FAE: e88d09           call 0x193e
  060A81  0FB1: 83c402           add sp, 2
  060A84  0FB4: 8946a6           mov word ptr [bp - 0x5a], ax
  060A87  0FB7: 0bc0             or ax, ax
  060A89  0FB9: 7c34             jl 0xfef
  060A8B  0FBB: ff364008         push word ptr [0x840]
  060A8F  0FBF: ff363e08         push word ptr [0x83e]
  060A93  0FC3: ff76a2           push word ptr [bp - 0x5e]
  060A96  0FC6: 051700           add ax, 0x17
  060A99  0FC9: 8d1ea82d         lea bx, [0x2da8]
  060A9D  0FCD: 8b56a4           mov dx, word ptr [bp - 0x5c]
  060AA0  0FD0: 9a54021f18       lcall 0x181f, 0x254
  060AA5  0FD5: 8b76a6           mov si, word ptr [bp - 0x5a]
  060AA8  0FD8: 8bc6             mov ax, si
  060AAA  0FDA: d1e6             shl si, 1
  060AAC  0FDC: 03f0             add si, ax
  060AAE  0FDE: c1e602           shl si, 2
  060AB1  0FE1: c41e3e08         les bx, ptr [0x83e]
  060AB5  0FE5: 268b805201       mov ax, word ptr es:[bx + si + 0x152]
  060ABA  0FEA: 40               inc ax
  060ABB  0FEB: 40               inc ax
  060ABC  0FEC: 0146a4           add word ptr [bp - 0x5c], ax
  060ABF  0FEF: ff46ae           inc word ptr [bp - 0x52]
  060AC2  0FF2: 8b46ae           mov ax, word ptr [bp - 0x52]
  060AC5  0FF5: 3946a0           cmp word ptr [bp - 0x60], ax
  060AC8  0FF8: 7fb2             jg 0xfac
  060ACA  0FFA: c746a4d000       mov word ptr [bp - 0x5c], 0xd0
  060ACF  0FFF: 6a01             push 1
  060AD1  1001: 0e               push cs
  060AD2  1002: e83e09           call 0x1943
  060AD5  1005: 83c402           add sp, 2
  060AD8  1008: 8946a0           mov word ptr [bp - 0x60], ax
  060ADB  100B: c746ae0000       mov word ptr [bp - 0x52], 0
  060AE0  1010: eb49             jmp 0x105b
  060AE2  1012: 050600           add ax, 6
  060AE5  1015: 50               push ax
  060AE6  1016: 0e               push cs
  060AE7  1017: e82409           call 0x193e
  060AEA  101A: 83c402           add sp, 2
  060AED  101D: 8946a6           mov word ptr [bp - 0x5a], ax
  060AF0  1020: 0bc0             or ax, ax
  060AF2  1022: 7c34             jl 0x1058
  060AF4  1024: ff364008         push word ptr [0x840]
  060AF8  1028: ff363e08         push word ptr [0x83e]
  060AFC  102C: ff76a2           push word ptr [bp - 0x5e]
  060AFF  102F: 051700           add ax, 0x17
  060B02  1032: 8d1ea82d         lea bx, [0x2da8]
  060B06  1036: 8b56a4           mov dx, word ptr [bp - 0x5c]
  060B09  1039: 9a54021f18       lcall 0x181f, 0x254
  060B0E  103E: 8b76a6           mov si, word ptr [bp - 0x5a]
  060B11  1041: 8bc6             mov ax, si
  060B13  1043: d1e6             shl si, 1
  060B15  1045: 03f0             add si, ax
  060B17  1047: c1e602           shl si, 2
  060B1A  104A: c41e3e08         les bx, ptr [0x83e]
  060B1E  104E: 268b805201       mov ax, word ptr es:[bx + si + 0x152]
  060B23  1053: 40               inc ax
  060B24  1054: 40               inc ax
  060B25  1055: 0146a4           add word ptr [bp - 0x5c], ax
  060B28  1058: ff46ae           inc word ptr [bp - 0x52]
  060B2B  105B: 8b46ae           mov ax, word ptr [bp - 0x52]
  060B2E  105E: 3946a0           cmp word ptr [bp - 0x60], ax
  060B31  1061: 7faf             jg 0x1012
  060B33  1063: 8346aa14         add word ptr [bp - 0x56], 0x14
  060B37  1067: ff46a8           inc word ptr [bp - 0x58]
  060B3A  106A: c41e149e         les bx, ptr [0x9e14]
  060B3E  106E: 268a4721         mov al, byte ptr es:[bx + 0x21]
  060B42  1072: 2ae4             sub ah, ah
  060B44  1074: 3b46a8           cmp ax, word ptr [bp - 0x58]
  060B47  1077: 7e7d             jle 0x10f6
  060B49  1079: ff76a8           push word ptr [bp - 0x58]
  060B4C  107C: 0e               push cs
  060B4D  107D: e8b908           call 0x1939
  060B50  1080: 83c402           add sp, 2
  060B53  1083: c646b000         mov byte ptr [bp - 0x50], 0
  060B57  1087: 8b46a8           mov ax, word ptr [bp - 0x58]
  060B5A  108A: 40               inc ax
  060B5B  108B: 50               push ax
  060B5C  108C: 8d46b0           lea ax, [bp - 0x50]
  060B5F  108F: 16               push ss
  060B60  1090: 50               push ax
  060B61  1091: 9a82011f18       lcall 0x181f, 0x182
  060B66  1096: 83c406           add sp, 6
  060B69  1099: 8d46b0           lea ax, [bp - 0x50]
  060B6C  109C: 50               push ax
  060B6D  109D: 9adc011f18       lcall 0x181f, 0x1dc
  060B72  10A2: 83c402           add sp, 2
  060B75  10A5: ff76a8           push word ptr [bp - 0x58]
  060B78  10A8: 0e               push cs
  060B79  10A9: e8b008           call 0x195c
  060B7C  10AC: 83c402           add sp, 2
  060B7F  10AF: 52               push dx
  060B80  10B0: 50               push ax
  060B81  10B1: 8d46b0           lea ax, [bp - 0x50]
  060B84  10B4: 16               push ss
  060B85  10B5: 50               push ax
  060B86  10B6: 9ab4111d0d       lcall 0xd1d, 0x11b4
  060B8B  10BB: 83c408           add sp, 8
  060B8E  10BE: 6a0f             push 0xf
  060B90  10C0: 8b46aa           mov ax, word ptr [bp - 0x56]
  060B93  10C3: 050500           add ax, 5
  060B96  10C6: 8946a2           mov word ptr [bp - 0x5e], ax
  060B99  10C9: 050300           add ax, 3
  060B9C  10CC: 50               push ax
  060B9D  10CD: 6a0a             push 0xa
  060B9F  10CF: 8d46b0           lea ax, [bp - 0x50]
  060BA2  10D2: 16               push ss
  060BA3  10D3: 50               push ax
  060BA4  10D4: 9a3c011f18       lcall 0x181f, 0x13c
  060BA9  10D9: 83c40a           add sp, 0xa
  060BAC  10DC: c746a47d00       mov word ptr [bp - 0x5c], 0x7d
  060BB1  10E1: 6a00             push 0
  060BB3  10E3: 0e               push cs
  060BB4  10E4: e85c08           call 0x1943
  060BB7  10E7: 83c402           add sp, 2
  060BBA  10EA: 8946a0           mov word ptr [bp - 0x60], ax
  060BBD  10ED: c746ae0000       mov word ptr [bp - 0x52], 0
  060BC2  10F2: e9fdfe           jmp 0xff2
  060BC5  10F5: 90               nop 
  060BC6  10F6: ff36ae2d         push word ptr [0x2dae]
  060BCA  10FA: ff36ac2d         push word ptr [0x2dac]
  060BCE  10FE: ff36aa2d         push word ptr [0x2daa]
  060BD2  1102: ff36a82d         push word ptr [0x2da8]
  060BD6  1106: 68bd00           push 0xbd
  060BD9  1109: 6a00             push 0
  060BDB  110B: b81801           mov ax, 0x118
  060BDE  110E: baaa00           mov dx, 0xaa
  060BE1  1111: bb3501           mov bx, 0x135
  060BE4  1114: 9ace001f18       lcall 0x181f, 0xce
  060BE9  1119: c41e9e08         les bx, ptr [0x89e]
  060BED  111D: 268a07           mov al, byte ptr es:[bx]
  060BF0  1120: d0e8             shr al, 1
  060BF2  1122: 2ae4             sub ah, ah
  060BF4  1124: 2db400           sub ax, 0xb4
  060BF7  1127: f7d8             neg ax
  060BF9  1129: 8946a2           mov word ptr [bp - 0x5e], ax
  060BFC  112C: 6a0f             push 0xf
  060BFE  112E: 50               push ax
  060BFF  112F: 6a1e             push 0x1e
  060C01  1131: b81801           mov ax, 0x118
  060C04  1134: 8946a4           mov word ptr [bp - 0x5c], ax
  060C07  1137: 50               push ax
  060C08  1138: ff36162e         push word ptr [0x2e16]
  060C0C  113C: 9a22001f18       lcall 0x181f, 0x22
  060C11  1141: 83c402           add sp, 2
  060C14  1144: 52               push dx
  060C15  1145: 50               push ax
  060C16  1146: 9a00011f18       lcall 0x181f, 0x100
  060C1B  114B: 83c40c           add sp, 0xc
  060C1E  114E: 6a00             push 0
  060C20  1150: 684001           push 0x140
  060C23  1153: 68c800           push 0xc8
  060C26  1156: 2bc0             sub ax, ax
  060C28  1158: 99               cdq 
  060C29  1159: 2bdb             sub bx, bx
  060C2B  115B: 9ae2001f18       lcall 0x181f, 0xe2
  060C30  1160: 5e               pop si
  060C31  1161: c9               leave 
  060C32  1162: cb               retf 

; ---- func_060C34  size=171  insns=66  prologue=ENTER 0x0002,0  terminal=RETF ----
  060C34  1164: c8020000         enter 2, 0
  060C38  1168: c41e149e         les bx, ptr [0x9e14]
  060C3C  116C: 268a4721         mov al, byte ptr es:[bx + 0x21]
  060C40  1170: 2ae4             sub ah, ah
  060C42  1172: 3b065ea1         cmp ax, word ptr [0xa15e]
  060C46  1176: 7f40             jg 0x11b8
  060C48  1178: a35ea1           mov word ptr [0xa15e], ax
  060C4B  117B: 50               push ax
  060C4C  117C: 0e               push cs
  060C4D  117D: e8b907           call 0x1939
  060C50  1180: 83c402           add sp, 2
  060C53  1183: 6a01             push 1
  060C55  1185: 6a00             push 0
  060C57  1187: c41e149e         les bx, ptr [0x9e14]
  060C5B  118B: 26ff7722         push word ptr es:[bx + 0x22]
  060C5F  118F: ff3660a1         push word ptr [0xa160]
  060C63  1193: 0e               push cs
  060C64  1194: e89307           call 0x192a
  060C67  1197: 83c408           add sp, 8
  060C6A  119A: 8946fe           mov word ptr [bp - 2], ax
  060C6D  119D: 0bc0             or ax, ax
  060C6F  119F: 7c68             jl 0x1209
  060C71  11A1: 3de803           cmp ax, 0x3e8
  060C74  11A4: 7463             je 0x1209
  060C76  11A6: c41e149e         les bx, ptr [0x9e14]
  060C7A  11AA: 26fe4721         inc byte ptr es:[bx + 0x21]
  060C7E  11AE: ff76fe           push word ptr [bp - 2]
  060C81  11B1: 0e               push cs
  060C82  11B2: e89d07           call 0x1952
  060C85  11B5: eb4f             jmp 0x1206
  060C87  11B7: 90               nop 
  060C88  11B8: ff365ea1         push word ptr [0xa15e]
  060C8C  11BC: 0e               push cs
  060C8D  11BD: e87907           call 0x1939
  060C90  11C0: 83c402           add sp, 2
  060C93  11C3: c41e149e         les bx, ptr [0x9e14]
  060C97  11C7: 26807f2101       cmp byte ptr es:[bx + 0x21], 1
  060C9C  11CC: 7606             jbe 0x11d4
  060C9E  11CE: b80100           mov ax, 1
  060CA1  11D1: eb03             jmp 0x11d6
  060CA3  11D3: 90               nop 
  060CA4  11D4: 2bc0             sub ax, ax
  060CA6  11D6: 50               push ax
  060CA7  11D7: 6a00             push 0
  060CA9  11D9: c41e189e         les bx, ptr [0x9e18]
  060CAD  11DD: 26ff37           push word ptr es:[bx]
  060CB0  11E0: ff3660a1         push word ptr [0xa160]
  060CB4  11E4: 0e               push cs
  060CB5  11E5: e84207           call 0x192a
  060CB8  11E8: 83c408           add sp, 8
  060CBB  11EB: 0bc0             or ax, ax
  060CBD  11ED: 7c1a             jl 0x1209
  060CBF  11EF: 3de803           cmp ax, 0x3e8
  060CC2  11F2: 740a             je 0x11fe
  060CC4  11F4: c41e189e         les bx, ptr [0x9e18]
  060CC8  11F8: 268907           mov word ptr es:[bx], ax
  060CCB  11FB: eb0c             jmp 0x1209
  060CCD  11FD: 90               nop 
  060CCE  11FE: ff365ea1         push word ptr [0xa15e]
  060CD2  1202: 0e               push cs
  060CD3  1203: e82e07           call 0x1934
  060CD6  1206: 83c402           add sp, 2
  060CD9  1209: 0e               push cs
  060CDA  120A: e85907           call 0x1966
  060CDD  120D: c9               leave 
  060CDE  120E: cb               retf 

; ---- func_060CE0  size=171  insns=54  prologue=ENTER 0x0008,0  terminal=RETF ----
  060CE0  1210: c8080000         enter 8, 0
  060CE4  1214: 680008           push 0x800
  060CE7  1217: ff36a008         push word ptr [0x8a0]
  060CEB  121B: ff369e08         push word ptr [0x89e]
  060CEF  121F: 9ac4071f1a       lcall 0x1a1f, 0x7c4
  060CF4  1224: 83c406           add sp, 6
  060CF7  1227: 2bd2             sub dx, dx
  060CF9  1229: 8956fe           mov word ptr [bp - 2], dx
  060CFC  122C: 8d1e7c08         lea bx, [0x87c]
  060D00  1230: 8b4606           mov ax, word ptr [bp + 6]
  060D03  1233: 9a82011f19       lcall 0x191f, 0x182
  060D08  1238: 8946fa           mov word ptr [bp - 6], ax
  060D0B  123B: 8956fc           mov word ptr [bp - 4], dx
  060D0E  123E: 0bd0             or dx, ax
  060D10  1240: 7450             je 0x1292
  060D12  1242: c45efa           les bx, ptr [bp - 6]
  060D15  1245: 26804f0a01       or byte ptr es:[bx + 0xa], 1
  060D1A  124A: 26c747220a00     mov word ptr es:[bx + 0x22], 0xa
  060D20  1250: c746f80000       mov word ptr [bp - 8], 0
  060D25  1255: 8b46f8           mov ax, word ptr [bp - 8]
  060D28  1258: 40               inc ax
  060D29  1259: 50               push ax
  060D2A  125A: 8b5ef8           mov bx, word ptr [bp - 8]
  060D2D  125D: d1e3             shl bx, 1
  060D2F  125F: ffb7c097         push word ptr [bx - 0x6840]
  060D33  1263: 9a22001f18       lcall 0x181f, 0x22
  060D38  1268: 83c402           add sp, 2
  060D3B  126B: 52               push dx
  060D3C  126C: 50               push ax
  060D3D  126D: ff76fc           push word ptr [bp - 4]
  060D40  1270: ff76fa           push word ptr [bp - 6]
  060D43  1273: 9a76011f19       lcall 0x191f, 0x176
  060D48  1278: 83c40a           add sp, 0xa
  060D4B  127B: ff46f8           inc word ptr [bp - 8]
  060D4E  127E: 837ef810         cmp word ptr [bp - 8], 0x10
  060D52  1282: 7cd1             jl 0x1255
  060D54  1284: ff76fc           push word ptr [bp - 4]
  060D57  1287: ff76fa           push word ptr [bp - 6]
  060D5A  128A: 9a6a011f19       lcall 0x191f, 0x16a
  060D5F  128F: 8946fe           mov word ptr [bp - 2], ax
  060D62  1292: 8b46fc           mov ax, word ptr [bp - 4]
  060D65  1295: 0b46fa           or ax, word ptr [bp - 6]
  060D68  1298: 740b             je 0x12a5
  060D6A  129A: ff76fc           push word ptr [bp - 4]
  060D6D  129D: ff76fa           push word ptr [bp - 6]
  060D70  12A0: 9aa8011f19       lcall 0x191f, 0x1a8
  060D75  12A5: 680008           push 0x800
  060D78  12A8: ff368c26         push word ptr [0x268c]
  060D7C  12AC: ff368a26         push word ptr [0x268a]
  060D80  12B0: 9ac4071f1a       lcall 0x1a1f, 0x7c4
  060D85  12B5: 8b46fe           mov ax, word ptr [bp - 2]
  060D88  12B8: 48               dec ax
  060D89  12B9: c9               leave 
  060D8A  12BA: cb               retf 

; ---- func_060D8C  size=312  insns=125  prologue=ENTER 0x0010,0  terminal=RETF ----
  060D8C  12BC: c8100000         enter 0x10, 0
  060D90  12C0: 56               push si
  060D91  12C1: c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  060D96  12C6: c41e149e         les bx, ptr [0x9e14]
  060D9A  12CA: 268a4721         mov al, byte ptr es:[bx + 0x21]
  060D9E  12CE: 2ae4             sub ah, ah
  060DA0  12D0: 3b065ea1         cmp ax, word ptr [0xa15e]
  060DA4  12D4: 7f03             jg 0x12d9
  060DA6  12D6: e91401           jmp 0x13ed
  060DA9  12D9: 837e0601         cmp word ptr [bp + 6], 1
  060DAD  12DD: f5               cmc 
  060DAE  12DE: 1bc0             sbb ax, ax
  060DB0  12E0: 250600           and ax, 6
  060DB3  12E3: 8946f8           mov word ptr [bp - 8], ax
  060DB6  12E6: 837e0601         cmp word ptr [bp + 6], 1
  060DBA  12EA: 1bc0             sbb ax, ax
  060DBC  12EC: 24ad             and al, 0xad
  060DBE  12EE: 05d000           add ax, 0xd0
  060DC1  12F1: ff7606           push word ptr [bp + 6]
  060DC4  12F4: 8bf0             mov si, ax
  060DC6  12F6: 0e               push cs
  060DC7  12F7: e84906           call 0x1943
  060DCA  12FA: 83c402           add sp, 2
  060DCD  12FD: 8946fe           mov word ptr [bp - 2], ax
  060DD0  1300: 8976f4           mov word ptr [bp - 0xc], si
  060DD3  1303: c746fa0000       mov word ptr [bp - 6], 0
  060DD8  1308: eb3f             jmp 0x1349
  060DDA  130A: 837ef200         cmp word ptr [bp - 0xe], 0
  060DDE  130E: 7d41             jge 0x1351
  060DE0  1310: 0346f8           add ax, word ptr [bp - 8]
  060DE3  1313: 50               push ax
  060DE4  1314: 0e               push cs
  060DE5  1315: e82606           call 0x193e
  060DE8  1318: 83c402           add sp, 2
  060DEB  131B: 8946f0           mov word ptr [bp - 0x10], ax
  060DEE  131E: a1e807           mov ax, word ptr [0x7e8]
  060DF1  1321: 8b76f0           mov si, word ptr [bp - 0x10]
  060DF4  1324: 8bce             mov cx, si
  060DF6  1326: d1e6             shl si, 1
  060DF8  1328: 03f1             add si, cx
  060DFA  132A: c1e602           shl si, 2
  060DFD  132D: c41e3e08         les bx, ptr [0x83e]
  060E01  1331: 268b885201       mov cx, word ptr es:[bx + si + 0x152]
  060E06  1336: 41               inc cx
  060E07  1337: 41               inc cx
  060E08  1338: 014ef4           add word ptr [bp - 0xc], cx
  060E0B  133B: 3946f4           cmp word ptr [bp - 0xc], ax
  060E0E  133E: 7e06             jle 0x1346
  060E10  1340: 8b46fa           mov ax, word ptr [bp - 6]
  060E13  1343: 8946f2           mov word ptr [bp - 0xe], ax
  060E16  1346: ff46fa           inc word ptr [bp - 6]
  060E19  1349: 8b46fa           mov ax, word ptr [bp - 6]
  060E1C  134C: 3946fe           cmp word ptr [bp - 2], ax
  060E1F  134F: 7fb9             jg 0x130a
  060E21  1351: 837ef200         cmp word ptr [bp - 0xe], 0
  060E25  1355: 7d09             jge 0x1360
  060E27  1357: 837efe06         cmp word ptr [bp - 2], 6
  060E2B  135B: 7c03             jl 0x1360
  060E2D  135D: e98d00           jmp 0x13ed
  060E30  1360: 837ef200         cmp word ptr [bp - 0xe], 0
  060E34  1364: 7c36             jl 0x139c
  060E36  1366: 8b46f2           mov ax, word ptr [bp - 0xe]
  060E39  1369: 8946f6           mov word ptr [bp - 0xa], ax
  060E3C  136C: eb1f             jmp 0x138d
  060E3E  136E: 8b46f6           mov ax, word ptr [bp - 0xa]
  060E41  1371: 0346f8           add ax, word ptr [bp - 8]
  060E44  1374: 8bc8             mov cx, ax
  060E46  1376: 40               inc ax
  060E47  1377: 50               push ax
  060E48  1378: 8bf1             mov si, cx
  060E4A  137A: 0e               push cs
  060E4B  137B: e8c005           call 0x193e
  060E4E  137E: 83c402           add sp, 2
  060E51  1381: 50               push ax
  060E52  1382: 56               push si
  060E53  1383: 0e               push cs
  060E54  1384: e8c605           call 0x194d
  060E57  1387: 83c404           add sp, 4
  060E5A  138A: ff46f6           inc word ptr [bp - 0xa]
  060E5D  138D: 8b46fe           mov ax, word ptr [bp - 2]
  060E60  1390: 48               dec ax
  060E61  1391: 3b46f6           cmp ax, word ptr [bp - 0xa]
  060E64  1394: 7fd8             jg 0x136e
  060E66  1396: 8b46fe           mov ax, word ptr [bp - 2]
  060E69  1399: 48               dec ax
  060E6A  139A: eb46             jmp 0x13e2
  060E6C  139C: ff365ea1         push word ptr [0xa15e]
  060E70  13A0: 0e               push cs
  060E71  13A1: e8b805           call 0x195c
  060E74  13A4: 83c402           add sp, 2
  060E77  13A7: 52               push dx
  060E78  13A8: 50               push ax
  060E79  13A9: 6a00             push 0
  060E7B  13AB: 9a16041f18       lcall 0x181f, 0x416
  060E80  13B0: 83c406           add sp, 6
  060E83  13B3: 837e0600         cmp word ptr [bp + 6], 0
  060E87  13B7: 7405             je 0x13be
  060E89  13B9: 683d1d           push 0x1d3d
  060E8C  13BC: eb03             jmp 0x13c1
  060E8E  13BE: 68471d           push 0x1d47
  060E91  13C1: 0e               push cs
  060E92  13C2: e88305           call 0x1948
  060E95  13C5: 83c402           add sp, 2
  060E98  13C8: 8946f0           mov word ptr [bp - 0x10], ax
  060E9B  13CB: 0bc0             or ax, ax
  060E9D  13CD: 7c1e             jl 0x13ed
  060E9F  13CF: 50               push ax
  060EA0  13D0: 8b46fe           mov ax, word ptr [bp - 2]
  060EA3  13D3: 0346f8           add ax, word ptr [bp - 8]
  060EA6  13D6: 50               push ax
  060EA7  13D7: 0e               push cs
  060EA8  13D8: e87205           call 0x194d
  060EAB  13DB: 83c404           add sp, 4
  060EAE  13DE: 8b46fe           mov ax, word ptr [bp - 2]
  060EB1  13E1: 40               inc ax
  060EB2  13E2: 50               push ax
  060EB3  13E3: ff7606           push word ptr [bp + 6]
  060EB6  13E6: 0e               push cs
  060EB7  13E7: e89505           call 0x197f
  060EBA  13EA: 83c404           add sp, 4
  060EBD  13ED: 0e               push cs
  060EBE  13EE: e87505           call 0x1966
  060EC1  13F1: 5e               pop si
  060EC2  13F2: c9               leave 
  060EC3  13F3: cb               retf 

; ---- func_060EC4  size=110  insns=47  prologue=ENTER 0x0004,0  terminal=RETF ----
  060EC4  13F4: c8040000         enter 4, 0
  060EC8  13F8: a1ea07           mov ax, word ptr [0x7ea]
  060ECB  13FB: 2d3d00           sub ax, 0x3d
  060ECE  13FE: b91400           mov cx, 0x14
  060ED1  1401: 99               cdq 
  060ED2  1402: f7f9             idiv cx
  060ED4  1404: 3d0300           cmp ax, 3
  060ED7  1407: 7e03             jle 0x140c
  060ED9  1409: b80300           mov ax, 3
  060EDC  140C: 50               push ax
  060EDD  140D: 0e               push cs
  060EDE  140E: e82805           call 0x1939
  060EE1  1411: 83c402           add sp, 2
  060EE4  1414: c746fc0000       mov word ptr [bp - 4], 0
  060EE9  1419: 833ee80773       cmp word ptr [0x7e8], 0x73
  060EEE  141E: 7c05             jl 0x1425
  060EF0  1420: c746fc0100       mov word ptr [bp - 4], 1
  060EF5  1425: 813ee807c600     cmp word ptr [0x7e8], 0xc6
  060EFB  142B: 7c05             jl 0x1432
  060EFD  142D: c746fc0200       mov word ptr [bp - 4], 2
  060F02  1432: 8b46fc           mov ax, word ptr [bp - 4]
  060F05  1435: eb1f             jmp 0x1456
  060F07  1437: 90               nop 
  060F08  1438: 0e               push cs
  060F09  1439: e83e05           call 0x197a
  060F0C  143C: c9               leave 
  060F0D  143D: cb               retf 
  060F0E  143E: 837efc02         cmp word ptr [bp - 4], 2
  060F12  1442: 7506             jne 0x144a
  060F14  1444: b80100           mov ax, 1
  060F17  1447: eb03             jmp 0x144c
  060F19  1449: 90               nop 
  060F1A  144A: 2bc0             sub ax, ax
  060F1C  144C: 50               push ax
  060F1D  144D: 0e               push cs
  060F1E  144E: e80605           call 0x1957
  060F21  1451: 83c402           add sp, 2
  060F24  1454: c9               leave 
  060F25  1455: cb               retf 
  060F26  1456: 0bc0             or ax, ax
  060F28  1458: 74de             je 0x1438
  060F2A  145A: 48               dec ax
  060F2B  145B: 7c03             jl 0x1460
  060F2D  145D: 48               dec ax
  060F2E  145E: 7ede             jle 0x143e
  060F30  1460: c9               leave 
  060F31  1461: cb               retf 

; ---- func_060F32  size=137  insns=48  prologue=ENTER 0x0050,0  terminal=RETF ----
  060F32  1462: c8500000         enter 0x50, 0
  060F36  1466: 833eea073d       cmp word ptr [0x7ea], 0x3d
  060F3B  146B: 7c0f             jl 0x147c
  060F3D  146D: 813eea078d00     cmp word ptr [0x7ea], 0x8d
  060F43  1473: 7d07             jge 0x147c
  060F45  1475: 0e               push cs
  060F46  1476: e8f204           call 0x196b
  060F49  1479: c9               leave 
  060F4A  147A: cb               retf 
  060F4B  147B: 90               nop 
  060F4C  147C: 833eea0719       cmp word ptr [0x7ea], 0x19
  060F51  1481: 7c59             jl 0x14dc
  060F53  1483: c41e9e08         les bx, ptr [0x89e]
  060F57  1487: 268a07           mov al, byte ptr es:[bx]
  060F5A  148A: 2ae4             sub ah, ah
  060F5C  148C: d1e0             shl ax, 1
  060F5E  148E: 051d00           add ax, 0x1d
  060F61  1491: 3b06ea07         cmp ax, word ptr [0x7ea]
  060F65  1495: 7e45             jle 0x14dc
  060F67  1497: ff36169e         push word ptr [0x9e16]
  060F6B  149B: ff36149e         push word ptr [0x9e14]
  060F6F  149F: 8d46b0           lea ax, [bp - 0x50]
  060F72  14A2: 16               push ss
  060F73  14A3: 50               push ax
  060F74  14A4: 9a7e111d0d       lcall 0xd1d, 0x117e
  060F79  14A9: 83c408           add sp, 8
  060F7C  14AC: 6a1f             push 0x1f
  060F7E  14AE: 8d1e7c08         lea bx, [0x87c]
  060F82  14B2: 8d06531d         lea ax, [0x1d53]
  060F86  14B6: 8d56b0           lea dx, [bp - 0x50]
  060F89  14B9: 9a20011f19       lcall 0x191f, 0x120
  060F8E  14BE: 0bc0             or ax, ax
  060F90  14C0: 7527             jne 0x14e9
  060F92  14C2: 1e               push ds
  060F93  14C3: 682098           push 0x9820
  060F96  14C6: ff36169e         push word ptr [0x9e16]
  060F9A  14CA: ff36149e         push word ptr [0x9e14]
  060F9E  14CE: 9a7e111d0d       lcall 0xd1d, 0x117e
  060FA3  14D3: 83c408           add sp, 8
  060FA6  14D6: 0e               push cs
  060FA7  14D7: e88c04           call 0x1966
  060FAA  14DA: c9               leave 
  060FAB  14DB: cb               retf 
  060FAC  14DC: 813eea07aa00     cmp word ptr [0x7ea], 0xaa
  060FB2  14E2: 7c05             jl 0x14e9
  060FB4  14E4: c6069da800       mov byte ptr [0xa89d], 0
  060FB9  14E9: c9               leave 
  060FBA  14EA: cb               retf 

; ---- func_060FBC  size=243  insns=85  prologue=ENTER 0x0006,0  terminal=RETF ----
  060FBC  14EC: c8060000         enter 6, 0
  060FC0  14F0: 837e0600         cmp word ptr [bp + 6], 0
  060FC4  14F4: 7d1b             jge 0x1511
  060FC6  14F6: 685d1d           push 0x1d5d
  060FC9  14F9: a0691d           mov al, byte ptr [0x1d69]
  060FCC  14FC: 98               cwde 
  060FCD  14FD: 50               push ax
  060FCE  14FE: 6a00             push 0
  060FD0  1500: 0e               push cs
  060FD1  1501: e82104           call 0x1925
  060FD4  1504: 83c406           add sp, 6
  060FD7  1507: 894606           mov word ptr [bp + 6], ax
  060FDA  150A: 0bc0             or ax, ax
  060FDC  150C: 7d03             jge 0x1511
  060FDE  150E: e9cc00           jmp 0x15dd
  060FE1  1511: 8a4606           mov al, byte ptr [bp + 6]
  060FE4  1514: a2691d           mov byte ptr [0x1d69], al
  060FE7  1517: ff7606           push word ptr [bp + 6]
  060FEA  151A: 0e               push cs
  060FEB  151B: e80204           call 0x1920
  060FEE  151E: 83c402           add sp, 2
  060FF1  1521: 6a00             push 0
  060FF3  1523: 0e               push cs
  060FF4  1524: e81204           call 0x1939
  060FF7  1527: 83c402           add sp, 2
  060FFA  152A: c41e189e         les bx, ptr [0x9e18]
  060FFE  152E: 26813fe703       cmp word ptr es:[bx], 0x3e7
  061003  1533: 750b             jne 0x1540
  061005  1535: a19453           mov ax, word ptr [0x5394]
  061008  1538: 2d1400           sub ax, 0x14
  06100B  153B: 8946fe           mov word ptr [bp - 2], ax
  06100E  153E: eb12             jmp 0x1552
  061010  1540: 26691fca00       imul bx, word ptr es:[bx], 0xca
  061015  1545: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  061019  1549: 2ae4             sub ah, ah
  06101B  154B: 8946fe           mov word ptr [bp - 2], ax
  06101E  154E: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  061022  1552: ff369453         push word ptr [0x5394]
  061026  1556: 50               push ax
  061027  1557: ff76fe           push word ptr [bp - 2]
  06102A  155A: c41e149e         les bx, ptr [0x9e14]
  06102E  155E: 268a4720         mov al, byte ptr es:[bx + 0x20]
  061032  1562: 2ae4             sub ah, ah
  061034  1564: 50               push ax
  061035  1565: 9aca011f1a       lcall 0x1a1f, 0x1ca
  06103A  156A: 83c408           add sp, 8
  06103D  156D: a360a1           mov word ptr [0xa160], ax
  061040  1570: 0e               push cs
  061041  1571: e8f203           call 0x1966
  061044  1574: c6069da801       mov byte ptr [0xa89d], 1
  061049  1579: 9a7a041f18       lcall 0x181f, 0x47a
  06104E  157E: 9a70041f18       lcall 0x181f, 0x470
  061053  1583: 2bc0             sub ax, ax
  061055  1585: 9a66041f18       lcall 0x181f, 0x466
  06105A  158A: 9af6001f18       lcall 0x181f, 0xf6
  06105F  158F: 0bc0             or ax, ax
  061061  1591: 7419             je 0x15ac
  061063  1593: 9ae0031f18       lcall 0x181f, 0x3e0
  061068  1598: eb08             jmp 0x15a2
  06106A  159A: c6069da800       mov byte ptr [0xa89d], 0
  06106F  159F: eb0b             jmp 0x15ac
  061071  15A1: 90               nop 
  061072  15A2: 2d0d00           sub ax, 0xd
  061075  15A5: 74f3             je 0x159a
  061077  15A7: 2d0e00           sub ax, 0xe
  06107A  15AA: 74ee             je 0x159a
  06107C  15AC: 833ef40700       cmp word ptr [0x7f4], 0
  061081  15B1: 7404             je 0x15b7
  061083  15B3: 0e               push cs
  061084  15B4: e8be03           call 0x1975
  061087  15B7: a09da8           mov al, byte ptr [0xa89d]
  06108A  15BA: 98               cwde 
  06108B  15BB: 8bd0             mov dx, ax
  06108D  15BD: 2bc0             sub ax, ax
  06108F  15BF: 9a5c041f18       lcall 0x181f, 0x45c
  061094  15C4: 803e9da800       cmp byte ptr [0xa89d], 0
  061099  15C9: 75b3             jne 0x157e
  06109B  15CB: a19c53           mov ax, word ptr [0x539c]
  06109E  15CE: 48               dec ax
  06109F  15CF: 50               push ax
  0610A0  15D0: 9a08081f18       lcall 0x181f, 0x808
  0610A5  15D5: 83c402           add sp, 2
  0610A8  15D8: 9a6a051f18       lcall 0x181f, 0x56a
  0610AD  15DD: c9               leave 
  0610AE  15DE: cb               retf 

; ---- func_0610B0  size=566  insns=201  prologue=ENTER 0x0064,0  terminal=RETF ----
  0610B0  15E0: c8640000         enter 0x64, 0
  0610B4  15E4: 56               push si
  0610B5  15E5: 833ea0530c       cmp word ptr [0x53a0], 0xc
  0610BA  15EA: 7c1e             jl 0x160a
  0610BC  15EC: c706b09c0c00     mov word ptr [0x9cb0], 0xc
  0610C2  15F2: c706b29c0000     mov word ptr [0x9cb2], 0
  0610C8  15F8: 8d1e7c08         lea bx, [0x87c]
  0610CC  15FC: 8d066a1d         lea ax, [0x1d6a]
  0610D0  1600: 2bd2             sub dx, dx
  0610D2  1602: 9a98091f18       lcall 0x181f, 0x998
  0610D7  1607: 5e               pop si
  0610D8  1608: c9               leave 
  0610D9  1609: cb               retf 
  0610DA  160A: 6a00             push 0
  0610DC  160C: 6a01             push 1
  0610DE  160E: 6a00             push 0
  0610E0  1610: 9aae091f18       lcall 0x181f, 0x9ae
  0610E5  1615: 83c406           add sp, 6
  0610E8  1618: 6a00             push 0
  0610EA  161A: 6a00             push 0
  0610EC  161C: 6aff             push -1
  0610EE  161E: 6aff             push -1
  0610F0  1620: 0e               push cs
  0610F1  1621: e80603           call 0x192a
  0610F4  1624: 83c408           add sp, 8
  0610F7  1627: 8946aa           mov word ptr [bp - 0x56], ax
  0610FA  162A: 0bc0             or ax, ax
  0610FC  162C: 7d03             jge 0x1631
  0610FE  162E: e9e201           jmp 0x1813
  061101  1631: 69d8ca00         imul bx, ax, 0xca
  061105  1635: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  061109  1639: 2ae4             sub ah, ah
  06110B  163B: 50               push ax
  06110C  163C: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  061110  1640: 50               push ax
  061111  1641: 9a120d1f18       lcall 0x181f, 0xd12
  061116  1646: 83c404           add sp, 4
  061119  1649: 0bc0             or ax, ax
  06111B  164B: 7420             je 0x166d
  06111D  164D: 8d1e7c08         lea bx, [0x87c]
  061121  1651: 8d06741d         lea ax, [0x1d74]
  061125  1655: 2bd2             sub dx, dx
  061127  1657: 9a98091f18       lcall 0x181f, 0x998
  06112C  165C: 89469e           mov word ptr [bp - 0x62], ax
  06112F  165F: 0bc0             or ax, ax
  061131  1661: 7d03             jge 0x1666
  061133  1663: e9ad01           jmp 0x1813
  061136  1666: 3d0100           cmp ax, 1
  061139  1669: 7402             je 0x166d
  06113B  166B: 2bc0             sub ax, ax
  06113D  166D: 8946a2           mov word ptr [bp - 0x5e], ax
  061140  1670: 6946aaca00       imul ax, word ptr [bp - 0x56], 0xca
  061145  1675: 05485d           add ax, 0x5d48
  061148  1678: 1e               push ds
  061149  1679: 50               push ax
  06114A  167A: 8d46ac           lea ax, [bp - 0x54]
  06114D  167D: 16               push ss
  06114E  167E: 50               push ax
  06114F  167F: 9a7e111d0d       lcall 0xd1d, 0x117e
  061154  1684: 83c408           add sp, 8
  061157  1687: 687e1d           push 0x1d7e
  06115A  168A: 687c08           push 0x87c
  06115D  168D: 9a28091f19       lcall 0x191f, 0x928
  061162  1692: 83c404           add sp, 4
  061165  1695: 0bc0             or ax, ax
  061167  1697: 7403             je 0x169c
  061169  1699: e9d400           jmp 0x1770
  06116C  169C: 8d46ac           lea ax, [bp - 0x54]
  06116F  169F: 50               push ax
  061170  16A0: 9a78011f18       lcall 0x181f, 0x178
  061175  16A5: 83c402           add sp, 2
  061178  16A8: 9a1c091f19       lcall 0x191f, 0x91c
  06117D  16AD: 50               push ax
  06117E  16AE: 9af6081d0d       lcall 0xd1d, 0x8f6
  061183  16B3: 83c402           add sp, 2
  061186  16B6: 8946fe           mov word ptr [bp - 2], ax
  061189  16B9: ff36a683         push word ptr [0x83a6]
  06118D  16BD: 9aca041f18       lcall 0x181f, 0x4ca
  061192  16C2: 83c402           add sp, 2
  061195  16C5: ff76fe           push word ptr [bp - 2]
  061198  16C8: 6a01             push 1
  06119A  16CA: 9ad4041f18       lcall 0x181f, 0x4d4
  06119F  16CF: 83c404           add sp, 4
  0611A2  16D2: 8946a8           mov word ptr [bp - 0x58], ax
  0611A5  16D5: c746a40000       mov word ptr [bp - 0x5c], 0
  0611AA  16DA: eb08             jmp 0x16e4
  0611AC  16DC: 9a1c091f19       lcall 0x191f, 0x91c
  0611B1  16E1: ff46a4           inc word ptr [bp - 0x5c]
  0611B4  16E4: 8b46a8           mov ax, word ptr [bp - 0x58]
  0611B7  16E7: 3946a4           cmp word ptr [bp - 0x5c], ax
  0611BA  16EA: 7cf0             jl 0x16dc
  0611BC  16EC: 1e               push ds
  0611BD  16ED: 683c83           push 0x833c
  0611C0  16F0: 8d46ac           lea ax, [bp - 0x54]
  0611C3  16F3: 16               push ss
  0611C4  16F4: 50               push ax
  0611C5  16F5: 9ab4111d0d       lcall 0xd1d, 0x11b4
  0611CA  16FA: 83c408           add sp, 8
  0611CD  16FD: c746a60000       mov word ptr [bp - 0x5a], 0
  0611D2  1702: 2bc0             sub ax, ax
  0611D4  1704: 8946a0           mov word ptr [bp - 0x60], ax
  0611D7  1707: 8946a4           mov word ptr [bp - 0x5c], ax
  0611DA  170A: eb14             jmp 0x1720
  0611DC  170C: 8d46ac           lea ax, [bp - 0x54]
  0611DF  170F: 50               push ax
  0611E0  1710: 9a42081d0d       lcall 0xd1d, 0x842
  0611E5  1715: 83c402           add sp, 2
  0611E8  1718: 8bf0             mov si, ax
  0611EA  171A: fe42ab           inc byte ptr [bp + si - 0x55]
  0611ED  171D: ff46a4           inc word ptr [bp - 0x5c]
  0611F0  1720: 837ea000         cmp word ptr [bp - 0x60], 0
  0611F4  1724: 7544             jne 0x176a
  0611F6  1726: 8b46a4           mov ax, word ptr [bp - 0x5c]
  0611F9  1729: 3906a053         cmp word ptr [0x53a0], ax
  0611FD  172D: 7e3b             jle 0x176a
  0611FF  172F: 6bc04a           imul ax, ax, 0x4a
  061202  1732: 050000           add ax, 0
  061205  1735: 68221b           push 0x1b22
  061208  1738: 50               push ax
  061209  1739: 8d46ac           lea ax, [bp - 0x54]
  06120C  173C: 16               push ss
  06120D  173D: 50               push ax
  06120E  173E: 9a54111d0d       lcall 0xd1d, 0x1154
  061213  1743: 83c408           add sp, 8
  061216  1746: 0bc0             or ax, ax
  061218  1748: 75d3             jne 0x171d
  06121A  174A: c746a00100       mov word ptr [bp - 0x60], 1
  06121F  174F: 3946a6           cmp word ptr [bp - 0x5a], ax
  061222  1752: 75b8             jne 0x170c
  061224  1754: 68891d           push 0x1d89
  061227  1757: 8d46ac           lea ax, [bp - 0x54]
  06122A  175A: 50               push ax
  06122B  175B: 9aa4071d0d       lcall 0xd1d, 0x7a4
  061230  1760: 83c404           add sp, 4
  061233  1763: c746a60100       mov word ptr [bp - 0x5a], 1
  061238  1768: ebb3             jmp 0x171d
  06123A  176A: 837ea000         cmp word ptr [bp - 0x60], 0
  06123E  176E: 7592             jne 0x1702
  061240  1770: 6a1f             push 0x1f
  061242  1772: 8d1e7c08         lea bx, [0x87c]
  061246  1776: 8d068c1d         lea ax, [0x1d8c]
  06124A  177A: 8d56ac           lea dx, [bp - 0x54]
  06124D  177D: 9a20011f19       lcall 0x191f, 0x120
  061252  1782: 0bc0             or ax, ax
  061254  1784: 7403             je 0x1789
  061256  1786: e98a00           jmp 0x1813
  061259  1789: a1a053           mov ax, word ptr [0x53a0]
  06125C  178C: 8946fc           mov word ptr [bp - 4], ax
  06125F  178F: 50               push ax
  061260  1790: 0e               push cs
  061261  1791: e88c01           call 0x1920
  061264  1794: 83c402           add sp, 2
  061267  1797: 1e               push ds
  061268  1798: 682098           push 0x9820
  06126B  179B: ff36169e         push word ptr [0x9e16]
  06126F  179F: ff36149e         push word ptr [0x9e14]
  061273  17A3: 9a7e111d0d       lcall 0xd1d, 0x117e
  061278  17A8: 83c408           add sp, 8
  06127B  17AB: 8a46a2           mov al, byte ptr [bp - 0x5e]
  06127E  17AE: c41e149e         les bx, ptr [0x9e14]
  061282  17B2: 26884720         mov byte ptr es:[bx + 0x20], al
  061286  17B6: 26c6472102       mov byte ptr es:[bx + 0x21], 2
  06128B  17BB: 6a00             push 0
  06128D  17BD: 0e               push cs
  06128E  17BE: e87801           call 0x1939
  061291  17C1: 83c402           add sp, 2
  061294  17C4: ff76aa           push word ptr [bp - 0x56]
  061297  17C7: 0e               push cs
  061298  17C8: e88701           call 0x1952
  06129B  17CB: 83c402           add sp, 2
  06129E  17CE: 6a00             push 0
  0612A0  17D0: 6a02             push 2
  0612A2  17D2: 6a00             push 0
  0612A4  17D4: 9aae091f18       lcall 0x181f, 0x9ae
  0612A9  17D9: 83c406           add sp, 6
  0612AC  17DC: 6a00             push 0
  0612AE  17DE: 6a00             push 0
  0612B0  17E0: 6aff             push -1
  0612B2  17E2: 6aff             push -1
  0612B4  17E4: 0e               push cs
  0612B5  17E5: e84201           call 0x192a
  0612B8  17E8: 83c408           add sp, 8
  0612BB  17EB: 8946aa           mov word ptr [bp - 0x56], ax
  0612BE  17EE: 0bc0             or ax, ax
  0612C0  17F0: 7c21             jl 0x1813
  0612C2  17F2: 6a01             push 1
  0612C4  17F4: 0e               push cs
  0612C5  17F5: e84101           call 0x1939
  0612C8  17F8: 83c402           add sp, 2
  0612CB  17FB: ff76aa           push word ptr [bp - 0x56]
  0612CE  17FE: 0e               push cs
  0612CF  17FF: e85001           call 0x1952
  0612D2  1802: 83c402           add sp, 2
  0612D5  1805: ff06a053         inc word ptr [0x53a0]
  0612D9  1809: ff76fc           push word ptr [bp - 4]
  0612DC  180C: 0e               push cs
  0612DD  180D: e81f01           call 0x192f
  0612E0  1810: 83c402           add sp, 2
  0612E3  1813: 5e               pop si
  0612E4  1814: c9               leave 
  0612E5  1815: cb               retf 

; ---- func_0612E6  size=366  insns=118  prologue=ENTER 0x0006,0  terminal=JMP-tail ----
  0612E6  1816: c8060000         enter 6, 0
  0612EA  181A: 57               push di
  0612EB  181B: 56               push si
  0612EC  181C: 68961d           push 0x1d96
  0612EF  181F: 6a00             push 0
  0612F1  1821: 6a00             push 0
  0612F3  1823: 0e               push cs
  0612F4  1824: e8fe00           call 0x1925
  0612F7  1827: 83c406           add sp, 6
  0612FA  182A: 8946fe           mov word ptr [bp - 2], ax
  0612FD  182D: 0bc0             or ax, ax
  0612FF  182F: 7d03             jge 0x1834
  061301  1831: e9e700           jmp 0x191b
  061304  1834: 50               push ax
  061305  1835: 0e               push cs
  061306  1836: e8e700           call 0x1920
  061309  1839: 83c402           add sp, 2
  06130C  183C: ff36169e         push word ptr [0x9e16]
  061310  1840: ff36149e         push word ptr [0x9e14]
  061314  1844: 6a00             push 0
  061316  1846: 9a16041f18       lcall 0x181f, 0x416
  06131B  184B: 83c406           add sp, 6
  06131E  184E: 8d1ea21d         lea bx, [0x1da2]
  061322  1852: 9afe031f18       lcall 0x181f, 0x3fe
  061327  1857: 48               dec ax
  061328  1858: 7403             je 0x185d
  06132A  185A: e9be00           jmp 0x191b
  06132D  185D: c746fa0000       mov word ptr [bp - 6], 0
  061332  1862: eb1c             jmp 0x1880
  061334  1864: 8b46fe           mov ax, word ptr [bp - 2]
  061337  1867: 3946fc           cmp word ptr [bp - 4], ax
  06133A  186A: 7e11             jle 0x187d
  06133C  186C: ff4efc           dec word ptr [bp - 4]
  06133F  186F: ff76fc           push word ptr [bp - 4]
  061342  1872: ff76fa           push word ptr [bp - 6]
  061345  1875: 9a62081f18       lcall 0x181f, 0x862
  06134A  187A: 83c404           add sp, 4
  06134D  187D: ff46fa           inc word ptr [bp - 6]
  061350  1880: 8b46fa           mov ax, word ptr [bp - 6]
  061353  1883: 39069c53         cmp word ptr [0x539c], ax
  061357  1887: 7e5b             jle 0x18e4
  061359  1889: 6bd81c           imul bx, ax, 0x1c
  06135C  188C: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  061360  1890: 2aff             sub bh, bh
  061362  1892: 8bc3             mov ax, bx
  061364  1894: d1e3             shl bx, 1
  061366  1896: 03d8             add bx, ax
  061368  1898: d1e3             shl bx, 1
  06136A  189A: 03d8             add bx, ax
  06136C  189C: d1e3             shl bx, 1
  06136E  189E: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  061373  18A3: 74d8             je 0x187d
  061375  18A5: ff76fa           push word ptr [bp - 6]
  061378  18A8: 9a58081f18       lcall 0x181f, 0x858
  06137D  18AD: 83c402           add sp, 2
  061380  18B0: 8946fc           mov word ptr [bp - 4], ax
  061383  18B3: 3b46fe           cmp ax, word ptr [bp - 2]
  061386  18B6: 75ac             jne 0x1864
  061388  18B8: 6a00             push 0
  06138A  18BA: ff76fa           push word ptr [bp - 6]
  06138D  18BD: 9a62081f18       lcall 0x181f, 0x862
  061392  18C2: 83c404           add sp, 4
  061395  18C5: 6a00             push 0
  061397  18C7: ff76fa           push word ptr [bp - 6]
  06139A  18CA: 9ab2081f18       lcall 0x181f, 0x8b2
  06139F  18CF: 83c404           add sp, 4
  0613A2  18D2: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  0613A6  18D6: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  0613AB  18DB: 75a0             jne 0x187d
  0613AD  18DD: c6874c3100       mov byte ptr [bx + 0x314c], 0
  0613B2  18E2: eb99             jmp 0x187d
  0613B4  18E4: 8b46fe           mov ax, word ptr [bp - 2]
  0613B7  18E7: 8946fc           mov word ptr [bp - 4], ax
  0613BA  18EA: eb22             jmp 0x190e
  0613BC  18EC: 6b46fc4a         imul ax, word ptr [bp - 4], 0x4a
  0613C0  18F0: 8bc8             mov cx, ax
  0613C2  18F2: 054a00           add ax, 0x4a
  0613C5  18F5: ba221b           mov dx, 0x1b22
  0613C8  18F8: 8bd9             mov bx, cx
  0613CA  18FA: 8ec2             mov es, dx
  0613CC  18FC: 1e               push ds
  0613CD  18FD: 8dbf0000         lea di, [bx]
  0613D1  1901: 8bf0             mov si, ax
  0613D3  1903: 8eda             mov ds, dx
  0613D5  1905: b92500           mov cx, 0x25
  0613D8  1908: f3a5             rep movsw word ptr es:[di], word ptr [si]
  0613DA  190A: 1f               pop ds
  0613DB  190B: ff46fc           inc word ptr [bp - 4]
  0613DE  190E: a1a053           mov ax, word ptr [0x53a0]
  0613E1  1911: 48               dec ax
  0613E2  1912: 3b46fc           cmp ax, word ptr [bp - 4]
  0613E5  1915: 7fd5             jg 0x18ec
  0613E7  1917: ff0ea053         dec word ptr [0x53a0]
  0613EB  191B: 5e               pop si
  0613EC  191C: 5f               pop di
  0613ED  191D: c9               leave 
  0613EE  191E: cb               retf 
  0613EF  191F: 90               nop 
  0613F0  1920: eace021f19       ljmp 0x191f:0x2ce
  0613F5  1925: eadc021f19       ljmp 0x191f:0x2dc
  0613FA  192A: eaf8021f19       ljmp 0x191f:0x2f8
  0613FF  192F: ea8e031f19       ljmp 0x191f:0x38e
  061404  1934: ea3c0a1f19       ljmp 0x191f:0xa3c
  061409  1939: ea4a0a1f19       ljmp 0x191f:0xa4a
  06140E  193E: ea1c021f1a       ljmp 0x1a1f:0x21c
  061413  1943: ea2a021f1a       ljmp 0x1a1f:0x22a
  061418  1948: ea1c071f1a       ljmp 0x1a1f:0x71c
  06141D  194D: ea2a071f1a       ljmp 0x1a1f:0x72a
  061422  1952: ea38071f1a       ljmp 0x1a1f:0x738
  061427  1957: ea46071f1a       ljmp 0x1a1f:0x746
  06142C  195C: ea54071f1a       ljmp 0x1a1f:0x754
  061431  1961: ea62071f1a       ljmp 0x1a1f:0x762
  061436  1966: ea70071f1a       ljmp 0x1a1f:0x770
  06143B  196B: ea7e071f1a       ljmp 0x1a1f:0x77e
  061440  1970: ea8c071f1a       ljmp 0x1a1f:0x78c
  061445  1975: ea9a071f1a       ljmp 0x1a1f:0x79a
  06144A  197A: eaa8071f1a       ljmp 0x1a1f:0x7a8
  06144F  197F: eab6071f1a       ljmp 0x1a1f:0x7b6

; ---- func_061454  size=2121  insns=722  prologue=ENTER 0x003C,0  terminal=RETF ----
  061454  1984: c83c0000         enter 0x3c, 0
  061458  1988: 57               push di
  061459  1989: 56               push si
  06145A  198A: c746c60100       mov word ptr [bp - 0x3a], 1
  06145F  198F: 2bc0             sub ax, ax
  061461  1991: 8946f4           mov word ptr [bp - 0xc], ax
  061464  1994: 8946ca           mov word ptr [bp - 0x36], ax
  061467  1997: 8946f0           mov word ptr [bp - 0x10], ax
  06146A  199A: 8946d2           mov word ptr [bp - 0x2e], ax
  06146D  199D: 8946ce           mov word ptr [bp - 0x32], ax
  061470  19A0: 8946fe           mov word ptr [bp - 2], ax
  061473  19A3: 8946d4           mov word ptr [bp - 0x2c], ax
  061476  19A6: a19653           mov ax, word ptr [0x5396]
  061479  19A9: 39069453         cmp word ptr [0x5394], ax
  06147D  19AD: 751b             jne 0x19ca
  06147F  19AF: 833e945304       cmp word ptr [0x5394], 4
  061484  19B4: 7d14             jge 0x19ca
  061486  19B6: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  06148B  19BB: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  061490  19C0: 7508             jne 0x19ca
  061492  19C2: c746f80100       mov word ptr [bp - 8], 1
  061497  19C7: eb06             jmp 0x19cf
  061499  19C9: 90               nop 
  06149A  19CA: c746f80000       mov word ptr [bp - 8], 0
  06149F  19CF: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0614A3  19D3: 895ec4           mov word ptr [bp - 0x3c], bx
  0614A6  19D6: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  0614AB  19DB: 7505             jne 0x19e2
  0614AD  19DD: b80100           mov ax, 1
  0614B0  19E0: eb02             jmp 0x19e4
  0614B2  19E2: 2bc0             sub ax, ax
  0614B4  19E4: 8946cc           mov word ptr [bp - 0x34], ax
  0614B7  19E7: 0bc0             or ax, ax
  0614B9  19E9: 740b             je 0x19f6
  0614BB  19EB: 80bf5b3116       cmp byte ptr [bx + 0x315b], 0x16
  0614C0  19F0: 7504             jne 0x19f6
  0614C2  19F2: 40               inc ax
  0614C3  19F3: 8946cc           mov word ptr [bp - 0x34], ax
  0614C6  19F6: 6a07             push 7
  0614C8  19F8: ff369453         push word ptr [0x5394]
  0614CC  19FC: 9ab4071f18       lcall 0x181f, 0x7b4
  0614D1  1A01: 83c404           add sp, 4
  0614D4  1A04: 0bc0             or ax, ax
  0614D6  1A06: 740e             je 0x1a16
  0614D8  1A08: 837ecc00         cmp word ptr [bp - 0x34], 0
  0614DC  1A0C: 7408             je 0x1a16
  0614DE  1A0E: c746d20100       mov word ptr [bp - 0x2e], 1
  0614E3  1A13: ff46cc           inc word ptr [bp - 0x34]
  0614E6  1A16: fe06c61d         inc byte ptr [0x1dc6]
  0614EA  1A1A: ff36a683         push word ptr [0x83a6]
  0614EE  1A1E: 9aca041f18       lcall 0x181f, 0x4ca
  0614F3  1A23: 83c402           add sp, 2
  0614F6  1A26: 6a09             push 9
  0614F8  1A28: 6a01             push 1
  0614FA  1A2A: 9ad4041f18       lcall 0x181f, 0x4d4
  0614FF  1A2F: 83c404           add sp, 4
  061502  1A32: 8946fa           mov word ptr [bp - 6], ax
  061505  1A35: 8b4ed4           mov cx, word ptr [bp - 0x2c]
  061508  1A38: 41               inc cx
  061509  1A39: 83f903           cmp cx, 3
  06150C  1A3C: 7e03             jle 0x1a41
  06150E  1A3E: b90300           mov cx, 3
  061511  1A41: 894ed4           mov word ptr [bp - 0x2c], cx
  061514  1A44: 3bc8             cmp cx, ax
  061516  1A46: 7d02             jge 0x1a4a
  061518  1A48: 8bc8             mov cx, ax
  06151A  1A4A: 894efa           mov word ptr [bp - 6], cx
  06151D  1A4D: 6a64             push 0x64
  06151F  1A4F: 6a01             push 1
  061521  1A51: 9ad4041f18       lcall 0x181f, 0x4d4
  061526  1A56: 83c404           add sp, 4
  061529  1A59: 8b4ecc           mov cx, word ptr [bp - 0x34]
  06152C  1A5C: 8bd1             mov dx, cx
  06152E  1A5E: c1e102           shl cx, 2
  061531  1A61: 03ca             add cx, dx
  061533  1A63: d1e1             shl cx, 1
  061535  1A65: 03c1             add ax, cx
  061537  1A67: 8946f6           mov word ptr [bp - 0xa], ax
  06153A  1A6A: ff760a           push word ptr [bp + 0xa]
  06153D  1A6D: ff7608           push word ptr [bp + 8]
  061540  1A70: 9a8c071f18       lcall 0x181f, 0x78c
  061545  1A75: 83c404           add sp, 4
  061548  1A78: 8946f2           mov word ptr [bp - 0xe], ax
  06154B  1A7B: 837efa05         cmp word ptr [bp - 6], 5
  06154F  1A7F: 751d             jne 0x1a9e
  061551  1A81: 8b46cc           mov ax, word ptr [bp - 0x34]
  061554  1A84: 40               inc ax
  061555  1A85: 50               push ax
  061556  1A86: 6a01             push 1
  061558  1A88: 9ad4041f18       lcall 0x181f, 0x4d4
  06155D  1A8D: 83c404           add sp, 4
  061560  1A90: 48               dec ax
  061561  1A91: 740b             je 0x1a9e
  061563  1A93: 837ed200         cmp word ptr [bp - 0x2e], 0
  061567  1A97: 758d             jne 0x1a26
  061569  1A99: c746fa0600       mov word ptr [bp - 6], 6
  06156E  1A9E: 837efa08         cmp word ptr [bp - 6], 8
  061572  1AA2: 7520             jne 0x1ac4
  061574  1AA4: 8b46cc           mov ax, word ptr [bp - 0x34]
  061577  1AA7: 40               inc ax
  061578  1AA8: 50               push ax
  061579  1AA9: 6a01             push 1
  06157B  1AAB: 9ad4041f18       lcall 0x181f, 0x4d4
  061580  1AB0: 83c404           add sp, 4
  061583  1AB3: 48               dec ax
  061584  1AB4: 740e             je 0x1ac4
  061586  1AB6: 837ed200         cmp word ptr [bp - 0x2e], 0
  06158A  1ABA: 7403             je 0x1abf
  06158C  1ABC: e967ff           jmp 0x1a26
  06158F  1ABF: c746fa0600       mov word ptr [bp - 6], 6
  061594  1AC4: 837efa01         cmp word ptr [bp - 6], 1
  061598  1AC8: 754d             jne 0x1b17
  06159A  1ACA: 837ef218         cmp word ptr [bp - 0xe], 0x18
  06159E  1ACE: 7d10             jge 0x1ae0
  0615A0  1AD0: 8a46f2           mov al, byte ptr [bp - 0xe]
  0615A3  1AD3: 2407             and al, 7
  0615A5  1AD5: 3c04             cmp al, 4
  0615A7  1AD7: 7c07             jl 0x1ae0
  0615A9  1AD9: c746fc0100       mov word ptr [bp - 4], 1
  0615AE  1ADE: eb05             jmp 0x1ae5
  0615B0  1AE0: c746fc0000       mov word ptr [bp - 4], 0
  0615B5  1AE5: 837efc00         cmp word ptr [bp - 4], 0
  0615B9  1AE9: 7407             je 0x1af2
  0615BB  1AEB: 803ec61d04       cmp byte ptr [0x1dc6], 4
  0615C0  1AF0: 7319             jae 0x1b0b
  0615C2  1AF2: 837ed200         cmp word ptr [bp - 0x2e], 0
  0615C6  1AF6: 7513             jne 0x1b0b
  0615C8  1AF8: 837ef60a         cmp word ptr [bp - 0xa], 0xa
  0615CC  1AFC: 7f08             jg 0x1b06
  0615CE  1AFE: c746fa0500       mov word ptr [bp - 6], 5
  0615D3  1B03: eb06             jmp 0x1b0b
  0615D5  1B05: 90               nop 
  0615D6  1B06: c746fa0600       mov word ptr [bp - 6], 6
  0615DB  1B0B: f606825301       test byte ptr [0x5382], 1
  0615E0  1B10: 7405             je 0x1b17
  0615E2  1B12: c746fa0200       mov word ptr [bp - 6], 2
  0615E7  1B17: 837efa02         cmp word ptr [bp - 6], 2
  0615EB  1B1B: 7403             je 0x1b20
  0615ED  1B1D: e9ed00           jmp 0x1c0d
  0615F0  1B20: 837ef21b         cmp word ptr [bp - 0xe], 0x1b
  0615F4  1B24: 7415             je 0x1b3b
  0615F6  1B26: 837ef21c         cmp word ptr [bp - 0xe], 0x1c
  0615FA  1B2A: 740f             je 0x1b3b
  0615FC  1B2C: 837ef218         cmp word ptr [bp - 0xe], 0x18
  061600  1B30: 7d10             jge 0x1b42
  061602  1B32: 8a46f2           mov al, byte ptr [bp - 0xe]
  061605  1B35: 2407             and al, 7
  061607  1B37: 3c01             cmp al, 1
  061609  1B39: 7507             jne 0x1b42
  06160B  1B3B: c746fc0100       mov word ptr [bp - 4], 1
  061610  1B40: eb05             jmp 0x1b47
  061612  1B42: c746fc0000       mov word ptr [bp - 4], 0
  061617  1B47: 837ed200         cmp word ptr [bp - 0x2e], 0
  06161B  1B4B: 7415             je 0x1b62
  06161D  1B4D: 6a02             push 2
  06161F  1B4F: 6a00             push 0
  061621  1B51: 9ad4041f18       lcall 0x181f, 0x4d4
  061626  1B56: 83c404           add sp, 4
  061629  1B59: 0bc0             or ax, ax
  06162B  1B5B: 7505             jne 0x1b62
  06162D  1B5D: c746fc0100       mov word ptr [bp - 4], 1
  061632  1B62: 837efc00         cmp word ptr [bp - 4], 0
  061636  1B66: 740e             je 0x1b76
  061638  1B68: 803ec61d01       cmp byte ptr [0x1dc6], 1
  06163D  1B6D: 7207             jb 0x1b76
  06163F  1B6F: 803ec71d07       cmp byte ptr [0x1dc7], 7
  061644  1B74: 7224             jb 0x1b9a
  061646  1B76: 837ef60a         cmp word ptr [bp - 0xa], 0xa
  06164A  1B7A: 7f08             jg 0x1b84
  06164C  1B7C: c746fa0500       mov word ptr [bp - 6], 5
  061651  1B81: e98900           jmp 0x1c0d
  061654  1B84: 837ef619         cmp word ptr [bp - 0xa], 0x19
  061658  1B88: 7d08             jge 0x1b92
  06165A  1B8A: c746fa0800       mov word ptr [bp - 6], 8
  06165F  1B8F: eb7c             jmp 0x1c0d
  061661  1B91: 90               nop 
  061662  1B92: c746fa0600       mov word ptr [bp - 6], 6
  061667  1B97: eb74             jmp 0x1c0d
  061669  1B99: 90               nop 
  06166A  1B9A: 6a14             push 0x14
  06166C  1B9C: 6a01             push 1
  06166E  1B9E: 9ad4041f18       lcall 0x181f, 0x4d4
  061673  1BA3: 83c404           add sp, 4
  061676  1BA6: 8b4ecc           mov cx, word ptr [bp - 0x34]
  061679  1BA9: 41               inc cx
  06167A  1BAA: 41               inc cx
  06167B  1BAB: 8bd1             mov dx, cx
  06167D  1BAD: c1e102           shl cx, 2
  061680  1BB0: 03ca             add cx, dx
  061682  1BB2: d1e1             shl cx, 1
  061684  1BB4: 03c8             add cx, ax
  061686  1BB6: 894ece           mov word ptr [bp - 0x32], cx
  061689  1BB9: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  06168D  1BBD: 8a874531         mov al, byte ptr [bx + 0x3145]
  061691  1BC1: 2ae4             sub ah, ah
  061693  1BC3: 50               push ax
  061694  1BC4: 8a874431         mov al, byte ptr [bx + 0x3144]
  061698  1BC8: 50               push ax
  061699  1BC9: 8a874731         mov al, byte ptr [bx + 0x3147]
  06169D  1BCD: 250f00           and ax, 0xf
  0616A0  1BD0: 50               push ax
  0616A1  1BD1: 6a0a             push 0xa
  0616A3  1BD3: 9a5c091f18       lcall 0x181f, 0x95c
  0616A8  1BD8: 83c408           add sp, 8
  0616AB  1BDB: 894606           mov word ptr [bp + 6], ax
  0616AE  1BDE: 0bc0             or ax, ax
  0616B0  1BE0: 7d03             jge 0x1be5
  0616B2  1BE2: e9a505           jmp 0x218a
  0616B5  1BE5: 8a46ce           mov al, byte ptr [bp - 0x32]
  0616B8  1BE8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0616BC  1BEC: 88875b31         mov byte ptr [bx + 0x315b], al
  0616C0  1BF0: b80100           mov ax, 1
  0616C3  1BF3: 8946fe           mov word ptr [bp - 2], ax
  0616C6  1BF6: 8946f4           mov word ptr [bp - 0xc], ax
  0616C9  1BF9: fe06c71d         inc byte ptr [0x1dc7]
  0616CD  1BFD: 8a874731         mov al, byte ptr [bx + 0x3147]
  0616D1  1C01: 250f00           and ax, 0xf
  0616D4  1C04: 50               push ax
  0616D5  1C05: 9aec061f1a       lcall 0x1a1f, 0x6ec
  0616DA  1C0A: 83c402           add sp, 2
  0616DD  1C0D: 837efa08         cmp word ptr [bp - 6], 8
  0616E1  1C11: 7403             je 0x1c16
  0616E3  1C13: e98a00           jmp 0x1ca0
  0616E6  1C16: 837ed200         cmp word ptr [bp - 0x2e], 0
  0616EA  1C1A: 7403             je 0x1c1f
  0616EC  1C1C: e907fe           jmp 0x1a26
  0616EF  1C1F: 6aff             push -1
  0616F1  1C21: 6aff             push -1
  0616F3  1C23: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0616F7  1C27: 8a874531         mov al, byte ptr [bx + 0x3145]
  0616FB  1C2B: 2ae4             sub ah, ah
  0616FD  1C2D: 50               push ax
  0616FE  1C2E: 8a874431         mov al, byte ptr [bx + 0x3144]
  061702  1C32: 50               push ax
  061703  1C33: 9a840d1f18       lcall 0x181f, 0xd84
  061708  1C38: 83c408           add sp, 8
  06170B  1C3B: 8946ee           mov word ptr [bp - 0x12], ax
  06170E  1C3E: 3d0200           cmp ax, 2
  061711  1C41: 7f58             jg 0x1c9b
  061713  1C43: a1528d           mov ax, word ptr [0x8d52]
  061716  1C46: 8946d0           mov word ptr [bp - 0x30], ax
  061719  1C49: 6a06             push 6
  06171B  1C4B: 6a01             push 1
  06171D  1C4D: 9ad4041f18       lcall 0x181f, 0x4d4
  061722  1C52: 83c404           add sp, 4
  061725  1C55: 8a0ea653         mov cl, byte ptr [0x53a6]
  061729  1C59: 2aed             sub ch, ch
  06172B  1C5B: 2b4ecc           sub cx, word ptr [bp - 0x34]
  06172E  1C5E: 41               inc cx
  06172F  1C5F: 8bd1             mov dx, cx
  061731  1C61: c1e102           shl cx, 2
  061734  1C64: 03ca             add cx, dx
  061736  1C66: 03c8             add cx, ax
  061738  1C68: 894eca           mov word ptr [bp - 0x36], cx
  06173B  1C6B: ff36508d         push word ptr [0x8d50]
  06173F  1C6F: 9aa4091f18       lcall 0x181f, 0x9a4
  061744  1C74: 83c402           add sp, 2
  061747  1C77: 50               push ax
  061748  1C78: 6a00             push 0
  06174A  1C7A: 9a38041f18       lcall 0x181f, 0x438
  06174F  1C7F: 83c404           add sp, 4
  061752  1C82: ff36508d         push word ptr [0x8d50]
  061756  1C86: ff369453         push word ptr [0x5394]
  06175A  1C8A: 9a380a1f18       lcall 0x181f, 0xa38
  06175F  1C8F: 83c404           add sp, 4
  061762  1C92: a820             test al, 0x20
  061764  1C94: 750a             jne 0x1ca0
  061766  1C96: c746d0ffff       mov word ptr [bp - 0x30], 0xffff
  06176B  1C9B: c746fa0600       mov word ptr [bp - 6], 6
  061770  1CA0: 837efa03         cmp word ptr [bp - 6], 3
  061774  1CA4: 754a             jne 0x1cf0
  061776  1CA6: 6a08             push 8
  061778  1CA8: 6a01             push 1
  06177A  1CAA: 9ad4041f18       lcall 0x181f, 0x4d4
  06177F  1CAF: 83c404           add sp, 4
  061782  1CB2: 6a08             push 8
  061784  1CB4: 6a01             push 1
  061786  1CB6: 8bf0             mov si, ax
  061788  1CB8: 9ad4041f18       lcall 0x181f, 0x4d4
  06178D  1CBD: 83c404           add sp, 4
  061790  1CC0: 6a08             push 8
  061792  1CC2: 6a01             push 1
  061794  1CC4: 8bf8             mov di, ax
  061796  1CC6: 9ad4041f18       lcall 0x181f, 0x4d4
  06179B  1CCB: 83c404           add sp, 4
  06179E  1CCE: 03f8             add di, ax
  0617A0  1CD0: 03f7             add si, di
  0617A2  1CD2: 8bc6             mov ax, si
  0617A4  1CD4: c1e602           shl si, 2
  0617A7  1CD7: 03f0             add si, ax
  0617A9  1CD9: d1e6             shl si, 1
  0617AB  1CDB: 8976f0           mov word ptr [bp - 0x10], si
  0617AE  1CDE: 837ecc00         cmp word ptr [bp - 0x34], 0
  0617B2  1CE2: 740c             je 0x1cf0
  0617B4  1CE4: 8b46cc           mov ax, word ptr [bp - 0x34]
  0617B7  1CE7: 40               inc ax
  0617B8  1CE8: 40               inc ax
  0617B9  1CE9: f7ee             imul si
  0617BB  1CEB: d1f8             sar ax, 1
  0617BD  1CED: 8946f0           mov word ptr [bp - 0x10], ax
  0617C0  1CF0: 837efa07         cmp word ptr [bp - 6], 7
  0617C4  1CF4: 7543             jne 0x1d39
  0617C6  1CF6: 6a0a             push 0xa
  0617C8  1CF8: 6a01             push 1
  0617CA  1CFA: 9ad4041f18       lcall 0x181f, 0x4d4
  0617CF  1CFF: 83c404           add sp, 4
  0617D2  1D02: 6a0a             push 0xa
  0617D4  1D04: 6a01             push 1
  0617D6  1D06: 8bf0             mov si, ax
  0617D8  1D08: 9ad4041f18       lcall 0x181f, 0x4d4
  0617DD  1D0D: 83c404           add sp, 4
  0617E0  1D10: 6a0a             push 0xa
  0617E2  1D12: 6a01             push 1
  0617E4  1D14: 8bf8             mov di, ax
  0617E6  1D16: 9ad4041f18       lcall 0x181f, 0x4d4
  0617EB  1D1B: 83c404           add sp, 4
  0617EE  1D1E: 6a0a             push 0xa
  0617F0  1D20: 6a01             push 1
  0617F2  1D22: 8946c4           mov word ptr [bp - 0x3c], ax
  0617F5  1D25: 9ad4041f18       lcall 0x181f, 0x4d4
  0617FA  1D2A: 83c404           add sp, 4
  0617FD  1D2D: 0346c4           add ax, word ptr [bp - 0x3c]
  061800  1D30: 03f8             add di, ax
  061802  1D32: 03f7             add si, di
  061804  1D34: d1e6             shl si, 1
  061806  1D36: 8976f0           mov word ptr [bp - 0x10], si
  061809  1D39: 837efa09         cmp word ptr [bp - 6], 9
  06180D  1D3D: 7515             jne 0x1d54
  06180F  1D3F: c606d29c00       mov byte ptr [0x9cd2], 0
  061814  1D44: ff369453         push word ptr [0x5394]
  061818  1D48: 6a00             push 0
  06181A  1D4A: 6a00             push 0
  06181C  1D4C: 9ac80a1f19       lcall 0x191f, 0xac8
  061821  1D51: 83c406           add sp, 6
  061824  1D54: 837efa05         cmp word ptr [bp - 6], 5
  061828  1D58: 7557             jne 0x1db1
  06182A  1D5A: 8b1e9453         mov bx, word ptr [0x5394]
  06182E  1D5E: 80bf109404       cmp byte ptr [bx - 0x6bf0], 4
  061833  1D63: 770c             ja 0x1d71
  061835  1D65: 80bf989202       cmp byte ptr [bx - 0x6d68], 2
  06183A  1D6A: 7705             ja 0x1d71
  06183C  1D6C: c746fa0600       mov word ptr [bp - 6], 6
  061841  1D71: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  061845  1D75: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  06184A  1D7A: 751f             jne 0x1d9b
  06184C  1D7C: 8b1e9453         mov bx, word ptr [0x5394]
  061850  1D80: 80bf109408       cmp byte ptr [bx - 0x6bf0], 8
  061855  1D85: 7714             ja 0x1d9b
  061857  1D87: 6a02             push 2
  061859  1D89: 6a01             push 1
  06185B  1D8B: 9ad4041f18       lcall 0x181f, 0x4d4
  061860  1D90: 83c404           add sp, 4
  061863  1D93: 48               dec ax
  061864  1D94: 7505             jne 0x1d9b
  061866  1D96: c746fa0600       mov word ptr [bp - 6], 6
  06186B  1D9B: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  061870  1DA0: f6873e5440       test byte ptr [bx + 0x543e], 0x40
  061875  1DA5: 750a             jne 0x1db1
  061877  1DA7: 808f3e5440       or byte ptr [bx + 0x543e], 0x40
  06187C  1DAC: c746fa0400       mov word ptr [bp - 6], 4
  061881  1DB1: 837efa05         cmp word ptr [bp - 6], 5
  061885  1DB5: 750b             jne 0x1dc2
  061887  1DB7: 837ed200         cmp word ptr [bp - 0x2e], 0
  06188B  1DBB: 7405             je 0x1dc2
  06188D  1DBD: c746fa0600       mov word ptr [bp - 6], 6
  061892  1DC2: 837efa06         cmp word ptr [bp - 6], 6
  061896  1DC6: 7509             jne 0x1dd1
  061898  1DC8: 837ed200         cmp word ptr [bp - 0x2e], 0
  06189C  1DCC: 7403             je 0x1dd1
  06189E  1DCE: e955fc           jmp 0x1a26
  0618A1  1DD1: 8b46f0           mov ax, word ptr [bp - 0x10]
  0618A4  1DD4: 99               cdq 
  0618A5  1DD5: 52               push dx
  0618A6  1DD6: 50               push ax
  0618A7  1DD7: 6a00             push 0
  0618A9  1DD9: 9aae091f18       lcall 0x181f, 0x9ae
  0618AE  1DDE: 83c406           add sp, 6
  0618B1  1DE1: 6b46ce64         imul ax, word ptr [bp - 0x32], 0x64
  0618B5  1DE5: 99               cdq 
  0618B6  1DE6: 52               push dx
  0618B7  1DE7: 50               push ax
  0618B8  1DE8: 6a01             push 1
  0618BA  1DEA: 9aae091f18       lcall 0x181f, 0x9ae
  0618BF  1DEF: 83c406           add sp, 6
  0618C2  1DF2: 68ae1d           push 0x1dae
  0618C5  1DF5: 8d46d6           lea ax, [bp - 0x2a]
  0618C8  1DF8: 50               push ax
  0618C9  1DF9: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0618CE  1DFE: 83c404           add sp, 4
  0618D1  1E01: ff76fa           push word ptr [bp - 6]
  0618D4  1E04: 8d46d6           lea ax, [bp - 0x2a]
  0618D7  1E07: 16               push ss
  0618D8  1E08: 50               push ax
  0618D9  1E09: 9a82011f18       lcall 0x181f, 0x182
  0618DE  1E0E: 83c406           add sp, 6
  0618E1  1E11: 837ef800         cmp word ptr [bp - 8], 0
  0618E5  1E15: 7454             je 0x1e6b
  0618E7  1E17: 837efa01         cmp word ptr [bp - 6], 1
  0618EB  1E1B: 7513             jne 0x1e30
  0618ED  1E1D: 6a37             push 0x37
  0618EF  1E1F: 9a8e041f18       lcall 0x181f, 0x48e
  0618F4  1E24: 83c402           add sp, 2
  0618F7  1E27: 6a08             push 8
  0618F9  1E29: 9a24051f18       lcall 0x181f, 0x524
  0618FE  1E2E: eb38             jmp 0x1e68
  061900  1E30: 837efa02         cmp word ptr [bp - 6], 2
  061904  1E34: 7504             jne 0x1e3a
  061906  1E36: 6a3c             push 0x3c
  061908  1E38: eb08             jmp 0x1e42
  06190A  1E3A: 837efa04         cmp word ptr [bp - 6], 4
  06190E  1E3E: 750a             jne 0x1e4a
  061910  1E40: 6a33             push 0x33
  061912  1E42: 9a8e041f18       lcall 0x181f, 0x48e
  061917  1E47: eb1f             jmp 0x1e68
  061919  1E49: 90               nop 
  06191A  1E4A: 837ef000         cmp word ptr [bp - 0x10], 0
  06191E  1E4E: 741b             je 0x1e6b
  061920  1E50: 6a02             push 2
  061922  1E52: 9a98041f18       lcall 0x181f, 0x498
  061927  1E57: 83c402           add sp, 2
  06192A  1E5A: 833ea20000       cmp word ptr [0xa2], 0
  06192F  1E5F: 750a             jne 0x1e6b
  061931  1E61: 6a02             push 2
  061933  1E63: 9aac041f18       lcall 0x181f, 0x4ac
  061938  1E68: 83c402           add sp, 2
  06193B  1E6B: 837ef800         cmp word ptr [bp - 8], 0
  06193F  1E6F: 7417             je 0x1e88
  061941  1E71: c7065e1f0300     mov word ptr [0x1f5e], 3
  061947  1E77: 8d1e7c08         lea bx, [0x87c]
  06194B  1E7B: 8d46d6           lea ax, [bp - 0x2a]
  06194E  1E7E: 2bd2             sub dx, dx
  061950  1E80: 9a98091f18       lcall 0x181f, 0x998
  061955  1E85: 8946c6           mov word ptr [bp - 0x3a], ax
  061958  1E88: 837eca00         cmp word ptr [bp - 0x36], 0
  06195C  1E8C: 7422             je 0x1eb0
  06195E  1E8E: 837ed000         cmp word ptr [bp - 0x30], 0
  061962  1E92: 7c1c             jl 0x1eb0
  061964  1E94: 6a00             push 0
  061966  1E96: ff76ca           push word ptr [bp - 0x36]
  061969  1E99: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  06196D  1E9D: 8a874731         mov al, byte ptr [bx + 0x3147]
  061971  1EA1: 250f00           and ax, 0xf
  061974  1EA4: 50               push ax
  061975  1EA5: ff76d0           push word ptr [bp - 0x30]
  061978  1EA8: 9a6c0d1f18       lcall 0x181f, 0xd6c
  06197D  1EAD: 83c408           add sp, 8
  061980  1EB0: 837efa04         cmp word ptr [bp - 6], 4
  061984  1EB4: 7403             je 0x1eb9
  061986  1EB6: e90302           jmp 0x20bc
  061989  1EB9: 837ec601         cmp word ptr [bp - 0x3a], 1
  06198D  1EBD: 7403             je 0x1ec2
  06198F  1EBF: e9fa01           jmp 0x20bc
  061992  1EC2: b8ffff           mov ax, 0xffff
  061995  1EC5: 8946d0           mov word ptr [bp - 0x30], ax
  061998  1EC8: 50               push ax
  061999  1EC9: 50               push ax
  06199A  1ECA: ff760a           push word ptr [bp + 0xa]
  06199D  1ECD: ff7608           push word ptr [bp + 8]
  0619A0  1ED0: 9a840d1f18       lcall 0x181f, 0xd84
  0619A5  1ED5: 83c408           add sp, 8
  0619A8  1ED8: 8946ee           mov word ptr [bp - 0x12], ax
  0619AB  1EDB: 0bc0             or ax, ax
  0619AD  1EDD: 7c2a             jl 0x1f09
  0619AF  1EDF: 8a4ecc           mov cl, byte ptr [bp - 0x34]
  0619B2  1EE2: a1b88d           mov ax, word ptr [0x8db8]
  0619B5  1EE5: 050500           add ax, 5
  0619B8  1EE8: d3e0             shl ax, cl
  0619BA  1EEA: 50               push ax
  0619BB  1EEB: 6a01             push 1
  0619BD  1EED: 9ad4041f18       lcall 0x181f, 0x4d4
  0619C2  1EF2: 83c404           add sp, 4
  0619C5  1EF5: 3d0300           cmp ax, 3
  0619C8  1EF8: 7f0f             jg 0x1f09
  0619CA  1EFA: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0619CE  1EFE: 8a4702           mov al, byte ptr [bx + 2]
  0619D1  1F01: 2ae4             sub ah, ah
  0619D3  1F03: 2d0400           sub ax, 4
  0619D6  1F06: 8946d0           mov word ptr [bp - 0x30], ax
  0619D9  1F09: ff36508d         push word ptr [0x8d50]
  0619DD  1F0D: ff369453         push word ptr [0x5394]
  0619E1  1F11: 9a380a1f18       lcall 0x181f, 0xa38
  0619E6  1F16: 83c404           add sp, 4
  0619E9  1F19: a820             test al, 0x20
  0619EB  1F1B: 7505             jne 0x1f22
  0619ED  1F1D: c746d0ffff       mov word ptr [bp - 0x30], 0xffff
  0619F2  1F22: 837ef619         cmp word ptr [bp - 0xa], 0x19
  0619F6  1F26: 7d0e             jge 0x1f36
  0619F8  1F28: c746c80100       mov word ptr [bp - 0x38], 1
  0619FD  1F2D: c746f00000       mov word ptr [bp - 0x10], 0
  061A02  1F32: e9dd00           jmp 0x2012
  061A05  1F35: 90               nop 
  061A06  1F36: 837ef632         cmp word ptr [bp - 0xa], 0x32
  061A0A  1F3A: 7c0c             jl 0x1f48
  061A0C  1F3C: 837ed000         cmp word ptr [bp - 0x30], 0
  061A10  1F40: 7d46             jge 0x1f88
  061A12  1F42: 837ef641         cmp word ptr [bp - 0xa], 0x41
  061A16  1F46: 7d40             jge 0x1f88
  061A18  1F48: c746c80200       mov word ptr [bp - 0x38], 2
  061A1D  1F4D: 6a08             push 8
  061A1F  1F4F: 6a01             push 1
  061A21  1F51: 9ad4041f18       lcall 0x181f, 0x4d4
  061A26  1F56: 83c404           add sp, 4
  061A29  1F59: 6a08             push 8
  061A2B  1F5B: 6a01             push 1
  061A2D  1F5D: 8bf0             mov si, ax
  061A2F  1F5F: 9ad4041f18       lcall 0x181f, 0x4d4
  061A34  1F64: 83c404           add sp, 4
  061A37  1F67: 6a08             push 8
  061A39  1F69: 6a01             push 1
  061A3B  1F6B: 8bf8             mov di, ax
  061A3D  1F6D: 9ad4041f18       lcall 0x181f, 0x4d4
  061A42  1F72: 83c404           add sp, 4
  061A45  1F75: 03f8             add di, ax
  061A47  1F77: 03f7             add si, di
  061A49  1F79: 8bc6             mov ax, si
  061A4B  1F7B: c1e602           shl si, 2
  061A4E  1F7E: 03f0             add si, ax
  061A50  1F80: d1e6             shl si, 1
  061A52  1F82: 8976f0           mov word ptr [bp - 0x10], si
  061A55  1F85: e98a00           jmp 0x2012
  061A58  1F88: c746c80300       mov word ptr [bp - 0x38], 3
  061A5D  1F8D: 6a08             push 8
  061A5F  1F8F: 6a01             push 1
  061A61  1F91: 9ad4041f18       lcall 0x181f, 0x4d4
  061A66  1F96: 83c404           add sp, 4
  061A69  1F99: 8b4ecc           mov cx, word ptr [bp - 0x34]
  061A6C  1F9C: 83c105           add cx, 5
  061A6F  1F9F: d1e1             shl cx, 1
  061A71  1FA1: 03c1             add ax, cx
  061A73  1FA3: d1e0             shl ax, 1
  061A75  1FA5: 8946ce           mov word ptr [bp - 0x32], ax
  061A78  1FA8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  061A7C  1FAC: 8a874531         mov al, byte ptr [bx + 0x3145]
  061A80  1FB0: 2ae4             sub ah, ah
  061A82  1FB2: 50               push ax
  061A83  1FB3: 8a874431         mov al, byte ptr [bx + 0x3144]
  061A87  1FB7: 50               push ax
  061A88  1FB8: 8a874731         mov al, byte ptr [bx + 0x3147]
  061A8C  1FBC: 250f00           and ax, 0xf
  061A8F  1FBF: 50               push ax
  061A90  1FC0: 6a0a             push 0xa
  061A92  1FC2: 9a5c091f18       lcall 0x181f, 0x95c
  061A97  1FC7: 83c408           add sp, 8
  061A9A  1FCA: 894606           mov word ptr [bp + 6], ax
  061A9D  1FCD: 0bc0             or ax, ax
  061A9F  1FCF: 7d03             jge 0x1fd4
  061AA1  1FD1: e9b601           jmp 0x218a
  061AA4  1FD4: 8a46ce           mov al, byte ptr [bp - 0x32]
  061AA7  1FD7: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  061AAB  1FDB: 88875b31         mov byte ptr [bx + 0x315b], al
  061AAF  1FDF: 837ef800         cmp word ptr [bp - 8], 0
  061AB3  1FE3: 7410             je 0x1ff5
  061AB5  1FE5: 837ed000         cmp word ptr [bp - 0x30], 0
  061AB9  1FE9: 7d0a             jge 0x1ff5
  061ABB  1FEB: 6a24             push 0x24
  061ABD  1FED: 9a8e041f18       lcall 0x181f, 0x48e
  061AC2  1FF2: 83c402           add sp, 2
  061AC5  1FF5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  061AC9  1FF9: 8a874731         mov al, byte ptr [bx + 0x3147]
  061ACD  1FFD: 250f00           and ax, 0xf
  061AD0  2000: 50               push ax
  061AD1  2001: 9aec061f1a       lcall 0x1a1f, 0x6ec
  061AD6  2006: 83c402           add sp, 2
  061AD9  2009: b80100           mov ax, 1
  061ADC  200C: 8946fe           mov word ptr [bp - 2], ax
  061ADF  200F: 8946f4           mov word ptr [bp - 0xc], ax
  061AE2  2012: 8b46f0           mov ax, word ptr [bp - 0x10]
  061AE5  2015: 99               cdq 
  061AE6  2016: 52               push dx
  061AE7  2017: 50               push ax
  061AE8  2018: 6a00             push 0
  061AEA  201A: 9aae091f18       lcall 0x181f, 0x9ae
  061AEF  201F: 83c406           add sp, 6
  061AF2  2022: 6b46ce64         imul ax, word ptr [bp - 0x32], 0x64
  061AF6  2026: 99               cdq 
  061AF7  2027: 52               push dx
  061AF8  2028: 50               push ax
  061AF9  2029: 6a01             push 1
  061AFB  202B: 9aae091f18       lcall 0x181f, 0x9ae
  061B00  2030: 83c406           add sp, 6
  061B03  2033: 68b71d           push 0x1db7
  061B06  2036: 8d46d6           lea ax, [bp - 0x2a]
  061B09  2039: 50               push ax
  061B0A  203A: 9ae4071d0d       lcall 0xd1d, 0x7e4
  061B0F  203F: 83c404           add sp, 4
  061B12  2042: ff76c8           push word ptr [bp - 0x38]
  061B15  2045: 8d46d6           lea ax, [bp - 0x2a]
  061B18  2048: 16               push ss
  061B19  2049: 50               push ax
  061B1A  204A: 9a82011f18       lcall 0x181f, 0x182
  061B1F  204F: 83c406           add sp, 6
  061B22  2052: 837ef800         cmp word ptr [bp - 8], 0
  061B26  2056: 740e             je 0x2066
  061B28  2058: 6a03             push 3
  061B2A  205A: 8d46d6           lea ax, [bp - 0x2a]
  061B2D  205D: 50               push ax
  061B2E  205E: 9a52061f18       lcall 0x181f, 0x652
  061B33  2063: 83c404           add sp, 4
  061B36  2066: 837ed000         cmp word ptr [bp - 0x30], 0
  061B3A  206A: 7c50             jl 0x20bc
  061B3C  206C: 837ef800         cmp word ptr [bp - 8], 0
  061B40  2070: 740a             je 0x207c
  061B42  2072: 6a32             push 0x32
  061B44  2074: 9a8e041f18       lcall 0x181f, 0x48e
  061B49  2079: 83c402           add sp, 2
  061B4C  207C: 8b46d0           mov ax, word ptr [bp - 0x30]
  061B4F  207F: 050400           add ax, 4
  061B52  2082: 50               push ax
  061B53  2083: 9aa4091f18       lcall 0x181f, 0x9a4
  061B58  2088: 83c402           add sp, 2
  061B5B  208B: 50               push ax
  061B5C  208C: 6a00             push 0
  061B5E  208E: 9a38041f18       lcall 0x181f, 0x438
  061B63  2093: 83c404           add sp, 4
  061B66  2096: 837ef800         cmp word ptr [bp - 8], 0
  061B6A  209A: 740d             je 0x20a9
  061B6C  209C: 6a03             push 3
  061B6E  209E: 68be1d           push 0x1dbe
  061B71  20A1: 9a52061f18       lcall 0x181f, 0x652
  061B76  20A6: 83c404           add sp, 4
  061B79  20A9: 6a00             push 0
  061B7B  20AB: 6a64             push 0x64
  061B7D  20AD: ff369453         push word ptr [0x5394]
  061B81  20B1: ff76d0           push word ptr [bp - 0x30]
  061B84  20B4: 9a6c0d1f18       lcall 0x181f, 0xd6c
  061B89  20B9: 83c408           add sp, 8
  061B8C  20BC: 8b46fa           mov ax, word ptr [bp - 6]
  061B8F  20BF: e99a00           jmp 0x215c
  061B92  20C2: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  061B96  20C6: 8a874731         mov al, byte ptr [bx + 0x3147]
  061B9A  20CA: 250f00           and ax, 0xf
  061B9D  20CD: 50               push ax
  061B9E  20CE: 9a82051f18       lcall 0x181f, 0x582
  061BA3  20D3: 83c402           add sp, 2
  061BA6  20D6: c746ea0000       mov word ptr [bp - 0x16], 0
  061BAB  20DB: eb04             jmp 0x20e1
  061BAD  20DD: 90               nop 
  061BAE  20DE: ff46ea           inc word ptr [bp - 0x16]
  061BB1  20E1: 837eea08         cmp word ptr [bp - 0x16], 8
  061BB5  20E5: 7c03             jl 0x20ea
  061BB7  20E7: e98800           jmp 0x2172
  061BBA  20EA: 6a00             push 0
  061BBC  20EC: 6a01             push 1
  061BBE  20EE: 9a2c0d1f19       lcall 0x191f, 0xd2c
  061BC3  20F3: 83c404           add sp, 4
  061BC6  20F6: ebe6             jmp 0x20de
  061BC8  20F8: 837ef800         cmp word ptr [bp - 8], 0
  061BCC  20FC: 741b             je 0x2119
  061BCE  20FE: 6a01             push 1
  061BD0  2100: 9a98041f18       lcall 0x181f, 0x498
  061BD5  2105: 83c402           add sp, 2
  061BD8  2108: 833ea20000       cmp word ptr [0xa2], 0
  061BDD  210D: 750a             jne 0x2119
  061BDF  210F: 6a01             push 1
  061BE1  2111: 9aac041f18       lcall 0x181f, 0x4ac
  061BE6  2116: 83c402           add sp, 2
  061BE9  2119: ff7606           push word ptr [bp + 6]
  061BEC  211C: 9a08081f18       lcall 0x181f, 0x808
  061BF1  2121: 83c402           add sp, 2
  061BF4  2124: c746f40100       mov word ptr [bp - 0xc], 1
  061BF9  2129: eb47             jmp 0x2172
  061BFB  212B: 90               nop 
  061BFC  212C: ff760a           push word ptr [bp + 0xa]
  061BFF  212F: ff7608           push word ptr [bp + 8]
  061C02  2132: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  061C06  2136: 8a874731         mov al, byte ptr [bx + 0x3147]
  061C0A  213A: 250f00           and ax, 0xf
  061C0D  213D: 50               push ax
  061C0E  213E: 6a00             push 0
  061C10  2140: 9a5c091f18       lcall 0x181f, 0x95c
  061C15  2145: 83c408           add sp, 8
  061C18  2148: 8946ec           mov word ptr [bp - 0x14], ax
  061C1B  214B: 0bc0             or ax, ax
  061C1D  214D: 7c3b             jl 0x218a
  061C1F  214F: ff7606           push word ptr [bp + 6]
  061C22  2152: 9a9e081f18       lcall 0x181f, 0x89e
  061C27  2157: 83c402           add sp, 2
  061C2A  215A: eb16             jmp 0x2172
  061C2C  215C: 3d0900           cmp ax, 9
  061C2F  215F: 74cb             je 0x212c
  061C31  2161: 770f             ja 0x2172
  061C33  2163: fec8             dec al
  061C35  2165: 7503             jne 0x216a
  061C37  2167: e958ff           jmp 0x20c2
  061C3A  216A: fec8             dec al
  061C3C  216C: 7404             je 0x2172
  061C3E  216E: 2c03             sub al, 3
  061C40  2170: 7486             je 0x20f8
  061C42  2172: 837ef000         cmp word ptr [bp - 0x10], 0
  061C46  2176: 7412             je 0x218a
  061C48  2178: 8b46f0           mov ax, word ptr [bp - 0x10]
  061C4B  217B: 99               cdq 
  061C4C  217C: 691e94533c01     imul bx, word ptr [0x5394], 0x13c
  061C52  2182: 01873288         add word ptr [bx - 0x77ce], ax
  061C56  2186: 11973488         adc word ptr [bx - 0x77cc], dx
  061C5A  218A: 837ef800         cmp word ptr [bp - 8], 0
  061C5E  218E: 7439             je 0x21c9
  061C60  2190: 837ef400         cmp word ptr [bp - 0xc], 0
  061C64  2194: 7433             je 0x21c9
  061C66  2196: 837efe01         cmp word ptr [bp - 2], 1
  061C6A  219A: 1bc0             sbb ax, ax
  061C6C  219C: f7d8             neg ax
  061C6E  219E: 50               push ax
  061C6F  219F: 6a07             push 7
  061C71  21A1: 6a07             push 7
  061C73  21A3: 8b460a           mov ax, word ptr [bp + 0xa]
  061C76  21A6: 2d0300           sub ax, 3
  061C79  21A9: 50               push ax
  061C7A  21AA: 8b4608           mov ax, word ptr [bp + 8]
  061C7D  21AD: 2d0300           sub ax, 3
  061C80  21B0: 50               push ax
  061C81  21B1: 9aba091f18       lcall 0x181f, 0x9ba
  061C86  21B6: 83c40a           add sp, 0xa
  061C89  21B9: 837efe00         cmp word ptr [bp - 2], 0
  061C8D  21BD: 740a             je 0x21c9
  061C8F  21BF: 6a08             push 8
  061C91  21C1: 9aea031f18       lcall 0x181f, 0x3ea
  061C96  21C6: 83c402           add sp, 2
  061C99  21C9: 5e               pop si
  061C9A  21CA: 5f               pop di
  061C9B  21CB: c9               leave 
  061C9C  21CC: cb               retf 
