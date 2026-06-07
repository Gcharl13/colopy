; ============================================================
; VICEROY.EXE overlay page 0x06 (record 5) -- RE-SEGMENTED
; file_offset (disk image) = 0x03B380
; code_offset (first insn) = 0x03B900
; code_end (next reloc hdr)= 0x03EA60  [resident size 790 para -> nominal_end 0x03E4E0; on-disk code spills past it]
; reloc_count = 340  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x03B380)
; functions in page = 32
; ============================================================

; ---- func_03B900  size=59  insns=24  prologue=ENTER 0x0006,0  terminal=RETF ----
  03B900  0580: c8060000         enter 6, 0
  03B904  0584: 8a4e08           mov cl, byte ptr [bp + 8]
  03B907  0587: 80e107           and cl, 7
  03B90A  058A: b80100           mov ax, 1
  03B90D  058D: d3e0             shl ax, cl
  03B90F  058F: 8946fc           mov word ptr [bp - 4], ax
  03B912  0592: 8b4e08           mov cx, word ptr [bp + 8]
  03B915  0595: c1f903           sar cx, 3
  03B918  0598: 6956063c01       imul dx, word ptr [bp + 6], 0x13c
  03B91D  059D: 03ca             add cx, dx
  03B91F  059F: 81c10f88         add cx, 0x880f
  03B923  05A3: 837e0a00         cmp word ptr [bp + 0xa], 0
  03B927  05A7: 7407             je 0x5b0
  03B929  05A9: 8bd9             mov bx, cx
  03B92B  05AB: 0807             or byte ptr [bx], al
  03B92D  05AD: c9               leave 
  03B92E  05AE: cb               retf 
  03B92F  05AF: 90               nop 
  03B930  05B0: 8a46fc           mov al, byte ptr [bp - 4]
  03B933  05B3: f6d0             not al
  03B935  05B5: 8bd9             mov bx, cx
  03B937  05B7: 2007             and byte ptr [bx], al
  03B939  05B9: c9               leave 
  03B93A  05BA: cb               retf 

; ---- func_03B93C  size=29  insns=14  prologue=push bp;mov bp,sp  terminal=RETF ----
  03B93C  05BC: 55               push bp
  03B93D  05BD: 8bec             mov bp, sp
  03B93F  05BF: ff7608           push word ptr [bp + 8]
  03B942  05C2: ff7606           push word ptr [bp + 6]
  03B945  05C5: 9ab4071f18       lcall 0x181f, 0x7b4
  03B94A  05CA: 8be5             mov sp, bp
  03B94C  05CC: 0bc0             or ax, ax
  03B94E  05CE: 7404             je 0x5d4
  03B950  05D0: 2bc0             sub ax, ax
  03B952  05D2: c9               leave 
  03B953  05D3: cb               retf 
  03B954  05D4: b80100           mov ax, 1
  03B957  05D7: c9               leave 
  03B958  05D8: cb               retf 

; ---- func_03B95A  size=38  insns=11  prologue=ENTER 0x0002,0  terminal=RETF ----
  03B95A  05DA: c8020000         enter 2, 0
  03B95E  05DE: c746fe0000       mov word ptr [bp - 2], 0
  03B963  05E3: 813e8a534006     cmp word ptr [0x538a], 0x640
  03B969  05E9: 7c05             jl 0x5f0
  03B96B  05EB: c746fe0100       mov word ptr [bp - 2], 1
  03B970  05F0: 813e8a53a406     cmp word ptr [0x538a], 0x6a4
  03B976  05F6: 7c03             jl 0x5fb
  03B978  05F8: ff46fe           inc word ptr [bp - 2]
  03B97B  05FB: 8b46fe           mov ax, word ptr [bp - 2]
  03B97E  05FE: c9               leave 
  03B97F  05FF: cb               retf 

; ---- func_03B980  size=96  insns=39  prologue=ENTER 0x0004,0  terminal=RETF ----
  03B980  0600: c8040000         enter 4, 0
  03B984  0604: 56               push si
  03B985  0605: 2bc0             sub ax, ax
  03B987  0607: 8946fc           mov word ptr [bp - 4], ax
  03B98A  060A: 8946fe           mov word ptr [bp - 2], ax
  03B98D  060D: eb45             jmp 0x654
  03B98F  060F: 90               nop 
  03B990  0610: ff76fe           push word ptr [bp - 2]
  03B993  0613: ff7606           push word ptr [bp + 6]
  03B996  0616: 9ab4071f18       lcall 0x181f, 0x7b4
  03B99B  061B: 83c404           add sp, 4
  03B99E  061E: 0bc0             or ax, ax
  03B9A0  0620: 752f             jne 0x651
  03B9A2  0622: 8a4608           mov al, byte ptr [bp + 8]
  03B9A5  0625: 8b5efe           mov bx, word ptr [bp - 2]
  03B9A8  0628: 8bcb             mov cx, bx
  03B9AA  062A: d1e3             shl bx, 1
  03B9AC  062C: 03d9             add bx, cx
  03B9AE  062E: d1e3             shl bx, 1
  03B9B0  0630: 38875496         cmp byte ptr [bx - 0x69ac], al
  03B9B4  0634: 751b             jne 0x651
  03B9B6  0636: 0e               push cs
  03B9B7  0637: e8600a           call 0x109a
  03B9BA  063A: 8bf0             mov si, ax
  03B9BC  063C: 8b5efe           mov bx, word ptr [bp - 2]
  03B9BF  063F: 8bc3             mov ax, bx
  03B9C1  0641: d1e3             shl bx, 1
  03B9C3  0643: 03d8             add bx, ax
  03B9C5  0645: d1e3             shl bx, 1
  03B9C7  0647: 80b8559600       cmp byte ptr [bx + si - 0x69ab], 0
  03B9CC  064C: 7403             je 0x651
  03B9CE  064E: ff46fc           inc word ptr [bp - 4]
  03B9D1  0651: ff46fe           inc word ptr [bp - 2]
  03B9D4  0654: 837efe19         cmp word ptr [bp - 2], 0x19
  03B9D8  0658: 7cb6             jl 0x610
  03B9DA  065A: 8b46fc           mov ax, word ptr [bp - 4]
  03B9DD  065D: 5e               pop si
  03B9DE  065E: c9               leave 
  03B9DF  065F: cb               retf 

; ---- func_03B9E0  size=69  insns=26  prologue=ENTER 0x0004,0  terminal=RETF ----
  03B9E0  0660: c8040000         enter 4, 0
  03B9E4  0664: 2bc0             sub ax, ax
  03B9E6  0666: 8946fc           mov word ptr [bp - 4], ax
  03B9E9  0669: 8946fe           mov word ptr [bp - 2], ax
  03B9EC  066C: eb2c             jmp 0x69a
  03B9EE  066E: ff76fe           push word ptr [bp - 2]
  03B9F1  0671: ff7606           push word ptr [bp + 6]
  03B9F4  0674: 9ab4071f18       lcall 0x181f, 0x7b4
  03B9F9  0679: 83c404           add sp, 4
  03B9FC  067C: 0bc0             or ax, ax
  03B9FE  067E: 7417             je 0x697
  03BA00  0680: 8a4608           mov al, byte ptr [bp + 8]
  03BA03  0683: 8b5efe           mov bx, word ptr [bp - 2]
  03BA06  0686: 8bcb             mov cx, bx
  03BA08  0688: d1e3             shl bx, 1
  03BA0A  068A: 03d9             add bx, cx
  03BA0C  068C: d1e3             shl bx, 1
  03BA0E  068E: 38875496         cmp byte ptr [bx - 0x69ac], al
  03BA12  0692: 7503             jne 0x697
  03BA14  0694: ff46fc           inc word ptr [bp - 4]
  03BA17  0697: ff46fe           inc word ptr [bp - 2]
  03BA1A  069A: 837efe19         cmp word ptr [bp - 2], 0x19
  03BA1E  069E: 7cce             jl 0x66e
  03BA20  06A0: 8b46fc           mov ax, word ptr [bp - 4]
  03BA23  06A3: c9               leave 
  03BA24  06A4: cb               retf 

; ---- func_03BA26  size=52  insns=18  prologue=ENTER 0x0002,0  terminal=RETF ----
  03BA26  06A6: c8020000         enter 2, 0
  03BA2A  06AA: 8b5e08           mov bx, word ptr [bp + 8]
  03BA2D  06AD: c60700           mov byte ptr [bx], 0
  03BA30  06B0: ff36f296         push word ptr [0x96f2]
  03BA34  06B4: 53               push bx
  03BA35  06B5: 9a6e011f18       lcall 0x181f, 0x16e
  03BA3A  06BA: 83c404           add sp, 4
  03BA3D  06BD: ff7608           push word ptr [bp + 8]
  03BA40  06C0: 9a78011f18       lcall 0x181f, 0x178
  03BA45  06C5: 83c402           add sp, 2
  03BA48  06C8: 8b4606           mov ax, word ptr [bp + 6]
  03BA4B  06CB: 2d1800           sub ax, 0x18
  03BA4E  06CE: 50               push ax
  03BA4F  06CF: 1e               push ds
  03BA50  06D0: ff7608           push word ptr [bp + 8]
  03BA53  06D3: 9a82011f18       lcall 0x181f, 0x182
  03BA58  06D8: c9               leave 
  03BA59  06D9: cb               retf 

; ---- func_03BA5A  size=76  insns=27  prologue=ENTER 0x0008,0  terminal=RETF ----
  03BA5A  06DA: c8080000         enter 8, 0
  03BA5E  06DE: b8ffff           mov ax, 0xffff
  03BA61  06E1: 8946fe           mov word ptr [bp - 2], ax
  03BA64  06E4: 8946f8           mov word ptr [bp - 8], ax
  03BA67  06E7: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  03BA6C  06EC: 80bf1c8819       cmp byte ptr [bx - 0x77e4], 0x19
  03BA71  06F1: 7205             jb 0x6f8
  03BA73  06F3: b80500           mov ax, 5
  03BA76  06F6: c9               leave 
  03BA77  06F7: cb               retf 
  03BA78  06F8: c746fa0000       mov word ptr [bp - 6], 0
  03BA7D  06FD: ff76fa           push word ptr [bp - 6]
  03BA80  0700: ff7606           push word ptr [bp + 6]
  03BA83  0703: 0e               push cs
  03BA84  0704: e89809           call 0x109f
  03BA87  0707: 83c404           add sp, 4
  03BA8A  070A: 3b46f8           cmp ax, word ptr [bp - 8]
  03BA8D  070D: 7c09             jl 0x718
  03BA8F  070F: 8946f8           mov word ptr [bp - 8], ax
  03BA92  0712: 8b46fa           mov ax, word ptr [bp - 6]
  03BA95  0715: 8946fe           mov word ptr [bp - 2], ax
  03BA98  0718: ff46fa           inc word ptr [bp - 6]
  03BA9B  071B: 837efa05         cmp word ptr [bp - 6], 5
  03BA9F  071F: 7cdc             jl 0x6fd
  03BAA1  0721: 8b46fe           mov ax, word ptr [bp - 2]
  03BAA4  0724: c9               leave 
  03BAA5  0725: cb               retf 

; ---- func_03BAA6  size=163  insns=56  prologue=ENTER 0x0058,0  terminal=RETF ----
  03BAA6  0726: c8580000         enter 0x58, 0
  03BAAA  072A: 2bc0             sub ax, ax
  03BAAC  072C: 8946fe           mov word ptr [bp - 2], ax
  03BAAF  072F: 8946fc           mov word ptr [bp - 4], ax
  03BAB2  0732: 8946a8           mov word ptr [bp - 0x58], ax
  03BAB5  0735: 8b5ea8           mov bx, word ptr [bp - 0x58]
  03BAB8  0738: 8a873a12         mov al, byte ptr [bx + 0x123a]
  03BABC  073C: 2ae4             sub ah, ah
  03BABE  073E: 8946aa           mov word ptr [bp - 0x56], ax
  03BAC1  0741: 50               push ax
  03BAC2  0742: ff7606           push word ptr [bp + 6]
  03BAC5  0745: 9ab4071f18       lcall 0x181f, 0x7b4
  03BACA  074A: 83c404           add sp, 4
  03BACD  074D: 0bc0             or ax, ax
  03BACF  074F: 746a             je 0x7bb
  03BAD1  0751: 683412           push 0x1234
  03BAD4  0754: 8d46ac           lea ax, [bp - 0x54]
  03BAD7  0757: 50               push ax
  03BAD8  0758: 9ae4071d0d       lcall 0xd1d, 0x7e4
  03BADD  075D: 83c404           add sp, 4
  03BAE0  0760: 837eaa0a         cmp word ptr [bp - 0x56], 0xa
  03BAE4  0764: 7d0f             jge 0x775
  03BAE6  0766: 683812           push 0x1238
  03BAE9  0769: 8d46ac           lea ax, [bp - 0x54]
  03BAEC  076C: 50               push ax
  03BAED  076D: 9aa4071d0d       lcall 0xd1d, 0x7a4
  03BAF2  0772: 83c404           add sp, 4
  03BAF5  0775: ff76aa           push word ptr [bp - 0x56]
  03BAF8  0778: 8d46ac           lea ax, [bp - 0x54]
  03BAFB  077B: 16               push ss
  03BAFC  077C: 50               push ax
  03BAFD  077D: 9a82011f18       lcall 0x181f, 0x182
  03BB02  0782: 83c406           add sp, 6
  03BB05  0785: 9ade0f1f19       lcall 0x191f, 0xfde
  03BB0A  078A: 8d5eac           lea bx, [bp - 0x54]
  03BB0D  078D: 2bc0             sub ax, ax
  03BB0F  078F: 9ad00f1f19       lcall 0x191f, 0xfd0
  03BB14  0794: 8946fc           mov word ptr [bp - 4], ax
  03BB17  0797: 8956fe           mov word ptr [bp - 2], dx
  03BB1A  079A: 0bd0             or dx, ax
  03BB1C  079C: 741d             je 0x7bb
  03BB1E  079E: ff76fe           push word ptr [bp - 2]
  03BB21  07A1: 50               push ax
  03BB22  07A2: c45efc           les bx, ptr [bp - 4]
  03BB25  07A5: 26ff7748         push word ptr es:[bx + 0x48]
  03BB29  07A9: 6a64             push 0x64
  03BB2B  07AB: 268b5746         mov dx, word ptr es:[bx + 0x46]
  03BB2F  07AF: b80100           mov ax, 1
  03BB32  07B2: 8d1ea82d         lea bx, [0x2da8]
  03BB36  07B6: 9af8021f18       lcall 0x181f, 0x2f8
  03BB3B  07BB: ff46a8           inc word ptr [bp - 0x58]
  03BB3E  07BE: 837ea819         cmp word ptr [bp - 0x58], 0x19
  03BB42  07C2: 7d03             jge 0x7c7
  03BB44  07C4: e96eff           jmp 0x735
  03BB47  07C7: c9               leave 
  03BB48  07C8: cb               retf 

; ---- func_03BB4A  size=247  insns=83  prologue=ENTER 0x0300,0  terminal=RETF ----
  03BB4A  07CA: c8000300         enter 0x300, 0
  03BB4E  07CE: 8d8600fd         lea ax, [bp - 0x300]
  03BB52  07D2: 16               push ss
  03BB53  07D3: 50               push ax
  03BB54  07D4: 2bc0             sub ax, ax
  03BB56  07D6: a37203           mov word ptr [0x372], ax
  03BB59  07D9: 50               push ax
  03BB5A  07DA: ff36a483         push word ptr [0x83a4]
  03BB5E  07DE: ff36a283         push word ptr [0x83a2]
  03BB62  07E2: ff36a083         push word ptr [0x83a0]
  03BB66  07E6: ff369e83         push word ptr [0x839e]
  03BB6A  07EA: 685312           push 0x1253
  03BB6D  07ED: 9a4e041f18       lcall 0x181f, 0x44e
  03BB72  07F2: 83c410           add sp, 0x10
  03BB75  07F5: 0bc0             or ax, ax
  03BB77  07F7: 7403             je 0x7fc
  03BB79  07F9: e9ad00           jmp 0x8a9
  03BB7C  07FC: 9ab6031f18       lcall 0x181f, 0x3b6
  03BB81  0801: 8d8600fd         lea ax, [bp - 0x300]
  03BB85  0805: 16               push ss
  03BB86  0806: 50               push ax
  03BB87  0807: 9af4031f18       lcall 0x181f, 0x3f4
  03BB8C  080C: ff36a483         push word ptr [0x83a4]
  03BB90  0810: ff36a283         push word ptr [0x83a2]
  03BB94  0814: ff36a083         push word ptr [0x83a0]
  03BB98  0818: ff369e83         push word ptr [0x839e]
  03BB9C  081C: ff36ae2d         push word ptr [0x2dae]
  03BBA0  0820: ff36ac2d         push word ptr [0x2dac]
  03BBA4  0824: ff36aa2d         push word ptr [0x2daa]
  03BBA8  0828: ff36a82d         push word ptr [0x2da8]
  03BBAC  082C: 68c800           push 0xc8
  03BBAF  082F: 2bc0             sub ax, ax
  03BBB1  0831: 99               cdq 
  03BBB2  0832: bb4001           mov bx, 0x140
  03BBB5  0835: 9a44041f18       lcall 0x181f, 0x444
  03BBBA  083A: 837e0800         cmp word ptr [bp + 8], 0
  03BBBE  083E: 7c0f             jl 0x84f
  03BBC0  0840: 6a00             push 0
  03BBC2  0842: ff7608           push word ptr [bp + 8]
  03BBC5  0845: ff7606           push word ptr [bp + 6]
  03BBC8  0848: 0e               push cs
  03BBC9  0849: e84908           call 0x1095
  03BBCC  084C: 83c406           add sp, 6
  03BBCF  084F: ff7606           push word ptr [bp + 6]
  03BBD2  0852: 0e               push cs
  03BBD3  0853: e83a08           call 0x1090
  03BBD6  0856: 83c402           add sp, 2
  03BBD9  0859: 6a00             push 0
  03BBDB  085B: 684001           push 0x140
  03BBDE  085E: 68c800           push 0xc8
  03BBE1  0861: 2bc0             sub ax, ax
  03BBE3  0863: 99               cdq 
  03BBE4  0864: 2bdb             sub bx, bx
  03BBE6  0866: 9ae2001f18       lcall 0x181f, 0xe2
  03BBEB  086B: 837e0800         cmp word ptr [bp + 8], 0
  03BBEF  086F: 7c23             jl 0x894
  03BBF1  0871: 6a01             push 1
  03BBF3  0873: ff7608           push word ptr [bp + 8]
  03BBF6  0876: ff7606           push word ptr [bp + 6]
  03BBF9  0879: 0e               push cs
  03BBFA  087A: e81808           call 0x1095
  03BBFD  087D: 83c406           add sp, 6
  03BC00  0880: ff7606           push word ptr [bp + 6]
  03BC03  0883: 0e               push cs
  03BC04  0884: e80908           call 0x1090
  03BC07  0887: 83c402           add sp, 2
  03BC0A  088A: 6a08             push 8
  03BC0C  088C: 9aea031f18       lcall 0x181f, 0x3ea
  03BC11  0891: 83c402           add sp, 2
  03BC14  0894: 9ac0031f18       lcall 0x181f, 0x3c0
  03BC19  0899: 9ab6031f18       lcall 0x181f, 0x3b6
  03BC1E  089E: 6800a0           push 0xa000
  03BC21  08A1: 6800fc           push 0xfc00
  03BC24  08A4: 9af4031f18       lcall 0x181f, 0x3f4
  03BC29  08A9: 8a268353         mov ah, byte ptr [0x5383]
  03BC2D  08AD: 250001           and ax, 0x100
  03BC30  08B0: 3d0100           cmp ax, 1
  03BC33  08B3: 1bc0             sbb ax, ax
  03BC35  08B5: f7d8             neg ax
  03BC37  08B7: a37203           mov word ptr [0x372], ax
  03BC3A  08BA: 9aac0a1f19       lcall 0x191f, 0xaac
  03BC3F  08BF: c9               leave 
  03BC40  08C0: cb               retf 

; ---- func_03BC42  size=911  insns=297  prologue=ENTER 0x0060,0  terminal=RETF ----
  03BC42  08C2: c8600000         enter 0x60, 0
  03BC46  08C6: 56               push si
  03BC47  08C7: a1c68d           mov ax, word ptr [0x8dc6]
  03BC4A  08CA: 8946a8           mov word ptr [bp - 0x58], ax
  03BC4D  08CD: ff7606           push word ptr [bp + 6]
  03BC50  08D0: 9a82051f18       lcall 0x181f, 0x582
  03BC55  08D5: 83c402           add sp, 2
  03BC58  08D8: 837e0800         cmp word ptr [bp + 8], 0
  03BC5C  08DC: 7c3c             jl 0x91a
  03BC5E  08DE: 6a01             push 1
  03BC60  08E0: ff7608           push word ptr [bp + 8]
  03BC63  08E3: ff7606           push word ptr [bp + 6]
  03BC66  08E6: 0e               push cs
  03BC67  08E7: e8ab07           call 0x1095
  03BC6A  08EA: 83c406           add sp, 6
  03BC6D  08ED: 8b5e08           mov bx, word ptr [bp + 8]
  03BC70  08F0: 8bc3             mov ax, bx
  03BC72  08F2: d1e3             shl bx, 1
  03BC74  08F4: 03d8             add bx, ax
  03BC76  08F6: d1e3             shl bx, 1
  03BC78  08F8: ffb75296         push word ptr [bx - 0x69ae]
  03BC7C  08FC: 6a01             push 1
  03BC7E  08FE: 9a38041f18       lcall 0x181f, 0x438
  03BC83  0903: 83c404           add sp, 4
  03BC86  0906: 8b5e08           mov bx, word ptr [bp + 8]
  03BC89  0909: 80bfa95300       cmp byte ptr [bx + 0x53a9], 0
  03BC8E  090E: 7d27             jge 0x937
  03BC90  0910: 8a4606           mov al, byte ptr [bp + 6]
  03BC93  0913: 8887a953         mov byte ptr [bx + 0x53a9], al
  03BC97  0917: eb1e             jmp 0x937
  03BC99  0919: 90               nop 
  03BC9A  091A: 8d46b0           lea ax, [bp - 0x50]
  03BC9D  091D: 50               push ax
  03BC9E  091E: ff7606           push word ptr [bp + 6]
  03BCA1  0921: 0e               push cs
  03BCA2  0922: e86107           call 0x1086
  03BCA5  0925: 83c404           add sp, 4
  03BCA8  0928: 8d46b0           lea ax, [bp - 0x50]
  03BCAB  092B: 16               push ss
  03BCAC  092C: 50               push ax
  03BCAD  092D: 6a01             push 1
  03BCAF  092F: 9a16041f18       lcall 0x181f, 0x416
  03BCB4  0934: 83c406           add sp, 6
  03BCB7  0937: 837e0604         cmp word ptr [bp + 6], 4
  03BCBB  093B: 7d76             jge 0x9b3
  03BCBD  093D: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  03BCC1  0941: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03BCC6  0946: 756b             jne 0x9b3
  03BCC8  0948: 837e0800         cmp word ptr [bp + 8], 0
  03BCCC  094C: 7c65             jl 0x9b3
  03BCCE  094E: 8b5e08           mov bx, word ptr [bp + 8]
  03BCD1  0951: 8bc3             mov ax, bx
  03BCD3  0953: d1e3             shl bx, 1
  03BCD5  0955: 03d8             add bx, ax
  03BCD7  0957: d1e3             shl bx, 1
  03BCD9  0959: ffb75296         push word ptr [bx - 0x69ae]
  03BCDD  095D: 6a00             push 0
  03BCDF  095F: 9a38041f18       lcall 0x181f, 0x438
  03BCE4  0964: 83c404           add sp, 4
  03BCE7  0967: ff7606           push word ptr [bp + 6]
  03BCEA  096A: 9aa4091f18       lcall 0x181f, 0x9a4
  03BCEF  096F: 83c402           add sp, 2
  03BCF2  0972: 50               push ax
  03BCF3  0973: 6a01             push 1
  03BCF5  0975: 9a38041f18       lcall 0x181f, 0x438
  03BCFA  097A: 83c404           add sp, 4
  03BCFD  097D: 6a03             push 3
  03BCFF  097F: 9aac041f18       lcall 0x181f, 0x4ac
  03BD04  0984: 83c402           add sp, 2
  03BD07  0987: 8d1e7c08         lea bx, [0x87c]
  03BD0B  098B: 8d065a12         lea ax, [0x125a]
  03BD0F  098F: 2bd2             sub dx, dx
  03BD11  0991: 9a98091f18       lcall 0x181f, 0x998
  03BD16  0996: ff7608           push word ptr [bp + 8]
  03BD19  0999: ff7606           push word ptr [bp + 6]
  03BD1C  099C: 0e               push cs
  03BD1D  099D: e8d706           call 0x1077
  03BD20  09A0: 83c404           add sp, 4
  03BD23  09A3: ff7608           push word ptr [bp + 8]
  03BD26  09A6: 9a62001f1a       lcall 0x1a1f, 0x62
  03BD2B  09AB: 83c402           add sp, 2
  03BD2E  09AE: 9a6a051f18       lcall 0x181f, 0x56a
  03BD33  09B3: 8b1efc84         mov bx, word ptr [0x84fc]
  03BD37  09B7: fe4714           inc byte ptr [bx + 0x14]
  03BD3A  09BA: c74712ffff       mov word ptr [bx + 0x12], 0xffff
  03BD3F  09BF: 837e0801         cmp word ptr [bp + 8], 1
  03BD43  09C3: 7505             jne 0x9ca
  03BD45  09C5: c747200000       mov word ptr [bx + 0x20], 0
  03BD4A  09CA: 837e0809         cmp word ptr [bp + 8], 9
  03BD4E  09CE: 753b             jne 0xa0b
  03BD50  09D0: c746a60000       mov word ptr [bp - 0x5a], 0
  03BD55  09D5: eb2b             jmp 0xa02
  03BD57  09D7: 90               nop 
  03BD58  09D8: 50               push ax
  03BD59  09D9: 9ae6091f18       lcall 0x181f, 0x9e6
  03BD5E  09DE: 83c402           add sp, 2
  03BD61  09E1: 8a4606           mov al, byte ptr [bp + 6]
  03BD64  09E4: 8b1e4285         mov bx, word ptr [0x8542]
  03BD68  09E8: 38471a           cmp byte ptr [bx + 0x1a], al
  03BD6B  09EB: 7512             jne 0x9ff
  03BD6D  09ED: 807f1f03         cmp byte ptr [bx + 0x1f], 3
  03BD71  09F1: 7c0c             jl 0x9ff
  03BD73  09F3: 6a01             push 1
  03BD75  09F5: 6a00             push 0
  03BD77  09F7: 9abe0b1f18       lcall 0x181f, 0xbbe
  03BD7C  09FC: 83c404           add sp, 4
  03BD7F  09FF: ff46a6           inc word ptr [bp - 0x5a]
  03BD82  0A02: 8b46a6           mov ax, word ptr [bp - 0x5a]
  03BD85  0A05: 39069e53         cmp word ptr [0x539e], ax
  03BD89  0A09: 7fcd             jg 0x9d8
  03BD8B  0A0B: 837e080e         cmp word ptr [bp + 8], 0xe
  03BD8F  0A0F: 754c             jne 0xa5d
  03BD91  0A11: 8b4606           mov ax, word ptr [bp + 6]
  03BD94  0A14: 2d1800           sub ax, 0x18
  03BD97  0A17: 50               push ax
  03BD98  0A18: 50               push ax
  03BD99  0A19: ff7606           push word ptr [bp + 6]
  03BD9C  0A1C: 837e080e         cmp word ptr [bp + 8], 0xe
  03BDA0  0A20: 7506             jne 0xa28
  03BDA2  0A22: b81100           mov ax, 0x11
  03BDA5  0A25: eb04             jmp 0xa2b
  03BDA7  0A27: 90               nop 
  03BDA8  0A28: b80f00           mov ax, 0xf
  03BDAB  0A2B: 50               push ax
  03BDAC  0A2C: 9a5c091f18       lcall 0x181f, 0x95c
  03BDB1  0A31: 83c408           add sp, 8
  03BDB4  0A34: 8946a2           mov word ptr [bp - 0x5e], ax
  03BDB7  0A37: 0bc0             or ax, ax
  03BDB9  0A39: 7c22             jl 0xa5d
  03BDBB  0A3B: 6bd81c           imul bx, ax, 0x1c
  03BDBE  0A3E: c6874c3100       mov byte ptr [bx + 0x314c], 0
  03BDC3  0A43: 6976063c01       imul si, word ptr [bp + 6], 0x13c
  03BDC8  0A48: 8a843a88         mov al, byte ptr [si - 0x77c6]
  03BDCC  0A4C: 88874d31         mov byte ptr [bx + 0x314d], al
  03BDD0  0A50: 8a843b88         mov al, byte ptr [si - 0x77c5]
  03BDD4  0A54: 88874e31         mov byte ptr [bx + 0x314e], al
  03BDD8  0A58: c6875a3100       mov byte ptr [bx + 0x315a], 0
  03BDDD  0A5D: 837e0810         cmp word ptr [bp + 8], 0x10
  03BDE1  0A61: 756a             jne 0xacd
  03BDE3  0A63: c746a60000       mov word ptr [bp - 0x5a], 0
  03BDE8  0A68: ff76a6           push word ptr [bp - 0x5a]
  03BDEB  0A6B: 9a420a1f18       lcall 0x181f, 0xa42
  03BDF0  0A70: 83c402           add sp, 2
  03BDF3  0A73: 8b7606           mov si, word ptr [bp + 6]
  03BDF6  0A76: d1e6             shl si, 1
  03BDF8  0A78: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  03BDFC  0A7C: 8b4046           mov ax, word ptr [bx + si + 0x46]
  03BDFF  0A7F: f7d8             neg ax
  03BE01  0A81: 8946aa           mov word ptr [bp - 0x56], ax
  03BE04  0A84: 0bc0             or ax, ax
  03BE06  0A86: 7d11             jge 0xa99
  03BE08  0A88: 6a00             push 0
  03BE0A  0A8A: 50               push ax
  03BE0B  0A8B: ff7606           push word ptr [bp + 6]
  03BE0E  0A8E: ff76a6           push word ptr [bp - 0x5a]
  03BE11  0A91: 9a6c0d1f18       lcall 0x181f, 0xd6c
  03BE16  0A96: 83c408           add sp, 8
  03BE19  0A99: ff46a6           inc word ptr [bp - 0x5a]
  03BE1C  0A9C: 837ea608         cmp word ptr [bp - 0x5a], 8
  03BE20  0AA0: 7cc6             jl 0xa68
  03BE22  0AA2: c746a60000       mov word ptr [bp - 0x5a], 0
  03BE27  0AA7: eb1b             jmp 0xac4
  03BE29  0AA9: 90               nop 
  03BE2A  0AAA: 50               push ax
  03BE2B  0AAB: 9a4c0a1f18       lcall 0x181f, 0xa4c
  03BE30  0AB0: 83c402           add sp, 2
  03BE33  0AB3: 8b7606           mov si, word ptr [bp + 6]
  03BE36  0AB6: d1e6             shl si, 1
  03BE38  0AB8: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  03BE3C  0ABC: c7400a0000       mov word ptr [bx + si + 0xa], 0
  03BE41  0AC1: ff46a6           inc word ptr [bp - 0x5a]
  03BE44  0AC4: 8b46a6           mov ax, word ptr [bp - 0x5a]
  03BE47  0AC7: 39069a53         cmp word ptr [0x539a], ax
  03BE4B  0ACB: 7fdd             jg 0xaaa
  03BE4D  0ACD: 837e0812         cmp word ptr [bp + 8], 0x12
  03BE51  0AD1: 7524             jne 0xaf7
  03BE53  0AD3: 837e0604         cmp word ptr [bp + 6], 4
  03BE57  0AD7: 7d1e             jge 0xaf7
  03BE59  0AD9: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  03BE5D  0ADD: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03BE62  0AE2: 7513             jne 0xaf7
  03BE64  0AE4: 8306d05314       add word ptr [0x53d0], 0x14
  03BE69  0AE9: a1d053           mov ax, word ptr [0x53d0]
  03BE6C  0AEC: 3d6400           cmp ax, 0x64
  03BE6F  0AEF: 7e03             jle 0xaf4
  03BE71  0AF1: b86400           mov ax, 0x64
  03BE74  0AF4: a3d053           mov word ptr [0x53d0], ax
  03BE77  0AF7: 837e0816         cmp word ptr [bp + 8], 0x16
  03BE7B  0AFB: 7535             jne 0xb32
  03BE7D  0AFD: c746a60000       mov word ptr [bp - 0x5a], 0
  03BE82  0B02: eb25             jmp 0xb29
  03BE84  0B04: 50               push ax
  03BE85  0B05: 9a4c0a1f18       lcall 0x181f, 0xa4c
  03BE8A  0B0A: 83c402           add sp, 2
  03BE8D  0B0D: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  03BE91  0B11: 807f0500         cmp byte ptr [bx + 5], 0
  03BE95  0B15: 7c0f             jl 0xb26
  03BE97  0B17: 8a4705           mov al, byte ptr [bx + 5]
  03BE9A  0B1A: 250f00           and ax, 0xf
  03BE9D  0B1D: 3b4606           cmp ax, word ptr [bp + 6]
  03BEA0  0B20: 7504             jne 0xb26
  03BEA2  0B22: 804f0510         or byte ptr [bx + 5], 0x10
  03BEA6  0B26: ff46a6           inc word ptr [bp - 0x5a]
  03BEA9  0B29: 8b46a6           mov ax, word ptr [bp - 0x5a]
  03BEAC  0B2C: 39069a53         cmp word ptr [0x539a], ax
  03BEB0  0B30: 7fd2             jg 0xb04
  03BEB2  0B32: 837e0818         cmp word ptr [bp + 8], 0x18
  03BEB6  0B36: 7403             je 0xb3b
  03BEB8  0B38: e99900           jmp 0xbd4
  03BEBB  0B3B: c746a20000       mov word ptr [bp - 0x5e], 0
  03BEC0  0B40: eb28             jmp 0xb6a
  03BEC2  0B42: 6bd81c           imul bx, ax, 0x1c
  03BEC5  0B45: 8a874731         mov al, byte ptr [bx + 0x3147]
  03BEC9  0B49: 240f             and al, 0xf
  03BECB  0B4B: 3a4606           cmp al, byte ptr [bp + 6]
  03BECE  0B4E: 7517             jne 0xb67
  03BED0  0B50: 6b5ea21c         imul bx, word ptr [bp - 0x5e], 0x1c
  03BED4  0B54: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  03BED9  0B59: 750c             jne 0xb67
  03BEDB  0B5B: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  03BEE0  0B60: 7505             jne 0xb67
  03BEE2  0B62: c6875b311c       mov byte ptr [bx + 0x315b], 0x1c
  03BEE7  0B67: ff46a2           inc word ptr [bp - 0x5e]
  03BEEA  0B6A: 8b46a2           mov ax, word ptr [bp - 0x5e]
  03BEED  0B6D: 39069c53         cmp word ptr [0x539c], ax
  03BEF1  0B71: 7fcf             jg 0xb42
  03BEF3  0B73: c746a60000       mov word ptr [bp - 0x5a], 0
  03BEF8  0B78: eb35             jmp 0xbaf
  03BEFA  0B7A: ff46a2           inc word ptr [bp - 0x5e]
  03BEFD  0B7D: 8b1e4285         mov bx, word ptr [0x8542]
  03BF01  0B81: 8a471f           mov al, byte ptr [bx + 0x1f]
  03BF04  0B84: 98               cwde 
  03BF05  0B85: 3b46a2           cmp ax, word ptr [bp - 0x5e]
  03BF08  0B88: 7e22             jle 0xbac
  03BF0A  0B8A: ff76a2           push word ptr [bp - 0x5e]
  03BF0D  0B8D: 9a540c1f18       lcall 0x181f, 0xc54
  03BF12  0B92: 83c402           add sp, 2
  03BF15  0B95: 8946a4           mov word ptr [bp - 0x5c], ax
  03BF18  0B98: 3d1b00           cmp ax, 0x1b
  03BF1B  0B9B: 75dd             jne 0xb7a
  03BF1D  0B9D: 6a1c             push 0x1c
  03BF1F  0B9F: ff76a2           push word ptr [bp - 0x5e]
  03BF22  0BA2: 9aae0c1f18       lcall 0x181f, 0xcae
  03BF27  0BA7: 83c404           add sp, 4
  03BF2A  0BAA: ebce             jmp 0xb7a
  03BF2C  0BAC: ff46a6           inc word ptr [bp - 0x5a]
  03BF2F  0BAF: 8b46a6           mov ax, word ptr [bp - 0x5a]
  03BF32  0BB2: 39069e53         cmp word ptr [0x539e], ax
  03BF36  0BB6: 7e1c             jle 0xbd4
  03BF38  0BB8: 50               push ax
  03BF39  0BB9: 9ae6091f18       lcall 0x181f, 0x9e6
  03BF3E  0BBE: 83c402           add sp, 2
  03BF41  0BC1: 8a4606           mov al, byte ptr [bp + 6]
  03BF44  0BC4: 8b1e4285         mov bx, word ptr [0x8542]
  03BF48  0BC8: 38471a           cmp byte ptr [bx + 0x1a], al
  03BF4B  0BCB: 75df             jne 0xbac
  03BF4D  0BCD: c746a20000       mov word ptr [bp - 0x5e], 0
  03BF52  0BD2: eba9             jmp 0xb7d
  03BF54  0BD4: 837e0806         cmp word ptr [bp + 8], 6
  03BF58  0BD8: 752b             jne 0xc05
  03BF5A  0BDA: c746a00000       mov word ptr [bp - 0x60], 0
  03BF5F  0BDF: eb1b             jmp 0xbfc
  03BF61  0BE1: 90               nop 
  03BF62  0BE2: 50               push ax
  03BF63  0BE3: 9ae6091f18       lcall 0x181f, 0x9e6
  03BF68  0BE8: 83c402           add sp, 2
  03BF6B  0BEB: ff7606           push word ptr [bp + 6]
  03BF6E  0BEE: ff76a0           push word ptr [bp - 0x60]
  03BF71  0BF1: 9aaa071f18       lcall 0x181f, 0x7aa
  03BF76  0BF6: 83c404           add sp, 4
  03BF79  0BF9: ff46a0           inc word ptr [bp - 0x60]
  03BF7C  0BFC: 8b46a0           mov ax, word ptr [bp - 0x60]
  03BF7F  0BFF: 39069e53         cmp word ptr [0x539e], ax
  03BF83  0C03: 7fdd             jg 0xbe2
  03BF85  0C05: 837e0814         cmp word ptr [bp + 8], 0x14
  03BF89  0C09: 752e             jne 0xc39
  03BF8B  0C0B: c746a60000       mov word ptr [bp - 0x5a], 0
  03BF90  0C10: 6976063c01       imul si, word ptr [bp + 6], 0x13c
  03BF95  0C15: 8b5ea6           mov bx, word ptr [bp - 0x5a]
  03BF98  0C18: 80b80a8819       cmp byte ptr [bx + si - 0x77f6], 0x19
  03BF9D  0C1D: 7407             je 0xc26
  03BF9F  0C1F: 80b80a881a       cmp byte ptr [bx + si - 0x77f6], 0x1a
  03BFA4  0C24: 750a             jne 0xc30
  03BFA6  0C26: 6976063c01       imul si, word ptr [bp + 6], 0x13c
  03BFAB  0C2B: c6800a881c       mov byte ptr [bx + si - 0x77f6], 0x1c
  03BFB0  0C30: ff46a6           inc word ptr [bp - 0x5a]
  03BFB3  0C33: 837ea603         cmp word ptr [bp - 0x5a], 3
  03BFB7  0C37: 7cd7             jl 0xc10
  03BFB9  0C39: ff76a8           push word ptr [bp - 0x58]
  03BFBC  0C3C: 9ae6091f18       lcall 0x181f, 0x9e6
  03BFC1  0C41: 83c402           add sp, 2
  03BFC4  0C44: 6a01             push 1
  03BFC6  0C46: 9a1c0e1f18       lcall 0x181f, 0xe1c
  03BFCB  0C4B: 83c402           add sp, 2
  03BFCE  0C4E: 5e               pop si
  03BFCF  0C4F: c9               leave 
  03BFD0  0C50: cb               retf 

