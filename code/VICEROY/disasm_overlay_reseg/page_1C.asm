; ============================================================
; VICEROY.EXE overlay page 0x1C (record 27) -- RE-SEGMENTED
; file_offset (disk image) = 0x076D70
; code_offset (first insn) = 0x076E50
; code_end (next reloc hdr)= 0x077880  [resident size 163 para -> nominal_end 0x0777A0; on-disk code spills past it]
; reloc_count = 43  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x076D70)
; functions in page = 11
; ============================================================

; ---- func_076E50  size=521  insns=185  prologue=ENTER 0x000E,0  terminal=RETF imm16 ----
  076E50  00E0: c80e0000         enter 0xe, 0
  076E54  00E4: 50               push ax
  076E55  00E5: 53               push bx
  076E56  00E6: 57               push di
  076E57  00E7: 56               push si
  076E58  00E8: 8b7606           mov si, word ptr [bp + 6]
  076E5B  00EB: 8b7e0a           mov di, word ptr [bp + 0xa]
  076E5E  00EE: c746fa0100       mov word ptr [bp - 6], 1
  076E63  00F3: c746fcffff       mov word ptr [bp - 4], 0xffff
  076E68  00F8: 6a0d             push 0xd
  076E6A  00FA: ff7608           push word ptr [bp + 8]
  076E6D  00FD: 56               push si
  076E6E  00FE: 1e               push ds
  076E6F  00FF: 684c24           push 0x244c
  076E72  0102: 9ac0101d0d       lcall 0xd1d, 0x10c0
  076E77  0107: 83c40a           add sp, 0xa
  076E7A  010A: 8e460c           mov es, word ptr [bp + 0xc]
  076E7D  010D: 26c7050000       mov word ptr es:[di], 0
  076E82  0112: 6a72             push 0x72
  076E84  0114: ff76ee           push word ptr [bp - 0x12]
  076E87  0117: 9a460d1d0d       lcall 0xd1d, 0xd46
  076E8C  011C: 83c402           add sp, 2
  076E8F  011F: 50               push ax
  076E90  0120: 9a560c1d0d       lcall 0xd1d, 0xc56
  076E95  0125: 83c404           add sp, 4
  076E98  0128: 3d0100           cmp ax, 1
  076E9B  012B: 1bc0             sbb ax, ax
  076E9D  012D: 40               inc ax
  076E9E  012E: 8946fe           mov word ptr [bp - 2], ax
  076EA1  0131: 8e460c           mov es, word ptr [bp + 0xc]
  076EA4  0134: 26c6450400       mov byte ptr es:[di + 4], 0
  076EA9  0139: 26c74508ffff     mov word ptr es:[di + 8], 0xffff
  076EAF  013F: 8b4608           mov ax, word ptr [bp + 8]
  076EB2  0142: 50               push ax
  076EB3  0143: 56               push si
  076EB4  0144: 8b5eee           mov bx, word ptr [bp - 0x12]
  076EB7  0147: 8cc6             mov si, es
  076EB9  0149: 9a860e1f18       lcall 0x181f, 0xe86
  076EBE  014E: 8ec6             mov es, si
  076EC0  0150: 26894506         mov word ptr es:[di + 6], ax
  076EC4  0154: 0bc0             or ax, ax
  076EC6  0156: 7503             jne 0x15b
  076EC8  0158: e96901           jmp 0x2c4
  076ECB  015B: 8e460c           mov es, word ptr [bp + 0xc]
  076ECE  015E: 26c745180000     mov word ptr es:[di + 0x18], 0
  076ED4  0164: 8b46fe           mov ax, word ptr [bp - 2]
  076ED7  0167: 26894502         mov word ptr es:[di + 2], ax
  076EDB  016B: 0bc0             or ax, ax
  076EDD  016D: 7503             jne 0x172
  076EDF  016F: e9e600           jmp 0x258
  076EE2  0172: 8d46f6           lea ax, [bp - 0xa]
  076EE5  0175: 50               push ax
  076EE6  0176: 8e460c           mov es, word ptr [bp + 0xc]
  076EE9  0179: 26ff7506         push word ptr es:[di + 6]
  076EED  017D: 8cc6             mov si, es
  076EEF  017F: 9aa2091d0d       lcall 0xd1d, 0x9a2
  076EF4  0184: 83c404           add sp, 4
  076EF7  0187: 8d451a           lea ax, [di + 0x1a]
  076EFA  018A: 56               push si
  076EFB  018B: 50               push ax
  076EFC  018C: 6a00             push 0
  076EFE  018E: 6a01             push 1
  076F00  0190: 8ec6             mov es, si
  076F02  0192: 268b5d06         mov bx, word ptr es:[di + 6]
  076F06  0196: b81000           mov ax, 0x10
  076F09  0199: 99               cdq 
  076F0A  019A: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  076F0F  019F: 0bd0             or dx, ax
  076F11  01A1: 7503             jne 0x1a6
  076F13  01A3: e91e01           jmp 0x2c4
  076F16  01A6: 6a0c             push 0xc
  076F18  01A8: 1e               push ds
  076F19  01A9: 680a24           push 0x240a
  076F1C  01AC: 8bc7             mov ax, di
  076F1E  01AE: 8b560c           mov dx, word ptr [bp + 0xc]
  076F21  01B1: 051a00           add ax, 0x1a
  076F24  01B4: 52               push dx
  076F25  01B5: 50               push ax
  076F26  01B6: 9a84101d0d       lcall 0xd1d, 0x1084
  076F2B  01BB: 83c40a           add sp, 0xa
  076F2E  01BE: 0bc0             or ax, ax
  076F30  01C0: 7403             je 0x1c5
  076F32  01C2: e9ff00           jmp 0x2c4
  076F35  01C5: 8bc7             mov ax, di
  076F37  01C7: 8b560c           mov dx, word ptr [bp + 0xc]
  076F3A  01CA: 052a00           add ax, 0x2a
  076F3D  01CD: 52               push dx
  076F3E  01CE: 50               push ax
  076F3F  01CF: 6a00             push 0
  076F41  01D1: 6a01             push 1
  076F43  01D3: 8ec2             mov es, dx
  076F45  01D5: 8bf7             mov si, di
  076F47  01D7: 268b4428         mov ax, word ptr es:[si + 0x28]
  076F4B  01DB: 8bd0             mov dx, ax
  076F4D  01DD: c1e002           shl ax, 2
  076F50  01E0: 03c2             add ax, dx
  076F52  01E2: d1e0             shl ax, 1
  076F54  01E4: 2bd2             sub dx, dx
  076F56  01E6: 268b5c06         mov bx, word ptr es:[si + 6]
  076F5A  01EA: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  076F5F  01EF: 0bd0             or dx, ax
  076F61  01F1: 7503             jne 0x1f6
  076F63  01F3: e9ce00           jmp 0x2c4
  076F66  01F6: 8146f6b000       add word ptr [bp - 0xa], 0xb0
  076F6B  01FB: 8356f800         adc word ptr [bp - 8], 0
  076F6F  01FF: 8d46f6           lea ax, [bp - 0xa]
  076F72  0202: 50               push ax
  076F73  0203: 8e460c           mov es, word ptr [bp + 0xc]
  076F76  0206: 26ff7506         push word ptr es:[di + 6]
  076F7A  020A: 8cc6             mov si, es
  076F7C  020C: 9abe0a1d0d       lcall 0xd1d, 0xabe
  076F81  0211: 83c404           add sp, 4
  076F84  0214: 8ec6             mov es, si
  076F86  0216: 2bc0             sub ax, ax
  076F88  0218: 26894516         mov word ptr es:[di + 0x16], ax
  076F8C  021C: 26894514         mov word ptr es:[di + 0x14], ax
  076F90  0220: 8946fe           mov word ptr [bp - 2], ax
  076F93  0223: 26394528         cmp word ptr es:[di + 0x28], ax
  076F97  0227: 7f03             jg 0x22c
  076F99  0229: e98100           jmp 0x2ad
  076F9C  022C: 8e5e0c           mov ds, word ptr [bp + 0xc]
  076F9F  022F: 8bc7             mov ax, di
  076FA1  0231: 8cda             mov dx, ds
  076FA3  0233: 052c00           add ax, 0x2c
  076FA6  0236: 8bd8             mov bx, ax
  076FA8  0238: 8ec2             mov es, dx
  076FAA  023A: 8b4d28           mov cx, word ptr [di + 0x28]
  076FAD  023D: 8bf3             mov si, bx
  076FAF  023F: 83c30a           add bx, 0xa
  076FB2  0242: 268b04           mov ax, word ptr es:[si]
  076FB5  0245: 268b5402         mov dx, word ptr es:[si + 2]
  076FB9  0249: 014514           add word ptr [di + 0x14], ax
  076FBC  024C: 115516           adc word ptr [di + 0x16], dx
  076FBF  024F: e2ec             loop 0x23d
  076FC1  0251: b85a1b           mov ax, 0x1b5a
  076FC4  0254: 8ed8             mov ds, ax
  076FC6  0256: eb55             jmp 0x2ad
  076FC8  0258: 8e460c           mov es, word ptr [bp + 0xc]
  076FCB  025B: 26c745280000     mov word ptr es:[di + 0x28], 0
  076FD1  0261: 8a46f0           mov al, byte ptr [bp - 0x10]
  076FD4  0264: 2688452a         mov byte ptr es:[di + 0x2a], al
  076FD8  0268: 1e               push ds
  076FD9  0269: 681824           push 0x2418
  076FDC  026C: 8d451a           lea ax, [di + 0x1a]
  076FDF  026F: 06               push es
  076FE0  0270: 50               push ax
  076FE1  0271: 8bf0             mov si, ax
  076FE3  0273: 8976f2           mov word ptr [bp - 0xe], si
  076FE6  0276: 8c46f4           mov word ptr [bp - 0xc], es
  076FE9  0279: 8cc6             mov si, es
  076FEB  027B: 9a7e111d0d       lcall 0xd1d, 0x117e
  076FF0  0280: 83c408           add sp, 8
  076FF3  0283: ff76f4           push word ptr [bp - 0xc]
  076FF6  0286: ff76f2           push word ptr [bp - 0xe]
  076FF9  0289: 6a00             push 0
  076FFB  028B: 6a01             push 1
  076FFD  028D: 8ec6             mov es, si
  076FFF  028F: 268b5d06         mov bx, word ptr es:[di + 6]
  077003  0293: b8b000           mov ax, 0xb0
  077006  0296: 99               cdq 
  077007  0297: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  07700C  029C: 0bd0             or dx, ax
  07700E  029E: 7424             je 0x2c4
  077010  02A0: 8e460c           mov es, word ptr [bp + 0xc]
  077013  02A3: 2bc0             sub ax, ax
  077015  02A5: 26894516         mov word ptr es:[di + 0x16], ax
  077019  02A9: 26894514         mov word ptr es:[di + 0x14], ax
  07701D  02AD: 83062e2401       add word ptr [0x242e], 1
  077022  02B2: 8316302400       adc word ptr [0x2430], 0
  077027  02B7: 8e460c           mov es, word ptr [bp + 0xc]
  07702A  02BA: 26c7050100       mov word ptr es:[di], 1
  07702F  02BF: c746fa0000       mov word ptr [bp - 6], 0
  077034  02C4: 837efa00         cmp word ptr [bp - 6], 0
  077038  02C8: 7416             je 0x2e0
  07703A  02CA: 8e460c           mov es, word ptr [bp + 0xc]
  07703D  02CD: 26837d0600       cmp word ptr es:[di + 6], 0
  077042  02D2: 740c             je 0x2e0
  077044  02D4: 26ff7506         push word ptr es:[di + 6]
  077048  02D8: 9af4031d0d       lcall 0xd1d, 0x3f4
  07704D  02DD: 83c402           add sp, 2
  077050  02E0: 8b46fa           mov ax, word ptr [bp - 6]
  077053  02E3: 5e               pop si
  077054  02E4: 5f               pop di
  077055  02E5: c9               leave 
  077056  02E6: ca0800           retf 8

