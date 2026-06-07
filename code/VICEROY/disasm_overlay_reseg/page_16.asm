; ============================================================
; VICEROY.EXE overlay page 0x16 (record 21) -- RE-SEGMENTED
; file_offset (disk image) = 0x068980
; code_offset (first insn) = 0x068EE0
; code_end (next reloc hdr)= 0x06BB00  [resident size 706 para -> nominal_end 0x06B5A0; on-disk code spills past it]
; reloc_count = 332  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x068980)
; functions in page = 23
; ============================================================

; ---- func_068EE0  size=87  insns=26  prologue=no-frame (first byte 0xA1)  terminal=RETF ----
  068EE0  0560: a1b01e           mov ax, word ptr [0x1eb0]
  068EE3  0563: 0b06ae1e         or ax, word ptr [0x1eae]
  068EE7  0567: 740d             je 0x576
  068EE9  0569: ff36b01e         push word ptr [0x1eb0]
  068EED  056D: ff36ae1e         push word ptr [0x1eae]
  068EF1  0571: 9aa8011f19       lcall 0x191f, 0x1a8
  068EF6  0576: a1ac1e           mov ax, word ptr [0x1eac]
  068EF9  0579: 0b06aa1e         or ax, word ptr [0x1eaa]
  068EFD  057D: 740d             je 0x58c
  068EFF  057F: ff36ac1e         push word ptr [0x1eac]
  068F03  0583: ff36aa1e         push word ptr [0x1eaa]
  068F07  0587: 9aa8011f19       lcall 0x191f, 0x1a8
  068F0C  058C: a1a81e           mov ax, word ptr [0x1ea8]
  068F0F  058F: 0b06a61e         or ax, word ptr [0x1ea6]
  068F13  0593: 740d             je 0x5a2
  068F15  0595: ff36a81e         push word ptr [0x1ea8]
  068F19  0599: ff36a61e         push word ptr [0x1ea6]
  068F1D  059D: 9aa8011f19       lcall 0x191f, 0x1a8
  068F22  05A2: 2bc0             sub ax, ax
  068F24  05A4: a3a81e           mov word ptr [0x1ea8], ax
  068F27  05A7: a3a61e           mov word ptr [0x1ea6], ax
  068F2A  05AA: a3ac1e           mov word ptr [0x1eac], ax
  068F2D  05AD: a3aa1e           mov word ptr [0x1eaa], ax
  068F30  05B0: a3b01e           mov word ptr [0x1eb0], ax
  068F33  05B3: a3ae1e           mov word ptr [0x1eae], ax
  068F36  05B6: cb               retf 

; ---- func_068F38  size=104  insns=36  prologue=ENTER 0x0002,0  terminal=RETF ----
  068F38  05B8: c8020000         enter 2, 0
  068F3C  05BC: c746fe0100       mov word ptr [bp - 2], 1
  068F41  05C1: b8b001           mov ax, 0x1b0
  068F44  05C4: 99               cdq 
  068F45  05C5: 9a9a021f18       lcall 0x181f, 0x29a
  068F4A  05CA: a3a61e           mov word ptr [0x1ea6], ax
  068F4D  05CD: 8916a81e         mov word ptr [0x1ea8], dx
  068F51  05D1: 8bc2             mov ax, dx
  068F53  05D3: 0b06a61e         or ax, word ptr [0x1ea6]
  068F57  05D7: 7438             je 0x611
  068F59  05D9: b8d800           mov ax, 0xd8
  068F5C  05DC: 99               cdq 
  068F5D  05DD: 9a9a021f18       lcall 0x181f, 0x29a
  068F62  05E2: a3aa1e           mov word ptr [0x1eaa], ax
  068F65  05E5: 8916ac1e         mov word ptr [0x1eac], dx
  068F69  05E9: 8bc2             mov ax, dx
  068F6B  05EB: 0b06aa1e         or ax, word ptr [0x1eaa]
  068F6F  05EF: 7420             je 0x611
  068F71  05F1: b8d800           mov ax, 0xd8
  068F74  05F4: 99               cdq 
  068F75  05F5: 9a9a021f18       lcall 0x181f, 0x29a
  068F7A  05FA: a3ae1e           mov word ptr [0x1eae], ax
  068F7D  05FD: 8916b01e         mov word ptr [0x1eb0], dx
  068F81  0601: 8bc2             mov ax, dx
  068F83  0603: 0b06ae1e         or ax, word ptr [0x1eae]
  068F87  0607: 7408             je 0x611
  068F89  0609: 2bc0             sub ax, ax
  068F8B  060B: a3aaa5           mov word ptr [0xa5aa], ax
  068F8E  060E: 8946fe           mov word ptr [bp - 2], ax
  068F91  0611: 837efe00         cmp word ptr [bp - 2], 0
  068F95  0615: 7404             je 0x61b
  068F97  0617: 0e               push cs
  068F98  0618: e81a27           call 0x2d35
  068F9B  061B: 8b46fe           mov ax, word ptr [bp - 2]
  068F9E  061E: c9               leave 
  068F9F  061F: cb               retf 

; ---- func_068FA0  size=59  insns=21  prologue=push bp;mov bp,sp  terminal=RETF ----
  068FA0  0620: 55               push bp
  068FA1  0621: 8bec             mov bp, sp
  068FA3  0623: 56               push si
  068FA4  0624: 813eaaa5d800     cmp word ptr [0xa5aa], 0xd8
  068FAA  062A: 7d2c             jge 0x658
  068FAC  062C: 8b4606           mov ax, word ptr [bp + 6]
  068FAF  062F: 8b1eaaa5         mov bx, word ptr [0xa5aa]
  068FB3  0633: d1e3             shl bx, 1
  068FB5  0635: c436a61e         les si, ptr [0x1ea6]
  068FB9  0639: 268900           mov word ptr es:[bx + si], ax
  068FBC  063C: 8a4608           mov al, byte ptr [bp + 8]
  068FBF  063F: c41eaa1e         les bx, ptr [0x1eaa]
  068FC3  0643: 8b36aaa5         mov si, word ptr [0xa5aa]
  068FC7  0647: 268800           mov byte ptr es:[bx + si], al
  068FCA  064A: 8a460a           mov al, byte ptr [bp + 0xa]
  068FCD  064D: c41eae1e         les bx, ptr [0x1eae]
  068FD1  0651: 268800           mov byte ptr es:[bx + si], al
  068FD4  0654: ff06aaa5         inc word ptr [0xa5aa]
  068FD8  0658: 5e               pop si
  068FD9  0659: c9               leave 
  068FDA  065A: cb               retf 

; ---- func_068FDC  size=124  insns=44  prologue=ENTER 0x0006,0  terminal=RETF ----
  068FDC  065C: c8060000         enter 6, 0
  068FE0  0660: 57               push di
  068FE1  0661: 56               push si
  068FE2  0662: 8b5e06           mov bx, word ptr [bp + 6]
  068FE5  0665: d1e3             shl bx, 1
  068FE7  0667: c436a61e         les si, ptr [0x1ea6]
  068FEB  066B: 268b00           mov ax, word ptr es:[bx + si]
  068FEE  066E: 8946fc           mov word ptr [bp - 4], ax
  068FF1  0671: 8bc3             mov ax, bx
  068FF3  0673: c41eaa1e         les bx, ptr [0x1eaa]
  068FF7  0677: 8b7606           mov si, word ptr [bp + 6]
  068FFA  067A: 268a08           mov cl, byte ptr es:[bx + si]
  068FFD  067D: 884efe           mov byte ptr [bp - 2], cl
  069000  0680: c41eae1e         les bx, ptr [0x1eae]
  069004  0684: 268a08           mov cl, byte ptr es:[bx + si]
  069007  0687: 884efa           mov byte ptr [bp - 6], cl
  06900A  068A: 8b5e08           mov bx, word ptr [bp + 8]
  06900D  068D: d1e3             shl bx, 1
  06900F  068F: c43ea61e         les di, ptr [0x1ea6]
  069013  0693: 268b09           mov cx, word ptr es:[bx + di]
  069016  0696: 8bd3             mov dx, bx
  069018  0698: 8bd8             mov bx, ax
  06901A  069A: 268909           mov word ptr es:[bx + di], cx
  06901D  069D: c41eaa1e         les bx, ptr [0x1eaa]
  069021  06A1: 8b7e08           mov di, word ptr [bp + 8]
  069024  06A4: 268a01           mov al, byte ptr es:[bx + di]
  069027  06A7: 268800           mov byte ptr es:[bx + si], al
  06902A  06AA: c41eae1e         les bx, ptr [0x1eae]
  06902E  06AE: 268a01           mov al, byte ptr es:[bx + di]
  069031  06B1: 268800           mov byte ptr es:[bx + si], al
  069034  06B4: 8b46fc           mov ax, word ptr [bp - 4]
  069037  06B7: 8bda             mov bx, dx
  069039  06B9: c436a61e         les si, ptr [0x1ea6]
  06903D  06BD: 268900           mov word ptr es:[bx + si], ax
  069040  06C0: 8a46fe           mov al, byte ptr [bp - 2]
  069043  06C3: c41eaa1e         les bx, ptr [0x1eaa]
  069047  06C7: 268801           mov byte ptr es:[bx + di], al
  06904A  06CA: 8a46fa           mov al, byte ptr [bp - 6]
  06904D  06CD: c41eae1e         les bx, ptr [0x1eae]
  069051  06D1: 268801           mov byte ptr es:[bx + di], al
  069054  06D4: 5e               pop si
  069055  06D5: 5f               pop di
  069056  06D6: c9               leave 
  069057  06D7: cb               retf 

; ---- func_069058  size=253  insns=90  prologue=ENTER 0x001C,0  terminal=RETF ----
  069058  06D8: c81c0000         enter 0x1c, 0
  06905C  06DC: 57               push di
  06905D  06DD: 56               push si
  06905E  06DE: c746f80000       mov word ptr [bp - 8], 0
  069063  06E3: c746fa0000       mov word ptr [bp - 6], 0
  069068  06E8: 8b46f8           mov ax, word ptr [bp - 8]
  06906B  06EB: 8946f4           mov word ptr [bp - 0xc], ax
  06906E  06EE: e9ce00           jmp 0x7bf
  069071  06F1: 90               nop 
  069072  06F2: a1aaa5           mov ax, word ptr [0xa5aa]
  069075  06F5: 48               dec ax
  069076  06F6: 3b46f4           cmp ax, word ptr [bp - 0xc]
  069079  06F9: 7f03             jg 0x6fe
  06907B  06FB: e9ca00           jmp 0x7c8
  06907E  06FE: 8b5ef4           mov bx, word ptr [bp - 0xc]
  069081  0701: d1e3             shl bx, 1
  069083  0703: 8bc3             mov ax, bx
  069085  0705: 031ea61e         add bx, word ptr [0x1ea6]
  069089  0709: 8e06a81e         mov es, word ptr [0x1ea8]
  06908D  070D: 26ff7702         push word ptr es:[bx + 2]
  069091  0711: 8bf0             mov si, ax
  069093  0713: 8bfb             mov di, bx
  069095  0715: 897ee8           mov word ptr [bp - 0x18], di
  069098  0718: 8c46ea           mov word ptr [bp - 0x16], es
  06909B  071B: 9a22001f18       lcall 0x181f, 0x22
  0690A0  0720: 83c402           add sp, 2
  0690A3  0723: 52               push dx
  0690A4  0724: 50               push ax
  0690A5  0725: c45ee8           les bx, ptr [bp - 0x18]
  0690A8  0728: 26ff37           push word ptr es:[bx]
  0690AB  072B: 9a22001f18       lcall 0x181f, 0x22
  0690B0  0730: 83c402           add sp, 2
  0690B3  0733: 52               push dx
  0690B4  0734: 50               push ax
  0690B5  0735: 9a3e101d0d       lcall 0xd1d, 0x103e
  0690BA  073A: 83c408           add sp, 8
  0690BD  073D: 0bc0             or ax, ax
  0690BF  073F: 7e7b             jle 0x7bc
  0690C1  0741: c746fa0100       mov word ptr [bp - 6], 1
  0690C6  0746: 8b46f4           mov ax, word ptr [bp - 0xc]
  0690C9  0749: 48               dec ax
  0690CA  074A: 7902             jns 0x74e
  0690CC  074C: 2bc0             sub ax, ax
  0690CE  074E: 8946f8           mov word ptr [bp - 8], ax
  0690D1  0751: 0336a61e         add si, word ptr [0x1ea6]
  0690D5  0755: 8e06a81e         mov es, word ptr [0x1ea8]
  0690D9  0759: 268b4402         mov ax, word ptr es:[si + 2]
  0690DD  075D: 8946f0           mov word ptr [bp - 0x10], ax
  0690E0  0760: 8cc0             mov ax, es
  0690E2  0762: c41eaa1e         les bx, ptr [0x1eaa]
  0690E6  0766: 035ef4           add bx, word ptr [bp - 0xc]
  0690E9  0769: 268a4f01         mov cl, byte ptr es:[bx + 1]
  0690ED  076D: 884efc           mov byte ptr [bp - 4], cl
  0690F0  0770: 8cc1             mov cx, es
  0690F2  0772: c43eae1e         les di, ptr [0x1eae]
  0690F6  0776: 037ef4           add di, word ptr [bp - 0xc]
  0690F9  0779: 268a5501         mov dl, byte ptr es:[di + 1]
  0690FD  077D: 8856ec           mov byte ptr [bp - 0x14], dl
  069100  0780: 8cc2             mov dx, es
  069102  0782: 8ec0             mov es, ax
  069104  0784: 8976e4           mov word ptr [bp - 0x1c], si
  069107  0787: 8946e6           mov word ptr [bp - 0x1a], ax
  06910A  078A: 268b04           mov ax, word ptr es:[si]
  06910D  078D: 26894402         mov word ptr es:[si + 2], ax
  069111  0791: 8ec1             mov es, cx
  069113  0793: 268a07           mov al, byte ptr es:[bx]
  069116  0796: 26884701         mov byte ptr es:[bx + 1], al
  06911A  079A: 8ec2             mov es, dx
  06911C  079C: 268a05           mov al, byte ptr es:[di]
  06911F  079F: 26884501         mov byte ptr es:[di + 1], al
  069123  07A3: c476e4           les si, ptr [bp - 0x1c]
  069126  07A6: 8b46f0           mov ax, word ptr [bp - 0x10]
  069129  07A9: 268904           mov word ptr es:[si], ax
  06912C  07AC: 8a46fc           mov al, byte ptr [bp - 4]
  06912F  07AF: 8ec1             mov es, cx
  069131  07B1: 268807           mov byte ptr es:[bx], al
  069134  07B4: 8a46ec           mov al, byte ptr [bp - 0x14]
  069137  07B7: 8ec2             mov es, dx
  069139  07B9: 268805           mov byte ptr es:[di], al
  06913C  07BC: ff46f4           inc word ptr [bp - 0xc]
  06913F  07BF: 837efa00         cmp word ptr [bp - 6], 0
  069143  07C3: 7503             jne 0x7c8
  069145  07C5: e92aff           jmp 0x6f2
  069148  07C8: 837efa00         cmp word ptr [bp - 6], 0
  06914C  07CC: 7403             je 0x7d1
  06914E  07CE: e912ff           jmp 0x6e3
  069151  07D1: 5e               pop si
  069152  07D2: 5f               pop di
  069153  07D3: c9               leave 
  069154  07D4: cb               retf 

; ---- func_069156  size=78  insns=33  prologue=ENTER 0x0004,0  terminal=RETF ----
  069156  07D6: c8040000         enter 4, 0
  06915A  07DA: 8b4606           mov ax, word ptr [bp + 6]
  06915D  07DD: b91800           mov cx, 0x18
  069160  07E0: 99               cdq 
  069161  07E1: f7f9             idiv cx
  069163  07E3: 8956fe           mov word ptr [bp - 2], dx
  069166  07E6: 8b4606           mov ax, word ptr [bp + 6]
  069169  07E9: 99               cdq 
  06916A  07EA: f7f9             idiv cx
  06916C  07EC: 2b06aca5         sub ax, word ptr [0xa5ac]
  069170  07F0: 7805             js 0x7f7
  069172  07F2: 3d0200           cmp ax, 2
  069175  07F5: 7e0b             jle 0x802
  069177  07F7: b8ffff           mov ax, 0xffff
  06917A  07FA: 8b5e08           mov bx, word ptr [bp + 8]
  06917D  07FD: 8907             mov word ptr [bx], ax
  06917F  07FF: eb1c             jmp 0x81d
  069181  0801: 90               nop 
  069182  0802: 6bc064           imul ax, ax, 0x64
  069185  0805: 050500           add ax, 5
  069188  0808: 8b5e08           mov bx, word ptr [bp + 8]
  06918B  080B: 8907             mov word ptr [bx], ax
  06918D  080D: 8b46fe           mov ax, word ptr [bp - 2]
  069190  0810: 8bc8             mov cx, ax
  069192  0812: d1e0             shl ax, 1
  069194  0814: 03c1             add ax, cx
  069196  0816: d1e0             shl ax, 1
  069198  0818: 03c1             add ax, cx
  06919A  081A: 051900           add ax, 0x19
  06919D  081D: 8b5e0a           mov bx, word ptr [bp + 0xa]
  0691A0  0820: 8907             mov word ptr [bx], ax
  0691A2  0822: c9               leave 
  0691A3  0823: cb               retf 

; ---- func_0691A4  size=117  insns=41  prologue=ENTER 0x0008,0  terminal=RETF ----
  0691A4  0824: c8080000         enter 8, 0
  0691A8  0828: c746f8ffff       mov word ptr [bp - 8], 0xffff
  0691AD  082D: 833eea070f       cmp word ptr [0x7ea], 0xf
  0691B2  0832: 7f15             jg 0x849
  0691B4  0834: 813ee807a000     cmp word ptr [0x7e8], 0xa0
  0691BA  083A: 7d08             jge 0x844
  0691BC  083C: c746f8feff       mov word ptr [bp - 8], 0xfffe
  0691C1  0841: eb06             jmp 0x849
  0691C3  0843: 90               nop 
  0691C4  0844: c746f8fdff       mov word ptr [bp - 8], 0xfffd
  0691C9  0849: c746fa0000       mov word ptr [bp - 6], 0
  0691CE  084E: eb3e             jmp 0x88e
  0691D0  0850: 8b46fa           mov ax, word ptr [bp - 6]
  0691D3  0853: 3906aaa5         cmp word ptr [0xa5aa], ax
  0691D7  0857: 7e3b             jle 0x894
  0691D9  0859: 8d4efc           lea cx, [bp - 4]
  0691DC  085C: 51               push cx
  0691DD  085D: 8d4efe           lea cx, [bp - 2]
  0691E0  0860: 51               push cx
  0691E1  0861: 50               push ax
  0691E2  0862: 0e               push cs
  0691E3  0863: e8c524           call 0x2d2b
  0691E6  0866: 83c406           add sp, 6
  0691E9  0869: 837efe00         cmp word ptr [bp - 2], 0
  0691ED  086D: 7c1c             jl 0x88b
  0691EF  086F: 6a07             push 7
  0691F1  0871: 6a64             push 0x64
  0691F3  0873: ff76fc           push word ptr [bp - 4]
  0691F6  0876: ff76fe           push word ptr [bp - 2]
  0691F9  0879: 9aca031f18       lcall 0x181f, 0x3ca
  0691FE  087E: 83c408           add sp, 8
  069201  0881: 0bc0             or ax, ax
  069203  0883: 7406             je 0x88b
  069205  0885: 8b46fa           mov ax, word ptr [bp - 6]
  069208  0888: 8946f8           mov word ptr [bp - 8], ax
  06920B  088B: ff46fa           inc word ptr [bp - 6]
  06920E  088E: 837ef800         cmp word ptr [bp - 8], 0
  069212  0892: 7cbc             jl 0x850
  069214  0894: 8b46f8           mov ax, word ptr [bp - 8]
  069217  0897: c9               leave 
  069218  0898: cb               retf 

; ---- func_06921A  size=97  insns=33  prologue=ENTER 0x0004,0  terminal=RETF ----
  06921A  089A: c8040000         enter 4, 0
  06921E  089E: 56               push si
  06921F  089F: 8b5e06           mov bx, word ptr [bp + 6]
  069222  08A2: d1e3             shl bx, 1
  069224  08A4: c436a61e         les si, ptr [0x1ea6]
  069228  08A8: 26ff30           push word ptr es:[bx + si]
  06922B  08AB: 9a22001f18       lcall 0x181f, 0x22
  069230  08B0: 83c402           add sp, 2
  069233  08B3: 52               push dx
  069234  08B4: 50               push ax
  069235  08B5: 1e               push ds
  069236  08B6: ff7608           push word ptr [bp + 8]
  069239  08B9: 9a7e111d0d       lcall 0xd1d, 0x117e
  06923E  08BE: 83c408           add sp, 8
  069241  08C1: c41eaa1e         les bx, ptr [0x1eaa]
  069245  08C5: 8b7606           mov si, word ptr [bp + 6]
  069248  08C8: 26803802         cmp byte ptr es:[bx + si], 2
  06924C  08CC: 752a             jne 0x8f8
  06924E  08CE: c41eae1e         les bx, ptr [0x1eae]
  069252  08D2: 26803808         cmp byte ptr es:[bx + si], 8
  069256  08D6: 7220             jb 0x8f8
  069258  08D8: 26803810         cmp byte ptr es:[bx + si], 0x10
  06925C  08DC: 731a             jae 0x8f8
  06925E  08DE: ff7608           push word ptr [bp + 8]
  069261  08E1: 9a78011f18       lcall 0x181f, 0x178
  069266  08E6: 83c402           add sp, 2
  069269  08E9: ff36b02d         push word ptr [0x2db0]
  06926D  08ED: ff7608           push word ptr [bp + 8]
  069270  08F0: 9a6e011f18       lcall 0x181f, 0x16e
  069275  08F5: 83c404           add sp, 4
  069278  08F8: 5e               pop si
  069279  08F9: c9               leave 
  06927A  08FA: cb               retf 

; ---- func_06927C  size=32  insns=12  prologue=push bp;mov bp,sp  terminal=RETF ----
  06927C  08FC: 55               push bp
  06927D  08FD: 8bec             mov bp, sp
  06927F  08FF: ff7608           push word ptr [bp + 8]
  069282  0902: 68b21e           push 0x1eb2
  069285  0905: 68b81e           push 0x1eb8
  069288  0908: 9a22041f18       lcall 0x181f, 0x422
  06928D  090D: 8be5             mov sp, bp
  06928F  090F: 683c83           push 0x833c
  069292  0912: ff7606           push word ptr [bp + 6]
  069295  0915: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06929A  091A: c9               leave 
  06929B  091B: cb               retf 

; ---- func_06929C  size=207  insns=62  prologue=push bp;mov bp,sp  terminal=RETF ----
  06929C  091C: 55               push bp
  06929D  091D: 8bec             mov bp, sp
  06929F  091F: ff36ae2d         push word ptr [0x2dae]
  0692A3  0923: ff36ac2d         push word ptr [0x2dac]
  0692A7  0927: ff36aa2d         push word ptr [0x2daa]
  0692AB  092B: ff36a82d         push word ptr [0x2da8]
  0692AF  092F: ff36a483         push word ptr [0x83a4]
  0692B3  0933: ff36a283         push word ptr [0x83a2]
  0692B7  0937: ff36a083         push word ptr [0x83a0]
  0692BB  093B: ff369e83         push word ptr [0x839e]
  0692BF  093F: 68c800           push 0xc8
  0692C2  0942: 2bc0             sub ax, ax
  0692C4  0944: 99               cdq 
  0692C5  0945: bb4001           mov bx, 0x140
  0692C8  0948: 9a44041f18       lcall 0x181f, 0x444
  0692CD  094D: 9a0a041f18       lcall 0x181f, 0x40a
  0692D2  0952: 800e561f20       or byte ptr [0x1f56], 0x20
  0692D7  0957: a19e08           mov ax, word ptr [0x89e]
  0692DA  095A: 8b16a008         mov dx, word ptr [0x8a0]
  0692DE  095E: a39e1f           mov word ptr [0x1f9e], ax
  0692E1  0961: 8916a01f         mov word ptr [0x1fa0], dx
  0692E5  0965: 8d1ebe1e         lea bx, [0x1ebe]
  0692E9  0969: 8b4606           mov ax, word ptr [bp + 6]
  0692EC  096C: 2bd2             sub dx, dx
  0692EE  096E: 9a98091f18       lcall 0x181f, 0x998
  0692F3  0973: a18a26           mov ax, word ptr [0x268a]
  0692F6  0976: 8b168c26         mov dx, word ptr [0x268c]
  0692FA  097A: a39e1f           mov word ptr [0x1f9e], ax
  0692FD  097D: 8916a01f         mov word ptr [0x1fa0], dx
  069301  0981: c9               leave 
  069302  0982: cb               retf 
  069303  0983: 90               nop 
  069304  0984: 6a00             push 0
  069306  0986: ff36ae2d         push word ptr [0x2dae]
  06930A  098A: ff36ac2d         push word ptr [0x2dac]
  06930E  098E: ff36aa2d         push word ptr [0x2daa]
  069312  0992: ff36a82d         push word ptr [0x2da8]
  069316  0996: 68c41e           push 0x1ec4
  069319  0999: 9a7a081f19       lcall 0x191f, 0x87a
  06931E  099E: 83c40c           add sp, 0xc
  069321  09A1: 0bc0             or ax, ax
  069323  09A3: 7417             je 0x9bc
  069325  09A5: ff36ae2d         push word ptr [0x2dae]
  069329  09A9: ff36ac2d         push word ptr [0x2dac]
  06932D  09AD: ff36aa2d         push word ptr [0x2daa]
  069331  09B1: ff36a82d         push word ptr [0x2da8]
  069335  09B5: b008             mov al, 8
  069337  09B7: 9a84041f18       lcall 0x181f, 0x484
  06933C  09BC: ff36ae2d         push word ptr [0x2dae]
  069340  09C0: ff36ac2d         push word ptr [0x2dac]
  069344  09C4: ff36aa2d         push word ptr [0x2daa]
  069348  09C8: ff36a82d         push word ptr [0x2da8]
  06934C  09CC: ff36a483         push word ptr [0x83a4]
  069350  09D0: ff36a283         push word ptr [0x83a2]
  069354  09D4: ff36a083         push word ptr [0x83a0]
  069358  09D8: ff369e83         push word ptr [0x839e]
  06935C  09DC: 68c800           push 0xc8
  06935F  09DF: 2bc0             sub ax, ax
  069361  09E1: 99               cdq 
  069362  09E2: bb4001           mov bx, 0x140
  069365  09E5: 9a44041f18       lcall 0x181f, 0x444
  06936A  09EA: cb               retf 

; ---- func_06936C  size=322  insns=102  prologue=ENTER 0x0058,0  terminal=RETF ----
  06936C  09EC: c8580000         enter 0x58, 0
  069370  09F0: c746aa0a00       mov word ptr [bp - 0x56], 0xa
  069375  09F5: 8b4606           mov ax, word ptr [bp + 6]
  069378  09F8: 051700           add ax, 0x17
  06937B  09FB: 8946ac           mov word ptr [bp - 0x54], ax
  06937E  09FE: 837e0610         cmp word ptr [bp + 6], 0x10
  069382  0A02: 7505             jne 0xa09
  069384  0A04: c746ac3700       mov word ptr [bp - 0x54], 0x37
  069389  0A09: 8b5e06           mov bx, word ptr [bp + 6]
  06938C  0A0C: d1e3             shl bx, 1
  06938E  0A0E: 8b87c097         mov ax, word ptr [bx - 0x6840]
  069392  0A12: 8946fe           mov word ptr [bp - 2], ax
  069395  0A15: 837e0600         cmp word ptr [bp + 6], 0
  069399  0A19: 7d10             jge 0xa2b
  06939B  0A1B: c746ac3a00       mov word ptr [bp - 0x54], 0x3a
  0693A0  0A20: c746080800       mov word ptr [bp + 8], 8
  0693A5  0A25: a11c2f           mov ax, word ptr [0x2f1c]
  0693A8  0A28: 8946fe           mov word ptr [bp - 2], ax
  0693AB  0A2B: 837e0800         cmp word ptr [bp + 8], 0
  0693AF  0A2F: 7c24             jl 0xa55
  0693B1  0A31: ff364008         push word ptr [0x840]
  0693B5  0A35: ff363e08         push word ptr [0x83e]
  0693B9  0A39: 8b460a           mov ax, word ptr [bp + 0xa]
  0693BC  0A3C: 48               dec ax
  0693BD  0A3D: 48               dec ax
  0693BE  0A3E: 50               push ax
  0693BF  0A3F: 8b4608           mov ax, word ptr [bp + 8]
  0693C2  0A42: 055200           add ax, 0x52
  0693C5  0A45: 8d1ea82d         lea bx, [0x2da8]
  0693C9  0A49: 8b56aa           mov dx, word ptr [bp - 0x56]
  0693CC  0A4C: 9a54021f18       lcall 0x181f, 0x254
  0693D1  0A51: 8346aa0e         add word ptr [bp - 0x56], 0xe
  0693D5  0A55: ff364008         push word ptr [0x840]
  0693D9  0A59: ff363e08         push word ptr [0x83e]
  0693DD  0A5D: ff760a           push word ptr [bp + 0xa]
  0693E0  0A60: 8b46ac           mov ax, word ptr [bp - 0x54]
  0693E3  0A63: 8d1ea82d         lea bx, [0x2da8]
  0693E7  0A67: 8b56aa           mov dx, word ptr [bp - 0x56]
  0693EA  0A6A: 9a54021f18       lcall 0x181f, 0x254
  0693EF  0A6F: 8346aa10         add word ptr [bp - 0x56], 0x10
  0693F3  0A73: c746a80000       mov word ptr [bp - 0x58], 0
  0693F8  0A78: ff364008         push word ptr [0x840]
  0693FC  0A7C: ff363e08         push word ptr [0x83e]
  069400  0A80: ff760a           push word ptr [bp + 0xa]
  069403  0A83: 8b46ac           mov ax, word ptr [bp - 0x54]
  069406  0A86: 8d1ea82d         lea bx, [0x2da8]
  06940A  0A8A: 8b56aa           mov dx, word ptr [bp - 0x56]
  06940D  0A8D: 9a54021f18       lcall 0x181f, 0x254
  069412  0A92: 8346aa04         add word ptr [bp - 0x56], 4
  069416  0A96: ff46a8           inc word ptr [bp - 0x58]
  069419  0A99: 837ea806         cmp word ptr [bp - 0x58], 6
  06941D  0A9D: 7cd9             jl 0xa78
  06941F  0A9F: 8346aa0c         add word ptr [bp - 0x56], 0xc
  069423  0AA3: c646ae00         mov byte ptr [bp - 0x52], 0
  069427  0AA7: ff76fe           push word ptr [bp - 2]
  06942A  0AAA: 8d46ae           lea ax, [bp - 0x52]
  06942D  0AAD: 50               push ax
  06942E  0AAE: 9a6e011f18       lcall 0x181f, 0x16e
  069433  0AB3: 83c404           add sp, 4
  069436  0AB6: 837e0800         cmp word ptr [bp + 8], 0
  06943A  0ABA: 7c56             jl 0xb12
  06943C  0ABC: 8d46ae           lea ax, [bp - 0x52]
  06943F  0ABF: 50               push ax
  069440  0AC0: 9a78011f18       lcall 0x181f, 0x178
  069445  0AC5: 83c402           add sp, 2
  069448  0AC8: 8d46ae           lea ax, [bp - 0x52]
  06944B  0ACB: 50               push ax
  06944C  0ACC: 9a1e011f18       lcall 0x181f, 0x11e
  069451  0AD1: 83c402           add sp, 2
  069454  0AD4: ff361e2f         push word ptr [0x2f1e]
  069458  0AD8: 8d46ae           lea ax, [bp - 0x52]
  06945B  0ADB: 50               push ax
  06945C  0ADC: 9a6e011f18       lcall 0x181f, 0x16e
  069461  0AE1: 83c404           add sp, 4
  069464  0AE4: 8d46ae           lea ax, [bp - 0x52]
  069467  0AE7: 50               push ax
  069468  0AE8: 9a78011f18       lcall 0x181f, 0x178
  06946D  0AED: 83c402           add sp, 2
  069470  0AF0: 8b5e08           mov bx, word ptr [bp + 8]
  069473  0AF3: c1e303           shl bx, 3
  069476  0AF6: ffb7a48e         push word ptr [bx - 0x715c]
  06947A  0AFA: 8d46ae           lea ax, [bp - 0x52]
  06947D  0AFD: 50               push ax
  06947E  0AFE: 9a6e011f18       lcall 0x181f, 0x16e
  069483  0B03: 83c404           add sp, 4
  069486  0B06: 8d46ae           lea ax, [bp - 0x52]
  069489  0B09: 50               push ax
  06948A  0B0A: 9a28011f18       lcall 0x181f, 0x128
  06948F  0B0F: 83c402           add sp, 2
  069492  0B12: a03008           mov al, byte ptr [0x830]
  069495  0B15: 2ae4             sub ah, ah
  069497  0B17: 50               push ax
  069498  0B18: 8b460a           mov ax, word ptr [bp + 0xa]
  06949B  0B1B: 050400           add ax, 4
  06949E  0B1E: 50               push ax
  06949F  0B1F: ff76aa           push word ptr [bp - 0x56]
  0694A2  0B22: 8d46ae           lea ax, [bp - 0x52]
  0694A5  0B25: 16               push ss
  0694A6  0B26: 50               push ax
  0694A7  0B27: 9a3c011f18       lcall 0x181f, 0x13c
  0694AC  0B2C: c9               leave 
  0694AD  0B2D: cb               retf 