; ---- func_03BFD2  size=688  insns=238  prologue=ENTER 0x0074,0  terminal=RETF ----
  03BFD2  0C52: c8740000         enter 0x74, 0
  03BFD6  0C56: 56               push si
  03BFD7  0C57: 2bc0             sub ax, ax
  03BFD9  0C59: 8946a4           mov word ptr [bp - 0x5c], ax
  03BFDC  0C5C: 8946a2           mov word ptr [bp - 0x5e], ax
  03BFDF  0C5F: ff7606           push word ptr [bp + 6]
  03BFE2  0C62: 9a82051f18       lcall 0x181f, 0x582
  03BFE7  0C67: 83c402           add sp, 2
  03BFEA  0C6A: 0e               push cs
  03BFEB  0C6B: e82c04           call 0x109a
  03BFEE  0C6E: 8946ac           mov word ptr [bp - 0x54], ax
  03BFF1  0C71: 2bc0             sub ax, ax
  03BFF3  0C73: 8946fe           mov word ptr [bp - 2], ax
  03BFF6  0C76: 894698           mov word ptr [bp - 0x68], ax
  03BFF9  0C79: eb65             jmp 0xce0
  03BFFB  0C7B: 90               nop 
  03BFFC  0C7C: 837e9619         cmp word ptr [bp - 0x6a], 0x19
  03C000  0C80: 7d50             jge 0xcd2
  03C002  0C82: ff7696           push word ptr [bp - 0x6a]
  03C005  0C85: ff7606           push word ptr [bp + 6]
  03C008  0C88: 9ab4071f18       lcall 0x181f, 0x7b4
  03C00D  0C8D: 83c404           add sp, 4
  03C010  0C90: 0bc0             or ax, ax
  03C012  0C92: 7535             jne 0xcc9
  03C014  0C94: 8a4698           mov al, byte ptr [bp - 0x68]
  03C017  0C97: 8b5e96           mov bx, word ptr [bp - 0x6a]
  03C01A  0C9A: 8bcb             mov cx, bx
  03C01C  0C9C: d1e3             shl bx, 1
  03C01E  0C9E: 03d9             add bx, cx
  03C020  0CA0: d1e3             shl bx, 1
  03C022  0CA2: 38875496         cmp byte ptr [bx - 0x69ac], al
  03C026  0CA6: 7521             jne 0xcc9
  03C028  0CA8: 8bf1             mov si, cx
  03C02A  0CAA: 8bc1             mov ax, cx
  03C02C  0CAC: d1e6             shl si, 1
  03C02E  0CAE: 03f0             add si, ax
  03C030  0CB0: d1e6             shl si, 1
  03C032  0CB2: 8b5eac           mov bx, word ptr [bp - 0x54]
  03C035  0CB5: 8a805596         mov al, byte ptr [bx + si - 0x69ab]
  03C039  0CB9: 2ae4             sub ah, ah
  03C03B  0CBB: 29469e           sub word ptr [bp - 0x62], ax
  03C03E  0CBE: 837e9e00         cmp word ptr [bp - 0x62], 0
  03C042  0CC2: 7f05             jg 0xcc9
  03C044  0CC4: 8bc1             mov ax, cx
  03C046  0CC6: 89469a           mov word ptr [bp - 0x66], ax
  03C049  0CC9: ff4696           inc word ptr [bp - 0x6a]
  03C04C  0CCC: 837e9a00         cmp word ptr [bp - 0x66], 0
  03C050  0CD0: 7caa             jl 0xc7c
  03C052  0CD2: 8b469a           mov ax, word ptr [bp - 0x66]
  03C055  0CD5: 8b7698           mov si, word ptr [bp - 0x68]
  03C058  0CD8: d1e6             shl si, 1
  03C05A  0CDA: 89428c           mov word ptr [bp + si - 0x74], ax
  03C05D  0CDD: ff4698           inc word ptr [bp - 0x68]
  03C060  0CE0: 837e9805         cmp word ptr [bp - 0x68], 5
  03C064  0CE4: 7c03             jl 0xce9
  03C066  0CE6: e98b00           jmp 0xd74
  03C069  0CE9: 8b7698           mov si, word ptr [bp - 0x68]
  03C06C  0CEC: d1e6             shl si, 1
  03C06E  0CEE: c7428cffff       mov word ptr [bp + si - 0x74], 0xffff
  03C073  0CF3: c7469c0000       mov word ptr [bp - 0x64], 0
  03C078  0CF8: ff7698           push word ptr [bp - 0x68]
  03C07B  0CFB: ff7606           push word ptr [bp + 6]
  03C07E  0CFE: 0e               push cs
  03C07F  0CFF: e89d03           call 0x109f
  03C082  0D02: 83c404           add sp, 4
  03C085  0D05: 0bc0             or ax, ax
  03C087  0D07: 74d4             je 0xcdd
  03C089  0D09: ff46fe           inc word ptr [bp - 2]
  03C08C  0D0C: c746960000       mov word ptr [bp - 0x6a], 0
  03C091  0D11: ff7696           push word ptr [bp - 0x6a]
  03C094  0D14: ff7606           push word ptr [bp + 6]
  03C097  0D17: 9ab4071f18       lcall 0x181f, 0x7b4
  03C09C  0D1C: 83c404           add sp, 4
  03C09F  0D1F: 0bc0             or ax, ax
  03C0A1  0D21: 752a             jne 0xd4d
  03C0A3  0D23: 8a4698           mov al, byte ptr [bp - 0x68]
  03C0A6  0D26: 8b5e96           mov bx, word ptr [bp - 0x6a]
  03C0A9  0D29: 8bcb             mov cx, bx
  03C0AB  0D2B: d1e3             shl bx, 1
  03C0AD  0D2D: 03d9             add bx, cx
  03C0AF  0D2F: d1e3             shl bx, 1
  03C0B1  0D31: 38875496         cmp byte ptr [bx - 0x69ac], al
  03C0B5  0D35: 7516             jne 0xd4d
  03C0B7  0D37: 8bf1             mov si, cx
  03C0B9  0D39: 8bc1             mov ax, cx
  03C0BB  0D3B: d1e6             shl si, 1
  03C0BD  0D3D: 03f0             add si, ax
  03C0BF  0D3F: d1e6             shl si, 1
  03C0C1  0D41: 8b5eac           mov bx, word ptr [bp - 0x54]
  03C0C4  0D44: 8a805596         mov al, byte ptr [bx + si - 0x69ab]
  03C0C8  0D48: 2ae4             sub ah, ah
  03C0CA  0D4A: 01469c           add word ptr [bp - 0x64], ax
  03C0CD  0D4D: ff4696           inc word ptr [bp - 0x6a]
  03C0D0  0D50: 837e9619         cmp word ptr [bp - 0x6a], 0x19
  03C0D4  0D54: 7cbb             jl 0xd11
  03C0D6  0D56: ff769c           push word ptr [bp - 0x64]
  03C0D9  0D59: 6a01             push 1
  03C0DB  0D5B: 9ad4041f18       lcall 0x181f, 0x4d4
  03C0E0  0D60: 83c404           add sp, 4
  03C0E3  0D63: 89469e           mov word ptr [bp - 0x62], ax
  03C0E6  0D66: c7469affff       mov word ptr [bp - 0x66], 0xffff
  03C0EB  0D6B: c746960000       mov word ptr [bp - 0x6a], 0
  03C0F0  0D70: e959ff           jmp 0xccc
  03C0F3  0D73: 90               nop 
  03C0F4  0D74: ff7606           push word ptr [bp + 6]
  03C0F7  0D77: 0e               push cs
  03C0F8  0D78: e81003           call 0x108b
  03C0FB  0D7B: 83c402           add sp, 2
  03C0FE  0D7E: 8946aa           mov word ptr [bp - 0x56], ax
  03C101  0D81: 837e0604         cmp word ptr [bp + 6], 4
  03C105  0D85: 7c03             jl 0xd8a
  03C107  0D87: e95401           jmp 0xede
  03C10A  0D8A: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  03C10E  0D8E: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03C113  0D93: 7403             je 0xd98
  03C115  0D95: e94601           jmp 0xede
  03C118  0D98: 837efe00         cmp word ptr [bp - 2], 0
  03C11C  0D9C: 7503             jne 0xda1
  03C11E  0D9E: e94b01           jmp 0xeec
  03C121  0DA1: 6a03             push 3
  03C123  0DA3: 9aac041f18       lcall 0x181f, 0x4ac
  03C128  0DA8: 83c402           add sp, 2
  03C12B  0DAB: 8d1e7c08         lea bx, [0x87c]
  03C12F  0DAF: 8d066212         lea ax, [0x1262]
  03C133  0DB3: 2bd2             sub dx, dx
  03C135  0DB5: 9a82011f19       lcall 0x191f, 0x182
  03C13A  0DBA: 8946a2           mov word ptr [bp - 0x5e], ax
  03C13D  0DBD: 8956a4           mov word ptr [bp - 0x5c], dx
  03C140  0DC0: 0bd0             or dx, ax
  03C142  0DC2: 7503             jne 0xdc7
  03C144  0DC4: e92501           jmp 0xeec
  03C147  0DC7: c45ea2           les bx, ptr [bp - 0x5e]
  03C14A  0DCA: 26c747220800     mov word ptr es:[bx + 0x22], 8
  03C150  0DD0: 837efe00         cmp word ptr [bp - 2], 0
  03C154  0DD4: 7503             jne 0xdd9
  03C156  0DD6: e9b100           jmp 0xe8a
  03C159  0DD9: c746980000       mov word ptr [bp - 0x68], 0
  03C15E  0DDE: ff7698           push word ptr [bp - 0x68]
  03C161  0DE1: ff7606           push word ptr [bp + 6]
  03C164  0DE4: 0e               push cs
  03C165  0DE5: e8b702           call 0x109f
  03C168  0DE8: 83c404           add sp, 4
  03C16B  0DEB: 0bc0             or ax, ax
  03C16D  0DED: 7503             jne 0xdf2
  03C16F  0DEF: e98c00           jmp 0xe7e
  03C172  0DF2: c646ae00         mov byte ptr [bp - 0x52], 0
  03C176  0DF6: 8b7698           mov si, word ptr [bp - 0x68]
  03C179  0DF9: d1e6             shl si, 1
  03C17B  0DFB: 8b5a8c           mov bx, word ptr [bp + si - 0x74]
  03C17E  0DFE: 8bc3             mov ax, bx
  03C180  0E00: d1e3             shl bx, 1
  03C182  0E02: 03d8             add bx, ax
  03C184  0E04: d1e3             shl bx, 1
  03C186  0E06: ffb75296         push word ptr [bx - 0x69ae]
  03C18A  0E0A: 8d46ae           lea ax, [bp - 0x52]
  03C18D  0E0D: 50               push ax
  03C18E  0E0E: 9a6e011f18       lcall 0x181f, 0x16e
  03C193  0E13: 83c404           add sp, 4
  03C196  0E16: 8d46ae           lea ax, [bp - 0x52]
  03C199  0E19: 50               push ax
  03C19A  0E1A: 9a78011f18       lcall 0x181f, 0x178
  03C19F  0E1F: 83c402           add sp, 2
  03C1A2  0E22: 8d46ae           lea ax, [bp - 0x52]
  03C1A5  0E25: 50               push ax
  03C1A6  0E26: 9a1e011f18       lcall 0x181f, 0x11e
  03C1AB  0E2B: 83c402           add sp, 2
  03C1AE  0E2E: ffb4e896         push word ptr [si - 0x6918]
  03C1B2  0E32: 8d46ae           lea ax, [bp - 0x52]
  03C1B5  0E35: 50               push ax
  03C1B6  0E36: 9a6e011f18       lcall 0x181f, 0x16e
  03C1BB  0E3B: 83c404           add sp, 4
  03C1BE  0E3E: 8d46ae           lea ax, [bp - 0x52]
  03C1C1  0E41: 50               push ax
  03C1C2  0E42: 9a78011f18       lcall 0x181f, 0x178
  03C1C7  0E47: 83c402           add sp, 2
  03C1CA  0E4A: ff36882e         push word ptr [0x2e88]
  03C1CE  0E4E: 8d46ae           lea ax, [bp - 0x52]
  03C1D1  0E51: 50               push ax
  03C1D2  0E52: 9a6e011f18       lcall 0x181f, 0x16e
  03C1D7  0E57: 83c404           add sp, 4
  03C1DA  0E5A: 8d46ae           lea ax, [bp - 0x52]
  03C1DD  0E5D: 50               push ax
  03C1DE  0E5E: 9a28011f18       lcall 0x181f, 0x128
  03C1E3  0E63: 83c402           add sp, 2
  03C1E6  0E66: 8b4698           mov ax, word ptr [bp - 0x68]
  03C1E9  0E69: 40               inc ax
  03C1EA  0E6A: 50               push ax
  03C1EB  0E6B: 8d46ae           lea ax, [bp - 0x52]
  03C1EE  0E6E: 16               push ss
  03C1EF  0E6F: 50               push ax
  03C1F0  0E70: ff76a4           push word ptr [bp - 0x5c]
  03C1F3  0E73: ff76a2           push word ptr [bp - 0x5e]
  03C1F6  0E76: 9a76011f19       lcall 0x191f, 0x176
  03C1FB  0E7B: 83c40a           add sp, 0xa
  03C1FE  0E7E: ff4698           inc word ptr [bp - 0x68]
  03C201  0E81: 837e9805         cmp word ptr [bp - 0x68], 5
  03C205  0E85: 7d03             jge 0xe8a
  03C207  0E87: e954ff           jmp 0xdde
  03C20A  0E8A: c706661f0100     mov word ptr [0x1f66], 1
  03C210  0E90: ff76a4           push word ptr [bp - 0x5c]
  03C213  0E93: ff76a2           push word ptr [bp - 0x5e]
  03C216  0E96: 9a6a011f19       lcall 0x191f, 0x16a
  03C21B  0E9B: 8946a8           mov word ptr [bp - 0x58], ax
  03C21E  0E9E: ff76a4           push word ptr [bp - 0x5c]
  03C221  0EA1: ff76a2           push word ptr [bp - 0x5e]
  03C224  0EA4: 9aa8011f19       lcall 0x191f, 0x1a8
  03C229  0EA9: 2bc0             sub ax, ax
  03C22B  0EAB: 8946a4           mov word ptr [bp - 0x5c], ax
  03C22E  0EAE: 8946a2           mov word ptr [bp - 0x5e], ax
  03C231  0EB1: 3946a8           cmp word ptr [bp - 0x58], ax
  03C234  0EB4: 7f03             jg 0xeb9
  03C236  0EB6: e9f2fe           jmp 0xdab
  03C239  0EB9: 8b46a8           mov ax, word ptr [bp - 0x58]
  03C23C  0EBC: 48               dec ax
  03C23D  0EBD: 8946aa           mov word ptr [bp - 0x56], ax
  03C240  0EC0: 833e681f00       cmp word ptr [0x1f68], 0
  03C245  0EC5: 7417             je 0xede
  03C247  0EC7: 8bf0             mov si, ax
  03C249  0EC9: d1e6             shl si, 1
  03C24B  0ECB: ff728c           push word ptr [bp + si - 0x74]
  03C24E  0ECE: 9a62001f1a       lcall 0x1a1f, 0x62
  03C253  0ED3: 83c402           add sp, 2
  03C256  0ED6: 9a6a051f18       lcall 0x181f, 0x56a
  03C25B  0EDB: e9cdfe           jmp 0xdab
  03C25E  0EDE: 8bf0             mov si, ax
  03C260  0EE0: d1e6             shl si, 1
  03C262  0EE2: 8b428c           mov ax, word ptr [bp + si - 0x74]
  03C265  0EE5: 8b1efc84         mov bx, word ptr [0x84fc]
  03C269  0EE9: 894712           mov word ptr [bx + 0x12], ax
  03C26C  0EEC: 8b46a4           mov ax, word ptr [bp - 0x5c]
  03C26F  0EEF: 0b46a2           or ax, word ptr [bp - 0x5e]
  03C272  0EF2: 740b             je 0xeff
  03C274  0EF4: ff76a4           push word ptr [bp - 0x5c]
  03C277  0EF7: ff76a2           push word ptr [bp - 0x5e]
  03C27A  0EFA: 9aa8011f19       lcall 0x191f, 0x1a8
  03C27F  0EFF: 5e               pop si
  03C280  0F00: c9               leave 
  03C281  0F01: cb               retf 

; ---- func_03C282  size=160  insns=56  prologue=ENTER 0x0004,0  terminal=RETF ----
  03C282  0F02: c8040000         enter 4, 0
  03C286  0F06: 837e0604         cmp word ptr [bp + 6], 4
  03C28A  0F0A: 7d18             jge 0xf24
  03C28C  0F0C: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  03C290  0F10: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03C295  0F15: 750d             jne 0xf24
  03C297  0F17: a0a653           mov al, byte ptr [0x53a6]
  03C29A  0F1A: 2ae4             sub ah, ah
  03C29C  0F1C: 050300           add ax, 3
  03C29F  0F1F: d1e0             shl ax, 1
  03C2A1  0F21: eb0b             jmp 0xf2e
  03C2A3  0F23: 90               nop 
  03C2A4  0F24: a0a653           mov al, byte ptr [0x53a6]
  03C2A7  0F27: 2ae4             sub ah, ah
  03C2A9  0F29: 2d0e00           sub ax, 0xe
  03C2AC  0F2C: f7d8             neg ax
  03C2AE  0F2E: 8946fc           mov word ptr [bp - 4], ax
  03C2B1  0F31: c166fc03         shl word ptr [bp - 4], 3
  03C2B5  0F35: 813e8a534006     cmp word ptr [0x538a], 0x640
  03C2BB  0F3B: 7c08             jl 0xf45
  03C2BD  0F3D: 8b46fc           mov ax, word ptr [bp - 4]
  03C2C0  0F40: d1f8             sar ax, 1
  03C2C2  0F42: 0146fc           add word ptr [bp - 4], ax
  03C2C5  0F45: 813e8a537206     cmp word ptr [0x538a], 0x672
  03C2CB  0F4B: 7c08             jl 0xf55
  03C2CD  0F4D: 8b46fc           mov ax, word ptr [bp - 4]
  03C2D0  0F50: d1f8             sar ax, 1
  03C2D2  0F52: 0146fc           add word ptr [bp - 4], ax
  03C2D5  0F55: 813e8a53a406     cmp word ptr [0x538a], 0x6a4
  03C2DB  0F5B: 7c08             jl 0xf65
  03C2DD  0F5D: 8b46fc           mov ax, word ptr [bp - 4]
  03C2E0  0F60: d1f8             sar ax, 1
  03C2E2  0F62: 0146fc           add word ptr [bp - 4], ax
  03C2E5  0F65: 813e8a53d606     cmp word ptr [0x538a], 0x6d6
  03C2EB  0F6B: 7c08             jl 0xf75
  03C2ED  0F6D: 8b46fc           mov ax, word ptr [bp - 4]
  03C2F0  0F70: d1f8             sar ax, 1
  03C2F2  0F72: 0146fc           add word ptr [bp - 4], ax
  03C2F5  0F75: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  03C2FA  0F7A: 8a871c88         mov al, byte ptr [bx - 0x77e4]
  03C2FE  0F7E: 8bc8             mov cx, ax
  03C300  0F80: 2ae4             sub ah, ah
  03C302  0F82: 40               inc ax
  03C303  0F83: f76efc           imul word ptr [bp - 4]
  03C306  0F86: 40               inc ax
  03C307  0F87: 0ac9             or cl, cl
  03C309  0F89: 7502             jne 0xf8d
  03C30B  0F8B: d1f8             sar ax, 1
  03C30D  0F8D: f606825301       test byte ptr [0x5382], 1
  03C312  0F92: 740c             je 0xfa0
  03C314  0F94: a0a653           mov al, byte ptr [0x53a6]
  03C317  0F97: 2ae4             sub ah, ah
  03C319  0F99: 69c0dc05         imul ax, ax, 0x5dc
  03C31D  0F9D: 05d007           add ax, 0x7d0
  03C320  0FA0: c9               leave 
  03C321  0FA1: cb               retf 

; ---- func_03C322  size=258  insns=84  prologue=push bp;mov bp,sp  terminal=JMP-tail ----
  03C322  0FA2: 55               push bp
  03C323  0FA3: 8bec             mov bp, sp
  03C325  0FA5: ff7606           push word ptr [bp + 6]
  03C328  0FA8: 9a82051f18       lcall 0x181f, 0x582
  03C32D  0FAD: 8be5             mov sp, bp
  03C32F  0FAF: 8b4608           mov ax, word ptr [bp + 8]
  03C332  0FB2: 8b1efc84         mov bx, word ptr [0x84fc]
  03C336  0FB6: 01470c           add word ptr [bx + 0xc], ax
  03C339  0FB9: 01470e           add word ptr [bx + 0xe], ax
  03C33C  0FBC: f606825301       test byte ptr [0x5382], 1
  03C341  0FC1: 750f             jne 0xfd2
  03C343  0FC3: 837f1200         cmp word ptr [bx + 0x12], 0
  03C347  0FC7: 7d09             jge 0xfd2
  03C349  0FC9: ff7606           push word ptr [bp + 6]
  03C34C  0FCC: 0e               push cs
  03C34D  0FCD: e8b100           call 0x1081
  03C350  0FD0: 8be5             mov sp, bp
  03C352  0FD2: f606825301       test byte ptr [0x5382], 1
  03C357  0FD7: 7454             je 0x102d
  03C359  0FD9: f606825306       test byte ptr [0x5382], 6
  03C35E  0FDE: 754d             jne 0x102d
  03C360  0FE0: 8b4608           mov ax, word ptr [bp + 8]
  03C363  0FE3: 8b1efc84         mov bx, word ptr [0x84fc]
  03C367  0FE7: 39470c           cmp word ptr [bx + 0xc], ax
  03C36A  0FEA: 7e41             jle 0x102d
  03C36C  0FEC: ff36d453         push word ptr [0x53d4]
  03C370  0FF0: 6a01             push 1
  03C372  0FF2: 6a00             push 0
  03C374  0FF4: 9ac80a1f19       lcall 0x191f, 0xac8
  03C379  0FF9: 8be5             mov sp, bp
  03C37B  0FFB: ff7606           push word ptr [bp + 6]
  03C37E  0FFE: 0e               push cs
  03C37F  0FFF: e87000           call 0x1072
  03C382  1002: 8be5             mov sp, bp
  03C384  1004: 99               cdq 
  03C385  1005: 52               push dx
  03C386  1006: 50               push ax
  03C387  1007: 6a00             push 0
  03C389  1009: 9aae091f18       lcall 0x181f, 0x9ae
  03C38E  100E: 8be5             mov sp, bp
  03C390  1010: 6a01             push 1
  03C392  1012: 686f12           push 0x126f
  03C395  1015: 9a52061f18       lcall 0x181f, 0x652
  03C39A  101A: 8be5             mov sp, bp
  03C39C  101C: 6a01             push 1
  03C39E  101E: 687a12           push 0x127a
  03C3A1  1021: 9a52061f18       lcall 0x181f, 0x652
  03C3A6  1026: 8be5             mov sp, bp
  03C3A8  1028: 800e825304       or byte ptr [0x5382], 4
  03C3AD  102D: ff7606           push word ptr [bp + 6]
  03C3B0  1030: 0e               push cs
  03C3B1  1031: e83e00           call 0x1072
  03C3B4  1034: 8be5             mov sp, bp
  03C3B6  1036: 8b1efc84         mov bx, word ptr [0x84fc]
  03C3BA  103A: 3b470c           cmp ax, word ptr [bx + 0xc]
  03C3BD  103D: 7f30             jg 0x106f
  03C3BF  103F: f606825301       test byte ptr [0x5382], 1
  03C3C4  1044: 740e             je 0x1054
  03C3C6  1046: f606825302       test byte ptr [0x5382], 2
  03C3CB  104B: 7522             jne 0x106f
  03C3CD  104D: 9a48031f19       lcall 0x191f, 0x348
  03C3D2  1052: eb12             jmp 0x1066
  03C3D4  1054: 837f1200         cmp word ptr [bx + 0x12], 0
  03C3D8  1058: 7c0c             jl 0x1066
  03C3DA  105A: 6a00             push 0
  03C3DC  105C: ff7712           push word ptr [bx + 0x12]
  03C3DF  105F: ff7606           push word ptr [bp + 6]
  03C3E2  1062: 0e               push cs
  03C3E3  1063: e81600           call 0x107c
  03C3E6  1066: 8b1efc84         mov bx, word ptr [0x84fc]
  03C3EA  106A: c7470c0000       mov word ptr [bx + 0xc], 0
  03C3EF  106F: c9               leave 
  03C3F0  1070: cb               retf 
  03C3F1  1071: 90               nop 
  03C3F2  1072: ea660f1f19       ljmp 0x191f:0xf66
  03C3F7  1077: ea740f1f19       ljmp 0x191f:0xf74
  03C3FC  107C: eaec0f1f19       ljmp 0x191f:0xfec
  03C401  1081: ea00001f1a       ljmp 0x1a1f:0
  03C406  1086: ea0e001f1a       ljmp 0x1a1f:0xe
  03C40B  108B: ea1c001f1a       ljmp 0x1a1f:0x1c
  03C410  1090: ea2a001f1a       ljmp 0x1a1f:0x2a
  03C415  1095: ea38001f1a       ljmp 0x1a1f:0x38
  03C41A  109A: ea46001f1a       ljmp 0x1a1f:0x46
  03C41F  109F: ea54001f1a       ljmp 0x1a1f:0x54

; ---- func_03C424  size=126  insns=51  prologue=ENTER 0x000A,0  terminal=RETF ----
  03C424  10A4: c80a0000         enter 0xa, 0
  03C428  10A8: 57               push di
  03C429  10A9: 56               push si
  03C42A  10AA: 2bc0             sub ax, ax
  03C42C  10AC: 8946f8           mov word ptr [bp - 8], ax
  03C42F  10AF: 8946f6           mov word ptr [bp - 0xa], ax
  03C432  10B2: 8946fe           mov word ptr [bp - 2], ax
  03C435  10B5: 8946fc           mov word ptr [bp - 4], ax
  03C438  10B8: 8946fa           mov word ptr [bp - 6], ax
  03C43B  10BB: eb3f             jmp 0x10fc
  03C43D  10BD: 90               nop 
  03C43E  10BE: ff76fa           push word ptr [bp - 6]
  03C441  10C1: 9ae6091f18       lcall 0x181f, 0x9e6
  03C446  10C6: 83c402           add sp, 2
  03C449  10C9: 8a4606           mov al, byte ptr [bp + 6]
  03C44C  10CC: 8b1e4285         mov bx, word ptr [0x8542]
  03C450  10D0: 38471a           cmp byte ptr [bx + 0x1a], al
  03C453  10D3: 7524             jne 0x10f9
  03C455  10D5: 8a471f           mov al, byte ptr [bx + 0x1f]
  03C458  10D8: 98               cwde 
  03C459  10D9: 99               cdq 
  03C45A  10DA: 0146f6           add word ptr [bp - 0xa], ax
  03C45D  10DD: 1156f8           adc word ptr [bp - 8], dx
  03C460  10E0: 8bf0             mov si, ax
  03C462  10E2: 8bfa             mov di, dx
  03C464  10E4: 9a860c1f18       lcall 0x181f, 0xc86
  03C469  10E9: 99               cdq 
  03C46A  10EA: 52               push dx
  03C46B  10EB: 50               push ax
  03C46C  10EC: 57               push di
  03C46D  10ED: 56               push si
  03C46E  10EE: 9a600f1d0d       lcall 0xd1d, 0xf60
  03C473  10F3: 0146fc           add word ptr [bp - 4], ax
  03C476  10F6: 1156fe           adc word ptr [bp - 2], dx
  03C479  10F9: ff46fa           inc word ptr [bp - 6]
  03C47C  10FC: a19e53           mov ax, word ptr [0x539e]
  03C47F  10FF: 3946fa           cmp word ptr [bp - 6], ax
  03C482  1102: 7cba             jl 0x10be
  03C484  1104: 8b46f8           mov ax, word ptr [bp - 8]
  03C487  1107: 0b46f6           or ax, word ptr [bp - 0xa]
  03C48A  110A: 740f             je 0x111b
  03C48C  110C: ff76f8           push word ptr [bp - 8]
  03C48F  110F: ff76f6           push word ptr [bp - 0xa]
  03C492  1112: 8d46fc           lea ax, [bp - 4]
  03C495  1115: 50               push ax
  03C496  1116: 9a920f1d0d       lcall 0xd1d, 0xf92
  03C49B  111B: 8b46fc           mov ax, word ptr [bp - 4]
  03C49E  111E: 5e               pop si
  03C49F  111F: 5f               pop di
  03C4A0  1120: c9               leave 
  03C4A1  1121: cb               retf 

; ---- func_03C4A2  size=134  insns=53  prologue=ENTER 0x0002,0  terminal=RETF ----
  03C4A2  1122: c8020000         enter 2, 0
  03C4A6  1126: 8b4606           mov ax, word ptr [bp + 6]
  03C4A9  1129: 48               dec ax
  03C4AA  112A: 7444             je 0x1170
  03C4AC  112C: 48               dec ax
  03C4AD  112D: 742d             je 0x115c
  03C4AF  112F: 48               dec ax
  03C4B0  1130: 7434             je 0x1166
  03C4B2  1132: 837e0804         cmp word ptr [bp + 8], 4
  03C4B6  1136: 7d66             jge 0x119e
  03C4B8  1138: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  03C4BC  113C: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03C4C1  1141: 755b             jne 0x119e
  03C4C3  1143: a08253           mov al, byte ptr [0x5382]
  03C4C6  1146: 250100           and ax, 1
  03C4C9  1149: 3d0100           cmp ax, 1
  03C4CC  114C: 1bc0             sbb ax, ax
  03C4CE  114E: 24fb             and al, 0xfb
  03C4D0  1150: 050900           add ax, 9
  03C4D3  1153: 8946fe           mov word ptr [bp - 2], ax
  03C4D6  1156: 8b46fe           mov ax, word ptr [bp - 2]
  03C4D9  1159: c9               leave 
  03C4DA  115A: cb               retf 
  03C4DB  115B: 90               nop 
  03C4DC  115C: c746fe1200       mov word ptr [bp - 2], 0x12
  03C4E1  1161: 8b46fe           mov ax, word ptr [bp - 2]
  03C4E4  1164: c9               leave 
  03C4E5  1165: cb               retf 
  03C4E6  1166: c746fe0b00       mov word ptr [bp - 2], 0xb
  03C4EB  116B: 8b46fe           mov ax, word ptr [bp - 2]
  03C4EE  116E: c9               leave 
  03C4EF  116F: cb               retf 
  03C4F0  1170: 837e0804         cmp word ptr [bp + 8], 4
  03C4F4  1174: 7d1e             jge 0x1194
  03C4F6  1176: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  03C4FA  117A: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03C4FF  117F: 7513             jne 0x1194
  03C501  1181: a08253           mov al, byte ptr [0x5382]
  03C504  1184: 250100           and ax, 1
  03C507  1187: 3d0100           cmp ax, 1
  03C50A  118A: 1bc0             sbb ax, ax
  03C50C  118C: 24fd             and al, 0xfd
  03C50E  118E: 050700           add ax, 7
  03C511  1191: ebc0             jmp 0x1153
  03C513  1193: 90               nop 
  03C514  1194: c746fe0800       mov word ptr [bp - 2], 8
  03C519  1199: 8b46fe           mov ax, word ptr [bp - 2]
  03C51C  119C: c9               leave 
  03C51D  119D: cb               retf 
  03C51E  119E: c746fe0600       mov word ptr [bp - 2], 6
  03C523  11A3: 8b46fe           mov ax, word ptr [bp - 2]
  03C526  11A6: c9               leave 
  03C527  11A7: cb               retf 

