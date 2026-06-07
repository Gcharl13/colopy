; ============================================================
; VICEROY.EXE overlay page 0x1E (record 29) -- RE-SEGMENTED
; file_offset (disk image) = 0x077E00
; code_offset (first insn) = 0x077ED0
; code_end (next reloc hdr)= 0x0785A0  [resident size 109 para -> nominal_end 0x0784D0; on-disk code spills past it]
; reloc_count = 42  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x077E00)
; functions in page = 10
; ============================================================

; ---- func_077ED0  size=106  insns=53  prologue=ENTER 0x0004,0  terminal=RETF imm16 ----
  077ED0  00D0: c8040000         enter 4, 0
  077ED4  00D4: 52               push dx
  077ED5  00D5: 50               push ax
  077ED6  00D6: 56               push si
  077ED7  00D7: 8bc8             mov cx, ax
  077ED9  00D9: d1e0             shl ax, 1
  077EDB  00DB: 03c1             add ax, cx
  077EDD  00DD: 8946fe           mov word ptr [bp - 2], ax
  077EE0  00E0: 8bc2             mov ax, dx
  077EE2  00E2: d1e2             shl dx, 1
  077EE4  00E4: 03d0             add dx, ax
  077EE6  00E6: 8956fc           mov word ptr [bp - 4], dx
  077EE9  00E9: 1e               push ds
  077EEA  00EA: c57606           lds si, ptr [bp + 6]
  077EED  00ED: 0376fe           add si, word ptr [bp - 2]
  077EF0  00F0: fa               cli 
  077EF1  00F1: 32c0             xor al, al
  077EF3  00F3: e643             out 0x43, al
  077EF5  00F5: eb00             jmp 0xf7
  077EF7  00F7: e440             in al, 0x40
  077EF9  00F9: 8ad8             mov bl, al
  077EFB  00FB: eb00             jmp 0xfd
  077EFD  00FD: e440             in al, 0x40
  077EFF  00FF: 8af8             mov bh, al
  077F01  0101: bac803           mov dx, 0x3c8
  077F04  0104: 8b46f8           mov ax, word ptr [bp - 8]
  077F07  0107: ee               out dx, al
  077F08  0108: 42               inc dx
  077F09  0109: 8b4efc           mov cx, word ptr [bp - 4]
  077F0C  010C: 833e0a0800       cmp word ptr [0x80a], 0
  077F11  0111: 7405             je 0x118
  077F13  0113: f36e             rep outsb dx, byte ptr [si]
  077F15  0115: eb08             jmp 0x11f
  077F17  0117: 90               nop 
  077F18  0118: 6e               outsb dx, byte ptr [si]
  077F19  0119: eb00             jmp 0x11b
  077F1B  011B: eb00             jmp 0x11d
  077F1D  011D: e2f9             loop 0x118
  077F1F  011F: 32c0             xor al, al
  077F21  0121: e643             out 0x43, al
  077F23  0123: eb00             jmp 0x125
  077F25  0125: e440             in al, 0x40
  077F27  0127: 8ad0             mov dl, al
  077F29  0129: eb00             jmp 0x12b
  077F2B  012B: e440             in al, 0x40
  077F2D  012D: 8af0             mov dh, al
  077F2F  012F: fb               sti 
  077F30  0130: 2bda             sub bx, dx
  077F32  0132: 8bc3             mov ax, bx
  077F34  0134: 1f               pop ds
  077F35  0135: 5e               pop si
  077F36  0136: c9               leave 
  077F37  0137: ca0400           retf 4

