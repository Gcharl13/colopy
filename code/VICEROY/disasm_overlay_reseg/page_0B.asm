; ============================================================
; VICEROY.EXE overlay page 0x0B (record 10) -- RE-SEGMENTED
; file_offset (disk image) = 0x045C20
; code_offset (first insn) = 0x045D00
; code_end (next reloc hdr)= 0x046600  [resident size 144 para -> nominal_end 0x046520; on-disk code spills past it]
; reloc_count = 43  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x045C20)
; functions in page = 7
; ============================================================

; ---- func_045D00  size=145  insns=48  prologue=ENTER 0x0004,0  terminal=RETF ----
  045D00  00E0: c8040000         enter 4, 0
  045D04  00E4: 2bc0             sub ax, ax
  045D06  00E6: 8946fe           mov word ptr [bp - 2], ax
  045D09  00E9: 8946fc           mov word ptr [bp - 4], ax
  045D0C  00EC: eb27             jmp 0x115
  045D0E  00EE: 6bd812           imul bx, ax, 0x12
  045D11  00F1: 8a87ee54         mov al, byte ptr [bx + 0x54ee]
  045D15  00F5: 2a4606           sub al, byte ptr [bp + 6]
  045D18  00F8: 3c04             cmp al, 4
  045D1A  00FA: 7516             jne 0x112
  045D1C  00FC: 8a87f154         mov al, byte ptr [bx + 0x54f1]
  045D20  0100: 250f00           and ax, 0xf
  045D23  0103: 3b4608           cmp ax, word ptr [bp + 8]
  045D26  0106: 750a             jne 0x112
  045D28  0108: c746fe0100       mov word ptr [bp - 2], 1
  045D2D  010D: c687f154ff       mov byte ptr [bx + 0x54f1], 0xff
  045D32  0112: ff46fc           inc word ptr [bp - 4]
  045D35  0115: 8b46fc           mov ax, word ptr [bp - 4]
  045D38  0118: 39069a53         cmp word ptr [0x539a], ax
  045D3C  011C: 7fd0             jg 0xee
  045D3E  011E: 837efe00         cmp word ptr [bp - 2], 0
  045D42  0122: 744b             je 0x16f
  045D44  0124: 8b4606           mov ax, word ptr [bp + 6]
  045D47  0127: 050400           add ax, 4
  045D4A  012A: 50               push ax
  045D4B  012B: 9a1a0a1f18       lcall 0x181f, 0xa1a
  045D50  0130: 83c402           add sp, 2
  045D53  0133: 50               push ax
  045D54  0134: 6a00             push 0
  045D56  0136: 9a38041f18       lcall 0x181f, 0x438
  045D5B  013B: 83c404           add sp, 4
  045D5E  013E: ff7608           push word ptr [bp + 8]
  045D61  0141: 9aa4091f18       lcall 0x181f, 0x9a4
  045D66  0146: 83c402           add sp, 2
  045D69  0149: 50               push ax
  045D6A  014A: 6a01             push 1
  045D6C  014C: 9a38041f18       lcall 0x181f, 0x438
  045D71  0151: 83c404           add sp, 4
  045D74  0154: 837e0804         cmp word ptr [bp + 8], 4
  045D78  0158: 7d15             jge 0x16f
  045D7A  015A: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  045D7E  015E: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  045D83  0163: 750a             jne 0x16f
  045D85  0165: 6a01             push 1
  045D87  0167: 68c814           push 0x14c8
  045D8A  016A: 9a52061f18       lcall 0x181f, 0x652
  045D8F  016F: c9               leave 
  045D90  0170: cb               retf 

; ---- func_045D92  size=95  insns=35  prologue=push bp;mov bp,sp  terminal=RETF ----
  045D92  0172: 55               push bp
  045D93  0173: 8bec             mov bp, sp
  045D95  0175: 837e0a04         cmp word ptr [bp + 0xa], 4
  045D99  0179: 7d37             jge 0x1b2
  045D9B  017B: 6b5e0a34         imul bx, word ptr [bp + 0xa], 0x34
  045D9F  017F: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  045DA4  0184: 752c             jne 0x1b2
  045DA6  0186: 837e0600         cmp word ptr [bp + 6], 0
  045DAA  018A: 7426             je 0x1b2
  045DAC  018C: 8b4608           mov ax, word ptr [bp + 8]
  045DAF  018F: 050400           add ax, 4
  045DB2  0192: 50               push ax
  045DB3  0193: 9a1a0a1f18       lcall 0x181f, 0xa1a
  045DB8  0198: 8be5             mov sp, bp
  045DBA  019A: 50               push ax
  045DBB  019B: 6a00             push 0
  045DBD  019D: 9a38041f18       lcall 0x181f, 0x438
  045DC2  01A2: 8be5             mov sp, bp
  045DC4  01A4: 8d1e7c08         lea bx, [0x87c]
  045DC8  01A8: 8b4606           mov ax, word ptr [bp + 6]
  045DCB  01AB: 2bd2             sub dx, dx
  045DCD  01AD: 9a98091f18       lcall 0x181f, 0x998
  045DD2  01B2: 6a40             push 0x40
  045DD4  01B4: ff760a           push word ptr [bp + 0xa]
  045DD7  01B7: 8b4608           mov ax, word ptr [bp + 8]
  045DDA  01BA: 050400           add ax, 4
  045DDD  01BD: 50               push ax
  045DDE  01BE: 9a100a1f18       lcall 0x181f, 0xa10
  045DE3  01C3: 8be5             mov sp, bp
  045DE5  01C5: ff760a           push word ptr [bp + 0xa]
  045DE8  01C8: ff7608           push word ptr [bp + 8]
  045DEB  01CB: 0e               push cs
  045DEC  01CC: e8ff07           call 0x9ce
  045DEF  01CF: c9               leave 
  045DF0  01D0: cb               retf 