; ---- func_03C528  size=128  insns=41  prologue=ENTER 0x0002,0  terminal=RETF ----
  03C528  11A8: c8020000         enter 2, 0
  03C52C  11AC: 6a0b             push 0xb
  03C52E  11AE: ff369853         push word ptr [0x5398]
  03C532  11B2: ff7606           push word ptr [bp + 6]
  03C535  11B5: 9a100a1f18       lcall 0x181f, 0xa10
  03C53A  11BA: 83c406           add sp, 6
  03C53D  11BD: 6a0b             push 0xb
  03C53F  11BF: ff36d253         push word ptr [0x53d2]
  03C543  11C3: ff7606           push word ptr [bp + 6]
  03C546  11C6: 9a100a1f18       lcall 0x181f, 0xa10
  03C54B  11CB: 83c406           add sp, 6
  03C54E  11CE: 6a60             push 0x60
  03C550  11D0: ff369853         push word ptr [0x5398]
  03C554  11D4: ff7606           push word ptr [bp + 6]
  03C557  11D7: 9a060a1f18       lcall 0x181f, 0xa06
  03C55C  11DC: 83c406           add sp, 6
  03C55F  11DF: 6a60             push 0x60
  03C561  11E1: ff36d253         push word ptr [0x53d2]
  03C565  11E5: ff7606           push word ptr [bp + 6]
  03C568  11E8: 9a060a1f18       lcall 0x181f, 0xa06
  03C56D  11ED: 83c406           add sp, 6
  03C570  11F0: a19c53           mov ax, word ptr [0x539c]
  03C573  11F3: 48               dec ax
  03C574  11F4: 8946fe           mov word ptr [bp - 2], ax
  03C577  11F7: eb1e             jmp 0x1217
  03C579  11F9: 90               nop 
  03C57A  11FA: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  03C57E  11FE: 8a874731         mov al, byte ptr [bx + 0x3147]
  03C582  1202: 240f             and al, 0xf
  03C584  1204: 3a4606           cmp al, byte ptr [bp + 6]
  03C587  1207: 750b             jne 0x1214
  03C589  1209: ff76fe           push word ptr [bp - 2]
  03C58C  120C: 9a08081f18       lcall 0x181f, 0x808
  03C591  1211: 83c402           add sp, 2
  03C594  1214: ff4efe           dec word ptr [bp - 2]
  03C597  1217: 837efe00         cmp word ptr [bp - 2], 0
  03C59B  121B: 7ddd             jge 0x11fa
  03C59D  121D: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  03C5A1  1221: c6873f5402       mov byte ptr [bx + 0x543f], 2
  03C5A6  1226: c9               leave 
  03C5A7  1227: cb               retf 

; ---- func_03C5A8  size=143  insns=53  prologue=ENTER 0x0002,0  terminal=RETF ----
  03C5A8  1228: c8020000         enter 2, 0
  03C5AC  122C: 56               push si
  03C5AD  122D: a19c53           mov ax, word ptr [0x539c]
  03C5B0  1230: 48               dec ax
  03C5B1  1231: 8946fe           mov word ptr [bp - 2], ax
  03C5B4  1234: eb78             jmp 0x12ae
  03C5B6  1236: 90               nop 
  03C5B7  1237: 90               nop 
  03C5B8  1238: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  03C5BC  123C: 8a874731         mov al, byte ptr [bx + 0x3147]
  03C5C0  1240: 240f             and al, 0xf
  03C5C2  1242: 3a4606           cmp al, byte ptr [bp + 6]
  03C5C5  1245: 7564             jne 0x12ab
  03C5C7  1247: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  03C5CB  124B: 8a874531         mov al, byte ptr [bx + 0x3145]
  03C5CF  124F: 2ae4             sub ah, ah
  03C5D1  1251: 50               push ax
  03C5D2  1252: 8a874431         mov al, byte ptr [bx + 0x3144]
  03C5D6  1256: 50               push ax
  03C5D7  1257: 8bf3             mov si, bx
  03C5D9  1259: 9a02031f18       lcall 0x181f, 0x302
  03C5DE  125E: 83c404           add sp, 4
  03C5E1  1261: 0bc0             or ax, ax
  03C5E3  1263: 7546             jne 0x12ab
  03C5E5  1265: 80bc46310d       cmp byte ptr [si + 0x3146], 0xd
  03C5EA  126A: 7234             jb 0x12a0
  03C5EC  126C: 80bc463112       cmp byte ptr [si + 0x3146], 0x12
  03C5F1  1271: 772d             ja 0x12a0
  03C5F3  1273: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  03C5F7  1277: 2aff             sub bh, bh
  03C5F9  1279: 8bc3             mov ax, bx
  03C5FB  127B: d1e3             shl bx, 1
  03C5FD  127D: 03d8             add bx, ax
  03C5FF  127F: d1e3             shl bx, 1
  03C601  1281: 03d8             add bx, ax
  03C603  1283: d1e3             shl bx, 1
  03C605  1285: ffb73052         push word ptr [bx + 0x5230]
  03C609  1289: 6a00             push 0
  03C60B  128B: 9a38041f18       lcall 0x181f, 0x438
  03C610  1290: 83c404           add sp, 4
  03C613  1293: 6a00             push 0
  03C615  1295: 688412           push 0x1284
  03C618  1298: 9a52061f18       lcall 0x181f, 0x652
  03C61D  129D: 83c404           add sp, 4
  03C620  12A0: ff76fe           push word ptr [bp - 2]
  03C623  12A3: 9a08081f18       lcall 0x181f, 0x808
  03C628  12A8: 83c402           add sp, 2
  03C62B  12AB: ff4efe           dec word ptr [bp - 2]
  03C62E  12AE: 837efe00         cmp word ptr [bp - 2], 0
  03C632  12B2: 7d84             jge 0x1238
  03C634  12B4: 5e               pop si
  03C635  12B5: c9               leave 
  03C636  12B6: cb               retf 

; ---- func_03C638  size=762  insns=265  prologue=ENTER 0x0024,0  terminal=RETF ----
  03C638  12B8: c8240000         enter 0x24, 0
  03C63C  12BC: 56               push si
  03C63D  12BD: f606815380       test byte ptr [0x5381], 0x80
  03C642  12C2: 7403             je 0x12c7
  03C644  12C4: e9e802           jmp 0x15af
  03C647  12C7: c746f00000       mov word ptr [bp - 0x10], 0
  03C64C  12CC: 8a46f0           mov al, byte ptr [bp - 0x10]
  03C64F  12CF: 8b76f0           mov si, word ptr [bp - 0x10]
  03C652  12D2: 8842ec           mov byte ptr [bp + si - 0x14], al
  03C655  12D5: 8a841894         mov al, byte ptr [si - 0x6be8]
  03C659  12D9: 2ae4             sub ah, ah
  03C65B  12DB: 8bc8             mov cx, ax
  03C65D  12DD: d1e0             shl ax, 1
  03C65F  12DF: 03c1             add ax, cx
  03C661  12E1: 8a8c9892         mov cl, byte ptr [si - 0x6d68]
  03C665  12E5: 2aed             sub ch, ch
  03C667  12E7: d1e1             shl cx, 1
  03C669  12E9: 03c1             add ax, cx
  03C66B  12EB: 8a8c1094         mov cl, byte ptr [si - 0x6bf0]
  03C66F  12EF: 2aed             sub ch, ch
  03C671  12F1: 03c1             add ax, cx
  03C673  12F3: d1e6             shl si, 1
  03C675  12F5: 8942e4           mov word ptr [bp + si - 0x1c], ax
  03C678  12F8: ff46f0           inc word ptr [bp - 0x10]
  03C67B  12FB: 837ef004         cmp word ptr [bp - 0x10], 4
  03C67F  12FF: 7ccb             jl 0x12cc
  03C681  1301: 8d46ec           lea ax, [bp - 0x14]
  03C684  1304: 16               push ss
  03C685  1305: 50               push ax
  03C686  1306: 8d46e4           lea ax, [bp - 0x1c]
  03C689  1309: 16               push ss
  03C68A  130A: 50               push ax
  03C68B  130B: b80400           mov ax, 4
  03C68E  130E: 9ad00e1f19       lcall 0x191f, 0xed0
  03C693  1313: b8ffff           mov ax, 0xffff
  03C696  1316: 8946f8           mov word ptr [bp - 8], ax
  03C699  1319: 8946f6           mov word ptr [bp - 0xa], ax
  03C69C  131C: c746f00000       mov word ptr [bp - 0x10], 0
  03C6A1  1321: eb29             jmp 0x134c
  03C6A3  1323: 90               nop 
  03C6A4  1324: 837ef004         cmp word ptr [bp - 0x10], 4
  03C6A8  1328: 7d28             jge 0x1352
  03C6AA  132A: 8b76f0           mov si, word ptr [bp - 0x10]
  03C6AD  132D: 807aec04         cmp byte ptr [bp + si - 0x14], 4
  03C6B1  1331: 730e             jae 0x1341
  03C6B3  1333: 8a42ec           mov al, byte ptr [bp + si - 0x14]
  03C6B6  1336: 2ae4             sub ah, ah
  03C6B8  1338: 6bd834           imul bx, ax, 0x34
  03C6BB  133B: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  03C6BF  133F: 7408             je 0x1349
  03C6C1  1341: 8a42ec           mov al, byte ptr [bp + si - 0x14]
  03C6C4  1344: 2ae4             sub ah, ah
  03C6C6  1346: 8946f6           mov word ptr [bp - 0xa], ax
  03C6C9  1349: ff46f0           inc word ptr [bp - 0x10]
  03C6CC  134C: 837ef600         cmp word ptr [bp - 0xa], 0
  03C6D0  1350: 7cd2             jl 0x1324
  03C6D2  1352: c746f00000       mov word ptr [bp - 0x10], 0
  03C6D7  1357: eb31             jmp 0x138a
  03C6D9  1359: 90               nop 
  03C6DA  135A: 837ef004         cmp word ptr [bp - 0x10], 4
  03C6DE  135E: 7d30             jge 0x1390
  03C6E0  1360: 8a46f6           mov al, byte ptr [bp - 0xa]
  03C6E3  1363: 8b76f0           mov si, word ptr [bp - 0x10]
  03C6E6  1366: 3842ec           cmp byte ptr [bp + si - 0x14], al
  03C6E9  1369: 741c             je 0x1387
  03C6EB  136B: 807aec04         cmp byte ptr [bp + si - 0x14], 4
  03C6EF  136F: 730e             jae 0x137f
  03C6F1  1371: 8a42ec           mov al, byte ptr [bp + si - 0x14]
  03C6F4  1374: 2ae4             sub ah, ah
  03C6F6  1376: 6bd834           imul bx, ax, 0x34
  03C6F9  1379: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  03C6FD  137D: 7408             je 0x1387
  03C6FF  137F: 8a42ec           mov al, byte ptr [bp + si - 0x14]
  03C702  1382: 2ae4             sub ah, ah
  03C704  1384: 8946f8           mov word ptr [bp - 8], ax
  03C707  1387: ff46f0           inc word ptr [bp - 0x10]
  03C70A  138A: 837ef800         cmp word ptr [bp - 8], 0
  03C70E  138E: 7cca             jl 0x135a
  03C710  1390: 6a03             push 3
  03C712  1392: 9aac041f18       lcall 0x181f, 0x4ac
  03C717  1397: 83c402           add sp, 2
  03C71A  139A: ff76f6           push word ptr [bp - 0xa]
  03C71D  139D: 6a01             push 1
  03C71F  139F: 6a00             push 0
  03C721  13A1: 9ac80a1f19       lcall 0x191f, 0xac8
  03C726  13A6: 83c406           add sp, 6
  03C729  13A9: 6b46f634         imul ax, word ptr [bp - 0xa], 0x34
  03C72D  13AD: 052654           add ax, 0x5426
  03C730  13B0: 1e               push ds
  03C731  13B1: 50               push ax
  03C732  13B2: 6a01             push 1
  03C734  13B4: 9a16041f18       lcall 0x181f, 0x416
  03C739  13B9: 83c406           add sp, 6
  03C73C  13BC: ff76f8           push word ptr [bp - 8]
  03C73F  13BF: 9a1a0a1f18       lcall 0x181f, 0xa1a
  03C744  13C4: 83c402           add sp, 2
  03C747  13C7: 50               push ax
  03C748  13C8: 6a02             push 2
  03C74A  13CA: 9a38041f18       lcall 0x181f, 0x438
  03C74F  13CF: 83c404           add sp, 4
  03C752  13D2: ff76f6           push word ptr [bp - 0xa]
  03C755  13D5: 9a1a0a1f18       lcall 0x181f, 0xa1a
  03C75A  13DA: 83c402           add sp, 2
  03C75D  13DD: 50               push ax
  03C75E  13DE: 6a03             push 3
  03C760  13E0: 9a38041f18       lcall 0x181f, 0x438
  03C765  13E5: 83c404           add sp, 4
  03C768  13E8: 6a02             push 2
  03C76A  13EA: 688c12           push 0x128c
  03C76D  13ED: 9a52061f18       lcall 0x181f, 0x652
  03C772  13F2: 83c404           add sp, 4
  03C775  13F5: 6a00             push 0
  03C777  13F7: 6a00             push 0
  03C779  13F9: 9a36071f18       lcall 0x181f, 0x736
  03C77E  13FE: 83c404           add sp, 4
  03C781  1401: 8946de           mov word ptr [bp - 0x22], ax
  03C784  1404: 8956e0           mov word ptr [bp - 0x20], dx
  03C787  1407: 6a00             push 0
  03C789  1409: 6a00             push 0
  03C78B  140B: 9aa0061f18       lcall 0x181f, 0x6a0
  03C790  1410: 83c404           add sp, 4
  03C793  1413: 8946fc           mov word ptr [bp - 4], ax
  03C796  1416: 8956fe           mov word ptr [bp - 2], dx
  03C799  1419: 8a4ef6           mov cl, byte ptr [bp - 0xa]
  03C79C  141C: b81000           mov ax, 0x10
  03C79F  141F: d3e0             shl ax, cl
  03C7A1  1421: 8946fa           mov word ptr [bp - 6], ax
  03C7A4  1424: 8a4ef8           mov cl, byte ptr [bp - 8]
  03C7A7  1427: b81000           mov ax, 0x10
  03C7AA  142A: d3e0             shl ax, cl
  03C7AC  142C: 8946dc           mov word ptr [bp - 0x24], ax
  03C7AF  142F: c746f20000       mov word ptr [bp - 0xe], 0
  03C7B4  1434: eb47             jmp 0x147d
  03C7B6  1436: ff46f4           inc word ptr [bp - 0xc]
  03C7B9  1439: a13a85           mov ax, word ptr [0x853a]
  03C7BC  143C: 3946f4           cmp word ptr [bp - 0xc], ax
  03C7BF  143F: 7d39             jge 0x147a
  03C7C1  1441: c45ede           les bx, ptr [bp - 0x22]
  03C7C4  1444: 268a07           mov al, byte ptr es:[bx]
  03C7C7  1447: 2ae4             sub ah, ah
  03C7C9  1449: 8546fa           test word ptr [bp - 6], ax
  03C7CC  144C: 7406             je 0x1454
  03C7CE  144E: 8a46dc           mov al, byte ptr [bp - 0x24]
  03C7D1  1451: 260807           or byte ptr es:[bx], al
  03C7D4  1454: c45efc           les bx, ptr [bp - 4]
  03C7D7  1457: 268a07           mov al, byte ptr es:[bx]
  03C7DA  145A: c0e804           shr al, 4
  03C7DD  145D: 2ae4             sub ah, ah
  03C7DF  145F: 3b46f6           cmp ax, word ptr [bp - 0xa]
  03C7E2  1462: 750d             jne 0x1471
  03C7E4  1464: 2680270f         and byte ptr es:[bx], 0xf
  03C7E8  1468: 8a46f8           mov al, byte ptr [bp - 8]
  03C7EB  146B: c0e004           shl al, 4
  03C7EE  146E: 260807           or byte ptr es:[bx], al
  03C7F1  1471: ff46de           inc word ptr [bp - 0x22]
  03C7F4  1474: ff46fc           inc word ptr [bp - 4]
  03C7F7  1477: ebbd             jmp 0x1436
  03C7F9  1479: 90               nop 
  03C7FA  147A: ff46f2           inc word ptr [bp - 0xe]
  03C7FD  147D: a13c85           mov ax, word ptr [0x853c]
  03C800  1480: 3946f2           cmp word ptr [bp - 0xe], ax
  03C803  1483: 7d07             jge 0x148c
  03C805  1485: c746f40000       mov word ptr [bp - 0xc], 0
  03C80A  148A: ebad             jmp 0x1439
  03C80C  148C: a19c53           mov ax, word ptr [0x539c]
  03C80F  148F: 48               dec ax
  03C810  1490: 8946e2           mov word ptr [bp - 0x1e], ax
  03C813  1493: eb20             jmp 0x14b5
  03C815  1495: 90               nop 
  03C816  1496: 8a46f8           mov al, byte ptr [bp - 8]
  03C819  1499: 6b5ee21c         imul bx, word ptr [bp - 0x1e], 0x1c
  03C81D  149D: 88874731         mov byte ptr [bx + 0x3147], al
  03C821  14A1: ff76f8           push word ptr [bp - 8]
  03C824  14A4: ff76f2           push word ptr [bp - 0xe]
  03C827  14A7: ff76f4           push word ptr [bp - 0xc]
  03C82A  14AA: 9a04071f18       lcall 0x181f, 0x704
  03C82F  14AF: 83c406           add sp, 6
  03C832  14B2: ff4ee2           dec word ptr [bp - 0x1e]
  03C835  14B5: 837ee200         cmp word ptr [bp - 0x1e], 0
  03C839  14B9: 7c41             jl 0x14fc
  03C83B  14BB: 6b5ee21c         imul bx, word ptr [bp - 0x1e], 0x1c
  03C83F  14BF: 8a874731         mov al, byte ptr [bx + 0x3147]
  03C843  14C3: 240f             and al, 0xf
  03C845  14C5: 3a46f6           cmp al, byte ptr [bp - 0xa]
  03C848  14C8: 75e8             jne 0x14b2
  03C84A  14CA: 6b5ee21c         imul bx, word ptr [bp - 0x1e], 0x1c
  03C84E  14CE: 8a874431         mov al, byte ptr [bx + 0x3144]
  03C852  14D2: 2ae4             sub ah, ah
  03C854  14D4: 8946f4           mov word ptr [bp - 0xc], ax
  03C857  14D7: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  03C85B  14DB: 2aed             sub ch, ch
  03C85D  14DD: 894ef2           mov word ptr [bp - 0xe], cx
  03C860  14E0: 51               push cx
  03C861  14E1: 50               push ax
  03C862  14E2: 9a02031f18       lcall 0x181f, 0x302
  03C867  14E7: 83c404           add sp, 4
  03C86A  14EA: 0bc0             or ax, ax
  03C86C  14EC: 75a8             jne 0x1496
  03C86E  14EE: ff76e2           push word ptr [bp - 0x1e]
  03C871  14F1: 9a08081f18       lcall 0x181f, 0x808
  03C876  14F6: 83c402           add sp, 2
  03C879  14F9: ebb7             jmp 0x14b2
  03C87B  14FB: 90               nop 
  03C87C  14FC: a19e53           mov ax, word ptr [0x539e]
  03C87F  14FF: 48               dec ax
  03C880  1500: 8946f0           mov word ptr [bp - 0x10], ax
  03C883  1503: eb3f             jmp 0x1544
  03C885  1505: 90               nop 
  03C886  1506: ff76f0           push word ptr [bp - 0x10]
  03C889  1509: 9ae6091f18       lcall 0x181f, 0x9e6
  03C88E  150E: 83c402           add sp, 2
  03C891  1511: 8a46f6           mov al, byte ptr [bp - 0xa]
  03C894  1514: 8b1e4285         mov bx, word ptr [0x8542]
  03C898  1518: 38471a           cmp byte ptr [bx + 0x1a], al
  03C89B  151B: 7524             jne 0x1541
  03C89D  151D: 8a46f8           mov al, byte ptr [bp - 8]
  03C8A0  1520: 88471a           mov byte ptr [bx + 0x1a], al
  03C8A3  1523: 2bc0             sub ax, ax
  03C8A5  1525: 8987c400         mov word ptr [bx + 0xc4], ax
  03C8A9  1529: 8987c200         mov word ptr [bx + 0xc2], ax
  03C8AD  152D: ff76f8           push word ptr [bp - 8]
  03C8B0  1530: 8a4701           mov al, byte ptr [bx + 1]
  03C8B3  1533: 2ae4             sub ah, ah
  03C8B5  1535: 50               push ax
  03C8B6  1536: 8a07             mov al, byte ptr [bx]
  03C8B8  1538: 50               push ax
  03C8B9  1539: 9a04071f18       lcall 0x181f, 0x704
  03C8BE  153E: 83c406           add sp, 6
  03C8C1  1541: ff4ef0           dec word ptr [bp - 0x10]
  03C8C4  1544: 837ef000         cmp word ptr [bp - 0x10], 0
  03C8C8  1548: 7dbc             jge 0x1506
  03C8CA  154A: c746f00000       mov word ptr [bp - 0x10], 0
  03C8CF  154F: eb26             jmp 0x1577
  03C8D1  1551: 90               nop 
  03C8D2  1552: 50               push ax
  03C8D3  1553: 9a4c0a1f18       lcall 0x181f, 0xa4c
  03C8D8  1558: 83c402           add sp, 2
  03C8DB  155B: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  03C8DF  155F: 8a4705           mov al, byte ptr [bx + 5]
  03C8E2  1562: 250f00           and ax, 0xf
  03C8E5  1565: 3b46f6           cmp ax, word ptr [bp - 0xa]
  03C8E8  1568: 750a             jne 0x1574
  03C8EA  156A: 806705f0         and byte ptr [bx + 5], 0xf0
  03C8EE  156E: 8a46f8           mov al, byte ptr [bp - 8]
  03C8F1  1571: 084705           or byte ptr [bx + 5], al
  03C8F4  1574: ff46f0           inc word ptr [bp - 0x10]
  03C8F7  1577: 8b46f0           mov ax, word ptr [bp - 0x10]
  03C8FA  157A: 39069a53         cmp word ptr [0x539a], ax
  03C8FE  157E: 7fd2             jg 0x1552
  03C900  1580: ff76f6           push word ptr [bp - 0xa]
  03C903  1583: 9a740a1f19       lcall 0x191f, 0xa74
  03C908  1588: 83c402           add sp, 2
  03C90B  158B: ff76f8           push word ptr [bp - 8]
  03C90E  158E: 9a740a1f19       lcall 0x191f, 0xa74
  03C913  1593: 83c402           add sp, 2
  03C916  1596: 6b5ef634         imul bx, word ptr [bp - 0xa], 0x34
  03C91A  159A: c6873f5402       mov byte ptr [bx + 0x543f], 2
  03C91F  159F: 8b46f6           mov ax, word ptr [bp - 0xa]
  03C922  15A2: a3d253           mov word ptr [0x53d2], ax
  03C925  15A5: 6a01             push 1
  03C927  15A7: 9a1c0e1f18       lcall 0x181f, 0xe1c
  03C92C  15AC: 83c402           add sp, 2
  03C92F  15AF: 5e               pop si
  03C930  15B0: c9               leave 
  03C931  15B1: cb               retf 

; ---- func_03C932  size=247  insns=89  prologue=ENTER 0x0002,0  terminal=RETF ----
  03C932  15B2: c8020000         enter 2, 0
  03C936  15B6: 57               push di
  03C937  15B7: 56               push si
  03C938  15B8: a19c53           mov ax, word ptr [0x539c]
  03C93B  15BB: 48               dec ax
  03C93C  15BC: 8946fe           mov word ptr [bp - 2], ax
  03C93F  15BF: eb1c             jmp 0x15dd
  03C941  15C1: 90               nop 
  03C942  15C2: 6a01             push 1
  03C944  15C4: 68a212           push 0x12a2
  03C947  15C7: 9a52061f18       lcall 0x181f, 0x652
  03C94C  15CC: 83c404           add sp, 4
  03C94F  15CF: ff76fe           push word ptr [bp - 2]
  03C952  15D2: 9a08081f18       lcall 0x181f, 0x808
  03C957  15D7: 83c402           add sp, 2
  03C95A  15DA: ff4efe           dec word ptr [bp - 2]
  03C95D  15DD: 837efe00         cmp word ptr [bp - 2], 0
  03C961  15E1: 7d03             jge 0x15e6
  03C963  15E3: e9a000           jmp 0x1686
  03C966  15E6: 8a4606           mov al, byte ptr [bp + 6]
  03C969  15E9: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  03C96D  15ED: 38874431         cmp byte ptr [bx + 0x3144], al
  03C971  15F1: 75e7             jne 0x15da
  03C973  15F3: 8a4608           mov al, byte ptr [bp + 8]
  03C976  15F6: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  03C97A  15FA: 38874531         cmp byte ptr [bx + 0x3145], al
  03C97E  15FE: 75da             jne 0x15da
  03C980  1600: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  03C984  1604: 8a874731         mov al, byte ptr [bx + 0x3147]
  03C988  1608: 240f             and al, 0xf
  03C98A  160A: 3a06d253         cmp al, byte ptr [0x53d2]
  03C98E  160E: 74ca             je 0x15da
  03C990  1610: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  03C994  1614: 8a874731         mov al, byte ptr [bx + 0x3147]
  03C998  1618: 240f             and al, 0xf
  03C99A  161A: 3c04             cmp al, 4
  03C99C  161C: 73b1             jae 0x15cf
  03C99E  161E: 2ae4             sub ah, ah
  03C9A0  1620: 6bf034           imul si, ax, 0x34
  03C9A3  1623: 38a43f54         cmp byte ptr [si + 0x543f], ah
  03C9A7  1627: 75a6             jne 0x15cf
  03C9A9  1629: 8d874631         lea ax, [bx + 0x3146]
  03C9AD  162D: 8bf0             mov si, ax
  03C9AF  162F: 8bcb             mov cx, bx
  03C9B1  1631: 8a1c             mov bl, byte ptr [si]
  03C9B3  1633: 2aff             sub bh, bh
  03C9B5  1635: 8bd3             mov dx, bx
  03C9B7  1637: d1e3             shl bx, 1
  03C9B9  1639: 03da             add bx, dx
  03C9BB  163B: d1e3             shl bx, 1
  03C9BD  163D: 03da             add bx, dx
  03C9BF  163F: d1e3             shl bx, 1
  03C9C1  1641: ffb73052         push word ptr [bx + 0x5230]
  03C9C5  1645: 6a00             push 0
  03C9C7  1647: 8bfe             mov di, si
  03C9C9  1649: 8bf1             mov si, cx
  03C9CB  164B: 9a38041f18       lcall 0x181f, 0x438
  03C9D0  1650: 83c404           add sp, 4
  03C9D3  1653: 8a844531         mov al, byte ptr [si + 0x3145]
  03C9D7  1657: 2ae4             sub ah, ah
  03C9D9  1659: 50               push ax
  03C9DA  165A: 8a844431         mov al, byte ptr [si + 0x3144]
  03C9DE  165E: 50               push ax
  03C9DF  165F: 9a68071f18       lcall 0x181f, 0x768
  03C9E4  1664: 83c404           add sp, 4
  03C9E7  1667: 0bc0             or ax, ax
  03C9E9  1669: 7503             jne 0x166e
  03C9EB  166B: e954ff           jmp 0x15c2
  03C9EE  166E: 803d0d           cmp byte ptr [di], 0xd
  03C9F1  1671: 7303             jae 0x1676
  03C9F3  1673: e959ff           jmp 0x15cf
  03C9F6  1676: 803d12           cmp byte ptr [di], 0x12
  03C9F9  1679: 7603             jbe 0x167e
  03C9FB  167B: e951ff           jmp 0x15cf
  03C9FE  167E: 6a00             push 0
  03CA00  1680: 689712           push 0x1297
  03CA03  1683: e941ff           jmp 0x15c7
  03CA06  1686: 5e               pop si
  03CA07  1687: 5f               pop di
  03CA08  1688: c9               leave 
  03CA09  1689: cb               retf 
  03CA0A  168A: 8b1ed253         mov bx, word ptr [0x53d2]
  03CA0E  168E: c68748080f       mov byte ptr [bx + 0x848], 0xf
  03CA13  1693: cb               retf 
  03CA14  1694: c60648080c       mov byte ptr [0x848], 0xc
  03CA19  1699: c606490809       mov byte ptr [0x849], 9
  03CA1E  169E: c6064a080e       mov byte ptr [0x84a], 0xe
  03CA23  16A3: c6064b080d       mov byte ptr [0x84b], 0xd
  03CA28  16A8: cb               retf 

; ---- func_03CA2A  size=155  insns=57  prologue=ENTER 0x0004,0  terminal=RETF ----
  03CA2A  16AA: c8040000         enter 4, 0
  03CA2E  16AE: 8b1e4285         mov bx, word ptr [0x8542]
  03CA32  16B2: 8b87b800         mov ax, word ptr [bx + 0xb8]
  03CA36  16B6: 053200           add ax, 0x32
  03CA39  16B9: b96400           mov cx, 0x64
  03CA3C  16BC: 99               cdq 
  03CA3D  16BD: f7f9             idiv cx
  03CA3F  16BF: 40               inc ax
  03CA40  16C0: 8946fc           mov word ptr [bp - 4], ax
  03CA43  16C3: 8a07             mov al, byte ptr [bx]
  03CA45  16C5: 2ae4             sub ah, ah
  03CA47  16C7: 8a5701           mov dl, byte ptr [bx + 1]
  03CA4A  16CA: 2af6             sub dh, dh
  03CA4C  16CC: 9ae0071f18       lcall 0x181f, 0x7e0
  03CA51  16D1: eb2e             jmp 0x1701
  03CA53  16D3: 90               nop 
  03CA54  16D4: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  03CA58  16D8: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  03CA5D  16DD: 7207             jb 0x16e6
  03CA5F  16DF: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03CA64  16E4: 7613             jbe 0x16f9
  03CA66  16E6: 6a01             push 1
  03CA68  16E8: ff76fe           push word ptr [bp - 2]
  03CA6B  16EB: 9ac8091f18       lcall 0x181f, 0x9c8
  03CA70  16F0: 83c404           add sp, 4
  03CA73  16F3: c1f804           sar ax, 4
  03CA76  16F6: 0146fc           add word ptr [bp - 4], ax
  03CA79  16F9: 8b46fe           mov ax, word ptr [bp - 2]
  03CA7C  16FC: 9ae4021f18       lcall 0x181f, 0x2e4
  03CA81  1701: 8946fe           mov word ptr [bp - 2], ax
  03CA84  1704: 0bc0             or ax, ax
  03CA86  1706: 7dcc             jge 0x16d4
  03CA88  1708: 6a02             push 2
  03CA8A  170A: 9afc091f18       lcall 0x181f, 0x9fc
  03CA8F  170F: 83c402           add sp, 2
  03CA92  1712: 0bc0             or ax, ax
  03CA94  1714: 7406             je 0x171c
  03CA96  1716: d166fc           shl word ptr [bp - 4], 1
  03CA99  1719: eb1d             jmp 0x1738
  03CA9B  171B: 90               nop 
  03CA9C  171C: 6a01             push 1
  03CA9E  171E: 9afc091f18       lcall 0x181f, 0x9fc
  03CAA3  1723: 83c402           add sp, 2
  03CAA6  1726: 0bc0             or ax, ax
  03CAA8  1728: 740e             je 0x1738
  03CAAA  172A: 8b46fc           mov ax, word ptr [bp - 4]
  03CAAD  172D: 8bc8             mov cx, ax
  03CAAF  172F: d1e0             shl ax, 1
  03CAB1  1731: 03c1             add ax, cx
  03CAB3  1733: d1f8             sar ax, 1
  03CAB5  1735: 8946fc           mov word ptr [bp - 4], ax
  03CAB8  1738: 8b46fc           mov ax, word ptr [bp - 4]
  03CABB  173B: 3d0100           cmp ax, 1
  03CABE  173E: 7d03             jge 0x1743
  03CAC0  1740: b80100           mov ax, 1
  03CAC3  1743: c9               leave 
  03CAC4  1744: cb               retf 