; ---- func_0694AE  size=535  insns=187  prologue=ENTER 0x0066,0  terminal=RETF ----
  0694AE  0B2E: c8660000         enter 0x66, 0
  0694B2  0B32: 56               push si
  0694B3  0B33: 0e               push cs
  0694B4  0B34: e8db21           call 0x2d12
  0694B7  0B37: a03108           mov al, byte ptr [0x831]
  0694BA  0B3A: 2ae4             sub ah, ah
  0694BC  0B3C: 50               push ax
  0694BD  0B3D: 6a05             push 5
  0694BF  0B3F: 684001           push 0x140
  0694C2  0B42: 6a00             push 0
  0694C4  0B44: ff36922e         push word ptr [0x2e92]
  0694C8  0B48: 9a22001f18       lcall 0x181f, 0x22
  0694CD  0B4D: 83c402           add sp, 2
  0694D0  0B50: 52               push dx
  0694D1  0B51: 50               push ax
  0694D2  0B52: 9a00011f18       lcall 0x181f, 0x100
  0694D7  0B57: 83c40c           add sp, 0xc
  0694DA  0B5A: c41e9e08         les bx, ptr [0x89e]
  0694DE  0B5E: 268a07           mov al, byte ptr es:[bx]
  0694E1  0B61: 2ae4             sub ah, ah
  0694E3  0B63: 050700           add ax, 7
  0694E6  0B66: 8946a8           mov word ptr [bp - 0x58], ax
  0694E9  0B69: c646ae00         mov byte ptr [bp - 0x52], 0
  0694ED  0B6D: 8d46ae           lea ax, [bp - 0x52]
  0694F0  0B70: 50               push ax
  0694F1  0B71: 9a1e011f18       lcall 0x181f, 0x11e
  0694F6  0B76: 83c402           add sp, 2
  0694F9  0B79: 8b5e06           mov bx, word ptr [bp + 6]
  0694FC  0B7C: d1e3             shl bx, 1
  0694FE  0B7E: ffb7c097         push word ptr [bx - 0x6840]
  069502  0B82: 8d46ae           lea ax, [bp - 0x52]
  069505  0B85: 50               push ax
  069506  0B86: 9a6e011f18       lcall 0x181f, 0x16e
  06950B  0B8B: 83c404           add sp, 4
  06950E  0B8E: 8d46ae           lea ax, [bp - 0x52]
  069511  0B91: 50               push ax
  069512  0B92: 9abe011f18       lcall 0x181f, 0x1be
  069517  0B97: 83c402           add sp, 2
  06951A  0B9A: 6a00             push 0
  06951C  0B9C: 8d46ae           lea ax, [bp - 0x52]
  06951F  0B9F: 50               push ax
  069520  0BA0: 0e               push cs
  069521  0BA1: e85a21           call 0x2cfe
  069524  0BA4: 83c404           add sp, 4
  069527  0BA7: 8d46ae           lea ax, [bp - 0x52]
  06952A  0BAA: 50               push ax
  06952B  0BAB: 9a28011f18       lcall 0x181f, 0x128
  069530  0BB0: 83c402           add sp, 2
  069533  0BB3: a03108           mov al, byte ptr [0x831]
  069536  0BB6: 2ae4             sub ah, ah
  069538  0BB8: 50               push ax
  069539  0BB9: ff76a8           push word ptr [bp - 0x58]
  06953C  0BBC: 684001           push 0x140
  06953F  0BBF: 6a00             push 0
  069541  0BC1: 8d46ae           lea ax, [bp - 0x52]
  069544  0BC4: 16               push ss
  069545  0BC5: 50               push ax
  069546  0BC6: 9a00011f18       lcall 0x181f, 0x100
  06954B  0BCB: 83c40c           add sp, 0xc
  06954E  0BCE: c746aa0a00       mov word ptr [bp - 0x56], 0xa
  069553  0BD3: c41e9e08         les bx, ptr [0x89e]
  069557  0BD7: 268a07           mov al, byte ptr es:[bx]
  06955A  0BDA: 2ae4             sub ah, ah
  06955C  0BDC: 050e00           add ax, 0xe
  06955F  0BDF: 0146a8           add word ptr [bp - 0x58], ax
  069562  0BE2: c746fe0000       mov word ptr [bp - 2], 0
  069567  0BE7: 837e0600         cmp word ptr [bp + 6], 0
  06956B  0BEB: 7515             jne 0xc02
  06956D  0BED: 8b4606           mov ax, word ptr [bp + 6]
  069570  0BF0: 89469a           mov word ptr [bp - 0x66], ax
  069573  0BF3: 8946a0           mov word ptr [bp - 0x60], ax
  069576  0BF6: b8ffff           mov ax, 0xffff
  069579  0BF9: 89469c           mov word ptr [bp - 0x64], ax
  06957C  0BFC: 8946a2           mov word ptr [bp - 0x5e], ax
  06957F  0BFF: e9b100           jmp 0xcb3
  069582  0C02: 837e0608         cmp word ptr [bp + 6], 8
  069586  0C06: 7406             je 0xc0e
  069588  0C08: 837e060d         cmp word ptr [bp + 6], 0xd
  06958C  0C0C: 7516             jne 0xc24
  06958E  0C0E: 8b4606           mov ax, word ptr [bp + 6]
  069591  0C11: 8b76fe           mov si, word ptr [bp - 2]
  069594  0C14: d1e6             shl si, 1
  069596  0C16: 89429a           mov word ptr [bp + si - 0x66], ax
  069599  0C19: c742a0ffff       mov word ptr [bp + si - 0x60], 0xffff
  06959E  0C1E: ff46fe           inc word ptr [bp - 2]
  0695A1  0C21: e99400           jmp 0xcb8
  0695A4  0C24: 837e0607         cmp word ptr [bp + 6], 7
  0695A8  0C28: 7510             jne 0xc3a
  0695AA  0C2A: 8b4606           mov ax, word ptr [bp + 6]
  0695AD  0C2D: 8b76fe           mov si, word ptr [bp - 2]
  0695B0  0C30: d1e6             shl si, 1
  0695B2  0C32: 89429a           mov word ptr [bp + si - 0x66], ax
  0695B5  0C35: 8942a0           mov word ptr [bp + si - 0x60], ax
  0695B8  0C38: ebe4             jmp 0xc1e
  0695BA  0C3A: 837e0606         cmp word ptr [bp + 6], 6
  0695BE  0C3E: 740c             je 0xc4c
  0695C0  0C40: 837e060e         cmp word ptr [bp + 6], 0xe
  0695C4  0C44: 7406             je 0xc4c
  0695C6  0C46: 837e060f         cmp word ptr [bp + 6], 0xf
  0695CA  0C4A: 7522             jne 0xc6e
  0695CC  0C4C: b80600           mov ax, 6
  0695CF  0C4F: 8946a0           mov word ptr [bp - 0x60], ax
  0695D2  0C52: 89469a           mov word ptr [bp - 0x66], ax
  0695D5  0C55: b80e00           mov ax, 0xe
  0695D8  0C58: 8946a2           mov word ptr [bp - 0x5e], ax
  0695DB  0C5B: 89469c           mov word ptr [bp - 0x64], ax
  0695DE  0C5E: b80f00           mov ax, 0xf
  0695E1  0C61: 8946a4           mov word ptr [bp - 0x5c], ax
  0695E4  0C64: 89469e           mov word ptr [bp - 0x62], ax
  0695E7  0C67: c746fe0300       mov word ptr [bp - 2], 3
  0695EC  0C6C: eb4a             jmp 0xcb8
  0695EE  0C6E: 837e0605         cmp word ptr [bp + 6], 5
  0695F2  0C72: 7516             jne 0xc8a
  0695F4  0C74: 8b4606           mov ax, word ptr [bp + 6]
  0695F7  0C77: 8946a0           mov word ptr [bp - 0x60], ax
  0695FA  0C7A: 89469a           mov word ptr [bp - 0x66], ax
  0695FD  0C7D: c7469c1000       mov word ptr [bp - 0x64], 0x10
  069602  0C82: c746a20d00       mov word ptr [bp - 0x5e], 0xd
  069607  0C87: eb2a             jmp 0xcb3
  069609  0C89: 90               nop 
  06960A  0C8A: 837e0608         cmp word ptr [bp + 6], 8
  06960E  0C8E: 7d0e             jge 0xc9e
  069610  0C90: 8b4606           mov ax, word ptr [bp + 6]
  069613  0C93: 8946a0           mov word ptr [bp - 0x60], ax
  069616  0C96: 89469a           mov word ptr [bp - 0x66], ax
  069619  0C99: 050800           add ax, 8
  06961C  0C9C: eb0f             jmp 0xcad
  06961E  0C9E: 8b4606           mov ax, word ptr [bp + 6]
  069621  0CA1: 2d0800           sub ax, 8
  069624  0CA4: 8946a0           mov word ptr [bp - 0x60], ax
  069627  0CA7: 89469a           mov word ptr [bp - 0x66], ax
  06962A  0CAA: 8b4606           mov ax, word ptr [bp + 6]
  06962D  0CAD: 8946a2           mov word ptr [bp - 0x5e], ax
  069630  0CB0: 89469c           mov word ptr [bp - 0x64], ax
  069633  0CB3: c746fe0200       mov word ptr [bp - 2], 2
  069638  0CB8: c746a60000       mov word ptr [bp - 0x5a], 0
  06963D  0CBD: eb1d             jmp 0xcdc
  06963F  0CBF: 90               nop 
  069640  0CC0: ff76a8           push word ptr [bp - 0x58]
  069643  0CC3: 8b76a6           mov si, word ptr [bp - 0x5a]
  069646  0CC6: d1e6             shl si, 1
  069648  0CC8: ff72a0           push word ptr [bp + si - 0x60]
  06964B  0CCB: ff729a           push word ptr [bp + si - 0x66]
  06964E  0CCE: 0e               push cs
  06964F  0CCF: e84f20           call 0x2d21
  069652  0CD2: 83c406           add sp, 6
  069655  0CD5: 8346a814         add word ptr [bp - 0x58], 0x14
  069659  0CD9: ff46a6           inc word ptr [bp - 0x5a]
  06965C  0CDC: 8b46fe           mov ax, word ptr [bp - 2]
  06965F  0CDF: 3946a6           cmp word ptr [bp - 0x5a], ax
  069662  0CE2: 7cdc             jl 0xcc0
  069664  0CE4: 68cd1e           push 0x1ecd
  069667  0CE7: 8d46ae           lea ax, [bp - 0x52]
  06966A  0CEA: 50               push ax
  06966B  0CEB: 9ae4071d0d       lcall 0xd1d, 0x7e4
  069670  0CF0: 83c404           add sp, 4
  069673  0CF3: ff7606           push word ptr [bp + 6]
  069676  0CF6: 8d46ae           lea ax, [bp - 0x52]
  069679  0CF9: 16               push ss
  06967A  0CFA: 50               push ax
  06967B  0CFB: 9a82011f18       lcall 0x181f, 0x182
  069680  0D00: 83c406           add sp, 6
  069683  0D03: 8346a80a         add word ptr [bp - 0x58], 0xa
  069687  0D07: 8b46a8           mov ax, word ptr [bp - 0x58]
  06968A  0D0A: a35a1f           mov word ptr [0x1f5a], ax
  06968D  0D0D: 8b5e06           mov bx, word ptr [bp + 6]
  069690  0D10: d1e3             shl bx, 1
  069692  0D12: ffb7c097         push word ptr [bx - 0x6840]
  069696  0D16: 6a00             push 0
  069698  0D18: 9a38041f18       lcall 0x181f, 0x438
  06969D  0D1D: 83c404           add sp, 4
  0696A0  0D20: 8d46ae           lea ax, [bp - 0x52]
  0696A3  0D23: 50               push ax
  0696A4  0D24: 0e               push cs
  0696A5  0D25: e8e51f           call 0x2d0d
  0696A8  0D28: 83c402           add sp, 2
  0696AB  0D2B: 6a00             push 0
  0696AD  0D2D: 684001           push 0x140
  0696B0  0D30: 68c800           push 0xc8
  0696B3  0D33: 2bc0             sub ax, ax
  0696B5  0D35: 99               cdq 
  0696B6  0D36: 2bdb             sub bx, bx
  0696B8  0D38: 9ae2001f18       lcall 0x181f, 0xe2
  0696BD  0D3D: 9ac0031f18       lcall 0x181f, 0x3c0
  0696C2  0D42: 5e               pop si
  0696C3  0D43: c9               leave 
  0696C4  0D44: cb               retf 