; ---- func_077F3A  size=519  insns=185  prologue=ENTER 0x030A,0  terminal=RETF ----
  077F3A  013A: c80a0300         enter 0x30a, 0
  077F3E  013E: 57               push di
  077F3F  013F: c7060a080000     mov word ptr [0x80a], 0
  077F45  0145: 33ff             xor di, di
  077F47  0147: b92000           mov cx, 0x20
  077F4A  014A: fa               cli 
  077F4B  014B: bada03           mov dx, 0x3da
  077F4E  014E: b408             mov ah, 8
  077F50  0150: ec               in al, dx
  077F51  0151: 22c4             and al, ah
  077F53  0153: 75fb             jne 0x150
  077F55  0155: ec               in al, dx
  077F56  0156: 22c4             and al, ah
  077F58  0158: 74fb             je 0x155
  077F5A  015A: 32c0             xor al, al
  077F5C  015C: e643             out 0x43, al
  077F5E  015E: eb00             jmp 0x160
  077F60  0160: e440             in al, 0x40
  077F62  0162: 8ad8             mov bl, al
  077F64  0164: eb00             jmp 0x166
  077F66  0166: e440             in al, 0x40
  077F68  0168: 8af8             mov bh, al
  077F6A  016A: bada03           mov dx, 0x3da
  077F6D  016D: b408             mov ah, 8
  077F6F  016F: ec               in al, dx
  077F70  0170: 22c4             and al, ah
  077F72  0172: 75fb             jne 0x16f
  077F74  0174: 32c0             xor al, al
  077F76  0176: e643             out 0x43, al
  077F78  0178: eb00             jmp 0x17a
  077F7A  017A: e440             in al, 0x40
  077F7C  017C: 8ad0             mov dl, al
  077F7E  017E: eb00             jmp 0x180
  077F80  0180: e440             in al, 0x40
  077F82  0182: 8af0             mov dh, al
  077F84  0184: fb               sti 
  077F85  0185: 2bda             sub bx, dx
  077F87  0187: 03fb             add di, bx
  077F89  0189: e2bf             loop 0x14a
  077F8B  018B: c1ef05           shr di, 5
  077F8E  018E: 893e0208         mov word ptr [0x802], di
  077F92  0192: 8d8600fd         lea ax, [bp - 0x300]
  077F96  0196: 16               push ss
  077F97  0197: 50               push ax
  077F98  0198: 9a780a1f1a       lcall 0x1a1f, 0xa78
  077F9D  019D: c786f6fc4000     mov word ptr [bp - 0x30a], 0x40
  077FA3  01A3: c786fefc8000     mov word ptr [bp - 0x302], 0x80
  077FA9  01A9: 2bc0             sub ax, ax
  077FAB  01AB: 8986fafc         mov word ptr [bp - 0x306], ax
  077FAF  01AF: 8986fcfc         mov word ptr [bp - 0x304], ax
  077FB3  01B3: 83bef6fc02       cmp word ptr [bp - 0x30a], 2
  077FB8  01B8: 7f07             jg 0x1c1
  077FBA  01BA: 83befafc00       cmp word ptr [bp - 0x306], 0
  077FBF  01BF: 7569             jne 0x22a
  077FC1  01C1: 83befcfc40       cmp word ptr [bp - 0x304], 0x40
  077FC6  01C6: 7d62             jge 0x22a
  077FC8  01C8: 8d8600fd         lea ax, [bp - 0x300]
  077FCC  01CC: 16               push ss
  077FCD  01CD: 50               push ax
  077FCE  01CE: 2bc0             sub ax, ax
  077FD0  01D0: 8b96fefc         mov dx, word ptr [bp - 0x302]
  077FD4  01D4: 0e               push cs
  077FD5  01D5: e88a00           call 0x262
  077FD8  01D8: 8986f8fc         mov word ptr [bp - 0x308], ax
  077FDC  01DC: 39060208         cmp word ptr [0x802], ax
  077FE0  01E0: 721c             jb 0x1fe
  077FE2  01E2: 8b86fefc         mov ax, word ptr [bp - 0x302]
  077FE6  01E6: 0386f6fc         add ax, word ptr [bp - 0x30a]
  077FEA  01EA: 3d0001           cmp ax, 0x100
  077FED  01ED: 7e03             jle 0x1f2
  077FEF  01EF: b80001           mov ax, 0x100
  077FF2  01F2: 8986fefc         mov word ptr [bp - 0x302], ax
  077FF6  01F6: c786fafc0100     mov word ptr [bp - 0x306], 1
  077FFC  01FC: eb1a             jmp 0x218
  077FFE  01FE: 8b86fefc         mov ax, word ptr [bp - 0x302]
  078002  0202: 2b86f6fc         sub ax, word ptr [bp - 0x30a]
  078006  0206: 3d0100           cmp ax, 1
  078009  0209: 7d03             jge 0x20e
  07800B  020B: b80100           mov ax, 1
  07800E  020E: 8986fefc         mov word ptr [bp - 0x302], ax
  078012  0212: c786fafc0000     mov word ptr [bp - 0x306], 0
  078018  0218: 83bef6fc02       cmp word ptr [bp - 0x30a], 2
  07801D  021D: 7e04             jle 0x223
  07801F  021F: d1bef6fc         sar word ptr [bp - 0x30a], 1
  078023  0223: ff86fcfc         inc word ptr [bp - 0x304]
  078027  0227: eb8a             jmp 0x1b3
  078029  0229: 90               nop 
  07802A  022A: 83befafc00       cmp word ptr [bp - 0x306], 0
  07802F  022F: 7509             jne 0x23a
  078031  0231: c70604082000     mov word ptr [0x804], 0x20
  078037  0237: eb14             jmp 0x24d
  078039  0239: 90               nop 
  07803A  023A: 8b86fefc         mov ax, word ptr [bp - 0x302]
  07803E  023E: 8bc8             mov cx, ax
  078040  0240: d1e0             shl ax, 1
  078042  0242: 03c1             add ax, cx
  078044  0244: d1e0             shl ax, 1
  078046  0246: 03c1             add ax, cx
  078048  0248: d1e0             shl ax, 1
  07804A  024A: a30408           mov word ptr [0x804], ax
  07804D  024D: a10408           mov ax, word ptr [0x804]
  078050  0250: 8bc8             mov cx, ax
  078052  0252: d1e0             shl ax, 1
  078054  0254: 03c1             add ax, cx
  078056  0256: a30608           mov word ptr [0x806], ax
  078059  0259: c70600080100     mov word ptr [0x800], 1
  07805F  025F: 5f               pop di
  078060  0260: c9               leave 
  078061  0261: cb               retf 
  078062  0262: ea300f1f1a       ljmp 0x1a1f:0xf30
  078067  0267: 00c8             add al, cl
  078069  0269: 56               push si
  07806A  026A: 0000             add byte ptr [bx + si], al
  07806C  026C: ff7608           push word ptr [bp + 8]
  07806F  026F: ff7606           push word ptr [bp + 6]
  078072  0272: 9afa061f18       lcall 0x181f, 0x6fa
  078077  0277: 83c404           add sp, 4
  07807A  027A: 0bc0             or ax, ax
  07807C  027C: 7503             jne 0x281
  07807E  027E: e9be00           jmp 0x33f
  078081  0281: a12a83           mov ax, word ptr [0x832a]
  078084  0284: 2b062883         sub ax, word ptr [0x8328]
  078088  0288: 034606           add ax, word ptr [bp + 6]
  07808B  028B: f72ed45a         imul word ptr [0x5ad4]
  07808F  028F: 8946ae           mov word ptr [bp - 0x52], ax
  078092  0292: a12c83           mov ax, word ptr [0x832c]
  078095  0295: 2b062e83         sub ax, word ptr [0x832e]
  078099  0299: 034608           add ax, word ptr [bp + 8]
  07809C  029C: f72e2683         imul word ptr [0x8326]
  0780A0  02A0: 050800           add ax, 8
  0780A3  02A3: 8946ac           mov word ptr [bp - 0x54], ax
  0780A6  02A6: c646b000         mov byte ptr [bp - 0x50], 0
  0780AA  02AA: ff760a           push word ptr [bp + 0xa]
  0780AD  02AD: 8d46b0           lea ax, [bp - 0x50]
  0780B0  02B0: 16               push ss
  0780B1  02B1: 50               push ax
  0780B2  02B2: 9a82011f18       lcall 0x181f, 0x182
  0780B7  02B7: 83c406           add sp, 6
  0780BA  02BA: ff36a008         push word ptr [0x8a0]
  0780BE  02BE: ff369e08         push word ptr [0x89e]
  0780C2  02C2: 8d46b0           lea ax, [bp - 0x50]
  0780C5  02C5: 16               push ss
  0780C6  02C6: 50               push ax
  0780C7  02C7: 2bc0             sub ax, ax
  0780C9  02C9: 9a04021f18       lcall 0x181f, 0x204
  0780CE  02CE: 40               inc ax
  0780CF  02CF: 8946aa           mov word ptr [bp - 0x56], ax
  0780D2  02D2: 8a0e8401         mov cl, byte ptr [0x184]
  0780D6  02D6: b80700           mov ax, 7
  0780D9  02D9: d3f8             sar ax, cl
  0780DB  02DB: 0146ae           add word ptr [bp - 0x52], ax
  0780DE  02DE: b80600           mov ax, 6
  0780E1  02E1: d3f8             sar ax, cl
  0780E3  02E3: 0146ac           add word ptr [bp - 0x54], ax
  0780E6  02E6: 833e840100       cmp word ptr [0x184], 0
  0780EB  02EB: 7524             jne 0x311
  0780ED  02ED: ff36b225         push word ptr [0x25b2]
  0780F1  02F1: ff36b025         push word ptr [0x25b0]
  0780F5  02F5: ff36ae25         push word ptr [0x25ae]
  0780F9  02F9: ff36ac25         push word ptr [0x25ac]
  0780FD  02FD: 6a07             push 7
  0780FF  02FF: 6a00             push 0
  078101  0301: 8b46ae           mov ax, word ptr [bp - 0x52]
  078104  0304: 48               dec ax
  078105  0305: 8b56ac           mov dx, word ptr [bp - 0x54]
  078108  0308: 4a               dec dx
  078109  0309: 8b5eaa           mov bx, word ptr [bp - 0x56]
  07810C  030C: 9aba001f18       lcall 0x181f, 0xba
  078111  0311: ff760c           push word ptr [bp + 0xc]
  078114  0314: b8ffff           mov ax, 0xffff
  078117  0317: 8b560c           mov dx, word ptr [bp + 0xc]
  07811A  031A: 8bda             mov bx, dx
  07811C  031C: 9af0011f18       lcall 0x181f, 0x1f0
  078121  0321: ff36a008         push word ptr [0x8a0]
  078125  0325: ff369e08         push word ptr [0x89e]
  078129  0329: 8d46b0           lea ax, [bp - 0x50]
  07812C  032C: 16               push ss
  07812D  032D: 50               push ax
  07812E  032E: 6a00             push 0
  078130  0330: 8d1eac25         lea bx, [0x25ac]
  078134  0334: 8b46ae           mov ax, word ptr [bp - 0x52]
  078137  0337: 8b56ac           mov dx, word ptr [bp - 0x54]
  07813A  033A: 9afa011f18       lcall 0x181f, 0x1fa
  07813F  033F: c9               leave 
  078140  0340: cb               retf 

