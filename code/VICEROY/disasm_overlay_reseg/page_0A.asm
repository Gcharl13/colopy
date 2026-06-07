; ============================================================
; VICEROY.EXE overlay page 0x0A (record 9) -- RE-SEGMENTED
; file_offset (disk image) = 0x044400
; code_offset (first insn) = 0x044540
; code_end (next reloc hdr)= 0x045C20  [resident size 366 para -> nominal_end 0x045AE0; on-disk code spills past it]
; reloc_count = 70  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x044400)
; functions in page = 24
; ============================================================

; ---- func_044540  size=21  insns=11  prologue=push bp;mov bp,sp  terminal=RET ----
  044540  0140: 55               push bp
  044541  0141: 8bec             mov bp, sp
  044543  0143: c45e04           les bx, ptr [bp + 4]
  044546  0146: 268a1f           mov bl, byte ptr es:[bx]
  044549  0149: 2aff             sub bh, bh
  04454B  014B: 83fb06           cmp bx, 6
  04454E  014E: 7501             jne 0x151
  044550  0150: 4b               dec bx
  044551  0151: 8bc3             mov ax, bx
  044553  0153: c9               leave 
  044554  0154: c3               ret 

; ---- func_044556  size=52  insns=18  prologue=push bp;mov bp,sp  terminal=RETF ----
  044556  0156: 55               push bp
  044557  0157: 8bec             mov bp, sp
  044559  0159: 8b5e06           mov bx, word ptr [bp + 6]
  04455C  015C: 8b460e           mov ax, word ptr [bp + 0xe]
  04455F  015F: 8e4608           mov es, word ptr [bp + 8]
  044562  0162: 268907           mov word ptr es:[bx], ax
  044565  0165: 8b4610           mov ax, word ptr [bp + 0x10]
  044568  0168: 26894702         mov word ptr es:[bx + 2], ax
  04456C  016C: 8b4612           mov ax, word ptr [bp + 0x12]
  04456F  016F: 26894704         mov word ptr es:[bx + 4], ax
  044573  0173: 8b4614           mov ax, word ptr [bp + 0x14]
  044576  0176: 26894706         mov word ptr es:[bx + 6], ax
  04457A  017A: 8b460a           mov ax, word ptr [bp + 0xa]
  04457D  017D: 8b560c           mov dx, word ptr [bp + 0xc]
  044580  0180: 26894708         mov word ptr es:[bx + 8], ax
  044584  0184: 2689570a         mov word ptr es:[bx + 0xa], dx
  044588  0188: c9               leave 
  044589  0189: cb               retf 

; ---- func_04458A  size=99  insns=37  prologue=push bp;mov bp,sp  terminal=RET imm16 ----
  04458A  018A: 55               push bp
  04458B  018B: 8bec             mov bp, sp
  04458D  018D: 50               push ax
  04458E  018E: 833eba1400       cmp word ptr [0x14ba], 0
  044593  0193: 7439             je 0x1ce
  044595  0195: 807e0a07         cmp byte ptr [bp + 0xa], 7
  044599  0199: 7533             jne 0x1ce
  04459B  019B: ff760e           push word ptr [bp + 0xe]
  04459E  019E: ff7610           push word ptr [bp + 0x10]
  0445A1  01A1: ff7612           push word ptr [bp + 0x12]
  0445A4  01A4: 53               push bx
  0445A5  01A5: 52               push dx
  0445A6  01A6: 50               push ax
  0445A7  01A7: 8b1eba14         mov bx, word ptr [0x14ba]
  0445AB  01AB: ff7706           push word ptr [bx + 6]
  0445AE  01AE: ff7704           push word ptr [bx + 4]
  0445B1  01B1: ff7702           push word ptr [bx + 2]
  0445B4  01B4: ff37             push word ptr [bx]
  0445B6  01B6: ff761a           push word ptr [bp + 0x1a]
  0445B9  01B9: ff7618           push word ptr [bp + 0x18]
  0445BC  01BC: ff7616           push word ptr [bp + 0x16]
  0445BF  01BF: ff7614           push word ptr [bp + 0x14]
  0445C2  01C2: 9ac4001f18       lcall 0x181f, 0xc4
  0445C7  01C7: 83c41c           add sp, 0x1c
  0445CA  01CA: c9               leave 
  0445CB  01CB: c21800           ret 0x18
  0445CE  01CE: ff761a           push word ptr [bp + 0x1a]
  0445D1  01D1: ff7618           push word ptr [bp + 0x18]
  0445D4  01D4: ff7616           push word ptr [bp + 0x16]
  0445D7  01D7: ff7614           push word ptr [bp + 0x14]
  0445DA  01DA: ff7612           push word ptr [bp + 0x12]
  0445DD  01DD: 8a460a           mov al, byte ptr [bp + 0xa]
  0445E0  01E0: 50               push ax
  0445E1  01E1: 8b46fe           mov ax, word ptr [bp - 2]
  0445E4  01E4: 9aba001f18       lcall 0x181f, 0xba
  0445E9  01E9: c9               leave 
  0445EA  01EA: c21800           ret 0x18

; ---- func_0445EE  size=86  insns=35  prologue=ENTER 0x0050,0  terminal=RETF ----
  0445EE  01EE: c8500000         enter 0x50, 0
  0445F2  01F2: 56               push si
  0445F3  01F3: ff760c           push word ptr [bp + 0xc]
  0445F6  01F6: ff760a           push word ptr [bp + 0xa]
  0445F9  01F9: 8d46b0           lea ax, [bp - 0x50]
  0445FC  01FC: 16               push ss
  0445FD  01FD: 50               push ax
  0445FE  01FE: 9a7e111d0d       lcall 0xd1d, 0x117e
  044603  0203: 83c408           add sp, 8
  044606  0206: 6a7e             push 0x7e
  044608  0208: 8d46b0           lea ax, [bp - 0x50]
  04460B  020B: 50               push ax
  04460C  020C: 9a560c1d0d       lcall 0xd1d, 0xc56
  044611  0211: 83c404           add sp, 4
  044614  0214: 8bf0             mov si, ax
  044616  0216: 0bf6             or si, si
  044618  0218: 740f             je 0x229
  04461A  021A: 8d4401           lea ax, [si + 1]
  04461D  021D: 1e               push ds
  04461E  021E: 50               push ax
  04461F  021F: 1e               push ds
  044620  0220: 56               push si
  044621  0221: 9a7e111d0d       lcall 0xd1d, 0x117e
  044626  0226: 83c408           add sp, 8
  044629  0229: c45e06           les bx, ptr [bp + 6]
  04462C  022C: 26ff770a         push word ptr es:[bx + 0xa]
  044630  0230: 26ff7708         push word ptr es:[bx + 8]
  044634  0234: 8d46b0           lea ax, [bp - 0x50]
  044637  0237: 16               push ss
  044638  0238: 50               push ax
  044639  0239: 268b07           mov ax, word ptr es:[bx]
  04463C  023C: 9a04021f18       lcall 0x181f, 0x204
  044641  0241: 5e               pop si
  044642  0242: c9               leave 
  044643  0243: cb               retf 

; ---- func_044644  size=313  insns=106  prologue=ENTER 0x000E,0  terminal=RETF ----
  044644  0244: c80e0000         enter 0xe, 0
  044648  0248: 57               push di
  044649  0249: 56               push si
  04464A  024A: 837e1200         cmp word ptr [bp + 0x12], 0
  04464E  024E: 744a             je 0x29a
  044650  0250: 8b7e06           mov di, word ptr [bp + 6]
  044653  0253: 8e4608           mov es, word ptr [bp + 8]
  044656  0256: 26ff7504         push word ptr es:[di + 4]
  04465A  025A: 268b5d04         mov bx, word ptr es:[di + 4]
  04465E  025E: 8bd3             mov dx, bx
  044660  0260: b8ffff           mov ax, 0xffff
  044663  0263: 8cc6             mov si, es
  044665  0265: 9af0011f18       lcall 0x181f, 0x1f0
  04466A  026A: 8ec6             mov es, si
  04466C  026C: 26ff750a         push word ptr es:[di + 0xa]
  044670  0270: 26ff7508         push word ptr es:[di + 8]
  044674  0274: ff760c           push word ptr [bp + 0xc]
  044677  0277: ff760a           push word ptr [bp + 0xa]
  04467A  027A: 26ff35           push word ptr es:[di]
  04467D  027D: 8d1ea82d         lea bx, [0x2da8]
  044681  0281: 8b460e           mov ax, word ptr [bp + 0xe]
  044684  0284: 8b5610           mov dx, word ptr [bp + 0x10]
  044687  0287: 8cc6             mov si, es
  044689  0289: 9afa011f18       lcall 0x181f, 0x1fa
  04468E  028E: 8ec6             mov es, si
  044690  0290: 260305           add ax, word ptr es:[di]
  044693  0293: 89460e           mov word ptr [bp + 0xe], ax
  044696  0296: e9dd00           jmp 0x376
  044699  0299: 90               nop 
  04469A  029A: 8b7606           mov si, word ptr [bp + 6]
  04469D  029D: c646fb00         mov byte ptr [bp - 5], 0
  0446A1  02A1: 8e4608           mov es, word ptr [bp + 8]
  0446A4  02A4: 26ff7402         push word ptr es:[si + 2]
  0446A8  02A8: 268b5402         mov dx, word ptr es:[si + 2]
  0446AC  02AC: 8bda             mov bx, dx
  0446AE  02AE: b8ffff           mov ax, 0xffff
  0446B1  02B1: 9af0011f18       lcall 0x181f, 0x1f0
  0446B6  02B6: c45e0a           les bx, ptr [bp + 0xa]
  0446B9  02B9: 8bfb             mov di, bx
  0446BB  02BB: 8c46fe           mov word ptr [bp - 2], es
  0446BE  02BE: 26803f00         cmp byte ptr es:[bx], 0
  0446C2  02C2: 7503             jne 0x2c7
  0446C4  02C4: e9af00           jmp 0x376
  0446C7  02C7: 26803d7e         cmp byte ptr es:[di], 0x7e
  0446CB  02CB: 7565             jne 0x332
  0446CD  02CD: 8e4608           mov es, word ptr [bp + 8]
  0446D0  02D0: 26ff7406         push word ptr es:[si + 6]
  0446D4  02D4: 268b5c06         mov bx, word ptr es:[si + 6]
  0446D8  02D8: 8bd3             mov dx, bx
  0446DA  02DA: b8ffff           mov ax, 0xffff
  0446DD  02DD: 8976f6           mov word ptr [bp - 0xa], si
  0446E0  02E0: 8c46f8           mov word ptr [bp - 8], es
  0446E3  02E3: 9af0011f18       lcall 0x181f, 0x1f0
  0446E8  02E8: 8e46fe           mov es, word ptr [bp - 2]
  0446EB  02EB: 47               inc di
  0446EC  02EC: 268a05           mov al, byte ptr es:[di]
  0446EF  02EF: 8846fa           mov byte ptr [bp - 6], al
  0446F2  02F2: c45ef6           les bx, ptr [bp - 0xa]
  0446F5  02F5: 26ff770a         push word ptr es:[bx + 0xa]
  0446F9  02F9: 26ff7708         push word ptr es:[bx + 8]
  0446FD  02FD: 8d46fa           lea ax, [bp - 6]
  044700  0300: 16               push ss
  044701  0301: 50               push ax
  044702  0302: 26ff37           push word ptr es:[bx]
  044705  0305: 8d1ea82d         lea bx, [0x2da8]
  044709  0309: 8b460e           mov ax, word ptr [bp + 0xe]
  04470C  030C: 8b5610           mov dx, word ptr [bp + 0x10]
  04470F  030F: 9afa011f18       lcall 0x181f, 0x1fa
  044714  0314: c45ef6           les bx, ptr [bp - 0xa]
  044717  0317: 260307           add ax, word ptr es:[bx]
  04471A  031A: 89460e           mov word ptr [bp + 0xe], ax
  04471D  031D: 26ff7702         push word ptr es:[bx + 2]
  044721  0321: 268b5f02         mov bx, word ptr es:[bx + 2]
  044725  0325: 8bd3             mov dx, bx
  044727  0327: b8ffff           mov ax, 0xffff
  04472A  032A: 9af0011f18       lcall 0x181f, 0x1f0
  04472F  032F: eb38             jmp 0x369
  044731  0331: 90               nop 
  044732  0332: 268a05           mov al, byte ptr es:[di]
  044735  0335: 8846fa           mov byte ptr [bp - 6], al
  044738  0338: 8e4608           mov es, word ptr [bp + 8]
  04473B  033B: 26ff740a         push word ptr es:[si + 0xa]
  04473F  033F: 26ff7408         push word ptr es:[si + 8]
  044743  0343: 8d46fa           lea ax, [bp - 6]
  044746  0346: 16               push ss
  044747  0347: 50               push ax
  044748  0348: 26ff34           push word ptr es:[si]
  04474B  034B: 8d1ea82d         lea bx, [0x2da8]
  04474F  034F: 8b460e           mov ax, word ptr [bp + 0xe]
  044752  0352: 8b5610           mov dx, word ptr [bp + 0x10]
  044755  0355: 8976f2           mov word ptr [bp - 0xe], si
  044758  0358: 8c46f4           mov word ptr [bp - 0xc], es
  04475B  035B: 9afa011f18       lcall 0x181f, 0x1fa
  044760  0360: c45ef2           les bx, ptr [bp - 0xe]
  044763  0363: 260307           add ax, word ptr es:[bx]
  044766  0366: 89460e           mov word ptr [bp + 0xe], ax
  044769  0369: 8e46fe           mov es, word ptr [bp - 2]
  04476C  036C: 47               inc di
  04476D  036D: 26803d00         cmp byte ptr es:[di], 0
  044771  0371: 7403             je 0x376
  044773  0373: e951ff           jmp 0x2c7
  044776  0376: 8b460e           mov ax, word ptr [bp + 0xe]
  044779  0379: 5e               pop si
  04477A  037A: 5f               pop di
  04477B  037B: c9               leave 
  04477C  037C: cb               retf 

; ---- func_04477E  size=183  insns=71  prologue=ENTER 0x000C,0  terminal=RETF ----
  04477E  037E: c80c0000         enter 0xc, 0
  044782  0382: 57               push di
  044783  0383: 56               push si
  044784  0384: c746f60000       mov word ptr [bp - 0xa], 0
  044789  0389: 6a7e             push 0x7e
  04478B  038B: ff7608           push word ptr [bp + 8]
  04478E  038E: ff7606           push word ptr [bp + 6]
  044791  0391: 9aea101d0d       lcall 0xd1d, 0x10ea
  044796  0396: 83c406           add sp, 6
  044799  0399: 8bf0             mov si, ax
  04479B  039B: 8956fe           mov word ptr [bp - 2], dx
  04479E  039E: 6a7e             push 0x7e
  0447A0  03A0: ff7608           push word ptr [bp + 8]
  0447A3  03A3: ff7606           push word ptr [bp + 6]
  0447A6  03A6: 9a10101d0d       lcall 0xd1d, 0x1010
  0447AB  03AB: 83c406           add sp, 6
  0447AE  03AE: 8bf8             mov di, ax
  0447B0  03B0: 8b4efe           mov cx, word ptr [bp - 2]
  0447B3  03B3: 3bc6             cmp ax, si
  0447B5  03B5: 7504             jne 0x3bb
  0447B7  03B7: 3bd1             cmp dx, cx
  0447B9  03B9: 7447             je 0x402
  0447BB  03BB: 8eda             mov ds, dx
  0447BD  03BD: 807d0146         cmp byte ptr [di + 1], 0x46
  0447C1  03C1: 753f             jne 0x402
  0447C3  03C3: 8e46fe           mov es, word ptr [bp - 2]
  0447C6  03C6: 268a5c01         mov bl, byte ptr es:[si + 1]
  0447CA  03CA: 2aff             sub bh, bh
  0447CC  03CC: 36f687ed2704     test byte ptr ss:[bx + 0x27ed], 4
  0447D2  03D2: 742e             je 0x402
  0447D4  03D4: b93b01           mov cx, 0x13b
  0447D7  03D7: 83c703           add di, 3
  0447DA  03DA: 803d30           cmp byte ptr [di], 0x30
  0447DD  03DD: 750c             jne 0x3eb
  0447DF  03DF: b95401           mov cx, 0x154
  0447E2  03E2: 807d0230         cmp byte ptr [di + 2], 0x30
  0447E6  03E6: 7503             jne 0x3eb
  0447E8  03E8: b95e01           mov cx, 0x15e
  0447EB  03EB: 26807cff31       cmp byte ptr es:[si - 1], 0x31
  0447F0  03F0: 7506             jne 0x3f8
  0447F2  03F2: 83c109           add cx, 9
  0447F5  03F5: eb33             jmp 0x42a
  0447F7  03F7: 90               nop 
  0447F8  03F8: 8bc3             mov ax, bx
  0447FA  03FA: 2d3100           sub ax, 0x31
  0447FD  03FD: 03c8             add cx, ax
  0447FF  03FF: eb29             jmp 0x42a
  044801  0401: 90               nop 
  044802  0402: 8b46fe           mov ax, word ptr [bp - 2]
  044805  0405: 0bc6             or ax, si
  044807  0407: 7419             je 0x422
  044809  0409: 8e46fe           mov es, word ptr [bp - 2]
  04480C  040C: 268a5c01         mov bl, byte ptr es:[si + 1]
  044810  0410: 2aff             sub bh, bh
  044812  0412: 36f687ed2702     test byte ptr ss:[bx + 0x27ed], 2
  044818  0418: 740e             je 0x428
  04481A  041A: 8bcb             mov cx, bx
  04481C  041C: 83e920           sub cx, 0x20
  04481F  041F: eb09             jmp 0x42a
  044821  0421: 90               nop 
  044822  0422: 8b4ef6           mov cx, word ptr [bp - 0xa]
  044825  0425: eb03             jmp 0x42a
  044827  0427: 90               nop 
  044828  0428: 8bcb             mov cx, bx
  04482A  042A: 8bc1             mov ax, cx
  04482C  042C: b95a1b           mov cx, 0x1b5a
  04482F  042F: 8ed9             mov ds, cx
  044831  0431: 5e               pop si
  044832  0432: 5f               pop di
  044833  0433: c9               leave 
  044834  0434: cb               retf 

