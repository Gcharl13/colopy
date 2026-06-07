; ============================================================
; VICEROY.EXE overlay page 0x0E (record 13) -- RE-SEGMENTED
; file_offset (disk image) = 0x053540
; code_offset (first insn) = 0x053820
; code_end (next reloc hdr)= 0x0562B0  [resident size 681 para -> nominal_end 0x055FD0; on-disk code spills past it]
; reloc_count = 171  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x053540)
; functions in page = 6
; ============================================================

; ---- func_053820  size=531  insns=186  prologue=ENTER 0x0028,0  terminal=RETF ----
  053820  02E0: c8280000         enter 0x28, 0
  053824  02E4: 56               push si
  053825  02E5: c746fc0000       mov word ptr [bp - 4], 0
  05382A  02EA: 8b1e4285         mov bx, word ptr [0x8542]
  05382E  02EE: 8a07             mov al, byte ptr [bx]
  053830  02F0: 2ae4             sub ah, ah
  053832  02F2: 8946ea           mov word ptr [bp - 0x16], ax
  053835  02F5: 8a4f01           mov cl, byte ptr [bx + 1]
  053838  02F8: 2aed             sub ch, ch
  05383A  02FA: 894ee4           mov word ptr [bp - 0x1c], cx
  05383D  02FD: 51               push cx
  05383E  02FE: 50               push ax
  05383F  02FF: 9a22071f18       lcall 0x181f, 0x722
  053844  0304: 83c404           add sp, 4
  053847  0307: 8946f8           mov word ptr [bp - 8], ax
  05384A  030A: 8b1e4285         mov bx, word ptr [0x8542]
  05384E  030E: 8a471a           mov al, byte ptr [bx + 0x1a]
  053851  0311: 2ae4             sub ah, ah
  053853  0313: 8946e2           mov word ptr [bp - 0x1e], ax
  053856  0316: 8bf0             mov si, ax
  053858  0318: c1e604           shl si, 4
  05385B  031B: 8b5ef8           mov bx, word ptr [bp - 8]
  05385E  031E: 80b8e69402       cmp byte ptr [bx + si - 0x6b1a], 2
  053863  0323: 7303             jae 0x328
  053865  0325: e9c501           jmp 0x4ed
  053868  0328: 8bf0             mov si, ax
  05386A  032A: c1e604           shl si, 4
  05386D  032D: 8a80e694         mov al, byte ptr [bx + si - 0x6b1a]
  053871  0331: 48               dec ax
  053872  0332: 48               dec ax
  053873  0333: 8946fe           mov word ptr [bp - 2], ax
  053876  0336: c746e00000       mov word ptr [bp - 0x20], 0
  05387B  033B: eb28             jmp 0x365
  05387D  033D: 90               nop 
  05387E  033E: 8b46f0           mov ax, word ptr [bp - 0x10]
  053881  0341: 2b46ea           sub ax, word ptr [bp - 0x16]
  053884  0344: f7d0             not ax
  053886  0346: 40               inc ax
  053887  0347: 3d0700           cmp ax, 7
  05388A  034A: 7c5a             jl 0x3a6
  05388C  034C: 8bc1             mov ax, cx
  05388E  034E: 2b46e4           sub ax, word ptr [bp - 0x1c]
  053891  0351: 0bc0             or ax, ax
  053893  0353: 7f08             jg 0x35d
  053895  0355: 8bc1             mov ax, cx
  053897  0357: 2b46e4           sub ax, word ptr [bp - 0x1c]
  05389A  035A: f7d0             not ax
  05389C  035C: 40               inc ax
  05389D  035D: 3d0700           cmp ax, 7
  0538A0  0360: 7c44             jl 0x3a6
  0538A2  0362: ff46e0           inc word ptr [bp - 0x20]
  0538A5  0365: 8b46e0           mov ax, word ptr [bp - 0x20]
  0538A8  0368: 39069e53         cmp word ptr [0x539e], ax
  0538AC  036C: 7f03             jg 0x371
  0538AE  036E: e97c01           jmp 0x4ed
  0538B1  0371: 69d8ca00         imul bx, ax, 0xca
  0538B5  0375: 8a46e2           mov al, byte ptr [bp - 0x1e]
  0538B8  0378: 3887605d         cmp byte ptr [bx + 0x5d60], al
  0538BC  037C: 75e4             jne 0x362
  0538BE  037E: 8b46e0           mov ax, word ptr [bp - 0x20]
  0538C1  0381: 3906c68d         cmp word ptr [0x8dc6], ax
  0538C5  0385: 74db             je 0x362
  0538C7  0387: 69d8ca00         imul bx, ax, 0xca
  0538CB  038B: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  0538CF  038F: 2ae4             sub ah, ah
  0538D1  0391: 8946f0           mov word ptr [bp - 0x10], ax
  0538D4  0394: 8a8f475d         mov cl, byte ptr [bx + 0x5d47]
  0538D8  0398: 2aed             sub ch, ch
  0538DA  039A: 894eee           mov word ptr [bp - 0x12], cx
  0538DD  039D: 2b46ea           sub ax, word ptr [bp - 0x16]
  0538E0  03A0: 0bc0             or ax, ax
  0538E2  03A2: 7e9a             jle 0x33e
  0538E4  03A4: eba1             jmp 0x347
  0538E6  03A6: 51               push cx
  0538E7  03A7: ff76f0           push word ptr [bp - 0x10]
  0538EA  03AA: 9a22071f18       lcall 0x181f, 0x722
  0538EF  03AF: 83c404           add sp, 4
  0538F2  03B2: 3b46f8           cmp ax, word ptr [bp - 8]
  0538F5  03B5: 75ab             jne 0x362
  0538F7  03B7: ff76fe           push word ptr [bp - 2]
  0538FA  03BA: 6a00             push 0
  0538FC  03BC: 9ad4041f18       lcall 0x181f, 0x4d4
  053901  03C1: 83c404           add sp, 4
  053904  03C4: 0bc0             or ax, ax
  053906  03C6: 759a             jne 0x362
  053908  03C8: c706d61dffff     mov word ptr [0x1dd6], 0xffff
  05390E  03CE: 8b46f0           mov ax, word ptr [bp - 0x10]
  053911  03D1: a34ea1           mov word ptr [0xa14e], ax
  053914  03D4: 8b46ee           mov ax, word ptr [bp - 0x12]
  053917  03D7: a34ca1           mov word ptr [0xa14c], ax
  05391A  03DA: b80100           mov ax, 1
  05391D  03DD: a3d41d           mov word ptr [0x1dd4], ax
  053920  03E0: a3d21d           mov word ptr [0x1dd2], ax
  053923  03E3: 8946fa           mov word ptr [bp - 6], ax
  053926  03E6: 8b46ea           mov ax, word ptr [bp - 0x16]
  053929  03E9: 8b56e4           mov dx, word ptr [bp - 0x1c]
  05392C  03EC: bb6300           mov bx, 0x63
  05392F  03EF: 9af0051f1a       lcall 0x1a1f, 0x5f0
  053934  03F4: 0bc0             or ax, ax
  053936  03F6: 7c56             jl 0x44e
  053938  03F8: 3d0800           cmp ax, 8
  05393B  03FB: 7451             je 0x44e
  05393D  03FD: 8bd8             mov bx, ax
  05393F  03FF: 8a87be00         mov al, byte ptr [bx + 0xbe]
  053943  0403: 98               cwde 
  053944  0404: 0146e4           add word ptr [bp - 0x1c], ax
  053947  0407: 8a87b400         mov al, byte ptr [bx + 0xb4]
  05394B  040B: 98               cwde 
  05394C  040C: 0146ea           add word ptr [bp - 0x16], ax
  05394F  040F: 8b46f0           mov ax, word ptr [bp - 0x10]
  053952  0412: 3946ea           cmp word ptr [bp - 0x16], ax
  053955  0415: 7508             jne 0x41f
  053957  0417: 8b46ee           mov ax, word ptr [bp - 0x12]
  05395A  041A: 3946e4           cmp word ptr [bp - 0x1c], ax
  05395D  041D: 742f             je 0x44e
  05395F  041F: ff76e4           push word ptr [bp - 0x1c]
  053962  0422: ff76ea           push word ptr [bp - 0x16]
  053965  0425: 9abe061f18       lcall 0x181f, 0x6be
  05396A  042A: 83c404           add sp, 4
  05396D  042D: 0bc0             or ax, ax
  05396F  042F: 7d17             jge 0x448
  053971  0431: ff76e4           push word ptr [bp - 0x1c]
  053974  0434: ff76ea           push word ptr [bp - 0x16]
  053977  0437: 9a54071f18       lcall 0x181f, 0x754
  05397C  043C: 83c404           add sp, 4
  05397F  043F: a80a             test al, 0xa
  053981  0441: 7505             jne 0x448
  053983  0443: c746fa0000       mov word ptr [bp - 6], 0
  053988  0448: 837efa00         cmp word ptr [bp - 6], 0
  05398C  044C: 7598             jne 0x3e6
  05398E  044E: c706d41d0000     mov word ptr [0x1dd4], 0
  053994  0454: 837efa00         cmp word ptr [bp - 6], 0
  053998  0458: 7403             je 0x45d
  05399A  045A: e905ff           jmp 0x362
  05399D  045D: ff76e4           push word ptr [bp - 0x1c]
  0539A0  0460: ff76ea           push word ptr [bp - 0x16]
  0539A3  0463: 9ad2061f18       lcall 0x181f, 0x6d2
  0539A8  0468: 83c404           add sp, 4
  0539AB  046B: 0bc0             or ax, ax
  0539AD  046D: 7c08             jl 0x477
  0539AF  046F: 3b46e2           cmp ax, word ptr [bp - 0x1e]
  0539B2  0472: 7403             je 0x477
  0539B4  0474: e9ebfe           jmp 0x362
  0539B7  0477: ff76e2           push word ptr [bp - 0x1e]
  0539BA  047A: ff76e4           push word ptr [bp - 0x1c]
  0539BD  047D: ff76ea           push word ptr [bp - 0x16]
  0539C0  0480: 9ae6061f18       lcall 0x181f, 0x6e6
  0539C5  0485: 83c406           add sp, 6
  0539C8  0488: 0bc0             or ax, ax
  0539CA  048A: 7c08             jl 0x494
  0539CC  048C: 3b46e2           cmp ax, word ptr [bp - 0x1e]
  0539CF  048F: 7403             je 0x494
  0539D1  0491: e9cefe           jmp 0x362
  0539D4  0494: ff76e4           push word ptr [bp - 0x1c]
  0539D7  0497: ff76ea           push word ptr [bp - 0x16]
  0539DA  049A: 9a8c071f18       lcall 0x181f, 0x78c
  0539DF  049F: 83c404           add sp, 4
  0539E2  04A2: 8bd8             mov bx, ax
  0539E4  04A4: c1e304           shl bx, 4
  0539E7  04A7: 8a87782f         mov al, byte ptr [bx + 0x2f78]
  0539EB  04AB: 2ae4             sub ah, ah
  0539ED  04AD: 40               inc ax
  0539EE  04AE: 40               inc ax
  0539EF  04AF: 8b1e4285         mov bx, word ptr [0x8542]
  0539F3  04B3: 3a878c00         cmp al, byte ptr [bx + 0x8c]
  0539F7  04B7: 7f34             jg 0x4ed
  0539F9  04B9: 6a00             push 0
  0539FB  04BB: ff76e2           push word ptr [bp - 0x1e]
  0539FE  04BE: ff76e4           push word ptr [bp - 0x1c]
  053A01  04C1: ff76ea           push word ptr [bp - 0x16]
  053A04  04C4: a04e52           mov al, byte ptr [0x524e]
  053A07  04C7: 2ae4             sub ah, ah
  053A09  04C9: 50               push ax
  053A0A  04CA: 9a200a1f19       lcall 0x191f, 0xa20
  053A0F  04CF: 83c40a           add sp, 0xa
  053A12  04D2: 6bd81c           imul bx, ax, 0x1c
  053A15  04D5: c6875a3163       mov byte ptr [bx + 0x315a], 0x63
  053A1A  04DA: 50               push ax
  053A1B  04DB: 9a16021f19       lcall 0x191f, 0x216
  053A20  04E0: 83c402           add sp, 2
  053A23  04E3: 9a060a1f19       lcall 0x191f, 0xa06
  053A28  04E8: c746fc0100       mov word ptr [bp - 4], 1
  053A2D  04ED: 8b46fc           mov ax, word ptr [bp - 4]
  053A30  04F0: 5e               pop si
  053A31  04F1: c9               leave 
  053A32  04F2: cb               retf 

; ---- func_053A34  size=107  insns=39  prologue=ENTER 0x0002,0  terminal=RETF ----
  053A34  04F4: c8020000         enter 2, 0
  053A38  04F8: 50               push ax
  053A39  04F9: c746fe0100       mov word ptr [bp - 2], 1
  053A3E  04FE: 0bc0             or ax, ax
  053A40  0500: 7c4a             jl 0x54c
  053A42  0502: 50               push ax
  053A43  0503: 9afc091f18       lcall 0x181f, 0x9fc
  053A48  0508: 83c402           add sp, 2
  053A4B  050B: 0bc0             or ax, ax
  053A4D  050D: 753d             jne 0x54c
  053A4F  050F: 8946fe           mov word ptr [bp - 2], ax
  053A52  0512: ff76fc           push word ptr [bp - 4]
  053A55  0515: 9a8c0b1f18       lcall 0x181f, 0xb8c
  053A5A  051A: 83c402           add sp, 2
  053A5D  051D: 0bc0             or ax, ax
  053A5F  051F: 740d             je 0x52e
  053A61  0521: 8a46fc           mov al, byte ptr [bp - 4]
  053A64  0524: 8b1e4285         mov bx, word ptr [0x8542]
  053A68  0528: 88879400         mov byte ptr [bx + 0x94], al
  053A6C  052C: eb1e             jmp 0x54c
  053A6E  052E: 8b5efc           mov bx, word ptr [bp - 4]
  053A71  0531: 8bc3             mov ax, bx
  053A73  0533: d1e3             shl bx, 1
  053A75  0535: 03d8             add bx, ax
  053A77  0537: c1e302           shl bx, 2
  053A7A  053A: 8a87858f         mov al, byte ptr [bx - 0x707b]
  053A7E  053E: 98               cwde 
  053A7F  053F: 0e               push cs
  053A80  0540: e80b28           call 0x2d4e
  053A83  0543: 0bc0             or ax, ax
  053A85  0545: 7405             je 0x54c
  053A87  0547: c746fe0100       mov word ptr [bp - 2], 1
  053A8C  054C: 837efe00         cmp word ptr [bp - 2], 0
  053A90  0550: 7508             jne 0x55a
  053A92  0552: 8b1e4285         mov bx, word ptr [0x8542]
  053A96  0556: 80671c7f         and byte ptr [bx + 0x1c], 0x7f
  053A9A  055A: 8b46fe           mov ax, word ptr [bp - 2]
  053A9D  055D: c9               leave 
  053A9E  055E: cb               retf 

; ---- func_053AA0  size=115  insns=40  prologue=ENTER 0x0008,0  terminal=RETF ----
  053AA0  0560: c8080000         enter 8, 0
  053AA4  0564: 56               push si
  053AA5  0565: c746f80000       mov word ptr [bp - 8], 0
  053AAA  056A: 8b5e06           mov bx, word ptr [bp + 6]
  053AAD  056D: c1e302           shl bx, 2
  053AB0  0570: 8a876608         mov al, byte ptr [bx + 0x866]
  053AB4  0574: 2ae4             sub ah, ah
  053AB6  0576: 8946fa           mov word ptr [bp - 6], ax
  053AB9  0579: 8a876408         mov al, byte ptr [bx + 0x864]
  053ABD  057D: 50               push ax
  053ABE  057E: 9ab00a1f18       lcall 0x181f, 0xab0
  053AC3  0583: 83c402           add sp, 2
  053AC6  0586: 8946fc           mov word ptr [bp - 4], ax
  053AC9  0589: 8b5efa           mov bx, word ptr [bp - 6]
  053ACC  058C: d1e3             shl bx, 1
  053ACE  058E: 83bfc88d03       cmp word ptr [bx - 0x7238], 3
  053AD3  0593: 7205             jb 0x59a
  053AD5  0595: c746f80200       mov word ptr [bp - 8], 2
  053ADA  059A: 8b5efa           mov bx, word ptr [bp - 6]
  053ADD  059D: d1e3             shl bx, 1
  053ADF  059F: 83bfc88d08       cmp word ptr [bx - 0x7238], 8
  053AE4  05A4: 7205             jb 0x5ab
  053AE6  05A6: c746f80300       mov word ptr [bp - 8], 3
  053AEB  05AB: 8b76fa           mov si, word ptr [bp - 6]
  053AEE  05AE: d1e6             shl si, 1
  053AF0  05B0: 8b1e4285         mov bx, word ptr [0x8542]
  053AF4  05B4: 83b89a0064       cmp word ptr [bx + si + 0x9a], 0x64
  053AF9  05B9: 7c05             jl 0x5c0
  053AFB  05BB: c746f80300       mov word ptr [bp - 8], 3
  053B00  05C0: 8b46f8           mov ax, word ptr [bp - 8]
  053B03  05C3: 3946fc           cmp word ptr [bp - 4], ax
  053B06  05C6: 7d06             jge 0x5ce
  053B08  05C8: b80100           mov ax, 1
  053B0B  05CB: 5e               pop si
  053B0C  05CC: c9               leave 
  053B0D  05CD: cb               retf 
  053B0E  05CE: 2bc0             sub ax, ax
  053B10  05D0: 5e               pop si
  053B11  05D1: c9               leave 
  053B12  05D2: cb               retf 

; ---- func_053B14  size=18  insns=8  prologue=push bp;mov bp,sp  terminal=RETF ----
  053B14  05D4: 55               push bp
  053B15  05D5: 8bec             mov bp, sp
  053B17  05D7: 8b1e4285         mov bx, word ptr [0x8542]
  053B1B  05DB: 80671c7f         and byte ptr [bx + 0x1c], 0x7f
  053B1F  05DF: 8a4606           mov al, byte ptr [bp + 6]
  053B22  05E2: 041f             add al, 0x1f
  053B24  05E4: c9               leave 
  053B25  05E5: cb               retf 

; ---- func_053B26  size=87  insns=31  prologue=push bp;mov bp,sp  terminal=RETF ----
  053B26  05E6: 55               push bp
  053B27  05E7: 8bec             mov bp, sp
  053B29  05E9: 56               push si
  053B2A  05EA: 9a3a0d1f18       lcall 0x181f, 0xd3a
  053B2F  05EF: 8b7606           mov si, word ptr [bp + 6]
  053B32  05F2: d1e6             shl si, 1
  053B34  05F4: 8b1e4285         mov bx, word ptr [0x8542]
  053B38  05F8: 39809a00         cmp word ptr [bx + si + 0x9a], ax
  053B3C  05FC: 7c05             jl 0x603
  053B3E  05FE: c746080000       mov word ptr [bp + 8], 0
  053B43  0603: 8b5e06           mov bx, word ptr [bp + 6]
  053B46  0606: d1e3             shl bx, 1
  053B48  0608: 83bfc88d00       cmp word ptr [bx - 0x7238], 0
  053B4D  060D: 7405             je 0x614
  053B4F  060F: c746080000       mov word ptr [bp + 8], 0
  053B54  0614: 837e0800         cmp word ptr [bp + 8], 0
  053B58  0618: 740e             je 0x628
  053B5A  061A: 8a4606           mov al, byte ptr [bp + 6]
  053B5D  061D: 8b1e4285         mov bx, word ptr [0x8542]
  053B61  0621: 88878d00         mov byte ptr [bx + 0x8d], al
  053B65  0625: 5e               pop si
  053B66  0626: c9               leave 
  053B67  0627: cb               retf 
  053B68  0628: 8a4606           mov al, byte ptr [bp + 6]
  053B6B  062B: 8b1e4285         mov bx, word ptr [0x8542]
  053B6F  062F: 38878d00         cmp byte ptr [bx + 0x8d], al
  053B73  0633: 7505             jne 0x63a
  053B75  0635: c6878d00ff       mov byte ptr [bx + 0x8d], 0xff
  053B7A  063A: 5e               pop si
  053B7B  063B: c9               leave 
  053B7C  063C: cb               retf 

