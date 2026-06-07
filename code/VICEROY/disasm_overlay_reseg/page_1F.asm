; ============================================================
; VICEROY.EXE overlay page 0x1F (record 30) -- RE-SEGMENTED
; file_offset (disk image) = 0x0785A0
; code_offset (first insn) = 0x078640
; code_end (next reloc hdr)= 0x078D3E  [resident size 112 para -> nominal_end 0x078CA0; on-disk code spills past it]
; reloc_count = 30  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x0785A0)
; functions in page = 16
; ============================================================

; ---- func_078640  size=189  insns=68  prologue=ENTER 0x0002,0  terminal=RETF imm16 ----
  078640  00A0: c8020000         enter 2, 0
  078644  00A4: 53               push bx
  078645  00A5: 57               push di
  078646  00A6: 56               push si
  078647  00A7: 8bf0             mov si, ax
  078649  00A9: bffdff           mov di, 0xfffd
  07864C  00AC: 897efe           mov word ptr [bp - 2], di
  07864F  00AF: 8d4608           lea ax, [bp + 8]
  078652  00B2: 50               push ax
  078653  00B3: 8d4606           lea ax, [bp + 6]
  078656  00B6: 50               push ax
  078657  00B7: 8b5efc           mov bx, word ptr [bp - 4]
  07865A  00BA: 8d460c           lea ax, [bp + 0xc]
  07865D  00BD: 8d560a           lea dx, [bp + 0xa]
  078660  00C0: 9acc0e1f18       lcall 0x181f, 0xecc
  078665  00C5: 0bc0             or ax, ax
  078667  00C7: 7403             je 0xcc
  078669  00C9: e98100           jmp 0x14d
  07866C  00CC: 83fef8           cmp si, -8
  07866F  00CF: 7555             jne 0x126
  078671  00D1: 681826           push 0x2618
  078674  00D4: 8d1e282d         lea bx, [0x2d28]
  078678  00D8: 8b4608           mov ax, word ptr [bp + 8]
  07867B  00DB: 8b5606           mov dx, word ptr [bp + 6]
  07867E  00DE: 9aa00f1f1a       lcall 0x1a1f, 0xfa0
  078683  00E3: a12e2d           mov ax, word ptr [0x2d2e]
  078686  00E6: 0b062c2d         or ax, word ptr [0x2d2c]
  07868A  00EA: 743a             je 0x126
  07868C  00EC: 8b5efc           mov bx, word ptr [bp - 4]
  07868F  00EF: ff7706           push word ptr [bx + 6]
  078692  00F2: ff7704           push word ptr [bx + 4]
  078695  00F5: ff7702           push word ptr [bx + 2]
  078698  00F8: ff37             push word ptr [bx]
  07869A  00FA: ff362e2d         push word ptr [0x2d2e]
  07869E  00FE: ff362c2d         push word ptr [0x2d2c]
  0786A2  0102: ff362a2d         push word ptr [0x2d2a]
  0786A6  0106: ff36282d         push word ptr [0x2d28]
  0786AA  010A: 6a00             push 0
  0786AC  010C: ff7608           push word ptr [bp + 8]
  0786AF  010F: ff7606           push word ptr [bp + 6]
  0786B2  0112: 8b460c           mov ax, word ptr [bp + 0xc]
  0786B5  0115: 8b560a           mov dx, word ptr [bp + 0xa]
  0786B8  0118: 2bdb             sub bx, bx
  0786BA  011A: 9a3a031f18       lcall 0x181f, 0x33a
  0786BF  011F: c746feffff       mov word ptr [bp - 2], 0xffff
  0786C4  0124: eb27             jmp 0x14d
  0786C6  0126: 83fefe           cmp si, -2
  0786C9  0129: 7427             je 0x152
  0786CB  012B: ff7608           push word ptr [bp + 8]
  0786CE  012E: ff7606           push word ptr [bp + 6]
  0786D1  0131: 8b5efc           mov bx, word ptr [bp - 4]
  0786D4  0134: 8b460c           mov ax, word ptr [bp + 0xc]
  0786D7  0137: 8b560a           mov dx, word ptr [bp + 0xa]
  0786DA  013A: 9a960f1f1a       lcall 0x1a1f, 0xf96
  0786DF  013F: 8bf0             mov si, ax
  0786E1  0141: 0bf6             or si, si
  0786E3  0143: 7c0d             jl 0x152
  0786E5  0145: bff6ff           mov di, 0xfff6
  0786E8  0148: 2bfe             sub di, si
  0786EA  014A: 897efe           mov word ptr [bp - 2], di
  0786ED  014D: 8b76fe           mov si, word ptr [bp - 2]
  0786F0  0150: eb03             jmp 0x155
  0786F2  0152: befdff           mov si, 0xfffd
  0786F5  0155: 8bc6             mov ax, si
  0786F7  0157: 5e               pop si
  0786F8  0158: 5f               pop di
  0786F9  0159: c9               leave 
  0786FA  015A: ca0800           retf 8