; ---- func_078142  size=66  insns=25  prologue=push bp;mov bp,sp  terminal=RETF ----
  078142  0342: 55               push bp
  078143  0343: 8bec             mov bp, sp
  078145  0345: 1e               push ds
  078146  0346: ff7606           push word ptr [bp + 6]
  078149  0349: 6a00             push 0
  07814B  034B: 9a16041f18       lcall 0x181f, 0x416
  078150  0350: 8be5             mov sp, bp
  078152  0352: 8b4608           mov ax, word ptr [bp + 8]
  078155  0355: 99               cdq 
  078156  0356: a3b09c           mov word ptr [0x9cb0], ax
  078159  0359: 8916b29c         mov word ptr [0x9cb2], dx
  07815D  035D: 8b460a           mov ax, word ptr [bp + 0xa]
  078160  0360: 99               cdq 
  078161  0361: a3b49c           mov word ptr [0x9cb4], ax
  078164  0364: 8916b69c         mov word ptr [0x9cb6], dx
  078168  0368: 8b460c           mov ax, word ptr [bp + 0xc]
  07816B  036B: 99               cdq 
  07816C  036C: a3b89c           mov word ptr [0x9cb8], ax
  07816F  036F: 8916ba9c         mov word ptr [0x9cba], dx
  078173  0373: 8d1ebb25         lea bx, [0x25bb]
  078177  0377: 8d06b425         lea ax, [0x25b4]
  07817B  037B: 2bd2             sub dx, dx
  07817D  037D: 9a98091f18       lcall 0x181f, 0x998
  078182  0382: c9               leave 
  078183  0383: cb               retf 