; ---- func_07705A  size=18  insns=9  prologue=push bp;mov bp,sp  terminal=RETF imm16 ----
  07705A  02EA: 55               push bp
  07705B  02EB: 8bec             mov bp, sp
  07705D  02ED: 56               push si
  07705E  02EE: 8bd8             mov bx, ax
  077060  02F0: c47606           les si, ptr [bp + 6]
  077063  02F3: 26885c2b         mov byte ptr es:[si + 0x2b], bl
  077067  02F7: 5e               pop si
  077068  02F8: c9               leave 
  077069  02F9: ca0400           retf 4

; ---- func_07706C  size=148  insns=56  prologue=push bp;mov bp,sp  terminal=RETF imm16 ----
  07706C  02FC: 55               push bp
  07706D  02FD: 8bec             mov bp, sp
  07706F  02FF: 57               push di
  077070  0300: 56               push si
  077071  0301: c47606           les si, ptr [bp + 6]
  077074  0304: 2bff             sub di, di
  077076  0306: 26393c           cmp word ptr es:[si], di
  077079  0309: 7475             je 0x380
  07707B  030B: 26807c0401       cmp byte ptr es:[si + 4], 1
  077080  0310: 7458             je 0x36a
  077082  0312: 26807c0402       cmp byte ptr es:[si + 4], 2
  077087  0317: 7451             je 0x36a
  077089  0319: 26397c02         cmp word ptr es:[si + 2], di
  07708D  031D: 7539             jne 0x358
  07708F  031F: 26ff7406         push word ptr es:[si + 6]
  077093  0323: 8cc7             mov di, es
  077095  0325: 9ad80a1d0d       lcall 0xd1d, 0xad8
  07709A  032A: 83c402           add sp, 2
  07709D  032D: 8bc6             mov ax, si
  07709F  032F: 8bd7             mov dx, di
  0770A1  0331: 051a00           add ax, 0x1a
  0770A4  0334: 52               push dx
  0770A5  0335: 50               push ax
  0770A6  0336: 6a00             push 0
  0770A8  0338: 6a01             push 1
  0770AA  033A: 8ec7             mov es, di
  0770AC  033C: 8bde             mov bx, si
  0770AE  033E: 268b5f06         mov bx, word ptr es:[bx + 6]
  0770B2  0342: b8b000           mov ax, 0xb0
  0770B5  0345: 99               cdq 
  0770B6  0346: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  0770BB  034B: 0bd0             or dx, ax
  0770BD  034D: 7507             jne 0x356
  0770BF  034F: bf0100           mov di, 1
  0770C2  0352: eb04             jmp 0x358
  0770C4  0354: 90               nop 
  0770C5  0355: 90               nop 
  0770C6  0356: 2bff             sub di, di
  0770C8  0358: 8e4608           mov es, word ptr [bp + 8]
  0770CB  035B: 26ff7406         push word ptr es:[si + 6]
  0770CF  035F: 9af4031d0d       lcall 0xd1d, 0x3f4
  0770D4  0364: 83c402           add sp, 2
  0770D7  0367: eb17             jmp 0x380
  0770D9  0369: 90               nop 
  0770DA  036A: 26c74410ffff     mov word ptr es:[si + 0x10], 0xffff
  0770E0  0370: 26c744120040     mov word ptr es:[si + 0x12], 0x4000
  0770E6  0376: 2bc0             sub ax, ax
  0770E8  0378: 2689440e         mov word ptr es:[si + 0xe], ax
  0770EC  037C: 2689440c         mov word ptr es:[si + 0xc], ax
  0770F0  0380: 8e4608           mov es, word ptr [bp + 8]
  0770F3  0383: 26c7040000       mov word ptr es:[si], 0
  0770F8  0388: 8bc7             mov ax, di
  0770FA  038A: 5e               pop si
  0770FB  038B: 5f               pop di
  0770FC  038C: c9               leave 
  0770FD  038D: ca0400           retf 4