; ---- func_044836  size=328  insns=117  prologue=ENTER 0x0020,0  terminal=RETF ----
  044836  0436: c8200000         enter 0x20, 0
  04483A  043A: 57               push di
  04483B  043B: 56               push si
  04483C  043C: 2bc0             sub ax, ax
  04483E  043E: 8946f6           mov word ptr [bp - 0xa], ax
  044841  0441: 8946f4           mov word ptr [bp - 0xc], ax
  044844  0444: 8b4606           mov ax, word ptr [bp + 6]
  044847  0447: 054e00           add ax, 0x4e
  04484A  044A: 99               cdq 
  04484B  044B: 9a9a021f18       lcall 0x181f, 0x29a
  044850  0450: 8bf8             mov di, ax
  044852  0452: 8956f2           mov word ptr [bp - 0xe], dx
  044855  0455: 0bd0             or dx, ax
  044857  0457: 7503             jne 0x45c
  044859  0459: e9fd00           jmp 0x559
  04485C  045C: 8b46f2           mov ax, word ptr [bp - 0xe]
  04485F  045F: 8bcf             mov cx, di
  044861  0461: 8bd8             mov bx, ax
  044863  0463: 8bf1             mov si, cx
  044865  0465: 8946fe           mov word ptr [bp - 2], ax
  044868  0468: 894eec           mov word ptr [bp - 0x14], cx
  04486B  046B: 895eee           mov word ptr [bp - 0x12], bx
  04486E  046E: 83c13c           add cx, 0x3c
  044871  0471: 53               push bx
  044872  0472: 51               push cx
  044873  0473: 8b46ec           mov ax, word ptr [bp - 0x14]
  044876  0476: 8bd3             mov dx, bx
  044878  0478: 054e00           add ax, 0x4e
  04487B  047B: 52               push dx
  04487C  047C: 50               push ax
  04487D  047D: 8b4606           mov ax, word ptr [bp + 6]
  044880  0480: 99               cdq 
  044881  0481: 52               push dx
  044882  0482: 50               push ax
  044883  0483: b82800           mov ax, 0x28
  044886  0486: 9a56031f1a       lcall 0x1a1f, 0x356
  04488B  048B: c45eec           les bx, ptr [bp - 0x14]
  04488E  048E: 2bc0             sub ax, ax
  044890  0490: 2689473a         mov word ptr es:[bx + 0x3a], ax
  044894  0494: 26894738         mov word ptr es:[bx + 0x38], ax
  044898  0498: 26894702         mov word ptr es:[bx + 2], ax
  04489C  049C: 26c747060c00     mov word ptr es:[bx + 6], 0xc
  0448A2  04A2: 26c747080300     mov word ptr es:[bx + 8], 3
  0448A8  04A8: 26c7470c0400     mov word ptr es:[bx + 0xc], 4
  0448AE  04AE: b80100           mov ax, 1
  0448B1  04B1: 26894704         mov word ptr es:[bx + 4], ax
  0448B5  04B5: 2689470a         mov word ptr es:[bx + 0xa], ax
  0448B9  04B9: a19c14           mov ax, word ptr [0x149c]
  0448BC  04BC: 8e46fe           mov es, word ptr [bp - 2]
  0448BF  04BF: 2689440e         mov word ptr es:[si + 0xe], ax
  0448C3  04C3: a19e14           mov ax, word ptr [0x149e]
  0448C6  04C6: 26894410         mov word ptr es:[si + 0x10], ax
  0448CA  04CA: ff36b814         push word ptr [0x14b8]
  0448CE  04CE: ff36b614         push word ptr [0x14b6]
  0448D2  04D2: ff36b414         push word ptr [0x14b4]
  0448D6  04D6: 6a00             push 0
  0448D8  04D8: ff760a           push word ptr [bp + 0xa]
  0448DB  04DB: ff7608           push word ptr [bp + 8]
  0448DE  04DE: 8d4420           lea ax, [si + 0x20]
  0448E1  04E1: 06               push es
  0448E2  04E2: 50               push ax
  0448E3  04E3: 8976e4           mov word ptr [bp - 0x1c], si
  0448E6  04E6: 8c46e6           mov word ptr [bp - 0x1a], es
  0448E9  04E9: 0e               push cs
  0448EA  04EA: e80513           call 0x17f2
  0448ED  04ED: 83c410           add sp, 0x10
  0448F0  04F0: a1a814           mov ax, word ptr [0x14a8]
  0448F3  04F3: c45ee4           les bx, ptr [bp - 0x1c]
  0448F6  04F6: 2689471a         mov word ptr es:[bx + 0x1a], ax
  0448FA  04FA: a1aa14           mov ax, word ptr [0x14aa]
  0448FD  04FD: 2689471c         mov word ptr es:[bx + 0x1c], ax
  044901  0501: a1a014           mov ax, word ptr [0x14a0]
  044904  0504: 8e46fe           mov es, word ptr [bp - 2]
  044907  0507: 26894412         mov word ptr es:[si + 0x12], ax
  04490B  050B: a1a214           mov ax, word ptr [0x14a2]
  04490E  050E: 26894414         mov word ptr es:[si + 0x14], ax
  044912  0512: a1a414           mov ax, word ptr [0x14a4]
  044915  0515: 26894416         mov word ptr es:[si + 0x16], ax
  044919  0519: a1a614           mov ax, word ptr [0x14a6]
  04491C  051C: 26894418         mov word ptr es:[si + 0x18], ax
  044920  0520: a1ac14           mov ax, word ptr [0x14ac]
  044923  0523: 2689441e         mov word ptr es:[si + 0x1e], ax
  044927  0527: ff36b214         push word ptr [0x14b2]
  04492B  052B: ff36b014         push word ptr [0x14b0]
  04492F  052F: ff36ae14         push word ptr [0x14ae]
  044933  0533: 6a00             push 0
  044935  0535: ff760a           push word ptr [bp + 0xa]
  044938  0538: ff7608           push word ptr [bp + 8]
  04493B  053B: 8d442c           lea ax, [si + 0x2c]
  04493E  053E: 06               push es
  04493F  053F: 50               push ax
  044940  0540: 8976e0           mov word ptr [bp - 0x20], si
  044943  0543: 8c46e2           mov word ptr [bp - 0x1e], es
  044946  0546: 0e               push cs
  044947  0547: e8a812           call 0x17f2
  04494A  054A: 83c410           add sp, 0x10
  04494D  054D: 8b46e0           mov ax, word ptr [bp - 0x20]
  044950  0550: 8b56e2           mov dx, word ptr [bp - 0x1e]
  044953  0553: 8946f4           mov word ptr [bp - 0xc], ax
  044956  0556: 8956f6           mov word ptr [bp - 0xa], dx
  044959  0559: 8b46f2           mov ax, word ptr [bp - 0xe]
  04495C  055C: 0bc7             or ax, di
  04495E  055E: 7414             je 0x574
  044960  0560: 8b46f2           mov ax, word ptr [bp - 0xe]
  044963  0563: 3b7ef4           cmp di, word ptr [bp - 0xc]
  044966  0566: 7505             jne 0x56d
  044968  0568: 3b46f6           cmp ax, word ptr [bp - 0xa]
  04496B  056B: 7407             je 0x574
  04496D  056D: 50               push ax
  04496E  056E: 57               push di
  04496F  056F: 9aa8011f19       lcall 0x191f, 0x1a8
  044974  0574: 8b46f4           mov ax, word ptr [bp - 0xc]
  044977  0577: 8b56f6           mov dx, word ptr [bp - 0xa]
  04497A  057A: 5e               pop si
  04497B  057B: 5f               pop di
  04497C  057C: c9               leave 
  04497D  057D: cb               retf 

; ---- func_04497E  size=69  insns=32  prologue=ENTER 0x0004,0  terminal=RETF ----
  04497E  057E: c8040000         enter 4, 0
  044982  0582: 57               push di
  044983  0583: 56               push si
  044984  0584: 2bc9             sub cx, cx
  044986  0586: 2bc0             sub ax, ax
  044988  0588: 99               cdq 
  044989  0589: 8bf8             mov di, ax
  04498B  058B: 8956fe           mov word ptr [bp - 2], dx
  04498E  058E: c47606           les si, ptr [bp + 6]
  044991  0591: 26c55c38         lds bx, ptr es:[si + 0x38]
  044995  0595: 8cd8             mov ax, ds
  044997  0597: 0bc3             or ax, bx
  044999  0599: 741a             je 0x5b5
  04499B  059B: 8b460a           mov ax, word ptr [bp + 0xa]
  04499E  059E: 39470a           cmp word ptr [bx + 0xa], ax
  0449A1  05A1: 750b             jne 0x5ae
  0449A3  05A3: b90100           mov cx, 1
  0449A6  05A6: 8bfb             mov di, bx
  0449A8  05A8: 8c5efe           mov word ptr [bp - 2], ds
  0449AB  05AB: eb04             jmp 0x5b1
  0449AD  05AD: 90               nop 
  0449AE  05AE: c55f16           lds bx, ptr [bx + 0x16]
  0449B1  05B1: 0bc9             or cx, cx
  0449B3  05B3: 74e0             je 0x595
  0449B5  05B5: b85a1b           mov ax, 0x1b5a
  0449B8  05B8: 8ed8             mov ds, ax
  0449BA  05BA: 8bc7             mov ax, di
  0449BC  05BC: 8b56fe           mov dx, word ptr [bp - 2]
  0449BF  05BF: 5e               pop si
  0449C0  05C0: 5f               pop di
  0449C1  05C1: c9               leave 
  0449C2  05C2: cb               retf 

; ---- func_0449C4  size=149  insns=58  prologue=ENTER 0x0018,0  terminal=RETF ----
  0449C4  05C4: c8180000         enter 0x18, 0
  0449C8  05C8: 57               push di
  0449C9  05C9: 56               push si
  0449CA  05CA: 2bc9             sub cx, cx
  0449CC  05CC: 2bc0             sub ax, ax
  0449CE  05CE: 8946ea           mov word ptr [bp - 0x16], ax
  0449D1  05D1: 8946e8           mov word ptr [bp - 0x18], ax
  0449D4  05D4: c47606           les si, ptr [bp + 6]
  0449D7  05D7: 268b4438         mov ax, word ptr es:[si + 0x38]
  0449DB  05DB: 268b543a         mov dx, word ptr es:[si + 0x3a]
  0449DF  05DF: 8bd8             mov bx, ax
  0449E1  05E1: 8956f2           mov word ptr [bp - 0xe], dx
  0449E4  05E4: 8bc2             mov ax, dx
  0449E6  05E6: 0bc3             or ax, bx
  0449E8  05E8: 7465             je 0x64f
  0449EA  05EA: 8ec2             mov es, dx
  0449EC  05EC: 268b471e         mov ax, word ptr es:[bx + 0x1e]
  0449F0  05F0: 268b5720         mov dx, word ptr es:[bx + 0x20]
  0449F4  05F4: 8bf8             mov di, ax
  0449F6  05F6: 8956fa           mov word ptr [bp - 6], dx
  0449F9  05F9: 0bc9             or cx, cx
  0449FB  05FB: 753e             jne 0x63b
  0449FD  05FD: 895ef0           mov word ptr [bp - 0x10], bx
  044A00  0600: 8bf0             mov si, ax
  044A02  0602: 8b5ee8           mov bx, word ptr [bp - 0x18]
  044A05  0605: 8b46fa           mov ax, word ptr [bp - 6]
  044A08  0608: 0bc6             or ax, si
  044A0A  060A: 7429             je 0x635
  044A0C  060C: 8b460a           mov ax, word ptr [bp + 0xa]
  044A0F  060F: 8e46fa           mov es, word ptr [bp - 6]
  044A12  0612: 26394404         cmp word ptr es:[si + 4], ax
  044A16  0616: 750c             jne 0x624
  044A18  0618: b90100           mov cx, 1
  044A1B  061B: 8cc0             mov ax, es
  044A1D  061D: 8bde             mov bx, si
  044A1F  061F: 8946ea           mov word ptr [bp - 0x16], ax
  044A22  0622: eb0d             jmp 0x631
  044A24  0624: 268b440e         mov ax, word ptr es:[si + 0xe]
  044A28  0628: 268b5410         mov dx, word ptr es:[si + 0x10]
  044A2C  062C: 8bf0             mov si, ax
  044A2E  062E: 8956fa           mov word ptr [bp - 6], dx
  044A31  0631: 0bc9             or cx, cx
  044A33  0633: 74d0             je 0x605
  044A35  0635: 895ee8           mov word ptr [bp - 0x18], bx
  044A38  0638: 8b5ef0           mov bx, word ptr [bp - 0x10]
  044A3B  063B: 8e46f2           mov es, word ptr [bp - 0xe]
  044A3E  063E: 268b4716         mov ax, word ptr es:[bx + 0x16]
  044A42  0642: 268b5718         mov dx, word ptr es:[bx + 0x18]
  044A46  0646: 8bd8             mov bx, ax
  044A48  0648: 8956f2           mov word ptr [bp - 0xe], dx
  044A4B  064B: 0bc9             or cx, cx
  044A4D  064D: 7495             je 0x5e4
  044A4F  064F: 8b46e8           mov ax, word ptr [bp - 0x18]
  044A52  0652: 8b56ea           mov dx, word ptr [bp - 0x16]
  044A55  0655: 5e               pop si
  044A56  0656: 5f               pop di
  044A57  0657: c9               leave 
  044A58  0658: cb               retf 

; ---- func_044A5A  size=56  insns=24  prologue=ENTER 0x0004,0  terminal=RETF ----
  044A5A  065A: c8040000         enter 4, 0
  044A5E  065E: 56               push si
  044A5F  065F: ff760a           push word ptr [bp + 0xa]
  044A62  0662: ff7608           push word ptr [bp + 8]
  044A65  0665: ff7606           push word ptr [bp + 6]
  044A68  0668: 0e               push cs
  044A69  0669: e89011           call 0x17fc
  044A6C  066C: 83c406           add sp, 6
  044A6F  066F: 8bf0             mov si, ax
  044A71  0671: 8956fe           mov word ptr [bp - 2], dx
  044A74  0674: 0bd0             or dx, ax
  044A76  0676: 7417             je 0x68f
  044A78  0678: 8e46fe           mov es, word ptr [bp - 2]
  044A7B  067B: 837e0c00         cmp word ptr [bp + 0xc], 0
  044A7F  067F: 7409             je 0x68a
  044A81  0681: 26804c0c01       or byte ptr es:[si + 0xc], 1
  044A86  0686: 5e               pop si
  044A87  0687: c9               leave 
  044A88  0688: cb               retf 
  044A89  0689: 90               nop 
  044A8A  068A: 2680640cfe       and byte ptr es:[si + 0xc], 0xfe
  044A8F  068F: 5e               pop si
  044A90  0690: c9               leave 
  044A91  0691: cb               retf 

; ---- func_044A92  size=47  insns=21  prologue=ENTER 0x0004,0  terminal=RETF ----
  044A92  0692: c8040000         enter 4, 0
  044A96  0696: 56               push si
  044A97  0697: ff760a           push word ptr [bp + 0xa]
  044A9A  069A: ff7608           push word ptr [bp + 8]
  044A9D  069D: ff7606           push word ptr [bp + 6]
  044AA0  06A0: 0e               push cs
  044AA1  06A1: e85d11           call 0x1801
  044AA4  06A4: 83c406           add sp, 6
  044AA7  06A7: 8bf0             mov si, ax
  044AA9  06A9: 837e0c00         cmp word ptr [bp + 0xc], 0
  044AAD  06AD: 7409             je 0x6b8
  044AAF  06AF: 8ec2             mov es, dx
  044AB1  06B1: 26800c01         or byte ptr es:[si], 1
  044AB5  06B5: 5e               pop si
  044AB6  06B6: c9               leave 
  044AB7  06B7: cb               retf 
  044AB8  06B8: 8ec2             mov es, dx
  044ABA  06BA: 268024fe         and byte ptr es:[si], 0xfe
  044ABE  06BE: 5e               pop si
  044ABF  06BF: c9               leave 
  044AC0  06C0: cb               retf 