; ---- func_03CAC6  size=732  insns=267  prologue=ENTER 0x0018,0  terminal=RETF ----
  03CAC6  1746: c8180000         enter 0x18, 0
  03CACA  174A: 56               push si
  03CACB  174B: c746fcffff       mov word ptr [bp - 4], 0xffff
  03CAD0  1750: a0a653           mov al, byte ptr [0x53a6]
  03CAD3  1753: 2ae4             sub ah, ah
  03CAD5  1755: 40               inc ax
  03CAD6  1756: 50               push ax
  03CAD7  1757: 2bc0             sub ax, ax
  03CAD9  1759: 8946ec           mov word ptr [bp - 0x14], ax
  03CADC  175C: 50               push ax
  03CADD  175D: 9ad4041f18       lcall 0x181f, 0x4d4
  03CAE2  1762: 83c404           add sp, 4
  03CAE5  1765: 0bc0             or ax, ax
  03CAE7  1767: 7503             jne 0x176c
  03CAE9  1769: e9b302           jmp 0x1a1f
  03CAEC  176C: c746e80000       mov word ptr [bp - 0x18], 0
  03CAF1  1771: e9cd00           jmp 0x1841
  03CAF4  1774: 6b5eee1c         imul bx, word ptr [bp - 0x12], 0x1c
  03CAF8  1778: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03CAFC  177C: 2aff             sub bh, bh
  03CAFE  177E: 8bc3             mov ax, bx
  03CB00  1780: d1e3             shl bx, 1
  03CB02  1782: 03d8             add bx, ax
  03CB04  1784: d1e3             shl bx, 1
  03CB06  1786: 03d8             add bx, ax
  03CB08  1788: d1e3             shl bx, 1
  03CB0A  178A: 8a873652         mov al, byte ptr [bx + 0x5236]
  03CB0E  178E: 2ae4             sub ah, ah
  03CB10  1790: 2946ea           sub word ptr [bp - 0x16], ax
  03CB13  1793: 8b46ee           mov ax, word ptr [bp - 0x12]
  03CB16  1796: 9ae4021f18       lcall 0x181f, 0x2e4
  03CB1B  179B: 8946ee           mov word ptr [bp - 0x12], ax
  03CB1E  179E: 0bc0             or ax, ax
  03CB20  17A0: 7dd2             jge 0x1774
  03CB22  17A2: 2bc0             sub ax, ax
  03CB24  17A4: 8946fe           mov word ptr [bp - 2], ax
  03CB27  17A7: 8946f6           mov word ptr [bp - 0xa], ax
  03CB2A  17AA: eb17             jmp 0x17c3
  03CB2C  17AC: 6bd81c           imul bx, ax, 0x1c
  03CB2F  17AF: 8a874731         mov al, byte ptr [bx + 0x3147]
  03CB33  17B3: 240f             and al, 0xf
  03CB35  17B5: 3a06d253         cmp al, byte ptr [0x53d2]
  03CB39  17B9: 7505             jne 0x17c0
  03CB3B  17BB: c746eaffff       mov word ptr [bp - 0x16], 0xffff
  03CB40  17C0: ff46f6           inc word ptr [bp - 0xa]
  03CB43  17C3: 837ef608         cmp word ptr [bp - 0xa], 8
  03CB47  17C7: 7d59             jge 0x1822
  03CB49  17C9: 8b5ef6           mov bx, word ptr [bp - 0xa]
  03CB4C  17CC: 8a87be00         mov al, byte ptr [bx + 0xbe]
  03CB50  17D0: 98               cwde 
  03CB51  17D1: 8b364285         mov si, word ptr [0x8542]
  03CB55  17D5: 8a4c01           mov cl, byte ptr [si + 1]
  03CB58  17D8: 2aed             sub ch, ch
  03CB5A  17DA: 03c1             add ax, cx
  03CB5C  17DC: 8946f0           mov word ptr [bp - 0x10], ax
  03CB5F  17DF: 50               push ax
  03CB60  17E0: 8a87b400         mov al, byte ptr [bx + 0xb4]
  03CB64  17E4: 98               cwde 
  03CB65  17E5: 8a0c             mov cl, byte ptr [si]
  03CB67  17E7: 03c1             add ax, cx
  03CB69  17E9: 8946f2           mov word ptr [bp - 0xe], ax
  03CB6C  17EC: 50               push ax
  03CB6D  17ED: 9a68071f18       lcall 0x181f, 0x768
  03CB72  17F2: 83c404           add sp, 4
  03CB75  17F5: 0bc0             or ax, ax
  03CB77  17F7: 75c7             jne 0x17c0
  03CB79  17F9: ff76f0           push word ptr [bp - 0x10]
  03CB7C  17FC: ff76f2           push word ptr [bp - 0xe]
  03CB7F  17FF: 9abe061f18       lcall 0x181f, 0x6be
  03CB84  1804: 83c404           add sp, 4
  03CB87  1807: 0bc0             or ax, ax
  03CB89  1809: 7db5             jge 0x17c0
  03CB8B  180B: 8b46f2           mov ax, word ptr [bp - 0xe]
  03CB8E  180E: 8b56f0           mov dx, word ptr [bp - 0x10]
  03CB91  1811: 9ae0071f18       lcall 0x181f, 0x7e0
  03CB96  1816: 8946ee           mov word ptr [bp - 0x12], ax
  03CB99  1819: 0bc0             or ax, ax
  03CB9B  181B: 7d8f             jge 0x17ac
  03CB9D  181D: ff46fe           inc word ptr [bp - 2]
  03CBA0  1820: eb9e             jmp 0x17c0
  03CBA2  1822: 837efe00         cmp word ptr [bp - 2], 0
  03CBA6  1826: 7505             jne 0x182d
  03CBA8  1828: c746eaffff       mov word ptr [bp - 0x16], 0xffff
  03CBAD  182D: 8b46ea           mov ax, word ptr [bp - 0x16]
  03CBB0  1830: 3946ec           cmp word ptr [bp - 0x14], ax
  03CBB3  1833: 7d09             jge 0x183e
  03CBB5  1835: 8946ec           mov word ptr [bp - 0x14], ax
  03CBB8  1838: 8b46e8           mov ax, word ptr [bp - 0x18]
  03CBBB  183B: 8946fc           mov word ptr [bp - 4], ax
  03CBBE  183E: ff46e8           inc word ptr [bp - 0x18]
  03CBC1  1841: a19e53           mov ax, word ptr [0x539e]
  03CBC4  1844: 3946e8           cmp word ptr [bp - 0x18], ax
  03CBC7  1847: 7d5b             jge 0x18a4
  03CBC9  1849: ff76e8           push word ptr [bp - 0x18]
  03CBCC  184C: 9ae6091f18       lcall 0x181f, 0x9e6
  03CBD1  1851: 83c402           add sp, 2
  03CBD4  1854: 8a4606           mov al, byte ptr [bp + 6]
  03CBD7  1857: 8b1e4285         mov bx, word ptr [0x8542]
  03CBDB  185B: 38471a           cmp byte ptr [bx + 0x1a], al
  03CBDE  185E: 75de             jne 0x183e
  03CBE0  1860: f6471c01         test byte ptr [bx + 0x1c], 1
  03CBE4  1864: 75d8             jne 0x183e
  03CBE6  1866: 9a860c1f18       lcall 0x181f, 0xc86
  03CBEB  186B: 2d6400           sub ax, 0x64
  03CBEE  186E: f7d8             neg ax
  03CBF0  1870: d1e0             shl ax, 1
  03CBF2  1872: 8946fa           mov word ptr [bp - 6], ax
  03CBF5  1875: 8b1e4285         mov bx, word ptr [0x8542]
  03CBF9  1879: 8a471f           mov al, byte ptr [bx + 0x1f]
  03CBFC  187C: 98               cwde 
  03CBFD  187D: f76efa           imul word ptr [bp - 6]
  03CC00  1880: b96400           mov cx, 0x64
  03CC03  1883: 99               cdq 
  03CC04  1884: f7f9             idiv cx
  03CC06  1886: 8a0ea653         mov cl, byte ptr [0x53a6]
  03CC0A  188A: 2aed             sub ch, ch
  03CC0C  188C: 03c1             add ax, cx
  03CC0E  188E: 40               inc ax
  03CC0F  188F: 8946ea           mov word ptr [bp - 0x16], ax
  03CC12  1892: 8a07             mov al, byte ptr [bx]
  03CC14  1894: 2ae4             sub ah, ah
  03CC16  1896: 8a5701           mov dl, byte ptr [bx + 1]
  03CC19  1899: 2af6             sub dh, dh
  03CC1B  189B: 9ae0071f18       lcall 0x181f, 0x7e0
  03CC20  18A0: e9f8fe           jmp 0x179b
  03CC23  18A3: 90               nop 
  03CC24  18A4: 837efc00         cmp word ptr [bp - 4], 0
  03CC28  18A8: 7d03             jge 0x18ad
  03CC2A  18AA: e97201           jmp 0x1a1f
  03CC2D  18AD: ff76fc           push word ptr [bp - 4]
  03CC30  18B0: 9ae6091f18       lcall 0x181f, 0x9e6
  03CC35  18B5: 83c402           add sp, 2
  03CC38  18B8: 8b1e4285         mov bx, word ptr [0x8542]
  03CC3C  18BC: 804f1c01         or byte ptr [bx + 0x1c], 1
  03CC40  18C0: c746f80000       mov word ptr [bp - 8], 0
  03CC45  18C5: e90801           jmp 0x19d0
  03CC48  18C8: 2bc0             sub ax, ax
  03CC4A  18CA: 8946f4           mov word ptr [bp - 0xc], ax
  03CC4D  18CD: 8946f6           mov word ptr [bp - 0xa], ax
  03CC50  18D0: e9e900           jmp 0x19bc
  03CC53  18D3: 90               nop 
  03CC54  18D4: 837ef608         cmp word ptr [bp - 0xa], 8
  03CC58  18D8: 7c03             jl 0x18dd
  03CC5A  18DA: e9e800           jmp 0x19c5
  03CC5D  18DD: 8b5ef6           mov bx, word ptr [bp - 0xa]
  03CC60  18E0: 8a87be00         mov al, byte ptr [bx + 0xbe]
  03CC64  18E4: 98               cwde 
  03CC65  18E5: 8b364285         mov si, word ptr [0x8542]
  03CC69  18E9: 8a4c01           mov cl, byte ptr [si + 1]
  03CC6C  18EC: 2aed             sub ch, ch
  03CC6E  18EE: 03c1             add ax, cx
  03CC70  18F0: 8946f0           mov word ptr [bp - 0x10], ax
  03CC73  18F3: 50               push ax
  03CC74  18F4: 8a87b400         mov al, byte ptr [bx + 0xb4]
  03CC78  18F8: 98               cwde 
  03CC79  18F9: 8a0c             mov cl, byte ptr [si]
  03CC7B  18FB: 03c1             add ax, cx
  03CC7D  18FD: 8946f2           mov word ptr [bp - 0xe], ax
  03CC80  1900: 50               push ax
  03CC81  1901: 9a68071f18       lcall 0x181f, 0x768
  03CC86  1906: 83c404           add sp, 4
  03CC89  1909: 0bc0             or ax, ax
  03CC8B  190B: 7403             je 0x1910
  03CC8D  190D: e9a900           jmp 0x19b9
  03CC90  1910: ff76f0           push word ptr [bp - 0x10]
  03CC93  1913: ff76f2           push word ptr [bp - 0xe]
  03CC96  1916: 9abe061f18       lcall 0x181f, 0x6be
  03CC9B  191B: 83c404           add sp, 4
  03CC9E  191E: 0bc0             or ax, ax
  03CCA0  1920: 7c03             jl 0x1925
  03CCA2  1922: e99400           jmp 0x19b9
  03CCA5  1925: ff76f0           push word ptr [bp - 0x10]
  03CCA8  1928: ff76f2           push word ptr [bp - 0xe]
  03CCAB  192B: 9a82061f18       lcall 0x181f, 0x682
  03CCB0  1930: 83c404           add sp, 4
  03CCB3  1933: 8946ee           mov word ptr [bp - 0x12], ax
  03CCB6  1936: 0bc0             or ax, ax
  03CCB8  1938: 7c09             jl 0x1943
  03CCBA  193A: a0d253           mov al, byte ptr [0x53d2]
  03CCBD  193D: 98               cwde 
  03CCBE  193E: 3946ee           cmp word ptr [bp - 0x12], ax
  03CCC1  1941: 7576             jne 0x19b9
  03CCC3  1943: ff76f0           push word ptr [bp - 0x10]
  03CCC6  1946: ff76f2           push word ptr [bp - 0xe]
  03CCC9  1949: ff36d253         push word ptr [0x53d2]
  03CCCD  194D: 6a01             push 1
  03CCCF  194F: 9a5c091f18       lcall 0x181f, 0x95c
  03CCD4  1954: 83c408           add sp, 8
  03CCD7  1957: 8946ee           mov word ptr [bp - 0x12], ax
  03CCDA  195A: 0bc0             or ax, ax
  03CCDC  195C: 7c58             jl 0x19b6
  03CCDE  195E: b90100           mov cx, 1
  03CCE1  1961: 894ef8           mov word ptr [bp - 8], cx
  03CCE4  1964: 894ef4           mov word ptr [bp - 0xc], cx
  03CCE7  1967: f646ea01         test byte ptr [bp - 0x16], 1
  03CCEB  196B: 741f             je 0x198c
  03CCED  196D: 8a0ea653         mov cl, byte ptr [0x53a6]
  03CCF1  1971: 2aed             sub ch, ch
  03CCF3  1973: 41               inc cx
  03CCF4  1974: 51               push cx
  03CCF5  1975: 6a00             push 0
  03CCF7  1977: 9ad4041f18       lcall 0x181f, 0x4d4
  03CCFC  197C: 83c404           add sp, 4
  03CCFF  197F: 0bc0             or ax, ax
  03CD01  1981: 7409             je 0x198c
  03CD03  1983: 6b5eee1c         imul bx, word ptr [bp - 0x12], 0x1c
  03CD07  1987: c6875b3115       mov byte ptr [bx + 0x315b], 0x15
  03CD0C  198C: 8b46ea           mov ax, word ptr [bp - 0x16]
  03CD0F  198F: b90300           mov cx, 3
  03CD12  1992: 99               cdq 
  03CD13  1993: f7f9             idiv cx
  03CD15  1995: 0bd2             or dx, dx
  03CD17  1997: 751d             jne 0x19b6
  03CD19  1999: a0a653           mov al, byte ptr [0x53a6]
  03CD1C  199C: 2ae4             sub ah, ah
  03CD1E  199E: 40               inc ax
  03CD1F  199F: 50               push ax
  03CD20  19A0: 52               push dx
  03CD21  19A1: 9ad4041f18       lcall 0x181f, 0x4d4
  03CD26  19A6: 83c404           add sp, 4
  03CD29  19A9: 0bc0             or ax, ax
  03CD2B  19AB: 7409             je 0x19b6
  03CD2D  19AD: 6b5eee1c         imul bx, word ptr [bp - 0x12], 0x1c
  03CD31  19B1: c687463104       mov byte ptr [bx + 0x3146], 4
  03CD36  19B6: ff4eea           dec word ptr [bp - 0x16]
  03CD39  19B9: ff46f6           inc word ptr [bp - 0xa]
  03CD3C  19BC: 837eea00         cmp word ptr [bp - 0x16], 0
  03CD40  19C0: 7e03             jle 0x19c5
  03CD42  19C2: e90fff           jmp 0x18d4
  03CD45  19C5: 837ef400         cmp word ptr [bp - 0xc], 0
  03CD49  19C9: 7505             jne 0x19d0
  03CD4B  19CB: c746ea0000       mov word ptr [bp - 0x16], 0
  03CD50  19D0: 837eea00         cmp word ptr [bp - 0x16], 0
  03CD54  19D4: 7e03             jle 0x19d9
  03CD56  19D6: e9effe           jmp 0x18c8
  03CD59  19D9: 837ef800         cmp word ptr [bp - 8], 0
  03CD5D  19DD: 750d             jne 0x19ec
  03CD5F  19DF: 8b1e4285         mov bx, word ptr [0x8542]
  03CD63  19E3: 80671cfe         and byte ptr [bx + 0x1c], 0xfe
  03CD67  19E7: 5e               pop si
  03CD68  19E8: c9               leave 
  03CD69  19E9: cb               retf 
  03CD6A  19EA: 90               nop 
  03CD6B  19EB: 90               nop 
  03CD6C  19EC: 8b1e4285         mov bx, word ptr [0x8542]
  03CD70  19F0: 8a4701           mov al, byte ptr [bx + 1]
  03CD73  19F3: 2ae4             sub ah, ah
  03CD75  19F5: 50               push ax
  03CD76  19F6: 8a07             mov al, byte ptr [bx]
  03CD78  19F8: 50               push ax
  03CD79  19F9: 9a9a0d1f18       lcall 0x181f, 0xd9a
  03CD7E  19FE: 83c404           add sp, 4
  03CD81  1A01: a14285           mov ax, word ptr [0x8542]
  03CD84  1A04: 40               inc ax
  03CD85  1A05: 40               inc ax
  03CD86  1A06: 1e               push ds
  03CD87  1A07: 50               push ax
  03CD88  1A08: 6a00             push 0
  03CD8A  1A0A: 9a16041f18       lcall 0x181f, 0x416
  03CD8F  1A0F: 83c406           add sp, 6
  03CD92  1A12: 6a01             push 1
  03CD94  1A14: 68ae12           push 0x12ae
  03CD97  1A17: 9a52061f18       lcall 0x181f, 0x652
  03CD9C  1A1C: 83c404           add sp, 4
  03CD9F  1A1F: 5e               pop si
  03CDA0  1A20: c9               leave 
  03CDA1  1A21: cb               retf 

