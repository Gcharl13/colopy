; ============================================================
; VICEROY.EXE overlay page 0x10 (record 15) -- RE-SEGMENTED
; file_offset (disk image) = 0x05A950
; code_offset (first insn) = 0x05AF70
; code_end (next reloc hdr)= 0x05E740  [resident size 893 para -> nominal_end 0x05E120; on-disk code spills past it]
; reloc_count = 382  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x05A950)
; functions in page = 9
; ============================================================

; ---- func_05AF70  size=364  insns=123  prologue=ENTER 0x0014,0  terminal=RETF ----
  05AF70  0620: c8140000         enter 0x14, 0
  05AF74  0624: 56               push si
  05AF75  0625: c746f0ffff       mov word ptr [bp - 0x10], 0xffff
  05AF7A  062A: c746fe0000       mov word ptr [bp - 2], 0
  05AF7F  062F: c746f20000       mov word ptr [bp - 0xe], 0
  05AF84  0634: 837e0600         cmp word ptr [bp + 6], 0
  05AF88  0638: 7c5b             jl 0x695
  05AF8A  063A: 8b4606           mov ax, word ptr [bp + 6]
  05AF8D  063D: 8946f4           mov word ptr [bp - 0xc], ax
  05AF90  0640: 6bd81c           imul bx, ax, 0x1c
  05AF93  0643: 8a874431         mov al, byte ptr [bx + 0x3144]
  05AF97  0647: 2ae4             sub ah, ah
  05AF99  0649: 8946fa           mov word ptr [bp - 6], ax
  05AF9C  064C: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  05AFA0  0650: 2aed             sub ch, ch
  05AFA2  0652: 894ef8           mov word ptr [bp - 8], cx
  05AFA5  0655: 51               push cx
  05AFA6  0656: 50               push ax
  05AFA7  0657: 9a96061f18       lcall 0x181f, 0x696
  05AFAC  065C: 83c404           add sp, 4
  05AFAF  065F: 0bc0             or ax, ax
  05AFB1  0661: 7c05             jl 0x668
  05AFB3  0663: b80100           mov ax, 1
  05AFB6  0666: eb02             jmp 0x66a
  05AFB8  0668: 2bc0             sub ax, ax
  05AFBA  066A: 8946fc           mov word ptr [bp - 4], ax
  05AFBD  066D: ff76f8           push word ptr [bp - 8]
  05AFC0  0670: ff76fa           push word ptr [bp - 6]
  05AFC3  0673: 9a02031f18       lcall 0x181f, 0x302
  05AFC8  0678: 83c404           add sp, 4
  05AFCB  067B: 0bc0             or ax, ax
  05AFCD  067D: 7416             je 0x695
  05AFCF  067F: ff76f8           push word ptr [bp - 8]
  05AFD2  0682: ff76fa           push word ptr [bp - 6]
  05AFD5  0685: 9a68071f18       lcall 0x181f, 0x768
  05AFDA  068A: 83c404           add sp, 4
  05AFDD  068D: 8946f6           mov word ptr [bp - 0xa], ax
  05AFE0  0690: c746fe0100       mov word ptr [bp - 2], 1
  05AFE5  0695: 8b4606           mov ax, word ptr [bp + 6]
  05AFE8  0698: 9aee021f18       lcall 0x181f, 0x2ee
  05AFED  069D: eb40             jmp 0x6df
  05AFEF  069F: 90               nop 
  05AFF0  06A0: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05AFF4  06A4: 8a874731         mov al, byte ptr [bx + 0x3147]
  05AFF8  06A8: 240f             and al, 0xf
  05AFFA  06AA: 3c04             cmp al, 4
  05AFFC  06AC: 7203             jb 0x6b1
  05AFFE  06AE: d166ee           shl word ptr [bp - 0x12], 1
  05B001  06B1: 837efc00         cmp word ptr [bp - 4], 0
  05B005  06B5: 7503             jne 0x6ba
  05B007  06B7: e98200           jmp 0x73c
  05B00A  06BA: 6b5ef41c         imul bx, word ptr [bp - 0xc], 0x1c
  05B00E  06BE: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05B012  06C2: 2aff             sub bh, bh
  05B014  06C4: 8bc3             mov ax, bx
  05B016  06C6: d1e3             shl bx, 1
  05B018  06C8: 03d8             add bx, ax
  05B01A  06CA: d1e3             shl bx, 1
  05B01C  06CC: 03d8             add bx, ax
  05B01E  06CE: d1e3             shl bx, 1
  05B020  06D0: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  05B025  06D5: 7565             jne 0x73c
  05B027  06D7: 8b46f4           mov ax, word ptr [bp - 0xc]
  05B02A  06DA: 9ae4021f18       lcall 0x181f, 0x2e4
  05B02F  06DF: 8946f4           mov word ptr [bp - 0xc], ax
  05B032  06E2: 0bc0             or ax, ax
  05B034  06E4: 7d03             jge 0x6e9
  05B036  06E6: e99d00           jmp 0x786
  05B039  06E9: 6a00             push 0
  05B03B  06EB: 50               push ax
  05B03C  06EC: 9ac8091f18       lcall 0x181f, 0x9c8
  05B041  06F1: 83c404           add sp, 4
  05B044  06F4: ff7608           push word ptr [bp + 8]
  05B047  06F7: ff76f4           push word ptr [bp - 0xc]
  05B04A  06FA: 8bf0             mov si, ax
  05B04C  06FC: 9adc091f18       lcall 0x181f, 0x9dc
  05B051  0701: 83c404           add sp, 4
  05B054  0704: 8ae0             mov ah, al
  05B056  0706: 2ac0             sub al, al
  05B058  0708: 2bc6             sub ax, si
  05B05A  070A: 05ff00           add ax, 0xff
  05B05D  070D: 8946ee           mov word ptr [bp - 0x12], ax
  05B060  0710: 6b5ef41c         imul bx, word ptr [bp - 0xc], 0x1c
  05B064  0714: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  05B069  0719: 7596             jne 0x6b1
  05B06B  071B: 837efc00         cmp word ptr [bp - 4], 0
  05B06F  071F: 7403             je 0x724
  05B071  0721: e97cff           jmp 0x6a0
  05B074  0724: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  05B079  0729: 7486             je 0x6b1
  05B07B  072B: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  05B080  0730: 7503             jne 0x735
  05B082  0732: e97cff           jmp 0x6b1
  05B085  0735: c16eee03         shr word ptr [bp - 0x12], 3
  05B089  0739: e975ff           jmp 0x6b1
  05B08C  073C: 837efe00         cmp word ptr [bp - 2], 0
  05B090  0740: 742a             je 0x76c
  05B092  0742: 6b5ef41c         imul bx, word ptr [bp - 0xc], 0x1c
  05B096  0746: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05B09B  074B: 720f             jb 0x75c
  05B09D  074D: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05B0A2  0752: 7708             ja 0x75c
  05B0A4  0754: c746ec0100       mov word ptr [bp - 0x14], 1
  05B0A9  0759: eb06             jmp 0x761
  05B0AB  075B: 90               nop 
  05B0AC  075C: c746ec0000       mov word ptr [bp - 0x14], 0
  05B0B1  0761: 8b46ec           mov ax, word ptr [bp - 0x14]
  05B0B4  0764: 3946f6           cmp word ptr [bp - 0xa], ax
  05B0B7  0767: 7403             je 0x76c
  05B0B9  0769: e96bff           jmp 0x6d7
  05B0BC  076C: 8b46f2           mov ax, word ptr [bp - 0xe]
  05B0BF  076F: 3946ee           cmp word ptr [bp - 0x12], ax
  05B0C2  0772: 7303             jae 0x777
  05B0C4  0774: e960ff           jmp 0x6d7
  05B0C7  0777: 8b46ee           mov ax, word ptr [bp - 0x12]
  05B0CA  077A: 8946f2           mov word ptr [bp - 0xe], ax
  05B0CD  077D: 8b46f4           mov ax, word ptr [bp - 0xc]
  05B0D0  0780: 8946f0           mov word ptr [bp - 0x10], ax
  05B0D3  0783: e951ff           jmp 0x6d7
  05B0D6  0786: 8b46f0           mov ax, word ptr [bp - 0x10]
  05B0D9  0789: 5e               pop si
  05B0DA  078A: c9               leave 
  05B0DB  078B: cb               retf 

; ---- func_05B0DC  size=486  insns=167  prologue=ENTER 0x0072,0  terminal=RETF ----
  05B0DC  078C: c8720000         enter 0x72, 0
  05B0E0  0790: 57               push di
  05B0E1  0791: 56               push si
  05B0E2  0792: c7469cffff       mov word ptr [bp - 0x64], 0xffff
  05B0E7  0797: 2bc0             sub ax, ax
  05B0E9  0799: 8946a2           mov word ptr [bp - 0x5e], ax
  05B0EC  079C: 8946a0           mov word ptr [bp - 0x60], ax
  05B0EF  079F: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05B0F3  07A3: 8a874731         mov al, byte ptr [bx + 0x3147]
  05B0F7  07A7: 250f00           and ax, 0xf
  05B0FA  07AA: 894696           mov word ptr [bp - 0x6a], ax
  05B0FD  07AD: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B101  07B1: 8a875031         mov al, byte ptr [bx + 0x3150]
  05B105  07B5: 2ae4             sub ah, ah
  05B107  07B7: 894698           mov word ptr [bp - 0x68], ax
  05B10A  07BA: c70654a10000     mov word ptr [0xa154], 0
  05B110  07C0: 0bc0             or ax, ax
  05B112  07C2: 7503             jne 0x7c7
  05B114  07C4: e9a401           jmp 0x96b
  05B117  07C7: c7469c0000       mov word ptr [bp - 0x64], 0
  05B11C  07CC: b80100           mov ax, 1
  05B11F  07CF: a354a1           mov word ptr [0xa154], ax
  05B122  07D2: 50               push ax
  05B123  07D3: 50               push ax
  05B124  07D4: ff7608           push word ptr [bp + 8]
  05B127  07D7: 9aa0011f1a       lcall 0x1a1f, 0x1a0
  05B12C  07DC: 83c406           add sp, 6
  05B12F  07DF: 3b4698           cmp ax, word ptr [bp - 0x68]
  05B132  07E2: 7c03             jl 0x7e7
  05B134  07E4: e98401           jmp 0x96b
  05B137  07E7: 837e9604         cmp word ptr [bp - 0x6a], 4
  05B13B  07EB: 7c03             jl 0x7f0
  05B13D  07ED: e90a01           jmp 0x8fa
  05B140  07F0: 6b5e9634         imul bx, word ptr [bp - 0x6a], 0x34
  05B144  07F4: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05B149  07F9: 7403             je 0x7fe
  05B14B  07FB: e9fc00           jmp 0x8fa
  05B14E  07FE: 8d1e7c08         lea bx, [0x87c]
  05B152  0802: 8d06081b         lea ax, [0x1b08]
  05B156  0806: 2bd2             sub dx, dx
  05B158  0808: 9a82011f19       lcall 0x191f, 0x182
  05B15D  080D: 8946a0           mov word ptr [bp - 0x60], ax
  05B160  0810: 8956a2           mov word ptr [bp - 0x5e], dx
  05B163  0813: 0bd0             or dx, ax
  05B165  0815: 7503             jne 0x81a
  05B167  0817: e95101           jmp 0x96b
  05B16A  081A: 6a63             push 0x63
  05B16C  081C: ff36fa2d         push word ptr [0x2dfa]
  05B170  0820: 9a22001f18       lcall 0x181f, 0x22
  05B175  0825: 83c402           add sp, 2
  05B178  0828: 52               push dx
  05B179  0829: 50               push ax
  05B17A  082A: ff76a2           push word ptr [bp - 0x5e]
  05B17D  082D: ff76a0           push word ptr [bp - 0x60]
  05B180  0830: 9a76011f19       lcall 0x191f, 0x176
  05B185  0835: 83c40a           add sp, 0xa
  05B188  0838: c7469a0000       mov word ptr [bp - 0x66], 0
  05B18D  083D: eb71             jmp 0x8b0
  05B18F  083F: 90               nop 
  05B190  0840: ff769a           push word ptr [bp - 0x66]
  05B193  0843: ff7606           push word ptr [bp + 6]
  05B196  0846: 9ae60b1f18       lcall 0x181f, 0xbe6
  05B19B  084B: 83c404           add sp, 4
  05B19E  084E: 894694           mov word ptr [bp - 0x6c], ax
  05B1A1  0851: c646b000         mov byte ptr [bp - 0x50], 0
  05B1A5  0855: ff769a           push word ptr [bp - 0x66]
  05B1A8  0858: ff7606           push word ptr [bp + 6]
  05B1AB  085B: 9a680c1f18       lcall 0x181f, 0xc68
  05B1B0  0860: 83c404           add sp, 4
  05B1B3  0863: 89469e           mov word ptr [bp - 0x62], ax
  05B1B6  0866: 50               push ax
  05B1B7  0867: 8d46b0           lea ax, [bp - 0x50]
  05B1BA  086A: 16               push ss
  05B1BB  086B: 50               push ax
  05B1BC  086C: 9a82011f18       lcall 0x181f, 0x182
  05B1C1  0871: 83c406           add sp, 6
  05B1C4  0874: 8d46b0           lea ax, [bp - 0x50]
  05B1C7  0877: 50               push ax
  05B1C8  0878: 9a78011f18       lcall 0x181f, 0x178
  05B1CD  087D: 83c402           add sp, 2
  05B1D0  0880: 8b5e94           mov bx, word ptr [bp - 0x6c]
  05B1D3  0883: d1e3             shl bx, 1
  05B1D5  0885: ffb7c097         push word ptr [bx - 0x6840]
  05B1D9  0889: 8d46b0           lea ax, [bp - 0x50]
  05B1DC  088C: 50               push ax
  05B1DD  088D: 9a6e011f18       lcall 0x181f, 0x16e
  05B1E2  0892: 83c404           add sp, 4
  05B1E5  0895: 8b469a           mov ax, word ptr [bp - 0x66]
  05B1E8  0898: 40               inc ax
  05B1E9  0899: 50               push ax
  05B1EA  089A: 8d46b0           lea ax, [bp - 0x50]
  05B1ED  089D: 16               push ss
  05B1EE  089E: 50               push ax
  05B1EF  089F: ff76a2           push word ptr [bp - 0x5e]
  05B1F2  08A2: ff76a0           push word ptr [bp - 0x60]
  05B1F5  08A5: 9a76011f19       lcall 0x191f, 0x176
  05B1FA  08AA: 83c40a           add sp, 0xa
  05B1FD  08AD: ff469a           inc word ptr [bp - 0x66]
  05B200  08B0: 8b4698           mov ax, word ptr [bp - 0x68]
  05B203  08B3: 39469a           cmp word ptr [bp - 0x66], ax
  05B206  08B6: 7c88             jl 0x840
  05B208  08B8: ff76a2           push word ptr [bp - 0x5e]
  05B20B  08BB: ff76a0           push word ptr [bp - 0x60]
  05B20E  08BE: 9a6a011f19       lcall 0x191f, 0x16a
  05B213  08C3: 89469c           mov word ptr [bp - 0x64], ax
  05B216  08C6: ff76a2           push word ptr [bp - 0x5e]
  05B219  08C9: ff76a0           push word ptr [bp - 0x60]
  05B21C  08CC: 9aa8011f19       lcall 0x191f, 0x1a8
  05B221  08D1: 837e9c63         cmp word ptr [bp - 0x64], 0x63
  05B225  08D5: 7509             jne 0x8e0
  05B227  08D7: c7469cffff       mov word ptr [bp - 0x64], 0xffff
  05B22C  08DC: e98c00           jmp 0x96b
  05B22F  08DF: 90               nop 
  05B230  08E0: 837e9c00         cmp word ptr [bp - 0x64], 0
  05B234  08E4: 7e0c             jle 0x8f2
  05B236  08E6: c70654a10000     mov word ptr [0xa154], 0
  05B23C  08EC: ff4e9c           dec word ptr [bp - 0x64]
  05B23F  08EF: eb7a             jmp 0x96b
  05B241  08F1: 90               nop 
  05B242  08F2: c7469c0000       mov word ptr [bp - 0x64], 0
  05B247  08F7: eb72             jmp 0x96b
  05B249  08F9: 90               nop 
  05B24A  08FA: c7469a0000       mov word ptr [bp - 0x66], 0
  05B24F  08FF: eb46             jmp 0x947
  05B251  0901: 90               nop 
  05B252  0902: ff769a           push word ptr [bp - 0x66]
  05B255  0905: ff7606           push word ptr [bp + 6]
  05B258  0908: 9ae60b1f18       lcall 0x181f, 0xbe6
  05B25D  090D: 83c404           add sp, 4
  05B260  0910: 894694           mov word ptr [bp - 0x6c], ax
  05B263  0913: ff769a           push word ptr [bp - 0x66]
  05B266  0916: ff7606           push word ptr [bp + 6]
  05B269  0919: 9a680c1f18       lcall 0x181f, 0xc68
  05B26E  091E: 83c404           add sp, 4
  05B271  0921: 89469e           mov word ptr [bp - 0x62], ax
  05B274  0924: 8a469a           mov al, byte ptr [bp - 0x66]
  05B277  0927: 8b769a           mov si, word ptr [bp - 0x66]
  05B27A  092A: 88428e           mov byte ptr [bp + si - 0x72], al
  05B27D  092D: 8b7e96           mov di, word ptr [bp - 0x6a]
  05B280  0930: c1e704           shl di, 4
  05B283  0933: 8b5e94           mov bx, word ptr [bp - 0x6c]
  05B286  0936: 8a81bc84         mov al, byte ptr [bx + di - 0x7b44]
  05B28A  093A: 2ae4             sub ah, ah
  05B28C  093C: f76e9e           imul word ptr [bp - 0x62]
  05B28F  093F: d1e6             shl si, 1
  05B291  0941: 8942a4           mov word ptr [bp + si - 0x5c], ax
  05B294  0944: ff469a           inc word ptr [bp - 0x66]
  05B297  0947: 8b4698           mov ax, word ptr [bp - 0x68]
  05B29A  094A: 39469a           cmp word ptr [bp - 0x66], ax
  05B29D  094D: 7cb3             jl 0x902
  05B29F  094F: 8d468e           lea ax, [bp - 0x72]
  05B2A2  0952: 16               push ss
  05B2A3  0953: 50               push ax
  05B2A4  0954: 8d46a4           lea ax, [bp - 0x5c]
  05B2A7  0957: 16               push ss
  05B2A8  0958: 50               push ax
  05B2A9  0959: 8b4698           mov ax, word ptr [bp - 0x68]
  05B2AC  095C: 9ad00e1f19       lcall 0x191f, 0xed0
  05B2B1  0961: 8b7698           mov si, word ptr [bp - 0x68]
  05B2B4  0964: 8a428d           mov al, byte ptr [bp + si - 0x73]
  05B2B7  0967: 98               cwde 
  05B2B8  0968: 89469c           mov word ptr [bp - 0x64], ax
  05B2BB  096B: 8b469c           mov ax, word ptr [bp - 0x64]
  05B2BE  096E: 5e               pop si
  05B2BF  096F: 5f               pop di
  05B2C0  0970: c9               leave 
  05B2C1  0971: cb               retf 