; ---- func_044AC2  size=68  insns=28  prologue=ENTER 0x0008,0  terminal=RETF ----
  044AC2  06C2: c8080000         enter 8, 0
  044AC6  06C6: 57               push di
  044AC7  06C7: c45e06           les bx, ptr [bp + 6]
  044ACA  06CA: 268b4738         mov ax, word ptr es:[bx + 0x38]
  044ACE  06CE: 268b573a         mov dx, word ptr es:[bx + 0x3a]
  044AD2  06D2: 8bf8             mov di, ax
  044AD4  06D4: 8956fa           mov word ptr [bp - 6], dx
  044AD7  06D7: 0bd0             or dx, ax
  044AD9  06D9: 7428             je 0x703
  044ADB  06DB: 8e46fa           mov es, word ptr [bp - 6]
  044ADE  06DE: 26c55d1e         lds bx, ptr es:[di + 0x1e]
  044AE2  06E2: 8cd8             mov ax, ds
  044AE4  06E4: 0bc3             or ax, bx
  044AE6  06E6: 740c             je 0x6f4
  044AE8  06E8: 8027fe           and byte ptr [bx], 0xfe
  044AEB  06EB: c55f0e           lds bx, ptr [bx + 0xe]
  044AEE  06EE: 8cd8             mov ax, ds
  044AF0  06F0: 0bc3             or ax, bx
  044AF2  06F2: 75f4             jne 0x6e8
  044AF4  06F4: b85a1b           mov ax, 0x1b5a
  044AF7  06F7: 8ed8             mov ds, ax
  044AF9  06F9: 26c47d16         les di, ptr es:[di + 0x16]
  044AFD  06FD: 8cc0             mov ax, es
  044AFF  06FF: 0bc7             or ax, di
  044B01  0701: 75db             jne 0x6de
  044B03  0703: 5f               pop di
  044B04  0704: c9               leave 
  044B05  0705: cb               retf 

; ---- func_044B06  size=47  insns=21  prologue=ENTER 0x0004,0  terminal=RETF ----
  044B06  0706: c8040000         enter 4, 0
  044B0A  070A: 56               push si
  044B0B  070B: ff760a           push word ptr [bp + 0xa]
  044B0E  070E: ff7608           push word ptr [bp + 8]
  044B11  0711: ff7606           push word ptr [bp + 6]
  044B14  0714: 0e               push cs
  044B15  0715: e8e910           call 0x1801
  044B18  0718: 83c406           add sp, 6
  044B1B  071B: 8bf0             mov si, ax
  044B1D  071D: 837e0c00         cmp word ptr [bp + 0xc], 0
  044B21  0721: 7409             je 0x72c
  044B23  0723: 8ec2             mov es, dx
  044B25  0725: 26800c02         or byte ptr es:[si], 2
  044B29  0729: 5e               pop si
  044B2A  072A: c9               leave 
  044B2B  072B: cb               retf 
  044B2C  072C: 8ec2             mov es, dx
  044B2E  072E: 268024fd         and byte ptr es:[si], 0xfd
  044B32  0732: 5e               pop si
  044B33  0733: c9               leave 
  044B34  0734: cb               retf 

; ---- func_044B36  size=68  insns=28  prologue=ENTER 0x0008,0  terminal=RETF ----
  044B36  0736: c8080000         enter 8, 0
  044B3A  073A: 57               push di
  044B3B  073B: c45e06           les bx, ptr [bp + 6]
  044B3E  073E: 268b4738         mov ax, word ptr es:[bx + 0x38]
  044B42  0742: 268b573a         mov dx, word ptr es:[bx + 0x3a]
  044B46  0746: 8bf8             mov di, ax
  044B48  0748: 8956fa           mov word ptr [bp - 6], dx
  044B4B  074B: 0bd0             or dx, ax
  044B4D  074D: 7428             je 0x777
  044B4F  074F: 8e46fa           mov es, word ptr [bp - 6]
  044B52  0752: 26c55d1e         lds bx, ptr es:[di + 0x1e]
  044B56  0756: 8cd8             mov ax, ds
  044B58  0758: 0bc3             or ax, bx
  044B5A  075A: 740c             je 0x768
  044B5C  075C: 8027fd           and byte ptr [bx], 0xfd
  044B5F  075F: c55f0e           lds bx, ptr [bx + 0xe]
  044B62  0762: 8cd8             mov ax, ds
  044B64  0764: 0bc3             or ax, bx
  044B66  0766: 75f4             jne 0x75c
  044B68  0768: b85a1b           mov ax, 0x1b5a
  044B6B  076B: 8ed8             mov ds, ax
  044B6D  076D: 26c47d16         les di, ptr es:[di + 0x16]
  044B71  0771: 8cc0             mov ax, es
  044B73  0773: 0bc7             or ax, di
  044B75  0775: 75db             jne 0x752
  044B77  0777: 5f               pop di
  044B78  0778: c9               leave 
  044B79  0779: cb               retf 

; ---- func_044B7A  size=411  insns=146  prologue=ENTER 0x0016,0  terminal=RETF ----
  044B7A  077A: c8160000         enter 0x16, 0
  044B7E  077E: 57               push di
  044B7F  077F: 56               push si
  044B80  0780: c746fa0000       mov word ptr [bp - 6], 0
  044B85  0785: c45e06           les bx, ptr [bp + 6]
  044B88  0788: 268b4738         mov ax, word ptr es:[bx + 0x38]
  044B8C  078C: 268b573a         mov dx, word ptr es:[bx + 0x3a]
  044B90  0790: 8bf8             mov di, ax
  044B92  0792: 8956f4           mov word ptr [bp - 0xc], dx
  044B95  0795: 8bc8             mov cx, ax
  044B97  0797: 8bf2             mov si, dx
  044B99  0799: 8bd8             mov bx, ax
  044B9B  079B: 8956f8           mov word ptr [bp - 8], dx
  044B9E  079E: 0bf1             or si, cx
  044BA0  07A0: 745c             je 0x7fe
  044BA2  07A2: 8eda             mov ds, dx
  044BA4  07A4: 8b4f02           mov cx, word ptr [bx + 2]
  044BA7  07A7: 034f04           add cx, word ptr [bx + 4]
  044BAA  07AA: 8cd8             mov ax, ds
  044BAC  07AC: 8bfb             mov di, bx
  044BAE  07AE: 8ec0             mov es, ax
  044BB0  07B0: c55f16           lds bx, ptr [bx + 0x16]
  044BB3  07B3: 8cd8             mov ax, ds
  044BB5  07B5: 0bc3             or ax, bx
  044BB7  07B7: 75eb             jne 0x7a4
  044BB9  07B9: 8c46f4           mov word ptr [bp - 0xc], es
  044BBC  07BC: 894efa           mov word ptr [bp - 6], cx
  044BBF  07BF: 897ef2           mov word ptr [bp - 0xe], di
  044BC2  07C2: b85a1b           mov ax, 0x1b5a
  044BC5  07C5: 8ed8             mov ds, ax
  044BC7  07C7: 8b7e06           mov di, word ptr [bp + 6]
  044BCA  07CA: 8e4608           mov es, word ptr [bp + 8]
  044BCD  07CD: 268b4506         mov ax, word ptr es:[di + 6]
  044BD1  07D1: 0146fa           add word ptr [bp - 6], ax
  044BD4  07D4: 8d453c           lea ax, [di + 0x3c]
  044BD7  07D7: 06               push es
  044BD8  07D8: 50               push ax
  044BD9  07D9: b82200           mov ax, 0x22
  044BDC  07DC: 99               cdq 
  044BDD  07DD: 9a2c001f18       lcall 0x181f, 0x2c
  044BE2  07E2: 8bf0             mov si, ax
  044BE4  07E4: 8956f8           mov word ptr [bp - 8], dx
  044BE7  07E7: 8b46f4           mov ax, word ptr [bp - 0xc]
  044BEA  07EA: 0b46f2           or ax, word ptr [bp - 0xe]
  044BED  07ED: 7415             je 0x804
  044BEF  07EF: 8bc2             mov ax, dx
  044BF1  07F1: c45ef2           les bx, ptr [bp - 0xe]
  044BF4  07F4: 26897716         mov word ptr es:[bx + 0x16], si
  044BF8  07F8: 26894718         mov word ptr es:[bx + 0x18], ax
  044BFC  07FC: eb13             jmp 0x811
  044BFE  07FE: 897ef2           mov word ptr [bp - 0xe], di
  044C01  0801: ebc4             jmp 0x7c7
  044C03  0803: 90               nop 
  044C04  0804: 8bc2             mov ax, dx
  044C06  0806: 8e4608           mov es, word ptr [bp + 8]
  044C09  0809: 26897538         mov word ptr es:[di + 0x38], si
  044C0D  080D: 2689453a         mov word ptr es:[di + 0x3a], ax
  044C11  0811: 8b46f2           mov ax, word ptr [bp - 0xe]
  044C14  0814: 8b56f4           mov dx, word ptr [bp - 0xc]
  044C17  0817: 8e46f8           mov es, word ptr [bp - 8]
  044C1A  081A: 2689441a         mov word ptr es:[si + 0x1a], ax
  044C1E  081E: 2689541c         mov word ptr es:[si + 0x1c], dx
  044C22  0822: 2bc0             sub ax, ax
  044C24  0824: 26894418         mov word ptr es:[si + 0x18], ax
  044C28  0828: 26894416         mov word ptr es:[si + 0x16], ax
  044C2C  082C: 26894420         mov word ptr es:[si + 0x20], ax
  044C30  0830: 2689441e         mov word ptr es:[si + 0x1e], ax
  044C34  0834: 268904           mov word ptr es:[si], ax
  044C37  0837: ff760c           push word ptr [bp + 0xc]
  044C3A  083A: ff760a           push word ptr [bp + 0xa]
  044C3D  083D: 8bc7             mov ax, di
  044C3F  083F: 8b5608           mov dx, word ptr [bp + 8]
  044C42  0842: 8bc8             mov cx, ax
  044C44  0844: 8bda             mov bx, dx
  044C46  0846: 053c00           add ax, 0x3c
  044C49  0849: 52               push dx
  044C4A  084A: 50               push ax
  044C4B  084B: ff760c           push word ptr [bp + 0xc]
  044C4E  084E: ff760a           push word ptr [bp + 0xa]
  044C51  0851: 894eee           mov word ptr [bp - 0x12], cx
  044C54  0854: 895ef0           mov word ptr [bp - 0x10], bx
  044C57  0857: 8976ea           mov word ptr [bp - 0x16], si
  044C5A  085A: 8c46ec           mov word ptr [bp - 0x14], es
  044C5D  085D: 9a3c111d0d       lcall 0xd1d, 0x113c
  044C62  0862: 83c404           add sp, 4
  044C65  0865: 40               inc ax
  044C66  0866: 2bd2             sub dx, dx
  044C68  0868: 9a2c001f18       lcall 0x181f, 0x2c
  044C6D  086D: c45eea           les bx, ptr [bp - 0x16]
  044C70  0870: 2689470e         mov word ptr es:[bx + 0xe], ax
  044C74  0874: 26895710         mov word ptr es:[bx + 0x10], dx
  044C78  0878: 52               push dx
  044C79  0879: 50               push ax
  044C7A  087A: 9a7e111d0d       lcall 0xd1d, 0x117e
  044C7F  087F: 83c408           add sp, 8
  044C82  0882: ff760c           push word ptr [bp + 0xc]
  044C85  0885: ff760a           push word ptr [bp + 0xa]
  044C88  0888: 0e               push cs
  044C89  0889: e8890f           call 0x1815
  044C8C  088C: 83c404           add sp, 4
  044C8F  088F: c45eea           les bx, ptr [bp - 0x16]
  044C92  0892: 26894708         mov word ptr es:[bx + 8], ax
  044C96  0896: 26c747060a00     mov word ptr es:[bx + 6], 0xa
  044C9C  089C: 8b46fa           mov ax, word ptr [bp - 6]
  044C9F  089F: 26894702         mov word ptr es:[bx + 2], ax
  044CA3  08A3: ff760c           push word ptr [bp + 0xc]
  044CA6  08A6: ff760a           push word ptr [bp + 0xa]
  044CA9  08A9: 8b46ee           mov ax, word ptr [bp - 0x12]
  044CAC  08AC: 8b56f0           mov dx, word ptr [bp - 0x10]
  044CAF  08AF: 052000           add ax, 0x20
  044CB2  08B2: 52               push dx
  044CB3  08B3: 50               push ax
  044CB4  08B4: 0e               push cs
  044CB5  08B5: e84e0f           call 0x1806
  044CB8  08B8: 83c408           add sp, 8
  044CBB  08BB: c45eee           les bx, ptr [bp - 0x12]
  044CBE  08BE: 268b4f0a         mov cx, word ptr es:[bx + 0xa]
  044CC2  08C2: d1e1             shl cx, 1
  044CC4  08C4: 03c1             add ax, cx
  044CC6  08C6: c45eea           les bx, ptr [bp - 0x16]
  044CC9  08C9: 26894704         mov word ptr es:[bx + 4], ax
  044CCD  08CD: 837e1000         cmp word ptr [bp + 0x10], 0
  044CD1  08D1: 7419             je 0x8ec
  044CD3  08D3: b84001           mov ax, 0x140
  044CD6  08D6: 8e46f8           mov es, word ptr [bp - 8]
  044CD9  08D9: 262b4404         sub ax, word ptr es:[si + 4]
  044CDD  08DD: 8cc1             mov cx, es
  044CDF  08DF: 8e4608           mov es, word ptr [bp + 8]
  044CE2  08E2: 262b4506         sub ax, word ptr es:[di + 6]
  044CE6  08E6: 8ec1             mov es, cx
  044CE8  08E8: 26894402         mov word ptr es:[si + 2], ax
  044CEC  08EC: 8b4608           mov ax, word ptr [bp + 8]
  044CEF  08EF: 8e46f8           mov es, word ptr [bp - 8]
  044CF2  08F2: 26897c12         mov word ptr es:[si + 0x12], di
  044CF6  08F6: 26894414         mov word ptr es:[si + 0x14], ax
  044CFA  08FA: 8b4e0e           mov cx, word ptr [bp + 0xe]
  044CFD  08FD: 26894c0a         mov word ptr es:[si + 0xa], cx
  044D01  0901: 26c7440c0000     mov word ptr es:[si + 0xc], 0
  044D07  0907: 8cc2             mov dx, es
  044D09  0909: 8ec0             mov es, ax
  044D0B  090B: 26ff4502         inc word ptr es:[di + 2]
  044D0F  090F: 8bc6             mov ax, si
  044D11  0911: 5e               pop si
  044D12  0912: 5f               pop di
  044D13  0913: c9               leave 
  044D14  0914: cb               retf 