; ---- func_077100  size=441  insns=163  prologue=ENTER 0x0020,0  terminal=RETF imm16 ----
  077100  0390: c8200000         enter 0x20, 0
  077104  0394: 52               push dx
  077105  0395: 50               push ax
  077106  0396: 57               push di
  077107  0397: 56               push si
  077108  0398: 2bc0             sub ax, ax
  07710A  039A: 8946f4           mov word ptr [bp - 0xc], ax
  07710D  039D: 8946f2           mov word ptr [bp - 0xe], ax
  077110  03A0: 8946ea           mov word ptr [bp - 0x16], ax
  077113  03A3: 8946e8           mov word ptr [bp - 0x18], ax
  077116  03A6: 8946ec           mov word ptr [bp - 0x14], ax
  077119  03A9: 8bc2             mov ax, dx
  07711B  03AB: 0b46dc           or ax, word ptr [bp - 0x24]
  07711E  03AE: 750a             jne 0x3ba
  077120  03B0: 2bc0             sub ax, ax
  077122  03B2: 2bd2             sub dx, dx
  077124  03B4: 5e               pop si
  077125  03B5: 5f               pop di
  077126  03B6: c9               leave 
  077127  03B7: ca0c00           retf 0xc
  07712A  03BA: 837e0a01         cmp word ptr [bp + 0xa], 1
  07712E  03BE: 750c             jne 0x3cc
  077130  03C0: 837e0c00         cmp word ptr [bp + 0xc], 0
  077134  03C4: 7506             jne 0x3cc
  077136  03C6: 8b46dc           mov ax, word ptr [bp - 0x24]
  077139  03C9: eb10             jmp 0x3db
  07713B  03CB: 90               nop 
  07713C  03CC: 52               push dx
  07713D  03CD: ff76dc           push word ptr [bp - 0x24]
  077140  03D0: ff760c           push word ptr [bp + 0xc]
  077143  03D3: ff760a           push word ptr [bp + 0xa]
  077146  03D6: 9a600f1d0d       lcall 0xd1d, 0xf60
  07714B  03DB: 8946fc           mov word ptr [bp - 4], ax
  07714E  03DE: 8956fe           mov word ptr [bp - 2], dx
  077151  03E1: c47606           les si, ptr [bp + 6]
  077154  03E4: 268b7c18         mov di, word ptr es:[si + 0x18]
  077158  03E8: 26ff4418         inc word ptr es:[si + 0x18]
  07715C  03EC: 26807c0401       cmp byte ptr es:[si + 4], 1
  077161  03F1: 740f             je 0x402
  077163  03F3: 26807c0402       cmp byte ptr es:[si + 4], 2
  077168  03F8: 750e             jne 0x408
  07716A  03FA: 2bc0             sub ax, ax
  07716C  03FC: 8946f4           mov word ptr [bp - 0xc], ax
  07716F  03FF: 8946f2           mov word ptr [bp - 0xe], ax
  077172  0402: 8b7ee8           mov di, word ptr [bp - 0x18]
  077175  0405: e90101           jmp 0x509
  077178  0408: 2bc0             sub ax, ax
  07717A  040A: 8946f4           mov word ptr [bp - 0xc], ax
  07717D  040D: 8946f2           mov word ptr [bp - 0xe], ax
  077180  0410: 8bde             mov bx, si
  077182  0412: 8bc7             mov ax, di
  077184  0414: c1e002           shl ax, 2
  077187  0417: 03c7             add ax, di
  077189  0419: d1e0             shl ax, 1
  07718B  041B: 03d8             add bx, ax
  07718D  041D: 268a472a         mov al, byte ptr es:[bx + 0x2a]
  077191  0421: 2ae4             sub ah, ah
  077193  0423: a3ca26           mov word ptr [0x26ca], ax
  077196  0426: 268b4f30         mov cx, word ptr es:[bx + 0x30]
  07719A  042A: 268b5732         mov dx, word ptr es:[bx + 0x32]
  07719E  042E: 894ef8           mov word ptr [bp - 8], cx
  0771A1  0431: 8956fa           mov word ptr [bp - 6], dx
  0771A4  0434: 3d0100           cmp ax, 1
  0771A7  0437: 1bc0             sbb ax, ax
  0771A9  0439: 250100           and ax, 1
  0771AC  043C: 40               inc ax
  0771AD  043D: 8946f6           mov word ptr [bp - 0xa], ax
  0771B0  0440: 48               dec ax
  0771B1  0441: 7403             je 0x446
  0771B3  0443: e9ea00           jmp 0x530
  0771B6  0446: 8bc1             mov ax, cx
  0771B8  0448: 9a9a021f18       lcall 0x181f, 0x29a
  0771BD  044D: 8bf8             mov di, ax
  0771BF  044F: 8956ea           mov word ptr [bp - 0x16], dx
  0771C2  0452: 0bd0             or dx, ax
  0771C4  0454: 7448             je 0x49e
  0771C6  0456: ff76ea           push word ptr [bp - 0x16]
  0771C9  0459: 57               push di
  0771CA  045A: 6a00             push 0
  0771CC  045C: 6a01             push 1
  0771CE  045E: 8e4608           mov es, word ptr [bp + 8]
  0771D1  0461: 268b5c06         mov bx, word ptr es:[si + 6]
  0771D5  0465: 8b46f8           mov ax, word ptr [bp - 8]
  0771D8  0468: 8b56fa           mov dx, word ptr [bp - 6]
  0771DB  046B: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  0771E0  0470: 0bd0             or dx, ax
  0771E2  0472: 7503             jne 0x477
  0771E4  0474: e99200           jmp 0x509
  0771E7  0477: ff76fe           push word ptr [bp - 2]
  0771EA  047A: ff76fc           push word ptr [bp - 4]
  0771ED  047D: ff76ea           push word ptr [bp - 0x16]
  0771F0  0480: 57               push di
  0771F1  0481: ff7610           push word ptr [bp + 0x10]
  0771F4  0484: ff760e           push word ptr [bp + 0xe]
  0771F7  0487: 8b46f6           mov ax, word ptr [bp - 0xa]
  0771FA  048A: 2bd2             sub dx, dx
  0771FC  048C: 2bdb             sub bx, bx
  0771FE  048E: 9aba0e1f1a       lcall 0x1a1f, 0xeba
  077203  0493: 8946f2           mov word ptr [bp - 0xe], ax
  077206  0496: 8956f4           mov word ptr [bp - 0xc], dx
  077209  0499: c746ec0100       mov word ptr [bp - 0x14], 1
  07720E  049E: 837eec00         cmp word ptr [bp - 0x14], 0
  077212  04A2: 7565             jne 0x509
  077214  04A4: 8d46e4           lea ax, [bp - 0x1c]
  077217  04A7: 50               push ax
  077218  04A8: 8e4608           mov es, word ptr [bp + 8]
  07721B  04AB: 26ff7406         push word ptr es:[si + 6]
  07721F  04AF: 8976e0           mov word ptr [bp - 0x20], si
  077222  04B2: 8c46e2           mov word ptr [bp - 0x1e], es
  077225  04B5: 9aa2091d0d       lcall 0xd1d, 0x9a2
  07722A  04BA: 83c404           add sp, 4
  07722D  04BD: ff76fe           push word ptr [bp - 2]
  077230  04C0: ff76fc           push word ptr [bp - 4]
  077233  04C3: c45ee0           les bx, ptr [bp - 0x20]
  077236  04C6: 1e               push ds
  077237  04C7: 26ff7706         push word ptr es:[bx + 6]
  07723B  04CB: ff7610           push word ptr [bp + 0x10]
  07723E  04CE: ff760e           push word ptr [bp + 0xe]
  077241  04D1: 8b46f6           mov ax, word ptr [bp - 0xa]
  077244  04D4: ba0100           mov dx, 1
  077247  04D7: 2bdb             sub bx, bx
  077249  04D9: 9aba0e1f1a       lcall 0x1a1f, 0xeba
  07724E  04DE: 8946f2           mov word ptr [bp - 0xe], ax
  077251  04E1: 8956f4           mov word ptr [bp - 0xc], dx
  077254  04E4: 837ef601         cmp word ptr [bp - 0xa], 1
  077258  04E8: 751f             jne 0x509
  07725A  04EA: 6a00             push 0
  07725C  04EC: 8b46f8           mov ax, word ptr [bp - 8]
  07725F  04EF: 8b56fa           mov dx, word ptr [bp - 6]
  077262  04F2: 0346e4           add ax, word ptr [bp - 0x1c]
  077265  04F5: 1356e6           adc dx, word ptr [bp - 0x1a]
  077268  04F8: 52               push dx
  077269  04F9: 50               push ax
  07726A  04FA: 8e4608           mov es, word ptr [bp + 8]
  07726D  04FD: 26ff7406         push word ptr es:[si + 6]
  077271  0501: 9a3e0a1d0d       lcall 0xd1d, 0xa3e
  077276  0506: 83c408           add sp, 8
  077279  0509: 8b46ea           mov ax, word ptr [bp - 0x16]
  07727C  050C: 0bc7             or ax, di
  07727E  050E: 740a             je 0x51a
  077280  0510: 8b46ea           mov ax, word ptr [bp - 0x16]
  077283  0513: 50               push ax
  077284  0514: 57               push di
  077285  0515: 9aa8011f19       lcall 0x191f, 0x1a8
  07728A  051A: 8b46f2           mov ax, word ptr [bp - 0xe]
  07728D  051D: 8b56f4           mov dx, word ptr [bp - 0xc]
  077290  0520: 3946dc           cmp word ptr [bp - 0x24], ax
  077293  0523: 7511             jne 0x536
  077295  0525: 3956de           cmp word ptr [bp - 0x22], dx
  077298  0528: 750c             jne 0x536
  07729A  052A: b80100           mov ax, 1
  07729D  052D: e982fe           jmp 0x3b2
  0772A0  0530: 8b7ee8           mov di, word ptr [bp - 0x18]
  0772A3  0533: e968ff           jmp 0x49e
  0772A6  0536: ff76de           push word ptr [bp - 0x22]
  0772A9  0539: ff76dc           push word ptr [bp - 0x24]
  0772AC  053C: 52               push dx
  0772AD  053D: 50               push ax
  0772AE  053E: 9ac60e1d0d       lcall 0xd1d, 0xec6
  0772B3  0543: 5e               pop si
  0772B4  0544: 5f               pop di
  0772B5  0545: c9               leave 
  0772B6  0546: ca0c00           retf 0xc