; ---- func_0786FE  size=163  insns=63  prologue=push bp;mov bp,sp  terminal=RETF imm16 ----
  0786FE  015E: 55               push bp
  0786FF  015F: 8bec             mov bp, sp
  078701  0161: 53               push bx
  078702  0162: 56               push si
  078703  0163: 8bf0             mov si, ax
  078705  0165: 8d4608           lea ax, [bp + 8]
  078708  0168: 50               push ax
  078709  0169: 8d4606           lea ax, [bp + 6]
  07870C  016C: 50               push ax
  07870D  016D: 8b5efe           mov bx, word ptr [bp - 2]
  078710  0170: 8d460c           lea ax, [bp + 0xc]
  078713  0173: 8d560a           lea dx, [bp + 0xa]
  078716  0176: 9acc0e1f18       lcall 0x181f, 0xecc
  07871B  017B: 0bc0             or ax, ax
  07871D  017D: 757d             jne 0x1fc
  07871F  017F: 8bc6             mov ax, si
  078721  0181: 2dedff           sub ax, 0xffed
  078724  0184: 7c76             jl 0x1fc
  078726  0186: 2d0900           sub ax, 9
  078729  0189: 7e0b             jle 0x196
  07872B  018B: 2d0900           sub ax, 9
  07872E  018E: 742a             je 0x1ba
  078730  0190: 5e               pop si
  078731  0191: c9               leave 
  078732  0192: ca0800           retf 8
  078735  0195: 90               nop 
  078736  0196: ff760c           push word ptr [bp + 0xc]
  078739  0199: ff760a           push word ptr [bp + 0xa]
  07873C  019C: ff7608           push word ptr [bp + 8]
  07873F  019F: ff7606           push word ptr [bp + 6]
  078742  01A2: 8d440a           lea ax, [si + 0xa]
  078745  01A5: f7d0             not ax
  078747  01A7: 40               inc ax
  078748  01A8: 8b5efe           mov bx, word ptr [bp - 2]
  07874B  01AB: 8b162226         mov dx, word ptr [0x2622]
  07874F  01AF: 9a8c0f1f1a       lcall 0x1a1f, 0xf8c
  078754  01B4: 5e               pop si
  078755  01B5: c9               leave 
  078756  01B6: ca0800           retf 8
  078759  01B9: 90               nop 
  07875A  01BA: ff362e2d         push word ptr [0x2d2e]
  07875E  01BE: ff362c2d         push word ptr [0x2d2c]
  078762  01C2: ff362a2d         push word ptr [0x2d2a]
  078766  01C6: ff36282d         push word ptr [0x2d28]
  07876A  01CA: 8b5efe           mov bx, word ptr [bp - 2]
  07876D  01CD: ff7706           push word ptr [bx + 6]
  078770  01D0: ff7704           push word ptr [bx + 4]
  078773  01D3: ff7702           push word ptr [bx + 2]
  078776  01D6: ff37             push word ptr [bx]
  078778  01D8: ff760a           push word ptr [bp + 0xa]
  07877B  01DB: ff7608           push word ptr [bp + 8]
  07877E  01DE: ff7606           push word ptr [bp + 6]
  078781  01E1: 2bc0             sub ax, ax
  078783  01E3: 99               cdq 
  078784  01E4: 8b5e0c           mov bx, word ptr [bp + 0xc]
  078787  01E7: 9a3a031f18       lcall 0x181f, 0x33a
  07878C  01EC: 833e222600       cmp word ptr [0x2622], 0
  078791  01F1: 7509             jne 0x1fc
  078793  01F3: 8d1e282d         lea bx, [0x2d28]
  078797  01F7: 9a7e0f1f1a       lcall 0x1a1f, 0xf7e
  07879C  01FC: 5e               pop si
  07879D  01FD: c9               leave 
  07879E  01FE: ca0800           retf 8

; ---- func_0787A2  size=58  insns=29  prologue=push bp;mov bp,sp  terminal=RETF ----
  0787A2  0202: 55               push bp
  0787A3  0203: 8bec             mov bp, sp
  0787A5  0205: 52               push dx
  0787A6  0206: 50               push ax
  0787A7  0207: 53               push bx
  0787A8  0208: 56               push si
  0787A9  0209: 8bc8             mov cx, ax
  0787AB  020B: 8bc2             mov ax, dx
  0787AD  020D: f7e1             mul cx
  0787AF  020F: 8bf3             mov si, bx
  0787B1  0211: 9a9a021f18       lcall 0x181f, 0x29a
  0787B6  0216: 894404           mov word ptr [si + 4], ax
  0787B9  0219: 895406           mov word ptr [si + 6], dx
  0787BC  021C: 8bc2             mov ax, dx
  0787BE  021E: 0b4404           or ax, word ptr [si + 4]
  0787C1  0221: 7505             jne 0x228
  0787C3  0223: 2bc0             sub ax, ax
  0787C5  0225: 5e               pop si
  0787C6  0226: c9               leave 
  0787C7  0227: cb               retf 
  0787C8  0228: 8b46fc           mov ax, word ptr [bp - 4]
  0787CB  022B: 8b5efa           mov bx, word ptr [bp - 6]
  0787CE  022E: 894702           mov word ptr [bx + 2], ax
  0787D1  0231: 8b46fe           mov ax, word ptr [bp - 2]
  0787D4  0234: 8907             mov word ptr [bx], ax
  0787D6  0236: b8ffff           mov ax, 0xffff
  0787D9  0239: 5e               pop si
  0787DA  023A: c9               leave 
  0787DB  023B: cb               retf 