; ---- func_053B7E  size=10025  insns=3186  prologue=ENTER 0x01C0,0  terminal=page-end ----
  053B7E  063E: c8c00100         enter 0x1c0, 0
  053B82  0642: 57               push di
  053B83  0643: 56               push si
  053B84  0644: 2bc0             sub ax, ax
  053B86  0646: 8946de           mov word ptr [bp - 0x22], ax
  053B89  0649: 898676ff         mov word ptr [bp - 0x8a], ax
  053B8D  064D: 894680           mov word ptr [bp - 0x80], ax
  053B90  0650: 898670ff         mov word ptr [bp - 0x90], ax
  053B94  0654: ff7606           push word ptr [bp + 6]
  053B97  0657: 9ae6091f18       lcall 0x181f, 0x9e6
  053B9C  065C: 83c402           add sp, 2
  053B9F  065F: 8b1e4285         mov bx, word ptr [0x8542]
  053BA3  0663: 803f2e           cmp byte ptr [bx], 0x2e
  053BA6  0666: 750e             jne 0x676
  053BA8  0668: 807f0114         cmp byte ptr [bx + 1], 0x14
  053BAC  066C: 7508             jne 0x676
  053BAE  066E: c746fe0100       mov word ptr [bp - 2], 1
  053BB3  0673: eb06             jmp 0x67b
  053BB5  0675: 90               nop 
  053BB6  0676: c746fe0000       mov word ptr [bp - 2], 0
  053BBB  067B: 6a02             push 2
  053BBD  067D: 6a00             push 0
  053BBF  067F: 8bc3             mov ax, bx
  053BC1  0681: 058a00           add ax, 0x8a
  053BC4  0684: 50               push ax
  053BC5  0685: 9aae0d1d0d       lcall 0xd1d, 0xdae
  053BCA  068A: 83c406           add sp, 6
  053BCD  068D: 9a720c1f18       lcall 0x181f, 0xc72
  053BD2  0692: 9a220c1f18       lcall 0x181f, 0xc22
  053BD7  0697: 9a3a0d1f18       lcall 0x181f, 0xd3a
  053BDC  069C: 8946cc           mov word ptr [bp - 0x34], ax
  053BDF  069F: 9a5e0c1f18       lcall 0x181f, 0xc5e
  053BE4  06A4: 8bd8             mov bx, ax
  053BE6  06A6: 895e92           mov word ptr [bp - 0x6e], bx
  053BE9  06A9: 8a872903         mov al, byte ptr [bx + 0x329]
  053BED  06AD: 2ae4             sub ah, ah
  053BEF  06AF: 898660ff         mov word ptr [bp - 0xa0], ax
  053BF3  06B3: 8b1e4285         mov bx, word ptr [0x8542]
  053BF7  06B7: 80bf8c007f       cmp byte ptr [bx + 0x8c], 0x7f
  053BFC  06BC: 7d04             jge 0x6c2
  053BFE  06BE: fe878c00         inc byte ptr [bx + 0x8c]
  053C02  06C2: 8b1e4285         mov bx, word ptr [0x8542]
  053C06  06C6: 80bf8f007f       cmp byte ptr [bx + 0x8f], 0x7f
  053C0B  06CB: 7d04             jge 0x6d1
  053C0D  06CD: fe878f00         inc byte ptr [bx + 0x8f]
  053C11  06D1: 8b1e4285         mov bx, word ptr [0x8542]
  053C15  06D5: 83bfb60014       cmp word ptr [bx + 0xb6], 0x14
  053C1A  06DA: 7c06             jl 0x6e2
  053C1C  06DC: b80100           mov ax, 1
  053C1F  06DF: eb03             jmp 0x6e4
  053C21  06E1: 90               nop 
  053C22  06E2: 2bc0             sub ax, ax
  053C24  06E4: 8946ec           mov word ptr [bp - 0x14], ax
  053C27  06E7: 8a07             mov al, byte ptr [bx]
  053C29  06E9: 2ae4             sub ah, ah
  053C2B  06EB: 89865cff         mov word ptr [bp - 0xa4], ax
  053C2F  06EF: 8a4f01           mov cl, byte ptr [bx + 1]
  053C32  06F2: 2aed             sub ch, ch
  053C34  06F4: 898e54ff         mov word ptr [bp - 0xac], cx
  053C38  06F8: 8a571a           mov dl, byte ptr [bx + 0x1a]
  053C3B  06FB: 2af6             sub dh, dh
  053C3D  06FD: 899652fe         mov word ptr [bp - 0x1ae], dx
  053C41  0701: 51               push cx
  053C42  0702: 50               push ax
  053C43  0703: 9a22071f18       lcall 0x181f, 0x722
  053C48  0708: 83c404           add sp, 4
  053C4B  070B: 8bf0             mov si, ax
  053C4D  070D: 897696           mov word ptr [bp - 0x6a], si
  053C50  0710: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  053C54  0714: c1e304           shl bx, 4
  053C57  0717: 8a807098         mov al, byte ptr [bx + si - 0x6790]
  053C5B  071B: 2ae4             sub ah, ah
  053C5D  071D: 8946d8           mov word ptr [bp - 0x28], ax
  053C60  0720: 2bc0             sub ax, ax
  053C62  0722: 89468c           mov word ptr [bp - 0x74], ax
  053C65  0725: 898668ff         mov word ptr [bp - 0x98], ax
  053C69  0729: 8946e0           mov word ptr [bp - 0x20], ax
  053C6C  072C: 9a860c1f18       lcall 0x181f, 0xc86
  053C71  0731: 898652ff         mov word ptr [bp - 0xae], ax
  053C75  0735: b96400           mov cx, 0x64
  053C78  0738: 2bc8             sub cx, ax
  053C7A  073A: 8b1e4285         mov bx, word ptr [0x8542]
  053C7E  073E: 8a471f           mov al, byte ptr [bx + 0x1f]
  053C81  0741: 98               cwde 
  053C82  0742: f7e9             imul cx
  053C84  0744: 053200           add ax, 0x32
  053C87  0747: b96400           mov cx, 0x64
  053C8A  074A: 99               cdq 
  053C8B  074B: f7f9             idiv cx
  053C8D  074D: 894686           mov word ptr [bp - 0x7a], ax
  053C90  0750: f606825301       test byte ptr [0x5382], 1
  053C95  0755: 7405             je 0x75c
  053C97  0757: c746860000       mov word ptr [bp - 0x7a], 0
  053C9C  075C: ff7696           push word ptr [bp - 0x6a]
  053C9F  075F: 6aff             push -1
  053CA1  0761: ffb654ff         push word ptr [bp - 0xac]
  053CA5  0765: ffb65cff         push word ptr [bp - 0xa4]
  053CA9  0769: 9a840d1f18       lcall 0x181f, 0xd84
  053CAE  076E: 83c408           add sp, 8
  053CB1  0771: 89861aff         mov word ptr [bp - 0xe6], ax
  053CB5  0775: a1b88d           mov ax, word ptr [0x8db8]
  053CB8  0778: 898650ff         mov word ptr [bp - 0xb0], ax
  053CBC  077C: 83be1aff00       cmp word ptr [bp - 0xe6], 0
  053CC1  0781: 7c14             jl 0x797
  053CC3  0783: ffb652fe         push word ptr [bp - 0x1ae]
  053CC7  0787: ff36528d         push word ptr [0x8d52]
  053CCB  078B: 9a0c031f18       lcall 0x181f, 0x30c
  053CD0  0790: 83c404           add sp, 4
  053CD3  0793: 89864cfe         mov word ptr [bp - 0x1b4], ax
  053CD7  0797: c786d2fefbff     mov word ptr [bp - 0x12e], 0xfffb
  053CDD  079D: e9ac01           jmp 0x94c
  053CE0  07A0: 8b865eff         mov ax, word ptr [bp - 0xa2]
  053CE4  07A4: f7d0             not ax
  053CE6  07A6: 40               inc ax
  053CE7  07A7: 3d0100           cmp ax, 1
  053CEA  07AA: 7f70             jg 0x81c
  053CEC  07AC: 83bed2fe00       cmp word ptr [bp - 0x12e], 0
  053CF1  07B1: 7e07             jle 0x7ba
  053CF3  07B3: 8b86d2fe         mov ax, word ptr [bp - 0x12e]
  053CF7  07B7: eb08             jmp 0x7c1
  053CF9  07B9: 90               nop 
  053CFA  07BA: 8b86d2fe         mov ax, word ptr [bp - 0x12e]
  053CFE  07BE: f7d0             not ax
  053D00  07C0: 40               inc ax
  053D01  07C1: 3d0100           cmp ax, 1
  053D04  07C4: 7f56             jg 0x81c
  053D06  07C6: ff46e0           inc word ptr [bp - 0x20]
  053D09  07C9: eb51             jmp 0x81c
  053D0B  07CB: 90               nop 
  053D0C  07CC: ffb652fe         push word ptr [bp - 0x1ae]
  053D10  07D0: 6b9ec4fe1c       imul bx, word ptr [bp - 0x13c], 0x1c
  053D15  07D5: 8a874731         mov al, byte ptr [bx + 0x3147]
  053D19  07D9: 250f00           and ax, 0xf
  053D1C  07DC: 2d0400           sub ax, 4
  053D1F  07DF: 50               push ax
  053D20  07E0: 9a0c031f18       lcall 0x181f, 0x30c
  053D25  07E5: 83c404           add sp, 4
  053D28  07E8: 89864cfe         mov word ptr [bp - 0x1b4], ax
  053D2C  07EC: 3d1900           cmp ax, 0x19
  053D2F  07EF: 7d06             jge 0x7f7
  053D31  07F1: c7866aff0000     mov word ptr [bp - 0x96], 0
  053D37  07F7: 6b9ec4fe1c       imul bx, word ptr [bp - 0x13c], 0x1c
  053D3C  07FC: 8a874a31         mov al, byte ptr [bx + 0x314a]
  053D40  0800: 98               cwde 
  053D41  0801: 8bd8             mov bx, ax
  053D43  0803: c1e303           shl bx, 3
  053D46  0806: 03d8             add bx, ax
  053D48  0808: 039e52fe         add bx, word ptr [bp - 0x1ae]
  053D4C  080C: d1e3             shl bx, 1
  053D4E  080E: 81bff6548000     cmp word ptr [bx + 0x54f6], 0x80
  053D54  0814: 7d06             jge 0x81c
  053D56  0816: c7866aff0000     mov word ptr [bp - 0x96], 0
  053D5C  081C: ff76da           push word ptr [bp - 0x26]
  053D5F  081F: ff76f0           push word ptr [bp - 0x10]
  053D62  0822: 9abe061f18       lcall 0x181f, 0x6be
  053D67  0827: 83c404           add sp, 4
  053D6A  082A: 0bc0             or ax, ax
  053D6C  082C: 7c04             jl 0x832
  053D6E  082E: d1be6aff         sar word ptr [bp - 0x96], 1
  053D72  0832: ffb6d2fe         push word ptr [bp - 0x12e]
  053D76  0836: ffb65eff         push word ptr [bp - 0xa2]
  053D7A  083A: 9a70031f18       lcall 0x181f, 0x370
  053D7F  083F: 83c404           add sp, 4
  053D82  0842: 2d0800           sub ax, 8
  053D85  0845: f7d8             neg ax
  053D87  0847: f7ae6aff         imul word ptr [bp - 0x96]
  053D8B  084B: c1f803           sar ax, 3
  053D8E  084E: 89866aff         mov word ptr [bp - 0x96], ax
  053D92  0852: 018668ff         add word ptr [bp - 0x98], ax
  053D96  0856: 8b86c4fe         mov ax, word ptr [bp - 0x13c]
  053D9A  085A: 9ae4021f18       lcall 0x181f, 0x2e4
  053D9F  085F: 8986c4fe         mov word ptr [bp - 0x13c], ax
  053DA3  0863: eb55             jmp 0x8ba
  053DA5  0865: 90               nop 
  053DA6  0866: ff865eff         inc word ptr [bp - 0xa2]
  053DAA  086A: 83be5eff05       cmp word ptr [bp - 0xa2], 5
  053DAF  086F: 7e03             jle 0x874
  053DB1  0871: e9d400           jmp 0x948
  053DB4  0874: 8b86d2fe         mov ax, word ptr [bp - 0x12e]
  053DB8  0878: 038654ff         add ax, word ptr [bp - 0xac]
  053DBC  087C: 8946da           mov word ptr [bp - 0x26], ax
  053DBF  087F: 50               push ax
  053DC0  0880: 8b865eff         mov ax, word ptr [bp - 0xa2]
  053DC4  0884: 03865cff         add ax, word ptr [bp - 0xa4]
  053DC8  0888: 8946f0           mov word ptr [bp - 0x10], ax
  053DCB  088B: 50               push ax
  053DCC  088C: 9a02031f18       lcall 0x181f, 0x302
  053DD1  0891: 83c404           add sp, 4
  053DD4  0894: 0bc0             or ax, ax
  053DD6  0896: 74ce             je 0x866
  053DD8  0898: 8b46f0           mov ax, word ptr [bp - 0x10]
  053DDB  089B: 8b56da           mov dx, word ptr [bp - 0x26]
  053DDE  089E: 9ae0071f18       lcall 0x181f, 0x7e0
  053DE3  08A3: 8986c4fe         mov word ptr [bp - 0x13c], ax
  053DE7  08A7: 0bc0             or ax, ax
  053DE9  08A9: 7cbb             jl 0x866
  053DEB  08AB: 6bd81c           imul bx, ax, 0x1c
  053DEE  08AE: 8a874731         mov al, byte ptr [bx + 0x3147]
  053DF2  08B2: 240f             and al, 0xf
  053DF4  08B4: 3a8652fe         cmp al, byte ptr [bp - 0x1ae]
  053DF8  08B8: 74ac             je 0x866
  053DFA  08BA: 83bec4fe00       cmp word ptr [bp - 0x13c], 0
  053DFF  08BF: 7ca5             jl 0x866
  053E01  08C1: 6a01             push 1
  053E03  08C3: ffb6c4fe         push word ptr [bp - 0x13c]
  053E07  08C7: 9ac8091f18       lcall 0x181f, 0x9c8
  053E0C  08CC: 83c404           add sp, 4
  053E0F  08CF: 89866aff         mov word ptr [bp - 0x96], ax
  053E13  08D3: 6b9ec4fe1c       imul bx, word ptr [bp - 0x13c], 0x1c
  053E18  08D8: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  053E1D  08DD: 720a             jb 0x8e9
  053E1F  08DF: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  053E24  08E4: 7703             ja 0x8e9
  053E26  08E6: e96dff           jmp 0x856
  053E29  08E9: 6b9ec4fe1c       imul bx, word ptr [bp - 0x13c], 0x1c
  053E2E  08EE: 8a874731         mov al, byte ptr [bx + 0x3147]
  053E32  08F2: 240f             and al, 0xf
  053E34  08F4: 3c04             cmp al, 4
  053E36  08F6: 7203             jb 0x8fb
  053E38  08F8: e9d1fe           jmp 0x7cc
  053E3B  08FB: 83be6aff01       cmp word ptr [bp - 0x96], 1
  053E40  0900: 7f06             jg 0x908
  053E42  0902: c7866aff0000     mov word ptr [bp - 0x96], 0
  053E48  0908: 6b9ec4fe1c       imul bx, word ptr [bp - 0x13c], 0x1c
  053E4D  090D: 8a874731         mov al, byte ptr [bx + 0x3147]
  053E51  0911: 240f             and al, 0xf
  053E53  0913: 3c04             cmp al, 4
  053E55  0915: 7315             jae 0x92c
  053E57  0917: 2ae4             sub ah, ah
  053E59  0919: 6bd834           imul bx, ax, 0x34
  053E5C  091C: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  053E60  0920: 750a             jne 0x92c
  053E62  0922: 8b866aff         mov ax, word ptr [bp - 0x96]
  053E66  0926: d1f8             sar ax, 1
  053E68  0928: 01866aff         add word ptr [bp - 0x96], ax
  053E6C  092C: 83be6aff00       cmp word ptr [bp - 0x96], 0
  053E71  0931: 7503             jne 0x936
  053E73  0933: e9e6fe           jmp 0x81c
  053E76  0936: 83be5eff00       cmp word ptr [bp - 0xa2], 0
  053E7B  093B: 7f03             jg 0x940
  053E7D  093D: e960fe           jmp 0x7a0
  053E80  0940: 8b865eff         mov ax, word ptr [bp - 0xa2]
  053E84  0944: e960fe           jmp 0x7a7
  053E87  0947: 90               nop 
  053E88  0948: ff86d2fe         inc word ptr [bp - 0x12e]
  053E8C  094C: 83bed2fe05       cmp word ptr [bp - 0x12e], 5
  053E91  0951: 7f09             jg 0x95c
  053E93  0953: c7865efffbff     mov word ptr [bp - 0xa2], 0xfffb
  053E99  0959: e90eff           jmp 0x86a
  053E9C  095C: 8b8668ff         mov ax, word ptr [bp - 0x98]
  053EA0  0960: 3d1000           cmp ax, 0x10
  053EA3  0963: 7e03             jle 0x968
  053EA5  0965: b81000           mov ax, 0x10
  053EA8  0968: 8946e6           mov word ptr [bp - 0x1a], ax
  053EAB  096B: 6a00             push 0
  053EAD  096D: 9ab00a1f18       lcall 0x181f, 0xab0
  053EB2  0972: 83c402           add sp, 2
  053EB5  0975: 8bc8             mov cx, ax
  053EB7  0977: 41               inc cx
  053EB8  0978: 8b8668ff         mov ax, word ptr [bp - 0x98]
  053EBC  097C: 99               cdq 
  053EBD  097D: f7f9             idiv cx
  053EBF  097F: 898668ff         mov word ptr [bp - 0x98], ax
  053EC3  0983: 3b46e6           cmp ax, word ptr [bp - 0x1a]
  053EC6  0986: 7d03             jge 0x98b
  053EC8  0988: 8b46e6           mov ax, word ptr [bp - 0x1a]
  053ECB  098B: 898668ff         mov word ptr [bp - 0x98], ax
  053ECF  098F: c1f803           sar ax, 3
  053ED2  0992: 8bc8             mov cx, ax
  053ED4  0994: 8b1e4285         mov bx, word ptr [0x8542]
  053ED8  0998: 88471e           mov byte ptr [bx + 0x1e], al
  053EDB  099B: 8a471f           mov al, byte ptr [bx + 0x1f]
  053EDE  099E: 98               cwde 
  053EDF  099F: 0306728d         add ax, word ptr [0x8d72]
  053EE3  09A3: 8bd0             mov dx, ax
  053EE5  09A5: d1f8             sar ax, 1
  053EE7  09A7: 8bd8             mov bx, ax
  053EE9  09A9: 8bc2             mov ax, dx
  053EEB  09AB: 48               dec ax
  053EEC  09AC: 99               cdq 
  053EED  09AD: 2bc2             sub ax, dx
  053EEF  09AF: d1f8             sar ax, 1
  053EF1  09B1: 3bc1             cmp ax, cx
  053EF3  09B3: 7d02             jge 0x9b7
  053EF5  09B5: 8bc1             mov ax, cx
  053EF7  09B7: 3bc3             cmp ax, bx
  053EF9  09B9: 7e02             jle 0x9bd
  053EFB  09BB: 8bc3             mov ax, bx
  053EFD  09BD: 89468c           mov word ptr [bp - 0x74], ax
  053F00  09C0: f606825301       test byte ptr [0x5382], 1
  053F05  09C5: 7404             je 0x9cb
  053F07  09C7: 40               inc ax
  053F08  09C8: 89468c           mov word ptr [bp - 0x74], ax
  053F0B  09CB: 837ee000         cmp word ptr [bp - 0x20], 0
  053F0F  09CF: 741f             je 0x9f0
  053F11  09D1: 8b1e4285         mov bx, word ptr [0x8542]
  053F15  09D5: 8a471f           mov al, byte ptr [bx + 0x1f]
  053F18  09D8: 98               cwde 
  053F19  09D9: 0306728d         add ax, word ptr [0x8d72]
  053F1D  09DD: 3d0100           cmp ax, 1
  053F20  09E0: 7e0e             jle 0x9f0
  053F22  09E2: 8b468c           mov ax, word ptr [bp - 0x74]
  053F25  09E5: 3d0100           cmp ax, 1
  053F28  09E8: 7d03             jge 0x9ed
  053F2A  09EA: b80100           mov ax, 1
  053F2D  09ED: 89468c           mov word ptr [bp - 0x74], ax
  053F30  09F0: 8a468c           mov al, byte ptr [bp - 0x74]
  053F33  09F3: 8b1e4285         mov bx, word ptr [0x8542]
  053F37  09F7: 88878e00         mov byte ptr [bx + 0x8e], al
  053F3B  09FB: 8b865cff         mov ax, word ptr [bp - 0xa4]
  053F3F  09FF: 8b9654ff         mov dx, word ptr [bp - 0xac]
  053F43  0A03: 9ae0071f18       lcall 0x181f, 0x7e0
  053F48  0A08: eb52             jmp 0xa5c
  053F4A  0A0A: 6bd81c           imul bx, ax, 0x1c
  053F4D  0A0D: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  053F52  0A12: 7207             jb 0xa1b
  053F54  0A14: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  053F59  0A19: 7638             jbe 0xa53
  053F5B  0A1B: 6bd81c           imul bx, ax, 0x1c
  053F5E  0A1E: 80bf4a3100       cmp byte ptr [bx + 0x314a], 0
  053F63  0A23: 7d07             jge 0xa2c
  053F65  0A25: a0c68d           mov al, byte ptr [0x8dc6]
  053F68  0A28: 88874a31         mov byte ptr [bx + 0x314a], al
  053F6C  0A2C: 6b9ec4fe1c       imul bx, word ptr [bp - 0x13c], 0x1c
  053F71  0A31: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  053F75  0A35: 2aff             sub bh, bh
  053F77  0A37: 8bc3             mov ax, bx
  053F79  0A39: d1e3             shl bx, 1
  053F7B  0A3B: 03d8             add bx, ax
  053F7D  0A3D: d1e3             shl bx, 1
  053F7F  0A3F: 03d8             add bx, ax
  053F81  0A41: d1e3             shl bx, 1
  053F83  0A43: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  053F88  0A48: 7609             jbe 0xa53
  053F8A  0A4A: 837e8c00         cmp word ptr [bp - 0x74], 0
  053F8E  0A4E: 7403             je 0xa53
  053F90  0A50: ff4e8c           dec word ptr [bp - 0x74]
  053F93  0A53: 8b86c4fe         mov ax, word ptr [bp - 0x13c]
  053F97  0A57: 9ae4021f18       lcall 0x181f, 0x2e4
  053F9C  0A5C: 8986c4fe         mov word ptr [bp - 0x13c], ax
  053FA0  0A60: 0bc0             or ax, ax
  053FA2  0A62: 7da6             jge 0xa0a
  053FA4  0A64: c786c4fe0000     mov word ptr [bp - 0x13c], 0
  053FAA  0A6A: eb55             jmp 0xac1
  053FAC  0A6C: 6bd81c           imul bx, ax, 0x1c
  053FAF  0A6F: 8a874731         mov al, byte ptr [bx + 0x3147]
  053FB3  0A73: 240f             and al, 0xf
  053FB5  0A75: 3a8652fe         cmp al, byte ptr [bp - 0x1ae]
  053FB9  0A79: 7542             jne 0xabd
  053FBB  0A7B: a0c68d           mov al, byte ptr [0x8dc6]
  053FBE  0A7E: 6b9ec4fe1c       imul bx, word ptr [bp - 0x13c], 0x1c
  053FC3  0A83: 38874a31         cmp byte ptr [bx + 0x314a], al
  053FC7  0A87: 7534             jne 0xabd
  053FC9  0A89: 6b9ec4fe1c       imul bx, word ptr [bp - 0x13c], 0x1c
  053FCE  0A8E: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  053FD3  0A93: 7207             jb 0xa9c
  053FD5  0A95: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  053FDA  0A9A: 7621             jbe 0xabd
  053FDC  0A9C: 6b9ec4fe1c       imul bx, word ptr [bp - 0x13c], 0x1c
  053FE1  0AA1: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  053FE5  0AA5: 2aff             sub bh, bh
  053FE7  0AA7: 8bc3             mov ax, bx
  053FE9  0AA9: d1e3             shl bx, 1
  053FEB  0AAB: 03d8             add bx, ax
  053FED  0AAD: d1e3             shl bx, 1
  053FEF  0AAF: 03d8             add bx, ax
  053FF1  0AB1: d1e3             shl bx, 1
  053FF3  0AB3: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  053FF8  0AB8: 7603             jbe 0xabd
  053FFA  0ABA: ff4680           inc word ptr [bp - 0x80]
  053FFD  0ABD: ff86c4fe         inc word ptr [bp - 0x13c]
  054001  0AC1: 8b86c4fe         mov ax, word ptr [bp - 0x13c]
  054005  0AC5: 39069c53         cmp word ptr [0x539c], ax
  054009  0AC9: 7fa1             jg 0xa6c
  05400B  0ACB: 8b1e4285         mov bx, word ptr [0x8542]
  05400F  0ACF: 8a878e00         mov al, byte ptr [bx + 0x8e]
  054013  0AD3: 98               cwde 
  054014  0AD4: 2b468c           sub ax, word ptr [bp - 0x74]
  054017  0AD7: f7d8             neg ax
  054019  0AD9: 014680           add word ptr [bp - 0x80], ax
  05401C  0ADC: 2bc0             sub ax, ax
  05401E  0ADE: 8986befe         mov word ptr [bp - 0x142], ax
  054022  0AE2: 8986c0fe         mov word ptr [bp - 0x140], ax
  054026  0AE6: 8946e8           mov word ptr [bp - 0x18], ax
  054029  0AE9: 898648fe         mov word ptr [bp - 0x1b8], ax
  05402D  0AED: 898658ff         mov word ptr [bp - 0xa8], ax
  054031  0AF1: 8986cefe         mov word ptr [bp - 0x132], ax
  054035  0AF5: 894694           mov word ptr [bp - 0x6c], ax
  054038  0AF8: 8946f4           mov word ptr [bp - 0xc], ax
  05403B  0AFB: 8946f6           mov word ptr [bp - 0xa], ax
  05403E  0AFE: 8946dc           mov word ptr [bp - 0x24], ax
  054041  0B01: 8986c2fe         mov word ptr [bp - 0x13e], ax
  054045  0B05: 898656ff         mov word ptr [bp - 0xaa], ax
  054049  0B09: e9e000           jmp 0xbec
  05404C  0B0C: ffb654ff         push word ptr [bp - 0xac]
  054050  0B10: ffb65cff         push word ptr [bp - 0xa4]
  054054  0B14: 9a8c071f18       lcall 0x181f, 0x78c
  054059  0B19: 83c404           add sp, 4
  05405C  0B1C: 898618ff         mov word ptr [bp - 0xe8], ax
  054060  0B20: 3d1900           cmp ax, 0x19
  054063  0B23: 7405             je 0xb2a
  054065  0B25: 3d1a00           cmp ax, 0x1a
  054068  0B28: 750e             jne 0xb38
  05406A  0B2A: ff86befe         inc word ptr [bp - 0x142]
  05406E  0B2E: ff46e8           inc word ptr [bp - 0x18]
  054071  0B31: ff86c0fe         inc word ptr [bp - 0x140]
  054075  0B35: ff46f4           inc word ptr [bp - 0xc]
  054078  0B38: 3d0800           cmp ax, 8
  05407B  0B3B: 7c05             jl 0xb42
  05407D  0B3D: 3d1000           cmp ax, 0x10
  054080  0B40: 7c0a             jl 0xb4c
  054082  0B42: 3d1000           cmp ax, 0x10
  054085  0B45: 7c23             jl 0xb6a
  054087  0B47: 3d1800           cmp ax, 0x18
  05408A  0B4A: 7d1e             jge 0xb6a
  05408C  0B4C: ff86cefe         inc word ptr [bp - 0x132]
  054090  0B50: ff86befe         inc word ptr [bp - 0x142]
  054094  0B54: 8a9e18ff         mov bl, byte ptr [bp - 0xe8]
  054098  0B58: 83e307           and bx, 7
  05409B  0B5B: c1e304           shl bx, 4
  05409E  0B5E: 80bf7b2f03       cmp byte ptr [bx + 0x2f7b], 3
  0540A3  0B63: 7227             jb 0xb8c
  0540A5  0B65: ff46f6           inc word ptr [bp - 0xa]
  0540A8  0B68: eb22             jmp 0xb8c
  0540AA  0B6A: 8bd8             mov bx, ax
  0540AC  0B6C: c1e304           shl bx, 4
  0540AF  0B6F: 80bf7b2f03       cmp byte ptr [bx + 0x2f7b], 3
  0540B4  0B74: 7206             jb 0xb7c
  0540B6  0B76: ff46f4           inc word ptr [bp - 0xc]
  0540B9  0B79: eb11             jmp 0xb8c
  0540BB  0B7B: 90               nop 
  0540BC  0B7C: 8bd8             mov bx, ax
  0540BE  0B7E: c1e304           shl bx, 4
  0540C1  0B81: 80bf7b2f02       cmp byte ptr [bx + 0x2f7b], 2
  0540C6  0B86: 7304             jae 0xb8c
  0540C8  0B88: ff86befe         inc word ptr [bp - 0x142]
  0540CC  0B8C: ffb654ff         push word ptr [bp - 0xac]
  0540D0  0B90: ffb65cff         push word ptr [bp - 0xa4]
  0540D4  0B94: 9a54071f18       lcall 0x181f, 0x754
  0540D9  0B99: 83c404           add sp, 4
  0540DC  0B9C: 250a00           and ax, 0xa
  0540DF  0B9F: 89867cff         mov word ptr [bp - 0x84], ax
  0540E3  0BA3: 8b1e4285         mov bx, word ptr [0x8542]
  0540E7  0BA7: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0540EB  0BAB: 80787000         cmp byte ptr [bx + si + 0x70], 0
  0540EF  0BAF: 7c37             jl 0xbe8
  0540F1  0BB1: ff8648fe         inc word ptr [bp - 0x1b8]
  0540F5  0BB5: 0bc0             or ax, ax
  0540F7  0BB7: 7503             jne 0xbbc
  0540F9  0BB9: ff4694           inc word ptr [bp - 0x6c]
  0540FC  0BBC: 0bc0             or ax, ax
  0540FE  0BBE: 7404             je 0xbc4
  054100  0BC0: ff8658ff         inc word ptr [bp - 0xa8]
  054104  0BC4: 83be18ff07       cmp word ptr [bp - 0xe8], 7
  054109  0BC9: 7f1d             jg 0xbe8
  05410B  0BCB: ffb654ff         push word ptr [bp - 0xac]
  05410F  0BCF: ffb65cff         push word ptr [bp - 0xa4]
  054113  0BD3: 9a54071f18       lcall 0x181f, 0x754
  054118  0BD8: 83c404           add sp, 4
  05411B  0BDB: a840             test al, 0x40
  05411D  0BDD: 7405             je 0xbe4
  05411F  0BDF: ff46dc           inc word ptr [bp - 0x24]
  054122  0BE2: eb04             jmp 0xbe8
  054124  0BE4: ff86c2fe         inc word ptr [bp - 0x13e]
  054128  0BE8: ff8656ff         inc word ptr [bp - 0xaa]
  05412C  0BEC: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  054130  0BF0: 398656ff         cmp word ptr [bp - 0xaa], ax
  054134  0BF4: 7d40             jge 0xc36
  054136  0BF6: 8b9e56ff         mov bx, word ptr [bp - 0xaa]
  05413A  0BFA: 8a87de00         mov al, byte ptr [bx + 0xde]
  05413E  0BFE: 98               cwde 
  05413F  0BFF: 8b364285         mov si, word ptr [0x8542]
  054143  0C03: 8a4c01           mov cl, byte ptr [si + 1]
  054146  0C06: 2aed             sub ch, ch
  054148  0C08: 03c1             add ax, cx
  05414A  0C0A: 898654ff         mov word ptr [bp - 0xac], ax
  05414E  0C0E: 50               push ax
  05414F  0C0F: 8a87c800         mov al, byte ptr [bx + 0xc8]
  054153  0C13: 98               cwde 
  054154  0C14: 8a0c             mov cl, byte ptr [si]
  054156  0C16: 03c1             add ax, cx
  054158  0C18: 89865cff         mov word ptr [bp - 0xa4], ax
  05415C  0C1C: 50               push ax
  05415D  0C1D: 9a02031f18       lcall 0x181f, 0x302
  054162  0C22: 83c404           add sp, 4
  054165  0C25: 0bc0             or ax, ax
  054167  0C27: 7403             je 0xc2c
  054169  0C29: e9e0fe           jmp 0xb0c
  05416C  0C2C: ff86c0fe         inc word ptr [bp - 0x140]
  054170  0C30: ff86befe         inc word ptr [bp - 0x142]
  054174  0C34: ebb2             jmp 0xbe8
  054176  0C36: 6a06             push 6
  054178  0C38: 9afc091f18       lcall 0x181f, 0x9fc
  05417D  0C3D: 83c402           add sp, 2
  054180  0C40: 0bc0             or ax, ax
  054182  0C42: 7406             je 0xc4a
  054184  0C44: c786c0fe0000     mov word ptr [bp - 0x140], 0
  05418A  0C4A: 8b1e4285         mov bx, word ptr [0x8542]
  05418E  0C4E: 80671b07         and byte ptr [bx + 0x1b], 7
  054192  0C52: f6471c10         test byte ptr [bx + 0x1c], 0x10
  054196  0C56: 740e             je 0xc66
  054198  0C58: 807f1f20         cmp byte ptr [bx + 0x1f], 0x20
  05419C  0C5C: 7d08             jge 0xc66
  05419E  0C5E: 804f1b10         or byte ptr [bx + 0x1b], 0x10
  0541A2  0C62: 80671cef         and byte ptr [bx + 0x1c], 0xef
  0541A6  0C66: 837e8c00         cmp word ptr [bp - 0x74], 0
  0541AA  0C6A: 7e08             jle 0xc74
  0541AC  0C6C: 8b1e4285         mov bx, word ptr [0x8542]
  0541B0  0C70: 804f1b40         or byte ptr [bx + 0x1b], 0x40
  0541B4  0C74: 8b1e4285         mov bx, word ptr [0x8542]
  0541B8  0C78: 8a471f           mov al, byte ptr [bx + 0x1f]
  0541BB  0C7B: 98               cwde 
  0541BC  0C7C: 0306728d         add ax, word ptr [0x8d72]
  0541C0  0C80: 8bc8             mov cx, ax
  0541C2  0C82: d1e0             shl ax, 1
  0541C4  0C84: 03c1             add ax, cx
  0541C6  0C86: d1f8             sar ax, 1
  0541C8  0C88: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  0541CC  0C8C: 8bcb             mov cx, bx
  0541CE  0C8E: d1e3             shl bx, 1
  0541D0  0C90: 03d9             add bx, cx
  0541D2  0C92: 8bc8             mov cx, ax
  0541D4  0C94: 8a876895         mov al, byte ptr [bx - 0x6a98]
  0541D8  0C98: 98               cwde 
  0541D9  0C99: 2bc8             sub cx, ax
  0541DB  0C9B: 8b168e53         mov dx, word ptr [0x538e]
  0541DF  0C9F: c1fa07           sar dx, 7
  0541E2  0CA2: 2bca             sub cx, dx
  0541E4  0CA4: 898e7eff         mov word ptr [bp - 0x82], cx
  0541E8  0CA8: 050500           add ax, 5
  0541EB  0CAB: 898646fe         mov word ptr [bp - 0x1ba], ax
  0541EF  0CAF: 837e8c00         cmp word ptr [bp - 0x74], 0
  0541F3  0CB3: 7405             je 0xcba
  0541F5  0CB5: 40               inc ax
  0541F6  0CB6: 898646fe         mov word ptr [bp - 0x1ba], ax
  0541FA  0CBA: 837ed804         cmp word ptr [bp - 0x28], 4
  0541FE  0CBE: 7504             jne 0xcc4
  054200  0CC0: ff8e46fe         dec word ptr [bp - 0x1ba]
  054204  0CC4: 837ed800         cmp word ptr [bp - 0x28], 0
  054208  0CC8: 7505             jne 0xccf
  05420A  0CCA: 83867eff02       add word ptr [bp - 0x82], 2
  05420F  0CCF: 837ed803         cmp word ptr [bp - 0x28], 3
  054213  0CD3: 7504             jne 0xcd9
  054215  0CD5: ff867eff         inc word ptr [bp - 0x82]
  054219  0CD9: 8b867eff         mov ax, word ptr [bp - 0x82]
  05421D  0CDD: 99               cdq 
  05421E  0CDE: f7be46fe         idiv word ptr [bp - 0x1ba]
  054222  0CE2: 89468e           mov word ptr [bp - 0x72], ax
  054225  0CE5: 8b5e96           mov bx, word ptr [bp - 0x6a]
  054228  0CE8: 80bff29500       cmp byte ptr [bx - 0x6a0e], 0
  05422D  0CED: 750b             jne 0xcfa
  05422F  0CEF: 837ed800         cmp word ptr [bp - 0x28], 0
  054233  0CF3: 7405             je 0xcfa
  054235  0CF5: c7468e0000       mov word ptr [bp - 0x72], 0
  05423A  0CFA: f687f29501       test byte ptr [bx - 0x6a0e], 1
  05423F  0CFF: 7503             jne 0xd04
  054241  0D01: e9c400           jmp 0xdc8
  054244  0D04: f687f29506       test byte ptr [bx - 0x6a0e], 6
  054249  0D09: 740a             je 0xd15
  05424B  0D0B: 83be52fe02       cmp word ptr [bp - 0x1ae], 2
  054250  0D10: 7403             je 0xd15
  054252  0D12: e9a500           jmp 0xdba
  054255  0D15: 8bb652fe         mov si, word ptr [bp - 0x1ae]
  054259  0D19: c1e604           shl si, 4
  05425C  0D1C: 80b8b29502       cmp byte ptr [bx + si - 0x6a4e], 2
  054261  0D21: 7303             jae 0xd26
  054263  0D23: e9a200           jmp 0xdc8
  054266  0D26: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  05426A  0D2A: d1e3             shl bx, 1
  05426C  0D2C: 8b871c94         mov ax, word ptr [bx - 0x6be4]
  054270  0D30: d1e0             shl ax, 1
  054272  0D32: 89867eff         mov word ptr [bp - 0x82], ax
  054276  0D36: 83be52fe02       cmp word ptr [bp - 0x1ae], 2
  05427B  0D3B: 7506             jne 0xd43
  05427D  0D3D: d1e0             shl ax, 1
  05427F  0D3F: 89867eff         mov word ptr [bp - 0x82], ax
  054283  0D43: 8bb652fe         mov si, word ptr [bp - 0x1ae]
  054287  0D47: c1e604           shl si, 4
  05428A  0D4A: 8b5e96           mov bx, word ptr [bp - 0x6a]
  05428D  0D4D: 8a80b295         mov al, byte ptr [bx + si - 0x6a4e]
  054291  0D51: 2ae4             sub ah, ah
  054293  0D53: c1e002           shl ax, 2
  054296  0D56: 898666ff         mov word ptr [bp - 0x9a], ax
  05429A  0D5A: 83be52fe02       cmp word ptr [bp - 0x1ae], 2
  05429F  0D5F: 7506             jne 0xd67
  0542A1  0D61: d1e0             shl ax, 1
  0542A3  0D63: 898666ff         mov word ptr [bp - 0x9a], ax
  0542A7  0D67: 8b1e528d         mov bx, word ptr [0x8d52]
  0542AB  0D6B: 8a878491         mov al, byte ptr [bx - 0x6e7c]
  0542AF  0D6F: 2ae4             sub ah, ah
  0542B1  0D71: 3b867eff         cmp ax, word ptr [bp - 0x82]
  0542B5  0D75: 7f51             jg 0xdc8
  0542B7  0D77: 8bf3             mov si, bx
  0542B9  0D79: c1e604           shl si, 4
  0542BC  0D7C: 8bc3             mov ax, bx
  0542BE  0D7E: 8b5e96           mov bx, word ptr [bp - 0x6a]
  0542C1  0D81: 8a88cc91         mov cl, byte ptr [bx + si - 0x6e34]
  0542C5  0D85: 2aed             sub ch, ch
  0542C7  0D87: 3b8e66ff         cmp cx, word ptr [bp - 0x9a]
  0542CB  0D8B: 7d3b             jge 0xdc8
  0542CD  0D8D: ffb652fe         push word ptr [bp - 0x1ae]
  0542D1  0D91: 50               push ax
  0542D2  0D92: 9a0c031f18       lcall 0x181f, 0x30c
  0542D7  0D97: 83c404           add sp, 4
  0542DA  0D9A: 3d1900           cmp ax, 0x19
  0542DD  0D9D: 7f07             jg 0xda6
  0542DF  0D9F: 83be52fe02       cmp word ptr [bp - 0x1ae], 2
  0542E4  0DA4: 7522             jne 0xdc8
  0542E6  0DA6: 6a02             push 2
  0542E8  0DA8: ff36508d         push word ptr [0x8d50]
  0542EC  0DAC: ffb652fe         push word ptr [bp - 0x1ae]
  0542F0  0DB0: 9a060a1f18       lcall 0x181f, 0xa06
  0542F5  0DB5: 83c406           add sp, 6
  0542F8  0DB8: eb0e             jmp 0xdc8
  0542FA  0DBA: 8b468e           mov ax, word ptr [bp - 0x72]
  0542FD  0DBD: 3d0100           cmp ax, 1
  054300  0DC0: 7e03             jle 0xdc5
  054302  0DC2: b80100           mov ax, 1
  054305  0DC5: 89468e           mov word ptr [bp - 0x72], ax
  054308  0DC8: 8b4680           mov ax, word ptr [bp - 0x80]
  05430B  0DCB: 39468e           cmp word ptr [bp - 0x72], ax
  05430E  0DCE: 7e08             jle 0xdd8
  054310  0DD0: 8b1e4285         mov bx, word ptr [0x8542]
  054314  0DD4: 804f1b08         or byte ptr [bx + 0x1b], 8
  054318  0DD8: 837e8e01         cmp word ptr [bp - 0x72], 1
  05431C  0DDC: 7e06             jle 0xde4
  05431E  0DDE: b80100           mov ax, 1
  054321  0DE1: eb03             jmp 0xde6
  054323  0DE3: 90               nop 
  054324  0DE4: 2bc0             sub ax, ax
  054326  0DE6: 03468e           add ax, word ptr [bp - 0x72]
  054329  0DE9: 3b4680           cmp ax, word ptr [bp - 0x80]
  05432C  0DEC: 7d08             jge 0xdf6
  05432E  0DEE: 8b1e4285         mov bx, word ptr [0x8542]
  054332  0DF2: 804f1b04         or byte ptr [bx + 0x1b], 4
  054336  0DF6: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  05433A  0DFA: 48               dec ax
  05433B  0DFB: 3b86befe         cmp ax, word ptr [bp - 0x142]
  05433F  0DFF: 7f0f             jg 0xe10
  054341  0E01: 83becefe01       cmp word ptr [bp - 0x132], 1
  054346  0E06: 7e08             jle 0xe10
  054348  0E08: 8b1e4285         mov bx, word ptr [0x8542]
  05434C  0E0C: 804f1ba0         or byte ptr [bx + 0x1b], 0xa0
  054350  0E10: 8b1e4285         mov bx, word ptr [0x8542]
  054354  0E14: 8a471f           mov al, byte ptr [bx + 0x1f]
  054357  0E17: 98               cwde 
  054358  0E18: 050300           add ax, 3
  05435B  0E1B: c1f802           sar ax, 2
  05435E  0E1E: 3b46f4           cmp ax, word ptr [bp - 0xc]
  054361  0E21: 7e11             jle 0xe34
  054363  0E23: 837ef600         cmp word ptr [bp - 0xa], 0
  054367  0E27: 740b             je 0xe34
  054369  0E29: 83becefe01       cmp word ptr [bp - 0x132], 1
  05436E  0E2E: 7e04             jle 0xe34
  054370  0E30: 804f1ba0         or byte ptr [bx + 0x1b], 0xa0
  054374  0E34: 837e9400         cmp word ptr [bp - 0x6c], 0
  054378  0E38: 7507             jne 0xe41
  05437A  0E3A: 83bec2fe00       cmp word ptr [bp - 0x13e], 0
  05437F  0E3F: 7408             je 0xe49
  054381  0E41: 8b1e4285         mov bx, word ptr [0x8542]
  054385  0E45: 804f1b80         or byte ptr [bx + 0x1b], 0x80
  054389  0E49: 8b1e4285         mov bx, word ptr [0x8542]
  05438D  0E4D: 8a471a           mov al, byte ptr [bx + 0x1a]
  054390  0E50: 2ae4             sub ah, ah
  054392  0E52: 50               push ax
  054393  0E53: 9a94041f1a       lcall 0x1a1f, 0x494
  054398  0E58: 83c402           add sp, 2
  05439B  0E5B: 8946f2           mov word ptr [bp - 0xe], ax
  05439E  0E5E: 8b1e4285         mov bx, word ptr [0x8542]
  0543A2  0E62: 807f1f20         cmp byte ptr [bx + 0x1f], 0x20
  0543A6  0E66: 7d30             jge 0xe98
  0543A8  0E68: 9a7c0c1f18       lcall 0x181f, 0xc7c
  0543AD  0E6D: 8a4e92           mov cl, byte ptr [bp - 0x6e]
  0543B0  0E70: d0e1             shl cl, 1
  0543B2  0E72: 02c1             add al, cl
  0543B4  0E74: 8b1e4285         mov bx, word ptr [0x8542]
  0543B8  0E78: 3a471f           cmp al, byte ptr [bx + 0x1f]
  0543BB  0E7B: 7e1b             jle 0xe98
  0543BD  0E7D: 8a471f           mov al, byte ptr [bx + 0x1f]
  0543C0  0E80: 98               cwde 
  0543C1  0E81: 8b4e92           mov cx, word ptr [bp - 0x6e]
  0543C4  0E84: d1e1             shl cx, 1
  0543C6  0E86: 2bc1             sub ax, cx
  0543C8  0E88: 8b8e60ff         mov cx, word ptr [bp - 0xa0]
  0543CC  0E8C: 2b8ec0fe         sub cx, word ptr [bp - 0x140]
  0543D0  0E90: 3bc1             cmp ax, cx
  0543D2  0E92: 7d04             jge 0xe98
  0543D4  0E94: 804f1b10         or byte ptr [bx + 0x1b], 0x10
  0543D8  0E98: 6a32             push 0x32
  0543DA  0E9A: 6a00             push 0
  0543DC  0E9C: 8d469a           lea ax, [bp - 0x66]
  0543DF  0E9F: 50               push ax
  0543E0  0EA0: 9aae0d1d0d       lcall 0xd1d, 0xdae
  0543E5  0EA5: 83c406           add sp, 6
  0543E8  0EA8: 6a32             push 0x32
  0543EA  0EAA: 6a00             push 0
  0543EC  0EAC: 8d861eff         lea ax, [bp - 0xe2]
  0543F0  0EB0: 50               push ax
  0543F1  0EB1: 9aae0d1d0d       lcall 0xd1d, 0xdae
  0543F6  0EB6: 83c406           add sp, 6
  0543F9  0EB9: c78656ff0000     mov word ptr [bp - 0xaa], 0
  0543FF  0EBF: eb2e             jmp 0xeef
  054401  0EC1: 90               nop 
  054402  0EC2: ffb656ff         push word ptr [bp - 0xaa]
  054406  0EC6: 9a540c1f18       lcall 0x181f, 0xc54
  05440B  0ECB: 83c402           add sp, 2
  05440E  0ECE: 8946ea           mov word ptr [bp - 0x16], ax
  054411  0ED1: 50               push ax
  054412  0ED2: 9a9a0c1f18       lcall 0x181f, 0xc9a
  054417  0ED7: 83c402           add sp, 2
  05441A  0EDA: 0bc0             or ax, ax
  05441C  0EDC: 7505             jne 0xee3
  05441E  0EDE: c746ea1300       mov word ptr [bp - 0x16], 0x13
  054423  0EE3: 8b76ea           mov si, word ptr [bp - 0x16]
  054426  0EE6: d1e6             shl si, 1
  054428  0EE8: ff429a           inc word ptr [bp + si - 0x66]
  05442B  0EEB: ff8656ff         inc word ptr [bp - 0xaa]
  05442F  0EEF: 8b1e4285         mov bx, word ptr [0x8542]
  054433  0EF3: 8a471f           mov al, byte ptr [bx + 0x1f]
  054436  0EF6: 98               cwde 
  054437  0EF7: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  05443B  0EFB: 7fc5             jg 0xec2
  05443D  0EFD: 9acc0c1f18       lcall 0x181f, 0xccc
  054442  0F02: 833e728d00       cmp word ptr [0x8d72], 0
  054447  0F07: 7503             jne 0xf0c
  054449  0F09: e97301           jmp 0x107f
  05444C  0F0C: 8b1e4285         mov bx, word ptr [0x8542]
  054450  0F10: f6471b10         test byte ptr [bx + 0x1b], 0x10
  054454  0F14: 7503             jne 0xf19
  054456  0F16: e96601           jmp 0x107f
  054459  0F19: c746d00000       mov word ptr [bp - 0x30], 0
  05445E  0F1E: 8b1e4285         mov bx, word ptr [0x8542]
  054462  0F22: 8a471f           mov al, byte ptr [bx + 0x1f]
  054465  0F25: 98               cwde 
  054466  0F26: 898656ff         mov word ptr [bp - 0xaa], ax
  05446A  0F2A: e98700           jmp 0xfb4
  05446D  0F2D: 90               nop 
  05446E  0F2E: 837ec000         cmp word ptr [bp - 0x40], 0
  054472  0F32: 7403             je 0xf37
  054474  0F34: ff4ec0           dec word ptr [bp - 0x40]
  054477  0F37: 83be14ff14       cmp word ptr [bp - 0xec], 0x14
  05447C  0F3C: 752d             jne 0xf6b
  05447E  0F3E: 8b1e4285         mov bx, word ptr [0x8542]
  054482  0F42: f6471b80         test byte ptr [bx + 0x1b], 0x80
  054486  0F46: 7406             je 0xf4e
  054488  0F48: 837eec00         cmp word ptr [bp - 0x14], 0
  05448C  0F4C: 7406             je 0xf54
  05448E  0F4E: 837ed800         cmp word ptr [bp - 0x28], 0
  054492  0F52: 7517             jne 0xf6b
  054494  0F54: 6a12             push 0x12
  054496  0F56: ffb656ff         push word ptr [bp - 0xaa]
  05449A  0F5A: 9a360c1f18       lcall 0x181f, 0xc36
  05449F  0F5F: 83c404           add sp, 4
  0544A2  0F62: b80100           mov ax, 1
  0544A5  0F65: 8946ec           mov word ptr [bp - 0x14], ax
  0544A8  0F68: 8946d0           mov word ptr [bp - 0x30], ax
  0544AB  0F6B: 83be14ff16       cmp word ptr [bp - 0xec], 0x16
  0544B0  0F70: 7524             jne 0xf96
  0544B2  0F72: 837ed800         cmp word ptr [bp - 0x28], 0
  0544B6  0F76: 740b             je 0xf83
  0544B8  0F78: 8b1e4285         mov bx, word ptr [0x8542]
  0544BC  0F7C: 83bfaa0034       cmp word ptr [bx + 0xaa], 0x34
  0544C1  0F81: 7d13             jge 0xf96
  0544C3  0F83: 6a12             push 0x12
  0544C5  0F85: ffb656ff         push word ptr [bp - 0xaa]
  0544C9  0F89: 9a360c1f18       lcall 0x181f, 0xc36
  0544CE  0F8E: 83c404           add sp, 4
  0544D1  0F91: c746d00100       mov word ptr [bp - 0x30], 1
  0544D6  0F96: 83be14ff13       cmp word ptr [bp - 0xec], 0x13
  0544DB  0F9B: 7513             jne 0xfb0
  0544DD  0F9D: 6a12             push 0x12
  0544DF  0F9F: ffb656ff         push word ptr [bp - 0xaa]
  0544E3  0FA3: 9a360c1f18       lcall 0x181f, 0xc36
  0544E8  0FA8: 83c404           add sp, 4
  0544EB  0FAB: c746d00100       mov word ptr [bp - 0x30], 1
  0544F0  0FB0: ff8656ff         inc word ptr [bp - 0xaa]
  0544F4  0FB4: 837ed000         cmp word ptr [bp - 0x30], 0
  0544F8  0FB8: 7403             je 0xfbd
  0544FA  0FBA: e9b900           jmp 0x1076
  0544FD  0FBD: 8b1e4285         mov bx, word ptr [0x8542]
  054501  0FC1: 8a471f           mov al, byte ptr [bx + 0x1f]
  054504  0FC4: 8bc8             mov cx, ax
  054506  0FC6: 98               cwde 
  054507  0FC7: 0306728d         add ax, word ptr [0x8d72]
  05450B  0FCB: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  05450F  0FCF: 7f03             jg 0xfd4
  054511  0FD1: e9a200           jmp 0x1076
  054514  0FD4: 80f920           cmp cl, 0x20
  054517  0FD7: 7c03             jl 0xfdc
  054519  0FD9: e99a00           jmp 0x1076
  05451C  0FDC: ffb656ff         push word ptr [bp - 0xaa]
  054520  0FE0: 9a0e0c1f18       lcall 0x181f, 0xc0e
  054525  0FE5: 83c402           add sp, 2
  054528  0FE8: 898614ff         mov word ptr [bp - 0xec], ax
  05452C  0FEC: ffb656ff         push word ptr [bp - 0xaa]
  054530  0FF0: 9a540c1f18       lcall 0x181f, 0xc54
  054535  0FF5: 83c402           add sp, 2
  054538  0FF8: 8946ea           mov word ptr [bp - 0x16], ax
  05453B  0FFB: 83be14ff15       cmp word ptr [bp - 0xec], 0x15
  054540  1000: 740a             je 0x100c
  054542  1002: 83be14ff17       cmp word ptr [bp - 0xec], 0x17
  054547  1007: 7403             je 0x100c
  054549  1009: e92bff           jmp 0xf37
  05454C  100C: 837e8c00         cmp word ptr [bp - 0x74], 0
  054550  1010: 7d0a             jge 0x101c
  054552  1012: 8b1e4285         mov bx, word ptr [0x8542]
  054556  1016: f6471b08         test byte ptr [bx + 0x1b], 8
  05455A  101A: 742c             je 0x1048
  05455C  101C: 50               push ax
  05455D  101D: 9a9a0c1f18       lcall 0x181f, 0xc9a
  054562  1022: 83c402           add sp, 2
  054565  1025: 0bc0             or ax, ax
  054567  1027: 7412             je 0x103b
  054569  1029: 837eea15         cmp word ptr [bp - 0x16], 0x15
  05456D  102D: 740c             je 0x103b
  05456F  102F: 837ec000         cmp word ptr [bp - 0x40], 0
  054573  1033: 7513             jne 0x1048
  054575  1035: 837ec400         cmp word ptr [bp - 0x3c], 0
  054579  1039: 750d             jne 0x1048
  05457B  103B: 8b1e4285         mov bx, word ptr [0x8542]
  05457F  103F: f6471b04         test byte ptr [bx + 0x1b], 4
  054583  1043: 7503             jne 0x1048
  054585  1045: e9effe           jmp 0xf37
  054588  1048: 6a12             push 0x12
  05458A  104A: ffb656ff         push word ptr [bp - 0xaa]
  05458E  104E: 9a360c1f18       lcall 0x181f, 0xc36
  054593  1053: 83c404           add sp, 4
  054596  1056: ff468c           inc word ptr [bp - 0x74]
  054599  1059: c746d00100       mov word ptr [bp - 0x30], 1
  05459E  105E: 8b1e4285         mov bx, word ptr [0x8542]
  0545A2  1062: 80671bfb         and byte ptr [bx + 0x1b], 0xfb
  0545A6  1066: 837ec400         cmp word ptr [bp - 0x3c], 0
  0545AA  106A: 7503             jne 0x106f
  0545AC  106C: e9bffe           jmp 0xf2e
  0545AF  106F: ff4ec4           dec word ptr [bp - 0x3c]
  0545B2  1072: e9c2fe           jmp 0xf37
  0545B5  1075: 90               nop 
  0545B6  1076: 837ed000         cmp word ptr [bp - 0x30], 0
  0545BA  107A: 7403             je 0x107f
  0545BC  107C: e99afe           jmp 0xf19
  0545BF  107F: 8b1e4285         mov bx, word ptr [0x8542]
  0545C3  1083: 807f1f01         cmp byte ptr [bx + 0x1f], 1
  0545C7  1087: 7f03             jg 0x108c
  0545C9  1089: e9d001           jmp 0x125c
  0545CC  108C: c78674ff1300     mov word ptr [bp - 0x8c], 0x13
  0545D2  1092: c786ccfe0000     mov word ptr [bp - 0x134], 0
  0545D8  1098: 83bfaa0066       cmp word ptr [bx + 0xaa], 0x66
  0545DD  109D: 7c26             jl 0x10c5
  0545DF  109F: 807f1f0a         cmp byte ptr [bx + 0x1f], 0xa
  0545E3  10A3: 7d0e             jge 0x10b3
  0545E5  10A5: 9a7c0c1f18       lcall 0x181f, 0xc7c
  0545EA  10AA: 8b1e4285         mov bx, word ptr [0x8542]
  0545EE  10AE: 3a471f           cmp al, byte ptr [bx + 0x1f]
  0545F1  10B1: 7f12             jg 0x10c5
  0545F3  10B3: f6471b10         test byte ptr [bx + 0x1b], 0x10
  0545F7  10B7: 750c             jne 0x10c5
  0545F9  10B9: c78674ff1600     mov word ptr [bp - 0x8c], 0x16
  0545FF  10BF: c786ccfe0100     mov word ptr [bp - 0x134], 1
  054605  10C5: 837ed800         cmp word ptr [bp - 0x28], 0
  054609  10C9: 7529             jne 0x10f4
  05460B  10CB: 807f1f0a         cmp byte ptr [bx + 0x1f], 0xa
  05460F  10CF: 7e23             jle 0x10f4
  054611  10D1: 6a03             push 3
  054613  10D3: 6a00             push 0
  054615  10D5: 9ad4041f18       lcall 0x181f, 0x4d4
  05461A  10DA: 83c404           add sp, 4
  05461D  10DD: 0bc0             or ax, ax
  05461F  10DF: 7513             jne 0x10f4
  054621  10E1: 8b1e4285         mov bx, word ptr [0x8542]
  054625  10E5: f6471b10         test byte ptr [bx + 0x1b], 0x10
  054629  10E9: 7509             jne 0x10f4
  05462B  10EB: c78672ff0100     mov word ptr [bp - 0x8e], 1
  054631  10F1: eb07             jmp 0x10fa
  054633  10F3: 90               nop 
  054634  10F4: c78672ff0000     mov word ptr [bp - 0x8e], 0
  05463A  10FA: 83be72ff00       cmp word ptr [bp - 0x8e], 0
  05463F  10FF: 7429             je 0x112a
  054641  1101: 6b9e52fe13       imul bx, word ptr [bp - 0x1ae], 0x13
  054646  1106: 80bf4e9200       cmp byte ptr [bx - 0x6db2], 0
  05464B  110B: 751d             jne 0x112a
  05464D  110D: 837ef200         cmp word ptr [bp - 0xe], 0
  054651  1111: 7417             je 0x112a
  054653  1113: 8b1e4285         mov bx, word ptr [0x8542]
  054657  1117: 83bfb60014       cmp word ptr [bx + 0xb6], 0x14
  05465C  111C: 7c0c             jl 0x112a
  05465E  111E: c78674ff1400     mov word ptr [bp - 0x8c], 0x14
  054664  1124: c786ccfe0100     mov word ptr [bp - 0x134], 1
  05466A  112A: 8b1e4285         mov bx, word ptr [0x8542]
  05466E  112E: f6471b48         test byte ptr [bx + 0x1b], 0x48
  054672  1132: 7507             jne 0x113b
  054674  1134: 83be72ff00       cmp word ptr [bp - 0x8e], 0
  054679  1139: 7420             je 0x115b
  05467B  113B: 83bfb80032       cmp word ptr [bx + 0xb8], 0x32
  054680  1140: 7c19             jl 0x115b
  054682  1142: c78674ff1500     mov word ptr [bp - 0x8c], 0x15
  054688  1148: 83bfaa0034       cmp word ptr [bx + 0xaa], 0x34
  05468D  114D: 7c06             jl 0x1155
  05468F  114F: c78674ff1700     mov word ptr [bp - 0x8c], 0x17
  054695  1155: c786ccfe0100     mov word ptr [bp - 0x134], 1
  05469B  115B: 83beccfe00       cmp word ptr [bp - 0x134], 0
  0546A0  1160: 7503             jne 0x1165
  0546A2  1162: e9f700           jmp 0x125c
  0546A5  1165: 8b8674ff         mov ax, word ptr [bp - 0x8c]
  0546A9  1169: 89864efe         mov word ptr [bp - 0x1b2], ax
  0546AD  116D: 3d1700           cmp ax, 0x17
  0546B0  1170: 7506             jne 0x1178
  0546B2  1172: c7864efe1500     mov word ptr [bp - 0x1b2], 0x15
  0546B8  1178: b8ffff           mov ax, 0xffff
  0546BB  117B: 898694fe         mov word ptr [bp - 0x16c], ax
  0546BF  117F: 8946ce           mov word ptr [bp - 0x32], ax
  0546C2  1182: c78656ff0000     mov word ptr [bp - 0xaa], 0
  0546C8  1188: eb4a             jmp 0x11d4
  0546CA  118A: 50               push ax
  0546CB  118B: 9a9a0c1f18       lcall 0x181f, 0xc9a
  0546D0  1190: 83c402           add sp, 2
  0546D3  1193: 0bc0             or ax, ax
  0546D5  1195: 7507             jne 0x119e
  0546D7  1197: ff86befe         inc word ptr [bp - 0x142]
  0546DB  119B: eb18             jmp 0x11b5
  0546DD  119D: 90               nop 
  0546DE  119E: 83be4efe15       cmp word ptr [bp - 0x1b2], 0x15
  0546E3  11A3: 7510             jne 0x11b5
  0546E5  11A5: 8b1e4285         mov bx, word ptr [0x8542]
  0546E9  11A9: f6471b40         test byte ptr [bx + 0x1b], 0x40
  0546ED  11AD: 7506             jne 0x11b5
  0546EF  11AF: c786befe9dff     mov word ptr [bp - 0x142], 0xff9d
  0546F5  11B5: 837eea19         cmp word ptr [bp - 0x16], 0x19
  0546F9  11B9: 7504             jne 0x11bf
  0546FB  11BB: ff86befe         inc word ptr [bp - 0x142]
  0546FF  11BF: 837eea1a         cmp word ptr [bp - 0x16], 0x1a
  054703  11C3: 7505             jne 0x11ca
  054705  11C5: 8386befe02       add word ptr [bp - 0x142], 2
  05470A  11CA: 837eea1b         cmp word ptr [bp - 0x16], 0x1b
  05470E  11CE: 7536             jne 0x1206
  054710  11D0: ff8656ff         inc word ptr [bp - 0xaa]
  054714  11D4: 8b1e4285         mov bx, word ptr [0x8542]
  054718  11D8: 8a471f           mov al, byte ptr [bx + 0x1f]
  05471B  11DB: 98               cwde 
  05471C  11DC: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  054720  11E0: 7e40             jle 0x1222
  054722  11E2: c786befe0000     mov word ptr [bp - 0x142], 0
  054728  11E8: ffb656ff         push word ptr [bp - 0xaa]
  05472C  11EC: 9a540c1f18       lcall 0x181f, 0xc54
  054731  11F1: 83c402           add sp, 2
  054734  11F4: 8946ea           mov word ptr [bp - 0x16], ax
  054737  11F7: 3b864efe         cmp ax, word ptr [bp - 0x1b2]
  05473B  11FB: 758d             jne 0x118a
  05473D  11FD: c786befe0400     mov word ptr [bp - 0x142], 4
  054743  1203: ebb0             jmp 0x11b5
  054745  1205: 90               nop 
  054746  1206: 8b8694fe         mov ax, word ptr [bp - 0x16c]
  05474A  120A: 3986befe         cmp word ptr [bp - 0x142], ax
  05474E  120E: 7cc0             jl 0x11d0
  054750  1210: 8b86befe         mov ax, word ptr [bp - 0x142]
  054754  1214: 898694fe         mov word ptr [bp - 0x16c], ax
  054758  1218: 8b8656ff         mov ax, word ptr [bp - 0xaa]
  05475C  121C: 8946ce           mov word ptr [bp - 0x32], ax
  05475F  121F: ebaf             jmp 0x11d0
  054761  1221: 90               nop 
  054762  1222: 837ece00         cmp word ptr [bp - 0x32], 0
  054766  1226: 7c34             jl 0x125c
  054768  1228: ff76ea           push word ptr [bp - 0x16]
  05476B  122B: 9a9a0c1f18       lcall 0x181f, 0xc9a
  054770  1230: 83c402           add sp, 2
  054773  1233: 0bc0             or ax, ax
  054775  1235: 7416             je 0x124d
  054777  1237: 8b46ea           mov ax, word ptr [bp - 0x16]
  05477A  123A: 39864efe         cmp word ptr [bp - 0x1b2], ax
  05477E  123E: 740d             je 0x124d
  054780  1240: 6a1c             push 0x1c
  054782  1242: ff76ce           push word ptr [bp - 0x32]
  054785  1245: 9aae0c1f18       lcall 0x181f, 0xcae
  05478A  124A: 83c404           add sp, 4
  05478D  124D: ffb674ff         push word ptr [bp - 0x8c]
  054791  1251: ff76ce           push word ptr [bp - 0x32]
  054794  1254: 9a360c1f18       lcall 0x181f, 0xc36
  054799  1259: 83c404           add sp, 4
  05479C  125C: 9acc0c1f18       lcall 0x181f, 0xccc
  0547A1  1261: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  0547A5  1265: 8bc3             mov ax, bx
  0547A7  1267: d1e3             shl bx, 1
  0547A9  1269: 03d8             add bx, ax
  0547AB  126B: 8a876695         mov al, byte ptr [bx - 0x6a9a]
  0547AF  126F: 98               cwde 
  0547B0  1270: 40               inc ax
  0547B1  1271: 40               inc ax
  0547B2  1272: 6bc032           imul ax, ax, 0x32
  0547B5  1275: 8b1e4285         mov bx, word ptr [0x8542]
  0547B9  1279: 3b87b800         cmp ax, word ptr [bx + 0xb8]
  0547BD  127D: 7e05             jle 0x1284
  0547BF  127F: b80100           mov ax, 1
  0547C2  1282: eb02             jmp 0x1286
  0547C4  1284: 2bc0             sub ax, ax
  0547C6  1286: 50               push ax
  0547C7  1287: 6a0f             push 0xf
  0547C9  1289: 0e               push cs
  0547CA  128A: e8d51a           call 0x2d62
  0547CD  128D: 83c404           add sp, 4
  0547D0  1290: 8b1e4285         mov bx, word ptr [0x8542]
  0547D4  1294: 80bf8d000f       cmp byte ptr [bx + 0x8d], 0xf
  0547D9  1299: 7505             jne 0x12a0
  0547DB  129B: b80100           mov ax, 1
  0547DE  129E: eb02             jmp 0x12a2
  0547E0  12A0: 2bc0             sub ax, ax
  0547E2  12A2: 89866cff         mov word ptr [bp - 0x94], ax
  0547E6  12A6: 83bfb40064       cmp word ptr [bx + 0xb4], 0x64
  0547EB  12AB: 7d1d             jge 0x12ca
  0547ED  12AD: 8bb652fe         mov si, word ptr [bp - 0x1ae]
  0547F1  12B1: c1e604           shl si, 4
  0547F4  12B4: 80bcc98403       cmp byte ptr [si - 0x7b37], 3
  0547F9  12B9: 770f             ja 0x12ca
  0547FB  12BB: f6471c20         test byte ptr [bx + 0x1c], 0x20
  0547FF  12BF: 7409             je 0x12ca
  054801  12C1: c78642fe0100     mov word ptr [bp - 0x1be], 1
  054807  12C7: eb07             jmp 0x12d0
  054809  12C9: 90               nop 
  05480A  12CA: c78642fe0000     mov word ptr [bp - 0x1be], 0
  054810  12D0: ffb642fe         push word ptr [bp - 0x1be]
  054814  12D4: 6a0d             push 0xd
  054816  12D6: 0e               push cs
  054817  12D7: e8881a           call 0x2d62
  05481A  12DA: 83c404           add sp, 4
  05481D  12DD: 8b1e4285         mov bx, word ptr [0x8542]
  054821  12E1: 83bfaa0032       cmp word ptr [bx + 0xaa], 0x32
  054826  12E6: 7d06             jge 0x12ee
  054828  12E8: b80100           mov ax, 1
  05482B  12EB: eb03             jmp 0x12f0
  05482D  12ED: 90               nop 
  05482E  12EE: 2bc0             sub ax, ax
  054830  12F0: 50               push ax
  054831  12F1: 6a08             push 8
  054833  12F3: 0e               push cs
  054834  12F4: e86b1a           call 0x2d62
  054837  12F7: 83c404           add sp, 4
  05483A  12FA: 837eec00         cmp word ptr [bp - 0x14], 0
  05483E  12FE: 7512             jne 0x1312
  054840  1300: 8b1e4285         mov bx, word ptr [0x8542]
  054844  1304: f6471b80         test byte ptr [bx + 0x1b], 0x80
  054848  1308: 7408             je 0x1312
  05484A  130A: c78644fe0100     mov word ptr [bp - 0x1bc], 1
  054850  1310: eb06             jmp 0x1318
  054852  1312: c78644fe0000     mov word ptr [bp - 0x1bc], 0
  054858  1318: ffb644fe         push word ptr [bp - 0x1bc]
  05485C  131C: 6a0e             push 0xe
  05485E  131E: 0e               push cs
  05485F  131F: e8401a           call 0x2d62
  054862  1322: 83c404           add sp, 4
  054865  1325: 837e8c00         cmp word ptr [bp - 0x74], 0
  054869  1329: 7e0b             jle 0x1336
  05486B  132B: 8b1e4285         mov bx, word ptr [0x8542]
  05486F  132F: 83bfb80032       cmp word ptr [bx + 0xb8], 0x32
  054874  1334: 7c3b             jl 0x1371
  054876  1336: 8b1e4285         mov bx, word ptr [0x8542]
  05487A  133A: 80bf8e0001       cmp byte ptr [bx + 0x8e], 1
  05487F  133F: 750e             jne 0x134f
  054881  1341: 83bfb80032       cmp word ptr [bx + 0xb8], 0x32
  054886  1346: 7d07             jge 0x134f
  054888  1348: 80bf8d000e       cmp byte ptr [bx + 0x8d], 0xe
  05488D  134D: 7522             jne 0x1371
  05488F  134F: f6471b08         test byte ptr [bx + 0x1b], 8
  054893  1353: 740e             je 0x1363
  054895  1355: 83bfb80032       cmp word ptr [bx + 0xb8], 0x32
  05489A  135A: 7d07             jge 0x1363
  05489C  135C: 80bf8d000e       cmp byte ptr [bx + 0x8d], 0xe
  0548A1  1361: 750e             jne 0x1371
  0548A3  1363: 83be6cff00       cmp word ptr [bp - 0x94], 0
  0548A8  1368: 7410             je 0x137a
  0548AA  136A: 80bf8d000f       cmp byte ptr [bx + 0x8d], 0xf
  0548AF  136F: 7509             jne 0x137a
  0548B1  1371: c78640fe0100     mov word ptr [bp - 0x1c0], 1
  0548B7  1377: eb07             jmp 0x1380
  0548B9  1379: 90               nop 
  0548BA  137A: c78640fe0000     mov word ptr [bp - 0x1c0], 0
  0548C0  1380: ffb640fe         push word ptr [bp - 0x1c0]
  0548C4  1384: 6a0f             push 0xf
  0548C6  1386: 0e               push cs
  0548C7  1387: e8d819           call 0x2d62
  0548CA  138A: 83c404           add sp, 4
  0548CD  138D: 837e8c00         cmp word ptr [bp - 0x74], 0
  0548D1  1391: 751e             jne 0x13b1
  0548D3  1393: 8b1e4285         mov bx, word ptr [0x8542]
  0548D7  1397: 81bfb800c800     cmp word ptr [bx + 0xb8], 0xc8
  0548DD  139D: 7c12             jl 0x13b1
  0548DF  139F: 8b36fc84         mov si, word ptr [0x84fc]
  0548E3  13A3: 807c4914         cmp byte ptr [si + 0x49], 0x14
  0548E7  13A7: 7308             jae 0x13b1
  0548E9  13A9: fe4449           inc byte ptr [si + 0x49]
  0548EC  13AC: 83afb80032       sub word ptr [bx + 0xb8], 0x32
  0548F1  13B1: c6064c0300       mov byte ptr [0x34c], 0
  0548F6  13B6: 9ad20b1f18       lcall 0x181f, 0xbd2
  0548FB  13BB: 8b1e4285         mov bx, word ptr [0x8542]
  0548FF  13BF: f6471b80         test byte ptr [bx + 0x1b], 0x80
  054903  13C3: 750d             jne 0x13d2
  054905  13C5: a18e53           mov ax, word ptr [0x538e]
  054908  13C8: b90a00           mov cx, 0xa
  05490B  13CB: 99               cdq 
  05490C  13CC: f7f9             idiv cx
  05490E  13CE: 0bd2             or dx, dx
  054910  13D0: 7549             jne 0x141b
  054912  13D2: 837eec00         cmp word ptr [bp - 0x14], 0
  054916  13D6: 7543             jne 0x141b
  054918  13D8: 8a5f1a           mov bl, byte ptr [bx + 0x1a]
  05491B  13DB: 2aff             sub bh, bh
  05491D  13DD: c1e304           shl bx, 4
  054920  13E0: b014             mov al, 0x14
  054922  13E2: f6a7ca84         mul byte ptr [bx - 0x7b36]
  054926  13E6: 89865aff         mov word ptr [bp - 0xa6], ax
  05492A  13EA: 99               cdq 
  05492B  13EB: 8b1efc84         mov bx, word ptr [0x84fc]
  05492F  13EF: 3b572c           cmp dx, word ptr [bx + 0x2c]
  054932  13F2: 7f27             jg 0x141b
  054934  13F4: 7c05             jl 0x13fb
  054936  13F6: 3b472a           cmp ax, word ptr [bx + 0x2a]
  054939  13F9: 7720             ja 0x141b
  05493B  13FB: 29472a           sub word ptr [bx + 0x2a], ax
  05493E  13FE: 19572c           sbb word ptr [bx + 0x2c], dx
  054941  1401: 6a14             push 0x14
  054943  1403: 6a0e             push 0xe
  054945  1405: 9a140c1f19       lcall 0x191f, 0xc14
  05494A  140A: 83c404           add sp, 4
  05494D  140D: 8b1e4285         mov bx, word ptr [0x8542]
  054951  1411: 8387b60014       add word ptr [bx + 0xb6], 0x14
  054956  1416: c746ec0100       mov word ptr [bp - 0x14], 1
  05495B  141B: c786c6fe0000     mov word ptr [bp - 0x13a], 0
  054961  1421: 837eec00         cmp word ptr [bp - 0x14], 0
  054965  1425: 7434             je 0x145b
  054967  1427: a18e53           mov ax, word ptr [0x538e]
  05496A  142A: b90700           mov cx, 7
  05496D  142D: 99               cdq 
  05496E  142E: f7f9             idiv cx
  054970  1430: 0bd2             or dx, dx
  054972  1432: 7527             jne 0x145b
  054974  1434: 0e               push cs
  054975  1435: e82519           call 0x2d5d
  054978  1438: 0bc0             or ax, ax
  05497A  143A: 741f             je 0x145b
  05497C  143C: 8b1e4285         mov bx, word ptr [0x8542]
  054980  1440: 8b87b600         mov ax, word ptr [bx + 0xb6]
  054984  1444: 3d1400           cmp ax, 0x14
  054987  1447: 7e03             jle 0x144c
  054989  1449: b81400           mov ax, 0x14
  05498C  144C: 2987b600         sub word ptr [bx + 0xb6], ax
  054990  1450: c6878c0000       mov byte ptr [bx + 0x8c], 0
  054995  1455: c786c6fe0100     mov word ptr [bp - 0x13a], 1
  05499B  145B: 8b1e4285         mov bx, word ptr [0x8542]
  05499F  145F: f6471b80         test byte ptr [bx + 0x1b], 0x80
  0549A3  1463: 7503             jne 0x1468
  0549A5  1465: e95f04           jmp 0x18c7
  0549A8  1468: 837eec00         cmp word ptr [bp - 0x14], 0
  0549AC  146C: 7503             jne 0x1471
  0549AE  146E: e95604           jmp 0x18c7
  0549B1  1471: a18e53           mov ax, word ptr [0x538e]
  0549B4  1474: b90700           mov cx, 7
  0549B7  1477: 99               cdq 
  0549B8  1478: f7f9             idiv cx
  0549BA  147A: 0bd2             or dx, dx
  0549BC  147C: 7503             jne 0x1481
  0549BE  147E: e94604           jmp 0x18c7
  0549C1  1481: b8ffff           mov ax, 0xffff
  0549C4  1484: 8946ce           mov word ptr [bp - 0x32], ax
  0549C7  1487: 898694fe         mov word ptr [bp - 0x16c], ax
  0549CB  148B: c746880000       mov word ptr [bp - 0x78], 0
  0549D0  1490: eb7d             jmp 0x150f
  0549D2  1492: 8b7688           mov si, word ptr [bp - 0x78]
  0549D5  1495: 80787000         cmp byte ptr [bx + si + 0x70], 0
  0549D9  1499: 7c43             jl 0x14de
  0549DB  149B: 8a4070           mov al, byte ptr [bx + si + 0x70]
  0549DE  149E: 98               cwde 
  0549DF  149F: 50               push ax
  0549E0  14A0: 9a0e0c1f18       lcall 0x181f, 0xc0e
  0549E5  14A5: 83c402           add sp, 2
  0549E8  14A8: 898614ff         mov word ptr [bp - 0xec], ax
  0549EC  14AC: 3d0400           cmp ax, 4
  0549EF  14AF: 7d15             jge 0x14c6
  0549F1  14B1: ffb654ff         push word ptr [bp - 0xac]
  0549F5  14B5: ffb65cff         push word ptr [bp - 0xa4]
  0549F9  14B9: 9a54071f18       lcall 0x181f, 0x754
  0549FE  14BE: 83c404           add sp, 4
  054A01  14C1: a840             test al, 0x40
  054A03  14C3: eb13             jmp 0x14d8
  054A05  14C5: 90               nop 
  054A06  14C6: ffb654ff         push word ptr [bp - 0xac]
  054A0A  14CA: ffb65cff         push word ptr [bp - 0xa4]
  054A0E  14CE: 9a54071f18       lcall 0x181f, 0x754
  054A13  14D3: 83c404           add sp, 4
  054A16  14D6: a80a             test al, 0xa
  054A18  14D8: 7504             jne 0x14de
  054A1A  14DA: d1a6d0fe         shl word ptr [bp - 0x130], 1
  054A1E  14DE: ffb654ff         push word ptr [bp - 0xac]
  054A22  14E2: ffb65cff         push word ptr [bp - 0xa4]
  054A26  14E6: 9a54071f18       lcall 0x181f, 0x754
  054A2B  14EB: 83c404           add sp, 4
  054A2E  14EE: a80a             test al, 0xa
  054A30  14F0: 7503             jne 0x14f5
  054A32  14F2: e90301           jmp 0x15f8
  054A35  14F5: ffb654ff         push word ptr [bp - 0xac]
  054A39  14F9: ffb65cff         push word ptr [bp - 0xa4]
  054A3D  14FD: 9a54071f18       lcall 0x181f, 0x754
  054A42  1502: 83c404           add sp, 4
  054A45  1505: a840             test al, 0x40
  054A47  1507: 7503             jne 0x150c
  054A49  1509: e9ec00           jmp 0x15f8
  054A4C  150C: ff4688           inc word ptr [bp - 0x78]
  054A4F  150F: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  054A53  1513: 394688           cmp word ptr [bp - 0x78], ax
  054A56  1516: 7c03             jl 0x151b
  054A58  1518: e97f01           jmp 0x169a
  054A5B  151B: 8b5e88           mov bx, word ptr [bp - 0x78]
  054A5E  151E: 8a87de00         mov al, byte ptr [bx + 0xde]
  054A62  1522: 98               cwde 
  054A63  1523: 8b364285         mov si, word ptr [0x8542]
  054A67  1527: 8a4c01           mov cl, byte ptr [si + 1]
  054A6A  152A: 2aed             sub ch, ch
  054A6C  152C: 8bd0             mov dx, ax
  054A6E  152E: 03c1             add ax, cx
  054A70  1530: 898654ff         mov word ptr [bp - 0xac], ax
  054A74  1534: 8bc8             mov cx, ax
  054A76  1536: 8a87c800         mov al, byte ptr [bx + 0xc8]
  054A7A  153A: 98               cwde 
  054A7B  153B: 8bd8             mov bx, ax
  054A7D  153D: 40               inc ax
  054A7E  153E: 40               inc ax
  054A7F  153F: 8946f0           mov word ptr [bp - 0x10], ax
  054A82  1542: 42               inc dx
  054A83  1543: 42               inc dx
  054A84  1544: 8956da           mov word ptr [bp - 0x26], dx
  054A87  1547: 51               push cx
  054A88  1548: 8a04             mov al, byte ptr [si]
  054A8A  154A: 2ae4             sub ah, ah
  054A8C  154C: 03d8             add bx, ax
  054A8E  154E: 899e5cff         mov word ptr [bp - 0xa4], bx
  054A92  1552: 53               push bx
  054A93  1553: 9a02031f18       lcall 0x181f, 0x302
  054A98  1558: 83c404           add sp, 4
  054A9B  155B: 0bc0             or ax, ax
  054A9D  155D: 74ad             je 0x150c
  054A9F  155F: ffb654ff         push word ptr [bp - 0xac]
  054AA3  1563: ffb65cff         push word ptr [bp - 0xa4]
  054AA7  1567: 9a68071f18       lcall 0x181f, 0x768
  054AAC  156C: 83c404           add sp, 4
  054AAF  156F: 0bc0             or ax, ax
  054AB1  1571: 7599             jne 0x150c
  054AB3  1573: 8b76f0           mov si, word ptr [bp - 0x10]
  054AB6  1576: 8bc6             mov ax, si
  054AB8  1578: c1e602           shl si, 2
  054ABB  157B: 03f0             add si, ax
  054ABD  157D: 8b5eda           mov bx, word ptr [bp - 0x26]
  054AC0  1580: 80b8f08d00       cmp byte ptr [bx + si - 0x7210], 0
  054AC5  1585: 7585             jne 0x150c
  054AC7  1587: ffb654ff         push word ptr [bp - 0xac]
  054ACB  158B: ffb65cff         push word ptr [bp - 0xa4]
  054ACF  158F: 9a8c071f18       lcall 0x181f, 0x78c
  054AD4  1594: 83c404           add sp, 4
  054AD7  1597: 898618ff         mov word ptr [bp - 0xe8], ax
  054ADB  159B: ffb654ff         push word ptr [bp - 0xac]
  054ADF  159F: ffb65cff         push word ptr [bp - 0xa4]
  054AE3  15A3: 9a18071f18       lcall 0x181f, 0x718
  054AE8  15A8: 83c404           add sp, 4
  054AEB  15AB: 898664ff         mov word ptr [bp - 0x9c], ax
  054AEF  15AF: 8b9e18ff         mov bx, word ptr [bp - 0xe8]
  054AF3  15B3: c1e304           shl bx, 4
  054AF6  15B6: 8a87792f         mov al, byte ptr [bx + 0x2f79]
  054AFA  15BA: 2ae4             sub ah, ah
  054AFC  15BC: 8986d0fe         mov word ptr [bp - 0x130], ax
  054B00  15C0: 83be64ffff       cmp word ptr [bp - 0x9c], -1
  054B05  15C5: 740c             je 0x15d3
  054B07  15C7: 8b9e64ff         mov bx, word ptr [bp - 0x9c]
  054B0B  15CB: 8a87b297         mov al, byte ptr [bx - 0x684e]
  054B0F  15CF: 8986d0fe         mov word ptr [bp - 0x130], ax
  054B13  15D3: 8b1e4285         mov bx, word ptr [0x8542]
  054B17  15D7: f6471b20         test byte ptr [bx + 0x1b], 0x20
  054B1B  15DB: 7503             jne 0x15e0
  054B1D  15DD: e9b2fe           jmp 0x1492
  054B20  15E0: 83be18ff08       cmp word ptr [bp - 0xe8], 8
  054B25  15E5: 7d03             jge 0x15ea
  054B27  15E7: e9a8fe           jmp 0x1492
  054B2A  15EA: 83be18ff18       cmp word ptr [bp - 0xe8], 0x18
  054B2F  15EF: 7c03             jl 0x15f4
  054B31  15F1: e99efe           jmp 0x1492
  054B34  15F4: d1a6d0fe         shl word ptr [bp - 0x130], 1
  054B38  15F8: 8b76f0           mov si, word ptr [bp - 0x10]
  054B3B  15FB: 8bc6             mov ax, si
  054B3D  15FD: c1e602           shl si, 2
  054B40  1600: 03f0             add si, ax
  054B42  1602: 8b5eda           mov bx, word ptr [bp - 0x26]
  054B45  1605: 8a809e8d         mov al, byte ptr [bx + si - 0x7262]
  054B49  1609: 98               cwde 
  054B4A  160A: 8946fc           mov word ptr [bp - 4], ax
  054B4D  160D: 0bc0             or ax, ax
  054B4F  160F: 7c6b             jl 0x167c
  054B51  1611: ffb652fe         push word ptr [bp - 0x1ae]
  054B55  1615: 50               push ax
  054B56  1616: 9a0c031f18       lcall 0x181f, 0x30c
  054B5B  161B: 83c404           add sp, 4
  054B5E  161E: 89864cfe         mov word ptr [bp - 0x1b4], ax
  054B62  1622: 2d0400           sub ax, 4
  054B65  1625: f7d8             neg ax
  054B67  1627: 89864cfe         mov word ptr [bp - 0x1b4], ax
  054B6B  162B: 83be64ffff       cmp word ptr [bp - 0x9c], -1
  054B70  1630: 7404             je 0x1636
  054B72  1632: d1a64cfe         shl word ptr [bp - 0x1b4], 1
  054B76  1636: 8b5e96           mov bx, word ptr [bp - 0x6a]
  054B79  1639: f687f29501       test byte ptr [bx - 0x6a0e], 1
  054B7E  163E: 7417             je 0x1657
  054B80  1640: 8b1e4285         mov bx, word ptr [0x8542]
  054B84  1644: f6471c20         test byte ptr [bx + 0x1c], 0x20
  054B88  1648: 750d             jne 0x1657
  054B8A  164A: f6471b20         test byte ptr [bx + 0x1b], 0x20
  054B8E  164E: 7503             jne 0x1653
  054B90  1650: e9b9fe           jmp 0x150c
  054B93  1653: d1a64cfe         shl word ptr [bp - 0x1b4], 1
  054B97  1657: 8b1efc84         mov bx, word ptr [0x84fc]
  054B9B  165B: 837f2c00         cmp word ptr [bx + 0x2c], 0
  054B9F  165F: 7f11             jg 0x1672
  054BA1  1661: 7c07             jl 0x166a
  054BA3  1663: 817f2ad007       cmp word ptr [bx + 0x2a], 0x7d0
  054BA8  1668: 7308             jae 0x1672
  054BAA  166A: 8b864cfe         mov ax, word ptr [bp - 0x1b4]
  054BAE  166E: d1e0             shl ax, 1
  054BB0  1670: eb06             jmp 0x1678
  054BB2  1672: 8b864cfe         mov ax, word ptr [bp - 0x1b4]
  054BB6  1676: d1f8             sar ax, 1
  054BB8  1678: 2986d0fe         sub word ptr [bp - 0x130], ax
  054BBC  167C: 8b8694fe         mov ax, word ptr [bp - 0x16c]
  054BC0  1680: 3986d0fe         cmp word ptr [bp - 0x130], ax
  054BC4  1684: 7f03             jg 0x1689
  054BC6  1686: e983fe           jmp 0x150c
  054BC9  1689: 8b86d0fe         mov ax, word ptr [bp - 0x130]
  054BCD  168D: 898694fe         mov word ptr [bp - 0x16c], ax
  054BD1  1691: 8b4688           mov ax, word ptr [bp - 0x78]
  054BD4  1694: 8946ce           mov word ptr [bp - 0x32], ax
  054BD7  1697: e972fe           jmp 0x150c
  054BDA  169A: 837ece00         cmp word ptr [bp - 0x32], 0
  054BDE  169E: 7d03             jge 0x16a3
  054BE0  16A0: e92402           jmp 0x18c7
  054BE3  16A3: 8b5ece           mov bx, word ptr [bp - 0x32]
  054BE6  16A6: 8a87c800         mov al, byte ptr [bx + 0xc8]
  054BEA  16AA: 98               cwde 
  054BEB  16AB: 8b364285         mov si, word ptr [0x8542]
  054BEF  16AF: 8a0c             mov cl, byte ptr [si]
  054BF1  16B1: 2aed             sub ch, ch
  054BF3  16B3: 03c1             add ax, cx
  054BF5  16B5: 89865cff         mov word ptr [bp - 0xa4], ax
  054BF9  16B9: 8a87de00         mov al, byte ptr [bx + 0xde]
  054BFD  16BD: 98               cwde 
  054BFE  16BE: 8a4c01           mov cl, byte ptr [si + 1]
  054C01  16C1: 03c1             add ax, cx
  054C03  16C3: 898654ff         mov word ptr [bp - 0xac], ax
  054C07  16C7: c746fa0100       mov word ptr [bp - 6], 1
  054C0C  16CC: c746880000       mov word ptr [bp - 0x78], 0
  054C11  16D1: 8b5e88           mov bx, word ptr [bp - 0x78]
  054C14  16D4: 8a87be00         mov al, byte ptr [bx + 0xbe]
  054C18  16D8: 98               cwde 
  054C19  16D9: 038654ff         add ax, word ptr [bp - 0xac]
  054C1D  16DD: 8946da           mov word ptr [bp - 0x26], ax
  054C20  16E0: 50               push ax
  054C21  16E1: 8a87b400         mov al, byte ptr [bx + 0xb4]
  054C25  16E5: 98               cwde 
  054C26  16E6: 03865cff         add ax, word ptr [bp - 0xa4]
  054C2A  16EA: 8946f0           mov word ptr [bp - 0x10], ax
  054C2D  16ED: 50               push ax
  054C2E  16EE: 9ad2061f18       lcall 0x181f, 0x6d2
  054C33  16F3: 83c404           add sp, 4
  054C36  16F6: 898652fe         mov word ptr [bp - 0x1ae], ax
  054C3A  16FA: 0bc0             or ax, ax
  054C3C  16FC: 7c14             jl 0x1712
  054C3E  16FE: 3d0400           cmp ax, 4
  054C41  1701: 7d0f             jge 0x1712
  054C43  1703: 6bd834           imul bx, ax, 0x34
  054C46  1706: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  054C4B  170B: 7505             jne 0x1712
  054C4D  170D: c746fa0000       mov word ptr [bp - 6], 0
  054C52  1712: ff4688           inc word ptr [bp - 0x78]
  054C55  1715: 837e8808         cmp word ptr [bp - 0x78], 8
  054C59  1719: 7cb6             jl 0x16d1
  054C5B  171B: ffb654ff         push word ptr [bp - 0xac]
  054C5F  171F: ffb65cff         push word ptr [bp - 0xa4]
  054C63  1723: 9ad2061f18       lcall 0x181f, 0x6d2
  054C68  1728: 83c404           add sp, 4
  054C6B  172B: 8b1e4285         mov bx, word ptr [0x8542]
  054C6F  172F: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  054C72  1732: 2aed             sub ch, ch
  054C74  1734: 3bc8             cmp cx, ax
  054C76  1736: 7505             jne 0x173d
  054C78  1738: c746fa0100       mov word ptr [bp - 6], 1
  054C7D  173D: 837efa00         cmp word ptr [bp - 6], 0
  054C81  1741: 7503             jne 0x1746
  054C83  1743: e98101           jmp 0x18c7
  054C86  1746: ffb654ff         push word ptr [bp - 0xac]
  054C8A  174A: ffb65cff         push word ptr [bp - 0xa4]
  054C8E  174E: 9a8c071f18       lcall 0x181f, 0x78c
  054C93  1753: 83c404           add sp, 4
  054C96  1756: 8bd8             mov bx, ax
  054C98  1758: 899e18ff         mov word ptr [bp - 0xe8], bx
  054C9C  175C: c1e304           shl bx, 4
  054C9F  175F: 8a87782f         mov al, byte ptr [bx + 0x2f78]
  054CA3  1763: 2ae4             sub ah, ah
  054CA5  1765: 40               inc ax
  054CA6  1766: 40               inc ax
  054CA7  1767: 8986befe         mov word ptr [bp - 0x142], ax
  054CAB  176B: 83be18ff08       cmp word ptr [bp - 0xe8], 8
  054CB0  1770: 7c07             jl 0x1779
  054CB2  1772: 83be18ff10       cmp word ptr [bp - 0xe8], 0x10
  054CB7  1777: 7c0e             jl 0x1787
  054CB9  1779: 83be18ff10       cmp word ptr [bp - 0xe8], 0x10
  054CBE  177E: 7c18             jl 0x1798
  054CC0  1780: 83be18ff18       cmp word ptr [bp - 0xe8], 0x18
  054CC5  1785: 7d11             jge 0x1798
  054CC7  1787: 8b1e4285         mov bx, word ptr [0x8542]
  054CCB  178B: f6471b20         test byte ptr [bx + 0x1b], 0x20
  054CCF  178F: 7407             je 0x1798
  054CD1  1791: c746d40100       mov word ptr [bp - 0x2c], 1
  054CD6  1796: eb05             jmp 0x179d
  054CD8  1798: c746d40000       mov word ptr [bp - 0x2c], 0
  054CDD  179D: 837ed400         cmp word ptr [bp - 0x2c], 0
  054CE1  17A1: 7405             je 0x17a8
  054CE3  17A3: 8386befe02       add word ptr [bp - 0x142], 2
  054CE8  17A8: 8a86befe         mov al, byte ptr [bp - 0x142]
  054CEC  17AC: 8b1e4285         mov bx, word ptr [0x8542]
  054CF0  17B0: 38878c00         cmp byte ptr [bx + 0x8c], al
  054CF4  17B4: 7d03             jge 0x17b9
  054CF6  17B6: e90e01           jmp 0x18c7
  054CF9  17B9: 6a00             push 0
  054CFB  17BB: 8a471a           mov al, byte ptr [bx + 0x1a]
  054CFE  17BE: 2ae4             sub ah, ah
  054D00  17C0: 50               push ax
  054D01  17C1: ffb654ff         push word ptr [bp - 0xac]
  054D05  17C5: ffb65cff         push word ptr [bp - 0xa4]
  054D09  17C9: a04e52           mov al, byte ptr [0x524e]
  054D0C  17CC: 50               push ax
  054D0D  17CD: 9a200a1f19       lcall 0x191f, 0xa20
  054D12  17D2: 83c40a           add sp, 0xa
  054D15  17D5: 8986c4fe         mov word ptr [bp - 0x13c], ax
  054D19  17D9: 6bd81c           imul bx, ax, 0x1c
  054D1C  17DC: c6875a3163       mov byte ptr [bx + 0x315a], 0x63
  054D21  17E1: 837ed400         cmp word ptr [bp - 0x2c], 0
  054D25  17E5: 7409             je 0x17f0
  054D27  17E7: 50               push ax
  054D28  17E8: 9ac2011f19       lcall 0x191f, 0x1c2
  054D2D  17ED: e9a900           jmp 0x1899
  054D30  17F0: c78614ffffff     mov word ptr [bp - 0xec], 0xffff
  054D36  17F6: 8b1e4285         mov bx, word ptr [0x8542]
  054D3A  17FA: 8b76ce           mov si, word ptr [bp - 0x32]
  054D3D  17FD: 80787000         cmp byte ptr [bx + si + 0x70], 0
  054D41  1801: 7c11             jl 0x1814
  054D43  1803: 8a4070           mov al, byte ptr [bx + si + 0x70]
  054D46  1806: 98               cwde 
  054D47  1807: 50               push ax
  054D48  1808: 9a0e0c1f18       lcall 0x181f, 0xc0e
  054D4D  180D: 83c402           add sp, 2
  054D50  1810: 898614ff         mov word ptr [bp - 0xec], ax
  054D54  1814: 83be14ff00       cmp word ptr [bp - 0xec], 0
  054D59  1819: 7c21             jl 0x183c
  054D5B  181B: 83be14ff04       cmp word ptr [bp - 0xec], 4
  054D60  1820: 7d1a             jge 0x183c
  054D62  1822: ffb654ff         push word ptr [bp - 0xac]
  054D66  1826: ffb65cff         push word ptr [bp - 0xa4]
  054D6A  182A: 9a54071f18       lcall 0x181f, 0x754
  054D6F  182F: 83c404           add sp, 4
  054D72  1832: a840             test al, 0x40
  054D74  1834: 7506             jne 0x183c
  054D76  1836: ffb6c4fe         push word ptr [bp - 0x13c]
  054D7A  183A: ebac             jmp 0x17e8
  054D7C  183C: 83be14ff04       cmp word ptr [bp - 0xec], 4
  054D81  1841: 7c14             jl 0x1857
  054D83  1843: ffb654ff         push word ptr [bp - 0xac]
  054D87  1847: ffb65cff         push word ptr [bp - 0xa4]
  054D8B  184B: 9a54071f18       lcall 0x181f, 0x754
  054D90  1850: 83c404           add sp, 4
  054D93  1853: a80a             test al, 0xa
  054D95  1855: 7439             je 0x1890
  054D97  1857: 83be18ff02       cmp word ptr [bp - 0xe8], 2
  054D9C  185C: 7c1e             jl 0x187c
  054D9E  185E: 83be18ff07       cmp word ptr [bp - 0xe8], 7
  054DA3  1863: 7f17             jg 0x187c
  054DA5  1865: ffb654ff         push word ptr [bp - 0xac]
  054DA9  1869: ffb65cff         push word ptr [bp - 0xa4]
  054DAD  186D: 9a54071f18       lcall 0x181f, 0x754
  054DB2  1872: 83c404           add sp, 4
  054DB5  1875: a840             test al, 0x40
  054DB7  1877: 7529             jne 0x18a2
  054DB9  1879: ebbb             jmp 0x1836
  054DBB  187B: 90               nop 
  054DBC  187C: ffb654ff         push word ptr [bp - 0xac]
  054DC0  1880: ffb65cff         push word ptr [bp - 0xa4]
  054DC4  1884: 9a54071f18       lcall 0x181f, 0x754
  054DC9  1889: 83c404           add sp, 4
  054DCC  188C: a80a             test al, 0xa
  054DCE  188E: 7512             jne 0x18a2
  054DD0  1890: ffb6c4fe         push word ptr [bp - 0x13c]
  054DD4  1894: 9a16021f19       lcall 0x191f, 0x216
  054DD9  1899: 83c402           add sp, 2
  054DDC  189C: c786c6fe0100     mov word ptr [bp - 0x13a], 1
  054DE2  18A2: 9a060a1f19       lcall 0x191f, 0xa06
  054DE7  18A7: 83bec6fe00       cmp word ptr [bp - 0x13a], 0
  054DEC  18AC: 7419             je 0x18c7
  054DEE  18AE: 8b1e4285         mov bx, word ptr [0x8542]
  054DF2  18B2: 8b87b600         mov ax, word ptr [bx + 0xb6]
  054DF6  18B6: 3d1400           cmp ax, 0x14
  054DF9  18B9: 7e03             jle 0x18be
  054DFB  18BB: b81400           mov ax, 0x14
  054DFE  18BE: 2987b600         sub word ptr [bx + 0xb6], ax
  054E02  18C2: c6878c0000       mov byte ptr [bx + 0x8c], 0
  054E07  18C7: c78656ff0000     mov word ptr [bp - 0xaa], 0
  054E0D  18CD: eb3c             jmp 0x190b
  054E0F  18CF: 90               nop 
  054E10  18D0: ffb656ff         push word ptr [bp - 0xaa]
  054E14  18D4: 9a540c1f18       lcall 0x181f, 0xc54
  054E19  18D9: 83c402           add sp, 2
  054E1C  18DC: 8bb656ff         mov si, word ptr [bp - 0xaa]
  054E20  18E0: d1e6             shl si, 1
  054E22  18E2: 8982d4fe         mov word ptr [bp + si - 0x12c], ax
  054E26  18E6: 2bc0             sub ax, ax
  054E28  18E8: 898254fe         mov word ptr [bp + si - 0x1ac], ax
  054E2C  18EC: 50               push ax
  054E2D  18ED: ffb656ff         push word ptr [bp - 0xaa]
  054E31  18F1: 9a7e0a1f18       lcall 0x181f, 0xa7e
  054E36  18F6: 83c404           add sp, 4
  054E39  18F9: 6a12             push 0x12
  054E3B  18FB: ffb656ff         push word ptr [bp - 0xaa]
  054E3F  18FF: 9a360c1f18       lcall 0x181f, 0xc36
  054E44  1904: 83c404           add sp, 4
  054E47  1907: ff8656ff         inc word ptr [bp - 0xaa]
  054E4B  190B: 8b1e4285         mov bx, word ptr [0x8542]
  054E4F  190F: 8a471f           mov al, byte ptr [bx + 0x1f]
  054E52  1912: 98               cwde 
  054E53  1913: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  054E57  1917: 7fb7             jg 0x18d0
  054E59  1919: c78656ff0000     mov word ptr [bp - 0xaa], 0
  054E5F  191F: 8b1e4285         mov bx, word ptr [0x8542]
  054E63  1923: 8bb656ff         mov si, word ptr [bp - 0xaa]
  054E67  1927: c64070ff         mov byte ptr [bx + si + 0x70], 0xff
  054E6B  192B: ff8656ff         inc word ptr [bp - 0xaa]
  054E6F  192F: 83be56ff14       cmp word ptr [bp - 0xaa], 0x14
  054E74  1934: 7ce9             jl 0x191f
  054E76  1936: c78656ff0000     mov word ptr [bp - 0xaa], 0
  054E7C  193C: ffb656ff         push word ptr [bp - 0xaa]
  054E80  1940: 9ab40b1f18       lcall 0x181f, 0xbb4
  054E85  1945: 83c402           add sp, 2
  054E88  1948: 8bb656ff         mov si, word ptr [bp - 0xaa]
  054E8C  194C: d1e6             shl si, 1
  054E8E  194E: 898298fe         mov word ptr [bp + si - 0x168], ax
  054E92  1952: ff8656ff         inc word ptr [bp - 0xaa]
  054E96  1956: 83be56ff13       cmp word ptr [bp - 0xaa], 0x13
  054E9B  195B: 7cdf             jl 0x193c
  054E9D  195D: 6a14             push 0x14
  054E9F  195F: 6aff             push -1
  054EA1  1961: a14285           mov ax, word ptr [0x8542]
  054EA4  1964: 057000           add ax, 0x70
  054EA7  1967: 50               push ax
  054EA8  1968: 9aae0d1d0d       lcall 0xd1d, 0xdae
  054EAD  196D: 83c406           add sp, 6
  054EB0  1970: 9a040c1f18       lcall 0x181f, 0xc04
  054EB5  1975: 8b1e4285         mov bx, word ptr [0x8542]
  054EB9  1979: 8a471f           mov al, byte ptr [bx + 0x1f]
  054EBC  197C: 98               cwde 
  054EBD  197D: 8b8e60ff         mov cx, word ptr [bp - 0xa0]
  054EC1  1981: d1e1             shl cx, 1
  054EC3  1983: 3bc1             cmp ax, cx
  054EC5  1985: 7d05             jge 0x198c
  054EC7  1987: b80100           mov ax, 1
  054ECA  198A: eb02             jmp 0x198e
  054ECC  198C: 2bc0             sub ax, ax
  054ECE  198E: 894682           mov word ptr [bp - 0x7e], ax
  054ED1  1991: 83bfaa0001       cmp word ptr [bx + 0xaa], 1
  054ED6  1996: 7e10             jle 0x19a8
  054ED8  1998: 8b46cc           mov ax, word ptr [bp - 0x34]
  054EDB  199B: 3987aa00         cmp word ptr [bx + 0xaa], ax
  054EDF  199F: 7d07             jge 0x19a8
  054EE1  19A1: c746e40100       mov word ptr [bp - 0x1c], 1
  054EE6  19A6: eb05             jmp 0x19ad
  054EE8  19A8: c746e40000       mov word ptr [bp - 0x1c], 0
  054EED  19AD: 837e8200         cmp word ptr [bp - 0x7e], 0
  054EF1  19B1: 7506             jne 0x19b9
  054EF3  19B3: 837ee400         cmp word ptr [bp - 0x1c], 0
  054EF7  19B7: 7407             je 0x19c0
  054EF9  19B9: c746840100       mov word ptr [bp - 0x7c], 1
  054EFE  19BE: eb05             jmp 0x19c5
  054F00  19C0: c746840000       mov word ptr [bp - 0x7c], 0
  054F05  19C5: 837e8400         cmp word ptr [bp - 0x7c], 0
  054F09  19C9: 750a             jne 0x19d5
  054F0B  19CB: 83bf9a004b       cmp word ptr [bx + 0x9a], 0x4b
  054F10  19D0: 7c03             jl 0x19d5
  054F12  19D2: e9b400           jmp 0x1a89
  054F15  19D5: c78656ff0000     mov word ptr [bp - 0xaa], 0
  054F1B  19DB: eb16             jmp 0x19f3
  054F1D  19DD: 90               nop 
  054F1E  19DE: 8bb656ff         mov si, word ptr [bp - 0xaa]
  054F22  19E2: d1e6             shl si, 1
  054F24  19E4: c78254fe0100     mov word ptr [bp + si - 0x1ac], 1
  054F2A  19EA: 9a040c1f18       lcall 0x181f, 0xc04
  054F2F  19EF: ff8656ff         inc word ptr [bp - 0xaa]
  054F33  19F3: 8b1e4285         mov bx, word ptr [0x8542]
  054F37  19F7: 8a471f           mov al, byte ptr [bx + 0x1f]
  054F3A  19FA: 98               cwde 
  054F3B  19FB: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  054F3F  19FF: 7f03             jg 0x1a04
  054F41  1A01: e9ce00           jmp 0x1ad2
  054F44  1A04: 837e8200         cmp word ptr [bp - 0x7e], 0
  054F48  1A08: 7512             jne 0x1a1c
  054F4A  1A0A: a10a8e           mov ax, word ptr [0x8e0a]
  054F4D  1A0D: 3906c88d         cmp word ptr [0x8dc8], ax
  054F51  1A11: 7e09             jle 0x1a1c
  054F53  1A13: 837ee400         cmp word ptr [bp - 0x1c], 0
  054F57  1A17: 7503             jne 0x1a1c
  054F59  1A19: e9b600           jmp 0x1ad2
  054F5C  1A1C: 8bb656ff         mov si, word ptr [bp - 0xaa]
  054F60  1A20: d1e6             shl si, 1
  054F62  1A22: 83ba54fe00       cmp word ptr [bp + si - 0x1ac], 0
  054F67  1A27: 75c6             jne 0x19ef
  054F69  1A29: 8bb656ff         mov si, word ptr [bp - 0xaa]
  054F6D  1A2D: d1e6             shl si, 1
  054F6F  1A2F: 83bad4fe00       cmp word ptr [bp + si - 0x12c], 0
  054F74  1A34: 7415             je 0x1a4b
  054F76  1A36: 83bad4fe08       cmp word ptr [bp + si - 0x12c], 8
  054F7B  1A3B: 75b2             jne 0x19ef
  054F7D  1A3D: 6a06             push 6
  054F7F  1A3F: 9afc091f18       lcall 0x181f, 0x9fc
  054F84  1A44: 83c402           add sp, 2
  054F87  1A47: 0bc0             or ax, ax
  054F89  1A49: 74a4             je 0x19ef
  054F8B  1A4B: 8bb656ff         mov si, word ptr [bp - 0xaa]
  054F8F  1A4F: d1e6             shl si, 1
  054F91  1A51: ffb2d4fe         push word ptr [bp + si - 0x12c]
  054F95  1A55: ffb656ff         push word ptr [bp - 0xaa]
  054F99  1A59: 9a6e0b1f18       lcall 0x181f, 0xb6e
  054F9E  1A5E: 83c404           add sp, 4
  054FA1  1A61: 0bc0             or ax, ax
  054FA3  1A63: 758a             jne 0x19ef
  054FA5  1A65: 833ebe8d03       cmp word ptr [0x8dbe], 3
  054FAA  1A6A: 7c03             jl 0x1a6f
  054FAC  1A6C: e96fff           jmp 0x19de
  054FAF  1A6F: ffb656ff         push word ptr [bp - 0xaa]
  054FB3  1A73: 9aa60a1f18       lcall 0x181f, 0xaa6
  054FB8  1A78: 83c402           add sp, 2
  054FBB  1A7B: 6a12             push 0x12
  054FBD  1A7D: ffb656ff         push word ptr [bp - 0xaa]
  054FC1  1A81: 9a360c1f18       lcall 0x181f, 0xc36
  054FC6  1A86: 83c404           add sp, 4
  054FC9  1A89: c7065e030100     mov word ptr [0x35e], 1
  054FCF  1A8F: 83bec0fe00       cmp word ptr [bp - 0x140], 0
  054FD4  1A94: 7417             je 0x1aad
  054FD6  1A96: 8b1e4285         mov bx, word ptr [0x8542]
  054FDA  1A9A: 8a471f           mov al, byte ptr [bx + 0x1f]
  054FDD  1A9D: 98               cwde 
  054FDE  1A9E: 8b8e60ff         mov cx, word ptr [bp - 0xa0]
  054FE2  1AA2: 2b8ec0fe         sub cx, word ptr [bp - 0x140]
  054FE6  1AA6: 3bc8             cmp cx, ax
  054FE8  1AA8: 7f03             jg 0x1aad
  054FEA  1AAA: e9e201           jmp 0x1c8f
  054FED  1AAD: 9a7c0c1f18       lcall 0x181f, 0xc7c
  054FF2  1AB2: 8b1e4285         mov bx, word ptr [0x8542]
  054FF6  1AB6: 3a471f           cmp al, byte ptr [bx + 0x1f]
  054FF9  1AB9: 7f03             jg 0x1abe
  054FFB  1ABB: e9d101           jmp 0x1c8f
  054FFE  1ABE: b8ffff           mov ax, 0xffff
  055001  1AC1: 898694fe         mov word ptr [bp - 0x16c], ax
  055005  1AC5: 8946ce           mov word ptr [bp - 0x32], ax
  055008  1AC8: c78656ff0000     mov word ptr [bp - 0xaa], 0
  05500E  1ACE: e97001           jmp 0x1c41
  055011  1AD1: 90               nop 
  055012  1AD2: c7861cff0000     mov word ptr [bp - 0xe4], 0
  055018  1AD8: e9dd00           jmp 0x1bb8
  05501B  1ADB: 90               nop 
  05501C  1ADC: 2bc0             sub ax, ax
  05501E  1ADE: 89867eff         mov word ptr [bp - 0x82], ax
  055022  1AE2: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055026  1AE6: d1e6             shl si, 1
  055028  1AE8: ffb2d4fe         push word ptr [bp + si - 0x12c]
  05502C  1AEC: 9a9a0c1f18       lcall 0x181f, 0xc9a
  055031  1AF1: 83c402           add sp, 2
  055034  1AF4: 0bc0             or ax, ax
  055036  1AF6: 745d             je 0x1b55
  055038  1AF8: 83be7eff00       cmp word ptr [bp - 0x82], 0
  05503D  1AFD: 744f             je 0x1b4e
  05503F  1AFF: ff8656ff         inc word ptr [bp - 0xaa]
  055043  1B03: 8b1e4285         mov bx, word ptr [0x8542]
  055047  1B07: 8a471f           mov al, byte ptr [bx + 0x1f]
  05504A  1B0A: 98               cwde 
  05504B  1B0B: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  05504F  1B0F: 7f03             jg 0x1b14
  055051  1B11: e9a000           jmp 0x1bb4
  055054  1B14: 833e328e00       cmp word ptr [0x8e32], 0
  055059  1B19: 740c             je 0x1b27
  05505B  1B1B: a1328e           mov ax, word ptr [0x8e32]
  05505E  1B1E: c1e004           shl ax, 4
  055061  1B21: 39879a00         cmp word ptr [bx + 0x9a], ax
  055065  1B25: 7e09             jle 0x1b30
  055067  1B27: 837e8400         cmp word ptr [bp - 0x7c], 0
  05506B  1B2B: 7503             jne 0x1b30
  05506D  1B2D: e98400           jmp 0x1bb4
  055070  1B30: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055074  1B34: d1e6             shl si, 1
  055076  1B36: 83ba54fe00       cmp word ptr [bp + si - 0x1ac], 0
  05507B  1B3B: 75c2             jne 0x1aff
  05507D  1B3D: a1328e           mov ax, word ptr [0x8e32]
  055080  1B40: c1e004           shl ax, 4
  055083  1B43: 39879a00         cmp word ptr [bx + 0x9a], ax
  055087  1B47: 7e93             jle 0x1adc
  055089  1B49: b80100           mov ax, 1
  05508C  1B4C: eb90             jmp 0x1ade
  05508E  1B4E: 83be1cff00       cmp word ptr [bp - 0xe4], 0
  055093  1B53: 74aa             je 0x1aff
  055095  1B55: 83be7eff00       cmp word ptr [bp - 0x82], 0
  05509A  1B5A: 7414             je 0x1b70
  05509C  1B5C: 83be1cff00       cmp word ptr [bp - 0xe4], 0
  0550A1  1B61: 750d             jne 0x1b70
  0550A3  1B63: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0550A7  1B67: d1e6             shl si, 1
  0550A9  1B69: 83bad4fe1b       cmp word ptr [bp + si - 0x12c], 0x1b
  0550AE  1B6E: 758f             jne 0x1aff
  0550B0  1B70: 6aff             push -1
  0550B2  1B72: ffb656ff         push word ptr [bp - 0xaa]
  0550B6  1B76: 9a6e0b1f18       lcall 0x181f, 0xb6e
  0550BB  1B7B: 83c404           add sp, 4
  0550BE  1B7E: 0bc0             or ax, ax
  0550C0  1B80: 7403             je 0x1b85
  0550C2  1B82: e97aff           jmp 0x1aff
  0550C5  1B85: 833ebe8d03       cmp word ptr [0x8dbe], 3
  0550CA  1B8A: 7d03             jge 0x1b8f
  0550CC  1B8C: e9e0fe           jmp 0x1a6f
  0550CF  1B8F: 39867eff         cmp word ptr [bp - 0x82], ax
  0550D3  1B93: 740a             je 0x1b9f
  0550D5  1B95: 833ebe8d05       cmp word ptr [0x8dbe], 5
  0550DA  1B9A: 7d03             jge 0x1b9f
  0550DC  1B9C: e9d0fe           jmp 0x1a6f
  0550DF  1B9F: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0550E3  1BA3: d1e6             shl si, 1
  0550E5  1BA5: c78254fe0100     mov word ptr [bp + si - 0x1ac], 1
  0550EB  1BAB: 9a040c1f18       lcall 0x181f, 0xc04
  0550F0  1BB0: e94cff           jmp 0x1aff
  0550F3  1BB3: 90               nop 
  0550F4  1BB4: ff861cff         inc word ptr [bp - 0xe4]
  0550F8  1BB8: 83be1cff02       cmp word ptr [bp - 0xe4], 2
  0550FD  1BBD: 7c03             jl 0x1bc2
  0550FF  1BBF: e9c7fe           jmp 0x1a89
  055102  1BC2: c78656ff0000     mov word ptr [bp - 0xaa], 0
  055108  1BC8: e938ff           jmp 0x1b03
  05510B  1BCB: 90               nop 
  05510C  1BCC: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055110  1BD0: d1e6             shl si, 1
  055112  1BD2: 83ba54fe00       cmp word ptr [bp + si - 0x1ac], 0
  055117  1BD7: 7564             jne 0x1c3d
  055119  1BD9: 6afe             push -2
  05511B  1BDB: ffb656ff         push word ptr [bp - 0xaa]
  05511F  1BDF: 9a6e0b1f18       lcall 0x181f, 0xb6e
  055124  1BE4: 83c404           add sp, 4
  055127  1BE7: 0bc0             or ax, ax
  055129  1BE9: 7552             jne 0x1c3d
  05512B  1BEB: c126c08d02       shl word ptr [0x8dc0], 2
  055130  1BF0: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055134  1BF4: d1e6             shl si, 1
  055136  1BF6: ffb2d4fe         push word ptr [bp + si - 0x12c]
  05513A  1BFA: 9a9a0c1f18       lcall 0x181f, 0xc9a
  05513F  1BFF: 83c402           add sp, 2
  055142  1C02: 0bc0             or ax, ax
  055144  1C04: 7504             jne 0x1c0a
  055146  1C06: ff06c08d         inc word ptr [0x8dc0]
  05514A  1C0A: a1c28d           mov ax, word ptr [0x8dc2]
  05514D  1C0D: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055151  1C11: d1e6             shl si, 1
  055153  1C13: 3982d4fe         cmp word ptr [bp + si - 0x12c], ax
  055157  1C17: 7505             jne 0x1c1e
  055159  1C19: 8306c08d02       add word ptr [0x8dc0], 2
  05515E  1C1E: 8b8694fe         mov ax, word ptr [bp - 0x16c]
  055162  1C22: 3906c08d         cmp word ptr [0x8dc0], ax
  055166  1C26: 7e15             jle 0x1c3d
  055168  1C28: 833ebe8d02       cmp word ptr [0x8dbe], 2
  05516D  1C2D: 7c0e             jl 0x1c3d
  05516F  1C2F: a1c08d           mov ax, word ptr [0x8dc0]
  055172  1C32: 898694fe         mov word ptr [bp - 0x16c], ax
  055176  1C36: 8b8656ff         mov ax, word ptr [bp - 0xaa]
  05517A  1C3A: 8946ce           mov word ptr [bp - 0x32], ax
  05517D  1C3D: ff8656ff         inc word ptr [bp - 0xaa]
  055181  1C41: 8b1e4285         mov bx, word ptr [0x8542]
  055185  1C45: 8a471f           mov al, byte ptr [bx + 0x1f]
  055188  1C48: 98               cwde 
  055189  1C49: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  05518D  1C4D: 7e03             jle 0x1c52
  05518F  1C4F: e97aff           jmp 0x1bcc
  055192  1C52: 837ece00         cmp word ptr [bp - 0x32], 0
  055196  1C56: 7c37             jl 0x1c8f
  055198  1C58: 6aff             push -1
  05519A  1C5A: ff76ce           push word ptr [bp - 0x32]
  05519D  1C5D: 9a6e0b1f18       lcall 0x181f, 0xb6e
  0551A2  1C62: 83c404           add sp, 4
  0551A5  1C65: 0bc0             or ax, ax
  0551A7  1C67: 7526             jne 0x1c8f
  0551A9  1C69: 8b76ce           mov si, word ptr [bp - 0x32]
  0551AC  1C6C: d1e6             shl si, 1
  0551AE  1C6E: c78254fe0100     mov word ptr [bp + si - 0x1ac], 1
  0551B4  1C74: 9a040c1f18       lcall 0x181f, 0xc04
  0551B9  1C79: ff76ce           push word ptr [bp - 0x32]
  0551BC  1C7C: 9a0e0c1f18       lcall 0x181f, 0xc0e
  0551C1  1C81: 83c402           add sp, 2
  0551C4  1C84: 3d0500           cmp ax, 5
  0551C7  1C87: 7506             jne 0x1c8f
  0551C9  1C89: c78676ff0100     mov word ptr [bp - 0x8a], 1
  0551CF  1C8F: c746ee0000       mov word ptr [bp - 0x12], 0
  0551D4  1C94: 8b1e4285         mov bx, word ptr [0x8542]
  0551D8  1C98: f6471d80         test byte ptr [bx + 0x1d], 0x80
  0551DC  1C9C: 7403             je 0x1ca1
  0551DE  1C9E: e92102           jmp 0x1ec2
  0551E1  1CA1: c746ee0100       mov word ptr [bp - 0x12], 1
  0551E6  1CA6: 83be76ff00       cmp word ptr [bp - 0x8a], 0
  0551EB  1CAB: 7403             je 0x1cb0
  0551ED  1CAD: e9a600           jmp 0x1d56
  0551F0  1CB0: 83bfa4000a       cmp word ptr [bx + 0xa4], 0xa
  0551F5  1CB5: 7c03             jl 0x1cba
  0551F7  1CB7: e99c00           jmp 0x1d56
  0551FA  1CBA: c7861cff0000     mov word ptr [bp - 0xe4], 0
  055200  1CC0: e98300           jmp 0x1d46
  055203  1CC3: 90               nop 
  055204  1CC4: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055208  1CC8: d1e6             shl si, 1
  05520A  1CCA: 83bad4fe05       cmp word ptr [bp + si - 0x12c], 5
  05520F  1CCF: 7431             je 0x1d02
  055211  1CD1: ff8656ff         inc word ptr [bp - 0xaa]
  055215  1CD5: 8b1e4285         mov bx, word ptr [0x8542]
  055219  1CD9: 8a471f           mov al, byte ptr [bx + 0x1f]
  05521C  1CDC: 98               cwde 
  05521D  1CDD: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  055221  1CE1: 7e5f             jle 0x1d42
  055223  1CE3: 833ed28d00       cmp word ptr [0x8dd2], 0
  055228  1CE8: 7558             jne 0x1d42
  05522A  1CEA: 8bb656ff         mov si, word ptr [bp - 0xaa]
  05522E  1CEE: d1e6             shl si, 1
  055230  1CF0: 83ba54fe00       cmp word ptr [bp + si - 0x1ac], 0
  055235  1CF5: 75da             jne 0x1cd1
  055237  1CF7: 8b861cff         mov ax, word ptr [bp - 0xe4]
  05523B  1CFB: 0bc0             or ax, ax
  05523D  1CFD: 74c5             je 0x1cc4
  05523F  1CFF: 48               dec ax
  055240  1D00: 742a             je 0x1d2c
  055242  1D02: 6a05             push 5
  055244  1D04: ffb656ff         push word ptr [bp - 0xaa]
  055248  1D08: 9a6e0b1f18       lcall 0x181f, 0xb6e
  05524D  1D0D: 83c404           add sp, 4
  055250  1D10: 0bc0             or ax, ax
  055252  1D12: 75bd             jne 0x1cd1
  055254  1D14: b80100           mov ax, 1
  055257  1D17: 8bb656ff         mov si, word ptr [bp - 0xaa]
  05525B  1D1B: d1e6             shl si, 1
  05525D  1D1D: 898254fe         mov word ptr [bp + si - 0x1ac], ax
  055261  1D21: 898676ff         mov word ptr [bp - 0x8a], ax
  055265  1D25: 9a040c1f18       lcall 0x181f, 0xc04
  05526A  1D2A: eba5             jmp 0x1cd1
  05526C  1D2C: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055270  1D30: d1e6             shl si, 1
  055272  1D32: ffb2d4fe         push word ptr [bp + si - 0x12c]
  055276  1D36: 9a9a0c1f18       lcall 0x181f, 0xc9a
  05527B  1D3B: 83c402           add sp, 2
  05527E  1D3E: 0bc0             or ax, ax
  055280  1D40: eb8d             jmp 0x1ccf
  055282  1D42: ff861cff         inc word ptr [bp - 0xe4]
  055286  1D46: 83be1cff03       cmp word ptr [bp - 0xe4], 3
  05528B  1D4B: 7d09             jge 0x1d56
  05528D  1D4D: c78656ff0000     mov word ptr [bp - 0xaa], 0
  055293  1D53: e97fff           jmp 0x1cd5
  055296  1D56: 83be76ff00       cmp word ptr [bp - 0x8a], 0
  05529B  1D5B: 7533             jne 0x1d90
  05529D  1D5D: 8b1e4285         mov bx, word ptr [0x8542]
  0552A1  1D61: 83bfa40002       cmp word ptr [bx + 0xa4], 2
  0552A6  1D66: 7d28             jge 0x1d90
  0552A8  1D68: f6068e5307       test byte ptr [0x538e], 7
  0552AD  1D6D: 7521             jne 0x1d90
  0552AF  1D6F: 8387a40064       add word ptr [bx + 0xa4], 0x64
  0552B4  1D74: 8b1efc84         mov bx, word ptr [0x84fc]
  0552B8  1D78: 837f2c00         cmp word ptr [bx + 0x2c], 0
  0552BC  1D7C: 7c12             jl 0x1d90
  0552BE  1D7E: 7f07             jg 0x1d87
  0552C0  1D80: 817f2ac800       cmp word ptr [bx + 0x2a], 0xc8
  0552C5  1D85: 7209             jb 0x1d90
  0552C7  1D87: 816f2ac800       sub word ptr [bx + 0x2a], 0xc8
  0552CC  1D8C: 835f2c00         sbb word ptr [bx + 0x2c], 0
  0552D0  1D90: 8b1e4285         mov bx, word ptr [0x8542]
  0552D4  1D94: 8b87a400         mov ax, word ptr [bx + 0xa4]
  0552D8  1D98: 0306d28d         add ax, word ptr [0x8dd2]
  0552DC  1D9C: 894698           mov word ptr [bp - 0x68], ax
  0552DF  1D9F: 3d0200           cmp ax, 2
  0552E2  1DA2: 7d03             jge 0x1da7
  0552E4  1DA4: e91b01           jmp 0x1ec2
  0552E7  1DA7: c7861cff0000     mov word ptr [bp - 0xe4], 0
  0552ED  1DAD: e90201           jmp 0x1eb2
  0552F0  1DB0: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0552F4  1DB4: d1e6             shl si, 1
  0552F6  1DB6: 83bad4fe0d       cmp word ptr [bp + si - 0x12c], 0xd
  0552FB  1DBB: 7440             je 0x1dfd
  0552FD  1DBD: ff8656ff         inc word ptr [bp - 0xaa]
  055301  1DC1: 8b1e4285         mov bx, word ptr [0x8542]
  055305  1DC5: 8a471f           mov al, byte ptr [bx + 0x1f]
  055308  1DC8: 98               cwde 
  055309  1DC9: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  05530D  1DCD: 7f03             jg 0x1dd2
  05530F  1DCF: e9dc00           jmp 0x1eae
  055312  1DD2: 833ee88d00       cmp word ptr [0x8de8], 0
  055317  1DD7: 7403             je 0x1ddc
  055319  1DD9: e9d200           jmp 0x1eae
  05531C  1DDC: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055320  1DE0: d1e6             shl si, 1
  055322  1DE2: 83ba54fe00       cmp word ptr [bp + si - 0x1ac], 0
  055327  1DE7: 75d4             jne 0x1dbd
  055329  1DE9: 8b861cff         mov ax, word ptr [bp - 0xe4]
  05532D  1DED: 0bc0             or ax, ax
  05532F  1DEF: 74bf             je 0x1db0
  055331  1DF1: 48               dec ax
  055332  1DF2: 7503             jne 0x1df7
  055334  1DF4: e99b00           jmp 0x1e92
  055337  1DF7: 48               dec ax
  055338  1DF8: 7503             jne 0x1dfd
  05533A  1DFA: e9a300           jmp 0x1ea0
  05533D  1DFD: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055341  1E01: d1e6             shl si, 1
  055343  1E03: 83bad4fe1a       cmp word ptr [bp + si - 0x12c], 0x1a
  055348  1E08: 7407             je 0x1e11
  05534A  1E0A: 83bad4fe19       cmp word ptr [bp + si - 0x12c], 0x19
  05534F  1E0F: 750e             jne 0x1e1f
  055351  1E11: 6a1c             push 0x1c
  055353  1E13: ffb656ff         push word ptr [bp - 0xaa]
  055357  1E17: 9aae0c1f18       lcall 0x181f, 0xcae
  05535C  1E1C: 83c404           add sp, 4
  05535F  1E1F: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055363  1E23: d1e6             shl si, 1
  055365  1E25: ffb2d4fe         push word ptr [bp + si - 0x12c]
  055369  1E29: 9a9a0c1f18       lcall 0x181f, 0xc9a
  05536E  1E2E: 83c402           add sp, 2
  055371  1E31: 0bc0             or ax, ax
  055373  1E33: 7536             jne 0x1e6b
  055375  1E35: 3946b4           cmp word ptr [bp - 0x4c], ax
  055378  1E38: 7531             jne 0x1e6b
  05537A  1E3A: 8b1e4285         mov bx, word ptr [0x8542]
  05537E  1E3E: 807f1f06         cmp byte ptr [bx + 0x1f], 6
  055382  1E42: 7c27             jl 0x1e6b
  055384  1E44: a0a653           mov al, byte ptr [0x53a6]
  055387  1E47: 2ae4             sub ah, ah
  055389  1E49: 2d1000           sub ax, 0x10
  05538C  1E4C: f7d8             neg ax
  05538E  1E4E: 50               push ax
  05538F  1E4F: 6a00             push 0
  055391  1E51: 9ad4041f18       lcall 0x181f, 0x4d4
  055396  1E56: 83c404           add sp, 4
  055399  1E59: 0bc0             or ax, ax
  05539B  1E5B: 750e             jne 0x1e6b
  05539D  1E5D: 6a0d             push 0xd
  05539F  1E5F: ffb656ff         push word ptr [bp - 0xaa]
  0553A3  1E63: 9aae0c1f18       lcall 0x181f, 0xcae
  0553A8  1E68: 83c404           add sp, 4
  0553AB  1E6B: 6a0d             push 0xd
  0553AD  1E6D: ffb656ff         push word ptr [bp - 0xaa]
  0553B1  1E71: 9a360c1f18       lcall 0x181f, 0xc36
  0553B6  1E76: 83c404           add sp, 4
  0553B9  1E79: ff8638ff         inc word ptr [bp - 0xc8]
  0553BD  1E7D: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0553C1  1E81: d1e6             shl si, 1
  0553C3  1E83: c78254fe0100     mov word ptr [bp + si - 0x1ac], 1
  0553C9  1E89: 9a040c1f18       lcall 0x181f, 0xc04
  0553CE  1E8E: e92cff           jmp 0x1dbd
  0553D1  1E91: 90               nop 
  0553D2  1E92: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0553D6  1E96: d1e6             shl si, 1
  0553D8  1E98: 83bad4fe1c       cmp word ptr [bp + si - 0x12c], 0x1c
  0553DD  1E9D: e91bff           jmp 0x1dbb
  0553E0  1EA0: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0553E4  1EA4: d1e6             shl si, 1
  0553E6  1EA6: 83bad4fe19       cmp word ptr [bp + si - 0x12c], 0x19
  0553EB  1EAB: e90dff           jmp 0x1dbb
  0553EE  1EAE: ff861cff         inc word ptr [bp - 0xe4]
  0553F2  1EB2: 83be1cff04       cmp word ptr [bp - 0xe4], 4
  0553F7  1EB7: 7d09             jge 0x1ec2
  0553F9  1EB9: c78656ff0000     mov word ptr [bp - 0xaa], 0
  0553FF  1EBF: e9fffe           jmp 0x1dc1
  055402  1EC2: c78656ff0000     mov word ptr [bp - 0xaa], 0
  055408  1EC8: eb18             jmp 0x1ee2
  05540A  1ECA: 8bb656ff         mov si, word ptr [bp - 0xaa]
  05540E  1ECE: d1e6             shl si, 1
  055410  1ED0: 83bad4fe00       cmp word ptr [bp + si - 0x12c], 0
  055415  1ED5: 7407             je 0x1ede
  055417  1ED7: 83bad4fe08       cmp word ptr [bp + si - 0x12c], 8
  05541C  1EDC: 7542             jne 0x1f20
  05541E  1EDE: ff8656ff         inc word ptr [bp - 0xaa]
  055422  1EE2: 8b1e4285         mov bx, word ptr [0x8542]
  055426  1EE6: 8a471f           mov al, byte ptr [bx + 0x1f]
  055429  1EE9: 98               cwde 
  05542A  1EEA: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  05542E  1EEE: 7f03             jg 0x1ef3
  055430  1EF0: e99f00           jmp 0x1f92
  055433  1EF3: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055437  1EF7: d1e6             shl si, 1
  055439  1EF9: 83ba54fe00       cmp word ptr [bp + si - 0x1ac], 0
  05543E  1EFE: 75de             jne 0x1ede
  055440  1F00: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055444  1F04: d1e6             shl si, 1
  055446  1F06: ffb2d4fe         push word ptr [bp + si - 0x12c]
  05544A  1F0A: 9a9a0c1f18       lcall 0x181f, 0xc9a
  05544F  1F0F: 83c402           add sp, 2
  055452  1F12: 0bc0             or ax, ax
  055454  1F14: 74c8             je 0x1ede
  055456  1F16: 83bad4fe09       cmp word ptr [bp + si - 0x12c], 9
  05545B  1F1B: 7cad             jl 0x1eca
  05545D  1F1D: ebbf             jmp 0x1ede
  05545F  1F1F: 90               nop 
  055460  1F20: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055464  1F24: d1e6             shl si, 1
  055466  1F26: 83bad4fe05       cmp word ptr [bp + si - 0x12c], 5
  05546B  1F2B: 751e             jne 0x1f4b
  05546D  1F2D: 837eee00         cmp word ptr [bp - 0x12], 0
  055471  1F31: 7507             jne 0x1f3a
  055473  1F33: c746ee0100       mov word ptr [bp - 0x12], 1
  055478  1F38: eb11             jmp 0x1f4b
  05547A  1F3A: 8b1e4285         mov bx, word ptr [0x8542]
  05547E  1F3E: f6471b20         test byte ptr [bx + 0x1b], 0x20
  055482  1F42: 7507             jne 0x1f4b
  055484  1F44: 833e648e00       cmp word ptr [0x8e64], 0
  055489  1F49: 7493             je 0x1ede
  05548B  1F4B: 8b46cc           mov ax, word ptr [bp - 0x34]
  05548E  1F4E: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055492  1F52: d1e6             shl si, 1
  055494  1F54: 8bb2d4fe         mov si, word ptr [bp + si - 0x12c]
  055498  1F58: d1e6             shl si, 1
  05549A  1F5A: 8b1e4285         mov bx, word ptr [0x8542]
  05549E  1F5E: 39809a00         cmp word ptr [bx + si + 0x9a], ax
  0554A2  1F62: 7e03             jle 0x1f67
  0554A4  1F64: e977ff           jmp 0x1ede
  0554A7  1F67: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0554AB  1F6B: d1e6             shl si, 1
  0554AD  1F6D: ffb2d4fe         push word ptr [bp + si - 0x12c]
  0554B1  1F71: ffb656ff         push word ptr [bp - 0xaa]
  0554B5  1F75: 9a6e0b1f18       lcall 0x181f, 0xb6e
  0554BA  1F7A: 83c404           add sp, 4
  0554BD  1F7D: 0bc0             or ax, ax
  0554BF  1F7F: 7403             je 0x1f84
  0554C1  1F81: e95aff           jmp 0x1ede
  0554C4  1F84: c78254fe0100     mov word ptr [bp + si - 0x1ac], 1
  0554CA  1F8A: 9a040c1f18       lcall 0x181f, 0xc04
  0554CF  1F8F: e94cff           jmp 0x1ede
  0554D2  1F92: c78656ff0000     mov word ptr [bp - 0xaa], 0
  0554D8  1F98: eb17             jmp 0x1fb1
  0554DA  1F9A: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0554DE  1F9E: d1e6             shl si, 1
  0554E0  1FA0: 8bb2d4fe         mov si, word ptr [bp + si - 0x12c]
  0554E4  1FA4: d1e6             shl si, 1
  0554E6  1FA6: 83ba98fe00       cmp word ptr [bp + si - 0x168], 0
  0554EB  1FAB: 7549             jne 0x1ff6
  0554ED  1FAD: ff8656ff         inc word ptr [bp - 0xaa]
  0554F1  1FB1: 8b1e4285         mov bx, word ptr [0x8542]
  0554F5  1FB5: 8a471f           mov al, byte ptr [bx + 0x1f]
  0554F8  1FB8: 98               cwde 
  0554F9  1FB9: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  0554FD  1FBD: 7f03             jg 0x1fc2
  0554FF  1FBF: e98601           jmp 0x2148
  055502  1FC2: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055506  1FC6: d1e6             shl si, 1
  055508  1FC8: 83ba54fe00       cmp word ptr [bp + si - 0x1ac], 0
  05550D  1FCD: 75de             jne 0x1fad
  05550F  1FCF: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055513  1FD3: d1e6             shl si, 1
  055515  1FD5: ffb2d4fe         push word ptr [bp + si - 0x12c]
  055519  1FD9: 9a9a0c1f18       lcall 0x181f, 0xc9a
  05551E  1FDE: 83c402           add sp, 2
  055521  1FE1: 0bc0             or ax, ax
  055523  1FE3: 74c8             je 0x1fad
  055525  1FE5: 83bad4fe09       cmp word ptr [bp + si - 0x12c], 9
  05552A  1FEA: 7cc1             jl 0x1fad
  05552C  1FEC: 83bad4fe13       cmp word ptr [bp + si - 0x12c], 0x13
  055531  1FF1: 7ca7             jl 0x1f9a
  055533  1FF3: ebb8             jmp 0x1fad
  055535  1FF5: 90               nop 
  055536  1FF6: 8bb656ff         mov si, word ptr [bp - 0xaa]
  05553A  1FFA: d1e6             shl si, 1
  05553C  1FFC: 8bb2d4fe         mov si, word ptr [bp + si - 0x12c]
  055540  2000: d1e6             shl si, 1
  055542  2002: 83ba1eff03       cmp word ptr [bp + si - 0xe2], 3
  055547  2007: 7da4             jge 0x1fad
  055549  2009: c7867aff0000     mov word ptr [bp - 0x86], 0
  05554F  200F: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055553  2013: d1e6             shl si, 1
  055555  2015: 8b82d4fe         mov ax, word ptr [bp + si - 0x12c]
  055559  2019: e9d200           jmp 0x20ee
  05555C  201C: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055560  2020: d1e6             shl si, 1
  055562  2022: 8b9ad4fe         mov bx, word ptr [bp + si - 0x12c]
  055566  2026: 8a87a202         mov al, byte ptr [bx + 0x2a2]
  05556A  202A: 98               cwde 
  05556B  202B: 8bd8             mov bx, ax
  05556D  202D: 899e7eff         mov word ptr [bp - 0x82], bx
  055571  2031: d1e3             shl bx, 1
  055573  2033: 83bf5a8e00       cmp word ptr [bx - 0x71a6], 0
  055578  2038: 7403             je 0x203d
  05557A  203A: e9d300           jmp 0x2110
  05557D  203D: 8bc3             mov ax, bx
  05557F  203F: 8b1e4285         mov bx, word ptr [0x8542]
  055583  2043: 8bf0             mov si, ax
  055585  2045: 83b89a0000       cmp word ptr [bx + si + 0x9a], 0
  05558A  204A: 7f0a             jg 0x2056
  05558C  204C: 83bcc88d00       cmp word ptr [si - 0x7238], 0
  055591  2051: 7503             jne 0x2056
  055593  2053: e9ba00           jmp 0x2110
  055596  2056: c7867aff0100     mov word ptr [bp - 0x86], 1
  05559C  205C: e9b100           jmp 0x2110
  05559F  205F: 90               nop 
  0555A0  2060: a08253           mov al, byte ptr [0x5382]
  0555A3  2063: 250100           and ax, 1
  0555A6  2066: 3d0100           cmp ax, 1
  0555A9  2069: 1bc9             sbb cx, cx
  0555AB  206B: f7d9             neg cx
  0555AD  206D: 898e7aff         mov word ptr [bp - 0x86], cx
  0555B1  2071: 0bc0             or ax, ax
  0555B3  2073: 7503             jne 0x2078
  0555B5  2075: e99800           jmp 0x2110
  0555B8  2078: b81c00           mov ax, 0x1c
  0555BB  207B: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0555BF  207F: d1e6             shl si, 1
  0555C1  2081: 8982d4fe         mov word ptr [bp + si - 0x12c], ax
  0555C5  2085: 50               push ax
  0555C6  2086: ffb656ff         push word ptr [bp - 0xaa]
  0555CA  208A: 9aae0c1f18       lcall 0x181f, 0xcae
  0555CF  208F: 83c404           add sp, 4
  0555D2  2092: ff4eba           dec word ptr [bp - 0x46]
  0555D5  2095: e915ff           jmp 0x1fad
  0555D8  2098: a08253           mov al, byte ptr [0x5382]
  0555DB  209B: 250100           and ax, 1
  0555DE  209E: 3d0100           cmp ax, 1
  0555E1  20A1: 1bc0             sbb ax, ax
  0555E3  20A3: f7d8             neg ax
  0555E5  20A5: 89867aff         mov word ptr [bp - 0x86], ax
  0555E9  20A9: eb65             jmp 0x2110
  0555EB  20AB: 90               nop 
  0555EC  20AC: 8b1e4285         mov bx, word ptr [0x8542]
  0555F0  20B0: f6471d80         test byte ptr [bx + 0x1d], 0x80
  0555F4  20B4: 7426             je 0x20dc
  0555F6  20B6: 837eb401         cmp word ptr [bp - 0x4c], 1
  0555FA  20BA: 7e20             jle 0x20dc
  0555FC  20BC: b81c00           mov ax, 0x1c
  0555FF  20BF: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055603  20C3: d1e6             shl si, 1
  055605  20C5: 8982d4fe         mov word ptr [bp + si - 0x12c], ax
  055609  20C9: 50               push ax
  05560A  20CA: ffb656ff         push word ptr [bp - 0xaa]
  05560E  20CE: 9aae0c1f18       lcall 0x181f, 0xcae
  055613  20D3: 83c404           add sp, 4
  055616  20D6: ff4eb4           dec word ptr [bp - 0x4c]
  055619  20D9: e9d1fe           jmp 0x1fad
  05561C  20DC: 833e648e00       cmp word ptr [0x8e64], 0
  055621  20E1: 752d             jne 0x2110
  055623  20E3: 8b87a400         mov ax, word ptr [bx + 0xa4]
  055627  20E7: 0306d28d         add ax, word ptr [0x8dd2]
  05562B  20EB: e963ff           jmp 0x2051
  05562E  20EE: 2d0900           sub ax, 9
  055631  20F1: 3d0800           cmp ax, 8
  055634  20F4: 771a             ja 0x2110
  055636  20F6: d1e0             shl ax, 1
  055638  20F8: 93               xchg bx, ax
  055639  20F9: 2effa71e1e       jmp word ptr cs:[bx + 0x1e1e]
  05563E  20FE: 3c1d             cmp al, 0x1d
  055640  2100: 3c1d             cmp al, 0x1d
  055642  2102: 3c1d             cmp al, 0x1d
  055644  2104: 3c1d             cmp al, 0x1d
  055646  2106: cc               int3 
  055647  2107: 1d3c1d           sbb ax, 0x1d3c
  05564A  210A: 3c1d             cmp al, 0x1d
  05564C  210C: 801db8           sbb byte ptr [di], 0xb8
  05564F  210F: 1d83be           sbb ax, 0xbe83
  055652  2112: 7aff             jp 0x2113
  055654  2114: 007503           add byte ptr [di + 3], dh
  055657  2117: e993fe           jmp 0x1fad
  05565A  211A: 8bb656ff         mov si, word ptr [bp - 0xaa]
  05565E  211E: d1e6             shl si, 1
  055660  2120: ffb2d4fe         push word ptr [bp + si - 0x12c]
  055664  2124: ffb656ff         push word ptr [bp - 0xaa]
  055668  2128: 9a360c1f18       lcall 0x181f, 0xc36
  05566D  212D: 83c404           add sp, 4
  055670  2130: 8bbad4fe         mov di, word ptr [bp + si - 0x12c]
  055674  2134: d1e7             shl di, 1
  055676  2136: ff831eff         inc word ptr [bp + di - 0xe2]
  05567A  213A: c78254fe0100     mov word ptr [bp + si - 0x1ac], 1
  055680  2140: 9a040c1f18       lcall 0x181f, 0xc04
  055685  2145: e965fe           jmp 0x1fad
  055688  2148: c78656ff0000     mov word ptr [bp - 0xaa], 0
  05568E  214E: e92603           jmp 0x2477
  055691  2151: 90               nop 
  055692  2152: 8b1e4285         mov bx, word ptr [0x8542]
  055696  2156: 8a5f1a           mov bl, byte ptr [bx + 0x1a]
  055699  2159: 2aff             sub bh, bh
  05569B  215B: c1e304           shl bx, 4
  05569E  215E: 035ece           add bx, word ptr [bp - 0x32]
  0556A1  2161: 8a87bc84         mov al, byte ptr [bx - 0x7b44]
  0556A5  2165: 2ae4             sub ah, ah
  0556A7  2167: 898646fe         mov word ptr [bp - 0x1ba], ax
  0556AB  216B: 837ece0f         cmp word ptr [bp - 0x32], 0xf
  0556AF  216F: 7412             je 0x2183
  0556B1  2171: 837ece0e         cmp word ptr [bp - 0x32], 0xe
  0556B5  2175: 740c             je 0x2183
  0556B7  2177: 8a8fb484         mov cl, byte ptr [bx - 0x7b4c]
  0556BB  217B: 2aed             sub ch, ch
  0556BD  217D: 2bc1             sub ax, cx
  0556BF  217F: 898646fe         mov word ptr [bp - 0x1ba], ax
  0556C3  2183: 837ece0e         cmp word ptr [bp - 0x32], 0xe
  0556C7  2187: 7406             je 0x218f
  0556C9  2189: 837ece0f         cmp word ptr [bp - 0x32], 0xf
  0556CD  218D: 7522             jne 0x21b1
  0556CF  218F: 838646fe04       add word ptr [bp - 0x1ba], 4
  0556D4  2194: 833e8e5332       cmp word ptr [0x538e], 0x32
  0556D9  2199: 7c16             jl 0x21b1
  0556DB  219B: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  0556DF  219F: 8a877c91         mov al, byte ptr [bx - 0x6e84]
  0556E3  21A3: 8b1e9853         mov bx, word ptr [0x5398]
  0556E7  21A7: 38877c91         cmp byte ptr [bx - 0x6e84], al
  0556EB  21AB: 7704             ja 0x21b1
  0556ED  21AD: d1a646fe         shl word ptr [bp - 0x1ba], 1
  0556F1  21B1: 8b86befe         mov ax, word ptr [bp - 0x142]
  0556F5  21B5: c1e003           shl ax, 3
  0556F8  21B8: 050500           add ax, 5
  0556FB  21BB: f7ae46fe         imul word ptr [bp - 0x1ba]
  0556FF  21BF: 8986befe         mov word ptr [bp - 0x142], ax
  055703  21C3: 3b8694fe         cmp ax, word ptr [bp - 0x16c]
  055707  21C7: 7e0b             jle 0x21d4
  055709  21C9: 898694fe         mov word ptr [bp - 0x16c], ax
  05570D  21CD: 8b4688           mov ax, word ptr [bp - 0x78]
  055710  21D0: 898614ff         mov word ptr [bp - 0xec], ax
  055714  21D4: ff4688           inc word ptr [bp - 0x78]
  055717  21D7: 837e8813         cmp word ptr [bp - 0x78], 0x13
  05571B  21DB: 7c03             jl 0x21e0
  05571D  21DD: e91602           jmp 0x23f6
  055720  21E0: 8b7688           mov si, word ptr [bp - 0x78]
  055723  21E3: d1e6             shl si, 1
  055725  21E5: 83ba98fe00       cmp word ptr [bp + si - 0x168], 0
  05572A  21EA: 74e8             je 0x21d4
  05572C  21EC: 837e8812         cmp word ptr [bp - 0x78], 0x12
  055730  21F0: 74e2             je 0x21d4
  055732  21F2: 8b7688           mov si, word ptr [bp - 0x78]
  055735  21F5: d1e6             shl si, 1
  055737  21F7: 83ba1eff03       cmp word ptr [bp + si - 0xe2], 3
  05573C  21FC: 7dd6             jge 0x21d4
  05573E  21FE: ff7688           push word ptr [bp - 0x78]
  055741  2201: ffb656ff         push word ptr [bp - 0xaa]
  055745  2205: 9a360c1f18       lcall 0x181f, 0xc36
  05574A  220A: 83c404           add sp, 4
  05574D  220D: 8b5e88           mov bx, word ptr [bp - 0x78]
  055750  2210: 8a87b602         mov al, byte ptr [bx + 0x2b6]
  055754  2214: 98               cwde 
  055755  2215: 8986c8fe         mov word ptr [bp - 0x138], ax
  055759  2219: 83fb0f           cmp bx, 0xf
  05575C  221C: 7506             jne 0x2224
  05575E  221E: c786c8fe0e00     mov word ptr [bp - 0x138], 0xe
  055764  2224: 83fb0d           cmp bx, 0xd
  055767  2227: 7506             jne 0x222f
  055769  2229: c786c8fe0500     mov word ptr [bp - 0x138], 5
  05576F  222F: 83bec8fe00       cmp word ptr [bp - 0x138], 0
  055774  2234: 7c24             jl 0x225a
  055776  2236: 8bb6c8fe         mov si, word ptr [bp - 0x138]
  05577A  223A: d1e6             shl si, 1
  05577C  223C: 8b1e4285         mov bx, word ptr [0x8542]
  055780  2240: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  055784  2244: 2b840a8e         sub ax, word ptr [si - 0x71f6]
  055788  2248: 0384c88d         add ax, word ptr [si - 0x7238]
  05578C  224C: 89468a           mov word ptr [bp - 0x76], ax
  05578F  224F: 0bc0             or ax, ax
  055791  2251: 7c81             jl 0x21d4
  055793  2253: 0bc0             or ax, ax
  055795  2255: 7503             jne 0x225a
  055797  2257: ff468a           inc word ptr [bp - 0x76]
  05579A  225A: 8d46ce           lea ax, [bp - 0x32]
  05579D  225D: 50               push ax
  05579E  225E: ffb656ff         push word ptr [bp - 0xaa]
  0557A2  2262: 9ad60c1f18       lcall 0x181f, 0xcd6
  0557A7  2267: 83c404           add sp, 4
  0557AA  226A: 8986befe         mov word ptr [bp - 0x142], ax
  0557AE  226E: 3b468a           cmp ax, word ptr [bp - 0x76]
  0557B1  2271: 7e03             jle 0x2276
  0557B3  2273: 8b468a           mov ax, word ptr [bp - 0x76]
  0557B6  2276: 8986befe         mov word ptr [bp - 0x142], ax
  0557BA  227A: 837ece10         cmp word ptr [bp - 0x32], 0x10
  0557BE  227E: 7d03             jge 0x2283
  0557C0  2280: e9cffe           jmp 0x2152
  0557C3  2283: c78646fe0300     mov word ptr [bp - 0x1ba], 3
  0557C9  2289: 837e8811         cmp word ptr [bp - 0x78], 0x11
  0557CD  228D: 7403             je 0x2292
  0557CF  228F: e9ef00           jmp 0x2381
  0557D2  2292: 6a13             push 0x13
  0557D4  2294: 9ab00a1f18       lcall 0x181f, 0xab0
  0557D9  2299: 83c402           add sp, 2
  0557DC  229C: c1e002           shl ax, 2
  0557DF  229F: 034686           add ax, word ptr [bp - 0x7a]
  0557E2  22A2: 050700           add ax, 7
  0557E5  22A5: 898646fe         mov word ptr [bp - 0x1ba], ax
  0557E9  22A9: 8b1e4285         mov bx, word ptr [0x8542]
  0557ED  22AD: 8a879600         mov al, byte ptr [bx + 0x96]
  0557F1  22B1: 2ae4             sub ah, ah
  0557F3  22B3: c1e002           shl ax, 2
  0557F6  22B6: 018646fe         add word ptr [bp - 0x1ba], ax
  0557FA  22BA: 837e860a         cmp word ptr [bp - 0x7a], 0xa
  0557FE  22BE: 7c04             jl 0x22c4
  055800  22C0: d1a646fe         shl word ptr [bp - 0x1ba], 1
  055804  22C4: 6a0f             push 0xf
  055806  22C6: 8a471a           mov al, byte ptr [bx + 0x1a]
  055809  22C9: 2ae4             sub ah, ah
  05580B  22CB: 50               push ax
  05580C  22CC: 9ab4071f18       lcall 0x181f, 0x7b4
  055811  22D1: 83c404           add sp, 4
  055814  22D4: 0bc0             or ax, ax
  055816  22D6: 7404             je 0x22dc
  055818  22D8: d1a646fe         shl word ptr [bp - 0x1ba], 1
  05581C  22DC: 813e8a530406     cmp word ptr [0x538a], 0x604
  055822  22E2: 7d06             jge 0x22ea
  055824  22E4: c78646fe0000     mov word ptr [bp - 0x1ba], 0
  05582A  22EA: 813e8a534006     cmp word ptr [0x538a], 0x640
  055830  22F0: 7e04             jle 0x22f6
  055832  22F2: d1a646fe         shl word ptr [bp - 0x1ba], 1
  055836  22F6: 813e8a53a406     cmp word ptr [0x538a], 0x6a4
  05583C  22FC: 7e04             jle 0x2302
  05583E  22FE: d1a646fe         shl word ptr [bp - 0x1ba], 1
  055842  2302: f606825301       test byte ptr [0x5382], 1
  055847  2307: 7406             je 0x230f
  055849  2309: c78646fe0000     mov word ptr [bp - 0x1ba], 0
  05584F  230F: 8b1e4285         mov bx, word ptr [0x8542]
  055853  2313: 807f1f03         cmp byte ptr [bx + 0x1f], 3
  055857  2317: 7f04             jg 0x231d
  055859  2319: d1be46fe         sar word ptr [bp - 0x1ba], 1
  05585D  231D: 807f1f06         cmp byte ptr [bx + 0x1f], 6
  055861  2321: 7d04             jge 0x2327
  055863  2323: d1be46fe         sar word ptr [bp - 0x1ba], 1
  055867  2327: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  05586B  232B: 8a877c91         mov al, byte ptr [bx - 0x6e84]
  05586F  232F: 8b1e9853         mov bx, word ptr [0x5398]
  055873  2333: 38877c91         cmp byte ptr [bx - 0x6e84], al
  055877  2337: 7304             jae 0x233d
  055879  2339: d1be46fe         sar word ptr [bp - 0x1ba], 1
  05587D  233D: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  055881  2341: 8a877c91         mov al, byte ptr [bx - 0x6e84]
  055885  2345: 8b1e9853         mov bx, word ptr [0x5398]
  055889  2349: 38877c91         cmp byte ptr [bx - 0x6e84], al
  05588D  234D: 7604             jbe 0x2353
  05588F  234F: d1a646fe         shl word ptr [bp - 0x1ba], 1
  055893  2353: 8b1efc84         mov bx, word ptr [0x84fc]
  055897  2357: f60704           test byte ptr [bx], 4
  05589A  235A: 7404             je 0x2360
  05589C  235C: d1be46fe         sar word ptr [bp - 0x1ba], 1
  0558A0  2360: 6a64             push 0x64
  0558A2  2362: 6a01             push 1
  0558A4  2364: 8b5ece           mov bx, word ptr [bp - 0x32]
  0558A7  2367: d1e3             shl bx, 1
  0558A9  2369: 8b87c88d         mov ax, word ptr [bx - 0x7238]
  0558AD  236D: 298646fe         sub word ptr [bp - 0x1ba], ax
  0558B1  2371: ffb646fe         push word ptr [bp - 0x1ba]
  0558B5  2375: 9a5c031f18       lcall 0x181f, 0x35c
  0558BA  237A: 83c406           add sp, 6
  0558BD  237D: 898646fe         mov word ptr [bp - 0x1ba], ax
  0558C1  2381: 837e880d         cmp word ptr [bp - 0x78], 0xd
  0558C5  2385: 7535             jne 0x23bc
  0558C7  2387: 8b5ece           mov bx, word ptr [bp - 0x32]
  0558CA  238A: d1e3             shl bx, 1
  0558CC  238C: 8b87c88d         mov ax, word ptr [bx - 0x7238]
  0558D0  2390: b90300           mov cx, 3
  0558D3  2393: 2bd2             sub dx, dx
  0558D5  2395: f7f1             div cx
  0558D7  2397: 2d0500           sub ax, 5
  0558DA  239A: f7d8             neg ax
  0558DC  239C: 898646fe         mov word ptr [bp - 0x1ba], ax
  0558E0  23A0: 8b1e4285         mov bx, word ptr [0x8542]
  0558E4  23A4: f6471d80         test byte ptr [bx + 0x1d], 0x80
  0558E8  23A8: 7406             je 0x23b0
  0558EA  23AA: d1f8             sar ax, 1
  0558EC  23AC: 898646fe         mov word ptr [bp - 0x1ba], ax
  0558F0  23B0: 3d0100           cmp ax, 1
  0558F3  23B3: 7d03             jge 0x23b8
  0558F5  23B5: b80100           mov ax, 1
  0558F8  23B8: 898646fe         mov word ptr [bp - 0x1ba], ax
  0558FC  23BC: 837e8810         cmp word ptr [bp - 0x78], 0x10
  055900  23C0: 7403             je 0x23c5
  055902  23C2: e9ecfd           jmp 0x21b1
  055905  23C5: a18e53           mov ax, word ptr [0x538e]
  055908  23C8: b96400           mov cx, 0x64
  05590B  23CB: 99               cdq 
  05590C  23CC: f7f9             idiv cx
  05590E  23CE: 8b5ece           mov bx, word ptr [bp - 0x32]
  055911  23D1: d1e3             shl bx, 1
  055913  23D3: 8b8fc88d         mov cx, word ptr [bx - 0x7238]
  055917  23D7: d1e9             shr cx, 1
  055919  23D9: 03c8             add cx, ax
  05591B  23DB: 83e906           sub cx, 6
  05591E  23DE: 298e46fe         sub word ptr [bp - 0x1ba], cx
  055922  23E2: 8b8646fe         mov ax, word ptr [bp - 0x1ba]
  055926  23E6: 3d0100           cmp ax, 1
  055929  23E9: 7d03             jge 0x23ee
  05592B  23EB: b80100           mov ax, 1
  05592E  23EE: 898646fe         mov word ptr [bp - 0x1ba], ax
  055932  23F2: e9bcfd           jmp 0x21b1
  055935  23F5: 90               nop 
  055936  23F6: 6a12             push 0x12
  055938  23F8: ffb656ff         push word ptr [bp - 0xaa]
  05593C  23FC: 9a360c1f18       lcall 0x181f, 0xc36
  055941  2401: 83c404           add sp, 4
  055944  2404: 8b8694fe         mov ax, word ptr [bp - 0x16c]
  055948  2408: 3906c08d         cmp word ptr [0x8dc0], ax
  05594C  240C: 7c46             jl 0x2454
  05594E  240E: 6aff             push -1
  055950  2410: ffb656ff         push word ptr [bp - 0xaa]
  055954  2414: 9a6e0b1f18       lcall 0x181f, 0xb6e
  055959  2419: 83c404           add sp, 4
  05595C  241C: 833ebe8d00       cmp word ptr [0x8dbe], 0
  055961  2421: 754b             jne 0x246e
  055963  2423: 6a25             push 0x25
  055965  2425: 9afc091f18       lcall 0x181f, 0x9fc
  05596A  242A: 83c402           add sp, 2
  05596D  242D: 0bc0             or ax, ax
  05596F  242F: 7415             je 0x2446
  055971  2431: 6a05             push 5
  055973  2433: 9a080d1f18       lcall 0x181f, 0xd08
  055978  2438: 83c402           add sp, 2
  05597B  243B: 0bc0             or ax, ax
  05597D  243D: 7407             je 0x2446
  05597F  243F: 83be3eff03       cmp word ptr [bp - 0xc2], 3
  055984  2444: 7c08             jl 0x244e
  055986  2446: c78614ff0d00     mov word ptr [bp - 0xec], 0xd
  05598C  244C: eb06             jmp 0x2454
  05598E  244E: c78614ff1000     mov word ptr [bp - 0xec], 0x10
  055994  2454: ffb614ff         push word ptr [bp - 0xec]
  055998  2458: ffb656ff         push word ptr [bp - 0xaa]
  05599C  245C: 9a360c1f18       lcall 0x181f, 0xc36
  0559A1  2461: 83c404           add sp, 4
  0559A4  2464: 8bb614ff         mov si, word ptr [bp - 0xec]
  0559A8  2468: d1e6             shl si, 1
  0559AA  246A: ff821eff         inc word ptr [bp + si - 0xe2]
  0559AE  246E: 9a040c1f18       lcall 0x181f, 0xc04
  0559B3  2473: ff8656ff         inc word ptr [bp - 0xaa]
  0559B7  2477: 8b1e4285         mov bx, word ptr [0x8542]
  0559BB  247B: 8a471f           mov al, byte ptr [bx + 0x1f]
  0559BE  247E: 98               cwde 
  0559BF  247F: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  0559C3  2483: 7e2f             jle 0x24b4
  0559C5  2485: 8bb656ff         mov si, word ptr [bp - 0xaa]
  0559C9  2489: d1e6             shl si, 1
  0559CB  248B: 83ba54fe00       cmp word ptr [bp + si - 0x1ac], 0
  0559D0  2490: 75e1             jne 0x2473
  0559D2  2492: 6afe             push -2
  0559D4  2494: ffb656ff         push word ptr [bp - 0xaa]
  0559D8  2498: 9a6e0b1f18       lcall 0x181f, 0xb6e
  0559DD  249D: 83c404           add sp, 4
  0559E0  24A0: c78694fe0000     mov word ptr [bp - 0x16c], 0
  0559E6  24A6: c78614ff0d00     mov word ptr [bp - 0xec], 0xd
  0559EC  24AC: c746880900       mov word ptr [bp - 0x78], 9
  0559F1  24B1: e923fd           jmp 0x21d7
  0559F4  24B4: 6a00             push 0
  0559F6  24B6: 9a820b1f18       lcall 0x181f, 0xb82
  0559FB  24BB: 83c402           add sp, 2
  0559FE  24BE: 6a08             push 8
  055A00  24C0: 8bf0             mov si, ax
  055A02  24C2: 9a820b1f18       lcall 0x181f, 0xb82
  055A07  24C7: 83c402           add sp, 2
  055A0A  24CA: 03f0             add si, ax
  055A0C  24CC: 89b64afe         mov word ptr [bp - 0x1b6], si
  055A10  24D0: 6a00             push 0
  055A12  24D2: 9af00b1f18       lcall 0x181f, 0xbf0
  055A17  24D7: 83c402           add sp, 2
  055A1A  24DA: 6a08             push 8
  055A1C  24DC: 8bf0             mov si, ax
  055A1E  24DE: 9af00b1f18       lcall 0x181f, 0xbf0
  055A23  24E3: 83c402           add sp, 2
  055A26  24E6: 03f0             add si, ax
  055A28  24E8: 8976f8           mov word ptr [bp - 8], si
  055A2B  24EB: 8b1e4285         mov bx, word ptr [0x8542]
  055A2F  24EF: 80671d7f         and byte ptr [bx + 0x1d], 0x7f
  055A33  24F3: c6879400ff       mov byte ptr [bx + 0x94], 0xff
  055A38  24F8: 2bc0             sub ax, ax
  055A3A  24FA: 898662ff         mov word ptr [bp - 0x9e], ax
  055A3E  24FE: 898616ff         mov word ptr [bp - 0xea], ax
  055A42  2502: 8986cafe         mov word ptr [bp - 0x136], ax
  055A46  2506: 898656ff         mov word ptr [bp - 0xaa], ax
  055A4A  250A: eb20             jmp 0x252c
  055A4C  250C: ffb656ff         push word ptr [bp - 0xaa]
  055A50  2510: 9a540c1f18       lcall 0x181f, 0xc54
  055A55  2515: 83c402           add sp, 2
  055A58  2518: 8946ea           mov word ptr [bp - 0x16], ax
  055A5B  251B: 50               push ax
  055A5C  251C: 9a9a0c1f18       lcall 0x181f, 0xc9a
  055A61  2521: 83c402           add sp, 2
  055A64  2524: 0bc0             or ax, ax
  055A66  2526: 752a             jne 0x2552
  055A68  2528: ff8656ff         inc word ptr [bp - 0xaa]
  055A6C  252C: 8b1e4285         mov bx, word ptr [0x8542]
  055A70  2530: 8a471f           mov al, byte ptr [bx + 0x1f]
  055A73  2533: 98               cwde 
  055A74  2534: 8bc8             mov cx, ax
  055A76  2536: 0306728d         add ax, word ptr [0x8d72]
  055A7A  253A: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  055A7E  253E: 7e36             jle 0x2576
  055A80  2540: 3b8e56ff         cmp cx, word ptr [bp - 0xaa]
  055A84  2544: 7ec6             jle 0x250c
  055A86  2546: 8bb656ff         mov si, word ptr [bp - 0xaa]
  055A8A  254A: d1e6             shl si, 1
  055A8C  254C: 8b82d4fe         mov ax, word ptr [bp + si - 0x12c]
  055A90  2550: ebc6             jmp 0x2518
  055A92  2552: ff8616ff         inc word ptr [bp - 0xea]
  055A96  2556: 8b5eea           mov bx, word ptr [bp - 0x16]
  055A99  2559: c1e303           shl bx, 3
  055A9C  255C: 8b87a68e         mov ax, word ptr [bx - 0x715a]
  055AA0  2560: b90400           mov cx, 4
  055AA3  2563: 99               cdq 
  055AA4  2564: f7f9             idiv cx
  055AA6  2566: 3b96cafe         cmp dx, word ptr [bp - 0x136]
  055AAA  256A: 7d04             jge 0x2570
  055AAC  256C: 8b96cafe         mov dx, word ptr [bp - 0x136]
  055AB0  2570: 8996cafe         mov word ptr [bp - 0x136], dx
  055AB4  2574: ebb2             jmp 0x2528
  055AB6  2576: 8a471f           mov al, byte ptr [bx + 0x1f]
  055AB9  2579: d0f8             sar al, 1
  055ABB  257B: 98               cwde 
  055ABC  257C: 3b864afe         cmp ax, word ptr [bp - 0x1b6]
  055AC0  2580: 7d0d             jge 0x258f
  055AC2  2582: 83be4afe01       cmp word ptr [bp - 0x1b6], 1
  055AC7  2587: 7e06             jle 0x258f
  055AC9  2589: c78662ff0100     mov word ptr [bp - 0x9e], 1
  055ACF  258F: 833e5a8e00       cmp word ptr [0x8e5a], 0
  055AD4  2594: 7406             je 0x259c
  055AD6  2596: c78662ff0100     mov word ptr [bp - 0x9e], 1
  055ADC  259C: 8a471f           mov al, byte ptr [bx + 0x1f]
  055ADF  259F: 98               cwde 
  055AE0  25A0: 8b8e60ff         mov cx, word ptr [bp - 0xa0]
  055AE4  25A4: 2b8ec0fe         sub cx, word ptr [bp - 0x140]
  055AE8  25A8: 3bc8             cmp cx, ax
  055AEA  25AA: 7e0e             jle 0x25ba
  055AEC  25AC: 83bec0fe00       cmp word ptr [bp - 0x140], 0
  055AF1  25B1: 7419             je 0x25cc
  055AF3  25B3: 83be62ff00       cmp word ptr [bp - 0x9e], 0
  055AF8  25B8: 7412             je 0x25cc
  055AFA  25BA: b80600           mov ax, 6
  055AFD  25BD: 0e               push cs
  055AFE  25BE: e88d07           call 0x2d4e
  055B01  25C1: 0bc0             or ax, ax
  055B03  25C3: 7507             jne 0x25cc
  055B05  25C5: 898662ff         mov word ptr [bp - 0x9e], ax
  055B09  25C9: e95f04           jmp 0x2a2b
  055B0C  25CC: 2bc0             sub ax, ax
  055B0E  25CE: 0e               push cs
  055B0F  25CF: e87c07           call 0x2d4e
  055B12  25D2: 0bc0             or ax, ax
  055B14  25D4: 7503             jne 0x25d9
  055B16  25D6: e95204           jmp 0x2a2b
  055B19  25D9: 8b1e4285         mov bx, word ptr [0x8542]
  055B1D  25DD: 83bfaa0002       cmp word ptr [bx + 0xaa], 2
  055B22  25E2: 7c0e             jl 0x25f2
  055B24  25E4: b81100           mov ax, 0x11
  055B27  25E7: 0e               push cs
  055B28  25E8: e86307           call 0x2d4e
  055B2B  25EB: 0bc0             or ax, ax
  055B2D  25ED: 7503             jne 0x25f2
  055B2F  25EF: e93904           jmp 0x2a2b
  055B32  25F2: 8b1e4285         mov bx, word ptr [0x8542]
  055B36  25F6: 807f1f04         cmp byte ptr [bx + 0x1f], 4
  055B3A  25FA: 7d03             jge 0x25ff
  055B3C  25FC: e92804           jmp 0x2a27
  055B3F  25FF: 8a471f           mov al, byte ptr [bx + 0x1f]
  055B42  2602: b106             mov cl, 6
  055B44  2604: 98               cwde 
  055B45  2605: f6f9             idiv cl
  055B47  2607: 98               cwde 
  055B48  2608: 898696fe         mov word ptr [bp - 0x16a], ax
  055B4C  260C: 3a879500         cmp al, byte ptr [bx + 0x95]
  055B50  2610: 7615             jbe 0x2627
  055B52  2612: 80bf950001       cmp byte ptr [bx + 0x95], 1
  055B57  2617: 730e             jae 0x2627
  055B59  2619: b81000           mov ax, 0x10
  055B5C  261C: 0e               push cs
  055B5D  261D: e82e07           call 0x2d4e
  055B60  2620: 0bc0             or ax, ax
  055B62  2622: 7503             jne 0x2627
  055B64  2624: e90404           jmp 0x2a2b
  055B67  2627: 8b1e4285         mov bx, word ptr [0x8542]
  055B6B  262B: 807f1f06         cmp byte ptr [bx + 0x1f], 6
  055B6F  262F: 7c34             jl 0x2665
  055B71  2631: f6471b03         test byte ptr [bx + 0x1b], 3
  055B75  2635: 7520             jne 0x2657
  055B77  2637: 8b369853         mov si, word ptr [0x5398]
  055B7B  263B: 8a842494         mov al, byte ptr [si - 0x6bdc]
  055B7F  263F: 2ae4             sub ah, ah
  055B81  2641: 48               dec ax
  055B82  2642: 48               dec ax
  055B83  2643: 8bb652fe         mov si, word ptr [bp - 0x1ae]
  055B87  2647: 8a8c2494         mov cl, byte ptr [si - 0x6bdc]
  055B8B  264B: 2aed             sub ch, ch
  055B8D  264D: 3bc1             cmp ax, cx
  055B8F  264F: 7f06             jg 0x2657
  055B91  2651: 807f1f0c         cmp byte ptr [bx + 0x1f], 0xc
  055B95  2655: 7c0e             jl 0x2665
  055B97  2657: b81200           mov ax, 0x12
  055B9A  265A: 0e               push cs
  055B9B  265B: e8f006           call 0x2d4e
  055B9E  265E: 0bc0             or ax, ax
  055BA0  2660: 7503             jne 0x2665
  055BA2  2662: e9c603           jmp 0x2a2b
  055BA5  2665: 8b1e4285         mov bx, word ptr [0x8542]
  055BA9  2669: f6471c20         test byte ptr [bx + 0x1c], 0x20
  055BAD  266D: 7541             jne 0x26b0
  055BAF  266F: 813e8a534006     cmp word ptr [0x538a], 0x640
  055BB5  2675: 7d39             jge 0x26b0
  055BB7  2677: 8b5e96           mov bx, word ptr [bp - 0x6a]
  055BBA  267A: f687f29501       test byte ptr [bx - 0x6a0e], 1
  055BBF  267F: 742f             je 0x26b0
  055BC1  2681: ffb652fe         push word ptr [bp - 0x1ae]
  055BC5  2685: ff36528d         push word ptr [0x8d52]
  055BC9  2689: 9a0c031f18       lcall 0x181f, 0x30c
  055BCE  268E: 83c404           add sp, 4
  055BD1  2691: 3d3200           cmp ax, 0x32
  055BD4  2694: 7d1a             jge 0x26b0
  055BD6  2696: 837ee000         cmp word ptr [bp - 0x20], 0
  055BDA  269A: 7514             jne 0x26b0
  055BDC  269C: 6a0c             push 0xc
  055BDE  269E: 0e               push cs
  055BDF  269F: e8b606           call 0x2d58
  055BE2  26A2: 83c402           add sp, 2
  055BE5  26A5: 8b1e4285         mov bx, word ptr [0x8542]
  055BE9  26A9: 88879400         mov byte ptr [bx + 0x94], al
  055BED  26AD: e97b03           jmp 0x2a2b
  055BF0  26B0: 83becafe01       cmp word ptr [bp - 0x136], 1
  055BF5  26B5: 7c1f             jl 0x26d6
  055BF7  26B7: 8b1e4285         mov bx, word ptr [0x8542]
  055BFB  26BB: 8a471f           mov al, byte ptr [bx + 0x1f]
  055BFE  26BE: 98               cwde 
  055BFF  26BF: 038616ff         add ax, word ptr [bp - 0xea]
  055C03  26C3: 3d0400           cmp ax, 4
  055C06  26C6: 7c0e             jl 0x26d6
  055C08  26C8: b80c00           mov ax, 0xc
  055C0B  26CB: 0e               push cs
  055C0C  26CC: e87f06           call 0x2d4e
  055C0F  26CF: 0bc0             or ax, ax
  055C11  26D1: 7503             jne 0x26d6
  055C13  26D3: e95503           jmp 0x2a2b
  055C16  26D6: 8b1e4285         mov bx, word ptr [0x8542]
  055C1A  26DA: 807f1f06         cmp byte ptr [bx + 0x1f], 6
  055C1E  26DE: 7d04             jge 0x26e4
  055C20  26E0: 804f1d80         or byte ptr [bx + 0x1d], 0x80
  055C24  26E4: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  055C28  26E8: c1e304           shl bx, 4
  055C2B  26EB: 8a87cb84         mov al, byte ptr [bx - 0x7b35]
  055C2F  26EF: 2ae4             sub ah, ah
  055C31  26F1: 8a0ea653         mov cl, byte ptr [0x53a6]
  055C35  26F5: d0e9             shr cl, 1
  055C37  26F7: 2aed             sub ch, ch
  055C39  26F9: 03c1             add ax, cx
  055C3B  26FB: 3d0400           cmp ax, 4
  055C3E  26FE: 7d07             jge 0x2707
  055C40  2700: 833e8e5350       cmp word ptr [0x538e], 0x50
  055C45  2705: 7e18             jle 0x271f
  055C47  2707: 8b1e4285         mov bx, word ptr [0x8542]
  055C4B  270B: 807f1f06         cmp byte ptr [bx + 0x1f], 6
  055C4F  270F: 7c0e             jl 0x271f
  055C51  2711: 83bfb60028       cmp word ptr [bx + 0xb6], 0x28
  055C56  2716: 7d0d             jge 0x2725
  055C58  2718: 833ee48d00       cmp word ptr [0x8de4], 0
  055C5D  271D: 7506             jne 0x2725
  055C5F  271F: 837eb800         cmp word ptr [bp - 0x48], 0
  055C63  2723: 740e             je 0x2733
  055C65  2725: b80300           mov ax, 3
  055C68  2728: 0e               push cs
  055C69  2729: e82206           call 0x2d4e
  055C6C  272C: 0bc0             or ax, ax
  055C6E  272E: 7503             jne 0x2733
  055C70  2730: e9f802           jmp 0x2a2b
  055C73  2733: 837eba00         cmp word ptr [bp - 0x46], 0
  055C77  2737: 740e             je 0x2747
  055C79  2739: b82500           mov ax, 0x25
  055C7C  273C: 0e               push cs
  055C7D  273D: e80e06           call 0x2d4e
  055C80  2740: 0bc0             or ax, ax
  055C82  2742: 7503             jne 0x2747
  055C84  2744: e9e402           jmp 0x2a2b
  055C87  2747: b82400           mov ax, 0x24
  055C8A  274A: 0e               push cs
  055C8B  274B: e80006           call 0x2d4e
  055C8E  274E: 0bc0             or ax, ax
  055C90  2750: 7503             jne 0x2755
  055C92  2752: e9d602           jmp 0x2a2b
  055C95  2755: b80100           mov ax, 1
  055C98  2758: 0e               push cs
  055C99  2759: e8f205           call 0x2d4e
  055C9C  275C: 0bc0             or ax, ax
  055C9E  275E: 7503             jne 0x2763
  055CA0  2760: e9c802           jmp 0x2a2b
  055CA3  2763: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  055CA7  2767: c1e304           shl bx, 4
  055CAA  276A: 80bfcb8404       cmp byte ptr [bx - 0x7b35], 4
  055CAF  276F: 7226             jb 0x2797
  055CB1  2771: 8b1e4285         mov bx, word ptr [0x8542]
  055CB5  2775: 807f1f04         cmp byte ptr [bx + 0x1f], 4
  055CB9  2779: 7c1c             jl 0x2797
  055CBB  277B: 83bfa60028       cmp word ptr [bx + 0xa6], 0x28
  055CC0  2780: 7d07             jge 0x2789
  055CC2  2782: 833ed48d00       cmp word ptr [0x8dd4], 0
  055CC7  2787: 740e             je 0x2797
  055CC9  2789: b82800           mov ax, 0x28
  055CCC  278C: 0e               push cs
  055CCD  278D: e8be05           call 0x2d4e
  055CD0  2790: 0bc0             or ax, ax
  055CD2  2792: 7503             jne 0x2797
  055CD4  2794: e99402           jmp 0x2a2b
  055CD7  2797: 8a8696fe         mov al, byte ptr [bp - 0x16a]
  055CDB  279B: 8b1e4285         mov bx, word ptr [0x8542]
  055CDF  279F: 38879500         cmp byte ptr [bx + 0x95], al
  055CE3  27A3: 730e             jae 0x27b3
  055CE5  27A5: b81000           mov ax, 0x10
  055CE8  27A8: 0e               push cs
  055CE9  27A9: e8a205           call 0x2d4e
  055CEC  27AC: 0bc0             or ax, ax
  055CEE  27AE: 7503             jne 0x27b3
  055CF0  27B0: e97802           jmp 0x2a2b
  055CF3  27B3: 833eec8d18       cmp word ptr [0x8dec], 0x18
  055CF8  27B8: 720e             jb 0x27c8
  055CFA  27BA: b81400           mov ax, 0x14
  055CFD  27BD: 0e               push cs
  055CFE  27BE: e88d05           call 0x2d4e
  055D01  27C1: 0bc0             or ax, ax
  055D03  27C3: 7503             jne 0x27c8
  055D05  27C5: e96302           jmp 0x2a2b
  055D08  27C8: 833eec8d04       cmp word ptr [0x8dec], 4
  055D0D  27CD: 720e             jb 0x27dd
  055D0F  27CF: b81400           mov ax, 0x14
  055D12  27D2: 0e               push cs
  055D13  27D3: e87805           call 0x2d4e
  055D16  27D6: 0bc0             or ax, ax
  055D18  27D8: 7503             jne 0x27dd
  055D1A  27DA: e94e02           jmp 0x2a2b
  055D1D  27DD: 83becafe02       cmp word ptr [bp - 0x136], 2
  055D22  27E2: 7c1f             jl 0x2803
  055D24  27E4: 8b1e4285         mov bx, word ptr [0x8542]
  055D28  27E8: 8a471f           mov al, byte ptr [bx + 0x1f]
  055D2B  27EB: 98               cwde 
  055D2C  27EC: 038616ff         add ax, word ptr [bp - 0xea]
  055D30  27F0: 3d0a00           cmp ax, 0xa
  055D33  27F3: 7c0e             jl 0x2803
  055D35  27F5: b80d00           mov ax, 0xd
  055D38  27F8: 0e               push cs
  055D39  27F9: e85205           call 0x2d4e
  055D3C  27FC: 0bc0             or ax, ax
  055D3E  27FE: 7503             jne 0x2803
  055D40  2800: e92802           jmp 0x2a2b
  055D43  2803: 8b1e4285         mov bx, word ptr [0x8542]
  055D47  2807: 807f1f08         cmp byte ptr [bx + 0x1f], 8
  055D4B  280B: 7d03             jge 0x2810
  055D4D  280D: e91702           jmp 0x2a27
  055D50  2810: 83becafe03       cmp word ptr [bp - 0x136], 3
  055D55  2815: 7c1b             jl 0x2832
  055D57  2817: 8a471f           mov al, byte ptr [bx + 0x1f]
  055D5A  281A: 98               cwde 
  055D5B  281B: 038616ff         add ax, word ptr [bp - 0xea]
  055D5F  281F: 3d1000           cmp ax, 0x10
  055D62  2822: 7c0e             jl 0x2832
  055D64  2824: b80e00           mov ax, 0xe
  055D67  2827: 0e               push cs
  055D68  2828: e82305           call 0x2d4e
  055D6B  282B: 0bc0             or ax, ax
  055D6D  282D: 7503             jne 0x2832
  055D6F  282F: e9f901           jmp 0x2a2b
  055D72  2832: b82500           mov ax, 0x25
  055D75  2835: 0e               push cs
  055D76  2836: e81505           call 0x2d4e
  055D79  2839: 0bc0             or ax, ax
  055D7B  283B: 7503             jne 0x2840
  055D7D  283D: e9eb01           jmp 0x2a2b
  055D80  2840: 8b1e4285         mov bx, word ptr [0x8542]
  055D84  2844: 807f1f0a         cmp byte ptr [bx + 0x1f], 0xa
  055D88  2848: 7c0e             jl 0x2858
  055D8A  284A: b80200           mov ax, 2
  055D8D  284D: 0e               push cs
  055D8E  284E: e8fd04           call 0x2d4e
  055D91  2851: 0bc0             or ax, ax
  055D93  2853: 7503             jne 0x2858
  055D95  2855: e9d301           jmp 0x2a2b
  055D98  2858: c746d60000       mov word ptr [bp - 0x2a], 0
  055D9D  285D: c78656ff0500     mov word ptr [bp - 0xaa], 5
  055DA3  2863: 8b9e56ff         mov bx, word ptr [bp - 0xaa]
  055DA7  2867: c1e302           shl bx, 2
  055DAA  286A: 8a876408         mov al, byte ptr [bx + 0x864]
  055DAE  286E: 2ae4             sub ah, ah
  055DB0  2870: 50               push ax
  055DB1  2871: 9ab00a1f18       lcall 0x181f, 0xab0
  055DB6  2876: 83c402           add sp, 2
  055DB9  2879: 3d0300           cmp ax, 3
  055DBC  287C: 7505             jne 0x2883
  055DBE  287E: c746d60100       mov word ptr [bp - 0x2a], 1
  055DC3  2883: ff8e56ff         dec word ptr [bp - 0xaa]
  055DC7  2887: 79da             jns 0x2863
  055DC9  2889: 837ed600         cmp word ptr [bp - 0x2a], 0
  055DCD  288D: 747d             je 0x290c
  055DCF  288F: 8b1e4285         mov bx, word ptr [0x8542]
  055DD3  2893: f6471c40         test byte ptr [bx + 0x1c], 0x40
  055DD7  2897: 7473             je 0x290c
  055DD9  2899: b80800           mov ax, 8
  055DDC  289C: 0e               push cs
  055DDD  289D: e8ae04           call 0x2d4e
  055DE0  28A0: 0bc0             or ax, ax
  055DE2  28A2: 7503             jne 0x28a7
  055DE4  28A4: e98401           jmp 0x2a2b
  055DE7  28A7: 6a08             push 8
  055DE9  28A9: 9afc091f18       lcall 0x181f, 0x9fc
  055DEE  28AE: 83c402           add sp, 2
  055DF1  28B1: 0bc0             or ax, ax
  055DF3  28B3: 7457             je 0x290c
  055DF5  28B5: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  055DF9  28B9: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  055DFD  28BD: d0e8             shr al, 1
  055DFF  28BF: 2ae4             sub ah, ah
  055E01  28C1: 8a8f9892         mov cl, byte ptr [bx - 0x6d68]
  055E05  28C5: 2aed             sub ch, ch
  055E07  28C7: 03c1             add ax, cx
  055E09  28C9: 8a8f1494         mov cl, byte ptr [bx - 0x6bec]
  055E0D  28CD: 3bc1             cmp ax, cx
  055E0F  28CF: 7c05             jl 0x28d6
  055E11  28D1: 6a0f             push 0xf
  055E13  28D3: e9c8fd           jmp 0x269e
  055E16  28D6: 6bdb13           imul bx, bx, 0x13
  055E19  28D9: 80bf5d9200       cmp byte ptr [bx - 0x6da3], 0
  055E1E  28DE: 750b             jne 0x28eb
  055E20  28E0: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  055E24  28E4: 80bf249400       cmp byte ptr [bx - 0x6bdc], 0
  055E29  28E9: 7511             jne 0x28fc
  055E2B  28EB: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  055E2F  28EF: 80bf249404       cmp byte ptr [bx - 0x6bdc], 4
  055E34  28F4: 7306             jae 0x28fc
  055E36  28F6: 6a10             push 0x10
  055E38  28F8: e9a3fd           jmp 0x269e
  055E3B  28FB: 90               nop 
  055E3C  28FC: 6bdb13           imul bx, bx, 0x13
  055E3F  28FF: 80bf5d9201       cmp byte ptr [bx - 0x6da3], 1
  055E44  2904: 7306             jae 0x290c
  055E46  2906: 6a11             push 0x11
  055E48  2908: e993fd           jmp 0x269e
  055E4B  290B: 90               nop 
  055E4C  290C: c78670ff0000     mov word ptr [bp - 0x90], 0
  055E52  2912: 8b865cff         mov ax, word ptr [bp - 0xa4]
  055E56  2916: 8b9654ff         mov dx, word ptr [bp - 0xac]
  055E5A  291A: 9ae0071f18       lcall 0x181f, 0x7e0
  055E5F  291F: eb14             jmp 0x2935
  055E61  2921: 90               nop 
  055E62  2922: 6bd81c           imul bx, ax, 0x1c
  055E65  2925: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  055E6A  292A: 7504             jne 0x2930
  055E6C  292C: ff8670ff         inc word ptr [bp - 0x90]
  055E70  2930: 9ae4021f18       lcall 0x181f, 0x2e4
  055E75  2935: 8986c4fe         mov word ptr [bp - 0x13c], ax
  055E79  2939: 0bc0             or ax, ax
  055E7B  293B: 7de5             jge 0x2922
  055E7D  293D: 837ed600         cmp word ptr [bp - 0x2a], 0
  055E81  2941: 742b             je 0x296e
  055E83  2943: 83be70ff00       cmp word ptr [bp - 0x90], 0
  055E88  2948: 7406             je 0x2950
  055E8A  294A: 837e8c00         cmp word ptr [bp - 0x74], 0
  055E8E  294E: 751e             jne 0x296e
  055E90  2950: 8b1e4285         mov bx, word ptr [0x8542]
  055E94  2954: 83bfb60000       cmp word ptr [bx + 0xb6], 0
  055E99  2959: 740e             je 0x2969
  055E9B  295B: b80300           mov ax, 3
  055E9E  295E: 0e               push cs
  055E9F  295F: e8ec03           call 0x2d4e
  055EA2  2962: 0bc0             or ax, ax
  055EA4  2964: 7503             jne 0x2969
  055EA6  2966: e9c200           jmp 0x2a2b
  055EA9  2969: 6a0b             push 0xb
  055EAB  296B: e930fd           jmp 0x269e
  055EAE  296E: c78656ff0500     mov word ptr [bp - 0xaa], 5
  055EB4  2974: ffb656ff         push word ptr [bp - 0xaa]
  055EB8  2978: 0e               push cs
  055EB9  2979: e8d703           call 0x2d53
  055EBC  297C: 83c402           add sp, 2
  055EBF  297F: 0bc0             or ax, ax
  055EC1  2981: 7421             je 0x29a4
  055EC3  2983: 8b9e56ff         mov bx, word ptr [bp - 0xaa]
  055EC7  2987: c1e302           shl bx, 2
  055ECA  298A: 8a876408         mov al, byte ptr [bx + 0x864]
  055ECE  298E: 2ae4             sub ah, ah
  055ED0  2990: 50               push ax
  055ED1  2991: 9aa00b1f18       lcall 0x181f, 0xba0
  055ED6  2996: 83c402           add sp, 2
  055ED9  2999: 0e               push cs
  055EDA  299A: e8b103           call 0x2d4e
  055EDD  299D: 0bc0             or ax, ax
  055EDF  299F: 7503             jne 0x29a4
  055EE1  29A1: e98700           jmp 0x2a2b
  055EE4  29A4: ff8e56ff         dec word ptr [bp - 0xaa]
  055EE8  29A8: 79ca             jns 0x2974
  055EEA  29AA: b82600           mov ax, 0x26
  055EED  29AD: 0e               push cs
  055EEE  29AE: e89d03           call 0x2d4e
  055EF1  29B1: 0bc0             or ax, ax
  055EF3  29B3: 7476             je 0x2a2b
  055EF5  29B5: 6a08             push 8
  055EF7  29B7: 9afc091f18       lcall 0x181f, 0x9fc
  055EFC  29BC: 83c402           add sp, 2
  055EFF  29BF: 0bc0             or ax, ax
  055F01  29C1: 742a             je 0x29ed
  055F03  29C3: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  055F07  29C7: 8a872494         mov al, byte ptr [bx - 0x6bdc]
  055F0B  29CB: 2c08             sub al, 8
  055F0D  29CD: 1ac9             sbb cl, cl
  055F0F  29CF: 22c1             and al, cl
  055F11  29D1: 0408             add al, 8
  055F13  29D3: 6bdb13           imul bx, bx, 0x13
  055F16  29D6: 38875b92         cmp byte ptr [bx - 0x6da5], al
  055F1A  29DA: 7303             jae 0x29df
  055F1C  29DC: e9f2fe           jmp 0x28d1
  055F1F  29DF: 8b9e52fe         mov bx, word ptr [bp - 0x1ae]
  055F23  29E3: 80bf249408       cmp byte ptr [bx - 0x6bdc], 8
  055F28  29E8: 7303             jae 0x29ed
  055F2A  29EA: e919ff           jmp 0x2906
  055F2D  29ED: 8b1e4285         mov bx, word ptr [0x8542]
  055F31  29F1: 807f1f0a         cmp byte ptr [bx + 0x1f], 0xa
  055F35  29F5: 7d04             jge 0x29fb
  055F37  29F7: 804f1c10         or byte ptr [bx + 0x1c], 0x10
  055F3B  29FB: 83be70ff03       cmp word ptr [bp - 0x90], 3
  055F40  2A00: 7d1c             jge 0x2a1e
  055F42  2A02: b80300           mov ax, 3
  055F45  2A05: 0e               push cs
  055F46  2A06: e84503           call 0x2d4e
  055F49  2A09: 0bc0             or ax, ax
  055F4B  2A0B: 741e             je 0x2a2b
  055F4D  2A0D: 833ee68d00       cmp word ptr [0x8de6], 0
  055F52  2A12: 7503             jne 0x2a17
  055F54  2A14: e952ff           jmp 0x2969
  055F57  2A17: b80500           mov ax, 5
  055F5A  2A1A: e941ff           jmp 0x295e
  055F5D  2A1D: 90               nop 
  055F5E  2A1E: 8b1e4285         mov bx, word ptr [0x8542]
  055F62  2A22: c6879400ff       mov byte ptr [bx + 0x94], 0xff
  055F67  2A27: 804f1d80         or byte ptr [bx + 0x1d], 0x80
  055F6B  2A2B: 6a0c             push 0xc
  055F6D  2A2D: 9ab00a1f18       lcall 0x181f, 0xab0
  055F72  2A32: 83c402           add sp, 2
  055F75  2A35: 89866eff         mov word ptr [bp - 0x92], ax
  055F79  2A39: 3d0300           cmp ax, 3
  055F7C  2A3C: 7506             jne 0x2a44
  055F7E  2A3E: b80100           mov ax, 1
  055F81  2A41: eb03             jmp 0x2a46
  055F83  2A43: 90               nop 
  055F84  2A44: 2bc0             sub ax, ax
  055F86  2A46: 03866eff         add ax, word ptr [bp - 0x92]
  055F8A  2A4A: c1e002           shl ax, 2
  055F8D  2A4D: 898650fe         mov word ptr [bp - 0x1b0], ax
  055F91  2A51: 83be6eff00       cmp word ptr [bp - 0x92], 0
  055F96  2A56: 7503             jne 0x2a5b
  055F98  2A58: e98701           jmp 0x2be2
  055F9B  2A5B: 8b1e4285         mov bx, word ptr [0x8542]
  055F9F  2A5F: 3a878c00         cmp al, byte ptr [bx + 0x8c]
  055FA3  2A63: 7e03             jle 0x2a68
  055FA5  2A65: e97a01           jmp 0x2be2
  055FA8  2A68: c78678ffffff     mov word ptr [bp - 0x88], 0xffff
  055FAE  2A6E: 807f1f0a         cmp byte ptr [bx + 0x1f], 0xa
  055FB2  2A72: 7d26             jge 0x2a9a
  055FB4  2A74: 8b864afe         mov ax, word ptr [bp - 0x1b6]
  055FB8  2A78: 3946f8           cmp word ptr [bp - 8], ax
  055FBB  2A7B: 7f1d             jg 0x2a9a
  055FBD  2A7D: 6a08             push 8
  055FBF  2A7F: 9af00b1f18       lcall 0x181f, 0xbf0
  055FC4  2A84: 83c402           add sp, 2
  055FC7  2A87: 3b46e8           cmp ax, word ptr [bp - 0x18]
  055FCA  2A8A: 7d08             jge 0x2a94
  055FCC  2A8C: c78678ff0800     mov word ptr [bp - 0x88], 8
  055FD2  2A92: eb06             jmp 0x2a9a
  055FD4  2A94: c78678ff0000     mov word ptr [bp - 0x88], 0
  055FDA  2A9A: c78656ff0000     mov word ptr [bp - 0xaa], 0
  055FE0  2AA0: eb0d             jmp 0x2aaf
  055FE2  2AA2: b80200           mov ax, 2
  055FE5  2AA5: 3b8642fe         cmp ax, word ptr [bp - 0x1be]
  055FE9  2AA9: 7e37             jle 0x2ae2
  055FEB  2AAB: ff8656ff         inc word ptr [bp - 0xaa]
  055FEF  2AAF: 83be56ff06       cmp word ptr [bp - 0xaa], 6
  055FF4  2AB4: 7d64             jge 0x2b1a
  055FF6  2AB6: 8b9e56ff         mov bx, word ptr [bp - 0xaa]
  055FFA  2ABA: c1e302           shl bx, 2
  055FFD  2ABD: 8a876408         mov al, byte ptr [bx + 0x864]
  056001  2AC1: 8bc8             mov cx, ax
  056003  2AC3: 2ae4             sub ah, ah
  056005  2AC5: 50               push ax
  056006  2AC6: 898e40fe         mov word ptr [bp - 0x1c0], cx
  05600A  2ACA: 9ab00a1f18       lcall 0x181f, 0xab0
  05600F  2ACF: 83c402           add sp, 2
  056012  2AD2: 898642fe         mov word ptr [bp - 0x1be], ax
  056016  2AD6: 80be40fe03       cmp byte ptr [bp - 0x1c0], 3
  05601B  2ADB: 75c5             jne 0x2aa2
  05601D  2ADD: b80100           mov ax, 1
  056020  2AE0: ebc3             jmp 0x2aa5
  056022  2AE2: 8b9e56ff         mov bx, word ptr [bp - 0xaa]
  056026  2AE6: c1e302           shl bx, 2
  056029  2AE9: 8a9f6608         mov bl, byte ptr [bx + 0x866]
  05602D  2AED: 2aff             sub bh, bh
  05602F  2AEF: d1e3             shl bx, 1
  056031  2AF1: 83bfc88d00       cmp word ptr [bx - 0x7238], 0
  056036  2AF6: 74b3             je 0x2aab
  056038  2AF8: 8b9e56ff         mov bx, word ptr [bp - 0xaa]
  05603C  2AFC: c1e302           shl bx, 2
  05603F  2AFF: 8a876508         mov al, byte ptr [bx + 0x865]
  056043  2B03: 2ae4             sub ah, ah
  056045  2B05: 8bf0             mov si, ax
  056047  2B07: d1e6             shl si, 1
  056049  2B09: 837a9a00         cmp word ptr [bp + si - 0x66], 0
  05604D  2B0D: 759c             jne 0x2aab
  05604F  2B0F: 8b8656ff         mov ax, word ptr [bp - 0xaa]
  056053  2B13: 898678ff         mov word ptr [bp - 0x88], ax
  056057  2B17: eb92             jmp 0x2aab
  056059  2B19: 90               nop 
  05605A  2B1A: 2bc0             sub ax, ax
  05605C  2B1C: 8946e2           mov word ptr [bp - 0x1e], ax
  05605F  2B1F: 898656ff         mov word ptr [bp - 0xaa], ax
  056063  2B23: eb5a             jmp 0x2b7f
  056065  2B25: 90               nop 
  056066  2B26: ffb656ff         push word ptr [bp - 0xaa]
  05606A  2B2A: 9a0e0c1f18       lcall 0x181f, 0xc0e
  05606F  2B2F: 83c402           add sp, 2
  056072  2B32: 898614ff         mov word ptr [bp - 0xec], ax
  056076  2B36: ffb656ff         push word ptr [bp - 0xaa]
  05607A  2B3A: 9a540c1f18       lcall 0x181f, 0xc54
  05607F  2B3F: 83c402           add sp, 2
  056082  2B42: 8946ea           mov word ptr [bp - 0x16], ax
  056085  2B45: 50               push ax
  056086  2B46: 9a9a0c1f18       lcall 0x181f, 0xc9a
  05608B  2B4B: 83c402           add sp, 2
  05608E  2B4E: 0bc0             or ax, ax
  056090  2B50: 740e             je 0x2b60
  056092  2B52: 8b8614ff         mov ax, word ptr [bp - 0xec]
  056096  2B56: 3946ea           cmp word ptr [bp - 0x16], ax
  056099  2B59: 7420             je 0x2b7b
  05609B  2B5B: 3d1300           cmp ax, 0x13
  05609E  2B5E: 741b             je 0x2b7b
  0560A0  2B60: 837eea1b         cmp word ptr [bp - 0x16], 0x1b
  0560A4  2B64: 7415             je 0x2b7b
  0560A6  2B66: 837ee219         cmp word ptr [bp - 0x1e], 0x19
  0560AA  2B6A: 7d0f             jge 0x2b7b
  0560AC  2B6C: 8b8656ff         mov ax, word ptr [bp - 0xaa]
  0560B0  2B70: 8b76e2           mov si, word ptr [bp - 0x1e]
  0560B3  2B73: d1e6             shl si, 1
  0560B5  2B75: 89429a           mov word ptr [bp + si - 0x66], ax
  0560B8  2B78: ff46e2           inc word ptr [bp - 0x1e]
  0560BB  2B7B: ff8656ff         inc word ptr [bp - 0xaa]
  0560BF  2B7F: 8b1e4285         mov bx, word ptr [0x8542]
  0560C3  2B83: 8a471f           mov al, byte ptr [bx + 0x1f]
  0560C6  2B86: 98               cwde 
  0560C7  2B87: 0306728d         add ax, word ptr [0x8d72]
  0560CB  2B8B: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  0560CF  2B8F: 7f95             jg 0x2b26
  0560D1  2B91: 837ee200         cmp word ptr [bp - 0x1e], 0
  0560D5  2B95: 744b             je 0x2be2
  0560D7  2B97: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0560DA  2B9A: 48               dec ax
  0560DB  2B9B: 50               push ax
  0560DC  2B9C: 6a00             push 0
  0560DE  2B9E: 9ad4041f18       lcall 0x181f, 0x4d4
  0560E3  2BA3: 83c404           add sp, 4
  0560E6  2BA6: 8bf0             mov si, ax
  0560E8  2BA8: 897690           mov word ptr [bp - 0x70], si
  0560EB  2BAB: d1e6             shl si, 1
  0560ED  2BAD: 8b429a           mov ax, word ptr [bp + si - 0x66]
  0560F0  2BB0: 8946d2           mov word ptr [bp - 0x2e], ax
  0560F3  2BB3: 83be78ff00       cmp word ptr [bp - 0x88], 0
  0560F8  2BB8: 7c06             jl 0x2bc0
  0560FA  2BBA: 8b8678ff         mov ax, word ptr [bp - 0x88]
  0560FE  2BBE: eb09             jmp 0x2bc9
  056100  2BC0: 50               push ax
  056101  2BC1: 9a0e0c1f18       lcall 0x181f, 0xc0e
  056106  2BC6: 83c402           add sp, 2
  056109  2BC9: 898614ff         mov word ptr [bp - 0xec], ax
  05610D  2BCD: 50               push ax
  05610E  2BCE: ff76d2           push word ptr [bp - 0x2e]
  056111  2BD1: 9aae0c1f18       lcall 0x181f, 0xcae
  056116  2BD6: 83c404           add sp, 4
  056119  2BD9: 8b1e4285         mov bx, word ptr [0x8542]
  05611D  2BDD: c6878c0000       mov byte ptr [bx + 0x8c], 0
  056122  2BE2: 83be62ff00       cmp word ptr [bp - 0x9e], 0
  056127  2BE7: 7503             jne 0x2bec
  056129  2BE9: e9f300           jmp 0x2cdf
  05612C  2BEC: 8b1efc84         mov bx, word ptr [0x84fc]
  056130  2BF0: 807f0119         cmp byte ptr [bx + 1], 0x19
  056134  2BF4: 7e03             jle 0x2bf9
  056136  2BF6: e9e600           jmp 0x2cdf
  056139  2BF9: a1a88e           mov ax, word ptr [0x8ea8]
  05613C  2BFC: 99               cdq 
  05613D  2BFD: 39572c           cmp word ptr [bx + 0x2c], dx
  056140  2C00: 7d03             jge 0x2c05
  056142  2C02: e9da00           jmp 0x2cdf
  056145  2C05: 7f08             jg 0x2c0f
  056147  2C07: 39472a           cmp word ptr [bx + 0x2a], ax
  05614A  2C0A: 7303             jae 0x2c0f
  05614C  2C0C: e9d000           jmp 0x2cdf
  05614F  2C0F: c746d2ffff       mov word ptr [bp - 0x2e], 0xffff
  056154  2C14: 2bc0             sub ax, ax
  056156  2C16: 898616ff         mov word ptr [bp - 0xea], ax
  05615A  2C1A: 898656ff         mov word ptr [bp - 0xaa], ax
  05615E  2C1E: eb42             jmp 0x2c62
  056160  2C20: ffb656ff         push word ptr [bp - 0xaa]
  056164  2C24: 9a540c1f18       lcall 0x181f, 0xc54
  056169  2C29: 83c402           add sp, 2
  05616C  2C2C: 898614ff         mov word ptr [bp - 0xec], ax
  056170  2C30: 0bc0             or ax, ax
  056172  2C32: 7505             jne 0x2c39
  056174  2C34: 808e16ff01       or byte ptr [bp - 0xea], 1
  056179  2C39: 3d0800           cmp ax, 8
  05617C  2C3C: 7505             jne 0x2c43
  05617E  2C3E: 808e16ff02       or byte ptr [bp - 0xea], 2
  056183  2C43: 50               push ax
  056184  2C44: 9a9a0c1f18       lcall 0x181f, 0xc9a
  056189  2C49: 83c402           add sp, 2
  05618C  2C4C: 0bc0             or ax, ax
  05618E  2C4E: 750e             jne 0x2c5e
  056190  2C50: 83be14ff1b       cmp word ptr [bp - 0xec], 0x1b
  056195  2C55: 7407             je 0x2c5e
  056197  2C57: 8b8656ff         mov ax, word ptr [bp - 0xaa]
  05619B  2C5B: 8946d2           mov word ptr [bp - 0x2e], ax
  05619E  2C5E: ff8656ff         inc word ptr [bp - 0xaa]
  0561A2  2C62: 8b1e4285         mov bx, word ptr [0x8542]
  0561A6  2C66: 8a471f           mov al, byte ptr [bx + 0x1f]
  0561A9  2C69: 98               cwde 
  0561AA  2C6A: 3b8656ff         cmp ax, word ptr [bp - 0xaa]
  0561AE  2C6E: 7fb0             jg 0x2c20
  0561B0  2C70: c78614ff1c00     mov word ptr [bp - 0xec], 0x1c
  0561B6  2C76: 837ed200         cmp word ptr [bp - 0x2e], 0
  0561BA  2C7A: 7c2b             jl 0x2ca7
  0561BC  2C7C: f68616ff02       test byte ptr [bp - 0xea], 2
  0561C1  2C81: 7517             jne 0x2c9a
  0561C3  2C83: 6a06             push 6
  0561C5  2C85: 9afc091f18       lcall 0x181f, 0x9fc
  0561CA  2C8A: 83c402           add sp, 2
  0561CD  2C8D: 0bc0             or ax, ax
  0561CF  2C8F: 7409             je 0x2c9a
  0561D1  2C91: c78614ff0800     mov word ptr [bp - 0xec], 8
  0561D7  2C97: eb0e             jmp 0x2ca7
  0561D9  2C99: 90               nop 
  0561DA  2C9A: f68616ff01       test byte ptr [bp - 0xea], 1
  0561DF  2C9F: 7506             jne 0x2ca7
  0561E1  2CA1: c78614ff0000     mov word ptr [bp - 0xec], 0
  0561E7  2CA7: 83be14ff1c       cmp word ptr [bp - 0xec], 0x1c
  0561EC  2CAC: 7431             je 0x2cdf
  0561EE  2CAE: ffb614ff         push word ptr [bp - 0xec]
  0561F2  2CB2: ff76d2           push word ptr [bp - 0x2e]
  0561F5  2CB5: 9aae0c1f18       lcall 0x181f, 0xcae
  0561FA  2CBA: 83c404           add sp, 4
  0561FD  2CBD: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  056200  2CC0: c1e303           shl bx, 3
  056203  2CC3: 8b87a88e         mov ax, word ptr [bx - 0x7158]
  056207  2CC7: 99               cdq 
  056208  2CC8: 8b1efc84         mov bx, word ptr [0x84fc]
  05620C  2CCC: 29472a           sub word ptr [bx + 0x2a], ax
  05620F  2CCF: 19572c           sbb word ptr [bx + 0x2c], dx
  056212  2CD2: 6a01             push 1
  056214  2CD4: 68e017           push 0x17e0
  056217  2CD7: 9ae00a1f19       lcall 0x191f, 0xae0
  05621C  2CDC: 83c404           add sp, 4
  05621F  2CDF: 8b1e4285         mov bx, word ptr [0x8542]
  056223  2CE3: 83bfaa0002       cmp word ptr [bx + 0xaa], 2
  056228  2CE8: 7d59             jge 0x2d43
  05622A  2CEA: 833e8e5328       cmp word ptr [0x538e], 0x28
  05622F  2CEF: 7c52             jl 0x2d43
  056231  2CF1: 8a07             mov al, byte ptr [bx]
  056233  2CF3: 2ae4             sub ah, ah
  056235  2CF5: 8a5701           mov dl, byte ptr [bx + 1]
  056238  2CF8: 2af6             sub dh, dh
  05623A  2CFA: 9ae0071f18       lcall 0x181f, 0x7e0
  05623F  2CFF: 8986c4fe         mov word ptr [bp - 0x13c], ax
  056243  2D03: 6bd81c           imul bx, ax, 0x1c
  056246  2D06: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05624A  2D0A: 2aff             sub bh, bh
  05624C  2D0C: 8bc3             mov ax, bx
  05624E  2D0E: d1e3             shl bx, 1
  056250  2D10: 03d8             add bx, ax
  056252  2D12: d1e3             shl bx, 1
  056254  2D14: 03d8             add bx, ax
  056256  2D16: d1e3             shl bx, 1
  056258  2D18: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  05625D  2D1D: 7424             je 0x2d43
  05625F  2D1F: 8b1efc84         mov bx, word ptr [0x84fc]
  056263  2D23: 837f2c00         cmp word ptr [bx + 0x2c], 0
  056267  2D27: 7c1a             jl 0x2d43
  056269  2D29: 7f06             jg 0x2d31
  05626B  2D2B: 837f2a0a         cmp word ptr [bx + 0x2a], 0xa
  05626F  2D2F: 7212             jb 0x2d43
  056271  2D31: 836f2a0a         sub word ptr [bx + 0x2a], 0xa
  056275  2D35: 835f2c00         sbb word ptr [bx + 0x2c], 0
  056279  2D39: 8b1e4285         mov bx, word ptr [0x8542]
  05627D  2D3D: c787aa000200     mov word ptr [bx + 0xaa], 2
  056283  2D43: c7065e030000     mov word ptr [0x35e], 0
  056289  2D49: 5e               pop si
  05628A  2D4A: 5f               pop di
  05628B  2D4B: c9               leave 
  05628C  2D4C: cb               retf 
  05628D  2D4D: 90               nop 
  05628E  2D4E: eab4051f1a       ljmp 0x1a1f:0x5b4
  056293  2D53: eac0051f1a       ljmp 0x1a1f:0x5c0
  056298  2D58: eacc051f1a       ljmp 0x1a1f:0x5cc
  05629D  2D5D: ead8051f1a       ljmp 0x1a1f:0x5d8
  0562A2  2D62: eae4051f1a       ljmp 0x1a1f:0x5e4