; ---- func_0772BA  size=10  insns=6  prologue=push bp;mov bp,sp  terminal=RETF ----
  0772BA  054A: 55               push bp
  0772BB  054B: 8bec             mov bp, sp
  0772BD  054D: c45e06           les bx, ptr [bp + 6]
  0772C0  0550: 8bc3             mov ax, bx
  0772C2  0552: c9               leave 
  0772C3  0553: cb               retf 

; ---- func_0772C4  size=21  insns=11  prologue=push bp;mov bp,sp  terminal=RETF ----
  0772C4  0554: 55               push bp
  0772C5  0555: 8bec             mov bp, sp
  0772C7  0557: 57               push di
  0772C8  0558: c43e5e24         les di, ptr [0x245e]
  0772CC  055C: 8cc0             mov ax, es
  0772CE  055E: 0bc7             or ax, di
  0772D0  0560: 7404             je 0x566
  0772D2  0562: ff1e5e24         lcall [0x245e]
  0772D6  0566: 5f               pop di
  0772D7  0567: c9               leave 
  0772D8  0568: cb               retf 

; ---- func_0772DA  size=31  insns=12  prologue=push bp;mov bp,sp  terminal=RETF ----
  0772DA  056A: 55               push bp
  0772DB  056B: 8bec             mov bp, sp
  0772DD  056D: 8b4606           mov ax, word ptr [bp + 6]
  0772E0  0570: 8b5608           mov dx, word ptr [bp + 8]
  0772E3  0573: a35a24           mov word ptr [0x245a], ax
  0772E6  0576: 89165c24         mov word ptr [0x245c], dx
  0772EA  057A: 8b460a           mov ax, word ptr [bp + 0xa]
  0772ED  057D: 8b560c           mov dx, word ptr [bp + 0xc]
  0772F0  0580: a35e24           mov word ptr [0x245e], ax
  0772F3  0583: 89166024         mov word ptr [0x2460], dx
  0772F7  0587: c9               leave 
  0772F8  0588: cb               retf 