; ---- func_0696C6  size=1733  insns=612  prologue=ENTER 0x0062,0  terminal=RETF ----
  0696C6  0D46: c8620000         enter 0x62, 0
  0696CA  0D4A: 56               push si
  0696CB  0D4B: ff369853         push word ptr [0x5398]
  0696CF  0D4F: 6afa             push -6
  0696D1  0D51: 6afa             push -6
  0696D3  0D53: 6a00             push 0
  0696D5  0D55: 9aca011f1a       lcall 0x1a1f, 0x1ca
  0696DA  0D5A: 83c408           add sp, 8
  0696DD  0D5D: 89469e           mov word ptr [bp - 0x62], ax
  0696E0  0D60: 0bc0             or ax, ax
  0696E2  0D62: 7d03             jge 0xd67
  0696E4  0D64: e9a106           jmp 0x1408
  0696E7  0D67: 6bd81c           imul bx, ax, 0x1c
  0696EA  0D6A: c6874c3100       mov byte ptr [bx + 0x314c], 0
  0696EF  0D6F: 8a4606           mov al, byte ptr [bp + 6]
  0696F2  0D72: 88874631         mov byte ptr [bx + 0x3146], al
  0696F6  0D76: c6875b3113       mov byte ptr [bx + 0x315b], 0x13
  0696FB  0D7B: 8bf3             mov si, bx
  0696FD  0D7D: 0e               push cs
  0696FE  0D7E: e8911f           call 0x2d12
  069701  0D81: a03108           mov al, byte ptr [0x831]
  069704  0D84: 2ae4             sub ah, ah
  069706  0D86: 50               push ax
  069707  0D87: 6a05             push 5
  069709  0D89: 684001           push 0x140
  06970C  0D8C: 6a00             push 0
  06970E  0D8E: ff36922e         push word ptr [0x2e92]
  069712  0D92: 9a22001f18       lcall 0x181f, 0x22
  069717  0D97: 83c402           add sp, 2
  06971A  0D9A: 52               push dx
  06971B  0D9B: 50               push ax
  06971C  0D9C: 9a00011f18       lcall 0x181f, 0x100
  069721  0DA1: 83c40c           add sp, 0xc
  069724  0DA4: c41e9e08         les bx, ptr [0x89e]
  069728  0DA8: 268a07           mov al, byte ptr es:[bx]
  06972B  0DAB: 2ae4             sub ah, ah
  06972D  0DAD: 050700           add ax, 7
  069730  0DB0: 8946a8           mov word ptr [bp - 0x58], ax
  069733  0DB3: c646ae00         mov byte ptr [bp - 0x52], 0
  069737  0DB7: 8d46ae           lea ax, [bp - 0x52]
  06973A  0DBA: 50               push ax
  06973B  0DBB: 9a1e011f18       lcall 0x181f, 0x11e
  069740  0DC0: 83c402           add sp, 2
  069743  0DC3: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  069747  0DC7: 2aff             sub bh, bh
  069749  0DC9: 8bc3             mov ax, bx
  06974B  0DCB: d1e3             shl bx, 1
  06974D  0DCD: 03d8             add bx, ax
  06974F  0DCF: d1e3             shl bx, 1
  069751  0DD1: 03d8             add bx, ax
  069753  0DD3: d1e3             shl bx, 1
  069755  0DD5: ffb73052         push word ptr [bx + 0x5230]
  069759  0DD9: 8d46ae           lea ax, [bp - 0x52]
  06975C  0DDC: 50               push ax
  06975D  0DDD: 9a6e011f18       lcall 0x181f, 0x16e
  069762  0DE2: 83c404           add sp, 4
  069765  0DE5: 8d46ae           lea ax, [bp - 0x52]
  069768  0DE8: 50               push ax
  069769  0DE9: 9abe011f18       lcall 0x181f, 0x1be
  06976E  0DEE: 83c402           add sp, 2
  069771  0DF1: 6a01             push 1
  069773  0DF3: 8d46ae           lea ax, [bp - 0x52]
  069776  0DF6: 50               push ax
  069777  0DF7: 0e               push cs
  069778  0DF8: e8031f           call 0x2cfe
  06977B  0DFB: 83c404           add sp, 4
  06977E  0DFE: 8d46ae           lea ax, [bp - 0x52]
  069781  0E01: 50               push ax
  069782  0E02: 9a28011f18       lcall 0x181f, 0x128
  069787  0E07: 83c402           add sp, 2
  06978A  0E0A: a03108           mov al, byte ptr [0x831]
  06978D  0E0D: 2ae4             sub ah, ah
  06978F  0E0F: 50               push ax
  069790  0E10: ff76a8           push word ptr [bp - 0x58]
  069793  0E13: 684001           push 0x140
  069796  0E16: 6a00             push 0
  069798  0E18: 8d46ae           lea ax, [bp - 0x52]
  06979B  0E1B: 16               push ss
  06979C  0E1C: 50               push ax
  06979D  0E1D: 9a00011f18       lcall 0x181f, 0x100
  0697A2  0E22: 83c40c           add sp, 0xc
  0697A5  0E25: c41e9e08         les bx, ptr [0x89e]
  0697A9  0E29: 268a07           mov al, byte ptr es:[bx]
  0697AC  0E2C: 2ae4             sub ah, ah
  0697AE  0E2E: 050e00           add ax, 0xe
  0697B1  0E31: 0146a8           add word ptr [bp - 0x58], ax
  0697B4  0E34: b80800           mov ax, 8
  0697B7  0E37: 8946aa           mov word ptr [bp - 0x56], ax
  0697BA  0E3A: 8946a0           mov word ptr [bp - 0x60], ax
  0697BD  0E3D: 80bc463100       cmp byte ptr [si + 0x3146], 0
  0697C2  0E42: 7403             je 0xe47
  0697C4  0E44: e9b500           jmp 0xefc
  0697C7  0E47: c6845b311c       mov byte ptr [si + 0x315b], 0x1c
  0697CC  0E4C: ff76a8           push word ptr [bp - 0x58]
  0697CF  0E4F: 6a00             push 0
  0697D1  0E51: 6a64             push 0x64
  0697D3  0E53: 8b469e           mov ax, word ptr [bp - 0x62]
  0697D6  0E56: 2bd2             sub dx, dx
  0697D8  0E58: bb0800           mov bx, 8
  0697DB  0E5B: 9abc021f18       lcall 0x181f, 0x2bc
  0697E0  0E60: c746a01a00       mov word ptr [bp - 0x60], 0x1a
  0697E5  0E65: c746fe0100       mov word ptr [bp - 2], 1
  0697EA  0E6A: c746a41900       mov word ptr [bp - 0x5c], 0x19
  0697EF  0E6F: 8a46a4           mov al, byte ptr [bp - 0x5c]
  0697F2  0E72: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  0697F6  0E76: 88875b31         mov byte ptr [bx + 0x315b], al
  0697FA  0E7A: ff76a8           push word ptr [bp - 0x58]
  0697FD  0E7D: 6a00             push 0
  0697FF  0E7F: 6a64             push 0x64
  069801  0E81: 8b469e           mov ax, word ptr [bp - 0x62]
  069804  0E84: 2bd2             sub dx, dx
  069806  0E86: 8b5ea0           mov bx, word ptr [bp - 0x60]
  069809  0E89: 9abc021f18       lcall 0x181f, 0x2bc
  06980E  0E8E: 8346a012         add word ptr [bp - 0x60], 0x12
  069812  0E92: ff46fe           inc word ptr [bp - 2]
  069815  0E95: ff46a4           inc word ptr [bp - 0x5c]
  069818  0E98: 837ea41b         cmp word ptr [bp - 0x5c], 0x1b
  06981C  0E9C: 7ed1             jle 0xe6f
  06981E  0E9E: c746a40000       mov word ptr [bp - 0x5c], 0
  069823  0EA3: eb04             jmp 0xea9
  069825  0EA5: 90               nop 
  069826  0EA6: ff46a4           inc word ptr [bp - 0x5c]
  069829  0EA9: 837ea416         cmp word ptr [bp - 0x5c], 0x16
  06982D  0EAD: 7e03             jle 0xeb2
  06982F  0EAF: e91501           jmp 0xfc7
  069832  0EB2: 837ea413         cmp word ptr [bp - 0x5c], 0x13
  069836  0EB6: 74ee             je 0xea6
  069838  0EB8: 837ea412         cmp word ptr [bp - 0x5c], 0x12
  06983C  0EBC: 74e8             je 0xea6
  06983E  0EBE: 8a46a4           mov al, byte ptr [bp - 0x5c]
  069841  0EC1: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  069845  0EC5: 88875b31         mov byte ptr [bx + 0x315b], al
  069849  0EC9: ff76a8           push word ptr [bp - 0x58]
  06984C  0ECC: 6a00             push 0
  06984E  0ECE: 6a64             push 0x64
  069850  0ED0: 8b469e           mov ax, word ptr [bp - 0x62]
  069853  0ED3: 2bd2             sub dx, dx
  069855  0ED5: 8b5ea0           mov bx, word ptr [bp - 0x60]
  069858  0ED8: 9abc021f18       lcall 0x181f, 0x2bc
  06985D  0EDD: 8346a012         add word ptr [bp - 0x60], 0x12
  069861  0EE1: ff46fe           inc word ptr [bp - 2]
  069864  0EE4: 837efe11         cmp word ptr [bp - 2], 0x11
  069868  0EE8: 7cbc             jl 0xea6
  06986A  0EEA: c746fe0000       mov word ptr [bp - 2], 0
  06986F  0EEF: 8b46aa           mov ax, word ptr [bp - 0x56]
  069872  0EF2: 8946a0           mov word ptr [bp - 0x60], ax
  069875  0EF5: 8346a814         add word ptr [bp - 0x58], 0x14
  069879  0EF9: ebab             jmp 0xea6
  06987B  0EFB: 90               nop 
  06987C  0EFC: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  069880  0F00: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  069885  0F05: 741c             je 0xf23
  069887  0F07: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  06988C  0F0C: 7415             je 0xf23
  06988E  0F0E: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  069893  0F13: 740e             je 0xf23
  069895  0F15: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  06989A  0F1A: 7407             je 0xf23
  06989C  0F1C: 80bf463103       cmp byte ptr [bx + 0x3146], 3
  0698A1  0F21: 755d             jne 0xf80
  0698A3  0F23: ff769e           push word ptr [bp - 0x62]
  0698A6  0F26: 9a780b1f18       lcall 0x181f, 0xb78
  0698AB  0F2B: 83c402           add sp, 2
  0698AE  0F2E: 8946a2           mov word ptr [bp - 0x5e], ax
  0698B1  0F31: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  0698B5  0F35: c6875b3113       mov byte ptr [bx + 0x315b], 0x13
  0698BA  0F3A: ff76a8           push word ptr [bp - 0x58]
  0698BD  0F3D: 6a00             push 0
  0698BF  0F3F: 6a64             push 0x64
  0698C1  0F41: 8b469e           mov ax, word ptr [bp - 0x62]
  0698C4  0F44: 2bd2             sub dx, dx
  0698C6  0F46: 8bf3             mov si, bx
  0698C8  0F48: 8b5ea0           mov bx, word ptr [bp - 0x60]
  0698CB  0F4B: 9abc021f18       lcall 0x181f, 0x2bc
  0698D0  0F50: 8346a012         add word ptr [bp - 0x60], 0x12
  0698D4  0F54: 8a46a2           mov al, byte ptr [bp - 0x5e]
  0698D7  0F57: 88845b31         mov byte ptr [si + 0x315b], al
  0698DB  0F5B: 837ea217         cmp word ptr [bp - 0x5e], 0x17
  0698DF  0F5F: 7505             jne 0xf66
  0698E1  0F61: c6845b3115       mov byte ptr [si + 0x315b], 0x15
  0698E6  0F66: ff76a8           push word ptr [bp - 0x58]
  0698E9  0F69: 6a00             push 0
  0698EB  0F6B: 6a64             push 0x64
  0698ED  0F6D: 8b469e           mov ax, word ptr [bp - 0x62]
  0698F0  0F70: 2bd2             sub dx, dx
  0698F2  0F72: 8b5ea0           mov bx, word ptr [bp - 0x60]
  0698F5  0F75: 9abc021f18       lcall 0x181f, 0x2bc
  0698FA  0F7A: 8346a012         add word ptr [bp - 0x60], 0x12
  0698FE  0F7E: eb47             jmp 0xfc7
  069900  0F80: ff76a8           push word ptr [bp - 0x58]
  069903  0F83: 6a00             push 0
  069905  0F85: 6a64             push 0x64
  069907  0F87: 8b469e           mov ax, word ptr [bp - 0x62]
  06990A  0F8A: 2bd2             sub dx, dx
  06990C  0F8C: 8b5ea0           mov bx, word ptr [bp - 0x60]
  06990F  0F8F: 9abc021f18       lcall 0x181f, 0x2bc
  069914  0F94: 8346a012         add word ptr [bp - 0x60], 0x12
  069918  0F98: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  06991C  0F9C: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  069921  0FA1: 7524             jne 0xfc7
  069923  0FA3: 808f483180       or byte ptr [bx + 0x3148], 0x80
  069928  0FA8: ff76a8           push word ptr [bp - 0x58]
  06992B  0FAB: 6a00             push 0
  06992D  0FAD: 6a64             push 0x64
  06992F  0FAF: 8b469e           mov ax, word ptr [bp - 0x62]
  069932  0FB2: 2bd2             sub dx, dx
  069934  0FB4: 8bf3             mov si, bx
  069936  0FB6: 8b5ea0           mov bx, word ptr [bp - 0x60]
  069939  0FB9: 9abc021f18       lcall 0x181f, 0x2bc
  06993E  0FBE: 8346a012         add word ptr [bp - 0x60], 0x12
  069942  0FC2: 80a448317f       and byte ptr [si + 0x3148], 0x7f
  069947  0FC7: c646ae00         mov byte ptr [bp - 0x52], 0
  06994B  0FCB: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  06994F  0FCF: 8d874631         lea ax, [bx + 0x3146]
  069953  0FD3: 8bd8             mov bx, ax
  069955  0FD5: 8a1f             mov bl, byte ptr [bx]
  069957  0FD7: 2aff             sub bh, bh
  069959  0FD9: 8bcb             mov cx, bx
  06995B  0FDB: d1e3             shl bx, 1
  06995D  0FDD: 03d9             add bx, cx
  06995F  0FDF: d1e3             shl bx, 1
  069961  0FE1: 03d9             add bx, cx
  069963  0FE3: d1e3             shl bx, 1
  069965  0FE5: ffb73052         push word ptr [bx + 0x5230]
  069969  0FE9: 8d4eae           lea cx, [bp - 0x52]
  06996C  0FEC: 51               push cx
  06996D  0FED: 8bf0             mov si, ax
  06996F  0FEF: 9a6e011f18       lcall 0x181f, 0x16e
  069974  0FF4: 83c404           add sp, 4
  069977  0FF7: 803c01           cmp byte ptr [si], 1
  06997A  0FFA: 7414             je 0x1010
  06997C  0FFC: 803c04           cmp byte ptr [si], 4
  06997F  0FFF: 740f             je 0x1010
  069981  1001: 803c02           cmp byte ptr [si], 2
  069984  1004: 740a             je 0x1010
  069986  1006: 803c05           cmp byte ptr [si], 5
  069989  1009: 7405             je 0x1010
  06998B  100B: 803c03           cmp byte ptr [si], 3
  06998E  100E: 7556             jne 0x1066
  069990  1010: 8d46ae           lea ax, [bp - 0x52]
  069993  1013: 50               push ax
  069994  1014: 9a78011f18       lcall 0x181f, 0x178
  069999  1019: 83c402           add sp, 2
  06999C  101C: 8d46ae           lea ax, [bp - 0x52]
  06999F  101F: 50               push ax
  0699A0  1020: 9a1e011f18       lcall 0x181f, 0x11e
  0699A5  1025: 83c402           add sp, 2
  0699A8  1028: ff368e2e         push word ptr [0x2e8e]
  0699AC  102C: 8d46ae           lea ax, [bp - 0x52]
  0699AF  102F: 50               push ax
  0699B0  1030: 9a6e011f18       lcall 0x181f, 0x16e
  0699B5  1035: 83c404           add sp, 4
  0699B8  1038: 8d46ae           lea ax, [bp - 0x52]
  0699BB  103B: 50               push ax
  0699BC  103C: 9a78011f18       lcall 0x181f, 0x178
  0699C1  1041: 83c402           add sp, 2
  0699C4  1044: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  0699C7  1047: c1e303           shl bx, 3
  0699CA  104A: ffb7a48e         push word ptr [bx - 0x715c]
  0699CE  104E: 8d46ae           lea ax, [bp - 0x52]
  0699D1  1051: 50               push ax
  0699D2  1052: 9a6e011f18       lcall 0x181f, 0x16e
  0699D7  1057: 83c404           add sp, 4
  0699DA  105A: 8d46ae           lea ax, [bp - 0x52]
  0699DD  105D: 50               push ax
  0699DE  105E: 9a28011f18       lcall 0x181f, 0x128
  0699E3  1063: 83c402           add sp, 2
  0699E6  1066: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  0699EA  106A: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  0699EF  106F: 7574             jne 0x10e5
  0699F1  1071: 8d46ae           lea ax, [bp - 0x52]
  0699F4  1074: 50               push ax
  0699F5  1075: 8bf3             mov si, bx
  0699F7  1077: 9a78011f18       lcall 0x181f, 0x178
  0699FC  107C: 83c402           add sp, 2
  0699FF  107F: 8d46ae           lea ax, [bp - 0x52]
  069A02  1082: 50               push ax
  069A03  1083: 9a1e011f18       lcall 0x181f, 0x11e
  069A08  1088: 83c402           add sp, 2
  069A0B  108B: ff368e2e         push word ptr [0x2e8e]
  069A0F  108F: 8d46ae           lea ax, [bp - 0x52]
  069A12  1092: 50               push ax
  069A13  1093: 9a6e011f18       lcall 0x181f, 0x16e
  069A18  1098: 83c404           add sp, 4
  069A1B  109B: 8d46ae           lea ax, [bp - 0x52]
  069A1E  109E: 50               push ax
  069A1F  109F: 9a78011f18       lcall 0x181f, 0x178
  069A24  10A4: 83c402           add sp, 2
  069A27  10A7: ff364c2f         push word ptr [0x2f4c]
  069A2B  10AB: 8d46ae           lea ax, [bp - 0x52]
  069A2E  10AE: 50               push ax
  069A2F  10AF: 9a6e011f18       lcall 0x181f, 0x16e
  069A34  10B4: 83c404           add sp, 4
  069A37  10B7: 8d46ae           lea ax, [bp - 0x52]
  069A3A  10BA: 50               push ax
  069A3B  10BB: 9a78011f18       lcall 0x181f, 0x178
  069A40  10C0: 83c402           add sp, 2
  069A43  10C3: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  069A47  10C7: 2aff             sub bh, bh
  069A49  10C9: 8bc3             mov ax, bx
  069A4B  10CB: d1e3             shl bx, 1
  069A4D  10CD: 03d8             add bx, ax
  069A4F  10CF: d1e3             shl bx, 1
  069A51  10D1: 03d8             add bx, ax
  069A53  10D3: d1e3             shl bx, 1
  069A55  10D5: ffb73052         push word ptr [bx + 0x5230]
  069A59  10D9: 8d46ae           lea ax, [bp - 0x52]
  069A5C  10DC: 50               push ax
  069A5D  10DD: 9a6e011f18       lcall 0x181f, 0x16e
  069A62  10E2: 83c404           add sp, 4
  069A65  10E5: a03008           mov al, byte ptr [0x830]
  069A68  10E8: 2ae4             sub ah, ah
  069A6A  10EA: 50               push ax
  069A6B  10EB: 8b46a8           mov ax, word ptr [bp - 0x58]
  069A6E  10EE: 050600           add ax, 6
  069A71  10F1: 50               push ax
  069A72  10F2: ff76a0           push word ptr [bp - 0x60]
  069A75  10F5: 8d46ae           lea ax, [bp - 0x52]
  069A78  10F8: 16               push ss
  069A79  10F9: 50               push ax
  069A7A  10FA: 9a3c011f18       lcall 0x181f, 0x13c
  069A7F  10FF: 83c40a           add sp, 0xa
  069A82  1102: 8946a0           mov word ptr [bp - 0x60], ax
  069A85  1105: 8346a818         add word ptr [bp - 0x58], 0x18
  069A89  1109: 8b46aa           mov ax, word ptr [bp - 0x56]
  069A8C  110C: 8946a0           mov word ptr [bp - 0x60], ax
  069A8F  110F: c646ae00         mov byte ptr [bp - 0x52], 0
  069A93  1113: ff36202f         push word ptr [0x2f20]
  069A97  1117: 8d46ae           lea ax, [bp - 0x52]
  069A9A  111A: 50               push ax
  069A9B  111B: 9a6e011f18       lcall 0x181f, 0x16e
  069AA0  1120: 83c404           add sp, 4
  069AA3  1123: 8d46ae           lea ax, [bp - 0x52]
  069AA6  1126: 50               push ax
  069AA7  1127: 9abe011f18       lcall 0x181f, 0x1be
  069AAC  112C: 83c402           add sp, 2
  069AAF  112F: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  069AB3  1133: 8d874631         lea ax, [bx + 0x3146]
  069AB7  1137: 8bd8             mov bx, ax
  069AB9  1139: 8a1f             mov bl, byte ptr [bx]
  069ABB  113B: 2aff             sub bh, bh
  069ABD  113D: 8bcb             mov cx, bx
  069ABF  113F: d1e3             shl bx, 1
  069AC1  1141: 03d9             add bx, cx
  069AC3  1143: d1e3             shl bx, 1
  069AC5  1145: 03d9             add bx, cx
  069AC7  1147: d1e3             shl bx, 1
  069AC9  1149: 8a8f3552         mov cl, byte ptr [bx + 0x5235]
  069ACD  114D: 2aed             sub ch, ch
  069ACF  114F: 51               push cx
  069AD0  1150: 8d4eae           lea cx, [bp - 0x52]
  069AD3  1153: 16               push ss
  069AD4  1154: 51               push cx
  069AD5  1155: 8bf0             mov si, ax
  069AD7  1157: 9a82011f18       lcall 0x181f, 0x182
  069ADC  115C: 83c406           add sp, 6
  069ADF  115F: 803c0b           cmp byte ptr [si], 0xb
  069AE2  1162: 7403             je 0x1167
  069AE4  1164: e9a700           jmp 0x120e
  069AE7  1167: 6a03             push 3
  069AE9  1169: 8d46ae           lea ax, [bp - 0x52]
  069AEC  116C: 50               push ax
  069AED  116D: 9a96011f18       lcall 0x181f, 0x196
  069AF2  1172: 83c404           add sp, 4
  069AF5  1175: 8d46ae           lea ax, [bp - 0x52]
  069AF8  1178: 50               push ax
  069AF9  1179: 9a1e011f18       lcall 0x181f, 0x11e
  069AFE  117E: 83c402           add sp, 2
  069B01  1181: ff36222f         push word ptr [0x2f22]
  069B05  1185: 8d46ae           lea ax, [bp - 0x52]
  069B08  1188: 50               push ax
  069B09  1189: 9a6e011f18       lcall 0x181f, 0x16e
  069B0E  118E: 83c404           add sp, 4
  069B11  1191: 8d46ae           lea ax, [bp - 0x52]
  069B14  1194: 50               push ax
  069B15  1195: 9abe011f18       lcall 0x181f, 0x1be
  069B1A  119A: 83c402           add sp, 2
  069B1D  119D: 8d46ae           lea ax, [bp - 0x52]
  069B20  11A0: 50               push ax
  069B21  11A1: 9a46011f18       lcall 0x181f, 0x146
  069B26  11A6: 83c402           add sp, 2
  069B29  11A9: 8a1c             mov bl, byte ptr [si]
  069B2B  11AB: 2aff             sub bh, bh
  069B2D  11AD: 8bc3             mov ax, bx
  069B2F  11AF: d1e3             shl bx, 1
  069B31  11B1: 03d8             add bx, ax
  069B33  11B3: d1e3             shl bx, 1
  069B35  11B5: 03d8             add bx, ax
  069B37  11B7: d1e3             shl bx, 1
  069B39  11B9: 8a873652         mov al, byte ptr [bx + 0x5236]
  069B3D  11BD: 2ae4             sub ah, ah
  069B3F  11BF: 8a8f3552         mov cl, byte ptr [bx + 0x5235]
  069B43  11C3: 2aed             sub ch, ch
  069B45  11C5: 2bc1             sub ax, cx
  069B47  11C7: 50               push ax
  069B48  11C8: 8d46ae           lea ax, [bp - 0x52]
  069B4B  11CB: 16               push ss
  069B4C  11CC: 50               push ax
  069B4D  11CD: 9a82011f18       lcall 0x181f, 0x182
  069B52  11D2: 83c406           add sp, 6
  069B55  11D5: 8d46ae           lea ax, [bp - 0x52]
  069B58  11D8: 50               push ax
  069B59  11D9: 9a78011f18       lcall 0x181f, 0x178
  069B5E  11DE: 83c402           add sp, 2
  069B61  11E1: ff364c2f         push word ptr [0x2f4c]
  069B65  11E5: 8d46ae           lea ax, [bp - 0x52]
  069B68  11E8: 50               push ax
  069B69  11E9: 9a6e011f18       lcall 0x181f, 0x16e
  069B6E  11EE: 83c404           add sp, 4
  069B71  11F1: 8d46ae           lea ax, [bp - 0x52]
  069B74  11F4: 50               push ax
  069B75  11F5: 9abe011f18       lcall 0x181f, 0x1be
  069B7A  11FA: 83c402           add sp, 2
  069B7D  11FD: 8d46ae           lea ax, [bp - 0x52]
  069B80  1200: 50               push ax
  069B81  1201: 9a5a011f18       lcall 0x181f, 0x15a
  069B86  1206: 83c402           add sp, 2
  069B89  1209: 6a02             push 2
  069B8B  120B: eb6e             jmp 0x127b
  069B8D  120D: 90               nop 
  069B8E  120E: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  069B92  1212: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  069B97  1217: 7407             je 0x1220
  069B99  1219: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  069B9E  121E: 7574             jne 0x1294
  069BA0  1220: 6a03             push 3
  069BA2  1222: 8d46ae           lea ax, [bp - 0x52]
  069BA5  1225: 50               push ax
  069BA6  1226: 9a96011f18       lcall 0x181f, 0x196
  069BAB  122B: 83c404           add sp, 4
  069BAE  122E: 8d46ae           lea ax, [bp - 0x52]
  069BB1  1231: 50               push ax
  069BB2  1232: 9a1e011f18       lcall 0x181f, 0x11e
  069BB7  1237: 83c402           add sp, 2
  069BBA  123A: ff363c2e         push word ptr [0x2e3c]
  069BBE  123E: 8d46ae           lea ax, [bp - 0x52]
  069BC1  1241: 50               push ax
  069BC2  1242: 9a6e011f18       lcall 0x181f, 0x16e
  069BC7  1247: 83c404           add sp, 4
  069BCA  124A: 8d46ae           lea ax, [bp - 0x52]
  069BCD  124D: 50               push ax
  069BCE  124E: 9abe011f18       lcall 0x181f, 0x1be
  069BD3  1253: 83c402           add sp, 2
  069BD6  1256: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  069BDA  125A: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  069BDE  125E: 2aff             sub bh, bh
  069BE0  1260: 8bc3             mov ax, bx
  069BE2  1262: d1e3             shl bx, 1
  069BE4  1264: 03d8             add bx, ax
  069BE6  1266: d1e3             shl bx, 1
  069BE8  1268: 03d8             add bx, ax
  069BEA  126A: d1e3             shl bx, 1
  069BEC  126C: 8a873652         mov al, byte ptr [bx + 0x5236]
  069BF0  1270: 2ae4             sub ah, ah
  069BF2  1272: 8bc8             mov cx, ax
  069BF4  1274: d1e0             shl ax, 1
  069BF6  1276: 03c1             add ax, cx
  069BF8  1278: d1f8             sar ax, 1
  069BFA  127A: 50               push ax
  069BFB  127B: 8d46ae           lea ax, [bp - 0x52]
  069BFE  127E: 16               push ss
  069BFF  127F: 50               push ax
  069C00  1280: 9a82011f18       lcall 0x181f, 0x182
  069C05  1285: 83c406           add sp, 6
  069C08  1288: 8d46ae           lea ax, [bp - 0x52]
  069C0B  128B: 50               push ax
  069C0C  128C: 9a28011f18       lcall 0x181f, 0x128
  069C11  1291: 83c402           add sp, 2
  069C14  1294: 6a03             push 3
  069C16  1296: 8d46ae           lea ax, [bp - 0x52]
  069C19  1299: 50               push ax
  069C1A  129A: 9a96011f18       lcall 0x181f, 0x196
  069C1F  129F: 83c404           add sp, 4
  069C22  12A2: ff36262f         push word ptr [0x2f26]
  069C26  12A6: 8d46ae           lea ax, [bp - 0x52]
  069C29  12A9: 50               push ax
  069C2A  12AA: 9a6e011f18       lcall 0x181f, 0x16e
  069C2F  12AF: 83c404           add sp, 4
  069C32  12B2: 8d46ae           lea ax, [bp - 0x52]
  069C35  12B5: 50               push ax
  069C36  12B6: 9abe011f18       lcall 0x181f, 0x1be
  069C3B  12BB: 83c402           add sp, 2
  069C3E  12BE: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  069C42  12C2: 8d874631         lea ax, [bx + 0x3146]
  069C46  12C6: b103             mov cl, 3
  069C48  12C8: 8bd8             mov bx, ax
  069C4A  12CA: 8a1f             mov bl, byte ptr [bx]
  069C4C  12CC: 2aff             sub bh, bh
  069C4E  12CE: 8bd3             mov dx, bx
  069C50  12D0: d1e3             shl bx, 1
  069C52  12D2: 03da             add bx, dx
  069C54  12D4: d1e3             shl bx, 1
  069C56  12D6: 03da             add bx, dx
  069C58  12D8: d1e3             shl bx, 1
  069C5A  12DA: 8bd0             mov dx, ax
  069C5C  12DC: 8a873452         mov al, byte ptr [bx + 0x5234]
  069C60  12E0: 2ae4             sub ah, ah
  069C62  12E2: f6f1             div cl
  069C64  12E4: 2ae4             sub ah, ah
  069C66  12E6: 50               push ax
  069C67  12E7: 8d46ae           lea ax, [bp - 0x52]
  069C6A  12EA: 16               push ss
  069C6B  12EB: 50               push ax
  069C6C  12EC: 8bf2             mov si, dx
  069C6E  12EE: 9a82011f18       lcall 0x181f, 0x182
  069C73  12F3: 83c406           add sp, 6
  069C76  12F6: 8a1c             mov bl, byte ptr [si]
  069C78  12F8: 2aff             sub bh, bh
  069C7A  12FA: 8bc3             mov ax, bx
  069C7C  12FC: d1e3             shl bx, 1
  069C7E  12FE: 03d8             add bx, ax
  069C80  1300: d1e3             shl bx, 1
  069C82  1302: 03d8             add bx, ax
  069C84  1304: d1e3             shl bx, 1
  069C86  1306: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  069C8B  130B: 7466             je 0x1373
  069C8D  130D: 6a03             push 3
  069C8F  130F: 8d46ae           lea ax, [bp - 0x52]
  069C92  1312: 50               push ax
  069C93  1313: 9a96011f18       lcall 0x181f, 0x196
  069C98  1318: 83c404           add sp, 4
  069C9B  131B: 8d46ae           lea ax, [bp - 0x52]
  069C9E  131E: 50               push ax
  069C9F  131F: 9a1e011f18       lcall 0x181f, 0x11e
  069CA4  1324: 83c402           add sp, 2
  069CA7  1327: ff36242f         push word ptr [0x2f24]
  069CAB  132B: 8d46ae           lea ax, [bp - 0x52]
  069CAE  132E: 50               push ax
  069CAF  132F: 9a6e011f18       lcall 0x181f, 0x16e
  069CB4  1334: 83c404           add sp, 4
  069CB7  1337: 8d46ae           lea ax, [bp - 0x52]
  069CBA  133A: 50               push ax
  069CBB  133B: 9abe011f18       lcall 0x181f, 0x1be
  069CC0  1340: 83c402           add sp, 2
  069CC3  1343: 8a1c             mov bl, byte ptr [si]
  069CC5  1345: 2aff             sub bh, bh
  069CC7  1347: 8bc3             mov ax, bx
  069CC9  1349: d1e3             shl bx, 1
  069CCB  134B: 03d8             add bx, ax
  069CCD  134D: d1e3             shl bx, 1
  069CCF  134F: 03d8             add bx, ax
  069CD1  1351: d1e3             shl bx, 1
  069CD3  1353: 8a873752         mov al, byte ptr [bx + 0x5237]
  069CD7  1357: 2ae4             sub ah, ah
  069CD9  1359: 50               push ax
  069CDA  135A: 8d46ae           lea ax, [bp - 0x52]
  069CDD  135D: 16               push ss
  069CDE  135E: 50               push ax
  069CDF  135F: 9a82011f18       lcall 0x181f, 0x182
  069CE4  1364: 83c406           add sp, 6
  069CE7  1367: 8d46ae           lea ax, [bp - 0x52]
  069CEA  136A: 50               push ax
  069CEB  136B: 9a28011f18       lcall 0x181f, 0x128
  069CF0  1370: 83c402           add sp, 2
  069CF3  1373: a03008           mov al, byte ptr [0x830]
  069CF6  1376: 2ae4             sub ah, ah
  069CF8  1378: 50               push ax
  069CF9  1379: ff76a8           push word ptr [bp - 0x58]
  069CFC  137C: ff76a0           push word ptr [bp - 0x60]
  069CFF  137F: 8d46ae           lea ax, [bp - 0x52]
  069D02  1382: 16               push ss
  069D03  1383: 50               push ax
  069D04  1384: 9a3c011f18       lcall 0x181f, 0x13c
  069D09  1389: 83c40a           add sp, 0xa
  069D0C  138C: 68d31e           push 0x1ed3
  069D0F  138F: 8d46ae           lea ax, [bp - 0x52]
  069D12  1392: 50               push ax
  069D13  1393: 9ae4071d0d       lcall 0xd1d, 0x7e4
  069D18  1398: 83c404           add sp, 4
  069D1B  139B: ff7606           push word ptr [bp + 6]
  069D1E  139E: 8d46ae           lea ax, [bp - 0x52]
  069D21  13A1: 16               push ss
  069D22  13A2: 50               push ax
  069D23  13A3: 9a82011f18       lcall 0x181f, 0x182
  069D28  13A8: 83c406           add sp, 6
  069D2B  13AB: 8346a80c         add word ptr [bp - 0x58], 0xc
  069D2F  13AF: 8b46a8           mov ax, word ptr [bp - 0x58]
  069D32  13B2: a35a1f           mov word ptr [0x1f5a], ax
  069D35  13B5: 6b5e9e1c         imul bx, word ptr [bp - 0x62], 0x1c
  069D39  13B9: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  069D3D  13BD: 2aff             sub bh, bh
  069D3F  13BF: 8bc3             mov ax, bx
  069D41  13C1: d1e3             shl bx, 1
  069D43  13C3: 03d8             add bx, ax
  069D45  13C5: d1e3             shl bx, 1
  069D47  13C7: 03d8             add bx, ax
  069D49  13C9: d1e3             shl bx, 1
  069D4B  13CB: ffb73052         push word ptr [bx + 0x5230]
  069D4F  13CF: 6a00             push 0
  069D51  13D1: 9a38041f18       lcall 0x181f, 0x438
  069D56  13D6: 83c404           add sp, 4
  069D59  13D9: 8d46ae           lea ax, [bp - 0x52]
  069D5C  13DC: 50               push ax
  069D5D  13DD: 0e               push cs
  069D5E  13DE: e82c19           call 0x2d0d
  069D61  13E1: 83c402           add sp, 2
  069D64  13E4: 6a00             push 0
  069D66  13E6: 684001           push 0x140
  069D69  13E9: 68c800           push 0xc8
  069D6C  13EC: 2bc0             sub ax, ax
  069D6E  13EE: 99               cdq 
  069D6F  13EF: 2bdb             sub bx, bx
  069D71  13F1: 9ae2001f18       lcall 0x181f, 0xe2
  069D76  13F6: 9ac0031f18       lcall 0x181f, 0x3c0
  069D7B  13FB: a19c53           mov ax, word ptr [0x539c]
  069D7E  13FE: 48               dec ax
  069D7F  13FF: 50               push ax
  069D80  1400: 9a08081f18       lcall 0x181f, 0x808
  069D85  1405: 83c402           add sp, 2
  069D88  1408: 5e               pop si
  069D89  1409: c9               leave 
  069D8A  140A: cb               retf 