; ---- func_045DF2  size=529  insns=193  prologue=ENTER 0x0064,0  terminal=RETF ----
  045DF2  01D2: c8640000         enter 0x64, 0
  045DF6  01D6: 56               push si
  045DF7  01D7: 6a64             push 0x64
  045DF9  01D9: 6a00             push 0
  045DFB  01DB: ff7608           push word ptr [bp + 8]
  045DFE  01DE: ff7606           push word ptr [bp + 6]
  045E01  01E1: 9a0c031f18       lcall 0x181f, 0x30c
  045E06  01E6: 83c404           add sp, 4
  045E09  01E9: 50               push ax
  045E0A  01EA: 9a5c031f18       lcall 0x181f, 0x35c
  045E0F  01EF: 83c406           add sp, 6
  045E12  01F2: 8946a4           mov word ptr [bp - 0x5c], ax
  045E15  01F5: 50               push ax
  045E16  01F6: 9a600a1f18       lcall 0x181f, 0xa60
  045E1B  01FB: 83c402           add sp, 2
  045E1E  01FE: 8946fc           mov word ptr [bp - 4], ax
  045E21  0201: 837e0801         cmp word ptr [bp + 8], 1
  045E25  0205: 7509             jne 0x210
  045E27  0207: 837e0a00         cmp word ptr [bp + 0xa], 0
  045E2B  020B: 7e03             jle 0x210
  045E2D  020D: d17e0a           sar word ptr [bp + 0xa], 1
  045E30  0210: 6a10             push 0x10
  045E32  0212: ff7608           push word ptr [bp + 8]
  045E35  0215: 9ab4071f18       lcall 0x181f, 0x7b4
  045E3A  021A: 83c404           add sp, 4
  045E3D  021D: 0bc0             or ax, ax
  045E3F  021F: 7409             je 0x22a
  045E41  0221: 837e0a00         cmp word ptr [bp + 0xa], 0
  045E45  0225: 7e03             jle 0x22a
  045E47  0227: d17e0a           sar word ptr [bp + 0xa], 1
  045E4A  022A: 6a64             push 0x64
  045E4C  022C: 6a00             push 0
  045E4E  022E: 6b5e0627         imul bx, word ptr [bp + 6], 0x27
  045E52  0232: 035e08           add bx, word ptr [bp + 8]
  045E55  0235: d1e3             shl bx, 1
  045E57  0237: 8b871c5b         mov ax, word ptr [bx + 0x5b1c]
  045E5B  023B: 03460a           add ax, word ptr [bp + 0xa]
  045E5E  023E: 50               push ax
  045E5F  023F: 8bf3             mov si, bx
  045E61  0241: 9a5c031f18       lcall 0x181f, 0x35c
  045E66  0246: 83c406           add sp, 6
  045E69  0249: 89469e           mov word ptr [bp - 0x62], ax
  045E6C  024C: 89841c5b         mov word ptr [si + 0x5b1c], ax
  045E70  0250: 50               push ax
  045E71  0251: 9a600a1f18       lcall 0x181f, 0xa60
  045E76  0256: 83c402           add sp, 2
  045E79  0259: 8946fa           mov word ptr [bp - 6], ax
  045E7C  025C: d17efc           sar word ptr [bp - 4], 1
  045E7F  025F: d17efa           sar word ptr [bp - 6], 1
  045E82  0262: 837e0a00         cmp word ptr [bp + 0xa], 0
  045E86  0266: 7d2a             jge 0x292
  045E88  0268: 6a04             push 4
  045E8A  026A: ff7608           push word ptr [bp + 8]
  045E8D  026D: 8b4606           mov ax, word ptr [bp + 6]
  045E90  0270: 050400           add ax, 4
  045E93  0273: 50               push ax
  045E94  0274: 8bf0             mov si, ax
  045E96  0276: 9a100a1f18       lcall 0x181f, 0xa10
  045E9B  027B: 83c406           add sp, 6
  045E9E  027E: 837e9e4b         cmp word ptr [bp - 0x62], 0x4b
  045EA2  0282: 7d0e             jge 0x292
  045EA4  0284: 6a02             push 2
  045EA6  0286: ff7608           push word ptr [bp + 8]
  045EA9  0289: 56               push si
  045EAA  028A: 9a100a1f18       lcall 0x181f, 0xa10
  045EAF  028F: 83c406           add sp, 6
  045EB2  0292: 837e9e64         cmp word ptr [bp - 0x62], 0x64
  045EB6  0296: 7c5e             jl 0x2f6
  045EB8  0298: ff7608           push word ptr [bp + 8]
  045EBB  029B: 8b4606           mov ax, word ptr [bp + 6]
  045EBE  029E: 050400           add ax, 4
  045EC1  02A1: 50               push ax
  045EC2  02A2: 9a380a1f18       lcall 0x181f, 0xa38
  045EC7  02A7: 83c404           add sp, 4
  045ECA  02AA: a840             test al, 0x40
  045ECC  02AC: 7448             je 0x2f6
  045ECE  02AE: 837e0804         cmp word ptr [bp + 8], 4
  045ED2  02B2: 7d16             jge 0x2ca
  045ED4  02B4: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  045ED8  02B8: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  045EDD  02BD: 750b             jne 0x2ca
  045EDF  02BF: a0a653           mov al, byte ptr [0x53a6]
  045EE2  02C2: 2ae4             sub ah, ah
  045EE4  02C4: 89469c           mov word ptr [bp - 0x64], ax
  045EE7  02C7: eb06             jmp 0x2cf
  045EE9  02C9: 90               nop 
  045EEA  02CA: c7469c0100       mov word ptr [bp - 0x64], 1
  045EEF  02CF: 6a0a             push 0xa
  045EF1  02D1: 6a00             push 0
  045EF3  02D3: 9ad4041f18       lcall 0x181f, 0x4d4
  045EF8  02D8: 83c404           add sp, 4
  045EFB  02DB: 8b4e9c           mov cx, word ptr [bp - 0x64]
  045EFE  02DE: 41               inc cx
  045EFF  02DF: 3bc1             cmp ax, cx
  045F01  02E1: 7e03             jle 0x2e6
  045F03  02E3: e9fa00           jmp 0x3e0
  045F06  02E6: ff7608           push word ptr [bp + 8]
  045F09  02E9: ff7606           push word ptr [bp + 6]
  045F0C  02EC: 0e               push cs
  045F0D  02ED: e8de06           call 0x9ce
  045F10  02F0: 83c404           add sp, 4
  045F13  02F3: 5e               pop si
  045F14  02F4: c9               leave 
  045F15  02F5: cb               retf 
  045F16  02F6: 8b46a4           mov ax, word ptr [bp - 0x5c]
  045F19  02F9: b9fbff           mov cx, 0xfffb
  045F1C  02FC: 99               cdq 
  045F1D  02FD: f7f9             idiv cx
  045F1F  02FF: 8bd0             mov dx, ax
  045F21  0301: 8b469e           mov ax, word ptr [bp - 0x62]
  045F24  0304: 3d6300           cmp ax, 0x63
  045F27  0307: 7e03             jle 0x30c
  045F29  0309: b86300           mov ax, 0x63
  045F2C  030C: 8bda             mov bx, dx
  045F2E  030E: 99               cdq 
  045F2F  030F: f7f9             idiv cx
  045F31  0311: 3bc3             cmp ax, bx
  045F33  0313: 7503             jne 0x318
  045F35  0315: e9c800           jmp 0x3e0
  045F38  0318: ff7608           push word ptr [bp + 8]
  045F3B  031B: 9aa4091f18       lcall 0x181f, 0x9a4
  045F40  0320: 83c402           add sp, 2
  045F43  0323: 50               push ax
  045F44  0324: 6a00             push 0
  045F46  0326: 9a38041f18       lcall 0x181f, 0x438
  045F4B  032B: 83c404           add sp, 4
  045F4E  032E: 8b4606           mov ax, word ptr [bp + 6]
  045F51  0331: 050400           add ax, 4
  045F54  0334: 50               push ax
  045F55  0335: 9aa4091f18       lcall 0x181f, 0x9a4
  045F5A  033A: 83c402           add sp, 2
  045F5D  033D: 50               push ax
  045F5E  033E: 6a01             push 1
  045F60  0340: 9a38041f18       lcall 0x181f, 0x438
  045F65  0345: 83c404           add sp, 4
  045F68  0348: 837e0a00         cmp word ptr [bp + 0xa], 0
  045F6C  034C: 7c03             jl 0x351
  045F6E  034E: e98f00           jmp 0x3e0
  045F71  0351: 8b4606           mov ax, word ptr [bp + 6]
  045F74  0354: 050400           add ax, 4
  045F77  0357: 8946fe           mov word ptr [bp - 2], ax
  045F7A  035A: c746a00000       mov word ptr [bp - 0x60], 0
  045F7F  035F: eb47             jmp 0x3a8
  045F81  0361: 90               nop 
  045F82  0362: 837efa00         cmp word ptr [bp - 6], 0
  045F86  0366: 751e             jne 0x386
  045F88  0368: 8b5ea0           mov bx, word ptr [bp - 0x60]
  045F8B  036B: 8bc3             mov ax, bx
  045F8D  036D: c1e303           shl bx, 3
  045F90  0370: 03d8             add bx, ax
  045F92  0372: 035e08           add bx, word ptr [bp + 8]
  045F95  0375: d1e3             shl bx, 1
  045F97  0377: 8b87f654         mov ax, word ptr [bx + 0x54f6]
  045F9B  037B: 3d2000           cmp ax, 0x20
  045F9E  037E: 7e21             jle 0x3a1
  045FA0  0380: b82000           mov ax, 0x20
  045FA3  0383: eb1c             jmp 0x3a1
  045FA5  0385: 90               nop 
  045FA6  0386: 8b5ea0           mov bx, word ptr [bp - 0x60]
  045FA9  0389: 8bc3             mov ax, bx
  045FAB  038B: c1e303           shl bx, 3
  045FAE  038E: 03d8             add bx, ax
  045FB0  0390: 035e08           add bx, word ptr [bp + 8]
  045FB3  0393: d1e3             shl bx, 1
  045FB5  0395: 8b87f654         mov ax, word ptr [bx + 0x54f6]
  045FB9  0399: 3d6000           cmp ax, 0x60
  045FBC  039C: 7e03             jle 0x3a1
  045FBE  039E: b86000           mov ax, 0x60
  045FC1  03A1: 8987f654         mov word ptr [bx + 0x54f6], ax
  045FC5  03A5: ff46a0           inc word ptr [bp - 0x60]
  045FC8  03A8: 8b46a0           mov ax, word ptr [bp - 0x60]
  045FCB  03AB: 39069a53         cmp word ptr [0x539a], ax
  045FCF  03AF: 7e2f             jle 0x3e0
  045FD1  03B1: 6bd812           imul bx, ax, 0x12
  045FD4  03B4: 8a46fe           mov al, byte ptr [bp - 2]
  045FD7  03B7: 3887ee54         cmp byte ptr [bx + 0x54ee], al
  045FDB  03BB: 75e8             jne 0x3a5
  045FDD  03BD: 8b46fc           mov ax, word ptr [bp - 4]
  045FE0  03C0: 2b46fa           sub ax, word ptr [bp - 6]
  045FE3  03C3: 3d0100           cmp ax, 1
  045FE6  03C6: 7e9a             jle 0x362
  045FE8  03C8: 8b5ea0           mov bx, word ptr [bp - 0x60]
  045FEB  03CB: 8bc3             mov ax, bx
  045FED  03CD: c1e303           shl bx, 3
  045FF0  03D0: 03d8             add bx, ax
  045FF2  03D2: 035e08           add bx, word ptr [bp + 8]
  045FF5  03D5: d1e3             shl bx, 1
  045FF7  03D7: c787f6540000     mov word ptr [bx + 0x54f6], 0
  045FFD  03DD: ebc6             jmp 0x3a5
  045FFF  03DF: 90               nop 
  046000  03E0: 5e               pop si
  046001  03E1: c9               leave 
  046002  03E2: cb               retf 

