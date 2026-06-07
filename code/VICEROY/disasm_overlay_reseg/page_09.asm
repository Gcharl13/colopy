; ============================================================
; VICEROY.EXE overlay page 0x09 (record 8) -- RE-SEGMENTED
; file_offset (disk image) = 0x0428D0
; code_offset (first insn) = 0x042C50
; code_end (next reloc hdr)= 0x044400  [resident size 379 para -> nominal_end 0x044080; on-disk code spills past it]
; reloc_count = 214  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x0428D0)
; functions in page = 8
; ============================================================

; ---- func_042C50  size=155  insns=50  prologue=no-frame (first byte 0x83)  terminal=RETF ----
  042C50  0380: 833e2c0800       cmp word ptr [0x82c], 0
  042C55  0385: 7525             jne 0x3ac
  042C57  0387: ff36ae2d         push word ptr [0x2dae]
  042C5B  038B: ff36ac2d         push word ptr [0x2dac]
  042C5F  038F: ff36aa2d         push word ptr [0x2daa]
  042C63  0393: ff36a82d         push word ptr [0x2da8]
  042C67  0397: 689600           push 0x96
  042C6A  039A: 6a22             push 0x22
  042C6C  039C: b8f100           mov ax, 0xf1
  042C6F  039F: ba3200           mov dx, 0x32
  042C72  03A2: bb4f00           mov bx, 0x4f
  042C75  03A5: 9aba001f18       lcall 0x181f, 0xba
  042C7A  03AA: eb35             jmp 0x3e1
  042C7C  03AC: 6a00             push 0
  042C7E  03AE: 6a00             push 0
  042C80  03B0: 689600           push 0x96
  042C83  03B3: 6a4f             push 0x4f
  042C85  03B5: 6a32             push 0x32
  042C87  03B7: 68f100           push 0xf1
  042C8A  03BA: 8b1e2c08         mov bx, word ptr [0x82c]
  042C8E  03BE: ff7706           push word ptr [bx + 6]
  042C91  03C1: ff7704           push word ptr [bx + 4]
  042C94  03C4: ff7702           push word ptr [bx + 2]
  042C97  03C7: ff37             push word ptr [bx]
  042C99  03C9: ff36ae2d         push word ptr [0x2dae]
  042C9D  03CD: ff36ac2d         push word ptr [0x2dac]
  042CA1  03D1: ff36aa2d         push word ptr [0x2daa]
  042CA5  03D5: ff36a82d         push word ptr [0x2da8]
  042CA9  03D9: 9ac4001f18       lcall 0x181f, 0xc4
  042CAE  03DE: 83c41c           add sp, 0x1c
  042CB1  03E1: ff36ae2d         push word ptr [0x2dae]
  042CB5  03E5: ff36ac2d         push word ptr [0x2dac]
  042CB9  03E9: ff36aa2d         push word ptr [0x2daa]
  042CBD  03ED: ff36a82d         push word ptr [0x2da8]
  042CC1  03F1: 68c800           push 0xc8
  042CC4  03F4: 6a00             push 0
  042CC6  03F6: b8f000           mov ax, 0xf0
  042CC9  03F9: ba3100           mov dx, 0x31
  042CCC  03FC: bb4001           mov bx, 0x140
  042CCF  03FF: 9ace001f18       lcall 0x181f, 0xce
  042CD4  0404: cb               retf 
  042CD5  0405: 90               nop 
  042CD6  0406: 6a32             push 0x32
  042CD8  0408: 6a4f             push 0x4f
  042CDA  040A: 689600           push 0x96
  042CDD  040D: b8f100           mov ax, 0xf1
  042CE0  0410: ba3200           mov dx, 0x32
  042CE3  0413: 8bd8             mov bx, ax
  042CE5  0415: 9ae2001f18       lcall 0x181f, 0xe2
  042CEA  041A: cb               retf 

; ---- func_042CEC  size=89  insns=34  prologue=ENTER 0x0050,0  terminal=RETF ----
  042CEC  041C: c8500000         enter 0x50, 0
  042CF0  0420: 56               push si
  042CF1  0421: c646b000         mov byte ptr [bp - 0x50], 0
  042CF5  0425: 8d46b0           lea ax, [bp - 0x50]
  042CF8  0428: 50               push ax
  042CF9  0429: 9a1e011f18       lcall 0x181f, 0x11e
  042CFE  042E: 83c402           add sp, 2
  042D01  0431: ff7606           push word ptr [bp + 6]
  042D04  0434: 8d46b0           lea ax, [bp - 0x50]
  042D07  0437: 50               push ax
  042D08  0438: 9ae6011f18       lcall 0x181f, 0x1e6
  042D0D  043D: 83c404           add sp, 4
  042D10  0440: 8d46b0           lea ax, [bp - 0x50]
  042D13  0443: 50               push ax
  042D14  0444: 9a28011f18       lcall 0x181f, 0x128
  042D19  0449: 83c402           add sp, 2
  042D1C  044C: 8b5e0a           mov bx, word ptr [bp + 0xa]
  042D1F  044F: ff37             push word ptr [bx]
  042D21  0451: 8b7608           mov si, word ptr [bp + 8]
  042D24  0454: ff34             push word ptr [si]
  042D26  0456: 8d46b0           lea ax, [bp - 0x50]
  042D29  0459: 16               push ss
  042D2A  045A: 50               push ax
  042D2B  045B: 9a32011f18       lcall 0x181f, 0x132
  042D30  0460: 83c408           add sp, 8
  042D33  0463: c41e9e08         les bx, ptr [0x89e]
  042D37  0467: 268a07           mov al, byte ptr es:[bx]
  042D3A  046A: 2ae4             sub ah, ah
  042D3C  046C: 40               inc ax
  042D3D  046D: 8b5e0a           mov bx, word ptr [bp + 0xa]
  042D40  0470: 0107             add word ptr [bx], ax
  042D42  0472: 5e               pop si
  042D43  0473: c9               leave 
  042D44  0474: cb               retf 

; ---- func_042D46  size=95  insns=36  prologue=ENTER 0x0050,0  terminal=RETF ----
  042D46  0476: c8500000         enter 0x50, 0
  042D4A  047A: 56               push si
  042D4B  047B: c646b000         mov byte ptr [bp - 0x50], 0
  042D4F  047F: 8d46b0           lea ax, [bp - 0x50]
  042D52  0482: 50               push ax
  042D53  0483: 9a1e011f18       lcall 0x181f, 0x11e
  042D58  0488: 83c402           add sp, 2
  042D5B  048B: 8b5e06           mov bx, word ptr [bp + 6]
  042D5E  048E: d1e3             shl bx, 1
  042D60  0490: ffb7b02d         push word ptr [bx + 0x2db0]
  042D64  0494: 8d46b0           lea ax, [bp - 0x50]
  042D67  0497: 50               push ax
  042D68  0498: 9a6e011f18       lcall 0x181f, 0x16e
  042D6D  049D: 83c404           add sp, 4
  042D70  04A0: 8d46b0           lea ax, [bp - 0x50]
  042D73  04A3: 50               push ax
  042D74  04A4: 9a28011f18       lcall 0x181f, 0x128
  042D79  04A9: 83c402           add sp, 2
  042D7C  04AC: 8b5e0a           mov bx, word ptr [bp + 0xa]
  042D7F  04AF: ff37             push word ptr [bx]
  042D81  04B1: 8b7608           mov si, word ptr [bp + 8]
  042D84  04B4: ff34             push word ptr [si]
  042D86  04B6: 8d46b0           lea ax, [bp - 0x50]
  042D89  04B9: 16               push ss
  042D8A  04BA: 50               push ax
  042D8B  04BB: 9a32011f18       lcall 0x181f, 0x132
  042D90  04C0: 83c408           add sp, 8
  042D93  04C3: c41e9e08         les bx, ptr [0x89e]
  042D97  04C7: 268a07           mov al, byte ptr es:[bx]
  042D9A  04CA: 2ae4             sub ah, ah
  042D9C  04CC: 40               inc ax
  042D9D  04CD: 8b5e0a           mov bx, word ptr [bp + 0xa]
  042DA0  04D0: 0107             add word ptr [bx], ax
  042DA2  04D2: 5e               pop si
  042DA3  04D3: c9               leave 
  042DA4  04D4: cb               retf 

; ---- func_042DA6  size=83  insns=29  prologue=ENTER 0x0002,0  terminal=RETF ----
  042DA6  04D6: c8020000         enter 2, 0
  042DAA  04DA: 833e9c9201       cmp word ptr [0x929c], 1
  042DAF  04DF: f5               cmc 
  042DB0  04E0: 1bc0             sbb ax, ax
  042DB2  04E2: 250f00           and ax, 0xf
  042DB5  04E5: 50               push ax
  042DB6  04E6: ff36569e         push word ptr [0x9e56]
  042DBA  04EA: 68f200           push 0xf2
  042DBD  04ED: ff36be2d         push word ptr [0x2dbe]
  042DC1  04F1: 9a22001f18       lcall 0x181f, 0x22
  042DC6  04F6: 83c402           add sp, 2
  042DC9  04F9: 52               push dx
  042DCA  04FA: 50               push ax
  042DCB  04FB: 9a3c011f18       lcall 0x181f, 0x13c
  042DD0  0500: 83c40a           add sp, 0xa
  042DD3  0503: 837e0600         cmp word ptr [bp + 6], 0
  042DD7  0507: 741e             je 0x527
  042DD9  0509: ff36569e         push word ptr [0x9e56]
  042DDD  050D: 6a4f             push 0x4f
  042DDF  050F: c41e9e08         les bx, ptr [0x89e]
  042DE3  0513: 268a07           mov al, byte ptr es:[bx]
  042DE6  0516: 2ae4             sub ah, ah
  042DE8  0518: 50               push ax
  042DE9  0519: b8f100           mov ax, 0xf1
  042DEC  051C: 8b16569e         mov dx, word ptr [0x9e56]
  042DF0  0520: 8bd8             mov bx, ax
  042DF2  0522: 9ae2001f18       lcall 0x181f, 0xe2
  042DF7  0527: c9               leave 
  042DF8  0528: cb               retf 

; ---- func_042DFA  size=293  insns=102  prologue=ENTER 0x0020,0  terminal=RETF ----
  042DFA  052A: c8200000         enter 0x20, 0
  042DFE  052E: 56               push si
  042DFF  052F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  042E03  0533: 8a875031         mov al, byte ptr [bx + 0x3150]
  042E07  0537: 2ae4             sub ah, ah
  042E09  0539: 8946e0           mov word ptr [bp - 0x20], ax
  042E0C  053C: c746f20000       mov word ptr [bp - 0xe], 0
  042E11  0541: eb72             jmp 0x5b5
  042E13  0543: 90               nop 
  042E14  0544: 8bf0             mov si, ax
  042E16  0546: 8842fa           mov byte ptr [bp + si - 6], al
  042E19  0549: 56               push si
  042E1A  054A: ff7606           push word ptr [bp + 6]
  042E1D  054D: 9ae60b1f18       lcall 0x181f, 0xbe6
  042E22  0552: 83c404           add sp, 4
  042E25  0555: 8946ee           mov word ptr [bp - 0x12], ax
  042E28  0558: 56               push si
  042E29  0559: ff7606           push word ptr [bp + 6]
  042E2C  055C: 9a680c1f18       lcall 0x181f, 0xc68
  042E31  0561: 83c404           add sp, 4
  042E34  0564: 8946f8           mov word ptr [bp - 8], ax
  042E37  0567: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  042E3B  056B: 8a874731         mov al, byte ptr [bx + 0x3147]
  042E3F  056F: 250f00           and ax, 0xf
  042E42  0572: 8bf0             mov si, ax
  042E44  0574: c1e604           shl si, 4
  042E47  0577: 8b5eee           mov bx, word ptr [bp - 0x12]
  042E4A  057A: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  042E4E  057E: 2ae4             sub ah, ah
  042E50  0580: c1e004           shl ax, 4
  042E53  0583: 8946f6           mov word ptr [bp - 0xa], ax
  042E56  0586: 83fb0f           cmp bx, 0xf
  042E59  0589: 7505             jne 0x590
  042E5B  058B: c746f60000       mov word ptr [bp - 0xa], 0
  042E60  0590: 83fb0e           cmp bx, 0xe
  042E63  0593: 7505             jne 0x59a
  042E65  0595: c746f60000       mov word ptr [bp - 0xa], 0
  042E6A  059A: 83fb08           cmp bx, 8
  042E6D  059D: 7505             jne 0x5a4
  042E6F  059F: c746f60100       mov word ptr [bp - 0xa], 1
  042E74  05A4: 8b46f6           mov ax, word ptr [bp - 0xa]
  042E77  05A7: f76ef8           imul word ptr [bp - 8]
  042E7A  05AA: 8b76f2           mov si, word ptr [bp - 0xe]
  042E7D  05AD: d1e6             shl si, 1
  042E7F  05AF: 8942e2           mov word ptr [bp + si - 0x1e], ax
  042E82  05B2: ff46f2           inc word ptr [bp - 0xe]
  042E85  05B5: 8b46f2           mov ax, word ptr [bp - 0xe]
  042E88  05B8: 3946e0           cmp word ptr [bp - 0x20], ax
  042E8B  05BB: 7f87             jg 0x544
  042E8D  05BD: 8d46fa           lea ax, [bp - 6]
  042E90  05C0: 16               push ss
  042E91  05C1: 50               push ax
  042E92  05C2: 8d46e2           lea ax, [bp - 0x1e]
  042E95  05C5: 16               push ss
  042E96  05C6: 50               push ax
  042E97  05C7: 8b46e0           mov ax, word ptr [bp - 0x20]
  042E9A  05CA: 9ad00e1f19       lcall 0x191f, 0xed0
  042E9F  05CF: c746f20000       mov word ptr [bp - 0xe], 0
  042EA4  05D4: eb3a             jmp 0x610
  042EA6  05D6: b82700           mov ax, 0x27
  042EA9  05D9: 8946f0           mov word ptr [bp - 0x10], ax
  042EAC  05DC: ff364008         push word ptr [0x840]
  042EB0  05E0: ff363e08         push word ptr [0x83e]
  042EB4  05E4: ff760a           push word ptr [bp + 0xa]
  042EB7  05E7: 0346ee           add ax, word ptr [bp - 0x12]
  042EBA  05EA: 8d1ea82d         lea bx, [0x2da8]
  042EBE  05EE: 8b5608           mov dx, word ptr [bp + 8]
  042EC1  05F1: 8bf0             mov si, ax
  042EC3  05F3: 9a54021f18       lcall 0x181f, 0x254
  042EC8  05F8: 8bc6             mov ax, si
  042ECA  05FA: d1e6             shl si, 1
  042ECC  05FC: 03f0             add si, ax
  042ECE  05FE: c1e602           shl si, 2
  042ED1  0601: c41e3e08         les bx, ptr [0x83e]
  042ED5  0605: 268b403e         mov ax, word ptr es:[bx + si + 0x3e]
  042ED9  0609: 40               inc ax
  042EDA  060A: 014608           add word ptr [bp + 8], ax
  042EDD  060D: ff46f2           inc word ptr [bp - 0xe]
  042EE0  0610: 8b46f2           mov ax, word ptr [bp - 0xe]
  042EE3  0613: 3946e0           cmp word ptr [bp - 0x20], ax
  042EE6  0616: 7e34             jle 0x64c
  042EE8  0618: 8bf0             mov si, ax
  042EEA  061A: 8a42fa           mov al, byte ptr [bp + si - 6]
  042EED  061D: 2ae4             sub ah, ah
  042EEF  061F: 8946f4           mov word ptr [bp - 0xc], ax
  042EF2  0622: 50               push ax
  042EF3  0623: ff7606           push word ptr [bp + 6]
  042EF6  0626: 9ae60b1f18       lcall 0x181f, 0xbe6
  042EFB  062B: 83c404           add sp, 4
  042EFE  062E: 8946ee           mov word ptr [bp - 0x12], ax
  042F01  0631: ff76f4           push word ptr [bp - 0xc]
  042F04  0634: ff7606           push word ptr [bp + 6]
  042F07  0637: 9a680c1f18       lcall 0x181f, 0xc68
  042F0C  063C: 83c404           add sp, 4
  042F0F  063F: 8946f8           mov word ptr [bp - 8], ax
  042F12  0642: 3d6400           cmp ax, 0x64
  042F15  0645: 7c8f             jl 0x5d6
  042F17  0647: b81700           mov ax, 0x17
  042F1A  064A: eb8d             jmp 0x5d9
  042F1C  064C: 5e               pop si
  042F1D  064D: c9               leave 
  042F1E  064E: cb               retf 