; ---- func_069D8C  size=2420  insns=787  prologue=ENTER 0x00A8,0  terminal=RETF ----
  069D8C  140C: c8a80000         enter 0xa8, 0
  069D90  1410: 57               push di
  069D91  1411: 56               push si
  069D92  1412: 0e               push cs
  069D93  1413: e8fc18           call 0x2d12
  069D96  1416: a03108           mov al, byte ptr [0x831]
  069D99  1419: 2ae4             sub ah, ah
  069D9B  141B: 50               push ax
  069D9C  141C: 6a05             push 5
  069D9E  141E: 684001           push 0x140
  069DA1  1421: 6a00             push 0
  069DA3  1423: ff36922e         push word ptr [0x2e92]
  069DA7  1427: 9a22001f18       lcall 0x181f, 0x22
  069DAC  142C: 83c402           add sp, 2
  069DAF  142F: 52               push dx
  069DB0  1430: 50               push ax
  069DB1  1431: 9a00011f18       lcall 0x181f, 0x100
  069DB6  1436: 83c40c           add sp, 0xc
  069DB9  1439: c41e9e08         les bx, ptr [0x89e]
  069DBD  143D: 268a07           mov al, byte ptr es:[bx]
  069DC0  1440: 2ae4             sub ah, ah
  069DC2  1442: 050700           add ax, 7
  069DC5  1445: 898678ff         mov word ptr [bp - 0x88], ax
  069DC9  1449: c6468400         mov byte ptr [bp - 0x7c], 0
  069DCD  144D: 8d4684           lea ax, [bp - 0x7c]
  069DD0  1450: 50               push ax
  069DD1  1451: 9a1e011f18       lcall 0x181f, 0x11e
  069DD6  1456: 83c402           add sp, 2
  069DD9  1459: c646d400         mov byte ptr [bp - 0x2c], 0
  069DDD  145D: 8b5e06           mov bx, word ptr [bp + 6]
  069DE0  1460: c1e304           shl bx, 4
  069DE3  1463: ffb7742f         push word ptr [bx + 0x2f74]
  069DE7  1467: 8d46d4           lea ax, [bp - 0x2c]
  069DEA  146A: 50               push ax
  069DEB  146B: 9a6e011f18       lcall 0x181f, 0x16e
  069DF0  1470: 83c404           add sp, 4
  069DF3  1473: 837e0608         cmp word ptr [bp + 6], 8
  069DF7  1477: 7c22             jl 0x149b
  069DF9  1479: 837e0610         cmp word ptr [bp + 6], 0x10
  069DFD  147D: 7d1c             jge 0x149b
  069DFF  147F: 8d46d4           lea ax, [bp - 0x2c]
  069E02  1482: 50               push ax
  069E03  1483: 9a78011f18       lcall 0x181f, 0x178
  069E08  1488: 83c402           add sp, 2
  069E0B  148B: ff36b02d         push word ptr [0x2db0]
  069E0F  148F: 8d46d4           lea ax, [bp - 0x2c]
  069E12  1492: 50               push ax
  069E13  1493: 9a6e011f18       lcall 0x181f, 0x16e
  069E18  1498: 83c404           add sp, 4
  069E1B  149B: 8d46d4           lea ax, [bp - 0x2c]
  069E1E  149E: 50               push ax
  069E1F  149F: 8d4684           lea ax, [bp - 0x7c]
  069E22  14A2: 50               push ax
  069E23  14A3: 9aa4071d0d       lcall 0xd1d, 0x7a4
  069E28  14A8: 83c404           add sp, 4
  069E2B  14AB: 8d4684           lea ax, [bp - 0x7c]
  069E2E  14AE: 50               push ax
  069E2F  14AF: 9abe011f18       lcall 0x181f, 0x1be
  069E34  14B4: 83c402           add sp, 2
  069E37  14B7: 6a02             push 2
  069E39  14B9: 8d4684           lea ax, [bp - 0x7c]
  069E3C  14BC: 50               push ax
  069E3D  14BD: 0e               push cs
  069E3E  14BE: e83d18           call 0x2cfe
  069E41  14C1: 83c404           add sp, 4
  069E44  14C4: 8d4684           lea ax, [bp - 0x7c]
  069E47  14C7: 50               push ax
  069E48  14C8: 9a28011f18       lcall 0x181f, 0x128
  069E4D  14CD: 83c402           add sp, 2
  069E50  14D0: a03108           mov al, byte ptr [0x831]
  069E53  14D3: 2ae4             sub ah, ah
  069E55  14D5: 50               push ax
  069E56  14D6: ffb678ff         push word ptr [bp - 0x88]
  069E5A  14DA: 684001           push 0x140
  069E5D  14DD: 6a00             push 0
  069E5F  14DF: 8d4684           lea ax, [bp - 0x7c]
  069E62  14E2: 16               push ss
  069E63  14E3: 50               push ax
  069E64  14E4: 9a00011f18       lcall 0x181f, 0x100
  069E69  14E9: 83c40c           add sp, 0xc
  069E6C  14EC: c41e9e08         les bx, ptr [0x89e]
  069E70  14F0: 268a07           mov al, byte ptr es:[bx]
  069E73  14F3: 2ae4             sub ah, ah
  069E75  14F5: 40               inc ax
  069E76  14F6: 40               inc ax
  069E77  14F7: 018678ff         add word ptr [bp - 0x88], ax
  069E7B  14FB: c7867cff0700     mov word ptr [bp - 0x84], 7
  069E81  1501: 837e061b         cmp word ptr [bp + 6], 0x1b
  069E85  1505: 7406             je 0x150d
  069E87  1507: 837e061c         cmp word ptr [bp + 6], 0x1c
  069E8B  150B: 7507             jne 0x1514
  069E8D  150D: c746fe0100       mov word ptr [bp - 2], 1
  069E92  1512: eb05             jmp 0x1519
  069E94  1514: c746fe0000       mov word ptr [bp - 2], 0
  069E99  1519: 837e0619         cmp word ptr [bp + 6], 0x19
  069E9D  151D: 7406             je 0x1525
  069E9F  151F: 837e061a         cmp word ptr [bp + 6], 0x1a
  069EA3  1523: 7509             jne 0x152e
  069EA5  1525: c7866eff0100     mov word ptr [bp - 0x92], 1
  069EAB  152B: eb07             jmp 0x1534
  069EAD  152D: 90               nop 
  069EAE  152E: c7866eff0000     mov word ptr [bp - 0x92], 0
  069EB4  1534: 837e0618         cmp word ptr [bp + 6], 0x18
  069EB8  1538: 7506             jne 0x1540
  069EBA  153A: b80100           mov ax, 1
  069EBD  153D: eb03             jmp 0x1542
  069EBF  153F: 90               nop 
  069EC0  1540: 2bc0             sub ax, ax
  069EC2  1542: 89867aff         mov word ptr [bp - 0x86], ax
  069EC6  1546: 837efe00         cmp word ptr [bp - 2], 0
  069ECA  154A: 7408             je 0x1554
  069ECC  154C: c78662ff0300     mov word ptr [bp - 0x9e], 3
  069ED2  1552: eb16             jmp 0x156a
  069ED4  1554: 837e0618         cmp word ptr [bp + 6], 0x18
  069ED8  1558: 7c06             jl 0x1560
  069EDA  155A: 8b4606           mov ax, word ptr [bp + 6]
  069EDD  155D: eb07             jmp 0x1566
  069EDF  155F: 90               nop 
  069EE0  1560: 8a4606           mov al, byte ptr [bp + 6]
  069EE3  1563: 250700           and ax, 7
  069EE6  1566: 898662ff         mov word ptr [bp - 0x9e], ax
  069EEA  156A: c7865aff0000     mov word ptr [bp - 0xa6], 0
  069EF0  1570: 837e0608         cmp word ptr [bp + 6], 8
  069EF4  1574: 7c06             jl 0x157c
  069EF6  1576: 837e0610         cmp word ptr [bp + 6], 0x10
  069EFA  157A: 7c0c             jl 0x1588
  069EFC  157C: 837e0610         cmp word ptr [bp + 6], 0x10
  069F00  1580: 7c0e             jl 0x1590
  069F02  1582: 837e0618         cmp word ptr [bp + 6], 0x18
  069F06  1586: 7d08             jge 0x1590
  069F08  1588: c746800100       mov word ptr [bp - 0x80], 1
  069F0D  158D: eb06             jmp 0x1595
  069F0F  158F: 90               nop 
  069F10  1590: c746800000       mov word ptr [bp - 0x80], 0
  069F15  1595: 837e8000         cmp word ptr [bp - 0x80], 0
  069F19  1599: 7413             je 0x15ae
  069F1B  159B: 83be62ff01       cmp word ptr [bp - 0x9e], 1
  069F20  15A0: 750c             jne 0x15ae
  069F22  15A2: c7865aff0100     mov word ptr [bp - 0xa6], 1
  069F28  15A8: c78662ff1100     mov word ptr [bp - 0x9e], 0x11
  069F2E  15AE: 8b5e06           mov bx, word ptr [bp + 6]
  069F31  15B1: d1e3             shl bx, 1
  069F33  15B3: 8b879201         mov ax, word ptr [bx + 0x192]
  069F37  15B7: 898672ff         mov word ptr [bp - 0x8e], ax
  069F3B  15BB: 8b867cff         mov ax, word ptr [bp - 0x84]
  069F3F  15BF: 8946fc           mov word ptr [bp - 4], ax
  069F42  15C2: 053300           add ax, 0x33
  069F45  15C5: 898666ff         mov word ptr [bp - 0x9a], ax
  069F49  15C9: 8b8e78ff         mov cx, word ptr [bp - 0x88]
  069F4D  15CD: 894e82           mov word ptr [bp - 0x7e], cx
  069F50  15D0: 83c133           add cx, 0x33
  069F53  15D3: 898e5eff         mov word ptr [bp - 0xa2], cx
  069F57  15D7: ff36ae2d         push word ptr [0x2dae]
  069F5B  15DB: ff36ac2d         push word ptr [0x2dac]
  069F5F  15DF: ff36aa2d         push word ptr [0x2daa]
  069F63  15E3: ff36a82d         push word ptr [0x2da8]
  069F67  15E7: 51               push cx
  069F68  15E8: 8a163908         mov dl, byte ptr [0x839]
  069F6C  15EC: 52               push dx
  069F6D  15ED: 8bd8             mov bx, ax
  069F6F  15EF: 8b9678ff         mov dx, word ptr [bp - 0x88]
  069F73  15F3: 8bf0             mov si, ax
  069F75  15F5: 8b867cff         mov ax, word ptr [bp - 0x84]
  069F79  15F9: 8bf9             mov di, cx
  069F7B  15FB: 9ace001f18       lcall 0x181f, 0xce
  069F80  1600: ff36ae2d         push word ptr [0x2dae]
  069F84  1604: ff36ac2d         push word ptr [0x2dac]
  069F88  1608: ff36aa2d         push word ptr [0x2daa]
  069F8C  160C: ff36a82d         push word ptr [0x2da8]
  069F90  1610: 8d45ff           lea ax, [di - 1]
  069F93  1613: 50               push ax
  069F94  1614: a03708           mov al, byte ptr [0x837]
  069F97  1617: 50               push ax
  069F98  1618: 8b867cff         mov ax, word ptr [bp - 0x84]
  069F9C  161C: 40               inc ax
  069F9D  161D: 8d5cff           lea bx, [si - 1]
  069FA0  1620: 8b9678ff         mov dx, word ptr [bp - 0x88]
  069FA4  1624: 42               inc dx
  069FA5  1625: 9ace001f18       lcall 0x181f, 0xce
  069FAA  162A: c7866cff0000     mov word ptr [bp - 0x94], 0
  069FB0  1630: e98502           jmp 0x18b8
  069FB3  1633: 90               nop 
  069FB4  1634: ff367601         push word ptr [0x176]
  069FB8  1638: ff367401         push word ptr [0x174]
  069FBC  163C: ff7682           push word ptr [bp - 0x7e]
  069FBF  163F: b84100           mov ax, 0x41
  069FC2  1642: 8d1ea82d         lea bx, [0x2da8]
  069FC6  1646: 8b56fc           mov dx, word ptr [bp - 4]
  069FC9  1649: 9a54021f18       lcall 0x181f, 0x254
  069FCE  164E: 83be70ff01       cmp word ptr [bp - 0x90], 1
  069FD3  1653: 7521             jne 0x1676
  069FD5  1655: 83be6cff02       cmp word ptr [bp - 0x94], 2
  069FDA  165A: 751a             jne 0x1676
  069FDC  165C: ff367601         push word ptr [0x176]
  069FE0  1660: ff367401         push word ptr [0x174]
  069FE4  1664: ff7682           push word ptr [bp - 0x7e]
  069FE7  1667: b89600           mov ax, 0x96
  069FEA  166A: 8d1ea82d         lea bx, [0x2da8]
  069FEE  166E: 8b56fc           mov dx, word ptr [bp - 4]
  069FF1  1671: 9a54021f18       lcall 0x181f, 0x254
  069FF6  1676: 837efe00         cmp word ptr [bp - 2], 0
  069FFA  167A: 754d             jne 0x16c9
  069FFC  167C: 83be6eff00       cmp word ptr [bp - 0x92], 0
  06A001  1681: 7546             jne 0x16c9
  06A003  1683: 83be7aff00       cmp word ptr [bp - 0x86], 0
  06A008  1688: 753f             jne 0x16c9
  06A00A  168A: 83be70ff00       cmp word ptr [bp - 0x90], 0
  06A00F  168F: 7538             jne 0x16c9
  06A011  1691: 83be6cff01       cmp word ptr [bp - 0x94], 1
  06A016  1696: 7510             jne 0x16a8
  06A018  1698: ff367601         push word ptr [0x176]
  06A01C  169C: ff367401         push word ptr [0x174]
  06A020  16A0: ff7682           push word ptr [bp - 0x7e]
  06A023  16A3: b81700           mov ax, 0x17
  06A026  16A6: eb15             jmp 0x16bd
  06A028  16A8: 83be6cff02       cmp word ptr [bp - 0x94], 2
  06A02D  16AD: 751a             jne 0x16c9
  06A02F  16AF: ff367601         push word ptr [0x176]
  06A033  16B3: ff367401         push word ptr [0x174]
  06A037  16B7: ff7682           push word ptr [bp - 0x7e]
  06A03A  16BA: b81b00           mov ax, 0x1b
  06A03D  16BD: 8d1ea82d         lea bx, [0x2da8]
  06A041  16C1: 8b56fc           mov dx, word ptr [bp - 4]
  06A044  16C4: 9a54021f18       lcall 0x181f, 0x254
  06A049  16C9: 83be6eff00       cmp word ptr [bp - 0x92], 0
  06A04E  16CE: 7573             jne 0x1743
  06A050  16D0: 83be70ff02       cmp word ptr [bp - 0x90], 2
  06A055  16D5: 756c             jne 0x1743
  06A057  16D7: 83be6cff00       cmp word ptr [bp - 0x94], 0
  06A05C  16DC: 752a             jne 0x1708
  06A05E  16DE: ff367601         push word ptr [0x176]
  06A062  16E2: ff367401         push word ptr [0x174]
  06A066  16E6: ff7682           push word ptr [bp - 0x7e]
  06A069  16E9: b85300           mov ax, 0x53
  06A06C  16EC: 8d1ea82d         lea bx, [0x2da8]
  06A070  16F0: 8b56fc           mov dx, word ptr [bp - 4]
  06A073  16F3: 9a54021f18       lcall 0x181f, 0x254
  06A078  16F8: ff367601         push word ptr [0x176]
  06A07C  16FC: ff367401         push word ptr [0x174]
  06A080  1700: ff7682           push word ptr [bp - 0x7e]
  06A083  1703: b85600           mov ax, 0x56
  06A086  1706: eb2f             jmp 0x1737
  06A088  1708: 83be6cff01       cmp word ptr [bp - 0x94], 1
  06A08D  170D: 7534             jne 0x1743
  06A08F  170F: ff367601         push word ptr [0x176]
  06A093  1713: ff367401         push word ptr [0x174]
  06A097  1717: ff7682           push word ptr [bp - 0x7e]
  06A09A  171A: b85200           mov ax, 0x52
  06A09D  171D: 8d1ea82d         lea bx, [0x2da8]
  06A0A1  1721: 8b56fc           mov dx, word ptr [bp - 4]
  06A0A4  1724: 9a54021f18       lcall 0x181f, 0x254
  06A0A9  1729: ff367601         push word ptr [0x176]
  06A0AD  172D: ff367401         push word ptr [0x174]
  06A0B1  1731: ff7682           push word ptr [bp - 0x7e]
  06A0B4  1734: b85500           mov ax, 0x55
  06A0B7  1737: 8d1ea82d         lea bx, [0x2da8]
  06A0BB  173B: 8b56fc           mov dx, word ptr [bp - 4]
  06A0BE  173E: 9a54021f18       lcall 0x181f, 0x254
  06A0C3  1743: 83be70ff01       cmp word ptr [bp - 0x90], 1
  06A0C8  1748: 752c             jne 0x1776
  06A0CA  174A: 83be6cff01       cmp word ptr [bp - 0x94], 1
  06A0CF  174F: 7525             jne 0x1776
  06A0D1  1751: 83be72ffff       cmp word ptr [bp - 0x8e], -1
  06A0D6  1756: 741e             je 0x1776
  06A0D8  1758: ff367601         push word ptr [0x176]
  06A0DC  175C: ff367401         push word ptr [0x174]
  06A0E0  1760: ff7682           push word ptr [bp - 0x7e]
  06A0E3  1763: 8b8672ff         mov ax, word ptr [bp - 0x8e]
  06A0E7  1767: 055a00           add ax, 0x5a
  06A0EA  176A: 8d1ea82d         lea bx, [0x2da8]
  06A0EE  176E: 8b56fc           mov dx, word ptr [bp - 4]
  06A0F1  1771: 9a54021f18       lcall 0x181f, 0x254
  06A0F6  1776: ff8670ff         inc word ptr [bp - 0x90]
  06A0FA  177A: 83be70ff03       cmp word ptr [bp - 0x90], 3
  06A0FF  177F: 7c03             jl 0x1784
  06A101  1781: e93001           jmp 0x18b4
  06A104  1784: ff7682           push word ptr [bp - 0x7e]
  06A107  1787: 8b8670ff         mov ax, word ptr [bp - 0x90]
  06A10B  178B: c1e004           shl ax, 4
  06A10E  178E: 03867cff         add ax, word ptr [bp - 0x84]
  06A112  1792: 40               inc ax
  06A113  1793: 40               inc ax
  06A114  1794: 8946fc           mov word ptr [bp - 4], ax
  06A117  1797: 50               push ax
  06A118  1798: 68a82d           push 0x2da8
  06A11B  179B: ffb662ff         push word ptr [bp - 0x9e]
  06A11F  179F: ff366e01         push word ptr [0x16e]
  06A123  17A3: ff366c01         push word ptr [0x16c]
  06A127  17A7: 9a5e021f18       lcall 0x181f, 0x25e
  06A12C  17AC: 83c40c           add sp, 0xc
  06A12F  17AF: 837e8000         cmp word ptr [bp - 0x80], 0
  06A133  17B3: 7435             je 0x17ea
  06A135  17B5: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  06A13A  17BA: 752e             jne 0x17ea
  06A13C  17BC: ff367601         push word ptr [0x176]
  06A140  17C0: ff367401         push word ptr [0x174]
  06A144  17C4: ff7682           push word ptr [bp - 0x7e]
  06A147  17C7: 8bb66cff         mov si, word ptr [bp - 0x94]
  06A14B  17CB: 8bc6             mov ax, si
  06A14D  17CD: d1e6             shl si, 1
  06A14F  17CF: 03f0             add si, ax
  06A151  17D1: 8b9e70ff         mov bx, word ptr [bp - 0x90]
  06A155  17D5: 8a80e41e         mov al, byte ptr [bx + si + 0x1ee4]
  06A159  17D9: 2ae4             sub ah, ah
  06A15B  17DB: 054100           add ax, 0x41
  06A15E  17DE: 8d1ea82d         lea bx, [0x2da8]
  06A162  17E2: 8b56fc           mov dx, word ptr [bp - 4]
  06A165  17E5: 9a54021f18       lcall 0x181f, 0x254
  06A16A  17EA: 837e061c         cmp word ptr [bp + 6], 0x1c
  06A16E  17EE: 752e             jne 0x181e
  06A170  17F0: ff367601         push word ptr [0x176]
  06A174  17F4: ff367401         push word ptr [0x174]
  06A178  17F8: ff7682           push word ptr [bp - 0x7e]
  06A17B  17FB: 8bb66cff         mov si, word ptr [bp - 0x94]
  06A17F  17FF: 8bc6             mov ax, si
  06A181  1801: d1e6             shl si, 1
  06A183  1803: 03f0             add si, ax
  06A185  1805: 8b9e70ff         mov bx, word ptr [bp - 0x90]
  06A189  1809: 8a80e41e         mov al, byte ptr [bx + si + 0x1ee4]
  06A18D  180D: 2ae4             sub ah, ah
  06A18F  180F: 053100           add ax, 0x31
  06A192  1812: 8d1ea82d         lea bx, [0x2da8]
  06A196  1816: 8b56fc           mov dx, word ptr [bp - 4]
  06A199  1819: 9a54021f18       lcall 0x181f, 0x254
  06A19E  181E: 837e061b         cmp word ptr [bp + 6], 0x1b
  06A1A2  1822: 752e             jne 0x1852
  06A1A4  1824: ff367601         push word ptr [0x176]
  06A1A8  1828: ff367401         push word ptr [0x174]
  06A1AC  182C: ff7682           push word ptr [bp - 0x7e]
  06A1AF  182F: 8bb66cff         mov si, word ptr [bp - 0x94]
  06A1B3  1833: 8bc6             mov ax, si
  06A1B5  1835: d1e6             shl si, 1
  06A1B7  1837: 03f0             add si, ax
  06A1B9  1839: 8b9e70ff         mov bx, word ptr [bp - 0x90]
  06A1BD  183D: 8a80e41e         mov al, byte ptr [bx + si + 0x1ee4]
  06A1C1  1841: 2ae4             sub ah, ah
  06A1C3  1843: 052100           add ax, 0x21
  06A1C6  1846: 8d1ea82d         lea bx, [0x2da8]
  06A1CA  184A: 8b56fc           mov dx, word ptr [bp - 4]
  06A1CD  184D: 9a54021f18       lcall 0x181f, 0x254
  06A1D2  1852: 837efe00         cmp word ptr [bp - 2], 0
  06A1D6  1856: 7403             je 0x185b
  06A1D8  1858: e91bfe           jmp 0x1676
  06A1DB  185B: 83be6eff00       cmp word ptr [bp - 0x92], 0
  06A1E0  1860: 7403             je 0x1865
  06A1E2  1862: e911fe           jmp 0x1676
  06A1E5  1865: 837e8000         cmp word ptr [bp - 0x80], 0
  06A1E9  1869: 7403             je 0x186e
  06A1EB  186B: e908fe           jmp 0x1676
  06A1EE  186E: 83be7aff00       cmp word ptr [bp - 0x86], 0
  06A1F3  1873: 7403             je 0x1878
  06A1F5  1875: e9fefd           jmp 0x1676
  06A1F8  1878: 83be70ff01       cmp word ptr [bp - 0x90], 1
  06A1FD  187D: 7503             jne 0x1882
  06A1FF  187F: e9ccfd           jmp 0x164e
  06A202  1882: 83be6cff01       cmp word ptr [bp - 0x94], 1
  06A207  1887: 7503             jne 0x188c
  06A209  1889: e9c2fd           jmp 0x164e
  06A20C  188C: 837e0601         cmp word ptr [bp + 6], 1
  06A210  1890: 7403             je 0x1895
  06A212  1892: e99ffd           jmp 0x1634
  06A215  1895: ff7682           push word ptr [bp - 0x7e]
  06A218  1898: ff76fc           push word ptr [bp - 4]
  06A21B  189B: 68a82d           push 0x2da8
  06A21E  189E: 6a11             push 0x11
  06A220  18A0: ff366e01         push word ptr [0x16e]
  06A224  18A4: ff366c01         push word ptr [0x16c]
  06A228  18A8: 9a5e021f18       lcall 0x181f, 0x25e
  06A22D  18AD: 83c40c           add sp, 0xc
  06A230  18B0: e99bfd           jmp 0x164e
  06A233  18B3: 90               nop 
  06A234  18B4: ff866cff         inc word ptr [bp - 0x94]
  06A238  18B8: 83be6cff03       cmp word ptr [bp - 0x94], 3
  06A23D  18BD: 7d19             jge 0x18d8
  06A23F  18BF: 8b866cff         mov ax, word ptr [bp - 0x94]
  06A243  18C3: c1e004           shl ax, 4
  06A246  18C6: 038678ff         add ax, word ptr [bp - 0x88]
  06A24A  18CA: 40               inc ax
  06A24B  18CB: 40               inc ax
  06A24C  18CC: 894682           mov word ptr [bp - 0x7e], ax
  06A24F  18CF: c78670ff0000     mov word ptr [bp - 0x90], 0
  06A255  18D5: e9a2fe           jmp 0x177a
  06A258  18D8: 8b8678ff         mov ax, word ptr [bp - 0x88]
  06A25C  18DC: 054000           add ax, 0x40
  06A25F  18DF: 898668ff         mov word ptr [bp - 0x98], ax
  06A263  18E3: 83867cff38       add word ptr [bp - 0x84], 0x38
  06A268  18E8: 8b8678ff         mov ax, word ptr [bp - 0x88]
  06A26C  18EC: 898660ff         mov word ptr [bp - 0xa0], ax
  06A270  18F0: c78664ff0000     mov word ptr [bp - 0x9c], 0
  06A276  18F6: e97802           jmp 0x1b71
  06A279  18F9: 90               nop 
  06A27A  18FA: 83be64ff08       cmp word ptr [bp - 0x9c], 8
  06A27F  18FF: 7d07             jge 0x1908
  06A281  1901: ff36f82d         push word ptr [0x2df8]
  06A285  1905: eb05             jmp 0x190c
  06A287  1907: 90               nop 
  06A288  1908: ff362c2f         push word ptr [0x2f2c]
  06A28C  190C: 8d4684           lea ax, [bp - 0x7c]
  06A28F  190F: 50               push ax
  06A290  1910: 9a6e011f18       lcall 0x181f, 0x16e
  06A295  1915: 83c404           add sp, 4
  06A298  1918: 68d81e           push 0x1ed8
  06A29B  191B: 8d4684           lea ax, [bp - 0x7c]
  06A29E  191E: 50               push ax
  06A29F  191F: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06A2A4  1924: 83c404           add sp, 4
  06A2A7  1927: ff362a2f         push word ptr [0x2f2a]
  06A2AB  192B: 8d4684           lea ax, [bp - 0x7c]
  06A2AE  192E: 50               push ax
  06A2AF  192F: 9a6e011f18       lcall 0x181f, 0x16e
  06A2B4  1934: 83c404           add sp, 4
  06A2B7  1937: 8d4684           lea ax, [bp - 0x7c]
  06A2BA  193A: 50               push ax
  06A2BB  193B: 9abe011f18       lcall 0x181f, 0x1be
  06A2C0  1940: 83c402           add sp, 2
  06A2C3  1943: 8d4684           lea ax, [bp - 0x7c]
  06A2C6  1946: 50               push ax
  06A2C7  1947: 9a46011f18       lcall 0x181f, 0x146
  06A2CC  194C: 83c402           add sp, 2
  06A2CF  194F: 83be64ff05       cmp word ptr [bp - 0x9c], 5
  06A2D4  1954: 7506             jne 0x195c
  06A2D6  1956: b80100           mov ax, 1
  06A2D9  1959: eb03             jmp 0x195e
  06A2DB  195B: 90               nop 
  06A2DC  195C: 2bc0             sub ax, ax
  06A2DE  195E: 898658ff         mov word ptr [bp - 0xa8], ax
  06A2E2  1962: 83be64ff04       cmp word ptr [bp - 0x9c], 4
  06A2E7  1967: 7505             jne 0x196e
  06A2E9  1969: b80100           mov ax, 1
  06A2EC  196C: eb02             jmp 0x1970
  06A2EE  196E: 2bc0             sub ax, ax
  06A2F0  1970: 038658ff         add ax, word ptr [bp - 0xa8]
  06A2F4  1974: 40               inc ax
  06A2F5  1975: 50               push ax
  06A2F6  1976: 8d4684           lea ax, [bp - 0x7c]
  06A2F9  1979: 16               push ss
  06A2FA  197A: 50               push ax
  06A2FB  197B: 9a82011f18       lcall 0x181f, 0x182
  06A300  1980: 83c406           add sp, 6
  06A303  1983: a03008           mov al, byte ptr [0x830]
  06A306  1986: 2ae4             sub ah, ah
  06A308  1988: 50               push ax
  06A309  1989: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  06A30D  198D: 050600           add ax, 6
  06A310  1990: 50               push ax
  06A311  1991: ffb65cff         push word ptr [bp - 0xa4]
  06A315  1995: 8d4e84           lea cx, [bp - 0x7c]
  06A318  1998: 16               push ss
  06A319  1999: 51               push cx
  06A31A  199A: 8bf0             mov si, ax
  06A31C  199C: 9a3c011f18       lcall 0x181f, 0x13c
  06A321  19A1: 83c40a           add sp, 0xa
  06A324  19A4: 89865cff         mov word ptr [bp - 0xa4], ax
  06A328  19A8: ffb664ff         push word ptr [bp - 0x9c]
  06A32C  19AC: ffb672ff         push word ptr [bp - 0x8e]
  06A330  19B0: 9a6a0a1f18       lcall 0x181f, 0xa6a
  06A335  19B5: 83c404           add sp, 4
  06A338  19B8: 898674ff         mov word ptr [bp - 0x8c], ax
  06A33C  19BC: 0bc0             or ax, ax
  06A33E  19BE: 7503             jne 0x19c3
  06A340  19C0: e91b01           jmp 0x1ade
  06A343  19C3: c6468400         mov byte ptr [bp - 0x7c], 0
  06A347  19C7: 6a01             push 1
  06A349  19C9: 8d4684           lea ax, [bp - 0x7c]
  06A34C  19CC: 50               push ax
  06A34D  19CD: 9a96011f18       lcall 0x181f, 0x196
  06A352  19D2: 83c404           add sp, 4
  06A355  19D5: a03008           mov al, byte ptr [0x830]
  06A358  19D8: 2ae4             sub ah, ah
  06A35A  19DA: 50               push ax
  06A35B  19DB: 56               push si
  06A35C  19DC: ffb65cff         push word ptr [bp - 0xa4]
  06A360  19E0: 8d4684           lea ax, [bp - 0x7c]
  06A363  19E3: 16               push ss
  06A364  19E4: 50               push ax
  06A365  19E5: 9a3c011f18       lcall 0x181f, 0x13c
  06A36A  19EA: 83c40a           add sp, 0xa
  06A36D  19ED: 89865cff         mov word ptr [bp - 0xa4], ax
  06A371  19F1: ff367601         push word ptr [0x176]
  06A375  19F5: ff367401         push word ptr [0x174]
  06A379  19F9: ffb660ff         push word ptr [bp - 0xa0]
  06A37D  19FD: 8b8672ff         mov ax, word ptr [bp - 0x8e]
  06A381  1A01: 055a00           add ax, 0x5a
  06A384  1A04: 8d1ea82d         lea bx, [0x2da8]
  06A388  1A08: 8b965cff         mov dx, word ptr [bp - 0xa4]
  06A38C  1A0C: 9a54021f18       lcall 0x181f, 0x254
  06A391  1A11: 83865cff12       add word ptr [bp - 0xa4], 0x12
  06A396  1A16: c6468400         mov byte ptr [bp - 0x7c], 0
  06A39A  1A1A: 83be72ff04       cmp word ptr [bp - 0x8e], 4
  06A39F  1A1F: 7507             jne 0x1a28
  06A3A1  1A21: ff364a2f         push word ptr [0x2f4a]
  06A3A5  1A25: eb0b             jmp 0x1a32
  06A3A7  1A27: 90               nop 
  06A3A8  1A28: 8b9e72ff         mov bx, word ptr [bp - 0x8e]
  06A3AC  1A2C: d1e3             shl bx, 1
  06A3AE  1A2E: ffb70c93         push word ptr [bx - 0x6cf4]
  06A3B2  1A32: 8d4684           lea ax, [bp - 0x7c]
  06A3B5  1A35: 50               push ax
  06A3B6  1A36: 9a6e011f18       lcall 0x181f, 0x16e
  06A3BB  1A3B: 83c404           add sp, 4
  06A3BE  1A3E: 8d4684           lea ax, [bp - 0x7c]
  06A3C1  1A41: 50               push ax
  06A3C2  1A42: 9abe011f18       lcall 0x181f, 0x1be
  06A3C7  1A47: 83c402           add sp, 2
  06A3CA  1A4A: 83be74ff00       cmp word ptr [bp - 0x8c], 0
  06A3CF  1A4F: 7d11             jge 0x1a62
  06A3D1  1A51: 8d4684           lea ax, [bp - 0x7c]
  06A3D4  1A54: 50               push ax
  06A3D5  1A55: 9a64011f18       lcall 0x181f, 0x164
  06A3DA  1A5A: 83c402           add sp, 2
  06A3DD  1A5D: 6a02             push 2
  06A3DF  1A5F: eb4d             jmp 0x1aae
  06A3E1  1A61: 90               nop 
  06A3E2  1A62: 83be64ff05       cmp word ptr [bp - 0x9c], 5
  06A3E7  1A67: 7504             jne 0x1a6d
  06A3E9  1A69: d1a674ff         shl word ptr [bp - 0x8c], 1
  06A3ED  1A6D: 8d4684           lea ax, [bp - 0x7c]
  06A3F0  1A70: 50               push ax
  06A3F1  1A71: 9a46011f18       lcall 0x181f, 0x146
  06A3F6  1A76: 83c402           add sp, 2
  06A3F9  1A79: ffb674ff         push word ptr [bp - 0x8c]
  06A3FD  1A7D: 8d4684           lea ax, [bp - 0x7c]
  06A400  1A80: 16               push ss
  06A401  1A81: 50               push ax
  06A402  1A82: 9a82011f18       lcall 0x181f, 0x182
  06A407  1A87: 83c406           add sp, 6
  06A40A  1A8A: 83be64ff08       cmp word ptr [bp - 0x9c], 8
  06A40F  1A8F: 7407             je 0x1a98
  06A411  1A91: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  06A416  1A96: 7523             jne 0x1abb
  06A418  1A98: 68da1e           push 0x1eda
  06A41B  1A9B: 8d4684           lea ax, [bp - 0x7c]
  06A41E  1A9E: 50               push ax
  06A41F  1A9F: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06A424  1AA4: 83c404           add sp, 4
  06A427  1AA7: 8b8674ff         mov ax, word ptr [bp - 0x8c]
  06A42B  1AAB: d1e0             shl ax, 1
  06A42D  1AAD: 50               push ax
  06A42E  1AAE: 8d4684           lea ax, [bp - 0x7c]
  06A431  1AB1: 16               push ss
  06A432  1AB2: 50               push ax
  06A433  1AB3: 9a82011f18       lcall 0x181f, 0x182
  06A438  1AB8: 83c406           add sp, 6
  06A43B  1ABB: a03108           mov al, byte ptr [0x831]
  06A43E  1ABE: 2ae4             sub ah, ah
  06A440  1AC0: 50               push ax
  06A441  1AC1: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  06A445  1AC5: 050600           add ax, 6
  06A448  1AC8: 50               push ax
  06A449  1AC9: ffb65cff         push word ptr [bp - 0xa4]
  06A44D  1ACD: 8d4684           lea ax, [bp - 0x7c]
  06A450  1AD0: 16               push ss
  06A451  1AD1: 50               push ax
  06A452  1AD2: 9a3c011f18       lcall 0x181f, 0x13c
  06A457  1AD7: 83c40a           add sp, 0xa
  06A45A  1ADA: 89865cff         mov word ptr [bp - 0xa4], ax
  06A45E  1ADE: c6468400         mov byte ptr [bp - 0x7c], 0
  06A462  1AE2: 6a04             push 4
  06A464  1AE4: 8d4684           lea ax, [bp - 0x7c]
  06A467  1AE7: 50               push ax
  06A468  1AE8: 9a96011f18       lcall 0x181f, 0x196
  06A46D  1AED: 83c404           add sp, 4
  06A470  1AF0: ff36c22d         push word ptr [0x2dc2]
  06A474  1AF4: 8d4684           lea ax, [bp - 0x7c]
  06A477  1AF7: 50               push ax
  06A478  1AF8: 9a6e011f18       lcall 0x181f, 0x16e
  06A47D  1AFD: 83c404           add sp, 4
  06A480  1B00: 8d4684           lea ax, [bp - 0x7c]
  06A483  1B03: 50               push ax
  06A484  1B04: 9abe011f18       lcall 0x181f, 0x1be
  06A489  1B09: 83c402           add sp, 2
  06A48C  1B0C: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  06A491  1B11: 7407             je 0x1b1a
  06A493  1B13: 83be64ff08       cmp word ptr [bp - 0x9c], 8
  06A498  1B18: 7510             jne 0x1b2a
  06A49A  1B1A: 8d4684           lea ax, [bp - 0x7c]
  06A49D  1B1D: 50               push ax
  06A49E  1B1E: 9a46011f18       lcall 0x181f, 0x146
  06A4A3  1B23: 83c402           add sp, 2
  06A4A6  1B26: 6a03             push 3
  06A4A8  1B28: eb0e             jmp 0x1b38
  06A4AA  1B2A: 8d4684           lea ax, [bp - 0x7c]
  06A4AD  1B2D: 50               push ax
  06A4AE  1B2E: 9a64011f18       lcall 0x181f, 0x164
  06A4B3  1B33: 83c402           add sp, 2
  06A4B6  1B36: 6a02             push 2
  06A4B8  1B38: 8d4684           lea ax, [bp - 0x7c]
  06A4BB  1B3B: 16               push ss
  06A4BC  1B3C: 50               push ax
  06A4BD  1B3D: 9a82011f18       lcall 0x181f, 0x182
  06A4C2  1B42: 83c406           add sp, 6
  06A4C5  1B45: a03008           mov al, byte ptr [0x830]
  06A4C8  1B48: 2ae4             sub ah, ah
  06A4CA  1B4A: 50               push ax
  06A4CB  1B4B: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  06A4CF  1B4F: 050600           add ax, 6
  06A4D2  1B52: 50               push ax
  06A4D3  1B53: ffb65cff         push word ptr [bp - 0xa4]
  06A4D7  1B57: 8d4684           lea ax, [bp - 0x7c]
  06A4DA  1B5A: 16               push ss
  06A4DB  1B5B: 50               push ax
  06A4DC  1B5C: 9a3c011f18       lcall 0x181f, 0x13c
  06A4E1  1B61: 83c40a           add sp, 0xa
  06A4E4  1B64: 89865cff         mov word ptr [bp - 0xa4], ax
  06A4E8  1B68: 838660ff10       add word ptr [bp - 0xa0], 0x10
  06A4ED  1B6D: ff8664ff         inc word ptr [bp - 0x9c]
  06A4F1  1B71: 83be64ff09       cmp word ptr [bp - 0x9c], 9
  06A4F6  1B76: 7c03             jl 0x1b7b
  06A4F8  1B78: e9e300           jmp 0x1c5e
  06A4FB  1B7B: 8b7606           mov si, word ptr [bp + 6]
  06A4FE  1B7E: c1e604           shl si, 4
  06A501  1B81: 8b9e64ff         mov bx, word ptr [bp - 0x9c]
  06A505  1B85: 80b87b2f00       cmp byte ptr [bx + si + 0x2f7b], 0
  06A50A  1B8A: 74e1             je 0x1b6d
  06A50C  1B8C: ff364008         push word ptr [0x840]
  06A510  1B90: ff363e08         push word ptr [0x83e]
  06A514  1B94: ffb660ff         push word ptr [bp - 0xa0]
  06A518  1B98: 8bc3             mov ax, bx
  06A51A  1B9A: 055200           add ax, 0x52
  06A51D  1B9D: 8d1ea82d         lea bx, [0x2da8]
  06A521  1BA1: 8b967cff         mov dx, word ptr [bp - 0x84]
  06A525  1BA5: 9a54021f18       lcall 0x181f, 0x254
  06A52A  1BAA: 8b867cff         mov ax, word ptr [bp - 0x84]
  06A52E  1BAE: 050c00           add ax, 0xc
  06A531  1BB1: 89865cff         mov word ptr [bp - 0xa4], ax
  06A535  1BB5: c6468400         mov byte ptr [bp - 0x7c], 0
  06A539  1BB9: 8b9e64ff         mov bx, word ptr [bp - 0x9c]
  06A53D  1BBD: c1e303           shl bx, 3
  06A540  1BC0: ffb7a28e         push word ptr [bx - 0x715e]
  06A544  1BC4: 8d4684           lea ax, [bp - 0x7c]
  06A547  1BC7: 50               push ax
  06A548  1BC8: 9a6e011f18       lcall 0x181f, 0x16e
  06A54D  1BCD: 83c404           add sp, 4
  06A550  1BD0: 8d4684           lea ax, [bp - 0x7c]
  06A553  1BD3: 50               push ax
  06A554  1BD4: 9abe011f18       lcall 0x181f, 0x1be
  06A559  1BD9: 83c402           add sp, 2
  06A55C  1BDC: 8b7606           mov si, word ptr [bp + 6]
  06A55F  1BDF: c1e604           shl si, 4
  06A562  1BE2: 8b9e64ff         mov bx, word ptr [bp - 0x9c]
  06A566  1BE6: 8a807b2f         mov al, byte ptr [bx + si + 0x2f7b]
  06A56A  1BEA: 2ae4             sub ah, ah
  06A56C  1BEC: 898676ff         mov word ptr [bp - 0x8a], ax
  06A570  1BF0: 0bdb             or bx, bx
  06A572  1BF2: 7405             je 0x1bf9
  06A574  1BF4: 83fb08           cmp bx, 8
  06A577  1BF7: 7504             jne 0x1bfd
  06A579  1BF9: ff8676ff         inc word ptr [bp - 0x8a]
  06A57D  1BFD: 83fb05           cmp bx, 5
  06A580  1C00: 7504             jne 0x1c06
  06A582  1C02: d1a676ff         shl word ptr [bp - 0x8a], 1
  06A586  1C06: ffb676ff         push word ptr [bp - 0x8a]
  06A58A  1C0A: 8d4684           lea ax, [bp - 0x7c]
  06A58D  1C0D: 16               push ss
  06A58E  1C0E: 50               push ax
  06A58F  1C0F: 9a82011f18       lcall 0x181f, 0x182
  06A594  1C14: 83c406           add sp, 6
  06A597  1C17: a03108           mov al, byte ptr [0x831]
  06A59A  1C1A: 2ae4             sub ah, ah
  06A59C  1C1C: 50               push ax
  06A59D  1C1D: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  06A5A1  1C21: 050600           add ax, 6
  06A5A4  1C24: 50               push ax
  06A5A5  1C25: ffb65cff         push word ptr [bp - 0xa4]
  06A5A9  1C29: 8d4684           lea ax, [bp - 0x7c]
  06A5AC  1C2C: 16               push ss
  06A5AD  1C2D: 50               push ax
  06A5AE  1C2E: 9a3c011f18       lcall 0x181f, 0x13c
  06A5B3  1C33: 83c40a           add sp, 0xa
  06A5B6  1C36: 89865cff         mov word ptr [bp - 0xa4], ax
  06A5BA  1C3A: c6468400         mov byte ptr [bp - 0x7c], 0
  06A5BE  1C3E: 6a04             push 4
  06A5C0  1C40: 8d4684           lea ax, [bp - 0x7c]
  06A5C3  1C43: 50               push ax
  06A5C4  1C44: 9a96011f18       lcall 0x181f, 0x196
  06A5C9  1C49: 83c404           add sp, 4
  06A5CC  1C4C: 83be64ff03       cmp word ptr [bp - 0x9c], 3
  06A5D1  1C51: 7e03             jle 0x1c56
  06A5D3  1C53: e9a4fc           jmp 0x18fa
  06A5D6  1C56: ff36282f         push word ptr [0x2f28]
  06A5DA  1C5A: e9affc           jmp 0x190c
  06A5DD  1C5D: 90               nop 
  06A5DE  1C5E: c6468400         mov byte ptr [bp - 0x7c], 0
  06A5E2  1C62: ff362e2f         push word ptr [0x2f2e]
  06A5E6  1C66: 8d4684           lea ax, [bp - 0x7c]
  06A5E9  1C69: 50               push ax
  06A5EA  1C6A: 9a6e011f18       lcall 0x181f, 0x16e
  06A5EF  1C6F: 83c404           add sp, 4
  06A5F2  1C72: 8d4684           lea ax, [bp - 0x7c]
  06A5F5  1C75: 50               push ax
  06A5F6  1C76: 9abe011f18       lcall 0x181f, 0x1be
  06A5FB  1C7B: 83c402           add sp, 2
  06A5FE  1C7E: 8b5e06           mov bx, word ptr [bp + 6]
  06A601  1C81: c1e304           shl bx, 4
  06A604  1C84: 8a87762f         mov al, byte ptr [bx + 0x2f76]
  06A608  1C88: 2ae4             sub ah, ah
  06A60A  1C8A: 50               push ax
  06A60B  1C8B: 8d4684           lea ax, [bp - 0x7c]
  06A60E  1C8E: 16               push ss
  06A60F  1C8F: 50               push ax
  06A610  1C90: 8bf3             mov si, bx
  06A612  1C92: 9a82011f18       lcall 0x181f, 0x182
  06A617  1C97: 83c406           add sp, 6
  06A61A  1C9A: 6a04             push 4
  06A61C  1C9C: 8d4684           lea ax, [bp - 0x7c]
  06A61F  1C9F: 50               push ax
  06A620  1CA0: 9a96011f18       lcall 0x181f, 0x196
  06A625  1CA5: 83c404           add sp, 4
  06A628  1CA8: ff36302f         push word ptr [0x2f30]
  06A62C  1CAC: 8d4684           lea ax, [bp - 0x7c]
  06A62F  1CAF: 50               push ax
  06A630  1CB0: 9a6e011f18       lcall 0x181f, 0x16e
  06A635  1CB5: 83c404           add sp, 4
  06A638  1CB8: 8d4684           lea ax, [bp - 0x7c]
  06A63B  1CBB: 50               push ax
  06A63C  1CBC: 9abe011f18       lcall 0x181f, 0x1be
  06A641  1CC1: 83c402           add sp, 2
  06A644  1CC4: 8d4684           lea ax, [bp - 0x7c]
  06A647  1CC7: 50               push ax
  06A648  1CC8: 9a46011f18       lcall 0x181f, 0x146
  06A64D  1CCD: 83c402           add sp, 2
  06A650  1CD0: b019             mov al, 0x19
  06A652  1CD2: f6a4772f         mul byte ptr [si + 0x2f77]
  06A656  1CD6: 50               push ax
  06A657  1CD7: 8d4684           lea ax, [bp - 0x7c]
  06A65A  1CDA: 16               push ss
  06A65B  1CDB: 50               push ax
  06A65C  1CDC: 9a82011f18       lcall 0x181f, 0x182
  06A661  1CE1: 83c406           add sp, 6
  06A664  1CE4: 8d4684           lea ax, [bp - 0x7c]
  06A667  1CE7: 50               push ax
  06A668  1CE8: 9a0a011f18       lcall 0x181f, 0x10a
  06A66D  1CED: 83c402           add sp, 2
  06A670  1CF0: a03008           mov al, byte ptr [0x830]
  06A673  1CF3: 2ae4             sub ah, ah
  06A675  1CF5: 50               push ax
  06A676  1CF6: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  06A67A  1CFA: 050600           add ax, 6
  06A67D  1CFD: 50               push ax
  06A67E  1CFE: ffb67cff         push word ptr [bp - 0x84]
  06A682  1D02: 8d4684           lea ax, [bp - 0x7c]
  06A685  1D05: 16               push ss
  06A686  1D06: 50               push ax
  06A687  1D07: 9a3c011f18       lcall 0x181f, 0x13c
  06A68C  1D0C: 83c40a           add sp, 0xa
  06A68F  1D0F: 838660ff17       add word ptr [bp - 0xa0], 0x17
  06A694  1D14: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  06A698  1D18: 3b8668ff         cmp ax, word ptr [bp - 0x98]
  06A69C  1D1C: 7d04             jge 0x1d22
  06A69E  1D1E: 8b8668ff         mov ax, word ptr [bp - 0x98]
  06A6A2  1D22: 898678ff         mov word ptr [bp - 0x88], ax
  06A6A6  1D26: 68dc1e           push 0x1edc
  06A6A9  1D29: 8d4e84           lea cx, [bp - 0x7c]
  06A6AC  1D2C: 51               push cx
  06A6AD  1D2D: 8bf0             mov si, ax
  06A6AF  1D2F: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06A6B4  1D34: 83c404           add sp, 4
  06A6B7  1D37: ff7606           push word ptr [bp + 6]
  06A6BA  1D3A: 8d4684           lea ax, [bp - 0x7c]
  06A6BD  1D3D: 16               push ss
  06A6BE  1D3E: 50               push ax
  06A6BF  1D3F: 9a82011f18       lcall 0x181f, 0x182
  06A6C4  1D44: 83c406           add sp, 6
  06A6C7  1D47: 89365a1f         mov word ptr [0x1f5a], si
  06A6CB  1D4B: 8d46d4           lea ax, [bp - 0x2c]
  06A6CE  1D4E: 16               push ss
  06A6CF  1D4F: 50               push ax
  06A6D0  1D50: 6a00             push 0
  06A6D2  1D52: 9a16041f18       lcall 0x181f, 0x416
  06A6D7  1D57: 83c406           add sp, 6
  06A6DA  1D5A: 8d4684           lea ax, [bp - 0x7c]
  06A6DD  1D5D: 50               push ax
  06A6DE  1D5E: 0e               push cs
  06A6DF  1D5F: e8ab0f           call 0x2d0d
  06A6E2  1D62: 83c402           add sp, 2
  06A6E5  1D65: 6a00             push 0
  06A6E7  1D67: 684001           push 0x140
  06A6EA  1D6A: 68c800           push 0xc8
  06A6ED  1D6D: 2bc0             sub ax, ax
  06A6EF  1D6F: 99               cdq 
  06A6F0  1D70: 2bdb             sub bx, bx
  06A6F2  1D72: 9ae2001f18       lcall 0x181f, 0xe2
  06A6F7  1D77: 9ac0031f18       lcall 0x181f, 0x3c0
  06A6FC  1D7C: 5e               pop si
  06A6FD  1D7D: 5f               pop di
  06A6FE  1D7E: c9               leave 
  06A6FF  1D7F: cb               retf 