; ---- func_046004  size=81  insns=27  prologue=ENTER 0x0004,0  terminal=RETF ----
  046004  03E4: c8040000         enter 4, 0
  046008  03E8: c746fcffff       mov word ptr [bp - 4], 0xffff
  04600D  03ED: ff7608           push word ptr [bp + 8]
  046010  03F0: ff7606           push word ptr [bp + 6]
  046013  03F3: 9af0061f18       lcall 0x181f, 0x6f0
  046018  03F8: 83c404           add sp, 4
  04601B  03FB: 0bc0             or ax, ax
  04601D  03FD: 7c31             jl 0x430
  04601F  03FF: c746fe0000       mov word ptr [bp - 2], 0
  046024  0404: eb24             jmp 0x42a
  046026  0406: 8b46fe           mov ax, word ptr [bp - 2]
  046029  0409: 39069a53         cmp word ptr [0x539a], ax
  04602D  040D: 7e21             jle 0x430
  04602F  040F: 6bd812           imul bx, ax, 0x12
  046032  0412: 8a4e06           mov cl, byte ptr [bp + 6]
  046035  0415: 388fec54         cmp byte ptr [bx + 0x54ec], cl
  046039  0419: 750c             jne 0x427
  04603B  041B: 8a4e08           mov cl, byte ptr [bp + 8]
  04603E  041E: 388fed54         cmp byte ptr [bx + 0x54ed], cl
  046042  0422: 7503             jne 0x427
  046044  0424: 8946fc           mov word ptr [bp - 4], ax
  046047  0427: ff46fe           inc word ptr [bp - 2]
  04604A  042A: 837efc00         cmp word ptr [bp - 4], 0
  04604E  042E: 7cd6             jl 0x406
  046050  0430: 8b46fc           mov ax, word ptr [bp - 4]
  046053  0433: c9               leave 
  046054  0434: cb               retf 