; ---- func_078184  size=90  insns=29  prologue=ENTER 0x0002,0  terminal=RETF ----
  078184  0384: c8020000         enter 2, 0
  078188  0388: c746fe0000       mov word ptr [bp - 2], 0
  07818D  038D: 803ef02500       cmp byte ptr [0x25f0], 0
  078192  0392: 7508             jne 0x39c
  078194  0394: 68c125           push 0x25c1
  078197  0397: 68c425           push 0x25c4
  07819A  039A: eb06             jmp 0x3a2
  07819C  039C: 68d025           push 0x25d0
  07819F  039F: 68d325           push 0x25d3
  0781A2  03A2: 9ada041d0d       lcall 0xd1d, 0x4da
  0781A7  03A7: 83c404           add sp, 4
  0781AA  03AA: 8946fe           mov word ptr [bp - 2], ax
  0781AD  03AD: 0bc0             or ax, ax
  0781AF  03AF: 741d             je 0x3ce
  0781B1  03B1: c606f02501       mov byte ptr [0x25f0], 1
  0781B6  03B6: ff760c           push word ptr [bp + 0xc]
  0781B9  03B9: ff760a           push word ptr [bp + 0xa]
  0781BC  03BC: ff7608           push word ptr [bp + 8]
  0781BF  03BF: ff7606           push word ptr [bp + 6]
  0781C2  03C2: 68df25           push 0x25df
  0781C5  03C5: 50               push ax
  0781C6  03C6: 9af0041d0d       lcall 0xd1d, 0x4f0
  0781CB  03CB: 83c40c           add sp, 0xc
  0781CE  03CE: 837efe00         cmp word ptr [bp - 2], 0
  0781D2  03D2: 7408             je 0x3dc
  0781D4  03D4: ff76fe           push word ptr [bp - 2]
  0781D7  03D7: 9af4031d0d       lcall 0xd1d, 0x3f4
  0781DC  03DC: c9               leave 
  0781DD  03DD: cb               retf 

; ---- func_0781DE  size=100  insns=38  prologue=ENTER 0x0302,0  terminal=RETF imm16 ----
  0781DE  03DE: c8020300         enter 0x302, 0
  0781E2  03E2: 53               push bx
  0781E3  03E3: 56               push si
  0781E4  03E4: c746fe0100       mov word ptr [bp - 2], 1
  0781E9  03E9: 1e               push ds
  0781EA  03EA: 53               push bx
  0781EB  03EB: 8d1ef225         lea bx, [0x25f2]
  0781EF  03EF: 9a860e1f18       lcall 0x181f, 0xe86
  0781F4  03F4: 8bf0             mov si, ax
  0781F6  03F6: 0bf6             or si, si
  0781F8  03F8: 7433             je 0x42d
  0781FA  03FA: 56               push si
  0781FB  03FB: 6a01             push 1
  0781FD  03FD: 680003           push 0x300
  078200  0400: 8d86fefc         lea ax, [bp - 0x302]
  078204  0404: 50               push ax
  078205  0405: 9a28051d0d       lcall 0xd1d, 0x528
  07820A  040A: 83c408           add sp, 8
  07820D  040D: 0bc0             or ax, ax
  07820F  040F: 741c             je 0x42d
  078211  0411: 680003           push 0x300
  078214  0414: 8d86fefc         lea ax, [bp - 0x302]
  078218  0418: 16               push ss
  078219  0419: 50               push ax
  07821A  041A: ff7608           push word ptr [bp + 8]
  07821D  041D: ff7606           push word ptr [bp + 6]
  078220  0420: 9ab20f1d0d       lcall 0xd1d, 0xfb2
  078225  0425: 83c40a           add sp, 0xa
  078228  0428: c746fe0000       mov word ptr [bp - 2], 0
  07822D  042D: 0bf6             or si, si
  07822F  042F: 7409             je 0x43a
  078231  0431: 56               push si
  078232  0432: 9af4031d0d       lcall 0xd1d, 0x3f4
  078237  0437: 83c402           add sp, 2
  07823A  043A: 8b46fe           mov ax, word ptr [bp - 2]
  07823D  043D: 5e               pop si
  07823E  043E: c9               leave 
  07823F  043F: ca0400           retf 4

