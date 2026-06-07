; ============================================================
; VICEROY.EXE overlay page 0x0D (record 12) -- RE-SEGMENTED
; file_offset (disk image) = 0x04BA50
; code_offset (first insn) = 0x04C1F0
; code_end (next reloc hdr)= 0x053540  [resident size 1845 para -> nominal_end 0x052DA0; on-disk code spills past it]
; reloc_count = 477  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x04BA50)
; functions in page = 28
; ============================================================

; ---- func_04C1F0  size=27  insns=10  prologue=push bp;mov bp,sp  terminal=RETF ----
  04C1F0  07A0: 55               push bp
  04C1F1  07A1: 8bec             mov bp, sp
  04C1F3  07A3: 8b5e06           mov bx, word ptr [bp + 6]
  04C1F6  07A6: c1e306           shl bx, 6
  04C1F9  07A9: 035e08           add bx, word ptr [bp + 8]
  04C1FC  07AC: c1e302           shl bx, 2
  04C1FF  07AF: c687b298ff       mov byte ptr [bx - 0x674e], 0xff
  04C204  07B4: c687b39800       mov byte ptr [bx - 0x674d], 0
  04C209  07B9: c9               leave 
  04C20A  07BA: cb               retf 

; ---- func_04C20C  size=86  insns=31  prologue=ENTER 0x0004,0  terminal=RETF ----
  04C20C  07BC: c8040000         enter 4, 0
  04C210  07C0: 56               push si
  04C211  07C1: c746fc0000       mov word ptr [bp - 4], 0
  04C216  07C6: 8a4608           mov al, byte ptr [bp + 8]
  04C219  07C9: 8b5e06           mov bx, word ptr [bp + 6]
  04C21C  07CC: c1e304           shl bx, 4
  04C21F  07CF: 035efc           add bx, word ptr [bp - 4]
  04C222  07D2: c1e302           shl bx, 2
  04C225  07D5: 3887ac9e         cmp byte ptr [bx - 0x6154], al
  04C229  07D9: 752b             jne 0x806
  04C22B  07DB: 8a87ab9e         mov al, byte ptr [bx - 0x6155]
  04C22F  07DF: 98               cwde 
  04C230  07E0: 50               push ax
  04C231  07E1: 8a87aa9e         mov al, byte ptr [bx - 0x6156]
  04C235  07E5: 98               cwde 
  04C236  07E6: 50               push ax
  04C237  07E7: ff760c           push word ptr [bp + 0xc]
  04C23A  07EA: ff760a           push word ptr [bp + 0xa]
  04C23D  07ED: 8bf3             mov si, bx
  04C23F  07EF: 9a7a031f18       lcall 0x181f, 0x37a
  04C244  07F4: 83c408           add sp, 8
  04C247  07F7: 3b460e           cmp ax, word ptr [bp + 0xe]
  04C24A  07FA: 7f0a             jg 0x806
  04C24C  07FC: c684ac9eff       mov byte ptr [si - 0x6154], 0xff
  04C251  0801: c684ad9e00       mov byte ptr [si - 0x6153], 0
  04C256  0806: ff46fc           inc word ptr [bp - 4]
  04C259  0809: 837efc10         cmp word ptr [bp - 4], 0x10
  04C25D  080D: 7cb7             jl 0x7c6
  04C25F  080F: 5e               pop si
  04C260  0810: c9               leave 
  04C261  0811: cb               retf 

; ---- func_04C262  size=53  insns=18  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C262  0812: c8020000         enter 2, 0
  04C266  0816: c746fe3e00       mov word ptr [bp - 2], 0x3e
  04C26B  081B: eb20             jmp 0x83d
  04C26D  081D: 90               nop 
  04C26E  081E: 8b5e06           mov bx, word ptr [bp + 6]
  04C271  0821: c1e306           shl bx, 6
  04C274  0824: 035efe           add bx, word ptr [bp - 2]
  04C277  0827: c1e302           shl bx, 2
  04C27A  082A: 8b87b098         mov ax, word ptr [bx - 0x6750]
  04C27E  082E: 8b97b298         mov dx, word ptr [bx - 0x674e]
  04C282  0832: 8987b498         mov word ptr [bx - 0x674c], ax
  04C286  0836: 8997b698         mov word ptr [bx - 0x674a], dx
  04C28A  083A: ff4efe           dec word ptr [bp - 2]
  04C28D  083D: 8b4608           mov ax, word ptr [bp + 8]
  04C290  0840: 3946fe           cmp word ptr [bp - 2], ax
  04C293  0843: 7dd9             jge 0x81e
  04C295  0845: c9               leave 
  04C296  0846: cb               retf 

; ---- func_04C298  size=53  insns=18  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C298  0848: c8020000         enter 2, 0
  04C29C  084C: c746fe0e00       mov word ptr [bp - 2], 0xe
  04C2A1  0851: eb20             jmp 0x873
  04C2A3  0853: 90               nop 
  04C2A4  0854: 8b5e06           mov bx, word ptr [bp + 6]
  04C2A7  0857: c1e304           shl bx, 4
  04C2AA  085A: 035efe           add bx, word ptr [bp - 2]
  04C2AD  085D: c1e302           shl bx, 2
  04C2B0  0860: 8b87aa9e         mov ax, word ptr [bx - 0x6156]
  04C2B4  0864: 8b97ac9e         mov dx, word ptr [bx - 0x6154]
  04C2B8  0868: 8987ae9e         mov word ptr [bx - 0x6152], ax
  04C2BC  086C: 8997b09e         mov word ptr [bx - 0x6150], dx
  04C2C0  0870: ff4efe           dec word ptr [bp - 2]
  04C2C3  0873: 8b4608           mov ax, word ptr [bp + 8]
  04C2C6  0876: 3946fe           cmp word ptr [bp - 2], ax
  04C2C9  0879: 7dd9             jge 0x854
  04C2CB  087B: c9               leave 
  04C2CC  087C: cb               retf 

; ---- func_04C2CE  size=55  insns=26  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C2CE  087E: c8020000         enter 2, 0
  04C2D2  0882: 57               push di
  04C2D3  0883: 56               push si
  04C2D4  0884: c746fe0e00       mov word ptr [bp - 2], 0xe
  04C2D9  0889: eb1e             jmp 0x8a9
  04C2DB  088B: 90               nop 
  04C2DC  088C: 8b5efe           mov bx, word ptr [bp - 2]
  04C2DF  088F: 8bc3             mov ax, bx
  04C2E1  0891: d1e3             shl bx, 1
  04C2E3  0893: 03d8             add bx, ax
  04C2E5  0895: d1e3             shl bx, 1
  04C2E7  0897: 8dbfe2a0         lea di, [bx - 0x5f1e]
  04C2EB  089B: 8db7dca0         lea si, [bx - 0x5f24]
  04C2EF  089F: 8cd8             mov ax, ds
  04C2F1  08A1: 8ec0             mov es, ax
  04C2F3  08A3: a5               movsw word ptr es:[di], word ptr [si]
  04C2F4  08A4: a5               movsw word ptr es:[di], word ptr [si]
  04C2F5  08A5: a5               movsw word ptr es:[di], word ptr [si]
  04C2F6  08A6: ff4efe           dec word ptr [bp - 2]
  04C2F9  08A9: 8b4606           mov ax, word ptr [bp + 6]
  04C2FC  08AC: 3946fe           cmp word ptr [bp - 2], ax
  04C2FF  08AF: 7ddb             jge 0x88c
  04C301  08B1: 5e               pop si
  04C302  08B2: 5f               pop di
  04C303  08B3: c9               leave 
  04C304  08B4: cb               retf 

; ---- func_04C306  size=84  insns=30  prologue=ENTER 0x0004,0  terminal=RETF ----
  04C306  08B6: c8040000         enter 4, 0
  04C30A  08BA: 2bc0             sub ax, ax
  04C30C  08BC: 8946fe           mov word ptr [bp - 2], ax
  04C30F  08BF: 8946fc           mov word ptr [bp - 4], ax
  04C312  08C2: eb3b             jmp 0x8ff
  04C314  08C4: 8a4608           mov al, byte ptr [bp + 8]
  04C317  08C7: 8b5e06           mov bx, word ptr [bp + 6]
  04C31A  08CA: c1e306           shl bx, 6
  04C31D  08CD: 035efc           add bx, word ptr [bp - 4]
  04C320  08D0: c1e302           shl bx, 2
  04C323  08D3: 3887b098         cmp byte ptr [bx - 0x6750], al
  04C327  08D7: 7523             jne 0x8fc
  04C329  08D9: 8a460a           mov al, byte ptr [bp + 0xa]
  04C32C  08DC: 3887b198         cmp byte ptr [bx - 0x674f], al
  04C330  08E0: 751a             jne 0x8fc
  04C332  08E2: 8a460c           mov al, byte ptr [bp + 0xc]
  04C335  08E5: 3887b298         cmp byte ptr [bx - 0x674e], al
  04C339  08E9: 7511             jne 0x8fc
  04C33B  08EB: 8a46fe           mov al, byte ptr [bp - 2]
  04C33E  08EE: 3887b398         cmp byte ptr [bx - 0x674d], al
  04C342  08F2: 7c08             jl 0x8fc
  04C344  08F4: 8a87b398         mov al, byte ptr [bx - 0x674d]
  04C348  08F8: 98               cwde 
  04C349  08F9: 8946fe           mov word ptr [bp - 2], ax
  04C34C  08FC: ff46fc           inc word ptr [bp - 4]
  04C34F  08FF: 837efc40         cmp word ptr [bp - 4], 0x40
  04C353  0903: 7cbf             jl 0x8c4
  04C355  0905: 8b46fe           mov ax, word ptr [bp - 2]
  04C358  0908: c9               leave 
  04C359  0909: cb               retf 

; ---- func_04C35A  size=169  insns=59  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C35A  090A: c8020000         enter 2, 0
  04C35E  090E: c746fe0000       mov word ptr [bp - 2], 0
  04C363  0913: eb04             jmp 0x919
  04C365  0915: 90               nop 
  04C366  0916: ff46fe           inc word ptr [bp - 2]
  04C369  0919: 837efe40         cmp word ptr [bp - 2], 0x40
  04C36D  091D: 7d33             jge 0x952
  04C36F  091F: 8a4608           mov al, byte ptr [bp + 8]
  04C372  0922: 8b5e06           mov bx, word ptr [bp + 6]
  04C375  0925: c1e306           shl bx, 6
  04C378  0928: 035efe           add bx, word ptr [bp - 2]
  04C37B  092B: c1e302           shl bx, 2
  04C37E  092E: 3887b098         cmp byte ptr [bx - 0x6750], al
  04C382  0932: 75e2             jne 0x916
  04C384  0934: 8a460a           mov al, byte ptr [bp + 0xa]
  04C387  0937: 3887b198         cmp byte ptr [bx - 0x674f], al
  04C38B  093B: 75d9             jne 0x916
  04C38D  093D: 8a460c           mov al, byte ptr [bp + 0xc]
  04C390  0940: 3887b298         cmp byte ptr [bx - 0x674e], al
  04C394  0944: 75d0             jne 0x916
  04C396  0946: 8a460e           mov al, byte ptr [bp + 0xe]
  04C399  0949: 3887b398         cmp byte ptr [bx - 0x674d], al
  04C39D  094D: 7cc7             jl 0x916
  04C39F  094F: c9               leave 
  04C3A0  0950: cb               retf 
  04C3A1  0951: 90               nop 
  04C3A2  0952: c746fe0000       mov word ptr [bp - 2], 0
  04C3A7  0957: eb04             jmp 0x95d
  04C3A9  0959: 90               nop 
  04C3AA  095A: ff46fe           inc word ptr [bp - 2]
  04C3AD  095D: 837efe40         cmp word ptr [bp - 2], 0x40
  04C3B1  0961: 7d4e             jge 0x9b1
  04C3B3  0963: 8a460e           mov al, byte ptr [bp + 0xe]
  04C3B6  0966: 8b5e06           mov bx, word ptr [bp + 6]
  04C3B9  0969: c1e306           shl bx, 6
  04C3BC  096C: 035efe           add bx, word ptr [bp - 2]
  04C3BF  096F: c1e302           shl bx, 2
  04C3C2  0972: 3887b398         cmp byte ptr [bx - 0x674d], al
  04C3C6  0976: 7c07             jl 0x97f
  04C3C8  0978: 80bfb298ff       cmp byte ptr [bx - 0x674e], 0xff
  04C3CD  097D: 75db             jne 0x95a
  04C3CF  097F: ff76fe           push word ptr [bp - 2]
  04C3D2  0982: ff7606           push word ptr [bp + 6]
  04C3D5  0985: 0e               push cs
  04C3D6  0986: e81a71           call 0x7aa3
  04C3D9  0989: 8a4608           mov al, byte ptr [bp + 8]
  04C3DC  098C: 8b5e06           mov bx, word ptr [bp + 6]
  04C3DF  098F: c1e306           shl bx, 6
  04C3E2  0992: 035efe           add bx, word ptr [bp - 2]
  04C3E5  0995: c1e302           shl bx, 2
  04C3E8  0998: 8887b098         mov byte ptr [bx - 0x6750], al
  04C3EC  099C: 8a460a           mov al, byte ptr [bp + 0xa]
  04C3EF  099F: 8887b198         mov byte ptr [bx - 0x674f], al
  04C3F3  09A3: 8a460c           mov al, byte ptr [bp + 0xc]
  04C3F6  09A6: 8887b298         mov byte ptr [bx - 0x674e], al
  04C3FA  09AA: 8a460e           mov al, byte ptr [bp + 0xe]
  04C3FD  09AD: 8887b398         mov byte ptr [bx - 0x674d], al
  04C401  09B1: c9               leave 
  04C402  09B2: cb               retf 

; ---- func_04C404  size=169  insns=59  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C404  09B4: c8020000         enter 2, 0
  04C408  09B8: c746fe0000       mov word ptr [bp - 2], 0
  04C40D  09BD: eb04             jmp 0x9c3
  04C40F  09BF: 90               nop 
  04C410  09C0: ff46fe           inc word ptr [bp - 2]
  04C413  09C3: 837efe10         cmp word ptr [bp - 2], 0x10
  04C417  09C7: 7d33             jge 0x9fc
  04C419  09C9: 8a4608           mov al, byte ptr [bp + 8]
  04C41C  09CC: 8b5e06           mov bx, word ptr [bp + 6]
  04C41F  09CF: c1e304           shl bx, 4
  04C422  09D2: 035efe           add bx, word ptr [bp - 2]
  04C425  09D5: c1e302           shl bx, 2
  04C428  09D8: 3887aa9e         cmp byte ptr [bx - 0x6156], al
  04C42C  09DC: 75e2             jne 0x9c0
  04C42E  09DE: 8a460a           mov al, byte ptr [bp + 0xa]
  04C431  09E1: 3887ab9e         cmp byte ptr [bx - 0x6155], al
  04C435  09E5: 75d9             jne 0x9c0
  04C437  09E7: 8a460c           mov al, byte ptr [bp + 0xc]
  04C43A  09EA: 3887ac9e         cmp byte ptr [bx - 0x6154], al
  04C43E  09EE: 75d0             jne 0x9c0
  04C440  09F0: 8a460e           mov al, byte ptr [bp + 0xe]
  04C443  09F3: 3887ad9e         cmp byte ptr [bx - 0x6153], al
  04C447  09F7: 7cc7             jl 0x9c0
  04C449  09F9: c9               leave 
  04C44A  09FA: cb               retf 
  04C44B  09FB: 90               nop 
  04C44C  09FC: c746fe0000       mov word ptr [bp - 2], 0
  04C451  0A01: eb04             jmp 0xa07
  04C453  0A03: 90               nop 
  04C454  0A04: ff46fe           inc word ptr [bp - 2]
  04C457  0A07: 837efe10         cmp word ptr [bp - 2], 0x10
  04C45B  0A0B: 7d4e             jge 0xa5b
  04C45D  0A0D: 8a460e           mov al, byte ptr [bp + 0xe]
  04C460  0A10: 8b5e06           mov bx, word ptr [bp + 6]
  04C463  0A13: c1e304           shl bx, 4
  04C466  0A16: 035efe           add bx, word ptr [bp - 2]
  04C469  0A19: c1e302           shl bx, 2
  04C46C  0A1C: 3887ad9e         cmp byte ptr [bx - 0x6153], al
  04C470  0A20: 7c07             jl 0xa29
  04C472  0A22: 80bfac9eff       cmp byte ptr [bx - 0x6154], 0xff
  04C477  0A27: 75db             jne 0xa04
  04C479  0A29: ff76fe           push word ptr [bp - 2]
  04C47C  0A2C: ff7606           push word ptr [bp + 6]
  04C47F  0A2F: 0e               push cs
  04C480  0A30: e88470           call 0x7ab7
  04C483  0A33: 8a4608           mov al, byte ptr [bp + 8]
  04C486  0A36: 8b5e06           mov bx, word ptr [bp + 6]
  04C489  0A39: c1e304           shl bx, 4
  04C48C  0A3C: 035efe           add bx, word ptr [bp - 2]
  04C48F  0A3F: c1e302           shl bx, 2
  04C492  0A42: 8887aa9e         mov byte ptr [bx - 0x6156], al
  04C496  0A46: 8a460a           mov al, byte ptr [bp + 0xa]
  04C499  0A49: 8887ab9e         mov byte ptr [bx - 0x6155], al
  04C49D  0A4D: 8a460c           mov al, byte ptr [bp + 0xc]
  04C4A0  0A50: 8887ac9e         mov byte ptr [bx - 0x6154], al
  04C4A4  0A54: 8a460e           mov al, byte ptr [bp + 0xe]
  04C4A7  0A57: 8887ad9e         mov byte ptr [bx - 0x6153], al
  04C4AB  0A5B: c9               leave 
  04C4AC  0A5C: cb               retf 

; ---- func_04C4AE  size=94  insns=35  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C4AE  0A5E: c8020000         enter 2, 0
  04C4B2  0A62: c746fe0000       mov word ptr [bp - 2], 0
  04C4B7  0A67: eb04             jmp 0xa6d
  04C4B9  0A69: 90               nop 
  04C4BA  0A6A: ff46fe           inc word ptr [bp - 2]
  04C4BD  0A6D: 837efe10         cmp word ptr [bp - 2], 0x10
  04C4C1  0A71: 7d47             jge 0xaba
  04C4C3  0A73: 8b4608           mov ax, word ptr [bp + 8]
  04C4C6  0A76: 8b5efe           mov bx, word ptr [bp - 2]
  04C4C9  0A79: 8bcb             mov cx, bx
  04C4CB  0A7B: d1e3             shl bx, 1
  04C4CD  0A7D: 03d9             add bx, cx
  04C4CF  0A7F: d1e3             shl bx, 1
  04C4D1  0A81: 3987dea0         cmp word ptr [bx - 0x5f22], ax
  04C4D5  0A85: 7c07             jl 0xa8e
  04C4D7  0A87: 83bfdca000       cmp word ptr [bx - 0x5f24], 0
  04C4DC  0A8C: 7ddc             jge 0xa6a
  04C4DE  0A8E: 51               push cx
  04C4DF  0A8F: 0e               push cs
  04C4E0  0A90: e83870           call 0x7acb
  04C4E3  0A93: 8b4606           mov ax, word ptr [bp + 6]
  04C4E6  0A96: 8b5efe           mov bx, word ptr [bp - 2]
  04C4E9  0A99: 8bcb             mov cx, bx
  04C4EB  0A9B: d1e3             shl bx, 1
  04C4ED  0A9D: 03d9             add bx, cx
  04C4EF  0A9F: d1e3             shl bx, 1
  04C4F1  0AA1: 8987dca0         mov word ptr [bx - 0x5f24], ax
  04C4F5  0AA5: 8b4608           mov ax, word ptr [bp + 8]
  04C4F8  0AA8: 8987dea0         mov word ptr [bx - 0x5f22], ax
  04C4FC  0AAC: 8a460a           mov al, byte ptr [bp + 0xa]
  04C4FF  0AAF: 8887e0a0         mov byte ptr [bx - 0x5f20], al
  04C503  0AB3: 8a460c           mov al, byte ptr [bp + 0xc]
  04C506  0AB6: 8887e1a0         mov byte ptr [bx - 0x5f1f], al
  04C50A  0ABA: c9               leave 
  04C50B  0ABB: cb               retf 

; ---- func_04C50C  size=37  insns=13  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C50C  0ABC: c8020000         enter 2, 0
  04C510  0AC0: c746fe0000       mov word ptr [bp - 2], 0
  04C515  0AC5: 8b5efe           mov bx, word ptr [bp - 2]
  04C518  0AC8: 8bc3             mov ax, bx
  04C51A  0ACA: d1e3             shl bx, 1
  04C51C  0ACC: 03d8             add bx, ax
  04C51E  0ACE: d1e3             shl bx, 1
  04C520  0AD0: c787dca0ffff     mov word ptr [bx - 0x5f24], 0xffff
  04C526  0AD6: ff46fe           inc word ptr [bp - 2]
  04C529  0AD9: 837efe10         cmp word ptr [bp - 2], 0x10
  04C52D  0ADD: 7ce6             jl 0xac5
  04C52F  0ADF: c9               leave 
  04C530  0AE0: cb               retf 

; ---- func_04C532  size=100  insns=38  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C532  0AE2: c8020000         enter 2, 0
  04C536  0AE6: c746fe0000       mov word ptr [bp - 2], 0
  04C53B  0AEB: ff76fe           push word ptr [bp - 2]
  04C53E  0AEE: ff7606           push word ptr [bp + 6]
  04C541  0AF1: 0e               push cs
  04C542  0AF2: e8906f           call 0x7a85
  04C545  0AF5: 83c404           add sp, 4
  04C548  0AF8: ff46fe           inc word ptr [bp - 2]
  04C54B  0AFB: 837efe40         cmp word ptr [bp - 2], 0x40
  04C54F  0AFF: 7cea             jl 0xaeb
  04C551  0B01: c746fe0000       mov word ptr [bp - 2], 0
  04C556  0B06: 8b5e06           mov bx, word ptr [bp + 6]
  04C559  0B09: c1e304           shl bx, 4
  04C55C  0B0C: 035efe           add bx, word ptr [bp - 2]
  04C55F  0B0F: c1e302           shl bx, 2
  04C562  0B12: 80bfac9e00       cmp byte ptr [bx - 0x6154], 0
  04C567  0B17: 7c22             jl 0xb3b
  04C569  0B19: 8a87ad9e         mov al, byte ptr [bx - 0x6153]
  04C56D  0B1D: 98               cwde 
  04C56E  0B1E: 50               push ax
  04C56F  0B1F: 8a87ac9e         mov al, byte ptr [bx - 0x6154]
  04C573  0B23: 98               cwde 
  04C574  0B24: 50               push ax
  04C575  0B25: 8a87ab9e         mov al, byte ptr [bx - 0x6155]
  04C579  0B29: 98               cwde 
  04C57A  0B2A: 50               push ax
  04C57B  0B2B: 8a87aa9e         mov al, byte ptr [bx - 0x6156]
  04C57F  0B2F: 98               cwde 
  04C580  0B30: 50               push ax
  04C581  0B31: ff7606           push word ptr [bp + 6]
  04C584  0B34: 0e               push cs
  04C585  0B35: e8396f           call 0x7a71
  04C588  0B38: 83c40a           add sp, 0xa
  04C58B  0B3B: ff46fe           inc word ptr [bp - 2]
  04C58E  0B3E: 837efe10         cmp word ptr [bp - 2], 0x10
  04C592  0B42: 7cc2             jl 0xb06
  04C594  0B44: c9               leave 
  04C595  0B45: cb               retf 

; ---- func_04C596  size=42  insns=13  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C596  0B46: c8020000         enter 2, 0
  04C59A  0B4A: c746fe0000       mov word ptr [bp - 2], 0
  04C59F  0B4F: 8b5e06           mov bx, word ptr [bp + 6]
  04C5A2  0B52: c1e304           shl bx, 4
  04C5A5  0B55: 035efe           add bx, word ptr [bp - 2]
  04C5A8  0B58: c1e302           shl bx, 2
  04C5AB  0B5B: c687ac9eff       mov byte ptr [bx - 0x6154], 0xff
  04C5B0  0B60: c687ad9e00       mov byte ptr [bx - 0x6153], 0
  04C5B5  0B65: ff46fe           inc word ptr [bp - 2]
  04C5B8  0B68: 837efe10         cmp word ptr [bp - 2], 0x10
  04C5BC  0B6C: 7ce1             jl 0xb4f
  04C5BE  0B6E: c9               leave 
  04C5BF  0B6F: cb               retf 

; ---- func_04C5C0  size=194  insns=79  prologue=ENTER 0x0010,0  terminal=RETF ----
  04C5C0  0B70: c8100000         enter 0x10, 0
  04C5C4  0B74: 8b5e06           mov bx, word ptr [bp + 6]
  04C5C7  0B77: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  04C5CB  0B7B: 2ae4             sub ah, ah
  04C5CD  0B7D: 8946f0           mov word ptr [bp - 0x10], ax
  04C5D0  0B80: 8a879892         mov al, byte ptr [bx - 0x6d68]
  04C5D4  0B84: 833e9e5330       cmp word ptr [0x539e], 0x30
  04C5D9  0B89: 7c03             jl 0xb8e
  04C5DB  0B8B: e9a000           jmp 0xc2e
  04C5DE  0B8E: 3d0100           cmp ax, 1
  04C5E1  0B91: 7d05             jge 0xb98
  04C5E3  0B93: b80800           mov ax, 8
  04C5E6  0B96: c9               leave 
  04C5E7  0B97: cb               retf 
  04C5E8  0B98: 80bfb8a000       cmp byte ptr [bx - 0x5f48], 0
  04C5ED  0B9D: 74f4             je 0xb93
  04C5EF  0B9F: 8946f8           mov word ptr [bp - 8], ax
  04C5F2  0BA2: 8bcb             mov cx, bx
  04C5F4  0BA4: d1e3             shl bx, 1
  04C5F6  0BA6: 03d9             add bx, cx
  04C5F8  0BA8: 8a876795         mov al, byte ptr [bx - 0x6a99]
  04C5FC  0BAC: 98               cwde 
  04C5FD  0BAD: b90400           mov cx, 4
  04C600  0BB0: 2bc8             sub cx, ax
  04C602  0BB2: 8b46f0           mov ax, word ptr [bp - 0x10]
  04C605  0BB5: 2b46f8           sub ax, word ptr [bp - 8]
  04C608  0BB8: 99               cdq 
  04C609  0BB9: f7f9             idiv cx
  04C60B  0BBB: 8946f2           mov word ptr [bp - 0xe], ax
  04C60E  0BBE: 8b5e06           mov bx, word ptr [bp + 6]
  04C611  0BC1: 8a8f1494         mov cl, byte ptr [bx - 0x6bec]
  04C615  0BC5: d0e9             shr cl, 1
  04C617  0BC7: 2aed             sub ch, ch
  04C619  0BC9: 3bc1             cmp ax, cx
  04C61B  0BCB: 7e0f             jle 0xbdc
  04C61D  0BCD: 2bc1             sub ax, cx
  04C61F  0BCF: 40               inc ax
  04C620  0BD0: d1f8             sar ax, 1
  04C622  0BD2: 2b46f2           sub ax, word ptr [bp - 0xe]
  04C625  0BD5: f7d8             neg ax
  04C627  0BD7: 8946f2           mov word ptr [bp - 0xe], ax
  04C62A  0BDA: eb0e             jmp 0xbea
  04C62C  0BDC: 3bc8             cmp cx, ax
  04C62E  0BDE: 7e0a             jle 0xbea
  04C630  0BE0: 2bc1             sub ax, cx
  04C632  0BE2: f7d8             neg ax
  04C634  0BE4: 40               inc ax
  04C635  0BE5: d1f8             sar ax, 1
  04C637  0BE7: 0146f2           add word ptr [bp - 0xe], ax
  04C63A  0BEA: 8b5e06           mov bx, word ptr [bp + 6]
  04C63D  0BED: 8bc3             mov ax, bx
  04C63F  0BEF: d1e3             shl bx, 1
  04C641  0BF1: 03d8             add bx, ax
  04C643  0BF3: 8a876795         mov al, byte ptr [bx - 0x6a99]
  04C647  0BF7: 98               cwde 
  04C648  0BF8: 8bc8             mov cx, ax
  04C64A  0BFA: d1e0             shl ax, 1
  04C64C  0BFC: 03c1             add ax, cx
  04C64E  0BFE: 2d0700           sub ax, 7
  04C651  0C01: f7d8             neg ax
  04C653  0C03: 8b5e06           mov bx, word ptr [bp + 6]
  04C656  0C06: d1e3             shl bx, 1
  04C658  0C08: 3b874e94         cmp ax, word ptr [bx - 0x6bb2]
  04C65C  0C0C: 7e19             jle 0xc27
  04C65E  0C0E: 2b874e94         sub ax, word ptr [bx - 0x6bb2]
  04C662  0C12: 8bc8             mov cx, ax
  04C664  0C14: b8ffff           mov ax, 0xffff
  04C667  0C17: 2bc1             sub ax, cx
  04C669  0C19: 8b5e06           mov bx, word ptr [bp + 6]
  04C66C  0C1C: 8a8f9892         mov cl, byte ptr [bx - 0x6d68]
  04C670  0C20: 2aed             sub ch, ch
  04C672  0C22: f7e9             imul cx
  04C674  0C24: 0146f2           add word ptr [bp - 0xe], ax
  04C677  0C27: 8b46f2           mov ax, word ptr [bp - 0xe]
  04C67A  0C2A: 0bc0             or ax, ax
  04C67C  0C2C: 7d02             jge 0xc30
  04C67E  0C2E: 2bc0             sub ax, ax
  04C680  0C30: c9               leave 
  04C681  0C31: cb               retf 

; ---- func_04C682  size=153  insns=55  prologue=ENTER 0x000A,0  terminal=RETF ----
  04C682  0C32: c80a0000         enter 0xa, 0
  04C686  0C36: 56               push si
  04C687  0C37: c746f60000       mov word ptr [bp - 0xa], 0
  04C68C  0C3C: 837e0800         cmp word ptr [bp + 8], 0
  04C690  0C40: 7d03             jge 0xc45
  04C692  0C42: e98000           jmp 0xcc5
  04C695  0C45: 8b5e08           mov bx, word ptr [bp + 8]
  04C698  0C48: d1e3             shl bx, 1
  04C69A  0C4A: 8b87c885         mov ax, word ptr [bx - 0x7a38]
  04C69E  0C4E: b90c00           mov cx, 0xc
  04C6A1  0C51: 99               cdq 
  04C6A2  0C52: f7f9             idiv cx
  04C6A4  0C54: 8946f8           mov word ptr [bp - 8], ax
  04C6A7  0C57: 8b5e08           mov bx, word ptr [bp + 8]
  04C6AA  0C5A: 8a877e94         mov al, byte ptr [bx - 0x6b82]
  04C6AE  0C5E: 2ae4             sub ah, ah
  04C6B0  0C60: 8946fa           mov word ptr [bp - 6], ax
  04C6B3  0C63: c746fc0000       mov word ptr [bp - 4], 0
  04C6B8  0C68: 8b76fc           mov si, word ptr [bp - 4]
  04C6BB  0C6B: c1e604           shl si, 4
  04C6BE  0C6E: 8a80e694         mov al, byte ptr [bx + si - 0x6b1a]
  04C6C2  0C72: 2ae4             sub ah, ah
  04C6C4  0C74: 0146fa           add word ptr [bp - 6], ax
  04C6C7  0C77: ff46fc           inc word ptr [bp - 4]
  04C6CA  0C7A: 837efc04         cmp word ptr [bp - 4], 4
  04C6CE  0C7E: 7ce8             jl 0xc68
  04C6D0  0C80: 8b46f8           mov ax, word ptr [bp - 8]
  04C6D3  0C83: 2b46fa           sub ax, word ptr [bp - 6]
  04C6D6  0C86: 0bc0             or ax, ax
  04C6D8  0C88: 7e06             jle 0xc90
  04C6DA  0C8A: b80100           mov ax, 1
  04C6DD  0C8D: eb10             jmp 0xc9f
  04C6DF  0C8F: 90               nop 
  04C6E0  0C90: 8b46f8           mov ax, word ptr [bp - 8]
  04C6E3  0C93: 2b46fa           sub ax, word ptr [bp - 6]
  04C6E6  0C96: 7804             js 0xc9c
  04C6E8  0C98: 2bc0             sub ax, ax
  04C6EA  0C9A: eb03             jmp 0xc9f
  04C6EC  0C9C: b8ffff           mov ax, 0xffff
  04C6EF  0C9F: 0146f6           add word ptr [bp - 0xa], ax
  04C6F2  0CA2: 8b5e08           mov bx, word ptr [bp + 8]
  04C6F5  0CA5: 8a877e94         mov al, byte ptr [bx - 0x6b82]
  04C6F9  0CA9: 2ae4             sub ah, ah
  04C6FB  0CAB: 3b46fa           cmp ax, word ptr [bp - 6]
  04C6FE  0CAE: 7504             jne 0xcb4
  04C700  0CB0: 8346f602         add word ptr [bp - 0xa], 2
  04C704  0CB4: 8b7606           mov si, word ptr [bp + 6]
  04C707  0CB7: c1e604           shl si, 4
  04C70A  0CBA: 80b8e69401       cmp byte ptr [bx + si - 0x6b1a], 1
  04C70F  0CBF: 7304             jae 0xcc5
  04C711  0CC1: 8346f604         add word ptr [bp - 0xa], 4
  04C715  0CC5: 8b46f6           mov ax, word ptr [bp - 0xa]
  04C718  0CC8: 5e               pop si
  04C719  0CC9: c9               leave 
  04C71A  0CCA: cb               retf 

; ---- func_04C71C  size=211  insns=70  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C71C  0CCC: c8020000         enter 2, 0
  04C720  0CD0: c746fe0000       mov word ptr [bp - 2], 0
  04C725  0CD5: 8b5e06           mov bx, word ptr [bp + 6]
  04C728  0CD8: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  04C72D  0CDD: 7434             je 0xd13
  04C72F  0CDF: ff760a           push word ptr [bp + 0xa]
  04C732  0CE2: 53               push bx
  04C733  0CE3: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  04C737  0CE7: 8a874531         mov al, byte ptr [bx + 0x3145]
  04C73B  0CEB: 2ae4             sub ah, ah
  04C73D  0CED: 50               push ax
  04C73E  0CEE: 8a874431         mov al, byte ptr [bx + 0x3144]
  04C742  0CF2: 50               push ax
  04C743  0CF3: 9a14061f18       lcall 0x181f, 0x614
  04C748  0CF8: 83c408           add sp, 8
  04C74B  0CFB: 0bc0             or ax, ax
  04C74D  0CFD: 7c0f             jl 0xd0e
  04C74F  0CFF: a1b88d           mov ax, word ptr [0x8db8]
  04C752  0D02: b90500           mov cx, 5
  04C755  0D05: 99               cdq 
  04C756  0D06: f7f9             idiv cx
  04C758  0D08: 48               dec ax
  04C759  0D09: 8946fe           mov word ptr [bp - 2], ax
  04C75C  0D0C: eb05             jmp 0xd13
  04C75E  0D0E: c746fe0200       mov word ptr [bp - 2], 2
  04C763  0D13: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  04C767  0D17: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  04C76C  0D1C: 7504             jne 0xd22
  04C76E  0D1E: 8346fe02         add word ptr [bp - 2], 2
  04C772  0D22: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  04C776  0D26: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  04C77B  0D2B: 7504             jne 0xd31
  04C77D  0D2D: 836efe02         sub word ptr [bp - 2], 2
  04C781  0D31: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  04C785  0D35: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  04C78A  0D3A: 7504             jne 0xd40
  04C78C  0D3C: 836efe03         sub word ptr [bp - 2], 3
  04C790  0D40: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  04C794  0D44: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  04C799  0D49: 7529             jne 0xd74
  04C79B  0D4B: 836efe02         sub word ptr [bp - 2], 2
  04C79F  0D4F: 8a875b31         mov al, byte ptr [bx + 0x315b]
  04C7A3  0D53: 98               cwde 
  04C7A4  0D54: 50               push ax
  04C7A5  0D55: 9a9a0c1f18       lcall 0x181f, 0xc9a
  04C7AA  0D5A: 83c402           add sp, 2
  04C7AD  0D5D: 0bc0             or ax, ax
  04C7AF  0D5F: 7404             je 0xd65
  04C7B1  0D61: 836efe02         sub word ptr [bp - 2], 2
  04C7B5  0D65: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  04C7B9  0D69: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  04C7BE  0D6E: 7504             jne 0xd74
  04C7C0  0D70: 836efe14         sub word ptr [bp - 2], 0x14
  04C7C4  0D74: ff7606           push word ptr [bp + 6]
  04C7C7  0D77: 0e               push cs
  04C7C8  0D78: e8056d           call 0x7a80
  04C7CB  0D7B: 83c402           add sp, 2
  04C7CE  0D7E: 0bc0             or ax, ax
  04C7D0  0D80: 7412             je 0xd94
  04C7D2  0D82: a18e53           mov ax, word ptr [0x538e]
  04C7D5  0D85: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  04C7DA  0D8A: 2b874e88         sub ax, word ptr [bx - 0x77b2]
  04C7DE  0D8E: c1f804           sar ax, 4
  04C7E1  0D91: 0146fe           add word ptr [bp - 2], ax
  04C7E4  0D94: 8b46fe           mov ax, word ptr [bp - 2]
  04C7E7  0D97: 0bc0             or ax, ax
  04C7E9  0D99: 7e02             jle 0xd9d
  04C7EB  0D9B: 2bc0             sub ax, ax
  04C7ED  0D9D: c9               leave 
  04C7EE  0D9E: cb               retf 

; ---- func_04C7F0  size=86  insns=37  prologue=ENTER 0x0004,0  terminal=RETF ----
  04C7F0  0DA0: c8040000         enter 4, 0
  04C7F4  0DA4: 57               push di
  04C7F5  0DA5: 56               push si
  04C7F6  0DA6: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  04C7FA  0DAA: 8a874531         mov al, byte ptr [bx + 0x3145]
  04C7FE  0DAE: 2ae4             sub ah, ah
  04C800  0DB0: 50               push ax
  04C801  0DB1: 8a874431         mov al, byte ptr [bx + 0x3144]
  04C805  0DB5: 50               push ax
  04C806  0DB6: 9a22071f18       lcall 0x181f, 0x722
  04C80B  0DBB: 83c404           add sp, 4
  04C80E  0DBE: 8946fc           mov word ptr [bp - 4], ax
  04C811  0DC1: 50               push ax
  04C812  0DC2: ff7608           push word ptr [bp + 8]
  04C815  0DC5: ff7606           push word ptr [bp + 6]
  04C818  0DC8: 0e               push cs
  04C819  0DC9: e8fa6c           call 0x7ac6
  04C81C  0DCC: 83c406           add sp, 6
  04C81F  0DCF: ff76fc           push word ptr [bp - 4]
  04C822  0DD2: ff7606           push word ptr [bp + 6]
  04C825  0DD5: 8bf0             mov si, ax
  04C827  0DD7: 0e               push cs
  04C828  0DD8: e8be6c           call 0x7a99
  04C82B  0DDB: 83c404           add sp, 4
  04C82E  0DDE: ff7606           push word ptr [bp + 6]
  04C831  0DE1: 8bf8             mov di, ax
  04C833  0DE3: 0e               push cs
  04C834  0DE4: e8996c           call 0x7a80
  04C837  0DE7: 83c402           add sp, 2
  04C83A  0DEA: 03f7             add si, di
  04C83C  0DEC: 03c6             add ax, si
  04C83E  0DEE: 7902             jns 0xdf2
  04C840  0DF0: 2bc0             sub ax, ax
  04C842  0DF2: 5e               pop si
  04C843  0DF3: 5f               pop di
  04C844  0DF4: c9               leave 
  04C845  0DF5: cb               retf 

; ---- func_04C846  size=87  insns=31  prologue=ENTER 0x0002,0  terminal=RETF ----
  04C846  0DF6: c8020000         enter 2, 0
  04C84A  0DFA: c746feffff       mov word ptr [bp - 2], 0xffff
  04C84F  0DFF: eb41             jmp 0xe42
  04C851  0E01: 90               nop 
  04C852  0E02: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04C856  0E06: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04C85A  0E0A: 8bc3             mov ax, bx
  04C85C  0E0C: 2aff             sub bh, bh
  04C85E  0E0E: 8bcb             mov cx, bx
  04C860  0E10: d1e3             shl bx, 1
  04C862  0E12: 03d9             add bx, cx
  04C864  0E14: d1e3             shl bx, 1
  04C866  0E16: 03d9             add bx, cx
  04C868  0E18: d1e3             shl bx, 1
  04C86A  0E1A: f6873d5240       test byte ptr [bx + 0x523d], 0x40
  04C86F  0E1F: 7416             je 0xe37
  04C871  0E21: 837efe00         cmp word ptr [bp - 2], 0
  04C875  0E25: 7c0a             jl 0xe31
  04C877  0E27: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  04C87B  0E2B: 38874631         cmp byte ptr [bx + 0x3146], al
  04C87F  0E2F: 7306             jae 0xe37
  04C881  0E31: 8b4606           mov ax, word ptr [bp + 6]
  04C884  0E34: 8946fe           mov word ptr [bp - 2], ax
  04C887  0E37: 8b4606           mov ax, word ptr [bp + 6]
  04C88A  0E3A: 9ae4021f18       lcall 0x181f, 0x2e4
  04C88F  0E3F: 894606           mov word ptr [bp + 6], ax
  04C892  0E42: 837e0600         cmp word ptr [bp + 6], 0
  04C896  0E46: 7dba             jge 0xe02
  04C898  0E48: 8b46fe           mov ax, word ptr [bp - 2]
  04C89B  0E4B: c9               leave 
  04C89C  0E4C: cb               retf 

; ---- func_04C89E  size=488  insns=170  prologue=ENTER 0x0018,0  terminal=RETF ----
  04C89E  0E4E: c8180000         enter 0x18, 0
  04C8A2  0E52: 56               push si
  04C8A3  0E53: c746e8ffff       mov word ptr [bp - 0x18], 0xffff
  04C8A8  0E58: c746f20800       mov word ptr [bp - 0xe], 8
  04C8AD  0E5D: c746f60000       mov word ptr [bp - 0xa], 0
  04C8B2  0E62: e98f01           jmp 0xff4
  04C8B5  0E65: 90               nop 
  04C8B6  0E66: ff76fa           push word ptr [bp - 6]
  04C8B9  0E69: ff76fc           push word ptr [bp - 4]
  04C8BC  0E6C: 9abe061f18       lcall 0x181f, 0x6be
  04C8C1  0E71: 83c404           add sp, 4
  04C8C4  0E74: 0bc0             or ax, ax
  04C8C6  0E76: 7d40             jge 0xeb8
  04C8C8  0E78: 8b46f0           mov ax, word ptr [bp - 0x10]
  04C8CB  0E7B: 394606           cmp word ptr [bp + 6], ax
  04C8CE  0E7E: 7538             jne 0xeb8
  04C8D0  0E80: 6a02             push 2
  04C8D2  0E82: 8b46fc           mov ax, word ptr [bp - 4]
  04C8D5  0E85: 8b56fa           mov dx, word ptr [bp - 6]
  04C8D8  0E88: 9ae0071f18       lcall 0x181f, 0x7e0
  04C8DD  0E8D: 8946ec           mov word ptr [bp - 0x14], ax
  04C8E0  0E90: 50               push ax
  04C8E1  0E91: 9abc081f18       lcall 0x181f, 0x8bc
  04C8E6  0E96: 83c404           add sp, 4
  04C8E9  0E99: 48               dec ax
  04C8EA  0E9A: 751c             jne 0xeb8
  04C8EC  0E9C: 6b5eec1c         imul bx, word ptr [bp - 0x14], 0x1c
  04C8F0  0EA0: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  04C8F5  0EA5: 7505             jne 0xeac
  04C8F7  0EA7: b80100           mov ax, 1
  04C8FA  0EAA: eb02             jmp 0xeae
  04C8FC  0EAC: 2bc0             sub ax, ax
  04C8FE  0EAE: 3b460e           cmp ax, word ptr [bp + 0xe]
  04C901  0EB1: 7405             je 0xeb8
  04C903  0EB3: c746fe0100       mov word ptr [bp - 2], 1
  04C908  0EB8: ff76fa           push word ptr [bp - 6]
  04C90B  0EBB: ff76fc           push word ptr [bp - 4]
  04C90E  0EBE: 9a02031f18       lcall 0x181f, 0x302
  04C913  0EC3: 83c404           add sp, 4
  04C916  0EC6: 0bc0             or ax, ax
  04C918  0EC8: 7503             jne 0xecd
  04C91A  0ECA: e92401           jmp 0xff1
  04C91D  0ECD: ff76fa           push word ptr [bp - 6]
  04C920  0ED0: ff76fc           push word ptr [bp - 4]
  04C923  0ED3: 9a68071f18       lcall 0x181f, 0x768
  04C928  0ED8: 83c404           add sp, 4
  04C92B  0EDB: 0bc0             or ax, ax
  04C92D  0EDD: 7403             je 0xee2
  04C92F  0EDF: e90f01           jmp 0xff1
  04C932  0EE2: 837ef608         cmp word ptr [bp - 0xa], 8
  04C936  0EE6: 7408             je 0xef0
  04C938  0EE8: 3946fe           cmp word ptr [bp - 2], ax
  04C93B  0EEB: 7503             jne 0xef0
  04C93D  0EED: e90101           jmp 0xff1
  04C940  0EF0: ff76fa           push word ptr [bp - 6]
  04C943  0EF3: ff76fc           push word ptr [bp - 4]
  04C946  0EF6: 9a8c071f18       lcall 0x181f, 0x78c
  04C94B  0EFB: 83c404           add sp, 4
  04C94E  0EFE: 8bd8             mov bx, ax
  04C950  0F00: c1e304           shl bx, 4
  04C953  0F03: 8a87772f         mov al, byte ptr [bx + 0x2f77]
  04C957  0F07: 2ae4             sub ah, ah
  04C959  0F09: 8946f8           mov word ptr [bp - 8], ax
  04C95C  0F0C: c746f40000       mov word ptr [bp - 0xc], 0
  04C961  0F11: 8b5ef4           mov bx, word ptr [bp - 0xc]
  04C964  0F14: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04C968  0F18: 98               cwde 
  04C969  0F19: 0346fa           add ax, word ptr [bp - 6]
  04C96C  0F1C: 8946ea           mov word ptr [bp - 0x16], ax
  04C96F  0F1F: 50               push ax
  04C970  0F20: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04C974  0F24: 98               cwde 
  04C975  0F25: 0346fc           add ax, word ptr [bp - 4]
  04C978  0F28: 8946ee           mov word ptr [bp - 0x12], ax
  04C97B  0F2B: 50               push ax
  04C97C  0F2C: 9a02031f18       lcall 0x181f, 0x302
  04C981  0F31: 83c404           add sp, 4
  04C984  0F34: 0bc0             or ax, ax
  04C986  0F36: 7503             jne 0xf3b
  04C988  0F38: e99900           jmp 0xfd4
  04C98B  0F3B: ff76ea           push word ptr [bp - 0x16]
  04C98E  0F3E: ff76ee           push word ptr [bp - 0x12]
  04C991  0F41: 9a68071f18       lcall 0x181f, 0x768
  04C996  0F46: 83c404           add sp, 4
  04C999  0F49: 0bc0             or ax, ax
  04C99B  0F4B: 7403             je 0xf50
  04C99D  0F4D: e98400           jmp 0xfd4
  04C9A0  0F50: ff76ea           push word ptr [bp - 0x16]
  04C9A3  0F53: ff76ee           push word ptr [bp - 0x12]
  04C9A6  0F56: 9a82061f18       lcall 0x181f, 0x682
  04C9AB  0F5B: 83c404           add sp, 4
  04C9AE  0F5E: 8946f0           mov word ptr [bp - 0x10], ax
  04C9B1  0F61: 0bc0             or ax, ax
  04C9B3  0F63: 7d6f             jge 0xfd4
  04C9B5  0F65: ff76ea           push word ptr [bp - 0x16]
  04C9B8  0F68: ff76ee           push word ptr [bp - 0x12]
  04C9BB  0F6B: 9adc061f18       lcall 0x181f, 0x6dc
  04C9C0  0F70: 83c404           add sp, 4
  04C9C3  0F73: 98               cwde 
  04C9C4  0F74: 8946f0           mov word ptr [bp - 0x10], ax
  04C9C7  0F77: 0bc0             or ax, ax
  04C9C9  0F79: 7c1f             jl 0xf9a
  04C9CB  0F7B: 3d0400           cmp ax, 4
  04C9CE  0F7E: 7d1a             jge 0xf9a
  04C9D0  0F80: 6bd834           imul bx, ax, 0x34
  04C9D3  0F83: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04C9D8  0F88: 7510             jne 0xf9a
  04C9DA  0F8A: 50               push ax
  04C9DB  0F8B: ff7606           push word ptr [bp + 6]
  04C9DE  0F8E: 9a380a1f18       lcall 0x181f, 0xa38
  04C9E3  0F93: 83c404           add sp, 4
  04C9E6  0F96: a840             test al, 0x40
  04C9E8  0F98: 753a             jne 0xfd4
  04C9EA  0F9A: 837e0c00         cmp word ptr [bp + 0xc], 0
  04C9EE  0F9E: 7434             je 0xfd4
  04C9F0  0FA0: ff76fa           push word ptr [bp - 6]
  04C9F3  0FA3: ff76fc           push word ptr [bp - 4]
  04C9F6  0FA6: 9a22071f18       lcall 0x181f, 0x722
  04C9FB  0FAB: 83c404           add sp, 4
  04C9FE  0FAE: 50               push ax
  04C9FF  0FAF: ff7606           push word ptr [bp + 6]
  04CA02  0FB2: 0e               push cs
  04CA03  0FB3: e8e36a           call 0x7a99
  04CA06  0FB6: 83c404           add sp, 4
  04CA09  0FB9: c1e004           shl ax, 4
  04CA0C  0FBC: ff76ea           push word ptr [bp - 0x16]
  04CA0F  0FBF: ff76ee           push word ptr [bp - 0x12]
  04CA12  0FC2: 8bf0             mov si, ax
  04CA14  0FC4: 9a4a071f18       lcall 0x181f, 0x74a
  04CA19  0FC9: 83c404           add sp, 4
  04CA1C  0FCC: 250f00           and ax, 0xf
  04CA1F  0FCF: 03f0             add si, ax
  04CA21  0FD1: 0176f8           add word ptr [bp - 8], si
  04CA24  0FD4: ff46f4           inc word ptr [bp - 0xc]
  04CA27  0FD7: 837ef408         cmp word ptr [bp - 0xc], 8
  04CA2B  0FDB: 7d03             jge 0xfe0
  04CA2D  0FDD: e931ff           jmp 0xf11
  04CA30  0FE0: 8b46f8           mov ax, word ptr [bp - 8]
  04CA33  0FE3: 3946e8           cmp word ptr [bp - 0x18], ax
  04CA36  0FE6: 7d09             jge 0xff1
  04CA38  0FE8: 8946e8           mov word ptr [bp - 0x18], ax
  04CA3B  0FEB: 8b46f6           mov ax, word ptr [bp - 0xa]
  04CA3E  0FEE: 8946f2           mov word ptr [bp - 0xe], ax
  04CA41  0FF1: ff46f6           inc word ptr [bp - 0xa]
  04CA44  0FF4: 837ef609         cmp word ptr [bp - 0xa], 9
  04CA48  0FF8: 7d36             jge 0x1030
  04CA4A  0FFA: 8b5ef6           mov bx, word ptr [bp - 0xa]
  04CA4D  0FFD: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04CA51  1001: 98               cwde 
  04CA52  1002: 03460a           add ax, word ptr [bp + 0xa]
  04CA55  1005: 8946fa           mov word ptr [bp - 6], ax
  04CA58  1008: c746fe0000       mov word ptr [bp - 2], 0
  04CA5D  100D: 50               push ax
  04CA5E  100E: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04CA62  1012: 98               cwde 
  04CA63  1013: 034608           add ax, word ptr [bp + 8]
  04CA66  1016: 8946fc           mov word ptr [bp - 4], ax
  04CA69  1019: 50               push ax
  04CA6A  101A: 9ad2061f18       lcall 0x181f, 0x6d2
  04CA6F  101F: 83c404           add sp, 4
  04CA72  1022: 8946f0           mov word ptr [bp - 0x10], ax
  04CA75  1025: 0bc0             or ax, ax
  04CA77  1027: 7c03             jl 0x102c
  04CA79  1029: e93afe           jmp 0xe66
  04CA7C  102C: e984fe           jmp 0xeb3
  04CA7F  102F: 90               nop 
  04CA80  1030: 8b46f2           mov ax, word ptr [bp - 0xe]
  04CA83  1033: 5e               pop si
  04CA84  1034: c9               leave 
  04CA85  1035: cb               retf 

; ---- func_04CA86  size=111  insns=36  prologue=ENTER 0x0008,0  terminal=RETF ----
  04CA86  1036: c8080000         enter 8, 0
  04CA8A  103A: c746faffff       mov word ptr [bp - 6], 0xffff
  04CA8F  103F: 837e0804         cmp word ptr [bp + 8], 4
  04CA93  1043: 7c55             jl 0x109a
  04CA95  1045: 837e0a00         cmp word ptr [bp + 0xa], 0
  04CA99  1049: 7455             je 0x10a0
  04CA9B  104B: c746fe0000       mov word ptr [bp - 2], 0
  04CAA0  1050: ff7606           push word ptr [bp + 6]
  04CAA3  1053: 8b4608           mov ax, word ptr [bp + 8]
  04CAA6  1056: 2d0400           sub ax, 4
  04CAA9  1059: 50               push ax
  04CAAA  105A: 9a0c031f18       lcall 0x181f, 0x30c
  04CAAF  105F: 83c404           add sp, 4
  04CAB2  1062: 3d4b00           cmp ax, 0x4b
  04CAB5  1065: 7c05             jl 0x106c
  04CAB7  1067: c746fe0100       mov word ptr [bp - 2], 1
  04CABC  106C: 837e0c00         cmp word ptr [bp + 0xc], 0
  04CAC0  1070: 7c22             jl 0x1094
  04CAC2  1072: 6b5e0c1c         imul bx, word ptr [bp + 0xc], 0x1c
  04CAC6  1076: 8a874a31         mov al, byte ptr [bx + 0x314a]
  04CACA  107A: 98               cwde 
  04CACB  107B: 8bd8             mov bx, ax
  04CACD  107D: c1e303           shl bx, 3
  04CAD0  1080: 03d8             add bx, ax
  04CAD2  1082: 035e06           add bx, word ptr [bp + 6]
  04CAD5  1085: d1e3             shl bx, 1
  04CAD7  1087: 81bff6548000     cmp word ptr [bx + 0x54f6], 0x80
  04CADD  108D: 7c05             jl 0x1094
  04CADF  108F: c746fe0100       mov word ptr [bp - 2], 1
  04CAE4  1094: 837efe00         cmp word ptr [bp - 2], 0
  04CAE8  1098: 7406             je 0x10a0
  04CAEA  109A: 8b4608           mov ax, word ptr [bp + 8]
  04CAED  109D: 8946fa           mov word ptr [bp - 6], ax
  04CAF0  10A0: 8b46fa           mov ax, word ptr [bp - 6]
  04CAF3  10A3: c9               leave 
  04CAF4  10A4: cb               retf 

; ---- func_04CAF6  size=345  insns=119  prologue=ENTER 0x0010,0  terminal=RETF ----
  04CAF6  10A6: c8100000         enter 0x10, 0
  04CAFA  10AA: ff7608           push word ptr [bp + 8]
  04CAFD  10AD: ff7606           push word ptr [bp + 6]
  04CB00  10B0: 9a68071f18       lcall 0x181f, 0x768
  04CB05  10B5: 83c404           add sp, 4
  04CB08  10B8: 8946f6           mov word ptr [bp - 0xa], ax
  04CB0B  10BB: b8ffff           mov ax, 0xffff
  04CB0E  10BE: 8946f0           mov word ptr [bp - 0x10], ax
  04CB11  10C1: a3a89e           mov word ptr [0x9ea8], ax
  04CB14  10C4: c746fa0000       mov word ptr [bp - 6], 0
  04CB19  10C9: e9c000           jmp 0x118c
  04CB1C  10CC: c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  04CB21  10D1: ff76f2           push word ptr [bp - 0xe]
  04CB24  10D4: ff760c           push word ptr [bp + 0xc]
  04CB27  10D7: ff76f4           push word ptr [bp - 0xc]
  04CB2A  10DA: ff760a           push word ptr [bp + 0xa]
  04CB2D  10DD: 0e               push cs
  04CB2E  10DE: e8f969           call 0x7ada
  04CB31  10E1: 83c408           add sp, 8
  04CB34  10E4: 8946f0           mov word ptr [bp - 0x10], ax
  04CB37  10E7: 0bc0             or ax, ax
  04CB39  10E9: 7c62             jl 0x114d
  04CB3B  10EB: 837ef600         cmp word ptr [bp - 0xa], 0
  04CB3F  10EF: 745c             je 0x114d
  04CB41  10F1: c746f80000       mov word ptr [bp - 8], 0
  04CB46  10F6: 8b46fe           mov ax, word ptr [bp - 2]
  04CB49  10F9: 8b56fc           mov dx, word ptr [bp - 4]
  04CB4C  10FC: 9ae0071f18       lcall 0x181f, 0x7e0
  04CB51  1101: eb38             jmp 0x113b
  04CB53  1103: 90               nop 
  04CB54  1104: 6bd81c           imul bx, ax, 0x1c
  04CB57  1107: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04CB5C  110C: 7225             jb 0x1133
  04CB5E  110E: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04CB63  1113: 771e             ja 0x1133
  04CB65  1115: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04CB69  1119: 2aff             sub bh, bh
  04CB6B  111B: 8bc3             mov ax, bx
  04CB6D  111D: d1e3             shl bx, 1
  04CB6F  111F: 03d8             add bx, ax
  04CB71  1121: d1e3             shl bx, 1
  04CB73  1123: 03d8             add bx, ax
  04CB75  1125: d1e3             shl bx, 1
  04CB77  1127: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  04CB7C  112C: 7405             je 0x1133
  04CB7E  112E: c746f80100       mov word ptr [bp - 8], 1
  04CB83  1133: 8b46f2           mov ax, word ptr [bp - 0xe]
  04CB86  1136: 9ae4021f18       lcall 0x181f, 0x2e4
  04CB8B  113B: 8946f2           mov word ptr [bp - 0xe], ax
  04CB8E  113E: 0bc0             or ax, ax
  04CB90  1140: 7dc2             jge 0x1104
  04CB92  1142: 837ef800         cmp word ptr [bp - 8], 0
  04CB96  1146: 7505             jne 0x114d
  04CB98  1148: c746f0ffff       mov word ptr [bp - 0x10], 0xffff
  04CB9D  114D: ff76fc           push word ptr [bp - 4]
  04CBA0  1150: ff76fe           push word ptr [bp - 2]
  04CBA3  1153: 9abe061f18       lcall 0x181f, 0x6be
  04CBA8  1158: 83c404           add sp, 4
  04CBAB  115B: 8946f4           mov word ptr [bp - 0xc], ax
  04CBAE  115E: 0bc0             or ax, ax
  04CBB0  1160: 7c27             jl 0x1189
  04CBB2  1162: 3b460a           cmp ax, word ptr [bp + 0xa]
  04CBB5  1165: 7422             je 0x1189
  04CBB7  1167: 6aff             push -1
  04CBB9  1169: ff760c           push word ptr [bp + 0xc]
  04CBBC  116C: 50               push ax
  04CBBD  116D: ff760a           push word ptr [bp + 0xa]
  04CBC0  1170: 0e               push cs
  04CBC1  1171: e86669           call 0x7ada
  04CBC4  1174: 83c408           add sp, 8
  04CBC7  1177: 8946f0           mov word ptr [bp - 0x10], ax
  04CBCA  117A: 3d0400           cmp ax, 4
  04CBCD  117D: 7d0a             jge 0x1189
  04CBCF  117F: 833ea89e00       cmp word ptr [0x9ea8], 0
  04CBD4  1184: 7d03             jge 0x1189
  04CBD6  1186: a3a89e           mov word ptr [0x9ea8], ax
  04CBD9  1189: ff46fa           inc word ptr [bp - 6]
  04CBDC  118C: 837ef000         cmp word ptr [bp - 0x10], 0
  04CBE0  1190: 7d68             jge 0x11fa
  04CBE2  1192: 837efa08         cmp word ptr [bp - 6], 8
  04CBE6  1196: 7d62             jge 0x11fa
  04CBE8  1198: 8b5efa           mov bx, word ptr [bp - 6]
  04CBEB  119B: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04CBEF  119F: 98               cwde 
  04CBF0  11A0: 034608           add ax, word ptr [bp + 8]
  04CBF3  11A3: 8946fc           mov word ptr [bp - 4], ax
  04CBF6  11A6: 50               push ax
  04CBF7  11A7: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04CBFB  11AB: 98               cwde 
  04CBFC  11AC: 034606           add ax, word ptr [bp + 6]
  04CBFF  11AF: 8946fe           mov word ptr [bp - 2], ax
  04CC02  11B2: 50               push ax
  04CC03  11B3: 9a68071f18       lcall 0x181f, 0x768
  04CC08  11B8: 83c404           add sp, 4
  04CC0B  11BB: 3b46f6           cmp ax, word ptr [bp - 0xa]
  04CC0E  11BE: 75c9             jne 0x1189
  04CC10  11C0: ff76fc           push word ptr [bp - 4]
  04CC13  11C3: ff76fe           push word ptr [bp - 2]
  04CC16  11C6: 9a82061f18       lcall 0x181f, 0x682
  04CC1B  11CB: 83c404           add sp, 4
  04CC1E  11CE: 8946f4           mov word ptr [bp - 0xc], ax
  04CC21  11D1: 0bc0             or ax, ax
  04CC23  11D3: 7d03             jge 0x11d8
  04CC25  11D5: e975ff           jmp 0x114d
  04CC28  11D8: 3b460a           cmp ax, word ptr [bp + 0xa]
  04CC2B  11DB: 7503             jne 0x11e0
  04CC2D  11DD: e96dff           jmp 0x114d
  04CC30  11E0: 3d0400           cmp ax, 4
  04CC33  11E3: 7d03             jge 0x11e8
  04CC35  11E5: e9e4fe           jmp 0x10cc
  04CC38  11E8: 8b46fe           mov ax, word ptr [bp - 2]
  04CC3B  11EB: 8b56fc           mov dx, word ptr [bp - 4]
  04CC3E  11EE: 9ae0071f18       lcall 0x181f, 0x7e0
  04CC43  11F3: 8946f2           mov word ptr [bp - 0xe], ax
  04CC46  11F6: e9d8fe           jmp 0x10d1
  04CC49  11F9: 90               nop 
  04CC4A  11FA: 8b46f0           mov ax, word ptr [bp - 0x10]
  04CC4D  11FD: c9               leave 
  04CC4E  11FE: cb               retf 

; ---- func_04CC50  size=5733  insns=1939  prologue=ENTER 0x01E4,0  terminal=RETF ----
  04CC50  1200: c8e40100         enter 0x1e4, 0
  04CC54  1204: 56               push si
  04CC55  1205: ff7606           push word ptr [bp + 6]
  04CC58  1208: 9a82051f18       lcall 0x181f, 0x582
  04CC5D  120D: 83c402           add sp, 2
  04CC60  1210: 680e01           push 0x10e
  04CC63  1213: 6a00             push 0
  04CC65  1215: 68aa9f           push 0x9faa
  04CC68  1218: 9aae0d1d0d       lcall 0xd1d, 0xdae
  04CC6D  121D: 83c406           add sp, 6
  04CC70  1220: 6a10             push 0x10
  04CC72  1222: 6a00             push 0
  04CC74  1224: 683ca1           push 0xa13c
  04CC77  1227: 9aae0d1d0d       lcall 0xd1d, 0xdae
  04CC7C  122C: 83c406           add sp, 6
  04CC7F  122F: 6a10             push 0x10
  04CC81  1231: 6a00             push 0
  04CC83  1233: 68989e           push 0x9e98
  04CC86  1236: 9aae0d1d0d       lcall 0xd1d, 0xdae
  04CC8B  123B: 83c406           add sp, 6
  04CC8E  123E: 680001           push 0x100
  04CC91  1241: 6a00             push 0
  04CC93  1243: 8d86b4fe         lea ax, [bp - 0x14c]
  04CC97  1247: 50               push ax
  04CC98  1248: 9aae0d1d0d       lcall 0xd1d, 0xdae
  04CC9D  124D: 83c406           add sp, 6
  04CCA0  1250: 6a63             push 0x63
  04CCA2  1252: 6a03             push 3
  04CCA4  1254: 8b5e06           mov bx, word ptr [bp + 6]
  04CCA7  1257: 8a87fc8c         mov al, byte ptr [bx - 0x7304]
  04CCAB  125B: c0e803           shr al, 3
  04CCAE  125E: 2ae4             sub ah, ah
  04CCB0  1260: 50               push ax
  04CCB1  1261: 9a5c031f18       lcall 0x181f, 0x35c
  04CCB6  1266: 83c406           add sp, 6
  04CCB9  1269: 8946c6           mov word ptr [bp - 0x3a], ax
  04CCBC  126C: c746c40000       mov word ptr [bp - 0x3c], 0
  04CCC1  1271: 8b46c6           mov ax, word ptr [bp - 0x3a]
  04CCC4  1274: 8b76c4           mov si, word ptr [bp - 0x3c]
  04CCC7  1277: d1e6             shl si, 1
  04CCC9  1279: 898228fe         mov word ptr [bp + si - 0x1d8], ax
  04CCCD  127D: ff46c4           inc word ptr [bp - 0x3c]
  04CCD0  1280: 837ec440         cmp word ptr [bp - 0x3c], 0x40
  04CCD4  1284: 7ceb             jl 0x1271
  04CCD6  1286: 2bc0             sub ax, ax
  04CCD8  1288: 8946f6           mov word ptr [bp - 0xa], ax
  04CCDB  128B: 8986aefe         mov word ptr [bp - 0x152], ax
  04CCDF  128F: e98f01           jmp 0x1421
  04CCE2  1292: c746e40000       mov word ptr [bp - 0x1c], 0
  04CCE7  1297: 6a03             push 3
  04CCE9  1299: ffb6aefe         push word ptr [bp - 0x152]
  04CCED  129D: 9abc081f18       lcall 0x181f, 0x8bc
  04CCF2  12A2: 83c404           add sp, 4
  04CCF5  12A5: 8946e6           mov word ptr [bp - 0x1a], ax
  04CCF8  12A8: 837ee400         cmp word ptr [bp - 0x1c], 0
  04CCFC  12AC: 7507             jne 0x12b5
  04CCFE  12AE: 0bc0             or ax, ax
  04CD00  12B0: 7503             jne 0x12b5
  04CD02  12B2: e9dc00           jmp 0x1391
  04CD05  12B5: c746fe0100       mov word ptr [bp - 2], 1
  04CD0A  12BA: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CD0F  12BF: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04CD14  12C4: 7303             jae 0x12c9
  04CD16  12C6: e9a200           jmp 0x136b
  04CD19  12C9: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04CD1E  12CE: 7603             jbe 0x12d3
  04CD20  12D0: e99800           jmp 0x136b
  04CD23  12D3: 8a875031         mov al, byte ptr [bx + 0x3150]
  04CD27  12D7: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04CD2B  12DB: 2aff             sub bh, bh
  04CD2D  12DD: 8bcb             mov cx, bx
  04CD2F  12DF: d1e3             shl bx, 1
  04CD31  12E1: 03d9             add bx, cx
  04CD33  12E3: d1e3             shl bx, 1
  04CD35  12E5: 03d9             add bx, cx
  04CD37  12E7: d1e3             shl bx, 1
  04CD39  12E9: 38873752         cmp byte ptr [bx + 0x5237], al
  04CD3D  12ED: 7405             je 0x12f4
  04CD3F  12EF: c746fe0000       mov word ptr [bp - 2], 0
  04CD44  12F4: 837efe00         cmp word ptr [bp - 2], 0
  04CD48  12F8: 7471             je 0x136b
  04CD4A  12FA: 8b86aefe         mov ax, word ptr [bp - 0x152]
  04CD4E  12FE: 8946c0           mov word ptr [bp - 0x40], ax
  04CD51  1301: 9aee021f18       lcall 0x181f, 0x2ee
  04CD56  1306: eb2a             jmp 0x1332
  04CD58  1308: 90               nop 
  04CD59  1309: 90               nop 
  04CD5A  130A: 6bd81c           imul bx, ax, 0x1c
  04CD5D  130D: 8a875031         mov al, byte ptr [bx + 0x3150]
  04CD61  1311: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04CD65  1315: 2aff             sub bh, bh
  04CD67  1317: 8bcb             mov cx, bx
  04CD69  1319: d1e3             shl bx, 1
  04CD6B  131B: 03d9             add bx, cx
  04CD6D  131D: d1e3             shl bx, 1
  04CD6F  131F: 03d9             add bx, cx
  04CD71  1321: d1e3             shl bx, 1
  04CD73  1323: 38873752         cmp byte ptr [bx + 0x5237], al
  04CD77  1327: 752b             jne 0x1354
  04CD79  1329: 8b86aefe         mov ax, word ptr [bp - 0x152]
  04CD7D  132D: 9ae4021f18       lcall 0x181f, 0x2e4
  04CD82  1332: 8986aefe         mov word ptr [bp - 0x152], ax
  04CD86  1336: 837efe00         cmp word ptr [bp - 2], 0
  04CD8A  133A: 7428             je 0x1364
  04CD8C  133C: 0bc0             or ax, ax
  04CD8E  133E: 7c24             jl 0x1364
  04CD90  1340: 6bd81c           imul bx, ax, 0x1c
  04CD93  1343: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04CD98  1348: 72df             jb 0x1329
  04CD9A  134A: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04CD9F  134F: 76b9             jbe 0x130a
  04CDA1  1351: ebd6             jmp 0x1329
  04CDA3  1353: 90               nop 
  04CDA4  1354: 8b46c0           mov ax, word ptr [bp - 0x40]
  04CDA7  1357: 3986aefe         cmp word ptr [bp - 0x152], ax
  04CDAB  135B: 7dcc             jge 0x1329
  04CDAD  135D: c746fe0000       mov word ptr [bp - 2], 0
  04CDB2  1362: ebc5             jmp 0x1329
  04CDB4  1364: 8b46c0           mov ax, word ptr [bp - 0x40]
  04CDB7  1367: 8986aefe         mov word ptr [bp - 0x152], ax
  04CDBB  136B: 837efe00         cmp word ptr [bp - 2], 0
  04CDBF  136F: 7420             je 0x1391
  04CDC1  1371: 837ee400         cmp word ptr [bp - 0x1c], 0
  04CDC5  1375: 740a             je 0x1381
  04CDC7  1377: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CDCC  137C: 808f48310c       or byte ptr [bx + 0x3148], 0xc
  04CDD1  1381: 837ee600         cmp word ptr [bp - 0x1a], 0
  04CDD5  1385: 740a             je 0x1391
  04CDD7  1387: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CDDC  138C: 808f483104       or byte ptr [bx + 0x3148], 4
  04CDE1  1391: 837ef600         cmp word ptr [bp - 0xa], 0
  04CDE5  1395: 7567             jne 0x13fe
  04CDE7  1397: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CDEC  139C: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04CDF1  13A1: 725b             jb 0x13fe
  04CDF3  13A3: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04CDF8  13A8: 7754             ja 0x13fe
  04CDFA  13AA: f68748310c       test byte ptr [bx + 0x3148], 0xc
  04CDFF  13AF: 754d             jne 0x13fe
  04CE01  13B1: 6b5e0613         imul bx, word ptr [bp + 6], 0x13
  04CE05  13B5: 8a875a92         mov al, byte ptr [bx - 0x6da6]
  04CE09  13B9: 8bc8             mov cx, ax
  04CE0B  13BB: 2ae4             sub ah, ah
  04CE0D  13BD: 8a975b92         mov dl, byte ptr [bx - 0x6da5]
  04CE11  13C1: 2af6             sub dh, dh
  04CE13  13C3: 03c2             add ax, dx
  04CE15  13C5: 3d0200           cmp ax, 2
  04CE18  13C8: 7c04             jl 0x13ce
  04CE1A  13CA: 0ac9             or cl, cl
  04CE1C  13CC: 751a             jne 0x13e8
  04CE1E  13CE: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CE23  13D3: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04CE28  13D8: 7524             jne 0x13fe
  04CE2A  13DA: 6b760613         imul si, word ptr [bp + 6], 0x13
  04CE2E  13DE: 80bc599201       cmp byte ptr [si - 0x6da7], 1
  04CE33  13E3: 7619             jbe 0x13fe
  04CE35  13E5: eb0d             jmp 0x13f4
  04CE37  13E7: 90               nop 
  04CE38  13E8: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CE3D  13ED: 80bf46310e       cmp byte ptr [bx + 0x3146], 0xe
  04CE42  13F2: 750a             jne 0x13fe
  04CE44  13F4: 808f483120       or byte ptr [bx + 0x3148], 0x20
  04CE49  13F9: c746f60100       mov word ptr [bp - 0xa], 1
  04CE4E  13FE: ff76c8           push word ptr [bp - 0x38]
  04CE51  1401: ff76cc           push word ptr [bp - 0x34]
  04CE54  1404: 9a02031f18       lcall 0x181f, 0x302
  04CE59  1409: 83c404           add sp, 4
  04CE5C  140C: 0bc0             or ax, ax
  04CE5E  140E: 7403             je 0x1413
  04CE60  1410: e99b00           jmp 0x14ae
  04CE63  1413: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CE68  1418: c6874c3101       mov byte ptr [bx + 0x314c], 1
  04CE6D  141D: ff86aefe         inc word ptr [bp - 0x152]
  04CE71  1421: a19c53           mov ax, word ptr [0x539c]
  04CE74  1424: 3986aefe         cmp word ptr [bp - 0x152], ax
  04CE78  1428: 7c03             jl 0x142d
  04CE7A  142A: e9b901           jmp 0x15e6
  04CE7D  142D: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CE82  1432: 8a874731         mov al, byte ptr [bx + 0x3147]
  04CE86  1436: 240f             and al, 0xf
  04CE88  1438: 3a4606           cmp al, byte ptr [bp + 6]
  04CE8B  143B: 7403             je 0x1440
  04CE8D  143D: e91a01           jmp 0x155a
  04CE90  1440: 8a874431         mov al, byte ptr [bx + 0x3144]
  04CE94  1444: 2ae4             sub ah, ah
  04CE96  1446: 8946cc           mov word ptr [bp - 0x34], ax
  04CE99  1449: 8a874531         mov al, byte ptr [bx + 0x3145]
  04CE9D  144D: 8946c8           mov word ptr [bp - 0x38], ax
  04CEA0  1450: 80bf4b3141       cmp byte ptr [bx + 0x314b], 0x41
  04CEA5  1455: 7505             jne 0x145c
  04CEA7  1457: c6874b3147       mov byte ptr [bx + 0x314b], 0x47
  04CEAC  145C: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CEB1  1461: 80a74831d1       and byte ptr [bx + 0x3148], 0xd1
  04CEB6  1466: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  04CEBB  146B: 7407             je 0x1474
  04CEBD  146D: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  04CEC2  1472: 750a             jne 0x147e
  04CEC4  1474: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CEC9  1479: 808f483102       or byte ptr [bx + 0x3148], 2
  04CECE  147E: 6a04             push 4
  04CED0  1480: ffb6aefe         push word ptr [bp - 0x152]
  04CED4  1484: 9abc081f18       lcall 0x181f, 0x8bc
  04CED9  1489: 83c404           add sp, 4
  04CEDC  148C: 3d0100           cmp ax, 1
  04CEDF  148F: 7f15             jg 0x14a6
  04CEE1  1491: 6a06             push 6
  04CEE3  1493: ffb6aefe         push word ptr [bp - 0x152]
  04CEE7  1497: 9abc081f18       lcall 0x181f, 0x8bc
  04CEEC  149C: 83c404           add sp, 4
  04CEEF  149F: 0bc0             or ax, ax
  04CEF1  14A1: 7503             jne 0x14a6
  04CEF3  14A3: e9ecfd           jmp 0x1292
  04CEF6  14A6: c746e40100       mov word ptr [bp - 0x1c], 1
  04CEFB  14AB: e9e9fd           jmp 0x1297
  04CEFE  14AE: ffb6aefe         push word ptr [bp - 0x152]
  04CF02  14B2: 9a280b1f18       lcall 0x181f, 0xb28
  04CF07  14B7: 83c402           add sp, 2
  04CF0A  14BA: 3d0100           cmp ax, 1
  04CF0D  14BD: 1ac0             sbb al, al
  04CF0F  14BF: 24fc             and al, 0xfc
  04CF11  14C1: 0405             add al, 5
  04CF13  14C3: 8b4ecc           mov cx, word ptr [bp - 0x34]
  04CF16  14C6: c1f902           sar cx, 2
  04CF19  14C9: 6bf112           imul si, cx, 0x12
  04CF1C  14CC: 8b5ec8           mov bx, word ptr [bp - 0x38]
  04CF1F  14CF: c1fb02           sar bx, 2
  04CF22  14D2: 0880aa9f         or byte ptr [bx + si - 0x6056], al
  04CF26  14D6: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CF2B  14DB: 80bf4c3103       cmp byte ptr [bx + 0x314c], 3
  04CF30  14E0: 741c             je 0x14fe
  04CF32  14E2: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  04CF37  14E7: 7415             je 0x14fe
  04CF39  14E9: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  04CF3E  14EE: 740e             je 0x14fe
  04CF40  14F0: 80bf4c310a       cmp byte ptr [bx + 0x314c], 0xa
  04CF45  14F5: 7211             jb 0x1508
  04CF47  14F7: 80bf4b3131       cmp byte ptr [bx + 0x314b], 0x31
  04CF4C  14FC: 740a             je 0x1508
  04CF4E  14FE: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CF53  1503: c6874c3100       mov byte ptr [bx + 0x314c], 0
  04CF58  1508: 6a01             push 1
  04CF5A  150A: ff7606           push word ptr [bp + 6]
  04CF5D  150D: ff76c8           push word ptr [bp - 0x38]
  04CF60  1510: ff76cc           push word ptr [bp - 0x34]
  04CF63  1513: 0e               push cs
  04CF64  1514: e85f65           call 0x7a76
  04CF67  1517: 83c408           add sp, 8
  04CF6A  151A: 0bc0             or ax, ax
  04CF6C  151C: 7c0a             jl 0x1528
  04CF6E  151E: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CF73  1523: c6874c310a       mov byte ptr [bx + 0x314c], 0xa
  04CF78  1528: ff76c8           push word ptr [bp - 0x38]
  04CF7B  152B: ff76cc           push word ptr [bp - 0x34]
  04CF7E  152E: 9a68071f18       lcall 0x181f, 0x768
  04CF83  1533: 83c404           add sp, 4
  04CF86  1536: 0bc0             or ax, ax
  04CF88  1538: 7503             jne 0x153d
  04CF8A  153A: e9e0fe           jmp 0x141d
  04CF8D  153D: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CF92  1542: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04CF97  1547: 7303             jae 0x154c
  04CF99  1549: e9c7fe           jmp 0x1413
  04CF9C  154C: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04CFA1  1551: 7703             ja 0x1556
  04CFA3  1553: e9c7fe           jmp 0x141d
  04CFA6  1556: e9bafe           jmp 0x1413
  04CFA9  1559: 90               nop 
  04CFAA  155A: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CFAF  155F: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04CFB4  1564: 7303             jae 0x1569
  04CFB6  1566: e9b4fe           jmp 0x141d
  04CFB9  1569: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04CFBE  156E: 7603             jbe 0x1573
  04CFC0  1570: e9aafe           jmp 0x141d
  04CFC3  1573: 80bf463111       cmp byte ptr [bx + 0x3146], 0x11
  04CFC8  1578: 750a             jne 0x1584
  04CFCA  157A: f606825301       test byte ptr [0x5382], 1
  04CFCF  157F: 7503             jne 0x1584
  04CFD1  1581: e999fe           jmp 0x141d
  04CFD4  1584: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04CFD9  1589: 8a874731         mov al, byte ptr [bx + 0x3147]
  04CFDD  158D: 8bc8             mov cx, ax
  04CFDF  158F: 2ae4             sub ah, ah
  04CFE1  1591: 8bd1             mov dx, cx
  04CFE3  1593: 8a4e06           mov cl, byte ptr [bp + 6]
  04CFE6  1596: be1000           mov si, 0x10
  04CFE9  1599: d3e6             shl si, cl
  04CFEB  159B: 85c6             test si, ax
  04CFED  159D: 7503             jne 0x15a2
  04CFEF  159F: e97bfe           jmp 0x141d
  04CFF2  15A2: 83e20f           and dx, 0xf
  04CFF5  15A5: 52               push dx
  04CFF6  15A6: ff7606           push word ptr [bp + 6]
  04CFF9  15A9: 8bf3             mov si, bx
  04CFFB  15AB: 9a380a1f18       lcall 0x181f, 0xa38
  04D000  15B0: 83c404           add sp, 4
  04D003  15B3: 2460             and al, 0x60
  04D005  15B5: 3c20             cmp al, 0x20
  04D007  15B7: 740a             je 0x15c3
  04D009  15B9: 80bc463110       cmp byte ptr [si + 0x3146], 0x10
  04D00E  15BE: 7403             je 0x15c3
  04D010  15C0: e95afe           jmp 0x141d
  04D013  15C3: 6a03             push 3
  04D015  15C5: 6a00             push 0
  04D017  15C7: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04D01C  15CC: 8a874531         mov al, byte ptr [bx + 0x3145]
  04D020  15D0: 2ae4             sub ah, ah
  04D022  15D2: 50               push ax
  04D023  15D3: 8a874431         mov al, byte ptr [bx + 0x3144]
  04D027  15D7: 50               push ax
  04D028  15D8: ff7606           push word ptr [bp + 6]
  04D02B  15DB: 0e               push cs
  04D02C  15DC: e89264           call 0x7a71
  04D02F  15DF: 83c40a           add sp, 0xa
  04D032  15E2: e938fe           jmp 0x141d
  04D035  15E5: 90               nop 
  04D036  15E6: 0e               push cs
  04D037  15E7: e8eb64           call 0x7ad5
  04D03A  15EA: 2bc0             sub ax, ax
  04D03C  15EC: a33c17           mov word ptr [0x173c], ax
  04D03F  15EF: a33e17           mov word ptr [0x173e], ax
  04D042  15F2: 8946c4           mov word ptr [bp - 0x3c], ax
  04D045  15F5: e99b00           jmp 0x1693
  04D048  15F8: 2bc0             sub ax, ax
  04D04A  15FA: 8986b0fe         mov word ptr [bp - 0x150], ax
  04D04E  15FE: 8b5e06           mov bx, word ptr [bp + 6]
  04D051  1601: c1e304           shl bx, 4
  04D054  1604: 035eee           add bx, word ptr [bp - 0x12]
  04D057  1607: 8a87e694         mov al, byte ptr [bx - 0x6b1a]
  04D05B  160B: 2ae4             sub ah, ah
  04D05D  160D: 8a8fa694         mov cl, byte ptr [bx - 0x6b5a]
  04D061  1611: 2aed             sub ch, ch
  04D063  1613: 03c1             add ax, cx
  04D065  1615: 746f             je 0x1686
  04D067  1617: 8a46c4           mov al, byte ptr [bp - 0x3c]
  04D06A  161A: 02068e53         add al, byte ptr [0x538e]
  04D06E  161E: a803             test al, 3
  04D070  1620: 7464             je 0x1686
  04D072  1622: 8b1e4285         mov bx, word ptr [0x8542]
  04D076  1626: 8a07             mov al, byte ptr [bx]
  04D078  1628: 2ae4             sub ah, ah
  04D07A  162A: 8a5701           mov dl, byte ptr [bx + 1]
  04D07D  162D: 2af6             sub dh, dh
  04D07F  162F: 9ae0071f18       lcall 0x181f, 0x7e0
  04D084  1634: 8986aefe         mov word ptr [bp - 0x152], ax
  04D088  1638: 6a02             push 2
  04D08A  163A: 50               push ax
  04D08B  163B: 9abc081f18       lcall 0x181f, 0x8bc
  04D090  1640: 83c404           add sp, 4
  04D093  1643: 8b1e4285         mov bx, word ptr [0x8542]
  04D097  1647: 8bc8             mov cx, ax
  04D099  1649: 8a471f           mov al, byte ptr [bx + 0x1f]
  04D09C  164C: 98               cwde 
  04D09D  164D: 03c8             add cx, ax
  04D09F  164F: 894ef2           mov word ptr [bp - 0xe], cx
  04D0A2  1652: a18e53           mov ax, word ptr [0x538e]
  04D0A5  1655: b9ceff           mov cx, 0xffce
  04D0A8  1658: 99               cdq 
  04D0A9  1659: f7f9             idiv cx
  04D0AB  165B: 050600           add ax, 6
  04D0AE  165E: 3b46f2           cmp ax, word ptr [bp - 0xe]
  04D0B1  1661: 7d23             jge 0x1686
  04D0B3  1663: 83beb0fe01       cmp word ptr [bp - 0x150], 1
  04D0B8  1668: 1bc0             sbb ax, ax
  04D0BA  166A: 250200           and ax, 2
  04D0BD  166D: 050300           add ax, 3
  04D0C0  1670: 50               push ax
  04D0C1  1671: 6a04             push 4
  04D0C3  1673: 8a4701           mov al, byte ptr [bx + 1]
  04D0C6  1676: 2ae4             sub ah, ah
  04D0C8  1678: 50               push ax
  04D0C9  1679: 8a07             mov al, byte ptr [bx]
  04D0CB  167B: 50               push ax
  04D0CC  167C: ff7606           push word ptr [bp + 6]
  04D0CF  167F: 0e               push cs
  04D0D0  1680: e8ee63           call 0x7a71
  04D0D3  1683: 83c40a           add sp, 0xa
  04D0D6  1686: 83beb0fe00       cmp word ptr [bp - 0x150], 0
  04D0DB  168B: 7503             jne 0x1690
  04D0DD  168D: e9b600           jmp 0x1746
  04D0E0  1690: ff46c4           inc word ptr [bp - 0x3c]
  04D0E3  1693: a19e53           mov ax, word ptr [0x539e]
  04D0E6  1696: 3946c4           cmp word ptr [bp - 0x3c], ax
  04D0E9  1699: 7c03             jl 0x169e
  04D0EB  169B: e92c0a           jmp 0x20ca
  04D0EE  169E: ff76c4           push word ptr [bp - 0x3c]
  04D0F1  16A1: 9ae6091f18       lcall 0x181f, 0x9e6
  04D0F6  16A6: 83c402           add sp, 2
  04D0F9  16A9: 8a4606           mov al, byte ptr [bp + 6]
  04D0FC  16AC: 8b1e4285         mov bx, word ptr [0x8542]
  04D100  16B0: 38471a           cmp byte ptr [bx + 0x1a], al
  04D103  16B3: 7503             jne 0x16b8
  04D105  16B5: e9e805           jmp 0x1ca0
  04D108  16B8: 8a4f01           mov cl, byte ptr [bx + 1]
  04D10B  16BB: 2aed             sub ch, ch
  04D10D  16BD: 51               push cx
  04D10E  16BE: 8a0f             mov cl, byte ptr [bx]
  04D110  16C0: 51               push cx
  04D111  16C1: 89861efe         mov word ptr [bp - 0x1e2], ax
  04D115  16C5: 9a22071f18       lcall 0x181f, 0x722
  04D11A  16CA: 83c404           add sp, 4
  04D11D  16CD: 8946ee           mov word ptr [bp - 0x12], ax
  04D120  16D0: a0a653           mov al, byte ptr [0x53a6]
  04D123  16D3: 2ae4             sub ah, ah
  04D125  16D5: f72e8e53         imul word ptr [0x538e]
  04D129  16D9: 3db400           cmp ax, 0xb4
  04D12C  16DC: 7f43             jg 0x1721
  04D12E  16DE: 837e0604         cmp word ptr [bp + 6], 4
  04D132  16E2: 7d3d             jge 0x1721
  04D134  16E4: 8b1e4285         mov bx, word ptr [0x8542]
  04D138  16E8: 8a4701           mov al, byte ptr [bx + 1]
  04D13B  16EB: 2ae4             sub ah, ah
  04D13D  16ED: 50               push ax
  04D13E  16EE: 8a07             mov al, byte ptr [bx]
  04D140  16F0: 50               push ax
  04D141  16F1: 9a4a071f18       lcall 0x181f, 0x74a
  04D146  16F6: 83c404           add sp, 4
  04D149  16F9: 2ae4             sub ah, ah
  04D14B  16FB: 8a8e1efe         mov cl, byte ptr [bp - 0x1e2]
  04D14F  16FF: ba1000           mov dx, 0x10
  04D152  1702: d3e2             shl dx, cl
  04D154  1704: 85c2             test dx, ax
  04D156  1706: 7519             jne 0x1721
  04D158  1708: 8b1e4285         mov bx, word ptr [0x8542]
  04D15C  170C: 807f1a04         cmp byte ptr [bx + 0x1a], 4
  04D160  1710: 730f             jae 0x1721
  04D162  1712: 8a471a           mov al, byte ptr [bx + 0x1a]
  04D165  1715: 6bd834           imul bx, ax, 0x34
  04D168  1718: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  04D16C  171C: 7503             jne 0x1721
  04D16E  171E: e93502           jmp 0x1956
  04D171  1721: 8b1e4285         mov bx, word ptr [0x8542]
  04D175  1725: 8a471a           mov al, byte ptr [bx + 0x1a]
  04D178  1728: 2ae4             sub ah, ah
  04D17A  172A: 50               push ax
  04D17B  172B: ff7606           push word ptr [bp + 6]
  04D17E  172E: 9a380a1f18       lcall 0x181f, 0xa38
  04D183  1733: 83c404           add sp, 4
  04D186  1736: 2448             and al, 0x48
  04D188  1738: 3c40             cmp al, 0x40
  04D18A  173A: 7403             je 0x173f
  04D18C  173C: e9b9fe           jmp 0x15f8
  04D18F  173F: b80100           mov ax, 1
  04D192  1742: e9b5fe           jmp 0x15fa
  04D195  1745: 90               nop 
  04D196  1746: 8b1e4285         mov bx, word ptr [0x8542]
  04D19A  174A: 8a07             mov al, byte ptr [bx]
  04D19C  174C: 2ae4             sub ah, ah
  04D19E  174E: 8a5701           mov dl, byte ptr [bx + 1]
  04D1A1  1751: 2af6             sub dh, dh
  04D1A3  1753: 9ae0071f18       lcall 0x181f, 0x7e0
  04D1A8  1758: 8986aefe         mov word ptr [bp - 0x152], ax
  04D1AC  175C: 8b1e4285         mov bx, word ptr [0x8542]
  04D1B0  1760: f6471c40         test byte ptr [bx + 0x1c], 0x40
  04D1B4  1764: 7503             jne 0x1769
  04D1B6  1766: e9ed01           jmp 0x1956
  04D1B9  1769: 03068e53         add ax, word ptr [0x538e]
  04D1BD  176D: b90400           mov cx, 4
  04D1C0  1770: 99               cdq 
  04D1C1  1771: f7f9             idiv cx
  04D1C3  1773: 0bd2             or dx, dx
  04D1C5  1775: 7515             jne 0x178c
  04D1C7  1777: 6a0d             push 0xd
  04D1C9  1779: ffb6aefe         push word ptr [bp - 0x152]
  04D1CD  177D: 9abc081f18       lcall 0x181f, 0x8bc
  04D1D2  1782: 83c404           add sp, 4
  04D1D5  1785: 0bc0             or ax, ax
  04D1D7  1787: 7503             jne 0x178c
  04D1D9  1789: e9ca01           jmp 0x1956
  04D1DC  178C: c786a8fe0000     mov word ptr [bp - 0x158], 0
  04D1E2  1792: 6a01             push 1
  04D1E4  1794: 9afc091f18       lcall 0x181f, 0x9fc
  04D1E9  1799: 83c402           add sp, 2
  04D1EC  179C: 8946bc           mov word ptr [bp - 0x44], ax
  04D1EF  179F: c746f8feff       mov word ptr [bp - 8], 0xfffe
  04D1F4  17A4: e96e01           jmp 0x1915
  04D1F7  17A7: 90               nop 
  04D1F8  17A8: 8b46fc           mov ax, word ptr [bp - 4]
  04D1FB  17AB: f7d0             not ax
  04D1FD  17AD: 40               inc ax
  04D1FE  17AE: 3d0200           cmp ax, 2
  04D201  17B1: 7439             je 0x17ec
  04D203  17B3: 837ef800         cmp word ptr [bp - 8], 0
  04D207  17B7: 7e05             jle 0x17be
  04D209  17B9: 8b46f8           mov ax, word ptr [bp - 8]
  04D20C  17BC: eb06             jmp 0x17c4
  04D20E  17BE: 8b46f8           mov ax, word ptr [bp - 8]
  04D211  17C1: f7d0             not ax
  04D213  17C3: 40               inc ax
  04D214  17C4: 3d0200           cmp ax, 2
  04D217  17C7: 7423             je 0x17ec
  04D219  17C9: ff46fc           inc word ptr [bp - 4]
  04D21C  17CC: 837efc02         cmp word ptr [bp - 4], 2
  04D220  17D0: 7e03             jle 0x17d5
  04D222  17D2: e93d01           jmp 0x1912
  04D225  17D5: 837efc00         cmp word ptr [bp - 4], 0
  04D229  17D9: 7506             jne 0x17e1
  04D22B  17DB: 837ef800         cmp word ptr [bp - 8], 0
  04D22F  17DF: 74e8             je 0x17c9
  04D231  17E1: 837efc00         cmp word ptr [bp - 4], 0
  04D235  17E5: 7ec1             jle 0x17a8
  04D237  17E7: 8b46fc           mov ax, word ptr [bp - 4]
  04D23A  17EA: ebc2             jmp 0x17ae
  04D23C  17EC: 8b1e4285         mov bx, word ptr [0x8542]
  04D240  17F0: 8a4701           mov al, byte ptr [bx + 1]
  04D243  17F3: 2ae4             sub ah, ah
  04D245  17F5: 0346f8           add ax, word ptr [bp - 8]
  04D248  17F8: 8946c8           mov word ptr [bp - 0x38], ax
  04D24B  17FB: 50               push ax
  04D24C  17FC: 8a07             mov al, byte ptr [bx]
  04D24E  17FE: 2ae4             sub ah, ah
  04D250  1800: 0346fc           add ax, word ptr [bp - 4]
  04D253  1803: 8946cc           mov word ptr [bp - 0x34], ax
  04D256  1806: 50               push ax
  04D257  1807: 9a02031f18       lcall 0x181f, 0x302
  04D25C  180C: 83c404           add sp, 4
  04D25F  180F: 0bc0             or ax, ax
  04D261  1811: 74b6             je 0x17c9
  04D263  1813: ff76c8           push word ptr [bp - 0x38]
  04D266  1816: ff76cc           push word ptr [bp - 0x34]
  04D269  1819: 9a68071f18       lcall 0x181f, 0x768
  04D26E  181E: 83c404           add sp, 4
  04D271  1821: 0bc0             or ax, ax
  04D273  1823: 74a4             je 0x17c9
  04D275  1825: ff76c8           push word ptr [bp - 0x38]
  04D278  1828: ff76cc           push word ptr [bp - 0x34]
  04D27B  182B: 9ab4061f18       lcall 0x181f, 0x6b4
  04D280  1830: 83c404           add sp, 4
  04D283  1833: fec8             dec al
  04D285  1835: 7592             jne 0x17c9
  04D287  1837: 2bc0             sub ax, ax
  04D289  1839: 8946f4           mov word ptr [bp - 0xc], ax
  04D28C  183C: 8946dc           mov word ptr [bp - 0x24], ax
  04D28F  183F: eb15             jmp 0x1856
  04D291  1841: 90               nop 
  04D292  1842: 8b46ce           mov ax, word ptr [bp - 0x32]
  04D295  1845: 8a0f             mov cl, byte ptr [bx]
  04D297  1847: 2aed             sub ch, ch
  04D299  1849: 2bc1             sub ax, cx
  04D29B  184B: f7d0             not ax
  04D29D  184D: 40               inc ax
  04D29E  184E: 3d0100           cmp ax, 1
  04D2A1  1851: 7e6f             jle 0x18c2
  04D2A3  1853: ff46dc           inc word ptr [bp - 0x24]
  04D2A6  1856: 837edc08         cmp word ptr [bp - 0x24], 8
  04D2AA  185A: 7c03             jl 0x185f
  04D2AC  185C: e99100           jmp 0x18f0
  04D2AF  185F: 8b5edc           mov bx, word ptr [bp - 0x24]
  04D2B2  1862: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04D2B6  1866: 98               cwde 
  04D2B7  1867: 0346c8           add ax, word ptr [bp - 0x38]
  04D2BA  186A: 8946b6           mov word ptr [bp - 0x4a], ax
  04D2BD  186D: 50               push ax
  04D2BE  186E: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04D2C2  1872: 98               cwde 
  04D2C3  1873: 0346cc           add ax, word ptr [bp - 0x34]
  04D2C6  1876: 8946ce           mov word ptr [bp - 0x32], ax
  04D2C9  1879: 50               push ax
  04D2CA  187A: 9a02031f18       lcall 0x181f, 0x302
  04D2CF  187F: 83c404           add sp, 4
  04D2D2  1882: 0bc0             or ax, ax
  04D2D4  1884: 74cd             je 0x1853
  04D2D6  1886: ff76b6           push word ptr [bp - 0x4a]
  04D2D9  1889: ff76ce           push word ptr [bp - 0x32]
  04D2DC  188C: 9a68071f18       lcall 0x181f, 0x768
  04D2E1  1891: 83c404           add sp, 4
  04D2E4  1894: 0bc0             or ax, ax
  04D2E6  1896: 74bb             je 0x1853
  04D2E8  1898: ff76b6           push word ptr [bp - 0x4a]
  04D2EB  189B: ff76ce           push word ptr [bp - 0x32]
  04D2EE  189E: 9ab4061f18       lcall 0x181f, 0x6b4
  04D2F3  18A3: 83c404           add sp, 4
  04D2F6  18A6: fec8             dec al
  04D2F8  18A8: 75a9             jne 0x1853
  04D2FA  18AA: 8b1e4285         mov bx, word ptr [0x8542]
  04D2FE  18AE: 8a07             mov al, byte ptr [bx]
  04D300  18B0: 2ae4             sub ah, ah
  04D302  18B2: 2b46ce           sub ax, word ptr [bp - 0x32]
  04D305  18B5: f7d8             neg ax
  04D307  18B7: 89861efe         mov word ptr [bp - 0x1e2], ax
  04D30B  18BB: 0bc0             or ax, ax
  04D30D  18BD: 7e83             jle 0x1842
  04D30F  18BF: eb8d             jmp 0x184e
  04D311  18C1: 90               nop 
  04D312  18C2: 8a4701           mov al, byte ptr [bx + 1]
  04D315  18C5: 2ae4             sub ah, ah
  04D317  18C7: 2b46b6           sub ax, word ptr [bp - 0x4a]
  04D31A  18CA: f7d8             neg ax
  04D31C  18CC: 89861efe         mov word ptr [bp - 0x1e2], ax
  04D320  18D0: 0bc0             or ax, ax
  04D322  18D2: 7f0d             jg 0x18e1
  04D324  18D4: 8b46b6           mov ax, word ptr [bp - 0x4a]
  04D327  18D7: 8a4f01           mov cl, byte ptr [bx + 1]
  04D32A  18DA: 2aed             sub ch, ch
  04D32C  18DC: 2bc1             sub ax, cx
  04D32E  18DE: f7d0             not ax
  04D330  18E0: 40               inc ax
  04D331  18E1: 3d0100           cmp ax, 1
  04D334  18E4: 7e03             jle 0x18e9
  04D336  18E6: e96aff           jmp 0x1853
  04D339  18E9: ff46f4           inc word ptr [bp - 0xc]
  04D33C  18EC: e964ff           jmp 0x1853
  04D33F  18EF: 90               nop 
  04D340  18F0: 8b86a8fe         mov ax, word ptr [bp - 0x158]
  04D344  18F4: 3946f4           cmp word ptr [bp - 0xc], ax
  04D347  18F7: 7f03             jg 0x18fc
  04D349  18F9: e9cdfe           jmp 0x17c9
  04D34C  18FC: 8b46f4           mov ax, word ptr [bp - 0xc]
  04D34F  18FF: 8986a8fe         mov word ptr [bp - 0x158], ax
  04D353  1903: 8b46cc           mov ax, word ptr [bp - 0x34]
  04D356  1906: 8946de           mov word ptr [bp - 0x22], ax
  04D359  1909: 8b46c8           mov ax, word ptr [bp - 0x38]
  04D35C  190C: 8946d6           mov word ptr [bp - 0x2a], ax
  04D35F  190F: e9b7fe           jmp 0x17c9
  04D362  1912: ff46f8           inc word ptr [bp - 8]
  04D365  1915: 837ef802         cmp word ptr [bp - 8], 2
  04D369  1919: 7f09             jg 0x1924
  04D36B  191B: c746fcfeff       mov word ptr [bp - 4], 0xfffe
  04D370  1920: e9a9fe           jmp 0x17cc
  04D373  1923: 90               nop 
  04D374  1924: 83bea8fe00       cmp word ptr [bp - 0x158], 0
  04D379  1929: 7e2b             jle 0x1956
  04D37B  192B: 8b1e4285         mov bx, word ptr [0x8542]
  04D37F  192F: 8a471f           mov al, byte ptr [bx + 0x1f]
  04D382  1932: 98               cwde 
  04D383  1933: 050400           add ax, 4
  04D386  1936: c1f803           sar ax, 3
  04D389  1939: 3d0200           cmp ax, 2
  04D38C  193C: 7e03             jle 0x1941
  04D38E  193E: b80200           mov ax, 2
  04D391  1941: 40               inc ax
  04D392  1942: 40               inc ax
  04D393  1943: 50               push ax
  04D394  1944: 6a00             push 0
  04D396  1946: ff76d6           push word ptr [bp - 0x2a]
  04D399  1949: ff76de           push word ptr [bp - 0x22]
  04D39C  194C: ff7606           push word ptr [bp + 6]
  04D39F  194F: 0e               push cs
  04D3A0  1950: e81e61           call 0x7a71
  04D3A3  1953: 83c40a           add sp, 0xa
  04D3A6  1956: a0a653           mov al, byte ptr [0x53a6]
  04D3A9  1959: 2ae4             sub ah, ah
  04D3AB  195B: f72e8e53         imul word ptr [0x538e]
  04D3AF  195F: 3dc800           cmp ax, 0xc8
  04D3B2  1962: 7f2c             jg 0x1990
  04D3B4  1964: 837e0604         cmp word ptr [bp + 6], 4
  04D3B8  1968: 7d26             jge 0x1990
  04D3BA  196A: 8b1e4285         mov bx, word ptr [0x8542]
  04D3BE  196E: 8a4701           mov al, byte ptr [bx + 1]
  04D3C1  1971: 2ae4             sub ah, ah
  04D3C3  1973: 50               push ax
  04D3C4  1974: 8a07             mov al, byte ptr [bx]
  04D3C6  1976: 50               push ax
  04D3C7  1977: 9a4a071f18       lcall 0x181f, 0x74a
  04D3CC  197C: 83c404           add sp, 4
  04D3CF  197F: 2ae4             sub ah, ah
  04D3D1  1981: 8a4e06           mov cl, byte ptr [bp + 6]
  04D3D4  1984: ba1000           mov dx, 0x10
  04D3D7  1987: d3e2             shl dx, cl
  04D3D9  1989: 85c2             test dx, ax
  04D3DB  198B: 7503             jne 0x1990
  04D3DD  198D: e900fd           jmp 0x1690
  04D3E0  1990: 2bc0             sub ax, ax
  04D3E2  1992: 8946d4           mov word ptr [bp - 0x2c], ax
  04D3E5  1995: 898626fe         mov word ptr [bp - 0x1da], ax
  04D3E9  1999: 8b7606           mov si, word ptr [bp + 6]
  04D3EC  199C: c1e604           shl si, 4
  04D3EF  199F: 8b5eee           mov bx, word ptr [bp - 0x12]
  04D3F2  19A2: 8a80e694         mov al, byte ptr [bx + si - 0x6b1a]
  04D3F6  19A6: 8b364285         mov si, word ptr [0x8542]
  04D3FA  19AA: 8a4c1a           mov cl, byte ptr [si + 0x1a]
  04D3FD  19AD: 2aed             sub ch, ch
  04D3FF  19AF: c1e104           shl cx, 4
  04D402  19B2: 03d9             add bx, cx
  04D404  19B4: 3887e694         cmp byte ptr [bx - 0x6b1a], al
  04D408  19B8: 760c             jbe 0x19c6
  04D40A  19BA: 80bf269508       cmp byte ptr [bx - 0x6ada], 8
  04D40F  19BF: 7205             jb 0x19c6
  04D411  19C1: c746d40100       mov word ptr [bp - 0x2c], 1
  04D416  19C6: 8b7606           mov si, word ptr [bp + 6]
  04D419  19C9: c1e604           shl si, 4
  04D41C  19CC: 8b5eee           mov bx, word ptr [bp - 0x12]
  04D41F  19CF: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  04D424  19D4: 751b             jne 0x19f1
  04D426  19D6: 8b364285         mov si, word ptr [0x8542]
  04D42A  19DA: 8a441a           mov al, byte ptr [si + 0x1a]
  04D42D  19DD: 2ae4             sub ah, ah
  04D42F  19DF: 8bf0             mov si, ax
  04D431  19E1: c1e604           shl si, 4
  04D434  19E4: 80b8269508       cmp byte ptr [bx + si - 0x6ada], 8
  04D439  19E9: 7306             jae 0x19f1
  04D43B  19EB: c78626fe0100     mov word ptr [bp - 0x1da], 1
  04D441  19F1: 837ed400         cmp word ptr [bp - 0x2c], 0
  04D445  19F5: 750a             jne 0x1a01
  04D447  19F7: 83be26fe00       cmp word ptr [bp - 0x1da], 0
  04D44C  19FC: 7503             jne 0x1a01
  04D44E  19FE: e98ffc           jmp 0x1690
  04D451  1A01: c786a8fe9dff     mov word ptr [bp - 0x158], 0xff9d
  04D457  1A07: 8b1e4285         mov bx, word ptr [0x8542]
  04D45B  1A0B: 8a07             mov al, byte ptr [bx]
  04D45D  1A0D: 2ae4             sub ah, ah
  04D45F  1A0F: 8946de           mov word ptr [bp - 0x22], ax
  04D462  1A12: 8a4701           mov al, byte ptr [bx + 1]
  04D465  1A15: 8946d6           mov word ptr [bp - 0x2a], ax
  04D468  1A18: c746fcfdff       mov word ptr [bp - 4], 0xfffd
  04D46D  1A1D: e9f300           jmp 0x1b13
  04D470  1A20: 2bc0             sub ax, ax
  04D472  1A22: 8946fe           mov word ptr [bp - 2], ax
  04D475  1A25: 8946d2           mov word ptr [bp - 0x2e], ax
  04D478  1A28: eb40             jmp 0x1a6a
  04D47A  1A2A: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  04D47D  1A2D: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04D481  1A31: 98               cwde 
  04D482  1A32: 0346c8           add ax, word ptr [bp - 0x38]
  04D485  1A35: 8946b6           mov word ptr [bp - 0x4a], ax
  04D488  1A38: 50               push ax
  04D489  1A39: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04D48D  1A3D: 98               cwde 
  04D48E  1A3E: 0346cc           add ax, word ptr [bp - 0x34]
  04D491  1A41: 8946ce           mov word ptr [bp - 0x32], ax
  04D494  1A44: 50               push ax
  04D495  1A45: 9a68071f18       lcall 0x181f, 0x768
  04D49A  1A4A: 83c404           add sp, 4
  04D49D  1A4D: 0bc0             or ax, ax
  04D49F  1A4F: 7516             jne 0x1a67
  04D4A1  1A51: ff76b6           push word ptr [bp - 0x4a]
  04D4A4  1A54: ff76ce           push word ptr [bp - 0x32]
  04D4A7  1A57: 9a22071f18       lcall 0x181f, 0x722
  04D4AC  1A5C: 83c404           add sp, 4
  04D4AF  1A5F: 3b46ee           cmp ax, word ptr [bp - 0x12]
  04D4B2  1A62: 7503             jne 0x1a67
  04D4B4  1A64: ff46fe           inc word ptr [bp - 2]
  04D4B7  1A67: ff46d2           inc word ptr [bp - 0x2e]
  04D4BA  1A6A: 837ed208         cmp word ptr [bp - 0x2e], 8
  04D4BE  1A6E: 7cba             jl 0x1a2a
  04D4C0  1A70: 837efe00         cmp word ptr [bp - 2], 0
  04D4C4  1A74: 754a             jne 0x1ac0
  04D4C6  1A76: ff46f8           inc word ptr [bp - 8]
  04D4C9  1A79: 837ef803         cmp word ptr [bp - 8], 3
  04D4CD  1A7D: 7e03             jle 0x1a82
  04D4CF  1A7F: e98e00           jmp 0x1b10
  04D4D2  1A82: 8b1e4285         mov bx, word ptr [0x8542]
  04D4D6  1A86: 8a4701           mov al, byte ptr [bx + 1]
  04D4D9  1A89: 2ae4             sub ah, ah
  04D4DB  1A8B: 0346f8           add ax, word ptr [bp - 8]
  04D4DE  1A8E: 8946c8           mov word ptr [bp - 0x38], ax
  04D4E1  1A91: 50               push ax
  04D4E2  1A92: 8a07             mov al, byte ptr [bx]
  04D4E4  1A94: 2ae4             sub ah, ah
  04D4E6  1A96: 0346fc           add ax, word ptr [bp - 4]
  04D4E9  1A99: 8946cc           mov word ptr [bp - 0x34], ax
  04D4EC  1A9C: 50               push ax
  04D4ED  1A9D: 9a68071f18       lcall 0x181f, 0x768
  04D4F2  1AA2: 83c404           add sp, 4
  04D4F5  1AA5: 0bc0             or ax, ax
  04D4F7  1AA7: 74cd             je 0x1a76
  04D4F9  1AA9: ff76c8           push word ptr [bp - 0x38]
  04D4FC  1AAC: ff76cc           push word ptr [bp - 0x34]
  04D4FF  1AAF: 9ab4061f18       lcall 0x181f, 0x6b4
  04D504  1AB4: 83c404           add sp, 4
  04D507  1AB7: fec8             dec al
  04D509  1AB9: 7503             jne 0x1abe
  04D50B  1ABB: e962ff           jmp 0x1a20
  04D50E  1ABE: ebb6             jmp 0x1a76
  04D510  1AC0: 837efc00         cmp word ptr [bp - 4], 0
  04D514  1AC4: 7e06             jle 0x1acc
  04D516  1AC6: 8b46fc           mov ax, word ptr [bp - 4]
  04D519  1AC9: eb07             jmp 0x1ad2
  04D51B  1ACB: 90               nop 
  04D51C  1ACC: 8b46fc           mov ax, word ptr [bp - 4]
  04D51F  1ACF: f7d0             not ax
  04D521  1AD1: 40               inc ax
  04D522  1AD2: 89861cfe         mov word ptr [bp - 0x1e4], ax
  04D526  1AD6: 837ef800         cmp word ptr [bp - 8], 0
  04D52A  1ADA: 7e06             jle 0x1ae2
  04D52C  1ADC: 8b46f8           mov ax, word ptr [bp - 8]
  04D52F  1ADF: eb07             jmp 0x1ae8
  04D531  1AE1: 90               nop 
  04D532  1AE2: 8b46f8           mov ax, word ptr [bp - 8]
  04D535  1AE5: f7d0             not ax
  04D537  1AE7: 40               inc ax
  04D538  1AE8: 0346fe           add ax, word ptr [bp - 2]
  04D53B  1AEB: 03861cfe         add ax, word ptr [bp - 0x1e4]
  04D53F  1AEF: d1e0             shl ax, 1
  04D541  1AF1: 8946f4           mov word ptr [bp - 0xc], ax
  04D544  1AF4: 3b86a8fe         cmp ax, word ptr [bp - 0x158]
  04D548  1AF8: 7d03             jge 0x1afd
  04D54A  1AFA: e979ff           jmp 0x1a76
  04D54D  1AFD: 8986a8fe         mov word ptr [bp - 0x158], ax
  04D551  1B01: 8b46cc           mov ax, word ptr [bp - 0x34]
  04D554  1B04: 8946de           mov word ptr [bp - 0x22], ax
  04D557  1B07: 8b46c8           mov ax, word ptr [bp - 0x38]
  04D55A  1B0A: 8946d6           mov word ptr [bp - 0x2a], ax
  04D55D  1B0D: e966ff           jmp 0x1a76
  04D560  1B10: ff46fc           inc word ptr [bp - 4]
  04D563  1B13: 837efc03         cmp word ptr [bp - 4], 3
  04D567  1B17: 7f09             jg 0x1b22
  04D569  1B19: c746f8fdff       mov word ptr [bp - 8], 0xfffd
  04D56E  1B1E: e958ff           jmp 0x1a79
  04D571  1B21: 90               nop 
  04D572  1B22: 83bea8fe00       cmp word ptr [bp - 0x158], 0
  04D577  1B27: 7f03             jg 0x1b2c
  04D579  1B29: e964fb           jmp 0x1690
  04D57C  1B2C: ff76d6           push word ptr [bp - 0x2a]
  04D57F  1B2F: ff76de           push word ptr [bp - 0x22]
  04D582  1B32: 9a82061f18       lcall 0x181f, 0x682
  04D587  1B37: 83c404           add sp, 4
  04D58A  1B3A: 0bc0             or ax, ax
  04D58C  1B3C: 7c03             jl 0x1b41
  04D58E  1B3E: e94ffb           jmp 0x1690
  04D591  1B41: 837ed400         cmp word ptr [bp - 0x2c], 0
  04D595  1B45: 740f             je 0x1b56
  04D597  1B47: 8a4eee           mov cl, byte ptr [bp - 0x12]
  04D59A  1B4A: b80100           mov ax, 1
  04D59D  1B4D: d3e0             shl ax, cl
  04D59F  1B4F: 09063c17         or word ptr [0x173c], ax
  04D5A3  1B53: eb0d             jmp 0x1b62
  04D5A5  1B55: 90               nop 
  04D5A6  1B56: 8a4eee           mov cl, byte ptr [bp - 0x12]
  04D5A9  1B59: b80100           mov ax, 1
  04D5AC  1B5C: d3e0             shl ax, cl
  04D5AE  1B5E: 09063e17         or word ptr [0x173e], ax
  04D5B2  1B62: c746f40200       mov word ptr [bp - 0xc], 2
  04D5B7  1B67: 837ed400         cmp word ptr [bp - 0x2c], 0
  04D5BB  1B6B: 7405             je 0x1b72
  04D5BD  1B6D: c746f40300       mov word ptr [bp - 0xc], 3
  04D5C2  1B72: 8b1e4285         mov bx, word ptr [0x8542]
  04D5C6  1B76: 807f1a04         cmp byte ptr [bx + 0x1a], 4
  04D5CA  1B7A: 7354             jae 0x1bd0
  04D5CC  1B7C: 8a471a           mov al, byte ptr [bx + 0x1a]
  04D5CF  1B7F: 2ae4             sub ah, ah
  04D5D1  1B81: 6bd834           imul bx, ax, 0x34
  04D5D4  1B84: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  04D5D8  1B88: 7546             jne 0x1bd0
  04D5DA  1B8A: ff46f4           inc word ptr [bp - 0xc]
  04D5DD  1B8D: 8bf0             mov si, ax
  04D5DF  1B8F: c1e604           shl si, 4
  04D5E2  1B92: 8b5eee           mov bx, word ptr [bp - 0x12]
  04D5E5  1B95: 8a871695         mov al, byte ptr [bx - 0x6aea]
  04D5E9  1B99: 8a8f0695         mov cl, byte ptr [bx - 0x6afa]
  04D5ED  1B9D: 2aed             sub ch, ch
  04D5EF  1B9F: 03c1             add ax, cx
  04D5F1  1BA1: 8a8ff694         mov cl, byte ptr [bx - 0x6b0a]
  04D5F5  1BA5: 03c1             add ax, cx
  04D5F7  1BA7: 8a8fe694         mov cl, byte ptr [bx - 0x6b1a]
  04D5FB  1BAB: 03c1             add ax, cx
  04D5FD  1BAD: 8a88e694         mov cl, byte ptr [bx + si - 0x6b1a]
  04D601  1BB1: 3bc1             cmp ax, cx
  04D603  1BB3: 751b             jne 0x1bd0
  04D605  1BB5: d1e3             shl bx, 1
  04D607  1BB7: 83bfc88510       cmp word ptr [bx - 0x7a38], 0x10
  04D60C  1BBC: 7c03             jl 0x1bc1
  04D60E  1BBE: ff46f4           inc word ptr [bp - 0xc]
  04D611  1BC1: 8b5eee           mov bx, word ptr [bp - 0x12]
  04D614  1BC4: d1e3             shl bx, 1
  04D616  1BC6: 83bfc88540       cmp word ptr [bx - 0x7a38], 0x40
  04D61B  1BCB: 7c03             jl 0x1bd0
  04D61D  1BCD: ff46f4           inc word ptr [bp - 0xc]
  04D620  1BD0: 8b5eee           mov bx, word ptr [bp - 0x12]
  04D623  1BD3: 8a871695         mov al, byte ptr [bx - 0x6aea]
  04D627  1BD7: 2ae4             sub ah, ah
  04D629  1BD9: 8a8f0695         mov cl, byte ptr [bx - 0x6afa]
  04D62D  1BDD: 2aed             sub ch, ch
  04D62F  1BDF: 03c1             add ax, cx
  04D631  1BE1: 8a8ff694         mov cl, byte ptr [bx - 0x6b0a]
  04D635  1BE5: 03c1             add ax, cx
  04D637  1BE7: 8a8fe694         mov cl, byte ptr [bx - 0x6b1a]
  04D63B  1BEB: 03c1             add ax, cx
  04D63D  1BED: c1e004           shl ax, 4
  04D640  1BF0: d1e3             shl bx, 1
  04D642  1BF2: 3b87c885         cmp ax, word ptr [bx - 0x7a38]
  04D646  1BF6: 7e03             jle 0x1bfb
  04D648  1BF8: ff4ef4           dec word ptr [bp - 0xc]
  04D64B  1BFB: 8b1e4285         mov bx, word ptr [0x8542]
  04D64F  1BFF: 8a471a           mov al, byte ptr [bx + 0x1a]
  04D652  1C02: 2ae4             sub ah, ah
  04D654  1C04: 50               push ax
  04D655  1C05: ff7606           push word ptr [bp + 6]
  04D658  1C08: 9a380a1f18       lcall 0x181f, 0xa38
  04D65D  1C0D: 83c404           add sp, 4
  04D660  1C10: 2460             and al, 0x60
  04D662  1C12: 3c20             cmp al, 0x20
  04D664  1C14: 7503             jne 0x1c19
  04D666  1C16: ff46f4           inc word ptr [bp - 0xc]
  04D669  1C19: 813e8e539600     cmp word ptr [0x538e], 0x96
  04D66F  1C1F: 7d03             jge 0x1c24
  04D671  1C21: d166f4           shl word ptr [bp - 0xc], 1
  04D674  1C24: 8b1e4285         mov bx, word ptr [0x8542]
  04D678  1C28: 8a07             mov al, byte ptr [bx]
  04D67A  1C2A: 2ae4             sub ah, ah
  04D67C  1C2C: 8a5701           mov dl, byte ptr [bx + 1]
  04D67F  1C2F: 2af6             sub dh, dh
  04D681  1C31: 9ae0071f18       lcall 0x181f, 0x7e0
  04D686  1C36: 8986aefe         mov word ptr [bp - 0x152], ax
  04D68A  1C3A: 6a02             push 2
  04D68C  1C3C: 50               push ax
  04D68D  1C3D: 9abc081f18       lcall 0x181f, 0x8bc
  04D692  1C42: 83c404           add sp, 4
  04D695  1C45: 8b1e4285         mov bx, word ptr [0x8542]
  04D699  1C49: 8bc8             mov cx, ax
  04D69B  1C4B: 8a471f           mov al, byte ptr [bx + 0x1f]
  04D69E  1C4E: 98               cwde 
  04D69F  1C4F: 03c8             add cx, ax
  04D6A1  1C51: 894ef2           mov word ptr [bp - 0xe], cx
  04D6A4  1C54: a18e53           mov ax, word ptr [0x538e]
  04D6A7  1C57: b9ceff           mov cx, 0xffce
  04D6AA  1C5A: 99               cdq 
  04D6AB  1C5B: f7f9             idiv cx
  04D6AD  1C5D: 050600           add ax, 6
  04D6B0  1C60: 3b46f2           cmp ax, word ptr [bp - 0xe]
  04D6B3  1C63: 7c09             jl 0x1c6e
  04D6B5  1C65: 2bc0             sub ax, ax
  04D6B7  1C67: 8946d4           mov word ptr [bp - 0x2c], ax
  04D6BA  1C6A: 898626fe         mov word ptr [bp - 0x1da], ax
  04D6BE  1C6E: 837ed400         cmp word ptr [bp - 0x2c], 0
  04D6C2  1C72: 750a             jne 0x1c7e
  04D6C4  1C74: 83be26fe00       cmp word ptr [bp - 0x1da], 0
  04D6C9  1C79: 7503             jne 0x1c7e
  04D6CB  1C7B: e912fa           jmp 0x1690
  04D6CE  1C7E: ff76f4           push word ptr [bp - 0xc]
  04D6D1  1C81: 837ed401         cmp word ptr [bp - 0x2c], 1
  04D6D5  1C85: 1bc0             sbb ax, ax
  04D6D7  1C87: 24fa             and al, 0xfa
  04D6D9  1C89: 050700           add ax, 7
  04D6DC  1C8C: 50               push ax
  04D6DD  1C8D: ff76d6           push word ptr [bp - 0x2a]
  04D6E0  1C90: ff76de           push word ptr [bp - 0x22]
  04D6E3  1C93: ff7606           push word ptr [bp + 6]
  04D6E6  1C96: 0e               push cs
  04D6E7  1C97: e8d75d           call 0x7a71
  04D6EA  1C9A: 83c40a           add sp, 0xa
  04D6ED  1C9D: e9f0f9           jmp 0x1690
  04D6F0  1CA0: 8a4701           mov al, byte ptr [bx + 1]
  04D6F3  1CA3: c0e802           shr al, 2
  04D6F6  1CA6: 2ae4             sub ah, ah
  04D6F8  1CA8: 8bf0             mov si, ax
  04D6FA  1CAA: 8a07             mov al, byte ptr [bx]
  04D6FC  1CAC: c0e802           shr al, 2
  04D6FF  1CAF: 6bd812           imul bx, ax, 0x12
  04D702  1CB2: 8088aa9f02       or byte ptr [bx + si - 0x6056], 2
  04D707  1CB7: 695ec4ca00       imul bx, word ptr [bp - 0x3c], 0xca
  04D70C  1CBC: f687625d40       test byte ptr [bx + 0x5d62], 0x40
  04D711  1CC1: 7503             jne 0x1cc6
  04D713  1CC3: e9caf9           jmp 0x1690
  04D716  1CC6: 8b1e4285         mov bx, word ptr [0x8542]
  04D71A  1CCA: f6471b03         test byte ptr [bx + 0x1b], 3
  04D71E  1CCE: 7424             je 0x1cf4
  04D720  1CD0: 8a471b           mov al, byte ptr [bx + 0x1b]
  04D723  1CD3: 2402             and al, 2
  04D725  1CD5: 3c01             cmp al, 1
  04D727  1CD7: 1bc0             sbb ax, ax
  04D729  1CD9: 24fd             and al, 0xfd
  04D72B  1CDB: 050800           add ax, 8
  04D72E  1CDE: 50               push ax
  04D72F  1CDF: 6a00             push 0
  04D731  1CE1: 8a4701           mov al, byte ptr [bx + 1]
  04D734  1CE4: 2ae4             sub ah, ah
  04D736  1CE6: 50               push ax
  04D737  1CE7: 8a07             mov al, byte ptr [bx]
  04D739  1CE9: 50               push ax
  04D73A  1CEA: ff7606           push word ptr [bp + 6]
  04D73D  1CED: 0e               push cs
  04D73E  1CEE: e8805d           call 0x7a71
  04D741  1CF1: 83c40a           add sp, 0xa
  04D744  1CF4: 2bc0             sub ax, ax
  04D746  1CF6: 8946ea           mov word ptr [bp - 0x16], ax
  04D749  1CF9: 8946e8           mov word ptr [bp - 0x18], ax
  04D74C  1CFC: 8946c2           mov word ptr [bp - 0x3e], ax
  04D74F  1CFF: 8946be           mov word ptr [bp - 0x42], ax
  04D752  1D02: 898622fe         mov word ptr [bp - 0x1de], ax
  04D756  1D06: 9a3a0d1f18       lcall 0x181f, 0xd3a
  04D75B  1D0B: 8946ba           mov word ptr [bp - 0x46], ax
  04D75E  1D0E: 8b1e4285         mov bx, word ptr [0x8542]
  04D762  1D12: 8a4701           mov al, byte ptr [bx + 1]
  04D765  1D15: 2ae4             sub ah, ah
  04D767  1D17: 50               push ax
  04D768  1D18: 8a07             mov al, byte ptr [bx]
  04D76A  1D1A: 50               push ax
  04D76B  1D1B: 9a22071f18       lcall 0x181f, 0x722
  04D770  1D20: 83c404           add sp, 4
  04D773  1D23: 8946ee           mov word ptr [bp - 0x12], ax
  04D776  1D26: 8b1e4285         mov bx, word ptr [0x8542]
  04D77A  1D2A: 8a07             mov al, byte ptr [bx]
  04D77C  1D2C: 2ae4             sub ah, ah
  04D77E  1D2E: 8a5701           mov dl, byte ptr [bx + 1]
  04D781  1D31: 2af6             sub dh, dh
  04D783  1D33: 9ae0071f18       lcall 0x181f, 0x7e0
  04D788  1D38: 8946ec           mov word ptr [bp - 0x14], ax
  04D78B  1D3B: e99400           jmp 0x1dd2
  04D78E  1D3E: 6bd81c           imul bx, ax, 0x1c
  04D791  1D41: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  04D796  1D46: 751c             jne 0x1d64
  04D798  1D48: 8b1e4285         mov bx, word ptr [0x8542]
  04D79C  1D4C: f6471b80         test byte ptr [bx + 0x1b], 0x80
  04D7A0  1D50: 7512             jne 0x1d64
  04D7A2  1D52: ff46c2           inc word ptr [bp - 0x3e]
  04D7A5  1D55: c78622fe0100     mov word ptr [bp - 0x1de], 1
  04D7AB  1D5B: 8146e82003       add word ptr [bp - 0x18], 0x320
  04D7B0  1D60: 8356ea00         adc word ptr [bp - 0x16], 0
  04D7B4  1D64: 8b7606           mov si, word ptr [bp + 6]
  04D7B7  1D67: c1e604           shl si, 4
  04D7BA  1D6A: 8b5eee           mov bx, word ptr [bp - 0x12]
  04D7BD  1D6D: 80b8709800       cmp byte ptr [bx + si - 0x6790], 0
  04D7C2  1D72: 7555             jne 0x1dc9
  04D7C4  1D74: 6bd81c           imul bx, ax, 0x1c
  04D7C7  1D77: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04D7CC  1D7C: 7207             jb 0x1d85
  04D7CE  1D7E: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04D7D3  1D83: 7644             jbe 0x1dc9
  04D7D5  1D85: 6bd81c           imul bx, ax, 0x1c
  04D7D8  1D88: 8bc3             mov ax, bx
  04D7DA  1D8A: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04D7DE  1D8E: 2aff             sub bh, bh
  04D7E0  1D90: 8bcb             mov cx, bx
  04D7E2  1D92: d1e3             shl bx, 1
  04D7E4  1D94: 03d9             add bx, cx
  04D7E6  1D96: d1e3             shl bx, 1
  04D7E8  1D98: 03d9             add bx, cx
  04D7EA  1D9A: d1e3             shl bx, 1
  04D7EC  1D9C: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  04D7F1  1DA1: 7626             jbe 0x1dc9
  04D7F3  1DA3: 8bd8             mov bx, ax
  04D7F5  1DA5: 80bf4b3147       cmp byte ptr [bx + 0x314b], 0x47
  04D7FA  1DAA: 741d             je 0x1dc9
  04D7FC  1DAC: 80bf4b3141       cmp byte ptr [bx + 0x314b], 0x41
  04D801  1DB1: 7416             je 0x1dc9
  04D803  1DB3: b80100           mov ax, 1
  04D806  1DB6: 8946be           mov word ptr [bp - 0x42], ax
  04D809  1DB9: 898622fe         mov word ptr [bp - 0x1de], ax
  04D80D  1DBD: 8146e8dc05       add word ptr [bp - 0x18], 0x5dc
  04D812  1DC2: 8356ea00         adc word ptr [bp - 0x16], 0
  04D816  1DC6: ff46c2           inc word ptr [bp - 0x3e]
  04D819  1DC9: 8b86aefe         mov ax, word ptr [bp - 0x152]
  04D81D  1DCD: 9ae4021f18       lcall 0x181f, 0x2e4
  04D822  1DD2: 8986aefe         mov word ptr [bp - 0x152], ax
  04D826  1DD6: 0bc0             or ax, ax
  04D828  1DD8: 7c03             jl 0x1ddd
  04D82A  1DDA: e961ff           jmp 0x1d3e
  04D82D  1DDD: c786b2fe0000     mov word ptr [bp - 0x14e], 0
  04D833  1DE3: eb3c             jmp 0x1e21
  04D835  1DE5: 90               nop 
  04D836  1DE6: 83beb2fe08       cmp word ptr [bp - 0x14e], 8
  04D83B  1DEB: 7515             jne 0x1e02
  04D83D  1DED: b81900           mov ax, 0x19
  04D840  1DF0: 2b46ba           sub ax, word ptr [bp - 0x46]
  04D843  1DF3: 0146d8           add word ptr [bp - 0x28], ax
  04D846  1DF6: 8b46d8           mov ax, word ptr [bp - 0x28]
  04D849  1DF9: 0bc0             or ax, ax
  04D84B  1DFB: 7d02             jge 0x1dff
  04D84D  1DFD: 2bc0             sub ax, ax
  04D84F  1DFF: 8946d8           mov word ptr [bp - 0x28], ax
  04D852  1E02: 3b46ba           cmp ax, word ptr [bp - 0x46]
  04D855  1E05: 7e03             jle 0x1e0a
  04D857  1E07: 8b46ba           mov ax, word ptr [bp - 0x46]
  04D85A  1E0A: 051900           add ax, 0x19
  04D85D  1E0D: b96400           mov cx, 0x64
  04D860  1E10: 99               cdq 
  04D861  1E11: f7f9             idiv cx
  04D863  1E13: 8946d0           mov word ptr [bp - 0x30], ax
  04D866  1E16: 83beb2fe00       cmp word ptr [bp - 0x14e], 0
  04D86B  1E1B: 752b             jne 0x1e48
  04D86D  1E1D: ff86b2fe         inc word ptr [bp - 0x14e]
  04D871  1E21: 83beb2fe10       cmp word ptr [bp - 0x14e], 0x10
  04D876  1E26: 7c03             jl 0x1e2b
  04D878  1E28: e98100           jmp 0x1eac
  04D87B  1E2B: 8bb6b2fe         mov si, word ptr [bp - 0x14e]
  04D87F  1E2F: d1e6             shl si, 1
  04D881  1E31: 8b1e4285         mov bx, word ptr [0x8542]
  04D885  1E35: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  04D889  1E39: 8946d8           mov word ptr [bp - 0x28], ax
  04D88C  1E3C: 3b46ba           cmp ax, word ptr [bp - 0x46]
  04D88F  1E3F: 7ca5             jl 0x1de6
  04D891  1E41: d1e0             shl ax, 1
  04D893  1E43: ebba             jmp 0x1dff
  04D895  1E45: 90               nop 
  04D896  1E46: 90               nop 
  04D897  1E47: 90               nop 
  04D898  1E48: 83beb2fe05       cmp word ptr [bp - 0x14e], 5
  04D89D  1E4D: 74ce             je 0x1e1d
  04D89F  1E4F: 83beb2fe0d       cmp word ptr [bp - 0x14e], 0xd
  04D8A4  1E54: 74c7             je 0x1e1d
  04D8A6  1E56: 83beb2fe0e       cmp word ptr [bp - 0x14e], 0xe
  04D8AB  1E5B: 7407             je 0x1e64
  04D8AD  1E5D: 83beb2fe0f       cmp word ptr [bp - 0x14e], 0xf
  04D8B2  1E62: 7513             jne 0x1e77
  04D8B4  1E64: 8a8eb2fe         mov cl, byte ptr [bp - 0x14e]
  04D8B8  1E68: b80100           mov ax, 1
  04D8BB  1E6B: d3e0             shl ax, cl
  04D8BD  1E6D: 85879000         test word ptr [bx + 0x90], ax
  04D8C1  1E71: 74aa             je 0x1e1d
  04D8C3  1E73: 836ed864         sub word ptr [bp - 0x28], 0x64
  04D8C7  1E77: 837ed84b         cmp word ptr [bp - 0x28], 0x4b
  04D8CB  1E7B: 7c06             jl 0x1e83
  04D8CD  1E7D: c78622fe0100     mov word ptr [bp - 0x1de], 1
  04D8D3  1E83: 837ed800         cmp word ptr [bp - 0x28], 0
  04D8D7  1E87: 7c94             jl 0x1e1d
  04D8D9  1E89: 8b7606           mov si, word ptr [bp + 6]
  04D8DC  1E8C: c1e604           shl si, 4
  04D8DF  1E8F: 8b9eb2fe         mov bx, word ptr [bp - 0x14e]
  04D8E3  1E93: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  04D8E7  1E97: 2ae4             sub ah, ah
  04D8E9  1E99: f76ed8           imul word ptr [bp - 0x28]
  04D8EC  1E9C: 0146e8           add word ptr [bp - 0x18], ax
  04D8EF  1E9F: 1156ea           adc word ptr [bp - 0x16], dx
  04D8F2  1EA2: 8b46d0           mov ax, word ptr [bp - 0x30]
  04D8F5  1EA5: 0146c2           add word ptr [bp - 0x3e], ax
  04D8F8  1EA8: e972ff           jmp 0x1e1d
  04D8FB  1EAB: 90               nop 
  04D8FC  1EAC: 83be22fe00       cmp word ptr [bp - 0x1de], 0
  04D901  1EB1: 7449             je 0x1efc
  04D903  1EB3: 8b5e06           mov bx, word ptr [bp + 6]
  04D906  1EB6: d1e3             shl bx, 1
  04D908  1EB8: ff873417         inc word ptr [bx + 0x1734]
  04D90C  1EBC: ff76be           push word ptr [bp - 0x42]
  04D90F  1EBF: ff76c2           push word ptr [bp - 0x3e]
  04D912  1EC2: 8b1e4285         mov bx, word ptr [0x8542]
  04D916  1EC6: 8a878f00         mov al, byte ptr [bx + 0x8f]
  04D91A  1ECA: 98               cwde 
  04D91B  1ECB: c1e003           shl ax, 3
  04D91E  1ECE: 99               cdq 
  04D91F  1ECF: 0146e8           add word ptr [bp - 0x18], ax
  04D922  1ED2: 1156ea           adc word ptr [bp - 0x16], dx
  04D925  1ED5: 8b46e8           mov ax, word ptr [bp - 0x18]
  04D928  1ED8: 8b56ea           mov dx, word ptr [bp - 0x16]
  04D92B  1EDB: 0bd2             or dx, dx
  04D92D  1EDD: 7c0c             jl 0x1eeb
  04D92F  1EDF: 7f05             jg 0x1ee6
  04D931  1EE1: 3dff7f           cmp ax, 0x7fff
  04D934  1EE4: 7605             jbe 0x1eeb
  04D936  1EE6: 2bd2             sub dx, dx
  04D938  1EE8: b8ff7f           mov ax, 0x7fff
  04D93B  1EEB: 8946e8           mov word ptr [bp - 0x18], ax
  04D93E  1EEE: 8956ea           mov word ptr [bp - 0x16], dx
  04D941  1EF1: 50               push ax
  04D942  1EF2: ff76c4           push word ptr [bp - 0x3c]
  04D945  1EF5: 0e               push cs
  04D946  1EF6: e8c35b           call 0x7abc
  04D949  1EF9: 83c408           add sp, 8
  04D94C  1EFC: 8b1e4285         mov bx, word ptr [0x8542]
  04D950  1F00: 80bf8e0000       cmp byte ptr [bx + 0x8e], 0
  04D955  1F05: 7f03             jg 0x1f0a
  04D957  1F07: e986f7           jmp 0x1690
  04D95A  1F0A: 6a0a             push 0xa
  04D95C  1F0C: ff76ec           push word ptr [bp - 0x14]
  04D95F  1F0F: 9abc081f18       lcall 0x181f, 0x8bc
  04D964  1F14: 83c404           add sp, 4
  04D967  1F17: 8946da           mov word ptr [bp - 0x26], ax
  04D96A  1F1A: 8b1e4285         mov bx, word ptr [0x8542]
  04D96E  1F1E: 8a878e00         mov al, byte ptr [bx + 0x8e]
  04D972  1F22: 98               cwde 
  04D973  1F23: 3b46da           cmp ax, word ptr [bp - 0x26]
  04D976  1F26: 7e31             jle 0x1f59
  04D978  1F28: 8a4e06           mov cl, byte ptr [bp + 6]
  04D97B  1F2B: 89861efe         mov word ptr [bp - 0x1e2], ax
  04D97F  1F2F: 384f1a           cmp byte ptr [bx + 0x1a], cl
  04D982  1F32: 7508             jne 0x1f3c
  04D984  1F34: 2b46da           sub ax, word ptr [bp - 0x26]
  04D987  1F37: 40               inc ax
  04D988  1F38: 40               inc ax
  04D989  1F39: eb04             jmp 0x1f3f
  04D98B  1F3B: 90               nop 
  04D98C  1F3C: b80200           mov ax, 2
  04D98F  1F3F: 89861cfe         mov word ptr [bp - 0x1e4], ax
  04D993  1F43: 50               push ax
  04D994  1F44: 6a03             push 3
  04D996  1F46: 8a4701           mov al, byte ptr [bx + 1]
  04D999  1F49: 2ae4             sub ah, ah
  04D99B  1F4B: 50               push ax
  04D99C  1F4C: 8a07             mov al, byte ptr [bx]
  04D99E  1F4E: 50               push ax
  04D99F  1F4F: ff7606           push word ptr [bp + 6]
  04D9A2  1F52: 0e               push cs
  04D9A3  1F53: e81b5b           call 0x7a71
  04D9A6  1F56: 83c40a           add sp, 0xa
  04D9A9  1F59: 8b46ec           mov ax, word ptr [bp - 0x14]
  04D9AC  1F5C: eb35             jmp 0x1f93
  04D9AE  1F5E: 8b1e4285         mov bx, word ptr [0x8542]
  04D9B2  1F62: 80bf8e0000       cmp byte ptr [bx + 0x8e], 0
  04D9B7  1F67: 7e32             jle 0x1f9b
  04D9B9  1F69: 6bf01c           imul si, ax, 0x1c
  04D9BC  1F6C: 80bc46310b       cmp byte ptr [si + 0x3146], 0xb
  04D9C1  1F71: 7517             jne 0x1f8a
  04D9C3  1F73: fe8f8e00         dec byte ptr [bx + 0x8e]
  04D9C7  1F77: 807f1e00         cmp byte ptr [bx + 0x1e], 0
  04D9CB  1F7B: 7403             je 0x1f80
  04D9CD  1F7D: fe4f1e           dec byte ptr [bx + 0x1e]
  04D9D0  1F80: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04D9D5  1F85: c6874b3141       mov byte ptr [bx + 0x314b], 0x41
  04D9DA  1F8A: 8b86aefe         mov ax, word ptr [bp - 0x152]
  04D9DE  1F8E: 9ae4021f18       lcall 0x181f, 0x2e4
  04D9E3  1F93: 8986aefe         mov word ptr [bp - 0x152], ax
  04D9E7  1F97: 0bc0             or ax, ax
  04D9E9  1F99: 7dc3             jge 0x1f5e
  04D9EB  1F9B: 8b46ec           mov ax, word ptr [bp - 0x14]
  04D9EE  1F9E: eb3c             jmp 0x1fdc
  04D9F0  1FA0: 8b1e4285         mov bx, word ptr [0x8542]
  04D9F4  1FA4: 80bf8e0000       cmp byte ptr [bx + 0x8e], 0
  04D9F9  1FA9: 7e39             jle 0x1fe4
  04D9FB  1FAB: 6bf01c           imul si, ax, 0x1c
  04D9FE  1FAE: 80bc463101       cmp byte ptr [si + 0x3146], 1
  04DA03  1FB3: 751e             jne 0x1fd3
  04DA05  1FB5: 80bc5b3115       cmp byte ptr [si + 0x315b], 0x15
  04DA0A  1FBA: 7417             je 0x1fd3
  04DA0C  1FBC: fe8f8e00         dec byte ptr [bx + 0x8e]
  04DA10  1FC0: 807f1e00         cmp byte ptr [bx + 0x1e], 0
  04DA14  1FC4: 7403             je 0x1fc9
  04DA16  1FC6: fe4f1e           dec byte ptr [bx + 0x1e]
  04DA19  1FC9: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04DA1E  1FCE: c6874b3141       mov byte ptr [bx + 0x314b], 0x41
  04DA23  1FD3: 8b86aefe         mov ax, word ptr [bp - 0x152]
  04DA27  1FD7: 9ae4021f18       lcall 0x181f, 0x2e4
  04DA2C  1FDC: 8986aefe         mov word ptr [bp - 0x152], ax
  04DA30  1FE0: 0bc0             or ax, ax
  04DA32  1FE2: 7dbc             jge 0x1fa0
  04DA34  1FE4: 8b46ec           mov ax, word ptr [bp - 0x14]
  04DA37  1FE7: eb3d             jmp 0x2026
  04DA39  1FE9: 90               nop 
  04DA3A  1FEA: 8b1e4285         mov bx, word ptr [0x8542]
  04DA3E  1FEE: 80bf8e0000       cmp byte ptr [bx + 0x8e], 0
  04DA43  1FF3: 7e39             jle 0x202e
  04DA45  1FF5: 6bf01c           imul si, ax, 0x1c
  04DA48  1FF8: 80bc463101       cmp byte ptr [si + 0x3146], 1
  04DA4D  1FFD: 751e             jne 0x201d
  04DA4F  1FFF: 80bc5b3115       cmp byte ptr [si + 0x315b], 0x15
  04DA54  2004: 7517             jne 0x201d
  04DA56  2006: fe8f8e00         dec byte ptr [bx + 0x8e]
  04DA5A  200A: 807f1e00         cmp byte ptr [bx + 0x1e], 0
  04DA5E  200E: 7403             je 0x2013
  04DA60  2010: fe4f1e           dec byte ptr [bx + 0x1e]
  04DA63  2013: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04DA68  2018: c6874b3141       mov byte ptr [bx + 0x314b], 0x41
  04DA6D  201D: 8b86aefe         mov ax, word ptr [bp - 0x152]
  04DA71  2021: 9ae4021f18       lcall 0x181f, 0x2e4
  04DA76  2026: 8986aefe         mov word ptr [bp - 0x152], ax
  04DA7A  202A: 0bc0             or ax, ax
  04DA7C  202C: 7dbc             jge 0x1fea
  04DA7E  202E: 8b46ec           mov ax, word ptr [bp - 0x14]
  04DA81  2031: eb3d             jmp 0x2070
  04DA83  2033: 90               nop 
  04DA84  2034: 8b1e4285         mov bx, word ptr [0x8542]
  04DA88  2038: 80bf8e0000       cmp byte ptr [bx + 0x8e], 0
  04DA8D  203D: 7e39             jle 0x2078
  04DA8F  203F: 6bf01c           imul si, ax, 0x1c
  04DA92  2042: 80bc463104       cmp byte ptr [si + 0x3146], 4
  04DA97  2047: 751e             jne 0x2067
  04DA99  2049: 80bc5b3115       cmp byte ptr [si + 0x315b], 0x15
  04DA9E  204E: 7417             je 0x2067
  04DAA0  2050: fe8f8e00         dec byte ptr [bx + 0x8e]
  04DAA4  2054: 807f1e00         cmp byte ptr [bx + 0x1e], 0
  04DAA8  2058: 7403             je 0x205d
  04DAAA  205A: fe4f1e           dec byte ptr [bx + 0x1e]
  04DAAD  205D: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04DAB2  2062: c6874b3141       mov byte ptr [bx + 0x314b], 0x41
  04DAB7  2067: 8b86aefe         mov ax, word ptr [bp - 0x152]
  04DABB  206B: 9ae4021f18       lcall 0x181f, 0x2e4
  04DAC0  2070: 8986aefe         mov word ptr [bp - 0x152], ax
  04DAC4  2074: 0bc0             or ax, ax
  04DAC6  2076: 7dbc             jge 0x2034
  04DAC8  2078: 8b46ec           mov ax, word ptr [bp - 0x14]
  04DACB  207B: eb0a             jmp 0x2087
  04DACD  207D: 90               nop 
  04DACE  207E: 8b86aefe         mov ax, word ptr [bp - 0x152]
  04DAD2  2082: 9ae4021f18       lcall 0x181f, 0x2e4
  04DAD7  2087: 8986aefe         mov word ptr [bp - 0x152], ax
  04DADB  208B: 0bc0             or ax, ax
  04DADD  208D: 7d03             jge 0x2092
  04DADF  208F: e9fef5           jmp 0x1690
  04DAE2  2092: 8b1e4285         mov bx, word ptr [0x8542]
  04DAE6  2096: 80bf8e0000       cmp byte ptr [bx + 0x8e], 0
  04DAEB  209B: 7f03             jg 0x20a0
  04DAED  209D: e9f0f5           jmp 0x1690
  04DAF0  20A0: 6bf01c           imul si, ax, 0x1c
  04DAF3  20A3: 80bc463104       cmp byte ptr [si + 0x3146], 4
  04DAF8  20A8: 75d4             jne 0x207e
  04DAFA  20AA: 80bc5b3115       cmp byte ptr [si + 0x315b], 0x15
  04DAFF  20AF: 75cd             jne 0x207e
  04DB01  20B1: fe8f8e00         dec byte ptr [bx + 0x8e]
  04DB05  20B5: 807f1e00         cmp byte ptr [bx + 0x1e], 0
  04DB09  20B9: 7403             je 0x20be
  04DB0B  20BB: fe4f1e           dec byte ptr [bx + 0x1e]
  04DB0E  20BE: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04DB13  20C3: c6874b3141       mov byte ptr [bx + 0x314b], 0x41
  04DB18  20C8: ebb4             jmp 0x207e
  04DB1A  20CA: c746c40000       mov word ptr [bp - 0x3c], 0
  04DB1F  20CF: eb2e             jmp 0x20ff
  04DB21  20D1: 90               nop 
  04DB22  20D2: b80200           mov ax, 2
  04DB25  20D5: 50               push ax
  04DB26  20D6: 6a04             push 4
  04DB28  20D8: 8a4701           mov al, byte ptr [bx + 1]
  04DB2B  20DB: 2ae4             sub ah, ah
  04DB2D  20DD: 50               push ax
  04DB2E  20DE: 8a07             mov al, byte ptr [bx]
  04DB30  20E0: 50               push ax
  04DB31  20E1: ff7606           push word ptr [bp + 6]
  04DB34  20E4: 0e               push cs
  04DB35  20E5: e88959           call 0x7a71
  04DB38  20E8: 83c40a           add sp, 0xa
  04DB3B  20EB: 8a4eee           mov cl, byte ptr [bp - 0x12]
  04DB3E  20EE: b80100           mov ax, 1
  04DB41  20F1: d3e0             shl ax, cl
  04DB43  20F3: 85063c17         test word ptr [0x173c], ax
  04DB47  20F7: 7503             jne 0x20fc
  04DB49  20F9: e9a800           jmp 0x21a4
  04DB4C  20FC: ff46c4           inc word ptr [bp - 0x3c]
  04DB4F  20FF: a19a53           mov ax, word ptr [0x539a]
  04DB52  2102: 3946c4           cmp word ptr [bp - 0x3c], ax
  04DB55  2105: 7c03             jl 0x210a
  04DB57  2107: e9b601           jmp 0x22c0
  04DB5A  210A: ff76c4           push word ptr [bp - 0x3c]
  04DB5D  210D: 9a4c0a1f18       lcall 0x181f, 0xa4c
  04DB62  2112: 83c402           add sp, 2
  04DB65  2115: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04DB69  2119: 8a4701           mov al, byte ptr [bx + 1]
  04DB6C  211C: 2ae4             sub ah, ah
  04DB6E  211E: 50               push ax
  04DB6F  211F: 8a07             mov al, byte ptr [bx]
  04DB71  2121: 50               push ax
  04DB72  2122: 9a22071f18       lcall 0x181f, 0x722
  04DB77  2127: 83c404           add sp, 4
  04DB7A  212A: 8946ee           mov word ptr [bp - 0x12], ax
  04DB7D  212D: ff7606           push word ptr [bp + 6]
  04DB80  2130: ff36528d         push word ptr [0x8d52]
  04DB84  2134: 9a0c031f18       lcall 0x181f, 0x30c
  04DB89  2139: 83c404           add sp, 4
  04DB8C  213C: 898624fe         mov word ptr [bp - 0x1dc], ax
  04DB90  2140: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04DB94  2144: 8a4704           mov al, byte ptr [bx + 4]
  04DB97  2147: 2ae4             sub ah, ah
  04DB99  2149: 8b36528d         mov si, word ptr [0x8d52]
  04DB9D  214D: c1e604           shl si, 4
  04DBA0  2150: 0376ee           add si, word ptr [bp - 0x12]
  04DBA3  2153: d1e6             shl si, 1
  04DBA5  2155: 0182b4fe         add word ptr [bp + si - 0x14c], ax
  04DBA9  2159: 8b5e06           mov bx, word ptr [bp + 6]
  04DBAC  215C: c1e304           shl bx, 4
  04DBAF  215F: 035eee           add bx, word ptr [bp - 0x12]
  04DBB2  2162: 8a87e694         mov al, byte ptr [bx - 0x6b1a]
  04DBB6  2166: 8a8fa694         mov cl, byte ptr [bx - 0x6b5a]
  04DBBA  216A: 2aed             sub ch, ch
  04DBBC  216C: 03c1             add ax, cx
  04DBBE  216E: 7503             jne 0x2173
  04DBC0  2170: e978ff           jmp 0x20eb
  04DBC3  2173: 83be24fe4b       cmp word ptr [bp - 0x1dc], 0x4b
  04DBC8  2178: 7d16             jge 0x2190
  04DBCA  217A: ff36508d         push word ptr [0x8d50]
  04DBCE  217E: ff7606           push word ptr [bp + 6]
  04DBD1  2181: 9a380a1f18       lcall 0x181f, 0xa38
  04DBD6  2186: 83c404           add sp, 4
  04DBD9  2189: a802             test al, 2
  04DBDB  218B: 7503             jne 0x2190
  04DBDD  218D: e95bff           jmp 0x20eb
  04DBE0  2190: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04DBE4  2194: 807f0500         cmp byte ptr [bx + 5], 0
  04DBE8  2198: 7d03             jge 0x219d
  04DBEA  219A: e935ff           jmp 0x20d2
  04DBED  219D: b80400           mov ax, 4
  04DBF0  21A0: e932ff           jmp 0x20d5
  04DBF3  21A3: 90               nop 
  04DBF4  21A4: 8a4eee           mov cl, byte ptr [bp - 0x12]
  04DBF7  21A7: b80100           mov ax, 1
  04DBFA  21AA: d3e0             shl ax, cl
  04DBFC  21AC: 85063e17         test word ptr [0x173e], ax
  04DC00  21B0: 7403             je 0x21b5
  04DC02  21B2: e947ff           jmp 0x20fc
  04DC05  21B5: 8b7606           mov si, word ptr [bp + 6]
  04DC08  21B8: c1e604           shl si, 4
  04DC0B  21BB: 8b5eee           mov bx, word ptr [bp - 0x12]
  04DC0E  21BE: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  04DC13  21C3: 7403             je 0x21c8
  04DC15  21C5: e934ff           jmp 0x20fc
  04DC18  21C8: b8ffff           mov ax, 0xffff
  04DC1B  21CB: 8946de           mov word ptr [bp - 0x22], ax
  04DC1E  21CE: 8946d6           mov word ptr [bp - 0x2a], ax
  04DC21  21D1: 8986a8fe         mov word ptr [bp - 0x158], ax
  04DC25  21D5: c746dc0000       mov word ptr [bp - 0x24], 0
  04DC2A  21DA: eb65             jmp 0x2241
  04DC2C  21DC: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  04DC2F  21DF: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04DC33  21E3: 98               cwde 
  04DC34  21E4: 0346c8           add ax, word ptr [bp - 0x38]
  04DC37  21E7: 8946b6           mov word ptr [bp - 0x4a], ax
  04DC3A  21EA: 50               push ax
  04DC3B  21EB: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04DC3F  21EF: 98               cwde 
  04DC40  21F0: 0346cc           add ax, word ptr [bp - 0x34]
  04DC43  21F3: 8946ce           mov word ptr [bp - 0x32], ax
  04DC46  21F6: 50               push ax
  04DC47  21F7: 9a68071f18       lcall 0x181f, 0x768
  04DC4C  21FC: 83c404           add sp, 4
  04DC4F  21FF: 0bc0             or ax, ax
  04DC51  2201: 7516             jne 0x2219
  04DC53  2203: ff76b6           push word ptr [bp - 0x4a]
  04DC56  2206: ff76ce           push word ptr [bp - 0x32]
  04DC59  2209: 9a22071f18       lcall 0x181f, 0x722
  04DC5E  220E: 83c404           add sp, 4
  04DC61  2211: 3b46ee           cmp ax, word ptr [bp - 0x12]
  04DC64  2214: 7503             jne 0x2219
  04DC66  2216: ff46f4           inc word ptr [bp - 0xc]
  04DC69  2219: ff46d2           inc word ptr [bp - 0x2e]
  04DC6C  221C: 837ed208         cmp word ptr [bp - 0x2e], 8
  04DC70  2220: 7cba             jl 0x21dc
  04DC72  2222: 8b86a8fe         mov ax, word ptr [bp - 0x158]
  04DC76  2226: 3946f4           cmp word ptr [bp - 0xc], ax
  04DC79  2229: 7e13             jle 0x223e
  04DC7B  222B: 8b46f4           mov ax, word ptr [bp - 0xc]
  04DC7E  222E: 8986a8fe         mov word ptr [bp - 0x158], ax
  04DC82  2232: 8b46cc           mov ax, word ptr [bp - 0x34]
  04DC85  2235: 8946de           mov word ptr [bp - 0x22], ax
  04DC88  2238: 8b46c8           mov ax, word ptr [bp - 0x38]
  04DC8B  223B: 8946d6           mov word ptr [bp - 0x2a], ax
  04DC8E  223E: ff46dc           inc word ptr [bp - 0x24]
  04DC91  2241: 837edc08         cmp word ptr [bp - 0x24], 8
  04DC95  2245: 7d4d             jge 0x2294
  04DC97  2247: 8b5edc           mov bx, word ptr [bp - 0x24]
  04DC9A  224A: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04DC9E  224E: 98               cwde 
  04DC9F  224F: 8b364a8d         mov si, word ptr [0x8d4a]
  04DCA3  2253: 8a4c01           mov cl, byte ptr [si + 1]
  04DCA6  2256: 2aed             sub ch, ch
  04DCA8  2258: 03c1             add ax, cx
  04DCAA  225A: 8946c8           mov word ptr [bp - 0x38], ax
  04DCAD  225D: 50               push ax
  04DCAE  225E: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04DCB2  2262: 98               cwde 
  04DCB3  2263: 8a0c             mov cl, byte ptr [si]
  04DCB5  2265: 03c1             add ax, cx
  04DCB7  2267: 8946cc           mov word ptr [bp - 0x34], ax
  04DCBA  226A: 50               push ax
  04DCBB  226B: 9a68071f18       lcall 0x181f, 0x768
  04DCC0  2270: 83c404           add sp, 4
  04DCC3  2273: 0bc0             or ax, ax
  04DCC5  2275: 74c7             je 0x223e
  04DCC7  2277: ff76c8           push word ptr [bp - 0x38]
  04DCCA  227A: ff76cc           push word ptr [bp - 0x34]
  04DCCD  227D: 9ab4061f18       lcall 0x181f, 0x6b4
  04DCD2  2282: 83c404           add sp, 4
  04DCD5  2285: fec8             dec al
  04DCD7  2287: 75b5             jne 0x223e
  04DCD9  2289: 2bc0             sub ax, ax
  04DCDB  228B: 8946f4           mov word ptr [bp - 0xc], ax
  04DCDE  228E: 8946d2           mov word ptr [bp - 0x2e], ax
  04DCE1  2291: eb89             jmp 0x221c
  04DCE3  2293: 90               nop 
  04DCE4  2294: 837ede00         cmp word ptr [bp - 0x22], 0
  04DCE8  2298: 7f03             jg 0x229d
  04DCEA  229A: e95ffe           jmp 0x20fc
  04DCED  229D: 6a02             push 2
  04DCEF  229F: 6a01             push 1
  04DCF1  22A1: ff76d6           push word ptr [bp - 0x2a]
  04DCF4  22A4: ff76de           push word ptr [bp - 0x22]
  04DCF7  22A7: ff7606           push word ptr [bp + 6]
  04DCFA  22AA: 0e               push cs
  04DCFB  22AB: e8c357           call 0x7a71
  04DCFE  22AE: 83c40a           add sp, 0xa
  04DD01  22B1: 8a4eee           mov cl, byte ptr [bp - 0x12]
  04DD04  22B4: b80100           mov ax, 1
  04DD07  22B7: d3e0             shl ax, cl
  04DD09  22B9: 09063e17         or word ptr [0x173e], ax
  04DD0D  22BD: e93cfe           jmp 0x20fc
  04DD10  22C0: c746c40000       mov word ptr [bp - 0x3c], 0
  04DD15  22C5: e95002           jmp 0x2518
  04DD18  22C8: ff46ca           inc word ptr [bp - 0x36]
  04DD1B  22CB: ff46b8           inc word ptr [bp - 0x48]
  04DD1E  22CE: 837eb804         cmp word ptr [bp - 0x48], 4
  04DD22  22D2: 7c03             jl 0x22d7
  04DD24  22D4: e98100           jmp 0x2358
  04DD27  22D7: 8b5eb8           mov bx, word ptr [bp - 0x48]
  04DD2A  22DA: c1e304           shl bx, 4
  04DD2D  22DD: 035ec4           add bx, word ptr [bp - 0x3c]
  04DD30  22E0: 8a872695         mov al, byte ptr [bx - 0x6ada]
  04DD34  22E4: 2ae4             sub ah, ah
  04DD36  22E6: 0186acfe         add word ptr [bp - 0x154], ax
  04DD3A  22EA: 8a87e694         mov al, byte ptr [bx - 0x6b1a]
  04DD3E  22EE: 8bc8             mov cx, ax
  04DD40  22F0: 018620fe         add word ptr [bp - 0x1e0], ax
  04DD44  22F4: 8b46b8           mov ax, word ptr [bp - 0x48]
  04DD47  22F7: 394606           cmp word ptr [bp + 6], ax
  04DD4A  22FA: 74cf             je 0x22cb
  04DD4C  22FC: 0ac9             or cl, cl
  04DD4E  22FE: 7506             jne 0x2306
  04DD50  2300: 388fa694         cmp byte ptr [bx - 0x6b5a], cl
  04DD54  2304: 74c5             je 0x22cb
  04DD56  2306: 50               push ax
  04DD57  2307: ff7606           push word ptr [bp + 6]
  04DD5A  230A: 9a380a1f18       lcall 0x181f, 0xa38
  04DD5F  230F: 83c404           add sp, 4
  04DD62  2312: 2460             and al, 0x60
  04DD64  2314: 3c20             cmp al, 0x20
  04DD66  2316: 7414             je 0x232c
  04DD68  2318: ff76b8           push word ptr [bp - 0x48]
  04DD6B  231B: ff7606           push word ptr [bp + 6]
  04DD6E  231E: 9a380a1f18       lcall 0x181f, 0xa38
  04DD73  2323: 83c404           add sp, 4
  04DD76  2326: 2448             and al, 0x48
  04DD78  2328: 3c40             cmp al, 0x40
  04DD7A  232A: 749f             je 0x22cb
  04DD7C  232C: 8b76b8           mov si, word ptr [bp - 0x48]
  04DD7F  232F: c1e604           shl si, 4
  04DD82  2332: 8b5ec4           mov bx, word ptr [bp - 0x3c]
  04DD85  2335: 8a808c91         mov al, byte ptr [bx + si - 0x6e74]
  04DD89  2339: 8b4e06           mov cx, word ptr [bp + 6]
  04DD8C  233C: c1e104           shl cx, 4
  04DD8F  233F: 03d9             add bx, cx
  04DD91  2341: 38878c91         cmp byte ptr [bx - 0x6e74], al
  04DD95  2345: 770a             ja 0x2351
  04DD97  2347: 80bfe69400       cmp byte ptr [bx - 0x6b1a], 0
  04DD9C  234C: 7403             je 0x2351
  04DD9E  234E: e977ff           jmp 0x22c8
  04DDA1  2351: ff46e0           inc word ptr [bp - 0x20]
  04DDA4  2354: e974ff           jmp 0x22cb
  04DDA7  2357: 90               nop 
  04DDA8  2358: c746b80400       mov word ptr [bp - 0x48], 4
  04DDAD  235D: eb07             jmp 0x2366
  04DDAF  235F: 90               nop 
  04DDB0  2360: ff46ca           inc word ptr [bp - 0x36]
  04DDB3  2363: ff46b8           inc word ptr [bp - 0x48]
  04DDB6  2366: 837eb80c         cmp word ptr [bp - 0x48], 0xc
  04DDBA  236A: 7c03             jl 0x236f
  04DDBC  236C: e98900           jmp 0x23f8
  04DDBF  236F: 8b46b8           mov ax, word ptr [bp - 0x48]
  04DDC2  2372: 2d0400           sub ax, 4
  04DDC5  2375: 50               push ax
  04DDC6  2376: 9a420a1f18       lcall 0x181f, 0xa42
  04DDCB  237B: 83c402           add sp, 2
  04DDCE  237E: 8b36528d         mov si, word ptr [0x8d52]
  04DDD2  2382: c1e604           shl si, 4
  04DDD5  2385: 0376c4           add si, word ptr [bp - 0x3c]
  04DDD8  2388: 8bc6             mov ax, si
  04DDDA  238A: d1e6             shl si, 1
  04DDDC  238C: 8b8ab4fe         mov cx, word ptr [bp + si - 0x14c]
  04DDE0  2390: 8bd1             mov dx, cx
  04DDE2  2392: d1e1             shl cx, 1
  04DDE4  2394: 018eacfe         add word ptr [bp - 0x154], cx
  04DDE8  2398: 8bd8             mov bx, ax
  04DDEA  239A: 80bfcc9100       cmp byte ptr [bx - 0x6e34], 0
  04DDEF  239F: 7504             jne 0x23a5
  04DDF1  23A1: 0bd2             or dx, dx
  04DDF3  23A3: 74be             je 0x2363
  04DDF5  23A5: ff7606           push word ptr [bp + 6]
  04DDF8  23A8: ff36528d         push word ptr [0x8d52]
  04DDFC  23AC: 9a0c031f18       lcall 0x181f, 0x30c
  04DE01  23B1: 83c404           add sp, 4
  04DE04  23B4: 3d4b00           cmp ax, 0x4b
  04DE07  23B7: 7d12             jge 0x23cb
  04DE09  23B9: ff76b8           push word ptr [bp - 0x48]
  04DE0C  23BC: ff7606           push word ptr [bp + 6]
  04DE0F  23BF: 9a380a1f18       lcall 0x181f, 0xa38
  04DE14  23C4: 83c404           add sp, 4
  04DE17  23C7: a802             test al, 2
  04DE19  23C9: 7498             je 0x2363
  04DE1B  23CB: 8b36528d         mov si, word ptr [0x8d52]
  04DE1F  23CF: c1e604           shl si, 4
  04DE22  23D2: 8b5ec4           mov bx, word ptr [bp - 0x3c]
  04DE25  23D5: 8a80cc91         mov al, byte ptr [bx + si - 0x6e34]
  04DE29  23D9: 8b4e06           mov cx, word ptr [bp + 6]
  04DE2C  23DC: c1e104           shl cx, 4
  04DE2F  23DF: 03d9             add bx, cx
  04DE31  23E1: 38878c91         cmp byte ptr [bx - 0x6e74], al
  04DE35  23E5: 770a             ja 0x23f1
  04DE37  23E7: 80bfe69400       cmp byte ptr [bx - 0x6b1a], 0
  04DE3C  23EC: 7403             je 0x23f1
  04DE3E  23EE: e96fff           jmp 0x2360
  04DE41  23F1: ff46e0           inc word ptr [bp - 0x20]
  04DE44  23F4: e96cff           jmp 0x2363
  04DE47  23F7: 90               nop 
  04DE48  23F8: 8b5e06           mov bx, word ptr [bp + 6]
  04DE4B  23FB: c1e304           shl bx, 4
  04DE4E  23FE: 035ec4           add bx, word ptr [bp - 0x3c]
  04DE51  2401: 8a87e694         mov al, byte ptr [bx - 0x6b1a]
  04DE55  2405: 2ae4             sub ah, ah
  04DE57  2407: 038620fe         add ax, word ptr [bp - 0x1e0]
  04DE5B  240B: 6bc014           imul ax, ax, 0x14
  04DE5E  240E: 8b76c4           mov si, word ptr [bp - 0x3c]
  04DE61  2411: d1e6             shl si, 1
  04DE63  2413: 899e1cfe         mov word ptr [bp - 0x1e4], bx
  04DE67  2417: 3b84c885         cmp ax, word ptr [si - 0x7a38]
  04DE6B  241B: 7e05             jle 0x2422
  04DE6D  241D: 2ac0             sub al, al
  04DE6F  241F: eb03             jmp 0x2424
  04DE71  2421: 90               nop 
  04DE72  2422: b006             mov al, 6
  04DE74  2424: 88877098         mov byte ptr [bx - 0x6790], al
  04DE78  2428: 837ee000         cmp word ptr [bp - 0x20], 0
  04DE7C  242C: 7405             je 0x2433
  04DE7E  242E: c687709804       mov byte ptr [bx - 0x6790], 4
  04DE83  2433: 837eca00         cmp word ptr [bp - 0x36], 0
  04DE87  2437: 740e             je 0x2447
  04DE89  2439: 8b7606           mov si, word ptr [bp + 6]
  04DE8C  243C: c1e604           shl si, 4
  04DE8F  243F: 8b5ec4           mov bx, word ptr [bp - 0x3c]
  04DE92  2442: c680709803       mov byte ptr [bx + si - 0x6790], 3
  04DE97  2447: 8b5e06           mov bx, word ptr [bp + 6]
  04DE9A  244A: c1e304           shl bx, 4
  04DE9D  244D: 035ec4           add bx, word ptr [bp - 0x3c]
  04DEA0  2450: 80bfa69400       cmp byte ptr [bx - 0x6b5a], 0
  04DEA5  2455: 750c             jne 0x2463
  04DEA7  2457: 80bfe69400       cmp byte ptr [bx - 0x6b1a], 0
  04DEAC  245C: 7505             jne 0x2463
  04DEAE  245E: c687709804       mov byte ptr [bx - 0x6790], 4
  04DEB3  2463: 8a46fa           mov al, byte ptr [bp - 6]
  04DEB6  2466: 8b7606           mov si, word ptr [bp + 6]
  04DEB9  2469: c1e604           shl si, 4
  04DEBC  246C: 8b5ec4           mov bx, word ptr [bp - 0x3c]
  04DEBF  246F: c746ec0000       mov word ptr [bp - 0x14], 0
  04DEC4  2474: eb49             jmp 0x24bf
  04DEC6  2476: 50               push ax
  04DEC7  2477: 9ae6091f18       lcall 0x181f, 0x9e6
  04DECC  247C: 83c402           add sp, 2
  04DECF  247F: 8a4606           mov al, byte ptr [bp + 6]
  04DED2  2482: 8b1e4285         mov bx, word ptr [0x8542]
  04DED6  2486: 38471a           cmp byte ptr [bx + 0x1a], al
  04DED9  2489: 7431             je 0x24bc
  04DEDB  248B: 8a4701           mov al, byte ptr [bx + 1]
  04DEDE  248E: 2ae4             sub ah, ah
  04DEE0  2490: 50               push ax
  04DEE1  2491: 8a07             mov al, byte ptr [bx]
  04DEE3  2493: 50               push ax
  04DEE4  2494: 9a22071f18       lcall 0x181f, 0x722
  04DEE9  2499: 83c404           add sp, 4
  04DEEC  249C: 3b46c4           cmp ax, word ptr [bp - 0x3c]
  04DEEF  249F: 751b             jne 0x24bc
  04DEF1  24A1: 8b1e4285         mov bx, word ptr [0x8542]
  04DEF5  24A5: 8a471f           mov al, byte ptr [bx + 0x1f]
  04DEF8  24A8: 98               cwde 
  04DEF9  24A9: 8b5ec4           mov bx, word ptr [bp - 0x3c]
  04DEFC  24AC: 8a8f989e         mov cl, byte ptr [bx - 0x6168]
  04DF00  24B0: 2aed             sub ch, ch
  04DF02  24B2: 3bc8             cmp cx, ax
  04DF04  24B4: 7d02             jge 0x24b8
  04DF06  24B6: 8bc8             mov cx, ax
  04DF08  24B8: 888f989e         mov byte ptr [bx - 0x6168], cl
  04DF0C  24BC: ff46ec           inc word ptr [bp - 0x14]
  04DF0F  24BF: 8b46ec           mov ax, word ptr [bp - 0x14]
  04DF12  24C2: 39069e53         cmp word ptr [0x539e], ax
  04DF16  24C6: 7fae             jg 0x2476
  04DF18  24C8: 2bc0             sub ax, ax
  04DF1A  24CA: 8946e2           mov word ptr [bp - 0x1e], ax
  04DF1D  24CD: 8946b8           mov word ptr [bp - 0x48], ax
  04DF20  24D0: eb1c             jmp 0x24ee
  04DF22  24D2: 8b46b8           mov ax, word ptr [bp - 0x48]
  04DF25  24D5: 394606           cmp word ptr [bp + 6], ax
  04DF28  24D8: 7411             je 0x24eb
  04DF2A  24DA: 8bf0             mov si, ax
  04DF2C  24DC: c1e604           shl si, 4
  04DF2F  24DF: 8b5ec4           mov bx, word ptr [bp - 0x3c]
  04DF32  24E2: 8a80a694         mov al, byte ptr [bx + si - 0x6b5a]
  04DF36  24E6: 2ae4             sub ah, ah
  04DF38  24E8: 0146e2           add word ptr [bp - 0x1e], ax
  04DF3B  24EB: ff46b8           inc word ptr [bp - 0x48]
  04DF3E  24EE: 837eb804         cmp word ptr [bp - 0x48], 4
  04DF42  24F2: 7cde             jl 0x24d2
  04DF44  24F4: 8b5ec4           mov bx, word ptr [bp - 0x3c]
  04DF47  24F7: 8a87989e         mov al, byte ptr [bx - 0x6168]
  04DF4B  24FB: 2ae4             sub ah, ah
  04DF4D  24FD: 8b4ee2           mov cx, word ptr [bp - 0x1e]
  04DF50  2500: 83f904           cmp cx, 4
  04DF53  2503: 7e03             jle 0x2508
  04DF55  2505: b90400           mov cx, 4
  04DF58  2508: 894ee2           mov word ptr [bp - 0x1e], cx
  04DF5B  250B: 3bc1             cmp ax, cx
  04DF5D  250D: 7d02             jge 0x2511
  04DF5F  250F: 8bc1             mov ax, cx
  04DF61  2511: 8887989e         mov byte ptr [bx - 0x6168], al
  04DF65  2515: ff46c4           inc word ptr [bp - 0x3c]
  04DF68  2518: 837ec410         cmp word ptr [bp - 0x3c], 0x10
  04DF6C  251C: 7d28             jge 0x2546
  04DF6E  251E: 8b7606           mov si, word ptr [bp + 6]
  04DF71  2521: c1e604           shl si, 4
  04DF74  2524: 8b5ec4           mov bx, word ptr [bp - 0x3c]
  04DF77  2527: 8a807098         mov al, byte ptr [bx + si - 0x6790]
  04DF7B  252B: 2ae4             sub ah, ah
  04DF7D  252D: 8946fa           mov word ptr [bp - 6], ax
  04DF80  2530: 2bc0             sub ax, ax
  04DF82  2532: 8946ca           mov word ptr [bp - 0x36], ax
  04DF85  2535: 8946e0           mov word ptr [bp - 0x20], ax
  04DF88  2538: 8986acfe         mov word ptr [bp - 0x154], ax
  04DF8C  253C: 898620fe         mov word ptr [bp - 0x1e0], ax
  04DF90  2540: 8946b8           mov word ptr [bp - 0x48], ax
  04DF93  2543: e988fd           jmp 0x22ce
  04DF96  2546: c786aefe0000     mov word ptr [bp - 0x152], 0
  04DF9C  254C: e93402           jmp 0x2783
  04DF9F  254F: 90               nop 
  04DFA0  2550: 8b86a8fe         mov ax, word ptr [bp - 0x158]
  04DFA4  2554: 3946f0           cmp word ptr [bp - 0x10], ax
  04DFA7  2557: 7d33             jge 0x258c
  04DFA9  2559: 8b5e06           mov bx, word ptr [bp + 6]
  04DFAC  255C: c1e306           shl bx, 6
  04DFAF  255F: 035ec4           add bx, word ptr [bp - 0x3c]
  04DFB2  2562: c1e302           shl bx, 2
  04DFB5  2565: 8a87b398         mov al, byte ptr [bx - 0x674d]
  04DFB9  2569: 98               cwde 
  04DFBA  256A: 8bc8             mov cx, ax
  04DFBC  256C: d1e0             shl ax, 1
  04DFBE  256E: 03c1             add ax, cx
  04DFC0  2570: d1f8             sar ax, 1
  04DFC2  2572: 8bc8             mov cx, ax
  04DFC4  2574: 8b46f0           mov ax, word ptr [bp - 0x10]
  04DFC7  2577: 99               cdq 
  04DFC8  2578: f77ec6           idiv word ptr [bp - 0x3a]
  04DFCB  257B: 3bc8             cmp cx, ax
  04DFCD  257D: 7c0d             jl 0x258c
  04DFCF  257F: 8b46f0           mov ax, word ptr [bp - 0x10]
  04DFD2  2582: 8986a8fe         mov word ptr [bp - 0x158], ax
  04DFD6  2586: 8b46c4           mov ax, word ptr [bp - 0x3c]
  04DFD9  2589: 8946b4           mov word ptr [bp - 0x4c], ax
  04DFDC  258C: ff46c4           inc word ptr [bp - 0x3c]
  04DFDF  258F: 837ec440         cmp word ptr [bp - 0x3c], 0x40
  04DFE3  2593: 7c03             jl 0x2598
  04DFE5  2595: e96a01           jmp 0x2702
  04DFE8  2598: 8b5e06           mov bx, word ptr [bp + 6]
  04DFEB  259B: c1e306           shl bx, 6
  04DFEE  259E: 035ec4           add bx, word ptr [bp - 0x3c]
  04DFF1  25A1: c1e302           shl bx, 2
  04DFF4  25A4: 80bfb298ff       cmp byte ptr [bx - 0x674e], 0xff
  04DFF9  25A9: 74e1             je 0x258c
  04DFFB  25AB: 8a8fb298         mov cl, byte ptr [bx - 0x674e]
  04DFFF  25AF: b80100           mov ax, 1
  04E002  25B2: d3e0             shl ax, cl
  04E004  25B4: 6bb6aefe1c       imul si, word ptr [bp - 0x152], 0x1c
  04E009  25B9: 8bcb             mov cx, bx
  04E00B  25BB: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  04E00F  25BF: 2aff             sub bh, bh
  04E011  25C1: 8bd3             mov dx, bx
  04E013  25C3: d1e3             shl bx, 1
  04E015  25C5: 03da             add bx, dx
  04E017  25C7: d1e3             shl bx, 1
  04E019  25C9: 03da             add bx, dx
  04E01B  25CB: d1e3             shl bx, 1
  04E01D  25CD: 8a973d52         mov dl, byte ptr [bx + 0x523d]
  04E021  25D1: 2af6             sub dh, dh
  04E023  25D3: 85d0             test ax, dx
  04E025  25D5: 74b5             je 0x258c
  04E027  25D7: 8bd9             mov bx, cx
  04E029  25D9: 8a87b198         mov al, byte ptr [bx - 0x674f]
  04E02D  25DD: 98               cwde 
  04E02E  25DE: 50               push ax
  04E02F  25DF: 8a87b098         mov al, byte ptr [bx - 0x6750]
  04E033  25E3: 98               cwde 
  04E034  25E4: 50               push ax
  04E035  25E5: 9a22071f18       lcall 0x181f, 0x722
  04E03A  25EA: 83c404           add sp, 4
  04E03D  25ED: 3b46ee           cmp ax, word ptr [bp - 0x12]
  04E040  25F0: 740e             je 0x2600
  04E042  25F2: 80bc46310d       cmp byte ptr [si + 0x3146], 0xd
  04E047  25F7: 7293             jb 0x258c
  04E049  25F9: 80bc463112       cmp byte ptr [si + 0x3146], 0x12
  04E04E  25FE: 778c             ja 0x258c
  04E050  2600: 8b5e06           mov bx, word ptr [bp + 6]
  04E053  2603: c1e306           shl bx, 6
  04E056  2606: 035ec4           add bx, word ptr [bp - 0x3c]
  04E059  2609: c1e302           shl bx, 2
  04E05C  260C: 80bfb29801       cmp byte ptr [bx - 0x674e], 1
  04E061  2611: 750f             jne 0x2622
  04E063  2613: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E068  2618: f687483104       test byte ptr [bx + 0x3148], 4
  04E06D  261D: 7503             jne 0x2622
  04E06F  261F: e96aff           jmp 0x258c
  04E072  2622: 8b5e06           mov bx, word ptr [bp + 6]
  04E075  2625: c1e306           shl bx, 6
  04E078  2628: 035ec4           add bx, word ptr [bp - 0x3c]
  04E07B  262B: c1e302           shl bx, 2
  04E07E  262E: 80bfb29807       cmp byte ptr [bx - 0x674e], 7
  04E083  2633: 750f             jne 0x2644
  04E085  2635: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E08A  263A: f687483108       test byte ptr [bx + 0x3148], 8
  04E08F  263F: 7503             jne 0x2644
  04E091  2641: e948ff           jmp 0x258c
  04E094  2644: 8b5e06           mov bx, word ptr [bp + 6]
  04E097  2647: c1e306           shl bx, 6
  04E09A  264A: 035ec4           add bx, word ptr [bp - 0x3c]
  04E09D  264D: c1e302           shl bx, 2
  04E0A0  2650: 8a87b198         mov al, byte ptr [bx - 0x674f]
  04E0A4  2654: 98               cwde 
  04E0A5  2655: 50               push ax
  04E0A6  2656: 8a87b098         mov al, byte ptr [bx - 0x6750]
  04E0AA  265A: 98               cwde 
  04E0AB  265B: 50               push ax
  04E0AC  265C: ff76c8           push word ptr [bp - 0x38]
  04E0AF  265F: ff76cc           push word ptr [bp - 0x34]
  04E0B2  2662: 8bf3             mov si, bx
  04E0B4  2664: 9a7a031f18       lcall 0x181f, 0x37a
  04E0B9  2669: 83c408           add sp, 8
  04E0BC  266C: 8bc8             mov cx, ax
  04E0BE  266E: 8a84b398         mov al, byte ptr [si - 0x674d]
  04E0C2  2672: 98               cwde 
  04E0C3  2673: 8bd8             mov bx, ax
  04E0C5  2675: 43               inc bx
  04E0C6  2676: 8b76c4           mov si, word ptr [bp - 0x3c]
  04E0C9  2679: d1e6             shl si, 1
  04E0CB  267B: 8b8228fe         mov ax, word ptr [bp + si - 0x1d8]
  04E0CF  267F: f7e9             imul cx
  04E0D1  2681: 99               cdq 
  04E0D2  2682: f7fb             idiv bx
  04E0D4  2684: 8946f0           mov word ptr [bp - 0x10], ax
  04E0D7  2687: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E0DC  268C: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  04E0E1  2691: 740a             je 0x269d
  04E0E3  2693: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  04E0E8  2698: 7403             je 0x269d
  04E0EA  269A: e9b3fe           jmp 0x2550
  04E0ED  269D: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E0F2  26A2: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04E0F7  26A7: 720a             jb 0x26b3
  04E0F9  26A9: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04E0FE  26AE: 7703             ja 0x26b3
  04E100  26B0: e99dfe           jmp 0x2550
  04E103  26B3: ff76c8           push word ptr [bp - 0x38]
  04E106  26B6: ff76cc           push word ptr [bp - 0x34]
  04E109  26B9: 9a96061f18       lcall 0x181f, 0x696
  04E10E  26BE: 83c404           add sp, 4
  04E111  26C1: 0bc0             or ax, ax
  04E113  26C3: 7c03             jl 0x26c8
  04E115  26C5: e9c4fe           jmp 0x258c
  04E118  26C8: 8b5e06           mov bx, word ptr [bp + 6]
  04E11B  26CB: c1e306           shl bx, 6
  04E11E  26CE: 035ec4           add bx, word ptr [bp - 0x3c]
  04E121  26D1: c1e302           shl bx, 2
  04E124  26D4: 80bfb39802       cmp byte ptr [bx - 0x674d], 2
  04E129  26D9: 7f03             jg 0x26de
  04E12B  26DB: e9aefe           jmp 0x258c
  04E12E  26DE: 8a87b398         mov al, byte ptr [bx - 0x674d]
  04E132  26E2: 98               cwde 
  04E133  26E3: f76ec6           imul word ptr [bp - 0x3a]
  04E136  26E6: 3b46f0           cmp ax, word ptr [bp - 0x10]
  04E139  26E9: 7c03             jl 0x26ee
  04E13B  26EB: e962fe           jmp 0x2550
  04E13E  26EE: 8b46c6           mov ax, word ptr [bp - 0x3a]
  04E141  26F1: 8b76c4           mov si, word ptr [bp - 0x3c]
  04E144  26F4: d1e6             shl si, 1
  04E146  26F6: 398228fe         cmp word ptr [bp + si - 0x1d8], ax
  04E14A  26FA: 7503             jne 0x26ff
  04E14C  26FC: e951fe           jmp 0x2550
  04E14F  26FF: e98afe           jmp 0x258c
  04E152  2702: 837eb400         cmp word ptr [bp - 0x4c], 0
  04E156  2706: 7c77             jl 0x277f
  04E158  2708: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E15D  270D: c6874b3131       mov byte ptr [bx + 0x314b], 0x31
  04E162  2712: 8b7606           mov si, word ptr [bp + 6]
  04E165  2715: c1e606           shl si, 6
  04E168  2718: 0376b4           add si, word ptr [bp - 0x4c]
  04E16B  271B: c1e602           shl si, 2
  04E16E  271E: 80bcb29801       cmp byte ptr [si - 0x674e], 1
  04E173  2723: 7507             jne 0x272c
  04E175  2725: c6874b3174       mov byte ptr [bx + 0x314b], 0x74
  04E17A  272A: eb1d             jmp 0x2749
  04E17C  272C: 8b5e06           mov bx, word ptr [bp + 6]
  04E17F  272F: c1e306           shl bx, 6
  04E182  2732: 035eb4           add bx, word ptr [bp - 0x4c]
  04E185  2735: c1e302           shl bx, 2
  04E188  2738: 80bfb29807       cmp byte ptr [bx - 0x674e], 7
  04E18D  273D: 750a             jne 0x2749
  04E18F  273F: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E194  2744: c6874b3169       mov byte ptr [bx + 0x314b], 0x69
  04E199  2749: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E19E  274E: c6874c310b       mov byte ptr [bx + 0x314c], 0xb
  04E1A3  2753: 8b7606           mov si, word ptr [bp + 6]
  04E1A6  2756: c1e606           shl si, 6
  04E1A9  2759: 0376b4           add si, word ptr [bp - 0x4c]
  04E1AC  275C: c1e602           shl si, 2
  04E1AF  275F: 8a84b098         mov al, byte ptr [si - 0x6750]
  04E1B3  2763: 88874d31         mov byte ptr [bx + 0x314d], al
  04E1B7  2767: 8a84b198         mov al, byte ptr [si - 0x674f]
  04E1BB  276B: 88874e31         mov byte ptr [bx + 0x314e], al
  04E1BF  276F: 80bcb29804       cmp byte ptr [si - 0x674e], 4
  04E1C4  2774: 7409             je 0x277f
  04E1C6  2776: 8b76b4           mov si, word ptr [bp - 0x4c]
  04E1C9  2779: d1e6             shl si, 1
  04E1CB  277B: ff8228fe         inc word ptr [bp + si - 0x1d8]
  04E1CF  277F: ff86aefe         inc word ptr [bp - 0x152]
  04E1D3  2783: a19c53           mov ax, word ptr [0x539c]
  04E1D6  2786: 3986aefe         cmp word ptr [bp - 0x152], ax
  04E1DA  278A: 7c03             jl 0x278f
  04E1DC  278C: e9d300           jmp 0x2862
  04E1DF  278F: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E1E4  2794: 8a874731         mov al, byte ptr [bx + 0x3147]
  04E1E8  2798: 240f             and al, 0xf
  04E1EA  279A: 3a4606           cmp al, byte ptr [bp + 6]
  04E1ED  279D: 75e0             jne 0x277f
  04E1EF  279F: 80bf4b3141       cmp byte ptr [bx + 0x314b], 0x41
  04E1F4  27A4: 74d9             je 0x277f
  04E1F6  27A6: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E1FB  27AB: 80bf4c310a       cmp byte ptr [bx + 0x314c], 0xa
  04E200  27B0: 7305             jae 0x27b7
  04E202  27B2: c6874b313f       mov byte ptr [bx + 0x314b], 0x3f
  04E207  27B7: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E20C  27BC: 80bf4c3100       cmp byte ptr [bx + 0x314c], 0
  04E211  27C1: 740e             je 0x27d1
  04E213  27C3: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  04E218  27C8: 7407             je 0x27d1
  04E21A  27CA: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  04E21F  27CF: 75ae             jne 0x277f
  04E221  27D1: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E226  27D6: 80bf4b3174       cmp byte ptr [bx + 0x314b], 0x74
  04E22B  27DB: 7407             je 0x27e4
  04E22D  27DD: 80bf4b3169       cmp byte ptr [bx + 0x314b], 0x69
  04E232  27E2: 750a             jne 0x27ee
  04E234  27E4: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E239  27E9: c6874b313f       mov byte ptr [bx + 0x314b], 0x3f
  04E23E  27EE: c786a8fe0f27     mov word ptr [bp - 0x158], 0x270f
  04E244  27F4: c746b4ffff       mov word ptr [bp - 0x4c], 0xffff
  04E249  27F9: 6b9eaefe1c       imul bx, word ptr [bp - 0x152], 0x1c
  04E24E  27FE: 8a874431         mov al, byte ptr [bx + 0x3144]
  04E252  2802: 2ae4             sub ah, ah
  04E254  2804: 8946cc           mov word ptr [bp - 0x34], ax
  04E257  2807: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  04E25B  280B: 2aed             sub ch, ch
  04E25D  280D: 894ec8           mov word ptr [bp - 0x38], cx
  04E260  2810: 51               push cx
  04E261  2811: 50               push ax
  04E262  2812: 8bf3             mov si, bx
  04E264  2814: 9a22071f18       lcall 0x181f, 0x722
  04E269  2819: 83c404           add sp, 4
  04E26C  281C: 8946ee           mov word ptr [bp - 0x12], ax
  04E26F  281F: 80bc463101       cmp byte ptr [si + 0x3146], 1
  04E274  2824: 7407             je 0x282d
  04E276  2826: 80bc463104       cmp byte ptr [si + 0x3146], 4
  04E27B  282B: 752d             jne 0x285a
  04E27D  282D: 8b7606           mov si, word ptr [bp + 6]
  04E280  2830: c1e604           shl si, 4
  04E283  2833: 8bd8             mov bx, ax
  04E285  2835: 8a80a694         mov al, byte ptr [bx + si - 0x6b5a]
  04E289  2839: 2ae4             sub ah, ah
  04E28B  283B: 8946e2           mov word ptr [bp - 0x1e], ax
  04E28E  283E: 3d0300           cmp ax, 3
  04E291  2841: 7d17             jge 0x285a
  04E293  2843: 3d0200           cmp ax, 2
  04E296  2846: 7d03             jge 0x284b
  04E298  2848: e934ff           jmp 0x277f
  04E29B  284B: 8b7606           mov si, word ptr [bp + 6]
  04E29E  284E: c1e604           shl si, 4
  04E2A1  2851: 38a0e694         cmp byte ptr [bx + si - 0x6b1a], ah
  04E2A5  2855: 7503             jne 0x285a
  04E2A7  2857: e925ff           jmp 0x277f
  04E2AA  285A: c746c40000       mov word ptr [bp - 0x3c], 0
  04E2AF  285F: e92dfd           jmp 0x258f
  04E2B2  2862: 5e               pop si
  04E2B3  2863: c9               leave 
  04E2B4  2864: cb               retf 

; ---- func_04E2B6  size=32  insns=12  prologue=push bp;mov bp,sp  terminal=RET imm16 ----
  04E2B6  2866: 55               push bp
  04E2B7  2867: 8bec             mov bp, sp
  04E2B9  2869: 56               push si
  04E2BA  286A: 6bf01c           imul si, ax, 0x1c
  04E2BD  286D: 88944b31         mov byte ptr [si + 0x314b], dl
  04E2C1  2871: c6844c310b       mov byte ptr [si + 0x314c], 0xb
  04E2C6  2876: 889c4d31         mov byte ptr [si + 0x314d], bl
  04E2CA  287A: 8a4604           mov al, byte ptr [bp + 4]
  04E2CD  287D: 88844e31         mov byte ptr [si + 0x314e], al
  04E2D1  2881: 5e               pop si
  04E2D2  2882: c9               leave 
  04E2D3  2883: c20200           ret 2

; ---- func_04E2D6  size=14975  insns=4858  prologue=ENTER 0x00EE,0  terminal=RETF ----
  04E2D6  2886: c8ee0000         enter 0xee, 0
  04E2DA  288A: 57               push di
  04E2DB  288B: 56               push si
  04E2DC  288C: c7864aff0100     mov word ptr [bp - 0xb6], 1
  04E2E2  2892: 2bc0             sub ax, ax
  04E2E4  2894: 898674ff         mov word ptr [bp - 0x8c], ax
  04E2E8  2898: 8946f0           mov word ptr [bp - 0x10], ax
  04E2EB  289B: 898654ff         mov word ptr [bp - 0xac], ax
  04E2EF  289F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E2F3  28A3: 8a874731         mov al, byte ptr [bx + 0x3147]
  04E2F7  28A7: 250f00           and ax, 0xf
  04E2FA  28AA: 89861cff         mov word ptr [bp - 0xe4], ax
  04E2FE  28AE: 80bf4c3100       cmp byte ptr [bx + 0x314c], 0
  04E303  28B3: 7418             je 0x28cd
  04E305  28B5: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  04E30A  28BA: 7411             je 0x28cd
  04E30C  28BC: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  04E311  28C1: 740a             je 0x28cd
  04E313  28C3: 80bf4c310a       cmp byte ptr [bx + 0x314c], 0xa
  04E318  28C8: 7303             jae 0x28cd
  04E31A  28CA: e94b39           jmp 0x6218
  04E31D  28CD: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E321  28D1: 8a874431         mov al, byte ptr [bx + 0x3144]
  04E325  28D5: 2ae4             sub ah, ah
  04E327  28D7: 89867aff         mov word ptr [bp - 0x86], ax
  04E32B  28DB: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  04E32F  28DF: 2aed             sub ch, ch
  04E331  28E1: 898e6eff         mov word ptr [bp - 0x92], cx
  04E335  28E5: c7468c0800       mov word ptr [bp - 0x74], 8
  04E33A  28EA: 8a974631         mov dl, byte ptr [bx + 0x3146]
  04E33E  28EE: 2af6             sub dh, dh
  04E340  28F0: 89569e           mov word ptr [bp - 0x62], dx
  04E343  28F3: 51               push cx
  04E344  28F4: 50               push ax
  04E345  28F5: 8bf3             mov si, bx
  04E347  28F7: 9a02031f18       lcall 0x181f, 0x302
  04E34C  28FC: 83c404           add sp, 4
  04E34F  28FF: 0bc0             or ax, ax
  04E351  2901: 7509             jne 0x290c
  04E353  2903: c6844b3140       mov byte ptr [si + 0x314b], 0x40
  04E358  2908: e90d39           jmp 0x6218
  04E35B  290B: 90               nop 
  04E35C  290C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E360  2910: 80bf4b3174       cmp byte ptr [bx + 0x314b], 0x74
  04E365  2915: 7407             je 0x291e
  04E367  2917: 80bf4b3169       cmp byte ptr [bx + 0x314b], 0x69
  04E36C  291C: 7508             jne 0x2926
  04E36E  291E: c746fc0100       mov word ptr [bp - 4], 1
  04E373  2923: eb06             jmp 0x292b
  04E375  2925: 90               nop 
  04E376  2926: c746fc0000       mov word ptr [bp - 4], 0
  04E37B  292B: ffb61cff         push word ptr [bp - 0xe4]
  04E37F  292F: ffb66eff         push word ptr [bp - 0x92]
  04E383  2933: ffb67aff         push word ptr [bp - 0x86]
  04E387  2937: 9a52091f18       lcall 0x181f, 0x952
  04E38C  293C: 83c406           add sp, 6
  04E38F  293F: 8946e8           mov word ptr [bp - 0x18], ax
  04E392  2942: 6aff             push -1
  04E394  2944: 6aff             push -1
  04E396  2946: ffb66eff         push word ptr [bp - 0x92]
  04E39A  294A: ffb67aff         push word ptr [bp - 0x86]
  04E39E  294E: 9a14061f18       lcall 0x181f, 0x614
  04E3A3  2953: 83c408           add sp, 8
  04E3A6  2956: 89861eff         mov word ptr [bp - 0xe2], ax
  04E3AA  295A: a1b88d           mov ax, word ptr [0x8db8]
  04E3AD  295D: 89468e           mov word ptr [bp - 0x72], ax
  04E3B0  2960: 8b1e4285         mov bx, word ptr [0x8542]
  04E3B4  2964: 8a4701           mov al, byte ptr [bx + 1]
  04E3B7  2967: 2ae4             sub ah, ah
  04E3B9  2969: 50               push ax
  04E3BA  296A: 8a07             mov al, byte ptr [bx]
  04E3BC  296C: 50               push ax
  04E3BD  296D: 9a22071f18       lcall 0x181f, 0x722
  04E3C2  2972: 83c404           add sp, 4
  04E3C5  2975: 894690           mov word ptr [bp - 0x70], ax
  04E3C8  2978: 6aff             push -1
  04E3CA  297A: ffb61cff         push word ptr [bp - 0xe4]
  04E3CE  297E: ffb66eff         push word ptr [bp - 0x92]
  04E3D2  2982: ffb67aff         push word ptr [bp - 0x86]
  04E3D6  2986: 9a14061f18       lcall 0x181f, 0x614
  04E3DB  298B: 83c408           add sp, 8
  04E3DE  298E: 8946a0           mov word ptr [bp - 0x60], ax
  04E3E1  2991: a1b88d           mov ax, word ptr [0x8db8]
  04E3E4  2994: 8946d4           mov word ptr [bp - 0x2c], ax
  04E3E7  2997: 837ea000         cmp word ptr [bp - 0x60], 0
  04E3EB  299B: 7c1b             jl 0x29b8
  04E3ED  299D: 8b1e4285         mov bx, word ptr [0x8542]
  04E3F1  29A1: 8a4701           mov al, byte ptr [bx + 1]
  04E3F4  29A4: 2ae4             sub ah, ah
  04E3F6  29A6: 50               push ax
  04E3F7  29A7: 8a07             mov al, byte ptr [bx]
  04E3F9  29A9: 50               push ax
  04E3FA  29AA: 9a22071f18       lcall 0x181f, 0x722
  04E3FF  29AF: 83c404           add sp, 4
  04E402  29B2: 8946d6           mov word ptr [bp - 0x2a], ax
  04E405  29B5: eb06             jmp 0x29bd
  04E407  29B7: 90               nop 
  04E408  29B8: c746d6feff       mov word ptr [bp - 0x2a], 0xfffe
  04E40D  29BD: 6aff             push -1
  04E40F  29BF: 6aff             push -1
  04E411  29C1: ffb66eff         push word ptr [bp - 0x92]
  04E415  29C5: ffb67aff         push word ptr [bp - 0x86]
  04E419  29C9: 9a840d1f18       lcall 0x181f, 0xd84
  04E41E  29CE: 83c408           add sp, 8
  04E421  29D1: 898656ff         mov word ptr [bp - 0xaa], ax
  04E425  29D5: a1b88d           mov ax, word ptr [0x8db8]
  04E428  29D8: 898662ff         mov word ptr [bp - 0x9e], ax
  04E42C  29DC: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04E430  29E0: 8a4701           mov al, byte ptr [bx + 1]
  04E433  29E3: 2ae4             sub ah, ah
  04E435  29E5: 50               push ax
  04E436  29E6: 8a07             mov al, byte ptr [bx]
  04E438  29E8: 50               push ax
  04E439  29E9: 9a22071f18       lcall 0x181f, 0x722
  04E43E  29EE: 83c404           add sp, 4
  04E441  29F1: 898664ff         mov word ptr [bp - 0x9c], ax
  04E445  29F5: ffb61cff         push word ptr [bp - 0xe4]
  04E449  29F9: ff36528d         push word ptr [0x8d52]
  04E44D  29FD: 9a0c031f18       lcall 0x181f, 0x30c
  04E452  2A02: 83c404           add sp, 4
  04E455  2A05: 50               push ax
  04E456  2A06: 9a600a1f18       lcall 0x181f, 0xa60
  04E45B  2A0B: 83c402           add sp, 2
  04E45E  2A0E: 8946ae           mov word ptr [bp - 0x52], ax
  04E461  2A11: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04E465  2A15: d1e6             shl si, 1
  04E467  2A17: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04E46B  2A1B: 8b400a           mov ax, word ptr [bx + si + 0xa]
  04E46E  2A1E: 8946c4           mov word ptr [bp - 0x3c], ax
  04E471  2A21: 6afe             push -2
  04E473  2A23: ffb61cff         push word ptr [bp - 0xe4]
  04E477  2A27: ffb66eff         push word ptr [bp - 0x92]
  04E47B  2A2B: ffb67aff         push word ptr [bp - 0x86]
  04E47F  2A2F: 9a14061f18       lcall 0x181f, 0x614
  04E484  2A34: 83c408           add sp, 8
  04E487  2A37: 8946b0           mov word ptr [bp - 0x50], ax
  04E48A  2A3A: a1b88d           mov ax, word ptr [0x8db8]
  04E48D  2A3D: 8946c6           mov word ptr [bp - 0x3a], ax
  04E490  2A40: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E494  2A44: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04E499  2A49: 720f             jb 0x2a5a
  04E49B  2A4B: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04E4A0  2A50: 7708             ja 0x2a5a
  04E4A2  2A52: c746ce0100       mov word ptr [bp - 0x32], 1
  04E4A7  2A57: eb06             jmp 0x2a5f
  04E4A9  2A59: 90               nop 
  04E4AA  2A5A: c746ce0000       mov word ptr [bp - 0x32], 0
  04E4AF  2A5F: ffb66eff         push word ptr [bp - 0x92]
  04E4B3  2A63: ffb67aff         push word ptr [bp - 0x86]
  04E4B7  2A67: 9a8c071f18       lcall 0x181f, 0x78c
  04E4BC  2A6C: 83c404           add sp, 4
  04E4BF  2A6F: 898658ff         mov word ptr [bp - 0xa8], ax
  04E4C3  2A73: 3d1900           cmp ax, 0x19
  04E4C6  2A76: 7405             je 0x2a7d
  04E4C8  2A78: 3d1a00           cmp ax, 0x1a
  04E4CB  2A7B: 7509             jne 0x2a86
  04E4CD  2A7D: c78672ff0100     mov word ptr [bp - 0x8e], 1
  04E4D3  2A83: eb07             jmp 0x2a8c
  04E4D5  2A85: 90               nop 
  04E4D6  2A86: c78672ff0000     mov word ptr [bp - 0x8e], 0
  04E4DC  2A8C: ffb66eff         push word ptr [bp - 0x92]
  04E4E0  2A90: ffb67aff         push word ptr [bp - 0x86]
  04E4E4  2A94: 9a2c071f18       lcall 0x181f, 0x72c
  04E4E9  2A99: 83c404           add sp, 4
  04E4EC  2A9C: 254000           and ax, 0x40
  04E4EF  2A9F: 89867eff         mov word ptr [bp - 0x82], ax
  04E4F3  2AA3: ffb66eff         push word ptr [bp - 0x92]
  04E4F7  2AA7: ffb67aff         push word ptr [bp - 0x86]
  04E4FB  2AAB: 9a54071f18       lcall 0x181f, 0x754
  04E500  2AB0: 83c404           add sp, 4
  04E503  2AB3: 250a00           and ax, 0xa
  04E506  2AB6: 8946a8           mov word ptr [bp - 0x58], ax
  04E509  2AB9: ffb66eff         push word ptr [bp - 0x92]
  04E50D  2ABD: ffb67aff         push word ptr [bp - 0x86]
  04E511  2AC1: 9a22071f18       lcall 0x181f, 0x722
  04E516  2AC6: 83c404           add sp, 4
  04E519  2AC9: 8946ca           mov word ptr [bp - 0x36], ax
  04E51C  2ACC: 0bc0             or ax, ax
  04E51E  2ACE: 7c14             jl 0x2ae4
  04E520  2AD0: 8bf0             mov si, ax
  04E522  2AD2: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04E526  2AD6: c1e304           shl bx, 4
  04E529  2AD9: 8a807098         mov al, byte ptr [bx + si - 0x6790]
  04E52D  2ADD: 2ae4             sub ah, ah
  04E52F  2ADF: 8946d8           mov word ptr [bp - 0x28], ax
  04E532  2AE2: eb05             jmp 0x2ae9
  04E534  2AE4: c746d80500       mov word ptr [bp - 0x28], 5
  04E539  2AE9: ffb66eff         push word ptr [bp - 0x92]
  04E53D  2AED: ffb67aff         push word ptr [bp - 0x86]
  04E541  2AF1: 9a18071f18       lcall 0x181f, 0x718
  04E546  2AF6: 83c404           add sp, 4
  04E549  2AF9: 89867cff         mov word ptr [bp - 0x84], ax
  04E54D  2AFD: ff7606           push word ptr [bp + 6]
  04E550  2B00: ffb61cff         push word ptr [bp - 0xe4]
  04E554  2B04: 0e               push cs
  04E555  2B05: e8e14f           call 0x7ae9
  04E558  2B08: 83c404           add sp, 4
  04E55B  2B0B: 8946ee           mov word ptr [bp - 0x12], ax
  04E55E  2B0E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E562  2B12: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  04E567  2B17: 7407             je 0x2b20
  04E569  2B19: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  04E56E  2B1E: 7508             jne 0x2b28
  04E570  2B20: c746980100       mov word ptr [bp - 0x68], 1
  04E575  2B25: eb06             jmp 0x2b2d
  04E577  2B27: 90               nop 
  04E578  2B28: c746980000       mov word ptr [bp - 0x68], 0
  04E57D  2B2D: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E581  2B31: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  04E586  2B36: 7505             jne 0x2b3d
  04E588  2B38: c746980000       mov word ptr [bp - 0x68], 0
  04E58D  2B3D: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E591  2B41: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  04E596  2B46: 740a             je 0x2b52
  04E598  2B48: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  04E59D  2B4D: 7403             je 0x2b52
  04E59F  2B4F: e9be00           jmp 0x2c10
  04E5A2  2B52: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E5A6  2B56: 80bf4c3100       cmp byte ptr [bx + 0x314c], 0
  04E5AB  2B5B: 7505             jne 0x2b62
  04E5AD  2B5D: c746980100       mov word ptr [bp - 0x68], 1
  04E5B2  2B62: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E5B6  2B66: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  04E5BB  2B6B: 7526             jne 0x2b93
  04E5BD  2B6D: 8a874e31         mov al, byte ptr [bx + 0x314e]
  04E5C1  2B71: 2ae4             sub ah, ah
  04E5C3  2B73: 50               push ax
  04E5C4  2B74: 8a874d31         mov al, byte ptr [bx + 0x314d]
  04E5C8  2B78: 50               push ax
  04E5C9  2B79: ffb66eff         push word ptr [bp - 0x92]
  04E5CD  2B7D: ffb67aff         push word ptr [bp - 0x86]
  04E5D1  2B81: 9a7a031f18       lcall 0x181f, 0x37a
  04E5D6  2B86: 83c408           add sp, 8
  04E5D9  2B89: 3d0c00           cmp ax, 0xc
  04E5DC  2B8C: 7e05             jle 0x2b93
  04E5DE  2B8E: c746980100       mov word ptr [bp - 0x68], 1
  04E5E3  2B93: ff76ca           push word ptr [bp - 0x36]
  04E5E6  2B96: ffb61cff         push word ptr [bp - 0xe4]
  04E5EA  2B9A: 0e               push cs
  04E5EB  2B9B: e8fb4e           call 0x7a99
  04E5EE  2B9E: 83c404           add sp, 4
  04E5F1  2BA1: 3d0200           cmp ax, 2
  04E5F4  2BA4: 7e05             jle 0x2bab
  04E5F6  2BA6: c746980100       mov word ptr [bp - 0x68], 1
  04E5FB  2BAB: 6a00             push 0
  04E5FD  2BAD: ffb61cff         push word ptr [bp - 0xe4]
  04E601  2BB1: ffb66eff         push word ptr [bp - 0x92]
  04E605  2BB5: ffb67aff         push word ptr [bp - 0x86]
  04E609  2BB9: 0e               push cs
  04E60A  2BBA: e8b94e           call 0x7a76
  04E60D  2BBD: 83c408           add sp, 8
  04E610  2BC0: 0bc0             or ax, ax
  04E612  2BC2: 7c05             jl 0x2bc9
  04E614  2BC4: c746980000       mov word ptr [bp - 0x68], 0
  04E619  2BC9: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E61D  2BCD: 80bf5b3115       cmp byte ptr [bx + 0x315b], 0x15
  04E622  2BD2: 7505             jne 0x2bd9
  04E624  2BD4: c746980000       mov word ptr [bp - 0x68], 0
  04E629  2BD9: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04E62D  2BDD: c1e304           shl bx, 4
  04E630  2BE0: 035eca           add bx, word ptr [bp - 0x36]
  04E633  2BE3: 80bfe69400       cmp byte ptr [bx - 0x6b1a], 0
  04E638  2BE8: 750c             jne 0x2bf6
  04E63A  2BEA: 80bf729508       cmp byte ptr [bx - 0x6a8e], 8
  04E63F  2BEF: 7305             jae 0x2bf6
  04E641  2BF1: c746980100       mov word ptr [bp - 0x68], 1
  04E646  2BF6: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E64A  2BFA: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  04E64F  2BFF: 750f             jne 0x2c10
  04E651  2C01: 8b5eca           mov bx, word ptr [bp - 0x36]
  04E654  2C04: f687f29504       test byte ptr [bx - 0x6a0e], 4
  04E659  2C09: 7405             je 0x2c10
  04E65B  2C0B: c746980000       mov word ptr [bp - 0x68], 0
  04E660  2C10: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E664  2C14: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  04E669  2C19: 7571             jne 0x2c8c
  04E66B  2C1B: 80bf4b3132       cmp byte ptr [bx + 0x314b], 0x32
  04E670  2C20: 7505             jne 0x2c27
  04E672  2C22: c746980100       mov word ptr [bp - 0x68], 1
  04E677  2C27: 837ed800         cmp word ptr [bp - 0x28], 0
  04E67B  2C2B: 7505             jne 0x2c32
  04E67D  2C2D: c746980000       mov word ptr [bp - 0x68], 0
  04E682  2C32: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04E686  2C36: c1e604           shl si, 4
  04E689  2C39: 8b5eca           mov bx, word ptr [bp - 0x36]
  04E68C  2C3C: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  04E691  2C41: 7512             jne 0x2c55
  04E693  2C43: a18e53           mov ax, word ptr [0x538e]
  04E696  2C46: b90f00           mov cx, 0xf
  04E699  2C49: 99               cdq 
  04E69A  2C4A: f7f9             idiv cx
  04E69C  2C4C: 0bd2             or dx, dx
  04E69E  2C4E: 7505             jne 0x2c55
  04E6A0  2C50: c746980100       mov word ptr [bp - 0x68], 1
  04E6A5  2C55: 837ed40c         cmp word ptr [bp - 0x2c], 0xc
  04E6A9  2C59: 7e0b             jle 0x2c66
  04E6AB  2C5B: 837e8e02         cmp word ptr [bp - 0x72], 2
  04E6AF  2C5F: 7e05             jle 0x2c66
  04E6B1  2C61: c746980100       mov word ptr [bp - 0x68], 1
  04E6B6  2C66: 6a00             push 0
  04E6B8  2C68: ffb61cff         push word ptr [bp - 0xe4]
  04E6BC  2C6C: ffb66eff         push word ptr [bp - 0x92]
  04E6C0  2C70: ffb67aff         push word ptr [bp - 0x86]
  04E6C4  2C74: 0e               push cs
  04E6C5  2C75: e8fe4d           call 0x7a76
  04E6C8  2C78: 83c408           add sp, 8
  04E6CB  2C7B: 0bc0             or ax, ax
  04E6CD  2C7D: 7d08             jge 0x2c87
  04E6CF  2C7F: 813e8a537206     cmp word ptr [0x538a], 0x672
  04E6D5  2C85: 7e05             jle 0x2c8c
  04E6D7  2C87: c746980000       mov word ptr [bp - 0x68], 0
  04E6DC  2C8C: 837ece00         cmp word ptr [bp - 0x32], 0
  04E6E0  2C90: 753d             jne 0x2ccf
  04E6E2  2C92: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E6E6  2C96: 8bc3             mov ax, bx
  04E6E8  2C98: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04E6EC  2C9C: 2aff             sub bh, bh
  04E6EE  2C9E: 8bcb             mov cx, bx
  04E6F0  2CA0: d1e3             shl bx, 1
  04E6F2  2CA2: 03d9             add bx, cx
  04E6F4  2CA4: d1e3             shl bx, 1
  04E6F6  2CA6: 03d9             add bx, cx
  04E6F8  2CA8: d1e3             shl bx, 1
  04E6FA  2CAA: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  04E6FF  2CAF: 761e             jbe 0x2ccf
  04E701  2CB1: 8bd8             mov bx, ax
  04E703  2CB3: 80bf4a3100       cmp byte ptr [bx + 0x314a], 0
  04E708  2CB8: 7d15             jge 0x2ccf
  04E70A  2CBA: 837ed408         cmp word ptr [bp - 0x2c], 8
  04E70E  2CBE: 7f0f             jg 0x2ccf
  04E710  2CC0: 8b46ca           mov ax, word ptr [bp - 0x36]
  04E713  2CC3: 3946d6           cmp word ptr [bp - 0x2a], ax
  04E716  2CC6: 7507             jne 0x2ccf
  04E718  2CC8: 8a46a0           mov al, byte ptr [bp - 0x60]
  04E71B  2CCB: 88874a31         mov byte ptr [bx + 0x314a], al
  04E71F  2CCF: 837e9800         cmp word ptr [bp - 0x68], 0
  04E723  2CD3: 740f             je 0x2ce4
  04E725  2CD5: 837eee00         cmp word ptr [bp - 0x12], 0
  04E729  2CD9: 7409             je 0x2ce4
  04E72B  2CDB: c746980100       mov word ptr [bp - 0x68], 1
  04E730  2CE0: eb07             jmp 0x2ce9
  04E732  2CE2: 90               nop 
  04E733  2CE3: 90               nop 
  04E734  2CE4: c746980000       mov word ptr [bp - 0x68], 0
  04E739  2CE9: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E73D  2CED: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  04E742  2CF2: 7520             jne 0x2d14
  04E744  2CF4: 837ed400         cmp word ptr [bp - 0x2c], 0
  04E748  2CF8: 751a             jne 0x2d14
  04E74A  2CFA: ff76a0           push word ptr [bp - 0x60]
  04E74D  2CFD: 9ae6091f18       lcall 0x181f, 0x9e6
  04E752  2D02: 83c402           add sp, 2
  04E755  2D05: 8b1e4285         mov bx, word ptr [0x8542]
  04E759  2D09: f6471b10         test byte ptr [bx + 0x1b], 0x10
  04E75D  2D0D: 7405             je 0x2d14
  04E75F  2D0F: c746980000       mov word ptr [bp - 0x68], 0
  04E764  2D14: 837e9800         cmp word ptr [bp - 0x68], 0
  04E768  2D18: 742a             je 0x2d44
  04E76A  2D1A: 837eca00         cmp word ptr [bp - 0x36], 0
  04E76E  2D1E: 7c24             jl 0x2d44
  04E770  2D20: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E774  2D24: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  04E779  2D29: 1bc0             sbb ax, ax
  04E77B  2D2B: 050300           add ax, 3
  04E77E  2D2E: 8b5eca           mov bx, word ptr [bp - 0x36]
  04E781  2D31: fe873ca1         inc byte ptr [bx - 0x5ec4]
  04E785  2D35: 8a8f3ca1         mov cl, byte ptr [bx - 0x5ec4]
  04E789  2D39: 2aed             sub ch, ch
  04E78B  2D3B: 3bc1             cmp ax, cx
  04E78D  2D3D: 7d05             jge 0x2d44
  04E78F  2D3F: c746980000       mov word ptr [bp - 0x68], 0
  04E794  2D44: f606825301       test byte ptr [0x5382], 1
  04E799  2D49: 7405             je 0x2d50
  04E79B  2D4B: c746980000       mov word ptr [bp - 0x68], 0
  04E7A0  2D50: c78636ff0100     mov word ptr [bp - 0xca], 1
  04E7A6  2D56: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E7AA  2D5A: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04E7AF  2D5F: 7506             jne 0x2d67
  04E7B1  2D61: c78636ff0000     mov word ptr [bp - 0xca], 0
  04E7B7  2D67: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E7BB  2D6B: 80bf463111       cmp byte ptr [bx + 0x3146], 0x11
  04E7C0  2D70: 7553             jne 0x2dc5
  04E7C2  2D72: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04E7C6  2D76: 8a841494         mov al, byte ptr [si - 0x6bec]
  04E7CA  2D7A: 2ae4             sub ah, ah
  04E7CC  2D7C: 8a8f4631         mov cl, byte ptr [bx + 0x3146]
  04E7D0  2D80: 2aed             sub ch, ch
  04E7D2  2D82: 8bf9             mov di, cx
  04E7D4  2D84: 6bde13           imul bx, si, 0x13
  04E7D7  2D87: 8a894c92         mov cl, byte ptr [bx + di - 0x6db4]
  04E7DB  2D8B: 8bd1             mov dx, cx
  04E7DD  2D8D: d1e1             shl cx, 1
  04E7DF  2D8F: 03ca             add cx, dx
  04E7E1  2D91: 2bc1             sub ax, cx
  04E7E3  2D93: 8a8f5c92         mov cl, byte ptr [bx - 0x6da4]
  04E7E7  2D97: 2aed             sub ch, ch
  04E7E9  2D99: 2bc1             sub ax, cx
  04E7EB  2D9B: 89864cff         mov word ptr [bp - 0xb4], ax
  04E7EF  2D9F: 3d0400           cmp ax, 4
  04E7F2  2DA2: 7c06             jl 0x2daa
  04E7F4  2DA4: c78636ff0000     mov word ptr [bp - 0xca], 0
  04E7FA  2DAA: 56               push si
  04E7FB  2DAB: ffb66eff         push word ptr [bp - 0x92]
  04E7FF  2DAF: ffb67aff         push word ptr [bp - 0x86]
  04E803  2DB3: 9a84091f18       lcall 0x181f, 0x984
  04E808  2DB8: 83c406           add sp, 6
  04E80B  2DBB: 0bc0             or ax, ax
  04E80D  2DBD: 7406             je 0x2dc5
  04E80F  2DBF: c78636ff0000     mov word ptr [bp - 0xca], 0
  04E815  2DC5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E819  2DC9: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  04E81E  2DCE: 751c             jne 0x2dec
  04E820  2DD0: 803e9ba801       cmp byte ptr [0xa89b], 1
  04E825  2DD5: 7707             ja 0x2dde
  04E827  2DD7: 833e529e06       cmp word ptr [0x9e52], 6
  04E82C  2DDC: 7e08             jle 0x2de6
  04E82E  2DDE: c78636ff0100     mov word ptr [bp - 0xca], 1
  04E834  2DE4: eb06             jmp 0x2dec
  04E836  2DE6: c78636ff0000     mov word ptr [bp - 0xca], 0
  04E83C  2DEC: 8b8636ff         mov ax, word ptr [bp - 0xca]
  04E840  2DF0: 898626ff         mov word ptr [bp - 0xda], ax
  04E844  2DF4: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E848  2DF8: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04E84D  2DFD: 7518             jne 0x2e17
  04E84F  2DFF: f6460601         test byte ptr [bp + 6], 1
  04E853  2E03: 750c             jne 0x2e11
  04E855  2E05: 6b9e1cff13       imul bx, word ptr [bp - 0xe4], 0x13
  04E85A  2E0A: 80bf5e9201       cmp byte ptr [bx - 0x6da2], 1
  04E85F  2E0F: 7506             jne 0x2e17
  04E861  2E11: c78626ff0100     mov word ptr [bp - 0xda], 1
  04E867  2E17: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04E86C  2E1C: 7411             je 0x2e2f
  04E86E  2E1E: 6a00             push 0
  04E870  2E20: 6a00             push 0
  04E872  2E22: 6a00             push 0
  04E874  2E24: 684217           push 0x1742
  04E877  2E27: 9a7e071f18       lcall 0x181f, 0x77e
  04E87C  2E2C: 83c408           add sp, 8
  04E87F  2E2F: 837ece00         cmp word ptr [bp - 0x32], 0
  04E883  2E33: 7403             je 0x2e38
  04E885  2E35: e9e200           jmp 0x2f1a
  04E888  2E38: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E88C  2E3C: 8bc3             mov ax, bx
  04E88E  2E3E: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04E892  2E42: 8bcb             mov cx, bx
  04E894  2E44: 2aff             sub bh, bh
  04E896  2E46: 8bd3             mov dx, bx
  04E898  2E48: d1e3             shl bx, 1
  04E89A  2E4A: 03da             add bx, dx
  04E89C  2E4C: d1e3             shl bx, 1
  04E89E  2E4E: 03da             add bx, dx
  04E8A0  2E50: d1e3             shl bx, 1
  04E8A2  2E52: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  04E8A7  2E57: 7703             ja 0x2e5c
  04E8A9  2E59: e9be00           jmp 0x2f1a
  04E8AC  2E5C: 80f904           cmp cl, 4
  04E8AF  2E5F: 7503             jne 0x2e64
  04E8B1  2E61: e9b600           jmp 0x2f1a
  04E8B4  2E64: 80f908           cmp cl, 8
  04E8B7  2E67: 7503             jne 0x2e6c
  04E8B9  2E69: e9ae00           jmp 0x2f1a
  04E8BC  2E6C: 837ed400         cmp word ptr [bp - 0x2c], 0
  04E8C0  2E70: 7403             je 0x2e75
  04E8C2  2E72: e9a500           jmp 0x2f1a
  04E8C5  2E75: ff76a0           push word ptr [bp - 0x60]
  04E8C8  2E78: 8bf0             mov si, ax
  04E8CA  2E7A: 9ae6091f18       lcall 0x181f, 0x9e6
  04E8CF  2E7F: 83c402           add sp, 2
  04E8D2  2E82: 8b1e4285         mov bx, word ptr [0x8542]
  04E8D6  2E86: 80bf8e0000       cmp byte ptr [bx + 0x8e], 0
  04E8DB  2E8B: 7f0a             jg 0x2e97
  04E8DD  2E8D: 80bc4b3141       cmp byte ptr [si + 0x314b], 0x41
  04E8E2  2E92: 7403             je 0x2e97
  04E8E4  2E94: e98300           jmp 0x2f1a
  04E8E7  2E97: c746aa0000       mov word ptr [bp - 0x56], 0
  04E8EC  2E9C: 8b4606           mov ax, word ptr [bp + 6]
  04E8EF  2E9F: 89865cff         mov word ptr [bp - 0xa4], ax
  04E8F3  2EA3: 9aee021f18       lcall 0x181f, 0x2ee
  04E8F8  2EA8: eb43             jmp 0x2eed
  04E8FA  2EAA: 6bd81c           imul bx, ax, 0x1c
  04E8FD  2EAD: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04E901  2EB1: 8bc3             mov ax, bx
  04E903  2EB3: 2aff             sub bh, bh
  04E905  2EB5: 8bcb             mov cx, bx
  04E907  2EB7: d1e3             shl bx, 1
  04E909  2EB9: 03d9             add bx, cx
  04E90B  2EBB: d1e3             shl bx, 1
  04E90D  2EBD: 03d9             add bx, cx
  04E90F  2EBF: d1e3             shl bx, 1
  04E911  2EC1: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  04E916  2EC6: 761d             jbe 0x2ee5
  04E918  2EC8: 3c0d             cmp al, 0xd
  04E91A  2ECA: 7204             jb 0x2ed0
  04E91C  2ECC: 3c12             cmp al, 0x12
  04E91E  2ECE: 7615             jbe 0x2ee5
  04E920  2ED0: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E924  2ED4: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  04E929  2ED9: 740a             je 0x2ee5
  04E92B  2EDB: 80bf463108       cmp byte ptr [bx + 0x3146], 8
  04E930  2EE0: 7403             je 0x2ee5
  04E932  2EE2: ff46aa           inc word ptr [bp - 0x56]
  04E935  2EE5: 8b4606           mov ax, word ptr [bp + 6]
  04E938  2EE8: 9ae4021f18       lcall 0x181f, 0x2e4
  04E93D  2EED: 894606           mov word ptr [bp + 6], ax
  04E940  2EF0: 0bc0             or ax, ax
  04E942  2EF2: 7db6             jge 0x2eaa
  04E944  2EF4: 8b865cff         mov ax, word ptr [bp - 0xa4]
  04E948  2EF8: 894606           mov word ptr [bp + 6], ax
  04E94B  2EFB: 6bd81c           imul bx, ax, 0x1c
  04E94E  2EFE: 80bf4b3141       cmp byte ptr [bx + 0x314b], 0x41
  04E953  2F03: 7503             jne 0x2f08
  04E955  2F05: e93131           jmp 0x6039
  04E958  2F08: 837eaa01         cmp word ptr [bp - 0x56], 1
  04E95C  2F0C: 7f03             jg 0x2f11
  04E95E  2F0E: e91731           jmp 0x6028
  04E961  2F11: c78674ff0100     mov word ptr [bp - 0x8c], 1
  04E967  2F17: e9b425           jmp 0x54ce
  04E96A  2F1A: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04E96F  2F1F: 7411             je 0x2f32
  04E971  2F21: 6a00             push 0
  04E973  2F23: 6a00             push 0
  04E975  2F25: 6a00             push 0
  04E977  2F27: 684617           push 0x1746
  04E97A  2F2A: 9a7e071f18       lcall 0x181f, 0x77e
  04E97F  2F2F: 83c408           add sp, 8
  04E982  2F32: 837ed800         cmp word ptr [bp - 0x28], 0
  04E986  2F36: 7570             jne 0x2fa8
  04E988  2F38: 837efc00         cmp word ptr [bp - 4], 0
  04E98C  2F3C: 756a             jne 0x2fa8
  04E98E  2F3E: 837ece00         cmp word ptr [bp - 0x32], 0
  04E992  2F42: 7564             jne 0x2fa8
  04E994  2F44: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E998  2F48: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  04E99D  2F4D: 7419             je 0x2f68
  04E99F  2F4F: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04E9A3  2F53: 2aff             sub bh, bh
  04E9A5  2F55: 8bc3             mov ax, bx
  04E9A7  2F57: d1e3             shl bx, 1
  04E9A9  2F59: 03d8             add bx, ax
  04E9AB  2F5B: d1e3             shl bx, 1
  04E9AD  2F5D: 03d8             add bx, ax
  04E9AF  2F5F: d1e3             shl bx, 1
  04E9B1  2F61: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  04E9B6  2F66: 7640             jbe 0x2fa8
  04E9B8  2F68: 8b46ca           mov ax, word ptr [bp - 0x36]
  04E9BB  2F6B: 3946d6           cmp word ptr [bp - 0x2a], ax
  04E9BE  2F6E: 7538             jne 0x2fa8
  04E9C0  2F70: 837ed400         cmp word ptr [bp - 0x2c], 0
  04E9C4  2F74: 7426             je 0x2f9c
  04E9C6  2F76: ff76a0           push word ptr [bp - 0x60]
  04E9C9  2F79: 9ae6091f18       lcall 0x181f, 0x9e6
  04E9CE  2F7E: 83c402           add sp, 2
  04E9D1  2F81: 8b1e4285         mov bx, word ptr [0x8542]
  04E9D5  2F85: 8a4701           mov al, byte ptr [bx + 1]
  04E9D8  2F88: 2ae4             sub ah, ah
  04E9DA  2F8A: 50               push ax
  04E9DB  2F8B: 8a1f             mov bl, byte ptr [bx]
  04E9DD  2F8D: 2aff             sub bh, bh
  04E9DF  2F8F: 8b4606           mov ax, word ptr [bp + 6]
  04E9E2  2F92: ba5600           mov dx, 0x56
  04E9E5  2F95: e8cef8           call 0x2866
  04E9E8  2F98: e97d32           jmp 0x6218
  04E9EB  2F9B: 90               nop 
  04E9EC  2F9C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04E9F0  2FA0: c6874b3156       mov byte ptr [bx + 0x314b], 0x56
  04E9F5  2FA5: e99130           jmp 0x6039
  04E9F8  2FA8: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04E9FD  2FAD: 7411             je 0x2fc0
  04E9FF  2FAF: 6a00             push 0
  04EA01  2FB1: 6a00             push 0
  04EA03  2FB3: 6a00             push 0
  04EA05  2FB5: 684a17           push 0x174a
  04EA08  2FB8: 9a7e071f18       lcall 0x181f, 0x77e
  04EA0D  2FBD: 83c408           add sp, 8
  04EA10  2FC0: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04EA14  2FC4: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  04EA19  2FC9: 7541             jne 0x300c
  04EA1B  2FCB: 83be62ff01       cmp word ptr [bp - 0x9e], 1
  04EA20  2FD0: 753a             jne 0x300c
  04EA22  2FD2: 8b364a8d         mov si, word ptr [0x8d4a]
  04EA26  2FD6: f6440308         test byte ptr [si + 3], 8
  04EA2A  2FDA: 7530             jne 0x300c
  04EA2C  2FDC: 837eae19         cmp word ptr [bp - 0x52], 0x19
  04EA30  2FE0: 7d2a             jge 0x300c
  04EA32  2FE2: 837ec400         cmp word ptr [bp - 0x3c], 0
  04EA36  2FE6: 7524             jne 0x300c
  04EA38  2FE8: 8a04             mov al, byte ptr [si]
  04EA3A  2FEA: 2ae4             sub ah, ah
  04EA3C  2FEC: 2b867aff         sub ax, word ptr [bp - 0x86]
  04EA40  2FF0: 8a5401           mov dl, byte ptr [si + 1]
  04EA43  2FF3: 2af6             sub dh, dh
  04EA45  2FF5: 2b966eff         sub dx, word ptr [bp - 0x92]
  04EA49  2FF9: 8bf3             mov si, bx
  04EA4B  2FFB: 9a9c051f1a       lcall 0x1a1f, 0x59c
  04EA50  3000: 89468c           mov word ptr [bp - 0x74], ax
  04EA53  3003: c6844b314c       mov byte ptr [si + 0x314b], 0x4c
  04EA58  3008: e93330           jmp 0x603e
  04EA5B  300B: 90               nop 
  04EA5C  300C: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04EA61  3011: 7411             je 0x3024
  04EA63  3013: 6a00             push 0
  04EA65  3015: 6a00             push 0
  04EA67  3017: 6a00             push 0
  04EA69  3019: 684e17           push 0x174e
  04EA6C  301C: 9a7e071f18       lcall 0x181f, 0x77e
  04EA71  3021: 83c408           add sp, 8
  04EA74  3024: ff7606           push word ptr [bp + 6]
  04EA77  3027: 9a280b1f18       lcall 0x181f, 0xb28
  04EA7C  302C: 83c402           add sp, 2
  04EA7F  302F: 0bc0             or ax, ax
  04EA81  3031: 747f             je 0x30b2
  04EA83  3033: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04EA87  3037: 8bc3             mov ax, bx
  04EA89  3039: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04EA8D  303D: 8bcb             mov cx, bx
  04EA8F  303F: 2aff             sub bh, bh
  04EA91  3041: 8bd3             mov dx, bx
  04EA93  3043: d1e3             shl bx, 1
  04EA95  3045: 03da             add bx, dx
  04EA97  3047: d1e3             shl bx, 1
  04EA99  3049: 03da             add bx, dx
  04EA9B  304B: d1e3             shl bx, 1
  04EA9D  304D: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  04EAA2  3052: 775e             ja 0x30b2
  04EAA4  3054: 80f905           cmp cl, 5
  04EAA7  3057: 7459             je 0x30b2
  04EAA9  3059: 80f903           cmp cl, 3
  04EAAC  305C: 7454             je 0x30b2
  04EAAE  305E: 8bd8             mov bx, ax
  04EAB0  3060: 80bf5b311c       cmp byte ptr [bx + 0x315b], 0x1c
  04EAB5  3065: 7407             je 0x306e
  04EAB7  3067: 80bf5b3119       cmp byte ptr [bx + 0x315b], 0x19
  04EABC  306C: 7544             jne 0x30b2
  04EABE  306E: 83be62ff01       cmp word ptr [bp - 0x9e], 1
  04EAC3  3073: 753d             jne 0x30b2
  04EAC5  3075: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04EAC9  3079: f6470302         test byte ptr [bx + 3], 2
  04EACD  307D: 7533             jne 0x30b2
  04EACF  307F: 837eae19         cmp word ptr [bp - 0x52], 0x19
  04EAD3  3083: 7d2d             jge 0x30b2
  04EAD5  3085: 837ec440         cmp word ptr [bp - 0x3c], 0x40
  04EAD9  3089: 7d27             jge 0x30b2
  04EADB  308B: 8a07             mov al, byte ptr [bx]
  04EADD  308D: 2ae4             sub ah, ah
  04EADF  308F: 2b867aff         sub ax, word ptr [bp - 0x86]
  04EAE3  3093: 8a5701           mov dl, byte ptr [bx + 1]
  04EAE6  3096: 2af6             sub dh, dh
  04EAE8  3098: 2b966eff         sub dx, word ptr [bp - 0x92]
  04EAEC  309C: 9a9c051f1a       lcall 0x1a1f, 0x59c
  04EAF1  30A1: 89468c           mov word ptr [bp - 0x74], ax
  04EAF4  30A4: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04EAF8  30A8: c6874b314c       mov byte ptr [bx + 0x314b], 0x4c
  04EAFD  30AD: e98e2f           jmp 0x603e
  04EB00  30B0: 90               nop 
  04EB01  30B1: 90               nop 
  04EB02  30B2: 6a06             push 6
  04EB04  30B4: ffb66eff         push word ptr [bp - 0x92]
  04EB08  30B8: ffb67aff         push word ptr [bp - 0x86]
  04EB0C  30BC: ffb61cff         push word ptr [bp - 0xe4]
  04EB10  30C0: 0e               push cs
  04EB11  30C1: e8204a           call 0x7ae4
  04EB14  30C4: 83c408           add sp, 8
  04EB17  30C7: 8946c0           mov word ptr [bp - 0x40], ax
  04EB1A  30CA: 837e9800         cmp word ptr [bp - 0x68], 0
  04EB1E  30CE: 7417             je 0x30e7
  04EB20  30D0: 6a00             push 0
  04EB22  30D2: ffb66eff         push word ptr [bp - 0x92]
  04EB26  30D6: ffb67aff         push word ptr [bp - 0x86]
  04EB2A  30DA: 6a06             push 6
  04EB2C  30DC: ffb61cff         push word ptr [bp - 0xe4]
  04EB30  30E0: 0e               push cs
  04EB31  30E1: e8ab49           call 0x7a8f
  04EB34  30E4: 83c40a           add sp, 0xa
  04EB37  30E7: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04EB3C  30EC: 7411             je 0x30ff
  04EB3E  30EE: 6a00             push 0
  04EB40  30F0: 6a00             push 0
  04EB42  30F2: 6a00             push 0
  04EB44  30F4: 685217           push 0x1752
  04EB47  30F7: 9a7e071f18       lcall 0x181f, 0x77e
  04EB4C  30FC: 83c408           add sp, 8
  04EB4F  30FF: 837e9800         cmp word ptr [bp - 0x68], 0
  04EB53  3103: 7448             je 0x314d
  04EB55  3105: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04EB59  3109: 80bf553100       cmp byte ptr [bx + 0x3155], 0
  04EB5E  310E: 7408             je 0x3118
  04EB60  3110: fe8f5531         dec byte ptr [bx + 0x3155]
  04EB64  3114: e9f904           jmp 0x3610
  04EB67  3117: 90               nop 
  04EB68  3118: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04EB6C  311C: c6875631ff       mov byte ptr [bx + 0x3156], 0xff
  04EB71  3121: 837eee00         cmp word ptr [bp - 0x12], 0
  04EB75  3125: 740b             je 0x3132
  04EB77  3127: 80bf54317f       cmp byte ptr [bx + 0x3154], 0x7f
  04EB7C  312C: 7304             jae 0x3132
  04EB7E  312E: fe875431         inc byte ptr [bx + 0x3154]
  04EB82  3132: 8b5eca           mov bx, word ptr [bp - 0x36]
  04EB85  3135: 8a87989e         mov al, byte ptr [bx - 0x6168]
  04EB89  3139: 2ae4             sub ah, ah
  04EB8B  313B: c1e003           shl ax, 3
  04EB8E  313E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04EB92  3142: 8a8f5431         mov cl, byte ptr [bx + 0x3154]
  04EB96  3146: 2aed             sub ch, ch
  04EB98  3148: 03c1             add ax, cx
  04EB9A  314A: 8946f0           mov word ptr [bp - 0x10], ax
  04EB9D  314D: 837e9800         cmp word ptr [bp - 0x68], 0
  04EBA1  3151: 7503             jne 0x3156
  04EBA3  3153: e9ba04           jmp 0x3610
  04EBA6  3156: c7468c0800       mov word ptr [bp - 0x74], 8
  04EBAB  315B: c78620ff19fc     mov word ptr [bp - 0xe0], 0xfc19
  04EBB1  3161: c746f60000       mov word ptr [bp - 0xa], 0
  04EBB6  3166: c78624ff0300     mov word ptr [bp - 0xdc], 3
  04EBBC  316C: 8b5eca           mov bx, word ptr [bp - 0x36]
  04EBBF  316F: d1e3             shl bx, 1
  04EBC1  3171: 83bf5e9408       cmp word ptr [bx - 0x6ba2], 8
  04EBC6  3176: 7f08             jg 0x3180
  04EBC8  3178: c78624ff0000     mov word ptr [bp - 0xdc], 0
  04EBCE  317E: eb26             jmp 0x31a6
  04EBD0  3180: 8b5eca           mov bx, word ptr [bp - 0x36]
  04EBD3  3183: d1e3             shl bx, 1
  04EBD5  3185: 83bf5e9418       cmp word ptr [bx - 0x6ba2], 0x18
  04EBDA  318A: 7f08             jg 0x3194
  04EBDC  318C: c78624ff0100     mov word ptr [bp - 0xdc], 1
  04EBE2  3192: eb12             jmp 0x31a6
  04EBE4  3194: 8b5eca           mov bx, word ptr [bp - 0x36]
  04EBE7  3197: d1e3             shl bx, 1
  04EBE9  3199: 83bf5e9430       cmp word ptr [bx - 0x6ba2], 0x30
  04EBEE  319E: 7f06             jg 0x31a6
  04EBF0  31A0: c78624ff0200     mov word ptr [bp - 0xdc], 2
  04EBF6  31A6: c78638ff0300     mov word ptr [bp - 0xc8], 3
  04EBFC  31AC: 837ef020         cmp word ptr [bp - 0x10], 0x20
  04EC00  31B0: 7c06             jl 0x31b8
  04EC02  31B2: c78638ff0200     mov word ptr [bp - 0xc8], 2
  04EC08  31B8: 837ef040         cmp word ptr [bp - 0x10], 0x40
  04EC0C  31BC: 7c06             jl 0x31c4
  04EC0E  31BE: c78638ff0100     mov word ptr [bp - 0xc8], 1
  04EC14  31C4: 8b866eff         mov ax, word ptr [bp - 0x92]
  04EC18  31C8: 2b8638ff         sub ax, word ptr [bp - 0xc8]
  04EC1C  31CC: 8946e6           mov word ptr [bp - 0x1a], ax
  04EC1F  31CF: e9c303           jmp 0x3595
  04EC22  31D2: ff76ca           push word ptr [bp - 0x36]
  04EC25  31D5: 6aff             push -1
  04EC27  31D7: ff76e6           push word ptr [bp - 0x1a]
  04EC2A  31DA: ff76ea           push word ptr [bp - 0x16]
  04EC2D  31DD: 9a14061f18       lcall 0x181f, 0x614
  04EC32  31E2: 83c408           add sp, 8
  04EC35  31E5: 833ec68d00       cmp word ptr [0x8dc6], 0
  04EC3A  31EA: 7d03             jge 0x31ef
  04EC3C  31EC: e96501           jmp 0x3354
  04EC3F  31EF: 833eb88d01       cmp word ptr [0x8db8], 1
  04EC44  31F4: 7e03             jle 0x31f9
  04EC46  31F6: e9e300           jmp 0x32dc
  04EC49  31F9: ff46ea           inc word ptr [bp - 0x16]
  04EC4C  31FC: 8b867aff         mov ax, word ptr [bp - 0x86]
  04EC50  3200: 038638ff         add ax, word ptr [bp - 0xc8]
  04EC54  3204: 3b46ea           cmp ax, word ptr [bp - 0x16]
  04EC57  3207: 7d03             jge 0x320c
  04EC59  3209: e98603           jmp 0x3592
  04EC5C  320C: ff76e6           push word ptr [bp - 0x1a]
  04EC5F  320F: ff76ea           push word ptr [bp - 0x16]
  04EC62  3212: 9a02031f18       lcall 0x181f, 0x302
  04EC67  3217: 83c404           add sp, 4
  04EC6A  321A: 0bc0             or ax, ax
  04EC6C  321C: 74db             je 0x31f9
  04EC6E  321E: ff76e6           push word ptr [bp - 0x1a]
  04EC71  3221: ff76ea           push word ptr [bp - 0x16]
  04EC74  3224: 9ad2061f18       lcall 0x181f, 0x6d2
  04EC79  3229: 83c404           add sp, 4
  04EC7C  322C: 8946a6           mov word ptr [bp - 0x5a], ax
  04EC7F  322F: 0bc0             or ax, ax
  04EC81  3231: 7c06             jl 0x3239
  04EC83  3233: 3b861cff         cmp ax, word ptr [bp - 0xe4]
  04EC87  3237: 75c0             jne 0x31f9
  04EC89  3239: ff76e6           push word ptr [bp - 0x1a]
  04EC8C  323C: ff76ea           push word ptr [bp - 0x16]
  04EC8F  323F: 9a22071f18       lcall 0x181f, 0x722
  04EC94  3244: 83c404           add sp, 4
  04EC97  3247: 3b46ca           cmp ax, word ptr [bp - 0x36]
  04EC9A  324A: 75ad             jne 0x31f9
  04EC9C  324C: ff76e6           push word ptr [bp - 0x1a]
  04EC9F  324F: ff76ea           push word ptr [bp - 0x16]
  04ECA2  3252: 9a4a071f18       lcall 0x181f, 0x74a
  04ECA7  3257: 83c404           add sp, 4
  04ECAA  325A: 250f00           and ax, 0xf
  04ECAD  325D: 8946b6           mov word ptr [bp - 0x4a], ax
  04ECB0  3260: c1e002           shl ax, 2
  04ECB3  3263: 8946da           mov word ptr [bp - 0x26], ax
  04ECB6  3266: 837eea00         cmp word ptr [bp - 0x16], 0
  04ECBA  326A: 750c             jne 0x3278
  04ECBC  326C: 837ee600         cmp word ptr [bp - 0x1a], 0
  04ECC0  3270: 7506             jne 0x3278
  04ECC2  3272: 051000           add ax, 0x10
  04ECC5  3275: 8946da           mov word ptr [bp - 0x26], ax
  04ECC8  3278: ff76e6           push word ptr [bp - 0x1a]
  04ECCB  327B: ff76ea           push word ptr [bp - 0x16]
  04ECCE  327E: 9a8c071f18       lcall 0x181f, 0x78c
  04ECD3  3283: 83c404           add sp, 4
  04ECD6  3286: 3d1b00           cmp ax, 0x1b
  04ECD9  3289: 7503             jne 0x328e
  04ECDB  328B: e96bff           jmp 0x31f9
  04ECDE  328E: ff76e6           push word ptr [bp - 0x1a]
  04ECE1  3291: ff76ea           push word ptr [bp - 0x16]
  04ECE4  3294: 9a120d1f18       lcall 0x181f, 0xd12
  04ECE9  3299: 83c404           add sp, 4
  04ECEC  329C: 8946e2           mov word ptr [bp - 0x1e], ax
  04ECEF  329F: 0bc0             or ax, ax
  04ECF1  32A1: 7419             je 0x32bc
  04ECF3  32A3: ff36bc8d         push word ptr [0x8dbc]
  04ECF7  32A7: ff36ba8d         push word ptr [0x8dba]
  04ECFB  32AB: 9ab4061f18       lcall 0x181f, 0x6b4
  04ED00  32B0: 83c404           add sp, 4
  04ED03  32B3: fec8             dec al
  04ED05  32B5: 7405             je 0x32bc
  04ED07  32B7: c746e20000       mov word ptr [bp - 0x1e], 0
  04ED0C  32BC: 837ee200         cmp word ptr [bp - 0x1e], 0
  04ED10  32C0: 7403             je 0x32c5
  04ED12  32C2: e90dff           jmp 0x31d2
  04ED15  32C5: c746b60000       mov word ptr [bp - 0x4a], 0
  04ED1A  32CA: 837eb208         cmp word ptr [bp - 0x4e], 8
  04ED1E  32CE: 7403             je 0x32d3
  04ED20  32D0: e926ff           jmp 0x31f9
  04ED23  32D3: c746da0000       mov word ptr [bp - 0x26], 0
  04ED28  32D8: e91eff           jmp 0x31f9
  04ED2B  32DB: 90               nop 
  04ED2C  32DC: 8a861cff         mov al, byte ptr [bp - 0xe4]
  04ED30  32E0: 8b1e4285         mov bx, word ptr [0x8542]
  04ED34  32E4: 38471a           cmp byte ptr [bx + 0x1a], al
  04ED37  32E7: 7441             je 0x332a
  04ED39  32E9: 833eb88d02       cmp word ptr [0x8db8], 2
  04ED3E  32EE: 7504             jne 0x32f4
  04ED40  32F0: 836eda14         sub word ptr [bp - 0x26], 0x14
  04ED44  32F4: c78660ff0700     mov word ptr [bp - 0xa0], 7
  04ED4A  32FA: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04ED4E  32FE: c1e604           shl si, 4
  04ED51  3301: 8b5eca           mov bx, word ptr [bp - 0x36]
  04ED54  3304: 80b8e69401       cmp byte ptr [bx + si - 0x6b1a], 1
  04ED59  3309: 7306             jae 0x3311
  04ED5B  330B: c78660ff0500     mov word ptr [bp - 0xa0], 5
  04ED61  3311: a1b88d           mov ax, word ptr [0x8db8]
  04ED64  3314: 8946d0           mov word ptr [bp - 0x30], ax
  04ED67  3317: 3b8660ff         cmp ax, word ptr [bp - 0xa0]
  04ED6B  331B: 7d37             jge 0x3354
  04ED6D  331D: 8b8e60ff         mov cx, word ptr [bp - 0xa0]
  04ED71  3321: 2bc8             sub cx, ax
  04ED73  3323: 2b8660ff         sub ax, word ptr [bp - 0xa0]
  04ED77  3327: eb26             jmp 0x334f
  04ED79  3329: 90               nop 
  04ED7A  332A: 833eb88d02       cmp word ptr [0x8db8], 2
  04ED7F  332F: 7503             jne 0x3334
  04ED81  3331: e9c5fe           jmp 0x31f9
  04ED84  3334: c78660ff0900     mov word ptr [bp - 0xa0], 9
  04ED8A  333A: a1b88d           mov ax, word ptr [0x8db8]
  04ED8D  333D: 8946d0           mov word ptr [bp - 0x30], ax
  04ED90  3340: 3d0900           cmp ax, 9
  04ED93  3343: 7d0f             jge 0x3354
  04ED95  3345: 8bc8             mov cx, ax
  04ED97  3347: 83e909           sub cx, 9
  04ED9A  334A: 2d0900           sub ax, 9
  04ED9D  334D: f7d8             neg ax
  04ED9F  334F: f7e9             imul cx
  04EDA1  3351: 0146da           add word ptr [bp - 0x26], ax
  04EDA4  3354: ffb61eff         push word ptr [bp - 0xe2]
  04EDA8  3358: 9ae6091f18       lcall 0x181f, 0x9e6
  04EDAD  335D: 83c402           add sp, 2
  04EDB0  3360: c746f80100       mov word ptr [bp - 8], 1
  04EDB5  3365: 8b4606           mov ax, word ptr [bp + 6]
  04EDB8  3368: 89865cff         mov word ptr [bp - 0xa4], ax
  04EDBC  336C: c746920000       mov word ptr [bp - 0x6e], 0
  04EDC1  3371: eb04             jmp 0x3377
  04EDC3  3373: 90               nop 
  04EDC4  3374: ff4692           inc word ptr [bp - 0x6e]
  04EDC7  3377: 837ef800         cmp word ptr [bp - 8], 0
  04EDCB  337B: 7449             je 0x33c6
  04EDCD  337D: 837e9209         cmp word ptr [bp - 0x6e], 9
  04EDD1  3381: 7d43             jge 0x33c6
  04EDD3  3383: 8b5e92           mov bx, word ptr [bp - 0x6e]
  04EDD6  3386: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04EDDA  338A: 98               cwde 
  04EDDB  338B: 0346e6           add ax, word ptr [bp - 0x1a]
  04EDDE  338E: 8946e4           mov word ptr [bp - 0x1c], ax
  04EDE1  3391: 8bd0             mov dx, ax
  04EDE3  3393: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04EDE7  3397: 98               cwde 
  04EDE8  3398: 0346ea           add ax, word ptr [bp - 0x16]
  04EDEB  339B: 8946f4           mov word ptr [bp - 0xc], ax
  04EDEE  339E: 9ae0071f18       lcall 0x181f, 0x7e0
  04EDF3  33A3: 894606           mov word ptr [bp + 6], ax
  04EDF6  33A6: 0bc0             or ax, ax
  04EDF8  33A8: 7cca             jl 0x3374
  04EDFA  33AA: 6bd81c           imul bx, ax, 0x1c
  04EDFD  33AD: 80bf4c3107       cmp byte ptr [bx + 0x314c], 7
  04EE02  33B2: 750b             jne 0x33bf
  04EE04  33B4: 39865cff         cmp word ptr [bp - 0xa4], ax
  04EE08  33B8: 7405             je 0x33bf
  04EE0A  33BA: c746f80000       mov word ptr [bp - 8], 0
  04EE0F  33BF: 9ae4021f18       lcall 0x181f, 0x2e4
  04EE14  33C4: ebdd             jmp 0x33a3
  04EE16  33C6: 8b865cff         mov ax, word ptr [bp - 0xa4]
  04EE1A  33CA: 894606           mov word ptr [bp + 6], ax
  04EE1D  33CD: 837ef800         cmp word ptr [bp - 8], 0
  04EE21  33D1: 7503             jne 0x33d6
  04EE23  33D3: e923fe           jmp 0x31f9
  04EE26  33D6: 6aff             push -1
  04EE28  33D8: 6aff             push -1
  04EE2A  33DA: ff76e6           push word ptr [bp - 0x1a]
  04EE2D  33DD: ff76ea           push word ptr [bp - 0x16]
  04EE30  33E0: 9a840d1f18       lcall 0x181f, 0xd84
  04EE35  33E5: 83c408           add sp, 8
  04EE38  33E8: 833e4c8d00       cmp word ptr [0x8d4c], 0
  04EE3D  33ED: 7d03             jge 0x33f2
  04EE3F  33EF: e92201           jmp 0x3514
  04EE42  33F2: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04EE46  33F6: 8a4701           mov al, byte ptr [bx + 1]
  04EE49  33F9: 2ae4             sub ah, ah
  04EE4B  33FB: 50               push ax
  04EE4C  33FC: 8a07             mov al, byte ptr [bx]
  04EE4E  33FE: 50               push ax
  04EE4F  33FF: 9a22071f18       lcall 0x181f, 0x722
  04EE54  3404: 83c404           add sp, 4
  04EE57  3407: 8946a2           mov word ptr [bp - 0x5e], ax
  04EE5A  340A: a1b88d           mov ax, word ptr [0x8db8]
  04EE5D  340D: 8946d0           mov word ptr [bp - 0x30], ax
  04EE60  3410: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04EE64  3414: c1e604           shl si, 4
  04EE67  3417: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04EE6A  341A: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  04EE6F  341F: 7504             jne 0x3425
  04EE71  3421: 40               inc ax
  04EE72  3422: 8946d0           mov word ptr [bp - 0x30], ax
  04EE75  3425: 837ed006         cmp word ptr [bp - 0x30], 6
  04EE79  3429: 7c03             jl 0x342e
  04EE7B  342B: e9e600           jmp 0x3514
  04EE7E  342E: ffb61cff         push word ptr [bp - 0xe4]
  04EE82  3432: ff36528d         push word ptr [0x8d52]
  04EE86  3436: 9a0c031f18       lcall 0x181f, 0x30c
  04EE8B  343B: 83c404           add sp, 4
  04EE8E  343E: 50               push ax
  04EE8F  343F: 9a600a1f18       lcall 0x181f, 0xa60
  04EE94  3444: 83c402           add sp, 2
  04EE97  3447: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04EE9B  344B: 8a4f02           mov cl, byte ptr [bx + 2]
  04EE9E  344E: 2aed             sub ch, ch
  04EEA0  3450: 03c8             add cx, ax
  04EEA2  3452: 83c103           add cx, 3
  04EEA5  3455: d1e1             shl cx, 1
  04EEA7  3457: 894e96           mov word ptr [bp - 0x6a], cx
  04EEAA  345A: 8b46ca           mov ax, word ptr [bp - 0x36]
  04EEAD  345D: 3946a2           cmp word ptr [bp - 0x5e], ax
  04EEB0  3460: 7403             je 0x3465
  04EEB2  3462: d17e96           sar word ptr [bp - 0x6a], 1
  04EEB5  3465: 8b4696           mov ax, word ptr [bp - 0x6a]
  04EEB8  3468: d1f8             sar ax, 1
  04EEBA  346A: 89862eff         mov word ptr [bp - 0xd2], ax
  04EEBE  346E: 837ed004         cmp word ptr [bp - 0x30], 4
  04EEC2  3472: 7f07             jg 0x347b
  04EEC4  3474: 034696           add ax, word ptr [bp - 0x6a]
  04EEC7  3477: 89862eff         mov word ptr [bp - 0xd2], ax
  04EECB  347B: 837ed003         cmp word ptr [bp - 0x30], 3
  04EECF  347F: 7f09             jg 0x348a
  04EED1  3481: 8b4696           mov ax, word ptr [bp - 0x6a]
  04EED4  3484: d1e0             shl ax, 1
  04EED6  3486: 01862eff         add word ptr [bp - 0xd2], ax
  04EEDA  348A: 837ed002         cmp word ptr [bp - 0x30], 2
  04EEDE  348E: 7f0a             jg 0x349a
  04EEE0  3490: 8b4696           mov ax, word ptr [bp - 0x6a]
  04EEE3  3493: c1e002           shl ax, 2
  04EEE6  3496: 01862eff         add word ptr [bp - 0xd2], ax
  04EEEA  349A: 837ed001         cmp word ptr [bp - 0x30], 1
  04EEEE  349E: 7f0a             jg 0x34aa
  04EEF0  34A0: 8b4696           mov ax, word ptr [bp - 0x6a]
  04EEF3  34A3: c1e003           shl ax, 3
  04EEF6  34A6: 01862eff         add word ptr [bp - 0xd2], ax
  04EEFA  34AA: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04EEFE  34AE: f6470304         test byte ptr [bx + 3], 4
  04EF02  34B2: 7404             je 0x34b8
  04EF04  34B4: d1a62eff         shl word ptr [bp - 0xd2], 1
  04EF08  34B8: 83be1cff01       cmp word ptr [bp - 0xe4], 1
  04EF0D  34BD: 7504             jne 0x34c3
  04EF0F  34BF: d1be2eff         sar word ptr [bp - 0xd2], 1
  04EF13  34C3: 6a10             push 0x10
  04EF15  34C5: ffb61cff         push word ptr [bp - 0xe4]
  04EF19  34C9: 9ab4071f18       lcall 0x181f, 0x7b4
  04EF1E  34CE: 83c404           add sp, 4
  04EF21  34D1: 0bc0             or ax, ax
  04EF23  34D3: 7404             je 0x34d9
  04EF25  34D5: d1be2eff         sar word ptr [bp - 0xd2], 1
  04EF29  34D9: 83be1cff02       cmp word ptr [bp - 0xe4], 2
  04EF2E  34DE: 7505             jne 0x34e5
  04EF30  34E0: c1be2eff02       sar word ptr [bp - 0xd2], 2
  04EF35  34E5: 837ef028         cmp word ptr [bp - 0x10], 0x28
  04EF39  34E9: 7e04             jle 0x34ef
  04EF3B  34EB: d1be2eff         sar word ptr [bp - 0xd2], 1
  04EF3F  34EF: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04EF43  34F3: c1e604           shl si, 4
  04EF46  34F6: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04EF49  34F9: 8a807295         mov al, byte ptr [bx + si - 0x6a8e]
  04EF4D  34FD: 2ae4             sub ah, ah
  04EF4F  34FF: 29862eff         sub word ptr [bp - 0xd2], ax
  04EF53  3503: 8b862eff         mov ax, word ptr [bp - 0xd2]
  04EF57  3507: 0bc0             or ax, ax
  04EF59  3509: 7d02             jge 0x350d
  04EF5B  350B: 2bc0             sub ax, ax
  04EF5D  350D: 89862eff         mov word ptr [bp - 0xd2], ax
  04EF61  3511: 2946da           sub word ptr [bp - 0x26], ax
  04EF64  3514: ffb656ff         push word ptr [bp - 0xaa]
  04EF68  3518: 9a4c0a1f18       lcall 0x181f, 0xa4c
  04EF6D  351D: 83c402           add sp, 2
  04EF70  3520: 837e9800         cmp word ptr [bp - 0x68], 0
  04EF74  3524: 7443             je 0x3569
  04EF76  3526: 837eb604         cmp word ptr [bp - 0x4a], 4
  04EF7A  352A: 7c3d             jl 0x3569
  04EF7C  352C: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04EF80  3530: c1e604           shl si, 4
  04EF83  3533: 8b5eca           mov bx, word ptr [bp - 0x36]
  04EF86  3536: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  04EF8B  353B: 7508             jne 0x3545
  04EF8D  353D: 8b46da           mov ax, word ptr [bp - 0x26]
  04EF90  3540: d1f8             sar ax, 1
  04EF92  3542: 0146da           add word ptr [bp - 0x26], ax
  04EF95  3545: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04EF99  3549: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  04EF9E  354E: 7503             jne 0x3553
  04EFA0  3550: d166da           shl word ptr [bp - 0x26], 1
  04EFA3  3553: 8a8e24ff         mov cl, byte ptr [bp - 0xdc]
  04EFA7  3557: 8b46f0           mov ax, word ptr [bp - 0x10]
  04EFAA  355A: d3f8             sar ax, cl
  04EFAC  355C: 0146da           add word ptr [bp - 0x26], ax
  04EFAF  355F: 837ec000         cmp word ptr [bp - 0x40], 0
  04EFB3  3563: 7404             je 0x3569
  04EFB5  3565: 8346da10         add word ptr [bp - 0x26], 0x10
  04EFB9  3569: 8b8620ff         mov ax, word ptr [bp - 0xe0]
  04EFBD  356D: 3946da           cmp word ptr [bp - 0x26], ax
  04EFC0  3570: 7d03             jge 0x3575
  04EFC2  3572: e984fc           jmp 0x31f9
  04EFC5  3575: 8b46da           mov ax, word ptr [bp - 0x26]
  04EFC8  3578: 898620ff         mov word ptr [bp - 0xe0], ax
  04EFCC  357C: 8b46b6           mov ax, word ptr [bp - 0x4a]
  04EFCF  357F: 8946f6           mov word ptr [bp - 0xa], ax
  04EFD2  3582: 8b46ea           mov ax, word ptr [bp - 0x16]
  04EFD5  3585: 8946b4           mov word ptr [bp - 0x4c], ax
  04EFD8  3588: 8b46e6           mov ax, word ptr [bp - 0x1a]
  04EFDB  358B: 8946a4           mov word ptr [bp - 0x5c], ax
  04EFDE  358E: e968fc           jmp 0x31f9
  04EFE1  3591: 90               nop 
  04EFE2  3592: ff46e6           inc word ptr [bp - 0x1a]
  04EFE5  3595: 8b866eff         mov ax, word ptr [bp - 0x92]
  04EFE9  3599: 038638ff         add ax, word ptr [bp - 0xc8]
  04EFED  359D: 3b46e6           cmp ax, word ptr [bp - 0x1a]
  04EFF0  35A0: 7c0e             jl 0x35b0
  04EFF2  35A2: 8b867aff         mov ax, word ptr [bp - 0x86]
  04EFF6  35A6: 2b8638ff         sub ax, word ptr [bp - 0xc8]
  04EFFA  35AA: 8946ea           mov word ptr [bp - 0x16], ax
  04EFFD  35AD: e94cfc           jmp 0x31fc
  04F000  35B0: 837ef600         cmp word ptr [bp - 0xa], 0
  04F004  35B4: 7e5a             jle 0x3610
  04F006  35B6: 837e9800         cmp word ptr [bp - 0x68], 0
  04F00A  35BA: 742e             je 0x35ea
  04F00C  35BC: 8b867aff         mov ax, word ptr [bp - 0x86]
  04F010  35C0: 3946b4           cmp word ptr [bp - 0x4c], ax
  04F013  35C3: 7515             jne 0x35da
  04F015  35C5: 8b866eff         mov ax, word ptr [bp - 0x92]
  04F019  35C9: 3946a4           cmp word ptr [bp - 0x5c], ax
  04F01C  35CC: 750c             jne 0x35da
  04F01E  35CE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F022  35D2: c6874c3107       mov byte ptr [bx + 0x314c], 7
  04F027  35D7: e93e2c           jmp 0x6218
  04F02A  35DA: ff76a4           push word ptr [bp - 0x5c]
  04F02D  35DD: 8b4606           mov ax, word ptr [bp + 6]
  04F030  35E0: ba3200           mov dx, 0x32
  04F033  35E3: 8b5eb4           mov bx, word ptr [bp - 0x4c]
  04F036  35E6: e9acf9           jmp 0x2f95
  04F039  35E9: 90               nop 
  04F03A  35EA: 6a02             push 2
  04F03C  35EC: 6a06             push 6
  04F03E  35EE: 8b5e8c           mov bx, word ptr [bp - 0x74]
  04F041  35F1: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04F045  35F5: 98               cwde 
  04F046  35F6: 03866eff         add ax, word ptr [bp - 0x92]
  04F04A  35FA: 50               push ax
  04F04B  35FB: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04F04F  35FF: 98               cwde 
  04F050  3600: 03867aff         add ax, word ptr [bp - 0x86]
  04F054  3604: 50               push ax
  04F055  3605: ffb61cff         push word ptr [bp - 0xe4]
  04F059  3609: 0e               push cs
  04F05A  360A: e88744           call 0x7a94
  04F05D  360D: 83c40a           add sp, 0xa
  04F060  3610: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04F065  3615: 7411             je 0x3628
  04F067  3617: 6a00             push 0
  04F069  3619: 6a00             push 0
  04F06B  361B: 6a00             push 0
  04F06D  361D: 685617           push 0x1756
  04F070  3620: 9a7e071f18       lcall 0x181f, 0x77e
  04F075  3625: 83c408           add sp, 8
  04F078  3628: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F07C  362C: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  04F081  3631: 7403             je 0x3636
  04F083  3633: e9b601           jmp 0x37ec
  04F086  3636: 837e9800         cmp word ptr [bp - 0x68], 0
  04F08A  363A: 7403             je 0x363f
  04F08C  363C: e9ad01           jmp 0x37ec
  04F08F  363F: c746deffff       mov word ptr [bp - 0x22], 0xffff
  04F094  3644: c78620ff0f27     mov word ptr [bp - 0xe0], 0x270f
  04F09A  364A: c78676ff0000     mov word ptr [bp - 0x8a], 0
  04F0A0  3650: e9f600           jmp 0x3749
  04F0A3  3653: 90               nop 
  04F0A4  3654: ffb676ff         push word ptr [bp - 0x8a]
  04F0A8  3658: 9ae6091f18       lcall 0x181f, 0x9e6
  04F0AD  365D: 83c402           add sp, 2
  04F0B0  3660: 8a861cff         mov al, byte ptr [bp - 0xe4]
  04F0B4  3664: 8b1e4285         mov bx, word ptr [0x8542]
  04F0B8  3668: 38471a           cmp byte ptr [bx + 0x1a], al
  04F0BB  366B: 7403             je 0x3670
  04F0BD  366D: e9d500           jmp 0x3745
  04F0C0  3670: 8a4701           mov al, byte ptr [bx + 1]
  04F0C3  3673: 2ae4             sub ah, ah
  04F0C5  3675: 50               push ax
  04F0C6  3676: 8a07             mov al, byte ptr [bx]
  04F0C8  3678: 50               push ax
  04F0C9  3679: 9a22071f18       lcall 0x181f, 0x722
  04F0CE  367E: 83c404           add sp, 4
  04F0D1  3681: 3b46ca           cmp ax, word ptr [bp - 0x36]
  04F0D4  3684: 7403             je 0x3689
  04F0D6  3686: e9bc00           jmp 0x3745
  04F0D9  3689: 8b1e4285         mov bx, word ptr [0x8542]
  04F0DD  368D: f6471b10         test byte ptr [bx + 0x1b], 0x10
  04F0E1  3691: 750e             jne 0x36a1
  04F0E3  3693: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F0E7  3697: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  04F0EC  369C: 7403             je 0x36a1
  04F0EE  369E: e9a400           jmp 0x3745
  04F0F1  36A1: 9a7c0c1f18       lcall 0x181f, 0xc7c
  04F0F6  36A6: 89865eff         mov word ptr [bp - 0xa2], ax
  04F0FA  36AA: 3d1000           cmp ax, 0x10
  04F0FD  36AD: 7e03             jle 0x36b2
  04F0FF  36AF: b81000           mov ax, 0x10
  04F102  36B2: 89865eff         mov word ptr [bp - 0xa2], ax
  04F106  36B6: 8b1e4285         mov bx, word ptr [0x8542]
  04F10A  36BA: 8a4701           mov al, byte ptr [bx + 1]
  04F10D  36BD: 2ae4             sub ah, ah
  04F10F  36BF: 50               push ax
  04F110  36C0: 8a07             mov al, byte ptr [bx]
  04F112  36C2: 50               push ax
  04F113  36C3: ffb66eff         push word ptr [bp - 0x92]
  04F117  36C7: ffb67aff         push word ptr [bp - 0x86]
  04F11B  36CB: 9a7a031f18       lcall 0x181f, 0x37a
  04F120  36D0: 83c408           add sp, 8
  04F123  36D3: d1f8             sar ax, 1
  04F125  36D5: 8946da           mov word ptr [bp - 0x26], ax
  04F128  36D8: 8b1e4285         mov bx, word ptr [0x8542]
  04F12C  36DC: 8a471f           mov al, byte ptr [bx + 0x1f]
  04F12F  36DF: 98               cwde 
  04F130  36E0: 2b865eff         sub ax, word ptr [bp - 0xa2]
  04F134  36E4: f7d8             neg ax
  04F136  36E6: 8946aa           mov word ptr [bp - 0x56], ax
  04F139  36E9: 0bc0             or ax, ax
  04F13B  36EB: 7e06             jle 0x36f3
  04F13D  36ED: f76eda           imul word ptr [bp - 0x26]
  04F140  36F0: 8946da           mov word ptr [bp - 0x26], ax
  04F143  36F3: 8a865eff         mov al, byte ptr [bp - 0xa2]
  04F147  36F7: 38471f           cmp byte ptr [bx + 0x1f], al
  04F14A  36FA: 7c03             jl 0x36ff
  04F14C  36FC: d166da           shl word ptr [bp - 0x26], 1
  04F14F  36FF: 6a02             push 2
  04F151  3701: 8a07             mov al, byte ptr [bx]
  04F153  3703: 2ae4             sub ah, ah
  04F155  3705: 8a5701           mov dl, byte ptr [bx + 1]
  04F158  3708: 2af6             sub dh, dh
  04F15A  370A: 9ae0071f18       lcall 0x181f, 0x7e0
  04F15F  370F: 50               push ax
  04F160  3710: 9abc081f18       lcall 0x181f, 0x8bc
  04F165  3715: 83c404           add sp, 4
  04F168  3718: 8b1e4285         mov bx, word ptr [0x8542]
  04F16C  371C: 8bc8             mov cx, ax
  04F16E  371E: 8a471f           mov al, byte ptr [bx + 0x1f]
  04F171  3721: 98               cwde 
  04F172  3722: 03c8             add cx, ax
  04F174  3724: 8b865eff         mov ax, word ptr [bp - 0xa2]
  04F178  3728: 40               inc ax
  04F179  3729: 40               inc ax
  04F17A  372A: 3bc8             cmp cx, ax
  04F17C  372C: 7d17             jge 0x3745
  04F17E  372E: 8b8620ff         mov ax, word ptr [bp - 0xe0]
  04F182  3732: 3946da           cmp word ptr [bp - 0x26], ax
  04F185  3735: 7d0e             jge 0x3745
  04F187  3737: 8b46da           mov ax, word ptr [bp - 0x26]
  04F18A  373A: 898620ff         mov word ptr [bp - 0xe0], ax
  04F18E  373E: 8b8676ff         mov ax, word ptr [bp - 0x8a]
  04F192  3742: 8946de           mov word ptr [bp - 0x22], ax
  04F195  3745: ff8676ff         inc word ptr [bp - 0x8a]
  04F199  3749: a19e53           mov ax, word ptr [0x539e]
  04F19C  374C: 398676ff         cmp word ptr [bp - 0x8a], ax
  04F1A0  3750: 7d03             jge 0x3755
  04F1A2  3752: e9fffe           jmp 0x3654
  04F1A5  3755: 837ede00         cmp word ptr [bp - 0x22], 0
  04F1A9  3759: 7c59             jl 0x37b4
  04F1AB  375B: ff76de           push word ptr [bp - 0x22]
  04F1AE  375E: 9ae6091f18       lcall 0x181f, 0x9e6
  04F1B3  3763: 83c402           add sp, 2
  04F1B6  3766: 8b1e4285         mov bx, word ptr [0x8542]
  04F1BA  376A: 8a07             mov al, byte ptr [bx]
  04F1BC  376C: 6b76061c         imul si, word ptr [bp + 6], 0x1c
  04F1C0  3770: 38844431         cmp byte ptr [si + 0x3144], al
  04F1C4  3774: 752a             jne 0x37a0
  04F1C6  3776: 8a4701           mov al, byte ptr [bx + 1]
  04F1C9  3779: 38844531         cmp byte ptr [si + 0x3145], al
  04F1CD  377D: 7521             jne 0x37a0
  04F1CF  377F: ff7606           push word ptr [bp + 6]
  04F1D2  3782: 9a34091f18       lcall 0x181f, 0x934
  04F1D7  3787: 83c402           add sp, 2
  04F1DA  378A: ff7606           push word ptr [bp + 6]
  04F1DD  378D: ff76de           push word ptr [bp - 0x22]
  04F1E0  3790: 9aa4091f19       lcall 0x191f, 0x9a4
  04F1E5  3795: 83c404           add sp, 4
  04F1E8  3798: b80100           mov ax, 1
  04F1EB  379B: 5e               pop si
  04F1EC  379C: 5f               pop di
  04F1ED  379D: c9               leave 
  04F1EE  379E: cb               retf 
  04F1EF  379F: 90               nop 
  04F1F0  37A0: 8a4701           mov al, byte ptr [bx + 1]
  04F1F3  37A3: 2ae4             sub ah, ah
  04F1F5  37A5: 50               push ax
  04F1F6  37A6: 8a1f             mov bl, byte ptr [bx]
  04F1F8  37A8: 2aff             sub bh, bh
  04F1FA  37AA: 8b4606           mov ax, word ptr [bp + 6]
  04F1FD  37AD: ba3300           mov dx, 0x33
  04F200  37B0: e9e2f7           jmp 0x2f95
  04F203  37B3: 90               nop 
  04F204  37B4: 837ed400         cmp word ptr [bp - 0x2c], 0
  04F208  37B8: 7522             jne 0x37dc
  04F20A  37BA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F20E  37BE: c6874b313d       mov byte ptr [bx + 0x314b], 0x3d
  04F213  37C3: c687463102       mov byte ptr [bx + 0x3146], 2
  04F218  37C8: c687593114       mov byte ptr [bx + 0x3159], 0x14
  04F21D  37CD: ff7606           push word ptr [bp + 6]
  04F220  37D0: 9a34091f18       lcall 0x181f, 0x934
  04F225  37D5: 83c402           add sp, 2
  04F228  37D8: e93d2a           jmp 0x6218
  04F22B  37DB: 90               nop 
  04F22C  37DC: f606825301       test byte ptr [0x5382], 1
  04F231  37E1: 7509             jne 0x37ec
  04F233  37E3: c746980100       mov word ptr [bp - 0x68], 1
  04F238  37E8: e9fcf8           jmp 0x30e7
  04F23B  37EB: 90               nop 
  04F23C  37EC: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04F241  37F1: 7411             je 0x3804
  04F243  37F3: 6a00             push 0
  04F245  37F5: 6a00             push 0
  04F247  37F7: 6a00             push 0
  04F249  37F9: 685a17           push 0x175a
  04F24C  37FC: 9a7e071f18       lcall 0x181f, 0x77e
  04F251  3801: 83c408           add sp, 8
  04F254  3804: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F258  3808: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04F25C  380C: 8bc3             mov ax, bx
  04F25E  380E: 2aff             sub bh, bh
  04F260  3810: 8bcb             mov cx, bx
  04F262  3812: d1e3             shl bx, 1
  04F264  3814: 03d9             add bx, cx
  04F266  3816: d1e3             shl bx, 1
  04F268  3818: 03d9             add bx, cx
  04F26A  381A: d1e3             shl bx, 1
  04F26C  381C: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  04F271  3821: 7503             jne 0x3826
  04F273  3823: e9d204           jmp 0x3cf8
  04F276  3826: 837ed400         cmp word ptr [bp - 0x2c], 0
  04F27A  382A: 7403             je 0x382f
  04F27C  382C: e9c904           jmp 0x3cf8
  04F27F  382F: 3c0d             cmp al, 0xd
  04F281  3831: 7204             jb 0x3837
  04F283  3833: 3c12             cmp al, 0x12
  04F285  3835: 7610             jbe 0x3847
  04F287  3837: 8a46a0           mov al, byte ptr [bp - 0x60]
  04F28A  383A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F28E  383E: 38874a31         cmp byte ptr [bx + 0x314a], al
  04F292  3842: 7403             je 0x3847
  04F294  3844: e9b104           jmp 0x3cf8
  04F297  3847: 8b4606           mov ax, word ptr [bp + 6]
  04F29A  384A: 89865cff         mov word ptr [bp - 0xa4], ax
  04F29E  384E: 9aee021f18       lcall 0x181f, 0x2ee
  04F2A3  3853: eb18             jmp 0x386d
  04F2A5  3855: 90               nop 
  04F2A6  3856: 6bd81c           imul bx, ax, 0x1c
  04F2A9  3859: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  04F2AE  385E: 7505             jne 0x3865
  04F2B0  3860: c6874c3100       mov byte ptr [bx + 0x314c], 0
  04F2B5  3865: 8b4606           mov ax, word ptr [bp + 6]
  04F2B8  3868: 9ae4021f18       lcall 0x181f, 0x2e4
  04F2BD  386D: 894606           mov word ptr [bp + 6], ax
  04F2C0  3870: 0bc0             or ax, ax
  04F2C2  3872: 7de2             jge 0x3856
  04F2C4  3874: 8b865cff         mov ax, word ptr [bp - 0xa4]
  04F2C8  3878: 894606           mov word ptr [bp + 6], ax
  04F2CB  387B: ff76a0           push word ptr [bp - 0x60]
  04F2CE  387E: 9ae6091f18       lcall 0x181f, 0x9e6
  04F2D3  3883: 83c402           add sp, 2
  04F2D6  3886: ffb61cff         push word ptr [bp - 0xe4]
  04F2DA  388A: 9a82051f18       lcall 0x181f, 0x582
  04F2DF  388F: 83c402           add sp, 2
  04F2E2  3892: eb22             jmp 0x38b6
  04F2E4  3894: 6a00             push 0
  04F2E6  3896: ff7606           push word ptr [bp + 6]
  04F2E9  3899: 9aec0a1f18       lcall 0x181f, 0xaec
  04F2EE  389E: 83c404           add sp, 4
  04F2F1  38A1: 89864cff         mov word ptr [bp - 0xb4], ax
  04F2F5  38A5: a1c48d           mov ax, word ptr [0x8dc4]
  04F2F8  38A8: 8bb64cff         mov si, word ptr [bp - 0xb4]
  04F2FC  38AC: d1e6             shl si, 1
  04F2FE  38AE: 8b1e4285         mov bx, word ptr [0x8542]
  04F302  38B2: 01809a00         add word ptr [bx + si + 0x9a], ax
  04F306  38B6: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F30A  38BA: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  04F30F  38BF: 75d3             jne 0x3894
  04F311  38C1: 837ece00         cmp word ptr [bp - 0x32], 0
  04F315  38C5: 7409             je 0x38d0
  04F317  38C7: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F31B  38CB: c6874a31ff       mov byte ptr [bx + 0x314a], 0xff
  04F320  38D0: 837ece00         cmp word ptr [bp - 0x32], 0
  04F324  38D4: 7409             je 0x38df
  04F326  38D6: 8b1e4285         mov bx, word ptr [0x8542]
  04F32A  38DA: c6878f0000       mov byte ptr [bx + 0x8f], 0
  04F32F  38DF: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F333  38E3: 8bc3             mov ax, bx
  04F335  38E5: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04F339  38E9: 8bf0             mov si, ax
  04F33B  38EB: 8a845031         mov al, byte ptr [si + 0x3150]
  04F33F  38EF: 2ae4             sub ah, ah
  04F341  38F1: 8bcb             mov cx, bx
  04F343  38F3: 2aff             sub bh, bh
  04F345  38F5: 8bd3             mov dx, bx
  04F347  38F7: d1e3             shl bx, 1
  04F349  38F9: 03da             add bx, dx
  04F34B  38FB: d1e3             shl bx, 1
  04F34D  38FD: 03da             add bx, dx
  04F34F  38FF: d1e3             shl bx, 1
  04F351  3901: 8a973752         mov dl, byte ptr [bx + 0x5237]
  04F355  3905: 2af6             sub dh, dh
  04F357  3907: 2bd0             sub dx, ax
  04F359  3909: 899630ff         mov word ptr [bp - 0xd0], dx
  04F35D  390D: 80f90c           cmp cl, 0xc
  04F360  3910: 750c             jne 0x391e
  04F362  3912: 83fa01           cmp dx, 1
  04F365  3915: 7e03             jle 0x391a
  04F367  3917: ba0100           mov dx, 1
  04F36A  391A: 899630ff         mov word ptr [bp - 0xd0], dx
  04F36E  391E: 837ece00         cmp word ptr [bp - 0x32], 0
  04F372  3922: 744c             je 0x3970
  04F374  3924: 8b1e4285         mov bx, word ptr [0x8542]
  04F378  3928: f6471b02         test byte ptr [bx + 0x1b], 2
  04F37C  392C: 7442             je 0x3970
  04F37E  392E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F382  3932: 80bf46310f       cmp byte ptr [bx + 0x3146], 0xf
  04F387  3937: 7337             jae 0x3970
  04F389  3939: fe875a31         inc byte ptr [bx + 0x315a]
  04F38D  393D: 8a875a31         mov al, byte ptr [bx + 0x315a]
  04F391  3941: 8bcb             mov cx, bx
  04F393  3943: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04F397  3947: 2ae4             sub ah, ah
  04F399  3949: 2aff             sub bh, bh
  04F39B  394B: 8bd3             mov dx, bx
  04F39D  394D: d1e3             shl bx, 1
  04F39F  394F: 03da             add bx, dx
  04F3A1  3951: d1e3             shl bx, 1
  04F3A3  3953: 03da             add bx, dx
  04F3A5  3955: d1e3             shl bx, 1
  04F3A7  3957: 8a973752         mov dl, byte ptr [bx + 0x5237]
  04F3AB  395B: 2af6             sub dh, dh
  04F3AD  395D: 83ea0a           sub dx, 0xa
  04F3B0  3960: f7da             neg dx
  04F3B2  3962: 3bd0             cmp dx, ax
  04F3B4  3964: 7e0a             jle 0x3970
  04F3B6  3966: 8bd9             mov bx, cx
  04F3B8  3968: c6874b3143       mov byte ptr [bx + 0x314b], 0x43
  04F3BD  396D: e9c926           jmp 0x6039
  04F3C0  3970: 837ece00         cmp word ptr [bp - 0x32], 0
  04F3C4  3974: 7503             jne 0x3979
  04F3C6  3976: e97503           jmp 0x3cee
  04F3C9  3979: 83be26ff00       cmp word ptr [bp - 0xda], 0
  04F3CE  397E: 7503             jne 0x3983
  04F3D0  3980: e96b03           jmp 0x3cee
  04F3D3  3983: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F3D7  3987: f687483120       test byte ptr [bx + 0x3148], 0x20
  04F3DC  398C: 7403             je 0x3991
  04F3DE  398E: e95d03           jmp 0x3cee
  04F3E1  3991: 8b4606           mov ax, word ptr [bp + 6]
  04F3E4  3994: 89865cff         mov word ptr [bp - 0xa4], ax
  04F3E8  3998: 9aee021f18       lcall 0x181f, 0x2ee
  04F3ED  399D: e9eb00           jmp 0x3a8b
  04F3F0  39A0: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04F3F4  39A4: d1e3             shl bx, 1
  04F3F6  39A6: 83bf341719       cmp word ptr [bx + 0x1734], 0x19
  04F3FB  39AB: 7c03             jl 0x39b0
  04F3FD  39AD: e9e500           jmp 0x3a95
  04F400  39B0: 6bd81c           imul bx, ax, 0x1c
  04F403  39B3: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04F408  39B8: 720a             jb 0x39c4
  04F40A  39BA: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04F40F  39BF: 7703             ja 0x39c4
  04F411  39C1: e9bf00           jmp 0x3a83
  04F414  39C4: 8a8630ff         mov al, byte ptr [bp - 0xd0]
  04F418  39C8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F41C  39CC: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04F420  39D0: 2aff             sub bh, bh
  04F422  39D2: 8bcb             mov cx, bx
  04F424  39D4: d1e3             shl bx, 1
  04F426  39D6: 03d9             add bx, cx
  04F428  39D8: d1e3             shl bx, 1
  04F42A  39DA: 03d9             add bx, cx
  04F42C  39DC: d1e3             shl bx, 1
  04F42E  39DE: 38873852         cmp byte ptr [bx + 0x5238], al
  04F432  39E2: 7603             jbe 0x39e7
  04F434  39E4: e99c00           jmp 0x3a83
  04F437  39E7: c78622ff0000     mov word ptr [bp - 0xde], 0
  04F43D  39ED: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F441  39F1: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04F446  39F6: 7207             jb 0x39ff
  04F448  39F8: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04F44D  39FD: 763b             jbe 0x3a3a
  04F44F  39FF: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F453  3A03: 8bc3             mov ax, bx
  04F455  3A05: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04F459  3A09: 2aff             sub bh, bh
  04F45B  3A0B: 8bcb             mov cx, bx
  04F45D  3A0D: d1e3             shl bx, 1
  04F45F  3A0F: 03d9             add bx, cx
  04F461  3A11: d1e3             shl bx, 1
  04F463  3A13: 03d9             add bx, cx
  04F465  3A15: d1e3             shl bx, 1
  04F467  3A17: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  04F46C  3A1C: 761c             jbe 0x3a3a
  04F46E  3A1E: 8bd8             mov bx, ax
  04F470  3A20: 80bf4b3147       cmp byte ptr [bx + 0x314b], 0x47
  04F475  3A25: 7413             je 0x3a3a
  04F477  3A27: 80bf4b3141       cmp byte ptr [bx + 0x314b], 0x41
  04F47C  3A2C: 740c             je 0x3a3a
  04F47E  3A2E: 837ed800         cmp word ptr [bp - 0x28], 0
  04F482  3A32: 7506             jne 0x3a3a
  04F484  3A34: c78622ff0100     mov word ptr [bp - 0xde], 1
  04F48A  3A3A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F48E  3A3E: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  04F493  3A43: 7512             jne 0x3a57
  04F495  3A45: 837eee00         cmp word ptr [bp - 0x12], 0
  04F499  3A49: 7506             jne 0x3a51
  04F49B  3A4B: 837ed800         cmp word ptr [bp - 0x28], 0
  04F49F  3A4F: 7532             jne 0x3a83
  04F4A1  3A51: c78622ff0100     mov word ptr [bp - 0xde], 1
  04F4A7  3A57: 83be22ff00       cmp word ptr [bp - 0xde], 0
  04F4AC  3A5C: 7425             je 0x3a83
  04F4AE  3A5E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F4B2  3A62: c6874c3101       mov byte ptr [bx + 0x314c], 1
  04F4B7  3A67: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04F4BB  3A6B: 2aff             sub bh, bh
  04F4BD  3A6D: 8bc3             mov ax, bx
  04F4BF  3A6F: d1e3             shl bx, 1
  04F4C1  3A71: 03d8             add bx, ax
  04F4C3  3A73: d1e3             shl bx, 1
  04F4C5  3A75: 03d8             add bx, ax
  04F4C7  3A77: d1e3             shl bx, 1
  04F4C9  3A79: 8a873852         mov al, byte ptr [bx + 0x5238]
  04F4CD  3A7D: 2ae4             sub ah, ah
  04F4CF  3A7F: 298630ff         sub word ptr [bp - 0xd0], ax
  04F4D3  3A83: 8b4606           mov ax, word ptr [bp + 6]
  04F4D6  3A86: 9ae4021f18       lcall 0x181f, 0x2e4
  04F4DB  3A8B: 894606           mov word ptr [bp + 6], ax
  04F4DE  3A8E: 0bc0             or ax, ax
  04F4E0  3A90: 7c03             jl 0x3a95
  04F4E2  3A92: e90bff           jmp 0x39a0
  04F4E5  3A95: 8b865cff         mov ax, word ptr [bp - 0xa4]
  04F4E9  3A99: 894606           mov word ptr [bp + 6], ax
  04F4EC  3A9C: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04F4F0  3AA0: d1e3             shl bx, 1
  04F4F2  3AA2: c78734170000     mov word ptr [bx + 0x1734], 0
  04F4F8  3AA8: e94302           jmp 0x3cee
  04F4FB  3AAB: 90               nop 
  04F4FC  3AAC: 83be36ff00       cmp word ptr [bp - 0xca], 0
  04F501  3AB1: 7503             jne 0x3ab6
  04F503  3AB3: e94202           jmp 0x3cf8
  04F506  3AB6: b8ffff           mov ax, 0xffff
  04F509  3AB9: 8946de           mov word ptr [bp - 0x22], ax
  04F50C  3ABC: 898620ff         mov word ptr [bp - 0xe0], ax
  04F510  3AC0: 9a3a0d1f18       lcall 0x181f, 0xd3a
  04F515  3AC5: 89865eff         mov word ptr [bp - 0xa2], ax
  04F519  3AC9: c7864cff0000     mov word ptr [bp - 0xb4], 0
  04F51F  3ACF: eb29             jmp 0x3afa
  04F521  3AD1: 90               nop 
  04F522  3AD2: 83be4cff08       cmp word ptr [bp - 0xb4], 8
  04F527  3AD7: 7516             jne 0x3aef
  04F529  3AD9: b81900           mov ax, 0x19
  04F52C  3ADC: 2b865eff         sub ax, word ptr [bp - 0xa2]
  04F530  3AE0: 0146cc           add word ptr [bp - 0x34], ax
  04F533  3AE3: 8b46cc           mov ax, word ptr [bp - 0x34]
  04F536  3AE6: 48               dec ax
  04F537  3AE7: 48               dec ax
  04F538  3AE8: 7902             jns 0x3aec
  04F53A  3AEA: 2bc0             sub ax, ax
  04F53C  3AEC: 8946cc           mov word ptr [bp - 0x34], ax
  04F53F  3AEF: 83be4cff05       cmp word ptr [bp - 0xb4], 5
  04F544  3AF4: 7530             jne 0x3b26
  04F546  3AF6: ff864cff         inc word ptr [bp - 0xb4]
  04F54A  3AFA: 83be4cff10       cmp word ptr [bp - 0xb4], 0x10
  04F54F  3AFF: 7c03             jl 0x3b04
  04F551  3B01: e92401           jmp 0x3c28
  04F554  3B04: 8bb64cff         mov si, word ptr [bp - 0xb4]
  04F558  3B08: d1e6             shl si, 1
  04F55A  3B0A: 8b1e4285         mov bx, word ptr [0x8542]
  04F55E  3B0E: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  04F562  3B12: 8946cc           mov word ptr [bp - 0x34], ax
  04F565  3B15: 3b865eff         cmp ax, word ptr [bp - 0xa2]
  04F569  3B19: 7cb7             jl 0x3ad2
  04F56B  3B1B: 83be4cff00       cmp word ptr [bp - 0xb4], 0
  04F570  3B20: 74b0             je 0x3ad2
  04F572  3B22: d1e0             shl ax, 1
  04F574  3B24: ebc6             jmp 0x3aec
  04F576  3B26: 83be4cff0e       cmp word ptr [bp - 0xb4], 0xe
  04F57B  3B2B: 7407             je 0x3b34
  04F57D  3B2D: 83be4cff0f       cmp word ptr [bp - 0xb4], 0xf
  04F582  3B32: 7519             jne 0x3b4d
  04F584  3B34: 837ece00         cmp word ptr [bp - 0x32], 0
  04F588  3B38: 74bc             je 0x3af6
  04F58A  3B3A: 8a8e4cff         mov cl, byte ptr [bp - 0xb4]
  04F58E  3B3E: b80100           mov ax, 1
  04F591  3B41: d3e0             shl ax, cl
  04F593  3B43: 85879000         test word ptr [bx + 0x90], ax
  04F597  3B47: 74ad             je 0x3af6
  04F599  3B49: 836ecc64         sub word ptr [bp - 0x34], 0x64
  04F59D  3B4D: 837ece00         cmp word ptr [bp - 0x32], 0
  04F5A1  3B51: 7407             je 0x3b5a
  04F5A3  3B53: 83be4cff0d       cmp word ptr [bp - 0xb4], 0xd
  04F5A8  3B58: 749c             je 0x3af6
  04F5AA  3B5A: 837ece00         cmp word ptr [bp - 0x32], 0
  04F5AE  3B5E: 7407             je 0x3b67
  04F5B0  3B60: 83be4cff00       cmp word ptr [bp - 0xb4], 0
  04F5B5  3B65: 748f             je 0x3af6
  04F5B7  3B67: 837ecc00         cmp word ptr [bp - 0x34], 0
  04F5BB  3B6B: 7489             je 0x3af6
  04F5BD  3B6D: 837ece00         cmp word ptr [bp - 0x32], 0
  04F5C1  3B71: 7419             je 0x3b8c
  04F5C3  3B73: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04F5C7  3B77: c1e604           shl si, 4
  04F5CA  3B7A: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  04F5CE  3B7E: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  04F5D2  3B82: 2ae4             sub ah, ah
  04F5D4  3B84: f76ecc           imul word ptr [bp - 0x34]
  04F5D7  3B87: 8946da           mov word ptr [bp - 0x26], ax
  04F5DA  3B8A: eb7e             jmp 0x3c0a
  04F5DC  3B8C: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04F5E0  3B90: c1e604           shl si, 4
  04F5E3  3B93: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  04F5E7  3B97: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  04F5EB  3B9B: 2ae4             sub ah, ah
  04F5ED  3B9D: 8946da           mov word ptr [bp - 0x26], ax
  04F5F0  3BA0: eb13             jmp 0x3bb5
  04F5F2  3BA2: 6a03             push 3
  04F5F4  3BA4: 6a00             push 0
  04F5F6  3BA6: 9ad4041f18       lcall 0x181f, 0x4d4
  04F5FB  3BAB: 83c404           add sp, 4
  04F5FE  3BAE: 0bc0             or ax, ax
  04F600  3BB0: 7509             jne 0x3bbb
  04F602  3BB2: ff4eda           dec word ptr [bp - 0x26]
  04F605  3BB5: 837eda02         cmp word ptr [bp - 0x26], 2
  04F609  3BB9: 7de7             jge 0x3ba2
  04F60B  3BBB: 83be4cff0d       cmp word ptr [bp - 0xb4], 0xd
  04F610  3BC0: 7506             jne 0x3bc8
  04F612  3BC2: b80800           mov ax, 8
  04F615  3BC5: eb04             jmp 0x3bcb
  04F617  3BC7: 90               nop 
  04F618  3BC8: b80400           mov ax, 4
  04F61B  3BCB: 89865cff         mov word ptr [bp - 0xa4], ax
  04F61F  3BCF: 3b46da           cmp ax, word ptr [bp - 0x26]
  04F622  3BD2: 7e26             jle 0x3bfa
  04F624  3BD4: 8b4eda           mov cx, word ptr [bp - 0x26]
  04F627  3BD7: 894eaa           mov word ptr [bp - 0x56], cx
  04F62A  3BDA: 2bc1             sub ax, cx
  04F62C  3BDC: 8946da           mov word ptr [bp - 0x26], ax
  04F62F  3BDF: 8b46cc           mov ax, word ptr [bp - 0x34]
  04F632  3BE2: f76eda           imul word ptr [bp - 0x26]
  04F635  3BE5: 8946da           mov word ptr [bp - 0x26], ax
  04F638  3BE8: b80100           mov ax, 1
  04F63B  3BEB: 2bc1             sub ax, cx
  04F63D  3BED: 8bc8             mov cx, ax
  04F63F  3BEF: c1e002           shl ax, 2
  04F642  3BF2: 03c1             add ax, cx
  04F644  3BF4: 0146da           add word ptr [bp - 0x26], ax
  04F647  3BF7: eb06             jmp 0x3bff
  04F649  3BF9: 90               nop 
  04F64A  3BFA: c746daffff       mov word ptr [bp - 0x26], 0xffff
  04F64F  3BFF: 837ecc32         cmp word ptr [bp - 0x34], 0x32
  04F653  3C03: 7d05             jge 0x3c0a
  04F655  3C05: c746daffff       mov word ptr [bp - 0x26], 0xffff
  04F65A  3C0A: 8b8620ff         mov ax, word ptr [bp - 0xe0]
  04F65E  3C0E: 3946da           cmp word ptr [bp - 0x26], ax
  04F661  3C11: 7f03             jg 0x3c16
  04F663  3C13: e9e0fe           jmp 0x3af6
  04F666  3C16: 8b46da           mov ax, word ptr [bp - 0x26]
  04F669  3C19: 898620ff         mov word ptr [bp - 0xe0], ax
  04F66D  3C1D: 8b864cff         mov ax, word ptr [bp - 0xb4]
  04F671  3C21: 8946de           mov word ptr [bp - 0x22], ax
  04F674  3C24: e9cffe           jmp 0x3af6
  04F677  3C27: 90               nop 
  04F678  3C28: 837ede00         cmp word ptr [bp - 0x22], 0
  04F67C  3C2C: 7d03             jge 0x3c31
  04F67E  3C2E: e9b700           jmp 0x3ce8
  04F681  3C31: 8b76de           mov si, word ptr [bp - 0x22]
  04F684  3C34: d1e6             shl si, 1
  04F686  3C36: 8b1e4285         mov bx, word ptr [0x8542]
  04F68A  3C3A: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  04F68E  3C3E: 8bc8             mov cx, ax
  04F690  3C40: 3d6400           cmp ax, 0x64
  04F693  3C43: 7e03             jle 0x3c48
  04F695  3C45: b86400           mov ax, 0x64
  04F698  3C48: 8946cc           mov word ptr [bp - 0x34], ax
  04F69B  3C4B: 837ede00         cmp word ptr [bp - 0x22], 0
  04F69F  3C4F: 7510             jne 0x3c61
  04F6A1  3C51: 3d0a00           cmp ax, 0xa
  04F6A4  3C54: 7e0b             jle 0x3c61
  04F6A6  3C56: 83f96e           cmp cx, 0x6e
  04F6A9  3C59: 7d06             jge 0x3c61
  04F6AB  3C5B: 2d0a00           sub ax, 0xa
  04F6AE  3C5E: 8946cc           mov word ptr [bp - 0x34], ax
  04F6B1  3C61: 837ede08         cmp word ptr [bp - 0x22], 8
  04F6B5  3C65: 750e             jne 0x3c75
  04F6B7  3C67: 8b87aa00         mov ax, word ptr [bx + 0xaa]
  04F6BB  3C6B: 2b865eff         sub ax, word ptr [bp - 0xa2]
  04F6BF  3C6F: 051900           add ax, 0x19
  04F6C2  3C72: 8946cc           mov word ptr [bp - 0x34], ax
  04F6C5  3C75: 837ede0e         cmp word ptr [bp - 0x22], 0xe
  04F6C9  3C79: 7406             je 0x3c81
  04F6CB  3C7B: 837ede0f         cmp word ptr [bp - 0x22], 0xf
  04F6CF  3C7F: 7517             jne 0x3c98
  04F6D1  3C81: 8b76de           mov si, word ptr [bp - 0x22]
  04F6D4  3C84: d1e6             shl si, 1
  04F6D6  3C86: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  04F6DA  3C8A: 2d6400           sub ax, 0x64
  04F6DD  3C8D: 3b46cc           cmp ax, word ptr [bp - 0x34]
  04F6E0  3C90: 7e03             jle 0x3c95
  04F6E2  3C92: 8b46cc           mov ax, word ptr [bp - 0x34]
  04F6E5  3C95: 8946cc           mov word ptr [bp - 0x34], ax
  04F6E8  3C98: 8b76de           mov si, word ptr [bp - 0x22]
  04F6EB  3C9B: d1e6             shl si, 1
  04F6ED  3C9D: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  04F6F1  3CA1: 3d6400           cmp ax, 0x64
  04F6F4  3CA4: 7e03             jle 0x3ca9
  04F6F6  3CA6: b86400           mov ax, 0x64
  04F6F9  3CA9: 8946cc           mov word ptr [bp - 0x34], ax
  04F6FC  3CAC: 29809a00         sub word ptr [bx + si + 0x9a], ax
  04F700  3CB0: ff76cc           push word ptr [bp - 0x34]
  04F703  3CB3: ff76de           push word ptr [bp - 0x22]
  04F706  3CB6: ff7606           push word ptr [bp + 6]
  04F709  3CB9: 9a580d1f18       lcall 0x181f, 0xd58
  04F70E  3CBE: 83c406           add sp, 6
  04F711  3CC1: ff8e30ff         dec word ptr [bp - 0xd0]
  04F715  3CC5: 837ece00         cmp word ptr [bp - 0x32], 0
  04F719  3CC9: 740b             je 0x3cd6
  04F71B  3CCB: 8a46a0           mov al, byte ptr [bp - 0x60]
  04F71E  3CCE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F722  3CD2: 88874a31         mov byte ptr [bx + 0x314a], al
  04F726  3CD6: 837ece00         cmp word ptr [bp - 0x32], 0
  04F72A  3CDA: 7512             jne 0x3cee
  04F72C  3CDC: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F730  3CE0: c687583101       mov byte ptr [bx + 0x3158], 1
  04F735  3CE5: eb07             jmp 0x3cee
  04F737  3CE7: 90               nop 
  04F738  3CE8: c78630ff0000     mov word ptr [bp - 0xd0], 0
  04F73E  3CEE: 83be30ff00       cmp word ptr [bp - 0xd0], 0
  04F743  3CF3: 7403             je 0x3cf8
  04F745  3CF5: e9b4fd           jmp 0x3aac
  04F748  3CF8: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04F74D  3CFD: 7411             je 0x3d10
  04F74F  3CFF: 6a00             push 0
  04F751  3D01: 6a00             push 0
  04F753  3D03: 6a00             push 0
  04F755  3D05: 685e17           push 0x175e
  04F758  3D08: 9a7e071f18       lcall 0x181f, 0x77e
  04F75D  3D0D: 83c408           add sp, 8
  04F760  3D10: 837ece00         cmp word ptr [bp - 0x32], 0
  04F764  3D14: 7503             jne 0x3d19
  04F766  3D16: e91a0e           jmp 0x4b33
  04F769  3D19: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F76D  3D1D: 8a875031         mov al, byte ptr [bx + 0x3150]
  04F771  3D21: 2ae4             sub ah, ah
  04F773  3D23: 89864cff         mov word ptr [bp - 0xb4], ax
  04F777  3D27: 6a10             push 0x10
  04F779  3D29: 6a00             push 0
  04F77B  3D2B: 8d863aff         lea ax, [bp - 0xc6]
  04F77F  3D2F: 50               push ax
  04F780  3D30: 9aae0d1d0d       lcall 0xd1d, 0xdae
  04F785  3D35: 83c406           add sp, 6
  04F788  3D38: c746beffff       mov word ptr [bp - 0x42], 0xffff
  04F78D  3D3D: c78676ff0000     mov word ptr [bp - 0x8a], 0
  04F793  3D43: eb42             jmp 0x3d87
  04F795  3D45: 90               nop 
  04F796  3D46: 50               push ax
  04F797  3D47: ff7606           push word ptr [bp + 6]
  04F79A  3D4A: 9ae60b1f18       lcall 0x181f, 0xbe6
  04F79F  3D4F: 83c404           add sp, 4
  04F7A2  3D52: 894688           mov word ptr [bp - 0x78], ax
  04F7A5  3D55: 3d0d00           cmp ax, 0xd
  04F7A8  3D58: 7d05             jge 0x3d5f
  04F7AA  3D5A: 3d0800           cmp ax, 8
  04F7AD  3D5D: 7524             jne 0x3d83
  04F7AF  3D5F: 8b46be           mov ax, word ptr [bp - 0x42]
  04F7B2  3D62: 394688           cmp word ptr [bp - 0x78], ax
  04F7B5  3D65: 7e06             jle 0x3d6d
  04F7B7  3D67: 8b4688           mov ax, word ptr [bp - 0x78]
  04F7BA  3D6A: 8946be           mov word ptr [bp - 0x42], ax
  04F7BD  3D6D: ffb676ff         push word ptr [bp - 0x8a]
  04F7C1  3D71: ff7606           push word ptr [bp + 6]
  04F7C4  3D74: 9a680c1f18       lcall 0x181f, 0xc68
  04F7C9  3D79: 83c404           add sp, 4
  04F7CC  3D7C: 8b7688           mov si, word ptr [bp - 0x78]
  04F7CF  3D7F: 00823aff         add byte ptr [bp + si - 0xc6], al
  04F7D3  3D83: ff8676ff         inc word ptr [bp - 0x8a]
  04F7D7  3D87: 8b8676ff         mov ax, word ptr [bp - 0x8a]
  04F7DB  3D8B: 39864cff         cmp word ptr [bp - 0xb4], ax
  04F7DF  3D8F: 7fb5             jg 0x3d46
  04F7E1  3D91: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04F7E6  3D96: 7411             je 0x3da9
  04F7E8  3D98: 6a00             push 0
  04F7EA  3D9A: 6a00             push 0
  04F7EC  3D9C: 6a00             push 0
  04F7EE  3D9E: 686217           push 0x1762
  04F7F1  3DA1: 9a7e071f18       lcall 0x181f, 0x77e
  04F7F6  3DA6: 83c408           add sp, 8
  04F7F9  3DA9: ff7606           push word ptr [bp + 6]
  04F7FC  3DAC: 9a20091f18       lcall 0x181f, 0x920
  04F801  3DB1: 83c402           add sp, 2
  04F804  3DB4: 6a02             push 2
  04F806  3DB6: ff7606           push word ptr [bp + 6]
  04F809  3DB9: 9abc081f18       lcall 0x181f, 0x8bc
  04F80E  3DBE: 83c404           add sp, 4
  04F811  3DC1: 48               dec ax
  04F812  3DC2: 89865aff         mov word ptr [bp - 0xa6], ax
  04F816  3DC6: 6a03             push 3
  04F818  3DC8: ff7606           push word ptr [bp + 6]
  04F81B  3DCB: 9abc081f18       lcall 0x181f, 0x8bc
  04F820  3DD0: 83c404           add sp, 4
  04F823  3DD3: 8946b8           mov word ptr [bp - 0x48], ax
  04F826  3DD6: 6a04             push 4
  04F828  3DD8: ff7606           push word ptr [bp + 6]
  04F82B  3DDB: 9abc081f18       lcall 0x181f, 0x8bc
  04F830  3DE0: 83c404           add sp, 4
  04F833  3DE3: 8946ba           mov word ptr [bp - 0x46], ax
  04F836  3DE6: 6a06             push 6
  04F838  3DE8: ff7606           push word ptr [bp + 6]
  04F83B  3DEB: 9abc081f18       lcall 0x181f, 0x8bc
  04F840  3DF0: 83c404           add sp, 4
  04F843  3DF3: 8946bc           mov word ptr [bp - 0x44], ax
  04F846  3DF6: 6a05             push 5
  04F848  3DF8: ff7606           push word ptr [bp + 6]
  04F84B  3DFB: 9abc081f18       lcall 0x181f, 0x8bc
  04F850  3E00: 83c404           add sp, 4
  04F853  3E03: 8946ec           mov word ptr [bp - 0x14], ax
  04F856  3E06: 2b865aff         sub ax, word ptr [bp - 0xa6]
  04F85A  3E0A: f7d8             neg ax
  04F85C  3E0C: 2b46ba           sub ax, word ptr [bp - 0x46]
  04F85F  3E0F: 2b46b8           sub ax, word ptr [bp - 0x48]
  04F862  3E12: 894680           mov word ptr [bp - 0x80], ax
  04F865  3E15: 8b46b8           mov ax, word ptr [bp - 0x48]
  04F868  3E18: 89864eff         mov word ptr [bp - 0xb2], ax
  04F86C  3E1C: f606825301       test byte ptr [0x5382], 1
  04F871  3E21: 7410             je 0x3e33
  04F873  3E23: 6a0c             push 0xc
  04F875  3E25: ff7606           push word ptr [bp + 6]
  04F878  3E28: 9abc081f18       lcall 0x181f, 0x8bc
  04F87D  3E2D: 83c404           add sp, 4
  04F880  3E30: 0146ba           add word ptr [bp - 0x46], ax
  04F883  3E33: ffb66eff         push word ptr [bp - 0x92]
  04F887  3E37: ffb67aff         push word ptr [bp - 0x86]
  04F88B  3E3B: ff7606           push word ptr [bp + 6]
  04F88E  3E3E: 9a48091f18       lcall 0x181f, 0x948
  04F893  3E43: 83c406           add sp, 6
  04F896  3E46: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04F89B  3E4B: 7411             je 0x3e5e
  04F89D  3E4D: 6a00             push 0
  04F89F  3E4F: 6a00             push 0
  04F8A1  3E51: 6a00             push 0
  04F8A3  3E53: 686417           push 0x1764
  04F8A6  3E56: 9a7e071f18       lcall 0x181f, 0x77e
  04F8AB  3E5B: 83c408           add sp, 8
  04F8AE  3E5E: 6a07             push 7
  04F8B0  3E60: ffb66eff         push word ptr [bp - 0x92]
  04F8B4  3E64: ffb67aff         push word ptr [bp - 0x86]
  04F8B8  3E68: ffb61cff         push word ptr [bp - 0xe4]
  04F8BC  3E6C: 0e               push cs
  04F8BD  3E6D: e8743c           call 0x7ae4
  04F8C0  3E70: 83c408           add sp, 8
  04F8C3  3E73: 89469c           mov word ptr [bp - 0x64], ax
  04F8C6  3E76: 6a01             push 1
  04F8C8  3E78: ffb66eff         push word ptr [bp - 0x92]
  04F8CC  3E7C: ffb67aff         push word ptr [bp - 0x86]
  04F8D0  3E80: ffb61cff         push word ptr [bp - 0xe4]
  04F8D4  3E84: 0e               push cs
  04F8D5  3E85: e85c3c           call 0x7ae4
  04F8D8  3E88: 83c408           add sp, 8
  04F8DB  3E8B: 898616ff         mov word ptr [bp - 0xea], ax
  04F8DF  3E8F: ff7606           push word ptr [bp + 6]
  04F8E2  3E92: 0e               push cs
  04F8E3  3E93: e8d63b           call 0x7a6c
  04F8E6  3E96: 83c402           add sp, 2
  04F8E9  3E99: 89469a           mov word ptr [bp - 0x66], ax
  04F8EC  3E9C: 0bc0             or ax, ax
  04F8EE  3E9E: 7c46             jl 0x3ee6
  04F8F0  3EA0: 6aff             push -1
  04F8F2  3EA2: 50               push ax
  04F8F3  3EA3: ffb61cff         push word ptr [bp - 0xe4]
  04F8F7  3EA7: 0e               push cs
  04F8F8  3EA8: e81b3c           call 0x7ac6
  04F8FB  3EAB: 83c406           add sp, 6
  04F8FE  3EAE: ffb61cff         push word ptr [bp - 0xe4]
  04F902  3EB2: 8bf0             mov si, ax
  04F904  3EB4: 0e               push cs
  04F905  3EB5: e8c83b           call 0x7a80
  04F908  3EB8: 83c402           add sp, 2
  04F90B  3EBB: 03f0             add si, ax
  04F90D  3EBD: 8976aa           mov word ptr [bp - 0x56], si
  04F910  3EC0: 0bf6             or si, si
  04F912  3EC2: 7e10             jle 0x3ed4
  04F914  3EC4: 8b4680           mov ax, word ptr [bp - 0x80]
  04F917  3EC7: 894682           mov word ptr [bp - 0x7e], ax
  04F91A  3ECA: 0146b8           add word ptr [bp - 0x48], ax
  04F91D  3ECD: c746800000       mov word ptr [bp - 0x80], 0
  04F922  3ED2: eb12             jmp 0x3ee6
  04F924  3ED4: 83be16ff00       cmp word ptr [bp - 0xea], 0
  04F929  3ED9: 750b             jne 0x3ee6
  04F92B  3EDB: 8b46b8           mov ax, word ptr [bp - 0x48]
  04F92E  3EDE: 014680           add word ptr [bp - 0x80], ax
  04F931  3EE1: c746b80000       mov word ptr [bp - 0x48], 0
  04F936  3EE6: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04F93B  3EEB: 7415             je 0x3f02
  04F93D  3EED: ffb65aff         push word ptr [bp - 0xa6]
  04F941  3EF1: ff76ba           push word ptr [bp - 0x46]
  04F944  3EF4: ff76b8           push word ptr [bp - 0x48]
  04F947  3EF7: 686617           push 0x1766
  04F94A  3EFA: 9a7e071f18       lcall 0x181f, 0x77e
  04F94F  3EFF: 83c408           add sp, 8
  04F952  3F02: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  04F957  3F07: 7503             jne 0x3f0c
  04F959  3F09: e9e407           jmp 0x46f0
  04F95C  3F0C: c78666ff0000     mov word ptr [bp - 0x9a], 0
  04F962  3F12: 837eb800         cmp word ptr [bp - 0x48], 0
  04F966  3F16: 750f             jne 0x3f27
  04F968  3F18: 837eba00         cmp word ptr [bp - 0x46], 0
  04F96C  3F1C: 7509             jne 0x3f27
  04F96E  3F1E: 837eec00         cmp word ptr [bp - 0x14], 0
  04F972  3F22: 7503             jne 0x3f27
  04F974  3F24: e94d03           jmp 0x4274
  04F977  3F27: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04F97C  3F2C: 7411             je 0x3f3f
  04F97E  3F2E: 6a00             push 0
  04F980  3F30: 6a00             push 0
  04F982  3F32: 6a00             push 0
  04F984  3F34: 686817           push 0x1768
  04F987  3F37: 9a7e071f18       lcall 0x181f, 0x77e
  04F98C  3F3C: 83c408           add sp, 8
  04F98F  3F3F: c746b20000       mov word ptr [bp - 0x4e], 0
  04F994  3F44: e98902           jmp 0x41d0
  04F997  3F47: 90               nop 
  04F998  3F48: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04F99C  3F4C: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  04F9A1  3F51: 751f             jne 0x3f72
  04F9A3  3F53: 8a874e31         mov al, byte ptr [bx + 0x314e]
  04F9A7  3F57: 2ae4             sub ah, ah
  04F9A9  3F59: 50               push ax
  04F9AA  3F5A: 8a874d31         mov al, byte ptr [bx + 0x314d]
  04F9AE  3F5E: 50               push ax
  04F9AF  3F5F: 9a22071f18       lcall 0x181f, 0x722
  04F9B4  3F64: 83c404           add sp, 4
  04F9B7  3F67: 3b46a2           cmp ax, word ptr [bp - 0x5e]
  04F9BA  3F6A: 7506             jne 0x3f72
  04F9BC  3F6C: c78666ffffff     mov word ptr [bp - 0x9a], 0xffff
  04F9C2  3F72: 837eec00         cmp word ptr [bp - 0x14], 0
  04F9C6  3F76: 7446             je 0x3fbe
  04F9C8  3F78: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04F9CC  3F7C: c1e304           shl bx, 4
  04F9CF  3F7F: 035ea2           add bx, word ptr [bp - 0x5e]
  04F9D2  3F82: 80bf709800       cmp byte ptr [bx - 0x6790], 0
  04F9D7  3F87: 7435             je 0x3fbe
  04F9D9  3F89: 80bfe69401       cmp byte ptr [bx - 0x6b1a], 1
  04F9DE  3F8E: 730c             jae 0x3f9c
  04F9E0  3F90: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04F9E3  3F93: d1e3             shl bx, 1
  04F9E5  3F95: 83bfc8850a       cmp word ptr [bx - 0x7a38], 0xa
  04F9EA  3F9A: 7f1d             jg 0x3fb9
  04F9EC  3F9C: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04F9F0  3FA0: c1e604           shl si, 4
  04F9F3  3FA3: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04F9F6  3FA6: 8a80a694         mov al, byte ptr [bx + si - 0x6b5a]
  04F9FA  3FAA: 2ae4             sub ah, ah
  04F9FC  3FAC: d1e3             shl bx, 1
  04F9FE  3FAE: 8b8fc885         mov cx, word ptr [bx - 0x7a38]
  04FA02  3FB2: c1f903           sar cx, 3
  04FA05  3FB5: 3bc1             cmp ax, cx
  04FA07  3FB7: 7d05             jge 0x3fbe
  04FA09  3FB9: 808e66ff20       or byte ptr [bp - 0x9a], 0x20
  04FA0E  3FBE: 837eb800         cmp word ptr [bp - 0x48], 0
  04FA12  3FC2: 7503             jne 0x3fc7
  04FA14  3FC4: e9ef00           jmp 0x40b6
  04FA17  3FC7: ff76a2           push word ptr [bp - 0x5e]
  04FA1A  3FCA: ffb61cff         push word ptr [bp - 0xe4]
  04FA1E  3FCE: 0e               push cs
  04FA1F  3FCF: e8c73a           call 0x7a99
  04FA22  3FD2: 83c404           add sp, 4
  04FA25  3FD5: 0bc0             or ax, ax
  04FA27  3FD7: 7e05             jle 0x3fde
  04FA29  3FD9: 808e66ff40       or byte ptr [bp - 0x9a], 0x40
  04FA2E  3FDE: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04FA32  3FE2: c1e604           shl si, 4
  04FA35  3FE5: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04FA38  3FE8: 80b8a69400       cmp byte ptr [bx + si - 0x6b5a], 0
  04FA3D  3FED: 7505             jne 0x3ff4
  04FA3F  3FEF: 808e66ff40       or byte ptr [bp - 0x9a], 0x40
  04FA44  3FF4: c7866aff0100     mov word ptr [bp - 0x96], 1
  04FA4A  3FFA: 837ea000         cmp word ptr [bp - 0x60], 0
  04FA4E  3FFE: 7c2f             jl 0x402f
  04FA50  4000: 8bc3             mov ax, bx
  04FA52  4002: 3946d6           cmp word ptr [bp - 0x2a], ax
  04FA55  4005: 7528             jne 0x402f
  04FA57  4007: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04FA5B  400B: c1e604           shl si, 4
  04FA5E  400E: 8a80e694         mov al, byte ptr [bx + si - 0x6b1a]
  04FA62  4012: 2ae4             sub ah, ah
  04FA64  4014: 2d0800           sub ax, 8
  04FA67  4017: f7d8             neg ax
  04FA69  4019: 3b46d4           cmp ax, word ptr [bp - 0x2c]
  04FA6C  401C: 7e05             jle 0x4023
  04FA6E  401E: 80a666ffbf       and byte ptr [bp - 0x9a], 0xbf
  04FA73  4023: 837ed40c         cmp word ptr [bp - 0x2c], 0xc
  04FA77  4027: 7c06             jl 0x402f
  04FA79  4029: c7866aff0000     mov word ptr [bp - 0x96], 0
  04FA7F  402F: 83be6aff00       cmp word ptr [bp - 0x96], 0
  04FA84  4034: 7441             je 0x4077
  04FA86  4036: a18e53           mov ax, word ptr [0x538e]
  04FA89  4039: c1f804           sar ax, 4
  04FA8C  403C: 8946aa           mov word ptr [bp - 0x56], ax
  04FA8F  403F: 833e509600       cmp word ptr [0x9650], 0
  04FA94  4044: 7431             je 0x4077
  04FA96  4046: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04FA9A  404A: c1e304           shl bx, 4
  04FA9D  404D: 035ea2           add bx, word ptr [bp - 0x5e]
  04FAA0  4050: 8a8fe694         mov cl, byte ptr [bx - 0x6b1a]
  04FAA4  4054: 2aed             sub ch, ch
  04FAA6  4056: c1e102           shl cx, 2
  04FAA9  4059: 8a97a694         mov dl, byte ptr [bx - 0x6b5a]
  04FAAD  405D: 2af6             sub dh, dh
  04FAAF  405F: 03ca             add cx, dx
  04FAB1  4061: 3bc8             cmp cx, ax
  04FAB3  4063: 7e12             jle 0x4077
  04FAB5  4065: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04FAB9  4069: d1e3             shl bx, 1
  04FABB  406B: 83bf341714       cmp word ptr [bx + 0x1734], 0x14
  04FAC0  4070: 7d05             jge 0x4077
  04FAC2  4072: 80a666ffbf       and byte ptr [bp - 0x9a], 0xbf
  04FAC7  4077: 837e8200         cmp word ptr [bp - 0x7e], 0
  04FACB  407B: 740f             je 0x408c
  04FACD  407D: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04FAD0  4080: 80bf3ca101       cmp byte ptr [bx - 0x5ec4], 1
  04FAD5  4085: 7605             jbe 0x408c
  04FAD7  4087: 80a666ffbf       and byte ptr [bp - 0x9a], 0xbf
  04FADC  408C: 837e9c00         cmp word ptr [bp - 0x64], 0
  04FAE0  4090: 7405             je 0x4097
  04FAE2  4092: 808e66ff40       or byte ptr [bp - 0x9a], 0x40
  04FAE7  4097: 83be16ff00       cmp word ptr [bp - 0xea], 0
  04FAEC  409C: 7405             je 0x40a3
  04FAEE  409E: 808e66ff40       or byte ptr [bp - 0x9a], 0x40
  04FAF3  40A3: 8a4ea2           mov cl, byte ptr [bp - 0x5e]
  04FAF6  40A6: b80100           mov ax, 1
  04FAF9  40A9: d3e0             shl ax, cl
  04FAFB  40AB: 85063e17         test word ptr [0x173e], ax
  04FAFF  40AF: 7405             je 0x40b6
  04FB01  40B1: 808e66ff40       or byte ptr [bp - 0x9a], 0x40
  04FB06  40B6: 837eba00         cmp word ptr [bp - 0x46], 0
  04FB0A  40BA: 741d             je 0x40d9
  04FB0C  40BC: f606825301       test byte ptr [0x5382], 1
  04FB11  40C1: 7416             je 0x40d9
  04FB13  40C3: 8b369853         mov si, word ptr [0x5398]
  04FB17  40C7: c1e604           shl si, 4
  04FB1A  40CA: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04FB1D  40CD: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  04FB22  40D2: 7405             je 0x40d9
  04FB24  40D4: 808e66ff10       or byte ptr [bp - 0x9a], 0x10
  04FB29  40D9: 837eba00         cmp word ptr [bp - 0x46], 0
  04FB2D  40DD: 7503             jne 0x40e2
  04FB2F  40DF: e99600           jmp 0x4178
  04FB32  40E2: f606825301       test byte ptr [0x5382], 1
  04FB37  40E7: 7403             je 0x40ec
  04FB39  40E9: e98c00           jmp 0x4178
  04FB3C  40EC: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04FB40  40F0: c1e604           shl si, 4
  04FB43  40F3: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04FB46  40F6: 80b8709804       cmp byte ptr [bx + si - 0x6790], 4
  04FB4B  40FB: 7505             jne 0x4102
  04FB4D  40FD: 808e66ff10       or byte ptr [bp - 0x9a], 0x10
  04FB52  4102: 837ebc00         cmp word ptr [bp - 0x44], 0
  04FB56  4106: 7541             jne 0x4149
  04FB58  4108: a18e53           mov ax, word ptr [0x538e]
  04FB5B  410B: c1f804           sar ax, 4
  04FB5E  410E: 8946aa           mov word ptr [bp - 0x56], ax
  04FB61  4111: 833e509600       cmp word ptr [0x9650], 0
  04FB66  4116: 7431             je 0x4149
  04FB68  4118: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04FB6C  411C: c1e304           shl bx, 4
  04FB6F  411F: 035ea2           add bx, word ptr [bp - 0x5e]
  04FB72  4122: 8a8fe694         mov cl, byte ptr [bx - 0x6b1a]
  04FB76  4126: 2aed             sub ch, ch
  04FB78  4128: c1e102           shl cx, 2
  04FB7B  412B: 8a97a694         mov dl, byte ptr [bx - 0x6b5a]
  04FB7F  412F: 2af6             sub dh, dh
  04FB81  4131: 03ca             add cx, dx
  04FB83  4133: 3bc8             cmp cx, ax
  04FB85  4135: 7e12             jle 0x4149
  04FB87  4137: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04FB8B  413B: d1e3             shl bx, 1
  04FB8D  413D: 83bf341714       cmp word ptr [bx + 0x1734], 0x14
  04FB92  4142: 7d05             jge 0x4149
  04FB94  4144: 80a666ffef       and byte ptr [bp - 0x9a], 0xef
  04FB99  4149: 8bb61cff         mov si, word ptr [bp - 0xe4]
  04FB9D  414D: c1e604           shl si, 4
  04FBA0  4150: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04FBA3  4153: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  04FBA8  4158: 7512             jne 0x416c
  04FBAA  415A: f687f29504       test byte ptr [bx - 0x6a0e], 4
  04FBAF  415F: 740b             je 0x416c
  04FBB1  4161: 837e8e07         cmp word ptr [bp - 0x72], 7
  04FBB5  4165: 7d05             jge 0x416c
  04FBB7  4167: 808e66ff10       or byte ptr [bp - 0x9a], 0x10
  04FBBC  416C: f687f29508       test byte ptr [bx - 0x6a0e], 8
  04FBC1  4171: 7405             je 0x4178
  04FBC3  4173: 808e66ff10       or byte ptr [bp - 0x9a], 0x10
  04FBC8  4178: 837eba00         cmp word ptr [bp - 0x46], 0
  04FBCC  417C: 744f             je 0x41cd
  04FBCE  417E: 6a07             push 7
  04FBD0  4180: ffb66eff         push word ptr [bp - 0x92]
  04FBD4  4184: ffb67aff         push word ptr [bp - 0x86]
  04FBD8  4188: ffb61cff         push word ptr [bp - 0xe4]
  04FBDC  418C: 0e               push cs
  04FBDD  418D: e85439           call 0x7ae4
  04FBE0  4190: 83c408           add sp, 8
  04FBE3  4193: 0bc0             or ax, ax
  04FBE5  4195: 7405             je 0x419c
  04FBE7  4197: 808e66ff10       or byte ptr [bp - 0x9a], 0x10
  04FBEC  419C: 6a01             push 1
  04FBEE  419E: ffb66eff         push word ptr [bp - 0x92]
  04FBF2  41A2: ffb67aff         push word ptr [bp - 0x86]
  04FBF6  41A6: ffb61cff         push word ptr [bp - 0xe4]
  04FBFA  41AA: 0e               push cs
  04FBFB  41AB: e83639           call 0x7ae4
  04FBFE  41AE: 83c408           add sp, 8
  04FC01  41B1: 0bc0             or ax, ax
  04FC03  41B3: 7405             je 0x41ba
  04FC05  41B5: 808e66ff10       or byte ptr [bp - 0x9a], 0x10
  04FC0A  41BA: 8a4ea2           mov cl, byte ptr [bp - 0x5e]
  04FC0D  41BD: b80100           mov ax, 1
  04FC10  41C0: d3e0             shl ax, cl
  04FC12  41C2: 85063c17         test word ptr [0x173c], ax
  04FC16  41C6: 7405             je 0x41cd
  04FC18  41C8: 808e66ff10       or byte ptr [bp - 0x9a], 0x10
  04FC1D  41CD: ff46b2           inc word ptr [bp - 0x4e]
  04FC20  41D0: 837eb208         cmp word ptr [bp - 0x4e], 8
  04FC24  41D4: 7c03             jl 0x41d9
  04FC26  41D6: e99b00           jmp 0x4274
  04FC29  41D9: 8b5eb2           mov bx, word ptr [bp - 0x4e]
  04FC2C  41DC: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04FC30  41E0: 98               cwde 
  04FC31  41E1: 03866eff         add ax, word ptr [bp - 0x92]
  04FC35  41E5: 8946e6           mov word ptr [bp - 0x1a], ax
  04FC38  41E8: 50               push ax
  04FC39  41E9: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04FC3D  41ED: 98               cwde 
  04FC3E  41EE: 03867aff         add ax, word ptr [bp - 0x86]
  04FC42  41F2: 8946ea           mov word ptr [bp - 0x16], ax
  04FC45  41F5: 50               push ax
  04FC46  41F6: 9a02031f18       lcall 0x181f, 0x302
  04FC4B  41FB: 83c404           add sp, 4
  04FC4E  41FE: 0bc0             or ax, ax
  04FC50  4200: 74cb             je 0x41cd
  04FC52  4202: ff76e6           push word ptr [bp - 0x1a]
  04FC55  4205: ff76ea           push word ptr [bp - 0x16]
  04FC58  4208: 9a68071f18       lcall 0x181f, 0x768
  04FC5D  420D: 83c404           add sp, 4
  04FC60  4210: 0bc0             or ax, ax
  04FC62  4212: 75b9             jne 0x41cd
  04FC64  4214: ff76e6           push word ptr [bp - 0x1a]
  04FC67  4217: ff76ea           push word ptr [bp - 0x16]
  04FC6A  421A: 9ad2061f18       lcall 0x181f, 0x6d2
  04FC6F  421F: 83c404           add sp, 4
  04FC72  4222: 8946a6           mov word ptr [bp - 0x5a], ax
  04FC75  4225: 0bc0             or ax, ax
  04FC77  4227: 7c06             jl 0x422f
  04FC79  4229: 3b861cff         cmp ax, word ptr [bp - 0xe4]
  04FC7D  422D: 759e             jne 0x41cd
  04FC7F  422F: c78666ff0000     mov word ptr [bp - 0x9a], 0
  04FC85  4235: ff76e6           push word ptr [bp - 0x1a]
  04FC88  4238: ff76ea           push word ptr [bp - 0x16]
  04FC8B  423B: 9a22071f18       lcall 0x181f, 0x722
  04FC90  4240: 83c404           add sp, 4
  04FC93  4243: 8bf0             mov si, ax
  04FC95  4245: 8976a2           mov word ptr [bp - 0x5e], si
  04FC98  4248: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04FC9C  424C: c1e304           shl bx, 4
  04FC9F  424F: 80b8709800       cmp byte ptr [bx + si - 0x6790], 0
  04FCA4  4254: 7503             jne 0x4259
  04FCA6  4256: e974ff           jmp 0x41cd
  04FCA9  4259: 837ee602         cmp word ptr [bp - 0x1a], 2
  04FCAD  425D: 7d03             jge 0x4262
  04FCAF  425F: e96bff           jmp 0x41cd
  04FCB2  4262: a13c85           mov ax, word ptr [0x853c]
  04FCB5  4265: 2d0300           sub ax, 3
  04FCB8  4268: 3b46e6           cmp ax, word ptr [bp - 0x1a]
  04FCBB  426B: 7c03             jl 0x4270
  04FCBD  426D: e9d8fc           jmp 0x3f48
  04FCC0  4270: e95aff           jmp 0x41cd
  04FCC3  4273: 90               nop 
  04FCC4  4274: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04FCC9  4279: 7415             je 0x4290
  04FCCB  427B: 6a00             push 0
  04FCCD  427D: ff364017         push word ptr [0x1740]
  04FCD1  4281: ffb666ff         push word ptr [bp - 0x9a]
  04FCD5  4285: 686a17           push 0x176a
  04FCD8  4288: 9a7e071f18       lcall 0x181f, 0x77e
  04FCDD  428D: 83c408           add sp, 8
  04FCE0  4290: 833e401700       cmp word ptr [0x1740], 0
  04FCE5  4295: 7406             je 0x429d
  04FCE7  4297: c78666ff0000     mov word ptr [bp - 0x9a], 0
  04FCED  429D: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  04FCF2  42A2: 7503             jne 0x42a7
  04FCF4  42A4: e94001           jmp 0x43e7
  04FCF7  42A7: 83be16ff00       cmp word ptr [bp - 0xea], 0
  04FCFC  42AC: 7506             jne 0x42b4
  04FCFE  42AE: 837e9c00         cmp word ptr [bp - 0x64], 0
  04FD02  42B2: 7405             je 0x42b9
  04FD04  42B4: c746fc0000       mov word ptr [bp - 4], 0
  04FD09  42B9: 8b4606           mov ax, word ptr [bp + 6]
  04FD0C  42BC: 89865cff         mov word ptr [bp - 0xa4], ax
  04FD10  42C0: c7468a0000       mov word ptr [bp - 0x76], 0
  04FD15  42C5: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04FD1A  42CA: 7411             je 0x42dd
  04FD1C  42CC: 6a00             push 0
  04FD1E  42CE: 6a00             push 0
  04FD20  42D0: 6a00             push 0
  04FD22  42D2: 686c17           push 0x176c
  04FD25  42D5: 9a7e071f18       lcall 0x181f, 0x77e
  04FD2A  42DA: 83c408           add sp, 8
  04FD2D  42DD: c746dc0000       mov word ptr [bp - 0x24], 0
  04FD32  42E2: c7468cffff       mov word ptr [bp - 0x74], 0xffff
  04FD37  42E7: 8b865cff         mov ax, word ptr [bp - 0xa4]
  04FD3B  42EB: 9aee021f18       lcall 0x181f, 0x2ee
  04FD40  42F0: e99200           jmp 0x4385
  04FD43  42F3: 90               nop 
  04FD44  42F4: 2bc0             sub ax, ax
  04FD46  42F6: 50               push ax
  04FD47  42F7: 8a8666ff         mov al, byte ptr [bp - 0x9a]
  04FD4B  42FB: 254000           and ax, 0x40
  04FD4E  42FE: 50               push ax
  04FD4F  42FF: ffb66eff         push word ptr [bp - 0x92]
  04FD53  4303: ffb67aff         push word ptr [bp - 0x86]
  04FD57  4307: ffb61cff         push word ptr [bp - 0xe4]
  04FD5B  430B: 0e               push cs
  04FD5C  430C: e87b37           call 0x7a8a
  04FD5F  430F: 83c40a           add sp, 0xa
  04FD62  4312: 89468c           mov word ptr [bp - 0x74], ax
  04FD65  4315: 8b9e14ff         mov bx, word ptr [bp - 0xec]
  04FD69  4319: 8a1f             mov bl, byte ptr [bx]
  04FD6B  431B: 2aff             sub bh, bh
  04FD6D  431D: 8bc3             mov ax, bx
  04FD6F  431F: d1e3             shl bx, 1
  04FD71  4321: 03d8             add bx, ax
  04FD73  4323: d1e3             shl bx, 1
  04FD75  4325: 03d8             add bx, ax
  04FD77  4327: d1e3             shl bx, 1
  04FD79  4329: 8a8666ff         mov al, byte ptr [bp - 0x9a]
  04FD7D  432D: 84873d52         test byte ptr [bx + 0x523d], al
  04FD81  4331: 744a             je 0x437d
  04FD83  4333: 837e8c08         cmp word ptr [bp - 0x74], 8
  04FD87  4337: 7444             je 0x437d
  04FD89  4339: c7468a0100       mov word ptr [bp - 0x76], 1
  04FD8E  433E: 8b9e12ff         mov bx, word ptr [bp - 0xee]
  04FD92  4342: c687493100       mov byte ptr [bx + 0x3149], 0
  04FD97  4347: ff768c           push word ptr [bp - 0x74]
  04FD9A  434A: ff7606           push word ptr [bp + 6]
  04FD9D  434D: 9a50011f1a       lcall 0x1a1f, 0x150
  04FDA2  4352: 83c404           add sp, 4
  04FDA5  4355: ff7606           push word ptr [bp + 6]
  04FDA8  4358: 9a34091f18       lcall 0x181f, 0x934
  04FDAD  435D: 83c402           add sp, 2
  04FDB0  4360: 8a867aff         mov al, byte ptr [bp - 0x86]
  04FDB4  4364: 8b9e12ff         mov bx, word ptr [bp - 0xee]
  04FDB8  4368: 38874431         cmp byte ptr [bx + 0x3144], al
  04FDBC  436C: 750a             jne 0x4378
  04FDBE  436E: 8a866eff         mov al, byte ptr [bp - 0x92]
  04FDC2  4372: 38874531         cmp byte ptr [bx + 0x3145], al
  04FDC6  4376: 7405             je 0x437d
  04FDC8  4378: c746dc0100       mov word ptr [bp - 0x24], 1
  04FDCD  437D: 8b4606           mov ax, word ptr [bp + 6]
  04FDD0  4380: 9ae4021f18       lcall 0x181f, 0x2e4
  04FDD5  4385: 894606           mov word ptr [bp + 6], ax
  04FDD8  4388: 837e8c08         cmp word ptr [bp - 0x74], 8
  04FDDC  438C: 743a             je 0x43c8
  04FDDE  438E: 837edc00         cmp word ptr [bp - 0x24], 0
  04FDE2  4392: 7534             jne 0x43c8
  04FDE4  4394: 0bc0             or ax, ax
  04FDE6  4396: 7c30             jl 0x43c8
  04FDE8  4398: 6bd81c           imul bx, ax, 0x1c
  04FDEB  439B: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04FDF0  43A0: 7207             jb 0x43a9
  04FDF2  43A2: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04FDF7  43A7: 76d4             jbe 0x437d
  04FDF9  43A9: 6bd81c           imul bx, ax, 0x1c
  04FDFC  43AC: 8d874631         lea ax, [bx + 0x3146]
  04FE00  43B0: 898614ff         mov word ptr [bp - 0xec], ax
  04FE04  43B4: 899e12ff         mov word ptr [bp - 0xee], bx
  04FE08  43B8: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  04FE0D  43BD: 7403             je 0x43c2
  04FE0F  43BF: e932ff           jmp 0x42f4
  04FE12  43C2: b80100           mov ax, 1
  04FE15  43C5: e92eff           jmp 0x42f6
  04FE18  43C8: 837edc00         cmp word ptr [bp - 0x24], 0
  04FE1C  43CC: 7403             je 0x43d1
  04FE1E  43CE: e9f4fe           jmp 0x42c5
  04FE21  43D1: 8b865cff         mov ax, word ptr [bp - 0xa4]
  04FE25  43D5: 894606           mov word ptr [bp + 6], ax
  04FE28  43D8: 837e8a00         cmp word ptr [bp - 0x76], 0
  04FE2C  43DC: 7409             je 0x43e7
  04FE2E  43DE: 50               push ax
  04FE2F  43DF: 9a34091f18       lcall 0x181f, 0x934
  04FE34  43E4: 83c402           add sp, 2
  04FE37  43E7: 83be54ff00       cmp word ptr [bp - 0xac], 0
  04FE3C  43EC: 7411             je 0x43ff
  04FE3E  43EE: 6a00             push 0
  04FE40  43F0: 6a00             push 0
  04FE42  43F2: 6a00             push 0
  04FE44  43F4: 686e17           push 0x176e
  04FE47  43F7: 9a7e071f18       lcall 0x181f, 0x77e
  04FE4C  43FC: 83c408           add sp, 8
  04FE4F  43FF: 837efc00         cmp word ptr [bp - 4], 0
  04FE53  4403: 7403             je 0x4408
  04FE55  4405: e9e802           jmp 0x46f0
  04FE58  4408: 837e8000         cmp word ptr [bp - 0x80], 0
  04FE5C  440C: 7523             jne 0x4431
  04FE5E  440E: 8b865aff         mov ax, word ptr [bp - 0xa6]
  04FE62  4412: 3946b8           cmp word ptr [bp - 0x48], ax
  04FE65  4415: 7510             jne 0x4427
  04FE67  4417: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04FE6B  441B: d1e3             shl bx, 1
  04FE6D  441D: 83bf341719       cmp word ptr [bx + 0x1734], 0x19
  04FE72  4422: 7d03             jge 0x4427
  04FE74  4424: e9c902           jmp 0x46f0
  04FE77  4427: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  04FE7C  442C: 7403             je 0x4431
  04FE7E  442E: e9bf02           jmp 0x46f0
  04FE81  4431: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04FE85  4435: 8a874431         mov al, byte ptr [bx + 0x3144]
  04FE89  4439: 2ae4             sub ah, ah
  04FE8B  443B: 8946b4           mov word ptr [bp - 0x4c], ax
  04FE8E  443E: 8a874531         mov al, byte ptr [bx + 0x3145]
  04FE92  4442: 8946a4           mov word ptr [bp - 0x5c], ax
  04FE95  4445: c78620fff1d8     mov word ptr [bp - 0xe0], 0xd8f1
  04FE9B  444B: c78676ff0000     mov word ptr [bp - 0x8a], 0
  04FEA1  4451: e96f01           jmp 0x45c3
  04FEA4  4454: 833e509601       cmp word ptr [0x9650], 1
  04FEA9  4459: 7e15             jle 0x4470
  04FEAB  445B: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  04FEAF  445F: d1e3             shl bx, 1
  04FEB1  4461: 83bf341714       cmp word ptr [bx + 0x1734], 0x14
  04FEB6  4466: 7d08             jge 0x4470
  04FEB8  4468: 836eda2d         sub word ptr [bp - 0x26], 0x2d
  04FEBC  446C: e98300           jmp 0x44f2
  04FEBF  446F: 90               nop 
  04FEC0  4470: 8b1e4285         mov bx, word ptr [0x8542]
  04FEC4  4474: f6471b08         test byte ptr [bx + 0x1b], 8
  04FEC8  4478: 7406             je 0x4480
  04FECA  447A: 8346da2d         add word ptr [bp - 0x26], 0x2d
  04FECE  447E: eb72             jmp 0x44f2
  04FED0  4480: 836eda0f         sub word ptr [bp - 0x26], 0xf
  04FED4  4484: eb6c             jmp 0x44f2
  04FED6  4486: 6a08             push 8
  04FED8  4488: 6a00             push 0
  04FEDA  448A: 9ad4041f18       lcall 0x181f, 0x4d4
  04FEDF  448F: 83c404           add sp, 4
  04FEE2  4492: 8b1e4285         mov bx, word ptr [0x8542]
  04FEE6  4496: 8bc8             mov cx, ax
  04FEE8  4498: 8a471f           mov al, byte ptr [bx + 0x1f]
  04FEEB  449B: 3c10             cmp al, 0x10
  04FEED  449D: 7e02             jle 0x44a1
  04FEEF  449F: b010             mov al, 0x10
  04FEF1  44A1: 98               cwde 
  04FEF2  44A2: bb1100           mov bx, 0x11
  04FEF5  44A5: 2bd8             sub bx, ax
  04FEF7  44A7: 8bc3             mov ax, bx
  04FEF9  44A9: f7eb             imul bx
  04FEFB  44AB: 40               inc ax
  04FEFC  44AC: 40               inc ax
  04FEFD  44AD: c1e002           shl ax, 2
  04FF00  44B0: 03c8             add cx, ax
  04FF02  44B2: 894eda           mov word ptr [bp - 0x26], cx
  04FF05  44B5: 8b1e4285         mov bx, word ptr [0x8542]
  04FF09  44B9: 8a471f           mov al, byte ptr [bx + 0x1f]
  04FF0C  44BC: 98               cwde 
  04FF0D  44BD: 2b865eff         sub ax, word ptr [bp - 0xa2]
  04FF11  44C1: f7d8             neg ax
  04FF13  44C3: d1e0             shl ax, 1
  04FF15  44C5: 0146da           add word ptr [bp - 0x26], ax
  04FF18  44C8: 8b369853         mov si, word ptr [0x5398]
  04FF1C  44CC: c1e604           shl si, 4
  04FF1F  44CF: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  04FF22  44D2: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  04FF27  44D7: 7404             je 0x44dd
  04FF29  44D9: 8346da14         add word ptr [bp - 0x26], 0x14
  04FF2D  44DD: 8b1e4285         mov bx, word ptr [0x8542]
  04FF31  44E1: 8a471b           mov al, byte ptr [bx + 0x1b]
  04FF34  44E4: 2410             and al, 0x10
  04FF36  44E6: 3c01             cmp al, 1
  04FF38  44E8: 1bc0             sbb ax, ax
  04FF3A  44EA: 24ce             and al, 0xce
  04FF3C  44EC: 051900           add ax, 0x19
  04FF3F  44EF: 0146da           add word ptr [bp - 0x26], ax
  04FF42  44F2: 8b1e4285         mov bx, word ptr [0x8542]
  04FF46  44F6: 8a878f00         mov al, byte ptr [bx + 0x8f]
  04FF4A  44FA: 98               cwde 
  04FF4B  44FB: 0146da           add word ptr [bp - 0x26], ax
  04FF4E  44FE: f6471b02         test byte ptr [bx + 0x1b], 2
  04FF52  4502: 7412             je 0x4516
  04FF54  4504: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04FF58  4508: 80bf463111       cmp byte ptr [bx + 0x3146], 0x11
  04FF5D  450D: 7438             je 0x4547
  04FF5F  450F: 836eda32         sub word ptr [bp - 0x26], 0x32
  04FF63  4513: eb32             jmp 0x4547
  04FF65  4515: 90               nop 
  04FF66  4516: f6471b01         test byte ptr [bx + 0x1b], 1
  04FF6A  451A: 742b             je 0x4547
  04FF6C  451C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04FF70  4520: 80bf463111       cmp byte ptr [bx + 0x3146], 0x11
  04FF75  4525: 7320             jae 0x4547
  04FF77  4527: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04FF7B  452B: 2aff             sub bh, bh
  04FF7D  452D: 8bc3             mov ax, bx
  04FF7F  452F: d1e3             shl bx, 1
  04FF81  4531: 03d8             add bx, ax
  04FF83  4533: d1e3             shl bx, 1
  04FF85  4535: 03d8             add bx, ax
  04FF87  4537: d1e3             shl bx, 1
  04FF89  4539: 8a873552         mov al, byte ptr [bx + 0x5235]
  04FF8D  453D: 2ae4             sub ah, ah
  04FF8F  453F: 2d0a00           sub ax, 0xa
  04FF92  4542: d1e0             shl ax, 1
  04FF94  4544: 0146da           add word ptr [bp - 0x26], ax
  04FF97  4547: 691ec68dca00     imul bx, word ptr [0x8dc6], 0xca
  04FF9D  454D: f687625d40       test byte ptr [bx + 0x5d62], 0x40
  04FFA2  4552: 751b             jne 0x456f
  04FFA4  4554: 6afe             push -2
  04FFA6  4556: ffb61cff         push word ptr [bp - 0xe4]
  04FFAA  455A: 8b1e4285         mov bx, word ptr [0x8542]
  04FFAE  455E: 8a4701           mov al, byte ptr [bx + 1]
  04FFB1  4561: 2ae4             sub ah, ah
  04FFB3  4563: 50               push ax
  04FFB4  4564: 8a07             mov al, byte ptr [bx]
  04FFB6  4566: 50               push ax
  04FFB7  4567: 9a14061f18       lcall 0x181f, 0x614
  04FFBC  456C: 83c408           add sp, 8
  04FFBF  456F: 833ec68d00       cmp word ptr [0x8dc6], 0
  04FFC4  4574: 7c49             jl 0x45bf
  04FFC6  4576: 8b1e4285         mov bx, word ptr [0x8542]
  04FFCA  457A: 8a4701           mov al, byte ptr [bx + 1]
  04FFCD  457D: 2ae4             sub ah, ah
  04FFCF  457F: 8946e6           mov word ptr [bp - 0x1a], ax
  04FFD2  4582: 50               push ax
  04FFD3  4583: 8a07             mov al, byte ptr [bx]
  04FFD5  4585: 8946ea           mov word ptr [bp - 0x16], ax
  04FFD8  4588: 50               push ax
  04FFD9  4589: ffb66eff         push word ptr [bp - 0x92]
  04FFDD  458D: ffb67aff         push word ptr [bp - 0x86]
  04FFE1  4591: 9a7a031f18       lcall 0x181f, 0x37a
  04FFE6  4596: 83c408           add sp, 8
  04FFE9  4599: f7ae50ff         imul word ptr [bp - 0xb0]
  04FFED  459D: d1f8             sar ax, 1
  04FFEF  459F: 40               inc ax
  04FFF0  45A0: 2946da           sub word ptr [bp - 0x26], ax
  04FFF3  45A3: 8b8620ff         mov ax, word ptr [bp - 0xe0]
  04FFF7  45A7: 3946da           cmp word ptr [bp - 0x26], ax
  04FFFA  45AA: 7c13             jl 0x45bf
  04FFFC  45AC: 8b46da           mov ax, word ptr [bp - 0x26]
  04FFFF  45AF: 898620ff         mov word ptr [bp - 0xe0], ax
  050003  45B3: 8b46ea           mov ax, word ptr [bp - 0x16]
  050006  45B6: 8946b4           mov word ptr [bp - 0x4c], ax
  050009  45B9: 8b46e6           mov ax, word ptr [bp - 0x1a]
  05000C  45BC: 8946a4           mov word ptr [bp - 0x5c], ax
  05000F  45BF: ff8676ff         inc word ptr [bp - 0x8a]
  050013  45C3: a19e53           mov ax, word ptr [0x539e]
  050016  45C6: 398676ff         cmp word ptr [bp - 0x8a], ax
  05001A  45CA: 7c03             jl 0x45cf
  05001C  45CC: e90501           jmp 0x46d4
  05001F  45CF: ffb676ff         push word ptr [bp - 0x8a]
  050023  45D3: 9ae6091f18       lcall 0x181f, 0x9e6
  050028  45D8: 83c402           add sp, 2
  05002B  45DB: 8a861cff         mov al, byte ptr [bp - 0xe4]
  05002F  45DF: 8b1e4285         mov bx, word ptr [0x8542]
  050033  45E3: 38471a           cmp byte ptr [bx + 0x1a], al
  050036  45E6: 75d7             jne 0x45bf
  050038  45E8: 8a07             mov al, byte ptr [bx]
  05003A  45EA: 6b76061c         imul si, word ptr [bp + 6], 0x1c
  05003E  45EE: 38844431         cmp byte ptr [si + 0x3144], al
  050042  45F2: 7509             jne 0x45fd
  050044  45F4: 8a4701           mov al, byte ptr [bx + 1]
  050047  45F7: 38844531         cmp byte ptr [si + 0x3145], al
  05004B  45FB: 74c2             je 0x45bf
  05004D  45FD: 8a4701           mov al, byte ptr [bx + 1]
  050050  4600: 2ae4             sub ah, ah
  050052  4602: 50               push ax
  050053  4603: 8a07             mov al, byte ptr [bx]
  050055  4605: 50               push ax
  050056  4606: 9a22071f18       lcall 0x181f, 0x722
  05005B  460B: 83c404           add sp, 4
  05005E  460E: 8946a2           mov word ptr [bp - 0x5e], ax
  050061  4611: 83be4eff00       cmp word ptr [bp - 0xb2], 0
  050066  4616: 7410             je 0x4628
  050068  4618: 8bb61cff         mov si, word ptr [bp - 0xe4]
  05006C  461C: c1e604           shl si, 4
  05006F  461F: 8bd8             mov bx, ax
  050071  4621: 80b8709800       cmp byte ptr [bx + si - 0x6790], 0
  050076  4626: 7497             je 0x45bf
  050078  4628: 9a7c0c1f18       lcall 0x181f, 0xc7c
  05007D  462D: 89865eff         mov word ptr [bp - 0xa2], ax
  050081  4631: 3d0c00           cmp ax, 0xc
  050084  4634: 7e06             jle 0x463c
  050086  4636: c7865eff1000     mov word ptr [bp - 0xa2], 0x10
  05008C  463C: c78650ff0100     mov word ptr [bp - 0xb0], 1
  050092  4642: 837eba00         cmp word ptr [bp - 0x46], 0
  050096  4646: 7503             jne 0x464b
  050098  4648: e93bfe           jmp 0x4486
  05009B  464B: c746da0000       mov word ptr [bp - 0x26], 0
  0500A0  4650: 8bb61cff         mov si, word ptr [bp - 0xe4]
  0500A4  4654: c1e604           shl si, 4
  0500A7  4657: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  0500AA  465A: 80b8709800       cmp byte ptr [bx + si - 0x6790], 0
  0500AF  465F: 7503             jne 0x4664
  0500B1  4661: e95bff           jmp 0x45bf
  0500B4  4664: 8b1e4285         mov bx, word ptr [0x8542]
  0500B8  4668: 8a4701           mov al, byte ptr [bx + 1]
  0500BB  466B: 2ae4             sub ah, ah
  0500BD  466D: 50               push ax
  0500BE  466E: 8a07             mov al, byte ptr [bx]
  0500C0  4670: 50               push ax
  0500C1  4671: 9a22071f18       lcall 0x181f, 0x722
  0500C6  4676: 83c404           add sp, 4
  0500C9  4679: 8bd8             mov bx, ax
  0500CB  467B: 8a87f295         mov al, byte ptr [bx - 0x6a0e]
  0500CF  467F: 250700           and ax, 7
  0500D2  4682: 8946aa           mov word ptr [bp - 0x56], ax
  0500D5  4685: c166aa03         shl word ptr [bp - 0x56], 3
  0500D9  4689: 8b46aa           mov ax, word ptr [bp - 0x56]
  0500DC  468C: 0146da           add word ptr [bp - 0x26], ax
  0500DF  468F: 803e9ca800       cmp byte ptr [0xa89c], 0
  0500E4  4694: 7414             je 0x46aa
  0500E6  4696: 837eba01         cmp word ptr [bp - 0x46], 1
  0500EA  469A: 7e0e             jle 0x46aa
  0500EC  469C: a09ca8           mov al, byte ptr [0xa89c]
  0500EF  469F: 2ae4             sub ah, ah
  0500F1  46A1: f76eba           imul word ptr [bp - 0x46]
  0500F4  46A4: c1e003           shl ax, 3
  0500F7  46A7: 2946da           sub word ptr [bp - 0x26], ax
  0500FA  46AA: 8b369853         mov si, word ptr [0x5398]
  0500FE  46AE: c1e604           shl si, 4
  050101  46B1: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  050104  46B4: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  050109  46B9: 7404             je 0x46bf
  05010B  46BB: 8346da32         add word ptr [bp - 0x26], 0x32
  05010F  46BF: 8b1e4285         mov bx, word ptr [0x8542]
  050113  46C3: f6471b40         test byte ptr [bx + 0x1b], 0x40
  050117  46C7: 7503             jne 0x46cc
  050119  46C9: e988fd           jmp 0x4454
  05011C  46CC: 8346da3c         add word ptr [bp - 0x26], 0x3c
  050120  46D0: e91ffe           jmp 0x44f2
  050123  46D3: 90               nop 
  050124  46D4: 837eba01         cmp word ptr [bp - 0x46], 1
  050128  46D8: 1bc0             sbb ax, ax
  05012A  46DA: 2519fc           and ax, 0xfc19
  05012D  46DD: 3b8620ff         cmp ax, word ptr [bp - 0xe0]
  050131  46E1: 7d0d             jge 0x46f0
  050133  46E3: ff76a4           push word ptr [bp - 0x5c]
  050136  46E6: 8b4606           mov ax, word ptr [bp + 6]
  050139  46E9: ba3400           mov dx, 0x34
  05013C  46EC: e9f4ee           jmp 0x35e3
  05013F  46EF: 90               nop 
  050140  46F0: 83be54ff00       cmp word ptr [bp - 0xac], 0
  050145  46F5: 7411             je 0x4708
  050147  46F7: 6a00             push 0
  050149  46F9: 6a00             push 0
  05014B  46FB: 6a00             push 0
  05014D  46FD: 687017           push 0x1770
  050150  4700: 9a7e071f18       lcall 0x181f, 0x77e
  050155  4705: 83c408           add sp, 8
  050158  4708: f606825301       test byte ptr [0x5382], 1
  05015D  470D: 7443             je 0x4752
  05015F  470F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050163  4713: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  050168  4718: 7538             jne 0x4752
  05016A  471A: 837efc00         cmp word ptr [bp - 4], 0
  05016E  471E: 7532             jne 0x4752
  050170  4720: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  050175  4725: 752b             jne 0x4752
  050177  4727: 833ede5300       cmp word ptr [0x53de], 0
  05017C  472C: 7524             jne 0x4752
  05017E  472E: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  050182  4732: 80bf569400       cmp byte ptr [bx - 0x6baa], 0
  050187  4737: 7519             jne 0x4752
  050189  4739: a1da53           mov ax, word ptr [0x53da]
  05018C  473C: 0306dc53         add ax, word ptr [0x53dc]
  050190  4740: 0306e053         add ax, word ptr [0x53e0]
  050194  4744: 740c             je 0x4752
  050196  4746: ff7606           push word ptr [bp + 6]
  050199  4749: 9aea021f19       lcall 0x191f, 0x2ea
  05019E  474E: e984f0           jmp 0x37d5
  0501A1  4751: 90               nop 
  0501A2  4752: 83be54ff00       cmp word ptr [bp - 0xac], 0
  0501A7  4757: 7411             je 0x476a
  0501A9  4759: 6a00             push 0
  0501AB  475B: 6a00             push 0
  0501AD  475D: 6a00             push 0
  0501AF  475F: 687217           push 0x1772
  0501B2  4762: 9a7e071f18       lcall 0x181f, 0x77e
  0501B7  4767: 83c408           add sp, 8
  0501BA  476A: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  0501BF  476F: 7521             jne 0x4792
  0501C1  4771: 837ebe00         cmp word ptr [bp - 0x42], 0
  0501C5  4775: 7d1b             jge 0x4792
  0501C7  4777: 83be26ff00       cmp word ptr [bp - 0xda], 0
  0501CC  477C: 7414             je 0x4792
  0501CE  477E: 837efc00         cmp word ptr [bp - 4], 0
  0501D2  4782: 750e             jne 0x4792
  0501D4  4784: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  0501D8  4788: 8a875694         mov al, byte ptr [bx - 0x6baa]
  0501DC  478C: 38875a94         cmp byte ptr [bx - 0x6ba6], al
  0501E0  4790: 77b4             ja 0x4746
  0501E2  4792: 83be54ff00       cmp word ptr [bp - 0xac], 0
  0501E7  4797: 7411             je 0x47aa
  0501E9  4799: 6a00             push 0
  0501EB  479B: 6a00             push 0
  0501ED  479D: 6a00             push 0
  0501EF  479F: 687417           push 0x1774
  0501F2  47A2: 9a7e071f18       lcall 0x181f, 0x77e
  0501F7  47A7: 83c408           add sp, 8
  0501FA  47AA: 83be4cff00       cmp word ptr [bp - 0xb4], 0
  0501FF  47AF: 7503             jne 0x47b4
  050201  47B1: e96703           jmp 0x4b1b
  050204  47B4: 837efc00         cmp word ptr [bp - 4], 0
  050208  47B8: 7403             je 0x47bd
  05020A  47BA: e95e03           jmp 0x4b1b
  05020D  47BD: 837ebe00         cmp word ptr [bp - 0x42], 0
  050211  47C1: 7d03             jge 0x47c6
  050213  47C3: e92b03           jmp 0x4af1
  050216  47C6: b8ffff           mov ax, 0xffff
  050219  47C9: 8946de           mov word ptr [bp - 0x22], ax
  05021C  47CC: 898620ff         mov word ptr [bp - 0xe0], ax
  050220  47D0: c746b20000       mov word ptr [bp - 0x4e], 0
  050225  47D5: e9ec01           jmp 0x49c4
  050228  47D8: 8bb64cff         mov si, word ptr [bp - 0xb4]
  05022C  47DC: 8a823aff         mov al, byte ptr [bp + si - 0xc6]
  050230  47E0: 98               cwde 
  050231  47E1: d1e6             shl si, 1
  050233  47E3: 8bc8             mov cx, ax
  050235  47E5: 03809a00         add ax, word ptr [bx + si + 0x9a]
  050239  47E9: 3b46e0           cmp ax, word ptr [bp - 0x20]
  05023C  47EC: 7c22             jl 0x4810
  05023E  47EE: 8b46e0           mov ax, word ptr [bp - 0x20]
  050241  47F1: 2b809a00         sub ax, word ptr [bx + si + 0x9a]
  050245  47F5: 2bc1             sub ax, cx
  050247  47F7: 8bb61cff         mov si, word ptr [bp - 0xe4]
  05024B  47FB: c1e604           shl si, 4
  05024E  47FE: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  050252  4802: 8a88bc84         mov cl, byte ptr [bx + si - 0x7b44]
  050256  4806: 2aed             sub ch, ch
  050258  4808: f7e9             imul cx
  05025A  480A: c1e002           shl ax, 2
  05025D  480D: 0146da           add word ptr [bp - 0x26], ax
  050260  4810: 8a864cff         mov al, byte ptr [bp - 0xb4]
  050264  4814: 8b1e4285         mov bx, word ptr [0x8542]
  050268  4818: 38878d00         cmp byte ptr [bx + 0x8d], al
  05026C  481C: 750e             jne 0x482c
  05026E  481E: 8a878f00         mov al, byte ptr [bx + 0x8f]
  050272  4822: 98               cwde 
  050273  4823: 050800           add ax, 8
  050276  4826: c1e002           shl ax, 2
  050279  4829: 0146da           add word ptr [bp - 0x26], ax
  05027C  482C: 8b46e0           mov ax, word ptr [bp - 0x20]
  05027F  482F: 8bb64cff         mov si, word ptr [bp - 0xb4]
  050283  4833: d1e6             shl si, 1
  050285  4835: 2b809a00         sub ax, word ptr [bx + si + 0x9a]
  050289  4839: 48               dec ax
  05028A  483A: 0146da           add word ptr [bp - 0x26], ax
  05028D  483D: ff864cff         inc word ptr [bp - 0xb4]
  050291  4841: 83be4cff10       cmp word ptr [bp - 0xb4], 0x10
  050296  4846: 7d32             jge 0x487a
  050298  4848: 8bb64cff         mov si, word ptr [bp - 0xb4]
  05029C  484C: 80ba3aff00       cmp byte ptr [bp + si - 0xc6], 0
  0502A1  4851: 74ea             je 0x483d
  0502A3  4853: 8b1e4285         mov bx, word ptr [0x8542]
  0502A7  4857: 8a8e4cff         mov cl, byte ptr [bp - 0xb4]
  0502AB  485B: b80100           mov ax, 1
  0502AE  485E: d3e0             shl ax, cl
  0502B0  4860: 85879000         test word ptr [bx + 0x90], ax
  0502B4  4864: 7503             jne 0x4869
  0502B6  4866: e96fff           jmp 0x47d8
  0502B9  4869: d1e6             shl si, 1
  0502BB  486B: 83b89a0064       cmp word ptr [bx + si + 0x9a], 0x64
  0502C0  4870: 7d03             jge 0x4875
  0502C2  4872: e963ff           jmp 0x47d8
  0502C5  4875: c746f80000       mov word ptr [bp - 8], 0
  0502CA  487A: 837ef800         cmp word ptr [bp - 8], 0
  0502CE  487E: 7503             jne 0x4883
  0502D0  4880: e93e01           jmp 0x49c1
  0502D3  4883: 837ebe0f         cmp word ptr [bp - 0x42], 0xf
  0502D7  4887: 7403             je 0x488c
  0502D9  4889: e99200           jmp 0x491e
  0502DC  488C: 8b369853         mov si, word ptr [0x5398]
  0502E0  4890: c1e604           shl si, 4
  0502E3  4893: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  0502E6  4896: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  0502EB  489B: 7404             je 0x48a1
  0502ED  489D: 8346da10         add word ptr [bp - 0x26], 0x10
  0502F1  48A1: c746920000       mov word ptr [bp - 0x6e], 0
  0502F6  48A6: eb09             jmp 0x48b1
  0502F8  48A8: 90               nop 
  0502F9  48A9: 90               nop 
  0502FA  48AA: 8346da18         add word ptr [bp - 0x26], 0x18
  0502FE  48AE: ff4692           inc word ptr [bp - 0x6e]
  050301  48B1: 837e9214         cmp word ptr [bp - 0x6e], 0x14
  050305  48B5: 7d67             jge 0x491e
  050307  48B7: 8b5e92           mov bx, word ptr [bp - 0x6e]
  05030A  48BA: 8a87de00         mov al, byte ptr [bx + 0xde]
  05030E  48BE: 98               cwde 
  05030F  48BF: 8b364285         mov si, word ptr [0x8542]
  050313  48C3: 8a4c01           mov cl, byte ptr [si + 1]
  050316  48C6: 2aed             sub ch, ch
  050318  48C8: 03c1             add ax, cx
  05031A  48CA: 8946e4           mov word ptr [bp - 0x1c], ax
  05031D  48CD: 50               push ax
  05031E  48CE: 8a87c800         mov al, byte ptr [bx + 0xc8]
  050322  48D2: 98               cwde 
  050323  48D3: 8a0c             mov cl, byte ptr [si]
  050325  48D5: 03c1             add ax, cx
  050327  48D7: 8946f4           mov word ptr [bp - 0xc], ax
  05032A  48DA: 50               push ax
  05032B  48DB: 9a02031f18       lcall 0x181f, 0x302
  050330  48E0: 83c404           add sp, 4
  050333  48E3: 0bc0             or ax, ax
  050335  48E5: 74c7             je 0x48ae
  050337  48E7: ff76e4           push word ptr [bp - 0x1c]
  05033A  48EA: ff76f4           push word ptr [bp - 0xc]
  05033D  48ED: 9ad2061f18       lcall 0x181f, 0x6d2
  050342  48F2: 83c404           add sp, 4
  050345  48F5: 8946f2           mov word ptr [bp - 0xe], ax
  050348  48F8: 3d0400           cmp ax, 4
  05034B  48FB: 7cad             jl 0x48aa
  05034D  48FD: ffb61cff         push word ptr [bp - 0xe4]
  050351  4901: 2d0400           sub ax, 4
  050354  4904: 50               push ax
  050355  4905: 9a0c031f18       lcall 0x181f, 0x30c
  05035A  490A: 83c404           add sp, 4
  05035D  490D: 50               push ax
  05035E  490E: 9a600a1f18       lcall 0x181f, 0xa60
  050363  4913: 83c402           add sp, 2
  050366  4916: c1e004           shl ax, 4
  050369  4919: 0146da           add word ptr [bp - 0x26], ax
  05036C  491C: eb90             jmp 0x48ae
  05036E  491E: 8b1e4285         mov bx, word ptr [0x8542]
  050372  4922: f6471b02         test byte ptr [bx + 0x1b], 2
  050376  4926: 742c             je 0x4954
  050378  4928: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05037C  492C: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  050381  4931: 7352             jae 0x4985
  050383  4933: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  050387  4937: 2aff             sub bh, bh
  050389  4939: 8bc3             mov ax, bx
  05038B  493B: d1e3             shl bx, 1
  05038D  493D: 03d8             add bx, ax
  05038F  493F: d1e3             shl bx, 1
  050391  4941: 03d8             add bx, ax
  050393  4943: d1e3             shl bx, 1
  050395  4945: 8a873552         mov al, byte ptr [bx + 0x5235]
  050399  4949: 2ae4             sub ah, ah
  05039B  494B: 2d0a00           sub ax, 0xa
  05039E  494E: c1e003           shl ax, 3
  0503A1  4951: eb2f             jmp 0x4982
  0503A3  4953: 90               nop 
  0503A4  4954: f6471b01         test byte ptr [bx + 0x1b], 1
  0503A8  4958: 742b             je 0x4985
  0503AA  495A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0503AE  495E: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  0503B3  4963: 7320             jae 0x4985
  0503B5  4965: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0503B9  4969: 2aff             sub bh, bh
  0503BB  496B: 8bc3             mov ax, bx
  0503BD  496D: d1e3             shl bx, 1
  0503BF  496F: 03d8             add bx, ax
  0503C1  4971: d1e3             shl bx, 1
  0503C3  4973: 03d8             add bx, ax
  0503C5  4975: d1e3             shl bx, 1
  0503C7  4977: 8a873552         mov al, byte ptr [bx + 0x5235]
  0503CB  497B: 2ae4             sub ah, ah
  0503CD  497D: 2d0a00           sub ax, 0xa
  0503D0  4980: d1e0             shl ax, 1
  0503D2  4982: 0146da           add word ptr [bp - 0x26], ax
  0503D5  4985: 8b1e4285         mov bx, word ptr [0x8542]
  0503D9  4989: 8a4701           mov al, byte ptr [bx + 1]
  0503DC  498C: 2ae4             sub ah, ah
  0503DE  498E: 50               push ax
  0503DF  498F: 8a07             mov al, byte ptr [bx]
  0503E1  4991: 50               push ax
  0503E2  4992: ffb66eff         push word ptr [bp - 0x92]
  0503E6  4996: ffb67aff         push word ptr [bp - 0x86]
  0503EA  499A: 9a7a031f18       lcall 0x181f, 0x37a
  0503EF  499F: 83c408           add sp, 8
  0503F2  49A2: 8bc8             mov cx, ax
  0503F4  49A4: c1f902           sar cx, 2
  0503F7  49A7: 41               inc cx
  0503F8  49A8: 8b46da           mov ax, word ptr [bp - 0x26]
  0503FB  49AB: 99               cdq 
  0503FC  49AC: f7f9             idiv cx
  0503FE  49AE: 8946da           mov word ptr [bp - 0x26], ax
  050401  49B1: 3b8620ff         cmp ax, word ptr [bp - 0xe0]
  050405  49B5: 7c0a             jl 0x49c1
  050407  49B7: 898620ff         mov word ptr [bp - 0xe0], ax
  05040B  49BB: 8b46b2           mov ax, word ptr [bp - 0x4e]
  05040E  49BE: 8946de           mov word ptr [bp - 0x22], ax
  050411  49C1: ff46b2           inc word ptr [bp - 0x4e]
  050414  49C4: a19e53           mov ax, word ptr [0x539e]
  050417  49C7: 3946b2           cmp word ptr [bp - 0x4e], ax
  05041A  49CA: 7c03             jl 0x49cf
  05041C  49CC: e99100           jmp 0x4a60
  05041F  49CF: ff76b2           push word ptr [bp - 0x4e]
  050422  49D2: 9ae6091f18       lcall 0x181f, 0x9e6
  050427  49D7: 83c402           add sp, 2
  05042A  49DA: 8a861cff         mov al, byte ptr [bp - 0xe4]
  05042E  49DE: 8b1e4285         mov bx, word ptr [0x8542]
  050432  49E2: 38471a           cmp byte ptr [bx + 0x1a], al
  050435  49E5: 75da             jne 0x49c1
  050437  49E7: 8b46a0           mov ax, word ptr [bp - 0x60]
  05043A  49EA: 3946b2           cmp word ptr [bp - 0x4e], ax
  05043D  49ED: 7506             jne 0x49f5
  05043F  49EF: 837ed400         cmp word ptr [bp - 0x2c], 0
  050443  49F3: 74cc             je 0x49c1
  050445  49F5: 695eb2ca00       imul bx, word ptr [bp - 0x4e], 0xca
  05044A  49FA: f687625d40       test byte ptr [bx + 0x5d62], 0x40
  05044F  49FF: 74c0             je 0x49c1
  050451  4A01: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050455  4A05: 8a874a31         mov al, byte ptr [bx + 0x314a]
  050459  4A09: 98               cwde 
  05045A  4A0A: 3b46b2           cmp ax, word ptr [bp - 0x4e]
  05045D  4A0D: 74b2             je 0x49c1
  05045F  4A0F: 837ebe08         cmp word ptr [bp - 0x42], 8
  050463  4A13: 7518             jne 0x4a2d
  050465  4A15: 9a3a0d1f18       lcall 0x181f, 0xd3a
  05046A  4A1A: 8bc8             mov cx, ax
  05046C  4A1C: 8a8642ff         mov al, byte ptr [bp - 0xbe]
  050470  4A20: 98               cwde 
  050471  4A21: 8b1e4285         mov bx, word ptr [0x8542]
  050475  4A25: 0387aa00         add ax, word ptr [bx + 0xaa]
  050479  4A29: 3bc1             cmp ax, cx
  05047B  4A2B: 7f94             jg 0x49c1
  05047D  4A2D: 8b1e4285         mov bx, word ptr [0x8542]
  050481  4A31: 8a4701           mov al, byte ptr [bx + 1]
  050484  4A34: 2ae4             sub ah, ah
  050486  4A36: 50               push ax
  050487  4A37: 8a07             mov al, byte ptr [bx]
  050489  4A39: 50               push ax
  05048A  4A3A: 9a22071f18       lcall 0x181f, 0x722
  05048F  4A3F: 83c404           add sp, 4
  050492  4A42: 8946a2           mov word ptr [bp - 0x5e], ax
  050495  4A45: 9a3a0d1f18       lcall 0x181f, 0xd3a
  05049A  4A4A: 8946e0           mov word ptr [bp - 0x20], ax
  05049D  4A4D: c746f80100       mov word ptr [bp - 8], 1
  0504A2  4A52: 2bc0             sub ax, ax
  0504A4  4A54: 8946da           mov word ptr [bp - 0x26], ax
  0504A7  4A57: 89864cff         mov word ptr [bp - 0xb4], ax
  0504AB  4A5B: e9e3fd           jmp 0x4841
  0504AE  4A5E: 90               nop 
  0504AF  4A5F: 90               nop 
  0504B0  4A60: 837ede00         cmp word ptr [bp - 0x22], 0
  0504B4  4A64: 7c77             jl 0x4add
  0504B6  4A66: ff76de           push word ptr [bp - 0x22]
  0504B9  4A69: 9ae6091f18       lcall 0x181f, 0x9e6
  0504BE  4A6E: 83c402           add sp, 2
  0504C1  4A71: 8b1e4285         mov bx, word ptr [0x8542]
  0504C5  4A75: 8a4701           mov al, byte ptr [bx + 1]
  0504C8  4A78: 2ae4             sub ah, ah
  0504CA  4A7A: 50               push ax
  0504CB  4A7B: 8a1f             mov bl, byte ptr [bx]
  0504CD  4A7D: 2aff             sub bh, bh
  0504CF  4A7F: 8b4606           mov ax, word ptr [bp + 6]
  0504D2  4A82: ba5000           mov dx, 0x50
  0504D5  4A85: e90de5           jmp 0x2f95
  0504D8  4A88: 6a00             push 0
  0504DA  4A8A: ff7606           push word ptr [bp + 6]
  0504DD  4A8D: 9aec0a1f18       lcall 0x181f, 0xaec
  0504E2  4A92: 83c404           add sp, 4
  0504E5  4A95: 89864cff         mov word ptr [bp - 0xb4], ax
  0504E9  4A99: ff36c48d         push word ptr [0x8dc4]
  0504ED  4A9D: 50               push ax
  0504EE  4A9E: 9a2e0a1f19       lcall 0x191f, 0xa2e
  0504F3  4AA3: 83c404           add sp, 4
  0504F6  4AA6: 8bb61cff         mov si, word ptr [bp - 0xe4]
  0504FA  4AAA: c1e604           shl si, 4
  0504FD  4AAD: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  050501  4AB1: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  050505  4AB5: 2ae4             sub ah, ah
  050507  4AB7: f72ec48d         imul word ptr [0x8dc4]
  05050B  4ABB: 99               cdq 
  05050C  4ABC: 8b36fc84         mov si, word ptr [0x84fc]
  050510  4AC0: 01442a           add word ptr [si + 0x2a], ax
  050513  4AC3: 11542c           adc word ptr [si + 0x2c], dx
  050516  4AC6: c1e302           shl bx, 2
  050519  4AC9: 03f3             add si, bx
  05051B  4ACB: 01447c           add word ptr [si + 0x7c], ax
  05051E  4ACE: 11547e           adc word ptr [si + 0x7e], dx
  050521  4AD1: a1c48d           mov ax, word ptr [0x8dc4]
  050524  4AD4: 99               cdq 
  050525  4AD5: 0184bc00         add word ptr [si + 0xbc], ax
  050529  4AD9: 1194be00         adc word ptr [si + 0xbe], dx
  05052D  4ADD: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050531  4AE1: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  050536  4AE6: 75a0             jne 0x4a88
  050538  4AE8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05053C  4AEC: c687503100       mov byte ptr [bx + 0x3150], 0
  050541  4AF1: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050545  4AF5: 8a875031         mov al, byte ptr [bx + 0x3150]
  050549  4AF9: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05054D  4AFD: 2aff             sub bh, bh
  05054F  4AFF: 8bcb             mov cx, bx
  050551  4B01: d1e3             shl bx, 1
  050553  4B03: 03d9             add bx, cx
  050555  4B05: d1e3             shl bx, 1
  050557  4B07: 03d9             add bx, cx
  050559  4B09: d1e3             shl bx, 1
  05055B  4B0B: 38873752         cmp byte ptr [bx + 0x5237], al
  05055F  4B0F: 7503             jne 0x4b14
  050561  4B11: e932fc           jmp 0x4746
  050564  4B14: 3c01             cmp al, 1
  050566  4B16: 7603             jbe 0x4b1b
  050568  4B18: e92bfc           jmp 0x4746
  05056B  4B1B: 83be54ff00       cmp word ptr [bp - 0xac], 0
  050570  4B20: 7411             je 0x4b33
  050572  4B22: 6a00             push 0
  050574  4B24: 6a00             push 0
  050576  4B26: 6a00             push 0
  050578  4B28: 687617           push 0x1776
  05057B  4B2B: 9a7e071f18       lcall 0x181f, 0x77e
  050580  4B30: 83c408           add sp, 8
  050583  4B33: 83be54ff00       cmp word ptr [bp - 0xac], 0
  050588  4B38: 7411             je 0x4b4b
  05058A  4B3A: 6a00             push 0
  05058C  4B3C: 6a00             push 0
  05058E  4B3E: 6a00             push 0
  050590  4B40: 687817           push 0x1778
  050593  4B43: 9a7e071f18       lcall 0x181f, 0x77e
  050598  4B48: 83c408           add sp, 8
  05059B  4B4B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05059F  4B4F: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  0505A4  4B54: 7303             jae 0x4b59
  0505A6  4B56: e9c501           jmp 0x4d1e
  0505A9  4B59: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  0505AE  4B5E: 7603             jbe 0x4b63
  0505B0  4B60: e9bb01           jmp 0x4d1e
  0505B3  4B63: 83be36ff00       cmp word ptr [bp - 0xca], 0
  0505B8  4B68: 750a             jne 0x4b74
  0505BA  4B6A: 83be26ff00       cmp word ptr [bp - 0xda], 0
  0505BF  4B6F: 7503             jne 0x4b74
  0505C1  4B71: e9aa01           jmp 0x4d1e
  0505C4  4B74: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  0505C9  4B79: 7403             je 0x4b7e
  0505CB  4B7B: e9a001           jmp 0x4d1e
  0505CE  4B7E: 837efc00         cmp word ptr [bp - 4], 0
  0505D2  4B82: 7403             je 0x4b87
  0505D4  4B84: e99701           jmp 0x4d1e
  0505D7  4B87: b8ffff           mov ax, 0xffff
  0505DA  4B8A: 8946de           mov word ptr [bp - 0x22], ax
  0505DD  4B8D: 898620ff         mov word ptr [bp - 0xe0], ax
  0505E1  4B91: c746b20000       mov word ptr [bp - 0x4e], 0
  0505E6  4B96: 8b5eb2           mov bx, word ptr [bp - 0x4e]
  0505E9  4B99: 8bc3             mov ax, bx
  0505EB  4B9B: d1e3             shl bx, 1
  0505ED  4B9D: 03d8             add bx, ax
  0505EF  4B9F: d1e3             shl bx, 1
  0505F1  4BA1: 83bfdca000       cmp word ptr [bx - 0x5f24], 0
  0505F6  4BA6: 7d03             jge 0x4bab
  0505F8  4BA8: e9b100           jmp 0x4c5c
  0505FB  4BAB: 8bd8             mov bx, ax
  0505FD  4BAD: d1e3             shl bx, 1
  0505FF  4BAF: 03d8             add bx, ax
  050601  4BB1: d1e3             shl bx, 1
  050603  4BB3: 80bfe0a000       cmp byte ptr [bx - 0x5f20], 0
  050608  4BB8: 7f03             jg 0x4bbd
  05060A  4BBA: e99f00           jmp 0x4c5c
  05060D  4BBD: 8bd8             mov bx, ax
  05060F  4BBF: d1e3             shl bx, 1
  050611  4BC1: 03d8             add bx, ax
  050613  4BC3: d1e3             shl bx, 1
  050615  4BC5: ffb7dca0         push word ptr [bx - 0x5f24]
  050619  4BC9: 8bf3             mov si, bx
  05061B  4BCB: 9ae6091f18       lcall 0x181f, 0x9e6
  050620  4BD0: 83c402           add sp, 2
  050623  4BD3: 8b84dea0         mov ax, word ptr [si - 0x5f22]
  050627  4BD7: 8946da           mov word ptr [bp - 0x26], ax
  05062A  4BDA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05062E  4BDE: 8a874a31         mov al, byte ptr [bx + 0x314a]
  050632  4BE2: 98               cwde 
  050633  4BE3: 3b06c68d         cmp ax, word ptr [0x8dc6]
  050637  4BE7: 7473             je 0x4c5c
  050639  4BE9: 8b1e4285         mov bx, word ptr [0x8542]
  05063D  4BED: f6471b02         test byte ptr [bx + 0x1b], 2
  050641  4BF1: 740b             je 0x4bfe
  050643  4BF3: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050647  4BF7: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  05064C  4BFC: 725e             jb 0x4c5c
  05064E  4BFE: 8b1e4285         mov bx, word ptr [0x8542]
  050652  4C02: 8a4701           mov al, byte ptr [bx + 1]
  050655  4C05: 2ae4             sub ah, ah
  050657  4C07: 50               push ax
  050658  4C08: 8a07             mov al, byte ptr [bx]
  05065A  4C0A: 50               push ax
  05065B  4C0B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05065F  4C0F: 8a874531         mov al, byte ptr [bx + 0x3145]
  050663  4C13: 50               push ax
  050664  4C14: 8a874431         mov al, byte ptr [bx + 0x3144]
  050668  4C18: 50               push ax
  050669  4C19: 9a7a031f18       lcall 0x181f, 0x37a
  05066E  4C1E: 83c408           add sp, 8
  050671  4C21: 8bc8             mov cx, ax
  050673  4C23: c1f902           sar cx, 2
  050676  4C26: 41               inc cx
  050677  4C27: 8b46da           mov ax, word ptr [bp - 0x26]
  05067A  4C2A: 99               cdq 
  05067B  4C2B: f7f9             idiv cx
  05067D  4C2D: 8946da           mov word ptr [bp - 0x26], ax
  050680  4C30: 3b8620ff         cmp ax, word ptr [bp - 0xe0]
  050684  4C34: 7c26             jl 0x4c5c
  050686  4C36: 83be36ff00       cmp word ptr [bp - 0xca], 0
  05068B  4C3B: 7512             jne 0x4c4f
  05068D  4C3D: 8b5eb2           mov bx, word ptr [bp - 0x4e]
  050690  4C40: 8bc3             mov ax, bx
  050692  4C42: d1e3             shl bx, 1
  050694  4C44: 03d8             add bx, ax
  050696  4C46: d1e3             shl bx, 1
  050698  4C48: 80bfe1a000       cmp byte ptr [bx - 0x5f1f], 0
  05069D  4C4D: 740d             je 0x4c5c
  05069F  4C4F: 8b46da           mov ax, word ptr [bp - 0x26]
  0506A2  4C52: 898620ff         mov word ptr [bp - 0xe0], ax
  0506A6  4C56: 8b46b2           mov ax, word ptr [bp - 0x4e]
  0506A9  4C59: 8946de           mov word ptr [bp - 0x22], ax
  0506AC  4C5C: ff46b2           inc word ptr [bp - 0x4e]
  0506AF  4C5F: 837eb210         cmp word ptr [bp - 0x4e], 0x10
  0506B3  4C63: 7d03             jge 0x4c68
  0506B5  4C65: e92eff           jmp 0x4b96
  0506B8  4C68: 837ede00         cmp word ptr [bp - 0x22], 0
  0506BC  4C6C: 7d03             jge 0x4c71
  0506BE  4C6E: e9ad00           jmp 0x4d1e
  0506C1  4C71: 8b5ede           mov bx, word ptr [bp - 0x22]
  0506C4  4C74: 8bc3             mov ax, bx
  0506C6  4C76: d1e3             shl bx, 1
  0506C8  4C78: 03d8             add bx, ax
  0506CA  4C7A: d1e3             shl bx, 1
  0506CC  4C7C: 8a87e0a0         mov al, byte ptr [bx - 0x5f20]
  0506D0  4C80: 98               cwde 
  0506D1  4C81: 6b76061c         imul si, word ptr [bp + 6], 0x1c
  0506D5  4C85: 8a8c5031         mov cl, byte ptr [si + 0x3150]
  0506D9  4C89: 2aed             sub ch, ch
  0506DB  4C8B: 8bd3             mov dx, bx
  0506DD  4C8D: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  0506E1  4C91: 2aff             sub bh, bh
  0506E3  4C93: 8bf3             mov si, bx
  0506E5  4C95: d1e3             shl bx, 1
  0506E7  4C97: 03de             add bx, si
  0506E9  4C99: d1e3             shl bx, 1
  0506EB  4C9B: 03de             add bx, si
  0506ED  4C9D: d1e3             shl bx, 1
  0506EF  4C9F: 8bf0             mov si, ax
  0506F1  4CA1: 8a873752         mov al, byte ptr [bx + 0x5237]
  0506F5  4CA5: 2ae4             sub ah, ah
  0506F7  4CA7: 8bde             mov bx, si
  0506F9  4CA9: 2bf0             sub si, ax
  0506FB  4CAB: 03f1             add si, cx
  0506FD  4CAD: 7902             jns 0x4cb1
  0506FF  4CAF: 2bf6             sub si, si
  050701  4CB1: 89b668ff         mov word ptr [bp - 0x98], si
  050705  4CB5: 8bfa             mov di, dx
  050707  4CB7: 8bc6             mov ax, si
  050709  4CB9: f7addea0         imul word ptr [di - 0x5f22]
  05070D  4CBD: 99               cdq 
  05070E  4CBE: f7fb             idiv bx
  050710  4CC0: 8985dea0         mov word ptr [di - 0x5f22], ax
  050714  4CC4: 8a8668ff         mov al, byte ptr [bp - 0x98]
  050718  4CC8: 8885e0a0         mov byte ptr [di - 0x5f20], al
  05071C  4CCC: ffb5dca0         push word ptr [di - 0x5f24]
  050720  4CD0: 9ae6091f18       lcall 0x181f, 0x9e6
  050725  4CD5: 83c402           add sp, 2
  050728  4CD8: 83be68ff00       cmp word ptr [bp - 0x98], 0
  05072D  4CDD: 7506             jne 0x4ce5
  05072F  4CDF: c785dca0ffff     mov word ptr [di - 0x5f24], 0xffff
  050735  4CE5: 83be54ff00       cmp word ptr [bp - 0xac], 0
  05073A  4CEA: 741b             je 0x4d07
  05073C  4CEC: 6a00             push 0
  05073E  4CEE: 8b1e4285         mov bx, word ptr [0x8542]
  050742  4CF2: 8a4701           mov al, byte ptr [bx + 1]
  050745  4CF5: 2ae4             sub ah, ah
  050747  4CF7: 50               push ax
  050748  4CF8: 8a07             mov al, byte ptr [bx]
  05074A  4CFA: 50               push ax
  05074B  4CFB: 8d4702           lea ax, [bx + 2]
  05074E  4CFE: 50               push ax
  05074F  4CFF: 9a7e071f18       lcall 0x181f, 0x77e
  050754  4D04: 83c408           add sp, 8
  050757  4D07: 8b1e4285         mov bx, word ptr [0x8542]
  05075B  4D0B: 8a4701           mov al, byte ptr [bx + 1]
  05075E  4D0E: 2ae4             sub ah, ah
  050760  4D10: 50               push ax
  050761  4D11: 8a1f             mov bl, byte ptr [bx]
  050763  4D13: 2aff             sub bh, bh
  050765  4D15: 8b4606           mov ax, word ptr [bp + 6]
  050768  4D18: ba3500           mov dx, 0x35
  05076B  4D1B: e977e2           jmp 0x2f95
  05076E  4D1E: 837efc00         cmp word ptr [bp - 4], 0
  050772  4D22: 7403             je 0x4d27
  050774  4D24: e9f114           jmp 0x6218
  050777  4D27: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05077B  4D2B: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  050780  4D30: 7239             jb 0x4d6b
  050782  4D32: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  050787  4D37: 7732             ja 0x4d6b
  050789  4D39: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  05078E  4D3E: 752b             jne 0x4d6b
  050790  4D40: 837ebe00         cmp word ptr [bp - 0x42], 0
  050794  4D44: 7d25             jge 0x4d6b
  050796  4D46: 83be26ff00       cmp word ptr [bp - 0xda], 0
  05079B  4D4B: 741e             je 0x4d6b
  05079D  4D4D: 837efc00         cmp word ptr [bp - 4], 0
  0507A1  4D51: 7518             jne 0x4d6b
  0507A3  4D53: f687483120       test byte ptr [bx + 0x3148], 0x20
  0507A8  4D58: 7403             je 0x4d5d
  0507AA  4D5A: e9e9f9           jmp 0x4746
  0507AD  4D5D: 8a4606           mov al, byte ptr [bp + 6]
  0507B0  4D60: 02068e53         add al, byte ptr [0x538e]
  0507B4  4D64: a81f             test al, 0x1f
  0507B6  4D66: 7503             jne 0x4d6b
  0507B8  4D68: e9dbf9           jmp 0x4746
  0507BB  4D6B: 83be54ff00       cmp word ptr [bp - 0xac], 0
  0507C0  4D70: 7411             je 0x4d83
  0507C2  4D72: 6a00             push 0
  0507C4  4D74: 6a00             push 0
  0507C6  4D76: 6a00             push 0
  0507C8  4D78: 687c17           push 0x177c
  0507CB  4D7B: 9a7e071f18       lcall 0x181f, 0x77e
  0507D0  4D80: 83c408           add sp, 8
  0507D3  4D83: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0507D7  4D87: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  0507DC  4D8C: 7403             je 0x4d91
  0507DE  4D8E: e93701           jmp 0x4ec8
  0507E1  4D91: 80bf583100       cmp byte ptr [bx + 0x3158], 0
  0507E6  4D96: 7503             jne 0x4d9b
  0507E8  4D98: e9c700           jmp 0x4e62
  0507EB  4D9B: c746deffff       mov word ptr [bp - 0x22], 0xffff
  0507F0  4DA0: c78620ff0f27     mov word ptr [bp - 0xe0], 0x270f
  0507F6  4DA6: c746b20000       mov word ptr [bp - 0x4e], 0
  0507FB  4DAB: eb7e             jmp 0x4e2b
  0507FD  4DAD: 90               nop 
  0507FE  4DAE: ff76b2           push word ptr [bp - 0x4e]
  050801  4DB1: 9a4c0a1f18       lcall 0x181f, 0xa4c
  050806  4DB6: 83c402           add sp, 2
  050809  4DB9: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  05080D  4DBD: 8a4701           mov al, byte ptr [bx + 1]
  050810  4DC0: 2ae4             sub ah, ah
  050812  4DC2: 50               push ax
  050813  4DC3: 8a07             mov al, byte ptr [bx]
  050815  4DC5: 50               push ax
  050816  4DC6: 9a22071f18       lcall 0x181f, 0x722
  05081B  4DCB: 83c404           add sp, 4
  05081E  4DCE: 3b46ca           cmp ax, word ptr [bp - 0x36]
  050821  4DD1: 7555             jne 0x4e28
  050823  4DD3: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  050827  4DD7: 8a4701           mov al, byte ptr [bx + 1]
  05082A  4DDA: 2ae4             sub ah, ah
  05082C  4DDC: 50               push ax
  05082D  4DDD: 8a07             mov al, byte ptr [bx]
  05082F  4DDF: 50               push ax
  050830  4DE0: ffb66eff         push word ptr [bp - 0x92]
  050834  4DE4: ffb67aff         push word ptr [bp - 0x86]
  050838  4DE8: 9a7a031f18       lcall 0x181f, 0x37a
  05083D  4DED: 83c408           add sp, 8
  050840  4DF0: 8946d0           mov word ptr [bp - 0x30], ax
  050843  4DF3: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  050847  4DF7: 8a4703           mov al, byte ptr [bx + 3]
  05084A  4DFA: 250400           and ax, 4
  05084D  4DFD: 89862aff         mov word ptr [bp - 0xd6], ax
  050851  4E01: 0bc0             or ax, ax
  050853  4E03: 7410             je 0x4e15
  050855  4E05: 8b46d0           mov ax, word ptr [bp - 0x30]
  050858  4E08: d1f8             sar ax, 1
  05085A  4E0A: 3d0100           cmp ax, 1
  05085D  4E0D: 7d03             jge 0x4e12
  05085F  4E0F: b80100           mov ax, 1
  050862  4E12: 8946d0           mov word ptr [bp - 0x30], ax
  050865  4E15: 8b46d0           mov ax, word ptr [bp - 0x30]
  050868  4E18: 398620ff         cmp word ptr [bp - 0xe0], ax
  05086C  4E1C: 7e0a             jle 0x4e28
  05086E  4E1E: 8b4eb2           mov cx, word ptr [bp - 0x4e]
  050871  4E21: 894ede           mov word ptr [bp - 0x22], cx
  050874  4E24: 898620ff         mov word ptr [bp - 0xe0], ax
  050878  4E28: ff46b2           inc word ptr [bp - 0x4e]
  05087B  4E2B: a19a53           mov ax, word ptr [0x539a]
  05087E  4E2E: 3946b2           cmp word ptr [bp - 0x4e], ax
  050881  4E31: 7d03             jge 0x4e36
  050883  4E33: e978ff           jmp 0x4dae
  050886  4E36: 837ede00         cmp word ptr [bp - 0x22], 0
  05088A  4E3A: 7d03             jge 0x4e3f
  05088C  4E3C: e91a01           jmp 0x4f59
  05088F  4E3F: ff76de           push word ptr [bp - 0x22]
  050892  4E42: 9a4c0a1f18       lcall 0x181f, 0xa4c
  050897  4E47: 83c402           add sp, 2
  05089A  4E4A: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  05089E  4E4E: 8a4701           mov al, byte ptr [bx + 1]
  0508A1  4E51: 2ae4             sub ah, ah
  0508A3  4E53: 50               push ax
  0508A4  4E54: 8a1f             mov bl, byte ptr [bx]
  0508A6  4E56: 2aff             sub bh, bh
  0508A8  4E58: 8b4606           mov ax, word ptr [bp + 6]
  0508AB  4E5B: ba3400           mov dx, 0x34
  0508AE  4E5E: e934e1           jmp 0x2f95
  0508B1  4E61: 90               nop 
  0508B2  4E62: 837ed400         cmp word ptr [bp - 0x2c], 0
  0508B6  4E66: 7528             jne 0x4e90
  0508B8  4E68: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0508BC  4E6C: 80bf4a3100       cmp byte ptr [bx + 0x314a], 0
  0508C1  4E71: 7d07             jge 0x4e7a
  0508C3  4E73: 8a46a0           mov al, byte ptr [bp - 0x60]
  0508C6  4E76: 88874a31         mov byte ptr [bx + 0x314a], al
  0508CA  4E7A: 8a46a0           mov al, byte ptr [bp - 0x60]
  0508CD  4E7D: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0508D1  4E81: 38874a31         cmp byte ptr [bx + 0x314a], al
  0508D5  4E85: 7509             jne 0x4e90
  0508D7  4E87: c6874b3155       mov byte ptr [bx + 0x314b], 0x55
  0508DC  4E8C: e9aa11           jmp 0x6039
  0508DF  4E8F: 90               nop 
  0508E0  4E90: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0508E4  4E94: 80bf4a3100       cmp byte ptr [bx + 0x314a], 0
  0508E9  4E99: 7c11             jl 0x4eac
  0508EB  4E9B: 8a874a31         mov al, byte ptr [bx + 0x314a]
  0508EF  4E9F: 98               cwde 
  0508F0  4EA0: 50               push ax
  0508F1  4EA1: 9ae6091f18       lcall 0x181f, 0x9e6
  0508F6  4EA6: 83c402           add sp, 2
  0508F9  4EA9: e95bfe           jmp 0x4d07
  0508FC  4EAC: 8b46ca           mov ax, word ptr [bp - 0x36]
  0508FF  4EAF: 3946d6           cmp word ptr [bp - 0x2a], ax
  050902  4EB2: 7403             je 0x4eb7
  050904  4EB4: e9a200           jmp 0x4f59
  050907  4EB7: 8a46a0           mov al, byte ptr [bp - 0x60]
  05090A  4EBA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05090E  4EBE: 88874a31         mov byte ptr [bx + 0x314a], al
  050912  4EC2: ff76a0           push word ptr [bp - 0x60]
  050915  4EC5: ebda             jmp 0x4ea1
  050917  4EC7: 90               nop 
  050918  4EC8: 83be54ff00       cmp word ptr [bp - 0xac], 0
  05091D  4ECD: 7411             je 0x4ee0
  05091F  4ECF: 6a00             push 0
  050921  4ED1: 6a00             push 0
  050923  4ED3: 6a00             push 0
  050925  4ED5: 688117           push 0x1781
  050928  4ED8: 9a7e071f18       lcall 0x181f, 0x77e
  05092D  4EDD: 83c408           add sp, 8
  050930  4EE0: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050934  4EE4: 80bf46310a       cmp byte ptr [bx + 0x3146], 0xa
  050939  4EE9: 7403             je 0x4eee
  05093B  4EEB: e90f01           jmp 0x4ffd
  05093E  4EEE: 837ed400         cmp word ptr [bp - 0x2c], 0
  050942  4EF2: 7574             jne 0x4f68
  050944  4EF4: b064             mov al, 0x64
  050946  4EF6: f6a75b31         mul byte ptr [bx + 0x315b]
  05094A  4EFA: 89862cff         mov word ptr [bp - 0xd4], ax
  05094E  4EFE: 2bd2             sub dx, dx
  050950  4F00: 8b1efc84         mov bx, word ptr [0x84fc]
  050954  4F04: 01472a           add word ptr [bx + 0x2a], ax
  050957  4F07: 11572c           adc word ptr [bx + 0x2c], dx
  05095A  4F0A: f606825301       test byte ptr [0x5382], 1
  05095F  4F0F: 7548             jne 0x4f59
  050961  4F11: ffb61cff         push word ptr [bp - 0xe4]
  050965  4F15: 9aa4091f18       lcall 0x181f, 0x9a4
  05096A  4F1A: 83c402           add sp, 2
  05096D  4F1D: 50               push ax
  05096E  4F1E: 6a00             push 0
  050970  4F20: 9a38041f18       lcall 0x181f, 0x438
  050975  4F25: 83c404           add sp, 4
  050978  4F28: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  05097C  4F2C: d1e3             shl bx, 1
  05097E  4F2E: ffb78c83         push word ptr [bx - 0x7c74]
  050982  4F32: 6a01             push 1
  050984  4F34: 9a38041f18       lcall 0x181f, 0x438
  050989  4F39: 83c404           add sp, 4
  05098C  4F3C: 6a00             push 0
  05098E  4F3E: ffb62cff         push word ptr [bp - 0xd4]
  050992  4F42: 6a00             push 0
  050994  4F44: 9aae091f18       lcall 0x181f, 0x9ae
  050999  4F49: 83c406           add sp, 6
  05099C  4F4C: 6a02             push 2
  05099E  4F4E: 688617           push 0x1786
  0509A1  4F51: 9a52061f18       lcall 0x181f, 0x652
  0509A6  4F56: 83c404           add sp, 4
  0509A9  4F59: ff7606           push word ptr [bp + 6]
  0509AC  4F5C: 9a08081f18       lcall 0x181f, 0x808
  0509B1  4F61: 83c402           add sp, 2
  0509B4  4F64: e99613           jmp 0x62fd
  0509B7  4F67: 90               nop 
  0509B8  4F68: 8b46ca           mov ax, word ptr [bp - 0x36]
  0509BB  4F6B: 3946d6           cmp word ptr [bp - 0x2a], ax
  0509BE  4F6E: 7503             jne 0x4f73
  0509C0  4F70: e94fff           jmp 0x4ec2
  0509C3  4F73: ffb66eff         push word ptr [bp - 0x92]
  0509C7  4F77: ffb67aff         push word ptr [bp - 0x86]
  0509CB  4F7B: 8b4606           mov ax, word ptr [bp + 6]
  0509CE  4F7E: 89865cff         mov word ptr [bp - 0xa4], ax
  0509D2  4F82: 50               push ax
  0509D3  4F83: ffb61cff         push word ptr [bp - 0xe4]
  0509D7  4F87: 9aa8081f18       lcall 0x181f, 0x8a8
  0509DC  4F8C: 83c408           add sp, 8
  0509DF  4F8F: 894606           mov word ptr [bp + 6], ax
  0509E2  4F92: 0bc0             or ax, ax
  0509E4  4F94: 7c42             jl 0x4fd8
  0509E6  4F96: 6bd81c           imul bx, ax, 0x1c
  0509E9  4F99: 8a874531         mov al, byte ptr [bx + 0x3145]
  0509ED  4F9D: 2ae4             sub ah, ah
  0509EF  4F9F: 50               push ax
  0509F0  4FA0: 8a874431         mov al, byte ptr [bx + 0x3144]
  0509F4  4FA4: 50               push ax
  0509F5  4FA5: 8bf3             mov si, bx
  0509F7  4FA7: 9a22071f18       lcall 0x181f, 0x722
  0509FC  4FAC: 83c404           add sp, 4
  0509FF  4FAF: 3b46ca           cmp ax, word ptr [bp - 0x36]
  050A02  4FB2: 7524             jne 0x4fd8
  050A04  4FB4: 8a844431         mov al, byte ptr [si + 0x3144]
  050A08  4FB8: 2ae4             sub ah, ah
  050A0A  4FBA: 8946f4           mov word ptr [bp - 0xc], ax
  050A0D  4FBD: 8a844531         mov al, byte ptr [si + 0x3145]
  050A11  4FC1: 8946e4           mov word ptr [bp - 0x1c], ax
  050A14  4FC4: 8b865cff         mov ax, word ptr [bp - 0xa4]
  050A18  4FC8: 894606           mov word ptr [bp + 6], ax
  050A1B  4FCB: ff76e4           push word ptr [bp - 0x1c]
  050A1E  4FCE: ba2100           mov dx, 0x21
  050A21  4FD1: 8b5ef4           mov bx, word ptr [bp - 0xc]
  050A24  4FD4: e9bedf           jmp 0x2f95
  050A27  4FD7: 90               nop 
  050A28  4FD8: 8b865cff         mov ax, word ptr [bp - 0xa4]
  050A2C  4FDC: 894606           mov word ptr [bp + 6], ax
  050A2F  4FDF: 6a00             push 0
  050A31  4FE1: ffb61cff         push word ptr [bp - 0xe4]
  050A35  4FE5: ffb66eff         push word ptr [bp - 0x92]
  050A39  4FE9: ffb67aff         push word ptr [bp - 0x86]
  050A3D  4FED: 0e               push cs
  050A3E  4FEE: e8852a           call 0x7a76
  050A41  4FF1: 83c408           add sp, 8
  050A44  4FF4: 3b069853         cmp ax, word ptr [0x5398]
  050A48  4FF8: 7503             jne 0x4ffd
  050A4A  4FFA: e95cff           jmp 0x4f59
  050A4D  4FFD: 83be54ff00       cmp word ptr [bp - 0xac], 0
  050A52  5002: 7411             je 0x5015
  050A54  5004: 6a00             push 0
  050A56  5006: 6a00             push 0
  050A58  5008: 6a00             push 0
  050A5A  500A: 689217           push 0x1792
  050A5D  500D: 9a7e071f18       lcall 0x181f, 0x77e
  050A62  5012: 83c408           add sp, 8
  050A65  5015: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050A69  5019: 80bf463103       cmp byte ptr [bx + 0x3146], 3
  050A6E  501E: 7403             je 0x5023
  050A70  5020: e97401           jmp 0x5197
  050A73  5023: c746deffff       mov word ptr [bp - 0x22], 0xffff
  050A78  5028: c78620ff19fc     mov word ptr [bp - 0xe0], 0xfc19
  050A7E  502E: c746b20000       mov word ptr [bp - 0x4e], 0
  050A83  5033: eb19             jmp 0x504e
  050A85  5035: 90               nop 
  050A86  5036: ff369853         push word ptr [0x5398]
  050A8A  503A: ff36528d         push word ptr [0x8d52]
  050A8E  503E: 9a0c031f18       lcall 0x181f, 0x30c
  050A93  5043: 83c404           add sp, 4
  050A96  5046: 3d4b00           cmp ax, 0x4b
  050A99  5049: 7c59             jl 0x50a4
  050A9B  504B: ff46b2           inc word ptr [bp - 0x4e]
  050A9E  504E: a19a53           mov ax, word ptr [0x539a]
  050AA1  5051: 3946b2           cmp word ptr [bp - 0x4e], ax
  050AA4  5054: 7c03             jl 0x5059
  050AA6  5056: e90d01           jmp 0x5166
  050AA9  5059: ff76b2           push word ptr [bp - 0x4e]
  050AAC  505C: 9a4c0a1f18       lcall 0x181f, 0xa4c
  050AB1  5061: 83c402           add sp, 2
  050AB4  5064: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  050AB8  5068: 8a4701           mov al, byte ptr [bx + 1]
  050ABB  506B: 2ae4             sub ah, ah
  050ABD  506D: 50               push ax
  050ABE  506E: 8a07             mov al, byte ptr [bx]
  050AC0  5070: 50               push ax
  050AC1  5071: 9a22071f18       lcall 0x181f, 0x722
  050AC6  5076: 83c404           add sp, 4
  050AC9  5079: 3b46ca           cmp ax, word ptr [bp - 0x36]
  050ACC  507C: 75cd             jne 0x504b
  050ACE  507E: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  050AD2  5082: 8a4705           mov al, byte ptr [bx + 5]
  050AD5  5085: 250f00           and ax, 0xf
  050AD8  5088: 3b861cff         cmp ax, word ptr [bp - 0xe4]
  050ADC  508C: 753c             jne 0x50ca
  050ADE  508E: 8b1efc84         mov bx, word ptr [0x84fc]
  050AE2  5092: 837f2c00         cmp word ptr [bx + 0x2c], 0
  050AE6  5096: 7f9e             jg 0x5036
  050AE8  5098: 7cb1             jl 0x504b
  050AEA  509A: 817f2ac409       cmp word ptr [bx + 0x2a], 0x9c4
  050AEF  509F: 7395             jae 0x5036
  050AF1  50A1: eba8             jmp 0x504b
  050AF3  50A3: 90               nop 
  050AF4  50A4: ff369853         push word ptr [0x5398]
  050AF8  50A8: ff36528d         push word ptr [0x8d52]
  050AFC  50AC: 9a380a1f18       lcall 0x181f, 0xa38
  050B01  50B1: 83c404           add sp, 4
  050B04  50B4: a820             test al, 0x20
  050B06  50B6: 7493             je 0x504b
  050B08  50B8: 8b1e9853         mov bx, word ptr [0x5398]
  050B0C  50BC: 8a877c91         mov al, byte ptr [bx - 0x6e84]
  050B10  50C0: 8b9e1cff         mov bx, word ptr [bp - 0xe4]
  050B14  50C4: 38877c91         cmp byte ptr [bx - 0x6e84], al
  050B18  50C8: 7381             jae 0x504b
  050B1A  50CA: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  050B1E  50CE: 8a4703           mov al, byte ptr [bx + 3]
  050B21  50D1: 250400           and ax, 4
  050B24  50D4: 89862aff         mov word ptr [bp - 0xd6], ax
  050B28  50D8: 8d8678ff         lea ax, [bp - 0x88]
  050B2C  50DC: 50               push ax
  050B2D  50DD: ff76b2           push word ptr [bp - 0x4e]
  050B30  50E0: 9a16031f18       lcall 0x181f, 0x316
  050B35  50E5: 83c404           add sp, 4
  050B38  50E8: 8946ac           mov word ptr [bp - 0x54], ax
  050B3B  50EB: 0bc0             or ax, ax
  050B3D  50ED: 7c0b             jl 0x50fa
  050B3F  50EF: 8b8678ff         mov ax, word ptr [bp - 0x88]
  050B43  50F3: c1e005           shl ax, 5
  050B46  50F6: 018632ff         add word ptr [bp - 0xce], ax
  050B4A  50FA: ffb61cff         push word ptr [bp - 0xe4]
  050B4E  50FE: ff36528d         push word ptr [0x8d52]
  050B52  5102: 9a0c031f18       lcall 0x181f, 0x30c
  050B57  5107: 83c404           add sp, 4
  050B5A  510A: 898632ff         mov word ptr [bp - 0xce], ax
  050B5E  510E: c1a632ff03       shl word ptr [bp - 0xce], 3
  050B63  5113: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  050B67  5117: 8a4701           mov al, byte ptr [bx + 1]
  050B6A  511A: 2ae4             sub ah, ah
  050B6C  511C: 50               push ax
  050B6D  511D: 8a07             mov al, byte ptr [bx]
  050B6F  511F: 50               push ax
  050B70  5120: ffb66eff         push word ptr [bp - 0x92]
  050B74  5124: ffb67aff         push word ptr [bp - 0x86]
  050B78  5128: 9a7a031f18       lcall 0x181f, 0x37a
  050B7D  512D: 83c408           add sp, 8
  050B80  5130: 8bc8             mov cx, ax
  050B82  5132: 41               inc cx
  050B83  5133: 8b8632ff         mov ax, word ptr [bp - 0xce]
  050B87  5137: 99               cdq 
  050B88  5138: f7f9             idiv cx
  050B8A  513A: 898632ff         mov word ptr [bp - 0xce], ax
  050B8E  513E: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  050B93  5143: 7406             je 0x514b
  050B95  5145: d1f8             sar ax, 1
  050B97  5147: 018632ff         add word ptr [bp - 0xce], ax
  050B9B  514B: 8b8632ff         mov ax, word ptr [bp - 0xce]
  050B9F  514F: 398620ff         cmp word ptr [bp - 0xe0], ax
  050BA3  5153: 7c03             jl 0x5158
  050BA5  5155: e9f3fe           jmp 0x504b
  050BA8  5158: 898620ff         mov word ptr [bp - 0xe0], ax
  050BAC  515C: 8b46b2           mov ax, word ptr [bp - 0x4e]
  050BAF  515F: 8946de           mov word ptr [bp - 0x22], ax
  050BB2  5162: e9e6fe           jmp 0x504b
  050BB5  5165: 90               nop 
  050BB6  5166: 837ede00         cmp word ptr [bp - 0x22], 0
  050BBA  516A: 7c22             jl 0x518e
  050BBC  516C: ff76de           push word ptr [bp - 0x22]
  050BBF  516F: 9a4c0a1f18       lcall 0x181f, 0xa4c
  050BC4  5174: 83c402           add sp, 2
  050BC7  5177: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  050BCB  517B: 8a4701           mov al, byte ptr [bx + 1]
  050BCE  517E: 2ae4             sub ah, ah
  050BD0  5180: 50               push ax
  050BD1  5181: 8a1f             mov bl, byte ptr [bx]
  050BD3  5183: 2aff             sub bh, bh
  050BD5  5185: 8b4606           mov ax, word ptr [bp + 6]
  050BD8  5188: ba4a00           mov dx, 0x4a
  050BDB  518B: e907de           jmp 0x2f95
  050BDE  518E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050BE2  5192: c687463100       mov byte ptr [bx + 0x3146], 0
  050BE7  5197: 83be54ff00       cmp word ptr [bp - 0xac], 0
  050BEC  519C: 7411             je 0x51af
  050BEE  519E: 6a00             push 0
  050BF0  51A0: 6a00             push 0
  050BF2  51A2: 6a00             push 0
  050BF4  51A4: 689717           push 0x1797
  050BF7  51A7: 9a7e071f18       lcall 0x181f, 0x77e
  050BFC  51AC: 83c408           add sp, 8
  050BFF  51AF: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050C03  51B3: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  050C08  51B8: 7407             je 0x51c1
  050C0A  51BA: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  050C0F  51BF: 7531             jne 0x51f2
  050C11  51C1: 837ed800         cmp word ptr [bp - 0x28], 0
  050C15  51C5: 752b             jne 0x51f2
  050C17  51C7: 8b46ca           mov ax, word ptr [bp - 0x36]
  050C1A  51CA: 3946d6           cmp word ptr [bp - 0x2a], ax
  050C1D  51CD: 7523             jne 0x51f2
  050C1F  51CF: ff76a0           push word ptr [bp - 0x60]
  050C22  51D2: 9ae6091f18       lcall 0x181f, 0x9e6
  050C27  51D7: 83c402           add sp, 2
  050C2A  51DA: 8b1e4285         mov bx, word ptr [0x8542]
  050C2E  51DE: 8a4701           mov al, byte ptr [bx + 1]
  050C31  51E1: 2ae4             sub ah, ah
  050C33  51E3: 50               push ax
  050C34  51E4: 8a1f             mov bl, byte ptr [bx]
  050C36  51E6: 2aff             sub bh, bh
  050C38  51E8: 8b4606           mov ax, word ptr [bp + 6]
  050C3B  51EB: ba4e00           mov dx, 0x4e
  050C3E  51EE: e9a4dd           jmp 0x2f95
  050C41  51F1: 90               nop 
  050C42  51F2: 83be54ff00       cmp word ptr [bp - 0xac], 0
  050C47  51F7: 7411             je 0x520a
  050C49  51F9: 6a00             push 0
  050C4B  51FB: 6a00             push 0
  050C4D  51FD: 6a00             push 0
  050C4F  51FF: 689c17           push 0x179c
  050C52  5202: 9a7e071f18       lcall 0x181f, 0x77e
  050C57  5207: 83c408           add sp, 8
  050C5A  520A: 837e9800         cmp word ptr [bp - 0x68], 0
  050C5E  520E: 7503             jne 0x5213
  050C60  5210: e9ff00           jmp 0x5312
  050C63  5213: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050C67  5217: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  050C6C  521C: 7503             jne 0x5221
  050C6E  521E: e9f70f           jmp 0x6218
  050C71  5221: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050C75  5225: 80bf563100       cmp byte ptr [bx + 0x3156], 0
  050C7A  522A: 7d14             jge 0x5240
  050C7C  522C: 6a14             push 0x14
  050C7E  522E: 6a01             push 1
  050C80  5230: 8bf3             mov si, bx
  050C82  5232: 9ad4041f18       lcall 0x181f, 0x4d4
  050C87  5237: 83c404           add sp, 4
  050C8A  523A: fec8             dec al
  050C8C  523C: 88845631         mov byte ptr [si + 0x3156], al
  050C90  5240: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050C94  5244: 8a875631         mov al, byte ptr [bx + 0x3156]
  050C98  5248: 2ae4             sub ah, ah
  050C9A  524A: 8946b2           mov word ptr [bp - 0x4e], ax
  050C9D  524D: 80bf4b3138       cmp byte ptr [bx + 0x314b], 0x38
  050CA2  5252: 7514             jne 0x5268
  050CA4  5254: 38a75531         cmp byte ptr [bx + 0x3155], ah
  050CA8  5258: 740e             je 0x5268
  050CAA  525A: 8a874d31         mov al, byte ptr [bx + 0x314d]
  050CAE  525E: 8946ea           mov word ptr [bp - 0x16], ax
  050CB1  5261: 8a874e31         mov al, byte ptr [bx + 0x314e]
  050CB5  5265: eb1e             jmp 0x5285
  050CB7  5267: 90               nop 
  050CB8  5268: 8bd8             mov bx, ax
  050CBA  526A: 8a87c800         mov al, byte ptr [bx + 0xc8]
  050CBE  526E: 98               cwde 
  050CBF  526F: c1e002           shl ax, 2
  050CC2  5272: 03867aff         add ax, word ptr [bp - 0x86]
  050CC6  5276: 8946ea           mov word ptr [bp - 0x16], ax
  050CC9  5279: 8a87de00         mov al, byte ptr [bx + 0xde]
  050CCD  527D: 98               cwde 
  050CCE  527E: c1e002           shl ax, 2
  050CD1  5281: 03866eff         add ax, word ptr [bp - 0x92]
  050CD5  5285: 8946e6           mov word ptr [bp - 0x1a], ax
  050CD8  5288: 50               push ax
  050CD9  5289: ff76ea           push word ptr [bp - 0x16]
  050CDC  528C: 9a02031f18       lcall 0x181f, 0x302
  050CE1  5291: 83c404           add sp, 4
  050CE4  5294: 0bc0             or ax, ax
  050CE6  5296: 747a             je 0x5312
  050CE8  5298: 8b46ea           mov ax, word ptr [bp - 0x16]
  050CEB  529B: c1f802           sar ax, 2
  050CEE  529E: 6bf012           imul si, ax, 0x12
  050CF1  52A1: 8b5ee6           mov bx, word ptr [bp - 0x1a]
  050CF4  52A4: c1fb02           sar bx, 2
  050CF7  52A7: f680aa9f06       test byte ptr [bx + si - 0x6056], 6
  050CFC  52AC: 7564             jne 0x5312
  050CFE  52AE: ff76e6           push word ptr [bp - 0x1a]
  050D01  52B1: ff76ea           push word ptr [bp - 0x16]
  050D04  52B4: 9a22071f18       lcall 0x181f, 0x722
  050D09  52B9: 83c404           add sp, 4
  050D0C  52BC: 3b46ca           cmp ax, word ptr [bp - 0x36]
  050D0F  52BF: 7551             jne 0x5312
  050D11  52C1: ff76e6           push word ptr [bp - 0x1a]
  050D14  52C4: ff76ea           push word ptr [bp - 0x16]
  050D17  52C7: 9ad2061f18       lcall 0x181f, 0x6d2
  050D1C  52CC: 83c404           add sp, 4
  050D1F  52CF: 0bc0             or ax, ax
  050D21  52D1: 7d3f             jge 0x5312
  050D23  52D3: 8b5eb2           mov bx, word ptr [bp - 0x4e]
  050D26  52D6: 8a87de00         mov al, byte ptr [bx + 0xde]
  050D2A  52DA: 98               cwde 
  050D2B  52DB: c1e002           shl ax, 2
  050D2E  52DE: 8bc8             mov cx, ax
  050D30  52E0: 8a87c800         mov al, byte ptr [bx + 0xc8]
  050D34  52E4: 98               cwde 
  050D35  52E5: c1e002           shl ax, 2
  050D38  52E8: 3bc1             cmp ax, cx
  050D3A  52EA: 7d02             jge 0x52ee
  050D3C  52EC: 8bc1             mov ax, cx
  050D3E  52EE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050D42  52F2: 88875531         mov byte ptr [bx + 0x3155], al
  050D46  52F6: 80bf543108       cmp byte ptr [bx + 0x3154], 8
  050D4B  52FB: 7605             jbe 0x5302
  050D4D  52FD: 80af543108       sub byte ptr [bx + 0x3154], 8
  050D52  5302: ff76e6           push word ptr [bp - 0x1a]
  050D55  5305: 8b4606           mov ax, word ptr [bp + 6]
  050D58  5308: ba3800           mov dx, 0x38
  050D5B  530B: 8b5eea           mov bx, word ptr [bp - 0x16]
  050D5E  530E: e984dc           jmp 0x2f95
  050D61  5311: 90               nop 
  050D62  5312: 83be54ff00       cmp word ptr [bp - 0xac], 0
  050D67  5317: 7411             je 0x532a
  050D69  5319: 6a00             push 0
  050D6B  531B: 6a00             push 0
  050D6D  531D: 6a00             push 0
  050D6F  531F: 68a117           push 0x17a1
  050D72  5322: 9a7e071f18       lcall 0x181f, 0x77e
  050D77  5327: 83c408           add sp, 8
  050D7A  532A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050D7E  532E: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  050D83  5333: 720a             jb 0x533f
  050D85  5335: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  050D8A  533A: 7703             ja 0x533f
  050D8C  533C: e99100           jmp 0x53d0
  050D8F  533F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050D93  5343: 8d874631         lea ax, [bx + 0x3146]
  050D97  5347: 8bf0             mov si, ax
  050D99  5349: 8bcb             mov cx, bx
  050D9B  534B: 8a1c             mov bl, byte ptr [si]
  050D9D  534D: 2aff             sub bh, bh
  050D9F  534F: 8bd3             mov dx, bx
  050DA1  5351: d1e3             shl bx, 1
  050DA3  5353: 03da             add bx, dx
  050DA5  5355: d1e3             shl bx, 1
  050DA7  5357: 03da             add bx, dx
  050DA9  5359: d1e3             shl bx, 1
  050DAB  535B: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  050DB0  5360: 766e             jbe 0x53d0
  050DB2  5362: 8bd9             mov bx, cx
  050DB4  5364: 80bf4a3100       cmp byte ptr [bx + 0x314a], 0
  050DB9  5369: 7c65             jl 0x53d0
  050DBB  536B: 8a874a31         mov al, byte ptr [bx + 0x314a]
  050DBF  536F: 98               cwde 
  050DC0  5370: 50               push ax
  050DC1  5371: 8bfe             mov di, si
  050DC3  5373: 9ae6091f18       lcall 0x181f, 0x9e6
  050DC8  5378: 83c402           add sp, 2
  050DCB  537B: 8b1e4285         mov bx, word ptr [0x8542]
  050DCF  537F: f6471b04         test byte ptr [bx + 0x1b], 4
  050DD3  5383: 744b             je 0x53d0
  050DD5  5385: 807f1e00         cmp byte ptr [bx + 0x1e], 0
  050DD9  5389: 7505             jne 0x5390
  050DDB  538B: 803d04           cmp byte ptr [di], 4
  050DDE  538E: 7440             je 0x53d0
  050DE0  5390: 8a4701           mov al, byte ptr [bx + 1]
  050DE3  5393: 2ae4             sub ah, ah
  050DE5  5395: 50               push ax
  050DE6  5396: 8a07             mov al, byte ptr [bx]
  050DE8  5398: 50               push ax
  050DE9  5399: 9a22071f18       lcall 0x181f, 0x722
  050DEE  539E: 83c404           add sp, 4
  050DF1  53A1: 3b46ca           cmp ax, word ptr [bp - 0x36]
  050DF4  53A4: 752a             jne 0x53d0
  050DF6  53A6: 8b1e4285         mov bx, word ptr [0x8542]
  050DFA  53AA: 80671bfb         and byte ptr [bx + 0x1b], 0xfb
  050DFE  53AE: 807f1e00         cmp byte ptr [bx + 0x1e], 0
  050E02  53B2: 7403             je 0x53b7
  050E04  53B4: fe4f1e           dec byte ptr [bx + 0x1e]
  050E07  53B7: 8b1e4285         mov bx, word ptr [0x8542]
  050E0B  53BB: 8a4701           mov al, byte ptr [bx + 1]
  050E0E  53BE: 2ae4             sub ah, ah
  050E10  53C0: 50               push ax
  050E11  53C1: 8a1f             mov bl, byte ptr [bx]
  050E13  53C3: 2aff             sub bh, bh
  050E15  53C5: 8b4606           mov ax, word ptr [bp + 6]
  050E18  53C8: ba5700           mov dx, 0x57
  050E1B  53CB: e9c7db           jmp 0x2f95
  050E1E  53CE: 90               nop 
  050E1F  53CF: 90               nop 
  050E20  53D0: 83be54ff00       cmp word ptr [bp - 0xac], 0
  050E25  53D5: 7411             je 0x53e8
  050E27  53D7: 6a00             push 0
  050E29  53D9: 6a00             push 0
  050E2B  53DB: 6a00             push 0
  050E2D  53DD: 68a617           push 0x17a6
  050E30  53E0: 9a7e071f18       lcall 0x181f, 0x77e
  050E35  53E5: 83c408           add sp, 8
  050E38  53E8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050E3C  53EC: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  050E41  53F1: 7403             je 0x53f6
  050E43  53F3: e98200           jmp 0x5478
  050E46  53F6: 837e9800         cmp word ptr [bp - 0x68], 0
  050E4A  53FA: 757c             jne 0x5478
  050E4C  53FC: c746f80100       mov word ptr [bp - 8], 1
  050E51  5401: 83be56ff00       cmp word ptr [bp - 0xaa], 0
  050E56  5406: 7c2c             jl 0x5434
  050E58  5408: ffb656ff         push word ptr [bp - 0xaa]
  050E5C  540C: 9a4c0a1f18       lcall 0x181f, 0xa4c
  050E61  5411: 83c402           add sp, 2
  050E64  5414: ff36528d         push word ptr [0x8d52]
  050E68  5418: 9a560a1f18       lcall 0x181f, 0xa56
  050E6D  541D: 83c402           add sp, 2
  050E70  5420: 894686           mov word ptr [bp - 0x7a], ax
  050E73  5423: 3b8662ff         cmp ax, word ptr [bp - 0x9e]
  050E77  5427: 7c0b             jl 0x5434
  050E79  5429: 837eae03         cmp word ptr [bp - 0x52], 3
  050E7D  542D: 7d05             jge 0x5434
  050E7F  542F: c746f80000       mov word ptr [bp - 8], 0
  050E84  5434: 83be1eff00       cmp word ptr [bp - 0xe2], 0
  050E89  5439: 7c24             jl 0x545f
  050E8B  543B: ffb61eff         push word ptr [bp - 0xe2]
  050E8F  543F: 9ae6091f18       lcall 0x181f, 0x9e6
  050E94  5444: 83c402           add sp, 2
  050E97  5447: 8a861cff         mov al, byte ptr [bp - 0xe4]
  050E9B  544B: 8b1e4285         mov bx, word ptr [0x8542]
  050E9F  544F: 38471a           cmp byte ptr [bx + 0x1a], al
  050EA2  5452: 740b             je 0x545f
  050EA4  5454: 837e8e03         cmp word ptr [bp - 0x72], 3
  050EA8  5458: 7d05             jge 0x545f
  050EAA  545A: c746f80000       mov word ptr [bp - 8], 0
  050EAF  545F: 837ef800         cmp word ptr [bp - 8], 0
  050EB3  5463: 7413             je 0x5478
  050EB5  5465: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050EB9  5469: c6874c3109       mov byte ptr [bx + 0x314c], 9
  050EBE  546E: c6874b3152       mov byte ptr [bx + 0x314b], 0x52
  050EC3  5473: e9a20d           jmp 0x6218
  050EC6  5476: 90               nop 
  050EC7  5477: 90               nop 
  050EC8  5478: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050ECC  547C: 80bf4c3100       cmp byte ptr [bx + 0x314c], 0
  050ED1  5481: 744b             je 0x54ce
  050ED3  5483: 80bf4c310a       cmp byte ptr [bx + 0x314c], 0xa
  050ED8  5488: 7444             je 0x54ce
  050EDA  548A: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  050EDF  548F: 743d             je 0x54ce
  050EE1  5491: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  050EE6  5496: 7436             je 0x54ce
  050EE8  5498: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  050EED  549D: 7514             jne 0x54b3
  050EEF  549F: 8a867aff         mov al, byte ptr [bp - 0x86]
  050EF3  54A3: 38874d31         cmp byte ptr [bx + 0x314d], al
  050EF7  54A7: 750a             jne 0x54b3
  050EF9  54A9: 8a866eff         mov al, byte ptr [bp - 0x92]
  050EFD  54AD: 38874e31         cmp byte ptr [bx + 0x314e], al
  050F01  54B1: 741b             je 0x54ce
  050F03  54B3: ffb61cff         push word ptr [bp - 0xe4]
  050F07  54B7: ffb66eff         push word ptr [bp - 0x92]
  050F0B  54BB: ffb67aff         push word ptr [bp - 0x86]
  050F0F  54BF: 9a84091f18       lcall 0x181f, 0x984
  050F14  54C4: 83c406           add sp, 6
  050F17  54C7: 0bc0             or ax, ax
  050F19  54C9: 7503             jne 0x54ce
  050F1B  54CB: e94a0d           jmp 0x6218
  050F1E  54CE: 83be54ff00       cmp word ptr [bp - 0xac], 0
  050F23  54D3: 7411             je 0x54e6
  050F25  54D5: 6a00             push 0
  050F27  54D7: 6a00             push 0
  050F29  54D9: 6a00             push 0
  050F2B  54DB: 68ab17           push 0x17ab
  050F2E  54DE: 9a7e071f18       lcall 0x181f, 0x77e
  050F33  54E3: 83c408           add sp, 8
  050F36  54E6: c78616ff0000     mov word ptr [bp - 0xea], 0
  050F3C  54EC: 6a01             push 1
  050F3E  54EE: ffb61cff         push word ptr [bp - 0xe4]
  050F42  54F2: ffb66eff         push word ptr [bp - 0x92]
  050F46  54F6: ffb67aff         push word ptr [bp - 0x86]
  050F4A  54FA: 0e               push cs
  050F4B  54FB: e87825           call 0x7a76
  050F4E  54FE: 83c408           add sp, 8
  050F51  5501: 0bc0             or ax, ax
  050F53  5503: 7c2f             jl 0x5534
  050F55  5505: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050F59  5509: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  050F5E  550E: 7207             jb 0x5517
  050F60  5510: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  050F65  5515: 7623             jbe 0x553a
  050F67  5517: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050F6B  551B: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  050F6F  551F: 2aff             sub bh, bh
  050F71  5521: 8bc3             mov ax, bx
  050F73  5523: d1e3             shl bx, 1
  050F75  5525: 03d8             add bx, ax
  050F77  5527: d1e3             shl bx, 1
  050F79  5529: 03d8             add bx, ax
  050F7B  552B: d1e3             shl bx, 1
  050F7D  552D: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  050F82  5532: 7506             jne 0x553a
  050F84  5534: c78616ff0100     mov word ptr [bp - 0xea], 1
  050F8A  553A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050F8E  553E: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  050F93  5543: 7214             jb 0x5559
  050F95  5545: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  050F9A  554A: 770d             ja 0x5559
  050F9C  554C: f606825301       test byte ptr [0x5382], 1
  050FA1  5551: 7406             je 0x5559
  050FA3  5553: c78616ff0000     mov word ptr [bp - 0xea], 0
  050FA9  5559: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  050FAD  555D: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  050FB2  5562: 7303             jae 0x5567
  050FB4  5564: e9e200           jmp 0x5649
  050FB7  5567: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  050FBC  556C: 7603             jbe 0x5571
  050FBE  556E: e9d800           jmp 0x5649
  050FC1  5571: 83be16ff00       cmp word ptr [bp - 0xea], 0
  050FC6  5576: 7503             jne 0x557b
  050FC8  5578: e9ce00           jmp 0x5649
  050FCB  557B: 8b46ba           mov ax, word ptr [bp - 0x46]
  050FCE  557E: 0346b8           add ax, word ptr [bp - 0x48]
  050FD1  5581: 7503             jne 0x5586
  050FD3  5583: e9c300           jmp 0x5649
  050FD6  5586: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  050FDB  558B: 7403             je 0x5590
  050FDD  558D: e9b900           jmp 0x5649
  050FE0  5590: f606825301       test byte ptr [0x5382], 1
  050FE5  5595: 7403             je 0x559a
  050FE7  5597: e9af00           jmp 0x5649
  050FEA  559A: f687483110       test byte ptr [bx + 0x3148], 0x10
  050FEF  559F: 7403             je 0x55a4
  050FF1  55A1: e98c00           jmp 0x5630
  050FF4  55A4: 6a10             push 0x10
  050FF6  55A6: 6a00             push 0
  050FF8  55A8: 8bf3             mov si, bx
  050FFA  55AA: 9ad4041f18       lcall 0x181f, 0x4d4
  050FFF  55AF: 83c404           add sp, 4
  051002  55B2: 0bc0             or ax, ax
  051004  55B4: 7403             je 0x55b9
  051006  55B6: e99000           jmp 0x5649
  051009  55B9: a13a85           mov ax, word ptr [0x853a]
  05100C  55BC: 2d0300           sub ax, 3
  05100F  55BF: 50               push ax
  051010  55C0: 6a02             push 2
  051012  55C2: 9ad4041f18       lcall 0x181f, 0x4d4
  051017  55C7: 83c404           add sp, 4
  05101A  55CA: 8946ea           mov word ptr [bp - 0x16], ax
  05101D  55CD: a13c85           mov ax, word ptr [0x853c]
  051020  55D0: 2d0300           sub ax, 3
  051023  55D3: 50               push ax
  051024  55D4: 6a02             push 2
  051026  55D6: 9ad4041f18       lcall 0x181f, 0x4d4
  05102B  55DB: 83c404           add sp, 4
  05102E  55DE: 8946e6           mov word ptr [bp - 0x1a], ax
  051031  55E1: 50               push ax
  051032  55E2: ff76ea           push word ptr [bp - 0x16]
  051035  55E5: 9a68071f18       lcall 0x181f, 0x768
  05103A  55EA: 83c404           add sp, 4
  05103D  55ED: 0bc0             or ax, ax
  05103F  55EF: 7458             je 0x5649
  051041  55F1: ff76e6           push word ptr [bp - 0x1a]
  051044  55F4: ff76ea           push word ptr [bp - 0x16]
  051047  55F7: 9ab4061f18       lcall 0x181f, 0x6b4
  05104C  55FC: 83c404           add sp, 4
  05104F  55FF: fec8             dec al
  051051  5601: 7546             jne 0x5649
  051053  5603: ff76e6           push word ptr [bp - 0x1a]
  051056  5606: ff76ea           push word ptr [bp - 0x16]
  051059  5609: ffb66eff         push word ptr [bp - 0x92]
  05105D  560D: ffb67aff         push word ptr [bp - 0x86]
  051061  5611: 9a7a031f18       lcall 0x181f, 0x37a
  051066  5616: 83c408           add sp, 8
  051069  5619: 3d0800           cmp ax, 8
  05106C  561C: 7c2b             jl 0x5649
  05106E  561E: 808c483110       or byte ptr [si + 0x3148], 0x10
  051073  5623: ff76e6           push word ptr [bp - 0x1a]
  051076  5626: 8b4606           mov ax, word ptr [bp + 6]
  051079  5629: ba4400           mov dx, 0x44
  05107C  562C: e9dcfc           jmp 0x530b
  05107F  562F: 90               nop 
  051080  5630: 6a30             push 0x30
  051082  5632: 6a00             push 0
  051084  5634: 9ad4041f18       lcall 0x181f, 0x4d4
  051089  5639: 83c404           add sp, 4
  05108C  563C: 0bc0             or ax, ax
  05108E  563E: 7509             jne 0x5649
  051090  5640: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051094  5644: 80a74831ef       and byte ptr [bx + 0x3148], 0xef
  051099  5649: 83be54ff00       cmp word ptr [bp - 0xac], 0
  05109E  564E: 7411             je 0x5661
  0510A0  5650: 6a00             push 0
  0510A2  5652: 6a00             push 0
  0510A4  5654: 6a00             push 0
  0510A6  5656: 68b017           push 0x17b0
  0510A9  5659: 9a7e071f18       lcall 0x181f, 0x77e
  0510AE  565E: 83c408           add sp, 8
  0510B1  5661: c78620ff19fc     mov word ptr [bp - 0xe0], 0xfc19
  0510B7  5667: c7468c0800       mov word ptr [bp - 0x74], 8
  0510BC  566C: c746b20000       mov word ptr [bp - 0x4e], 0
  0510C1  5671: e9b202           jmp 0x5926
  0510C4  5674: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0510C8  5678: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  0510CD  567D: 7569             jne 0x56e8
  0510CF  567F: 6a08             push 8
  0510D1  5681: 6a01             push 1
  0510D3  5683: 9ad4041f18       lcall 0x181f, 0x4d4
  0510D8  5688: 83c404           add sp, 4
  0510DB  568B: 8946da           mov word ptr [bp - 0x26], ax
  0510DE  568E: 83be7eff00       cmp word ptr [bp - 0x82], 0
  0510E3  5693: 741f             je 0x56b4
  0510E5  5695: ff76e6           push word ptr [bp - 0x1a]
  0510E8  5698: ff76ea           push word ptr [bp - 0x16]
  0510EB  569B: 9a2c071f18       lcall 0x181f, 0x72c
  0510F0  56A0: 83c404           add sp, 4
  0510F3  56A3: a840             test al, 0x40
  0510F5  56A5: 740d             je 0x56b4
  0510F7  56A7: f646b201         test byte ptr [bp - 0x4e], 1
  0510FB  56AB: 7507             jne 0x56b4
  0510FD  56AD: 8346da02         add word ptr [bp - 0x26], 2
  051101  56B1: e95c01           jmp 0x5810
  051104  56B4: 837ea800         cmp word ptr [bp - 0x58], 0
  051108  56B8: 7415             je 0x56cf
  05110A  56BA: ff76e6           push word ptr [bp - 0x1a]
  05110D  56BD: ff76ea           push word ptr [bp - 0x16]
  051110  56C0: 9a54071f18       lcall 0x181f, 0x754
  051115  56C5: 83c404           add sp, 4
  051118  56C8: a80a             test al, 0xa
  05111A  56CA: 7403             je 0x56cf
  05111C  56CC: e9cb00           jmp 0x579a
  05111F  56CF: 8b5ec8           mov bx, word ptr [bp - 0x38]
  051122  56D2: c1e304           shl bx, 4
  051125  56D5: 8a87762f         mov al, byte ptr [bx + 0x2f76]
  051129  56D9: 2ae4             sub ah, ah
  05112B  56DB: 8bc8             mov cx, ax
  05112D  56DD: d1e0             shl ax, 1
  05112F  56DF: 03c1             add ax, cx
  051131  56E1: 2946da           sub word ptr [bp - 0x26], ax
  051134  56E4: e92901           jmp 0x5810
  051137  56E7: 90               nop 
  051138  56E8: 837e9800         cmp word ptr [bp - 0x68], 0
  05113C  56EC: 742a             je 0x5718
  05113E  56EE: 6a04             push 4
  051140  56F0: 6a01             push 1
  051142  56F2: 9ad4041f18       lcall 0x181f, 0x4d4
  051147  56F7: 83c404           add sp, 4
  05114A  56FA: ff76e6           push word ptr [bp - 0x1a]
  05114D  56FD: ff76ea           push word ptr [bp - 0x16]
  051150  5700: 8bf0             mov si, ax
  051152  5702: 9a4a071f18       lcall 0x181f, 0x74a
  051157  5707: 83c404           add sp, 4
  05115A  570A: 250f00           and ax, 0xf
  05115D  570D: 03f0             add si, ax
  05115F  570F: d1fe             sar si, 1
  051161  5711: 8976da           mov word ptr [bp - 0x26], si
  051164  5714: e9f900           jmp 0x5810
  051167  5717: 90               nop 
  051168  5718: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05116C  571C: 8a874731         mov al, byte ptr [bx + 0x3147]
  051170  5720: 2ae4             sub ah, ah
  051172  5722: a9f0ff           test ax, 0xfff0
  051175  5725: 7403             je 0x572a
  051177  5727: e9b600           jmp 0x57e0
  05117A  572A: 83be72ff00       cmp word ptr [bp - 0x8e], 0
  05117F  572F: 7403             je 0x5734
  051181  5731: e9ac00           jmp 0x57e0
  051184  5734: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  051188  5738: 2aff             sub bh, bh
  05118A  573A: 8bc3             mov ax, bx
  05118C  573C: d1e3             shl bx, 1
  05118E  573E: 03d8             add bx, ax
  051190  5740: d1e3             shl bx, 1
  051192  5742: 03d8             add bx, ax
  051194  5744: d1e3             shl bx, 1
  051196  5746: f6873d5220       test byte ptr [bx + 0x523d], 0x20
  05119B  574B: 7507             jne 0x5754
  05119D  574D: f6873d5210       test byte ptr [bx + 0x523d], 0x10
  0511A2  5752: 745c             je 0x57b0
  0511A4  5754: 6a03             push 3
  0511A6  5756: 6a01             push 1
  0511A8  5758: 9ad4041f18       lcall 0x181f, 0x4d4
  0511AD  575D: 83c404           add sp, 4
  0511B0  5760: 8946da           mov word ptr [bp - 0x26], ax
  0511B3  5763: 83be7eff00       cmp word ptr [bp - 0x82], 0
  0511B8  5768: 7418             je 0x5782
  0511BA  576A: ff76e6           push word ptr [bp - 0x1a]
  0511BD  576D: ff76ea           push word ptr [bp - 0x16]
  0511C0  5770: 9a2c071f18       lcall 0x181f, 0x72c
  0511C5  5775: 83c404           add sp, 4
  0511C8  5778: a840             test al, 0x40
  0511CA  577A: 7406             je 0x5782
  0511CC  577C: f646b201         test byte ptr [bp - 0x4e], 1
  0511D0  5780: 7418             je 0x579a
  0511D2  5782: 837ea800         cmp word ptr [bp - 0x58], 0
  0511D6  5786: 7418             je 0x57a0
  0511D8  5788: ff76e6           push word ptr [bp - 0x1a]
  0511DB  578B: ff76ea           push word ptr [bp - 0x16]
  0511DE  578E: 9a54071f18       lcall 0x181f, 0x754
  0511E3  5793: 83c404           add sp, 4
  0511E6  5796: a80a             test al, 0xa
  0511E8  5798: 7406             je 0x57a0
  0511EA  579A: ff46da           inc word ptr [bp - 0x26]
  0511ED  579D: eb71             jmp 0x5810
  0511EF  579F: 90               nop 
  0511F0  57A0: 8b5ec8           mov bx, word ptr [bp - 0x38]
  0511F3  57A3: c1e304           shl bx, 4
  0511F6  57A6: 8a87762f         mov al, byte ptr [bx + 0x2f76]
  0511FA  57AA: 2ae4             sub ah, ah
  0511FC  57AC: e932ff           jmp 0x56e1
  0511FF  57AF: 90               nop 
  051200  57B0: 6a03             push 3
  051202  57B2: 6a01             push 1
  051204  57B4: 9ad4041f18       lcall 0x181f, 0x4d4
  051209  57B9: 83c404           add sp, 4
  05120C  57BC: 8946da           mov word ptr [bp - 0x26], ax
  05120F  57BF: f606825301       test byte ptr [0x5382], 1
  051214  57C4: 740c             je 0x57d2
  051216  57C6: 8b5ec8           mov bx, word ptr [bp - 0x38]
  051219  57C9: c1e304           shl bx, 4
  05121C  57CC: 8a87772f         mov al, byte ptr [bx + 0x2f77]
  051220  57D0: ebd8             jmp 0x57aa
  051222  57D2: 8b5ec8           mov bx, word ptr [bp - 0x38]
  051225  57D5: c1e304           shl bx, 4
  051228  57D8: 8a87772f         mov al, byte ptr [bx + 0x2f77]
  05122C  57DC: 2ae4             sub ah, ah
  05122E  57DE: eb2d             jmp 0x580d
  051230  57E0: 6a05             push 5
  051232  57E2: 6a01             push 1
  051234  57E4: 9ad4041f18       lcall 0x181f, 0x4d4
  051239  57E9: 83c404           add sp, 4
  05123C  57EC: 8946da           mov word ptr [bp - 0x26], ax
  05123F  57EF: 837ea600         cmp word ptr [bp - 0x5a], 0
  051243  57F3: 7c09             jl 0x57fe
  051245  57F5: 8b861cff         mov ax, word ptr [bp - 0xe4]
  051249  57F9: 3946f2           cmp word ptr [bp - 0xe], ax
  05124C  57FC: 7412             je 0x5810
  05124E  57FE: 8b5ec8           mov bx, word ptr [bp - 0x38]
  051251  5801: c1e304           shl bx, 4
  051254  5804: 8a87772f         mov al, byte ptr [bx + 0x2f77]
  051258  5808: 2ae4             sub ah, ah
  05125A  580A: c1e002           shl ax, 2
  05125D  580D: 0146da           add word ptr [bp - 0x26], ax
  051260  5810: 837ec81a         cmp word ptr [bp - 0x38], 0x1a
  051264  5814: 7504             jne 0x581a
  051266  5816: 836eda10         sub word ptr [bp - 0x26], 0x10
  05126A  581A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05126E  581E: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  051273  5823: 7207             jb 0x582c
  051275  5825: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05127A  582A: 7670             jbe 0x589c
  05127C  582C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051280  5830: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  051284  5834: 2aff             sub bh, bh
  051286  5836: 8bc3             mov ax, bx
  051288  5838: d1e3             shl bx, 1
  05128A  583A: 03d8             add bx, ax
  05128C  583C: d1e3             shl bx, 1
  05128E  583E: 03d8             add bx, ax
  051290  5840: d1e3             shl bx, 1
  051292  5842: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  051297  5847: 7653             jbe 0x589c
  051299  5849: ff76e6           push word ptr [bp - 0x1a]
  05129C  584C: ff76ea           push word ptr [bp - 0x16]
  05129F  584F: 9a96061f18       lcall 0x181f, 0x696
  0512A4  5854: 83c404           add sp, 4
  0512A7  5857: 0bc0             or ax, ax
  0512A9  5859: 7c41             jl 0x589c
  0512AB  585B: 8b861cff         mov ax, word ptr [bp - 0xe4]
  0512AF  585F: 3946f2           cmp word ptr [bp - 0xe], ax
  0512B2  5862: 7534             jne 0x5898
  0512B4  5864: ff76a0           push word ptr [bp - 0x60]
  0512B7  5867: 9ae6091f18       lcall 0x181f, 0x9e6
  0512BC  586C: 83c402           add sp, 2
  0512BF  586F: 8b1e4285         mov bx, word ptr [0x8542]
  0512C3  5873: f6471b40         test byte ptr [bx + 0x1b], 0x40
  0512C7  5877: 7407             je 0x5880
  0512C9  5879: 8346da0a         add word ptr [bp - 0x26], 0xa
  0512CD  587D: eb1d             jmp 0x589c
  0512CF  587F: 90               nop 
  0512D0  5880: f6471b04         test byte ptr [bx + 0x1b], 4
  0512D4  5884: 7406             je 0x588c
  0512D6  5886: 8346da06         add word ptr [bp - 0x26], 6
  0512DA  588A: eb10             jmp 0x589c
  0512DC  588C: f6471b10         test byte ptr [bx + 0x1b], 0x10
  0512E0  5890: 740a             je 0x589c
  0512E2  5892: 8346da03         add word ptr [bp - 0x26], 3
  0512E6  5896: eb04             jmp 0x589c
  0512E8  5898: 8346da10         add word ptr [bp - 0x26], 0x10
  0512EC  589C: c746840000       mov word ptr [bp - 0x7c], 0
  0512F1  58A1: 837ea600         cmp word ptr [bp - 0x5a], 0
  0512F5  58A5: 7d15             jge 0x58bc
  0512F7  58A7: ff76e6           push word ptr [bp - 0x1a]
  0512FA  58AA: ff76ea           push word ptr [bp - 0x16]
  0512FD  58AD: 9ad2061f18       lcall 0x181f, 0x6d2
  051302  58B2: 83c404           add sp, 4
  051305  58B5: 0bc0             or ax, ax
  051307  58B7: 7d03             jge 0x58bc
  051309  58B9: e9d903           jmp 0x5c95
  05130C  58BC: 8b861cff         mov ax, word ptr [bp - 0xe4]
  051310  58C0: 3946f2           cmp word ptr [bp - 0xe], ax
  051313  58C3: 7503             jne 0x58c8
  051315  58C5: e9cd03           jmp 0x5c95
  051318  58C8: 837ef204         cmp word ptr [bp - 0xe], 4
  05131C  58CC: 7d03             jge 0x58d1
  05131E  58CE: e92f01           jmp 0x5a00
  051321  58D1: 50               push ax
  051322  58D2: 8b4ef2           mov cx, word ptr [bp - 0xe]
  051325  58D5: 83e904           sub cx, 4
  051328  58D8: 51               push cx
  051329  58D9: 9a0c031f18       lcall 0x181f, 0x30c
  05132E  58DE: 83c404           add sp, 4
  051331  58E1: 3d4b00           cmp ax, 0x4b
  051334  58E4: 7d13             jge 0x58f9
  051336  58E6: ff76f2           push word ptr [bp - 0xe]
  051339  58E9: ffb61cff         push word ptr [bp - 0xe4]
  05133D  58ED: 9a380a1f18       lcall 0x181f, 0xa38
  051342  58F2: 83c404           add sp, 4
  051345  58F5: a802             test al, 2
  051347  58F7: 742a             je 0x5923
  051349  58F9: ff76f2           push word ptr [bp - 0xe]
  05134C  58FC: ffb61cff         push word ptr [bp - 0xe4]
  051350  5900: 9a380a1f18       lcall 0x181f, 0xa38
  051355  5905: 83c404           add sp, 4
  051358  5908: a802             test al, 2
  05135A  590A: 7403             je 0x590f
  05135C  590C: d166da           shl word ptr [bp - 0x26], 1
  05135F  590F: 8bb61cff         mov si, word ptr [bp - 0xe4]
  051363  5913: c1e604           shl si, 4
  051366  5916: 8b5eca           mov bx, word ptr [bp - 0x36]
  051369  5919: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  05136E  591E: 7403             je 0x5923
  051370  5920: e92701           jmp 0x5a4a
  051373  5923: ff46b2           inc word ptr [bp - 0x4e]
  051376  5926: 837eb208         cmp word ptr [bp - 0x4e], 8
  05137A  592A: 7c03             jl 0x592f
  05137C  592C: e99906           jmp 0x5fc8
  05137F  592F: 8b5eb2           mov bx, word ptr [bp - 0x4e]
  051382  5932: 8a87be00         mov al, byte ptr [bx + 0xbe]
  051386  5936: 98               cwde 
  051387  5937: 03866eff         add ax, word ptr [bp - 0x92]
  05138B  593B: 8946e6           mov word ptr [bp - 0x1a], ax
  05138E  593E: 50               push ax
  05138F  593F: 8a87b400         mov al, byte ptr [bx + 0xb4]
  051393  5943: 98               cwde 
  051394  5944: 03867aff         add ax, word ptr [bp - 0x86]
  051398  5948: 8946ea           mov word ptr [bp - 0x16], ax
  05139B  594B: 50               push ax
  05139C  594C: 9a02031f18       lcall 0x181f, 0x302
  0513A1  5951: 83c404           add sp, 4
  0513A4  5954: 0bc0             or ax, ax
  0513A6  5956: 74cb             je 0x5923
  0513A8  5958: ff76e6           push word ptr [bp - 0x1a]
  0513AB  595B: ff76ea           push word ptr [bp - 0x16]
  0513AE  595E: 9a8c071f18       lcall 0x181f, 0x78c
  0513B3  5963: 83c404           add sp, 4
  0513B6  5966: 8946c8           mov word ptr [bp - 0x38], ax
  0513B9  5969: 3d1900           cmp ax, 0x19
  0513BC  596C: 7405             je 0x5973
  0513BE  596E: 3d1a00           cmp ax, 0x1a
  0513C1  5971: 7518             jne 0x598b
  0513C3  5973: 837ece00         cmp word ptr [bp - 0x32], 0
  0513C7  5977: 74aa             je 0x5923
  0513C9  5979: ff76e6           push word ptr [bp - 0x1a]
  0513CC  597C: ff76ea           push word ptr [bp - 0x16]
  0513CF  597F: 9ab4061f18       lcall 0x181f, 0x6b4
  0513D4  5984: 83c404           add sp, 4
  0513D7  5987: fec8             dec al
  0513D9  5989: 7598             jne 0x5923
  0513DB  598B: ff76e6           push word ptr [bp - 0x1a]
  0513DE  598E: ff76ea           push word ptr [bp - 0x16]
  0513E1  5991: 9adc061f18       lcall 0x181f, 0x6dc
  0513E6  5996: 83c404           add sp, 4
  0513E9  5999: 98               cwde 
  0513EA  599A: 8946f2           mov word ptr [bp - 0xe], ax
  0513ED  599D: 8b46ea           mov ax, word ptr [bp - 0x16]
  0513F0  59A0: 8b56e6           mov dx, word ptr [bp - 0x1a]
  0513F3  59A3: 9ae0071f18       lcall 0x181f, 0x7e0
  0513F8  59A8: 8946a6           mov word ptr [bp - 0x5a], ax
  0513FB  59AB: 83be72ff00       cmp word ptr [bp - 0x8e], 0
  051400  59B0: 7416             je 0x59c8
  051402  59B2: 837ece00         cmp word ptr [bp - 0x32], 0
  051406  59B6: 7510             jne 0x59c8
  051408  59B8: 0bc0             or ax, ax
  05140A  59BA: 7c0c             jl 0x59c8
  05140C  59BC: 8b861cff         mov ax, word ptr [bp - 0xe4]
  051410  59C0: 3946f2           cmp word ptr [bp - 0xe], ax
  051413  59C3: 7403             je 0x59c8
  051415  59C5: e95bff           jmp 0x5923
  051418  59C8: 837ece00         cmp word ptr [bp - 0x32], 0
  05141C  59CC: 7503             jne 0x59d1
  05141E  59CE: e9a3fc           jmp 0x5674
  051421  59D1: 837ec819         cmp word ptr [bp - 0x38], 0x19
  051425  59D5: 7503             jne 0x59da
  051427  59D7: e99afc           jmp 0x5674
  05142A  59DA: 837ec81a         cmp word ptr [bp - 0x38], 0x1a
  05142E  59DE: 7503             jne 0x59e3
  051430  59E0: e991fc           jmp 0x5674
  051433  59E3: ff76e6           push word ptr [bp - 0x1a]
  051436  59E6: ff76ea           push word ptr [bp - 0x16]
  051439  59E9: 9a96061f18       lcall 0x181f, 0x696
  05143E  59EE: 83c404           add sp, 4
  051441  59F1: 0bc0             or ax, ax
  051443  59F3: 7d03             jge 0x59f8
  051445  59F5: e92bff           jmp 0x5923
  051448  59F8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05144C  59FC: e924ff           jmp 0x5923
  05144F  59FF: 90               nop 
  051450  5A00: ff76f2           push word ptr [bp - 0xe]
  051453  5A03: 50               push ax
  051454  5A04: 9a380a1f18       lcall 0x181f, 0xa38
  051459  5A09: 83c404           add sp, 4
  05145C  5A0C: a840             test al, 0x40
  05145E  5A0E: 7419             je 0x5a29
  051460  5A10: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051464  5A14: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  051469  5A19: 740e             je 0x5a29
  05146B  5A1B: 6b5ea61c         imul bx, word ptr [bp - 0x5a], 0x1c
  05146F  5A1F: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  051474  5A24: 7403             je 0x5a29
  051476  5A26: e9fafe           jmp 0x5923
  051479  5A29: f606825301       test byte ptr [0x5382], 1
  05147E  5A2E: 741a             je 0x5a4a
  051480  5A30: 837ef204         cmp word ptr [bp - 0xe], 4
  051484  5A34: 7d0b             jge 0x5a41
  051486  5A36: 6b5ef234         imul bx, word ptr [bp - 0xe], 0x34
  05148A  5A3A: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05148F  5A3F: 7409             je 0x5a4a
  051491  5A41: 837ef204         cmp word ptr [bp - 0xe], 4
  051495  5A45: 7d03             jge 0x5a4a
  051497  5A47: e9d9fe           jmp 0x5923
  05149A  5A4A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05149E  5A4E: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0514A2  5A52: 2aff             sub bh, bh
  0514A4  5A54: 8bc3             mov ax, bx
  0514A6  5A56: d1e3             shl bx, 1
  0514A8  5A58: 03d8             add bx, ax
  0514AA  5A5A: d1e3             shl bx, 1
  0514AC  5A5C: 03d8             add bx, ax
  0514AE  5A5E: d1e3             shl bx, 1
  0514B0  5A60: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  0514B5  5A65: 7503             jne 0x5a6a
  0514B7  5A67: e9b9fe           jmp 0x5923
  0514BA  5A6A: b80100           mov ax, 1
  0514BD  5A6D: 894684           mov word ptr [bp - 0x7c], ax
  0514C0  5A70: 898618ff         mov word ptr [bp - 0xe8], ax
  0514C4  5A74: 6a00             push 0
  0514C6  5A76: 6a00             push 0
  0514C8  5A78: ff76e6           push word ptr [bp - 0x1a]
  0514CB  5A7B: ff76ea           push word ptr [bp - 0x16]
  0514CE  5A7E: ff7606           push word ptr [bp + 6]
  0514D1  5A81: 9a140a1f19       lcall 0x191f, 0xa14
  0514D6  5A86: 83c40a           add sp, 0xa
  0514D9  5A89: 89861aff         mov word ptr [bp - 0xe6], ax
  0514DD  5A8D: 6a02             push 2
  0514DF  5A8F: ff76a6           push word ptr [bp - 0x5a]
  0514E2  5A92: 9abc081f18       lcall 0x181f, 0x8bc
  0514E7  5A97: 83c404           add sp, 4
  0514EA  5A9A: 3d0100           cmp ax, 1
  0514ED  5A9D: 7d05             jge 0x5aa4
  0514EF  5A9F: b80100           mov ax, 1
  0514F2  5AA2: eb0d             jmp 0x5ab1
  0514F4  5AA4: 6a02             push 2
  0514F6  5AA6: ff76a6           push word ptr [bp - 0x5a]
  0514F9  5AA9: 9abc081f18       lcall 0x181f, 0x8bc
  0514FE  5AAE: 83c404           add sp, 4
  051501  5AB1: 898612ff         mov word ptr [bp - 0xee], ax
  051505  5AB5: 6a00             push 0
  051507  5AB7: ff76a6           push word ptr [bp - 0x5a]
  05150A  5ABA: 9abc081f18       lcall 0x181f, 0x8bc
  05150F  5ABF: 83c404           add sp, 4
  051512  5AC2: 40               inc ax
  051513  5AC3: 99               cdq 
  051514  5AC4: f7be12ff         idiv word ptr [bp - 0xee]
  051518  5AC8: f7ae1aff         imul word ptr [bp - 0xe6]
  05151C  5ACC: 89861aff         mov word ptr [bp - 0xe6], ax
  051520  5AD0: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051524  5AD4: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  051528  5AD8: 2aff             sub bh, bh
  05152A  5ADA: 8bc3             mov ax, bx
  05152C  5ADC: d1e3             shl bx, 1
  05152E  5ADE: 03d8             add bx, ax
  051530  5AE0: d1e3             shl bx, 1
  051532  5AE2: 03d8             add bx, ax
  051534  5AE4: d1e3             shl bx, 1
  051536  5AE6: 8a8f3952         mov cl, byte ptr [bx + 0x5239]
  05153A  5AEA: 80e901           sub cl, 1
  05153D  5AED: 1ac0             sbb al, al
  05153F  5AEF: f6d0             not al
  051541  5AF1: 22c8             and cl, al
  051543  5AF3: 80c101           add cl, 1
  051546  5AF6: 2aed             sub ch, ch
  051548  5AF8: 8b861aff         mov ax, word ptr [bp - 0xe6]
  05154C  5AFC: 99               cdq 
  05154D  5AFD: f7f9             idiv cx
  05154F  5AFF: 89861aff         mov word ptr [bp - 0xe6], ax
  051553  5B03: c746fe0000       mov word ptr [bp - 2], 0
  051558  5B08: ff76e6           push word ptr [bp - 0x1a]
  05155B  5B0B: ff76ea           push word ptr [bp - 0x16]
  05155E  5B0E: 9a96061f18       lcall 0x181f, 0x696
  051563  5B13: 83c404           add sp, 4
  051566  5B16: 0bc0             or ax, ax
  051568  5B18: 7c10             jl 0x5b2a
  05156A  5B1A: b80300           mov ax, 3
  05156D  5B1D: f7ae1aff         imul word ptr [bp - 0xe6]
  051571  5B21: 89861aff         mov word ptr [bp - 0xe6], ax
  051575  5B25: c746fe0100       mov word ptr [bp - 2], 1
  05157A  5B2A: ff76e6           push word ptr [bp - 0x1a]
  05157D  5B2D: ff76ea           push word ptr [bp - 0x16]
  051580  5B30: 9af0061f18       lcall 0x181f, 0x6f0
  051585  5B35: 83c404           add sp, 4
  051588  5B38: 0bc0             or ax, ax
  05158A  5B3A: 7c09             jl 0x5b45
  05158C  5B3C: d1a61aff         shl word ptr [bp - 0xe6], 1
  051590  5B40: c746fe0100       mov word ptr [bp - 2], 1
  051595  5B45: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051599  5B49: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  05159E  5B4E: 750c             jne 0x5b5c
  0515A0  5B50: 837efe00         cmp word ptr [bp - 2], 0
  0515A4  5B54: 7506             jne 0x5b5c
  0515A6  5B56: c7861aff0000     mov word ptr [bp - 0xe6], 0
  0515AC  5B5C: a1d253           mov ax, word ptr [0x53d2]
  0515AF  5B5F: 39861cff         cmp word ptr [bp - 0xe4], ax
  0515B3  5B63: 7510             jne 0x5b75
  0515B5  5B65: 837efe00         cmp word ptr [bp - 2], 0
  0515B9  5B69: 750a             jne 0x5b75
  0515BB  5B6B: 837ed400         cmp word ptr [bp - 0x2c], 0
  0515BF  5B6F: 7504             jne 0x5b75
  0515C1  5B71: d1be1aff         sar word ptr [bp - 0xe6], 1
  0515C5  5B75: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0515C9  5B79: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0515CD  5B7D: 2aff             sub bh, bh
  0515CF  5B7F: 8bc3             mov ax, bx
  0515D1  5B81: d1e3             shl bx, 1
  0515D3  5B83: 03d8             add bx, ax
  0515D5  5B85: d1e3             shl bx, 1
  0515D7  5B87: 03d8             add bx, ax
  0515D9  5B89: d1e3             shl bx, 1
  0515DB  5B8B: f6873d5210       test byte ptr [bx + 0x523d], 0x10
  0515E0  5B90: 7411             je 0x5ba3
  0515E2  5B92: 837ed804         cmp word ptr [bp - 0x28], 4
  0515E6  5B96: 750b             jne 0x5ba3
  0515E8  5B98: b80300           mov ax, 3
  0515EB  5B9B: f7ae1aff         imul word ptr [bp - 0xe6]
  0515EF  5B9F: 89861aff         mov word ptr [bp - 0xe6], ax
  0515F3  5BA3: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0515F7  5BA7: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  0515FC  5BAC: 740a             je 0x5bb8
  0515FE  5BAE: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  051603  5BB3: 7403             je 0x5bb8
  051605  5BB5: e99d00           jmp 0x5c55
  051608  5BB8: ff76e6           push word ptr [bp - 0x1a]
  05160B  5BBB: ff76ea           push word ptr [bp - 0x16]
  05160E  5BBE: 9a96061f18       lcall 0x181f, 0x696
  051613  5BC3: 83c404           add sp, 4
  051616  5BC6: 0bc0             or ax, ax
  051618  5BC8: 7d03             jge 0x5bcd
  05161A  5BCA: e98800           jmp 0x5c55
  05161D  5BCD: 6a0b             push 0xb
  05161F  5BCF: ff76a6           push word ptr [bp - 0x5a]
  051622  5BD2: 9abc081f18       lcall 0x181f, 0x8bc
  051627  5BD7: 83c404           add sp, 4
  05162A  5BDA: 898628ff         mov word ptr [bp - 0xd8], ax
  05162E  5BDE: 0bc0             or ax, ax
  051630  5BE0: 7473             je 0x5c55
  051632  5BE2: 8b4606           mov ax, word ptr [bp + 6]
  051635  5BE5: 89865cff         mov word ptr [bp - 0xa4], ax
  051639  5BE9: 2bc0             sub ax, ax
  05163B  5BEB: 8946fa           mov word ptr [bp - 6], ax
  05163E  5BEE: 894692           mov word ptr [bp - 0x6e], ax
  051641  5BF1: eb49             jmp 0x5c3c
  051643  5BF3: 90               nop 
  051644  5BF4: 8b5e92           mov bx, word ptr [bp - 0x6e]
  051647  5BF7: 8a87be00         mov al, byte ptr [bx + 0xbe]
  05164B  5BFB: 98               cwde 
  05164C  5BFC: 0346e6           add ax, word ptr [bp - 0x1a]
  05164F  5BFF: 8946c2           mov word ptr [bp - 0x3e], ax
  051652  5C02: 8bd0             mov dx, ax
  051654  5C04: 8a87b400         mov al, byte ptr [bx + 0xb4]
  051658  5C08: 98               cwde 
  051659  5C09: 0346ea           add ax, word ptr [bp - 0x16]
  05165C  5C0C: 8946d2           mov word ptr [bp - 0x2e], ax
  05165F  5C0F: 9ae0071f18       lcall 0x181f, 0x7e0
  051664  5C14: 894606           mov word ptr [bp + 6], ax
  051667  5C17: 0bc0             or ax, ax
  051669  5C19: 7c1e             jl 0x5c39
  05166B  5C1B: 6bd81c           imul bx, ax, 0x1c
  05166E  5C1E: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  051672  5C22: 80e10f           and cl, 0xf
  051675  5C25: 3a8e1cff         cmp cl, byte ptr [bp - 0xe4]
  051679  5C29: 750e             jne 0x5c39
  05167B  5C2B: 6a0b             push 0xb
  05167D  5C2D: 50               push ax
  05167E  5C2E: 9abc081f18       lcall 0x181f, 0x8bc
  051683  5C33: 83c404           add sp, 4
  051686  5C36: 0146fa           add word ptr [bp - 6], ax
  051689  5C39: ff4692           inc word ptr [bp - 0x6e]
  05168C  5C3C: 837e9208         cmp word ptr [bp - 0x6e], 8
  051690  5C40: 7cb2             jl 0x5bf4
  051692  5C42: 8b865cff         mov ax, word ptr [bp - 0xa4]
  051696  5C46: 894606           mov word ptr [bp + 6], ax
  051699  5C49: 8b46fa           mov ax, word ptr [bp - 6]
  05169C  5C4C: 398628ff         cmp word ptr [bp - 0xd8], ax
  0516A0  5C50: 7c03             jl 0x5c55
  0516A2  5C52: e9cefc           jmp 0x5923
  0516A5  5C55: 81be1affe803     cmp word ptr [bp - 0xe6], 0x3e8
  0516AB  5C5B: 7d07             jge 0x5c64
  0516AD  5C5D: 83be1aff00       cmp word ptr [bp - 0xe6], 0
  0516B2  5C62: 7d06             jge 0x5c6a
  0516B4  5C64: c7861affe803     mov word ptr [bp - 0xe6], 0x3e8
  0516BA  5C6A: 83be1aff0c       cmp word ptr [bp - 0xe6], 0xc
  0516BF  5C6F: 7d12             jge 0x5c83
  0516C1  5C71: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0516C5  5C75: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  0516CA  5C7A: 723e             jb 0x5cba
  0516CC  5C7C: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  0516D1  5C81: 7737             ja 0x5cba
  0516D3  5C83: 8b861aff         mov ax, word ptr [bp - 0xe6]
  0516D7  5C87: 3d0100           cmp ax, 1
  0516DA  5C8A: 7d03             jge 0x5c8f
  0516DC  5C8C: b80100           mov ax, 1
  0516DF  5C8F: c1e002           shl ax, 2
  0516E2  5C92: 0146da           add word ptr [bp - 0x26], ax
  0516E5  5C95: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0516E9  5C99: 80bf4f3100       cmp byte ptr [bx + 0x314f], 0
  0516EE  5C9E: 7c4a             jl 0x5cea
  0516F0  5CA0: 80bf4f3108       cmp byte ptr [bx + 0x314f], 8
  0516F5  5CA5: 7d43             jge 0x5cea
  0516F7  5CA7: 8a874f31         mov al, byte ptr [bx + 0x314f]
  0516FB  5CAB: 98               cwde 
  0516FC  5CAC: 2b46b2           sub ax, word ptr [bp - 0x4e]
  0516FF  5CAF: 898612ff         mov word ptr [bp - 0xee], ax
  051703  5CB3: 0bc0             or ax, ax
  051705  5CB5: 7e0b             jle 0x5cc2
  051707  5CB7: eb18             jmp 0x5cd1
  051709  5CB9: 90               nop 
  05170A  5CBA: 816edae703       sub word ptr [bp - 0x26], 0x3e7
  05170F  5CBF: ebd4             jmp 0x5c95
  051711  5CC1: 90               nop 
  051712  5CC2: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051716  5CC6: 8a874f31         mov al, byte ptr [bx + 0x314f]
  05171A  5CCA: 98               cwde 
  05171B  5CCB: 2b46b2           sub ax, word ptr [bp - 0x4e]
  05171E  5CCE: f7d0             not ax
  051720  5CD0: 40               inc ax
  051721  5CD1: 894694           mov word ptr [bp - 0x6c], ax
  051724  5CD4: 3d0400           cmp ax, 4
  051727  5CD7: 7e08             jle 0x5ce1
  051729  5CD9: 2d0800           sub ax, 8
  05172C  5CDC: f7d8             neg ax
  05172E  5CDE: 894694           mov word ptr [bp - 0x6c], ax
  051731  5CE1: 8bc8             mov cx, ax
  051733  5CE3: f7e9             imul cx
  051735  5CE5: d1e0             shl ax, 1
  051737  5CE7: 2946da           sub word ptr [bp - 0x26], ax
  05173A  5CEA: c746920000       mov word ptr [bp - 0x6e], 0
  05173F  5CEF: e9fb00           jmp 0x5ded
  051742  5CF2: 6b9e6cff1c       imul bx, word ptr [bp - 0x94], 0x1c
  051747  5CF7: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05174B  5CFB: 2aff             sub bh, bh
  05174D  5CFD: 8bc3             mov ax, bx
  05174F  5CFF: d1e3             shl bx, 1
  051751  5D01: 03d8             add bx, ax
  051753  5D03: d1e3             shl bx, 1
  051755  5D05: 03d8             add bx, ax
  051757  5D07: d1e3             shl bx, 1
  051759  5D09: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  05175E  5D0E: 7404             je 0x5d14
  051760  5D10: 836eda0a         sub word ptr [bp - 0x26], 0xa
  051764  5D14: 8b866cff         mov ax, word ptr [bp - 0x94]
  051768  5D18: 9ae4021f18       lcall 0x181f, 0x2e4
  05176D  5D1D: 89866cff         mov word ptr [bp - 0x94], ax
  051771  5D21: 0bc0             or ax, ax
  051773  5D23: 7dcd             jge 0x5cf2
  051775  5D25: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051779  5D29: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05177E  5D2E: 7303             jae 0x5d33
  051780  5D30: e9b700           jmp 0x5dea
  051783  5D33: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  051788  5D38: 7603             jbe 0x5d3d
  05178A  5D3A: e9ad00           jmp 0x5dea
  05178D  5D3D: ff76c2           push word ptr [bp - 0x3e]
  051790  5D40: ff76d2           push word ptr [bp - 0x2e]
  051793  5D43: 9abe071f18       lcall 0x181f, 0x7be
  051798  5D48: 83c404           add sp, 4
  05179B  5D4B: 898670ff         mov word ptr [bp - 0x90], ax
  05179F  5D4F: 0bc0             or ax, ax
  0517A1  5D51: 7d03             jge 0x5d56
  0517A3  5D53: e99400           jmp 0x5dea
  0517A6  5D56: 69d8ca00         imul bx, ax, 0xca
  0517AA  5D5A: 8a8f605d         mov cl, byte ptr [bx + 0x5d60]
  0517AE  5D5E: 2aed             sub ch, ch
  0517B0  5D60: 894ef2           mov word ptr [bp - 0xe], cx
  0517B3  5D63: c78652ff0000     mov word ptr [bp - 0xae], 0
  0517B9  5D69: 51               push cx
  0517BA  5D6A: ffb61cff         push word ptr [bp - 0xe4]
  0517BE  5D6E: 9a380a1f18       lcall 0x181f, 0xa38
  0517C3  5D73: 83c404           add sp, 4
  0517C6  5D76: 2460             and al, 0x60
  0517C8  5D78: 3c20             cmp al, 0x20
  0517CA  5D7A: 756e             jne 0x5dea
  0517CC  5D7C: 6a01             push 1
  0517CE  5D7E: ffb670ff         push word ptr [bp - 0x90]
  0517D2  5D82: 9a22031f18       lcall 0x181f, 0x322
  0517D7  5D87: 83c404           add sp, 4
  0517DA  5D8A: 0bc0             or ax, ax
  0517DC  5D8C: 7406             je 0x5d94
  0517DE  5D8E: c78652ff1400     mov word ptr [bp - 0xae], 0x14
  0517E4  5D94: 6a02             push 2
  0517E6  5D96: ffb670ff         push word ptr [bp - 0x90]
  0517EA  5D9A: 9a22031f18       lcall 0x181f, 0x322
  0517EF  5D9F: 83c404           add sp, 4
  0517F2  5DA2: 0bc0             or ax, ax
  0517F4  5DA4: 7406             je 0x5dac
  0517F6  5DA6: c78652ff2800     mov word ptr [bp - 0xae], 0x28
  0517FC  5DAC: 8b46d2           mov ax, word ptr [bp - 0x2e]
  0517FF  5DAF: 8b56c2           mov dx, word ptr [bp - 0x3e]
  051802  5DB2: 9ae0071f18       lcall 0x181f, 0x7e0
  051807  5DB7: eb15             jmp 0x5dce
  051809  5DB9: 90               nop 
  05180A  5DBA: 6bd81c           imul bx, ax, 0x1c
  05180D  5DBD: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  051812  5DC2: 7505             jne 0x5dc9
  051814  5DC4: 838652ff1e       add word ptr [bp - 0xae], 0x1e
  051819  5DC9: 9ae4021f18       lcall 0x181f, 0x2e4
  05181E  5DCE: 8946aa           mov word ptr [bp - 0x56], ax
  051821  5DD1: 0bc0             or ax, ax
  051823  5DD3: 7de5             jge 0x5dba
  051825  5DD5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051829  5DD9: 8a875031         mov al, byte ptr [bx + 0x3150]
  05182D  5DDD: 2ae4             sub ah, ah
  05182F  5DDF: f7ae52ff         imul word ptr [bp - 0xae]
  051833  5DE3: 898652ff         mov word ptr [bp - 0xae], ax
  051837  5DE7: 2946da           sub word ptr [bp - 0x26], ax
  05183A  5DEA: ff4692           inc word ptr [bp - 0x6e]
  05183D  5DED: 837e9208         cmp word ptr [bp - 0x6e], 8
  051841  5DF1: 7d7b             jge 0x5e6e
  051843  5DF3: 8b5e92           mov bx, word ptr [bp - 0x6e]
  051846  5DF6: 8a87be00         mov al, byte ptr [bx + 0xbe]
  05184A  5DFA: 98               cwde 
  05184B  5DFB: 0346e6           add ax, word ptr [bp - 0x1a]
  05184E  5DFE: 8946c2           mov word ptr [bp - 0x3e], ax
  051851  5E01: 50               push ax
  051852  5E02: 8a87b400         mov al, byte ptr [bx + 0xb4]
  051856  5E06: 98               cwde 
  051857  5E07: 0346ea           add ax, word ptr [bp - 0x16]
  05185A  5E0A: 8946d2           mov word ptr [bp - 0x2e], ax
  05185D  5E0D: 50               push ax
  05185E  5E0E: 9a82061f18       lcall 0x181f, 0x682
  051863  5E13: 83c404           add sp, 4
  051866  5E16: 8946f2           mov word ptr [bp - 0xe], ax
  051869  5E19: 0bc0             or ax, ax
  05186B  5E1B: 7d03             jge 0x5e20
  05186D  5E1D: e905ff           jmp 0x5d25
  051870  5E20: 3b861cff         cmp ax, word ptr [bp - 0xe4]
  051874  5E24: 7503             jne 0x5e29
  051876  5E26: e9fcfe           jmp 0x5d25
  051879  5E29: 50               push ax
  05187A  5E2A: ffb61cff         push word ptr [bp - 0xe4]
  05187E  5E2E: 9a380a1f18       lcall 0x181f, 0xa38
  051883  5E33: 83c404           add sp, 4
  051886  5E36: 2460             and al, 0x60
  051888  5E38: 3c20             cmp al, 0x20
  05188A  5E3A: 7403             je 0x5e3f
  05188C  5E3C: e9e6fe           jmp 0x5d25
  05188F  5E3F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051893  5E43: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  051897  5E47: 2aff             sub bh, bh
  051899  5E49: 8bc3             mov ax, bx
  05189B  5E4B: d1e3             shl bx, 1
  05189D  5E4D: 03d8             add bx, ax
  05189F  5E4F: d1e3             shl bx, 1
  0518A1  5E51: 03d8             add bx, ax
  0518A3  5E53: d1e3             shl bx, 1
  0518A5  5E55: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  0518AA  5E5A: 7403             je 0x5e5f
  0518AC  5E5C: e9c6fe           jmp 0x5d25
  0518AF  5E5F: 8b46d2           mov ax, word ptr [bp - 0x2e]
  0518B2  5E62: 8b56c2           mov dx, word ptr [bp - 0x3e]
  0518B5  5E65: 9ae0071f18       lcall 0x181f, 0x7e0
  0518BA  5E6A: e9b0fe           jmp 0x5d1d
  0518BD  5E6D: 90               nop 
  0518BE  5E6E: 83be16ff00       cmp word ptr [bp - 0xea], 0
  0518C3  5E73: 7503             jne 0x5e78
  0518C5  5E75: e92d01           jmp 0x5fa5
  0518C8  5E78: 8b5eb2           mov bx, word ptr [bp - 0x4e]
  0518CB  5E7B: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0518CF  5E7F: 98               cwde 
  0518D0  5E80: c1e002           shl ax, 2
  0518D3  5E83: 03866eff         add ax, word ptr [bp - 0x92]
  0518D7  5E87: 8946e6           mov word ptr [bp - 0x1a], ax
  0518DA  5E8A: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0518DE  5E8E: 98               cwde 
  0518DF  5E8F: c1e002           shl ax, 2
  0518E2  5E92: 03867aff         add ax, word ptr [bp - 0x86]
  0518E6  5E96: 8946ea           mov word ptr [bp - 0x16], ax
  0518E9  5E99: c1f802           sar ax, 2
  0518EC  5E9C: 6bf012           imul si, ax, 0x12
  0518EF  5E9F: 8b5ee6           mov bx, word ptr [bp - 0x1a]
  0518F2  5EA2: c1fb02           sar bx, 2
  0518F5  5EA5: 80b8aa9f00       cmp byte ptr [bx + si - 0x6056], 0
  0518FA  5EAA: 7528             jne 0x5ed4
  0518FC  5EAC: ff76e6           push word ptr [bp - 0x1a]
  0518FF  5EAF: ff76ea           push word ptr [bp - 0x16]
  051902  5EB2: 9a68071f18       lcall 0x181f, 0x768
  051907  5EB7: 83c404           add sp, 4
  05190A  5EBA: 0bc0             or ax, ax
  05190C  5EBC: 7516             jne 0x5ed4
  05190E  5EBE: ff76e6           push word ptr [bp - 0x1a]
  051911  5EC1: ff76ea           push word ptr [bp - 0x16]
  051914  5EC4: 9a02031f18       lcall 0x181f, 0x302
  051919  5EC9: 83c404           add sp, 4
  05191C  5ECC: 0bc0             or ax, ax
  05191E  5ECE: 7404             je 0x5ed4
  051920  5ED0: 8346da08         add word ptr [bp - 0x26], 8
  051924  5ED4: 837ece00         cmp word ptr [bp - 0x32], 0
  051928  5ED8: 741b             je 0x5ef5
  05192A  5EDA: 837eb205         cmp word ptr [bp - 0x4e], 5
  05192E  5EDE: 7c15             jl 0x5ef5
  051930  5EE0: 837eb207         cmp word ptr [bp - 0x4e], 7
  051934  5EE4: 7f0f             jg 0x5ef5
  051936  5EE6: a13a85           mov ax, word ptr [0x853a]
  051939  5EE9: d1f8             sar ax, 1
  05193B  5EEB: 3b867aff         cmp ax, word ptr [bp - 0x86]
  05193F  5EEF: 7d04             jge 0x5ef5
  051941  5EF1: 8346da04         add word ptr [bp - 0x26], 4
  051945  5EF5: c746920000       mov word ptr [bp - 0x6e], 0
  05194A  5EFA: 8b5e92           mov bx, word ptr [bp - 0x6e]
  05194D  5EFD: 8a87be00         mov al, byte ptr [bx + 0xbe]
  051951  5F01: 98               cwde 
  051952  5F02: 0346e6           add ax, word ptr [bp - 0x1a]
  051955  5F05: 8946c2           mov word ptr [bp - 0x3e], ax
  051958  5F08: 50               push ax
  051959  5F09: 8a87b400         mov al, byte ptr [bx + 0xb4]
  05195D  5F0D: 98               cwde 
  05195E  5F0E: 0346ea           add ax, word ptr [bp - 0x16]
  051961  5F11: 8946d2           mov word ptr [bp - 0x2e], ax
  051964  5F14: 50               push ax
  051965  5F15: 9a02031f18       lcall 0x181f, 0x302
  05196A  5F1A: 83c404           add sp, 4
  05196D  5F1D: 0bc0             or ax, ax
  05196F  5F1F: 7478             je 0x5f99
  051971  5F21: 83be1cff04       cmp word ptr [bp - 0xe4], 4
  051976  5F26: 7d39             jge 0x5f61
  051978  5F28: ff76c2           push word ptr [bp - 0x3e]
  05197B  5F2B: ff76d2           push word ptr [bp - 0x2e]
  05197E  5F2E: 9a4a071f18       lcall 0x181f, 0x74a
  051983  5F33: 83c404           add sp, 4
  051986  5F36: 2ae4             sub ah, ah
  051988  5F38: 8a8e1cff         mov cl, byte ptr [bp - 0xe4]
  05198C  5F3C: ba1000           mov dx, 0x10
  05198F  5F3F: d3e2             shl dx, cl
  051991  5F41: 85c2             test dx, ax
  051993  5F43: 751c             jne 0x5f61
  051995  5F45: ff76c2           push word ptr [bp - 0x3e]
  051998  5F48: ff76d2           push word ptr [bp - 0x2e]
  05199B  5F4B: 9a68071f18       lcall 0x181f, 0x768
  0519A0  5F50: 83c404           add sp, 4
  0519A3  5F53: 0bc0             or ax, ax
  0519A5  5F55: 7406             je 0x5f5d
  0519A7  5F57: 837ece00         cmp word ptr [bp - 0x32], 0
  0519AB  5F5B: 7404             je 0x5f61
  0519AD  5F5D: 8346da02         add word ptr [bp - 0x26], 2
  0519B1  5F61: ff76c2           push word ptr [bp - 0x3e]
  0519B4  5F64: ff76d2           push word ptr [bp - 0x2e]
  0519B7  5F67: 9a82061f18       lcall 0x181f, 0x682
  0519BC  5F6C: 83c404           add sp, 4
  0519BF  5F6F: 0bc0             or ax, ax
  0519C1  5F71: 7c04             jl 0x5f77
  0519C3  5F73: 836eda02         sub word ptr [bp - 0x26], 2
  0519C7  5F77: 837e9800         cmp word ptr [bp - 0x68], 0
  0519CB  5F7B: 741c             je 0x5f99
  0519CD  5F7D: ff76c2           push word ptr [bp - 0x3e]
  0519D0  5F80: ff76d2           push word ptr [bp - 0x2e]
  0519D3  5F83: 9a8c071f18       lcall 0x181f, 0x78c
  0519D8  5F88: 83c404           add sp, 4
  0519DB  5F8B: 8bd8             mov bx, ax
  0519DD  5F8D: c1e304           shl bx, 4
  0519E0  5F90: 8a87792f         mov al, byte ptr [bx + 0x2f79]
  0519E4  5F94: 2ae4             sub ah, ah
  0519E6  5F96: 0146da           add word ptr [bp - 0x26], ax
  0519E9  5F99: ff4692           inc word ptr [bp - 0x6e]
  0519EC  5F9C: 837e9208         cmp word ptr [bp - 0x6e], 8
  0519F0  5FA0: 7d03             jge 0x5fa5
  0519F2  5FA2: e955ff           jmp 0x5efa
  0519F5  5FA5: 8b8620ff         mov ax, word ptr [bp - 0xe0]
  0519F9  5FA9: 3946da           cmp word ptr [bp - 0x26], ax
  0519FC  5FAC: 7f03             jg 0x5fb1
  0519FE  5FAE: e972f9           jmp 0x5923
  051A01  5FB1: 8b46da           mov ax, word ptr [bp - 0x26]
  051A04  5FB4: 898620ff         mov word ptr [bp - 0xe0], ax
  051A08  5FB8: 8b46b2           mov ax, word ptr [bp - 0x4e]
  051A0B  5FBB: 89468c           mov word ptr [bp - 0x74], ax
  051A0E  5FBE: 8b4684           mov ax, word ptr [bp - 0x7c]
  051A11  5FC1: 898634ff         mov word ptr [bp - 0xcc], ax
  051A15  5FC5: e95bf9           jmp 0x5923
  051A18  5FC8: 83be54ff00       cmp word ptr [bp - 0xac], 0
  051A1D  5FCD: 7411             je 0x5fe0
  051A1F  5FCF: 6a00             push 0
  051A21  5FD1: 6a00             push 0
  051A23  5FD3: 6a00             push 0
  051A25  5FD5: 68b517           push 0x17b5
  051A28  5FD8: 9a7e071f18       lcall 0x181f, 0x77e
  051A2D  5FDD: 83c408           add sp, 8
  051A30  5FE0: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  051A35  5FE5: 742f             je 0x6016
  051A37  5FE7: ff7606           push word ptr [bp + 6]
  051A3A  5FEA: 9a0c091f18       lcall 0x181f, 0x90c
  051A3F  5FEF: 83c402           add sp, 2
  051A42  5FF2: 2ae4             sub ah, ah
  051A44  5FF4: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051A48  5FF8: 8a8f4931         mov cl, byte ptr [bx + 0x3149]
  051A4C  5FFC: 2aed             sub ch, ch
  051A4E  5FFE: 2bc1             sub ax, cx
  051A50  6000: 3d0300           cmp ax, 3
  051A53  6003: 7d05             jge 0x600a
  051A55  6005: c7468c0800       mov word ptr [bp - 0x74], 8
  051A5A  600A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051A5E  600E: c6874b3139       mov byte ptr [bx + 0x314b], 0x39
  051A63  6013: eb29             jmp 0x603e
  051A65  6015: 90               nop 
  051A66  6016: 83be74ff00       cmp word ptr [bp - 0x8c], 0
  051A6B  601B: 745f             je 0x607c
  051A6D  601D: ff76a0           push word ptr [bp - 0x60]
  051A70  6020: 9ae6091f18       lcall 0x181f, 0x9e6
  051A75  6025: 83c402           add sp, 2
  051A78  6028: 8b1e4285         mov bx, word ptr [0x8542]
  051A7C  602C: fe8f8e00         dec byte ptr [bx + 0x8e]
  051A80  6030: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051A84  6034: c6874b3147       mov byte ptr [bx + 0x314b], 0x47
  051A89  6039: c7468c0800       mov word ptr [bp - 0x74], 8
  051A8E  603E: 8a468c           mov al, byte ptr [bp - 0x74]
  051A91  6041: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051A95  6045: 88874f31         mov byte ptr [bx + 0x314f], al
  051A99  6049: 837e8c08         cmp word ptr [bp - 0x74], 8
  051A9D  604D: 7403             je 0x6052
  051A9F  604F: e98201           jmp 0x61d4
  051AA2  6052: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  051AA7  6057: 740c             je 0x6065
  051AA9  6059: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  051AAE  605E: 7405             je 0x6065
  051AB0  6060: c6874c3105       mov byte ptr [bx + 0x314c], 5
  051AB5  6065: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051AB9  6069: f687483102       test byte ptr [bx + 0x3148], 2
  051ABE  606E: 7503             jne 0x6073
  051AC0  6070: e9a501           jmp 0x6218
  051AC3  6073: c6874c3106       mov byte ptr [bx + 0x314c], 6
  051AC8  6078: e99d01           jmp 0x6218
  051ACB  607B: 90               nop 
  051ACC  607C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051AD0  6080: 8bc3             mov ax, bx
  051AD2  6082: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  051AD6  6086: 2aff             sub bh, bh
  051AD8  6088: 8bcb             mov cx, bx
  051ADA  608A: d1e3             shl bx, 1
  051ADC  608C: 03d9             add bx, cx
  051ADE  608E: d1e3             shl bx, 1
  051AE0  6090: 03d9             add bx, cx
  051AE2  6092: d1e3             shl bx, 1
  051AE4  6094: f6873d5201       test byte ptr [bx + 0x523d], 1
  051AE9  6099: 7443             je 0x60de
  051AEB  609B: 837ed400         cmp word ptr [bp - 0x2c], 0
  051AEF  609F: 743d             je 0x60de
  051AF1  60A1: 6a00             push 0
  051AF3  60A3: ffb66eff         push word ptr [bp - 0x92]
  051AF7  60A7: ffb67aff         push word ptr [bp - 0x86]
  051AFB  60AB: ffb61cff         push word ptr [bp - 0xe4]
  051AFF  60AF: 8bf0             mov si, ax
  051B01  60B1: 0e               push cs
  051B02  60B2: e82f1a           call 0x7ae4
  051B05  60B5: 83c408           add sp, 8
  051B08  60B8: 8946c0           mov word ptr [bp - 0x40], ax
  051B0B  60BB: 0bc0             or ax, ax
  051B0D  60BD: 741f             je 0x60de
  051B0F  60BF: 3d0400           cmp ax, 4
  051B12  60C2: 7f1a             jg 0x60de
  051B14  60C4: 6a02             push 2
  051B16  60C6: ff7606           push word ptr [bp + 6]
  051B19  60C9: 9abc081f18       lcall 0x181f, 0x8bc
  051B1E  60CE: 83c404           add sp, 4
  051B21  60D1: 3d0200           cmp ax, 2
  051B24  60D4: 7d08             jge 0x60de
  051B26  60D6: c6844b3142       mov byte ptr [si + 0x314b], 0x42
  051B2B  60DB: e95bff           jmp 0x6039
  051B2E  60DE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051B32  60E2: 8bc3             mov ax, bx
  051B34  60E4: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  051B38  60E8: 2aff             sub bh, bh
  051B3A  60EA: 8bcb             mov cx, bx
  051B3C  60EC: d1e3             shl bx, 1
  051B3E  60EE: 03d9             add bx, cx
  051B40  60F0: d1e3             shl bx, 1
  051B42  60F2: 03d9             add bx, cx
  051B44  60F4: d1e3             shl bx, 1
  051B46  60F6: f6873d5204       test byte ptr [bx + 0x523d], 4
  051B4B  60FB: 7435             je 0x6132
  051B4D  60FD: 6a02             push 2
  051B4F  60FF: ffb66eff         push word ptr [bp - 0x92]
  051B53  6103: ffb67aff         push word ptr [bp - 0x86]
  051B57  6107: ffb61cff         push word ptr [bp - 0xe4]
  051B5B  610B: 8bf0             mov si, ax
  051B5D  610D: 0e               push cs
  051B5E  610E: e8d319           call 0x7ae4
  051B61  6111: 83c408           add sp, 8
  051B64  6114: 0bc0             or ax, ax
  051B66  6116: 741a             je 0x6132
  051B68  6118: 6a02             push 2
  051B6A  611A: ff7606           push word ptr [bp + 6]
  051B6D  611D: 9abc081f18       lcall 0x181f, 0x8bc
  051B72  6122: 83c404           add sp, 4
  051B75  6125: 3d0200           cmp ax, 2
  051B78  6128: 7d08             jge 0x6132
  051B7A  612A: c6844b3165       mov byte ptr [si + 0x314b], 0x65
  051B7F  612F: e907ff           jmp 0x6039
  051B82  6132: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051B86  6136: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  051B8A  613A: 8bc3             mov ax, bx
  051B8C  613C: 2aff             sub bh, bh
  051B8E  613E: 8bcb             mov cx, bx
  051B90  6140: d1e3             shl bx, 1
  051B92  6142: 03d9             add bx, cx
  051B94  6144: d1e3             shl bx, 1
  051B96  6146: 03d9             add bx, cx
  051B98  6148: d1e3             shl bx, 1
  051B9A  614A: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  051B9F  614F: 7703             ja 0x6154
  051BA1  6151: e9b6fe           jmp 0x600a
  051BA4  6154: 3c0d             cmp al, 0xd
  051BA6  6156: 7207             jb 0x615f
  051BA8  6158: 3c12             cmp al, 0x12
  051BAA  615A: 7703             ja 0x615f
  051BAC  615C: e9abfe           jmp 0x600a
  051BAF  615F: 83be18ff00       cmp word ptr [bp - 0xe8], 0
  051BB4  6164: 7503             jne 0x6169
  051BB6  6166: e9a1fe           jmp 0x600a
  051BB9  6169: 8b4606           mov ax, word ptr [bp + 6]
  051BBC  616C: 9a8e091f18       lcall 0x181f, 0x98e
  051BC1  6171: 8bf0             mov si, ax
  051BC3  6173: 8b4606           mov ax, word ptr [bp + 6]
  051BC6  6176: 9aee021f18       lcall 0x181f, 0x2ee
  051BCB  617B: 3bc6             cmp ax, si
  051BCD  617D: 7403             je 0x6182
  051BCF  617F: e988fe           jmp 0x600a
  051BD2  6182: c746b20000       mov word ptr [bp - 0x4e], 0
  051BD7  6187: eb04             jmp 0x618d
  051BD9  6189: 90               nop 
  051BDA  618A: ff46b2           inc word ptr [bp - 0x4e]
  051BDD  618D: 837eb208         cmp word ptr [bp - 0x4e], 8
  051BE1  6191: 7c03             jl 0x6196
  051BE3  6193: e974fe           jmp 0x600a
  051BE6  6196: 8b5eb2           mov bx, word ptr [bp - 0x4e]
  051BE9  6199: 8a87be00         mov al, byte ptr [bx + 0xbe]
  051BED  619D: 98               cwde 
  051BEE  619E: 03866eff         add ax, word ptr [bp - 0x92]
  051BF2  61A2: 8946e6           mov word ptr [bp - 0x1a], ax
  051BF5  61A5: 50               push ax
  051BF6  61A6: 8a87b400         mov al, byte ptr [bx + 0xb4]
  051BFA  61AA: 98               cwde 
  051BFB  61AB: 03867aff         add ax, word ptr [bp - 0x86]
  051BFF  61AF: 8946ea           mov word ptr [bp - 0x16], ax
  051C02  61B2: 50               push ax
  051C03  61B3: 9a96061f18       lcall 0x181f, 0x696
  051C08  61B8: 83c404           add sp, 4
  051C0B  61BB: 8946f2           mov word ptr [bp - 0xe], ax
  051C0E  61BE: 0bc0             or ax, ax
  051C10  61C0: 7cc8             jl 0x618a
  051C12  61C2: 3b861cff         cmp ax, word ptr [bp - 0xe4]
  051C16  61C6: 74c2             je 0x618a
  051C18  61C8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051C1C  61CC: c6874b3146       mov byte ptr [bx + 0x314b], 0x46
  051C21  61D1: e965fe           jmp 0x6039
  051C24  61D4: 8b5e8c           mov bx, word ptr [bp - 0x74]
  051C27  61D7: 8a87be00         mov al, byte ptr [bx + 0xbe]
  051C2B  61DB: 98               cwde 
  051C2C  61DC: 01866eff         add word ptr [bp - 0x92], ax
  051C30  61E0: 8b866eff         mov ax, word ptr [bp - 0x92]
  051C34  61E4: 50               push ax
  051C35  61E5: 8a87b400         mov al, byte ptr [bx + 0xb4]
  051C39  61E9: 98               cwde 
  051C3A  61EA: 01867aff         add word ptr [bp - 0x86], ax
  051C3E  61EE: 8b867aff         mov ax, word ptr [bp - 0x86]
  051C42  61F2: 50               push ax
  051C43  61F3: 9a02031f18       lcall 0x181f, 0x302
  051C48  61F8: 83c404           add sp, 4
  051C4B  61FB: 0bc0             or ax, ax
  051C4D  61FD: 7419             je 0x6218
  051C4F  61FF: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051C53  6203: c6874c310c       mov byte ptr [bx + 0x314c], 0xc
  051C58  6208: 8a867aff         mov al, byte ptr [bp - 0x86]
  051C5C  620C: 88874d31         mov byte ptr [bx + 0x314d], al
  051C60  6210: 8a866eff         mov al, byte ptr [bp - 0x92]
  051C64  6214: 88874e31         mov byte ptr [bx + 0x314e], al
  051C68  6218: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051C6C  621C: 80bf4c310a       cmp byte ptr [bx + 0x314c], 0xa
  051C71  6221: 7407             je 0x622a
  051C73  6223: 80bf4c3100       cmp byte ptr [bx + 0x314c], 0
  051C78  6228: 750e             jne 0x6238
  051C7A  622A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051C7E  622E: c6874b3130       mov byte ptr [bx + 0x314b], 0x30
  051C83  6233: c6874c3105       mov byte ptr [bx + 0x314c], 5
  051C88  6238: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051C8C  623C: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  051C91  6241: 7570             jne 0x62b3
  051C93  6243: 8a874431         mov al, byte ptr [bx + 0x3144]
  051C97  6247: 2ae4             sub ah, ah
  051C99  6249: 89867aff         mov word ptr [bp - 0x86], ax
  051C9D  624D: 8a874531         mov al, byte ptr [bx + 0x3145]
  051CA1  6251: 89866eff         mov word ptr [bp - 0x92], ax
  051CA5  6255: c746b20000       mov word ptr [bp - 0x4e], 0
  051CAA  625A: eb14             jmp 0x6270
  051CAC  625C: 50               push ax
  051CAD  625D: ffb61cff         push word ptr [bp - 0xe4]
  051CB1  6261: 9a380a1f18       lcall 0x181f, 0xa38
  051CB6  6266: 83c404           add sp, 4
  051CB9  6269: a840             test al, 0x40
  051CBB  626B: 753d             jne 0x62aa
  051CBD  626D: ff46b2           inc word ptr [bp - 0x4e]
  051CC0  6270: 837eb208         cmp word ptr [bp - 0x4e], 8
  051CC4  6274: 7d3d             jge 0x62b3
  051CC6  6276: 8b5eb2           mov bx, word ptr [bp - 0x4e]
  051CC9  6279: 8a87be00         mov al, byte ptr [bx + 0xbe]
  051CCD  627D: 98               cwde 
  051CCE  627E: 03866eff         add ax, word ptr [bp - 0x92]
  051CD2  6282: 8946e6           mov word ptr [bp - 0x1a], ax
  051CD5  6285: 50               push ax
  051CD6  6286: 8a87b400         mov al, byte ptr [bx + 0xb4]
  051CDA  628A: 98               cwde 
  051CDB  628B: 03867aff         add ax, word ptr [bp - 0x86]
  051CDF  628F: 8946ea           mov word ptr [bp - 0x16], ax
  051CE2  6292: 50               push ax
  051CE3  6293: 9a96061f18       lcall 0x181f, 0x696
  051CE8  6298: 83c404           add sp, 4
  051CEB  629B: 8946f2           mov word ptr [bp - 0xe], ax
  051CEE  629E: 0bc0             or ax, ax
  051CF0  62A0: 7ccb             jl 0x626d
  051CF2  62A2: 3b861cff         cmp ax, word ptr [bp - 0xe4]
  051CF6  62A6: 75b4             jne 0x625c
  051CF8  62A8: ebc3             jmp 0x626d
  051CFA  62AA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051CFE  62AE: c6874c3100       mov byte ptr [bx + 0x314c], 0
  051D03  62B3: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051D07  62B7: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  051D0C  62BC: 7539             jne 0x62f7
  051D0E  62BE: 8a874431         mov al, byte ptr [bx + 0x3144]
  051D12  62C2: 38874d31         cmp byte ptr [bx + 0x314d], al
  051D16  62C6: 752f             jne 0x62f7
  051D18  62C8: 8a874531         mov al, byte ptr [bx + 0x3145]
  051D1C  62CC: 38874e31         cmp byte ptr [bx + 0x314e], al
  051D20  62D0: 7525             jne 0x62f7
  051D22  62D2: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  051D27  62D7: 7213             jb 0x62ec
  051D29  62D9: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  051D2E  62DE: 770c             ja 0x62ec
  051D30  62E0: 80bf4b3131       cmp byte ptr [bx + 0x314b], 0x31
  051D35  62E5: 7505             jne 0x62ec
  051D37  62E7: c6874b3142       mov byte ptr [bx + 0x314b], 0x42
  051D3C  62EC: ff7606           push word ptr [bp + 6]
  051D3F  62EF: 9a34091f18       lcall 0x181f, 0x934
  051D44  62F4: 83c402           add sp, 2
  051D47  62F7: c7864aff0000     mov word ptr [bp - 0xb6], 0
  051D4D  62FD: 8b864aff         mov ax, word ptr [bp - 0xb6]
  051D51  6301: 5e               pop si
  051D52  6302: 5f               pop di
  051D53  6303: c9               leave 
  051D54  6304: cb               retf 

; ---- func_051D56  size=214  insns=81  prologue=push bp;mov bp,sp  terminal=RETF ----
  051D56  6306: 55               push bp
  051D57  6307: 8bec             mov bp, sp
  051D59  6309: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051D5D  630D: 80bf493100       cmp byte ptr [bx + 0x3149], 0
  051D62  6312: 7459             je 0x636d
  051D64  6314: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  051D69  6319: 7552             jne 0x636d
  051D6B  631B: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  051D6F  631F: 2aff             sub bh, bh
  051D71  6321: 8bc3             mov ax, bx
  051D73  6323: d1e3             shl bx, 1
  051D75  6325: 03d8             add bx, ax
  051D77  6327: d1e3             shl bx, 1
  051D79  6329: 03d8             add bx, ax
  051D7B  632B: d1e3             shl bx, 1
  051D7D  632D: f6873d5201       test byte ptr [bx + 0x523d], 1
  051D82  6332: 7446             je 0x637a
  051D84  6334: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051D88  6338: 8a874731         mov al, byte ptr [bx + 0x3147]
  051D8C  633C: 250f00           and ax, 0xf
  051D8F  633F: 50               push ax
  051D90  6340: 8a874531         mov al, byte ptr [bx + 0x3145]
  051D94  6344: 2ae4             sub ah, ah
  051D96  6346: 50               push ax
  051D97  6347: 8a874431         mov al, byte ptr [bx + 0x3144]
  051D9B  634B: 50               push ax
  051D9C  634C: 9a84091f18       lcall 0x181f, 0x984
  051DA1  6351: 8be5             mov sp, bp
  051DA3  6353: 0bc0             or ax, ax
  051DA5  6355: 7423             je 0x637a
  051DA7  6357: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051DAB  635B: 80bf4b3145       cmp byte ptr [bx + 0x314b], 0x45
  051DB0  6360: 750b             jne 0x636d
  051DB2  6362: 8a9f4731         mov bl, byte ptr [bx + 0x3147]
  051DB6  6366: 83e30f           and bx, 0xf
  051DB9  6369: fe8f5694         dec byte ptr [bx - 0x6baa]
  051DBD  636D: ff7606           push word ptr [bp + 6]
  051DC0  6370: 0e               push cs
  051DC1  6371: e83417           call 0x7aa8
  051DC4  6374: 8be5             mov sp, bp
  051DC6  6376: 0bc0             or ax, ax
  051DC8  6378: 755c             jne 0x63d6
  051DCA  637A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  051DCE  637E: 8a874c31         mov al, byte ptr [bx + 0x314c]
  051DD2  6382: 2ae4             sub ah, ah
  051DD4  6384: eb34             jmp 0x63ba
  051DD6  6386: ff7606           push word ptr [bp + 6]
  051DD9  6389: 9ac2011f19       lcall 0x191f, 0x1c2
  051DDE  638E: 8be5             mov sp, bp
  051DE0  6390: c9               leave 
  051DE1  6391: cb               retf 
  051DE2  6392: ff7606           push word ptr [bp + 6]
  051DE5  6395: 9a16021f19       lcall 0x191f, 0x216
  051DEA  639A: ebf2             jmp 0x638e
  051DEC  639C: ff7606           push word ptr [bp + 6]
  051DEF  639F: 9afa011f19       lcall 0x191f, 0x1fa
  051DF4  63A4: ebe8             jmp 0x638e
  051DF6  63A6: ff7606           push word ptr [bp + 6]
  051DF9  63A9: 9aba041f19       lcall 0x191f, 0x4ba
  051DFE  63AE: ebde             jmp 0x638e
  051E00  63B0: ff7606           push word ptr [bp + 6]
  051E03  63B3: 9a34091f18       lcall 0x181f, 0x934
  051E08  63B8: ebd4             jmp 0x638e
  051E0A  63BA: 2d0700           sub ax, 7
  051E0D  63BD: 3d0500           cmp ax, 5
  051E10  63C0: 77ee             ja 0x63b0
  051E12  63C2: d1e0             shl ax, 1
  051E14  63C4: 93               xchg bx, ax
  051E15  63C5: 2effa72a5c       jmp word ptr cs:[bx + 0x5c2a]
  051E1A  63CA: fc               cld 
  051E1B  63CB: 5b               pop bx
  051E1C  63CC: e65b             out 0x5b, al
  051E1E  63CE: f25b             pop bx
  051E20  63D0: 105c06           adc byte ptr [si + 6], bl
  051E23  63D3: 5c               pop sp
  051E24  63D4: 06               push es
  051E25  63D5: 5c               pop sp
  051E26  63D6: c9               leave 
  051E27  63D7: cb               retf 
  051E28  63D8: b80100           mov ax, 1
  051E2B  63DB: cb               retf 

; ---- func_051E2C  size=186  insns=68  prologue=ENTER 0x0006,0  terminal=RETF ----
  051E2C  63DC: c8060000         enter 6, 0
  051E30  63E0: 56               push si
  051E31  63E1: c746fa0000       mov word ptr [bp - 6], 0
  051E36  63E6: ff7606           push word ptr [bp + 6]
  051E39  63E9: 0e               push cs
  051E3A  63EA: e8b116           call 0x7a9e
  051E3D  63ED: 83c402           add sp, 2
  051E40  63F0: 0bc0             or ax, ax
  051E42  63F2: 7503             jne 0x63f7
  051E44  63F4: e99900           jmp 0x6490
  051E47  63F7: 8b5e06           mov bx, word ptr [bp + 6]
  051E4A  63FA: 8bc3             mov ax, bx
  051E4C  63FC: d1e3             shl bx, 1
  051E4E  63FE: 03d8             add bx, ax
  051E50  6400: d1e3             shl bx, 1
  051E52  6402: 8b879097         mov ax, word ptr [bx - 0x6870]
  051E56  6406: 8946fe           mov word ptr [bp - 2], ax
  051E59  6409: 99               cdq 
  051E5A  640A: 8b1efc84         mov bx, word ptr [0x84fc]
  051E5E  640E: 3b572c           cmp dx, word ptr [bx + 0x2c]
  051E61  6411: 7c07             jl 0x641a
  051E63  6413: 7f7b             jg 0x6490
  051E65  6415: 3b472a           cmp ax, word ptr [bx + 0x2a]
  051E68  6418: 7776             ja 0x6490
  051E6A  641A: a19453           mov ax, word ptr [0x5394]
  051E6D  641D: 2d1400           sub ax, 0x14
  051E70  6420: 50               push ax
  051E71  6421: 50               push ax
  051E72  6422: ff369453         push word ptr [0x5394]
  051E76  6426: 8b5e06           mov bx, word ptr [bp + 6]
  051E79  6429: 8bc3             mov ax, bx
  051E7B  642B: d1e3             shl bx, 1
  051E7D  642D: 03d8             add bx, ax
  051E7F  642F: d1e3             shl bx, 1
  051E81  6431: 8a878d97         mov al, byte ptr [bx - 0x6873]
  051E85  6435: 2ae4             sub ah, ah
  051E87  6437: 50               push ax
  051E88  6438: 9a5c091f18       lcall 0x181f, 0x95c
  051E8D  643D: 83c408           add sp, 8
  051E90  6440: 8946fc           mov word ptr [bp - 4], ax
  051E93  6443: 0bc0             or ax, ax
  051E95  6445: 7c49             jl 0x6490
  051E97  6447: 8b1efc84         mov bx, word ptr [0x84fc]
  051E9B  644B: 8a4732           mov al, byte ptr [bx + 0x32]
  051E9E  644E: 6b76fc1c         imul si, word ptr [bp - 4], 0x1c
  051EA2  6452: 88844d31         mov byte ptr [si + 0x314d], al
  051EA6  6456: 8a4733           mov al, byte ptr [bx + 0x33]
  051EA9  6459: 88844e31         mov byte ptr [si + 0x314e], al
  051EAD  645D: 80bc46310d       cmp byte ptr [si + 0x3146], 0xd
  051EB2  6462: 7210             jb 0x6474
  051EB4  6464: 80bc463112       cmp byte ptr [si + 0x3146], 0x12
  051EB9  6469: 7709             ja 0x6474
  051EBB  646B: c6844c3100       mov byte ptr [si + 0x314c], 0
  051EC0  6470: eb0b             jmp 0x647d
  051EC2  6472: 90               nop 
  051EC3  6473: 90               nop 
  051EC4  6474: 6b5efc1c         imul bx, word ptr [bp - 4], 0x1c
  051EC8  6478: c6874c3101       mov byte ptr [bx + 0x314c], 1
  051ECD  647D: 8b46fe           mov ax, word ptr [bp - 2]
  051ED0  6480: 99               cdq 
  051ED1  6481: 8b1efc84         mov bx, word ptr [0x84fc]
  051ED5  6485: 29472a           sub word ptr [bx + 0x2a], ax
  051ED8  6488: 19572c           sbb word ptr [bx + 0x2c], dx
  051EDB  648B: c746fa0100       mov word ptr [bp - 6], 1
  051EE0  6490: 8b46fa           mov ax, word ptr [bp - 6]
  051EE3  6493: 5e               pop si
  051EE4  6494: c9               leave 
  051EE5  6495: cb               retf 

; ---- func_051EE6  size=13  insns=6  prologue=push bp;mov bp,sp  terminal=RETF ----
  051EE6  6496: 55               push bp
  051EE7  6497: 8bec             mov bp, sp
  051EE9  6499: ff7606           push word ptr [bp + 6]
  051EEC  649C: 9aa8051f1a       lcall 0x1a1f, 0x5a8
  051EF1  64A1: c9               leave 
  051EF2  64A2: cb               retf 

; ---- func_051EF4  size=4233  insns=1456  prologue=ENTER 0x0044,0  terminal=RETF ----
  051EF4  64A4: c8440000         enter 0x44, 0
  051EF8  64A8: 57               push di
  051EF9  64A9: 56               push si
  051EFA  64AA: 2bc0             sub ax, ax
  051EFC  64AC: 8946da           mov word ptr [bp - 0x26], ax
  051EFF  64AF: 8946d6           mov word ptr [bp - 0x2a], ax
  051F02  64B2: 8946f8           mov word ptr [bp - 8], ax
  051F05  64B5: 8946ee           mov word ptr [bp - 0x12], ax
  051F08  64B8: 8946ce           mov word ptr [bp - 0x32], ax
  051F0B  64BB: 8946d0           mov word ptr [bp - 0x30], ax
  051F0E  64BE: 8946e4           mov word ptr [bp - 0x1c], ax
  051F11  64C1: 8946fe           mov word ptr [bp - 2], ax
  051F14  64C4: ff7606           push word ptr [bp + 6]
  051F17  64C7: 9a82051f18       lcall 0x181f, 0x582
  051F1C  64CC: 83c402           add sp, 2
  051F1F  64CF: a18a53           mov ax, word ptr [0x538a]
  051F22  64D2: 2ddc05           sub ax, 0x5dc
  051F25  64D5: b93200           mov cx, 0x32
  051F28  64D8: 99               cdq 
  051F29  64D9: f7f9             idiv cx
  051F2B  64DB: 8b5e06           mov bx, word ptr [bp + 6]
  051F2E  64DE: 8a8f9892         mov cl, byte ptr [bx - 0x6d68]
  051F32  64E2: 2aed             sub ch, ch
  051F34  64E4: 03c8             add cx, ax
  051F36  64E6: 894ef0           mov word ptr [bp - 0x10], cx
  051F39  64E9: 833e8e5314       cmp word ptr [0x538e], 0x14
  051F3E  64EE: 7d05             jge 0x64f5
  051F40  64F0: c746f00000       mov word ptr [bp - 0x10], 0
  051F45  64F5: 813e8a53a406     cmp word ptr [0x538a], 0x6a4
  051F4B  64FB: 7c03             jl 0x6500
  051F4D  64FD: d166f0           shl word ptr [bp - 0x10], 1
  051F50  6500: a0a653           mov al, byte ptr [0x53a6]
  051F53  6503: 2ae4             sub ah, ah
  051F55  6505: f76ef0           imul word ptr [bp - 0x10]
  051F58  6508: 8946d4           mov word ptr [bp - 0x2c], ax
  051F5B  650B: 803ea65303       cmp byte ptr [0x53a6], 3
  051F60  6510: 7508             jne 0x651a
  051F62  6512: d1f8             sar ax, 1
  051F64  6514: 0346d4           add ax, word ptr [bp - 0x2c]
  051F67  6517: 8946d4           mov word ptr [bp - 0x2c], ax
  051F6A  651A: 803ea65304       cmp byte ptr [0x53a6], 4
  051F6F  651F: 7503             jne 0x6524
  051F71  6521: d166d4           shl word ptr [bp - 0x2c], 1
  051F74  6524: c166d402         shl word ptr [bp - 0x2c], 2
  051F78  6528: 8b46d4           mov ax, word ptr [bp - 0x2c]
  051F7B  652B: 99               cdq 
  051F7C  652C: 8b1efc84         mov bx, word ptr [0x84fc]
  051F80  6530: 01472a           add word ptr [bx + 0x2a], ax
  051F83  6533: 11572c           adc word ptr [bx + 0x2c], dx
  051F86  6536: c746cc0000       mov word ptr [bp - 0x34], 0
  051F8B  653B: eb34             jmp 0x6571
  051F8D  653D: 90               nop 
  051F8E  653E: 837eee00         cmp word ptr [bp - 0x12], 0
  051F92  6542: 7535             jne 0x6579
  051F94  6544: ff76cc           push word ptr [bp - 0x34]
  051F97  6547: 9ae6091f18       lcall 0x181f, 0x9e6
  051F9C  654C: 83c402           add sp, 2
  051F9F  654F: 8a4606           mov al, byte ptr [bp + 6]
  051FA2  6552: 8b1e4285         mov bx, word ptr [0x8542]
  051FA6  6556: 38471a           cmp byte ptr [bx + 0x1a], al
  051FA9  6559: 7513             jne 0x656e
  051FAB  655B: 6a0d             push 0xd
  051FAD  655D: 9afc091f18       lcall 0x181f, 0x9fc
  051FB2  6562: 83c402           add sp, 2
  051FB5  6565: 0bc0             or ax, ax
  051FB7  6567: 7405             je 0x656e
  051FB9  6569: c746ee0100       mov word ptr [bp - 0x12], 1
  051FBE  656E: ff46cc           inc word ptr [bp - 0x34]
  051FC1  6571: a19e53           mov ax, word ptr [0x539e]
  051FC4  6574: 3946cc           cmp word ptr [bp - 0x34], ax
  051FC7  6577: 7cc5             jl 0x653e
  051FC9  6579: f606825301       test byte ptr [0x5382], 1
  051FCE  657E: 7447             je 0x65c7
  051FD0  6580: 8b4606           mov ax, word ptr [bp + 6]
  051FD3  6583: 2d1400           sub ax, 0x14
  051FD6  6586: 8bd0             mov dx, ax
  051FD8  6588: 9ae0071f18       lcall 0x181f, 0x7e0
  051FDD  658D: eb09             jmp 0x6598
  051FDF  658F: 90               nop 
  051FE0  6590: 8b46be           mov ax, word ptr [bp - 0x42]
  051FE3  6593: 9ae4021f18       lcall 0x181f, 0x2e4
  051FE8  6598: 8946be           mov word ptr [bp - 0x42], ax
  051FEB  659B: 0bc0             or ax, ax
  051FED  659D: 7c28             jl 0x65c7
  051FEF  659F: 6bd81c           imul bx, ax, 0x1c
  051FF2  65A2: 8a874731         mov al, byte ptr [bx + 0x3147]
  051FF6  65A6: 240f             and al, 0xf
  051FF8  65A8: 3a4606           cmp al, byte ptr [bp + 6]
  051FFB  65AB: 75e3             jne 0x6590
  051FFD  65AD: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052001  65B1: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  052006  65B6: 75d8             jne 0x6590
  052008  65B8: ff76be           push word ptr [bp - 0x42]
  05200B  65BB: 9a08081f18       lcall 0x181f, 0x808
  052010  65C0: 83c402           add sp, 2
  052013  65C3: ff06de53         inc word ptr [0x53de]
  052017  65C7: 8b5e06           mov bx, word ptr [bp + 6]
  05201A  65CA: 80bf189401       cmp byte ptr [bx - 0x6be8], 1
  05201F  65CF: 7305             jae 0x65d6
  052021  65D1: b80100           mov ax, 1
  052024  65D4: eb02             jmp 0x65d8
  052026  65D6: 2bc0             sub ax, ax
  052028  65D8: 8946e2           mov word ptr [bp - 0x1e], ax
  05202B  65DB: 2bc0             sub ax, ax
  05202D  65DD: 8946c6           mov word ptr [bp - 0x3a], ax
  052030  65E0: 8946cc           mov word ptr [bp - 0x34], ax
  052033  65E3: eb23             jmp 0x6608
  052035  65E5: 90               nop 
  052036  65E6: 8b4606           mov ax, word ptr [bp + 6]
  052039  65E9: 3946cc           cmp word ptr [bp - 0x34], ax
  05203C  65EC: 7417             je 0x6605
  05203E  65EE: 6b5ecc13         imul bx, word ptr [bp - 0x34], 0x13
  052042  65F2: 8a875c92         mov al, byte ptr [bx - 0x6da4]
  052046  65F6: 2ae4             sub ah, ah
  052048  65F8: 0146c6           add word ptr [bp - 0x3a], ax
  05204B  65FB: 8a875d92         mov al, byte ptr [bx - 0x6da3]
  05204F  65FF: c1e002           shl ax, 2
  052052  6602: 0146c6           add word ptr [bp - 0x3a], ax
  052055  6605: ff46cc           inc word ptr [bp - 0x34]
  052058  6608: 837ecc04         cmp word ptr [bp - 0x34], 4
  05205C  660C: 7cd8             jl 0x65e6
  05205E  660E: c17ec602         sar word ptr [bp - 0x3a], 2
  052062  6612: f606825301       test byte ptr [0x5382], 1
  052067  6617: 7405             je 0x661e
  052069  6619: c746c60000       mov word ptr [bp - 0x3a], 0
  05206E  661E: 803e9ba800       cmp byte ptr [0xa89b], 0
  052073  6623: 7507             jne 0x662c
  052075  6625: 803e9aa800       cmp byte ptr [0xa89a], 0
  05207A  662A: 745c             je 0x6688
  05207C  662C: 837ec600         cmp word ptr [bp - 0x3a], 0
  052080  6630: 7456             je 0x6688
  052082  6632: 8b5e06           mov bx, word ptr [bp + 6]
  052085  6635: 8a879892         mov al, byte ptr [bx - 0x6d68]
  052089  6639: d0e8             shr al, 1
  05208B  663B: 3a069ba8         cmp al, byte ptr [0xa89b]
  05208F  663F: 7629             jbe 0x666a
  052091  6641: 8a870c94         mov al, byte ptr [bx - 0x6bf4]
  052095  6645: d0e8             shr al, 1
  052097  6647: 2ae4             sub ah, ah
  052099  6649: 3b06529e         cmp ax, word ptr [0x9e52]
  05209D  664D: 7e1b             jle 0x666a
  05209F  664F: 813e8e53c800     cmp word ptr [0x538e], 0xc8
  0520A5  6655: 7e31             jle 0x6688
  0520A7  6657: 8b1efc84         mov bx, word ptr [0x84fc]
  0520AB  665B: 837f2c00         cmp word ptr [bx + 0x2c], 0
  0520AF  665F: 7c27             jl 0x6688
  0520B1  6661: 7f07             jg 0x666a
  0520B3  6663: 817f2ad007       cmp word ptr [bx + 0x2a], 0x7d0
  0520B8  6668: 721e             jb 0x6688
  0520BA  666A: 6b5e0613         imul bx, word ptr [bp + 6], 0x13
  0520BE  666E: 80bf5d9200       cmp byte ptr [bx - 0x6da3], 0
  0520C3  6673: 7513             jne 0x6688
  0520C5  6675: 6b1e985313       imul bx, word ptr [0x5398], 0x13
  0520CA  667A: 80bf5d9200       cmp byte ptr [bx - 0x6da3], 0
  0520CF  667F: 7407             je 0x6688
  0520D1  6681: c746f40100       mov word ptr [bp - 0xc], 1
  0520D6  6686: eb05             jmp 0x668d
  0520D8  6688: c746f40000       mov word ptr [bp - 0xc], 0
  0520DD  668D: 803e9ba800       cmp byte ptr [0xa89b], 0
  0520E2  6692: 7507             jne 0x669b
  0520E4  6694: 803e9aa800       cmp byte ptr [0xa89a], 0
  0520E9  6699: 7461             je 0x66fc
  0520EB  669B: 837ec600         cmp word ptr [bp - 0x3a], 0
  0520EF  669F: 745b             je 0x66fc
  0520F1  66A1: 837ef400         cmp word ptr [bp - 0xc], 0
  0520F5  66A5: 7555             jne 0x66fc
  0520F7  66A7: 8b5e06           mov bx, word ptr [bp + 6]
  0520FA  66AA: 8a879892         mov al, byte ptr [bx - 0x6d68]
  0520FE  66AE: d0e8             shr al, 1
  052100  66B0: 3a069aa8         cmp al, byte ptr [0xa89a]
  052104  66B4: 7628             jbe 0x66de
  052106  66B6: 8a870c94         mov al, byte ptr [bx - 0x6bf4]
  05210A  66BA: d0e8             shr al, 1
  05210C  66BC: 2ae4             sub ah, ah
  05210E  66BE: 3b06549e         cmp ax, word ptr [0x9e54]
  052112  66C2: 7e1a             jle 0x66de
  052114  66C4: 833e8e5364       cmp word ptr [0x538e], 0x64
  052119  66C9: 7e31             jle 0x66fc
  05211B  66CB: 8b1efc84         mov bx, word ptr [0x84fc]
  05211F  66CF: 837f2c00         cmp word ptr [bx + 0x2c], 0
  052123  66D3: 7c27             jl 0x66fc
  052125  66D5: 7f07             jg 0x66de
  052127  66D7: 817f2ae803       cmp word ptr [bx + 0x2a], 0x3e8
  05212C  66DC: 721e             jb 0x66fc
  05212E  66DE: 6b5e0613         imul bx, word ptr [bp + 6], 0x13
  052132  66E2: 80bf5c9202       cmp byte ptr [bx - 0x6da4], 2
  052137  66E7: 7313             jae 0x66fc
  052139  66E9: 6b1e985313       imul bx, word ptr [0x5398], 0x13
  05213E  66EE: 80bf5c9200       cmp byte ptr [bx - 0x6da4], 0
  052143  66F3: 7407             je 0x66fc
  052145  66F5: c746f20100       mov word ptr [bp - 0xe], 1
  05214A  66FA: eb05             jmp 0x6701
  05214C  66FC: c746f20000       mov word ptr [bp - 0xe], 0
  052151  6701: 837ee200         cmp word ptr [bp - 0x1e], 0
  052155  6705: 741a             je 0x6721
  052157  6707: a19697           mov ax, word ptr [0x9796]
  05215A  670A: 99               cdq 
  05215B  670B: 8b1efc84         mov bx, word ptr [0x84fc]
  05215F  670F: 39572c           cmp word ptr [bx + 0x2c], dx
  052162  6712: 7f0d             jg 0x6721
  052164  6714: 7c05             jl 0x671b
  052166  6716: 39472a           cmp word ptr [bx + 0x2a], ax
  052169  6719: 7306             jae 0x6721
  05216B  671B: 89472a           mov word ptr [bx + 0x2a], ax
  05216E  671E: 89572c           mov word ptr [bx + 0x2c], dx
  052171  6721: 837ef200         cmp word ptr [bp - 0xe], 0
  052175  6725: 741a             je 0x6741
  052177  6727: a1a897           mov ax, word ptr [0x97a8]
  05217A  672A: 99               cdq 
  05217B  672B: 8b1efc84         mov bx, word ptr [0x84fc]
  05217F  672F: 39572c           cmp word ptr [bx + 0x2c], dx
  052182  6732: 7f0d             jg 0x6741
  052184  6734: 7c05             jl 0x673b
  052186  6736: 39472a           cmp word ptr [bx + 0x2a], ax
  052189  6739: 7306             jae 0x6741
  05218B  673B: 89472a           mov word ptr [bx + 0x2a], ax
  05218E  673E: 89572c           mov word ptr [bx + 0x2c], dx
  052191  6741: 837ef400         cmp word ptr [bp - 0xc], 0
  052195  6745: 741a             je 0x6761
  052197  6747: a1ae97           mov ax, word ptr [0x97ae]
  05219A  674A: 99               cdq 
  05219B  674B: 8b1efc84         mov bx, word ptr [0x84fc]
  05219F  674F: 39572c           cmp word ptr [bx + 0x2c], dx
  0521A2  6752: 7f0d             jg 0x6761
  0521A4  6754: 7c05             jl 0x675b
  0521A6  6756: 39472a           cmp word ptr [bx + 0x2a], ax
  0521A9  6759: 7306             jae 0x6761
  0521AB  675B: 89472a           mov word ptr [bx + 0x2a], ax
  0521AE  675E: 89572c           mov word ptr [bx + 0x2c], dx
  0521B1  6761: 2bc0             sub ax, ax
  0521B3  6763: 8946dc           mov word ptr [bp - 0x24], ax
  0521B6  6766: 8946d2           mov word ptr [bp - 0x2e], ax
  0521B9  6769: 8946cc           mov word ptr [bp - 0x34], ax
  0521BC  676C: eb17             jmp 0x6785
  0521BE  676E: 8b5ecc           mov bx, word ptr [bp - 0x34]
  0521C1  6771: 8a872494         mov al, byte ptr [bx - 0x6bdc]
  0521C5  6775: 2ae4             sub ah, ah
  0521C7  6777: 3b46d2           cmp ax, word ptr [bp - 0x2e]
  0521CA  677A: 7d03             jge 0x677f
  0521CC  677C: 8b46d2           mov ax, word ptr [bp - 0x2e]
  0521CF  677F: 8946d2           mov word ptr [bp - 0x2e], ax
  0521D2  6782: ff46cc           inc word ptr [bp - 0x34]
  0521D5  6785: 837ecc04         cmp word ptr [bp - 0x34], 4
  0521D9  6789: 7ce3             jl 0x676e
  0521DB  678B: c746cc0000       mov word ptr [bp - 0x34], 0
  0521E0  6790: 8b5ecc           mov bx, word ptr [bp - 0x34]
  0521E3  6793: 8a872494         mov al, byte ptr [bx - 0x6bdc]
  0521E7  6797: 2ae4             sub ah, ah
  0521E9  6799: 3b46d2           cmp ax, word ptr [bp - 0x2e]
  0521EC  679C: 7503             jne 0x67a1
  0521EE  679E: ff46dc           inc word ptr [bp - 0x24]
  0521F1  67A1: ff46cc           inc word ptr [bp - 0x34]
  0521F4  67A4: 837ecc04         cmp word ptr [bp - 0x34], 4
  0521F8  67A8: 7ce6             jl 0x6790
  0521FA  67AA: 837ef400         cmp word ptr [bp - 0xc], 0
  0521FE  67AE: 7514             jne 0x67c4
  052200  67B0: 8b5e06           mov bx, word ptr [bp + 6]
  052203  67B3: 8a872494         mov al, byte ptr [bx - 0x6bdc]
  052207  67B7: 2ae4             sub ah, ah
  052209  67B9: 3b46d2           cmp ax, word ptr [bp - 0x2e]
  05220C  67BC: 7c06             jl 0x67c4
  05220E  67BE: 837edc01         cmp word ptr [bp - 0x24], 1
  052212  67C2: 7e08             jle 0x67cc
  052214  67C4: c746fc0100       mov word ptr [bp - 4], 1
  052219  67C9: eb06             jmp 0x67d1
  05221B  67CB: 90               nop 
  05221C  67CC: c746fc0000       mov word ptr [bp - 4], 0
  052221  67D1: 8b5e06           mov bx, word ptr [bp + 6]
  052224  67D4: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  052228  67D8: d0e8             shr al, 1
  05222A  67DA: 2ae4             sub ah, ah
  05222C  67DC: 8a8f9892         mov cl, byte ptr [bx - 0x6d68]
  052230  67E0: 2aed             sub ch, ch
  052232  67E2: d1e1             shl cx, 1
  052234  67E4: 03c1             add ax, cx
  052236  67E6: d1f8             sar ax, 1
  052238  67E8: 3a871494         cmp al, byte ptr [bx - 0x6bec]
  05223C  67EC: 720c             jb 0x67fa
  05223E  67EE: f606825301       test byte ptr [0x5382], 1
  052243  67F3: 7505             jne 0x67fa
  052245  67F5: c746d00100       mov word ptr [bp - 0x30], 1
  05224A  67FA: f606825301       test byte ptr [0x5382], 1
  05224F  67FF: 7403             je 0x6804
  052251  6801: e94201           jmp 0x6946
  052254  6804: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  052258  6808: d0e8             shr al, 1
  05225A  680A: 2ae4             sub ah, ah
  05225C  680C: 8a8f9892         mov cl, byte ptr [bx - 0x6d68]
  052260  6810: 2aed             sub ch, ch
  052262  6812: 03c1             add ax, cx
  052264  6814: 8a8f1494         mov cl, byte ptr [bx - 0x6bec]
  052268  6818: 3bc1             cmp ax, cx
  05226A  681A: 7d03             jge 0x681f
  05226C  681C: e92701           jmp 0x6946
  05226F  681F: c746c40000       mov word ptr [bp - 0x3c], 0
  052274  6824: 837ef400         cmp word ptr [bp - 0xc], 0
  052278  6828: 740e             je 0x6838
  05227A  682A: 6a64             push 0x64
  05227C  682C: 6a05             push 5
  05227E  682E: 0e               push cs
  05227F  682F: e87b12           call 0x7aad
  052282  6832: 83c404           add sp, 4
  052285  6835: 8946c4           mov word ptr [bp - 0x3c], ax
  052288  6838: 837ec400         cmp word ptr [bp - 0x3c], 0
  05228C  683C: 7509             jne 0x6847
  05228E  683E: 837ef400         cmp word ptr [bp - 0xc], 0
  052292  6842: 7403             je 0x6847
  052294  6844: e9e20c           jmp 0x7529
  052297  6847: 837ef200         cmp word ptr [bp - 0xe], 0
  05229B  684B: 740e             je 0x685b
  05229D  684D: 6a64             push 0x64
  05229F  684F: 6a04             push 4
  0522A1  6851: 0e               push cs
  0522A2  6852: e85812           call 0x7aad
  0522A5  6855: 83c404           add sp, 4
  0522A8  6858: 8946c4           mov word ptr [bp - 0x3c], ax
  0522AB  685B: 837ec400         cmp word ptr [bp - 0x3c], 0
  0522AF  685F: 7509             jne 0x686a
  0522B1  6861: 837ef200         cmp word ptr [bp - 0xe], 0
  0522B5  6865: 7403             je 0x686a
  0522B7  6867: e9bf0c           jmp 0x7529
  0522BA  686A: 837ec400         cmp word ptr [bp - 0x3c], 0
  0522BE  686E: 752e             jne 0x689e
  0522C0  6870: 8b5e06           mov bx, word ptr [bp + 6]
  0522C3  6873: 80bf249408       cmp byte ptr [bx - 0x6bdc], 8
  0522C8  6878: 7324             jae 0x689e
  0522CA  687A: 6a01             push 1
  0522CC  687C: 6a00             push 0
  0522CE  687E: 9ad4041f18       lcall 0x181f, 0x4d4
  0522D3  6883: 83c404           add sp, 4
  0522D6  6886: 0bc0             or ax, ax
  0522D8  6888: 7414             je 0x689e
  0522DA  688A: 837efc00         cmp word ptr [bp - 4], 0
  0522DE  688E: 740e             je 0x689e
  0522E0  6890: 6a23             push 0x23
  0522E2  6892: 6a05             push 5
  0522E4  6894: 0e               push cs
  0522E5  6895: e81512           call 0x7aad
  0522E8  6898: 83c404           add sp, 4
  0522EB  689B: 8946c4           mov word ptr [bp - 0x3c], ax
  0522EE  689E: 837ec400         cmp word ptr [bp - 0x3c], 0
  0522F2  68A2: 751e             jne 0x68c2
  0522F4  68A4: 6a03             push 3
  0522F6  68A6: 6a00             push 0
  0522F8  68A8: 9ad4041f18       lcall 0x181f, 0x4d4
  0522FD  68AD: 83c404           add sp, 4
  052300  68B0: 0bc0             or ax, ax
  052302  68B2: 740e             je 0x68c2
  052304  68B4: 6a32             push 0x32
  052306  68B6: 6a03             push 3
  052308  68B8: 0e               push cs
  052309  68B9: e8f111           call 0x7aad
  05230C  68BC: 83c404           add sp, 4
  05230F  68BF: 8946c4           mov word ptr [bp - 0x3c], ax
  052312  68C2: 837ec400         cmp word ptr [bp - 0x3c], 0
  052316  68C6: 7528             jne 0x68f0
  052318  68C8: 6a01             push 1
  05231A  68CA: 6a00             push 0
  05231C  68CC: 9ad4041f18       lcall 0x181f, 0x4d4
  052321  68D1: 83c404           add sp, 4
  052324  68D4: 0bc0             or ax, ax
  052326  68D6: 7518             jne 0x68f0
  052328  68D8: 8b5e06           mov bx, word ptr [bp + 6]
  05232B  68DB: 80bf14940c       cmp byte ptr [bx - 0x6bec], 0xc
  052330  68E0: 730e             jae 0x68f0
  052332  68E2: 6a14             push 0x14
  052334  68E4: 6a02             push 2
  052336  68E6: 0e               push cs
  052337  68E7: e8c311           call 0x7aad
  05233A  68EA: 83c404           add sp, 4
  05233D  68ED: 8946c4           mov word ptr [bp - 0x3c], ax
  052340  68F0: 837ec400         cmp word ptr [bp - 0x3c], 0
  052344  68F4: 7518             jne 0x690e
  052346  68F6: 8b5e06           mov bx, word ptr [bp + 6]
  052349  68F9: 80bf149402       cmp byte ptr [bx - 0x6bec], 2
  05234E  68FE: 770e             ja 0x690e
  052350  6900: 6a14             push 0x14
  052352  6902: 6a01             push 1
  052354  6904: 0e               push cs
  052355  6905: e8a511           call 0x7aad
  052358  6908: 83c404           add sp, 4
  05235B  690B: 8946c4           mov word ptr [bp - 0x3c], ax
  05235E  690E: 837ec400         cmp word ptr [bp - 0x3c], 0
  052362  6912: 7532             jne 0x6946
  052364  6914: 8b5e06           mov bx, word ptr [bp + 6]
  052367  6917: 80bf249404       cmp byte ptr [bx - 0x6bdc], 4
  05236C  691C: 7328             jae 0x6946
  05236E  691E: 6a03             push 3
  052370  6920: 6a00             push 0
  052372  6922: 9ad4041f18       lcall 0x181f, 0x4d4
  052377  6927: 83c404           add sp, 4
  05237A  692A: 0bc0             or ax, ax
  05237C  692C: 7518             jne 0x6946
  05237E  692E: 3946fc           cmp word ptr [bp - 4], ax
  052381  6931: 7413             je 0x6946
  052383  6933: 3946d0           cmp word ptr [bp - 0x30], ax
  052386  6936: 750e             jne 0x6946
  052388  6938: 6a1e             push 0x1e
  05238A  693A: 6a04             push 4
  05238C  693C: 0e               push cs
  05238D  693D: e86d11           call 0x7aad
  052390  6940: 83c404           add sp, 4
  052393  6943: 8946c4           mov word ptr [bp - 0x3c], ax
  052396  6946: 837ec400         cmp word ptr [bp - 0x3c], 0
  05239A  694A: 7509             jne 0x6955
  05239C  694C: 837ee200         cmp word ptr [bp - 0x1e], 0
  0523A0  6950: 7403             je 0x6955
  0523A2  6952: e9d40b           jmp 0x7529
  0523A5  6955: 6a0c             push 0xc
  0523A7  6957: 8b4606           mov ax, word ptr [bp + 6]
  0523AA  695A: 2d1400           sub ax, 0x14
  0523AD  695D: 8bd0             mov dx, ax
  0523AF  695F: 8bf0             mov si, ax
  0523B1  6961: 9ae0071f18       lcall 0x181f, 0x7e0
  0523B6  6966: 8946ec           mov word ptr [bp - 0x14], ax
  0523B9  6969: 50               push ax
  0523BA  696A: 9abc081f18       lcall 0x181f, 0x8bc
  0523BF  696F: 83c404           add sp, 4
  0523C2  6972: 8946ce           mov word ptr [bp - 0x32], ax
  0523C5  6975: 0bc0             or ax, ax
  0523C7  6977: 7550             jne 0x69c9
  0523C9  6979: f606825301       test byte ptr [0x5382], 1
  0523CE  697E: 7549             jne 0x69c9
  0523D0  6980: 803edba000       cmp byte ptr [0xa0db], 0
  0523D5  6985: 7e42             jle 0x69c9
  0523D7  6987: 6a03             push 3
  0523D9  6989: 50               push ax
  0523DA  698A: 9ad4041f18       lcall 0x181f, 0x4d4
  0523DF  698F: 83c404           add sp, 4
  0523E2  6992: 0bc0             or ax, ax
  0523E4  6994: 7533             jne 0x69c9
  0523E6  6996: 3946d0           cmp word ptr [bp - 0x30], ax
  0523E9  6999: 752e             jne 0x69c9
  0523EB  699B: 8b5e06           mov bx, word ptr [bp + 6]
  0523EE  699E: 80bf149404       cmp byte ptr [bx - 0x6bec], 4
  0523F3  69A3: 7624             jbe 0x69c9
  0523F5  69A5: 6a14             push 0x14
  0523F7  69A7: 50               push ax
  0523F8  69A8: 0e               push cs
  0523F9  69A9: e80111           call 0x7aad
  0523FC  69AC: 83c404           add sp, 4
  0523FF  69AF: 6a0c             push 0xc
  052401  69B1: 8bc6             mov ax, si
  052403  69B3: 8bd0             mov dx, ax
  052405  69B5: 9ae0071f18       lcall 0x181f, 0x7e0
  05240A  69BA: 8946ec           mov word ptr [bp - 0x14], ax
  05240D  69BD: 50               push ax
  05240E  69BE: 9abc081f18       lcall 0x181f, 0x8bc
  052413  69C3: 83c404           add sp, 4
  052416  69C6: 8946ce           mov word ptr [bp - 0x32], ax
  052419  69C9: ff7606           push word ptr [bp + 6]
  05241C  69CC: 0e               push cs
  05241D  69CD: e8b010           call 0x7a80
  052420  69D0: 83c402           add sp, 2
  052423  69D3: 8946fa           mov word ptr [bp - 6], ax
  052426  69D6: 8b46ec           mov ax, word ptr [bp - 0x14]
  052429  69D9: eb1f             jmp 0x69fa
  05242B  69DB: 90               nop 
  05242C  69DC: 6bd81c           imul bx, ax, 0x1c
  05242F  69DF: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  052434  69E4: 7207             jb 0x69ed
  052436  69E6: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05243B  69EB: 7605             jbe 0x69f2
  05243D  69ED: c746d60100       mov word ptr [bp - 0x2a], 1
  052442  69F2: 8b46be           mov ax, word ptr [bp - 0x42]
  052445  69F5: 9ae4021f18       lcall 0x181f, 0x2e4
  05244A  69FA: 8946be           mov word ptr [bp - 0x42], ax
  05244D  69FD: 0bc0             or ax, ax
  05244F  69FF: 7ddb             jge 0x69dc
  052451  6A01: a18e53           mov ax, word ptr [0x538e]
  052454  6A04: b90300           mov cx, 3
  052457  6A07: 99               cdq 
  052458  6A08: f7f9             idiv cx
  05245A  6A0A: 0bd2             or dx, dx
  05245C  6A0C: 7505             jne 0x6a13
  05245E  6A0E: c746fe0100       mov word ptr [bp - 2], 1
  052463  6A13: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052467  6A17: f687483120       test byte ptr [bx + 0x3148], 0x20
  05246C  6A1C: 7405             je 0x6a23
  05246E  6A1E: c746fe0100       mov word ptr [bp - 2], 1
  052473  6A23: 8b5e06           mov bx, word ptr [bp + 6]
  052476  6A26: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  05247B  6A2B: 7505             jne 0x6a32
  05247D  6A2D: c746fe0000       mov word ptr [bp - 2], 0
  052482  6A32: f606825301       test byte ptr [0x5382], 1
  052487  6A37: 7403             je 0x6a3c
  052489  6A39: e9e000           jmp 0x6b1c
  05248C  6A3C: 837ed600         cmp word ptr [bp - 0x2a], 0
  052490  6A40: 7403             je 0x6a45
  052492  6A42: e9d700           jmp 0x6b1c
  052495  6A45: 837ed000         cmp word ptr [bp - 0x30], 0
  052499  6A49: 7403             je 0x6a4e
  05249B  6A4B: e9ce00           jmp 0x6b1c
  05249E  6A4E: 837efe00         cmp word ptr [bp - 2], 0
  0524A2  6A52: 7403             je 0x6a57
  0524A4  6A54: e9c500           jmp 0x6b1c
  0524A7  6A57: 8a87b8a0         mov al, byte ptr [bx - 0x5f48]
  0524AB  6A5B: 98               cwde 
  0524AC  6A5C: 8a8f0894         mov cl, byte ptr [bx - 0x6bf8]
  0524B0  6A60: 2aed             sub ch, ch
  0524B2  6A62: 2bc1             sub ax, cx
  0524B4  6A64: 8a8f9892         mov cl, byte ptr [bx - 0x6d68]
  0524B8  6A68: d0e9             shr cl, 1
  0524BA  6A6A: 3bc1             cmp ax, cx
  0524BC  6A6C: 7d03             jge 0x6a71
  0524BE  6A6E: e9ab00           jmp 0x6b1c
  0524C1  6A71: 8b36fc84         mov si, word ptr [0x84fc]
  0524C5  6A75: 8b4430           mov ax, word ptr [si + 0x30]
  0524C8  6A78: 99               cdq 
  0524C9  6A79: b9ffff           mov cx, 0xffff
  0524CC  6A7C: 8bf9             mov di, cx
  0524CE  6A7E: 2bc8             sub cx, ax
  0524D0  6A80: 1bfa             sbb di, dx
  0524D2  6A82: 57               push di
  0524D3  6A83: 51               push cx
  0524D4  6A84: 8a4406           mov al, byte ptr [si + 6]
  0524D7  6A87: 2ae4             sub ah, ah
  0524D9  6A89: 8a0ea653         mov cl, byte ptr [0x53a6]
  0524DD  6A8D: 2aed             sub ch, ch
  0524DF  6A8F: 2bc1             sub ax, cx
  0524E1  6A91: 050700           add ax, 7
  0524E4  6A94: 6bc014           imul ax, ax, 0x14
  0524E7  6A97: 8bc8             mov cx, ax
  0524E9  6A99: f76c2e           imul word ptr [si + 0x2e]
  0524EC  6A9C: 52               push dx
  0524ED  6A9D: 50               push ax
  0524EE  6A9E: 8bf9             mov di, cx
  0524F0  6AA0: 9ac60e1d0d       lcall 0xd1d, 0xec6
  0524F5  6AA5: 8b5e06           mov bx, word ptr [bp + 6]
  0524F8  6AA8: 8bc8             mov cx, ax
  0524FA  6AAA: b01e             mov al, 0x1e
  0524FC  6AAC: f6a71094         mul byte ptr [bx - 0x6bf0]
  052500  6AB0: 2b068e53         sub ax, word ptr [0x538e]
  052504  6AB4: d1e0             shl ax, 1
  052506  6AB6: 0bc0             or ax, ax
  052508  6AB8: 7d02             jge 0x6abc
  05250A  6ABA: 2bc0             sub ax, ax
  05250C  6ABC: 8bd8             mov bx, ax
  05250E  6ABE: 8bc1             mov ax, cx
  052510  6AC0: 03c7             add ax, di
  052512  6AC2: 8946ca           mov word ptr [bp - 0x36], ax
  052515  6AC5: 03c3             add ax, bx
  052517  6AC7: 99               cdq 
  052518  6AC8: 3b542c           cmp dx, word ptr [si + 0x2c]
  05251B  6ACB: 7f4f             jg 0x6b1c
  05251D  6ACD: 7c05             jl 0x6ad4
  05251F  6ACF: 3b442a           cmp ax, word ptr [si + 0x2a]
  052522  6AD2: 7748             ja 0x6b1c
  052524  6AD4: 8b46ca           mov ax, word ptr [bp - 0x36]
  052527  6AD7: 99               cdq 
  052528  6AD8: 29442a           sub word ptr [si + 0x2a], ax
  05252B  6ADB: 19542c           sbb word ptr [si + 0x2c], dx
  05252E  6ADE: 6a02             push 2
  052530  6AE0: 6a00             push 0
  052532  6AE2: 9ad4041f18       lcall 0x181f, 0x4d4
  052537  6AE7: 83c404           add sp, 4
  05253A  6AEA: 8946ea           mov word ptr [bp - 0x16], ax
  05253D  6AED: 8b1efc84         mov bx, word ptr [0x84fc]
  052541  6AF1: 8bf0             mov si, ax
  052543  6AF3: 8a4002           mov al, byte ptr [bx + si + 2]
  052546  6AF6: 2ae4             sub ah, ah
  052548  6AF8: 50               push ax
  052549  6AF9: 9a260b1f19       lcall 0x191f, 0xb26
  05254E  6AFE: 83c402           add sp, 2
  052551  6B01: 8946be           mov word ptr [bp - 0x42], ax
  052554  6B04: 0bc0             or ax, ax
  052556  6B06: 7c14             jl 0x6b1c
  052558  6B08: 8946ec           mov word ptr [bp - 0x14], ax
  05255B  6B0B: 6a00             push 0
  05255D  6B0D: 9afc0a1f19       lcall 0x191f, 0xafc
  052562  6B12: 83c402           add sp, 2
  052565  6B15: 8b1efc84         mov bx, word ptr [0x84fc]
  052569  6B19: 884002           mov byte ptr [bx + si + 2], al
  05256C  6B1C: c746c80000       mov word ptr [bp - 0x38], 0
  052571  6B21: e9b503           jmp 0x6ed9
  052574  6B24: 837ec800         cmp word ptr [bp - 0x38], 0
  052578  6B28: 7442             je 0x6b6c
  05257A  6B2A: 8b46be           mov ax, word ptr [bp - 0x42]
  05257D  6B2D: 9ae4021f18       lcall 0x181f, 0x2e4
  052582  6B32: 8946be           mov word ptr [bp - 0x42], ax
  052585  6B35: 0bc0             or ax, ax
  052587  6B37: 7d03             jge 0x6b3c
  052589  6B39: e99a03           jmp 0x6ed6
  05258C  6B3C: f606825301       test byte ptr [0x5382], 1
  052591  6B41: 75e7             jne 0x6b2a
  052593  6B43: 50               push ax
  052594  6B44: 9a780b1f18       lcall 0x181f, 0xb78
  052599  6B49: 83c402           add sp, 2
  05259C  6B4C: 0bc0             or ax, ax
  05259E  6B4E: 7cda             jl 0x6b2a
  0525A0  6B50: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  0525A4  6B54: 8a875b31         mov al, byte ptr [bx + 0x315b]
  0525A8  6B58: 98               cwde 
  0525A9  6B59: 50               push ax
  0525AA  6B5A: 9a9a0c1f18       lcall 0x181f, 0xc9a
  0525AF  6B5F: 83c402           add sp, 2
  0525B2  6B62: 0bc0             or ax, ax
  0525B4  6B64: 74be             je 0x6b24
  0525B6  6B66: 837ec800         cmp word ptr [bp - 0x38], 0
  0525BA  6B6A: 74be             je 0x6b2a
  0525BC  6B6C: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  0525C0  6B70: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  0525C5  6B75: 7506             jne 0x6b7d
  0525C7  6B77: 8b46fa           mov ax, word ptr [bp - 6]
  0525CA  6B7A: 0946da           or word ptr [bp - 0x26], ax
  0525CD  6B7D: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  0525D1  6B81: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  0525D6  6B86: 7403             je 0x6b8b
  0525D8  6B88: e9bd02           jmp 0x6e48
  0525DB  6B8B: 837efe00         cmp word ptr [bp - 2], 0
  0525DF  6B8F: 7403             je 0x6b94
  0525E1  6B91: e9b402           jmp 0x6e48
  0525E4  6B94: c746f60000       mov word ptr [bp - 0xa], 0
  0525E9  6B99: 8a875b31         mov al, byte ptr [bx + 0x315b]
  0525ED  6B9D: 98               cwde 
  0525EE  6B9E: 50               push ax
  0525EF  6B9F: 9a9a0c1f18       lcall 0x181f, 0xc9a
  0525F4  6BA4: 83c402           add sp, 2
  0525F7  6BA7: 0bc0             or ax, ax
  0525F9  6BA9: 7405             je 0x6bb0
  0525FB  6BAB: c746f60100       mov word ptr [bp - 0xa], 1
  052600  6BB0: 803edba000       cmp byte ptr [0xa0db], 0
  052605  6BB5: 7e13             jle 0x6bca
  052607  6BB7: 8b46f6           mov ax, word ptr [bp - 0xa]
  05260A  6BBA: 40               inc ax
  05260B  6BBB: 50               push ax
  05260C  6BBC: 6a00             push 0
  05260E  6BBE: 9ad4041f18       lcall 0x181f, 0x4d4
  052613  6BC3: 83c404           add sp, 4
  052616  6BC6: 0bc0             or ax, ax
  052618  6BC8: 742a             je 0x6bf4
  05261A  6BCA: 837efa00         cmp word ptr [bp - 6], 0
  05261E  6BCE: 7503             jne 0x6bd3
  052620  6BD0: e99901           jmp 0x6d6c
  052623  6BD3: 8b46f6           mov ax, word ptr [bp - 0xa]
  052626  6BD6: 40               inc ax
  052627  6BD7: 40               inc ax
  052628  6BD8: 50               push ax
  052629  6BD9: 6a00             push 0
  05262B  6BDB: 9ad4041f18       lcall 0x181f, 0x4d4
  052630  6BE0: 83c404           add sp, 4
  052633  6BE3: 0bc0             or ax, ax
  052635  6BE5: 7403             je 0x6bea
  052637  6BE7: e98201           jmp 0x6d6c
  05263A  6BEA: 833e8e5364       cmp word ptr [0x538e], 0x64
  05263F  6BEF: 7d03             jge 0x6bf4
  052641  6BF1: e97801           jmp 0x6d6c
  052644  6BF4: 6a0f             push 0xf
  052646  6BF6: 9a3e0c1f19       lcall 0x191f, 0xc3e
  05264B  6BFB: 83c402           add sp, 2
  05264E  6BFE: 6bc032           imul ax, ax, 0x32
  052651  6C01: 8946e8           mov word ptr [bp - 0x18], ax
  052654  6C04: 8b1efc84         mov bx, word ptr [0x84fc]
  052658  6C08: 807f4900         cmp byte ptr [bx + 0x49], 0
  05265C  6C0C: 7405             je 0x6c13
  05265E  6C0E: c746e80000       mov word ptr [bp - 0x18], 0
  052663  6C13: 8b46e8           mov ax, word ptr [bp - 0x18]
  052666  6C16: 99               cdq 
  052667  6C17: 39572c           cmp word ptr [bx + 0x2c], dx
  05266A  6C1A: 7d03             jge 0x6c1f
  05266C  6C1C: e94d01           jmp 0x6d6c
  05266F  6C1F: 7f08             jg 0x6c29
  052671  6C21: 39472a           cmp word ptr [bx + 0x2a], ax
  052674  6C24: 7303             jae 0x6c29
  052676  6C26: e94301           jmp 0x6d6c
  052679  6C29: 837ed000         cmp word ptr [bp - 0x30], 0
  05267D  6C2D: 7403             je 0x6c32
  05267F  6C2F: e93a01           jmp 0x6d6c
  052682  6C32: 807f4900         cmp byte ptr [bx + 0x49], 0
  052686  6C36: 7406             je 0x6c3e
  052688  6C38: fe4f49           dec byte ptr [bx + 0x49]
  05268B  6C3B: eb0d             jmp 0x6c4a
  05268D  6C3D: 90               nop 
  05268E  6C3E: 6a32             push 0x32
  052690  6C40: 6a0f             push 0xf
  052692  6C42: 9a140c1f19       lcall 0x191f, 0xc14
  052697  6C47: 83c404           add sp, 4
  05269A  6C4A: 8b46e8           mov ax, word ptr [bp - 0x18]
  05269D  6C4D: 99               cdq 
  05269E  6C4E: 8b1efc84         mov bx, word ptr [0x84fc]
  0526A2  6C52: 29472a           sub word ptr [bx + 0x2a], ax
  0526A5  6C55: 19572c           sbb word ptr [bx + 0x2c], dx
  0526A8  6C58: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  0526AC  6C5C: c687463101       mov byte ptr [bx + 0x3146], 1
  0526B1  6C61: 8a875b31         mov al, byte ptr [bx + 0x315b]
  0526B5  6C65: 98               cwde 
  0526B6  6C66: 50               push ax
  0526B7  6C67: 9a9a0c1f18       lcall 0x181f, 0xc9a
  0526BC  6C6C: 83c402           add sp, 2
  0526BF  6C6F: 0bc0             or ax, ax
  0526C1  6C71: 7451             je 0x6cc4
  0526C3  6C73: c746d81c00       mov word ptr [bp - 0x28], 0x1c
  0526C8  6C78: c746cc0000       mov word ptr [bp - 0x34], 0
  0526CD  6C7D: eb04             jmp 0x6c83
  0526CF  6C7F: 90               nop 
  0526D0  6C80: ff46cc           inc word ptr [bp - 0x34]
  0526D3  6C83: 837ecc03         cmp word ptr [bp - 0x34], 3
  0526D7  6C87: 7d30             jge 0x6cb9
  0526D9  6C89: 8b1efc84         mov bx, word ptr [0x84fc]
  0526DD  6C8D: 8b76cc           mov si, word ptr [bp - 0x34]
  0526E0  6C90: 8a4002           mov al, byte ptr [bx + si + 2]
  0526E3  6C93: 2ae4             sub ah, ah
  0526E5  6C95: 50               push ax
  0526E6  6C96: 9a9a0c1f18       lcall 0x181f, 0xc9a
  0526EB  6C9B: 83c402           add sp, 2
  0526EE  6C9E: 0bc0             or ax, ax
  0526F0  6CA0: 75de             jne 0x6c80
  0526F2  6CA2: 8b1efc84         mov bx, word ptr [0x84fc]
  0526F6  6CA6: 8a4002           mov al, byte ptr [bx + si + 2]
  0526F9  6CA9: 2ae4             sub ah, ah
  0526FB  6CAB: 8946d8           mov word ptr [bp - 0x28], ax
  0526FE  6CAE: 6b7ebe1c         imul di, word ptr [bp - 0x42], 0x1c
  052702  6CB2: 8a855b31         mov al, byte ptr [di + 0x315b]
  052706  6CB6: 884002           mov byte ptr [bx + si + 2], al
  052709  6CB9: 8a46d8           mov al, byte ptr [bp - 0x28]
  05270C  6CBC: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052710  6CC0: 88875b31         mov byte ptr [bx + 0x315b], al
  052714  6CC4: c746fa0000       mov word ptr [bp - 6], 0
  052719  6CC9: c746f80100       mov word ptr [bp - 8], 1
  05271E  6CCE: fe0edba0         dec byte ptr [0xa0db]
  052722  6CD2: 837eee00         cmp word ptr [bp - 0x12], 0
  052726  6CD6: 7433             je 0x6d0b
  052728  6CD8: 6b5e0613         imul bx, word ptr [bp + 6], 0x13
  05272C  6CDC: 8a875092         mov al, byte ptr [bx - 0x6db0]
  052730  6CE0: 2ae4             sub ah, ah
  052732  6CE2: 8a8f4d92         mov cl, byte ptr [bx - 0x6db3]
  052736  6CE6: 2aed             sub ch, ch
  052738  6CE8: 03c1             add ax, cx
  05273A  6CEA: 50               push ax
  05273B  6CEB: 6a00             push 0
  05273D  6CED: 9ad4041f18       lcall 0x181f, 0x4d4
  052742  6CF2: 83c404           add sp, 4
  052745  6CF5: 8b5e06           mov bx, word ptr [bp + 6]
  052748  6CF8: 8a8f2894         mov cl, byte ptr [bx - 0x6bd8]
  05274C  6CFC: 2aed             sub ch, ch
  05274E  6CFE: 3bc8             cmp cx, ax
  052750  6D00: 7c09             jl 0x6d0b
  052752  6D02: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052756  6D06: c6875b3115       mov byte ptr [bx + 0x315b], 0x15
  05275B  6D0B: 6a08             push 8
  05275D  6D0D: 9a3e0c1f19       lcall 0x191f, 0xc3e
  052762  6D12: 83c402           add sp, 2
  052765  6D15: 6bc032           imul ax, ax, 0x32
  052768  6D18: 8946e8           mov word ptr [bp - 0x18], ax
  05276B  6D1B: 8b1efc84         mov bx, word ptr [0x84fc]
  05276F  6D1F: 837f4a32         cmp word ptr [bx + 0x4a], 0x32
  052773  6D23: 7205             jb 0x6d2a
  052775  6D25: c746e80000       mov word ptr [bp - 0x18], 0
  05277A  6D2A: 8b46e8           mov ax, word ptr [bp - 0x18]
  05277D  6D2D: 99               cdq 
  05277E  6D2E: 39572c           cmp word ptr [bx + 0x2c], dx
  052781  6D31: 7d03             jge 0x6d36
  052783  6D33: e9f4fd           jmp 0x6b2a
  052786  6D36: 7f08             jg 0x6d40
  052788  6D38: 39472a           cmp word ptr [bx + 0x2a], ax
  05278B  6D3B: 7303             jae 0x6d40
  05278D  6D3D: e9eafd           jmp 0x6b2a
  052790  6D40: 29472a           sub word ptr [bx + 0x2a], ax
  052793  6D43: 19572c           sbb word ptr [bx + 0x2c], dx
  052796  6D46: 6b76be1c         imul si, word ptr [bp - 0x42], 0x1c
  05279A  6D4A: c684463104       mov byte ptr [si + 0x3146], 4
  05279F  6D4F: 837f4a32         cmp word ptr [bx + 0x4a], 0x32
  0527A3  6D53: 7207             jb 0x6d5c
  0527A5  6D55: 836f4a32         sub word ptr [bx + 0x4a], 0x32
  0527A9  6D59: e9cefd           jmp 0x6b2a
  0527AC  6D5C: 6a32             push 0x32
  0527AE  6D5E: 6a08             push 8
  0527B0  6D60: 9a140c1f19       lcall 0x191f, 0xc14
  0527B5  6D65: 83c404           add sp, 4
  0527B8  6D68: e9bffd           jmp 0x6b2a
  0527BB  6D6B: 90               nop 
  0527BC  6D6C: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  0527C0  6D70: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  0527C5  6D75: 7403             je 0x6d7a
  0527C7  6D77: e9ce00           jmp 0x6e48
  0527CA  6D7A: 6b5e0613         imul bx, word ptr [bp + 6], 0x13
  0527CE  6D7E: 8a874e92         mov al, byte ptr [bx - 0x6db2]
  0527D2  6D82: 2ae4             sub ah, ah
  0527D4  6D84: 2b46fa           sub ax, word ptr [bp - 6]
  0527D7  6D87: f7d8             neg ax
  0527D9  6D89: 0bc0             or ax, ax
  0527DB  6D8B: 7f03             jg 0x6d90
  0527DD  6D8D: e9b800           jmp 0x6e48
  0527E0  6D90: 6a02             push 2
  0527E2  6D92: 6a00             push 0
  0527E4  6D94: 8bf3             mov si, bx
  0527E6  6D96: 9ad4041f18       lcall 0x181f, 0x4d4
  0527EB  6D9B: 83c404           add sp, 4
  0527EE  6D9E: 0bc0             or ax, ax
  0527F0  6DA0: 7403             je 0x6da5
  0527F2  6DA2: e9a300           jmp 0x6e48
  0527F5  6DA5: 3946da           cmp word ptr [bp - 0x26], ax
  0527F8  6DA8: 7403             je 0x6dad
  0527FA  6DAA: e99b00           jmp 0x6e48
  0527FD  6DAD: 833e8e5364       cmp word ptr [0x538e], 0x64
  052802  6DB2: 7c18             jl 0x6dcc
  052804  6DB4: 6a02             push 2
  052806  6DB6: 50               push ax
  052807  6DB7: 9ad4041f18       lcall 0x181f, 0x4d4
  05280C  6DBC: 83c404           add sp, 4
  05280F  6DBF: 8a8c4e92         mov cl, byte ptr [si - 0x6db2]
  052813  6DC3: 2aed             sub ch, ch
  052815  6DC5: 3bc8             cmp cx, ax
  052817  6DC7: 7c03             jl 0x6dcc
  052819  6DC9: e95efd           jmp 0x6b2a
  05281C  6DCC: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052820  6DD0: 8a875b31         mov al, byte ptr [bx + 0x315b]
  052824  6DD4: 98               cwde 
  052825  6DD5: 50               push ax
  052826  6DD6: 9a9a0c1f18       lcall 0x181f, 0xc9a
  05282B  6DDB: 83c402           add sp, 2
  05282E  6DDE: 0bc0             or ax, ax
  052830  6DE0: 7413             je 0x6df5
  052832  6DE2: 6a04             push 4
  052834  6DE4: 6a00             push 0
  052836  6DE6: 9ad4041f18       lcall 0x181f, 0x4d4
  05283B  6DEB: 83c404           add sp, 4
  05283E  6DEE: 0bc0             or ax, ax
  052840  6DF0: 7403             je 0x6df5
  052842  6DF2: e935fd           jmp 0x6b2a
  052845  6DF5: 6a0e             push 0xe
  052847  6DF7: 9a3e0c1f19       lcall 0x191f, 0xc3e
  05284C  6DFC: 83c402           add sp, 2
  05284F  6DFF: 6bc064           imul ax, ax, 0x64
  052852  6E02: 8946e8           mov word ptr [bp - 0x18], ax
  052855  6E05: 99               cdq 
  052856  6E06: 8b1efc84         mov bx, word ptr [0x84fc]
  05285A  6E0A: 39572c           cmp word ptr [bx + 0x2c], dx
  05285D  6E0D: 7c39             jl 0x6e48
  05285F  6E0F: 7f05             jg 0x6e16
  052861  6E11: 39472a           cmp word ptr [bx + 0x2a], ax
  052864  6E14: 7232             jb 0x6e48
  052866  6E16: 29472a           sub word ptr [bx + 0x2a], ax
  052869  6E19: 19572c           sbb word ptr [bx + 0x2c], dx
  05286C  6E1C: 6a64             push 0x64
  05286E  6E1E: 6a0e             push 0xe
  052870  6E20: 9a140c1f19       lcall 0x191f, 0xc14
  052875  6E25: 83c404           add sp, 4
  052878  6E28: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  05287C  6E2C: c687463102       mov byte ptr [bx + 0x3146], 2
  052881  6E31: 8b46fa           mov ax, word ptr [bp - 6]
  052884  6E34: 0946da           or word ptr [bp - 0x26], ax
  052887  6E37: c746fa0000       mov word ptr [bp - 6], 0
  05288C  6E3C: c746f80100       mov word ptr [bp - 8], 1
  052891  6E41: fe0edaa0         dec byte ptr [0xa0da]
  052895  6E45: e9e2fc           jmp 0x6b2a
  052898  6E48: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  05289C  6E4C: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  0528A1  6E51: 7403             je 0x6e56
  0528A3  6E53: e9d4fc           jmp 0x6b2a
  0528A6  6E56: 6b5e0613         imul bx, word ptr [bp + 6], 0x13
  0528AA  6E5A: 80bf4f9200       cmp byte ptr [bx - 0x6db1], 0
  0528AF  6E5F: 7403             je 0x6e64
  0528B1  6E61: e9c6fc           jmp 0x6b2a
  0528B4  6E64: 833e8e5332       cmp word ptr [0x538e], 0x32
  0528B9  6E69: 7f03             jg 0x6e6e
  0528BB  6E6B: e9bcfc           jmp 0x6b2a
  0528BE  6E6E: 813e8e53c800     cmp word ptr [0x538e], 0xc8
  0528C4  6E74: 7c13             jl 0x6e89
  0528C6  6E76: 6a03             push 3
  0528C8  6E78: 6a00             push 0
  0528CA  6E7A: 9ad4041f18       lcall 0x181f, 0x4d4
  0528CF  6E7F: 83c404           add sp, 4
  0528D2  6E82: 0bc0             or ax, ax
  0528D4  6E84: 7403             je 0x6e89
  0528D6  6E86: e9a1fc           jmp 0x6b2a
  0528D9  6E89: a18e53           mov ax, word ptr [0x538e]
  0528DC  6E8C: b90700           mov cx, 7
  0528DF  6E8F: 99               cdq 
  0528E0  6E90: f7f9             idiv cx
  0528E2  6E92: 0bd2             or dx, dx
  0528E4  6E94: 7403             je 0x6e99
  0528E6  6E96: e991fc           jmp 0x6b2a
  0528E9  6E99: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  0528ED  6E9D: 8a875b31         mov al, byte ptr [bx + 0x315b]
  0528F1  6EA1: 98               cwde 
  0528F2  6EA2: 50               push ax
  0528F3  6EA3: 9a9a0c1f18       lcall 0x181f, 0xc9a
  0528F8  6EA8: 83c402           add sp, 2
  0528FB  6EAB: 0bc0             or ax, ax
  0528FD  6EAD: 7413             je 0x6ec2
  0528FF  6EAF: 6a07             push 7
  052901  6EB1: 6a00             push 0
  052903  6EB3: 9ad4041f18       lcall 0x181f, 0x4d4
  052908  6EB8: 83c404           add sp, 4
  05290B  6EBB: 0bc0             or ax, ax
  05290D  6EBD: 7403             je 0x6ec2
  05290F  6EBF: e968fc           jmp 0x6b2a
  052912  6EC2: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052916  6EC6: c687463103       mov byte ptr [bx + 0x3146], 3
  05291B  6ECB: 6b5e0613         imul bx, word ptr [bp + 6], 0x13
  05291F  6ECF: fe874f92         inc byte ptr [bx - 0x6db1]
  052923  6ED3: e954fc           jmp 0x6b2a
  052926  6ED6: ff46c8           inc word ptr [bp - 0x38]
  052929  6ED9: 837ec802         cmp word ptr [bp - 0x38], 2
  05292D  6EDD: 7d13             jge 0x6ef2
  05292F  6EDF: 8b4606           mov ax, word ptr [bp + 6]
  052932  6EE2: 2d1400           sub ax, 0x14
  052935  6EE5: 8bd0             mov dx, ax
  052937  6EE7: 9ae0071f18       lcall 0x181f, 0x7e0
  05293C  6EEC: 8946ec           mov word ptr [bp - 0x14], ax
  05293F  6EEF: e940fc           jmp 0x6b32
  052942  6EF2: 6a04             push 4
  052944  6EF4: ff76ec           push word ptr [bp - 0x14]
  052947  6EF7: 9abc081f18       lcall 0x181f, 0x8bc
  05294C  6EFC: 83c404           add sp, 4
  05294F  6EFF: 8946e0           mov word ptr [bp - 0x20], ax
  052952  6F02: f606825301       test byte ptr [0x5382], 1
  052957  6F07: 7410             je 0x6f19
  052959  6F09: 6a0c             push 0xc
  05295B  6F0B: ff76ec           push word ptr [bp - 0x14]
  05295E  6F0E: 9abc081f18       lcall 0x181f, 0x8bc
  052963  6F13: 83c404           add sp, 4
  052966  6F16: 0146e0           add word ptr [bp - 0x20], ax
  052969  6F19: 837ee000         cmp word ptr [bp - 0x20], 0
  05296D  6F1D: 7503             jne 0x6f22
  05296F  6F1F: e9cb03           jmp 0x72ed
  052972  6F22: 837ed000         cmp word ptr [bp - 0x30], 0
  052976  6F26: 7403             je 0x6f2b
  052978  6F28: e9c203           jmp 0x72ed
  05297B  6F2B: 837efe00         cmp word ptr [bp - 2], 0
  05297F  6F2F: 7403             je 0x6f34
  052981  6F31: e9b903           jmp 0x72ed
  052984  6F34: f606825301       test byte ptr [0x5382], 1
  052989  6F39: 7403             je 0x6f3e
  05298B  6F3B: e9af03           jmp 0x72ed
  05298E  6F3E: 6a0e             push 0xe
  052990  6F40: ff76ec           push word ptr [bp - 0x14]
  052993  6F43: 9abc081f18       lcall 0x181f, 0x8bc
  052998  6F48: 83c404           add sp, 4
  05299B  6F4B: 8946de           mov word ptr [bp - 0x22], ax
  05299E  6F4E: 2b46e0           sub ax, word ptr [bp - 0x20]
  0529A1  6F51: 8946c0           mov word ptr [bp - 0x40], ax
  0529A4  6F54: 833e8e5350       cmp word ptr [0x538e], 0x50
  0529A9  6F59: 7e3e             jle 0x6f99
  0529AB  6F5B: eb07             jmp 0x6f64
  0529AD  6F5D: 90               nop 
  0529AE  6F5E: 294f4a           sub word ptr [bx + 0x4a], cx
  0529B1  6F61: fe4749           inc byte ptr [bx + 0x49]
  0529B4  6F64: 8b1efc84         mov bx, word ptr [0x84fc]
  0529B8  6F68: 8b474a           mov ax, word ptr [bx + 0x4a]
  0529BB  6F6B: b93200           mov cx, 0x32
  0529BE  6F6E: 2bd2             sub dx, dx
  0529C0  6F70: f7f1             div cx
  0529C2  6F72: 8a5749           mov dl, byte ptr [bx + 0x49]
  0529C5  6F75: 2af6             sub dh, dh
  0529C7  6F77: 42               inc dx
  0529C8  6F78: 3bd0             cmp dx, ax
  0529CA  6F7A: 72e2             jb 0x6f5e
  0529CC  6F7C: eb06             jmp 0x6f84
  0529CE  6F7E: fe4f49           dec byte ptr [bx + 0x49]
  0529D1  6F81: 014f4a           add word ptr [bx + 0x4a], cx
  0529D4  6F84: 8b1efc84         mov bx, word ptr [0x84fc]
  0529D8  6F88: 8b474a           mov ax, word ptr [bx + 0x4a]
  0529DB  6F8B: 2bd2             sub dx, dx
  0529DD  6F8D: f7f1             div cx
  0529DF  6F8F: 40               inc ax
  0529E0  6F90: 8a5749           mov dl, byte ptr [bx + 0x49]
  0529E3  6F93: 2af6             sub dh, dh
  0529E5  6F95: 3bc2             cmp ax, dx
  0529E7  6F97: 72e5             jb 0x6f7e
  0529E9  6F99: 837ece00         cmp word ptr [bp - 0x32], 0
  0529ED  6F9D: 7570             jne 0x700f
  0529EF  6F9F: 837ede06         cmp word ptr [bp - 0x22], 6
  0529F3  6FA3: 7c6a             jl 0x700f
  0529F5  6FA5: 833e8e5328       cmp word ptr [0x538e], 0x28
  0529FA  6FAA: 7c10             jl 0x6fbc
  0529FC  6FAC: a0a653           mov al, byte ptr [0x53a6]
  0529FF  6FAF: 2ae4             sub ah, ah
  052A01  6FB1: 2d0a00           sub ax, 0xa
  052A04  6FB4: f7d8             neg ax
  052A06  6FB6: 6bc064           imul ax, ax, 0x64
  052A09  6FB9: 8946ca           mov word ptr [bp - 0x36], ax
  052A0C  6FBC: 8b1efc84         mov bx, word ptr [0x84fc]
  052A10  6FC0: 807f4800         cmp byte ptr [bx + 0x48], 0
  052A14  6FC4: 7408             je 0x6fce
  052A16  6FC6: fe4f48           dec byte ptr [bx + 0x48]
  052A19  6FC9: c746ca0000       mov word ptr [bp - 0x36], 0
  052A1E  6FCE: 8b46ca           mov ax, word ptr [bp - 0x36]
  052A21  6FD1: 99               cdq 
  052A22  6FD2: 8b1efc84         mov bx, word ptr [0x84fc]
  052A26  6FD6: 39572c           cmp word ptr [bx + 0x2c], dx
  052A29  6FD9: 7c34             jl 0x700f
  052A2B  6FDB: 7f05             jg 0x6fe2
  052A2D  6FDD: 39472a           cmp word ptr [bx + 0x2a], ax
  052A30  6FE0: 722d             jb 0x700f
  052A32  6FE2: 8b4e06           mov cx, word ptr [bp + 6]
  052A35  6FE5: 83e914           sub cx, 0x14
  052A38  6FE8: 51               push cx
  052A39  6FE9: 51               push cx
  052A3A  6FEA: ff7606           push word ptr [bp + 6]
  052A3D  6FED: 6a0b             push 0xb
  052A3F  6FEF: 8bf0             mov si, ax
  052A41  6FF1: 8bfa             mov di, dx
  052A43  6FF3: 9a5c091f18       lcall 0x181f, 0x95c
  052A48  6FF8: 83c408           add sp, 8
  052A4B  6FFB: 8946be           mov word ptr [bp - 0x42], ax
  052A4E  6FFE: 0bc0             or ax, ax
  052A50  7000: 7c0d             jl 0x700f
  052A52  7002: ff4ec0           dec word ptr [bp - 0x40]
  052A55  7005: 8b1efc84         mov bx, word ptr [0x84fc]
  052A59  7009: 29772a           sub word ptr [bx + 0x2a], si
  052A5C  700C: 197f2c           sbb word ptr [bx + 0x2c], di
  052A5F  700F: c746e60000       mov word ptr [bp - 0x1a], 0
  052A64  7014: 8b1efc84         mov bx, word ptr [0x84fc]
  052A68  7018: 8b4730           mov ax, word ptr [bx + 0x30]
  052A6B  701B: 99               cdq 
  052A6C  701C: b9ffff           mov cx, 0xffff
  052A6F  701F: 8bf1             mov si, cx
  052A71  7021: 2bc8             sub cx, ax
  052A73  7023: 1bf2             sbb si, dx
  052A75  7025: 56               push si
  052A76  7026: 51               push cx
  052A77  7027: 8a4706           mov al, byte ptr [bx + 6]
  052A7A  702A: 2ae4             sub ah, ah
  052A7C  702C: 050700           add ax, 7
  052A7F  702F: d1e0             shl ax, 1
  052A81  7031: 8a0ea653         mov cl, byte ptr [0x53a6]
  052A85  7035: 81e1fe00         and cx, 0xfe
  052A89  7039: 2bc1             sub ax, cx
  052A8B  703B: 8bc8             mov cx, ax
  052A8D  703D: c1e002           shl ax, 2
  052A90  7040: 03c1             add ax, cx
  052A92  7042: d1e0             shl ax, 1
  052A94  7044: 8bc8             mov cx, ax
  052A96  7046: f76f2e           imul word ptr [bx + 0x2e]
  052A99  7049: 52               push dx
  052A9A  704A: 50               push ax
  052A9B  704B: 8bf1             mov si, cx
  052A9D  704D: 9ac60e1d0d       lcall 0xd1d, 0xec6
  052AA2  7052: 03f0             add si, ax
  052AA4  7054: 8976ca           mov word ptr [bp - 0x36], si
  052AA7  7057: 8b1efc84         mov bx, word ptr [0x84fc]
  052AAB  705B: 807f4900         cmp byte ptr [bx + 0x49], 0
  052AAF  705F: 7512             jne 0x7073
  052AB1  7061: 6a0f             push 0xf
  052AB3  7063: 9a3e0c1f19       lcall 0x191f, 0xc3e
  052AB8  7068: 83c402           add sp, 2
  052ABB  706B: 6bc032           imul ax, ax, 0x32
  052ABE  706E: 03f0             add si, ax
  052AC0  7070: 8976ca           mov word ptr [bp - 0x36], si
  052AC3  7073: 833e8e5364       cmp word ptr [0x538e], 0x64
  052AC8  7078: 7c19             jl 0x7093
  052ACA  707A: a0a653           mov al, byte ptr [0x53a6]
  052ACD  707D: 2ae4             sub ah, ah
  052ACF  707F: f7ee             imul si
  052AD1  7081: 8bc8             mov cx, ax
  052AD3  7083: c1e002           shl ax, 2
  052AD6  7086: 03c1             add ax, cx
  052AD8  7088: d1e0             shl ax, 1
  052ADA  708A: b99cff           mov cx, 0xff9c
  052ADD  708D: 99               cdq 
  052ADE  708E: f7f9             idiv cx
  052AE0  7090: 0146ca           add word ptr [bp - 0x36], ax
  052AE3  7093: 8b46ca           mov ax, word ptr [bp - 0x36]
  052AE6  7096: 99               cdq 
  052AE7  7097: 8b1efc84         mov bx, word ptr [0x84fc]
  052AEB  709B: 39572c           cmp word ptr [bx + 0x2c], dx
  052AEE  709E: 7d03             jge 0x70a3
  052AF0  70A0: e93b02           jmp 0x72de
  052AF3  70A3: 7f08             jg 0x70ad
  052AF5  70A5: 39472a           cmp word ptr [bx + 0x2a], ax
  052AF8  70A8: 7303             jae 0x70ad
  052AFA  70AA: e93102           jmp 0x72de
  052AFD  70AD: 6a02             push 2
  052AFF  70AF: 6a00             push 0
  052B01  70B1: 9ad4041f18       lcall 0x181f, 0x4d4
  052B06  70B6: 83c404           add sp, 4
  052B09  70B9: 8946ea           mov word ptr [bp - 0x16], ax
  052B0C  70BC: 8b1efc84         mov bx, word ptr [0x84fc]
  052B10  70C0: 8bf0             mov si, ax
  052B12  70C2: 8a4002           mov al, byte ptr [bx + si + 2]
  052B15  70C5: 2ae4             sub ah, ah
  052B17  70C7: 50               push ax
  052B18  70C8: 9a260b1f19       lcall 0x191f, 0xb26
  052B1D  70CD: 83c402           add sp, 2
  052B20  70D0: 8946be           mov word ptr [bp - 0x42], ax
  052B23  70D3: 0bc0             or ax, ax
  052B25  70D5: 7d03             jge 0x70da
  052B27  70D7: e91302           jmp 0x72ed
  052B2A  70DA: 6bd81c           imul bx, ax, 0x1c
  052B2D  70DD: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  052B32  70E2: 7407             je 0x70eb
  052B34  70E4: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  052B39  70E9: 752f             jne 0x711a
  052B3B  70EB: 8b1efc84         mov bx, word ptr [0x84fc]
  052B3F  70EF: 807f4900         cmp byte ptr [bx + 0x49], 0
  052B43  70F3: 751f             jne 0x7114
  052B45  70F5: 6a0f             push 0xf
  052B47  70F7: 9a3e0c1f19       lcall 0x191f, 0xc3e
  052B4C  70FC: 83c402           add sp, 2
  052B4F  70FF: 6bc0ce           imul ax, ax, -0x32
  052B52  7102: 0146ca           add word ptr [bp - 0x36], ax
  052B55  7105: 6a32             push 0x32
  052B57  7107: 6a0f             push 0xf
  052B59  7109: 9a2e0a1f19       lcall 0x191f, 0xa2e
  052B5E  710E: 83c404           add sp, 4
  052B61  7111: eb36             jmp 0x7149
  052B63  7113: 90               nop 
  052B64  7114: fe4749           inc byte ptr [bx + 0x49]
  052B67  7117: eb30             jmp 0x7149
  052B69  7119: 90               nop 
  052B6A  711A: 6bd81c           imul bx, ax, 0x1c
  052B6D  711D: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  052B72  7122: 7516             jne 0x713a
  052B74  7124: 6a0e             push 0xe
  052B76  7126: 9aea091f19       lcall 0x191f, 0x9ea
  052B7B  712B: 83c402           add sp, 2
  052B7E  712E: 6bc09c           imul ax, ax, -0x64
  052B81  7131: 0146ca           add word ptr [bp - 0x36], ax
  052B84  7134: 6a64             push 0x64
  052B86  7136: 6a0e             push 0xe
  052B88  7138: ebcf             jmp 0x7109
  052B8A  713A: 6bd81c           imul bx, ax, 0x1c
  052B8D  713D: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  052B92  7142: 7505             jne 0x7149
  052B94  7144: c687463104       mov byte ptr [bx + 0x3146], 4
  052B99  7149: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052B9D  714D: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  052BA2  7152: 7468             je 0x71bc
  052BA4  7154: c687463101       mov byte ptr [bx + 0x3146], 1
  052BA9  7159: 8a875b31         mov al, byte ptr [bx + 0x315b]
  052BAD  715D: 98               cwde 
  052BAE  715E: 50               push ax
  052BAF  715F: 9a9a0c1f18       lcall 0x181f, 0xc9a
  052BB4  7164: 83c402           add sp, 2
  052BB7  7167: 0bc0             or ax, ax
  052BB9  7169: 7451             je 0x71bc
  052BBB  716B: c746d81c00       mov word ptr [bp - 0x28], 0x1c
  052BC0  7170: c746cc0000       mov word ptr [bp - 0x34], 0
  052BC5  7175: eb04             jmp 0x717b
  052BC7  7177: 90               nop 
  052BC8  7178: ff46cc           inc word ptr [bp - 0x34]
  052BCB  717B: 837ecc03         cmp word ptr [bp - 0x34], 3
  052BCF  717F: 7d30             jge 0x71b1
  052BD1  7181: 8b1efc84         mov bx, word ptr [0x84fc]
  052BD5  7185: 8b76cc           mov si, word ptr [bp - 0x34]
  052BD8  7188: 8a4002           mov al, byte ptr [bx + si + 2]
  052BDB  718B: 2ae4             sub ah, ah
  052BDD  718D: 50               push ax
  052BDE  718E: 9a9a0c1f18       lcall 0x181f, 0xc9a
  052BE3  7193: 83c402           add sp, 2
  052BE6  7196: 0bc0             or ax, ax
  052BE8  7198: 75de             jne 0x7178
  052BEA  719A: 8b1efc84         mov bx, word ptr [0x84fc]
  052BEE  719E: 8a4002           mov al, byte ptr [bx + si + 2]
  052BF1  71A1: 2ae4             sub ah, ah
  052BF3  71A3: 8946d8           mov word ptr [bp - 0x28], ax
  052BF6  71A6: 6b7ebe1c         imul di, word ptr [bp - 0x42], 0x1c
  052BFA  71AA: 8a855b31         mov al, byte ptr [di + 0x315b]
  052BFE  71AE: 884002           mov byte ptr [bx + si + 2], al
  052C01  71B1: 8a46d8           mov al, byte ptr [bp - 0x28]
  052C04  71B4: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052C08  71B8: 88875b31         mov byte ptr [bx + 0x315b], al
  052C0C  71BC: 8b46ca           mov ax, word ptr [bp - 0x36]
  052C0F  71BF: 99               cdq 
  052C10  71C0: 8b1efc84         mov bx, word ptr [0x84fc]
  052C14  71C4: 29472a           sub word ptr [bx + 0x2a], ax
  052C17  71C7: 19572c           sbb word ptr [bx + 0x2c], dx
  052C1A  71CA: 807f4900         cmp byte ptr [bx + 0x49], 0
  052C1E  71CE: 750e             jne 0x71de
  052C20  71D0: 6a32             push 0x32
  052C22  71D2: 6a0f             push 0xf
  052C24  71D4: 9a140c1f19       lcall 0x191f, 0xc14
  052C29  71D9: 83c404           add sp, 4
  052C2C  71DC: eb07             jmp 0x71e5
  052C2E  71DE: 8b1efc84         mov bx, word ptr [0x84fc]
  052C32  71E2: fe4f49           dec byte ptr [bx + 0x49]
  052C35  71E5: 837eee00         cmp word ptr [bp - 0x12], 0
  052C39  71E9: 743c             je 0x7227
  052C3B  71EB: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052C3F  71EF: 80bf5b3115       cmp byte ptr [bx + 0x315b], 0x15
  052C44  71F4: 7431             je 0x7227
  052C46  71F6: 6b760613         imul si, word ptr [bp + 6], 0x13
  052C4A  71FA: 8a845092         mov al, byte ptr [si - 0x6db0]
  052C4E  71FE: 2ae4             sub ah, ah
  052C50  7200: 8a8c4d92         mov cl, byte ptr [si - 0x6db3]
  052C54  7204: 2aed             sub ch, ch
  052C56  7206: 03c1             add ax, cx
  052C58  7208: 50               push ax
  052C59  7209: 6a00             push 0
  052C5B  720B: 8bf3             mov si, bx
  052C5D  720D: 9ad4041f18       lcall 0x181f, 0x4d4
  052C62  7212: 83c404           add sp, 4
  052C65  7215: 8b5e06           mov bx, word ptr [bp + 6]
  052C68  7218: 8a8f2894         mov cl, byte ptr [bx - 0x6bd8]
  052C6C  721C: 2aed             sub ch, ch
  052C6E  721E: 3bc8             cmp cx, ax
  052C70  7220: 7c05             jl 0x7227
  052C72  7222: c6845b3115       mov byte ptr [si + 0x315b], 0x15
  052C77  7227: 6a08             push 8
  052C79  7229: 9a3e0c1f19       lcall 0x191f, 0xc3e
  052C7E  722E: 83c402           add sp, 2
  052C81  7231: 6bc032           imul ax, ax, 0x32
  052C84  7234: 8946e8           mov word ptr [bp - 0x18], ax
  052C87  7237: 833e8e5364       cmp word ptr [0x538e], 0x64
  052C8C  723C: 7c1a             jl 0x7258
  052C8E  723E: a0a653           mov al, byte ptr [0x53a6]
  052C91  7241: 2ae4             sub ah, ah
  052C93  7243: f76ee8           imul word ptr [bp - 0x18]
  052C96  7246: 8bc8             mov cx, ax
  052C98  7248: c1e002           shl ax, 2
  052C9B  724B: 03c1             add ax, cx
  052C9D  724D: d1e0             shl ax, 1
  052C9F  724F: b99cff           mov cx, 0xff9c
  052CA2  7252: 99               cdq 
  052CA3  7253: f7f9             idiv cx
  052CA5  7255: 0146e8           add word ptr [bp - 0x18], ax
  052CA8  7258: 8b1efc84         mov bx, word ptr [0x84fc]
  052CAC  725C: 837f4a32         cmp word ptr [bx + 0x4a], 0x32
  052CB0  7260: 7205             jb 0x7267
  052CB2  7262: c746e80000       mov word ptr [bp - 0x18], 0
  052CB7  7267: 8b46e8           mov ax, word ptr [bp - 0x18]
  052CBA  726A: 99               cdq 
  052CBB  726B: 39572c           cmp word ptr [bx + 0x2c], dx
  052CBE  726E: 7c0d             jl 0x727d
  052CC0  7270: 7f05             jg 0x7277
  052CC2  7272: 39472a           cmp word ptr [bx + 0x2a], ax
  052CC5  7275: 7206             jb 0x727d
  052CC7  7277: 29472a           sub word ptr [bx + 0x2a], ax
  052CCA  727A: 19572c           sbb word ptr [bx + 0x2c], dx
  052CCD  727D: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052CD1  7281: c687463104       mov byte ptr [bx + 0x3146], 4
  052CD6  7286: 8b1efc84         mov bx, word ptr [0x84fc]
  052CDA  728A: 837f4a32         cmp word ptr [bx + 0x4a], 0x32
  052CDE  728E: 7206             jb 0x7296
  052CE0  7290: 836f4a32         sub word ptr [bx + 0x4a], 0x32
  052CE4  7294: eb0c             jmp 0x72a2
  052CE6  7296: 6a32             push 0x32
  052CE8  7298: 6a08             push 8
  052CEA  729A: 9a140c1f19       lcall 0x191f, 0xc14
  052CEF  729F: 83c404           add sp, 4
  052CF2  72A2: 6a00             push 0
  052CF4  72A4: 9afc0a1f19       lcall 0x191f, 0xafc
  052CF9  72A9: 83c402           add sp, 2
  052CFC  72AC: 8b1efc84         mov bx, word ptr [0x84fc]
  052D00  72B0: 8b76ea           mov si, word ptr [bp - 0x16]
  052D03  72B3: 884002           mov byte ptr [bx + si + 2], al
  052D06  72B6: b80100           mov ax, 1
  052D09  72B9: 8946e4           mov word ptr [bp - 0x1c], ax
  052D0C  72BC: 8946e6           mov word ptr [bp - 0x1a], ax
  052D0F  72BF: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052D13  72C3: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  052D17  72C7: 2aff             sub bh, bh
  052D19  72C9: 8bc3             mov ax, bx
  052D1B  72CB: d1e3             shl bx, 1
  052D1D  72CD: 03d8             add bx, ax
  052D1F  72CF: d1e3             shl bx, 1
  052D21  72D1: 03d8             add bx, ax
  052D23  72D3: d1e3             shl bx, 1
  052D25  72D5: 8a873852         mov al, byte ptr [bx + 0x5238]
  052D29  72D9: 2ae4             sub ah, ah
  052D2B  72DB: 2946c0           sub word ptr [bp - 0x40], ax
  052D2E  72DE: 837ee600         cmp word ptr [bp - 0x1a], 0
  052D32  72E2: 7409             je 0x72ed
  052D34  72E4: 837ec000         cmp word ptr [bp - 0x40], 0
  052D38  72E8: 7e03             jle 0x72ed
  052D3A  72EA: e922fd           jmp 0x700f
  052D3D  72ED: 8b5e06           mov bx, word ptr [bp + 6]
  052D40  72F0: 80bf5a9400       cmp byte ptr [bx - 0x6ba6], 0
  052D45  72F5: 7409             je 0x7300
  052D47  72F7: 8a875a94         mov al, byte ptr [bx - 0x6ba6]
  052D4B  72FB: 2ae4             sub ah, ah
  052D4D  72FD: eb03             jmp 0x7302
  052D4F  72FF: 90               nop 
  052D50  7300: 2bc0             sub ax, ax
  052D52  7302: 8946bc           mov word ptr [bp - 0x44], ax
  052D55  7305: a08e53           mov al, byte ptr [0x538e]
  052D58  7308: 250100           and ax, 1
  052D5B  730B: 3d0100           cmp ax, 1
  052D5E  730E: 1bc0             sbb ax, ax
  052D60  7310: 40               inc ax
  052D61  7311: 0146bc           add word ptr [bp - 0x44], ax
  052D64  7314: c746e60000       mov word ptr [bp - 0x1a], 0
  052D69  7319: 8b4606           mov ax, word ptr [bp + 6]
  052D6C  731C: 2d1400           sub ax, 0x14
  052D6F  731F: 8bd0             mov dx, ax
  052D71  7321: 9ae0071f18       lcall 0x181f, 0x7e0
  052D76  7326: e9d500           jmp 0x73fe
  052D79  7329: 90               nop 
  052D7A  732A: 6a00             push 0
  052D7C  732C: ff76be           push word ptr [bp - 0x42]
  052D7F  732F: 9ae60b1f18       lcall 0x181f, 0xbe6
  052D84  7334: 83c404           add sp, 4
  052D87  7337: 8946c2           mov word ptr [bp - 0x3e], ax
  052D8A  733A: 3d0f00           cmp ax, 0xf
  052D8D  733D: 7533             jne 0x7372
  052D8F  733F: 6a00             push 0
  052D91  7341: ff76be           push word ptr [bp - 0x42]
  052D94  7344: 9a680c1f18       lcall 0x181f, 0xc68
  052D99  7349: 83c404           add sp, 4
  052D9C  734C: a3c48d           mov word ptr [0x8dc4], ax
  052D9F  734F: 053100           add ax, 0x31
  052DA2  7352: b93200           mov cx, 0x32
  052DA5  7355: 99               cdq 
  052DA6  7356: f7f9             idiv cx
  052DA8  7358: a3c48d           mov word ptr [0x8dc4], ax
  052DAB  735B: 8b1efc84         mov bx, word ptr [0x84fc]
  052DAF  735F: 004749           add byte ptr [bx + 0x49], al
  052DB2  7362: 6a00             push 0
  052DB4  7364: ff76be           push word ptr [bp - 0x42]
  052DB7  7367: 9aec0a1f18       lcall 0x181f, 0xaec
  052DBC  736C: 83c404           add sp, 4
  052DBF  736F: eb3d             jmp 0x73ae
  052DC1  7371: 90               nop 
  052DC2  7372: 3d0800           cmp ax, 8
  052DC5  7375: 7519             jne 0x7390
  052DC7  7377: 6a00             push 0
  052DC9  7379: ff76be           push word ptr [bp - 0x42]
  052DCC  737C: 9aec0a1f18       lcall 0x181f, 0xaec
  052DD1  7381: 83c404           add sp, 4
  052DD4  7384: a1c48d           mov ax, word ptr [0x8dc4]
  052DD7  7387: 8b1efc84         mov bx, word ptr [0x84fc]
  052DDB  738B: 01474a           add word ptr [bx + 0x4a], ax
  052DDE  738E: eb1e             jmp 0x73ae
  052DE0  7390: 6a64             push 0x64
  052DE2  7392: 6a00             push 0
  052DE4  7394: ff76be           push word ptr [bp - 0x42]
  052DE7  7397: 9ac60d1f19       lcall 0x191f, 0xdc6
  052DEC  739C: 83c406           add sp, 6
  052DEF  739F: 99               cdq 
  052DF0  73A0: 52               push dx
  052DF1  73A1: 50               push ax
  052DF2  73A2: ff36129e         push word ptr [0x9e12]
  052DF6  73A6: 9aba0a1f18       lcall 0x181f, 0xaba
  052DFB  73AB: 83c406           add sp, 6
  052DFE  73AE: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052E02  73B2: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  052E07  73B7: 7403             je 0x73bc
  052E09  73B9: e96eff           jmp 0x732a
  052E0C  73BC: 837ee400         cmp word ptr [bp - 0x1c], 0
  052E10  73C0: 747a             je 0x743c
  052E12  73C2: 8a46de           mov al, byte ptr [bp - 0x22]
  052E15  73C5: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052E19  73C9: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  052E1D  73CD: 2aff             sub bh, bh
  052E1F  73CF: 8bcb             mov cx, bx
  052E21  73D1: d1e3             shl bx, 1
  052E23  73D3: 03d9             add bx, cx
  052E25  73D5: d1e3             shl bx, 1
  052E27  73D7: 03d9             add bx, cx
  052E29  73D9: d1e3             shl bx, 1
  052E2B  73DB: 38873752         cmp byte ptr [bx + 0x5237], al
  052E2F  73DF: 755b             jne 0x743c
  052E31  73E1: c746e40000       mov word ptr [bp - 0x1c], 0
  052E36  73E6: c746e60100       mov word ptr [bp - 0x1a], 1
  052E3B  73EB: ff76be           push word ptr [bp - 0x42]
  052E3E  73EE: 9ac20e1f19       lcall 0x191f, 0xec2
  052E43  73F3: 83c402           add sp, 2
  052E46  73F6: 8b46be           mov ax, word ptr [bp - 0x42]
  052E49  73F9: 9ae4021f18       lcall 0x181f, 0x2e4
  052E4E  73FE: 8946be           mov word ptr [bp - 0x42], ax
  052E51  7401: 837ee600         cmp word ptr [bp - 0x1a], 0
  052E55  7405: 7403             je 0x740a
  052E57  7407: e91601           jmp 0x7520
  052E5A  740A: 0bc0             or ax, ax
  052E5C  740C: 7d03             jge 0x7411
  052E5E  740E: e90f01           jmp 0x7520
  052E61  7411: 6bd81c           imul bx, ax, 0x1c
  052E64  7414: f687483180       test byte ptr [bx + 0x3148], 0x80
  052E69  7419: 7407             je 0x7422
  052E6B  741B: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  052E70  7420: 75d4             jne 0x73f6
  052E72  7422: 6bd81c           imul bx, ax, 0x1c
  052E75  7425: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  052E7A  742A: 72ca             jb 0x73f6
  052E7C  742C: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  052E81  7431: 77c3             ja 0x73f6
  052E83  7433: c6874a31ff       mov byte ptr [bx + 0x314a], 0xff
  052E88  7438: e973ff           jmp 0x73ae
  052E8B  743B: 90               nop 
  052E8C  743C: c746c20f00       mov word ptr [bp - 0x3e], 0xf
  052E91  7441: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052E95  7445: 8a875031         mov al, byte ptr [bx + 0x3150]
  052E99  7449: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  052E9D  744D: 2aff             sub bh, bh
  052E9F  744F: 8bcb             mov cx, bx
  052EA1  7451: d1e3             shl bx, 1
  052EA3  7453: 03d9             add bx, cx
  052EA5  7455: d1e3             shl bx, 1
  052EA7  7457: 03d9             add bx, cx
  052EA9  7459: d1e3             shl bx, 1
  052EAB  745B: 38873752         cmp byte ptr [bx + 0x5237], al
  052EAF  745F: 7503             jne 0x7464
  052EB1  7461: e9a900           jmp 0x750d
  052EB4  7464: 837ed000         cmp word ptr [bp - 0x30], 0
  052EB8  7468: 7403             je 0x746d
  052EBA  746A: e9a000           jmp 0x750d
  052EBD  746D: 8b5e06           mov bx, word ptr [bp + 6]
  052EC0  7470: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  052EC5  7475: 7503             jne 0x747a
  052EC7  7477: e99300           jmp 0x750d
  052ECA  747A: 8a46bc           mov al, byte ptr [bp - 0x44]
  052ECD  747D: 8b5ec2           mov bx, word ptr [bp - 0x3e]
  052ED0  7480: 3887cca0         cmp byte ptr [bx - 0x5f34], al
  052ED4  7484: 7d06             jge 0x748c
  052ED6  7486: 837efe00         cmp word ptr [bp - 2], 0
  052EDA  748A: 7479             je 0x7505
  052EDC  748C: 837ef800         cmp word ptr [bp - 8], 0
  052EE0  7490: 7506             jne 0x7498
  052EE2  7492: 837eda00         cmp word ptr [bp - 0x26], 0
  052EE6  7496: 7433             je 0x74cb
  052EE8  7498: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  052EEC  749C: 8bc3             mov ax, bx
  052EEE  749E: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  052EF2  74A2: 8bf0             mov si, ax
  052EF4  74A4: 8a845031         mov al, byte ptr [si + 0x3150]
  052EF8  74A8: 2ae4             sub ah, ah
  052EFA  74AA: 2aff             sub bh, bh
  052EFC  74AC: 8bcb             mov cx, bx
  052EFE  74AE: d1e3             shl bx, 1
  052F00  74B0: 03d9             add bx, cx
  052F02  74B2: d1e3             shl bx, 1
  052F04  74B4: 03d9             add bx, cx
  052F06  74B6: d1e3             shl bx, 1
  052F08  74B8: 8a8f3752         mov cl, byte ptr [bx + 0x5237]
  052F0C  74BC: 2aed             sub ch, ch
  052F0E  74BE: 2bc8             sub cx, ax
  052F10  74C0: 83f902           cmp cx, 2
  052F13  74C3: 7f06             jg 0x74cb
  052F15  74C5: 837efe00         cmp word ptr [bp - 2], 0
  052F19  74C9: 743a             je 0x7505
  052F1B  74CB: ff76c2           push word ptr [bp - 0x3e]
  052F1E  74CE: 9a3e0c1f19       lcall 0x191f, 0xc3e
  052F23  74D3: 83c402           add sp, 2
  052F26  74D6: f72ec48d         imul word ptr [0x8dc4]
  052F2A  74DA: 8946e8           mov word ptr [bp - 0x18], ax
  052F2D  74DD: 99               cdq 
  052F2E  74DE: 8b1efc84         mov bx, word ptr [0x84fc]
  052F32  74E2: 39572c           cmp word ptr [bx + 0x2c], dx
  052F35  74E5: 7c1e             jl 0x7505
  052F37  74E7: 7f05             jg 0x74ee
  052F39  74E9: 39472a           cmp word ptr [bx + 0x2a], ax
  052F3C  74EC: 7217             jb 0x7505
  052F3E  74EE: 6a64             push 0x64
  052F40  74F0: ff76c2           push word ptr [bp - 0x3e]
  052F43  74F3: ff76be           push word ptr [bp - 0x42]
  052F46  74F6: 9a8e0d1f19       lcall 0x191f, 0xd8e
  052F4B  74FB: 83c406           add sp, 6
  052F4E  74FE: 8b5ec2           mov bx, word ptr [bp - 0x3e]
  052F51  7501: fe8fcca0         dec byte ptr [bx - 0x5f34]
  052F55  7505: ff4ec2           dec word ptr [bp - 0x3e]
  052F58  7508: 7803             js 0x750d
  052F5A  750A: e934ff           jmp 0x7441
  052F5D  750D: ff76be           push word ptr [bp - 0x42]
  052F60  7510: 9ac20e1f19       lcall 0x191f, 0xec2
  052F65  7515: 83c402           add sp, 2
  052F68  7518: c746e60100       mov word ptr [bp - 0x1a], 1
  052F6D  751D: e9d6fe           jmp 0x73f6
  052F70  7520: 837ee600         cmp word ptr [bp - 0x1a], 0
  052F74  7524: 7403             je 0x7529
  052F76  7526: e9ebfd           jmp 0x7314
  052F79  7529: 5e               pop si
  052F7A  752A: 5f               pop di
  052F7B  752B: c9               leave 
  052F7C  752C: cb               retf 

; ---- func_052F7E  size=1472  insns=455  prologue=ENTER 0x001E,0  terminal=page-end ----
  052F7E  752E: c81e0000         enter 0x1e, 0
  052F82  7532: 56               push si
  052F83  7533: c706122dffff     mov word ptr [0x2d12], 0xffff
  052F89  7539: 2bc0             sub ax, ax
  052F8B  753B: 8946ea           mov word ptr [bp - 0x16], ax
  052F8E  753E: a34017           mov word ptr [0x1740], ax
  052F91  7541: ff36a683         push word ptr [0x83a6]
  052F95  7545: 9aca041f18       lcall 0x181f, 0x4ca
  052F9A  754A: 83c402           add sp, 2
  052F9D  754D: 8b4606           mov ax, word ptr [bp + 6]
  052FA0  7550: a39453           mov word ptr [0x5394], ax
  052FA3  7553: 50               push ax
  052FA4  7554: 9a82051f18       lcall 0x181f, 0x582
  052FA9  7559: 83c402           add sp, 2
  052FAC  755C: 8b5e06           mov bx, word ptr [bp + 6]
  052FAF  755F: 8a874808         mov al, byte ptr [bx + 0x848]
  052FB3  7563: 2ae4             sub ah, ah
  052FB5  7565: 50               push ax
  052FB6  7566: 9a90051f18       lcall 0x181f, 0x590
  052FBB  756B: 83c402           add sp, 2
  052FBE  756E: 8b5e06           mov bx, word ptr [bp + 6]
  052FC1  7571: 8a874808         mov al, byte ptr [bx + 0x848]
  052FC5  7575: 2ae4             sub ah, ah
  052FC7  7577: 2d0800           sub ax, 8
  052FCA  757A: 8946e2           mov word ptr [bp - 0x1e], ax
  052FCD  757D: 6a10             push 0x10
  052FCF  757F: 6a00             push 0
  052FD1  7581: 68cca0           push 0xa0cc
  052FD4  7584: 9aae0d1d0d       lcall 0xd1d, 0xdae
  052FD9  7589: 83c406           add sp, 6
  052FDC  758C: 8b5e06           mov bx, word ptr [bp + 6]
  052FDF  758F: c687b8a000       mov byte ptr [bx - 0x5f48], 0
  052FE4  7594: c6069ca800       mov byte ptr [0xa89c], 0
  052FE9  7599: c746f00000       mov word ptr [bp - 0x10], 0
  052FEE  759E: 8b5ef0           mov bx, word ptr [bp - 0x10]
  052FF1  75A1: f687f29508       test byte ptr [bx - 0x6a0e], 8
  052FF6  75A6: 7404             je 0x75ac
  052FF8  75A8: fe069ca8         inc byte ptr [0xa89c]
  052FFC  75AC: ff46f0           inc word ptr [bp - 0x10]
  052FFF  75AF: 837ef010         cmp word ptr [bp - 0x10], 0x10
  053003  75B3: 7ce9             jl 0x759e
  053005  75B5: ff76e2           push word ptr [bp - 0x1e]
  053008  75B8: 6a00             push 0
  05300A  75BA: 9aae0d1f18       lcall 0x181f, 0xdae
  05300F  75BF: 83c404           add sp, 4
  053012  75C2: c746f00000       mov word ptr [bp - 0x10], 0
  053017  75C7: eb77             jmp 0x7640
  053019  75C9: 90               nop 
  05301A  75CA: 8a4606           mov al, byte ptr [bp + 6]
  05301D  75CD: 695ef0ca00       imul bx, word ptr [bp - 0x10], 0xca
  053022  75D2: 3887605d         cmp byte ptr [bx + 0x5d60], al
  053026  75D6: 7565             jne 0x763d
  053028  75D8: ff76f0           push word ptr [bp - 0x10]
  05302B  75DB: 0e               push cs
  05302C  75DC: e8e204           call 0x7ac1
  05302F  75DF: 83c402           add sp, 2
  053032  75E2: 8b1e4285         mov bx, word ptr [0x8542]
  053036  75E6: 80bf8d0000       cmp byte ptr [bx + 0x8d], 0
  05303B  75EB: 7c0b             jl 0x75f8
  05303D  75ED: 8a878d00         mov al, byte ptr [bx + 0x8d]
  053041  75F1: 98               cwde 
  053042  75F2: 8bd8             mov bx, ax
  053044  75F4: fe87cca0         inc byte ptr [bx - 0x5f34]
  053048  75F8: 8b1e4285         mov bx, word ptr [0x8542]
  05304C  75FC: 80bf8d000f       cmp byte ptr [bx + 0x8d], 0xf
  053051  7601: 7504             jne 0x7607
  053053  7603: fe06dba0         inc byte ptr [0xa0db]
  053057  7607: 83bfb80000       cmp word ptr [bx + 0xb8], 0
  05305C  760C: 7504             jne 0x7612
  05305E  760E: fe06dba0         inc byte ptr [0xa0db]
  053062  7612: 83bfaa0000       cmp word ptr [bx + 0xaa], 0
  053067  7617: 7504             jne 0x761d
  053069  7619: fe06d4a0         inc byte ptr [0xa0d4]
  05306D  761D: 83bfb60000       cmp word ptr [bx + 0xb6], 0
  053072  7622: 7504             jne 0x7628
  053074  7624: fe06daa0         inc byte ptr [0xa0da]
  053078  7628: f6471b10         test byte ptr [bx + 0x1b], 0x10
  05307C  762C: 7407             je 0x7635
  05307E  762E: 8b5e06           mov bx, word ptr [bp + 6]
  053081  7631: fe87b8a0         inc byte ptr [bx - 0x5f48]
  053085  7635: 8b1e4285         mov bx, word ptr [0x8542]
  053089  7639: 80671cdf         and byte ptr [bx + 0x1c], 0xdf
  05308D  763D: ff46f0           inc word ptr [bp - 0x10]
  053090  7640: a19e53           mov ax, word ptr [0x539e]
  053093  7643: 3946f0           cmp word ptr [bp - 0x10], ax
  053096  7646: 7c82             jl 0x75ca
  053098  7648: ff76e2           push word ptr [bp - 0x1e]
  05309B  764B: 6a01             push 1
  05309D  764D: 9aae0d1f18       lcall 0x181f, 0xdae
  0530A2  7652: 83c404           add sp, 4
  0530A5  7655: 6a10             push 0x10
  0530A7  7657: 68cca0           push 0xa0cc
  0530AA  765A: 68bca0           push 0xa0bc
  0530AD  765D: 9a820d1d0d       lcall 0xd1d, 0xd82
  0530B2  7662: 83c406           add sp, 6
  0530B5  7665: 2bc0             sub ax, ax
  0530B7  7667: 8946e6           mov word ptr [bp - 0x1a], ax
  0530BA  766A: eb38             jmp 0x76a4
  0530BC  766C: ff76f0           push word ptr [bp - 0x10]
  0530BF  766F: ff76e6           push word ptr [bp - 0x1a]
  0530C2  7672: 9ae60b1f18       lcall 0x181f, 0xbe6
  0530C7  7677: 83c404           add sp, 4
  0530CA  767A: 8bd8             mov bx, ax
  0530CC  767C: fe8fcca0         dec byte ptr [bx - 0x5f34]
  0530D0  7680: ff46f0           inc word ptr [bp - 0x10]
  0530D3  7683: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  0530D7  7687: 8a875031         mov al, byte ptr [bx + 0x3150]
  0530DB  768B: 2ae4             sub ah, ah
  0530DD  768D: 3b46f0           cmp ax, word ptr [bp - 0x10]
  0530E0  7690: 7fda             jg 0x766c
  0530E2  7692: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  0530E6  7696: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  0530EB  769B: 7504             jne 0x76a1
  0530ED  769D: fe0edaa0         dec byte ptr [0xa0da]
  0530F1  76A1: ff46e6           inc word ptr [bp - 0x1a]
  0530F4  76A4: a19c53           mov ax, word ptr [0x539c]
  0530F7  76A7: 3946e6           cmp word ptr [bp - 0x1a], ax
  0530FA  76AA: 7d56             jge 0x7702
  0530FC  76AC: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  053100  76B0: 8a874731         mov al, byte ptr [bx + 0x3147]
  053104  76B4: 240f             and al, 0xf
  053106  76B6: 8a4e06           mov cl, byte ptr [bp + 6]
  053109  76B9: 3ac1             cmp al, cl
  05310B  76BB: 75e4             jne 0x76a1
  05310D  76BD: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  053112  76C2: 7525             jne 0x76e9
  053114  76C4: 80bf4a3100       cmp byte ptr [bx + 0x314a], 0
  053119  76C9: 7c1e             jl 0x76e9
  05311B  76CB: 8a874a31         mov al, byte ptr [bx + 0x314a]
  05311F  76CF: 98               cwde 
  053120  76D0: 50               push ax
  053121  76D1: 9ae6091f18       lcall 0x181f, 0x9e6
  053126  76D6: 83c402           add sp, 2
  053129  76D9: 8a4606           mov al, byte ptr [bp + 6]
  05312C  76DC: 8b1e4285         mov bx, word ptr [0x8542]
  053130  76E0: 38471a           cmp byte ptr [bx + 0x1a], al
  053133  76E3: 7504             jne 0x76e9
  053135  76E5: 804f1c20         or byte ptr [bx + 0x1c], 0x20
  053139  76E9: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  05313D  76ED: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  053142  76F2: 729e             jb 0x7692
  053144  76F4: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  053149  76F9: 7797             ja 0x7692
  05314B  76FB: c746f00000       mov word ptr [bp - 0x10], 0
  053150  7700: eb81             jmp 0x7683
  053152  7702: c746f00000       mov word ptr [bp - 0x10], 0
  053157  7707: ff76f0           push word ptr [bp - 0x10]
  05315A  770A: ff7606           push word ptr [bp + 6]
  05315D  770D: 9a380a1f18       lcall 0x181f, 0xa38
  053162  7712: 83c404           add sp, 4
  053165  7715: a808             test al, 8
  053167  7717: 742b             je 0x7744
  053169  7719: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  05316E  771E: 035ef0           add bx, word ptr [bp - 0x10]
  053171  7721: 80bf488800       cmp byte ptr [bx - 0x77b8], 0
  053176  7726: 751c             jne 0x7744
  053178  7728: 6a03             push 3
  05317A  772A: 6a00             push 0
  05317C  772C: 8bf3             mov si, bx
  05317E  772E: 9ad4041f18       lcall 0x181f, 0x4d4
  053183  7733: 83c404           add sp, 4
  053186  7736: 0bc0             or ax, ax
  053188  7738: 750a             jne 0x7744
  05318A  773A: 80a43c88b7       and byte ptr [si - 0x77c4], 0xb7
  05318F  773F: 808c3c8801       or byte ptr [si - 0x77c4], 1
  053194  7744: 6976063c01       imul si, word ptr [bp + 6], 0x13c
  053199  7749: 8b5ef0           mov bx, word ptr [bp - 0x10]
  05319C  774C: 80b8488800       cmp byte ptr [bx + si - 0x77b8], 0
  0531A1  7751: 7404             je 0x7757
  0531A3  7753: fe884888         dec byte ptr [bx + si - 0x77b8]
  0531A7  7757: ff46f0           inc word ptr [bp - 0x10]
  0531AA  775A: 837ef004         cmp word ptr [bp - 0x10], 4
  0531AE  775E: 7ca7             jl 0x7707
  0531B0  7760: ff76e2           push word ptr [bp - 0x1e]
  0531B3  7763: 6a02             push 2
  0531B5  7765: 9aae0d1f18       lcall 0x181f, 0xdae
  0531BA  776A: 83c404           add sp, 4
  0531BD  776D: 9a70041f18       lcall 0x181f, 0x470
  0531C2  7772: ff7606           push word ptr [bp + 6]
  0531C5  7775: 0e               push cs
  0531C6  7776: e85703           call 0x7ad0
  0531C9  7779: 83c402           add sp, 2
  0531CC  777C: ff76e2           push word ptr [bp - 0x1e]
  0531CF  777F: 6a03             push 3
  0531D1  7781: 9aae0d1f18       lcall 0x181f, 0xdae
  0531D6  7786: 83c404           add sp, 4
  0531D9  7789: 9a70041f18       lcall 0x181f, 0x470
  0531DE  778E: ff7606           push word ptr [bp + 6]
  0531E1  7791: 0e               push cs
  0531E2  7792: e84a03           call 0x7adf
  0531E5  7795: 83c402           add sp, 2
  0531E8  7798: ff7606           push word ptr [bp + 6]
  0531EB  779B: 0e               push cs
  0531EC  779C: e81303           call 0x7ab2
  0531EF  779F: 83c402           add sp, 2
  0531F2  77A2: ff76e2           push word ptr [bp - 0x1e]
  0531F5  77A5: 6a04             push 4
  0531F7  77A7: 9aae0d1f18       lcall 0x181f, 0xdae
  0531FC  77AC: 83c404           add sp, 4
  0531FF  77AF: 9a70041f18       lcall 0x181f, 0x470
  053204  77B4: 9a7a041f18       lcall 0x181f, 0x47a
  053209  77B9: 9a70041f18       lcall 0x181f, 0x470
  05320E  77BE: 2bc0             sub ax, ax
  053210  77C0: 9a66041f18       lcall 0x181f, 0x466
  053215  77C5: 803e280800       cmp byte ptr [0x828], 0
  05321A  77CA: 7450             je 0x781c
  05321C  77CC: 833ef40700       cmp word ptr [0x7f4], 0
  053221  77D1: 7509             jne 0x77dc
  053223  77D3: 9af6001f18       lcall 0x181f, 0xf6
  053228  77D8: 0bc0             or ax, ax
  05322A  77DA: 7440             je 0x781c
  05322C  77DC: c746e41b00       mov word ptr [bp - 0x1c], 0x1b
  053231  77E1: b81f18           mov ax, 0x181f
  053234  77E4: 0df600           or ax, 0xf6
  053237  77E7: 7408             je 0x77f1
  053239  77E9: 9ae0031f18       lcall 0x181f, 0x3e0
  05323E  77EE: 8946e4           mov word ptr [bp - 0x1c], ax
  053241  77F1: ff76e4           push word ptr [bp - 0x1c]
  053244  77F4: 9a2c091d0d       lcall 0xd1d, 0x92c
  053249  77F9: 83c402           add sp, 2
  05324C  77FC: 8946e4           mov word ptr [bp - 0x1c], ax
  05324F  77FF: 3d4a00           cmp ax, 0x4a
  053252  7802: 7508             jne 0x780c
  053254  7804: c6062b0801       mov byte ptr [0x82b], 1
  053259  7809: eb11             jmp 0x781c
  05325B  780B: 90               nop 
  05325C  780C: 6a05             push 5
  05325E  780E: 9ab6051f18       lcall 0x181f, 0x5b6
  053263  7813: 83c402           add sp, 2
  053266  7816: c706c2530000     mov word ptr [0x53c2], 0
  05326C  781C: c746f40000       mov word ptr [bp - 0xc], 0
  053271  7821: e90f02           jmp 0x7a33
  053274  7824: c746fe0000       mov word ptr [bp - 2], 0
  053279  7829: 837ef400         cmp word ptr [bp - 0xc], 0
  05327D  782D: 7506             jne 0x7835
  05327F  782F: 837efe00         cmp word ptr [bp - 2], 0
  053283  7833: 7409             je 0x783e
  053285  7835: c746f60100       mov word ptr [bp - 0xa], 1
  05328A  783A: e9b101           jmp 0x79ee
  05328D  783D: 90               nop 
  05328E  783E: c746f60000       mov word ptr [bp - 0xa], 0
  053293  7843: e9a801           jmp 0x79ee
  053296  7846: 837ef600         cmp word ptr [bp - 0xa], 0
  05329A  784A: 7503             jne 0x784f
  05329C  784C: e9ae01           jmp 0x79fd
  05329F  784F: a1122d           mov ax, word ptr [0x2d12]
  0532A2  7852: 3946e6           cmp word ptr [bp - 0x1a], ax
  0532A5  7855: 7519             jne 0x7870
  0532A7  7857: ff06142d         inc word ptr [0x2d14]
  0532AB  785B: 833e142d14       cmp word ptr [0x2d14], 0x14
  0532B0  7860: 7e1a             jle 0x787c
  0532B2  7862: ff76e6           push word ptr [bp - 0x1a]
  0532B5  7865: 9a34091f18       lcall 0x181f, 0x934
  0532BA  786A: 83c402           add sp, 2
  0532BD  786D: eb0d             jmp 0x787c
  0532BF  786F: 90               nop 
  0532C0  7870: 8b46e6           mov ax, word ptr [bp - 0x1a]
  0532C3  7873: a3122d           mov word ptr [0x2d12], ax
  0532C6  7876: c706142d0000     mov word ptr [0x2d14], 0
  0532CC  787C: 833e260800       cmp word ptr [0x826], 0
  0532D1  7881: 745a             je 0x78dd
  0532D3  7883: a19653           mov ax, word ptr [0x5396]
  0532D6  7886: 394606           cmp word ptr [bp + 6], ax
  0532D9  7889: 7407             je 0x7892
  0532DB  788B: 833ea25300       cmp word ptr [0x53a2], 0
  0532E0  7890: 744b             je 0x78dd
  0532E2  7892: c70690530000     mov word ptr [0x5390], 0
  0532E8  7898: 8b46e6           mov ax, word ptr [bp - 0x1a]
  0532EB  789B: a39253           mov word ptr [0x5392], ax
  0532EE  789E: 6bd81c           imul bx, ax, 0x1c
  0532F1  78A1: 8a874531         mov al, byte ptr [bx + 0x3145]
  0532F5  78A5: 2ae4             sub ah, ah
  0532F7  78A7: 50               push ax
  0532F8  78A8: 8a874431         mov al, byte ptr [bx + 0x3144]
  0532FC  78AC: 50               push ax
  0532FD  78AD: 8bf3             mov si, bx
  0532FF  78AF: 9a02031f18       lcall 0x181f, 0x302
  053304  78B4: 83c404           add sp, 4
  053307  78B7: 0bc0             or ax, ax
  053309  78B9: 7410             je 0x78cb
  05330B  78BB: 8a844431         mov al, byte ptr [si + 0x3144]
  05330F  78BF: 2ae4             sub ah, ah
  053311  78C1: a34085           mov word ptr [0x8540], ax
  053314  78C4: 8a844531         mov al, byte ptr [si + 0x3145]
  053318  78C8: a33e85           mov word ptr [0x853e], ax
  05331B  78CB: 6a00             push 0
  05331D  78CD: 6a01             push 1
  05331F  78CF: 9a5e051f18       lcall 0x181f, 0x55e
  053324  78D4: 83c404           add sp, 4
  053327  78D7: a19c53           mov ax, word ptr [0x539c]
  05332A  78DA: 8946fa           mov word ptr [bp - 6], ax
  05332D  78DD: 837eea00         cmp word ptr [bp - 0x16], 0
  053331  78E1: 7439             je 0x791c
  053333  78E3: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  053337  78E7: 8a875b31         mov al, byte ptr [bx + 0x315b]
  05333B  78EB: 98               cwde 
  05333C  78EC: 50               push ax
  05333D  78ED: ff76e6           push word ptr [bp - 0x1a]
  053340  78F0: ff76f4           push word ptr [bp - 0xc]
  053343  78F3: 68ba17           push 0x17ba
  053346  78F6: 8bf3             mov si, bx
  053348  78F8: 9a7e071f18       lcall 0x181f, 0x77e
  05334D  78FD: 83c408           add sp, 8
  053350  7900: 8a844531         mov al, byte ptr [si + 0x3145]
  053354  7904: 2ae4             sub ah, ah
  053356  7906: 50               push ax
  053357  7907: 8a844431         mov al, byte ptr [si + 0x3144]
  05335B  790B: 50               push ax
  05335C  790C: 8a844631         mov al, byte ptr [si + 0x3146]
  053360  7910: 50               push ax
  053361  7911: 68ce17           push 0x17ce
  053364  7914: 9a7e071f18       lcall 0x181f, 0x77e
  053369  7919: 83c408           add sp, 8
  05336C  791C: ff76e6           push word ptr [bp - 0x1a]
  05336F  791F: 0e               push cs
  053370  7920: e85801           call 0x7a7b
  053373  7923: 83c402           add sp, 2
  053376  7926: a19c53           mov ax, word ptr [0x539c]
  053379  7929: 3946fa           cmp word ptr [bp - 6], ax
  05337C  792C: 7554             jne 0x7982
  05337E  792E: 837efe00         cmp word ptr [bp - 2], 0
  053382  7932: 744e             je 0x7982
  053384  7934: 8b46e6           mov ax, word ptr [bp - 0x1a]
  053387  7937: 9a7a091f18       lcall 0x181f, 0x97a
  05338C  793C: 0bc0             or ax, ax
  05338E  793E: 7542             jne 0x7982
  053390  7940: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  053394  7944: 8a874631         mov al, byte ptr [bx + 0x3146]
  053398  7948: 2ae4             sub ah, ah
  05339A  794A: 2d0a00           sub ax, 0xa
  05339D  794D: 7503             jne 0x7952
  05339F  794F: e98200           jmp 0x79d4
  0533A2  7952: 48               dec ax
  0533A3  7953: 7409             je 0x795e
  0533A5  7955: c746fc0100       mov word ptr [bp - 4], 1
  0533AA  795A: eb07             jmp 0x7963
  0533AC  795C: 90               nop 
  0533AD  795D: 90               nop 
  0533AE  795E: c746fc0300       mov word ptr [bp - 4], 3
  0533B3  7963: ff76fc           push word ptr [bp - 4]
  0533B6  7966: 6a02             push 2
  0533B8  7968: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  0533BC  796C: 8a874531         mov al, byte ptr [bx + 0x3145]
  0533C0  7970: 2ae4             sub ah, ah
  0533C2  7972: 50               push ax
  0533C3  7973: 8a874431         mov al, byte ptr [bx + 0x3144]
  0533C7  7977: 50               push ax
  0533C8  7978: ff7606           push word ptr [bp + 6]
  0533CB  797B: 0e               push cs
  0533CC  797C: e8f200           call 0x7a71
  0533CF  797F: 83c40a           add sp, 0xa
  0533D2  7982: 833e260800       cmp word ptr [0x826], 0
  0533D7  7987: 7453             je 0x79dc
  0533D9  7989: a19653           mov ax, word ptr [0x5396]
  0533DC  798C: 394606           cmp word ptr [bp + 6], ax
  0533DF  798F: 7407             je 0x7998
  0533E1  7991: 833ea25300       cmp word ptr [0x53a2], 0
  0533E6  7996: 7444             je 0x79dc
  0533E8  7998: a19c53           mov ax, word ptr [0x539c]
  0533EB  799B: 3946fa           cmp word ptr [bp - 6], ax
  0533EE  799E: 750c             jne 0x79ac
  0533F0  79A0: 8b46e6           mov ax, word ptr [bp - 0x1a]
  0533F3  79A3: 9a7a091f18       lcall 0x181f, 0x97a
  0533F8  79A8: 0bc0             or ax, ax
  0533FA  79AA: 7530             jne 0x79dc
  0533FC  79AC: 9a06000c0c       lcall 0xc0c, 6
  053401  79B1: 8946ec           mov word ptr [bp - 0x14], ax
  053404  79B4: 8956ee           mov word ptr [bp - 0x12], dx
  053407  79B7: 9a06000c0c       lcall 0xc0c, 6
  05340C  79BC: 8b4eec           mov cx, word ptr [bp - 0x14]
  05340F  79BF: 8b5eee           mov bx, word ptr [bp - 0x12]
  053412  79C2: 83c11e           add cx, 0x1e
  053415  79C5: 83d300           adc bx, 0
  053418  79C8: 3bd3             cmp dx, bx
  05341A  79CA: 7f10             jg 0x79dc
  05341C  79CC: 7ce9             jl 0x79b7
  05341E  79CE: 3bc1             cmp ax, cx
  053420  79D0: 730a             jae 0x79dc
  053422  79D2: ebe3             jmp 0x79b7
  053424  79D4: c746fc0200       mov word ptr [bp - 4], 2
  053429  79D9: eb88             jmp 0x7963
  05342B  79DB: 90               nop 
  05342C  79DC: c746f80100       mov word ptr [bp - 8], 1
  053431  79E1: 803e280800       cmp byte ptr [0x828], 0
  053436  79E6: 7406             je 0x79ee
  053438  79E8: c70690530100     mov word ptr [0x5390], 1
  05343E  79EE: 8b46e6           mov ax, word ptr [bp - 0x1a]
  053441  79F1: 9a7a091f18       lcall 0x181f, 0x97a
  053446  79F6: 0bc0             or ax, ax
  053448  79F8: 7403             je 0x79fd
  05344A  79FA: e949fe           jmp 0x7846
  05344D  79FD: ff4ee6           dec word ptr [bp - 0x1a]
  053450  7A00: 837ef800         cmp word ptr [bp - 8], 0
  053454  7A04: 752a             jne 0x7a30
  053456  7A06: 837ee600         cmp word ptr [bp - 0x1a], 0
  05345A  7A0A: 7c24             jl 0x7a30
  05345C  7A0C: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  053460  7A10: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  053465  7A15: 7411             je 0x7a28
  053467  7A17: 80bf46310a       cmp byte ptr [bx + 0x3146], 0xa
  05346C  7A1C: 740a             je 0x7a28
  05346E  7A1E: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  053473  7A23: 7403             je 0x7a28
  053475  7A25: e9fcfd           jmp 0x7824
  053478  7A28: c746fe0100       mov word ptr [bp - 2], 1
  05347D  7A2D: e9f9fd           jmp 0x7829
  053480  7A30: ff46f4           inc word ptr [bp - 0xc]
  053483  7A33: 837ef402         cmp word ptr [bp - 0xc], 2
  053487  7A37: 7d0f             jge 0x7a48
  053489  7A39: c746f80000       mov word ptr [bp - 8], 0
  05348E  7A3E: a19c53           mov ax, word ptr [0x539c]
  053491  7A41: 48               dec ax
  053492  7A42: 8946e6           mov word ptr [bp - 0x1a], ax
  053495  7A45: ebb9             jmp 0x7a00
  053497  7A47: 90               nop 
  053498  7A48: 2bc0             sub ax, ax
  05349A  7A4A: 8b56f8           mov dx, word ptr [bp - 8]
  05349D  7A4D: 9a5c041f18       lcall 0x181f, 0x45c
  0534A2  7A52: 837ef800         cmp word ptr [bp - 8], 0
  0534A6  7A56: 7403             je 0x7a5b
  0534A8  7A58: e95efd           jmp 0x77b9
  0534AB  7A5B: ff76e2           push word ptr [bp - 0x1e]
  0534AE  7A5E: 6a05             push 5
  0534B0  7A60: 9aae0d1f18       lcall 0x181f, 0xdae
  0534B5  7A65: 83c404           add sp, 4
  0534B8  7A68: 5e               pop si
  0534B9  7A69: c9               leave 
  0534BA  7A6A: cb               retf 
  0534BB  7A6B: 90               nop 
  0534BC  7A6C: ea64041f1a       ljmp 0x1a1f:0x464
  0534C1  7A71: ea70041f1a       ljmp 0x1a1f:0x470
  0534C6  7A76: ea7c041f1a       ljmp 0x1a1f:0x47c
  0534CB  7A7B: ea88041f1a       ljmp 0x1a1f:0x488
  0534D0  7A80: ea94041f1a       ljmp 0x1a1f:0x494
  0534D5  7A85: eaa0041f1a       ljmp 0x1a1f:0x4a0
  0534DA  7A8A: eaac041f1a       ljmp 0x1a1f:0x4ac
  0534DF  7A8F: eab8041f1a       ljmp 0x1a1f:0x4b8
  0534E4  7A94: eac4041f1a       ljmp 0x1a1f:0x4c4
  0534E9  7A99: ead0041f1a       ljmp 0x1a1f:0x4d0
  0534EE  7A9E: eadc041f1a       ljmp 0x1a1f:0x4dc
  0534F3  7AA3: eae8041f1a       ljmp 0x1a1f:0x4e8
  0534F8  7AA8: eaf4041f1a       ljmp 0x1a1f:0x4f4
  0534FD  7AAD: ea00051f1a       ljmp 0x1a1f:0x500
  053502  7AB2: ea0c051f1a       ljmp 0x1a1f:0x50c
  053507  7AB7: ea18051f1a       ljmp 0x1a1f:0x518
  05350C  7ABC: ea24051f1a       ljmp 0x1a1f:0x524
  053511  7AC1: ea30051f1a       ljmp 0x1a1f:0x530
  053516  7AC6: ea3c051f1a       ljmp 0x1a1f:0x53c
  05351B  7ACB: ea48051f1a       ljmp 0x1a1f:0x548
  053520  7AD0: ea54051f1a       ljmp 0x1a1f:0x554
  053525  7AD5: ea60051f1a       ljmp 0x1a1f:0x560
  05352A  7ADA: ea6c051f1a       ljmp 0x1a1f:0x56c
  05352F  7ADF: ea78051f1a       ljmp 0x1a1f:0x578
  053534  7AE4: ea84051f1a       ljmp 0x1a1f:0x584
  053539  7AE9: ea90051f1a       ljmp 0x1a1f:0x590