; ---- func_046056  size=162  insns=55  prologue=ENTER 0x000A,0  terminal=RETF ----
  046056  0436: c80a0000         enter 0xa, 0
  04605A  043A: c746f6ffff       mov word ptr [bp - 0xa], 0xffff
  04605F  043F: c746fe0f27       mov word ptr [bp - 2], 0x270f
  046064  0444: c746fa0000       mov word ptr [bp - 6], 0
  046069  0449: eb6b             jmp 0x4b6
  04606B  044B: 90               nop 
  04606C  044C: 837e0a00         cmp word ptr [bp + 0xa], 0
  046070  0450: 7c0c             jl 0x45e
  046072  0452: 6bd812           imul bx, ax, 0x12
  046075  0455: 8a460a           mov al, byte ptr [bp + 0xa]
  046078  0458: 3887ee54         cmp byte ptr [bx + 0x54ee], al
  04607C  045C: 7555             jne 0x4b3
  04607E  045E: 837e0c00         cmp word ptr [bp + 0xc], 0
  046082  0462: 7c1d             jl 0x481
  046084  0464: 6b5efa12         imul bx, word ptr [bp - 6], 0x12
  046088  0468: 8a87ed54         mov al, byte ptr [bx + 0x54ed]
  04608C  046C: 2ae4             sub ah, ah
  04608E  046E: 50               push ax
  04608F  046F: 8a87ec54         mov al, byte ptr [bx + 0x54ec]
  046093  0473: 50               push ax
  046094  0474: 9a22071f18       lcall 0x181f, 0x722
  046099  0479: 83c404           add sp, 4
  04609C  047C: 3b460c           cmp ax, word ptr [bp + 0xc]
  04609F  047F: 7532             jne 0x4b3
  0460A1  0481: 6b5efa12         imul bx, word ptr [bp - 6], 0x12
  0460A5  0485: 8a87ed54         mov al, byte ptr [bx + 0x54ed]
  0460A9  0489: 2ae4             sub ah, ah
  0460AB  048B: 2b4608           sub ax, word ptr [bp + 8]
  0460AE  048E: f7d8             neg ax
  0460B0  0490: 50               push ax
  0460B1  0491: 8a87ec54         mov al, byte ptr [bx + 0x54ec]
  0460B5  0495: 2ae4             sub ah, ah
  0460B7  0497: 2b4606           sub ax, word ptr [bp + 6]
  0460BA  049A: f7d8             neg ax
  0460BC  049C: 50               push ax
  0460BD  049D: 9a70031f18       lcall 0x181f, 0x370
  0460C2  04A2: 83c404           add sp, 4
  0460C5  04A5: 3b46fe           cmp ax, word ptr [bp - 2]
  0460C8  04A8: 7f09             jg 0x4b3
  0460CA  04AA: 8b4efa           mov cx, word ptr [bp - 6]
  0460CD  04AD: 894ef6           mov word ptr [bp - 0xa], cx
  0460D0  04B0: 8946fe           mov word ptr [bp - 2], ax
  0460D3  04B3: ff46fa           inc word ptr [bp - 6]
  0460D6  04B6: 8b46fa           mov ax, word ptr [bp - 6]
  0460D9  04B9: 39069a53         cmp word ptr [0x539a], ax
  0460DD  04BD: 7f8d             jg 0x44c
  0460DF  04BF: 8b46fe           mov ax, word ptr [bp - 2]
  0460E2  04C2: a3b88d           mov word ptr [0x8db8], ax
  0460E5  04C5: 837ef600         cmp word ptr [bp - 0xa], 0
  0460E9  04C9: 7c08             jl 0x4d3
  0460EB  04CB: ff76f6           push word ptr [bp - 0xa]
  0460EE  04CE: 9a4c0a1f18       lcall 0x181f, 0xa4c
  0460F3  04D3: 8b46f6           mov ax, word ptr [bp - 0xa]
  0460F6  04D6: c9               leave 
  0460F7  04D7: cb               retf 