; ---- func_044D16  size=357  insns=137  prologue=ENTER 0x0014,0  terminal=RETF ----
  044D16  0916: c8140000         enter 0x14, 0
  044D1A  091A: 57               push di
  044D1B  091B: 56               push si
  044D1C  091C: 2bc0             sub ax, ax
  044D1E  091E: 99               cdq 
  044D1F  091F: 8bf0             mov si, ax
  044D21  0921: 8956fa           mov word ptr [bp - 6], dx
  044D24  0924: ff760a           push word ptr [bp + 0xa]
  044D27  0927: ff7608           push word ptr [bp + 8]
  044D2A  092A: ff7606           push word ptr [bp + 6]
  044D2D  092D: 0e               push cs
  044D2E  092E: e8cb0e           call 0x17fc
  044D31  0931: 83c406           add sp, 6
  044D34  0934: 8946ec           mov word ptr [bp - 0x14], ax
  044D37  0937: 8956ee           mov word ptr [bp - 0x12], dx
  044D3A  093A: 0bd0             or dx, ax
  044D3C  093C: 7503             jne 0x941
  044D3E  093E: e93101           jmp 0xa72
  044D41  0941: 2bc0             sub ax, ax
  044D43  0943: 99               cdq 
  044D44  0944: 8bc8             mov cx, ax
  044D46  0946: 8956f2           mov word ptr [bp - 0xe], dx
  044D49  0949: c476ec           les si, ptr [bp - 0x14]
  044D4C  094C: 268b441e         mov ax, word ptr es:[si + 0x1e]
  044D50  0950: 268b5420         mov dx, word ptr es:[si + 0x20]
  044D54  0954: 8bd8             mov bx, ax
  044D56  0956: 8956fa           mov word ptr [bp - 6], dx
  044D59  0959: 0bd0             or dx, ax
  044D5B  095B: 7531             jne 0x98e
  044D5D  095D: 8bf9             mov di, cx
  044D5F  095F: 8b4606           mov ax, word ptr [bp + 6]
  044D62  0962: 8b5608           mov dx, word ptr [bp + 8]
  044D65  0965: 053c00           add ax, 0x3c
  044D68  0968: 52               push dx
  044D69  0969: 50               push ax
  044D6A  096A: b81600           mov ax, 0x16
  044D6D  096D: 99               cdq 
  044D6E  096E: 9a2c001f18       lcall 0x181f, 0x2c
  044D73  0973: 8bf0             mov si, ax
  044D75  0975: 8956fa           mov word ptr [bp - 6], dx
  044D78  0978: 8b46f2           mov ax, word ptr [bp - 0xe]
  044D7B  097B: 0bc7             or ax, di
  044D7D  097D: 742b             je 0x9aa
  044D7F  097F: 8bc2             mov ax, dx
  044D81  0981: 8e46f2           mov es, word ptr [bp - 0xe]
  044D84  0984: 2689750e         mov word ptr es:[di + 0xe], si
  044D88  0988: 26894510         mov word ptr es:[di + 0x10], ax
  044D8C  098C: eb29             jmp 0x9b7
  044D8E  098E: 8e5efa           mov ds, word ptr [bp - 6]
  044D91  0991: 8bfb             mov di, bx
  044D93  0993: 1e               push ds
  044D94  0994: 07               pop es
  044D95  0995: 26c55f0e         lds bx, ptr es:[bx + 0xe]
  044D99  0999: 8cd8             mov ax, ds
  044D9B  099B: 0bc3             or ax, bx
  044D9D  099D: 75f2             jne 0x991
  044D9F  099F: 8c46f2           mov word ptr [bp - 0xe], es
  044DA2  09A2: b85a1b           mov ax, 0x1b5a
  044DA5  09A5: 8ed8             mov ds, ax
  044DA7  09A7: ebb6             jmp 0x95f
  044DA9  09A9: 90               nop 
  044DAA  09AA: 8bc2             mov ax, dx
  044DAC  09AC: c45eec           les bx, ptr [bp - 0x14]
  044DAF  09AF: 2689771e         mov word ptr es:[bx + 0x1e], si
  044DB3  09B3: 26894720         mov word ptr es:[bx + 0x20], ax
  044DB7  09B7: 8b46f2           mov ax, word ptr [bp - 0xe]
  044DBA  09BA: 8ec2             mov es, dx
  044DBC  09BC: 26897c12         mov word ptr es:[si + 0x12], di
  044DC0  09C0: 26894414         mov word ptr es:[si + 0x14], ax
  044DC4  09C4: 2bc0             sub ax, ax
  044DC6  09C6: 26894410         mov word ptr es:[si + 0x10], ax
  044DCA  09CA: 2689440e         mov word ptr es:[si + 0xe], ax
  044DCE  09CE: 268904           mov word ptr es:[si], ax
  044DD1  09D1: ff760e           push word ptr [bp + 0xe]
  044DD4  09D4: ff760c           push word ptr [bp + 0xc]
  044DD7  09D7: 8b4606           mov ax, word ptr [bp + 6]
  044DDA  09DA: 8b5608           mov dx, word ptr [bp + 8]
  044DDD  09DD: 053c00           add ax, 0x3c
  044DE0  09E0: 52               push dx
  044DE1  09E1: 50               push ax
  044DE2  09E2: ff760e           push word ptr [bp + 0xe]
  044DE5  09E5: ff760c           push word ptr [bp + 0xc]
  044DE8  09E8: 8cc7             mov di, es
  044DEA  09EA: 9a3c111d0d       lcall 0xd1d, 0x113c
  044DEF  09EF: 83c404           add sp, 4
  044DF2  09F2: 40               inc ax
  044DF3  09F3: 2bd2             sub dx, dx
  044DF5  09F5: 9a2c001f18       lcall 0x181f, 0x2c
  044DFA  09FA: 8ec7             mov es, di
  044DFC  09FC: 26894406         mov word ptr es:[si + 6], ax
  044E00  0A00: 26895408         mov word ptr es:[si + 8], dx
  044E04  0A04: 52               push dx
  044E05  0A05: 50               push ax
  044E06  0A06: 9a7e111d0d       lcall 0xd1d, 0x117e
  044E0B  0A0B: 83c408           add sp, 8
  044E0E  0A0E: c45e0c           les bx, ptr [bp + 0xc]
  044E11  0A11: 26803f00         cmp byte ptr es:[bx], 0
  044E15  0A15: 7506             jne 0xa1d
  044E17  0A17: 8ec7             mov es, di
  044E19  0A19: 26800c01         or byte ptr es:[si], 1
  044E1D  0A1D: 8b4610           mov ax, word ptr [bp + 0x10]
  044E20  0A20: 8ec7             mov es, di
  044E22  0A22: 26894404         mov word ptr es:[si + 4], ax
  044E26  0A26: ff760e           push word ptr [bp + 0xe]
  044E29  0A29: 53               push bx
  044E2A  0A2A: 0e               push cs
  044E2B  0A2B: e8e70d           call 0x1815
  044E2E  0A2E: 83c404           add sp, 4
  044E31  0A31: 8ec7             mov es, di
  044E33  0A33: 26894402         mov word ptr es:[si + 2], ax
  044E37  0A37: ff760e           push word ptr [bp + 0xe]
  044E3A  0A3A: ff760c           push word ptr [bp + 0xc]
  044E3D  0A3D: 8b4606           mov ax, word ptr [bp + 6]
  044E40  0A40: 8b5608           mov dx, word ptr [bp + 8]
  044E43  0A43: 052c00           add ax, 0x2c
  044E46  0A46: 52               push dx
  044E47  0A47: 50               push ax
  044E48  0A48: 0e               push cs
  044E49  0A49: e8ba0d           call 0x1806
  044E4C  0A4C: 83c408           add sp, 8
  044E4F  0A4F: 8946fe           mov word ptr [bp - 2], ax
  044E52  0A52: c45e06           les bx, ptr [bp + 6]
  044E55  0A55: 268b470c         mov ax, word ptr es:[bx + 0xc]
  044E59  0A59: d1e0             shl ax, 1
  044E5B  0A5B: 0346fe           add ax, word ptr [bp - 2]
  044E5E  0A5E: c45eec           les bx, ptr [bp - 0x14]
  044E61  0A61: 263b4706         cmp ax, word ptr es:[bx + 6]
  044E65  0A65: 7d04             jge 0xa6b
  044E67  0A67: 268b4706         mov ax, word ptr es:[bx + 6]
  044E6B  0A6B: 26894706         mov word ptr es:[bx + 6], ax
  044E6F  0A6F: 26ff07           inc word ptr es:[bx]
  044E72  0A72: 8bc6             mov ax, si
  044E74  0A74: 8b56fa           mov dx, word ptr [bp - 6]
  044E77  0A77: 5e               pop si
  044E78  0A78: 5f               pop di
  044E79  0A79: c9               leave 
  044E7A  0A7A: cb               retf 

; ---- func_044E7C  size=296  insns=107  prologue=ENTER 0x000C,0  terminal=RETF ----
  044E7C  0A7C: c80c0000         enter 0xc, 0
  044E80  0A80: 56               push si
  044E81  0A81: c45e06           les bx, ptr [bp + 6]
  044E84  0A84: 26ff772a         push word ptr es:[bx + 0x2a]
  044E88  0A88: 26ff7728         push word ptr es:[bx + 0x28]
  044E8C  0A8C: e8b1f6           call 0x140
  044E8F  0A8F: 83c404           add sp, 4
  044E92  0A92: c45e06           les bx, ptr [bp + 6]
  044E95  0A95: 26034704         add ax, word ptr es:[bx + 4]
  044E99  0A99: 40               inc ax
  044E9A  0A9A: 8946f8           mov word ptr [bp - 8], ax
  044E9D  0A9D: ff36ae2d         push word ptr [0x2dae]
  044EA1  0AA1: ff36ac2d         push word ptr [0x2dac]
  044EA5  0AA5: ff36aa2d         push word ptr [0x2daa]
  044EA9  0AA9: ff36a82d         push word ptr [0x2da8]
  044EAD  0AAD: 50               push ax
  044EAE  0AAE: 6a00             push 0
  044EB0  0AB0: 6a00             push 0
  044EB2  0AB2: 684001           push 0x140
  044EB5  0AB5: 268a470e         mov al, byte ptr es:[bx + 0xe]
  044EB9  0AB9: 50               push ax
  044EBA  0ABA: 268a4710         mov al, byte ptr es:[bx + 0x10]
  044EBE  0ABE: 50               push ax
  044EBF  0ABF: 6a00             push 0
  044EC1  0AC1: 6a00             push 0
  044EC3  0AC3: 2bc0             sub ax, ax
  044EC5  0AC5: 99               cdq 
  044EC6  0AC6: bb4001           mov bx, 0x140
  044EC9  0AC9: e8bef6           call 0x18a
  044ECC  0ACC: c45e06           les bx, ptr [bp + 6]
  044ECF  0ACF: 268b4738         mov ax, word ptr es:[bx + 0x38]
  044ED3  0AD3: 268b573a         mov dx, word ptr es:[bx + 0x3a]
  044ED7  0AD7: 8946f4           mov word ptr [bp - 0xc], ax
  044EDA  0ADA: 8956f6           mov word ptr [bp - 0xa], dx
  044EDD  0ADD: 0bd0             or dx, ax
  044EDF  0ADF: 7503             jne 0xae4
  044EE1  0AE1: e9a500           jmp 0xb89
  044EE4  0AE4: c45ef4           les bx, ptr [bp - 0xc]
  044EE7  0AE7: 26f6470c01       test byte ptr es:[bx + 0xc], 1
  044EEC  0AEC: 7403             je 0xaf1
  044EEE  0AEE: e98000           jmp 0xb71
  044EF1  0AF1: 268b4702         mov ax, word ptr es:[bx + 2]
  044EF5  0AF5: 8946fe           mov word ptr [bp - 2], ax
  044EF8  0AF8: 8cc0             mov ax, es
  044EFA  0AFA: 3b5e0a           cmp bx, word ptr [bp + 0xa]
  044EFD  0AFD: 7545             jne 0xb44
  044EFF  0AFF: 3b460c           cmp ax, word ptr [bp + 0xc]
  044F02  0B02: 7540             jne 0xb44
  044F04  0B04: ff36ae2d         push word ptr [0x2dae]
  044F08  0B08: ff36ac2d         push word ptr [0x2dac]
  044F0C  0B0C: ff36aa2d         push word ptr [0x2daa]
  044F10  0B10: ff36a82d         push word ptr [0x2da8]
  044F14  0B14: ff76f8           push word ptr [bp - 8]
  044F17  0B17: 6a00             push 0
  044F19  0B19: 6a00             push 0
  044F1B  0B1B: 684001           push 0x140
  044F1E  0B1E: c45e06           les bx, ptr [bp + 6]
  044F21  0B21: 268a471a         mov al, byte ptr es:[bx + 0x1a]
  044F25  0B25: 50               push ax
  044F26  0B26: 268a471c         mov al, byte ptr es:[bx + 0x1c]
  044F2A  0B2A: 50               push ax
  044F2B  0B2B: 6a00             push 0
  044F2D  0B2D: 6a00             push 0
  044F2F  0B2F: 268b5f0a         mov bx, word ptr es:[bx + 0xa]
  044F33  0B33: d1e3             shl bx, 1
  044F35  0B35: c476f4           les si, ptr [bp - 0xc]
  044F38  0B38: 26035c04         add bx, word ptr es:[si + 4]
  044F3C  0B3C: 8b46fe           mov ax, word ptr [bp - 2]
  044F3F  0B3F: 2bd2             sub dx, dx
  044F41  0B41: e846f6           call 0x18a
  044F44  0B44: 6a00             push 0
  044F46  0B46: c45e06           les bx, ptr [bp + 6]
  044F49  0B49: 26ff7704         push word ptr es:[bx + 4]
  044F4D  0B4D: 268b470a         mov ax, word ptr es:[bx + 0xa]
  044F51  0B51: 0346fe           add ax, word ptr [bp - 2]
  044F54  0B54: 50               push ax
  044F55  0B55: c476f4           les si, ptr [bp - 0xc]
  044F58  0B58: 26ff7410         push word ptr es:[si + 0x10]
  044F5C  0B5C: 26ff740e         push word ptr es:[si + 0xe]
  044F60  0B60: 8bc3             mov ax, bx
  044F62  0B62: 8b5608           mov dx, word ptr [bp + 8]
  044F65  0B65: 052000           add ax, 0x20
  044F68  0B68: 52               push dx
  044F69  0B69: 50               push ax
  044F6A  0B6A: 0e               push cs
  044F6B  0B6B: e8a20c           call 0x1810
  044F6E  0B6E: 83c40e           add sp, 0xe
  044F71  0B71: c45ef4           les bx, ptr [bp - 0xc]
  044F74  0B74: 268b4716         mov ax, word ptr es:[bx + 0x16]
  044F78  0B78: 268b5718         mov dx, word ptr es:[bx + 0x18]
  044F7C  0B7C: 8946f4           mov word ptr [bp - 0xc], ax
  044F7F  0B7F: 8956f6           mov word ptr [bp - 0xa], dx
  044F82  0B82: 0bd0             or dx, ax
  044F84  0B84: 7403             je 0xb89
  044F86  0B86: e95bff           jmp 0xae4
  044F89  0B89: 837e0e00         cmp word ptr [bp + 0xe], 0
  044F8D  0B8D: 7412             je 0xba1
  044F8F  0B8F: 6a00             push 0
  044F91  0B91: 684001           push 0x140
  044F94  0B94: ff76f8           push word ptr [bp - 8]
  044F97  0B97: 2bc0             sub ax, ax
  044F99  0B99: 99               cdq 
  044F9A  0B9A: 2bdb             sub bx, bx
  044F9C  0B9C: 9ae2001f18       lcall 0x181f, 0xe2
  044FA1  0BA1: 5e               pop si
  044FA2  0BA2: c9               leave 
  044FA3  0BA3: cb               retf 

; ---- func_044FA4  size=278  insns=109  prologue=ENTER 0x0012,0  terminal=RETF ----
  044FA4  0BA4: c8120000         enter 0x12, 0
  044FA8  0BA8: 57               push di
  044FA9  0BA9: 56               push si
  044FAA  0BAA: 8b7606           mov si, word ptr [bp + 6]
  044FAD  0BAD: 8e4608           mov es, word ptr [bp + 8]
  044FB0  0BB0: 268b4402         mov ax, word ptr es:[si + 2]
  044FB4  0BB4: 8b5e0a           mov bx, word ptr [bp + 0xa]
  044FB7  0BB7: 8907             mov word ptr [bx], ax
  044FB9  0BB9: 8cc0             mov ax, es
  044FBB  0BBB: 26c45c12         les bx, ptr es:[si + 0x12]
  044FBF  0BBF: 895eee           mov word ptr [bp - 0x12], bx
  044FC2  0BC2: 8c46f0           mov word ptr [bp - 0x10], es
  044FC5  0BC5: 26ff772a         push word ptr es:[bx + 0x2a]
  044FC9  0BC9: 26ff7728         push word ptr es:[bx + 0x28]
  044FCD  0BCD: 8bf8             mov di, ax
  044FCF  0BCF: e86ef5           call 0x140
  044FD2  0BD2: 83c404           add sp, 4
  044FD5  0BD5: c45eee           les bx, ptr [bp - 0x12]
  044FD8  0BD8: 26034704         add ax, word ptr es:[bx + 4]
  044FDC  0BDC: 050300           add ax, 3
  044FDF  0BDF: 8b5e0c           mov bx, word ptr [bp + 0xc]
  044FE2  0BE2: 8907             mov word ptr [bx], ax
  044FE4  0BE4: c746fa0000       mov word ptr [bp - 6], 0
  044FE9  0BE9: 8ec7             mov es, di
  044FEB  0BEB: 268b441e         mov ax, word ptr es:[si + 0x1e]
  044FEF  0BEF: 268b5420         mov dx, word ptr es:[si + 0x20]
  044FF3  0BF3: 8956f8           mov word ptr [bp - 8], dx
  044FF6  0BF6: 0bd0             or dx, ax
  044FF8  0BF8: 741f             je 0xc19
  044FFA  0BFA: 8bd8             mov bx, ax
  044FFC  0BFC: 8b4efa           mov cx, word ptr [bp - 6]
  044FFF  0BFF: 8e5ef8           mov ds, word ptr [bp - 8]
  045002  0C02: f60702           test byte ptr [bx], 2
  045005  0C05: 7501             jne 0xc08
  045007  0C07: 41               inc cx
  045008  0C08: c55f0e           lds bx, ptr [bx + 0xe]
  04500B  0C0B: 8cd8             mov ax, ds
  04500D  0C0D: 0bc3             or ax, bx
  04500F  0C0F: 75f1             jne 0xc02
  045011  0C11: 894efa           mov word ptr [bp - 6], cx
  045014  0C14: b85a1b           mov ax, 0x1b5a
  045017  0C17: 8ed8             mov ds, ax
  045019  0C19: 8b760a           mov si, word ptr [bp + 0xa]
  04501C  0C1C: 8b7e0c           mov di, word ptr [bp + 0xc]
  04501F  0C1F: c45e06           les bx, ptr [bp + 6]
  045022  0C22: 268b4706         mov ax, word ptr es:[bx + 6]
  045026  0C26: 40               inc ax
  045027  0C27: 40               inc ax
  045028  0C28: 8b5e0e           mov bx, word ptr [bp + 0xe]
  04502B  0C2B: 8907             mov word ptr [bx], ax
  04502D  0C2D: 0304             add ax, word ptr [si]
  04502F  0C2F: 48               dec ax
  045030  0C30: 8946f8           mov word ptr [bp - 8], ax
  045033  0C33: c45eee           les bx, ptr [bp - 0x12]
  045036  0C36: 26ff7736         push word ptr es:[bx + 0x36]
  04503A  0C3A: 26ff7734         push word ptr es:[bx + 0x34]
  04503E  0C3E: e8fff4           call 0x140
  045041  0C41: 83c404           add sp, 4
  045044  0C44: c45eee           les bx, ptr [bp - 0x12]
  045047  0C47: 26034708         add ax, word ptr es:[bx + 8]
  04504B  0C4B: f76efa           imul word ptr [bp - 6]
  04504E  0C4E: 26034708         add ax, word ptr es:[bx + 8]
  045052  0C52: 40               inc ax
  045053  0C53: 40               inc ax
  045054  0C54: 8b5e10           mov bx, word ptr [bp + 0x10]
  045057  0C57: 8907             mov word ptr [bx], ax
  045059  0C59: 0305             add ax, word ptr [di]
  04505B  0C5B: 48               dec ax
  04505C  0C5C: 8946fe           mov word ptr [bp - 2], ax
  04505F  0C5F: 817ef83e01       cmp word ptr [bp - 8], 0x13e
  045064  0C64: 7c08             jl 0xc6e
  045066  0C66: b83d01           mov ax, 0x13d
  045069  0C69: 2b46f8           sub ax, word ptr [bp - 8]
  04506C  0C6C: 0104             add word ptr [si], ax
  04506E  0C6E: 817efec600       cmp word ptr [bp - 2], 0xc6
  045073  0C73: 7c08             jl 0xc7d
  045075  0C75: b8c700           mov ax, 0xc7
  045078  0C78: 2b46fe           sub ax, word ptr [bp - 2]
  04507B  0C7B: 0105             add word ptr [di], ax
  04507D  0C7D: 8b04             mov ax, word ptr [si]
  04507F  0C7F: 40               inc ax
  045080  0C80: 8b5e12           mov bx, word ptr [bp + 0x12]
  045083  0C83: 8907             mov word ptr [bx], ax
  045085  0C85: 8b5eee           mov bx, word ptr [bp - 0x12]
  045088  0C88: 268b4708         mov ax, word ptr es:[bx + 8]
  04508C  0C8C: 0305             add ax, word ptr [di]
  04508E  0C8E: 40               inc ax
  04508F  0C8F: 8b5e14           mov bx, word ptr [bp + 0x14]
  045092  0C92: 8907             mov word ptr [bx], ax
  045094  0C94: 833c00           cmp word ptr [si], 0
  045097  0C97: 7c05             jl 0xc9e
  045099  0C99: 833d00           cmp word ptr [di], 0
  04509C  0C9C: 7d18             jge 0xcb6
  04509E  0C9E: 8b04             mov ax, word ptr [si]
  0450A0  0CA0: 99               cdq 
  0450A1  0CA1: 52               push dx
  0450A2  0CA2: 50               push ax
  0450A3  0CA3: 8b05             mov ax, word ptr [di]
  0450A5  0CA5: 99               cdq 
  0450A6  0CA6: 52               push dx
  0450A7  0CA7: 50               push ax
  0450A8  0CA8: b8b0ff           mov ax, 0xffb0
  0450AB  0CAB: ba0200           mov dx, 2
  0450AE  0CAE: bb2800           mov bx, 0x28
  0450B1  0CB1: 9a72071f18       lcall 0x181f, 0x772
  0450B6  0CB6: 5e               pop si
  0450B7  0CB7: 5f               pop di
  0450B8  0CB8: c9               leave 
  0450B9  0CB9: cb               retf 