; ---- func_06A700  size=904  insns=315  prologue=ENTER 0x006A,0  terminal=RETF ----
  06A700  1D80: c86a0000         enter 0x6a, 0
  06A704  1D84: 56               push si
  06A705  1D85: 0e               push cs
  06A706  1D86: e8890f           call 0x2d12
  06A709  1D89: a03108           mov al, byte ptr [0x831]
  06A70C  1D8C: 2ae4             sub ah, ah
  06A70E  1D8E: 50               push ax
  06A70F  1D8F: 6a05             push 5
  06A711  1D91: 684001           push 0x140
  06A714  1D94: 2bc0             sub ax, ax
  06A716  1D96: 89469a           mov word ptr [bp - 0x66], ax
  06A719  1D99: 50               push ax
  06A71A  1D9A: ff36922e         push word ptr [0x2e92]
  06A71E  1D9E: 9a22001f18       lcall 0x181f, 0x22
  06A723  1DA3: 83c402           add sp, 2
  06A726  1DA6: 52               push dx
  06A727  1DA7: 50               push ax
  06A728  1DA8: 9a00011f18       lcall 0x181f, 0x100
  06A72D  1DAD: 83c40c           add sp, 0xc
  06A730  1DB0: c41e9e08         les bx, ptr [0x89e]
  06A734  1DB4: 268a07           mov al, byte ptr es:[bx]
  06A737  1DB7: 2ae4             sub ah, ah
  06A739  1DB9: 050700           add ax, 7
  06A73C  1DBC: 8946a6           mov word ptr [bp - 0x5a], ax
  06A73F  1DBF: c646ac00         mov byte ptr [bp - 0x54], 0
  06A743  1DC3: 8d46ac           lea ax, [bp - 0x54]
  06A746  1DC6: 50               push ax
  06A747  1DC7: 9a1e011f18       lcall 0x181f, 0x11e
  06A74C  1DCC: 83c402           add sp, 2
  06A74F  1DCF: 8b5e06           mov bx, word ptr [bp + 6]
  06A752  1DD2: c1e303           shl bx, 3
  06A755  1DD5: ffb7a28e         push word ptr [bx - 0x715e]
  06A759  1DD9: 8d46ac           lea ax, [bp - 0x54]
  06A75C  1DDC: 50               push ax
  06A75D  1DDD: 9a6e011f18       lcall 0x181f, 0x16e
  06A762  1DE2: 83c404           add sp, 4
  06A765  1DE5: 8d46ac           lea ax, [bp - 0x54]
  06A768  1DE8: 50               push ax
  06A769  1DE9: 9abe011f18       lcall 0x181f, 0x1be
  06A76E  1DEE: 83c402           add sp, 2
  06A771  1DF1: 6a03             push 3
  06A773  1DF3: 8d46ac           lea ax, [bp - 0x54]
  06A776  1DF6: 50               push ax
  06A777  1DF7: 0e               push cs
  06A778  1DF8: e8030f           call 0x2cfe
  06A77B  1DFB: 83c404           add sp, 4
  06A77E  1DFE: 8d46ac           lea ax, [bp - 0x54]
  06A781  1E01: 50               push ax
  06A782  1E02: 9a28011f18       lcall 0x181f, 0x128
  06A787  1E07: 83c402           add sp, 2
  06A78A  1E0A: a03108           mov al, byte ptr [0x831]
  06A78D  1E0D: 2ae4             sub ah, ah
  06A78F  1E0F: 50               push ax
  06A790  1E10: ff76a6           push word ptr [bp - 0x5a]
  06A793  1E13: 684001           push 0x140
  06A796  1E16: 6a00             push 0
  06A798  1E18: 8d46ac           lea ax, [bp - 0x54]
  06A79B  1E1B: 16               push ss
  06A79C  1E1C: 50               push ax
  06A79D  1E1D: 9a00011f18       lcall 0x181f, 0x100
  06A7A2  1E22: 83c40c           add sp, 0xc
  06A7A5  1E25: c41e9e08         les bx, ptr [0x89e]
  06A7A9  1E29: 268a07           mov al, byte ptr es:[bx]
  06A7AC  1E2C: 2ae4             sub ah, ah
  06A7AE  1E2E: 40               inc ax
  06A7AF  1E2F: 40               inc ax
  06A7B0  1E30: 0146a6           add word ptr [bp - 0x5a], ax
  06A7B3  1E33: ff46a6           inc word ptr [bp - 0x5a]
  06A7B6  1E36: c746a80a00       mov word ptr [bp - 0x58], 0xa
  06A7BB  1E3B: ff7606           push word ptr [bp + 6]
  06A7BE  1E3E: 9a000b1f18       lcall 0x181f, 0xb00
  06A7C3  1E43: 83c402           add sp, 2
  06A7C6  1E46: 8946fe           mov word ptr [bp - 2], ax
  06A7C9  1E49: 0bc0             or ax, ax
  06A7CB  1E4B: 7d04             jge 0x1e51
  06A7CD  1E4D: 8346a60b         add word ptr [bp - 0x5a], 0xb
  06A7D1  1E51: 8b46a8           mov ax, word ptr [bp - 0x58]
  06A7D4  1E54: 894698           mov word ptr [bp - 0x68], ax
  06A7D7  1E57: 2bc0             sub ax, ax
  06A7D9  1E59: 894696           mov word ptr [bp - 0x6a], ax
  06A7DC  1E5C: 8946a4           mov word ptr [bp - 0x5c], ax
  06A7DF  1E5F: 3946fe           cmp word ptr [bp - 2], ax
  06A7E2  1E62: 7c24             jl 0x1e88
  06A7E4  1E64: c746a40100       mov word ptr [bp - 0x5c], 1
  06A7E9  1E69: 8b76fe           mov si, word ptr [bp - 2]
  06A7EC  1E6C: 8bc6             mov ax, si
  06A7EE  1E6E: d1e6             shl si, 1
  06A7F0  1E70: 03f0             add si, ax
  06A7F2  1E72: c1e602           shl si, 2
  06A7F5  1E75: c41e4208         les bx, ptr [0x842]
  06A7F9  1E79: 268b404c         mov ax, word ptr es:[bx + si + 0x4c]
  06A7FD  1E7D: 89469a           mov word ptr [bp - 0x66], ax
  06A800  1E80: d1f8             sar ax, 1
  06A802  1E82: 2d0700           sub ax, 7
  06A805  1E85: 894696           mov word ptr [bp - 0x6a], ax
  06A808  1E88: 8b4606           mov ax, word ptr [bp + 6]
  06A80B  1E8B: 055200           add ax, 0x52
  06A80E  1E8E: 8946a0           mov word ptr [bp - 0x60], ax
  06A811  1E91: 837e061b         cmp word ptr [bp + 6], 0x1b
  06A815  1E95: 7505             jne 0x1e9c
  06A817  1E97: c746a04300       mov word ptr [bp - 0x60], 0x43
  06A81C  1E9C: ff364008         push word ptr [0x840]
  06A820  1EA0: ff363e08         push word ptr [0x83e]
  06A824  1EA4: 8b4696           mov ax, word ptr [bp - 0x6a]
  06A827  1EA7: 0346a6           add ax, word ptr [bp - 0x5a]
  06A82A  1EAA: 50               push ax
  06A82B  1EAB: 8bf0             mov si, ax
  06A82D  1EAD: 8b46a0           mov ax, word ptr [bp - 0x60]
  06A830  1EB0: 8d1ea82d         lea bx, [0x2da8]
  06A834  1EB4: 8b5698           mov dx, word ptr [bp - 0x68]
  06A837  1EB7: 9a54021f18       lcall 0x181f, 0x254
  06A83C  1EBC: c646ac00         mov byte ptr [bp - 0x54], 0
  06A840  1EC0: 8b5e06           mov bx, word ptr [bp + 6]
  06A843  1EC3: c1e303           shl bx, 3
  06A846  1EC6: ffb7a48e         push word ptr [bx - 0x715c]
  06A84A  1ECA: 8d46ac           lea ax, [bp - 0x54]
  06A84D  1ECD: 50               push ax
  06A84E  1ECE: 9a6e011f18       lcall 0x181f, 0x16e
  06A853  1ED3: 83c404           add sp, 4
  06A856  1ED6: a03108           mov al, byte ptr [0x831]
  06A859  1ED9: 2ae4             sub ah, ah
  06A85B  1EDB: 50               push ax
  06A85C  1EDC: 8d4406           lea ax, [si + 6]
  06A85F  1EDF: 50               push ax
  06A860  1EE0: 8346980e         add word ptr [bp - 0x68], 0xe
  06A864  1EE4: ff7698           push word ptr [bp - 0x68]
  06A867  1EE7: 8d46ac           lea ax, [bp - 0x54]
  06A86A  1EEA: 16               push ss
  06A86B  1EEB: 50               push ax
  06A86C  1EEC: 9a3c011f18       lcall 0x181f, 0x13c
  06A871  1EF1: 83c40a           add sp, 0xa
  06A874  1EF4: 894698           mov word ptr [bp - 0x68], ax
  06A877  1EF7: 83469818         add word ptr [bp - 0x68], 0x18
  06A87B  1EFB: 8b4698           mov ax, word ptr [bp - 0x68]
  06A87E  1EFE: 8946a2           mov word ptr [bp - 0x5e], ax
  06A881  1F01: 8b4ea6           mov cx, word ptr [bp - 0x5a]
  06A884  1F04: 894e9e           mov word ptr [bp - 0x62], cx
  06A887  1F07: 8946fc           mov word ptr [bp - 4], ax
  06A88A  1F0A: 837efe00         cmp word ptr [bp - 2], 0
  06A88E  1F0E: 7d03             jge 0x1f13
  06A890  1F10: e9ae00           jmp 0x1fc1
  06A893  1F13: c746fcffff       mov word ptr [bp - 4], 0xffff
  06A898  1F18: e9a600           jmp 0x1fc1
  06A89B  1F1B: 90               nop 
  06A89C  1F1C: 8b76fe           mov si, word ptr [bp - 2]
  06A89F  1F1F: 8bc6             mov ax, si
  06A8A1  1F21: d1e6             shl si, 1
  06A8A3  1F23: 03f0             add si, ax
  06A8A5  1F25: c1e602           shl si, 2
  06A8A8  1F28: c41e4208         les bx, ptr [0x842]
  06A8AC  1F2C: 268b404c         mov ax, word ptr es:[bx + si + 0x4c]
  06A8B0  1F30: 89469a           mov word ptr [bp - 0x66], ax
  06A8B3  1F33: d1f8             sar ax, 1
  06A8B5  1F35: 2d0700           sub ax, 7
  06A8B8  1F38: 894696           mov word ptr [bp - 0x6a], ax
  06A8BB  1F3B: 06               push es
  06A8BC  1F3C: 53               push bx
  06A8BD  1F3D: ff76a6           push word ptr [bp - 0x5a]
  06A8C0  1F40: 8b46fe           mov ax, word ptr [bp - 2]
  06A8C3  1F43: 40               inc ax
  06A8C4  1F44: 8d1ea82d         lea bx, [0x2da8]
  06A8C8  1F48: 8b56a2           mov dx, word ptr [bp - 0x5e]
  06A8CB  1F4B: 9a54021f18       lcall 0x181f, 0x254
  06A8D0  1F50: c41e4208         les bx, ptr [0x842]
  06A8D4  1F54: 268b404a         mov ax, word ptr es:[bx + si + 0x4a]
  06A8D8  1F58: 0346a2           add ax, word ptr [bp - 0x5e]
  06A8DB  1F5B: 050300           add ax, 3
  06A8DE  1F5E: 894698           mov word ptr [bp - 0x68], ax
  06A8E1  1F61: c646ac00         mov byte ptr [bp - 0x54], 0
  06A8E5  1F65: ffb4828f         push word ptr [si - 0x707e]
  06A8E9  1F69: 8d46ac           lea ax, [bp - 0x54]
  06A8EC  1F6C: 50               push ax
  06A8ED  1F6D: 9a6e011f18       lcall 0x181f, 0x16e
  06A8F2  1F72: 83c404           add sp, 4
  06A8F5  1F75: a03108           mov al, byte ptr [0x831]
  06A8F8  1F78: 2ae4             sub ah, ah
  06A8FA  1F7A: 50               push ax
  06A8FB  1F7B: 8b4696           mov ax, word ptr [bp - 0x6a]
  06A8FE  1F7E: 0346a6           add ax, word ptr [bp - 0x5a]
  06A901  1F81: 050600           add ax, 6
  06A904  1F84: 50               push ax
  06A905  1F85: ff7698           push word ptr [bp - 0x68]
  06A908  1F88: 8d46ac           lea ax, [bp - 0x54]
  06A90B  1F8B: 16               push ss
  06A90C  1F8C: 50               push ax
  06A90D  1F8D: 9a3c011f18       lcall 0x181f, 0x13c
  06A912  1F92: 83c40a           add sp, 0xa
  06A915  1F95: 894698           mov word ptr [bp - 0x68], ax
  06A918  1F98: 837efc00         cmp word ptr [bp - 4], 0
  06A91C  1F9C: 7d06             jge 0x1fa4
  06A91E  1F9E: 051800           add ax, 0x18
  06A921  1FA1: 8946fc           mov word ptr [bp - 4], ax
  06A924  1FA4: 8b469a           mov ax, word ptr [bp - 0x66]
  06A927  1FA7: 050400           add ax, 4
  06A92A  1FAA: 0146a6           add word ptr [bp - 0x5a], ax
  06A92D  1FAD: 8b5efe           mov bx, word ptr [bp - 2]
  06A930  1FB0: 8bc3             mov ax, bx
  06A932  1FB2: d1e3             shl bx, 1
  06A934  1FB4: 03d8             add bx, ax
  06A936  1FB6: c1e302           shl bx, 2
  06A939  1FB9: 8a87868f         mov al, byte ptr [bx - 0x707a]
  06A93D  1FBD: 98               cwde 
  06A93E  1FBE: 8946fe           mov word ptr [bp - 2], ax
  06A941  1FC1: 837efe00         cmp word ptr [bp - 2], 0
  06A945  1FC5: 7c03             jl 0x1fca
  06A947  1FC7: e952ff           jmp 0x1f1c
  06A94A  1FCA: 837e0613         cmp word ptr [bp + 6], 0x13
  06A94E  1FCE: 7c03             jl 0x1fd3
  06A950  1FD0: e9c600           jmp 0x2099
  06A953  1FD3: 8b4606           mov ax, word ptr [bp + 6]
  06A956  1FD6: 051700           add ax, 0x17
  06A959  1FD9: 8946a0           mov word ptr [bp - 0x60], ax
  06A95C  1FDC: 837e0608         cmp word ptr [bp + 6], 8
  06A960  1FE0: 7505             jne 0x1fe7
  06A962  1FE2: c746a03a00       mov word ptr [bp - 0x60], 0x3a
  06A967  1FE7: 837e060d         cmp word ptr [bp + 6], 0xd
  06A96B  1FEB: 7505             jne 0x1ff2
  06A96D  1FED: c746a03700       mov word ptr [bp - 0x60], 0x37
  06A972  1FF2: 837e0610         cmp word ptr [bp + 6], 0x10
  06A976  1FF6: 7505             jne 0x1ffd
  06A978  1FF8: c746a03900       mov word ptr [bp - 0x60], 0x39
  06A97D  1FFD: 837e0611         cmp word ptr [bp + 6], 0x11
  06A981  2001: 7505             jne 0x2008
  06A983  2003: c746a03f00       mov word ptr [bp - 0x60], 0x3f
  06A988  2008: ff364008         push word ptr [0x840]
  06A98C  200C: ff363e08         push word ptr [0x83e]
  06A990  2010: 8b4696           mov ax, word ptr [bp - 0x6a]
  06A993  2013: 03469e           add ax, word ptr [bp - 0x62]
  06A996  2016: 40               inc ax
  06A997  2017: 40               inc ax
  06A998  2018: 50               push ax
  06A999  2019: 8b46a0           mov ax, word ptr [bp - 0x60]
  06A99C  201C: 8d1ea82d         lea bx, [0x2da8]
  06A9A0  2020: 8b56fc           mov dx, word ptr [bp - 4]
  06A9A3  2023: 9a54021f18       lcall 0x181f, 0x254
  06A9A8  2028: 8346fc10         add word ptr [bp - 4], 0x10
  06A9AC  202C: c646ac00         mov byte ptr [bp - 0x54], 0
  06A9B0  2030: 8b4606           mov ax, word ptr [bp + 6]
  06A9B3  2033: 8946a0           mov word ptr [bp - 0x60], ax
  06A9B6  2036: 3d0d00           cmp ax, 0xd
  06A9B9  2039: 7505             jne 0x2040
  06A9BB  203B: c746a01000       mov word ptr [bp - 0x60], 0x10
  06A9C0  2040: 3d1000           cmp ax, 0x10
  06A9C3  2043: 7505             jne 0x204a
  06A9C5  2045: c746a01100       mov word ptr [bp - 0x60], 0x11
  06A9CA  204A: 3d1100           cmp ax, 0x11
  06A9CD  204D: 7505             jne 0x2054
  06A9CF  204F: c746a01200       mov word ptr [bp - 0x60], 0x12
  06A9D4  2054: 8b5ea0           mov bx, word ptr [bp - 0x60]
  06A9D7  2057: d1e3             shl bx, 1
  06A9D9  2059: 8b87c097         mov ax, word ptr [bx - 0x6840]
  06A9DD  205D: 8946a0           mov word ptr [bp - 0x60], ax
  06A9E0  2060: 837e0608         cmp word ptr [bp + 6], 8
  06A9E4  2064: 7506             jne 0x206c
  06A9E6  2066: a11c2f           mov ax, word ptr [0x2f1c]
  06A9E9  2069: 8946a0           mov word ptr [bp - 0x60], ax
  06A9EC  206C: 50               push ax
  06A9ED  206D: 8d46ac           lea ax, [bp - 0x54]
  06A9F0  2070: 50               push ax
  06A9F1  2071: 9a6e011f18       lcall 0x181f, 0x16e
  06A9F6  2076: 83c404           add sp, 4
  06A9F9  2079: a03108           mov al, byte ptr [0x831]
  06A9FC  207C: 2ae4             sub ah, ah
  06A9FE  207E: 50               push ax
  06A9FF  207F: 8b4696           mov ax, word ptr [bp - 0x6a]
  06AA02  2082: 03469e           add ax, word ptr [bp - 0x62]
  06AA05  2085: 050600           add ax, 6
  06AA08  2088: 50               push ax
  06AA09  2089: ff76fc           push word ptr [bp - 4]
  06AA0C  208C: 8d46ac           lea ax, [bp - 0x54]
  06AA0F  208F: 16               push ss
  06AA10  2090: 50               push ax
  06AA11  2091: 9a3c011f18       lcall 0x181f, 0x13c
  06AA16  2096: 83c40a           add sp, 0xa
  06AA19  2099: 837ea400         cmp word ptr [bp - 0x5c], 0
  06AA1D  209D: 7407             je 0x20a6
  06AA1F  209F: 8346a604         add word ptr [bp - 0x5a], 4
  06AA23  20A3: eb05             jmp 0x20aa
  06AA25  20A5: 90               nop 
  06AA26  20A6: 8346a614         add word ptr [bp - 0x5a], 0x14
  06AA2A  20AA: 68ed1e           push 0x1eed
  06AA2D  20AD: 8d46ac           lea ax, [bp - 0x54]
  06AA30  20B0: 50               push ax
  06AA31  20B1: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06AA36  20B6: 83c404           add sp, 4
  06AA39  20B9: ff7606           push word ptr [bp + 6]
  06AA3C  20BC: 8d46ac           lea ax, [bp - 0x54]
  06AA3F  20BF: 16               push ss
  06AA40  20C0: 50               push ax
  06AA41  20C1: 9a82011f18       lcall 0x181f, 0x182
  06AA46  20C6: 83c406           add sp, 6
  06AA49  20C9: 8b46a6           mov ax, word ptr [bp - 0x5a]
  06AA4C  20CC: a35a1f           mov word ptr [0x1f5a], ax
  06AA4F  20CF: 8b5e06           mov bx, word ptr [bp + 6]
  06AA52  20D2: c1e303           shl bx, 3
  06AA55  20D5: ffb7a28e         push word ptr [bx - 0x715e]
  06AA59  20D9: 6a00             push 0
  06AA5B  20DB: 9a38041f18       lcall 0x181f, 0x438
  06AA60  20E0: 83c404           add sp, 4
  06AA63  20E3: 8d46ac           lea ax, [bp - 0x54]
  06AA66  20E6: 50               push ax
  06AA67  20E7: 0e               push cs
  06AA68  20E8: e8220c           call 0x2d0d
  06AA6B  20EB: 83c402           add sp, 2
  06AA6E  20EE: 6a00             push 0
  06AA70  20F0: 684001           push 0x140
  06AA73  20F3: 68c800           push 0xc8
  06AA76  20F6: 2bc0             sub ax, ax
  06AA78  20F8: 99               cdq 
  06AA79  20F9: 2bdb             sub bx, bx
  06AA7B  20FB: 9ae2001f18       lcall 0x181f, 0xe2
  06AA80  2100: 9ac0031f18       lcall 0x181f, 0x3c0
  06AA85  2105: 5e               pop si
  06AA86  2106: c9               leave 
  06AA87  2107: cb               retf 