; ---- func_03CDA2  size=1902  insns=662  prologue=ENTER 0x0082,0  terminal=RETF ----
  03CDA2  1A22: c8820000         enter 0x82, 0
  03CDA6  1A26: 56               push si
  03CDA7  1A27: c746fa0000       mov word ptr [bp - 6], 0
  03CDAC  1A2C: 833ede5300       cmp word ptr [0x53de], 0
  03CDB1  1A31: 7435             je 0x1a68
  03CDB3  1A33: a1da53           mov ax, word ptr [0x53da]
  03CDB6  1A36: 0306dc53         add ax, word ptr [0x53dc]
  03CDBA  1A3A: 0306e053         add ax, word ptr [0x53e0]
  03CDBE  1A3E: 0306de53         add ax, word ptr [0x53de]
  03CDC2  1A42: 8946fe           mov word ptr [bp - 2], ax
  03CDC5  1A45: 3d0400           cmp ax, 4
  03CDC8  1A48: 7e06             jle 0x1a50
  03CDCA  1A4A: 3b06de53         cmp ax, word ptr [0x53de]
  03CDCE  1A4E: 7505             jne 0x1a55
  03CDD0  1A50: c746fa0100       mov word ptr [bp - 6], 1
  03CDD5  1A55: 3906de53         cmp word ptr [0x53de], ax
  03CDD9  1A59: 7503             jne 0x1a5e
  03CDDB  1A5B: e91007           jmp 0x216e
  03CDDE  1A5E: 2bc0             sub ax, ax
  03CDE0  1A60: 8946d8           mov word ptr [bp - 0x28], ax
  03CDE3  1A63: 894698           mov word ptr [bp - 0x68], ax
  03CDE6  1A66: eb19             jmp 0x1a81
  03CDE8  1A68: 6b1ed25313       imul bx, word ptr [0x53d2], 0x13
  03CDED  1A6D: 80bf5e9200       cmp byte ptr [bx - 0x6da2], 0
  03CDF2  1A72: 7403             je 0x1a77
  03CDF4  1A74: e9f706           jmp 0x216e
  03CDF7  1A77: ff06de53         inc word ptr [0x53de]
  03CDFB  1A7B: e9f006           jmp 0x216e
  03CDFE  1A7E: ff4698           inc word ptr [bp - 0x68]
  03CE01  1A81: 8b4698           mov ax, word ptr [bp - 0x68]
  03CE04  1A84: 39069e53         cmp word ptr [0x539e], ax
  03CE08  1A88: 7f03             jg 0x1a8d
  03CE0A  1A8A: e98900           jmp 0x1b16
  03CE0D  1A8D: 50               push ax
  03CE0E  1A8E: 9ae6091f18       lcall 0x181f, 0x9e6
  03CE13  1A93: 83c402           add sp, 2
  03CE16  1A96: 8a4606           mov al, byte ptr [bp + 6]
  03CE19  1A99: 8b1e4285         mov bx, word ptr [0x8542]
  03CE1D  1A9D: 38471a           cmp byte ptr [bx + 0x1a], al
  03CE20  1AA0: 75dc             jne 0x1a7e
  03CE22  1AA2: f6471c40         test byte ptr [bx + 0x1c], 0x40
  03CE26  1AA6: 74d6             je 0x1a7e
  03CE28  1AA8: 837ed80a         cmp word ptr [bp - 0x28], 0xa
  03CE2C  1AAC: 7dd0             jge 0x1a7e
  03CE2E  1AAE: 9a860c1f18       lcall 0x181f, 0xc86
  03CE33  1AB3: 2d6400           sub ax, 0x64
  03CE36  1AB6: f7d8             neg ax
  03CE38  1AB8: 8946bc           mov word ptr [bp - 0x44], ax
  03CE3B  1ABB: 8b1e4285         mov bx, word ptr [0x8542]
  03CE3F  1ABF: 8a471f           mov al, byte ptr [bx + 0x1f]
  03CE42  1AC2: 98               cwde 
  03CE43  1AC3: 8b4ebc           mov cx, word ptr [bp - 0x44]
  03CE46  1AC6: 83c119           add cx, 0x19
  03CE49  1AC9: f7e9             imul cx
  03CE4B  1ACB: 8946ce           mov word ptr [bp - 0x32], ax
  03CE4E  1ACE: 6a0a             push 0xa
  03CE50  1AD0: 8a07             mov al, byte ptr [bx]
  03CE52  1AD2: 2ae4             sub ah, ah
  03CE54  1AD4: 8a5701           mov dl, byte ptr [bx + 1]
  03CE57  1AD7: 2af6             sub dh, dh
  03CE59  1AD9: 9ae0071f18       lcall 0x181f, 0x7e0
  03CE5E  1ADE: 8946b6           mov word ptr [bp - 0x4a], ax
  03CE61  1AE1: 50               push ax
  03CE62  1AE2: 9abc081f18       lcall 0x181f, 0x8bc
  03CE67  1AE7: 83c404           add sp, 4
  03CE6A  1AEA: 6bc0b5           imul ax, ax, -0x4b
  03CE6D  1AED: 0146ce           add word ptr [bp - 0x32], ax
  03CE70  1AF0: 8b46ce           mov ax, word ptr [bp - 0x32]
  03CE73  1AF3: 3b46bc           cmp ax, word ptr [bp - 0x44]
  03CE76  1AF6: 7d03             jge 0x1afb
  03CE78  1AF8: 8b46bc           mov ax, word ptr [bp - 0x44]
  03CE7B  1AFB: 8946ce           mov word ptr [bp - 0x32], ax
  03CE7E  1AFE: 8b76d8           mov si, word ptr [bp - 0x28]
  03CE81  1B01: d1e6             shl si, 1
  03CE83  1B03: 8942a2           mov word ptr [bp + si - 0x5e], ax
  03CE86  1B06: 8a4698           mov al, byte ptr [bp - 0x68]
  03CE89  1B09: 8b76d8           mov si, word ptr [bp - 0x28]
  03CE8C  1B0C: 8842c0           mov byte ptr [bp + si - 0x40], al
  03CE8F  1B0F: ff46d8           inc word ptr [bp - 0x28]
  03CE92  1B12: e969ff           jmp 0x1a7e
  03CE95  1B15: 90               nop 
  03CE96  1B16: 837ed800         cmp word ptr [bp - 0x28], 0
  03CE9A  1B1A: 7412             je 0x1b2e
  03CE9C  1B1C: 8d46c0           lea ax, [bp - 0x40]
  03CE9F  1B1F: 16               push ss
  03CEA0  1B20: 50               push ax
  03CEA1  1B21: 8d46a2           lea ax, [bp - 0x5e]
  03CEA4  1B24: 16               push ss
  03CEA5  1B25: 50               push ax
  03CEA6  1B26: 8b46d8           mov ax, word ptr [bp - 0x28]
  03CEA9  1B29: 9ad00e1f19       lcall 0x191f, 0xed0
  03CEAE  1B2E: c746ca0000       mov word ptr [bp - 0x36], 0
  03CEB3  1B33: e99500           jmp 0x1bcb
  03CEB6  1B36: ff46e0           inc word ptr [bp - 0x20]
  03CEB9  1B39: 837ee008         cmp word ptr [bp - 0x20], 8
  03CEBD  1B3D: 7c03             jl 0x1b42
  03CEBF  1B3F: e98600           jmp 0x1bc8
  03CEC2  1B42: 8b5ee0           mov bx, word ptr [bp - 0x20]
  03CEC5  1B45: 8a87be00         mov al, byte ptr [bx + 0xbe]
  03CEC9  1B49: 98               cwde 
  03CECA  1B4A: 8b364285         mov si, word ptr [0x8542]
  03CECE  1B4E: 8a4c01           mov cl, byte ptr [si + 1]
  03CED1  1B51: 2aed             sub ch, ch
  03CED3  1B53: 03c1             add ax, cx
  03CED5  1B55: 8946cc           mov word ptr [bp - 0x34], ax
  03CED8  1B58: 50               push ax
  03CED9  1B59: 8a87b400         mov al, byte ptr [bx + 0xb4]
  03CEDD  1B5D: 98               cwde 
  03CEDE  1B5E: 8a0c             mov cl, byte ptr [si]
  03CEE0  1B60: 03c1             add ax, cx
  03CEE2  1B62: 8946d0           mov word ptr [bp - 0x30], ax
  03CEE5  1B65: 50               push ax
  03CEE6  1B66: 9a68071f18       lcall 0x181f, 0x768
  03CEEB  1B6B: 83c404           add sp, 4
  03CEEE  1B6E: 0bc0             or ax, ax
  03CEF0  1B70: 75c4             jne 0x1b36
  03CEF2  1B72: 6b5eb61c         imul bx, word ptr [bp - 0x4a], 0x1c
  03CEF6  1B76: 8a874731         mov al, byte ptr [bx + 0x3147]
  03CEFA  1B7A: 240f             and al, 0xf
  03CEFC  1B7C: 3a06d253         cmp al, byte ptr [0x53d2]
  03CF00  1B80: 75b4             jne 0x1b36
  03CF02  1B82: 8b46d0           mov ax, word ptr [bp - 0x30]
  03CF05  1B85: 8b56cc           mov dx, word ptr [bp - 0x34]
  03CF08  1B88: 9ae0071f18       lcall 0x181f, 0x7e0
  03CF0D  1B8D: 8946b6           mov word ptr [bp - 0x4a], ax
  03CF10  1B90: 0bc0             or ax, ax
  03CF12  1B92: 7ca2             jl 0x1b36
  03CF14  1B94: 8b76ca           mov si, word ptr [bp - 0x36]
  03CF17  1B97: d1e6             shl si, 1
  03CF19  1B99: 837a8400         cmp word ptr [bp + si - 0x7c], 0
  03CF1D  1B9D: 7e97             jle 0x1b36
  03CF1F  1B9F: 6bd81c           imul bx, ax, 0x1c
  03CF22  1BA2: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03CF26  1BA6: 2aff             sub bh, bh
  03CF28  1BA8: 8bc3             mov ax, bx
  03CF2A  1BAA: d1e3             shl bx, 1
  03CF2C  1BAC: 03d8             add bx, ax
  03CF2E  1BAE: d1e3             shl bx, 1
  03CF30  1BB0: 03d8             add bx, ax
  03CF32  1BB2: d1e3             shl bx, 1
  03CF34  1BB4: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  03CF39  1BB9: 7403             je 0x1bbe
  03CF3B  1BBB: ff4a84           dec word ptr [bp + si - 0x7c]
  03CF3E  1BBE: 8b46b6           mov ax, word ptr [bp - 0x4a]
  03CF41  1BC1: 9ae4021f18       lcall 0x181f, 0x2e4
  03CF46  1BC6: ebc5             jmp 0x1b8d
  03CF48  1BC8: ff46ca           inc word ptr [bp - 0x36]
  03CF4B  1BCB: 8b46ca           mov ax, word ptr [bp - 0x36]
  03CF4E  1BCE: 3946d8           cmp word ptr [bp - 0x28], ax
  03CF51  1BD1: 7e25             jle 0x1bf8
  03CF53  1BD3: 8bf0             mov si, ax
  03CF55  1BD5: 8a4ac0           mov cl, byte ptr [bp + si - 0x40]
  03CF58  1BD8: 2aed             sub ch, ch
  03CF5A  1BDA: 894e98           mov word ptr [bp - 0x68], cx
  03CF5D  1BDD: 51               push cx
  03CF5E  1BDE: 9ae6091f18       lcall 0x181f, 0x9e6
  03CF63  1BE3: 83c402           add sp, 2
  03CF66  1BE6: 0e               push cs
  03CF67  1BE7: e8ce1a           call 0x36b8
  03CF6A  1BEA: d1e6             shl si, 1
  03CF6C  1BEC: 894284           mov word ptr [bp + si - 0x7c], ax
  03CF6F  1BEF: c746e00000       mov word ptr [bp - 0x20], 0
  03CF74  1BF4: e942ff           jmp 0x1b39
  03CF77  1BF7: 90               nop 
  03CF78  1BF8: c746e60100       mov word ptr [bp - 0x1a], 1
  03CF7D  1BFD: c746be0000       mov word ptr [bp - 0x42], 0
  03CF82  1C02: eb03             jmp 0x1c07
  03CF84  1C04: ff46be           inc word ptr [bp - 0x42]
  03CF87  1C07: 837ee600         cmp word ptr [bp - 0x1a], 0
  03CF8B  1C0B: 7503             jne 0x1c10
  03CF8D  1C0D: e9c200           jmp 0x1cd2
  03CF90  1C10: 837ebe03         cmp word ptr [bp - 0x42], 3
  03CF94  1C14: 7c03             jl 0x1c19
  03CF96  1C16: e9b900           jmp 0x1cd2
  03CF99  1C19: c746ba0000       mov word ptr [bp - 0x46], 0
  03CF9E  1C1E: 8b46d8           mov ax, word ptr [bp - 0x28]
  03CFA1  1C21: 3946ba           cmp word ptr [bp - 0x46], ax
  03CFA4  1C24: 7dde             jge 0x1c04
  03CFA6  1C26: 837ee600         cmp word ptr [bp - 0x1a], 0
  03CFAA  1C2A: 74d8             je 0x1c04
  03CFAC  1C2C: c746e60000       mov word ptr [bp - 0x1a], 0
  03CFB1  1C31: 8bf0             mov si, ax
  03CFB3  1C33: 2b76ba           sub si, word ptr [bp - 0x46]
  03CFB6  1C36: 8a42bf           mov al, byte ptr [bp + si - 0x41]
  03CFB9  1C39: 2ae4             sub ah, ah
  03CFBB  1C3B: 894698           mov word ptr [bp - 0x68], ax
  03CFBE  1C3E: 50               push ax
  03CFBF  1C3F: 9ae6091f18       lcall 0x181f, 0x9e6
  03CFC4  1C44: 83c402           add sp, 2
  03CFC7  1C47: d1e6             shl si, 1
  03CFC9  1C49: 8b4282           mov ax, word ptr [bp + si - 0x7e]
  03CFCC  1C4C: 8946d2           mov word ptr [bp - 0x2e], ax
  03CFCF  1C4F: 3d0100           cmp ax, 1
  03CFD2  1C52: 7d03             jge 0x1c57
  03CFD4  1C54: b80100           mov ax, 1
  03CFD7  1C57: 894682           mov word ptr [bp - 0x7e], ax
  03CFDA  1C5A: c1f803           sar ax, 3
  03CFDD  1C5D: 3d0100           cmp ax, 1
  03CFE0  1C60: 7d03             jge 0x1c65
  03CFE2  1C62: b80100           mov ax, 1
  03CFE5  1C65: 89469c           mov word ptr [bp - 0x64], ax
  03CFE8  1C68: a1dc53           mov ax, word ptr [0x53dc]
  03CFEB  1C6B: 0306e053         add ax, word ptr [0x53e0]
  03CFEF  1C6F: 3b06da53         cmp ax, word ptr [0x53da]
  03CFF3  1C73: 7f05             jg 0x1c7a
  03CFF5  1C75: c7469c0100       mov word ptr [bp - 0x64], 1
  03CFFA  1C7A: a1dc53           mov ax, word ptr [0x53dc]
  03CFFD  1C7D: 3b469c           cmp ax, word ptr [bp - 0x64]
  03D000  1C80: 7e03             jle 0x1c85
  03D002  1C82: 8b469c           mov ax, word ptr [bp - 0x64]
  03D005  1C85: 8946f6           mov word ptr [bp - 0xa], ax
  03D008  1C88: a1e053           mov ax, word ptr [0x53e0]
  03D00B  1C8B: 3b469c           cmp ax, word ptr [bp - 0x64]
  03D00E  1C8E: 7e03             jle 0x1c93
  03D010  1C90: 8b469c           mov ax, word ptr [bp - 0x64]
  03D013  1C93: 8946d4           mov word ptr [bp - 0x2c], ax
  03D016  1C96: 837ebe00         cmp word ptr [bp - 0x42], 0
  03D01A  1C9A: 7410             je 0x1cac
  03D01C  1C9C: a03353           mov al, byte ptr [0x5333]
  03D01F  1C9F: 2ae4             sub ah, ah
  03D021  1CA1: 3b4682           cmp ax, word ptr [bp - 0x7e]
  03D024  1CA4: 7e03             jle 0x1ca9
  03D026  1CA6: 8b4682           mov ax, word ptr [bp - 0x7e]
  03D029  1CA9: 894682           mov word ptr [bp - 0x7e], ax
  03D02C  1CAC: 837ebe02         cmp word ptr [bp - 0x42], 2
  03D030  1CB0: 7c03             jl 0x1cb5
  03D032  1CB2: e969ff           jmp 0x1c1e
  03D035  1CB5: a1da53           mov ax, word ptr [0x53da]
  03D038  1CB8: 0346f6           add ax, word ptr [bp - 0xa]
  03D03B  1CBB: 0346d4           add ax, word ptr [bp - 0x2c]
  03D03E  1CBE: 3b4682           cmp ax, word ptr [bp - 0x7e]
  03D041  1CC1: 7c03             jl 0x1cc6
  03D043  1CC3: e958ff           jmp 0x1c1e
  03D046  1CC6: ff46ba           inc word ptr [bp - 0x46]
  03D049  1CC9: c746e60100       mov word ptr [bp - 0x1a], 1
  03D04E  1CCE: e94dff           jmp 0x1c1e
  03D051  1CD1: 90               nop 
  03D052  1CD2: a03353           mov al, byte ptr [0x5333]
  03D055  1CD5: 2ae4             sub ah, ah
  03D057  1CD7: 3b4682           cmp ax, word ptr [bp - 0x7e]
  03D05A  1CDA: 7e03             jle 0x1cdf
  03D05C  1CDC: 8b4682           mov ax, word ptr [bp - 0x7e]
  03D05F  1CDF: 894682           mov word ptr [bp - 0x7e], ax
  03D062  1CE2: 8b46d8           mov ax, word ptr [bp - 0x28]
  03D065  1CE5: 3946ba           cmp word ptr [bp - 0x46], ax
  03D068  1CE8: 7c03             jl 0x1ced
  03D06A  1CEA: e98104           jmp 0x216e
  03D06D  1CED: 8b1e4285         mov bx, word ptr [0x8542]
  03D071  1CF1: 8a4701           mov al, byte ptr [bx + 1]
  03D074  1CF4: 2ae4             sub ah, ah
  03D076  1CF6: 50               push ax
  03D077  1CF7: 8a07             mov al, byte ptr [bx]
  03D079  1CF9: 50               push ax
  03D07A  1CFA: 9a22071f18       lcall 0x181f, 0x722
  03D07F  1CFF: 83c404           add sp, 4
  03D082  1D02: 8946e4           mov word ptr [bp - 0x1c], ax
  03D085  1D05: 2bc0             sub ax, ax
  03D087  1D07: 89469a           mov word ptr [bp - 0x66], ax
  03D08A  1D0A: 8946e0           mov word ptr [bp - 0x20], ax
  03D08D  1D0D: e91001           jmp 0x1e20
  03D090  1D10: 8b5ee0           mov bx, word ptr [bp - 0x20]
  03D093  1D13: 8a87be00         mov al, byte ptr [bx + 0xbe]
  03D097  1D17: 98               cwde 
  03D098  1D18: 8b364285         mov si, word ptr [0x8542]
  03D09C  1D1C: 8a4c01           mov cl, byte ptr [si + 1]
  03D09F  1D1F: 2aed             sub ch, ch
  03D0A1  1D21: 03c1             add ax, cx
  03D0A3  1D23: 8946e8           mov word ptr [bp - 0x18], ax
  03D0A6  1D26: c746ec0000       mov word ptr [bp - 0x14], 0
  03D0AB  1D2B: 50               push ax
  03D0AC  1D2C: 8a87b400         mov al, byte ptr [bx + 0xb4]
  03D0B0  1D30: 98               cwde 
  03D0B1  1D31: 8a0c             mov cl, byte ptr [si]
  03D0B3  1D33: 03c1             add ax, cx
  03D0B5  1D35: 8946f0           mov word ptr [bp - 0x10], ax
  03D0B8  1D38: 50               push ax
  03D0B9  1D39: 9a68071f18       lcall 0x181f, 0x768
  03D0BE  1D3E: 83c404           add sp, 4
  03D0C1  1D41: 0bc0             or ax, ax
  03D0C3  1D43: 7503             jne 0x1d48
  03D0C5  1D45: e9d500           jmp 0x1e1d
  03D0C8  1D48: ff76e8           push word ptr [bp - 0x18]
  03D0CB  1D4B: ff76f0           push word ptr [bp - 0x10]
  03D0CE  1D4E: 9ab4061f18       lcall 0x181f, 0x6b4
  03D0D3  1D53: 83c404           add sp, 4
  03D0D6  1D56: fec8             dec al
  03D0D8  1D58: 7403             je 0x1d5d
  03D0DA  1D5A: e9c000           jmp 0x1e1d
  03D0DD  1D5D: c746da0000       mov word ptr [bp - 0x26], 0
  03D0E2  1D62: 8b5eda           mov bx, word ptr [bp - 0x26]
  03D0E5  1D65: 8a87be00         mov al, byte ptr [bx + 0xbe]
  03D0E9  1D69: 98               cwde 
  03D0EA  1D6A: 0346e8           add ax, word ptr [bp - 0x18]
  03D0ED  1D6D: 8946f2           mov word ptr [bp - 0xe], ax
  03D0F0  1D70: 50               push ax
  03D0F1  1D71: 8a87b400         mov al, byte ptr [bx + 0xb4]
  03D0F5  1D75: 98               cwde 
  03D0F6  1D76: 0346f0           add ax, word ptr [bp - 0x10]
  03D0F9  1D79: 8946fc           mov word ptr [bp - 4], ax
  03D0FC  1D7C: 50               push ax
  03D0FD  1D7D: 9a68071f18       lcall 0x181f, 0x768
  03D102  1D82: 83c404           add sp, 4
  03D105  1D85: 0bc0             or ax, ax
  03D107  1D87: 7528             jne 0x1db1
  03D109  1D89: ff76f2           push word ptr [bp - 0xe]
  03D10C  1D8C: ff76fc           push word ptr [bp - 4]
  03D10F  1D8F: 9a22071f18       lcall 0x181f, 0x722
  03D114  1D94: 83c404           add sp, 4
  03D117  1D97: 3b46e4           cmp ax, word ptr [bp - 0x1c]
  03D11A  1D9A: 7515             jne 0x1db1
  03D11C  1D9C: ff76f2           push word ptr [bp - 0xe]
  03D11F  1D9F: ff76fc           push word ptr [bp - 4]
  03D122  1DA2: 9abe061f18       lcall 0x181f, 0x6be
  03D127  1DA7: 83c404           add sp, 4
  03D12A  1DAA: 0bc0             or ax, ax
  03D12C  1DAC: 7d03             jge 0x1db1
  03D12E  1DAE: ff46ec           inc word ptr [bp - 0x14]
  03D131  1DB1: ff46da           inc word ptr [bp - 0x26]
  03D134  1DB4: 837eda08         cmp word ptr [bp - 0x26], 8
  03D138  1DB8: 7ca8             jl 0x1d62
  03D13A  1DBA: 837eec00         cmp word ptr [bp - 0x14], 0
  03D13E  1DBE: 745d             je 0x1e1d
  03D140  1DC0: 8b46f0           mov ax, word ptr [bp - 0x10]
  03D143  1DC3: 8b56e8           mov dx, word ptr [bp - 0x18]
  03D146  1DC6: 9ae0071f18       lcall 0x181f, 0x7e0
  03D14B  1DCB: 8946b6           mov word ptr [bp - 0x4a], ax
  03D14E  1DCE: 0bc0             or ax, ax
  03D150  1DD0: 7c2e             jl 0x1e00
  03D152  1DD2: 6bd81c           imul bx, ax, 0x1c
  03D155  1DD5: 8a874731         mov al, byte ptr [bx + 0x3147]
  03D159  1DD9: 240f             and al, 0xf
  03D15B  1DDB: 3a06d253         cmp al, byte ptr [0x53d2]
  03D15F  1DDF: 741f             je 0x1e00
  03D161  1DE1: 6b5eb61c         imul bx, word ptr [bp - 0x4a], 0x1c
  03D165  1DE5: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03D16A  1DEA: 7505             jne 0x1df1
  03D16C  1DEC: c746ec0100       mov word ptr [bp - 0x14], 1
  03D171  1DF1: 8b46b6           mov ax, word ptr [bp - 0x4a]
  03D174  1DF4: 9ae4021f18       lcall 0x181f, 0x2e4
  03D179  1DF9: 8946b6           mov word ptr [bp - 0x4a], ax
  03D17C  1DFC: 0bc0             or ax, ax
  03D17E  1DFE: 7de1             jge 0x1de1
  03D180  1E00: 837eec00         cmp word ptr [bp - 0x14], 0
  03D184  1E04: 7c17             jl 0x1e1d
  03D186  1E06: 8b46ec           mov ax, word ptr [bp - 0x14]
  03D189  1E09: 39469a           cmp word ptr [bp - 0x66], ax
  03D18C  1E0C: 7d0f             jge 0x1e1d
  03D18E  1E0E: 89469a           mov word ptr [bp - 0x66], ax
  03D191  1E11: 8b46f0           mov ax, word ptr [bp - 0x10]
  03D194  1E14: 8946f4           mov word ptr [bp - 0xc], ax
  03D197  1E17: 8b46e8           mov ax, word ptr [bp - 0x18]
  03D19A  1E1A: 8946ea           mov word ptr [bp - 0x16], ax
  03D19D  1E1D: ff46e0           inc word ptr [bp - 0x20]
  03D1A0  1E20: 837ee008         cmp word ptr [bp - 0x20], 8
  03D1A4  1E24: 7d03             jge 0x1e29
  03D1A6  1E26: e9e7fe           jmp 0x1d10
  03D1A9  1E29: 837e9a00         cmp word ptr [bp - 0x66], 0
  03D1AD  1E2D: 7f03             jg 0x1e32
  03D1AF  1E2F: e93c03           jmp 0x216e
  03D1B2  1E32: ff76ea           push word ptr [bp - 0x16]
  03D1B5  1E35: ff76f4           push word ptr [bp - 0xc]
  03D1B8  1E38: 0e               push cs
  03D1B9  1E39: e86818           call 0x36a4
  03D1BC  1E3C: 83c404           add sp, 4
  03D1BF  1E3F: ff0ede53         dec word ptr [0x53de]
  03D1C3  1E43: ff76ea           push word ptr [bp - 0x16]
  03D1C6  1E46: ff76f4           push word ptr [bp - 0xc]
  03D1C9  1E49: ff36d253         push word ptr [0x53d2]
  03D1CD  1E4D: 6a12             push 0x12
  03D1CF  1E4F: 9a5c091f18       lcall 0x181f, 0x95c
  03D1D4  1E54: 83c408           add sp, 8
  03D1D7  1E57: 8946b6           mov word ptr [bp - 0x4a], ax
  03D1DA  1E5A: 0bc0             or ax, ax
  03D1DC  1E5C: 7d03             jge 0x1e61
  03D1DE  1E5E: e90d03           jmp 0x216e
  03D1E1  1E61: ff7606           push word ptr [bp + 6]
  03D1E4  1E64: 50               push ax
  03D1E5  1E65: 9a3e091f18       lcall 0x181f, 0x93e
  03D1EA  1E6A: 83c404           add sp, 4
  03D1ED  1E6D: 6a00             push 0
  03D1EF  1E6F: ff76ea           push word ptr [bp - 0x16]
  03D1F2  1E72: ff76f4           push word ptr [bp - 0xc]
  03D1F5  1E75: 9a080e1f18       lcall 0x181f, 0xe08
  03D1FA  1E7A: 83c406           add sp, 6
  03D1FD  1E7D: 6a03             push 3
  03D1FF  1E7F: 9aac041f18       lcall 0x181f, 0x4ac
  03D204  1E84: 83c402           add sp, 2
  03D207  1E87: a14285           mov ax, word ptr [0x8542]
  03D20A  1E8A: 40               inc ax
  03D20B  1E8B: 40               inc ax
  03D20C  1E8C: 1e               push ds
  03D20D  1E8D: 50               push ax
  03D20E  1E8E: 6a00             push 0
  03D210  1E90: 9a16041f18       lcall 0x181f, 0x416
  03D215  1E95: 83c406           add sp, 6
  03D218  1E98: 6a01             push 1
  03D21A  1E9A: 68bb12           push 0x12bb
  03D21D  1E9D: 9a52061f18       lcall 0x181f, 0x652
  03D222  1EA2: 83c404           add sp, 4
  03D225  1EA5: 2bc0             sub ax, ax
  03D227  1EA7: 8946fa           mov word ptr [bp - 6], ax
  03D22A  1EAA: 8946d4           mov word ptr [bp - 0x2c], ax
  03D22D  1EAD: 8946f6           mov word ptr [bp - 0xa], ax
  03D230  1EB0: 8b46d2           mov ax, word ptr [bp - 0x2e]
  03D233  1EB3: c1f803           sar ax, 3
  03D236  1EB6: 3d0100           cmp ax, 1
  03D239  1EB9: 7d03             jge 0x1ebe
  03D23B  1EBB: b80100           mov ax, 1
  03D23E  1EBE: 89469c           mov word ptr [bp - 0x64], ax
  03D241  1EC1: 833eda5302       cmp word ptr [0x53da], 2
  03D246  1EC6: 7c0b             jl 0x1ed3
  03D248  1EC8: 3d0200           cmp ax, 2
  03D24B  1ECB: 7e03             jle 0x1ed0
  03D24D  1ECD: b80200           mov ax, 2
  03D250  1ED0: 89469c           mov word ptr [bp - 0x64], ax
  03D253  1ED3: a1dc53           mov ax, word ptr [0x53dc]
  03D256  1ED6: 0306e053         add ax, word ptr [0x53e0]
  03D25A  1EDA: 3b06da53         cmp ax, word ptr [0x53da]
  03D25E  1EDE: 7f05             jg 0x1ee5
  03D260  1EE0: c7469c0100       mov word ptr [bp - 0x64], 1
  03D265  1EE5: 8b4682           mov ax, word ptr [bp - 0x7e]
  03D268  1EE8: 3d0300           cmp ax, 3
  03D26B  1EEB: 7d03             jge 0x1ef0
  03D26D  1EED: b80300           mov ax, 3
  03D270  1EF0: 894682           mov word ptr [bp - 0x7e], ax
  03D273  1EF3: 2bc0             sub ax, ax
  03D275  1EF5: 8946e2           mov word ptr [bp - 0x1e], ax
  03D278  1EF8: 8946ee           mov word ptr [bp - 0x12], ax
  03D27B  1EFB: e96202           jmp 0x2160
  03D27E  1EFE: 2bc0             sub ax, ax
  03D280  1F00: 8946d6           mov word ptr [bp - 0x2a], ax
  03D283  1F03: 8946e0           mov word ptr [bp - 0x20], ax
  03D286  1F06: eb14             jmp 0x1f1c
  03D288  1F08: 8b46f0           mov ax, word ptr [bp - 0x10]
  03D28B  1F0B: 8a0f             mov cl, byte ptr [bx]
  03D28D  1F0D: 2aed             sub ch, ch
  03D28F  1F0F: 2bc1             sub ax, cx
  03D291  1F11: f7d0             not ax
  03D293  1F13: 40               inc ax
  03D294  1F14: 3d0100           cmp ax, 1
  03D297  1F17: 7e5d             jle 0x1f76
  03D299  1F19: ff46e0           inc word ptr [bp - 0x20]
  03D29C  1F1C: 837ee008         cmp word ptr [bp - 0x20], 8
  03D2A0  1F20: 7c03             jl 0x1f25
  03D2A2  1F22: e97101           jmp 0x2096
  03D2A5  1F25: 8b5ee0           mov bx, word ptr [bp - 0x20]
  03D2A8  1F28: 8a87be00         mov al, byte ptr [bx + 0xbe]
  03D2AC  1F2C: 98               cwde 
  03D2AD  1F2D: 0346ea           add ax, word ptr [bp - 0x16]
  03D2B0  1F30: 8946e8           mov word ptr [bp - 0x18], ax
  03D2B3  1F33: 50               push ax
  03D2B4  1F34: 8a87b400         mov al, byte ptr [bx + 0xb4]
  03D2B8  1F38: 98               cwde 
  03D2B9  1F39: 0346f4           add ax, word ptr [bp - 0xc]
  03D2BC  1F3C: 8946f0           mov word ptr [bp - 0x10], ax
  03D2BF  1F3F: 50               push ax
  03D2C0  1F40: 9a68071f18       lcall 0x181f, 0x768
  03D2C5  1F45: 83c404           add sp, 4
  03D2C8  1F48: 0bc0             or ax, ax
  03D2CA  1F4A: 75cd             jne 0x1f19
  03D2CC  1F4C: ff76e8           push word ptr [bp - 0x18]
  03D2CF  1F4F: ff76f0           push word ptr [bp - 0x10]
  03D2D2  1F52: 9abe061f18       lcall 0x181f, 0x6be
  03D2D7  1F57: 83c404           add sp, 4
  03D2DA  1F5A: 0bc0             or ax, ax
  03D2DC  1F5C: 7dbb             jge 0x1f19
  03D2DE  1F5E: 8b1e4285         mov bx, word ptr [0x8542]
  03D2E2  1F62: 8a07             mov al, byte ptr [bx]
  03D2E4  1F64: 2ae4             sub ah, ah
  03D2E6  1F66: 2b46f0           sub ax, word ptr [bp - 0x10]
  03D2E9  1F69: f7d8             neg ax
  03D2EB  1F6B: 89867eff         mov word ptr [bp - 0x82], ax
  03D2EF  1F6F: 0bc0             or ax, ax
  03D2F1  1F71: 7e95             jle 0x1f08
  03D2F3  1F73: eb9f             jmp 0x1f14
  03D2F5  1F75: 90               nop 
  03D2F6  1F76: 8a4701           mov al, byte ptr [bx + 1]
  03D2F9  1F79: 2ae4             sub ah, ah
  03D2FB  1F7B: 2b46e8           sub ax, word ptr [bp - 0x18]
  03D2FE  1F7E: f7d8             neg ax
  03D300  1F80: 894680           mov word ptr [bp - 0x80], ax
  03D303  1F83: 0bc0             or ax, ax
  03D305  1F85: 7f0d             jg 0x1f94
  03D307  1F87: 8b46e8           mov ax, word ptr [bp - 0x18]
  03D30A  1F8A: 8a4f01           mov cl, byte ptr [bx + 1]
  03D30D  1F8D: 2aed             sub ch, ch
  03D30F  1F8F: 2bc1             sub ax, cx
  03D311  1F91: f7d0             not ax
  03D313  1F93: 40               inc ax
  03D314  1F94: 3d0100           cmp ax, 1
  03D317  1F97: 7e03             jle 0x1f9c
  03D319  1F99: e97dff           jmp 0x1f19
  03D31C  1F9C: ff76e8           push word ptr [bp - 0x18]
  03D31F  1F9F: ff76f0           push word ptr [bp - 0x10]
  03D322  1FA2: 9a22071f18       lcall 0x181f, 0x722
  03D327  1FA7: 83c404           add sp, 4
  03D32A  1FAA: 8946dc           mov word ptr [bp - 0x24], ax
  03D32D  1FAD: 3b46e4           cmp ax, word ptr [bp - 0x1c]
  03D330  1FB0: 7403             je 0x1fb5
  03D332  1FB2: e964ff           jmp 0x1f19
  03D335  1FB5: 837e8200         cmp word ptr [bp - 0x7e], 0
  03D339  1FB9: 7f03             jg 0x1fbe
  03D33B  1FBB: e95bff           jmp 0x1f19
  03D33E  1FBE: 2bc0             sub ax, ax
  03D340  1FC0: 89469e           mov word ptr [bp - 0x62], ax
  03D343  1FC3: 8946b8           mov word ptr [bp - 0x48], ax
  03D346  1FC6: ff76e8           push word ptr [bp - 0x18]
  03D349  1FC9: ff76f0           push word ptr [bp - 0x10]
  03D34C  1FCC: 9adc061f18       lcall 0x181f, 0x6dc
  03D351  1FD1: 83c404           add sp, 4
  03D354  1FD4: 3a06d253         cmp al, byte ptr [0x53d2]
  03D358  1FD8: 744e             je 0x2028
  03D35A  1FDA: 6a02             push 2
  03D35C  1FDC: 8b46f0           mov ax, word ptr [bp - 0x10]
  03D35F  1FDF: 8b56e8           mov dx, word ptr [bp - 0x18]
  03D362  1FE2: 9ae0071f18       lcall 0x181f, 0x7e0
  03D367  1FE7: 8946b6           mov word ptr [bp - 0x4a], ax
  03D36A  1FEA: 50               push ax
  03D36B  1FEB: 9abc081f18       lcall 0x181f, 0x8bc
  03D370  1FF0: 83c404           add sp, 4
  03D373  1FF3: 8946a0           mov word ptr [bp - 0x60], ax
  03D376  1FF6: 837eee00         cmp word ptr [bp - 0x12], 0
  03D37A  1FFA: 751a             jne 0x2016
  03D37C  1FFC: 8b46de           mov ax, word ptr [bp - 0x22]
  03D37F  1FFF: 3946a0           cmp word ptr [bp - 0x60], ax
  03D382  2002: 7c03             jl 0x2007
  03D384  2004: e912ff           jmp 0x1f19
  03D387  2007: c746e20100       mov word ptr [bp - 0x1e], 1
  03D38C  200C: 8b46a0           mov ax, word ptr [bp - 0x60]
  03D38F  200F: 8946de           mov word ptr [bp - 0x22], ax
  03D392  2012: e904ff           jmp 0x1f19
  03D395  2015: 90               nop 
  03D396  2016: 8b46de           mov ax, word ptr [bp - 0x22]
  03D399  2019: 3946a0           cmp word ptr [bp - 0x60], ax
  03D39C  201C: 7e03             jle 0x2021
  03D39E  201E: e9f8fe           jmp 0x1f19
  03D3A1  2021: c746b80100       mov word ptr [bp - 0x48], 1
  03D3A6  2026: eb31             jmp 0x2059
  03D3A8  2028: 8b46f6           mov ax, word ptr [bp - 0xa]
  03D3AB  202B: 39469c           cmp word ptr [bp - 0x64], ax
  03D3AE  202E: 7e12             jle 0x2042
  03D3B0  2030: 833edc5300       cmp word ptr [0x53dc], 0
  03D3B5  2035: 740b             je 0x2042
  03D3B7  2037: ff46f6           inc word ptr [bp - 0xa]
  03D3BA  203A: c7469e0100       mov word ptr [bp - 0x62], 1
  03D3BF  203F: eb18             jmp 0x2059
  03D3C1  2041: 90               nop 
  03D3C2  2042: 8b46d4           mov ax, word ptr [bp - 0x2c]
  03D3C5  2045: 39469c           cmp word ptr [bp - 0x64], ax
  03D3C8  2048: 7e0f             jle 0x2059
  03D3CA  204A: 833ee05300       cmp word ptr [0x53e0], 0
  03D3CF  204F: 7408             je 0x2059
  03D3D1  2051: ff46d4           inc word ptr [bp - 0x2c]
  03D3D4  2054: c7469e0300       mov word ptr [bp - 0x62], 3
  03D3D9  2059: 8b5e9e           mov bx, word ptr [bp - 0x62]
  03D3DC  205C: d1e3             shl bx, 1
  03D3DE  205E: 83bfda5300       cmp word ptr [bx + 0x53da], 0
  03D3E3  2063: 7f03             jg 0x2068
  03D3E5  2065: e9b1fe           jmp 0x1f19
  03D3E8  2068: ff36d253         push word ptr [0x53d2]
  03D3EC  206C: ff769e           push word ptr [bp - 0x62]
  03D3EF  206F: 0e               push cs
  03D3F0  2070: e81d16           call 0x3690
  03D3F3  2073: 83c404           add sp, 4
  03D3F6  2076: 8946f8           mov word ptr [bp - 8], ax
  03D3F9  2079: 6afe             push -2
  03D3FB  207B: 6afe             push -2
  03D3FD  207D: ff36d253         push word ptr [0x53d2]
  03D401  2081: 50               push ax
  03D402  2082: 9a5c091f18       lcall 0x181f, 0x95c
  03D407  2087: 83c408           add sp, 8
  03D40A  208A: 8946b6           mov word ptr [bp - 0x4a], ax
  03D40D  208D: 0bc0             or ax, ax
  03D40F  208F: 7d25             jge 0x20b6
  03D411  2091: c746820000       mov word ptr [bp - 0x7e], 0
  03D416  2096: 837ed600         cmp word ptr [bp - 0x2a], 0
  03D41A  209A: 7403             je 0x209f
  03D41C  209C: e9b900           jmp 0x2158
  03D41F  209F: 837ee200         cmp word ptr [bp - 0x1e], 0
  03D423  20A3: 7409             je 0x20ae
  03D425  20A5: 837eee00         cmp word ptr [bp - 0x12], 0
  03D429  20A9: 7503             jne 0x20ae
  03D42B  20AB: e9a200           jmp 0x2150
  03D42E  20AE: c746820000       mov word ptr [bp - 0x7e], 0
  03D433  20B3: e9af00           jmp 0x2165
  03D436  20B6: 50               push ax
  03D437  20B7: 9a34091f18       lcall 0x181f, 0x934
  03D43C  20BC: 83c402           add sp, 2
  03D43F  20BF: ff7606           push word ptr [bp + 6]
  03D442  20C2: ff76b6           push word ptr [bp - 0x4a]
  03D445  20C5: 9a3e091f18       lcall 0x181f, 0x93e
  03D44A  20CA: 83c404           add sp, 4
  03D44D  20CD: ff76e8           push word ptr [bp - 0x18]
  03D450  20D0: ff76f0           push word ptr [bp - 0x10]
  03D453  20D3: ff76ea           push word ptr [bp - 0x16]
  03D456  20D6: ff76f4           push word ptr [bp - 0xc]
  03D459  20D9: 6aff             push -1
  03D45B  20DB: 68c000           push 0xc0
  03D45E  20DE: ff76b6           push word ptr [bp - 0x4a]
  03D461  20E1: 9ad0021f18       lcall 0x181f, 0x2d0
  03D466  20E6: 83c40e           add sp, 0xe
  03D469  20E9: 837eb800         cmp word ptr [bp - 0x48], 0
  03D46D  20ED: 741a             je 0x2109
  03D46F  20EF: ff76e8           push word ptr [bp - 0x18]
  03D472  20F2: ff76f0           push word ptr [bp - 0x10]
  03D475  20F5: 0e               push cs
  03D476  20F6: e8ab15           call 0x36a4
  03D479  20F9: 83c404           add sp, 4
  03D47C  20FC: b8feff           mov ax, 0xfffe
  03D47F  20FF: 8bd0             mov dx, ax
  03D481  2101: 9ae0071f18       lcall 0x181f, 0x7e0
  03D486  2106: 8946b6           mov word ptr [bp - 0x4a], ax
  03D489  2109: ff76e8           push word ptr [bp - 0x18]
  03D48C  210C: ff76f0           push word ptr [bp - 0x10]
  03D48F  210F: ff76b6           push word ptr [bp - 0x4a]
  03D492  2112: 9a48091f18       lcall 0x181f, 0x948
  03D497  2117: 83c406           add sp, 6
  03D49A  211A: 6a01             push 1
  03D49C  211C: 6a05             push 5
  03D49E  211E: 6a05             push 5
  03D4A0  2120: 8b1e4285         mov bx, word ptr [0x8542]
  03D4A4  2124: 8a4701           mov al, byte ptr [bx + 1]
  03D4A7  2127: 2ae4             sub ah, ah
  03D4A9  2129: 48               dec ax
  03D4AA  212A: 48               dec ax
  03D4AB  212B: 50               push ax
  03D4AC  212C: 8a07             mov al, byte ptr [bx]
  03D4AE  212E: 2ae4             sub ah, ah
  03D4B0  2130: 48               dec ax
  03D4B1  2131: 48               dec ax
  03D4B2  2132: 50               push ax
  03D4B3  2133: 9aba091f18       lcall 0x181f, 0x9ba
  03D4B8  2138: 83c40a           add sp, 0xa
  03D4BB  213B: 8b5e9e           mov bx, word ptr [bp - 0x62]
  03D4BE  213E: d1e3             shl bx, 1
  03D4C0  2140: ff8fda53         dec word ptr [bx + 0x53da]
  03D4C4  2144: ff4e82           dec word ptr [bp - 0x7e]
  03D4C7  2147: c746d60100       mov word ptr [bp - 0x2a], 1
  03D4CC  214C: e9cafd           jmp 0x1f19
  03D4CF  214F: 90               nop 
  03D4D0  2150: c746ee0100       mov word ptr [bp - 0x12], 1
  03D4D5  2155: eb0e             jmp 0x2165
  03D4D7  2157: 90               nop 
  03D4D8  2158: 2bc0             sub ax, ax
  03D4DA  215A: 8946ee           mov word ptr [bp - 0x12], ax
  03D4DD  215D: 8946e2           mov word ptr [bp - 0x1e], ax
  03D4E0  2160: c746de6300       mov word ptr [bp - 0x22], 0x63
  03D4E5  2165: 837e8200         cmp word ptr [bp - 0x7e], 0
  03D4E9  2169: 7403             je 0x216e
  03D4EB  216B: e990fd           jmp 0x1efe
  03D4EE  216E: 837efa00         cmp word ptr [bp - 6], 0
  03D4F2  2172: 7419             je 0x218d
  03D4F4  2174: c7469e0000       mov word ptr [bp - 0x62], 0
  03D4F9  2179: 8b5e9e           mov bx, word ptr [bp - 0x62]
  03D4FC  217C: d1e3             shl bx, 1
  03D4FE  217E: c787da530000     mov word ptr [bx + 0x53da], 0
  03D504  2184: ff469e           inc word ptr [bp - 0x62]
  03D507  2187: 837e9e04         cmp word ptr [bp - 0x62], 4
  03D50B  218B: 7cec             jl 0x2179
  03D50D  218D: 5e               pop si
  03D50E  218E: c9               leave 
  03D50F  218F: cb               retf 

; ---- func_03D510  size=1080  insns=374  prologue=ENTER 0x0056,0  terminal=RETF ----
  03D510  2190: c8560000         enter 0x56, 0
  03D514  2194: 56               push si
  03D515  2195: a19853           mov ax, word ptr [0x5398]
  03D518  2198: 8946aa           mov word ptr [bp - 0x56], ax
  03D51B  219B: 2bc0             sub ax, ax
  03D51D  219D: 8946de           mov word ptr [bp - 0x22], ax
  03D520  21A0: 8946ea           mov word ptr [bp - 0x16], ax
  03D523  21A3: 8946ac           mov word ptr [bp - 0x54], ax
  03D526  21A6: eb3f             jmp 0x21e7
  03D528  21A8: 50               push ax
  03D529  21A9: 9ae6091f18       lcall 0x181f, 0x9e6
  03D52E  21AE: 83c402           add sp, 2
  03D531  21B1: 8a46aa           mov al, byte ptr [bp - 0x56]
  03D534  21B4: 8b1e4285         mov bx, word ptr [0x8542]
  03D538  21B8: 38471a           cmp byte ptr [bx + 0x1a], al
  03D53B  21BB: 7527             jne 0x21e4
  03D53D  21BD: f6471c40         test byte ptr [bx + 0x1c], 0x40
  03D541  21C1: 7421             je 0x21e4
  03D543  21C3: 837ede0a         cmp word ptr [bp - 0x22], 0xa
  03D547  21C7: 7d1b             jge 0x21e4
  03D549  21C9: 8a471f           mov al, byte ptr [bx + 0x1f]
  03D54C  21CC: 98               cwde 
  03D54D  21CD: 8b76de           mov si, word ptr [bp - 0x22]
  03D550  21D0: d1e6             shl si, 1
  03D552  21D2: 8942ba           mov word ptr [bp + si - 0x46], ax
  03D555  21D5: 0146ea           add word ptr [bp - 0x16], ax
  03D558  21D8: 8a46ac           mov al, byte ptr [bp - 0x54]
  03D55B  21DB: 8b76de           mov si, word ptr [bp - 0x22]
  03D55E  21DE: 8842d2           mov byte ptr [bp + si - 0x2e], al
  03D561  21E1: ff46de           inc word ptr [bp - 0x22]
  03D564  21E4: ff46ac           inc word ptr [bp - 0x54]
  03D567  21E7: 8b46ac           mov ax, word ptr [bp - 0x54]
  03D56A  21EA: 39069e53         cmp word ptr [0x539e], ax
  03D56E  21EE: 7fb8             jg 0x21a8
  03D570  21F0: 837ede00         cmp word ptr [bp - 0x22], 0
  03D574  21F4: 7503             jne 0x21f9
  03D576  21F6: e9cc03           jmp 0x25c5
  03D579  21F9: ff76ea           push word ptr [bp - 0x16]
  03D57C  21FC: 6a01             push 1
  03D57E  21FE: 9ad4041f18       lcall 0x181f, 0x4d4
  03D583  2203: 83c404           add sp, 4
  03D586  2206: 8946d0           mov word ptr [bp - 0x30], ax
  03D589  2209: c746acffff       mov word ptr [bp - 0x54], 0xffff
  03D58E  220E: c746dc0000       mov word ptr [bp - 0x24], 0
  03D593  2213: eb28             jmp 0x223d
  03D595  2215: 90               nop 
  03D596  2216: 8b46de           mov ax, word ptr [bp - 0x22]
  03D599  2219: 3946dc           cmp word ptr [bp - 0x24], ax
  03D59C  221C: 7d25             jge 0x2243
  03D59E  221E: 8b76dc           mov si, word ptr [bp - 0x24]
  03D5A1  2221: d1e6             shl si, 1
  03D5A3  2223: 8b42ba           mov ax, word ptr [bp + si - 0x46]
  03D5A6  2226: 2946d0           sub word ptr [bp - 0x30], ax
  03D5A9  2229: 837ed000         cmp word ptr [bp - 0x30], 0
  03D5AD  222D: 7f0b             jg 0x223a
  03D5AF  222F: 8b76dc           mov si, word ptr [bp - 0x24]
  03D5B2  2232: 8a42d2           mov al, byte ptr [bp + si - 0x2e]
  03D5B5  2235: 2ae4             sub ah, ah
  03D5B7  2237: 8946ac           mov word ptr [bp - 0x54], ax
  03D5BA  223A: ff46dc           inc word ptr [bp - 0x24]
  03D5BD  223D: 837eac00         cmp word ptr [bp - 0x54], 0
  03D5C1  2241: 7cd3             jl 0x2216
  03D5C3  2243: 837eac00         cmp word ptr [bp - 0x54], 0
  03D5C7  2247: 7d03             jge 0x224c
  03D5C9  2249: e97903           jmp 0x25c5
  03D5CC  224C: ff76ac           push word ptr [bp - 0x54]
  03D5CF  224F: 9ae6091f18       lcall 0x181f, 0x9e6
  03D5D4  2254: 83c402           add sp, 2
  03D5D7  2257: 8b1e4285         mov bx, word ptr [0x8542]
  03D5DB  225B: 8a4701           mov al, byte ptr [bx + 1]
  03D5DE  225E: 2ae4             sub ah, ah
  03D5E0  2260: 50               push ax
  03D5E1  2261: 8a07             mov al, byte ptr [bx]
  03D5E3  2263: 50               push ax
  03D5E4  2264: 9a22071f18       lcall 0x181f, 0x722
  03D5E9  2269: 83c404           add sp, 4
  03D5EC  226C: 8946e4           mov word ptr [bp - 0x1c], ax
  03D5EF  226F: 2bc0             sub ax, ax
  03D5F1  2271: 8946ae           mov word ptr [bp - 0x52], ax
  03D5F4  2274: 8946e2           mov word ptr [bp - 0x1e], ax
  03D5F7  2277: e92701           jmp 0x23a1
  03D5FA  227A: 8b5ee2           mov bx, word ptr [bp - 0x1e]
  03D5FD  227D: 8a87be00         mov al, byte ptr [bx + 0xbe]
  03D601  2281: 98               cwde 
  03D602  2282: 8b364285         mov si, word ptr [0x8542]
  03D606  2286: 8a4c01           mov cl, byte ptr [si + 1]
  03D609  2289: 2aed             sub ch, ch
  03D60B  228B: 03c1             add ax, cx
  03D60D  228D: 8946ec           mov word ptr [bp - 0x14], ax
  03D610  2290: c746f00100       mov word ptr [bp - 0x10], 1
  03D615  2295: 50               push ax
  03D616  2296: 8a87b400         mov al, byte ptr [bx + 0xb4]
  03D61A  229A: 98               cwde 
  03D61B  229B: 8a0c             mov cl, byte ptr [si]
  03D61D  229D: 03c1             add ax, cx
  03D61F  229F: 8946f2           mov word ptr [bp - 0xe], ax
  03D622  22A2: 50               push ax
  03D623  22A3: 9a68071f18       lcall 0x181f, 0x768
  03D628  22A8: 83c404           add sp, 4
  03D62B  22AB: 0bc0             or ax, ax
  03D62D  22AD: 7503             jne 0x22b2
  03D62F  22AF: e9ec00           jmp 0x239e
  03D632  22B2: ff76ec           push word ptr [bp - 0x14]
  03D635  22B5: ff76f2           push word ptr [bp - 0xe]
  03D638  22B8: 9ab4061f18       lcall 0x181f, 0x6b4
  03D63D  22BD: 83c404           add sp, 4
  03D640  22C0: fec8             dec al
  03D642  22C2: 7403             je 0x22c7
  03D644  22C4: e9d700           jmp 0x239e
  03D647  22C7: 8b46f2           mov ax, word ptr [bp - 0xe]
  03D64A  22CA: 8b56ec           mov dx, word ptr [bp - 0x14]
  03D64D  22CD: 9ae0071f18       lcall 0x181f, 0x7e0
  03D652  22D2: 8946ce           mov word ptr [bp - 0x32], ax
  03D655  22D5: 0bc0             or ax, ax
  03D657  22D7: 7c2e             jl 0x2307
  03D659  22D9: 6bd81c           imul bx, ax, 0x1c
  03D65C  22DC: 8a874731         mov al, byte ptr [bx + 0x3147]
  03D660  22E0: 240f             and al, 0xf
  03D662  22E2: 3a06d253         cmp al, byte ptr [0x53d2]
  03D666  22E6: 751f             jne 0x2307
  03D668  22E8: 6b5ece1c         imul bx, word ptr [bp - 0x32], 0x1c
  03D66C  22EC: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03D671  22F1: 7505             jne 0x22f8
  03D673  22F3: 816ef0e703       sub word ptr [bp - 0x10], 0x3e7
  03D678  22F8: 8b46ce           mov ax, word ptr [bp - 0x32]
  03D67B  22FB: 9ae4021f18       lcall 0x181f, 0x2e4
  03D680  2300: 8946ce           mov word ptr [bp - 0x32], ax
  03D683  2303: 0bc0             or ax, ax
  03D685  2305: 7de1             jge 0x22e8
  03D687  2307: 837ef000         cmp word ptr [bp - 0x10], 0
  03D68B  230B: 7d03             jge 0x2310
  03D68D  230D: e98e00           jmp 0x239e
  03D690  2310: ff76ec           push word ptr [bp - 0x14]
  03D693  2313: ff76f2           push word ptr [bp - 0xe]
  03D696  2316: 9a82061f18       lcall 0x181f, 0x682
  03D69B  231B: 83c404           add sp, 4
  03D69E  231E: 8946fe           mov word ptr [bp - 2], ax
  03D6A1  2321: 0bc0             or ax, ax
  03D6A3  2323: 7c05             jl 0x232a
  03D6A5  2325: 3b46aa           cmp ax, word ptr [bp - 0x56]
  03D6A8  2328: 7574             jne 0x239e
  03D6AA  232A: c746e00000       mov word ptr [bp - 0x20], 0
  03D6AF  232F: 8b5ee0           mov bx, word ptr [bp - 0x20]
  03D6B2  2332: 8a87be00         mov al, byte ptr [bx + 0xbe]
  03D6B6  2336: 98               cwde 
  03D6B7  2337: 0346ec           add ax, word ptr [bp - 0x14]
  03D6BA  233A: 8946f4           mov word ptr [bp - 0xc], ax
  03D6BD  233D: 50               push ax
  03D6BE  233E: 8a87b400         mov al, byte ptr [bx + 0xb4]
  03D6C2  2342: 98               cwde 
  03D6C3  2343: 0346f2           add ax, word ptr [bp - 0xe]
  03D6C6  2346: 8946fc           mov word ptr [bp - 4], ax
  03D6C9  2349: 50               push ax
  03D6CA  234A: 9a68071f18       lcall 0x181f, 0x768
  03D6CF  234F: 83c404           add sp, 4
  03D6D2  2352: 0bc0             or ax, ax
  03D6D4  2354: 7528             jne 0x237e
  03D6D6  2356: ff76f4           push word ptr [bp - 0xc]
  03D6D9  2359: ff76fc           push word ptr [bp - 4]
  03D6DC  235C: 9a22071f18       lcall 0x181f, 0x722
  03D6E1  2361: 83c404           add sp, 4
  03D6E4  2364: 3b46e4           cmp ax, word ptr [bp - 0x1c]
  03D6E7  2367: 7515             jne 0x237e
  03D6E9  2369: ff76f4           push word ptr [bp - 0xc]
  03D6EC  236C: ff76fc           push word ptr [bp - 4]
  03D6EF  236F: 9abe061f18       lcall 0x181f, 0x6be
  03D6F4  2374: 83c404           add sp, 4
  03D6F7  2377: 0bc0             or ax, ax
  03D6F9  2379: 7d03             jge 0x237e
  03D6FB  237B: ff46f0           inc word ptr [bp - 0x10]
  03D6FE  237E: ff46e0           inc word ptr [bp - 0x20]
  03D701  2381: 837ee008         cmp word ptr [bp - 0x20], 8
  03D705  2385: 7ca8             jl 0x232f
  03D707  2387: 8b46f0           mov ax, word ptr [bp - 0x10]
  03D70A  238A: 3946ae           cmp word ptr [bp - 0x52], ax
  03D70D  238D: 7d0f             jge 0x239e
  03D70F  238F: 8946ae           mov word ptr [bp - 0x52], ax
  03D712  2392: 8b46f2           mov ax, word ptr [bp - 0xe]
  03D715  2395: 8946f6           mov word ptr [bp - 0xa], ax
  03D718  2398: 8b46ec           mov ax, word ptr [bp - 0x14]
  03D71B  239B: 8946ee           mov word ptr [bp - 0x12], ax
  03D71E  239E: ff46e2           inc word ptr [bp - 0x1e]
  03D721  23A1: 837ee208         cmp word ptr [bp - 0x1e], 8
  03D725  23A5: 7d03             jge 0x23aa
  03D727  23A7: e9d0fe           jmp 0x227a
  03D72A  23AA: 837eae00         cmp word ptr [bp - 0x52], 0
  03D72E  23AE: 7f03             jg 0x23b3
  03D730  23B0: e91202           jmp 0x25c5
  03D733  23B3: 837e0600         cmp word ptr [bp + 6], 0
  03D737  23B7: 7504             jne 0x23bd
  03D739  23B9: ff0ee653         dec word ptr [0x53e6]
  03D73D  23BD: ff76ee           push word ptr [bp - 0x12]
  03D740  23C0: ff76f6           push word ptr [bp - 0xa]
  03D743  23C3: ff76aa           push word ptr [bp - 0x56]
  03D746  23C6: 6a12             push 0x12
  03D748  23C8: 9a5c091f18       lcall 0x181f, 0x95c
  03D74D  23CD: 83c408           add sp, 8
  03D750  23D0: 8946ce           mov word ptr [bp - 0x32], ax
  03D753  23D3: 8946e6           mov word ptr [bp - 0x1a], ax
  03D756  23D6: 0bc0             or ax, ax
  03D758  23D8: 7d03             jge 0x23dd
  03D75A  23DA: e9e801           jmp 0x25c5
  03D75D  23DD: ff76aa           push word ptr [bp - 0x56]
  03D760  23E0: 50               push ax
  03D761  23E1: 9a3e091f18       lcall 0x181f, 0x93e
  03D766  23E6: 83c404           add sp, 4
  03D769  23E9: 6a00             push 0
  03D76B  23EB: ff76ee           push word ptr [bp - 0x12]
  03D76E  23EE: ff76f6           push word ptr [bp - 0xa]
  03D771  23F1: 9a080e1f18       lcall 0x181f, 0xe08
  03D776  23F6: 83c406           add sp, 6
  03D779  23F9: a14285           mov ax, word ptr [0x8542]
  03D77C  23FC: 40               inc ax
  03D77D  23FD: 40               inc ax
  03D77E  23FE: 1e               push ds
  03D77F  23FF: 50               push ax
  03D780  2400: 6a00             push 0
  03D782  2402: 9a16041f18       lcall 0x181f, 0x416
  03D787  2407: 83c406           add sp, 6
  03D78A  240A: 837e0600         cmp word ptr [bp + 6], 0
  03D78E  240E: 7532             jne 0x2442
  03D790  2410: 6a03             push 3
  03D792  2412: 9a98041f18       lcall 0x181f, 0x498
  03D797  2417: 83c402           add sp, 2
  03D79A  241A: ff36d453         push word ptr [0x53d4]
  03D79E  241E: 9aa4091f18       lcall 0x181f, 0x9a4
  03D7A3  2423: 83c402           add sp, 2
  03D7A6  2426: 50               push ax
  03D7A7  2427: 6a01             push 1
  03D7A9  2429: 9a38041f18       lcall 0x181f, 0x438
  03D7AE  242E: 83c404           add sp, 4
  03D7B1  2431: b83f00           mov ax, 0x3f
  03D7B4  2434: 9ac0041f18       lcall 0x181f, 0x4c0
  03D7B9  2439: 6a01             push 1
  03D7BB  243B: 68c412           push 0x12c4
  03D7BE  243E: eb1e             jmp 0x245e
  03D7C0  2440: 90               nop 
  03D7C1  2441: 90               nop 
  03D7C2  2442: ff36d653         push word ptr [0x53d6]
  03D7C6  2446: 9aa4091f18       lcall 0x181f, 0x9a4
  03D7CB  244B: 83c402           add sp, 2
  03D7CE  244E: 50               push ax
  03D7CF  244F: 6a01             push 1
  03D7D1  2451: 9a38041f18       lcall 0x181f, 0x438
  03D7D6  2456: 83c404           add sp, 4
  03D7D9  2459: 6a01             push 1
  03D7DB  245B: 68ce12           push 0x12ce
  03D7DE  245E: 9a52061f18       lcall 0x181f, 0x652
  03D7E3  2463: 83c404           add sp, 4
  03D7E6  2466: c746e80100       mov word ptr [bp - 0x18], 1
  03D7EB  246B: c746b20600       mov word ptr [bp - 0x4e], 6
  03D7F0  2470: 2bc0             sub ax, ax
  03D7F2  2472: 8946b4           mov word ptr [bp - 0x4c], ax
  03D7F5  2475: 8946b8           mov word ptr [bp - 0x48], ax
  03D7F8  2478: 3906e453         cmp word ptr [0x53e4], ax
  03D7FC  247C: 740e             je 0x248c
  03D7FE  247E: a1e453           mov ax, word ptr [0x53e4]
  03D801  2481: 3d0200           cmp ax, 2
  03D804  2484: 7e03             jle 0x2489
  03D806  2486: b80200           mov ax, 2
  03D809  2489: 8946b4           mov word ptr [bp - 0x4c], ax
  03D80C  248C: 833ee85300       cmp word ptr [0x53e8], 0
  03D811  2491: 740e             je 0x24a1
  03D813  2493: a1e853           mov ax, word ptr [0x53e8]
  03D816  2496: 3d0200           cmp ax, 2
  03D819  2499: 7e03             jle 0x249e
  03D81B  249B: b80200           mov ax, 2
  03D81E  249E: 8946b8           mov word ptr [bp - 0x48], ax
  03D821  24A1: 8b46b4           mov ax, word ptr [bp - 0x4c]
  03D824  24A4: 0346b8           add ax, word ptr [bp - 0x48]
  03D827  24A7: 2946b2           sub word ptr [bp - 0x4e], ax
  03D82A  24AA: c746b00000       mov word ptr [bp - 0x50], 0
  03D82F  24AF: e9b000           jmp 0x2562
  03D832  24B2: 6bd81c           imul bx, ax, 0x1c
  03D835  24B5: c6875b3115       mov byte ptr [bx + 0x315b], 0x15
  03D83A  24BA: ff76aa           push word ptr [bp - 0x56]
  03D83D  24BD: ff76ce           push word ptr [bp - 0x32]
  03D840  24C0: 9a3e091f18       lcall 0x181f, 0x93e
  03D845  24C5: 83c404           add sp, 4
  03D848  24C8: 8b1e4285         mov bx, word ptr [0x8542]
  03D84C  24CC: 8a4701           mov al, byte ptr [bx + 1]
  03D84F  24CF: 2ae4             sub ah, ah
  03D851  24D1: 50               push ax
  03D852  24D2: 8a07             mov al, byte ptr [bx]
  03D854  24D4: 50               push ax
  03D855  24D5: ff76ee           push word ptr [bp - 0x12]
  03D858  24D8: ff76f6           push word ptr [bp - 0xa]
  03D85B  24DB: 6aff             push -1
  03D85D  24DD: 68c000           push 0xc0
  03D860  24E0: ff76ce           push word ptr [bp - 0x32]
  03D863  24E3: 9ad0021f18       lcall 0x181f, 0x2d0
  03D868  24E8: 83c40e           add sp, 0xe
  03D86B  24EB: 8b1e4285         mov bx, word ptr [0x8542]
  03D86F  24EF: 8a4701           mov al, byte ptr [bx + 1]
  03D872  24F2: 2ae4             sub ah, ah
  03D874  24F4: 50               push ax
  03D875  24F5: 8a07             mov al, byte ptr [bx]
  03D877  24F7: 50               push ax
  03D878  24F8: ff76ce           push word ptr [bp - 0x32]
  03D87B  24FB: 9a48091f18       lcall 0x181f, 0x948
  03D880  2500: 83c406           add sp, 6
  03D883  2503: 6a01             push 1
  03D885  2505: 6a05             push 5
  03D887  2507: 6a05             push 5
  03D889  2509: 8b1e4285         mov bx, word ptr [0x8542]
  03D88D  250D: 8a4701           mov al, byte ptr [bx + 1]
  03D890  2510: 2ae4             sub ah, ah
  03D892  2512: 48               dec ax
  03D893  2513: 48               dec ax
  03D894  2514: 50               push ax
  03D895  2515: 8a07             mov al, byte ptr [bx]
  03D897  2517: 2ae4             sub ah, ah
  03D899  2519: 48               dec ax
  03D89A  251A: 48               dec ax
  03D89B  251B: 50               push ax
  03D89C  251C: 9aba091f18       lcall 0x181f, 0x9ba
  03D8A1  2521: 83c40a           add sp, 0xa
  03D8A4  2524: 837e0600         cmp word ptr [bp + 6], 0
  03D8A8  2528: 7509             jne 0x2533
  03D8AA  252A: 8b5eb0           mov bx, word ptr [bp - 0x50]
  03D8AD  252D: d1e3             shl bx, 1
  03D8AF  252F: ff8fe253         dec word ptr [bx + 0x53e2]
  03D8B3  2533: ff46dc           inc word ptr [bp - 0x24]
  03D8B6  2536: 8b46fa           mov ax, word ptr [bp - 6]
  03D8B9  2539: 3946dc           cmp word ptr [bp - 0x24], ax
  03D8BC  253C: 7d21             jge 0x255f
  03D8BE  253E: 6afe             push -2
  03D8C0  2540: 6afe             push -2
  03D8C2  2542: ff76aa           push word ptr [bp - 0x56]
  03D8C5  2545: ff76f8           push word ptr [bp - 8]
  03D8C8  2548: 9a5c091f18       lcall 0x181f, 0x95c
  03D8CD  254D: 83c408           add sp, 8
  03D8D0  2550: 8946ce           mov word ptr [bp - 0x32], ax
  03D8D3  2553: 0bc0             or ax, ax
  03D8D5  2555: 7c03             jl 0x255a
  03D8D7  2557: e958ff           jmp 0x24b2
  03D8DA  255A: c746e80000       mov word ptr [bp - 0x18], 0
  03D8DF  255F: ff46b0           inc word ptr [bp - 0x50]
  03D8E2  2562: 837ee800         cmp word ptr [bp - 0x18], 0
  03D8E6  2566: 7446             je 0x25ae
  03D8E8  2568: 837eb003         cmp word ptr [bp - 0x50], 3
  03D8EC  256C: 7f40             jg 0x25ae
  03D8EE  256E: 837eb002         cmp word ptr [bp - 0x50], 2
  03D8F2  2572: 74eb             je 0x255f
  03D8F4  2574: 8b76b0           mov si, word ptr [bp - 0x50]
  03D8F7  2577: d1e6             shl si, 1
  03D8F9  2579: 8b42b2           mov ax, word ptr [bp + si - 0x4e]
  03D8FC  257C: 3b84e253         cmp ax, word ptr [si + 0x53e2]
  03D900  2580: 7e04             jle 0x2586
  03D902  2582: 8b84e253         mov ax, word ptr [si + 0x53e2]
  03D906  2586: 8946fa           mov word ptr [bp - 6], ax
  03D909  2589: ff76aa           push word ptr [bp - 0x56]
  03D90C  258C: ff76b0           push word ptr [bp - 0x50]
  03D90F  258F: 0e               push cs
  03D910  2590: e8fd10           call 0x3690
  03D913  2593: 83c404           add sp, 4
  03D916  2596: 8946f8           mov word ptr [bp - 8], ax
  03D919  2599: 837e0600         cmp word ptr [bp + 6], 0
  03D91D  259D: 7407             je 0x25a6
  03D91F  259F: 8b84469e         mov ax, word ptr [si - 0x61ba]
  03D923  25A3: 8946fa           mov word ptr [bp - 6], ax
  03D926  25A6: c746dc0000       mov word ptr [bp - 0x24], 0
  03D92B  25AB: eb89             jmp 0x2536
  03D92D  25AD: 90               nop 
  03D92E  25AE: 837e0600         cmp word ptr [bp + 6], 0
  03D932  25B2: 7411             je 0x25c5
  03D934  25B4: 837ee600         cmp word ptr [bp - 0x1a], 0
  03D938  25B8: 7c0b             jl 0x25c5
  03D93A  25BA: ff76e6           push word ptr [bp - 0x1a]
  03D93D  25BD: 9a08081f18       lcall 0x181f, 0x808
  03D942  25C2: 83c402           add sp, 2
  03D945  25C5: 5e               pop si
  03D946  25C6: c9               leave 
  03D947  25C7: cb               retf 