; ---- func_0772FA  size=754  insns=251  prologue=ENTER 0x0006,0  terminal=JMP-tail ----
  0772FA  058A: c8060000         enter 6, 0
  0772FE  058E: 53               push bx
  0772FF  058F: 52               push dx
  077300  0590: 50               push ax
  077301  0591: 57               push di
  077302  0592: 56               push si
  077303  0593: c746fc0000       mov word ptr [bp - 4], 0
  077308  0598: 0bd2             or dx, dx
  07730A  059A: 751c             jne 0x5b8
  07730C  059C: c70644a6100f     mov word ptr [0xa644], 0xf10
  077312  05A2: c70646a61f1a     mov word ptr [0xa646], 0x1a1f
  077318  05A8: 8b460a           mov ax, word ptr [bp + 0xa]
  07731B  05AB: 8b560c           mov dx, word ptr [bp + 0xc]
  07731E  05AE: a348a6           mov word ptr [0xa648], ax
  077321  05B1: 89164aa6         mov word ptr [0xa64a], dx
  077325  05B5: eb1d             jmp 0x5d4
  077327  05B7: 90               nop 
  077328  05B8: c70644a6060f     mov word ptr [0xa644], 0xf06
  07732E  05BE: c70646a61f1a     mov word ptr [0xa646], 0x1a1f
  077334  05C4: ff760c           push word ptr [bp + 0xc]
  077337  05C7: ff760a           push word ptr [bp + 0xa]
  07733A  05CA: 0e               push cs
  07733B  05CB: e8a902           call 0x877
  07733E  05CE: 83c404           add sp, 4
  077341  05D1: a342a6           mov word ptr [0xa642], ax
  077344  05D4: 837ef802         cmp word ptr [bp - 8], 2
  077348  05D8: 743e             je 0x618
  07734A  05DA: 837ef800         cmp word ptr [bp - 8], 0
  07734E  05DE: 751c             jne 0x5fc
  077350  05E0: c7063aa6fc0e     mov word ptr [0xa63a], 0xefc
  077356  05E6: c7063ca61f1a     mov word ptr [0xa63c], 0x1a1f
  07735C  05EC: 8b4606           mov ax, word ptr [bp + 6]
  07735F  05EF: 8b5608           mov dx, word ptr [bp + 8]
  077362  05F2: a33ea6           mov word ptr [0xa63e], ax
  077365  05F5: 891640a6         mov word ptr [0xa640], dx
  077369  05F9: eb1d             jmp 0x618
  07736B  05FB: 90               nop 
  07736C  05FC: c7063aa6f20e     mov word ptr [0xa63a], 0xef2
  077372  0602: c7063ca61f1a     mov word ptr [0xa63c], 0x1a1f
  077378  0608: ff7608           push word ptr [bp + 8]
  07737B  060B: ff7606           push word ptr [bp + 6]
  07737E  060E: 0e               push cs
  07737F  060F: e86502           call 0x877
  077382  0612: 83c404           add sp, 4
  077385  0615: a338a6           mov word ptr [0xa638], ax
  077388  0618: 2bc0             sub ax, ax
  07738A  061A: a32aa6           mov word ptr [0xa62a], ax
  07738D  061D: a328a6           mov word ptr [0xa628], ax
  077390  0620: a336a6           mov word ptr [0xa636], ax
  077393  0623: a334a6           mov word ptr [0xa634], ax
  077396  0626: 8b46f4           mov ax, word ptr [bp - 0xc]
  077399  0629: 0bc0             or ax, ax
  07739B  062B: 742d             je 0x65a
  07739D  062D: 48               dec ax
  07739E  062E: 7503             jne 0x633
  0773A0  0630: e98d00           jmp 0x6c0
  0773A3  0633: c70626a60010     mov word ptr [0xa626], 0x1000
  0773A9  0639: 8b460e           mov ax, word ptr [bp + 0xe]
  0773AC  063C: 8b5610           mov dx, word ptr [bp + 0x10]
  0773AF  063F: a330a6           mov word ptr [0xa630], ax
  0773B2  0642: 891632a6         mov word ptr [0xa632], dx
  0773B6  0646: a32ca6           mov word ptr [0xa62c], ax
  0773B9  0649: 89162ea6         mov word ptr [0xa62e], dx
  0773BD  064D: c746fa30a6       mov word ptr [bp - 6], 0xa630
  0773C2  0652: c746fe28a6       mov word ptr [bp - 2], 0xa628
  0773C7  0657: e92201           jmp 0x77c
  0773CA  065A: 833eca2601       cmp word ptr [0x26ca], 1
  0773CF  065F: 750f             jne 0x670
  0773D1  0661: c70626a6be71     mov word ptr [0xa626], 0x71be
  0773D7  0667: a1d626           mov ax, word ptr [0x26d6]
  0773DA  066A: 0b06d426         or ax, word ptr [0x26d4]
  0773DE  066E: eb0d             jmp 0x67d
  0773E0  0670: c70626a6b889     mov word ptr [0xa626], 0x89b8
  0773E6  0676: a1ce26           mov ax, word ptr [0x26ce]
  0773E9  0679: 0b06cc26         or ax, word ptr [0x26cc]
  0773ED  067D: 751a             jne 0x699
  0773EF  067F: 8b46f4           mov ax, word ptr [bp - 0xc]
  0773F2  0682: 99               cdq 
  0773F3  0683: 52               push dx
  0773F4  0684: 50               push ax
  0773F5  0685: a1ca26           mov ax, word ptr [0x26ca]
  0773F8  0688: 99               cdq 
  0773F9  0689: 52               push dx
  0773FA  068A: 50               push ax
  0773FB  068B: b8e3ff           mov ax, 0xffe3
  0773FE  068E: ba0300           mov dx, 3
  077401  0691: bb1800           mov bx, 0x18
  077404  0694: 9a72071f18       lcall 0x181f, 0x772
  077409  0699: 8b460e           mov ax, word ptr [bp + 0xe]
  07740C  069C: 8b5610           mov dx, word ptr [bp + 0x10]
  07740F  069F: a330a6           mov word ptr [0xa630], ax
  077412  06A2: 891632a6         mov word ptr [0xa632], dx
  077416  06A6: c7062ca6ffff     mov word ptr [0xa62c], 0xffff
  07741C  06AC: c7062ea6ffff     mov word ptr [0xa62e], 0xffff
  077422  06B2: c746fa30a6       mov word ptr [bp - 6], 0xa630
  077427  06B7: c746fe34a6       mov word ptr [bp - 2], 0xa634
  07742C  06BC: e9bd00           jmp 0x77c
  07742F  06BF: 90               nop 
  077430  06C0: c70630a6ffff     mov word ptr [0xa630], 0xffff
  077436  06C6: c70632a6ffff     mov word ptr [0xa632], 0xffff
  07743C  06CC: 8b460e           mov ax, word ptr [bp + 0xe]
  07743F  06CF: 8b5610           mov dx, word ptr [bp + 0x10]
  077442  06D2: a32ca6           mov word ptr [0xa62c], ax
  077445  06D5: 89162ea6         mov word ptr [0xa62e], dx
  077449  06D9: c746fa2ca6       mov word ptr [bp - 6], 0xa62c
  07744E  06DE: 833eca2601       cmp word ptr [0x26ca], 1
  077453  06E3: 7569             jne 0x74e
  077455  06E5: 837ef600         cmp word ptr [bp - 0xa], 0
  077459  06E9: 7523             jne 0x70e
  07745B  06EB: 837ef800         cmp word ptr [bp - 8], 0
  07745F  06EF: 751d             jne 0x70e
  077461  06F1: a1e226           mov ax, word ptr [0x26e2]
  077464  06F4: 0b06e026         or ax, word ptr [0x26e0]
  077468  06F8: 7414             je 0x70e
  07746A  06FA: 8d460e           lea ax, [bp + 0xe]
  07746D  06FD: 8946fe           mov word ptr [bp - 2], ax
  077470  0700: c70626a60400     mov word ptr [0xa626], 4
  077476  0706: c746fc0200       mov word ptr [bp - 4], 2
  07747B  070B: eb6f             jmp 0x77c
  07747D  070D: 90               nop 
  07747E  070E: 837ef801         cmp word ptr [bp - 8], 1
  077482  0712: 7420             je 0x734
  077484  0714: 837ef802         cmp word ptr [bp - 8], 2
  077488  0718: 741a             je 0x734
  07748A  071A: 8d460e           lea ax, [bp + 0xe]
  07748D  071D: 8946fe           mov word ptr [bp - 2], ax
  077490  0720: c70626a62008     mov word ptr [0xa626], 0x820
  077496  0726: c746fc0100       mov word ptr [bp - 4], 1
  07749B  072B: a1de26           mov ax, word ptr [0x26de]
  07749E  072E: 0b06dc26         or ax, word ptr [0x26dc]
  0774A2  0732: eb2c             jmp 0x760
  0774A4  0734: c746fe28a6       mov word ptr [bp - 2], 0xa628
  0774A9  0739: c70626a62c38     mov word ptr [0xa626], 0x382c
  0774AF  073F: c746fc0000       mov word ptr [bp - 4], 0
  0774B4  0744: a1da26           mov ax, word ptr [0x26da]
  0774B7  0747: 0b06d826         or ax, word ptr [0x26d8]
  0774BB  074B: eb13             jmp 0x760
  0774BD  074D: 90               nop 
  0774BE  074E: c746fe28a6       mov word ptr [bp - 2], 0xa628
  0774C3  0753: c70626a61e31     mov word ptr [0xa626], 0x311e
  0774C9  0759: a1d226           mov ax, word ptr [0x26d2]
  0774CC  075C: 0b06d026         or ax, word ptr [0x26d0]
  0774D0  0760: 751a             jne 0x77c
  0774D2  0762: 8b46f4           mov ax, word ptr [bp - 0xc]
  0774D5  0765: 99               cdq 
  0774D6  0766: 52               push dx
  0774D7  0767: 50               push ax
  0774D8  0768: a1ca26           mov ax, word ptr [0x26ca]
  0774DB  076B: 99               cdq 
  0774DC  076C: 52               push dx
  0774DD  076D: 50               push ax
  0774DE  076E: b8e3ff           mov ax, 0xffe3
  0774E1  0771: ba0300           mov dx, 3
  0774E4  0774: bb1800           mov bx, 0x18
  0774E7  0777: 9a72071f18       lcall 0x181f, 0x772
  0774EC  077C: 2bc0             sub ax, ax
  0774EE  077E: a324a6           mov word ptr [0xa624], ax
  0774F1  0781: a322a6           mov word ptr [0xa622], ax
  0774F4  0784: a15c24           mov ax, word ptr [0x245c]
  0774F7  0787: 0b065a24         or ax, word ptr [0x245a]
  0774FB  078B: 752b             jne 0x7b8
  0774FD  078D: 1e               push ds
  0774FE  078E: 686224           push 0x2462
  077501  0791: a126a6           mov ax, word ptr [0xa626]
  077504  0794: 2bd2             sub dx, dx
  077506  0796: 9a900e1f1a       lcall 0x1a1f, 0xe90
  07750B  079B: a322a6           mov word ptr [0xa622], ax
  07750E  079E: 891624a6         mov word ptr [0xa624], dx
  077512  07A2: 8bc2             mov ax, dx
  077514  07A4: 0b0622a6         or ax, word ptr [0xa622]
  077518  07A8: 751c             jne 0x7c6
  07751A  07AA: 8b5efe           mov bx, word ptr [bp - 2]
  07751D  07AD: 2bc0             sub ax, ax
  07751F  07AF: 894702           mov word ptr [bx + 2], ax
  077522  07B2: 8907             mov word ptr [bx], ax
  077524  07B4: e98800           jmp 0x83f
  077527  07B7: 90               nop 
  077528  07B8: a15a24           mov ax, word ptr [0x245a]
  07752B  07BB: 8b165c24         mov dx, word ptr [0x245c]
  07752F  07BF: a322a6           mov word ptr [0xa622], ax
  077532  07C2: 891624a6         mov word ptr [0xa624], dx
  077536  07C6: 837ef401         cmp word ptr [bp - 0xc], 1
  07753A  07CA: 7530             jne 0x7fc
  07753C  07CC: 837ef800         cmp word ptr [bp - 8], 0
  077540  07D0: 752a             jne 0x7fc
  077542  07D2: 8b46f4           mov ax, word ptr [bp - 0xc]
  077545  07D5: 8b56fc           mov dx, word ptr [bp - 4]
  077548  07D8: 9ae40e1f1a       lcall 0x1a1f, 0xee4
  07754D  07DD: 8bf0             mov si, ax
  07754F  07DF: 0bf6             or si, si
  077551  07E1: 745c             je 0x83f
  077553  07E3: 8b5efe           mov bx, word ptr [bp - 2]
  077556  07E6: 2bc0             sub ax, ax
  077558  07E8: 894702           mov word ptr [bx + 2], ax
  07755B  07EB: 8907             mov word ptr [bx], ax
  07755D  07ED: 6946f4e803       imul ax, word ptr [bp - 0xc], 0x3e8
  077562  07F2: 0346fc           add ax, word ptr [bp - 4]
  077565  07F5: 99               cdq 
  077566  07F6: 52               push dx
  077567  07F7: 50               push ax
  077568  07F8: 8bc6             mov ax, si
  07756A  07FA: eb32             jmp 0x82e
  07756C  07FC: 8b76fa           mov si, word ptr [bp - 6]
  07756F  07FF: 8b7ef4           mov di, word ptr [bp - 0xc]
  077572  0802: 837c0200         cmp word ptr [si + 2], 0
  077576  0806: 7c37             jl 0x83f
  077578  0808: 7f05             jg 0x80f
  07757A  080A: 833c00           cmp word ptr [si], 0
  07757D  080D: 7430             je 0x83f
  07757F  080F: 8bc7             mov ax, di
  077581  0811: 2bd2             sub dx, dx
  077583  0813: 9ae40e1f1a       lcall 0x1a1f, 0xee4
  077588  0818: 0bc0             or ax, ax
  07758A  081A: 74e6             je 0x802
  07758C  081C: 8b5efe           mov bx, word ptr [bp - 2]
  07758F  081F: 2bc0             sub ax, ax
  077591  0821: 894702           mov word ptr [bx + 2], ax
  077594  0824: 8907             mov word ptr [bx], ax
  077596  0826: 8bc7             mov ax, di
  077598  0828: 99               cdq 
  077599  0829: 52               push dx
  07759A  082A: 50               push ax
  07759B  082B: 8b46f8           mov ax, word ptr [bp - 8]
  07759E  082E: 99               cdq 
  07759F  082F: 52               push dx
  0775A0  0830: 50               push ax
  0775A1  0831: b8e4ff           mov ax, 0xffe4
  0775A4  0834: ba0300           mov dx, 3
  0775A7  0837: bb1800           mov bx, 0x18
  0775AA  083A: 9a72071f18       lcall 0x181f, 0x772
  0775AF  083F: a15c24           mov ax, word ptr [0x245c]
  0775B2  0842: 0b065a24         or ax, word ptr [0x245a]
  0775B6  0846: 7518             jne 0x860
  0775B8  0848: a124a6           mov ax, word ptr [0xa624]
  0775BB  084B: 0b0622a6         or ax, word ptr [0xa622]
  0775BF  084F: 7413             je 0x864
  0775C1  0851: ff3624a6         push word ptr [0xa624]
  0775C5  0855: ff3622a6         push word ptr [0xa622]
  0775C9  0859: 9aa8011f19       lcall 0x191f, 0x1a8
  0775CE  085E: eb04             jmp 0x864
  0775D0  0860: 0e               push cs
  0775D1  0861: e80e00           call 0x872
  0775D4  0864: 8b5efe           mov bx, word ptr [bp - 2]
  0775D7  0867: 8b07             mov ax, word ptr [bx]
  0775D9  0869: 8b5702           mov dx, word ptr [bx + 2]
  0775DC  086C: 5e               pop si
  0775DD  086D: 5f               pop di
  0775DE  086E: c9               leave 
  0775DF  086F: ca0c00           retf 0xc
  0775E2  0872: eac80e1f1a       ljmp 0x1a1f:0xec8
  0775E7  0877: ead60e1f1a       ljmp 0x1a1f:0xed6