; ---- func_0450BA  size=537  insns=197  prologue=ENTER 0x0024,0  terminal=RETF ----
  0450BA  0CBA: c8240000         enter 0x24, 0
  0450BE  0CBE: 57               push di
  0450BF  0CBF: 56               push si
  0450C0  0CC0: c45e06           les bx, ptr [bp + 6]
  0450C3  0CC3: 268b4712         mov ax, word ptr es:[bx + 0x12]
  0450C7  0CC7: 268b5714         mov dx, word ptr es:[bx + 0x14]
  0450CB  0CCB: 8946e8           mov word ptr [bp - 0x18], ax
  0450CE  0CCE: 8956ea           mov word ptr [bp - 0x16], dx
  0450D1  0CD1: 8d46dc           lea ax, [bp - 0x24]
  0450D4  0CD4: 50               push ax
  0450D5  0CD5: 8d4ee0           lea cx, [bp - 0x20]
  0450D8  0CD8: 51               push cx
  0450D9  0CD9: 8d56de           lea dx, [bp - 0x22]
  0450DC  0CDC: 52               push dx
  0450DD  0CDD: 8d76e2           lea si, [bp - 0x1e]
  0450E0  0CE0: 56               push si
  0450E1  0CE1: 8d7ee6           lea di, [bp - 0x1a]
  0450E4  0CE4: 57               push di
  0450E5  0CE5: 8d46e4           lea ax, [bp - 0x1c]
  0450E8  0CE8: 50               push ax
  0450E9  0CE9: 06               push es
  0450EA  0CEA: 53               push bx
  0450EB  0CEB: 0e               push cs
  0450EC  0CEC: e8080b           call 0x17f7
  0450EF  0CEF: 83c410           add sp, 0x10
  0450F2  0CF2: ff36ae2d         push word ptr [0x2dae]
  0450F6  0CF6: ff36ac2d         push word ptr [0x2dac]
  0450FA  0CFA: ff36aa2d         push word ptr [0x2daa]
  0450FE  0CFE: ff36a82d         push word ptr [0x2da8]
  045102  0D02: 8b46de           mov ax, word ptr [bp - 0x22]
  045105  0D05: 0346e6           add ax, word ptr [bp - 0x1a]
  045108  0D08: 48               dec ax
  045109  0D09: 50               push ax
  04510A  0D0A: c45ee8           les bx, ptr [bp - 0x18]
  04510D  0D0D: 268a471e         mov al, byte ptr es:[bx + 0x1e]
  045111  0D11: 50               push ax
  045112  0D12: 8b46e4           mov ax, word ptr [bp - 0x1c]
  045115  0D15: 8b5ee2           mov bx, word ptr [bp - 0x1e]
  045118  0D18: 03d8             add bx, ax
  04511A  0D1A: 8d5fff           lea bx, [bx - 1]
  04511D  0D1D: 8b56e6           mov dx, word ptr [bp - 0x1a]
  045120  0D20: 9ace001f18       lcall 0x181f, 0xce
  045125  0D25: 8b46e4           mov ax, word ptr [bp - 0x1c]
  045128  0D28: 40               inc ax
  045129  0D29: 8946e0           mov word ptr [bp - 0x20], ax
  04512C  0D2C: 8b4ee6           mov cx, word ptr [bp - 0x1a]
  04512F  0D2F: 41               inc cx
  045130  0D30: 894edc           mov word ptr [bp - 0x24], cx
  045133  0D33: 8b56e2           mov dx, word ptr [bp - 0x1e]
  045136  0D36: 4a               dec dx
  045137  0D37: 4a               dec dx
  045138  0D38: 8956f2           mov word ptr [bp - 0xe], dx
  04513B  0D3B: ff36ae2d         push word ptr [0x2dae]
  04513F  0D3F: ff36ac2d         push word ptr [0x2dac]
  045143  0D43: ff36aa2d         push word ptr [0x2daa]
  045147  0D47: ff36a82d         push word ptr [0x2da8]
  04514B  0D4B: 8b5ede           mov bx, word ptr [bp - 0x22]
  04514E  0D4E: 4b               dec bx
  04514F  0D4F: 4b               dec bx
  045150  0D50: 53               push bx
  045151  0D51: ff76e4           push word ptr [bp - 0x1c]
  045154  0D54: ff76e6           push word ptr [bp - 0x1a]
  045157  0D57: ff76e2           push word ptr [bp - 0x1e]
  04515A  0D5A: c45ee8           les bx, ptr [bp - 0x18]
  04515D  0D5D: 268a5f12         mov bl, byte ptr es:[bx + 0x12]
  045161  0D61: 53               push bx
  045162  0D62: 8b5ee8           mov bx, word ptr [bp - 0x18]
  045165  0D65: 268a5f14         mov bl, byte ptr es:[bx + 0x14]
  045169  0D69: 53               push bx
  04516A  0D6A: 6a00             push 0
  04516C  0D6C: 6a00             push 0
  04516E  0D6E: 8bda             mov bx, dx
  045170  0D70: 8bd1             mov dx, cx
  045172  0D72: 8bf0             mov si, ax
  045174  0D74: 8bf9             mov di, cx
  045176  0D76: e811f4           call 0x18a
  045179  0D79: c45e06           les bx, ptr [bp + 6]
  04517C  0D7C: 268b471e         mov ax, word ptr es:[bx + 0x1e]
  045180  0D80: 268b5720         mov dx, word ptr es:[bx + 0x20]
  045184  0D84: 8946ec           mov word ptr [bp - 0x14], ax
  045187  0D87: 8956ee           mov word ptr [bp - 0x12], dx
  04518A  0D8A: c45ee8           les bx, ptr [bp - 0x18]
  04518D  0D8D: 2603770c         add si, word ptr es:[bx + 0xc]
  045191  0D91: 8976f0           mov word ptr [bp - 0x10], si
  045194  0D94: 26037f08         add di, word ptr es:[bx + 8]
  045198  0D98: 897ef4           mov word ptr [bp - 0xc], di
  04519B  0D9B: 0bd0             or dx, ax
  04519D  0D9D: 7503             jne 0xda2
  04519F  0D9F: e91701           jmp 0xeb9
  0451A2  0DA2: c45eec           les bx, ptr [bp - 0x14]
  0451A5  0DA5: 26f60702         test byte ptr es:[bx], 2
  0451A9  0DA9: 7403             je 0xdae
  0451AB  0DAB: e9f300           jmp 0xea1
  0451AE  0DAE: 8cc2             mov dx, es
  0451B0  0DB0: 39460a           cmp word ptr [bp + 0xa], ax
  0451B3  0DB3: 7557             jne 0xe0c
  0451B5  0DB5: 39560c           cmp word ptr [bp + 0xc], dx
  0451B8  0DB8: 7552             jne 0xe0c
  0451BA  0DBA: ff36ae2d         push word ptr [0x2dae]
  0451BE  0DBE: ff36ac2d         push word ptr [0x2dac]
  0451C2  0DC2: ff36aa2d         push word ptr [0x2daa]
  0451C6  0DC6: ff36a82d         push word ptr [0x2da8]
  0451CA  0DCA: c45ee8           les bx, ptr [bp - 0x18]
  0451CD  0DCD: 26ff7736         push word ptr es:[bx + 0x36]
  0451D1  0DD1: 26ff7734         push word ptr es:[bx + 0x34]
  0451D5  0DD5: e868f3           call 0x140
  0451D8  0DD8: 83c404           add sp, 4
  0451DB  0DDB: 40               inc ax
  0451DC  0DDC: 40               inc ax
  0451DD  0DDD: 50               push ax
  0451DE  0DDE: ff76e4           push word ptr [bp - 0x1c]
  0451E1  0DE1: ff76e6           push word ptr [bp - 0x1a]
  0451E4  0DE4: ff76e2           push word ptr [bp - 0x1e]
  0451E7  0DE7: c45ee8           les bx, ptr [bp - 0x18]
  0451EA  0DEA: 268a4716         mov al, byte ptr es:[bx + 0x16]
  0451EE  0DEE: 50               push ax
  0451EF  0DEF: 268a4718         mov al, byte ptr es:[bx + 0x18]
  0451F3  0DF3: 50               push ax
  0451F4  0DF4: 6a00             push 0
  0451F6  0DF6: 6a00             push 0
  0451F8  0DF8: 8b46e0           mov ax, word ptr [bp - 0x20]
  0451FB  0DFB: 40               inc ax
  0451FC  0DFC: c45e06           les bx, ptr [bp + 6]
  0451FF  0DFF: 268b5f06         mov bx, word ptr es:[bx + 6]
  045203  0E03: 4b               dec bx
  045204  0E04: 4b               dec bx
  045205  0E05: 8b56f4           mov dx, word ptr [bp - 0xc]
  045208  0E08: 4a               dec dx
  045209  0E09: e87ef3           call 0x18a
  04520C  0E0C: c45eec           les bx, ptr [bp - 0x14]
  04520F  0E0F: 26c45f06         les bx, ptr es:[bx + 6]
  045213  0E13: 26803f00         cmp byte ptr es:[bx], 0
  045217  0E17: 7543             jne 0xe5c
  045219  0E19: c45ee8           les bx, ptr [bp - 0x18]
  04521C  0E1C: 26ff7736         push word ptr es:[bx + 0x36]
  045220  0E20: 26ff7734         push word ptr es:[bx + 0x34]
  045224  0E24: e819f3           call 0x140
  045227  0E27: 83c404           add sp, 4
  04522A  0E2A: d1f8             sar ax, 1
  04522C  0E2C: 0346f4           add ax, word ptr [bp - 0xc]
  04522F  0E2F: 8946f6           mov word ptr [bp - 0xa], ax
  045232  0E32: ff36ae2d         push word ptr [0x2dae]
  045236  0E36: ff36ac2d         push word ptr [0x2dac]
  04523A  0E3A: ff36aa2d         push word ptr [0x2daa]
  04523E  0E3E: ff36a82d         push word ptr [0x2da8]
  045242  0E42: 6a01             push 1
  045244  0E44: c45ee8           les bx, ptr [bp - 0x18]
  045247  0E47: 268a472e         mov al, byte ptr es:[bx + 0x2e]
  04524B  0E4B: 50               push ax
  04524C  0E4C: 8b46e0           mov ax, word ptr [bp - 0x20]
  04524F  0E4F: 8b56f6           mov dx, word ptr [bp - 0xa]
  045252  0E52: 8b5ef2           mov bx, word ptr [bp - 0xe]
  045255  0E55: 9aba001f18       lcall 0x181f, 0xba
  04525A  0E5A: eb2a             jmp 0xe86
  04525C  0E5C: c45eec           les bx, ptr [bp - 0x14]
  04525F  0E5F: 268a07           mov al, byte ptr es:[bx]
  045262  0E62: 250100           and ax, 1
  045265  0E65: 50               push ax
  045266  0E66: ff76f4           push word ptr [bp - 0xc]
  045269  0E69: ff76f0           push word ptr [bp - 0x10]
  04526C  0E6C: 26ff7708         push word ptr es:[bx + 8]
  045270  0E70: 26ff7706         push word ptr es:[bx + 6]
  045274  0E74: 8b46e8           mov ax, word ptr [bp - 0x18]
  045277  0E77: 8b56ea           mov dx, word ptr [bp - 0x16]
  04527A  0E7A: 052c00           add ax, 0x2c
  04527D  0E7D: 52               push dx
  04527E  0E7E: 50               push ax
  04527F  0E7F: 0e               push cs
  045280  0E80: e88d09           call 0x1810
  045283  0E83: 83c40e           add sp, 0xe
  045286  0E86: c45ee8           les bx, ptr [bp - 0x18]
  045289  0E89: 26ff7736         push word ptr es:[bx + 0x36]
  04528D  0E8D: 26ff7734         push word ptr es:[bx + 0x34]
  045291  0E91: e8acf2           call 0x140
  045294  0E94: 83c404           add sp, 4
  045297  0E97: c45ee8           les bx, ptr [bp - 0x18]
  04529A  0E9A: 26034708         add ax, word ptr es:[bx + 8]
  04529E  0E9E: 0146f4           add word ptr [bp - 0xc], ax
  0452A1  0EA1: c45eec           les bx, ptr [bp - 0x14]
  0452A4  0EA4: 268b470e         mov ax, word ptr es:[bx + 0xe]
  0452A8  0EA8: 268b5710         mov dx, word ptr es:[bx + 0x10]
  0452AC  0EAC: 8946ec           mov word ptr [bp - 0x14], ax
  0452AF  0EAF: 8956ee           mov word ptr [bp - 0x12], dx
  0452B2  0EB2: 0bd0             or dx, ax
  0452B4  0EB4: 7403             je 0xeb9
  0452B6  0EB6: e9e9fe           jmp 0xda2
  0452B9  0EB9: ff76e6           push word ptr [bp - 0x1a]
  0452BC  0EBC: ff76e2           push word ptr [bp - 0x1e]
  0452BF  0EBF: ff76de           push word ptr [bp - 0x22]
  0452C2  0EC2: 8b46e4           mov ax, word ptr [bp - 0x1c]
  0452C5  0EC5: 8b56e6           mov dx, word ptr [bp - 0x1a]
  0452C8  0EC8: 8bd8             mov bx, ax
  0452CA  0ECA: 9ae2001f18       lcall 0x181f, 0xe2
  0452CF  0ECF: 5e               pop si
  0452D0  0ED0: 5f               pop di
  0452D1  0ED1: c9               leave 
  0452D2  0ED2: cb               retf 