; ---- func_0787DC  size=66  insns=31  prologue=push bp;mov bp,sp  terminal=RETF imm16 ----
  0787DC  023C: 55               push bp
  0787DD  023D: 8bec             mov bp, sp
  0787DF  023F: 52               push dx
  0787E0  0240: 50               push ax
  0787E1  0241: 53               push bx
  0787E2  0242: 56               push si
  0787E3  0243: 1e               push ds
  0787E4  0244: ff7606           push word ptr [bp + 6]
  0787E7  0247: 8bc8             mov cx, ax
  0787E9  0249: 8bc2             mov ax, dx
  0787EB  024B: f7e1             mul cx
  0787ED  024D: 8bf3             mov si, bx
  0787EF  024F: 9a900e1f1a       lcall 0x1a1f, 0xe90
  0787F4  0254: 894404           mov word ptr [si + 4], ax
  0787F7  0257: 895406           mov word ptr [si + 6], dx
  0787FA  025A: 8bc2             mov ax, dx
  0787FC  025C: 0b4404           or ax, word ptr [si + 4]
  0787FF  025F: 7507             jne 0x268
  078801  0261: 2bc0             sub ax, ax
  078803  0263: 5e               pop si
  078804  0264: c9               leave 
  078805  0265: ca0200           retf 2
  078808  0268: 8b46fc           mov ax, word ptr [bp - 4]
  07880B  026B: 8b5efa           mov bx, word ptr [bp - 6]
  07880E  026E: 894702           mov word ptr [bx + 2], ax
  078811  0271: 8b46fe           mov ax, word ptr [bp - 2]
  078814  0274: 8907             mov word ptr [bx], ax
  078816  0276: b8ffff           mov ax, 0xffff
  078819  0279: 5e               pop si
  07881A  027A: c9               leave 
  07881B  027B: ca0200           retf 2

; ---- func_07881E  size=55  insns=19  prologue=ENTER 0x0002,0  terminal=RETF ----
  07881E  027E: c8020000         enter 2, 0
  078822  0282: 53               push bx
  078823  0283: c746fe0000       mov word ptr [bp - 2], 0
  078828  0288: 8b4706           mov ax, word ptr [bx + 6]
  07882B  028B: 0b4704           or ax, word ptr [bx + 4]
  07882E  028E: 7410             je 0x2a0
  078830  0290: ff7706           push word ptr [bx + 6]
  078833  0293: ff7704           push word ptr [bx + 4]
  078836  0296: 9aa8011f19       lcall 0x191f, 0x1a8
  07883B  029B: c746feffff       mov word ptr [bp - 2], 0xffff
  078840  02A0: 8b5efc           mov bx, word ptr [bp - 4]
  078843  02A3: 2bc0             sub ax, ax
  078845  02A5: 894706           mov word ptr [bx + 6], ax
  078848  02A8: 894704           mov word ptr [bx + 4], ax
  07884B  02AB: 894702           mov word ptr [bx + 2], ax
  07884E  02AE: 8907             mov word ptr [bx], ax
  078850  02B0: 8b46fe           mov ax, word ptr [bp - 2]
  078853  02B3: c9               leave 
  078854  02B4: cb               retf 

; ---- func_078856  size=28  insns=10  prologue=push bp;mov bp,sp  terminal=RETF ----
  078856  02B6: 55               push bp
  078857  02B7: 8bec             mov bp, sp
  078859  02B9: 8b4606           mov ax, word ptr [bp + 6]
  07885C  02BC: 0b4608           or ax, word ptr [bp + 8]
  07885F  02BF: 740f             je 0x2d0
  078861  02C1: c70672260100     mov word ptr [0x2672], 1
  078867  02C7: ff5e06           lcall [bp + 6]
  07886A  02CA: c70672260000     mov word ptr [0x2672], 0
  078870  02D0: c9               leave 
  078871  02D1: cb               retf 