; ---- func_042F20  size=182  insns=65  prologue=push bp;mov bp,sp  terminal=RETF ----
  042F20  0650: 55               push bp
  042F21  0651: 8bec             mov bp, sp
  042F23  0653: ff760a           push word ptr [bp + 0xa]
  042F26  0656: ff7608           push word ptr [bp + 8]
  042F29  0659: 9a02031f18       lcall 0x181f, 0x302
  042F2E  065E: 8be5             mov sp, bp
  042F30  0660: 0bc0             or ax, ax
  042F32  0662: 752a             jne 0x68e
  042F34  0664: 39460c           cmp word ptr [bp + 0xc], ax
  042F37  0667: 7c1f             jl 0x688
  042F39  0669: 8a460c           mov al, byte ptr [bp + 0xc]
  042F3C  066C: 2a4608           sub al, byte ptr [bp + 8]
  042F3F  066F: 3c14             cmp al, 0x14
  042F41  0671: 7515             jne 0x688
  042F43  0673: 8b5e0c           mov bx, word ptr [bp + 0xc]
  042F46  0676: d1e3             shl bx, 1
  042F48  0678: ffb78c83         push word ptr [bx - 0x7c74]
  042F4C  067C: ff7606           push word ptr [bp + 6]
  042F4F  067F: 9a6e011f18       lcall 0x181f, 0x16e
  042F54  0684: 8be5             mov sp, bp
  042F56  0686: c9               leave 
  042F57  0687: cb               retf 
  042F58  0688: ff36322e         push word ptr [0x2e32]
  042F5C  068C: ebee             jmp 0x67c
  042F5E  068E: ff760a           push word ptr [bp + 0xa]
  042F61  0691: ff7608           push word ptr [bp + 8]
  042F64  0694: 9a8c071f18       lcall 0x181f, 0x78c
  042F69  0699: 8be5             mov sp, bp
  042F6B  069B: 3d1a00           cmp ax, 0x1a
  042F6E  069E: 7506             jne 0x6a6
  042F70  06A0: 837e0e00         cmp word ptr [bp + 0xe], 0
  042F74  06A4: 75cd             jne 0x673
  042F76  06A6: ff760a           push word ptr [bp + 0xa]
  042F79  06A9: ff7608           push word ptr [bp + 8]
  042F7C  06AC: 9abe071f18       lcall 0x181f, 0x7be
  042F81  06B1: 8be5             mov sp, bp
  042F83  06B3: a3c68d           mov word ptr [0x8dc6], ax
  042F86  06B6: 0bc0             or ax, ax
  042F88  06B8: 7c12             jl 0x6cc
  042F8A  06BA: 69c0ca00         imul ax, ax, 0xca
  042F8E  06BE: 05485d           add ax, 0x5d48
  042F91  06C1: 50               push ax
  042F92  06C2: ff7606           push word ptr [bp + 6]
  042F95  06C5: 9ae4071d0d       lcall 0xd1d, 0x7e4
  042F9A  06CA: ebb8             jmp 0x684
  042F9C  06CC: ff7606           push word ptr [bp + 6]
  042F9F  06CF: 9a1e011f18       lcall 0x181f, 0x11e
  042FA4  06D4: 8be5             mov sp, bp
  042FA6  06D6: ff7608           push word ptr [bp + 8]
  042FA9  06D9: 1e               push ds
  042FAA  06DA: ff7606           push word ptr [bp + 6]
  042FAD  06DD: 9a82011f18       lcall 0x181f, 0x182
  042FB2  06E2: 8be5             mov sp, bp
  042FB4  06E4: ff7606           push word ptr [bp + 6]
  042FB7  06E7: 9ab4011f18       lcall 0x181f, 0x1b4
  042FBC  06EC: 8be5             mov sp, bp
  042FBE  06EE: ff760a           push word ptr [bp + 0xa]
  042FC1  06F1: 1e               push ds
  042FC2  06F2: ff7606           push word ptr [bp + 6]
  042FC5  06F5: 9a82011f18       lcall 0x181f, 0x182
  042FCA  06FA: 8be5             mov sp, bp
  042FCC  06FC: ff7606           push word ptr [bp + 6]
  042FCF  06FF: 9a28011f18       lcall 0x181f, 0x128
  042FD4  0704: c9               leave 
  042FD5  0705: cb               retf 

; ---- func_042FD6  size=157  insns=52  prologue=ENTER 0x0006,0  terminal=RETF ----
  042FD6  0706: c8060000         enter 6, 0
  042FDA  070A: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  042FDE  070E: 8a875b31         mov al, byte ptr [bx + 0x315b]
  042FE2  0712: 98               cwde 
  042FE3  0713: 8946fe           mov word ptr [bp - 2], ax
  042FE6  0716: 8a8f4631         mov cl, byte ptr [bx + 0x3146]
  042FEA  071A: 2aed             sub ch, ch
  042FEC  071C: 894efc           mov word ptr [bp - 4], cx
  042FEF  071F: 3d1c00           cmp ax, 0x1c
  042FF2  0722: 7505             jne 0x729
  042FF4  0724: c746fe1300       mov word ptr [bp - 2], 0x13
  042FF9  0729: 8b5efe           mov bx, word ptr [bp - 2]
  042FFC  072C: c1e303           shl bx, 3
  042FFF  072F: 8b87a28e         mov ax, word ptr [bx - 0x715e]
  043003  0733: 8946fa           mov word ptr [bp - 6], ax
  043006  0736: 0bc9             or cx, cx
  043008  0738: 741a             je 0x754
  04300A  073A: 837e0a00         cmp word ptr [bp + 0xa], 0
  04300E  073E: 7514             jne 0x754
  043010  0740: ff76fe           push word ptr [bp - 2]
  043013  0743: 9a9a0c1f18       lcall 0x181f, 0xc9a
  043018  0748: 83c402           add sp, 2
  04301B  074B: 0bc0             or ax, ax
  04301D  074D: 7505             jne 0x754
  04301F  074F: c746faffff       mov word ptr [bp - 6], 0xffff
  043024  0754: 837efc01         cmp word ptr [bp - 4], 1
  043028  0758: 7406             je 0x760
  04302A  075A: 837efc04         cmp word ptr [bp - 4], 4
  04302E  075E: 750c             jne 0x76c
  043030  0760: 837efe15         cmp word ptr [bp - 2], 0x15
  043034  0764: 7506             jne 0x76c
  043036  0766: a13c2e           mov ax, word ptr [0x2e3c]
  043039  0769: 8946fa           mov word ptr [bp - 6], ax
  04303C  076C: 837efc05         cmp word ptr [bp - 4], 5
  043040  0770: 750c             jne 0x77e
  043042  0772: 837efe16         cmp word ptr [bp - 2], 0x16
  043046  0776: 7506             jne 0x77e
  043048  0778: a1c22d           mov ax, word ptr [0x2dc2]
  04304B  077B: 8946fa           mov word ptr [bp - 6], ax
  04304E  077E: 837efc03         cmp word ptr [bp - 4], 3
  043052  0782: 750c             jne 0x790
  043054  0784: 837efe18         cmp word ptr [bp - 2], 0x18
  043058  0788: 7506             jne 0x790
  04305A  078A: a1c22d           mov ax, word ptr [0x2dc2]
  04305D  078D: 8946fa           mov word ptr [bp - 6], ax
  043060  0790: 837efa00         cmp word ptr [bp - 6], 0
  043064  0794: 7c0b             jl 0x7a1
  043066  0796: ff76fa           push word ptr [bp - 6]
  043069  0799: ff7606           push word ptr [bp + 6]
  04306C  079C: 9a6e011f18       lcall 0x181f, 0x16e
  043071  07A1: c9               leave 
  043072  07A2: cb               retf 