; ---- func_0452D4  size=1559  insns=519  prologue=ENTER 0x003C,0  terminal=RETF imm16 ----
  0452D4  0ED4: c83c0000         enter 0x3c, 0
  0452D8  0ED8: 56               push si
  0452D9  0ED9: c746e00000       mov word ptr [bp - 0x20], 0
  0452DE  0EDE: 2bc0             sub ax, ax
  0452E0  0EE0: 8946d8           mov word ptr [bp - 0x28], ax
  0452E3  0EE3: 8946d6           mov word ptr [bp - 0x2a], ax
  0452E6  0EE6: c45e06           les bx, ptr [bp + 6]
  0452E9  0EE9: 268b4712         mov ax, word ptr es:[bx + 0x12]
  0452ED  0EED: 268b5714         mov dx, word ptr es:[bx + 0x14]
  0452F1  0EF1: 8946f2           mov word ptr [bp - 0xe], ax
  0452F4  0EF4: 8956f4           mov word ptr [bp - 0xc], dx
  0452F7  0EF7: c746f60100       mov word ptr [bp - 0xa], 1
  0452FC  0EFC: bb4000           mov bx, 0x40
  0452FF  0EFF: 8ec3             mov es, bx
  045301  0F01: bb1700           mov bx, 0x17
  045304  0F04: 268a07           mov al, byte ptr es:[bx]
  045307  0F07: 250800           and ax, 8
  04530A  0F0A: 8946e6           mov word ptr [bp - 0x1a], ax
  04530D  0F0D: c746ec0000       mov word ptr [bp - 0x14], 0
  045312  0F12: c746d00100       mov word ptr [bp - 0x30], 1
  045317  0F17: c45e06           les bx, ptr [bp + 6]
  04531A  0F1A: 268b4720         mov ax, word ptr es:[bx + 0x20]
  04531E  0F1E: 260b471e         or ax, word ptr es:[bx + 0x1e]
  045322  0F22: 7503             jne 0xf27
  045324  0F24: e9a705           jmp 0x14ce
  045327  0F27: 6a01             push 1
  045329  0F29: 06               push es
  04532A  0F2A: 53               push bx
  04532B  0F2B: ff76f4           push word ptr [bp - 0xc]
  04532E  0F2E: ff76f2           push word ptr [bp - 0xe]
  045331  0F31: 0e               push cs
  045332  0F32: e8b308           call 0x17e8
  045335  0F35: 83c40a           add sp, 0xa
  045338  0F38: 8d46e8           lea ax, [bp - 0x18]
  04533B  0F3B: 50               push ax
  04533C  0F3C: 8d46f0           lea ax, [bp - 0x10]
  04533F  0F3F: 50               push ax
  045340  0F40: 8d46d4           lea ax, [bp - 0x2c]
  045343  0F43: 50               push ax
  045344  0F44: 8d4eda           lea cx, [bp - 0x26]
  045347  0F47: 51               push cx
  045348  0F48: 8d56e2           lea dx, [bp - 0x1e]
  04534B  0F4B: 52               push dx
  04534C  0F4C: 8d5ee4           lea bx, [bp - 0x1c]
  04534F  0F4F: 53               push bx
  045350  0F50: ff7608           push word ptr [bp + 8]
  045353  0F53: ff7606           push word ptr [bp + 6]
  045356  0F56: 0e               push cs
  045357  0F57: e89d08           call 0x17f7
  04535A  0F5A: 83c410           add sp, 0x10
  04535D  0F5D: c45ef2           les bx, ptr [bp - 0xe]
  045360  0F60: 26ff7736         push word ptr es:[bx + 0x36]
  045364  0F64: 26ff7734         push word ptr es:[bx + 0x34]
  045368  0F68: e8d5f1           call 0x140
  04536B  0F6B: 83c404           add sp, 4
  04536E  0F6E: c45ef2           les bx, ptr [bp - 0xe]
  045371  0F71: 26034708         add ax, word ptr es:[bx + 8]
  045375  0F75: 8946f8           mov word ptr [bp - 8], ax
  045378  0F78: ff76e4           push word ptr [bp - 0x1c]
  04537B  0F7B: ff76e2           push word ptr [bp - 0x1e]
  04537E  0F7E: ff76da           push word ptr [bp - 0x26]
  045381  0F81: ff76d4           push word ptr [bp - 0x2c]
  045384  0F84: 8d1ea82d         lea bx, [0x2da8]
  045388  0F88: b8f8ff           mov ax, 0xfff8
  04538B  0F8B: 99               cdq 
  04538C  0F8C: 9a64031f1a       lcall 0x1a1f, 0x364
  045391  0F91: 8946ea           mov word ptr [bp - 0x16], ax
  045394  0F94: a1ee07           mov ax, word ptr [0x7ee]
  045397  0F97: 8946dc           mov word ptr [bp - 0x24], ax
  04539A  0F9A: 0bc0             or ax, ax
  04539C  0F9C: 7511             jne 0xfaf
  04539E  0F9E: c45e06           les bx, ptr [bp + 6]
  0453A1  0FA1: 268b471e         mov ax, word ptr es:[bx + 0x1e]
  0453A5  0FA5: 268b5720         mov dx, word ptr es:[bx + 0x20]
  0453A9  0FA9: 8946d6           mov word ptr [bp - 0x2a], ax
  0453AC  0FAC: 8956d8           mov word ptr [bp - 0x28], dx
  0453AF  0FAF: 9a70041f18       lcall 0x181f, 0x470
  0453B4  0FB4: 2bc0             sub ax, ax
  0453B6  0FB6: 9a66041f18       lcall 0x181f, 0x466
  0453BB  0FBB: 833ef60700       cmp word ptr [0x7f6], 0
  0453C0  0FC0: 7503             jne 0xfc5
  0453C2  0FC2: e96d01           jmp 0x1132
  0453C5  0FC5: c746d20000       mov word ptr [bp - 0x2e], 0
  0453CA  0FCA: c45ef2           les bx, ptr [bp - 0xe]
  0453CD  0FCD: 26ff772a         push word ptr es:[bx + 0x2a]
  0453D1  0FD1: 26ff7728         push word ptr es:[bx + 0x28]
  0453D5  0FD5: e868f1           call 0x140
  0453D8  0FD8: 83c404           add sp, 4
  0453DB  0FDB: c45ef2           les bx, ptr [bp - 0xe]
  0453DE  0FDE: 26034704         add ax, word ptr es:[bx + 4]
  0453E2  0FE2: 40               inc ax
  0453E3  0FE3: 3b06ea07         cmp ax, word ptr [0x7ea]
  0453E7  0FE7: 7c61             jl 0x104a
  0453E9  0FE9: 268b4738         mov ax, word ptr es:[bx + 0x38]
  0453ED  0FED: 268b573a         mov dx, word ptr es:[bx + 0x3a]
  0453F1  0FF1: 8946fa           mov word ptr [bp - 6], ax
  0453F4  0FF4: 8956fc           mov word ptr [bp - 4], dx
  0453F7  0FF7: 8b46fc           mov ax, word ptr [bp - 4]
  0453FA  0FFA: 0b46fa           or ax, word ptr [bp - 6]
  0453FD  0FFD: 744b             je 0x104a
  0453FF  0FFF: 837ed200         cmp word ptr [bp - 0x2e], 0
  045403  1003: 7545             jne 0x104a
  045405  1005: c45efa           les bx, ptr [bp - 6]
  045408  1008: 268b4702         mov ax, word ptr es:[bx + 2]
  04540C  100C: 8946fe           mov word ptr [bp - 2], ax
  04540F  100F: 26034704         add ax, word ptr es:[bx + 4]
  045413  1013: 8946de           mov word ptr [bp - 0x22], ax
  045416  1016: 3b06e807         cmp ax, word ptr [0x7e8]
  04541A  101A: 7c24             jl 0x1040
  04541C  101C: 26f6470c01       test byte ptr es:[bx + 0xc], 1
  045421  1021: 751d             jne 0x1040
  045423  1023: 8cc0             mov ax, es
  045425  1025: 395e06           cmp word ptr [bp + 6], bx
  045428  1028: 7505             jne 0x102f
  04542A  102A: 394608           cmp word ptr [bp + 8], ax
  04542D  102D: 7407             je 0x1036
  04542F  102F: c746d20100       mov word ptr [bp - 0x2e], 1
  045434  1034: ebc1             jmp 0xff7
  045436  1036: 2bc0             sub ax, ax
  045438  1038: 8946fc           mov word ptr [bp - 4], ax
  04543B  103B: 8946fa           mov word ptr [bp - 6], ax
  04543E  103E: ebb7             jmp 0xff7
  045440  1040: 268b4716         mov ax, word ptr es:[bx + 0x16]
  045444  1044: 268b5718         mov dx, word ptr es:[bx + 0x18]
  045448  1048: eba7             jmp 0xff1
  04544A  104A: 837ed200         cmp word ptr [bp - 0x2e], 0
  04544E  104E: 741a             je 0x106a
  045450  1050: 8b46fa           mov ax, word ptr [bp - 6]
  045453  1053: 8b56fc           mov dx, word ptr [bp - 4]
  045456  1056: 894606           mov word ptr [bp + 6], ax
  045459  1059: 895608           mov word ptr [bp + 8], dx
  04545C  105C: c746ec0100       mov word ptr [bp - 0x14], 1
  045461  1061: c746e00000       mov word ptr [bp - 0x20], 0
  045466  1066: e9c900           jmp 0x1132
  045469  1069: 90               nop 
  04546A  106A: 8b46e2           mov ax, word ptr [bp - 0x1e]
  04546D  106D: 3906ea07         cmp word ptr [0x7ea], ax
  045471  1071: 7c1d             jl 0x1090
  045473  1073: 0346d4           add ax, word ptr [bp - 0x2c]
  045476  1076: 48               dec ax
  045477  1077: 3b06ea07         cmp ax, word ptr [0x7ea]
  04547B  107B: 7c13             jl 0x1090
  04547D  107D: 8b46e4           mov ax, word ptr [bp - 0x1c]
  045480  1080: 3906e807         cmp word ptr [0x7e8], ax
  045484  1084: 7c0a             jl 0x1090
  045486  1086: 0346da           add ax, word ptr [bp - 0x26]
  045489  1089: 48               dec ax
  04548A  108A: 3b06e807         cmp ax, word ptr [0x7e8]
  04548E  108E: 7d14             jge 0x10a4
  045490  1090: c746d00100       mov word ptr [bp - 0x30], 1
  045495  1095: 2bc0             sub ax, ax
  045497  1097: 8946d8           mov word ptr [bp - 0x28], ax
  04549A  109A: 8946d6           mov word ptr [bp - 0x2a], ax
  04549D  109D: 8946e0           mov word ptr [bp - 0x20], ax
  0454A0  10A0: e98f00           jmp 0x1132
  0454A3  10A3: 90               nop 
  0454A4  10A4: c45e06           les bx, ptr [bp + 6]
  0454A7  10A7: 268b471e         mov ax, word ptr es:[bx + 0x1e]
  0454AB  10AB: 268b5720         mov dx, word ptr es:[bx + 0x20]
  0454AF  10AF: 8946cc           mov word ptr [bp - 0x34], ax
  0454B2  10B2: 8956ce           mov word ptr [bp - 0x32], dx
  0454B5  10B5: c746d20000       mov word ptr [bp - 0x2e], 0
  0454BA  10BA: 8b46e8           mov ax, word ptr [bp - 0x18]
  0454BD  10BD: 8946ee           mov word ptr [bp - 0x12], ax
  0454C0  10C0: eb6a             jmp 0x112c
  0454C2  10C2: 8b46ce           mov ax, word ptr [bp - 0x32]
  0454C5  10C5: 0b46cc           or ax, word ptr [bp - 0x34]
  0454C8  10C8: 7468             je 0x1132
  0454CA  10CA: c45ecc           les bx, ptr [bp - 0x34]
  0454CD  10CD: 268b07           mov ax, word ptr es:[bx]
  0454D0  10D0: 8bc8             mov cx, ax
  0454D2  10D2: a802             test al, 2
  0454D4  10D4: 7545             jne 0x111b
  0454D6  10D6: 8b46ee           mov ax, word ptr [bp - 0x12]
  0454D9  10D9: 48               dec ax
  0454DA  10DA: 3b06ea07         cmp ax, word ptr [0x7ea]
  0454DE  10DE: 7f35             jg 0x1115
  0454E0  10E0: 8b46f8           mov ax, word ptr [bp - 8]
  0454E3  10E3: 0346ee           add ax, word ptr [bp - 0x12]
  0454E6  10E6: 48               dec ax
  0454E7  10E7: 3b06ea07         cmp ax, word ptr [0x7ea]
  0454EB  10EB: 7e28             jle 0x1115
  0454ED  10ED: f6c101           test cl, 1
  0454F0  10F0: 7523             jne 0x1115
  0454F2  10F2: 26c47706         les si, ptr es:[bx + 6]
  0454F6  10F6: 26803c00         cmp byte ptr es:[si], 0
  0454FA  10FA: 7419             je 0x1115
  0454FC  10FC: 8bc3             mov ax, bx
  0454FE  10FE: 8b56ce           mov dx, word ptr [bp - 0x32]
  045501  1101: 8946d6           mov word ptr [bp - 0x2a], ax
  045504  1104: 8956d8           mov word ptr [bp - 0x28], dx
  045507  1107: b80100           mov ax, 1
  04550A  110A: 8946d2           mov word ptr [bp - 0x2e], ax
  04550D  110D: 8946d0           mov word ptr [bp - 0x30], ax
  045510  1110: c746e00000       mov word ptr [bp - 0x20], 0
  045515  1115: 8b46f8           mov ax, word ptr [bp - 8]
  045518  1118: 0146ee           add word ptr [bp - 0x12], ax
  04551B  111B: 8e46ce           mov es, word ptr [bp - 0x32]
  04551E  111E: 268b470e         mov ax, word ptr es:[bx + 0xe]
  045522  1122: 268b5710         mov dx, word ptr es:[bx + 0x10]
  045526  1126: 8946cc           mov word ptr [bp - 0x34], ax
  045529  1129: 8956ce           mov word ptr [bp - 0x32], dx
  04552C  112C: 837ed200         cmp word ptr [bp - 0x2e], 0
  045530  1130: 7490             je 0x10c2
  045532  1132: 9af6001f18       lcall 0x181f, 0xf6
  045537  1137: 0bc0             or ax, ax
  045539  1139: 7503             jne 0x113e
  04553B  113B: e9dc00           jmp 0x121a
  04553E  113E: 837ef600         cmp word ptr [bp - 0xa], 0
  045542  1142: 7503             jne 0x1147
  045544  1144: e9d300           jmp 0x121a
  045547  1147: 837eec00         cmp word ptr [bp - 0x14], 0
  04554B  114B: 7403             je 0x1150
  04554D  114D: e9ca00           jmp 0x121a
  045550  1150: 9ae0031f18       lcall 0x181f, 0x3e0
  045555  1155: 8946c4           mov word ptr [bp - 0x3c], ax
  045558  1158: 3d0001           cmp ax, 0x100
  04555B  115B: 7d0f             jge 0x116c
  04555D  115D: 8bd8             mov bx, ax
  04555F  115F: f687ed2702       test byte ptr [bx + 0x27ed], 2
  045564  1164: 7406             je 0x116c
  045566  1166: 2d2000           sub ax, 0x20
  045569  1169: 8946c4           mov word ptr [bp - 0x3c], ax
  04556C  116C: c746e00000       mov word ptr [bp - 0x20], 0
  045571  1171: 3d3800           cmp ax, 0x38
  045574  1174: 7424             je 0x119a
  045576  1176: 7e03             jle 0x117b
  045578  1178: e94102           jmp 0x13bc
  04557B  117B: 3d3200           cmp ax, 0x32
  04557E  117E: 7503             jne 0x1183
  045580  1180: e9e100           jmp 0x1264
  045583  1183: 7603             jbe 0x1188
  045585  1185: e95302           jmp 0x13db
  045588  1188: 2c0d             sub al, 0xd
  04558A  118A: 7503             jne 0x118f
  04558C  118C: e9c101           jmp 0x1350
  04558F  118F: 2c0e             sub al, 0xe
  045591  1191: 7503             jne 0x1196
  045593  1193: e9c201           jmp 0x1358
  045596  1196: e94202           jmp 0x13db
  045599  1199: 90               nop 
  04559A  119A: 2bc0             sub ax, ax
  04559C  119C: 8946c8           mov word ptr [bp - 0x38], ax
  04559F  119F: 8946c6           mov word ptr [bp - 0x3a], ax
  0455A2  11A2: 8b46d8           mov ax, word ptr [bp - 0x28]
  0455A5  11A5: 0b46d6           or ax, word ptr [bp - 0x2a]
  0455A8  11A8: 7411             je 0x11bb
  0455AA  11AA: c45ed6           les bx, ptr [bp - 0x2a]
  0455AD  11AD: 268b4712         mov ax, word ptr es:[bx + 0x12]
  0455B1  11B1: 268b5714         mov dx, word ptr es:[bx + 0x14]
  0455B5  11B5: 8946d6           mov word ptr [bp - 0x2a], ax
  0455B8  11B8: 8956d8           mov word ptr [bp - 0x28], dx
  0455BB  11BB: 8b46d8           mov ax, word ptr [bp - 0x28]
  0455BE  11BE: 0b46d6           or ax, word ptr [bp - 0x2a]
  0455C1  11C1: 7539             jne 0x11fc
  0455C3  11C3: c45e06           les bx, ptr [bp + 6]
  0455C6  11C6: 268b471e         mov ax, word ptr es:[bx + 0x1e]
  0455CA  11CA: 268b5720         mov dx, word ptr es:[bx + 0x20]
  0455CE  11CE: 8946d6           mov word ptr [bp - 0x2a], ax
  0455D1  11D1: 8956d8           mov word ptr [bp - 0x28], dx
  0455D4  11D4: c45ed6           les bx, ptr [bp - 0x2a]
  0455D7  11D7: 268b4710         mov ax, word ptr es:[bx + 0x10]
  0455DB  11DB: 260b470e         or ax, word ptr es:[bx + 0xe]
  0455DF  11DF: 740b             je 0x11ec
  0455E1  11E1: 268b470e         mov ax, word ptr es:[bx + 0xe]
  0455E5  11E5: 268b5710         mov dx, word ptr es:[bx + 0x10]
  0455E9  11E9: ebe3             jmp 0x11ce
  0455EB  11EB: 90               nop 
  0455EC  11EC: 837ec600         cmp word ptr [bp - 0x3a], 0
  0455F0  11F0: 7405             je 0x11f7
  0455F2  11F2: c746c80100       mov word ptr [bp - 0x38], 1
  0455F7  11F7: c746c60100       mov word ptr [bp - 0x3a], 1
  0455FC  11FC: c45ed6           les bx, ptr [bp - 0x2a]
  0455FF  11FF: 26f60703         test byte ptr es:[bx], 3
  045603  1203: 750a             jne 0x120f
  045605  1205: 26c45f06         les bx, ptr es:[bx + 6]
  045609  1209: 26803f00         cmp byte ptr es:[bx], 0
  04560D  120D: 7506             jne 0x1215
  04560F  120F: 837ec800         cmp word ptr [bp - 0x38], 0
  045613  1213: 748d             je 0x11a2
  045615  1215: c746d00100       mov word ptr [bp - 0x30], 1
  04561A  121A: bb4000           mov bx, 0x40
  04561D  121D: 8ec3             mov es, bx
  04561F  121F: bb1700           mov bx, 0x17
  045622  1222: 268a07           mov al, byte ptr es:[bx]
  045625  1225: 250800           and ax, 8
  045628  1228: 8946ca           mov word ptr [bp - 0x36], ax
  04562B  122B: 837ee000         cmp word ptr [bp - 0x20], 0
  04562F  122F: 7411             je 0x1242
  045631  1231: 0bc0             or ax, ax
  045633  1233: 750d             jne 0x1242
  045635  1235: 3946e6           cmp word ptr [bp - 0x1a], ax
  045638  1238: 7503             jne 0x123d
  04563A  123A: 8946f6           mov word ptr [bp - 0xa], ax
  04563D  123D: c746e60000       mov word ptr [bp - 0x1a], 0
  045642  1242: 0bc0             or ax, ax
  045644  1244: 7503             jne 0x1249
  045646  1246: e9a501           jmp 0x13ee
  045649  1249: 837ed000         cmp word ptr [bp - 0x30], 0
  04564D  124D: 7403             je 0x1252
  04564F  124F: e99c01           jmp 0x13ee
  045652  1252: 837eec00         cmp word ptr [bp - 0x14], 0
  045656  1256: 7403             je 0x125b
  045658  1258: e99301           jmp 0x13ee
  04565B  125B: c746e00100       mov word ptr [bp - 0x20], 1
  045660  1260: e99001           jmp 0x13f3
  045663  1263: 90               nop 
  045664  1264: 2bc0             sub ax, ax
  045666  1266: 8946c8           mov word ptr [bp - 0x38], ax
  045669  1269: 8946c6           mov word ptr [bp - 0x3a], ax
  04566C  126C: 8b46d8           mov ax, word ptr [bp - 0x28]
  04566F  126F: 0b46d6           or ax, word ptr [bp - 0x2a]
  045672  1272: 7411             je 0x1285
  045674  1274: c45ed6           les bx, ptr [bp - 0x2a]
  045677  1277: 268b470e         mov ax, word ptr es:[bx + 0xe]
  04567B  127B: 268b5710         mov dx, word ptr es:[bx + 0x10]
  04567F  127F: 8946d6           mov word ptr [bp - 0x2a], ax
  045682  1282: 8956d8           mov word ptr [bp - 0x28], dx
  045685  1285: 8b46d8           mov ax, word ptr [bp - 0x28]
  045688  1288: 0b46d6           or ax, word ptr [bp - 0x2a]
  04568B  128B: 7521             jne 0x12ae
  04568D  128D: c45e06           les bx, ptr [bp + 6]
  045690  1290: 268b471e         mov ax, word ptr es:[bx + 0x1e]
  045694  1294: 268b5720         mov dx, word ptr es:[bx + 0x20]
  045698  1298: 8946d6           mov word ptr [bp - 0x2a], ax
  04569B  129B: 8956d8           mov word ptr [bp - 0x28], dx
  04569E  129E: 837ec600         cmp word ptr [bp - 0x3a], 0
  0456A2  12A2: 7405             je 0x12a9
  0456A4  12A4: c746c80100       mov word ptr [bp - 0x38], 1
  0456A9  12A9: c746c60100       mov word ptr [bp - 0x3a], 1
  0456AE  12AE: c45ed6           les bx, ptr [bp - 0x2a]
  0456B1  12B1: 26f60703         test byte ptr es:[bx], 3
  0456B5  12B5: 750d             jne 0x12c4
  0456B7  12B7: 26c45f06         les bx, ptr es:[bx + 6]
  0456BB  12BB: 26803f00         cmp byte ptr es:[bx], 0
  0456BF  12BF: 7403             je 0x12c4
  0456C1  12C1: e951ff           jmp 0x1215
  0456C4  12C4: 837ec800         cmp word ptr [bp - 0x38], 0
  0456C8  12C8: 74a2             je 0x126c
  0456CA  12CA: e948ff           jmp 0x1215
  0456CD  12CD: 90               nop 
  0456CE  12CE: c45e06           les bx, ptr [bp + 6]
  0456D1  12D1: 268b471a         mov ax, word ptr es:[bx + 0x1a]
  0456D5  12D5: 268b571c         mov dx, word ptr es:[bx + 0x1c]
  0456D9  12D9: 894606           mov word ptr [bp + 6], ax
  0456DC  12DC: 895608           mov word ptr [bp + 8], dx
  0456DF  12DF: 0bd0             or dx, ax
  0456E1  12E1: 7529             jne 0x130c
  0456E3  12E3: c45ef2           les bx, ptr [bp - 0xe]
  0456E6  12E6: 268b4738         mov ax, word ptr es:[bx + 0x38]
  0456EA  12EA: 268b573a         mov dx, word ptr es:[bx + 0x3a]
  0456EE  12EE: 894606           mov word ptr [bp + 6], ax
  0456F1  12F1: 895608           mov word ptr [bp + 8], dx
  0456F4  12F4: c45e06           les bx, ptr [bp + 6]
  0456F7  12F7: 268b4718         mov ax, word ptr es:[bx + 0x18]
  0456FB  12FB: 260b4716         or ax, word ptr es:[bx + 0x16]
  0456FF  12FF: 740b             je 0x130c
  045701  1301: 268b4716         mov ax, word ptr es:[bx + 0x16]
  045705  1305: 268b5718         mov dx, word ptr es:[bx + 0x18]
  045709  1309: ebe3             jmp 0x12ee
  04570B  130B: 90               nop 
  04570C  130C: c45e06           les bx, ptr [bp + 6]
  04570F  130F: 26f6470c01       test byte ptr es:[bx + 0xc], 1
  045714  1314: 75b8             jne 0x12ce
  045716  1316: c746ec0100       mov word ptr [bp - 0x14], 1
  04571B  131B: e9fcfe           jmp 0x121a
  04571E  131E: c45e06           les bx, ptr [bp + 6]
  045721  1321: 268b4716         mov ax, word ptr es:[bx + 0x16]
  045725  1325: 268b5718         mov dx, word ptr es:[bx + 0x18]
  045729  1329: 894606           mov word ptr [bp + 6], ax
  04572C  132C: 895608           mov word ptr [bp + 8], dx
  04572F  132F: 0bd0             or dx, ax
  045731  1331: 7511             jne 0x1344
  045733  1333: c45ef2           les bx, ptr [bp - 0xe]
  045736  1336: 268b4738         mov ax, word ptr es:[bx + 0x38]
  04573A  133A: 268b573a         mov dx, word ptr es:[bx + 0x3a]
  04573E  133E: 894606           mov word ptr [bp + 6], ax
  045741  1341: 895608           mov word ptr [bp + 8], dx
  045744  1344: c45e06           les bx, ptr [bp + 6]
  045747  1347: 26f6470c01       test byte ptr es:[bx + 0xc], 1
  04574C  134C: 75d0             jne 0x131e
  04574E  134E: ebc6             jmp 0x1316
  045750  1350: c746f60000       mov word ptr [bp - 0xa], 0
  045755  1355: e9c2fe           jmp 0x121a
  045758  1358: c746f60000       mov word ptr [bp - 0xa], 0
  04575D  135D: 2bc0             sub ax, ax
  04575F  135F: 8946d8           mov word ptr [bp - 0x28], ax
  045762  1362: 8946d6           mov word ptr [bp - 0x2a], ax
  045765  1365: e9b2fe           jmp 0x121a
  045768  1368: 8b46ce           mov ax, word ptr [bp - 0x32]
  04576B  136B: 0b46cc           or ax, word ptr [bp - 0x34]
  04576E  136E: 742e             je 0x139e
  045770  1370: 8b46c4           mov ax, word ptr [bp - 0x3c]
  045773  1373: c45ecc           les bx, ptr [bp - 0x34]
  045776  1376: 26394702         cmp word ptr es:[bx + 2], ax
  04577A  137A: 750e             jne 0x138a
  04577C  137C: 26f60703         test byte ptr es:[bx], 3
  045780  1380: 7508             jne 0x138a
  045782  1382: c746d20100       mov word ptr [bp - 0x2e], 1
  045787  1387: eb0f             jmp 0x1398
  045789  1389: 90               nop 
  04578A  138A: 268b470e         mov ax, word ptr es:[bx + 0xe]
  04578E  138E: 268b5710         mov dx, word ptr es:[bx + 0x10]
  045792  1392: 8946cc           mov word ptr [bp - 0x34], ax
  045795  1395: 8956ce           mov word ptr [bp - 0x32], dx
  045798  1398: 837ed200         cmp word ptr [bp - 0x2e], 0
  04579C  139C: 74ca             je 0x1368
  04579E  139E: 837ed200         cmp word ptr [bp - 0x2e], 0
  0457A2  13A2: 7503             jne 0x13a7
  0457A4  13A4: e973fe           jmp 0x121a
  0457A7  13A7: 8b46cc           mov ax, word ptr [bp - 0x34]
  0457AA  13AA: 8b56ce           mov dx, word ptr [bp - 0x32]
  0457AD  13AD: 8946d6           mov word ptr [bp - 0x2a], ax
  0457B0  13B0: 8956d8           mov word ptr [bp - 0x28], dx
  0457B3  13B3: c746f60000       mov word ptr [bp - 0xa], 0
  0457B8  13B8: e95afe           jmp 0x1215
  0457BB  13BB: 90               nop 
  0457BC  13BC: 2d4801           sub ax, 0x148
  0457BF  13BF: 7503             jne 0x13c4
  0457C1  13C1: e9d6fd           jmp 0x119a
  0457C4  13C4: 2d0300           sub ax, 3
  0457C7  13C7: 7503             jne 0x13cc
  0457C9  13C9: e902ff           jmp 0x12ce
  0457CC  13CC: 48               dec ax
  0457CD  13CD: 48               dec ax
  0457CE  13CE: 7503             jne 0x13d3
  0457D0  13D0: e94bff           jmp 0x131e
  0457D3  13D3: 2d0300           sub ax, 3
  0457D6  13D6: 7503             jne 0x13db
  0457D8  13D8: e989fe           jmp 0x1264
  0457DB  13DB: c746d20000       mov word ptr [bp - 0x2e], 0
  0457E0  13E0: c45e06           les bx, ptr [bp + 6]
  0457E3  13E3: 268b471e         mov ax, word ptr es:[bx + 0x1e]
  0457E7  13E7: 268b5720         mov dx, word ptr es:[bx + 0x20]
  0457EB  13EB: eba5             jmp 0x1392
  0457ED  13ED: 90               nop 
  0457EE  13EE: c746e00000       mov word ptr [bp - 0x20], 0
  0457F3  13F3: 837ed000         cmp word ptr [bp - 0x30], 0
  0457F7  13F7: 741e             je 0x1417
  0457F9  13F9: 837eec00         cmp word ptr [bp - 0x14], 0
  0457FD  13FD: 7518             jne 0x1417
  0457FF  13FF: ff76d8           push word ptr [bp - 0x28]
  045802  1402: ff76d6           push word ptr [bp - 0x2a]
  045805  1405: ff7608           push word ptr [bp + 8]
  045808  1408: ff7606           push word ptr [bp + 6]
  04580B  140B: 0e               push cs
  04580C  140C: e8fc03           call 0x180b
  04580F  140F: 83c408           add sp, 8
  045812  1412: c746d00000       mov word ptr [bp - 0x30], 0
  045817  1417: 833ef40700       cmp word ptr [0x7f4], 0
  04581C  141C: 7412             je 0x1430
  04581E  141E: 8b46d8           mov ax, word ptr [bp - 0x28]
  045821  1421: 0b46d6           or ax, word ptr [bp - 0x2a]
  045824  1424: 7474             je 0x149a
  045826  1426: c746f60000       mov word ptr [bp - 0xa], 0
  04582B  142B: c746dc0000       mov word ptr [bp - 0x24], 0
  045830  1430: 2bc0             sub ax, ax
  045832  1432: 8b56f6           mov dx, word ptr [bp - 0xa]
  045835  1435: 9a5c041f18       lcall 0x181f, 0x45c
  04583A  143A: 837ef600         cmp word ptr [bp - 0xa], 0
  04583E  143E: 7409             je 0x1449
  045840  1440: 837eec00         cmp word ptr [bp - 0x14], 0
  045844  1444: 7503             jne 0x1449
  045846  1446: e966fb           jmp 0xfaf
  045849  1449: ff76e4           push word ptr [bp - 0x1c]
  04584C  144C: ff76e2           push word ptr [bp - 0x1e]
  04584F  144F: ff76da           push word ptr [bp - 0x26]
  045852  1452: ff76d4           push word ptr [bp - 0x2c]
  045855  1455: 8d1ea82d         lea bx, [0x2da8]
  045859  1459: 8b46ea           mov ax, word ptr [bp - 0x16]
  04585C  145C: baffff           mov dx, 0xffff
  04585F  145F: 9a8a031f1a       lcall 0x1a1f, 0x38a
  045864  1464: ff76e2           push word ptr [bp - 0x1e]
  045867  1467: ff76da           push word ptr [bp - 0x26]
  04586A  146A: ff76d4           push word ptr [bp - 0x2c]
  04586D  146D: 8b46e4           mov ax, word ptr [bp - 0x1c]
  045870  1470: 8b56e2           mov dx, word ptr [bp - 0x1e]
  045873  1473: 8bd8             mov bx, ax
  045875  1475: 9ae2001f18       lcall 0x181f, 0xe2
  04587A  147A: 837ef600         cmp word ptr [bp - 0xa], 0
  04587E  147E: 7403             je 0x1483
  045880  1480: e98afa           jmp 0xf0d
  045883  1483: 8b46d8           mov ax, word ptr [bp - 0x28]
  045886  1486: 0b46d6           or ax, word ptr [bp - 0x2a]
  045889  1489: 743b             je 0x14c6
  04588B  148B: c45ed6           les bx, ptr [bp - 0x2a]
  04588E  148E: 268b4704         mov ax, word ptr es:[bx + 4]
  045892  1492: c45ef2           les bx, ptr [bp - 0xe]
  045895  1495: 268907           mov word ptr es:[bx], ax
  045898  1498: eb34             jmp 0x14ce
  04589A  149A: 837edc00         cmp word ptr [bp - 0x24], 0
  04589E  149E: 7486             je 0x1426
  0458A0  14A0: c45ef2           les bx, ptr [bp - 0xe]
  0458A3  14A3: 26ff772a         push word ptr es:[bx + 0x2a]
  0458A7  14A7: 26ff7728         push word ptr es:[bx + 0x28]
  0458AB  14AB: e892ec           call 0x140
  0458AE  14AE: 83c404           add sp, 4
  0458B1  14B1: c45ef2           les bx, ptr [bp - 0xe]
  0458B4  14B4: 26034704         add ax, word ptr es:[bx + 4]
  0458B8  14B8: 40               inc ax
  0458B9  14B9: 3b06ea07         cmp ax, word ptr [0x7ea]
  0458BD  14BD: 7c03             jl 0x14c2
  0458BF  14BF: e969ff           jmp 0x142b
  0458C2  14C2: e961ff           jmp 0x1426
  0458C5  14C5: 90               nop 
  0458C6  14C6: c45ef2           les bx, ptr [bp - 0xe]
  0458C9  14C9: 26c7070000       mov word ptr es:[bx], 0
  0458CE  14CE: 9a7a041f18       lcall 0x181f, 0x47a
  0458D3  14D3: 6a01             push 1
  0458D5  14D5: 6a00             push 0
  0458D7  14D7: 6a00             push 0
  0458D9  14D9: ff76f4           push word ptr [bp - 0xc]
  0458DC  14DC: ff76f2           push word ptr [bp - 0xe]
  0458DF  14DF: 0e               push cs
  0458E0  14E0: e80503           call 0x17e8
  0458E3  14E3: 83c40a           add sp, 0xa
  0458E6  14E6: 5e               pop si
  0458E7  14E7: c9               leave 
  0458E8  14E8: ca0400           retf 4

