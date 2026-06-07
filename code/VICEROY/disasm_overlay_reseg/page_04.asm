; ============================================================
; VICEROY.EXE overlay page 0x04 (record 3) -- RE-SEGMENTED
; file_offset (disk image) = 0x02FAF0
; code_offset (first insn) = 0x030550
; code_end (next reloc hdr)= 0x036990  [resident size 1604 para -> nominal_end 0x035F30; on-disk code spills past it]
; reloc_count = 652  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x02FAF0)
; functions in page = 57
; ============================================================

; ---- func_030550  size=21  insns=9  prologue=push bp;mov bp,sp  terminal=RETF ----
  030550  0A60: 55               push bp
  030551  0A61: 8bec             mov bp, sp
  030553  0A63: 8b4606           mov ax, word ptr [bp + 6]
  030556  0A66: a3129e           mov word ptr [0x9e12], ax
  030559  0A69: 69c03c01         imul ax, ax, 0x13c
  03055D  0A6D: 050888           add ax, 0x8808
  030560  0A70: a3fc84           mov word ptr [0x84fc], ax
  030563  0A73: c9               leave 
  030564  0A74: cb               retf 

; ---- func_030566  size=42  insns=19  prologue=ENTER 0x0002,0  terminal=RETF ----
  030566  0A76: c8020000         enter 2, 0
  03056A  0A7A: 56               push si
  03056B  0A7B: 8b5e06           mov bx, word ptr [bp + 6]
  03056E  0A7E: 8bc3             mov ax, bx
  030570  0A80: c1e303           shl bx, 3
  030573  0A83: 03d8             add bx, ax
  030575  0A85: 8a870097         mov al, byte ptr [bx - 0x6900]
  030579  0A89: 98               cwde 
  03057A  0A8A: 8b1efc84         mov bx, word ptr [0x84fc]
  03057E  0A8E: 8b7606           mov si, word ptr [bp + 6]
  030581  0A91: 8bc8             mov cx, ax
  030583  0A93: 8a404c           mov al, byte ptr [bx + si + 0x4c]
  030586  0A96: 98               cwde 
  030587  0A97: 03c1             add ax, cx
  030589  0A99: 7902             jns 0xa9d
  03058B  0A9B: 2bc0             sub ax, ax
  03058D  0A9D: 5e               pop si
  03058E  0A9E: c9               leave 
  03058F  0A9F: cb               retf 

; ---- func_030590  size=24  insns=12  prologue=ENTER 0x0002,0  terminal=RETF ----
  030590  0AA0: c8020000         enter 2, 0
  030594  0AA4: 56               push si
  030595  0AA5: 8b1efc84         mov bx, word ptr [0x84fc]
  030599  0AA9: 8b7606           mov si, word ptr [bp + 6]
  03059C  0AAC: 8a404c           mov al, byte ptr [bx + si + 0x4c]
  03059F  0AAF: 98               cwde 
  0305A0  0AB0: 48               dec ax
  0305A1  0AB1: 7902             jns 0xab5
  0305A3  0AB3: 2bc0             sub ax, ax
  0305A5  0AB5: 5e               pop si
  0305A6  0AB6: c9               leave 
  0305A7  0AB7: cb               retf 

; ---- func_0305A8  size=1424  insns=524  prologue=ENTER 0x0066,0  terminal=RETF ----
  0305A8  0AB8: c8660000         enter 0x66, 0
  0305AC  0ABC: 57               push di
  0305AD  0ABD: 56               push si
  0305AE  0ABE: c746a20000       mov word ptr [bp - 0x5e], 0
  0305B3  0AC3: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  0305B6  0AC6: d1e3             shl bx, 1
  0305B8  0AC8: 8b87ea53         mov ax, word ptr [bx + 0x53ea]
  0305BC  0ACC: 99               cdq 
  0305BD  0ACD: 8b76a2           mov si, word ptr [bp - 0x5e]
  0305C0  0AD0: c1e602           shl si, 2
  0305C3  0AD3: 8942b4           mov word ptr [bp + si - 0x4c], ax
  0305C6  0AD6: 8952b6           mov word ptr [bp + si - 0x4a], dx
  0305C9  0AD9: c746ac0000       mov word ptr [bp - 0x54], 0
  0305CE  0ADE: 6b5eac4f         imul bx, word ptr [bp - 0x54], 0x4f
  0305D2  0AE2: 035ea2           add bx, word ptr [bp - 0x5e]
  0305D5  0AE5: c1e302           shl bx, 2
  0305D8  0AE8: 8b870489         mov ax, word ptr [bx - 0x76fc]
  0305DC  0AEC: 8b970689         mov dx, word ptr [bx - 0x76fa]
  0305E0  0AF0: 0bd2             or dx, dx
  0305E2  0AF2: 7f06             jg 0xafa
  0305E4  0AF4: 7d04             jge 0xafa
  0305E6  0AF6: 2bd2             sub dx, dx
  0305E8  0AF8: 2bc0             sub ax, ax
  0305EA  0AFA: 8b76a2           mov si, word ptr [bp - 0x5e]
  0305ED  0AFD: c1e602           shl si, 2
  0305F0  0B00: 0142b4           add word ptr [bp + si - 0x4c], ax
  0305F3  0B03: 1152b6           adc word ptr [bp + si - 0x4a], dx
  0305F6  0B06: ff46ac           inc word ptr [bp - 0x54]
  0305F9  0B09: 837eac04         cmp word ptr [bp - 0x54], 4
  0305FD  0B0D: 7ccf             jl 0xade
  0305FF  0B0F: 837e0600         cmp word ptr [bp + 6], 0
  030603  0B13: 7538             jne 0xb4d
  030605  0B15: 833e129e00       cmp word ptr [0x9e12], 0
  03060A  0B1A: 7531             jne 0xb4d
  03060C  0B1C: 8b76a2           mov si, word ptr [bp - 0x5e]
  03060F  0B1F: c1e602           shl si, 2
  030612  0B22: 8b42b4           mov ax, word ptr [bp + si - 0x4c]
  030615  0B25: 8b52b6           mov dx, word ptr [bp + si - 0x4a]
  030618  0B28: d1fa             sar dx, 1
  03061A  0B2A: d1d8             rcr ax, 1
  03061C  0B2C: d1fa             sar dx, 1
  03061E  0B2E: d1d8             rcr ax, 1
  030620  0B30: d1fa             sar dx, 1
  030622  0B32: d1d8             rcr ax, 1
  030624  0B34: d1fa             sar dx, 1
  030626  0B36: d1d8             rcr ax, 1
  030628  0B38: d1fa             sar dx, 1
  03062A  0B3A: d1d8             rcr ax, 1
  03062C  0B3C: d1fa             sar dx, 1
  03062E  0B3E: d1d8             rcr ax, 1
  030630  0B40: d1fa             sar dx, 1
  030632  0B42: d1d8             rcr ax, 1
  030634  0B44: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  030637  0B47: d1e3             shl bx, 1
  030639  0B49: 2987ea53         sub word ptr [bx + 0x53ea], ax
  03063D  0B4D: ff46a2           inc word ptr [bp - 0x5e]
  030640  0B50: 837ea210         cmp word ptr [bp - 0x5e], 0x10
  030644  0B54: 7d03             jge 0xb59
  030646  0B56: e96aff           jmp 0xac3
  030649  0B59: 8b46d8           mov ax, word ptr [bp - 0x28]
  03064C  0B5C: 8b56da           mov dx, word ptr [bp - 0x26]
  03064F  0B5F: 0346dc           add ax, word ptr [bp - 0x24]
  030652  0B62: 1356de           adc dx, word ptr [bp - 0x22]
  030655  0B65: 0346e0           add ax, word ptr [bp - 0x20]
  030658  0B68: 1356e2           adc dx, word ptr [bp - 0x1e]
  03065B  0B6B: 0346e4           add ax, word ptr [bp - 0x1c]
  03065E  0B6E: 1356e6           adc dx, word ptr [bp - 0x1a]
  030661  0B71: 0bd2             or dx, dx
  030663  0B73: 7f0c             jg 0xb81
  030665  0B75: 7c05             jl 0xb7c
  030667  0B77: 3d0100           cmp ax, 1
  03066A  0B7A: 7305             jae 0xb81
  03066C  0B7C: 2bd2             sub dx, dx
  03066E  0B7E: b80100           mov ax, 1
  030671  0B81: 8946f6           mov word ptr [bp - 0xa], ax
  030674  0B84: 8956f8           mov word ptr [bp - 8], dx
  030677  0B87: c746a20900       mov word ptr [bp - 0x5e], 9
  03067C  0B8C: e98e00           jmp 0xc1d
  03067F  0B8F: 90               nop 
  030680  0B90: 0bc0             or ax, ax
  030682  0B92: 7c04             jl 0xb98
  030684  0B94: 2bc0             sub ax, ax
  030686  0B96: eb03             jmp 0xb9b
  030688  0B98: b8ffff           mov ax, 0xffff
  03068B  0B9B: 8946aa           mov word ptr [bp - 0x56], ax
  03068E  0B9E: 8bde             mov bx, si
  030690  0BA0: 8bc6             mov ax, si
  030692  0BA2: c1e303           shl bx, 3
  030695  0BA5: 03d8             add bx, ax
  030697  0BA7: 8a870297         mov al, byte ptr [bx - 0x68fe]
  03069B  0BAB: 98               cwde 
  03069C  0BAC: 8bc8             mov cx, ax
  03069E  0BAE: 8a870197         mov al, byte ptr [bx - 0x68ff]
  0306A2  0BB2: 98               cwde 
  0306A3  0BB3: 03c1             add ax, cx
  0306A5  0BB5: 99               cdq 
  0306A6  0BB6: 2bc2             sub ax, dx
  0306A8  0BB8: d1f8             sar ax, 1
  0306AA  0BBA: 89469a           mov word ptr [bp - 0x66], ax
  0306AD  0BBD: 837e0600         cmp word ptr [bp + 6], 0
  0306B1  0BC1: 7445             je 0xc08
  0306B3  0BC3: 8a87fe96         mov al, byte ptr [bx - 0x6902]
  0306B7  0BC7: 98               cwde 
  0306B8  0BC8: 99               cdq 
  0306B9  0BC9: 3b56b2           cmp dx, word ptr [bp - 0x4e]
  0306BC  0BCC: 7f0d             jg 0xbdb
  0306BE  0BCE: 7c05             jl 0xbd5
  0306C0  0BD0: 3b46b0           cmp ax, word ptr [bp - 0x50]
  0306C3  0BD3: 7306             jae 0xbdb
  0306C5  0BD5: 8b56b2           mov dx, word ptr [bp - 0x4e]
  0306C8  0BD8: 8b46b0           mov ax, word ptr [bp - 0x50]
  0306CB  0BDB: 8946b0           mov word ptr [bp - 0x50], ax
  0306CE  0BDE: 8956b2           mov word ptr [bp - 0x4e], dx
  0306D1  0BE1: 8a87ff96         mov al, byte ptr [bx - 0x6901]
  0306D5  0BE5: 98               cwde 
  0306D6  0BE6: 99               cdq 
  0306D7  0BE7: 3b56b2           cmp dx, word ptr [bp - 0x4e]
  0306DA  0BEA: 7c0d             jl 0xbf9
  0306DC  0BEC: 7f05             jg 0xbf3
  0306DE  0BEE: 3b46b0           cmp ax, word ptr [bp - 0x50]
  0306E1  0BF1: 7606             jbe 0xbf9
  0306E3  0BF3: 8b56b2           mov dx, word ptr [bp - 0x4e]
  0306E6  0BF6: 8b46b0           mov ax, word ptr [bp - 0x50]
  0306E9  0BF9: 8946b0           mov word ptr [bp - 0x50], ax
  0306EC  0BFC: 8956b2           mov word ptr [bp - 0x4e], dx
  0306EF  0BFF: 8b1efc84         mov bx, word ptr [0x84fc]
  0306F3  0C03: 88404c           mov byte ptr [bx + si + 0x4c], al
  0306F6  0C06: eb12             jmp 0xc1a
  0306F8  0C08: 8b46aa           mov ax, word ptr [bp - 0x56]
  0306FB  0C0B: f76e9a           imul word ptr [bp - 0x66]
  0306FE  0C0E: 6bc064           imul ax, ax, 0x64
  030701  0C11: d1e6             shl si, 1
  030703  0C13: 8b1efc84         mov bx, word ptr [0x84fc]
  030707  0C17: 01405c           add word ptr [bx + si + 0x5c], ax
  03070A  0C1A: ff46a2           inc word ptr [bp - 0x5e]
  03070D  0C1D: 837ea20c         cmp word ptr [bp - 0x5e], 0xc
  030711  0C21: 7f7b             jg 0xc9e
  030713  0C23: 837e0800         cmp word ptr [bp + 8], 0
  030717  0C27: 7c08             jl 0xc31
  030719  0C29: 8b4608           mov ax, word ptr [bp + 8]
  03071C  0C2C: 3946a2           cmp word ptr [bp - 0x5e], ax
  03071F  0C2F: 75e9             jne 0xc1a
  030721  0C31: 8b76a2           mov si, word ptr [bp - 0x5e]
  030724  0C34: c1e602           shl si, 2
  030727  0C37: 8b42b4           mov ax, word ptr [bp + si - 0x4c]
  03072A  0C3A: 8b52b6           mov dx, word ptr [bp + si - 0x4a]
  03072D  0C3D: 0bd2             or dx, dx
  03072F  0C3F: 7f0c             jg 0xc4d
  030731  0C41: 7c05             jl 0xc48
  030733  0C43: 3d0100           cmp ax, 1
  030736  0C46: 7305             jae 0xc4d
  030738  0C48: 2bd2             sub dx, dx
  03073A  0C4A: b80100           mov ax, 1
  03073D  0C4D: 8942b4           mov word ptr [bp + si - 0x4c], ax
  030740  0C50: 8952b6           mov word ptr [bp + si - 0x4a], dx
  030743  0C53: 52               push dx
  030744  0C54: 50               push ax
  030745  0C55: 8b46f6           mov ax, word ptr [bp - 0xa]
  030748  0C58: 8b56f8           mov dx, word ptr [bp - 8]
  03074B  0C5B: 8bc8             mov cx, ax
  03074D  0C5D: 8bda             mov bx, dx
  03074F  0C5F: d1e0             shl ax, 1
  030751  0C61: d1d2             rcl dx, 1
  030753  0C63: 03c1             add ax, cx
  030755  0C65: 13d3             adc dx, bx
  030757  0C67: 52               push dx
  030758  0C68: 50               push ax
  030759  0C69: 9ac60e1d0d       lcall 0xd1d, 0xec6
  03075E  0C6E: 8946b0           mov word ptr [bp - 0x50], ax
  030761  0C71: 8956b2           mov word ptr [bp - 0x4e], dx
  030764  0C74: 8b1efc84         mov bx, word ptr [0x84fc]
  030768  0C78: 8b76a2           mov si, word ptr [bp - 0x5e]
  03076B  0C7B: 8bc8             mov cx, ax
  03076D  0C7D: 8a404c           mov al, byte ptr [bx + si + 0x4c]
  030770  0C80: 98               cwde 
  030771  0C81: 8bda             mov bx, dx
  030773  0C83: 99               cdq 
  030774  0C84: 8946fc           mov word ptr [bp - 4], ax
  030777  0C87: 8956fe           mov word ptr [bp - 2], dx
  03077A  0C8A: 2bc1             sub ax, cx
  03077C  0C8C: 8946aa           mov word ptr [bp - 0x56], ax
  03077F  0C8F: 0bc0             or ax, ax
  030781  0C91: 7f03             jg 0xc96
  030783  0C93: e9fafe           jmp 0xb90
  030786  0C96: b80100           mov ax, 1
  030789  0C99: e9fffe           jmp 0xb9b
  03078C  0C9C: 90               nop 
  03078D  0C9D: 90               nop 
  03078E  0C9E: 837e0600         cmp word ptr [bp + 6], 0
  030792  0CA2: 7403             je 0xca7
  030794  0CA4: e99d03           jmp 0x1044
  030797  0CA7: 8b46c4           mov ax, word ptr [bp - 0x3c]
  03079A  0CAA: 8b56c6           mov dx, word ptr [bp - 0x3a]
  03079D  0CAD: d1fa             sar dx, 1
  03079F  0CAF: d1d8             rcr ax, 1
  0307A1  0CB1: 0346b8           add ax, word ptr [bp - 0x48]
  0307A4  0CB4: 1356ba           adc dx, word ptr [bp - 0x46]
  0307A7  0CB7: 0346bc           add ax, word ptr [bp - 0x44]
  0307AA  0CBA: 1356be           adc dx, word ptr [bp - 0x42]
  0307AD  0CBD: 0346c0           add ax, word ptr [bp - 0x40]
  0307B0  0CC0: 1356c2           adc dx, word ptr [bp - 0x3e]
  0307B3  0CC3: 0bd2             or dx, dx
  0307B5  0CC5: 7f0c             jg 0xcd3
  0307B7  0CC7: 7c05             jl 0xcce
  0307B9  0CC9: 3d0100           cmp ax, 1
  0307BC  0CCC: 7305             jae 0xcd3
  0307BE  0CCE: 2bd2             sub dx, dx
  0307C0  0CD0: b80100           mov ax, 1
  0307C3  0CD3: 8946f6           mov word ptr [bp - 0xa], ax
  0307C6  0CD6: 8956f8           mov word ptr [bp - 8], dx
  0307C9  0CD9: c746a20100       mov word ptr [bp - 0x5e], 1
  0307CE  0CDE: eb3c             jmp 0xd1c
  0307D0  0CE0: 0bc0             or ax, ax
  0307D2  0CE2: 7c04             jl 0xce8
  0307D4  0CE4: 2bc0             sub ax, ax
  0307D6  0CE6: eb03             jmp 0xceb
  0307D8  0CE8: b8ffff           mov ax, 0xffff
  0307DB  0CEB: 8946aa           mov word ptr [bp - 0x56], ax
  0307DE  0CEE: 8bde             mov bx, si
  0307E0  0CF0: 8bc6             mov ax, si
  0307E2  0CF2: c1e303           shl bx, 3
  0307E5  0CF5: 03d8             add bx, ax
  0307E7  0CF7: 8a870297         mov al, byte ptr [bx - 0x68fe]
  0307EB  0CFB: 98               cwde 
  0307EC  0CFC: 8bc8             mov cx, ax
  0307EE  0CFE: 8a870197         mov al, byte ptr [bx - 0x68ff]
  0307F2  0D02: 98               cwde 
  0307F3  0D03: 03c1             add ax, cx
  0307F5  0D05: 99               cdq 
  0307F6  0D06: 2bc2             sub ax, dx
  0307F8  0D08: d1f8             sar ax, 1
  0307FA  0D0A: 89469a           mov word ptr [bp - 0x66], ax
  0307FD  0D0D: f76eaa           imul word ptr [bp - 0x56]
  030800  0D10: d1e6             shl si, 1
  030802  0D12: 8b1efc84         mov bx, word ptr [0x84fc]
  030806  0D16: 01405c           add word ptr [bx + si + 0x5c], ax
  030809  0D19: ff46a2           inc word ptr [bp - 0x5e]
  03080C  0D1C: 837ea204         cmp word ptr [bp - 0x5e], 4
  030810  0D20: 7e03             jle 0xd25
  030812  0D22: e9b700           jmp 0xddc
  030815  0D25: 837e0800         cmp word ptr [bp + 8], 0
  030819  0D29: 7c08             jl 0xd33
  03081B  0D2B: 8b4608           mov ax, word ptr [bp + 8]
  03081E  0D2E: 3946a2           cmp word ptr [bp - 0x5e], ax
  030821  0D31: 75e6             jne 0xd19
  030823  0D33: 8b76a2           mov si, word ptr [bp - 0x5e]
  030826  0D36: c1e602           shl si, 2
  030829  0D39: 8b42b4           mov ax, word ptr [bp + si - 0x4c]
  03082C  0D3C: 8b52b6           mov dx, word ptr [bp + si - 0x4a]
  03082F  0D3F: 8946a6           mov word ptr [bp - 0x5a], ax
  030832  0D42: 8956a8           mov word ptr [bp - 0x58], dx
  030835  0D45: 837ea204         cmp word ptr [bp - 0x5e], 4
  030839  0D49: 750a             jne 0xd55
  03083B  0D4B: d1fa             sar dx, 1
  03083D  0D4D: d1d8             rcr ax, 1
  03083F  0D4F: 8946a6           mov word ptr [bp - 0x5a], ax
  030842  0D52: 8956a8           mov word ptr [bp - 0x58], dx
  030845  0D55: 0bd2             or dx, dx
  030847  0D57: 7f0c             jg 0xd65
  030849  0D59: 7c05             jl 0xd60
  03084B  0D5B: 3d0100           cmp ax, 1
  03084E  0D5E: 7305             jae 0xd65
  030850  0D60: 2bd2             sub dx, dx
  030852  0D62: b80100           mov ax, 1
  030855  0D65: 8946a6           mov word ptr [bp - 0x5a], ax
  030858  0D68: 8956a8           mov word ptr [bp - 0x58], dx
  03085B  0D6B: 52               push dx
  03085C  0D6C: 50               push ax
  03085D  0D6D: 8b46f6           mov ax, word ptr [bp - 0xa]
  030860  0D70: 8b56f8           mov dx, word ptr [bp - 8]
  030863  0D73: 8bc8             mov cx, ax
  030865  0D75: 8bda             mov bx, dx
  030867  0D77: d1e0             shl ax, 1
  030869  0D79: d1d2             rcl dx, 1
  03086B  0D7B: 03c1             add ax, cx
  03086D  0D7D: 13d3             adc dx, bx
  03086F  0D7F: 52               push dx
  030870  0D80: 50               push ax
  030871  0D81: 9ac60e1d0d       lcall 0xd1d, 0xec6
  030876  0D86: 8946b0           mov word ptr [bp - 0x50], ax
  030879  0D89: 8956b2           mov word ptr [bp - 0x4e], dx
  03087C  0D8C: 837ea204         cmp word ptr [bp - 0x5e], 4
  030880  0D90: 7524             jne 0xdb6
  030882  0D92: 813e8a53a406     cmp word ptr [0x538a], 0x6a4
  030888  0D98: 7d0c             jge 0xda6
  03088A  0D9A: 050100           add ax, 1
  03088D  0D9D: 83d200           adc dx, 0
  030890  0DA0: 8946b0           mov word ptr [bp - 0x50], ax
  030893  0DA3: 8956b2           mov word ptr [bp - 0x4e], dx
  030896  0DA6: 813e8a534006     cmp word ptr [0x538a], 0x640
  03089C  0DAC: 7d08             jge 0xdb6
  03089E  0DAE: 8346b001         add word ptr [bp - 0x50], 1
  0308A2  0DB2: 8356b200         adc word ptr [bp - 0x4e], 0
  0308A6  0DB6: 8b1efc84         mov bx, word ptr [0x84fc]
  0308AA  0DBA: 8b76a2           mov si, word ptr [bp - 0x5e]
  0308AD  0DBD: 8a404c           mov al, byte ptr [bx + si + 0x4c]
  0308B0  0DC0: 98               cwde 
  0308B1  0DC1: 99               cdq 
  0308B2  0DC2: 8946fc           mov word ptr [bp - 4], ax
  0308B5  0DC5: 8956fe           mov word ptr [bp - 2], dx
  0308B8  0DC8: 2b46b0           sub ax, word ptr [bp - 0x50]
  0308BB  0DCB: 8946aa           mov word ptr [bp - 0x56], ax
  0308BE  0DCE: 0bc0             or ax, ax
  0308C0  0DD0: 7f03             jg 0xdd5
  0308C2  0DD2: e90bff           jmp 0xce0
  0308C5  0DD5: b80100           mov ax, 1
  0308C8  0DD8: e910ff           jmp 0xceb
  0308CB  0DDB: 90               nop 
  0308CC  0DDC: c746a20000       mov word ptr [bp - 0x5e], 0
  0308D1  0DE1: 837e0800         cmp word ptr [bp + 8], 0
  0308D5  0DE5: 7c0b             jl 0xdf2
  0308D7  0DE7: 8b4608           mov ax, word ptr [bp + 8]
  0308DA  0DEA: 3946a2           cmp word ptr [bp - 0x5e], ax
  0308DD  0DED: 7403             je 0xdf2
  0308DF  0DEF: e94602           jmp 0x1038
  0308E2  0DF2: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  0308E5  0DF5: 8bc3             mov ax, bx
  0308E7  0DF7: c1e303           shl bx, 3
  0308EA  0DFA: 03d8             add bx, ax
  0308EC  0DFC: 8a87ff96         mov al, byte ptr [bx - 0x6901]
  0308F0  0E00: 8846a4           mov byte ptr [bp - 0x5c], al
  0308F3  0E03: 837ea20e         cmp word ptr [bp - 0x5e], 0xe
  0308F7  0E07: 7c59             jl 0xe62
  0308F9  0E09: 833e129e04       cmp word ptr [0x9e12], 4
  0308FE  0E0E: 7d0c             jge 0xe1c
  030900  0E10: 6b1e129e34       imul bx, word ptr [0x9e12], 0x34
  030905  0E15: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03090A  0E1A: 7446             je 0xe62
  03090C  0E1C: a18e53           mov ax, word ptr [0x538e]
  03090F  0E1F: 2d5802           sub ax, 0x258
  030912  0E22: b96400           mov cx, 0x64
  030915  0E25: 99               cdq 
  030916  0E26: f7f9             idiv cx
  030918  0E28: 8a16a653         mov dl, byte ptr [0x53a6]
  03091C  0E2C: 80ea04           sub dl, 4
  03091F  0E2F: d0e2             shl dl, 1
  030921  0E31: 02d0             add dl, al
  030923  0E33: 0056a4           add byte ptr [bp - 0x5c], dl
  030926  0E36: 837e0800         cmp word ptr [bp + 8], 0
  03092A  0E3A: 7d26             jge 0xe62
  03092C  0E3C: 8a46a4           mov al, byte ptr [bp - 0x5c]
  03092F  0E3F: 8b1efc84         mov bx, word ptr [0x84fc]
  030933  0E43: 8b76a2           mov si, word ptr [bp - 0x5e]
  030936  0E46: 38404c           cmp byte ptr [bx + si + 0x4c], al
  030939  0E49: 7e17             jle 0xe62
  03093B  0E4B: 8bc6             mov ax, si
  03093D  0E4D: c1e603           shl si, 3
  030940  0E50: 03f0             add si, ax
  030942  0E52: 8a840297         mov al, byte ptr [si - 0x68fe]
  030946  0E56: 98               cwde 
  030947  0E57: 6bc064           imul ax, ax, 0x64
  03094A  0E5A: 8b76a2           mov si, word ptr [bp - 0x5e]
  03094D  0E5D: d1e6             shl si, 1
  03094F  0E5F: 01405c           add word ptr [bx + si + 0x5c], ax
  030952  0E62: c746ae0000       mov word ptr [bp - 0x52], 0
  030957  0E67: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  03095A  0E6A: 8bc3             mov ax, bx
  03095C  0E6C: c1e303           shl bx, 3
  03095F  0E6F: 03d8             add bx, ax
  030961  0E71: 8a870397         mov al, byte ptr [bx - 0x68fd]
  030965  0E75: 98               cwde 
  030966  0E76: 89469c           mov word ptr [bp - 0x64], ax
  030969  0E79: 833e129e03       cmp word ptr [0x9e12], 3
  03096E  0E7E: 750c             jne 0xe8c
  030970  0E80: f6068e5301       test byte ptr [0x538e], 1
  030975  0E85: 7405             je 0xe8c
  030977  0E87: d1e0             shl ax, 1
  030979  0E89: 89469c           mov word ptr [bp - 0x64], ax
  03097C  0E8C: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  03097F  0E8F: 8bc3             mov ax, bx
  030981  0E91: c1e303           shl bx, 3
  030984  0E94: 03d8             add bx, ax
  030986  0E96: b09c             mov al, 0x9c
  030988  0E98: f6af0197         imul byte ptr [bx - 0x68ff]
  03098C  0E9C: 89469a           mov word ptr [bp - 0x66], ax
  03098F  0E9F: 8b4e9c           mov cx, word ptr [bp - 0x64]
  030992  0EA2: 8b76a2           mov si, word ptr [bp - 0x5e]
  030995  0EA5: d1e6             shl si, 1
  030997  0EA7: 8b1efc84         mov bx, word ptr [0x84fc]
  03099B  0EAB: 01485c           add word ptr [bx + si + 0x5c], cx
  03099E  0EAE: 8b485c           mov cx, word ptr [bx + si + 0x5c]
  0309A1  0EB1: 3bc1             cmp ax, cx
  0309A3  0EB3: 7c6a             jl 0xf1f
  0309A5  0EB5: 2bc8             sub cx, ax
  0309A7  0EB7: 89485c           mov word ptr [bx + si + 0x5c], cx
  0309AA  0EBA: 8a46a4           mov al, byte ptr [bp - 0x5c]
  0309AD  0EBD: 8b7ea2           mov di, word ptr [bp - 0x5e]
  0309B0  0EC0: 38414c           cmp byte ptr [bx + di + 0x4c], al
  0309B3  0EC3: 7d5a             jge 0xf1f
  0309B5  0EC5: fe414c           inc byte ptr [bx + di + 0x4c]
  0309B8  0EC8: 833e129e04       cmp word ptr [0x9e12], 4
  0309BD  0ECD: 7d50             jge 0xf1f
  0309BF  0ECF: 6b1e129e34       imul bx, word ptr [0x9e12], 0x34
  0309C4  0ED4: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  0309C9  0ED9: 7544             jne 0xf1f
  0309CB  0EDB: ffb4c097         push word ptr [si - 0x6840]
  0309CF  0EDF: 6a00             push 0
  0309D1  0EE1: 9a38041f18       lcall 0x181f, 0x438
  0309D6  0EE6: 83c404           add sp, 4
  0309D9  0EE9: 8b1e129e         mov bx, word ptr [0x9e12]
  0309DD  0EED: d1e3             shl bx, 1
  0309DF  0EEF: ffb78c83         push word ptr [bx - 0x7c74]
  0309E3  0EF3: 6a01             push 1
  0309E5  0EF5: 9a38041f18       lcall 0x181f, 0x438
  0309EA  0EFA: 83c404           add sp, 4
  0309ED  0EFD: 57               push di
  0309EE  0EFE: 0e               push cs
  0309EF  0EFF: e8215e           call 0x6d23
  0309F2  0F02: 83c402           add sp, 2
  0309F5  0F05: 99               cdq 
  0309F6  0F06: 52               push dx
  0309F7  0F07: 50               push ax
  0309F8  0F08: 6a00             push 0
  0309FA  0F0A: 9aae091f18       lcall 0x181f, 0x9ae
  0309FF  0F0F: 83c406           add sp, 6
  030A02  0F12: 6a02             push 2
  030A04  0F14: 68a80f           push 0xfa8
  030A07  0F17: 9a52061f18       lcall 0x181f, 0x652
  030A0C  0F1C: 83c404           add sp, 4
  030A0F  0F1F: 837eae00         cmp word ptr [bp - 0x52], 0
  030A13  0F23: 7403             je 0xf28
  030A15  0F25: e98e00           jmp 0xfb6
  030A18  0F28: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  030A1B  0F2B: 8bc3             mov ax, bx
  030A1D  0F2D: c1e303           shl bx, 3
  030A20  0F30: 03d8             add bx, ax
  030A22  0F32: b064             mov al, 0x64
  030A24  0F34: f6af0297         imul byte ptr [bx - 0x68fe]
  030A28  0F38: 89469a           mov word ptr [bp - 0x66], ax
  030A2B  0F3B: 8b76a2           mov si, word ptr [bp - 0x5e]
  030A2E  0F3E: d1e6             shl si, 1
  030A30  0F40: 8bcb             mov cx, bx
  030A32  0F42: 8b1efc84         mov bx, word ptr [0x84fc]
  030A36  0F46: 3b405c           cmp ax, word ptr [bx + si + 0x5c]
  030A39  0F49: 7f6b             jg 0xfb6
  030A3B  0F4B: 29405c           sub word ptr [bx + si + 0x5c], ax
  030A3E  0F4E: 8bf9             mov di, cx
  030A40  0F50: 8a85fe96         mov al, byte ptr [di - 0x6902]
  030A44  0F54: 8b7ea2           mov di, word ptr [bp - 0x5e]
  030A47  0F57: 38414c           cmp byte ptr [bx + di + 0x4c], al
  030A4A  0F5A: 7e5a             jle 0xfb6
  030A4C  0F5C: fe494c           dec byte ptr [bx + di + 0x4c]
  030A4F  0F5F: 833e129e04       cmp word ptr [0x9e12], 4
  030A54  0F64: 7d50             jge 0xfb6
  030A56  0F66: 6b1e129e34       imul bx, word ptr [0x9e12], 0x34
  030A5B  0F6B: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  030A60  0F70: 7544             jne 0xfb6
  030A62  0F72: ffb4c097         push word ptr [si - 0x6840]
  030A66  0F76: 6a00             push 0
  030A68  0F78: 9a38041f18       lcall 0x181f, 0x438
  030A6D  0F7D: 83c404           add sp, 4
  030A70  0F80: 8b1e129e         mov bx, word ptr [0x9e12]
  030A74  0F84: d1e3             shl bx, 1
  030A76  0F86: ffb78c83         push word ptr [bx - 0x7c74]
  030A7A  0F8A: 6a01             push 1
  030A7C  0F8C: 9a38041f18       lcall 0x181f, 0x438
  030A81  0F91: 83c404           add sp, 4
  030A84  0F94: 57               push di
  030A85  0F95: 0e               push cs
  030A86  0F96: e88a5d           call 0x6d23
  030A89  0F99: 83c402           add sp, 2
  030A8C  0F9C: 99               cdq 
  030A8D  0F9D: 52               push dx
  030A8E  0F9E: 50               push ax
  030A8F  0F9F: 6a00             push 0
  030A91  0FA1: 9aae091f18       lcall 0x181f, 0x9ae
  030A96  0FA6: 83c406           add sp, 6
  030A99  0FA9: 6a02             push 2
  030A9B  0FAB: 68b00f           push 0xfb0
  030A9E  0FAE: 9a52061f18       lcall 0x181f, 0x652
  030AA3  0FB3: 83c404           add sp, 4
  030AA6  0FB6: 837e0800         cmp word ptr [bp + 8], 0
  030AAA  0FBA: 7c0f             jl 0xfcb
  030AAC  0FBC: 8b469c           mov ax, word ptr [bp - 0x64]
  030AAF  0FBF: 8b76a2           mov si, word ptr [bp - 0x5e]
  030AB2  0FC2: d1e6             shl si, 1
  030AB4  0FC4: 8b1efc84         mov bx, word ptr [0x84fc]
  030AB8  0FC8: 29405c           sub word ptr [bx + si + 0x5c], ax
  030ABB  0FCB: 833e129e04       cmp word ptr [0x9e12], 4
  030AC0  0FD0: 7d0c             jge 0xfde
  030AC2  0FD2: 6b1e129e34       imul bx, word ptr [0x9e12], 0x34
  030AC7  0FD7: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  030ACC  0FDC: 743f             je 0x101d
  030ACE  0FDE: c646f419         mov byte ptr [bp - 0xc], 0x19
  030AD2  0FE2: 837ea20f         cmp word ptr [bp - 0x5e], 0xf
  030AD6  0FE6: 740c             je 0xff4
  030AD8  0FE8: 837ea20e         cmp word ptr [bp - 0x5e], 0xe
  030ADC  0FEC: 7406             je 0xff4
  030ADE  0FEE: 837ea208         cmp word ptr [bp - 0x5e], 8
  030AE2  0FF2: 7529             jne 0x101d
  030AE4  0FF4: a0a653           mov al, byte ptr [0x53a6]
  030AE7  0FF7: 2ae4             sub ah, ah
  030AE9  0FF9: 2d0400           sub ax, 4
  030AEC  0FFC: f7d8             neg ax
  030AEE  0FFE: 8bc8             mov cx, ax
  030AF0  1000: d1e0             shl ax, 1
  030AF2  1002: 03c1             add ax, cx
  030AF4  1004: d1f8             sar ax, 1
  030AF6  1006: 0403             add al, 3
  030AF8  1008: 8846f4           mov byte ptr [bp - 0xc], al
  030AFB  100B: 8b1efc84         mov bx, word ptr [0x84fc]
  030AFF  100F: 8b76a2           mov si, word ptr [bp - 0x5e]
  030B02  1012: 3a404c           cmp al, byte ptr [bx + si + 0x4c]
  030B05  1015: 7e03             jle 0x101a
  030B07  1017: 8a404c           mov al, byte ptr [bx + si + 0x4c]
  030B0A  101A: 88404c           mov byte ptr [bx + si + 0x4c], al
  030B0D  101D: 8b1efc84         mov bx, word ptr [0x84fc]
  030B11  1021: 8b76a2           mov si, word ptr [bp - 0x5e]
  030B14  1024: 8a404c           mov al, byte ptr [bx + si + 0x4c]
  030B17  1027: 98               cwde 
  030B18  1028: 48               dec ax
  030B19  1029: 7902             jns 0x102d
  030B1B  102B: 2bc0             sub ax, ax
  030B1D  102D: 8b1e129e         mov bx, word ptr [0x9e12]
  030B21  1031: c1e304           shl bx, 4
  030B24  1034: 8880bc84         mov byte ptr [bx + si - 0x7b44], al
  030B28  1038: ff46a2           inc word ptr [bp - 0x5e]
  030B2B  103B: 837ea210         cmp word ptr [bp - 0x5e], 0x10
  030B2F  103F: 7d03             jge 0x1044
  030B31  1041: e99dfd           jmp 0xde1
  030B34  1044: 5e               pop si
  030B35  1045: 5f               pop di
  030B36  1046: c9               leave 
  030B37  1047: cb               retf 

; ---- func_030B38  size=20  insns=9  prologue=push bp;mov bp,sp  terminal=RETF ----
  030B38  1048: 55               push bp
  030B39  1049: 8bec             mov bp, sp
  030B3B  104B: b80100           mov ax, 1
  030B3E  104E: 8a4e06           mov cl, byte ptr [bp + 6]
  030B41  1051: d3e0             shl ax, cl
  030B43  1053: 8b1efc84         mov bx, word ptr [0x84fc]
  030B47  1057: 234720           and ax, word ptr [bx + 0x20]
  030B4A  105A: c9               leave 
  030B4B  105B: cb               retf 

; ---- func_030B4C  size=105  insns=40  prologue=ENTER 0x0004,0  terminal=RET ----
  030B4C  105C: c8040000         enter 4, 0
  030B50  1060: 2bc0             sub ax, ax
  030B52  1062: 8946fe           mov word ptr [bp - 2], ax
  030B55  1065: 8b5e04           mov bx, word ptr [bp + 4]
  030B58  1068: 8907             mov word ptr [bx], ax
  030B5A  106A: a1129e           mov ax, word ptr [0x9e12]
  030B5D  106D: 2d1400           sub ax, 0x14
  030B60  1070: 8bd0             mov dx, ax
  030B62  1072: 9ae0071f18       lcall 0x181f, 0x7e0
  030B67  1077: eb40             jmp 0x10b9
  030B69  1079: 90               nop 
  030B6A  107A: 6b5efc1c         imul bx, word ptr [bp - 4], 0x1c
  030B6E  107E: 8bc3             mov ax, bx
  030B70  1080: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  030B74  1084: 8bcb             mov cx, bx
  030B76  1086: 2aff             sub bh, bh
  030B78  1088: 8bd3             mov dx, bx
  030B7A  108A: d1e3             shl bx, 1
  030B7C  108C: 03da             add bx, dx
  030B7E  108E: d1e3             shl bx, 1
  030B80  1090: 03da             add bx, dx
  030B82  1092: d1e3             shl bx, 1
  030B84  1094: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  030B89  1099: 7416             je 0x10b1
  030B8B  109B: 8bd8             mov bx, ax
  030B8D  109D: f687483180       test byte ptr [bx + 0x3148], 0x80
  030B92  10A2: 740a             je 0x10ae
  030B94  10A4: 80f90b           cmp cl, 0xb
  030B97  10A7: 7405             je 0x10ae
  030B99  10A9: 8b5e04           mov bx, word ptr [bp + 4]
  030B9C  10AC: ff07             inc word ptr [bx]
  030B9E  10AE: ff46fe           inc word ptr [bp - 2]
  030BA1  10B1: 8b46fc           mov ax, word ptr [bp - 4]
  030BA4  10B4: 9ae4021f18       lcall 0x181f, 0x2e4
  030BA9  10B9: 8946fc           mov word ptr [bp - 4], ax
  030BAC  10BC: 0bc0             or ax, ax
  030BAE  10BE: 7dba             jge 0x107a
  030BB0  10C0: 8b46fe           mov ax, word ptr [bp - 2]
  030BB3  10C3: c9               leave 
  030BB4  10C4: c3               ret 

; ---- func_030BB6  size=94  insns=34  prologue=ENTER 0x0006,0  terminal=RETF ----
  030BB6  10C6: c8060000         enter 6, 0
  030BBA  10CA: b8ffff           mov ax, 0xffff
  030BBD  10CD: 8946fc           mov word ptr [bp - 4], ax
  030BC0  10D0: 8946fe           mov word ptr [bp - 2], ax
  030BC3  10D3: a1129e           mov ax, word ptr [0x9e12]
  030BC6  10D6: 2d1400           sub ax, 0x14
  030BC9  10D9: 8bd0             mov dx, ax
  030BCB  10DB: 9ae0071f18       lcall 0x181f, 0x7e0
  030BD0  10E0: eb36             jmp 0x1118
  030BD2  10E2: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  030BD6  10E6: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  030BDA  10EA: 2aff             sub bh, bh
  030BDC  10EC: 8bc3             mov ax, bx
  030BDE  10EE: d1e3             shl bx, 1
  030BE0  10F0: 03d8             add bx, ax
  030BE2  10F2: d1e3             shl bx, 1
  030BE4  10F4: 03d8             add bx, ax
  030BE6  10F6: d1e3             shl bx, 1
  030BE8  10F8: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  030BED  10FD: 7411             je 0x1110
  030BEF  10FF: 8b4606           mov ax, word ptr [bp + 6]
  030BF2  1102: ff46fc           inc word ptr [bp - 4]
  030BF5  1105: 3946fc           cmp word ptr [bp - 4], ax
  030BF8  1108: 7506             jne 0x1110
  030BFA  110A: 8b46fa           mov ax, word ptr [bp - 6]
  030BFD  110D: 8946fe           mov word ptr [bp - 2], ax
  030C00  1110: 8b46fa           mov ax, word ptr [bp - 6]
  030C03  1113: 9ae4021f18       lcall 0x181f, 0x2e4
  030C08  1118: 8946fa           mov word ptr [bp - 6], ax
  030C0B  111B: 0bc0             or ax, ax
  030C0D  111D: 7dc3             jge 0x10e2
  030C0F  111F: 8b46fe           mov ax, word ptr [bp - 2]
  030C12  1122: c9               leave 
  030C13  1123: cb               retf 

; ---- func_030C14  size=83  insns=28  prologue=ENTER 0x0006,0  terminal=RETF ----
  030C14  1124: c8060000         enter 6, 0
  030C18  1128: b8ffff           mov ax, 0xffff
  030C1B  112B: 8946fa           mov word ptr [bp - 6], ax
  030C1E  112E: 8946fe           mov word ptr [bp - 2], ax
  030C21  1131: a1129e           mov ax, word ptr [0x9e12]
  030C24  1134: 2d1400           sub ax, 0x14
  030C27  1137: 8bd0             mov dx, ax
  030C29  1139: 9ae0071f18       lcall 0x181f, 0x7e0
  030C2E  113E: eb2b             jmp 0x116b
  030C30  1140: 6b5efc1c         imul bx, word ptr [bp - 4], 0x1c
  030C34  1144: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  030C39  1149: 7207             jb 0x1152
  030C3B  114B: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  030C40  1150: 7611             jbe 0x1163
  030C42  1152: 8b4606           mov ax, word ptr [bp + 6]
  030C45  1155: ff46fa           inc word ptr [bp - 6]
  030C48  1158: 3946fa           cmp word ptr [bp - 6], ax
  030C4B  115B: 7506             jne 0x1163
  030C4D  115D: 8b46fc           mov ax, word ptr [bp - 4]
  030C50  1160: 8946fe           mov word ptr [bp - 2], ax
  030C53  1163: 8b46fc           mov ax, word ptr [bp - 4]
  030C56  1166: 9ae4021f18       lcall 0x181f, 0x2e4
  030C5B  116B: 8946fc           mov word ptr [bp - 4], ax
  030C5E  116E: 0bc0             or ax, ax
  030C60  1170: 7dce             jge 0x1140
  030C62  1172: 8b46fe           mov ax, word ptr [bp - 2]
  030C65  1175: c9               leave 
  030C66  1176: cb               retf 

; ---- func_030C68  size=174  insns=54  prologue=ENTER 0x0006,0  terminal=RETF ----
  030C68  1178: c8060000         enter 6, 0
  030C6C  117C: c746fe0000       mov word ptr [bp - 2], 0
  030C71  1181: 837e0614         cmp word ptr [bp + 6], 0x14
  030C75  1185: 7505             jne 0x118c
  030C77  1187: c746fe0200       mov word ptr [bp - 2], 2
  030C7C  118C: 837e0618         cmp word ptr [bp + 6], 0x18
  030C80  1190: 7505             jne 0x1197
  030C82  1192: c746fe0300       mov word ptr [bp - 2], 3
  030C87  1197: 837e0616         cmp word ptr [bp + 6], 0x16
  030C8B  119B: 7505             jne 0x11a2
  030C8D  119D: c746fe0500       mov word ptr [bp - 2], 5
  030C92  11A2: 837e0615         cmp word ptr [bp + 6], 0x15
  030C96  11A6: 7541             jne 0x11e9
  030C98  11A8: c746fe0100       mov word ptr [bp - 2], 1
  030C9D  11AD: 833e129e04       cmp word ptr [0x9e12], 4
  030CA2  11B2: 7d16             jge 0x11ca
  030CA4  11B4: 6b1e129e34       imul bx, word ptr [0x9e12], 0x34
  030CA9  11B9: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  030CAE  11BE: 750a             jne 0x11ca
  030CB0  11C0: a0a653           mov al, byte ptr [0x53a6]
  030CB3  11C3: 2ae4             sub ah, ah
  030CB5  11C5: 8946fc           mov word ptr [bp - 4], ax
  030CB8  11C8: eb05             jmp 0x11cf
  030CBA  11CA: c746fc0100       mov word ptr [bp - 4], 1
  030CBF  11CF: 8b46fc           mov ax, word ptr [bp - 4]
  030CC2  11D2: 050400           add ax, 4
  030CC5  11D5: 50               push ax
  030CC6  11D6: 6a00             push 0
  030CC8  11D8: 9ad4041f18       lcall 0x181f, 0x4d4
  030CCD  11DD: 83c404           add sp, 4
  030CD0  11E0: 0bc0             or ax, ax
  030CD2  11E2: 7505             jne 0x11e9
  030CD4  11E4: c746fe0400       mov word ptr [bp - 2], 4
  030CD9  11E9: a1129e           mov ax, word ptr [0x9e12]
  030CDC  11EC: 2d1400           sub ax, 0x14
  030CDF  11EF: 50               push ax
  030CE0  11F0: 50               push ax
  030CE1  11F1: ff36129e         push word ptr [0x9e12]
  030CE5  11F5: ff76fe           push word ptr [bp - 2]
  030CE8  11F8: 9a5c091f18       lcall 0x181f, 0x95c
  030CED  11FD: 83c408           add sp, 8
  030CF0  1200: 8946fa           mov word ptr [bp - 6], ax
  030CF3  1203: 0bc0             or ax, ax
  030CF5  1205: 7c1a             jl 0x1221
  030CF7  1207: 6bd81c           imul bx, ax, 0x1c
  030CFA  120A: c6874c3101       mov byte ptr [bx + 0x314c], 1
  030CFF  120F: 8a4606           mov al, byte ptr [bp + 6]
  030D02  1212: 88875b31         mov byte ptr [bx + 0x315b], al
  030D06  1216: 837efe02         cmp word ptr [bp - 2], 2
  030D0A  121A: 7505             jne 0x1221
  030D0C  121C: c687593164       mov byte ptr [bx + 0x3159], 0x64
  030D11  1221: 8b46fa           mov ax, word ptr [bp - 6]
  030D14  1224: c9               leave 
  030D15  1225: cb               retf 

; ---- func_030D16  size=111  insns=37  prologue=ENTER 0x0002,0  terminal=RETF ----
  030D16  1226: c8020000         enter 2, 0
  030D1A  122A: c7062a9e0000     mov word ptr [0x9e2a], 0
  030D20  1230: a1129e           mov ax, word ptr [0x9e12]
  030D23  1233: 2d1400           sub ax, 0x14
  030D26  1236: 8bd0             mov dx, ax
  030D28  1238: 9ae0071f18       lcall 0x181f, 0x7e0
  030D2D  123D: eb1e             jmp 0x125d
  030D2F  123F: 90               nop 
  030D30  1240: 6bd81c           imul bx, ax, 0x1c
  030D33  1243: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  030D38  1248: 7207             jb 0x1251
  030D3A  124A: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  030D3F  124F: 7604             jbe 0x1255
  030D41  1251: ff062a9e         inc word ptr [0x9e2a]
  030D45  1255: 8b46fe           mov ax, word ptr [bp - 2]
  030D48  1258: 9ae4021f18       lcall 0x181f, 0x2e4
  030D4D  125D: 8946fe           mov word ptr [bp - 2], ax
  030D50  1260: 0bc0             or ax, ax
  030D52  1262: 7ddc             jge 0x1240
  030D54  1264: 833e2a9e00       cmp word ptr [0x9e2a], 0
  030D59  1269: 740f             je 0x127a
  030D5B  126B: a12a9e           mov ax, word ptr [0x9e2a]
  030D5E  126E: 39062c9e         cmp word ptr [0x9e2c], ax
  030D62  1272: 7c06             jl 0x127a
  030D64  1274: c7062c9e0000     mov word ptr [0x9e2c], 0
  030D6A  127A: c9               leave 
  030D6B  127B: cb               retf 
  030D6C  127C: 68a40f           push 0xfa4
  030D6F  127F: e8dafd           call 0x105c
  030D72  1282: 83c402           add sp, 2
  030D75  1285: a3a20f           mov word ptr [0xfa2], ax
  030D78  1288: 2bc0             sub ax, ax
  030D7A  128A: a3209e           mov word ptr [0x9e20], ax
  030D7D  128D: a31c9e           mov word ptr [0x9e1c], ax
  030D80  1290: 0e               push cs
  030D81  1291: e8ee5a           call 0x6d82
  030D84  1294: cb               retf 

; ---- func_030D86  size=110  insns=36  prologue=push bp;mov bp,sp  terminal=RETF ----
  030D86  1296: 55               push bp
  030D87  1297: 8bec             mov bp, sp
  030D89  1299: ff36a483         push word ptr [0x83a4]
  030D8D  129D: ff36a283         push word ptr [0x83a2]
  030D91  12A1: ff36a083         push word ptr [0x83a0]
  030D95  12A5: ff369e83         push word ptr [0x839e]
  030D99  12A9: ff36ae2d         push word ptr [0x2dae]
  030D9D  12AD: ff36ac2d         push word ptr [0x2dac]
  030DA1  12B1: ff36aa2d         push word ptr [0x2daa]
  030DA5  12B5: ff36a82d         push word ptr [0x2da8]
  030DA9  12B9: ff760c           push word ptr [bp + 0xc]
  030DAC  12BC: 8b4606           mov ax, word ptr [bp + 6]
  030DAF  12BF: 8b5608           mov dx, word ptr [bp + 8]
  030DB2  12C2: 8b5e0a           mov bx, word ptr [bp + 0xa]
  030DB5  12C5: 9a44041f18       lcall 0x181f, 0x444
  030DBA  12CA: c9               leave 
  030DBB  12CB: cb               retf 
  030DBC  12CC: 6a00             push 0
  030DBE  12CE: ff36a483         push word ptr [0x83a4]
  030DC2  12D2: ff36a283         push word ptr [0x83a2]
  030DC6  12D6: ff36a083         push word ptr [0x83a0]
  030DCA  12DA: ff369e83         push word ptr [0x839e]
  030DCE  12DE: 68ba0f           push 0xfba
  030DD1  12E1: 9a7a081f19       lcall 0x191f, 0x87a
  030DD6  12E6: 83c40c           add sp, 0xc
  030DD9  12E9: 0bc0             or ax, ax
  030DDB  12EB: 7416             je 0x1303
  030DDD  12ED: 6a00             push 0
  030DDF  12EF: 6a00             push 0
  030DE1  12F1: 6a00             push 0
  030DE3  12F3: 6a00             push 0
  030DE5  12F5: b8adff           mov ax, 0xffad
  030DE8  12F8: ba0200           mov dx, 2
  030DEB  12FB: bb2b00           mov bx, 0x2b
  030DEE  12FE: 9a72071f18       lcall 0x181f, 0x772
  030DF3  1303: cb               retf 

; ---- func_030DF4  size=385  insns=139  prologue=ENTER 0x0064,0  terminal=RETF ----
  030DF4  1304: c8640000         enter 0x64, 0
  030DF8  1308: 56               push si
  030DF9  1309: c646b000         mov byte ptr [bp - 0x50], 0
  030DFD  130D: 8b5e06           mov bx, word ptr [bp + 6]
  030E00  1310: d1e3             shl bx, 1
  030E02  1312: ffb7c097         push word ptr [bx - 0x6840]
  030E06  1316: 8d46b0           lea ax, [bp - 0x50]
  030E09  1319: 50               push ax
  030E0A  131A: 9a6e011f18       lcall 0x181f, 0x16e
  030E0F  131F: 83c404           add sp, 4
  030E12  1322: 8d46b0           lea ax, [bp - 0x50]
  030E15  1325: 50               push ax
  030E16  1326: 9a78011f18       lcall 0x181f, 0x178
  030E1B  132B: 83c402           add sp, 2
  030E1E  132E: 8d46b0           lea ax, [bp - 0x50]
  030E21  1331: 50               push ax
  030E22  1332: 9a1e011f18       lcall 0x181f, 0x11e
  030E27  1337: 83c402           add sp, 2
  030E2A  133A: ff7606           push word ptr [bp + 6]
  030E2D  133D: 0e               push cs
  030E2E  133E: e8965a           call 0x6dd7
  030E31  1341: 83c402           add sp, 2
  030E34  1344: 0bc0             or ax, ax
  030E36  1346: 7412             je 0x135a
  030E38  1348: ff36c02e         push word ptr [0x2ec0]
  030E3C  134C: 8d46b0           lea ax, [bp - 0x50]
  030E3F  134F: 50               push ax
  030E40  1350: 9a6e011f18       lcall 0x181f, 0x16e
  030E45  1355: 83c404           add sp, 4
  030E48  1358: eb74             jmp 0x13ce
  030E4A  135A: ff36b42e         push word ptr [0x2eb4]
  030E4E  135E: 8d46b0           lea ax, [bp - 0x50]
  030E51  1361: 50               push ax
  030E52  1362: 9a6e011f18       lcall 0x181f, 0x16e
  030E57  1367: 83c404           add sp, 4
  030E5A  136A: 8d46b0           lea ax, [bp - 0x50]
  030E5D  136D: 50               push ax
  030E5E  136E: 9a78011f18       lcall 0x181f, 0x178
  030E63  1373: 83c402           add sp, 2
  030E66  1376: ff7606           push word ptr [bp + 6]
  030E69  1379: 0e               push cs
  030E6A  137A: e8a659           call 0x6d23
  030E6D  137D: 83c402           add sp, 2
  030E70  1380: 50               push ax
  030E71  1381: 8d46b0           lea ax, [bp - 0x50]
  030E74  1384: 16               push ss
  030E75  1385: 50               push ax
  030E76  1386: 9a82011f18       lcall 0x181f, 0x182
  030E7B  138B: 83c406           add sp, 6
  030E7E  138E: 8d46b0           lea ax, [bp - 0x50]
  030E81  1391: 50               push ax
  030E82  1392: 9ab4011f18       lcall 0x181f, 0x1b4
  030E87  1397: 83c402           add sp, 2
  030E8A  139A: ff36b22e         push word ptr [0x2eb2]
  030E8E  139E: 8d46b0           lea ax, [bp - 0x50]
  030E91  13A1: 50               push ax
  030E92  13A2: 9a6e011f18       lcall 0x181f, 0x16e
  030E97  13A7: 83c404           add sp, 4
  030E9A  13AA: 8d46b0           lea ax, [bp - 0x50]
  030E9D  13AD: 50               push ax
  030E9E  13AE: 9a78011f18       lcall 0x181f, 0x178
  030EA3  13B3: 83c402           add sp, 2
  030EA6  13B6: ff7606           push word ptr [bp + 6]
  030EA9  13B9: 0e               push cs
  030EAA  13BA: e8e359           call 0x6da0
  030EAD  13BD: 83c402           add sp, 2
  030EB0  13C0: 50               push ax
  030EB1  13C1: 8d46b0           lea ax, [bp - 0x50]
  030EB4  13C4: 16               push ss
  030EB5  13C5: 50               push ax
  030EB6  13C6: 9a82011f18       lcall 0x181f, 0x182
  030EBB  13CB: 83c406           add sp, 6
  030EBE  13CE: 8d46b0           lea ax, [bp - 0x50]
  030EC1  13D1: 50               push ax
  030EC2  13D2: 9a28011f18       lcall 0x181f, 0x128
  030EC7  13D7: 83c402           add sp, 2
  030ECA  13DA: c746ae0100       mov word ptr [bp - 0x52], 1
  030ECF  13DF: c746acb500       mov word ptr [bp - 0x54], 0xb5
  030ED4  13E4: 6b460613         imul ax, word ptr [bp + 6], 0x13
  030ED8  13E8: 050a00           add ax, 0xa
  030EDB  13EB: 8946a4           mov word ptr [bp - 0x5c], ax
  030EDE  13EE: ff36a008         push word ptr [0x8a0]
  030EE2  13F2: ff369e08         push word ptr [0x89e]
  030EE6  13F6: 8d4eb0           lea cx, [bp - 0x50]
  030EE9  13F9: 16               push ss
  030EEA  13FA: 51               push cx
  030EEB  13FB: 8bf0             mov si, ax
  030EED  13FD: 2bc0             sub ax, ax
  030EEF  13FF: 9a04021f18       lcall 0x181f, 0x204
  030EF4  1404: 48               dec ax
  030EF5  1405: 89469c           mov word ptr [bp - 0x64], ax
  030EF8  1408: 40               inc ax
  030EF9  1409: 40               inc ax
  030EFA  140A: 8946a0           mov word ptr [bp - 0x60], ax
  030EFD  140D: 8bc8             mov cx, ax
  030EFF  140F: 2d3101           sub ax, 0x131
  030F02  1412: f7d8             neg ax
  030F04  1414: 50               push ax
  030F05  1415: 6a00             push 0
  030F07  1417: 8bc1             mov ax, cx
  030F09  1419: d1f9             sar cx, 1
  030F0B  141B: 2bf1             sub si, cx
  030F0D  141D: 56               push si
  030F0E  141E: 8bf0             mov si, ax
  030F10  1420: 9a5c031f18       lcall 0x181f, 0x35c
  030F15  1425: 83c406           add sp, 6
  030F18  1428: 8946aa           mov word ptr [bp - 0x56], ax
  030F1B  142B: ff36ae2d         push word ptr [0x2dae]
  030F1F  142F: ff36ac2d         push word ptr [0x2dac]
  030F23  1433: ff36aa2d         push word ptr [0x2daa]
  030F27  1437: ff36a82d         push word ptr [0x2da8]
  030F2B  143B: b80700           mov ax, 7
  030F2E  143E: 89469e           mov word ptr [bp - 0x62], ax
  030F31  1441: 50               push ax
  030F32  1442: 6a00             push 0
  030F34  1444: bac100           mov dx, 0xc1
  030F37  1447: 8956a8           mov word ptr [bp - 0x58], dx
  030F3A  144A: 8bde             mov bx, si
  030F3C  144C: 8b46aa           mov ax, word ptr [bp - 0x56]
  030F3F  144F: 9aba001f18       lcall 0x181f, 0xba
  030F44  1454: 6a0f             push 0xf
  030F46  1456: b8ffff           mov ax, 0xffff
  030F49  1459: ba0f00           mov dx, 0xf
  030F4C  145C: 8bda             mov bx, dx
  030F4E  145E: 9af0011f18       lcall 0x181f, 0x1f0
  030F53  1463: ff36a008         push word ptr [0x8a0]
  030F57  1467: ff369e08         push word ptr [0x89e]
  030F5B  146B: 8d46b0           lea ax, [bp - 0x50]
  030F5E  146E: 16               push ss
  030F5F  146F: 50               push ax
  030F60  1470: 6a00             push 0
  030F62  1472: 8b46aa           mov ax, word ptr [bp - 0x56]
  030F65  1475: 40               inc ax
  030F66  1476: 8d1ea82d         lea bx, [0x2da8]
  030F6A  147A: bac200           mov dx, 0xc2
  030F6D  147D: 9afa011f18       lcall 0x181f, 0x1fa
  030F72  1482: 5e               pop si
  030F73  1483: c9               leave 
  030F74  1484: cb               retf 

; ---- func_030F76  size=318  insns=112  prologue=ENTER 0x0064,0  terminal=RET ----
  030F76  1486: c8640000         enter 0x64, 0
  030F7A  148A: 8b1e129e         mov bx, word ptr [0x9e12]
  030F7E  148E: d1e3             shl bx, 1
  030F80  1490: ffb78c83         push word ptr [bx - 0x7c74]
  030F84  1494: 9a22001f18       lcall 0x181f, 0x22
  030F89  1499: 83c402           add sp, 2
  030F8C  149C: 52               push dx
  030F8D  149D: 50               push ax
  030F8E  149E: 8d46b0           lea ax, [bp - 0x50]
  030F91  14A1: 16               push ss
  030F92  14A2: 50               push ax
  030F93  14A3: 9a7e111d0d       lcall 0xd1d, 0x117e
  030F98  14A8: 83c408           add sp, 8
  030F9B  14AB: 8d46b0           lea ax, [bp - 0x50]
  030F9E  14AE: 50               push ax
  030F9F  14AF: 9ab4011f18       lcall 0x181f, 0x1b4
  030FA4  14B4: 83c402           add sp, 2
  030FA7  14B7: 8b1e129e         mov bx, word ptr [0x9e12]
  030FAB  14BB: d1e3             shl bx, 1
  030FAD  14BD: ffb7428d         push word ptr [bx - 0x72be]
  030FB1  14C1: 9a22001f18       lcall 0x181f, 0x22
  030FB6  14C6: 83c402           add sp, 2
  030FB9  14C9: 52               push dx
  030FBA  14CA: 50               push ax
  030FBB  14CB: 8d46b0           lea ax, [bp - 0x50]
  030FBE  14CE: 16               push ss
  030FBF  14CF: 50               push ax
  030FC0  14D0: 9ab4111d0d       lcall 0xd1d, 0x11b4
  030FC5  14D5: 83c408           add sp, 8
  030FC8  14D8: 8d46b0           lea ax, [bp - 0x50]
  030FCB  14DB: 50               push ax
  030FCC  14DC: 9adc011f18       lcall 0x181f, 0x1dc
  030FD1  14E1: 83c402           add sp, 2
  030FD4  14E4: 8b1e8c53         mov bx, word ptr [0x538c]
  030FD8  14E8: d1e3             shl bx, 1
  030FDA  14EA: ffb70098         push word ptr [bx - 0x6800]
  030FDE  14EE: 9a22001f18       lcall 0x181f, 0x22
  030FE3  14F3: 83c402           add sp, 2
  030FE6  14F6: 52               push dx
  030FE7  14F7: 50               push ax
  030FE8  14F8: 8d46b0           lea ax, [bp - 0x50]
  030FEB  14FB: 16               push ss
  030FEC  14FC: 50               push ax
  030FED  14FD: 9ab4111d0d       lcall 0xd1d, 0x11b4
  030FF2  1502: 83c408           add sp, 8
  030FF5  1505: 8d46b0           lea ax, [bp - 0x50]
  030FF8  1508: 50               push ax
  030FF9  1509: 9ab4011f18       lcall 0x181f, 0x1b4
  030FFE  150E: 83c402           add sp, 2
  031001  1511: 6a0a             push 0xa
  031003  1513: 8d469c           lea ax, [bp - 0x64]
  031006  1516: 50               push ax
  031007  1517: ff368a53         push word ptr [0x538a]
  03100B  151B: 9afa081d0d       lcall 0xd1d, 0x8fa
  031010  1520: 83c406           add sp, 6
  031013  1523: 8d469c           lea ax, [bp - 0x64]
  031016  1526: 50               push ax
  031017  1527: 8d46b0           lea ax, [bp - 0x50]
  03101A  152A: 50               push ax
  03101B  152B: 9aa4071d0d       lcall 0xd1d, 0x7a4
  031020  1530: 83c404           add sp, 4
  031023  1533: 8d46b0           lea ax, [bp - 0x50]
  031026  1536: 50               push ax
  031027  1537: 9adc011f18       lcall 0x181f, 0x1dc
  03102C  153C: 83c402           add sp, 2
  03102F  153F: ff36b093         push word ptr [0x93b0]
  031033  1543: 8d46b0           lea ax, [bp - 0x50]
  031036  1546: 50               push ax
  031037  1547: 9a6e011f18       lcall 0x181f, 0x16e
  03103C  154C: 83c404           add sp, 4
  03103F  154F: 8b1efc84         mov bx, word ptr [0x84fc]
  031043  1553: 8a4701           mov al, byte ptr [bx + 1]
  031046  1556: 98               cwde 
  031047  1557: 50               push ax
  031048  1558: 8d46b0           lea ax, [bp - 0x50]
  03104B  155B: 16               push ss
  03104C  155C: 50               push ax
  03104D  155D: 9a82011f18       lcall 0x181f, 0x182
  031052  1562: 83c406           add sp, 6
  031055  1565: 8d46b0           lea ax, [bp - 0x50]
  031058  1568: 50               push ax
  031059  1569: 9a0a011f18       lcall 0x181f, 0x10a
  03105E  156E: 83c402           add sp, 2
  031061  1571: 8d46b0           lea ax, [bp - 0x50]
  031064  1574: 50               push ax
  031065  1575: 9a78011f18       lcall 0x181f, 0x178
  03106A  157A: 83c402           add sp, 2
  03106D  157D: 8d46b0           lea ax, [bp - 0x50]
  031070  1580: 50               push ax
  031071  1581: 9a78011f18       lcall 0x181f, 0x178
  031076  1586: 83c402           add sp, 2
  031079  1589: ff36a093         push word ptr [0x93a0]
  03107D  158D: 8d46b0           lea ax, [bp - 0x50]
  031080  1590: 50               push ax
  031081  1591: 9a6e011f18       lcall 0x181f, 0x16e
  031086  1596: 83c404           add sp, 4
  031089  1599: 8d46b0           lea ax, [bp - 0x50]
  03108C  159C: 50               push ax
  03108D  159D: 9a78011f18       lcall 0x181f, 0x178
  031092  15A2: 83c402           add sp, 2
  031095  15A5: 8d46b0           lea ax, [bp - 0x50]
  031098  15A8: 50               push ax
  031099  15A9: ff36129e         push word ptr [0x9e12]
  03109D  15AD: 9a1e0b1f18       lcall 0x181f, 0xb1e
  0310A2  15B2: 83c404           add sp, 4
  0310A5  15B5: 8d46b0           lea ax, [bp - 0x50]
  0310A8  15B8: 16               push ss
  0310A9  15B9: 50               push ax
  0310AA  15BA: ff7604           push word ptr [bp + 4]
  0310AD  15BD: 9ab0001f18       lcall 0x181f, 0xb0
  0310B2  15C2: c9               leave 
  0310B3  15C3: c3               ret 

; ---- func_0310B4  size=483  insns=171  prologue=ENTER 0x0074,0  terminal=RET ----
  0310B4  15C4: c8740000         enter 0x74, 0
  0310B8  15C8: 56               push si
  0310B9  15C9: 6a15             push 0x15
  0310BB  15CB: 684001           push 0x140
  0310BE  15CE: 68b300           push 0xb3
  0310C1  15D1: 6a00             push 0
  0310C3  15D3: 0e               push cs
  0310C4  15D4: e80558           call 0x6ddc
  0310C7  15D7: 83c408           add sp, 8
  0310CA  15DA: c746980100       mov word ptr [bp - 0x68], 1
  0310CF  15DF: c74696b500       mov word ptr [bp - 0x6a], 0xb5
  0310D4  15E4: c7468e0000       mov word ptr [bp - 0x72], 0
  0310D9  15E9: ff364008         push word ptr [0x840]
  0310DD  15ED: ff363e08         push word ptr [0x83e]
  0310E1  15F1: ff7696           push word ptr [bp - 0x6a]
  0310E4  15F4: 8b468e           mov ax, word ptr [bp - 0x72]
  0310E7  15F7: 8bf0             mov si, ax
  0310E9  15F9: 8bc8             mov cx, ax
  0310EB  15FB: d1e6             shl si, 1
  0310ED  15FD: 03f1             add si, cx
  0310EF  15FF: c1e602           shl si, 2
  0310F2  1602: 051700           add ax, 0x17
  0310F5  1605: 8b5698           mov dx, word ptr [bp - 0x68]
  0310F8  1608: c41e3e08         les bx, ptr [0x83e]
  0310FC  160C: 268b885201       mov cx, word ptr es:[bx + si + 0x152]
  031101  1611: d1f9             sar cx, 1
  031103  1613: 2bd1             sub dx, cx
  031105  1615: 83c209           add dx, 9
  031108  1618: 89568c           mov word ptr [bp - 0x74], dx
  03110B  161B: 8d1ea82d         lea bx, [0x2da8]
  03110F  161F: 9a54021f18       lcall 0x181f, 0x254
  031114  1624: c646ae00         mov byte ptr [bp - 0x52], 0
  031118  1628: 6a0a             push 0xa
  03111A  162A: 8d469a           lea ax, [bp - 0x66]
  03111D  162D: 50               push ax
  03111E  162E: ff768e           push word ptr [bp - 0x72]
  031121  1631: 0e               push cs
  031122  1632: e8ee56           call 0x6d23
  031125  1635: 83c402           add sp, 2
  031128  1638: 50               push ax
  031129  1639: 9afa081d0d       lcall 0xd1d, 0x8fa
  03112E  163E: 83c406           add sp, 6
  031131  1641: 8d469a           lea ax, [bp - 0x66]
  031134  1644: 50               push ax
  031135  1645: 8d4eae           lea cx, [bp - 0x52]
  031138  1648: 51               push cx
  031139  1649: 9aa4071d0d       lcall 0xd1d, 0x7a4
  03113E  164E: 83c404           add sp, 4
  031141  1651: 68c10f           push 0xfc1
  031144  1654: 8d46ae           lea ax, [bp - 0x52]
  031147  1657: 50               push ax
  031148  1658: 9aa4071d0d       lcall 0xd1d, 0x7a4
  03114D  165D: 83c404           add sp, 4
  031150  1660: 6a0a             push 0xa
  031152  1662: 8d469a           lea ax, [bp - 0x66]
  031155  1665: 50               push ax
  031156  1666: ff768e           push word ptr [bp - 0x72]
  031159  1669: 0e               push cs
  03115A  166A: e83357           call 0x6da0
  03115D  166D: 83c402           add sp, 2
  031160  1670: 50               push ax
  031161  1671: 9afa081d0d       lcall 0xd1d, 0x8fa
  031166  1676: 83c406           add sp, 6
  031169  1679: 8d469a           lea ax, [bp - 0x66]
  03116C  167C: 50               push ax
  03116D  167D: 8d46ae           lea ax, [bp - 0x52]
  031170  1680: 50               push ax
  031171  1681: 9aa4071d0d       lcall 0xd1d, 0x7a4
  031176  1686: 83c404           add sp, 4
  031179  1689: ff36a008         push word ptr [0x8a0]
  03117D  168D: ff369e08         push word ptr [0x89e]
  031181  1691: 8d46ae           lea ax, [bp - 0x52]
  031184  1694: 16               push ss
  031185  1695: 50               push ax
  031186  1696: 2bc0             sub ax, ax
  031188  1698: 9a04021f18       lcall 0x181f, 0x204
  03118D  169D: 40               inc ax
  03118E  169E: 8946fe           mov word ptr [bp - 2], ax
  031191  16A1: d1f8             sar ax, 1
  031193  16A3: 2b4698           sub ax, word ptr [bp - 0x68]
  031196  16A6: f7d8             neg ax
  031198  16A8: 050800           add ax, 8
  03119B  16AB: 894692           mov word ptr [bp - 0x6e], ax
  03119E  16AE: 6a2f             push 0x2f
  0311A0  16B0: b9c200           mov cx, 0xc2
  0311A3  16B3: 894e90           mov word ptr [bp - 0x70], cx
  0311A6  16B6: 51               push cx
  0311A7  16B7: 40               inc ax
  0311A8  16B8: 50               push ax
  0311A9  16B9: 8d46ae           lea ax, [bp - 0x52]
  0311AC  16BC: 16               push ss
  0311AD  16BD: 50               push ax
  0311AE  16BE: 9a3c011f18       lcall 0x181f, 0x13c
  0311B3  16C3: 83c40a           add sp, 0xa
  0311B6  16C6: ff768e           push word ptr [bp - 0x72]
  0311B9  16C9: 0e               push cs
  0311BA  16CA: e80a57           call 0x6dd7
  0311BD  16CD: 83c402           add sp, 2
  0311C0  16D0: 0bc0             or ax, ax
  0311C2  16D2: 7421             je 0x16f5
  0311C4  16D4: ff364008         push word ptr [0x840]
  0311C8  16D8: ff363e08         push word ptr [0x83e]
  0311CC  16DC: 8b4696           mov ax, word ptr [bp - 0x6a]
  0311CF  16DF: 050300           add ax, 3
  0311D2  16E2: 50               push ax
  0311D3  16E3: 8b5698           mov dx, word ptr [bp - 0x68]
  0311D6  16E6: 83c205           add dx, 5
  0311D9  16E9: b83800           mov ax, 0x38
  0311DC  16EC: 8d1ea82d         lea bx, [0x2da8]
  0311E0  16F0: 9a54021f18       lcall 0x181f, 0x254
  0311E5  16F5: a09e0f           mov al, byte ptr [0xf9e]
  0311E8  16F8: 2ae4             sub ah, ah
  0311EA  16FA: 3b468e           cmp ax, word ptr [bp - 0x72]
  0311ED  16FD: 755d             jne 0x175c
  0311EF  16FF: c646940a         mov byte ptr [bp - 0x6c], 0xa
  0311F3  1703: 833eee0700       cmp word ptr [0x7ee], 0
  0311F8  1708: 740b             je 0x1715
  0311FA  170A: 833e3a9e00       cmp word ptr [0x9e3a], 0
  0311FF  170F: 7504             jne 0x1715
  031201  1711: c646940e         mov byte ptr [bp - 0x6c], 0xe
  031205  1715: 833e9a0f00       cmp word ptr [0xf9a], 0
  03120A  171A: 7512             jne 0x172e
  03120C  171C: 833e409e00       cmp word ptr [0x9e40], 0
  031211  1721: 740b             je 0x172e
  031213  1723: 803ea70f00       cmp byte ptr [0xfa7], 0
  031218  1728: 7504             jne 0x172e
  03121A  172A: c646940e         mov byte ptr [bp - 0x6c], 0xe
  03121E  172E: ff36ae2d         push word ptr [0x2dae]
  031222  1732: ff36ac2d         push word ptr [0x2dac]
  031226  1736: ff36aa2d         push word ptr [0x2daa]
  03122A  173A: ff36a82d         push word ptr [0x2da8]
  03122E  173E: 8b4696           mov ax, word ptr [bp - 0x6a]
  031231  1741: 051200           add ax, 0x12
  031234  1744: 50               push ax
  031235  1745: 8a4694           mov al, byte ptr [bp - 0x6c]
  031238  1748: 50               push ax
  031239  1749: 8b4698           mov ax, word ptr [bp - 0x68]
  03123C  174C: 8bd8             mov bx, ax
  03123E  174E: 83c312           add bx, 0x12
  031241  1751: 48               dec ax
  031242  1752: 8b5696           mov dx, word ptr [bp - 0x6a]
  031245  1755: 4a               dec dx
  031246  1756: 4a               dec dx
  031247  1757: 9ace001f18       lcall 0x181f, 0xce
  03124C  175C: 83469813         add word ptr [bp - 0x68], 0x13
  031250  1760: ff468e           inc word ptr [bp - 0x72]
  031253  1763: 837e8e10         cmp word ptr [bp - 0x72], 0x10
  031257  1767: 7d03             jge 0x176c
  031259  1769: e97dfe           jmp 0x15e9
  03125C  176C: 6a0f             push 0xf
  03125E  176E: 68b300           push 0xb3
  031261  1771: 683201           push 0x132
  031264  1774: ff365e2f         push word ptr [0x2f5e]
  031268  1778: 9a22001f18       lcall 0x181f, 0x22
  03126D  177D: 83c402           add sp, 2
  031270  1780: 52               push dx
  031271  1781: 50               push ax
  031272  1782: 9a3c011f18       lcall 0x181f, 0x13c
  031277  1787: 83c40a           add sp, 0xa
  03127A  178A: 837e0400         cmp word ptr [bp + 4], 0
  03127E  178E: 7414             je 0x17a4
  031280  1790: 68b300           push 0xb3
  031283  1793: 684001           push 0x140
  031286  1796: 6a15             push 0x15
  031288  1798: 2bc0             sub ax, ax
  03128A  179A: bab300           mov dx, 0xb3
  03128D  179D: 2bdb             sub bx, bx
  03128F  179F: 9ae2001f18       lcall 0x181f, 0xe2
  031294  17A4: 5e               pop si
  031295  17A5: c9               leave 
  031296  17A6: c3               ret 

; ---- func_031298  size=206  insns=84  prologue=ENTER 0x0008,0  terminal=RETF ----
  031298  17A8: c8080000         enter 8, 0
  03129C  17AC: 8b4606           mov ax, word ptr [bp + 6]
  03129F  17AF: 8946fe           mov word ptr [bp - 2], ax
  0312A2  17B2: 2bc9             sub cx, cx
  0312A4  17B4: 894ef8           mov word ptr [bp - 8], cx
  0312A7  17B7: 8b5e0e           mov bx, word ptr [bp + 0xe]
  0312AA  17BA: 890f             mov word ptr [bx], cx
  0312AC  17BC: 3d0400           cmp ax, 4
  0312AF  17BF: 7d05             jge 0x17c6
  0312B1  17C1: 8946f8           mov word ptr [bp - 8], ax
  0312B4  17C4: eb2a             jmp 0x17f0
  0312B6  17C6: 8b5e0e           mov bx, word ptr [bp + 0xe]
  0312B9  17C9: ff07             inc word ptr [bx]
  0312BB  17CB: 836efe04         sub word ptr [bp - 2], 4
  0312BF  17CF: 837efe08         cmp word ptr [bp - 2], 8
  0312C3  17D3: 7d05             jge 0x17da
  0312C5  17D5: 8b46fe           mov ax, word ptr [bp - 2]
  0312C8  17D8: ebe7             jmp 0x17c1
  0312CA  17DA: 8b5e0e           mov bx, word ptr [bp + 0xe]
  0312CD  17DD: ff07             inc word ptr [bx]
  0312CF  17DF: 8b460a           mov ax, word ptr [bp + 0xa]
  0312D2  17E2: 836efe08         sub word ptr [bp - 2], 8
  0312D6  17E6: 3946fe           cmp word ptr [bp - 2], ax
  0312D9  17E9: 7cea             jl 0x17d5
  0312DB  17EB: 8b5e0e           mov bx, word ptr [bp + 0xe]
  0312DE  17EE: ff07             inc word ptr [bx]
  0312E0  17F0: 8b5e0e           mov bx, word ptr [bp + 0xe]
  0312E3  17F3: 8a0f             mov cl, byte ptr [bx]
  0312E5  17F5: b81000           mov ax, 0x10
  0312E8  17F8: d3f8             sar ax, cl
  0312EA  17FA: 8946fa           mov word ptr [bp - 6], ax
  0312ED  17FD: 8946fc           mov word ptr [bp - 4], ax
  0312F0  1800: 833f00           cmp word ptr [bx], 0
  0312F3  1803: 7506             jne 0x180b
  0312F5  1805: 03460c           add ax, word ptr [bp + 0xc]
  0312F8  1808: 8946fc           mov word ptr [bp - 4], ax
  0312FB  180B: 833f02           cmp word ptr [bx], 2
  0312FE  180E: 7503             jne 0x1813
  031300  1810: ff46fc           inc word ptr [bp - 4]
  031303  1813: 8b46fa           mov ax, word ptr [bp - 6]
  031306  1816: 8b5e16           mov bx, word ptr [bp + 0x16]
  031309  1819: 8907             mov word ptr [bx], ax
  03130B  181B: 8b5e14           mov bx, word ptr [bp + 0x14]
  03130E  181E: 8907             mov word ptr [bx], ax
  031310  1820: 8b46f8           mov ax, word ptr [bp - 8]
  031313  1823: f76efc           imul word ptr [bp - 4]
  031316  1826: 034608           add ax, word ptr [bp + 8]
  031319  1829: 8b5e10           mov bx, word ptr [bp + 0x10]
  03131C  182C: 8907             mov word ptr [bx], ax
  03131E  182E: 8b5e0e           mov bx, word ptr [bp + 0xe]
  031321  1831: 8b07             mov ax, word ptr [bx]
  031323  1833: eb35             jmp 0x186a
  031325  1835: 90               nop 
  031326  1836: 8b5e12           mov bx, word ptr [bp + 0x12]
  031329  1839: c7079200         mov word ptr [bx], 0x92
  03132D  183D: c9               leave 
  03132E  183E: cb               retf 
  03132F  183F: 90               nop 
  031330  1840: 8b5e10           mov bx, word ptr [bp + 0x10]
  031333  1843: 830702           add word ptr [bx], 2
  031336  1846: 8b5e14           mov bx, word ptr [bp + 0x14]
  031339  1849: 832f02           sub word ptr [bx], 2
  03133C  184C: 8b5e12           mov bx, word ptr [bp + 0x12]
  03133F  184F: c7078900         mov word ptr [bx], 0x89
  031343  1853: c9               leave 
  031344  1854: cb               retf 
  031345  1855: 90               nop 
  031346  1856: 8b5e10           mov bx, word ptr [bp + 0x10]
  031349  1859: ff07             inc word ptr [bx]
  03134B  185B: 8b5e14           mov bx, word ptr [bp + 0x14]
  03134E  185E: ff0f             dec word ptr [bx]
  031350  1860: 8b5e12           mov bx, word ptr [bp + 0x12]
  031353  1863: c7078400         mov word ptr [bx], 0x84
  031357  1867: c9               leave 
  031358  1868: cb               retf 
  031359  1869: 90               nop 
  03135A  186A: 0bc0             or ax, ax
  03135C  186C: 74c8             je 0x1836
  03135E  186E: 48               dec ax
  03135F  186F: 74cf             je 0x1840
  031361  1871: 48               dec ax
  031362  1872: 74e2             je 0x1856
  031364  1874: c9               leave 
  031365  1875: cb               retf 

; ---- func_031366  size=327  insns=120  prologue=ENTER 0x000A,0  terminal=RETF ----
  031366  1876: c80a0000         enter 0xa, 0
  03136A  187A: 8d46f6           lea ax, [bp - 0xa]
  03136D  187D: 50               push ax
  03136E  187E: 8d46f8           lea ax, [bp - 8]
  031371  1881: 50               push ax
  031372  1882: 8d46fa           lea ax, [bp - 6]
  031375  1885: 50               push ax
  031376  1886: 8d4efe           lea cx, [bp - 2]
  031379  1889: 51               push cx
  03137A  188A: 8d56fc           lea dx, [bp - 4]
  03137D  188D: 52               push dx
  03137E  188E: ff760c           push word ptr [bp + 0xc]
  031381  1891: ff760a           push word ptr [bp + 0xa]
  031384  1894: ff7608           push word ptr [bp + 8]
  031387  1897: 8b5e0e           mov bx, word ptr [bp + 0xe]
  03138A  189A: ff37             push word ptr [bx]
  03138C  189C: 0e               push cs
  03138D  189D: e80f55           call 0x6daf
  031390  18A0: 83c412           add sp, 0x12
  031393  18A3: 837efc02         cmp word ptr [bp - 4], 2
  031397  18A7: 7c03             jl 0x18ac
  031399  18A9: e98400           jmp 0x1930
  03139C  18AC: ff76fa           push word ptr [bp - 6]
  03139F  18AF: 6a10             push 0x10
  0313A1  18B1: 8a4efc           mov cl, byte ptr [bp - 4]
  0313A4  18B4: b86400           mov ax, 0x64
  0313A7  18B7: d3f8             sar ax, cl
  0313A9  18B9: 50               push ax
  0313AA  18BA: 837efc01         cmp word ptr [bp - 4], 1
  0313AE  18BE: 7506             jne 0x18c6
  0313B0  18C0: b80400           mov ax, 4
  0313B3  18C3: eb03             jmp 0x18c8
  0313B5  18C5: 90               nop 
  0313B6  18C6: 2bc0             sub ax, ax
  0313B8  18C8: 8b5efe           mov bx, word ptr [bp - 2]
  0313BB  18CB: 2bd8             sub bx, ax
  0313BD  18CD: 8b4606           mov ax, word ptr [bp + 6]
  0313C0  18D0: 2bd2             sub dx, dx
  0313C2  18D2: 9abc021f18       lcall 0x181f, 0x2bc
  0313C7  18D7: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0313CB  18DB: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  0313D0  18E0: 7303             jae 0x18e5
  0313D2  18E2: e99800           jmp 0x197d
  0313D5  18E5: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  0313DA  18EA: 7603             jbe 0x18ef
  0313DC  18EC: e98e00           jmp 0x197d
  0313DF  18EF: 837efc00         cmp word ptr [bp - 4], 0
  0313E3  18F3: 7403             je 0x18f8
  0313E5  18F5: e98500           jmp 0x197d
  0313E8  18F8: 837e0c02         cmp word ptr [bp + 0xc], 2
  0313EC  18FC: 7d7f             jge 0x197d
  0313EE  18FE: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  0313F3  1903: 7478             je 0x197d
  0313F5  1905: ff364008         push word ptr [0x840]
  0313F9  1909: ff363e08         push word ptr [0x83e]
  0313FD  190D: ff76fa           push word ptr [bp - 6]
  031400  1910: 6a00             push 0
  031402  1912: ff7606           push word ptr [bp + 6]
  031405  1915: 9ae60b1f18       lcall 0x181f, 0xbe6
  03140A  191A: 83c404           add sp, 4
  03140D  191D: 051700           add ax, 0x17
  031410  1920: 8d1ea82d         lea bx, [0x2da8]
  031414  1924: 8b56fe           mov dx, word ptr [bp - 2]
  031417  1927: 9a54021f18       lcall 0x181f, 0x254
  03141C  192C: eb4f             jmp 0x197d
  03141E  192E: 90               nop 
  03141F  192F: 90               nop 
  031420  1930: 837efc03         cmp word ptr [bp - 4], 3
  031424  1934: 7d47             jge 0x197d
  031426  1936: ff364008         push word ptr [0x840]
  03142A  193A: ff363e08         push word ptr [0x83e]
  03142E  193E: 8b46f6           mov ax, word ptr [bp - 0xa]
  031431  1941: 0346fa           add ax, word ptr [bp - 6]
  031434  1944: 48               dec ax
  031435  1945: 50               push ax
  031436  1946: 8a4efc           mov cl, byte ptr [bp - 4]
  031439  1949: b86400           mov ax, 0x64
  03143C  194C: d3f8             sar ax, cl
  03143E  194E: 50               push ax
  03143F  194F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  031443  1953: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  031447  1957: 2aff             sub bh, bh
  031449  1959: 8bc3             mov ax, bx
  03144B  195B: d1e3             shl bx, 1
  03144D  195D: 03d8             add bx, ax
  03144F  195F: d1e3             shl bx, 1
  031451  1961: 03d8             add bx, ax
  031453  1963: d1e3             shl bx, 1
  031455  1965: 8a873252         mov al, byte ptr [bx + 0x5232]
  031459  1969: 2ae4             sub ah, ah
  03145B  196B: 8b56f8           mov dx, word ptr [bp - 8]
  03145E  196E: d1fa             sar dx, 1
  031460  1970: 0356fe           add dx, word ptr [bp - 2]
  031463  1973: 4a               dec dx
  031464  1974: 8d1ea82d         lea bx, [0x2da8]
  031468  1978: 9af8021f18       lcall 0x181f, 0x2f8
  03146D  197D: 837e1000         cmp word ptr [bp + 0x10], 0
  031471  1981: 7c33             jl 0x19b6
  031473  1983: 837efc03         cmp word ptr [bp - 4], 3
  031477  1987: 7d2d             jge 0x19b6
  031479  1989: ff36ae2d         push word ptr [0x2dae]
  03147D  198D: ff36ac2d         push word ptr [0x2dac]
  031481  1991: ff36aa2d         push word ptr [0x2daa]
  031485  1995: ff36a82d         push word ptr [0x2da8]
  031489  1999: 8b46f6           mov ax, word ptr [bp - 0xa]
  03148C  199C: 0346fa           add ax, word ptr [bp - 6]
  03148F  199F: 50               push ax
  031490  19A0: 8a4610           mov al, byte ptr [bp + 0x10]
  031493  19A3: 50               push ax
  031494  19A4: 8b46fe           mov ax, word ptr [bp - 2]
  031497  19A7: 8b5ef8           mov bx, word ptr [bp - 8]
  03149A  19AA: 03d8             add bx, ax
  03149C  19AC: 48               dec ax
  03149D  19AD: 8b56fa           mov dx, word ptr [bp - 6]
  0314A0  19B0: 4a               dec dx
  0314A1  19B1: 9ace001f18       lcall 0x181f, 0xce
  0314A6  19B6: 8b5e0e           mov bx, word ptr [bp + 0xe]
  0314A9  19B9: ff07             inc word ptr [bx]
  0314AB  19BB: c9               leave 
  0314AC  19BC: cb               retf 

; ---- func_0314AE  size=46  insns=18  prologue=push bp;mov bp,sp  terminal=RETF ----
  0314AE  19BE: 55               push bp
  0314AF  19BF: 8bec             mov bp, sp
  0314B1  19C1: 8b4606           mov ax, word ptr [bp + 6]
  0314B4  19C4: 8bc8             mov cx, ax
  0314B6  19C6: d1e0             shl ax, 1
  0314B8  19C8: 03c1             add ax, cx
  0314BA  19CA: c1e002           shl ax, 2
  0314BD  19CD: 059300           add ax, 0x93
  0314C0  19D0: 8b5e08           mov bx, word ptr [bp + 8]
  0314C3  19D3: 8907             mov word ptr [bx], ax
  0314C5  19D5: 8b5e0a           mov bx, word ptr [bp + 0xa]
  0314C8  19D8: c707a500         mov word ptr [bx], 0xa5
  0314CC  19DC: 8b5e0c           mov bx, word ptr [bp + 0xc]
  0314CF  19DF: c7070a00         mov word ptr [bx], 0xa
  0314D3  19E3: 8b5e0e           mov bx, word ptr [bp + 0xe]
  0314D6  19E6: c7070c00         mov word ptr [bx], 0xc
  0314DA  19EA: c9               leave 
  0314DB  19EB: cb               retf 

; ---- func_0314DC  size=752  insns=271  prologue=ENTER 0x0068,0  terminal=RET ----
  0314DC  19EC: c8680000         enter 0x68, 0
  0314E0  19F0: 56               push si
  0314E1  19F1: 6a3c             push 0x3c
  0314E3  19F3: 6a51             push 0x51
  0314E5  19F5: 6a76             push 0x76
  0314E7  19F7: 688f00           push 0x8f
  0314EA  19FA: 0e               push cs
  0314EB  19FB: e8de53           call 0x6ddc
  0314EE  19FE: 83c408           add sp, 8
  0314F1  1A01: 833ea20f00       cmp word ptr [0xfa2], 0
  0314F6  1A06: 7568             jne 0x1a70
  0314F8  1A08: 6a45             push 0x45
  0314FA  1A0A: 6a78             push 0x78
  0314FC  1A0C: 6a51             push 0x51
  0314FE  1A0E: 688f00           push 0x8f
  031501  1A11: ff36d02d         push word ptr [0x2dd0]
  031505  1A15: 9a22001f18       lcall 0x181f, 0x22
  03150A  1A1A: 83c402           add sp, 2
  03150D  1A1D: 52               push dx
  03150E  1A1E: 50               push ax
  03150F  1A1F: 9a00011f18       lcall 0x181f, 0x100
  031514  1A24: 83c40c           add sp, 0xc
  031517  1A27: c746a40000       mov word ptr [bp - 0x5c], 0
  03151C  1A2C: eb03             jmp 0x1a31
  03151E  1A2E: ff46a4           inc word ptr [bp - 0x5c]
  031521  1A31: 837ea406         cmp word ptr [bp - 0x5c], 6
  031525  1A35: 7c03             jl 0x1a3a
  031527  1A37: e98602           jmp 0x1cc0
  03152A  1A3A: 8d469e           lea ax, [bp - 0x62]
  03152D  1A3D: 50               push ax
  03152E  1A3E: 8d46a0           lea ax, [bp - 0x60]
  031531  1A41: 50               push ax
  031532  1A42: 8d46a8           lea ax, [bp - 0x58]
  031535  1A45: 50               push ax
  031536  1A46: 8d4eaa           lea cx, [bp - 0x56]
  031539  1A49: 51               push cx
  03153A  1A4A: ff76a4           push word ptr [bp - 0x5c]
  03153D  1A4D: 0e               push cs
  03153E  1A4E: e80453           call 0x6d55
  031541  1A51: 83c40a           add sp, 0xa
  031544  1A54: ff364008         push word ptr [0x840]
  031548  1A58: ff363e08         push word ptr [0x83e]
  03154C  1A5C: ff76a8           push word ptr [bp - 0x58]
  03154F  1A5F: b87b00           mov ax, 0x7b
  031552  1A62: 8d1ea82d         lea bx, [0x2da8]
  031556  1A66: 8b56aa           mov dx, word ptr [bp - 0x56]
  031559  1A69: 9a54021f18       lcall 0x181f, 0x254
  03155E  1A6E: ebbe             jmp 0x1a2e
  031560  1A70: ff361c9e         push word ptr [0x9e1c]
  031564  1A74: 0e               push cs
  031565  1A75: e89b53           call 0x6e13
  031568  1A78: 83c402           add sp, 2
  03156B  1A7B: 89469a           mov word ptr [bp - 0x66], ax
  03156E  1A7E: c646ae00         mov byte ptr [bp - 0x52], 0
  031572  1A82: ff36e82d         push word ptr [0x2de8]
  031576  1A86: 8d46ae           lea ax, [bp - 0x52]
  031579  1A89: 50               push ax
  03157A  1A8A: 9a6e011f18       lcall 0x181f, 0x16e
  03157F  1A8F: 83c404           add sp, 4
  031582  1A92: 8d46ae           lea ax, [bp - 0x52]
  031585  1A95: 50               push ax
  031586  1A96: 9abe011f18       lcall 0x181f, 0x1be
  03158B  1A9B: 83c402           add sp, 2
  03158E  1A9E: 6b5e9a1c         imul bx, word ptr [bp - 0x66], 0x1c
  031592  1AA2: 80bf46310e       cmp byte ptr [bx + 0x3146], 0xe
  031597  1AA7: 7430             je 0x1ad9
  031599  1AA9: 8d46ae           lea ax, [bp - 0x52]
  03159C  1AAC: 50               push ax
  03159D  1AAD: 8bf3             mov si, bx
  03159F  1AAF: 9a78011f18       lcall 0x181f, 0x178
  0315A4  1AB4: 83c402           add sp, 2
  0315A7  1AB7: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  0315AB  1ABB: 2aff             sub bh, bh
  0315AD  1ABD: 8bc3             mov ax, bx
  0315AF  1ABF: d1e3             shl bx, 1
  0315B1  1AC1: 03d8             add bx, ax
  0315B3  1AC3: d1e3             shl bx, 1
  0315B5  1AC5: 03d8             add bx, ax
  0315B7  1AC7: d1e3             shl bx, 1
  0315B9  1AC9: ffb73052         push word ptr [bx + 0x5230]
  0315BD  1ACD: 8d46ae           lea ax, [bp - 0x52]
  0315C0  1AD0: 50               push ax
  0315C1  1AD1: 9a6e011f18       lcall 0x181f, 0x16e
  0315C6  1AD6: 83c404           add sp, 4
  0315C9  1AD9: 6a45             push 0x45
  0315CB  1ADB: 6a78             push 0x78
  0315CD  1ADD: 6a51             push 0x51
  0315CF  1ADF: 688f00           push 0x8f
  0315D2  1AE2: 8d46ae           lea ax, [bp - 0x52]
  0315D5  1AE5: 16               push ss
  0315D6  1AE6: 50               push ax
  0315D7  1AE7: 9a00011f18       lcall 0x181f, 0x100
  0315DC  1AEC: 83c40c           add sp, 0xc
  0315DF  1AEF: 6b5e9a1c         imul bx, word ptr [bp - 0x66], 0x1c
  0315E3  1AF3: 80bf46310e       cmp byte ptr [bx + 0x3146], 0xe
  0315E8  1AF8: 7547             jne 0x1b41
  0315EA  1AFA: c646ae00         mov byte ptr [bp - 0x52], 0
  0315EE  1AFE: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0315F2  1B02: 2aff             sub bh, bh
  0315F4  1B04: 8bc3             mov ax, bx
  0315F6  1B06: d1e3             shl bx, 1
  0315F8  1B08: 03d8             add bx, ax
  0315FA  1B0A: d1e3             shl bx, 1
  0315FC  1B0C: 03d8             add bx, ax
  0315FE  1B0E: d1e3             shl bx, 1
  031600  1B10: ffb73052         push word ptr [bx + 0x5230]
  031604  1B14: 8d46ae           lea ax, [bp - 0x52]
  031607  1B17: 50               push ax
  031608  1B18: 9a6e011f18       lcall 0x181f, 0x16e
  03160D  1B1D: 83c404           add sp, 4
  031610  1B20: 6a45             push 0x45
  031612  1B22: c41e9e08         les bx, ptr [0x89e]
  031616  1B26: 268a07           mov al, byte ptr es:[bx]
  031619  1B29: 2ae4             sub ah, ah
  03161B  1B2B: 057900           add ax, 0x79
  03161E  1B2E: 50               push ax
  03161F  1B2F: 6a51             push 0x51
  031621  1B31: 688f00           push 0x8f
  031624  1B34: 8d46ae           lea ax, [bp - 0x52]
  031627  1B37: 16               push ss
  031628  1B38: 50               push ax
  031629  1B39: 9a00011f18       lcall 0x181f, 0x100
  03162E  1B3E: 83c40c           add sp, 0xc
  031631  1B41: c746aa9200       mov word ptr [bp - 0x56], 0x92
  031636  1B46: 2bc0             sub ax, ax
  031638  1B48: 8946fe           mov word ptr [bp - 2], ax
  03163B  1B4B: 8946a4           mov word ptr [bp - 0x5c], ax
  03163E  1B4E: e98000           jmp 0x1bd1
  031641  1B51: 90               nop 
  031642  1B52: ff76a4           push word ptr [bp - 0x5c]
  031645  1B55: 0e               push cs
  031646  1B56: e8ba52           call 0x6e13
  031649  1B59: 83c402           add sp, 2
  03164C  1B5C: 89469a           mov word ptr [bp - 0x66], ax
  03164F  1B5F: c74698ffff       mov word ptr [bp - 0x68], 0xffff
  031654  1B64: a11c9e           mov ax, word ptr [0x9e1c]
  031657  1B67: 3946a4           cmp word ptr [bp - 0x5c], ax
  03165A  1B6A: 7408             je 0x1b74
  03165C  1B6C: a1209e           mov ax, word ptr [0x9e20]
  03165F  1B6F: 3946a4           cmp word ptr [bp - 0x5c], ax
  031662  1B72: 7542             jne 0x1bb6
  031664  1B74: a11c9e           mov ax, word ptr [0x9e1c]
  031667  1B77: 3946a4           cmp word ptr [bp - 0x5c], ax
  03166A  1B7A: 7505             jne 0x1b81
  03166C  1B7C: c746980a00       mov word ptr [bp - 0x68], 0xa
  031671  1B81: 833eee0700       cmp word ptr [0x7ee], 0
  031676  1B86: 7413             je 0x1b9b
  031678  1B88: 833e3a9e01       cmp word ptr [0x9e3a], 1
  03167D  1B8D: 750c             jne 0x1b9b
  03167F  1B8F: 833e289e00       cmp word ptr [0x9e28], 0
  031684  1B94: 7505             jne 0x1b9b
  031686  1B96: c746980f00       mov word ptr [bp - 0x68], 0xf
  03168B  1B9B: 833e9a0f01       cmp word ptr [0xf9a], 1
  031690  1BA0: 7514             jne 0x1bb6
  031692  1BA2: 833e409e00       cmp word ptr [0x9e40], 0
  031697  1BA7: 740d             je 0x1bb6
  031699  1BA9: a1209e           mov ax, word ptr [0x9e20]
  03169C  1BAC: 3946a4           cmp word ptr [bp - 0x5c], ax
  03169F  1BAF: 7505             jne 0x1bb6
  0316A1  1BB1: c746980f00       mov word ptr [bp - 0x68], 0xf
  0316A6  1BB6: ff7698           push word ptr [bp - 0x68]
  0316A9  1BB9: 8d46fe           lea ax, [bp - 2]
  0316AC  1BBC: 50               push ax
  0316AD  1BBD: 6a02             push 2
  0316AF  1BBF: 6a05             push 5
  0316B1  1BC1: ff76aa           push word ptr [bp - 0x56]
  0316B4  1BC4: ff769a           push word ptr [bp - 0x66]
  0316B7  1BC7: 0e               push cs
  0316B8  1BC8: e87052           call 0x6e3b
  0316BB  1BCB: 83c40c           add sp, 0xc
  0316BE  1BCE: ff46a4           inc word ptr [bp - 0x5c]
  0316C1  1BD1: a1a20f           mov ax, word ptr [0xfa2]
  0316C4  1BD4: 3946a4           cmp word ptr [bp - 0x5c], ax
  0316C7  1BD7: 7d03             jge 0x1bdc
  0316C9  1BD9: e976ff           jmp 0x1b52
  0316CC  1BDC: ff361c9e         push word ptr [0x9e1c]
  0316D0  1BE0: 0e               push cs
  0316D1  1BE1: e82f52           call 0x6e13
  0316D4  1BE4: 83c402           add sp, 2
  0316D7  1BE7: 89469a           mov word ptr [bp - 0x66], ax
  0316DA  1BEA: c746a40000       mov word ptr [bp - 0x5c], 0
  0316DF  1BEF: eb58             jmp 0x1c49
  0316E1  1BF1: 90               nop 
  0316E2  1BF2: be2700           mov si, 0x27
  0316E5  1BF5: 8976a2           mov word ptr [bp - 0x5e], si
  0316E8  1BF8: 03769c           add si, word ptr [bp - 0x64]
  0316EB  1BFB: 8bce             mov cx, si
  0316ED  1BFD: 8bc1             mov ax, cx
  0316EF  1BFF: d1e6             shl si, 1
  0316F1  1C01: 03f0             add si, ax
  0316F3  1C03: c1e602           shl si, 2
  0316F6  1C06: c41e3e08         les bx, ptr [0x83e]
  0316FA  1C0A: 268b403e         mov ax, word ptr es:[bx + si + 0x3e]
  0316FE  1C0E: 8946a6           mov word ptr [bp - 0x5a], ax
  031701  1C11: 06               push es
  031702  1C12: 53               push bx
  031703  1C13: ff76a8           push word ptr [bp - 0x58]
  031706  1C16: d1f8             sar ax, 1
  031708  1C18: 8b56a0           mov dx, word ptr [bp - 0x60]
  03170B  1C1B: 4a               dec dx
  03170C  1C1C: d1fa             sar dx, 1
  03170E  1C1E: 2bd0             sub dx, ax
  031710  1C20: 0356aa           add dx, word ptr [bp - 0x56]
  031713  1C23: 42               inc dx
  031714  1C24: 8bc1             mov ax, cx
  031716  1C26: 8d1ea82d         lea bx, [0x2da8]
  03171A  1C2A: eb15             jmp 0x1c41
  03171C  1C2C: ff364008         push word ptr [0x840]
  031720  1C30: ff363e08         push word ptr [0x83e]
  031724  1C34: ff76a8           push word ptr [bp - 0x58]
  031727  1C37: b87b00           mov ax, 0x7b
  03172A  1C3A: 8d1ea82d         lea bx, [0x2da8]
  03172E  1C3E: 8b56aa           mov dx, word ptr [bp - 0x56]
  031731  1C41: 9a54021f18       lcall 0x181f, 0x254
  031736  1C46: ff46a4           inc word ptr [bp - 0x5c]
  031739  1C49: 837ea406         cmp word ptr [bp - 0x5c], 6
  03173D  1C4D: 7d71             jge 0x1cc0
  03173F  1C4F: 8d469e           lea ax, [bp - 0x62]
  031742  1C52: 50               push ax
  031743  1C53: 8d46a0           lea ax, [bp - 0x60]
  031746  1C56: 50               push ax
  031747  1C57: 8d4ea8           lea cx, [bp - 0x58]
  03174A  1C5A: 51               push cx
  03174B  1C5B: 8d56aa           lea dx, [bp - 0x56]
  03174E  1C5E: 52               push dx
  03174F  1C5F: ff76a4           push word ptr [bp - 0x5c]
  031752  1C62: 0e               push cs
  031753  1C63: e8ef50           call 0x6d55
  031756  1C66: 83c40a           add sp, 0xa
  031759  1C69: 6b5e9a1c         imul bx, word ptr [bp - 0x66], 0x1c
  03175D  1C6D: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  031761  1C71: 2aff             sub bh, bh
  031763  1C73: 8bc3             mov ax, bx
  031765  1C75: d1e3             shl bx, 1
  031767  1C77: 03d8             add bx, ax
  031769  1C79: d1e3             shl bx, 1
  03176B  1C7B: 03d8             add bx, ax
  03176D  1C7D: d1e3             shl bx, 1
  03176F  1C7F: 8a873752         mov al, byte ptr [bx + 0x5237]
  031773  1C83: 2ae4             sub ah, ah
  031775  1C85: 3b46a4           cmp ax, word ptr [bp - 0x5c]
  031778  1C88: 7ea2             jle 0x1c2c
  03177A  1C8A: ff76a4           push word ptr [bp - 0x5c]
  03177D  1C8D: ff769a           push word ptr [bp - 0x66]
  031780  1C90: 9ae60b1f18       lcall 0x181f, 0xbe6
  031785  1C95: 83c404           add sp, 4
  031788  1C98: 89469c           mov word ptr [bp - 0x64], ax
  03178B  1C9B: ff76a4           push word ptr [bp - 0x5c]
  03178E  1C9E: ff769a           push word ptr [bp - 0x66]
  031791  1CA1: 9a680c1f18       lcall 0x181f, 0xc68
  031796  1CA6: 83c404           add sp, 4
  031799  1CA9: 8946ac           mov word ptr [bp - 0x54], ax
  03179C  1CAC: 837e9c00         cmp word ptr [bp - 0x64], 0
  0317A0  1CB0: 7c94             jl 0x1c46
  0317A2  1CB2: 3d6400           cmp ax, 0x64
  0317A5  1CB5: 7d03             jge 0x1cba
  0317A7  1CB7: e938ff           jmp 0x1bf2
  0317AA  1CBA: be1700           mov si, 0x17
  0317AD  1CBD: e935ff           jmp 0x1bf5
  0317B0  1CC0: 837e0400         cmp word ptr [bp + 4], 0
  0317B4  1CC4: 7413             je 0x1cd9
  0317B6  1CC6: 6a76             push 0x76
  0317B8  1CC8: 6a51             push 0x51
  0317BA  1CCA: 6a3c             push 0x3c
  0317BC  1CCC: b88f00           mov ax, 0x8f
  0317BF  1CCF: ba7600           mov dx, 0x76
  0317C2  1CD2: 8bd8             mov bx, ax
  0317C4  1CD4: 9ae2001f18       lcall 0x181f, 0xe2
  0317C9  1CD9: 5e               pop si
  0317CA  1CDA: c9               leave 
  0317CB  1CDB: c3               ret 

; ---- func_0317CC  size=261  insns=98  prologue=ENTER 0x0056,0  terminal=RETF ----
  0317CC  1CDC: c8560000         enter 0x56, 0
  0317D0  1CE0: 6a33             push 0x33
  0317D2  1CE2: 6a46             push 0x46
  0317D4  1CE4: 6a76             push 0x76
  0317D6  1CE6: 6a48             push 0x48
  0317D8  1CE8: 0e               push cs
  0317D9  1CE9: e8f050           call 0x6ddc
  0317DC  1CEC: 83c408           add sp, 8
  0317DF  1CEF: c646ae00         mov byte ptr [bp - 0x52], 0
  0317E3  1CF3: ff36ce2d         push word ptr [0x2dce]
  0317E7  1CF7: 8d46ae           lea ax, [bp - 0x52]
  0317EA  1CFA: 50               push ax
  0317EB  1CFB: 9a6e011f18       lcall 0x181f, 0x16e
  0317F0  1D00: 83c404           add sp, 4
  0317F3  1D03: 6a45             push 0x45
  0317F5  1D05: 6a78             push 0x78
  0317F7  1D07: 6a46             push 0x46
  0317F9  1D09: 6a48             push 0x48
  0317FB  1D0B: 8d46ae           lea ax, [bp - 0x52]
  0317FE  1D0E: 16               push ss
  0317FF  1D0F: 50               push ax
  031800  1D10: 9a00011f18       lcall 0x181f, 0x100
  031805  1D15: 83c40c           add sp, 0xc
  031808  1D18: c646ae00         mov byte ptr [bp - 0x52], 0
  03180C  1D1C: 6b06129e34       imul ax, word ptr [0x9e12], 0x34
  031811  1D21: 052654           add ax, 0x5426
  031814  1D24: 50               push ax
  031815  1D25: 8d46ae           lea ax, [bp - 0x52]
  031818  1D28: 50               push ax
  031819  1D29: 9aa4071d0d       lcall 0xd1d, 0x7a4
  03181E  1D2E: 83c404           add sp, 4
  031821  1D31: 6a45             push 0x45
  031823  1D33: c41e9e08         les bx, ptr [0x89e]
  031827  1D37: 268a07           mov al, byte ptr es:[bx]
  03182A  1D3A: 2ae4             sub ah, ah
  03182C  1D3C: 057900           add ax, 0x79
  03182F  1D3F: 50               push ax
  031830  1D40: 6a46             push 0x46
  031832  1D42: 6a48             push 0x48
  031834  1D44: 8d46ae           lea ax, [bp - 0x52]
  031837  1D47: 16               push ss
  031838  1D48: 50               push ax
  031839  1D49: 9a00011f18       lcall 0x181f, 0x100
  03183E  1D4E: 83c40c           add sp, 0xc
  031841  1D51: c746ac4900       mov word ptr [bp - 0x54], 0x49
  031846  1D56: c746fe0000       mov word ptr [bp - 2], 0
  03184B  1D5B: a1129e           mov ax, word ptr [0x9e12]
  03184E  1D5E: 2d1c00           sub ax, 0x1c
  031851  1D61: 8bd0             mov dx, ax
  031853  1D63: 9ae0071f18       lcall 0x181f, 0x7e0
  031858  1D68: eb1f             jmp 0x1d89
  03185A  1D6A: 6aff             push -1
  03185C  1D6C: 8d46fe           lea ax, [bp - 2]
  03185F  1D6F: 50               push ax
  031860  1D70: 6a01             push 1
  031862  1D72: 6a0d             push 0xd
  031864  1D74: ff76ac           push word ptr [bp - 0x54]
  031867  1D77: ff76aa           push word ptr [bp - 0x56]
  03186A  1D7A: 0e               push cs
  03186B  1D7B: e8bd50           call 0x6e3b
  03186E  1D7E: 83c40c           add sp, 0xc
  031871  1D81: 8b46aa           mov ax, word ptr [bp - 0x56]
  031874  1D84: 9ae4021f18       lcall 0x181f, 0x2e4
  031879  1D89: 8946aa           mov word ptr [bp - 0x56], ax
  03187C  1D8C: 0bc0             or ax, ax
  03187E  1D8E: 7dda             jge 0x1d6a
  031880  1D90: a1129e           mov ax, word ptr [0x9e12]
  031883  1D93: 2d1800           sub ax, 0x18
  031886  1D96: 8bd0             mov dx, ax
  031888  1D98: 9ae0071f18       lcall 0x181f, 0x7e0
  03188D  1D9D: eb20             jmp 0x1dbf
  03188F  1D9F: 90               nop 
  031890  1DA0: 6aff             push -1
  031892  1DA2: 8d46fe           lea ax, [bp - 2]
  031895  1DA5: 50               push ax
  031896  1DA6: 6a01             push 1
  031898  1DA8: 6a0d             push 0xd
  03189A  1DAA: ff76ac           push word ptr [bp - 0x54]
  03189D  1DAD: ff76aa           push word ptr [bp - 0x56]
  0318A0  1DB0: 0e               push cs
  0318A1  1DB1: e88750           call 0x6e3b
  0318A4  1DB4: 83c40c           add sp, 0xc
  0318A7  1DB7: 8b46aa           mov ax, word ptr [bp - 0x56]
  0318AA  1DBA: 9ae4021f18       lcall 0x181f, 0x2e4
  0318AF  1DBF: 8946aa           mov word ptr [bp - 0x56], ax
  0318B2  1DC2: 0bc0             or ax, ax
  0318B4  1DC4: 7dda             jge 0x1da0
  0318B6  1DC6: 837e0600         cmp word ptr [bp + 6], 0
  0318BA  1DCA: 7413             je 0x1ddf
  0318BC  1DCC: 6a76             push 0x76
  0318BE  1DCE: 6a46             push 0x46
  0318C0  1DD0: 6a33             push 0x33
  0318C2  1DD2: b84800           mov ax, 0x48
  0318C5  1DD5: ba7600           mov dx, 0x76
  0318C8  1DD8: 8bd8             mov bx, ax
  0318CA  1DDA: 9ae2001f18       lcall 0x181f, 0xe2
  0318CF  1DDF: c9               leave 
  0318D0  1DE0: cb               retf 

; ---- func_0318D2  size=211  insns=81  prologue=ENTER 0x0056,0  terminal=RETF ----
  0318D2  1DE2: c8560000         enter 0x56, 0
  0318D6  1DE6: 6a33             push 0x33
  0318D8  1DE8: 6a46             push 0x46
  0318DA  1DEA: 6a76             push 0x76
  0318DC  1DEC: 6a01             push 1
  0318DE  1DEE: 0e               push cs
  0318DF  1DEF: e8ea4f           call 0x6ddc
  0318E2  1DF2: 83c408           add sp, 8
  0318E5  1DF5: ff36cc2d         push word ptr [0x2dcc]
  0318E9  1DF9: 9a22001f18       lcall 0x181f, 0x22
  0318EE  1DFE: 83c402           add sp, 2
  0318F1  1E01: 52               push dx
  0318F2  1E02: 50               push ax
  0318F3  1E03: 8d46ae           lea ax, [bp - 0x52]
  0318F6  1E06: 16               push ss
  0318F7  1E07: 50               push ax
  0318F8  1E08: 9a7e111d0d       lcall 0xd1d, 0x117e
  0318FD  1E0D: 83c408           add sp, 8
  031900  1E10: 6a45             push 0x45
  031902  1E12: 6a78             push 0x78
  031904  1E14: 6a46             push 0x46
  031906  1E16: 6a01             push 1
  031908  1E18: 8d46ae           lea ax, [bp - 0x52]
  03190B  1E1B: 16               push ss
  03190C  1E1C: 50               push ax
  03190D  1E1D: 9a00011f18       lcall 0x181f, 0x100
  031912  1E22: 83c40c           add sp, 0xc
  031915  1E25: c746ac0200       mov word ptr [bp - 0x54], 2
  03191A  1E2A: c746fe0000       mov word ptr [bp - 2], 0
  03191F  1E2F: a1129e           mov ax, word ptr [0x9e12]
  031922  1E32: 2d1000           sub ax, 0x10
  031925  1E35: 8bd0             mov dx, ax
  031927  1E37: 9ae0071f18       lcall 0x181f, 0x7e0
  03192C  1E3C: eb1f             jmp 0x1e5d
  03192E  1E3E: 6aff             push -1
  031930  1E40: 8d46fe           lea ax, [bp - 2]
  031933  1E43: 50               push ax
  031934  1E44: 6a01             push 1
  031936  1E46: 6a0d             push 0xd
  031938  1E48: ff76ac           push word ptr [bp - 0x54]
  03193B  1E4B: ff76aa           push word ptr [bp - 0x56]
  03193E  1E4E: 0e               push cs
  03193F  1E4F: e8e94f           call 0x6e3b
  031942  1E52: 83c40c           add sp, 0xc
  031945  1E55: 8b46aa           mov ax, word ptr [bp - 0x56]
  031948  1E58: 9ae4021f18       lcall 0x181f, 0x2e4
  03194D  1E5D: 8946aa           mov word ptr [bp - 0x56], ax
  031950  1E60: 0bc0             or ax, ax
  031952  1E62: 7dda             jge 0x1e3e
  031954  1E64: a1129e           mov ax, word ptr [0x9e12]
  031957  1E67: 2d0c00           sub ax, 0xc
  03195A  1E6A: 8bd0             mov dx, ax
  03195C  1E6C: 9ae0071f18       lcall 0x181f, 0x7e0
  031961  1E71: eb20             jmp 0x1e93
  031963  1E73: 90               nop 
  031964  1E74: 6aff             push -1
  031966  1E76: 8d46fe           lea ax, [bp - 2]
  031969  1E79: 50               push ax
  03196A  1E7A: 6a01             push 1
  03196C  1E7C: 6a0d             push 0xd
  03196E  1E7E: ff76ac           push word ptr [bp - 0x54]
  031971  1E81: ff76aa           push word ptr [bp - 0x56]
  031974  1E84: 0e               push cs
  031975  1E85: e8b34f           call 0x6e3b
  031978  1E88: 83c40c           add sp, 0xc
  03197B  1E8B: 8b46aa           mov ax, word ptr [bp - 0x56]
  03197E  1E8E: 9ae4021f18       lcall 0x181f, 0x2e4
  031983  1E93: 8946aa           mov word ptr [bp - 0x56], ax
  031986  1E96: 0bc0             or ax, ax
  031988  1E98: 7dda             jge 0x1e74
  03198A  1E9A: 837e0600         cmp word ptr [bp + 6], 0
  03198E  1E9E: 7413             je 0x1eb3
  031990  1EA0: 6a76             push 0x76
  031992  1EA2: 6a46             push 0x46
  031994  1EA4: 6a33             push 0x33
  031996  1EA6: b80100           mov ax, 1
  031999  1EA9: ba7600           mov dx, 0x76
  03199C  1EAC: 8bd8             mov bx, ax
  03199E  1EAE: 9ae2001f18       lcall 0x181f, 0xe2
  0319A3  1EB3: c9               leave 
  0319A4  1EB4: cb               retf 

; ---- func_0319A6  size=21  insns=11  prologue=push bp;mov bp,sp  terminal=RETF ----
  0319A6  1EB6: 55               push bp
  0319A7  1EB7: 8bec             mov bp, sp
  0319A9  1EB9: ff7606           push word ptr [bp + 6]
  0319AC  1EBC: 0e               push cs
  0319AD  1EBD: e85d4f           call 0x6e1d
  0319B0  1EC0: 8be5             mov sp, bp
  0319B2  1EC2: ff7606           push word ptr [bp + 6]
  0319B5  1EC5: 0e               push cs
  0319B6  1EC6: e8a44f           call 0x6e6d
  0319B9  1EC9: c9               leave 
  0319BA  1ECA: cb               retf 

; ---- func_0319BC  size=117  insns=49  prologue=ENTER 0x0008,0  terminal=RETF ----
  0319BC  1ECC: c8080000         enter 8, 0
  0319C0  1ED0: 8b4606           mov ax, word ptr [bp + 6]
  0319C3  1ED3: 8946fe           mov word ptr [bp - 2], ax
  0319C6  1ED6: 2bc9             sub cx, cx
  0319C8  1ED8: 894ef8           mov word ptr [bp - 8], cx
  0319CB  1EDB: 8b5e0a           mov bx, word ptr [bp + 0xa]
  0319CE  1EDE: 890f             mov word ptr [bx], cx
  0319D0  1EE0: 3d0300           cmp ax, 3
  0319D3  1EE3: 7d05             jge 0x1eea
  0319D5  1EE5: 8946f8           mov word ptr [bp - 8], ax
  0319D8  1EE8: eb19             jmp 0x1f03
  0319DA  1EEA: 8b5e0a           mov bx, word ptr [bp + 0xa]
  0319DD  1EED: ff07             inc word ptr [bx]
  0319DF  1EEF: 836efe03         sub word ptr [bp - 2], 3
  0319E3  1EF3: 837efe05         cmp word ptr [bp - 2], 5
  0319E7  1EF7: 7d05             jge 0x1efe
  0319E9  1EF9: 8b46fe           mov ax, word ptr [bp - 2]
  0319EC  1EFC: ebe7             jmp 0x1ee5
  0319EE  1EFE: 8b5e0a           mov bx, word ptr [bp + 0xa]
  0319F1  1F01: ff07             inc word ptr [bx]
  0319F3  1F03: b81000           mov ax, 0x10
  0319F6  1F06: 8b5e12           mov bx, word ptr [bp + 0x12]
  0319F9  1F09: 8907             mov word ptr [bx], ax
  0319FB  1F0B: 8b5e10           mov bx, word ptr [bp + 0x10]
  0319FE  1F0E: 8907             mov word ptr [bx], ax
  031A00  1F10: 6b46f811         imul ax, word ptr [bp - 8], 0x11
  031A04  1F14: 034608           add ax, word ptr [bp + 8]
  031A07  1F17: 8b5e0c           mov bx, word ptr [bp + 0xc]
  031A0A  1F1A: 8907             mov word ptr [bx], ax
  031A0C  1F1C: 8b5e0a           mov bx, word ptr [bp + 0xa]
  031A0F  1F1F: 8b07             mov ax, word ptr [bx]
  031A11  1F21: eb15             jmp 0x1f38
  031A13  1F23: 90               nop 
  031A14  1F24: 8b5e0e           mov bx, word ptr [bp + 0xe]
  031A17  1F27: c7078a00         mov word ptr [bx], 0x8a
  031A1B  1F2B: c9               leave 
  031A1C  1F2C: cb               retf 
  031A1D  1F2D: 90               nop 
  031A1E  1F2E: 8b5e0e           mov bx, word ptr [bp + 0xe]
  031A21  1F31: c707a100         mov word ptr [bx], 0xa1
  031A25  1F35: c9               leave 
  031A26  1F36: cb               retf 
  031A27  1F37: 90               nop 
  031A28  1F38: 0bc0             or ax, ax
  031A2A  1F3A: 74e8             je 0x1f24
  031A2C  1F3C: 48               dec ax
  031A2D  1F3D: 74ef             je 0x1f2e
  031A2F  1F3F: c9               leave 
  031A30  1F40: cb               retf 

; ---- func_031A32  size=199  insns=70  prologue=ENTER 0x000A,0  terminal=RETF ----
  031A32  1F42: c80a0000         enter 0xa, 0
  031A36  1F46: 8d46f6           lea ax, [bp - 0xa]
  031A39  1F49: 50               push ax
  031A3A  1F4A: 8d46f8           lea ax, [bp - 8]
  031A3D  1F4D: 50               push ax
  031A3E  1F4E: 8d46fa           lea ax, [bp - 6]
  031A41  1F51: 50               push ax
  031A42  1F52: 8d4efe           lea cx, [bp - 2]
  031A45  1F55: 51               push cx
  031A46  1F56: 8d56fc           lea dx, [bp - 4]
  031A49  1F59: 52               push dx
  031A4A  1F5A: ff7608           push word ptr [bp + 8]
  031A4D  1F5D: 8b5e0a           mov bx, word ptr [bp + 0xa]
  031A50  1F60: ff37             push word ptr [bx]
  031A52  1F62: 0e               push cs
  031A53  1F63: e8354e           call 0x6d9b
  031A56  1F66: 83c40e           add sp, 0xe
  031A59  1F69: 837efc02         cmp word ptr [bp - 4], 2
  031A5D  1F6D: 7d5a             jge 0x1fc9
  031A5F  1F6F: ff76fa           push word ptr [bp - 6]
  031A62  1F72: 6a10             push 0x10
  031A64  1F74: 6a64             push 0x64
  031A66  1F76: 8b4606           mov ax, word ptr [bp + 6]
  031A69  1F79: 2bd2             sub dx, dx
  031A6B  1F7B: 8b5efe           mov bx, word ptr [bp - 2]
  031A6E  1F7E: 9abc021f18       lcall 0x181f, 0x2bc
  031A73  1F83: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  031A77  1F87: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  031A7C  1F8C: 723b             jb 0x1fc9
  031A7E  1F8E: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  031A83  1F93: 7734             ja 0x1fc9
  031A85  1F95: 837efc00         cmp word ptr [bp - 4], 0
  031A89  1F99: 752e             jne 0x1fc9
  031A8B  1F9B: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  031A90  1FA0: 7427             je 0x1fc9
  031A92  1FA2: ff364008         push word ptr [0x840]
  031A96  1FA6: ff363e08         push word ptr [0x83e]
  031A9A  1FAA: ff76fa           push word ptr [bp - 6]
  031A9D  1FAD: 6a00             push 0
  031A9F  1FAF: ff7606           push word ptr [bp + 6]
  031AA2  1FB2: 9ae60b1f18       lcall 0x181f, 0xbe6
  031AA7  1FB7: 83c404           add sp, 4
  031AAA  1FBA: 051700           add ax, 0x17
  031AAD  1FBD: 8d1ea82d         lea bx, [0x2da8]
  031AB1  1FC1: 8b56fe           mov dx, word ptr [bp - 2]
  031AB4  1FC4: 9a54021f18       lcall 0x181f, 0x254
  031AB9  1FC9: 837e0c00         cmp word ptr [bp + 0xc], 0
  031ABD  1FCD: 7c33             jl 0x2002
  031ABF  1FCF: 837efc02         cmp word ptr [bp - 4], 2
  031AC3  1FD3: 7d2d             jge 0x2002
  031AC5  1FD5: ff36ae2d         push word ptr [0x2dae]
  031AC9  1FD9: ff36ac2d         push word ptr [0x2dac]
  031ACD  1FDD: ff36aa2d         push word ptr [0x2daa]
  031AD1  1FE1: ff36a82d         push word ptr [0x2da8]
  031AD5  1FE5: 8b46f6           mov ax, word ptr [bp - 0xa]
  031AD8  1FE8: 0346fa           add ax, word ptr [bp - 6]
  031ADB  1FEB: 50               push ax
  031ADC  1FEC: 8a460c           mov al, byte ptr [bp + 0xc]
  031ADF  1FEF: 50               push ax
  031AE0  1FF0: 8b46fe           mov ax, word ptr [bp - 2]
  031AE3  1FF3: 8b5ef8           mov bx, word ptr [bp - 8]
  031AE6  1FF6: 03d8             add bx, ax
  031AE8  1FF8: 48               dec ax
  031AE9  1FF9: 8b56fa           mov dx, word ptr [bp - 6]
  031AEC  1FFC: 4a               dec dx
  031AED  1FFD: 9ace001f18       lcall 0x181f, 0xce
  031AF2  2002: 8b5e0a           mov bx, word ptr [bp + 0xa]
  031AF5  2005: ff07             inc word ptr [bx]
  031AF7  2007: c9               leave 
  031AF8  2008: cb               retf 

; ---- func_031AFA  size=182  insns=60  prologue=ENTER 0x0008,0  terminal=RETF ----
  031AFA  200A: c8080000         enter 8, 0
  031AFE  200E: 6a3b             push 0x3b
  031B00  2010: 6a60             push 0x60
  031B02  2012: 6a78             push 0x78
  031B04  2014: 68e000           push 0xe0
  031B07  2017: 0e               push cs
  031B08  2018: e8c14d           call 0x6ddc
  031B0B  201B: 83c408           add sp, 8
  031B0E  201E: c746fce900       mov word ptr [bp - 4], 0xe9
  031B13  2023: c746fe0000       mov word ptr [bp - 2], 0
  031B18  2028: a1129e           mov ax, word ptr [0x9e12]
  031B1B  202B: 2d1400           sub ax, 0x14
  031B1E  202E: 8bd0             mov dx, ax
  031B20  2030: 9ae0071f18       lcall 0x181f, 0x7e0
  031B25  2035: eb67             jmp 0x209e
  031B27  2037: 90               nop 
  031B28  2038: 6bd81c           imul bx, ax, 0x1c
  031B2B  203B: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  031B30  2040: 7207             jb 0x2049
  031B32  2042: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  031B37  2047: 764d             jbe 0x2096
  031B39  2049: c746f8ffff       mov word ptr [bp - 8], 0xffff
  031B3E  204E: 8b46fe           mov ax, word ptr [bp - 2]
  031B41  2051: 39062c9e         cmp word ptr [0x9e2c], ax
  031B45  2055: 752b             jne 0x2082
  031B47  2057: c746f80a00       mov word ptr [bp - 8], 0xa
  031B4C  205C: 833eee0700       cmp word ptr [0x7ee], 0
  031B51  2061: 740c             je 0x206f
  031B53  2063: 833e3a9e04       cmp word ptr [0x9e3a], 4
  031B58  2068: 7505             jne 0x206f
  031B5A  206A: c746f80f00       mov word ptr [bp - 8], 0xf
  031B5F  206F: 833e9a0f02       cmp word ptr [0xf9a], 2
  031B64  2074: 750c             jne 0x2082
  031B66  2076: 833e409e00       cmp word ptr [0x9e40], 0
  031B6B  207B: 7405             je 0x2082
  031B6D  207D: c746f80f00       mov word ptr [bp - 8], 0xf
  031B72  2082: ff76f8           push word ptr [bp - 8]
  031B75  2085: 8d46fe           lea ax, [bp - 2]
  031B78  2088: 50               push ax
  031B79  2089: ff76fc           push word ptr [bp - 4]
  031B7C  208C: ff76fa           push word ptr [bp - 6]
  031B7F  208F: 0e               push cs
  031B80  2090: e8714d           call 0x6e04
  031B83  2093: 83c408           add sp, 8
  031B86  2096: 8b46fa           mov ax, word ptr [bp - 6]
  031B89  2099: 9ae4021f18       lcall 0x181f, 0x2e4
  031B8E  209E: 8946fa           mov word ptr [bp - 6], ax
  031B91  20A1: 0bc0             or ax, ax
  031B93  20A3: 7d93             jge 0x2038
  031B95  20A5: 837e0600         cmp word ptr [bp + 6], 0
  031B99  20A9: 7413             je 0x20be
  031B9B  20AB: 6a78             push 0x78
  031B9D  20AD: 6a60             push 0x60
  031B9F  20AF: 6a3b             push 0x3b
  031BA1  20B1: b8e000           mov ax, 0xe0
  031BA4  20B4: ba7800           mov dx, 0x78
  031BA7  20B7: 8bd8             mov bx, ax
  031BA9  20B9: 9ae2001f18       lcall 0x181f, 0xe2
  031BAE  20BE: c9               leave 
  031BAF  20BF: cb               retf 

; ---- func_031BB0  size=54  insns=20  prologue=ENTER 0x0002,0  terminal=RET ----
  031BB0  20C0: c8020000         enter 2, 0
  031BB4  20C4: ff7604           push word ptr [bp + 4]
  031BB7  20C7: 9a22001f18       lcall 0x181f, 0x22
  031BBC  20CC: 83c402           add sp, 2
  031BBF  20CF: 52               push dx
  031BC0  20D0: 50               push ax
  031BC1  20D1: 9a14011f18       lcall 0x181f, 0x114
  031BC6  20D6: 8b5e06           mov bx, word ptr [bp + 6]
  031BC9  20D9: 8907             mov word ptr [bx], ax
  031BCB  20DB: c41e9e08         les bx, ptr [0x89e]
  031BCF  20DF: 268a07           mov al, byte ptr es:[bx]
  031BD2  20E2: 2ae4             sub ah, ah
  031BD4  20E4: 48               dec ax
  031BD5  20E5: 8b5e08           mov bx, word ptr [bp + 8]
  031BD8  20E8: c7072500         mov word ptr [bx], 0x25
  031BDC  20EC: 050400           add ax, 4
  031BDF  20EF: 8b5e0a           mov bx, word ptr [bp + 0xa]
  031BE2  20F2: 8907             mov word ptr [bx], ax
  031BE4  20F4: c9               leave 
  031BE5  20F5: c3               ret 

; ---- func_031BE6  size=481  insns=164  prologue=ENTER 0x00B6,0  terminal=RET ----
  031BE6  20F6: c8b60000         enter 0xb6, 0
  031BEA  20FA: 57               push di
  031BEB  20FB: 56               push si
  031BEC  20FC: 8a460a           mov al, byte ptr [bp + 0xa]
  031BEF  20FF: 250100           and ax, 1
  031BF2  2102: 741c             je 0x2120
  031BF4  2104: c68658ff00       mov byte ptr [bp - 0xa8], 0
  031BF9  2109: c78656ff0f00     mov word ptr [bp - 0xaa], 0xf
  031BFF  210F: c6864eff30       mov byte ptr [bp - 0xb2], 0x30
  031C04  2114: c646fe39         mov byte ptr [bp - 2], 0x39
  031C08  2118: c68650ff07       mov byte ptr [bp - 0xb0], 7
  031C0D  211D: eb1a             jmp 0x2139
  031C0F  211F: 90               nop 
  031C10  2120: c68658ff0f       mov byte ptr [bp - 0xa8], 0xf
  031C15  2125: c78656ffffff     mov word ptr [bp - 0xaa], 0xffff
  031C1B  212B: c6864eff39       mov byte ptr [bp - 0xb2], 0x39
  031C20  2130: c646fe30         mov byte ptr [bp - 2], 0x30
  031C24  2134: c68650ff0e       mov byte ptr [bp - 0xb0], 0xe
  031C29  2139: 8d8652ff         lea ax, [bp - 0xae]
  031C2D  213D: 50               push ax
  031C2E  213E: 8d8e54ff         lea cx, [bp - 0xac]
  031C32  2142: 51               push cx
  031C33  2143: 8d56fa           lea dx, [bp - 6]
  031C36  2146: 52               push dx
  031C37  2147: ff7604           push word ptr [bp + 4]
  031C3A  214A: e873ff           call 0x20c0
  031C3D  214D: 83c408           add sp, 8
  031C40  2150: 8b8654ff         mov ax, word ptr [bp - 0xac]
  031C44  2154: 2b46fa           sub ax, word ptr [bp - 6]
  031C47  2157: d1f8             sar ax, 1
  031C49  2159: 034606           add ax, word ptr [bp + 6]
  031C4C  215C: 89864cff         mov word ptr [bp - 0xb4], ax
  031C50  2160: 8b4608           mov ax, word ptr [bp + 8]
  031C53  2163: 40               inc ax
  031C54  2164: 40               inc ax
  031C55  2165: 89864aff         mov word ptr [bp - 0xb6], ax
  031C59  2169: f6460a02         test byte ptr [bp + 0xa], 2
  031C5D  216D: 7403             je 0x2172
  031C5F  216F: e9dd00           jmp 0x224f
  031C62  2172: ff36ae2d         push word ptr [0x2dae]
  031C66  2176: ff36ac2d         push word ptr [0x2dac]
  031C6A  217A: ff36aa2d         push word ptr [0x2daa]
  031C6E  217E: ff36a82d         push word ptr [0x2da8]
  031C72  2182: 8a46fe           mov al, byte ptr [bp - 2]
  031C75  2185: 50               push ax
  031C76  2186: 8b4606           mov ax, word ptr [bp + 6]
  031C79  2189: 8b9654ff         mov dx, word ptr [bp - 0xac]
  031C7D  218D: 03d0             add dx, ax
  031C7F  218F: 8b9e52ff         mov bx, word ptr [bp - 0xae]
  031C83  2193: 035e08           add bx, word ptr [bp + 8]
  031C86  2196: 4b               dec bx
  031C87  2197: 4a               dec dx
  031C88  2198: 8bf0             mov si, ax
  031C8A  219A: 9abc081f19       lcall 0x191f, 0x8bc
  031C8F  219F: ff36ae2d         push word ptr [0x2dae]
  031C93  21A3: ff36ac2d         push word ptr [0x2dac]
  031C97  21A7: ff36aa2d         push word ptr [0x2daa]
  031C9B  21AB: ff36a82d         push word ptr [0x2da8]
  031C9F  21AF: 8a46fe           mov al, byte ptr [bp - 2]
  031CA2  21B2: 50               push ax
  031CA3  21B3: 8b8654ff         mov ax, word ptr [bp - 0xac]
  031CA7  21B7: 034606           add ax, word ptr [bp + 6]
  031CAA  21BA: 48               dec ax
  031CAB  21BB: 8b9e52ff         mov bx, word ptr [bp - 0xae]
  031CAF  21BF: 035e08           add bx, word ptr [bp + 8]
  031CB2  21C2: 4b               dec bx
  031CB3  21C3: 8b5608           mov dx, word ptr [bp + 8]
  031CB6  21C6: 8bfa             mov di, dx
  031CB8  21C8: 9ab2081f19       lcall 0x191f, 0x8b2
  031CBD  21CD: ff36ae2d         push word ptr [0x2dae]
  031CC1  21D1: ff36ac2d         push word ptr [0x2dac]
  031CC5  21D5: ff36aa2d         push word ptr [0x2daa]
  031CC9  21D9: ff36a82d         push word ptr [0x2da8]
  031CCD  21DD: 8a864eff         mov al, byte ptr [bp - 0xb2]
  031CD1  21E1: 50               push ax
  031CD2  21E2: 8bdf             mov bx, di
  031CD4  21E4: 8bc6             mov ax, si
  031CD6  21E6: 8b9654ff         mov dx, word ptr [bp - 0xac]
  031CDA  21EA: 035606           add dx, word ptr [bp + 6]
  031CDD  21ED: 4a               dec dx
  031CDE  21EE: 9abc081f19       lcall 0x191f, 0x8bc
  031CE3  21F3: ff36ae2d         push word ptr [0x2dae]
  031CE7  21F7: ff36ac2d         push word ptr [0x2dac]
  031CEB  21FB: ff36aa2d         push word ptr [0x2daa]
  031CEF  21FF: ff36a82d         push word ptr [0x2da8]
  031CF3  2203: 8a864eff         mov al, byte ptr [bp - 0xb2]
  031CF7  2207: 50               push ax
  031CF8  2208: 8bc6             mov ax, si
  031CFA  220A: 8b9e52ff         mov bx, word ptr [bp - 0xae]
  031CFE  220E: 035e08           add bx, word ptr [bp + 8]
  031D01  2211: 4b               dec bx
  031D02  2212: 8bd7             mov dx, di
  031D04  2214: 9ab2081f19       lcall 0x191f, 0x8b2
  031D09  2219: 83be56ff00       cmp word ptr [bp - 0xaa], 0
  031D0E  221E: 7c2f             jl 0x224f
  031D10  2220: ff36ae2d         push word ptr [0x2dae]
  031D14  2224: ff36ac2d         push word ptr [0x2dac]
  031D18  2228: ff36aa2d         push word ptr [0x2daa]
  031D1C  222C: ff36a82d         push word ptr [0x2da8]
  031D20  2230: 8b8652ff         mov ax, word ptr [bp - 0xae]
  031D24  2234: 48               dec ax
  031D25  2235: 48               dec ax
  031D26  2236: 50               push ax
  031D27  2237: 8a8656ff         mov al, byte ptr [bp - 0xaa]
  031D2B  223B: 50               push ax
  031D2C  223C: 8b4606           mov ax, word ptr [bp + 6]
  031D2F  223F: 40               inc ax
  031D30  2240: 8b9e54ff         mov bx, word ptr [bp - 0xac]
  031D34  2244: 4b               dec bx
  031D35  2245: 4b               dec bx
  031D36  2246: 8b5608           mov dx, word ptr [bp + 8]
  031D39  2249: 42               inc dx
  031D3A  224A: 9aba001f18       lcall 0x181f, 0xba
  031D3F  224F: ff7604           push word ptr [bp + 4]
  031D42  2252: 9a22001f18       lcall 0x181f, 0x22
  031D47  2257: 83c402           add sp, 2
  031D4A  225A: 52               push dx
  031D4B  225B: 50               push ax
  031D4C  225C: 8d46aa           lea ax, [bp - 0x56]
  031D4F  225F: 16               push ss
  031D50  2260: 50               push ax
  031D51  2261: 9a7e111d0d       lcall 0xd1d, 0x117e
  031D56  2266: 83c408           add sp, 8
  031D59  2269: 8d46aa           lea ax, [bp - 0x56]
  031D5C  226C: 50               push ax
  031D5D  226D: 9a42081d0d       lcall 0xd1d, 0x842
  031D62  2272: 83c402           add sp, 2
  031D65  2275: 0bc0             or ax, ax
  031D67  2277: 7413             je 0x228c
  031D69  2279: 8d46ab           lea ax, [bp - 0x55]
  031D6C  227C: 50               push ax
  031D6D  227D: 8d865aff         lea ax, [bp - 0xa6]
  031D71  2281: 50               push ax
  031D72  2282: 9ae4071d0d       lcall 0xd1d, 0x7e4
  031D77  2287: 83c404           add sp, 4
  031D7A  228A: eb05             jmp 0x2291
  031D7C  228C: c6865aff00       mov byte ptr [bp - 0xa6], 0
  031D81  2291: c646ab00         mov byte ptr [bp - 0x55], 0
  031D85  2295: 8a8658ff         mov al, byte ptr [bp - 0xa8]
  031D89  2299: 2ae4             sub ah, ah
  031D8B  229B: 50               push ax
  031D8C  229C: ffb64aff         push word ptr [bp - 0xb6]
  031D90  22A0: 8a8650ff         mov al, byte ptr [bp - 0xb0]
  031D94  22A4: 50               push ax
  031D95  22A5: ffb64aff         push word ptr [bp - 0xb6]
  031D99  22A9: ffb64cff         push word ptr [bp - 0xb4]
  031D9D  22AD: 8d46aa           lea ax, [bp - 0x56]
  031DA0  22B0: 16               push ss
  031DA1  22B1: 50               push ax
  031DA2  22B2: 9a3c011f18       lcall 0x181f, 0x13c
  031DA7  22B7: 83c40a           add sp, 0xa
  031DAA  22BA: 8946fc           mov word ptr [bp - 4], ax
  031DAD  22BD: 50               push ax
  031DAE  22BE: 8d865aff         lea ax, [bp - 0xa6]
  031DB2  22C2: 16               push ss
  031DB3  22C3: 50               push ax
  031DB4  22C4: 9a3c011f18       lcall 0x181f, 0x13c
  031DB9  22C9: 83c40a           add sp, 0xa
  031DBC  22CC: 8946fc           mov word ptr [bp - 4], ax
  031DBF  22CF: 8b8652ff         mov ax, word ptr [bp - 0xae]
  031DC3  22D3: 5e               pop si
  031DC4  22D4: 5f               pop di
  031DC5  22D5: c9               leave 
  031DC6  22D6: c3               ret 

; ---- func_031DC8  size=351  insns=138  prologue=ENTER 0x000A,0  terminal=RETF ----
  031DC8  22D8: c80a0000         enter 0xa, 0
  031DCC  22DC: 6a20             push 0x20
  031DCE  22DE: 6a25             push 0x25
  031DD0  22E0: 6a59             push 0x59
  031DD2  22E2: 681901           push 0x119
  031DD5  22E5: 0e               push cs
  031DD6  22E6: e8f34a           call 0x6ddc
  031DD9  22E9: 83c408           add sp, 8
  031DDC  22EC: c746fe1901       mov word ptr [bp - 2], 0x119
  031DE1  22F1: c746fc5900       mov word ptr [bp - 4], 0x59
  031DE6  22F6: c746fa0000       mov word ptr [bp - 6], 0
  031DEB  22FB: c746f80000       mov word ptr [bp - 8], 0
  031DF0  2300: 8b46fa           mov ax, word ptr [bp - 6]
  031DF3  2303: 39062e9e         cmp word ptr [0x9e2e], ax
  031DF7  2307: 7513             jne 0x231c
  031DF9  2309: 833eee0700       cmp word ptr [0x7ee], 0
  031DFE  230E: 740c             je 0x231c
  031E00  2310: 833e3a9e05       cmp word ptr [0x9e3a], 5
  031E05  2315: 7505             jne 0x231c
  031E07  2317: c746f80100       mov word ptr [bp - 8], 1
  031E0C  231C: ff76f8           push word ptr [bp - 8]
  031E0F  231F: ff76fc           push word ptr [bp - 4]
  031E12  2322: ff76fe           push word ptr [bp - 2]
  031E15  2325: 8bd8             mov bx, ax
  031E17  2327: d1e3             shl bx, 1
  031E19  2329: ffb7d893         push word ptr [bx - 0x6c28]
  031E1D  232D: e8c6fd           call 0x20f6
  031E20  2330: 83c408           add sp, 8
  031E23  2333: 40               inc ax
  031E24  2334: 40               inc ax
  031E25  2335: 0146fc           add word ptr [bp - 4], ax
  031E28  2338: ff46fa           inc word ptr [bp - 6]
  031E2B  233B: 837efa03         cmp word ptr [bp - 6], 3
  031E2F  233F: 7cba             jl 0x22fb
  031E31  2341: 837e0400         cmp word ptr [bp + 4], 0
  031E35  2345: 7413             je 0x235a
  031E37  2347: 6a59             push 0x59
  031E39  2349: 6a25             push 0x25
  031E3B  234B: 6a20             push 0x20
  031E3D  234D: b81901           mov ax, 0x119
  031E40  2350: ba5900           mov dx, 0x59
  031E43  2353: 8bd8             mov bx, ax
  031E45  2355: 9ae2001f18       lcall 0x181f, 0xe2
  031E4A  235A: c9               leave 
  031E4B  235B: c3               ret 
  031E4C  235C: 68c000           push 0xc0
  031E4F  235F: 684001           push 0x140
  031E52  2362: 6a08             push 8
  031E54  2364: 6a00             push 0
  031E56  2366: 0e               push cs
  031E57  2367: e8724a           call 0x6ddc
  031E5A  236A: 83c408           add sp, 8
  031E5D  236D: 0e               push cs
  031E5E  236E: e8434a           call 0x6db4
  031E61  2371: 6a00             push 0
  031E63  2373: e84ef2           call 0x15c4
  031E66  2376: 83c402           add sp, 2
  031E69  2379: 6a00             push 0
  031E6B  237B: e808f1           call 0x1486
  031E6E  237E: 83c402           add sp, 2
  031E71  2381: 6a00             push 0
  031E73  2383: e866f6           call 0x19ec
  031E76  2386: 83c402           add sp, 2
  031E79  2389: 6a00             push 0
  031E7B  238B: 0e               push cs
  031E7C  238C: e8e449           call 0x6d73
  031E7F  238F: 83c402           add sp, 2
  031E82  2392: 6a00             push 0
  031E84  2394: 0e               push cs
  031E85  2395: e89e4a           call 0x6e36
  031E88  2398: 83c402           add sp, 2
  031E8B  239B: 6a00             push 0
  031E8D  239D: e838ff           call 0x22d8
  031E90  23A0: 83c402           add sp, 2
  031E93  23A3: 6a00             push 0
  031E95  23A5: 684001           push 0x140
  031E98  23A8: 68c800           push 0xc8
  031E9B  23AB: 2bc0             sub ax, ax
  031E9D  23AD: 99               cdq 
  031E9E  23AE: 2bdb             sub bx, bx
  031EA0  23B0: 9ae2001f18       lcall 0x181f, 0xe2
  031EA5  23B5: cb               retf 
  031EA6  23B6: 0e               push cs
  031EA7  23B7: e8314a           call 0x6deb
  031EAA  23BA: 0e               push cs
  031EAB  23BB: e8734a           call 0x6e31
  031EAE  23BE: cb               retf 
  031EAF  23BF: 90               nop 
  031EB0  23C0: 833e409e01       cmp word ptr [0x9e40], 1
  031EB5  23C5: 1bc0             sbb ax, ax
  031EB7  23C7: f7d8             neg ax
  031EB9  23C9: a3409e           mov word ptr [0x9e40], ax
  031EBC  23CC: a19a0f           mov ax, word ptr [0xf9a]
  031EBF  23CF: eb21             jmp 0x23f2
  031EC1  23D1: 90               nop 
  031EC2  23D2: 803ea70f00       cmp byte ptr [0xfa7], 0
  031EC7  23D7: 7523             jne 0x23fc
  031EC9  23D9: 6a01             push 1
  031ECB  23DB: e8e6f1           call 0x15c4
  031ECE  23DE: 83c402           add sp, 2
  031ED1  23E1: cb               retf 
  031ED2  23E2: 6a01             push 1
  031ED4  23E4: e805f6           call 0x19ec
  031ED7  23E7: ebf5             jmp 0x23de
  031ED9  23E9: 90               nop 
  031EDA  23EA: 6a01             push 1
  031EDC  23EC: 0e               push cs
  031EDD  23ED: e8464a           call 0x6e36
  031EE0  23F0: ebec             jmp 0x23de
  031EE2  23F2: 0bc0             or ax, ax
  031EE4  23F4: 74dc             je 0x23d2
  031EE6  23F6: 48               dec ax
  031EE7  23F7: 74e9             je 0x23e2
  031EE9  23F9: 48               dec ax
  031EEA  23FA: 74ee             je 0x23ea
  031EEC  23FC: cb               retf 
  031EED  23FD: 90               nop 
  031EEE  23FE: b80100           mov ax, 1
  031EF1  2401: a3409e           mov word ptr [0x9e40], ax
  031EF4  2404: 50               push ax
  031EF5  2405: e8e4f5           call 0x19ec
  031EF8  2408: 83c402           add sp, 2
  031EFB  240B: 6a01             push 1
  031EFD  240D: e8b4f1           call 0x15c4
  031F00  2410: 83c402           add sp, 2
  031F03  2413: 6a01             push 1
  031F05  2415: e86ef0           call 0x1486
  031F08  2418: 83c402           add sp, 2
  031F0B  241B: 6a01             push 1
  031F0D  241D: 0e               push cs
  031F0E  241E: e8154a           call 0x6e36
  031F11  2421: 83c402           add sp, 2
  031F14  2424: 9a06000c0c       lcall 0xc0c, 6
  031F19  2429: 051400           add ax, 0x14
  031F1C  242C: 83d200           adc dx, 0
  031F1F  242F: a3309e           mov word ptr [0x9e30], ax
  031F22  2432: 8916329e         mov word ptr [0x9e32], dx
  031F26  2436: cb               retf 

; ---- func_031F28  size=32  insns=13  prologue=push bp;mov bp,sp  terminal=RETF ----
  031F28  2438: 55               push bp
  031F29  2439: 8bec             mov bp, sp
  031F2B  243B: ff760a           push word ptr [bp + 0xa]
  031F2E  243E: ff7608           push word ptr [bp + 8]
  031F31  2441: ff7606           push word ptr [bp + 6]
  031F34  2444: 9a92001f18       lcall 0x181f, 0x92
  031F39  2449: 8be5             mov sp, bp
  031F3B  244B: 6a00             push 0
  031F3D  244D: 6a00             push 0
  031F3F  244F: 6a01             push 1
  031F41  2451: 9ab0001f18       lcall 0x181f, 0xb0
  031F46  2456: c9               leave 
  031F47  2457: cb               retf 

; ---- func_031F48  size=19  insns=8  prologue=push bp;mov bp,sp  terminal=RETF ----
  031F48  2458: 55               push bp
  031F49  2459: 8bec             mov bp, sp
  031F4B  245B: 8b5e06           mov bx, word ptr [bp + 6]
  031F4E  245E: d1e3             shl bx, 1
  031F50  2460: ffb7b293         push word ptr [bx - 0x6c4e]
  031F54  2464: 9a74001f18       lcall 0x181f, 0x74
  031F59  2469: c9               leave 
  031F5A  246A: cb               retf 

; ---- func_031F5C  size=35  insns=16  prologue=push bp;mov bp,sp  terminal=RETF ----
  031F5C  246C: 55               push bp
  031F5D  246D: 8bec             mov bp, sp
  031F5F  246F: 6a01             push 1
  031F61  2471: 9a56001f18       lcall 0x181f, 0x56
  031F66  2476: 8be5             mov sp, bp
  031F68  2478: ff7606           push word ptr [bp + 6]
  031F6B  247B: 0e               push cs
  031F6C  247C: e8e548           call 0x6d64
  031F6F  247F: 8be5             mov sp, bp
  031F71  2481: ff760a           push word ptr [bp + 0xa]
  031F74  2484: ff7608           push word ptr [bp + 8]
  031F77  2487: 6a03             push 3
  031F79  2489: 0e               push cs
  031F7A  248A: e8c348           call 0x6d50
  031F7D  248D: c9               leave 
  031F7E  248E: cb               retf 

; ---- func_031F80  size=137  insns=49  prologue=push bp;mov bp,sp  terminal=RETF ----
  031F80  2490: 55               push bp
  031F81  2491: 8bec             mov bp, sp
  031F83  2493: 6a01             push 1
  031F85  2495: 9a56001f18       lcall 0x181f, 0x56
  031F8A  249A: 8be5             mov sp, bp
  031F8C  249C: 837e0a00         cmp word ptr [bp + 0xa], 0
  031F90  24A0: 7404             je 0x24a6
  031F92  24A2: 6a0d             push 0xd
  031F94  24A4: eb02             jmp 0x24a8
  031F96  24A6: 6a0e             push 0xe
  031F98  24A8: 0e               push cs
  031F99  24A9: e8b848           call 0x6d64
  031F9C  24AC: 83c402           add sp, 2
  031F9F  24AF: 8b5e06           mov bx, word ptr [bp + 6]
  031FA2  24B2: d1e3             shl bx, 1
  031FA4  24B4: ffb7c097         push word ptr [bx - 0x6840]
  031FA8  24B8: 9a74001f18       lcall 0x181f, 0x74
  031FAD  24BD: 83c402           add sp, 2
  031FB0  24C0: 6a0c             push 0xc
  031FB2  24C2: 0e               push cs
  031FB3  24C3: e89e48           call 0x6d64
  031FB6  24C6: 83c402           add sp, 2
  031FB9  24C9: 8b460c           mov ax, word ptr [bp + 0xc]
  031FBC  24CC: f76e08           imul word ptr [bp + 8]
  031FBF  24CF: 50               push ax
  031FC0  24D0: 9a7e001f18       lcall 0x181f, 0x7e
  031FC5  24D5: 83c402           add sp, 2
  031FC8  24D8: ff36a093         push word ptr [0x93a0]
  031FCC  24DC: 9a74001f18       lcall 0x181f, 0x74
  031FD1  24E1: 83c402           add sp, 2
  031FD4  24E4: 1e               push ds
  031FD5  24E5: 68c30f           push 0xfc3
  031FD8  24E8: 9a6a001f18       lcall 0x181f, 0x6a
  031FDD  24ED: 83c404           add sp, 4
  031FE0  24F0: ff36129e         push word ptr [0x9e12]
  031FE4  24F4: 9a5a0b1f18       lcall 0x181f, 0xb5a
  031FE9  24F9: 83c402           add sp, 2
  031FEC  24FC: 9a88001f18       lcall 0x181f, 0x88
  031FF1  2501: 1e               push ds
  031FF2  2502: 68c50f           push 0xfc5
  031FF5  2505: 9a6a001f18       lcall 0x181f, 0x6a
  031FFA  250A: 83c404           add sp, 4
  031FFD  250D: 6a00             push 0
  031FFF  250F: 6a00             push 0
  032001  2511: 6a01             push 1
  032003  2513: 0e               push cs
  032004  2514: e83948           call 0x6d50
  032007  2517: c9               leave 
  032008  2518: cb               retf 

; ---- func_03200A  size=227  insns=89  prologue=ENTER 0x0002,0  terminal=RETF ----
  03200A  251A: c8020000         enter 2, 0
  03200E  251E: 6a15             push 0x15
  032010  2520: b80f00           mov ax, 0xf
  032013  2523: 8946fe           mov word ptr [bp - 2], ax
  032016  2526: 50               push ax
  032017  2527: 68b300           push 0xb3
  03201A  252A: 683101           push 0x131
  03201D  252D: 9aca031f18       lcall 0x181f, 0x3ca
  032022  2532: 83c408           add sp, 8
  032025  2535: 0bc0             or ax, ax
  032027  2537: 740b             je 0x2544
  032029  2539: c746fe0b00       mov word ptr [bp - 2], 0xb
  03202E  253E: 8b46fe           mov ax, word ptr [bp - 2]
  032031  2541: c9               leave 
  032032  2542: cb               retf 
  032033  2543: 90               nop 
  032034  2544: 6a20             push 0x20
  032036  2546: 6a25             push 0x25
  032038  2548: 6a59             push 0x59
  03203A  254A: 681901           push 0x119
  03203D  254D: 9aca031f18       lcall 0x181f, 0x3ca
  032042  2552: 83c408           add sp, 8
  032045  2555: 0bc0             or ax, ax
  032047  2557: 740b             je 0x2564
  032049  2559: c746fe0500       mov word ptr [bp - 2], 5
  03204E  255E: 8b46fe           mov ax, word ptr [bp - 2]
  032051  2561: c9               leave 
  032052  2562: cb               retf 
  032053  2563: 90               nop 
  032054  2564: 6a15             push 0x15
  032056  2566: 683101           push 0x131
  032059  2569: 68b300           push 0xb3
  03205C  256C: 6a00             push 0
  03205E  256E: 9aca031f18       lcall 0x181f, 0x3ca
  032063  2573: 83c408           add sp, 8
  032066  2576: 0bc0             or ax, ax
  032068  2578: 740a             je 0x2584
  03206A  257A: c746fe0000       mov word ptr [bp - 2], 0
  03206F  257F: 8b46fe           mov ax, word ptr [bp - 2]
  032072  2582: c9               leave 
  032073  2583: cb               retf 
  032074  2584: 6a3c             push 0x3c
  032076  2586: 6a51             push 0x51
  032078  2588: 6a76             push 0x76
  03207A  258A: 688f00           push 0x8f
  03207D  258D: 9aca031f18       lcall 0x181f, 0x3ca
  032082  2592: 83c408           add sp, 8
  032085  2595: 0bc0             or ax, ax
  032087  2597: 740b             je 0x25a4
  032089  2599: c746fe0100       mov word ptr [bp - 2], 1
  03208E  259E: 8b46fe           mov ax, word ptr [bp - 2]
  032091  25A1: c9               leave 
  032092  25A2: cb               retf 
  032093  25A3: 90               nop 
  032094  25A4: 6a33             push 0x33
  032096  25A6: 6a46             push 0x46
  032098  25A8: 6a76             push 0x76
  03209A  25AA: 6a48             push 0x48
  03209C  25AC: 9aca031f18       lcall 0x181f, 0x3ca
  0320A1  25B1: 83c408           add sp, 8
  0320A4  25B4: 0bc0             or ax, ax
  0320A6  25B6: 740a             je 0x25c2
  0320A8  25B8: c746fe0200       mov word ptr [bp - 2], 2
  0320AD  25BD: 8b46fe           mov ax, word ptr [bp - 2]
  0320B0  25C0: c9               leave 
  0320B1  25C1: cb               retf 
  0320B2  25C2: 6a33             push 0x33
  0320B4  25C4: 6a46             push 0x46
  0320B6  25C6: 6a76             push 0x76
  0320B8  25C8: 6a01             push 1
  0320BA  25CA: 9aca031f18       lcall 0x181f, 0x3ca
  0320BF  25CF: 83c408           add sp, 8
  0320C2  25D2: 0bc0             or ax, ax
  0320C4  25D4: 7408             je 0x25de
  0320C6  25D6: c746fe0300       mov word ptr [bp - 2], 3
  0320CB  25DB: eb1b             jmp 0x25f8
  0320CD  25DD: 90               nop 
  0320CE  25DE: 6a3b             push 0x3b
  0320D0  25E0: 6a60             push 0x60
  0320D2  25E2: 6a78             push 0x78
  0320D4  25E4: 68e000           push 0xe0
  0320D7  25E7: 9aca031f18       lcall 0x181f, 0x3ca
  0320DC  25EC: 83c408           add sp, 8
  0320DF  25EF: 0bc0             or ax, ax
  0320E1  25F1: 7405             je 0x25f8
  0320E3  25F3: c746fe0400       mov word ptr [bp - 2], 4
  0320E8  25F8: 8b46fe           mov ax, word ptr [bp - 2]
  0320EB  25FB: c9               leave 
  0320EC  25FC: cb               retf 

; ---- func_0320EE  size=51  insns=16  prologue=ENTER 0x0002,0  terminal=RETF ----
  0320EE  25FE: c8020000         enter 2, 0
  0320F2  2602: ff364008         push word ptr [0x840]
  0320F6  2606: ff363e08         push word ptr [0x83e]
  0320FA  260A: 837e0864         cmp word ptr [bp + 8], 0x64
  0320FE  260E: 7c06             jl 0x2616
  032100  2610: b81700           mov ax, 0x17
  032103  2613: eb04             jmp 0x2619
  032105  2615: 90               nop 
  032106  2616: b82700           mov ax, 0x27
  032109  2619: 034606           add ax, word ptr [bp + 6]
  03210C  261C: 2bd2             sub dx, dx
  03210E  261E: 9af8081f19       lcall 0x191f, 0x8f8
  032113  2623: c7063e9e0100     mov word ptr [0x9e3e], 1
  032119  2629: c7063a9e0a00     mov word ptr [0x9e3a], 0xa
  03211F  262F: c9               leave 
  032120  2630: cb               retf 

; ---- func_032122  size=146  insns=56  prologue=push bp;mov bp,sp  terminal=RETF ----
  032122  2632: 55               push bp
  032123  2633: 8bec             mov bp, sp
  032125  2635: 6a01             push 1
  032127  2637: 9a56001f18       lcall 0x181f, 0x56
  03212C  263C: 8be5             mov sp, bp
  03212E  263E: ff36129e         push word ptr [0x9e12]
  032132  2642: 9aa4091f18       lcall 0x181f, 0x9a4
  032137  2647: 8be5             mov sp, bp
  032139  2649: 50               push ax
  03213A  264A: 9a74001f18       lcall 0x181f, 0x74
  03213F  264F: 8be5             mov sp, bp
  032141  2651: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  032145  2655: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  032149  2659: 2aff             sub bh, bh
  03214B  265B: 8bc3             mov ax, bx
  03214D  265D: d1e3             shl bx, 1
  03214F  265F: 03d8             add bx, ax
  032151  2661: d1e3             shl bx, 1
  032153  2663: 03d8             add bx, ax
  032155  2665: d1e3             shl bx, 1
  032157  2667: ffb73052         push word ptr [bx + 0x5230]
  03215B  266B: 9a74001f18       lcall 0x181f, 0x74
  032160  2670: 8be5             mov sp, bp
  032162  2672: 8b5e08           mov bx, word ptr [bp + 8]
  032165  2675: d1e3             shl bx, 1
  032167  2677: ffb7ba2d         push word ptr [bx + 0x2dba]
  03216B  267B: 9a74001f18       lcall 0x181f, 0x74
  032170  2680: 8be5             mov sp, bp
  032172  2682: 8b4608           mov ax, word ptr [bp + 8]
  032175  2685: eb27             jmp 0x26ae
  032177  2687: 90               nop 
  032178  2688: 6b06129e34       imul ax, word ptr [0x9e12], 0x34
  03217D  268D: 052654           add ax, 0x5426
  032180  2690: 1e               push ds
  032181  2691: 50               push ax
  032182  2692: 9a6a001f18       lcall 0x181f, 0x6a
  032187  2697: 8be5             mov sp, bp
  032189  2699: eb1d             jmp 0x26b8
  03218B  269B: 90               nop 
  03218C  269C: 8b1e129e         mov bx, word ptr [0x9e12]
  032190  26A0: d1e3             shl bx, 1
  032192  26A2: ffb78c83         push word ptr [bx - 0x7c74]
  032196  26A6: 9a74001f18       lcall 0x181f, 0x74
  03219B  26AB: ebea             jmp 0x2697
  03219D  26AD: 90               nop 
  03219E  26AE: 2d0a00           sub ax, 0xa
  0321A1  26B1: 74d5             je 0x2688
  0321A3  26B3: 2d1000           sub ax, 0x10
  0321A6  26B6: 74e4             je 0x269c
  0321A8  26B8: 6a00             push 0
  0321AA  26BA: 6a00             push 0
  0321AC  26BC: 6a01             push 1
  0321AE  26BE: 0e               push cs
  0321AF  26BF: e88e46           call 0x6d50
  0321B2  26C2: c9               leave 
  0321B3  26C3: cb               retf 

; ---- func_0321B4  size=72  insns=24  prologue=ENTER 0x0002,0  terminal=RETF ----
  0321B4  26C4: c8020000         enter 2, 0
  0321B8  26C8: ff364008         push word ptr [0x840]
  0321BC  26CC: ff363e08         push word ptr [0x83e]
  0321C0  26D0: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0321C4  26D4: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0321C8  26D8: 2aff             sub bh, bh
  0321CA  26DA: 8bc3             mov ax, bx
  0321CC  26DC: d1e3             shl bx, 1
  0321CE  26DE: 03d8             add bx, ax
  0321D0  26E0: d1e3             shl bx, 1
  0321D2  26E2: 03d8             add bx, ax
  0321D4  26E4: d1e3             shl bx, 1
  0321D6  26E6: 8a873252         mov al, byte ptr [bx + 0x5232]
  0321DA  26EA: 2ae4             sub ah, ah
  0321DC  26EC: ba0100           mov dx, 1
  0321DF  26EF: 9af8081f19       lcall 0x191f, 0x8f8
  0321E4  26F4: c7063e9e0100     mov word ptr [0x9e3e], 1
  0321EA  26FA: c7063a9e0800     mov word ptr [0x9e3a], 8
  0321F0  2700: ff7608           push word ptr [bp + 8]
  0321F3  2703: ff7606           push word ptr [bp + 6]
  0321F6  2706: 0e               push cs
  0321F7  2707: e81d47           call 0x6e27
  0321FA  270A: c9               leave 
  0321FB  270B: cb               retf 

; ---- func_0321FC  size=102  insns=32  prologue=ENTER 0x0002,0  terminal=RETF ----
  0321FC  270C: c8020000         enter 2, 0
  032200  2710: ff364008         push word ptr [0x840]
  032204  2714: ff363e08         push word ptr [0x83e]
  032208  2718: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03220C  271C: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  032210  2720: 2aff             sub bh, bh
  032212  2722: 8bc3             mov ax, bx
  032214  2724: d1e3             shl bx, 1
  032216  2726: 03d8             add bx, ax
  032218  2728: d1e3             shl bx, 1
  03221A  272A: 03d8             add bx, ax
  03221C  272C: d1e3             shl bx, 1
  03221E  272E: 8a873252         mov al, byte ptr [bx + 0x5232]
  032222  2732: 2ae4             sub ah, ah
  032224  2734: ba0100           mov dx, 1
  032227  2737: 9af8081f19       lcall 0x191f, 0x8f8
  03222C  273C: c7063e9e0100     mov word ptr [0x9e3e], 1
  032232  2742: c7063a9e0900     mov word ptr [0x9e3a], 9
  032238  2748: ff7608           push word ptr [bp + 8]
  03223B  274B: ff7606           push word ptr [bp + 6]
  03223E  274E: 0e               push cs
  03223F  274F: e8d546           call 0x6e27
  032242  2752: c9               leave 
  032243  2753: cb               retf 
  032244  2754: 833e3e9e00       cmp word ptr [0x9e3e], 0
  032249  2759: 7416             je 0x2771
  03224B  275B: ff363c08         push word ptr [0x83c]
  03224F  275F: ff363a08         push word ptr [0x83a]
  032253  2763: b80100           mov ax, 1
  032256  2766: 9a68041f19       lcall 0x191f, 0x468
  03225B  276B: c7063e9e0000     mov word ptr [0x9e3e], 0
  032261  2771: cb               retf 

; ---- func_032262  size=22  insns=10  prologue=ENTER 0x0002,0  terminal=RETF ----
  032262  2772: c8020000         enter 2, 0
  032266  2776: 56               push si
  032267  2777: 8b1efc84         mov bx, word ptr [0x84fc]
  03226B  277B: 8b7606           mov si, word ptr [bp + 6]
  03226E  277E: 8a404c           mov al, byte ptr [bx + si + 0x4c]
  032271  2781: 40               inc ax
  032272  2782: 88404c           mov byte ptr [bx + si + 0x4c], al
  032275  2785: 5e               pop si
  032276  2786: c9               leave 
  032277  2787: cb               retf 

; ---- func_032278  size=27  insns=13  prologue=ENTER 0x0002,0  terminal=RETF ----
  032278  2788: c8020000         enter 2, 0
  03227C  278C: 56               push si
  03227D  278D: 8b1efc84         mov bx, word ptr [0x84fc]
  032281  2791: 8b7606           mov si, word ptr [bp + 6]
  032284  2794: 8a404c           mov al, byte ptr [bx + si + 0x4c]
  032287  2797: 98               cwde 
  032288  2798: 48               dec ax
  032289  2799: 7902             jns 0x279d
  03228B  279B: 2bc0             sub ax, ax
  03228D  279D: 88404c           mov byte ptr [bx + si + 0x4c], al
  032290  27A0: 5e               pop si
  032291  27A1: c9               leave 
  032292  27A2: cb               retf 

; ---- func_032294  size=59  insns=22  prologue=ENTER 0x0002,0  terminal=RET ----
  032294  27A4: c8020000         enter 2, 0
  032298  27A8: 50               push ax
  032299  27A9: 833e129e04       cmp word ptr [0x9e12], 4
  03229E  27AE: 7d18             jge 0x27c8
  0322A0  27B0: 6b1e129e34       imul bx, word ptr [0x9e12], 0x34
  0322A5  27B5: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  0322AA  27BA: 750c             jne 0x27c8
  0322AC  27BC: a0a653           mov al, byte ptr [0x53a6]
  0322AF  27BF: 2ae4             sub ah, ah
  0322B1  27C1: 48               dec ax
  0322B2  27C2: 48               dec ax
  0322B3  27C3: 8946fe           mov word ptr [bp - 2], ax
  0322B6  27C6: eb05             jmp 0x27cd
  0322B8  27C8: c746fefeff       mov word ptr [bp - 2], 0xfffe
  0322BD  27CD: c166fe04         shl word ptr [bp - 2], 4
  0322C1  27D1: 8b46fe           mov ax, word ptr [bp - 2]
  0322C4  27D4: f76efc           imul word ptr [bp - 4]
  0322C7  27D7: b96400           mov cx, 0x64
  0322CA  27DA: 99               cdq 
  0322CB  27DB: f7f9             idiv cx
  0322CD  27DD: c9               leave 
  0322CE  27DE: c3               ret 

; ---- func_0322D0  size=121  insns=43  prologue=ENTER 0x0006,0  terminal=RETF ----
  0322D0  27E0: c8060000         enter 6, 0
  0322D4  27E4: 56               push si
  0322D5  27E5: c746fc0000       mov word ptr [bp - 4], 0
  0322DA  27EA: 8b4608           mov ax, word ptr [bp + 8]
  0322DD  27ED: e8b4ff           call 0x27a4
  0322E0  27F0: 8b5e06           mov bx, word ptr [bp + 6]
  0322E3  27F3: 8bcb             mov cx, bx
  0322E5  27F5: c1e303           shl bx, 3
  0322E8  27F8: 03d9             add bx, cx
  0322EA  27FA: 8a8f0497         mov cl, byte ptr [bx - 0x68fc]
  0322EE  27FE: 8b5608           mov dx, word ptr [bp + 8]
  0322F1  2801: d3e2             shl dx, cl
  0322F3  2803: 03c2             add ax, dx
  0322F5  2805: 695efc9e00       imul bx, word ptr [bp - 4], 0x9e
  0322FA  280A: 035e06           add bx, word ptr [bp + 6]
  0322FD  280D: d1e3             shl bx, 1
  0322FF  280F: 29876488         sub word ptr [bx - 0x779c], ax
  032303  2813: ff46fc           inc word ptr [bp - 4]
  032306  2816: 837efc04         cmp word ptr [bp - 4], 4
  03230A  281A: 7cce             jl 0x27ea
  03230C  281C: 8b4608           mov ax, word ptr [bp + 8]
  03230F  281F: 99               cdq 
  032310  2820: 8b5e06           mov bx, word ptr [bp + 6]
  032313  2823: c1e302           shl bx, 2
  032316  2826: 8bcb             mov cx, bx
  032318  2828: 031efc84         add bx, word ptr [0x84fc]
  03231C  282C: 2987bc00         sub word ptr [bx + 0xbc], ax
  032320  2830: 1997be00         sbb word ptr [bx + 0xbe], dx
  032324  2834: 2987fc00         sub word ptr [bx + 0xfc], ax
  032328  2838: 1997fe00         sbb word ptr [bx + 0xfe], dx
  03232C  283C: ff7606           push word ptr [bp + 6]
  03232F  283F: 8bf1             mov si, cx
  032331  2841: 0e               push cs
  032332  2842: e85b45           call 0x6da0
  032335  2845: 83c402           add sp, 2
  032338  2848: f76e08           imul word ptr [bp + 8]
  03233B  284B: 99               cdq 
  03233C  284C: 8b1efc84         mov bx, word ptr [0x84fc]
  032340  2850: 29407c           sub word ptr [bx + si + 0x7c], ax
  032343  2853: 19507e           sbb word ptr [bx + si + 0x7e], dx
  032346  2856: 5e               pop si
  032347  2857: c9               leave 
  032348  2858: cb               retf 

; ---- func_03234A  size=194  insns=78  prologue=ENTER 0x0010,0  terminal=RETF ----
  03234A  285A: c8100000         enter 0x10, 0
  03234E  285E: 57               push di
  03234F  285F: 56               push si
  032350  2860: 8b4608           mov ax, word ptr [bp + 8]
  032353  2863: e83eff           call 0x27a4
  032356  2866: 8b5e06           mov bx, word ptr [bp + 6]
  032359  2869: 8bcb             mov cx, bx
  03235B  286B: c1e303           shl bx, 3
  03235E  286E: 03d9             add bx, cx
  032360  2870: 8a8f0497         mov cl, byte ptr [bx - 0x68fc]
  032364  2874: 8b5608           mov dx, word ptr [bp + 8]
  032367  2877: d3e2             shl dx, cl
  032369  2879: 03d0             add dx, ax
  03236B  287B: 8956f4           mov word ptr [bp - 0xc], dx
  03236E  287E: c746f80000       mov word ptr [bp - 8], 0
  032373  2883: eb15             jmp 0x289a
  032375  2885: 90               nop 
  032376  2886: 8b46f4           mov ax, word ptr [bp - 0xc]
  032379  2889: 695ef89e00       imul bx, word ptr [bp - 8], 0x9e
  03237E  288E: 035e06           add bx, word ptr [bp + 6]
  032381  2891: d1e3             shl bx, 1
  032383  2893: 01876488         add word ptr [bx - 0x779c], ax
  032387  2897: ff46f8           inc word ptr [bp - 8]
  03238A  289A: 837ef804         cmp word ptr [bp - 8], 4
  03238E  289E: 7d14             jge 0x28b4
  032390  28A0: 837ef803         cmp word ptr [bp - 8], 3
  032394  28A4: 75e0             jne 0x2886
  032396  28A6: 8b46f4           mov ax, word ptr [bp - 0xc]
  032399  28A9: d1e0             shl ax, 1
  03239B  28AB: b90300           mov cx, 3
  03239E  28AE: 99               cdq 
  03239F  28AF: f7f9             idiv cx
  0323A1  28B1: ebd6             jmp 0x2889
  0323A3  28B3: 90               nop 
  0323A4  28B4: 8b4608           mov ax, word ptr [bp + 8]
  0323A7  28B7: 99               cdq 
  0323A8  28B8: 8b5e06           mov bx, word ptr [bp + 6]
  0323AB  28BB: c1e302           shl bx, 2
  0323AE  28BE: 8bcb             mov cx, bx
  0323B0  28C0: 031efc84         add bx, word ptr [0x84fc]
  0323B4  28C4: 0187bc00         add word ptr [bx + 0xbc], ax
  0323B8  28C8: 1197be00         adc word ptr [bx + 0xbe], dx
  0323BC  28CC: 0187fc00         add word ptr [bx + 0xfc], ax
  0323C0  28D0: 1197fe00         adc word ptr [bx + 0xfe], dx
  0323C4  28D4: ff7606           push word ptr [bp + 6]
  0323C7  28D7: 8bf1             mov si, cx
  0323C9  28D9: 0e               push cs
  0323CA  28DA: e84644           call 0x6d23
  0323CD  28DD: 83c402           add sp, 2
  0323D0  28E0: f76e08           imul word ptr [bp + 8]
  0323D3  28E3: 6a00             push 0
  0323D5  28E5: 6a64             push 0x64
  0323D7  28E7: 8b1efc84         mov bx, word ptr [0x84fc]
  0323DB  28EB: 8bc8             mov cx, ax
  0323DD  28ED: 8a4701           mov al, byte ptr [bx + 1]
  0323E0  28F0: 98               cwde 
  0323E1  28F1: 99               cdq 
  0323E2  28F2: bf6400           mov di, 0x64
  0323E5  28F5: 2bdb             sub bx, bx
  0323E7  28F7: 2bf8             sub di, ax
  0323E9  28F9: 1bda             sbb bx, dx
  0323EB  28FB: 53               push bx
  0323EC  28FC: 57               push di
  0323ED  28FD: 8bc1             mov ax, cx
  0323EF  28FF: 99               cdq 
  0323F0  2900: 52               push dx
  0323F1  2901: 50               push ax
  0323F2  2902: 9a600f1d0d       lcall 0xd1d, 0xf60
  0323F7  2907: 52               push dx
  0323F8  2908: 50               push ax
  0323F9  2909: 9ac60e1d0d       lcall 0xd1d, 0xec6
  0323FE  290E: 8b1efc84         mov bx, word ptr [0x84fc]
  032402  2912: 01407c           add word ptr [bx + si + 0x7c], ax
  032405  2915: 11507e           adc word ptr [bx + si + 0x7e], dx
  032408  2918: 5e               pop si
  032409  2919: 5f               pop di
  03240A  291A: c9               leave 
  03240B  291B: cb               retf 

; ---- func_03240C  size=80  insns=30  prologue=ENTER 0x0004,0  terminal=RETF ----
  03240C  291C: c8040000         enter 4, 0
  032410  2920: ff7608           push word ptr [bp + 8]
  032413  2923: 0e               push cs
  032414  2924: e87944           call 0x6da0
  032417  2927: 83c402           add sp, 2
  03241A  292A: 8b4e0a           mov cx, word ptr [bp + 0xa]
  03241D  292D: 83f964           cmp cx, 0x64
  032420  2930: 7e03             jle 0x2935
  032422  2932: b96400           mov cx, 0x64
  032425  2935: 894efc           mov word ptr [bp - 4], cx
  032428  2938: f7e9             imul cx
  03242A  293A: 8946fe           mov word ptr [bp - 2], ax
  03242D  293D: 99               cdq 
  03242E  293E: 52               push dx
  03242F  293F: 50               push ax
  032430  2940: ff36129e         push word ptr [0x9e12]
  032434  2944: 9af60a1f18       lcall 0x181f, 0xaf6
  032439  2949: 83c406           add sp, 6
  03243C  294C: ff76fc           push word ptr [bp - 4]
  03243F  294F: ff7608           push word ptr [bp + 8]
  032442  2952: 0e               push cs
  032443  2953: e83b44           call 0x6d91
  032446  2956: 83c404           add sp, 4
  032449  2959: ff76fc           push word ptr [bp - 4]
  03244C  295C: ff7608           push word ptr [bp + 8]
  03244F  295F: ff7606           push word ptr [bp + 6]
  032452  2962: 9a580d1f18       lcall 0x181f, 0xd58
  032457  2967: 8b46fe           mov ax, word ptr [bp - 2]
  03245A  296A: c9               leave 
  03245B  296B: cb               retf 

; ---- func_03245C  size=150  insns=57  prologue=ENTER 0x0006,0  terminal=RETF ----
  03245C  296C: c8060000         enter 6, 0
  032460  2970: ff7608           push word ptr [bp + 8]
  032463  2973: ff7606           push word ptr [bp + 6]
  032466  2976: 9aec0a1f18       lcall 0x181f, 0xaec
  03246B  297B: 83c404           add sp, 4
  03246E  297E: 8946fa           mov word ptr [bp - 6], ax
  032471  2981: 0bc0             or ax, ax
  032473  2983: 7c3c             jl 0x29c1
  032475  2985: a1c48d           mov ax, word ptr [0x8dc4]
  032478  2988: 3b460a           cmp ax, word ptr [bp + 0xa]
  03247B  298B: 7e18             jle 0x29a5
  03247D  298D: 2b460a           sub ax, word ptr [bp + 0xa]
  032480  2990: 50               push ax
  032481  2991: ff76fa           push word ptr [bp - 6]
  032484  2994: ff7606           push word ptr [bp + 6]
  032487  2997: 9a580d1f18       lcall 0x181f, 0xd58
  03248C  299C: 83c406           add sp, 6
  03248F  299F: 8b460a           mov ax, word ptr [bp + 0xa]
  032492  29A2: a3c48d           mov word ptr [0x8dc4], ax
  032495  29A5: ff76fa           push word ptr [bp - 6]
  032498  29A8: 0e               push cs
  032499  29A9: e87743           call 0x6d23
  03249C  29AC: 83c402           add sp, 2
  03249F  29AF: f72ec48d         imul word ptr [0x8dc4]
  0324A3  29B3: 8946fe           mov word ptr [bp - 2], ax
  0324A6  29B6: ff36c48d         push word ptr [0x8dc4]
  0324AA  29BA: ff76fa           push word ptr [bp - 6]
  0324AD  29BD: 0e               push cs
  0324AE  29BE: e86743           call 0x6d28
  0324B1  29C1: 8b46fe           mov ax, word ptr [bp - 2]
  0324B4  29C4: c9               leave 
  0324B5  29C5: cb               retf 
  0324B6  29C6: 6a50             push 0x50
  0324B8  29C8: 684001           push 0x140
  0324BB  29CB: 6a08             push 8
  0324BD  29CD: 6a00             push 0
  0324BF  29CF: 0e               push cs
  0324C0  29D0: e80944           call 0x6ddc
  0324C3  29D3: 83c408           add sp, 8
  0324C6  29D6: c706c80f0c00     mov word ptr [0xfc8], 0xc
  0324CC  29DC: cb               retf 
  0324CD  29DD: 90               nop 
  0324CE  29DE: c41e8a26         les bx, ptr [0x268a]
  0324D2  29E2: 268a07           mov al, byte ptr es:[bx]
  0324D5  29E5: 2ae4             sub ah, ah
  0324D7  29E7: 40               inc ax
  0324D8  29E8: 40               inc ax
  0324D9  29E9: 0106c80f         add word ptr [0xfc8], ax
  0324DD  29ED: cb               retf 
  0324DE  29EE: 6a08             push 8
  0324E0  29F0: 684001           push 0x140
  0324E3  29F3: 6a50             push 0x50
  0324E5  29F5: 2bc0             sub ax, ax
  0324E7  29F7: ba0800           mov dx, 8
  0324EA  29FA: 2bdb             sub bx, bx
  0324EC  29FC: 9ae2001f18       lcall 0x181f, 0xe2
  0324F1  2A01: cb               retf 

; ---- func_0324F2  size=1057  insns=384  prologue=ENTER 0x0058,0  terminal=RETF ----
  0324F2  2A02: c8580000         enter 0x58, 0
  0324F6  2A06: 56               push si
  0324F7  2A07: c746aa0100       mov word ptr [bp - 0x56], 1
  0324FC  2A0C: 833e920800       cmp word ptr [0x892], 0
  032501  2A11: 745f             je 0x2a72
  032503  2A13: 833ea20f00       cmp word ptr [0xfa2], 0
  032508  2A18: 7558             jne 0x2a72
  03250A  2A1A: 6a01             push 1
  03250C  2A1C: 9a56001f18       lcall 0x181f, 0x56
  032511  2A21: 83c402           add sp, 2
  032514  2A24: 6a05             push 5
  032516  2A26: 0e               push cs
  032517  2A27: e83a43           call 0x6d64
  03251A  2A2A: 83c402           add sp, 2
  03251D  2A2D: 8b5e08           mov bx, word ptr [bp + 8]
  032520  2A30: d1e3             shl bx, 1
  032522  2A32: ffb7c097         push word ptr [bx - 0x6840]
  032526  2A36: 9a74001f18       lcall 0x181f, 0x74
  03252B  2A3B: 83c402           add sp, 2
  03252E  2A3E: 9a88001f18       lcall 0x181f, 0x88
  032533  2A43: 1e               push ds
  032534  2A44: 68ca0f           push 0xfca
  032537  2A47: 9a6a001f18       lcall 0x181f, 0x6a
  03253C  2A4C: 83c404           add sp, 4
  03253F  2A4F: 833eee0701       cmp word ptr [0x7ee], 1
  032544  2A54: 1bc0             sbb ax, ax
  032546  2A56: 257800           and ax, 0x78
  032549  2A59: 99               cdq 
  03254A  2A5A: 52               push dx
  03254B  2A5B: 50               push ax
  03254C  2A5C: 6a03             push 3
  03254E  2A5E: 0e               push cs
  03254F  2A5F: e8ee42           call 0x6d50
  032552  2A62: 83c406           add sp, 6
  032555  2A65: c7063a9e0f00     mov word ptr [0x9e3a], 0xf
  03255B  2A6B: 8b46aa           mov ax, word ptr [bp - 0x56]
  03255E  2A6E: 5e               pop si
  03255F  2A6F: c9               leave 
  032560  2A70: cb               retf 
  032561  2A71: 90               nop 
  032562  2A72: 837e0a00         cmp word ptr [bp + 0xa], 0
  032566  2A76: 7503             jne 0x2a7b
  032568  2A78: e99d03           jmp 0x2e18
  03256B  2A7B: 8d46ae           lea ax, [bp - 0x52]
  03256E  2A7E: 50               push ax
  03256F  2A7F: ff7608           push word ptr [bp + 8]
  032572  2A82: ff7606           push word ptr [bp + 6]
  032575  2A85: 9a960b1f18       lcall 0x181f, 0xb96
  03257A  2A8A: 83c406           add sp, 6
  03257D  2A8D: 0bc0             or ax, ax
  03257F  2A8F: 7549             jne 0x2ada
  032581  2A91: 6a01             push 1
  032583  2A93: 9a56001f18       lcall 0x181f, 0x56
  032588  2A98: 83c402           add sp, 2
  03258B  2A9B: 6a04             push 4
  03258D  2A9D: 0e               push cs
  03258E  2A9E: e8c342           call 0x6d64
  032591  2AA1: 83c402           add sp, 2
  032594  2AA4: 8b5e08           mov bx, word ptr [bp + 8]
  032597  2AA7: d1e3             shl bx, 1
  032599  2AA9: ffb7c097         push word ptr [bx - 0x6840]
  03259D  2AAD: 9a74001f18       lcall 0x181f, 0x74
  0325A2  2AB2: 83c402           add sp, 2
  0325A5  2AB5: 9a88001f18       lcall 0x181f, 0x88
  0325AA  2ABA: 1e               push ds
  0325AB  2ABB: 68cc0f           push 0xfcc
  0325AE  2ABE: 9a6a001f18       lcall 0x181f, 0x6a
  0325B3  2AC3: 83c404           add sp, 4
  0325B6  2AC6: 6a00             push 0
  0325B8  2AC8: 6a78             push 0x78
  0325BA  2ACA: 6a03             push 3
  0325BC  2ACC: 0e               push cs
  0325BD  2ACD: e88042           call 0x6d50
  0325C0  2AD0: 83c406           add sp, 6
  0325C3  2AD3: 8b46aa           mov ax, word ptr [bp - 0x56]
  0325C6  2AD6: 5e               pop si
  0325C7  2AD7: c9               leave 
  0325C8  2AD8: cb               retf 
  0325C9  2AD9: 90               nop 
  0325CA  2ADA: 8b46ae           mov ax, word ptr [bp - 0x52]
  0325CD  2ADD: 3d6400           cmp ax, 0x64
  0325D0  2AE0: 7e03             jle 0x2ae5
  0325D2  2AE2: b86400           mov ax, 0x64
  0325D5  2AE5: 8946ae           mov word ptr [bp - 0x52], ax
  0325D8  2AE8: 837e0c00         cmp word ptr [bp + 0xc], 0
  0325DC  2AEC: 7503             jne 0x2af1
  0325DE  2AEE: e99a00           jmp 0x2b8b
  0325E1  2AF1: 8b5e08           mov bx, word ptr [bp + 8]
  0325E4  2AF4: d1e3             shl bx, 1
  0325E6  2AF6: ffb7c097         push word ptr [bx - 0x6840]
  0325EA  2AFA: 6a00             push 0
  0325EC  2AFC: 9a38041f18       lcall 0x181f, 0x438
  0325F1  2B01: 83c404           add sp, 4
  0325F4  2B04: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0325F8  2B08: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0325FC  2B0C: 2aff             sub bh, bh
  0325FE  2B0E: 8bc3             mov ax, bx
  032600  2B10: d1e3             shl bx, 1
  032602  2B12: 03d8             add bx, ax
  032604  2B14: d1e3             shl bx, 1
  032606  2B16: 03d8             add bx, ax
  032608  2B18: d1e3             shl bx, 1
  03260A  2B1A: ffb73052         push word ptr [bx + 0x5230]
  03260E  2B1E: 6a01             push 1
  032610  2B20: 9a38041f18       lcall 0x181f, 0x438
  032615  2B25: 83c404           add sp, 4
  032618  2B28: 8b46ae           mov ax, word ptr [bp - 0x52]
  03261B  2B2B: 99               cdq 
  03261C  2B2C: 52               push dx
  03261D  2B2D: 50               push ax
  03261E  2B2E: 6a00             push 0
  032620  2B30: 9aae091f18       lcall 0x181f, 0x9ae
  032625  2B35: 83c406           add sp, 6
  032628  2B38: ff7608           push word ptr [bp + 8]
  03262B  2B3B: 0e               push cs
  03262C  2B3C: e86142           call 0x6da0
  03262F  2B3F: 83c402           add sp, 2
  032632  2B42: 99               cdq 
  032633  2B43: 52               push dx
  032634  2B44: 50               push ax
  032635  2B45: 6a01             push 1
  032637  2B47: 9aae091f18       lcall 0x181f, 0x9ae
  03263C  2B4C: 83c406           add sp, 6
  03263F  2B4F: 8d1e7c08         lea bx, [0x87c]
  032643  2B53: 8d06ce0f         lea ax, [0xfce]
  032647  2B57: 8b56ae           mov dx, word ptr [bp - 0x52]
  03264A  2B5A: 9a36041f19       lcall 0x191f, 0x436
  03264F  2B5F: 0bc0             or ax, ax
  032651  2B61: 7403             je 0x2b66
  032653  2B63: e9b702           jmp 0x2e1d
  032656  2B66: ff76ae           push word ptr [bp - 0x52]
  032659  2B69: 50               push ax
  03265A  2B6A: ff36c89c         push word ptr [0x9cc8]
  03265E  2B6E: 9a5c031f18       lcall 0x181f, 0x35c
  032663  2B73: 83c406           add sp, 6
  032666  2B76: 8946a8           mov word ptr [bp - 0x58], ax
  032669  2B79: 3b46ae           cmp ax, word ptr [bp - 0x52]
  03266C  2B7C: 7e03             jle 0x2b81
  03266E  2B7E: 8b46ae           mov ax, word ptr [bp - 0x52]
  032671  2B81: 8946ae           mov word ptr [bp - 0x52], ax
  032674  2B84: 0bc0             or ax, ax
  032676  2B86: 7f03             jg 0x2b8b
  032678  2B88: e99202           jmp 0x2e1d
  03267B  2B8B: ff7608           push word ptr [bp + 8]
  03267E  2B8E: 0e               push cs
  03267F  2B8F: e80e42           call 0x6da0
  032682  2B92: 83c402           add sp, 2
  032685  2B95: f76eae           imul word ptr [bp - 0x52]
  032688  2B98: 8946ac           mov word ptr [bp - 0x54], ax
  03268B  2B9B: ff36129e         push word ptr [0x9e12]
  03268F  2B9F: 9a920a1f18       lcall 0x181f, 0xa92
  032694  2BA4: 83c402           add sp, 2
  032697  2BA7: 8bc8             mov cx, ax
  032699  2BA9: 8b46ac           mov ax, word ptr [bp - 0x54]
  03269C  2BAC: 8bda             mov bx, dx
  03269E  2BAE: 99               cdq 
  03269F  2BAF: 3bda             cmp bx, dx
  0326A1  2BB1: 7e03             jle 0x2bb6
  0326A3  2BB3: e9ca00           jmp 0x2c80
  0326A6  2BB6: 7c07             jl 0x2bbf
  0326A8  2BB8: 3bc8             cmp cx, ax
  0326AA  2BBA: 7203             jb 0x2bbf
  0326AC  2BBC: e9c100           jmp 0x2c80
  0326AF  2BBF: 6a01             push 1
  0326B1  2BC1: 9a56001f18       lcall 0x181f, 0x56
  0326B6  2BC6: 83c402           add sp, 2
  0326B9  2BC9: 8b5e08           mov bx, word ptr [bp + 8]
  0326BC  2BCC: d1e3             shl bx, 1
  0326BE  2BCE: ffb7c097         push word ptr [bx - 0x6840]
  0326C2  2BD2: 8bf3             mov si, bx
  0326C4  2BD4: 9a74001f18       lcall 0x181f, 0x74
  0326C9  2BD9: 83c402           add sp, 2
  0326CC  2BDC: 1e               push ds
  0326CD  2BDD: 68d70f           push 0xfd7
  0326D0  2BE0: 9a6a001f18       lcall 0x181f, 0x6a
  0326D5  2BE5: 83c404           add sp, 4
  0326D8  2BE8: 9a88001f18       lcall 0x181f, 0x88
  0326DD  2BED: ff76ac           push word ptr [bp - 0x54]
  0326E0  2BF0: 9a7e001f18       lcall 0x181f, 0x7e
  0326E5  2BF5: 83c402           add sp, 2
  0326E8  2BF8: 9a88001f18       lcall 0x181f, 0x88
  0326ED  2BFD: 1e               push ds
  0326EE  2BFE: 68d90f           push 0xfd9
  0326F1  2C01: 9a6a001f18       lcall 0x181f, 0x6a
  0326F6  2C06: 83c404           add sp, 4
  0326F9  2C09: 6a08             push 8
  0326FB  2C0B: 0e               push cs
  0326FC  2C0C: e85541           call 0x6d64
  0326FF  2C0F: 83c402           add sp, 2
  032702  2C12: 833eee0701       cmp word ptr [0x7ee], 1
  032707  2C17: 1bc0             sbb ax, ax
  032709  2C19: 257800           and ax, 0x78
  03270C  2C1C: 99               cdq 
  03270D  2C1D: 52               push dx
  03270E  2C1E: 50               push ax
  03270F  2C1F: 6a03             push 3
  032711  2C21: 0e               push cs
  032712  2C22: e82b41           call 0x6d50
  032715  2C25: 83c406           add sp, 6
  032718  2C28: c7063a9e0f00     mov word ptr [0x9e3a], 0xf
  03271E  2C2E: 837e0c00         cmp word ptr [bp + 0xc], 0
  032722  2C32: 7403             je 0x2c37
  032724  2C34: e9e601           jmp 0x2e1d
  032727  2C37: ffb4c097         push word ptr [si - 0x6840]
  03272B  2C3B: 6a00             push 0
  03272D  2C3D: 9a38041f18       lcall 0x181f, 0x438
  032732  2C42: 83c404           add sp, 4
  032735  2C45: ff7608           push word ptr [bp + 8]
  032738  2C48: 0e               push cs
  032739  2C49: e85441           call 0x6da0
  03273C  2C4C: 83c402           add sp, 2
  03273F  2C4F: 99               cdq 
  032740  2C50: 52               push dx
  032741  2C51: 50               push ax
  032742  2C52: 6a00             push 0
  032744  2C54: 9aae091f18       lcall 0x181f, 0x9ae
  032749  2C59: 83c406           add sp, 6
  03274C  2C5C: 8b1efc84         mov bx, word ptr [0x84fc]
  032750  2C60: ff772c           push word ptr [bx + 0x2c]
  032753  2C63: ff772a           push word ptr [bx + 0x2a]
  032756  2C66: 6a01             push 1
  032758  2C68: 9aae091f18       lcall 0x181f, 0x9ae
  03275D  2C6D: 83c406           add sp, 6
  032760  2C70: 8d1edb0f         lea bx, [0xfdb]
  032764  2C74: 9afe031f18       lcall 0x181f, 0x3fe
  032769  2C79: 8b46aa           mov ax, word ptr [bp - 0x56]
  03276C  2C7C: 5e               pop si
  03276D  2C7D: c9               leave 
  03276E  2C7E: cb               retf 
  03276F  2C7F: 90               nop 
  032770  2C80: ff76ae           push word ptr [bp - 0x52]
  032773  2C83: ff7608           push word ptr [bp + 8]
  032776  2C86: ff7606           push word ptr [bp + 6]
  032779  2C89: 0e               push cs
  03277A  2C8A: e88b41           call 0x6e18
  03277D  2C8D: 83c406           add sp, 6
  032780  2C90: 8946ac           mov word ptr [bp - 0x54], ax
  032783  2C93: 6a01             push 1
  032785  2C95: 9a56001f18       lcall 0x181f, 0x56
  03278A  2C9A: 83c402           add sp, 2
  03278D  2C9D: 8b46ae           mov ax, word ptr [bp - 0x52]
  032790  2CA0: 3d6400           cmp ax, 0x64
  032793  2CA3: 7e03             jle 0x2ca8
  032795  2CA5: b86400           mov ax, 0x64
  032798  2CA8: 50               push ax
  032799  2CA9: 9a7e001f18       lcall 0x181f, 0x7e
  03279E  2CAE: 83c402           add sp, 2
  0327A1  2CB1: 8b5e08           mov bx, word ptr [bp + 8]
  0327A4  2CB4: d1e3             shl bx, 1
  0327A6  2CB6: ffb7c097         push word ptr [bx - 0x6840]
  0327AA  2CBA: 8bf3             mov si, bx
  0327AC  2CBC: 9a74001f18       lcall 0x181f, 0x74
  0327B1  2CC1: 83c402           add sp, 2
  0327B4  2CC4: 6a00             push 0
  0327B6  2CC6: 0e               push cs
  0327B7  2CC7: e89a40           call 0x6d64
  0327BA  2CCA: 83c402           add sp, 2
  0327BD  2CCD: ff76ac           push word ptr [bp - 0x54]
  0327C0  2CD0: 9a7e001f18       lcall 0x181f, 0x7e
  0327C5  2CD5: 83c402           add sp, 2
  0327C8  2CD8: 6a00             push 0
  0327CA  2CDA: 6a78             push 0x78
  0327CC  2CDC: 6a01             push 1
  0327CE  2CDE: 0e               push cs
  0327CF  2CDF: e86e40           call 0x6d50
  0327D2  2CE2: 83c406           add sp, 6
  0327D5  2CE5: 0e               push cs
  0327D6  2CE6: e87f41           call 0x6e68
  0327D9  2CE9: c646b000         mov byte ptr [bp - 0x50], 0
  0327DD  2CED: ff36ca2e         push word ptr [0x2eca]
  0327E1  2CF1: 8d46b0           lea ax, [bp - 0x50]
  0327E4  2CF4: 50               push ax
  0327E5  2CF5: 9a6e011f18       lcall 0x181f, 0x16e
  0327EA  2CFA: 83c404           add sp, 4
  0327ED  2CFD: 8d46b0           lea ax, [bp - 0x50]
  0327F0  2D00: 50               push ax
  0327F1  2D01: 9a78011f18       lcall 0x181f, 0x178
  0327F6  2D06: 83c402           add sp, 2
  0327F9  2D09: 8b46ae           mov ax, word ptr [bp - 0x52]
  0327FC  2D0C: 3d6400           cmp ax, 0x64
  0327FF  2D0F: 7e03             jle 0x2d14
  032801  2D11: b86400           mov ax, 0x64
  032804  2D14: 50               push ax
  032805  2D15: 8d46b0           lea ax, [bp - 0x50]
  032808  2D18: 16               push ss
  032809  2D19: 50               push ax
  03280A  2D1A: 9a82011f18       lcall 0x181f, 0x182
  03280F  2D1F: 83c406           add sp, 6
  032812  2D22: 8d46b0           lea ax, [bp - 0x50]
  032815  2D25: 50               push ax
  032816  2D26: 9a78011f18       lcall 0x181f, 0x178
  03281B  2D2B: 83c402           add sp, 2
  03281E  2D2E: ffb4c097         push word ptr [si - 0x6840]
  032822  2D32: 8d46b0           lea ax, [bp - 0x50]
  032825  2D35: 50               push ax
  032826  2D36: 9a6e011f18       lcall 0x181f, 0x16e
  03282B  2D3B: 83c404           add sp, 4
  03282E  2D3E: 8d46b0           lea ax, [bp - 0x50]
  032831  2D41: 50               push ax
  032832  2D42: 9a78011f18       lcall 0x181f, 0x178
  032837  2D47: 83c402           add sp, 2
  03283A  2D4A: ff36cc2e         push word ptr [0x2ecc]
  03283E  2D4E: 8d46b0           lea ax, [bp - 0x50]
  032841  2D51: 50               push ax
  032842  2D52: 9a6e011f18       lcall 0x181f, 0x16e
  032847  2D57: 83c404           add sp, 4
  03284A  2D5A: 8d46b0           lea ax, [bp - 0x50]
  03284D  2D5D: 50               push ax
  03284E  2D5E: 9a78011f18       lcall 0x181f, 0x178
  032853  2D63: 83c402           add sp, 2
  032856  2D66: ff7608           push word ptr [bp + 8]
  032859  2D69: 0e               push cs
  03285A  2D6A: e83340           call 0x6da0
  03285D  2D6D: 83c402           add sp, 2
  032860  2D70: 50               push ax
  032861  2D71: 8d46b0           lea ax, [bp - 0x50]
  032864  2D74: 16               push ss
  032865  2D75: 50               push ax
  032866  2D76: 9a82011f18       lcall 0x181f, 0x182
  03286B  2D7B: 83c406           add sp, 6
  03286E  2D7E: ff36ce2e         push word ptr [0x2ece]
  032872  2D82: 8d46b0           lea ax, [bp - 0x50]
  032875  2D85: 50               push ax
  032876  2D86: 9a6e011f18       lcall 0x181f, 0x16e
  03287B  2D8B: 83c404           add sp, 4
  03287E  2D8E: 6a36             push 0x36
  032880  2D90: 6a30             push 0x30
  032882  2D92: ff36c80f         push word ptr [0xfc8]
  032886  2D96: 684001           push 0x140
  032889  2D99: 6a00             push 0
  03288B  2D9B: 8d46b0           lea ax, [bp - 0x50]
  03288E  2D9E: 16               push ss
  03288F  2D9F: 50               push ax
  032890  2DA0: 9ac8011f18       lcall 0x181f, 0x1c8
  032895  2DA5: 83c40e           add sp, 0xe
  032898  2DA8: 0e               push cs
  032899  2DA9: e8c640           call 0x6e72
  03289C  2DAC: c646b000         mov byte ptr [bp - 0x50], 0
  0328A0  2DB0: ff36d02e         push word ptr [0x2ed0]
  0328A4  2DB4: 8d46b0           lea ax, [bp - 0x50]
  0328A7  2DB7: 50               push ax
  0328A8  2DB8: 9a6e011f18       lcall 0x181f, 0x16e
  0328AD  2DBD: 83c404           add sp, 4
  0328B0  2DC0: 8d46b0           lea ax, [bp - 0x50]
  0328B3  2DC3: 50               push ax
  0328B4  2DC4: 9abe011f18       lcall 0x181f, 0x1be
  0328B9  2DC9: 83c402           add sp, 2
  0328BC  2DCC: 8b46ac           mov ax, word ptr [bp - 0x54]
  0328BF  2DCF: 99               cdq 
  0328C0  2DD0: 52               push dx
  0328C1  2DD1: 50               push ax
  0328C2  2DD2: 8d46b0           lea ax, [bp - 0x50]
  0328C5  2DD5: 16               push ss
  0328C6  2DD6: 50               push ax
  0328C7  2DD7: 9ad8001f18       lcall 0x181f, 0xd8
  0328CC  2DDC: 83c408           add sp, 8
  0328CF  2DDF: 6a36             push 0x36
  0328D1  2DE1: 6a30             push 0x30
  0328D3  2DE3: ff36c80f         push word ptr [0xfc8]
  0328D7  2DE7: 684001           push 0x140
  0328DA  2DEA: 6a00             push 0
  0328DC  2DEC: 8d46b0           lea ax, [bp - 0x50]
  0328DF  2DEF: 16               push ss
  0328E0  2DF0: 50               push ax
  0328E1  2DF1: 9ac8011f18       lcall 0x181f, 0x1c8
  0328E6  2DF6: 83c40e           add sp, 0xe
  0328E9  2DF9: 0e               push cs
  0328EA  2DFA: e87540           call 0x6e72
  0328ED  2DFD: 0e               push cs
  0328EE  2DFE: e88040           call 0x6e81
  0328F1  2E01: 833e920800       cmp word ptr [0x892], 0
  0328F6  2E06: 7404             je 0x2e0c
  0328F8  2E08: 0e               push cs
  0328F9  2E09: e8303f           call 0x6d3c
  0328FC  2E0C: ff7608           push word ptr [bp + 8]
  0328FF  2E0F: 6a00             push 0
  032901  2E11: 0e               push cs
  032902  2E12: e8b83f           call 0x6dcd
  032905  2E15: 83c404           add sp, 4
  032908  2E18: c746aa0000       mov word ptr [bp - 0x56], 0
  03290D  2E1D: 8b46aa           mov ax, word ptr [bp - 0x56]
  032910  2E20: 5e               pop si
  032911  2E21: c9               leave 
  032912  2E22: cb               retf 

; ---- func_032914  size=1175  insns=423  prologue=ENTER 0x0064,0  terminal=RETF ----
  032914  2E24: c8640000         enter 0x64, 0
  032918  2E28: 57               push di
  032919  2E29: 56               push si
  03291A  2E2A: c746ac0100       mov word ptr [bp - 0x54], 1
  03291F  2E2F: c746aa6400       mov word ptr [bp - 0x56], 0x64
  032924  2E34: ff7608           push word ptr [bp + 8]
  032927  2E37: ff7606           push word ptr [bp + 6]
  03292A  2E3A: 9a2c0c1f18       lcall 0x181f, 0xc2c
  03292F  2E3F: 83c404           add sp, 4
  032932  2E42: 8946a8           mov word ptr [bp - 0x58], ax
  032935  2E45: 0bc0             or ax, ax
  032937  2E47: 7d47             jge 0x2e90
  032939  2E49: 833e920800       cmp word ptr [0x892], 0
  03293E  2E4E: 7503             jne 0x2e53
  032940  2E50: e96104           jmp 0x32b4
  032943  2E53: 6a01             push 1
  032945  2E55: 9a56001f18       lcall 0x181f, 0x56
  03294A  2E5A: 83c402           add sp, 2
  03294D  2E5D: 6a09             push 9
  03294F  2E5F: 0e               push cs
  032950  2E60: e8013f           call 0x6d64
  032953  2E63: 83c402           add sp, 2
  032956  2E66: 8b5e08           mov bx, word ptr [bp + 8]
  032959  2E69: d1e3             shl bx, 1
  03295B  2E6B: ffb7c097         push word ptr [bx - 0x6840]
  03295F  2E6F: 9a74001f18       lcall 0x181f, 0x74
  032964  2E74: 83c402           add sp, 2
  032967  2E77: 6a0a             push 0xa
  032969  2E79: 0e               push cs
  03296A  2E7A: e8e73e           call 0x6d64
  03296D  2E7D: 83c402           add sp, 2
  032970  2E80: 6a00             push 0
  032972  2E82: 6a78             push 0x78
  032974  2E84: 6a03             push 3
  032976  2E86: 0e               push cs
  032977  2E87: e8c63e           call 0x6d50
  03297A  2E8A: 83c406           add sp, 6
  03297D  2E8D: e92404           jmp 0x32b4
  032980  2E90: 837e0a00         cmp word ptr [bp + 0xa], 0
  032984  2E94: 7503             jne 0x2e99
  032986  2E96: e9ae00           jmp 0x2f47
  032989  2E99: 8b5e08           mov bx, word ptr [bp + 8]
  03298C  2E9C: d1e3             shl bx, 1
  03298E  2E9E: ffb7c097         push word ptr [bx - 0x6840]
  032992  2EA2: 6a00             push 0
  032994  2EA4: 9a38041f18       lcall 0x181f, 0x438
  032999  2EA9: 83c404           add sp, 4
  03299C  2EAC: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0329A0  2EB0: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0329A4  2EB4: 2aff             sub bh, bh
  0329A6  2EB6: 8bc3             mov ax, bx
  0329A8  2EB8: d1e3             shl bx, 1
  0329AA  2EBA: 03d8             add bx, ax
  0329AC  2EBC: d1e3             shl bx, 1
  0329AE  2EBE: 03d8             add bx, ax
  0329B0  2EC0: d1e3             shl bx, 1
  0329B2  2EC2: ffb73052         push word ptr [bx + 0x5230]
  0329B6  2EC6: 6a01             push 1
  0329B8  2EC8: 9a38041f18       lcall 0x181f, 0x438
  0329BD  2ECD: 83c404           add sp, 4
  0329C0  2ED0: 8b1e129e         mov bx, word ptr [0x9e12]
  0329C4  2ED4: d1e3             shl bx, 1
  0329C6  2ED6: ffb78c83         push word ptr [bx - 0x7c74]
  0329CA  2EDA: 6a02             push 2
  0329CC  2EDC: 9a38041f18       lcall 0x181f, 0x438
  0329D1  2EE1: 83c404           add sp, 4
  0329D4  2EE4: a1c48d           mov ax, word ptr [0x8dc4]
  0329D7  2EE7: 99               cdq 
  0329D8  2EE8: 52               push dx
  0329D9  2EE9: 50               push ax
  0329DA  2EEA: 6a00             push 0
  0329DC  2EEC: 9aae091f18       lcall 0x181f, 0x9ae
  0329E1  2EF1: 83c406           add sp, 6
  0329E4  2EF4: ff7608           push word ptr [bp + 8]
  0329E7  2EF7: 0e               push cs
  0329E8  2EF8: e8283e           call 0x6d23
  0329EB  2EFB: 83c402           add sp, 2
  0329EE  2EFE: 99               cdq 
  0329EF  2EFF: 52               push dx
  0329F0  2F00: 50               push ax
  0329F1  2F01: 6a01             push 1
  0329F3  2F03: 9aae091f18       lcall 0x181f, 0x9ae
  0329F8  2F08: 83c406           add sp, 6
  0329FB  2F0B: 8d1e7c08         lea bx, [0x87c]
  0329FF  2F0F: 8d06e60f         lea ax, [0xfe6]
  032A03  2F13: 8b56aa           mov dx, word ptr [bp - 0x56]
  032A06  2F16: 9a36041f19       lcall 0x191f, 0x436
  032A0B  2F1B: 0bc0             or ax, ax
  032A0D  2F1D: 7403             je 0x2f22
  032A0F  2F1F: e99203           jmp 0x32b4
  032A12  2F22: ff76aa           push word ptr [bp - 0x56]
  032A15  2F25: 50               push ax
  032A16  2F26: ff36c89c         push word ptr [0x9cc8]
  032A1A  2F2A: 9a5c031f18       lcall 0x181f, 0x35c
  032A1F  2F2F: 83c406           add sp, 6
  032A22  2F32: 8946a6           mov word ptr [bp - 0x5a], ax
  032A25  2F35: 3b46aa           cmp ax, word ptr [bp - 0x56]
  032A28  2F38: 7e03             jle 0x2f3d
  032A2A  2F3A: 8b46aa           mov ax, word ptr [bp - 0x56]
  032A2D  2F3D: 8946aa           mov word ptr [bp - 0x56], ax
  032A30  2F40: 0bc0             or ax, ax
  032A32  2F42: 7f03             jg 0x2f47
  032A34  2F44: e96d03           jmp 0x32b4
  032A37  2F47: ff76aa           push word ptr [bp - 0x56]
  032A3A  2F4A: ff76a8           push word ptr [bp - 0x58]
  032A3D  2F4D: ff7606           push word ptr [bp + 6]
  032A40  2F50: 0e               push cs
  032A41  2F51: e8d83e           call 0x6e2c
  032A44  2F54: 83c406           add sp, 6
  032A47  2F57: 8946ae           mov word ptr [bp - 0x52], ax
  032A4A  2F5A: 6a00             push 0
  032A4C  2F5C: 6a64             push 0x64
  032A4E  2F5E: 99               cdq 
  032A4F  2F5F: 52               push dx
  032A50  2F60: 50               push ax
  032A51  2F61: 8b1efc84         mov bx, word ptr [0x84fc]
  032A55  2F65: 8bc8             mov cx, ax
  032A57  2F67: 8a4701           mov al, byte ptr [bx + 1]
  032A5A  2F6A: 98               cwde 
  032A5B  2F6B: 8bda             mov bx, dx
  032A5D  2F6D: 99               cdq 
  032A5E  2F6E: 52               push dx
  032A5F  2F6F: 50               push ax
  032A60  2F70: 8bf1             mov si, cx
  032A62  2F72: 8bfb             mov di, bx
  032A64  2F74: 9a600f1d0d       lcall 0xd1d, 0xf60
  032A69  2F79: 52               push dx
  032A6A  2F7A: 50               push ax
  032A6B  2F7B: 9ac60e1d0d       lcall 0xd1d, 0xec6
  032A70  2F80: 8946a2           mov word ptr [bp - 0x5e], ax
  032A73  2F83: 2b46ae           sub ax, word ptr [bp - 0x52]
  032A76  2F86: f7d8             neg ax
  032A78  2F88: 8946a4           mov word ptr [bp - 0x5c], ax
  032A7B  2F8B: 99               cdq 
  032A7C  2F8C: 52               push dx
  032A7D  2F8D: 50               push ax
  032A7E  2F8E: ff36129e         push word ptr [0x9e12]
  032A82  2F92: 9aba0a1f18       lcall 0x181f, 0xaba
  032A87  2F97: 83c406           add sp, 6
  032A8A  2F9A: 8b46a2           mov ax, word ptr [bp - 0x5e]
  032A8D  2F9D: 99               cdq 
  032A8E  2F9E: 8b1efc84         mov bx, word ptr [0x84fc]
  032A92  2FA2: 014722           add word ptr [bx + 0x22], ax
  032A95  2FA5: 115724           adc word ptr [bx + 0x24], dx
  032A98  2FA8: 8b46a4           mov ax, word ptr [bp - 0x5c]
  032A9B  2FAB: 99               cdq 
  032A9C  2FAC: 014726           add word ptr [bx + 0x26], ax
  032A9F  2FAF: 115728           adc word ptr [bx + 0x28], dx
  032AA2  2FB2: 6a01             push 1
  032AA4  2FB4: 89469e           mov word ptr [bp - 0x62], ax
  032AA7  2FB7: 8956a0           mov word ptr [bp - 0x60], dx
  032AAA  2FBA: 9a56001f18       lcall 0x181f, 0x56
  032AAF  2FBF: 83c402           add sp, 2
  032AB2  2FC2: ff36c48d         push word ptr [0x8dc4]
  032AB6  2FC6: 9a7e001f18       lcall 0x181f, 0x7e
  032ABB  2FCB: 83c402           add sp, 2
  032ABE  2FCE: 8b5e08           mov bx, word ptr [bp + 8]
  032AC1  2FD1: d1e3             shl bx, 1
  032AC3  2FD3: ffb7c097         push word ptr [bx - 0x6840]
  032AC7  2FD7: 895e9c           mov word ptr [bp - 0x64], bx
  032ACA  2FDA: 9a74001f18       lcall 0x181f, 0x74
  032ACF  2FDF: 83c402           add sp, 2
  032AD2  2FE2: 6a01             push 1
  032AD4  2FE4: 0e               push cs
  032AD5  2FE5: e87c3d           call 0x6d64
  032AD8  2FE8: 83c402           add sp, 2
  032ADB  2FEB: ff76ae           push word ptr [bp - 0x52]
  032ADE  2FEE: 9a7e001f18       lcall 0x181f, 0x7e
  032AE3  2FF3: 83c402           add sp, 2
  032AE6  2FF6: 9a88001f18       lcall 0x181f, 0x88
  032AEB  2FFB: 1e               push ds
  032AEC  2FFC: 68ef0f           push 0xfef
  032AEF  2FFF: 9a6a001f18       lcall 0x181f, 0x6a
  032AF4  3004: 83c404           add sp, 4
  032AF7  3007: 8b1efc84         mov bx, word ptr [0x84fc]
  032AFB  300B: 8a4701           mov al, byte ptr [bx + 1]
  032AFE  300E: 98               cwde 
  032AFF  300F: 50               push ax
  032B00  3010: 9a7e001f18       lcall 0x181f, 0x7e
  032B05  3015: 83c402           add sp, 2
  032B08  3018: 9a88001f18       lcall 0x181f, 0x88
  032B0D  301D: 6a11             push 0x11
  032B0F  301F: 0e               push cs
  032B10  3020: e8413d           call 0x6d64
  032B13  3023: 83c402           add sp, 2
  032B16  3026: ff76a2           push word ptr [bp - 0x5e]
  032B19  3029: 9a7e001f18       lcall 0x181f, 0x7e
  032B1E  302E: 83c402           add sp, 2
  032B21  3031: 9a88001f18       lcall 0x181f, 0x88
  032B26  3036: 6a12             push 0x12
  032B28  3038: 0e               push cs
  032B29  3039: e8283d           call 0x6d64
  032B2C  303C: 83c402           add sp, 2
  032B2F  303F: ff76a4           push word ptr [bp - 0x5c]
  032B32  3042: 9a7e001f18       lcall 0x181f, 0x7e
  032B37  3047: 83c402           add sp, 2
  032B3A  304A: 6a00             push 0
  032B3C  304C: 6a78             push 0x78
  032B3E  304E: 6a01             push 1
  032B40  3050: 0e               push cs
  032B41  3051: e8fc3c           call 0x6d50
  032B44  3054: 83c406           add sp, 6
  032B47  3057: 0e               push cs
  032B48  3058: e80d3e           call 0x6e68
  032B4B  305B: c646b000         mov byte ptr [bp - 0x50], 0
  032B4F  305F: ff36c82e         push word ptr [0x2ec8]
  032B53  3063: 8d46b0           lea ax, [bp - 0x50]
  032B56  3066: 50               push ax
  032B57  3067: 9a6e011f18       lcall 0x181f, 0x16e
  032B5C  306C: 83c404           add sp, 4
  032B5F  306F: 8d46b0           lea ax, [bp - 0x50]
  032B62  3072: 50               push ax
  032B63  3073: 9a78011f18       lcall 0x181f, 0x178
  032B68  3078: 83c402           add sp, 2
  032B6B  307B: ff36c48d         push word ptr [0x8dc4]
  032B6F  307F: 8d46b0           lea ax, [bp - 0x50]
  032B72  3082: 16               push ss
  032B73  3083: 50               push ax
  032B74  3084: 9a82011f18       lcall 0x181f, 0x182
  032B79  3089: 83c406           add sp, 6
  032B7C  308C: 8d46b0           lea ax, [bp - 0x50]
  032B7F  308F: 50               push ax
  032B80  3090: 9a78011f18       lcall 0x181f, 0x178
  032B85  3095: 83c402           add sp, 2
  032B88  3098: 8b5e9c           mov bx, word ptr [bp - 0x64]
  032B8B  309B: ffb7c097         push word ptr [bx - 0x6840]
  032B8F  309F: 8d46b0           lea ax, [bp - 0x50]
  032B92  30A2: 50               push ax
  032B93  30A3: 9a6e011f18       lcall 0x181f, 0x16e
  032B98  30A8: 83c404           add sp, 4
  032B9B  30AB: 8d46b0           lea ax, [bp - 0x50]
  032B9E  30AE: 50               push ax
  032B9F  30AF: 9a78011f18       lcall 0x181f, 0x178
  032BA4  30B4: 83c402           add sp, 2
  032BA7  30B7: ff36cc2e         push word ptr [0x2ecc]
  032BAB  30BB: 8d46b0           lea ax, [bp - 0x50]
  032BAE  30BE: 50               push ax
  032BAF  30BF: 9a6e011f18       lcall 0x181f, 0x16e
  032BB4  30C4: 83c404           add sp, 4
  032BB7  30C7: 8d46b0           lea ax, [bp - 0x50]
  032BBA  30CA: 50               push ax
  032BBB  30CB: 9a78011f18       lcall 0x181f, 0x178
  032BC0  30D0: 83c402           add sp, 2
  032BC3  30D3: ff7608           push word ptr [bp + 8]
  032BC6  30D6: 0e               push cs
  032BC7  30D7: e8493c           call 0x6d23
  032BCA  30DA: 83c402           add sp, 2
  032BCD  30DD: 50               push ax
  032BCE  30DE: 8d46b0           lea ax, [bp - 0x50]
  032BD1  30E1: 16               push ss
  032BD2  30E2: 50               push ax
  032BD3  30E3: 9a82011f18       lcall 0x181f, 0x182
  032BD8  30E8: 83c406           add sp, 6
  032BDB  30EB: ff36ce2e         push word ptr [0x2ece]
  032BDF  30EF: 8d46b0           lea ax, [bp - 0x50]
  032BE2  30F2: 50               push ax
  032BE3  30F3: 9a6e011f18       lcall 0x181f, 0x16e
  032BE8  30F8: 83c404           add sp, 4
  032BEB  30FB: 6a36             push 0x36
  032BED  30FD: 6a30             push 0x30
  032BEF  30FF: ff36c80f         push word ptr [0xfc8]
  032BF3  3103: 684001           push 0x140
  032BF6  3106: 6a00             push 0
  032BF8  3108: 8d46b0           lea ax, [bp - 0x50]
  032BFB  310B: 16               push ss
  032BFC  310C: 50               push ax
  032BFD  310D: 9ac8011f18       lcall 0x181f, 0x1c8
  032C02  3112: 83c40e           add sp, 0xe
  032C05  3115: 0e               push cs
  032C06  3116: e8593d           call 0x6e72
  032C09  3119: c646b000         mov byte ptr [bp - 0x50], 0
  032C0D  311D: ff36d02e         push word ptr [0x2ed0]
  032C11  3121: 8d46b0           lea ax, [bp - 0x50]
  032C14  3124: 50               push ax
  032C15  3125: 9a6e011f18       lcall 0x181f, 0x16e
  032C1A  312A: 83c404           add sp, 4
  032C1D  312D: 8d46b0           lea ax, [bp - 0x50]
  032C20  3130: 50               push ax
  032C21  3131: 9abe011f18       lcall 0x181f, 0x1be
  032C26  3136: 83c402           add sp, 2
  032C29  3139: 6a36             push 0x36
  032C2B  313B: 6a30             push 0x30
  032C2D  313D: ff36c80f         push word ptr [0xfc8]
  032C31  3141: 689600           push 0x96
  032C34  3144: 8d46b0           lea ax, [bp - 0x50]
  032C37  3147: 16               push ss
  032C38  3148: 50               push ax
  032C39  3149: 9aaa011f18       lcall 0x181f, 0x1aa
  032C3E  314E: 83c40c           add sp, 0xc
  032C41  3151: c646b000         mov byte ptr [bp - 0x50], 0
  032C45  3155: 57               push di
  032C46  3156: 56               push si
  032C47  3157: 8d46b0           lea ax, [bp - 0x50]
  032C4A  315A: 16               push ss
  032C4B  315B: 50               push ax
  032C4C  315C: 9ad8001f18       lcall 0x181f, 0xd8
  032C51  3161: 83c408           add sp, 8
  032C54  3164: 6a36             push 0x36
  032C56  3166: 6a30             push 0x30
  032C58  3168: ff36c80f         push word ptr [0xfc8]
  032C5C  316C: 68c800           push 0xc8
  032C5F  316F: 8d46b0           lea ax, [bp - 0x50]
  032C62  3172: 16               push ss
  032C63  3173: 50               push ax
  032C64  3174: 9aaa011f18       lcall 0x181f, 0x1aa
  032C69  3179: 83c40c           add sp, 0xc
  032C6C  317C: 0e               push cs
  032C6D  317D: e8f23c           call 0x6e72
  032C70  3180: c646b000         mov byte ptr [bp - 0x50], 0
  032C74  3184: 8b1efc84         mov bx, word ptr [0x84fc]
  032C78  3188: 8a4701           mov al, byte ptr [bx + 1]
  032C7B  318B: 98               cwde 
  032C7C  318C: 50               push ax
  032C7D  318D: 8d46b0           lea ax, [bp - 0x50]
  032C80  3190: 16               push ss
  032C81  3191: 50               push ax
  032C82  3192: 9a82011f18       lcall 0x181f, 0x182
  032C87  3197: 83c406           add sp, 6
  032C8A  319A: ff36d22e         push word ptr [0x2ed2]
  032C8E  319E: 8d46b0           lea ax, [bp - 0x50]
  032C91  31A1: 50               push ax
  032C92  31A2: 9a6e011f18       lcall 0x181f, 0x16e
  032C97  31A7: 83c404           add sp, 4
  032C9A  31AA: 8d46b0           lea ax, [bp - 0x50]
  032C9D  31AD: 50               push ax
  032C9E  31AE: 9abe011f18       lcall 0x181f, 0x1be
  032CA3  31B3: 83c402           add sp, 2
  032CA6  31B6: 6a36             push 0x36
  032CA8  31B8: 6a30             push 0x30
  032CAA  31BA: ff36c80f         push word ptr [0xfc8]
  032CAE  31BE: 689600           push 0x96
  032CB1  31C1: 8d46b0           lea ax, [bp - 0x50]
  032CB4  31C4: 16               push ss
  032CB5  31C5: 50               push ax
  032CB6  31C6: 9aaa011f18       lcall 0x181f, 0x1aa
  032CBB  31CB: 83c40c           add sp, 0xc
  032CBE  31CE: c646b000         mov byte ptr [bp - 0x50], 0
  032CC2  31D2: 8b46a2           mov ax, word ptr [bp - 0x5e]
  032CC5  31D5: f7d8             neg ax
  032CC7  31D7: 99               cdq 
  032CC8  31D8: 52               push dx
  032CC9  31D9: 50               push ax
  032CCA  31DA: 8d46b0           lea ax, [bp - 0x50]
  032CCD  31DD: 16               push ss
  032CCE  31DE: 50               push ax
  032CCF  31DF: 9ad8001f18       lcall 0x181f, 0xd8
  032CD4  31E4: 83c408           add sp, 8
  032CD7  31E7: 6a36             push 0x36
  032CD9  31E9: 6a30             push 0x30
  032CDB  31EB: ff36c80f         push word ptr [0xfc8]
  032CDF  31EF: 68c800           push 0xc8
  032CE2  31F2: 8d46b0           lea ax, [bp - 0x50]
  032CE5  31F5: 16               push ss
  032CE6  31F6: 50               push ax
  032CE7  31F7: 9aaa011f18       lcall 0x181f, 0x1aa
  032CEC  31FC: 83c40c           add sp, 0xc
  032CEF  31FF: 0e               push cs
  032CF0  3200: e86f3c           call 0x6e72
  032CF3  3203: ff36ae2d         push word ptr [0x2dae]
  032CF7  3207: ff36ac2d         push word ptr [0x2dac]
  032CFB  320B: ff36aa2d         push word ptr [0x2daa]
  032CFF  320F: ff36a82d         push word ptr [0x2da8]
  032D03  3213: 6a00             push 0
  032D05  3215: b86400           mov ax, 0x64
  032D08  3218: bac800           mov dx, 0xc8
  032D0B  321B: 8b1ec80f         mov bx, word ptr [0xfc8]
  032D0F  321F: 9abc081f19       lcall 0x191f, 0x8bc
  032D14  3224: 8306c80f03       add word ptr [0xfc8], 3
  032D19  3229: c646b000         mov byte ptr [bp - 0x50], 0
  032D1D  322D: ff36d42e         push word ptr [0x2ed4]
  032D21  3231: 8d46b0           lea ax, [bp - 0x50]
  032D24  3234: 50               push ax
  032D25  3235: 9a6e011f18       lcall 0x181f, 0x16e
  032D2A  323A: 83c404           add sp, 4
  032D2D  323D: 8d46b0           lea ax, [bp - 0x50]
  032D30  3240: 50               push ax
  032D31  3241: 9abe011f18       lcall 0x181f, 0x1be
  032D36  3246: 83c402           add sp, 2
  032D39  3249: 6a36             push 0x36
  032D3B  324B: 6a30             push 0x30
  032D3D  324D: ff36c80f         push word ptr [0xfc8]
  032D41  3251: 689600           push 0x96
  032D44  3254: 8d46b0           lea ax, [bp - 0x50]
  032D47  3257: 16               push ss
  032D48  3258: 50               push ax
  032D49  3259: 9aaa011f18       lcall 0x181f, 0x1aa
  032D4E  325E: 83c40c           add sp, 0xc
  032D51  3261: c646b000         mov byte ptr [bp - 0x50], 0
  032D55  3265: ff76a0           push word ptr [bp - 0x60]
  032D58  3268: ff769e           push word ptr [bp - 0x62]
  032D5B  326B: 8d46b0           lea ax, [bp - 0x50]
  032D5E  326E: 16               push ss
  032D5F  326F: 50               push ax
  032D60  3270: 9ad8001f18       lcall 0x181f, 0xd8
  032D65  3275: 83c408           add sp, 8
  032D68  3278: 6a36             push 0x36
  032D6A  327A: 6a30             push 0x30
  032D6C  327C: ff36c80f         push word ptr [0xfc8]
  032D70  3280: 68c800           push 0xc8
  032D73  3283: 8d46b0           lea ax, [bp - 0x50]
  032D76  3286: 16               push ss
  032D77  3287: 50               push ax
  032D78  3288: 9aaa011f18       lcall 0x181f, 0x1aa
  032D7D  328D: 83c40c           add sp, 0xc
  032D80  3290: 0e               push cs
  032D81  3291: e8de3b           call 0x6e72
  032D84  3294: 0e               push cs
  032D85  3295: e8e93b           call 0x6e81
  032D88  3298: 833e920800       cmp word ptr [0x892], 0
  032D8D  329D: 7404             je 0x32a3
  032D8F  329F: 0e               push cs
  032D90  32A0: e8993a           call 0x6d3c
  032D93  32A3: ff7608           push word ptr [bp + 8]
  032D96  32A6: 6a00             push 0
  032D98  32A8: 0e               push cs
  032D99  32A9: e8213b           call 0x6dcd
  032D9C  32AC: 83c404           add sp, 4
  032D9F  32AF: c746ac0000       mov word ptr [bp - 0x54], 0
  032DA4  32B4: 8b46ac           mov ax, word ptr [bp - 0x54]
  032DA7  32B7: 5e               pop si
  032DA8  32B8: 5f               pop di
  032DA9  32B9: c9               leave 
  032DAA  32BA: cb               retf 

; ---- func_032DAC  size=566  insns=197  prologue=ENTER 0x000A,0  terminal=RETF ----
  032DAC  32BC: c80a0000         enter 0xa, 0
  032DB0  32C0: c746fc0100       mov word ptr [bp - 4], 1
  032DB5  32C5: 8d46fe           lea ax, [bp - 2]
  032DB8  32C8: 50               push ax
  032DB9  32C9: ff760a           push word ptr [bp + 0xa]
  032DBC  32CC: ff7606           push word ptr [bp + 6]
  032DBF  32CF: 9ae60b1f18       lcall 0x181f, 0xbe6
  032DC4  32D4: 83c404           add sp, 4
  032DC7  32D7: 8946f6           mov word ptr [bp - 0xa], ax
  032DCA  32DA: 50               push ax
  032DCB  32DB: ff7608           push word ptr [bp + 8]
  032DCE  32DE: 9a960b1f18       lcall 0x181f, 0xb96
  032DD3  32E3: 83c406           add sp, 6
  032DD6  32E6: 0bc0             or ax, ax
  032DD8  32E8: 7558             jne 0x3342
  032DDA  32EA: ff760a           push word ptr [bp + 0xa]
  032DDD  32ED: ff7608           push word ptr [bp + 8]
  032DE0  32F0: 9ae60b1f18       lcall 0x181f, 0xbe6
  032DE5  32F5: 83c404           add sp, 4
  032DE8  32F8: 8946f6           mov word ptr [bp - 0xa], ax
  032DEB  32FB: 6a01             push 1
  032DED  32FD: 9a56001f18       lcall 0x181f, 0x56
  032DF2  3302: 83c402           add sp, 2
  032DF5  3305: 6a04             push 4
  032DF7  3307: 0e               push cs
  032DF8  3308: e8593a           call 0x6d64
  032DFB  330B: 83c402           add sp, 2
  032DFE  330E: 8b5ef6           mov bx, word ptr [bp - 0xa]
  032E01  3311: d1e3             shl bx, 1
  032E03  3313: ffb7c097         push word ptr [bx - 0x6840]
  032E07  3317: 9a74001f18       lcall 0x181f, 0x74
  032E0C  331C: 83c402           add sp, 2
  032E0F  331F: 9a88001f18       lcall 0x181f, 0x88
  032E14  3324: 1e               push ds
  032E15  3325: 68f10f           push 0xff1
  032E18  3328: 9a6a001f18       lcall 0x181f, 0x6a
  032E1D  332D: 83c404           add sp, 4
  032E20  3330: 6a00             push 0
  032E22  3332: 6a78             push 0x78
  032E24  3334: 6a03             push 3
  032E26  3336: 0e               push cs
  032E27  3337: e8163a           call 0x6d50
  032E2A  333A: 83c406           add sp, 6
  032E2D  333D: 8b46fc           mov ax, word ptr [bp - 4]
  032E30  3340: c9               leave 
  032E31  3341: cb               retf 
  032E32  3342: 8b46fe           mov ax, word ptr [bp - 2]
  032E35  3345: 3d6400           cmp ax, 0x64
  032E38  3348: 7e03             jle 0x334d
  032E3A  334A: b86400           mov ax, 0x64
  032E3D  334D: 8946fe           mov word ptr [bp - 2], ax
  032E40  3350: ff760a           push word ptr [bp + 0xa]
  032E43  3353: ff7606           push word ptr [bp + 6]
  032E46  3356: 9a680c1f18       lcall 0x181f, 0xc68
  032E4B  335B: 83c404           add sp, 4
  032E4E  335E: 3b46fe           cmp ax, word ptr [bp - 2]
  032E51  3361: 7f11             jg 0x3374
  032E53  3363: ff760a           push word ptr [bp + 0xa]
  032E56  3366: ff7606           push word ptr [bp + 6]
  032E59  3369: 9a680c1f18       lcall 0x181f, 0xc68
  032E5E  336E: 83c404           add sp, 4
  032E61  3371: 8946fe           mov word ptr [bp - 2], ax
  032E64  3374: 837e0c00         cmp word ptr [bp + 0xc], 0
  032E68  3378: 7503             jne 0x337d
  032E6A  337A: e9b700           jmp 0x3434
  032E6D  337D: ff760a           push word ptr [bp + 0xa]
  032E70  3380: ff7606           push word ptr [bp + 6]
  032E73  3383: 9ae60b1f18       lcall 0x181f, 0xbe6
  032E78  3388: 83c404           add sp, 4
  032E7B  338B: 8bd8             mov bx, ax
  032E7D  338D: 895ef8           mov word ptr [bp - 8], bx
  032E80  3390: d1e3             shl bx, 1
  032E82  3392: ffb7c097         push word ptr [bx - 0x6840]
  032E86  3396: 6a00             push 0
  032E88  3398: 9a38041f18       lcall 0x181f, 0x438
  032E8D  339D: 83c404           add sp, 4
  032E90  33A0: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  032E94  33A4: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  032E98  33A8: 2aff             sub bh, bh
  032E9A  33AA: 8bc3             mov ax, bx
  032E9C  33AC: d1e3             shl bx, 1
  032E9E  33AE: 03d8             add bx, ax
  032EA0  33B0: d1e3             shl bx, 1
  032EA2  33B2: 03d8             add bx, ax
  032EA4  33B4: d1e3             shl bx, 1
  032EA6  33B6: ffb73052         push word ptr [bx + 0x5230]
  032EAA  33BA: 6a01             push 1
  032EAC  33BC: 9a38041f18       lcall 0x181f, 0x438
  032EB1  33C1: 83c404           add sp, 4
  032EB4  33C4: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  032EB8  33C8: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  032EBC  33CC: 2aff             sub bh, bh
  032EBE  33CE: 8bc3             mov ax, bx
  032EC0  33D0: d1e3             shl bx, 1
  032EC2  33D2: 03d8             add bx, ax
  032EC4  33D4: d1e3             shl bx, 1
  032EC6  33D6: 03d8             add bx, ax
  032EC8  33D8: d1e3             shl bx, 1
  032ECA  33DA: ffb73052         push word ptr [bx + 0x5230]
  032ECE  33DE: 6a02             push 2
  032ED0  33E0: 9a38041f18       lcall 0x181f, 0x438
  032ED5  33E5: 83c404           add sp, 4
  032ED8  33E8: 8b46fe           mov ax, word ptr [bp - 2]
  032EDB  33EB: 99               cdq 
  032EDC  33EC: 52               push dx
  032EDD  33ED: 50               push ax
  032EDE  33EE: 6a00             push 0
  032EE0  33F0: 9aae091f18       lcall 0x181f, 0x9ae
  032EE5  33F5: 83c406           add sp, 6
  032EE8  33F8: 8d1e7c08         lea bx, [0x87c]
  032EEC  33FC: 8d06f30f         lea ax, [0xff3]
  032EF0  3400: 8b56fe           mov dx, word ptr [bp - 2]
  032EF3  3403: 9a36041f19       lcall 0x191f, 0x436
  032EF8  3408: 0bc0             or ax, ax
  032EFA  340A: 7403             je 0x340f
  032EFC  340C: e9de00           jmp 0x34ed
  032EFF  340F: ff76fe           push word ptr [bp - 2]
  032F02  3412: 50               push ax
  032F03  3413: ff36c89c         push word ptr [0x9cc8]
  032F07  3417: 9a5c031f18       lcall 0x181f, 0x35c
  032F0C  341C: 83c406           add sp, 6
  032F0F  341F: 8946fa           mov word ptr [bp - 6], ax
  032F12  3422: 3b46fe           cmp ax, word ptr [bp - 2]
  032F15  3425: 7e03             jle 0x342a
  032F17  3427: 8b46fe           mov ax, word ptr [bp - 2]
  032F1A  342A: 8946fe           mov word ptr [bp - 2], ax
  032F1D  342D: 0bc0             or ax, ax
  032F1F  342F: 7f03             jg 0x3434
  032F21  3431: e9b900           jmp 0x34ed
  032F24  3434: ff760a           push word ptr [bp + 0xa]
  032F27  3437: ff7606           push word ptr [bp + 6]
  032F2A  343A: 9aec0a1f18       lcall 0x181f, 0xaec
  032F2F  343F: 83c404           add sp, 4
  032F32  3442: 8946f8           mov word ptr [bp - 8], ax
  032F35  3445: 0bc0             or ax, ax
  032F37  3447: 7d0d             jge 0x3456
  032F39  3449: 6a00             push 0
  032F3B  344B: 6a78             push 0x78
  032F3D  344D: 6a0b             push 0xb
  032F3F  344F: 0e               push cs
  032F40  3450: e82a39           call 0x6d7d
  032F43  3453: e9e4fe           jmp 0x333a
  032F46  3456: a1c48d           mov ax, word ptr [0x8dc4]
  032F49  3459: 3946fe           cmp word ptr [bp - 2], ax
  032F4C  345C: 7d18             jge 0x3476
  032F4E  345E: 2b46fe           sub ax, word ptr [bp - 2]
  032F51  3461: 50               push ax
  032F52  3462: ff76f8           push word ptr [bp - 8]
  032F55  3465: ff7606           push word ptr [bp + 6]
  032F58  3468: 9a580d1f18       lcall 0x181f, 0xd58
  032F5D  346D: 83c406           add sp, 6
  032F60  3470: 8b46fe           mov ax, word ptr [bp - 2]
  032F63  3473: a3c48d           mov word ptr [0x8dc4], ax
  032F66  3476: 50               push ax
  032F67  3477: ff76f8           push word ptr [bp - 8]
  032F6A  347A: ff7608           push word ptr [bp + 8]
  032F6D  347D: 9a580d1f18       lcall 0x181f, 0xd58
  032F72  3482: 83c406           add sp, 6
  032F75  3485: 6a01             push 1
  032F77  3487: 9a56001f18       lcall 0x181f, 0x56
  032F7C  348C: 83c402           add sp, 2
  032F7F  348F: ff36c48d         push word ptr [0x8dc4]
  032F83  3493: 9a7e001f18       lcall 0x181f, 0x7e
  032F88  3498: 83c402           add sp, 2
  032F8B  349B: 8b5ef8           mov bx, word ptr [bp - 8]
  032F8E  349E: d1e3             shl bx, 1
  032F90  34A0: ffb7c097         push word ptr [bx - 0x6840]
  032F94  34A4: 9a74001f18       lcall 0x181f, 0x74
  032F99  34A9: 83c402           add sp, 2
  032F9C  34AC: 6a02             push 2
  032F9E  34AE: 0e               push cs
  032F9F  34AF: e8b238           call 0x6d64
  032FA2  34B2: 83c402           add sp, 2
  032FA5  34B5: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  032FA9  34B9: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  032FAD  34BD: 2aff             sub bh, bh
  032FAF  34BF: 8bc3             mov ax, bx
  032FB1  34C1: d1e3             shl bx, 1
  032FB3  34C3: 03d8             add bx, ax
  032FB5  34C5: d1e3             shl bx, 1
  032FB7  34C7: 03d8             add bx, ax
  032FB9  34C9: d1e3             shl bx, 1
  032FBB  34CB: ffb73052         push word ptr [bx + 0x5230]
  032FBF  34CF: 9a74001f18       lcall 0x181f, 0x74
  032FC4  34D4: 83c402           add sp, 2
  032FC7  34D7: 6a00             push 0
  032FC9  34D9: 6a78             push 0x78
  032FCB  34DB: 6a01             push 1
  032FCD  34DD: 0e               push cs
  032FCE  34DE: e86f38           call 0x6d50
  032FD1  34E1: 83c406           add sp, 6
  032FD4  34E4: 0e               push cs
  032FD5  34E5: e85438           call 0x6d3c
  032FD8  34E8: c746fc0000       mov word ptr [bp - 4], 0
  032FDD  34ED: 8b46fc           mov ax, word ptr [bp - 4]
  032FE0  34F0: c9               leave 
  032FE1  34F1: cb               retf 

; ---- func_032FE2  size=364  insns=116  prologue=ENTER 0x000C,0  terminal=RETF ----
  032FE2  34F2: c80c0000         enter 0xc, 0
  032FE6  34F6: ff7606           push word ptr [bp + 6]
  032FE9  34F9: 0e               push cs
  032FEA  34FA: e81639           call 0x6e13
  032FED  34FD: 83c402           add sp, 2
  032FF0  3500: 8946f6           mov word ptr [bp - 0xa], ax
  032FF3  3503: 6bd81c           imul bx, ax, 0x1c
  032FF6  3506: 8a8f4c31         mov cl, byte ptr [bx + 0x314c]
  032FFA  350A: 884ef4           mov byte ptr [bp - 0xc], cl
  032FFD  350D: c6874c3100       mov byte ptr [bx + 0x314c], 0
  033002  3512: 50               push ax
  033003  3513: 9a20091f18       lcall 0x181f, 0x920
  033008  3518: 83c402           add sp, 2
  03300B  351B: 2bd2             sub dx, dx
  03300D  351D: 89165e1f         mov word ptr [0x1f5e], dx
  033011  3521: 8d1e7c08         lea bx, [0x87c]
  033015  3525: 8d06fc0f         lea ax, [0xffc]
  033019  3529: 9a82011f19       lcall 0x191f, 0x182
  03301E  352E: 8946fa           mov word ptr [bp - 6], ax
  033021  3531: 8956fc           mov word ptr [bp - 4], dx
  033024  3534: 0bd0             or dx, ax
  033026  3536: 7503             jne 0x353b
  033028  3538: e9f900           jmp 0x3634
  03302B  353B: 6a00             push 0
  03302D  353D: ff76f6           push word ptr [bp - 0xa]
  033030  3540: 9aea071f18       lcall 0x181f, 0x7ea
  033035  3545: 83c404           add sp, 4
  033038  3548: 8b46f6           mov ax, word ptr [bp - 0xa]
  03303B  354B: 9aee021f18       lcall 0x181f, 0x2ee
  033040  3550: eb2a             jmp 0x357c
  033042  3552: 6a00             push 0
  033044  3554: 6a00             push 0
  033046  3556: 6a00             push 0
  033048  3558: 9ada021f18       lcall 0x181f, 0x2da
  03304D  355D: 50               push ax
  03304E  355E: ff364008         push word ptr [0x840]
  033052  3562: ff363e08         push word ptr [0x83e]
  033056  3566: ff76fc           push word ptr [bp - 4]
  033059  3569: ff76fa           push word ptr [bp - 6]
  03305C  356C: 9a30021f19       lcall 0x191f, 0x230
  033061  3571: 83c410           add sp, 0x10
  033064  3574: 8b46f8           mov ax, word ptr [bp - 8]
  033067  3577: 9ae4021f18       lcall 0x181f, 0x2e4
  03306C  357C: 8946f8           mov word ptr [bp - 8], ax
  03306F  357F: 0bc0             or ax, ax
  033071  3581: 7dcf             jge 0x3552
  033073  3583: c746f80000       mov word ptr [bp - 8], 0
  033078  3588: eb31             jmp 0x35bb
  03307A  358A: 6a00             push 0
  03307C  358C: 6a00             push 0
  03307E  358E: 6a00             push 0
  033080  3590: ff76f8           push word ptr [bp - 8]
  033083  3593: ff76f6           push word ptr [bp - 0xa]
  033086  3596: 9ae60b1f18       lcall 0x181f, 0xbe6
  03308B  359B: 83c404           add sp, 4
  03308E  359E: 051700           add ax, 0x17
  033091  35A1: 50               push ax
  033092  35A2: ff364008         push word ptr [0x840]
  033096  35A6: ff363e08         push word ptr [0x83e]
  03309A  35AA: ff76fc           push word ptr [bp - 4]
  03309D  35AD: ff76fa           push word ptr [bp - 6]
  0330A0  35B0: 9a30021f19       lcall 0x191f, 0x230
  0330A5  35B5: 83c410           add sp, 0x10
  0330A8  35B8: ff46f8           inc word ptr [bp - 8]
  0330AB  35BB: 6b5ef61c         imul bx, word ptr [bp - 0xa], 0x1c
  0330AF  35BF: 8a875031         mov al, byte ptr [bx + 0x3150]
  0330B3  35C3: 2ae4             sub ah, ah
  0330B5  35C5: 3b46f8           cmp ax, word ptr [bp - 8]
  0330B8  35C8: 7fc0             jg 0x358a
  0330BA  35CA: a1129e           mov ax, word ptr [0x9e12]
  0330BD  35CD: 2d1400           sub ax, 0x14
  0330C0  35D0: 50               push ax
  0330C1  35D1: 50               push ax
  0330C2  35D2: ff76f6           push word ptr [bp - 0xa]
  0330C5  35D5: 9a48091f18       lcall 0x181f, 0x948
  0330CA  35DA: 83c406           add sp, 6
  0330CD  35DD: ff76fc           push word ptr [bp - 4]
  0330D0  35E0: ff76fa           push word ptr [bp - 6]
  0330D3  35E3: 9a6a011f19       lcall 0x191f, 0x16a
  0330D8  35E8: 48               dec ax
  0330D9  35E9: 7549             jne 0x3634
  0330DB  35EB: ff76f6           push word ptr [bp - 0xa]
  0330DE  35EE: 9ac20e1f19       lcall 0x191f, 0xec2
  0330E3  35F3: 83c402           add sp, 2
  0330E6  35F6: 833e9a0f01       cmp word ptr [0xf9a], 1
  0330EB  35FB: 7509             jne 0x3606
  0330ED  35FD: 833ea20f01       cmp word ptr [0xfa2], 1
  0330F2  3602: 7f1a             jg 0x361e
  0330F4  3604: eb12             jmp 0x3618
  0330F6  3606: 833e9a0f02       cmp word ptr [0xf9a], 2
  0330FB  360B: 7511             jne 0x361e
  0330FD  360D: 0e               push cs
  0330FE  360E: e87137           call 0x6d82
  033101  3611: 833e2a9e00       cmp word ptr [0x9e2a], 0
  033106  3616: 7506             jne 0x361e
  033108  3618: c7069a0f0000     mov word ptr [0xf9a], 0
  03310E  361E: a1a20f           mov ax, word ptr [0xfa2]
  033111  3621: 2b06a40f         sub ax, word ptr [0xfa4]
  033115  3625: 3d0100           cmp ax, 1
  033118  3628: 7f06             jg 0x3630
  03311A  362A: c706389e0000     mov word ptr [0x9e38], 0
  033120  3630: c646f400         mov byte ptr [bp - 0xc], 0
  033124  3634: c7065e1fffff     mov word ptr [0x1f5e], 0xffff
  03312A  363A: 8a46f4           mov al, byte ptr [bp - 0xc]
  03312D  363D: 6b5ef61c         imul bx, word ptr [bp - 0xa], 0x1c
  033131  3641: 88874c31         mov byte ptr [bx + 0x314c], al
  033135  3645: 8b46fc           mov ax, word ptr [bp - 4]
  033138  3648: 0b46fa           or ax, word ptr [bp - 6]
  03313B  364B: 740b             je 0x3658
  03313D  364D: ff76fc           push word ptr [bp - 4]
  033140  3650: ff76fa           push word ptr [bp - 6]
  033143  3653: 9aa8011f19       lcall 0x191f, 0x1a8
  033148  3658: 0e               push cs
  033149  3659: e8d537           call 0x6e31
  03314C  365C: c9               leave 
  03314D  365D: cb               retf 

; ---- func_03314E  size=511  insns=185  prologue=ENTER 0x0060,0  terminal=RETF ----
  03314E  365E: c8600000         enter 0x60, 0
  033152  3662: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  033156  3666: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03315A  366A: 2aff             sub bh, bh
  03315C  366C: 8bc3             mov ax, bx
  03315E  366E: d1e3             shl bx, 1
  033160  3670: 03d8             add bx, ax
  033162  3672: d1e3             shl bx, 1
  033164  3674: 03d8             add bx, ax
  033166  3676: d1e3             shl bx, 1
  033168  3678: ffb73052         push word ptr [bx + 0x5230]
  03316C  367C: 6a00             push 0
  03316E  367E: 9a38041f18       lcall 0x181f, 0x438
  033173  3683: 83c404           add sp, 4
  033176  3686: c646b000         mov byte ptr [bp - 0x50], 0
  03317A  368A: 8d46b0           lea ax, [bp - 0x50]
  03317D  368D: 16               push ss
  03317E  368E: 50               push ax
  03317F  368F: 6a01             push 1
  033181  3691: 9a16041f18       lcall 0x181f, 0x416
  033186  3696: 83c406           add sp, 6
  033189  3699: 8d1e7c08         lea bx, [0x87c]
  03318D  369D: 8d060510         lea ax, [0x1005]
  033191  36A1: 2bd2             sub dx, dx
  033193  36A3: 9a82011f19       lcall 0x191f, 0x182
  033198  36A8: 8946a8           mov word ptr [bp - 0x58], ax
  03319B  36AB: 8956aa           mov word ptr [bp - 0x56], dx
  03319E  36AE: 0bd0             or dx, ax
  0331A0  36B0: 7503             jne 0x36b5
  0331A2  36B2: e98f01           jmp 0x3844
  0331A5  36B5: c45ea8           les bx, ptr [bp - 0x58]
  0331A8  36B8: 26804f0a03       or byte ptr es:[bx + 0xa], 3
  0331AD  36BD: 681510           push 0x1015
  0331B0  36C0: 687c08           push 0x87c
  0331B3  36C3: 9a28091f19       lcall 0x191f, 0x928
  0331B8  36C8: 83c404           add sp, 4
  0331BB  36CB: 0bc0             or ax, ax
  0331BD  36CD: 7403             je 0x36d2
  0331BF  36CF: e97201           jmp 0x3844
  0331C2  36D2: 50               push ax
  0331C3  36D3: 50               push ax
  0331C4  36D4: 50               push ax
  0331C5  36D5: ff7606           push word ptr [bp + 6]
  0331C8  36D8: ff364008         push word ptr [0x840]
  0331CC  36DC: ff363e08         push word ptr [0x83e]
  0331D0  36E0: ff76aa           push word ptr [bp - 0x56]
  0331D3  36E3: ff76a8           push word ptr [bp - 0x58]
  0331D6  36E6: 9a30021f19       lcall 0x191f, 0x230
  0331DB  36EB: 83c410           add sp, 0x10
  0331DE  36EE: c746a20100       mov word ptr [bp - 0x5e], 1
  0331E3  36F3: eb36             jmp 0x372b
  0331E5  36F5: 90               nop 
  0331E6  36F6: 837e0800         cmp word ptr [bp + 8], 0
  0331EA  36FA: 756e             jne 0x376a
  0331EC  36FC: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0331F0  3700: f687483180       test byte ptr [bx + 0x3148], 0x80
  0331F5  3705: 7563             jne 0x376a
  0331F7  3707: c746a40100       mov word ptr [bp - 0x5c], 1
  0331FC  370C: 837ea400         cmp word ptr [bp - 0x5c], 0
  033200  3710: 7416             je 0x3728
  033202  3712: ff76a2           push word ptr [bp - 0x5e]
  033205  3715: 8d46b0           lea ax, [bp - 0x50]
  033208  3718: 16               push ss
  033209  3719: 50               push ax
  03320A  371A: ff76aa           push word ptr [bp - 0x56]
  03320D  371D: ff76a8           push word ptr [bp - 0x58]
  033210  3720: 9a76011f19       lcall 0x191f, 0x176
  033215  3725: 83c40a           add sp, 0xa
  033218  3728: ff46a2           inc word ptr [bp - 0x5e]
  03321B  372B: 837ea204         cmp word ptr [bp - 0x5e], 4
  03321F  372F: 7f41             jg 0x3772
  033221  3731: 8d46b0           lea ax, [bp - 0x50]
  033224  3734: 50               push ax
  033225  3735: 9a1c091f19       lcall 0x191f, 0x91c
  03322A  373A: 8946a6           mov word ptr [bp - 0x5a], ax
  03322D  373D: 50               push ax
  03322E  373E: 9a10091f19       lcall 0x191f, 0x910
  033233  3743: 83c404           add sp, 4
  033236  3746: 8b46a2           mov ax, word ptr [bp - 0x5e]
  033239  3749: 48               dec ax
  03323A  374A: 74bb             je 0x3707
  03323C  374C: 48               dec ax
  03323D  374D: 74a7             je 0x36f6
  03323F  374F: 48               dec ax
  033240  3750: 7406             je 0x3758
  033242  3752: 48               dec ax
  033243  3753: 74b2             je 0x3707
  033245  3755: ebb5             jmp 0x370c
  033247  3757: 90               nop 
  033248  3758: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03324C  375C: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  033251  3761: 7407             je 0x376a
  033253  3763: 837e0800         cmp word ptr [bp + 8], 0
  033257  3767: eb9c             jmp 0x3705
  033259  3769: 90               nop 
  03325A  376A: c746a40000       mov word ptr [bp - 0x5c], 0
  03325F  376F: eb9b             jmp 0x370c
  033261  3771: 90               nop 
  033262  3772: ff76aa           push word ptr [bp - 0x56]
  033265  3775: ff76a8           push word ptr [bp - 0x58]
  033268  3778: 9a6a011f19       lcall 0x191f, 0x16a
  03326D  377D: 8946ac           mov word ptr [bp - 0x54], ax
  033270  3780: ff76aa           push word ptr [bp - 0x56]
  033273  3783: ff76a8           push word ptr [bp - 0x58]
  033276  3786: 9aa8011f19       lcall 0x191f, 0x1a8
  03327B  378B: 2bc0             sub ax, ax
  03327D  378D: 8946aa           mov word ptr [bp - 0x56], ax
  033280  3790: 8946a8           mov word ptr [bp - 0x58], ax
  033283  3793: 837eac01         cmp word ptr [bp - 0x54], 1
  033287  3797: 7d03             jge 0x379c
  033289  3799: e9a800           jmp 0x3844
  03328C  379C: 837eac04         cmp word ptr [bp - 0x54], 4
  033290  37A0: 7c03             jl 0x37a5
  033292  37A2: e99f00           jmp 0x3844
  033295  37A5: 8b46ac           mov ax, word ptr [bp - 0x54]
  033298  37A8: e98d00           jmp 0x3838
  03329B  37AB: 90               nop 
  03329C  37AC: ff7606           push word ptr [bp + 6]
  03329F  37AF: 9a9e081f18       lcall 0x181f, 0x89e
  0332A4  37B4: 83c402           add sp, 2
  0332A7  37B7: 2bc0             sub ax, ax
  0332A9  37B9: a3209e           mov word ptr [0x9e20], ax
  0332AC  37BC: a31c9e           mov word ptr [0x9e1c], ax
  0332AF  37BF: e98200           jmp 0x3844
  0332B2  37C2: ff361c9e         push word ptr [0x9e1c]
  0332B6  37C6: 0e               push cs
  0332B7  37C7: e89535           call 0x6d5f
  0332BA  37CA: 83c402           add sp, 2
  0332BD  37CD: eb75             jmp 0x3844
  0332BF  37CF: 90               nop 
  0332C0  37D0: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0332C4  37D4: 8a875031         mov al, byte ptr [bx + 0x3150]
  0332C8  37D8: 2ae4             sub ah, ah
  0332CA  37DA: 48               dec ax
  0332CB  37DB: 8946a2           mov word ptr [bp - 0x5e], ax
  0332CE  37DE: eb08             jmp 0x37e8
  0332D0  37E0: c746a00100       mov word ptr [bp - 0x60], 1
  0332D5  37E5: ff4ea2           dec word ptr [bp - 0x5e]
  0332D8  37E8: 837ea200         cmp word ptr [bp - 0x5e], 0
  0332DC  37EC: 7c34             jl 0x3822
  0332DE  37EE: c746a00000       mov word ptr [bp - 0x60], 0
  0332E3  37F3: ff76a2           push word ptr [bp - 0x5e]
  0332E6  37F6: ff7606           push word ptr [bp + 6]
  0332E9  37F9: 9ae60b1f18       lcall 0x181f, 0xbe6
  0332EE  37FE: 83c404           add sp, 4
  0332F1  3801: 8946ae           mov word ptr [bp - 0x52], ax
  0332F4  3804: 50               push ax
  0332F5  3805: 0e               push cs
  0332F6  3806: e8ce35           call 0x6dd7
  0332F9  3809: 83c402           add sp, 2
  0332FC  380C: 0bc0             or ax, ax
  0332FE  380E: 75d0             jne 0x37e0
  033300  3810: 50               push ax
  033301  3811: ff76ae           push word ptr [bp - 0x52]
  033304  3814: ff7606           push word ptr [bp + 6]
  033307  3817: 0e               push cs
  033308  3818: e8cb35           call 0x6de6
  03330B  381B: 83c406           add sp, 6
  03330E  381E: 0bc0             or ax, ax
  033310  3820: 74c3             je 0x37e5
  033312  3822: 837ea000         cmp word ptr [bp - 0x60], 0
  033316  3826: 741c             je 0x3844
  033318  3828: 6a02             push 2
  03331A  382A: 682710           push 0x1027
  03331D  382D: 9a52061f18       lcall 0x181f, 0x652
  033322  3832: 83c404           add sp, 4
  033325  3835: eb0d             jmp 0x3844
  033327  3837: 90               nop 
  033328  3838: 48               dec ax
  033329  3839: 7503             jne 0x383e
  03332B  383B: e96eff           jmp 0x37ac
  03332E  383E: 48               dec ax
  03332F  383F: 7481             je 0x37c2
  033331  3841: 48               dec ax
  033332  3842: 748c             je 0x37d0
  033334  3844: 0e               push cs
  033335  3845: e8f434           call 0x6d3c
  033338  3848: 8b46aa           mov ax, word ptr [bp - 0x56]
  03333B  384B: 0b46a8           or ax, word ptr [bp - 0x58]
  03333E  384E: 740b             je 0x385b
  033340  3850: ff76aa           push word ptr [bp - 0x56]
  033343  3853: ff76a8           push word ptr [bp - 0x58]
  033346  3856: 9aa8011f19       lcall 0x191f, 0x1a8
  03334B  385B: c9               leave 
  03334C  385C: cb               retf 

; ---- func_03334E  size=221  insns=78  prologue=ENTER 0x0006,0  terminal=RETF ----
  03334E  385E: c8060000         enter 6, 0
  033352  3862: c746fa0000       mov word ptr [bp - 6], 0
  033357  3867: 833e129e04       cmp word ptr [0x9e12], 4
  03335C  386C: 7d0c             jge 0x387a
  03335E  386E: 6b1e129e34       imul bx, word ptr [0x9e12], 0x34
  033363  3873: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  033368  3878: 7414             je 0x388e
  03336A  387A: 8b1efc84         mov bx, word ptr [0x84fc]
  03336E  387E: c747200000       mov word ptr [bx + 0x20], 0
  033373  3883: c746fa0100       mov word ptr [bp - 6], 1
  033378  3888: 8b46fa           mov ax, word ptr [bp - 6]
  03337B  388B: c9               leave 
  03337C  388C: cb               retf 
  03337D  388D: 90               nop 
  03337E  388E: 8b5e06           mov bx, word ptr [bp + 6]
  033381  3891: d1e3             shl bx, 1
  033383  3893: ffb7c097         push word ptr [bx - 0x6840]
  033387  3897: 6a00             push 0
  033389  3899: 9a38041f18       lcall 0x181f, 0x438
  03338E  389E: 83c404           add sp, 4
  033391  38A1: 8b1e129e         mov bx, word ptr [0x9e12]
  033395  38A5: d1e3             shl bx, 1
  033397  38A7: ffb78c83         push word ptr [bx - 0x7c74]
  03339B  38AB: 6a01             push 1
  03339D  38AD: 9a38041f18       lcall 0x181f, 0x438
  0333A2  38B2: 83c404           add sp, 4
  0333A5  38B5: ff7606           push word ptr [bp + 6]
  0333A8  38B8: 0e               push cs
  0333A9  38B9: e8e434           call 0x6da0
  0333AC  38BC: 83c402           add sp, 2
  0333AF  38BF: 69c0f401         imul ax, ax, 0x1f4
  0333B3  38C3: 8946fc           mov word ptr [bp - 4], ax
  0333B6  38C6: 99               cdq 
  0333B7  38C7: 52               push dx
  0333B8  38C8: 50               push ax
  0333B9  38C9: 6a00             push 0
  0333BB  38CB: 9aae091f18       lcall 0x181f, 0x9ae
  0333C0  38D0: 83c406           add sp, 6
  0333C3  38D3: 6a02             push 2
  0333C5  38D5: 683310           push 0x1033
  0333C8  38D8: 9a52061f18       lcall 0x181f, 0x652
  0333CD  38DD: 83c404           add sp, 4
  0333D0  38E0: 3d0200           cmp ax, 2
  0333D3  38E3: 7551             jne 0x3936
  0333D5  38E5: 8b46fc           mov ax, word ptr [bp - 4]
  0333D8  38E8: 99               cdq 
  0333D9  38E9: 8b1efc84         mov bx, word ptr [0x84fc]
  0333DD  38ED: 39572c           cmp word ptr [bx + 0x2c], dx
  0333E0  38F0: 7f2a             jg 0x391c
  0333E2  38F2: 7c05             jl 0x38f9
  0333E4  38F4: 39472a           cmp word ptr [bx + 0x2a], ax
  0333E7  38F7: 7323             jae 0x391c
  0333E9  38F9: ff772c           push word ptr [bx + 0x2c]
  0333EC  38FC: ff772a           push word ptr [bx + 0x2a]
  0333EF  38FF: 6a00             push 0
  0333F1  3901: 9aae091f18       lcall 0x181f, 0x9ae
  0333F6  3906: 83c406           add sp, 6
  0333F9  3909: 6a02             push 2
  0333FB  390B: 683a10           push 0x103a
  0333FE  390E: 9a52061f18       lcall 0x181f, 0x652
  033403  3913: 83c404           add sp, 4
  033406  3916: 8b46fa           mov ax, word ptr [bp - 6]
  033409  3919: c9               leave 
  03340A  391A: cb               retf 
  03340B  391B: 90               nop 
  03340C  391C: 99               cdq 
  03340D  391D: 29472a           sub word ptr [bx + 0x2a], ax
  033410  3920: 19572c           sbb word ptr [bx + 0x2c], dx
  033413  3923: 014722           add word ptr [bx + 0x22], ax
  033416  3926: 115724           adc word ptr [bx + 0x24], dx
  033419  3929: 8a4e06           mov cl, byte ptr [bp + 6]
  03341C  392C: b80100           mov ax, 1
  03341F  392F: d3e0             shl ax, cl
  033421  3931: f7d0             not ax
  033423  3933: 214720           and word ptr [bx + 0x20], ax
  033426  3936: 8b46fa           mov ax, word ptr [bp - 6]
  033429  3939: c9               leave 
  03342A  393A: cb               retf 

; ---- func_03342C  size=462  insns=175  prologue=ENTER 0x0012,0  terminal=RETF ----
  03342C  393C: c8120000         enter 0x12, 0
  033430  3940: 56               push si
  033431  3941: c746eeffff       mov word ptr [bp - 0x12], 0xffff
  033436  3946: c746f40000       mov word ptr [bp - 0xc], 0
  03343B  394B: eb4f             jmp 0x399c
  03343D  394D: 90               nop 
  03343E  394E: a1a20f           mov ax, word ptr [0xfa2]
  033441  3951: 3946f4           cmp word ptr [bp - 0xc], ax
  033444  3954: 7d4c             jge 0x39a2
  033446  3956: 8d46f0           lea ax, [bp - 0x10]
  033449  3959: 50               push ax
  03344A  395A: 8d4ef2           lea cx, [bp - 0xe]
  03344D  395D: 51               push cx
  03344E  395E: 8d56f6           lea dx, [bp - 0xa]
  033451  3961: 52               push dx
  033452  3962: 8d5efa           lea bx, [bp - 6]
  033455  3965: 53               push bx
  033456  3966: 8d76f8           lea si, [bp - 8]
  033459  3969: 56               push si
  03345A  396A: 6a02             push 2
  03345C  396C: 6a05             push 5
  03345E  396E: 689200           push 0x92
  033461  3971: ff76f4           push word ptr [bp - 0xc]
  033464  3974: 0e               push cs
  033465  3975: e83734           call 0x6daf
  033468  3978: 83c412           add sp, 0x12
  03346B  397B: ff76f0           push word ptr [bp - 0x10]
  03346E  397E: ff76f2           push word ptr [bp - 0xe]
  033471  3981: ff76f6           push word ptr [bp - 0xa]
  033474  3984: ff76fa           push word ptr [bp - 6]
  033477  3987: 9aca031f18       lcall 0x181f, 0x3ca
  03347C  398C: 83c408           add sp, 8
  03347F  398F: 0bc0             or ax, ax
  033481  3991: 7406             je 0x3999
  033483  3993: 8b46f4           mov ax, word ptr [bp - 0xc]
  033486  3996: 8946ee           mov word ptr [bp - 0x12], ax
  033489  3999: ff46f4           inc word ptr [bp - 0xc]
  03348C  399C: 837eee00         cmp word ptr [bp - 0x12], 0
  033490  39A0: 7cac             jl 0x394e
  033492  39A2: 837eee00         cmp word ptr [bp - 0x12], 0
  033496  39A6: 7d03             jge 0x39ab
  033498  39A8: e95c01           jmp 0x3b07
  03349B  39AB: 833e3a9e0a       cmp word ptr [0x9e3a], 0xa
  0334A0  39B0: 7403             je 0x39b5
  0334A2  39B2: e98b00           jmp 0x3a40
  0334A5  39B5: 833ef40700       cmp word ptr [0x7f4], 0
  0334AA  39BA: 7503             jne 0x39bf
  0334AC  39BC: e94801           jmp 0x3b07
  0334AF  39BF: 833e229e00       cmp word ptr [0x9e22], 0
  0334B4  39C4: 7532             jne 0x39f8
  0334B6  39C6: ff361c9e         push word ptr [0x9e1c]
  0334BA  39CA: 0e               push cs
  0334BB  39CB: e84534           call 0x6e13
  0334BE  39CE: 83c402           add sp, 2
  0334C1  39D1: 8946fe           mov word ptr [bp - 2], ax
  0334C4  39D4: ff76ee           push word ptr [bp - 0x12]
  0334C7  39D7: 0e               push cs
  0334C8  39D8: e83834           call 0x6e13
  0334CB  39DB: 83c402           add sp, 2
  0334CE  39DE: 8946fc           mov word ptr [bp - 4], ax
  0334D1  39E1: 9aa2031f18       lcall 0x181f, 0x3a2
  0334D6  39E6: 50               push ax
  0334D7  39E7: ff361e9e         push word ptr [0x9e1e]
  0334DB  39EB: ff76fc           push word ptr [bp - 4]
  0334DE  39EE: ff76fe           push word ptr [bp - 2]
  0334E1  39F1: 0e               push cs
  0334E2  39F2: e85f34           call 0x6e54
  0334E5  39F5: eb42             jmp 0x3a39
  0334E7  39F7: 90               nop 
  0334E8  39F8: ff76ee           push word ptr [bp - 0x12]
  0334EB  39FB: 0e               push cs
  0334EC  39FC: e81434           call 0x6e13
  0334EF  39FF: 83c402           add sp, 2
  0334F2  3A02: 8946fe           mov word ptr [bp - 2], ax
  0334F5  3A05: ff36249e         push word ptr [0x9e24]
  0334F9  3A09: 0e               push cs
  0334FA  3A0A: e8ca33           call 0x6dd7
  0334FD  3A0D: 83c402           add sp, 2
  033500  3A10: 0bc0             or ax, ax
  033502  3A12: 7412             je 0x3a26
  033504  3A14: ff36249e         push word ptr [0x9e24]
  033508  3A18: 0e               push cs
  033509  3A19: e87033           call 0x6d8c
  03350C  3A1C: 83c402           add sp, 2
  03350F  3A1F: 0bc0             or ax, ax
  033511  3A21: 7503             jne 0x3a26
  033513  3A23: e9e100           jmp 0x3b07
  033516  3A26: 9aa2031f18       lcall 0x181f, 0x3a2
  03351B  3A2B: 50               push ax
  03351C  3A2C: 6a01             push 1
  03351E  3A2E: ff36249e         push word ptr [0x9e24]
  033522  3A32: ff76fe           push word ptr [bp - 2]
  033525  3A35: 0e               push cs
  033526  3A36: e81233           call 0x6d4b
  033529  3A39: 83c408           add sp, 8
  03352C  3A3C: 5e               pop si
  03352D  3A3D: c9               leave 
  03352E  3A3E: cb               retf 
  03352F  3A3F: 90               nop 
  033530  3A40: 833ef40700       cmp word ptr [0x7f4], 0
  033535  3A45: 7449             je 0x3a90
  033537  3A47: 833ee40700       cmp word ptr [0x7e4], 0
  03353C  3A4C: 7514             jne 0x3a62
  03353E  3A4E: 6a00             push 0
  033540  3A50: ff76ee           push word ptr [bp - 0x12]
  033543  3A53: 0e               push cs
  033544  3A54: e8bc33           call 0x6e13
  033547  3A57: 83c402           add sp, 2
  03354A  3A5A: 50               push ax
  03354B  3A5B: 0e               push cs
  03354C  3A5C: e89133           call 0x6df0
  03354F  3A5F: e9a200           jmp 0x3b04
  033552  3A62: 833ea20f00       cmp word ptr [0xfa2], 0
  033557  3A67: 7427             je 0x3a90
  033559  3A69: ff76ee           push word ptr [bp - 0x12]
  03355C  3A6C: 0e               push cs
  03355D  3A6D: e8a333           call 0x6e13
  033560  3A70: 83c402           add sp, 2
  033563  3A73: 8946ee           mov word ptr [bp - 0x12], ax
  033566  3A76: 6bd81c           imul bx, ax, 0x1c
  033569  3A79: 8a874631         mov al, byte ptr [bx + 0x3146]
  03356D  3A7D: 2ae4             sub ah, ah
  03356F  3A7F: 50               push ax
  033570  3A80: 9a42091f19       lcall 0x191f, 0x942
  033575  3A85: 83c402           add sp, 2
  033578  3A88: 0e               push cs
  033579  3A89: e8b433           call 0x6e40
  03357C  3A8C: 5e               pop si
  03357D  3A8D: c9               leave 
  03357E  3A8E: cb               retf 
  03357F  3A8F: 90               nop 
  033580  3A90: 833e3a9e08       cmp word ptr [0x9e3a], 8
  033585  3A95: 7470             je 0x3b07
  033587  3A97: 833ef60700       cmp word ptr [0x7f6], 0
  03358C  3A9C: 7469             je 0x3b07
  03358E  3A9E: 833eec0700       cmp word ptr [0x7ec], 0
  033593  3AA3: 7406             je 0x3aab
  033595  3AA5: a11c9e           mov ax, word ptr [0x9e1c]
  033598  3AA8: a34410           mov word ptr [0x1044], ax
  03359B  3AAB: c7069a0f0100     mov word ptr [0xf9a], 1
  0335A1  3AB1: 8b46ee           mov ax, word ptr [bp - 0x12]
  0335A4  3AB4: 39061c9e         cmp word ptr [0x9e1c], ax
  0335A8  3AB8: 7506             jne 0x3ac0
  0335AA  3ABA: 3906209e         cmp word ptr [0x9e20], ax
  0335AE  3ABE: 740a             je 0x3aca
  0335B0  3AC0: a3209e           mov word ptr [0x9e20], ax
  0335B3  3AC3: a31c9e           mov word ptr [0x9e1c], ax
  0335B6  3AC6: 0e               push cs
  0335B7  3AC7: e87232           call 0x6d3c
  0335BA  3ACA: ff76ee           push word ptr [bp - 0x12]
  0335BD  3ACD: 0e               push cs
  0335BE  3ACE: e84233           call 0x6e13
  0335C1  3AD1: 83c402           add sp, 2
  0335C4  3AD4: 6bd81c           imul bx, ax, 0x1c
  0335C7  3AD7: f687483180       test byte ptr [bx + 0x3148], 0x80
  0335CC  3ADC: 7414             je 0x3af2
  0335CE  3ADE: ff76ee           push word ptr [bp - 0x12]
  0335D1  3AE1: 0e               push cs
  0335D2  3AE2: e82e33           call 0x6e13
  0335D5  3AE5: 83c402           add sp, 2
  0335D8  3AE8: 6bd81c           imul bx, ax, 0x1c
  0335DB  3AEB: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  0335E0  3AF0: 7515             jne 0x3b07
  0335E2  3AF2: 6a1a             push 0x1a
  0335E4  3AF4: ff361c9e         push word ptr [0x9e1c]
  0335E8  3AF8: 0e               push cs
  0335E9  3AF9: e81733           call 0x6e13
  0335EC  3AFC: 83c402           add sp, 2
  0335EF  3AFF: 50               push ax
  0335F0  3B00: 0e               push cs
  0335F1  3B01: e85a33           call 0x6e5e
  0335F4  3B04: 83c404           add sp, 4
  0335F7  3B07: 5e               pop si
  0335F8  3B08: c9               leave 
  0335F9  3B09: cb               retf 

; ---- func_0335FA  size=283  insns=109  prologue=ENTER 0x0008,0  terminal=RETF ----
  0335FA  3B0A: c8080000         enter 8, 0
  0335FE  3B0E: 56               push si
  0335FF  3B0F: 833ea20f00       cmp word ptr [0xfa2], 0
  033604  3B14: 7503             jne 0x3b19
  033606  3B16: e90901           jmp 0x3c22
  033609  3B19: 6a47             push 0x47
  03360B  3B1B: 6a00             push 0
  03360D  3B1D: a1e807           mov ax, word ptr [0x7e8]
  033610  3B20: 2d9300           sub ax, 0x93
  033613  3B23: 50               push ax
  033614  3B24: 9a5c031f18       lcall 0x181f, 0x35c
  033619  3B29: 83c406           add sp, 6
  03361C  3B2C: b90c00           mov cx, 0xc
  03361F  3B2F: 99               cdq 
  033620  3B30: f7f9             idiv cx
  033622  3B32: 8946fc           mov word ptr [bp - 4], ax
  033625  3B35: ff361c9e         push word ptr [0x9e1c]
  033629  3B39: 8bf0             mov si, ax
  03362B  3B3B: 0e               push cs
  03362C  3B3C: e8d432           call 0x6e13
  03362F  3B3F: 83c402           add sp, 2
  033632  3B42: 8946f8           mov word ptr [bp - 8], ax
  033635  3B45: 56               push si
  033636  3B46: 50               push ax
  033637  3B47: 9ae60b1f18       lcall 0x181f, 0xbe6
  03363C  3B4C: 83c404           add sp, 4
  03363F  3B4F: 8946fa           mov word ptr [bp - 6], ax
  033642  3B52: 833e3a9e0a       cmp word ptr [0x9e3a], 0xa
  033647  3B57: 754f             jne 0x3ba8
  033649  3B59: 833ef40700       cmp word ptr [0x7f4], 0
  03364E  3B5E: 7503             jne 0x3b63
  033650  3B60: e9bf00           jmp 0x3c22
  033653  3B63: 833e229e01       cmp word ptr [0x9e22], 1
  033658  3B68: 7403             je 0x3b6d
  03365A  3B6A: e9b500           jmp 0x3c22
  03365D  3B6D: ff36249e         push word ptr [0x9e24]
  033661  3B71: 0e               push cs
  033662  3B72: e86232           call 0x6dd7
  033665  3B75: 83c402           add sp, 2
  033668  3B78: 0bc0             or ax, ax
  03366A  3B7A: 7412             je 0x3b8e
  03366C  3B7C: ff36249e         push word ptr [0x9e24]
  033670  3B80: 0e               push cs
  033671  3B81: e80832           call 0x6d8c
  033674  3B84: 83c402           add sp, 2
  033677  3B87: 0bc0             or ax, ax
  033679  3B89: 7503             jne 0x3b8e
  03367B  3B8B: e99400           jmp 0x3c22
  03367E  3B8E: 9aa2031f18       lcall 0x181f, 0x3a2
  033683  3B93: 50               push ax
  033684  3B94: 6a01             push 1
  033686  3B96: ff36249e         push word ptr [0x9e24]
  03368A  3B9A: ff76f8           push word ptr [bp - 8]
  03368D  3B9D: 0e               push cs
  03368E  3B9E: e8aa31           call 0x6d4b
  033691  3BA1: 83c408           add sp, 8
  033694  3BA4: 5e               pop si
  033695  3BA5: c9               leave 
  033696  3BA6: cb               retf 
  033697  3BA7: 90               nop 
  033698  3BA8: 833ee40700       cmp word ptr [0x7e4], 0
  03369D  3BAD: 741b             je 0x3bca
  03369F  3BAF: 833ef40700       cmp word ptr [0x7f4], 0
  0336A4  3BB4: 746c             je 0x3c22
  0336A6  3BB6: 0bc0             or ax, ax
  0336A8  3BB8: 7c68             jl 0x3c22
  0336AA  3BBA: 50               push ax
  0336AB  3BBB: 9a34091f19       lcall 0x191f, 0x934
  0336B0  3BC0: 83c402           add sp, 2
  0336B3  3BC3: 0e               push cs
  0336B4  3BC4: e87932           call 0x6e40
  0336B7  3BC7: 5e               pop si
  0336B8  3BC8: c9               leave 
  0336B9  3BC9: cb               retf 
  0336BA  3BCA: 833eec0700       cmp word ptr [0x7ec], 0
  0336BF  3BCF: 7451             je 0x3c22
  0336C1  3BD1: 0bc0             or ax, ax
  0336C3  3BD3: 7c4d             jl 0x3c22
  0336C5  3BD5: c706229e0000     mov word ptr [0x9e22], 0
  0336CB  3BDB: 8a46fa           mov al, byte ptr [bp - 6]
  0336CE  3BDE: 2ae4             sub ah, ah
  0336D0  3BE0: a3249e           mov word ptr [0x9e24], ax
  0336D3  3BE3: 8a46fc           mov al, byte ptr [bp - 4]
  0336D6  3BE6: a31e9e           mov word ptr [0x9e1e], ax
  0336D9  3BE9: ff76fc           push word ptr [bp - 4]
  0336DC  3BEC: ff76f8           push word ptr [bp - 8]
  0336DF  3BEF: 9a680c1f18       lcall 0x181f, 0xc68
  0336E4  3BF4: 83c404           add sp, 4
  0336E7  3BF7: 2ae4             sub ah, ah
  0336E9  3BF9: a3269e           mov word ptr [0x9e26], ax
  0336EC  3BFC: 50               push ax
  0336ED  3BFD: 6a00             push 0
  0336EF  3BFF: ff76fa           push word ptr [bp - 6]
  0336F2  3C02: 0e               push cs
  0336F3  3C03: e81d31           call 0x6d23
  0336F6  3C06: 83c402           add sp, 2
  0336F9  3C09: 50               push ax
  0336FA  3C0A: ff76fa           push word ptr [bp - 6]
  0336FD  3C0D: 0e               push cs
  0336FE  3C0E: e88531           call 0x6d96
  033701  3C11: 83c408           add sp, 8
  033704  3C14: ff36269e         push word ptr [0x9e26]
  033708  3C18: ff76fa           push word ptr [bp - 6]
  03370B  3C1B: 0e               push cs
  03370C  3C1C: e8ef31           call 0x6e0e
  03370F  3C1F: 83c404           add sp, 4
  033712  3C22: 5e               pop si
  033713  3C23: c9               leave 
  033714  3C24: cb               retf 

; ---- func_033716  size=97  insns=41  prologue=ENTER 0x0002,0  terminal=RETF ----
  033716  3C26: c8020000         enter 2, 0
  03371A  3C2A: 6a0c             push 0xc
  03371C  3C2C: 6a48             push 0x48
  03371E  3C2E: 68a500           push 0xa5
  033721  3C31: 689300           push 0x93
  033724  3C34: 9aca031f18       lcall 0x181f, 0x3ca
  033729  3C39: 83c408           add sp, 8
  03372C  3C3C: 0bc0             or ax, ax
  03372E  3C3E: 7406             je 0x3c46
  033730  3C40: c646fe01         mov byte ptr [bp - 2], 1
  033734  3C44: eb04             jmp 0x3c4a
  033736  3C46: c646fe00         mov byte ptr [bp - 2], 0
  03373A  3C4A: 833eec0700       cmp word ptr [0x7ec], 0
  03373F  3C4F: 7507             jne 0x3c58
  033741  3C51: 833e3a9e0a       cmp word ptr [0x9e3a], 0xa
  033746  3C56: 7508             jne 0x3c60
  033748  3C58: 8a46fe           mov al, byte ptr [bp - 2]
  03374B  3C5B: 2ae4             sub ah, ah
  03374D  3C5D: a3289e           mov word ptr [0x9e28], ax
  033750  3C60: a1289e           mov ax, word ptr [0x9e28]
  033753  3C63: eb19             jmp 0x3c7e
  033755  3C65: 90               nop 
  033756  3C66: 0e               push cs
  033757  3C67: e85e31           call 0x6dc8
  03375A  3C6A: c9               leave 
  03375B  3C6B: cb               retf 
  03375C  3C6C: 8a46fe           mov al, byte ptr [bp - 2]
  03375F  3C6F: 2ae4             sub ah, ah
  033761  3C71: 3b06289e         cmp ax, word ptr [0x9e28]
  033765  3C75: 750e             jne 0x3c85
  033767  3C77: 0e               push cs
  033768  3C78: e8fc31           call 0x6e77
  03376B  3C7B: c9               leave 
  03376C  3C7C: cb               retf 
  03376D  3C7D: 90               nop 
  03376E  3C7E: 0bc0             or ax, ax
  033770  3C80: 74e4             je 0x3c66
  033772  3C82: 48               dec ax
  033773  3C83: 74e7             je 0x3c6c
  033775  3C85: c9               leave 
  033776  3C86: cb               retf 

; ---- func_033778  size=730  insns=263  prologue=ENTER 0x0022,0  terminal=RETF ----
  033778  3C88: c8220000         enter 0x22, 0
  03377C  3C8C: 56               push si
  03377D  3C8D: c746fa0000       mov word ptr [bp - 6], 0
  033782  3C92: 833e3a9e08       cmp word ptr [0x9e3a], 8
  033787  3C97: 7519             jne 0x3cb2
  033789  3C99: 833ef40700       cmp word ptr [0x7f4], 0
  03378E  3C9E: 7503             jne 0x3ca3
  033790  3CA0: e9bc02           jmp 0x3f5f
  033793  3CA3: ff361c9e         push word ptr [0x9e1c]
  033797  3CA7: 0e               push cs
  033798  3CA8: e8b430           call 0x6d5f
  03379B  3CAB: 83c402           add sp, 2
  03379E  3CAE: 5e               pop si
  03379F  3CAF: c9               leave 
  0337A0  3CB0: cb               retf 
  0337A1  3CB1: 90               nop 
  0337A2  3CB2: 833e3a9e09       cmp word ptr [0x9e3a], 9
  0337A7  3CB7: 7403             je 0x3cbc
  0337A9  3CB9: e90601           jmp 0x3dc2
  0337AC  3CBC: 833ef40700       cmp word ptr [0x7f4], 0
  0337B1  3CC1: 7503             jne 0x3cc6
  0337B3  3CC3: e9fc00           jmp 0x3dc2
  0337B6  3CC6: a1429e           mov ax, word ptr [0x9e42]
  0337B9  3CC9: 8946e4           mov word ptr [bp - 0x1c], ax
  0337BC  3CCC: 6bd81c           imul bx, ax, 0x1c
  0337BF  3CCF: c6874c3100       mov byte ptr [bx + 0x314c], 0
  0337C4  3CD4: a1449e           mov ax, word ptr [0x9e44]
  0337C7  3CD7: 394606           cmp word ptr [bp + 6], ax
  0337CA  3CDA: 7503             jne 0x3cdf
  0337CC  3CDC: e9db00           jmp 0x3dba
  0337CF  3CDF: 8bc3             mov ax, bx
  0337D1  3CE1: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0337D5  3CE5: 8bf0             mov si, ax
  0337D7  3CE7: 8a845031         mov al, byte ptr [si + 0x3150]
  0337DB  3CEB: 2ae4             sub ah, ah
  0337DD  3CED: 2aff             sub bh, bh
  0337DF  3CEF: 8bcb             mov cx, bx
  0337E1  3CF1: d1e3             shl bx, 1
  0337E3  3CF3: 03d9             add bx, cx
  0337E5  3CF5: d1e3             shl bx, 1
  0337E7  3CF7: 03d9             add bx, cx
  0337E9  3CF9: d1e3             shl bx, 1
  0337EB  3CFB: 8a8f3752         mov cl, byte ptr [bx + 0x5237]
  0337EF  3CFF: 2aed             sub ch, ch
  0337F1  3D01: 2bc8             sub cx, ax
  0337F3  3D03: 894ee6           mov word ptr [bp - 0x1a], cx
  0337F6  3D06: 837ee400         cmp word ptr [bp - 0x1c], 0
  0337FA  3D0A: 7c36             jl 0x3d42
  0337FC  3D0C: 6b5ee41c         imul bx, word ptr [bp - 0x1c], 0x1c
  033800  3D10: 8b875e31         mov ax, word ptr [bx + 0x315e]
  033804  3D14: 8946de           mov word ptr [bp - 0x22], ax
  033807  3D17: a1429e           mov ax, word ptr [0x9e42]
  03380A  3D1A: 3946e4           cmp word ptr [bp - 0x1c], ax
  03380D  3D1D: 7511             jne 0x3d30
  03380F  3D1F: 6afe             push -2
  033811  3D21: 6afe             push -2
  033813  3D23: ff76e4           push word ptr [bp - 0x1c]
  033816  3D26: 9a80081f18       lcall 0x181f, 0x880
  03381B  3D2B: 83c406           add sp, 6
  03381E  3D2E: eb6d             jmp 0x3d9d
  033820  3D30: 6b5ee41c         imul bx, word ptr [bp - 0x1c], 0x1c
  033824  3D34: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  033829  3D39: 7215             jb 0x3d50
  03382B  3D3B: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  033830  3D40: 770e             ja 0x3d50
  033832  3D42: 837e0602         cmp word ptr [bp + 6], 2
  033836  3D46: 755e             jne 0x3da6
  033838  3D48: a1129e           mov ax, word ptr [0x9e12]
  03383B  3D4B: 2d1800           sub ax, 0x18
  03383E  3D4E: eb5c             jmp 0x3dac
  033840  3D50: 8a46e6           mov al, byte ptr [bp - 0x1a]
  033843  3D53: 6b5ee41c         imul bx, word ptr [bp - 0x1c], 0x1c
  033847  3D57: 8d8f4631         lea cx, [bx + 0x3146]
  03384B  3D5B: 8bd9             mov bx, cx
  03384D  3D5D: 8a1f             mov bl, byte ptr [bx]
  03384F  3D5F: 2aff             sub bh, bh
  033851  3D61: 8bd3             mov dx, bx
  033853  3D63: d1e3             shl bx, 1
  033855  3D65: 03da             add bx, dx
  033857  3D67: d1e3             shl bx, 1
  033859  3D69: 03da             add bx, dx
  03385B  3D6B: d1e3             shl bx, 1
  03385D  3D6D: 38873852         cmp byte ptr [bx + 0x5238], al
  033861  3D71: 772a             ja 0x3d9d
  033863  3D73: 6afe             push -2
  033865  3D75: 6afe             push -2
  033867  3D77: ff76e4           push word ptr [bp - 0x1c]
  03386A  3D7A: 8bf1             mov si, cx
  03386C  3D7C: 9a80081f18       lcall 0x181f, 0x880
  033871  3D81: 83c406           add sp, 6
  033874  3D84: 8a1c             mov bl, byte ptr [si]
  033876  3D86: 2aff             sub bh, bh
  033878  3D88: 8bc3             mov ax, bx
  03387A  3D8A: d1e3             shl bx, 1
  03387C  3D8C: 03d8             add bx, ax
  03387E  3D8E: d1e3             shl bx, 1
  033880  3D90: 03d8             add bx, ax
  033882  3D92: d1e3             shl bx, 1
  033884  3D94: 8a873852         mov al, byte ptr [bx + 0x5238]
  033888  3D98: 2ae4             sub ah, ah
  03388A  3D9A: 2946e6           sub word ptr [bp - 0x1a], ax
  03388D  3D9D: 8b46de           mov ax, word ptr [bp - 0x22]
  033890  3DA0: 8946e4           mov word ptr [bp - 0x1c], ax
  033893  3DA3: e960ff           jmp 0x3d06
  033896  3DA6: a1129e           mov ax, word ptr [0x9e12]
  033899  3DA9: 2d0c00           sub ax, 0xc
  03389C  3DAC: 50               push ax
  03389D  3DAD: 50               push ax
  03389E  3DAE: ff36429e         push word ptr [0x9e42]
  0338A2  3DB2: 9a48091f18       lcall 0x181f, 0x948
  0338A7  3DB7: 83c406           add sp, 6
  0338AA  3DBA: 0e               push cs
  0338AB  3DBB: e87330           call 0x6e31
  0338AE  3DBE: 5e               pop si
  0338AF  3DBF: c9               leave 
  0338B0  3DC0: cb               retf 
  0338B1  3DC1: 90               nop 
  0338B2  3DC2: 833e3a9e02       cmp word ptr [0x9e3a], 2
  0338B7  3DC7: 751b             jne 0x3de4
  0338B9  3DC9: c746e0e4ff       mov word ptr [bp - 0x20], 0xffe4
  0338BE  3DCE: c746e2e8ff       mov word ptr [bp - 0x1e], 0xffe8
  0338C3  3DD3: c746fc4900       mov word ptr [bp - 4], 0x49
  0338C8  3DD8: c746f87600       mov word ptr [bp - 8], 0x76
  0338CD  3DDD: c746fe0a00       mov word ptr [bp - 2], 0xa
  0338D2  3DE2: eb23             jmp 0x3e07
  0338D4  3DE4: 833e3a9e03       cmp word ptr [0x9e3a], 3
  0338D9  3DE9: 7403             je 0x3dee
  0338DB  3DEB: e97101           jmp 0x3f5f
  0338DE  3DEE: c746e0f0ff       mov word ptr [bp - 0x20], 0xfff0
  0338E3  3DF3: c746e2f4ff       mov word ptr [bp - 0x1e], 0xfff4
  0338E8  3DF8: c746fc0200       mov word ptr [bp - 4], 2
  0338ED  3DFD: c746f87600       mov word ptr [bp - 8], 0x76
  0338F2  3E02: c746fe0900       mov word ptr [bp - 2], 9
  0338F7  3E07: c746ee0000       mov word ptr [bp - 0x12], 0
  0338FC  3E0C: eb15             jmp 0x3e23
  0338FE  3E0E: 9ae4021f18       lcall 0x181f, 0x2e4
  033903  3E13: 8946e4           mov word ptr [bp - 0x1c], ax
  033906  3E16: 0bc0             or ax, ax
  033908  3E18: 7c06             jl 0x3e20
  03390A  3E1A: ff46fa           inc word ptr [bp - 6]
  03390D  3E1D: ebef             jmp 0x3e0e
  03390F  3E1F: 90               nop 
  033910  3E20: ff46ee           inc word ptr [bp - 0x12]
  033913  3E23: 837eee02         cmp word ptr [bp - 0x12], 2
  033917  3E27: 7d15             jge 0x3e3e
  033919  3E29: 8b76ee           mov si, word ptr [bp - 0x12]
  03391C  3E2C: d1e6             shl si, 1
  03391E  3E2E: 8b42e0           mov ax, word ptr [bp + si - 0x20]
  033921  3E31: 0306129e         add ax, word ptr [0x9e12]
  033925  3E35: 8bd0             mov dx, ax
  033927  3E37: 9ae0071f18       lcall 0x181f, 0x7e0
  03392C  3E3C: ebd5             jmp 0x3e13
  03392E  3E3E: 8b46fa           mov ax, word ptr [bp - 6]
  033931  3E41: 3d1900           cmp ax, 0x19
  033934  3E44: 7e03             jle 0x3e49
  033936  3E46: b81900           mov ax, 0x19
  033939  3E49: 8946fa           mov word ptr [bp - 6], ax
  03393C  3E4C: 0bc0             or ax, ax
  03393E  3E4E: 750a             jne 0x3e5a
  033940  3E50: c7063a9e0f00     mov word ptr [0x9e3a], 0xf
  033946  3E56: 5e               pop si
  033947  3E57: c9               leave 
  033948  3E58: cb               retf 
  033949  3E59: 90               nop 
  03394A  3E5A: c746ecffff       mov word ptr [bp - 0x14], 0xffff
  03394F  3E5F: 2bc0             sub ax, ax
  033951  3E61: 8946f6           mov word ptr [bp - 0xa], ax
  033954  3E64: 8946ee           mov word ptr [bp - 0x12], ax
  033957  3E67: eb62             jmp 0x3ecb
  033959  3E69: 90               nop 
  03395A  3E6A: 8b46e4           mov ax, word ptr [bp - 0x1c]
  03395D  3E6D: 9ae4021f18       lcall 0x181f, 0x2e4
  033962  3E72: 8946e4           mov word ptr [bp - 0x1c], ax
  033965  3E75: 0bc0             or ax, ax
  033967  3E77: 7c4f             jl 0x3ec8
  033969  3E79: 837eec00         cmp word ptr [bp - 0x14], 0
  03396D  3E7D: 7d49             jge 0x3ec8
  03396F  3E7F: 8d46e8           lea ax, [bp - 0x18]
  033972  3E82: 50               push ax
  033973  3E83: 8d4eea           lea cx, [bp - 0x16]
  033976  3E86: 51               push cx
  033977  3E87: 8d56f0           lea dx, [bp - 0x10]
  03397A  3E8A: 52               push dx
  03397B  3E8B: 8d5ef4           lea bx, [bp - 0xc]
  03397E  3E8E: 53               push bx
  03397F  3E8F: 8d76f2           lea si, [bp - 0xe]
  033982  3E92: 56               push si
  033983  3E93: 6a01             push 1
  033985  3E95: 6a0d             push 0xd
  033987  3E97: ff76fc           push word ptr [bp - 4]
  03398A  3E9A: ff76f6           push word ptr [bp - 0xa]
  03398D  3E9D: 0e               push cs
  03398E  3E9E: e80e2f           call 0x6daf
  033991  3EA1: 83c412           add sp, 0x12
  033994  3EA4: ff76e8           push word ptr [bp - 0x18]
  033997  3EA7: ff76ea           push word ptr [bp - 0x16]
  03399A  3EAA: ff76f0           push word ptr [bp - 0x10]
  03399D  3EAD: ff76f4           push word ptr [bp - 0xc]
  0339A0  3EB0: 9aca031f18       lcall 0x181f, 0x3ca
  0339A5  3EB5: 83c408           add sp, 8
  0339A8  3EB8: 0bc0             or ax, ax
  0339AA  3EBA: 7406             je 0x3ec2
  0339AC  3EBC: 8b46e4           mov ax, word ptr [bp - 0x1c]
  0339AF  3EBF: 8946ec           mov word ptr [bp - 0x14], ax
  0339B2  3EC2: ff46f6           inc word ptr [bp - 0xa]
  0339B5  3EC5: eba3             jmp 0x3e6a
  0339B7  3EC7: 90               nop 
  0339B8  3EC8: ff46ee           inc word ptr [bp - 0x12]
  0339BB  3ECB: 837eee02         cmp word ptr [bp - 0x12], 2
  0339BF  3ECF: 7d15             jge 0x3ee6
  0339C1  3ED1: 8b76ee           mov si, word ptr [bp - 0x12]
  0339C4  3ED4: d1e6             shl si, 1
  0339C6  3ED6: 8b42e0           mov ax, word ptr [bp + si - 0x20]
  0339C9  3ED9: 0306129e         add ax, word ptr [0x9e12]
  0339CD  3EDD: 8bd0             mov dx, ax
  0339CF  3EDF: 9ae0071f18       lcall 0x181f, 0x7e0
  0339D4  3EE4: eb8c             jmp 0x3e72
  0339D6  3EE6: 8b46ec           mov ax, word ptr [bp - 0x14]
  0339D9  3EE9: 8946e4           mov word ptr [bp - 0x1c], ax
  0339DC  3EEC: 833ee40700       cmp word ptr [0x7e4], 0
  0339E1  3EF1: 7425             je 0x3f18
  0339E3  3EF3: 833ef40700       cmp word ptr [0x7f4], 0
  0339E8  3EF8: 7465             je 0x3f5f
  0339EA  3EFA: 0bc0             or ax, ax
  0339EC  3EFC: 7c61             jl 0x3f5f
  0339EE  3EFE: 6bd81c           imul bx, ax, 0x1c
  0339F1  3F01: 8a874631         mov al, byte ptr [bx + 0x3146]
  0339F5  3F05: 2ae4             sub ah, ah
  0339F7  3F07: 50               push ax
  0339F8  3F08: 9a42091f19       lcall 0x191f, 0x942
  0339FD  3F0D: 83c402           add sp, 2
  033A00  3F10: 0e               push cs
  033A01  3F11: e82c2f           call 0x6e40
  033A04  3F14: 5e               pop si
  033A05  3F15: c9               leave 
  033A06  3F16: cb               retf 
  033A07  3F17: 90               nop 
  033A08  3F18: 6b5ee41c         imul bx, word ptr [bp - 0x1c], 0x1c
  033A0C  3F1C: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  033A11  3F21: 7303             jae 0x3f26
  033A13  3F23: e92aff           jmp 0x3e50
  033A16  3F26: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  033A1B  3F2B: 7603             jbe 0x3f30
  033A1D  3F2D: e920ff           jmp 0x3e50
  033A20  3F30: f687483180       test byte ptr [bx + 0x3148], 0x80
  033A25  3F35: 740a             je 0x3f41
  033A27  3F37: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  033A2C  3F3C: 7403             je 0x3f41
  033A2E  3F3E: e90fff           jmp 0x3e50
  033A31  3F41: 833ef60700       cmp word ptr [0x7f6], 0
  033A36  3F46: 7417             je 0x3f5f
  033A38  3F48: a13a9e           mov ax, word ptr [0x9e3a]
  033A3B  3F4B: a3449e           mov word ptr [0x9e44], ax
  033A3E  3F4E: ff76fe           push word ptr [bp - 2]
  033A41  3F51: 8b46e4           mov ax, word ptr [bp - 0x1c]
  033A44  3F54: a3429e           mov word ptr [0x9e42], ax
  033A47  3F57: 50               push ax
  033A48  3F58: 0e               push cs
  033A49  3F59: e8202f           call 0x6e7c
  033A4C  3F5C: 83c404           add sp, 4
  033A4F  3F5F: 5e               pop si
  033A50  3F60: c9               leave 
  033A51  3F61: cb               retf 

; ---- func_033A52  size=402  insns=152  prologue=ENTER 0x0008,0  terminal=RETF ----
  033A52  3F62: c8080000         enter 8, 0
  033A56  3F66: 833e3a9e0a       cmp word ptr [0x9e3a], 0xa
  033A5B  3F6B: 7559             jne 0x3fc6
  033A5D  3F6D: 833ef40700       cmp word ptr [0x7f4], 0
  033A62  3F72: 7503             jne 0x3f77
  033A64  3F74: e97b01           jmp 0x40f2
  033A67  3F77: 833e229e00       cmp word ptr [0x9e22], 0
  033A6C  3F7C: 7403             je 0x3f81
  033A6E  3F7E: e97101           jmp 0x40f2
  033A71  3F81: ff36249e         push word ptr [0x9e24]
  033A75  3F85: 0e               push cs
  033A76  3F86: e84e2e           call 0x6dd7
  033A79  3F89: 83c402           add sp, 2
  033A7C  3F8C: 0bc0             or ax, ax
  033A7E  3F8E: 7412             je 0x3fa2
  033A80  3F90: ff36249e         push word ptr [0x9e24]
  033A84  3F94: 0e               push cs
  033A85  3F95: e8f42d           call 0x6d8c
  033A88  3F98: 83c402           add sp, 2
  033A8B  3F9B: 0bc0             or ax, ax
  033A8D  3F9D: 7503             jne 0x3fa2
  033A8F  3F9F: e95001           jmp 0x40f2
  033A92  3FA2: ff361c9e         push word ptr [0x9e1c]
  033A96  3FA6: 0e               push cs
  033A97  3FA7: e8692e           call 0x6e13
  033A9A  3FAA: 83c402           add sp, 2
  033A9D  3FAD: 8946fa           mov word ptr [bp - 6], ax
  033AA0  3FB0: 9aa2031f18       lcall 0x181f, 0x3a2
  033AA5  3FB5: 50               push ax
  033AA6  3FB6: ff36249e         push word ptr [0x9e24]
  033AAA  3FBA: ff76fa           push word ptr [bp - 6]
  033AAD  3FBD: 0e               push cs
  033AAE  3FBE: e8252e           call 0x6de6
  033AB1  3FC1: 83c406           add sp, 6
  033AB4  3FC4: c9               leave 
  033AB5  3FC5: cb               retf 
  033AB6  3FC6: 683101           push 0x131
  033AB9  3FC9: 6a00             push 0
  033ABB  3FCB: ff36e807         push word ptr [0x7e8]
  033ABF  3FCF: 9a5c031f18       lcall 0x181f, 0x35c
  033AC4  3FD4: 83c406           add sp, 6
  033AC7  3FD7: b91300           mov cx, 0x13
  033ACA  3FDA: 99               cdq 
  033ACB  3FDB: f7f9             idiv cx
  033ACD  3FDD: 8946f8           mov word ptr [bp - 8], ax
  033AD0  3FE0: 3d1000           cmp ax, 0x10
  033AD3  3FE3: 7c03             jl 0x3fe8
  033AD5  3FE5: e90a01           jmp 0x40f2
  033AD8  3FE8: 833ef60700       cmp word ptr [0x7f6], 0
  033ADD  3FED: 753d             jne 0x402c
  033ADF  3FEF: c606a70f01       mov byte ptr [0xfa7], 1
  033AE4  3FF4: 8a46f8           mov al, byte ptr [bp - 8]
  033AE7  3FF7: 3806a60f         cmp byte ptr [0xfa6], al
  033AEB  3FFB: 7503             jne 0x4000
  033AED  3FFD: e9f200           jmp 0x40f2
  033AF0  4000: a2a60f           mov byte ptr [0xfa6], al
  033AF3  4003: 6a00             push 0
  033AF5  4005: e8bcd5           call 0x15c4
  033AF8  4008: 83c402           add sp, 2
  033AFB  400B: ff76f8           push word ptr [bp - 8]
  033AFE  400E: 0e               push cs
  033AFF  400F: e8e82d           call 0x6dfa
  033B02  4012: 83c402           add sp, 2
  033B05  4015: 68b300           push 0xb3
  033B08  4018: 683101           push 0x131
  033B0B  401B: 6a15             push 0x15
  033B0D  401D: 2bc0             sub ax, ax
  033B0F  401F: bab300           mov dx, 0xb3
  033B12  4022: 2bdb             sub bx, bx
  033B14  4024: 9ae2001f18       lcall 0x181f, 0xe2
  033B19  4029: c9               leave 
  033B1A  402A: cb               retf 
  033B1B  402B: 90               nop 
  033B1C  402C: 833e9a0f00       cmp word ptr [0xf9a], 0
  033B21  4031: 7508             jne 0x403b
  033B23  4033: a09e0f           mov al, byte ptr [0xf9e]
  033B26  4036: 3846f8           cmp byte ptr [bp - 8], al
  033B29  4039: 7410             je 0x404b
  033B2B  403B: c7069a0f0000     mov word ptr [0xf9a], 0
  033B31  4041: 8a46f8           mov al, byte ptr [bp - 8]
  033B34  4044: a29e0f           mov byte ptr [0xf9e], al
  033B37  4047: 0e               push cs
  033B38  4048: e8f12c           call 0x6d3c
  033B3B  404B: 833ee40700       cmp word ptr [0x7e4], 0
  033B40  4050: 741c             je 0x406e
  033B42  4052: 833ef40700       cmp word ptr [0x7f4], 0
  033B47  4057: 7503             jne 0x405c
  033B49  4059: e99600           jmp 0x40f2
  033B4C  405C: ff76f8           push word ptr [bp - 8]
  033B4F  405F: 9a34091f19       lcall 0x191f, 0x934
  033B54  4064: 83c402           add sp, 2
  033B57  4067: 0e               push cs
  033B58  4068: e8d52d           call 0x6e40
  033B5B  406B: c9               leave 
  033B5C  406C: cb               retf 
  033B5D  406D: 90               nop 
  033B5E  406E: 833ef40700       cmp word ptr [0x7f4], 0
  033B63  4073: 741b             je 0x4090
  033B65  4075: ff76f8           push word ptr [bp - 8]
  033B68  4078: 0e               push cs
  033B69  4079: e85b2d           call 0x6dd7
  033B6C  407C: 83c402           add sp, 2
  033B6F  407F: 0bc0             or ax, ax
  033B71  4081: 740d             je 0x4090
  033B73  4083: ff76f8           push word ptr [bp - 8]
  033B76  4086: 0e               push cs
  033B77  4087: e8022d           call 0x6d8c
  033B7A  408A: 83c402           add sp, 2
  033B7D  408D: c9               leave 
  033B7E  408E: cb               retf 
  033B7F  408F: 90               nop 
  033B80  4090: ff76f8           push word ptr [bp - 8]
  033B83  4093: 0e               push cs
  033B84  4094: e8402d           call 0x6dd7
  033B87  4097: 83c402           add sp, 2
  033B8A  409A: 0bc0             or ax, ax
  033B8C  409C: 7554             jne 0x40f2
  033B8E  409E: 50               push ax
  033B8F  409F: 50               push ax
  033B90  40A0: ff76f8           push word ptr [bp - 8]
  033B93  40A3: ff361c9e         push word ptr [0x9e1c]
  033B97  40A7: 0e               push cs
  033B98  40A8: e8682d           call 0x6e13
  033B9B  40AB: 83c402           add sp, 2
  033B9E  40AE: 50               push ax
  033B9F  40AF: 0e               push cs
  033BA0  40B0: e8982c           call 0x6d4b
  033BA3  40B3: 83c408           add sp, 8
  033BA6  40B6: 0bc0             or ax, ax
  033BA8  40B8: 7538             jne 0x40f2
  033BAA  40BA: c706229e0100     mov word ptr [0x9e22], 1
  033BB0  40C0: 8a46f8           mov al, byte ptr [bp - 8]
  033BB3  40C3: 2ae4             sub ah, ah
  033BB5  40C5: a3249e           mov word ptr [0x9e24], ax
  033BB8  40C8: c706269e6400     mov word ptr [0x9e26], 0x64
  033BBE  40CE: 6a64             push 0x64
  033BC0  40D0: 6a01             push 1
  033BC2  40D2: ff76f8           push word ptr [bp - 8]
  033BC5  40D5: 0e               push cs
  033BC6  40D6: e8c72c           call 0x6da0
  033BC9  40D9: 83c402           add sp, 2
  033BCC  40DC: 50               push ax
  033BCD  40DD: ff76f8           push word ptr [bp - 8]
  033BD0  40E0: 0e               push cs
  033BD1  40E1: e8b22c           call 0x6d96
  033BD4  40E4: 83c408           add sp, 8
  033BD7  40E7: ff36269e         push word ptr [0x9e26]
  033BDB  40EB: ff76f8           push word ptr [bp - 8]
  033BDE  40EE: 0e               push cs
  033BDF  40EF: e81c2d           call 0x6e0e
  033BE2  40F2: c9               leave 
  033BE3  40F3: cb               retf 

; ---- func_033BE4  size=178  insns=64  prologue=ENTER 0x0002,0  terminal=RETF ----
  033BE4  40F4: c8020000         enter 2, 0
  033BE8  40F8: 56               push si
  033BE9  40F9: ff362c9e         push word ptr [0x9e2c]
  033BED  40FD: 0e               push cs
  033BEE  40FE: e8442d           call 0x6e45
  033BF1  4101: 83c402           add sp, 2
  033BF4  4104: 8946fe           mov word ptr [bp - 2], ax
  033BF7  4107: 6a01             push 1
  033BF9  4109: 9a56001f18       lcall 0x181f, 0x56
  033BFE  410E: 83c402           add sp, 2
  033C01  4111: 8b1e129e         mov bx, word ptr [0x9e12]
  033C05  4115: d1e3             shl bx, 1
  033C07  4117: ffb70a8d         push word ptr [bx - 0x72f6]
  033C0B  411B: 9a74001f18       lcall 0x181f, 0x74
  033C10  4120: 83c402           add sp, 2
  033C13  4123: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  033C17  4127: 8bc3             mov ax, bx
  033C19  4129: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  033C1D  412D: 2aff             sub bh, bh
  033C1F  412F: 8bcb             mov cx, bx
  033C21  4131: d1e3             shl bx, 1
  033C23  4133: 03d9             add bx, cx
  033C25  4135: d1e3             shl bx, 1
  033C27  4137: 03d9             add bx, cx
  033C29  4139: d1e3             shl bx, 1
  033C2B  413B: ffb73052         push word ptr [bx + 0x5230]
  033C2F  413F: 8bf0             mov si, ax
  033C31  4141: 9a74001f18       lcall 0x181f, 0x74
  033C36  4146: 83c402           add sp, 2
  033C39  4149: ff76fe           push word ptr [bp - 2]
  033C3C  414C: 9a780b1f18       lcall 0x181f, 0xb78
  033C41  4151: 83c402           add sp, 2
  033C44  4154: 0bc0             or ax, ax
  033C46  4156: 7c35             jl 0x418d
  033C48  4158: 80bc5b311c       cmp byte ptr [si + 0x315b], 0x1c
  033C4D  415D: 742e             je 0x418d
  033C4F  415F: 1e               push ds
  033C50  4160: 684610           push 0x1046
  033C53  4163: 9a6a001f18       lcall 0x181f, 0x6a
  033C58  4168: 83c404           add sp, 4
  033C5B  416B: 8a845b31         mov al, byte ptr [si + 0x315b]
  033C5F  416F: 98               cwde 
  033C60  4170: 8bd8             mov bx, ax
  033C62  4172: c1e303           shl bx, 3
  033C65  4175: ffb7a28e         push word ptr [bx - 0x715e]
  033C69  4179: 9a74001f18       lcall 0x181f, 0x74
  033C6E  417E: 83c402           add sp, 2
  033C71  4181: 1e               push ds
  033C72  4182: 684810           push 0x1048
  033C75  4185: 9a6a001f18       lcall 0x181f, 0x6a
  033C7A  418A: 83c404           add sp, 4
  033C7D  418D: 833eee0701       cmp word ptr [0x7ee], 1
  033C82  4192: 1bc0             sbb ax, ax
  033C84  4194: 257800           and ax, 0x78
  033C87  4197: 99               cdq 
  033C88  4198: 52               push dx
  033C89  4199: 50               push ax
  033C8A  419A: 6a01             push 1
  033C8C  419C: 0e               push cs
  033C8D  419D: e8b02b           call 0x6d50
  033C90  41A0: 83c406           add sp, 6
  033C93  41A3: 5e               pop si
  033C94  41A4: c9               leave 
  033C95  41A5: cb               retf 

; ---- func_033C96  size=724  insns=249  prologue=ENTER 0x006C,0  terminal=page-end ----
  033C96  41A6: c86c0000         enter 0x6c, 0
  033C9A  41AA: 2bc0             sub ax, ax
  033C9C  41AC: 8946ac           mov word ptr [bp - 0x54], ax
  033C9F  41AF: 8946aa           mov word ptr [bp - 0x56], ax
  033CA2  41B2: ff362c9e         push word ptr [0x9e2c]
  033CA6  41B6: 0e               push cs
  033CA7  41B7: e88b2c           call 0x6e45
  033CAA  41BA: 83c402           add sp, 2
  033CAD  41BD: 894694           mov word ptr [bp - 0x6c], ax
  033CB0  41C0: 0bc0             or ax, ax
  033CB2  41C2: 7d03             jge 0x41c7
  033CB4  41C4: e90905           jmp 0x46d0
  033CB7  41C7: 6a0f             push 0xf
  033CB9  41C9: 0e               push cs
  033CBA  41CA: e8d32b           call 0x6da0
  033CBD  41CD: 83c402           add sp, 2
  033CC0  41D0: 6bc032           imul ax, ax, 0x32
  033CC3  41D3: 89469c           mov word ptr [bp - 0x64], ax
  033CC6  41D6: 6a0e             push 0xe
  033CC8  41D8: 0e               push cs
  033CC9  41D9: e8c42b           call 0x6da0
  033CCC  41DC: 83c402           add sp, 2
  033CCF  41DF: 6bc064           imul ax, ax, 0x64
  033CD2  41E2: 89469e           mov word ptr [bp - 0x62], ax
  033CD5  41E5: 6a08             push 8
  033CD7  41E7: 0e               push cs
  033CD8  41E8: e8b52b           call 0x6da0
  033CDB  41EB: 83c402           add sp, 2
  033CDE  41EE: 6bc032           imul ax, ax, 0x32
  033CE1  41F1: 8946a0           mov word ptr [bp - 0x60], ax
  033CE4  41F4: 6a0f             push 0xf
  033CE6  41F6: 0e               push cs
  033CE7  41F7: e8292b           call 0x6d23
  033CEA  41FA: 83c402           add sp, 2
  033CED  41FD: 6bc032           imul ax, ax, 0x32
  033CF0  4200: 8946a2           mov word ptr [bp - 0x5e], ax
  033CF3  4203: 6a0e             push 0xe
  033CF5  4205: 0e               push cs
  033CF6  4206: e81a2b           call 0x6d23
  033CF9  4209: 83c402           add sp, 2
  033CFC  420C: 6bc064           imul ax, ax, 0x64
  033CFF  420F: 8946a4           mov word ptr [bp - 0x5c], ax
  033D02  4212: 6a08             push 8
  033D04  4214: 0e               push cs
  033D05  4215: e80b2b           call 0x6d23
  033D08  4218: 83c402           add sp, 2
  033D0B  421B: 6bc032           imul ax, ax, 0x32
  033D0E  421E: 8946a6           mov word ptr [bp - 0x5a], ax
  033D11  4221: 8d1e7c08         lea bx, [0x87c]
  033D15  4225: 8d064a10         lea ax, [0x104a]
  033D19  4229: 2bd2             sub dx, dx
  033D1B  422B: 9a82011f19       lcall 0x191f, 0x182
  033D20  4230: 8946aa           mov word ptr [bp - 0x56], ax
  033D23  4233: 8956ac           mov word ptr [bp - 0x54], dx
  033D26  4236: 0bd0             or dx, ax
  033D28  4238: 7503             jne 0x423d
  033D2A  423A: e99304           jmp 0x46d0
  033D2D  423D: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033D31  4241: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  033D36  4246: 7407             je 0x424f
  033D38  4248: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  033D3D  424D: 7505             jne 0x4254
  033D3F  424F: 8b46a2           mov ax, word ptr [bp - 0x5e]
  033D42  4252: eb03             jmp 0x4257
  033D44  4254: 8b469c           mov ax, word ptr [bp - 0x64]
  033D47  4257: 99               cdq 
  033D48  4258: 52               push dx
  033D49  4259: 50               push ax
  033D4A  425A: 6a00             push 0
  033D4C  425C: 9aae091f18       lcall 0x181f, 0x9ae
  033D51  4261: 83c406           add sp, 6
  033D54  4264: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033D58  4268: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  033D5D  426D: 7505             jne 0x4274
  033D5F  426F: 8b46a4           mov ax, word ptr [bp - 0x5c]
  033D62  4272: eb03             jmp 0x4277
  033D64  4274: 8b469e           mov ax, word ptr [bp - 0x62]
  033D67  4277: 99               cdq 
  033D68  4278: 52               push dx
  033D69  4279: 50               push ax
  033D6A  427A: 6a01             push 1
  033D6C  427C: 9aae091f18       lcall 0x181f, 0x9ae
  033D71  4281: 83c406           add sp, 6
  033D74  4284: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033D78  4288: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  033D7D  428D: 7407             je 0x4296
  033D7F  428F: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  033D84  4294: 7506             jne 0x429c
  033D86  4296: 8b46a6           mov ax, word ptr [bp - 0x5a]
  033D89  4299: eb04             jmp 0x429f
  033D8B  429B: 90               nop 
  033D8C  429C: 8b46a0           mov ax, word ptr [bp - 0x60]
  033D8F  429F: 99               cdq 
  033D90  42A0: 52               push dx
  033D91  42A1: 50               push ax
  033D92  42A2: 6a02             push 2
  033D94  42A4: 9aae091f18       lcall 0x181f, 0x9ae
  033D99  42A9: 83c406           add sp, 6
  033D9C  42AC: c45eaa           les bx, ptr [bp - 0x56]
  033D9F  42AF: 26804f0a03       or byte ptr es:[bx + 0xa], 3
  033DA4  42B4: 685410           push 0x1054
  033DA7  42B7: 687c08           push 0x87c
  033DAA  42BA: 9a28091f19       lcall 0x191f, 0x928
  033DAF  42BF: 83c404           add sp, 4
  033DB2  42C2: 0bc0             or ax, ax
  033DB4  42C4: 7403             je 0x42c9
  033DB6  42C6: e90704           jmp 0x46d0
  033DB9  42C9: 50               push ax
  033DBA  42CA: 50               push ax
  033DBB  42CB: 50               push ax
  033DBC  42CC: ff7694           push word ptr [bp - 0x6c]
  033DBF  42CF: ff364008         push word ptr [0x840]
  033DC3  42D3: ff363e08         push word ptr [0x83e]
  033DC7  42D7: ff76ac           push word ptr [bp - 0x54]
  033DCA  42DA: ff76aa           push word ptr [bp - 0x56]
  033DCD  42DD: 9a30021f19       lcall 0x191f, 0x230
  033DD2  42E2: 83c410           add sp, 0x10
  033DD5  42E5: c746980100       mov word ptr [bp - 0x68], 1
  033DDA  42EA: e9f101           jmp 0x44de
  033DDD  42ED: 90               nop 
  033DDE  42EE: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033DE2  42F2: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  033DE7  42F7: 741e             je 0x4317
  033DE9  42F9: 2bc0             sub ax, ax
  033DEB  42FB: 89469a           mov word ptr [bp - 0x66], ax
  033DEE  42FE: e99101           jmp 0x4492
  033DF1  4301: 90               nop 
  033DF2  4302: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033DF6  4306: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  033DFB  430B: 74ec             je 0x42f9
  033DFD  430D: eb08             jmp 0x4317
  033DFF  430F: 90               nop 
  033E00  4310: 833e2c9e00       cmp word ptr [0x9e2c], 0
  033E05  4315: 7ee2             jle 0x42f9
  033E07  4317: b80100           mov ax, 1
  033E0A  431A: ebdf             jmp 0x42fb
  033E0C  431C: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033E10  4320: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  033E15  4325: 7407             je 0x432e
  033E17  4327: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  033E1C  432C: 7508             jne 0x4336
  033E1E  432E: c7469a0100       mov word ptr [bp - 0x66], 1
  033E23  4333: eb06             jmp 0x433b
  033E25  4335: 90               nop 
  033E26  4336: c7469a0000       mov word ptr [bp - 0x66], 0
  033E2B  433B: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033E2F  433F: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  033E34  4344: 7505             jne 0x434b
  033E36  4346: c7469a0000       mov word ptr [bp - 0x66], 0
  033E3B  434B: 8b469c           mov ax, word ptr [bp - 0x64]
  033E3E  434E: 894696           mov word ptr [bp - 0x6a], ax
  033E41  4351: 6a0f             push 0xf
  033E43  4353: 0e               push cs
  033E44  4354: e8802a           call 0x6dd7
  033E47  4357: 83c402           add sp, 2
  033E4A  435A: 0bc0             or ax, ax
  033E4C  435C: 7503             jne 0x4361
  033E4E  435E: e93101           jmp 0x4492
  033E51  4361: c7469a0000       mov word ptr [bp - 0x66], 0
  033E56  4366: e92901           jmp 0x4492
  033E59  4369: 90               nop 
  033E5A  436A: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033E5E  436E: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  033E63  4373: 7407             je 0x437c
  033E65  4375: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  033E6A  437A: 7508             jne 0x4384
  033E6C  437C: c7469a0100       mov word ptr [bp - 0x66], 1
  033E71  4381: ebce             jmp 0x4351
  033E73  4383: 90               nop 
  033E74  4384: c7469a0000       mov word ptr [bp - 0x66], 0
  033E79  4389: ebc6             jmp 0x4351
  033E7B  438B: 90               nop 
  033E7C  438C: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033E80  4390: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  033E85  4395: 1bc0             sbb ax, ax
  033E87  4397: f7d8             neg ax
  033E89  4399: 89469a           mov word ptr [bp - 0x66], ax
  033E8C  439C: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  033E91  43A1: 7505             jne 0x43a8
  033E93  43A3: c7469a0000       mov word ptr [bp - 0x66], 0
  033E98  43A8: 6a0e             push 0xe
  033E9A  43AA: 0e               push cs
  033E9B  43AB: e8292a           call 0x6dd7
  033E9E  43AE: 83c402           add sp, 2
  033EA1  43B1: 0bc0             or ax, ax
  033EA3  43B3: 7405             je 0x43ba
  033EA5  43B5: c7469a0000       mov word ptr [bp - 0x66], 0
  033EAA  43BA: 8b469e           mov ax, word ptr [bp - 0x62]
  033EAD  43BD: 894696           mov word ptr [bp - 0x6a], ax
  033EB0  43C0: e9cf00           jmp 0x4492
  033EB3  43C3: 90               nop 
  033EB4  43C4: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033EB8  43C8: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  033EBD  43CD: 7505             jne 0x43d4
  033EBF  43CF: b80100           mov ax, 1
  033EC2  43D2: eb02             jmp 0x43d6
  033EC4  43D4: 2bc0             sub ax, ax
  033EC6  43D6: 89469a           mov word ptr [bp - 0x66], ax
  033EC9  43D9: 6a0e             push 0xe
  033ECB  43DB: e975ff           jmp 0x4353
  033ECE  43DE: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033ED2  43E2: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  033ED7  43E7: 7407             je 0x43f0
  033ED9  43E9: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  033EDE  43EE: 7508             jne 0x43f8
  033EE0  43F0: c7469a0100       mov word ptr [bp - 0x66], 1
  033EE5  43F5: eb06             jmp 0x43fd
  033EE7  43F7: 90               nop 
  033EE8  43F8: c7469a0000       mov word ptr [bp - 0x66], 0
  033EED  43FD: 8b46a0           mov ax, word ptr [bp - 0x60]
  033EF0  4400: 894696           mov word ptr [bp - 0x6a], ax
  033EF3  4403: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033EF7  4407: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  033EFC  440C: 7505             jne 0x4413
  033EFE  440E: c7469a0000       mov word ptr [bp - 0x66], 0
  033F03  4413: 6a08             push 8
  033F05  4415: e93bff           jmp 0x4353
  033F08  4418: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033F0C  441C: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  033F11  4421: 7407             je 0x442a
  033F13  4423: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  033F18  4428: 75e4             jne 0x440e
  033F1A  442A: c7469a0100       mov word ptr [bp - 0x66], 1
  033F1F  442F: ebe2             jmp 0x4413
  033F21  4431: 90               nop 
  033F22  4432: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033F26  4436: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  033F2B  443B: 1bc0             sbb ax, ax
  033F2D  443D: f7d8             neg ax
  033F2F  443F: 89469a           mov word ptr [bp - 0x66], ax
  033F32  4442: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  033F37  4447: 7549             jne 0x4492
  033F39  4449: e915ff           jmp 0x4361
  033F3C  444C: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  033F40  4450: 80bf463103       cmp byte ptr [bx + 0x3146], 3
  033F45  4455: 7403             je 0x445a
  033F47  4457: e907ff           jmp 0x4361
  033F4A  445A: 80bf5b3118       cmp byte ptr [bx + 0x315b], 0x18
  033F4F  445F: 7503             jne 0x4464
  033F51  4461: e9fdfe           jmp 0x4361
  033F54  4464: c7469a0100       mov word ptr [bp - 0x66], 1
  033F59  4469: eb27             jmp 0x4492
  033F5B  446B: 90               nop 
  033F5C  446C: 48               dec ax
  033F5D  446D: 3d0b00           cmp ax, 0xb
  033F60  4470: 7720             ja 0x4492
  033F62  4472: d1e0             shl ax, 1
  033F64  4474: 93               xchg bx, ax
  033F65  4475: 2effa71a3a       jmp word ptr cs:[bx + 0x3a1a]

; ---- func_033F6A  size=10788  insns=0  prologue=no-frame (first byte 0x8E)  terminal=page-end ----