; ---- func_05B2C2  size=2925  insns=974  prologue=ENTER 0x003A,0  terminal=RETF ----
  05B2C2  0972: c83a0000         enter 0x3a, 0
  05B2C6  0976: 57               push di
  05B2C7  0977: 56               push si
  05B2C8  0978: 2bc0             sub ax, ax
  05B2CA  097A: 8946cc           mov word ptr [bp - 0x34], ax
  05B2CD  097D: 8946f6           mov word ptr [bp - 0xa], ax
  05B2D0  0980: 8946d8           mov word ptr [bp - 0x28], ax
  05B2D3  0983: c746dc0100       mov word ptr [bp - 0x24], 1
  05B2D8  0988: 817e062c01       cmp word ptr [bp + 6], 0x12c
  05B2DD  098D: 7c07             jl 0x996
  05B2DF  098F: 2bc0             sub ax, ax
  05B2E1  0991: 5e               pop si
  05B2E2  0992: 5f               pop di
  05B2E3  0993: c9               leave 
  05B2E4  0994: cb               retf 
  05B2E5  0995: 90               nop 
  05B2E6  0996: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B2EA  099A: 8a874731         mov al, byte ptr [bx + 0x3147]
  05B2EE  099E: 250f00           and ax, 0xf
  05B2F1  09A1: 8946f8           mov word ptr [bp - 8], ax
  05B2F4  09A4: 837e0800         cmp word ptr [bp + 8], 0
  05B2F8  09A8: 7d08             jge 0x9b2
  05B2FA  09AA: c746fe1000       mov word ptr [bp - 2], 0x10
  05B2FF  09AF: e9ab04           jmp 0xe5d
  05B302  09B2: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05B306  09B6: 8a874731         mov al, byte ptr [bx + 0x3147]
  05B30A  09BA: 250f00           and ax, 0xf
  05B30D  09BD: 8946d0           mov word ptr [bp - 0x30], ax
  05B310  09C0: 8a874631         mov al, byte ptr [bx + 0x3146]
  05B314  09C4: 2ae4             sub ah, ah
  05B316  09C6: 8946fe           mov word ptr [bp - 2], ax
  05B319  09C9: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B31D  09CD: 80bf46310a       cmp byte ptr [bx + 0x3146], 0xa
  05B322  09D2: 740d             je 0x9e1
  05B324  09D4: 38a74631         cmp byte ptr [bx + 0x3146], ah
  05B328  09D8: 7407             je 0x9e1
  05B32A  09DA: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  05B32F  09DF: 7507             jne 0x9e8
  05B331  09E1: c746ea0100       mov word ptr [bp - 0x16], 1
  05B336  09E6: eb05             jmp 0x9ed
  05B338  09E8: c746ea0000       mov word ptr [bp - 0x16], 0
  05B33D  09ED: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05B341  09F1: 8a874431         mov al, byte ptr [bx + 0x3144]
  05B345  09F5: 2ae4             sub ah, ah
  05B347  09F7: 8946f0           mov word ptr [bp - 0x10], ax
  05B34A  09FA: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  05B34E  09FE: 2aed             sub ch, ch
  05B350  0A00: 894eee           mov word ptr [bp - 0x12], cx
  05B353  0A03: 51               push cx
  05B354  0A04: 50               push ax
  05B355  0A05: 9a02031f18       lcall 0x181f, 0x302
  05B35A  0A0A: 83c404           add sp, 4
  05B35D  0A0D: 0bc0             or ax, ax
  05B35F  0A0F: 7411             je 0xa22
  05B361  0A11: ff76ee           push word ptr [bp - 0x12]
  05B364  0A14: ff76f0           push word ptr [bp - 0x10]
  05B367  0A17: 9a68071f18       lcall 0x181f, 0x768
  05B36C  0A1C: 83c404           add sp, 4
  05B36F  0A1F: 0946d8           or word ptr [bp - 0x28], ax
  05B372  0A22: ff760e           push word ptr [bp + 0xe]
  05B375  0A25: ff760c           push word ptr [bp + 0xc]
  05B378  0A28: 9a02031f18       lcall 0x181f, 0x302
  05B37D  0A2D: 83c404           add sp, 4
  05B380  0A30: 0bc0             or ax, ax
  05B382  0A32: 741b             je 0xa4f
  05B384  0A34: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B388  0A38: 8a874531         mov al, byte ptr [bx + 0x3145]
  05B38C  0A3C: 2ae4             sub ah, ah
  05B38E  0A3E: 50               push ax
  05B38F  0A3F: 8a874431         mov al, byte ptr [bx + 0x3144]
  05B393  0A43: 50               push ax
  05B394  0A44: 9a68071f18       lcall 0x181f, 0x768
  05B399  0A49: 83c404           add sp, 4
  05B39C  0A4C: 0946d8           or word ptr [bp - 0x28], ax
  05B39F  0A4F: 837ef804         cmp word ptr [bp - 8], 4
  05B3A3  0A53: 7c50             jl 0xaa5
  05B3A5  0A55: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B3A9  0A59: f687483110       test byte ptr [bx + 0x3148], 0x10
  05B3AE  0A5E: 7510             jne 0xa70
  05B3B0  0A60: 6a01             push 1
  05B3B2  0A62: 6a00             push 0
  05B3B4  0A64: 9ad4041f18       lcall 0x181f, 0x4d4
  05B3B9  0A69: 83c404           add sp, 4
  05B3BC  0A6C: 0bc0             or ax, ax
  05B3BE  0A6E: 7435             je 0xaa5
  05B3C0  0A70: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B3C4  0A74: 80bf463114       cmp byte ptr [bx + 0x3146], 0x14
  05B3C9  0A79: 7407             je 0xa82
  05B3CB  0A7B: 80bf463116       cmp byte ptr [bx + 0x3146], 0x16
  05B3D0  0A80: 7508             jne 0xa8a
  05B3D2  0A82: 6b5ef84e         imul bx, word ptr [bp - 8], 0x4e
  05B3D6  0A86: fe87a559         inc byte ptr [bx + 0x59a5]
  05B3DA  0A8A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B3DE  0A8E: 80bf463115       cmp byte ptr [bx + 0x3146], 0x15
  05B3E3  0A93: 7407             je 0xa9c
  05B3E5  0A95: 80bf463116       cmp byte ptr [bx + 0x3146], 0x16
  05B3EA  0A9A: 7509             jne 0xaa5
  05B3EC  0A9C: 6b5ef84e         imul bx, word ptr [bp - 8], 0x4e
  05B3F0  0AA0: 8387a85919       add word ptr [bx + 0x59a8], 0x19
  05B3F5  0AA5: 8b5efe           mov bx, word ptr [bp - 2]
  05B3F8  0AA8: 8bc3             mov ax, bx
  05B3FA  0AAA: d1e3             shl bx, 1
  05B3FC  0AAC: 03d8             add bx, ax
  05B3FE  0AAE: d1e3             shl bx, 1
  05B400  0AB0: 03d8             add bx, ax
  05B402  0AB2: d1e3             shl bx, 1
  05B404  0AB4: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  05B409  0AB9: 7505             jne 0xac0
  05B40B  0ABB: c746ea0000       mov word ptr [bp - 0x16], 0
  05B410  0AC0: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05B414  0AC4: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05B419  0AC9: 7207             jb 0xad2
  05B41B  0ACB: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05B420  0AD0: 7606             jbe 0xad8
  05B422  0AD2: 837ed800         cmp word ptr [bp - 0x28], 0
  05B426  0AD6: 7405             je 0xadd
  05B428  0AD8: c746ea0000       mov word ptr [bp - 0x16], 0
  05B42D  0ADD: 837eea00         cmp word ptr [bp - 0x16], 0
  05B431  0AE1: 746b             je 0xb4e
  05B433  0AE3: ff76ee           push word ptr [bp - 0x12]
  05B436  0AE6: ff76f0           push word ptr [bp - 0x10]
  05B439  0AE9: 9a02031f18       lcall 0x181f, 0x302
  05B43E  0AEE: 83c404           add sp, 4
  05B441  0AF1: 0bc0             or ax, ax
  05B443  0AF3: 7459             je 0xb4e
  05B445  0AF5: 837ed800         cmp word ptr [bp - 0x28], 0
  05B449  0AF9: 7453             je 0xb4e
  05B44B  0AFB: 837efe0f         cmp word ptr [bp - 2], 0xf
  05B44F  0AFF: 7548             jne 0xb49
  05B451  0B01: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05B455  0B05: 8bc3             mov ax, bx
  05B457  0B07: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05B45B  0B0B: 8bf0             mov si, ax
  05B45D  0B0D: 8a845031         mov al, byte ptr [si + 0x3150]
  05B461  0B11: 2ae4             sub ah, ah
  05B463  0B13: 2aff             sub bh, bh
  05B465  0B15: 8bcb             mov cx, bx
  05B467  0B17: d1e3             shl bx, 1
  05B469  0B19: 03d9             add bx, cx
  05B46B  0B1B: d1e3             shl bx, 1
  05B46D  0B1D: 03d9             add bx, cx
  05B46F  0B1F: d1e3             shl bx, 1
  05B471  0B21: 8a8f3752         mov cl, byte ptr [bx + 0x5237]
  05B475  0B25: 2aed             sub ch, ch
  05B477  0B27: 2bc8             sub cx, ax
  05B479  0B29: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B47D  0B2D: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05B481  0B31: 2aff             sub bh, bh
  05B483  0B33: 8bc3             mov ax, bx
  05B485  0B35: d1e3             shl bx, 1
  05B487  0B37: 03d8             add bx, ax
  05B489  0B39: d1e3             shl bx, 1
  05B48B  0B3B: 03d8             add bx, ax
  05B48D  0B3D: d1e3             shl bx, 1
  05B48F  0B3F: 8a873852         mov al, byte ptr [bx + 0x5238]
  05B493  0B43: 2ae4             sub ah, ah
  05B495  0B45: 3bc8             cmp cx, ax
  05B497  0B47: 7d05             jge 0xb4e
  05B499  0B49: c746dc0000       mov word ptr [bp - 0x24], 0
  05B49E  0B4E: 837eea00         cmp word ptr [bp - 0x16], 0
  05B4A2  0B52: 7503             jne 0xb57
  05B4A4  0B54: e9e500           jmp 0xc3c
  05B4A7  0B57: 837ed004         cmp word ptr [bp - 0x30], 4
  05B4AB  0B5B: 7c03             jl 0xb60
  05B4AD  0B5D: e9dc00           jmp 0xc3c
  05B4B0  0B60: 837edc00         cmp word ptr [bp - 0x24], 0
  05B4B4  0B64: 7503             jne 0xb69
  05B4B6  0B66: e9d300           jmp 0xc3c
  05B4B9  0B69: 8b4606           mov ax, word ptr [bp + 6]
  05B4BC  0B6C: 9a12081f18       lcall 0x181f, 0x812
  05B4C1  0B71: ff76d0           push word ptr [bp - 0x30]
  05B4C4  0B74: ff7606           push word ptr [bp + 6]
  05B4C7  0B77: 9a94081f18       lcall 0x181f, 0x894
  05B4CC  0B7C: 83c404           add sp, 4
  05B4CF  0B7F: 8b4606           mov ax, word ptr [bp + 6]
  05B4D2  0B82: 8b56f0           mov dx, word ptr [bp - 0x10]
  05B4D5  0B85: 8b5eee           mov bx, word ptr [bp - 0x12]
  05B4D8  0B88: 9a44081f18       lcall 0x181f, 0x844
  05B4DD  0B8D: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B4E1  0B91: c6874c3100       mov byte ptr [bx + 0x314c], 0
  05B4E6  0B96: 837e0a00         cmp word ptr [bp + 0xa], 0
  05B4EA  0B9A: 7463             je 0xbff
  05B4EC  0B9C: ff76f8           push word ptr [bp - 8]
  05B4EF  0B9F: 8bf3             mov si, bx
  05B4F1  0BA1: 9aa4091f18       lcall 0x181f, 0x9a4
  05B4F6  0BA6: 83c402           add sp, 2
  05B4F9  0BA9: 50               push ax
  05B4FA  0BAA: 6a00             push 0
  05B4FC  0BAC: 9a38041f18       lcall 0x181f, 0x438
  05B501  0BB1: 83c404           add sp, 4
  05B504  0BB4: ff76d0           push word ptr [bp - 0x30]
  05B507  0BB7: 9aa4091f18       lcall 0x181f, 0x9a4
  05B50C  0BBC: 83c402           add sp, 2
  05B50F  0BBF: 50               push ax
  05B510  0BC0: 6a01             push 1
  05B512  0BC2: 9a38041f18       lcall 0x181f, 0x438
  05B517  0BC7: 83c404           add sp, 4
  05B51A  0BCA: b064             mov al, 0x64
  05B51C  0BCC: f6ac5b31         imul byte ptr [si + 0x315b]
  05B520  0BD0: 99               cdq 
  05B521  0BD1: 52               push dx
  05B522  0BD2: 50               push ax
  05B523  0BD3: 6a00             push 0
  05B525  0BD5: 9aae091f18       lcall 0x181f, 0x9ae
  05B52A  0BDA: 83c406           add sp, 6
  05B52D  0BDD: 8a844631         mov al, byte ptr [si + 0x3146]
  05B531  0BE1: 2ae4             sub ah, ah
  05B533  0BE3: 3d0c00           cmp ax, 0xc
  05B536  0BE6: 742c             je 0xc14
  05B538  0BE8: 7715             ja 0xbff
  05B53A  0BEA: 0ac0             or al, al
  05B53C  0BEC: 742e             je 0xc1c
  05B53E  0BEE: 2c0a             sub al, 0xa
  05B540  0BF0: 750d             jne 0xbff
  05B542  0BF2: 6a01             push 1
  05B544  0BF4: 68131b           push 0x1b13
  05B547  0BF7: 9a52061f18       lcall 0x181f, 0x652
  05B54C  0BFC: 83c404           add sp, 4
  05B54F  0BFF: 837ed800         cmp word ptr [bp - 0x28], 0
  05B553  0C03: 7503             jne 0xc08
  05B555  0C05: e987fd           jmp 0x98f
  05B558  0C08: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B55C  0C0C: c6874c3101       mov byte ptr [bx + 0x314c], 1
  05B561  0C11: e97bfd           jmp 0x98f
  05B564  0C14: 6a01             push 1
  05B566  0C16: 681f1b           push 0x1b1f
  05B569  0C19: ebdc             jmp 0xbf7
  05B56B  0C1B: 90               nop 
  05B56C  0C1C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B570  0C20: 80bf5b3115       cmp byte ptr [bx + 0x315b], 0x15
  05B575  0C25: 750d             jne 0xc34
  05B577  0C27: c6875b311c       mov byte ptr [bx + 0x315b], 0x1c
  05B57C  0C2C: 6a01             push 1
  05B57E  0C2E: 682c1b           push 0x1b2c
  05B581  0C31: ebc4             jmp 0xbf7
  05B583  0C33: 90               nop 
  05B584  0C34: 6a01             push 1
  05B586  0C36: 683d1b           push 0x1b3d
  05B589  0C39: ebbc             jmp 0xbf7
  05B58B  0C3B: 90               nop 
  05B58C  0C3C: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05B590  0C40: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05B595  0C45: 720a             jb 0xc51
  05B597  0C47: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05B59C  0C4C: 7703             ja 0xc51
  05B59E  0C4E: e9aa01           jmp 0xdfb
  05B5A1  0C51: 837ed800         cmp word ptr [bp - 0x28], 0
  05B5A5  0C55: 7403             je 0xc5a
  05B5A7  0C57: e9a101           jmp 0xdfb
  05B5AA  0C5A: c746deffff       mov word ptr [bp - 0x22], 0xffff
  05B5AF  0C5F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B5B3  0C63: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  05B5B8  0C68: 7505             jne 0xc6f
  05B5BA  0C6A: c746de0100       mov word ptr [bp - 0x22], 1
  05B5BF  0C6F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B5C3  0C73: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  05B5C8  0C78: 7505             jne 0xc7f
  05B5CA  0C7A: c746de0000       mov word ptr [bp - 0x22], 0
  05B5CF  0C7F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B5D3  0C83: 80bf463109       cmp byte ptr [bx + 0x3146], 9
  05B5D8  0C88: 7505             jne 0xc8f
  05B5DA  0C8A: c746de0000       mov word ptr [bp - 0x22], 0
  05B5DF  0C8F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B5E3  0C93: 80bf463107       cmp byte ptr [bx + 0x3146], 7
  05B5E8  0C98: 7505             jne 0xc9f
  05B5EA  0C9A: c746de0900       mov word ptr [bp - 0x22], 9
  05B5EF  0C9F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B5F3  0CA3: 80bf463108       cmp byte ptr [bx + 0x3146], 8
  05B5F8  0CA8: 7505             jne 0xcaf
  05B5FA  0CAA: c746de0600       mov word ptr [bp - 0x22], 6
  05B5FF  0CAF: 837ede00         cmp word ptr [bp - 0x22], 0
  05B603  0CB3: 7d03             jge 0xcb8
  05B605  0CB5: e98a00           jmp 0xd42
  05B608  0CB8: 7510             jne 0xcca
  05B60A  0CBA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B60E  0CBE: 80bf5b3118       cmp byte ptr [bx + 0x315b], 0x18
  05B613  0CC3: 7505             jne 0xcca
  05B615  0CC5: c746de0300       mov word ptr [bp - 0x22], 3
  05B61A  0CCA: 837e0a00         cmp word ptr [bp + 0xa], 0
  05B61E  0CCE: 7464             je 0xd34
  05B620  0CD0: ff76f8           push word ptr [bp - 8]
  05B623  0CD3: 9aa4091f18       lcall 0x181f, 0x9a4
  05B628  0CD8: 83c402           add sp, 2
  05B62B  0CDB: 50               push ax
  05B62C  0CDC: 6a00             push 0
  05B62E  0CDE: 9a38041f18       lcall 0x181f, 0x438
  05B633  0CE3: 83c404           add sp, 4
  05B636  0CE6: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B63A  0CEA: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05B63E  0CEE: 2aff             sub bh, bh
  05B640  0CF0: 8bc3             mov ax, bx
  05B642  0CF2: d1e3             shl bx, 1
  05B644  0CF4: 03d8             add bx, ax
  05B646  0CF6: d1e3             shl bx, 1
  05B648  0CF8: 03d8             add bx, ax
  05B64A  0CFA: d1e3             shl bx, 1
  05B64C  0CFC: ffb73052         push word ptr [bx + 0x5230]
  05B650  0D00: 6a01             push 1
  05B652  0D02: 9a38041f18       lcall 0x181f, 0x438
  05B657  0D07: 83c404           add sp, 4
  05B65A  0D0A: 8b5ede           mov bx, word ptr [bp - 0x22]
  05B65D  0D0D: 8bc3             mov ax, bx
  05B65F  0D0F: d1e3             shl bx, 1
  05B661  0D11: 03d8             add bx, ax
  05B663  0D13: d1e3             shl bx, 1
  05B665  0D15: 03d8             add bx, ax
  05B667  0D17: d1e3             shl bx, 1
  05B669  0D19: ffb73052         push word ptr [bx + 0x5230]
  05B66D  0D1D: 6a02             push 2
  05B66F  0D1F: 9a38041f18       lcall 0x181f, 0x438
  05B674  0D24: 83c404           add sp, 4
  05B677  0D27: 6a01             push 1
  05B679  0D29: 684d1b           push 0x1b4d
  05B67C  0D2C: 9a52061f18       lcall 0x181f, 0x652
  05B681  0D31: 83c404           add sp, 4
  05B684  0D34: 8a46de           mov al, byte ptr [bp - 0x22]
  05B687  0D37: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B68B  0D3B: 88874631         mov byte ptr [bx + 0x3146], al
  05B68F  0D3F: e99607           jmp 0x14d8
  05B692  0D42: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B696  0D46: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  05B69B  0D4B: 7403             je 0xd50
  05B69D  0D4D: e9ab00           jmp 0xdfb
  05B6A0  0D50: f687483180       test byte ptr [bx + 0x3148], 0x80
  05B6A5  0D55: 7557             jne 0xdae
  05B6A7  0D57: 837e0a00         cmp word ptr [bp + 0xa], 0
  05B6AB  0D5B: 7445             je 0xda2
  05B6AD  0D5D: ff76f8           push word ptr [bp - 8]
  05B6B0  0D60: 8bf3             mov si, bx
  05B6B2  0D62: 9aa4091f18       lcall 0x181f, 0x9a4
  05B6B7  0D67: 83c402           add sp, 2
  05B6BA  0D6A: 50               push ax
  05B6BB  0D6B: 6a00             push 0
  05B6BD  0D6D: 9a38041f18       lcall 0x181f, 0x438
  05B6C2  0D72: 83c404           add sp, 4
  05B6C5  0D75: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  05B6C9  0D79: 2aff             sub bh, bh
  05B6CB  0D7B: 8bc3             mov ax, bx
  05B6CD  0D7D: d1e3             shl bx, 1
  05B6CF  0D7F: 03d8             add bx, ax
  05B6D1  0D81: d1e3             shl bx, 1
  05B6D3  0D83: 03d8             add bx, ax
  05B6D5  0D85: d1e3             shl bx, 1
  05B6D7  0D87: ffb73052         push word ptr [bx + 0x5230]
  05B6DB  0D8B: 6a01             push 1
  05B6DD  0D8D: 9a38041f18       lcall 0x181f, 0x438
  05B6E2  0D92: 83c404           add sp, 4
  05B6E5  0D95: 6a01             push 1
  05B6E7  0D97: 68541b           push 0x1b54
  05B6EA  0D9A: 9a52061f18       lcall 0x181f, 0x652
  05B6EF  0D9F: 83c404           add sp, 4
  05B6F2  0DA2: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B6F6  0DA6: 808f483180       or byte ptr [bx + 0x3148], 0x80
  05B6FB  0DAB: e92a07           jmp 0x14d8
  05B6FE  0DAE: 837e0a00         cmp word ptr [bp + 0xa], 0
  05B702  0DB2: 7447             je 0xdfb
  05B704  0DB4: ff76f8           push word ptr [bp - 8]
  05B707  0DB7: 9aa4091f18       lcall 0x181f, 0x9a4
  05B70C  0DBC: 83c402           add sp, 2
  05B70F  0DBF: 50               push ax
  05B710  0DC0: 6a00             push 0
  05B712  0DC2: 9a38041f18       lcall 0x181f, 0x438
  05B717  0DC7: 83c404           add sp, 4
  05B71A  0DCA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B71E  0DCE: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05B722  0DD2: 2aff             sub bh, bh
  05B724  0DD4: 8bc3             mov ax, bx
  05B726  0DD6: d1e3             shl bx, 1
  05B728  0DD8: 03d8             add bx, ax
  05B72A  0DDA: d1e3             shl bx, 1
  05B72C  0DDC: 03d8             add bx, ax
  05B72E  0DDE: d1e3             shl bx, 1
  05B730  0DE0: ffb73052         push word ptr [bx + 0x5230]
  05B734  0DE4: 6a01             push 1
  05B736  0DE6: 9a38041f18       lcall 0x181f, 0x438
  05B73B  0DEB: 83c404           add sp, 4
  05B73E  0DEE: 6a01             push 1
  05B740  0DF0: 685e1b           push 0x1b5e
  05B743  0DF3: 9a52061f18       lcall 0x181f, 0x652
  05B748  0DF8: 83c404           add sp, 4
  05B74B  0DFB: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B74F  0DFF: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05B754  0E04: 7257             jb 0xe5d
  05B756  0E06: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05B75B  0E0B: 7750             ja 0xe5d
  05B75D  0E0D: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05B761  0E11: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05B766  0E16: 7245             jb 0xe5d
  05B768  0E18: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05B76D  0E1D: 773e             ja 0xe5d
  05B76F  0E1F: 837e0a00         cmp word ptr [bp + 0xa], 0
  05B773  0E23: 7408             je 0xe2d
  05B775  0E25: b84d00           mov ax, 0x4d
  05B778  0E28: 9ac0041f18       lcall 0x181f, 0x4c0
  05B77D  0E2D: 6a01             push 1
  05B77F  0E2F: 6a01             push 1
  05B781  0E31: ff7608           push word ptr [bp + 8]
  05B784  0E34: 9aa0011f1a       lcall 0x1a1f, 0x1a0
  05B789  0E39: 83c406           add sp, 6
  05B78C  0E3C: 0bc0             or ax, ax
  05B78E  0E3E: 7414             je 0xe54
  05B790  0E40: ff7608           push word ptr [bp + 8]
  05B793  0E43: ff7606           push word ptr [bp + 6]
  05B796  0E46: 0e               push cs
  05B797  0E47: e8752f           call 0x3dbf
  05B79A  0E4A: 83c404           add sp, 4
  05B79D  0E4D: 0bc0             or ax, ax
  05B79F  0E4F: 7c03             jl 0xe54
  05B7A1  0E51: e94801           jmp 0xf9c
  05B7A4  0E54: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B7A8  0E58: c687503100       mov byte ptr [bx + 0x3150], 0
  05B7AD  0E5D: c746c60000       mov word ptr [bp - 0x3a], 0
  05B7B2  0E62: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B7B6  0E66: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05B7BB  0E6B: 7303             jae 0xe70
  05B7BD  0E6D: e9e302           jmp 0x1153
  05B7C0  0E70: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05B7C5  0E75: 7603             jbe 0xe7a
  05B7C7  0E77: e9d902           jmp 0x1153
  05B7CA  0E7A: ff76f8           push word ptr [bp - 8]
  05B7CD  0E7D: 8bf3             mov si, bx
  05B7CF  0E7F: 9aa4091f18       lcall 0x181f, 0x9a4
  05B7D4  0E84: 83c402           add sp, 2
  05B7D7  0E87: 50               push ax
  05B7D8  0E88: 6a00             push 0
  05B7DA  0E8A: 9a38041f18       lcall 0x181f, 0x438
  05B7DF  0E8F: 83c404           add sp, 4
  05B7E2  0E92: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  05B7E6  0E96: 2aff             sub bh, bh
  05B7E8  0E98: 8bc3             mov ax, bx
  05B7EA  0E9A: d1e3             shl bx, 1
  05B7EC  0E9C: 03d8             add bx, ax
  05B7EE  0E9E: d1e3             shl bx, 1
  05B7F0  0EA0: 03d8             add bx, ax
  05B7F2  0EA2: d1e3             shl bx, 1
  05B7F4  0EA4: ffb73052         push word ptr [bx + 0x5230]
  05B7F8  0EA8: b80100           mov ax, 1
  05B7FB  0EAB: 8946c6           mov word ptr [bp - 0x3a], ax
  05B7FE  0EAE: 8946f6           mov word ptr [bp - 0xa], ax
  05B801  0EB1: 50               push ax
  05B802  0EB2: 9a38041f18       lcall 0x181f, 0x438
  05B807  0EB7: 83c404           add sp, 4
  05B80A  0EBA: 8b5efe           mov bx, word ptr [bp - 2]
  05B80D  0EBD: 8bc3             mov ax, bx
  05B80F  0EBF: d1e3             shl bx, 1
  05B811  0EC1: 03d8             add bx, ax
  05B813  0EC3: d1e3             shl bx, 1
  05B815  0EC5: 03d8             add bx, ax
  05B817  0EC7: d1e3             shl bx, 1
  05B819  0EC9: 80bf3b5200       cmp byte ptr [bx + 0x523b], 0
  05B81E  0ECE: 7503             jne 0xed3
  05B820  0ED0: e98002           jmp 0x1153
  05B823  0ED3: 8a873b52         mov al, byte ptr [bx + 0x523b]
  05B827  0ED7: 2ae4             sub ah, ah
  05B829  0ED9: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  05B82D  0EDD: 2aff             sub bh, bh
  05B82F  0EDF: 8bcb             mov cx, bx
  05B831  0EE1: d1e3             shl bx, 1
  05B833  0EE3: 03d9             add bx, cx
  05B835  0EE5: d1e3             shl bx, 1
  05B837  0EE7: 03d9             add bx, cx
  05B839  0EE9: d1e3             shl bx, 1
  05B83B  0EEB: 8a8f3c52         mov cl, byte ptr [bx + 0x523c]
  05B83F  0EEF: 2aed             sub ch, ch
  05B841  0EF1: 894ee4           mov word ptr [bp - 0x1c], cx
  05B844  0EF4: 03c1             add ax, cx
  05B846  0EF6: 50               push ax
  05B847  0EF7: 6a01             push 1
  05B849  0EF9: 9ad4041f18       lcall 0x181f, 0x4d4
  05B84E  0EFE: 83c404           add sp, 4
  05B851  0F01: 3b46e4           cmp ax, word ptr [bp - 0x1c]
  05B854  0F04: 7e05             jle 0xf0b
  05B856  0F06: c746c60000       mov word ptr [bp - 0x3a], 0
  05B85B  0F0B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B85F  0F0F: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05B863  0F13: 2aff             sub bh, bh
  05B865  0F15: 8bcb             mov cx, bx
  05B867  0F17: 8bc3             mov ax, bx
  05B869  0F19: d1e3             shl bx, 1
  05B86B  0F1B: 03d8             add bx, ax
  05B86D  0F1D: d1e3             shl bx, 1
  05B86F  0F1F: 03d8             add bx, ax
  05B871  0F21: d1e3             shl bx, 1
  05B873  0F23: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  05B878  0F28: 7503             jne 0xf2d
  05B87A  0F2A: e91d01           jmp 0x104a
  05B87D  0F2D: f606825301       test byte ptr [0x5382], 1
  05B882  0F32: 7403             je 0xf37
  05B884  0F34: e9a601           jmp 0x10dd
  05B887  0F37: 8bf1             mov si, cx
  05B889  0F39: 6b5ef813         imul bx, word ptr [bp - 8], 0x13
  05B88D  0F3D: 8a804c92         mov al, byte ptr [bx + si - 0x6db4]
  05B891  0F41: 2ae4             sub ah, ah
  05B893  0F43: 8946fa           mov word ptr [bp - 6], ax
  05B896  0F46: 8b5ef8           mov bx, word ptr [bp - 8]
  05B899  0F49: 8a8f9892         mov cl, byte ptr [bx - 0x6d68]
  05B89D  0F4D: 2aed             sub ch, ch
  05B89F  0F4F: 3bc1             cmp ax, cx
  05B8A1  0F51: 7f07             jg 0xf5a
  05B8A3  0F53: 80bf249408       cmp byte ptr [bx - 0x6bdc], 8
  05B8A8  0F58: 7605             jbe 0xf5f
  05B8AA  0F5A: c746c60000       mov word ptr [bp - 0x3a], 0
  05B8AF  0F5F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B8B3  0F63: 80bf463111       cmp byte ptr [bx + 0x3146], 0x11
  05B8B8  0F68: 7518             jne 0xf82
  05B8BA  0F6A: 837efe11         cmp word ptr [bp - 2], 0x11
  05B8BE  0F6E: 7512             jne 0xf82
  05B8C0  0F70: 8a46fa           mov al, byte ptr [bp - 6]
  05B8C3  0F73: 6b5ed013         imul bx, word ptr [bp - 0x30], 0x13
  05B8C7  0F77: 38875d92         cmp byte ptr [bx - 0x6da3], al
  05B8CB  0F7B: 7305             jae 0xf82
  05B8CD  0F7D: c746c60000       mov word ptr [bp - 0x3a], 0
  05B8D2  0F82: 837efa02         cmp word ptr [bp - 6], 2
  05B8D6  0F86: 7c03             jl 0xf8b
  05B8D8  0F88: e95201           jmp 0x10dd
  05B8DB  0F8B: 8b5ef8           mov bx, word ptr [bp - 8]
  05B8DE  0F8E: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  05B8E3  0F93: 7503             jne 0xf98
  05B8E5  0F95: e94501           jmp 0x10dd
  05B8E8  0F98: e93d01           jmp 0x10d8
  05B8EB  0F9B: 90               nop 
  05B8EC  0F9C: 50               push ax
  05B8ED  0F9D: ff7606           push word ptr [bp + 6]
  05B8F0  0FA0: 9aec0a1f18       lcall 0x181f, 0xaec
  05B8F5  0FA5: 83c404           add sp, 4
  05B8F8  0FA8: 8946ce           mov word ptr [bp - 0x32], ax
  05B8FB  0FAB: ff36c48d         push word ptr [0x8dc4]
  05B8FF  0FAF: 50               push ax
  05B900  0FB0: ff7608           push word ptr [bp + 8]
  05B903  0FB3: 9a580d1f18       lcall 0x181f, 0xd58
  05B908  0FB8: 83c406           add sp, 6
  05B90B  0FBB: 837e0a00         cmp word ptr [bp + 0xa], 0
  05B90F  0FBF: 7503             jne 0xfc4
  05B911  0FC1: e969fe           jmp 0xe2d
  05B914  0FC4: 833e54a100       cmp word ptr [0xa154], 0
  05B919  0FC9: 7503             jne 0xfce
  05B91B  0FCB: e95ffe           jmp 0xe2d
  05B91E  0FCE: a1c48d           mov ax, word ptr [0x8dc4]
  05B921  0FD1: 99               cdq 
  05B922  0FD2: 52               push dx
  05B923  0FD3: 50               push ax
  05B924  0FD4: 6a00             push 0
  05B926  0FD6: 9aae091f18       lcall 0x181f, 0x9ae
  05B92B  0FDB: 83c406           add sp, 6
  05B92E  0FDE: ff76f8           push word ptr [bp - 8]
  05B931  0FE1: 9aa4091f18       lcall 0x181f, 0x9a4
  05B936  0FE6: 83c402           add sp, 2
  05B939  0FE9: 50               push ax
  05B93A  0FEA: 6a00             push 0
  05B93C  0FEC: 9a38041f18       lcall 0x181f, 0x438
  05B941  0FF1: 83c404           add sp, 4
  05B944  0FF4: 8b5ece           mov bx, word ptr [bp - 0x32]
  05B947  0FF7: d1e3             shl bx, 1
  05B949  0FF9: ffb7c097         push word ptr [bx - 0x6840]
  05B94D  0FFD: 6a01             push 1
  05B94F  0FFF: 9a38041f18       lcall 0x181f, 0x438
  05B954  1004: 83c404           add sp, 4
  05B957  1007: ff76d0           push word ptr [bp - 0x30]
  05B95A  100A: 9aa4091f18       lcall 0x181f, 0x9a4
  05B95F  100F: 83c402           add sp, 2
  05B962  1012: 50               push ax
  05B963  1013: 6a02             push 2
  05B965  1015: 9a38041f18       lcall 0x181f, 0x438
  05B96A  101A: 83c404           add sp, 4
  05B96D  101D: 8b5efe           mov bx, word ptr [bp - 2]
  05B970  1020: 8bc3             mov ax, bx
  05B972  1022: d1e3             shl bx, 1
  05B974  1024: 03d8             add bx, ax
  05B976  1026: d1e3             shl bx, 1
  05B978  1028: 03d8             add bx, ax
  05B97A  102A: d1e3             shl bx, 1
  05B97C  102C: ffb73052         push word ptr [bx + 0x5230]
  05B980  1030: 6a03             push 3
  05B982  1032: 9a38041f18       lcall 0x181f, 0x438
  05B987  1037: 83c404           add sp, 4
  05B98A  103A: 6a00             push 0
  05B98C  103C: 68691b           push 0x1b69
  05B98F  103F: 9a52061f18       lcall 0x181f, 0x652
  05B994  1044: 83c404           add sp, 4
  05B997  1047: e9e3fd           jmp 0xe2d
  05B99A  104A: 6b5ef813         imul bx, word ptr [bp - 8], 0x13
  05B99E  104E: 8a875d92         mov al, byte ptr [bx - 0x6da3]
  05B9A2  1052: f6262553         mul byte ptr [0x5325]
  05B9A6  1056: 8b76f8           mov si, word ptr [bp - 8]
  05B9A9  1059: 8a8c1494         mov cl, byte ptr [si - 0x6bec]
  05B9AD  105D: 2aed             sub ch, ch
  05B9AF  105F: 6b7e061c         imul di, word ptr [bp + 6], 0x1c
  05B9B3  1063: 8bd3             mov dx, bx
  05B9B5  1065: 8a9d4631         mov bl, byte ptr [di + 0x3146]
  05B9B9  1069: 2aff             sub bh, bh
  05B9BB  106B: 8bfb             mov di, bx
  05B9BD  106D: d1e3             shl bx, 1
  05B9BF  106F: 03df             add bx, di
  05B9C1  1071: d1e3             shl bx, 1
  05B9C3  1073: 03df             add bx, di
  05B9C5  1075: d1e3             shl bx, 1
  05B9C7  1077: 8bf8             mov di, ax
  05B9C9  1079: 8a873752         mov al, byte ptr [bx + 0x5237]
  05B9CD  107D: 2ae4             sub ah, ah
  05B9CF  107F: 2bc8             sub cx, ax
  05B9D1  1081: 2bcf             sub cx, di
  05B9D3  1083: 8bda             mov bx, dx
  05B9D5  1085: 8a875c92         mov al, byte ptr [bx - 0x6da4]
  05B9D9  1089: 2bc8             sub cx, ax
  05B9DB  108B: 894efa           mov word ptr [bp - 6], cx
  05B9DE  108E: 8a841894         mov al, byte ptr [si - 0x6be8]
  05B9E2  1092: 8a8c2494         mov cl, byte ptr [si - 0x6bdc]
  05B9E6  1096: 2aed             sub ch, ch
  05B9E8  1098: 2bc1             sub ax, cx
  05B9EA  109A: 3d0800           cmp ax, 8
  05B9ED  109D: 7e05             jle 0x10a4
  05B9EF  109F: c746c60000       mov word ptr [bp - 0x3a], 0
  05B9F4  10A4: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05B9F8  10A8: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05B9FD  10AD: 750c             jne 0x10bb
  05B9FF  10AF: 833e8e5350       cmp word ptr [0x538e], 0x50
  05BA04  10B4: 7c05             jl 0x10bb
  05BA06  10B6: c746c60000       mov word ptr [bp - 0x3a], 0
  05BA0B  10BB: 6a06             push 6
  05BA0D  10BD: 6a03             push 3
  05BA0F  10BF: 8bde             mov bx, si
  05BA11  10C1: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  05BA15  10C5: c0e802           shr al, 2
  05BA18  10C8: 2ae4             sub ah, ah
  05BA1A  10CA: 50               push ax
  05BA1B  10CB: 9a5c031f18       lcall 0x181f, 0x35c
  05BA20  10D0: 83c406           add sp, 6
  05BA23  10D3: 3b46fa           cmp ax, word ptr [bp - 6]
  05BA26  10D6: 7e05             jle 0x10dd
  05BA28  10D8: c746c60100       mov word ptr [bp - 0x3a], 1
  05BA2D  10DD: f606825301       test byte ptr [0x5382], 1
  05BA32  10E2: 7423             je 0x1107
  05BA34  10E4: a1d253           mov ax, word ptr [0x53d2]
  05BA37  10E7: 3946f8           cmp word ptr [bp - 8], ax
  05BA3A  10EA: 751b             jne 0x1107
  05BA3C  10EC: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05BA40  10F0: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05BA45  10F5: 7510             jne 0x1107
  05BA47  10F7: 6b5ef813         imul bx, word ptr [bp - 8], 0x13
  05BA4B  10FB: 80bf5e9202       cmp byte ptr [bx - 0x6da2], 2
  05BA50  1100: 7305             jae 0x1107
  05BA52  1102: c746c60100       mov word ptr [bp - 0x3a], 1
  05BA57  1107: 837e0800         cmp word ptr [bp + 8], 0
  05BA5B  110B: 7d05             jge 0x1112
  05BA5D  110D: c746c60100       mov word ptr [bp - 0x3a], 1
  05BA62  1112: 837ec600         cmp word ptr [bp - 0x3a], 0
  05BA66  1116: 753b             jne 0x1153
  05BA68  1118: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05BA6C  111C: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05BA70  1120: 2aff             sub bh, bh
  05BA72  1122: 8bcb             mov cx, bx
  05BA74  1124: 8bc3             mov ax, bx
  05BA76  1126: d1e3             shl bx, 1
  05BA78  1128: 03d8             add bx, ax
  05BA7A  112A: d1e3             shl bx, 1
  05BA7C  112C: 03d8             add bx, ax
  05BA7E  112E: d1e3             shl bx, 1
  05BA80  1130: 8a873752         mov al, byte ptr [bx + 0x5237]
  05BA84  1134: 8b76f8           mov si, word ptr [bp - 8]
  05BA87  1137: 28841494         sub byte ptr [si - 0x6bec], al
  05BA8B  113B: 8bc3             mov ax, bx
  05BA8D  113D: 8bf9             mov di, cx
  05BA8F  113F: 6bde13           imul bx, si, 0x13
  05BA92  1142: fe894c92         dec byte ptr [bx + di - 0x6db4]
  05BA96  1146: 8bd8             mov bx, ax
  05BA98  1148: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  05BA9D  114D: 7404             je 0x1153
  05BA9F  114F: fe8c2494         dec byte ptr [si - 0x6bdc]
  05BAA3  1153: 837ec600         cmp word ptr [bp - 0x3a], 0
  05BAA7  1157: 7503             jne 0x115c
  05BAA9  1159: e9d801           jmp 0x1334
  05BAAC  115C: c746e2e703       mov word ptr [bp - 0x1e], 0x3e7
  05BAB1  1161: c746c80f27       mov word ptr [bp - 0x38], 0x270f
  05BAB6  1166: c746d20000       mov word ptr [bp - 0x2e], 0
  05BABB  116B: eb65             jmp 0x11d2
  05BABD  116D: 90               nop 
  05BABE  116E: 69d8ca00         imul bx, ax, 0xca
  05BAC2  1172: 8a46f8           mov al, byte ptr [bp - 8]
  05BAC5  1175: 3887605d         cmp byte ptr [bx + 0x5d60], al
  05BAC9  1179: 7554             jne 0x11cf
  05BACB  117B: 6a07             push 7
  05BACD  117D: ff76d2           push word ptr [bp - 0x2e]
  05BAD0  1180: 9a22031f18       lcall 0x181f, 0x322
  05BAD5  1185: 83c404           add sp, 4
  05BAD8  1188: 0bc0             or ax, ax
  05BADA  118A: 7443             je 0x11cf
  05BADC  118C: 695ed2ca00       imul bx, word ptr [bp - 0x2e], 0xca
  05BAE1  1191: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  05BAE5  1195: 2ae4             sub ah, ah
  05BAE7  1197: 50               push ax
  05BAE8  1198: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  05BAEC  119C: 50               push ax
  05BAED  119D: ff760e           push word ptr [bp + 0xe]
  05BAF0  11A0: ff760c           push word ptr [bp + 0xc]
  05BAF3  11A3: 8bf3             mov si, bx
  05BAF5  11A5: 9a7a031f18       lcall 0x181f, 0x37a
  05BAFA  11AA: 83c408           add sp, 8
  05BAFD  11AD: 3b46c8           cmp ax, word ptr [bp - 0x38]
  05BB00  11B0: 7f1d             jg 0x11cf
  05BB02  11B2: 0bc0             or ax, ax
  05BB04  11B4: 7419             je 0x11cf
  05BB06  11B6: 8946c8           mov word ptr [bp - 0x38], ax
  05BB09  11B9: 8b46d2           mov ax, word ptr [bp - 0x2e]
  05BB0C  11BC: 8946e2           mov word ptr [bp - 0x1e], ax
  05BB0F  11BF: 8a8c465d         mov cl, byte ptr [si + 0x5d46]
  05BB13  11C3: 2aed             sub ch, ch
  05BB15  11C5: 894eda           mov word ptr [bp - 0x26], cx
  05BB18  11C8: 8a8c475d         mov cl, byte ptr [si + 0x5d47]
  05BB1C  11CC: 894ed6           mov word ptr [bp - 0x2a], cx
  05BB1F  11CF: ff46d2           inc word ptr [bp - 0x2e]
  05BB22  11D2: 8b46d2           mov ax, word ptr [bp - 0x2e]
  05BB25  11D5: 39069e53         cmp word ptr [0x539e], ax
  05BB29  11D9: 7f93             jg 0x116e
  05BB2B  11DB: 817ee2e703       cmp word ptr [bp - 0x1e], 0x3e7
  05BB30  11E0: 7554             jne 0x1236
  05BB32  11E2: 8b46f8           mov ax, word ptr [bp - 8]
  05BB35  11E5: 2d1400           sub ax, 0x14
  05BB38  11E8: 8946da           mov word ptr [bp - 0x26], ax
  05BB3B  11EB: 8946d6           mov word ptr [bp - 0x2a], ax
  05BB3E  11EE: f606825301       test byte ptr [0x5382], 1
  05BB43  11F3: 7411             je 0x1206
  05BB45  11F5: a19853           mov ax, word ptr [0x5398]
  05BB48  11F8: 3946f8           cmp word ptr [bp - 8], ax
  05BB4B  11FB: 7509             jne 0x1206
  05BB4D  11FD: c746c60000       mov word ptr [bp - 0x3a], 0
  05BB52  1202: e92f01           jmp 0x1334
  05BB55  1205: 90               nop 
  05BB56  1206: 8b5ef8           mov bx, word ptr [bp - 8]
  05BB59  1209: d1e3             shl bx, 1
  05BB5B  120B: 8b878c83         mov ax, word ptr [bx - 0x7c74]
  05BB5F  120F: 8946d4           mov word ptr [bp - 0x2c], ax
  05BB62  1212: a1d253           mov ax, word ptr [0x53d2]
  05BB65  1215: 3946f8           cmp word ptr [bp - 8], ax
  05BB68  1218: 750d             jne 0x1227
  05BB6A  121A: 8b1e9853         mov bx, word ptr [0x5398]
  05BB6E  121E: d1e3             shl bx, 1
  05BB70  1220: 8b878c83         mov ax, word ptr [bx - 0x7c74]
  05BB74  1224: 8946d4           mov word ptr [bp - 0x2c], ax
  05BB77  1227: ff76d4           push word ptr [bp - 0x2c]
  05BB7A  122A: 6a02             push 2
  05BB7C  122C: 9a38041f18       lcall 0x181f, 0x438
  05BB81  1231: 83c404           add sp, 4
  05BB84  1234: eb14             jmp 0x124a
  05BB86  1236: 6946e2ca00       imul ax, word ptr [bp - 0x1e], 0xca
  05BB8B  123B: 05485d           add ax, 0x5d48
  05BB8E  123E: 1e               push ds
  05BB8F  123F: 50               push ax
  05BB90  1240: 6a02             push 2
  05BB92  1242: 9a16041f18       lcall 0x181f, 0x416
  05BB97  1247: 83c406           add sp, 6
  05BB9A  124A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05BB9E  124E: 808f483180       or byte ptr [bx + 0x3148], 0x80
  05BBA3  1253: 2ac0             sub al, al
  05BBA5  1255: 88875a31         mov byte ptr [bx + 0x315a], al
  05BBA9  1259: 88875031         mov byte ptr [bx + 0x3150], al
  05BBAD  125D: 88874c31         mov byte ptr [bx + 0x314c], al
  05BBB1  1261: 6976f83c01       imul si, word ptr [bp - 8], 0x13c
  05BBB6  1266: 8a843a88         mov al, byte ptr [si - 0x77c6]
  05BBBA  126A: 88874d31         mov byte ptr [bx + 0x314d], al
  05BBBE  126E: 8a843b88         mov al, byte ptr [si - 0x77c5]
  05BBC2  1272: 88874e31         mov byte ptr [bx + 0x314e], al
  05BBC6  1276: 8b5efe           mov bx, word ptr [bp - 2]
  05BBC9  1279: 8bc3             mov ax, bx
  05BBCB  127B: d1e3             shl bx, 1
  05BBCD  127D: 03d8             add bx, ax
  05BBCF  127F: d1e3             shl bx, 1
  05BBD1  1281: 03d8             add bx, ax
  05BBD3  1283: d1e3             shl bx, 1
  05BBD5  1285: 8a873552         mov al, byte ptr [bx + 0x5235]
  05BBD9  1289: 2ae4             sub ah, ah
  05BBDB  128B: 8946fc           mov word ptr [bp - 4], ax
  05BBDE  128E: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  05BBE2  1292: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05BBE7  1297: 7207             jb 0x12a0
  05BBE9  1299: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05BBEE  129E: 7603             jbe 0x12a3
  05BBF0  12A0: d166fc           shl word ptr [bp - 4], 1
  05BBF3  12A3: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05BBF7  12A7: 8bc3             mov ax, bx
  05BBF9  12A9: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05BBFD  12AD: 2aff             sub bh, bh
  05BBFF  12AF: 8bcb             mov cx, bx
  05BC01  12B1: d1e3             shl bx, 1
  05BC03  12B3: 03d9             add bx, cx
  05BC05  12B5: d1e3             shl bx, 1
  05BC07  12B7: 03d9             add bx, cx
  05BC09  12B9: d1e3             shl bx, 1
  05BC0B  12BB: 8a8f3552         mov cl, byte ptr [bx + 0x5235]
  05BC0F  12BF: 8bd1             mov dx, cx
  05BC11  12C1: 2aed             sub ch, ch
  05BC13  12C3: 3b4efc           cmp cx, word ptr [bp - 4]
  05BC16  12C6: 7e09             jle 0x12d1
  05BC18  12C8: 8bd8             mov bx, ax
  05BC1A  12CA: 2a56fc           sub dl, byte ptr [bp - 4]
  05BC1D  12CD: 88975a31         mov byte ptr [bx + 0x315a], dl
  05BC21  12D1: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05BC25  12D5: 80bf463111       cmp byte ptr [bx + 0x3146], 0x11
  05BC2A  12DA: 7512             jne 0x12ee
  05BC2C  12DC: 8a875a31         mov al, byte ptr [bx + 0x315a]
  05BC30  12E0: 2c04             sub al, 4
  05BC32  12E2: 1ac9             sbb cl, cl
  05BC34  12E4: f6d1             not cl
  05BC36  12E6: 22c1             and al, cl
  05BC38  12E8: 0404             add al, 4
  05BC3A  12EA: 88875a31         mov byte ptr [bx + 0x315a], al
  05BC3E  12EE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05BC42  12F2: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05BC47  12F7: 7512             jne 0x130b
  05BC49  12F9: 8a875a31         mov al, byte ptr [bx + 0x315a]
  05BC4D  12FD: 2c08             sub al, 8
  05BC4F  12FF: 1ac9             sbb cl, cl
  05BC51  1301: f6d1             not cl
  05BC53  1303: 22c1             and al, cl
  05BC55  1305: 0408             add al, 8
  05BC57  1307: 88875a31         mov byte ptr [bx + 0x315a], al
  05BC5B  130B: 8b4606           mov ax, word ptr [bp + 6]
  05BC5E  130E: 9a12081f18       lcall 0x181f, 0x812
  05BC63  1313: 8b4606           mov ax, word ptr [bp + 6]
  05BC66  1316: 8b56da           mov dx, word ptr [bp - 0x26]
  05BC69  1319: 8b5ed6           mov bx, word ptr [bp - 0x2a]
  05BC6C  131C: 9a44081f18       lcall 0x181f, 0x844
  05BC71  1321: 837e0a00         cmp word ptr [bp + 0xa], 0
  05BC75  1325: 740d             je 0x1334
  05BC77  1327: 6a00             push 0
  05BC79  1329: 68761b           push 0x1b76
  05BC7C  132C: 9a52061f18       lcall 0x181f, 0x652
  05BC81  1331: 83c404           add sp, 4
  05BC84  1334: 837ec600         cmp word ptr [bp - 0x3a], 0
  05BC88  1338: 7403             je 0x133d
  05BC8A  133A: e99b01           jmp 0x14d8
  05BC8D  133D: 837ef600         cmp word ptr [bp - 0xa], 0
  05BC91  1341: 7503             jne 0x1346
  05BC93  1343: e98400           jmp 0x13ca
  05BC96  1346: ff76d0           push word ptr [bp - 0x30]
  05BC99  1349: 9aa4091f18       lcall 0x181f, 0x9a4
  05BC9E  134E: 83c402           add sp, 2
  05BCA1  1351: 50               push ax
  05BCA2  1352: 6a02             push 2
  05BCA4  1354: 9a38041f18       lcall 0x181f, 0x438
  05BCA9  1359: 83c404           add sp, 4
  05BCAC  135C: 8b5efe           mov bx, word ptr [bp - 2]
  05BCAF  135F: 8bc3             mov ax, bx
  05BCB1  1361: d1e3             shl bx, 1
  05BCB3  1363: 03d8             add bx, ax
  05BCB5  1365: d1e3             shl bx, 1
  05BCB7  1367: 03d8             add bx, ax
  05BCB9  1369: d1e3             shl bx, 1
  05BCBB  136B: ffb73052         push word ptr [bx + 0x5230]
  05BCBF  136F: 6a03             push 3
  05BCC1  1371: 9a38041f18       lcall 0x181f, 0x438
  05BCC6  1376: 83c404           add sp, 4
  05BCC9  1379: 837e0a00         cmp word ptr [bp + 0xa], 0
  05BCCD  137D: 744b             je 0x13ca
  05BCCF  137F: b85700           mov ax, 0x57
  05BCD2  1382: 9ac0041f18       lcall 0x181f, 0x4c0
  05BCD7  1387: 837ef804         cmp word ptr [bp - 8], 4
  05BCDB  138B: 7d15             jge 0x13a2
  05BCDD  138D: 6b5ef834         imul bx, word ptr [bp - 8], 0x34
  05BCE1  1391: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05BCE6  1396: 750a             jne 0x13a2
  05BCE8  1398: 6a01             push 1
  05BCEA  139A: 9ab6041f18       lcall 0x181f, 0x4b6
  05BCEF  139F: 83c402           add sp, 2
  05BCF2  13A2: 837ed004         cmp word ptr [bp - 0x30], 4
  05BCF6  13A6: 7d15             jge 0x13bd
  05BCF8  13A8: 6b5ed034         imul bx, word ptr [bp - 0x30], 0x34
  05BCFC  13AC: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05BD01  13B1: 750a             jne 0x13bd
  05BD03  13B3: 6a04             push 4
  05BD05  13B5: 9ab6041f18       lcall 0x181f, 0x4b6
  05BD0A  13BA: 83c402           add sp, 2
  05BD0D  13BD: 6a00             push 0
  05BD0F  13BF: 68811b           push 0x1b81
  05BD12  13C2: 9a52061f18       lcall 0x181f, 0x652
  05BD17  13C7: 83c404           add sp, 4
  05BD1A  13CA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05BD1E  13CE: f687483140       test byte ptr [bx + 0x3148], 0x40
  05BD23  13D3: 7503             jne 0x13d8
  05BD25  13D5: e9f000           jmp 0x14c8
  05BD28  13D8: c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  05BD2D  13DD: c746d20000       mov word ptr [bp - 0x2e], 0
  05BD32  13E2: eb27             jmp 0x140b
  05BD34  13E4: 837ed206         cmp word ptr [bp - 0x2e], 6
  05BD38  13E8: 7d27             jge 0x1411
  05BD3A  13EA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05BD3E  13EE: 8a874631         mov al, byte ptr [bx + 0x3146]
  05BD42  13F2: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  05BD45  13F5: 8bcb             mov cx, bx
  05BD47  13F7: d1e3             shl bx, 1
  05BD49  13F9: 03d9             add bx, cx
  05BD4B  13FB: d1e3             shl bx, 1
  05BD4D  13FD: 38878d97         cmp byte ptr [bx - 0x6873], al
  05BD51  1401: 7505             jne 0x1408
  05BD53  1403: 8bc1             mov ax, cx
  05BD55  1405: 8946f2           mov word ptr [bp - 0xe], ax
  05BD58  1408: ff46d2           inc word ptr [bp - 0x2e]
  05BD5B  140B: 837ef200         cmp word ptr [bp - 0xe], 0
  05BD5F  140F: 7cd3             jl 0x13e4
  05BD61  1411: 837ef200         cmp word ptr [bp - 0xe], 0
  05BD65  1415: 7f03             jg 0x141a
  05BD67  1417: e9ae00           jmp 0x14c8
  05BD6A  141A: 695ef83c01       imul bx, word ptr [bp - 8], 0x13c
  05BD6F  141F: 8a870988         mov al, byte ptr [bx - 0x77f7]
  05BD73  1423: 8b76d2           mov si, word ptr [bp - 0x2e]
  05BD76  1426: 8bce             mov cx, si
  05BD78  1428: d1e6             shl si, 1
  05BD7A  142A: 03f1             add si, cx
  05BD7C  142C: d1e6             shl si, 1
  05BD7E  142E: 3a848e97         cmp al, byte ptr [si - 0x6872]
  05BD82  1432: 7e04             jle 0x1438
  05BD84  1434: 8a848e97         mov al, byte ptr [si - 0x6872]
  05BD88  1438: 98               cwde 
  05BD89  1439: 8946ca           mov word ptr [bp - 0x36], ax
  05BD8C  143C: 0bc0             or ax, ax
  05BD8E  143E: 7f03             jg 0x1443
  05BD90  1440: e98500           jmp 0x14c8
  05BD93  1443: 28870988         sub byte ptr [bx - 0x77f7], al
  05BD97  1447: 837ef804         cmp word ptr [bp - 8], 4
  05BD9B  144B: 7d7b             jge 0x14c8
  05BD9D  144D: 6b76f834         imul si, word ptr [bp - 8], 0x34
  05BDA1  1451: 80bc3f5400       cmp byte ptr [si + 0x543f], 0
  05BDA6  1456: 7570             jne 0x14c8
  05BDA8  1458: 8bc3             mov ax, bx
  05BDAA  145A: 8a1ea653         mov bl, byte ptr [0x53a6]
  05BDAE  145E: 2aff             sub bh, bh
  05BDB0  1460: d1e3             shl bx, 1
  05BDB2  1462: ffb79483         push word ptr [bx - 0x7c6c]
  05BDB6  1466: 6a00             push 0
  05BDB8  1468: 8bf8             mov di, ax
  05BDBA  146A: 9a38041f18       lcall 0x181f, 0x438
  05BDBF  146F: 83c404           add sp, 4
  05BDC2  1472: 81c60e54         add si, 0x540e
  05BDC6  1476: 1e               push ds
  05BDC7  1477: 56               push si
  05BDC8  1478: 6a01             push 1
  05BDCA  147A: 9a16041f18       lcall 0x181f, 0x416
  05BDCF  147F: 83c406           add sp, 6
  05BDD2  1482: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05BDD6  1486: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05BDDA  148A: 2aff             sub bh, bh
  05BDDC  148C: 8bc3             mov ax, bx
  05BDDE  148E: d1e3             shl bx, 1
  05BDE0  1490: 03d8             add bx, ax
  05BDE2  1492: d1e3             shl bx, 1
  05BDE4  1494: 03d8             add bx, ax
  05BDE6  1496: d1e3             shl bx, 1
  05BDE8  1498: ffb73052         push word ptr [bx + 0x5230]
  05BDEC  149C: 6a02             push 2
  05BDEE  149E: 9a38041f18       lcall 0x181f, 0x438
  05BDF3  14A3: 83c404           add sp, 4
  05BDF6  14A6: 8b46ca           mov ax, word ptr [bp - 0x36]
  05BDF9  14A9: 99               cdq 
  05BDFA  14AA: 52               push dx
  05BDFB  14AB: 50               push ax
  05BDFC  14AC: 6a00             push 0
  05BDFE  14AE: 9aae091f18       lcall 0x181f, 0x9ae
  05BE03  14B3: 83c406           add sp, 6
  05BE06  14B6: 8a850988         mov al, byte ptr [di - 0x77f7]
  05BE0A  14BA: 98               cwde 
  05BE0B  14BB: 99               cdq 
  05BE0C  14BC: 52               push dx
  05BE0D  14BD: 50               push ax
  05BE0E  14BE: 6a01             push 1
  05BE10  14C0: 9aae091f18       lcall 0x181f, 0x9ae
  05BE15  14C5: 83c406           add sp, 6
  05BE18  14C8: ff7606           push word ptr [bp + 6]
  05BE1B  14CB: 9a08081f18       lcall 0x181f, 0x808
  05BE20  14D0: 83c402           add sp, 2
  05BE23  14D3: c746cc0100       mov word ptr [bp - 0x34], 1
  05BE28  14D8: 8b46cc           mov ax, word ptr [bp - 0x34]
  05BE2B  14DB: 5e               pop si
  05BE2C  14DC: 5f               pop di
  05BE2D  14DD: c9               leave 
  05BE2E  14DE: cb               retf 