; ---- func_0775EC  size=263  insns=107  prologue=ENTER 0x000E,0  terminal=RETF imm16 ----
  0775EC  087C: c80e0000         enter 0xe, 0
  0775F0  0880: 53               push bx
  0775F1  0881: 52               push dx
  0775F2  0882: 50               push ax
  0775F3  0883: 57               push di
  0775F4  0884: 56               push si
  0775F5  0885: 8bfb             mov di, bx
  0775F7  0887: 2bc0             sub ax, ax
  0775F9  0889: 8946f6           mov word ptr [bp - 0xa], ax
  0775FC  088C: 8946f4           mov word ptr [bp - 0xc], ax
  0775FF  088F: 8946fa           mov word ptr [bp - 6], ax
  077602  0892: 8946f8           mov word ptr [bp - 8], ax
  077605  0895: 8bc2             mov ax, dx
  077607  0897: 0b46ec           or ax, word ptr [bp - 0x14]
  07760A  089A: 7503             jne 0x89f
  07760C  089C: e9de00           jmp 0x97d
  07760F  089F: f6450604         test byte ptr [di + 6], 4
  077613  08A3: 750b             jne 0x8b0
  077615  08A5: 6a00             push 0
  077617  08A7: 57               push di
  077618  08A8: 9a1c0b1d0d       lcall 0xd1d, 0xb1c
  07761D  08AD: 83c404           add sp, 4
  077620  08B0: 837e0601         cmp word ptr [bp + 6], 1
  077624  08B4: 750e             jne 0x8c4
  077626  08B6: 837e0800         cmp word ptr [bp + 8], 0
  07762A  08BA: 7508             jne 0x8c4
  07762C  08BC: 8b46ec           mov ax, word ptr [bp - 0x14]
  07762F  08BF: 8b56ee           mov dx, word ptr [bp - 0x12]
  077632  08C2: eb11             jmp 0x8d5
  077634  08C4: ff7608           push word ptr [bp + 8]
  077637  08C7: ff7606           push word ptr [bp + 6]
  07763A  08CA: ff76ee           push word ptr [bp - 0x12]
  07763D  08CD: ff76ec           push word ptr [bp - 0x14]
  077640  08D0: 9a600f1d0d       lcall 0xd1d, 0xf60
  077645  08D5: 8946fc           mov word ptr [bp - 4], ax
  077648  08D8: 8956fe           mov word ptr [bp - 2], dx
  07764B  08DB: 0bd2             or dx, dx
  07764D  08DD: 7c77             jl 0x956
  07764F  08DF: 7f04             jg 0x8e5
  077651  08E1: 0bc0             or ax, ax
  077653  08E3: 7471             je 0x956
  077655  08E5: 897ef0           mov word ptr [bp - 0x10], di
  077658  08E8: 8d46f2           lea ax, [bp - 0xe]
  07765B  08EB: 50               push ax
  07765C  08EC: 8b46fc           mov ax, word ptr [bp - 4]
  07765F  08EF: 8b56fe           mov dx, word ptr [bp - 2]
  077662  08F2: 2b46f4           sub ax, word ptr [bp - 0xc]
  077665  08F5: 1b56f6           sbb dx, word ptr [bp - 0xa]
  077668  08F8: 0bd2             or dx, dx
  07766A  08FA: 7c0a             jl 0x906
  07766C  08FC: 7f05             jg 0x903
  07766E  08FE: 3d00f0           cmp ax, 0xf000
  077671  0901: 7603             jbe 0x906
  077673  0903: b800f0           mov ax, 0xf000
  077676  0906: 8bf0             mov si, ax
  077678  0908: 56               push si
  077679  0909: ff760c           push word ptr [bp + 0xc]
  07767C  090C: ff760a           push word ptr [bp + 0xa]
  07767F  090F: 8a4507           mov al, byte ptr [di + 7]
  077682  0912: 98               cwde 
  077683  0913: 50               push ax
  077684  0914: 9a9d0e1d0d       lcall 0xd1d, 0xe9d
  077689  0919: 83c40a           add sp, 0xa
  07768C  091C: 0bc0             or ax, ax
  07768E  091E: 7536             jne 0x956
  077690  0920: 8b46f2           mov ax, word ptr [bp - 0xe]
  077693  0923: 2bd2             sub dx, dx
  077695  0925: 0146f4           add word ptr [bp - 0xc], ax
  077698  0928: 1156f6           adc word ptr [bp - 0xa], dx
  07769B  092B: 2bdb             sub bx, bx
  07769D  092D: 8bc8             mov cx, ax
  07769F  092F: 014e0a           add word ptr [bp + 0xa], cx
  0776A2  0932: 13da             adc bx, dx
  0776A4  0934: b90c00           mov cx, 0xc
  0776A7  0937: d3e3             shl bx, cl
  0776A9  0939: 015e0c           add word ptr [bp + 0xc], bx
  0776AC  093C: 8b46fc           mov ax, word ptr [bp - 4]
  0776AF  093F: 8b56fe           mov dx, word ptr [bp - 2]
  0776B2  0942: 2bc9             sub cx, cx
  0776B4  0944: 0176f8           add word ptr [bp - 8], si
  0776B7  0947: 114efa           adc word ptr [bp - 6], cx
  0776BA  094A: 3956fa           cmp word ptr [bp - 6], dx
  0776BD  094D: 7c99             jl 0x8e8
  0776BF  094F: 7f05             jg 0x956
  0776C1  0951: 3946f8           cmp word ptr [bp - 8], ax
  0776C4  0954: 7292             jb 0x8e8
  0776C6  0956: 8b46ec           mov ax, word ptr [bp - 0x14]
  0776C9  0959: 8b56ee           mov dx, word ptr [bp - 0x12]
  0776CC  095C: 3946f4           cmp word ptr [bp - 0xc], ax
  0776CF  095F: 750f             jne 0x970
  0776D1  0961: 3956f6           cmp word ptr [bp - 0xa], dx
  0776D4  0964: 750a             jne 0x970
  0776D6  0966: b80100           mov ax, 1
  0776D9  0969: 99               cdq 
  0776DA  096A: 5e               pop si
  0776DB  096B: 5f               pop di
  0776DC  096C: c9               leave 
  0776DD  096D: ca0800           retf 8
  0776E0  0970: 52               push dx
  0776E1  0971: 50               push ax
  0776E2  0972: ff76f6           push word ptr [bp - 0xa]
  0776E5  0975: ff76f4           push word ptr [bp - 0xc]
  0776E8  0978: 9ac60e1d0d       lcall 0xd1d, 0xec6
  0776ED  097D: 5e               pop si
  0776EE  097E: 5f               pop di
  0776EF  097F: c9               leave 
  0776F0  0980: ca0800           retf 8