; ---- func_06AA88  size=895  insns=312  prologue=ENTER 0x006C,0  terminal=RETF ----
  06AA88  2108: c86c0000         enter 0x6c, 0
  06AA8C  210C: 56               push si
  06AA8D  210D: 0e               push cs
  06AA8E  210E: e8010c           call 0x2d12
  06AA91  2111: a03108           mov al, byte ptr [0x831]
  06AA94  2114: 2ae4             sub ah, ah
  06AA96  2116: 50               push ax
  06AA97  2117: 6a05             push 5
  06AA99  2119: 684001           push 0x140
  06AA9C  211C: 6a00             push 0
  06AA9E  211E: ff36922e         push word ptr [0x2e92]
  06AAA2  2122: 9a22001f18       lcall 0x181f, 0x22
  06AAA7  2127: 83c402           add sp, 2
  06AAAA  212A: 52               push dx
  06AAAB  212B: 50               push ax
  06AAAC  212C: 9a00011f18       lcall 0x181f, 0x100
  06AAB1  2131: 83c40c           add sp, 0xc
  06AAB4  2134: c41e9e08         les bx, ptr [0x89e]
  06AAB8  2138: 268a07           mov al, byte ptr es:[bx]
  06AABB  213B: 2ae4             sub ah, ah
  06AABD  213D: 050700           add ax, 7
  06AAC0  2140: 8946a6           mov word ptr [bp - 0x5a], ax
  06AAC3  2143: c646ac00         mov byte ptr [bp - 0x54], 0
  06AAC7  2147: 8d46ac           lea ax, [bp - 0x54]
  06AACA  214A: 50               push ax
  06AACB  214B: 9a1e011f18       lcall 0x181f, 0x11e
  06AAD0  2150: 83c402           add sp, 2
  06AAD3  2153: 8b5e06           mov bx, word ptr [bp + 6]
  06AAD6  2156: 8bc3             mov ax, bx
  06AAD8  2158: d1e3             shl bx, 1
  06AADA  215A: 03d8             add bx, ax
  06AADC  215C: c1e302           shl bx, 2
  06AADF  215F: ffb7828f         push word ptr [bx - 0x707e]
  06AAE3  2163: 8d46ac           lea ax, [bp - 0x54]
  06AAE6  2166: 50               push ax
  06AAE7  2167: 9a6e011f18       lcall 0x181f, 0x16e
  06AAEC  216C: 83c404           add sp, 4
  06AAEF  216F: 8d46ac           lea ax, [bp - 0x54]
  06AAF2  2172: 50               push ax
  06AAF3  2173: 9abe011f18       lcall 0x181f, 0x1be
  06AAF8  2178: 83c402           add sp, 2
  06AAFB  217B: 6a04             push 4
  06AAFD  217D: 8d46ac           lea ax, [bp - 0x54]
  06AB00  2180: 50               push ax
  06AB01  2181: 0e               push cs
  06AB02  2182: e8790b           call 0x2cfe
  06AB05  2185: 83c404           add sp, 4
  06AB08  2188: 8d46ac           lea ax, [bp - 0x54]
  06AB0B  218B: 50               push ax
  06AB0C  218C: 9a28011f18       lcall 0x181f, 0x128
  06AB11  2191: 83c402           add sp, 2
  06AB14  2194: a03108           mov al, byte ptr [0x831]
  06AB17  2197: 2ae4             sub ah, ah
  06AB19  2199: 50               push ax
  06AB1A  219A: ff76a6           push word ptr [bp - 0x5a]
  06AB1D  219D: 684001           push 0x140
  06AB20  21A0: 6a00             push 0
  06AB22  21A2: 8d46ac           lea ax, [bp - 0x54]
  06AB25  21A5: 16               push ss
  06AB26  21A6: 50               push ax
  06AB27  21A7: 9a00011f18       lcall 0x181f, 0x100
  06AB2C  21AC: 83c40c           add sp, 0xc
  06AB2F  21AF: c41e9e08         les bx, ptr [0x89e]
  06AB33  21B3: 268a07           mov al, byte ptr es:[bx]
  06AB36  21B6: 2ae4             sub ah, ah
  06AB38  21B8: 050e00           add ax, 0xe
  06AB3B  21BB: 0146a6           add word ptr [bp - 0x5a], ax
  06AB3E  21BE: c746a80a00       mov word ptr [bp - 0x58], 0xa
  06AB43  21C3: 837e0610         cmp word ptr [bp + 6], 0x10
  06AB47  21C7: 7406             je 0x21cf
  06AB49  21C9: 837e061f         cmp word ptr [bp + 6], 0x1f
  06AB4D  21CD: 750d             jne 0x21dc
  06AB4F  21CF: c746961800       mov word ptr [bp - 0x6a], 0x18
  06AB54  21D4: 2bc0             sub ax, ax
  06AB56  21D6: 89469c           mov word ptr [bp - 0x64], ax
  06AB59  21D9: eb51             jmp 0x222c
  06AB5B  21DB: 90               nop 
  06AB5C  21DC: 8b4606           mov ax, word ptr [bp + 6]
  06AB5F  21DF: 8946a4           mov word ptr [bp - 0x5c], ax
  06AB62  21E2: 3d1100           cmp ax, 0x11
  06AB65  21E5: 7505             jne 0x21ec
  06AB67  21E7: c746a42e00       mov word ptr [bp - 0x5c], 0x2e
  06AB6C  21EC: 8b5ea4           mov bx, word ptr [bp - 0x5c]
  06AB6F  21EF: 8bc3             mov ax, bx
  06AB71  21F1: d1e3             shl bx, 1
  06AB73  21F3: 03d8             add bx, ax
  06AB75  21F5: c1e302           shl bx, 2
  06AB78  21F8: 031e4208         add bx, word ptr [0x842]
  06AB7C  21FC: 8e064408         mov es, word ptr [0x844]
  06AB80  2200: 268b474a         mov ax, word ptr es:[bx + 0x4a]
  06AB84  2204: 89469c           mov word ptr [bp - 0x64], ax
  06AB87  2207: 268b474c         mov ax, word ptr es:[bx + 0x4c]
  06AB8B  220B: 894696           mov word ptr [bp - 0x6a], ax
  06AB8E  220E: 06               push es
  06AB8F  220F: ff364208         push word ptr [0x842]
  06AB93  2213: ff76a6           push word ptr [bp - 0x5a]
  06AB96  2216: 8b46a4           mov ax, word ptr [bp - 0x5c]
  06AB99  2219: 40               inc ax
  06AB9A  221A: 8d1ea82d         lea bx, [0x2da8]
  06AB9E  221E: 8b56a8           mov dx, word ptr [bp - 0x58]
  06ABA1  2221: 9a54021f18       lcall 0x181f, 0x254
  06ABA6  2226: 8b469c           mov ax, word ptr [bp - 0x64]
  06ABA9  2229: 050300           add ax, 3
  06ABAC  222C: 8946fe           mov word ptr [bp - 2], ax
  06ABAF  222F: 8b4696           mov ax, word ptr [bp - 0x6a]
  06ABB2  2232: d1f8             sar ax, 1
  06ABB4  2234: 2d0700           sub ax, 7
  06ABB7  2237: 7902             jns 0x223b
  06ABB9  2239: 2bc0             sub ax, ax
  06ABBB  223B: 8946fc           mov word ptr [bp - 4], ax
  06ABBE  223E: 0346a6           add ax, word ptr [bp - 0x5a]
  06ABC1  2241: 894694           mov word ptr [bp - 0x6c], ax
  06ABC4  2244: c646ac00         mov byte ptr [bp - 0x54], 0
  06ABC8  2248: 8b5e06           mov bx, word ptr [bp + 6]
  06ABCB  224B: 8bcb             mov cx, bx
  06ABCD  224D: d1e3             shl bx, 1
  06ABCF  224F: 03d9             add bx, cx
  06ABD1  2251: c1e302           shl bx, 2
  06ABD4  2254: ffb7828f         push word ptr [bx - 0x707e]
  06ABD8  2258: 8d4eac           lea cx, [bp - 0x54]
  06ABDB  225B: 51               push cx
  06ABDC  225C: 9a6e011f18       lcall 0x181f, 0x16e
  06ABE1  2261: 83c404           add sp, 4
  06ABE4  2264: a03108           mov al, byte ptr [0x831]
  06ABE7  2267: 2ae4             sub ah, ah
  06ABE9  2269: 50               push ax
  06ABEA  226A: 8b4694           mov ax, word ptr [bp - 0x6c]
  06ABED  226D: 050600           add ax, 6
  06ABF0  2270: 50               push ax
  06ABF1  2271: 8b46a8           mov ax, word ptr [bp - 0x58]
  06ABF4  2274: 0346fe           add ax, word ptr [bp - 2]
  06ABF7  2277: 50               push ax
  06ABF8  2278: 8d46ac           lea ax, [bp - 0x54]
  06ABFB  227B: 16               push ss
  06ABFC  227C: 50               push ax
  06ABFD  227D: 9a3c011f18       lcall 0x181f, 0x13c
  06AC02  2282: 83c40a           add sp, 0xa
  06AC05  2285: 894698           mov word ptr [bp - 0x68], ax
  06AC08  2288: 83469818         add word ptr [bp - 0x68], 0x18
  06AC0C  228C: ff7606           push word ptr [bp + 6]
  06AC0F  228F: 9ace0a1f18       lcall 0x181f, 0xace
  06AC14  2294: 83c402           add sp, 2
  06AC17  2297: 89469e           mov word ptr [bp - 0x62], ax
  06AC1A  229A: 3d1200           cmp ax, 0x12
  06AC1D  229D: 7405             je 0x22a4
  06AC1F  229F: 3d1500           cmp ax, 0x15
  06AC22  22A2: 7505             jne 0x22a9
  06AC24  22A4: c7469effff       mov word ptr [bp - 0x62], 0xffff
  06AC29  22A9: 837e9e00         cmp word ptr [bp - 0x62], 0
  06AC2D  22AD: 7d03             jge 0x22b2
  06AC2F  22AF: e9f500           jmp 0x23a7
  06AC32  22B2: ff364008         push word ptr [0x840]
  06AC36  22B6: ff363e08         push word ptr [0x83e]
  06AC3A  22BA: ff7694           push word ptr [bp - 0x6c]
  06AC3D  22BD: 8b469e           mov ax, word ptr [bp - 0x62]
  06AC40  22C0: 055200           add ax, 0x52
  06AC43  22C3: 8d1ea82d         lea bx, [0x2da8]
  06AC47  22C7: 8b5698           mov dx, word ptr [bp - 0x68]
  06AC4A  22CA: 9a54021f18       lcall 0x181f, 0x254
  06AC4F  22CF: c646ac00         mov byte ptr [bp - 0x54], 0
  06AC53  22D3: 8b5e9e           mov bx, word ptr [bp - 0x62]
  06AC56  22D6: c1e303           shl bx, 3
  06AC59  22D9: ffb7a48e         push word ptr [bx - 0x715c]
  06AC5D  22DD: 8d46ac           lea ax, [bp - 0x54]
  06AC60  22E0: 50               push ax
  06AC61  22E1: 9a6e011f18       lcall 0x181f, 0x16e
  06AC66  22E6: 83c404           add sp, 4
  06AC69  22E9: a03108           mov al, byte ptr [0x831]
  06AC6C  22EC: 2ae4             sub ah, ah
  06AC6E  22EE: 50               push ax
  06AC6F  22EF: 8b4694           mov ax, word ptr [bp - 0x6c]
  06AC72  22F2: 050600           add ax, 6
  06AC75  22F5: 50               push ax
  06AC76  22F6: 8346980e         add word ptr [bp - 0x68], 0xe
  06AC7A  22FA: ff7698           push word ptr [bp - 0x68]
  06AC7D  22FD: 8d46ac           lea ax, [bp - 0x54]
  06AC80  2300: 16               push ss
  06AC81  2301: 50               push ax
  06AC82  2302: 9a3c011f18       lcall 0x181f, 0x13c
  06AC87  2307: 83c40a           add sp, 0xa
  06AC8A  230A: 894698           mov word ptr [bp - 0x68], ax
  06AC8D  230D: 83469818         add word ptr [bp - 0x68], 0x18
  06AC91  2311: 8b469e           mov ax, word ptr [bp - 0x62]
  06AC94  2314: 89469a           mov word ptr [bp - 0x66], ax
  06AC97  2317: 051700           add ax, 0x17
  06AC9A  231A: 8946a2           mov word ptr [bp - 0x5e], ax
  06AC9D  231D: 837e9e0d         cmp word ptr [bp - 0x62], 0xd
  06ACA1  2321: 750a             jne 0x232d
  06ACA3  2323: c7469a1000       mov word ptr [bp - 0x66], 0x10
  06ACA8  2328: c746a23700       mov word ptr [bp - 0x5e], 0x37
  06ACAD  232D: 837e9e10         cmp word ptr [bp - 0x62], 0x10
  06ACB1  2331: 750a             jne 0x233d
  06ACB3  2333: c7469a1100       mov word ptr [bp - 0x66], 0x11
  06ACB8  2338: c746a23900       mov word ptr [bp - 0x5e], 0x39
  06ACBD  233D: 837e9e11         cmp word ptr [bp - 0x62], 0x11
  06ACC1  2341: 750a             jne 0x234d
  06ACC3  2343: c7469a1200       mov word ptr [bp - 0x66], 0x12
  06ACC8  2348: c746a23f00       mov word ptr [bp - 0x5e], 0x3f
  06ACCD  234D: ff364008         push word ptr [0x840]
  06ACD1  2351: ff363e08         push word ptr [0x83e]
  06ACD5  2355: 8b4694           mov ax, word ptr [bp - 0x6c]
  06ACD8  2358: 40               inc ax
  06ACD9  2359: 40               inc ax
  06ACDA  235A: 50               push ax
  06ACDB  235B: 8b46a2           mov ax, word ptr [bp - 0x5e]
  06ACDE  235E: 8d1ea82d         lea bx, [0x2da8]
  06ACE2  2362: 8b5698           mov dx, word ptr [bp - 0x68]
  06ACE5  2365: 9a54021f18       lcall 0x181f, 0x254
  06ACEA  236A: c646ac00         mov byte ptr [bp - 0x54], 0
  06ACEE  236E: 8b5e9a           mov bx, word ptr [bp - 0x66]
  06ACF1  2371: d1e3             shl bx, 1
  06ACF3  2373: ffb7c097         push word ptr [bx - 0x6840]
  06ACF7  2377: 8d46ac           lea ax, [bp - 0x54]
  06ACFA  237A: 50               push ax
  06ACFB  237B: 9a6e011f18       lcall 0x181f, 0x16e
  06AD00  2380: 83c404           add sp, 4
  06AD03  2383: a03108           mov al, byte ptr [0x831]
  06AD06  2386: 2ae4             sub ah, ah
  06AD08  2388: 50               push ax
  06AD09  2389: 8b4694           mov ax, word ptr [bp - 0x6c]
  06AD0C  238C: 050600           add ax, 6
  06AD0F  238F: 50               push ax
  06AD10  2390: 8346980e         add word ptr [bp - 0x68], 0xe
  06AD14  2394: ff7698           push word ptr [bp - 0x68]
  06AD17  2397: 8d46ac           lea ax, [bp - 0x54]
  06AD1A  239A: 16               push ss
  06AD1B  239B: 50               push ax
  06AD1C  239C: 9a3c011f18       lcall 0x181f, 0x13c
  06AD21  23A1: 83c40a           add sp, 0xa
  06AD24  23A4: 894698           mov word ptr [bp - 0x68], ax
  06AD27  23A7: 8b4696           mov ax, word ptr [bp - 0x6a]
  06AD2A  23AA: 050c00           add ax, 0xc
  06AD2D  23AD: 0146a6           add word ptr [bp - 0x5a], ax
  06AD30  23B0: 8b5e06           mov bx, word ptr [bp + 6]
  06AD33  23B3: 8bc3             mov ax, bx
  06AD35  23B5: d1e3             shl bx, 1
  06AD37  23B7: 03d8             add bx, ax
  06AD39  23B9: c1e302           shl bx, 2
  06AD3C  23BC: 80bf858f00       cmp byte ptr [bx - 0x707b], 0
  06AD41  23C1: 7c60             jl 0x2423
  06AD43  23C3: c646ac00         mov byte ptr [bp - 0x54], 0
  06AD47  23C7: ff36322f         push word ptr [0x2f32]
  06AD4B  23CB: 8d46ac           lea ax, [bp - 0x54]
  06AD4E  23CE: 50               push ax
  06AD4F  23CF: 8bf3             mov si, bx
  06AD51  23D1: 9a6e011f18       lcall 0x181f, 0x16e
  06AD56  23D6: 83c404           add sp, 4
  06AD59  23D9: 8d46ac           lea ax, [bp - 0x54]
  06AD5C  23DC: 50               push ax
  06AD5D  23DD: 9abe011f18       lcall 0x181f, 0x1be
  06AD62  23E2: 83c402           add sp, 2
  06AD65  23E5: 8a84858f         mov al, byte ptr [si - 0x707b]
  06AD69  23E9: 98               cwde 
  06AD6A  23EA: 8bd8             mov bx, ax
  06AD6C  23EC: d1e3             shl bx, 1
  06AD6E  23EE: 03d8             add bx, ax
  06AD70  23F0: c1e302           shl bx, 2
  06AD73  23F3: ffb7828f         push word ptr [bx - 0x707e]
  06AD77  23F7: 8d46ac           lea ax, [bp - 0x54]
  06AD7A  23FA: 50               push ax
  06AD7B  23FB: 9a6e011f18       lcall 0x181f, 0x16e
  06AD80  2400: 83c404           add sp, 4
  06AD83  2403: a03008           mov al, byte ptr [0x830]
  06AD86  2406: 2ae4             sub ah, ah
  06AD88  2408: 50               push ax
  06AD89  2409: ff76a6           push word ptr [bp - 0x5a]
  06AD8C  240C: ff76a8           push word ptr [bp - 0x58]
  06AD8F  240F: 8d46ac           lea ax, [bp - 0x54]
  06AD92  2412: 16               push ss
  06AD93  2413: 50               push ax
  06AD94  2414: 9a3c011f18       lcall 0x181f, 0x13c
  06AD99  2419: 83c40a           add sp, 0xa
  06AD9C  241C: 894698           mov word ptr [bp - 0x68], ax
  06AD9F  241F: 8346a614         add word ptr [bp - 0x5a], 0x14
  06ADA3  2423: 68f11e           push 0x1ef1
  06ADA6  2426: 8d46ac           lea ax, [bp - 0x54]
  06ADA9  2429: 50               push ax
  06ADAA  242A: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06ADAF  242F: 83c404           add sp, 4
  06ADB2  2432: ff7606           push word ptr [bp + 6]
  06ADB5  2435: 8d46ac           lea ax, [bp - 0x54]
  06ADB8  2438: 16               push ss
  06ADB9  2439: 50               push ax
  06ADBA  243A: 9a82011f18       lcall 0x181f, 0x182
  06ADBF  243F: 83c406           add sp, 6
  06ADC2  2442: 8b46a6           mov ax, word ptr [bp - 0x5a]
  06ADC5  2445: a35a1f           mov word ptr [0x1f5a], ax
  06ADC8  2448: 8b5e06           mov bx, word ptr [bp + 6]
  06ADCB  244B: 8bc3             mov ax, bx
  06ADCD  244D: d1e3             shl bx, 1
  06ADCF  244F: 03d8             add bx, ax
  06ADD1  2451: c1e302           shl bx, 2
  06ADD4  2454: ffb7828f         push word ptr [bx - 0x707e]
  06ADD8  2458: 6a00             push 0
  06ADDA  245A: 9a38041f18       lcall 0x181f, 0x438
  06ADDF  245F: 83c404           add sp, 4
  06ADE2  2462: 8d46ac           lea ax, [bp - 0x54]
  06ADE5  2465: 50               push ax
  06ADE6  2466: 0e               push cs
  06ADE7  2467: e8a308           call 0x2d0d
  06ADEA  246A: 83c402           add sp, 2
  06ADED  246D: 6a00             push 0
  06ADEF  246F: 684001           push 0x140
  06ADF2  2472: 68c800           push 0xc8
  06ADF5  2475: 2bc0             sub ax, ax
  06ADF7  2477: 99               cdq 
  06ADF8  2478: 2bdb             sub bx, bx
  06ADFA  247A: 9ae2001f18       lcall 0x181f, 0xe2
  06ADFF  247F: 9ac0031f18       lcall 0x181f, 0x3c0
  06AE04  2484: 5e               pop si
  06AE05  2485: c9               leave 
  06AE06  2486: cb               retf 

; ---- func_06AE08  size=276  insns=102  prologue=ENTER 0x0058,0  terminal=RETF ----
  06AE08  2488: c8580000         enter 0x58, 0
  06AE0C  248C: 56               push si
  06AE0D  248D: 0e               push cs
  06AE0E  248E: e88108           call 0x2d12
  06AE11  2491: a03108           mov al, byte ptr [0x831]
  06AE14  2494: 2ae4             sub ah, ah
  06AE16  2496: 50               push ax
  06AE17  2497: 6a05             push 5
  06AE19  2499: 684001           push 0x140
  06AE1C  249C: 6a00             push 0
  06AE1E  249E: ff36922e         push word ptr [0x2e92]
  06AE22  24A2: 9a22001f18       lcall 0x181f, 0x22
  06AE27  24A7: 83c402           add sp, 2
  06AE2A  24AA: 52               push dx
  06AE2B  24AB: 50               push ax
  06AE2C  24AC: 9a00011f18       lcall 0x181f, 0x100
  06AE31  24B1: 83c40c           add sp, 0xc
  06AE34  24B4: c41e9e08         les bx, ptr [0x89e]
  06AE38  24B8: 268a07           mov al, byte ptr es:[bx]
  06AE3B  24BB: 2ae4             sub ah, ah
  06AE3D  24BD: 050700           add ax, 7
  06AE40  24C0: 8946aa           mov word ptr [bp - 0x56], ax
  06AE43  24C3: c646b000         mov byte ptr [bp - 0x50], 0
  06AE47  24C7: 8d46b0           lea ax, [bp - 0x50]
  06AE4A  24CA: 50               push ax
  06AE4B  24CB: 9a1e011f18       lcall 0x181f, 0x11e
  06AE50  24D0: 83c402           add sp, 2
  06AE53  24D3: 8b5e06           mov bx, word ptr [bp + 6]
  06AE56  24D6: 8bc3             mov ax, bx
  06AE58  24D8: d1e3             shl bx, 1
  06AE5A  24DA: 03d8             add bx, ax
  06AE5C  24DC: d1e3             shl bx, 1
  06AE5E  24DE: ffb75296         push word ptr [bx - 0x69ae]
  06AE62  24E2: 8d46b0           lea ax, [bp - 0x50]
  06AE65  24E5: 50               push ax
  06AE66  24E6: 8bf3             mov si, bx
  06AE68  24E8: 9a6e011f18       lcall 0x181f, 0x16e
  06AE6D  24ED: 83c404           add sp, 4
  06AE70  24F0: 8d46b0           lea ax, [bp - 0x50]
  06AE73  24F3: 50               push ax
  06AE74  24F4: 9abe011f18       lcall 0x181f, 0x1be
  06AE79  24F9: 83c402           add sp, 2
  06AE7C  24FC: 6a05             push 5
  06AE7E  24FE: 8d46b0           lea ax, [bp - 0x50]
  06AE81  2501: 50               push ax
  06AE82  2502: 0e               push cs
  06AE83  2503: e8f807           call 0x2cfe
  06AE86  2506: 83c404           add sp, 4
  06AE89  2509: 8d46b0           lea ax, [bp - 0x50]
  06AE8C  250C: 50               push ax
  06AE8D  250D: 9a28011f18       lcall 0x181f, 0x128
  06AE92  2512: 83c402           add sp, 2
  06AE95  2515: a03108           mov al, byte ptr [0x831]
  06AE98  2518: 2ae4             sub ah, ah
  06AE9A  251A: 50               push ax
  06AE9B  251B: ff76aa           push word ptr [bp - 0x56]
  06AE9E  251E: 684001           push 0x140
  06AEA1  2521: 6a00             push 0
  06AEA3  2523: 8d46b0           lea ax, [bp - 0x50]
  06AEA6  2526: 16               push ss
  06AEA7  2527: 50               push ax
  06AEA8  2528: 9a00011f18       lcall 0x181f, 0x100
  06AEAD  252D: 83c40c           add sp, 0xc
  06AEB0  2530: c41e9e08         les bx, ptr [0x89e]
  06AEB4  2534: 268a07           mov al, byte ptr es:[bx]
  06AEB7  2537: 2ae4             sub ah, ah
  06AEB9  2539: 050e00           add ax, 0xe
  06AEBC  253C: 0146aa           add word ptr [bp - 0x56], ax
  06AEBF  253F: c746ac0a00       mov word ptr [bp - 0x54], 0xa
  06AEC4  2544: 68fa1e           push 0x1efa
  06AEC7  2547: 8d46b0           lea ax, [bp - 0x50]
  06AECA  254A: 50               push ax
  06AECB  254B: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06AED0  2550: 83c404           add sp, 4
  06AED3  2553: ff7606           push word ptr [bp + 6]
  06AED6  2556: 8d46b0           lea ax, [bp - 0x50]
  06AED9  2559: 16               push ss
  06AEDA  255A: 50               push ax
  06AEDB  255B: 9a82011f18       lcall 0x181f, 0x182
  06AEE0  2560: 83c406           add sp, 6
  06AEE3  2563: 8b46aa           mov ax, word ptr [bp - 0x56]
  06AEE6  2566: a35a1f           mov word ptr [0x1f5a], ax
  06AEE9  2569: ffb45296         push word ptr [si - 0x69ae]
  06AEED  256D: 6a00             push 0
  06AEEF  256F: 9a38041f18       lcall 0x181f, 0x438
  06AEF4  2574: 83c404           add sp, 4
  06AEF7  2577: 8d46b0           lea ax, [bp - 0x50]
  06AEFA  257A: 50               push ax
  06AEFB  257B: 0e               push cs
  06AEFC  257C: e88e07           call 0x2d0d
  06AEFF  257F: 83c402           add sp, 2
  06AF02  2582: 6a00             push 0
  06AF04  2584: 684001           push 0x140
  06AF07  2587: 68c800           push 0xc8
  06AF0A  258A: 2bc0             sub ax, ax
  06AF0C  258C: 99               cdq 
  06AF0D  258D: 2bdb             sub bx, bx
  06AF0F  258F: 9ae2001f18       lcall 0x181f, 0xe2
  06AF14  2594: 9ac0031f18       lcall 0x181f, 0x3c0
  06AF19  2599: 5e               pop si
  06AF1A  259A: c9               leave 
  06AF1B  259B: cb               retf 

; ---- func_06AF1C  size=270  insns=99  prologue=ENTER 0x0058,0  terminal=RETF ----
  06AF1C  259C: c8580000         enter 0x58, 0
  06AF20  25A0: 56               push si
  06AF21  25A1: 0e               push cs
  06AF22  25A2: e86d07           call 0x2d12
  06AF25  25A5: a03108           mov al, byte ptr [0x831]
  06AF28  25A8: 2ae4             sub ah, ah
  06AF2A  25AA: 50               push ax
  06AF2B  25AB: 6a05             push 5
  06AF2D  25AD: 684001           push 0x140
  06AF30  25B0: 6a00             push 0
  06AF32  25B2: ff36922e         push word ptr [0x2e92]
  06AF36  25B6: 9a22001f18       lcall 0x181f, 0x22
  06AF3B  25BB: 83c402           add sp, 2
  06AF3E  25BE: 52               push dx
  06AF3F  25BF: 50               push ax
  06AF40  25C0: 9a00011f18       lcall 0x181f, 0x100
  06AF45  25C5: 83c40c           add sp, 0xc
  06AF48  25C8: c41e9e08         les bx, ptr [0x89e]
  06AF4C  25CC: 268a07           mov al, byte ptr es:[bx]
  06AF4F  25CF: 2ae4             sub ah, ah
  06AF51  25D1: 050700           add ax, 7
  06AF54  25D4: 8946aa           mov word ptr [bp - 0x56], ax
  06AF57  25D7: c646b000         mov byte ptr [bp - 0x50], 0
  06AF5B  25DB: 8d46b0           lea ax, [bp - 0x50]
  06AF5E  25DE: 50               push ax
  06AF5F  25DF: 9a1e011f18       lcall 0x181f, 0x11e
  06AF64  25E4: 83c402           add sp, 2
  06AF67  25E7: 8b5e06           mov bx, word ptr [bp + 6]
  06AF6A  25EA: d1e3             shl bx, 1
  06AF6C  25EC: ffb75c93         push word ptr [bx - 0x6ca4]
  06AF70  25F0: 8d46b0           lea ax, [bp - 0x50]
  06AF73  25F3: 50               push ax
  06AF74  25F4: 8bf3             mov si, bx
  06AF76  25F6: 9a6e011f18       lcall 0x181f, 0x16e
  06AF7B  25FB: 83c404           add sp, 4
  06AF7E  25FE: 8d46b0           lea ax, [bp - 0x50]
  06AF81  2601: 50               push ax
  06AF82  2602: 9abe011f18       lcall 0x181f, 0x1be
  06AF87  2607: 83c402           add sp, 2
  06AF8A  260A: 6a06             push 6
  06AF8C  260C: 8d46b0           lea ax, [bp - 0x50]
  06AF8F  260F: 50               push ax
  06AF90  2610: 0e               push cs
  06AF91  2611: e8ea06           call 0x2cfe
  06AF94  2614: 83c404           add sp, 4
  06AF97  2617: 8d46b0           lea ax, [bp - 0x50]
  06AF9A  261A: 50               push ax
  06AF9B  261B: 9a28011f18       lcall 0x181f, 0x128
  06AFA0  2620: 83c402           add sp, 2
  06AFA3  2623: a03108           mov al, byte ptr [0x831]
  06AFA6  2626: 2ae4             sub ah, ah
  06AFA8  2628: 50               push ax
  06AFA9  2629: ff76aa           push word ptr [bp - 0x56]
  06AFAC  262C: 684001           push 0x140
  06AFAF  262F: 6a00             push 0
  06AFB1  2631: 8d46b0           lea ax, [bp - 0x50]
  06AFB4  2634: 16               push ss
  06AFB5  2635: 50               push ax
  06AFB6  2636: 9a00011f18       lcall 0x181f, 0x100
  06AFBB  263B: 83c40c           add sp, 0xc
  06AFBE  263E: c41e9e08         les bx, ptr [0x89e]
  06AFC2  2642: 268a07           mov al, byte ptr es:[bx]
  06AFC5  2645: 2ae4             sub ah, ah
  06AFC7  2647: 050e00           add ax, 0xe
  06AFCA  264A: 0146aa           add word ptr [bp - 0x56], ax
  06AFCD  264D: c746ac0a00       mov word ptr [bp - 0x54], 0xa
  06AFD2  2652: 68011f           push 0x1f01
  06AFD5  2655: 8d46b0           lea ax, [bp - 0x50]
  06AFD8  2658: 50               push ax
  06AFD9  2659: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06AFDE  265E: 83c404           add sp, 4
  06AFE1  2661: ff7606           push word ptr [bp + 6]
  06AFE4  2664: 8d46b0           lea ax, [bp - 0x50]
  06AFE7  2667: 16               push ss
  06AFE8  2668: 50               push ax
  06AFE9  2669: 9a82011f18       lcall 0x181f, 0x182
  06AFEE  266E: 83c406           add sp, 6
  06AFF1  2671: 8b46aa           mov ax, word ptr [bp - 0x56]
  06AFF4  2674: a35a1f           mov word ptr [0x1f5a], ax
  06AFF7  2677: ffb45c93         push word ptr [si - 0x6ca4]
  06AFFB  267B: 6a00             push 0
  06AFFD  267D: 9a38041f18       lcall 0x181f, 0x438
  06B002  2682: 83c404           add sp, 4
  06B005  2685: 8d46b0           lea ax, [bp - 0x50]
  06B008  2688: 50               push ax
  06B009  2689: 0e               push cs
  06B00A  268A: e88006           call 0x2d0d
  06B00D  268D: 83c402           add sp, 2
  06B010  2690: 6a00             push 0
  06B012  2692: 684001           push 0x140
  06B015  2695: 68c800           push 0xc8
  06B018  2698: 2bc0             sub ax, ax
  06B01A  269A: 99               cdq 
  06B01B  269B: 2bdb             sub bx, bx
  06B01D  269D: 9ae2001f18       lcall 0x181f, 0xe2
  06B022  26A2: 9ac0031f18       lcall 0x181f, 0x3c0
  06B027  26A7: 5e               pop si
  06B028  26A8: c9               leave 
  06B029  26A9: cb               retf 