; ---- func_05BE30  size=83  insns=31  prologue=ENTER 0x0002,0  terminal=RETF ----
  05BE30  14E0: c8020000         enter 2, 0
  05BE34  14E4: 8b4606           mov ax, word ptr [bp + 6]
  05BE37  14E7: 9aee021f18       lcall 0x181f, 0x2ee
  05BE3C  14EC: 8946fe           mov word ptr [bp - 2], ax
  05BE3F  14EF: eb39             jmp 0x152a
  05BE41  14F1: 90               nop 
  05BE42  14F2: 9ae4021f18       lcall 0x181f, 0x2e4
  05BE47  14F7: 8946fe           mov word ptr [bp - 2], ax
  05BE4A  14FA: ff760e           push word ptr [bp + 0xe]
  05BE4D  14FD: ff760c           push word ptr [bp + 0xc]
  05BE50  1500: ff760a           push word ptr [bp + 0xa]
  05BE53  1503: ff7608           push word ptr [bp + 8]
  05BE56  1506: ff7606           push word ptr [bp + 6]
  05BE59  1509: 0e               push cs
  05BE5A  150A: e8c628           call 0x3dd3
  05BE5D  150D: 83c40a           add sp, 0xa
  05BE60  1510: 0bc0             or ax, ax
  05BE62  1512: 7413             je 0x1527
  05BE64  1514: 8b4606           mov ax, word ptr [bp + 6]
  05BE67  1517: 3946fe           cmp word ptr [bp - 2], ax
  05BE6A  151A: 7e03             jle 0x151f
  05BE6C  151C: ff4efe           dec word ptr [bp - 2]
  05BE6F  151F: 394608           cmp word ptr [bp + 8], ax
  05BE72  1522: 7e03             jle 0x1527
  05BE74  1524: ff4e08           dec word ptr [bp + 8]
  05BE77  1527: 8b46fe           mov ax, word ptr [bp - 2]
  05BE7A  152A: 894606           mov word ptr [bp + 6], ax
  05BE7D  152D: 0bc0             or ax, ax
  05BE7F  152F: 7dc1             jge 0x14f2
  05BE81  1531: c9               leave 
  05BE82  1532: cb               retf 

; ---- func_05BE84  size=2006  insns=683  prologue=ENTER 0x0024,0  terminal=RETF ----
  05BE84  1534: c8240000         enter 0x24, 0
  05BE88  1538: 56               push si
  05BE89  1539: 8b4606           mov ax, word ptr [bp + 6]
  05BE8C  153C: 2d0400           sub ax, 4
  05BE8F  153F: 8946ec           mov word ptr [bp - 0x14], ax
  05BE92  1542: 50               push ax
  05BE93  1543: 9a420a1f18       lcall 0x181f, 0xa42
  05BE98  1548: 83c402           add sp, 2
  05BE9B  154B: ff7608           push word ptr [bp + 8]
  05BE9E  154E: 9ae6091f18       lcall 0x181f, 0x9e6
  05BEA3  1553: 83c402           add sp, 2
  05BEA6  1556: 8b1e4285         mov bx, word ptr [0x8542]
  05BEAA  155A: 8a471a           mov al, byte ptr [bx + 0x1a]
  05BEAD  155D: 2ae4             sub ah, ah
  05BEAF  155F: 8946de           mov word ptr [bp - 0x22], ax
  05BEB2  1562: ff7606           push word ptr [bp + 6]
  05BEB5  1565: 9a1a0a1f18       lcall 0x181f, 0xa1a
  05BEBA  156A: 83c402           add sp, 2
  05BEBD  156D: 50               push ax
  05BEBE  156E: 6a00             push 0
  05BEC0  1570: 9a38041f18       lcall 0x181f, 0x438
  05BEC5  1575: 83c404           add sp, 4
  05BEC8  1578: a14285           mov ax, word ptr [0x8542]
  05BECB  157B: 40               inc ax
  05BECC  157C: 40               inc ax
  05BECD  157D: 1e               push ds
  05BECE  157E: 50               push ax
  05BECF  157F: 6a01             push 1
  05BED1  1581: 9a16041f18       lcall 0x181f, 0x416
  05BED6  1586: 83c406           add sp, 6
  05BED9  1589: 6a00             push 0
  05BEDB  158B: 9ab00a1f18       lcall 0x181f, 0xab0
  05BEE0  1590: 83c402           add sp, 2
  05BEE3  1593: 8bc8             mov cx, ax
  05BEE5  1595: d1e0             shl ax, 1
  05BEE7  1597: 03c1             add ax, cx
  05BEE9  1599: 40               inc ax
  05BEEA  159A: 8946e6           mov word ptr [bp - 0x1a], ax
  05BEED  159D: ff36a683         push word ptr [0x83a6]
  05BEF1  15A1: 9aca041f18       lcall 0x181f, 0x4ca
  05BEF6  15A6: 83c402           add sp, 2
  05BEF9  15A9: 6a0c             push 0xc
  05BEFB  15AB: 6a00             push 0
  05BEFD  15AD: 9ad4041f18       lcall 0x181f, 0x4d4
  05BF02  15B2: 83c404           add sp, 4
  05BF05  15B5: 48               dec ax
  05BF06  15B6: 8946e8           mov word ptr [bp - 0x18], ax
  05BF09  15B9: 837ede04         cmp word ptr [bp - 0x22], 4
  05BF0D  15BD: 7d15             jge 0x15d4
  05BF0F  15BF: 6b5ede34         imul bx, word ptr [bp - 0x22], 0x34
  05BF13  15C3: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05BF18  15C8: 750a             jne 0x15d4
  05BF1A  15CA: a0a653           mov al, byte ptr [0x53a6]
  05BF1D  15CD: 2ae4             sub ah, ah
  05BF1F  15CF: 48               dec ax
  05BF20  15D0: 48               dec ax
  05BF21  15D1: 0146e8           add word ptr [bp - 0x18], ax
  05BF24  15D4: 8b46e6           mov ax, word ptr [bp - 0x1a]
  05BF27  15D7: 3946e8           cmp word ptr [bp - 0x18], ax
  05BF2A  15DA: 7d09             jge 0x15e5
  05BF2C  15DC: 837e0c00         cmp word ptr [bp + 0xc], 0
  05BF30  15E0: 7503             jne 0x15e5
  05BF32  15E2: e97502           jmp 0x185a
  05BF35  15E5: 6a04             push 4
  05BF37  15E7: 6a01             push 1
  05BF39  15E9: 9ad4041f18       lcall 0x181f, 0x4d4
  05BF3E  15EE: 83c404           add sp, 4
  05BF41  15F1: 8946fc           mov word ptr [bp - 4], ax
  05BF44  15F4: a0a653           mov al, byte ptr [0x53a6]
  05BF47  15F7: 2ae4             sub ah, ah
  05BF49  15F9: 48               dec ax
  05BF4A  15FA: 48               dec ax
  05BF4B  15FB: f7d8             neg ax
  05BF4D  15FD: 6bc028           imul ax, ax, 0x28
  05BF50  1600: 3b068e53         cmp ax, word ptr [0x538e]
  05BF54  1604: 7e18             jle 0x161e
  05BF56  1606: 803ea65301       cmp byte ptr [0x53a6], 1
  05BF5B  160B: 7711             ja 0x161e
  05BF5D  160D: 837efc02         cmp word ptr [bp - 4], 2
  05BF61  1611: 7406             je 0x1619
  05BF63  1613: 837efc03         cmp word ptr [bp - 4], 3
  05BF67  1617: 7505             jne 0x161e
  05BF69  1619: c746fc0000       mov word ptr [bp - 4], 0
  05BF6E  161E: 837efc02         cmp word ptr [bp - 4], 2
  05BF72  1622: 754e             jne 0x1672
  05BF74  1624: 837ede04         cmp word ptr [bp - 0x22], 4
  05BF78  1628: 7d16             jge 0x1640
  05BF7A  162A: 6b5ede34         imul bx, word ptr [bp - 0x22], 0x34
  05BF7E  162E: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05BF83  1633: 750b             jne 0x1640
  05BF85  1635: a0a653           mov al, byte ptr [0x53a6]
  05BF88  1638: 2ae4             sub ah, ah
  05BF8A  163A: 8946dc           mov word ptr [bp - 0x24], ax
  05BF8D  163D: eb06             jmp 0x1645
  05BF8F  163F: 90               nop 
  05BF90  1640: c746dc0100       mov word ptr [bp - 0x24], 1
  05BF95  1645: 6a08             push 8
  05BF97  1647: 6a00             push 0
  05BF99  1649: 9ad4041f18       lcall 0x181f, 0x4d4
  05BF9E  164E: 83c404           add sp, 4
  05BFA1  1651: 8b4edc           mov cx, word ptr [bp - 0x24]
  05BFA4  1654: 41               inc cx
  05BFA5  1655: 41               inc cx
  05BFA6  1656: 3bc1             cmp ax, cx
  05BFA8  1658: 7e05             jle 0x165f
  05BFAA  165A: c746fc0100       mov word ptr [bp - 4], 1
  05BFAF  165F: 6a01             push 1
  05BFB1  1661: 9afc091f18       lcall 0x181f, 0x9fc
  05BFB6  1666: 83c402           add sp, 2
  05BFB9  1669: 0bc0             or ax, ax
  05BFBB  166B: 7405             je 0x1672
  05BFBD  166D: c746fc0100       mov word ptr [bp - 4], 1
  05BFC2  1672: 837efc04         cmp word ptr [bp - 4], 4
  05BFC6  1676: 7513             jne 0x168b
  05BFC8  1678: 6a00             push 0
  05BFCA  167A: 9afc091f18       lcall 0x181f, 0x9fc
  05BFCF  167F: 83c402           add sp, 2
  05BFD2  1682: 0bc0             or ax, ax
  05BFD4  1684: 7405             je 0x168b
  05BFD6  1686: c746fc0100       mov word ptr [bp - 4], 1
  05BFDB  168B: 837efc03         cmp word ptr [bp - 4], 3
  05BFDF  168F: 7513             jne 0x16a4
  05BFE1  1691: 6a02             push 2
  05BFE3  1693: 9afc091f18       lcall 0x181f, 0x9fc
  05BFE8  1698: 83c402           add sp, 2
  05BFEB  169B: 0bc0             or ax, ax
  05BFED  169D: 7405             je 0x16a4
  05BFEF  169F: c746fc0000       mov word ptr [bp - 4], 0
  05BFF4  16A4: 837efc01         cmp word ptr [bp - 4], 1
  05BFF8  16A8: 7529             jne 0x16d3
  05BFFA  16AA: 6a00             push 0
  05BFFC  16AC: 9afc091f18       lcall 0x181f, 0x9fc
  05C001  16B1: 83c402           add sp, 2
  05C004  16B4: 0bc0             or ax, ax
  05C006  16B6: 741b             je 0x16d3
  05C008  16B8: 6a08             push 8
  05C00A  16BA: 6a00             push 0
  05C00C  16BC: 9ad4041f18       lcall 0x181f, 0x4d4
  05C011  16C1: 83c404           add sp, 4
  05C014  16C4: 8a0ea653         mov cl, byte ptr [0x53a6]
  05C018  16C8: 2aed             sub ch, ch
  05C01A  16CA: 3bc1             cmp ax, cx
  05C01C  16CC: 7e05             jle 0x16d3
  05C01E  16CE: c746fc0000       mov word ptr [bp - 4], 0
  05C023  16D3: 8b46fc           mov ax, word ptr [bp - 4]
  05C026  16D6: 48               dec ax
  05C027  16D7: 7415             je 0x16ee
  05C029  16D9: 48               dec ax
  05C02A  16DA: 7503             jne 0x16df
  05C02C  16DC: e99b00           jmp 0x177a
  05C02F  16DF: 48               dec ax
  05C030  16E0: 7503             jne 0x16e5
  05C032  16E2: e91d02           jmp 0x1902
  05C035  16E5: 48               dec ax
  05C036  16E6: 7503             jne 0x16eb
  05C038  16E8: e95f02           jmp 0x194a
  05C03B  16EB: e97101           jmp 0x185f
  05C03E  16EE: c746ea0000       mov word ptr [bp - 0x16], 0
  05C043  16F3: ff46ea           inc word ptr [bp - 0x16]
  05C046  16F6: 6a0f             push 0xf
  05C048  16F8: 6a00             push 0
  05C04A  16FA: 9ad4041f18       lcall 0x181f, 0x4d4
  05C04F  16FF: 83c404           add sp, 4
  05C052  1702: 8946e2           mov word ptr [bp - 0x1e], ax
  05C055  1705: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05C059  1709: 807f0800         cmp byte ptr [bx + 8], 0
  05C05D  170D: 752a             jne 0x1739
  05C05F  170F: 837eea01         cmp word ptr [bp - 0x16], 1
  05C063  1713: 7524             jne 0x1739
  05C065  1715: 8bf0             mov si, ax
  05C067  1717: d1e6             shl si, 1
  05C069  1719: 8b1e4285         mov bx, word ptr [0x8542]
  05C06D  171D: 83b89a0034       cmp word ptr [bx + si + 0x9a], 0x34
  05C072  1722: 7e15             jle 0x1739
  05C074  1724: 6a01             push 1
  05C076  1726: 6a00             push 0
  05C078  1728: 9ad4041f18       lcall 0x181f, 0x4d4
  05C07D  172D: 83c404           add sp, 4
  05C080  1730: 0bc0             or ax, ax
  05C082  1732: 7505             jne 0x1739
  05C084  1734: c746e20800       mov word ptr [bp - 0x1e], 8
  05C089  1739: 837ee20f         cmp word ptr [bp - 0x1e], 0xf
  05C08D  173D: 7519             jne 0x1758
  05C08F  173F: 68c800           push 0xc8
  05C092  1742: 6a00             push 0
  05C094  1744: 9ad4041f18       lcall 0x181f, 0x4d4
  05C099  1749: 83c404           add sp, 4
  05C09C  174C: 8bc8             mov cx, ax
  05C09E  174E: a0a653           mov al, byte ptr [0x53a6]
  05C0A1  1751: 2ae4             sub ah, ah
  05C0A3  1753: f76eea           imul word ptr [bp - 0x16]
  05C0A6  1756: 2bc8             sub cx, ax
  05C0A8  1758: 837eea64         cmp word ptr [bp - 0x16], 0x64
  05C0AC  175C: 7d10             jge 0x176e
  05C0AE  175E: 8b76e2           mov si, word ptr [bp - 0x1e]
  05C0B1  1761: d1e6             shl si, 1
  05C0B3  1763: 8b1e4285         mov bx, word ptr [0x8542]
  05C0B7  1767: 83b89a000a       cmp word ptr [bx + si + 0x9a], 0xa
  05C0BC  176C: 7c85             jl 0x16f3
  05C0BE  176E: 837eea64         cmp word ptr [bp - 0x16], 0x64
  05C0C2  1772: 7d03             jge 0x1777
  05C0C4  1774: e9e800           jmp 0x185f
  05C0C7  1777: e9e000           jmp 0x185a
  05C0CA  177A: c746ea0000       mov word ptr [bp - 0x16], 0
  05C0CF  177F: 6a00             push 0
  05C0D1  1781: 8b1e4285         mov bx, word ptr [0x8542]
  05C0D5  1785: 8a879400         mov al, byte ptr [bx + 0x94]
  05C0D9  1789: 98               cwde 
  05C0DA  178A: 50               push ax
  05C0DB  178B: 9ac20c1f18       lcall 0x181f, 0xcc2
  05C0E0  1790: 83c404           add sp, 4
  05C0E3  1793: 8946ee           mov word ptr [bp - 0x12], ax
  05C0E6  1796: c746fe0100       mov word ptr [bp - 2], 1
  05C0EB  179B: ff46ea           inc word ptr [bp - 0x16]
  05C0EE  179E: 6a29             push 0x29
  05C0F0  17A0: 6a00             push 0
  05C0F2  17A2: 9ad4041f18       lcall 0x181f, 0x4d4
  05C0F7  17A7: 83c404           add sp, 4
  05C0FA  17AA: 8946f8           mov word ptr [bp - 8], ax
  05C0FD  17AD: 3d2300           cmp ax, 0x23
  05C100  17B0: 7505             jne 0x17b7
  05C102  17B2: c746fe0000       mov word ptr [bp - 2], 0
  05C107  17B7: 50               push ax
  05C108  17B8: 9a880a1f18       lcall 0x181f, 0xa88
  05C10D  17BD: 83c402           add sp, 2
  05C110  17C0: 3d0900           cmp ax, 9
  05C113  17C3: 7505             jne 0x17ca
  05C115  17C5: c746fe0000       mov word ptr [bp - 2], 0
  05C11A  17CA: 837eee01         cmp word ptr [bp - 0x12], 1
  05C11E  17CE: 7528             jne 0x17f8
  05C120  17D0: 8b1e4285         mov bx, word ptr [0x8542]
  05C124  17D4: 8a879400         mov al, byte ptr [bx + 0x94]
  05C128  17D8: 98               cwde 
  05C129  17D9: 50               push ax
  05C12A  17DA: 9a880a1f18       lcall 0x181f, 0xa88
  05C12F  17DF: 83c402           add sp, 2
  05C132  17E2: ff76f8           push word ptr [bp - 8]
  05C135  17E5: 8bf0             mov si, ax
  05C137  17E7: 9a880a1f18       lcall 0x181f, 0xa88
  05C13C  17EC: 83c402           add sp, 2
  05C13F  17EF: 3bc6             cmp ax, si
  05C141  17F1: 7505             jne 0x17f8
  05C143  17F3: c746fe0000       mov word ptr [bp - 2], 0
  05C148  17F8: 837ef827         cmp word ptr [bp - 8], 0x27
  05C14C  17FC: 742a             je 0x1828
  05C14E  17FE: 837ef815         cmp word ptr [bp - 8], 0x15
  05C152  1802: 7424             je 0x1828
  05C154  1804: 837ef818         cmp word ptr [bp - 8], 0x18
  05C158  1808: 741e             je 0x1828
  05C15A  180A: 837ef81b         cmp word ptr [bp - 8], 0x1b
  05C15E  180E: 7418             je 0x1828
  05C160  1810: 837ef800         cmp word ptr [bp - 8], 0
  05C164  1814: 7412             je 0x1828
  05C166  1816: 837ef801         cmp word ptr [bp - 8], 1
  05C16A  181A: 740c             je 0x1828
  05C16C  181C: 837ef802         cmp word ptr [bp - 8], 2
  05C170  1820: 7406             je 0x1828
  05C172  1822: 837ef820         cmp word ptr [bp - 8], 0x20
  05C176  1826: 7505             jne 0x182d
  05C178  1828: c746fe0000       mov word ptr [bp - 2], 0
  05C17D  182D: 837eea64         cmp word ptr [bp - 0x16], 0x64
  05C181  1831: 7d1b             jge 0x184e
  05C183  1833: ff76f8           push word ptr [bp - 8]
  05C186  1836: 9afc091f18       lcall 0x181f, 0x9fc
  05C18B  183B: 83c402           add sp, 2
  05C18E  183E: 0bc0             or ax, ax
  05C190  1840: 7503             jne 0x1845
  05C192  1842: e951ff           jmp 0x1796
  05C195  1845: 837efe00         cmp word ptr [bp - 2], 0
  05C199  1849: 7503             jne 0x184e
  05C19B  184B: e948ff           jmp 0x1796
  05C19E  184E: 837eea64         cmp word ptr [bp - 0x16], 0x64
  05C1A2  1852: 7d06             jge 0x185a
  05C1A4  1854: 837efe00         cmp word ptr [bp - 2], 0
  05C1A8  1858: 756a             jne 0x18c4
  05C1AA  185A: c746fc0000       mov word ptr [bp - 4], 0
  05C1AF  185F: ff76de           push word ptr [bp - 0x22]
  05C1B2  1862: 9aa4091f18       lcall 0x181f, 0x9a4
  05C1B7  1867: 83c402           add sp, 2
  05C1BA  186A: 50               push ax
  05C1BB  186B: 6a03             push 3
  05C1BD  186D: 9a38041f18       lcall 0x181f, 0x438
  05C1C2  1872: 83c404           add sp, 4
  05C1C5  1875: 837ede04         cmp word ptr [bp - 0x22], 4
  05C1C9  1879: 7d0b             jge 0x1886
  05C1CB  187B: 6b5ede34         imul bx, word ptr [bp - 0x22], 0x34
  05C1CF  187F: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05C1D4  1884: 7413             je 0x1899
  05C1D6  1886: 837efc00         cmp word ptr [bp - 4], 0
  05C1DA  188A: 740d             je 0x1899
  05C1DC  188C: 6a03             push 3
  05C1DE  188E: 688a1b           push 0x1b8a
  05C1E1  1891: 9a52061f18       lcall 0x181f, 0x652
  05C1E6  1896: 83c404           add sp, 4
  05C1E9  1899: 837ede04         cmp word ptr [bp - 0x22], 4
  05C1ED  189D: 7c03             jl 0x18a2
  05C1EF  189F: e93a01           jmp 0x19dc
  05C1F2  18A2: 6b5ede34         imul bx, word ptr [bp - 0x22], 0x34
  05C1F6  18A6: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05C1FB  18AB: 7403             je 0x18b0
  05C1FD  18AD: e92c01           jmp 0x19dc
  05C200  18B0: 837efc00         cmp word ptr [bp - 4], 0
  05C204  18B4: 7403             je 0x18b9
  05C206  18B6: e91901           jmp 0x19d2
  05C209  18B9: 6a02             push 2
  05C20B  18BB: 9a98041f18       lcall 0x181f, 0x498
  05C210  18C0: e91601           jmp 0x19d9
  05C213  18C3: 90               nop 
  05C214  18C4: c746fe0100       mov word ptr [bp - 2], 1
  05C219  18C9: 8b5ef8           mov bx, word ptr [bp - 8]
  05C21C  18CC: 8bc3             mov ax, bx
  05C21E  18CE: d1e3             shl bx, 1
  05C220  18D0: 03d8             add bx, ax
  05C222  18D2: c1e302           shl bx, 2
  05C225  18D5: 8a87868f         mov al, byte ptr [bx - 0x707a]
  05C229  18D9: 98               cwde 
  05C22A  18DA: 8946fa           mov word ptr [bp - 6], ax
  05C22D  18DD: 0bc0             or ax, ax
  05C22F  18DF: 7c18             jl 0x18f9
  05C231  18E1: 50               push ax
  05C232  18E2: 9afc091f18       lcall 0x181f, 0x9fc
  05C237  18E7: 83c402           add sp, 2
  05C23A  18EA: 0bc0             or ax, ax
  05C23C  18EC: 740b             je 0x18f9
  05C23E  18EE: 8b46fa           mov ax, word ptr [bp - 6]
  05C241  18F1: 8946f8           mov word ptr [bp - 8], ax
  05C244  18F4: c746fe0000       mov word ptr [bp - 2], 0
  05C249  18F9: 837efe00         cmp word ptr [bp - 2], 0
  05C24D  18FD: 74c5             je 0x18c4
  05C24F  18FF: e95dff           jmp 0x185f
  05C252  1902: 8b1e4285         mov bx, word ptr [0x8542]
  05C256  1906: 8a07             mov al, byte ptr [bx]
  05C258  1908: 2ae4             sub ah, ah
  05C25A  190A: 8a5701           mov dl, byte ptr [bx + 1]
  05C25D  190D: 2af6             sub dh, dh
  05C25F  190F: 9ae0071f18       lcall 0x181f, 0x7e0
  05C264  1914: 8946e0           mov word ptr [bp - 0x20], ax
  05C267  1917: 50               push ax
  05C268  1918: 9a8a081f18       lcall 0x181f, 0x88a
  05C26D  191D: 83c402           add sp, 2
  05C270  1920: 0bc0             or ax, ax
  05C272  1922: 7503             jne 0x1927
  05C274  1924: e933ff           jmp 0x185a
  05C277  1927: 6b5ee01c         imul bx, word ptr [bp - 0x20], 0x1c
  05C27B  192B: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05C280  1930: 720a             jb 0x193c
  05C282  1932: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05C287  1937: 7703             ja 0x193c
  05C289  1939: e923ff           jmp 0x185f
  05C28C  193C: 8b46e0           mov ax, word ptr [bp - 0x20]
  05C28F  193F: 9ae4021f18       lcall 0x181f, 0x2e4
  05C294  1944: 8946e0           mov word ptr [bp - 0x20], ax
  05C297  1947: ebde             jmp 0x1927
  05C299  1949: 90               nop 
  05C29A  194A: 8b5ede           mov bx, word ptr [bp - 0x22]
  05C29D  194D: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  05C2A1  1951: 2ae4             sub ah, ah
  05C2A3  1953: 2bd2             sub dx, dx
  05C2A5  1955: 050100           add ax, 1
  05C2A8  1958: 13d2             adc dx, dx
  05C2AA  195A: 52               push dx
  05C2AB  195B: 50               push ax
  05C2AC  195C: 8b364285         mov si, word ptr [0x8542]
  05C2B0  1960: 8a441f           mov al, byte ptr [si + 0x1f]
  05C2B3  1963: 98               cwde 
  05C2B4  1964: 99               cdq 
  05C2B5  1965: 52               push dx
  05C2B6  1966: 50               push ax
  05C2B7  1967: 69db3c01         imul bx, bx, 0x13c
  05C2BB  196B: ffb73488         push word ptr [bx - 0x77cc]
  05C2BF  196F: ffb73288         push word ptr [bx - 0x77ce]
  05C2C3  1973: 8bf3             mov si, bx
  05C2C5  1975: 9a600f1d0d       lcall 0xd1d, 0xf60
  05C2CA  197A: 52               push dx
  05C2CB  197B: 50               push ax
  05C2CC  197C: 9ac60e1d0d       lcall 0xd1d, 0xec6
  05C2D1  1981: 050a00           add ax, 0xa
  05C2D4  1984: 83d200           adc dx, 0
  05C2D7  1987: 0bd2             or dx, dx
  05C2D9  1989: 7c0a             jl 0x1995
  05C2DB  198B: 7f05             jg 0x1992
  05C2DD  198D: 3dff7f           cmp ax, 0x7fff
  05C2E0  1990: 7603             jbe 0x1995
  05C2E2  1992: b8ff7f           mov ax, 0x7fff
  05C2E5  1995: 50               push ax
  05C2E6  1996: 6a32             push 0x32
  05C2E8  1998: 9ad4041f18       lcall 0x181f, 0x4d4
  05C2ED  199D: 83c404           add sp, 4
  05C2F0  19A0: 99               cdq 
  05C2F1  19A1: 8946f0           mov word ptr [bp - 0x10], ax
  05C2F4  19A4: 8956f2           mov word ptr [bp - 0xe], dx
  05C2F7  19A7: 39943488         cmp word ptr [si - 0x77cc], dx
  05C2FB  19AB: 7d03             jge 0x19b0
  05C2FD  19AD: e9aafe           jmp 0x185a
  05C300  19B0: 7f09             jg 0x19bb
  05C302  19B2: 39843288         cmp word ptr [si - 0x77ce], ax
  05C306  19B6: 7303             jae 0x19bb
  05C308  19B8: e99ffe           jmp 0x185a
  05C30B  19BB: 0bd2             or dx, dx
  05C30D  19BD: 7e03             jle 0x19c2
  05C30F  19BF: e99dfe           jmp 0x185f
  05C312  19C2: 7d03             jge 0x19c7
  05C314  19C4: e993fe           jmp 0x185a
  05C317  19C7: 3d3200           cmp ax, 0x32
  05C31A  19CA: 7203             jb 0x19cf
  05C31C  19CC: e990fe           jmp 0x185f
  05C31F  19CF: e988fe           jmp 0x185a
  05C322  19D2: 6a32             push 0x32
  05C324  19D4: 9a8e041f18       lcall 0x181f, 0x48e
  05C329  19D9: 83c402           add sp, 2
  05C32C  19DC: 8b46fc           mov ax, word ptr [bp - 4]
  05C32F  19DF: 48               dec ax
  05C330  19E0: 7416             je 0x19f8
  05C332  19E2: 48               dec ax
  05C333  19E3: 7503             jne 0x19e8
  05C335  19E5: e9f200           jmp 0x1ada
  05C338  19E8: 48               dec ax
  05C339  19E9: 7503             jne 0x19ee
  05C33B  19EB: e9f601           jmp 0x1be4
  05C33E  19EE: 48               dec ax
  05C33F  19EF: 7503             jne 0x19f4
  05C341  19F1: e97e02           jmp 0x1c72
  05C344  19F4: e9d502           jmp 0x1ccc
  05C347  19F7: 90               nop 
  05C348  19F8: 8b76e2           mov si, word ptr [bp - 0x1e]
  05C34B  19FB: d1e6             shl si, 1
  05C34D  19FD: 8b1e4285         mov bx, word ptr [0x8542]
  05C351  1A01: 83b89a0000       cmp word ptr [bx + si + 0x9a], 0
  05C356  1A06: 7503             jne 0x1a0b
  05C358  1A08: e9e702           jmp 0x1cf2
  05C35B  1A0B: 8b5ee2           mov bx, word ptr [bp - 0x1e]
  05C35E  1A0E: d1e3             shl bx, 1
  05C360  1A10: ffb7c097         push word ptr [bx - 0x6840]
  05C364  1A14: 6a02             push 2
  05C366  1A16: 8bf3             mov si, bx
  05C368  1A18: 9a38041f18       lcall 0x181f, 0x438
  05C36D  1A1D: 83c404           add sp, 4
  05C370  1A20: 8b1e4285         mov bx, word ptr [0x8542]
  05C374  1A24: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  05C378  1A28: d1f8             sar ax, 1
  05C37A  1A2A: 50               push ax
  05C37B  1A2B: 3d0a00           cmp ax, 0xa
  05C37E  1A2E: 7e03             jle 0x1a33
  05C380  1A30: b80a00           mov ax, 0xa
  05C383  1A33: 50               push ax
  05C384  1A34: 9ad4041f18       lcall 0x181f, 0x4d4
  05C389  1A39: 83c404           add sp, 4
  05C38C  1A3C: 8946f6           mov word ptr [bp - 0xa], ax
  05C38F  1A3F: 8b1e4285         mov bx, word ptr [0x8542]
  05C393  1A43: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  05C397  1A47: 3b46f6           cmp ax, word ptr [bp - 0xa]
  05C39A  1A4A: 7e03             jle 0x1a4f
  05C39C  1A4C: 8b46f6           mov ax, word ptr [bp - 0xa]
  05C39F  1A4F: 8946f6           mov word ptr [bp - 0xa], ax
  05C3A2  1A52: 3d0100           cmp ax, 1
  05C3A5  1A55: 7d03             jge 0x1a5a
  05C3A7  1A57: b80100           mov ax, 1
  05C3AA  1A5A: 8946f6           mov word ptr [bp - 0xa], ax
  05C3AD  1A5D: 29809a00         sub word ptr [bx + si + 0x9a], ax
  05C3B1  1A61: 837ede04         cmp word ptr [bp - 0x22], 4
  05C3B5  1A65: 7d20             jge 0x1a87
  05C3B7  1A67: 6b5ede34         imul bx, word ptr [bp - 0x22], 0x34
  05C3BB  1A6B: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05C3C0  1A70: 7515             jne 0x1a87
  05C3C2  1A72: b84f00           mov ax, 0x4f
  05C3C5  1A75: 9ac0041f18       lcall 0x181f, 0x4c0
  05C3CA  1A7A: 6a05             push 5
  05C3CC  1A7C: 68941b           push 0x1b94
  05C3CF  1A7F: 9a52061f18       lcall 0x181f, 0x652
  05C3D4  1A84: 83c404           add sp, 4
  05C3D7  1A87: 837ee208         cmp word ptr [bp - 0x1e], 8
  05C3DB  1A8B: 750b             jne 0x1a98
  05C3DD  1A8D: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05C3E1  1A91: fe4708           inc byte ptr [bx + 8]
  05C3E4  1A94: 83470a19         add word ptr [bx + 0xa], 0x19
  05C3E8  1A98: 837ee20f         cmp word ptr [bp - 0x1e], 0xf
  05C3EC  1A9C: 7510             jne 0x1aae
  05C3EE  1A9E: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05C3F2  1AA2: fe4707           inc byte ptr [bx + 7]
  05C3F5  1AA5: 837ef632         cmp word ptr [bp - 0xa], 0x32
  05C3F9  1AA9: 7c03             jl 0x1aae
  05C3FB  1AAB: fe4707           inc byte ptr [bx + 7]
  05C3FE  1AAE: ff76de           push word ptr [bp - 0x22]
  05C401  1AB1: ff36508d         push word ptr [0x8d50]
  05C405  1AB5: 9a380a1f18       lcall 0x181f, 0xa38
  05C40A  1ABA: 83c404           add sp, 4
  05C40D  1ABD: a802             test al, 2
  05C40F  1ABF: 7403             je 0x1ac4
  05C411  1AC1: e92e02           jmp 0x1cf2
  05C414  1AC4: 6a00             push 0
  05C416  1AC6: 6afc             push -4
  05C418  1AC8: ff76de           push word ptr [bp - 0x22]
  05C41B  1ACB: ff76ec           push word ptr [bp - 0x14]
  05C41E  1ACE: 9a6c0d1f18       lcall 0x181f, 0xd6c
  05C423  1AD3: 83c408           add sp, 8
  05C426  1AD6: e91902           jmp 0x1cf2
  05C429  1AD9: 90               nop 
  05C42A  1ADA: 8b5ef8           mov bx, word ptr [bp - 8]
  05C42D  1ADD: 8bc3             mov ax, bx
  05C42F  1ADF: d1e3             shl bx, 1
  05C431  1AE1: 03d8             add bx, ax
  05C433  1AE3: c1e302           shl bx, 2
  05C436  1AE6: ffb7828f         push word ptr [bx - 0x707e]
  05C43A  1AEA: 6a02             push 2
  05C43C  1AEC: 9a38041f18       lcall 0x181f, 0x438
  05C441  1AF1: 83c404           add sp, 4
  05C444  1AF4: 837ef80f         cmp word ptr [bp - 8], 0xf
  05C448  1AF8: 7520             jne 0x1b1a
  05C44A  1AFA: 8b1e4285         mov bx, word ptr [0x8542]
  05C44E  1AFE: fe8f9500         dec byte ptr [bx + 0x95]
  05C452  1B02: 7508             jne 0x1b0c
  05C454  1B04: 6a00             push 0
  05C456  1B06: 6a0f             push 0xf
  05C458  1B08: e98d00           jmp 0x1b98
  05C45B  1B0B: 90               nop 
  05C45C  1B0C: ff364290         push word ptr [0x9042]
  05C460  1B10: 6a02             push 2
  05C462  1B12: 9a38041f18       lcall 0x181f, 0x438
  05C467  1B17: e98300           jmp 0x1b9d
  05C46A  1B1A: 837ef81e         cmp word ptr [bp - 8], 0x1e
  05C46E  1B1E: 751c             jne 0x1b3c
  05C470  1B20: 8b1e4285         mov bx, word ptr [0x8542]
  05C474  1B24: fe8f9600         dec byte ptr [bx + 0x96]
  05C478  1B28: 750c             jne 0x1b36
  05C47A  1B2A: 6a00             push 0
  05C47C  1B2C: 6a1e             push 0x1e
  05C47E  1B2E: 9abe0b1f18       lcall 0x181f, 0xbbe
  05C483  1B33: 83c404           add sp, 4
  05C486  1B36: ff36f690         push word ptr [0x90f6]
  05C48A  1B3A: ebd4             jmp 0x1b10
  05C48C  1B3C: 8b5ef8           mov bx, word ptr [bp - 8]
  05C48F  1B3F: 8bc3             mov ax, bx
  05C491  1B41: d1e3             shl bx, 1
  05C493  1B43: 03d8             add bx, ax
  05C495  1B45: c1e302           shl bx, 2
  05C498  1B48: 80bf858f00       cmp byte ptr [bx - 0x707b], 0
  05C49D  1B4D: 7d44             jge 0x1b93
  05C49F  1B4F: 50               push ax
  05C4A0  1B50: 9ace0a1f18       lcall 0x181f, 0xace
  05C4A5  1B55: 83c402           add sp, 2
  05C4A8  1B58: 8946e4           mov word ptr [bp - 0x1c], ax
  05C4AB  1B5B: 0bc0             or ax, ax
  05C4AD  1B5D: 7c34             jl 0x1b93
  05C4AF  1B5F: c746f40000       mov word ptr [bp - 0xc], 0
  05C4B4  1B64: eb20             jmp 0x1b86
  05C4B6  1B66: ff76f4           push word ptr [bp - 0xc]
  05C4B9  1B69: 9a0e0c1f18       lcall 0x181f, 0xc0e
  05C4BE  1B6E: 83c402           add sp, 2
  05C4C1  1B71: 3b46e4           cmp ax, word ptr [bp - 0x1c]
  05C4C4  1B74: 750d             jne 0x1b83
  05C4C6  1B76: 6a0d             push 0xd
  05C4C8  1B78: ff76f4           push word ptr [bp - 0xc]
  05C4CB  1B7B: 9a360c1f18       lcall 0x181f, 0xc36
  05C4D0  1B80: 83c404           add sp, 4
  05C4D3  1B83: ff46f4           inc word ptr [bp - 0xc]
  05C4D6  1B86: 8b1e4285         mov bx, word ptr [0x8542]
  05C4DA  1B8A: 8a471f           mov al, byte ptr [bx + 0x1f]
  05C4DD  1B8D: 98               cwde 
  05C4DE  1B8E: 3b46f4           cmp ax, word ptr [bp - 0xc]
  05C4E1  1B91: 7fd3             jg 0x1b66
  05C4E3  1B93: 6a00             push 0
  05C4E5  1B95: ff76f8           push word ptr [bp - 8]
  05C4E8  1B98: 9abe0b1f18       lcall 0x181f, 0xbbe
  05C4ED  1B9D: 83c404           add sp, 4
  05C4F0  1BA0: 837ede04         cmp word ptr [bp - 0x22], 4
  05C4F4  1BA4: 7d20             jge 0x1bc6
  05C4F6  1BA6: 6b5ede34         imul bx, word ptr [bp - 0x22], 0x34
  05C4FA  1BAA: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05C4FF  1BAF: 7515             jne 0x1bc6
  05C501  1BB1: b85300           mov ax, 0x53
  05C504  1BB4: 9ac0041f18       lcall 0x181f, 0x4c0
  05C509  1BB9: 6a05             push 5
  05C50B  1BBB: 689f1b           push 0x1b9f
  05C50E  1BBE: 9a52061f18       lcall 0x181f, 0x652
  05C513  1BC3: 83c404           add sp, 4
  05C516  1BC6: ff76de           push word ptr [bp - 0x22]
  05C519  1BC9: ff36508d         push word ptr [0x8d50]
  05C51D  1BCD: 9a380a1f18       lcall 0x181f, 0xa38
  05C522  1BD2: 83c404           add sp, 4
  05C525  1BD5: a802             test al, 2
  05C527  1BD7: 7403             je 0x1bdc
  05C529  1BD9: e91601           jmp 0x1cf2
  05C52C  1BDC: 6a00             push 0
  05C52E  1BDE: 6af4             push -0xc
  05C530  1BE0: e9e5fe           jmp 0x1ac8
  05C533  1BE3: 90               nop 
  05C534  1BE4: 6b5ee01c         imul bx, word ptr [bp - 0x20], 0x1c
  05C538  1BE8: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05C53C  1BEC: 2aff             sub bh, bh
  05C53E  1BEE: 8bc3             mov ax, bx
  05C540  1BF0: d1e3             shl bx, 1
  05C542  1BF2: 03d8             add bx, ax
  05C544  1BF4: d1e3             shl bx, 1
  05C546  1BF6: 03d8             add bx, ax
  05C548  1BF8: d1e3             shl bx, 1
  05C54A  1BFA: ffb73052         push word ptr [bx + 0x5230]
  05C54E  1BFE: 6a02             push 2
  05C550  1C00: 9a38041f18       lcall 0x181f, 0x438
  05C555  1C05: 83c404           add sp, 4
  05C558  1C08: 837ede04         cmp word ptr [bp - 0x22], 4
  05C55C  1C0C: 7d28             jge 0x1c36
  05C55E  1C0E: 6b5ede34         imul bx, word ptr [bp - 0x22], 0x34
  05C562  1C12: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05C567  1C17: 751d             jne 0x1c36
  05C569  1C19: b84b00           mov ax, 0x4b
  05C56C  1C1C: 9ac0041f18       lcall 0x181f, 0x4c0
  05C571  1C21: b84d00           mov ax, 0x4d
  05C574  1C24: 9ac0041f18       lcall 0x181f, 0x4c0
  05C579  1C29: 6a05             push 5
  05C57B  1C2B: 68a81b           push 0x1ba8
  05C57E  1C2E: 9a52061f18       lcall 0x181f, 0x652
  05C583  1C33: 83c404           add sp, 4
  05C586  1C36: 6b5ee01c         imul bx, word ptr [bp - 0x20], 0x1c
  05C58A  1C3A: 8a874531         mov al, byte ptr [bx + 0x3145]
  05C58E  1C3E: 2ae4             sub ah, ah
  05C590  1C40: 50               push ax
  05C591  1C41: 8a874431         mov al, byte ptr [bx + 0x3144]
  05C595  1C45: 50               push ax
  05C596  1C46: 6a01             push 1
  05C598  1C48: 6aff             push -1
  05C59A  1C4A: ff76e0           push word ptr [bp - 0x20]
  05C59D  1C4D: 0e               push cs
  05C59E  1C4E: e88221           call 0x3dd3
  05C5A1  1C51: 83c40a           add sp, 0xa
  05C5A4  1C54: ff76de           push word ptr [bp - 0x22]
  05C5A7  1C57: ff36508d         push word ptr [0x8d50]
  05C5AB  1C5B: 9a380a1f18       lcall 0x181f, 0xa38
  05C5B0  1C60: 83c404           add sp, 4
  05C5B3  1C63: a802             test al, 2
  05C5B5  1C65: 7403             je 0x1c6a
  05C5B7  1C67: e98800           jmp 0x1cf2
  05C5BA  1C6A: 6a00             push 0
  05C5BC  1C6C: 6af0             push -0x10
  05C5BE  1C6E: e957fe           jmp 0x1ac8
  05C5C1  1C71: 90               nop 
  05C5C2  1C72: 8b46f0           mov ax, word ptr [bp - 0x10]
  05C5C5  1C75: 8b56f2           mov dx, word ptr [bp - 0xe]
  05C5C8  1C78: a3b09c           mov word ptr [0x9cb0], ax
  05C5CB  1C7B: 8916b29c         mov word ptr [0x9cb2], dx
  05C5CF  1C7F: 695ede3c01       imul bx, word ptr [bp - 0x22], 0x13c
  05C5D4  1C84: 29873288         sub word ptr [bx - 0x77ce], ax
  05C5D8  1C88: 19973488         sbb word ptr [bx - 0x77cc], dx
  05C5DC  1C8C: 837ede04         cmp word ptr [bp - 0x22], 4
  05C5E0  1C90: 7d20             jge 0x1cb2
  05C5E2  1C92: 6b5ede34         imul bx, word ptr [bp - 0x22], 0x34
  05C5E6  1C96: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05C5EB  1C9B: 7515             jne 0x1cb2
  05C5ED  1C9D: b84e00           mov ax, 0x4e
  05C5F0  1CA0: 9ac0041f18       lcall 0x181f, 0x4c0
  05C5F5  1CA5: 6a05             push 5
  05C5F7  1CA7: 68b11b           push 0x1bb1
  05C5FA  1CAA: 9a52061f18       lcall 0x181f, 0x652
  05C5FF  1CAF: 83c404           add sp, 4
  05C602  1CB2: ff76de           push word ptr [bp - 0x22]
  05C605  1CB5: ff36508d         push word ptr [0x8d50]
  05C609  1CB9: 9a380a1f18       lcall 0x181f, 0xa38
  05C60E  1CBE: 83c404           add sp, 4
  05C611  1CC1: a802             test al, 2
  05C613  1CC3: 752d             jne 0x1cf2
  05C615  1CC5: 6a00             push 0
  05C617  1CC7: 6af8             push -8
  05C619  1CC9: e9fcfd           jmp 0x1ac8
  05C61C  1CCC: 837ede04         cmp word ptr [bp - 0x22], 4
  05C620  1CD0: 7d20             jge 0x1cf2
  05C622  1CD2: 6b5ede34         imul bx, word ptr [bp - 0x22], 0x34
  05C626  1CD6: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05C62B  1CDB: 7515             jne 0x1cf2
  05C62D  1CDD: b85b00           mov ax, 0x5b
  05C630  1CE0: 9ac0041f18       lcall 0x181f, 0x4c0
  05C635  1CE5: 6a05             push 5
  05C637  1CE7: 68ba1b           push 0x1bba
  05C63A  1CEA: 9a52061f18       lcall 0x181f, 0x652
  05C63F  1CEF: 83c404           add sp, 4
  05C642  1CF2: 8b5e0a           mov bx, word ptr [bp + 0xa]
  05C645  1CF5: 8bc3             mov ax, bx
  05C647  1CF7: c1e303           shl bx, 3
  05C64A  1CFA: 03d8             add bx, ax
  05C64C  1CFC: 035ede           add bx, word ptr [bp - 0x22]
  05C64F  1CFF: d1e3             shl bx, 1
  05C651  1D01: c787f6540000     mov word ptr [bx + 0x54f6], 0
  05C657  1D07: 5e               pop si
  05C658  1D08: c9               leave 
  05C659  1D09: cb               retf 