; ---- func_0460F8  size=969  insns=344  prologue=ENTER 0x0048,0  terminal=RETF ----
  0460F8  04D8: c8480000         enter 0x48, 0
  0460FC  04DC: 56               push si
  0460FD  04DD: b8ffff           mov ax, 0xffff
  046100  04E0: 8946c8           mov word ptr [bp - 0x38], ax
  046103  04E3: 8946d0           mov word ptr [bp - 0x30], ax
  046106  04E6: 6b5e0612         imul bx, word ptr [bp + 6], 0x12
  04610A  04EA: 8a87ec54         mov al, byte ptr [bx + 0x54ec]
  04610E  04EE: 2ae4             sub ah, ah
  046110  04F0: 8946d6           mov word ptr [bp - 0x2a], ax
  046113  04F3: 8a8fed54         mov cl, byte ptr [bx + 0x54ed]
  046117  04F7: 2aed             sub ch, ch
  046119  04F9: 894ed4           mov word ptr [bp - 0x2c], cx
  04611C  04FC: 51               push cx
  04611D  04FD: 50               push ax
  04611E  04FE: 9a22071f18       lcall 0x181f, 0x722
  046123  0503: 83c404           add sp, 4
  046126  0506: 8946f0           mov word ptr [bp - 0x10], ax
  046129  0509: 2bc0             sub ax, ax
  04612B  050B: 8946ea           mov word ptr [bp - 0x16], ax
  04612E  050E: 8946c0           mov word ptr [bp - 0x40], ax
  046131  0511: 8946d2           mov word ptr [bp - 0x2e], ax
  046134  0514: eb0d             jmp 0x523
  046136  0516: 8b76d2           mov si, word ptr [bp - 0x2e]
  046139  0519: d1e6             shl si, 1
  04613B  051B: c742e20000       mov word ptr [bp + si - 0x1e], 0
  046140  0520: ff46d2           inc word ptr [bp - 0x2e]
  046143  0523: 837ed204         cmp word ptr [bp - 0x2e], 4
  046147  0527: 7ced             jl 0x516
  046149  0529: 6b5e0612         imul bx, word ptr [bp + 6], 0x12
  04614D  052D: 8a87ee54         mov al, byte ptr [bx + 0x54ee]
  046151  0531: 2ae4             sub ah, ah
  046153  0533: 6bf04e           imul si, ax, 0x4e
  046156  0536: 8a84a059         mov al, byte ptr [si + 0x59a0]
  04615A  053A: 8946d8           mov word ptr [bp - 0x28], ax
  04615D  053D: 8a87f154         mov al, byte ptr [bx + 0x54f1]
  046161  0541: 98               cwde 
  046162  0542: 8946f4           mov word ptr [bp - 0xc], ax
  046165  0545: c746e00000       mov word ptr [bp - 0x20], 0
  04616A  054A: e9ab00           jmp 0x5f8
  04616D  054D: 90               nop 
  04616E  054E: 6b5eca1c         imul bx, word ptr [bp - 0x36], 0x1c
  046172  0552: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  046177  0557: 7207             jb 0x560
  046179  0559: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04617E  055E: 7626             jbe 0x586
  046180  0560: 6b5eca1c         imul bx, word ptr [bp - 0x36], 0x1c
  046184  0564: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  046188  0568: 2aff             sub bh, bh
  04618A  056A: 8bc3             mov ax, bx
  04618C  056C: d1e3             shl bx, 1
  04618E  056E: 03d8             add bx, ax
  046190  0570: d1e3             shl bx, 1
  046192  0572: 03d8             add bx, ax
  046194  0574: d1e3             shl bx, 1
  046196  0576: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  04619B  057B: 7609             jbe 0x586
  04619D  057D: 8a873652         mov al, byte ptr [bx + 0x5236]
  0461A1  0581: 2ae4             sub ah, ah
  0461A3  0583: 0146dc           add word ptr [bp - 0x24], ax
  0461A6  0586: 8b46ca           mov ax, word ptr [bp - 0x36]
  0461A9  0589: 9ae4021f18       lcall 0x181f, 0x2e4
  0461AE  058E: 8946ca           mov word ptr [bp - 0x36], ax
  0461B1  0591: 837eca00         cmp word ptr [bp - 0x36], 0
  0461B5  0595: 7db7             jge 0x54e
  0461B7  0597: ff76f2           push word ptr [bp - 0xe]
  0461BA  059A: ff76fa           push word ptr [bp - 6]
  0461BD  059D: 9abe061f18       lcall 0x181f, 0x6be
  0461C2  05A2: 83c404           add sp, 4
  0461C5  05A5: 0bc0             or ax, ax
  0461C7  05A7: 7c03             jl 0x5ac
  0461C9  05A9: d17edc           sar word ptr [bp - 0x24], 1
  0461CC  05AC: 8b5ee0           mov bx, word ptr [bp - 0x20]
  0461CF  05AF: 80bfc80000       cmp byte ptr [bx + 0xc8], 0
  0461D4  05B4: 7e08             jle 0x5be
  0461D6  05B6: 8a87c800         mov al, byte ptr [bx + 0xc8]
  0461DA  05BA: 98               cwde 
  0461DB  05BB: eb09             jmp 0x5c6
  0461DD  05BD: 90               nop 
  0461DE  05BE: 8a87c800         mov al, byte ptr [bx + 0xc8]
  0461E2  05C2: f6d0             not al
  0461E4  05C4: 98               cwde 
  0461E5  05C5: 40               inc ax
  0461E6  05C6: 3d0100           cmp ax, 1
  0461E9  05C9: 7f1c             jg 0x5e7
  0461EB  05CB: 80bfde0000       cmp byte ptr [bx + 0xde], 0
  0461F0  05D0: 7e08             jle 0x5da
  0461F2  05D2: 8a87de00         mov al, byte ptr [bx + 0xde]
  0461F6  05D6: 98               cwde 
  0461F7  05D7: eb09             jmp 0x5e2
  0461F9  05D9: 90               nop 
  0461FA  05DA: 8a87de00         mov al, byte ptr [bx + 0xde]
  0461FE  05DE: f6d0             not al
  046200  05E0: 98               cwde 
  046201  05E1: 40               inc ax
  046202  05E2: 3d0100           cmp ax, 1
  046205  05E5: 7e03             jle 0x5ea
  046207  05E7: d17edc           sar word ptr [bp - 0x24], 1
  04620A  05EA: 8b46dc           mov ax, word ptr [bp - 0x24]
  04620D  05ED: 8b76fc           mov si, word ptr [bp - 4]
  046210  05F0: d1e6             shl si, 1
  046212  05F2: 0142e2           add word ptr [bp + si - 0x1e], ax
  046215  05F5: ff46e0           inc word ptr [bp - 0x20]
  046218  05F8: 837ee014         cmp word ptr [bp - 0x20], 0x14
  04621C  05FC: 7d66             jge 0x664
  04621E  05FE: 8b5ee0           mov bx, word ptr [bp - 0x20]
  046221  0601: 8a87de00         mov al, byte ptr [bx + 0xde]
  046225  0605: 98               cwde 
  046226  0606: 0346d4           add ax, word ptr [bp - 0x2c]
  046229  0609: 8946f2           mov word ptr [bp - 0xe], ax
  04622C  060C: 50               push ax
  04622D  060D: 8a87c800         mov al, byte ptr [bx + 0xc8]
  046231  0611: 98               cwde 
  046232  0612: 0346d6           add ax, word ptr [bp - 0x2a]
  046235  0615: 8946fa           mov word ptr [bp - 6], ax
  046238  0618: 50               push ax
  046239  0619: 9a02031f18       lcall 0x181f, 0x302
  04623E  061E: 83c404           add sp, 4
  046241  0621: 0bc0             or ax, ax
  046243  0623: 74d0             je 0x5f5
  046245  0625: ff76f2           push word ptr [bp - 0xe]
  046248  0628: ff76fa           push word ptr [bp - 6]
  04624B  062B: 9a68071f18       lcall 0x181f, 0x768
  046250  0630: 83c404           add sp, 4
  046253  0633: 0bc0             or ax, ax
  046255  0635: 75be             jne 0x5f5
  046257  0637: 8b46fa           mov ax, word ptr [bp - 6]
  04625A  063A: 8b56f2           mov dx, word ptr [bp - 0xe]
  04625D  063D: 9ae0071f18       lcall 0x181f, 0x7e0
  046262  0642: 8946ca           mov word ptr [bp - 0x36], ax
  046265  0645: 0bc0             or ax, ax
  046267  0647: 7cac             jl 0x5f5
  046269  0649: 6bd81c           imul bx, ax, 0x1c
  04626C  064C: 8a874731         mov al, byte ptr [bx + 0x3147]
  046270  0650: 250f00           and ax, 0xf
  046273  0653: 8946fc           mov word ptr [bp - 4], ax
  046276  0656: 3d0400           cmp ax, 4
  046279  0659: 7d9a             jge 0x5f5
  04627B  065B: c746dc0000       mov word ptr [bp - 0x24], 0
  046280  0660: e92eff           jmp 0x591
  046283  0663: 90               nop 
  046284  0664: c746c20000       mov word ptr [bp - 0x3e], 0
  046289  0669: e92d01           jmp 0x799
  04628C  066C: c746f60100       mov word ptr [bp - 0xa], 1
  046291  0671: c746c40200       mov word ptr [bp - 0x3c], 2
  046296  0676: 2bc0             sub ax, ax
  046298  0678: 8946ee           mov word ptr [bp - 0x12], ax
  04629B  067B: 8946d2           mov word ptr [bp - 0x2e], ax
  04629E  067E: eb4b             jmp 0x6cb
  0462A0  0680: c746f60300       mov word ptr [bp - 0xa], 3
  0462A5  0685: c746c40400       mov word ptr [bp - 0x3c], 4
  0462AA  068A: ebea             jmp 0x676
  0462AC  068C: b80100           mov ax, 1
  0462AF  068F: 8946f6           mov word ptr [bp - 0xa], ax
  0462B2  0692: 8946c4           mov word ptr [bp - 0x3c], ax
  0462B5  0695: ebdf             jmp 0x676
  0462B7  0697: 90               nop 
  0462B8  0698: c746f60300       mov word ptr [bp - 0xa], 3
  0462BD  069D: ebd2             jmp 0x671
  0462BF  069F: 90               nop 
  0462C0  06A0: c746f60200       mov word ptr [bp - 0xa], 2
  0462C5  06A5: c746c40100       mov word ptr [bp - 0x3c], 1
  0462CA  06AA: ebca             jmp 0x676
  0462CC  06AC: ff46bc           inc word ptr [bp - 0x44]
  0462CF  06AF: 837ebc08         cmp word ptr [bp - 0x44], 8
  0462D3  06B3: 7d13             jge 0x6c8
  0462D5  06B5: 8b46cc           mov ax, word ptr [bp - 0x34]
  0462D8  06B8: 8546ce           test word ptr [bp - 0x32], ax
  0462DB  06BB: 7406             je 0x6c3
  0462DD  06BD: 8b46f6           mov ax, word ptr [bp - 0xa]
  0462E0  06C0: 0146ee           add word ptr [bp - 0x12], ax
  0462E3  06C3: d166ce           shl word ptr [bp - 0x32], 1
  0462E6  06C6: ebe4             jmp 0x6ac
  0462E8  06C8: ff46d2           inc word ptr [bp - 0x2e]
  0462EB  06CB: 837ed206         cmp word ptr [bp - 0x2e], 6
  0462EF  06CF: 7d1d             jge 0x6ee
  0462F1  06D1: 6976c2ca00       imul si, word ptr [bp - 0x3e], 0xca
  0462F6  06D6: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  0462F9  06D9: 8a80ca5d         mov al, byte ptr [bx + si + 0x5dca]
  0462FD  06DD: 98               cwde 
  0462FE  06DE: 8946cc           mov word ptr [bp - 0x34], ax
  046301  06E1: c746ce0100       mov word ptr [bp - 0x32], 1
  046306  06E6: c746bc0000       mov word ptr [bp - 0x44], 0
  04630B  06EB: ebc2             jmp 0x6af
  04630D  06ED: 90               nop 
  04630E  06EE: 695ec2ca00       imul bx, word ptr [bp - 0x3e], 0xca
  046313  06F3: 8a87655d         mov al, byte ptr [bx + 0x5d65]
  046317  06F7: 98               cwde 
  046318  06F8: 8946be           mov word ptr [bp - 0x42], ax
  04631B  06FB: 3d0600           cmp ax, 6
  04631E  06FE: 7e03             jle 0x703
  046320  0700: b80600           mov ax, 6
  046323  0703: 8946fe           mov word ptr [bp - 2], ax
  046326  0706: 2b46be           sub ax, word ptr [bp - 0x42]
  046329  0709: f7d8             neg ax
  04632B  070B: 8946f8           mov word ptr [bp - 8], ax
  04632E  070E: 8b46ee           mov ax, word ptr [bp - 0x12]
  046331  0711: 99               cdq 
  046332  0712: f77ec4           idiv word ptr [bp - 0x3c]
  046335  0715: 8946ee           mov word ptr [bp - 0x12], ax
  046338  0718: 2d0800           sub ax, 8
  04633B  071B: c1f802           sar ax, 2
  04633E  071E: 0146da           add word ptr [bp - 0x26], ax
  046341  0721: 8b46f8           mov ax, word ptr [bp - 8]
  046344  0724: d1e0             shl ax, 1
  046346  0726: 8b4ebe           mov cx, word ptr [bp - 0x42]
  046349  0729: d1f9             sar cx, 1
  04634B  072B: 3b4ed8           cmp cx, word ptr [bp - 0x28]
  04634E  072E: 7e03             jle 0x733
  046350  0730: 8b4ed8           mov cx, word ptr [bp - 0x28]
  046353  0733: 03c1             add ax, cx
  046355  0735: 0346fe           add ax, word ptr [bp - 2]
  046358  0738: 0346da           add ax, word ptr [bp - 0x26]
  04635B  073B: d1e0             shl ax, 1
  04635D  073D: 2b46ec           sub ax, word ptr [bp - 0x14]
  046360  0740: 48               dec ax
  046361  0741: 8b4eec           mov cx, word ptr [bp - 0x14]
  046364  0744: 83c104           add cx, 4
  046367  0747: 99               cdq 
  046368  0748: f7f9             idiv cx
  04636A  074A: 8946ea           mov word ptr [bp - 0x16], ax
  04636D  074D: 8b46f0           mov ax, word ptr [bp - 0x10]
  046370  0750: 3946de           cmp word ptr [bp - 0x22], ax
  046373  0753: 7408             je 0x75d
  046375  0755: 8b46ea           mov ax, word ptr [bp - 0x16]
  046378  0758: d1f8             sar ax, 1
  04637A  075A: 8946ea           mov word ptr [bp - 0x16], ax
  04637D  075D: 8b76c6           mov si, word ptr [bp - 0x3a]
  046380  0760: d1e6             shl si, 1
  046382  0762: 8b42e2           mov ax, word ptr [bp + si - 0x1e]
  046385  0765: 0146ea           add word ptr [bp - 0x16], ax
  046388  0768: 837ec601         cmp word ptr [bp - 0x3a], 1
  04638C  076C: 7503             jne 0x771
  04638E  076E: d17eea           sar word ptr [bp - 0x16], 1
  046391  0771: 6a10             push 0x10
  046393  0773: ff76c6           push word ptr [bp - 0x3a]
  046396  0776: 9ab4071f18       lcall 0x181f, 0x7b4
  04639B  077B: 83c404           add sp, 4
  04639E  077E: 0bc0             or ax, ax
  0463A0  0780: 7403             je 0x785
  0463A2  0782: d17eea           sar word ptr [bp - 0x16], 1
  0463A5  0785: 8b46ea           mov ax, word ptr [bp - 0x16]
  0463A8  0788: 3946c0           cmp word ptr [bp - 0x40], ax
  0463AB  078B: 7d09             jge 0x796
  0463AD  078D: 8946c0           mov word ptr [bp - 0x40], ax
  0463B0  0790: 8b46c2           mov ax, word ptr [bp - 0x3e]
  0463B3  0793: 8946d0           mov word ptr [bp - 0x30], ax
  0463B6  0796: ff46c2           inc word ptr [bp - 0x3e]
  0463B9  0799: 8b46c2           mov ax, word ptr [bp - 0x3e]
  0463BC  079C: 39069e53         cmp word ptr [0x539e], ax
  0463C0  07A0: 7f03             jg 0x7a5
  0463C2  07A2: e99900           jmp 0x83e
  0463C5  07A5: 69d8ca00         imul bx, ax, 0xca
  0463C9  07A9: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  0463CD  07AD: 2ae4             sub ah, ah
  0463CF  07AF: 50               push ax
  0463D0  07B0: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  0463D4  07B4: 50               push ax
  0463D5  07B5: ff76d4           push word ptr [bp - 0x2c]
  0463D8  07B8: ff76d6           push word ptr [bp - 0x2a]
  0463DB  07BB: 9a7a031f18       lcall 0x181f, 0x37a
  0463E0  07C0: 83c408           add sp, 8
  0463E3  07C3: 8946ec           mov word ptr [bp - 0x14], ax
  0463E6  07C6: 3d0600           cmp ax, 6
  0463E9  07C9: 7fcb             jg 0x796
  0463EB  07CB: 695ec2ca00       imul bx, word ptr [bp - 0x3e], 0xca
  0463F0  07D0: 8a87605d         mov al, byte ptr [bx + 0x5d60]
  0463F4  07D4: 2ae4             sub ah, ah
  0463F6  07D6: 8946c6           mov word ptr [bp - 0x3a], ax
  0463F9  07D9: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  0463FD  07DD: 50               push ax
  0463FE  07DE: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  046402  07E2: 50               push ax
  046403  07E3: 9a22071f18       lcall 0x181f, 0x722
  046408  07E8: 83c404           add sp, 4
  04640B  07EB: 8946de           mov word ptr [bp - 0x22], ax
  04640E  07EE: c746da0000       mov word ptr [bp - 0x26], 0
  046413  07F3: b80100           mov ax, 1
  046416  07F6: 8946f6           mov word ptr [bp - 0xa], ax
  046419  07F9: 8946c4           mov word ptr [bp - 0x3c], ax
  04641C  07FC: 837ec604         cmp word ptr [bp - 0x3a], 4
  046420  0800: 7c03             jl 0x805
  046422  0802: e971fe           jmp 0x676
  046425  0805: 6b5ec634         imul bx, word ptr [bp - 0x3a], 0x34
  046429  0809: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04642E  080E: 7403             je 0x813
  046430  0810: e963fe           jmp 0x676
  046433  0813: a0a653           mov al, byte ptr [0x53a6]
  046436  0816: 2ae4             sub ah, ah
  046438  0818: 8946da           mov word ptr [bp - 0x26], ax
  04643B  081B: 0bc0             or ax, ax
  04643D  081D: 7503             jne 0x822
  04643F  081F: e94afe           jmp 0x66c
  046442  0822: 48               dec ax
  046443  0823: 7503             jne 0x828
  046445  0825: e958fe           jmp 0x680
  046448  0828: 48               dec ax
  046449  0829: 7503             jne 0x82e
  04644B  082B: e95efe           jmp 0x68c
  04644E  082E: 48               dec ax
  04644F  082F: 7503             jne 0x834
  046451  0831: e964fe           jmp 0x698
  046454  0834: 48               dec ax
  046455  0835: 7503             jne 0x83a
  046457  0837: e966fe           jmp 0x6a0
  04645A  083A: e939fe           jmp 0x676
  04645D  083D: 90               nop 
  04645E  083E: 837ec000         cmp word ptr [bp - 0x40], 0
  046462  0842: 7e49             jle 0x88d
  046464  0844: 695ed0ca00       imul bx, word ptr [bp - 0x30], 0xca
  046469  0849: 8a87605d         mov al, byte ptr [bx + 0x5d60]
  04646D  084D: 2ae4             sub ah, ah
  04646F  084F: 8946c8           mov word ptr [bp - 0x38], ax
  046472  0852: 837ef400         cmp word ptr [bp - 0xc], 0
  046476  0856: 7c35             jl 0x88d
  046478  0858: 8a4ef4           mov cl, byte ptr [bp - 0xc]
  04647B  085B: 83e10f           and cx, 0xf
  04647E  085E: 3bc1             cmp ax, cx
  046480  0860: 7416             je 0x878
  046482  0862: f646f410         test byte ptr [bp - 0xc], 0x10
  046486  0866: 7406             je 0x86e
  046488  0868: d166c0           shl word ptr [bp - 0x40], 1
  04648B  086B: eb20             jmp 0x88d
  04648D  086D: 90               nop 
  04648E  086E: 8b46c0           mov ax, word ptr [bp - 0x40]
  046491  0871: d1f8             sar ax, 1
  046493  0873: 0146c0           add word ptr [bp - 0x40], ax
  046496  0876: eb15             jmp 0x88d
  046498  0878: f646f410         test byte ptr [bp - 0xc], 0x10
  04649C  087C: 7406             je 0x884
  04649E  087E: d17ec0           sar word ptr [bp - 0x40], 1
  0464A1  0881: eb0a             jmp 0x88d
  0464A3  0883: 90               nop 
  0464A4  0884: 8b46c0           mov ax, word ptr [bp - 0x40]
  0464A7  0887: c1f802           sar ax, 2
  0464AA  088A: 2946c0           sub word ptr [bp - 0x40], ax
  0464AD  088D: 837e0800         cmp word ptr [bp + 8], 0
  0464B1  0891: 7408             je 0x89b
  0464B3  0893: 8b46c0           mov ax, word ptr [bp - 0x40]
  0464B6  0896: 8b5e08           mov bx, word ptr [bp + 8]
  0464B9  0899: 8907             mov word ptr [bx], ax
  0464BB  089B: 8b46c8           mov ax, word ptr [bp - 0x38]
  0464BE  089E: 5e               pop si
  0464BF  089F: c9               leave 
  0464C0  08A0: cb               retf 