; ---- func_06B02A  size=472  insns=164  prologue=ENTER 0x0062,0  terminal=RETF ----
  06B02A  26AA: c8620000         enter 0x62, 0
  06B02E  26AE: ff36a483         push word ptr [0x83a4]
  06B032  26B2: ff36a283         push word ptr [0x83a2]
  06B036  26B6: ff36a083         push word ptr [0x83a0]
  06B03A  26BA: ff369e83         push word ptr [0x839e]
  06B03E  26BE: ff36ae2d         push word ptr [0x2dae]
  06B042  26C2: ff36ac2d         push word ptr [0x2dac]
  06B046  26C6: ff36aa2d         push word ptr [0x2daa]
  06B04A  26CA: ff36a82d         push word ptr [0x2da8]
  06B04E  26CE: 68b900           push 0xb9
  06B051  26D1: 2bc0             sub ax, ax
  06B053  26D3: ba0f00           mov dx, 0xf
  06B056  26D6: bb4001           mov bx, 0x140
  06B059  26D9: 9a44041f18       lcall 0x181f, 0x444
  06B05E  26DE: 6b06aca518       imul ax, word ptr [0xa5ac], 0x18
  06B063  26E3: 8946a8           mov word ptr [bp - 0x58], ax
  06B066  26E6: eb37             jmp 0x271f
  06B068  26E8: a03008           mov al, byte ptr [0x830]
  06B06B  26EB: 2ae4             sub ah, ah
  06B06D  26ED: 8946a0           mov word ptr [bp - 0x60], ax
  06B070  26F0: 50               push ax
  06B071  26F1: b8ffff           mov ax, 0xffff
  06B074  26F4: 8b56a0           mov dx, word ptr [bp - 0x60]
  06B077  26F7: 8bda             mov bx, dx
  06B079  26F9: 9af0011f18       lcall 0x181f, 0x1f0
  06B07E  26FE: ff36a008         push word ptr [0x8a0]
  06B082  2702: ff369e08         push word ptr [0x89e]
  06B086  2706: 8d46b0           lea ax, [bp - 0x50]
  06B089  2709: 16               push ss
  06B08A  270A: 50               push ax
  06B08B  270B: 6a00             push 0
  06B08D  270D: 8d1ea82d         lea bx, [0x2da8]
  06B091  2711: 8b46ac           mov ax, word ptr [bp - 0x54]
  06B094  2714: 8b56a6           mov dx, word ptr [bp - 0x5a]
  06B097  2717: 9afa011f18       lcall 0x181f, 0x1fa
  06B09C  271C: ff46a8           inc word ptr [bp - 0x58]
  06B09F  271F: 8b46a8           mov ax, word ptr [bp - 0x58]
  06B0A2  2722: 3906aaa5         cmp word ptr [0xa5aa], ax
  06B0A6  2726: 7f03             jg 0x272b
  06B0A8  2728: e9d900           jmp 0x2804
  06B0AB  272B: 8b0eaca5         mov cx, word ptr [0xa5ac]
  06B0AF  272F: 83c103           add cx, 3
  06B0B2  2732: 6bc918           imul cx, cx, 0x18
  06B0B5  2735: 3bc8             cmp cx, ax
  06B0B7  2737: 7f03             jg 0x273c
  06B0B9  2739: e9c800           jmp 0x2804
  06B0BC  273C: 8d4eaa           lea cx, [bp - 0x56]
  06B0BF  273F: 51               push cx
  06B0C0  2740: 8d4eae           lea cx, [bp - 0x52]
  06B0C3  2743: 51               push cx
  06B0C4  2744: 50               push ax
  06B0C5  2745: 0e               push cs
  06B0C6  2746: e8e205           call 0x2d2b
  06B0C9  2749: 83c406           add sp, 6
  06B0CC  274C: 837eae00         cmp word ptr [bp - 0x52], 0
  06B0D0  2750: 7cca             jl 0x271c
  06B0D2  2752: 8d46b0           lea ax, [bp - 0x50]
  06B0D5  2755: 50               push ax
  06B0D6  2756: ff76a8           push word ptr [bp - 0x58]
  06B0D9  2759: 0e               push cs
  06B0DA  275A: e8e205           call 0x2d3f
  06B0DD  275D: 83c404           add sp, 4
  06B0E0  2760: ff36a008         push word ptr [0x8a0]
  06B0E4  2764: ff369e08         push word ptr [0x89e]
  06B0E8  2768: 8d46b0           lea ax, [bp - 0x50]
  06B0EB  276B: 16               push ss
  06B0EC  276C: 50               push ax
  06B0ED  276D: 2bc0             sub ax, ax
  06B0EF  276F: 9a04021f18       lcall 0x181f, 0x204
  06B0F4  2774: 050400           add ax, 4
  06B0F7  2777: 8946a4           mov word ptr [bp - 0x5c], ax
  06B0FA  277A: c41e9e08         les bx, ptr [0x89e]
  06B0FE  277E: 268a07           mov al, byte ptr es:[bx]
  06B101  2781: 2ae4             sub ah, ah
  06B103  2783: 40               inc ax
  06B104  2784: 8946a2           mov word ptr [bp - 0x5e], ax
  06B107  2787: ff36a483         push word ptr [0x83a4]
  06B10B  278B: ff36a283         push word ptr [0x83a2]
  06B10F  278F: ff36a083         push word ptr [0x83a0]
  06B113  2793: ff369e83         push word ptr [0x839e]
  06B117  2797: ff36ae2d         push word ptr [0x2dae]
  06B11B  279B: ff36ac2d         push word ptr [0x2dac]
  06B11F  279F: ff36aa2d         push word ptr [0x2daa]
  06B123  27A3: ff36a82d         push word ptr [0x2da8]
  06B127  27A7: 50               push ax
  06B128  27A8: 8b46ae           mov ax, word ptr [bp - 0x52]
  06B12B  27AB: 8b56aa           mov dx, word ptr [bp - 0x56]
  06B12E  27AE: bb6400           mov bx, 0x64
  06B131  27B1: 9a44041f18       lcall 0x181f, 0x444
  06B136  27B6: 8b46a8           mov ax, word ptr [bp - 0x58]
  06B139  27B9: 394606           cmp word ptr [bp + 6], ax
  06B13C  27BC: 7525             jne 0x27e3
  06B13E  27BE: ff36ae2d         push word ptr [0x2dae]
  06B142  27C2: ff36ac2d         push word ptr [0x2dac]
  06B146  27C6: ff36aa2d         push word ptr [0x2daa]
  06B14A  27CA: ff36a82d         push word ptr [0x2da8]
  06B14E  27CE: ff76a2           push word ptr [bp - 0x5e]
  06B151  27D1: a03508           mov al, byte ptr [0x835]
  06B154  27D4: 50               push ax
  06B155  27D5: 8b46ae           mov ax, word ptr [bp - 0x52]
  06B158  27D8: 8b56aa           mov dx, word ptr [bp - 0x56]
  06B15B  27DB: 8b5ea4           mov bx, word ptr [bp - 0x5c]
  06B15E  27DE: 9aba001f18       lcall 0x181f, 0xba
  06B163  27E3: 8b46ae           mov ax, word ptr [bp - 0x52]
  06B166  27E6: 40               inc ax
  06B167  27E7: 40               inc ax
  06B168  27E8: 8946ac           mov word ptr [bp - 0x54], ax
  06B16B  27EB: 8b46aa           mov ax, word ptr [bp - 0x56]
  06B16E  27EE: 40               inc ax
  06B16F  27EF: 8946a6           mov word ptr [bp - 0x5a], ax
  06B172  27F2: 8b46a8           mov ax, word ptr [bp - 0x58]
  06B175  27F5: 394606           cmp word ptr [bp + 6], ax
  06B178  27F8: 7403             je 0x27fd
  06B17A  27FA: e9ebfe           jmp 0x26e8
  06B17D  27FD: a03108           mov al, byte ptr [0x831]
  06B180  2800: e9e8fe           jmp 0x26eb
  06B183  2803: 90               nop 
  06B184  2804: 833eaaa548       cmp word ptr [0xa5aa], 0x48
  06B189  2809: 7e2e             jle 0x2839
  06B18B  280B: 837e06fe         cmp word ptr [bp + 6], -2
  06B18F  280F: 7505             jne 0x2816
  06B191  2811: a03108           mov al, byte ptr [0x831]
  06B194  2814: eb03             jmp 0x2819
  06B196  2816: a03008           mov al, byte ptr [0x830]
  06B199  2819: 2ae4             sub ah, ah
  06B19B  281B: 89469e           mov word ptr [bp - 0x62], ax
  06B19E  281E: 50               push ax
  06B19F  281F: 6a05             push 5
  06B1A1  2821: 6a05             push 5
  06B1A3  2823: ff36942e         push word ptr [0x2e94]
  06B1A7  2827: 9a22001f18       lcall 0x181f, 0x22
  06B1AC  282C: 83c402           add sp, 2
  06B1AF  282F: 52               push dx
  06B1B0  2830: 50               push ax
  06B1B1  2831: 9a3c011f18       lcall 0x181f, 0x13c
  06B1B6  2836: 83c40a           add sp, 0xa
  06B1B9  2839: 837e06fd         cmp word ptr [bp + 6], -3
  06B1BD  283D: 7505             jne 0x2844
  06B1BF  283F: a03108           mov al, byte ptr [0x831]
  06B1C2  2842: eb03             jmp 0x2847
  06B1C4  2844: a03008           mov al, byte ptr [0x830]
  06B1C7  2847: 2ae4             sub ah, ah
  06B1C9  2849: 89469e           mov word ptr [bp - 0x62], ax
  06B1CC  284C: 50               push ax
  06B1CD  284D: 6a05             push 5
  06B1CF  284F: 683b01           push 0x13b
  06B1D2  2852: ff36962e         push word ptr [0x2e96]
  06B1D6  2856: 9a22001f18       lcall 0x181f, 0x22
  06B1DB  285B: 83c402           add sp, 2
  06B1DE  285E: 52               push dx
  06B1DF  285F: 50               push ax
  06B1E0  2860: 9a50011f18       lcall 0x181f, 0x150
  06B1E5  2865: 83c40a           add sp, 0xa
  06B1E8  2868: 837e0800         cmp word ptr [bp + 8], 0
  06B1EC  286C: 7412             je 0x2880
  06B1EE  286E: 6a00             push 0
  06B1F0  2870: 684001           push 0x140
  06B1F3  2873: 68c800           push 0xc8
  06B1F6  2876: 2bc0             sub ax, ax
  06B1F8  2878: 99               cdq 
  06B1F9  2879: 2bdb             sub bx, bx
  06B1FB  287B: 9ae2001f18       lcall 0x181f, 0xe2
  06B200  2880: c9               leave 
  06B201  2881: cb               retf 

; ---- func_06B202  size=406  insns=155  prologue=ENTER 0x0004,0  terminal=RETF ----
  06B202  2882: c8040000         enter 4, 0
  06B206  2886: 8b4606           mov ax, word ptr [bp + 6]
  06B209  2889: e96e01           jmp 0x29fa
  06B20C  288C: c746fc0000       mov word ptr [bp - 4], 0
  06B211  2891: eb04             jmp 0x2897
  06B213  2893: 90               nop 
  06B214  2894: ff46fc           inc word ptr [bp - 4]
  06B217  2897: 837efc10         cmp word ptr [bp - 4], 0x10
  06B21B  289B: 7c03             jl 0x28a0
  06B21D  289D: e97601           jmp 0x2a16
  06B220  28A0: ff76fc           push word ptr [bp - 4]
  06B223  28A3: 6a00             push 0
  06B225  28A5: 8b5efc           mov bx, word ptr [bp - 4]
  06B228  28A8: d1e3             shl bx, 1
  06B22A  28AA: ffb7c097         push word ptr [bx - 0x6840]
  06B22E  28AE: 0e               push cs
  06B22F  28AF: e85104           call 0x2d03
  06B232  28B2: 83c406           add sp, 6
  06B235  28B5: ebdd             jmp 0x2894
  06B237  28B7: 90               nop 
  06B238  28B8: c746fc0000       mov word ptr [bp - 4], 0
  06B23D  28BD: eb04             jmp 0x28c3
  06B23F  28BF: 90               nop 
  06B240  28C0: ff46fc           inc word ptr [bp - 4]
  06B243  28C3: 837efc17         cmp word ptr [bp - 4], 0x17
  06B247  28C7: 7c03             jl 0x28cc
  06B249  28C9: e94a01           jmp 0x2a16
  06B24C  28CC: ff76fc           push word ptr [bp - 4]
  06B24F  28CF: 6a01             push 1
  06B251  28D1: 8b5efc           mov bx, word ptr [bp - 4]
  06B254  28D4: 8bc3             mov ax, bx
  06B256  28D6: d1e3             shl bx, 1
  06B258  28D8: 03d8             add bx, ax
  06B25A  28DA: d1e3             shl bx, 1
  06B25C  28DC: 03d8             add bx, ax
  06B25E  28DE: d1e3             shl bx, 1
  06B260  28E0: ffb73052         push word ptr [bx + 0x5230]
  06B264  28E4: 0e               push cs
  06B265  28E5: e81b04           call 0x2d03
  06B268  28E8: 83c406           add sp, 6
  06B26B  28EB: ebd3             jmp 0x28c0
  06B26D  28ED: 90               nop 
  06B26E  28EE: c746fc0000       mov word ptr [bp - 4], 0
  06B273  28F3: eb04             jmp 0x28f9
  06B275  28F5: 90               nop 
  06B276  28F6: ff46fc           inc word ptr [bp - 4]
  06B279  28F9: 837efc1d         cmp word ptr [bp - 4], 0x1d
  06B27D  28FD: 7c03             jl 0x2902
  06B27F  28FF: e91401           jmp 0x2a16
  06B282  2902: 837efc10         cmp word ptr [bp - 4], 0x10
  06B286  2906: 7c06             jl 0x290e
  06B288  2908: 837efc18         cmp word ptr [bp - 4], 0x18
  06B28C  290C: 7ce8             jl 0x28f6
  06B28E  290E: ff76fc           push word ptr [bp - 4]
  06B291  2911: 6a02             push 2
  06B293  2913: 8b5efc           mov bx, word ptr [bp - 4]
  06B296  2916: c1e304           shl bx, 4
  06B299  2919: ffb7742f         push word ptr [bx + 0x2f74]
  06B29D  291D: 0e               push cs
  06B29E  291E: e8e203           call 0x2d03
  06B2A1  2921: 83c406           add sp, 6
  06B2A4  2924: ebd0             jmp 0x28f6
  06B2A6  2926: c746fc0000       mov word ptr [bp - 4], 0
  06B2AB  292B: eb04             jmp 0x2931
  06B2AD  292D: 90               nop 
  06B2AE  292E: ff46fc           inc word ptr [bp - 4]
  06B2B1  2931: 837efc1c         cmp word ptr [bp - 4], 0x1c
  06B2B5  2935: 7c03             jl 0x293a
  06B2B7  2937: e9dc00           jmp 0x2a16
  06B2BA  293A: 837efc12         cmp word ptr [bp - 4], 0x12
  06B2BE  293E: 74ee             je 0x292e
  06B2C0  2940: ff76fc           push word ptr [bp - 4]
  06B2C3  2943: 6a03             push 3
  06B2C5  2945: 8b5efc           mov bx, word ptr [bp - 4]
  06B2C8  2948: c1e303           shl bx, 3
  06B2CB  294B: ffb7a28e         push word ptr [bx - 0x715e]
  06B2CF  294F: 0e               push cs
  06B2D0  2950: e8b003           call 0x2d03
  06B2D3  2953: 83c406           add sp, 6
  06B2D6  2956: ebd6             jmp 0x292e
  06B2D8  2958: c746fc0000       mov word ptr [bp - 4], 0
  06B2DD  295D: eb04             jmp 0x2963
  06B2DF  295F: 90               nop 
  06B2E0  2960: ff46fc           inc word ptr [bp - 4]
  06B2E3  2963: 837efc2a         cmp word ptr [bp - 4], 0x2a
  06B2E7  2967: 7c03             jl 0x296c
  06B2E9  2969: e9aa00           jmp 0x2a16
  06B2EC  296C: 837efc1e         cmp word ptr [bp - 4], 0x1e
  06B2F0  2970: 74ee             je 0x2960
  06B2F2  2972: 837efc1f         cmp word ptr [bp - 4], 0x1f
  06B2F6  2976: 74e8             je 0x2960
  06B2F8  2978: 837efc0a         cmp word ptr [bp - 4], 0xa
  06B2FC  297C: 74e2             je 0x2960
  06B2FE  297E: 837efc0b         cmp word ptr [bp - 4], 0xb
  06B302  2982: 74dc             je 0x2960
  06B304  2984: ff76fc           push word ptr [bp - 4]
  06B307  2987: 6a04             push 4
  06B309  2989: 8b5efc           mov bx, word ptr [bp - 4]
  06B30C  298C: 8bc3             mov ax, bx
  06B30E  298E: d1e3             shl bx, 1
  06B310  2990: 03d8             add bx, ax
  06B312  2992: c1e302           shl bx, 2
  06B315  2995: ffb7828f         push word ptr [bx - 0x707e]
  06B319  2999: 0e               push cs
  06B31A  299A: e86603           call 0x2d03
  06B31D  299D: 83c406           add sp, 6
  06B320  29A0: ebbe             jmp 0x2960
  06B322  29A2: c746fc0000       mov word ptr [bp - 4], 0
  06B327  29A7: eb04             jmp 0x29ad
  06B329  29A9: 90               nop 
  06B32A  29AA: ff46fc           inc word ptr [bp - 4]
  06B32D  29AD: 837efc19         cmp word ptr [bp - 4], 0x19
  06B331  29B1: 7d63             jge 0x2a16
  06B333  29B3: ff76fc           push word ptr [bp - 4]
  06B336  29B6: 6a05             push 5
  06B338  29B8: 8b5efc           mov bx, word ptr [bp - 4]
  06B33B  29BB: 8bc3             mov ax, bx
  06B33D  29BD: d1e3             shl bx, 1
  06B33F  29BF: 03d8             add bx, ax
  06B341  29C1: d1e3             shl bx, 1
  06B343  29C3: ffb75296         push word ptr [bx - 0x69ae]
  06B347  29C7: 0e               push cs
  06B348  29C8: e83803           call 0x2d03
  06B34B  29CB: 83c406           add sp, 6
  06B34E  29CE: ebda             jmp 0x29aa
  06B350  29D0: c746fc0000       mov word ptr [bp - 4], 0
  06B355  29D5: eb04             jmp 0x29db
  06B357  29D7: 90               nop 
  06B358  29D8: ff46fc           inc word ptr [bp - 4]
  06B35B  29DB: a14608           mov ax, word ptr [0x846]
  06B35E  29DE: 3946fc           cmp word ptr [bp - 4], ax
  06B361  29E1: 7d33             jge 0x2a16
  06B363  29E3: ff76fc           push word ptr [bp - 4]
  06B366  29E6: 6a06             push 6
  06B368  29E8: 8b5efc           mov bx, word ptr [bp - 4]
  06B36B  29EB: d1e3             shl bx, 1
  06B36D  29ED: ffb75c93         push word ptr [bx - 0x6ca4]
  06B371  29F1: 0e               push cs
  06B372  29F2: e80e03           call 0x2d03
  06B375  29F5: 83c406           add sp, 6
  06B378  29F8: ebde             jmp 0x29d8
  06B37A  29FA: 3d0600           cmp ax, 6
  06B37D  29FD: 7717             ja 0x2a16
  06B37F  29FF: d1e0             shl ax, 1
  06B381  2A01: 93               xchg bx, ax
  06B382  2A02: 2effa7a824       jmp word ptr cs:[bx + 0x24a8]
  06B387  2A07: 90               nop 
  06B388  2A08: 2c23             sub al, 0x23
  06B38A  2A0A: 58               pop ax
  06B38B  2A0B: 238e23c6         and cx, word ptr [bp - 0x39dd]
  06B38F  2A0F: 23f8             and di, ax
  06B391  2A11: 234224           and ax, word ptr [bp + si + 0x24]
  06B394  2A14: 7024             jo 0x2a3a
  06B396  2A16: c9               leave 
  06B397  2A17: cb               retf 

; ---- func_06B398  size=854  insns=315  prologue=ENTER 0x0012,0  terminal=RETF ----
  06B398  2A18: c8120000         enter 0x12, 0
  06B39C  2A1C: 56               push si
  06B39D  2A1D: 0e               push cs
  06B39E  2A1E: e81903           call 0x2d3a
  06B3A1  2A21: 0bc0             or ax, ax
  06B3A3  2A23: 7403             je 0x2a28
  06B3A5  2A25: e9b002           jmp 0x2cd8
  06B3A8  2A28: 837e0607         cmp word ptr [bp + 6], 7
  06B3AC  2A2C: 751c             jne 0x2a4a
  06B3AE  2A2E: 8946f4           mov word ptr [bp - 0xc], ax
  06B3B1  2A31: eb04             jmp 0x2a37
  06B3B3  2A33: 90               nop 
  06B3B4  2A34: ff46f4           inc word ptr [bp - 0xc]
  06B3B7  2A37: 837ef407         cmp word ptr [bp - 0xc], 7
  06B3BB  2A3B: 7d17             jge 0x2a54
  06B3BD  2A3D: ff76f4           push word ptr [bp - 0xc]
  06B3C0  2A40: 0e               push cs
  06B3C1  2A41: e8e202           call 0x2d26
  06B3C4  2A44: 83c402           add sp, 2
  06B3C7  2A47: ebeb             jmp 0x2a34
  06B3C9  2A49: 90               nop 
  06B3CA  2A4A: ff7606           push word ptr [bp + 6]
  06B3CD  2A4D: 0e               push cs
  06B3CE  2A4E: e8d502           call 0x2d26
  06B3D1  2A51: 83c402           add sp, 2
  06B3D4  2A54: 833eaaa500       cmp word ptr [0xa5aa], 0
  06B3D9  2A59: 7503             jne 0x2a5e
  06B3DB  2A5B: e97a02           jmp 0x2cd8
  06B3DE  2A5E: 2bc0             sub ax, ax
  06B3E0  2A60: 8946fc           mov word ptr [bp - 4], ax
  06B3E3  2A63: 8946f6           mov word ptr [bp - 0xa], ax
  06B3E6  2A66: a3aca5           mov word ptr [0xa5ac], ax
  06B3E9  2A69: 0e               push cs
  06B3EA  2A6A: e8aa02           call 0x2d17
  06B3ED  2A6D: 0e               push cs
  06B3EE  2A6E: e8a102           call 0x2d12
  06B3F1  2A71: 6a0f             push 0xf
  06B3F3  2A73: 6a05             push 5
  06B3F5  2A75: 684001           push 0x140
  06B3F8  2A78: 6a00             push 0
  06B3FA  2A7A: ff36922e         push word ptr [0x2e92]
  06B3FE  2A7E: 9a22001f18       lcall 0x181f, 0x22
  06B403  2A83: 83c402           add sp, 2
  06B406  2A86: 52               push dx
  06B407  2A87: 50               push ax
  06B408  2A88: 9a00011f18       lcall 0x181f, 0x100
  06B40D  2A8D: 83c40c           add sp, 0xc
  06B410  2A90: b80100           mov ax, 1
  06B413  2A93: 8946f8           mov word ptr [bp - 8], ax
  06B416  2A96: 50               push ax
  06B417  2A97: 6a00             push 0
  06B419  2A99: 0e               push cs
  06B41A  2A9A: e87f02           call 0x2d1c
  06B41D  2A9D: 83c404           add sp, 4
  06B420  2AA0: 9a7a041f18       lcall 0x181f, 0x47a
  06B425  2AA5: c746fe0100       mov word ptr [bp - 2], 1
  06B42A  2AAA: 2bc0             sub ax, ax
  06B42C  2AAC: 8946fa           mov word ptr [bp - 6], ax
  06B42F  2AAF: 9a66041f18       lcall 0x181f, 0x466
  06B434  2AB4: 9af6001f18       lcall 0x181f, 0xf6
  06B439  2AB9: 0bc0             or ax, ax
  06B43B  2ABB: 7433             je 0x2af0
  06B43D  2ABD: 9ae0031f18       lcall 0x181f, 0x3e0
  06B442  2AC2: 3d3400           cmp ax, 0x34
  06B445  2AC5: 745d             je 0x2b24
  06B447  2AC7: 7e03             jle 0x2acc
  06B449  2AC9: e99600           jmp 0x2b62
  06B44C  2ACC: 3d3200           cmp ax, 0x32
  06B44F  2ACF: 7445             je 0x2b16
  06B451  2AD1: 771d             ja 0x2af0
  06B453  2AD3: 2c09             sub al, 9
  06B455  2AD5: 7467             je 0x2b3e
  06B457  2AD7: 2c04             sub al, 4
  06B459  2AD9: 747f             je 0x2b5a
  06B45B  2ADB: 2c0e             sub al, 0xe
  06B45D  2ADD: 7409             je 0x2ae8
  06B45F  2ADF: 2c05             sub al, 5
  06B461  2AE1: 7477             je 0x2b5a
  06B463  2AE3: eb0b             jmp 0x2af0
  06B465  2AE5: 90               nop 
  06B466  2AE6: 90               nop 
  06B467  2AE7: 90               nop 
  06B468  2AE8: 2bc0             sub ax, ax
  06B46A  2AEA: 8946f8           mov word ptr [bp - 8], ax
  06B46D  2AED: 8946fe           mov word ptr [bp - 2], ax
  06B470  2AF0: 6b06aca518       imul ax, word ptr [0xa5ac], 0x18
  06B475  2AF5: 3b46fc           cmp ax, word ptr [bp - 4]
  06B478  2AF8: 7f03             jg 0x2afd
  06B47A  2AFA: e99400           jmp 0x2b91
  06B47D  2AFD: ff0eaca5         dec word ptr [0xa5ac]
  06B481  2B01: c746fa0100       mov word ptr [bp - 6], 1
  06B486  2B06: ebe8             jmp 0x2af0
  06B488  2B08: ff4efc           dec word ptr [bp - 4]
  06B48B  2B0B: 79f4             jns 0x2b01
  06B48D  2B0D: a1aaa5           mov ax, word ptr [0xa5aa]
  06B490  2B10: 48               dec ax
  06B491  2B11: 8946fc           mov word ptr [bp - 4], ax
  06B494  2B14: ebeb             jmp 0x2b01
  06B496  2B16: 8b46fc           mov ax, word ptr [bp - 4]
  06B499  2B19: 40               inc ax
  06B49A  2B1A: 99               cdq 
  06B49B  2B1B: f73eaaa5         idiv word ptr [0xa5aa]
  06B49F  2B1F: 8956fc           mov word ptr [bp - 4], dx
  06B4A2  2B22: ebdd             jmp 0x2b01
  06B4A4  2B24: 836efc18         sub word ptr [bp - 4], 0x18
  06B4A8  2B28: 79d7             jns 0x2b01
  06B4AA  2B2A: eb03             jmp 0x2b2f
  06B4AC  2B2C: 8946fc           mov word ptr [bp - 4], ax
  06B4AF  2B2F: 8b46fc           mov ax, word ptr [bp - 4]
  06B4B2  2B32: 051800           add ax, 0x18
  06B4B5  2B35: 3b06aaa5         cmp ax, word ptr [0xa5aa]
  06B4B9  2B39: 7cf1             jl 0x2b2c
  06B4BB  2B3B: ebc4             jmp 0x2b01
  06B4BD  2B3D: 90               nop 
  06B4BE  2B3E: a1aaa5           mov ax, word ptr [0xa5aa]
  06B4C1  2B41: 8346fc18         add word ptr [bp - 4], 0x18
  06B4C5  2B45: 3946fc           cmp word ptr [bp - 4], ax
  06B4C8  2B48: 7eb7             jle 0x2b01
  06B4CA  2B4A: eb03             jmp 0x2b4f
  06B4CC  2B4C: 8946fc           mov word ptr [bp - 4], ax
  06B4CF  2B4F: 8b46fc           mov ax, word ptr [bp - 4]
  06B4D2  2B52: 2d1800           sub ax, 0x18
  06B4D5  2B55: 79f5             jns 0x2b4c
  06B4D7  2B57: eba8             jmp 0x2b01
  06B4D9  2B59: 90               nop 
  06B4DA  2B5A: c746f80000       mov word ptr [bp - 8], 0
  06B4DF  2B5F: eb8f             jmp 0x2af0
  06B4E1  2B61: 90               nop 
  06B4E2  2B62: 3d4801           cmp ax, 0x148
  06B4E5  2B65: 74a1             je 0x2b08
  06B4E7  2B67: 7f0d             jg 0x2b76
  06B4E9  2B69: 2d3600           sub ax, 0x36
  06B4EC  2B6C: 74d0             je 0x2b3e
  06B4EE  2B6E: 48               dec ax
  06B4EF  2B6F: 48               dec ax
  06B4F0  2B70: 7496             je 0x2b08
  06B4F2  2B72: e97bff           jmp 0x2af0
  06B4F5  2B75: 90               nop 
  06B4F6  2B76: 2d4b01           sub ax, 0x14b
  06B4F9  2B79: 74a9             je 0x2b24
  06B4FB  2B7B: 48               dec ax
  06B4FC  2B7C: 48               dec ax
  06B4FD  2B7D: 74bf             je 0x2b3e
  06B4FF  2B7F: 2d0300           sub ax, 3
  06B502  2B82: 7492             je 0x2b16
  06B504  2B84: e969ff           jmp 0x2af0
  06B507  2B87: 90               nop 
  06B508  2B88: ff06aca5         inc word ptr [0xa5ac]
  06B50C  2B8C: c746fa0100       mov word ptr [bp - 6], 1
  06B511  2B91: a1aca5           mov ax, word ptr [0xa5ac]
  06B514  2B94: 050300           add ax, 3
  06B517  2B97: 6bc018           imul ax, ax, 0x18
  06B51A  2B9A: 3b46fc           cmp ax, word ptr [bp - 4]
  06B51D  2B9D: 7ee9             jle 0x2b88
  06B51F  2B9F: 833ef60700       cmp word ptr [0x7f6], 0
  06B524  2BA4: 747c             je 0x2c22
  06B526  2BA6: 0e               push cs
  06B527  2BA7: e88601           call 0x2d30
  06B52A  2BAA: 8946f2           mov word ptr [bp - 0xe], ax
  06B52D  2BAD: 40               inc ax
  06B52E  2BAE: 7413             je 0x2bc3
  06B530  2BB0: 8b46fc           mov ax, word ptr [bp - 4]
  06B533  2BB3: 3946f2           cmp word ptr [bp - 0xe], ax
  06B536  2BB6: 740b             je 0x2bc3
  06B538  2BB8: 8b46f2           mov ax, word ptr [bp - 0xe]
  06B53B  2BBB: 8946f6           mov word ptr [bp - 0xa], ax
  06B53E  2BBE: c746fa0100       mov word ptr [bp - 6], 1
  06B543  2BC3: 833ef40700       cmp word ptr [0x7f4], 0
  06B548  2BC8: 744a             je 0x2c14
  06B54A  2BCA: 837ef2fe         cmp word ptr [bp - 0xe], -2
  06B54E  2BCE: 7534             jne 0x2c04
  06B550  2BD0: 833eaaa548       cmp word ptr [0xa5aa], 0x48
  06B555  2BD5: 7e3d             jle 0x2c14
  06B557  2BD7: a1aca5           mov ax, word ptr [0xa5ac]
  06B55A  2BDA: 050300           add ax, 3
  06B55D  2BDD: 6bc818           imul cx, ax, 0x18
  06B560  2BE0: 3b0eaaa5         cmp cx, word ptr [0xa5aa]
  06B564  2BE4: 7d06             jge 0x2bec
  06B566  2BE6: a3aca5           mov word ptr [0xa5ac], ax
  06B569  2BE9: eb07             jmp 0x2bf2
  06B56B  2BEB: 90               nop 
  06B56C  2BEC: c706aca50000     mov word ptr [0xa5ac], 0
  06B572  2BF2: 6b06aca518       imul ax, word ptr [0xa5ac], 0x18
  06B577  2BF7: 8946f6           mov word ptr [bp - 0xa], ax
  06B57A  2BFA: 8946fc           mov word ptr [bp - 4], ax
  06B57D  2BFD: c746fa0100       mov word ptr [bp - 6], 1
  06B582  2C02: eb10             jmp 0x2c14
  06B584  2C04: c746f80000       mov word ptr [bp - 8], 0
  06B589  2C09: 837ef200         cmp word ptr [bp - 0xe], 0
  06B58D  2C0D: 7d05             jge 0x2c14
  06B58F  2C0F: c746fe0000       mov word ptr [bp - 2], 0
  06B594  2C14: 837ef600         cmp word ptr [bp - 0xa], 0
  06B598  2C18: 7c0e             jl 0x2c28
  06B59A  2C1A: 8b46f6           mov ax, word ptr [bp - 0xa]
  06B59D  2C1D: 8946fc           mov word ptr [bp - 4], ax
  06B5A0  2C20: eb06             jmp 0x2c28
  06B5A2  2C22: 8b46fc           mov ax, word ptr [bp - 4]
  06B5A5  2C25: 8946f6           mov word ptr [bp - 0xa], ax
  06B5A8  2C28: 837efa00         cmp word ptr [bp - 6], 0
  06B5AC  2C2C: 740c             je 0x2c3a
  06B5AE  2C2E: 6a01             push 1
  06B5B0  2C30: ff76f6           push word ptr [bp - 0xa]
  06B5B3  2C33: 0e               push cs
  06B5B4  2C34: e8e500           call 0x2d1c
  06B5B7  2C37: 83c404           add sp, 4
  06B5BA  2C3A: 2bc0             sub ax, ax
  06B5BC  2C3C: 8b56f8           mov dx, word ptr [bp - 8]
  06B5BF  2C3F: 9a5c041f18       lcall 0x181f, 0x45c
  06B5C4  2C44: 837ef800         cmp word ptr [bp - 8], 0
  06B5C8  2C48: 7403             je 0x2c4d
  06B5CA  2C4A: e95dfe           jmp 0x2aaa
  06B5CD  2C4D: 837efe00         cmp word ptr [bp - 2], 0
  06B5D1  2C51: 7503             jne 0x2c56
  06B5D3  2C53: e98200           jmp 0x2cd8
  06B5D6  2C56: c41eae1e         les bx, ptr [0x1eae]
  06B5DA  2C5A: 8b76fc           mov si, word ptr [bp - 4]
  06B5DD  2C5D: 268a00           mov al, byte ptr es:[bx + si]
  06B5E0  2C60: 2ae4             sub ah, ah
  06B5E2  2C62: 8946f0           mov word ptr [bp - 0x10], ax
  06B5E5  2C65: c41eaa1e         les bx, ptr [0x1eaa]
  06B5E9  2C69: 268a00           mov al, byte ptr es:[bx + si]
  06B5EC  2C6C: eb4c             jmp 0x2cba
  06B5EE  2C6E: 90               nop 
  06B5EF  2C6F: 90               nop 
  06B5F0  2C70: ff76f0           push word ptr [bp - 0x10]
  06B5F3  2C73: 0e               push cs
  06B5F4  2C74: e87800           call 0x2cef
  06B5F7  2C77: eb3a             jmp 0x2cb3
  06B5F9  2C79: 90               nop 
  06B5FA  2C7A: ff76f0           push word ptr [bp - 0x10]
  06B5FD  2C7D: 0e               push cs
  06B5FE  2C7E: e87300           call 0x2cf4
  06B601  2C81: eb30             jmp 0x2cb3
  06B603  2C83: 90               nop 
  06B604  2C84: ff76f0           push word ptr [bp - 0x10]
  06B607  2C87: 0e               push cs
  06B608  2C88: e85500           call 0x2ce0
  06B60B  2C8B: eb26             jmp 0x2cb3
  06B60D  2C8D: 90               nop 
  06B60E  2C8E: ff76f0           push word ptr [bp - 0x10]
  06B611  2C91: 0e               push cs
  06B612  2C92: e85000           call 0x2ce5
  06B615  2C95: eb1c             jmp 0x2cb3
  06B617  2C97: 90               nop 
  06B618  2C98: ff76f0           push word ptr [bp - 0x10]
  06B61B  2C9B: 0e               push cs
  06B61C  2C9C: e84b00           call 0x2cea
  06B61F  2C9F: eb12             jmp 0x2cb3
  06B621  2CA1: 90               nop 
  06B622  2CA2: ff76f0           push word ptr [bp - 0x10]
  06B625  2CA5: 0e               push cs
  06B626  2CA6: e85000           call 0x2cf9
  06B629  2CA9: eb08             jmp 0x2cb3
  06B62B  2CAB: 90               nop 
  06B62C  2CAC: ff76f0           push word ptr [bp - 0x10]
  06B62F  2CAF: 0e               push cs
  06B630  2CB0: e85500           call 0x2d08
  06B633  2CB3: 83c402           add sp, 2
  06B636  2CB6: e9a5fd           jmp 0x2a5e
  06B639  2CB9: 90               nop 
  06B63A  2CBA: 3d0600           cmp ax, 6
  06B63D  2CBD: 7603             jbe 0x2cc2
  06B63F  2CBF: e99cfd           jmp 0x2a5e
  06B642  2CC2: d1e0             shl ax, 1
  06B644  2CC4: 93               xchg bx, ax
  06B645  2CC5: 2effa76a27       jmp word ptr cs:[bx + 0x276a]
  06B64A  2CCA: 1027             adc byte ptr [bx], ah
  06B64C  2CCC: 1a27             sbb ah, byte ptr [bx]
  06B64E  2CCE: 2427             and al, 0x27
  06B650  2CD0: 2e27             daa 
  06B652  2CD2: 3827             cmp byte ptr [bx], ah
  06B654  2CD4: 42               inc dx
  06B655  2CD5: 27               daa 
  06B656  2CD6: 4c               dec sp
  06B657  2CD7: 27               daa 
  06B658  2CD8: 0e               push cs
  06B659  2CD9: e85900           call 0x2d35
  06B65C  2CDC: 5e               pop si
  06B65D  2CDD: c9               leave 
  06B65E  2CDE: cb               retf 
  06B65F  2CDF: 90               nop 
  06B660  2CE0: ea28041f19       ljmp 0x191f:0x428
  06B665  2CE5: eade081f19       ljmp 0x191f:0x8de
  06B66A  2CEA: ea02091f19       ljmp 0x191f:0x902
  06B66F  2CEF: ea34091f19       ljmp 0x191f:0x934
  06B674  2CF4: ea42091f19       ljmp 0x191f:0x942
  06B679  2CF9: ea62001f1a       ljmp 0x1a1f:0x62
  06B67E  2CFE: ea98091f1a       ljmp 0x1a1f:0x998
  06B683  2D03: eaa6091f1a       ljmp 0x1a1f:0x9a6
  06B688  2D08: eab4091f1a       ljmp 0x1a1f:0x9b4
  06B68D  2D0D: eac2091f1a       ljmp 0x1a1f:0x9c2
  06B692  2D12: ead0091f1a       ljmp 0x1a1f:0x9d0
  06B697  2D17: eade091f1a       ljmp 0x1a1f:0x9de
  06B69C  2D1C: eaec091f1a       ljmp 0x1a1f:0x9ec
  06B6A1  2D21: eafa091f1a       ljmp 0x1a1f:0x9fa
  06B6A6  2D26: ea080a1f1a       ljmp 0x1a1f:0xa08
  06B6AB  2D2B: ea160a1f1a       ljmp 0x1a1f:0xa16
  06B6B0  2D30: ea240a1f1a       ljmp 0x1a1f:0xa24
  06B6B5  2D35: ea320a1f1a       ljmp 0x1a1f:0xa32
  06B6BA  2D3A: ea400a1f1a       ljmp 0x1a1f:0xa40
  06B6BF  2D3F: ea4e0a1f1a       ljmp 0x1a1f:0xa4e
  06B6C4  2D44: ff36ae2d         push word ptr [0x2dae]
  06B6C8  2D48: ff36ac2d         push word ptr [0x2dac]
  06B6CC  2D4C: ff36aa2d         push word ptr [0x2daa]
  06B6D0  2D50: ff36a82d         push word ptr [0x2da8]
  06B6D4  2D54: 2ac0             sub al, al
  06B6D6  2D56: 9a84041f18       lcall 0x181f, 0x484
  06B6DB  2D5B: 6a00             push 0
  06B6DD  2D5D: 684001           push 0x140
  06B6E0  2D60: 68c800           push 0xc8
  06B6E3  2D63: 2bc0             sub ax, ax
  06B6E5  2D65: 99               cdq 
  06B6E6  2D66: 2bdb             sub bx, bx
  06B6E8  2D68: 9ae2001f18       lcall 0x181f, 0xe2
  06B6ED  2D6D: cb               retf 