; ---- func_0776F4  size=125  insns=50  prologue=ENTER 0x0002,0  terminal=RETF ----
  0776F4  0984: c8020000         enter 2, 0
  0776F8  0988: 57               push di
  0776F9  0989: 56               push si
  0776FA  098A: 2bf6             sub si, si
  0776FC  098C: 393632a6         cmp word ptr [0xa632], si
  077700  0990: 7c69             jl 0x9fb
  077702  0992: 7f06             jg 0x99a
  077704  0994: 393630a6         cmp word ptr [0xa630], si
  077708  0998: 7461             je 0x9fb
  07770A  099A: 0bf6             or si, si
  07770C  099C: 755d             jne 0x9fb
  07770E  099E: a126a6           mov ax, word ptr [0xa626]
  077711  09A1: 2bd2             sub dx, dx
  077713  09A3: 3b1632a6         cmp dx, word ptr [0xa632]
  077717  09A7: 7c0f             jl 0x9b8
  077719  09A9: 7f06             jg 0x9b1
  07771B  09AB: 3b0630a6         cmp ax, word ptr [0xa630]
  07771F  09AF: 7607             jbe 0x9b8
  077721  09B1: 8b1632a6         mov dx, word ptr [0xa632]
  077725  09B5: a130a6           mov ax, word ptr [0xa630]
  077728  09B8: 8946fe           mov word ptr [bp - 2], ax
  07772B  09BB: ff3624a6         push word ptr [0xa624]
  07772F  09BF: ff3622a6         push word ptr [0xa622]
  077733  09C3: 8d46fe           lea ax, [bp - 2]
  077736  09C6: 16               push ss
  077737  09C7: 50               push ax
  077738  09C8: ff1e44a6         lcall [0xa644]
  07773C  09CC: 8bf8             mov di, ax
  07773E  09CE: 3b7efe           cmp di, word ptr [bp - 2]
  077741  09D1: 7407             je 0x9da
  077743  09D3: be0400           mov si, 4
  077746  09D6: eb13             jmp 0x9eb
  077748  09D8: 90               nop 
  077749  09D9: 90               nop 
  07774A  09DA: ff3624a6         push word ptr [0xa624]
  07774E  09DE: ff3622a6         push word ptr [0xa622]
  077752  09E2: 8d46fe           lea ax, [bp - 2]
  077755  09E5: 16               push ss
  077756  09E6: 50               push ax
  077757  09E7: ff1e3aa6         lcall [0xa63a]
  07775B  09EB: 833e32a600       cmp word ptr [0xa632], 0
  077760  09F0: 7fa8             jg 0x99a
  077762  09F2: 7c07             jl 0x9fb
  077764  09F4: 833e30a600       cmp word ptr [0xa630], 0
  077769  09F9: 759f             jne 0x99a
  07776B  09FB: 8bc6             mov ax, si
  07776D  09FD: 5e               pop si
  07776E  09FE: 5f               pop di
  07776F  09FF: c9               leave 
  077770  0A00: cb               retf 