; ---- func_078242  size=39  insns=24  prologue=push bp;mov bp,sp  terminal=RETF ----
  078242  0442: 55               push bp
  078243  0443: 8bec             mov bp, sp
  078245  0445: 57               push di
  078246  0446: 56               push si
  078247  0447: 1e               push ds
  078248  0448: c47e0a           les di, ptr [bp + 0xa]
  07824B  044B: c57606           lds si, ptr [bp + 6]
  07824E  044E: b90003           mov cx, 0x300
  078251  0451: ac               lodsb al, byte ptr [si]
  078252  0452: 51               push cx
  078253  0453: 8b4e0e           mov cx, word ptr [bp + 0xe]
  078256  0456: d2e8             shr al, cl
  078258  0458: 59               pop cx
  078259  0459: 1400             adc al, 0
  07825B  045B: 0ac0             or al, al
  07825D  045D: 7502             jne 0x461
  07825F  045F: fec0             inc al
  078261  0461: aa               stosb byte ptr es:[di], al
  078262  0462: e2ed             loop 0x451
  078264  0464: 1f               pop ds
  078265  0465: 5e               pop si
  078266  0466: 5f               pop di
  078267  0467: c9               leave 
  078268  0468: cb               retf 

; ---- func_07826A  size=176  insns=67  prologue=ENTER 0x0312,0  terminal=RETF imm16 ----
  07826A  046A: c8120300         enter 0x312, 0
  07826E  046E: 50               push ax
  07826F  046F: 57               push di
  078270  0470: 56               push si
  078271  0471: 8d86f6fc         lea ax, [bp - 0x30a]
  078275  0475: 8946fc           mov word ptr [bp - 4], ax
  078278  0478: 8c56fe           mov word ptr [bp - 2], ss
  07827B  047B: 2bc9             sub cx, cx
  07827D  047D: 890e3a83         mov word ptr [0x833a], cx
  078281  0481: 890e3883         mov word ptr [0x8338], cx
  078285  0485: 6a03             push 3
  078287  0487: 16               push ss
  078288  0488: 50               push ax
  078289  0489: 8b4606           mov ax, word ptr [bp + 6]
  07828C  048C: 8b5608           mov dx, word ptr [bp + 8]
  07828F  048F: 8946f8           mov word ptr [bp - 8], ax
  078292  0492: 8956fa           mov word ptr [bp - 6], dx
  078295  0495: 52               push dx
  078296  0496: 50               push ax
  078297  0497: 0e               push cs
  078298  0498: e84301           call 0x5de
  07829B  049B: 83c40a           add sp, 0xa
  07829E  049E: c746f60000       mov word ptr [bp - 0xa], 0
  0782A3  04A3: 9a22000c0c       lcall 0xc0c, 0x22
  0782A8  04A8: 8bc8             mov cx, ax
  0782AA  04AA: 8b86ecfc         mov ax, word ptr [bp - 0x314]
  0782AE  04AE: 8bda             mov bx, dx
  0782B0  04B0: 99               cdq 
  0782B1  04B1: 03c1             add ax, cx
  0782B3  04B3: 13d3             adc dx, bx
  0782B5  04B5: 8986f2fc         mov word ptr [bp - 0x30e], ax
  0782B9  04B9: 8996f4fc         mov word ptr [bp - 0x30c], dx
  0782BD  04BD: 1e               push ds
  0782BE  04BE: c45efc           les bx, ptr [bp - 4]
  0782C1  04C1: c47ef8           les di, ptr [bp - 8]
  0782C4  04C4: c576f8           lds si, ptr [bp - 8]
  0782C7  04C7: b90003           mov cx, 0x300
  0782CA  04CA: ac               lodsb al, byte ptr [si]
  0782CB  04CB: 368a17           mov dl, byte ptr ss:[bx]
  0782CE  04CE: 43               inc bx
  0782CF  04CF: 2ac2             sub al, dl
  0782D1  04D1: 7302             jae 0x4d5
  0782D3  04D3: 32c0             xor al, al
  0782D5  04D5: aa               stosb byte ptr es:[di], al
  0782D6  04D6: 7405             je 0x4dd
  0782D8  04D8: c746f60100       mov word ptr [bp - 0xa], 1
  0782DD  04DD: e2eb             loop 0x4ca
  0782DF  04DF: 1f               pop ds
  0782E0  04E0: ff7608           push word ptr [bp + 8]
  0782E3  04E3: ff7606           push word ptr [bp + 6]
  0782E6  04E6: 9af4031f18       lcall 0x181f, 0x3f4
  0782EB  04EB: 9a22000c0c       lcall 0xc0c, 0x22
  0782F0  04F0: 8986eefc         mov word ptr [bp - 0x312], ax
  0782F4  04F4: 8996f0fc         mov word ptr [bp - 0x310], dx
  0782F8  04F8: 8b86f2fc         mov ax, word ptr [bp - 0x30e]
  0782FC  04FC: 8b96f4fc         mov dx, word ptr [bp - 0x30c]
  078300  0500: 3996f0fc         cmp word ptr [bp - 0x310], dx
  078304  0504: 7ce5             jl 0x4eb
  078306  0506: 7f06             jg 0x50e
  078308  0508: 3986eefc         cmp word ptr [bp - 0x312], ax
  07830C  050C: 72dd             jb 0x4eb
  07830E  050E: 837ef600         cmp word ptr [bp - 0xa], 0
  078312  0512: 758a             jne 0x49e
  078314  0514: 5e               pop si
  078315  0515: 5f               pop di
  078316  0516: c9               leave 
  078317  0517: ca0400           retf 4