; ---- func_0458EC  size=158  insns=64  prologue=ENTER 0x0006,0  terminal=RETF imm16 ----
  0458EC  14EC: c8060000         enter 6, 0
  0458F0  14F0: 50               push ax
  0458F1  14F1: 57               push di
  0458F2  14F2: 56               push si
  0458F3  14F3: 8b7e06           mov di, word ptr [bp + 6]
  0458F6  14F6: 2bc0             sub ax, ax
  0458F8  14F8: 8946fa           mov word ptr [bp - 6], ax
  0458FB  14FB: 8e4608           mov es, word ptr [bp + 8]
  0458FE  14FE: 268905           mov word ptr es:[di], ax
  045901  1501: 3906ec07         cmp word ptr [0x7ec], ax
  045905  1505: 747a             je 0x1581
  045907  1507: 26ff752a         push word ptr es:[di + 0x2a]
  04590B  150B: 26ff7528         push word ptr es:[di + 0x28]
  04590F  150F: 8cc6             mov si, es
  045911  1511: e82cec           call 0x140
  045914  1514: 83c404           add sp, 4
  045917  1517: 8ec6             mov es, si
  045919  1519: 268b7504         mov si, word ptr es:[di + 4]
  04591D  151D: 03f0             add si, ax
  04591F  151F: 46               inc si
  045920  1520: 3b36ea07         cmp si, word ptr [0x7ea]
  045924  1524: 7c5b             jl 0x1581
  045926  1526: 2bc9             sub cx, cx
  045928  1528: 26c57538         lds si, ptr es:[di + 0x38]
  04592C  152C: 8cd8             mov ax, ds
  04592E  152E: 0bc6             or ax, si
  045930  1530: 7429             je 0x155b
  045932  1532: 368b1ee807       mov bx, word ptr ss:[0x7e8]
  045937  1537: 0bc9             or cx, cx
  045939  1539: 7520             jne 0x155b
  04593B  153B: 8b4402           mov ax, word ptr [si + 2]
  04593E  153E: 034404           add ax, word ptr [si + 4]
  045941  1541: 3bc3             cmp ax, bx
  045943  1543: 7c0d             jl 0x1552
  045945  1545: f6440c01         test byte ptr [si + 0xc], 1
  045949  1549: 7507             jne 0x1552
  04594B  154B: b90100           mov cx, 1
  04594E  154E: eb05             jmp 0x1555
  045950  1550: 90               nop 
  045951  1551: 90               nop 
  045952  1552: c57416           lds si, ptr [si + 0x16]
  045955  1555: 8cd8             mov ax, ds
  045957  1557: 0bc6             or ax, si
  045959  1559: 75dc             jne 0x1537
  04595B  155B: 0bc9             or cx, cx
  04595D  155D: 7507             jne 0x1566
  04595F  155F: b85a1b           mov ax, 0x1b5a
  045962  1562: 8ed8             mov ds, ax
  045964  1564: eb1b             jmp 0x1581
  045966  1566: c746fa0100       mov word ptr [bp - 6], 1
  04596B  156B: 837ef800         cmp word ptr [bp - 8], 0
  04596F  156F: 74ee             je 0x155f
  045971  1571: 8c5efe           mov word ptr [bp - 2], ds
  045974  1574: b85a1b           mov ax, 0x1b5a
  045977  1577: 8ed8             mov ds, ax
  045979  1579: ff76fe           push word ptr [bp - 2]
  04597C  157C: 56               push si
  04597D  157D: 0e               push cs
  04597E  157E: e86c02           call 0x17ed
  045981  1581: 8b46fa           mov ax, word ptr [bp - 6]
  045984  1584: 5e               pop si
  045985  1585: 5f               pop di
  045986  1586: c9               leave 
  045987  1587: ca0400           retf 4