; ---- func_043074  size=4990  insns=1678  prologue=ENTER 0x00C0,0  terminal=page-end ----
  043074  07A4: c8c00000         enter 0xc0, 0
  043078  07A8: 57               push di
  043079  07A9: 56               push si
  04307A  07AA: 0e               push cs
  04307B  07AB: e85b13           call 0x1b09
  04307E  07AE: 6a00             push 0
  043080  07B0: a14085           mov ax, word ptr [0x8540]
  043083  07B3: 8b163e85         mov dx, word ptr [0x853e]
  043087  07B7: 9ae0071f18       lcall 0x181f, 0x7e0
  04308C  07BC: 894698           mov word ptr [bp - 0x68], ax
  04308F  07BF: 50               push ax
  043090  07C0: 9aea071f18       lcall 0x181f, 0x7ea
  043095  07C5: 83c404           add sp, 4
  043098  07C8: 8b4698           mov ax, word ptr [bp - 0x68]
  04309B  07CB: 9aee021f18       lcall 0x181f, 0x2ee
  0430A0  07D0: 894698           mov word ptr [bp - 0x68], ax
  0430A3  07D3: 833e965304       cmp word ptr [0x5396], 4
  0430A8  07D8: 7d26             jge 0x800
  0430AA  07DA: ff363e85         push word ptr [0x853e]
  0430AE  07DE: ff364085         push word ptr [0x8540]
  0430B2  07E2: 9a4a071f18       lcall 0x181f, 0x74a
  0430B7  07E7: 83c404           add sp, 4
  0430BA  07EA: 2ae4             sub ah, ah
  0430BC  07EC: 8a0e9653         mov cl, byte ptr [0x5396]
  0430C0  07F0: ba1000           mov dx, 0x10
  0430C3  07F3: d3e2             shl dx, cl
  0430C5  07F5: 85c2             test dx, ax
  0430C7  07F7: 7507             jne 0x800
  0430C9  07F9: 833ea25300       cmp word ptr [0x53a2], 0
  0430CE  07FE: 7408             je 0x808
  0430D0  0800: c78650ff0100     mov word ptr [bp - 0xb0], 1
  0430D6  0806: eb06             jmp 0x80e
  0430D8  0808: c78650ff0000     mov word ptr [bp - 0xb0], 0
  0430DE  080E: c7468e3300       mov word ptr [bp - 0x72], 0x33
  0430E3  0813: c74692f200       mov word ptr [bp - 0x6e], 0xf2
  0430E8  0818: c41e9e08         les bx, ptr [0x89e]
  0430EC  081C: 268a07           mov al, byte ptr es:[bx]
  0430EF  081F: 2ae4             sub ah, ah
  0430F1  0821: 40               inc ax
  0430F2  0822: 8946fa           mov word ptr [bp - 6], ax
  0430F5  0825: c646aa00         mov byte ptr [bp - 0x56], 0
  0430F9  0829: 8b1e8c53         mov bx, word ptr [0x538c]
  0430FD  082D: d1e3             shl bx, 1
  0430FF  082F: ffb70098         push word ptr [bx - 0x6800]
  043103  0833: 8d46aa           lea ax, [bp - 0x56]
  043106  0836: 50               push ax
  043107  0837: 9a6e011f18       lcall 0x181f, 0x16e
  04310C  083C: 83c404           add sp, 4
  04310F  083F: 8d46aa           lea ax, [bp - 0x56]
  043112  0842: 50               push ax
  043113  0843: 9a78011f18       lcall 0x181f, 0x178
  043118  0848: 83c402           add sp, 2
  04311B  084B: ff368a53         push word ptr [0x538a]
  04311F  084F: 8d46aa           lea ax, [bp - 0x56]
  043122  0852: 16               push ss
  043123  0853: 50               push ax
  043124  0854: 9a82011f18       lcall 0x181f, 0x182
  043129  0859: 83c406           add sp, 6
  04312C  085C: ff768e           push word ptr [bp - 0x72]
  04312F  085F: ff7692           push word ptr [bp - 0x6e]
  043132  0862: 8d46aa           lea ax, [bp - 0x56]
  043135  0865: 16               push ss
  043136  0866: 50               push ax
  043137  0867: 9a32011f18       lcall 0x181f, 0x132
  04313C  086C: 83c408           add sp, 8
  04313F  086F: 8b46fa           mov ax, word ptr [bp - 6]
  043142  0872: 01468e           add word ptr [bp - 0x72], ax
  043145  0875: c646aa00         mov byte ptr [bp - 0x56], 0
  043149  0879: ff36a093         push word ptr [0x93a0]
  04314D  087D: 8d46aa           lea ax, [bp - 0x56]
  043150  0880: 50               push ax
  043151  0881: 9a6e011f18       lcall 0x181f, 0x16e
  043156  0886: 83c404           add sp, 4
  043159  0889: 837e0800         cmp word ptr [bp + 8], 0
  04315D  088D: 7405             je 0x894
  04315F  088F: a19853           mov ax, word ptr [0x5398]
  043162  0892: eb03             jmp 0x897
  043164  0894: a19653           mov ax, word ptr [0x5396]
  043167  0897: 69d83c01         imul bx, ax, 0x13c
  04316B  089B: ffb73488         push word ptr [bx - 0x77cc]
  04316F  089F: ffb73288         push word ptr [bx - 0x77ce]
  043173  08A3: 8d46aa           lea ax, [bp - 0x56]
  043176  08A6: 16               push ss
  043177  08A7: 50               push ax
  043178  08A8: 9ad8001f18       lcall 0x181f, 0xd8
  04317D  08AD: 83c408           add sp, 8
  043180  08B0: 8d46aa           lea ax, [bp - 0x56]
  043183  08B3: 50               push ax
  043184  08B4: 9a78011f18       lcall 0x181f, 0x178
  043189  08B9: 83c402           add sp, 2
  04318C  08BC: 8d46aa           lea ax, [bp - 0x56]
  04318F  08BF: 50               push ax
  043190  08C0: 9a78011f18       lcall 0x181f, 0x178
  043195  08C5: 83c402           add sp, 2
  043198  08C8: ff36b093         push word ptr [0x93b0]
  04319C  08CC: 8d46aa           lea ax, [bp - 0x56]
  04319F  08CF: 50               push ax
  0431A0  08D0: 9a6e011f18       lcall 0x181f, 0x16e
  0431A5  08D5: 83c404           add sp, 4
  0431A8  08D8: 8d46aa           lea ax, [bp - 0x56]
  0431AB  08DB: 50               push ax
  0431AC  08DC: 9a78011f18       lcall 0x181f, 0x178
  0431B1  08E1: 83c402           add sp, 2
  0431B4  08E4: 837e0800         cmp word ptr [bp + 8], 0
  0431B8  08E8: 7406             je 0x8f0
  0431BA  08EA: a19853           mov ax, word ptr [0x5398]
  0431BD  08ED: eb04             jmp 0x8f3
  0431BF  08EF: 90               nop 
  0431C0  08F0: a19653           mov ax, word ptr [0x5396]
  0431C3  08F3: 69d83c01         imul bx, ax, 0x13c
  0431C7  08F7: 8a870988         mov al, byte ptr [bx - 0x77f7]
  0431CB  08FB: 98               cwde 
  0431CC  08FC: 50               push ax
  0431CD  08FD: 8d46aa           lea ax, [bp - 0x56]
  0431D0  0900: 16               push ss
  0431D1  0901: 50               push ax
  0431D2  0902: 9a82011f18       lcall 0x181f, 0x182
  0431D7  0907: 83c406           add sp, 6
  0431DA  090A: 8d46aa           lea ax, [bp - 0x56]
  0431DD  090D: 50               push ax
  0431DE  090E: 9a0a011f18       lcall 0x181f, 0x10a
  0431E3  0913: 83c402           add sp, 2
  0431E6  0916: ff768e           push word ptr [bp - 0x72]
  0431E9  0919: ff7692           push word ptr [bp - 0x6e]
  0431EC  091C: 8d46aa           lea ax, [bp - 0x56]
  0431EF  091F: 16               push ss
  0431F0  0920: 50               push ax
  0431F1  0921: 9a32011f18       lcall 0x181f, 0x132
  0431F6  0926: 83c408           add sp, 8
  0431F9  0929: 8b46fa           mov ax, word ptr [bp - 6]
  0431FC  092C: 01468e           add word ptr [bp - 0x72], ax
  0431FF  092F: 837e0800         cmp word ptr [bp + 8], 0
  043203  0933: 7403             je 0x938
  043205  0935: e98811           jmp 0x1ac0
  043208  0938: d1f8             sar ax, 1
  04320A  093A: 01468e           add word ptr [bp - 0x72], ax
  04320D  093D: 833e905301       cmp word ptr [0x5390], 1
  043212  0942: 1bc0             sbb ax, ax
  043214  0944: f7d8             neg ax
  043216  0946: 8946fe           mov word ptr [bp - 2], ax
  043219  0949: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  04321E  094E: 8a874731         mov al, byte ptr [bx + 0x3147]
  043222  0952: 240f             and al, 0xf
  043224  0954: 3a069653         cmp al, byte ptr [0x5396]
  043228  0958: 740c             je 0x966
  04322A  095A: 833ea25300       cmp word ptr [0x53a2], 0
  04322F  095F: 7505             jne 0x966
  043231  0961: c746fe0000       mov word ptr [bp - 2], 0
  043236  0966: 837efe00         cmp word ptr [bp - 2], 0
  04323A  096A: 7503             jne 0x96f
  04323C  096C: e96d04           jmp 0xddc
  04323F  096F: 8b468e           mov ax, word ptr [bp - 0x72]
  043242  0972: 83468e02         add word ptr [bp - 0x72], 2
  043246  0976: 898644ff         mov word ptr [bp - 0xbc], ax
  04324A  097A: 50               push ax
  04324B  097B: 6a10             push 0x10
  04324D  097D: 6a64             push 0x64
  04324F  097F: a19253           mov ax, word ptr [0x5392]
  043252  0982: 898652ff         mov word ptr [bp - 0xae], ax
  043256  0986: 2bd2             sub dx, dx
  043258  0988: 8b5e92           mov bx, word ptr [bp - 0x6e]
  04325B  098B: 9abc021f18       lcall 0x181f, 0x2bc
  043260  0990: 8b4692           mov ax, word ptr [bp - 0x6e]
  043263  0993: 051200           add ax, 0x12
  043266  0996: 89867aff         mov word ptr [bp - 0x86], ax
  04326A  099A: c646aa00         mov byte ptr [bp - 0x56], 0
  04326E  099E: ff36f496         push word ptr [0x96f4]
  043272  09A2: 8d46aa           lea ax, [bp - 0x56]
  043275  09A5: 50               push ax
  043276  09A6: 9a6e011f18       lcall 0x181f, 0x16e
  04327B  09AB: 83c404           add sp, 4
  04327E  09AE: 8d46aa           lea ax, [bp - 0x56]
  043281  09B1: 50               push ax
  043282  09B2: 9a78011f18       lcall 0x181f, 0x178
  043287  09B7: 83c402           add sp, 2
  04328A  09BA: ffb652ff         push word ptr [bp - 0xae]
  04328E  09BE: 9a0c091f18       lcall 0x181f, 0x90c
  043293  09C3: 83c402           add sp, 2
  043296  09C6: 2ae4             sub ah, ah
  043298  09C8: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  04329D  09CD: 8a8f4931         mov cl, byte ptr [bx + 0x3149]
  0432A1  09D1: 2aed             sub ch, ch
  0432A3  09D3: 2bc1             sub ax, cx
  0432A5  09D5: 89864eff         mov word ptr [bp - 0xb2], ax
  0432A9  09D9: 0bc0             or ax, ax
  0432AB  09DB: 7d02             jge 0x9df
  0432AD  09DD: 2bc0             sub ax, ax
  0432AF  09DF: 89864eff         mov word ptr [bp - 0xb2], ax
  0432B3  09E3: b90300           mov cx, 3
  0432B6  09E6: 99               cdq 
  0432B7  09E7: f7f9             idiv cx
  0432B9  09E9: 89967eff         mov word ptr [bp - 0x82], dx
  0432BD  09ED: 8b864eff         mov ax, word ptr [bp - 0xb2]
  0432C1  09F1: 99               cdq 
  0432C2  09F2: f7f9             idiv cx
  0432C4  09F4: 89864eff         mov word ptr [bp - 0xb2], ax
  0432C8  09F8: 0bc0             or ax, ax
  0432CA  09FA: 7506             jne 0xa02
  0432CC  09FC: 39867eff         cmp word ptr [bp - 0x82], ax
  0432D0  0A00: 7521             jne 0xa23
  0432D2  0A02: 50               push ax
  0432D3  0A03: 8d46aa           lea ax, [bp - 0x56]
  0432D6  0A06: 16               push ss
  0432D7  0A07: 50               push ax
  0432D8  0A08: 9a82011f18       lcall 0x181f, 0x182
  0432DD  0A0D: 83c406           add sp, 6
  0432E0  0A10: 83be7eff00       cmp word ptr [bp - 0x82], 0
  0432E5  0A15: 740c             je 0xa23
  0432E7  0A17: 8d46aa           lea ax, [bp - 0x56]
  0432EA  0A1A: 50               push ax
  0432EB  0A1B: 9a78011f18       lcall 0x181f, 0x178
  0432F0  0A20: 83c402           add sp, 2
  0432F3  0A23: 83be7eff00       cmp word ptr [bp - 0x82], 0
  0432F8  0A28: 7420             je 0xa4a
  0432FA  0A2A: ffb67eff         push word ptr [bp - 0x82]
  0432FE  0A2E: 8d46aa           lea ax, [bp - 0x56]
  043301  0A31: 16               push ss
  043302  0A32: 50               push ax
  043303  0A33: 9a82011f18       lcall 0x181f, 0x182
  043308  0A38: 83c406           add sp, 6
  04330B  0A3B: 689814           push 0x1498
  04330E  0A3E: 8d46aa           lea ax, [bp - 0x56]
  043311  0A41: 50               push ax
  043312  0A42: 9aa4071d0d       lcall 0xd1d, 0x7a4
  043317  0A47: 83c404           add sp, 4
  04331A  0A4A: ff768e           push word ptr [bp - 0x72]
  04331D  0A4D: ffb67aff         push word ptr [bp - 0x86]
  043321  0A51: 8d46aa           lea ax, [bp - 0x56]
  043324  0A54: 16               push ss
  043325  0A55: 50               push ax
  043326  0A56: 9a32011f18       lcall 0x181f, 0x132
  04332B  0A5B: 83c408           add sp, 8
  04332E  0A5E: 8b46fa           mov ax, word ptr [bp - 6]
  043331  0A61: 01468e           add word ptr [bp - 0x72], ax
  043334  0A64: c646aa00         mov byte ptr [bp - 0x56], 0
  043338  0A68: ff36f696         push word ptr [0x96f6]
  04333C  0A6C: 8d46aa           lea ax, [bp - 0x56]
  04333F  0A6F: 50               push ax
  043340  0A70: 9a6e011f18       lcall 0x181f, 0x16e
  043345  0A75: 83c404           add sp, 4
  043348  0A78: 8d46aa           lea ax, [bp - 0x56]
  04334B  0A7B: 50               push ax
  04334C  0A7C: 9a78011f18       lcall 0x181f, 0x178
  043351  0A81: 83c402           add sp, 2
  043354  0A84: 8d46aa           lea ax, [bp - 0x56]
  043357  0A87: 50               push ax
  043358  0A88: 9a1e011f18       lcall 0x181f, 0x11e
  04335D  0A8D: 83c402           add sp, 2
  043360  0A90: ff364085         push word ptr [0x8540]
  043364  0A94: 8d46aa           lea ax, [bp - 0x56]
  043367  0A97: 16               push ss
  043368  0A98: 50               push ax
  043369  0A99: 9a82011f18       lcall 0x181f, 0x182
  04336E  0A9E: 83c406           add sp, 6
  043371  0AA1: 8d46aa           lea ax, [bp - 0x56]
  043374  0AA4: 50               push ax
  043375  0AA5: 9ab4011f18       lcall 0x181f, 0x1b4
  04337A  0AAA: 83c402           add sp, 2
  04337D  0AAD: ff363e85         push word ptr [0x853e]
  043381  0AB1: 8d46aa           lea ax, [bp - 0x56]
  043384  0AB4: 16               push ss
  043385  0AB5: 50               push ax
  043386  0AB6: 9a82011f18       lcall 0x181f, 0x182
  04338B  0ABB: 83c406           add sp, 6
  04338E  0ABE: 8d46aa           lea ax, [bp - 0x56]
  043391  0AC1: 50               push ax
  043392  0AC2: 9a28011f18       lcall 0x181f, 0x128
  043397  0AC7: 83c402           add sp, 2
  04339A  0ACA: f606835320       test byte ptr [0x5383], 0x20
  04339F  0ACF: 743a             je 0xb0b
  0433A1  0AD1: 833ea25300       cmp word ptr [0x53a2], 0
  0433A6  0AD6: 7507             jne 0xadf
  0433A8  0AD8: 833ea45300       cmp word ptr [0x53a4], 0
  0433AD  0ADD: 742c             je 0xb0b
  0433AF  0ADF: 8d46aa           lea ax, [bp - 0x56]
  0433B2  0AE2: 50               push ax
  0433B3  0AE3: 9a78011f18       lcall 0x181f, 0x178
  0433B8  0AE8: 83c402           add sp, 2
  0433BB  0AEB: ff363e85         push word ptr [0x853e]
  0433BF  0AEF: ff364085         push word ptr [0x8540]
  0433C3  0AF3: 9ab4061f18       lcall 0x181f, 0x6b4
  0433C8  0AF8: 83c404           add sp, 4
  0433CB  0AFB: 2ae4             sub ah, ah
  0433CD  0AFD: 50               push ax
  0433CE  0AFE: 8d46aa           lea ax, [bp - 0x56]
  0433D1  0B01: 16               push ss
  0433D2  0B02: 50               push ax
  0433D3  0B03: 9a82011f18       lcall 0x181f, 0x182
  0433D8  0B08: 83c406           add sp, 6
  0433DB  0B0B: ff768e           push word ptr [bp - 0x72]
  0433DE  0B0E: ffb67aff         push word ptr [bp - 0x86]
  0433E2  0B12: 8d46aa           lea ax, [bp - 0x56]
  0433E5  0B15: 16               push ss
  0433E6  0B16: 50               push ax
  0433E7  0B17: 9a32011f18       lcall 0x181f, 0x132
  0433EC  0B1C: 83c408           add sp, 8
  0433EF  0B1F: 8b8644ff         mov ax, word ptr [bp - 0xbc]
  0433F3  0B23: 051200           add ax, 0x12
  0433F6  0B26: 89468e           mov word ptr [bp - 0x72], ax
  0433F9  0B29: c646aa00         mov byte ptr [bp - 0x56], 0
  0433FD  0B2D: 833ea25300       cmp word ptr [0x53a2], 0
  043402  0B32: 7424             je 0xb58
  043404  0B34: f606835320       test byte ptr [0x5383], 0x20
  043409  0B39: 741d             je 0xb58
  04340B  0B3B: ffb652ff         push word ptr [bp - 0xae]
  04340F  0B3F: 8d46aa           lea ax, [bp - 0x56]
  043412  0B42: 16               push ss
  043413  0B43: 50               push ax
  043414  0B44: 9a82011f18       lcall 0x181f, 0x182
  043419  0B49: 83c406           add sp, 6
  04341C  0B4C: 8d46aa           lea ax, [bp - 0x56]
  04341F  0B4F: 50               push ax
  043420  0B50: 9a78011f18       lcall 0x181f, 0x178
  043425  0B55: 83c402           add sp, 2
  043428  0B58: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  04342D  0B5D: 8bc3             mov ax, bx
  04342F  0B5F: 8a9f4731         mov bl, byte ptr [bx + 0x3147]
  043433  0B63: 83e30f           and bx, 0xf
  043436  0B66: d1e3             shl bx, 1
  043438  0B68: ffb7f097         push word ptr [bx - 0x6810]
  04343C  0B6C: 8d4eaa           lea cx, [bp - 0x56]
  04343F  0B6F: 51               push cx
  043440  0B70: 8bf0             mov si, ax
  043442  0B72: 9a6e011f18       lcall 0x181f, 0x16e
  043447  0B77: 83c404           add sp, 4
  04344A  0B7A: 8d46aa           lea ax, [bp - 0x56]
  04344D  0B7D: 50               push ax
  04344E  0B7E: 9a78011f18       lcall 0x181f, 0x178
  043453  0B83: 83c402           add sp, 2
  043456  0B86: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  04345A  0B8A: 2aff             sub bh, bh
  04345C  0B8C: 8bc3             mov ax, bx
  04345E  0B8E: d1e3             shl bx, 1
  043460  0B90: 03d8             add bx, ax
  043462  0B92: d1e3             shl bx, 1
  043464  0B94: 03d8             add bx, ax
  043466  0B96: d1e3             shl bx, 1
  043468  0B98: ffb73052         push word ptr [bx + 0x5230]
  04346C  0B9C: 8d46aa           lea ax, [bp - 0x56]
  04346F  0B9F: 50               push ax
  043470  0BA0: 9a6e011f18       lcall 0x181f, 0x16e
  043475  0BA5: 83c404           add sp, 4
  043478  0BA8: ff768e           push word ptr [bp - 0x72]
  04347B  0BAB: ff7692           push word ptr [bp - 0x6e]
  04347E  0BAE: 8d46aa           lea ax, [bp - 0x56]
  043481  0BB1: 16               push ss
  043482  0BB2: 50               push ax
  043483  0BB3: 9a32011f18       lcall 0x181f, 0x132
  043488  0BB8: 83c408           add sp, 8
  04348B  0BBB: 8b46fa           mov ax, word ptr [bp - 6]
  04348E  0BBE: 01468e           add word ptr [bp - 0x72], ax
  043491  0BC1: ffb652ff         push word ptr [bp - 0xae]
  043495  0BC5: 9a780b1f18       lcall 0x181f, 0xb78
  04349A  0BCA: 83c402           add sp, 2
  04349D  0BCD: 0bc0             or ax, ax
  04349F  0BCF: 7c34             jl 0xc05
  0434A1  0BD1: c646aa00         mov byte ptr [bp - 0x56], 0
  0434A5  0BD5: 6a01             push 1
  0434A7  0BD7: ffb652ff         push word ptr [bp - 0xae]
  0434AB  0BDB: 8d46aa           lea ax, [bp - 0x56]
  0434AE  0BDE: 50               push ax
  0434AF  0BDF: 0e               push cs
  0434B0  0BE0: e82b0f           call 0x1b0e
  0434B3  0BE3: 83c406           add sp, 6
  0434B6  0BE6: a03608           mov al, byte ptr [0x836]
  0434B9  0BE9: 2ae4             sub ah, ah
  0434BB  0BEB: 50               push ax
  0434BC  0BEC: ff768e           push word ptr [bp - 0x72]
  0434BF  0BEF: ff7692           push word ptr [bp - 0x6e]
  0434C2  0BF2: 8d46aa           lea ax, [bp - 0x56]
  0434C5  0BF5: 16               push ss
  0434C6  0BF6: 50               push ax
  0434C7  0BF7: 9a3c011f18       lcall 0x181f, 0x13c
  0434CC  0BFC: 83c40a           add sp, 0xa
  0434CF  0BFF: 8b46fa           mov ax, word ptr [bp - 6]
  0434D2  0C02: 01468e           add word ptr [bp - 0x72], ax
  0434D5  0C05: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  0434DA  0C0A: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  0434DF  0C0F: 756d             jne 0xc7e
  0434E1  0C11: c646aa00         mov byte ptr [bp - 0x56], 0
  0434E5  0C15: 8d46aa           lea ax, [bp - 0x56]
  0434E8  0C18: 50               push ax
  0434E9  0C19: 8bf3             mov si, bx
  0434EB  0C1B: 9a1e011f18       lcall 0x181f, 0x11e
  0434F0  0C20: 83c402           add sp, 2
  0434F3  0C23: 8a845931         mov al, byte ptr [si + 0x3159]
  0434F7  0C27: 2ae4             sub ah, ah
  0434F9  0C29: 50               push ax
  0434FA  0C2A: 8d46aa           lea ax, [bp - 0x56]
  0434FD  0C2D: 16               push ss
  0434FE  0C2E: 50               push ax
  0434FF  0C2F: 9a82011f18       lcall 0x181f, 0x182
  043504  0C34: 83c406           add sp, 6
  043507  0C37: 8d46aa           lea ax, [bp - 0x56]
  04350A  0C3A: 50               push ax
  04350B  0C3B: 9a78011f18       lcall 0x181f, 0x178
  043510  0C40: 83c402           add sp, 2
  043513  0C43: ff36dc97         push word ptr [0x97dc]
  043517  0C47: 8d46aa           lea ax, [bp - 0x56]
  04351A  0C4A: 50               push ax
  04351B  0C4B: 9a6e011f18       lcall 0x181f, 0x16e
  043520  0C50: 83c404           add sp, 4
  043523  0C53: 8d46aa           lea ax, [bp - 0x56]
  043526  0C56: 50               push ax
  043527  0C57: 9a28011f18       lcall 0x181f, 0x128
  04352C  0C5C: 83c402           add sp, 2
  04352F  0C5F: a03608           mov al, byte ptr [0x836]
  043532  0C62: 2ae4             sub ah, ah
  043534  0C64: 50               push ax
  043535  0C65: ff768e           push word ptr [bp - 0x72]
  043538  0C68: ff7692           push word ptr [bp - 0x6e]
  04353B  0C6B: 8d46aa           lea ax, [bp - 0x56]
  04353E  0C6E: 16               push ss
  04353F  0C6F: 50               push ax
  043540  0C70: 9a3c011f18       lcall 0x181f, 0x13c
  043545  0C75: 83c40a           add sp, 0xa
  043548  0C78: 8b46fa           mov ax, word ptr [bp - 6]
  04354B  0C7B: 01468e           add word ptr [bp - 0x72], ax
  04354E  0C7E: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  043553  0C83: 80bf46310a       cmp byte ptr [bx + 0x3146], 0xa
  043558  0C88: 7574             jne 0xcfe
  04355A  0C8A: c646aa00         mov byte ptr [bp - 0x56], 0
  04355E  0C8E: 8d46aa           lea ax, [bp - 0x56]
  043561  0C91: 50               push ax
  043562  0C92: 8bf3             mov si, bx
  043564  0C94: 9a1e011f18       lcall 0x181f, 0x11e
  043569  0C99: 83c402           add sp, 2
  04356C  0C9C: ff36a093         push word ptr [0x93a0]
  043570  0CA0: 8d46aa           lea ax, [bp - 0x56]
  043573  0CA3: 50               push ax
  043574  0CA4: 9a6e011f18       lcall 0x181f, 0x16e
  043579  0CA9: 83c404           add sp, 4
  04357C  0CAC: 8d46aa           lea ax, [bp - 0x56]
  04357F  0CAF: 50               push ax
  043580  0CB0: 9a78011f18       lcall 0x181f, 0x178
  043585  0CB5: 83c402           add sp, 2
  043588  0CB8: 8a845b31         mov al, byte ptr [si + 0x315b]
  04358C  0CBC: 2ae4             sub ah, ah
  04358E  0CBE: 898648ff         mov word ptr [bp - 0xb8], ax
  043592  0CC2: 6bc064           imul ax, ax, 0x64
  043595  0CC5: 50               push ax
  043596  0CC6: 8d46aa           lea ax, [bp - 0x56]
  043599  0CC9: 16               push ss
  04359A  0CCA: 50               push ax
  04359B  0CCB: 9a82011f18       lcall 0x181f, 0x182
  0435A0  0CD0: 83c406           add sp, 6
  0435A3  0CD3: 8d46aa           lea ax, [bp - 0x56]
  0435A6  0CD6: 50               push ax
  0435A7  0CD7: 9a28011f18       lcall 0x181f, 0x128
  0435AC  0CDC: 83c402           add sp, 2
  0435AF  0CDF: a03608           mov al, byte ptr [0x836]
  0435B2  0CE2: 2ae4             sub ah, ah
  0435B4  0CE4: 50               push ax
  0435B5  0CE5: ff768e           push word ptr [bp - 0x72]
  0435B8  0CE8: ff7692           push word ptr [bp - 0x6e]
  0435BB  0CEB: 8d46aa           lea ax, [bp - 0x56]
  0435BE  0CEE: 16               push ss
  0435BF  0CEF: 50               push ax
  0435C0  0CF0: 9a3c011f18       lcall 0x181f, 0x13c
  0435C5  0CF5: 83c40a           add sp, 0xa
  0435C8  0CF8: 8b46fa           mov ax, word ptr [bp - 6]
  0435CB  0CFB: 01468e           add word ptr [bp - 0x72], ax
  0435CE  0CFE: c646aa00         mov byte ptr [bp - 0x56], 0
  0435D2  0D02: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  0435D7  0D07: 8d874c31         lea ax, [bx + 0x314c]
  0435DB  0D0B: 8bf0             mov si, ax
  0435DD  0D0D: 8bcb             mov cx, bx
  0435DF  0D0F: 8a1c             mov bl, byte ptr [si]
  0435E1  0D11: 2aff             sub bh, bh
  0435E3  0D13: d1e3             shl bx, 1
  0435E5  0D15: ffb70498         push word ptr [bx - 0x67fc]
  0435E9  0D19: 8d56aa           lea dx, [bp - 0x56]
  0435EC  0D1C: 52               push dx
  0435ED  0D1D: 8bf8             mov di, ax
  0435EF  0D1F: 8bf1             mov si, cx
  0435F1  0D21: 9a6e011f18       lcall 0x181f, 0x16e
  0435F6  0D26: 83c404           add sp, 4
  0435F9  0D29: 8d46aa           lea ax, [bp - 0x56]
  0435FC  0D2C: 50               push ax
  0435FD  0D2D: 9a78011f18       lcall 0x181f, 0x178
  043602  0D32: 83c402           add sp, 2
  043605  0D35: 803d03           cmp byte ptr [di], 3
  043608  0D38: 7524             jne 0xd5e
  04360A  0D3A: 6a01             push 1
  04360C  0D3C: 8a844731         mov al, byte ptr [si + 0x3147]
  043610  0D40: 250f00           and ax, 0xf
  043613  0D43: 50               push ax
  043614  0D44: 8a844e31         mov al, byte ptr [si + 0x314e]
  043618  0D48: 2ae4             sub ah, ah
  04361A  0D4A: 50               push ax
  04361B  0D4B: 8a844d31         mov al, byte ptr [si + 0x314d]
  04361F  0D4F: 50               push ax
  043620  0D50: 8d46aa           lea ax, [bp - 0x56]
  043623  0D53: 50               push ax
  043624  0D54: 0e               push cs
  043625  0D55: e8a70d           call 0x1aff
  043628  0D58: 83c40a           add sp, 0xa
  04362B  0D5B: eb63             jmp 0xdc0
  04362D  0D5D: 90               nop 
  04362E  0D5E: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  043633  0D63: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  043638  0D68: 7556             jne 0xdc0
  04363A  0D6A: ffb652ff         push word ptr [bp - 0xae]
  04363E  0D6E: 8bf3             mov si, bx
  043640  0D70: 9a58081f18       lcall 0x181f, 0x858
  043645  0D75: 83c402           add sp, 2
  043648  0D78: 40               inc ax
  043649  0D79: 50               push ax
  04364A  0D7A: 8d46aa           lea ax, [bp - 0x56]
  04364D  0D7D: 16               push ss
  04364E  0D7E: 50               push ax
  04364F  0D7F: 9a82011f18       lcall 0x181f, 0x182
  043654  0D84: 83c406           add sp, 6
  043657  0D87: 8d46aa           lea ax, [bp - 0x56]
  04365A  0D8A: 50               push ax
  04365B  0D8B: 9a1e011f18       lcall 0x181f, 0x11e
  043660  0D90: 83c402           add sp, 2
  043663  0D93: 6a01             push 1
  043665  0D95: 8a844731         mov al, byte ptr [si + 0x3147]
  043669  0D99: 250f00           and ax, 0xf
  04366C  0D9C: 50               push ax
  04366D  0D9D: 8a844e31         mov al, byte ptr [si + 0x314e]
  043671  0DA1: 2ae4             sub ah, ah
  043673  0DA3: 50               push ax
  043674  0DA4: 8a844d31         mov al, byte ptr [si + 0x314d]
  043678  0DA8: 50               push ax
  043679  0DA9: 8d46aa           lea ax, [bp - 0x56]
  04367C  0DAC: 50               push ax
  04367D  0DAD: 0e               push cs
  04367E  0DAE: e84e0d           call 0x1aff
  043681  0DB1: 83c40a           add sp, 0xa
  043684  0DB4: 8d46aa           lea ax, [bp - 0x56]
  043687  0DB7: 50               push ax
  043688  0DB8: 9a28011f18       lcall 0x181f, 0x128
  04368D  0DBD: 83c402           add sp, 2
  043690  0DC0: a03608           mov al, byte ptr [0x836]
  043693  0DC3: 2ae4             sub ah, ah
  043695  0DC5: 50               push ax
  043696  0DC6: ff768e           push word ptr [bp - 0x72]
  043699  0DC9: ff7692           push word ptr [bp - 0x6e]
  04369C  0DCC: 8d46aa           lea ax, [bp - 0x56]
  04369F  0DCF: 16               push ss
  0436A0  0DD0: 50               push ax
  0436A1  0DD1: 9a3c011f18       lcall 0x181f, 0x13c
  0436A6  0DD6: 83c40a           add sp, 0xa
  0436A9  0DD9: e95d01           jmp 0xf39
  0436AC  0DDC: c646aa00         mov byte ptr [bp - 0x56], 0
  0436B0  0DE0: ff36f696         push word ptr [0x96f6]
  0436B4  0DE4: 8d46aa           lea ax, [bp - 0x56]
  0436B7  0DE7: 50               push ax
  0436B8  0DE8: 9a6e011f18       lcall 0x181f, 0x16e
  0436BD  0DED: 83c404           add sp, 4
  0436C0  0DF0: 8d46aa           lea ax, [bp - 0x56]
  0436C3  0DF3: 50               push ax
  0436C4  0DF4: 9a78011f18       lcall 0x181f, 0x178
  0436C9  0DF9: 83c402           add sp, 2
  0436CC  0DFC: 8d46aa           lea ax, [bp - 0x56]
  0436CF  0DFF: 50               push ax
  0436D0  0E00: 9a1e011f18       lcall 0x181f, 0x11e
  0436D5  0E05: 83c402           add sp, 2
  0436D8  0E08: ff364085         push word ptr [0x8540]
  0436DC  0E0C: 8d46aa           lea ax, [bp - 0x56]
  0436DF  0E0F: 16               push ss
  0436E0  0E10: 50               push ax
  0436E1  0E11: 9a82011f18       lcall 0x181f, 0x182
  0436E6  0E16: 83c406           add sp, 6
  0436E9  0E19: 8d46aa           lea ax, [bp - 0x56]
  0436EC  0E1C: 50               push ax
  0436ED  0E1D: 9ab4011f18       lcall 0x181f, 0x1b4
  0436F2  0E22: 83c402           add sp, 2
  0436F5  0E25: ff363e85         push word ptr [0x853e]
  0436F9  0E29: 8d46aa           lea ax, [bp - 0x56]
  0436FC  0E2C: 16               push ss
  0436FD  0E2D: 50               push ax
  0436FE  0E2E: 9a82011f18       lcall 0x181f, 0x182
  043703  0E33: 83c406           add sp, 6
  043706  0E36: 8d46aa           lea ax, [bp - 0x56]
  043709  0E39: 50               push ax
  04370A  0E3A: 9a28011f18       lcall 0x181f, 0x128
  04370F  0E3F: 83c402           add sp, 2
  043712  0E42: 833ea25300       cmp word ptr [0x53a2], 0
  043717  0E47: 7507             jne 0xe50
  043719  0E49: 833ea45300       cmp word ptr [0x53a4], 0
  04371E  0E4E: 742c             je 0xe7c
  043720  0E50: 8d46aa           lea ax, [bp - 0x56]
  043723  0E53: 50               push ax
  043724  0E54: 9a78011f18       lcall 0x181f, 0x178
  043729  0E59: 83c402           add sp, 2
  04372C  0E5C: ff363e85         push word ptr [0x853e]
  043730  0E60: ff364085         push word ptr [0x8540]
  043734  0E64: 9ab4061f18       lcall 0x181f, 0x6b4
  043739  0E69: 83c404           add sp, 4
  04373C  0E6C: 2ae4             sub ah, ah
  04373E  0E6E: 50               push ax
  04373F  0E6F: 8d46aa           lea ax, [bp - 0x56]
  043742  0E72: 16               push ss
  043743  0E73: 50               push ax
  043744  0E74: 9a82011f18       lcall 0x181f, 0x182
  043749  0E79: 83c406           add sp, 6
  04374C  0E7C: ff768e           push word ptr [bp - 0x72]
  04374F  0E7F: ff7692           push word ptr [bp - 0x6e]
  043752  0E82: 8d46aa           lea ax, [bp - 0x56]
  043755  0E85: 16               push ss
  043756  0E86: 50               push ax
  043757  0E87: 9a32011f18       lcall 0x181f, 0x132
  04375C  0E8C: 83c408           add sp, 8
  04375F  0E8F: 8b46fa           mov ax, word ptr [bp - 6]
  043762  0E92: 01468e           add word ptr [bp - 0x72], ax
  043765  0E95: 83be50ff00       cmp word ptr [bp - 0xb0], 0
  04376A  0E9A: 7503             jne 0xe9f
  04376C  0E9C: e9a000           jmp 0xf3f
  04376F  0E9F: ff363e85         push word ptr [0x853e]
  043773  0EA3: ff364085         push word ptr [0x8540]
  043777  0EA7: 9a68071f18       lcall 0x181f, 0x768
  04377C  0EAC: 83c404           add sp, 4
  04377F  0EAF: 0bc0             or ax, ax
  043781  0EB1: 7403             je 0xeb6
  043783  0EB3: e98900           jmp 0xf3f
  043786  0EB6: c646aa00         mov byte ptr [bp - 0x56], 0
  04378A  0EBA: ff363e85         push word ptr [0x853e]
  04378E  0EBE: ff364085         push word ptr [0x8540]
  043792  0EC2: 9adc061f18       lcall 0x181f, 0x6dc
  043797  0EC7: 83c404           add sp, 4
  04379A  0ECA: 98               cwde 
  04379B  0ECB: 894680           mov word ptr [bp - 0x80], ax
  04379E  0ECE: 0bc0             or ax, ax
  0437A0  0ED0: 7d06             jge 0xed8
  0437A2  0ED2: ff36dc2d         push word ptr [0x2ddc]
  0437A6  0ED6: eb42             jmp 0xf1a
  0437A8  0ED8: 3d0400           cmp ax, 4
  0437AB  0EDB: 7d15             jge 0xef2
  0437AD  0EDD: 50               push ax
  0437AE  0EDE: 9a2e0a1f18       lcall 0x181f, 0xa2e
  0437B3  0EE3: 83c402           add sp, 2
  0437B6  0EE6: 50               push ax
  0437B7  0EE7: 8d46aa           lea ax, [bp - 0x56]
  0437BA  0EEA: 50               push ax
  0437BB  0EEB: 9aa4071d0d       lcall 0xd1d, 0x7a4
  0437C0  0EF0: eb31             jmp 0xf23
  0437C2  0EF2: 8bd8             mov bx, ax
  0437C4  0EF4: d1e3             shl bx, 1
  0437C6  0EF6: 03d8             add bx, ax
  0437C8  0EF8: d1e3             shl bx, 1
  0437CA  0EFA: ffb7fc8c         push word ptr [bx - 0x7304]
  0437CE  0EFE: 8d46aa           lea ax, [bp - 0x56]
  0437D1  0F01: 50               push ax
  0437D2  0F02: 9a6e011f18       lcall 0x181f, 0x16e
  0437D7  0F07: 83c404           add sp, 4
  0437DA  0F0A: 8d46aa           lea ax, [bp - 0x56]
  0437DD  0F0D: 50               push ax
  0437DE  0F0E: 9a78011f18       lcall 0x181f, 0x178
  0437E3  0F13: 83c402           add sp, 2
  0437E6  0F16: ff36de2d         push word ptr [0x2dde]
  0437EA  0F1A: 8d46aa           lea ax, [bp - 0x56]
  0437ED  0F1D: 50               push ax
  0437EE  0F1E: 9a6e011f18       lcall 0x181f, 0x16e
  0437F3  0F23: 83c404           add sp, 4
  0437F6  0F26: ff768e           push word ptr [bp - 0x72]
  0437F9  0F29: ff7692           push word ptr [bp - 0x6e]
  0437FC  0F2C: 8d46aa           lea ax, [bp - 0x56]
  0437FF  0F2F: 16               push ss
  043800  0F30: 50               push ax
  043801  0F31: 9a32011f18       lcall 0x181f, 0x132
  043806  0F36: 83c408           add sp, 8
  043809  0F39: 8b46fa           mov ax, word ptr [bp - 6]
  04380C  0F3C: 01468e           add word ptr [bp - 0x72], ax
  04380F  0F3F: ff363e85         push word ptr [0x853e]
  043813  0F43: ff364085         push word ptr [0x8540]
  043817  0F47: 9a2c071f18       lcall 0x181f, 0x72c
  04381C  0F4C: 83c404           add sp, 4
  04381F  0F4F: 88864aff         mov byte ptr [bp - 0xb6], al
  043823  0F53: 83be50ff00       cmp word ptr [bp - 0xb0], 0
  043828  0F58: 7514             jne 0xf6e
  04382A  0F5A: 8d468e           lea ax, [bp - 0x72]
  04382D  0F5D: 50               push ax
  04382E  0F5E: 8d4692           lea ax, [bp - 0x6e]
  043831  0F61: 50               push ax
  043832  0F62: 6a04             push 4
  043834  0F64: 0e               push cs
  043835  0F65: e8b50b           call 0x1b1d
  043838  0F68: 83c406           add sp, 6
  04383B  0F6B: e9da01           jmp 0x1148
  04383E  0F6E: ff363e85         push word ptr [0x853e]
  043842  0F72: ff364085         push word ptr [0x8540]
  043846  0F76: 9a8c071f18       lcall 0x181f, 0x78c
  04384B  0F7B: 83c404           add sp, 4
  04384E  0F7E: 894682           mov word ptr [bp - 0x7e], ax
  043851  0F81: 3d1900           cmp ax, 0x19
  043854  0F84: 7519             jne 0xf9f
  043856  0F86: ff363e85         push word ptr [0x853e]
  04385A  0F8A: ff364085         push word ptr [0x8540]
  04385E  0F8E: 9ab4061f18       lcall 0x181f, 0x6b4
  043863  0F93: 83c404           add sp, 4
  043866  0F96: fec8             dec al
  043868  0F98: 7405             je 0xf9f
  04386A  0F9A: c74682ffff       mov word ptr [bp - 0x7e], 0xffff
  04386F  0F9F: 8d468e           lea ax, [bp - 0x72]
  043872  0FA2: 50               push ax
  043873  0FA3: 8d4e92           lea cx, [bp - 0x6e]
  043876  0FA6: 51               push cx
  043877  0FA7: ff7682           push word ptr [bp - 0x7e]
  04387A  0FAA: 0e               push cs
  04387B  0FAB: e86a0b           call 0x1b18
  04387E  0FAE: 83c406           add sp, 6
  043881  0FB1: f6864aff40       test byte ptr [bp - 0xb6], 0x40
  043886  0FB6: 7425             je 0xfdd
  043888  0FB8: f6864aff80       test byte ptr [bp - 0xb6], 0x80
  04388D  0FBD: 740d             je 0xfcc
  04388F  0FBF: 8d468e           lea ax, [bp - 0x72]
  043892  0FC2: 50               push ax
  043893  0FC3: 8d4692           lea ax, [bp - 0x6e]
  043896  0FC6: 50               push ax
  043897  0FC7: 6a02             push 2
  043899  0FC9: eb0b             jmp 0xfd6
  04389B  0FCB: 90               nop 
  04389C  0FCC: 8d468e           lea ax, [bp - 0x72]
  04389F  0FCF: 50               push ax
  0438A0  0FD0: 8d4692           lea ax, [bp - 0x6e]
  0438A3  0FD3: 50               push ax
  0438A4  0FD4: 6a03             push 3
  0438A6  0FD6: 0e               push cs
  0438A7  0FD7: e8430b           call 0x1b1d
  0438AA  0FDA: 83c406           add sp, 6
  0438AD  0FDD: ff363e85         push word ptr [0x853e]
  0438B1  0FE1: ff364085         push word ptr [0x8540]
  0438B5  0FE5: 9a54071f18       lcall 0x181f, 0x754
  0438BA  0FEA: 83c404           add sp, 4
  0438BD  0FED: a80a             test al, 0xa
  0438BF  0FEF: 7445             je 0x1036
  0438C1  0FF1: c646aa00         mov byte ptr [bp - 0x56], 0
  0438C5  0FF5: 8d46aa           lea ax, [bp - 0x56]
  0438C8  0FF8: 50               push ax
  0438C9  0FF9: 9a1e011f18       lcall 0x181f, 0x11e
  0438CE  0FFE: 83c402           add sp, 2
  0438D1  1001: ff36f82d         push word ptr [0x2df8]
  0438D5  1005: 8d46aa           lea ax, [bp - 0x56]
  0438D8  1008: 50               push ax
  0438D9  1009: 9a6e011f18       lcall 0x181f, 0x16e
  0438DE  100E: 83c404           add sp, 4
  0438E1  1011: 8d46aa           lea ax, [bp - 0x56]
  0438E4  1014: 50               push ax
  0438E5  1015: 9a28011f18       lcall 0x181f, 0x128
  0438EA  101A: 83c402           add sp, 2
  0438ED  101D: ff768e           push word ptr [bp - 0x72]
  0438F0  1020: ff7692           push word ptr [bp - 0x6e]
  0438F3  1023: 8d46aa           lea ax, [bp - 0x56]
  0438F6  1026: 16               push ss
  0438F7  1027: 50               push ax
  0438F8  1028: 9a32011f18       lcall 0x181f, 0x132
  0438FD  102D: 83c408           add sp, 8
  043900  1030: 8b46fa           mov ax, word ptr [bp - 6]
  043903  1033: 01468e           add word ptr [bp - 0x72], ax
  043906  1036: ff363e85         push word ptr [0x853e]
  04390A  103A: ff364085         push word ptr [0x8540]
  04390E  103E: 9a54071f18       lcall 0x181f, 0x754
  043913  1043: 83c404           add sp, 4
  043916  1046: a840             test al, 0x40
  043918  1048: 7445             je 0x108f
  04391A  104A: c646aa00         mov byte ptr [bp - 0x56], 0
  04391E  104E: 8d46aa           lea ax, [bp - 0x56]
  043921  1051: 50               push ax
  043922  1052: 9a1e011f18       lcall 0x181f, 0x11e
  043927  1057: 83c402           add sp, 2
  04392A  105A: ff36602e         push word ptr [0x2e60]
  04392E  105E: 8d46aa           lea ax, [bp - 0x56]
  043931  1061: 50               push ax
  043932  1062: 9a6e011f18       lcall 0x181f, 0x16e
  043937  1067: 83c404           add sp, 4
  04393A  106A: 8d46aa           lea ax, [bp - 0x56]
  04393D  106D: 50               push ax
  04393E  106E: 9a28011f18       lcall 0x181f, 0x128
  043943  1073: 83c402           add sp, 2
  043946  1076: ff768e           push word ptr [bp - 0x72]
  043949  1079: ff7692           push word ptr [bp - 0x6e]
  04394C  107C: 8d46aa           lea ax, [bp - 0x56]
  04394F  107F: 16               push ss
  043950  1080: 50               push ax
  043951  1081: 9a32011f18       lcall 0x181f, 0x132
  043956  1086: 83c408           add sp, 8
  043959  1089: 8b46fa           mov ax, word ptr [bp - 6]
  04395C  108C: 01468e           add word ptr [bp - 0x72], ax
  04395F  108F: ff363e85         push word ptr [0x853e]
  043963  1093: ff364085         push word ptr [0x8540]
  043967  1097: 9a18071f18       lcall 0x181f, 0x718
  04396C  109C: 83c404           add sp, 4
  04396F  109F: 89468c           mov word ptr [bp - 0x74], ax
  043972  10A2: 40               inc ax
  043973  10A3: 744a             je 0x10ef
  043975  10A5: c646aa00         mov byte ptr [bp - 0x56], 0
  043979  10A9: 8d46aa           lea ax, [bp - 0x56]
  04397C  10AC: 50               push ax
  04397D  10AD: 9a1e011f18       lcall 0x181f, 0x11e
  043982  10B2: 83c402           add sp, 2
  043985  10B5: 8b5e8c           mov bx, word ptr [bp - 0x74]
  043988  10B8: d1e3             shl bx, 1
  04398A  10BA: ffb70c93         push word ptr [bx - 0x6cf4]
  04398E  10BE: 8d46aa           lea ax, [bp - 0x56]
  043991  10C1: 50               push ax
  043992  10C2: 9a6e011f18       lcall 0x181f, 0x16e
  043997  10C7: 83c404           add sp, 4
  04399A  10CA: 8d46aa           lea ax, [bp - 0x56]
  04399D  10CD: 50               push ax
  04399E  10CE: 9a28011f18       lcall 0x181f, 0x128
  0439A3  10D3: 83c402           add sp, 2
  0439A6  10D6: ff768e           push word ptr [bp - 0x72]
  0439A9  10D9: ff7692           push word ptr [bp - 0x6e]
  0439AC  10DC: 8d46aa           lea ax, [bp - 0x56]
  0439AF  10DF: 16               push ss
  0439B0  10E0: 50               push ax
  0439B1  10E1: 9a32011f18       lcall 0x181f, 0x132
  0439B6  10E6: 83c408           add sp, 8
  0439B9  10E9: 8b46fa           mov ax, word ptr [bp - 6]
  0439BC  10EC: 01468e           add word ptr [bp - 0x72], ax
  0439BF  10EF: ff363e85         push word ptr [0x853e]
  0439C3  10F3: ff364085         push word ptr [0x8540]
  0439C7  10F7: 9a5e071f18       lcall 0x181f, 0x75e
  0439CC  10FC: 83c404           add sp, 4
  0439CF  10FF: 0bc0             or ax, ax
  0439D1  1101: 7445             je 0x1148
  0439D3  1103: c646aa00         mov byte ptr [bp - 0x56], 0
  0439D7  1107: 8d46aa           lea ax, [bp - 0x56]
  0439DA  110A: 50               push ax
  0439DB  110B: 9a1e011f18       lcall 0x181f, 0x11e
  0439E0  1110: 83c402           add sp, 2
  0439E3  1113: ff36d82d         push word ptr [0x2dd8]
  0439E7  1117: 8d46aa           lea ax, [bp - 0x56]
  0439EA  111A: 50               push ax
  0439EB  111B: 9a6e011f18       lcall 0x181f, 0x16e
  0439F0  1120: 83c404           add sp, 4
  0439F3  1123: 8d46aa           lea ax, [bp - 0x56]
  0439F6  1126: 50               push ax
  0439F7  1127: 9a28011f18       lcall 0x181f, 0x128
  0439FC  112C: 83c402           add sp, 2
  0439FF  112F: ff768e           push word ptr [bp - 0x72]
  043A02  1132: ff7692           push word ptr [bp - 0x6e]
  043A05  1135: 8d46aa           lea ax, [bp - 0x56]
  043A08  1138: 16               push ss
  043A09  1139: 50               push ax
  043A0A  113A: 9a32011f18       lcall 0x181f, 0x132
  043A0F  113F: 83c408           add sp, 8
  043A12  1142: 8b46fa           mov ax, word ptr [bp - 6]
  043A15  1145: 01468e           add word ptr [bp - 0x72], ax
  043A18  1148: 8b46fa           mov ax, word ptr [bp - 6]
  043A1B  114B: d1f8             sar ax, 1
  043A1D  114D: 01468e           add word ptr [bp - 0x72], ax
  043A20  1150: 837efe00         cmp word ptr [bp - 2], 0
  043A24  1154: 7474             je 0x11ca
  043A26  1156: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  043A2B  115B: 8bc3             mov ax, bx
  043A2D  115D: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  043A31  1161: 2aff             sub bh, bh
  043A33  1163: 8bcb             mov cx, bx
  043A35  1165: d1e3             shl bx, 1
  043A37  1167: 03d9             add bx, cx
  043A39  1169: d1e3             shl bx, 1
  043A3B  116B: 03d9             add bx, cx
  043A3D  116D: d1e3             shl bx, 1
  043A3F  116F: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  043A44  1174: 7454             je 0x11ca
  043A46  1176: 8bd8             mov bx, ax
  043A48  1178: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  043A4D  117D: 744b             je 0x11ca
  043A4F  117F: c646aa00         mov byte ptr [bp - 0x56], 0
  043A53  1183: ff36f896         push word ptr [0x96f8]
  043A57  1187: 8d46aa           lea ax, [bp - 0x56]
  043A5A  118A: 50               push ax
  043A5B  118B: 9a6e011f18       lcall 0x181f, 0x16e
  043A60  1190: 83c404           add sp, 4
  043A63  1193: 8b468e           mov ax, word ptr [bp - 0x72]
  043A66  1196: 40               inc ax
  043A67  1197: 40               inc ax
  043A68  1198: 50               push ax
  043A69  1199: ff7692           push word ptr [bp - 0x6e]
  043A6C  119C: 8d46aa           lea ax, [bp - 0x56]
  043A6F  119F: 16               push ss
  043A70  11A0: 50               push ax
  043A71  11A1: 9a32011f18       lcall 0x181f, 0x132
  043A76  11A6: 83c408           add sp, 8
  043A79  11A9: 40               inc ax
  043A7A  11AA: 89867aff         mov word ptr [bp - 0x86], ax
  043A7E  11AE: ff768e           push word ptr [bp - 0x72]
  043A81  11B1: 50               push ax
  043A82  11B2: ff369253         push word ptr [0x5392]
  043A86  11B6: 0e               push cs
  043A87  11B7: e84a09           call 0x1b04
  043A8A  11BA: 83c406           add sp, 6
  043A8D  11BD: c41e3e08         les bx, ptr [0x83e]
  043A91  11C1: 268b875401       mov ax, word ptr es:[bx + 0x154]
  043A96  11C6: 40               inc ax
  043A97  11C7: 01468e           add word ptr [bp - 0x72], ax
  043A9A  11CA: 83be50ff00       cmp word ptr [bp - 0xb0], 0
  043A9F  11CF: 7503             jne 0x11d4
  043AA1  11D1: e95908           jmp 0x1a2d
  043AA4  11D4: ff363e85         push word ptr [0x853e]
  043AA8  11D8: ff364085         push word ptr [0x8540]
  043AAC  11DC: 9abe071f18       lcall 0x181f, 0x7be
  043AB1  11E1: 83c404           add sp, 4
  043AB4  11E4: 8946fc           mov word ptr [bp - 4], ax
  043AB7  11E7: 0bc0             or ax, ax
  043AB9  11E9: 7d03             jge 0x11ee
  043ABB  11EB: e99b02           jmp 0x1489
  043ABE  11EE: ff369653         push word ptr [0x5396]
  043AC2  11F2: 50               push ax
  043AC3  11F3: 9a96091f19       lcall 0x191f, 0x996
  043AC8  11F8: 83c404           add sp, 4
  043ACB  11FB: 0bc0             or ax, ax
  043ACD  11FD: 7503             jne 0x1202
  043ACF  11FF: e98702           jmp 0x1489
  043AD2  1202: ff76fc           push word ptr [bp - 4]
  043AD5  1205: 9ae6091f18       lcall 0x181f, 0x9e6
  043ADA  120A: 83c402           add sp, 2
  043ADD  120D: 8b4692           mov ax, word ptr [bp - 0x6e]
  043AE0  1210: 051400           add ax, 0x14
  043AE3  1213: 89867aff         mov word ptr [bp - 0x86], ax
  043AE7  1217: 8b1e4285         mov bx, word ptr [0x8542]
  043AEB  121B: 8a471a           mov al, byte ptr [bx + 0x1a]
  043AEE  121E: 2ae4             sub ah, ah
  043AF0  1220: 894680           mov word ptr [bp - 0x80], ax
  043AF3  1223: ff36ae2d         push word ptr [0x2dae]
  043AF7  1227: ff36ac2d         push word ptr [0x2dac]
  043AFB  122B: ff36aa2d         push word ptr [0x2daa]
  043AFF  122F: ff36a82d         push word ptr [0x2da8]
  043B03  1233: 6a64             push 0x64
  043B05  1235: 6a00             push 0
  043B07  1237: 6a00             push 0
  043B09  1239: 8b5692           mov dx, word ptr [bp - 0x6e]
  043B0C  123C: 42               inc dx
  043B0D  123D: 42               inc dx
  043B0E  123E: 8b46fc           mov ax, word ptr [bp - 4]
  043B11  1241: 8b5e8e           mov bx, word ptr [bp - 0x72]
  043B14  1244: 9aa8021f18       lcall 0x181f, 0x2a8
  043B19  1249: 8b468e           mov ax, word ptr [bp - 0x72]
  043B1C  124C: 050a00           add ax, 0xa
  043B1F  124F: 50               push ax
  043B20  1250: ffb67aff         push word ptr [bp - 0x86]
  043B24  1254: a14285           mov ax, word ptr [0x8542]
  043B27  1257: 40               inc ax
  043B28  1258: 40               inc ax
  043B29  1259: 1e               push ds
  043B2A  125A: 50               push ax
  043B2B  125B: 9a32011f18       lcall 0x181f, 0x132
  043B30  1260: 83c408           add sp, 8
  043B33  1263: c41e9e08         les bx, ptr [0x89e]
  043B37  1267: 268a07           mov al, byte ptr es:[bx]
  043B3A  126A: 2ae4             sub ah, ah
  043B3C  126C: 051100           add ax, 0x11
  043B3F  126F: 01468e           add word ptr [bp - 0x72], ax
  043B42  1272: a09653           mov al, byte ptr [0x5396]
  043B45  1275: 8b1e4285         mov bx, word ptr [0x8542]
  043B49  1279: 38471a           cmp byte ptr [bx + 0x1a], al
  043B4C  127C: 740a             je 0x1288
  043B4E  127E: 833ea25300       cmp word ptr [0x53a2], 0
  043B53  1283: 7503             jne 0x1288
  043B55  1285: e90102           jmp 0x1489
  043B58  1288: c646aa00         mov byte ptr [bp - 0x56], 0
  043B5C  128C: ff36fa96         push word ptr [0x96fa]
  043B60  1290: 8d46aa           lea ax, [bp - 0x56]
  043B63  1293: 50               push ax
  043B64  1294: 9a6e011f18       lcall 0x181f, 0x16e
  043B69  1299: 83c404           add sp, 4
  043B6C  129C: 2bc0             sub ax, ax
  043B6E  129E: 898658ff         mov word ptr [bp - 0xa8], ax
  043B72  12A2: 894686           mov word ptr [bp - 0x7a], ax
  043B75  12A5: eb6c             jmp 0x1313
  043B77  12A7: 90               nop 
  043B78  12A8: 8a4686           mov al, byte ptr [bp - 0x7a]
  043B7B  12AB: 8b7686           mov si, word ptr [bp - 0x7a]
  043B7E  12AE: 88429a           mov byte ptr [bp + si - 0x66], al
  043B81  12B1: 8b5e80           mov bx, word ptr [bp - 0x80]
  043B84  12B4: c1e304           shl bx, 4
  043B87  12B7: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  043B8B  12BB: 2ae4             sub ah, ah
  043B8D  12BD: c1e004           shl ax, 4
  043B90  12C0: 894690           mov word ptr [bp - 0x70], ax
  043B93  12C3: 83fe0f           cmp si, 0xf
  043B96  12C6: 7505             jne 0x12cd
  043B98  12C8: c746900100       mov word ptr [bp - 0x70], 1
  043B9D  12CD: 837e860e         cmp word ptr [bp - 0x7a], 0xe
  043BA1  12D1: 7505             jne 0x12d8
  043BA3  12D3: c746900100       mov word ptr [bp - 0x70], 1
  043BA8  12D8: 837e8608         cmp word ptr [bp - 0x7a], 8
  043BAC  12DC: 7516             jne 0x12f4
  043BAE  12DE: 8b7686           mov si, word ptr [bp - 0x7a]
  043BB1  12E1: d1e6             shl si, 1
  043BB3  12E3: 8b1e4285         mov bx, word ptr [0x8542]
  043BB7  12E7: 81b89a009600     cmp word ptr [bx + si + 0x9a], 0x96
  043BBD  12ED: 7d05             jge 0x12f4
  043BBF  12EF: c746900000       mov word ptr [bp - 0x70], 0
  043BC4  12F4: 8b7686           mov si, word ptr [bp - 0x7a]
  043BC7  12F7: d1e6             shl si, 1
  043BC9  12F9: 8b1e4285         mov bx, word ptr [0x8542]
  043BCD  12FD: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  043BD1  1301: 3d6400           cmp ax, 0x64
  043BD4  1304: 7e03             jle 0x1309
  043BD6  1306: b86400           mov ax, 0x64
  043BD9  1309: f76e90           imul word ptr [bp - 0x70]
  043BDC  130C: 89825aff         mov word ptr [bp + si - 0xa6], ax
  043BE0  1310: ff4686           inc word ptr [bp - 0x7a]
  043BE3  1313: 837e8610         cmp word ptr [bp - 0x7a], 0x10
  043BE7  1317: 7c8f             jl 0x12a8
  043BE9  1319: 8d469a           lea ax, [bp - 0x66]
  043BEC  131C: 16               push ss
  043BED  131D: 50               push ax
  043BEE  131E: 8d865aff         lea ax, [bp - 0xa6]
  043BF2  1322: 16               push ss
  043BF3  1323: 50               push ax
  043BF4  1324: b81000           mov ax, 0x10
  043BF7  1327: 9ad00e1f19       lcall 0x191f, 0xed0
  043BFC  132C: c746860f00       mov word ptr [bp - 0x7a], 0xf
  043C01  1331: eb04             jmp 0x1337
  043C03  1333: 90               nop 
  043C04  1334: ff4e86           dec word ptr [bp - 0x7a]
  043C07  1337: 837e8600         cmp word ptr [bp - 0x7a], 0
  043C0B  133B: 7d03             jge 0x1340
  043C0D  133D: e99e00           jmp 0x13de
  043C10  1340: 8b7686           mov si, word ptr [bp - 0x7a]
  043C13  1343: 8a429a           mov al, byte ptr [bp + si - 0x66]
  043C16  1346: 2ae4             sub ah, ah
  043C18  1348: 8bf0             mov si, ax
  043C1A  134A: 89b67cff         mov word ptr [bp - 0x84], si
  043C1E  134E: d1e6             shl si, 1
  043C20  1350: 8b1e4285         mov bx, word ptr [0x8542]
  043C24  1354: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  043C28  1358: 894696           mov word ptr [bp - 0x6a], ax
  043C2B  135B: 837e9600         cmp word ptr [bp - 0x6a], 0
  043C2F  135F: 7ed3             jle 0x1334
  043C31  1361: 83be58ff05       cmp word ptr [bp - 0xa8], 5
  043C36  1366: 7d6d             jge 0x13d5
  043C38  1368: 83be58ff00       cmp word ptr [bp - 0xa8], 0
  043C3D  136D: 751b             jne 0x138a
  043C3F  136F: 8b468e           mov ax, word ptr [bp - 0x72]
  043C42  1372: 40               inc ax
  043C43  1373: 40               inc ax
  043C44  1374: 50               push ax
  043C45  1375: ff7692           push word ptr [bp - 0x6e]
  043C48  1378: 8d46aa           lea ax, [bp - 0x56]
  043C4B  137B: 16               push ss
  043C4C  137C: 50               push ax
  043C4D  137D: 9a32011f18       lcall 0x181f, 0x132
  043C52  1382: 83c408           add sp, 8
  043C55  1385: 40               inc ax
  043C56  1386: 89867aff         mov word ptr [bp - 0x86], ax
  043C5A  138A: c746902700       mov word ptr [bp - 0x70], 0x27
  043C5F  138F: 837e9664         cmp word ptr [bp - 0x6a], 0x64
  043C63  1393: 7c05             jl 0x139a
  043C65  1395: c746901700       mov word ptr [bp - 0x70], 0x17
  043C6A  139A: ff364008         push word ptr [0x840]
  043C6E  139E: ff363e08         push word ptr [0x83e]
  043C72  13A2: ff768e           push word ptr [bp - 0x72]
  043C75  13A5: 8b4690           mov ax, word ptr [bp - 0x70]
  043C78  13A8: 03867cff         add ax, word ptr [bp - 0x84]
  043C7C  13AC: 8d1ea82d         lea bx, [0x2da8]
  043C80  13B0: 8b967aff         mov dx, word ptr [bp - 0x86]
  043C84  13B4: 8bf0             mov si, ax
  043C86  13B6: 9a54021f18       lcall 0x181f, 0x254
  043C8B  13BB: 8bc6             mov ax, si
  043C8D  13BD: d1e6             shl si, 1
  043C8F  13BF: 03f0             add si, ax
  043C91  13C1: c1e602           shl si, 2
  043C94  13C4: c41e3e08         les bx, ptr [0x83e]
  043C98  13C8: 268b403e         mov ax, word ptr es:[bx + si + 0x3e]
  043C9C  13CC: 40               inc ax
  043C9D  13CD: 01867aff         add word ptr [bp - 0x86], ax
  043CA1  13D1: ff8658ff         inc word ptr [bp - 0xa8]
  043CA5  13D5: c746960000       mov word ptr [bp - 0x6a], 0
  043CAA  13DA: e97eff           jmp 0x135b
  043CAD  13DD: 90               nop 
  043CAE  13DE: 83be58ff00       cmp word ptr [bp - 0xa8], 0
  043CB3  13E3: 740d             je 0x13f2
  043CB5  13E5: c41e3e08         les bx, ptr [0x83e]
  043CB9  13E9: 268b875401       mov ax, word ptr es:[bx + 0x154]
  043CBE  13EE: 40               inc ax
  043CBF  13EF: 01468e           add word ptr [bp - 0x72], ax
  043CC2  13F2: 833ea25300       cmp word ptr [0x53a2], 0
  043CC7  13F7: 750a             jne 0x1403
  043CC9  13F9: 833ea45300       cmp word ptr [0x53a4], 0
  043CCE  13FE: 7d03             jge 0x1403
  043CD0  1400: e98600           jmp 0x1489
  043CD3  1403: 8b1e4285         mov bx, word ptr [0x8542]
  043CD7  1407: 80bf8d0000       cmp byte ptr [bx + 0x8d], 0
  043CDC  140C: 7c7b             jl 0x1489
  043CDE  140E: c646aa00         mov byte ptr [bp - 0x56], 0
  043CE2  1412: ff36422e         push word ptr [0x2e42]
  043CE6  1416: 8d46aa           lea ax, [bp - 0x56]
  043CE9  1419: 50               push ax
  043CEA  141A: 9a6e011f18       lcall 0x181f, 0x16e
  043CEF  141F: 83c404           add sp, 4
  043CF2  1422: 8b468e           mov ax, word ptr [bp - 0x72]
  043CF5  1425: 40               inc ax
  043CF6  1426: 40               inc ax
  043CF7  1427: 50               push ax
  043CF8  1428: ff7692           push word ptr [bp - 0x6e]
  043CFB  142B: 8d46aa           lea ax, [bp - 0x56]
  043CFE  142E: 16               push ss
  043CFF  142F: 50               push ax
  043D00  1430: 9a32011f18       lcall 0x181f, 0x132
  043D05  1435: 83c408           add sp, 8
  043D08  1438: 40               inc ax
  043D09  1439: 89867aff         mov word ptr [bp - 0x86], ax
  043D0D  143D: 8b1e4285         mov bx, word ptr [0x8542]
  043D11  1441: 8a878d00         mov al, byte ptr [bx + 0x8d]
  043D15  1445: 98               cwde 
  043D16  1446: 89867cff         mov word ptr [bp - 0x84], ax
  043D1A  144A: ff364008         push word ptr [0x840]
  043D1E  144E: ff363e08         push word ptr [0x83e]
  043D22  1452: ff768e           push word ptr [bp - 0x72]
  043D25  1455: 051700           add ax, 0x17
  043D28  1458: 8d1ea82d         lea bx, [0x2da8]
  043D2C  145C: 8b967aff         mov dx, word ptr [bp - 0x86]
  043D30  1460: 9a54021f18       lcall 0x181f, 0x254
  043D35  1465: 8bb67cff         mov si, word ptr [bp - 0x84]
  043D39  1469: 8bc6             mov ax, si
  043D3B  146B: d1e6             shl si, 1
  043D3D  146D: 03f0             add si, ax
  043D3F  146F: c1e602           shl si, 2
  043D42  1472: c41e3e08         les bx, ptr [0x83e]
  043D46  1476: 268b805201       mov ax, word ptr es:[bx + si + 0x152]
  043D4B  147B: 40               inc ax
  043D4C  147C: 01867aff         add word ptr [bp - 0x86], ax
  043D50  1480: 268b875401       mov ax, word ptr es:[bx + 0x154]
  043D55  1485: 40               inc ax
  043D56  1486: 01468e           add word ptr [bp - 0x72], ax
  043D59  1489: ff363e85         push word ptr [0x853e]
  043D5D  148D: ff364085         push word ptr [0x8540]
  043D61  1491: 9af0091f18       lcall 0x181f, 0x9f0
  043D66  1496: 83c404           add sp, 4
  043D69  1499: 894688           mov word ptr [bp - 0x78], ax
  043D6C  149C: 0bc0             or ax, ax
  043D6E  149E: 7d03             jge 0x14a3
  043D70  14A0: e99401           jmp 0x1637
  043D73  14A3: 8b4e92           mov cx, word ptr [bp - 0x6e]
  043D76  14A6: 83c114           add cx, 0x14
  043D79  14A9: 898e7aff         mov word ptr [bp - 0x86], cx
  043D7D  14AD: 6bd812           imul bx, ax, 0x12
  043D80  14B0: 8a8fee54         mov cl, byte ptr [bx + 0x54ee]
  043D84  14B4: 2aed             sub ch, ch
  043D86  14B6: 83e904           sub cx, 4
  043D89  14B9: 894e80           mov word ptr [bp - 0x80], cx
  043D8C  14BC: ff36ae2d         push word ptr [0x2dae]
  043D90  14C0: ff36ac2d         push word ptr [0x2dac]
  043D94  14C4: ff36aa2d         push word ptr [0x2daa]
  043D98  14C8: ff36a82d         push word ptr [0x2da8]
  043D9C  14CC: 6a64             push 0x64
  043D9E  14CE: 8b5692           mov dx, word ptr [bp - 0x6e]
  043DA1  14D1: 8bf3             mov si, bx
  043DA3  14D3: 8b5e8e           mov bx, word ptr [bp - 0x72]
  043DA6  14D6: 9ab2021f18       lcall 0x181f, 0x2b2
  043DAB  14DB: 6b5e804e         imul bx, word ptr [bp - 0x80], 0x4e
  043DAF  14DF: 8a87d85a         mov al, byte ptr [bx + 0x5ad8]
  043DB3  14E3: 2ae4             sub ah, ah
  043DB5  14E5: 898656ff         mov word ptr [bp - 0xaa], ax
  043DB9  14E9: 8a84f154         mov al, byte ptr [si + 0x54f1]
  043DBD  14ED: 250f00           and ax, 0xf
  043DC0  14F0: 898646ff         mov word ptr [bp - 0xba], ax
  043DC4  14F4: f684ef5404       test byte ptr [si + 0x54ef], 4
  043DC9  14F9: 7406             je 0x1501
  043DCB  14FB: c78656ff0400     mov word ptr [bp - 0xaa], 4
  043DD1  1501: 8b468e           mov ax, word ptr [bp - 0x72]
  043DD4  1504: 050400           add ax, 4
  043DD7  1507: 50               push ax
  043DD8  1508: ffb67aff         push word ptr [bp - 0x86]
  043DDC  150C: 8b5e80           mov bx, word ptr [bp - 0x80]
  043DDF  150F: 8bc3             mov ax, bx
  043DE1  1511: d1e3             shl bx, 1
  043DE3  1513: 03d8             add bx, ax
  043DE5  1515: d1e3             shl bx, 1
  043DE7  1517: ffb7148d         push word ptr [bx - 0x72ec]
  043DEB  151B: 9a22001f18       lcall 0x181f, 0x22
  043DF0  1520: 83c402           add sp, 2
  043DF3  1523: 52               push dx
  043DF4  1524: 50               push ax
  043DF5  1525: 9a32011f18       lcall 0x181f, 0x132
  043DFA  152A: 83c408           add sp, 8
  043DFD  152D: 8b468e           mov ax, word ptr [bp - 0x72]
  043E00  1530: 050a00           add ax, 0xa
  043E03  1533: 50               push ax
  043E04  1534: ffb67aff         push word ptr [bp - 0x86]
  043E08  1538: 8b9e56ff         mov bx, word ptr [bp - 0xaa]
  043E0C  153C: 8bc3             mov ax, bx
  043E0E  153E: d1e3             shl bx, 1
  043E10  1540: 03d8             add bx, ax
  043E12  1542: d1e3             shl bx, 1
  043E14  1544: ffb73496         push word ptr [bx - 0x69cc]
  043E18  1548: 9a22001f18       lcall 0x181f, 0x22
  043E1D  154D: 83c402           add sp, 2
  043E20  1550: 52               push dx
  043E21  1551: 50               push ax
  043E22  1552: 9a32011f18       lcall 0x181f, 0x132
  043E27  1557: 83c408           add sp, 8
  043E2A  155A: c41e9e08         les bx, ptr [0x89e]
  043E2E  155E: 268a07           mov al, byte ptr es:[bx]
  043E31  1561: 2ae4             sub ah, ah
  043E33  1563: 051100           add ax, 0x11
  043E36  1566: 01468e           add word ptr [bp - 0x72], ax
  043E39  1569: 6b5e8812         imul bx, word ptr [bp - 0x78], 0x12
  043E3D  156D: 80bff15400       cmp byte ptr [bx + 0x54f1], 0
  043E42  1572: 7c5c             jl 0x15d0
  043E44  1574: c646aa00         mov byte ptr [bp - 0x56], 0
  043E48  1578: 8b8646ff         mov ax, word ptr [bp - 0xba]
  043E4C  157C: 39069653         cmp word ptr [0x5396], ax
  043E50  1580: 7503             jne 0x1585
  043E52  1582: e9e700           jmp 0x166c
  043E55  1585: 50               push ax
  043E56  1586: 9a1a0a1f18       lcall 0x181f, 0xa1a
  043E5B  158B: 83c402           add sp, 2
  043E5E  158E: 50               push ax
  043E5F  158F: 8d46aa           lea ax, [bp - 0x56]
  043E62  1592: 50               push ax
  043E63  1593: 9a6e011f18       lcall 0x181f, 0x16e
  043E68  1598: 83c404           add sp, 4
  043E6B  159B: 8d46aa           lea ax, [bp - 0x56]
  043E6E  159E: 50               push ax
  043E6F  159F: 9a78011f18       lcall 0x181f, 0x178
  043E74  15A4: 83c402           add sp, 2
  043E77  15A7: ff36f02d         push word ptr [0x2df0]
  043E7B  15AB: 8d46aa           lea ax, [bp - 0x56]
  043E7E  15AE: 50               push ax
  043E7F  15AF: 9a6e011f18       lcall 0x181f, 0x16e
  043E84  15B4: 83c404           add sp, 4
  043E87  15B7: ff768e           push word ptr [bp - 0x72]
  043E8A  15BA: ff7692           push word ptr [bp - 0x6e]
  043E8D  15BD: 8d46aa           lea ax, [bp - 0x56]
  043E90  15C0: 16               push ss
  043E91  15C1: 50               push ax
  043E92  15C2: 9a32011f18       lcall 0x181f, 0x132
  043E97  15C7: 83c408           add sp, 8
  043E9A  15CA: 8b46fa           mov ax, word ptr [bp - 6]
  043E9D  15CD: 01468e           add word ptr [bp - 0x72], ax
  043EA0  15D0: 6a00             push 0
  043EA2  15D2: ff7688           push word ptr [bp - 0x78]
  043EA5  15D5: 9a16031f18       lcall 0x181f, 0x316
  043EAA  15DA: 83c404           add sp, 4
  043EAD  15DD: 898646ff         mov word ptr [bp - 0xba], ax
  043EB1  15E1: 0bc0             or ax, ax
  043EB3  15E3: 7c52             jl 0x1637
  043EB5  15E5: c646aa00         mov byte ptr [bp - 0x56], 0
  043EB9  15E9: ff36082e         push word ptr [0x2e08]
  043EBD  15ED: 8d4eaa           lea cx, [bp - 0x56]
  043EC0  15F0: 51               push cx
  043EC1  15F1: 9a6e011f18       lcall 0x181f, 0x16e
  043EC6  15F6: 83c404           add sp, 4
  043EC9  15F9: 8d46aa           lea ax, [bp - 0x56]
  043ECC  15FC: 50               push ax
  043ECD  15FD: 9a78011f18       lcall 0x181f, 0x178
  043ED2  1602: 83c402           add sp, 2
  043ED5  1605: ffb646ff         push word ptr [bp - 0xba]
  043ED9  1609: 9a1a0a1f18       lcall 0x181f, 0xa1a
  043EDE  160E: 83c402           add sp, 2
  043EE1  1611: 50               push ax
  043EE2  1612: 8d46aa           lea ax, [bp - 0x56]
  043EE5  1615: 50               push ax
  043EE6  1616: 9a6e011f18       lcall 0x181f, 0x16e
  043EEB  161B: 83c404           add sp, 4
  043EEE  161E: ff768e           push word ptr [bp - 0x72]
  043EF1  1621: ff7692           push word ptr [bp - 0x6e]
  043EF4  1624: 8d46aa           lea ax, [bp - 0x56]
  043EF7  1627: 16               push ss
  043EF8  1628: 50               push ax
  043EF9  1629: 9a32011f18       lcall 0x181f, 0x132
  043EFE  162E: 83c408           add sp, 8
  043F01  1631: 8b46fa           mov ax, word ptr [bp - 6]
  043F04  1634: 01468e           add word ptr [bp - 0x72], ax
  043F07  1637: 8b4692           mov ax, word ptr [bp - 0x6e]
  043F0A  163A: 89867aff         mov word ptr [bp - 0x86], ax
  043F0E  163E: 837e9800         cmp word ptr [bp - 0x68], 0
  043F12  1642: 7d03             jge 0x1647
  043F14  1644: e9e603           jmp 0x1a2d
  043F17  1647: 6b5e981c         imul bx, word ptr [bp - 0x68], 0x1c
  043F1B  164B: 8a874731         mov al, byte ptr [bx + 0x3147]
  043F1F  164F: 240f             and al, 0xf
  043F21  1651: 3a069653         cmp al, byte ptr [0x5396]
  043F25  1655: 740a             je 0x1661
  043F27  1657: 833ea25300       cmp word ptr [0x53a2], 0
  043F2C  165C: 7503             jne 0x1661
  043F2E  165E: e90b03           jmp 0x196c
  043F31  1661: c746940000       mov word ptr [bp - 0x6c], 0
  043F36  1666: 8b4698           mov ax, word ptr [bp - 0x68]
  043F39  1669: e9b502           jmp 0x1921
  043F3C  166C: 6b5e8812         imul bx, word ptr [bp - 0x78], 0x12
  043F40  1670: f687f15410       test byte ptr [bx + 0x54f1], 0x10
  043F45  1675: 7503             jne 0x167a
  043F47  1677: e90bff           jmp 0x1585
  043F4A  167A: ff36c22d         push word ptr [0x2dc2]
  043F4E  167E: e90eff           jmp 0x158f
  043F51  1681: 90               nop 
  043F52  1682: ff768e           push word ptr [bp - 0x72]
  043F55  1685: 6a10             push 0x10
  043F57  1687: 6a64             push 0x64
  043F59  1689: 2bd2             sub dx, dx
  043F5B  168B: 899654ff         mov word ptr [bp - 0xac], dx
  043F5F  168F: 8b8652ff         mov ax, word ptr [bp - 0xae]
  043F63  1693: 8b9e7aff         mov bx, word ptr [bp - 0x86]
  043F67  1697: 9abc021f18       lcall 0x181f, 0x2bc
  043F6C  169C: 83867aff12       add word ptr [bp - 0x86], 0x12
  043F71  16A1: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  043F76  16A6: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  043F7B  16AB: 7553             jne 0x1700
  043F7D  16AD: c646aa00         mov byte ptr [bp - 0x56], 0
  043F81  16B1: 80bf5b3114       cmp byte ptr [bx + 0x315b], 0x14
  043F86  16B6: 751c             jne 0x16d4
  043F88  16B8: ff36c22d         push word ptr [0x2dc2]
  043F8C  16BC: 8d46aa           lea ax, [bp - 0x56]
  043F8F  16BF: 50               push ax
  043F90  16C0: 9a6e011f18       lcall 0x181f, 0x16e
  043F95  16C5: 83c404           add sp, 4
  043F98  16C8: 8d46aa           lea ax, [bp - 0x56]
  043F9B  16CB: 50               push ax
  043F9C  16CC: 9a78011f18       lcall 0x181f, 0x178
  043FA1  16D1: 83c402           add sp, 2
  043FA4  16D4: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  043FA9  16D9: 8a875931         mov al, byte ptr [bx + 0x3159]
  043FAD  16DD: 2ae4             sub ah, ah
  043FAF  16DF: 50               push ax
  043FB0  16E0: 8d46aa           lea ax, [bp - 0x56]
  043FB3  16E3: 16               push ss
  043FB4  16E4: 50               push ax
  043FB5  16E5: 9a82011f18       lcall 0x181f, 0x182
  043FBA  16EA: 83c406           add sp, 6
  043FBD  16ED: 8d46aa           lea ax, [bp - 0x56]
  043FC0  16F0: 50               push ax
  043FC1  16F1: 9a78011f18       lcall 0x181f, 0x178
  043FC6  16F6: 83c402           add sp, 2
  043FC9  16F9: ff36dc97         push word ptr [0x97dc]
  043FCD  16FD: e9c500           jmp 0x17c5
  043FD0  1700: ffb652ff         push word ptr [bp - 0xae]
  043FD4  1704: 9a780b1f18       lcall 0x181f, 0xb78
  043FD9  1709: 83c402           add sp, 2
  043FDC  170C: 0bc0             or ax, ax
  043FDE  170E: 7c14             jl 0x1724
  043FE0  1710: c646aa00         mov byte ptr [bp - 0x56], 0
  043FE4  1714: 6a00             push 0
  043FE6  1716: ffb652ff         push word ptr [bp - 0xae]
  043FEA  171A: 8d46aa           lea ax, [bp - 0x56]
  043FED  171D: 50               push ax
  043FEE  171E: 0e               push cs
  043FEF  171F: e8ec03           call 0x1b0e
  043FF2  1722: eb3f             jmp 0x1763
  043FF4  1724: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  043FF9  1729: 80bf46310a       cmp byte ptr [bx + 0x3146], 0xa
  043FFE  172E: 7538             jne 0x1768
  044000  1730: c646aa00         mov byte ptr [bp - 0x56], 0
  044004  1734: ff36a093         push word ptr [0x93a0]
  044008  1738: 8d46aa           lea ax, [bp - 0x56]
  04400B  173B: 50               push ax
  04400C  173C: 8bf3             mov si, bx
  04400E  173E: 9a6e011f18       lcall 0x181f, 0x16e
  044013  1743: 83c404           add sp, 4
  044016  1746: 8d46aa           lea ax, [bp - 0x56]
  044019  1749: 50               push ax
  04401A  174A: 9a78011f18       lcall 0x181f, 0x178
  04401F  174F: 83c402           add sp, 2
  044022  1752: b064             mov al, 0x64
  044024  1754: f6a45b31         mul byte ptr [si + 0x315b]
  044028  1758: 50               push ax
  044029  1759: 8d46aa           lea ax, [bp - 0x56]
  04402C  175C: 16               push ss
  04402D  175D: 50               push ax
  04402E  175E: 9a82011f18       lcall 0x181f, 0x182
  044033  1763: 83c406           add sp, 6
  044036  1766: eb69             jmp 0x17d1
  044038  1768: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  04403D  176D: 8bc3             mov ax, bx
  04403F  176F: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  044043  1773: 2aff             sub bh, bh
  044045  1775: 8bcb             mov cx, bx
  044047  1777: d1e3             shl bx, 1
  044049  1779: 03d9             add bx, cx
  04404B  177B: d1e3             shl bx, 1
  04404D  177D: 03d9             add bx, cx
  04404F  177F: d1e3             shl bx, 1
  044051  1781: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  044056  1786: 741e             je 0x17a6
  044058  1788: 8bd8             mov bx, ax
  04405A  178A: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  04405F  178F: 7415             je 0x17a6
  044061  1791: ff768e           push word ptr [bp - 0x72]
  044064  1794: ffb67aff         push word ptr [bp - 0x86]
  044068  1798: ffb652ff         push word ptr [bp - 0xae]
  04406C  179C: 0e               push cs
  04406D  179D: e86403           call 0x1b04
  044070  17A0: 83c406           add sp, 6
  044073  17A3: eb4a             jmp 0x17ef
  044075  17A5: 90               nop 
  044076  17A6: c646aa00         mov byte ptr [bp - 0x56], 0
  04407A  17AA: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  04407F  17AF: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  044083  17B3: 2aff             sub bh, bh
  044085  17B5: 8bc3             mov ax, bx
  044087  17B7: d1e3             shl bx, 1
  044089  17B9: 03d8             add bx, ax
  04408B  17BB: d1e3             shl bx, 1
  04408D  17BD: 03d8             add bx, ax
  04408F  17BF: d1e3             shl bx, 1
  044091  17C1: ffb73052         push word ptr [bx + 0x5230]
  044095  17C5: 8d46aa           lea ax, [bp - 0x56]
  044098  17C8: 50               push ax
  044099  17C9: 9a6e011f18       lcall 0x181f, 0x16e
  04409E  17CE: 83c404           add sp, 4
  0440A1  17D1: a03608           mov al, byte ptr [0x836]
  0440A4  17D4: 2ae4             sub ah, ah
  0440A6  17D6: 50               push ax
  0440A7  17D7: 8b468e           mov ax, word ptr [bp - 0x72]
  0440AA  17DA: 050400           add ax, 4
  0440AD  17DD: 50               push ax
  0440AE  17DE: ffb67aff         push word ptr [bp - 0x86]
  0440B2  17E2: 8d46aa           lea ax, [bp - 0x56]
  0440B5  17E5: 16               push ss
  0440B6  17E6: 50               push ax
  0440B7  17E7: 9a3c011f18       lcall 0x181f, 0x13c
  0440BC  17EC: 83c40a           add sp, 0xa
  0440BF  17EF: c41e9e08         les bx, ptr [0x89e]
  0440C3  17F3: 268a07           mov al, byte ptr es:[bx]
  0440C6  17F6: 2ae4             sub ah, ah
  0440C8  17F8: 2b468e           sub ax, word ptr [bp - 0x72]
  0440CB  17FB: f7d8             neg ax
  0440CD  17FD: 051000           add ax, 0x10
  0440D0  1800: 89864cff         mov word ptr [bp - 0xb4], ax
  0440D4  1804: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  0440D9  1809: 8a874d31         mov al, byte ptr [bx + 0x314d]
  0440DD  180D: 2ae4             sub ah, ah
  0440DF  180F: 89468a           mov word ptr [bp - 0x76], ax
  0440E2  1812: 8a874e31         mov al, byte ptr [bx + 0x314e]
  0440E6  1816: 894684           mov word ptr [bp - 0x7c], ax
  0440E9  1819: 8866aa           mov byte ptr [bp - 0x56], ah
  0440EC  181C: 833ea25300       cmp word ptr [0x53a2], 0
  0440F1  1821: 7424             je 0x1847
  0440F3  1823: f606835320       test byte ptr [0x5383], 0x20
  0440F8  1828: 741d             je 0x1847
  0440FA  182A: ffb652ff         push word ptr [bp - 0xae]
  0440FE  182E: 8d46aa           lea ax, [bp - 0x56]
  044101  1831: 16               push ss
  044102  1832: 50               push ax
  044103  1833: 9a82011f18       lcall 0x181f, 0x182
  044108  1838: 83c406           add sp, 6
  04410B  183B: 8d46aa           lea ax, [bp - 0x56]
  04410E  183E: 50               push ax
  04410F  183F: 9a78011f18       lcall 0x181f, 0x178
  044114  1844: 83c402           add sp, 2
  044117  1847: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  04411C  184C: 80bf4c3103       cmp byte ptr [bx + 0x314c], 3
  044121  1851: 7415             je 0x1868
  044123  1853: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  044128  1858: 740e             je 0x1868
  04412A  185A: 80bf4c310c       cmp byte ptr [bx + 0x314c], 0xc
  04412F  185F: 7407             je 0x1868
  044131  1861: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  044136  1866: 7522             jne 0x188a
  044138  1868: 6a01             push 1
  04413A  186A: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  04413F  186F: 8a874731         mov al, byte ptr [bx + 0x3147]
  044143  1873: 250f00           and ax, 0xf
  044146  1876: 50               push ax
  044147  1877: ff7684           push word ptr [bp - 0x7c]
  04414A  187A: ff768a           push word ptr [bp - 0x76]
  04414D  187D: 8d46aa           lea ax, [bp - 0x56]
  044150  1880: 50               push ax
  044151  1881: 0e               push cs
  044152  1882: e87a02           call 0x1aff
  044155  1885: 83c40a           add sp, 0xa
  044158  1888: eb1d             jmp 0x18a7
  04415A  188A: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  04415F  188F: 8a9f4c31         mov bl, byte ptr [bx + 0x314c]
  044163  1893: 2aff             sub bh, bh
  044165  1895: d1e3             shl bx, 1
  044167  1897: ffb70498         push word ptr [bx - 0x67fc]
  04416B  189B: 8d46aa           lea ax, [bp - 0x56]
  04416E  189E: 50               push ax
  04416F  189F: 9a6e011f18       lcall 0x181f, 0x16e
  044174  18A4: 83c404           add sp, 4
  044177  18A7: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  04417C  18AC: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  044181  18B1: 753f             jne 0x18f2
  044183  18B3: 8d46aa           lea ax, [bp - 0x56]
  044186  18B6: 50               push ax
  044187  18B7: 9a78011f18       lcall 0x181f, 0x178
  04418C  18BC: 83c402           add sp, 2
  04418F  18BF: 8d46aa           lea ax, [bp - 0x56]
  044192  18C2: 50               push ax
  044193  18C3: 9a1e011f18       lcall 0x181f, 0x11e
  044198  18C8: 83c402           add sp, 2
  04419B  18CB: ffb652ff         push word ptr [bp - 0xae]
  04419F  18CF: 9a58081f18       lcall 0x181f, 0x858
  0441A4  18D4: 83c402           add sp, 2
  0441A7  18D7: 40               inc ax
  0441A8  18D8: 50               push ax
  0441A9  18D9: 8d46aa           lea ax, [bp - 0x56]
  0441AC  18DC: 16               push ss
  0441AD  18DD: 50               push ax
  0441AE  18DE: 9a82011f18       lcall 0x181f, 0x182
  0441B3  18E3: 83c406           add sp, 6
  0441B6  18E6: 8d46aa           lea ax, [bp - 0x56]
  0441B9  18E9: 50               push ax
  0441BA  18EA: 9a28011f18       lcall 0x181f, 0x128
  0441BF  18EF: 83c402           add sp, 2
  0441C2  18F2: a03608           mov al, byte ptr [0x836]
  0441C5  18F5: 2ae4             sub ah, ah
  0441C7  18F7: 50               push ax
  0441C8  18F8: ffb64cff         push word ptr [bp - 0xb4]
  0441CC  18FC: ffb67aff         push word ptr [bp - 0x86]
  0441D0  1900: 8d46aa           lea ax, [bp - 0x56]
  0441D3  1903: 16               push ss
  0441D4  1904: 50               push ax
  0441D5  1905: 9a3c011f18       lcall 0x181f, 0x13c
  0441DA  190A: 83c40a           add sp, 0xa
  0441DD  190D: 8b4692           mov ax, word ptr [bp - 0x6e]
  0441E0  1910: 89867aff         mov word ptr [bp - 0x86], ax
  0441E4  1914: 83468e12         add word ptr [bp - 0x72], 0x12
  0441E8  1918: 8b8652ff         mov ax, word ptr [bp - 0xae]
  0441EC  191C: 9ae4021f18       lcall 0x181f, 0x2e4
  0441F1  1921: 898652ff         mov word ptr [bp - 0xae], ax
  0441F5  1925: 0bc0             or ax, ax
  0441F7  1927: 7c36             jl 0x195f
  0441F9  1929: 833e905301       cmp word ptr [0x5390], 1
  0441FE  192E: 7409             je 0x1939
  044200  1930: a19253           mov ax, word ptr [0x5392]
  044203  1933: 398652ff         cmp word ptr [bp - 0xae], ax
  044207  1937: 74df             je 0x1918
  044209  1939: 817e8eb800       cmp word ptr [bp - 0x72], 0xb8
  04420E  193E: 7d03             jge 0x1943
  044210  1940: e93ffd           jmp 0x1682
  044213  1943: ff768e           push word ptr [bp - 0x72]
  044216  1946: ff7692           push word ptr [bp - 0x6e]
  044219  1949: ff368c2e         push word ptr [0x2e8c]
  04421D  194D: 9a22001f18       lcall 0x181f, 0x22
  044222  1952: 83c402           add sp, 2
  044225  1955: 52               push dx
  044226  1956: 50               push ax
  044227  1957: 9a32011f18       lcall 0x181f, 0x132
  04422C  195C: 83c408           add sp, 8
  04422F  195F: 837e9400         cmp word ptr [bp - 0x6c], 0
  044233  1963: 7503             jne 0x1968
  044235  1965: e9c500           jmp 0x1a2d
  044238  1968: e9be00           jmp 0x1a29
  04423B  196B: 90               nop 
  04423C  196C: 6b5e981c         imul bx, word ptr [bp - 0x68], 0x1c
  044240  1970: 8a874731         mov al, byte ptr [bx + 0x3147]
  044244  1974: 2ae4             sub ah, ah
  044246  1976: 8a0e9653         mov cl, byte ptr [0x5396]
  04424A  197A: ba1000           mov dx, 0x10
  04424D  197D: d3e2             shl dx, cl
  04424F  197F: 85c2             test dx, ax
  044251  1981: 7503             jne 0x1986
  044253  1983: e9a700           jmp 0x1a2d
  044256  1986: ff768e           push word ptr [bp - 0x72]
  044259  1989: 6a10             push 0x10
  04425B  198B: 6a64             push 0x64
  04425D  198D: baa000           mov dx, 0xa0
  044260  1990: 899654ff         mov word ptr [bp - 0xac], dx
  044264  1994: 8b4698           mov ax, word ptr [bp - 0x68]
  044267  1997: 8bf3             mov si, bx
  044269  1999: 8b9e7aff         mov bx, word ptr [bp - 0x86]
  04426D  199D: 9abc021f18       lcall 0x181f, 0x2bc
  044272  19A2: 83867aff12       add word ptr [bp - 0x86], 0x12
  044277  19A7: 8b4698           mov ax, word ptr [bp - 0x68]
  04427A  19AA: 898652ff         mov word ptr [bp - 0xae], ax
  04427E  19AE: 8a8c4731         mov cl, byte ptr [si + 0x3147]
  044282  19B2: 83e10f           and cx, 0xf
  044285  19B5: 894e80           mov word ptr [bp - 0x80], cx
  044288  19B8: c646aa00         mov byte ptr [bp - 0x56], 0
  04428C  19BC: 80bc463110       cmp byte ptr [si + 0x3146], 0x10
  044291  19C1: 742e             je 0x19f1
  044293  19C3: 51               push cx
  044294  19C4: 9aa4091f18       lcall 0x181f, 0x9a4
  044299  19C9: 83c402           add sp, 2
  04429C  19CC: 50               push ax
  04429D  19CD: 8d46aa           lea ax, [bp - 0x56]
  0442A0  19D0: 50               push ax
  0442A1  19D1: 9a6e011f18       lcall 0x181f, 0x16e
  0442A6  19D6: 83c404           add sp, 4
  0442A9  19D9: 8b468e           mov ax, word ptr [bp - 0x72]
  0442AC  19DC: 050400           add ax, 4
  0442AF  19DF: 50               push ax
  0442B0  19E0: ffb67aff         push word ptr [bp - 0x86]
  0442B4  19E4: 8d46aa           lea ax, [bp - 0x56]
  0442B7  19E7: 16               push ss
  0442B8  19E8: 50               push ax
  0442B9  19E9: 9a32011f18       lcall 0x181f, 0x132
  0442BE  19EE: 83c408           add sp, 8
  0442C1  19F1: 8b468e           mov ax, word ptr [bp - 0x72]
  0442C4  19F4: 050a00           add ax, 0xa
  0442C7  19F7: 50               push ax
  0442C8  19F8: ffb67aff         push word ptr [bp - 0x86]
  0442CC  19FC: 6b9e52ff1c       imul bx, word ptr [bp - 0xae], 0x1c
  0442D1  1A01: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0442D5  1A05: 2aff             sub bh, bh
  0442D7  1A07: 8bc3             mov ax, bx
  0442D9  1A09: d1e3             shl bx, 1
  0442DB  1A0B: 03d8             add bx, ax
  0442DD  1A0D: d1e3             shl bx, 1
  0442DF  1A0F: 03d8             add bx, ax
  0442E1  1A11: d1e3             shl bx, 1
  0442E3  1A13: ffb73052         push word ptr [bx + 0x5230]
  0442E7  1A17: 9a22001f18       lcall 0x181f, 0x22
  0442EC  1A1C: 83c402           add sp, 2
  0442EF  1A1F: 52               push dx
  0442F0  1A20: 50               push ax
  0442F1  1A21: 9a32011f18       lcall 0x181f, 0x132
  0442F6  1A26: 83c408           add sp, 8
  0442F9  1A29: 83468e12         add word ptr [bp - 0x72], 0x12
  0442FD  1A2D: 8b46fa           mov ax, word ptr [bp - 6]
  044300  1A30: 01468e           add word ptr [bp - 0x72], ax
  044303  1A33: f606940801       test byte ptr [0x894], 1
  044308  1A38: 7503             jne 0x1a3d
  04430A  1A3A: e98300           jmp 0x1ac0
  04430D  1A3D: c746860000       mov word ptr [bp - 0x7a], 0
  044312  1A42: ff7686           push word ptr [bp - 0x7a]
  044315  1A45: 9a420a1f18       lcall 0x181f, 0xa42
  04431A  1A4A: 83c402           add sp, 2
  04431D  1A4D: 6b5e864e         imul bx, word ptr [bp - 0x7a], 0x4e
  044321  1A51: f687d95a80       test byte ptr [bx + 0x5ad9], 0x80
  044326  1A56: 755f             jne 0x1ab7
  044328  1A58: c646aa00         mov byte ptr [bp - 0x56], 0
  04432C  1A5C: ff36508d         push word ptr [0x8d50]
  044330  1A60: 9a1a0a1f18       lcall 0x181f, 0xa1a
  044335  1A65: 83c402           add sp, 2
  044338  1A68: 50               push ax
  044339  1A69: 8d46aa           lea ax, [bp - 0x56]
  04433C  1A6C: 50               push ax
  04433D  1A6D: 9a6e011f18       lcall 0x181f, 0x16e
  044342  1A72: 83c404           add sp, 4
  044345  1A75: 8d46aa           lea ax, [bp - 0x56]
  044348  1A78: 50               push ax
  044349  1A79: 9a78011f18       lcall 0x181f, 0x178
  04434E  1A7E: 83c402           add sp, 2
  044351  1A81: ff369653         push word ptr [0x5396]
  044355  1A85: ff7686           push word ptr [bp - 0x7a]
  044358  1A88: 9a0c031f18       lcall 0x181f, 0x30c
  04435D  1A8D: 83c404           add sp, 4
  044360  1A90: 50               push ax
  044361  1A91: 8d46aa           lea ax, [bp - 0x56]
  044364  1A94: 16               push ss
  044365  1A95: 50               push ax
  044366  1A96: 9a82011f18       lcall 0x181f, 0x182
  04436B  1A9B: 83c406           add sp, 6
  04436E  1A9E: ff768e           push word ptr [bp - 0x72]
  044371  1AA1: ff7692           push word ptr [bp - 0x6e]
  044374  1AA4: 8d46aa           lea ax, [bp - 0x56]
  044377  1AA7: 16               push ss
  044378  1AA8: 50               push ax
  044379  1AA9: 9a32011f18       lcall 0x181f, 0x132
  04437E  1AAE: 83c408           add sp, 8
  044381  1AB1: 8b46fa           mov ax, word ptr [bp - 6]
  044384  1AB4: 01468e           add word ptr [bp - 0x72], ax
  044387  1AB7: ff4686           inc word ptr [bp - 0x7a]
  04438A  1ABA: 837e8608         cmp word ptr [bp - 0x7a], 8
  04438E  1ABE: 7c82             jl 0x1a42
  044390  1AC0: 833ec65300       cmp word ptr [0x53c6], 0
  044395  1AC5: 7425             je 0x1aec
  044397  1AC7: c41e9e08         les bx, ptr [0x89e]
  04439B  1ACB: 268a07           mov al, byte ptr es:[bx]
  04439E  1ACE: 2ae4             sub ah, ah
  0443A0  1AD0: 2dc600           sub ax, 0xc6
  0443A3  1AD3: f7d8             neg ax
  0443A5  1AD5: 3b468e           cmp ax, word ptr [bp - 0x72]
  0443A8  1AD8: 7e03             jle 0x1add
  0443AA  1ADA: 8b468e           mov ax, word ptr [bp - 0x72]
  0443AD  1ADD: 89468e           mov word ptr [bp - 0x72], ax
  0443B0  1AE0: a3569e           mov word ptr [0x9e56], ax
  0443B3  1AE3: 6a00             push 0
  0443B5  1AE5: 0e               push cs
  0443B6  1AE6: e81100           call 0x1afa
  0443B9  1AE9: 83c402           add sp, 2
  0443BC  1AEC: 837e0600         cmp word ptr [bp + 6], 0
  0443C0  1AF0: 7404             je 0x1af6
  0443C2  1AF2: 0e               push cs
  0443C3  1AF3: e81d00           call 0x1b13
  0443C6  1AF6: 5e               pop si
  0443C7  1AF7: 5f               pop di
  0443C8  1AF8: c9               leave 
  0443C9  1AF9: cb               retf 
  0443CA  1AFA: ea460e1f18       ljmp 0x181f:0xe46
  0443CF  1AFF: ea820f1f19       ljmp 0x191f:0xf82
  0443D4  1B04: ea8a021f1a       ljmp 0x1a1f:0x28a
  0443D9  1B09: ea96021f1a       ljmp 0x1a1f:0x296
  0443DE  1B0E: eaa2021f1a       ljmp 0x1a1f:0x2a2
  0443E3  1B13: eaae021f1a       ljmp 0x1a1f:0x2ae
  0443E8  1B18: eaba021f1a       ljmp 0x1a1f:0x2ba
  0443ED  1B1D: eac6021f1a       ljmp 0x1a1f:0x2c6
