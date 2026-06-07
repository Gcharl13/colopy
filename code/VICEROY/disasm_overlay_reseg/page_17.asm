; ============================================================
; VICEROY.EXE overlay page 0x17 (record 22) -- RE-SEGMENTED
; file_offset (disk image) = 0x06BB00
; code_offset (first insn) = 0x06BE50
; code_end (next reloc hdr)= 0x06F850  [resident size 928 para -> nominal_end 0x06F500; on-disk code spills past it]
; reloc_count = 201  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x06BB00)
; functions in page = 57
; ============================================================

; ---- func_06BE50  size=65  insns=27  prologue=push bp;mov bp,sp  terminal=RET imm16 ----
  06BE50  0350: 55               push bp
  06BE51  0351: 8bec             mov bp, sp
  06BE53  0353: 56               push si
  06BE54  0354: 8b4604           mov ax, word ptr [bp + 4]
  06BE57  0357: 8b5606           mov dx, word ptr [bp + 6]
  06BE5A  035A: 058400           add ax, 0x84
  06BE5D  035D: 52               push dx
  06BE5E  035E: 50               push ax
  06BE5F  035F: 53               push bx
  06BE60  0360: 8bf3             mov si, bx
  06BE62  0362: 9a42081d0d       lcall 0xd1d, 0x842
  06BE67  0367: 83c402           add sp, 2
  06BE6A  036A: 40               inc ax
  06BE6B  036B: 2bd2             sub dx, dx
  06BE6D  036D: 9a2c001f18       lcall 0x181f, 0x2c
  06BE72  0372: c45e04           les bx, ptr [bp + 4]
  06BE75  0375: 2689476c         mov word ptr es:[bx + 0x6c], ax
  06BE79  0379: 2689576e         mov word ptr es:[bx + 0x6e], dx
  06BE7D  037D: 1e               push ds
  06BE7E  037E: 56               push si
  06BE7F  037F: 52               push dx
  06BE80  0380: 26ff776c         push word ptr es:[bx + 0x6c]
  06BE84  0384: 9a7e111d0d       lcall 0xd1d, 0x117e
  06BE89  0389: 83c408           add sp, 8
  06BE8C  038C: 5e               pop si
  06BE8D  038D: c9               leave 
  06BE8E  038E: c20400           ret 4

; ---- func_06BE92  size=127  insns=41  prologue=ENTER 0x0016,0  terminal=RET imm16 ----
  06BE92  0392: c8160000         enter 0x16, 0
  06BE96  0396: 833e5c1f07       cmp word ptr [0x1f5c], 7
  06BE9B  039B: 7e2d             jle 0x3ca
  06BE9D  039D: 68721f           push 0x1f72
  06BEA0  03A0: 8d46ec           lea ax, [bp - 0x14]
  06BEA3  03A3: 50               push ax
  06BEA4  03A4: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06BEA9  03A9: 83c404           add sp, 4
  06BEAC  03AC: b80100           mov ax, 1
  06BEAF  03AF: a36e1f           mov word ptr [0x1f6e], ax
  06BEB2  03B2: a3aea5           mov word ptr [0xa5ae], ax
  06BEB5  03B5: 9a06000c0c       lcall 0xc0c, 6
  06BEBA  03BA: 05f000           add ax, 0xf0
  06BEBD  03BD: 83d200           adc dx, 0
  06BEC0  03C0: a3b0a5           mov word ptr [0xa5b0], ax
  06BEC3  03C3: 8916b2a5         mov word ptr [0xa5b2], dx
  06BEC7  03C7: eb38             jmp 0x401
  06BEC9  03C9: 90               nop 
  06BECA  03CA: ff369853         push word ptr [0x5398]
  06BECE  03CE: ff365c1f         push word ptr [0x1f5c]
  06BED2  03D2: 9a0c031f18       lcall 0x181f, 0x30c
  06BED7  03D7: 83c404           add sp, 4
  06BEDA  03DA: 50               push ax
  06BEDB  03DB: 9a600a1f18       lcall 0x181f, 0xa60
  06BEE0  03E0: 83c402           add sp, 2
  06BEE3  03E3: 8946ea           mov word ptr [bp - 0x16], ax
  06BEE6  03E6: 68771f           push 0x1f77
  06BEE9  03E9: 8d46ec           lea ax, [bp - 0x14]
  06BEEC  03EC: 50               push ax
  06BEED  03ED: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06BEF2  03F2: 83c404           add sp, 4
  06BEF5  03F5: a05c1f           mov al, byte ptr [0x1f5c]
  06BEF8  03F8: 0046ef           add byte ptr [bp - 0x11], al
  06BEFB  03FB: 8a46ea           mov al, byte ptr [bp - 0x16]
  06BEFE  03FE: 0046f1           add byte ptr [bp - 0xf], al
  06BF01  0401: ff7606           push word ptr [bp + 6]
  06BF04  0404: ff7604           push word ptr [bp + 4]
  06BF07  0407: 8d5eec           lea bx, [bp - 0x14]
  06BF0A  040A: e843ff           call 0x350
  06BF0D  040D: c9               leave 
  06BF0E  040E: c20400           ret 4

; ---- func_06BF12  size=41  insns=14  prologue=ENTER 0x0014,0  terminal=RET imm16 ----
  06BF12  0412: c8140000         enter 0x14, 0
  06BF16  0416: 687e1f           push 0x1f7e
  06BF19  0419: 8d46ec           lea ax, [bp - 0x14]
  06BF1C  041C: 50               push ax
  06BF1D  041D: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06BF22  0422: 83c404           add sp, 4
  06BF25  0425: a05e1f           mov al, byte ptr [0x1f5e]
  06BF28  0428: 0046ef           add byte ptr [bp - 0x11], al
  06BF2B  042B: ff7606           push word ptr [bp + 6]
  06BF2E  042E: ff7604           push word ptr [bp + 4]
  06BF31  0431: 8d5eec           lea bx, [bp - 0x14]
  06BF34  0434: e819ff           call 0x350
  06BF37  0437: c9               leave 
  06BF38  0438: c20400           ret 4

; ---- func_06BF3C  size=41  insns=14  prologue=ENTER 0x0014,0  terminal=RET imm16 ----
  06BF3C  043C: c8140000         enter 0x14, 0
  06BF40  0440: 68831f           push 0x1f83
  06BF43  0443: 8d46ec           lea ax, [bp - 0x14]
  06BF46  0446: 50               push ax
  06BF47  0447: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06BF4C  044C: 83c404           add sp, 4
  06BF4F  044F: a0601f           mov al, byte ptr [0x1f60]
  06BF52  0452: 0046ef           add byte ptr [bp - 0x11], al
  06BF55  0455: ff7606           push word ptr [bp + 6]
  06BF58  0458: ff7604           push word ptr [bp + 4]
  06BF5B  045B: 8d5eec           lea bx, [bp - 0x14]
  06BF5E  045E: e8effe           call 0x350
  06BF61  0461: c9               leave 
  06BF62  0462: c20400           ret 4

; ---- func_06BF66  size=550  insns=170  prologue=ENTER 0x008C,0  terminal=RET imm16 ----
  06BF66  0466: c88c0000         enter 0x8c, 0
  06BF6A  046A: 57               push di
  06BF6B  046B: 56               push si
  06BF6C  046C: c45e04           les bx, ptr [bp + 4]
  06BF6F  046F: 268b476e         mov ax, word ptr es:[bx + 0x6e]
  06BF73  0473: 260b476c         or ax, word ptr es:[bx + 0x6c]
  06BF77  0477: 7503             jne 0x47c
  06BF79  0479: e90a02           jmp 0x686
  06BF7C  047C: 833e5c1f07       cmp word ptr [0x1f5c], 7
  06BF81  0481: 7e05             jle 0x488
  06BF83  0483: b80100           mov ax, 1
  06BF86  0486: eb02             jmp 0x48a
  06BF88  0488: 2bc0             sub ax, ax
  06BF8A  048A: 89867aff         mov word ptr [bp - 0x86], ax
  06BF8E  048E: 8bc3             mov ax, bx
  06BF90  0490: 8cc2             mov dx, es
  06BF92  0492: 058400           add ax, 0x84
  06BF95  0495: 52               push dx
  06BF96  0496: 50               push ax
  06BF97  0497: 8bf0             mov si, ax
  06BF99  0499: 8cc7             mov di, es
  06BF9B  049B: b81400           mov ax, 0x14
  06BF9E  049E: 99               cdq 
  06BF9F  049F: 9a2c001f18       lcall 0x181f, 0x2c
  06BFA4  04A4: c45e04           les bx, ptr [bp + 4]
  06BFA7  04A7: 26894768         mov word ptr es:[bx + 0x68], ax
  06BFAB  04AB: 2689576a         mov word ptr es:[bx + 0x6a], dx
  06BFAF  04AF: 268b4768         mov ax, word ptr es:[bx + 0x68]
  06BFB3  04B3: 89867cff         mov word ptr [bp - 0x84], ax
  06BFB7  04B7: 89967eff         mov word ptr [bp - 0x82], dx
  06BFBB  04BB: 8ec2             mov es, dx
  06BFBD  04BD: 8bd8             mov bx, ax
  06BFBF  04BF: 2bc0             sub ax, ax
  06BFC1  04C1: 26894712         mov word ptr es:[bx + 0x12], ax
  06BFC5  04C5: 26894710         mov word ptr es:[bx + 0x10], ax
  06BFC9  04C9: 39867aff         cmp word ptr [bp - 0x86], ax
  06BFCD  04CD: 741f             je 0x4ee
  06BFCF  04CF: 57               push di
  06BFD0  04D0: 56               push si
  06BFD1  04D1: b81400           mov ax, 0x14
  06BFD4  04D4: 99               cdq 
  06BFD5  04D5: 9a2c001f18       lcall 0x181f, 0x2c
  06BFDA  04DA: 898676ff         mov word ptr [bp - 0x8a], ax
  06BFDE  04DE: 899678ff         mov word ptr [bp - 0x88], dx
  06BFE2  04E2: c49e7cff         les bx, ptr [bp - 0x84]
  06BFE6  04E6: 26894710         mov word ptr es:[bx + 0x10], ax
  06BFEA  04EA: 26895712         mov word ptr es:[bx + 0x12], dx
  06BFEE  04EE: c45e04           les bx, ptr [bp + 4]
  06BFF1  04F1: 26ff776e         push word ptr es:[bx + 0x6e]
  06BFF5  04F5: 26ff776c         push word ptr es:[bx + 0x6c]
  06BFF9  04F9: 8d4680           lea ax, [bp - 0x80]
  06BFFC  04FC: 16               push ss
  06BFFD  04FD: 50               push ax
  06BFFE  04FE: 9a7e111d0d       lcall 0xd1d, 0x117e
  06C003  0503: 83c408           add sp, 8
  06C006  0506: a17203           mov ax, word ptr [0x372]
  06C009  0509: 898674ff         mov word ptr [bp - 0x8c], ax
  06C00D  050D: c70672030000     mov word ptr [0x372], 0
  06C013  0513: 6a01             push 1
  06C015  0515: 9aa40e1f18       lcall 0x181f, 0xea4
  06C01A  051A: 83c402           add sp, 2
  06C01D  051D: 6a30             push 0x30
  06C01F  051F: 6800a0           push 0xa000
  06C022  0522: 6800fc           push 0xfc00
  06C025  0525: 8d46d0           lea ax, [bp - 0x30]
  06C028  0528: 16               push ss
  06C029  0529: 50               push ax
  06C02A  052A: 9ab20f1d0d       lcall 0xd1d, 0xfb2
  06C02F  052F: 83c40a           add sp, 0xa
  06C032  0532: c706f22300fc     mov word ptr [0x23f2], 0xfc00
  06C038  0538: c706f42300a0     mov word ptr [0x23f4], 0xa000
  06C03E  053E: 8d5e80           lea bx, [bp - 0x80]
  06C041  0541: 2bc0             sub ax, ax
  06C043  0543: 9a72031f1a       lcall 0x1a1f, 0x372
  06C048  0548: c49e7cff         les bx, ptr [bp - 0x84]
  06C04C  054C: 2689470c         mov word ptr es:[bx + 0xc], ax
  06C050  0550: 2689570e         mov word ptr es:[bx + 0xe], dx
  06C054  0554: 8bc2             mov ax, dx
  06C056  0556: 260b470c         or ax, word ptr es:[bx + 0xc]
  06C05A  055A: 7521             jne 0x57d
  06C05C  055C: 9ade0f1f19       lcall 0x191f, 0xfde
  06C061  0561: c706701f0100     mov word ptr [0x1f70], 1
  06C067  0567: 8d5e80           lea bx, [bp - 0x80]
  06C06A  056A: 2bc0             sub ax, ax
  06C06C  056C: 9ad00f1f19       lcall 0x191f, 0xfd0
  06C071  0571: c49e7cff         les bx, ptr [bp - 0x84]
  06C075  0575: 2689470c         mov word ptr es:[bx + 0xc], ax
  06C079  0579: 2689570e         mov word ptr es:[bx + 0xe], dx
  06C07D  057D: 6a30             push 0x30
  06C07F  057F: 8d46d0           lea ax, [bp - 0x30]
  06C082  0582: 16               push ss
  06C083  0583: 50               push ax
  06C084  0584: 6800a0           push 0xa000
  06C087  0587: 6800fc           push 0xfc00
  06C08A  058A: 9ab20f1d0d       lcall 0xd1d, 0xfb2
  06C08F  058F: 83c40a           add sp, 0xa
  06C092  0592: 2bc0             sub ax, ax
  06C094  0594: a3f423           mov word ptr [0x23f4], ax
  06C097  0597: a3f223           mov word ptr [0x23f2], ax
  06C09A  059A: c49e7cff         les bx, ptr [bp - 0x84]
  06C09E  059E: 268b470e         mov ax, word ptr es:[bx + 0xe]
  06C0A2  05A2: 260b470c         or ax, word ptr es:[bx + 0xc]
  06C0A6  05A6: 7510             jne 0x5b8
  06C0A8  05A8: c45e04           les bx, ptr [bp + 4]
  06C0AB  05AB: 2bc0             sub ax, ax
  06C0AD  05AD: 2689476a         mov word ptr es:[bx + 0x6a], ax
  06C0B1  05B1: 26894768         mov word ptr es:[bx + 0x68], ax
  06C0B5  05B5: e9bf00           jmp 0x677
  06C0B8  05B8: 83be7aff00       cmp word ptr [bp - 0x86], 0
  06C0BD  05BD: 7469             je 0x628
  06C0BF  05BF: 68881f           push 0x1f88
  06C0C2  05C2: 8d4680           lea ax, [bp - 0x80]
  06C0C5  05C5: 50               push ax
  06C0C6  05C6: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06C0CB  05CB: 83c404           add sp, 4
  06C0CE  05CE: 833e701f00       cmp word ptr [0x1f70], 0
  06C0D3  05D3: 7516             jne 0x5eb
  06C0D5  05D5: 8d5e80           lea bx, [bp - 0x80]
  06C0D8  05D8: 2bc0             sub ax, ax
  06C0DA  05DA: 9a72031f1a       lcall 0x1a1f, 0x372
  06C0DF  05DF: c49e76ff         les bx, ptr [bp - 0x8a]
  06C0E3  05E3: 2689470c         mov word ptr es:[bx + 0xc], ax
  06C0E7  05E7: 2689570e         mov word ptr es:[bx + 0xe], dx
  06C0EB  05EB: c49e76ff         les bx, ptr [bp - 0x8a]
  06C0EF  05EF: 268b470e         mov ax, word ptr es:[bx + 0xe]
  06C0F3  05F3: 260b470c         or ax, word ptr es:[bx + 0xc]
  06C0F7  05F7: 7512             jne 0x60b
  06C0F9  05F9: 833e701f00       cmp word ptr [0x1f70], 0
  06C0FE  05FE: 750b             jne 0x60b
  06C100  0600: c706701f0200     mov word ptr [0x1f70], 2
  06C106  0606: 9ade0f1f19       lcall 0x191f, 0xfde
  06C10B  060B: 833e701f00       cmp word ptr [0x1f70], 0
  06C110  0610: 7416             je 0x628
  06C112  0612: 8d5e80           lea bx, [bp - 0x80]
  06C115  0615: 2bc0             sub ax, ax
  06C117  0617: 9ad00f1f19       lcall 0x191f, 0xfd0
  06C11C  061C: c49e76ff         les bx, ptr [bp - 0x8a]
  06C120  0620: 2689470c         mov word ptr es:[bx + 0xc], ax
  06C124  0624: 2689570e         mov word ptr es:[bx + 0xe], dx
  06C128  0628: 6a00             push 0
  06C12A  062A: 9aa40e1f18       lcall 0x181f, 0xea4
  06C12F  062F: 83c402           add sp, 2
  06C132  0632: 83be7aff00       cmp word ptr [bp - 0x86], 0
  06C137  0637: 7433             je 0x66c
  06C139  0639: c49e76ff         les bx, ptr [bp - 0x8a]
  06C13D  063D: 268b470e         mov ax, word ptr es:[bx + 0xe]
  06C141  0641: 260b470c         or ax, word ptr es:[bx + 0xc]
  06C145  0645: 7525             jne 0x66c
  06C147  0647: 833e701f01       cmp word ptr [0x1f70], 1
  06C14C  064C: 7411             je 0x65f
  06C14E  064E: c49e7cff         les bx, ptr [bp - 0x84]
  06C152  0652: 26ff770e         push word ptr es:[bx + 0xe]
  06C156  0656: 26ff770c         push word ptr es:[bx + 0xc]
  06C15A  065A: 9aa8011f19       lcall 0x191f, 0x1a8
  06C15F  065F: c45e04           les bx, ptr [bp + 4]
  06C162  0662: 2bc0             sub ax, ax
  06C164  0664: 2689476a         mov word ptr es:[bx + 0x6a], ax
  06C168  0668: 26894768         mov word ptr es:[bx + 0x68], ax
  06C16C  066C: 6800a0           push 0xa000
  06C16F  066F: 6800fc           push 0xfc00
  06C172  0672: 9af4031f18       lcall 0x181f, 0x3f4
  06C177  0677: 2bc0             sub ax, ax
  06C179  0679: a3f423           mov word ptr [0x23f4], ax
  06C17C  067C: a3f223           mov word ptr [0x23f2], ax
  06C17F  067F: 8b8674ff         mov ax, word ptr [bp - 0x8c]
  06C183  0683: a37203           mov word ptr [0x372], ax
  06C186  0686: 5e               pop si
  06C187  0687: 5f               pop di
  06C188  0688: c9               leave 
  06C189  0689: c20400           ret 4

; ---- func_06C18C  size=147  insns=52  prologue=push bp;mov bp,sp  terminal=RET imm16 ----
  06C18C  068C: 55               push bp
  06C18D  068D: 8bec             mov bp, sp
  06C18F  068F: 50               push ax
  06C190  0690: 833e6c1f00       cmp word ptr [0x1f6c], 0
  06C195  0695: 7469             je 0x700
  06C197  0697: 807e0a07         cmp byte ptr [bp + 0xa], 7
  06C19B  069B: 7563             jne 0x700
  06C19D  069D: 833e8a1f00       cmp word ptr [0x1f8a], 0
  06C1A2  06A2: 7428             je 0x6cc
  06C1A4  06A4: ff36a483         push word ptr [0x83a4]
  06C1A8  06A8: ff36a283         push word ptr [0x83a2]
  06C1AC  06AC: ff36a083         push word ptr [0x83a0]
  06C1B0  06B0: ff369e83         push word ptr [0x839e]
  06C1B4  06B4: ff761a           push word ptr [bp + 0x1a]
  06C1B7  06B7: ff7618           push word ptr [bp + 0x18]
  06C1BA  06BA: ff7616           push word ptr [bp + 0x16]
  06C1BD  06BD: ff7614           push word ptr [bp + 0x14]
  06C1C0  06C0: ff7612           push word ptr [bp + 0x12]
  06C1C3  06C3: 9a44041f18       lcall 0x181f, 0x444
  06C1C8  06C8: c9               leave 
  06C1C9  06C9: c21800           ret 0x18
  06C1CC  06CC: ff760e           push word ptr [bp + 0xe]
  06C1CF  06CF: ff7610           push word ptr [bp + 0x10]
  06C1D2  06D2: ff7612           push word ptr [bp + 0x12]
  06C1D5  06D5: 53               push bx
  06C1D6  06D6: 52               push dx
  06C1D7  06D7: 50               push ax
  06C1D8  06D8: 8b1e6c1f         mov bx, word ptr [0x1f6c]
  06C1DC  06DC: ff7706           push word ptr [bx + 6]
  06C1DF  06DF: ff7704           push word ptr [bx + 4]
  06C1E2  06E2: ff7702           push word ptr [bx + 2]
  06C1E5  06E5: ff37             push word ptr [bx]
  06C1E7  06E7: ff761a           push word ptr [bp + 0x1a]
  06C1EA  06EA: ff7618           push word ptr [bp + 0x18]
  06C1ED  06ED: ff7616           push word ptr [bp + 0x16]
  06C1F0  06F0: ff7614           push word ptr [bp + 0x14]
  06C1F3  06F3: 9ac4001f18       lcall 0x181f, 0xc4
  06C1F8  06F8: 83c41c           add sp, 0x1c
  06C1FB  06FB: c9               leave 
  06C1FC  06FC: c21800           ret 0x18
  06C1FF  06FF: 90               nop 
  06C200  0700: ff761a           push word ptr [bp + 0x1a]
  06C203  0703: ff7618           push word ptr [bp + 0x18]
  06C206  0706: ff7616           push word ptr [bp + 0x16]
  06C209  0709: ff7614           push word ptr [bp + 0x14]
  06C20C  070C: ff7612           push word ptr [bp + 0x12]
  06C20F  070F: 8a460a           mov al, byte ptr [bp + 0xa]
  06C212  0712: 50               push ax
  06C213  0713: 8b46fe           mov ax, word ptr [bp - 2]
  06C216  0716: 9aba001f18       lcall 0x181f, 0xba
  06C21B  071B: c9               leave 
  06C21C  071C: c21800           ret 0x18

; ---- func_06C220  size=27  insns=12  prologue=push bp;mov bp,sp  terminal=RETF ----
  06C220  0720: 55               push bp
  06C221  0721: 8bec             mov bp, sp
  06C223  0723: ff760a           push word ptr [bp + 0xa]
  06C226  0726: ff7608           push word ptr [bp + 8]
  06C229  0729: 8b4606           mov ax, word ptr [bp + 6]
  06C22C  072C: c1e006           shl ax, 6
  06C22F  072F: 05d29c           add ax, 0x9cd2
  06C232  0732: 1e               push ds
  06C233  0733: 50               push ax
  06C234  0734: 9a7e111d0d       lcall 0xd1d, 0x117e
  06C239  0739: c9               leave 
  06C23A  073A: cb               retf 

; ---- func_06C23C  size=24  insns=12  prologue=push bp;mov bp,sp  terminal=RETF ----
  06C23C  073C: 55               push bp
  06C23D  073D: 8bec             mov bp, sp
  06C23F  073F: ff7608           push word ptr [bp + 8]
  06C242  0742: 9a22001f18       lcall 0x181f, 0x22
  06C247  0747: 8be5             mov sp, bp
  06C249  0749: 52               push dx
  06C24A  074A: 50               push ax
  06C24B  074B: ff7606           push word ptr [bp + 6]
  06C24E  074E: 0e               push cs
  06C24F  074F: e89835           call 0x3cea
  06C252  0752: c9               leave 
  06C253  0753: cb               retf 

; ---- func_06C254  size=40  insns=16  prologue=ENTER 0x0050,0  terminal=RETF ----
  06C254  0754: c8500000         enter 0x50, 0
  06C258  0758: c646b000         mov byte ptr [bp - 0x50], 0
  06C25C  075C: 8d46b0           lea ax, [bp - 0x50]
  06C25F  075F: 50               push ax
  06C260  0760: ff7608           push word ptr [bp + 8]
  06C263  0763: ff760a           push word ptr [bp + 0xa]
  06C266  0766: 9a2e041f18       lcall 0x181f, 0x42e
  06C26B  076B: 83c406           add sp, 6
  06C26E  076E: 8d46b0           lea ax, [bp - 0x50]
  06C271  0771: 16               push ss
  06C272  0772: 50               push ax
  06C273  0773: ff7606           push word ptr [bp + 6]
  06C276  0776: 0e               push cs
  06C277  0777: e87035           call 0x3cea
  06C27A  077A: c9               leave 
  06C27B  077B: cb               retf 

; ---- func_06C27C  size=25  insns=10  prologue=push bp;mov bp,sp  terminal=RETF ----
  06C27C  077C: 55               push bp
  06C27D  077D: 8bec             mov bp, sp
  06C27F  077F: 8b4608           mov ax, word ptr [bp + 8]
  06C282  0782: 8b560a           mov dx, word ptr [bp + 0xa]
  06C285  0785: 8b5e06           mov bx, word ptr [bp + 6]
  06C288  0788: c1e302           shl bx, 2
  06C28B  078B: 8987b09c         mov word ptr [bx - 0x6350], ax
  06C28F  078F: 8997b29c         mov word ptr [bx - 0x634e], dx
  06C293  0793: c9               leave 
  06C294  0794: cb               retf 

; ---- func_06C296  size=63  insns=21  prologue=push bp;mov bp,sp  terminal=RETF ----
  06C296  0796: 55               push bp
  06C297  0797: 8bec             mov bp, sp
  06C299  0799: 8b460e           mov ax, word ptr [bp + 0xe]
  06C29C  079C: c45e06           les bx, ptr [bp + 6]
  06C29F  079F: 268907           mov word ptr es:[bx], ax
  06C2A2  07A2: 8b4610           mov ax, word ptr [bp + 0x10]
  06C2A5  07A5: 26894702         mov word ptr es:[bx + 2], ax
  06C2A9  07A9: 8b4612           mov ax, word ptr [bp + 0x12]
  06C2AC  07AC: 26894704         mov word ptr es:[bx + 4], ax
  06C2B0  07B0: 8b4614           mov ax, word ptr [bp + 0x14]
  06C2B3  07B3: 26894706         mov word ptr es:[bx + 6], ax
  06C2B7  07B7: 8b4616           mov ax, word ptr [bp + 0x16]
  06C2BA  07BA: 26894708         mov word ptr es:[bx + 8], ax
  06C2BE  07BE: 8b4618           mov ax, word ptr [bp + 0x18]
  06C2C1  07C1: 2689470a         mov word ptr es:[bx + 0xa], ax
  06C2C5  07C5: 8b460a           mov ax, word ptr [bp + 0xa]
  06C2C8  07C8: 8b560c           mov dx, word ptr [bp + 0xc]
  06C2CB  07CB: 2689470c         mov word ptr es:[bx + 0xc], ax
  06C2CF  07CF: 2689570e         mov word ptr es:[bx + 0xe], dx
  06C2D3  07D3: c9               leave 
  06C2D4  07D4: cb               retf 

; ---- func_06C2D6  size=112  insns=42  prologue=ENTER 0x0054,0  terminal=RET imm16 ----
  06C2D6  07D6: c8540000         enter 0x54, 0
  06C2DA  07DA: ff7606           push word ptr [bp + 6]
  06C2DD  07DD: ff7604           push word ptr [bp + 4]
  06C2E0  07E0: 8d46b0           lea ax, [bp - 0x50]
  06C2E3  07E3: 16               push ss
  06C2E4  07E4: 50               push ax
  06C2E5  07E5: 9a7e111d0d       lcall 0xd1d, 0x117e
  06C2EA  07EA: 83c408           add sp, 8
  06C2ED  07ED: 8d46b0           lea ax, [bp - 0x50]
  06C2F0  07F0: 8946ae           mov word ptr [bp - 0x52], ax
  06C2F3  07F3: eb2a             jmp 0x81f
  06C2F5  07F5: 90               nop 
  06C2F6  07F6: 8a07             mov al, byte ptr [bx]
  06C2F8  07F8: 2ae4             sub ah, ah
  06C2FA  07FA: 50               push ax
  06C2FB  07FB: 688c1f           push 0x1f8c
  06C2FE  07FE: 9a560c1d0d       lcall 0xd1d, 0xc56
  06C303  0803: 83c404           add sp, 4
  06C306  0806: 0bc0             or ax, ax
  06C308  0808: 7412             je 0x81c
  06C30A  080A: 8b46ae           mov ax, word ptr [bp - 0x52]
  06C30D  080D: 40               inc ax
  06C30E  080E: 50               push ax
  06C30F  080F: ff76ae           push word ptr [bp - 0x52]
  06C312  0812: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06C317  0817: 83c404           add sp, 4
  06C31A  081A: eb03             jmp 0x81f
  06C31C  081C: ff46ae           inc word ptr [bp - 0x52]
  06C31F  081F: 8b5eae           mov bx, word ptr [bp - 0x52]
  06C322  0822: 803f00           cmp byte ptr [bx], 0
  06C325  0825: 75cf             jne 0x7f6
  06C327  0827: c45e08           les bx, ptr [bp + 8]
  06C32A  082A: 26ff770e         push word ptr es:[bx + 0xe]
  06C32E  082E: 26ff770c         push word ptr es:[bx + 0xc]
  06C332  0832: 8d46b0           lea ax, [bp - 0x50]
  06C335  0835: 16               push ss
  06C336  0836: 50               push ax
  06C337  0837: 268b07           mov ax, word ptr es:[bx]
  06C33A  083A: 9a04021f18       lcall 0x181f, 0x204
  06C33F  083F: 8946ac           mov word ptr [bp - 0x54], ax
  06C342  0842: c9               leave 
  06C343  0843: c20800           ret 8

; ---- func_06C346  size=65  insns=23  prologue=push bp;mov bp,sp  terminal=RET imm16 ----
  06C346  0846: 55               push bp
  06C347  0847: 8bec             mov bp, sp
  06C349  0849: 0bc0             or ax, ax
  06C34B  084B: 740d             je 0x85a
  06C34D  084D: c45e04           les bx, ptr [bp + 4]
  06C350  0850: 26ff770a         push word ptr es:[bx + 0xa]
  06C354  0854: 268b5704         mov dx, word ptr es:[bx + 4]
  06C358  0858: eb1d             jmp 0x877
  06C35A  085A: 0bd2             or dx, dx
  06C35C  085C: 740e             je 0x86c
  06C35E  085E: c45e04           les bx, ptr [bp + 4]
  06C361  0861: 26ff770a         push word ptr es:[bx + 0xa]
  06C365  0865: 268b5706         mov dx, word ptr es:[bx + 6]
  06C369  0869: eb0c             jmp 0x877
  06C36B  086B: 90               nop 
  06C36C  086C: c45e04           les bx, ptr [bp + 4]
  06C36F  086F: 26ff770a         push word ptr es:[bx + 0xa]
  06C373  0873: 268b5702         mov dx, word ptr es:[bx + 2]
  06C377  0877: 268b5f08         mov bx, word ptr es:[bx + 8]
  06C37B  087B: b8ffff           mov ax, 0xffff
  06C37E  087E: 9af0011f18       lcall 0x181f, 0x1f0
  06C383  0883: c9               leave 
  06C384  0884: c20400           ret 4

; ---- func_06C388  size=265  insns=97  prologue=ENTER 0x0008,0  terminal=RET imm16 ----
  06C388  0888: c8080000         enter 8, 0
  06C38C  088C: 53               push bx
  06C38D  088D: 52               push dx
  06C38E  088E: 50               push ax
  06C38F  088F: c646ff00         mov byte ptr [bp - 1], 0
  06C393  0893: ff760a           push word ptr [bp + 0xa]
  06C396  0896: ff7608           push word ptr [bp + 8]
  06C399  0899: 8bc3             mov ax, bx
  06C39B  089B: 250100           and ax, 1
  06C39E  089E: 8946fc           mov word ptr [bp - 4], ax
  06C3A1  08A1: 8b16621f         mov dx, word ptr [0x1f62]
  06C3A5  08A5: e89eff           call 0x846
  06C3A8  08A8: 8b4604           mov ax, word ptr [bp + 4]
  06C3AB  08AB: 8b5606           mov dx, word ptr [bp + 6]
  06C3AE  08AE: 8946f8           mov word ptr [bp - 8], ax
  06C3B1  08B1: 8956fa           mov word ptr [bp - 6], dx
  06C3B4  08B4: c45ef8           les bx, ptr [bp - 8]
  06C3B7  08B7: 26803f00         cmp byte ptr es:[bx], 0
  06C3BB  08BB: 7503             jne 0x8c0
  06C3BD  08BD: e9ca00           jmp 0x98a
  06C3C0  08C0: 268a07           mov al, byte ptr es:[bx]
  06C3C3  08C3: 98               cwde 
  06C3C4  08C4: 2d7b00           sub ax, 0x7b
  06C3C7  08C7: 7503             jne 0x8cc
  06C3C9  08C9: e9a000           jmp 0x96c
  06C3CC  08CC: 48               dec ax
  06C3CD  08CD: 7503             jne 0x8d2
  06C3CF  08CF: e9b800           jmp 0x98a
  06C3D2  08D2: 48               dec ax
  06C3D3  08D3: 7503             jne 0x8d8
  06C3D5  08D5: e9a000           jmp 0x978
  06C3D8  08D8: 48               dec ax
  06C3D9  08D9: 7433             je 0x90e
  06C3DB  08DB: 268a07           mov al, byte ptr es:[bx]
  06C3DE  08DE: 8846fe           mov byte ptr [bp - 2], al
  06C3E1  08E1: c45e08           les bx, ptr [bp + 8]
  06C3E4  08E4: 26ff770e         push word ptr es:[bx + 0xe]
  06C3E8  08E8: 26ff770c         push word ptr es:[bx + 0xc]
  06C3EC  08EC: 8d46fe           lea ax, [bp - 2]
  06C3EF  08EF: 16               push ss
  06C3F0  08F0: 50               push ax
  06C3F1  08F1: 26ff37           push word ptr es:[bx]
  06C3F4  08F4: 8d1ea82d         lea bx, [0x2da8]
  06C3F8  08F8: 8b46f2           mov ax, word ptr [bp - 0xe]
  06C3FB  08FB: 8b56f4           mov dx, word ptr [bp - 0xc]
  06C3FE  08FE: 9afa011f18       lcall 0x181f, 0x1fa
  06C403  0903: c45e08           les bx, ptr [bp + 8]
  06C406  0906: 260307           add ax, word ptr es:[bx]
  06C409  0909: 8946f2           mov word ptr [bp - 0xe], ax
  06C40C  090C: eb58             jmp 0x966
  06C40E  090E: ff760a           push word ptr [bp + 0xa]
  06C411  0911: ff7608           push word ptr [bp + 8]
  06C414  0914: 833e621f01       cmp word ptr [0x1f62], 1
  06C419  0919: 1bd2             sbb dx, dx
  06C41B  091B: f7da             neg dx
  06C41D  091D: 8b46fc           mov ax, word ptr [bp - 4]
  06C420  0920: e823ff           call 0x846
  06C423  0923: ff46f8           inc word ptr [bp - 8]
  06C426  0926: c45ef8           les bx, ptr [bp - 8]
  06C429  0929: 268a07           mov al, byte ptr es:[bx]
  06C42C  092C: 8846fe           mov byte ptr [bp - 2], al
  06C42F  092F: c45e08           les bx, ptr [bp + 8]
  06C432  0932: 26ff770e         push word ptr es:[bx + 0xe]
  06C436  0936: 26ff770c         push word ptr es:[bx + 0xc]
  06C43A  093A: 8d46fe           lea ax, [bp - 2]
  06C43D  093D: 16               push ss
  06C43E  093E: 50               push ax
  06C43F  093F: 26ff37           push word ptr es:[bx]
  06C442  0942: 8d1ea82d         lea bx, [0x2da8]
  06C446  0946: 8b46f2           mov ax, word ptr [bp - 0xe]
  06C449  0949: 8b56f4           mov dx, word ptr [bp - 0xc]
  06C44C  094C: 9afa011f18       lcall 0x181f, 0x1fa
  06C451  0951: c45e08           les bx, ptr [bp + 8]
  06C454  0954: 260307           add ax, word ptr es:[bx]
  06C457  0957: 8946f2           mov word ptr [bp - 0xe], ax
  06C45A  095A: 06               push es
  06C45B  095B: 53               push bx
  06C45C  095C: 8b46fc           mov ax, word ptr [bp - 4]
  06C45F  095F: 8b16621f         mov dx, word ptr [0x1f62]
  06C463  0963: e8e0fe           call 0x846
  06C466  0966: ff46f8           inc word ptr [bp - 8]
  06C469  0969: e948ff           jmp 0x8b4
  06C46C  096C: ff760a           push word ptr [bp + 0xa]
  06C46F  096F: ff7608           push word ptr [bp + 8]
  06C472  0972: ba0100           mov dx, 1
  06C475  0975: eb09             jmp 0x980
  06C477  0977: 90               nop 
  06C478  0978: ff760a           push word ptr [bp + 0xa]
  06C47B  097B: ff7608           push word ptr [bp + 8]
  06C47E  097E: 2bd2             sub dx, dx
  06C480  0980: 8916621f         mov word ptr [0x1f62], dx
  06C484  0984: 8b46fc           mov ax, word ptr [bp - 4]
  06C487  0987: ebda             jmp 0x963
  06C489  0989: 90               nop 
  06C48A  098A: 8b46f2           mov ax, word ptr [bp - 0xe]
  06C48D  098D: c9               leave 
  06C48E  098E: c20800           ret 8

; ---- func_06C492  size=141  insns=48  prologue=ENTER 0x000C,0  terminal=RET imm16 ----
  06C492  0992: c80c0000         enter 0xc, 0
  06C496  0996: c746fe0000       mov word ptr [bp - 2], 0
  06C49B  099B: 6a7e             push 0x7e
  06C49D  099D: ff7606           push word ptr [bp + 6]
  06C4A0  09A0: ff7604           push word ptr [bp + 4]
  06C4A3  09A3: 9aea101d0d       lcall 0xd1d, 0x10ea
  06C4A8  09A8: 83c406           add sp, 6
  06C4AB  09AB: 8946fa           mov word ptr [bp - 6], ax
  06C4AE  09AE: 8956fc           mov word ptr [bp - 4], dx
  06C4B1  09B1: 6a7e             push 0x7e
  06C4B3  09B3: ff7606           push word ptr [bp + 6]
  06C4B6  09B6: ff7604           push word ptr [bp + 4]
  06C4B9  09B9: 9a10101d0d       lcall 0xd1d, 0x1010
  06C4BE  09BE: 83c406           add sp, 6
  06C4C1  09C1: 3b46fa           cmp ax, word ptr [bp - 6]
  06C4C4  09C4: 7505             jne 0x9cb
  06C4C6  09C6: 3b56fc           cmp dx, word ptr [bp - 4]
  06C4C9  09C9: 7421             je 0x9ec
  06C4CB  09CB: 8ec2             mov es, dx
  06C4CD  09CD: 8bd8             mov bx, ax
  06C4CF  09CF: 26807f0146       cmp byte ptr es:[bx + 1], 0x46
  06C4D4  09D4: 7516             jne 0x9ec
  06C4D6  09D6: c45efa           les bx, ptr [bp - 6]
  06C4D9  09D9: 268a5f01         mov bl, byte ptr es:[bx + 1]
  06C4DD  09DD: 2aff             sub bh, bh
  06C4DF  09DF: f687ed2704       test byte ptr [bx + 0x27ed], 4
  06C4E4  09E4: 7406             je 0x9ec
  06C4E6  09E6: 8d870a01         lea ax, [bx + 0x10a]
  06C4EA  09EA: eb29             jmp 0xa15
  06C4EC  09EC: 8b46fc           mov ax, word ptr [bp - 4]
  06C4EF  09EF: 0b46fa           or ax, word ptr [bp - 6]
  06C4F2  09F2: 7424             je 0xa18
  06C4F4  09F4: c45efa           les bx, ptr [bp - 6]
  06C4F7  09F7: 268a5f01         mov bl, byte ptr es:[bx + 1]
  06C4FB  09FB: 2aff             sub bh, bh
  06C4FD  09FD: f687ed2702       test byte ptr [bx + 0x27ed], 2
  06C502  0A02: 7408             je 0xa0c
  06C504  0A04: 8bc3             mov ax, bx
  06C506  0A06: 2d2000           sub ax, 0x20
  06C509  0A09: eb0a             jmp 0xa15
  06C50B  0A0B: 90               nop 
  06C50C  0A0C: 8b5efa           mov bx, word ptr [bp - 6]
  06C50F  0A0F: 268a4701         mov al, byte ptr es:[bx + 1]
  06C513  0A13: 2ae4             sub ah, ah
  06C515  0A15: 8946fe           mov word ptr [bp - 2], ax
  06C518  0A18: 8b46fe           mov ax, word ptr [bp - 2]
  06C51B  0A1B: c9               leave 
  06C51C  0A1C: c20400           ret 4

; ---- func_06C520  size=458  insns=143  prologue=ENTER 0x0014,0  terminal=RETF ----
  06C520  0A20: c8140000         enter 0x14, 0
  06C524  0A24: 2bc0             sub ax, ax
  06C526  0A26: 8946ee           mov word ptr [bp - 0x12], ax
  06C529  0A29: 8946ec           mov word ptr [bp - 0x14], ax
  06C52C  0A2C: a36e1f           mov word ptr [0x1f6e], ax
  06C52F  0A2F: a3701f           mov word ptr [0x1f70], ax
  06C532  0A32: 8b4606           mov ax, word ptr [bp + 6]
  06C535  0A35: 059600           add ax, 0x96
  06C538  0A38: 2bd2             sub dx, dx
  06C53A  0A3A: 9a9a021f18       lcall 0x181f, 0x29a
  06C53F  0A3F: 8946f0           mov word ptr [bp - 0x10], ax
  06C542  0A42: 8956f2           mov word ptr [bp - 0xe], dx
  06C545  0A45: 0bd0             or dx, ax
  06C547  0A47: 7503             jne 0xa4c
  06C549  0A49: e97301           jmp 0xbbf
  06C54C  0A4C: 8b56f2           mov dx, word ptr [bp - 0xe]
  06C54F  0A4F: 8946f8           mov word ptr [bp - 8], ax
  06C552  0A52: 8956fa           mov word ptr [bp - 6], dx
  06C555  0A55: 059600           add ax, 0x96
  06C558  0A58: 8b4ef8           mov cx, word ptr [bp - 8]
  06C55B  0A5B: 8bda             mov bx, dx
  06C55D  0A5D: 81c18400         add cx, 0x84
  06C561  0A61: 53               push bx
  06C562  0A62: 51               push cx
  06C563  0A63: 52               push dx
  06C564  0A64: 50               push ax
  06C565  0A65: 8b4606           mov ax, word ptr [bp + 6]
  06C568  0A68: 99               cdq 
  06C569  0A69: 52               push dx
  06C56A  0A6A: 50               push ax
  06C56B  0A6B: b82900           mov ax, 0x29
  06C56E  0A6E: 9a56031f1a       lcall 0x1a1f, 0x356
  06C573  0A73: c45ef8           les bx, ptr [bp - 8]
  06C576  0A76: 2bc0             sub ax, ax
  06C578  0A78: 2689474e         mov word ptr es:[bx + 0x4e], ax
  06C57C  0A7C: 2689474c         mov word ptr es:[bx + 0x4c], ax
  06C580  0A80: 26894752         mov word ptr es:[bx + 0x52], ax
  06C584  0A84: 26894750         mov word ptr es:[bx + 0x50], ax
  06C588  0A88: a1561f           mov ax, word ptr [0x1f56]
  06C58B  0A8B: 2689470a         mov word ptr es:[bx + 0xa], ax
  06C58F  0A8F: a1581f           mov ax, word ptr [0x1f58]
  06C592  0A92: 2689470c         mov word ptr es:[bx + 0xc], ax
  06C596  0A96: a15a1f           mov ax, word ptr [0x1f5a]
  06C599  0A99: 2689470e         mov word ptr es:[bx + 0xe], ax
  06C59D  0A9D: b8ffff           mov ax, 0xffff
  06C5A0  0AA0: a3581f           mov word ptr [0x1f58], ax
  06C5A3  0AA3: a35a1f           mov word ptr [0x1f5a], ax
  06C5A6  0AA6: 26c747285000     mov word ptr es:[bx + 0x28], 0x50
  06C5AC  0AAC: b80400           mov ax, 4
  06C5AF  0AAF: 26894722         mov word ptr es:[bx + 0x22], ax
  06C5B3  0AB3: 26894732         mov word ptr es:[bx + 0x32], ax
  06C5B7  0AB7: a13c1f           mov ax, word ptr [0x1f3c]
  06C5BA  0ABA: 2689473c         mov word ptr es:[bx + 0x3c], ax
  06C5BE  0ABE: a13e1f           mov ax, word ptr [0x1f3e]
  06C5C1  0AC1: 2689473e         mov word ptr es:[bx + 0x3e], ax
  06C5C5  0AC5: a1401f           mov ax, word ptr [0x1f40]
  06C5C8  0AC8: 26894740         mov word ptr es:[bx + 0x40], ax
  06C5CC  0ACC: a1421f           mov ax, word ptr [0x1f42]
  06C5CF  0ACF: 26894742         mov word ptr es:[bx + 0x42], ax
  06C5D3  0AD3: a1441f           mov ax, word ptr [0x1f44]
  06C5D6  0AD6: 26894744         mov word ptr es:[bx + 0x44], ax
  06C5DA  0ADA: 268a470a         mov al, byte ptr es:[bx + 0xa]
  06C5DE  0ADE: 251000           and ax, 0x10
  06C5E1  0AE1: 3d0100           cmp ax, 1
  06C5E4  0AE4: 1bc9             sbb cx, cx
  06C5E6  0AE6: 83e103           and cx, 3
  06C5E9  0AE9: 26894f46         mov word ptr es:[bx + 0x46], cx
  06C5ED  0AED: 3d0100           cmp ax, 1
  06C5F0  0AF0: 1bc0             sbb ax, ax
  06C5F2  0AF2: 250200           and ax, 2
  06C5F5  0AF5: 26894748         mov word ptr es:[bx + 0x48], ax
  06C5F9  0AF9: 2bc0             sub ax, ax
  06C5FB  0AFB: 26894756         mov word ptr es:[bx + 0x56], ax
  06C5FF  0AFF: 26894754         mov word ptr es:[bx + 0x54], ax
  06C603  0B03: 2689475a         mov word ptr es:[bx + 0x5a], ax
  06C607  0B07: 26894758         mov word ptr es:[bx + 0x58], ax
  06C60B  0B0B: 2689475e         mov word ptr es:[bx + 0x5e], ax
  06C60F  0B0F: 2689475c         mov word ptr es:[bx + 0x5c], ax
  06C613  0B13: 26894762         mov word ptr es:[bx + 0x62], ax
  06C617  0B17: 26894760         mov word ptr es:[bx + 0x60], ax
  06C61B  0B1B: 26894772         mov word ptr es:[bx + 0x72], ax
  06C61F  0B1F: 26894770         mov word ptr es:[bx + 0x70], ax
  06C623  0B23: 26894766         mov word ptr es:[bx + 0x66], ax
  06C627  0B27: 26894764         mov word ptr es:[bx + 0x64], ax
  06C62B  0B2B: 2689476a         mov word ptr es:[bx + 0x6a], ax
  06C62F  0B2F: 26894768         mov word ptr es:[bx + 0x68], ax
  06C633  0B33: 2689476e         mov word ptr es:[bx + 0x6e], ax
  06C637  0B37: 2689476c         mov word ptr es:[bx + 0x6c], ax
  06C63B  0B3B: ff36521f         push word ptr [0x1f52]
  06C63F  0B3F: ff36501f         push word ptr [0x1f50]
  06C643  0B43: ff364e1f         push word ptr [0x1f4e]
  06C647  0B47: ff364c1f         push word ptr [0x1f4c]
  06C64B  0B4B: ff364a1f         push word ptr [0x1f4a]
  06C64F  0B4F: 268907           mov word ptr es:[bx], ax
  06C652  0B52: 26894702         mov word ptr es:[bx + 2], ax
  06C656  0B56: 26894704         mov word ptr es:[bx + 4], ax
  06C65A  0B5A: 26894706         mov word ptr es:[bx + 6], ax
  06C65E  0B5E: 26894708         mov word ptr es:[bx + 8], ax
  06C662  0B62: a3561f           mov word ptr [0x1f56], ax
  06C665  0B65: 26894720         mov word ptr es:[bx + 0x20], ax
  06C669  0B69: 26894724         mov word ptr es:[bx + 0x24], ax
  06C66D  0B6D: 26894726         mov word ptr es:[bx + 0x26], ax
  06C671  0B71: 2689472a         mov word ptr es:[bx + 0x2a], ax
  06C675  0B75: 2689472c         mov word ptr es:[bx + 0x2c], ax
  06C679  0B79: 2689472e         mov word ptr es:[bx + 0x2e], ax
  06C67D  0B7D: 26894730         mov word ptr es:[bx + 0x30], ax
  06C681  0B81: 26894734         mov word ptr es:[bx + 0x34], ax
  06C685  0B85: 26894736         mov word ptr es:[bx + 0x36], ax
  06C689  0B89: 26894738         mov word ptr es:[bx + 0x38], ax
  06C68D  0B8D: 2689474a         mov word ptr es:[bx + 0x4a], ax
  06C691  0B91: 50               push ax
  06C692  0B92: ff760a           push word ptr [bp + 0xa]
  06C695  0B95: ff7608           push word ptr [bp + 8]
  06C698  0B98: 8d4774           lea ax, [bx + 0x74]
  06C69B  0B9B: 06               push es
  06C69C  0B9C: 50               push ax
  06C69D  0B9D: 0e               push cs
  06C69E  0B9E: e89e31           call 0x3d3f
  06C6A1  0BA1: 83c414           add sp, 0x14
  06C6A4  0BA4: 833eac8300       cmp word ptr [0x83ac], 0
  06C6A9  0BA9: 7508             jne 0xbb3
  06C6AB  0BAB: c45ef8           les bx, ptr [bp - 8]
  06C6AE  0BAE: 26804f0a80       or byte ptr es:[bx + 0xa], 0x80
  06C6B3  0BB3: 8b46f8           mov ax, word ptr [bp - 8]
  06C6B6  0BB6: 8b56fa           mov dx, word ptr [bp - 6]
  06C6B9  0BB9: 8946ec           mov word ptr [bp - 0x14], ax
  06C6BC  0BBC: 8956ee           mov word ptr [bp - 0x12], dx
  06C6BF  0BBF: 8b46f2           mov ax, word ptr [bp - 0xe]
  06C6C2  0BC2: 0b46f0           or ax, word ptr [bp - 0x10]
  06C6C5  0BC5: 741b             je 0xbe2
  06C6C7  0BC7: 8b46ec           mov ax, word ptr [bp - 0x14]
  06C6CA  0BCA: 8b56ee           mov dx, word ptr [bp - 0x12]
  06C6CD  0BCD: 3946f0           cmp word ptr [bp - 0x10], ax
  06C6D0  0BD0: 7505             jne 0xbd7
  06C6D2  0BD2: 3956f2           cmp word ptr [bp - 0xe], dx
  06C6D5  0BD5: 740b             je 0xbe2
  06C6D7  0BD7: ff76f2           push word ptr [bp - 0xe]
  06C6DA  0BDA: ff76f0           push word ptr [bp - 0x10]
  06C6DD  0BDD: 9aa8011f19       lcall 0x191f, 0x1a8
  06C6E2  0BE2: 8b46ec           mov ax, word ptr [bp - 0x14]
  06C6E5  0BE5: 8b56ee           mov dx, word ptr [bp - 0x12]
  06C6E8  0BE8: c9               leave 
  06C6E9  0BE9: cb               retf 

; ---- func_06C6EA  size=96  insns=33  prologue=ENTER 0x000A,0  terminal=RETF imm16 ----
  06C6EA  0BEA: c80a0000         enter 0xa, 0
  06C6EE  0BEE: 50               push ax
  06C6EF  0BEF: c746fe0000       mov word ptr [bp - 2], 0
  06C6F4  0BF4: 2bc0             sub ax, ax
  06C6F6  0BF6: 8946f8           mov word ptr [bp - 8], ax
  06C6F9  0BF9: 8946f6           mov word ptr [bp - 0xa], ax
  06C6FC  0BFC: c45e06           les bx, ptr [bp + 6]
  06C6FF  0BFF: 268b4754         mov ax, word ptr es:[bx + 0x54]
  06C703  0C03: 268b5756         mov dx, word ptr es:[bx + 0x56]
  06C707  0C07: eb2b             jmp 0xc34
  06C709  0C09: 90               nop 
  06C70A  0C0A: 8b46fc           mov ax, word ptr [bp - 4]
  06C70D  0C0D: 0b46fa           or ax, word ptr [bp - 6]
  06C710  0C10: 742e             je 0xc40
  06C712  0C12: 8b46f4           mov ax, word ptr [bp - 0xc]
  06C715  0C15: c45efa           les bx, ptr [bp - 6]
  06C718  0C18: 26394704         cmp word ptr es:[bx + 4], ax
  06C71C  0C1C: 750e             jne 0xc2c
  06C71E  0C1E: c746fe0100       mov word ptr [bp - 2], 1
  06C723  0C23: 895ef6           mov word ptr [bp - 0xa], bx
  06C726  0C26: 8c46f8           mov word ptr [bp - 8], es
  06C729  0C29: eb0f             jmp 0xc3a
  06C72B  0C2B: 90               nop 
  06C72C  0C2C: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06C730  0C30: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06C734  0C34: 8946fa           mov word ptr [bp - 6], ax
  06C737  0C37: 8956fc           mov word ptr [bp - 4], dx
  06C73A  0C3A: 837efe00         cmp word ptr [bp - 2], 0
  06C73E  0C3E: 74ca             je 0xc0a
  06C740  0C40: 8b46f6           mov ax, word ptr [bp - 0xa]
  06C743  0C43: 8b56f8           mov dx, word ptr [bp - 8]
  06C746  0C46: c9               leave 
  06C747  0C47: ca0400           retf 4

; ---- func_06C74A  size=47  insns=18  prologue=ENTER 0x0004,0  terminal=RETF ----
  06C74A  0C4A: c8040000         enter 4, 0
  06C74E  0C4E: ff7608           push word ptr [bp + 8]
  06C751  0C51: ff7606           push word ptr [bp + 6]
  06C754  0C54: 8b460a           mov ax, word ptr [bp + 0xa]
  06C757  0C57: 0e               push cs
  06C758  0C58: e8c630           call 0x3d21
  06C75B  0C5B: 8946fc           mov word ptr [bp - 4], ax
  06C75E  0C5E: 8956fe           mov word ptr [bp - 2], dx
  06C761  0C61: 837e0c00         cmp word ptr [bp + 0xc], 0
  06C765  0C65: 7409             je 0xc70
  06C767  0C67: c45efc           les bx, ptr [bp - 4]
  06C76A  0C6A: 26800f01         or byte ptr es:[bx], 1
  06C76E  0C6E: c9               leave 
  06C76F  0C6F: cb               retf 
  06C770  0C70: c45efc           les bx, ptr [bp - 4]
  06C773  0C73: 268027fe         and byte ptr es:[bx], 0xfe
  06C777  0C77: c9               leave 
  06C778  0C78: cb               retf 

; ---- func_06C77A  size=47  insns=18  prologue=ENTER 0x0004,0  terminal=RETF ----
  06C77A  0C7A: c8040000         enter 4, 0
  06C77E  0C7E: ff7608           push word ptr [bp + 8]
  06C781  0C81: ff7606           push word ptr [bp + 6]
  06C784  0C84: 8b460a           mov ax, word ptr [bp + 0xa]
  06C787  0C87: 0e               push cs
  06C788  0C88: e89630           call 0x3d21
  06C78B  0C8B: 8946fc           mov word ptr [bp - 4], ax
  06C78E  0C8E: 8956fe           mov word ptr [bp - 2], dx
  06C791  0C91: 837e0c00         cmp word ptr [bp + 0xc], 0
  06C795  0C95: 7409             je 0xca0
  06C797  0C97: c45efc           les bx, ptr [bp - 4]
  06C79A  0C9A: 26800f02         or byte ptr es:[bx], 2
  06C79E  0C9E: c9               leave 
  06C79F  0C9F: cb               retf 
  06C7A0  0CA0: c45efc           les bx, ptr [bp - 4]
  06C7A3  0CA3: 268027fd         and byte ptr es:[bx], 0xfd
  06C7A7  0CA7: c9               leave 
  06C7A8  0CA8: cb               retf 

; ---- func_06C7AA  size=48  insns=17  prologue=ENTER 0x0004,0  terminal=RETF ----
  06C7AA  0CAA: c8040000         enter 4, 0
  06C7AE  0CAE: c45e06           les bx, ptr [bp + 6]
  06C7B1  0CB1: 268b4754         mov ax, word ptr es:[bx + 0x54]
  06C7B5  0CB5: 268b5756         mov dx, word ptr es:[bx + 0x56]
  06C7B9  0CB9: 8946fc           mov word ptr [bp - 4], ax
  06C7BC  0CBC: 8956fe           mov word ptr [bp - 2], dx
  06C7BF  0CBF: 8bc2             mov ax, dx
  06C7C1  0CC1: 0b46fc           or ax, word ptr [bp - 4]
  06C7C4  0CC4: 7412             je 0xcd8
  06C7C6  0CC6: c45efc           les bx, ptr [bp - 4]
  06C7C9  0CC9: 268027fe         and byte ptr es:[bx], 0xfe
  06C7CD  0CCD: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06C7D1  0CD1: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06C7D5  0CD5: ebe2             jmp 0xcb9
  06C7D7  0CD7: 90               nop 
  06C7D8  0CD8: c9               leave 
  06C7D9  0CD9: cb               retf 

; ---- func_06C7DA  size=47  insns=17  prologue=ENTER 0x0006,0  terminal=RETF ----
  06C7DA  0CDA: c8060000         enter 6, 0
  06C7DE  0CDE: c746fe0000       mov word ptr [bp - 2], 0
  06C7E3  0CE3: ff7608           push word ptr [bp + 8]
  06C7E6  0CE6: ff7606           push word ptr [bp + 6]
  06C7E9  0CE9: 8b460a           mov ax, word ptr [bp + 0xa]
  06C7EC  0CEC: 0e               push cs
  06C7ED  0CED: e83130           call 0x3d21
  06C7F0  0CF0: 8946fa           mov word ptr [bp - 6], ax
  06C7F3  0CF3: 8956fc           mov word ptr [bp - 4], dx
  06C7F6  0CF6: 0bd0             or dx, ax
  06C7F8  0CF8: 740a             je 0xd04
  06C7FA  0CFA: c45efa           les bx, ptr [bp - 6]
  06C7FD  0CFD: 268b4706         mov ax, word ptr es:[bx + 6]
  06C801  0D01: 8946fe           mov word ptr [bp - 2], ax
  06C804  0D04: 8b46fe           mov ax, word ptr [bp - 2]
  06C807  0D07: c9               leave 
  06C808  0D08: cb               retf 

; ---- func_06C80A  size=39  insns=15  prologue=ENTER 0x0004,0  terminal=RETF ----
  06C80A  0D0A: c8040000         enter 4, 0
  06C80E  0D0E: ff7608           push word ptr [bp + 8]
  06C811  0D11: ff7606           push word ptr [bp + 6]
  06C814  0D14: 8b460a           mov ax, word ptr [bp + 0xa]
  06C817  0D17: 0e               push cs
  06C818  0D18: e80630           call 0x3d21
  06C81B  0D1B: 8946fc           mov word ptr [bp - 4], ax
  06C81E  0D1E: 8956fe           mov word ptr [bp - 2], dx
  06C821  0D21: 0bd0             or dx, ax
  06C823  0D23: 740a             je 0xd2f
  06C825  0D25: 8b460c           mov ax, word ptr [bp + 0xc]
  06C828  0D28: c45efc           les bx, ptr [bp - 4]
  06C82B  0D2B: 26894706         mov word ptr es:[bx + 6], ax
  06C82F  0D2F: c9               leave 
  06C830  0D30: cb               retf 

; ---- func_06C832  size=29  insns=12  prologue=push bp;mov bp,sp  terminal=RETF ----
  06C832  0D32: 55               push bp
  06C833  0D33: 8bec             mov bp, sp
  06C835  0D35: ff7608           push word ptr [bp + 8]
  06C838  0D38: ff7606           push word ptr [bp + 6]
  06C83B  0D3B: 8b460a           mov ax, word ptr [bp + 0xa]
  06C83E  0D3E: 0e               push cs
  06C83F  0D3F: e8df2f           call 0x3d21
  06C842  0D42: c45e06           les bx, ptr [bp + 6]
  06C845  0D45: 2689474c         mov word ptr es:[bx + 0x4c], ax
  06C849  0D49: 2689574e         mov word ptr es:[bx + 0x4e], dx
  06C84D  0D4D: c9               leave 
  06C84E  0D4E: cb               retf 

; ---- func_06C850  size=488  insns=160  prologue=ENTER 0x0020,0  terminal=RETF ----
  06C850  0D50: c8200000         enter 0x20, 0
  06C854  0D54: 56               push si
  06C855  0D55: c45e06           les bx, ptr [bp + 6]
  06C858  0D58: 268b4754         mov ax, word ptr es:[bx + 0x54]
  06C85C  0D5C: 268b5756         mov dx, word ptr es:[bx + 0x56]
  06C860  0D60: 8946e0           mov word ptr [bp - 0x20], ax
  06C863  0D63: 8956e2           mov word ptr [bp - 0x1e], dx
  06C866  0D66: 2bc0             sub ax, ax
  06C868  0D68: 8946e6           mov word ptr [bp - 0x1a], ax
  06C86B  0D6B: 8946e4           mov word ptr [bp - 0x1c], ax
  06C86E  0D6E: 8bc2             mov ax, dx
  06C870  0D70: 0b46e0           or ax, word ptr [bp - 0x20]
  06C873  0D73: 741d             je 0xd92
  06C875  0D75: 8b46e0           mov ax, word ptr [bp - 0x20]
  06C878  0D78: 8946e4           mov word ptr [bp - 0x1c], ax
  06C87B  0D7B: 8956e6           mov word ptr [bp - 0x1a], dx
  06C87E  0D7E: 8ec2             mov es, dx
  06C880  0D80: 8bd8             mov bx, ax
  06C882  0D82: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06C886  0D86: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06C88A  0D8A: 8946e0           mov word ptr [bp - 0x20], ax
  06C88D  0D8D: 8956e2           mov word ptr [bp - 0x1e], dx
  06C890  0D90: ebdc             jmp 0xd6e
  06C892  0D92: 8b4606           mov ax, word ptr [bp + 6]
  06C895  0D95: 8b5608           mov dx, word ptr [bp + 8]
  06C898  0D98: 058400           add ax, 0x84
  06C89B  0D9B: 52               push dx
  06C89C  0D9C: 50               push ax
  06C89D  0D9D: b81800           mov ax, 0x18
  06C8A0  0DA0: 99               cdq 
  06C8A1  0DA1: 9a2c001f18       lcall 0x181f, 0x2c
  06C8A6  0DA6: 8946e0           mov word ptr [bp - 0x20], ax
  06C8A9  0DA9: 8956e2           mov word ptr [bp - 0x1e], dx
  06C8AC  0DAC: 8b46e6           mov ax, word ptr [bp - 0x1a]
  06C8AF  0DAF: 0b46e4           or ax, word ptr [bp - 0x1c]
  06C8B2  0DB2: 7422             je 0xdd6
  06C8B4  0DB4: c45ee0           les bx, ptr [bp - 0x20]
  06C8B7  0DB7: 8cc0             mov ax, es
  06C8B9  0DB9: c476e4           les si, ptr [bp - 0x1c]
  06C8BC  0DBC: 26895c10         mov word ptr es:[si + 0x10], bx
  06C8C0  0DC0: 26894412         mov word ptr es:[si + 0x12], ax
  06C8C4  0DC4: 8ec0             mov es, ax
  06C8C6  0DC6: 8b46e4           mov ax, word ptr [bp - 0x1c]
  06C8C9  0DC9: 8b56e6           mov dx, word ptr [bp - 0x1a]
  06C8CC  0DCC: 26894714         mov word ptr es:[bx + 0x14], ax
  06C8D0  0DD0: 26895716         mov word ptr es:[bx + 0x16], dx
  06C8D4  0DD4: eb24             jmp 0xdfa
  06C8D6  0DD6: 8b46e0           mov ax, word ptr [bp - 0x20]
  06C8D9  0DD9: c45e06           les bx, ptr [bp + 6]
  06C8DC  0DDC: 26894754         mov word ptr es:[bx + 0x54], ax
  06C8E0  0DE0: 26895756         mov word ptr es:[bx + 0x56], dx
  06C8E4  0DE4: 2689474c         mov word ptr es:[bx + 0x4c], ax
  06C8E8  0DE8: 2689574e         mov word ptr es:[bx + 0x4e], dx
  06C8EC  0DEC: 8ec2             mov es, dx
  06C8EE  0DEE: 8bd8             mov bx, ax
  06C8F0  0DF0: 2bc0             sub ax, ax
  06C8F2  0DF2: 26894716         mov word ptr es:[bx + 0x16], ax
  06C8F6  0DF6: 26894714         mov word ptr es:[bx + 0x14], ax
  06C8FA  0DFA: 8b46e0           mov ax, word ptr [bp - 0x20]
  06C8FD  0DFD: 8b56e2           mov dx, word ptr [bp - 0x1e]
  06C900  0E00: c45e06           les bx, ptr [bp + 6]
  06C903  0E03: 26894770         mov word ptr es:[bx + 0x70], ax
  06C907  0E07: 26895772         mov word ptr es:[bx + 0x72], dx
  06C90B  0E0B: 26f6470a04       test byte ptr es:[bx + 0xa], 4
  06C910  0E10: 7416             je 0xe28
  06C912  0E12: c746e80300       mov word ptr [bp - 0x18], 3
  06C917  0E17: 68911f           push 0x1f91
  06C91A  0E1A: 8d46ea           lea ax, [bp - 0x16]
  06C91D  0E1D: 50               push ax
  06C91E  0E1E: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06C923  0E23: 83c404           add sp, 4
  06C926  0E26: eb09             jmp 0xe31
  06C928  0E28: c746e80000       mov word ptr [bp - 0x18], 0
  06C92D  0E2D: c646ea00         mov byte ptr [bp - 0x16], 0
  06C931  0E31: c45ee0           les bx, ptr [bp - 0x20]
  06C934  0E34: 2bc0             sub ax, ax
  06C936  0E36: 26894712         mov word ptr es:[bx + 0x12], ax
  06C93A  0E3A: 26894710         mov word ptr es:[bx + 0x10], ax
  06C93E  0E3E: 268907           mov word ptr es:[bx], ax
  06C941  0E41: 26894706         mov word ptr es:[bx + 6], ax
  06C945  0E45: 8b4606           mov ax, word ptr [bp + 6]
  06C948  0E48: 8b5608           mov dx, word ptr [bp + 8]
  06C94B  0E4B: 058400           add ax, 0x84
  06C94E  0E4E: 52               push dx
  06C94F  0E4F: 50               push ax
  06C950  0E50: ff760c           push word ptr [bp + 0xc]
  06C953  0E53: ff760a           push word ptr [bp + 0xa]
  06C956  0E56: 9a3c111d0d       lcall 0xd1d, 0x113c
  06C95B  0E5B: 83c404           add sp, 4
  06C95E  0E5E: 0346e8           add ax, word ptr [bp - 0x18]
  06C961  0E61: 40               inc ax
  06C962  0E62: 2bd2             sub dx, dx
  06C964  0E64: 9a2c001f18       lcall 0x181f, 0x2c
  06C969  0E69: c45ee0           les bx, ptr [bp - 0x20]
  06C96C  0E6C: 26894708         mov word ptr es:[bx + 8], ax
  06C970  0E70: 2689570a         mov word ptr es:[bx + 0xa], dx
  06C974  0E74: 8d46ea           lea ax, [bp - 0x16]
  06C977  0E77: 16               push ss
  06C978  0E78: 50               push ax
  06C979  0E79: 26ff770a         push word ptr es:[bx + 0xa]
  06C97D  0E7D: 26ff7708         push word ptr es:[bx + 8]
  06C981  0E81: 9a7e111d0d       lcall 0xd1d, 0x117e
  06C986  0E86: 83c408           add sp, 8
  06C989  0E89: ff760c           push word ptr [bp + 0xc]
  06C98C  0E8C: ff760a           push word ptr [bp + 0xa]
  06C98F  0E8F: c45ee0           les bx, ptr [bp - 0x20]
  06C992  0E92: 26ff770a         push word ptr es:[bx + 0xa]
  06C996  0E96: 26ff7708         push word ptr es:[bx + 8]
  06C99A  0E9A: 9ab4111d0d       lcall 0xd1d, 0x11b4
  06C99F  0E9F: 83c408           add sp, 8
  06C9A2  0EA2: c45e0a           les bx, ptr [bp + 0xa]
  06C9A5  0EA5: 26803f00         cmp byte ptr es:[bx], 0
  06C9A9  0EA9: 7507             jne 0xeb2
  06C9AB  0EAB: c45ee0           les bx, ptr [bp - 0x20]
  06C9AE  0EAE: 26800f01         or byte ptr es:[bx], 1
  06C9B2  0EB2: 8b460e           mov ax, word ptr [bp + 0xe]
  06C9B5  0EB5: c45ee0           les bx, ptr [bp - 0x20]
  06C9B8  0EB8: 26894704         mov word ptr es:[bx + 4], ax
  06C9BC  0EBC: ff760c           push word ptr [bp + 0xc]
  06C9BF  0EBF: ff760a           push word ptr [bp + 0xa]
  06C9C2  0EC2: e8cdfa           call 0x992
  06C9C5  0EC5: c45ee0           les bx, ptr [bp - 0x20]
  06C9C8  0EC8: 26894702         mov word ptr es:[bx + 2], ax
  06C9CC  0ECC: 8b4606           mov ax, word ptr [bp + 6]
  06C9CF  0ECF: 8b5608           mov dx, word ptr [bp + 8]
  06C9D2  0ED2: 057400           add ax, 0x74
  06C9D5  0ED5: 52               push dx
  06C9D6  0ED6: 50               push ax
  06C9D7  0ED7: 26ff770a         push word ptr es:[bx + 0xa]
  06C9DB  0EDB: 26ff7708         push word ptr es:[bx + 8]
  06C9DF  0EDF: e8f4f8           call 0x7d6
  06C9E2  0EE2: 8946fe           mov word ptr [bp - 2], ax
  06C9E5  0EE5: c45e06           les bx, ptr [bp + 6]
  06C9E8  0EE8: 268b4748         mov ax, word ptr es:[bx + 0x48]
  06C9EC  0EEC: d1e0             shl ax, 1
  06C9EE  0EEE: 26034722         add ax, word ptr es:[bx + 0x22]
  06C9F2  0EF2: 0146fe           add word ptr [bp - 2], ax
  06C9F5  0EF5: 6a7c             push 0x7c
  06C9F7  0EF7: c476e0           les si, ptr [bp - 0x20]
  06C9FA  0EFA: 26ff740a         push word ptr es:[si + 0xa]
  06C9FE  0EFE: 26ff7408         push word ptr es:[si + 8]
  06CA02  0F02: 9a10101d0d       lcall 0xd1d, 0x1010
  06CA07  0F07: 83c406           add sp, 6
  06CA0A  0F0A: 0bd0             or dx, ax
  06CA0C  0F0C: 740a             je 0xf18
  06CA0E  0F0E: c45e06           les bx, ptr [bp + 6]
  06CA11  0F11: 268b4722         mov ax, word ptr es:[bx + 0x22]
  06CA15  0F15: 0146fe           add word ptr [bp - 2], ax
  06CA18  0F18: c45e06           les bx, ptr [bp + 6]
  06CA1B  0F1B: 268b4720         mov ax, word ptr es:[bx + 0x20]
  06CA1F  0F1F: 3b46fe           cmp ax, word ptr [bp - 2]
  06CA22  0F22: 7d03             jge 0xf27
  06CA24  0F24: 8b46fe           mov ax, word ptr [bp - 2]
  06CA27  0F27: 26894720         mov word ptr es:[bx + 0x20], ax
  06CA2B  0F2B: 26ff4702         inc word ptr es:[bx + 2]
  06CA2F  0F2F: 8b46e0           mov ax, word ptr [bp - 0x20]
  06CA32  0F32: 8b56e2           mov dx, word ptr [bp - 0x1e]
  06CA35  0F35: 5e               pop si
  06CA36  0F36: c9               leave 
  06CA37  0F37: cb               retf 

; ---- func_06CA38  size=58  insns=22  prologue=ENTER 0x0004,0  terminal=RETF ----
  06CA38  0F38: c8040000         enter 4, 0
  06CA3C  0F3C: c45e06           les bx, ptr [bp + 6]
  06CA3F  0F3F: 26804f0a05       or byte ptr es:[bx + 0xa], 5
  06CA44  0F44: ff760e           push word ptr [bp + 0xe]
  06CA47  0F47: ff760c           push word ptr [bp + 0xc]
  06CA4A  0F4A: ff760a           push word ptr [bp + 0xa]
  06CA4D  0F4D: 06               push es
  06CA4E  0F4E: 53               push bx
  06CA4F  0F4F: 0e               push cs
  06CA50  0F50: e8ab2d           call 0x3cfe
  06CA53  0F53: 83c40a           add sp, 0xa
  06CA56  0F56: 8946fc           mov word ptr [bp - 4], ax
  06CA59  0F59: 8956fe           mov word ptr [bp - 2], dx
  06CA5C  0F5C: 0bd0             or dx, ax
  06CA5E  0F5E: 740a             je 0xf6a
  06CA60  0F60: 8b4610           mov ax, word ptr [bp + 0x10]
  06CA63  0F63: c45efc           les bx, ptr [bp - 4]
  06CA66  0F66: 26894706         mov word ptr es:[bx + 6], ax
  06CA6A  0F6A: 8b46fc           mov ax, word ptr [bp - 4]
  06CA6D  0F6D: 8b56fe           mov dx, word ptr [bp - 2]
  06CA70  0F70: c9               leave 
  06CA71  0F71: cb               retf 

; ---- func_06CA72  size=15  insns=7  prologue=push bp;mov bp,sp  terminal=RETF ----
  06CA72  0F72: 55               push bp
  06CA73  0F73: 8bec             mov bp, sp
  06CA75  0F75: 8b460a           mov ax, word ptr [bp + 0xa]
  06CA78  0F78: c45e06           les bx, ptr [bp + 6]
  06CA7B  0F7B: 26894728         mov word ptr es:[bx + 0x28], ax
  06CA7F  0F7F: c9               leave 
  06CA80  0F80: cb               retf 

; ---- func_06CA82  size=274  insns=95  prologue=ENTER 0x0008,0  terminal=RETF ----
  06CA82  0F82: c8080000         enter 8, 0
  06CA86  0F86: 56               push si
  06CA87  0F87: c45e06           les bx, ptr [bp + 6]
  06CA8A  0F8A: 268b4758         mov ax, word ptr es:[bx + 0x58]
  06CA8E  0F8E: 268b575a         mov dx, word ptr es:[bx + 0x5a]
  06CA92  0F92: 8946f8           mov word ptr [bp - 8], ax
  06CA95  0F95: 8956fa           mov word ptr [bp - 6], dx
  06CA98  0F98: 2bc0             sub ax, ax
  06CA9A  0F9A: 8946fe           mov word ptr [bp - 2], ax
  06CA9D  0F9D: 8946fc           mov word ptr [bp - 4], ax
  06CAA0  0FA0: 8bc2             mov ax, dx
  06CAA2  0FA2: 0b46f8           or ax, word ptr [bp - 8]
  06CAA5  0FA5: 741d             je 0xfc4
  06CAA7  0FA7: 8b46f8           mov ax, word ptr [bp - 8]
  06CAAA  0FAA: 8946fc           mov word ptr [bp - 4], ax
  06CAAD  0FAD: 8956fe           mov word ptr [bp - 2], dx
  06CAB0  0FB0: 8ec2             mov es, dx
  06CAB2  0FB2: 8bd8             mov bx, ax
  06CAB4  0FB4: 268b4706         mov ax, word ptr es:[bx + 6]
  06CAB8  0FB8: 268b5708         mov dx, word ptr es:[bx + 8]
  06CABC  0FBC: 8946f8           mov word ptr [bp - 8], ax
  06CABF  0FBF: 8956fa           mov word ptr [bp - 6], dx
  06CAC2  0FC2: ebdc             jmp 0xfa0
  06CAC4  0FC4: 8b4606           mov ax, word ptr [bp + 6]
  06CAC7  0FC7: 8b5608           mov dx, word ptr [bp + 8]
  06CACA  0FCA: 058400           add ax, 0x84
  06CACD  0FCD: 52               push dx
  06CACE  0FCE: 50               push ax
  06CACF  0FCF: b80a00           mov ax, 0xa
  06CAD2  0FD2: 99               cdq 
  06CAD3  0FD3: 9a2c001f18       lcall 0x181f, 0x2c
  06CAD8  0FD8: 8946f8           mov word ptr [bp - 8], ax
  06CADB  0FDB: 8956fa           mov word ptr [bp - 6], dx
  06CADE  0FDE: 8b46fe           mov ax, word ptr [bp - 2]
  06CAE1  0FE1: 0b46fc           or ax, word ptr [bp - 4]
  06CAE4  0FE4: 7410             je 0xff6
  06CAE6  0FE6: 8b46f8           mov ax, word ptr [bp - 8]
  06CAE9  0FE9: c45efc           les bx, ptr [bp - 4]
  06CAEC  0FEC: 26894706         mov word ptr es:[bx + 6], ax
  06CAF0  0FF0: 26895708         mov word ptr es:[bx + 8], dx
  06CAF4  0FF4: eb0e             jmp 0x1004
  06CAF6  0FF6: 8b46f8           mov ax, word ptr [bp - 8]
  06CAF9  0FF9: c45e06           les bx, ptr [bp + 6]
  06CAFC  0FFC: 26894758         mov word ptr es:[bx + 0x58], ax
  06CB00  1000: 2689575a         mov word ptr es:[bx + 0x5a], dx
  06CB04  1004: c45ef8           les bx, ptr [bp - 8]
  06CB07  1007: 2bc0             sub ax, ax
  06CB09  1009: 26894708         mov word ptr es:[bx + 8], ax
  06CB0D  100D: 26894706         mov word ptr es:[bx + 6], ax
  06CB11  1011: 268907           mov word ptr es:[bx], ax
  06CB14  1014: c4760a           les si, ptr [bp + 0xa]
  06CB17  1017: 26803c5e         cmp byte ptr es:[si], 0x5e
  06CB1B  101B: 7528             jne 0x1045
  06CB1D  101D: ff460a           inc word ptr [bp + 0xa]
  06CB20  1020: 8b5e0a           mov bx, word ptr [bp + 0xa]
  06CB23  1023: 26803f5e         cmp byte ptr es:[bx], 0x5e
  06CB27  1027: 7515             jne 0x103e
  06CB29  1029: c476f8           les si, ptr [bp - 8]
  06CB2C  102C: 26c7040100       mov word ptr es:[si], 1
  06CB31  1031: 8b460a           mov ax, word ptr [bp + 0xa]
  06CB34  1034: 8b560c           mov dx, word ptr [bp + 0xc]
  06CB37  1037: 40               inc ax
  06CB38  1038: 89460a           mov word ptr [bp + 0xa], ax
  06CB3B  103B: eb08             jmp 0x1045
  06CB3D  103D: 90               nop 
  06CB3E  103E: c45ef8           les bx, ptr [bp - 8]
  06CB41  1041: 26800f02         or byte ptr es:[bx], 2
  06CB45  1045: 8b4606           mov ax, word ptr [bp + 6]
  06CB48  1048: 8b5608           mov dx, word ptr [bp + 8]
  06CB4B  104B: 058400           add ax, 0x84
  06CB4E  104E: 52               push dx
  06CB4F  104F: 50               push ax
  06CB50  1050: ff760c           push word ptr [bp + 0xc]
  06CB53  1053: ff760a           push word ptr [bp + 0xa]
  06CB56  1056: 9a3c111d0d       lcall 0xd1d, 0x113c
  06CB5B  105B: 83c404           add sp, 4
  06CB5E  105E: 40               inc ax
  06CB5F  105F: 2bd2             sub dx, dx
  06CB61  1061: 9a2c001f18       lcall 0x181f, 0x2c
  06CB66  1066: c45ef8           les bx, ptr [bp - 8]
  06CB69  1069: 26894702         mov word ptr es:[bx + 2], ax
  06CB6D  106D: 26895704         mov word ptr es:[bx + 4], dx
  06CB71  1071: ff760c           push word ptr [bp + 0xc]
  06CB74  1074: ff760a           push word ptr [bp + 0xa]
  06CB77  1077: 52               push dx
  06CB78  1078: 26ff7702         push word ptr es:[bx + 2]
  06CB7C  107C: 9a7e111d0d       lcall 0xd1d, 0x117e
  06CB81  1081: 83c408           add sp, 8
  06CB84  1084: c45e06           les bx, ptr [bp + 6]
  06CB87  1087: 26ff4704         inc word ptr es:[bx + 4]
  06CB8B  108B: 8b46f8           mov ax, word ptr [bp - 8]
  06CB8E  108E: 8b56fa           mov dx, word ptr [bp - 6]
  06CB91  1091: 5e               pop si
  06CB92  1092: c9               leave 
  06CB93  1093: cb               retf 

; ---- func_06CB94  size=465  insns=158  prologue=ENTER 0x000E,0  terminal=RETF ----
  06CB94  1094: c80e0000         enter 0xe, 0
  06CB98  1098: 57               push di
  06CB99  1099: 56               push si
  06CB9A  109A: c45e06           les bx, ptr [bp + 6]
  06CB9D  109D: 268b4760         mov ax, word ptr es:[bx + 0x60]
  06CBA1  10A1: 268b5762         mov dx, word ptr es:[bx + 0x62]
  06CBA5  10A5: 8946fa           mov word ptr [bp - 6], ax
  06CBA8  10A8: 8956fc           mov word ptr [bp - 4], dx
  06CBAB  10AB: 2bc0             sub ax, ax
  06CBAD  10AD: 8946f8           mov word ptr [bp - 8], ax
  06CBB0  10B0: 8946f6           mov word ptr [bp - 0xa], ax
  06CBB3  10B3: 8bc2             mov ax, dx
  06CBB5  10B5: 0b46fa           or ax, word ptr [bp - 6]
  06CBB8  10B8: 741e             je 0x10d8
  06CBBA  10BA: 8b46fa           mov ax, word ptr [bp - 6]
  06CBBD  10BD: 8946f6           mov word ptr [bp - 0xa], ax
  06CBC0  10C0: 8956f8           mov word ptr [bp - 8], dx
  06CBC3  10C3: 8ec2             mov es, dx
  06CBC5  10C5: 8bd8             mov bx, ax
  06CBC7  10C7: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06CBCB  10CB: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06CBCF  10CF: 8946fa           mov word ptr [bp - 6], ax
  06CBD2  10D2: 8956fc           mov word ptr [bp - 4], dx
  06CBD5  10D5: ebdc             jmp 0x10b3
  06CBD7  10D7: 90               nop 
  06CBD8  10D8: 8b4606           mov ax, word ptr [bp + 6]
  06CBDB  10DB: 8b5608           mov dx, word ptr [bp + 8]
  06CBDE  10DE: 058400           add ax, 0x84
  06CBE1  10E1: 52               push dx
  06CBE2  10E2: 50               push ax
  06CBE3  10E3: b81400           mov ax, 0x14
  06CBE6  10E6: 99               cdq 
  06CBE7  10E7: 9a2c001f18       lcall 0x181f, 0x2c
  06CBEC  10EC: 8946fa           mov word ptr [bp - 6], ax
  06CBEF  10EF: 8956fc           mov word ptr [bp - 4], dx
  06CBF2  10F2: 8b46f8           mov ax, word ptr [bp - 8]
  06CBF5  10F5: 0b46f6           or ax, word ptr [bp - 0xa]
  06CBF8  10F8: 7410             je 0x110a
  06CBFA  10FA: 8b46fa           mov ax, word ptr [bp - 6]
  06CBFD  10FD: c45ef6           les bx, ptr [bp - 0xa]
  06CC00  1100: 26894710         mov word ptr es:[bx + 0x10], ax
  06CC04  1104: 26895712         mov word ptr es:[bx + 0x12], dx
  06CC08  1108: eb0e             jmp 0x1118
  06CC0A  110A: 8b46fa           mov ax, word ptr [bp - 6]
  06CC0D  110D: c45e06           les bx, ptr [bp + 6]
  06CC10  1110: 26894760         mov word ptr es:[bx + 0x60], ax
  06CC14  1114: 26895762         mov word ptr es:[bx + 0x62], dx
  06CC18  1118: c45efa           les bx, ptr [bp - 6]
  06CC1B  111B: 2bc0             sub ax, ax
  06CC1D  111D: 26894712         mov word ptr es:[bx + 0x12], ax
  06CC21  1121: 26894710         mov word ptr es:[bx + 0x10], ax
  06CC25  1125: 268907           mov word ptr es:[bx], ax
  06CC28  1128: 8b4606           mov ax, word ptr [bp + 6]
  06CC2B  112B: 8b5608           mov dx, word ptr [bp + 8]
  06CC2E  112E: 058400           add ax, 0x84
  06CC31  1131: 52               push dx
  06CC32  1132: 50               push ax
  06CC33  1133: ff760c           push word ptr [bp + 0xc]
  06CC36  1136: ff760a           push word ptr [bp + 0xa]
  06CC39  1139: 8bf0             mov si, ax
  06CC3B  113B: 8bfa             mov di, dx
  06CC3D  113D: 9a3c111d0d       lcall 0xd1d, 0x113c
  06CC42  1142: 83c404           add sp, 4
  06CC45  1145: 40               inc ax
  06CC46  1146: 40               inc ax
  06CC47  1147: 2bd2             sub dx, dx
  06CC49  1149: 9a2c001f18       lcall 0x181f, 0x2c
  06CC4E  114E: c45efa           les bx, ptr [bp - 6]
  06CC51  1151: 26894708         mov word ptr es:[bx + 8], ax
  06CC55  1155: 2689570a         mov word ptr es:[bx + 0xa], dx
  06CC59  1159: ff760c           push word ptr [bp + 0xc]
  06CC5C  115C: ff760a           push word ptr [bp + 0xa]
  06CC5F  115F: 52               push dx
  06CC60  1160: 26ff7708         push word ptr es:[bx + 8]
  06CC64  1164: 9a7e111d0d       lcall 0xd1d, 0x117e
  06CC69  1169: 83c408           add sp, 8
  06CC6C  116C: 1e               push ds
  06CC6D  116D: 68951f           push 0x1f95
  06CC70  1170: c45efa           les bx, ptr [bp - 6]
  06CC73  1173: 26ff770a         push word ptr es:[bx + 0xa]
  06CC77  1177: 26ff7708         push word ptr es:[bx + 8]
  06CC7B  117B: 9ab4111d0d       lcall 0xd1d, 0x11b4
  06CC80  1180: 83c408           add sp, 8
  06CC83  1183: 8b4606           mov ax, word ptr [bp + 6]
  06CC86  1186: 8b5608           mov dx, word ptr [bp + 8]
  06CC89  1189: 057400           add ax, 0x74
  06CC8C  118C: 52               push dx
  06CC8D  118D: 50               push ax
  06CC8E  118E: c45efa           les bx, ptr [bp - 6]
  06CC91  1191: 26ff770a         push word ptr es:[bx + 0xa]
  06CC95  1195: 26ff7708         push word ptr es:[bx + 8]
  06CC99  1199: 8946f2           mov word ptr [bp - 0xe], ax
  06CC9C  119C: 8956f4           mov word ptr [bp - 0xc], dx
  06CC9F  119F: e834f6           call 0x7d6
  06CCA2  11A2: c45efa           les bx, ptr [bp - 6]
  06CCA5  11A5: 26894702         mov word ptr es:[bx + 2], ax
  06CCA9  11A9: 8b4612           mov ax, word ptr [bp + 0x12]
  06CCAC  11AC: 26894706         mov word ptr es:[bx + 6], ax
  06CCB0  11B0: 57               push di
  06CCB1  11B1: 56               push si
  06CCB2  11B2: 40               inc ax
  06CCB3  11B3: 99               cdq 
  06CCB4  11B4: 9a2c001f18       lcall 0x181f, 0x2c
  06CCB9  11B9: c45efa           les bx, ptr [bp - 6]
  06CCBC  11BC: 2689470c         mov word ptr es:[bx + 0xc], ax
  06CCC0  11C0: 2689570e         mov word ptr es:[bx + 0xe], dx
  06CCC4  11C4: ff76f4           push word ptr [bp - 0xc]
  06CCC7  11C7: ff76f2           push word ptr [bp - 0xe]
  06CCCA  11CA: 1e               push ds
  06CCCB  11CB: 68971f           push 0x1f97
  06CCCE  11CE: e805f6           call 0x7d6
  06CCD1  11D1: f76e12           imul word ptr [bp + 0x12]
  06CCD4  11D4: c45efa           les bx, ptr [bp - 6]
  06CCD7  11D7: 26894704         mov word ptr es:[bx + 4], ax
  06CCDB  11DB: 268b4702         mov ax, word ptr es:[bx + 2]
  06CCDF  11DF: 26034704         add ax, word ptr es:[bx + 4]
  06CCE3  11E3: 050a00           add ax, 0xa
  06CCE6  11E6: c47606           les si, ptr [bp + 6]
  06CCE9  11E9: 263b4434         cmp ax, word ptr es:[si + 0x34]
  06CCED  11ED: 7d04             jge 0x11f3
  06CCEF  11EF: 268b4434         mov ax, word ptr es:[si + 0x34]
  06CCF3  11F3: 26894434         mov word ptr es:[si + 0x34], ax
  06CCF7  11F7: 8b4610           mov ax, word ptr [bp + 0x10]
  06CCFA  11FA: 0b460e           or ax, word ptr [bp + 0xe]
  06CCFD  11FD: 750d             jne 0x120c
  06CCFF  11FF: c45efa           les bx, ptr [bp - 6]
  06CD02  1202: 26c45f0c         les bx, ptr es:[bx + 0xc]
  06CD06  1206: 26c60700         mov byte ptr es:[bx], 0
  06CD0A  120A: eb48             jmp 0x1254
  06CD0C  120C: ff7612           push word ptr [bp + 0x12]
  06CD0F  120F: ff7610           push word ptr [bp + 0x10]
  06CD12  1212: ff760e           push word ptr [bp + 0xe]
  06CD15  1215: c45efa           les bx, ptr [bp - 6]
  06CD18  1218: 26ff770e         push word ptr es:[bx + 0xe]
  06CD1C  121C: 26ff770c         push word ptr es:[bx + 0xc]
  06CD20  1220: 9ac0101d0d       lcall 0xd1d, 0x10c0
  06CD25  1225: 83c40a           add sp, 0xa
  06CD28  1228: c45efa           les bx, ptr [bp - 6]
  06CD2B  122B: 26c45f0c         les bx, ptr es:[bx + 0xc]
  06CD2F  122F: 8b7612           mov si, word ptr [bp + 0x12]
  06CD32  1232: 26c60000         mov byte ptr es:[bx + si], 0
  06CD36  1236: c45efa           les bx, ptr [bp - 6]
  06CD39  1239: 26ff770e         push word ptr es:[bx + 0xe]
  06CD3D  123D: 26ff770c         push word ptr es:[bx + 0xc]
  06CD41  1241: 9a3c111d0d       lcall 0xd1d, 0x113c
  06CD46  1246: 83c404           add sp, 4
  06CD49  1249: 0bc0             or ax, ax
  06CD4B  124B: 7407             je 0x1254
  06CD4D  124D: c45efa           les bx, ptr [bp - 6]
  06CD50  1250: 26800f80         or byte ptr es:[bx], 0x80
  06CD54  1254: c45e06           les bx, ptr [bp + 6]
  06CD57  1257: 26ff4708         inc word ptr es:[bx + 8]
  06CD5B  125B: 8b46fa           mov ax, word ptr [bp - 6]
  06CD5E  125E: 8b56fc           mov dx, word ptr [bp - 4]
  06CD61  1261: 5e               pop si
  06CD62  1262: 5f               pop di
  06CD63  1263: c9               leave 
  06CD64  1264: cb               retf 

; ---- func_06CD66  size=37  insns=13  prologue=ENTER 0x0002,0  terminal=RET ----
  06CD66  1266: c8020000         enter 2, 0
  06CD6A  126A: c45e04           les bx, ptr [bp + 4]
  06CD6D  126D: 268a07           mov al, byte ptr es:[bx]
  06CD70  1270: 2ae4             sub ah, ah
  06CD72  1272: 8946fe           mov word ptr [bp - 2], ax
  06CD75  1275: 3d0600           cmp ax, 6
  06CD78  1278: 750c             jne 0x1286
  06CD7A  127A: 833e8a1f00       cmp word ptr [0x1f8a], 0
  06CD7F  127F: 7505             jne 0x1286
  06CD81  1281: c746fe0500       mov word ptr [bp - 2], 5
  06CD86  1286: 8b46fe           mov ax, word ptr [bp - 2]
  06CD89  1289: c9               leave 
  06CD8A  128A: c3               ret 

; ---- func_06CD8C  size=494  insns=165  prologue=ENTER 0x0012,0  terminal=RETF ----
  06CD8C  128C: c8120000         enter 0x12, 0
  06CD90  1290: 56               push si
  06CD91  1291: c45e06           les bx, ptr [bp + 6]
  06CD94  1294: 268b475c         mov ax, word ptr es:[bx + 0x5c]
  06CD98  1298: 268b575e         mov dx, word ptr es:[bx + 0x5e]
  06CD9C  129C: 8946f6           mov word ptr [bp - 0xa], ax
  06CD9F  129F: 8956f8           mov word ptr [bp - 8], dx
  06CDA2  12A2: 2bc0             sub ax, ax
  06CDA4  12A4: 8946fc           mov word ptr [bp - 4], ax
  06CDA7  12A7: 8946fa           mov word ptr [bp - 6], ax
  06CDAA  12AA: 8bc2             mov ax, dx
  06CDAC  12AC: 0b46f6           or ax, word ptr [bp - 0xa]
  06CDAF  12AF: 741d             je 0x12ce
  06CDB1  12B1: 8b46f6           mov ax, word ptr [bp - 0xa]
  06CDB4  12B4: 8946fa           mov word ptr [bp - 6], ax
  06CDB7  12B7: 8956fc           mov word ptr [bp - 4], dx
  06CDBA  12BA: 8ec2             mov es, dx
  06CDBC  12BC: 8bd8             mov bx, ax
  06CDBE  12BE: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06CDC2  12C2: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06CDC6  12C6: 8946f6           mov word ptr [bp - 0xa], ax
  06CDC9  12C9: 8956f8           mov word ptr [bp - 8], dx
  06CDCC  12CC: ebdc             jmp 0x12aa
  06CDCE  12CE: 8b4606           mov ax, word ptr [bp + 6]
  06CDD1  12D1: 8b5608           mov dx, word ptr [bp + 8]
  06CDD4  12D4: 058400           add ax, 0x84
  06CDD7  12D7: 52               push dx
  06CDD8  12D8: 50               push ax
  06CDD9  12D9: b81400           mov ax, 0x14
  06CDDC  12DC: 99               cdq 
  06CDDD  12DD: 9a2c001f18       lcall 0x181f, 0x2c
  06CDE2  12E2: 8946f6           mov word ptr [bp - 0xa], ax
  06CDE5  12E5: 8956f8           mov word ptr [bp - 8], dx
  06CDE8  12E8: 8b46fc           mov ax, word ptr [bp - 4]
  06CDEB  12EB: 0b46fa           or ax, word ptr [bp - 6]
  06CDEE  12EE: 741e             je 0x130e
  06CDF0  12F0: c45efa           les bx, ptr [bp - 6]
  06CDF3  12F3: 268b4702         mov ax, word ptr es:[bx + 2]
  06CDF7  12F7: c476f6           les si, ptr [bp - 0xa]
  06CDFA  12FA: 8cc1             mov cx, es
  06CDFC  12FC: 8e46fc           mov es, word ptr [bp - 4]
  06CDFF  12FF: 26897710         mov word ptr es:[bx + 0x10], si
  06CE03  1303: 26894f12         mov word ptr es:[bx + 0x12], cx
  06CE07  1307: 8ec1             mov es, cx
  06CE09  1309: 268904           mov word ptr es:[si], ax
  06CE0C  130C: eb25             jmp 0x1333
  06CE0E  130E: 8b46f6           mov ax, word ptr [bp - 0xa]
  06CE11  1311: c45e06           les bx, ptr [bp + 6]
  06CE14  1314: 2689475c         mov word ptr es:[bx + 0x5c], ax
  06CE18  1318: 2689575e         mov word ptr es:[bx + 0x5e], dx
  06CE1C  131C: 26894750         mov word ptr es:[bx + 0x50], ax
  06CE20  1320: 26895752         mov word ptr es:[bx + 0x52], dx
  06CE24  1324: 268b4f46         mov cx, word ptr es:[bx + 0x46]
  06CE28  1328: 26034f4a         add cx, word ptr es:[bx + 0x4a]
  06CE2C  132C: 8ec2             mov es, dx
  06CE2E  132E: 8bd8             mov bx, ax
  06CE30  1330: 26890f           mov word ptr es:[bx], cx
  06CE33  1333: c45ef6           les bx, ptr [bp - 0xa]
  06CE36  1336: 2bc0             sub ax, ax
  06CE38  1338: 26894712         mov word ptr es:[bx + 0x12], ax
  06CE3C  133C: 26894710         mov word ptr es:[bx + 0x10], ax
  06CE40  1340: 8b460a           mov ax, word ptr [bp + 0xa]
  06CE43  1343: 8b560c           mov dx, word ptr [bp + 0xc]
  06CE46  1346: 2689470c         mov word ptr es:[bx + 0xc], ax
  06CE4A  134A: 2689570e         mov word ptr es:[bx + 0xe], dx
  06CE4E  134E: 8b460e           mov ax, word ptr [bp + 0xe]
  06CE51  1351: 26894704         mov word ptr es:[bx + 4], ax
  06CE55  1355: 8b4614           mov ax, word ptr [bp + 0x14]
  06CE58  1358: 26894706         mov word ptr es:[bx + 6], ax
  06CE5C  135C: 8b4612           mov ax, word ptr [bp + 0x12]
  06CE5F  135F: 0b4610           or ax, word ptr [bp + 0x10]
  06CE62  1362: 7503             jne 0x1367
  06CE64  1364: e98700           jmp 0x13ee
  06CE67  1367: c45e06           les bx, ptr [bp + 6]
  06CE6A  136A: 268b4756         mov ax, word ptr es:[bx + 0x56]
  06CE6E  136E: 260b4754         or ax, word ptr es:[bx + 0x54]
  06CE72  1372: 7506             jne 0x137a
  06CE74  1374: 26c747280000     mov word ptr es:[bx + 0x28], 0
  06CE7A  137A: 8b4606           mov ax, word ptr [bp + 6]
  06CE7D  137D: 8b5608           mov dx, word ptr [bp + 8]
  06CE80  1380: 058400           add ax, 0x84
  06CE83  1383: 52               push dx
  06CE84  1384: 50               push ax
  06CE85  1385: ff7612           push word ptr [bp + 0x12]
  06CE88  1388: ff7610           push word ptr [bp + 0x10]
  06CE8B  138B: 9a3c111d0d       lcall 0xd1d, 0x113c
  06CE90  1390: 83c404           add sp, 4
  06CE93  1393: 40               inc ax
  06CE94  1394: 2bd2             sub dx, dx
  06CE96  1396: 9a2c001f18       lcall 0x181f, 0x2c
  06CE9B  139B: c45ef6           les bx, ptr [bp - 0xa]
  06CE9E  139E: 26894708         mov word ptr es:[bx + 8], ax
  06CEA2  13A2: 2689570a         mov word ptr es:[bx + 0xa], dx
  06CEA6  13A6: ff7612           push word ptr [bp + 0x12]
  06CEA9  13A9: ff7610           push word ptr [bp + 0x10]
  06CEAC  13AC: 52               push dx
  06CEAD  13AD: 26ff7708         push word ptr es:[bx + 8]
  06CEB1  13B1: 9a7e111d0d       lcall 0xd1d, 0x117e
  06CEB6  13B6: 83c408           add sp, 8
  06CEB9  13B9: 8b4606           mov ax, word ptr [bp + 6]
  06CEBC  13BC: 8b5608           mov dx, word ptr [bp + 8]
  06CEBF  13BF: 057400           add ax, 0x74
  06CEC2  13C2: 52               push dx
  06CEC3  13C3: 50               push ax
  06CEC4  13C4: ff7612           push word ptr [bp + 0x12]
  06CEC7  13C7: ff7610           push word ptr [bp + 0x10]
  06CECA  13CA: e809f4           call 0x7d6
  06CECD  13CD: c45e06           les bx, ptr [bp + 6]
  06CED0  13D0: 26034746         add ax, word ptr es:[bx + 0x46]
  06CED4  13D4: 26034732         add ax, word ptr es:[bx + 0x32]
  06CED8  13D8: 8946ee           mov word ptr [bp - 0x12], ax
  06CEDB  13DB: 26ffb78200       push word ptr es:[bx + 0x82]
  06CEE0  13E0: 26ffb78000       push word ptr es:[bx + 0x80]
  06CEE5  13E5: e87efe           call 0x1266
  06CEE8  13E8: 83c404           add sp, 4
  06CEEB  13EB: eb11             jmp 0x13fe
  06CEED  13ED: 90               nop 
  06CEEE  13EE: c45ef6           les bx, ptr [bp - 0xa]
  06CEF1  13F1: 2bc0             sub ax, ax
  06CEF3  13F3: 2689470a         mov word ptr es:[bx + 0xa], ax
  06CEF7  13F7: 26894708         mov word ptr es:[bx + 8], ax
  06CEFB  13FB: 8946ee           mov word ptr [bp - 0x12], ax
  06CEFE  13FE: 8946f4           mov word ptr [bp - 0xc], ax
  06CF01  1401: c45e06           les bx, ptr [bp + 6]
  06CF04  1404: 26f6470a02       test byte ptr es:[bx + 0xa], 2
  06CF09  1409: 7409             je 0x1414
  06CF0B  140B: b81000           mov ax, 0x10
  06CF0E  140E: 8946fe           mov word ptr [bp - 2], ax
  06CF11  1411: eb1e             jmp 0x1431
  06CF13  1413: 90               nop 
  06CF14  1414: 8b5e0e           mov bx, word ptr [bp + 0xe]
  06CF17  1417: 8bc3             mov ax, bx
  06CF19  1419: d1e3             shl bx, 1
  06CF1B  141B: 03d8             add bx, ax
  06CF1D  141D: c1e302           shl bx, 2
  06CF20  1420: 035e0a           add bx, word ptr [bp + 0xa]
  06CF23  1423: 8e460c           mov es, word ptr [bp + 0xc]
  06CF26  1426: 268b473e         mov ax, word ptr es:[bx + 0x3e]
  06CF2A  142A: 8946fe           mov word ptr [bp - 2], ax
  06CF2D  142D: 268b4740         mov ax, word ptr es:[bx + 0x40]
  06CF31  1431: 3b46f4           cmp ax, word ptr [bp - 0xc]
  06CF34  1434: 7d03             jge 0x1439
  06CF36  1436: 8b46f4           mov ax, word ptr [bp - 0xc]
  06CF39  1439: c45e06           les bx, ptr [bp + 6]
  06CF3C  143C: 26034746         add ax, word ptr es:[bx + 0x46]
  06CF40  1440: c476f6           les si, ptr [bp - 0xa]
  06CF43  1443: 260304           add ax, word ptr es:[si]
  06CF46  1446: 26894402         mov word ptr es:[si + 2], ax
  06CF4A  144A: c45e06           les bx, ptr [bp + 6]
  06CF4D  144D: 268b472e         mov ax, word ptr es:[bx + 0x2e]
  06CF51  1451: 3b46fe           cmp ax, word ptr [bp - 2]
  06CF54  1454: 7d03             jge 0x1459
  06CF56  1456: 8b46fe           mov ax, word ptr [bp - 2]
  06CF59  1459: 2689472e         mov word ptr es:[bx + 0x2e], ax
  06CF5D  145D: 268b4730         mov ax, word ptr es:[bx + 0x30]
  06CF61  1461: 3b46ee           cmp ax, word ptr [bp - 0x12]
  06CF64  1464: 7d03             jge 0x1469
  06CF66  1466: 8b46ee           mov ax, word ptr [bp - 0x12]
  06CF69  1469: 26894730         mov word ptr es:[bx + 0x30], ax
  06CF6D  146D: 26ff4706         inc word ptr es:[bx + 6]
  06CF71  1471: 8b46f6           mov ax, word ptr [bp - 0xa]
  06CF74  1474: 8b56f8           mov dx, word ptr [bp - 8]
  06CF77  1477: 5e               pop si
  06CF78  1478: c9               leave 
  06CF79  1479: cb               retf 

; ---- func_06CF7A  size=65  insns=24  prologue=push bp;mov bp,sp  terminal=RETF ----
  06CF7A  147A: 55               push bp
  06CF7B  147B: 8bec             mov bp, sp
  06CF7D  147D: 8b4606           mov ax, word ptr [bp + 6]
  06CF80  1480: 8b5608           mov dx, word ptr [bp + 8]
  06CF83  1483: 058400           add ax, 0x84
  06CF86  1486: 52               push dx
  06CF87  1487: 50               push ax
  06CF88  1488: b81400           mov ax, 0x14
  06CF8B  148B: 99               cdq 
  06CF8C  148C: 9a2c001f18       lcall 0x181f, 0x2c
  06CF91  1491: c45e06           les bx, ptr [bp + 6]
  06CF94  1494: 26894764         mov word ptr es:[bx + 0x64], ax
  06CF98  1498: 26895766         mov word ptr es:[bx + 0x66], dx
  06CF9C  149C: 8b460a           mov ax, word ptr [bp + 0xa]
  06CF9F  149F: 8b560c           mov dx, word ptr [bp + 0xc]
  06CFA2  14A2: 26c45f64         les bx, ptr es:[bx + 0x64]
  06CFA6  14A6: 2689470c         mov word ptr es:[bx + 0xc], ax
  06CFAA  14AA: 2689570e         mov word ptr es:[bx + 0xe], dx
  06CFAE  14AE: 8b460e           mov ax, word ptr [bp + 0xe]
  06CFB1  14B1: 26894704         mov word ptr es:[bx + 4], ax
  06CFB5  14B5: 8bc3             mov ax, bx
  06CFB7  14B7: 8cc2             mov dx, es
  06CFB9  14B9: c9               leave 
  06CFBA  14BA: cb               retf 

; ---- func_06CFBC  size=43  insns=16  prologue=ENTER 0x0002,0  terminal=RET imm16 ----
  06CFBC  14BC: c8020000         enter 2, 0
  06CFC0  14C0: 8b4e08           mov cx, word ptr [bp + 8]
  06CFC3  14C3: 8b5e0a           mov bx, word ptr [bp + 0xa]
  06CFC6  14C6: 83c174           add cx, 0x74
  06CFC9  14C9: 53               push bx
  06CFCA  14CA: 51               push cx
  06CFCB  14CB: ff7606           push word ptr [bp + 6]
  06CFCE  14CE: ff7604           push word ptr [bp + 4]
  06CFD1  14D1: c45e08           les bx, ptr [bp + 8]
  06CFD4  14D4: 268b4f48         mov cx, word ptr es:[bx + 0x48]
  06CFD8  14D8: 26034f2a         add cx, word ptr es:[bx + 0x2a]
  06CFDC  14DC: 03c1             add ax, cx
  06CFDE  14DE: 2bdb             sub bx, bx
  06CFE0  14E0: e8a5f3           call 0x888
  06CFE3  14E3: c9               leave 
  06CFE4  14E4: c20800           ret 8

; ---- func_06CFE8  size=814  insns=261  prologue=ENTER 0x016A,0  terminal=RET imm16 ----
  06CFE8  14E8: c86a0100         enter 0x16a, 0
  06CFEC  14EC: 50               push ax
  06CFED  14ED: 57               push di
  06CFEE  14EE: 56               push si
  06CFEF  14EF: c45e04           les bx, ptr [bp + 4]
  06CFF2  14F2: 268b4758         mov ax, word ptr es:[bx + 0x58]
  06CFF6  14F6: 268b575a         mov dx, word ptr es:[bx + 0x5a]
  06CFFA  14FA: 8986f4fe         mov word ptr [bp - 0x10c], ax
  06CFFE  14FE: 8996f6fe         mov word ptr [bp - 0x10a], dx
  06D002  1502: 268b4748         mov ax, word ptr es:[bx + 0x48]
  06D006  1506: d1e0             shl ax, 1
  06D008  1508: 262b4728         sub ax, word ptr es:[bx + 0x28]
  06D00C  150C: f7d8             neg ax
  06D00E  150E: 8986f8fe         mov word ptr [bp - 0x108], ax
  06D012  1512: 268b472c         mov ax, word ptr es:[bx + 0x2c]
  06D016  1516: 8986f2fe         mov word ptr [bp - 0x10e], ax
  06D01A  151A: c686fafe00       mov byte ptr [bp - 0x106], 0
  06D01F  151F: 2bc0             sub ax, ax
  06D021  1521: 89869afe         mov word ptr [bp - 0x166], ax
  06D025  1525: 8946fa           mov word ptr [bp - 6], ax
  06D028  1528: 8bc2             mov ax, dx
  06D02A  152A: 0b86f4fe         or ax, word ptr [bp - 0x10c]
  06D02E  152E: 7503             jne 0x1533
  06D030  1530: e98102           jmp 0x17b4
  06D033  1533: c49ef4fe         les bx, ptr [bp - 0x10c]
  06D037  1537: 268b4702         mov ax, word ptr es:[bx + 2]
  06D03B  153B: 268b5704         mov dx, word ptr es:[bx + 4]
  06D03F  153F: 8946fc           mov word ptr [bp - 4], ax
  06D042  1542: 8956fe           mov word ptr [bp - 2], dx
  06D045  1545: 26f60703         test byte ptr es:[bx], 3
  06D049  1549: 7503             jne 0x154e
  06D04B  154B: e93a02           jmp 0x1788
  06D04E  154E: 80befafe00       cmp byte ptr [bp - 0x106], 0
  06D053  1553: 7456             je 0x15ab
  06D055  1555: 83be94fe00       cmp word ptr [bp - 0x16c], 0
  06D05A  155A: 7415             je 0x1571
  06D05C  155C: ff7606           push word ptr [bp + 6]
  06D05F  155F: ff7604           push word ptr [bp + 4]
  06D062  1562: 8d86fafe         lea ax, [bp - 0x106]
  06D066  1566: 16               push ss
  06D067  1567: 50               push ax
  06D068  1568: 2bc0             sub ax, ax
  06D06A  156A: 8b96f2fe         mov dx, word ptr [bp - 0x10e]
  06D06E  156E: e84bff           call 0x14bc
  06D071  1571: c45e04           les bx, ptr [bp + 4]
  06D074  1574: 26ffb78200       push word ptr es:[bx + 0x82]
  06D079  1579: 26ffb78000       push word ptr es:[bx + 0x80]
  06D07E  157E: e8e5fc           call 0x1266
  06D081  1581: 83c404           add sp, 4
  06D084  1584: 40               inc ax
  06D085  1585: 01869afe         add word ptr [bp - 0x166], ax
  06D089  1589: c45e04           les bx, ptr [bp + 4]
  06D08C  158C: 26ffb78200       push word ptr es:[bx + 0x82]
  06D091  1591: 26ffb78000       push word ptr es:[bx + 0x80]
  06D096  1596: e8cdfc           call 0x1266
  06D099  1599: 83c404           add sp, 4
  06D09C  159C: 40               inc ax
  06D09D  159D: 0186f2fe         add word ptr [bp - 0x10e], ax
  06D0A1  15A1: c686fafe00       mov byte ptr [bp - 0x106], 0
  06D0A6  15A6: c746fa0000       mov word ptr [bp - 6], 0
  06D0AB  15AB: 83be94fe00       cmp word ptr [bp - 0x16c], 0
  06D0B0  15B0: 7451             je 0x1603
  06D0B2  15B2: c49ef4fe         les bx, ptr [bp - 0x10c]
  06D0B6  15B6: 26f60701         test byte ptr es:[bx], 1
  06D0BA  15BA: 7424             je 0x15e0
  06D0BC  15BC: 8b4604           mov ax, word ptr [bp + 4]
  06D0BF  15BF: 8b5606           mov dx, word ptr [bp + 6]
  06D0C2  15C2: 057400           add ax, 0x74
  06D0C5  15C5: 52               push dx
  06D0C6  15C6: 50               push ax
  06D0C7  15C7: ff76fe           push word ptr [bp - 2]
  06D0CA  15CA: ff76fc           push word ptr [bp - 4]
  06D0CD  15CD: e806f2           call 0x7d6
  06D0D0  15D0: d1f8             sar ax, 1
  06D0D2  15D2: 8b8ef8fe         mov cx, word ptr [bp - 0x108]
  06D0D6  15D6: d1f9             sar cx, 1
  06D0D8  15D8: 2bc8             sub cx, ax
  06D0DA  15DA: 898e98fe         mov word ptr [bp - 0x168], cx
  06D0DE  15DE: eb06             jmp 0x15e6
  06D0E0  15E0: c78698fe0000     mov word ptr [bp - 0x168], 0
  06D0E6  15E6: ff7606           push word ptr [bp + 6]
  06D0E9  15E9: ff7604           push word ptr [bp + 4]
  06D0EC  15EC: ff76fe           push word ptr [bp - 2]
  06D0EF  15EF: ff76fc           push word ptr [bp - 4]
  06D0F2  15F2: 8b8698fe         mov ax, word ptr [bp - 0x168]
  06D0F6  15F6: 8b96f2fe         mov dx, word ptr [bp - 0x10e]
  06D0FA  15FA: e8bffe           call 0x14bc
  06D0FD  15FD: eb04             jmp 0x1603
  06D0FF  15FF: 90               nop 
  06D100  1600: ff46fc           inc word ptr [bp - 4]
  06D103  1603: c45efc           les bx, ptr [bp - 4]
  06D106  1606: 26803f00         cmp byte ptr es:[bx], 0
  06D10A  160A: 75f4             jne 0x1600
  06D10C  160C: c45e04           les bx, ptr [bp + 4]
  06D10F  160F: 26ffb78200       push word ptr es:[bx + 0x82]
  06D114  1614: 26ffb78000       push word ptr es:[bx + 0x80]
  06D119  1619: e84afc           call 0x1266
  06D11C  161C: 83c404           add sp, 4
  06D11F  161F: 40               inc ax
  06D120  1620: 01869afe         add word ptr [bp - 0x166], ax
  06D124  1624: c45e04           les bx, ptr [bp + 4]
  06D127  1627: 26ffb78200       push word ptr es:[bx + 0x82]
  06D12C  162C: 26ffb78000       push word ptr es:[bx + 0x80]
  06D131  1631: e832fc           call 0x1266
  06D134  1634: 83c404           add sp, 4
  06D137  1637: 40               inc ax
  06D138  1638: 0186f2fe         add word ptr [bp - 0x10e], ax
  06D13C  163C: e94901           jmp 0x1788
  06D13F  163F: 90               nop 
  06D140  1640: ff46fc           inc word ptr [bp - 4]
  06D143  1643: c45efc           les bx, ptr [bp - 4]
  06D146  1646: 26803f20         cmp byte ptr es:[bx], 0x20
  06D14A  164A: 74f4             je 0x1640
  06D14C  164C: 6a20             push 0x20
  06D14E  164E: 06               push es
  06D14F  164F: 53               push bx
  06D150  1650: 9a10101d0d       lcall 0xd1d, 0x1010
  06D155  1655: 83c406           add sp, 6
  06D158  1658: 89869efe         mov word ptr [bp - 0x162], ax
  06D15C  165C: 8996a0fe         mov word ptr [bp - 0x160], dx
  06D160  1660: 0bd0             or dx, ax
  06D162  1662: 7408             je 0x166c
  06D164  1664: c49e9efe         les bx, ptr [bp - 0x162]
  06D168  1668: 26c60700         mov byte ptr es:[bx], 0
  06D16C  166C: ff76fe           push word ptr [bp - 2]
  06D16F  166F: ff76fc           push word ptr [bp - 4]
  06D172  1672: 9a3c111d0d       lcall 0xd1d, 0x113c
  06D177  1677: 83c404           add sp, 4
  06D17A  167A: 898696fe         mov word ptr [bp - 0x16a], ax
  06D17E  167E: c686a2fe00       mov byte ptr [bp - 0x15e], 0
  06D183  1683: 80befafe00       cmp byte ptr [bp - 0x106], 0
  06D188  1688: 7410             je 0x169a
  06D18A  168A: 68991f           push 0x1f99
  06D18D  168D: 8d86a2fe         lea ax, [bp - 0x15e]
  06D191  1691: 50               push ax
  06D192  1692: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06D197  1697: 83c404           add sp, 4
  06D19A  169A: ff76fe           push word ptr [bp - 2]
  06D19D  169D: ff76fc           push word ptr [bp - 4]
  06D1A0  16A0: 8d86a2fe         lea ax, [bp - 0x15e]
  06D1A4  16A4: 16               push ss
  06D1A5  16A5: 50               push ax
  06D1A6  16A6: 9ab4111d0d       lcall 0xd1d, 0x11b4
  06D1AB  16AB: 83c408           add sp, 8
  06D1AE  16AE: 8b4604           mov ax, word ptr [bp + 4]
  06D1B1  16B1: 8b5606           mov dx, word ptr [bp + 6]
  06D1B4  16B4: 057400           add ax, 0x74
  06D1B7  16B7: 52               push dx
  06D1B8  16B8: 50               push ax
  06D1B9  16B9: 8d8ea2fe         lea cx, [bp - 0x15e]
  06D1BD  16BD: 16               push ss
  06D1BE  16BE: 51               push cx
  06D1BF  16BF: 8bf0             mov si, ax
  06D1C1  16C1: 8bfa             mov di, dx
  06D1C3  16C3: e810f1           call 0x7d6
  06D1C6  16C6: 89869cfe         mov word ptr [bp - 0x164], ax
  06D1CA  16CA: 8ec7             mov es, di
  06D1CC  16CC: 268b04           mov ax, word ptr es:[si]
  06D1CF  16CF: 03869cfe         add ax, word ptr [bp - 0x164]
  06D1D3  16D3: 0346fa           add ax, word ptr [bp - 6]
  06D1D6  16D6: 3b86f8fe         cmp ax, word ptr [bp - 0x108]
  06D1DA  16DA: 7e71             jle 0x174d
  06D1DC  16DC: 83be94fe00       cmp word ptr [bp - 0x16c], 0
  06D1E1  16E1: 7415             je 0x16f8
  06D1E3  16E3: ff7606           push word ptr [bp + 6]
  06D1E6  16E6: ff7604           push word ptr [bp + 4]
  06D1E9  16E9: 8d86fafe         lea ax, [bp - 0x106]
  06D1ED  16ED: 16               push ss
  06D1EE  16EE: 50               push ax
  06D1EF  16EF: 2bc0             sub ax, ax
  06D1F1  16F1: 8b96f2fe         mov dx, word ptr [bp - 0x10e]
  06D1F5  16F5: e8c4fd           call 0x14bc
  06D1F8  16F8: c45e04           les bx, ptr [bp + 4]
  06D1FB  16FB: 26ffb78200       push word ptr es:[bx + 0x82]
  06D200  1700: 26ffb78000       push word ptr es:[bx + 0x80]
  06D205  1705: e85efb           call 0x1266
  06D208  1708: 83c404           add sp, 4
  06D20B  170B: 40               inc ax
  06D20C  170C: 01869afe         add word ptr [bp - 0x166], ax
  06D210  1710: c45e04           les bx, ptr [bp + 4]
  06D213  1713: 26ffb78200       push word ptr es:[bx + 0x82]
  06D218  1718: 26ffb78000       push word ptr es:[bx + 0x80]
  06D21D  171D: e846fb           call 0x1266
  06D220  1720: 83c404           add sp, 4
  06D223  1723: 40               inc ax
  06D224  1724: 0186f2fe         add word ptr [bp - 0x10e], ax
  06D228  1728: eb12             jmp 0x173c
  06D22A  172A: 8d86a3fe         lea ax, [bp - 0x15d]
  06D22E  172E: 50               push ax
  06D22F  172F: 8d86a2fe         lea ax, [bp - 0x15e]
  06D233  1733: 50               push ax
  06D234  1734: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06D239  1739: 83c404           add sp, 4
  06D23C  173C: 80bea2fe20       cmp byte ptr [bp - 0x15e], 0x20
  06D241  1741: 74e7             je 0x172a
  06D243  1743: c686fafe00       mov byte ptr [bp - 0x106], 0
  06D248  1748: c746fa0000       mov word ptr [bp - 6], 0
  06D24D  174D: 8d86a2fe         lea ax, [bp - 0x15e]
  06D251  1751: 16               push ss
  06D252  1752: 50               push ax
  06D253  1753: 8d86fafe         lea ax, [bp - 0x106]
  06D257  1757: 16               push ss
  06D258  1758: 50               push ax
  06D259  1759: 9ab4111d0d       lcall 0xd1d, 0x11b4
  06D25E  175E: 83c408           add sp, 8
  06D261  1761: c45e04           les bx, ptr [bp + 4]
  06D264  1764: 268b4774         mov ax, word ptr es:[bx + 0x74]
  06D268  1768: 03869cfe         add ax, word ptr [bp - 0x164]
  06D26C  176C: 0146fa           add word ptr [bp - 6], ax
  06D26F  176F: 8b86a0fe         mov ax, word ptr [bp - 0x160]
  06D273  1773: 0b869efe         or ax, word ptr [bp - 0x162]
  06D277  1777: 7408             je 0x1781
  06D279  1779: c49e9efe         les bx, ptr [bp - 0x162]
  06D27D  177D: 26c60720         mov byte ptr es:[bx], 0x20
  06D281  1781: 8b8696fe         mov ax, word ptr [bp - 0x16a]
  06D285  1785: 0146fc           add word ptr [bp - 4], ax
  06D288  1788: ff76fe           push word ptr [bp - 2]
  06D28B  178B: ff76fc           push word ptr [bp - 4]
  06D28E  178E: 9a3c111d0d       lcall 0xd1d, 0x113c
  06D293  1793: 83c404           add sp, 4
  06D296  1796: 0bc0             or ax, ax
  06D298  1798: 7403             je 0x179d
  06D29A  179A: e9a6fe           jmp 0x1643
  06D29D  179D: c49ef4fe         les bx, ptr [bp - 0x10c]
  06D2A1  17A1: 268b4706         mov ax, word ptr es:[bx + 6]
  06D2A5  17A5: 268b5708         mov dx, word ptr es:[bx + 8]
  06D2A9  17A9: 8986f4fe         mov word ptr [bp - 0x10c], ax
  06D2AD  17AD: 8996f6fe         mov word ptr [bp - 0x10a], dx
  06D2B1  17B1: e974fd           jmp 0x1528
  06D2B4  17B4: 80befafe00       cmp byte ptr [bp - 0x106], 0
  06D2B9  17B9: 7451             je 0x180c
  06D2BB  17BB: 83be94fe00       cmp word ptr [bp - 0x16c], 0
  06D2C0  17C0: 7415             je 0x17d7
  06D2C2  17C2: ff7606           push word ptr [bp + 6]
  06D2C5  17C5: ff7604           push word ptr [bp + 4]
  06D2C8  17C8: 8d86fafe         lea ax, [bp - 0x106]
  06D2CC  17CC: 16               push ss
  06D2CD  17CD: 50               push ax
  06D2CE  17CE: 2bc0             sub ax, ax
  06D2D0  17D0: 8b96f2fe         mov dx, word ptr [bp - 0x10e]
  06D2D4  17D4: e8e5fc           call 0x14bc
  06D2D7  17D7: c45e04           les bx, ptr [bp + 4]
  06D2DA  17DA: 26ffb78200       push word ptr es:[bx + 0x82]
  06D2DF  17DF: 26ffb78000       push word ptr es:[bx + 0x80]
  06D2E4  17E4: e87ffa           call 0x1266
  06D2E7  17E7: 83c404           add sp, 4
  06D2EA  17EA: 40               inc ax
  06D2EB  17EB: 01869afe         add word ptr [bp - 0x166], ax
  06D2EF  17EF: c45e04           les bx, ptr [bp + 4]
  06D2F2  17F2: 26ffb78200       push word ptr es:[bx + 0x82]
  06D2F7  17F7: 26ffb78000       push word ptr es:[bx + 0x80]
  06D2FC  17FC: e867fa           call 0x1266
  06D2FF  17FF: 83c404           add sp, 4
  06D302  1802: 40               inc ax
  06D303  1803: 0186f2fe         add word ptr [bp - 0x10e], ax
  06D307  1807: c686fafe00       mov byte ptr [bp - 0x106], 0
  06D30C  180C: 8b869afe         mov ax, word ptr [bp - 0x166]
  06D310  1810: 5e               pop si
  06D311  1811: 5f               pop di
  06D312  1812: c9               leave 
  06D313  1813: c20400           ret 4

; ---- func_06D316  size=1398  insns=442  prologue=ENTER 0x002C,0  terminal=RET imm16 ----
  06D316  1816: c82c0000         enter 0x2c, 0
  06D31A  181A: 56               push si
  06D31B  181B: c746f80100       mov word ptr [bp - 8], 1
  06D320  1820: 2bc0             sub ax, ax
  06D322  1822: 8946d4           mov word ptr [bp - 0x2c], ax
  06D325  1825: 8946ec           mov word ptr [bp - 0x14], ax
  06D328  1828: 8946e2           mov word ptr [bp - 0x1e], ax
  06D32B  182B: c45e04           les bx, ptr [bp + 4]
  06D32E  182E: 26394708         cmp word ptr es:[bx + 8], ax
  06D332  1832: 7412             je 0x1846
  06D334  1834: 26394702         cmp word ptr es:[bx + 2], ax
  06D338  1838: 740c             je 0x1846
  06D33A  183A: 26894708         mov word ptr es:[bx + 8], ax
  06D33E  183E: 26894762         mov word ptr es:[bx + 0x62], ax
  06D342  1842: 26894760         mov word ptr es:[bx + 0x60], ax
  06D346  1846: c45e04           les bx, ptr [bp + 4]
  06D349  1849: 268b470c         mov ax, word ptr es:[bx + 0xc]
  06D34D  184D: 26894710         mov word ptr es:[bx + 0x10], ax
  06D351  1851: 268b470e         mov ax, word ptr es:[bx + 0xe]
  06D355  1855: 26894712         mov word ptr es:[bx + 0x12], ax
  06D359  1859: 26c747140000     mov word ptr es:[bx + 0x14], 0
  06D35F  185F: 268b474a         mov ax, word ptr es:[bx + 0x4a]
  06D363  1863: d1e0             shl ax, 1
  06D365  1865: 26034746         add ax, word ptr es:[bx + 0x46]
  06D369  1869: 26894716         mov word ptr es:[bx + 0x16], ax
  06D36D  186D: 268a470a         mov al, byte ptr es:[bx + 0xa]
  06D371  1871: 251000           and ax, 0x10
  06D374  1874: 3d0100           cmp ax, 1
  06D377  1877: 1bc0             sbb ax, ax
  06D379  1879: 250300           and ax, 3
  06D37C  187C: 2689472a         mov word ptr es:[bx + 0x2a], ax
  06D380  1880: 8bc8             mov cx, ax
  06D382  1882: 26034746         add ax, word ptr es:[bx + 0x46]
  06D386  1886: 2689472c         mov word ptr es:[bx + 0x2c], ax
  06D38A  188A: 26894f24         mov word ptr es:[bx + 0x24], cx
  06D38E  188E: 26894726         mov word ptr es:[bx + 0x26], ax
  06D392  1892: 268b4728         mov ax, word ptr es:[bx + 0x28]
  06D396  1896: 263b4720         cmp ax, word ptr es:[bx + 0x20]
  06D39A  189A: 7d04             jge 0x18a0
  06D39C  189C: 268b4720         mov ax, word ptr es:[bx + 0x20]
  06D3A0  18A0: 263b4734         cmp ax, word ptr es:[bx + 0x34]
  06D3A4  18A4: 7d04             jge 0x18aa
  06D3A6  18A6: 268b4734         mov ax, word ptr es:[bx + 0x34]
  06D3AA  18AA: 26894728         mov word ptr es:[bx + 0x28], ax
  06D3AE  18AE: 26894734         mov word ptr es:[bx + 0x34], ax
  06D3B2  18B2: 26894720         mov word ptr es:[bx + 0x20], ax
  06D3B6  18B6: 268b4702         mov ax, word ptr es:[bx + 2]
  06D3BA  18BA: 26034704         add ax, word ptr es:[bx + 4]
  06D3BE  18BE: 26034706         add ax, word ptr es:[bx + 6]
  06D3C2  18C2: 26034708         add ax, word ptr es:[bx + 8]
  06D3C6  18C6: 7503             jne 0x18cb
  06D3C8  18C8: e9b904           jmp 0x1d84
  06D3CB  18CB: c746fa0000       mov word ptr [bp - 6], 0
  06D3D0  18D0: c45e04           les bx, ptr [bp + 4]
  06D3D3  18D3: 268b475e         mov ax, word ptr es:[bx + 0x5e]
  06D3D7  18D7: 260b475c         or ax, word ptr es:[bx + 0x5c]
  06D3DB  18DB: 7449             je 0x1926
  06D3DD  18DD: 268b4748         mov ax, word ptr es:[bx + 0x48]
  06D3E1  18E1: 2603472e         add ax, word ptr es:[bx + 0x2e]
  06D3E5  18E5: 26034730         add ax, word ptr es:[bx + 0x30]
  06D3E9  18E9: 26034732         add ax, word ptr es:[bx + 0x32]
  06D3ED  18ED: 26014714         add word ptr es:[bx + 0x14], ax
  06D3F1  18F1: 2601472a         add word ptr es:[bx + 0x2a], ax
  06D3F5  18F5: 26014724         add word ptr es:[bx + 0x24], ax
  06D3F9  18F9: 26014736         add word ptr es:[bx + 0x36], ax
  06D3FD  18FD: 268b475c         mov ax, word ptr es:[bx + 0x5c]
  06D401  1901: 268b575e         mov dx, word ptr es:[bx + 0x5e]
  06D405  1905: 8946ee           mov word ptr [bp - 0x12], ax
  06D408  1908: 8956f0           mov word ptr [bp - 0x10], dx
  06D40B  190B: 8bc2             mov ax, dx
  06D40D  190D: 0b46ee           or ax, word ptr [bp - 0x12]
  06D410  1910: 7414             je 0x1926
  06D412  1912: c45eee           les bx, ptr [bp - 0x12]
  06D415  1915: 268b4702         mov ax, word ptr es:[bx + 2]
  06D419  1919: 8946fa           mov word ptr [bp - 6], ax
  06D41C  191C: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06D420  1920: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06D424  1924: ebdf             jmp 0x1905
  06D426  1926: c45e04           les bx, ptr [bp + 4]
  06D429  1929: 268b475a         mov ax, word ptr es:[bx + 0x5a]
  06D42D  192D: 260b4758         or ax, word ptr es:[bx + 0x58]
  06D431  1931: 7421             je 0x1954
  06D433  1933: 06               push es
  06D434  1934: 53               push bx
  06D435  1935: 2bc0             sub ax, ax
  06D437  1937: e8aefb           call 0x14e8
  06D43A  193A: 8946d4           mov word ptr [bp - 0x2c], ax
  06D43D  193D: c45e04           les bx, ptr [bp + 4]
  06D440  1940: 268b4746         mov ax, word ptr es:[bx + 0x46]
  06D444  1944: 8bc8             mov cx, ax
  06D446  1946: 0346d4           add ax, word ptr [bp - 0x2c]
  06D449  1949: 26014726         add word ptr es:[bx + 0x26], ax
  06D44D  194D: 034ed4           add cx, word ptr [bp - 0x2c]
  06D450  1950: 26014f38         add word ptr es:[bx + 0x38], cx
  06D454  1954: c45e04           les bx, ptr [bp + 4]
  06D457  1957: 268b4756         mov ax, word ptr es:[bx + 0x56]
  06D45B  195B: 260b4754         or ax, word ptr es:[bx + 0x54]
  06D45F  195F: 741e             je 0x197f
  06D461  1961: 26ffb78200       push word ptr es:[bx + 0x82]
  06D466  1966: 26ffb78000       push word ptr es:[bx + 0x80]
  06D46B  196B: e8f8f8           call 0x1266
  06D46E  196E: 83c404           add sp, 4
  06D471  1971: c45e04           les bx, ptr [bp + 4]
  06D474  1974: 26034746         add ax, word ptr es:[bx + 0x46]
  06D478  1978: 26f76f02         imul word ptr es:[bx + 2]
  06D47C  197C: 8946ec           mov word ptr [bp - 0x14], ax
  06D47F  197F: 268b4762         mov ax, word ptr es:[bx + 0x62]
  06D483  1983: 260b4760         or ax, word ptr es:[bx + 0x60]
  06D487  1987: 7421             je 0x19aa
  06D489  1989: 26ffb78200       push word ptr es:[bx + 0x82]
  06D48E  198E: 26ffb78000       push word ptr es:[bx + 0x80]
  06D493  1993: e8d0f8           call 0x1266
  06D496  1996: 83c404           add sp, 4
  06D499  1999: c45e04           les bx, ptr [bp + 4]
  06D49C  199C: 26034746         add ax, word ptr es:[bx + 0x46]
  06D4A0  19A0: 050500           add ax, 5
  06D4A3  19A3: 26f76f08         imul word ptr es:[bx + 8]
  06D4A7  19A7: 8946e2           mov word ptr [bp - 0x1e], ax
  06D4AA  19AA: 8b46e2           mov ax, word ptr [bp - 0x1e]
  06D4AD  19AD: 0346ec           add ax, word ptr [bp - 0x14]
  06D4B0  19B0: 0346d4           add ax, word ptr [bp - 0x2c]
  06D4B3  19B3: 8946f2           mov word ptr [bp - 0xe], ax
  06D4B6  19B6: 0bc0             or ax, ax
  06D4B8  19B8: 7407             je 0x19c1
  06D4BA  19BA: 26034746         add ax, word ptr es:[bx + 0x46]
  06D4BE  19BE: 8946f2           mov word ptr [bp - 0xe], ax
  06D4C1  19C1: 268a470a         mov al, byte ptr es:[bx + 0xa]
  06D4C5  19C5: 251000           and ax, 0x10
  06D4C8  19C8: 3d0100           cmp ax, 1
  06D4CB  19CB: 1bc0             sbb ax, ax
  06D4CD  19CD: 250300           and ax, 3
  06D4D0  19D0: d1e0             shl ax, 1
  06D4D2  19D2: 8b4efa           mov cx, word ptr [bp - 6]
  06D4D5  19D5: 3b4ef2           cmp cx, word ptr [bp - 0xe]
  06D4D8  19D8: 7d03             jge 0x19dd
  06D4DA  19DA: 8b4ef2           mov cx, word ptr [bp - 0xe]
  06D4DD  19DD: 8bd0             mov dx, ax
  06D4DF  19DF: 03c1             add ax, cx
  06D4E1  19E1: 26014716         add word ptr es:[bx + 0x16], ax
  06D4E5  19E5: 26035720         add dx, word ptr es:[bx + 0x20]
  06D4E9  19E9: 26015714         add word ptr es:[bx + 0x14], dx
  06D4ED  19ED: 833e661f00       cmp word ptr [0x1f66], 0
  06D4F2  19F2: 7424             je 0x1a18
  06D4F4  19F4: a19e08           mov ax, word ptr [0x89e]
  06D4F7  19F7: 8b16a008         mov dx, word ptr [0x8a0]
  06D4FB  19FB: 2639878000       cmp word ptr es:[bx + 0x80], ax
  06D500  1A00: 750e             jne 0x1a10
  06D502  1A02: 2639978200       cmp word ptr es:[bx + 0x82], dx
  06D507  1A07: 7507             jne 0x1a10
  06D509  1A09: 2683471606       add word ptr es:[bx + 0x16], 6
  06D50E  1A0E: eb08             jmp 0x1a18
  06D510  1A10: c45e04           les bx, ptr [bp + 4]
  06D513  1A13: 2683471603       add word ptr es:[bx + 0x16], 3
  06D518  1A18: c45e04           les bx, ptr [bp + 4]
  06D51B  1A1B: 26837f10ff       cmp word ptr es:[bx + 0x10], -1
  06D520  1A20: 750f             jne 0x1a31
  06D522  1A22: 268b4714         mov ax, word ptr es:[bx + 0x14]
  06D526  1A26: d1f8             sar ax, 1
  06D528  1A28: 2da000           sub ax, 0xa0
  06D52B  1A2B: f7d8             neg ax
  06D52D  1A2D: 26894710         mov word ptr es:[bx + 0x10], ax
  06D531  1A31: c45e04           les bx, ptr [bp + 4]
  06D534  1A34: 26837f12ff       cmp word ptr es:[bx + 0x12], -1
  06D539  1A39: 750f             jne 0x1a4a
  06D53B  1A3B: 268b4716         mov ax, word ptr es:[bx + 0x16]
  06D53F  1A3F: d1f8             sar ax, 1
  06D541  1A41: 2d6400           sub ax, 0x64
  06D544  1A44: f7d8             neg ax
  06D546  1A46: 26894712         mov word ptr es:[bx + 0x12], ax
  06D54A  1A4A: c45e04           les bx, ptr [bp + 4]
  06D54D  1A4D: 268b4716         mov ax, word ptr es:[bx + 0x16]
  06D551  1A51: 26034712         add ax, word ptr es:[bx + 0x12]
  06D555  1A55: 8946de           mov word ptr [bp - 0x22], ax
  06D558  1A58: 268b4714         mov ax, word ptr es:[bx + 0x14]
  06D55C  1A5C: 26034710         add ax, word ptr es:[bx + 0x10]
  06D560  1A60: 8946e4           mov word ptr [bp - 0x1c], ax
  06D563  1A63: 3d4001           cmp ax, 0x140
  06D566  1A66: 7e09             jle 0x1a71
  06D568  1A68: 2d4001           sub ax, 0x140
  06D56B  1A6B: f7d8             neg ax
  06D56D  1A6D: 26014710         add word ptr es:[bx + 0x10], ax
  06D571  1A71: 817edec800       cmp word ptr [bp - 0x22], 0xc8
  06D576  1A76: 7e0d             jle 0x1a85
  06D578  1A78: b8c800           mov ax, 0xc8
  06D57B  1A7B: 2b46de           sub ax, word ptr [bp - 0x22]
  06D57E  1A7E: c45e04           les bx, ptr [bp + 4]
  06D581  1A81: 26014712         add word ptr es:[bx + 0x12], ax
  06D585  1A85: c45e04           les bx, ptr [bp + 4]
  06D588  1A88: 26837f1000       cmp word ptr es:[bx + 0x10], 0
  06D58D  1A8D: 7c07             jl 0x1a96
  06D58F  1A8F: 26837f1200       cmp word ptr es:[bx + 0x12], 0
  06D594  1A94: 7d1c             jge 0x1ab2
  06D596  1A96: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06D59A  1A9A: 99               cdq 
  06D59B  1A9B: 52               push dx
  06D59C  1A9C: 50               push ax
  06D59D  1A9D: 268b4712         mov ax, word ptr es:[bx + 0x12]
  06D5A1  1AA1: 99               cdq 
  06D5A2  1AA2: 52               push dx
  06D5A3  1AA3: 50               push ax
  06D5A4  1AA4: b8afff           mov ax, 0xffaf
  06D5A7  1AA7: ba0200           mov dx, 2
  06D5AA  1AAA: bb2900           mov bx, 0x29
  06D5AD  1AAD: 9a72071f18       lcall 0x181f, 0x772
  06D5B2  1AB2: c45e04           les bx, ptr [bp + 4]
  06D5B5  1AB5: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06D5B9  1AB9: 26894718         mov word ptr es:[bx + 0x18], ax
  06D5BD  1ABD: 268b4712         mov ax, word ptr es:[bx + 0x12]
  06D5C1  1AC1: 2689471a         mov word ptr es:[bx + 0x1a], ax
  06D5C5  1AC5: 268b4714         mov ax, word ptr es:[bx + 0x14]
  06D5C9  1AC9: 2689471c         mov word ptr es:[bx + 0x1c], ax
  06D5CD  1ACD: 268b4f16         mov cx, word ptr es:[bx + 0x16]
  06D5D1  1AD1: 26894f1e         mov word ptr es:[bx + 0x1e], cx
  06D5D5  1AD5: 268b4f6a         mov cx, word ptr es:[bx + 0x6a]
  06D5D9  1AD9: 260b4f68         or cx, word ptr es:[bx + 0x68]
  06D5DD  1ADD: 7503             jne 0x1ae2
  06D5DF  1ADF: e97a02           jmp 0x1d5c
  06D5E2  1AE2: 268b4f68         mov cx, word ptr es:[bx + 0x68]
  06D5E6  1AE6: 268b576a         mov dx, word ptr es:[bx + 0x6a]
  06D5EA  1AEA: 894eee           mov word ptr [bp - 0x12], cx
  06D5ED  1AED: 8956f0           mov word ptr [bp - 0x10], dx
  06D5F0  1AF0: 833e5c1f00       cmp word ptr [0x1f5c], 0
  06D5F5  1AF5: 7d03             jge 0x1afa
  06D5F7  1AF7: e9f300           jmp 0x1bed
  06D5FA  1AFA: 8ec2             mov es, dx
  06D5FC  1AFC: 8bd9             mov bx, cx
  06D5FE  1AFE: 26c45f0c         les bx, ptr es:[bx + 0xc]
  06D602  1B02: 268b4f4c         mov cx, word ptr es:[bx + 0x4c]
  06D606  1B06: 83c103           add cx, 3
  06D609  1B09: 894eda           mov word ptr [bp - 0x26], cx
  06D60C  1B0C: c746e8fdff       mov word ptr [bp - 0x18], 0xfffd
  06D611  1B11: 268b4f4a         mov cx, word ptr es:[bx + 0x4a]
  06D615  1B15: 83c103           add cx, 3
  06D618  1B18: 894ee0           mov word ptr [bp - 0x20], cx
  06D61B  1B1B: 03c1             add ax, cx
  06D61D  1B1D: 050300           add ax, 3
  06D620  1B20: 8946d8           mov word ptr [bp - 0x28], ax
  06D623  1B23: 3d4001           cmp ax, 0x140
  06D626  1B26: 7e0b             jle 0x1b33
  06D628  1B28: 2d4301           sub ax, 0x143
  06D62B  1B2B: 8946e8           mov word ptr [bp - 0x18], ax
  06D62E  1B2E: c746d84001       mov word ptr [bp - 0x28], 0x140
  06D633  1B33: 833e5c1f00       cmp word ptr [0x1f5c], 0
  06D638  1B38: 741c             je 0x1b56
  06D63A  1B3A: 833e5c1f03       cmp word ptr [0x1f5c], 3
  06D63F  1B3F: 7415             je 0x1b56
  06D641  1B41: 833e5c1f05       cmp word ptr [0x1f5c], 5
  06D646  1B46: 740e             je 0x1b56
  06D648  1B48: 833e5c1f07       cmp word ptr [0x1f5c], 7
  06D64D  1B4D: 7407             je 0x1b56
  06D64F  1B4F: 833e5c1f08       cmp word ptr [0x1f5c], 8
  06D654  1B54: 7508             jne 0x1b5e
  06D656  1B56: c746dc0100       mov word ptr [bp - 0x24], 1
  06D65B  1B5B: eb06             jmp 0x1b63
  06D65D  1B5D: 90               nop 
  06D65E  1B5E: c746dc0000       mov word ptr [bp - 0x24], 0
  06D663  1B63: 8b46d8           mov ax, word ptr [bp - 0x28]
  06D666  1B66: c45e04           les bx, ptr [bp + 4]
  06D669  1B69: 2689471c         mov word ptr es:[bx + 0x1c], ax
  06D66D  1B6D: 837edc00         cmp word ptr [bp - 0x24], 0
  06D671  1B71: 7421             je 0x1b94
  06D673  1B73: d1f8             sar ax, 1
  06D675  1B75: 2da000           sub ax, 0xa0
  06D678  1B78: f7d8             neg ax
  06D67A  1B7A: 26894718         mov word ptr es:[bx + 0x18], ax
  06D67E  1B7E: c476ee           les si, ptr [bp - 0x12]
  06D681  1B81: 26894404         mov word ptr es:[si + 4], ax
  06D685  1B85: 2b46e8           sub ax, word ptr [bp - 0x18]
  06D688  1B88: 0346e0           add ax, word ptr [bp - 0x20]
  06D68B  1B8B: c45e04           les bx, ptr [bp + 4]
  06D68E  1B8E: 26894710         mov word ptr es:[bx + 0x10], ax
  06D692  1B92: eb23             jmp 0x1bb7
  06D694  1B94: 8b46d8           mov ax, word ptr [bp - 0x28]
  06D697  1B97: d1f8             sar ax, 1
  06D699  1B99: 2da000           sub ax, 0xa0
  06D69C  1B9C: f7d8             neg ax
  06D69E  1B9E: c45e04           les bx, ptr [bp + 4]
  06D6A1  1BA1: 26894718         mov word ptr es:[bx + 0x18], ax
  06D6A5  1BA5: 26894710         mov word ptr es:[bx + 0x10], ax
  06D6A9  1BA9: 26034714         add ax, word ptr es:[bx + 0x14]
  06D6AD  1BAD: 2b46e8           sub ax, word ptr [bp - 0x18]
  06D6B0  1BB0: c45eee           les bx, ptr [bp - 0x12]
  06D6B3  1BB3: 26894704         mov word ptr es:[bx + 4], ax
  06D6B7  1BB7: 8b46da           mov ax, word ptr [bp - 0x26]
  06D6BA  1BBA: d1f8             sar ax, 1
  06D6BC  1BBC: 2d6400           sub ax, 0x64
  06D6BF  1BBF: f7d8             neg ax
  06D6C1  1BC1: c45eee           les bx, ptr [bp - 0x12]
  06D6C4  1BC4: 268907           mov word ptr es:[bx], ax
  06D6C7  1BC7: c45e04           les bx, ptr [bp + 4]
  06D6CA  1BCA: 8bc8             mov cx, ax
  06D6CC  1BCC: 263b4712         cmp ax, word ptr es:[bx + 0x12]
  06D6D0  1BD0: 7e04             jle 0x1bd6
  06D6D2  1BD2: 268b4712         mov ax, word ptr es:[bx + 0x12]
  06D6D6  1BD6: 2689471a         mov word ptr es:[bx + 0x1a], ax
  06D6DA  1BDA: 034eda           add cx, word ptr [bp - 0x26]
  06D6DD  1BDD: 49               dec cx
  06D6DE  1BDE: 3b4ede           cmp cx, word ptr [bp - 0x22]
  06D6E1  1BE1: 7d03             jge 0x1be6
  06D6E3  1BE3: 8b4ede           mov cx, word ptr [bp - 0x22]
  06D6E6  1BE6: 2bc8             sub cx, ax
  06D6E8  1BE8: 41               inc cx
  06D6E9  1BE9: 26894f1e         mov word ptr es:[bx + 0x1e], cx
  06D6ED  1BED: 833e5e1f00       cmp word ptr [0x1f5e], 0
  06D6F2  1BF2: 7d0a             jge 0x1bfe
  06D6F4  1BF4: 833e601f00       cmp word ptr [0x1f60], 0
  06D6F9  1BF9: 7d03             jge 0x1bfe
  06D6FB  1BFB: e95e01           jmp 0x1d5c
  06D6FE  1BFE: c45eee           les bx, ptr [bp - 0x12]
  06D701  1C01: 26c45f0c         les bx, ptr es:[bx + 0xc]
  06D705  1C05: 268b474a         mov ax, word ptr es:[bx + 0x4a]
  06D709  1C09: 8946e0           mov word ptr [bp - 0x20], ax
  06D70C  1C0C: 268b474c         mov ax, word ptr es:[bx + 0x4c]
  06D710  1C10: 8946da           mov word ptr [bp - 0x26], ax
  06D713  1C13: 268b4f10         mov cx, word ptr es:[bx + 0x10]
  06D717  1C17: 894ef6           mov word ptr [bp - 0xa], cx
  06D71A  1C1A: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06D71E  1C1E: 8956f4           mov word ptr [bp - 0xc], dx
  06D721  1C21: 268b5714         mov dx, word ptr es:[bx + 0x14]
  06D725  1C25: 8956fc           mov word ptr [bp - 4], dx
  06D728  1C28: 3bc8             cmp cx, ax
  06D72A  1C2A: 7e02             jle 0x1c2e
  06D72C  1C2C: 8bc8             mov cx, ax
  06D72E  1C2E: 2bc1             sub ax, cx
  06D730  1C30: c45e04           les bx, ptr [bp + 4]
  06D733  1C33: 26034716         add ax, word ptr es:[bx + 0x16]
  06D737  1C37: 8946d6           mov word ptr [bp - 0x2a], ax
  06D73A  1C3A: 3dc800           cmp ax, 0xc8
  06D73D  1C3D: 7c09             jl 0x1c48
  06D73F  1C3F: 26804f0a40       or byte ptr es:[bx + 0xa], 0x40
  06D744  1C44: e91501           jmp 0x1d5c
  06D747  1C47: 90               nop 
  06D748  1C48: d1f8             sar ax, 1
  06D74A  1C4A: 2d6400           sub ax, 0x64
  06D74D  1C4D: f7d8             neg ax
  06D74F  1C4F: c45eee           les bx, ptr [bp - 0x12]
  06D752  1C52: 268907           mov word ptr es:[bx], ax
  06D755  1C55: c45e04           les bx, ptr [bp + 4]
  06D758  1C58: 2689471a         mov word ptr es:[bx + 0x1a], ax
  06D75C  1C5C: 8b4ed6           mov cx, word ptr [bp - 0x2a]
  06D75F  1C5F: 3b4eda           cmp cx, word ptr [bp - 0x26]
  06D762  1C62: 7d03             jge 0x1c67
  06D764  1C64: 8b4eda           mov cx, word ptr [bp - 0x26]
  06D767  1C67: 26894f1e         mov word ptr es:[bx + 0x1e], cx
  06D76B  1C6B: 2b46f6           sub ax, word ptr [bp - 0xa]
  06D76E  1C6E: 0346da           add ax, word ptr [bp - 0x26]
  06D771  1C71: 26894712         mov word ptr es:[bx + 0x12], ax
  06D775  1C75: 8b46f4           mov ax, word ptr [bp - 0xc]
  06D778  1C78: e9d100           jmp 0x1d4c
  06D77B  1C7B: 90               nop 
  06D77C  1C7C: c45e04           les bx, ptr [bp + 4]
  06D77F  1C7F: 268b4714         mov ax, word ptr es:[bx + 0x14]
  06D783  1C83: 2b46fc           sub ax, word ptr [bp - 4]
  06D786  1C86: 0346e0           add ax, word ptr [bp - 0x20]
  06D789  1C89: 8946d8           mov word ptr [bp - 0x28], ax
  06D78C  1C8C: 3d4001           cmp ax, 0x140
  06D78F  1C8F: 7e0b             jle 0x1c9c
  06D791  1C91: 2d4001           sub ax, 0x140
  06D794  1C94: 0146fc           add word ptr [bp - 4], ax
  06D797  1C97: c746d84001       mov word ptr [bp - 0x28], 0x140
  06D79C  1C9C: 8b46d8           mov ax, word ptr [bp - 0x28]
  06D79F  1C9F: d1f8             sar ax, 1
  06D7A1  1CA1: 2da000           sub ax, 0xa0
  06D7A4  1CA4: f7d8             neg ax
  06D7A6  1CA6: c45eee           les bx, ptr [bp - 0x12]
  06D7A9  1CA9: 26894704         mov word ptr es:[bx + 4], ax
  06D7AD  1CAD: c45e04           les bx, ptr [bp + 4]
  06D7B0  1CB0: 26894718         mov word ptr es:[bx + 0x18], ax
  06D7B4  1CB4: 8b4ed8           mov cx, word ptr [bp - 0x28]
  06D7B7  1CB7: 26894f1c         mov word ptr es:[bx + 0x1c], cx
  06D7BB  1CBB: 2b46fc           sub ax, word ptr [bp - 4]
  06D7BE  1CBE: 0346e0           add ax, word ptr [bp - 0x20]
  06D7C1  1CC1: 26894710         mov word ptr es:[bx + 0x10], ax
  06D7C5  1CC5: e99400           jmp 0x1d5c
  06D7C8  1CC8: 8b46e0           mov ax, word ptr [bp - 0x20]
  06D7CB  1CCB: d1f8             sar ax, 1
  06D7CD  1CCD: 2da000           sub ax, 0xa0
  06D7D0  1CD0: f7d8             neg ax
  06D7D2  1CD2: c45eee           les bx, ptr [bp - 0x12]
  06D7D5  1CD5: 26894704         mov word ptr es:[bx + 4], ax
  06D7D9  1CD9: c45e04           les bx, ptr [bp + 4]
  06D7DC  1CDC: 268b4f10         mov cx, word ptr es:[bx + 0x10]
  06D7E0  1CE0: 3bc8             cmp cx, ax
  06D7E2  1CE2: 7e02             jle 0x1ce6
  06D7E4  1CE4: 8bc8             mov cx, ax
  06D7E6  1CE6: 26894f18         mov word ptr es:[bx + 0x18], cx
  06D7EA  1CEA: 0346e0           add ax, word ptr [bp - 0x20]
  06D7ED  1CED: 48               dec ax
  06D7EE  1CEE: 3b46e4           cmp ax, word ptr [bp - 0x1c]
  06D7F1  1CF1: 7d03             jge 0x1cf6
  06D7F3  1CF3: 8b46e4           mov ax, word ptr [bp - 0x1c]
  06D7F6  1CF6: 8946e4           mov word ptr [bp - 0x1c], ax
  06D7F9  1CF9: 2bc1             sub ax, cx
  06D7FB  1CFB: 40               inc ax
  06D7FC  1CFC: 2689471c         mov word ptr es:[bx + 0x1c], ax
  06D800  1D00: eb5a             jmp 0x1d5c
  06D802  1D02: c45e04           les bx, ptr [bp + 4]
  06D805  1D05: 268b4714         mov ax, word ptr es:[bx + 0x14]
  06D809  1D09: 2b46fc           sub ax, word ptr [bp - 4]
  06D80C  1D0C: 0346e0           add ax, word ptr [bp - 0x20]
  06D80F  1D0F: 8946d8           mov word ptr [bp - 0x28], ax
  06D812  1D12: 3d4001           cmp ax, 0x140
  06D815  1D15: 7e0b             jle 0x1d22
  06D817  1D17: 2d4001           sub ax, 0x140
  06D81A  1D1A: 0146fc           add word ptr [bp - 4], ax
  06D81D  1D1D: c746d84001       mov word ptr [bp - 0x28], 0x140
  06D822  1D22: 8b46d8           mov ax, word ptr [bp - 0x28]
  06D825  1D25: d1f8             sar ax, 1
  06D827  1D27: 2da000           sub ax, 0xa0
  06D82A  1D2A: f7d8             neg ax
  06D82C  1D2C: 26894710         mov word ptr es:[bx + 0x10], ax
  06D830  1D30: 26894718         mov word ptr es:[bx + 0x18], ax
  06D834  1D34: 8b4ed8           mov cx, word ptr [bp - 0x28]
  06D837  1D37: 26894f1c         mov word ptr es:[bx + 0x1c], cx
  06D83B  1D3B: 26034714         add ax, word ptr es:[bx + 0x14]
  06D83F  1D3F: 2b46fc           sub ax, word ptr [bp - 4]
  06D842  1D42: c45eee           les bx, ptr [bp - 0x12]
  06D845  1D45: 26894704         mov word ptr es:[bx + 4], ax
  06D849  1D49: eb11             jmp 0x1d5c
  06D84B  1D4B: 90               nop 
  06D84C  1D4C: 0bc0             or ax, ax
  06D84E  1D4E: 7503             jne 0x1d53
  06D850  1D50: e929ff           jmp 0x1c7c
  06D853  1D53: 48               dec ax
  06D854  1D54: 7503             jne 0x1d59
  06D856  1D56: e96fff           jmp 0x1cc8
  06D859  1D59: 48               dec ax
  06D85A  1D5A: 74a6             je 0x1d02
  06D85C  1D5C: c45e04           les bx, ptr [bp + 4]
  06D85F  1D5F: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06D863  1D63: 26014724         add word ptr es:[bx + 0x24], ax
  06D867  1D67: 268b4f12         mov cx, word ptr es:[bx + 0x12]
  06D86B  1D6B: 26014f26         add word ptr es:[bx + 0x26], cx
  06D86F  1D6F: 2601472a         add word ptr es:[bx + 0x2a], ax
  06D873  1D73: 26014f2c         add word ptr es:[bx + 0x2c], cx
  06D877  1D77: 26014736         add word ptr es:[bx + 0x36], ax
  06D87B  1D7B: 26014f38         add word ptr es:[bx + 0x38], cx
  06D87F  1D7F: c746f80000       mov word ptr [bp - 8], 0
  06D884  1D84: 8b46f8           mov ax, word ptr [bp - 8]
  06D887  1D87: 5e               pop si
  06D888  1D88: c9               leave 
  06D889  1D89: c20400           ret 4

; ---- func_06D88C  size=59  insns=20  prologue=push bp;mov bp,sp  terminal=RET imm16 ----
  06D88C  1D8C: 55               push bp
  06D88D  1D8D: 8bec             mov bp, sp
  06D88F  1D8F: 56               push si
  06D890  1D90: 833e6a1f00       cmp word ptr [0x1f6a], 0
  06D895  1D95: 740a             je 0x1da1
  06D897  1D97: c45e04           les bx, ptr [bp + 4]
  06D89A  1D9A: 26f6470a20       test byte ptr es:[bx + 0xa], 0x20
  06D89F  1D9F: 7521             jne 0x1dc2
  06D8A1  1DA1: c45e04           les bx, ptr [bp + 4]
  06D8A4  1DA4: 26ff771a         push word ptr es:[bx + 0x1a]
  06D8A8  1DA8: 26ff771c         push word ptr es:[bx + 0x1c]
  06D8AC  1DAC: 26ff771e         push word ptr es:[bx + 0x1e]
  06D8B0  1DB0: 268b4718         mov ax, word ptr es:[bx + 0x18]
  06D8B4  1DB4: 8bd8             mov bx, ax
  06D8B6  1DB6: 8b7604           mov si, word ptr [bp + 4]
  06D8B9  1DB9: 268b541a         mov dx, word ptr es:[si + 0x1a]
  06D8BD  1DBD: 9ae2001f18       lcall 0x181f, 0xe2
  06D8C2  1DC2: 5e               pop si
  06D8C3  1DC3: c9               leave 
  06D8C4  1DC4: c20400           ret 4

; ---- func_06D8C8  size=112  insns=39  prologue=ENTER 0x0054,0  terminal=RETF ----
  06D8C8  1DC8: c8540000         enter 0x54, 0
  06D8CC  1DCC: 833e661f00       cmp word ptr [0x1f66], 0
  06D8D1  1DD1: 7463             je 0x1e36
  06D8D3  1DD3: c45e06           les bx, ptr [bp + 6]
  06D8D6  1DD6: 268b4714         mov ax, word ptr es:[bx + 0x14]
  06D8DA  1DDA: 26034710         add ax, word ptr es:[bx + 0x10]
  06D8DE  1DDE: 48               dec ax
  06D8DF  1DDF: 48               dec ax
  06D8E0  1DE0: 8946fe           mov word ptr [bp - 2], ax
  06D8E3  1DE3: 268b4716         mov ax, word ptr es:[bx + 0x16]
  06D8E7  1DE7: 26034712         add ax, word ptr es:[bx + 0x12]
  06D8EB  1DEB: 2d0700           sub ax, 7
  06D8EE  1DEE: 8946ac           mov word ptr [bp - 0x54], ax
  06D8F1  1DF1: 8b0e9e08         mov cx, word ptr [0x89e]
  06D8F5  1DF5: 8b16a008         mov dx, word ptr [0x8a0]
  06D8F9  1DF9: 26398f8000       cmp word ptr es:[bx + 0x80], cx
  06D8FE  1DFE: 750c             jne 0x1e0c
  06D900  1E00: 2639978200       cmp word ptr es:[bx + 0x82], dx
  06D905  1E05: 7505             jne 0x1e0c
  06D907  1E07: 48               dec ax
  06D908  1E08: 48               dec ax
  06D909  1E09: 8946ac           mov word ptr [bp - 0x54], ax
  06D90C  1E0C: c646ae00         mov byte ptr [bp - 0x52], 0
  06D910  1E10: ff36342f         push word ptr [0x2f34]
  06D914  1E14: 8d46ae           lea ax, [bp - 0x52]
  06D917  1E17: 50               push ax
  06D918  1E18: 9a6e011f18       lcall 0x181f, 0x16e
  06D91D  1E1D: 83c404           add sp, 4
  06D920  1E20: a03108           mov al, byte ptr [0x831]
  06D923  1E23: 2ae4             sub ah, ah
  06D925  1E25: 50               push ax
  06D926  1E26: ff76ac           push word ptr [bp - 0x54]
  06D929  1E29: ff76fe           push word ptr [bp - 2]
  06D92C  1E2C: 8d46ae           lea ax, [bp - 0x52]
  06D92F  1E2F: 16               push ss
  06D930  1E30: 50               push ax
  06D931  1E31: 9a50011f18       lcall 0x181f, 0x150
  06D936  1E36: c9               leave 
  06D937  1E37: cb               retf 

; ---- func_06D938  size=148  insns=47  prologue=ENTER 0x000C,0  terminal=RETF ----
  06D938  1E38: c80c0000         enter 0xc, 0
  06D93C  1E3C: 56               push si
  06D93D  1E3D: 833e5c1f07       cmp word ptr [0x1f5c], 7
  06D942  1E42: 7e06             jle 0x1e4a
  06D944  1E44: b80100           mov ax, 1
  06D947  1E47: eb03             jmp 0x1e4c
  06D949  1E49: 90               nop 
  06D94A  1E4A: 2bc0             sub ax, ax
  06D94C  1E4C: 8946fa           mov word ptr [bp - 6], ax
  06D94F  1E4F: c45e06           les bx, ptr [bp + 6]
  06D952  1E52: 268b476a         mov ax, word ptr es:[bx + 0x6a]
  06D956  1E56: 260b4768         or ax, word ptr es:[bx + 0x68]
  06D95A  1E5A: 746d             je 0x1ec9
  06D95C  1E5C: 26f6470a40       test byte ptr es:[bx + 0xa], 0x40
  06D961  1E61: 7566             jne 0x1ec9
  06D963  1E63: 268b4768         mov ax, word ptr es:[bx + 0x68]
  06D967  1E67: 268b576a         mov dx, word ptr es:[bx + 0x6a]
  06D96B  1E6B: 8946fc           mov word ptr [bp - 4], ax
  06D96E  1E6E: 8956fe           mov word ptr [bp - 2], dx
  06D971  1E71: 8ec2             mov es, dx
  06D973  1E73: 8bd8             mov bx, ax
  06D975  1E75: 26ff770e         push word ptr es:[bx + 0xe]
  06D979  1E79: 26ff770c         push word ptr es:[bx + 0xc]
  06D97D  1E7D: 26ff37           push word ptr es:[bx]
  06D980  1E80: b80100           mov ax, 1
  06D983  1E83: 268b5704         mov dx, word ptr es:[bx + 4]
  06D987  1E87: 8d1ea82d         lea bx, [0x2da8]
  06D98B  1E8B: 9a54021f18       lcall 0x181f, 0x254
  06D990  1E90: 837efa00         cmp word ptr [bp - 6], 0
  06D994  1E94: 7433             je 0x1ec9
  06D996  1E96: 833e6e1f00       cmp word ptr [0x1f6e], 0
  06D99B  1E9B: 742c             je 0x1ec9
  06D99D  1E9D: 833eaea500       cmp word ptr [0xa5ae], 0
  06D9A2  1EA2: 7e25             jle 0x1ec9
  06D9A4  1EA4: a1aea5           mov ax, word ptr [0xa5ae]
  06D9A7  1EA7: c45efc           les bx, ptr [bp - 4]
  06D9AA  1EAA: 26c47710         les si, ptr es:[bx + 0x10]
  06D9AE  1EAE: 26ff740e         push word ptr es:[si + 0xe]
  06D9B2  1EB2: 26ff740c         push word ptr es:[si + 0xc]
  06D9B6  1EB6: 8e46fe           mov es, word ptr [bp - 2]
  06D9B9  1EB9: 26ff37           push word ptr es:[bx]
  06D9BC  1EBC: 268b5704         mov dx, word ptr es:[bx + 4]
  06D9C0  1EC0: 8d1ea82d         lea bx, [0x2da8]
  06D9C4  1EC4: 9a54021f18       lcall 0x181f, 0x254
  06D9C9  1EC9: 5e               pop si
  06D9CA  1ECA: c9               leave 
  06D9CB  1ECB: cb               retf 

; ---- func_06D9CC  size=664  insns=225  prologue=ENTER 0x0012,0  terminal=RET imm16 ----
  06D9CC  1ECC: c8120000         enter 0x12, 0
  06D9D0  1ED0: 50               push ax
  06D9D1  1ED1: 57               push di
  06D9D2  1ED2: 56               push si
  06D9D3  1ED3: c45e04           les bx, ptr [bp + 4]
  06D9D6  1ED6: 268b4f24         mov cx, word ptr es:[bx + 0x24]
  06D9DA  1EDA: 26034f48         add cx, word ptr es:[bx + 0x48]
  06D9DE  1EDE: 26034f22         add cx, word ptr es:[bx + 0x22]
  06D9E2  1EE2: 894ef8           mov word ptr [bp - 8], cx
  06D9E5  1EE5: 268b5726         mov dx, word ptr es:[bx + 0x26]
  06D9E9  1EE9: 8956f6           mov word ptr [bp - 0xa], dx
  06D9EC  1EEC: 268b7754         mov si, word ptr es:[bx + 0x54]
  06D9F0  1EF0: 268b7f56         mov di, word ptr es:[bx + 0x56]
  06D9F4  1EF4: 8976f0           mov word ptr [bp - 0x10], si
  06D9F7  1EF7: 897ef2           mov word ptr [bp - 0xe], di
  06D9FA  1EFA: 0bc0             or ax, ax
  06D9FC  1EFC: 7468             je 0x1f66
  06D9FE  1EFE: ff36ae2d         push word ptr [0x2dae]
  06DA02  1F02: ff36ac2d         push word ptr [0x2dac]
  06DA06  1F06: ff36aa2d         push word ptr [0x2daa]
  06DA0A  1F0A: ff36a82d         push word ptr [0x2da8]
  06DA0E  1F0E: 26ffb78200       push word ptr es:[bx + 0x82]
  06DA13  1F13: 26ffb78000       push word ptr es:[bx + 0x80]
  06DA18  1F18: e84bf3           call 0x1266
  06DA1B  1F1B: 83c404           add sp, 4
  06DA1E  1F1E: c45e04           les bx, ptr [bp + 4]
  06DA21  1F21: 26034746         add ax, word ptr es:[bx + 0x46]
  06DA25  1F25: 26f76f02         imul word ptr es:[bx + 2]
  06DA29  1F29: 50               push ax
  06DA2A  1F2A: 26ff7710         push word ptr es:[bx + 0x10]
  06DA2E  1F2E: 26ff7712         push word ptr es:[bx + 0x12]
  06DA32  1F32: 26ff7714         push word ptr es:[bx + 0x14]
  06DA36  1F36: 268a473c         mov al, byte ptr es:[bx + 0x3c]
  06DA3A  1F3A: 50               push ax
  06DA3B  1F3B: 268a473e         mov al, byte ptr es:[bx + 0x3e]
  06DA3F  1F3F: 50               push ax
  06DA40  1F40: 6a00             push 0
  06DA42  1F42: 6a00             push 0
  06DA44  1F44: 268b4748         mov ax, word ptr es:[bx + 0x48]
  06DA48  1F48: 268b4f20         mov cx, word ptr es:[bx + 0x20]
  06DA4C  1F4C: bb0100           mov bx, 1
  06DA4F  1F4F: 2bd8             sub bx, ax
  06DA51  1F51: 8b7604           mov si, word ptr [bp + 4]
  06DA54  1F54: 8b46f8           mov ax, word ptr [bp - 8]
  06DA57  1F57: 262b4422         sub ax, word ptr es:[si + 0x22]
  06DA5B  1F5B: 48               dec ax
  06DA5C  1F5C: d1e3             shl bx, 1
  06DA5E  1F5E: 03d9             add bx, cx
  06DA60  1F60: 8b56f6           mov dx, word ptr [bp - 0xa]
  06DA63  1F63: e826e7           call 0x68c
  06DA66  1F66: 8b46f2           mov ax, word ptr [bp - 0xe]
  06DA69  1F69: 0b46f0           or ax, word ptr [bp - 0x10]
  06DA6C  1F6C: 7503             jne 0x1f71
  06DA6E  1F6E: e9bd01           jmp 0x212e
  06DA71  1F71: c45ef0           les bx, ptr [bp - 0x10]
  06DA74  1F74: 268a07           mov al, byte ptr es:[bx]
  06DA77  1F77: 250200           and ax, 2
  06DA7A  1F7A: a3621f           mov word ptr [0x1f62], ax
  06DA7D  1F7D: c47604           les si, ptr [bp + 4]
  06DA80  1F80: 8bc3             mov ax, bx
  06DA82  1F82: 8b56f2           mov dx, word ptr [bp - 0xe]
  06DA85  1F85: 2639444c         cmp word ptr es:[si + 0x4c], ax
  06DA89  1F89: 7568             jne 0x1ff3
  06DA8B  1F8B: 2639544e         cmp word ptr es:[si + 0x4e], dx
  06DA8F  1F8F: 7562             jne 0x1ff3
  06DA91  1F91: ff36ae2d         push word ptr [0x2dae]
  06DA95  1F95: ff36ac2d         push word ptr [0x2dac]
  06DA99  1F99: ff36aa2d         push word ptr [0x2daa]
  06DA9D  1F9D: ff36a82d         push word ptr [0x2da8]
  06DAA1  1FA1: 26ffb48200       push word ptr es:[si + 0x82]
  06DAA6  1FA6: 26ffb48000       push word ptr es:[si + 0x80]
  06DAAB  1FAB: e8b8f2           call 0x1266
  06DAAE  1FAE: 83c404           add sp, 4
  06DAB1  1FB1: 40               inc ax
  06DAB2  1FB2: 40               inc ax
  06DAB3  1FB3: 50               push ax
  06DAB4  1FB4: c45e04           les bx, ptr [bp + 4]
  06DAB7  1FB7: 26ff7710         push word ptr es:[bx + 0x10]
  06DABB  1FBB: 26ff7712         push word ptr es:[bx + 0x12]
  06DABF  1FBF: 26ff7714         push word ptr es:[bx + 0x14]
  06DAC3  1FC3: 268a4740         mov al, byte ptr es:[bx + 0x40]
  06DAC7  1FC7: 50               push ax
  06DAC8  1FC8: 268a4742         mov al, byte ptr es:[bx + 0x42]
  06DACC  1FCC: 50               push ax
  06DACD  1FCD: 6a00             push 0
  06DACF  1FCF: 6a00             push 0
  06DAD1  1FD1: 268b4748         mov ax, word ptr es:[bx + 0x48]
  06DAD5  1FD5: 268b4f20         mov cx, word ptr es:[bx + 0x20]
  06DAD9  1FD9: bb0100           mov bx, 1
  06DADC  1FDC: 2bd8             sub bx, ax
  06DADE  1FDE: 8b46f8           mov ax, word ptr [bp - 8]
  06DAE1  1FE1: 8b7604           mov si, word ptr [bp + 4]
  06DAE4  1FE4: 262b4422         sub ax, word ptr es:[si + 0x22]
  06DAE8  1FE8: 48               dec ax
  06DAE9  1FE9: d1e3             shl bx, 1
  06DAEB  1FEB: 03d9             add bx, cx
  06DAED  1FED: 8b56f6           mov dx, word ptr [bp - 0xa]
  06DAF0  1FF0: e899e6           call 0x68c
  06DAF3  1FF3: c45ef0           les bx, ptr [bp - 0x10]
  06DAF6  1FF6: 26c45f08         les bx, ptr es:[bx + 8]
  06DAFA  1FFA: 26803f00         cmp byte ptr es:[bx], 0
  06DAFE  1FFE: 7554             jne 0x2054
  06DB00  2000: c45e04           les bx, ptr [bp + 4]
  06DB03  2003: 26ffb78200       push word ptr es:[bx + 0x82]
  06DB08  2008: 26ffb78000       push word ptr es:[bx + 0x80]
  06DB0D  200D: e856f2           call 0x1266
  06DB10  2010: 83c404           add sp, 4
  06DB13  2013: d1f8             sar ax, 1
  06DB15  2015: 0346f6           add ax, word ptr [bp - 0xa]
  06DB18  2018: 8946f4           mov word ptr [bp - 0xc], ax
  06DB1B  201B: ff36ae2d         push word ptr [0x2dae]
  06DB1F  201F: ff36ac2d         push word ptr [0x2dac]
  06DB23  2023: ff36aa2d         push word ptr [0x2daa]
  06DB27  2027: ff36a82d         push word ptr [0x2da8]
  06DB2B  202B: 6a01             push 1
  06DB2D  202D: c45e04           les bx, ptr [bp + 4]
  06DB30  2030: 268a4776         mov al, byte ptr es:[bx + 0x76]
  06DB34  2034: 50               push ax
  06DB35  2035: 8b46f8           mov ax, word ptr [bp - 8]
  06DB38  2038: 262b4722         sub ax, word ptr es:[bx + 0x22]
  06DB3C  203C: 268b4f48         mov cx, word ptr es:[bx + 0x48]
  06DB40  2040: 268b5f20         mov bx, word ptr es:[bx + 0x20]
  06DB44  2044: d1e1             shl cx, 1
  06DB46  2046: 2bd9             sub bx, cx
  06DB48  2048: 8b56f4           mov dx, word ptr [bp - 0xc]
  06DB4B  204B: 9aba001f18       lcall 0x181f, 0xba
  06DB50  2050: e9aa00           jmp 0x20fd
  06DB53  2053: 90               nop 
  06DB54  2054: c45e04           les bx, ptr [bp + 4]
  06DB57  2057: 26f6470a04       test byte ptr es:[bx + 0xa], 4
  06DB5C  205C: 7416             je 0x2074
  06DB5E  205E: c45ef0           les bx, ptr [bp - 0x10]
  06DB61  2061: 26837f0601       cmp word ptr es:[bx + 6], 1
  06DB66  2066: 1ac0             sbb al, al
  06DB68  2068: 24fe             and al, 0xfe
  06DB6A  206A: 045d             add al, 0x5d
  06DB6C  206C: 26c45f08         les bx, ptr es:[bx + 8]
  06DB70  2070: 26884701         mov byte ptr es:[bx + 1], al
  06DB74  2074: 8b4604           mov ax, word ptr [bp + 4]
  06DB77  2077: 8b5606           mov dx, word ptr [bp + 6]
  06DB7A  207A: 057400           add ax, 0x74
  06DB7D  207D: 52               push dx
  06DB7E  207E: 50               push ax
  06DB7F  207F: c45ef0           les bx, ptr [bp - 0x10]
  06DB82  2082: 26ff770a         push word ptr es:[bx + 0xa]
  06DB86  2086: 26ff7708         push word ptr es:[bx + 8]
  06DB8A  208A: 8bca             mov cx, dx
  06DB8C  208C: 8b56f6           mov dx, word ptr [bp - 0xa]
  06DB8F  208F: 42               inc dx
  06DB90  2090: 268b1f           mov bx, word ptr es:[bx]
  06DB93  2093: 8bf0             mov si, ax
  06DB95  2095: 8b46f8           mov ax, word ptr [bp - 8]
  06DB98  2098: 8bf9             mov di, cx
  06DB9A  209A: 8956ee           mov word ptr [bp - 0x12], dx
  06DB9D  209D: e8e8e7           call 0x888
  06DBA0  20A0: 6a7c             push 0x7c
  06DBA2  20A2: c45ef0           les bx, ptr [bp - 0x10]
  06DBA5  20A5: 26ff770a         push word ptr es:[bx + 0xa]
  06DBA9  20A9: 26ff7708         push word ptr es:[bx + 8]
  06DBAD  20AD: 9a10101d0d       lcall 0xd1d, 0x1010
  06DBB2  20B2: 83c406           add sp, 6
  06DBB5  20B5: 8946fa           mov word ptr [bp - 6], ax
  06DBB8  20B8: 8956fc           mov word ptr [bp - 4], dx
  06DBBB  20BB: 0bd0             or dx, ax
  06DBBD  20BD: 743e             je 0x20fd
  06DBBF  20BF: 57               push di
  06DBC0  20C0: 56               push si
  06DBC1  20C1: 8b56fc           mov dx, word ptr [bp - 4]
  06DBC4  20C4: 40               inc ax
  06DBC5  20C5: 8946fa           mov word ptr [bp - 6], ax
  06DBC8  20C8: 52               push dx
  06DBC9  20C9: 50               push ax
  06DBCA  20CA: e809e7           call 0x7d6
  06DBCD  20CD: 8946fe           mov word ptr [bp - 2], ax
  06DBD0  20D0: 57               push di
  06DBD1  20D1: 56               push si
  06DBD2  20D2: ff76fc           push word ptr [bp - 4]
  06DBD5  20D5: ff76fa           push word ptr [bp - 6]
  06DBD8  20D8: c45e04           les bx, ptr [bp + 4]
  06DBDB  20DB: 268b4720         mov ax, word ptr es:[bx + 0x20]
  06DBDF  20DF: 268b4f48         mov cx, word ptr es:[bx + 0x48]
  06DBE3  20E3: 26034f22         add cx, word ptr es:[bx + 0x22]
  06DBE7  20E7: d1e1             shl cx, 1
  06DBE9  20E9: 2bc1             sub ax, cx
  06DBEB  20EB: 2b46fe           sub ax, word ptr [bp - 2]
  06DBEE  20EE: 0346f8           add ax, word ptr [bp - 8]
  06DBF1  20F1: c45ef0           les bx, ptr [bp - 0x10]
  06DBF4  20F4: 268b1f           mov bx, word ptr es:[bx]
  06DBF7  20F7: 8b56ee           mov dx, word ptr [bp - 0x12]
  06DBFA  20FA: e88be7           call 0x888
  06DBFD  20FD: c45e04           les bx, ptr [bp + 4]
  06DC00  2100: 26ffb78200       push word ptr es:[bx + 0x82]
  06DC05  2105: 26ffb78000       push word ptr es:[bx + 0x80]
  06DC0A  210A: e859f1           call 0x1266
  06DC0D  210D: 83c404           add sp, 4
  06DC10  2110: c45e04           les bx, ptr [bp + 4]
  06DC13  2113: 26034746         add ax, word ptr es:[bx + 0x46]
  06DC17  2117: 0146f6           add word ptr [bp - 0xa], ax
  06DC1A  211A: c45ef0           les bx, ptr [bp - 0x10]
  06DC1D  211D: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06DC21  2121: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06DC25  2125: 8946f0           mov word ptr [bp - 0x10], ax
  06DC28  2128: 8956f2           mov word ptr [bp - 0xe], dx
  06DC2B  212B: e938fe           jmp 0x1f66
  06DC2E  212E: 837eec00         cmp word ptr [bp - 0x14], 0
  06DC32  2132: 742a             je 0x215e
  06DC34  2134: 833e5c1f00       cmp word ptr [0x1f5c], 0
  06DC39  2139: 7d0d             jge 0x2148
  06DC3B  213B: ff7606           push word ptr [bp + 6]
  06DC3E  213E: ff7604           push word ptr [bp + 4]
  06DC41  2141: 0e               push cs
  06DC42  2142: e8e61b           call 0x3d2b
  06DC45  2145: 83c404           add sp, 4
  06DC48  2148: ff7606           push word ptr [bp + 6]
  06DC4B  214B: ff7604           push word ptr [bp + 4]
  06DC4E  214E: 0e               push cs
  06DC4F  214F: e8f71b           call 0x3d49
  06DC52  2152: 83c404           add sp, 4
  06DC55  2155: ff7606           push word ptr [bp + 6]
  06DC58  2158: ff7604           push word ptr [bp + 4]
  06DC5B  215B: e82efc           call 0x1d8c
  06DC5E  215E: 5e               pop si
  06DC5F  215F: 5f               pop di
  06DC60  2160: c9               leave 
  06DC61  2161: c20400           ret 4

; ---- func_06DC64  size=522  insns=183  prologue=ENTER 0x006A,0  terminal=RET imm16 ----
  06DC64  2164: c86a0000         enter 0x6a, 0
  06DC68  2168: 50               push ax
  06DC69  2169: 57               push di
  06DC6A  216A: 56               push si
  06DC6B  216B: c706621f0000     mov word ptr [0x1f62], 0
  06DC71  2171: c45e04           les bx, ptr [bp + 4]
  06DC74  2174: 268b4724         mov ax, word ptr es:[bx + 0x24]
  06DC78  2178: 26034748         add ax, word ptr es:[bx + 0x48]
  06DC7C  217C: 89469a           mov word ptr [bp - 0x66], ax
  06DC7F  217F: 268b4726         mov ax, word ptr es:[bx + 0x26]
  06DC83  2183: 894698           mov word ptr [bp - 0x68], ax
  06DC86  2186: 268b4760         mov ax, word ptr es:[bx + 0x60]
  06DC8A  218A: 268b5762         mov dx, word ptr es:[bx + 0x62]
  06DC8E  218E: 8946f4           mov word ptr [bp - 0xc], ax
  06DC91  2191: 8956f6           mov word ptr [bp - 0xa], dx
  06DC94  2194: 8bc2             mov ax, dx
  06DC96  2196: 0b46f4           or ax, word ptr [bp - 0xc]
  06DC99  2199: 7503             jne 0x219e
  06DC9B  219B: e9ae01           jmp 0x234c
  06DC9E  219E: c45ef4           les bx, ptr [bp - 0xc]
  06DCA1  21A1: 26ff770e         push word ptr es:[bx + 0xe]
  06DCA5  21A5: 26ff770c         push word ptr es:[bx + 0xc]
  06DCA9  21A9: 8d46a4           lea ax, [bp - 0x5c]
  06DCAC  21AC: 16               push ss
  06DCAD  21AD: 50               push ax
  06DCAE  21AE: 9a7e111d0d       lcall 0xd1d, 0x117e
  06DCB3  21B3: 83c408           add sp, 8
  06DCB6  21B6: 8d46a4           lea ax, [bp - 0x5c]
  06DCB9  21B9: 50               push ax
  06DCBA  21BA: 9a42081d0d       lcall 0xd1d, 0x842
  06DCBF  21BF: 83c402           add sp, 2
  06DCC2  21C2: c45ef4           les bx, ptr [bp - 0xc]
  06DCC5  21C5: 263b4706         cmp ax, word ptr es:[bx + 6]
  06DCC9  21C9: 7d0f             jge 0x21da
  06DCCB  21CB: 689b1f           push 0x1f9b
  06DCCE  21CE: 8d46a4           lea ax, [bp - 0x5c]
  06DCD1  21D1: 50               push ax
  06DCD2  21D2: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06DCD7  21D7: 83c404           add sp, 4
  06DCDA  21DA: 8b4604           mov ax, word ptr [bp + 4]
  06DCDD  21DD: 8b5606           mov dx, word ptr [bp + 6]
  06DCE0  21E0: 057400           add ax, 0x74
  06DCE3  21E3: 52               push dx
  06DCE4  21E4: 50               push ax
  06DCE5  21E5: c45ef4           les bx, ptr [bp - 0xc]
  06DCE8  21E8: 26ff770a         push word ptr es:[bx + 0xa]
  06DCEC  21EC: 26ff7708         push word ptr es:[bx + 8]
  06DCF0  21F0: 8bca             mov cx, dx
  06DCF2  21F2: 8b5698           mov dx, word ptr [bp - 0x68]
  06DCF5  21F5: 83c203           add dx, 3
  06DCF8  21F8: 895696           mov word ptr [bp - 0x6a], dx
  06DCFB  21FB: 8bf0             mov si, ax
  06DCFD  21FD: 8b469a           mov ax, word ptr [bp - 0x66]
  06DD00  2200: 2bdb             sub bx, bx
  06DD02  2202: 8bf9             mov di, cx
  06DD04  2204: e881e6           call 0x888
  06DD07  2207: c45ef4           les bx, ptr [bp - 0xc]
  06DD0A  220A: 268b4702         mov ax, word ptr es:[bx + 2]
  06DD0E  220E: 03469a           add ax, word ptr [bp - 0x66]
  06DD11  2211: 8946fc           mov word ptr [bp - 4], ax
  06DD14  2214: 8b4698           mov ax, word ptr [bp - 0x68]
  06DD17  2217: 8946f8           mov word ptr [bp - 8], ax
  06DD1A  221A: 268b4f04         mov cx, word ptr es:[bx + 4]
  06DD1E  221E: 83c106           add cx, 6
  06DD21  2221: 894ea0           mov word ptr [bp - 0x60], cx
  06DD24  2224: c45e04           les bx, ptr [bp + 4]
  06DD27  2227: 26ffb78200       push word ptr es:[bx + 0x82]
  06DD2C  222C: 26ffb78000       push word ptr es:[bx + 0x80]
  06DD31  2231: e832f0           call 0x1266
  06DD34  2234: 83c404           add sp, 4
  06DD37  2237: 050500           add ax, 5
  06DD3A  223A: 89469c           mov word ptr [bp - 0x64], ax
  06DD3D  223D: ff36ae2d         push word ptr [0x2dae]
  06DD41  2241: ff36ac2d         push word ptr [0x2dac]
  06DD45  2245: ff36aa2d         push word ptr [0x2daa]
  06DD49  2249: ff36a82d         push word ptr [0x2da8]
  06DD4D  224D: 034698           add ax, word ptr [bp - 0x68]
  06DD50  2250: 48               dec ax
  06DD51  2251: 50               push ax
  06DD52  2252: c45e04           les bx, ptr [bp + 4]
  06DD55  2255: 268a4776         mov al, byte ptr es:[bx + 0x76]
  06DD59  2259: 50               push ax
  06DD5A  225A: 8b46fc           mov ax, word ptr [bp - 4]
  06DD5D  225D: 8b5ea0           mov bx, word ptr [bp - 0x60]
  06DD60  2260: 03d8             add bx, ax
  06DD62  2262: 8d5fff           lea bx, [bx - 1]
  06DD65  2265: 8b5698           mov dx, word ptr [bp - 0x68]
  06DD68  2268: 9ace001f18       lcall 0x181f, 0xce
  06DD6D  226D: 8b46fc           mov ax, word ptr [bp - 4]
  06DD70  2270: 40               inc ax
  06DD71  2271: 40               inc ax
  06DD72  2272: 8946fe           mov word ptr [bp - 2], ax
  06DD75  2275: 8b4ea0           mov cx, word ptr [bp - 0x60]
  06DD78  2278: 83e904           sub cx, 4
  06DD7B  227B: 894ea2           mov word ptr [bp - 0x5e], cx
  06DD7E  227E: 8b5698           mov dx, word ptr [bp - 0x68]
  06DD81  2281: 42               inc dx
  06DD82  2282: 42               inc dx
  06DD83  2283: 8956fa           mov word ptr [bp - 6], dx
  06DD86  2286: 8b5e9c           mov bx, word ptr [bp - 0x64]
  06DD89  2289: 83eb04           sub bx, 4
  06DD8C  228C: 895e9e           mov word ptr [bp - 0x62], bx
  06DD8F  228F: ff36ae2d         push word ptr [0x2dae]
  06DD93  2293: ff36ac2d         push word ptr [0x2dac]
  06DD97  2297: ff36aa2d         push word ptr [0x2daa]
  06DD9B  229B: ff36a82d         push word ptr [0x2da8]
  06DD9F  229F: 53               push bx
  06DDA0  22A0: c45e04           les bx, ptr [bp + 4]
  06DDA3  22A3: 26ff7710         push word ptr es:[bx + 0x10]
  06DDA7  22A7: 26ff7712         push word ptr es:[bx + 0x12]
  06DDAB  22AB: 26ff7714         push word ptr es:[bx + 0x14]
  06DDAF  22AF: 268a473c         mov al, byte ptr es:[bx + 0x3c]
  06DDB3  22B3: 50               push ax
  06DDB4  22B4: 268a473e         mov al, byte ptr es:[bx + 0x3e]
  06DDB8  22B8: 50               push ax
  06DDB9  22B9: 6a00             push 0
  06DDBB  22BB: 6a00             push 0
  06DDBD  22BD: 8bd9             mov bx, cx
  06DDBF  22BF: 8b46fe           mov ax, word ptr [bp - 2]
  06DDC2  22C2: e8c7e3           call 0x68c
  06DDC5  22C5: c45ef4           les bx, ptr [bp - 0xc]
  06DDC8  22C8: 26f60780         test byte ptr es:[bx], 0x80
  06DDCC  22CC: 744e             je 0x231c
  06DDCE  22CE: 57               push di
  06DDCF  22CF: 56               push si
  06DDD0  22D0: 26ff770e         push word ptr es:[bx + 0xe]
  06DDD4  22D4: 26ff770c         push word ptr es:[bx + 0xc]
  06DDD8  22D8: e8fbe4           call 0x7d6
  06DDDB  22DB: 40               inc ax
  06DDDC  22DC: 40               inc ax
  06DDDD  22DD: 8946a2           mov word ptr [bp - 0x5e], ax
  06DDE0  22E0: ff36ae2d         push word ptr [0x2dae]
  06DDE4  22E4: ff36ac2d         push word ptr [0x2dac]
  06DDE8  22E8: ff36aa2d         push word ptr [0x2daa]
  06DDEC  22EC: ff36a82d         push word ptr [0x2da8]
  06DDF0  22F0: ff769e           push word ptr [bp - 0x62]
  06DDF3  22F3: c45e04           les bx, ptr [bp + 4]
  06DDF6  22F6: 26ff7710         push word ptr es:[bx + 0x10]
  06DDFA  22FA: 26ff7712         push word ptr es:[bx + 0x12]
  06DDFE  22FE: 26ff7714         push word ptr es:[bx + 0x14]
  06DE02  2302: 268a4740         mov al, byte ptr es:[bx + 0x40]
  06DE06  2306: 50               push ax
  06DE07  2307: 268a4742         mov al, byte ptr es:[bx + 0x42]
  06DE0B  230B: 50               push ax
  06DE0C  230C: 6a00             push 0
  06DE0E  230E: 6a00             push 0
  06DE10  2310: 8b46fe           mov ax, word ptr [bp - 2]
  06DE13  2313: 8b56fa           mov dx, word ptr [bp - 6]
  06DE16  2316: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  06DE19  2319: e870e3           call 0x68c
  06DE1C  231C: 8b4604           mov ax, word ptr [bp + 4]
  06DE1F  231F: 8b5606           mov dx, word ptr [bp + 6]
  06DE22  2322: 057400           add ax, 0x74
  06DE25  2325: 52               push dx
  06DE26  2326: 50               push ax
  06DE27  2327: 8d46a4           lea ax, [bp - 0x5c]
  06DE2A  232A: 16               push ss
  06DE2B  232B: 50               push ax
  06DE2C  232C: 8b46fc           mov ax, word ptr [bp - 4]
  06DE2F  232F: 050300           add ax, 3
  06DE32  2332: 8b56f8           mov dx, word ptr [bp - 8]
  06DE35  2335: 83c203           add dx, 3
  06DE38  2338: 2bdb             sub bx, bx
  06DE3A  233A: e84be5           call 0x888
  06DE3D  233D: c45ef4           les bx, ptr [bp - 0xc]
  06DE40  2340: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06DE44  2344: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06DE48  2348: e943fe           jmp 0x218e
  06DE4B  234B: 90               nop 
  06DE4C  234C: 837e9400         cmp word ptr [bp - 0x6c], 0
  06DE50  2350: 7416             je 0x2368
  06DE52  2352: ff7606           push word ptr [bp + 6]
  06DE55  2355: ff7604           push word ptr [bp + 4]
  06DE58  2358: 0e               push cs
  06DE59  2359: e8ed19           call 0x3d49
  06DE5C  235C: 83c404           add sp, 4
  06DE5F  235F: ff7606           push word ptr [bp + 6]
  06DE62  2362: ff7604           push word ptr [bp + 4]
  06DE65  2365: e824fa           call 0x1d8c
  06DE68  2368: 5e               pop si
  06DE69  2369: 5f               pop di
  06DE6A  236A: c9               leave 
  06DE6B  236B: c20400           ret 4

; ---- func_06DE6E  size=601  insns=207  prologue=ENTER 0x0016,0  terminal=RET imm16 ----
  06DE6E  236E: c8160000         enter 0x16, 0
  06DE72  2372: 53               push bx
  06DE73  2373: 52               push dx
  06DE74  2374: 50               push ax
  06DE75  2375: 56               push si
  06DE76  2376: c706621f0000     mov word ptr [0x1f62], 0
  06DE7C  237C: c45e04           les bx, ptr [bp + 4]
  06DE7F  237F: 268b475e         mov ax, word ptr es:[bx + 0x5e]
  06DE83  2383: 260b475c         or ax, word ptr es:[bx + 0x5c]
  06DE87  2387: 7503             jne 0x238c
  06DE89  2389: e93602           jmp 0x25c2
  06DE8C  238C: 268b475c         mov ax, word ptr es:[bx + 0x5c]
  06DE90  2390: 268b575e         mov dx, word ptr es:[bx + 0x5e]
  06DE94  2394: 8946f4           mov word ptr [bp - 0xc], ax
  06DE97  2397: 8956f6           mov word ptr [bp - 0xa], dx
  06DE9A  239A: c45ef4           les bx, ptr [bp - 0xc]
  06DE9D  239D: 268b4712         mov ax, word ptr es:[bx + 0x12]
  06DEA1  23A1: 260b4710         or ax, word ptr es:[bx + 0x10]
  06DEA5  23A5: 740b             je 0x23b2
  06DEA7  23A7: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06DEAB  23AB: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06DEAF  23AF: ebe3             jmp 0x2394
  06DEB1  23B1: 90               nop 
  06DEB2  23B2: 268b4702         mov ax, word ptr es:[bx + 2]
  06DEB6  23B6: 8946ea           mov word ptr [bp - 0x16], ax
  06DEB9  23B9: c45e04           les bx, ptr [bp + 4]
  06DEBC  23BC: 268b475c         mov ax, word ptr es:[bx + 0x5c]
  06DEC0  23C0: 268b575e         mov dx, word ptr es:[bx + 0x5e]
  06DEC4  23C4: 8946f4           mov word ptr [bp - 0xc], ax
  06DEC7  23C7: 8956f6           mov word ptr [bp - 0xa], dx
  06DECA  23CA: 268b470a         mov ax, word ptr es:[bx + 0xa]
  06DECE  23CE: 8bc8             mov cx, ax
  06DED0  23D0: 251000           and ax, 0x10
  06DED3  23D3: 3d0100           cmp ax, 1
  06DED6  23D6: 1bc0             sbb ax, ax
  06DED8  23D8: 250300           and ax, 3
  06DEDB  23DB: 8bd0             mov dx, ax
  06DEDD  23DD: 26034710         add ax, word ptr es:[bx + 0x10]
  06DEE1  23E1: 26035712         add dx, word ptr es:[bx + 0x12]
  06DEE5  23E5: 8956fc           mov word ptr [bp - 4], dx
  06DEE8  23E8: 26034748         add ax, word ptr es:[bx + 0x48]
  06DEEC  23EC: 8946fa           mov word ptr [bp - 6], ax
  06DEEF  23EF: 26035746         add dx, word ptr es:[bx + 0x46]
  06DEF3  23F3: f6c102           test cl, 2
  06DEF6  23F6: 7408             je 0x2400
  06DEF8  23F8: c746ee1000       mov word ptr [bp - 0x12], 0x10
  06DEFD  23FD: eb1c             jmp 0x241b
  06DEFF  23FF: 90               nop 
  06DF00  2400: c45ef4           les bx, ptr [bp - 0xc]
  06DF03  2403: 268b7704         mov si, word ptr es:[bx + 4]
  06DF07  2407: 8bc6             mov ax, si
  06DF09  2409: d1e6             shl si, 1
  06DF0B  240B: 03f0             add si, ax
  06DF0D  240D: c1e602           shl si, 2
  06DF10  2410: 26c45f0c         les bx, ptr es:[bx + 0xc]
  06DF14  2414: 268b403e         mov ax, word ptr es:[bx + si + 0x3e]
  06DF18  2418: 8946ee           mov word ptr [bp - 0x12], ax
  06DF1B  241B: 8b46ea           mov ax, word ptr [bp - 0x16]
  06DF1E  241E: c45ef4           les bx, ptr [bp - 0xc]
  06DF21  2421: 262b07           sub ax, word ptr es:[bx]
  06DF24  2424: 40               inc ax
  06DF25  2425: 837ee600         cmp word ptr [bp - 0x1a], 0
  06DF29  2429: 7447             je 0x2472
  06DF2B  242B: ff36ae2d         push word ptr [0x2dae]
  06DF2F  242F: ff36ac2d         push word ptr [0x2dac]
  06DF33  2433: ff36aa2d         push word ptr [0x2daa]
  06DF37  2437: ff36a82d         push word ptr [0x2da8]
  06DF3B  243B: 40               inc ax
  06DF3C  243C: 40               inc ax
  06DF3D  243D: 50               push ax
  06DF3E  243E: 8cc0             mov ax, es
  06DF40  2440: c47604           les si, ptr [bp + 4]
  06DF43  2443: 26ff7410         push word ptr es:[si + 0x10]
  06DF47  2447: 26ff7412         push word ptr es:[si + 0x12]
  06DF4B  244B: 26ff7414         push word ptr es:[si + 0x14]
  06DF4F  244F: 268a4c3c         mov cl, byte ptr es:[si + 0x3c]
  06DF53  2453: 51               push cx
  06DF54  2454: 268a4c3e         mov cl, byte ptr es:[si + 0x3e]
  06DF58  2458: 51               push cx
  06DF59  2459: 6a00             push 0
  06DF5B  245B: 6a00             push 0
  06DF5D  245D: 8ec0             mov es, ax
  06DF5F  245F: 268b17           mov dx, word ptr es:[bx]
  06DF62  2462: 0356fc           add dx, word ptr [bp - 4]
  06DF65  2465: 4a               dec dx
  06DF66  2466: 8b46fa           mov ax, word ptr [bp - 6]
  06DF69  2469: 48               dec ax
  06DF6A  246A: 8b5eee           mov bx, word ptr [bp - 0x12]
  06DF6D  246D: 43               inc bx
  06DF6E  246E: 43               inc bx
  06DF6F  246F: e81ae2           call 0x68c
  06DF72  2472: 8b46f6           mov ax, word ptr [bp - 0xa]
  06DF75  2475: 0b46f4           or ax, word ptr [bp - 0xc]
  06DF78  2478: 7503             jne 0x247d
  06DF7A  247A: e92901           jmp 0x25a6
  06DF7D  247D: c45e04           les bx, ptr [bp + 4]
  06DF80  2480: 26f6470a02       test byte ptr es:[bx + 0xa], 2
  06DF85  2485: 741f             je 0x24a6
  06DF87  2487: c45ef4           les bx, ptr [bp - 0xc]
  06DF8A  248A: 268b07           mov ax, word ptr es:[bx]
  06DF8D  248D: 0346fc           add ax, word ptr [bp - 4]
  06DF90  2490: 50               push ax
  06DF91  2491: 6a10             push 0x10
  06DF93  2493: 6a64             push 0x64
  06DF95  2495: 268b4704         mov ax, word ptr es:[bx + 4]
  06DF99  2499: 2bd2             sub dx, dx
  06DF9B  249B: 8b5efa           mov bx, word ptr [bp - 6]
  06DF9E  249E: 9abc021f18       lcall 0x181f, 0x2bc
  06DFA3  24A3: eb23             jmp 0x24c8
  06DFA5  24A5: 90               nop 
  06DFA6  24A6: c45ef4           les bx, ptr [bp - 0xc]
  06DFA9  24A9: 26ff770e         push word ptr es:[bx + 0xe]
  06DFAD  24AD: 26ff770c         push word ptr es:[bx + 0xc]
  06DFB1  24B1: 268b07           mov ax, word ptr es:[bx]
  06DFB4  24B4: 0346fc           add ax, word ptr [bp - 4]
  06DFB7  24B7: 50               push ax
  06DFB8  24B8: 268b4704         mov ax, word ptr es:[bx + 4]
  06DFBC  24BC: 8d1ea82d         lea bx, [0x2da8]
  06DFC0  24C0: 8b56fa           mov dx, word ptr [bp - 6]
  06DFC3  24C3: 9a54021f18       lcall 0x181f, 0x254
  06DFC8  24C8: 8b46f4           mov ax, word ptr [bp - 0xc]
  06DFCB  24CB: 8b56f6           mov dx, word ptr [bp - 0xa]
  06DFCE  24CE: c45e04           les bx, ptr [bp + 4]
  06DFD1  24D1: 26394750         cmp word ptr es:[bx + 0x50], ax
  06DFD5  24D5: 7550             jne 0x2527
  06DFD7  24D7: 26395752         cmp word ptr es:[bx + 0x52], dx
  06DFDB  24DB: 754a             jne 0x2527
  06DFDD  24DD: 837ee800         cmp word ptr [bp - 0x18], 0
  06DFE1  24E1: 7444             je 0x2527
  06DFE3  24E3: 26f6470a80       test byte ptr es:[bx + 0xa], 0x80
  06DFE8  24E8: 743d             je 0x2527
  06DFEA  24EA: 268b4f66         mov cx, word ptr es:[bx + 0x66]
  06DFEE  24EE: 260b4f64         or cx, word ptr es:[bx + 0x64]
  06DFF2  24F2: 7433             je 0x2527
  06DFF4  24F4: ff36ae2d         push word ptr [0x2dae]
  06DFF8  24F8: ff36ac2d         push word ptr [0x2dac]
  06DFFC  24FC: ff36aa2d         push word ptr [0x2daa]
  06E000  2500: ff36a82d         push word ptr [0x2da8]
  06E004  2504: 8ec2             mov es, dx
  06E006  2506: 8bd8             mov bx, ax
  06E008  2508: 268b07           mov ax, word ptr es:[bx]
  06E00B  250B: 0346fc           add ax, word ptr [bp - 4]
  06E00E  250E: 8bc8             mov cx, ax
  06E010  2510: 051000           add ax, 0x10
  06E013  2513: 50               push ax
  06E014  2514: 6a0f             push 0xf
  06E016  2516: 8b46fa           mov ax, word ptr [bp - 6]
  06E019  2519: 8bd8             mov bx, ax
  06E01B  251B: 83c310           add bx, 0x10
  06E01E  251E: 48               dec ax
  06E01F  251F: 8bd1             mov dx, cx
  06E021  2521: 4a               dec dx
  06E022  2522: 9ace001f18       lcall 0x181f, 0xce
  06E027  2527: 837ee400         cmp word ptr [bp - 0x1c], 0
  06E02B  252B: 7465             je 0x2592
  06E02D  252D: c45ef4           les bx, ptr [bp - 0xc]
  06E030  2530: 268b470a         mov ax, word ptr es:[bx + 0xa]
  06E034  2534: 260b4708         or ax, word ptr es:[bx + 8]
  06E038  2538: 7458             je 0x2592
  06E03A  253A: c47604           les si, ptr [bp + 4]
  06E03D  253D: 268b4446         mov ax, word ptr es:[si + 0x46]
  06E041  2541: 2603442e         add ax, word ptr es:[si + 0x2e]
  06E045  2545: 26034432         add ax, word ptr es:[si + 0x32]
  06E049  2549: 0346fa           add ax, word ptr [bp - 6]
  06E04C  254C: 8946f2           mov word ptr [bp - 0xe], ax
  06E04F  254F: 26ffb48200       push word ptr es:[si + 0x82]
  06E054  2554: 26ffb48000       push word ptr es:[si + 0x80]
  06E059  2559: e80aed           call 0x1266
  06E05C  255C: 83c404           add sp, 4
  06E05F  255F: d1f8             sar ax, 1
  06E061  2561: c45ef4           les bx, ptr [bp - 0xc]
  06E064  2564: 268b4f02         mov cx, word ptr es:[bx + 2]
  06E068  2568: 262b0f           sub cx, word ptr es:[bx]
  06E06B  256B: d1f9             sar cx, 1
  06E06D  256D: 2bc8             sub cx, ax
  06E06F  256F: 26030f           add cx, word ptr es:[bx]
  06E072  2572: 034efc           add cx, word ptr [bp - 4]
  06E075  2575: 8b4604           mov ax, word ptr [bp + 4]
  06E078  2578: 8b5606           mov dx, word ptr [bp + 6]
  06E07B  257B: 057400           add ax, 0x74
  06E07E  257E: 52               push dx
  06E07F  257F: 50               push ax
  06E080  2580: 26ff770a         push word ptr es:[bx + 0xa]
  06E084  2584: 26ff7708         push word ptr es:[bx + 8]
  06E088  2588: 8b46f2           mov ax, word ptr [bp - 0xe]
  06E08B  258B: 8bd1             mov dx, cx
  06E08D  258D: 2bdb             sub bx, bx
  06E08F  258F: e8f6e2           call 0x888
  06E092  2592: c45ef4           les bx, ptr [bp - 0xc]
  06E095  2595: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06E099  2599: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06E09D  259D: 8946f4           mov word ptr [bp - 0xc], ax
  06E0A0  25A0: 8956f6           mov word ptr [bp - 0xa], dx
  06E0A3  25A3: e9ccfe           jmp 0x2472
  06E0A6  25A6: 837ee600         cmp word ptr [bp - 0x1a], 0
  06E0AA  25AA: 7416             je 0x25c2
  06E0AC  25AC: ff7606           push word ptr [bp + 6]
  06E0AF  25AF: ff7604           push word ptr [bp + 4]
  06E0B2  25B2: 0e               push cs
  06E0B3  25B3: e89317           call 0x3d49
  06E0B6  25B6: 83c404           add sp, 4
  06E0B9  25B9: ff7606           push word ptr [bp + 6]
  06E0BC  25BC: ff7604           push word ptr [bp + 4]
  06E0BF  25BF: e8caf7           call 0x1d8c
  06E0C2  25C2: 5e               pop si
  06E0C3  25C3: c9               leave 
  06E0C4  25C4: c20400           ret 4

; ---- func_06E0C8  size=534  insns=188  prologue=ENTER 0x0018,0  terminal=RETF ----
  06E0C8  25C8: c8180000         enter 0x18, 0
  06E0CC  25CC: 57               push di
  06E0CD  25CD: 56               push si
  06E0CE  25CE: c746f00000       mov word ptr [bp - 0x10], 0
  06E0D3  25D3: 8b4608           mov ax, word ptr [bp + 8]
  06E0D6  25D6: 0b4606           or ax, word ptr [bp + 6]
  06E0D9  25D9: 7405             je 0x25e0
  06E0DB  25DB: c746f00100       mov word ptr [bp - 0x10], 1
  06E0E0  25E0: 837ef000         cmp word ptr [bp - 0x10], 0
  06E0E4  25E4: 7418             je 0x25fe
  06E0E6  25E6: c45e06           les bx, ptr [bp + 6]
  06E0E9  25E9: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06E0ED  25ED: 8946f6           mov word ptr [bp - 0xa], ax
  06E0F0  25F0: 268b4712         mov ax, word ptr es:[bx + 0x12]
  06E0F4  25F4: 8946f2           mov word ptr [bp - 0xe], ax
  06E0F7  25F7: 268b4714         mov ax, word ptr es:[bx + 0x14]
  06E0FB  25FB: eb10             jmp 0x260d
  06E0FD  25FD: 90               nop 
  06E0FE  25FE: 8b460a           mov ax, word ptr [bp + 0xa]
  06E101  2601: 8946f6           mov word ptr [bp - 0xa], ax
  06E104  2604: 8b460c           mov ax, word ptr [bp + 0xc]
  06E107  2607: 8946f2           mov word ptr [bp - 0xe], ax
  06E10A  260A: 8b460e           mov ax, word ptr [bp + 0xe]
  06E10D  260D: 8946f4           mov word ptr [bp - 0xc], ax
  06E110  2610: 8b4608           mov ax, word ptr [bp + 8]
  06E113  2613: 0b4606           or ax, word ptr [bp + 6]
  06E116  2616: 740d             je 0x2625
  06E118  2618: c45e06           les bx, ptr [bp + 6]
  06E11B  261B: 26f6470a10       test byte ptr es:[bx + 0xa], 0x10
  06E120  2620: 7403             je 0x2625
  06E122  2622: e9ef00           jmp 0x2714
  06E125  2625: ff36ae2d         push word ptr [0x2dae]
  06E129  2629: ff36ac2d         push word ptr [0x2dac]
  06E12D  262D: ff36aa2d         push word ptr [0x2daa]
  06E131  2631: ff36a82d         push word ptr [0x2da8]
  06E135  2635: 8b4610           mov ax, word ptr [bp + 0x10]
  06E138  2638: 03460c           add ax, word ptr [bp + 0xc]
  06E13B  263B: 8bc8             mov cx, ax
  06E13D  263D: 48               dec ax
  06E13E  263E: 50               push ax
  06E13F  263F: 6a00             push 0
  06E141  2641: 8b460a           mov ax, word ptr [bp + 0xa]
  06E144  2644: 8b5e0e           mov bx, word ptr [bp + 0xe]
  06E147  2647: 03d8             add bx, ax
  06E149  2649: 8bd3             mov dx, bx
  06E14B  264B: 8d5fff           lea bx, [bx - 1]
  06E14E  264E: 8bf2             mov si, dx
  06E150  2650: 8b560c           mov dx, word ptr [bp + 0xc]
  06E153  2653: 8bf9             mov di, cx
  06E155  2655: 9ace001f18       lcall 0x181f, 0xce
  06E15A  265A: ff36ae2d         push word ptr [0x2dae]
  06E15E  265E: ff36ac2d         push word ptr [0x2dac]
  06E162  2662: ff36aa2d         push word ptr [0x2daa]
  06E166  2666: ff36a82d         push word ptr [0x2da8]
  06E16A  266A: 8d45fe           lea ax, [di - 2]
  06E16D  266D: 50               push ax
  06E16E  266E: a0441f           mov al, byte ptr [0x1f44]
  06E171  2671: 50               push ax
  06E172  2672: 8d5cfe           lea bx, [si - 2]
  06E175  2675: 8b460a           mov ax, word ptr [bp + 0xa]
  06E178  2678: 40               inc ax
  06E179  2679: 8b560c           mov dx, word ptr [bp + 0xc]
  06E17C  267C: 42               inc dx
  06E17D  267D: 9ace001f18       lcall 0x181f, 0xce
  06E182  2682: ff36ae2d         push word ptr [0x2dae]
  06E186  2686: ff36ac2d         push word ptr [0x2dac]
  06E18A  268A: ff36aa2d         push word ptr [0x2daa]
  06E18E  268E: ff36a82d         push word ptr [0x2da8]
  06E192  2692: a0481f           mov al, byte ptr [0x1f48]
  06E195  2695: 50               push ax
  06E196  2696: 8b460a           mov ax, word ptr [bp + 0xa]
  06E199  2699: 40               inc ax
  06E19A  269A: 40               inc ax
  06E19B  269B: 8d5dfd           lea bx, [di - 3]
  06E19E  269E: 8b560c           mov dx, word ptr [bp + 0xc]
  06E1A1  26A1: 42               inc dx
  06E1A2  26A2: 42               inc dx
  06E1A3  26A3: 8bf8             mov di, ax
  06E1A5  26A5: 8956ee           mov word ptr [bp - 0x12], dx
  06E1A8  26A8: 895eec           mov word ptr [bp - 0x14], bx
  06E1AB  26AB: 9ab2081f19       lcall 0x191f, 0x8b2
  06E1B0  26B0: ff36ae2d         push word ptr [0x2dae]
  06E1B4  26B4: ff36ac2d         push word ptr [0x2dac]
  06E1B8  26B8: ff36aa2d         push word ptr [0x2daa]
  06E1BC  26BC: ff36a82d         push word ptr [0x2da8]
  06E1C0  26C0: a0461f           mov al, byte ptr [0x1f46]
  06E1C3  26C3: 50               push ax
  06E1C4  26C4: 8d44fd           lea ax, [si - 3]
  06E1C7  26C7: 8b56ee           mov dx, word ptr [bp - 0x12]
  06E1CA  26CA: 8b5eec           mov bx, word ptr [bp - 0x14]
  06E1CD  26CD: 8bf0             mov si, ax
  06E1CF  26CF: 9ab2081f19       lcall 0x191f, 0x8b2
  06E1D4  26D4: ff36ae2d         push word ptr [0x2dae]
  06E1D8  26D8: ff36ac2d         push word ptr [0x2dac]
  06E1DC  26DC: ff36aa2d         push word ptr [0x2daa]
  06E1E0  26E0: ff36a82d         push word ptr [0x2da8]
  06E1E4  26E4: a0461f           mov al, byte ptr [0x1f46]
  06E1E7  26E7: 50               push ax
  06E1E8  26E8: 8bd6             mov dx, si
  06E1EA  26EA: 8bc7             mov ax, di
  06E1EC  26EC: 8b5eee           mov bx, word ptr [bp - 0x12]
  06E1EF  26EF: 9abc081f19       lcall 0x191f, 0x8bc
  06E1F4  26F4: ff36ae2d         push word ptr [0x2dae]
  06E1F8  26F8: ff36ac2d         push word ptr [0x2dac]
  06E1FC  26FC: ff36aa2d         push word ptr [0x2daa]
  06E200  2700: ff36a82d         push word ptr [0x2da8]
  06E204  2704: a0481f           mov al, byte ptr [0x1f48]
  06E207  2707: 50               push ax
  06E208  2708: 8bc7             mov ax, di
  06E20A  270A: 8bd6             mov dx, si
  06E20C  270C: 8b5eec           mov bx, word ptr [bp - 0x14]
  06E20F  270F: 9abc081f19       lcall 0x191f, 0x8bc
  06E214  2714: 837ef000         cmp word ptr [bp - 0x10], 0
  06E218  2718: 7414             je 0x272e
  06E21A  271A: c45e06           les bx, ptr [bp + 6]
  06E21D  271D: 268a470a         mov al, byte ptr es:[bx + 0xa]
  06E221  2721: 251000           and ax, 0x10
  06E224  2724: 3d0100           cmp ax, 1
  06E227  2727: 1bc0             sbb ax, ax
  06E229  2729: 250300           and ax, 3
  06E22C  272C: eb03             jmp 0x2731
  06E22E  272E: b80300           mov ax, 3
  06E231  2731: 03460a           add ax, word ptr [bp + 0xa]
  06E234  2734: 8946fe           mov word ptr [bp - 2], ax
  06E237  2737: 837ef000         cmp word ptr [bp - 0x10], 0
  06E23B  273B: 7415             je 0x2752
  06E23D  273D: c45e06           les bx, ptr [bp + 6]
  06E240  2740: 268a470a         mov al, byte ptr es:[bx + 0xa]
  06E244  2744: 251000           and ax, 0x10
  06E247  2747: 3d0100           cmp ax, 1
  06E24A  274A: 1bc0             sbb ax, ax
  06E24C  274C: 250300           and ax, 3
  06E24F  274F: eb04             jmp 0x2755
  06E251  2751: 90               nop 
  06E252  2752: b80300           mov ax, 3
  06E255  2755: 03460c           add ax, word ptr [bp + 0xc]
  06E258  2758: 8946fc           mov word ptr [bp - 4], ax
  06E25B  275B: 837ef000         cmp word ptr [bp - 0x10], 0
  06E25F  275F: 7415             je 0x2776
  06E261  2761: c45e06           les bx, ptr [bp + 6]
  06E264  2764: 268a470a         mov al, byte ptr es:[bx + 0xa]
  06E268  2768: 251000           and ax, 0x10
  06E26B  276B: 3d0100           cmp ax, 1
  06E26E  276E: 1bc0             sbb ax, ax
  06E270  2770: 250300           and ax, 3
  06E273  2773: eb04             jmp 0x2779
  06E275  2775: 90               nop 
  06E276  2776: b80300           mov ax, 3
  06E279  2779: d1e0             shl ax, 1
  06E27B  277B: 2b460e           sub ax, word ptr [bp + 0xe]
  06E27E  277E: f7d8             neg ax
  06E280  2780: 8946fa           mov word ptr [bp - 6], ax
  06E283  2783: 837ef000         cmp word ptr [bp - 0x10], 0
  06E287  2787: 7415             je 0x279e
  06E289  2789: c45e06           les bx, ptr [bp + 6]
  06E28C  278C: 268a470a         mov al, byte ptr es:[bx + 0xa]
  06E290  2790: 251000           and ax, 0x10
  06E293  2793: 3d0100           cmp ax, 1
  06E296  2796: 1bc0             sbb ax, ax
  06E298  2798: 250300           and ax, 3
  06E29B  279B: eb04             jmp 0x27a1
  06E29D  279D: 90               nop 
  06E29E  279E: b80300           mov ax, 3
  06E2A1  27A1: d1e0             shl ax, 1
  06E2A3  27A3: 2b4610           sub ax, word ptr [bp + 0x10]
  06E2A6  27A6: f7d8             neg ax
  06E2A8  27A8: ff36ae2d         push word ptr [0x2dae]
  06E2AC  27AC: ff36ac2d         push word ptr [0x2dac]
  06E2B0  27B0: ff36aa2d         push word ptr [0x2daa]
  06E2B4  27B4: ff36a82d         push word ptr [0x2da8]
  06E2B8  27B8: 50               push ax
  06E2B9  27B9: ff76f6           push word ptr [bp - 0xa]
  06E2BC  27BC: ff76f2           push word ptr [bp - 0xe]
  06E2BF  27BF: ff76f4           push word ptr [bp - 0xc]
  06E2C2  27C2: a03c1f           mov al, byte ptr [0x1f3c]
  06E2C5  27C5: 50               push ax
  06E2C6  27C6: a03e1f           mov al, byte ptr [0x1f3e]
  06E2C9  27C9: 50               push ax
  06E2CA  27CA: 6a00             push 0
  06E2CC  27CC: 6a00             push 0
  06E2CE  27CE: 8b46fe           mov ax, word ptr [bp - 2]
  06E2D1  27D1: 8b56fc           mov dx, word ptr [bp - 4]
  06E2D4  27D4: 8b5efa           mov bx, word ptr [bp - 6]
  06E2D7  27D7: e8b2de           call 0x68c
  06E2DA  27DA: 5e               pop si
  06E2DB  27DB: 5f               pop di
  06E2DC  27DC: c9               leave 
  06E2DD  27DD: cb               retf 

; ---- func_06E2DE  size=207  insns=72  prologue=ENTER 0x005E,0  terminal=RETF ----
  06E2DE  27DE: c85e0000         enter 0x5e, 0
  06E2E2  27E2: c746aa0100       mov word ptr [bp - 0x56], 1
  06E2E7  27E7: ff7608           push word ptr [bp + 8]
  06E2EA  27EA: ff7606           push word ptr [bp + 6]
  06E2ED  27ED: e826f0           call 0x1816
  06E2F0  27F0: 0bc0             or ax, ax
  06E2F2  27F2: 7403             je 0x27f7
  06E2F4  27F4: e9b100           jmp 0x28a8
  06E2F7  27F7: a3621f           mov word ptr [0x1f62], ax
  06E2FA  27FA: c45e06           les bx, ptr [bp + 6]
  06E2FD  27FD: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06E301  2801: 8946a8           mov word ptr [bp - 0x58], ax
  06E304  2804: 268b4712         mov ax, word ptr es:[bx + 0x12]
  06E308  2808: 8946a6           mov word ptr [bp - 0x5a], ax
  06E30B  280B: 268b4714         mov ax, word ptr es:[bx + 0x14]
  06E30F  280F: 8946a4           mov word ptr [bp - 0x5c], ax
  06E312  2812: 268b4716         mov ax, word ptr es:[bx + 0x16]
  06E316  2816: 8946a2           mov word ptr [bp - 0x5e], ax
  06E319  2819: 833e5c1f00       cmp word ptr [0x1f5c], 0
  06E31E  281E: 7c09             jl 0x2829
  06E320  2820: 06               push es
  06E321  2821: 53               push bx
  06E322  2822: 0e               push cs
  06E323  2823: e80515           call 0x3d2b
  06E326  2826: 83c404           add sp, 4
  06E329  2829: ff76a2           push word ptr [bp - 0x5e]
  06E32C  282C: ff76a4           push word ptr [bp - 0x5c]
  06E32F  282F: ff76a6           push word ptr [bp - 0x5a]
  06E332  2832: ff76a8           push word ptr [bp - 0x58]
  06E335  2835: ff7608           push word ptr [bp + 8]
  06E338  2838: ff7606           push word ptr [bp + 6]
  06E33B  283B: 0e               push cs
  06E33C  283C: e8dd14           call 0x3d1c
  06E33F  283F: 83c40c           add sp, 0xc
  06E342  2842: ff7608           push word ptr [bp + 8]
  06E345  2845: ff7606           push word ptr [bp + 6]
  06E348  2848: b80100           mov ax, 1
  06E34B  284B: 99               cdq 
  06E34C  284C: 8bd8             mov bx, ax
  06E34E  284E: e81dfb           call 0x236e
  06E351  2851: c706621f0000     mov word ptr [0x1f62], 0
  06E357  2857: ff7608           push word ptr [bp + 8]
  06E35A  285A: ff7606           push word ptr [bp + 6]
  06E35D  285D: b80100           mov ax, 1
  06E360  2860: e885ec           call 0x14e8
  06E363  2863: ff7608           push word ptr [bp + 8]
  06E366  2866: ff7606           push word ptr [bp + 6]
  06E369  2869: 2bc0             sub ax, ax
  06E36B  286B: e85ef6           call 0x1ecc
  06E36E  286E: ff7608           push word ptr [bp + 8]
  06E371  2871: ff7606           push word ptr [bp + 6]
  06E374  2874: 2bc0             sub ax, ax
  06E376  2876: e8ebf8           call 0x2164
  06E379  2879: 833e5c1f00       cmp word ptr [0x1f5c], 0
  06E37E  287E: 7d0d             jge 0x288d
  06E380  2880: ff7608           push word ptr [bp + 8]
  06E383  2883: ff7606           push word ptr [bp + 6]
  06E386  2886: 0e               push cs
  06E387  2887: e8a114           call 0x3d2b
  06E38A  288A: 83c404           add sp, 4
  06E38D  288D: ff7608           push word ptr [bp + 8]
  06E390  2890: ff7606           push word ptr [bp + 6]
  06E393  2893: 0e               push cs
  06E394  2894: e8b214           call 0x3d49
  06E397  2897: 83c404           add sp, 4
  06E39A  289A: ff7608           push word ptr [bp + 8]
  06E39D  289D: ff7606           push word ptr [bp + 6]
  06E3A0  28A0: e8e9f4           call 0x1d8c
  06E3A3  28A3: c746aa0000       mov word ptr [bp - 0x56], 0
  06E3A8  28A8: 8b46aa           mov ax, word ptr [bp - 0x56]
  06E3AB  28AB: c9               leave 
  06E3AC  28AC: cb               retf 

; ---- func_06E3AE  size=34  insns=15  prologue=push bp;mov bp,sp  terminal=RETF ----
  06E3AE  28AE: 55               push bp
  06E3AF  28AF: 8bec             mov bp, sp
  06E3B1  28B1: 8b460a           mov ax, word ptr [bp + 0xa]
  06E3B4  28B4: 8b560c           mov dx, word ptr [bp + 0xc]
  06E3B7  28B7: c45e06           les bx, ptr [bp + 6]
  06E3BA  28BA: 26894750         mov word ptr es:[bx + 0x50], ax
  06E3BE  28BE: 26895752         mov word ptr es:[bx + 0x52], dx
  06E3C2  28C2: 06               push es
  06E3C3  28C3: 53               push bx
  06E3C4  28C4: 2bc0             sub ax, ax
  06E3C6  28C6: ba0100           mov dx, 1
  06E3C9  28C9: 8bda             mov bx, dx
  06E3CB  28CB: e8a0fa           call 0x236e
  06E3CE  28CE: c9               leave 
  06E3CF  28CF: cb               retf 

; ---- func_06E3D0  size=2820  insns=895  prologue=ENTER 0x0038,0  terminal=RETF imm16 ----
  06E3D0  28D0: c8380000         enter 0x38, 0
  06E3D4  28D4: 56               push si
  06E3D5  28D5: c746f40100       mov word ptr [bp - 0xc], 1
  06E3DA  28DA: 833e5c1f07       cmp word ptr [0x1f5c], 7
  06E3DF  28DF: 7e05             jle 0x28e6
  06E3E1  28E1: b80100           mov ax, 1
  06E3E4  28E4: eb02             jmp 0x28e8
  06E3E6  28E6: 2bc0             sub ax, ax
  06E3E8  28E8: 8946e0           mov word ptr [bp - 0x20], ax
  06E3EB  28EB: 2bc0             sub ax, ax
  06E3ED  28ED: 8946fe           mov word ptr [bp - 2], ax
  06E3F0  28F0: a3681f           mov word ptr [0x1f68], ax
  06E3F3  28F3: c45e06           les bx, ptr [bp + 6]
  06E3F6  28F6: 26f6470a10       test byte ptr es:[bx + 0xa], 0x10
  06E3FB  28FB: 7409             je 0x2906
  06E3FD  28FD: c7068a1f0100     mov word ptr [0x1f8a], 1
  06E403  2903: eb04             jmp 0x2909
  06E405  2905: 90               nop 
  06E406  2906: a38a1f           mov word ptr [0x1f8a], ax
  06E409  2909: a3621f           mov word ptr [0x1f62], ax
  06E40C  290C: 9ab80f1f19       lcall 0x191f, 0xfb8
  06E411  2911: eb06             jmp 0x2919
  06E413  2913: 90               nop 
  06E414  2914: 9ae0031f18       lcall 0x181f, 0x3e0
  06E419  2919: 9af6001f18       lcall 0x181f, 0xf6
  06E41E  291E: 0bc0             or ax, ax
  06E420  2920: 75f2             jne 0x2914
  06E422  2922: c45e06           les bx, ptr [bp + 6]
  06E425  2925: 26f6470a04       test byte ptr es:[bx + 0xa], 4
  06E42A  292A: 742e             je 0x295a
  06E42C  292C: 8946de           mov word ptr [bp - 0x22], ax
  06E42F  292F: eb1d             jmp 0x294e
  06E431  2931: 90               nop 
  06E432  2932: 8bc8             mov cx, ax
  06E434  2934: 2aed             sub ch, ch
  06E436  2936: ba0100           mov dx, 1
  06E439  2939: d3e2             shl dx, cl
  06E43B  293B: 2316541f         and dx, word ptr [0x1f54]
  06E43F  293F: 52               push dx
  06E440  2940: 40               inc ax
  06E441  2941: 50               push ax
  06E442  2942: 06               push es
  06E443  2943: 53               push bx
  06E444  2944: 0e               push cs
  06E445  2945: e8f213           call 0x3d3a
  06E448  2948: 83c408           add sp, 8
  06E44B  294B: ff46de           inc word ptr [bp - 0x22]
  06E44E  294E: 8b46de           mov ax, word ptr [bp - 0x22]
  06E451  2951: c45e06           les bx, ptr [bp + 6]
  06E454  2954: 26394702         cmp word ptr es:[bx + 2], ax
  06E458  2958: 7fd8             jg 0x2932
  06E45A  295A: 26c7070000       mov word ptr es:[bx], 0
  06E45F  295F: 26ffb78200       push word ptr es:[bx + 0x82]
  06E464  2964: 26ffb78000       push word ptr es:[bx + 0x80]
  06E469  2969: e8fae8           call 0x1266
  06E46C  296C: 83c404           add sp, 4
  06E46F  296F: c45e06           les bx, ptr [bp + 6]
  06E472  2972: 26034746         add ax, word ptr es:[bx + 0x46]
  06E476  2976: 8946f8           mov word ptr [bp - 8], ax
  06E479  2979: 833e5c1f00       cmp word ptr [0x1f5c], 0
  06E47E  297E: 7c05             jl 0x2985
  06E480  2980: 06               push es
  06E481  2981: 53               push bx
  06E482  2982: e80dda           call 0x392
  06E485  2985: 833e5e1f00       cmp word ptr [0x1f5e], 0
  06E48A  298A: 7c09             jl 0x2995
  06E48C  298C: ff7608           push word ptr [bp + 8]
  06E48F  298F: ff7606           push word ptr [bp + 6]
  06E492  2992: e87dda           call 0x412
  06E495  2995: 833e601f00       cmp word ptr [0x1f60], 0
  06E49A  299A: 7c09             jl 0x29a5
  06E49C  299C: ff7608           push word ptr [bp + 8]
  06E49F  299F: ff7606           push word ptr [bp + 6]
  06E4A2  29A2: e897da           call 0x43c
  06E4A5  29A5: ff7608           push word ptr [bp + 8]
  06E4A8  29A8: ff7606           push word ptr [bp + 6]
  06E4AB  29AB: e8b8da           call 0x466
  06E4AE  29AE: c45e06           les bx, ptr [bp + 6]
  06E4B1  29B1: 268b476a         mov ax, word ptr es:[bx + 0x6a]
  06E4B5  29B5: 260b4768         or ax, word ptr es:[bx + 0x68]
  06E4B9  29B9: 7420             je 0x29db
  06E4BB  29BB: 268b4768         mov ax, word ptr es:[bx + 0x68]
  06E4BF  29BF: 268b576a         mov dx, word ptr es:[bx + 0x6a]
  06E4C3  29C3: 8946ea           mov word ptr [bp - 0x16], ax
  06E4C6  29C6: 8956ec           mov word ptr [bp - 0x14], dx
  06E4C9  29C9: 8ec2             mov es, dx
  06E4CB  29CB: 8bd8             mov bx, ax
  06E4CD  29CD: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06E4D1  29D1: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06E4D5  29D5: 8946e2           mov word ptr [bp - 0x1e], ax
  06E4D8  29D8: 8956e4           mov word ptr [bp - 0x1c], dx
  06E4DB  29DB: ff7608           push word ptr [bp + 8]
  06E4DE  29DE: ff7606           push word ptr [bp + 6]
  06E4E1  29E1: e832ee           call 0x1816
  06E4E4  29E4: 0bc0             or ax, ax
  06E4E6  29E6: 7403             je 0x29eb
  06E4E8  29E8: e97d09           jmp 0x3368
  06E4EB  29EB: 39066e1f         cmp word ptr [0x1f6e], ax
  06E4EF  29EF: 742c             je 0x2a1d
  06E4F1  29F1: ff36ae2d         push word ptr [0x2dae]
  06E4F5  29F5: ff36ac2d         push word ptr [0x2dac]
  06E4F9  29F9: ff36aa2d         push word ptr [0x2daa]
  06E4FD  29FD: ff36a82d         push word ptr [0x2da8]
  06E501  2A01: ff36a483         push word ptr [0x83a4]
  06E505  2A05: ff36a283         push word ptr [0x83a2]
  06E509  2A09: ff36a083         push word ptr [0x83a0]
  06E50D  2A0D: ff369e83         push word ptr [0x839e]
  06E511  2A11: 68c800           push 0xc8
  06E514  2A14: 99               cdq 
  06E515  2A15: bb4001           mov bx, 0x140
  06E518  2A18: 9a44041f18       lcall 0x181f, 0x444
  06E51D  2A1D: c45e06           les bx, ptr [bp + 6]
  06E520  2A20: 26f6470a08       test byte ptr es:[bx + 0xa], 8
  06E525  2A25: 7520             jne 0x2a47
  06E527  2A27: 26ff7718         push word ptr es:[bx + 0x18]
  06E52B  2A2B: 26ff771a         push word ptr es:[bx + 0x1a]
  06E52F  2A2F: 26ff771c         push word ptr es:[bx + 0x1c]
  06E533  2A33: 26ff771e         push word ptr es:[bx + 0x1e]
  06E537  2A37: 8d1ea82d         lea bx, [0x2da8]
  06E53B  2A3B: b8f8ff           mov ax, 0xfff8
  06E53E  2A3E: 99               cdq 
  06E53F  2A3F: 9a64031f1a       lcall 0x1a1f, 0x364
  06E544  2A44: 8946e8           mov word ptr [bp - 0x18], ax
  06E547  2A47: c746f60100       mov word ptr [bp - 0xa], 1
  06E54C  2A4C: 9a06000c0c       lcall 0xc0c, 6
  06E551  2A51: 8946f0           mov word ptr [bp - 0x10], ax
  06E554  2A54: 8956f2           mov word ptr [bp - 0xe], dx
  06E557  2A57: 9a7a041f18       lcall 0x181f, 0x47a
  06E55C  2A5C: 833e641f00       cmp word ptr [0x1f64], 0
  06E561  2A61: 741d             je 0x2a80
  06E563  2A63: a17203           mov ax, word ptr [0x372]
  06E566  2A66: 8946dc           mov word ptr [bp - 0x24], ax
  06E569  2A69: c70672030000     mov word ptr [0x372], 0
  06E56F  2A6F: 6800a0           push 0xa000
  06E572  2A72: 6800fc           push 0xfc00
  06E575  2A75: 9af4031f18       lcall 0x181f, 0x3f4
  06E57A  2A7A: 8b46dc           mov ax, word ptr [bp - 0x24]
  06E57D  2A7D: a37203           mov word ptr [0x372], ax
  06E580  2A80: c45e06           les bx, ptr [bp + 6]
  06E583  2A83: 26f6470a20       test byte ptr es:[bx + 0xa], 0x20
  06E588  2A88: 740c             je 0x2a96
  06E58A  2A8A: 06               push es
  06E58B  2A8B: 53               push bx
  06E58C  2A8C: 0e               push cs
  06E58D  2A8D: e8b412           call 0x3d44
  06E590  2A90: 83c404           add sp, 4
  06E593  2A93: e9d208           jmp 0x3368
  06E596  2A96: 9a70041f18       lcall 0x181f, 0x470
  06E59B  2A9B: 2bc0             sub ax, ax
  06E59D  2A9D: 9a66041f18       lcall 0x181f, 0x466
  06E5A2  2AA2: c746d40000       mov word ptr [bp - 0x2c], 0
  06E5A7  2AA7: 833ef60700       cmp word ptr [0x7f6], 0
  06E5AC  2AAC: 7503             jne 0x2ab1
  06E5AE  2AAE: e96901           jmp 0x2c1a
  06E5B1  2AB1: 833ef00700       cmp word ptr [0x7f0], 0
  06E5B6  2AB6: 7503             jne 0x2abb
  06E5B8  2AB8: e95f01           jmp 0x2c1a
  06E5BB  2ABB: a1e807           mov ax, word ptr [0x7e8]
  06E5BE  2ABE: c45e06           les bx, ptr [bp + 6]
  06E5C1  2AC1: 26394710         cmp word ptr es:[bx + 0x10], ax
  06E5C5  2AC5: 7f22             jg 0x2ae9
  06E5C7  2AC7: 8b0eea07         mov cx, word ptr [0x7ea]
  06E5CB  2ACB: 26394f12         cmp word ptr es:[bx + 0x12], cx
  06E5CF  2ACF: 7f18             jg 0x2ae9
  06E5D1  2AD1: 268b5714         mov dx, word ptr es:[bx + 0x14]
  06E5D5  2AD5: 26035710         add dx, word ptr es:[bx + 0x10]
  06E5D9  2AD9: 3bd0             cmp dx, ax
  06E5DB  2ADB: 7e0c             jle 0x2ae9
  06E5DD  2ADD: 268b4716         mov ax, word ptr es:[bx + 0x16]
  06E5E1  2AE1: 26034712         add ax, word ptr es:[bx + 0x12]
  06E5E5  2AE5: 3bc1             cmp ax, cx
  06E5E7  2AE7: 7f1d             jg 0x2b06
  06E5E9  2AE9: c746fe0100       mov word ptr [bp - 2], 1
  06E5EE  2AEE: 2bc0             sub ax, ax
  06E5F0  2AF0: 2689474e         mov word ptr es:[bx + 0x4e], ax
  06E5F4  2AF4: 2689474c         mov word ptr es:[bx + 0x4c], ax
  06E5F8  2AF8: 50               push ax
  06E5F9  2AF9: 50               push ax
  06E5FA  2AFA: 06               push es
  06E5FB  2AFB: 53               push bx
  06E5FC  2AFC: 0e               push cs
  06E5FD  2AFD: e82612           call 0x3d26
  06E600  2B00: 83c408           add sp, 8
  06E603  2B03: e91401           jmp 0x2c1a
  06E606  2B06: 268b4756         mov ax, word ptr es:[bx + 0x56]
  06E60A  2B0A: 260b4754         or ax, word ptr es:[bx + 0x54]
  06E60E  2B0E: 747c             je 0x2b8c
  06E610  2B10: 268b4754         mov ax, word ptr es:[bx + 0x54]
  06E614  2B14: 268b5756         mov dx, word ptr es:[bx + 0x56]
  06E618  2B18: 8946d0           mov word ptr [bp - 0x30], ax
  06E61B  2B1B: 8956d2           mov word ptr [bp - 0x2e], dx
  06E61E  2B1E: 268b4726         mov ax, word ptr es:[bx + 0x26]
  06E622  2B22: 8946ee           mov word ptr [bp - 0x12], ax
  06E625  2B25: c746da0000       mov word ptr [bp - 0x26], 0
  06E62A  2B2A: 8bc2             mov ax, dx
  06E62C  2B2C: 0b46d0           or ax, word ptr [bp - 0x30]
  06E62F  2B2F: 7503             jne 0x2b34
  06E631  2B31: e9db00           jmp 0x2c0f
  06E634  2B34: 8b46ee           mov ax, word ptr [bp - 0x12]
  06E637  2B37: 48               dec ax
  06E638  2B38: 3b06ea07         cmp ax, word ptr [0x7ea]
  06E63C  2B3C: 7f2c             jg 0x2b6a
  06E63E  2B3E: 8b46f8           mov ax, word ptr [bp - 8]
  06E641  2B41: 0346ee           add ax, word ptr [bp - 0x12]
  06E644  2B44: 48               dec ax
  06E645  2B45: 3b06ea07         cmp ax, word ptr [0x7ea]
  06E649  2B49: 7e1f             jle 0x2b6a
  06E64B  2B4B: c45ed0           les bx, ptr [bp - 0x30]
  06E64E  2B4E: 26f60701         test byte ptr es:[bx], 1
  06E652  2B52: 7516             jne 0x2b6a
  06E654  2B54: c47606           les si, ptr [bp + 6]
  06E657  2B57: 8bc3             mov ax, bx
  06E659  2B59: 2689444c         mov word ptr es:[si + 0x4c], ax
  06E65D  2B5D: 2689544e         mov word ptr es:[si + 0x4e], dx
  06E661  2B61: b80100           mov ax, 1
  06E664  2B64: 8946da           mov word ptr [bp - 0x26], ax
  06E667  2B67: 8946fe           mov word ptr [bp - 2], ax
  06E66A  2B6A: 8b46f8           mov ax, word ptr [bp - 8]
  06E66D  2B6D: 0146ee           add word ptr [bp - 0x12], ax
  06E670  2B70: c45ed0           les bx, ptr [bp - 0x30]
  06E673  2B73: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06E677  2B77: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06E67B  2B7B: 8946d0           mov word ptr [bp - 0x30], ax
  06E67E  2B7E: 8956d2           mov word ptr [bp - 0x2e], dx
  06E681  2B81: 837eda00         cmp word ptr [bp - 0x26], 0
  06E685  2B85: 74a3             je 0x2b2a
  06E687  2B87: e98500           jmp 0x2c0f
  06E68A  2B8A: 90               nop 
  06E68B  2B8B: 90               nop 
  06E68C  2B8C: 268b475e         mov ax, word ptr es:[bx + 0x5e]
  06E690  2B90: 260b475c         or ax, word ptr es:[bx + 0x5c]
  06E694  2B94: 7503             jne 0x2b99
  06E696  2B96: e98100           jmp 0x2c1a
  06E699  2B99: 268b475c         mov ax, word ptr es:[bx + 0x5c]
  06E69D  2B9D: 268b575e         mov dx, word ptr es:[bx + 0x5e]
  06E6A1  2BA1: 8946ea           mov word ptr [bp - 0x16], ax
  06E6A4  2BA4: 8956ec           mov word ptr [bp - 0x14], dx
  06E6A7  2BA7: c746da0000       mov word ptr [bp - 0x26], 0
  06E6AC  2BAC: 8bc2             mov ax, dx
  06E6AE  2BAE: 0b46ea           or ax, word ptr [bp - 0x16]
  06E6B1  2BB1: 745c             je 0x2c0f
  06E6B3  2BB3: c45e06           les bx, ptr [bp + 6]
  06E6B6  2BB6: 268a470a         mov al, byte ptr es:[bx + 0xa]
  06E6BA  2BBA: 251000           and ax, 0x10
  06E6BD  2BBD: 3d0100           cmp ax, 1
  06E6C0  2BC0: 1bc0             sbb ax, ax
  06E6C2  2BC2: 250300           and ax, 3
  06E6C5  2BC5: 8bc8             mov cx, ax
  06E6C7  2BC7: 26034712         add ax, word ptr es:[bx + 0x12]
  06E6CB  2BCB: c476ea           les si, ptr [bp - 0x16]
  06E6CE  2BCE: 260304           add ax, word ptr es:[si]
  06E6D1  2BD1: 3b06ea07         cmp ax, word ptr [0x7ea]
  06E6D5  2BD5: 7f21             jg 0x2bf8
  06E6D7  2BD7: 26034c02         add cx, word ptr es:[si + 2]
  06E6DB  2BDB: 8e4608           mov es, word ptr [bp + 8]
  06E6DE  2BDE: 26034f12         add cx, word ptr es:[bx + 0x12]
  06E6E2  2BE2: 3b0eea07         cmp cx, word ptr [0x7ea]
  06E6E6  2BE6: 7e10             jle 0x2bf8
  06E6E8  2BE8: c746da0100       mov word ptr [bp - 0x26], 1
  06E6ED  2BED: 52               push dx
  06E6EE  2BEE: 56               push si
  06E6EF  2BEF: 06               push es
  06E6F0  2BF0: 53               push bx
  06E6F1  2BF1: 0e               push cs
  06E6F2  2BF2: e83111           call 0x3d26
  06E6F5  2BF5: 83c408           add sp, 8
  06E6F8  2BF8: c45eea           les bx, ptr [bp - 0x16]
  06E6FB  2BFB: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06E6FF  2BFF: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06E703  2C03: 8946ea           mov word ptr [bp - 0x16], ax
  06E706  2C06: 8956ec           mov word ptr [bp - 0x14], dx
  06E709  2C09: 837eda00         cmp word ptr [bp - 0x26], 0
  06E70D  2C0D: 749d             je 0x2bac
  06E70F  2C0F: 837eda00         cmp word ptr [bp - 0x26], 0
  06E713  2C13: 7505             jne 0x2c1a
  06E715  2C15: c746d40100       mov word ptr [bp - 0x2c], 1
  06E71A  2C1A: 837ef600         cmp word ptr [bp - 0xa], 0
  06E71E  2C1E: 7503             jne 0x2c23
  06E720  2C20: e9d102           jmp 0x2ef4
  06E723  2C23: 9af6001f18       lcall 0x181f, 0xf6
  06E728  2C28: 0bc0             or ax, ax
  06E72A  2C2A: 7503             jne 0x2c2f
  06E72C  2C2C: e9c502           jmp 0x2ef4
  06E72F  2C2F: 9ae0031f18       lcall 0x181f, 0x3e0
  06E734  2C34: 8946ca           mov word ptr [bp - 0x36], ax
  06E737  2C37: c45e06           les bx, ptr [bp + 6]
  06E73A  2C3A: 268b4762         mov ax, word ptr es:[bx + 0x62]
  06E73E  2C3E: 260b4760         or ax, word ptr es:[bx + 0x60]
  06E742  2C42: 7503             jne 0x2c47
  06E744  2C44: e92301           jmp 0x2d6a
  06E747  2C47: 268b4760         mov ax, word ptr es:[bx + 0x60]
  06E74B  2C4B: 268b5762         mov dx, word ptr es:[bx + 0x62]
  06E74F  2C4F: 8946fa           mov word ptr [bp - 6], ax
  06E752  2C52: 8956fc           mov word ptr [bp - 4], dx
  06E755  2C55: 8b46ca           mov ax, word ptr [bp - 0x36]
  06E758  2C58: 2d0800           sub ax, 8
  06E75B  2C5B: 7503             jne 0x2c60
  06E75D  2C5D: e9a200           jmp 0x2d02
  06E760  2C60: 2d0500           sub ax, 5
  06E763  2C63: 7503             jne 0x2c68
  06E765  2C65: e98702           jmp 0x2eef
  06E768  2C68: 2d0e00           sub ax, 0xe
  06E76B  2C6B: 7503             jne 0x2c70
  06E76D  2C6D: e97a02           jmp 0x2eea
  06E770  2C70: 2d2001           sub ax, 0x120
  06E773  2C73: 7475             je 0x2cea
  06E775  2C75: 2d1800           sub ax, 0x18
  06E778  2C78: 7503             jne 0x2c7d
  06E77A  2C7A: e9d700           jmp 0x2d54
  06E77D  2C7D: 817eca0001       cmp word ptr [bp - 0x36], 0x100
  06E782  2C82: 7c03             jl 0x2c87
  06E784  2C84: e96d02           jmp 0x2ef4
  06E787  2C87: 8b5eca           mov bx, word ptr [bp - 0x36]
  06E78A  2C8A: f687ed2757       test byte ptr [bx + 0x27ed], 0x57
  06E78F  2C8F: 7503             jne 0x2c94
  06E791  2C91: e96002           jmp 0x2ef4
  06E794  2C94: c45efa           les bx, ptr [bp - 6]
  06E797  2C97: 26f60780         test byte ptr es:[bx], 0x80
  06E79B  2C9B: 740f             je 0x2cac
  06E79D  2C9D: 26c4770c         les si, ptr es:[bx + 0xc]
  06E7A1  2CA1: 26c60400         mov byte ptr es:[si], 0
  06E7A5  2CA5: c45efa           les bx, ptr [bp - 6]
  06E7A8  2CA8: 2680277f         and byte ptr es:[bx], 0x7f
  06E7AC  2CAC: 8a46ca           mov al, byte ptr [bp - 0x36]
  06E7AF  2CAF: 8846e6           mov byte ptr [bp - 0x1a], al
  06E7B2  2CB2: c646e700         mov byte ptr [bp - 0x19], 0
  06E7B6  2CB6: c45efa           les bx, ptr [bp - 6]
  06E7B9  2CB9: 26ff770e         push word ptr es:[bx + 0xe]
  06E7BD  2CBD: 26ff770c         push word ptr es:[bx + 0xc]
  06E7C1  2CC1: 9a3c111d0d       lcall 0xd1d, 0x113c
  06E7C6  2CC6: 83c404           add sp, 4
  06E7C9  2CC9: c45efa           les bx, ptr [bp - 6]
  06E7CC  2CCC: 263b4706         cmp ax, word ptr es:[bx + 6]
  06E7D0  2CD0: 7372             jae 0x2d44
  06E7D2  2CD2: 8d46e6           lea ax, [bp - 0x1a]
  06E7D5  2CD5: 16               push ss
  06E7D6  2CD6: 50               push ax
  06E7D7  2CD7: 26ff770e         push word ptr es:[bx + 0xe]
  06E7DB  2CDB: 26ff770c         push word ptr es:[bx + 0xc]
  06E7DF  2CDF: 9ab4111d0d       lcall 0xd1d, 0x11b4
  06E7E4  2CE4: 83c408           add sp, 8
  06E7E7  2CE7: eb5b             jmp 0x2d44
  06E7E9  2CE9: 90               nop 
  06E7EA  2CEA: 833e661f00       cmp word ptr [0x1f66], 0
  06E7EF  2CEF: 7503             jne 0x2cf4
  06E7F1  2CF1: e90002           jmp 0x2ef4
  06E7F4  2CF4: c746f60000       mov word ptr [bp - 0xa], 0
  06E7F9  2CF9: c706681f0100     mov word ptr [0x1f68], 1
  06E7FF  2CFF: e9f201           jmp 0x2ef4
  06E802  2D02: c45efa           les bx, ptr [bp - 6]
  06E805  2D05: 26ff770e         push word ptr es:[bx + 0xe]
  06E809  2D09: 26ff770c         push word ptr es:[bx + 0xc]
  06E80D  2D0D: 9a3c111d0d       lcall 0xd1d, 0x113c
  06E812  2D12: 83c404           add sp, 4
  06E815  2D15: 0bc0             or ax, ax
  06E817  2D17: 7424             je 0x2d3d
  06E819  2D19: c45efa           les bx, ptr [bp - 6]
  06E81C  2D1C: 26ff770e         push word ptr es:[bx + 0xe]
  06E820  2D20: 26ff770c         push word ptr es:[bx + 0xc]
  06E824  2D24: 9a3c111d0d       lcall 0xd1d, 0x113c
  06E829  2D29: 83c404           add sp, 4
  06E82C  2D2C: 8946c8           mov word ptr [bp - 0x38], ax
  06E82F  2D2F: c45efa           les bx, ptr [bp - 6]
  06E832  2D32: 26c45f0c         les bx, ptr es:[bx + 0xc]
  06E836  2D36: 8bf0             mov si, ax
  06E838  2D38: 26c640ff00       mov byte ptr es:[bx + si - 1], 0
  06E83D  2D3D: c45efa           les bx, ptr [bp - 6]
  06E840  2D40: 2680277f         and byte ptr es:[bx], 0x7f
  06E844  2D44: ff7608           push word ptr [bp + 8]
  06E847  2D47: ff7606           push word ptr [bp + 6]
  06E84A  2D4A: b80100           mov ax, 1
  06E84D  2D4D: e814f4           call 0x2164
  06E850  2D50: e9a101           jmp 0x2ef4
  06E853  2D53: 90               nop 
  06E854  2D54: c45efa           les bx, ptr [bp - 6]
  06E857  2D57: 26f60780         test byte ptr es:[bx], 0x80
  06E85B  2D5B: 7503             jne 0x2d60
  06E85D  2D5D: e99401           jmp 0x2ef4
  06E860  2D60: 26c4770c         les si, ptr es:[bx + 0xc]
  06E864  2D64: 26c60400         mov byte ptr es:[si], 0
  06E868  2D68: ebd3             jmp 0x2d3d
  06E86A  2D6A: 817eca0001       cmp word ptr [bp - 0x36], 0x100
  06E86F  2D6F: 7d0e             jge 0x2d7f
  06E871  2D71: 8b5eca           mov bx, word ptr [bp - 0x36]
  06E874  2D74: f687ed2702       test byte ptr [bx + 0x27ed], 2
  06E879  2D79: 7404             je 0x2d7f
  06E87B  2D7B: 836eca20         sub word ptr [bp - 0x36], 0x20
  06E87F  2D7F: 8b5e06           mov bx, word ptr [bp + 6]
  06E882  2D82: 268b4756         mov ax, word ptr es:[bx + 0x56]
  06E886  2D86: 260b4754         or ax, word ptr es:[bx + 0x54]
  06E88A  2D8A: 7403             je 0x2d8f
  06E88C  2D8C: e93b01           jmp 0x2eca
  06E88F  2D8F: 8b46ca           mov ax, word ptr [bp - 0x36]
  06E892  2D92: 2d1b00           sub ax, 0x1b
  06E895  2D95: 7503             jne 0x2d9a
  06E897  2D97: e95001           jmp 0x2eea
  06E89A  2D9A: 2d2d01           sub ax, 0x12d
  06E89D  2D9D: 7503             jne 0x2da2
  06E89F  2D9F: e99c00           jmp 0x2e3e
  06E8A2  2DA2: 2d0800           sub ax, 8
  06E8A5  2DA5: 743d             je 0x2de4
  06E8A7  2DA7: 26804f0a80       or byte ptr es:[bx + 0xa], 0x80
  06E8AC  2DAC: 268b4752         mov ax, word ptr es:[bx + 0x52]
  06E8B0  2DB0: 260b4750         or ax, word ptr es:[bx + 0x50]
  06E8B4  2DB4: 7503             jne 0x2db9
  06E8B6  2DB6: e93601           jmp 0x2eef
  06E8B9  2DB9: 26f6470a02       test byte ptr es:[bx + 0xa], 2
  06E8BE  2DBE: 7503             jne 0x2dc3
  06E8C0  2DC0: e92c01           jmp 0x2eef
  06E8C3  2DC3: 26c47750         les si, ptr es:[bx + 0x50]
  06E8C7  2DC7: 268b4404         mov ax, word ptr es:[si + 4]
  06E8CB  2DCB: 8946d8           mov word ptr [bp - 0x28], ax
  06E8CE  2DCE: 6bd81c           imul bx, ax, 0x1c
  06E8D1  2DD1: 80bf4c3100       cmp byte ptr [bx + 0x314c], 0
  06E8D6  2DD6: 7503             jne 0x2ddb
  06E8D8  2DD8: e91401           jmp 0x2eef
  06E8DB  2DDB: c6874c3100       mov byte ptr [bx + 0x314c], 0
  06E8E0  2DE0: 06               push es
  06E8E1  2DE1: 56               push si
  06E8E2  2DE2: eb4a             jmp 0x2e2e
  06E8E4  2DE4: 26804f0a80       or byte ptr es:[bx + 0xa], 0x80
  06E8E9  2DE9: 268b475e         mov ax, word ptr es:[bx + 0x5e]
  06E8ED  2DED: 260b475c         or ax, word ptr es:[bx + 0x5c]
  06E8F1  2DF1: 7503             jne 0x2df6
  06E8F3  2DF3: e9fe00           jmp 0x2ef4
  06E8F6  2DF6: 268b4752         mov ax, word ptr es:[bx + 0x52]
  06E8FA  2DFA: 260b4750         or ax, word ptr es:[bx + 0x50]
  06E8FE  2DFE: 741c             je 0x2e1c
  06E900  2E00: c45e06           les bx, ptr [bp + 6]
  06E903  2E03: 26c47750         les si, ptr es:[bx + 0x50]
  06E907  2E07: 268b4410         mov ax, word ptr es:[si + 0x10]
  06E90B  2E0B: 268b5412         mov dx, word ptr es:[si + 0x12]
  06E90F  2E0F: 8946ea           mov word ptr [bp - 0x16], ax
  06E912  2E12: 8956ec           mov word ptr [bp - 0x14], dx
  06E915  2E15: 0bd0             or dx, ax
  06E917  2E17: 7511             jne 0x2e2a
  06E919  2E19: 8e4608           mov es, word ptr [bp + 8]
  06E91C  2E1C: 268b475c         mov ax, word ptr es:[bx + 0x5c]
  06E920  2E20: 268b575e         mov dx, word ptr es:[bx + 0x5e]
  06E924  2E24: 8946ea           mov word ptr [bp - 0x16], ax
  06E927  2E27: 8956ec           mov word ptr [bp - 0x14], dx
  06E92A  2E2A: ff76ec           push word ptr [bp - 0x14]
  06E92D  2E2D: 50               push ax
  06E92E  2E2E: ff7608           push word ptr [bp + 8]
  06E931  2E31: ff7606           push word ptr [bp + 6]
  06E934  2E34: 0e               push cs
  06E935  2E35: e8ee0e           call 0x3d26
  06E938  2E38: 83c408           add sp, 8
  06E93B  2E3B: e9b600           jmp 0x2ef4
  06E93E  2E3E: 26804f0a80       or byte ptr es:[bx + 0xa], 0x80
  06E943  2E43: 268b475e         mov ax, word ptr es:[bx + 0x5e]
  06E947  2E47: 260b475c         or ax, word ptr es:[bx + 0x5c]
  06E94B  2E4B: 7503             jne 0x2e50
  06E94D  2E4D: e9a400           jmp 0x2ef4
  06E950  2E50: 268b4752         mov ax, word ptr es:[bx + 0x52]
  06E954  2E54: 260b4750         or ax, word ptr es:[bx + 0x50]
  06E958  2E58: 7414             je 0x2e6e
  06E95A  2E5A: 268b4750         mov ax, word ptr es:[bx + 0x50]
  06E95E  2E5E: 268b5752         mov dx, word ptr es:[bx + 0x52]
  06E962  2E62: 2639475c         cmp word ptr es:[bx + 0x5c], ax
  06E966  2E66: 752e             jne 0x2e96
  06E968  2E68: 2639575e         cmp word ptr es:[bx + 0x5e], dx
  06E96C  2E6C: 7528             jne 0x2e96
  06E96E  2E6E: c45e06           les bx, ptr [bp + 6]
  06E971  2E71: 268b475c         mov ax, word ptr es:[bx + 0x5c]
  06E975  2E75: 268b575e         mov dx, word ptr es:[bx + 0x5e]
  06E979  2E79: 8946ea           mov word ptr [bp - 0x16], ax
  06E97C  2E7C: 8956ec           mov word ptr [bp - 0x14], dx
  06E97F  2E7F: c45eea           les bx, ptr [bp - 0x16]
  06E982  2E82: 268b4712         mov ax, word ptr es:[bx + 0x12]
  06E986  2E86: 260b4710         or ax, word ptr es:[bx + 0x10]
  06E98A  2E8A: 7435             je 0x2ec1
  06E98C  2E8C: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06E990  2E90: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06E994  2E94: ebe3             jmp 0x2e79
  06E996  2E96: c45e06           les bx, ptr [bp + 6]
  06E999  2E99: 268b475c         mov ax, word ptr es:[bx + 0x5c]
  06E99D  2E9D: 268b575e         mov dx, word ptr es:[bx + 0x5e]
  06E9A1  2EA1: 8946ea           mov word ptr [bp - 0x16], ax
  06E9A4  2EA4: 8956ec           mov word ptr [bp - 0x14], dx
  06E9A7  2EA7: c45eea           les bx, ptr [bp - 0x16]
  06E9AA  2EAA: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06E9AE  2EAE: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06E9B2  2EB2: c45e06           les bx, ptr [bp + 6]
  06E9B5  2EB5: 26394750         cmp word ptr es:[bx + 0x50], ax
  06E9B9  2EB9: 75e6             jne 0x2ea1
  06E9BB  2EBB: 26395752         cmp word ptr es:[bx + 0x52], dx
  06E9BF  2EBF: 75e0             jne 0x2ea1
  06E9C1  2EC1: ff76ec           push word ptr [bp - 0x14]
  06E9C4  2EC4: ff76ea           push word ptr [bp - 0x16]
  06E9C7  2EC7: e964ff           jmp 0x2e2e
  06E9CA  2ECA: 8b46ca           mov ax, word ptr [bp - 0x36]
  06E9CD  2ECD: 3d2000           cmp ax, 0x20
  06E9D0  2ED0: 7503             jne 0x2ed5
  06E9D2  2ED2: e97701           jmp 0x304c
  06E9D5  2ED5: 7e03             jle 0x2eda
  06E9D7  2ED7: e95402           jmp 0x312e
  06E9DA  2EDA: 2d0d00           sub ax, 0xd
  06E9DD  2EDD: 7503             jne 0x2ee2
  06E9DF  2EDF: e96a01           jmp 0x304c
  06E9E2  2EE2: 2d0e00           sub ax, 0xe
  06E9E5  2EE5: 7403             je 0x2eea
  06E9E7  2EE7: e95c02           jmp 0x3146
  06E9EA  2EEA: 26c707ffff       mov word ptr es:[bx], 0xffff
  06E9EF  2EEF: c746f60000       mov word ptr [bp - 0xa], 0
  06E9F4  2EF4: 833e6e1f00       cmp word ptr [0x1f6e], 0
  06E9F9  2EF9: 7474             je 0x2f6f
  06E9FB  2EFB: 8b46e4           mov ax, word ptr [bp - 0x1c]
  06E9FE  2EFE: 0b46e2           or ax, word ptr [bp - 0x1e]
  06EA01  2F01: 746c             je 0x2f6f
  06EA03  2F03: 9a06000c0c       lcall 0xc0c, 6
  06EA08  2F08: 3b16b2a5         cmp dx, word ptr [0xa5b2]
  06EA0C  2F0C: 7c61             jl 0x2f6f
  06EA0E  2F0E: 7f06             jg 0x2f16
  06EA10  2F10: 3b06b0a5         cmp ax, word ptr [0xa5b0]
  06EA14  2F14: 7259             jb 0x2f6f
  06EA16  2F16: a1aea5           mov ax, word ptr [0xa5ae]
  06EA19  2F19: c45ee2           les bx, ptr [bp - 0x1e]
  06EA1C  2F1C: 26c45f0c         les bx, ptr es:[bx + 0xc]
  06EA20  2F20: 26394704         cmp word ptr es:[bx + 4], ax
  06EA24  2F24: 7e49             jle 0x2f6f
  06EA26  2F26: ff06aea5         inc word ptr [0xa5ae]
  06EA2A  2F2A: ff36a483         push word ptr [0x83a4]
  06EA2E  2F2E: ff36a283         push word ptr [0x83a2]
  06EA32  2F32: ff36a083         push word ptr [0x83a0]
  06EA36  2F36: ff369e83         push word ptr [0x839e]
  06EA3A  2F3A: ff36ae2d         push word ptr [0x2dae]
  06EA3E  2F3E: ff36ac2d         push word ptr [0x2dac]
  06EA42  2F42: ff36aa2d         push word ptr [0x2daa]
  06EA46  2F46: ff36a82d         push word ptr [0x2da8]
  06EA4A  2F4A: 68c800           push 0xc8
  06EA4D  2F4D: 2bc0             sub ax, ax
  06EA4F  2F4F: 99               cdq 
  06EA50  2F50: bb4001           mov bx, 0x140
  06EA53  2F53: 9a44041f18       lcall 0x181f, 0x444
  06EA58  2F58: c746f40100       mov word ptr [bp - 0xc], 1
  06EA5D  2F5D: 9a06000c0c       lcall 0xc0c, 6
  06EA62  2F62: 050a00           add ax, 0xa
  06EA65  2F65: 83d200           adc dx, 0
  06EA68  2F68: a3b0a5           mov word ptr [0xa5b0], ax
  06EA6B  2F6B: 8916b2a5         mov word ptr [0xa5b2], dx
  06EA6F  2F6F: 837ef400         cmp word ptr [bp - 0xc], 0
  06EA73  2F73: 7503             jne 0x2f78
  06EA75  2F75: e9de01           jmp 0x3156
  06EA78  2F78: ff7608           push word ptr [bp + 8]
  06EA7B  2F7B: ff7606           push word ptr [bp + 6]
  06EA7E  2F7E: 0e               push cs
  06EA7F  2F7F: e8c20d           call 0x3d44
  06EA82  2F82: 83c404           add sp, 4
  06EA85  2F85: e9e001           jmp 0x3168
  06EA88  2F88: c746d60000       mov word ptr [bp - 0x2a], 0
  06EA8D  2F8D: c45e06           les bx, ptr [bp + 6]
  06EA90  2F90: 268b474e         mov ax, word ptr es:[bx + 0x4e]
  06EA94  2F94: 260b474c         or ax, word ptr es:[bx + 0x4c]
  06EA98  2F98: 7418             je 0x2fb2
  06EA9A  2F9A: 8cc0             mov ax, es
  06EA9C  2F9C: 26c4774c         les si, ptr es:[bx + 0x4c]
  06EAA0  2FA0: 268b4c10         mov cx, word ptr es:[si + 0x10]
  06EAA4  2FA4: 268b5412         mov dx, word ptr es:[si + 0x12]
  06EAA8  2FA8: 8ec0             mov es, ax
  06EAAA  2FAA: 26894f4c         mov word ptr es:[bx + 0x4c], cx
  06EAAE  2FAE: 2689574e         mov word ptr es:[bx + 0x4e], dx
  06EAB2  2FB2: c45e06           les bx, ptr [bp + 6]
  06EAB5  2FB5: 268b474e         mov ax, word ptr es:[bx + 0x4e]
  06EAB9  2FB9: 260b474c         or ax, word ptr es:[bx + 0x4c]
  06EABD  2FBD: 7513             jne 0x2fd2
  06EABF  2FBF: 268b4754         mov ax, word ptr es:[bx + 0x54]
  06EAC3  2FC3: 268b5756         mov dx, word ptr es:[bx + 0x56]
  06EAC7  2FC7: 2689474c         mov word ptr es:[bx + 0x4c], ax
  06EACB  2FCB: 2689574e         mov word ptr es:[bx + 0x4e], dx
  06EACF  2FCF: ff46d6           inc word ptr [bp - 0x2a]
  06EAD2  2FD2: c45e06           les bx, ptr [bp + 6]
  06EAD5  2FD5: 26c45f4c         les bx, ptr es:[bx + 0x4c]
  06EAD9  2FD9: 26f60701         test byte ptr es:[bx], 1
  06EADD  2FDD: 7503             jne 0x2fe2
  06EADF  2FDF: e9a300           jmp 0x3085
  06EAE2  2FE2: 837ed602         cmp word ptr [bp - 0x2a], 2
  06EAE6  2FE6: 7ca5             jl 0x2f8d
  06EAE8  2FE8: e99a00           jmp 0x3085
  06EAEB  2FEB: 90               nop 
  06EAEC  2FEC: c746d60000       mov word ptr [bp - 0x2a], 0
  06EAF1  2FF1: c45e06           les bx, ptr [bp + 6]
  06EAF4  2FF4: 268b474e         mov ax, word ptr es:[bx + 0x4e]
  06EAF8  2FF8: 260b474c         or ax, word ptr es:[bx + 0x4c]
  06EAFC  2FFC: 7418             je 0x3016
  06EAFE  2FFE: 8cc0             mov ax, es
  06EB00  3000: 26c4774c         les si, ptr es:[bx + 0x4c]
  06EB04  3004: 268b4c14         mov cx, word ptr es:[si + 0x14]
  06EB08  3008: 268b5416         mov dx, word ptr es:[si + 0x16]
  06EB0C  300C: 8ec0             mov es, ax
  06EB0E  300E: 26894f4c         mov word ptr es:[bx + 0x4c], cx
  06EB12  3012: 2689574e         mov word ptr es:[bx + 0x4e], dx
  06EB16  3016: c45e06           les bx, ptr [bp + 6]
  06EB19  3019: 268b474e         mov ax, word ptr es:[bx + 0x4e]
  06EB1D  301D: 260b474c         or ax, word ptr es:[bx + 0x4c]
  06EB21  3021: 7513             jne 0x3036
  06EB23  3023: 268b4770         mov ax, word ptr es:[bx + 0x70]
  06EB27  3027: 268b5772         mov dx, word ptr es:[bx + 0x72]
  06EB2B  302B: 2689474c         mov word ptr es:[bx + 0x4c], ax
  06EB2F  302F: 2689574e         mov word ptr es:[bx + 0x4e], dx
  06EB33  3033: ff46d6           inc word ptr [bp - 0x2a]
  06EB36  3036: c45e06           les bx, ptr [bp + 6]
  06EB39  3039: 26c45f4c         les bx, ptr es:[bx + 0x4c]
  06EB3D  303D: 26f60701         test byte ptr es:[bx], 1
  06EB41  3041: 7442             je 0x3085
  06EB43  3043: 837ed602         cmp word ptr [bp - 0x2a], 2
  06EB47  3047: 7ca8             jl 0x2ff1
  06EB49  3049: eb3a             jmp 0x3085
  06EB4B  304B: 90               nop 
  06EB4C  304C: c45e06           les bx, ptr [bp + 6]
  06EB4F  304F: 268b474e         mov ax, word ptr es:[bx + 0x4e]
  06EB53  3053: 260b474c         or ax, word ptr es:[bx + 0x4c]
  06EB57  3057: 7503             jne 0x305c
  06EB59  3059: e998fe           jmp 0x2ef4
  06EB5C  305C: 26f6470a04       test byte ptr es:[bx + 0xa], 4
  06EB61  3061: 742b             je 0x308e
  06EB63  3063: 837eca0d         cmp word ptr [bp - 0x36], 0xd
  06EB67  3067: 7411             je 0x307a
  06EB69  3069: 26c45f4c         les bx, ptr es:[bx + 0x4c]
  06EB6D  306D: 26837f0601       cmp word ptr es:[bx + 6], 1
  06EB72  3072: 1bc0             sbb ax, ax
  06EB74  3074: f7d8             neg ax
  06EB76  3076: 26894706         mov word ptr es:[bx + 6], ax
  06EB7A  307A: 837eca0d         cmp word ptr [bp - 0x36], 0xd
  06EB7E  307E: 7505             jne 0x3085
  06EB80  3080: c746f60000       mov word ptr [bp - 0xa], 0
  06EB85  3085: c746fe0100       mov word ptr [bp - 2], 1
  06EB8A  308A: e967fe           jmp 0x2ef4
  06EB8D  308D: 90               nop 
  06EB8E  308E: 817eca3b01       cmp word ptr [bp - 0x36], 0x13b
  06EB93  3093: 750a             jne 0x309f
  06EB95  3095: 833e661f00       cmp word ptr [0x1f66], 0
  06EB9A  309A: 7503             jne 0x309f
  06EB9C  309C: e955fe           jmp 0x2ef4
  06EB9F  309F: 26c4774c         les si, ptr es:[bx + 0x4c]
  06EBA3  30A3: 268b4404         mov ax, word ptr es:[si + 4]
  06EBA7  30A7: 8e4608           mov es, word ptr [bp + 8]
  06EBAA  30AA: 268907           mov word ptr es:[bx], ax
  06EBAD  30AD: c746f60000       mov word ptr [bp - 0xa], 0
  06EBB2  30B2: 817eca3b01       cmp word ptr [bp - 0x36], 0x13b
  06EBB7  30B7: 7403             je 0x30bc
  06EBB9  30B9: e938fe           jmp 0x2ef4
  06EBBC  30BC: e93afc           jmp 0x2cf9
  06EBBF  30BF: 90               nop 
  06EBC0  30C0: 8b46d2           mov ax, word ptr [bp - 0x2e]
  06EBC3  30C3: 0b46d0           or ax, word ptr [bp - 0x30]
  06EBC6  30C6: 7428             je 0x30f0
  06EBC8  30C8: 8b46ca           mov ax, word ptr [bp - 0x36]
  06EBCB  30CB: c45ed0           les bx, ptr [bp - 0x30]
  06EBCE  30CE: 26394702         cmp word ptr es:[bx + 2], ax
  06EBD2  30D2: 7508             jne 0x30dc
  06EBD4  30D4: c746da0100       mov word ptr [bp - 0x26], 1
  06EBD9  30D9: eb0f             jmp 0x30ea
  06EBDB  30DB: 90               nop 
  06EBDC  30DC: 268b4710         mov ax, word ptr es:[bx + 0x10]
  06EBE0  30E0: 268b5712         mov dx, word ptr es:[bx + 0x12]
  06EBE4  30E4: 8946d0           mov word ptr [bp - 0x30], ax
  06EBE7  30E7: 8956d2           mov word ptr [bp - 0x2e], dx
  06EBEA  30EA: 837eda00         cmp word ptr [bp - 0x26], 0
  06EBEE  30EE: 74d0             je 0x30c0
  06EBF0  30F0: 837eda00         cmp word ptr [bp - 0x26], 0
  06EBF4  30F4: 7503             jne 0x30f9
  06EBF6  30F6: e9fbfd           jmp 0x2ef4
  06EBF9  30F9: 8b46d0           mov ax, word ptr [bp - 0x30]
  06EBFC  30FC: 8b56d2           mov dx, word ptr [bp - 0x2e]
  06EBFF  30FF: c45e06           les bx, ptr [bp + 6]
  06EC02  3102: 2689474c         mov word ptr es:[bx + 0x4c], ax
  06EC06  3106: 2689574e         mov word ptr es:[bx + 0x4e], dx
  06EC0A  310A: c746fe0100       mov word ptr [bp - 2], 1
  06EC0F  310F: 26f6470a04       test byte ptr es:[bx + 0xa], 4
  06EC14  3114: 7503             jne 0x3119
  06EC16  3116: e9d6fd           jmp 0x2eef
  06EC19  3119: 8ec2             mov es, dx
  06EC1B  311B: 8bd8             mov bx, ax
  06EC1D  311D: 26837f0601       cmp word ptr es:[bx + 6], 1
  06EC22  3122: 1bc0             sbb ax, ax
  06EC24  3124: f7d8             neg ax
  06EC26  3126: 26894706         mov word ptr es:[bx + 6], ax
  06EC2A  312A: e9c7fd           jmp 0x2ef4
  06EC2D  312D: 90               nop 
  06EC2E  312E: 2d3b01           sub ax, 0x13b
  06EC31  3131: 7503             jne 0x3136
  06EC33  3133: e916ff           jmp 0x304c
  06EC36  3136: 2d0d00           sub ax, 0xd
  06EC39  3139: 7503             jne 0x313e
  06EC3B  313B: e9aefe           jmp 0x2fec
  06EC3E  313E: 2d0800           sub ax, 8
  06EC41  3141: 7503             jne 0x3146
  06EC43  3143: e942fe           jmp 0x2f88
  06EC46  3146: c746da0000       mov word ptr [bp - 0x26], 0
  06EC4B  314B: 268b4754         mov ax, word ptr es:[bx + 0x54]
  06EC4F  314F: 268b5756         mov dx, word ptr es:[bx + 0x56]
  06EC53  3153: eb8f             jmp 0x30e4
  06EC55  3155: 90               nop 
  06EC56  3156: 837efe00         cmp word ptr [bp - 2], 0
  06EC5A  315A: 740c             je 0x3168
  06EC5C  315C: ff7608           push word ptr [bp + 8]
  06EC5F  315F: ff7606           push word ptr [bp + 6]
  06EC62  3162: b80100           mov ax, 1
  06EC65  3165: e864ed           call 0x1ecc
  06EC68  3168: 2bc0             sub ax, ax
  06EC6A  316A: 8946f4           mov word ptr [bp - 0xc], ax
  06EC6D  316D: 8946fe           mov word ptr [bp - 2], ax
  06EC70  3170: 3906f407         cmp word ptr [0x7f4], ax
  06EC74  3174: 7432             je 0x31a8
  06EC76  3176: 3946d4           cmp word ptr [bp - 0x2c], ax
  06EC79  3179: 752d             jne 0x31a8
  06EC7B  317B: c45e06           les bx, ptr [bp + 6]
  06EC7E  317E: 268b4756         mov ax, word ptr es:[bx + 0x56]
  06EC82  3182: 260b4754         or ax, word ptr es:[bx + 0x54]
  06EC86  3186: 7476             je 0x31fe
  06EC88  3188: 268b474e         mov ax, word ptr es:[bx + 0x4e]
  06EC8C  318C: 260b474c         or ax, word ptr es:[bx + 0x4c]
  06EC90  3190: 7507             jne 0x3199
  06EC92  3192: 26f6470a01       test byte ptr es:[bx + 0xa], 1
  06EC97  3197: 740f             je 0x31a8
  06EC99  3199: 268b474e         mov ax, word ptr es:[bx + 0x4e]
  06EC9D  319D: 260b474c         or ax, word ptr es:[bx + 0x4c]
  06ECA1  31A1: 753b             jne 0x31de
  06ECA3  31A3: c746f60000       mov word ptr [bp - 0xa], 0
  06ECA8  31A8: 833ef40700       cmp word ptr [0x7f4], 0
  06ECAD  31AD: 741a             je 0x31c9
  06ECAF  31AF: 837ef600         cmp word ptr [bp - 0xa], 0
  06ECB3  31B3: 7514             jne 0x31c9
  06ECB5  31B5: 833e661f00       cmp word ptr [0x1f66], 0
  06ECBA  31BA: 740d             je 0x31c9
  06ECBC  31BC: 833ee40700       cmp word ptr [0x7e4], 0
  06ECC1  31C1: 7406             je 0x31c9
  06ECC3  31C3: c706681f0100     mov word ptr [0x1f68], 1
  06ECC9  31C9: 837ef600         cmp word ptr [bp - 0xa], 0
  06ECCD  31CD: 7479             je 0x3248
  06ECCF  31CF: 833eee0700       cmp word ptr [0x7ee], 0
  06ECD4  31D4: 7472             je 0x3248
  06ECD6  31D6: c746c80100       mov word ptr [bp - 0x38], 1
  06ECDB  31DB: eb70             jmp 0x324d
  06ECDD  31DD: 90               nop 
  06ECDE  31DE: 26f6470a04       test byte ptr es:[bx + 0xa], 4
  06ECE3  31E3: 74be             je 0x31a3
  06ECE5  31E5: 26c45f4c         les bx, ptr es:[bx + 0x4c]
  06ECE9  31E9: 26837f0601       cmp word ptr es:[bx + 6], 1
  06ECEE  31EE: 1bc0             sbb ax, ax
  06ECF0  31F0: f7d8             neg ax
  06ECF2  31F2: 26894706         mov word ptr es:[bx + 6], ax
  06ECF6  31F6: c746fe0100       mov word ptr [bp - 2], 1
  06ECFB  31FB: ebab             jmp 0x31a8
  06ECFD  31FD: 90               nop 
  06ECFE  31FE: 268b475e         mov ax, word ptr es:[bx + 0x5e]
  06ED02  3202: 260b475c         or ax, word ptr es:[bx + 0x5c]
  06ED06  3206: 749b             je 0x31a3
  06ED08  3208: 268b4752         mov ax, word ptr es:[bx + 0x52]
  06ED0C  320C: 260b4750         or ax, word ptr es:[bx + 0x50]
  06ED10  3210: 7491             je 0x31a3
  06ED12  3212: 26f6470a02       test byte ptr es:[bx + 0xa], 2
  06ED17  3217: 748a             je 0x31a3
  06ED19  3219: 26c47750         les si, ptr es:[bx + 0x50]
  06ED1D  321D: 268b4404         mov ax, word ptr es:[si + 4]
  06ED21  3221: 8946d8           mov word ptr [bp - 0x28], ax
  06ED24  3224: 6bd81c           imul bx, ax, 0x1c
  06ED27  3227: 80bf4c3100       cmp byte ptr [bx + 0x314c], 0
  06ED2C  322C: 7503             jne 0x3231
  06ED2E  322E: e972ff           jmp 0x31a3
  06ED31  3231: c6874c3100       mov byte ptr [bx + 0x314c], 0
  06ED36  3236: 06               push es
  06ED37  3237: 56               push si
  06ED38  3238: ff7608           push word ptr [bp + 8]
  06ED3B  323B: ff7606           push word ptr [bp + 6]
  06ED3E  323E: 0e               push cs
  06ED3F  323F: e8e40a           call 0x3d26
  06ED42  3242: 83c408           add sp, 8
  06ED45  3245: e960ff           jmp 0x31a8
  06ED48  3248: c746c80000       mov word ptr [bp - 0x38], 0
  06ED4D  324D: 2bc0             sub ax, ax
  06ED4F  324F: 8b56c8           mov dx, word ptr [bp - 0x38]
  06ED52  3252: 9a5c041f18       lcall 0x181f, 0x45c
  06ED57  3257: 833e260800       cmp word ptr [0x826], 0
  06ED5C  325C: 7426             je 0x3284
  06ED5E  325E: 9a06000c0c       lcall 0xc0c, 6
  06ED63  3263: 8946cc           mov word ptr [bp - 0x34], ax
  06ED66  3266: 8956ce           mov word ptr [bp - 0x32], dx
  06ED69  3269: 8b4ef0           mov cx, word ptr [bp - 0x10]
  06ED6C  326C: 8b5ef2           mov bx, word ptr [bp - 0xe]
  06ED6F  326F: 83c178           add cx, 0x78
  06ED72  3272: 83d300           adc bx, 0
  06ED75  3275: 3bd3             cmp dx, bx
  06ED77  3277: 7c0b             jl 0x3284
  06ED79  3279: 7f04             jg 0x327f
  06ED7B  327B: 3bc1             cmp ax, cx
  06ED7D  327D: 7205             jb 0x3284
  06ED7F  327F: c746f60000       mov word ptr [bp - 0xa], 0
  06ED84  3284: 837ef600         cmp word ptr [bp - 0xa], 0
  06ED88  3288: 7403             je 0x328d
  06ED8A  328A: e909f8           jmp 0x2a96
  06ED8D  328D: c45e06           les bx, ptr [bp + 6]
  06ED90  3290: 268b4762         mov ax, word ptr es:[bx + 0x62]
  06ED94  3294: 260b4760         or ax, word ptr es:[bx + 0x60]
  06ED98  3298: 741a             je 0x32b4
  06ED9A  329A: 26c45f60         les bx, ptr es:[bx + 0x60]
  06ED9E  329E: 26ff770e         push word ptr es:[bx + 0xe]
  06EDA2  32A2: 26ff770c         push word ptr es:[bx + 0xc]
  06EDA6  32A6: 1e               push ds
  06EDA7  32A7: 682098           push 0x9820
  06EDAA  32AA: 9a7e111d0d       lcall 0xd1d, 0x117e
  06EDAF  32AF: 83c408           add sp, 8
  06EDB2  32B2: eb32             jmp 0x32e6
  06EDB4  32B4: 26833f00         cmp word ptr es:[bx], 0
  06EDB8  32B8: 752c             jne 0x32e6
  06EDBA  32BA: 268b474e         mov ax, word ptr es:[bx + 0x4e]
  06EDBE  32BE: 260b474c         or ax, word ptr es:[bx + 0x4c]
  06EDC2  32C2: 740a             je 0x32ce
  06EDC4  32C4: 26c4774c         les si, ptr es:[bx + 0x4c]
  06EDC8  32C8: 268b4404         mov ax, word ptr es:[si + 4]
  06EDCC  32CC: eb12             jmp 0x32e0
  06EDCE  32CE: 268b4752         mov ax, word ptr es:[bx + 0x52]
  06EDD2  32D2: 260b4750         or ax, word ptr es:[bx + 0x50]
  06EDD6  32D6: 740e             je 0x32e6
  06EDD8  32D8: 26c47750         les si, ptr es:[bx + 0x50]
  06EDDC  32DC: 268b4406         mov ax, word ptr es:[si + 6]
  06EDE0  32E0: 8e4608           mov es, word ptr [bp + 8]
  06EDE3  32E3: 268907           mov word ptr es:[bx], ax
  06EDE6  32E6: c45e06           les bx, ptr [bp + 6]
  06EDE9  32E9: 26f6470a08       test byte ptr es:[bx + 0xa], 8
  06EDEE  32EE: 751f             jne 0x330f
  06EDF0  32F0: 26ff7718         push word ptr es:[bx + 0x18]
  06EDF4  32F4: 26ff771a         push word ptr es:[bx + 0x1a]
  06EDF8  32F8: 26ff771c         push word ptr es:[bx + 0x1c]
  06EDFC  32FC: 26ff771e         push word ptr es:[bx + 0x1e]
  06EE00  3300: 8d1ea82d         lea bx, [0x2da8]
  06EE04  3304: 8b46e8           mov ax, word ptr [bp - 0x18]
  06EE07  3307: baffff           mov dx, 0xffff
  06EE0A  330A: 9a8a031f1a       lcall 0x1a1f, 0x38a
  06EE0F  330F: c45e06           les bx, ptr [bp + 6]
  06EE12  3312: 268b476a         mov ax, word ptr es:[bx + 0x6a]
  06EE16  3316: 260b4768         or ax, word ptr es:[bx + 0x68]
  06EE1A  331A: 7443             je 0x335f
  06EE1C  331C: 833e701f01       cmp word ptr [0x1f70], 1
  06EE21  3321: 7411             je 0x3334
  06EE23  3323: 26c45f68         les bx, ptr es:[bx + 0x68]
  06EE27  3327: 26ff770e         push word ptr es:[bx + 0xe]
  06EE2B  332B: 26ff770c         push word ptr es:[bx + 0xc]
  06EE2F  332F: 9aa8011f19       lcall 0x191f, 0x1a8
  06EE34  3334: 837ee000         cmp word ptr [bp - 0x20], 0
  06EE38  3338: 7425             je 0x335f
  06EE3A  333A: 833e701f00       cmp word ptr [0x1f70], 0
  06EE3F  333F: 751e             jne 0x335f
  06EE41  3341: c45e06           les bx, ptr [bp + 6]
  06EE44  3344: 26c45f68         les bx, ptr es:[bx + 0x68]
  06EE48  3348: 26c45f10         les bx, ptr es:[bx + 0x10]
  06EE4C  334C: 895eea           mov word ptr [bp - 0x16], bx
  06EE4F  334F: 8c46ec           mov word ptr [bp - 0x14], es
  06EE52  3352: 26ff770e         push word ptr es:[bx + 0xe]
  06EE56  3356: 26ff770c         push word ptr es:[bx + 0xc]
  06EE5A  335A: 9aa8011f19       lcall 0x191f, 0x1a8
  06EE5F  335F: ff7608           push word ptr [bp + 8]
  06EE62  3362: ff7606           push word ptr [bp + 6]
  06EE65  3365: e824ea           call 0x1d8c
  06EE68  3368: b8ffff           mov ax, 0xffff
  06EE6B  336B: a35c1f           mov word ptr [0x1f5c], ax
  06EE6E  336E: a35e1f           mov word ptr [0x1f5e], ax
  06EE71  3371: a3601f           mov word ptr [0x1f60], ax
  06EE74  3374: 2bc0             sub ax, ax
  06EE76  3376: a38a1f           mov word ptr [0x1f8a], ax
  06EE79  3379: a3661f           mov word ptr [0x1f66], ax
  06EE7C  337C: c45e06           les bx, ptr [bp + 6]
  06EE7F  337F: 26f6470a04       test byte ptr es:[bx + 0xa], 4
  06EE84  3384: 7432             je 0x33b8
  06EE86  3386: a3541f           mov word ptr [0x1f54], ax
  06EE89  3389: 8946de           mov word ptr [bp - 0x22], ax
  06EE8C  338C: eb1e             jmp 0x33ac
  06EE8E  338E: 40               inc ax
  06EE8F  338F: 50               push ax
  06EE90  3390: 06               push es
  06EE91  3391: 53               push bx
  06EE92  3392: 0e               push cs
  06EE93  3393: e89a09           call 0x3d30
  06EE96  3396: 83c406           add sp, 6
  06EE99  3399: 0bc0             or ax, ax
  06EE9B  339B: 740c             je 0x33a9
  06EE9D  339D: 8a4ede           mov cl, byte ptr [bp - 0x22]
  06EEA0  33A0: b80100           mov ax, 1
  06EEA3  33A3: d3e0             shl ax, cl
  06EEA5  33A5: 0906541f         or word ptr [0x1f54], ax
  06EEA9  33A9: ff46de           inc word ptr [bp - 0x22]
  06EEAC  33AC: 8b46de           mov ax, word ptr [bp - 0x22]
  06EEAF  33AF: c45e06           les bx, ptr [bp + 6]
  06EEB2  33B2: 26394702         cmp word ptr es:[bx + 2], ax
  06EEB6  33B6: 7fd6             jg 0x338e
  06EEB8  33B8: 9a7a041f18       lcall 0x181f, 0x47a
  06EEBD  33BD: 833e701f00       cmp word ptr [0x1f70], 0
  06EEC2  33C2: 7405             je 0x33c9
  06EEC4  33C4: 9aac0a1f19       lcall 0x191f, 0xaac
  06EEC9  33C9: c45e06           les bx, ptr [bp + 6]
  06EECC  33CC: 268b07           mov ax, word ptr es:[bx]
  06EECF  33CF: 5e               pop si
  06EED0  33D0: c9               leave 
  06EED1  33D1: ca0400           retf 4

; ---- func_06EED4  size=24  insns=10  prologue=push bp;mov bp,sp  terminal=RETF ----
  06EED4  33D4: 55               push bp
  06EED5  33D5: 8bec             mov bp, sp
  06EED7  33D7: 8b4606           mov ax, word ptr [bp + 6]
  06EEDA  33DA: 8b5608           mov dx, word ptr [bp + 8]
  06EEDD  33DD: a39e1f           mov word ptr [0x1f9e], ax
  06EEE0  33E0: 8916a01f         mov word ptr [0x1fa0], dx
  06EEE4  33E4: 8b460a           mov ax, word ptr [bp + 0xa]
  06EEE7  33E7: a3a21f           mov word ptr [0x1fa2], ax
  06EEEA  33EA: c9               leave 
  06EEEB  33EB: cb               retf 

; ---- func_06EEEC  size=520  insns=183  prologue=ENTER 0x002E,0  terminal=RETF ----
  06EEEC  33EC: c82e0000         enter 0x2e, 0
  06EEF0  33F0: 8b5e08           mov bx, word ptr [bp + 8]
  06EEF3  33F3: c60700           mov byte ptr [bx], 0
  06EEF6  33F6: 6a25             push 0x25
  06EEF8  33F8: ff7606           push word ptr [bp + 6]
  06EEFB  33FB: 9a560c1d0d       lcall 0xd1d, 0xc56
  06EF00  3400: 83c404           add sp, 4
  06EF03  3403: 8946d4           mov word ptr [bp - 0x2c], ax
  06EF06  3406: 0bc0             or ax, ax
  06EF08  3408: 7405             je 0x340f
  06EF0A  340A: 8bd8             mov bx, ax
  06EF0C  340C: c60700           mov byte ptr [bx], 0
  06EF0F  340F: 8b5e06           mov bx, word ptr [bp + 6]
  06EF12  3412: 803f00           cmp byte ptr [bx], 0
  06EF15  3415: 740c             je 0x3423
  06EF17  3417: 53               push bx
  06EF18  3418: ff7608           push word ptr [bp + 8]
  06EF1B  341B: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06EF20  3420: 83c404           add sp, 4
  06EF23  3423: 837ed400         cmp word ptr [bp - 0x2c], 0
  06EF27  3427: 7503             jne 0x342c
  06EF29  3429: e9bd01           jmp 0x35e9
  06EF2C  342C: ff46d4           inc word ptr [bp - 0x2c]
  06EF2F  342F: 8b46d4           mov ax, word ptr [bp - 0x2c]
  06EF32  3432: 894606           mov word ptr [bp + 6], ax
  06EF35  3435: 6a06             push 6
  06EF37  3437: 68a41f           push 0x1fa4
  06EF3A  343A: 50               push ax
  06EF3B  343B: 9ac20c1d0d       lcall 0xd1d, 0xcc2
  06EF40  3440: 83c406           add sp, 6
  06EF43  3443: 0bc0             or ax, ax
  06EF45  3445: 7531             jne 0x3478
  06EF47  3447: 8b4606           mov ax, word ptr [bp + 6]
  06EF4A  344A: 050600           add ax, 6
  06EF4D  344D: 50               push ax
  06EF4E  344E: 9af6081d0d       lcall 0xd1d, 0x8f6
  06EF53  3453: 83c402           add sp, 2
  06EF56  3456: 8946d2           mov word ptr [bp - 0x2e], ax
  06EF59  3459: c1e006           shl ax, 6
  06EF5C  345C: 05d29c           add ax, 0x9cd2
  06EF5F  345F: 50               push ax
  06EF60  3460: ff7608           push word ptr [bp + 8]
  06EF63  3463: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06EF68  3468: 83c404           add sp, 4
  06EF6B  346B: 8b4606           mov ax, word ptr [bp + 6]
  06EF6E  346E: 050700           add ax, 7
  06EF71  3471: 894606           mov word ptr [bp + 6], ax
  06EF74  3474: e97201           jmp 0x35e9
  06EF77  3477: 90               nop 
  06EF78  3478: 6a06             push 6
  06EF7A  347A: 68ab1f           push 0x1fab
  06EF7D  347D: ff76d4           push word ptr [bp - 0x2c]
  06EF80  3480: 9abc081d0d       lcall 0xd1d, 0x8bc
  06EF85  3485: 83c406           add sp, 6
  06EF88  3488: 0bc0             or ax, ax
  06EF8A  348A: 7544             jne 0x34d0
  06EF8C  348C: 6a0a             push 0xa
  06EF8E  348E: 8d46d8           lea ax, [bp - 0x28]
  06EF91  3491: 50               push ax
  06EF92  3492: 8b4ed4           mov cx, word ptr [bp - 0x2c]
  06EF95  3495: 83c106           add cx, 6
  06EF98  3498: 51               push cx
  06EF99  3499: 9af6081d0d       lcall 0xd1d, 0x8f6
  06EF9E  349E: 83c402           add sp, 2
  06EFA1  34A1: 8946d2           mov word ptr [bp - 0x2e], ax
  06EFA4  34A4: 8bd8             mov bx, ax
  06EFA6  34A6: c1e302           shl bx, 2
  06EFA9  34A9: ffb7b29c         push word ptr [bx - 0x634e]
  06EFAD  34AD: ffb7b09c         push word ptr [bx - 0x6350]
  06EFB1  34B1: 9a16091d0d       lcall 0xd1d, 0x916
  06EFB6  34B6: 83c408           add sp, 8
  06EFB9  34B9: 8d46d8           lea ax, [bp - 0x28]
  06EFBC  34BC: 50               push ax
  06EFBD  34BD: ff7608           push word ptr [bp + 8]
  06EFC0  34C0: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06EFC5  34C5: 83c404           add sp, 4
  06EFC8  34C8: 83460607         add word ptr [bp + 6], 7
  06EFCC  34CC: e91a01           jmp 0x35e9
  06EFCF  34CF: 90               nop 
  06EFD0  34D0: 6a03             push 3
  06EFD2  34D2: 68b21f           push 0x1fb2
  06EFD5  34D5: ff76d4           push word ptr [bp - 0x2c]
  06EFD8  34D8: 9abc081d0d       lcall 0xd1d, 0x8bc
  06EFDD  34DD: 83c406           add sp, 6
  06EFE0  34E0: 0bc0             or ax, ax
  06EFE2  34E2: 7572             jne 0x3556
  06EFE4  34E4: 6a10             push 0x10
  06EFE6  34E6: 8d46d8           lea ax, [bp - 0x28]
  06EFE9  34E9: 50               push ax
  06EFEA  34EA: 8b46d4           mov ax, word ptr [bp - 0x2c]
  06EFED  34ED: 050300           add ax, 3
  06EFF0  34F0: 50               push ax
  06EFF1  34F1: 9af6081d0d       lcall 0xd1d, 0x8f6
  06EFF6  34F6: 83c402           add sp, 2
  06EFF9  34F9: 8bd8             mov bx, ax
  06EFFB  34FB: 895ed2           mov word ptr [bp - 0x2e], bx
  06EFFE  34FE: c1e302           shl bx, 2
  06F001  3501: ffb7b29c         push word ptr [bx - 0x634e]
  06F005  3505: ffb7b09c         push word ptr [bx - 0x6350]
  06F009  3509: 9a16091d0d       lcall 0xd1d, 0x916
  06F00E  350E: 83c408           add sp, 8
  06F011  3511: c746d60000       mov word ptr [bp - 0x2a], 0
  06F016  3516: eb11             jmp 0x3529
  06F018  3518: 68b61f           push 0x1fb6
  06F01B  351B: ff7608           push word ptr [bp + 8]
  06F01E  351E: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06F023  3523: 83c404           add sp, 4
  06F026  3526: ff46d6           inc word ptr [bp - 0x2a]
  06F029  3529: 8d46d8           lea ax, [bp - 0x28]
  06F02C  352C: 50               push ax
  06F02D  352D: 9a42081d0d       lcall 0xd1d, 0x842
  06F032  3532: 83c402           add sp, 2
  06F035  3535: 2d0400           sub ax, 4
  06F038  3538: f7d8             neg ax
  06F03A  353A: 3b46d6           cmp ax, word ptr [bp - 0x2a]
  06F03D  353D: 77d9             ja 0x3518
  06F03F  353F: 8d46d8           lea ax, [bp - 0x28]
  06F042  3542: 50               push ax
  06F043  3543: ff7608           push word ptr [bp + 8]
  06F046  3546: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06F04B  354B: 83c404           add sp, 4
  06F04E  354E: 83460604         add word ptr [bp + 6], 4
  06F052  3552: e99400           jmp 0x35e9
  06F055  3555: 90               nop 
  06F056  3556: 6a07             push 7
  06F058  3558: 68b81f           push 0x1fb8
  06F05B  355B: ff76d4           push word ptr [bp - 0x2c]
  06F05E  355E: 9abc081d0d       lcall 0xd1d, 0x8bc
  06F063  3563: 83c406           add sp, 6
  06F066  3566: 0bc0             or ax, ax
  06F068  3568: 752a             jne 0x3594
  06F06A  356A: c646d800         mov byte ptr [bp - 0x28], 0
  06F06E  356E: 8d46d8           lea ax, [bp - 0x28]
  06F071  3571: 50               push ax
  06F072  3572: 6a00             push 0
  06F074  3574: ff369853         push word ptr [0x5398]
  06F078  3578: 9a2e041f18       lcall 0x181f, 0x42e
  06F07D  357D: 83c406           add sp, 6
  06F080  3580: 8d46d8           lea ax, [bp - 0x28]
  06F083  3583: 16               push ss
  06F084  3584: 50               push ax
  06F085  3585: 1e               push ds
  06F086  3586: ff7608           push word ptr [bp + 8]
  06F089  3589: 9ab4111d0d       lcall 0xd1d, 0x11b4
  06F08E  358E: 83c408           add sp, 8
  06F091  3591: e934ff           jmp 0x34c8
  06F094  3594: 6a04             push 4
  06F096  3596: 68c01f           push 0x1fc0
  06F099  3599: ff76d4           push word ptr [bp - 0x2c]
  06F09C  359C: 9abc081d0d       lcall 0xd1d, 0x8bc
  06F0A1  35A1: 83c406           add sp, 6
  06F0A4  35A4: 0bc0             or ax, ax
  06F0A6  35A6: 7526             jne 0x35ce
  06F0A8  35A8: 6a0a             push 0xa
  06F0AA  35AA: 8d46d8           lea ax, [bp - 0x28]
  06F0AD  35AD: 50               push ax
  06F0AE  35AE: ff368a53         push word ptr [0x538a]
  06F0B2  35B2: 9afa081d0d       lcall 0xd1d, 0x8fa
  06F0B7  35B7: 83c406           add sp, 6
  06F0BA  35BA: 8d46d8           lea ax, [bp - 0x28]
  06F0BD  35BD: 16               push ss
  06F0BE  35BE: 50               push ax
  06F0BF  35BF: 1e               push ds
  06F0C0  35C0: ff7608           push word ptr [bp + 8]
  06F0C3  35C3: 9ab4111d0d       lcall 0xd1d, 0x11b4
  06F0C8  35C8: 83c408           add sp, 8
  06F0CB  35CB: eb81             jmp 0x354e
  06F0CD  35CD: 90               nop 
  06F0CE  35CE: 8b5ed4           mov bx, word ptr [bp - 0x2c]
  06F0D1  35D1: 803f25           cmp byte ptr [bx], 0x25
  06F0D4  35D4: 7513             jne 0x35e9
  06F0D6  35D6: 1e               push ds
  06F0D7  35D7: 68c51f           push 0x1fc5
  06F0DA  35DA: 1e               push ds
  06F0DB  35DB: ff7608           push word ptr [bp + 8]
  06F0DE  35DE: 9ab4111d0d       lcall 0xd1d, 0x11b4
  06F0E3  35E3: 83c408           add sp, 8
  06F0E6  35E6: ff4606           inc word ptr [bp + 6]
  06F0E9  35E9: 837ed400         cmp word ptr [bp - 0x2c], 0
  06F0ED  35ED: 7403             je 0x35f2
  06F0EF  35EF: e904fe           jmp 0x33f6
  06F0F2  35F2: c9               leave 
  06F0F3  35F3: cb               retf 

; ---- func_06F0F4  size=1061  insns=369  prologue=ENTER 0x0168,0  terminal=RETF ----
  06F0F4  35F4: c8680100         enter 0x168, 0
  06F0F8  35F8: 52               push dx
  06F0F9  35F9: 50               push ax
  06F0FA  35FA: 53               push bx
  06F0FB  35FB: 57               push di
  06F0FC  35FC: 56               push si
  06F0FD  35FD: b90100           mov cx, 1
  06F100  3600: 894efc           mov word ptr [bp - 4], cx
  06F103  3603: 898e9efe         mov word ptr [bp - 0x162], cx
  06F107  3607: c746f00000       mov word ptr [bp - 0x10], 0
  06F10C  360C: 2bc9             sub cx, cx
  06F10E  360E: 894ef6           mov word ptr [bp - 0xa], cx
  06F111  3611: 894ef4           mov word ptr [bp - 0xc], cx
  06F114  3614: 50               push ax
  06F115  3615: 687824           push 0x2478
  06F118  3618: 8bf0             mov si, ax
  06F11A  361A: 8bfb             mov di, bx
  06F11C  361C: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06F121  3621: 83c404           add sp, 4
  06F124  3624: 56               push si
  06F125  3625: 57               push di
  06F126  3626: 9a28091f19       lcall 0x191f, 0x928
  06F12B  362B: 83c404           add sp, 4
  06F12E  362E: 0bc0             or ax, ax
  06F130  3630: 7403             je 0x3635
  06F132  3632: e9c003           jmp 0x39f5
  06F135  3635: ff36a01f         push word ptr [0x1fa0]
  06F139  3639: ff369e1f         push word ptr [0x1f9e]
  06F13D  363D: ff36a21f         push word ptr [0x1fa2]
  06F141  3641: 0e               push cs
  06F142  3642: e8c306           call 0x3d08
  06F145  3645: 83c406           add sp, 6
  06F148  3648: 8946f4           mov word ptr [bp - 0xc], ax
  06F14B  364B: 8956f6           mov word ptr [bp - 0xa], dx
  06F14E  364E: 0bd0             or dx, ax
  06F150  3650: 7503             jne 0x3655
  06F152  3652: e9a003           jmp 0x39f5
  06F155  3655: 833e082000       cmp word ptr [0x2008], 0
  06F15A  365A: 7418             je 0x3674
  06F15C  365C: 833eb4a500       cmp word ptr [0xa5b4], 0
  06F161  3661: 7411             je 0x3674
  06F163  3663: ff36b4a5         push word ptr [0xa5b4]
  06F167  3667: 8d86a0fe         lea ax, [bp - 0x160]
  06F16B  366B: 50               push ax
  06F16C  366C: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06F171  3671: 83c404           add sp, 4
  06F174  3674: 9a1c091f19       lcall 0x191f, 0x91c
  06F179  3679: 8946f2           mov word ptr [bp - 0xe], ax
  06F17C  367C: 50               push ax
  06F17D  367D: 9a42081d0d       lcall 0xd1d, 0x842
  06F182  3682: 83c402           add sp, 2
  06F185  3685: 0bc0             or ax, ax
  06F187  3687: 7507             jne 0x3690
  06F189  3689: ff46fc           inc word ptr [bp - 4]
  06F18C  368C: e95d03           jmp 0x39ec
  06F18F  368F: 90               nop 
  06F190  3690: 8b5ef2           mov bx, word ptr [bp - 0xe]
  06F193  3693: 803f40           cmp byte ptr [bx], 0x40
  06F196  3696: 7403             je 0x369b
  06F198  3698: e96f02           jmp 0x390a
  06F19B  369B: 53               push bx
  06F19C  369C: 9a640d1d0d       lcall 0xd1d, 0xd64
  06F1A1  36A1: 83c402           add sp, 2
  06F1A4  36A4: 68c71f           push 0x1fc7
  06F1A7  36A7: 8b46f2           mov ax, word ptr [bp - 0xe]
  06F1AA  36AA: 40               inc ax
  06F1AB  36AB: 898698fe         mov word ptr [bp - 0x168], ax
  06F1AF  36AF: 50               push ax
  06F1B0  36B0: 9a16081d0d       lcall 0xd1d, 0x816
  06F1B5  36B5: 83c404           add sp, 4
  06F1B8  36B8: 0bc0             or ax, ax
  06F1BA  36BA: 7413             je 0x36cf
  06F1BC  36BC: 68cf1f           push 0x1fcf
  06F1BF  36BF: ffb698fe         push word ptr [bp - 0x168]
  06F1C3  36C3: 9a16081d0d       lcall 0xd1d, 0x816
  06F1C8  36C8: 83c404           add sp, 4
  06F1CB  36CB: 0bc0             or ax, ax
  06F1CD  36CD: 7509             jne 0x36d8
  06F1CF  36CF: c746fc0200       mov word ptr [bp - 4], 2
  06F1D4  36D4: e91503           jmp 0x39ec
  06F1D7  36D7: 90               nop 
  06F1D8  36D8: 68d61f           push 0x1fd6
  06F1DB  36DB: ffb698fe         push word ptr [bp - 0x168]
  06F1DF  36DF: 9a16081d0d       lcall 0xd1d, 0x816
  06F1E4  36E4: 83c404           add sp, 4
  06F1E7  36E7: 0bc0             or ax, ax
  06F1E9  36E9: 7509             jne 0x36f4
  06F1EB  36EB: c746fc0100       mov word ptr [bp - 4], 1
  06F1F0  36F0: e9f902           jmp 0x39ec
  06F1F3  36F3: 90               nop 
  06F1F4  36F4: 68db1f           push 0x1fdb
  06F1F7  36F7: ffb698fe         push word ptr [bp - 0x168]
  06F1FB  36FB: 9a16081d0d       lcall 0xd1d, 0x816
  06F200  3700: 83c404           add sp, 4
  06F203  3703: 0bc0             or ax, ax
  06F205  3705: 7517             jne 0x371e
  06F207  3707: a19e08           mov ax, word ptr [0x89e]
  06F20A  370A: 8b16a008         mov dx, word ptr [0x8a0]
  06F20E  370E: c45ef4           les bx, ptr [bp - 0xc]
  06F211  3711: 2689878000       mov word ptr es:[bx + 0x80], ax
  06F216  3716: 2689978200       mov word ptr es:[bx + 0x82], dx
  06F21B  371B: e9ce02           jmp 0x39ec
  06F21E  371E: 6a01             push 1
  06F220  3720: 68e51f           push 0x1fe5
  06F223  3723: ffb698fe         push word ptr [bp - 0x168]
  06F227  3727: 9abc081d0d       lcall 0xd1d, 0x8bc
  06F22C  372C: 83c406           add sp, 6
  06F22F  372F: 0bc0             or ax, ax
  06F231  3731: 7533             jne 0x3766
  06F233  3733: eb11             jmp 0x3746
  06F235  3735: 90               nop 
  06F236  3736: 8a07             mov al, byte ptr [bx]
  06F238  3738: 98               cwde 
  06F239  3739: 8bd8             mov bx, ax
  06F23B  373B: f687ed2704       test byte ptr [bx + 0x27ed], 4
  06F240  3740: 750d             jne 0x374f
  06F242  3742: ff8698fe         inc word ptr [bp - 0x168]
  06F246  3746: 8b9e98fe         mov bx, word ptr [bp - 0x168]
  06F24A  374A: 803f00           cmp byte ptr [bx], 0
  06F24D  374D: 75e7             jne 0x3736
  06F24F  374F: ffb698fe         push word ptr [bp - 0x168]
  06F253  3753: 9af6081d0d       lcall 0xd1d, 0x8f6
  06F258  3758: 83c402           add sp, 2
  06F25B  375B: c45ef4           les bx, ptr [bp - 0xc]
  06F25E  375E: 2689470e         mov word ptr es:[bx + 0xe], ax
  06F262  3762: e98702           jmp 0x39ec
  06F265  3765: 90               nop 
  06F266  3766: 6a01             push 1
  06F268  3768: 68e71f           push 0x1fe7
  06F26B  376B: ffb698fe         push word ptr [bp - 0x168]
  06F26F  376F: 9abc081d0d       lcall 0xd1d, 0x8bc
  06F274  3774: 83c406           add sp, 6
  06F277  3777: 0bc0             or ax, ax
  06F279  3779: 7533             jne 0x37ae
  06F27B  377B: eb11             jmp 0x378e
  06F27D  377D: 90               nop 
  06F27E  377E: 8a07             mov al, byte ptr [bx]
  06F280  3780: 98               cwde 
  06F281  3781: 8bd8             mov bx, ax
  06F283  3783: f687ed2704       test byte ptr [bx + 0x27ed], 4
  06F288  3788: 750d             jne 0x3797
  06F28A  378A: ff8698fe         inc word ptr [bp - 0x168]
  06F28E  378E: 8b9e98fe         mov bx, word ptr [bp - 0x168]
  06F292  3792: 803f00           cmp byte ptr [bx], 0
  06F295  3795: 75e7             jne 0x377e
  06F297  3797: ffb698fe         push word ptr [bp - 0x168]
  06F29B  379B: 9af6081d0d       lcall 0xd1d, 0x8f6
  06F2A0  37A0: 83c402           add sp, 2
  06F2A3  37A3: c45ef4           les bx, ptr [bp - 0xc]
  06F2A6  37A6: 2689470c         mov word ptr es:[bx + 0xc], ax
  06F2AA  37AA: e93f02           jmp 0x39ec
  06F2AD  37AD: 90               nop 
  06F2AE  37AE: 6a05             push 5
  06F2B0  37B0: 68e91f           push 0x1fe9
  06F2B3  37B3: ffb698fe         push word ptr [bp - 0x168]
  06F2B7  37B7: 9abc081d0d       lcall 0xd1d, 0x8bc
  06F2BC  37BC: 83c406           add sp, 6
  06F2BF  37BF: 0bc0             or ax, ax
  06F2C1  37C1: 753d             jne 0x3800
  06F2C3  37C3: eb11             jmp 0x37d6
  06F2C5  37C5: 90               nop 
  06F2C6  37C6: 8a07             mov al, byte ptr [bx]
  06F2C8  37C8: 98               cwde 
  06F2C9  37C9: 8bd8             mov bx, ax
  06F2CB  37CB: f687ed2704       test byte ptr [bx + 0x27ed], 4
  06F2D0  37D0: 750d             jne 0x37df
  06F2D2  37D2: ff8698fe         inc word ptr [bp - 0x168]
  06F2D6  37D6: 8b9e98fe         mov bx, word ptr [bp - 0x168]
  06F2DA  37DA: 803f00           cmp byte ptr [bx], 0
  06F2DD  37DD: 75e7             jne 0x37c6
  06F2DF  37DF: ffb698fe         push word ptr [bp - 0x168]
  06F2E3  37E3: 9af6081d0d       lcall 0xd1d, 0x8f6
  06F2E8  37E8: 83c402           add sp, 2
  06F2EB  37EB: 8946fe           mov word ptr [bp - 2], ax
  06F2EE  37EE: 50               push ax
  06F2EF  37EF: ff76f6           push word ptr [bp - 0xa]
  06F2F2  37F2: ff76f4           push word ptr [bp - 0xc]
  06F2F5  37F5: 0e               push cs
  06F2F6  37F6: e81905           call 0x3d12
  06F2F9  37F9: 83c406           add sp, 6
  06F2FC  37FC: e9ed01           jmp 0x39ec
  06F2FF  37FF: 90               nop 
  06F300  3800: 6a06             push 6
  06F302  3802: 68ef1f           push 0x1fef
  06F305  3805: ffb698fe         push word ptr [bp - 0x168]
  06F309  3809: 9ac20c1d0d       lcall 0xd1d, 0xcc2
  06F30E  380E: 83c406           add sp, 6
  06F311  3811: 0bc0             or ax, ax
  06F313  3813: 7539             jne 0x384e
  06F315  3815: eb11             jmp 0x3828
  06F317  3817: 90               nop 
  06F318  3818: 8a07             mov al, byte ptr [bx]
  06F31A  381A: 98               cwde 
  06F31B  381B: 8bd8             mov bx, ax
  06F31D  381D: f687ed2704       test byte ptr [bx + 0x27ed], 4
  06F322  3822: 750d             jne 0x3831
  06F324  3824: ff8698fe         inc word ptr [bp - 0x168]
  06F328  3828: 8b9e98fe         mov bx, word ptr [bp - 0x168]
  06F32C  382C: 803f00           cmp byte ptr [bx], 0
  06F32F  382F: 75e7             jne 0x3818
  06F331  3831: 833eb6a500       cmp word ptr [0xa5b6], 0
  06F336  3836: 7403             je 0x383b
  06F338  3838: e9b101           jmp 0x39ec
  06F33B  383B: ffb698fe         push word ptr [bp - 0x168]
  06F33F  383F: 9af6081d0d       lcall 0xd1d, 0x8f6
  06F344  3844: 83c402           add sp, 2
  06F347  3847: a3b6a5           mov word ptr [0xa5b6], ax
  06F34A  384A: e99f01           jmp 0x39ec
  06F34D  384D: 90               nop 
  06F34E  384E: 6a07             push 7
  06F350  3850: 68f61f           push 0x1ff6
  06F353  3853: ffb698fe         push word ptr [bp - 0x168]
  06F357  3857: 9abc081d0d       lcall 0xd1d, 0x8bc
  06F35C  385C: 83c406           add sp, 6
  06F35F  385F: 0bc0             or ax, ax
  06F361  3861: 7511             jne 0x3874
  06F363  3863: c746f00100       mov word ptr [bp - 0x10], 1
  06F368  3868: c45ef4           les bx, ptr [bp - 0xc]
  06F36B  386B: 26804f0a05       or byte ptr es:[bx + 0xa], 5
  06F370  3870: e97901           jmp 0x39ec
  06F373  3873: 90               nop 
  06F374  3874: 6a07             push 7
  06F376  3876: 68ff1f           push 0x1fff
  06F379  3879: ffb698fe         push word ptr [bp - 0x168]
  06F37D  387D: 9abc081d0d       lcall 0xd1d, 0x8bc
  06F382  3882: 83c406           add sp, 6
  06F385  3885: 0bc0             or ax, ax
  06F387  3887: 7579             jne 0x3902
  06F389  3889: 39060820         cmp word ptr [0x2008], ax
  06F38D  388D: 744d             je 0x38dc
  06F38F  388F: eb0a             jmp 0x389b
  06F391  3891: 90               nop 
  06F392  3892: 803f3d           cmp byte ptr [bx], 0x3d
  06F395  3895: 740d             je 0x38a4
  06F397  3897: ff8698fe         inc word ptr [bp - 0x168]
  06F39B  389B: 8b9e98fe         mov bx, word ptr [bp - 0x168]
  06F39F  389F: 803f00           cmp byte ptr [bx], 0
  06F3A2  38A2: 75ee             jne 0x3892
  06F3A4  38A4: 833eb4a500       cmp word ptr [0xa5b4], 0
  06F3A9  38A9: 7403             je 0x38ae
  06F3AB  38AB: e93e01           jmp 0x39ec
  06F3AE  38AE: 803f00           cmp byte ptr [bx], 0
  06F3B1  38B1: 7404             je 0x38b7
  06F3B3  38B3: ff8698fe         inc word ptr [bp - 0x168]
  06F3B7  38B7: ffb698fe         push word ptr [bp - 0x168]
  06F3BB  38BB: 8d86a0fe         lea ax, [bp - 0x160]
  06F3BF  38BF: 50               push ax
  06F3C0  38C0: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06F3C5  38C5: 83c404           add sp, 4
  06F3C8  38C8: e92101           jmp 0x39ec
  06F3CB  38CB: 90               nop 
  06F3CC  38CC: 8a07             mov al, byte ptr [bx]
  06F3CE  38CE: 98               cwde 
  06F3CF  38CF: 8bd8             mov bx, ax
  06F3D1  38D1: f687ed2704       test byte ptr [bx + 0x27ed], 4
  06F3D6  38D6: 750d             jne 0x38e5
  06F3D8  38D8: ff8698fe         inc word ptr [bp - 0x168]
  06F3DC  38DC: 8b9e98fe         mov bx, word ptr [bp - 0x168]
  06F3E0  38E0: 803f00           cmp byte ptr [bx], 0
  06F3E3  38E3: 75e7             jne 0x38cc
  06F3E5  38E5: 83be96fe00       cmp word ptr [bp - 0x16a], 0
  06F3EA  38EA: 7403             je 0x38ef
  06F3EC  38EC: e9fd00           jmp 0x39ec
  06F3EF  38EF: ffb698fe         push word ptr [bp - 0x168]
  06F3F3  38F3: 9af6081d0d       lcall 0xd1d, 0x8f6
  06F3F8  38F8: 83c402           add sp, 2
  06F3FB  38FB: 898696fe         mov word ptr [bp - 0x16a], ax
  06F3FF  38FF: e9ea00           jmp 0x39ec
  06F402  3902: c746fc0300       mov word ptr [bp - 4], 3
  06F407  3907: e9e200           jmp 0x39ec
  06F40A  390A: 8b46fc           mov ax, word ptr [bp - 4]
  06F40D  390D: e9d000           jmp 0x39e0
  06F410  3910: 8d86f0fe         lea ax, [bp - 0x110]
  06F414  3914: 50               push ax
  06F415  3915: ff76f2           push word ptr [bp - 0xe]
  06F418  3918: 0e               push cs
  06F419  3919: e8fb03           call 0x3d17
  06F41C  391C: 83c404           add sp, 4
  06F41F  391F: 8d86f0fe         lea ax, [bp - 0x110]
  06F423  3923: 16               push ss
  06F424  3924: 50               push ax
  06F425  3925: ff76f6           push word ptr [bp - 0xa]
  06F428  3928: ff76f4           push word ptr [bp - 0xc]
  06F42B  392B: 0e               push cs
  06F42C  392C: e8de03           call 0x3d0d
  06F42F  392F: 83c408           add sp, 8
  06F432  3932: e9b700           jmp 0x39ec
  06F435  3935: 90               nop 
  06F436  3936: 833e082000       cmp word ptr [0x2008], 0
  06F43B  393B: 7441             je 0x397e
  06F43D  393D: 833eb6a500       cmp word ptr [0xa5b6], 0
  06F442  3942: 7506             jne 0x394a
  06F444  3944: c706b6a50500     mov word ptr [0xa5b6], 5
  06F44A  394A: 8d86f0fe         lea ax, [bp - 0x110]
  06F44E  394E: 50               push ax
  06F44F  394F: ff76f2           push word ptr [bp - 0xe]
  06F452  3952: 0e               push cs
  06F453  3953: e8c103           call 0x3d17
  06F456  3956: 83c404           add sp, 4
  06F459  3959: ff36b6a5         push word ptr [0xa5b6]
  06F45D  395D: 8d86a0fe         lea ax, [bp - 0x160]
  06F461  3961: 16               push ss
  06F462  3962: 50               push ax
  06F463  3963: 8d86f0fe         lea ax, [bp - 0x110]
  06F467  3967: 16               push ss
  06F468  3968: 50               push ax
  06F469  3969: ff76f6           push word ptr [bp - 0xa]
  06F46C  396C: ff76f4           push word ptr [bp - 0xc]
  06F46F  396F: 0e               push cs
  06F470  3970: e8c203           call 0x3d35
  06F473  3973: 83c40e           add sp, 0xe
  06F476  3976: 8946f8           mov word ptr [bp - 8], ax
  06F479  3979: 8956fa           mov word ptr [bp - 6], dx
  06F47C  397C: eb6e             jmp 0x39ec
  06F47E  397E: 8d86f0fe         lea ax, [bp - 0x110]
  06F482  3982: 50               push ax
  06F483  3983: ff76f2           push word ptr [bp - 0xe]
  06F486  3986: 0e               push cs
  06F487  3987: e88d03           call 0x3d17
  06F48A  398A: 83c404           add sp, 4
  06F48D  398D: ffb69efe         push word ptr [bp - 0x162]
  06F491  3991: 8d86f0fe         lea ax, [bp - 0x110]
  06F495  3995: 16               push ss
  06F496  3996: 50               push ax
  06F497  3997: ff76f6           push word ptr [bp - 0xa]
  06F49A  399A: ff76f4           push word ptr [bp - 0xc]
  06F49D  399D: 0e               push cs
  06F49E  399E: e85d03           call 0x3cfe
  06F4A1  39A1: 83c40a           add sp, 0xa
  06F4A4  39A4: 89869afe         mov word ptr [bp - 0x166], ax
  06F4A8  39A8: 89969cfe         mov word ptr [bp - 0x164], dx
  06F4AC  39AC: 837ef000         cmp word ptr [bp - 0x10], 0
  06F4B0  39B0: 740a             je 0x39bc
  06F4B2  39B2: c49e9afe         les bx, ptr [bp - 0x166]
  06F4B6  39B6: 26c747060000     mov word ptr es:[bx + 6], 0
  06F4BC  39BC: 8b8696fe         mov ax, word ptr [bp - 0x16a]
  06F4C0  39C0: 39869efe         cmp word ptr [bp - 0x162], ax
  06F4C4  39C4: 7513             jne 0x39d9
  06F4C6  39C6: 8b869afe         mov ax, word ptr [bp - 0x166]
  06F4CA  39CA: 8b969cfe         mov dx, word ptr [bp - 0x164]
  06F4CE  39CE: c45ef4           les bx, ptr [bp - 0xc]
  06F4D1  39D1: 2689474c         mov word ptr es:[bx + 0x4c], ax
  06F4D5  39D5: 2689574e         mov word ptr es:[bx + 0x4e], dx
  06F4D9  39D9: ff869efe         inc word ptr [bp - 0x162]
  06F4DD  39DD: eb0d             jmp 0x39ec
  06F4DF  39DF: 90               nop 
  06F4E0  39E0: 48               dec ax
  06F4E1  39E1: 7503             jne 0x39e6
  06F4E3  39E3: e92aff           jmp 0x3910
  06F4E6  39E6: 48               dec ax
  06F4E7  39E7: 7503             jne 0x39ec
  06F4E9  39E9: e94aff           jmp 0x3936
  06F4EC  39EC: 837efc03         cmp word ptr [bp - 4], 3
  06F4F0  39F0: 7d03             jge 0x39f5
  06F4F2  39F2: e97ffc           jmp 0x3674
  06F4F5  39F5: 8b46f6           mov ax, word ptr [bp - 0xa]
  06F4F8  39F8: 0b46f4           or ax, word ptr [bp - 0xc]
  06F4FB  39FB: 7512             jne 0x3a0f
  06F4FD  39FD: b8ffff           mov ax, 0xffff
  06F500  3A00: a35e1f           mov word ptr [0x1f5e], ax
  06F503  3A03: a35c1f           mov word ptr [0x1f5c], ax
  06F506  3A06: a3601f           mov word ptr [0x1f60], ax
  06F509  3A09: c706661f0000     mov word ptr [0x1f66], 0
  06F50F  3A0F: 8b46f4           mov ax, word ptr [bp - 0xc]
  06F512  3A12: 8b56f6           mov dx, word ptr [bp - 0xa]
  06F515  3A15: 5e               pop si
  06F516  3A16: 5f               pop di
  06F517  3A17: c9               leave 
  06F518  3A18: cb               retf 

; ---- func_06F51A  size=57  insns=21  prologue=ENTER 0x0006,0  terminal=RETF ----
  06F51A  3A1A: c8060000         enter 6, 0
  06F51E  3A1E: c746fe0000       mov word ptr [bp - 2], 0
  06F523  3A23: 0e               push cs
  06F524  3A24: e8dc02           call 0x3d03
  06F527  3A27: 8946fa           mov word ptr [bp - 6], ax
  06F52A  3A2A: 8956fc           mov word ptr [bp - 4], dx
  06F52D  3A2D: 0bd0             or dx, ax
  06F52F  3A2F: 7416             je 0x3a47
  06F531  3A31: ff76fc           push word ptr [bp - 4]
  06F534  3A34: 50               push ax
  06F535  3A35: 0e               push cs
  06F536  3A36: e8c002           call 0x3cf9
  06F539  3A39: 8946fe           mov word ptr [bp - 2], ax
  06F53C  3A3C: ff76fc           push word ptr [bp - 4]
  06F53F  3A3F: ff76fa           push word ptr [bp - 6]
  06F542  3A42: 9aa8011f19       lcall 0x191f, 0x1a8
  06F547  3A47: 8b46fe           mov ax, word ptr [bp - 2]
  06F54A  3A4A: c9               leave 
  06F54B  3A4B: cb               retf 
  06F54C  3A4C: c706541f0000     mov word ptr [0x1f54], 0
  06F552  3A52: cb               retf 

; ---- func_06F554  size=42  insns=20  prologue=push bp;mov bp,sp  terminal=RETF ----
  06F554  3A54: 55               push bp
  06F555  3A55: 8bec             mov bp, sp
  06F557  3A57: 50               push ax
  06F558  3A58: ff4efe           dec word ptr [bp - 2]
  06F55B  3A5B: 0bd2             or dx, dx
  06F55D  3A5D: 740f             je 0x3a6e
  06F55F  3A5F: 8a4efe           mov cl, byte ptr [bp - 2]
  06F562  3A62: b80100           mov ax, 1
  06F565  3A65: d3e0             shl ax, cl
  06F567  3A67: 0906541f         or word ptr [0x1f54], ax
  06F56B  3A6B: c9               leave 
  06F56C  3A6C: cb               retf 
  06F56D  3A6D: 90               nop 
  06F56E  3A6E: 8a4efe           mov cl, byte ptr [bp - 2]
  06F571  3A71: b80100           mov ax, 1
  06F574  3A74: d3e0             shl ax, cl
  06F576  3A76: f7d0             not ax
  06F578  3A78: 2106541f         and word ptr [0x1f54], ax
  06F57C  3A7C: c9               leave 
  06F57D  3A7D: cb               retf 

; ---- func_06F57E  size=49  insns=24  prologue=push bp;mov bp,sp  terminal=RETF ----
  06F57E  3A7E: 55               push bp
  06F57F  3A7F: 8bec             mov bp, sp
  06F581  3A81: 50               push ax
  06F582  3A82: b80100           mov ax, 1
  06F585  3A85: 2946fe           sub word ptr [bp - 2], ax
  06F588  3A88: 8a4efe           mov cl, byte ptr [bp - 2]
  06F58B  3A8B: d3e0             shl ax, cl
  06F58D  3A8D: 2306541f         and ax, word ptr [0x1f54]
  06F591  3A91: c9               leave 
  06F592  3A92: cb               retf 
  06F593  3A93: 90               nop 
  06F594  3A94: 8bc3             mov ax, bx
  06F596  3A96: 8d1e7c08         lea bx, [0x87c]
  06F59A  3A9A: 2bd2             sub dx, dx
  06F59C  3A9C: 0e               push cs
  06F59D  3A9D: e84f02           call 0x3cef
  06F5A0  3AA0: cb               retf 
  06F5A1  3AA1: 90               nop 
  06F5A2  3AA2: 8bd0             mov dx, ax
  06F5A4  3AA4: 8bc3             mov ax, bx
  06F5A6  3AA6: 8d1e7c08         lea bx, [0x87c]
  06F5AA  3AAA: 0e               push cs
  06F5AB  3AAB: e84102           call 0x3cef
  06F5AE  3AAE: cb               retf 

; ---- func_06F5B0  size=41  insns=18  prologue=push bp;mov bp,sp  terminal=RETF ----
  06F5B0  3AB0: 55               push bp
  06F5B1  3AB1: 8bec             mov bp, sp
  06F5B3  3AB3: 8b4608           mov ax, word ptr [bp + 8]
  06F5B6  3AB6: a35c1f           mov word ptr [0x1f5c], ax
  06F5B9  3AB9: 8d1e7c08         lea bx, [0x87c]
  06F5BD  3ABD: 8b4606           mov ax, word ptr [bp + 6]
  06F5C0  3AC0: 2bd2             sub dx, dx
  06F5C2  3AC2: 0e               push cs
  06F5C3  3AC3: e82902           call 0x3cef
  06F5C6  3AC6: c9               leave 
  06F5C7  3AC7: cb               retf 
  06F5C8  3AC8: 89165c1f         mov word ptr [0x1f5c], dx
  06F5CC  3ACC: 8bd0             mov dx, ax
  06F5CE  3ACE: 8bc3             mov ax, bx
  06F5D0  3AD0: 8d1e7c08         lea bx, [0x87c]
  06F5D4  3AD4: 0e               push cs
  06F5D5  3AD5: e81702           call 0x3cef
  06F5D8  3AD8: cb               retf 

; ---- func_06F5DA  size=24  insns=10  prologue=push bp;mov bp,sp  terminal=RETF ----
  06F5DA  3ADA: 55               push bp
  06F5DB  3ADB: 8bec             mov bp, sp
  06F5DD  3ADD: c7065c1f0800     mov word ptr [0x1f5c], 8
  06F5E3  3AE3: 8d1e7c08         lea bx, [0x87c]
  06F5E7  3AE7: 8b4606           mov ax, word ptr [bp + 6]
  06F5EA  3AEA: 2bd2             sub dx, dx
  06F5EC  3AEC: 0e               push cs
  06F5ED  3AED: e8ff01           call 0x3cef
  06F5F0  3AF0: c9               leave 
  06F5F1  3AF1: cb               retf 

; ---- func_06F5F2  size=41  insns=18  prologue=push bp;mov bp,sp  terminal=RETF ----
  06F5F2  3AF2: 55               push bp
  06F5F3  3AF3: 8bec             mov bp, sp
  06F5F5  3AF5: 8b4608           mov ax, word ptr [bp + 8]
  06F5F8  3AF8: a35e1f           mov word ptr [0x1f5e], ax
  06F5FB  3AFB: 8d1e7c08         lea bx, [0x87c]
  06F5FF  3AFF: 8b4606           mov ax, word ptr [bp + 6]
  06F602  3B02: 2bd2             sub dx, dx
  06F604  3B04: 0e               push cs
  06F605  3B05: e8e701           call 0x3cef
  06F608  3B08: c9               leave 
  06F609  3B09: cb               retf 
  06F60A  3B0A: 89165e1f         mov word ptr [0x1f5e], dx
  06F60E  3B0E: 8bd0             mov dx, ax
  06F610  3B10: 8bc3             mov ax, bx
  06F612  3B12: 8d1e7c08         lea bx, [0x87c]
  06F616  3B16: 0e               push cs
  06F617  3B17: e8d501           call 0x3cef
  06F61A  3B1A: cb               retf 

; ---- func_06F61C  size=48  insns=21  prologue=push bp;mov bp,sp  terminal=RETF ----
  06F61C  3B1C: 55               push bp
  06F61D  3B1D: 8bec             mov bp, sp
  06F61F  3B1F: 8b4608           mov ax, word ptr [bp + 8]
  06F622  3B22: a3601f           mov word ptr [0x1f60], ax
  06F625  3B25: 8d1e7c08         lea bx, [0x87c]
  06F629  3B29: 8b4606           mov ax, word ptr [bp + 6]
  06F62C  3B2C: 2bd2             sub dx, dx
  06F62E  3B2E: 0e               push cs
  06F62F  3B2F: e8bd01           call 0x3cef
  06F632  3B32: c9               leave 
  06F633  3B33: cb               retf 
  06F634  3B34: 8916601f         mov word ptr [0x1f60], dx
  06F638  3B38: 8bd0             mov dx, ax
  06F63A  3B3A: 8bc3             mov ax, bx
  06F63C  3B3C: 8d1e7c08         lea bx, [0x87c]
  06F640  3B40: 0e               push cs
  06F641  3B41: e8ab01           call 0x3cef
  06F644  3B44: cb               retf 
  06F645  3B45: 90               nop 
  06F646  3B46: 800e561f18       or byte ptr [0x1f56], 0x18
  06F64B  3B4B: cb               retf 

; ---- func_06F64C  size=75  insns=25  prologue=ENTER 0x0006,0  terminal=RETF imm16 ----
  06F64C  3B4C: c8060000         enter 6, 0
  06F650  3B50: c70608200100     mov word ptr [0x2008], 1
  06F656  3B56: 8b4e06           mov cx, word ptr [bp + 6]
  06F659  3B59: 890eb6a5         mov word ptr [0xa5b6], cx
  06F65D  3B5D: 8916b4a5         mov word ptr [0xa5b4], dx
  06F661  3B61: 2bd2             sub dx, dx
  06F663  3B63: 8956fe           mov word ptr [bp - 2], dx
  06F666  3B66: 0e               push cs
  06F667  3B67: e89901           call 0x3d03
  06F66A  3B6A: 8946fa           mov word ptr [bp - 6], ax
  06F66D  3B6D: 8956fc           mov word ptr [bp - 4], dx
  06F670  3B70: 0bd0             or dx, ax
  06F672  3B72: 7416             je 0x3b8a
  06F674  3B74: ff76fc           push word ptr [bp - 4]
  06F677  3B77: 50               push ax
  06F678  3B78: 0e               push cs
  06F679  3B79: e87d01           call 0x3cf9
  06F67C  3B7C: 8946fe           mov word ptr [bp - 2], ax
  06F67F  3B7F: ff76fc           push word ptr [bp - 4]
  06F682  3B82: ff76fa           push word ptr [bp - 6]
  06F685  3B85: 9aa8011f19       lcall 0x191f, 0x1a8
  06F68A  3B8A: c70608200000     mov word ptr [0x2008], 0
  06F690  3B90: 8b46fe           mov ax, word ptr [bp - 2]
  06F693  3B93: c9               leave 
  06F694  3B94: ca0200           retf 2

; ---- func_06F698  size=65  insns=30  prologue=ENTER 0x0016,0  terminal=RETF ----
  06F698  3B98: c8160000         enter 0x16, 0
  06F69C  3B9C: 52               push dx
  06F69D  3B9D: 50               push ax
  06F69E  3B9E: 53               push bx
  06F69F  3B9F: 57               push di
  06F6A0  3BA0: 56               push si
  06F6A1  3BA1: 6a0a             push 0xa
  06F6A3  3BA3: 8d4eec           lea cx, [bp - 0x14]
  06F6A6  3BA6: 51               push cx
  06F6A7  3BA7: 52               push dx
  06F6A8  3BA8: 8bf0             mov si, ax
  06F6AA  3BAA: 8bfb             mov di, bx
  06F6AC  3BAC: 9afa081d0d       lcall 0xd1d, 0x8fa
  06F6B1  3BB1: 83c406           add sp, 6
  06F6B4  3BB4: 6a05             push 5
  06F6B6  3BB6: 8bc6             mov ax, si
  06F6B8  3BB8: 8bdf             mov bx, di
  06F6BA  3BBA: 8d56ec           lea dx, [bp - 0x14]
  06F6BD  3BBD: 0e               push cs
  06F6BE  3BBE: e83301           call 0x3cf4
  06F6C1  3BC1: 8946ea           mov word ptr [bp - 0x16], ax
  06F6C4  3BC4: 682098           push 0x9820
  06F6C7  3BC7: 9af6081d0d       lcall 0xd1d, 0x8f6
  06F6CC  3BCC: 83c402           add sp, 2
  06F6CF  3BCF: a3c89c           mov word ptr [0x9cc8], ax
  06F6D2  3BD2: 8b46ea           mov ax, word ptr [bp - 0x16]
  06F6D5  3BD5: 5e               pop si
  06F6D6  3BD6: 5f               pop di
  06F6D7  3BD7: c9               leave 
  06F6D8  3BD8: cb               retf 

; ---- func_06F6DA  size=372  insns=114  prologue=ENTER 0x000E,0  terminal=page-end ----
  06F6DA  3BDA: c80e0000         enter 0xe, 0
  06F6DE  3BDE: b80100           mov ax, 1
  06F6E1  3BE1: 8946f4           mov word ptr [bp - 0xc], ax
  06F6E4  3BE4: 8946f2           mov word ptr [bp - 0xe], ax
  06F6E7  3BE7: 8d46fa           lea ax, [bp - 6]
  06F6EA  3BEA: 8946f6           mov word ptr [bp - 0xa], ax
  06F6ED  3BED: 8c56f8           mov word ptr [bp - 8], ss
  06F6F0  3BF0: 8d1e0a20         lea bx, [0x200a]
  06F6F4  3BF4: 2bc0             sub ax, ax
  06F6F6  3BF6: 9a72031f1a       lcall 0x1a1f, 0x372
  06F6FB  3BFB: 8946fc           mov word ptr [bp - 4], ax
  06F6FE  3BFE: 8956fe           mov word ptr [bp - 2], dx
  06F701  3C01: 0bd0             or dx, ax
  06F703  3C03: 7503             jne 0x3c08
  06F705  3C05: e9df00           jmp 0x3ce7
  06F708  3C08: ff76fe           push word ptr [bp - 2]
  06F70B  3C0B: 50               push ax
  06F70C  3C0C: 6a00             push 0
  06F70E  3C0E: b80100           mov ax, 1
  06F711  3C11: 8d5ef2           lea bx, [bp - 0xe]
  06F714  3C14: 2bd2             sub dx, dx
  06F716  3C16: 9a54021f18       lcall 0x181f, 0x254
  06F71B  3C1B: 8a46fa           mov al, byte ptr [bp - 6]
  06F71E  3C1E: 2ae4             sub ah, ah
  06F720  3C20: a33c1f           mov word ptr [0x1f3c], ax
  06F723  3C23: ff76fe           push word ptr [bp - 2]
  06F726  3C26: ff76fc           push word ptr [bp - 4]
  06F729  3C29: 6a00             push 0
  06F72B  3C2B: b80200           mov ax, 2
  06F72E  3C2E: 8d5ef2           lea bx, [bp - 0xe]
  06F731  3C31: 2bd2             sub dx, dx
  06F733  3C33: 9a54021f18       lcall 0x181f, 0x254
  06F738  3C38: 8a46fa           mov al, byte ptr [bp - 6]
  06F73B  3C3B: 2ae4             sub ah, ah
  06F73D  3C3D: a33e1f           mov word ptr [0x1f3e], ax
  06F740  3C40: ff76fe           push word ptr [bp - 2]
  06F743  3C43: ff76fc           push word ptr [bp - 4]
  06F746  3C46: 6a00             push 0
  06F748  3C48: b80300           mov ax, 3
  06F74B  3C4B: 8d5ef2           lea bx, [bp - 0xe]
  06F74E  3C4E: 2bd2             sub dx, dx
  06F750  3C50: 9a54021f18       lcall 0x181f, 0x254
  06F755  3C55: 8a46fa           mov al, byte ptr [bp - 6]
  06F758  3C58: 2ae4             sub ah, ah
  06F75A  3C5A: a3401f           mov word ptr [0x1f40], ax
  06F75D  3C5D: ff76fe           push word ptr [bp - 2]
  06F760  3C60: ff76fc           push word ptr [bp - 4]
  06F763  3C63: 6a00             push 0
  06F765  3C65: b80400           mov ax, 4
  06F768  3C68: 8d5ef2           lea bx, [bp - 0xe]
  06F76B  3C6B: 2bd2             sub dx, dx
  06F76D  3C6D: 9a54021f18       lcall 0x181f, 0x254
  06F772  3C72: 8a46fa           mov al, byte ptr [bp - 6]
  06F775  3C75: 2ae4             sub ah, ah
  06F777  3C77: a3421f           mov word ptr [0x1f42], ax
  06F77A  3C7A: ff76fe           push word ptr [bp - 2]
  06F77D  3C7D: ff76fc           push word ptr [bp - 4]
  06F780  3C80: 6a00             push 0
  06F782  3C82: b80500           mov ax, 5
  06F785  3C85: 8d5ef2           lea bx, [bp - 0xe]
  06F788  3C88: 2bd2             sub dx, dx
  06F78A  3C8A: 9a54021f18       lcall 0x181f, 0x254
  06F78F  3C8F: 8a46fa           mov al, byte ptr [bp - 6]
  06F792  3C92: 2ae4             sub ah, ah
  06F794  3C94: a34a1f           mov word ptr [0x1f4a], ax
  06F797  3C97: ff76fe           push word ptr [bp - 2]
  06F79A  3C9A: ff76fc           push word ptr [bp - 4]
  06F79D  3C9D: 6a00             push 0
  06F79F  3C9F: b80600           mov ax, 6
  06F7A2  3CA2: 8d5ef2           lea bx, [bp - 0xe]
  06F7A5  3CA5: 2bd2             sub dx, dx
  06F7A7  3CA7: 9a54021f18       lcall 0x181f, 0x254
  06F7AC  3CAC: 8a46fa           mov al, byte ptr [bp - 6]
  06F7AF  3CAF: 2ae4             sub ah, ah
  06F7B1  3CB1: a34e1f           mov word ptr [0x1f4e], ax
  06F7B4  3CB4: ff76fe           push word ptr [bp - 2]
  06F7B7  3CB7: ff76fc           push word ptr [bp - 4]
  06F7BA  3CBA: 6a00             push 0
  06F7BC  3CBC: b80700           mov ax, 7
  06F7BF  3CBF: 8d5ef2           lea bx, [bp - 0xe]
  06F7C2  3CC2: 2bd2             sub dx, dx
  06F7C4  3CC4: 9a54021f18       lcall 0x181f, 0x254
  06F7C9  3CC9: 8a46fa           mov al, byte ptr [bp - 6]
  06F7CC  3CCC: 2ae4             sub ah, ah
  06F7CE  3CCE: a34c1f           mov word ptr [0x1f4c], ax
  06F7D1  3CD1: 6800a0           push 0xa000
  06F7D4  3CD4: 6800fc           push 0xfc00
  06F7D7  3CD7: 9af4031f18       lcall 0x181f, 0x3f4
  06F7DC  3CDC: ff76fe           push word ptr [bp - 2]
  06F7DF  3CDF: ff76fc           push word ptr [bp - 4]
  06F7E2  3CE2: 9aa8011f19       lcall 0x191f, 0x1a8
  06F7E7  3CE7: c9               leave 
  06F7E8  3CE8: cb               retf 
  06F7E9  3CE9: 90               nop 
  06F7EA  3CEA: ea16041f18       ljmp 0x181f:0x416
  06F7EF  3CEF: ea98091f18       ljmp 0x181f:0x998
  06F7F4  3CF4: ea20011f19       ljmp 0x191f:0x120
  06F7F9  3CF9: ea6a011f19       ljmp 0x191f:0x16a
  06F7FE  3CFE: ea76011f19       ljmp 0x191f:0x176
  06F803  3D03: ea82011f19       ljmp 0x191f:0x182
  06F808  3D08: ea3c021f19       ljmp 0x191f:0x23c
  06F80D  3D0D: eac6081f19       ljmp 0x191f:0x8c6
  06F812  3D12: ead2081f19       ljmp 0x191f:0x8d2
  06F817  3D17: ea10091f19       ljmp 0x191f:0x910
  06F81C  3D1C: ea10071f1a       ljmp 0x1a1f:0x710
  06F821  3D21: ea9e0a1f1a       ljmp 0x1a1f:0xa9e
  06F826  3D26: eaaa0a1f1a       ljmp 0x1a1f:0xaaa
  06F82B  3D2B: eab60a1f1a       ljmp 0x1a1f:0xab6
  06F830  3D30: eac20a1f1a       ljmp 0x1a1f:0xac2
  06F835  3D35: eace0a1f1a       ljmp 0x1a1f:0xace
  06F83A  3D3A: eada0a1f1a       ljmp 0x1a1f:0xada
  06F83F  3D3F: eae60a1f1a       ljmp 0x1a1f:0xae6
  06F844  3D44: eaf20a1f1a       ljmp 0x1a1f:0xaf2
  06F849  3D49: ea0a0b1f1a       ljmp 0x1a1f:0xb0a