; ---- func_077772  size=255  insns=89  prologue=ENTER 0x0002,0  terminal=page-end ----
  077772  0A02: c8020000         enter 2, 0
  077776  0A06: 52               push dx
  077777  0A07: 50               push ax
  077778  0A08: 8bc8             mov cx, ax
  07777A  0A0A: 0bc0             or ax, ax
  07777C  0A0C: 740a             je 0xa18
  07777E  0A0E: 48               dec ax
  07777F  0A0F: 7463             je 0xa74
  077781  0A11: 0e               push cs
  077782  0A12: e8e700           call 0xafc
  077785  0A15: e9e200           jmp 0xafa
  077788  0A18: c746fe0010       mov word ptr [bp - 2], 0x1000
  07778D  0A1D: 833eca2601       cmp word ptr [0x26ca], 1
  077792  0A22: 7528             jne 0xa4c
  077794  0A24: ff3646a6         push word ptr [0xa646]
  077798  0A28: ff3644a6         push word ptr [0xa644]
  07779C  0A2C: ff363ca6         push word ptr [0xa63c]
  0777A0  0A30: ff363aa6         push word ptr [0xa63a]
  0777A4  0A34: ff3624a6         push word ptr [0xa624]
  0777A8  0A38: ff3622a6         push word ptr [0xa622]
  0777AC  0A3C: 1e               push ds
  0777AD  0A3D: 68c626           push 0x26c6
  0777B0  0A40: 8d46fe           lea ax, [bp - 2]
  0777B3  0A43: 16               push ss
  0777B4  0A44: 50               push ax
  0777B5  0A45: ff1ed426         lcall [0x26d4]
  0777B9  0A49: c9               leave 
  0777BA  0A4A: cb               retf 
  0777BB  0A4B: 90               nop 
  0777BC  0A4C: ff3646a6         push word ptr [0xa646]
  0777C0  0A50: ff3644a6         push word ptr [0xa644]
  0777C4  0A54: ff363ca6         push word ptr [0xa63c]
  0777C8  0A58: ff363aa6         push word ptr [0xa63a]
  0777CC  0A5C: ff3624a6         push word ptr [0xa624]
  0777D0  0A60: ff3622a6         push word ptr [0xa622]
  0777D4  0A64: 1e               push ds
  0777D5  0A65: 68c626           push 0x26c6
  0777D8  0A68: 8d46fe           lea ax, [bp - 2]
  0777DB  0A6B: 16               push ss
  0777DC  0A6C: 50               push ax
  0777DD  0A6D: ff1ecc26         lcall [0x26cc]
  0777E1  0A71: c9               leave 
  0777E2  0A72: cb               retf 
  0777E3  0A73: 90               nop 
  0777E4  0A74: 833eca2601       cmp word ptr [0x26ca], 1
  0777E9  0A79: 7563             jne 0xade
  0777EB  0A7B: 8bc2             mov ax, dx
  0777ED  0A7D: 48               dec ax
  0777EE  0A7E: 7422             je 0xaa2
  0777F0  0A80: 48               dec ax
  0777F1  0A81: 743d             je 0xac0
  0777F3  0A83: ff3646a6         push word ptr [0xa646]
  0777F7  0A87: ff3644a6         push word ptr [0xa644]
  0777FB  0A8B: ff363ca6         push word ptr [0xa63c]
  0777FF  0A8F: ff363aa6         push word ptr [0xa63a]
  077803  0A93: ff3624a6         push word ptr [0xa624]
  077807  0A97: ff3622a6         push word ptr [0xa622]
  07780B  0A9B: ff1ed826         lcall [0x26d8]
  07780F  0A9F: c9               leave 
  077810  0AA0: cb               retf 
  077811  0AA1: 90               nop 
  077812  0AA2: ff3646a6         push word ptr [0xa646]
  077816  0AA6: ff3644a6         push word ptr [0xa644]
  07781A  0AAA: ff3640a6         push word ptr [0xa640]
  07781E  0AAE: ff363ea6         push word ptr [0xa63e]
  077822  0AB2: ff3624a6         push word ptr [0xa624]
  077826  0AB6: ff3622a6         push word ptr [0xa622]
  07782A  0ABA: ff1edc26         lcall [0x26dc]
  07782E  0ABE: c9               leave 
  07782F  0ABF: cb               retf 
  077830  0AC0: ff364aa6         push word ptr [0xa64a]
  077834  0AC4: ff3648a6         push word ptr [0xa648]
  077838  0AC8: ff3640a6         push word ptr [0xa640]
  07783C  0ACC: ff363ea6         push word ptr [0xa63e]
  077840  0AD0: ff3624a6         push word ptr [0xa624]
  077844  0AD4: ff3622a6         push word ptr [0xa622]
  077848  0AD8: ff1ee026         lcall [0x26e0]
  07784C  0ADC: c9               leave 
  07784D  0ADD: cb               retf 
  07784E  0ADE: ff3646a6         push word ptr [0xa646]
  077852  0AE2: ff3644a6         push word ptr [0xa644]
  077856  0AE6: ff363ca6         push word ptr [0xa63c]
  07785A  0AEA: ff363aa6         push word ptr [0xa63a]
  07785E  0AEE: ff3624a6         push word ptr [0xa624]
  077862  0AF2: ff3622a6         push word ptr [0xa622]
  077866  0AF6: ff1ed026         lcall [0x26d0]
  07786A  0AFA: c9               leave 
  07786B  0AFB: cb               retf 
  07786C  0AFC: eae80f1f1a       ljmp 0x1a1f:0xfe8