; ---- func_04598A  size=147  insns=57  prologue=ENTER 0x000A,0  terminal=RETF imm16 ----
  04598A  158A: c80a0000         enter 0xa, 0
  04598E  158E: 57               push di
  04598F  158F: 56               push si
  045990  1590: 8bf8             mov di, ax
  045992  1592: 8b5e06           mov bx, word ptr [bp + 6]
  045995  1595: 8e4608           mov es, word ptr [bp + 8]
  045998  1598: 268b4738         mov ax, word ptr es:[bx + 0x38]
  04599C  159C: 268b573a         mov dx, word ptr es:[bx + 0x3a]
  0459A0  15A0: 8bf0             mov si, ax
  0459A2  15A2: 8956f8           mov word ptr [bp - 8], dx
  0459A5  15A5: 2bc0             sub ax, ax
  0459A7  15A7: 8946fa           mov word ptr [bp - 6], ax
  0459AA  15AA: 268907           mov word ptr es:[bx], ax
  0459AD  15AD: 8946fc           mov word ptr [bp - 4], ax
  0459B0  15B0: 8bc7             mov ax, di
  0459B2  15B2: 9a80031f1a       lcall 0x1a1f, 0x380
  0459B7  15B7: 8946fe           mov word ptr [bp - 2], ax
  0459BA  15BA: 3bc7             cmp ax, di
  0459BC  15BC: 7426             je 0x15e4
  0459BE  15BE: 8b46f8           mov ax, word ptr [bp - 8]
  0459C1  15C1: 0bc6             or ax, si
  0459C3  15C3: 741f             je 0x15e4
  0459C5  15C5: 8b4efc           mov cx, word ptr [bp - 4]
  0459C8  15C8: 8b5efe           mov bx, word ptr [bp - 2]
  0459CB  15CB: 0bc9             or cx, cx
  0459CD  15CD: 752f             jne 0x15fe
  0459CF  15CF: 8e46f8           mov es, word ptr [bp - 8]
  0459D2  15D2: 26395c08         cmp word ptr es:[si + 8], bx
  0459D6  15D6: 7512             jne 0x15ea
  0459D8  15D8: 26f6440c01       test byte ptr es:[si + 0xc], 1
  0459DD  15DD: 750b             jne 0x15ea
  0459DF  15DF: b90100           mov cx, 1
  0459E2  15E2: eb13             jmp 0x15f7
  0459E4  15E4: 8b4efc           mov cx, word ptr [bp - 4]
  0459E7  15E7: eb15             jmp 0x15fe
  0459E9  15E9: 90               nop 
  0459EA  15EA: 268b4416         mov ax, word ptr es:[si + 0x16]
  0459EE  15EE: 268b5418         mov dx, word ptr es:[si + 0x18]
  0459F2  15F2: 8bf0             mov si, ax
  0459F4  15F4: 8956f8           mov word ptr [bp - 8], dx
  0459F7  15F7: 8b46f8           mov ax, word ptr [bp - 8]
  0459FA  15FA: 0bc6             or ax, si
  0459FC  15FC: 75cd             jne 0x15cb
  0459FE  15FE: 8b7efa           mov di, word ptr [bp - 6]
  045A01  1601: 0bc9             or cx, cx
  045A03  1603: 740b             je 0x1610
  045A05  1605: ff76f8           push word ptr [bp - 8]
  045A08  1608: 56               push si
  045A09  1609: 0e               push cs
  045A0A  160A: e8e001           call 0x17ed
  045A0D  160D: bf0100           mov di, 1
  045A10  1610: 9a7a041f18       lcall 0x181f, 0x47a
  045A15  1615: 8bc7             mov ax, di
  045A17  1617: 5e               pop si
  045A18  1618: 5f               pop di
  045A19  1619: c9               leave 
  045A1A  161A: ca0400           retf 4

; ---- func_045A1E  size=198  insns=75  prologue=ENTER 0x0014,0  terminal=RETF imm16 ----
  045A1E  161E: c8140000         enter 0x14, 0
  045A22  1622: 50               push ax
  045A23  1623: 57               push di
  045A24  1624: 56               push si
  045A25  1625: c47606           les si, ptr [bp + 6]
  045A28  1628: 2bc0             sub ax, ax
  045A2A  162A: 99               cdq 
  045A2B  162B: 8bc8             mov cx, ax
  045A2D  162D: 8956f4           mov word ptr [bp - 0xc], dx
  045A30  1630: 268b4438         mov ax, word ptr es:[si + 0x38]
  045A34  1634: 268b543a         mov dx, word ptr es:[si + 0x3a]
  045A38  1638: 8bd8             mov bx, ax
  045A3A  163A: 8956f0           mov word ptr [bp - 0x10], dx
  045A3D  163D: 2bff             sub di, di
  045A3F  163F: 897eec           mov word ptr [bp - 0x14], di
  045A42  1642: 26893c           mov word ptr es:[si], di
  045A45  1645: 897efa           mov word ptr [bp - 6], di
  045A48  1648: 894ef2           mov word ptr [bp - 0xe], cx
  045A4B  164B: 0bd0             or dx, ax
  045A4D  164D: 7474             je 0x16c3
  045A4F  164F: 8bf1             mov si, cx
  045A51  1651: 8b4efa           mov cx, word ptr [bp - 6]
  045A54  1654: 0bc9             or cx, cx
  045A56  1656: 7568             jne 0x16c0
  045A58  1658: 8e46f0           mov es, word ptr [bp - 0x10]
  045A5B  165B: 26f6470c01       test byte ptr es:[bx + 0xc], 1
  045A60  1660: 754a             jne 0x16ac
  045A62  1662: 268b471e         mov ax, word ptr es:[bx + 0x1e]
  045A66  1666: 268b5720         mov dx, word ptr es:[bx + 0x20]
  045A6A  166A: 8bf0             mov si, ax
  045A6C  166C: 8956f4           mov word ptr [bp - 0xc], dx
  045A6F  166F: 0bd0             or dx, ax
  045A71  1671: 7439             je 0x16ac
  045A73  1673: 895eee           mov word ptr [bp - 0x12], bx
  045A76  1676: 8b5eea           mov bx, word ptr [bp - 0x16]
  045A79  1679: 0bc9             or cx, cx
  045A7B  167B: 7529             jne 0x16a6
  045A7D  167D: 8e46f4           mov es, word ptr [bp - 0xc]
  045A80  1680: 26395c02         cmp word ptr es:[si + 2], bx
  045A84  1684: 750c             jne 0x1692
  045A86  1686: 26f60403         test byte ptr es:[si], 3
  045A8A  168A: 7506             jne 0x1692
  045A8C  168C: b90100           mov cx, 1
  045A8F  168F: eb0e             jmp 0x169f
  045A91  1691: 90               nop 
  045A92  1692: 268b440e         mov ax, word ptr es:[si + 0xe]
  045A96  1696: 268b5410         mov dx, word ptr es:[si + 0x10]
  045A9A  169A: 8bf0             mov si, ax
  045A9C  169C: 8956f4           mov word ptr [bp - 0xc], dx
  045A9F  169F: 8b46f4           mov ax, word ptr [bp - 0xc]
  045AA2  16A2: 0bc6             or ax, si
  045AA4  16A4: 75d3             jne 0x1679
  045AA6  16A6: 894efa           mov word ptr [bp - 6], cx
  045AA9  16A9: 8b5eee           mov bx, word ptr [bp - 0x12]
  045AAC  16AC: 8e46f0           mov es, word ptr [bp - 0x10]
  045AAF  16AF: 268b4716         mov ax, word ptr es:[bx + 0x16]
  045AB3  16B3: 268b5718         mov dx, word ptr es:[bx + 0x18]
  045AB7  16B7: 8bd8             mov bx, ax
  045AB9  16B9: 8956f0           mov word ptr [bp - 0x10], dx
  045ABC  16BC: 0bd0             or dx, ax
  045ABE  16BE: 7591             jne 0x1651
  045AC0  16C0: 8976f2           mov word ptr [bp - 0xe], si
  045AC3  16C3: 8b5eec           mov bx, word ptr [bp - 0x14]
  045AC6  16C6: 8b7ef2           mov di, word ptr [bp - 0xe]
  045AC9  16C9: 837efa00         cmp word ptr [bp - 6], 0
  045ACD  16CD: 740d             je 0x16dc
  045ACF  16CF: 8e46f4           mov es, word ptr [bp - 0xc]
  045AD2  16D2: 268b5d04         mov bx, word ptr es:[di + 4]
  045AD6  16D6: c47606           les si, ptr [bp + 6]
  045AD9  16D9: 26891c           mov word ptr es:[si], bx
  045ADC  16DC: 8bc3             mov ax, bx
  045ADE  16DE: 5e               pop si
  045ADF  16DF: 5f               pop di
  045AE0  16E0: c9               leave 
  045AE1  16E1: ca0400           retf 4

; ---- func_045AE4  size=310  insns=114  prologue=ENTER 0x000E,0  terminal=page-end ----
  045AE4  16E4: c80e0000         enter 0xe, 0
  045AE8  16E8: 57               push di
  045AE9  16E9: 56               push si
  045AEA  16EA: b80100           mov ax, 1
  045AED  16ED: 8946f4           mov word ptr [bp - 0xc], ax
  045AF0  16F0: 8946f2           mov word ptr [bp - 0xe], ax
  045AF3  16F3: 8d46ff           lea ax, [bp - 1]
  045AF6  16F6: 8946f6           mov word ptr [bp - 0xa], ax
  045AF9  16F9: 8c56f8           mov word ptr [bp - 8], ss
  045AFC  16FC: 8d1ebc14         lea bx, [0x14bc]
  045B00  1700: 2bc0             sub ax, ax
  045B02  1702: 9a72031f1a       lcall 0x1a1f, 0x372
  045B07  1707: 8bf0             mov si, ax
  045B09  1709: 8956fc           mov word ptr [bp - 4], dx
  045B0C  170C: 0bd0             or dx, ax
  045B0E  170E: 7503             jne 0x1713
  045B10  1710: e9d000           jmp 0x17e3
  045B13  1713: 8b46fc           mov ax, word ptr [bp - 4]
  045B16  1716: 50               push ax
  045B17  1717: 56               push si
  045B18  1718: 6a00             push 0
  045B1A  171A: 8bf8             mov di, ax
  045B1C  171C: b80100           mov ax, 1
  045B1F  171F: 8d5ef2           lea bx, [bp - 0xe]
  045B22  1722: 2bd2             sub dx, dx
  045B24  1724: 9a54021f18       lcall 0x181f, 0x254
  045B29  1729: 8a46ff           mov al, byte ptr [bp - 1]
  045B2C  172C: 2ae4             sub ah, ah
  045B2E  172E: a39c14           mov word ptr [0x149c], ax
  045B31  1731: a3a014           mov word ptr [0x14a0], ax
  045B34  1734: 57               push di
  045B35  1735: 56               push si
  045B36  1736: 6a00             push 0
  045B38  1738: b80200           mov ax, 2
  045B3B  173B: 8d5ef2           lea bx, [bp - 0xe]
  045B3E  173E: 2bd2             sub dx, dx
  045B40  1740: 9a54021f18       lcall 0x181f, 0x254
  045B45  1745: 8a46ff           mov al, byte ptr [bp - 1]
  045B48  1748: 2ae4             sub ah, ah
  045B4A  174A: a39e14           mov word ptr [0x149e], ax
  045B4D  174D: a3a214           mov word ptr [0x14a2], ax
  045B50  1750: 57               push di
  045B51  1751: 56               push si
  045B52  1752: 6a00             push 0
  045B54  1754: b80300           mov ax, 3
  045B57  1757: 8d5ef2           lea bx, [bp - 0xe]
  045B5A  175A: 2bd2             sub dx, dx
  045B5C  175C: 9a54021f18       lcall 0x181f, 0x254
  045B61  1761: 8a46ff           mov al, byte ptr [bp - 1]
  045B64  1764: 2ae4             sub ah, ah
  045B66  1766: a3a814           mov word ptr [0x14a8], ax
  045B69  1769: a3a414           mov word ptr [0x14a4], ax
  045B6C  176C: 57               push di
  045B6D  176D: 56               push si
  045B6E  176E: 6a00             push 0
  045B70  1770: b80400           mov ax, 4
  045B73  1773: 8d5ef2           lea bx, [bp - 0xe]
  045B76  1776: 2bd2             sub dx, dx
  045B78  1778: 9a54021f18       lcall 0x181f, 0x254
  045B7D  177D: 8a46ff           mov al, byte ptr [bp - 1]
  045B80  1780: 2ae4             sub ah, ah
  045B82  1782: a3aa14           mov word ptr [0x14aa], ax
  045B85  1785: a3a614           mov word ptr [0x14a6], ax
  045B88  1788: 57               push di
  045B89  1789: 56               push si
  045B8A  178A: 6a00             push 0
  045B8C  178C: b80500           mov ax, 5
  045B8F  178F: 8d5ef2           lea bx, [bp - 0xe]
  045B92  1792: 2bd2             sub dx, dx
  045B94  1794: 9a54021f18       lcall 0x181f, 0x254
  045B99  1799: 8a46ff           mov al, byte ptr [bp - 1]
  045B9C  179C: 2ae4             sub ah, ah
  045B9E  179E: a3b414           mov word ptr [0x14b4], ax
  045BA1  17A1: a3ae14           mov word ptr [0x14ae], ax
  045BA4  17A4: 57               push di
  045BA5  17A5: 56               push si
  045BA6  17A6: 6a00             push 0
  045BA8  17A8: b80600           mov ax, 6
  045BAB  17AB: 8d5ef2           lea bx, [bp - 0xe]
  045BAE  17AE: 2bd2             sub dx, dx
  045BB0  17B0: 9a54021f18       lcall 0x181f, 0x254
  045BB5  17B5: 8a46ff           mov al, byte ptr [bp - 1]
  045BB8  17B8: 2ae4             sub ah, ah
  045BBA  17BA: a3b814           mov word ptr [0x14b8], ax
  045BBD  17BD: a3b214           mov word ptr [0x14b2], ax
  045BC0  17C0: 57               push di
  045BC1  17C1: 56               push si
  045BC2  17C2: 6a00             push 0
  045BC4  17C4: b80700           mov ax, 7
  045BC7  17C7: 8d5ef2           lea bx, [bp - 0xe]
  045BCA  17CA: 2bd2             sub dx, dx
  045BCC  17CC: 9a54021f18       lcall 0x181f, 0x254
  045BD1  17D1: 8a46ff           mov al, byte ptr [bp - 1]
  045BD4  17D4: 2ae4             sub ah, ah
  045BD6  17D6: a3b414           mov word ptr [0x14b4], ax
  045BD9  17D9: a3b014           mov word ptr [0x14b0], ax
  045BDC  17DC: 57               push di
  045BDD  17DD: 56               push si
  045BDE  17DE: 9aa8011f19       lcall 0x191f, 0x1a8
  045BE3  17E3: 5e               pop si
  045BE4  17E4: 5f               pop di
  045BE5  17E5: c9               leave 
  045BE6  17E6: cb               retf 
  045BE7  17E7: 90               nop 
  045BE8  17E8: ea520e1f18       ljmp 0x181f:0xe52
  045BED  17ED: ea72041f19       ljmp 0x191f:0x472
  045BF2  17F2: eade021f1a       ljmp 0x1a1f:0x2de
  045BF7  17F7: eaea021f1a       ljmp 0x1a1f:0x2ea
  045BFC  17FC: eaf6021f1a       ljmp 0x1a1f:0x2f6
  045C01  1801: ea02031f1a       ljmp 0x1a1f:0x302
  045C06  1806: ea0e031f1a       ljmp 0x1a1f:0x30e
  045C0B  180B: ea26031f1a       ljmp 0x1a1f:0x326
  045C10  1810: ea32031f1a       ljmp 0x1a1f:0x332
  045C15  1815: ea4a031f1a       ljmp 0x1a1f:0x34a