; ---- func_078872  size=391  insns=145  prologue=ENTER 0x0014,0  terminal=RETF ----
  078872  02D2: c8140000         enter 0x14, 0
  078876  02D6: 52               push dx
  078877  02D7: 50               push ax
  078878  02D8: 2bc9             sub cx, cx
  07887A  02DA: 894efa           mov word ptr [bp - 6], cx
  07887D  02DD: 894ef8           mov word ptr [bp - 8], cx
  078880  02E0: 0bd2             or dx, dx
  078882  02E2: 7f0c             jg 0x2f0
  078884  02E4: 7d03             jge 0x2e9
  078886  02E6: e94b01           jmp 0x434
  078889  02E9: 0bc0             or ax, ax
  07888B  02EB: 7503             jne 0x2f0
  07888D  02ED: e94401           jmp 0x434
  078890  02F0: 9ac60f1f1a       lcall 0x1a1f, 0xfc6
  078895  02F5: 8946ec           mov word ptr [bp - 0x14], ax
  078898  02F8: 8956ee           mov word ptr [bp - 0x12], dx
  07889B  02FB: 9abc0f1f1a       lcall 0x1a1f, 0xfbc
  0788A0  0300: 8946fc           mov word ptr [bp - 4], ax
  0788A3  0303: 8956fe           mov word ptr [bp - 2], dx
  0788A6  0306: 8b46e8           mov ax, word ptr [bp - 0x18]
  0788A9  0309: 8b56ea           mov dx, word ptr [bp - 0x16]
  0788AC  030C: a35226           mov word ptr [0x2652], ax
  0788AF  030F: 89165426         mov word ptr [0x2654], dx
  0788B3  0313: 8b46ec           mov ax, word ptr [bp - 0x14]
  0788B6  0316: 8b56ee           mov dx, word ptr [bp - 0x12]
  0788B9  0319: a35626           mov word ptr [0x2656], ax
  0788BC  031C: 89165826         mov word ptr [0x2658], dx
  0788C0  0320: 8b4efc           mov cx, word ptr [bp - 4]
  0788C3  0323: 8b5efe           mov bx, word ptr [bp - 2]
  0788C6  0326: 890e5a26         mov word ptr [0x265a], cx
  0788CA  032A: 891e5c26         mov word ptr [0x265c], bx
  0788CE  032E: 803e4d2600       cmp byte ptr [0x264d], 0
  0788D3  0333: 7513             jne 0x348
  0788D5  0335: a35e26           mov word ptr [0x265e], ax
  0788D8  0338: 89166026         mov word ptr [0x2660], dx
  0788DC  033C: a36226           mov word ptr [0x2662], ax
  0788DF  033F: 89166426         mov word ptr [0x2664], dx
  0788E3  0343: c6064d2601       mov byte ptr [0x264d], 1
  0788E8  0348: 803e4e2600       cmp byte ptr [0x264e], 0
  0788ED  034D: 7517             jne 0x366
  0788EF  034F: 8bc1             mov ax, cx
  0788F1  0351: 8bd3             mov dx, bx
  0788F3  0353: a36626           mov word ptr [0x2666], ax
  0788F6  0356: 89166826         mov word ptr [0x2668], dx
  0788FA  035A: a36a26           mov word ptr [0x266a], ax
  0788FD  035D: 89166c26         mov word ptr [0x266c], dx
  078901  0361: c6064e2601       mov byte ptr [0x264e], 1
  078906  0366: 8b46e8           mov ax, word ptr [bp - 0x18]
  078909  0369: 8b56ea           mov dx, word ptr [bp - 0x16]
  07890C  036C: 3bda             cmp bx, dx
  07890E  036E: 7c0c             jl 0x37c
  078910  0370: 7f04             jg 0x376
  078912  0372: 3bc8             cmp cx, ax
  078914  0374: 7206             jb 0x37c
  078916  0376: b80100           mov ax, 1
  078919  0379: eb03             jmp 0x37e
  07891B  037B: 90               nop 
  07891C  037C: 2bc0             sub ax, ax
  07891E  037E: 8946f6           mov word ptr [bp - 0xa], ax
  078921  0381: 8b46e8           mov ax, word ptr [bp - 0x18]
  078924  0384: 3bda             cmp bx, dx
  078926  0386: 7c0c             jl 0x394
  078928  0388: 7f04             jg 0x38e
  07892A  038A: 3bc8             cmp cx, ax
  07892C  038C: 7206             jb 0x394
  07892E  038E: 8bc1             mov ax, cx
  078930  0390: 8bd3             mov dx, bx
  078932  0392: eb06             jmp 0x39a
  078934  0394: 8b46ec           mov ax, word ptr [bp - 0x14]
  078937  0397: 8b56ee           mov dx, word ptr [bp - 0x12]
  07893A  039A: 8946f0           mov word ptr [bp - 0x10], ax
  07893D  039D: 8956f2           mov word ptr [bp - 0xe], dx
  078940  03A0: 8b46e8           mov ax, word ptr [bp - 0x18]
  078943  03A3: 8b56ea           mov dx, word ptr [bp - 0x16]
  078946  03A6: d1fa             sar dx, 1
  078948  03A8: d1d8             rcr ax, 1
  07894A  03AA: d1fa             sar dx, 1
  07894C  03AC: d1d8             rcr ax, 1
  07894E  03AE: d1fa             sar dx, 1
  078950  03B0: d1d8             rcr ax, 1
  078952  03B2: d1fa             sar dx, 1
  078954  03B4: d1d8             rcr ax, 1
  078956  03B6: 40               inc ax
  078957  03B7: 8946f4           mov word ptr [bp - 0xc], ax
  07895A  03BA: 8b46e8           mov ax, word ptr [bp - 0x18]
  07895D  03BD: 8b56ea           mov dx, word ptr [bp - 0x16]
  078960  03C0: 3bda             cmp bx, dx
  078962  03C2: 7c42             jl 0x406
  078964  03C4: 7f04             jg 0x3ca
  078966  03C6: 3bc8             cmp cx, ax
  078968  03C8: 723c             jb 0x406
  07896A  03CA: 52               push dx
  07896B  03CB: 50               push ax
  07896C  03CC: 9ade0f1f1a       lcall 0x1a1f, 0xfde
  078971  03D1: 83c404           add sp, 4
  078974  03D4: 8946f8           mov word ptr [bp - 8], ax
  078977  03D7: 8956fa           mov word ptr [bp - 6], dx
  07897A  03DA: 0bd0             or dx, ax
  07897C  03DC: 7428             je 0x406
  07897E  03DE: 9abc0f1f1a       lcall 0x1a1f, 0xfbc
  078983  03E3: 8946fc           mov word ptr [bp - 4], ax
  078986  03E6: 8956fe           mov word ptr [bp - 2], dx
  078989  03E9: 8946f0           mov word ptr [bp - 0x10], ax
  07898C  03EC: 8956f2           mov word ptr [bp - 0xe], dx
  07898F  03EF: 3b166c26         cmp dx, word ptr [0x266c]
  078993  03F3: 7f3f             jg 0x434
  078995  03F5: 7c06             jl 0x3fd
  078997  03F7: 3b066a26         cmp ax, word ptr [0x266a]
  07899B  03FB: 7337             jae 0x434
  07899D  03FD: a36a26           mov word ptr [0x266a], ax
  0789A0  0400: 89166c26         mov word ptr [0x266c], dx
  0789A4  0404: eb2e             jmp 0x434
  0789A6  0406: 8b5ef4           mov bx, word ptr [bp - 0xc]
  0789A9  0409: b448             mov ah, 0x48
  0789AB  040B: cd21             int 0x21
  0789AD  040D: 720b             jb 0x41a
  0789AF  040F: c746f80000       mov word ptr [bp - 8], 0
  0789B4  0414: 8946fa           mov word ptr [bp - 6], ax
  0789B7  0417: eb01             jmp 0x41a
  0789B9  0419: 90               nop 
  0789BA  041A: 9ac60f1f1a       lcall 0x1a1f, 0xfc6
  0789BF  041F: 3b166426         cmp dx, word ptr [0x2664]
  0789C3  0423: 7f0f             jg 0x434
  0789C5  0425: 7c06             jl 0x42d
  0789C7  0427: 3b066226         cmp ax, word ptr [0x2662]
  0789CB  042B: 7307             jae 0x434
  0789CD  042D: a36226           mov word ptr [0x2662], ax
  0789D0  0430: 89166426         mov word ptr [0x2664], dx
  0789D4  0434: 8b46fa           mov ax, word ptr [bp - 6]
  0789D7  0437: 0b46f8           or ax, word ptr [bp - 8]
  0789DA  043A: 7504             jne 0x440
  0789DC  043C: b001             mov al, 1
  0789DE  043E: eb02             jmp 0x442
  0789E0  0440: 2ac0             sub al, al
  0789E2  0442: a24f26           mov byte ptr [0x264f], al
  0789E5  0445: 8b46f8           mov ax, word ptr [bp - 8]
  0789E8  0448: 8b56fa           mov dx, word ptr [bp - 6]
  0789EB  044B: c9               leave 
  0789EC  044C: ca0400           retf 4
  0789EF  044F: 90               nop 
  0789F0  0450: 1e               push ds
  0789F1  0451: 687426           push 0x2674
  0789F4  0454: 0e               push cs
  0789F5  0455: e8f000           call 0x548
  0789F8  0458: cb               retf 