; ---- func_03D948  size=225  insns=73  prologue=ENTER 0x0006,0  terminal=RETF ----
  03D948  25C8: c8060000         enter 6, 0
  03D94C  25CC: c746fcffff       mov word ptr [bp - 4], 0xffff
  03D951  25D1: 2bc0             sub ax, ax
  03D953  25D3: 8946fe           mov word ptr [bp - 2], ax
  03D956  25D6: 8946fa           mov word ptr [bp - 6], ax
  03D959  25D9: eb40             jmp 0x261b
  03D95B  25DB: 90               nop 
  03D95C  25DC: ff76fa           push word ptr [bp - 6]
  03D95F  25DF: 9ae6091f18       lcall 0x181f, 0x9e6
  03D964  25E4: 83c402           add sp, 2
  03D967  25E7: a09853           mov al, byte ptr [0x5398]
  03D96A  25EA: 8b1e4285         mov bx, word ptr [0x8542]
  03D96E  25EE: 38471a           cmp byte ptr [bx + 0x1a], al
  03D971  25F1: 7525             jne 0x2618
  03D973  25F3: 695efaca00       imul bx, word ptr [bp - 6], 0xca
  03D978  25F8: f687625d40       test byte ptr [bx + 0x5d62], 0x40
  03D97D  25FD: 7419             je 0x2618
  03D97F  25FF: 8a46fc           mov al, byte ptr [bp - 4]
  03D982  2602: 8b1e4285         mov bx, word ptr [0x8542]
  03D986  2606: 38471f           cmp byte ptr [bx + 0x1f], al
  03D989  2609: 7e0d             jle 0x2618
  03D98B  260B: 8a471f           mov al, byte ptr [bx + 0x1f]
  03D98E  260E: 98               cwde 
  03D98F  260F: 8946fc           mov word ptr [bp - 4], ax
  03D992  2612: 8b46fa           mov ax, word ptr [bp - 6]
  03D995  2615: 8946fe           mov word ptr [bp - 2], ax
  03D998  2618: ff46fa           inc word ptr [bp - 6]
  03D99B  261B: a19e53           mov ax, word ptr [0x539e]
  03D99E  261E: 3946fa           cmp word ptr [bp - 6], ax
  03D9A1  2621: 7cb9             jl 0x25dc
  03D9A3  2623: 6a03             push 3
  03D9A5  2625: 9aac041f18       lcall 0x181f, 0x4ac
  03D9AA  262A: 83c402           add sp, 2
  03D9AD  262D: ff36d453         push word ptr [0x53d4]
  03D9B1  2631: 6a01             push 1
  03D9B3  2633: 6a00             push 0
  03D9B5  2635: 9ac80a1f19       lcall 0x191f, 0xac8
  03D9BA  263A: 83c406           add sp, 6
  03D9BD  263D: ff369853         push word ptr [0x5398]
  03D9C1  2641: 6a00             push 0
  03D9C3  2643: 6a01             push 1
  03D9C5  2645: 9ac80a1f19       lcall 0x191f, 0xac8
  03D9CA  264A: 83c406           add sp, 6
  03D9CD  264D: ff36d453         push word ptr [0x53d4]
  03D9D1  2651: 68d412           push 0x12d4
  03D9D4  2654: 687c08           push 0x87c
  03D9D7  2657: 9a22041f18       lcall 0x181f, 0x422
  03D9DC  265C: 83c406           add sp, 6
  03D9DF  265F: 1e               push ds
  03D9E0  2660: 683c83           push 0x833c
  03D9E3  2663: 6a02             push 2
  03D9E5  2665: 9a16041f18       lcall 0x181f, 0x416
  03D9EA  266A: 83c406           add sp, 6
  03D9ED  266D: 6946feca00       imul ax, word ptr [bp - 2], 0xca
  03D9F2  2672: 05485d           add ax, 0x5d48
  03D9F5  2675: 1e               push ds
  03D9F6  2676: 50               push ax
  03D9F7  2677: 6a03             push 3
  03D9F9  2679: 9a16041f18       lcall 0x181f, 0x416
  03D9FE  267E: 83c406           add sp, 6
  03DA01  2681: ff36d453         push word ptr [0x53d4]
  03DA05  2685: 9aa4091f18       lcall 0x181f, 0x9a4
  03DA0A  268A: 83c402           add sp, 2
  03DA0D  268D: 50               push ax
  03DA0E  268E: 6a04             push 4
  03DA10  2690: 9a38041f18       lcall 0x181f, 0x438
  03DA15  2695: 83c404           add sp, 4
  03DA18  2698: 6a01             push 1
  03DA1A  269A: 68db12           push 0x12db
  03DA1D  269D: 9a52061f18       lcall 0x181f, 0x652
  03DA22  26A2: 800e825302       or byte ptr [0x5382], 2
  03DA27  26A7: c9               leave 
  03DA28  26A8: cb               retf 

; ---- func_03DA2A  size=1051  insns=324  prologue=ENTER 0x051E,0  terminal=RETF ----
  03DA2A  26AA: c81e0500         enter 0x51e, 0
  03DA2E  26AE: 56               push si
  03DA2F  26AF: 8d8604fb         lea ax, [bp - 0x4fc]
  03DA33  26B3: 16               push ss
  03DA34  26B4: 50               push ax
  03DA35  26B5: 6a00             push 0
  03DA37  26B7: ff36a483         push word ptr [0x83a4]
  03DA3B  26BB: ff36a283         push word ptr [0x83a2]
  03DA3F  26BF: ff36a083         push word ptr [0x83a0]
  03DA43  26C3: ff369e83         push word ptr [0x839e]
  03DA47  26C7: 68e812           push 0x12e8
  03DA4A  26CA: 9a4e041f18       lcall 0x181f, 0x44e
  03DA4F  26CF: 83c410           add sp, 0x10
  03DA52  26D2: 0bc0             or ax, ax
  03DA54  26D4: 7403             je 0x26d9
  03DA56  26D6: e9e903           jmp 0x2ac2
  03DA59  26D9: 9ab6031f18       lcall 0x181f, 0x3b6
  03DA5E  26DE: c70672030000     mov word ptr [0x372], 0
  03DA64  26E4: 8d8604fb         lea ax, [bp - 0x4fc]
  03DA68  26E8: 16               push ss
  03DA69  26E9: 50               push ax
  03DA6A  26EA: 9af4031f18       lcall 0x181f, 0x3f4
  03DA6F  26EF: ff36a483         push word ptr [0x83a4]
  03DA73  26F3: ff36a283         push word ptr [0x83a2]
  03DA77  26F7: ff36a083         push word ptr [0x83a0]
  03DA7B  26FB: ff369e83         push word ptr [0x839e]
  03DA7F  26FF: ff36ae2d         push word ptr [0x2dae]
  03DA83  2703: ff36ac2d         push word ptr [0x2dac]
  03DA87  2707: ff36aa2d         push word ptr [0x2daa]
  03DA8B  270B: ff36a82d         push word ptr [0x2da8]
  03DA8F  270F: 68c800           push 0xc8
  03DA92  2712: 2bc0             sub ax, ax
  03DA94  2714: 99               cdq 
  03DA95  2715: bb4001           mov bx, 0x140
  03DA98  2718: 9a44041f18       lcall 0x181f, 0x444
  03DA9D  271D: 6a00             push 0
  03DA9F  271F: 684001           push 0x140
  03DAA2  2722: 68c800           push 0xc8
  03DAA5  2725: 2bc0             sub ax, ax
  03DAA7  2727: 99               cdq 
  03DAA8  2728: 2bdb             sub bx, bx
  03DAAA  272A: 9ae2001f18       lcall 0x181f, 0xe2
  03DAAF  272F: 9ade0f1f19       lcall 0x191f, 0xfde
  03DAB4  2734: 6b06985334       imul ax, word ptr [0x5398], 0x34
  03DAB9  2739: 050e54           add ax, 0x540e
  03DABC  273C: 50               push ax
  03DABD  273D: 8d46ac           lea ax, [bp - 0x54]
  03DAC0  2740: 50               push ax
  03DAC1  2741: 9ae4071d0d       lcall 0xd1d, 0x7e4
  03DAC6  2746: 83c404           add sp, 4
  03DAC9  2749: 8d46ac           lea ax, [bp - 0x54]
  03DACC  274C: 50               push ax
  03DACD  274D: 9a460d1d0d       lcall 0xd1d, 0xd46
  03DAD2  2752: 83c402           add sp, 2
  03DAD5  2755: 6a1a             push 0x1a
  03DAD7  2757: 6a00             push 0
  03DAD9  2759: 8d86e8fa         lea ax, [bp - 0x518]
  03DADD  275D: 50               push ax
  03DADE  275E: 9aae0d1d0d       lcall 0xd1d, 0xdae
  03DAE3  2763: 83c406           add sp, 6
  03DAE6  2766: 6a1a             push 0x1a
  03DAE8  2768: 6a00             push 0
  03DAEA  276A: 8d86ccfe         lea ax, [bp - 0x134]
  03DAEE  276E: 50               push ax
  03DAEF  276F: 9aae0d1d0d       lcall 0xd1d, 0xdae
  03DAF4  2774: 83c406           add sp, 6
  03DAF7  2777: c786e4fa0100     mov word ptr [bp - 0x51c], 1
  03DAFD  277D: 8d46ac           lea ax, [bp - 0x54]
  03DB00  2780: 8986cafe         mov word ptr [bp - 0x136], ax
  03DB04  2784: eb0a             jmp 0x2790
  03DB06  2786: c786e4fa0100     mov word ptr [bp - 0x51c], 1
  03DB0C  278C: ff86cafe         inc word ptr [bp - 0x136]
  03DB10  2790: 8b9ecafe         mov bx, word ptr [bp - 0x136]
  03DB14  2794: 803f00           cmp byte ptr [bx], 0
  03DB17  2797: 7425             je 0x27be
  03DB19  2799: 8a07             mov al, byte ptr [bx]
  03DB1B  279B: 98               cwde 
  03DB1C  279C: 8bf0             mov si, ax
  03DB1E  279E: f684ed2703       test byte ptr [si + 0x27ed], 3
  03DB23  27A3: 74e1             je 0x2786
  03DB25  27A5: 83bee4fa00       cmp word ptr [bp - 0x51c], 0
  03DB2A  27AA: 740a             je 0x27b6
  03DB2C  27AC: f684ed2702       test byte ptr [si + 0x27ed], 2
  03DB31  27B1: 7403             je 0x27b6
  03DB33  27B3: 802f20           sub byte ptr [bx], 0x20
  03DB36  27B6: c786e4fa0000     mov word ptr [bp - 0x51c], 0
  03DB3C  27BC: ebce             jmp 0x278c
  03DB3E  27BE: 8d46ac           lea ax, [bp - 0x54]
  03DB41  27C1: 8986cafe         mov word ptr [bp - 0x136], ax
  03DB45  27C5: eb18             jmp 0x27df
  03DB47  27C7: 90               nop 
  03DB48  27C8: 8b9ecafe         mov bx, word ptr [bp - 0x136]
  03DB4C  27CC: 8a07             mov al, byte ptr [bx]
  03DB4E  27CE: 2c61             sub al, 0x61
  03DB50  27D0: 8846fe           mov byte ptr [bp - 2], al
  03DB53  27D3: 98               cwde 
  03DB54  27D4: 8bf0             mov si, ax
  03DB56  27D6: c682ccfe01       mov byte ptr [bp + si - 0x134], 1
  03DB5B  27DB: ff86cafe         inc word ptr [bp - 0x136]
  03DB5F  27DF: 8b9ecafe         mov bx, word ptr [bp - 0x136]
  03DB63  27E3: 803f00           cmp byte ptr [bx], 0
  03DB66  27E6: 7426             je 0x280e
  03DB68  27E8: 8a07             mov al, byte ptr [bx]
  03DB6A  27EA: 8bc8             mov cx, ax
  03DB6C  27EC: 98               cwde 
  03DB6D  27ED: 8bd8             mov bx, ax
  03DB6F  27EF: f687ed2703       test byte ptr [bx + 0x27ed], 3
  03DB74  27F4: 74e5             je 0x27db
  03DB76  27F6: f687ed2701       test byte ptr [bx + 0x27ed], 1
  03DB7B  27FB: 74cb             je 0x27c8
  03DB7D  27FD: 8ac1             mov al, cl
  03DB7F  27FF: 2c41             sub al, 0x41
  03DB81  2801: 8846fe           mov byte ptr [bp - 2], al
  03DB84  2804: 98               cwde 
  03DB85  2805: 8bf0             mov si, ax
  03DB87  2807: c682e8fa01       mov byte ptr [bp + si - 0x518], 1
  03DB8C  280C: ebcd             jmp 0x27db
  03DB8E  280E: 68f012           push 0x12f0
  03DB91  2811: 8d8654ff         lea ax, [bp - 0xac]
  03DB95  2815: 50               push ax
  03DB96  2816: 9ae4071d0d       lcall 0xd1d, 0x7e4
  03DB9B  281B: 83c404           add sp, 4
  03DB9E  281E: 68f912           push 0x12f9
  03DBA1  2821: 8d860afe         lea ax, [bp - 0x1f6]
  03DBA5  2825: 50               push ax
  03DBA6  2826: 9ae4071d0d       lcall 0xd1d, 0x7e4
  03DBAB  282B: 83c404           add sp, 4
  03DBAE  282E: c786e6fe0000     mov word ptr [bp - 0x11a], 0
  03DBB4  2834: 8a86e6fe         mov al, byte ptr [bp - 0x11a]
  03DBB8  2838: 8bc8             mov cx, ax
  03DBBA  283A: 0441             add al, 0x41
  03DBBC  283C: 88865bff         mov byte ptr [bp - 0xa5], al
  03DBC0  2840: 80c161           add cl, 0x61
  03DBC3  2843: 888e11fe         mov byte ptr [bp - 0x1ef], cl
  03DBC7  2847: 8bb6e6fe         mov si, word ptr [bp - 0x11a]
  03DBCB  284B: 80bae8fa00       cmp byte ptr [bp + si - 0x518], 0
  03DBD0  2850: 741d             je 0x286f
  03DBD2  2852: 8d9e54ff         lea bx, [bp - 0xac]
  03DBD6  2856: 2bc0             sub ax, ax
  03DBD8  2858: 9ad00f1f19       lcall 0x191f, 0xfd0
  03DBDD  285D: c1e602           shl si, 2
  03DBE0  2860: 89825afe         mov word ptr [bp + si - 0x1a6], ax
  03DBE4  2864: 89925cfe         mov word ptr [bp + si - 0x1a4], dx
  03DBE8  2868: 0bd0             or dx, ax
  03DBEA  286A: 7503             jne 0x286f
  03DBEC  286C: e92302           jmp 0x2a92
  03DBEF  286F: 8bb6e6fe         mov si, word ptr [bp - 0x11a]
  03DBF3  2873: 80baccfe00       cmp byte ptr [bp + si - 0x134], 0
  03DBF8  2878: 741d             je 0x2897
  03DBFA  287A: 8d9e0afe         lea bx, [bp - 0x1f6]
  03DBFE  287E: 2bc0             sub ax, ax
  03DC00  2880: 9ad00f1f19       lcall 0x191f, 0xfd0
  03DC05  2885: c1e602           shl si, 2
  03DC08  2888: 8982e8fe         mov word ptr [bp + si - 0x118], ax
  03DC0C  288C: 8992eafe         mov word ptr [bp + si - 0x116], dx
  03DC10  2890: 0bd0             or dx, ax
  03DC12  2892: 7503             jne 0x2897
  03DC14  2894: e9fb01           jmp 0x2a92
  03DC17  2897: ff86e6fe         inc word ptr [bp - 0x11a]
  03DC1B  289B: 83bee6fe1a       cmp word ptr [bp - 0x11a], 0x1a
  03DC20  28A0: 7c92             jl 0x2834
  03DC22  28A2: 8d1e0213         lea bx, [0x1302]
  03DC26  28A6: 2bc0             sub ax, ax
  03DC28  28A8: 9ad00f1f19       lcall 0x191f, 0xfd0
  03DC2D  28AD: 8986c2fe         mov word ptr [bp - 0x13e], ax
  03DC31  28B1: 8996c4fe         mov word ptr [bp - 0x13c], dx
  03DC35  28B5: 0bd0             or dx, ax
  03DC37  28B7: 7503             jne 0x28bc
  03DC39  28B9: e90602           jmp 0x2ac2
  03DC3C  28BC: c78604fe7e00     mov word ptr [bp - 0x1fc], 0x7e
  03DC42  28C2: c78602fb9400     mov word ptr [bp - 0x4fe], 0x94
  03DC48  28C8: c746aa0000       mov word ptr [bp - 0x56], 0
  03DC4D  28CD: 8d46ac           lea ax, [bp - 0x54]
  03DC50  28D0: 8986cafe         mov word ptr [bp - 0x136], ax
  03DC54  28D4: e99101           jmp 0x2a68
  03DC57  28D7: 90               nop 
  03DC58  28D8: 8a07             mov al, byte ptr [bx]
  03DC5A  28DA: 98               cwde 
  03DC5B  28DB: 8bd8             mov bx, ax
  03DC5D  28DD: f687ed2708       test byte ptr [bx + 0x27ed], 8
  03DC62  28E2: 7507             jne 0x28eb
  03DC64  28E4: f687ed2710       test byte ptr [bx + 0x27ed], 0x10
  03DC69  28E9: 740d             je 0x28f8
  03DC6B  28EB: c746fc0300       mov word ptr [bp - 4], 3
  03DC70  28F0: c746a8ffff       mov word ptr [bp - 0x58], 0xffff
  03DC75  28F5: e98500           jmp 0x297d
  03DC78  28F8: 8b9ecafe         mov bx, word ptr [bp - 0x136]
  03DC7C  28FC: 8a07             mov al, byte ptr [bx]
  03DC7E  28FE: 98               cwde 
  03DC7F  28FF: 8bd8             mov bx, ax
  03DC81  2901: f687ed2703       test byte ptr [bx + 0x27ed], 3
  03DC86  2906: 7520             jne 0x2928
  03DC88  2908: 8b86c2fe         mov ax, word ptr [bp - 0x13e]
  03DC8C  290C: 8b96c4fe         mov dx, word ptr [bp - 0x13c]
  03DC90  2910: 8946a4           mov word ptr [bp - 0x5c], ax
  03DC93  2913: 8956a6           mov word ptr [bp - 0x5a], dx
  03DC96  2916: c786e2fa0a00     mov word ptr [bp - 0x51e], 0xa
  03DC9C  291C: c746aa0100       mov word ptr [bp - 0x56], 1
  03DCA1  2921: c746a8fcff       mov word ptr [bp - 0x58], 0xfffc
  03DCA6  2926: eb55             jmp 0x297d
  03DCA8  2928: 8b9ecafe         mov bx, word ptr [bp - 0x136]
  03DCAC  292C: 8a07             mov al, byte ptr [bx]
  03DCAE  292E: 98               cwde 
  03DCAF  292F: 8bd8             mov bx, ax
  03DCB1  2931: f687ed2701       test byte ptr [bx + 0x27ed], 1
  03DCB6  2936: 7420             je 0x2958
  03DCB8  2938: 8bf0             mov si, ax
  03DCBA  293A: c1e602           shl si, 2
  03DCBD  293D: 8b8256fd         mov ax, word ptr [bp + si - 0x2aa]
  03DCC1  2941: 8b9258fd         mov dx, word ptr [bp + si - 0x2a8]
  03DCC5  2945: 8946a4           mov word ptr [bp - 0x5c], ax
  03DCC8  2948: 8956a6           mov word ptr [bp - 0x5a], dx
  03DCCB  294B: c786e2fa0a00     mov word ptr [bp - 0x51e], 0xa
  03DCD1  2951: c746a8fdff       mov word ptr [bp - 0x58], 0xfffd
  03DCD6  2956: eb25             jmp 0x297d
  03DCD8  2958: 8b9ecafe         mov bx, word ptr [bp - 0x136]
  03DCDC  295C: 8a07             mov al, byte ptr [bx]
  03DCDE  295E: 98               cwde 
  03DCDF  295F: 8bf0             mov si, ax
  03DCE1  2961: c1e602           shl si, 2
  03DCE4  2964: 8b8264fd         mov ax, word ptr [bp + si - 0x29c]
  03DCE8  2968: 8b9266fd         mov dx, word ptr [bp + si - 0x29a]
  03DCEC  296C: 8946a4           mov word ptr [bp - 0x5c], ax
  03DCEF  296F: 8956a6           mov word ptr [bp - 0x5a], dx
  03DCF2  2972: c786e2fa0700     mov word ptr [bp - 0x51e], 7
  03DCF8  2978: c746a8feff       mov word ptr [bp - 0x58], 0xfffe
  03DCFD  297D: c786e6fa0000     mov word ptr [bp - 0x51a], 0
  03DD03  2983: 8b46a6           mov ax, word ptr [bp - 0x5a]
  03DD06  2986: 0b46a4           or ax, word ptr [bp - 0x5c]
  03DD09  2989: 7503             jne 0x298e
  03DD0B  298B: e9c800           jmp 0x2a56
  03DD0E  298E: 9a7a041f18       lcall 0x181f, 0x47a
  03DD13  2993: c45ea4           les bx, ptr [bp - 0x5c]
  03DD16  2996: 268b474a         mov ax, word ptr es:[bx + 0x4a]
  03DD1A  299A: 8946fc           mov word ptr [bp - 4], ax
  03DD1D  299D: c786e6fe0000     mov word ptr [bp - 0x11a], 0
  03DD23  29A3: e9a300           jmp 0x2a49
  03DD26  29A6: ff76a6           push word ptr [bp - 0x5a]
  03DD29  29A9: ff76a4           push word ptr [bp - 0x5c]
  03DD2C  29AC: ffb602fb         push word ptr [bp - 0x4fe]
  03DD30  29B0: 40               inc ax
  03DD31  29B1: 40               inc ax
  03DD32  29B2: 8d1ea82d         lea bx, [0x2da8]
  03DD36  29B6: 8b9604fe         mov dx, word ptr [bp - 0x1fc]
  03DD3A  29BA: 9a54021f18       lcall 0x181f, 0x254
  03DD3F  29BF: 6a00             push 0
  03DD41  29C1: 684001           push 0x140
  03DD44  29C4: 68c800           push 0xc8
  03DD47  29C7: 2bc0             sub ax, ax
  03DD49  29C9: 99               cdq 
  03DD4A  29CA: 2bdb             sub bx, bx
  03DD4C  29CC: 9ae2001f18       lcall 0x181f, 0xe2
  03DD51  29D1: 2bc0             sub ax, ax
  03DD53  29D3: a33a83           mov word ptr [0x833a], ax
  03DD56  29D6: a33883           mov word ptr [0x8338], ax
  03DD59  29D9: 9a22000c0c       lcall 0xc0c, 0x22
  03DD5E  29DE: 8986c6fe         mov word ptr [bp - 0x13a], ax
  03DD62  29E2: 8996c8fe         mov word ptr [bp - 0x138], dx
  03DD66  29E6: 2bc0             sub ax, ax
  03DD68  29E8: 9a66041f18       lcall 0x181f, 0x466
  03DD6D  29ED: 833ef40700       cmp word ptr [0x7f4], 0
  03DD72  29F2: 7406             je 0x29fa
  03DD74  29F4: c786e6fa0100     mov word ptr [bp - 0x51a], 1
  03DD7A  29FA: 9af6001f18       lcall 0x181f, 0xf6
  03DD7F  29FF: 0bc0             or ax, ax
  03DD81  2A01: 740b             je 0x2a0e
  03DD83  2A03: 9ae0031f18       lcall 0x181f, 0x3e0
  03DD88  2A08: c786e6fa0100     mov word ptr [bp - 0x51a], 1
  03DD8E  2A0E: 83bee6fa01       cmp word ptr [bp - 0x51a], 1
  03DD93  2A13: 1bd2             sbb dx, dx
  03DD95  2A15: f7da             neg dx
  03DD97  2A17: 2bc0             sub ax, ax
  03DD99  2A19: 9a5c041f18       lcall 0x181f, 0x45c
  03DD9E  2A1E: 9a22000c0c       lcall 0xc0c, 0x22
  03DDA3  2A23: 898606fe         mov word ptr [bp - 0x1fa], ax
  03DDA7  2A27: 899608fe         mov word ptr [bp - 0x1f8], dx
  03DDAB  2A2B: 2b86c6fe         sub ax, word ptr [bp - 0x13a]
  03DDAF  2A2F: 1b96c8fe         sbb dx, word ptr [bp - 0x138]
  03DDB3  2A33: 0bd2             or dx, dx
  03DDB5  2A35: 7f0e             jg 0x2a45
  03DDB7  2A37: 7c05             jl 0x2a3e
  03DDB9  2A39: 3d0500           cmp ax, 5
  03DDBC  2A3C: 7307             jae 0x2a45
  03DDBE  2A3E: 83bee6fa00       cmp word ptr [bp - 0x51a], 0
  03DDC3  2A43: 74a1             je 0x29e6
  03DDC5  2A45: ff86e6fe         inc word ptr [bp - 0x11a]
  03DDC9  2A49: 8b86e6fe         mov ax, word ptr [bp - 0x11a]
  03DDCD  2A4D: 3986e2fa         cmp word ptr [bp - 0x51e], ax
  03DDD1  2A51: 7e03             jle 0x2a56
  03DDD3  2A53: e950ff           jmp 0x29a6
  03DDD6  2A56: 8b46fc           mov ax, word ptr [bp - 4]
  03DDD9  2A59: 018604fe         add word ptr [bp - 0x1fc], ax
  03DDDD  2A5D: 8b46a8           mov ax, word ptr [bp - 0x58]
  03DDE0  2A60: 018602fb         add word ptr [bp - 0x4fe], ax
  03DDE4  2A64: ff86cafe         inc word ptr [bp - 0x136]
  03DDE8  2A68: 837eaa00         cmp word ptr [bp - 0x56], 0
  03DDEC  2A6C: 7524             jne 0x2a92
  03DDEE  2A6E: 8b9ecafe         mov bx, word ptr [bp - 0x136]
  03DDF2  2A72: 803f00           cmp byte ptr [bx], 0
  03DDF5  2A75: 741b             je 0x2a92
  03DDF7  2A77: c746fc0000       mov word ptr [bp - 4], 0
  03DDFC  2A7C: 2bc0             sub ax, ax
  03DDFE  2A7E: 8946a6           mov word ptr [bp - 0x5a], ax
  03DE01  2A81: 8946a4           mov word ptr [bp - 0x5c], ax
  03DE04  2A84: 81be04fedc00     cmp word ptr [bp - 0x1fc], 0xdc
  03DE0A  2A8A: 7d03             jge 0x2a8f
  03DE0C  2A8C: e949fe           jmp 0x28d8
  03DE0F  2A8F: e976fe           jmp 0x2908
  03DE12  2A92: 9aac0a1f19       lcall 0x191f, 0xaac
  03DE17  2A97: 9ac0031f18       lcall 0x181f, 0x3c0
  03DE1C  2A9C: 9ab6031f18       lcall 0x181f, 0x3b6
  03DE21  2AA1: 6800a0           push 0xa000
  03DE24  2AA4: 6800fc           push 0xfc00
  03DE27  2AA7: 9af4031f18       lcall 0x181f, 0x3f4
  03DE2C  2AAC: 8a268353         mov ah, byte ptr [0x5383]
  03DE30  2AB0: 250001           and ax, 0x100
  03DE33  2AB3: 3d0100           cmp ax, 1
  03DE36  2AB6: 1bc0             sbb ax, ax
  03DE38  2AB8: f7d8             neg ax
  03DE3A  2ABA: a37203           mov word ptr [0x372], ax
  03DE3D  2ABD: 9a6a051f18       lcall 0x181f, 0x56a
  03DE42  2AC2: 5e               pop si
  03DE43  2AC3: c9               leave 
  03DE44  2AC4: cb               retf 