; ---- func_07831A  size=320  insns=117  prologue=ENTER 0x0316,0  terminal=RETF ----
  07831A  051A: c8160300         enter 0x316, 0
  07831E  051E: 50               push ax
  07831F  051F: 57               push di
  078320  0520: 56               push si
  078321  0521: 8d86f2fc         lea ax, [bp - 0x30e]
  078325  0525: 8946f8           mov word ptr [bp - 8], ax
  078328  0528: 8c56fa           mov word ptr [bp - 6], ss
  07832B  052B: 8b4e06           mov cx, word ptr [bp + 6]
  07832E  052E: 8b5608           mov dx, word ptr [bp + 8]
  078331  0531: 894efc           mov word ptr [bp - 4], cx
  078334  0534: 8956fe           mov word ptr [bp - 2], dx
  078337  0537: 2bc9             sub cx, cx
  078339  0539: 890e3a83         mov word ptr [0x833a], cx
  07833D  053D: 890e3883         mov word ptr [0x8338], cx
  078341  0541: 6a03             push 3
  078343  0543: 16               push ss
  078344  0544: 50               push ax
  078345  0545: b800fc           mov ax, 0xfc00
  078348  0548: ba00a0           mov dx, 0xa000
  07834B  054B: 8946f4           mov word ptr [bp - 0xc], ax
  07834E  054E: 8956f6           mov word ptr [bp - 0xa], dx
  078351  0551: 52               push dx
  078352  0552: 50               push ax
  078353  0553: 0e               push cs
  078354  0554: e88700           call 0x5de
  078357  0557: 83c40a           add sp, 0xa
  07835A  055A: c746f20000       mov word ptr [bp - 0xe], 0
  07835F  055F: 9a22000c0c       lcall 0xc0c, 0x22
  078364  0564: 8bc8             mov cx, ax
  078366  0566: 8b86e8fc         mov ax, word ptr [bp - 0x318]
  07836A  056A: 8bda             mov bx, dx
  07836C  056C: 99               cdq 
  07836D  056D: 03c1             add ax, cx
  07836F  056F: 13d3             adc dx, bx
  078371  0571: 8986eefc         mov word ptr [bp - 0x312], ax
  078375  0575: 8996f0fc         mov word ptr [bp - 0x310], dx
  078379  0579: 1e               push ds
  07837A  057A: c45ef8           les bx, ptr [bp - 8]
  07837D  057D: c47efc           les di, ptr [bp - 4]
  078380  0580: c576f4           lds si, ptr [bp - 0xc]
  078383  0583: b90003           mov cx, 0x300
  078386  0586: ac               lodsb al, byte ptr [si]
  078387  0587: 268a25           mov ah, byte ptr es:[di]
  07838A  058A: 86c4             xchg ah, al
  07838C  058C: 368a17           mov dl, byte ptr ss:[bx]
  07838F  058F: 43               inc bx
  078390  0590: 02c2             add al, dl
  078392  0592: 3ac4             cmp al, ah
  078394  0594: 7604             jbe 0x59a
  078396  0596: 8ac4             mov al, ah
  078398  0598: eb05             jmp 0x59f
  07839A  059A: c746f20100       mov word ptr [bp - 0xe], 1
  07839F  059F: aa               stosb byte ptr es:[di], al
  0783A0  05A0: e2e4             loop 0x586
  0783A2  05A2: 1f               pop ds
  0783A3  05A3: ff7608           push word ptr [bp + 8]
  0783A6  05A6: ff7606           push word ptr [bp + 6]
  0783A9  05A9: 9af4031f18       lcall 0x181f, 0x3f4
  0783AE  05AE: 9a22000c0c       lcall 0xc0c, 0x22
  0783B3  05B3: 8986eafc         mov word ptr [bp - 0x316], ax
  0783B7  05B7: 8996ecfc         mov word ptr [bp - 0x314], dx
  0783BB  05BB: 8b86eefc         mov ax, word ptr [bp - 0x312]
  0783BF  05BF: 8b96f0fc         mov dx, word ptr [bp - 0x310]
  0783C3  05C3: 3996ecfc         cmp word ptr [bp - 0x314], dx
  0783C7  05C7: 7ce5             jl 0x5ae
  0783C9  05C9: 7f06             jg 0x5d1
  0783CB  05CB: 3986eafc         cmp word ptr [bp - 0x316], ax
  0783CF  05CF: 72dd             jb 0x5ae
  0783D1  05D1: 837ef200         cmp word ptr [bp - 0xe], 0
  0783D5  05D5: 7583             jne 0x55a
  0783D7  05D7: 5e               pop si
  0783D8  05D8: 5f               pop di
  0783D9  05D9: c9               leave 
  0783DA  05DA: ca0400           retf 4
  0783DD  05DD: 90               nop 
  0783DE  05DE: ea3e0f1f1a       ljmp 0x1a1f:0xf3e
  0783E3  05E3: 00c8             add al, cl
  0783E5  05E5: 0200             add al, byte ptr [bx + si]
  0783E7  05E7: 00c7             add bh, al
  0783E9  05E9: 06               push es
  0783EA  05EA: 9e               sahf 
  0783EB  05EB: 92               xchg dx, ax
  0783EC  05EC: 0000             add byte ptr [bx + si], al
  0783EE  05EE: 1e               push ds
  0783EF  05EF: 68f925           push 0x25f9
  0783F2  05F2: 8d1ef625         lea bx, [0x25f6]
  0783F6  05F6: 9a860e1f18       lcall 0x181f, 0xe86
  0783FB  05FB: 8946fe           mov word ptr [bp - 2], ax
  0783FE  05FE: 0bc0             or ax, ax
  078400  0600: 7410             je 0x612
  078402  0602: 50               push ax
  078403  0603: 6a01             push 1
  078405  0605: 6a22             push 0x22
  078407  0607: 689e92           push 0x929e
  07840A  060A: 9a28051d0d       lcall 0xd1d, 0x528
  07840F  060F: 83c408           add sp, 8
  078412  0612: 837efe00         cmp word ptr [bp - 2], 0
  078416  0616: 7408             je 0x620
  078418  0618: ff76fe           push word ptr [bp - 2]
  07841B  061B: 9af4031d0d       lcall 0xd1d, 0x3f4
  078420  0620: c9               leave 
  078421  0621: cb               retf 
  078422  0622: 833e042600       cmp word ptr [0x2604], 0
  078427  0627: 742a             je 0x653
  078429  0629: 6a00             push 0
  07842B  062B: 9ade041f18       lcall 0x181f, 0x4de
  078430  0630: 83c402           add sp, 2
  078433  0633: 6a00             push 0
  078435  0635: 9ac20e1f18       lcall 0x181f, 0xec2
  07843A  063A: 83c402           add sp, 2
  07843D  063D: 9ad8051f18       lcall 0x181f, 0x5d8
  078442  0642: ff360426         push word ptr [0x2604]
  078446  0646: 9a740f1f1a       lcall 0x1a1f, 0xf74
  07844B  064B: 83c402           add sp, 2
  07844E  064E: 9a4c0f1f1a       lcall 0x1a1f, 0xf4c
  078453  0653: c70604260000     mov word ptr [0x2604], 0
  078459  0659: cb               retf 