; ---- func_0789FA  size=80  insns=30  prologue=ENTER 0x0006,0  terminal=RETF imm16 ----
  0789FA  045A: c8060000         enter 6, 0
  0789FE  045E: 8b4608           mov ax, word ptr [bp + 8]
  078A01  0461: 8946fc           mov word ptr [bp - 4], ax
  078A04  0464: 817efc00a0       cmp word ptr [bp - 4], 0xa000
  078A09  0469: 7205             jb 0x470
  078A0B  046B: b80100           mov ax, 1
  078A0E  046E: eb02             jmp 0x472
  078A10  0470: 2bc0             sub ax, ax
  078A12  0472: 8946fe           mov word ptr [bp - 2], ax
  078A15  0475: 48               dec ax
  078A16  0476: 7510             jne 0x488
  078A18  0478: ff7608           push word ptr [bp + 8]
  078A1B  047B: ff7606           push word ptr [bp + 6]
  078A1E  047E: 9ad40f1f1a       lcall 0x1a1f, 0xfd4
  078A23  0483: 83c404           add sp, 4
  078A26  0486: eb0c             jmp 0x494
  078A28  0488: c44606           les ax, ptr [bp + 6]
  078A2B  048B: b449             mov ah, 0x49
  078A2D  048D: cd21             int 0x21
  078A2F  048F: d0d8             rcr al, 1
  078A31  0491: 98               cwde 
  078A32  0492: 8ac4             mov al, ah
  078A34  0494: 8946fa           mov word ptr [bp - 6], ax
  078A37  0497: ff367026         push word ptr [0x2670]
  078A3B  049B: ff366e26         push word ptr [0x266e]
  078A3F  049F: 0e               push cs
  078A40  04A0: e8aa00           call 0x54d
  078A43  04A3: 8b46fa           mov ax, word ptr [bp - 6]
  078A46  04A6: c9               leave 
  078A47  04A7: ca0400           retf 4