; ---- func_03DE46  size=795  insns=286  prologue=ENTER 0x0324,0  terminal=RETF ----
  03DE46  2AC6: c8240300         enter 0x324, 0
  03DE4A  2ACA: 57               push di
  03DE4B  2ACB: 56               push si
  03DE4C  2ACC: a19853           mov ax, word ptr [0x5398]
  03DE4F  2ACF: 8986dcfc         mov word ptr [bp - 0x324], ax
  03DE53  2AD3: 50               push ax
  03DE54  2AD4: 9a82051f18       lcall 0x181f, 0x582
  03DE59  2AD9: 83c402           add sp, 2
  03DE5C  2ADC: a18a53           mov ax, word ptr [0x538a]
  03DE5F  2ADF: b96400           mov cx, 0x64
  03DE62  2AE2: 99               cdq 
  03DE63  2AE3: f7f9             idiv cx
  03DE65  2AE5: 8816a853         mov byte ptr [0x53a8], dl
  03DE69  2AE9: a18a53           mov ax, word ptr [0x538a]
  03DE6C  2AEC: 99               cdq 
  03DE6D  2AED: f7f9             idiv cx
  03DE6F  2AEF: a2a753           mov byte ptr [0x53a7], al
  03DE72  2AF2: 2bc0             sub ax, ax
  03DE74  2AF4: 8946f8           mov word ptr [bp - 8], ax
  03DE77  2AF7: 8b1efc84         mov bx, word ptr [0x84fc]
  03DE7B  2AFB: 89470c           mov word ptr [bx + 0xc], ax
  03DE7E  2AFE: 3906d253         cmp word ptr [0x53d2], ax
  03DE82  2B02: 7d04             jge 0x2b08
  03DE84  2B04: 0e               push cs
  03DE85  2B05: e8830b           call 0x368b
  03DE88  2B08: 6a03             push 3
  03DE8A  2B0A: 9aac041f18       lcall 0x181f, 0x4ac
  03DE8F  2B0F: 83c402           add sp, 2
  03DE92  2B12: 0e               push cs
  03DE93  2B13: e8890b           call 0x369f
  03DE96  2B16: c746f20000       mov word ptr [bp - 0xe], 0
  03DE9B  2B1B: 8a46f2           mov al, byte ptr [bp - 0xe]
  03DE9E  2B1E: 8b76f2           mov si, word ptr [bp - 0xe]
  03DEA1  2B21: 8842ee           mov byte ptr [bp + si - 0x12], al
  03DEA4  2B24: 8a841894         mov al, byte ptr [si - 0x6be8]
  03DEA8  2B28: 2ae4             sub ah, ah
  03DEAA  2B2A: 8bc8             mov cx, ax
  03DEAC  2B2C: d1e0             shl ax, 1
  03DEAE  2B2E: 03c1             add ax, cx
  03DEB0  2B30: 8a8c9892         mov cl, byte ptr [si - 0x6d68]
  03DEB4  2B34: 2aed             sub ch, ch
  03DEB6  2B36: d1e1             shl cx, 1
  03DEB8  2B38: 03c1             add ax, cx
  03DEBA  2B3A: 8a8c1094         mov cl, byte ptr [si - 0x6bf0]
  03DEBE  2B3E: 2aed             sub ch, ch
  03DEC0  2B40: 03c1             add ax, cx
  03DEC2  2B42: d1e6             shl si, 1
  03DEC4  2B44: 8942e6           mov word ptr [bp + si - 0x1a], ax
  03DEC7  2B47: ff46f2           inc word ptr [bp - 0xe]
  03DECA  2B4A: 837ef204         cmp word ptr [bp - 0xe], 4
  03DECE  2B4E: 7ccb             jl 0x2b1b
  03DED0  2B50: 8d46ee           lea ax, [bp - 0x12]
  03DED3  2B53: 16               push ss
  03DED4  2B54: 50               push ax
  03DED5  2B55: 8d46e6           lea ax, [bp - 0x1a]
  03DED8  2B58: 16               push ss
  03DED9  2B59: 50               push ax
  03DEDA  2B5A: b80400           mov ax, 4
  03DEDD  2B5D: 9ad00e1f19       lcall 0x191f, 0xed0
  03DEE2  2B62: c706d653ffff     mov word ptr [0x53d6], 0xffff
  03DEE8  2B68: c746f20000       mov word ptr [bp - 0xe], 0
  03DEED  2B6D: eb0c             jmp 0x2b7b
  03DEEF  2B6F: 90               nop 
  03DEF0  2B70: 8a42ee           mov al, byte ptr [bp + si - 0x12]
  03DEF3  2B73: 2ae4             sub ah, ah
  03DEF5  2B75: a3d653           mov word ptr [0x53d6], ax
  03DEF8  2B78: ff46f2           inc word ptr [bp - 0xe]
  03DEFB  2B7B: 833ed65300       cmp word ptr [0x53d6], 0
  03DF00  2B80: 7d2a             jge 0x2bac
  03DF02  2B82: 837ef204         cmp word ptr [bp - 0xe], 4
  03DF06  2B86: 7d24             jge 0x2bac
  03DF08  2B88: a09853           mov al, byte ptr [0x5398]
  03DF0B  2B8B: 8b76f2           mov si, word ptr [bp - 0xe]
  03DF0E  2B8E: 3842ee           cmp byte ptr [bp + si - 0x12], al
  03DF11  2B91: 74e5             je 0x2b78
  03DF13  2B93: a0d253           mov al, byte ptr [0x53d2]
  03DF16  2B96: 3842ee           cmp byte ptr [bp + si - 0x12], al
  03DF19  2B99: 74dd             je 0x2b78
  03DF1B  2B9B: 833ed45300       cmp word ptr [0x53d4], 0
  03DF20  2BA0: 7dce             jge 0x2b70
  03DF22  2BA2: 8a42ee           mov al, byte ptr [bp + si - 0x12]
  03DF25  2BA5: 2ae4             sub ah, ah
  03DF27  2BA7: a3d453           mov word ptr [0x53d4], ax
  03DF2A  2BAA: ebcc             jmp 0x2b78
  03DF2C  2BAC: 6b1ed45313       imul bx, word ptr [0x53d4], 0x13
  03DF31  2BB1: 8a875c92         mov al, byte ptr [bx - 0x6da4]
  03DF35  2BB5: 2ae4             sub ah, ah
  03DF37  2BB7: 8a8f5d92         mov cl, byte ptr [bx - 0x6da3]
  03DF3B  2BBB: 2aed             sub ch, ch
  03DF3D  2BBD: 03c1             add ax, cx
  03DF3F  2BBF: 8946fe           mov word ptr [bp - 2], ax
  03DF42  2BC2: 8a0ea653         mov cl, byte ptr [0x53a6]
  03DF46  2BC6: b30a             mov bl, 0xa
  03DF48  2BC8: 8b36d453         mov si, word ptr [0x53d4]
  03DF4C  2BCC: 8bd0             mov dx, ax
  03DF4E  2BCE: 8a841094         mov al, byte ptr [si - 0x6bf0]
  03DF52  2BD2: 2ae4             sub ah, ah
  03DF54  2BD4: f6f3             div bl
  03DF56  2BD6: 2ae4             sub ah, ah
  03DF58  2BD8: 2bc1             sub ax, cx
  03DF5A  2BDA: 050800           add ax, 8
  03DF5D  2BDD: a3e253           mov word ptr [0x53e2], ax
  03DF60  2BE0: 83e904           sub cx, 4
  03DF63  2BE3: f7d9             neg cx
  03DF65  2BE5: d1f9             sar cx, 1
  03DF67  2BE7: 8a9c2c94         mov bl, byte ptr [si - 0x6bd4]
  03DF6B  2BEB: 2aff             sub bh, bh
  03DF6D  2BED: 43               inc bx
  03DF6E  2BEE: c1fb04           sar bx, 4
  03DF71  2BF1: 03d9             add bx, cx
  03DF73  2BF3: 43               inc bx
  03DF74  2BF4: 891ee453         mov word ptr [0x53e4], bx
  03DF78  2BF8: d1e6             shl si, 1
  03DF7A  2BFA: 8bbc1c94         mov di, word ptr [si - 0x6be4]
  03DF7E  2BFE: 47               inc di
  03DF7F  2BFF: c1ef05           shr di, 5
  03DF82  2C02: 8bf1             mov si, cx
  03DF84  2C04: 03cf             add cx, di
  03DF86  2C06: 83c103           add cx, 3
  03DF89  2C09: 890ee853         mov word ptr [0x53e8], cx
  03DF8D  2C0D: 03f2             add si, dx
  03DF8F  2C0F: 83c603           add si, 3
  03DF92  2C12: 8936e653         mov word ptr [0x53e6], si
  03DF96  2C16: 40               inc ax
  03DF97  2C17: 99               cdq 
  03DF98  2C18: 2bc2             sub ax, dx
  03DF9A  2C1A: d1f8             sar ax, 1
  03DF9C  2C1C: a3e253           mov word ptr [0x53e2], ax
  03DF9F  2C1F: 8bd0             mov dx, ax
  03DFA1  2C21: 8d4701           lea ax, [bx + 1]
  03DFA4  2C24: 8bda             mov bx, dx
  03DFA6  2C26: 99               cdq 
  03DFA7  2C27: 2bc2             sub ax, dx
  03DFA9  2C29: d1f8             sar ax, 1
  03DFAB  2C2B: a3e453           mov word ptr [0x53e4], ax
  03DFAE  2C2E: 8bd0             mov dx, ax
  03DFB0  2C30: 8bc1             mov ax, cx
  03DFB2  2C32: 40               inc ax
  03DFB3  2C33: 8bca             mov cx, dx
  03DFB5  2C35: 99               cdq 
  03DFB6  2C36: 2bc2             sub ax, dx
  03DFB8  2C38: d1f8             sar ax, 1
  03DFBA  2C3A: a3e853           mov word ptr [0x53e8], ax
  03DFBD  2C3D: 8bd0             mov dx, ax
  03DFBF  2C3F: 8d4401           lea ax, [si + 1]
  03DFC2  2C42: 8bf2             mov si, dx
  03DFC4  2C44: 99               cdq 
  03DFC5  2C45: 2bc2             sub ax, dx
  03DFC7  2C47: d1f8             sar ax, 1
  03DFC9  2C49: a3e653           mov word ptr [0x53e6], ax
  03DFCC  2C4C: 8bd0             mov dx, ax
  03DFCE  2C4E: d1e0             shl ax, 1
  03DFD0  2C50: 8bf8             mov di, ax
  03DFD2  2C52: 3bc6             cmp ax, si
  03DFD4  2C54: 7e02             jle 0x2c58
  03DFD6  2C56: 8bc6             mov ax, si
  03DFD8  2C58: a3e853           mov word ptr [0x53e8], ax
  03DFDB  2C5B: 3bf9             cmp di, cx
  03DFDD  2C5D: 7e02             jle 0x2c61
  03DFDF  2C5F: 8bf9             mov di, cx
  03DFE1  2C61: 893ee453         mov word ptr [0x53e4], di
  03DFE5  2C65: 8bc2             mov ax, dx
  03DFE7  2C67: d1e2             shl dx, 1
  03DFE9  2C69: 03d0             add dx, ax
  03DFEB  2C6B: d1e2             shl dx, 1
  03DFED  2C6D: 2b16e853         sub dx, word ptr [0x53e8]
  03DFF1  2C71: 2bd7             sub dx, di
  03DFF3  2C73: 3bd3             cmp dx, bx
  03DFF5  2C75: 7e02             jle 0x2c79
  03DFF7  2C77: 8bd3             mov dx, bx
  03DFF9  2C79: 8916e253         mov word ptr [0x53e2], dx
  03DFFD  2C7D: c746f20000       mov word ptr [bp - 0xe], 0
  03E002  2C82: 8b46f2           mov ax, word ptr [bp - 0xe]
  03E005  2C85: 39069853         cmp word ptr [0x5398], ax
  03E009  2C89: 740e             je 0x2c99
  03E00B  2C8B: 3906d253         cmp word ptr [0x53d2], ax
  03E00F  2C8F: 7408             je 0x2c99
  03E011  2C91: 50               push ax
  03E012  2C92: 0e               push cs
  03E013  2C93: e8040a           call 0x369a
  03E016  2C96: 83c402           add sp, 2
  03E019  2C99: ff46f2           inc word ptr [bp - 0xe]
  03E01C  2C9C: 837ef204         cmp word ptr [bp - 0xe], 4
  03E020  2CA0: 7ce0             jl 0x2c82
  03E022  2CA2: ff369853         push word ptr [0x5398]
  03E026  2CA6: 0e               push cs
  03E027  2CA7: e8ff09           call 0x36a9
  03E02A  2CAA: 83c402           add sp, 2
  03E02D  2CAD: 0e               push cs
  03E02E  2CAE: e8020a           call 0x36b3
  03E031  2CB1: 800e825301       or byte ptr [0x5382], 1
  03E036  2CB6: 6a00             push 0
  03E038  2CB8: 6a00             push 0
  03E03A  2CBA: 9a36071f18       lcall 0x181f, 0x736
  03E03F  2CBF: 83c404           add sp, 4
  03E042  2CC2: 8986defc         mov word ptr [bp - 0x322], ax
  03E046  2CC6: 8996e0fc         mov word ptr [bp - 0x320], dx
  03E04A  2CCA: 8a0e9853         mov cl, byte ptr [0x5398]
  03E04E  2CCE: b81000           mov ax, 0x10
  03E051  2CD1: d3e0             shl ax, cl
  03E053  2CD3: 8986e2fc         mov word ptr [bp - 0x31e], ax
  03E057  2CD7: 8a0ed253         mov cl, byte ptr [0x53d2]
  03E05B  2CDB: b81000           mov ax, 0x10
  03E05E  2CDE: d3e0             shl ax, cl
  03E060  2CE0: 8946fa           mov word ptr [bp - 6], ax
  03E063  2CE3: a1d253           mov ax, word ptr [0x53d2]
  03E066  2CE6: f7d0             not ax
  03E068  2CE8: 8946fc           mov word ptr [bp - 4], ax
  03E06B  2CEB: c746f40000       mov word ptr [bp - 0xc], 0
  03E070  2CF0: eb33             jmp 0x2d25
  03E072  2CF2: ff46f6           inc word ptr [bp - 0xa]
  03E075  2CF5: 8b46f6           mov ax, word ptr [bp - 0xa]
  03E078  2CF8: 39063a85         cmp word ptr [0x853a], ax
  03E07C  2CFC: 7e24             jle 0x2d22
  03E07E  2CFE: 8a46fc           mov al, byte ptr [bp - 4]
  03E081  2D01: c49edefc         les bx, ptr [bp - 0x322]
  03E085  2D05: 262007           and byte ptr es:[bx], al
  03E088  2D08: 268a07           mov al, byte ptr es:[bx]
  03E08B  2D0B: 8bc8             mov cx, ax
  03E08D  2D0D: 2ae4             sub ah, ah
  03E08F  2D0F: 8586e2fc         test word ptr [bp - 0x31e], ax
  03E093  2D13: 7406             je 0x2d1b
  03E095  2D15: 0a4efa           or cl, byte ptr [bp - 6]
  03E098  2D18: 26880f           mov byte ptr es:[bx], cl
  03E09B  2D1B: ff86defc         inc word ptr [bp - 0x322]
  03E09F  2D1F: ebd1             jmp 0x2cf2
  03E0A1  2D21: 90               nop 
  03E0A2  2D22: ff46f4           inc word ptr [bp - 0xc]
  03E0A5  2D25: 8b46f4           mov ax, word ptr [bp - 0xc]
  03E0A8  2D28: 39063c85         cmp word ptr [0x853c], ax
  03E0AC  2D2C: 7e08             jle 0x2d36
  03E0AE  2D2E: c746f60000       mov word ptr [bp - 0xa], 0
  03E0B3  2D33: ebc0             jmp 0x2cf5
  03E0B5  2D35: 90               nop 
  03E0B6  2D36: 6b1ed25334       imul bx, word ptr [0x53d2], 0x34
  03E0BB  2D3B: c6873f5401       mov byte ptr [bx + 0x543f], 1
  03E0C0  2D40: 6a22             push 0x22
  03E0C2  2D42: ff36d253         push word ptr [0x53d2]
  03E0C6  2D46: ffb6dcfc         push word ptr [bp - 0x324]
  03E0CA  2D4A: 9a060a1f18       lcall 0x181f, 0xa06
  03E0CF  2D4F: 83c406           add sp, 6
  03E0D2  2D52: 6a40             push 0x40
  03E0D4  2D54: ff36d253         push word ptr [0x53d2]
  03E0D8  2D58: ffb6dcfc         push word ptr [bp - 0x324]
  03E0DC  2D5C: 9a100a1f18       lcall 0x181f, 0xa10
  03E0E1  2D61: 83c406           add sp, 6
  03E0E4  2D64: 6a01             push 1
  03E0E6  2D66: 9a1c0e1f18       lcall 0x181f, 0xe1c
  03E0EB  2D6B: 83c402           add sp, 2
  03E0EE  2D6E: 6b86dcfc34       imul ax, word ptr [bp - 0x324], 0x34
  03E0F3  2D73: 050e54           add ax, 0x540e
  03E0F6  2D76: 1e               push ds
  03E0F7  2D77: 50               push ax
  03E0F8  2D78: 6a00             push 0
  03E0FA  2D7A: 9a16041f18       lcall 0x181f, 0x416
  03E0FF  2D7F: 83c406           add sp, 6
  03E102  2D82: 6a01             push 1
  03E104  2D84: 680b13           push 0x130b
  03E107  2D87: 9a52061f18       lcall 0x181f, 0x652
  03E10C  2D8C: 83c404           add sp, 4
  03E10F  2D8F: a19c53           mov ax, word ptr [0x539c]
  03E112  2D92: 48               dec ax
  03E113  2D93: 8986e4fc         mov word ptr [bp - 0x31c], ax
  03E117  2D97: eb22             jmp 0x2dbb
  03E119  2D99: 90               nop 
  03E11A  2D9A: 6b9ee4fc1c       imul bx, word ptr [bp - 0x31c], 0x1c
  03E11F  2D9F: 8a874731         mov al, byte ptr [bx + 0x3147]
  03E123  2DA3: 240f             and al, 0xf
  03E125  2DA5: 3a86dcfc         cmp al, byte ptr [bp - 0x324]
  03E129  2DA9: 750c             jne 0x2db7
  03E12B  2DAB: ffb6e4fc         push word ptr [bp - 0x31c]
  03E12F  2DAF: 9a34091f18       lcall 0x181f, 0x934
  03E134  2DB4: 83c402           add sp, 2
  03E137  2DB7: ff8ee4fc         dec word ptr [bp - 0x31c]
  03E13B  2DBB: 83bee4fc00       cmp word ptr [bp - 0x31c], 0
  03E140  2DC0: 7dd8             jge 0x2d9a
  03E142  2DC2: 2bc0             sub ax, ax
  03E144  2DC4: 699edcfc3c01     imul bx, word ptr [bp - 0x324], 0x13c
  03E14A  2DCA: 89871e88         mov word ptr [bx - 0x77e2], ax
  03E14E  2DCE: 691ed2533c01     imul bx, word ptr [0x53d2], 0x13c
  03E154  2DD4: 89871e88         mov word ptr [bx - 0x77e2], ax
  03E158  2DD8: 80a70888fb       and byte ptr [bx - 0x77f8], 0xfb
  03E15D  2DDD: 5e               pop si
  03E15E  2DDE: 5f               pop di
  03E15F  2DDF: c9               leave 
  03E160  2DE0: cb               retf 

; ---- func_03E162  size=391  insns=136  prologue=ENTER 0x0008,0  terminal=RETF ----
  03E162  2DE2: c8080000         enter 8, 0
  03E166  2DE6: 56               push si
  03E167  2DE7: ff7606           push word ptr [bp + 6]
  03E16A  2DEA: 9a82051f18       lcall 0x181f, 0x582
  03E16F  2DEF: 83c402           add sp, 2
  03E172  2DF2: f606825301       test byte ptr [0x5382], 1
  03E177  2DF7: 7403             je 0x2dfc
  03E179  2DF9: e96a01           jmp 0x2f66
  03E17C  2DFC: a0a653           mov al, byte ptr [0x53a6]
  03E17F  2DFF: 2ae4             sub ah, ah
  03E181  2E01: c1e003           shl ax, 3
  03E184  2E04: 050a00           add ax, 0xa
  03E187  2E07: 8946fc           mov word ptr [bp - 4], ax
  03E18A  2E0A: 813e8a534006     cmp word ptr [0x538a], 0x640
  03E190  2E10: 7c05             jl 0x2e17
  03E192  2E12: d1e0             shl ax, 1
  03E194  2E14: 8946fc           mov word ptr [bp - 4], ax
  03E197  2E17: 813e8a53a406     cmp word ptr [0x538a], 0x6a4
  03E19D  2E1D: 7c03             jl 0x2e22
  03E19F  2E1F: d166fc           shl word ptr [bp - 4], 1
  03E1A2  2E22: 813e8a53d606     cmp word ptr [0x538a], 0x6d6
  03E1A8  2E28: 7c03             jl 0x2e2d
  03E1AA  2E2A: d166fc           shl word ptr [bp - 4], 1
  03E1AD  2E2D: 8b46fc           mov ax, word ptr [bp - 4]
  03E1B0  2E30: 99               cdq 
  03E1B1  2E31: 8b1efc84         mov bx, word ptr [0x84fc]
  03E1B5  2E35: 014722           add word ptr [bx + 0x22], ax
  03E1B8  2E38: 115724           adc word ptr [bx + 0x24], dx
  03E1BB  2E3B: 837f2400         cmp word ptr [bx + 0x24], 0
  03E1BF  2E3F: 7f0f             jg 0x2e50
  03E1C1  2E41: 7d03             jge 0x2e46
  03E1C3  2E43: e92001           jmp 0x2f66
  03E1C6  2E46: 817f220807       cmp word ptr [bx + 0x22], 0x708
  03E1CB  2E4B: 7303             jae 0x2e50
  03E1CD  2E4D: e91601           jmp 0x2f66
  03E1D0  2E50: c746f80000       mov word ptr [bp - 8], 0
  03E1D5  2E55: a1da53           mov ax, word ptr [0x53da]
  03E1D8  2E58: 40               inc ax
  03E1D9  2E59: 40               inc ax
  03E1DA  2E5A: b90300           mov cx, 3
  03E1DD  2E5D: 99               cdq 
  03E1DE  2E5E: f7f9             idiv cx
  03E1E0  2E60: 3b06dc53         cmp ax, word ptr [0x53dc]
  03E1E4  2E64: 7e05             jle 0x2e6b
  03E1E6  2E66: c746f80100       mov word ptr [bp - 8], 1
  03E1EB  2E6B: a1da53           mov ax, word ptr [0x53da]
  03E1EE  2E6E: 99               cdq 
  03E1EF  2E6F: 33c2             xor ax, dx
  03E1F1  2E71: 2bc2             sub ax, dx
  03E1F3  2E73: c1f802           sar ax, 2
  03E1F6  2E76: 33c2             xor ax, dx
  03E1F8  2E78: 2bc2             sub ax, dx
  03E1FA  2E7A: 3b06e053         cmp ax, word ptr [0x53e0]
  03E1FE  2E7E: 7e03             jle 0x2e83
  03E200  2E80: 894ef8           mov word ptr [bp - 8], cx
  03E203  2E83: a1da53           mov ax, word ptr [0x53da]
  03E206  2E86: 0306dc53         add ax, word ptr [0x53dc]
  03E20A  2E8A: 0306e053         add ax, word ptr [0x53e0]
  03E20E  2E8E: 050500           add ax, 5
  03E211  2E91: b90a00           mov cx, 0xa
  03E214  2E94: 99               cdq 
  03E215  2E95: f7f9             idiv cx
  03E217  2E97: 3b06de53         cmp ax, word ptr [0x53de]
  03E21B  2E9B: 7e05             jle 0x2ea2
  03E21D  2E9D: c746f80200       mov word ptr [bp - 8], 2
  03E222  2EA2: ff36d253         push word ptr [0x53d2]
  03E226  2EA6: ff76f8           push word ptr [bp - 8]
  03E229  2EA9: 0e               push cs
  03E22A  2EAA: e8e307           call 0x3690
  03E22D  2EAD: 83c404           add sp, 4
  03E230  2EB0: 8946fe           mov word ptr [bp - 2], ax
  03E233  2EB3: 8b5ef8           mov bx, word ptr [bp - 8]
  03E236  2EB6: d1e3             shl bx, 1
  03E238  2EB8: ff87da53         inc word ptr [bx + 0x53da]
  03E23C  2EBC: f606825301       test byte ptr [0x5382], 1
  03E241  2EC1: 7547             jne 0x2f0a
  03E243  2EC3: 8b5efe           mov bx, word ptr [bp - 2]
  03E246  2EC6: 8bc3             mov ax, bx
  03E248  2EC8: d1e3             shl bx, 1
  03E24A  2ECA: 03d8             add bx, ax
  03E24C  2ECC: d1e3             shl bx, 1
  03E24E  2ECE: 03d8             add bx, ax
  03E250  2ED0: d1e3             shl bx, 1
  03E252  2ED2: ffb73052         push word ptr [bx + 0x5230]
  03E256  2ED6: 6a00             push 0
  03E258  2ED8: 9a38041f18       lcall 0x181f, 0x438
  03E25D  2EDD: 83c404           add sp, 4
  03E260  2EE0: 6a01             push 1
  03E262  2EE2: 681813           push 0x1318
  03E265  2EE5: 9a52061f18       lcall 0x181f, 0x652
  03E26A  2EEA: 83c404           add sp, 4
  03E26D  2EED: 8b1efc84         mov bx, word ptr [0x84fc]
  03E271  2EF1: 816f220807       sub word ptr [bx + 0x22], 0x708
  03E276  2EF6: 835f2400         sbb word ptr [bx + 0x24], 0
  03E27A  2EFA: 8b7606           mov si, word ptr [bp + 6]
  03E27D  2EFD: 8a840894         mov al, byte ptr [si - 0x6bf8]
  03E281  2F01: 2ae4             sub ah, ah
  03E283  2F03: 01470e           add word ptr [bx + 0xe], ax
  03E286  2F06: 5e               pop si
  03E287  2F07: c9               leave 
  03E288  2F08: cb               retf 
  03E289  2F09: 90               nop 
  03E28A  2F0A: 6a03             push 3
  03E28C  2F0C: 9a98041f18       lcall 0x181f, 0x498
  03E291  2F11: 83c402           add sp, 2
  03E294  2F14: 6b06985334       imul ax, word ptr [0x5398], 0x34
  03E299  2F19: 052654           add ax, 0x5426
  03E29C  2F1C: 1e               push ds
  03E29D  2F1D: 50               push ax
  03E29E  2F1E: 6a00             push 0
  03E2A0  2F20: 9a16041f18       lcall 0x181f, 0x416
  03E2A5  2F25: 83c406           add sp, 6
  03E2A8  2F28: 8b5efe           mov bx, word ptr [bp - 2]
  03E2AB  2F2B: 8bc3             mov ax, bx
  03E2AD  2F2D: d1e3             shl bx, 1
  03E2AF  2F2F: 03d8             add bx, ax
  03E2B1  2F31: d1e3             shl bx, 1
  03E2B3  2F33: 03d8             add bx, ax
  03E2B5  2F35: d1e3             shl bx, 1
  03E2B7  2F37: ffb73052         push word ptr [bx + 0x5230]
  03E2BB  2F3B: 6a01             push 1
  03E2BD  2F3D: 9a38041f18       lcall 0x181f, 0x438
  03E2C2  2F42: 83c404           add sp, 4
  03E2C5  2F45: 8b1e9853         mov bx, word ptr [0x5398]
  03E2C9  2F49: d1e3             shl bx, 1
  03E2CB  2F4B: ffb78c83         push word ptr [bx - 0x7c74]
  03E2CF  2F4F: 6a02             push 2
  03E2D1  2F51: 9a38041f18       lcall 0x181f, 0x438
  03E2D6  2F56: 83c404           add sp, 4
  03E2D9  2F59: 6a01             push 1
  03E2DB  2F5B: 682013           push 0x1320
  03E2DE  2F5E: 9a52061f18       lcall 0x181f, 0x652
  03E2E3  2F63: 83c404           add sp, 4
  03E2E6  2F66: 5e               pop si
  03E2E7  2F67: c9               leave 
  03E2E8  2F68: cb               retf 

; ---- func_03E2EA  size=343  insns=126  prologue=ENTER 0x000C,0  terminal=RETF ----
  03E2EA  2F6A: c80c0000         enter 0xc, 0
  03E2EE  2F6E: 56               push si
  03E2EF  2F6F: 6a03             push 3
  03E2F1  2F71: 9aac041f18       lcall 0x181f, 0x4ac
  03E2F6  2F76: 83c402           add sp, 2
  03E2F9  2F79: c746f40000       mov word ptr [bp - 0xc], 0
  03E2FE  2F7E: e9c900           jmp 0x304a
  03E301  2F81: 90               nop 
  03E302  2F82: 6b5ef61c         imul bx, word ptr [bp - 0xa], 0x1c
  03E306  2F86: c687463107       mov byte ptr [bx + 0x3146], 7
  03E30B  2F8B: ff46f8           inc word ptr [bp - 8]
  03E30E  2F8E: 8b46f6           mov ax, word ptr [bp - 0xa]
  03E311  2F91: 9ae4021f18       lcall 0x181f, 0x2e4
  03E316  2F96: 8946f6           mov word ptr [bp - 0xa], ax
  03E319  2F99: 837efe00         cmp word ptr [bp - 2], 0
  03E31D  2F9D: 7e63             jle 0x3002
  03E31F  2F9F: 0bc0             or ax, ax
  03E321  2FA1: 7c5f             jl 0x3002
  03E323  2FA3: 6bd81c           imul bx, ax, 0x1c
  03E326  2FA6: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  03E32B  2FAB: 7407             je 0x2fb4
  03E32D  2FAD: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  03E332  2FB2: 75da             jne 0x2f8e
  03E334  2FB4: 6bd81c           imul bx, ax, 0x1c
  03E337  2FB7: 80bf5b3115       cmp byte ptr [bx + 0x315b], 0x15
  03E33C  2FBC: 75d0             jne 0x2f8e
  03E33E  2FBE: ff4efe           dec word ptr [bp - 2]
  03E341  2FC1: a14285           mov ax, word ptr [0x8542]
  03E344  2FC4: 40               inc ax
  03E345  2FC5: 40               inc ax
  03E346  2FC6: 1e               push ds
  03E347  2FC7: 50               push ax
  03E348  2FC8: 6a00             push 0
  03E34A  2FCA: 8bf3             mov si, bx
  03E34C  2FCC: 9a16041f18       lcall 0x181f, 0x416
  03E351  2FD1: 83c406           add sp, 6
  03E354  2FD4: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  03E358  2FD8: 2aff             sub bh, bh
  03E35A  2FDA: 8bc3             mov ax, bx
  03E35C  2FDC: d1e3             shl bx, 1
  03E35E  2FDE: 03d8             add bx, ax
  03E360  2FE0: d1e3             shl bx, 1
  03E362  2FE2: 03d8             add bx, ax
  03E364  2FE4: d1e3             shl bx, 1
  03E366  2FE6: ffb73052         push word ptr [bx + 0x5230]
  03E36A  2FEA: 6a01             push 1
  03E36C  2FEC: 9a38041f18       lcall 0x181f, 0x438
  03E371  2FF1: 83c404           add sp, 4
  03E374  2FF4: 80bc463101       cmp byte ptr [si + 0x3146], 1
  03E379  2FF9: 7587             jne 0x2f82
  03E37B  2FFB: c684463109       mov byte ptr [si + 0x3146], 9
  03E380  3000: eb89             jmp 0x2f8b
  03E382  3002: 837ef800         cmp word ptr [bp - 8], 0
  03E386  3006: 743f             je 0x3047
  03E388  3008: 8b1e4285         mov bx, word ptr [0x8542]
  03E38C  300C: 8a4701           mov al, byte ptr [bx + 1]
  03E38F  300F: 2ae4             sub ah, ah
  03E391  3011: 50               push ax
  03E392  3012: 8a07             mov al, byte ptr [bx]
  03E394  3014: 50               push ax
  03E395  3015: 9a9a0d1f18       lcall 0x181f, 0xd9a
  03E39A  301A: 83c404           add sp, 4
  03E39D  301D: 837ef801         cmp word ptr [bp - 8], 1
  03E3A1  3021: 7507             jne 0x302a
  03E3A3  3023: 6a01             push 1
  03E3A5  3025: 682d13           push 0x132d
  03E3A8  3028: eb15             jmp 0x303f
  03E3AA  302A: 8b46f8           mov ax, word ptr [bp - 8]
  03E3AD  302D: 99               cdq 
  03E3AE  302E: 52               push dx
  03E3AF  302F: 50               push ax
  03E3B0  3030: 6a00             push 0
  03E3B2  3032: 9aae091f18       lcall 0x181f, 0x9ae
  03E3B7  3037: 83c406           add sp, 6
  03E3BA  303A: 6a01             push 1
  03E3BC  303C: 683613           push 0x1336
  03E3BF  303F: 9a52061f18       lcall 0x181f, 0x652
  03E3C4  3044: 83c404           add sp, 4
  03E3C7  3047: ff46f4           inc word ptr [bp - 0xc]
  03E3CA  304A: a19e53           mov ax, word ptr [0x539e]
  03E3CD  304D: 3946f4           cmp word ptr [bp - 0xc], ax
  03E3D0  3050: 7d6c             jge 0x30be
  03E3D2  3052: ff76f4           push word ptr [bp - 0xc]
  03E3D5  3055: 9ae6091f18       lcall 0x181f, 0x9e6
  03E3DA  305A: 83c402           add sp, 2
  03E3DD  305D: 8a4606           mov al, byte ptr [bp + 6]
  03E3E0  3060: 8b1e4285         mov bx, word ptr [0x8542]
  03E3E4  3064: 38471a           cmp byte ptr [bx + 0x1a], al
  03E3E7  3067: 75de             jne 0x3047
  03E3E9  3069: 9a860c1f18       lcall 0x181f, 0xc86
  03E3EE  306E: 8946fa           mov word ptr [bp - 6], ax
  03E3F1  3071: 3d3200           cmp ax, 0x32
  03E3F4  3074: 7cd1             jl 0x3047
  03E3F6  3076: 8b1e4285         mov bx, word ptr [0x8542]
  03E3FA  307A: 8a471f           mov al, byte ptr [bx + 0x1f]
  03E3FD  307D: 8bc8             mov cx, ax
  03E3FF  307F: d0f8             sar al, 1
  03E401  3081: 98               cwde 
  03E402  3082: 8b76fa           mov si, word ptr [bp - 6]
  03E405  3085: 83ee32           sub si, 0x32
  03E408  3088: 8bd0             mov dx, ax
  03E40A  308A: 8ac1             mov al, cl
  03E40C  308C: 98               cwde 
  03E40D  308D: 8bca             mov cx, dx
  03E40F  308F: f7ee             imul si
  03E411  3091: be3200           mov si, 0x32
  03E414  3094: 99               cdq 
  03E415  3095: f7fe             idiv si
  03E417  3097: 3bc1             cmp ax, cx
  03E419  3099: 7e02             jle 0x309d
  03E41B  309B: 8bc1             mov ax, cx
  03E41D  309D: 3d0100           cmp ax, 1
  03E420  30A0: 7d03             jge 0x30a5
  03E422  30A2: b80100           mov ax, 1
  03E425  30A5: 8946fe           mov word ptr [bp - 2], ax
  03E428  30A8: 2bc0             sub ax, ax
  03E42A  30AA: 8946f8           mov word ptr [bp - 8], ax
  03E42D  30AD: 8a07             mov al, byte ptr [bx]
  03E42F  30AF: 2ae4             sub ah, ah
  03E431  30B1: 8a5701           mov dl, byte ptr [bx + 1]
  03E434  30B4: 2af6             sub dh, dh
  03E436  30B6: 9ae0071f18       lcall 0x181f, 0x7e0
  03E43B  30BB: e9d8fe           jmp 0x2f96
  03E43E  30BE: 5e               pop si
  03E43F  30BF: c9               leave 
  03E440  30C0: cb               retf 