; ---- func_0464C2  size=305  insns=104  prologue=ENTER 0x0006,0  terminal=page-end ----
  0464C2  08A2: c8060000         enter 6, 0
  0464C6  08A6: ff7606           push word ptr [bp + 6]
  0464C9  08A9: 9a4c0a1f18       lcall 0x181f, 0xa4c
  0464CE  08AE: 83c402           add sp, 2
  0464D1  08B1: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0464D5  08B5: 8a4701           mov al, byte ptr [bx + 1]
  0464D8  08B8: 2ae4             sub ah, ah
  0464DA  08BA: 50               push ax
  0464DB  08BB: 8a07             mov al, byte ptr [bx]
  0464DD  08BD: 50               push ax
  0464DE  08BE: ff760c           push word ptr [bp + 0xc]
  0464E1  08C1: ff760a           push word ptr [bp + 0xa]
  0464E4  08C4: 9a7a031f18       lcall 0x181f, 0x37a
  0464E9  08C9: 83c408           add sp, 8
  0464EC  08CC: 8946fc           mov word ptr [bp - 4], ax
  0464EF  08CF: 837e0804         cmp word ptr [bp + 8], 4
  0464F3  08D3: 7d33             jge 0x908
  0464F5  08D5: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  0464F9  08D9: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  0464FE  08DE: 7528             jne 0x908
  046500  08E0: a0a653           mov al, byte ptr [0x53a6]
  046503  08E3: 2ae4             sub ah, ah
  046505  08E5: 050300           add ax, 3
  046508  08E8: d1e0             shl ax, 1
  04650A  08EA: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04650E  08EE: 8a4f02           mov cl, byte ptr [bx + 2]
  046511  08F1: 2aed             sub ch, ch
  046513  08F3: 03c1             add ax, cx
  046515  08F5: 8a4f05           mov cl, byte ptr [bx + 5]
  046518  08F8: 03c1             add ax, cx
  04651A  08FA: 2b46fc           sub ax, word ptr [bp - 4]
  04651D  08FD: 8946fe           mov word ptr [bp - 2], ax
  046520  0900: c746fa4100       mov word ptr [bp - 6], 0x41
  046525  0905: eb25             jmp 0x92c
  046527  0907: 90               nop 
  046528  0908: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04652C  090C: 8a4702           mov al, byte ptr [bx + 2]
  04652F  090F: 2ae4             sub ah, ah
  046531  0911: 8a4f05           mov cl, byte ptr [bx + 5]
  046534  0914: 2aed             sub ch, ch
  046536  0916: 03c1             add ax, cx
  046538  0918: 8a0ea653         mov cl, byte ptr [0x53a6]
  04653C  091C: 2bc1             sub ax, cx
  04653E  091E: 2b46fc           sub ax, word ptr [bp - 4]
  046541  0921: 050c00           add ax, 0xc
  046544  0924: 8946fe           mov word ptr [bp - 2], ax
  046547  0927: c746fa3200       mov word ptr [bp - 6], 0x32
  04654C  092C: 8b5e08           mov bx, word ptr [bp + 8]
  04654F  092F: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  046553  0933: 2ae4             sub ah, ah
  046555  0935: 2d0a00           sub ax, 0xa
  046558  0938: f7d8             neg ax
  04655A  093A: d1f8             sar ax, 1
  04655C  093C: 0bc0             or ax, ax
  04655E  093E: 7d02             jge 0x942
  046560  0940: 2bc0             sub ax, ax
  046562  0942: 2946fe           sub word ptr [bp - 2], ax
  046565  0945: ff760c           push word ptr [bp + 0xc]
  046568  0948: ff760a           push word ptr [bp + 0xa]
  04656B  094B: 9a18071f18       lcall 0x181f, 0x718
  046570  0950: 83c404           add sp, 4
  046573  0953: 40               inc ax
  046574  0954: 7403             je 0x959
  046576  0956: d166fe           shl word ptr [bp - 2], 1
  046579  0959: 8b46fe           mov ax, word ptr [bp - 2]
  04657C  095C: 3d0100           cmp ax, 1
  04657F  095F: 7d03             jge 0x964
  046581  0961: b80100           mov ax, 1
  046584  0964: 8946fe           mov word ptr [bp - 2], ax
  046587  0967: 8b46fa           mov ax, word ptr [bp - 6]
  04658A  096A: f76efe           imul word ptr [bp - 2]
  04658D  096D: 8946fe           mov word ptr [bp - 2], ax
  046590  0970: 837e0804         cmp word ptr [bp + 8], 4
  046594  0974: 7d2b             jge 0x9a1
  046596  0976: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04659A  097A: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04659F  097F: 7520             jne 0x9a1
  0465A1  0981: ff369453         push word ptr [0x5394]
  0465A5  0985: ff36528d         push word ptr [0x8d52]
  0465A9  0989: 9a0c031f18       lcall 0x181f, 0x30c
  0465AE  098E: 83c404           add sp, 4
  0465B1  0991: 50               push ax
  0465B2  0992: 9a600a1f18       lcall 0x181f, 0xa60
  0465B7  0997: 83c402           add sp, 2
  0465BA  099A: 40               inc ax
  0465BB  099B: f76efe           imul word ptr [bp - 2]
  0465BE  099E: 8946fe           mov word ptr [bp - 2], ax
  0465C1  09A1: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0465C5  09A5: f6470304         test byte ptr [bx + 3], 4
  0465C9  09A9: 7405             je 0x9b0
  0465CB  09AB: d1f8             sar ax, 1
  0465CD  09AD: 0146fe           add word ptr [bp - 2], ax
  0465D0  09B0: 6a02             push 2
  0465D2  09B2: ff7608           push word ptr [bp + 8]
  0465D5  09B5: 9ab4071f18       lcall 0x181f, 0x7b4
  0465DA  09BA: 83c404           add sp, 4
  0465DD  09BD: 0bc0             or ax, ax
  0465DF  09BF: 7405             je 0x9c6
  0465E1  09C1: c746fe0000       mov word ptr [bp - 2], 0
  0465E6  09C6: d17efe           sar word ptr [bp - 2], 1
  0465E9  09C9: 8b46fe           mov ax, word ptr [bp - 2]
  0465EC  09CC: c9               leave 
  0465ED  09CD: cb               retf 
  0465EE  09CE: ea98031f1a       ljmp 0x1a1f:0x398