; ---- func_078A4A  size=168  insns=61  prologue=ENTER 0x0002,0  terminal=JMP-tail ----
  078A4A  04AA: c8020000         enter 2, 0
  078A4E  04AE: 52               push dx
  078A4F  04AF: 50               push ax
  078A50  04B0: d1fa             sar dx, 1
  078A52  04B2: d1d8             rcr ax, 1
  078A54  04B4: d1fa             sar dx, 1
  078A56  04B6: d1d8             rcr ax, 1
  078A58  04B8: d1fa             sar dx, 1
  078A5A  04BA: d1d8             rcr ax, 1
  078A5C  04BC: d1fa             sar dx, 1
  078A5E  04BE: d1d8             rcr ax, 1
  078A60  04C0: 40               inc ax
  078A61  04C1: 8946fe           mov word ptr [bp - 2], ax
  078A64  04C4: c45e06           les bx, ptr [bp + 6]
  078A67  04C7: 8b5efe           mov bx, word ptr [bp - 2]
  078A6A  04CA: b44a             mov ah, 0x4a
  078A6C  04CC: cd21             int 0x21
  078A6E  04CE: d0d8             rcr al, 1
  078A70  04D0: 98               cwde 
  078A71  04D1: 8ac4             mov al, ah
  078A73  04D3: c9               leave 
  078A74  04D4: ca0400           retf 4
  078A77  04D7: 90               nop 
  078A78  04D8: a16226           mov ax, word ptr [0x2662]
  078A7B  04DB: 8b166426         mov dx, word ptr [0x2664]
  078A7F  04DF: a34ca6           mov word ptr [0xa64c], ax
  078A82  04E2: 89164ea6         mov word ptr [0xa64e], dx
  078A86  04E6: a16a26           mov ax, word ptr [0x266a]
  078A89  04E9: 8b166c26         mov dx, word ptr [0x266c]
  078A8D  04ED: a350a6           mov word ptr [0xa650], ax
  078A90  04F0: 891652a6         mov word ptr [0xa652], dx
  078A94  04F4: cb               retf 
  078A95  04F5: 90               nop 
  078A96  04F6: 9ac60f1f1a       lcall 0x1a1f, 0xfc6
  078A9B  04FB: 3b164ea6         cmp dx, word ptr [0xa64e]
  078A9F  04FF: 7f0f             jg 0x510
  078AA1  0501: 7c06             jl 0x509
  078AA3  0503: 3b064ca6         cmp ax, word ptr [0xa64c]
  078AA7  0507: 7707             ja 0x510
  078AA9  0509: 9ac60f1f1a       lcall 0x1a1f, 0xfc6
  078AAE  050E: eb07             jmp 0x517
  078AB0  0510: a14ca6           mov ax, word ptr [0xa64c]
  078AB3  0513: 8b164ea6         mov dx, word ptr [0xa64e]
  078AB7  0517: a36226           mov word ptr [0x2662], ax
  078ABA  051A: 89166426         mov word ptr [0x2664], dx
  078ABE  051E: 9abc0f1f1a       lcall 0x1a1f, 0xfbc
  078AC3  0523: 3b1652a6         cmp dx, word ptr [0xa652]
  078AC7  0527: 7f0f             jg 0x538
  078AC9  0529: 7c06             jl 0x531
  078ACB  052B: 3b0650a6         cmp ax, word ptr [0xa650]
  078ACF  052F: 7707             ja 0x538
  078AD1  0531: 9abc0f1f1a       lcall 0x1a1f, 0xfbc
  078AD6  0536: eb07             jmp 0x53f
  078AD8  0538: a150a6           mov ax, word ptr [0xa650]
  078ADB  053B: 8b1652a6         mov dx, word ptr [0xa652]
  078ADF  053F: a36a26           mov word ptr [0x266a], ax
  078AE2  0542: 89166c26         mov word ptr [0x266c], dx
  078AE6  0546: cb               retf 
  078AE7  0547: 90               nop 
  078AE8  0548: ea900e1f1a       ljmp 0x1a1f:0xe90
  078AED  054D: eaae0f1f1a       ljmp 0x1a1f:0xfae

; ---- func_078AF2  size=28  insns=14  prologue=push bp;mov bp,sp  terminal=RETF ----
  078AF2  0552: 55               push bp
  078AF3  0553: 8bec             mov bp, sp
  078AF5  0555: b448             mov ah, 0x48
  078AF7  0557: bbffff           mov bx, 0xffff
  078AFA  055A: cd21             int 0x21
  078AFC  055C: 32f6             xor dh, dh
  078AFE  055E: 8ad7             mov dl, bh
  078B00  0560: c1e204           shl dx, 4
  078B03  0563: 8ad6             mov dl, dh
  078B05  0565: 32f6             xor dh, dh
  078B07  0567: 8bc3             mov ax, bx
  078B09  0569: c1e004           shl ax, 4
  078B0C  056C: c9               leave 
  078B0D  056D: cb               retf 

; ---- func_078B0E  size=191  insns=67  prologue=ENTER 0x0008,0  terminal=RETF imm16 ----
  078B0E  056E: c8080000         enter 8, 0
  078B12  0572: 0e               push cs
  078B13  0573: e82200           call 0x598
  078B16  0576: 8946fc           mov word ptr [bp - 4], ax
  078B19  0579: 8956fe           mov word ptr [bp - 2], dx
  078B1C  057C: 9abc0f1f1a       lcall 0x1a1f, 0xfbc
  078B21  0581: 3b56fe           cmp dx, word ptr [bp - 2]
  078B24  0584: 7f0d             jg 0x593
  078B26  0586: 7c05             jl 0x58d
  078B28  0588: 3b46fc           cmp ax, word ptr [bp - 4]
  078B2B  058B: 7306             jae 0x593
  078B2D  058D: 8b56fe           mov dx, word ptr [bp - 2]
  078B30  0590: 8b46fc           mov ax, word ptr [bp - 4]
  078B33  0593: c9               leave 
  078B34  0594: cb               retf 
  078B35  0595: 90               nop 
  078B36  0596: cb               retf 
  078B37  0597: 90               nop 
  078B38  0598: eac60f1f1a       ljmp 0x1a1f:0xfc6
  078B3D  059D: 00c8             add al, cl
  078B3F  059F: 0200             add al, byte ptr [bx + si]
  078B41  05A1: 0056c7           add byte ptr [bp - 0x39], dl
  078B44  05A4: 46               inc si
  078B45  05A5: fe01             inc byte ptr [bx + di]
  078B47  05A7: 008bc8c4         add byte ptr [bp + di - 0x3b38], cl
  078B4B  05AB: 5e               pop si
  078B4C  05AC: 0e               push cs
  078B4D  05AD: 268807           mov byte ptr es:[bx], al
  078B50  05B0: ff7608           push word ptr [bp + 8]
  078B53  05B3: ff7606           push word ptr [bp + 6]
  078B56  05B6: 8b460a           mov ax, word ptr [bp + 0xa]
  078B59  05B9: 8b560c           mov dx, word ptr [bp + 0xc]
  078B5C  05BC: 8bf1             mov si, cx
  078B5E  05BE: 9a900e1f1a       lcall 0x1a1f, 0xe90
  078B63  05C3: c45e0e           les bx, ptr [bp + 0xe]
  078B66  05C6: 26894702         mov word ptr es:[bx + 2], ax
  078B6A  05CA: 26895704         mov word ptr es:[bx + 4], dx
  078B6E  05CE: 8bc2             mov ax, dx
  078B70  05D0: 260b4702         or ax, word ptr es:[bx + 2]
  078B74  05D4: 751c             jne 0x5f2
  078B76  05D6: ff760c           push word ptr [bp + 0xc]
  078B79  05D9: ff760a           push word ptr [bp + 0xa]
  078B7C  05DC: 9a7a021f19       lcall 0x191f, 0x27a
  078B81  05E1: 52               push dx
  078B82  05E2: 50               push ax
  078B83  05E3: 8bde             mov bx, si
  078B85  05E5: b8c4ff           mov ax, 0xffc4
  078B88  05E8: ba0200           mov dx, 2
  078B8B  05EB: 9a72071f18       lcall 0x181f, 0x772
  078B90  05F0: eb33             jmp 0x625
  078B92  05F2: c45e0e           les bx, ptr [bp + 0xe]
  078B95  05F5: 26c6470101       mov byte ptr es:[bx + 1], 1
  078B9A  05FA: 268b4702         mov ax, word ptr es:[bx + 2]
  078B9E  05FE: 268b5704         mov dx, word ptr es:[bx + 4]
  078BA2  0602: 26894706         mov word ptr es:[bx + 6], ax
  078BA6  0606: 26895708         mov word ptr es:[bx + 8], dx
  078BAA  060A: 8b460a           mov ax, word ptr [bp + 0xa]
  078BAD  060D: 8b560c           mov dx, word ptr [bp + 0xc]
  078BB0  0610: 2689470e         mov word ptr es:[bx + 0xe], ax
  078BB4  0614: 26895710         mov word ptr es:[bx + 0x10], dx
  078BB8  0618: 2689470a         mov word ptr es:[bx + 0xa], ax
  078BBC  061C: 2689570c         mov word ptr es:[bx + 0xc], dx
  078BC0  0620: c746fe0000       mov word ptr [bp - 2], 0
  078BC5  0625: 8b46fe           mov ax, word ptr [bp - 2]
  078BC8  0628: 5e               pop si
  078BC9  0629: c9               leave 
  078BCA  062A: ca0c00           retf 0xc