; ---- func_03E442  size=546  insns=198  prologue=ENTER 0x005A,0  terminal=RETF ----
  03E442  30C2: c85a0000         enter 0x5a, 0
  03E446  30C6: 57               push di
  03E447  30C7: 56               push si
  03E448  30C8: ff7606           push word ptr [bp + 6]
  03E44B  30CB: 9a82051f18       lcall 0x181f, 0x582
  03E450  30D0: 83c402           add sp, 2
  03E453  30D3: 8b4606           mov ax, word ptr [bp + 6]
  03E456  30D6: 3906d253         cmp word ptr [0x53d2], ax
  03E45A  30DA: 755c             jne 0x3138
  03E45C  30DC: 691e98533c01     imul bx, word ptr [0x5398], 0x13c
  03E462  30E2: f687088808       test byte ptr [bx - 0x77f8], 8
  03E467  30E7: 7408             je 0x30f1
  03E469  30E9: 50               push ax
  03E46A  30EA: 0e               push cs
  03E46B  30EB: e8a705           call 0x3695
  03E46E  30EE: 83c402           add sp, 2
  03E471  30F1: 833ee05300       cmp word ptr [0x53e0], 0
  03E476  30F6: 7e06             jle 0x30fe
  03E478  30F8: b80100           mov ax, 1
  03E47B  30FB: eb03             jmp 0x3100
  03E47D  30FD: 90               nop 
  03E47E  30FE: 2bc0             sub ax, ax
  03E480  3100: 8946a6           mov word ptr [bp - 0x5a], ax
  03E483  3103: 833edc5300       cmp word ptr [0x53dc], 0
  03E488  3108: 7e06             jle 0x3110
  03E48A  310A: b80100           mov ax, 1
  03E48D  310D: eb03             jmp 0x3112
  03E48F  310F: 90               nop 
  03E490  3110: 2bc0             sub ax, ax
  03E492  3112: 0346a6           add ax, word ptr [bp - 0x5a]
  03E495  3115: 0306da53         add ax, word ptr [0x53da]
  03E499  3119: 8946a8           mov word ptr [bp - 0x58], ax
  03E49C  311C: 0bc0             or ax, ax
  03E49E  311E: 740c             je 0x312c
  03E4A0  3120: ff369853         push word ptr [0x5398]
  03E4A4  3124: 0e               push cs
  03E4A5  3125: e89505           call 0x36bd
  03E4A8  3128: e9b201           jmp 0x32dd
  03E4AB  312B: 90               nop 
  03E4AC  312C: ff369853         push word ptr [0x5398]
  03E4B0  3130: 0e               push cs
  03E4B1  3131: e89305           call 0x36c7
  03E4B4  3134: e9a601           jmp 0x32dd
  03E4B7  3137: 90               nop 
  03E4B8  3138: 8b1efc84         mov bx, word ptr [0x84fc]
  03E4BC  313C: f60708           test byte ptr [bx], 8
  03E4BF  313F: 7513             jne 0x3154
  03E4C1  3141: 50               push ax
  03E4C2  3142: 0e               push cs
  03E4C3  3143: e86805           call 0x36ae
  03E4C6  3146: 83c402           add sp, 2
  03E4C9  3149: 8b1efc84         mov bx, word ptr [0x84fc]
  03E4CD  314D: 800f08           or byte ptr [bx], 8
  03E4D0  3150: 5e               pop si
  03E4D1  3151: 5f               pop di
  03E4D2  3152: c9               leave 
  03E4D3  3153: cb               retf 
  03E4D4  3154: f606825302       test byte ptr [0x5382], 2
  03E4D9  3159: 740d             je 0x3168
  03E4DB  315B: 833ee65300       cmp word ptr [0x53e6], 0
  03E4E0  3160: 7406             je 0x3168
  03E4E2  3162: 6a00             push 0
  03E4E4  3164: e97201           jmp 0x32d9
  03E4E7  3167: 90               nop 
  03E4E8  3168: 6a02             push 2
  03E4EA  316A: 6a00             push 0
  03E4EC  316C: 9ad4041f18       lcall 0x181f, 0x4d4
  03E4F1  3171: 83c404           add sp, 4
  03E4F4  3174: 0bc0             or ax, ax
  03E4F6  3176: 7403             je 0x317b
  03E4F8  3178: e96501           jmp 0x32e0
  03E4FB  317B: 8946aa           mov word ptr [bp - 0x56], ax
  03E4FE  317E: 8b5eaa           mov bx, word ptr [bp - 0x56]
  03E501  3181: d1e3             shl bx, 1
  03E503  3183: c787469e0000     mov word ptr [bx - 0x61ba], 0
  03E509  3189: ff46aa           inc word ptr [bp - 0x56]
  03E50C  318C: 837eaa04         cmp word ptr [bp - 0x56], 4
  03E510  3190: 7cec             jl 0x317e
  03E512  3192: a0a653           mov al, byte ptr [0x53a6]
  03E515  3195: 2ae4             sub ah, ah
  03E517  3197: 2d0400           sub ax, 4
  03E51A  319A: f7d8             neg ax
  03E51C  319C: d1f8             sar ax, 1
  03E51E  319E: 40               inc ax
  03E51F  319F: 40               inc ax
  03E520  31A0: 50               push ax
  03E521  31A1: 6a02             push 2
  03E523  31A3: 9ad4041f18       lcall 0x181f, 0x4d4
  03E528  31A8: 83c404           add sp, 4
  03E52B  31AB: a3469e           mov word ptr [0x9e46], ax
  03E52E  31AE: 6a01             push 1
  03E530  31B0: 6a00             push 0
  03E532  31B2: 9ad4041f18       lcall 0x181f, 0x4d4
  03E537  31B7: 83c404           add sp, 4
  03E53A  31BA: 0bc0             or ax, ax
  03E53C  31BC: 7408             je 0x31c6
  03E53E  31BE: c706489e0100     mov word ptr [0x9e48], 1
  03E544  31C4: eb06             jmp 0x31cc
  03E546  31C6: c7064c9e0100     mov word ptr [0x9e4c], 1
  03E54C  31CC: 6a06             push 6
  03E54E  31CE: 6a00             push 0
  03E550  31D0: 9ad4041f18       lcall 0x181f, 0x4d4
  03E555  31D5: 83c404           add sp, 4
  03E558  31D8: 8a0ea653         mov cl, byte ptr [0x53a6]
  03E55C  31DC: 2aed             sub ch, ch
  03E55E  31DE: 83c103           add cx, 3
  03E561  31E1: d1e1             shl cx, 1
  03E563  31E3: 03c8             add cx, ax
  03E565  31E5: 6bc164           imul ax, cx, 0x64
  03E568  31E8: 8946ac           mov word ptr [bp - 0x54], ax
  03E56B  31EB: a14c9e           mov ax, word ptr [0x9e4c]
  03E56E  31EE: 0306489e         add ax, word ptr [0x9e48]
  03E572  31F2: d1e0             shl ax, 1
  03E574  31F4: 0306469e         add ax, word ptr [0x9e46]
  03E578  31F8: f76eac           imul word ptr [bp - 0x54]
  03E57B  31FB: 8946ac           mov word ptr [bp - 0x54], ax
  03E57E  31FE: c646b000         mov byte ptr [bp - 0x50], 0
  03E582  3202: ff36469e         push word ptr [0x9e46]
  03E586  3206: 8d46b0           lea ax, [bp - 0x50]
  03E589  3209: 16               push ss
  03E58A  320A: 50               push ax
  03E58B  320B: 9a82011f18       lcall 0x181f, 0x182
  03E590  3210: 83c406           add sp, 6
  03E593  3213: 8d46b0           lea ax, [bp - 0x50]
  03E596  3216: 50               push ax
  03E597  3217: 9a78011f18       lcall 0x181f, 0x178
  03E59C  321C: 83c402           add sp, 2
  03E59F  321F: ff368452         push word ptr [0x5284]
  03E5A3  3223: 8d46b0           lea ax, [bp - 0x50]
  03E5A6  3226: 50               push ax
  03E5A7  3227: 9a6e011f18       lcall 0x181f, 0x16e
  03E5AC  322C: 83c404           add sp, 4
  03E5AF  322F: 833e489e00       cmp word ptr [0x9e48], 0
  03E5B4  3234: 741c             je 0x3252
  03E5B6  3236: 8d46b0           lea ax, [bp - 0x50]
  03E5B9  3239: 50               push ax
  03E5BA  323A: 9ab4011f18       lcall 0x181f, 0x1b4
  03E5BF  323F: 83c402           add sp, 2
  03E5C2  3242: ff36a052         push word ptr [0x52a0]
  03E5C6  3246: 8d46b0           lea ax, [bp - 0x50]
  03E5C9  3249: 50               push ax
  03E5CA  324A: 9a6e011f18       lcall 0x181f, 0x16e
  03E5CF  324F: 83c404           add sp, 4
  03E5D2  3252: 833e4c9e00       cmp word ptr [0x9e4c], 0
  03E5D7  3257: 741c             je 0x3275
  03E5D9  3259: 8d46b0           lea ax, [bp - 0x50]
  03E5DC  325C: 50               push ax
  03E5DD  325D: 9ab4011f18       lcall 0x181f, 0x1b4
  03E5E2  3262: 83c402           add sp, 2
  03E5E5  3265: ff36ca52         push word ptr [0x52ca]
  03E5E9  3269: 8d46b0           lea ax, [bp - 0x50]
  03E5EC  326C: 50               push ax
  03E5ED  326D: 9a6e011f18       lcall 0x181f, 0x16e
  03E5F2  3272: 83c404           add sp, 4
  03E5F5  3275: 8b46ac           mov ax, word ptr [bp - 0x54]
  03E5F8  3278: 99               cdq 
  03E5F9  3279: 8b1efc84         mov bx, word ptr [0x84fc]
  03E5FD  327D: 39572c           cmp word ptr [bx + 0x2c], dx
  03E600  3280: 7c5e             jl 0x32e0
  03E602  3282: 7f05             jg 0x3289
  03E604  3284: 39472a           cmp word ptr [bx + 0x2a], ax
  03E607  3287: 7257             jb 0x32e0
  03E609  3289: ff36d653         push word ptr [0x53d6]
  03E60D  328D: 6a00             push 0
  03E60F  328F: 6a00             push 0
  03E611  3291: 8bf0             mov si, ax
  03E613  3293: 8bfa             mov di, dx
  03E615  3295: 9ac80a1f19       lcall 0x191f, 0xac8
  03E61A  329A: 83c406           add sp, 6
  03E61D  329D: 57               push di
  03E61E  329E: 56               push si
  03E61F  329F: 6a00             push 0
  03E621  32A1: 9aae091f18       lcall 0x181f, 0x9ae
  03E626  32A6: 83c406           add sp, 6
  03E629  32A9: 8d46b0           lea ax, [bp - 0x50]
  03E62C  32AC: 16               push ss
  03E62D  32AD: 50               push ax
  03E62E  32AE: 6a01             push 1
  03E630  32B0: 9a16041f18       lcall 0x181f, 0x416
  03E635  32B5: 83c406           add sp, 6
  03E638  32B8: 6a01             push 1
  03E63A  32BA: 684013           push 0x1340
  03E63D  32BD: 9a52061f18       lcall 0x181f, 0x652
  03E642  32C2: 83c404           add sp, 4
  03E645  32C5: 8946ae           mov word ptr [bp - 0x52], ax
  03E648  32C8: 3d0200           cmp ax, 2
  03E64B  32CB: 7513             jne 0x32e0
  03E64D  32CD: 8b1efc84         mov bx, word ptr [0x84fc]
  03E651  32D1: 29772a           sub word ptr [bx + 0x2a], si
  03E654  32D4: 197f2c           sbb word ptr [bx + 0x2c], di
  03E657  32D7: 6a01             push 1
  03E659  32D9: 0e               push cs
  03E65A  32DA: e8e503           call 0x36c2
  03E65D  32DD: 83c402           add sp, 2
  03E660  32E0: 5e               pop si
  03E661  32E1: 5f               pop di
  03E662  32E2: c9               leave 
  03E663  32E3: cb               retf 

; ---- func_03E664  size=479  insns=168  prologue=ENTER 0x0056,0  terminal=RETF ----
  03E664  32E4: c8560000         enter 0x56, 0
  03E668  32E8: 57               push di
  03E669  32E9: 56               push si
  03E66A  32EA: f606825301       test byte ptr [0x5382], 1
  03E66F  32EF: 7403             je 0x32f4
  03E671  32F1: e9cb01           jmp 0x34bf
  03E674  32F4: 6a14             push 0x14
  03E676  32F6: 6a00             push 0
  03E678  32F8: 9ad4041f18       lcall 0x181f, 0x4d4
  03E67D  32FD: 83c404           add sp, 4
  03E680  3300: 0bc0             or ax, ax
  03E682  3302: 7403             je 0x3307
  03E684  3304: e9b801           jmp 0x34bf
  03E687  3307: 6a03             push 3
  03E689  3309: 50               push ax
  03E68A  330A: 9ad4041f18       lcall 0x181f, 0x4d4
  03E68F  330F: 83c404           add sp, 4
  03E692  3312: a3d653           mov word ptr [0x53d6], ax
  03E695  3315: 39069853         cmp word ptr [0x5398], ax
  03E699  3319: 7414             je 0x332f
  03E69B  331B: ff369853         push word ptr [0x5398]
  03E69F  331F: 50               push ax
  03E6A0  3320: 9a380a1f18       lcall 0x181f, 0xa38
  03E6A5  3325: 83c404           add sp, 4
  03E6A8  3328: a840             test al, 0x40
  03E6AA  332A: 7503             jne 0x332f
  03E6AC  332C: e99001           jmp 0x34bf
  03E6AF  332F: c746aa0000       mov word ptr [bp - 0x56], 0
  03E6B4  3334: 8b5eaa           mov bx, word ptr [bp - 0x56]
  03E6B7  3337: d1e3             shl bx, 1
  03E6B9  3339: c787469e0000     mov word ptr [bx - 0x61ba], 0
  03E6BF  333F: ff46aa           inc word ptr [bp - 0x56]
  03E6C2  3342: 837eaa04         cmp word ptr [bp - 0x56], 4
  03E6C6  3346: 7cec             jl 0x3334
  03E6C8  3348: 6a03             push 3
  03E6CA  334A: 6a01             push 1
  03E6CC  334C: 9ad4041f18       lcall 0x181f, 0x4d4
  03E6D1  3351: 83c404           add sp, 4
  03E6D4  3354: a3469e           mov word ptr [0x9e46], ax
  03E6D7  3357: 6a01             push 1
  03E6D9  3359: 6a00             push 0
  03E6DB  335B: 9ad4041f18       lcall 0x181f, 0x4d4
  03E6E0  3360: 83c404           add sp, 4
  03E6E3  3363: 0bc0             or ax, ax
  03E6E5  3365: 7407             je 0x336e
  03E6E7  3367: ff06469e         inc word ptr [0x9e46]
  03E6EB  336B: eb1a             jmp 0x3387
  03E6ED  336D: 90               nop 
  03E6EE  336E: b80100           mov ax, 1
  03E6F1  3371: a34c9e           mov word ptr [0x9e4c], ax
  03E6F4  3374: 50               push ax
  03E6F5  3375: 6a00             push 0
  03E6F7  3377: 9ad4041f18       lcall 0x181f, 0x4d4
  03E6FC  337C: 83c404           add sp, 4
  03E6FF  337F: 0bc0             or ax, ax
  03E701  3381: 7504             jne 0x3387
  03E703  3383: ff064c9e         inc word ptr [0x9e4c]
  03E707  3387: 6a06             push 6
  03E709  3389: 6a00             push 0
  03E70B  338B: 9ad4041f18       lcall 0x181f, 0x4d4
  03E710  3390: 83c404           add sp, 4
  03E713  3393: 8a0ea653         mov cl, byte ptr [0x53a6]
  03E717  3397: 2aed             sub ch, ch
  03E719  3399: 83c104           add cx, 4
  03E71C  339C: d1e1             shl cx, 1
  03E71E  339E: 03c8             add cx, ax
  03E720  33A0: 6bc164           imul ax, cx, 0x64
  03E723  33A3: 8946ac           mov word ptr [bp - 0x54], ax
  03E726  33A6: a14c9e           mov ax, word ptr [0x9e4c]
  03E729  33A9: 0306489e         add ax, word ptr [0x9e48]
  03E72D  33AD: d1e0             shl ax, 1
  03E72F  33AF: 0306469e         add ax, word ptr [0x9e46]
  03E733  33B3: f76eac           imul word ptr [bp - 0x54]
  03E736  33B6: 8946ac           mov word ptr [bp - 0x54], ax
  03E739  33B9: c646b000         mov byte ptr [bp - 0x50], 0
  03E73D  33BD: ff36469e         push word ptr [0x9e46]
  03E741  33C1: 8d46b0           lea ax, [bp - 0x50]
  03E744  33C4: 16               push ss
  03E745  33C5: 50               push ax
  03E746  33C6: 9a82011f18       lcall 0x181f, 0x182
  03E74B  33CB: 83c406           add sp, 6
  03E74E  33CE: 8d46b0           lea ax, [bp - 0x50]
  03E751  33D1: 50               push ax
  03E752  33D2: 9a78011f18       lcall 0x181f, 0x178
  03E757  33D7: 83c402           add sp, 2
  03E75A  33DA: ff366852         push word ptr [0x5268]
  03E75E  33DE: 8d46b0           lea ax, [bp - 0x50]
  03E761  33E1: 50               push ax
  03E762  33E2: 9a6e011f18       lcall 0x181f, 0x16e
  03E767  33E7: 83c404           add sp, 4
  03E76A  33EA: 833e489e00       cmp word ptr [0x9e48], 0
  03E76F  33EF: 741c             je 0x340d
  03E771  33F1: 8d46b0           lea ax, [bp - 0x50]
  03E774  33F4: 50               push ax
  03E775  33F5: 9ab4011f18       lcall 0x181f, 0x1b4
  03E77A  33FA: 83c402           add sp, 2
  03E77D  33FD: ff36a052         push word ptr [0x52a0]
  03E781  3401: 8d46b0           lea ax, [bp - 0x50]
  03E784  3404: 50               push ax
  03E785  3405: 9a6e011f18       lcall 0x181f, 0x16e
  03E78A  340A: 83c404           add sp, 4
  03E78D  340D: 833e4c9e00       cmp word ptr [0x9e4c], 0
  03E792  3412: 7440             je 0x3454
  03E794  3414: 8d46b0           lea ax, [bp - 0x50]
  03E797  3417: 50               push ax
  03E798  3418: 9ab4011f18       lcall 0x181f, 0x1b4
  03E79D  341D: 83c402           add sp, 2
  03E7A0  3420: 833e4c9e01       cmp word ptr [0x9e4c], 1
  03E7A5  3425: 7e1d             jle 0x3444
  03E7A7  3427: ff364c9e         push word ptr [0x9e4c]
  03E7AB  342B: 8d46b0           lea ax, [bp - 0x50]
  03E7AE  342E: 16               push ss
  03E7AF  342F: 50               push ax
  03E7B0  3430: 9a82011f18       lcall 0x181f, 0x182
  03E7B5  3435: 83c406           add sp, 6
  03E7B8  3438: 8d46b0           lea ax, [bp - 0x50]
  03E7BB  343B: 50               push ax
  03E7BC  343C: 9a78011f18       lcall 0x181f, 0x178
  03E7C1  3441: 83c402           add sp, 2
  03E7C4  3444: ff36ca52         push word ptr [0x52ca]
  03E7C8  3448: 8d46b0           lea ax, [bp - 0x50]
  03E7CB  344B: 50               push ax
  03E7CC  344C: 9a6e011f18       lcall 0x181f, 0x16e
  03E7D1  3451: 83c404           add sp, 4
  03E7D4  3454: 8b46ac           mov ax, word ptr [bp - 0x54]
  03E7D7  3457: 99               cdq 
  03E7D8  3458: 8b1efc84         mov bx, word ptr [0x84fc]
  03E7DC  345C: 39572c           cmp word ptr [bx + 0x2c], dx
  03E7DF  345F: 7c5e             jl 0x34bf
  03E7E1  3461: 7f05             jg 0x3468
  03E7E3  3463: 39472a           cmp word ptr [bx + 0x2a], ax
  03E7E6  3466: 7257             jb 0x34bf
  03E7E8  3468: ff36d653         push word ptr [0x53d6]
  03E7EC  346C: 6a00             push 0
  03E7EE  346E: 6a00             push 0
  03E7F0  3470: 8bf0             mov si, ax
  03E7F2  3472: 8bfa             mov di, dx
  03E7F4  3474: 9ac80a1f19       lcall 0x191f, 0xac8
  03E7F9  3479: 83c406           add sp, 6
  03E7FC  347C: 57               push di
  03E7FD  347D: 56               push si
  03E7FE  347E: 6a00             push 0
  03E800  3480: 9aae091f18       lcall 0x181f, 0x9ae
  03E805  3485: 83c406           add sp, 6
  03E808  3488: 8d46b0           lea ax, [bp - 0x50]
  03E80B  348B: 16               push ss
  03E80C  348C: 50               push ax
  03E80D  348D: 6a01             push 1
  03E80F  348F: 9a16041f18       lcall 0x181f, 0x416
  03E814  3494: 83c406           add sp, 6
  03E817  3497: 6a01             push 1
  03E819  3499: 684c13           push 0x134c
  03E81C  349C: 9a52061f18       lcall 0x181f, 0x652
  03E821  34A1: 83c404           add sp, 4
  03E824  34A4: 8946ae           mov word ptr [bp - 0x52], ax
  03E827  34A7: 3d0200           cmp ax, 2
  03E82A  34AA: 7513             jne 0x34bf
  03E82C  34AC: 8b1efc84         mov bx, word ptr [0x84fc]
  03E830  34B0: 29772a           sub word ptr [bx + 0x2a], si
  03E833  34B3: 197f2c           sbb word ptr [bx + 0x2c], di
  03E836  34B6: 6a01             push 1
  03E838  34B8: 0e               push cs
  03E839  34B9: e80602           call 0x36c2
  03E83C  34BC: 83c402           add sp, 2
  03E83F  34BF: 5e               pop si
  03E840  34C0: 5f               pop di
  03E841  34C1: c9               leave 
  03E842  34C2: cb               retf 

; ---- func_03E844  size=319  insns=116  prologue=ENTER 0x0012,0  terminal=RETF ----
  03E844  34C4: c8120000         enter 0x12, 0
  03E848  34C8: a19853           mov ax, word ptr [0x5398]
  03E84B  34CB: 394606           cmp word ptr [bp + 6], ax
  03E84E  34CE: 740f             je 0x34df
  03E850  34D0: f606825301       test byte ptr [0x5382], 1
  03E855  34D5: 740f             je 0x34e6
  03E857  34D7: a1d253           mov ax, word ptr [0x53d2]
  03E85A  34DA: 394606           cmp word ptr [bp + 6], ax
  03E85D  34DD: 7507             jne 0x34e6
  03E85F  34DF: c746fe0100       mov word ptr [bp - 2], 1
  03E864  34E4: eb05             jmp 0x34eb
  03E866  34E6: c746fe0000       mov word ptr [bp - 2], 0
  03E86B  34EB: f606825301       test byte ptr [0x5382], 1
  03E870  34F0: 7416             je 0x3508
  03E872  34F2: 837efe00         cmp word ptr [bp - 2], 0
  03E876  34F6: 7503             jne 0x34fb
  03E878  34F8: e90601           jmp 0x3601
  03E87B  34FB: ff7606           push word ptr [bp + 6]
  03E87E  34FE: 0e               push cs
  03E87F  34FF: e8ca01           call 0x36cc
  03E882  3502: 83c402           add sp, 2
  03E885  3505: c9               leave 
  03E886  3506: cb               retf 
  03E887  3507: 90               nop 
  03E888  3508: 837efe00         cmp word ptr [bp - 2], 0
  03E88C  350C: 740a             je 0x3518
  03E88E  350E: ff7606           push word ptr [bp + 6]
  03E891  3511: 0e               push cs
  03E892  3512: e88001           call 0x3695
  03E895  3515: 83c402           add sp, 2
  03E898  3518: ff7606           push word ptr [bp + 6]
  03E89B  351B: 0e               push cs
  03E89C  351C: e8b201           call 0x36d1
  03E89F  351F: 83c402           add sp, 2
  03E8A2  3522: 8946f2           mov word ptr [bp - 0xe], ax
  03E8A5  3525: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  03E8AA  352A: 88872188         mov byte ptr [bx - 0x77df], al
  03E8AE  352E: 837efe00         cmp word ptr [bp - 2], 0
  03E8B2  3532: 7503             jne 0x3537
  03E8B4  3534: e9ca00           jmp 0x3601
  03E8B7  3537: 8b46f2           mov ax, word ptr [bp - 0xe]
  03E8BA  353A: a3d053           mov word ptr [0x53d0], ax
  03E8BD  353D: 3d3200           cmp ax, 0x32
  03E8C0  3540: 7c0b             jl 0x354d
  03E8C2  3542: 833ed25300       cmp word ptr [0x53d2], 0
  03E8C7  3547: 7d04             jge 0x354d
  03E8C9  3549: 0e               push cs
  03E8CA  354A: e83e01           call 0x368b
  03E8CD  354D: 8b5e06           mov bx, word ptr [bp + 6]
  03E8D0  3550: 80bf109404       cmp byte ptr [bx - 0x6bf0], 4
  03E8D5  3555: 7303             jae 0x355a
  03E8D7  3557: e9a700           jmp 0x3601
  03E8DA  355A: a1d053           mov ax, word ptr [0x53d0]
  03E8DD  355D: b90a00           mov cx, 0xa
  03E8E0  3560: 99               cdq 
  03E8E1  3561: f7f9             idiv cx
  03E8E3  3563: 3b06d853         cmp ax, word ptr [0x53d8]
  03E8E7  3567: 7e49             jle 0x35b2
  03E8E9  3569: 6a03             push 3
  03E8EB  356B: 9aac041f18       lcall 0x181f, 0x4ac
  03E8F0  3570: 83c402           add sp, 2
  03E8F3  3573: a1d053           mov ax, word ptr [0x53d0]
  03E8F6  3576: 99               cdq 
  03E8F7  3577: 52               push dx
  03E8F8  3578: 50               push ax
  03E8F9  3579: 6a00             push 0
  03E8FB  357B: 9aae091f18       lcall 0x181f, 0x9ae
  03E900  3580: 83c406           add sp, 6
  03E903  3583: ff369853         push word ptr [0x5398]
  03E907  3587: 6a00             push 0
  03E909  3589: 6a00             push 0
  03E90B  358B: 9ac80a1f19       lcall 0x191f, 0xac8
  03E910  3590: 83c406           add sp, 6
  03E913  3593: 833ed05332       cmp word ptr [0x53d0], 0x32
  03E918  3598: 7c08             jl 0x35a2
  03E91A  359A: 6a01             push 1
  03E91C  359C: 685813           push 0x1358
  03E91F  359F: eb06             jmp 0x35a7
  03E921  35A1: 90               nop 
  03E922  35A2: 6a01             push 1
  03E924  35A4: 686213           push 0x1362
  03E927  35A7: 9a52061f18       lcall 0x181f, 0x652
  03E92C  35AC: 83c404           add sp, 4
  03E92F  35AF: eb44             jmp 0x35f5
  03E931  35B1: 90               nop 
  03E932  35B2: a1d053           mov ax, word ptr [0x53d0]
  03E935  35B5: 050400           add ax, 4
  03E938  35B8: 99               cdq 
  03E939  35B9: f7f9             idiv cx
  03E93B  35BB: 3b06d853         cmp ax, word ptr [0x53d8]
  03E93F  35BF: 7d40             jge 0x3601
  03E941  35C1: 6a01             push 1
  03E943  35C3: 9aac041f18       lcall 0x181f, 0x4ac
  03E948  35C8: 83c402           add sp, 2
  03E94B  35CB: a1d053           mov ax, word ptr [0x53d0]
  03E94E  35CE: 99               cdq 
  03E94F  35CF: 52               push dx
  03E950  35D0: 50               push ax
  03E951  35D1: 6a00             push 0
  03E953  35D3: 9aae091f18       lcall 0x181f, 0x9ae
  03E958  35D8: 83c406           add sp, 6
  03E95B  35DB: ff369853         push word ptr [0x5398]
  03E95F  35DF: 6a00             push 0
  03E961  35E1: 6a00             push 0
  03E963  35E3: 9ac80a1f19       lcall 0x191f, 0xac8
  03E968  35E8: 83c406           add sp, 6
  03E96B  35EB: 6a01             push 1
  03E96D  35ED: 686a13           push 0x136a
  03E970  35F0: 9a52061f18       lcall 0x181f, 0x652
  03E975  35F5: a1d053           mov ax, word ptr [0x53d0]
  03E978  35F8: b90a00           mov cx, 0xa
  03E97B  35FB: 99               cdq 
  03E97C  35FC: f7f9             idiv cx
  03E97E  35FE: a3d853           mov word ptr [0x53d8], ax
  03E981  3601: c9               leave 
  03E982  3602: cb               retf 

; ---- func_03E984  size=210  insns=63  prologue=ENTER 0x0002,0  terminal=page-end ----
  03E984  3604: c8020000         enter 2, 0
  03E988  3608: f606825301       test byte ptr [0x5382], 1
  03E98D  360D: 740f             je 0x361e
  03E98F  360F: 6a01             push 1
  03E991  3611: 687413           push 0x1374
  03E994  3614: 9a52061f18       lcall 0x181f, 0x652
  03E999  3619: 83c404           add sp, 4
  03E99C  361C: c9               leave 
  03E99D  361D: cb               retf 
  03E99E  361E: 833ed05332       cmp word ptr [0x53d0], 0x32
  03E9A3  3623: 7d17             jge 0x363c
  03E9A5  3625: a1d053           mov ax, word ptr [0x53d0]
  03E9A8  3628: 99               cdq 
  03E9A9  3629: 52               push dx
  03E9AA  362A: 50               push ax
  03E9AB  362B: 6a00             push 0
  03E9AD  362D: 9aae091f18       lcall 0x181f, 0x9ae
  03E9B2  3632: 83c406           add sp, 6
  03E9B5  3635: 6a01             push 1
  03E9B7  3637: 688613           push 0x1386
  03E9BA  363A: ebd8             jmp 0x3614
  03E9BC  363C: f606815380       test byte ptr [0x5381], 0x80
  03E9C1  3641: 741b             je 0x365e
  03E9C3  3643: 6a01             push 1
  03E9C5  3645: 688e13           push 0x138e
  03E9C8  3648: 9a52061f18       lcall 0x181f, 0x652
  03E9CD  364D: 83c404           add sp, 4
  03E9D0  3650: 48               dec ax
  03E9D1  3651: 7531             jne 0x3684
  03E9D3  3653: 802681537f       and byte ptr [0x5381], 0x7f
  03E9D8  3658: a19453           mov ax, word ptr [0x5394]
  03E9DB  365B: a39853           mov word ptr [0x5398], ax
  03E9DE  365E: ff369853         push word ptr [0x5398]
  03E9E2  3662: 6a00             push 0
  03E9E4  3664: 6a00             push 0
  03E9E6  3666: 9ac80a1f19       lcall 0x191f, 0xac8
  03E9EB  366B: 83c406           add sp, 6
  03E9EE  366E: 6a01             push 1
  03E9F0  3670: 689713           push 0x1397
  03E9F3  3673: 9a52061f18       lcall 0x181f, 0x652
  03E9F8  3678: 83c404           add sp, 4
  03E9FB  367B: 3d0200           cmp ax, 2
  03E9FE  367E: 7504             jne 0x3684
  03EA00  3680: 0e               push cs
  03EA01  3681: e80200           call 0x3686
  03EA04  3684: c9               leave 
  03EA05  3685: cb               retf 
  03EA06  3686: ea56031f19       ljmp 0x191f:0x356
  03EA0B  368B: ea64031f19       ljmp 0x191f:0x364
  03EA10  3690: ea70001f1a       ljmp 0x1a1f:0x70
  03EA15  3695: ea7e001f1a       ljmp 0x1a1f:0x7e
  03EA1A  369A: ea8c001f1a       ljmp 0x1a1f:0x8c
  03EA1F  369F: ea9a001f1a       ljmp 0x1a1f:0x9a
  03EA24  36A4: eaa8001f1a       ljmp 0x1a1f:0xa8
  03EA29  36A9: eab6001f1a       ljmp 0x1a1f:0xb6
  03EA2E  36AE: eac4001f1a       ljmp 0x1a1f:0xc4
  03EA33  36B3: ead2001f1a       ljmp 0x1a1f:0xd2
  03EA38  36B8: eaee001f1a       ljmp 0x1a1f:0xee
  03EA3D  36BD: eafc001f1a       ljmp 0x1a1f:0xfc
  03EA42  36C2: ea0a011f1a       ljmp 0x1a1f:0x10a
  03EA47  36C7: ea18011f1a       ljmp 0x1a1f:0x118
  03EA4C  36CC: ea26011f1a       ljmp 0x1a1f:0x126
  03EA51  36D1: ea34011f1a       ljmp 0x1a1f:0x134