; ---- func_06B6EE  size=52  insns=19  prologue=ENTER 0x0008,0  terminal=RET ----
  06B6EE  2D6E: c8080000         enter 8, 0
  06B6F2  2D72: c45e04           les bx, ptr [bp + 4]
  06B6F5  2D75: 83c342           add bx, 0x42
  06B6F8  2D78: 268b4708         mov ax, word ptr es:[bx + 8]
  06B6FC  2D7C: d1f8             sar ax, 1
  06B6FE  2D7E: 262b4704         sub ax, word ptr es:[bx + 4]
  06B702  2D82: f7d8             neg ax
  06B704  2D84: 268b4f06         mov cx, word ptr es:[bx + 6]
  06B708  2D88: 262b4f0a         sub cx, word ptr es:[bx + 0xa]
  06B70C  2D8C: 41               inc cx
  06B70D  2D8D: 06               push es
  06B70E  2D8E: ff7604           push word ptr [bp + 4]
  06B711  2D91: 51               push cx
  06B712  2D92: 8bd0             mov dx, ax
  06B714  2D94: b80100           mov ax, 1
  06B717  2D97: 8d1ea82d         lea bx, [0x2da8]
  06B71B  2D9B: 9a54021f18       lcall 0x181f, 0x254
  06B720  2DA0: c9               leave 
  06B721  2DA1: c3               ret 

; ---- func_06B722  size=975  insns=295  prologue=ENTER 0x03C8,0  terminal=page-end ----
  06B722  2DA2: c8c80300         enter 0x3c8, 0
  06B726  2DA6: 56               push si
  06B727  2DA7: c7865cff0100     mov word ptr [bp - 0xa4], 1
  06B72D  2DAD: c78638fc0000     mov word ptr [bp - 0x3c8], 0
  06B733  2DB3: 2bc0             sub ax, ax
  06B735  2DB5: 898656fc         mov word ptr [bp - 0x3aa], ax
  06B739  2DB9: 898654fc         mov word ptr [bp - 0x3ac], ax
  06B73D  2DBD: 898644fc         mov word ptr [bp - 0x3bc], ax
  06B741  2DC1: 898642fc         mov word ptr [bp - 0x3be], ax
  06B745  2DC5: 89863cfc         mov word ptr [bp - 0x3c4], ax
  06B749  2DC9: 89863afc         mov word ptr [bp - 0x3c6], ax
  06B74D  2DCD: 89865afc         mov word ptr [bp - 0x3a6], ax
  06B751  2DD1: 898658fc         mov word ptr [bp - 0x3a8], ax
  06B755  2DD5: 394606           cmp word ptr [bp + 6], ax
  06B758  2DD8: 7d11             jge 0x2deb
  06B75A  2DDA: 7f09             jg 0x2de5
  06B75C  2DDC: 8b4606           mov ax, word ptr [bp + 6]
  06B75F  2DDF: f7d0             not ax
  06B761  2DE1: 40               inc ax
  06B762  2DE2: 894606           mov word ptr [bp + 6], ax
  06B765  2DE5: c78638fc0100     mov word ptr [bp - 0x3c8], 1
  06B76B  2DEB: 68061f           push 0x1f06
  06B76E  2DEE: 8d865eff         lea ax, [bp - 0xa2]
  06B772  2DF2: 50               push ax
  06B773  2DF3: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06B778  2DF8: 83c404           add sp, 4
  06B77B  2DFB: 8d865eff         lea ax, [bp - 0xa2]
  06B77F  2DFF: 16               push ss
  06B780  2E00: 50               push ax
  06B781  2E01: 8b4606           mov ax, word ptr [bp + 6]
  06B784  2E04: ba0200           mov dx, 2
  06B787  2E07: 9a9a0e1f18       lcall 0x181f, 0xe9a
  06B78C  2E0C: 8d865eff         lea ax, [bp - 0xa2]
  06B790  2E10: 16               push ss
  06B791  2E11: 50               push ax
  06B792  2E12: 1e               push ds
  06B793  2E13: 680c1f           push 0x1f0c
  06B796  2E16: 9a940a1f1a       lcall 0x1a1f, 0xa94
  06B79B  2E1B: 8d9e5eff         lea bx, [bp - 0xa2]
  06B79F  2E1F: 9a900e1f18       lcall 0x181f, 0xe90
  06B7A4  2E24: 0bc0             or ax, ax
  06B7A6  2E26: 7503             jne 0x2e2b
  06B7A8  2E28: e93a03           jmp 0x3165
  06B7AB  2E2B: 8d1e0f1f         lea bx, [0x1f0f]
  06B7AF  2E2F: 9a860a1f1a       lcall 0x1a1f, 0xa86
  06B7B4  2E34: 898654fc         mov word ptr [bp - 0x3ac], ax
  06B7B8  2E38: 899656fc         mov word ptr [bp - 0x3aa], dx
  06B7BC  2E3C: 0bd0             or dx, ax
  06B7BE  2E3E: 7503             jne 0x2e43
  06B7C0  2E40: e92203           jmp 0x3165
  06B7C3  2E43: 9ade0f1f19       lcall 0x191f, 0xfde
  06B7C8  2E48: 8d1e171f         lea bx, [0x1f17]
  06B7CC  2E4C: 2bc0             sub ax, ax
  06B7CE  2E4E: 9ad00f1f19       lcall 0x191f, 0xfd0
  06B7D3  2E53: 898642fc         mov word ptr [bp - 0x3be], ax
  06B7D7  2E57: 899644fc         mov word ptr [bp - 0x3bc], dx
  06B7DB  2E5B: 0bd0             or dx, ax
  06B7DD  2E5D: 7503             jne 0x2e62
  06B7DF  2E5F: e9b002           jmp 0x3112
  06B7E2  2E62: 8d1e201f         lea bx, [0x1f20]
  06B7E6  2E66: 2bc0             sub ax, ax
  06B7E8  2E68: 9ad00f1f19       lcall 0x191f, 0xfd0
  06B7ED  2E6D: 898658fc         mov word ptr [bp - 0x3a8], ax
  06B7F1  2E71: 89965afc         mov word ptr [bp - 0x3a6], dx
  06B7F5  2E75: 0bd0             or dx, ax
  06B7F7  2E77: 7503             jne 0x2e7c
  06B7F9  2E79: e99602           jmp 0x3112
  06B7FC  2E7C: 83be38fc00       cmp word ptr [bp - 0x3c8], 0
  06B801  2E81: 7419             je 0x2e9c
  06B803  2E83: 8d865cfc         lea ax, [bp - 0x3a4]
  06B807  2E87: 16               push ss
  06B808  2E88: 50               push ax
  06B809  2E89: 9a780a1f1a       lcall 0x1a1f, 0xa78
  06B80E  2E8E: 8d865cfc         lea ax, [bp - 0x3a4]
  06B812  2E92: 16               push ss
  06B813  2E93: 50               push ax
  06B814  2E94: b80100           mov ax, 1
  06B817  2E97: 9a6a0a1f1a       lcall 0x1a1f, 0xa6a
  06B81C  2E9C: 8d865cfc         lea ax, [bp - 0x3a4]
  06B820  2EA0: a3f223           mov word ptr [0x23f2], ax
  06B823  2EA3: 8c16f423         mov word ptr [0x23f4], ss
  06B827  2EA7: 8d9e5eff         lea bx, [bp - 0xa2]
  06B82B  2EAB: 2bc0             sub ax, ax
  06B82D  2EAD: 9ad00f1f19       lcall 0x191f, 0xfd0
  06B832  2EB2: 89863afc         mov word ptr [bp - 0x3c6], ax
  06B836  2EB6: 89963cfc         mov word ptr [bp - 0x3c4], dx
  06B83A  2EBA: 0bd0             or dx, ax
  06B83C  2EBC: 7503             jne 0x2ec1
  06B83E  2EBE: e95102           jmp 0x3112
  06B841  2EC1: 0e               push cs
  06B842  2EC2: e8a702           call 0x316c
  06B845  2EC5: 83be38fc00       cmp word ptr [bp - 0x3c8], 0
  06B84A  2ECA: 7506             jne 0x2ed2
  06B84C  2ECC: c70672030000     mov word ptr [0x372], 0
  06B852  2ED2: 8d865cfc         lea ax, [bp - 0x3a4]
  06B856  2ED6: 16               push ss
  06B857  2ED7: 50               push ax
  06B858  2ED8: 9af4031f18       lcall 0x181f, 0x3f4
  06B85D  2EDD: ffb644fc         push word ptr [bp - 0x3bc]
  06B861  2EE1: ffb642fc         push word ptr [bp - 0x3be]
  06B865  2EE5: e886fe           call 0x2d6e
  06B868  2EE8: 83c404           add sp, 4
  06B86B  2EEB: c49e58fc         les bx, ptr [bp - 0x3a8]
  06B86F  2EEF: 268b474a         mov ax, word ptr es:[bx + 0x4a]
  06B873  2EF3: 898652fc         mov word ptr [bp - 0x3ae], ax
  06B877  2EF7: 268b4756         mov ax, word ptr es:[bx + 0x56]
  06B87B  2EFB: 89864cfc         mov word ptr [bp - 0x3b4], ax
  06B87F  2EFF: 268b4762         mov ax, word ptr es:[bx + 0x62]
  06B883  2F03: 898646fc         mov word ptr [bp - 0x3ba], ax
  06B887  2F07: 83be38fc00       cmp word ptr [bp - 0x3c8], 0
  06B88C  2F0C: 740b             je 0x2f19
  06B88E  2F0E: 837e0601         cmp word ptr [bp + 6], 1
  06B892  2F12: 7505             jne 0x2f19
  06B894  2F14: c746060000       mov word ptr [bp + 6], 0
  06B899  2F19: 68291f           push 0x1f29
  06B89C  2F1C: 68311f           push 0x1f31
  06B89F  2F1F: 9a28091f19       lcall 0x191f, 0x928
  06B8A4  2F24: 83c404           add sp, 4
  06B8A7  2F27: c78648fc0000     mov word ptr [bp - 0x3b8], 0
  06B8AD  2F2D: eb0e             jmp 0x2f3d
  06B8AF  2F2F: 90               nop 
  06B8B0  2F30: 9a1c091f19       lcall 0x191f, 0x91c
  06B8B5  2F35: 898640fc         mov word ptr [bp - 0x3c0], ax
  06B8B9  2F39: ff8648fc         inc word ptr [bp - 0x3b8]
  06B8BD  2F3D: 8b8648fc         mov ax, word ptr [bp - 0x3b8]
  06B8C1  2F41: 394606           cmp word ptr [bp + 6], ax
  06B8C4  2F44: 7dea             jge 0x2f30
  06B8C6  2F46: 9ab80f1f19       lcall 0x191f, 0xfb8
  06B8CB  2F4B: ffb640fc         push word ptr [bp - 0x3c0]
  06B8CF  2F4F: 8d865eff         lea ax, [bp - 0xa2]
  06B8D3  2F53: 50               push ax
  06B8D4  2F54: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06B8D9  2F59: 83c404           add sp, 4
  06B8DC  2F5C: c646b000         mov byte ptr [bp - 0x50], 0
  06B8E0  2F60: 6a0a             push 0xa
  06B8E2  2F62: 8d46b0           lea ax, [bp - 0x50]
  06B8E5  2F65: 50               push ax
  06B8E6  2F66: ff368a53         push word ptr [0x538a]
  06B8EA  2F6A: 9afa081d0d       lcall 0xd1d, 0x8fa
  06B8EF  2F6F: 83c406           add sp, 6
  06B8F2  2F72: 68391f           push 0x1f39
  06B8F5  2F75: 8d46b0           lea ax, [bp - 0x50]
  06B8F8  2F78: 50               push ax
  06B8F9  2F79: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06B8FE  2F7E: 83c404           add sp, 4
  06B901  2F81: 8d865eff         lea ax, [bp - 0xa2]
  06B905  2F85: 50               push ax
  06B906  2F86: 8d4eb0           lea cx, [bp - 0x50]
  06B909  2F89: 51               push cx
  06B90A  2F8A: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06B90F  2F8F: 83c404           add sp, 4
  06B912  2F92: 8d865eff         lea ax, [bp - 0xa2]
  06B916  2F96: 50               push ax
  06B917  2F97: 8d46b0           lea ax, [bp - 0x50]
  06B91A  2F9A: 50               push ax
  06B91B  2F9B: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06B920  2FA0: 83c404           add sp, 4
  06B923  2FA3: ffb656fc         push word ptr [bp - 0x3aa]
  06B927  2FA7: ffb654fc         push word ptr [bp - 0x3ac]
  06B92B  2FAB: 8d46b0           lea ax, [bp - 0x50]
  06B92E  2FAE: 16               push ss
  06B92F  2FAF: 50               push ax
  06B930  2FB0: 2bc0             sub ax, ax
  06B932  2FB2: 9a04021f18       lcall 0x181f, 0x204
  06B937  2FB7: 8946ae           mov word ptr [bp - 0x52], ax
  06B93A  2FBA: 2bc0             sub ax, ax
  06B93C  2FBC: 89863efc         mov word ptr [bp - 0x3c2], ax
  06B940  2FC0: 89864efc         mov word ptr [bp - 0x3b2], ax
  06B944  2FC4: eb0c             jmp 0x2fd2
  06B946  2FC6: 8b864cfc         mov ax, word ptr [bp - 0x3b4]
  06B94A  2FCA: 01863efc         add word ptr [bp - 0x3c2], ax
  06B94E  2FCE: ff864efc         inc word ptr [bp - 0x3b2]
  06B952  2FD2: 8b46ae           mov ax, word ptr [bp - 0x52]
  06B955  2FD5: 39863efc         cmp word ptr [bp - 0x3c2], ax
  06B959  2FD9: 7ceb             jl 0x2fc6
  06B95B  2FDB: ffb65afc         push word ptr [bp - 0x3a6]
  06B95F  2FDF: ffb658fc         push word ptr [bp - 0x3a8]
  06B963  2FE3: b8a200           mov ax, 0xa2
  06B966  2FE6: 89864afc         mov word ptr [bp - 0x3b6], ax
  06B96A  2FEA: 50               push ax
  06B96B  2FEB: baa000           mov dx, 0xa0
  06B96E  2FEE: 8b863efc         mov ax, word ptr [bp - 0x3c2]
  06B972  2FF2: 038646fc         add ax, word ptr [bp - 0x3ba]
  06B976  2FF6: 038652fc         add ax, word ptr [bp - 0x3ae]
  06B97A  2FFA: d1f8             sar ax, 1
  06B97C  2FFC: 2bd0             sub dx, ax
  06B97E  2FFE: b80100           mov ax, 1
  06B981  3001: 8d1ea82d         lea bx, [0x2da8]
  06B985  3005: 8bf2             mov si, dx
  06B987  3007: 9a54021f18       lcall 0x181f, 0x254
  06B98C  300C: 03b652fc         add si, word ptr [bp - 0x3ae]
  06B990  3010: 89b650fc         mov word ptr [bp - 0x3b0], si
  06B994  3014: c78648fc0000     mov word ptr [bp - 0x3b8], 0
  06B99A  301A: eb28             jmp 0x3044
  06B99C  301C: ffb65afc         push word ptr [bp - 0x3a6]
  06B9A0  3020: ffb658fc         push word ptr [bp - 0x3a8]
  06B9A4  3024: ffb64afc         push word ptr [bp - 0x3b6]
  06B9A8  3028: b80200           mov ax, 2
  06B9AB  302B: 8d1ea82d         lea bx, [0x2da8]
  06B9AF  302F: 8b9650fc         mov dx, word ptr [bp - 0x3b0]
  06B9B3  3033: 9a54021f18       lcall 0x181f, 0x254
  06B9B8  3038: 8b864cfc         mov ax, word ptr [bp - 0x3b4]
  06B9BC  303C: 018650fc         add word ptr [bp - 0x3b0], ax
  06B9C0  3040: ff8648fc         inc word ptr [bp - 0x3b8]
  06B9C4  3044: 8b8648fc         mov ax, word ptr [bp - 0x3b8]
  06B9C8  3048: 39864efc         cmp word ptr [bp - 0x3b2], ax
  06B9CC  304C: 7fce             jg 0x301c
  06B9CE  304E: ffb65afc         push word ptr [bp - 0x3a6]
  06B9D2  3052: ffb658fc         push word ptr [bp - 0x3a8]
  06B9D6  3056: ffb64afc         push word ptr [bp - 0x3b6]
  06B9DA  305A: b80300           mov ax, 3
  06B9DD  305D: 8d1ea82d         lea bx, [0x2da8]
  06B9E1  3061: 8b9650fc         mov dx, word ptr [bp - 0x3b0]
  06B9E5  3065: 9a54021f18       lcall 0x181f, 0x254
  06B9EA  306A: 8b46ae           mov ax, word ptr [bp - 0x52]
  06B9ED  306D: d1f8             sar ax, 1
  06B9EF  306F: 2da000           sub ax, 0xa0
  06B9F2  3072: f7d8             neg ax
  06B9F4  3074: 898650fc         mov word ptr [bp - 0x3b0], ax
  06B9F8  3078: 6a5d             push 0x5d
  06B9FA  307A: b8ffff           mov ax, 0xffff
  06B9FD  307D: ba5c00           mov dx, 0x5c
  06BA00  3080: bb5e00           mov bx, 0x5e
  06BA03  3083: 9af0011f18       lcall 0x181f, 0x1f0
  06BA08  3088: ffb656fc         push word ptr [bp - 0x3aa]
  06BA0C  308C: ffb654fc         push word ptr [bp - 0x3ac]
  06BA10  3090: 8d46b0           lea ax, [bp - 0x50]
  06BA13  3093: 16               push ss
  06BA14  3094: 50               push ax
  06BA15  3095: 6a00             push 0
  06BA17  3097: baa500           mov dx, 0xa5
  06BA1A  309A: 89964afc         mov word ptr [bp - 0x3b6], dx
  06BA1E  309E: 8d1ea82d         lea bx, [0x2da8]
  06BA22  30A2: 8b8650fc         mov ax, word ptr [bp - 0x3b0]
  06BA26  30A6: 9afa011f18       lcall 0x181f, 0x1fa
  06BA2B  30AB: ff36ae2d         push word ptr [0x2dae]
  06BA2F  30AF: ff36ac2d         push word ptr [0x2dac]
  06BA33  30B3: ff36aa2d         push word ptr [0x2daa]
  06BA37  30B7: ff36a82d         push word ptr [0x2da8]
  06BA3B  30BB: 6a70             push 0x70
  06BA3D  30BD: 6a0a             push 0xa
  06BA3F  30BF: b83f00           mov ax, 0x3f
  06BA42  30C2: ba2800           mov dx, 0x28
  06BA45  30C5: bbc000           mov bx, 0xc0
  06BA48  30C8: 9aba001f18       lcall 0x181f, 0xba
  06BA4D  30CD: 6a00             push 0
  06BA4F  30CF: 684001           push 0x140
  06BA52  30D2: 68c800           push 0xc8
  06BA55  30D5: 2bc0             sub ax, ax
  06BA57  30D7: 99               cdq 
  06BA58  30D8: 2bdb             sub bx, bx
  06BA5A  30DA: 9ae2001f18       lcall 0x181f, 0xe2
  06BA5F  30DF: ffb63cfc         push word ptr [bp - 0x3c4]
  06BA63  30E3: ffb63afc         push word ptr [bp - 0x3c6]
  06BA67  30E7: e884fc           call 0x2d6e
  06BA6A  30EA: 83c404           add sp, 4
  06BA6D  30ED: 6a08             push 8
  06BA6F  30EF: 9aea031f18       lcall 0x181f, 0x3ea
  06BA74  30F4: 83c402           add sp, 2
  06BA77  30F7: 83be38fc00       cmp word ptr [bp - 0x3c8], 0
  06BA7C  30FC: 750e             jne 0x310c
  06BA7E  30FE: 9aa2041f19       lcall 0x191f, 0x4a2
  06BA83  3103: 9ac0031f18       lcall 0x181f, 0x3c0
  06BA88  3108: 0e               push cs
  06BA89  3109: e86000           call 0x316c
  06BA8C  310C: c7865cff0000     mov word ptr [bp - 0xa4], 0
  06BA92  3112: 83be38fc00       cmp word ptr [bp - 0x3c8], 0
  06BA97  3117: 751c             jne 0x3135
  06BA99  3119: 6800a0           push 0xa000
  06BA9C  311C: 6800fc           push 0xfc00
  06BA9F  311F: 9af4031f18       lcall 0x181f, 0x3f4
  06BAA4  3124: 8a268353         mov ah, byte ptr [0x5383]
  06BAA8  3128: 250001           and ax, 0x100
  06BAAB  312B: 3d0100           cmp ax, 1
  06BAAE  312E: 1bc0             sbb ax, ax
  06BAB0  3130: f7d8             neg ax
  06BAB2  3132: a37203           mov word ptr [0x372], ax
  06BAB5  3135: 2bc0             sub ax, ax
  06BAB7  3137: a3f423           mov word ptr [0x23f4], ax
  06BABA  313A: a3f223           mov word ptr [0x23f2], ax
  06BABD  313D: 8b8656fc         mov ax, word ptr [bp - 0x3aa]
  06BAC1  3141: 0b8654fc         or ax, word ptr [bp - 0x3ac]
  06BAC5  3145: 740d             je 0x3154
  06BAC7  3147: ffb656fc         push word ptr [bp - 0x3aa]
  06BACB  314B: ffb654fc         push word ptr [bp - 0x3ac]
  06BACF  314F: 9aa8011f19       lcall 0x191f, 0x1a8
  06BAD4  3154: 9aac0a1f19       lcall 0x191f, 0xaac
  06BAD9  3159: 83be38fc00       cmp word ptr [bp - 0x3c8], 0
  06BADE  315E: 7505             jne 0x3165
  06BAE0  3160: 9a6a051f18       lcall 0x181f, 0x56a
  06BAE5  3165: 8b865cff         mov ax, word ptr [bp - 0xa4]
  06BAE9  3169: 5e               pop si
  06BAEA  316A: c9               leave 
  06BAEB  316B: cb               retf 
  06BAEC  316C: ea5c0a1f1a       ljmp 0x1a1f:0xa5c