; ---- func_078BCE  size=62  insns=19  prologue=push bp;mov bp,sp  terminal=RETF imm16 ----
  078BCE  062E: 55               push bp
  078BCF  062F: 8bec             mov bp, sp
  078BD1  0631: c45e0e           les bx, ptr [bp + 0xe]
  078BD4  0634: 26c6470100       mov byte ptr es:[bx + 1], 0
  078BD9  0639: 268807           mov byte ptr es:[bx], al
  078BDC  063C: 8b460a           mov ax, word ptr [bp + 0xa]
  078BDF  063F: 8b560c           mov dx, word ptr [bp + 0xc]
  078BE2  0642: 26894706         mov word ptr es:[bx + 6], ax
  078BE6  0646: 26895708         mov word ptr es:[bx + 8], dx
  078BEA  064A: 26894702         mov word ptr es:[bx + 2], ax
  078BEE  064E: 26895704         mov word ptr es:[bx + 4], dx
  078BF2  0652: 8b4606           mov ax, word ptr [bp + 6]
  078BF5  0655: 8b5608           mov dx, word ptr [bp + 8]
  078BF8  0658: 2689470e         mov word ptr es:[bx + 0xe], ax
  078BFC  065C: 26895710         mov word ptr es:[bx + 0x10], dx
  078C00  0660: 2689470a         mov word ptr es:[bx + 0xa], ax
  078C04  0664: 2689570c         mov word ptr es:[bx + 0xc], dx
  078C08  0668: c9               leave 
  078C09  0669: ca0c00           retf 0xc

; ---- func_078C0C  size=59  insns=18  prologue=push bp;mov bp,sp  terminal=RETF imm16 ----
  078C0C  066C: 55               push bp
  078C0D  066D: 8bec             mov bp, sp
  078C0F  066F: c45e06           les bx, ptr [bp + 6]
  078C12  0672: 26807f0100       cmp byte ptr es:[bx + 1], 0
  078C17  0677: 740d             je 0x686
  078C19  0679: 26ff7704         push word ptr es:[bx + 4]
  078C1D  067D: 26ff7702         push word ptr es:[bx + 2]
  078C21  0681: 9aa8011f19       lcall 0x191f, 0x1a8
  078C26  0686: c45e06           les bx, ptr [bp + 6]
  078C29  0689: 2bc0             sub ax, ax
  078C2B  068B: 26894704         mov word ptr es:[bx + 4], ax
  078C2F  068F: 26894702         mov word ptr es:[bx + 2], ax
  078C33  0693: 26894710         mov word ptr es:[bx + 0x10], ax
  078C37  0697: 2689470e         mov word ptr es:[bx + 0xe], ax
  078C3B  069B: 2689470c         mov word ptr es:[bx + 0xc], ax
  078C3F  069F: 2689470a         mov word ptr es:[bx + 0xa], ax
  078C43  06A3: c9               leave 
  078C44  06A4: ca0400           retf 4