; ---- func_05C65A  size=65  insns=19  prologue=ENTER 0x0002,0  terminal=RETF ----
  05C65A  1D0A: c8020000         enter 2, 0
  05C65E  1D0E: c746fe1500       mov word ptr [bp - 2], 0x15
  05C663  1D13: f606825301       test byte ptr [0x5382], 1
  05C668  1D18: 740b             je 0x1d25
  05C66A  1D1A: 837e0615         cmp word ptr [bp + 6], 0x15
  05C66E  1D1E: 7505             jne 0x1d25
  05C670  1D20: c746feffff       mov word ptr [bp - 2], 0xffff
  05C675  1D25: 837e061a         cmp word ptr [bp + 6], 0x1a
  05C679  1D29: 7505             jne 0x1d30
  05C67B  1D2B: c746fe1900       mov word ptr [bp - 2], 0x19
  05C680  1D30: 837e0619         cmp word ptr [bp + 6], 0x19
  05C684  1D34: 7505             jne 0x1d3b
  05C686  1D36: c746fe1c00       mov word ptr [bp - 2], 0x1c
  05C68B  1D3B: 837e061b         cmp word ptr [bp + 6], 0x1b
  05C68F  1D3F: 7505             jne 0x1d46
  05C691  1D41: c746fe1b00       mov word ptr [bp - 2], 0x1b
  05C696  1D46: 8b46fe           mov ax, word ptr [bp - 2]
  05C699  1D49: c9               leave 
  05C69A  1D4A: cb               retf 

; ---- func_05C69C  size=475  insns=168  prologue=ENTER 0x0006,0  terminal=RETF ----
  05C69C  1D4C: c8060000         enter 6, 0
  05C6A0  1D50: 56               push si
  05C6A1  1D51: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C6A5  1D55: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  05C6AA  1D5A: 740a             je 0x1d66
  05C6AC  1D5C: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  05C6B1  1D61: 7403             je 0x1d66
  05C6B3  1D63: e9bd01           jmp 0x1f23
  05C6B6  1D66: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C6BA  1D6A: 80bf5b3115       cmp byte ptr [bx + 0x315b], 0x15
  05C6BF  1D6F: 751b             jne 0x1d8c
  05C6C1  1D71: f606825301       test byte ptr [0x5382], 1
  05C6C6  1D76: 7503             jne 0x1d7b
  05C6C8  1D78: e9a801           jmp 0x1f23
  05C6CB  1D7B: 691e98533c01     imul bx, word ptr [0x5398], 0x13c
  05C6D1  1D81: f687088808       test byte ptr [bx - 0x77f8], 8
  05C6D6  1D86: 751d             jne 0x1da5
  05C6D8  1D88: 5e               pop si
  05C6D9  1D89: c9               leave 
  05C6DA  1D8A: cb               retf 
  05C6DB  1D8B: 90               nop 
  05C6DC  1D8C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C6E0  1D90: 8a875b31         mov al, byte ptr [bx + 0x315b]
  05C6E4  1D94: 98               cwde 
  05C6E5  1D95: 50               push ax
  05C6E6  1D96: 9a9a0c1f18       lcall 0x181f, 0xc9a
  05C6EB  1D9B: 83c402           add sp, 2
  05C6EE  1D9E: 0bc0             or ax, ax
  05C6F0  1DA0: 7403             je 0x1da5
  05C6F2  1DA2: e97e01           jmp 0x1f23
  05C6F5  1DA5: 8b460a           mov ax, word ptr [bp + 0xa]
  05C6F8  1DA8: 034608           add ax, word ptr [bp + 8]
  05C6FB  1DAB: 8946fc           mov word ptr [bp - 4], ax
  05C6FE  1DAE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C702  1DB2: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  05C706  1DB6: 80e10f           and cl, 0xf
  05C709  1DB9: 80f904           cmp cl, 4
  05C70C  1DBC: 7316             jae 0x1dd4
  05C70E  1DBE: 2aed             sub ch, ch
  05C710  1DC0: 6bd934           imul bx, cx, 0x34
  05C713  1DC3: 38af3f54         cmp byte ptr [bx + 0x543f], ch
  05C717  1DC7: 750b             jne 0x1dd4
  05C719  1DC9: 8a0ea653         mov cl, byte ptr [0x53a6]
  05C71D  1DCD: 03c1             add ax, cx
  05C71F  1DCF: 8946fc           mov word ptr [bp - 4], ax
  05C722  1DD2: eb08             jmp 0x1ddc
  05C724  1DD4: a0a653           mov al, byte ptr [0x53a6]
  05C727  1DD7: 2ae4             sub ah, ah
  05C729  1DD9: 2946fc           sub word ptr [bp - 4], ax
  05C72C  1DDC: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C730  1DE0: 8a875b31         mov al, byte ptr [bx + 0x315b]
  05C734  1DE4: 98               cwde 
  05C735  1DE5: 8946fa           mov word ptr [bp - 6], ax
  05C738  1DE8: 3d1a00           cmp ax, 0x1a
  05C73B  1DEB: 7504             jne 0x1df1
  05C73D  1DED: 836efc0a         sub word ptr [bp - 4], 0xa
  05C741  1DF1: 3d1900           cmp ax, 0x19
  05C744  1DF4: 7504             jne 0x1dfa
  05C746  1DF6: 836efc05         sub word ptr [bp - 4], 5
  05C74A  1DFA: 6a0b             push 0xb
  05C74C  1DFC: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C750  1E00: 8a874731         mov al, byte ptr [bx + 0x3147]
  05C754  1E04: 250f00           and ax, 0xf
  05C757  1E07: 50               push ax
  05C758  1E08: 9ab4071f18       lcall 0x181f, 0x7b4
  05C75D  1E0D: 83c404           add sp, 4
  05C760  1E10: 0bc0             or ax, ax
  05C762  1E12: 7515             jne 0x1e29
  05C764  1E14: ff76fc           push word ptr [bp - 4]
  05C767  1E17: 6a01             push 1
  05C769  1E19: 9ad4041f18       lcall 0x181f, 0x4d4
  05C76E  1E1E: 83c404           add sp, 4
  05C771  1E21: 3b460a           cmp ax, word ptr [bp + 0xa]
  05C774  1E24: 7e03             jle 0x1e29
  05C776  1E26: e9fa00           jmp 0x1f23
  05C779  1E29: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C77D  1E2D: 8a875b31         mov al, byte ptr [bx + 0x315b]
  05C781  1E31: 98               cwde 
  05C782  1E32: 50               push ax
  05C783  1E33: 0e               push cs
  05C784  1E34: e88d1f           call 0x3dc4
  05C787  1E37: 83c402           add sp, 2
  05C78A  1E3A: 8946fe           mov word ptr [bp - 2], ax
  05C78D  1E3D: 3b46fa           cmp ax, word ptr [bp - 6]
  05C790  1E40: 7503             jne 0x1e45
  05C792  1E42: e9de00           jmp 0x1f23
  05C795  1E45: 0bc0             or ax, ax
  05C797  1E47: 7d3d             jge 0x1e86
  05C799  1E49: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C79D  1E4D: 8a874731         mov al, byte ptr [bx + 0x3147]
  05C7A1  1E51: 240f             and al, 0xf
  05C7A3  1E53: 3c04             cmp al, 4
  05C7A5  1E55: 7203             jb 0x1e5a
  05C7A7  1E57: e9c900           jmp 0x1f23
  05C7AA  1E5A: 2ae4             sub ah, ah
  05C7AC  1E5C: 6bd834           imul bx, ax, 0x34
  05C7AF  1E5F: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  05C7B3  1E63: 7403             je 0x1e68
  05C7B5  1E65: e9bb00           jmp 0x1f23
  05C7B8  1E68: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C7BC  1E6C: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  05C7C1  1E71: 7507             jne 0x1e7a
  05C7C3  1E73: c687463109       mov byte ptr [bx + 0x3146], 9
  05C7C8  1E78: eb17             jmp 0x1e91
  05C7CA  1E7A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C7CE  1E7E: c687463107       mov byte ptr [bx + 0x3146], 7
  05C7D3  1E83: eb0c             jmp 0x1e91
  05C7D5  1E85: 90               nop 
  05C7D6  1E86: 8a46fe           mov al, byte ptr [bp - 2]
  05C7D9  1E89: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C7DD  1E8D: 88875b31         mov byte ptr [bx + 0x315b], al
  05C7E1  1E91: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C7E5  1E95: 8a874731         mov al, byte ptr [bx + 0x3147]
  05C7E9  1E99: 240f             and al, 0xf
  05C7EB  1E9B: 3c04             cmp al, 4
  05C7ED  1E9D: 7203             jb 0x1ea2
  05C7EF  1E9F: e98100           jmp 0x1f23
  05C7F2  1EA2: 2ae4             sub ah, ah
  05C7F4  1EA4: 6bf034           imul si, ax, 0x34
  05C7F7  1EA7: 38a43f54         cmp byte ptr [si + 0x543f], ah
  05C7FB  1EAB: 7576             jne 0x1f23
  05C7FD  1EAD: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05C801  1EB1: 2aff             sub bh, bh
  05C803  1EB3: 8bc3             mov ax, bx
  05C805  1EB5: d1e3             shl bx, 1
  05C807  1EB7: 03d8             add bx, ax
  05C809  1EB9: d1e3             shl bx, 1
  05C80B  1EBB: 03d8             add bx, ax
  05C80D  1EBD: d1e3             shl bx, 1
  05C80F  1EBF: ffb73052         push word ptr [bx + 0x5230]
  05C813  1EC3: 6a00             push 0
  05C815  1EC5: 9a38041f18       lcall 0x181f, 0x438
  05C81A  1ECA: 83c404           add sp, 4
  05C81D  1ECD: 837efe00         cmp word ptr [bp - 2], 0
  05C821  1ED1: 7d09             jge 0x1edc
  05C823  1ED3: 6a01             push 1
  05C825  1ED5: 68c61b           push 0x1bc6
  05C828  1ED8: eb41             jmp 0x1f1b
  05C82A  1EDA: 90               nop 
  05C82B  1EDB: 90               nop 
  05C82C  1EDC: 837efe15         cmp word ptr [bp - 2], 0x15
  05C830  1EE0: 7508             jne 0x1eea
  05C832  1EE2: 6a01             push 1
  05C834  1EE4: 68d21b           push 0x1bd2
  05C837  1EE7: eb32             jmp 0x1f1b
  05C839  1EE9: 90               nop 
  05C83A  1EEA: ff76fa           push word ptr [bp - 6]
  05C83D  1EED: 9a400c1f18       lcall 0x181f, 0xc40
  05C842  1EF2: 83c402           add sp, 2
  05C845  1EF5: 50               push ax
  05C846  1EF6: 6a01             push 1
  05C848  1EF8: 9a38041f18       lcall 0x181f, 0x438
  05C84D  1EFD: 83c404           add sp, 4
  05C850  1F00: ff76fe           push word ptr [bp - 2]
  05C853  1F03: 9a400c1f18       lcall 0x181f, 0xc40
  05C858  1F08: 83c402           add sp, 2
  05C85B  1F0B: 50               push ax
  05C85C  1F0C: 6a02             push 2
  05C85E  1F0E: 9a38041f18       lcall 0x181f, 0x438
  05C863  1F13: 83c404           add sp, 4
  05C866  1F16: 6a01             push 1
  05C868  1F18: 68da1b           push 0x1bda
  05C86B  1F1B: 9a52061f18       lcall 0x181f, 0x652
  05C870  1F20: 83c404           add sp, 4
  05C873  1F23: 5e               pop si
  05C874  1F24: c9               leave 
  05C875  1F25: cb               retf 
  05C876  1F26: cb               retf 

; ---- func_05C878  size=518  insns=183  prologue=ENTER 0x005E,0  terminal=RETF ----
  05C878  1F28: c85e0000         enter 0x5e, 0
  05C87C  1F2C: 57               push di
  05C87D  1F2D: 56               push si
  05C87E  1F2E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05C882  1F32: b064             mov al, 0x64
  05C884  1F34: f6a75b31         mul byte ptr [bx + 0x315b]
  05C888  1F38: 8946a6           mov word ptr [bp - 0x5a], ax
  05C88B  1F3B: f606825301       test byte ptr [0x5382], 1
  05C890  1F40: 7428             je 0x1f6a
  05C892  1F42: 6a00             push 0
  05C894  1F44: 50               push ax
  05C895  1F45: 6a00             push 0
  05C897  1F47: 9aae091f18       lcall 0x181f, 0x9ae
  05C89C  1F4C: 83c406           add sp, 6
  05C89F  1F4F: 6a02             push 2
  05C8A1  1F51: 68e01b           push 0x1be0
  05C8A4  1F54: 9a52061f18       lcall 0x181f, 0x652
  05C8A9  1F59: 83c404           add sp, 4
  05C8AC  1F5C: 6a02             push 2
  05C8AE  1F5E: 9ab6041f18       lcall 0x181f, 0x4b6
  05C8B3  1F63: 83c402           add sp, 2
  05C8B6  1F66: e99c01           jmp 0x2105
  05C8B9  1F69: 90               nop 
  05C8BA  1F6A: 8a1ea653         mov bl, byte ptr [0x53a6]
  05C8BE  1F6E: 2aff             sub bh, bh
  05C8C0  1F70: d1e3             shl bx, 1
  05C8C2  1F72: ffb79483         push word ptr [bx - 0x7c6c]
  05C8C6  1F76: 6a00             push 0
  05C8C8  1F78: 9a38041f18       lcall 0x181f, 0x438
  05C8CD  1F7D: 83c404           add sp, 4
  05C8D0  1F80: 6b460834         imul ax, word ptr [bp + 8], 0x34
  05C8D4  1F84: 050e54           add ax, 0x540e
  05C8D7  1F87: 1e               push ds
  05C8D8  1F88: 50               push ax
  05C8D9  1F89: 6a01             push 1
  05C8DB  1F8B: 9a16041f18       lcall 0x181f, 0x416
  05C8E0  1F90: 83c406           add sp, 6
  05C8E3  1F93: ff7608           push word ptr [bp + 8]
  05C8E6  1F96: 6a00             push 0
  05C8E8  1F98: 6a02             push 2
  05C8EA  1F9A: 9ac80a1f19       lcall 0x191f, 0xac8
  05C8EF  1F9F: 83c406           add sp, 6
  05C8F2  1FA2: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  05C8F7  1FA7: 8a870988         mov al, byte ptr [bx - 0x77f7]
  05C8FB  1FAB: 98               cwde 
  05C8FC  1FAC: 99               cdq 
  05C8FD  1FAD: 52               push dx
  05C8FE  1FAE: 50               push ax
  05C8FF  1FAF: 6a00             push 0
  05C901  1FB1: 9aae091f18       lcall 0x181f, 0x9ae
  05C906  1FB6: 83c406           add sp, 6
  05C909  1FB9: 68ed1b           push 0x1bed
  05C90C  1FBC: 8d46b0           lea ax, [bp - 0x50]
  05C90F  1FBF: 50               push ax
  05C910  1FC0: 9ae4071d0d       lcall 0xd1d, 0x7e4
  05C915  1FC5: 83c404           add sp, 4
  05C918  1FC8: 6a0a             push 0xa
  05C91A  1FCA: ff7608           push word ptr [bp + 8]
  05C91D  1FCD: 9ab4071f18       lcall 0x181f, 0x7b4
  05C922  1FD2: 83c404           add sp, 4
  05C925  1FD5: 0bc0             or ax, ax
  05C927  1FD7: 7405             je 0x1fde
  05C929  1FD9: 68f91b           push 0x1bf9
  05C92C  1FDC: eb03             jmp 0x1fe1
  05C92E  1FDE: 68fb1b           push 0x1bfb
  05C931  1FE1: 8d46b0           lea ax, [bp - 0x50]
  05C934  1FE4: 50               push ax
  05C935  1FE5: 9aa4071d0d       lcall 0xd1d, 0x7a4
  05C93A  1FEA: 83c404           add sp, 4
  05C93D  1FED: 6a3e             push 0x3e
  05C93F  1FEF: 9a8e041f18       lcall 0x181f, 0x48e
  05C944  1FF4: 83c402           add sp, 2
  05C947  1FF7: 8d5eb0           lea bx, [bp - 0x50]
  05C94A  1FFA: 9afe031f18       lcall 0x181f, 0x3fe
  05C94F  1FFF: 8946ae           mov word ptr [bp - 0x52], ax
  05C952  2002: 48               dec ax
  05C953  2003: 7403             je 0x2008
  05C955  2005: e92201           jmp 0x212a
  05C958  2008: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  05C95D  200D: 8a870988         mov al, byte ptr [bx - 0x77f7]
  05C961  2011: 98               cwde 
  05C962  2012: 8946a8           mov word ptr [bp - 0x58], ax
  05C965  2015: 6a0a             push 0xa
  05C967  2017: ff7608           push word ptr [bp + 8]
  05C96A  201A: 9ab4071f18       lcall 0x181f, 0x7b4
  05C96F  201F: 83c404           add sp, 4
  05C972  2022: 0bc0             or ax, ax
  05C974  2024: 751d             jne 0x2043
  05C976  2026: a0a653           mov al, byte ptr [0x53a6]
  05C979  2029: 2ae4             sub ah, ah
  05C97B  202B: 050a00           add ax, 0xa
  05C97E  202E: 8bc8             mov cx, ax
  05C980  2030: c1e002           shl ax, 2
  05C983  2033: 03c1             add ax, cx
  05C985  2035: d166a8           shl word ptr [bp - 0x58], 1
  05C988  2038: 3b46a8           cmp ax, word ptr [bp - 0x58]
  05C98B  203B: 7d03             jge 0x2040
  05C98D  203D: 8b46a8           mov ax, word ptr [bp - 0x58]
  05C990  2040: 8946a8           mov word ptr [bp - 0x58], ax
  05C993  2043: 6a00             push 0
  05C995  2045: 6a64             push 0x64
  05C997  2047: 8b46a6           mov ax, word ptr [bp - 0x5a]
  05C99A  204A: 2bd2             sub dx, dx
  05C99C  204C: 52               push dx
  05C99D  204D: 50               push ax
  05C99E  204E: 8bc8             mov cx, ax
  05C9A0  2050: 8b46a8           mov ax, word ptr [bp - 0x58]
  05C9A3  2053: 3d5a00           cmp ax, 0x5a
  05C9A6  2056: 7e03             jle 0x205b
  05C9A8  2058: b85a00           mov ax, 0x5a
  05C9AB  205B: 8946a8           mov word ptr [bp - 0x58], ax
  05C9AE  205E: 8bda             mov bx, dx
  05C9B0  2060: 99               cdq 
  05C9B1  2061: 52               push dx
  05C9B2  2062: 50               push ax
  05C9B3  2063: 8bf0             mov si, ax
  05C9B5  2065: 8bf9             mov di, cx
  05C9B7  2067: 8976a2           mov word ptr [bp - 0x5e], si
  05C9BA  206A: 8956a4           mov word ptr [bp - 0x5c], dx
  05C9BD  206D: 8bf3             mov si, bx
  05C9BF  206F: 9a600f1d0d       lcall 0xd1d, 0xf60
  05C9C4  2074: 52               push dx
  05C9C5  2075: 50               push ax
  05C9C6  2076: 9ac60e1d0d       lcall 0xd1d, 0xec6
  05C9CB  207B: 8946aa           mov word ptr [bp - 0x56], ax
  05C9CE  207E: 8956ac           mov word ptr [bp - 0x54], dx
  05C9D1  2081: 56               push si
  05C9D2  2082: 57               push di
  05C9D3  2083: 56               push si
  05C9D4  2084: 8bf0             mov si, ax
  05C9D6  2086: 9aae091f18       lcall 0x181f, 0x9ae
  05C9DB  208B: 83c406           add sp, 6
  05C9DE  208E: ff76a4           push word ptr [bp - 0x5c]
  05C9E1  2091: ff76a2           push word ptr [bp - 0x5e]
  05C9E4  2094: 6a01             push 1
  05C9E6  2096: 9aae091f18       lcall 0x181f, 0x9ae
  05C9EB  209B: 83c406           add sp, 6
  05C9EE  209E: 8bc6             mov ax, si
  05C9F0  20A0: 2946a6           sub word ptr [bp - 0x5a], ax
  05C9F3  20A3: 6a00             push 0
  05C9F5  20A5: ff76a6           push word ptr [bp - 0x5a]
  05C9F8  20A8: 6a02             push 2
  05C9FA  20AA: 9aae091f18       lcall 0x181f, 0x9ae
  05C9FF  20AF: 83c406           add sp, 6
  05CA02  20B2: ff7608           push word ptr [bp + 8]
  05CA05  20B5: 9aa4091f18       lcall 0x181f, 0x9a4
  05CA0A  20BA: 83c402           add sp, 2
  05CA0D  20BD: 50               push ax
  05CA0E  20BE: 6a00             push 0
  05CA10  20C0: 9a38041f18       lcall 0x181f, 0x438
  05CA15  20C5: 83c404           add sp, 4
  05CA18  20C8: 8b5e08           mov bx, word ptr [bp + 8]
  05CA1B  20CB: d1e3             shl bx, 1
  05CA1D  20CD: ffb78c83         push word ptr [bx - 0x7c74]
  05CA21  20D1: 6a01             push 1
  05CA23  20D3: 9a38041f18       lcall 0x181f, 0x438
  05CA28  20D8: 83c404           add sp, 4
  05CA2B  20DB: 6a02             push 2
  05CA2D  20DD: 9ab6041f18       lcall 0x181f, 0x4b6
  05CA32  20E2: 83c402           add sp, 2
  05CA35  20E5: 6a02             push 2
  05CA37  20E7: 68fd1b           push 0x1bfd
  05CA3A  20EA: 9a52061f18       lcall 0x181f, 0x652
  05CA3F  20EF: 83c404           add sp, 4
  05CA42  20F2: 8b46aa           mov ax, word ptr [bp - 0x56]
  05CA45  20F5: 8b56ac           mov dx, word ptr [bp - 0x54]
  05CA48  20F8: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  05CA4D  20FD: 01872a88         add word ptr [bx - 0x77d6], ax
  05CA51  2101: 11972c88         adc word ptr [bx - 0x77d4], dx
  05CA55  2105: 8b46a6           mov ax, word ptr [bp - 0x5a]
  05CA58  2108: 2bd2             sub dx, dx
  05CA5A  210A: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  05CA5F  210F: 01873288         add word ptr [bx - 0x77ce], ax
  05CA63  2113: 11973488         adc word ptr [bx - 0x77cc], dx
  05CA67  2117: 01872e88         add word ptr [bx - 0x77d2], ax
  05CA6B  211B: 11973088         adc word ptr [bx - 0x77d0], dx
  05CA6F  211F: ff7606           push word ptr [bp + 6]
  05CA72  2122: 9a08081f18       lcall 0x181f, 0x808
  05CA77  2127: 83c402           add sp, 2
  05CA7A  212A: 5e               pop si
  05CA7B  212B: 5f               pop di
  05CA7C  212C: c9               leave 
  05CA7D  212D: cb               retf 