; ---- func_07845A  size=315  insns=130  prologue=ENTER 0x00A0,0  terminal=page-end ----
  07845A  065A: c8a00000         enter 0xa0, 0
  07845E  065E: 52               push dx
  07845F  065F: 50               push ax
  078460  0660: 53               push bx
  078461  0661: 57               push di
  078462  0662: 56               push si
  078463  0663: 8bfa             mov di, dx
  078465  0665: 8bcb             mov cx, bx
  078467  0667: 51               push cx
  078468  0668: 8d46b0           lea ax, [bp - 0x50]
  07846B  066B: 50               push ax
  07846C  066C: 9ae4071d0d       lcall 0xd1d, 0x7e4
  078471  0671: 83c404           add sp, 4
  078474  0674: 8d76b0           lea si, [bp - 0x50]
  078477  0677: 803c00           cmp byte ptr [si], 0
  07847A  067A: 7415             je 0x691
  07847C  067C: 89be5eff         mov word ptr [bp - 0xa2], di
  078480  0680: 803c23           cmp byte ptr [si], 0x23
  078483  0683: 7506             jne 0x68b
  078485  0685: 8a865cff         mov al, byte ptr [bp - 0xa4]
  078489  0689: 8804             mov byte ptr [si], al
  07848B  068B: 46               inc si
  07848C  068C: 803c00           cmp byte ptr [si], 0
  07848F  068F: 75ef             jne 0x680
  078491  0691: 833e062600       cmp word ptr [0x2606], 0
  078496  0696: 7414             je 0x6ac
  078498  0698: 8d46b0           lea ax, [bp - 0x50]
  07849B  069B: 50               push ax
  07849C  069C: 8d8660ff         lea ax, [bp - 0xa0]
  0784A0  06A0: 50               push ax
  0784A1  06A1: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0784A6  06A6: 83c404           add sp, 4
  0784A9  06A9: eb14             jmp 0x6bf
  0784AB  06AB: 90               nop 
  0784AC  06AC: 8d46b0           lea ax, [bp - 0x50]
  0784AF  06AF: 16               push ss
  0784B0  06B0: 50               push ax
  0784B1  06B1: 8d8660ff         lea ax, [bp - 0xa0]
  0784B5  06B5: 16               push ss
  0784B6  06B6: 50               push ax
  0784B7  06B7: 9a7c0e1f18       lcall 0x181f, 0xe7c
  0784BC  06BC: 83c408           add sp, 8
  0784BF  06BF: 0e               push cs
  0784C0  06C0: e87f00           call 0x742
  0784C3  06C3: 8d8660ff         lea ax, [bp - 0xa0]
  0784C7  06C7: 16               push ss
  0784C8  06C8: 50               push ax
  0784C9  06C9: 9a6a0f1f1a       lcall 0x1a1f, 0xf6a
  0784CE  06CE: 83c404           add sp, 4
  0784D1  06D1: a30426           mov word ptr [0x2604], ax
  0784D4  06D4: 0bc0             or ax, ax
  0784D6  06D6: 7450             je 0x728
  0784D8  06D8: 8b7606           mov si, word ptr [bp + 6]
  0784DB  06DB: 50               push ax
  0784DC  06DC: 9a600f1f1a       lcall 0x1a1f, 0xf60
  0784E1  06E1: 83c402           add sp, 2
  0784E4  06E4: 56               push si
  0784E5  06E5: ff7608           push word ptr [bp + 8]
  0784E8  06E8: ff760a           push word ptr [bp + 0xa]
  0784EB  06EB: ff760c           push word ptr [bp + 0xc]
  0784EE  06EE: ff760e           push word ptr [bp + 0xe]
  0784F1  06F1: ff7610           push word ptr [bp + 0x10]
  0784F4  06F4: 57               push di
  0784F5  06F5: 9a560f1f1a       lcall 0x1a1f, 0xf56
  0784FA  06FA: 83c40e           add sp, 0xe
  0784FD  06FD: 0bc0             or ax, ax
  0784FF  06FF: 742c             je 0x72d
  078501  0701: 89be5eff         mov word ptr [bp - 0xa2], di
  078505  0705: 8b7e08           mov di, word ptr [bp + 8]
  078508  0708: 56               push si
  078509  0709: 57               push di
  07850A  070A: ff760a           push word ptr [bp + 0xa]
  07850D  070D: ff760c           push word ptr [bp + 0xc]
  078510  0710: ff760e           push word ptr [bp + 0xe]
  078513  0713: ff7610           push word ptr [bp + 0x10]
  078516  0716: ffb65eff         push word ptr [bp - 0xa2]
  07851A  071A: 9a560f1f1a       lcall 0x1a1f, 0xf56
  07851F  071F: 83c40e           add sp, 0xe
  078522  0722: 0bc0             or ax, ax
  078524  0724: 75e2             jne 0x708
  078526  0726: eb05             jmp 0x72d
  078528  0728: 9a4c0f1f1a       lcall 0x1a1f, 0xf4c
  07852D  072D: ff360426         push word ptr [0x2604]
  078531  0731: 9ac20e1f18       lcall 0x181f, 0xec2
  078536  0736: 83c402           add sp, 2
  078539  0739: a10426           mov ax, word ptr [0x2604]
  07853C  073C: 5e               pop si
  07853D  073D: 5f               pop di
  07853E  073E: c9               leave 
  07853F  073F: ca0c00           retf 0xc
  078542  0742: ea4e0e1f1a       ljmp 0x1a1f:0xe4e
  078547  0747: 00558b           add byte ptr [di - 0x75], dl
  07854A  074A: ec               in al, dx
  07854B  074B: 57               push di
  07854C  074C: 56               push si
  07854D  074D: c70608080100     mov word ptr [0x808], 1
  078553  0753: bb4000           mov bx, 0x40
  078556  0756: be0003           mov si, 0x300
  078559  0759: c47e06           les di, ptr [bp + 6]
  07855C  075C: bac703           mov dx, 0x3c7
  07855F  075F: 32c0             xor al, al
  078561  0761: ee               out dx, al
  078562  0762: bada03           mov dx, 0x3da
  078565  0765: b408             mov ah, 8
  078567  0767: ec               in al, dx
  078568  0768: 22c4             and al, ah
  07856A  076A: 75fb             jne 0x767
  07856C  076C: ec               in al, dx
  07856D  076D: 22c4             and al, ah
  07856F  076F: 74fb             je 0x76c
  078571  0771: fa               cli 
  078572  0772: bac903           mov dx, 0x3c9
  078575  0775: 8bce             mov cx, si
  078577  0777: 3bcb             cmp cx, bx
  078579  0779: 7602             jbe 0x77d
  07857B  077B: 8bcb             mov cx, bx
  07857D  077D: 51               push cx
  07857E  077E: 6c               insb byte ptr es:[di], dx
  07857F  077F: eb01             jmp 0x782
  078581  0781: 90               nop 
  078582  0782: eb00             jmp 0x784
  078584  0784: e2f8             loop 0x77e
  078586  0786: fb               sti 
  078587  0787: 59               pop cx
  078588  0788: 2bf1             sub si, cx
  07858A  078A: 75d6             jne 0x762
  07858C  078C: c70608080000     mov word ptr [0x808], 0
  078592  0792: 5e               pop si
  078593  0793: 5f               pop di
  078594  0794: c9               leave 

; ---- func_078595  size=2  insns=0  prologue=UNRECOGNISED (0xCA)  terminal=page-end ----