; ---- func_078C48  size=105  insns=37  prologue=ENTER 0x0004,0  terminal=RETF imm16 ----
  078C48  06A8: c8040000         enter 4, 0
  078C4C  06AC: 52               push dx
  078C4D  06AD: 50               push ax
  078C4E  06AE: 2bc9             sub cx, cx
  078C50  06B0: 894efe           mov word ptr [bp - 2], cx
  078C53  06B3: 894efc           mov word ptr [bp - 4], cx
  078C56  06B6: c45e06           les bx, ptr [bp + 6]
  078C59  06B9: 26395710         cmp word ptr es:[bx + 0x10], dx
  078C5D  06BD: 7f25             jg 0x6e4
  078C5F  06BF: 7c06             jl 0x6c7
  078C61  06C1: 2639470e         cmp word ptr es:[bx + 0xe], ax
  078C65  06C5: 731d             jae 0x6e4
  078C67  06C7: 52               push dx
  078C68  06C8: 50               push ax
  078C69  06C9: 26ff7710         push word ptr es:[bx + 0x10]
  078C6D  06CD: 26ff770e         push word ptr es:[bx + 0xe]
  078C71  06D1: 268a1f           mov bl, byte ptr es:[bx]
  078C74  06D4: 2aff             sub bh, bh
  078C76  06D6: b8c3ff           mov ax, 0xffc3
  078C79  06D9: ba0200           mov dx, 2
  078C7C  06DC: 9a72071f18       lcall 0x181f, 0x772
  078C81  06E1: eb24             jmp 0x707
  078C83  06E3: 90               nop 
  078C84  06E4: 268b4706         mov ax, word ptr es:[bx + 6]
  078C88  06E8: 268b5708         mov dx, word ptr es:[bx + 8]
  078C8C  06EC: 8946fc           mov word ptr [bp - 4], ax
  078C8F  06EF: 8956fe           mov word ptr [bp - 2], dx
  078C92  06F2: 8b46f8           mov ax, word ptr [bp - 8]
  078C95  06F5: 26014706         add word ptr es:[bx + 6], ax
  078C99  06F9: 8b46f8           mov ax, word ptr [bp - 8]
  078C9C  06FC: 8b56fa           mov dx, word ptr [bp - 6]
  078C9F  06FF: 2629470e         sub word ptr es:[bx + 0xe], ax
  078CA3  0703: 26195710         sbb word ptr es:[bx + 0x10], dx
  078CA7  0707: 8b46fc           mov ax, word ptr [bp - 4]
  078CAA  070A: 8b56fe           mov dx, word ptr [bp - 2]
  078CAD  070D: c9               leave 
  078CAE  070E: ca0400           retf 4

; ---- func_078CB2  size=137  insns=48  prologue=ENTER 0x000A,0  terminal=page-end ----
  078CB2  0712: c80a0000         enter 0xa, 0
  078CB6  0716: 57               push di
  078CB7  0717: 56               push si
  078CB8  0718: c45e06           les bx, ptr [bp + 6]
  078CBB  071B: 26837f1000       cmp word ptr es:[bx + 0x10], 0
  078CC0  0720: 7f09             jg 0x72b
  078CC2  0722: 7c69             jl 0x78d
  078CC4  0724: 26837f0e10       cmp word ptr es:[bx + 0xe], 0x10
  078CC9  0729: 7262             jb 0x78d
  078CCB  072B: 268b470a         mov ax, word ptr es:[bx + 0xa]
  078CCF  072F: 268b570c         mov dx, word ptr es:[bx + 0xc]
  078CD3  0733: 262b470e         sub ax, word ptr es:[bx + 0xe]
  078CD7  0737: 261b5710         sbb dx, word ptr es:[bx + 0x10]
  078CDB  073B: 8946fc           mov word ptr [bp - 4], ax
  078CDE  073E: 8956fe           mov word ptr [bp - 2], dx
  078CE1  0741: 268b4f02         mov cx, word ptr es:[bx + 2]
  078CE5  0745: 268b7704         mov si, word ptr es:[bx + 4]
  078CE9  0749: 894ef8           mov word ptr [bp - 8], cx
  078CEC  074C: 8976fa           mov word ptr [bp - 6], si
  078CEF  074F: 050f00           add ax, 0xf
  078CF2  0752: 83d200           adc dx, 0
  078CF5  0755: d1fa             sar dx, 1
  078CF7  0757: d1d8             rcr ax, 1
  078CF9  0759: d1fa             sar dx, 1
  078CFB  075B: d1d8             rcr ax, 1
  078CFD  075D: d1fa             sar dx, 1
  078CFF  075F: d1d8             rcr ax, 1
  078D01  0761: d1fa             sar dx, 1
  078D03  0763: d1d8             rcr ax, 1
  078D05  0765: 8946f6           mov word ptr [bp - 0xa], ax
  078D08  0768: b44a             mov ah, 0x4a
  078D0A  076A: c47ef8           les di, ptr [bp - 8]
  078D0D  076D: 8b5ef6           mov bx, word ptr [bp - 0xa]
  078D10  0770: cd21             int 0x21
  078D12  0772: 8b46fc           mov ax, word ptr [bp - 4]
  078D15  0775: 8b56fe           mov dx, word ptr [bp - 2]
  078D18  0778: c45e06           les bx, ptr [bp + 6]
  078D1B  077B: 2689470a         mov word ptr es:[bx + 0xa], ax
  078D1F  077F: 2689570c         mov word ptr es:[bx + 0xc], dx
  078D23  0783: 2bc0             sub ax, ax
  078D25  0785: 26894710         mov word ptr es:[bx + 0x10], ax
  078D29  0789: 2689470e         mov word ptr es:[bx + 0xe], ax
  078D2D  078D: c45e06           les bx, ptr [bp + 6]
  078D30  0790: 268b470a         mov ax, word ptr es:[bx + 0xa]
  078D34  0794: 268b570c         mov dx, word ptr es:[bx + 0xc]
  078D38  0798: 5e               pop si
  078D39  0799: 5f               pop di
  078D3A  079A: c9               leave 

; ---- func_078D3B  size=2  insns=0  prologue=UNRECOGNISED (0xCA)  terminal=page-end ----