; ---- func_05CA7E  size=7348  insns=2313  prologue=ENTER 0x00DE,0  terminal=page-end ----
  05CA7E  212E: c8de0000         enter 0xde, 0
  05CA82  2132: 57               push di
  05CA83  2133: 56               push si
  05CA84  2134: b8ffff           mov ax, 0xffff
  05CA87  2137: 89862aff         mov word ptr [bp - 0xd6], ax
  05CA8B  213B: 898650ff         mov word ptr [bp - 0xb0], ax
  05CA8F  213F: 8946a0           mov word ptr [bp - 0x60], ax
  05CA92  2142: 2bc0             sub ax, ax
  05CA94  2144: 898628ff         mov word ptr [bp - 0xd8], ax
  05CA98  2148: 8946f6           mov word ptr [bp - 0xa], ax
  05CA9B  214B: 894692           mov word ptr [bp - 0x6e], ax
  05CA9E  214E: 89866aff         mov word ptr [bp - 0x96], ax
  05CAA2  2152: 898656ff         mov word ptr [bp - 0xaa], ax
  05CAA6  2156: 894690           mov word ptr [bp - 0x70], ax
  05CAA9  2159: 8946fc           mov word ptr [bp - 4], ax
  05CAAC  215C: 894686           mov word ptr [bp - 0x7a], ax
  05CAAF  215F: 898638ff         mov word ptr [bp - 0xc8], ax
  05CAB3  2163: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05CAB7  2167: 8a874631         mov al, byte ptr [bx + 0x3146]
  05CABB  216B: 2ae4             sub ah, ah
  05CABD  216D: 898666ff         mov word ptr [bp - 0x9a], ax
  05CAC1  2171: ff7606           push word ptr [bp + 6]
  05CAC4  2174: 8bf3             mov si, bx
  05CAC6  2176: 9a0c091f18       lcall 0x181f, 0x90c
  05CACB  217B: 83c402           add sp, 2
  05CACE  217E: 2ae4             sub ah, ah
  05CAD0  2180: 8a8c4931         mov cl, byte ptr [si + 0x3149]
  05CAD4  2184: 2aed             sub ch, ch
  05CAD6  2186: 2bc1             sub ax, cx
  05CAD8  2188: 898668ff         mov word ptr [bp - 0x98], ax
  05CADC  218C: 837e0e00         cmp word ptr [bp + 0xe], 0
  05CAE0  2190: 7405             je 0x2197
  05CAE2  2192: 8084493103       add byte ptr [si + 0x3149], 3
  05CAE7  2197: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05CAEB  219B: 8a874731         mov al, byte ptr [bx + 0x3147]
  05CAEF  219F: 250f00           and ax, 0xf
  05CAF2  21A2: 89867aff         mov word ptr [bp - 0x86], ax
  05CAF6  21A6: 8a874a31         mov al, byte ptr [bx + 0x314a]
  05CAFA  21AA: 98               cwde 
  05CAFB  21AB: 8946f8           mov word ptr [bp - 8], ax
  05CAFE  21AE: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  05CB03  21B3: 720f             jb 0x21c4
  05CB05  21B5: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05CB0A  21BA: 7708             ja 0x21c4
  05CB0C  21BC: c7867cff0100     mov word ptr [bp - 0x84], 1
  05CB12  21C2: eb06             jmp 0x21ca
  05CB14  21C4: c7867cff0000     mov word ptr [bp - 0x84], 0
  05CB1A  21CA: ffb67aff         push word ptr [bp - 0x86]
  05CB1E  21CE: 8b4608           mov ax, word ptr [bp + 8]
  05CB21  21D1: 8b560a           mov dx, word ptr [bp + 0xa]
  05CB24  21D4: 9ae0071f18       lcall 0x181f, 0x7e0
  05CB29  21D9: 894682           mov word ptr [bp - 0x7e], ax
  05CB2C  21DC: 50               push ax
  05CB2D  21DD: 0e               push cs
  05CB2E  21DE: e8d91b           call 0x3dba
  05CB31  21E1: 83c404           add sp, 4
  05CB34  21E4: 89863aff         mov word ptr [bp - 0xc6], ax
  05CB38  21E8: 2bc0             sub ax, ax
  05CB3A  21EA: a3008d           mov word ptr [0x8d00], ax
  05CB3D  21ED: a356a1           mov word ptr [0xa156], ax
  05CB40  21F0: a3028d           mov word ptr [0x8d02], ax
  05CB43  21F3: a358a1           mov word ptr [0xa158], ax
  05CB46  21F6: 83be68ff03       cmp word ptr [bp - 0x98], 3
  05CB4B  21FB: 7d5f             jge 0x225c
  05CB4D  21FD: 8b8668ff         mov ax, word ptr [bp - 0x98]
  05CB51  2201: 89866aff         mov word ptr [bp - 0x96], ax
  05CB55  2205: 837e0e00         cmp word ptr [bp + 0xe], 0
  05CB59  2209: 7439             je 0x2244
  05CB5B  220B: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05CB60  2210: 7c03             jl 0x2215
  05CB62  2212: e9a11b           jmp 0x3db6
  05CB65  2215: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05CB6A  221A: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05CB6F  221F: 7403             je 0x2224
  05CB71  2221: e9921b           jmp 0x3db6
  05CB74  2224: 99               cdq 
  05CB75  2225: 52               push dx
  05CB76  2226: 50               push ax
  05CB77  2227: 6a00             push 0
  05CB79  2229: 9aae091f18       lcall 0x181f, 0x9ae
  05CB7E  222E: 83c406           add sp, 6
  05CB81  2231: 6a01             push 1
  05CB83  2233: 68061c           push 0x1c06
  05CB86  2236: 9a52061f18       lcall 0x181f, 0x652
  05CB8B  223B: 83c404           add sp, 4
  05CB8E  223E: 48               dec ax
  05CB8F  223F: 7403             je 0x2244
  05CB91  2241: e9721b           jmp 0x3db6
  05CB94  2244: 83be68ff02       cmp word ptr [bp - 0x98], 2
  05CB99  2249: 7505             jne 0x2250
  05CB9B  224B: 800e018d01       or byte ptr [0x8d01], 1
  05CBA0  2250: 83be68ff01       cmp word ptr [bp - 0x98], 1
  05CBA5  2255: 7505             jne 0x225c
  05CBA7  2257: 800e56a108       or byte ptr [0xa156], 8
  05CBAC  225C: 837e0e00         cmp word ptr [bp + 0xe], 0
  05CBB0  2260: 740b             je 0x226d
  05CBB2  2262: ff7606           push word ptr [bp + 6]
  05CBB5  2265: 9a34091f18       lcall 0x181f, 0x934
  05CBBA  226A: 83c402           add sp, 2
  05CBBD  226D: ff760a           push word ptr [bp + 0xa]
  05CBC0  2270: ff7608           push word ptr [bp + 8]
  05CBC3  2273: 9abe061f18       lcall 0x181f, 0x6be
  05CBC8  2278: 83c404           add sp, 4
  05CBCB  227B: 89862cff         mov word ptr [bp - 0xd4], ax
  05CBCF  227F: ff760a           push word ptr [bp + 0xa]
  05CBD2  2282: ff7608           push word ptr [bp + 8]
  05CBD5  2285: 9abe071f18       lcall 0x181f, 0x7be
  05CBDA  228A: 83c404           add sp, 4
  05CBDD  228D: 89862aff         mov word ptr [bp - 0xd6], ax
  05CBE1  2291: 83be3aff00       cmp word ptr [bp - 0xc6], 0
  05CBE6  2296: 7c03             jl 0x229b
  05CBE8  2298: e9a501           jmp 0x2440
  05CBEB  229B: c746920100       mov word ptr [bp - 0x6e], 1
  05CBF0  22A0: 83be2cff00       cmp word ptr [bp - 0xd4], 0
  05CBF5  22A5: 7d35             jge 0x22dc
  05CBF7  22A7: c78672ff0100     mov word ptr [bp - 0x8e], 1
  05CBFD  22AD: ffb672ff         push word ptr [bp - 0x8e]
  05CC01  22B1: ff760a           push word ptr [bp + 0xa]
  05CC04  22B4: ff7608           push word ptr [bp + 8]
  05CC07  22B7: 68e11c           push 0x1ce1
  05CC0A  22BA: 9a7e071f18       lcall 0x181f, 0x77e
  05CC0F  22BF: 83c408           add sp, 8
  05CC12  22C2: ff760a           push word ptr [bp + 0xa]
  05CC15  22C5: ff7608           push word ptr [bp + 8]
  05CC18  22C8: 9a02031f18       lcall 0x181f, 0x302
  05CC1D  22CD: 83c404           add sp, 4
  05CC20  22D0: 0bc0             or ax, ax
  05CC22  22D2: 7403             je 0x22d7
  05CC24  22D4: e9471a           jmp 0x3d1e
  05CC27  22D7: 5e               pop si
  05CC28  22D8: 5f               pop di
  05CC29  22D9: c9               leave 
  05CC2A  22DA: cb               retf 
  05CC2B  22DB: 90               nop 
  05CC2C  22DC: 0bc0             or ax, ax
  05CC2E  22DE: 7d1e             jge 0x22fe
  05CC30  22E0: ff760a           push word ptr [bp + 0xa]
  05CC33  22E3: ff7608           push word ptr [bp + 8]
  05CC36  22E6: 9af0091f18       lcall 0x181f, 0x9f0
  05CC3B  22EB: 83c404           add sp, 4
  05CC3E  22EE: 898650ff         mov word ptr [bp - 0xb0], ax
  05CC42  22F2: 0bc0             or ax, ax
  05CC44  22F4: 7d08             jge 0x22fe
  05CC46  22F6: c78672ff0200     mov word ptr [bp - 0x8e], 2
  05CC4C  22FC: ebaf             jmp 0x22ad
  05CC4E  22FE: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  05CC53  2303: 7d03             jge 0x2308
  05CC55  2305: e9a400           jmp 0x23ac
  05CC58  2308: ffb62aff         push word ptr [bp - 0xd6]
  05CC5C  230C: 9ae6091f18       lcall 0x181f, 0x9e6
  05CC61  2311: 83c402           add sp, 2
  05CC64  2314: 8b1e4285         mov bx, word ptr [0x8542]
  05CC68  2318: 8a471f           mov al, byte ptr [bx + 0x1f]
  05CC6B  231B: 98               cwde 
  05CC6C  231C: 48               dec ax
  05CC6D  231D: 50               push ax
  05CC6E  231E: 6a00             push 0
  05CC70  2320: 9ad4041f18       lcall 0x181f, 0x4d4
  05CC75  2325: 83c404           add sp, 4
  05CC78  2328: 898652ff         mov word ptr [bp - 0xae], ax
  05CC7C  232C: 50               push ax
  05CC7D  232D: 9a540c1f18       lcall 0x181f, 0xc54
  05CC82  2332: 83c402           add sp, 2
  05CC85  2335: 898654ff         mov word ptr [bp - 0xac], ax
  05CC89  2339: a03552           mov al, byte ptr [0x5235]
  05CC8C  233C: 2ae4             sub ah, ah
  05CC8E  233E: 898624ff         mov word ptr [bp - 0xdc], ax
  05CC92  2342: 800e038d02       or byte ptr [0x8d03], 2
  05CC97  2347: 8b8654ff         mov ax, word ptr [bp - 0xac]
  05CC9B  234B: 9ac6021f18       lcall 0x181f, 0x2c6
  05CCA0  2350: 89866eff         mov word ptr [bp - 0x92], ax
  05CCA4  2354: 6a0c             push 0xc
  05CCA6  2356: ffb62cff         push word ptr [bp - 0xd4]
  05CCAA  235A: 9ab4071f18       lcall 0x181f, 0x7b4
  05CCAF  235F: 83c404           add sp, 4
  05CCB2  2362: 0bc0             or ax, ax
  05CCB4  2364: 741a             je 0x2380
  05CCB6  2366: 8b1e4285         mov bx, word ptr [0x8542]
  05CCBA  236A: 83bfb80032       cmp word ptr [bx + 0xb8], 0x32
  05CCBF  236F: 7c0f             jl 0x2380
  05CCC1  2371: c7866eff4b00     mov word ptr [bp - 0x92], 0x4b
  05CCC7  2377: ff8624ff         inc word ptr [bp - 0xdc]
  05CCCB  237B: 800e038d04       or byte ptr [0x8d03], 4
  05CCD0  2380: ffb624ff         push word ptr [bp - 0xdc]
  05CCD4  2384: ffb62cff         push word ptr [bp - 0xd4]
  05CCD8  2388: ff760a           push word ptr [bp + 0xa]
  05CCDB  238B: ff7608           push word ptr [bp + 8]
  05CCDE  238E: ffb66eff         push word ptr [bp - 0x92]
  05CCE2  2392: 9a200a1f19       lcall 0x191f, 0xa20
  05CCE7  2397: 83c40a           add sp, 0xa
  05CCEA  239A: 89468c           mov word ptr [bp - 0x74], ax
  05CCED  239D: 6bd81c           imul bx, ax, 0x1c
  05CCF0  23A0: 8a8654ff         mov al, byte ptr [bp - 0xac]
  05CCF4  23A4: 88875b31         mov byte ptr [bx + 0x315b], al
  05CCF8  23A8: e98e00           jmp 0x2439
  05CCFB  23AB: 90               nop 
  05CCFC  23AC: ffb650ff         push word ptr [bp - 0xb0]
  05CD00  23B0: 9a4c0a1f18       lcall 0x181f, 0xa4c
  05CD05  23B5: 83c402           add sp, 2
  05CD08  23B8: c78678ff1300     mov word ptr [bp - 0x88], 0x13
  05CD0E  23BE: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05CD12  23C2: 807f0700         cmp byte ptr [bx + 7], 0
  05CD16  23C6: 7406             je 0x23ce
  05CD18  23C8: c78678ff1400     mov word ptr [bp - 0x88], 0x14
  05CD1E  23CE: 837f0a19         cmp word ptr [bx + 0xa], 0x19
  05CD22  23D2: 7c05             jl 0x23d9
  05CD24  23D4: 838678ff02       add word ptr [bp - 0x88], 2
  05CD29  23D9: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  05CD2D  23DD: 8a4705           mov al, byte ptr [bx + 5]
  05CD30  23E0: 98               cwde 
  05CD31  23E1: 8946a0           mov word ptr [bp - 0x60], ax
  05CD34  23E4: 8b9e78ff         mov bx, word ptr [bp - 0x88]
  05CD38  23E8: 8bc3             mov ax, bx
  05CD3A  23EA: d1e3             shl bx, 1
  05CD3C  23EC: 03d8             add bx, ax
  05CD3E  23EE: d1e3             shl bx, 1
  05CD40  23F0: 03d8             add bx, ax
  05CD42  23F2: d1e3             shl bx, 1
  05CD44  23F4: 8a873552         mov al, byte ptr [bx + 0x5235]
  05CD48  23F8: 2ae4             sub ah, ah
  05CD4A  23FA: 898624ff         mov word ptr [bp - 0xdc], ax
  05CD4E  23FE: 50               push ax
  05CD4F  23FF: ffb62cff         push word ptr [bp - 0xd4]
  05CD53  2403: ff760a           push word ptr [bp + 0xa]
  05CD56  2406: ff7608           push word ptr [bp + 8]
  05CD59  2409: 8a873252         mov al, byte ptr [bx + 0x5232]
  05CD5D  240D: 50               push ax
  05CD5E  240E: 8bf3             mov si, bx
  05CD60  2410: 9a200a1f19       lcall 0x191f, 0xa20
  05CD65  2415: 83c40a           add sp, 0xa
  05CD68  2418: 89468c           mov word ptr [bp - 0x74], ax
  05CD6B  241B: 8b843052         mov ax, word ptr [si + 0x5230]
  05CD6F  241F: 6b5e8c1c         imul bx, word ptr [bp - 0x74], 0x1c
  05CD73  2423: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05CD77  2427: 2aff             sub bh, bh
  05CD79  2429: 8bcb             mov cx, bx
  05CD7B  242B: d1e3             shl bx, 1
  05CD7D  242D: 03d9             add bx, cx
  05CD7F  242F: d1e3             shl bx, 1
  05CD81  2431: 03d9             add bx, cx
  05CD83  2433: d1e3             shl bx, 1
  05CD85  2435: 89873052         mov word ptr [bx + 0x5230], ax
  05CD89  2439: 8b468c           mov ax, word ptr [bp - 0x74]
  05CD8C  243C: 89863aff         mov word ptr [bp - 0xc6], ax
  05CD90  2440: 83be3aff00       cmp word ptr [bp - 0xc6], 0
  05CD95  2445: 7d09             jge 0x2450
  05CD97  2447: c78672ff0300     mov word ptr [bp - 0x8e], 3
  05CD9D  244D: e95dfe           jmp 0x22ad
  05CDA0  2450: 6b9e3aff1c       imul bx, word ptr [bp - 0xc6], 0x1c
  05CDA5  2455: 8a874731         mov al, byte ptr [bx + 0x3147]
  05CDA9  2459: 250f00           and ax, 0xf
  05CDAC  245C: 89468a           mov word ptr [bp - 0x76], ax
  05CDAF  245F: 8a874631         mov al, byte ptr [bx + 0x3146]
  05CDB3  2463: 2ae4             sub ah, ah
  05CDB5  2465: 898674ff         mov word ptr [bp - 0x8c], ax
  05CDB9  2469: 8a874a31         mov al, byte ptr [bx + 0x314a]
  05CDBD  246D: 98               cwde 
  05CDBE  246E: 89862eff         mov word ptr [bp - 0xd2], ax
  05CDC2  2472: ff7606           push word ptr [bp + 6]
  05CDC5  2475: ffb63aff         push word ptr [bp - 0xc6]
  05CDC9  2479: 8bf3             mov si, bx
  05CDCB  247B: 9adc091f18       lcall 0x181f, 0x9dc
  05CDD0  2480: 83c404           add sp, 4
  05CDD3  2483: 89865aff         mov word ptr [bp - 0xa6], ax
  05CDD7  2487: 80bc46310d       cmp byte ptr [si + 0x3146], 0xd
  05CDDC  248C: 7210             jb 0x249e
  05CDDE  248E: 80bc463112       cmp byte ptr [si + 0x3146], 0x12
  05CDE3  2493: 7709             ja 0x249e
  05CDE5  2495: c78676ff0100     mov word ptr [bp - 0x8a], 1
  05CDEB  249B: eb07             jmp 0x24a4
  05CDED  249D: 90               nop 
  05CDEE  249E: c78676ff0000     mov word ptr [bp - 0x8a], 0
  05CDF4  24A4: 6a01             push 1
  05CDF6  24A6: ff7606           push word ptr [bp + 6]
  05CDF9  24A9: 9ac8091f18       lcall 0x181f, 0x9c8
  05CDFE  24AE: 83c404           add sp, 4
  05CE01  24B1: 898670ff         mov word ptr [bp - 0x90], ax
  05CE05  24B5: a1048d           mov ax, word ptr [0x8d04]
  05CE08  24B8: 050400           add ax, 4
  05CE0B  24BB: f7ae70ff         imul word ptr [bp - 0x90]
  05CE0F  24BF: c1f802           sar ax, 2
  05CE12  24C2: 898670ff         mov word ptr [bp - 0x90], ax
  05CE16  24C6: 8bc8             mov cx, ax
  05CE18  24C8: d1e0             shl ax, 1
  05CE1A  24CA: 03c1             add ax, cx
  05CE1C  24CC: d1f8             sar ax, 1
  05CE1E  24CE: 898670ff         mov word ptr [bp - 0x90], ax
  05CE22  24D2: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05CE27  24D7: 7d1a             jge 0x24f3
  05CE29  24D9: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05CE2E  24DE: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05CE33  24E3: 750e             jne 0x24f3
  05CE35  24E5: a0a653           mov al, byte ptr [0x53a6]
  05CE38  24E8: 2ae4             sub ah, ah
  05CE3A  24EA: 2d0400           sub ax, 4
  05CE3D  24ED: f7d8             neg ax
  05CE3F  24EF: 018670ff         add word ptr [bp - 0x90], ax
  05CE43  24F3: 837e8a04         cmp word ptr [bp - 0x76], 4
  05CE47  24F7: 7d19             jge 0x2512
  05CE49  24F9: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05CE4D  24FD: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05CE52  2502: 750e             jne 0x2512
  05CE54  2504: a0a653           mov al, byte ptr [0x53a6]
  05CE57  2507: 2ae4             sub ah, ah
  05CE59  2509: 2d0400           sub ax, 4
  05CE5C  250C: f7d8             neg ax
  05CE5E  250E: 01865aff         add word ptr [bp - 0xa6], ax
  05CE62  2512: 83be6aff00       cmp word ptr [bp - 0x96], 0
  05CE67  2517: 7412             je 0x252b
  05CE69  2519: 8b8670ff         mov ax, word ptr [bp - 0x90]
  05CE6D  251D: f7ae6aff         imul word ptr [bp - 0x96]
  05CE71  2521: b90300           mov cx, 3
  05CE74  2524: 99               cdq 
  05CE75  2525: f7f9             idiv cx
  05CE77  2527: 898670ff         mov word ptr [bp - 0x90], ax
  05CE7B  252B: 83be7cff00       cmp word ptr [bp - 0x84], 0
  05CE80  2530: 7539             jne 0x256b
  05CE82  2532: 83be76ff00       cmp word ptr [bp - 0x8a], 0
  05CE87  2537: 7532             jne 0x256b
  05CE89  2539: 8b9e66ff         mov bx, word ptr [bp - 0x9a]
  05CE8D  253D: 8bc3             mov ax, bx
  05CE8F  253F: d1e3             shl bx, 1
  05CE91  2541: 03d8             add bx, ax
  05CE93  2543: d1e3             shl bx, 1
  05CE95  2545: 03d8             add bx, ax
  05CE97  2547: d1e3             shl bx, 1
  05CE99  2549: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  05CE9E  254E: 761b             jbe 0x256b
  05CEA0  2550: 8b9e74ff         mov bx, word ptr [bp - 0x8c]
  05CEA4  2554: 8bc3             mov ax, bx
  05CEA6  2556: d1e3             shl bx, 1
  05CEA8  2558: 03d8             add bx, ax
  05CEAA  255A: d1e3             shl bx, 1
  05CEAC  255C: 03d8             add bx, ax
  05CEAE  255E: d1e3             shl bx, 1
  05CEB0  2560: 80bf355202       cmp byte ptr [bx + 0x5235], 2
  05CEB5  2565: 7304             jae 0x256b
  05CEB7  2567: d1be5aff         sar word ptr [bp - 0xa6], 1
  05CEBB  256B: 83be2cff00       cmp word ptr [bp - 0xd4], 0
  05CEC0  2570: 7d56             jge 0x25c8
  05CEC2  2572: 83be66ff0b       cmp word ptr [bp - 0x9a], 0xb
  05CEC7  2577: 7523             jne 0x259c
  05CEC9  2579: 6b9e3aff1c       imul bx, word ptr [bp - 0xc6], 0x1c
  05CECE  257E: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  05CED3  2583: 7407             je 0x258c
  05CED5  2585: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  05CEDA  258A: 7506             jne 0x2592
  05CEDC  258C: 837e8a04         cmp word ptr [bp - 0x76], 4
  05CEE0  2590: 7c0a             jl 0x259c
  05CEE2  2592: c1be70ff02       sar word ptr [bp - 0x90], 2
  05CEE7  2597: 800e018d08       or byte ptr [0x8d01], 8
  05CEEC  259C: 83be74ff0b       cmp word ptr [bp - 0x8c], 0xb
  05CEF1  25A1: 753c             jne 0x25df
  05CEF3  25A3: 6b9e3aff1c       imul bx, word ptr [bp - 0xc6], 0x1c
  05CEF8  25A8: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  05CEFD  25AD: 7407             je 0x25b6
  05CEFF  25AF: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  05CF04  25B4: 7506             jne 0x25bc
  05CF06  25B6: 837e8a04         cmp word ptr [bp - 0x76], 4
  05CF0A  25BA: 7c23             jl 0x25df
  05CF0C  25BC: 800e038d08       or byte ptr [0x8d03], 8
  05CF11  25C1: c1be5aff02       sar word ptr [bp - 0xa6], 2
  05CF16  25C6: eb17             jmp 0x25df
  05CF18  25C8: 83be74ff0b       cmp word ptr [bp - 0x8c], 0xb
  05CF1D  25CD: 7510             jne 0x25df
  05CF1F  25CF: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05CF24  25D4: 7c09             jl 0x25df
  05CF26  25D6: 800e58a101       or byte ptr [0xa158], 1
  05CF2B  25DB: d1a65aff         shl word ptr [bp - 0xa6], 1
  05CF2F  25DF: 83be7aff02       cmp word ptr [bp - 0x86], 2
  05CF34  25E4: 751c             jne 0x2602
  05CF36  25E6: 837e8a04         cmp word ptr [bp - 0x76], 4
  05CF3A  25EA: 7c16             jl 0x2602
  05CF3C  25EC: 83be2cff00       cmp word ptr [bp - 0xd4], 0
  05CF41  25F1: 7c0f             jl 0x2602
  05CF43  25F3: 8b8670ff         mov ax, word ptr [bp - 0x90]
  05CF47  25F7: d1f8             sar ax, 1
  05CF49  25F9: 018670ff         add word ptr [bp - 0x90], ax
  05CF4D  25FD: 800e018d10       or byte ptr [0x8d01], 0x10
  05CF52  2602: f606825301       test byte ptr [0x5382], 1
  05CF57  2607: 7503             jne 0x260c
  05CF59  2609: e9c500           jmp 0x26d1
  05CF5C  260C: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05CF61  2611: 7c03             jl 0x2616
  05CF63  2613: e9bb00           jmp 0x26d1
  05CF66  2616: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  05CF6B  261B: 7c6f             jl 0x268c
  05CF6D  261D: a1d253           mov ax, word ptr [0x53d2]
  05CF70  2620: 39867aff         cmp word ptr [bp - 0x86], ax
  05CF74  2624: 7407             je 0x262d
  05CF76  2626: f606825302       test byte ptr [0x5382], 2
  05CF7B  262B: 740f             je 0x263c
  05CF7D  262D: 800e018d80       or byte ptr [0x8d01], 0x80
  05CF82  2632: 8b8670ff         mov ax, word ptr [bp - 0x90]
  05CF86  2636: d1f8             sar ax, 1
  05CF88  2638: 018670ff         add word ptr [bp - 0x90], ax
  05CF8C  263C: ffb62aff         push word ptr [bp - 0xd6]
  05CF90  2640: 9ae6091f18       lcall 0x181f, 0x9e6
  05CF95  2645: 83c402           add sp, 2
  05CF98  2648: 9a860c1f18       lcall 0x181f, 0xc86
  05CF9D  264D: 89865eff         mov word ptr [bp - 0xa2], ax
  05CFA1  2651: a1d253           mov ax, word ptr [0x53d2]
  05CFA4  2654: 39867aff         cmp word ptr [bp - 0x86], ax
  05CFA8  2658: 7512             jne 0x266c
  05CFAA  265A: c746f40200       mov word ptr [bp - 0xc], 2
  05CFAF  265F: b86400           mov ax, 0x64
  05CFB2  2662: 2b865eff         sub ax, word ptr [bp - 0xa2]
  05CFB6  2666: 89865eff         mov word ptr [bp - 0xa2], ax
  05CFBA  266A: eb05             jmp 0x2671
  05CFBC  266C: c746f40400       mov word ptr [bp - 0xc], 4
  05CFC1  2671: 83be5eff00       cmp word ptr [bp - 0xa2], 0
  05CFC6  2676: 7442             je 0x26ba
  05CFC8  2678: 8b46f4           mov ax, word ptr [bp - 0xc]
  05CFCB  267B: 090656a1         or word ptr [0xa156], ax
  05CFCF  267F: 8b865eff         mov ax, word ptr [bp - 0xa2]
  05CFD3  2683: f7ae70ff         imul word ptr [bp - 0x90]
  05CFD7  2687: b96400           mov cx, 0x64
  05CFDA  268A: eb27             jmp 0x26b3
  05CFDC  268C: a1d253           mov ax, word ptr [0x53d2]
  05CFDF  268F: 39867aff         cmp word ptr [bp - 0x86], ax
  05CFE3  2693: 7525             jne 0x26ba
  05CFE5  2695: ff760a           push word ptr [bp + 0xa]
  05CFE8  2698: ff7608           push word ptr [bp + 8]
  05CFEB  269B: 9a68071f18       lcall 0x181f, 0x768
  05CFF0  26A0: 83c404           add sp, 4
  05CFF3  26A3: 0bc0             or ax, ax
  05CFF5  26A5: 7513             jne 0x26ba
  05CFF7  26A7: a0a653           mov al, byte ptr [0x53a6]
  05CFFA  26AA: 2ae4             sub ah, ah
  05CFFC  26AC: f7ae70ff         imul word ptr [bp - 0x90]
  05D000  26B0: b91400           mov cx, 0x14
  05D003  26B3: 99               cdq 
  05D004  26B4: f7f9             idiv cx
  05D006  26B6: 018670ff         add word ptr [bp - 0x90], ax
  05D00A  26BA: a1d253           mov ax, word ptr [0x53d2]
  05D00D  26BD: 39867aff         cmp word ptr [bp - 0x86], ax
  05D011  26C1: 750e             jne 0x26d1
  05D013  26C3: ff760a           push word ptr [bp + 0xa]
  05D016  26C6: ff7608           push word ptr [bp + 8]
  05D019  26C9: 9a96061f18       lcall 0x181f, 0x696
  05D01E  26CE: 83c404           add sp, 4
  05D021  26D1: 837e0e00         cmp word ptr [bp + 0xe], 0
  05D025  26D5: 751f             jne 0x26f6
  05D027  26D7: 837e9200         cmp word ptr [bp - 0x6e], 0
  05D02B  26DB: 7405             je 0x26e2
  05D02D  26DD: 9a060a1f19       lcall 0x191f, 0xa06
  05D032  26E2: 8b8670ff         mov ax, word ptr [bp - 0x90]
  05D036  26E6: c1e003           shl ax, 3
  05D039  26E9: 8b8e5aff         mov cx, word ptr [bp - 0xa6]
  05D03D  26ED: 41               inc cx
  05D03E  26EE: 99               cdq 
  05D03F  26EF: f7f9             idiv cx
  05D041  26F1: 5e               pop si
  05D042  26F2: 5f               pop di
  05D043  26F3: c9               leave 
  05D044  26F4: cb               retf 
  05D045  26F5: 90               nop 
  05D046  26F6: 803ea65301       cmp byte ptr [0x53a6], 1
  05D04B  26FB: 7603             jbe 0x2700
  05D04D  26FD: e98900           jmp 0x2789
  05D050  2700: f606825301       test byte ptr [0x5382], 1
  05D055  2705: 7415             je 0x271c
  05D057  2707: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  05D05C  270C: 7c0e             jl 0x271c
  05D05E  270E: 83be66ff0d       cmp word ptr [bp - 0x9a], 0xd
  05D063  2713: 7c74             jl 0x2789
  05D065  2715: 83be66ff12       cmp word ptr [bp - 0x9a], 0x12
  05D06A  271A: 7f6d             jg 0x2789
  05D06C  271C: 837e8a04         cmp word ptr [bp - 0x76], 4
  05D070  2720: 7d44             jge 0x2766
  05D072  2722: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05D076  2726: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D07B  272B: 7539             jne 0x2766
  05D07D  272D: 833e8e5350       cmp word ptr [0x538e], 0x50
  05D082  2732: 7d32             jge 0x2766
  05D084  2734: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  05D089  2739: 7c2b             jl 0x2766
  05D08B  273B: 803ea65300       cmp byte ptr [0x53a6], 0
  05D090  2740: 7406             je 0x2748
  05D092  2742: d1be70ff         sar word ptr [bp - 0x90], 1
  05D096  2746: eb0b             jmp 0x2753
  05D098  2748: 8b8670ff         mov ax, word ptr [bp - 0x90]
  05D09C  274C: c1f802           sar ax, 2
  05D09F  274F: 298670ff         sub word ptr [bp - 0x90], ax
  05D0A3  2753: 837e9200         cmp word ptr [bp - 0x6e], 0
  05D0A7  2757: 740d             je 0x2766
  05D0A9  2759: 803ea65300       cmp byte ptr [0x53a6], 0
  05D0AE  275E: 7506             jne 0x2766
  05D0B0  2760: c78670ff0000     mov word ptr [bp - 0x90], 0
  05D0B6  2766: 837e8a04         cmp word ptr [bp - 0x76], 4
  05D0BA  276A: 7d1d             jge 0x2789
  05D0BC  276C: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05D0C0  2770: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D0C5  2775: 7512             jne 0x2789
  05D0C7  2777: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D0CC  277C: 7c07             jl 0x2785
  05D0CE  277E: 833e8e5350       cmp word ptr [0x538e], 0x50
  05D0D3  2783: 7d04             jge 0x2789
  05D0D5  2785: d1be70ff         sar word ptr [bp - 0x90], 1
  05D0D9  2789: 803ea65300       cmp byte ptr [0x53a6], 0
  05D0DE  278E: 7517             jne 0x27a7
  05D0E0  2790: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D0E5  2795: 7d10             jge 0x27a7
  05D0E7  2797: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05D0EC  279C: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D0F1  27A1: 7504             jne 0x27a7
  05D0F3  27A3: d1a670ff         shl word ptr [bp - 0x90], 1
  05D0F7  27A7: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  05D0FC  27AC: 7c53             jl 0x2801
  05D0FE  27AE: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D103  27B3: 7c10             jl 0x27c5
  05D105  27B5: 8b5e8a           mov bx, word ptr [bp - 0x76]
  05D108  27B8: 80bf989201       cmp byte ptr [bx - 0x6d68], 1
  05D10D  27BD: 7506             jne 0x27c5
  05D10F  27BF: c78670ff0000     mov word ptr [bp - 0x90], 0
  05D115  27C5: 837e8a04         cmp word ptr [bp - 0x76], 4
  05D119  27C9: 7d36             jge 0x2801
  05D11B  27CB: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05D11F  27CF: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D124  27D4: 752b             jne 0x2801
  05D126  27D6: 699e2affca00     imul bx, word ptr [bp - 0xd6], 0xca
  05D12C  27DC: 8a87655d         mov al, byte ptr [bx + 0x5d65]
  05D130  27E0: 98               cwde 
  05D131  27E1: 8b5e8a           mov bx, word ptr [bp - 0x76]
  05D134  27E4: 8a8f0c94         mov cl, byte ptr [bx - 0x6bf4]
  05D138  27E8: d0e9             shr cl, 1
  05D13A  27EA: 2aed             sub ch, ch
  05D13C  27EC: 3bc8             cmp cx, ax
  05D13E  27EE: 7f11             jg 0x2801
  05D140  27F0: a0a653           mov al, byte ptr [0x53a6]
  05D143  27F3: 2ae4             sub ah, ah
  05D145  27F5: 2d0400           sub ax, 4
  05D148  27F8: f7d8             neg ax
  05D14A  27FA: c1e002           shl ax, 2
  05D14D  27FD: 01865aff         add word ptr [bp - 0xa6], ax
  05D151  2801: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05D155  2805: 8a874431         mov al, byte ptr [bx + 0x3144]
  05D159  2809: 2ae4             sub ah, ah
  05D15B  280B: 89864cff         mov word ptr [bp - 0xb4], ax
  05D15F  280F: 8a874531         mov al, byte ptr [bx + 0x3145]
  05D163  2813: 898644ff         mov word ptr [bp - 0xbc], ax
  05D167  2817: ff7606           push word ptr [bp + 6]
  05D16A  281A: 9a16091f18       lcall 0x181f, 0x916
  05D16F  281F: 83c402           add sp, 2
  05D172  2822: ff7606           push word ptr [bp + 6]
  05D175  2825: 9a9e081f18       lcall 0x181f, 0x89e
  05D17A  282A: 83c402           add sp, 2
  05D17D  282D: 8b865aff         mov ax, word ptr [bp - 0xa6]
  05D181  2831: 038670ff         add ax, word ptr [bp - 0x90]
  05D185  2835: 50               push ax
  05D186  2836: 6a01             push 1
  05D188  2838: 9ad4041f18       lcall 0x181f, 0x4d4
  05D18D  283D: 83c404           add sp, 4
  05D190  2840: 898630ff         mov word ptr [bp - 0xd0], ax
  05D194  2844: 3b8670ff         cmp ax, word ptr [bp - 0x90]
  05D198  2848: 7f06             jg 0x2850
  05D19A  284A: b80100           mov ax, 1
  05D19D  284D: eb03             jmp 0x2852
  05D19F  284F: 90               nop 
  05D1A0  2850: 2bc0             sub ax, ax
  05D1A2  2852: 898664ff         mov word ptr [bp - 0x9c], ax
  05D1A6  2856: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D1AB  285B: 7c2b             jl 0x2888
  05D1AD  285D: 837e8a04         cmp word ptr [bp - 0x76], 4
  05D1B1  2861: 7d25             jge 0x2888
  05D1B3  2863: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05D1B7  2867: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D1BC  286C: 751a             jne 0x2888
  05D1BE  286E: 83be66ff13       cmp word ptr [bp - 0x9a], 0x13
  05D1C3  2873: 7513             jne 0x2888
  05D1C5  2875: 83be74ff0b       cmp word ptr [bp - 0x8c], 0xb
  05D1CA  287A: 750c             jne 0x2888
  05D1CC  287C: c78664ff0000     mov word ptr [bp - 0x9c], 0
  05D1D2  2882: c78638ff0100     mov word ptr [bp - 0xc8], 1
  05D1D8  2888: 837e0c00         cmp word ptr [bp + 0xc], 0
  05D1DC  288C: 7503             jne 0x2891
  05D1DE  288E: e99501           jmp 0x2a26
  05D1E1  2891: c746fe0000       mov word ptr [bp - 2], 0
  05D1E6  2896: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D1EB  289B: 7c34             jl 0x28d1
  05D1ED  289D: 837e8a04         cmp word ptr [bp - 0x76], 4
  05D1F1  28A1: 7d2e             jge 0x28d1
  05D1F3  28A3: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05D1F7  28A7: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D1FC  28AC: 7523             jne 0x28d1
  05D1FE  28AE: 8b8666ff         mov ax, word ptr [bp - 0x9a]
  05D202  28B2: 053b00           add ax, 0x3b
  05D205  28B5: 9ac0041f18       lcall 0x181f, 0x4c0
  05D20A  28BA: 6a0d             push 0xd
  05D20C  28BC: 9a1a051f18       lcall 0x181f, 0x51a
  05D211  28C1: 83c402           add sp, 2
  05D214  28C4: 8946fe           mov word ptr [bp - 2], ax
  05D217  28C7: 6a0d             push 0xd
  05D219  28C9: 9a24051f18       lcall 0x181f, 0x524
  05D21E  28CE: 83c402           add sp, 2
  05D221  28D1: f606835302       test byte ptr [0x5383], 2
  05D226  28D6: 7476             je 0x294e
  05D228  28D8: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D22D  28DD: 7d0c             jge 0x28eb
  05D22F  28DF: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05D234  28E4: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D239  28E9: 7418             je 0x2903
  05D23B  28EB: 837e8a04         cmp word ptr [bp - 0x76], 4
  05D23F  28EF: 7d0b             jge 0x28fc
  05D241  28F1: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05D245  28F5: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D24A  28FA: 7407             je 0x2903
  05D24C  28FC: 833ea25300       cmp word ptr [0x53a2], 0
  05D251  2901: 744b             je 0x294e
  05D253  2903: ff760a           push word ptr [bp + 0xa]
  05D256  2906: ff7608           push word ptr [bp + 8]
  05D259  2909: 9a9a0d1f18       lcall 0x181f, 0xd9a
  05D25E  290E: 83c404           add sp, 4
  05D261  2911: ffb630ff         push word ptr [bp - 0xd0]
  05D265  2915: ffb65aff         push word ptr [bp - 0xa6]
  05D269  2919: ffb670ff         push word ptr [bp - 0x90]
  05D26D  291D: ff36041b         push word ptr [0x1b04]
  05D271  2921: ff36061b         push word ptr [0x1b06]
  05D275  2925: ff768a           push word ptr [bp - 0x76]
  05D278  2928: ffb67aff         push word ptr [bp - 0x86]
  05D27C  292C: ff760a           push word ptr [bp + 0xa]
  05D27F  292F: ff7608           push word ptr [bp + 8]
  05D282  2932: ffb644ff         push word ptr [bp - 0xbc]
  05D286  2936: ffb64cff         push word ptr [bp - 0xb4]
  05D28A  293A: ffb63aff         push word ptr [bp - 0xc6]
  05D28E  293E: ff7606           push word ptr [bp + 6]
  05D291  2941: 9a04071f1a       lcall 0x1a1f, 0x704
  05D296  2946: 83c41a           add sp, 0x1a
  05D299  2949: c746fe0000       mov word ptr [bp - 2], 0
  05D29E  294E: 837efe00         cmp word ptr [bp - 2], 0
  05D2A2  2952: 7578             jne 0x29cc
  05D2A4  2954: 83be7cff00       cmp word ptr [bp - 0x84], 0
  05D2A9  2959: 750e             jne 0x2969
  05D2AB  295B: 83be66ff0b       cmp word ptr [bp - 0x9a], 0xb
  05D2B0  2960: 7407             je 0x2969
  05D2B2  2962: 83be74ff0b       cmp word ptr [bp - 0x8c], 0xb
  05D2B7  2967: 7505             jne 0x296e
  05D2B9  2969: b84200           mov ax, 0x42
  05D2BC  296C: eb59             jmp 0x29c7
  05D2BE  296E: 83be66ff04       cmp word ptr [bp - 0x9a], 4
  05D2C3  2973: 7415             je 0x298a
  05D2C5  2975: 83be66ff05       cmp word ptr [bp - 0x9a], 5
  05D2CA  297A: 740e             je 0x298a
  05D2CC  297C: 83be66ff08       cmp word ptr [bp - 0x9a], 8
  05D2D1  2981: 7407             je 0x298a
  05D2D3  2983: 83be66ff07       cmp word ptr [bp - 0x9a], 7
  05D2D8  2988: 7506             jne 0x2990
  05D2DA  298A: b84c00           mov ax, 0x4c
  05D2DD  298D: eb38             jmp 0x29c7
  05D2DF  298F: 90               nop 
  05D2E0  2990: 8b9e66ff         mov bx, word ptr [bp - 0x9a]
  05D2E4  2994: 8bc3             mov ax, bx
  05D2E6  2996: d1e3             shl bx, 1
  05D2E8  2998: 03d8             add bx, ax
  05D2EA  299A: d1e3             shl bx, 1
  05D2EC  299C: 03d8             add bx, ax
  05D2EE  299E: d1e3             shl bx, 1
  05D2F0  29A0: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  05D2F5  29A5: 7717             ja 0x29be
  05D2F7  29A7: 8b9e74ff         mov bx, word ptr [bp - 0x8c]
  05D2FB  29AB: 8bc3             mov ax, bx
  05D2FD  29AD: d1e3             shl bx, 1
  05D2FF  29AF: 03d8             add bx, ax
  05D301  29B1: d1e3             shl bx, 1
  05D303  29B3: 03d8             add bx, ax
  05D305  29B5: d1e3             shl bx, 1
  05D307  29B7: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  05D30C  29BC: 7606             jbe 0x29c4
  05D30E  29BE: b84100           mov ax, 0x41
  05D311  29C1: eb04             jmp 0x29c7
  05D313  29C3: 90               nop 
  05D314  29C4: b84000           mov ax, 0x40
  05D317  29C7: 9ac0041f18       lcall 0x181f, 0x4c0
  05D31C  29CC: c7863cffc000     mov word ptr [bp - 0xc4], 0xc0
  05D322  29D2: ff760a           push word ptr [bp + 0xa]
  05D325  29D5: ff7608           push word ptr [bp + 8]
  05D328  29D8: 9abe061f18       lcall 0x181f, 0x6be
  05D32D  29DD: 83c404           add sp, 4
  05D330  29E0: 0bc0             or ax, ax
  05D332  29E2: 7c07             jl 0x29eb
  05D334  29E4: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05D339  29E9: 7405             je 0x29f0
  05D33B  29EB: 808e3cff10       or byte ptr [bp - 0xc4], 0x10
  05D340  29F0: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05D344  29F4: 8a874731         mov al, byte ptr [bx + 0x3147]
  05D348  29F8: 240f             and al, 0xf
  05D34A  29FA: 3a069653         cmp al, byte ptr [0x5396]
  05D34E  29FE: 7405             je 0x2a05
  05D350  2A00: 808e3cff20       or byte ptr [bp - 0xc4], 0x20
  05D355  2A05: ff760a           push word ptr [bp + 0xa]
  05D358  2A08: ff7608           push word ptr [bp + 8]
  05D35B  2A0B: ffb644ff         push word ptr [bp - 0xbc]
  05D35F  2A0F: ffb64cff         push word ptr [bp - 0xb4]
  05D363  2A13: ffb63aff         push word ptr [bp - 0xc6]
  05D367  2A17: ffb63cff         push word ptr [bp - 0xc4]
  05D36B  2A1B: ff7606           push word ptr [bp + 6]
  05D36E  2A1E: 9ad0021f18       lcall 0x181f, 0x2d0
  05D373  2A23: 83c40e           add sp, 0xe
  05D376  2A26: 83be7cff00       cmp word ptr [bp - 0x84], 0
  05D37B  2A2B: 7503             jne 0x2a30
  05D37D  2A2D: e9f800           jmp 0x2b28
  05D380  2A30: 83be76ff00       cmp word ptr [bp - 0x8a], 0
  05D385  2A35: 7503             jne 0x2a3a
  05D387  2A37: e9ee00           jmp 0x2b28
  05D38A  2A3A: 8b9e66ff         mov bx, word ptr [bp - 0x9a]
  05D38E  2A3E: 8bc3             mov ax, bx
  05D390  2A40: d1e3             shl bx, 1
  05D392  2A42: 03d8             add bx, ax
  05D394  2A44: d1e3             shl bx, 1
  05D396  2A46: 03d8             add bx, ax
  05D398  2A48: d1e3             shl bx, 1
  05D39A  2A4A: 8a873652         mov al, byte ptr [bx + 0x5236]
  05D39E  2A4E: 8bb674ff         mov si, word ptr [bp - 0x8c]
  05D3A2  2A52: 8bce             mov cx, si
  05D3A4  2A54: d1e6             shl si, 1
  05D3A6  2A56: 03f1             add si, cx
  05D3A8  2A58: d1e6             shl si, 1
  05D3AA  2A5A: 03f1             add si, cx
  05D3AC  2A5C: d1e6             shl si, 1
  05D3AE  2A5E: 38843652         cmp byte ptr [si + 0x5236], al
  05D3B2  2A62: 7203             jb 0x2a67
  05D3B4  2A64: e9c100           jmp 0x2b28
  05D3B7  2A67: ff7606           push word ptr [bp + 6]
  05D3BA  2A6A: 8bfb             mov di, bx
  05D3BC  2A6C: 9a26061f1a       lcall 0x1a1f, 0x626
  05D3C1  2A71: 83c402           add sp, 2
  05D3C4  2A74: 894696           mov word ptr [bp - 0x6a], ax
  05D3C7  2A77: ffb63aff         push word ptr [bp - 0xc6]
  05D3CB  2A7B: 9a26061f1a       lcall 0x1a1f, 0x626
  05D3D0  2A80: 83c402           add sp, 2
  05D3D3  2A83: 89468e           mov word ptr [bp - 0x72], ax
  05D3D6  2A86: 034696           add ax, word ptr [bp - 0x6a]
  05D3D9  2A89: 50               push ax
  05D3DA  2A8A: 6a01             push 1
  05D3DC  2A8C: 9ad4041f18       lcall 0x181f, 0x4d4
  05D3E1  2A91: 83c404           add sp, 4
  05D3E4  2A94: 3b468e           cmp ax, word ptr [bp - 0x72]
  05D3E7  2A97: 7e03             jle 0x2a9c
  05D3E9  2A99: e98c00           jmp 0x2b28
  05D3EC  2A9C: ffb644ff         push word ptr [bp - 0xbc]
  05D3F0  2AA0: ffb64cff         push word ptr [bp - 0xb4]
  05D3F4  2AA4: ff7606           push word ptr [bp + 6]
  05D3F7  2AA7: 9a48091f18       lcall 0x181f, 0x948
  05D3FC  2AAC: 83c406           add sp, 6
  05D3FF  2AAF: 837e0c00         cmp word ptr [bp + 0xc], 0
  05D403  2AB3: 7503             jne 0x2ab8
  05D405  2AB5: e9fe12           jmp 0x3db6
  05D408  2AB8: 6a01             push 1
  05D40A  2ABA: 6a01             push 1
  05D40C  2ABC: 6a01             push 1
  05D40E  2ABE: ffb644ff         push word ptr [bp - 0xbc]
  05D412  2AC2: ffb64cff         push word ptr [bp - 0xb4]
  05D416  2AC6: 9aba091f18       lcall 0x181f, 0x9ba
  05D41B  2ACB: 83c40a           add sp, 0xa
  05D41E  2ACE: ff768a           push word ptr [bp - 0x76]
  05D421  2AD1: 9aa4091f18       lcall 0x181f, 0x9a4
  05D426  2AD6: 83c402           add sp, 2
  05D429  2AD9: 50               push ax
  05D42A  2ADA: 6a00             push 0
  05D42C  2ADC: 9a38041f18       lcall 0x181f, 0x438
  05D431  2AE1: 83c404           add sp, 4
  05D434  2AE4: ffb43052         push word ptr [si + 0x5230]
  05D438  2AE8: 6a01             push 1
  05D43A  2AEA: 9a38041f18       lcall 0x181f, 0x438
  05D43F  2AEF: 83c404           add sp, 4
  05D442  2AF2: ffb67aff         push word ptr [bp - 0x86]
  05D446  2AF6: 9aa4091f18       lcall 0x181f, 0x9a4
  05D44B  2AFB: 83c402           add sp, 2
  05D44E  2AFE: 50               push ax
  05D44F  2AFF: 6a02             push 2
  05D451  2B01: 9a38041f18       lcall 0x181f, 0x438
  05D456  2B06: 83c404           add sp, 4
  05D459  2B09: ffb53052         push word ptr [di + 0x5230]
  05D45D  2B0D: 6a03             push 3
  05D45F  2B0F: 9a38041f18       lcall 0x181f, 0x438
  05D464  2B14: 83c404           add sp, 4
  05D467  2B17: 6a00             push 0
  05D469  2B19: 680b1c           push 0x1c0b
  05D46C  2B1C: 9a52061f18       lcall 0x181f, 0x652
  05D471  2B21: 83c404           add sp, 4
  05D474  2B24: 5e               pop si
  05D475  2B25: 5f               pop di
  05D476  2B26: c9               leave 
  05D477  2B27: cb               retf 
  05D478  2B28: 837e9200         cmp word ptr [bp - 0x6e], 0
  05D47C  2B2C: 7405             je 0x2b33
  05D47E  2B2E: 9a060a1f19       lcall 0x191f, 0xa06
  05D483  2B33: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05D488  2B38: 7503             jne 0x2b3d
  05D48A  2B3A: e91703           jmp 0x2e54
  05D48D  2B3D: ff7606           push word ptr [bp + 6]
  05D490  2B40: 9ac6081f18       lcall 0x181f, 0x8c6
  05D495  2B45: 83c402           add sp, 2
  05D498  2B48: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D49D  2B4D: 7c25             jl 0x2b74
  05D49F  2B4F: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  05D4A4  2B54: 7c1e             jl 0x2b74
  05D4A6  2B56: 8b1e4285         mov bx, word ptr [0x8542]
  05D4AA  2B5A: 807f1f01         cmp byte ptr [bx + 0x1f], 1
  05D4AE  2B5E: 7f06             jg 0x2b66
  05D4B0  2B60: 837e9200         cmp word ptr [bp - 0x6e], 0
  05D4B4  2B64: 750e             jne 0x2b74
  05D4B6  2B66: c746fc0100       mov word ptr [bp - 4], 1
  05D4BB  2B6B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05D4BF  2B6F: 808f483110       or byte ptr [bx + 0x3148], 0x10
  05D4C4  2B74: 837e9200         cmp word ptr [bp - 0x6e], 0
  05D4C8  2B78: 7414             je 0x2b8e
  05D4CA  2B7A: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  05D4CF  2B7F: 7c0d             jl 0x2b8e
  05D4D1  2B81: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D4D6  2B86: 7d06             jge 0x2b8e
  05D4D8  2B88: c78628ff0100     mov word ptr [bp - 0xd8], 1
  05D4DE  2B8E: 837e9200         cmp word ptr [bp - 0x6e], 0
  05D4E2  2B92: 7403             je 0x2b97
  05D4E4  2B94: e98d00           jmp 0x2c24
  05D4E7  2B97: 837e0c00         cmp word ptr [bp + 0xc], 0
  05D4EB  2B9B: 7427             je 0x2bc4
  05D4ED  2B9D: 83be7cff00       cmp word ptr [bp - 0x84], 0
  05D4F2  2BA2: 7507             jne 0x2bab
  05D4F4  2BA4: 83be66ff0b       cmp word ptr [bp - 0x9a], 0xb
  05D4F9  2BA9: 7505             jne 0x2bb0
  05D4FB  2BAB: b84300           mov ax, 0x43
  05D4FE  2BAE: eb0f             jmp 0x2bbf
  05D500  2BB0: 83be2cff00       cmp word ptr [bp - 0xd4], 0
  05D505  2BB5: 7c05             jl 0x2bbc
  05D507  2BB7: b84900           mov ax, 0x49
  05D50A  2BBA: eb03             jmp 0x2bbf
  05D50C  2BBC: b84000           mov ax, 0x40
  05D50F  2BBF: 9ac0041f18       lcall 0x181f, 0x4c0
  05D514  2BC4: 8b9e66ff         mov bx, word ptr [bp - 0x9a]
  05D518  2BC8: 8bc3             mov ax, bx
  05D51A  2BCA: d1e3             shl bx, 1
  05D51C  2BCC: 03d8             add bx, ax
  05D51E  2BCE: d1e3             shl bx, 1
  05D520  2BD0: 03d8             add bx, ax
  05D522  2BD2: d1e3             shl bx, 1
  05D524  2BD4: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  05D529  2BD9: 7433             je 0x2c0e
  05D52B  2BDB: 3d0d00           cmp ax, 0xd
  05D52E  2BDE: 7c05             jl 0x2be5
  05D530  2BE0: 3d1200           cmp ax, 0x12
  05D533  2BE3: 7e29             jle 0x2c0e
  05D535  2BE5: 83be74ff0d       cmp word ptr [bp - 0x8c], 0xd
  05D53A  2BEA: 7c07             jl 0x2bf3
  05D53C  2BEC: 83be74ff12       cmp word ptr [bp - 0x8c], 0x12
  05D541  2BF1: 7e1b             jle 0x2c0e
  05D543  2BF3: ff760a           push word ptr [bp + 0xa]
  05D546  2BF6: ff7608           push word ptr [bp + 8]
  05D549  2BF9: ff760c           push word ptr [bp + 0xc]
  05D54C  2BFC: ff7606           push word ptr [bp + 6]
  05D54F  2BFF: ffb63aff         push word ptr [bp - 0xc6]
  05D553  2C03: 0e               push cs
  05D554  2C04: e8cc11           call 0x3dd3
  05D557  2C07: 83c40a           add sp, 0xa
  05D55A  2C0A: e99a01           jmp 0x2da7
  05D55D  2C0D: 90               nop 
  05D55E  2C0E: ff760a           push word ptr [bp + 0xa]
  05D561  2C11: ff7608           push word ptr [bp + 8]
  05D564  2C14: ff760c           push word ptr [bp + 0xc]
  05D567  2C17: ff7606           push word ptr [bp + 6]
  05D56A  2C1A: ffb63aff         push word ptr [bp - 0xc6]
  05D56E  2C1E: 0e               push cs
  05D56F  2C1F: e8bb11           call 0x3ddd
  05D572  2C22: ebe3             jmp 0x2c07
  05D574  2C24: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  05D579  2C29: 7d03             jge 0x2c2e
  05D57B  2C2B: e9e800           jmp 0x2d16
  05D57E  2C2E: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D583  2C33: 7d05             jge 0x2c3a
  05D585  2C35: b80100           mov ax, 1
  05D588  2C38: eb02             jmp 0x2c3c
  05D58A  2C3A: 2bc0             sub ax, ax
  05D58C  2C3C: 898648ff         mov word ptr [bp - 0xb8], ax
  05D590  2C40: 8b1e4285         mov bx, word ptr [0x8542]
  05D594  2C44: 807f1f01         cmp byte ptr [bx + 0x1f], 1
  05D598  2C48: 7f04             jg 0x2c4e
  05D59A  2C4A: 0bc0             or ax, ax
  05D59C  2C4C: 7432             je 0x2c80
  05D59E  2C4E: 0bc0             or ax, ax
  05D5A0  2C50: 750c             jne 0x2c5e
  05D5A2  2C52: ffb652ff         push word ptr [bp - 0xae]
  05D5A6  2C56: 9a9c0a1f18       lcall 0x181f, 0xa9c
  05D5AB  2C5B: 83c402           add sp, 2
  05D5AE  2C5E: 837e0c00         cmp word ptr [bp + 0xc], 0
  05D5B2  2C62: 7503             jne 0x2c67
  05D5B4  2C64: e94001           jmp 0x2da7
  05D5B7  2C67: 83be28ff00       cmp word ptr [bp - 0xd8], 0
  05D5BC  2C6C: 7406             je 0x2c74
  05D5BE  2C6E: b84b00           mov ax, 0x4b
  05D5C1  2C71: eb04             jmp 0x2c77
  05D5C3  2C73: 90               nop 
  05D5C4  2C74: b84a00           mov ax, 0x4a
  05D5C7  2C77: 9ac0041f18       lcall 0x181f, 0x4c0
  05D5CC  2C7C: e92801           jmp 0x2da7
  05D5CF  2C7F: 90               nop 
  05D5D0  2C80: 8b4608           mov ax, word ptr [bp + 8]
  05D5D3  2C83: 8b560a           mov dx, word ptr [bp + 0xa]
  05D5D6  2C86: 9ae0071f18       lcall 0x181f, 0x7e0
  05D5DB  2C8B: 89863eff         mov word ptr [bp - 0xc2], ax
  05D5DF  2C8F: 0bc0             or ax, ax
  05D5E1  2C91: 7c14             jl 0x2ca7
  05D5E3  2C93: ff760a           push word ptr [bp + 0xa]
  05D5E6  2C96: ff7608           push word ptr [bp + 8]
  05D5E9  2C99: ff760c           push word ptr [bp + 0xc]
  05D5EC  2C9C: ff7606           push word ptr [bp + 6]
  05D5EF  2C9F: 50               push ax
  05D5F0  2CA0: 0e               push cs
  05D5F1  2CA1: e83911           call 0x3ddd
  05D5F4  2CA4: 83c40a           add sp, 0xa
  05D5F7  2CA7: 837e0c00         cmp word ptr [bp + 0xc], 0
  05D5FB  2CAB: 7408             je 0x2cb5
  05D5FD  2CAD: b84a00           mov ax, 0x4a
  05D600  2CB0: 9ac0041f18       lcall 0x181f, 0x4c0
  05D605  2CB5: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D60A  2CBA: 7c34             jl 0x2cf0
  05D60C  2CBC: 8b867aff         mov ax, word ptr [bp - 0x86]
  05D610  2CC0: 2d0400           sub ax, 4
  05D613  2CC3: 50               push ax
  05D614  2CC4: 9a420a1f18       lcall 0x181f, 0xa42
  05D619  2CC9: 83c402           add sp, 2
  05D61C  2CCC: 8b1e4285         mov bx, word ptr [0x8542]
  05D620  2CD0: 83bfaa0000       cmp word ptr [bx + 0xaa], 0
  05D625  2CD5: 7407             je 0x2cde
  05D627  2CD7: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05D62B  2CDB: fe4708           inc byte ptr [bx + 8]
  05D62E  2CDE: 8b1e4285         mov bx, word ptr [0x8542]
  05D632  2CE2: 83bfb80000       cmp word ptr [bx + 0xb8], 0
  05D637  2CE7: 7407             je 0x2cf0
  05D639  2CE9: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05D63D  2CED: fe4707           inc byte ptr [bx + 7]
  05D640  2CF0: a14285           mov ax, word ptr [0x8542]
  05D643  2CF3: 40               inc ax
  05D644  2CF4: 40               inc ax
  05D645  2CF5: 1e               push ds
  05D646  2CF6: 50               push ax
  05D647  2CF7: 6a03             push 3
  05D649  2CF9: 9a16041f18       lcall 0x181f, 0x416
  05D64E  2CFE: 83c406           add sp, 6
  05D651  2D01: ffb62aff         push word ptr [bp - 0xd6]
  05D655  2D05: 9a54021f19       lcall 0x191f, 0x254
  05D65A  2D0A: 83c402           add sp, 2
  05D65D  2D0D: c746f60100       mov word ptr [bp - 0xa], 1
  05D662  2D12: e99200           jmp 0x2da7
  05D665  2D15: 90               nop 
  05D666  2D16: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  05D66A  2D1A: 8a4703           mov al, byte ptr [bx + 3]
  05D66D  2D1D: 250400           and ax, 4
  05D670  2D20: 898634ff         mov word ptr [bp - 0xcc], ax
  05D674  2D24: 807f0401         cmp byte ptr [bx + 4], 1
  05D678  2D28: 7610             jbe 0x2d3a
  05D67A  2D2A: fe4f04           dec byte ptr [bx + 4]
  05D67D  2D2D: 837e0c00         cmp word ptr [bp + 0xc], 0
  05D681  2D31: 7474             je 0x2da7
  05D683  2D33: b84800           mov ax, 0x48
  05D686  2D36: e93eff           jmp 0x2c77
  05D689  2D39: 90               nop 
  05D68A  2D3A: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D68F  2D3F: 7d14             jge 0x2d55
  05D691  2D41: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05D696  2D46: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D69B  2D4B: 7508             jne 0x2d55
  05D69D  2D4D: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05D6A1  2D51: 804f0340         or byte ptr [bx + 3], 0x40
  05D6A5  2D55: ffb650ff         push word ptr [bp - 0xb0]
  05D6A9  2D59: 9a48021f19       lcall 0x191f, 0x248
  05D6AE  2D5E: 83c402           add sp, 2
  05D6B1  2D61: c746f60100       mov word ptr [bp - 0xa], 1
  05D6B6  2D66: 837e0c00         cmp word ptr [bp + 0xc], 0
  05D6BA  2D6A: 7408             je 0x2d74
  05D6BC  2D6C: b84a00           mov ax, 0x4a
  05D6BF  2D6F: 9ac0041f18       lcall 0x181f, 0x4c0
  05D6C4  2D74: 8a46a0           mov al, byte ptr [bp - 0x60]
  05D6C7  2D77: 250f00           and ax, 0xf
  05D6CA  2D7A: 3b867aff         cmp ax, word ptr [bp - 0x86]
  05D6CE  2D7E: 7527             jne 0x2da7
  05D6D0  2D80: ff760a           push word ptr [bp + 0xa]
  05D6D3  2D83: ff7608           push word ptr [bp + 8]
  05D6D6  2D86: 50               push ax
  05D6D7  2D87: 6a03             push 3
  05D6D9  2D89: 9a5c091f18       lcall 0x181f, 0x95c
  05D6DE  2D8E: 83c408           add sp, 8
  05D6E1  2D91: 89863eff         mov word ptr [bp - 0xc2], ax
  05D6E5  2D95: 0bc0             or ax, ax
  05D6E7  2D97: 7c0e             jl 0x2da7
  05D6E9  2D99: f646a010         test byte ptr [bp - 0x60], 0x10
  05D6ED  2D9D: 7408             je 0x2da7
  05D6EF  2D9F: 6bd81c           imul bx, ax, 0x1c
  05D6F2  2DA2: c6875b3118       mov byte ptr [bx + 0x315b], 0x18
  05D6F7  2DA7: ffb65aff         push word ptr [bp - 0xa6]
  05D6FB  2DAB: ffb670ff         push word ptr [bp - 0x90]
  05D6FF  2DAF: b8feff           mov ax, 0xfffe
  05D702  2DB2: 8bd0             mov dx, ax
  05D704  2DB4: 9ae0071f18       lcall 0x181f, 0x7e0
  05D709  2DB9: 894606           mov word ptr [bp + 6], ax
  05D70C  2DBC: 9a8e091f18       lcall 0x181f, 0x98e
  05D711  2DC1: 894606           mov word ptr [bp + 6], ax
  05D714  2DC4: 50               push ax
  05D715  2DC5: 0e               push cs
  05D716  2DC6: e80510           call 0x3dce
  05D719  2DC9: 83c406           add sp, 6
  05D71C  2DCC: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D721  2DD1: 7c76             jl 0x2e49
  05D723  2DD3: 837e8a04         cmp word ptr [bp - 0x76], 4
  05D727  2DD7: 7d70             jge 0x2e49
  05D729  2DD9: 837e9200         cmp word ptr [bp - 0x6e], 0
  05D72D  2DDD: 756a             jne 0x2e49
  05D72F  2DDF: 837efc00         cmp word ptr [bp - 4], 0
  05D733  2DE3: 7564             jne 0x2e49
  05D735  2DE5: 83be74ff04       cmp word ptr [bp - 0x8c], 4
  05D73A  2DEA: 7407             je 0x2df3
  05D73C  2DEC: 83be74ff05       cmp word ptr [bp - 0x8c], 5
  05D741  2DF1: 7533             jne 0x2e26
  05D743  2DF3: 83be66ff13       cmp word ptr [bp - 0x9a], 0x13
  05D748  2DF8: 7407             je 0x2e01
  05D74A  2DFA: 83be66ff14       cmp word ptr [bp - 0x9a], 0x14
  05D74F  2DFF: 7525             jne 0x2e26
  05D751  2E01: c746900100       mov word ptr [bp - 0x70], 1
  05D756  2E06: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05D75A  2E0A: 8087463102       add byte ptr [bx + 0x3146], 2
  05D75F  2E0F: ff7606           push word ptr [bp + 6]
  05D762  2E12: 9a34091f18       lcall 0x181f, 0x934
  05D767  2E17: 83c402           add sp, 2
  05D76A  2E1A: 6b9e7aff4e       imul bx, word ptr [bp - 0x86], 0x4e
  05D76F  2E1F: fe87a659         inc byte ptr [bx + 0x59a6]
  05D773  2E23: eb24             jmp 0x2e49
  05D775  2E25: 90               nop 
  05D776  2E26: 83be74ff01       cmp word ptr [bp - 0x8c], 1
  05D77B  2E2B: 751c             jne 0x2e49
  05D77D  2E2D: 83be66ff15       cmp word ptr [bp - 0x9a], 0x15
  05D782  2E32: 7407             je 0x2e3b
  05D784  2E34: 83be66ff13       cmp word ptr [bp - 0x9a], 0x13
  05D789  2E39: 750e             jne 0x2e49
  05D78B  2E3B: c78656ff0100     mov word ptr [bp - 0xaa], 1
  05D791  2E41: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05D795  2E45: fe874631         inc byte ptr [bx + 0x3146]
  05D799  2E49: ff7606           push word ptr [bp + 6]
  05D79C  2E4C: 9ac6081f18       lcall 0x181f, 0x8c6
  05D7A1  2E51: 83c402           add sp, 2
  05D7A4  2E54: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05D7A9  2E59: 7409             je 0x2e64
  05D7AB  2E5B: 837efc00         cmp word ptr [bp - 4], 0
  05D7AF  2E5F: 7503             jne 0x2e64
  05D7B1  2E61: e99000           jmp 0x2ef4
  05D7B4  2E64: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05D7B9  2E69: 7513             jne 0x2e7e
  05D7BB  2E6B: ffb670ff         push word ptr [bp - 0x90]
  05D7BF  2E6F: ffb65aff         push word ptr [bp - 0xa6]
  05D7C3  2E73: ffb63aff         push word ptr [bp - 0xc6]
  05D7C7  2E77: 0e               push cs
  05D7C8  2E78: e8530f           call 0x3dce
  05D7CB  2E7B: 83c406           add sp, 6
  05D7CE  2E7E: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05D7D3  2E83: 751b             jne 0x2ea0
  05D7D5  2E85: ffb644ff         push word ptr [bp - 0xbc]
  05D7D9  2E89: ffb64cff         push word ptr [bp - 0xb4]
  05D7DD  2E8D: ff760c           push word ptr [bp + 0xc]
  05D7E0  2E90: ffb63aff         push word ptr [bp - 0xc6]
  05D7E4  2E94: ff7606           push word ptr [bp + 6]
  05D7E7  2E97: 0e               push cs
  05D7E8  2E98: e8420f           call 0x3ddd
  05D7EB  2E9B: 83c40a           add sp, 0xa
  05D7EE  2E9E: eb0b             jmp 0x2eab
  05D7F0  2EA0: ff7606           push word ptr [bp + 6]
  05D7F3  2EA3: 9a3a081f18       lcall 0x181f, 0x83a
  05D7F8  2EA8: 83c402           add sp, 2
  05D7FB  2EAB: b8feff           mov ax, 0xfffe
  05D7FE  2EAE: 8bd0             mov dx, ax
  05D800  2EB0: 9ae0071f18       lcall 0x181f, 0x7e0
  05D805  2EB5: 89863eff         mov word ptr [bp - 0xc2], ax
  05D809  2EB9: 0bc0             or ax, ax
  05D80B  2EBB: 7c13             jl 0x2ed0
  05D80D  2EBD: ffb644ff         push word ptr [bp - 0xbc]
  05D811  2EC1: ffb64cff         push word ptr [bp - 0xb4]
  05D815  2EC5: ff7606           push word ptr [bp + 6]
  05D818  2EC8: 9a48091f18       lcall 0x181f, 0x948
  05D81D  2ECD: 83c406           add sp, 6
  05D820  2ED0: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05D825  2ED5: 7430             je 0x2f07
  05D827  2ED7: 837e0c00         cmp word ptr [bp + 0xc], 0
  05D82B  2EDB: 742a             je 0x2f07
  05D82D  2EDD: 83be7cff00       cmp word ptr [bp - 0x84], 0
  05D832  2EE2: 7406             je 0x2eea
  05D834  2EE4: b84400           mov ax, 0x44
  05D837  2EE7: eb04             jmp 0x2eed
  05D839  2EE9: 90               nop 
  05D83A  2EEA: b84500           mov ax, 0x45
  05D83D  2EED: 9ac0041f18       lcall 0x181f, 0x4c0
  05D842  2EF2: eb13             jmp 0x2f07
  05D844  2EF4: ffb644ff         push word ptr [bp - 0xbc]
  05D848  2EF8: ffb64cff         push word ptr [bp - 0xb4]
  05D84C  2EFC: ff7606           push word ptr [bp + 6]
  05D84F  2EFF: 9a48091f18       lcall 0x181f, 0x948
  05D854  2F04: 83c406           add sp, 6
  05D857  2F07: 837e0c00         cmp word ptr [bp + 0xc], 0
  05D85B  2F0B: 7503             jne 0x2f10
  05D85D  2F0D: e9a600           jmp 0x2fb6
  05D860  2F10: 8b460a           mov ax, word ptr [bp + 0xa]
  05D863  2F13: 3b8644ff         cmp ax, word ptr [bp - 0xbc]
  05D867  2F17: 7e04             jle 0x2f1d
  05D869  2F19: 8b8644ff         mov ax, word ptr [bp - 0xbc]
  05D86D  2F1D: 898646ff         mov word ptr [bp - 0xba], ax
  05D871  2F21: 8b4e08           mov cx, word ptr [bp + 8]
  05D874  2F24: 3b8e4cff         cmp cx, word ptr [bp - 0xb4]
  05D878  2F28: 7e04             jle 0x2f2e
  05D87A  2F2A: 8b8e4cff         mov cx, word ptr [bp - 0xb4]
  05D87E  2F2E: 898e4eff         mov word ptr [bp - 0xb2], cx
  05D882  2F32: 2b4e08           sub cx, word ptr [bp + 8]
  05D885  2F35: f7d9             neg cx
  05D887  2F37: 41               inc cx
  05D888  2F38: 41               inc cx
  05D889  2F39: 894e94           mov word ptr [bp - 0x6c], cx
  05D88C  2F3C: 2b460a           sub ax, word ptr [bp + 0xa]
  05D88F  2F3F: f7d8             neg ax
  05D891  2F41: 40               inc ax
  05D892  2F42: 40               inc ax
  05D893  2F43: 894688           mov word ptr [bp - 0x78], ax
  05D896  2F46: 837efc00         cmp word ptr [bp - 4], 0
  05D89A  2F4A: 751d             jne 0x2f69
  05D89C  2F4C: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05D8A1  2F51: 7416             je 0x2f69
  05D8A3  2F53: 6a01             push 1
  05D8A5  2F55: 6a01             push 1
  05D8A7  2F57: 6a01             push 1
  05D8A9  2F59: ffb644ff         push word ptr [bp - 0xbc]
  05D8AD  2F5D: ffb64cff         push word ptr [bp - 0xb4]
  05D8B1  2F61: 9aba091f18       lcall 0x181f, 0x9ba
  05D8B6  2F66: 83c40a           add sp, 0xa
  05D8B9  2F69: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05D8BE  2F6E: 7514             jne 0x2f84
  05D8C0  2F70: 6a01             push 1
  05D8C2  2F72: 6a01             push 1
  05D8C4  2F74: 6a01             push 1
  05D8C6  2F76: ff760a           push word ptr [bp + 0xa]
  05D8C9  2F79: ff7608           push word ptr [bp + 8]
  05D8CC  2F7C: 9aba091f18       lcall 0x181f, 0x9ba
  05D8D1  2F81: 83c40a           add sp, 0xa
  05D8D4  2F84: 837ef600         cmp word ptr [bp - 0xa], 0
  05D8D8  2F88: 740a             je 0x2f94
  05D8DA  2F8A: 6a00             push 0
  05D8DC  2F8C: 9a1c0e1f18       lcall 0x181f, 0xe1c
  05D8E1  2F91: 83c402           add sp, 2
  05D8E4  2F94: 6a00             push 0
  05D8E6  2F96: ff7688           push word ptr [bp - 0x78]
  05D8E9  2F99: ff7694           push word ptr [bp - 0x6c]
  05D8EC  2F9C: ffb646ff         push word ptr [bp - 0xba]
  05D8F0  2FA0: ffb64eff         push word ptr [bp - 0xb2]
  05D8F4  2FA4: 9aba091f18       lcall 0x181f, 0x9ba
  05D8F9  2FA9: 83c40a           add sp, 0xa
  05D8FC  2FAC: 6a08             push 8
  05D8FE  2FAE: 9aea031f18       lcall 0x181f, 0x3ea
  05D903  2FB3: 83c402           add sp, 2
  05D906  2FB6: ffb67aff         push word ptr [bp - 0x86]
  05D90A  2FBA: 9a1a0a1f18       lcall 0x181f, 0xa1a
  05D90F  2FBF: 83c402           add sp, 2
  05D912  2FC2: 50               push ax
  05D913  2FC3: 6a00             push 0
  05D915  2FC5: 9a38041f18       lcall 0x181f, 0x438
  05D91A  2FCA: 83c404           add sp, 4
  05D91D  2FCD: ff768a           push word ptr [bp - 0x76]
  05D920  2FD0: 9aa4091f18       lcall 0x181f, 0x9a4
  05D925  2FD5: 83c402           add sp, 2
  05D928  2FD8: 50               push ax
  05D929  2FD9: 6a01             push 1
  05D92B  2FDB: 9a38041f18       lcall 0x181f, 0x438
  05D930  2FE0: 83c404           add sp, 4
  05D933  2FE3: 6aff             push -1
  05D935  2FE5: 6aff             push -1
  05D937  2FE7: ff760a           push word ptr [bp + 0xa]
  05D93A  2FEA: ff7608           push word ptr [bp + 8]
  05D93D  2FED: 9a14061f18       lcall 0x181f, 0x614
  05D942  2FF2: 83c408           add sp, 8
  05D945  2FF5: 8946f2           mov word ptr [bp - 0xe], ax
  05D948  2FF8: 0bc0             or ax, ax
  05D94A  2FFA: 7c1a             jl 0x3016
  05D94C  2FFC: 837ef600         cmp word ptr [bp - 0xa], 0
  05D950  3000: 7522             jne 0x3024
  05D952  3002: a14285           mov ax, word ptr [0x8542]
  05D955  3005: 40               inc ax
  05D956  3006: 40               inc ax
  05D957  3007: 1e               push ds
  05D958  3008: 50               push ax
  05D959  3009: 6a03             push 3
  05D95B  300B: 9a16041f18       lcall 0x181f, 0x416
  05D960  3010: 83c406           add sp, 6
  05D963  3013: eb0f             jmp 0x3024
  05D965  3015: 90               nop 
  05D966  3016: ff36dc2d         push word ptr [0x2ddc]
  05D96A  301A: 6a03             push 3
  05D96C  301C: 9a38041f18       lcall 0x181f, 0x438
  05D971  3021: 83c404           add sp, 4
  05D974  3024: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05D979  3029: 7c03             jl 0x302e
  05D97B  302B: e9ad00           jmp 0x30db
  05D97E  302E: 837e8a04         cmp word ptr [bp - 0x76], 4
  05D982  3032: 7c03             jl 0x3037
  05D984  3034: e9a400           jmp 0x30db
  05D987  3037: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05D98B  303B: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05D990  3040: 7403             je 0x3045
  05D992  3042: e99600           jmp 0x30db
  05D995  3045: 837ef600         cmp word ptr [bp - 0xa], 0
  05D999  3049: 7403             je 0x304e
  05D99B  304B: e98d00           jmp 0x30db
  05D99E  304E: 83be28ff00       cmp word ptr [bp - 0xd8], 0
  05D9A3  3053: 7403             je 0x3058
  05D9A5  3055: e98300           jmp 0x30db
  05D9A8  3058: 837e9200         cmp word ptr [bp - 0x6e], 0
  05D9AC  305C: 7410             je 0x306e
  05D9AE  305E: ffb654ff         push word ptr [bp - 0xac]
  05D9B2  3062: 9a180c1f18       lcall 0x181f, 0xc18
  05D9B7  3067: 83c402           add sp, 2
  05D9BA  306A: 50               push ax
  05D9BB  306B: eb15             jmp 0x3082
  05D9BD  306D: 90               nop 
  05D9BE  306E: 8b9e74ff         mov bx, word ptr [bp - 0x8c]
  05D9C2  3072: 8bc3             mov ax, bx
  05D9C4  3074: d1e3             shl bx, 1
  05D9C6  3076: 03d8             add bx, ax
  05D9C8  3078: d1e3             shl bx, 1
  05D9CA  307A: 03d8             add bx, ax
  05D9CC  307C: d1e3             shl bx, 1
  05D9CE  307E: ffb73052         push word ptr [bx + 0x5230]
  05D9D2  3082: 6a02             push 2
  05D9D4  3084: 9a38041f18       lcall 0x181f, 0x438
  05D9D9  3089: 83c404           add sp, 4
  05D9DC  308C: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05D9E1  3091: 7415             je 0x30a8
  05D9E3  3093: ff364c2e         push word ptr [0x2e4c]
  05D9E7  3097: 6a04             push 4
  05D9E9  3099: 9a38041f18       lcall 0x181f, 0x438
  05D9EE  309E: 83c404           add sp, 4
  05D9F1  30A1: 6a01             push 1
  05D9F3  30A3: 68131c           push 0x1c13
  05D9F6  30A6: eb2b             jmp 0x30d3
  05D9F8  30A8: 83be74ff07       cmp word ptr [bp - 0x8c], 7
  05D9FD  30AD: 7d07             jge 0x30b6
  05D9FF  30AF: ff364c2e         push word ptr [0x2e4c]
  05DA03  30B3: eb05             jmp 0x30ba
  05DA05  30B5: 90               nop 
  05DA06  30B6: ff364e2e         push word ptr [0x2e4e]
  05DA0A  30BA: 6a04             push 4
  05DA0C  30BC: 9a38041f18       lcall 0x181f, 0x438
  05DA11  30C1: 83c404           add sp, 4
  05DA14  30C4: 6a04             push 4
  05DA16  30C6: 9aac041f18       lcall 0x181f, 0x4ac
  05DA1B  30CB: 83c402           add sp, 2
  05DA1E  30CE: 6a01             push 1
  05DA20  30D0: 681d1c           push 0x1c1d
  05DA23  30D3: 9a52061f18       lcall 0x181f, 0x652
  05DA28  30D8: 83c404           add sp, 4
  05DA2B  30DB: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05DA30  30E0: 7d0e             jge 0x30f0
  05DA32  30E2: 837e8a04         cmp word ptr [bp - 0x76], 4
  05DA36  30E6: 7d08             jge 0x30f0
  05DA38  30E8: c7469c0100       mov word ptr [bp - 0x64], 1
  05DA3D  30ED: eb06             jmp 0x30f5
  05DA3F  30EF: 90               nop 
  05DA40  30F0: c7469c0000       mov word ptr [bp - 0x64], 0
  05DA45  30F5: 837e9c00         cmp word ptr [bp - 0x64], 0
  05DA49  30F9: 7503             jne 0x30fe
  05DA4B  30FB: e9c604           jmp 0x35c4
  05DA4E  30FE: 83be28ff00       cmp word ptr [bp - 0xd8], 0
  05DA53  3103: 740d             je 0x3112
  05DA55  3105: 837ef600         cmp word ptr [bp - 0xa], 0
  05DA59  3109: 7507             jne 0x3112
  05DA5B  310B: c746980100       mov word ptr [bp - 0x68], 1
  05DA60  3110: eb05             jmp 0x3117
  05DA62  3112: c746980000       mov word ptr [bp - 0x68], 0
  05DA67  3117: 83be7cff00       cmp word ptr [bp - 0x84], 0
  05DA6C  311C: 7416             je 0x3134
  05DA6E  311E: 83be76ff00       cmp word ptr [bp - 0x8a], 0
  05DA73  3123: 740f             je 0x3134
  05DA75  3125: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05DA7A  312A: 7408             je 0x3134
  05DA7C  312C: c7469a0100       mov word ptr [bp - 0x66], 1
  05DA81  3131: eb06             jmp 0x3139
  05DA83  3133: 90               nop 
  05DA84  3134: c7469a0000       mov word ptr [bp - 0x66], 0
  05DA89  3139: 837ef600         cmp word ptr [bp - 0xa], 0
  05DA8D  313D: 7503             jne 0x3142
  05DA8F  313F: e98b00           jmp 0x31cd
  05DA92  3142: ffb67aff         push word ptr [bp - 0x86]
  05DA96  3146: 9a1a0a1f18       lcall 0x181f, 0xa1a
  05DA9B  314B: 83c402           add sp, 2
  05DA9E  314E: 50               push ax
  05DA9F  314F: 6a00             push 0
  05DAA1  3151: 9a38041f18       lcall 0x181f, 0x438
  05DAA6  3156: 83c404           add sp, 4
  05DAA9  3159: ff768a           push word ptr [bp - 0x76]
  05DAAC  315C: 9a1a0a1f18       lcall 0x181f, 0xa1a
  05DAB1  3161: 83c402           add sp, 2
  05DAB4  3164: 50               push ax
  05DAB5  3165: 6a01             push 1
  05DAB7  3167: 9a38041f18       lcall 0x181f, 0x438
  05DABC  316C: 83c404           add sp, 4
  05DABF  316F: 837e8a04         cmp word ptr [bp - 0x76], 4
  05DAC3  3173: 7d27             jge 0x319c
  05DAC5  3175: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05DAC9  3179: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05DACE  317E: 751c             jne 0x319c
  05DAD0  3180: 6a01             push 1
  05DAD2  3182: 9aac041f18       lcall 0x181f, 0x4ac
  05DAD7  3187: 83c402           add sp, 2
  05DADA  318A: 6a0b             push 0xb
  05DADC  318C: 9a24051f18       lcall 0x181f, 0x524
  05DAE1  3191: 83c402           add sp, 2
  05DAE4  3194: 6a01             push 1
  05DAE6  3196: 68281c           push 0x1c28
  05DAE9  3199: eb2a             jmp 0x31c5
  05DAEB  319B: 90               nop 
  05DAEC  319C: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05DAF1  31A1: 7d1d             jge 0x31c0
  05DAF3  31A3: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05DAF8  31A8: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05DAFD  31AD: 7511             jne 0x31c0
  05DAFF  31AF: 6a04             push 4
  05DB01  31B1: 9aac041f18       lcall 0x181f, 0x4ac
  05DB06  31B6: 83c402           add sp, 2
  05DB09  31B9: 6a01             push 1
  05DB0B  31BB: 682f1c           push 0x1c2f
  05DB0E  31BE: eb05             jmp 0x31c5
  05DB10  31C0: 6a02             push 2
  05DB12  31C2: 68371c           push 0x1c37
  05DB15  31C5: 9a52061f18       lcall 0x181f, 0x652
  05DB1A  31CA: 83c404           add sp, 4
  05DB1D  31CD: 837e9800         cmp word ptr [bp - 0x68], 0
  05DB21  31D1: 7509             jne 0x31dc
  05DB23  31D3: 837e9a00         cmp word ptr [bp - 0x66], 0
  05DB27  31D7: 7503             jne 0x31dc
  05DB29  31D9: e96202           jmp 0x343e
  05DB2C  31DC: ff7606           push word ptr [bp + 6]
  05DB2F  31DF: 9a16091f18       lcall 0x181f, 0x916
  05DB34  31E4: 83c402           add sp, 2
  05DB37  31E7: ff7606           push word ptr [bp + 6]
  05DB3A  31EA: 9ac6081f18       lcall 0x181f, 0x8c6
  05DB3F  31EF: 83c402           add sp, 2
  05DB42  31F2: ff760a           push word ptr [bp + 0xa]
  05DB45  31F5: ff7608           push word ptr [bp + 8]
  05DB48  31F8: ff760c           push word ptr [bp + 0xc]
  05DB4B  31FB: ff7606           push word ptr [bp + 6]
  05DB4E  31FE: 8b4608           mov ax, word ptr [bp + 8]
  05DB51  3201: 8b560a           mov dx, word ptr [bp + 0xa]
  05DB54  3204: 9ae0071f18       lcall 0x181f, 0x7e0
  05DB59  3209: 89863eff         mov word ptr [bp - 0xc2], ax
  05DB5D  320D: 50               push ax
  05DB5E  320E: 0e               push cs
  05DB5F  320F: e8cb0b           call 0x3ddd
  05DB62  3212: 83c40a           add sp, 0xa
  05DB65  3215: b8feff           mov ax, 0xfffe
  05DB68  3218: 8bd0             mov dx, ax
  05DB6A  321A: 9ae0071f18       lcall 0x181f, 0x7e0
  05DB6F  321F: 894606           mov word ptr [bp + 6], ax
  05DB72  3222: 9a8e091f18       lcall 0x181f, 0x98e
  05DB77  3227: 894606           mov word ptr [bp + 6], ax
  05DB7A  322A: 837e0c00         cmp word ptr [bp + 0xc], 0
  05DB7E  322E: 744c             je 0x327c
  05DB80  3230: f606825301       test byte ptr [0x5382], 1
  05DB85  3235: 740a             je 0x3241
  05DB87  3237: 6a03             push 3
  05DB89  3239: 9aac041f18       lcall 0x181f, 0x4ac
  05DB8E  323E: 83c402           add sp, 2
  05DB91  3241: c7863cffc000     mov word ptr [bp - 0xc4], 0xc0
  05DB97  3247: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05DB9B  324B: 8a874731         mov al, byte ptr [bx + 0x3147]
  05DB9F  324F: 240f             and al, 0xf
  05DBA1  3251: 3a069653         cmp al, byte ptr [0x5396]
  05DBA5  3255: 7406             je 0x325d
  05DBA7  3257: c7863cffe000     mov word ptr [bp - 0xc4], 0xe0
  05DBAD  325D: ff760a           push word ptr [bp + 0xa]
  05DBB0  3260: ff7608           push word ptr [bp + 8]
  05DBB3  3263: ffb644ff         push word ptr [bp - 0xbc]
  05DBB7  3267: ffb64cff         push word ptr [bp - 0xb4]
  05DBBB  326B: 6aff             push -1
  05DBBD  326D: ffb63cff         push word ptr [bp - 0xc4]
  05DBC1  3271: ff7606           push word ptr [bp + 6]
  05DBC4  3274: 9ad0021f18       lcall 0x181f, 0x2d0
  05DBC9  3279: 83c40e           add sp, 0xe
  05DBCC  327C: ff760a           push word ptr [bp + 0xa]
  05DBCF  327F: ff7608           push word ptr [bp + 8]
  05DBD2  3282: ff7606           push word ptr [bp + 6]
  05DBD5  3285: 9a48091f18       lcall 0x181f, 0x948
  05DBDA  328A: 83c406           add sp, 6
  05DBDD  328D: ffb67aff         push word ptr [bp - 0x86]
  05DBE1  3291: ff760a           push word ptr [bp + 0xa]
  05DBE4  3294: ff7608           push word ptr [bp + 8]
  05DBE7  3297: 9a04071f18       lcall 0x181f, 0x704
  05DBEC  329C: 83c406           add sp, 6
  05DBEF  329F: 837e9800         cmp word ptr [bp - 0x68], 0
  05DBF3  32A3: 7503             jne 0x32a8
  05DBF5  32A5: e97801           jmp 0x3420
  05DBF8  32A8: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05DBFD  32AD: 7d11             jge 0x32c0
  05DBFF  32AF: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05DC04  32B4: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05DC09  32B9: 7505             jne 0x32c0
  05DC0B  32BB: 6a04             push 4
  05DC0D  32BD: eb14             jmp 0x32d3
  05DC0F  32BF: 90               nop 
  05DC10  32C0: 837e8a04         cmp word ptr [bp - 0x76], 4
  05DC14  32C4: 7d15             jge 0x32db
  05DC16  32C6: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05DC1A  32CA: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05DC1F  32CF: 750a             jne 0x32db
  05DC21  32D1: 6a01             push 1
  05DC23  32D3: 9aac041f18       lcall 0x181f, 0x4ac
  05DC28  32D8: 83c402           add sp, 2
  05DC2B  32DB: f606825301       test byte ptr [0x5382], 1
  05DC30  32E0: 7430             je 0x3312
  05DC32  32E2: a1d253           mov ax, word ptr [0x53d2]
  05DC35  32E5: 39867aff         cmp word ptr [bp - 0x86], ax
  05DC39  32E9: 7505             jne 0x32f0
  05DC3B  32EB: 800e825340       or byte ptr [0x5382], 0x40
  05DC40  32F0: a19853           mov ax, word ptr [0x5398]
  05DC43  32F3: 39867aff         cmp word ptr [bp - 0x86], ax
  05DC47  32F7: 7519             jne 0x3312
  05DC49  32F9: f606865301       test byte ptr [0x5386], 1
  05DC4E  32FE: 7512             jne 0x3312
  05DC50  3300: 800e865301       or byte ptr [0x5386], 1
  05DC55  3305: 6a01             push 1
  05DC57  3307: 683f1c           push 0x1c3f
  05DC5A  330A: 9a52061f18       lcall 0x181f, 0x652
  05DC5F  330F: 83c404           add sp, 4
  05DC62  3312: 8b1e4285         mov bx, word ptr [0x8542]
  05DC66  3316: 8a5f1a           mov bl, byte ptr [bx + 0x1a]
  05DC69  3319: 2aff             sub bh, bh
  05DC6B  331B: fe8f9892         dec byte ptr [bx - 0x6d68]
  05DC6F  331F: 8b364285         mov si, word ptr [0x8542]
  05DC73  3323: 8a441f           mov al, byte ptr [si + 0x1f]
  05DC76  3326: 28870c94         sub byte ptr [bx - 0x6bf4], al
  05DC7A  332A: 8a8e7aff         mov cl, byte ptr [bp - 0x86]
  05DC7E  332E: 884c1a           mov byte ptr [si + 0x1a], cl
  05DC81  3331: 8ad9             mov bl, cl
  05DC83  3333: fe879892         inc byte ptr [bx - 0x6d68]
  05DC87  3337: 00870c94         add byte ptr [bx - 0x6bf4], al
  05DC8B  333B: 6a00             push 0
  05DC8D  333D: 6a03             push 3
  05DC8F  333F: 8b84c200         mov ax, word ptr [si + 0xc2]
  05DC93  3343: 8b94c400         mov dx, word ptr [si + 0xc4]
  05DC97  3347: d1e0             shl ax, 1
  05DC99  3349: d1d2             rcl dx, 1
  05DC9B  334B: 52               push dx
  05DC9C  334C: 50               push ax
  05DC9D  334D: 9ac60e1d0d       lcall 0xd1d, 0xec6
  05DCA2  3352: 8984c200         mov word ptr [si + 0xc2], ax
  05DCA6  3356: 8994c400         mov word ptr [si + 0xc4], dx
  05DCAA  335A: c746800000       mov word ptr [bp - 0x80], 0
  05DCAF  335F: 8b5e80           mov bx, word ptr [bp - 0x80]
  05DCB2  3362: 8a87be00         mov al, byte ptr [bx + 0xbe]
  05DCB6  3366: 98               cwde 
  05DCB7  3367: 03460a           add ax, word ptr [bp + 0xa]
  05DCBA  336A: 898642ff         mov word ptr [bp - 0xbe], ax
  05DCBE  336E: 50               push ax
  05DCBF  336F: 8a87b400         mov al, byte ptr [bx + 0xb4]
  05DCC3  3373: 98               cwde 
  05DCC4  3374: 034608           add ax, word ptr [bp + 8]
  05DCC7  3377: 89864aff         mov word ptr [bp - 0xb6], ax
  05DCCB  337B: 50               push ax
  05DCCC  337C: 9ad2061f18       lcall 0x181f, 0x6d2
  05DCD1  3381: 83c404           add sp, 4
  05DCD4  3384: 0bc0             or ax, ax
  05DCD6  3386: 7d14             jge 0x339c
  05DCD8  3388: ffb67aff         push word ptr [bp - 0x86]
  05DCDC  338C: ffb642ff         push word ptr [bp - 0xbe]
  05DCE0  3390: ffb64aff         push word ptr [bp - 0xb6]
  05DCE4  3394: 9a04071f18       lcall 0x181f, 0x704
  05DCE9  3399: 83c406           add sp, 6
  05DCEC  339C: ff4680           inc word ptr [bp - 0x80]
  05DCEF  339F: 837e8008         cmp word ptr [bp - 0x80], 8
  05DCF3  33A3: 7cba             jl 0x335f
  05DCF5  33A5: f606825301       test byte ptr [0x5382], 1
  05DCFA  33AA: 7474             je 0x3420
  05DCFC  33AC: a1d253           mov ax, word ptr [0x53d2]
  05DCFF  33AF: 39867aff         cmp word ptr [bp - 0x86], ax
  05DD03  33B3: 756b             jne 0x3420
  05DD05  33B5: c746800000       mov word ptr [bp - 0x80], 0
  05DD0A  33BA: eb03             jmp 0x33bf
  05DD0C  33BC: ff4680           inc word ptr [bp - 0x80]
  05DD0F  33BF: 837e8008         cmp word ptr [bp - 0x80], 8
  05DD13  33C3: 7d5b             jge 0x3420
  05DD15  33C5: 8b5e80           mov bx, word ptr [bp - 0x80]
  05DD18  33C8: 8a87be00         mov al, byte ptr [bx + 0xbe]
  05DD1C  33CC: 98               cwde 
  05DD1D  33CD: 03460a           add ax, word ptr [bp + 0xa]
  05DD20  33D0: 898642ff         mov word ptr [bp - 0xbe], ax
  05DD24  33D4: 8bd0             mov dx, ax
  05DD26  33D6: 8a87b400         mov al, byte ptr [bx + 0xb4]
  05DD2A  33DA: 98               cwde 
  05DD2B  33DB: 034608           add ax, word ptr [bp + 8]
  05DD2E  33DE: 89864aff         mov word ptr [bp - 0xb6], ax
  05DD32  33E2: 9ae0071f18       lcall 0x181f, 0x7e0
  05DD37  33E7: 89863eff         mov word ptr [bp - 0xc2], ax
  05DD3B  33EB: 0bc0             or ax, ax
  05DD3D  33ED: 7ccd             jl 0x33bc
  05DD3F  33EF: 6bd81c           imul bx, ax, 0x1c
  05DD42  33F2: 8a874731         mov al, byte ptr [bx + 0x3147]
  05DD46  33F6: 240f             and al, 0xf
  05DD48  33F8: 3a867aff         cmp al, byte ptr [bp - 0x86]
  05DD4C  33FC: 75be             jne 0x33bc
  05DD4E  33FE: 83be3eff00       cmp word ptr [bp - 0xc2], 0
  05DD53  3403: 7eb7             jle 0x33bc
  05DD55  3405: a0c68d           mov al, byte ptr [0x8dc6]
  05DD58  3408: 6b9e3eff1c       imul bx, word ptr [bp - 0xc2], 0x1c
  05DD5D  340D: 88874a31         mov byte ptr [bx + 0x314a], al
  05DD61  3411: 8b863eff         mov ax, word ptr [bp - 0xc2]
  05DD65  3415: 9ae4021f18       lcall 0x181f, 0x2e4
  05DD6A  341A: 89863eff         mov word ptr [bp - 0xc2], ax
  05DD6E  341E: ebde             jmp 0x33fe
  05DD70  3420: 837e0c00         cmp word ptr [bp + 0xc], 0
  05DD74  3424: 7418             je 0x343e
  05DD76  3426: 6a01             push 1
  05DD78  3428: ff7688           push word ptr [bp - 0x78]
  05DD7B  342B: ff7694           push word ptr [bp - 0x6c]
  05DD7E  342E: ffb646ff         push word ptr [bp - 0xba]
  05DD82  3432: ffb64eff         push word ptr [bp - 0xb2]
  05DD86  3436: 9aba091f18       lcall 0x181f, 0x9ba
  05DD8B  343B: 83c40a           add sp, 0xa
  05DD8E  343E: 837e9800         cmp word ptr [bp - 0x68], 0
  05DD92  3442: 7503             jne 0x3447
  05DD94  3444: e97d01           jmp 0x35c4
  05DD97  3447: 837e0c00         cmp word ptr [bp + 0xc], 0
  05DD9B  344B: 7503             jne 0x3450
  05DD9D  344D: e97401           jmp 0x35c4
  05DDA0  3450: ffb67aff         push word ptr [bp - 0x86]
  05DDA4  3454: 9a1a0a1f18       lcall 0x181f, 0xa1a
  05DDA9  3459: 83c402           add sp, 2
  05DDAC  345C: 50               push ax
  05DDAD  345D: 6a00             push 0
  05DDAF  345F: 9a38041f18       lcall 0x181f, 0x438
  05DDB4  3464: 83c404           add sp, 4
  05DDB7  3467: a14285           mov ax, word ptr [0x8542]
  05DDBA  346A: 40               inc ax
  05DDBB  346B: 40               inc ax
  05DDBC  346C: 1e               push ds
  05DDBD  346D: 50               push ax
  05DDBE  346E: 6a02             push 2
  05DDC0  3470: 9a16041f18       lcall 0x181f, 0x416
  05DDC5  3475: 83c406           add sp, 6
  05DDC8  3478: 8b1e4285         mov bx, word ptr [0x8542]
  05DDCC  347C: 8a471f           mov al, byte ptr [bx + 0x1f]
  05DDCF  347F: 98               cwde 
  05DDD0  3480: 89867eff         mov word ptr [bp - 0x82], ax
  05DDD4  3484: c7866cff0000     mov word ptr [bp - 0x94], 0
  05DDDA  348A: eb1c             jmp 0x34a8
  05DDDC  348C: 8a468a           mov al, byte ptr [bp - 0x76]
  05DDDF  348F: 699e6cffca00     imul bx, word ptr [bp - 0x94], 0xca
  05DDE5  3495: 3887605d         cmp byte ptr [bx + 0x5d60], al
  05DDE9  3499: 7509             jne 0x34a4
  05DDEB  349B: 8a87655d         mov al, byte ptr [bx + 0x5d65]
  05DDEF  349F: 98               cwde 
  05DDF0  34A0: 01867eff         add word ptr [bp - 0x82], ax
  05DDF4  34A4: ff866cff         inc word ptr [bp - 0x94]
  05DDF8  34A8: a19e53           mov ax, word ptr [0x539e]
  05DDFB  34AB: 39866cff         cmp word ptr [bp - 0x94], ax
  05DDFF  34AF: 7cdb             jl 0x348c
  05DE01  34B1: 8b867eff         mov ax, word ptr [bp - 0x82]
  05DE05  34B5: 3d0100           cmp ax, 1
  05DE08  34B8: 7d03             jge 0x34bd
  05DE0A  34BA: b80100           mov ax, 1
  05DE0D  34BD: 89867eff         mov word ptr [bp - 0x82], ax
  05DE11  34C1: f606825301       test byte ptr [0x5382], 1
  05DE16  34C6: 755b             jne 0x3523
  05DE18  34C8: 99               cdq 
  05DE19  34C9: 52               push dx
  05DE1A  34CA: 50               push ax
  05DE1B  34CB: 8b1e4285         mov bx, word ptr [0x8542]
  05DE1F  34CF: 8a471f           mov al, byte ptr [bx + 0x1f]
  05DE22  34D2: 98               cwde 
  05DE23  34D3: 99               cdq 
  05DE24  34D4: 52               push dx
  05DE25  34D5: 50               push ax
  05DE26  34D6: 695e8a3c01       imul bx, word ptr [bp - 0x76], 0x13c
  05DE2B  34DB: ffb73488         push word ptr [bx - 0x77cc]
  05DE2F  34DF: ffb73288         push word ptr [bx - 0x77ce]
  05DE33  34E3: 8bf3             mov si, bx
  05DE35  34E5: 9a600f1d0d       lcall 0xd1d, 0xf60
  05DE3A  34EA: 52               push dx
  05DE3B  34EB: 50               push ax
  05DE3C  34EC: 9ac60e1d0d       lcall 0xd1d, 0xec6
  05DE41  34F1: 898660ff         mov word ptr [bp - 0xa0], ax
  05DE45  34F5: 899662ff         mov word ptr [bp - 0x9e], dx
  05DE49  34F9: 29843288         sub word ptr [si - 0x77ce], ax
  05DE4D  34FD: 19943488         sbb word ptr [si - 0x77cc], dx
  05DE51  3501: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  05DE55  3505: 8b9662ff         mov dx, word ptr [bp - 0x9e]
  05DE59  3509: 699e7aff3c01     imul bx, word ptr [bp - 0x86], 0x13c
  05DE5F  350F: 01873288         add word ptr [bx - 0x77ce], ax
  05DE63  3513: 11973488         adc word ptr [bx - 0x77cc], dx
  05DE67  3517: 52               push dx
  05DE68  3518: 50               push ax
  05DE69  3519: 6a00             push 0
  05DE6B  351B: 9aae091f18       lcall 0x181f, 0x9ae
  05DE70  3520: 83c406           add sp, 6
  05DE73  3523: 2bc0             sub ax, ax
  05DE75  3525: 8b9e7aff         mov bx, word ptr [bp - 0x86]
  05DE79  3529: d1e3             shl bx, 1
  05DE7B  352B: 8987c853         mov word ptr [bx + 0x53c8], ax
  05DE7F  352F: 8b5e8a           mov bx, word ptr [bp - 0x76]
  05DE82  3532: d1e3             shl bx, 1
  05DE84  3534: 8987c853         mov word ptr [bx + 0x53c8], ax
  05DE88  3538: 69b67aff3c01     imul si, word ptr [bp - 0x86], 0x13c
  05DE8E  353E: 8b5e8a           mov bx, word ptr [bp - 0x76]
  05DE91  3541: f6803c8802       test byte ptr [bx + si - 0x77c4], 2
  05DE96  3546: 7408             je 0x3550
  05DE98  3548: 80a03c88fd       and byte ptr [bx + si - 0x77c4], 0xfd
  05DE9D  354D: eb0e             jmp 0x355d
  05DE9F  354F: 90               nop 
  05DEA0  3550: 69f33c01         imul si, bx, 0x13c
  05DEA4  3554: 8b9e7aff         mov bx, word ptr [bp - 0x86]
  05DEA8  3558: 80883c8802       or byte ptr [bx + si - 0x77c4], 2
  05DEAD  355D: 837e8a04         cmp word ptr [bp - 0x76], 4
  05DEB1  3561: 7d0b             jge 0x356e
  05DEB3  3563: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05DEB7  3567: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05DEBC  356C: 7413             je 0x3581
  05DEBE  356E: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05DEC3  3573: 7d23             jge 0x3598
  05DEC5  3575: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05DECA  357A: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05DECF  357F: 7517             jne 0x3598
  05DED1  3581: f606825301       test byte ptr [0x5382], 1
  05DED6  3586: 7408             je 0x3590
  05DED8  3588: 6a01             push 1
  05DEDA  358A: 68481c           push 0x1c48
  05DEDD  358D: eb0e             jmp 0x359d
  05DEDF  358F: 90               nop 
  05DEE0  3590: 6a01             push 1
  05DEE2  3592: 68521c           push 0x1c52
  05DEE5  3595: eb06             jmp 0x359d
  05DEE7  3597: 90               nop 
  05DEE8  3598: 6a02             push 2
  05DEEA  359A: 685b1c           push 0x1c5b
  05DEED  359D: 9a52061f18       lcall 0x181f, 0x652
  05DEF2  35A2: 83c404           add sp, 4
  05DEF5  35A5: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05DEFA  35AA: 7d18             jge 0x35c4
  05DEFC  35AC: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05DF01  35B1: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05DF06  35B6: 750c             jne 0x35c4
  05DF08  35B8: ffb62aff         push word ptr [bp - 0xd6]
  05DF0C  35BC: 9a08061f18       lcall 0x181f, 0x608
  05DF11  35C1: 83c402           add sp, 2
  05DF14  35C4: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05DF19  35C9: 7d03             jge 0x35ce
  05DF1B  35CB: e99302           jmp 0x3861
  05DF1E  35CE: 837e8a04         cmp word ptr [bp - 0x76], 4
  05DF22  35D2: 7c03             jl 0x35d7
  05DF24  35D4: e98a02           jmp 0x3861
  05DF27  35D7: 8b867aff         mov ax, word ptr [bp - 0x86]
  05DF2B  35DB: 2d0400           sub ax, 4
  05DF2E  35DE: 50               push ax
  05DF2F  35DF: 9a420a1f18       lcall 0x181f, 0xa42
  05DF34  35E4: 83c402           add sp, 2
  05DF37  35E7: 837ef200         cmp word ptr [bp - 0xe], 0
  05DF3B  35EB: 7c2b             jl 0x3618
  05DF3D  35ED: 833eb88d00       cmp word ptr [0x8db8], 0
  05DF42  35F2: 7524             jne 0x3618
  05DF44  35F4: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05DF49  35F9: 751d             jne 0x3618
  05DF4B  35FB: ffb666ff         push word ptr [bp - 0x9a]
  05DF4F  35FF: ffb638ff         push word ptr [bp - 0xc8]
  05DF53  3603: ff76f8           push word ptr [bp - 8]
  05DF56  3606: ff76f2           push word ptr [bp - 0xe]
  05DF59  3609: ffb67aff         push word ptr [bp - 0x86]
  05DF5D  360D: 0e               push cs
  05DF5E  360E: e8b807           call 0x3dc9
  05DF61  3611: 83c40a           add sp, 0xa
  05DF64  3614: e94a02           jmp 0x3861
  05DF67  3617: 90               nop 
  05DF68  3618: 2bc0             sub ax, ax
  05DF6A  361A: 89865cff         mov word ptr [bp - 0xa4], ax
  05DF6E  361E: 8b5ef8           mov bx, word ptr [bp - 8]
  05DF71  3621: 8bcb             mov cx, bx
  05DF73  3623: c1e303           shl bx, 3
  05DF76  3626: 03d9             add bx, cx
  05DF78  3628: 035e8a           add bx, word ptr [bp - 0x76]
  05DF7B  362B: d1e3             shl bx, 1
  05DF7D  362D: 8987f654         mov word ptr [bx + 0x54f6], ax
  05DF81  3631: 394692           cmp word ptr [bp - 0x6e], ax
  05DF84  3634: 7503             jne 0x3639
  05DF86  3636: e9d900           jmp 0x3712
  05DF89  3639: ffb654ff         push word ptr [bp - 0xac]
  05DF8D  363D: 9a180c1f18       lcall 0x181f, 0xc18
  05DF92  3642: 83c402           add sp, 2
  05DF95  3645: 50               push ax
  05DF96  3646: 6a02             push 2
  05DF98  3648: 9a38041f18       lcall 0x181f, 0x438
  05DF9D  364D: 83c404           add sp, 4
  05DFA0  3650: 837ef600         cmp word ptr [bp - 0xa], 0
  05DFA4  3654: 745c             je 0x36b2
  05DFA6  3656: 837e8a04         cmp word ptr [bp - 0x76], 4
  05DFAA  365A: 7d27             jge 0x3683
  05DFAC  365C: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05DFB0  3660: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05DFB5  3665: 751c             jne 0x3683
  05DFB7  3667: b85300           mov ax, 0x53
  05DFBA  366A: 9ac0041f18       lcall 0x181f, 0x4c0
  05DFBF  366F: 6a32             push 0x32
  05DFC1  3671: 9a8e041f18       lcall 0x181f, 0x48e
  05DFC6  3676: 83c402           add sp, 2
  05DFC9  3679: 6a0b             push 0xb
  05DFCB  367B: 9a24051f18       lcall 0x181f, 0x524
  05DFD0  3680: 83c402           add sp, 2
  05DFD3  3683: 837e8a04         cmp word ptr [bp - 0x76], 4
  05DFD7  3687: 7d13             jge 0x369c
  05DFD9  3689: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05DFDD  368D: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05DFE2  3692: 7508             jne 0x369c
  05DFE4  3694: 6a01             push 1
  05DFE6  3696: 68651c           push 0x1c65
  05DFE9  3699: eb06             jmp 0x36a1
  05DFEB  369B: 90               nop 
  05DFEC  369C: 6a03             push 3
  05DFEE  369E: 68761c           push 0x1c76
  05DFF1  36A1: 9a52061f18       lcall 0x181f, 0x652
  05DFF6  36A6: 83c404           add sp, 4
  05DFF9  36A9: c7865cffceff     mov word ptr [bp - 0xa4], 0xffce
  05DFFF  36AF: e98001           jmp 0x3832
  05E002  36B2: 837e8a04         cmp word ptr [bp - 0x76], 4
  05E006  36B6: 7d1c             jge 0x36d4
  05E008  36B8: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05E00C  36BC: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05E011  36C1: 7511             jne 0x36d4
  05E013  36C3: 6a32             push 0x32
  05E015  36C5: 9a8e041f18       lcall 0x181f, 0x48e
  05E01A  36CA: 83c402           add sp, 2
  05E01D  36CD: 6a01             push 1
  05E01F  36CF: 68881c           push 0x1c88
  05E022  36D2: eb05             jmp 0x36d9
  05E024  36D4: 6a03             push 3
  05E026  36D6: 68981c           push 0x1c98
  05E029  36D9: 9a52061f18       lcall 0x181f, 0x652
  05E02E  36DE: 83c404           add sp, 4
  05E031  36E1: 837e8a04         cmp word ptr [bp - 0x76], 4
  05E035  36E5: 7d17             jge 0x36fe
  05E037  36E7: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05E03B  36EB: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05E040  36F0: 750c             jne 0x36fe
  05E042  36F2: a0a653           mov al, byte ptr [0x53a6]
  05E045  36F5: 2ae4             sub ah, ah
  05E047  36F7: 898622ff         mov word ptr [bp - 0xde], ax
  05E04B  36FB: eb07             jmp 0x3704
  05E04D  36FD: 90               nop 
  05E04E  36FE: c78622ff0000     mov word ptr [bp - 0xde], 0
  05E054  3704: 8b8622ff         mov ax, word ptr [bp - 0xde]
  05E058  3708: 2d0a00           sub ax, 0xa
  05E05B  370B: 89865cff         mov word ptr [bp - 0xa4], ax
  05E05F  370F: e92001           jmp 0x3832
  05E062  3712: 394692           cmp word ptr [bp - 0x6e], ax
  05E065  3715: 740f             je 0x3726
  05E067  3717: ffb654ff         push word ptr [bp - 0xac]
  05E06B  371B: 9a180c1f18       lcall 0x181f, 0xc18
  05E070  3720: 83c402           add sp, 2
  05E073  3723: 50               push ax
  05E074  3724: eb14             jmp 0x373a
  05E076  3726: 8b9e74ff         mov bx, word ptr [bp - 0x8c]
  05E07A  372A: 8bc3             mov ax, bx
  05E07C  372C: d1e3             shl bx, 1
  05E07E  372E: 03d8             add bx, ax
  05E080  3730: d1e3             shl bx, 1
  05E082  3732: 03d8             add bx, ax
  05E084  3734: d1e3             shl bx, 1
  05E086  3736: ffb73052         push word ptr [bx + 0x5230]
  05E08A  373A: 6a02             push 2
  05E08C  373C: 9a38041f18       lcall 0x181f, 0x438
  05E091  3741: 83c404           add sp, 4
  05E094  3744: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05E099  3749: 7503             jne 0x374e
  05E09B  374B: e9a000           jmp 0x37ee
  05E09E  374E: 68a91c           push 0x1ca9
  05E0A1  3751: 8d46a2           lea ax, [bp - 0x5e]
  05E0A4  3754: 50               push ax
  05E0A5  3755: 9ae4071d0d       lcall 0xd1d, 0x7e4
  05E0AA  375A: 83c404           add sp, 4
  05E0AD  375D: 83be56ff00       cmp word ptr [bp - 0xaa], 0
  05E0B2  3762: 7404             je 0x3768
  05E0B4  3764: c646ab31         mov byte ptr [bp - 0x55], 0x31
  05E0B8  3768: 837e9000         cmp word ptr [bp - 0x70], 0
  05E0BC  376C: 7404             je 0x3772
  05E0BE  376E: c646ab32         mov byte ptr [bp - 0x55], 0x32
  05E0C2  3772: 83be56ff00       cmp word ptr [bp - 0xaa], 0
  05E0C7  3777: 7506             jne 0x377f
  05E0C9  3779: 837e9000         cmp word ptr [bp - 0x70], 0
  05E0CD  377D: 7417             je 0x3796
  05E0CF  377F: ffb67aff         push word ptr [bp - 0x86]
  05E0D3  3783: 9aa4091f18       lcall 0x181f, 0x9a4
  05E0D8  3788: 83c402           add sp, 2
  05E0DB  378B: 50               push ax
  05E0DC  378C: 6a04             push 4
  05E0DE  378E: 9a38041f18       lcall 0x181f, 0x438
  05E0E3  3793: 83c404           add sp, 4
  05E0E6  3796: 837e8a04         cmp word ptr [bp - 0x76], 4
  05E0EA  379A: 7d23             jge 0x37bf
  05E0EC  379C: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05E0F0  37A0: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05E0F5  37A5: 7518             jne 0x37bf
  05E0F7  37A7: 6a32             push 0x32
  05E0F9  37A9: 9a8e041f18       lcall 0x181f, 0x48e
  05E0FE  37AE: 83c402           add sp, 2
  05E101  37B1: 6a01             push 1
  05E103  37B3: 8d46a2           lea ax, [bp - 0x5e]
  05E106  37B6: 50               push ax
  05E107  37B7: 9a52061f18       lcall 0x181f, 0x652
  05E10C  37BC: 83c404           add sp, 4
  05E10F  37BF: 837e8a04         cmp word ptr [bp - 0x76], 4
  05E113  37C3: 7d19             jge 0x37de
  05E115  37C5: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05E119  37C9: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05E11E  37CE: 750e             jne 0x37de
  05E120  37D0: a0a653           mov al, byte ptr [0x53a6]
  05E123  37D3: d0e8             shr al, 1
  05E125  37D5: 2ae4             sub ah, ah
  05E127  37D7: 898622ff         mov word ptr [bp - 0xde], ax
  05E12B  37DB: eb07             jmp 0x37e4
  05E12D  37DD: 90               nop 
  05E12E  37DE: c78622ff0000     mov word ptr [bp - 0xde], 0
  05E134  37E4: 8b8622ff         mov ax, word ptr [bp - 0xde]
  05E138  37E8: 2d0500           sub ax, 5
  05E13B  37EB: e91dff           jmp 0x370b
  05E13E  37EE: 83be74ff07       cmp word ptr [bp - 0x8c], 7
  05E143  37F3: 7d07             jge 0x37fc
  05E145  37F5: ff364c2e         push word ptr [0x2e4c]
  05E149  37F9: eb05             jmp 0x3800
  05E14B  37FB: 90               nop 
  05E14C  37FC: ff364e2e         push word ptr [0x2e4e]
  05E150  3800: 6a04             push 4
  05E152  3802: 9a38041f18       lcall 0x181f, 0x438
  05E157  3807: 83c404           add sp, 4
  05E15A  380A: 837e8a04         cmp word ptr [bp - 0x76], 4
  05E15E  380E: 7d22             jge 0x3832
  05E160  3810: 6b5e8a34         imul bx, word ptr [bp - 0x76], 0x34
  05E164  3814: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05E169  3819: 7517             jne 0x3832
  05E16B  381B: 6a04             push 4
  05E16D  381D: 9aac041f18       lcall 0x181f, 0x4ac
  05E172  3822: 83c402           add sp, 2
  05E175  3825: 6a01             push 1
  05E177  3827: 68b41c           push 0x1cb4
  05E17A  382A: 9a52061f18       lcall 0x181f, 0x652
  05E17F  382F: 83c404           add sp, 4
  05E182  3832: 83be5cff00       cmp word ptr [bp - 0xa4], 0
  05E187  3837: 7428             je 0x3861
  05E189  3839: ff768a           push word ptr [bp - 0x76]
  05E18C  383C: ff36508d         push word ptr [0x8d50]
  05E190  3840: 9a380a1f18       lcall 0x181f, 0xa38
  05E195  3845: 83c404           add sp, 4
  05E198  3848: a802             test al, 2
  05E19A  384A: 7515             jne 0x3861
  05E19C  384C: 6a00             push 0
  05E19E  384E: ffb65cff         push word ptr [bp - 0xa4]
  05E1A2  3852: ff768a           push word ptr [bp - 0x76]
  05E1A5  3855: ff36528d         push word ptr [0x8d52]
  05E1A9  3859: 9a6c0d1f18       lcall 0x181f, 0xd6c
  05E1AE  385E: 83c408           add sp, 8
  05E1B1  3861: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05E1B6  3866: 7c03             jl 0x386b
  05E1B8  3868: e94b05           jmp 0x3db6
  05E1BB  386B: 837e8a04         cmp word ptr [bp - 0x76], 4
  05E1BF  386F: 7d03             jge 0x3874
  05E1C1  3871: e94205           jmp 0x3db6
  05E1C4  3874: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  05E1C9  3879: 7503             jne 0x387e
  05E1CB  387B: e93805           jmp 0x3db6
  05E1CE  387E: 837e9200         cmp word ptr [bp - 0x6e], 0
  05E1D2  3882: 7503             jne 0x3887
  05E1D4  3884: e91e01           jmp 0x39a5
  05E1D7  3887: 837ea000         cmp word ptr [bp - 0x60], 0
  05E1DB  388B: 7d03             jge 0x3890
  05E1DD  388D: e91501           jmp 0x39a5
  05E1E0  3890: 8a46a0           mov al, byte ptr [bp - 0x60]
  05E1E3  3893: 250f00           and ax, 0xf
  05E1E6  3896: 3b867aff         cmp ax, word ptr [bp - 0x86]
  05E1EA  389A: 7403             je 0x389f
  05E1EC  389C: e90601           jmp 0x39a5
  05E1EF  389F: c7469e0400       mov word ptr [bp - 0x62], 4
  05E1F4  38A4: f646a010         test byte ptr [bp - 0x60], 0x10
  05E1F8  38A8: 7405             je 0x38af
  05E1FA  38AA: c7469e0800       mov word ptr [bp - 0x62], 8
  05E1FF  38AF: 3d0200           cmp ax, 2
  05E202  38B2: 7504             jne 0x38b8
  05E204  38B4: 83469e04         add word ptr [bp - 0x62], 4
  05E208  38B8: 6a17             push 0x17
  05E20A  38BA: 50               push ax
  05E20B  38BB: 9ab4071f18       lcall 0x181f, 0x7b4
  05E210  38C0: 83c404           add sp, 4
  05E213  38C3: 0bc0             or ax, ax
  05E215  38C5: 7404             je 0x38cb
  05E217  38C7: 83469e04         add word ptr [bp - 0x62], 4
  05E21B  38CB: 6a18             push 0x18
  05E21D  38CD: ffb67aff         push word ptr [bp - 0x86]
  05E221  38D1: 9ab4071f18       lcall 0x181f, 0x7b4
  05E226  38D6: 83c404           add sp, 4
  05E229  38D9: 0bc0             or ax, ax
  05E22B  38DB: 7404             je 0x38e1
  05E22D  38DD: 836e9e04         sub word ptr [bp - 0x62], 4
  05E231  38E1: 6a0c             push 0xc
  05E233  38E3: 6a00             push 0
  05E235  38E5: 9ad4041f18       lcall 0x181f, 0x4d4
  05E23A  38EA: 83c404           add sp, 4
  05E23D  38ED: 3b469e           cmp ax, word ptr [bp - 0x62]
  05E240  38F0: 7d06             jge 0x38f8
  05E242  38F2: b80100           mov ax, 1
  05E245  38F5: eb03             jmp 0x38fa
  05E247  38F7: 90               nop 
  05E248  38F8: 2bc0             sub ax, ax
  05E24A  38FA: 894686           mov word ptr [bp - 0x7a], ax
  05E24D  38FD: 0bc0             or ax, ax
  05E24F  38FF: 7503             jne 0x3904
  05E251  3901: e9a100           jmp 0x39a5
  05E254  3904: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05E259  3909: 7d46             jge 0x3951
  05E25B  390B: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05E260  3910: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05E265  3915: 753a             jne 0x3951
  05E267  3917: ff768a           push word ptr [bp - 0x76]
  05E26A  391A: 9a1a0a1f18       lcall 0x181f, 0xa1a
  05E26F  391F: 83c402           add sp, 2
  05E272  3922: 50               push ax
  05E273  3923: 6a00             push 0
  05E275  3925: 9a38041f18       lcall 0x181f, 0x438
  05E27A  392A: 83c404           add sp, 4
  05E27D  392D: ffb67aff         push word ptr [bp - 0x86]
  05E281  3931: 9aa4091f18       lcall 0x181f, 0x9a4
  05E286  3936: 83c402           add sp, 2
  05E289  3939: 50               push ax
  05E28A  393A: 6a01             push 1
  05E28C  393C: 9a38041f18       lcall 0x181f, 0x438
  05E291  3941: 83c404           add sp, 4
  05E294  3944: 6a01             push 1
  05E296  3946: 68bf1c           push 0x1cbf
  05E299  3949: 9a52061f18       lcall 0x181f, 0x652
  05E29E  394E: 83c404           add sp, 4
  05E2A1  3951: ffb644ff         push word ptr [bp - 0xbc]
  05E2A5  3955: ffb64cff         push word ptr [bp - 0xb4]
  05E2A9  3959: ffb67aff         push word ptr [bp - 0x86]
  05E2AD  395D: 6a00             push 0
  05E2AF  395F: 9a5c091f18       lcall 0x181f, 0x95c
  05E2B4  3964: 83c408           add sp, 8
  05E2B7  3967: 89863eff         mov word ptr [bp - 0xc2], ax
  05E2BB  396B: 0bc0             or ax, ax
  05E2BD  396D: 7c36             jl 0x39a5
  05E2BF  396F: 6bd81c           imul bx, ax, 0x1c
  05E2C2  3972: c6875b311b       mov byte ptr [bx + 0x315b], 0x1b
  05E2C7  3977: 837e0c00         cmp word ptr [bp + 0xc], 0
  05E2CB  397B: 7428             je 0x39a5
  05E2CD  397D: 837ef600         cmp word ptr [bp - 0xa], 0
  05E2D1  3981: 7522             jne 0x39a5
  05E2D3  3983: 6a00             push 0
  05E2D5  3985: ff7688           push word ptr [bp - 0x78]
  05E2D8  3988: ff7694           push word ptr [bp - 0x6c]
  05E2DB  398B: ffb646ff         push word ptr [bp - 0xba]
  05E2DF  398F: ffb64eff         push word ptr [bp - 0xb2]
  05E2E3  3993: 9aba091f18       lcall 0x181f, 0x9ba
  05E2E8  3998: 83c40a           add sp, 0xa
  05E2EB  399B: 6a08             push 8
  05E2ED  399D: 9aea031f18       lcall 0x181f, 0x3ea
  05E2F2  39A2: 83c402           add sp, 2
  05E2F5  39A5: 837ef600         cmp word ptr [bp - 0xa], 0
  05E2F9  39A9: 7503             jne 0x39ae
  05E2FB  39AB: e99c02           jmp 0x3c4a
  05E2FE  39AE: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05E303  39B3: 7d16             jge 0x39cb
  05E305  39B5: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05E30A  39BA: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05E30F  39BF: 750a             jne 0x39cb
  05E311  39C1: 6a04             push 4
  05E313  39C3: 9aac041f18       lcall 0x181f, 0x4ac
  05E318  39C8: 83c402           add sp, 2
  05E31B  39CB: 699e7aff3c01     imul bx, word ptr [bp - 0x86], 0x13c
  05E321  39D1: fe872088         inc byte ptr [bx - 0x77e0]
  05E325  39D5: 8b468a           mov ax, word ptr [bp - 0x76]
  05E328  39D8: 2d0400           sub ax, 4
  05E32B  39DB: 50               push ax
  05E32C  39DC: 9a420a1f18       lcall 0x181f, 0xa42
  05E331  39E1: 83c402           add sp, 2
  05E334  39E4: 6a0a             push 0xa
  05E336  39E6: ffb67aff         push word ptr [bp - 0x86]
  05E33A  39EA: 9ab4071f18       lcall 0x181f, 0x7b4
  05E33F  39EF: 83c404           add sp, 4
  05E342  39F2: 8946fa           mov word ptr [bp - 6], ax
  05E345  39F5: 83be7aff02       cmp word ptr [bp - 0x86], 2
  05E34A  39FA: 7506             jne 0x3a02
  05E34C  39FC: b80100           mov ax, 1
  05E34F  39FF: eb03             jmp 0x3a04
  05E351  3A01: 90               nop 
  05E352  3A02: 2bc0             sub ax, ax
  05E354  3A04: 898658ff         mov word ptr [bp - 0xa8], ax
  05E358  3A08: c78632ff0000     mov word ptr [bp - 0xce], 0
  05E35E  3A0E: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05E362  3A12: 8a4702           mov al, byte ptr [bx + 2]
  05E365  3A15: 2ae4             sub ah, ah
  05E367  3A17: 0bc0             or ax, ax
  05E369  3A19: 7411             je 0x3a2c
  05E36B  3A1B: 48               dec ax
  05E36C  3A1C: 7476             je 0x3a94
  05E36E  3A1E: 48               dec ax
  05E36F  3A1F: 7503             jne 0x3a24
  05E371  3A21: e9a200           jmp 0x3ac6
  05E374  3A24: 48               dec ax
  05E375  3A25: 7503             jne 0x3a2a
  05E377  3A27: e9e000           jmp 0x3b0a
  05E37A  3A2A: eb57             jmp 0x3a83
  05E37C  3A2C: 83be58ff01       cmp word ptr [bp - 0xa8], 1
  05E381  3A31: 1bc0             sbb ax, ax
  05E383  3A33: 250300           and ax, 3
  05E386  3A36: 050300           add ax, 3
  05E389  3A39: 89469e           mov word ptr [bp - 0x62], ax
  05E38C  3A3C: 50               push ax
  05E38D  3A3D: 6a00             push 0
  05E38F  3A3F: 9ad4041f18       lcall 0x181f, 0x4d4
  05E394  3A44: 83c404           add sp, 4
  05E397  3A47: 0bc0             or ax, ax
  05E399  3A49: 740d             je 0x3a58
  05E39B  3A4B: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  05E3A0  3A50: 7506             jne 0x3a58
  05E3A2  3A52: 837efa00         cmp word ptr [bp - 6], 0
  05E3A6  3A56: 7410             je 0x3a68
  05E3A8  3A58: 6a04             push 4
  05E3AA  3A5A: 6a02             push 2
  05E3AC  3A5C: 9ad4041f18       lcall 0x181f, 0x4d4
  05E3B1  3A61: 83c404           add sp, 4
  05E3B4  3A64: 898632ff         mov word ptr [bp - 0xce], ax
  05E3B8  3A68: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  05E3BD  3A6D: 7404             je 0x3a73
  05E3BF  3A6F: d1a632ff         shl word ptr [bp - 0xce], 1
  05E3C3  3A73: 837efa00         cmp word ptr [bp - 6], 0
  05E3C7  3A77: 740a             je 0x3a83
  05E3C9  3A79: 8b8632ff         mov ax, word ptr [bp - 0xce]
  05E3CD  3A7D: d1f8             sar ax, 1
  05E3CF  3A7F: 018632ff         add word ptr [bp - 0xce], ax
  05E3D3  3A83: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  05E3D8  3A88: 7503             jne 0x3a8d
  05E3DA  3A8A: e9bb00           jmp 0x3b48
  05E3DD  3A8D: b80400           mov ax, 4
  05E3E0  3A90: e9be00           jmp 0x3b51
  05E3E3  3A93: 90               nop 
  05E3E4  3A94: 83be58ff01       cmp word ptr [bp - 0xa8], 1
  05E3E9  3A99: 1bc0             sbb ax, ax
  05E3EB  3A9B: 250100           and ax, 1
  05E3EE  3A9E: 40               inc ax
  05E3EF  3A9F: 89469e           mov word ptr [bp - 0x62], ax
  05E3F2  3AA2: 6a02             push 2
  05E3F4  3AA4: 6a00             push 0
  05E3F6  3AA6: 9ad4041f18       lcall 0x181f, 0x4d4
  05E3FB  3AAB: 83c404           add sp, 4
  05E3FE  3AAE: 0bc0             or ax, ax
  05E400  3AB0: 740d             je 0x3abf
  05E402  3AB2: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  05E407  3AB7: 7506             jne 0x3abf
  05E409  3AB9: 837efa00         cmp word ptr [bp - 6], 0
  05E40D  3ABD: 74a9             je 0x3a68
  05E40F  3ABF: 6a08             push 8
  05E411  3AC1: 6a03             push 3
  05E413  3AC3: eb97             jmp 0x3a5c
  05E415  3AC5: 90               nop 
  05E416  3AC6: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  05E41B  3ACB: 7407             je 0x3ad4
  05E41D  3ACD: 6a0a             push 0xa
  05E41F  3ACF: 6a04             push 4
  05E421  3AD1: eb05             jmp 0x3ad8
  05E423  3AD3: 90               nop 
  05E424  3AD4: 6a06             push 6
  05E426  3AD6: 6a02             push 2
  05E428  3AD8: 9ad4041f18       lcall 0x181f, 0x4d4
  05E42D  3ADD: 83c404           add sp, 4
  05E430  3AE0: 837efa01         cmp word ptr [bp - 6], 1
  05E434  3AE4: f5               cmc 
  05E435  3AE5: 1bc9             sbb cx, cx
  05E437  3AE7: 83e106           and cx, 6
  05E43A  3AEA: 03c1             add ax, cx
  05E43C  3AEC: 83be58ff01       cmp word ptr [bp - 0xa8], 1
  05E441  3AF1: f5               cmc 
  05E442  3AF2: 1bc9             sbb cx, cx
  05E444  3AF4: 83e103           and cx, 3
  05E447  3AF7: 03c1             add ax, cx
  05E449  3AF9: 8bc8             mov cx, ax
  05E44B  3AFB: c1e002           shl ax, 2
  05E44E  3AFE: 03c1             add ax, cx
  05E450  3B00: d1e0             shl ax, 1
  05E452  3B02: 898632ff         mov word ptr [bp - 0xce], ax
  05E456  3B06: e97aff           jmp 0x3a83
  05E459  3B09: 90               nop 
  05E45A  3B0A: 6a04             push 4
  05E45C  3B0C: 6a00             push 0
  05E45E  3B0E: 9ad4041f18       lcall 0x181f, 0x4d4
  05E463  3B13: 83c404           add sp, 4
  05E466  3B16: 40               inc ax
  05E467  3B17: 40               inc ax
  05E468  3B18: 898632ff         mov word ptr [bp - 0xce], ax
  05E46C  3B1C: 83be34ff01       cmp word ptr [bp - 0xcc], 1
  05E471  3B21: 1bc0             sbb ax, ax
  05E473  3B23: 24f7             and al, 0xf7
  05E475  3B25: 051900           add ax, 0x19
  05E478  3B28: 837efa01         cmp word ptr [bp - 6], 1
  05E47C  3B2C: f5               cmc 
  05E47D  3B2D: 1bc9             sbb cx, cx
  05E47F  3B2F: 83e10a           and cx, 0xa
  05E482  3B32: 03c1             add ax, cx
  05E484  3B34: 83be58ff01       cmp word ptr [bp - 0xa8], 1
  05E489  3B39: f5               cmc 
  05E48A  3B3A: 1bc9             sbb cx, cx
  05E48C  3B3C: 83e105           and cx, 5
  05E48F  3B3F: 03c1             add ax, cx
  05E491  3B41: f7ae32ff         imul word ptr [bp - 0xce]
  05E495  3B45: ebbb             jmp 0x3b02
  05E497  3B47: 90               nop 
  05E498  3B48: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05E49C  3B4C: 8a4702           mov al, byte ptr [bx + 2]
  05E49F  3B4F: 2ae4             sub ah, ah
  05E4A1  3B51: 898640ff         mov word ptr [bp - 0xc0], ax
  05E4A5  3B55: ffb67aff         push word ptr [bp - 0x86]
  05E4A9  3B59: 9aa4091f18       lcall 0x181f, 0x9a4
  05E4AE  3B5E: 83c402           add sp, 2
  05E4B1  3B61: 50               push ax
  05E4B2  3B62: 6a00             push 0
  05E4B4  3B64: 9a38041f18       lcall 0x181f, 0x438
  05E4B9  3B69: 83c404           add sp, 4
  05E4BC  3B6C: ff768a           push word ptr [bp - 0x76]
  05E4BF  3B6F: 9aa4091f18       lcall 0x181f, 0x9a4
  05E4C4  3B74: 83c402           add sp, 2
  05E4C7  3B77: 50               push ax
  05E4C8  3B78: 6a01             push 1
  05E4CA  3B7A: 9a38041f18       lcall 0x181f, 0x438
  05E4CF  3B7F: 83c404           add sp, 4
  05E4D2  3B82: 8b9e40ff         mov bx, word ptr [bp - 0xc0]
  05E4D6  3B86: 8bc3             mov ax, bx
  05E4D8  3B88: d1e3             shl bx, 1
  05E4DA  3B8A: 03d8             add bx, ax
  05E4DC  3B8C: d1e3             shl bx, 1
  05E4DE  3B8E: ffb73496         push word ptr [bx - 0x69cc]
  05E4E2  3B92: 6a02             push 2
  05E4E4  3B94: 9a38041f18       lcall 0x181f, 0x438
  05E4E9  3B99: 83c404           add sp, 4
  05E4EC  3B9C: 83be32ff00       cmp word ptr [bp - 0xce], 0
  05E4F1  3BA1: 7465             je 0x3c08
  05E4F3  3BA3: ff760a           push word ptr [bp + 0xa]
  05E4F6  3BA6: ff7608           push word ptr [bp + 8]
  05E4F9  3BA9: ffb67aff         push word ptr [bp - 0x86]
  05E4FD  3BAD: 6a0a             push 0xa
  05E4FF  3BAF: 9a5c091f18       lcall 0x181f, 0x95c
  05E504  3BB4: 83c408           add sp, 8
  05E507  3BB7: 89863eff         mov word ptr [bp - 0xc2], ax
  05E50B  3BBB: 0bc0             or ax, ax
  05E50D  3BBD: 7c41             jl 0x3c00
  05E50F  3BBF: 6bd81c           imul bx, ax, 0x1c
  05E512  3BC2: 8a8632ff         mov al, byte ptr [bp - 0xce]
  05E516  3BC6: 88875b31         mov byte ptr [bx + 0x315b], al
  05E51A  3BCA: 6b8632ff64       imul ax, word ptr [bp - 0xce], 0x64
  05E51F  3BCF: 99               cdq 
  05E520  3BD0: 52               push dx
  05E521  3BD1: 50               push ax
  05E522  3BD2: 6a00             push 0
  05E524  3BD4: 9aae091f18       lcall 0x181f, 0x9ae
  05E529  3BD9: 83c406           add sp, 6
  05E52C  3BDC: 6a02             push 2
  05E52E  3BDE: 9aac041f18       lcall 0x181f, 0x4ac
  05E533  3BE3: 83c402           add sp, 2
  05E536  3BE6: 6a01             push 1
  05E538  3BE8: 68cc1c           push 0x1ccc
  05E53B  3BEB: 9a52061f18       lcall 0x181f, 0x652
  05E540  3BF0: 83c404           add sp, 4
  05E543  3BF3: ffb67aff         push word ptr [bp - 0x86]
  05E547  3BF7: 0e               push cs
  05E548  3BF8: e8dd01           call 0x3dd8
  05E54B  3BFB: 83c402           add sp, 2
  05E54E  3BFE: eb15             jmp 0x3c15
  05E550  3C00: c78632ff0000     mov word ptr [bp - 0xce], 0
  05E556  3C06: eb0d             jmp 0x3c15
  05E558  3C08: 6a01             push 1
  05E55A  3C0A: 68d11c           push 0x1cd1
  05E55D  3C0D: 9a52061f18       lcall 0x181f, 0x652
  05E562  3C12: 83c404           add sp, 4
  05E565  3C15: 837e0c00         cmp word ptr [bp + 0xc], 0
  05E569  3C19: 742f             je 0x3c4a
  05E56B  3C1B: 6a00             push 0
  05E56D  3C1D: ff7688           push word ptr [bp - 0x78]
  05E570  3C20: ff7694           push word ptr [bp - 0x6c]
  05E573  3C23: ffb646ff         push word ptr [bp - 0xba]
  05E577  3C27: ffb64eff         push word ptr [bp - 0xb2]
  05E57B  3C2B: 9aba091f18       lcall 0x181f, 0x9ba
  05E580  3C30: 83c40a           add sp, 0xa
  05E583  3C33: 83be32ff00       cmp word ptr [bp - 0xce], 0
  05E588  3C38: 7506             jne 0x3c40
  05E58A  3C3A: 837e8600         cmp word ptr [bp - 0x7a], 0
  05E58E  3C3E: 740a             je 0x3c4a
  05E590  3C40: 6a08             push 8
  05E592  3C42: 9aea031f18       lcall 0x181f, 0x3ea
  05E597  3C47: 83c402           add sp, 2
  05E59A  3C4A: 837ef600         cmp word ptr [bp - 0xa], 0
  05E59E  3C4E: 7503             jne 0x3c53
  05E5A0  3C50: e96301           jmp 0x3db6
  05E5A3  3C53: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  05E5A8  3C58: 7503             jne 0x3c5d
  05E5AA  3C5A: e95901           jmp 0x3db6
  05E5AD  3C5D: ffb67aff         push word ptr [bp - 0x86]
  05E5B1  3C61: ff36528d         push word ptr [0x8d52]
  05E5B5  3C65: 9a0c031f18       lcall 0x181f, 0x30c
  05E5BA  3C6A: 83c404           add sp, 4
  05E5BD  3C6D: 2d0f00           sub ax, 0xf
  05E5C0  3C70: f7d8             neg ax
  05E5C2  3C72: 89865cff         mov word ptr [bp - 0xa4], ax
  05E5C6  3C76: 0bc0             or ax, ax
  05E5C8  3C78: 7d13             jge 0x3c8d
  05E5CA  3C7A: 6a00             push 0
  05E5CC  3C7C: 50               push ax
  05E5CD  3C7D: ffb67aff         push word ptr [bp - 0x86]
  05E5D1  3C81: ff36528d         push word ptr [0x8d52]
  05E5D5  3C85: 9a6c0d1f18       lcall 0x181f, 0xd6c
  05E5DA  3C8A: 83c408           add sp, 8
  05E5DD  3C8D: c7866cff0000     mov word ptr [bp - 0x94], 0
  05E5E3  3C93: eb2a             jmp 0x3cbf
  05E5E5  3C95: 90               nop 
  05E5E6  3C96: a0528d           mov al, byte ptr [0x8d52]
  05E5E9  3C99: 6b9e6cff12       imul bx, word ptr [bp - 0x94], 0x12
  05E5EE  3C9E: 3887ee54         cmp byte ptr [bx + 0x54ee], al
  05E5F2  3CA2: 7517             jne 0x3cbb
  05E5F4  3CA4: 8b9e6cff         mov bx, word ptr [bp - 0x94]
  05E5F8  3CA8: 8bc3             mov ax, bx
  05E5FA  3CAA: c1e303           shl bx, 3
  05E5FD  3CAD: 03d8             add bx, ax
  05E5FF  3CAF: 039e7aff         add bx, word ptr [bp - 0x86]
  05E603  3CB3: d1e3             shl bx, 1
  05E605  3CB5: c787f6540000     mov word ptr [bx + 0x54f6], 0
  05E60B  3CBB: ff866cff         inc word ptr [bp - 0x94]
  05E60F  3CBF: a19a53           mov ax, word ptr [0x539a]
  05E612  3CC2: 39866cff         cmp word ptr [bp - 0x94], ax
  05E616  3CC6: 7cce             jl 0x3c96
  05E618  3CC8: 83be7aff04       cmp word ptr [bp - 0x86], 4
  05E61D  3CCD: 7c03             jl 0x3cd2
  05E61F  3CCF: e9e400           jmp 0x3db6
  05E622  3CD2: 6b9e7aff34       imul bx, word ptr [bp - 0x86], 0x34
  05E627  3CD7: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05E62C  3CDC: 7403             je 0x3ce1
  05E62E  3CDE: e9d500           jmp 0x3db6
  05E631  3CE1: ff768a           push word ptr [bp - 0x76]
  05E634  3CE4: 9aa4091f18       lcall 0x181f, 0x9a4
  05E639  3CE9: 83c402           add sp, 2
  05E63C  3CEC: 50               push ax
  05E63D  3CED: 6a00             push 0
  05E63F  3CEF: 9a38041f18       lcall 0x181f, 0x438
  05E644  3CF4: 83c404           add sp, 4
  05E647  3CF7: ffb67aff         push word ptr [bp - 0x86]
  05E64B  3CFB: 9aa4091f18       lcall 0x181f, 0x9a4
  05E650  3D00: 83c402           add sp, 2
  05E653  3D03: 50               push ax
  05E654  3D04: 6a01             push 1
  05E656  3D06: 9a38041f18       lcall 0x181f, 0x438
  05E65B  3D0B: 83c404           add sp, 4
  05E65E  3D0E: ff36528d         push word ptr [0x8d52]
  05E662  3D12: 68d71c           push 0x1cd7
  05E665  3D15: 9a9c011f19       lcall 0x191f, 0x19c
  05E66A  3D1A: e904ee           jmp 0x2b21
  05E66D  3D1D: 90               nop 
  05E66E  3D1E: 8b4608           mov ax, word ptr [bp + 8]
  05E671  3D21: 8b560a           mov dx, word ptr [bp + 0xa]
  05E674  3D24: 9ae0071f18       lcall 0x181f, 0x7e0
  05E679  3D29: 89863eff         mov word ptr [bp - 0xc2], ax
  05E67D  3D2D: 0bc0             or ax, ax
  05E67F  3D2F: 7c09             jl 0x3d3a
  05E681  3D31: 50               push ax
  05E682  3D32: 9a3a081f18       lcall 0x181f, 0x83a
  05E687  3D37: 83c402           add sp, 2
  05E68A  3D3A: ff760a           push word ptr [bp + 0xa]
  05E68D  3D3D: ff7608           push word ptr [bp + 8]
  05E690  3D40: 9abe071f18       lcall 0x181f, 0x7be
  05E695  3D45: 83c404           add sp, 4
  05E698  3D48: 89863eff         mov word ptr [bp - 0xc2], ax
  05E69C  3D4C: 0bc0             or ax, ax
  05E69E  3D4E: 7c09             jl 0x3d59
  05E6A0  3D50: 50               push ax
  05E6A1  3D51: 9a54021f19       lcall 0x191f, 0x254
  05E6A6  3D56: 83c402           add sp, 2
  05E6A9  3D59: ff760a           push word ptr [bp + 0xa]
  05E6AC  3D5C: ff7608           push word ptr [bp + 8]
  05E6AF  3D5F: 9af0091f18       lcall 0x181f, 0x9f0
  05E6B4  3D64: 83c404           add sp, 4
  05E6B7  3D67: 89863eff         mov word ptr [bp - 0xc2], ax
  05E6BB  3D6B: 0bc0             or ax, ax
  05E6BD  3D6D: 7c09             jl 0x3d78
  05E6BF  3D6F: 50               push ax
  05E6C0  3D70: 9a48021f19       lcall 0x191f, 0x248
  05E6C5  3D75: 83c402           add sp, 2
  05E6C8  3D78: 6a00             push 0
  05E6CA  3D7A: 6a01             push 1
  05E6CC  3D7C: ff760a           push word ptr [bp + 0xa]
  05E6CF  3D7F: ff7608           push word ptr [bp + 8]
  05E6D2  3D82: 9a8c061f18       lcall 0x181f, 0x68c
  05E6D7  3D87: 83c408           add sp, 8
  05E6DA  3D8A: 6a00             push 0
  05E6DC  3D8C: 6a02             push 2
  05E6DE  3D8E: ff760a           push word ptr [bp + 0xa]
  05E6E1  3D91: ff7608           push word ptr [bp + 8]
  05E6E4  3D94: 9a8c061f18       lcall 0x181f, 0x68c
  05E6E9  3D99: 83c408           add sp, 8
  05E6EC  3D9C: 837e0c00         cmp word ptr [bp + 0xc], 0
  05E6F0  3DA0: 7414             je 0x3db6
  05E6F2  3DA2: 6a00             push 0
  05E6F4  3DA4: 9a1c0e1f18       lcall 0x181f, 0xe1c
  05E6F9  3DA9: 83c402           add sp, 2
  05E6FC  3DAC: 6a08             push 8
  05E6FE  3DAE: 9aea031f18       lcall 0x181f, 0x3ea
  05E703  3DB3: 83c402           add sp, 2
  05E706  3DB6: 5e               pop si
  05E707  3DB7: 5f               pop di
  05E708  3DB8: c9               leave 
  05E709  3DB9: cb               retf 
  05E70A  3DBA: ea58041f1a       ljmp 0x1a1f:0x458
  05E70F  3DBF: eab0061f1a       ljmp 0x1a1f:0x6b0
  05E714  3DC4: eabc061f1a       ljmp 0x1a1f:0x6bc
  05E719  3DC9: eac8061f1a       ljmp 0x1a1f:0x6c8
  05E71E  3DCE: ead4061f1a       ljmp 0x1a1f:0x6d4
  05E723  3DD3: eae0061f1a       ljmp 0x1a1f:0x6e0
  05E728  3DD8: eaec061f1a       ljmp 0x1a1f:0x6ec
  05E72D  3DDD: eaf8061f1a       ljmp 0x1a1f:0x6f8
