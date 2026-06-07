; ============================================================
; VICEROY.EXE overlay page 0x01 (record 0) -- RE-SEGMENTED
; file_offset (disk image) = 0x020670
; code_offset (first insn) = 0x020EE0
; code_end (next reloc hdr)= 0x024BF0  [resident size 977 para -> nominal_end 0x024380; on-disk code spills past it]
; reloc_count = 527  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x020670)
; functions in page = 34
; ============================================================

; ---- func_020EE0  size=111  insns=35  prologue=no-frame (first byte 0x1E)  terminal=RETF ----
  020EE0  0870: 1e               push ds
  020EE1  0871: 680c08           push 0x80c
  020EE4  0874: 6a00             push 0
  020EE6  0876: 9a16041f18       lcall 0x181f, 0x416
  020EEB  087B: 83c406           add sp, 6
  020EEE  087E: 1e               push ds
  020EEF  087F: 681008           push 0x810
  020EF2  0882: 6a01             push 1
  020EF4  0884: 9a16041f18       lcall 0x181f, 0x416
  020EF9  0889: 83c406           add sp, 6
  020EFC  088C: cb               retf 
  020EFD  088D: 90               nop 
  020EFE  088E: 6a01             push 1
  020F00  0890: 9a24051f18       lcall 0x181f, 0x524
  020F05  0895: 83c402           add sp, 2
  020F08  0898: c7065e1f0000     mov word ptr [0x1f5e], 0
  020F0E  089E: 6a17             push 0x17
  020F10  08A0: 6b16945334       imul dx, word ptr [0x5394], 0x34
  020F15  08A5: 81c22654         add dx, 0x5426
  020F19  08A9: 8d1e7c08         lea bx, [0x87c]
  020F1D  08AD: 8d06a208         lea ax, [0x8a2]
  020F21  08B1: 9a20011f19       lcall 0x191f, 0x120
  020F26  08B6: 682098           push 0x9820
  020F29  08B9: 6b06945334       imul ax, word ptr [0x5394], 0x34
  020F2E  08BE: 052654           add ax, 0x5426
  020F31  08C1: 50               push ax
  020F32  08C2: 9ae4071d0d       lcall 0xd1d, 0x7e4
  020F37  08C7: 83c404           add sp, 4
  020F3A  08CA: f606825380       test byte ptr [0x5382], 0x80
  020F3F  08CF: 740d             je 0x8de
  020F41  08D1: 6a00             push 0
  020F43  08D3: 68a908           push 0x8a9
  020F46  08D6: 9a52061f18       lcall 0x181f, 0x652
  020F4B  08DB: 83c404           add sp, 4
  020F4E  08DE: cb               retf 

; ---- func_020F50  size=1714  insns=586  prologue=ENTER 0x002A,0  terminal=RET ----
  020F50  08E0: c82a0000         enter 0x2a, 0
  020F54  08E4: 56               push si
  020F55  08E5: a19253           mov ax, word ptr [0x5392]
  020F58  08E8: 8946da           mov word ptr [bp - 0x26], ax
  020F5B  08EB: 6bd81c           imul bx, ax, 0x1c
  020F5E  08EE: 80bf4c3100       cmp byte ptr [bx + 0x314c], 0
  020F63  08F3: 7403             je 0x8f8
  020F65  08F5: e99706           jmp 0xf8f
  020F68  08F8: 0bc0             or ax, ax
  020F6A  08FA: 7d03             jge 0x8ff
  020F6C  08FC: e99006           jmp 0xf8f
  020F6F  08FF: 39069c53         cmp word ptr [0x539c], ax
  020F73  0903: 7f03             jg 0x908
  020F75  0905: e98706           jmp 0xf8f
  020F78  0908: 6bd81c           imul bx, ax, 0x1c
  020F7B  090B: 8a874731         mov al, byte ptr [bx + 0x3147]
  020F7F  090F: 250f00           and ax, 0xf
  020F82  0912: 8946d6           mov word ptr [bp - 0x2a], ax
  020F85  0915: 3b069853         cmp ax, word ptr [0x5398]
  020F89  0919: 7403             je 0x91e
  020F8B  091B: e97106           jmp 0xf8f
  020F8E  091E: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  020F92  0922: 8a874431         mov al, byte ptr [bx + 0x3144]
  020F96  0926: 2ae4             sub ah, ah
  020F98  0928: 8946e6           mov word ptr [bp - 0x1a], ax
  020F9B  092B: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  020F9F  092F: 2aed             sub ch, ch
  020FA1  0931: 894ee4           mov word ptr [bp - 0x1c], cx
  020FA4  0934: 51               push cx
  020FA5  0935: 50               push ax
  020FA6  0936: 9a02031f18       lcall 0x181f, 0x302
  020FAB  093B: 83c404           add sp, 4
  020FAE  093E: 0bc0             or ax, ax
  020FB0  0940: 7503             jne 0x945
  020FB2  0942: e94a06           jmp 0xf8f
  020FB5  0945: 833e8e5300       cmp word ptr [0x538e], 0
  020FBA  094A: 7548             jne 0x994
  020FBC  094C: 803ea65300       cmp byte ptr [0x53a6], 0
  020FC1  0951: 7541             jne 0x994
  020FC3  0953: f606865310       test byte ptr [0x5386], 0x10
  020FC8  0958: 753a             jne 0x994
  020FCA  095A: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  020FCE  095E: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  020FD2  0962: 2aff             sub bh, bh
  020FD4  0964: 8bc3             mov ax, bx
  020FD6  0966: d1e3             shl bx, 1
  020FD8  0968: 03d8             add bx, ax
  020FDA  096A: d1e3             shl bx, 1
  020FDC  096C: 03d8             add bx, ax
  020FDE  096E: d1e3             shl bx, 1
  020FE0  0970: ffb73052         push word ptr [bx + 0x5230]
  020FE4  0974: 6a00             push 0
  020FE6  0976: 9a38041f18       lcall 0x181f, 0x438
  020FEB  097B: 83c404           add sp, 4
  020FEE  097E: 6a00             push 0
  020FF0  0980: 68b308           push 0x8b3
  020FF3  0983: 9a52061f18       lcall 0x181f, 0x652
  020FF8  0988: 83c404           add sp, 4
  020FFB  098B: 800e865310       or byte ptr [0x5386], 0x10
  021000  0990: 5e               pop si
  021001  0991: c9               leave 
  021002  0992: c3               ret 
  021003  0993: 90               nop 
  021004  0994: f606875340       test byte ptr [0x5387], 0x40
  021009  0999: 7577             jne 0xa12
  02100B  099B: 833e8e5314       cmp word ptr [0x538e], 0x14
  021010  09A0: 7d70             jge 0xa12
  021012  09A2: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  021016  09A6: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  02101B  09AB: 7265             jb 0xa12
  02101D  09AD: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  021022  09B2: 775e             ja 0xa12
  021024  09B4: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  021029  09B9: 7557             jne 0xa12
  02102B  09BB: 83bf5c3100       cmp word ptr [bx + 0x315c], 0
  021030  09C0: 7d50             jge 0xa12
  021032  09C2: 83bf5e3100       cmp word ptr [bx + 0x315e], 0
  021037  09C7: 7d49             jge 0xa12
  021039  09C9: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  02103D  09CD: 2aff             sub bh, bh
  02103F  09CF: 8bc3             mov ax, bx
  021041  09D1: d1e3             shl bx, 1
  021043  09D3: 03d8             add bx, ax
  021045  09D5: d1e3             shl bx, 1
  021047  09D7: 03d8             add bx, ax
  021049  09D9: d1e3             shl bx, 1
  02104B  09DB: ffb73052         push word ptr [bx + 0x5230]
  02104F  09DF: 6a00             push 0
  021051  09E1: 9a38041f18       lcall 0x181f, 0x438
  021056  09E6: 83c404           add sp, 4
  021059  09E9: 8b5ed6           mov bx, word ptr [bp - 0x2a]
  02105C  09EC: d1e3             shl bx, 1
  02105E  09EE: ffb78c83         push word ptr [bx - 0x7c74]
  021062  09F2: 6a01             push 1
  021064  09F4: 9a38041f18       lcall 0x181f, 0x438
  021069  09F9: 83c404           add sp, 4
  02106C  09FC: 6a00             push 0
  02106E  09FE: 68bd08           push 0x8bd
  021071  0A01: 9a52061f18       lcall 0x181f, 0x652
  021076  0A06: 83c404           add sp, 4
  021079  0A09: 800e875340       or byte ptr [0x5387], 0x40
  02107E  0A0E: 5e               pop si
  02107F  0A0F: c9               leave 
  021080  0A10: c3               ret 
  021081  0A11: 90               nop 
  021082  0A12: f606805301       test byte ptr [0x5380], 1
  021087  0A17: 7543             jne 0xa5c
  021089  0A19: 833e8e5314       cmp word ptr [0x538e], 0x14
  02108E  0A1E: 7d3c             jge 0xa5c
  021090  0A20: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  021094  0A24: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  021099  0A29: 7531             jne 0xa5c
  02109B  0A2B: 8b5ed6           mov bx, word ptr [bp - 0x2a]
  02109E  0A2E: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  0210A3  0A33: 7527             jne 0xa5c
  0210A5  0A35: ff76e4           push word ptr [bp - 0x1c]
  0210A8  0A38: ff76e6           push word ptr [bp - 0x1a]
  0210AB  0A3B: 9a68071f18       lcall 0x181f, 0x768
  0210B0  0A40: 83c404           add sp, 4
  0210B3  0A43: 0bc0             or ax, ax
  0210B5  0A45: 7515             jne 0xa5c
  0210B7  0A47: 6a03             push 3
  0210B9  0A49: 68c808           push 0x8c8
  0210BC  0A4C: 9a52061f18       lcall 0x181f, 0x652
  0210C1  0A51: 83c404           add sp, 4
  0210C4  0A54: 800e805301       or byte ptr [0x5380], 1
  0210C9  0A59: 5e               pop si
  0210CA  0A5A: c9               leave 
  0210CB  0A5B: c3               ret 
  0210CC  0A5C: f606805302       test byte ptr [0x5380], 2
  0210D1  0A61: 7539             jne 0xa9c
  0210D3  0A63: 833e8e5314       cmp word ptr [0x538e], 0x14
  0210D8  0A68: 7d32             jge 0xa9c
  0210DA  0A6A: ff76e4           push word ptr [bp - 0x1c]
  0210DD  0A6D: ff76e6           push word ptr [bp - 0x1a]
  0210E0  0A70: 9a68071f18       lcall 0x181f, 0x768
  0210E5  0A75: 83c404           add sp, 4
  0210E8  0A78: 0bc0             or ax, ax
  0210EA  0A7A: 7520             jne 0xa9c
  0210EC  0A7C: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  0210F0  0A80: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  0210F5  0A85: 7515             jne 0xa9c
  0210F7  0A87: 6a01             push 1
  0210F9  0A89: 68d308           push 0x8d3
  0210FC  0A8C: 9a52061f18       lcall 0x181f, 0x652
  021101  0A91: 83c404           add sp, 4
  021104  0A94: 800e805302       or byte ptr [0x5380], 2
  021109  0A99: 5e               pop si
  02110A  0A9A: c9               leave 
  02110B  0A9B: c3               ret 
  02110C  0A9C: 833e8e5328       cmp word ptr [0x538e], 0x28
  021111  0AA1: 7d4d             jge 0xaf0
  021113  0AA3: f606805308       test byte ptr [0x5380], 8
  021118  0AA8: 7546             jne 0xaf0
  02111A  0AAA: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  02111E  0AAE: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  021123  0AB3: 753b             jne 0xaf0
  021125  0AB5: ff76e4           push word ptr [bp - 0x1c]
  021128  0AB8: ff76e6           push word ptr [bp - 0x1a]
  02112B  0ABB: 9abe071f18       lcall 0x181f, 0x7be
  021130  0AC0: 83c404           add sp, 4
  021133  0AC3: 0bc0             or ax, ax
  021135  0AC5: 7c29             jl 0xaf0
  021137  0AC7: 69c0ca00         imul ax, ax, 0xca
  02113B  0ACB: 05485d           add ax, 0x5d48
  02113E  0ACE: 1e               push ds
  02113F  0ACF: 50               push ax
  021140  0AD0: 6a00             push 0
  021142  0AD2: 9a16041f18       lcall 0x181f, 0x416
  021147  0AD7: 83c406           add sp, 6
  02114A  0ADA: 6a05             push 5
  02114C  0ADC: 68de08           push 0x8de
  02114F  0ADF: 9a52061f18       lcall 0x181f, 0x652
  021154  0AE4: 83c404           add sp, 4
  021157  0AE7: 800e805308       or byte ptr [0x5380], 8
  02115C  0AEC: 5e               pop si
  02115D  0AED: c9               leave 
  02115E  0AEE: c3               ret 
  02115F  0AEF: 90               nop 
  021160  0AF0: f606865340       test byte ptr [0x5386], 0x40
  021165  0AF5: 7403             je 0xafa
  021167  0AF7: e9ee01           jmp 0xce8
  02116A  0AFA: 8b5ed6           mov bx, word ptr [bp - 0x2a]
  02116D  0AFD: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  021172  0B02: 7403             je 0xb07
  021174  0B04: e9e101           jmp 0xce8
  021177  0B07: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  02117B  0B0B: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  021180  0B10: 7403             je 0xb15
  021182  0B12: e9d301           jmp 0xce8
  021185  0B15: c746fc0100       mov word ptr [bp - 4], 1
  02118A  0B1A: ff76e4           push word ptr [bp - 0x1c]
  02118D  0B1D: ff76e6           push word ptr [bp - 0x1a]
  021190  0B20: 9a8c071f18       lcall 0x181f, 0x78c
  021195  0B25: 83c404           add sp, 4
  021198  0B28: 8946e0           mov word ptr [bp - 0x20], ax
  02119B  0B2B: 3d1900           cmp ax, 0x19
  02119E  0B2E: 740f             je 0xb3f
  0211A0  0B30: 3d1a00           cmp ax, 0x1a
  0211A3  0B33: 740a             je 0xb3f
  0211A5  0B35: 3d1b00           cmp ax, 0x1b
  0211A8  0B38: 7405             je 0xb3f
  0211AA  0B3A: 3d1c00           cmp ax, 0x1c
  0211AD  0B3D: 7505             jne 0xb44
  0211AF  0B3F: c746fc0000       mov word ptr [bp - 4], 0
  0211B4  0B44: 6aff             push -1
  0211B6  0B46: 6aff             push -1
  0211B8  0B48: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  0211BC  0B4C: 8a874531         mov al, byte ptr [bx + 0x3145]
  0211C0  0B50: 2ae4             sub ah, ah
  0211C2  0B52: 50               push ax
  0211C3  0B53: 8a874431         mov al, byte ptr [bx + 0x3144]
  0211C7  0B57: 50               push ax
  0211C8  0B58: 9a14061f18       lcall 0x181f, 0x614
  0211CD  0B5D: 83c408           add sp, 8
  0211D0  0B60: 0bc0             or ax, ax
  0211D2  0B62: 7c0c             jl 0xb70
  0211D4  0B64: 833eb88d01       cmp word ptr [0x8db8], 1
  0211D9  0B69: 7505             jne 0xb70
  0211DB  0B6B: c746fc0000       mov word ptr [bp - 4], 0
  0211E0  0B70: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  0211E4  0B74: 8a874531         mov al, byte ptr [bx + 0x3145]
  0211E8  0B78: 2ae4             sub ah, ah
  0211EA  0B7A: 50               push ax
  0211EB  0B7B: 8a874431         mov al, byte ptr [bx + 0x3144]
  0211EF  0B7F: 50               push ax
  0211F0  0B80: 9a120d1f18       lcall 0x181f, 0xd12
  0211F5  0B85: 83c404           add sp, 4
  0211F8  0B88: 0bc0             or ax, ax
  0211FA  0B8A: 741c             je 0xba8
  0211FC  0B8C: ff36bc8d         push word ptr [0x8dbc]
  021200  0B90: ff36ba8d         push word ptr [0x8dba]
  021204  0B94: 9ab4061f18       lcall 0x181f, 0x6b4
  021209  0B99: 83c404           add sp, 4
  02120C  0B9C: fec8             dec al
  02120E  0B9E: 7506             jne 0xba6
  021210  0BA0: b80100           mov ax, 1
  021213  0BA3: eb03             jmp 0xba8
  021215  0BA5: 90               nop 
  021216  0BA6: 2bc0             sub ax, ax
  021218  0BA8: 0bc0             or ax, ax
  02121A  0BAA: 7503             jne 0xbaf
  02121C  0BAC: 8946fc           mov word ptr [bp - 4], ax
  02121F  0BAF: 837efc00         cmp word ptr [bp - 4], 0
  021223  0BB3: 7503             jne 0xbb8
  021225  0BB5: e93001           jmp 0xce8
  021228  0BB8: c746deffff       mov word ptr [bp - 0x22], 0xffff
  02122D  0BBD: 2bc0             sub ax, ax
  02122F  0BBF: 8946e8           mov word ptr [bp - 0x18], ax
  021232  0BC2: 8946ee           mov word ptr [bp - 0x12], ax
  021235  0BC5: eb78             jmp 0xc3f
  021237  0BC7: 90               nop 
  021238  0BC8: 837ede00         cmp word ptr [bp - 0x22], 0
  02123C  0BCC: 7d6e             jge 0xc3c
  02123E  0BCE: c746de0000       mov word ptr [bp - 0x22], 0
  021243  0BD3: eb67             jmp 0xc3c
  021245  0BD5: 90               nop 
  021246  0BD6: c746de0300       mov word ptr [bp - 0x22], 3
  02124B  0BDB: eb5f             jmp 0xc3c
  02124D  0BDD: 90               nop 
  02124E  0BDE: c746de0200       mov word ptr [bp - 0x22], 2
  021253  0BE3: eb57             jmp 0xc3c
  021255  0BE5: 90               nop 
  021256  0BE6: c746de0100       mov word ptr [bp - 0x22], 1
  02125B  0BEB: eb4f             jmp 0xc3c
  02125D  0BED: 90               nop 
  02125E  0BEE: c746de0400       mov word ptr [bp - 0x22], 4
  021263  0BF3: eb47             jmp 0xc3c
  021265  0BF5: 90               nop 
  021266  0BF6: 837ede00         cmp word ptr [bp - 0x22], 0
  02126A  0BFA: 7d40             jge 0xc3c
  02126C  0BFC: c746de0500       mov word ptr [bp - 0x22], 5
  021271  0C01: eb39             jmp 0xc3c
  021273  0C03: 90               nop 
  021274  0C04: c746de0700       mov word ptr [bp - 0x22], 7
  021279  0C09: eb31             jmp 0xc3c
  02127B  0C0B: 90               nop 
  02127C  0C0C: c746de0600       mov word ptr [bp - 0x22], 6
  021281  0C11: eb29             jmp 0xc3c
  021283  0C13: 90               nop 
  021284  0C14: 48               dec ax
  021285  0C15: 48               dec ax
  021286  0C16: 3d0b00           cmp ax, 0xb
  021289  0C19: 7721             ja 0xc3c
  02128B  0C1B: d1e0             shl ax, 1
  02128D  0C1D: 93               xchg bx, ax
  02128E  0C1E: 2effa7b403       jmp word ptr cs:[bx + 0x3b4]
  021293  0C23: 90               nop 
  021294  0C24: 58               pop ax
  021295  0C25: 036603           add sp, word ptr [bp + 3]
  021298  0C28: 6e               outsb dx, byte ptr [si]
  021299  0C29: 037603           add si, word ptr [bp + 3]
  02129C  0C2C: 9c               pushf 
  02129D  0C2D: 03cc             add cx, sp
  02129F  0C2F: 037e03           add di, word ptr [bp + 3]
  0212A2  0C32: 7e03             jle 0xc37
  0212A4  0C34: 8603             xchg byte ptr [bp + di], al
  0212A6  0C36: cc               int3 
  0212A7  0C37: 0394039c         add dx, word ptr [si - 0x63fd]
  0212AB  0C3B: 03ff             add di, di
  0212AD  0C3D: 46               inc si
  0212AE  0C3E: ee               out dx, al
  0212AF  0C3F: 837eee09         cmp word ptr [bp - 0x12], 9
  0212B3  0C43: 7d4f             jge 0xc94
  0212B5  0C45: 8b5eee           mov bx, word ptr [bp - 0x12]
  0212B8  0C48: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0212BC  0C4C: 98               cwde 
  0212BD  0C4D: 0346e4           add ax, word ptr [bp - 0x1c]
  0212C0  0C50: 8946f8           mov word ptr [bp - 8], ax
  0212C3  0C53: 50               push ax
  0212C4  0C54: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0212C8  0C58: 98               cwde 
  0212C9  0C59: 0346e6           add ax, word ptr [bp - 0x1a]
  0212CC  0C5C: 8946fe           mov word ptr [bp - 2], ax
  0212CF  0C5F: 50               push ax
  0212D0  0C60: 9a8c071f18       lcall 0x181f, 0x78c
  0212D5  0C65: 83c404           add sp, 4
  0212D8  0C68: 8bd8             mov bx, ax
  0212DA  0C6A: 895ee0           mov word ptr [bp - 0x20], bx
  0212DD  0C6D: c1e304           shl bx, 4
  0212E0  0C70: 80bf7b2f00       cmp byte ptr [bx + 0x2f7b], 0
  0212E5  0C75: 7403             je 0xc7a
  0212E7  0C77: ff46e8           inc word ptr [bp - 0x18]
  0212EA  0C7A: ff76f8           push word ptr [bp - 8]
  0212ED  0C7D: ff76fe           push word ptr [bp - 2]
  0212F0  0C80: 9a18071f18       lcall 0x181f, 0x718
  0212F5  0C85: 83c404           add sp, 4
  0212F8  0C88: 8946ea           mov word ptr [bp - 0x16], ax
  0212FB  0C8B: 40               inc ax
  0212FC  0C8C: 74ae             je 0xc3c
  0212FE  0C8E: 8b46ea           mov ax, word ptr [bp - 0x16]
  021301  0C91: eb81             jmp 0xc14
  021303  0C93: 90               nop 
  021304  0C94: ff76e4           push word ptr [bp - 0x1c]
  021307  0C97: ff76e6           push word ptr [bp - 0x1a]
  02130A  0C9A: 9a22071f18       lcall 0x181f, 0x722
  02130F  0C9F: 83c404           add sp, 4
  021312  0CA2: 0bc0             or ax, ax
  021314  0CA4: 7e0e             jle 0xcb4
  021316  0CA6: 8bd8             mov bx, ax
  021318  0CA8: d1e3             shl bx, 1
  02131A  0CAA: 83bfc88507       cmp word ptr [bx - 0x7a38], 7
  02131F  0CAF: 7d03             jge 0xcb4
  021321  0CB1: ff46e8           inc word ptr [bp - 0x18]
  021324  0CB4: 837ede00         cmp word ptr [bp - 0x22], 0
  021328  0CB8: 7c2e             jl 0xce8
  02132A  0CBA: 837ee805         cmp word ptr [bp - 0x18], 5
  02132E  0CBE: 7c28             jl 0xce8
  021330  0CC0: 8b5ede           mov bx, word ptr [bp - 0x22]
  021333  0CC3: d1e3             shl bx, 1
  021335  0CC5: ffb7c097         push word ptr [bx - 0x6840]
  021339  0CC9: 6a00             push 0
  02133B  0CCB: 9a38041f18       lcall 0x181f, 0x438
  021340  0CD0: 83c404           add sp, 4
  021343  0CD3: 6a03             push 3
  021345  0CD5: 68e908           push 0x8e9
  021348  0CD8: 9a52061f18       lcall 0x181f, 0x652
  02134D  0CDD: 83c404           add sp, 4
  021350  0CE0: 800e865340       or byte ptr [0x5386], 0x40
  021355  0CE5: e9a702           jmp 0xf8f
  021358  0CE8: f606875308       test byte ptr [0x5387], 8
  02135D  0CED: 7403             je 0xcf2
  02135F  0CEF: e99000           jmp 0xd82
  021362  0CF2: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  021366  0CF6: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  02136B  0CFB: 7403             je 0xd00
  02136D  0CFD: e98200           jmp 0xd82
  021370  0D00: 80bf5b311c       cmp byte ptr [bx + 0x315b], 0x1c
  021375  0D05: 7407             je 0xd0e
  021377  0D07: 80bf5b3119       cmp byte ptr [bx + 0x315b], 0x19
  02137C  0D0C: 7574             jne 0xd82
  02137E  0D0E: 2bc0             sub ax, ax
  021380  0D10: 8946fc           mov word ptr [bp - 4], ax
  021383  0D13: 8946ee           mov word ptr [bp - 0x12], ax
  021386  0D16: eb1e             jmp 0xd36
  021388  0D18: 8b46ee           mov ax, word ptr [bp - 0x12]
  02138B  0D1B: 050400           add ax, 4
  02138E  0D1E: 50               push ax
  02138F  0D1F: ff76d6           push word ptr [bp - 0x2a]
  021392  0D22: 9a380a1f18       lcall 0x181f, 0xa38
  021397  0D27: 83c404           add sp, 4
  02139A  0D2A: a820             test al, 0x20
  02139C  0D2C: 7405             je 0xd33
  02139E  0D2E: c746fc0100       mov word ptr [bp - 4], 1
  0213A3  0D33: ff46ee           inc word ptr [bp - 0x12]
  0213A6  0D36: 837eee08         cmp word ptr [bp - 0x12], 8
  0213AA  0D3A: 7cdc             jl 0xd18
  0213AC  0D3C: 837efc00         cmp word ptr [bp - 4], 0
  0213B0  0D40: 7440             je 0xd82
  0213B2  0D42: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  0213B6  0D46: 8a875b31         mov al, byte ptr [bx + 0x315b]
  0213BA  0D4A: 98               cwde 
  0213BB  0D4B: 8946e2           mov word ptr [bp - 0x1e], ax
  0213BE  0D4E: 3d1c00           cmp ax, 0x1c
  0213C1  0D51: 7505             jne 0xd58
  0213C3  0D53: c746e21300       mov word ptr [bp - 0x1e], 0x13
  0213C8  0D58: 8b5ee2           mov bx, word ptr [bp - 0x1e]
  0213CB  0D5B: c1e303           shl bx, 3
  0213CE  0D5E: ffb7a28e         push word ptr [bx - 0x715e]
  0213D2  0D62: 6a00             push 0
  0213D4  0D64: 9a38041f18       lcall 0x181f, 0x438
  0213D9  0D69: 83c404           add sp, 4
  0213DC  0D6C: 6a05             push 5
  0213DE  0D6E: 68f308           push 0x8f3
  0213E1  0D71: 9a52061f18       lcall 0x181f, 0x652
  0213E6  0D76: 83c404           add sp, 4
  0213E9  0D79: 800e875308       or byte ptr [0x5387], 8
  0213EE  0D7E: e90e02           jmp 0xf8f
  0213F1  0D81: 90               nop 
  0213F2  0D82: f606875310       test byte ptr [0x5387], 0x10
  0213F7  0D87: 7403             je 0xd8c
  0213F9  0D89: e99000           jmp 0xe1c
  0213FC  0D8C: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  021400  0D90: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  021405  0D95: 7403             je 0xd9a
  021407  0D97: e98200           jmp 0xe1c
  02140A  0D9A: 6aff             push -1
  02140C  0D9C: 6aff             push -1
  02140E  0D9E: ff76e4           push word ptr [bp - 0x1c]
  021411  0DA1: ff76e6           push word ptr [bp - 0x1a]
  021414  0DA4: 9a14061f18       lcall 0x181f, 0x614
  021419  0DA9: 83c408           add sp, 8
  02141C  0DAC: 0bc0             or ax, ax
  02141E  0DAE: 7c6c             jl 0xe1c
  021420  0DB0: 833eb88d01       cmp word ptr [0x8db8], 1
  021425  0DB5: 7565             jne 0xe1c
  021427  0DB7: 8a46d6           mov al, byte ptr [bp - 0x2a]
  02142A  0DBA: 8b1e4285         mov bx, word ptr [0x8542]
  02142E  0DBE: 38471a           cmp byte ptr [bx + 0x1a], al
  021431  0DC1: 7559             jne 0xe1c
  021433  0DC3: ff76e4           push word ptr [bp - 0x1c]
  021436  0DC6: ff76e6           push word ptr [bp - 0x1a]
  021439  0DC9: 9a54071f18       lcall 0x181f, 0x754
  02143E  0DCE: 83c404           add sp, 4
  021441  0DD1: a80a             test al, 0xa
  021443  0DD3: 7547             jne 0xe1c
  021445  0DD5: ff76e4           push word ptr [bp - 0x1c]
  021448  0DD8: ff76e6           push word ptr [bp - 0x1a]
  02144B  0DDB: 9a8c071f18       lcall 0x181f, 0x78c
  021450  0DE0: 83c404           add sp, 4
  021453  0DE3: 8946e0           mov word ptr [bp - 0x20], ax
  021456  0DE6: 3d0800           cmp ax, 8
  021459  0DE9: 7c05             jl 0xdf0
  02145B  0DEB: 3d1000           cmp ax, 0x10
  02145E  0DEE: 7c14             jl 0xe04
  021460  0DF0: 3d1000           cmp ax, 0x10
  021463  0DF3: 7c05             jl 0xdfa
  021465  0DF5: 3d1800           cmp ax, 0x18
  021468  0DF8: 7c0a             jl 0xe04
  02146A  0DFA: 3d1b00           cmp ax, 0x1b
  02146D  0DFD: 7405             je 0xe04
  02146F  0DFF: 3d1c00           cmp ax, 0x1c
  021472  0E02: 7518             jne 0xe1c
  021474  0E04: 6a03             push 3
  021476  0E06: 68fd08           push 0x8fd
  021479  0E09: 9a52061f18       lcall 0x181f, 0x652
  02147E  0E0E: 83c404           add sp, 4
  021481  0E11: 800e875310       or byte ptr [0x5387], 0x10
  021486  0E16: e97601           jmp 0xf8f
  021489  0E19: 90               nop 
  02148A  0E1A: 90               nop 
  02148B  0E1B: 90               nop 
  02148C  0E1C: f606875320       test byte ptr [0x5387], 0x20
  021491  0E21: 7403             je 0xe26
  021493  0E23: e93e01           jmp 0xf64
  021496  0E26: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  02149A  0E2A: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  02149F  0E2F: 7403             je 0xe34
  0214A1  0E31: e93001           jmp 0xf64
  0214A4  0E34: 6aff             push -1
  0214A6  0E36: 6aff             push -1
  0214A8  0E38: ff76e4           push word ptr [bp - 0x1c]
  0214AB  0E3B: ff76e6           push word ptr [bp - 0x1a]
  0214AE  0E3E: 9a14061f18       lcall 0x181f, 0x614
  0214B3  0E43: 83c408           add sp, 8
  0214B6  0E46: 0bc0             or ax, ax
  0214B8  0E48: 7d03             jge 0xe4d
  0214BA  0E4A: e91701           jmp 0xf64
  0214BD  0E4D: 833eb88d01       cmp word ptr [0x8db8], 1
  0214C2  0E52: 7403             je 0xe57
  0214C4  0E54: e90d01           jmp 0xf64
  0214C7  0E57: 8a46d6           mov al, byte ptr [bp - 0x2a]
  0214CA  0E5A: 8b1e4285         mov bx, word ptr [0x8542]
  0214CE  0E5E: 38471a           cmp byte ptr [bx + 0x1a], al
  0214D1  0E61: 7403             je 0xe66
  0214D3  0E63: e9fe00           jmp 0xf64
  0214D6  0E66: ff76e4           push word ptr [bp - 0x1c]
  0214D9  0E69: ff76e6           push word ptr [bp - 0x1a]
  0214DC  0E6C: 9a54071f18       lcall 0x181f, 0x754
  0214E1  0E71: 83c404           add sp, 4
  0214E4  0E74: a840             test al, 0x40
  0214E6  0E76: 7403             je 0xe7b
  0214E8  0E78: e9e900           jmp 0xf64
  0214EB  0E7B: ff76e4           push word ptr [bp - 0x1c]
  0214EE  0E7E: ff76e6           push word ptr [bp - 0x1a]
  0214F1  0E81: 9a8c071f18       lcall 0x181f, 0x78c
  0214F6  0E86: 83c404           add sp, 4
  0214F9  0E89: 8946e0           mov word ptr [bp - 0x20], ax
  0214FC  0E8C: 3d0800           cmp ax, 8
  0214FF  0E8F: 7c05             jl 0xe96
  021501  0E91: 3d1000           cmp ax, 0x10
  021504  0E94: 7c0a             jl 0xea0
  021506  0E96: 3d1000           cmp ax, 0x10
  021509  0E99: 7c0d             jl 0xea8
  02150B  0E9B: 3d1800           cmp ax, 0x18
  02150E  0E9E: 7d08             jge 0xea8
  021510  0EA0: c746f20100       mov word ptr [bp - 0xe], 1
  021515  0EA5: eb06             jmp 0xead
  021517  0EA7: 90               nop 
  021518  0EA8: c746f20000       mov word ptr [bp - 0xe], 0
  02151D  0EAD: c746f60000       mov word ptr [bp - 0xa], 0
  021522  0EB2: 8a46e0           mov al, byte ptr [bp - 0x20]
  021525  0EB5: 250700           and ax, 7
  021528  0EB8: 3d0200           cmp ax, 2
  02152B  0EBB: 7c05             jl 0xec2
  02152D  0EBD: 3d0500           cmp ax, 5
  021530  0EC0: 7e05             jle 0xec7
  021532  0EC2: c746f20000       mov word ptr [bp - 0xe], 0
  021537  0EC7: 833e8e5310       cmp word ptr [0x538e], 0x10
  02153C  0ECC: 7d05             jge 0xed3
  02153E  0ECE: c746f20000       mov word ptr [bp - 0xe], 0
  021543  0ED3: c746ee0000       mov word ptr [bp - 0x12], 0
  021548  0ED8: 8b5eee           mov bx, word ptr [bp - 0x12]
  02154B  0EDB: 8a87be00         mov al, byte ptr [bx + 0xbe]
  02154F  0EDF: 98               cwde 
  021550  0EE0: 8b364285         mov si, word ptr [0x8542]
  021554  0EE4: 8a4c01           mov cl, byte ptr [si + 1]
  021557  0EE7: 2aed             sub ch, ch
  021559  0EE9: 03c1             add ax, cx
  02155B  0EEB: 8946f8           mov word ptr [bp - 8], ax
  02155E  0EEE: 50               push ax
  02155F  0EEF: 8a87b400         mov al, byte ptr [bx + 0xb4]
  021563  0EF3: 98               cwde 
  021564  0EF4: 8a0c             mov cl, byte ptr [si]
  021566  0EF6: 03c1             add ax, cx
  021568  0EF8: 8946fe           mov word ptr [bp - 2], ax
  02156B  0EFB: 50               push ax
  02156C  0EFC: 9a8c071f18       lcall 0x181f, 0x78c
  021571  0F01: 83c404           add sp, 4
  021574  0F04: 3d0200           cmp ax, 2
  021577  0F07: 7c0a             jl 0xf13
  021579  0F09: 3d0500           cmp ax, 5
  02157C  0F0C: 7f05             jg 0xf13
  02157E  0F0E: c746f20000       mov word ptr [bp - 0xe], 0
  021583  0F13: 3d0800           cmp ax, 8
  021586  0F16: 7c05             jl 0xf1d
  021588  0F18: 3d1000           cmp ax, 0x10
  02158B  0F1B: 7c0a             jl 0xf27
  02158D  0F1D: 3d1000           cmp ax, 0x10
  021590  0F20: 7c08             jl 0xf2a
  021592  0F22: 3d1800           cmp ax, 0x18
  021595  0F25: 7d03             jge 0xf2a
  021597  0F27: ff46f6           inc word ptr [bp - 0xa]
  02159A  0F2A: ff46ee           inc word ptr [bp - 0x12]
  02159D  0F2D: 837eee08         cmp word ptr [bp - 0x12], 8
  0215A1  0F31: 7ca5             jl 0xed8
  0215A3  0F33: 837ef602         cmp word ptr [bp - 0xa], 2
  0215A7  0F37: 7d05             jge 0xf3e
  0215A9  0F39: c746f20000       mov word ptr [bp - 0xe], 0
  0215AE  0F3E: 837ef200         cmp word ptr [bp - 0xe], 0
  0215B2  0F42: 750c             jne 0xf50
  0215B4  0F44: 837ee002         cmp word ptr [bp - 0x20], 2
  0215B8  0F48: 7c1a             jl 0xf64
  0215BA  0F4A: 837ee005         cmp word ptr [bp - 0x20], 5
  0215BE  0F4E: 7f14             jg 0xf64
  0215C0  0F50: 6a03             push 3
  0215C2  0F52: 680709           push 0x907
  0215C5  0F55: 9a52061f18       lcall 0x181f, 0x652
  0215CA  0F5A: 83c404           add sp, 4
  0215CD  0F5D: 800e875320       or byte ptr [0x5387], 0x20
  0215D2  0F62: eb2b             jmp 0xf8f
  0215D4  0F64: f606805380       test byte ptr [0x5380], 0x80
  0215D9  0F69: 7524             jne 0xf8f
  0215DB  0F6B: 6b5eda1c         imul bx, word ptr [bp - 0x26], 0x1c
  0215DF  0F6F: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  0215E4  0F74: 7519             jne 0xf8f
  0215E6  0F76: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  0215EB  0F7B: 7512             jne 0xf8f
  0215ED  0F7D: 6a04             push 4
  0215EF  0F7F: 681209           push 0x912
  0215F2  0F82: 9a52061f18       lcall 0x181f, 0x652
  0215F7  0F87: 83c404           add sp, 4
  0215FA  0F8A: 800e805380       or byte ptr [0x5380], 0x80
  0215FF  0F8F: 5e               pop si
  021600  0F90: c9               leave 
  021601  0F91: c3               ret 

; ---- func_021602  size=92  insns=32  prologue=ENTER 0x0004,0  terminal=RETF ----
  021602  0F92: c8040000         enter 4, 0
  021606  0F96: a12883           mov ax, word ptr [0x8328]
  021609  0F99: 8946fe           mov word ptr [bp - 2], ax
  02160C  0F9C: eb31             jmp 0xfcf
  02160E  0F9E: ff46fc           inc word ptr [bp - 4]
  021611  0FA1: 8b46fc           mov ax, word ptr [bp - 4]
  021614  0FA4: 39060688         cmp word ptr [0x8806], ax
  021618  0FA8: 7c22             jl 0xfcc
  02161A  0FAA: 6a0f             push 0xf
  02161C  0FAC: 50               push ax
  02161D  0FAD: ff76fe           push word ptr [bp - 2]
  021620  0FB0: 9a4a071f18       lcall 0x181f, 0x74a
  021625  0FB5: 83c404           add sp, 4
  021628  0FB8: 250f00           and ax, 0xf
  02162B  0FBB: 50               push ax
  02162C  0FBC: ff76fc           push word ptr [bp - 4]
  02162F  0FBF: ff76fe           push word ptr [bp - 2]
  021632  0FC2: 9a2c011f19       lcall 0x191f, 0x12c
  021637  0FC7: 83c408           add sp, 8
  02163A  0FCA: ebd2             jmp 0xf9e
  02163C  0FCC: ff46fe           inc word ptr [bp - 2]
  02163F  0FCF: 8b46fe           mov ax, word ptr [bp - 2]
  021642  0FD2: 39060488         cmp word ptr [0x8804], ax
  021646  0FD6: 7c08             jl 0xfe0
  021648  0FD8: a12e83           mov ax, word ptr [0x832e]
  02164B  0FDB: 8946fc           mov word ptr [bp - 4], ax
  02164E  0FDE: ebc1             jmp 0xfa1
  021650  0FE0: 9ac0031f18       lcall 0x181f, 0x3c0
  021655  0FE5: 6a01             push 1
  021657  0FE7: 9a1c0e1f18       lcall 0x181f, 0xe1c
  02165C  0FEC: c9               leave 
  02165D  0FED: cb               retf 

; ---- func_02165E  size=906  insns=293  prologue=ENTER 0x0054,0  terminal=RETF ----
  02165E  0FEE: c8540000         enter 0x54, 0
  021662  0FF2: 56               push si
  021663  0FF3: a19653           mov ax, word ptr [0x5396]
  021666  0FF6: 8946ac           mov word ptr [bp - 0x54], ax
  021669  0FF9: c746ae0000       mov word ptr [bp - 0x52], 0
  02166E  0FFE: 8b5eac           mov bx, word ptr [bp - 0x54]
  021671  1001: c1e306           shl bx, 6
  021674  1004: 035eae           add bx, word ptr [bp - 0x52]
  021677  1007: c1e302           shl bx, 2
  02167A  100A: 80bfb298ff       cmp byte ptr [bx - 0x674e], 0xff
  02167F  100F: 7421             je 0x1032
  021681  1011: 8a87b298         mov al, byte ptr [bx - 0x674e]
  021685  1015: 98               cwde 
  021686  1016: 40               inc ax
  021687  1017: 50               push ax
  021688  1018: 8a87b398         mov al, byte ptr [bx - 0x674d]
  02168C  101C: 98               cwde 
  02168D  101D: 50               push ax
  02168E  101E: 8a87b198         mov al, byte ptr [bx - 0x674f]
  021692  1022: 98               cwde 
  021693  1023: 50               push ax
  021694  1024: 8a87b098         mov al, byte ptr [bx - 0x6750]
  021698  1028: 98               cwde 
  021699  1029: 50               push ax
  02169A  102A: 9a2c011f19       lcall 0x191f, 0x12c
  02169F  102F: 83c408           add sp, 8
  0216A2  1032: ff46ae           inc word ptr [bp - 0x52]
  0216A5  1035: 837eae40         cmp word ptr [bp - 0x52], 0x40
  0216A9  1039: 7cc3             jl 0xffe
  0216AB  103B: 9ac0031f18       lcall 0x181f, 0x3c0
  0216B0  1040: 6a01             push 1
  0216B2  1042: 9a1c0e1f18       lcall 0x181f, 0xe1c
  0216B7  1047: 83c402           add sp, 2
  0216BA  104A: c746ae0100       mov word ptr [bp - 0x52], 1
  0216BF  104F: c646b000         mov byte ptr [bp - 0x50], 0
  0216C3  1053: ff76ae           push word ptr [bp - 0x52]
  0216C6  1056: 8d46b0           lea ax, [bp - 0x50]
  0216C9  1059: 16               push ss
  0216CA  105A: 50               push ax
  0216CB  105B: 9a82011f18       lcall 0x181f, 0x182
  0216D0  1060: 83c406           add sp, 6
  0216D3  1063: 8d46b0           lea ax, [bp - 0x50]
  0216D6  1066: 50               push ax
  0216D7  1067: 9adc011f18       lcall 0x181f, 0x1dc
  0216DC  106C: 83c402           add sp, 2
  0216DF  106F: 8d46b0           lea ax, [bp - 0x50]
  0216E2  1072: 50               push ax
  0216E3  1073: 9a1e011f18       lcall 0x181f, 0x11e
  0216E8  1078: 83c402           add sp, 2
  0216EB  107B: 8b5eae           mov bx, word ptr [bp - 0x52]
  0216EE  107E: d1e3             shl bx, 1
  0216F0  1080: ffb7c885         push word ptr [bx - 0x7a38]
  0216F4  1084: 8d46b0           lea ax, [bp - 0x50]
  0216F7  1087: 16               push ss
  0216F8  1088: 50               push ax
  0216F9  1089: 9a82011f18       lcall 0x181f, 0x182
  0216FE  108E: 83c406           add sp, 6
  021701  1091: 8d46b0           lea ax, [bp - 0x50]
  021704  1094: 50               push ax
  021705  1095: 9a28011f18       lcall 0x181f, 0x128
  02170A  109A: 83c402           add sp, 2
  02170D  109D: 8d46b0           lea ax, [bp - 0x50]
  021710  10A0: 50               push ax
  021711  10A1: 9a78011f18       lcall 0x181f, 0x178
  021716  10A6: 83c402           add sp, 2
  021719  10A9: 8b76ac           mov si, word ptr [bp - 0x54]
  02171C  10AC: c1e604           shl si, 4
  02171F  10AF: 8b5eae           mov bx, word ptr [bp - 0x52]
  021722  10B2: 8a807098         mov al, byte ptr [bx + si - 0x6790]
  021726  10B6: 2ae4             sub ah, ah
  021728  10B8: 50               push ax
  021729  10B9: 8d46b0           lea ax, [bp - 0x50]
  02172C  10BC: 16               push ss
  02172D  10BD: 50               push ax
  02172E  10BE: 9a82011f18       lcall 0x181f, 0x182
  021733  10C3: 83c406           add sp, 6
  021736  10C6: 8d46b0           lea ax, [bp - 0x50]
  021739  10C9: 50               push ax
  02173A  10CA: 9a78011f18       lcall 0x181f, 0x178
  02173F  10CF: 83c402           add sp, 2
  021742  10D2: 8b5eae           mov bx, word ptr [bp - 0x52]
  021745  10D5: 8a87f295         mov al, byte ptr [bx - 0x6a0e]
  021749  10D9: 2ae4             sub ah, ah
  02174B  10DB: 50               push ax
  02174C  10DC: 8d46b0           lea ax, [bp - 0x50]
  02174F  10DF: 16               push ss
  021750  10E0: 50               push ax
  021751  10E1: 9aa0011f18       lcall 0x181f, 0x1a0
  021756  10E6: 83c406           add sp, 6
  021759  10E9: 6a0f             push 0xf
  02175B  10EB: 8b46ae           mov ax, word ptr [bp - 0x52]
  02175E  10EE: 8bc8             mov cx, ax
  021760  10F0: d1e0             shl ax, 1
  021762  10F2: 03c1             add ax, cx
  021764  10F4: d1e0             shl ax, 1
  021766  10F6: 03c1             add ax, cx
  021768  10F8: 050a00           add ax, 0xa
  02176B  10FB: 50               push ax
  02176C  10FC: 6a05             push 5
  02176E  10FE: 8d46b0           lea ax, [bp - 0x50]
  021771  1101: 16               push ss
  021772  1102: 50               push ax
  021773  1103: 9a3c011f18       lcall 0x181f, 0x13c
  021778  1108: 83c40a           add sp, 0xa
  02177B  110B: ff46ae           inc word ptr [bp - 0x52]
  02177E  110E: 837eae0f         cmp word ptr [bp - 0x52], 0xf
  021782  1112: 7d03             jge 0x1117
  021784  1114: e938ff           jmp 0x104f
  021787  1117: 6a00             push 0
  021789  1119: 684001           push 0x140
  02178C  111C: 68c800           push 0xc8
  02178F  111F: 2bc0             sub ax, ax
  021791  1121: 99               cdq 
  021792  1122: 2bdb             sub bx, bx
  021794  1124: 9ae2001f18       lcall 0x181f, 0xe2
  021799  1129: 9ac0031f18       lcall 0x181f, 0x3c0
  02179E  112E: 6a01             push 1
  0217A0  1130: 9a1c0e1f18       lcall 0x181f, 0xe1c
  0217A5  1135: 83c402           add sp, 2
  0217A8  1138: 5e               pop si
  0217A9  1139: c9               leave 
  0217AA  113A: cb               retf 
  0217AB  113B: 90               nop 
  0217AC  113C: 80268253f4       and byte ptr [0x5382], 0xf4
  0217B1  1141: a19c53           mov ax, word ptr [0x539c]
  0217B4  1144: 99               cdq 
  0217B5  1145: 52               push dx
  0217B6  1146: 50               push ax
  0217B7  1147: 6a00             push 0
  0217B9  1149: 9aae091f18       lcall 0x181f, 0x9ae
  0217BE  114E: 83c406           add sp, 6
  0217C1  1151: a19e53           mov ax, word ptr [0x539e]
  0217C4  1154: 99               cdq 
  0217C5  1155: 52               push dx
  0217C6  1156: 50               push ax
  0217C7  1157: 6a01             push 1
  0217C9  1159: 9aae091f18       lcall 0x181f, 0x9ae
  0217CE  115E: 83c406           add sp, 6
  0217D1  1161: 8d1e2209         lea bx, [0x922]
  0217D5  1165: 8d061d09         lea ax, [0x91d]
  0217D9  1169: 2bd2             sub dx, dx
  0217DB  116B: 9a98091f18       lcall 0x181f, 0x998
  0217E0  1170: cb               retf 
  0217E1  1171: 90               nop 
  0217E2  1172: c70690530100     mov word ptr [0x5390], 1
  0217E8  1178: 833e925300       cmp word ptr [0x5392], 0
  0217ED  117D: 7c1f             jl 0x119e
  0217EF  117F: 6a01             push 1
  0217F1  1181: 6a01             push 1
  0217F3  1183: 6a01             push 1
  0217F5  1185: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  0217FA  118A: 8a874531         mov al, byte ptr [bx + 0x3145]
  0217FE  118E: 2ae4             sub ah, ah
  021800  1190: 50               push ax
  021801  1191: 8a874431         mov al, byte ptr [bx + 0x3144]
  021805  1195: 50               push ax
  021806  1196: 9aba091f18       lcall 0x181f, 0x9ba
  02180B  119B: 83c40a           add sp, 0xa
  02180E  119E: ff369808         push word ptr [0x898]
  021812  11A2: ff369608         push word ptr [0x896]
  021816  11A6: 9a5e011f19       lcall 0x191f, 0x15e
  02181B  11AB: 83c404           add sp, 4
  02181E  11AE: ff369808         push word ptr [0x898]
  021822  11B2: ff369608         push word ptr [0x896]
  021826  11B6: 9a52011f19       lcall 0x191f, 0x152
  02182B  11BB: 83c404           add sp, 4
  02182E  11BE: 6a01             push 1
  021830  11C0: 680103           push 0x301
  021833  11C3: ff369808         push word ptr [0x898]
  021837  11C7: ff369608         push word ptr [0x896]
  02183B  11CB: 9a46011f19       lcall 0x191f, 0x146
  021840  11D0: 83c408           add sp, 8
  021843  11D3: 6a01             push 1
  021845  11D5: 683003           push 0x330
  021848  11D8: ff369808         push word ptr [0x898]
  02184C  11DC: ff369608         push word ptr [0x896]
  021850  11E0: 9a46011f19       lcall 0x191f, 0x146
  021855  11E5: 83c408           add sp, 8
  021858  11E8: 6a01             push 1
  02185A  11EA: 680203           push 0x302
  02185D  11ED: ff369808         push word ptr [0x898]
  021861  11F1: ff369608         push word ptr [0x896]
  021865  11F5: 9a46011f19       lcall 0x191f, 0x146
  02186A  11FA: 83c408           add sp, 8
  02186D  11FD: 6a01             push 1
  02186F  11FF: 680403           push 0x304
  021872  1202: ff369808         push word ptr [0x898]
  021876  1206: ff369608         push word ptr [0x896]
  02187A  120A: 9a46011f19       lcall 0x191f, 0x146
  02187F  120F: 83c408           add sp, 8
  021882  1212: 6a01             push 1
  021884  1214: 681003           push 0x310
  021887  1217: ff369808         push word ptr [0x898]
  02188B  121B: ff369608         push word ptr [0x896]
  02188F  121F: 9a46011f19       lcall 0x191f, 0x146
  021894  1224: 83c408           add sp, 8
  021897  1227: 6a01             push 1
  021899  1229: 683103           push 0x331
  02189C  122C: ff369808         push word ptr [0x898]
  0218A0  1230: ff369608         push word ptr [0x896]
  0218A4  1234: 9a3a011f19       lcall 0x191f, 0x13a
  0218A9  1239: 83c408           add sp, 8
  0218AC  123C: 6a01             push 1
  0218AE  123E: 680303           push 0x303
  0218B1  1241: ff369808         push word ptr [0x898]
  0218B5  1245: ff369608         push word ptr [0x896]
  0218B9  1249: 9a3a011f19       lcall 0x191f, 0x13a
  0218BE  124E: 83c408           add sp, 8
  0218C1  1251: 6a01             push 1
  0218C3  1253: 681003           push 0x310
  0218C6  1256: ff369808         push word ptr [0x898]
  0218CA  125A: ff369608         push word ptr [0x896]
  0218CE  125E: 9a3a011f19       lcall 0x191f, 0x13a
  0218D3  1263: 83c408           add sp, 8
  0218D6  1266: 6a01             push 1
  0218D8  1268: 681103           push 0x311
  0218DB  126B: ff369808         push word ptr [0x898]
  0218DF  126F: ff369608         push word ptr [0x896]
  0218E3  1273: 9a3a011f19       lcall 0x191f, 0x13a
  0218E8  1278: 83c408           add sp, 8
  0218EB  127B: 6a01             push 1
  0218ED  127D: 681203           push 0x312
  0218F0  1280: ff369808         push word ptr [0x898]
  0218F4  1284: ff369608         push word ptr [0x896]
  0218F8  1288: 9a3a011f19       lcall 0x191f, 0x13a
  0218FD  128D: 83c408           add sp, 8
  021900  1290: 6a01             push 1
  021902  1292: 681303           push 0x313
  021905  1295: ff369808         push word ptr [0x898]
  021909  1299: ff369608         push word ptr [0x896]
  02190D  129D: 9a3a011f19       lcall 0x191f, 0x13a
  021912  12A2: 83c408           add sp, 8
  021915  12A5: 6a01             push 1
  021917  12A7: 681403           push 0x314
  02191A  12AA: ff369808         push word ptr [0x898]
  02191E  12AE: ff369608         push word ptr [0x896]
  021922  12B2: 9a3a011f19       lcall 0x191f, 0x13a
  021927  12B7: 83c408           add sp, 8
  02192A  12BA: 6a01             push 1
  02192C  12BC: 681503           push 0x315
  02192F  12BF: ff369808         push word ptr [0x898]
  021933  12C3: ff369608         push word ptr [0x896]
  021937  12C7: 9a3a011f19       lcall 0x191f, 0x13a
  02193C  12CC: 83c408           add sp, 8
  02193F  12CF: 6a01             push 1
  021941  12D1: 681603           push 0x316
  021944  12D4: ff369808         push word ptr [0x898]
  021948  12D8: ff369608         push word ptr [0x896]
  02194C  12DC: 9a3a011f19       lcall 0x191f, 0x13a
  021951  12E1: 83c408           add sp, 8
  021954  12E4: 6a01             push 1
  021956  12E6: 681703           push 0x317
  021959  12E9: ff369808         push word ptr [0x898]
  02195D  12ED: ff369608         push word ptr [0x896]
  021961  12F1: 9a3a011f19       lcall 0x191f, 0x13a
  021966  12F6: 83c408           add sp, 8
  021969  12F9: 6a01             push 1
  02196B  12FB: 682303           push 0x323
  02196E  12FE: ff369808         push word ptr [0x898]
  021972  1302: ff369608         push word ptr [0x896]
  021976  1306: 9a3a011f19       lcall 0x191f, 0x13a
  02197B  130B: 83c408           add sp, 8
  02197E  130E: 6a01             push 1
  021980  1310: 682003           push 0x320
  021983  1313: ff369808         push word ptr [0x898]
  021987  1317: ff369608         push word ptr [0x896]
  02198B  131B: 9a3a011f19       lcall 0x191f, 0x13a
  021990  1320: 83c408           add sp, 8
  021993  1323: 6a01             push 1
  021995  1325: 682103           push 0x321
  021998  1328: ff369808         push word ptr [0x898]
  02199C  132C: ff369608         push word ptr [0x896]
  0219A0  1330: 9a3a011f19       lcall 0x191f, 0x13a
  0219A5  1335: 83c408           add sp, 8
  0219A8  1338: 6a01             push 1
  0219AA  133A: 682203           push 0x322
  0219AD  133D: ff369808         push word ptr [0x898]
  0219B1  1341: ff369608         push word ptr [0x896]
  0219B5  1345: 9a3a011f19       lcall 0x191f, 0x13a
  0219BA  134A: 83c408           add sp, 8
  0219BD  134D: 6a01             push 1
  0219BF  134F: 68ff00           push 0xff
  0219C2  1352: ff369808         push word ptr [0x898]
  0219C6  1356: ff369608         push word ptr [0x896]
  0219CA  135A: 9a3a011f19       lcall 0x191f, 0x13a
  0219CF  135F: 83c408           add sp, 8
  0219D2  1362: 6a01             push 1
  0219D4  1364: 680001           push 0x100
  0219D7  1367: ff369808         push word ptr [0x898]
  0219DB  136B: ff369608         push word ptr [0x896]
  0219DF  136F: 9a3a011f19       lcall 0x191f, 0x13a
  0219E4  1374: 83c408           add sp, 8
  0219E7  1377: cb               retf 

; ---- func_0219E8  size=44  insns=16  prologue=push bp;mov bp,sp  terminal=RETF ----
  0219E8  1378: 55               push bp
  0219E9  1379: 8bec             mov bp, sp
  0219EB  137B: ff7606           push word ptr [bp + 6]
  0219EE  137E: 9a780b1f18       lcall 0x181f, 0xb78
  0219F3  1383: 8be5             mov sp, bp
  0219F5  1385: 0bc0             or ax, ax
  0219F7  1387: 7c07             jl 0x1390
  0219F9  1389: 8b5e08           mov bx, word ptr [bp + 8]
  0219FC  138C: c7070100         mov word ptr [bx], 1
  021A00  1390: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  021A04  1394: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  021A09  1399: 7507             jne 0x13a2
  021A0B  139B: 8b5e0a           mov bx, word ptr [bp + 0xa]
  021A0E  139E: c7070100         mov word ptr [bx], 1
  021A12  13A2: c9               leave 
  021A13  13A3: cb               retf 

; ---- func_021A14  size=797  insns=247  prologue=ENTER 0x000C,0  terminal=RETF ----
  021A14  13A4: c80c0000         enter 0xc, 0
  021A18  13A8: a19253           mov ax, word ptr [0x5392]
  021A1B  13AB: 8946f4           mov word ptr [bp - 0xc], ax
  021A1E  13AE: 833e905300       cmp word ptr [0x5390], 0
  021A23  13B3: 7403             je 0x13b8
  021A25  13B5: e90703           jmp 0x16bf
  021A28  13B8: ff369808         push word ptr [0x898]
  021A2C  13BC: ff369608         push word ptr [0x896]
  021A30  13C0: 9a5e011f19       lcall 0x191f, 0x15e
  021A35  13C5: 83c404           add sp, 4
  021A38  13C8: ff369808         push word ptr [0x898]
  021A3C  13CC: ff369608         push word ptr [0x896]
  021A40  13D0: 9a52011f19       lcall 0x191f, 0x152
  021A45  13D5: 83c404           add sp, 4
  021A48  13D8: 6b5ef41c         imul bx, word ptr [bp - 0xc], 0x1c
  021A4C  13DC: 8a874431         mov al, byte ptr [bx + 0x3144]
  021A50  13E0: 2ae4             sub ah, ah
  021A52  13E2: 8946fa           mov word ptr [bp - 6], ax
  021A55  13E5: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  021A59  13E9: 2aed             sub ch, ch
  021A5B  13EB: 894ef8           mov word ptr [bp - 8], cx
  021A5E  13EE: 51               push cx
  021A5F  13EF: 50               push ax
  021A60  13F0: 9a8c071f18       lcall 0x181f, 0x78c
  021A65  13F5: 83c404           add sp, 4
  021A68  13F8: 8846fc           mov byte ptr [bp - 4], al
  021A6B  13FB: 2bc0             sub ax, ax
  021A6D  13FD: 8946f6           mov word ptr [bp - 0xa], ax
  021A70  1400: 8946fe           mov word ptr [bp - 2], ax
  021A73  1403: ff76f4           push word ptr [bp - 0xc]
  021A76  1406: 9a780b1f18       lcall 0x181f, 0xb78
  021A7B  140B: 83c402           add sp, 2
  021A7E  140E: 0bc0             or ax, ax
  021A80  1410: 7c12             jl 0x1424
  021A82  1412: 8d46fe           lea ax, [bp - 2]
  021A85  1415: 50               push ax
  021A86  1416: 8d46f6           lea ax, [bp - 0xa]
  021A89  1419: 50               push ax
  021A8A  141A: ff76f4           push word ptr [bp - 0xc]
  021A8D  141D: 0e               push cs
  021A8E  141E: e83731           call 0x4558
  021A91  1421: 83c406           add sp, 6
  021A94  1424: 6a01             push 1
  021A96  1426: 681703           push 0x317
  021A99  1429: ff369808         push word ptr [0x898]
  021A9D  142D: ff369608         push word ptr [0x896]
  021AA1  1431: 9a3a011f19       lcall 0x191f, 0x13a
  021AA6  1436: 83c408           add sp, 8
  021AA9  1439: 837ef600         cmp word ptr [bp - 0xa], 0
  021AAD  143D: 751d             jne 0x145c
  021AAF  143F: 6a01             push 1
  021AB1  1441: 681003           push 0x310
  021AB4  1444: ff369808         push word ptr [0x898]
  021AB8  1448: ff369608         push word ptr [0x896]
  021ABC  144C: 9a3a011f19       lcall 0x191f, 0x13a
  021AC1  1451: 83c408           add sp, 8
  021AC4  1454: 6a01             push 1
  021AC6  1456: 681103           push 0x311
  021AC9  1459: eb18             jmp 0x1473
  021ACB  145B: 90               nop 
  021ACC  145C: ff76f8           push word ptr [bp - 8]
  021ACF  145F: ff76fa           push word ptr [bp - 6]
  021AD2  1462: 9abe071f18       lcall 0x181f, 0x7be
  021AD7  1467: 83c404           add sp, 4
  021ADA  146A: 0bc0             or ax, ax
  021ADC  146C: 7c14             jl 0x1482
  021ADE  146E: 6a01             push 1
  021AE0  1470: 681003           push 0x310
  021AE3  1473: ff369808         push word ptr [0x898]
  021AE7  1477: ff369608         push word ptr [0x896]
  021AEB  147B: 9a3a011f19       lcall 0x191f, 0x13a
  021AF0  1480: eb32             jmp 0x14b4
  021AF2  1482: 6a01             push 1
  021AF4  1484: 681103           push 0x311
  021AF7  1487: ff369808         push word ptr [0x898]
  021AFB  148B: ff369608         push word ptr [0x896]
  021AFF  148F: 9a3a011f19       lcall 0x191f, 0x13a
  021B04  1494: 83c408           add sp, 8
  021B07  1497: 6b5ef41c         imul bx, word ptr [bp - 0xc], 0x1c
  021B0B  149B: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  021B10  14A0: 7515             jne 0x14b7
  021B12  14A2: 6a01             push 1
  021B14  14A4: 681003           push 0x310
  021B17  14A7: ff369808         push word ptr [0x898]
  021B1B  14AB: ff369608         push word ptr [0x896]
  021B1F  14AF: 9a46011f19       lcall 0x191f, 0x146
  021B24  14B4: 83c408           add sp, 8
  021B27  14B7: 837efe00         cmp word ptr [bp - 2], 0
  021B2B  14BB: 753f             jne 0x14fc
  021B2D  14BD: 6a01             push 1
  021B2F  14BF: 681203           push 0x312
  021B32  14C2: ff369808         push word ptr [0x898]
  021B36  14C6: ff369608         push word ptr [0x896]
  021B3A  14CA: 9a46011f19       lcall 0x191f, 0x146
  021B3F  14CF: 83c408           add sp, 8
  021B42  14D2: 6a01             push 1
  021B44  14D4: 681303           push 0x313
  021B47  14D7: ff369808         push word ptr [0x898]
  021B4B  14DB: ff369608         push word ptr [0x896]
  021B4F  14DF: 9a46011f19       lcall 0x191f, 0x146
  021B54  14E4: 83c408           add sp, 8
  021B57  14E7: 6a01             push 1
  021B59  14E9: 681403           push 0x314
  021B5C  14EC: ff369808         push word ptr [0x898]
  021B60  14F0: ff369608         push word ptr [0x896]
  021B64  14F4: 9a46011f19       lcall 0x191f, 0x146
  021B69  14F9: 83c408           add sp, 8
  021B6C  14FC: 807efc08         cmp byte ptr [bp - 4], 8
  021B70  1500: 7206             jb 0x1508
  021B72  1502: 807efc10         cmp byte ptr [bp - 4], 0x10
  021B76  1506: 720c             jb 0x1514
  021B78  1508: 807efc10         cmp byte ptr [bp - 4], 0x10
  021B7C  150C: 720e             jb 0x151c
  021B7E  150E: 807efc18         cmp byte ptr [bp - 4], 0x18
  021B82  1512: 7308             jae 0x151c
  021B84  1514: 6a01             push 1
  021B86  1516: 681303           push 0x313
  021B89  1519: eb06             jmp 0x1521
  021B8B  151B: 90               nop 
  021B8C  151C: 6a01             push 1
  021B8E  151E: 681203           push 0x312
  021B91  1521: ff369808         push word ptr [0x898]
  021B95  1525: ff369608         push word ptr [0x896]
  021B99  1529: 9a3a011f19       lcall 0x191f, 0x13a
  021B9E  152E: 83c408           add sp, 8
  021BA1  1531: 807efc1b         cmp byte ptr [bp - 4], 0x1b
  021BA5  1535: 7406             je 0x153d
  021BA7  1537: 807efc1c         cmp byte ptr [bp - 4], 0x1c
  021BAB  153B: 752a             jne 0x1567
  021BAD  153D: 6a01             push 1
  021BAF  153F: 681303           push 0x313
  021BB2  1542: ff369808         push word ptr [0x898]
  021BB6  1546: ff369608         push word ptr [0x896]
  021BBA  154A: 9a3a011f19       lcall 0x191f, 0x13a
  021BBF  154F: 83c408           add sp, 8
  021BC2  1552: 6a01             push 1
  021BC4  1554: 681203           push 0x312
  021BC7  1557: ff369808         push word ptr [0x898]
  021BCB  155B: ff369608         push word ptr [0x896]
  021BCF  155F: 9a3a011f19       lcall 0x191f, 0x13a
  021BD4  1564: 83c408           add sp, 8
  021BD7  1567: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  021BDC  156C: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  021BE1  1571: 723f             jb 0x15b2
  021BE3  1573: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  021BE8  1578: 7738             ja 0x15b2
  021BEA  157A: 807efc1a         cmp byte ptr [bp - 4], 0x1a
  021BEE  157E: 7415             je 0x1595
  021BF0  1580: 6a01             push 1
  021BF2  1582: 682303           push 0x323
  021BF5  1585: ff369808         push word ptr [0x898]
  021BF9  1589: ff369608         push word ptr [0x896]
  021BFD  158D: 9a46011f19       lcall 0x191f, 0x146
  021C02  1592: 83c408           add sp, 8
  021C05  1595: 6a01             push 1
  021C07  1597: 682103           push 0x321
  021C0A  159A: ff369808         push word ptr [0x898]
  021C0E  159E: ff369608         push word ptr [0x896]
  021C12  15A2: 9a3a011f19       lcall 0x191f, 0x13a
  021C17  15A7: 83c408           add sp, 8
  021C1A  15AA: 6a01             push 1
  021C1C  15AC: 680203           push 0x302
  021C1F  15AF: eb30             jmp 0x15e1
  021C21  15B1: 90               nop 
  021C22  15B2: 6a01             push 1
  021C24  15B4: 682303           push 0x323
  021C27  15B7: ff369808         push word ptr [0x898]
  021C2B  15BB: ff369608         push word ptr [0x896]
  021C2F  15BF: 9a3a011f19       lcall 0x191f, 0x13a
  021C34  15C4: 83c408           add sp, 8
  021C37  15C7: 6a01             push 1
  021C39  15C9: 682003           push 0x320
  021C3C  15CC: ff369808         push word ptr [0x898]
  021C40  15D0: ff369608         push word ptr [0x896]
  021C44  15D4: 9a3a011f19       lcall 0x191f, 0x13a
  021C49  15D9: 83c408           add sp, 8
  021C4C  15DC: 6a01             push 1
  021C4E  15DE: 680303           push 0x303
  021C51  15E1: ff369808         push word ptr [0x898]
  021C55  15E5: ff369608         push word ptr [0x896]
  021C59  15E9: 9a3a011f19       lcall 0x191f, 0x13a
  021C5E  15EE: 83c408           add sp, 8
  021C61  15F1: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  021C66  15F6: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  021C6A  15FA: 2aff             sub bh, bh
  021C6C  15FC: 8bc3             mov ax, bx
  021C6E  15FE: d1e3             shl bx, 1
  021C70  1600: 03d8             add bx, ax
  021C72  1602: d1e3             shl bx, 1
  021C74  1604: 03d8             add bx, ax
  021C76  1606: d1e3             shl bx, 1
  021C78  1608: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  021C7D  160D: 745f             je 0x166e
  021C7F  160F: ff76f8           push word ptr [bp - 8]
  021C82  1612: ff76fa           push word ptr [bp - 6]
  021C85  1615: 9a96061f18       lcall 0x181f, 0x696
  021C8A  161A: 83c404           add sp, 4
  021C8D  161D: 0bc0             or ax, ax
  021C8F  161F: 7d2a             jge 0x164b
  021C91  1621: 6a01             push 1
  021C93  1623: 681503           push 0x315
  021C96  1626: ff369808         push word ptr [0x898]
  021C9A  162A: ff369608         push word ptr [0x896]
  021C9E  162E: 9a46011f19       lcall 0x191f, 0x146
  021CA3  1633: 83c408           add sp, 8
  021CA6  1636: 6a01             push 1
  021CA8  1638: 681603           push 0x316
  021CAB  163B: ff369808         push word ptr [0x898]
  021CAF  163F: ff369608         push word ptr [0x896]
  021CB3  1643: 9a46011f19       lcall 0x191f, 0x146
  021CB8  1648: 83c408           add sp, 8
  021CBB  164B: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  021CC0  1650: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  021CC5  1655: 7568             jne 0x16bf
  021CC7  1657: 6a01             push 1
  021CC9  1659: 683103           push 0x331
  021CCC  165C: ff369808         push word ptr [0x898]
  021CD0  1660: ff369608         push word ptr [0x896]
  021CD4  1664: 9a46011f19       lcall 0x191f, 0x146
  021CD9  1669: 83c408           add sp, 8
  021CDC  166C: c9               leave 
  021CDD  166D: cb               retf 
  021CDE  166E: 6a01             push 1
  021CE0  1670: 681503           push 0x315
  021CE3  1673: ff369808         push word ptr [0x898]
  021CE7  1677: ff369608         push word ptr [0x896]
  021CEB  167B: 9a3a011f19       lcall 0x191f, 0x13a
  021CF0  1680: 83c408           add sp, 8
  021CF3  1683: 6a01             push 1
  021CF5  1685: 681603           push 0x316
  021CF8  1688: ff369808         push word ptr [0x898]
  021CFC  168C: ff369608         push word ptr [0x896]
  021D00  1690: 9a3a011f19       lcall 0x191f, 0x13a
  021D05  1695: 83c408           add sp, 8
  021D08  1698: 6a01             push 1
  021D0A  169A: 682203           push 0x322
  021D0D  169D: ff369808         push word ptr [0x898]
  021D11  16A1: ff369608         push word ptr [0x896]
  021D15  16A5: 9a3a011f19       lcall 0x191f, 0x13a
  021D1A  16AA: 83c408           add sp, 8
  021D1D  16AD: 6a01             push 1
  021D1F  16AF: 683103           push 0x331
  021D22  16B2: ff369808         push word ptr [0x898]
  021D26  16B6: ff369608         push word ptr [0x896]
  021D2A  16BA: 9a3a011f19       lcall 0x191f, 0x13a
  021D2F  16BF: c9               leave 
  021D30  16C0: cb               retf 

; ---- func_021D32  size=320  insns=103  prologue=ENTER 0x0004,0  terminal=RETF ----
  021D32  16C2: c8040000         enter 4, 0
  021D36  16C6: c746fe0000       mov word ptr [bp - 2], 0
  021D3B  16CB: 833e905301       cmp word ptr [0x5390], 1
  021D40  16D0: 1bc0             sbb ax, ax
  021D42  16D2: 40               inc ax
  021D43  16D3: 8946fc           mov word ptr [bp - 4], ax
  021D46  16D6: 833e925300       cmp word ptr [0x5392], 0
  021D4B  16DB: 7c33             jl 0x1710
  021D4D  16DD: c706a21e0000     mov word ptr [0x1ea2], 0
  021D53  16E3: a19253           mov ax, word ptr [0x5392]
  021D56  16E6: 9aa0071f18       lcall 0x181f, 0x7a0
  021D5B  16EB: 6a01             push 1
  021D5D  16ED: 6a01             push 1
  021D5F  16EF: 6a01             push 1
  021D61  16F1: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  021D66  16F6: 8a874531         mov al, byte ptr [bx + 0x3145]
  021D6A  16FA: 2ae4             sub ah, ah
  021D6C  16FC: 50               push ax
  021D6D  16FD: 8a874431         mov al, byte ptr [bx + 0x3144]
  021D71  1701: 50               push ax
  021D72  1702: 9aba091f18       lcall 0x181f, 0x9ba
  021D77  1707: 83c40a           add sp, 0xa
  021D7A  170A: c706a21e0100     mov word ptr [0x1ea2], 1
  021D80  1710: a19253           mov ax, word ptr [0x5392]
  021D83  1713: 9af4071f18       lcall 0x181f, 0x7f4
  021D88  1718: 0bc0             or ax, ax
  021D8A  171A: 7406             je 0x1722
  021D8C  171C: 837e0600         cmp word ptr [bp + 6], 0
  021D90  1720: 743c             je 0x175e
  021D92  1722: a19253           mov ax, word ptr [0x5392]
  021D95  1725: 9a30081f18       lcall 0x181f, 0x830
  021D9A  172A: 50               push ax
  021D9B  172B: 9a6c081f18       lcall 0x181f, 0x86c
  021DA0  1730: 83c402           add sp, 2
  021DA3  1733: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  021DA8  1738: 8a874c31         mov al, byte ptr [bx + 0x314c]
  021DAC  173C: 2ae4             sub ah, ah
  021DAE  173E: 2d0500           sub ax, 5
  021DB1  1741: 7c0a             jl 0x174d
  021DB3  1743: 48               dec ax
  021DB4  1744: 7e0e             jle 0x1754
  021DB6  1746: 48               dec ax
  021DB7  1747: 48               dec ax
  021DB8  1748: 7c03             jl 0x174d
  021DBA  174A: 48               dec ax
  021DBB  174B: 7e07             jle 0x1754
  021DBD  174D: c746fc0100       mov word ptr [bp - 4], 1
  021DC2  1752: eb0a             jmp 0x175e
  021DC4  1754: c746fc0000       mov word ptr [bp - 4], 0
  021DC9  1759: c746fe0100       mov word ptr [bp - 2], 1
  021DCE  175E: 833e925300       cmp word ptr [0x5392], 0
  021DD3  1763: 7c69             jl 0x17ce
  021DD5  1765: 2bc0             sub ax, ax
  021DD7  1767: a39053           mov word ptr [0x5390], ax
  021DDA  176A: a3c653           mov word ptr [0x53c6], ax
  021DDD  176D: 3946fe           cmp word ptr [bp - 2], ax
  021DE0  1770: 7556             jne 0x17c8
  021DE2  1772: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  021DE7  1777: 8a874531         mov al, byte ptr [bx + 0x3145]
  021DEB  177B: 2ae4             sub ah, ah
  021DED  177D: 50               push ax
  021DEE  177E: 8a874431         mov al, byte ptr [bx + 0x3144]
  021DF2  1782: 50               push ax
  021DF3  1783: 9a02031f18       lcall 0x181f, 0x302
  021DF8  1788: 83c404           add sp, 4
  021DFB  178B: 0bc0             or ax, ax
  021DFD  178D: 7439             je 0x17c8
  021DFF  178F: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  021E04  1794: 8a874531         mov al, byte ptr [bx + 0x3145]
  021E08  1798: 2ae4             sub ah, ah
  021E0A  179A: 50               push ax
  021E0B  179B: 8a874431         mov al, byte ptr [bx + 0x3144]
  021E0F  179F: 50               push ax
  021E10  17A0: 9ab80d1f18       lcall 0x181f, 0xdb8
  021E15  17A5: 83c404           add sp, 4
  021E18  17A8: 837efc00         cmp word ptr [bp - 4], 0
  021E1C  17AC: 741a             je 0x17c8
  021E1E  17AE: 6a00             push 0
  021E20  17B0: ff363e85         push word ptr [0x853e]
  021E24  17B4: ff364085         push word ptr [0x8540]
  021E28  17B8: ff363e85         push word ptr [0x853e]
  021E2C  17BC: ff364085         push word ptr [0x8540]
  021E30  17C0: 9a52031f18       lcall 0x181f, 0x352
  021E35  17C5: 83c40a           add sp, 0xa
  021E38  17C8: 0e               push cs
  021E39  17C9: e89b2d           call 0x4567
  021E3C  17CC: eb1e             jmp 0x17ec
  021E3E  17CE: c706c6530100     mov word ptr [0x53c6], 1
  021E44  17D4: 0e               push cs
  021E45  17D5: e85d2d           call 0x4535
  021E48  17D8: 833eb09700       cmp word ptr [0x97b0], 0
  021E4D  17DD: 740d             je 0x17ec
  021E4F  17DF: f606835308       test byte ptr [0x5383], 8
  021E54  17E4: 7506             jne 0x17ec
  021E56  17E6: c706c4530000     mov word ptr [0x53c4], 0
  021E5C  17EC: 833e925300       cmp word ptr [0x5392], 0
  021E61  17F1: 7c0a             jl 0x17fd
  021E63  17F3: f606825380       test byte ptr [0x5382], 0x80
  021E68  17F8: 7403             je 0x17fd
  021E6A  17FA: e8e3f0           call 0x8e0
  021E6D  17FD: 8b46fe           mov ax, word ptr [bp - 2]
  021E70  1800: c9               leave 
  021E71  1801: cb               retf 

; ---- func_021E72  size=107  insns=39  prologue=push bp;mov bp,sp  terminal=RETF ----
  021E72  1802: 55               push bp
  021E73  1803: 8bec             mov bp, sp
  021E75  1805: 8b4606           mov ax, word ptr [bp + 6]
  021E78  1808: 0bc0             or ax, ax
  021E7A  180A: 7d02             jge 0x180e
  021E7C  180C: 2bc0             sub ax, ax
  021E7E  180E: 894606           mov word ptr [bp + 6], ax
  021E81  1811: 3d0300           cmp ax, 3
  021E84  1814: 7e03             jle 0x1819
  021E86  1816: b80300           mov ax, 3
  021E89  1819: 894606           mov word ptr [bp + 6], ax
  021E8C  181C: a38401           mov word ptr [0x184], ax
  021E8F  181F: 9a8e011f19       lcall 0x191f, 0x18e
  021E94  1824: 6a00             push 0
  021E96  1826: ff363e85         push word ptr [0x853e]
  021E9A  182A: ff364085         push word ptr [0x8540]
  021E9E  182E: ff363e85         push word ptr [0x853e]
  021EA2  1832: ff364085         push word ptr [0x8540]
  021EA6  1836: 9a52031f18       lcall 0x181f, 0x352
  021EAB  183B: 8be5             mov sp, bp
  021EAD  183D: 0bc0             or ax, ax
  021EAF  183F: 7507             jne 0x1848
  021EB1  1841: 6a01             push 1
  021EB3  1843: 9a1c0e1f18       lcall 0x181f, 0xe1c
  021EB8  1848: c9               leave 
  021EB9  1849: cb               retf 
  021EBA  184A: 6a01             push 1
  021EBC  184C: 0e               push cs
  021EBD  184D: e8902c           call 0x44e0
  021EC0  1850: 83c402           add sp, 2
  021EC3  1853: cb               retf 
  021EC4  1854: ff369253         push word ptr [0x5392]
  021EC8  1858: 9a34091f18       lcall 0x181f, 0x934
  021ECD  185D: 83c402           add sp, 2
  021ED0  1860: cb               retf 
  021ED1  1861: 90               nop 
  021ED2  1862: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  021ED7  1867: c6874c3100       mov byte ptr [bx + 0x314c], 0
  021EDC  186C: cb               retf 

; ---- func_021EDE  size=275  insns=91  prologue=ENTER 0x005E,0  terminal=RETF ----
  021EDE  186E: c85e0000         enter 0x5e, 0
  021EE2  1872: a19253           mov ax, word ptr [0x5392]
  021EE5  1875: 8946a2           mov word ptr [bp - 0x5e], ax
  021EE8  1878: 6bd81c           imul bx, ax, 0x1c
  021EEB  187B: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  021EF0  1880: 7503             jne 0x1885
  021EF2  1882: e9e900           jmp 0x196e
  021EF5  1885: 2bd2             sub dx, dx
  021EF7  1887: 89165e1f         mov word ptr [0x1f5e], dx
  021EFB  188B: 8d1e7c08         lea bx, [0x87c]
  021EFF  188F: 8d062809         lea ax, [0x928]
  021F03  1893: 9a82011f19       lcall 0x191f, 0x182
  021F08  1898: 8946ac           mov word ptr [bp - 0x54], ax
  021F0B  189B: 8956ae           mov word ptr [bp - 0x52], dx
  021F0E  189E: 0bd0             or dx, ax
  021F10  18A0: 7503             jne 0x18a5
  021F12  18A2: e9c900           jmp 0x196e
  021F15  18A5: 6a63             push 0x63
  021F17  18A7: ff36fa2d         push word ptr [0x2dfa]
  021F1B  18AB: 9a22001f18       lcall 0x181f, 0x22
  021F20  18B0: 83c402           add sp, 2
  021F23  18B3: 52               push dx
  021F24  18B4: 50               push ax
  021F25  18B5: ff76ae           push word ptr [bp - 0x52]
  021F28  18B8: ff76ac           push word ptr [bp - 0x54]
  021F2B  18BB: 9a76011f19       lcall 0x191f, 0x176
  021F30  18C0: 83c40a           add sp, 0xa
  021F33  18C3: c746a60000       mov word ptr [bp - 0x5a], 0
  021F38  18C8: eb70             jmp 0x193a
  021F3A  18CA: ff76a6           push word ptr [bp - 0x5a]
  021F3D  18CD: ff76a2           push word ptr [bp - 0x5e]
  021F40  18D0: 9ae60b1f18       lcall 0x181f, 0xbe6
  021F45  18D5: 83c404           add sp, 4
  021F48  18D8: 8946a4           mov word ptr [bp - 0x5c], ax
  021F4B  18DB: c646b000         mov byte ptr [bp - 0x50], 0
  021F4F  18DF: ff76a6           push word ptr [bp - 0x5a]
  021F52  18E2: ff76a2           push word ptr [bp - 0x5e]
  021F55  18E5: 9a680c1f18       lcall 0x181f, 0xc68
  021F5A  18EA: 83c404           add sp, 4
  021F5D  18ED: 8946aa           mov word ptr [bp - 0x56], ax
  021F60  18F0: 50               push ax
  021F61  18F1: 8d46b0           lea ax, [bp - 0x50]
  021F64  18F4: 16               push ss
  021F65  18F5: 50               push ax
  021F66  18F6: 9a82011f18       lcall 0x181f, 0x182
  021F6B  18FB: 83c406           add sp, 6
  021F6E  18FE: 8d46b0           lea ax, [bp - 0x50]
  021F71  1901: 50               push ax
  021F72  1902: 9a78011f18       lcall 0x181f, 0x178
  021F77  1907: 83c402           add sp, 2
  021F7A  190A: 8b5ea4           mov bx, word ptr [bp - 0x5c]
  021F7D  190D: d1e3             shl bx, 1
  021F7F  190F: ffb7c097         push word ptr [bx - 0x6840]
  021F83  1913: 8d46b0           lea ax, [bp - 0x50]
  021F86  1916: 50               push ax
  021F87  1917: 9a6e011f18       lcall 0x181f, 0x16e
  021F8C  191C: 83c404           add sp, 4
  021F8F  191F: 8b46a6           mov ax, word ptr [bp - 0x5a]
  021F92  1922: 40               inc ax
  021F93  1923: 50               push ax
  021F94  1924: 8d46b0           lea ax, [bp - 0x50]
  021F97  1927: 16               push ss
  021F98  1928: 50               push ax
  021F99  1929: ff76ae           push word ptr [bp - 0x52]
  021F9C  192C: ff76ac           push word ptr [bp - 0x54]
  021F9F  192F: 9a76011f19       lcall 0x191f, 0x176
  021FA4  1934: 83c40a           add sp, 0xa
  021FA7  1937: ff46a6           inc word ptr [bp - 0x5a]
  021FAA  193A: 6b5ea21c         imul bx, word ptr [bp - 0x5e], 0x1c
  021FAE  193E: 8a875031         mov al, byte ptr [bx + 0x3150]
  021FB2  1942: 2ae4             sub ah, ah
  021FB4  1944: 3b46a6           cmp ax, word ptr [bp - 0x5a]
  021FB7  1947: 7f81             jg 0x18ca
  021FB9  1949: ff76ae           push word ptr [bp - 0x52]
  021FBC  194C: ff76ac           push word ptr [bp - 0x54]
  021FBF  194F: 9a6a011f19       lcall 0x191f, 0x16a
  021FC4  1954: 8946a8           mov word ptr [bp - 0x58], ax
  021FC7  1957: 0bc0             or ax, ax
  021FC9  1959: 7e13             jle 0x196e
  021FCB  195B: 3d6300           cmp ax, 0x63
  021FCE  195E: 740e             je 0x196e
  021FD0  1960: ff4ea8           dec word ptr [bp - 0x58]
  021FD3  1963: ff76a8           push word ptr [bp - 0x58]
  021FD6  1966: ff76a2           push word ptr [bp - 0x5e]
  021FD9  1969: 9aec0a1f18       lcall 0x181f, 0xaec
  021FDE  196E: c7065e1fffff     mov word ptr [0x1f5e], 0xffff
  021FE4  1974: c9               leave 
  021FE5  1975: cb               retf 
  021FE6  1976: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  021FEB  197B: c6874c3101       mov byte ptr [bx + 0x314c], 1
  021FF0  1980: cb               retf 

; ---- func_021FF2  size=299  insns=100  prologue=ENTER 0x0014,0  terminal=RETF ----
  021FF2  1982: c8140000         enter 0x14, 0
  021FF6  1986: 56               push si
  021FF7  1987: a19253           mov ax, word ptr [0x5392]
  021FFA  198A: 8946ee           mov word ptr [bp - 0x12], ax
  021FFD  198D: 6bd81c           imul bx, ax, 0x1c
  022000  1990: 8a874731         mov al, byte ptr [bx + 0x3147]
  022004  1994: 250f00           and ax, 0xf
  022007  1997: 8946ec           mov word ptr [bp - 0x14], ax
  02200A  199A: 8a874431         mov al, byte ptr [bx + 0x3144]
  02200E  199E: 2ae4             sub ah, ah
  022010  19A0: 8946f6           mov word ptr [bp - 0xa], ax
  022013  19A3: 8a874531         mov al, byte ptr [bx + 0x3145]
  022017  19A7: 8946f2           mov word ptr [bp - 0xe], ax
  02201A  19AA: b8ffff           mov ax, 0xffff
  02201D  19AD: 8946f0           mov word ptr [bp - 0x10], ax
  022020  19B0: 8946f4           mov word ptr [bp - 0xc], ax
  022023  19B3: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  022028  19B8: 720a             jb 0x19c4
  02202A  19BA: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  02202F  19BF: 7703             ja 0x19c4
  022031  19C1: e9c500           jmp 0x1a89
  022034  19C4: c746fa0000       mov word ptr [bp - 6], 0
  022039  19C9: eb14             jmp 0x19df
  02203B  19CB: 90               nop 
  02203C  19CC: 50               push ax
  02203D  19CD: ff76ec           push word ptr [bp - 0x14]
  022040  19D0: 9a380a1f18       lcall 0x181f, 0xa38
  022045  19D5: 83c404           add sp, 4
  022048  19D8: a840             test al, 0x40
  02204A  19DA: 755e             jne 0x1a3a
  02204C  19DC: ff46fa           inc word ptr [bp - 6]
  02204F  19DF: 837efa08         cmp word ptr [bp - 6], 8
  022053  19E3: 7d5b             jge 0x1a40
  022055  19E5: 8b5efa           mov bx, word ptr [bp - 6]
  022058  19E8: 8a87be00         mov al, byte ptr [bx + 0xbe]
  02205C  19EC: 98               cwde 
  02205D  19ED: 0346f2           add ax, word ptr [bp - 0xe]
  022060  19F0: 8946fc           mov word ptr [bp - 4], ax
  022063  19F3: 50               push ax
  022064  19F4: 8a87b400         mov al, byte ptr [bx + 0xb4]
  022068  19F8: 98               cwde 
  022069  19F9: 0346f6           add ax, word ptr [bp - 0xa]
  02206C  19FC: 8946fe           mov word ptr [bp - 2], ax
  02206F  19FF: 50               push ax
  022070  1A00: 9a02031f18       lcall 0x181f, 0x302
  022075  1A05: 83c404           add sp, 4
  022078  1A08: 0bc0             or ax, ax
  02207A  1A0A: 74d0             je 0x19dc
  02207C  1A0C: ff76fc           push word ptr [bp - 4]
  02207F  1A0F: ff76fe           push word ptr [bp - 2]
  022082  1A12: 9a68071f18       lcall 0x181f, 0x768
  022087  1A17: 83c404           add sp, 4
  02208A  1A1A: 0bc0             or ax, ax
  02208C  1A1C: 75be             jne 0x19dc
  02208E  1A1E: ff76fc           push word ptr [bp - 4]
  022091  1A21: ff76fe           push word ptr [bp - 2]
  022094  1A24: 9a96061f18       lcall 0x181f, 0x696
  022099  1A29: 83c404           add sp, 4
  02209C  1A2C: 8946f0           mov word ptr [bp - 0x10], ax
  02209F  1A2F: 0bc0             or ax, ax
  0220A1  1A31: 7ca9             jl 0x19dc
  0220A3  1A33: 3b46ec           cmp ax, word ptr [bp - 0x14]
  0220A6  1A36: 7594             jne 0x19cc
  0220A8  1A38: eba2             jmp 0x19dc
  0220AA  1A3A: 8b46f0           mov ax, word ptr [bp - 0x10]
  0220AD  1A3D: 8946f4           mov word ptr [bp - 0xc], ax
  0220B0  1A40: 837ef400         cmp word ptr [bp - 0xc], 0
  0220B4  1A44: 7c43             jl 0x1a89
  0220B6  1A46: ff76f4           push word ptr [bp - 0xc]
  0220B9  1A49: 9a1a0a1f18       lcall 0x181f, 0xa1a
  0220BE  1A4E: 83c402           add sp, 2
  0220C1  1A51: 50               push ax
  0220C2  1A52: 6a00             push 0
  0220C4  1A54: 9a38041f18       lcall 0x181f, 0x438
  0220C9  1A59: 83c404           add sp, 4
  0220CC  1A5C: 6a01             push 1
  0220CE  1A5E: 683209           push 0x932
  0220D1  1A61: 9a52061f18       lcall 0x181f, 0x652
  0220D6  1A66: 83c404           add sp, 4
  0220D9  1A69: 3d0200           cmp ax, 2
  0220DC  1A6C: 753c             jne 0x1aaa
  0220DE  1A6E: 6976f43c01       imul si, word ptr [bp - 0xc], 0x13c
  0220E3  1A73: 8b5eec           mov bx, word ptr [bp - 0x14]
  0220E6  1A76: 80883c8802       or byte ptr [bx + si - 0x77c4], 2
  0220EB  1A7B: 6a40             push 0x40
  0220ED  1A7D: ff76f4           push word ptr [bp - 0xc]
  0220F0  1A80: 53               push bx
  0220F1  1A81: 9a100a1f18       lcall 0x181f, 0xa10
  0220F6  1A86: 83c406           add sp, 6
  0220F9  1A89: b85800           mov ax, 0x58
  0220FC  1A8C: 9ac0041f18       lcall 0x181f, 0x4c0
  022101  1A91: 6b5eee1c         imul bx, word ptr [bp - 0x12], 0x1c
  022105  1A95: c6874c3105       mov byte ptr [bx + 0x314c], 5
  02210A  1A9A: c6875a3100       mov byte ptr [bx + 0x315a], 0
  02210F  1A9F: ff76ee           push word ptr [bp - 0x12]
  022112  1AA2: 9a34091f18       lcall 0x181f, 0x934
  022117  1AA7: 83c402           add sp, 2
  02211A  1AAA: 5e               pop si
  02211B  1AAB: c9               leave 
  02211C  1AAC: cb               retf 

; ---- func_02211E  size=533  insns=178  prologue=ENTER 0x0016,0  terminal=RETF ----
  02211E  1AAE: c8160000         enter 0x16, 0
  022122  1AB2: 2bc0             sub ax, ax
  022124  1AB4: 8946fc           mov word ptr [bp - 4], ax
  022127  1AB7: 8946fa           mov word ptr [bp - 6], ax
  02212A  1ABA: a19253           mov ax, word ptr [0x5392]
  02212D  1ABD: 8946ea           mov word ptr [bp - 0x16], ax
  022130  1AC0: 6bd81c           imul bx, ax, 0x1c
  022133  1AC3: 8a874431         mov al, byte ptr [bx + 0x3144]
  022137  1AC7: 2ae4             sub ah, ah
  022139  1AC9: 8946f2           mov word ptr [bp - 0xe], ax
  02213C  1ACC: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  022140  1AD0: 2aed             sub ch, ch
  022142  1AD2: 894ef0           mov word ptr [bp - 0x10], cx
  022145  1AD5: 51               push cx
  022146  1AD6: 50               push ax
  022147  1AD7: 9a22071f18       lcall 0x181f, 0x722
  02214C  1ADC: 83c404           add sp, 4
  02214F  1ADF: 8946f8           mov word ptr [bp - 8], ax
  022152  1AE2: ff76f0           push word ptr [bp - 0x10]
  022155  1AE5: ff76f2           push word ptr [bp - 0xe]
  022158  1AE8: 9a8c071f18       lcall 0x181f, 0x78c
  02215D  1AED: 83c404           add sp, 4
  022160  1AF0: 8946ee           mov word ptr [bp - 0x12], ax
  022163  1AF3: ff76f0           push word ptr [bp - 0x10]
  022166  1AF6: ff76f2           push word ptr [bp - 0xe]
  022169  1AF9: 9a54071f18       lcall 0x181f, 0x754
  02216E  1AFE: 83c404           add sp, 4
  022171  1B01: a840             test al, 0x40
  022173  1B03: 740f             je 0x1b14
  022175  1B05: 6a03             push 3
  022177  1B07: 683d09           push 0x93d
  02217A  1B0A: 9a52061f18       lcall 0x181f, 0x652
  02217F  1B0F: 83c404           add sp, 4
  022182  1B12: c9               leave 
  022183  1B13: cb               retf 
  022184  1B14: ff76f0           push word ptr [bp - 0x10]
  022187  1B17: ff76f2           push word ptr [bp - 0xe]
  02218A  1B1A: 9a96061f18       lcall 0x181f, 0x696
  02218F  1B1F: 83c404           add sp, 4
  022192  1B22: 0bc0             or ax, ax
  022194  1B24: 7c03             jl 0x1b29
  022196  1B26: e98701           jmp 0x1cb0
  022199  1B29: ff76f8           push word ptr [bp - 8]
  02219C  1B2C: 6aff             push -1
  02219E  1B2E: ff76f0           push word ptr [bp - 0x10]
  0221A1  1B31: ff76f2           push word ptr [bp - 0xe]
  0221A4  1B34: 9a840d1f18       lcall 0x181f, 0xd84
  0221A9  1B39: 83c408           add sp, 8
  0221AC  1B3C: 0bc0             or ax, ax
  0221AE  1B3E: 7d03             jge 0x1b43
  0221B0  1B40: e96d01           jmp 0x1cb0
  0221B3  1B43: ff36528d         push word ptr [0x8d52]
  0221B7  1B47: 9a560a1f18       lcall 0x181f, 0xa56
  0221BC  1B4C: 83c402           add sp, 2
  0221BF  1B4F: 8946f4           mov word ptr [bp - 0xc], ax
  0221C2  1B52: a1b88d           mov ax, word ptr [0x8db8]
  0221C5  1B55: 3946f4           cmp word ptr [bp - 0xc], ax
  0221C8  1B58: 7d03             jge 0x1b5d
  0221CA  1B5A: e95301           jmp 0x1cb0
  0221CD  1B5D: ff369453         push word ptr [0x5394]
  0221D1  1B61: ff36508d         push word ptr [0x8d50]
  0221D5  1B65: 9a380a1f18       lcall 0x181f, 0xa38
  0221DA  1B6A: 83c404           add sp, 4
  0221DD  1B6D: a840             test al, 0x40
  0221DF  1B6F: 7503             jne 0x1b74
  0221E1  1B71: e93c01           jmp 0x1cb0
  0221E4  1B74: ff76f0           push word ptr [bp - 0x10]
  0221E7  1B77: ff76f2           push word ptr [bp - 0xe]
  0221EA  1B7A: 9a54071f18       lcall 0x181f, 0x754
  0221EF  1B7F: 83c404           add sp, 4
  0221F2  1B82: a810             test al, 0x10
  0221F4  1B84: 7403             je 0x1b89
  0221F6  1B86: e92701           jmp 0x1cb0
  0221F9  1B89: 837eee08         cmp word ptr [bp - 0x12], 8
  0221FD  1B8D: 7c06             jl 0x1b95
  0221FF  1B8F: 837eee10         cmp word ptr [bp - 0x12], 0x10
  022203  1B93: 7c12             jl 0x1ba7
  022205  1B95: 837eee10         cmp word ptr [bp - 0x12], 0x10
  022209  1B99: 7d03             jge 0x1b9e
  02220B  1B9B: e91201           jmp 0x1cb0
  02220E  1B9E: 837eee18         cmp word ptr [bp - 0x12], 0x18
  022212  1BA2: 7c03             jl 0x1ba7
  022214  1BA4: e90901           jmp 0x1cb0
  022217  1BA7: ff36508d         push word ptr [0x8d50]
  02221B  1BAB: 9aa4091f18       lcall 0x181f, 0x9a4
  022220  1BB0: 83c402           add sp, 2
  022223  1BB3: 50               push ax
  022224  1BB4: 6a00             push 0
  022226  1BB6: 9a38041f18       lcall 0x181f, 0x438
  02222B  1BBB: 83c404           add sp, 4
  02222E  1BBE: ff76f0           push word ptr [bp - 0x10]
  022231  1BC1: ff76f2           push word ptr [bp - 0xe]
  022234  1BC4: ff369453         push word ptr [0x5394]
  022238  1BC8: ff364c8d         push word ptr [0x8d4c]
  02223C  1BCC: 9a780d1f18       lcall 0x181f, 0xd78
  022241  1BD1: 83c408           add sp, 8
  022244  1BD4: 8946f6           mov word ptr [bp - 0xa], ax
  022247  1BD7: 0bc0             or ax, ax
  022249  1BD9: 7f03             jg 0x1bde
  02224B  1BDB: e9d200           jmp 0x1cb0
  02224E  1BDE: 99               cdq 
  02224F  1BDF: 52               push dx
  022250  1BE0: 50               push ax
  022251  1BE1: 6a01             push 1
  022253  1BE3: 9aae091f18       lcall 0x181f, 0x9ae
  022258  1BE8: 83c406           add sp, 6
  02225B  1BEB: 8d1e7c08         lea bx, [0x87c]
  02225F  1BEF: 8d064409         lea ax, [0x944]
  022263  1BF3: 2bd2             sub dx, dx
  022265  1BF5: 9a82011f19       lcall 0x191f, 0x182
  02226A  1BFA: 8946fa           mov word ptr [bp - 6], ax
  02226D  1BFD: 8956fc           mov word ptr [bp - 4], dx
  022270  1C00: 0bd0             or dx, ax
  022272  1C02: 7503             jne 0x1c07
  022274  1C04: e9ba00           jmp 0x1cc1
  022277  1C07: ff369453         push word ptr [0x5394]
  02227B  1C0B: 9a920a1f18       lcall 0x181f, 0xa92
  022280  1C10: 83c402           add sp, 2
  022283  1C13: 8bc8             mov cx, ax
  022285  1C15: 8b46f6           mov ax, word ptr [bp - 0xa]
  022288  1C18: 8bda             mov bx, dx
  02228A  1C1A: 99               cdq 
  02228B  1C1B: 3bda             cmp bx, dx
  02228D  1C1D: 7f18             jg 0x1c37
  02228F  1C1F: 7c04             jl 0x1c25
  022291  1C21: 3bc8             cmp cx, ax
  022293  1C23: 7312             jae 0x1c37
  022295  1C25: 6a01             push 1
  022297  1C27: 6a02             push 2
  022299  1C29: ff76fc           push word ptr [bp - 4]
  02229C  1C2C: ff76fa           push word ptr [bp - 6]
  02229F  1C2F: 9ab6011f19       lcall 0x191f, 0x1b6
  0222A4  1C34: 83c408           add sp, 8
  0222A7  1C37: a1528d           mov ax, word ptr [0x8d52]
  0222AA  1C3A: a35c1f           mov word ptr [0x1f5c], ax
  0222AD  1C3D: ff76fc           push word ptr [bp - 4]
  0222B0  1C40: ff76fa           push word ptr [bp - 6]
  0222B3  1C43: 9a6a011f19       lcall 0x191f, 0x16a
  0222B8  1C48: 8946fe           mov word ptr [bp - 2], ax
  0222BB  1C4B: ff76fc           push word ptr [bp - 4]
  0222BE  1C4E: ff76fa           push word ptr [bp - 6]
  0222C1  1C51: 9aa8011f19       lcall 0x191f, 0x1a8
  0222C6  1C56: 837efe01         cmp word ptr [bp - 2], 1
  0222CA  1C5A: 7514             jne 0x1c70
  0222CC  1C5C: 6b5eea1c         imul bx, word ptr [bp - 0x16], 0x1c
  0222D0  1C60: c6874c3100       mov byte ptr [bx + 0x314c], 0
  0222D5  1C65: ff76ea           push word ptr [bp - 0x16]
  0222D8  1C68: 9a34091f18       lcall 0x181f, 0x934
  0222DD  1C6D: c9               leave 
  0222DE  1C6E: cb               retf 
  0222DF  1C6F: 90               nop 
  0222E0  1C70: 837efe02         cmp word ptr [bp - 2], 2
  0222E4  1C74: 753a             jne 0x1cb0
  0222E6  1C76: 6a01             push 1
  0222E8  1C78: 6a10             push 0x10
  0222EA  1C7A: ff76f0           push word ptr [bp - 0x10]
  0222ED  1C7D: ff76f2           push word ptr [bp - 0xe]
  0222F0  1C80: 9a8c061f18       lcall 0x181f, 0x68c
  0222F5  1C85: 83c408           add sp, 8
  0222F8  1C88: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0222FC  1C8C: fe4705           inc byte ptr [bx + 5]
  0222FF  1C8F: 8b46f6           mov ax, word ptr [bp - 0xa]
  022302  1C92: 99               cdq 
  022303  1C93: 52               push dx
  022304  1C94: 50               push ax
  022305  1C95: ff369453         push word ptr [0x5394]
  022309  1C99: 9af60a1f18       lcall 0x181f, 0xaf6
  02230E  1C9E: 83c406           add sp, 6
  022311  1CA1: ff36528d         push word ptr [0x8d52]
  022315  1CA5: 685109           push 0x951
  022318  1CA8: 9a9c011f19       lcall 0x191f, 0x19c
  02231D  1CAD: 83c404           add sp, 4
  022320  1CB0: 6b5eea1c         imul bx, word ptr [bp - 0x16], 0x1c
  022324  1CB4: c6874c3108       mov byte ptr [bx + 0x314c], 8
  022329  1CB9: ff76ea           push word ptr [bp - 0x16]
  02232C  1CBC: 9ac2011f19       lcall 0x191f, 0x1c2
  022331  1CC1: c9               leave 
  022332  1CC2: cb               retf 

; ---- func_022334  size=526  insns=177  prologue=ENTER 0x0014,0  terminal=RETF ----
  022334  1CC4: c8140000         enter 0x14, 0
  022338  1CC8: 2bc0             sub ax, ax
  02233A  1CCA: 8946fc           mov word ptr [bp - 4], ax
  02233D  1CCD: 8946fa           mov word ptr [bp - 6], ax
  022340  1CD0: a19253           mov ax, word ptr [0x5392]
  022343  1CD3: 8946ec           mov word ptr [bp - 0x14], ax
  022346  1CD6: 6bd81c           imul bx, ax, 0x1c
  022349  1CD9: 8a874431         mov al, byte ptr [bx + 0x3144]
  02234D  1CDD: 2ae4             sub ah, ah
  02234F  1CDF: 8946f2           mov word ptr [bp - 0xe], ax
  022352  1CE2: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  022356  1CE6: 2aed             sub ch, ch
  022358  1CE8: 894ef0           mov word ptr [bp - 0x10], cx
  02235B  1CEB: 51               push cx
  02235C  1CEC: 50               push ax
  02235D  1CED: 9a22071f18       lcall 0x181f, 0x722
  022362  1CF2: 83c404           add sp, 4
  022365  1CF5: 8946f8           mov word ptr [bp - 8], ax
  022368  1CF8: ff76f0           push word ptr [bp - 0x10]
  02236B  1CFB: ff76f2           push word ptr [bp - 0xe]
  02236E  1CFE: 9a54071f18       lcall 0x181f, 0x754
  022373  1D03: 83c404           add sp, 4
  022376  1D06: a80a             test al, 0xa
  022378  1D08: 7410             je 0x1d1a
  02237A  1D0A: 6a03             push 3
  02237C  1D0C: 685d09           push 0x95d
  02237F  1D0F: 9a52061f18       lcall 0x181f, 0x652
  022384  1D14: 83c404           add sp, 4
  022387  1D17: c9               leave 
  022388  1D18: cb               retf 
  022389  1D19: 90               nop 
  02238A  1D1A: ff76f0           push word ptr [bp - 0x10]
  02238D  1D1D: ff76f2           push word ptr [bp - 0xe]
  022390  1D20: 9a96061f18       lcall 0x181f, 0x696
  022395  1D25: 83c404           add sp, 4
  022398  1D28: 0bc0             or ax, ax
  02239A  1D2A: 7c03             jl 0x1d2f
  02239C  1D2C: e96b01           jmp 0x1e9a
  02239F  1D2F: ff76f8           push word ptr [bp - 8]
  0223A2  1D32: 6aff             push -1
  0223A4  1D34: ff76f0           push word ptr [bp - 0x10]
  0223A7  1D37: ff76f2           push word ptr [bp - 0xe]
  0223AA  1D3A: 9a840d1f18       lcall 0x181f, 0xd84
  0223AF  1D3F: 83c408           add sp, 8
  0223B2  1D42: 8946ee           mov word ptr [bp - 0x12], ax
  0223B5  1D45: 0bc0             or ax, ax
  0223B7  1D47: 7d03             jge 0x1d4c
  0223B9  1D49: e94e01           jmp 0x1e9a
  0223BC  1D4C: ff36528d         push word ptr [0x8d52]
  0223C0  1D50: 9a560a1f18       lcall 0x181f, 0xa56
  0223C5  1D55: 83c402           add sp, 2
  0223C8  1D58: 8946f4           mov word ptr [bp - 0xc], ax
  0223CB  1D5B: a1b88d           mov ax, word ptr [0x8db8]
  0223CE  1D5E: 3946f4           cmp word ptr [bp - 0xc], ax
  0223D1  1D61: 7d03             jge 0x1d66
  0223D3  1D63: e93401           jmp 0x1e9a
  0223D6  1D66: ff369453         push word ptr [0x5394]
  0223DA  1D6A: ff36508d         push word ptr [0x8d50]
  0223DE  1D6E: 9a380a1f18       lcall 0x181f, 0xa38
  0223E3  1D73: 83c404           add sp, 4
  0223E6  1D76: a840             test al, 0x40
  0223E8  1D78: 7503             jne 0x1d7d
  0223EA  1D7A: e91d01           jmp 0x1e9a
  0223ED  1D7D: ff76f0           push word ptr [bp - 0x10]
  0223F0  1D80: ff76f2           push word ptr [bp - 0xe]
  0223F3  1D83: 9a54071f18       lcall 0x181f, 0x754
  0223F8  1D88: 83c404           add sp, 4
  0223FB  1D8B: a810             test al, 0x10
  0223FD  1D8D: 7403             je 0x1d92
  0223FF  1D8F: e90801           jmp 0x1e9a
  022402  1D92: ff36508d         push word ptr [0x8d50]
  022406  1D96: 9aa4091f18       lcall 0x181f, 0x9a4
  02240B  1D9B: 83c402           add sp, 2
  02240E  1D9E: 50               push ax
  02240F  1D9F: 6a00             push 0
  022411  1DA1: 9a38041f18       lcall 0x181f, 0x438
  022416  1DA6: 83c404           add sp, 4
  022419  1DA9: ff76f0           push word ptr [bp - 0x10]
  02241C  1DAC: ff76f2           push word ptr [bp - 0xe]
  02241F  1DAF: ff369453         push word ptr [0x5394]
  022423  1DB3: ff76ee           push word ptr [bp - 0x12]
  022426  1DB6: 9a780d1f18       lcall 0x181f, 0xd78
  02242B  1DBB: 83c408           add sp, 8
  02242E  1DBE: 8946f6           mov word ptr [bp - 0xa], ax
  022431  1DC1: 0bc0             or ax, ax
  022433  1DC3: 7f03             jg 0x1dc8
  022435  1DC5: e9d200           jmp 0x1e9a
  022438  1DC8: 99               cdq 
  022439  1DC9: 52               push dx
  02243A  1DCA: 50               push ax
  02243B  1DCB: 6a01             push 1
  02243D  1DCD: 9aae091f18       lcall 0x181f, 0x9ae
  022442  1DD2: 83c406           add sp, 6
  022445  1DD5: 8d1e7c08         lea bx, [0x87c]
  022449  1DD9: 8d066409         lea ax, [0x964]
  02244D  1DDD: 2bd2             sub dx, dx
  02244F  1DDF: 9a82011f19       lcall 0x191f, 0x182
  022454  1DE4: 8946fa           mov word ptr [bp - 6], ax
  022457  1DE7: 8956fc           mov word ptr [bp - 4], dx
  02245A  1DEA: 0bd0             or dx, ax
  02245C  1DEC: 7503             jne 0x1df1
  02245E  1DEE: e9ba00           jmp 0x1eab
  022461  1DF1: ff369453         push word ptr [0x5394]
  022465  1DF5: 9a920a1f18       lcall 0x181f, 0xa92
  02246A  1DFA: 83c402           add sp, 2
  02246D  1DFD: 8bc8             mov cx, ax
  02246F  1DFF: 8b46f6           mov ax, word ptr [bp - 0xa]
  022472  1E02: 8bda             mov bx, dx
  022474  1E04: 99               cdq 
  022475  1E05: 3bda             cmp bx, dx
  022477  1E07: 7f18             jg 0x1e21
  022479  1E09: 7c04             jl 0x1e0f
  02247B  1E0B: 3bc8             cmp cx, ax
  02247D  1E0D: 7312             jae 0x1e21
  02247F  1E0F: 6a01             push 1
  022481  1E11: 6a02             push 2
  022483  1E13: ff76fc           push word ptr [bp - 4]
  022486  1E16: ff76fa           push word ptr [bp - 6]
  022489  1E19: 9ab6011f19       lcall 0x191f, 0x1b6
  02248E  1E1E: 83c408           add sp, 8
  022491  1E21: a1528d           mov ax, word ptr [0x8d52]
  022494  1E24: a35c1f           mov word ptr [0x1f5c], ax
  022497  1E27: ff76fc           push word ptr [bp - 4]
  02249A  1E2A: ff76fa           push word ptr [bp - 6]
  02249D  1E2D: 9a6a011f19       lcall 0x191f, 0x16a
  0224A2  1E32: 8946fe           mov word ptr [bp - 2], ax
  0224A5  1E35: ff76fc           push word ptr [bp - 4]
  0224A8  1E38: ff76fa           push word ptr [bp - 6]
  0224AB  1E3B: 9aa8011f19       lcall 0x191f, 0x1a8
  0224B0  1E40: 837efe01         cmp word ptr [bp - 2], 1
  0224B4  1E44: 7514             jne 0x1e5a
  0224B6  1E46: 6b5eec1c         imul bx, word ptr [bp - 0x14], 0x1c
  0224BA  1E4A: c6874c3100       mov byte ptr [bx + 0x314c], 0
  0224BF  1E4F: ff76ec           push word ptr [bp - 0x14]
  0224C2  1E52: 9a34091f18       lcall 0x181f, 0x934
  0224C7  1E57: c9               leave 
  0224C8  1E58: cb               retf 
  0224C9  1E59: 90               nop 
  0224CA  1E5A: 837efe02         cmp word ptr [bp - 2], 2
  0224CE  1E5E: 753a             jne 0x1e9a
  0224D0  1E60: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0224D4  1E64: fe4705           inc byte ptr [bx + 5]
  0224D7  1E67: 8b46f6           mov ax, word ptr [bp - 0xa]
  0224DA  1E6A: 99               cdq 
  0224DB  1E6B: 52               push dx
  0224DC  1E6C: 50               push ax
  0224DD  1E6D: ff369453         push word ptr [0x5394]
  0224E1  1E71: 9af60a1f18       lcall 0x181f, 0xaf6
  0224E6  1E76: 83c406           add sp, 6
  0224E9  1E79: 6a01             push 1
  0224EB  1E7B: 6a10             push 0x10
  0224ED  1E7D: ff76f0           push word ptr [bp - 0x10]
  0224F0  1E80: ff76f2           push word ptr [bp - 0xe]
  0224F3  1E83: 9a8c061f18       lcall 0x181f, 0x68c
  0224F8  1E88: 83c408           add sp, 8
  0224FB  1E8B: ff36528d         push word ptr [0x8d52]
  0224FF  1E8F: 686f09           push 0x96f
  022502  1E92: 9a9c011f19       lcall 0x191f, 0x19c
  022507  1E97: 83c404           add sp, 4
  02250A  1E9A: 6b5eec1c         imul bx, word ptr [bp - 0x14], 0x1c
  02250E  1E9E: c6874c3109       mov byte ptr [bx + 0x314c], 9
  022513  1EA3: ff76ec           push word ptr [bp - 0x14]
  022516  1EA6: 9a16021f19       lcall 0x191f, 0x216
  02251B  1EAB: c9               leave 
  02251C  1EAC: cb               retf 
  02251D  1EAD: 90               nop 
  02251E  1EAE: f606825301       test byte ptr [0x5382], 1
  022523  1EB3: 740b             je 0x1ec0
  022525  1EB5: 8d1e7b09         lea bx, [0x97b]
  022529  1EB9: 9afe031f18       lcall 0x181f, 0x3fe
  02252E  1EBE: cb               retf 
  02252F  1EBF: 90               nop 
  022530  1EC0: 9a08021f19       lcall 0x191f, 0x208
  022535  1EC5: ff369253         push word ptr [0x5392]
  022539  1EC9: 9af40d1f18       lcall 0x181f, 0xdf4
  02253E  1ECE: 83c402           add sp, 2
  022541  1ED1: cb               retf 

; ---- func_022542  size=678  insns=240  prologue=ENTER 0x0018,0  terminal=RETF ----
  022542  1ED2: c8180000         enter 0x18, 0
  022546  1ED6: 56               push si
  022547  1ED7: a19253           mov ax, word ptr [0x5392]
  02254A  1EDA: 8946e8           mov word ptr [bp - 0x18], ax
  02254D  1EDD: 6bd81c           imul bx, ax, 0x1c
  022550  1EE0: 8a874531         mov al, byte ptr [bx + 0x3145]
  022554  1EE4: 2ae4             sub ah, ah
  022556  1EE6: 50               push ax
  022557  1EE7: 8a874431         mov al, byte ptr [bx + 0x3144]
  02255B  1EEB: 50               push ax
  02255C  1EEC: 9abe071f18       lcall 0x181f, 0x7be
  022561  1EF1: 83c404           add sp, 4
  022564  1EF4: 8946ea           mov word ptr [bp - 0x16], ax
  022567  1EF7: 8b46e8           mov ax, word ptr [bp - 0x18]
  02256A  1EFA: 8946f6           mov word ptr [bp - 0xa], ax
  02256D  1EFD: f606825301       test byte ptr [0x5382], 1
  022572  1F02: 7410             je 0x1f14
  022574  1F04: 6a01             push 1
  022576  1F06: 688a09           push 0x98a
  022579  1F09: 9a52061f18       lcall 0x181f, 0x652
  02257E  1F0E: 83c404           add sp, 4
  022581  1F11: 5e               pop si
  022582  1F12: c9               leave 
  022583  1F13: cb               retf 
  022584  1F14: 833e9e5330       cmp word ptr [0x539e], 0x30
  022589  1F19: 7d11             jge 0x1f2c
  02258B  1F1B: 6bd81c           imul bx, ax, 0x1c
  02258E  1F1E: 8a9f4731         mov bl, byte ptr [bx + 0x3147]
  022592  1F22: 83e30f           and bx, 0xf
  022595  1F25: 80bf989226       cmp byte ptr [bx - 0x6d68], 0x26
  02259A  1F2A: 7209             jb 0x1f35
  02259C  1F2C: 837eea00         cmp word ptr [bp - 0x16], 0
  0225A0  1F30: 7d03             jge 0x1f35
  0225A2  1F32: e93702           jmp 0x216c
  0225A5  1F35: 837eea00         cmp word ptr [bp - 0x16], 0
  0225A9  1F39: 7c03             jl 0x1f3e
  0225AB  1F3B: e90402           jmp 0x2142
  0225AE  1F3E: 6bd81c           imul bx, ax, 0x1c
  0225B1  1F41: 8a874531         mov al, byte ptr [bx + 0x3145]
  0225B5  1F45: 2ae4             sub ah, ah
  0225B7  1F47: 50               push ax
  0225B8  1F48: 8a874431         mov al, byte ptr [bx + 0x3144]
  0225BC  1F4C: 50               push ax
  0225BD  1F4D: 9a68071f18       lcall 0x181f, 0x768
  0225C2  1F52: 83c404           add sp, 4
  0225C5  1F55: 0bc0             or ax, ax
  0225C7  1F57: 7407             je 0x1f60
  0225C9  1F59: 6a00             push 0
  0225CB  1F5B: 689b09           push 0x99b
  0225CE  1F5E: eba9             jmp 0x1f09
  0225D0  1F60: 6aff             push -1
  0225D2  1F62: 6aff             push -1
  0225D4  1F64: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  0225D8  1F68: 8a874531         mov al, byte ptr [bx + 0x3145]
  0225DC  1F6C: 2ae4             sub ah, ah
  0225DE  1F6E: 50               push ax
  0225DF  1F6F: 8a874431         mov al, byte ptr [bx + 0x3144]
  0225E3  1F73: 50               push ax
  0225E4  1F74: 9a14061f18       lcall 0x181f, 0x614
  0225E9  1F79: 83c408           add sp, 8
  0225EC  1F7C: 0bc0             or ax, ax
  0225EE  1F7E: 7c20             jl 0x1fa0
  0225F0  1F80: 833eb88d01       cmp word ptr [0x8db8], 1
  0225F5  1F85: 7519             jne 0x1fa0
  0225F7  1F87: a14285           mov ax, word ptr [0x8542]
  0225FA  1F8A: 40               inc ax
  0225FB  1F8B: 40               inc ax
  0225FC  1F8C: 1e               push ds
  0225FD  1F8D: 50               push ax
  0225FE  1F8E: 6a00             push 0
  022600  1F90: 9a16041f18       lcall 0x181f, 0x416
  022605  1F95: 83c406           add sp, 6
  022608  1F98: 6a05             push 5
  02260A  1F9A: 68a509           push 0x9a5
  02260D  1F9D: e969ff           jmp 0x1f09
  022610  1FA0: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  022614  1FA4: 8a874531         mov al, byte ptr [bx + 0x3145]
  022618  1FA8: 2ae4             sub ah, ah
  02261A  1FAA: 50               push ax
  02261B  1FAB: 8a874431         mov al, byte ptr [bx + 0x3144]
  02261F  1FAF: 50               push ax
  022620  1FB0: 9a8c071f18       lcall 0x181f, 0x78c
  022625  1FB5: 83c404           add sp, 4
  022628  1FB8: 3d1b00           cmp ax, 0x1b
  02262B  1FBB: 7509             jne 0x1fc6
  02262D  1FBD: 6a03             push 3
  02262F  1FBF: 68ad09           push 0x9ad
  022632  1FC2: e944ff           jmp 0x1f09
  022635  1FC5: 90               nop 
  022636  1FC6: 2bc0             sub ax, ax
  022638  1FC8: 8946fa           mov word ptr [bp - 6], ax
  02263B  1FCB: 8946f2           mov word ptr [bp - 0xe], ax
  02263E  1FCE: 8946f8           mov word ptr [bp - 8], ax
  022641  1FD1: e99600           jmp 0x206a
  022644  1FD4: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  022648  1FD8: 80bf4c3107       cmp byte ptr [bx + 0x314c], 7
  02264D  1FDD: 7509             jne 0x1fe8
  02264F  1FDF: 6a03             push 3
  022651  1FE1: 68b909           push 0x9b9
  022654  1FE4: e922ff           jmp 0x1f09
  022657  1FE7: 90               nop 
  022658  1FE8: 8b46e8           mov ax, word ptr [bp - 0x18]
  02265B  1FEB: 9ae4021f18       lcall 0x181f, 0x2e4
  022660  1FF0: 8946e8           mov word ptr [bp - 0x18], ax
  022663  1FF3: 0bc0             or ax, ax
  022665  1FF5: 7ddd             jge 0x1fd4
  022667  1FF7: a19253           mov ax, word ptr [0x5392]
  02266A  1FFA: 8946e8           mov word ptr [bp - 0x18], ax
  02266D  1FFD: ff76ee           push word ptr [bp - 0x12]
  022670  2000: ff76f0           push word ptr [bp - 0x10]
  022673  2003: 9a8c071f18       lcall 0x181f, 0x78c
  022678  2008: 83c404           add sp, 4
  02267B  200B: 8946ec           mov word ptr [bp - 0x14], ax
  02267E  200E: 3d1900           cmp ax, 0x19
  022681  2011: 7423             je 0x2036
  022683  2013: 3d1a00           cmp ax, 0x1a
  022686  2016: 741e             je 0x2036
  022688  2018: 48               dec ax
  022689  2019: 741b             je 0x2036
  02268B  201B: 837eec18         cmp word ptr [bp - 0x14], 0x18
  02268F  201F: 7415             je 0x2036
  022691  2021: ff76ee           push word ptr [bp - 0x12]
  022694  2024: ff76f0           push word ptr [bp - 0x10]
  022697  2027: 9af0061f18       lcall 0x181f, 0x6f0
  02269C  202C: 83c404           add sp, 4
  02269F  202F: 0bc0             or ax, ax
  0226A1  2031: 7d03             jge 0x2036
  0226A3  2033: ff46fa           inc word ptr [bp - 6]
  0226A6  2036: ff76ee           push word ptr [bp - 0x12]
  0226A9  2039: ff76f0           push word ptr [bp - 0x10]
  0226AC  203C: 9a18071f18       lcall 0x181f, 0x718
  0226B1  2041: 83c404           add sp, 4
  0226B4  2044: 40               inc ax
  0226B5  2045: 7403             je 0x204a
  0226B7  2047: ff46fa           inc word ptr [bp - 6]
  0226BA  204A: 837eec08         cmp word ptr [bp - 0x14], 8
  0226BE  204E: 7c06             jl 0x2056
  0226C0  2050: 837eec10         cmp word ptr [bp - 0x14], 0x10
  0226C4  2054: 7c0c             jl 0x2062
  0226C6  2056: 837eec10         cmp word ptr [bp - 0x14], 0x10
  0226CA  205A: 7c0b             jl 0x2067
  0226CC  205C: 837eec18         cmp word ptr [bp - 0x14], 0x18
  0226D0  2060: 7d05             jge 0x2067
  0226D2  2062: c746f20100       mov word ptr [bp - 0xe], 1
  0226D7  2067: ff46f8           inc word ptr [bp - 8]
  0226DA  206A: 837ef809         cmp word ptr [bp - 8], 9
  0226DE  206E: 7d32             jge 0x20a2
  0226E0  2070: 8b5ef8           mov bx, word ptr [bp - 8]
  0226E3  2073: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0226E7  2077: 98               cwde 
  0226E8  2078: 6b76e81c         imul si, word ptr [bp - 0x18], 0x1c
  0226EC  207C: 8a8c4431         mov cl, byte ptr [si + 0x3144]
  0226F0  2080: 2aed             sub ch, ch
  0226F2  2082: 03c8             add cx, ax
  0226F4  2084: 894ef0           mov word ptr [bp - 0x10], cx
  0226F7  2087: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0226FB  208B: 98               cwde 
  0226FC  208C: 8a944531         mov dl, byte ptr [si + 0x3145]
  022700  2090: 2af6             sub dh, dh
  022702  2092: 03d0             add dx, ax
  022704  2094: 8956ee           mov word ptr [bp - 0x12], dx
  022707  2097: 8bc1             mov ax, cx
  022709  2099: 9ae0071f18       lcall 0x181f, 0x7e0
  02270E  209E: e94fff           jmp 0x1ff0
  022711  20A1: 90               nop 
  022712  20A2: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  022716  20A6: 8a874531         mov al, byte ptr [bx + 0x3145]
  02271A  20AA: 2ae4             sub ah, ah
  02271C  20AC: 50               push ax
  02271D  20AD: 8a874431         mov al, byte ptr [bx + 0x3144]
  022721  20B1: 50               push ax
  022722  20B2: 9a120d1f18       lcall 0x181f, 0xd12
  022727  20B7: 83c404           add sp, 4
  02272A  20BA: 0bc0             or ax, ax
  02272C  20BC: 741c             je 0x20da
  02272E  20BE: ff36bc8d         push word ptr [0x8dbc]
  022732  20C2: ff36ba8d         push word ptr [0x8dba]
  022736  20C6: 9ab4061f18       lcall 0x181f, 0x6b4
  02273B  20CB: 83c404           add sp, 4
  02273E  20CE: fec8             dec al
  022740  20D0: 7506             jne 0x20d8
  022742  20D2: b80100           mov ax, 1
  022745  20D5: eb03             jmp 0x20da
  022747  20D7: 90               nop 
  022748  20D8: 2bc0             sub ax, ax
  02274A  20DA: 0bc0             or ax, ax
  02274C  20DC: 7515             jne 0x20f3
  02274E  20DE: 6a03             push 3
  022750  20E0: 68c609           push 0x9c6
  022753  20E3: 9a52061f18       lcall 0x181f, 0x652
  022758  20E8: 83c404           add sp, 4
  02275B  20EB: 3d0200           cmp ax, 2
  02275E  20EE: 7403             je 0x20f3
  022760  20F0: e98200           jmp 0x2175
  022763  20F3: 803ea65302       cmp byte ptr [0x53a6], 2
  022768  20F8: 7330             jae 0x212a
  02276A  20FA: 837efa04         cmp word ptr [bp - 6], 4
  02276E  20FE: 7d12             jge 0x2112
  022770  2100: 6a03             push 3
  022772  2102: 68cd09           push 0x9cd
  022775  2105: 9a52061f18       lcall 0x181f, 0x652
  02277A  210A: 83c404           add sp, 4
  02277D  210D: 3d0200           cmp ax, 2
  022780  2110: 7563             jne 0x2175
  022782  2112: 837ef200         cmp word ptr [bp - 0xe], 0
  022786  2116: 7512             jne 0x212a
  022788  2118: 6a03             push 3
  02278A  211A: 68d909           push 0x9d9
  02278D  211D: 9a52061f18       lcall 0x181f, 0x652
  022792  2122: 83c404           add sp, 4
  022795  2125: 3d0200           cmp ax, 2
  022798  2128: 754b             jne 0x2175
  02279A  212A: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  02279E  212E: c6874c3107       mov byte ptr [bx + 0x314c], 7
  0227A3  2133: ff76e8           push word ptr [bp - 0x18]
  0227A6  2136: 9afa011f19       lcall 0x191f, 0x1fa
  0227AB  213B: 83c402           add sp, 2
  0227AE  213E: 5e               pop si
  0227AF  213F: c9               leave 
  0227B0  2140: cb               retf 
  0227B1  2141: 90               nop 
  0227B2  2142: a09453           mov al, byte ptr [0x5394]
  0227B5  2145: 695eeaca00       imul bx, word ptr [bp - 0x16], 0xca
  0227BA  214A: 3887605d         cmp byte ptr [bx + 0x5d60], al
  0227BE  214E: 7525             jne 0x2175
  0227C0  2150: ff76f6           push word ptr [bp - 0xa]
  0227C3  2153: ff76ea           push word ptr [bp - 0x16]
  0227C6  2156: 9aec011f19       lcall 0x191f, 0x1ec
  0227CB  215B: 83c404           add sp, 4
  0227CE  215E: 0bc0             or ax, ax
  0227D0  2160: 7513             jne 0x2175
  0227D2  2162: 6a01             push 1
  0227D4  2164: 9a1c0e1f18       lcall 0x181f, 0xe1c
  0227D9  2169: ebd0             jmp 0x213b
  0227DB  216B: 90               nop 
  0227DC  216C: 8d1ee509         lea bx, [0x9e5]
  0227E0  2170: 9afe031f18       lcall 0x181f, 0x3fe
  0227E5  2175: 5e               pop si
  0227E6  2176: c9               leave 
  0227E7  2177: cb               retf 

; ---- func_0227E8  size=73  insns=27  prologue=ENTER 0x0044,0  terminal=RETF ----
  0227E8  2178: c8440000         enter 0x44, 0
  0227EC  217C: a19253           mov ax, word ptr [0x5392]
  0227EF  217F: 8946c0           mov word ptr [bp - 0x40], ax
  0227F2  2182: 6bd81c           imul bx, ax, 0x1c
  0227F5  2185: 8a874431         mov al, byte ptr [bx + 0x3144]
  0227F9  2189: 2ae4             sub ah, ah
  0227FB  218B: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  0227FF  218F: 2aed             sub ch, ch
  022801  2191: 51               push cx
  022802  2192: 50               push ax
  022803  2193: 9abe071f18       lcall 0x181f, 0x7be
  022808  2198: 83c404           add sp, 4
  02280B  219B: 0bc0             or ax, ax
  02280D  219D: 7c20             jl 0x21bf
  02280F  219F: 50               push ax
  022810  21A0: 9ae6091f18       lcall 0x181f, 0x9e6
  022815  21A5: 83c402           add sp, 2
  022818  21A8: ff76c0           push word ptr [bp - 0x40]
  02281B  21AB: 9ade011f19       lcall 0x191f, 0x1de
  022820  21B0: 83c402           add sp, 2
  022823  21B3: 0bc0             or ax, ax
  022825  21B5: 7508             jne 0x21bf
  022827  21B7: 50               push ax
  022828  21B8: 6a01             push 1
  02282A  21BA: 9a5e051f18       lcall 0x181f, 0x55e
  02282F  21BF: c9               leave 
  022830  21C0: cb               retf 

; ---- func_022832  size=75  insns=28  prologue=ENTER 0x0028,0  terminal=RETF ----
  022832  21C2: c8280000         enter 0x28, 0
  022836  21C6: a19253           mov ax, word ptr [0x5392]
  022839  21C9: 8946da           mov word ptr [bp - 0x26], ax
  02283C  21CC: 6bd81c           imul bx, ax, 0x1c
  02283F  21CF: 8a874431         mov al, byte ptr [bx + 0x3144]
  022843  21D3: 2ae4             sub ah, ah
  022845  21D5: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  022849  21D9: 2aed             sub ch, ch
  02284B  21DB: 51               push cx
  02284C  21DC: 50               push ax
  02284D  21DD: 9abe071f18       lcall 0x181f, 0x7be
  022852  21E2: 83c404           add sp, 4
  022855  21E5: 0bc0             or ax, ax
  022857  21E7: 7c22             jl 0x220b
  022859  21E9: 50               push ax
  02285A  21EA: 9ae6091f18       lcall 0x181f, 0x9e6
  02285F  21EF: 83c402           add sp, 2
  022862  21F2: 6a00             push 0
  022864  21F4: ff76da           push word ptr [bp - 0x26]
  022867  21F7: 9ad0011f19       lcall 0x191f, 0x1d0
  02286C  21FC: 83c404           add sp, 4
  02286F  21FF: 0bc0             or ax, ax
  022871  2201: 7508             jne 0x220b
  022873  2203: 50               push ax
  022874  2204: 6a01             push 1
  022876  2206: 9a5e051f18       lcall 0x181f, 0x55e
  02287B  220B: c9               leave 
  02287C  220C: cb               retf 

; ---- func_02287E  size=444  insns=150  prologue=ENTER 0x0006,0  terminal=RETF ----
  02287E  220E: c8060000         enter 6, 0
  022882  2212: ff363e85         push word ptr [0x853e]
  022886  2216: ff364085         push word ptr [0x8540]
  02288A  221A: 9adc061f18       lcall 0x181f, 0x6dc
  02288F  221F: 83c404           add sp, 4
  022892  2222: 98               cwde 
  022893  2223: 8946fa           mov word ptr [bp - 6], ax
  022896  2226: f606835320       test byte ptr [0x5383], 0x20
  02289B  222B: 750b             jne 0x2238
  02289D  222D: a19653           mov ax, word ptr [0x5396]
  0228A0  2230: 3946fa           cmp word ptr [bp - 6], ax
  0228A3  2233: 7403             je 0x2238
  0228A5  2235: e99001           jmp 0x23c8
  0228A8  2238: a14085           mov ax, word ptr [0x8540]
  0228AB  223B: 8b163e85         mov dx, word ptr [0x853e]
  0228AF  223F: 9ae0071f18       lcall 0x181f, 0x7e0
  0228B4  2244: 8946fc           mov word ptr [bp - 4], ax
  0228B7  2247: 833e905300       cmp word ptr [0x5390], 0
  0228BC  224C: 7506             jne 0x2254
  0228BE  224E: a19253           mov ax, word ptr [0x5392]
  0228C1  2251: 8946fc           mov word ptr [bp - 4], ax
  0228C4  2254: 0bc0             or ax, ax
  0228C6  2256: 7d03             jge 0x225b
  0228C8  2258: e9f500           jmp 0x2350
  0228CB  225B: 6bd81c           imul bx, ax, 0x1c
  0228CE  225E: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  0228D3  2263: 7249             jb 0x22ae
  0228D5  2265: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  0228DA  226A: 7742             ja 0x22ae
  0228DC  226C: 50               push ax
  0228DD  226D: 9a20091f18       lcall 0x181f, 0x920
  0228E2  2272: 83c402           add sp, 2
  0228E5  2275: 6a02             push 2
  0228E7  2277: ff76fc           push word ptr [bp - 4]
  0228EA  227A: 9abc081f18       lcall 0x181f, 0x8bc
  0228EF  227F: 83c404           add sp, 4
  0228F2  2282: 8946fe           mov word ptr [bp - 2], ax
  0228F5  2285: ff363e85         push word ptr [0x853e]
  0228F9  2289: ff364085         push word ptr [0x8540]
  0228FD  228D: ff76fc           push word ptr [bp - 4]
  022900  2290: 9a48091f18       lcall 0x181f, 0x948
  022905  2295: 83c406           add sp, 6
  022908  2298: 837efe01         cmp word ptr [bp - 2], 1
  02290C  229C: 7e10             jle 0x22ae
  02290E  229E: 6a00             push 0
  022910  22A0: 68f509           push 0x9f5
  022913  22A3: 9a52061f18       lcall 0x181f, 0x652
  022918  22A8: 83c404           add sp, 4
  02291B  22AB: c9               leave 
  02291C  22AC: cb               retf 
  02291D  22AD: 90               nop 
  02291E  22AE: 6b5efc1c         imul bx, word ptr [bp - 4], 0x1c
  022922  22B2: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  022926  22B6: 2aff             sub bh, bh
  022928  22B8: 8bc3             mov ax, bx
  02292A  22BA: d1e3             shl bx, 1
  02292C  22BC: 03d8             add bx, ax
  02292E  22BE: d1e3             shl bx, 1
  022930  22C0: 03d8             add bx, ax
  022932  22C2: d1e3             shl bx, 1
  022934  22C4: ffb73052         push word ptr [bx + 0x5230]
  022938  22C8: 6a00             push 0
  02293A  22CA: 9a38041f18       lcall 0x181f, 0x438
  02293F  22CF: 83c404           add sp, 4
  022942  22D2: 8d1e010a         lea bx, [0xa01]
  022946  22D6: 9afe031f18       lcall 0x181f, 0x3fe
  02294B  22DB: 48               dec ax
  02294C  22DC: 7403             je 0x22e1
  02294E  22DE: e9e700           jmp 0x23c8
  022951  22E1: ff76fc           push word ptr [bp - 4]
  022954  22E4: 9a08081f18       lcall 0x181f, 0x808
  022959  22E9: 83c402           add sp, 2
  02295C  22EC: 6a01             push 1
  02295E  22EE: 9a1c0e1f18       lcall 0x181f, 0xe1c
  022963  22F3: 83c402           add sp, 2
  022966  22F6: a19253           mov ax, word ptr [0x5392]
  022969  22F9: 3946fc           cmp word ptr [bp - 4], ax
  02296C  22FC: 7e03             jle 0x2301
  02296E  22FE: e9c700           jmp 0x23c8
  022971  2301: 7d04             jge 0x2307
  022973  2303: ff0e9253         dec word ptr [0x5392]
  022977  2307: a19253           mov ax, word ptr [0x5392]
  02297A  230A: 39069c53         cmp word ptr [0x539c], ax
  02297E  230E: 7f0a             jg 0x231a
  022980  2310: 6a00             push 0
  022982  2312: 9a6c081f18       lcall 0x181f, 0x86c
  022987  2317: 83c402           add sp, 2
  02298A  231A: 833e9c5301       cmp word ptr [0x539c], 1
  02298F  231F: 7d07             jge 0x2328
  022991  2321: 0e               push cs
  022992  2322: e81022           call 0x4535
  022995  2325: c9               leave 
  022996  2326: cb               retf 
  022997  2327: 90               nop 
  022998  2328: 833e905300       cmp word ptr [0x5390], 0
  02299D  232D: 7403             je 0x2332
  02299F  232F: e99600           jmp 0x23c8
  0229A2  2332: 6a01             push 1
  0229A4  2334: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  0229A9  2339: 8a874531         mov al, byte ptr [bx + 0x3145]
  0229AD  233D: 2ae4             sub ah, ah
  0229AF  233F: 50               push ax
  0229B0  2340: 8a874431         mov al, byte ptr [bx + 0x3144]
  0229B4  2344: 50               push ax
  0229B5  2345: 9a080e1f18       lcall 0x181f, 0xe08
  0229BA  234A: 83c406           add sp, 6
  0229BD  234D: c9               leave 
  0229BE  234E: cb               retf 
  0229BF  234F: 90               nop 
  0229C0  2350: f606835320       test byte ptr [0x5383], 0x20
  0229C5  2355: 7471             je 0x23c8
  0229C7  2357: ff363e85         push word ptr [0x853e]
  0229CB  235B: ff364085         push word ptr [0x8540]
  0229CF  235F: 9abe071f18       lcall 0x181f, 0x7be
  0229D4  2364: 83c404           add sp, 4
  0229D7  2367: 8946fe           mov word ptr [bp - 2], ax
  0229DA  236A: 0bc0             or ax, ax
  0229DC  236C: 7c36             jl 0x23a4
  0229DE  236E: 69c0ca00         imul ax, ax, 0xca
  0229E2  2372: 05485d           add ax, 0x5d48
  0229E5  2375: 1e               push ds
  0229E6  2376: 50               push ax
  0229E7  2377: 6a00             push 0
  0229E9  2379: 9a16041f18       lcall 0x181f, 0x416
  0229EE  237E: 83c406           add sp, 6
  0229F1  2381: 8d1e0d0a         lea bx, [0xa0d]
  0229F5  2385: 9afe031f18       lcall 0x181f, 0x3fe
  0229FA  238A: 48               dec ax
  0229FB  238B: 753b             jne 0x23c8
  0229FD  238D: ff76fe           push word ptr [bp - 2]
  022A00  2390: 9a54021f19       lcall 0x191f, 0x254
  022A05  2395: 83c402           add sp, 2
  022A08  2398: 6a01             push 1
  022A0A  239A: 9a1c0e1f18       lcall 0x181f, 0xe1c
  022A0F  239F: 83c402           add sp, 2
  022A12  23A2: c9               leave 
  022A13  23A3: cb               retf 
  022A14  23A4: ff363e85         push word ptr [0x853e]
  022A18  23A8: ff364085         push word ptr [0x8540]
  022A1C  23AC: 9af0091f18       lcall 0x181f, 0x9f0
  022A21  23B1: 83c404           add sp, 4
  022A24  23B4: 0bc0             or ax, ax
  022A26  23B6: 7c10             jl 0x23c8
  022A28  23B8: 50               push ax
  022A29  23B9: 9a48021f19       lcall 0x191f, 0x248
  022A2E  23BE: 83c402           add sp, 2
  022A31  23C1: 6a01             push 1
  022A33  23C3: 9a1c0e1f18       lcall 0x181f, 0xe1c
  022A38  23C8: c9               leave 
  022A39  23C9: cb               retf 

; ---- func_022A3A  size=673  insns=222  prologue=ENTER 0x0064,0  terminal=RETF ----
  022A3A  23CA: c8640000         enter 0x64, 0
  022A3E  23CE: 56               push si
  022A3F  23CF: c746a80100       mov word ptr [bp - 0x58], 1
  022A44  23D4: c746ae0000       mov word ptr [bp - 0x52], 0
  022A49  23D9: 2bc0             sub ax, ax
  022A4B  23DB: 8946a6           mov word ptr [bp - 0x5a], ax
  022A4E  23DE: 8946a4           mov word ptr [bp - 0x5c], ax
  022A51  23E1: 8b4606           mov ax, word ptr [bp + 6]
  022A54  23E4: 8b5608           mov dx, word ptr [bp + 8]
  022A57  23E7: 9ae0071f18       lcall 0x181f, 0x7e0
  022A5C  23EC: 8946aa           mov word ptr [bp - 0x56], ax
  022A5F  23EF: 0bc0             or ax, ax
  022A61  23F1: 7d03             jge 0x23f6
  022A63  23F3: e95c02           jmp 0x2652
  022A66  23F6: 6bd81c           imul bx, ax, 0x1c
  022A69  23F9: 8a874731         mov al, byte ptr [bx + 0x3147]
  022A6D  23FD: 240f             and al, 0xf
  022A6F  23FF: 3a069453         cmp al, byte ptr [0x5394]
  022A73  2403: 7403             je 0x2408
  022A75  2405: e94a02           jmp 0x2652
  022A78  2408: 6a00             push 0
  022A7A  240A: ff76aa           push word ptr [bp - 0x56]
  022A7D  240D: 9aea071f18       lcall 0x181f, 0x7ea
  022A82  2412: 83c404           add sp, 4
  022A85  2415: 8b46aa           mov ax, word ptr [bp - 0x56]
  022A88  2418: 9aee021f18       lcall 0x181f, 0x2ee
  022A8D  241D: 8946aa           mov word ptr [bp - 0x56], ax
  022A90  2420: 6bd81c           imul bx, ax, 0x1c
  022A93  2423: 83bf5e3100       cmp word ptr [bx + 0x315e], 0
  022A98  2428: 7d24             jge 0x244e
  022A9A  242A: 8bf3             mov si, bx
  022A9C  242C: 9a66091f18       lcall 0x181f, 0x966
  022AA1  2431: 0bc0             or ax, ax
  022AA3  2433: 7507             jne 0x243c
  022AA5  2435: 80bc4c3100       cmp byte ptr [si + 0x314c], 0
  022AAA  243A: 7412             je 0x244e
  022AAC  243C: 6b5eaa1c         imul bx, word ptr [bp - 0x56], 0x1c
  022AB0  2440: c6874c3100       mov byte ptr [bx + 0x314c], 0
  022AB5  2445: 8b46aa           mov ax, word ptr [bp - 0x56]
  022AB8  2448: 8946a0           mov word ptr [bp - 0x60], ax
  022ABB  244B: e9a801           jmp 0x25f6
  022ABE  244E: ff368c26         push word ptr [0x268c]
  022AC2  2452: ff368a26         push word ptr [0x268a]
  022AC6  2456: 680008           push 0x800
  022AC9  2459: 9a3c021f19       lcall 0x191f, 0x23c
  022ACE  245E: 83c406           add sp, 6
  022AD1  2461: 8946a4           mov word ptr [bp - 0x5c], ax
  022AD4  2464: 8956a6           mov word ptr [bp - 0x5a], dx
  022AD7  2467: 0bd0             or dx, ax
  022AD9  2469: 7503             jne 0x246e
  022ADB  246B: e9e401           jmp 0x2652
  022ADE  246E: c45ea4           les bx, ptr [bp - 0x5c]
  022AE1  2471: 26c747460000     mov word ptr es:[bx + 0x46], 0
  022AE7  2477: b80200           mov ax, 2
  022AEA  247A: 2689474a         mov word ptr es:[bx + 0x4a], ax
  022AEE  247E: 0c80             or al, 0x80
  022AF0  2480: 2609470a         or word ptr es:[bx + 0xa], ax
  022AF4  2484: 8b46aa           mov ax, word ptr [bp - 0x56]
  022AF7  2487: 8946a0           mov word ptr [bp - 0x60], ax
  022AFA  248A: c7469e0100       mov word ptr [bp - 0x62], 1
  022AFF  248F: 6bd81c           imul bx, ax, 0x1c
  022B02  2492: 8bc3             mov ax, bx
  022B04  2494: 8a9f4731         mov bl, byte ptr [bx + 0x3147]
  022B08  2498: 83e30f           and bx, 0xf
  022B0B  249B: d1e3             shl bx, 1
  022B0D  249D: ffb70a8d         push word ptr [bx - 0x72f6]
  022B11  24A1: 8bf0             mov si, ax
  022B13  24A3: 9a22001f18       lcall 0x181f, 0x22
  022B18  24A8: 83c402           add sp, 2
  022B1B  24AB: 52               push dx
  022B1C  24AC: 50               push ax
  022B1D  24AD: 8d46b0           lea ax, [bp - 0x50]
  022B20  24B0: 16               push ss
  022B21  24B1: 50               push ax
  022B22  24B2: 9a7e111d0d       lcall 0xd1d, 0x117e
  022B27  24B7: 83c408           add sp, 8
  022B2A  24BA: 8d46b0           lea ax, [bp - 0x50]
  022B2D  24BD: 50               push ax
  022B2E  24BE: 9a78011f18       lcall 0x181f, 0x178
  022B33  24C3: 83c402           add sp, 2
  022B36  24C6: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  022B3A  24CA: 2aff             sub bh, bh
  022B3C  24CC: 8bc3             mov ax, bx
  022B3E  24CE: d1e3             shl bx, 1
  022B40  24D0: 03d8             add bx, ax
  022B42  24D2: d1e3             shl bx, 1
  022B44  24D4: 03d8             add bx, ax
  022B46  24D6: d1e3             shl bx, 1
  022B48  24D8: ffb73052         push word ptr [bx + 0x5230]
  022B4C  24DC: 9a22001f18       lcall 0x181f, 0x22
  022B51  24E1: 83c402           add sp, 2
  022B54  24E4: 52               push dx
  022B55  24E5: 50               push ax
  022B56  24E6: 8d46b0           lea ax, [bp - 0x50]
  022B59  24E9: 16               push ss
  022B5A  24EA: 50               push ax
  022B5B  24EB: 9ab4111d0d       lcall 0xd1d, 0x11b4
  022B60  24F0: 83c408           add sp, 8
  022B63  24F3: ff76a0           push word ptr [bp - 0x60]
  022B66  24F6: 9a780b1f18       lcall 0x181f, 0xb78
  022B6B  24FB: 83c402           add sp, 2
  022B6E  24FE: 0bc0             or ax, ax
  022B70  2500: 7c6d             jl 0x256f
  022B72  2502: 68190a           push 0xa19
  022B75  2505: 8d46b0           lea ax, [bp - 0x50]
  022B78  2508: 50               push ax
  022B79  2509: 9aa4071d0d       lcall 0xd1d, 0x7a4
  022B7E  250E: 83c404           add sp, 4
  022B81  2511: ff76a0           push word ptr [bp - 0x60]
  022B84  2514: 9a780b1f18       lcall 0x181f, 0xb78
  022B89  2519: 83c402           add sp, 2
  022B8C  251C: 38845b31         cmp byte ptr [si + 0x315b], al
  022B90  2520: 7420             je 0x2542
  022B92  2522: 80bc5b311c       cmp byte ptr [si + 0x315b], 0x1c
  022B97  2527: 7505             jne 0x252e
  022B99  2529: a1c02d           mov ax, word ptr [0x2dc0]
  022B9C  252C: eb17             jmp 0x2545
  022B9E  252E: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  022BA2  2532: 8a875b31         mov al, byte ptr [bx + 0x315b]
  022BA6  2536: 98               cwde 
  022BA7  2537: 8bd8             mov bx, ax
  022BA9  2539: c1e303           shl bx, 3
  022BAC  253C: 8b87a28e         mov ax, word ptr [bx - 0x715e]
  022BB0  2540: eb03             jmp 0x2545
  022BB2  2542: a1c22d           mov ax, word ptr [0x2dc2]
  022BB5  2545: 8946ac           mov word ptr [bp - 0x54], ax
  022BB8  2548: 50               push ax
  022BB9  2549: 9a22001f18       lcall 0x181f, 0x22
  022BBE  254E: 83c402           add sp, 2
  022BC1  2551: 52               push dx
  022BC2  2552: 50               push ax
  022BC3  2553: 8d46b0           lea ax, [bp - 0x50]
  022BC6  2556: 16               push ss
  022BC7  2557: 50               push ax
  022BC8  2558: 9ab4111d0d       lcall 0xd1d, 0x11b4
  022BCD  255D: 83c408           add sp, 8
  022BD0  2560: 681c0a           push 0xa1c
  022BD3  2563: 8d46b0           lea ax, [bp - 0x50]
  022BD6  2566: 50               push ax
  022BD7  2567: 9aa4071d0d       lcall 0xd1d, 0x7a4
  022BDC  256C: 83c404           add sp, 4
  022BDF  256F: ff769e           push word ptr [bp - 0x62]
  022BE2  2572: ff469e           inc word ptr [bp - 0x62]
  022BE5  2575: 8d46b0           lea ax, [bp - 0x50]
  022BE8  2578: 16               push ss
  022BE9  2579: 50               push ax
  022BEA  257A: ff76a0           push word ptr [bp - 0x60]
  022BED  257D: ff364008         push word ptr [0x840]
  022BF1  2581: ff363e08         push word ptr [0x83e]
  022BF5  2585: ff76a6           push word ptr [bp - 0x5a]
  022BF8  2588: ff76a4           push word ptr [bp - 0x5c]
  022BFB  258B: 9a30021f19       lcall 0x191f, 0x230
  022C00  2590: 83c410           add sp, 0x10
  022C03  2593: 8b46a0           mov ax, word ptr [bp - 0x60]
  022C06  2596: 9ae4021f18       lcall 0x181f, 0x2e4
  022C0B  259B: 8946a0           mov word ptr [bp - 0x60], ax
  022C0E  259E: ff46ae           inc word ptr [bp - 0x52]
  022C11  25A1: 0bc0             or ax, ax
  022C13  25A3: 7c09             jl 0x25ae
  022C15  25A5: 837eae0a         cmp word ptr [bp - 0x52], 0xa
  022C19  25A9: 7d03             jge 0x25ae
  022C1B  25AB: e9e1fe           jmp 0x248f
  022C1E  25AE: 6a13             push 0x13
  022C20  25B0: ff364008         push word ptr [0x840]
  022C24  25B4: ff363e08         push word ptr [0x83e]
  022C28  25B8: ff76a6           push word ptr [bp - 0x5a]
  022C2B  25BB: ff76a4           push word ptr [bp - 0x5c]
  022C2E  25BE: 9a24021f19       lcall 0x191f, 0x224
  022C33  25C3: 83c40a           add sp, 0xa
  022C36  25C6: ff76a6           push word ptr [bp - 0x5a]
  022C39  25C9: ff76a4           push word ptr [bp - 0x5c]
  022C3C  25CC: 9a6a011f19       lcall 0x191f, 0x16a
  022C41  25D1: 8946a2           mov word ptr [bp - 0x5e], ax
  022C44  25D4: 3d0100           cmp ax, 1
  022C47  25D7: 7c79             jl 0x2652
  022C49  25D9: 8b46aa           mov ax, word ptr [bp - 0x56]
  022C4C  25DC: 8946a0           mov word ptr [bp - 0x60], ax
  022C4F  25DF: eb0f             jmp 0x25f0
  022C51  25E1: 90               nop 
  022C52  25E2: 8b46a0           mov ax, word ptr [bp - 0x60]
  022C55  25E5: 9ae4021f18       lcall 0x181f, 0x2e4
  022C5A  25EA: 8946a0           mov word ptr [bp - 0x60], ax
  022C5D  25ED: ff4ea2           dec word ptr [bp - 0x5e]
  022C60  25F0: 837ea201         cmp word ptr [bp - 0x5e], 1
  022C64  25F4: 7fec             jg 0x25e2
  022C66  25F6: 833e925300       cmp word ptr [0x5392], 0
  022C6B  25FB: 7c2b             jl 0x2628
  022C6D  25FD: c706a21e0000     mov word ptr [0x1ea2], 0
  022C73  2603: 6a01             push 1
  022C75  2605: 6a01             push 1
  022C77  2607: 6a01             push 1
  022C79  2609: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  022C7E  260E: 8a874531         mov al, byte ptr [bx + 0x3145]
  022C82  2612: 2ae4             sub ah, ah
  022C84  2614: 50               push ax
  022C85  2615: 8a874431         mov al, byte ptr [bx + 0x3144]
  022C89  2619: 50               push ax
  022C8A  261A: 9aba091f18       lcall 0x181f, 0x9ba
  022C8F  261F: 83c40a           add sp, 0xa
  022C92  2622: c706a21e0100     mov word ptr [0x1ea2], 1
  022C98  2628: ff76a0           push word ptr [bp - 0x60]
  022C9B  262B: 9a6c081f18       lcall 0x181f, 0x86c
  022CA0  2630: 83c402           add sp, 2
  022CA3  2633: 833e925300       cmp word ptr [0x5392], 0
  022CA8  2638: 7c0a             jl 0x2644
  022CAA  263A: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  022CAF  263F: c6874c3100       mov byte ptr [bx + 0x314c], 0
  022CB4  2644: 6a00             push 0
  022CB6  2646: 0e               push cs
  022CB7  2647: e8961e           call 0x44e0
  022CBA  264A: 83c402           add sp, 2
  022CBD  264D: c746a80000       mov word ptr [bp - 0x58], 0
  022CC2  2652: 8b46a6           mov ax, word ptr [bp - 0x5a]
  022CC5  2655: 0b46a4           or ax, word ptr [bp - 0x5c]
  022CC8  2658: 740b             je 0x2665
  022CCA  265A: ff76a6           push word ptr [bp - 0x5a]
  022CCD  265D: ff76a4           push word ptr [bp - 0x5c]
  022CD0  2660: 9aa8011f19       lcall 0x191f, 0x1a8
  022CD5  2665: 8b46a8           mov ax, word ptr [bp - 0x58]
  022CD8  2668: 5e               pop si
  022CD9  2669: c9               leave 
  022CDA  266A: cb               retf 

; ---- func_022CDC  size=106  insns=40  prologue=ENTER 0x0004,0  terminal=RETF ----
  022CDC  266C: c8040000         enter 4, 0
  022CE0  2670: 56               push si
  022CE1  2671: 6a00             push 0
  022CE3  2673: 6a01             push 1
  022CE5  2675: 6aff             push -1
  022CE7  2677: a19253           mov ax, word ptr [0x5392]
  022CEA  267A: 8946fc           mov word ptr [bp - 4], ax
  022CED  267D: 50               push ax
  022CEE  267E: 9af8021f19       lcall 0x191f, 0x2f8
  022CF3  2683: 83c408           add sp, 8
  022CF6  2686: 3de703           cmp ax, 0x3e7
  022CF9  2689: 7521             jne 0x26ac
  022CFB  268B: f606825301       test byte ptr [0x5382], 1
  022D00  2690: 740c             je 0x269e
  022D02  2692: 8d1e1e0a         lea bx, [0xa1e]
  022D06  2696: 9afe031f18       lcall 0x181f, 0x3fe
  022D0B  269B: 5e               pop si
  022D0C  269C: c9               leave 
  022D0D  269D: cb               retf 
  022D0E  269E: ff76fc           push word ptr [bp - 4]
  022D11  26A1: 9aea021f19       lcall 0x191f, 0x2ea
  022D16  26A6: 83c402           add sp, 2
  022D19  26A9: 5e               pop si
  022D1A  26AA: c9               leave 
  022D1B  26AB: cb               retf 
  022D1C  26AC: 0bc0             or ax, ax
  022D1E  26AE: 7c23             jl 0x26d3
  022D20  26B0: 50               push ax
  022D21  26B1: 9ae6091f18       lcall 0x181f, 0x9e6
  022D26  26B6: 83c402           add sp, 2
  022D29  26B9: 6b5efc1c         imul bx, word ptr [bp - 4], 0x1c
  022D2D  26BD: c6874c3103       mov byte ptr [bx + 0x314c], 3
  022D32  26C2: 8b364285         mov si, word ptr [0x8542]
  022D36  26C6: 8a04             mov al, byte ptr [si]
  022D38  26C8: 88874d31         mov byte ptr [bx + 0x314d], al
  022D3C  26CC: 8a4401           mov al, byte ptr [si + 1]
  022D3F  26CF: 88874e31         mov byte ptr [bx + 0x314e], al
  022D43  26D3: 5e               pop si
  022D44  26D4: c9               leave 
  022D45  26D5: cb               retf 

; ---- func_022D46  size=208  insns=66  prologue=ENTER 0x0008,0  terminal=RETF ----
  022D46  26D6: c8080000         enter 8, 0
  022D4A  26DA: 833ea05300       cmp word ptr [0x53a0], 0
  022D4F  26DF: 750d             jne 0x26ee
  022D51  26E1: 6a00             push 0
  022D53  26E3: 682d0a           push 0xa2d
  022D56  26E6: 9a52061f18       lcall 0x181f, 0x652
  022D5B  26EB: c9               leave 
  022D5C  26EC: cb               retf 
  022D5D  26ED: 90               nop 
  022D5E  26EE: a19253           mov ax, word ptr [0x5392]
  022D61  26F1: 8946fa           mov word ptr [bp - 6], ax
  022D64  26F4: 6bd81c           imul bx, ax, 0x1c
  022D67  26F7: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  022D6C  26FC: 720e             jb 0x270c
  022D6E  26FE: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  022D73  2703: 7707             ja 0x270c
  022D75  2705: c746f80200       mov word ptr [bp - 8], 2
  022D7A  270A: eb05             jmp 0x2711
  022D7C  270C: c746f80100       mov word ptr [bp - 8], 1
  022D81  2711: 68370a           push 0xa37
  022D84  2714: ff76fa           push word ptr [bp - 6]
  022D87  2717: 9a58081f18       lcall 0x181f, 0x858
  022D8C  271C: 83c402           add sp, 2
  022D8F  271F: 50               push ax
  022D90  2720: ff76f8           push word ptr [bp - 8]
  022D93  2723: 9adc021f19       lcall 0x191f, 0x2dc
  022D98  2728: 83c406           add sp, 6
  022D9B  272B: 8946fc           mov word ptr [bp - 4], ax
  022D9E  272E: 0bc0             or ax, ax
  022DA0  2730: 7c72             jl 0x27a4
  022DA2  2732: ff76fa           push word ptr [bp - 6]
  022DA5  2735: 9a58081f18       lcall 0x181f, 0x858
  022DAA  273A: 83c402           add sp, 2
  022DAD  273D: 3b46fc           cmp ax, word ptr [bp - 4]
  022DB0  2740: 741b             je 0x275d
  022DB2  2742: ff76fc           push word ptr [bp - 4]
  022DB5  2745: ff76fa           push word ptr [bp - 6]
  022DB8  2748: 9a62081f18       lcall 0x181f, 0x862
  022DBD  274D: 83c404           add sp, 4
  022DC0  2750: 6a00             push 0
  022DC2  2752: ff76fa           push word ptr [bp - 6]
  022DC5  2755: 9ab2081f18       lcall 0x181f, 0x8b2
  022DCA  275A: 83c404           add sp, 4
  022DCD  275D: ff76fa           push word ptr [bp - 6]
  022DD0  2760: 9a76081f18       lcall 0x181f, 0x876
  022DD5  2765: 83c402           add sp, 2
  022DD8  2768: 8946fe           mov word ptr [bp - 2], ax
  022DDB  276B: ff76fc           push word ptr [bp - 4]
  022DDE  276E: 9ace021f19       lcall 0x191f, 0x2ce
  022DE3  2773: 83c402           add sp, 2
  022DE6  2776: ff76fe           push word ptr [bp - 2]
  022DE9  2779: 9ac0021f19       lcall 0x191f, 0x2c0
  022DEE  277E: 83c402           add sp, 2
  022DF1  2781: 0bc0             or ax, ax
  022DF3  2783: 7c1f             jl 0x27a4
  022DF5  2785: 50               push ax
  022DF6  2786: ff76fa           push word ptr [bp - 6]
  022DF9  2789: 9ab2081f18       lcall 0x181f, 0x8b2
  022DFE  278E: 83c404           add sp, 4
  022E01  2791: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  022E05  2795: c6874c3102       mov byte ptr [bx + 0x314c], 2
  022E0A  279A: 6a01             push 1
  022E0C  279C: ff76fa           push word ptr [bp - 6]
  022E0F  279F: 9ab2021f19       lcall 0x191f, 0x2b2
  022E14  27A4: c9               leave 
  022E15  27A5: cb               retf 

; ---- func_022E16  size=242  insns=72  prologue=ENTER 0x0006,0  terminal=RETF ----
  022E16  27A6: c8060000         enter 6, 0
  022E1A  27AA: c746fe0000       mov word ptr [bp - 2], 0
  022E1F  27AF: eb16             jmp 0x27c7
  022E21  27B1: 90               nop 
  022E22  27B2: a19653           mov ax, word ptr [0x5396]
  022E25  27B5: 9aa4021f19       lcall 0x191f, 0x2a4
  022E2A  27BA: 9a96021f19       lcall 0x191f, 0x296
  022E2F  27BF: 9a88021f19       lcall 0x191f, 0x288
  022E34  27C4: ff46fe           inc word ptr [bp - 2]
  022E37  27C7: 837efe03         cmp word ptr [bp - 2], 3
  022E3B  27CB: 7f13             jg 0x27e0
  022E3D  27CD: 8b46fe           mov ax, word ptr [bp - 2]
  022E40  27D0: a38e01           mov word ptr [0x18e], ax
  022E43  27D3: 833ea25300       cmp word ptr [0x53a2], 0
  022E48  27D8: 74d8             je 0x27b2
  022E4A  27DA: b8ffff           mov ax, 0xffff
  022E4D  27DD: ebd6             jmp 0x27b5
  022E4F  27DF: 90               nop 
  022E50  27E0: c7068e010000     mov word ptr [0x18e], 0
  022E56  27E6: 9ac0031f18       lcall 0x181f, 0x3c0
  022E5B  27EB: 8bd8             mov bx, ax
  022E5D  27ED: 895efc           mov word ptr [bp - 4], bx
  022E60  27F0: f687ed2702       test byte ptr [bx + 0x27ed], 2
  022E65  27F5: 7406             je 0x27fd
  022E67  27F7: 8d47e0           lea ax, [bx - 0x20]
  022E6A  27FA: 8946fc           mov word ptr [bp - 4], ax
  022E6D  27FD: 837efc48         cmp word ptr [bp - 4], 0x48
  022E71  2801: 7535             jne 0x2838
  022E73  2803: c746fe0200       mov word ptr [bp - 2], 2
  022E78  2808: eb15             jmp 0x281f
  022E7A  280A: a19653           mov ax, word ptr [0x5396]
  022E7D  280D: 9aa4021f19       lcall 0x191f, 0x2a4
  022E82  2812: 9a96021f19       lcall 0x191f, 0x296
  022E87  2817: 9a88021f19       lcall 0x191f, 0x288
  022E8C  281C: ff4efe           dec word ptr [bp - 2]
  022E8F  281F: 837efe00         cmp word ptr [bp - 2], 0
  022E93  2823: 7c13             jl 0x2838
  022E95  2825: 8b46fe           mov ax, word ptr [bp - 2]
  022E98  2828: a38e01           mov word ptr [0x18e], ax
  022E9B  282B: 833ea25300       cmp word ptr [0x53a2], 0
  022EA0  2830: 74d8             je 0x280a
  022EA2  2832: b8ffff           mov ax, 0xffff
  022EA5  2835: ebd6             jmp 0x280d
  022EA7  2837: 90               nop 
  022EA8  2838: 6a01             push 1
  022EAA  283A: 9a1c0e1f18       lcall 0x181f, 0xe1c
  022EAF  283F: c9               leave 
  022EB0  2840: cb               retf 
  022EB1  2841: 90               nop 
  022EB2  2842: 9a7a021f19       lcall 0x191f, 0x27a
  022EB7  2847: a3b09c           mov word ptr [0x9cb0], ax
  022EBA  284A: 8916b29c         mov word ptr [0x9cb2], dx
  022EBE  284E: c41e9608         les bx, ptr [0x896]
  022EC2  2852: 268b474a         mov ax, word ptr es:[bx + 0x4a]
  022EC6  2856: 268b574c         mov dx, word ptr es:[bx + 0x4c]
  022ECA  285A: a3b49c           mov word ptr [0x9cb4], ax
  022ECD  285D: 8916b69c         mov word ptr [0x9cb6], dx
  022ED1  2861: 9a280c1d0d       lcall 0xd1d, 0xc28
  022ED6  2866: a3b89c           mov word ptr [0x9cb8], ax
  022ED9  2869: c706ba9c0000     mov word ptr [0x9cba], 0
  022EDF  286F: 9aea0e1f18       lcall 0x181f, 0xeea
  022EE4  2874: 99               cdq 
  022EE5  2875: a3bc9c           mov word ptr [0x9cbc], ax
  022EE8  2878: 8916be9c         mov word ptr [0x9cbe], dx
  022EEC  287C: a1b227           mov ax, word ptr [0x27b2]
  022EEF  287F: a3c09c           mov word ptr [0x9cc0], ax
  022EF2  2882: c706c29c0000     mov word ptr [0x9cc2], 0
  022EF8  2888: 8d1e4a0a         lea bx, [0xa4a]
  022EFC  288C: 8d06430a         lea ax, [0xa43]
  022F00  2890: 2bd2             sub dx, dx
  022F02  2892: 9a98091f18       lcall 0x181f, 0x998
  022F07  2897: cb               retf 

; ---- func_022F08  size=1084  insns=334  prologue=ENTER 0x0004,0  terminal=RETF ----
  022F08  2898: c8040000         enter 4, 0
  022F0C  289C: c746fcffff       mov word ptr [bp - 4], 0xffff
  022F11  28A1: 6a17             push 0x17
  022F13  28A3: 8d1e7c08         lea bx, [0x87c]
  022F17  28A7: 8d06510a         lea ax, [0xa51]
  022F1B  28AB: 8d16500a         lea dx, [0xa50]
  022F1F  28AF: 9a20011f19       lcall 0x191f, 0x120
  022F24  28B4: 0bc0             or ax, ax
  022F26  28B6: 7403             je 0x28bb
  022F28  28B8: e9a800           jmp 0x2963
  022F2B  28BB: 8946fe           mov word ptr [bp - 2], ax
  022F2E  28BE: eb63             jmp 0x2923
  022F30  28C0: a19e53           mov ax, word ptr [0x539e]
  022F33  28C3: 3946fe           cmp word ptr [bp - 2], ax
  022F36  28C6: 7d61             jge 0x2929
  022F38  28C8: ff76fe           push word ptr [bp - 2]
  022F3B  28CB: 9ae6091f18       lcall 0x181f, 0x9e6
  022F40  28D0: 83c402           add sp, 2
  022F43  28D3: a14285           mov ax, word ptr [0x8542]
  022F46  28D6: 40               inc ax
  022F47  28D7: 40               inc ax
  022F48  28D8: 50               push ax
  022F49  28D9: 682098           push 0x9820
  022F4C  28DC: 9a800c1d0d       lcall 0xd1d, 0xc80
  022F51  28E1: 83c404           add sp, 4
  022F54  28E4: 0bc0             or ax, ax
  022F56  28E6: 7538             jne 0x2920
  022F58  28E8: 833e965304       cmp word ptr [0x5396], 4
  022F5D  28ED: 7d2b             jge 0x291a
  022F5F  28EF: 8b1e4285         mov bx, word ptr [0x8542]
  022F63  28F3: 8a4701           mov al, byte ptr [bx + 1]
  022F66  28F6: 2ae4             sub ah, ah
  022F68  28F8: 50               push ax
  022F69  28F9: 8a07             mov al, byte ptr [bx]
  022F6B  28FB: 50               push ax
  022F6C  28FC: 9a4a071f18       lcall 0x181f, 0x74a
  022F71  2901: 83c404           add sp, 4
  022F74  2904: 2ae4             sub ah, ah
  022F76  2906: 8a0e9653         mov cl, byte ptr [0x5396]
  022F7A  290A: ba1000           mov dx, 0x10
  022F7D  290D: d3e2             shl dx, cl
  022F7F  290F: 85c2             test dx, ax
  022F81  2911: 7507             jne 0x291a
  022F83  2913: 833ea25300       cmp word ptr [0x53a2], 0
  022F88  2918: 7406             je 0x2920
  022F8A  291A: 8b46fe           mov ax, word ptr [bp - 2]
  022F8D  291D: 8946fc           mov word ptr [bp - 4], ax
  022F90  2920: ff46fe           inc word ptr [bp - 2]
  022F93  2923: 837efc00         cmp word ptr [bp - 4], 0
  022F97  2927: 7c97             jl 0x28c0
  022F99  2929: 837efc00         cmp word ptr [bp - 4], 0
  022F9D  292D: 7c1d             jl 0x294c
  022F9F  292F: 0e               push cs
  022FA0  2930: e8021c           call 0x4535
  022FA3  2933: 6a00             push 0
  022FA5  2935: 8b1e4285         mov bx, word ptr [0x8542]
  022FA9  2939: 8a4701           mov al, byte ptr [bx + 1]
  022FAC  293C: 2ae4             sub ah, ah
  022FAE  293E: 50               push ax
  022FAF  293F: 8a07             mov al, byte ptr [bx]
  022FB1  2941: 50               push ax
  022FB2  2942: 9a080e1f18       lcall 0x181f, 0xe08
  022FB7  2947: 83c406           add sp, 6
  022FBA  294A: c9               leave 
  022FBB  294B: cb               retf 
  022FBC  294C: 1e               push ds
  022FBD  294D: 682098           push 0x9820
  022FC0  2950: 6a00             push 0
  022FC2  2952: 9a16041f18       lcall 0x181f, 0x416
  022FC7  2957: 83c406           add sp, 6
  022FCA  295A: 8d1e5a0a         lea bx, [0xa5a]
  022FCE  295E: 9afe031f18       lcall 0x181f, 0x3fe
  022FD3  2963: c9               leave 
  022FD4  2964: cb               retf 
  022FD5  2965: 90               nop 
  022FD6  2966: 9a6e021f19       lcall 0x191f, 0x26e
  022FDB  296B: 8a368353         mov dh, byte ptr [0x5383]
  022FDF  296F: 81e20080         and dx, 0x8000
  022FE3  2973: b80100           mov ax, 1
  022FE6  2976: 9a62021f19       lcall 0x191f, 0x262
  022FEB  297B: 8a368353         mov dh, byte ptr [0x5383]
  022FEF  297F: 81e20040         and dx, 0x4000
  022FF3  2983: b80200           mov ax, 2
  022FF6  2986: 9a62021f19       lcall 0x191f, 0x262
  022FFB  298B: 8a368353         mov dh, byte ptr [0x5383]
  022FFF  298F: 81e20010         and dx, 0x1000
  023003  2993: b80300           mov ax, 3
  023006  2996: 9a62021f19       lcall 0x191f, 0x262
  02300B  299B: 8a368353         mov dh, byte ptr [0x5383]
  02300F  299F: 81e20008         and dx, 0x800
  023013  29A3: b80400           mov ax, 4
  023016  29A6: 9a62021f19       lcall 0x191f, 0x262
  02301B  29AB: 8a368353         mov dh, byte ptr [0x5383]
  02301F  29AF: 81e20004         and dx, 0x400
  023023  29B3: b80500           mov ax, 5
  023026  29B6: 9a62021f19       lcall 0x191f, 0x262
  02302B  29BB: 8a368353         mov dh, byte ptr [0x5383]
  02302F  29BF: 81e20002         and dx, 0x200
  023033  29C3: b80600           mov ax, 6
  023036  29C6: 9a62021f19       lcall 0x191f, 0x262
  02303B  29CB: 8a268353         mov ah, byte ptr [0x5383]
  02303F  29CF: 250001           and ax, 0x100
  023042  29D2: 3d0100           cmp ax, 1
  023045  29D5: 1bd2             sbb dx, dx
  023047  29D7: f7da             neg dx
  023049  29D9: b80700           mov ax, 7
  02304C  29DC: 9a62021f19       lcall 0x191f, 0x262
  023051  29E1: 8a168253         mov dl, byte ptr [0x5382]
  023055  29E5: 81e28000         and dx, 0x80
  023059  29E9: b80800           mov ax, 8
  02305C  29EC: 9a62021f19       lcall 0x191f, 0x262
  023061  29F1: 8d1e610a         lea bx, [0xa61]
  023065  29F5: 9afe031f18       lcall 0x181f, 0x3fe
  02306A  29FA: 812682537f20     and word ptr [0x5382], 0x207f
  023070  2A00: b80100           mov ax, 1
  023073  2A03: 9a06031f19       lcall 0x191f, 0x306
  023078  2A08: 0bc0             or ax, ax
  02307A  2A0A: 7405             je 0x2a11
  02307C  2A0C: 800e835380       or byte ptr [0x5383], 0x80
  023081  2A11: b80200           mov ax, 2
  023084  2A14: 9a06031f19       lcall 0x191f, 0x306
  023089  2A19: 0bc0             or ax, ax
  02308B  2A1B: 7405             je 0x2a22
  02308D  2A1D: 800e835340       or byte ptr [0x5383], 0x40
  023092  2A22: b80300           mov ax, 3
  023095  2A25: 9a06031f19       lcall 0x191f, 0x306
  02309A  2A2A: 0bc0             or ax, ax
  02309C  2A2C: 7405             je 0x2a33
  02309E  2A2E: 800e835310       or byte ptr [0x5383], 0x10
  0230A3  2A33: b80400           mov ax, 4
  0230A6  2A36: 9a06031f19       lcall 0x191f, 0x306
  0230AB  2A3B: 0bc0             or ax, ax
  0230AD  2A3D: 7405             je 0x2a44
  0230AF  2A3F: 800e835308       or byte ptr [0x5383], 8
  0230B4  2A44: b80500           mov ax, 5
  0230B7  2A47: 9a06031f19       lcall 0x191f, 0x306
  0230BC  2A4C: 0bc0             or ax, ax
  0230BE  2A4E: 7405             je 0x2a55
  0230C0  2A50: 800e835304       or byte ptr [0x5383], 4
  0230C5  2A55: b80600           mov ax, 6
  0230C8  2A58: 9a06031f19       lcall 0x191f, 0x306
  0230CD  2A5D: 0bc0             or ax, ax
  0230CF  2A5F: 7405             je 0x2a66
  0230D1  2A61: 800e835302       or byte ptr [0x5383], 2
  0230D6  2A66: b80700           mov ax, 7
  0230D9  2A69: 9a06031f19       lcall 0x191f, 0x306
  0230DE  2A6E: 0bc0             or ax, ax
  0230E0  2A70: 7505             jne 0x2a77
  0230E2  2A72: 800e835301       or byte ptr [0x5383], 1
  0230E7  2A77: b80800           mov ax, 8
  0230EA  2A7A: 9a06031f19       lcall 0x191f, 0x306
  0230EF  2A7F: 0bc0             or ax, ax
  0230F1  2A81: 7405             je 0x2a88
  0230F3  2A83: 800e825380       or byte ptr [0x5382], 0x80
  0230F8  2A88: 8a268353         mov ah, byte ptr [0x5383]
  0230FC  2A8C: 250001           and ax, 0x100
  0230FF  2A8F: 3d0100           cmp ax, 1
  023102  2A92: 1bc0             sbb ax, ax
  023104  2A94: f7d8             neg ax
  023106  2A96: a37203           mov word ptr [0x372], ax
  023109  2A99: 0bc0             or ax, ax
  02310B  2A9B: 750b             jne 0x2aa8
  02310D  2A9D: 6800a0           push 0xa000
  023110  2AA0: 6800fc           push 0xfc00
  023113  2AA3: 9af4031f18       lcall 0x181f, 0x3f4
  023118  2AA8: cb               retf 
  023119  2AA9: 90               nop 
  02311A  2AAA: 9a6e021f19       lcall 0x191f, 0x26e
  02311F  2AAF: a08453           mov al, byte ptr [0x5384]
  023122  2AB2: 250200           and ax, 2
  023125  2AB5: 3d0100           cmp ax, 1
  023128  2AB8: 1bd2             sbb dx, dx
  02312A  2ABA: f7da             neg dx
  02312C  2ABC: b80100           mov ax, 1
  02312F  2ABF: 9a62021f19       lcall 0x191f, 0x262
  023134  2AC4: a08453           mov al, byte ptr [0x5384]
  023137  2AC7: 250100           and ax, 1
  02313A  2ACA: 3d0100           cmp ax, 1
  02313D  2ACD: 1bd2             sbb dx, dx
  02313F  2ACF: f7da             neg dx
  023141  2AD1: b80200           mov ax, 2
  023144  2AD4: 9a62021f19       lcall 0x191f, 0x262
  023149  2AD9: a08453           mov al, byte ptr [0x5384]
  02314C  2ADC: 258000           and ax, 0x80
  02314F  2ADF: 3d0100           cmp ax, 1
  023152  2AE2: 1bd2             sbb dx, dx
  023154  2AE4: f7da             neg dx
  023156  2AE6: b80300           mov ax, 3
  023159  2AE9: 9a62021f19       lcall 0x191f, 0x262
  02315E  2AEE: a08453           mov al, byte ptr [0x5384]
  023161  2AF1: 254000           and ax, 0x40
  023164  2AF4: 3d0100           cmp ax, 1
  023167  2AF7: 1bd2             sbb dx, dx
  023169  2AF9: f7da             neg dx
  02316B  2AFB: b80400           mov ax, 4
  02316E  2AFE: 9a62021f19       lcall 0x191f, 0x262
  023173  2B03: a08453           mov al, byte ptr [0x5384]
  023176  2B06: 252000           and ax, 0x20
  023179  2B09: 3d0100           cmp ax, 1
  02317C  2B0C: 1bd2             sbb dx, dx
  02317E  2B0E: f7da             neg dx
  023180  2B10: b80500           mov ax, 5
  023183  2B13: 9a62021f19       lcall 0x191f, 0x262
  023188  2B18: a08453           mov al, byte ptr [0x5384]
  02318B  2B1B: 251000           and ax, 0x10
  02318E  2B1E: 3d0100           cmp ax, 1
  023191  2B21: 1bd2             sbb dx, dx
  023193  2B23: f7da             neg dx
  023195  2B25: b80600           mov ax, 6
  023198  2B28: 9a62021f19       lcall 0x191f, 0x262
  02319D  2B2D: a08453           mov al, byte ptr [0x5384]
  0231A0  2B30: 250800           and ax, 8
  0231A3  2B33: 3d0100           cmp ax, 1
  0231A6  2B36: 1bd2             sbb dx, dx
  0231A8  2B38: f7da             neg dx
  0231AA  2B3A: b80700           mov ax, 7
  0231AD  2B3D: 9a62021f19       lcall 0x191f, 0x262
  0231B2  2B42: a08453           mov al, byte ptr [0x5384]
  0231B5  2B45: 250400           and ax, 4
  0231B8  2B48: 3d0100           cmp ax, 1
  0231BB  2B4B: 1bd2             sbb dx, dx
  0231BD  2B4D: f7da             neg dx
  0231BF  2B4F: b80800           mov ax, 8
  0231C2  2B52: 9a62021f19       lcall 0x191f, 0x262
  0231C7  2B57: 8a268553         mov ah, byte ptr [0x5385]
  0231CB  2B5B: 250001           and ax, 0x100
  0231CE  2B5E: 3d0100           cmp ax, 1
  0231D1  2B61: 1bd2             sbb dx, dx
  0231D3  2B63: f7da             neg dx
  0231D5  2B65: b80900           mov ax, 9
  0231D8  2B68: 9a62021f19       lcall 0x191f, 0x262
  0231DD  2B6D: 8a268553         mov ah, byte ptr [0x5385]
  0231E1  2B71: 250002           and ax, 0x200
  0231E4  2B74: 3d0100           cmp ax, 1
  0231E7  2B77: 1bd2             sbb dx, dx
  0231E9  2B79: f7da             neg dx
  0231EB  2B7B: b80a00           mov ax, 0xa
  0231EE  2B7E: 9a62021f19       lcall 0x191f, 0x262
  0231F3  2B83: 8d1e6d0a         lea bx, [0xa6d]
  0231F7  2B87: 9afe031f18       lcall 0x181f, 0x3fe
  0231FC  2B8C: 8126845300fc     and word ptr [0x5384], 0xfc00
  023202  2B92: b80100           mov ax, 1
  023205  2B95: 9a06031f19       lcall 0x191f, 0x306
  02320A  2B9A: 0bc0             or ax, ax
  02320C  2B9C: 7505             jne 0x2ba3
  02320E  2B9E: 800e845302       or byte ptr [0x5384], 2
  023213  2BA3: b80200           mov ax, 2
  023216  2BA6: 9a06031f19       lcall 0x191f, 0x306
  02321B  2BAB: 0bc0             or ax, ax
  02321D  2BAD: 7505             jne 0x2bb4
  02321F  2BAF: 800e845301       or byte ptr [0x5384], 1
  023224  2BB4: b80300           mov ax, 3
  023227  2BB7: 9a06031f19       lcall 0x191f, 0x306
  02322C  2BBC: 0bc0             or ax, ax
  02322E  2BBE: 7505             jne 0x2bc5
  023230  2BC0: 800e845380       or byte ptr [0x5384], 0x80
  023235  2BC5: b80400           mov ax, 4
  023238  2BC8: 9a06031f19       lcall 0x191f, 0x306
  02323D  2BCD: 0bc0             or ax, ax
  02323F  2BCF: 7505             jne 0x2bd6
  023241  2BD1: 800e845340       or byte ptr [0x5384], 0x40
  023246  2BD6: b80500           mov ax, 5
  023249  2BD9: 9a06031f19       lcall 0x191f, 0x306
  02324E  2BDE: 0bc0             or ax, ax
  023250  2BE0: 7505             jne 0x2be7
  023252  2BE2: 800e845320       or byte ptr [0x5384], 0x20
  023257  2BE7: b80600           mov ax, 6
  02325A  2BEA: 9a06031f19       lcall 0x191f, 0x306
  02325F  2BEF: 0bc0             or ax, ax
  023261  2BF1: 7505             jne 0x2bf8
  023263  2BF3: 800e845310       or byte ptr [0x5384], 0x10
  023268  2BF8: b80700           mov ax, 7
  02326B  2BFB: 9a06031f19       lcall 0x191f, 0x306
  023270  2C00: 0bc0             or ax, ax
  023272  2C02: 7505             jne 0x2c09
  023274  2C04: 800e845308       or byte ptr [0x5384], 8
  023279  2C09: b80800           mov ax, 8
  02327C  2C0C: 9a06031f19       lcall 0x191f, 0x306
  023281  2C11: 0bc0             or ax, ax
  023283  2C13: 7505             jne 0x2c1a
  023285  2C15: 800e845304       or byte ptr [0x5384], 4
  02328A  2C1A: b80900           mov ax, 9
  02328D  2C1D: 9a06031f19       lcall 0x191f, 0x306
  023292  2C22: 0bc0             or ax, ax
  023294  2C24: 7505             jne 0x2c2b
  023296  2C26: 800e855301       or byte ptr [0x5385], 1
  02329B  2C2B: b80a00           mov ax, 0xa
  02329E  2C2E: 9a06031f19       lcall 0x191f, 0x306
  0232A3  2C33: 0bc0             or ax, ax
  0232A5  2C35: 7505             jne 0x2c3c
  0232A7  2C37: 800e855302       or byte ptr [0x5385], 2
  0232AC  2C3C: cb               retf 
  0232AD  2C3D: 90               nop 
  0232AE  2C3E: 9a6e021f19       lcall 0x191f, 0x26e
  0232B3  2C43: b80100           mov ax, 1
  0232B6  2C46: 8b16a200         mov dx, word ptr [0xa2]
  0232BA  2C4A: 9a62021f19       lcall 0x191f, 0x262
  0232BF  2C4F: b80200           mov ax, 2
  0232C2  2C52: 8b16a000         mov dx, word ptr [0xa0]
  0232C6  2C56: 9a62021f19       lcall 0x191f, 0x262
  0232CB  2C5B: b80300           mov ax, 3
  0232CE  2C5E: 8b16a400         mov dx, word ptr [0xa4]
  0232D2  2C62: 9a62021f19       lcall 0x191f, 0x262
  0232D7  2C67: 8d1e7b0a         lea bx, [0xa7b]
  0232DB  2C6B: 9afe031f18       lcall 0x181f, 0x3fe
  0232E0  2C70: b80100           mov ax, 1
  0232E3  2C73: 9a06031f19       lcall 0x191f, 0x306
  0232E8  2C78: a3a200           mov word ptr [0xa2], ax
  0232EB  2C7B: b80200           mov ax, 2
  0232EE  2C7E: 9a06031f19       lcall 0x191f, 0x306
  0232F3  2C83: a3a000           mov word ptr [0xa0], ax
  0232F6  2C86: b80300           mov ax, 3
  0232F9  2C89: 9a06031f19       lcall 0x191f, 0x306
  0232FE  2C8E: a3a400           mov word ptr [0xa4], ax
  023301  2C91: 80268653f1       and byte ptr [0x5386], 0xf1
  023306  2C96: 833ea20000       cmp word ptr [0xa2], 0
  02330B  2C9B: 7405             je 0x2ca2
  02330D  2C9D: 800e865302       or byte ptr [0x5386], 2
  023312  2CA2: 833ea00000       cmp word ptr [0xa0], 0
  023317  2CA7: 7405             je 0x2cae
  023319  2CA9: 800e865304       or byte ptr [0x5386], 4
  02331E  2CAE: 0bc0             or ax, ax
  023320  2CB0: 7405             je 0x2cb7
  023322  2CB2: 800e865308       or byte ptr [0x5386], 8
  023327  2CB7: 833ea00000       cmp word ptr [0xa0], 0
  02332C  2CBC: 740b             je 0x2cc9
  02332E  2CBE: 833ea20000       cmp word ptr [0xa2], 0
  023333  2CC3: 7404             je 0x2cc9
  023335  2CC5: 0bc0             or ax, ax
  023337  2CC7: 750a             jne 0x2cd3
  023339  2CC9: 6a01             push 1
  02333B  2CCB: 9ade041f18       lcall 0x181f, 0x4de
  023340  2CD0: 83c402           add sp, 2
  023343  2CD3: cb               retf 

; ---- func_023344  size=551  insns=189  prologue=ENTER 0x0008,0  terminal=RETF ----
  023344  2CD4: c8080000         enter 8, 0
  023348  2CD8: 2bc0             sub ax, ax
  02334A  2CDA: 8946fe           mov word ptr [bp - 2], ax
  02334D  2CDD: 8946f8           mov word ptr [bp - 8], ax
  023350  2CE0: 8946fc           mov word ptr [bp - 4], ax
  023353  2CE3: 8946fa           mov word ptr [bp - 6], ax
  023356  2CE6: a19600           mov ax, word ptr [0x96]
  023359  2CE9: eb79             jmp 0x2d64
  02335B  2CEB: 90               nop 
  02335C  2CEC: c746fe0100       mov word ptr [bp - 2], 1
  023361  2CF1: e9b800           jmp 0x2dac
  023364  2CF4: c746fe0200       mov word ptr [bp - 2], 2
  023369  2CF9: e9b000           jmp 0x2dac
  02336C  2CFC: c746fe0300       mov word ptr [bp - 2], 3
  023371  2D01: e9a800           jmp 0x2dac
  023374  2D04: c746fe0400       mov word ptr [bp - 2], 4
  023379  2D09: e9a000           jmp 0x2dac
  02337C  2D0C: c746fe0500       mov word ptr [bp - 2], 5
  023381  2D11: e99800           jmp 0x2dac
  023384  2D14: c746fe0600       mov word ptr [bp - 2], 6
  023389  2D19: e99000           jmp 0x2dac
  02338C  2D1C: c746fe0700       mov word ptr [bp - 2], 7
  023391  2D21: e98800           jmp 0x2dac
  023394  2D24: c746fe0800       mov word ptr [bp - 2], 8
  023399  2D29: e98000           jmp 0x2dac
  02339C  2D2C: c746fe0900       mov word ptr [bp - 2], 9
  0233A1  2D31: eb79             jmp 0x2dac
  0233A3  2D33: 90               nop 
  0233A4  2D34: c746fe0a00       mov word ptr [bp - 2], 0xa
  0233A9  2D39: eb71             jmp 0x2dac
  0233AB  2D3B: 90               nop 
  0233AC  2D3C: c746fe0b00       mov word ptr [bp - 2], 0xb
  0233B1  2D41: eb69             jmp 0x2dac
  0233B3  2D43: 90               nop 
  0233B4  2D44: c746fe0c00       mov word ptr [bp - 2], 0xc
  0233B9  2D49: eb61             jmp 0x2dac
  0233BB  2D4B: 90               nop 
  0233BC  2D4C: c746fe0d00       mov word ptr [bp - 2], 0xd
  0233C1  2D51: eb59             jmp 0x2dac
  0233C3  2D53: 90               nop 
  0233C4  2D54: c746fe0e00       mov word ptr [bp - 2], 0xe
  0233C9  2D59: eb51             jmp 0x2dac
  0233CB  2D5B: 90               nop 
  0233CC  2D5C: c746fe0f00       mov word ptr [bp - 2], 0xf
  0233D1  2D61: eb49             jmp 0x2dac
  0233D3  2D63: 90               nop 
  0233D4  2D64: 2d2000           sub ax, 0x20
  0233D7  2D67: 3d1b00           cmp ax, 0x1b
  0233DA  2D6A: 7740             ja 0x2dac
  0233DC  2D6C: d1e0             shl ax, 1
  0233DE  2D6E: 93               xchg bx, ax
  0233DF  2D6F: 2effa70425       jmp word ptr cs:[bx + 0x2504]
  0233E4  2D74: 7c24             jl 0x2d9a
  0233E6  2D76: 8424             test byte ptr [si], ah
  0233E8  2D78: 8c24             mov word ptr [si], fs
  0233EA  2D7A: 94               xchg sp, ax
  0233EB  2D7B: 249c             and al, 0x9c
  0233ED  2D7D: 24a4             and al, 0xa4
  0233EF  2D7F: 24ac             and al, 0xac
  0233F1  2D81: 24b4             and al, 0xb4
  0233F3  2D83: 24dc             and al, 0xdc
  0233F5  2D85: 24dc             and al, 0xdc
  0233F7  2D87: 24dc             and al, 0xdc
  0233F9  2D89: 24dc             and al, 0xdc
  0233FB  2D8B: 24dc             and al, 0xdc
  0233FD  2D8D: 24dc             and al, 0xdc
  0233FF  2D8F: 24e4             and al, 0xe4
  023401  2D91: 24e4             and al, 0xe4
  023403  2D93: 24e4             and al, 0xe4
  023405  2D95: 24e4             and al, 0xe4
  023407  2D97: 24ec             and al, 0xec
  023409  2D99: 24ec             and al, 0xec
  02340B  2D9B: 243c             and al, 0x3c
  02340D  2D9D: 25ec24           and ax, 0x24ec
  023410  2DA0: ec               in al, dx
  023411  2DA1: 243c             and al, 0x3c
  023413  2DA3: 25c424           and ax, 0x24c4
  023416  2DA6: bc24cc           mov sp, 0xcc24
  023419  2DA9: 24d4             and al, 0xd4
  02341B  2DAB: 248d             and al, 0x8d
  02341D  2DAD: 1e               push ds
  02341E  2DAE: 7c08             jl 0x2db8
  023420  2DB0: 8d06880a         lea ax, [0xa88]
  023424  2DB4: 8b56fe           mov dx, word ptr [bp - 2]
  023427  2DB7: 9a82011f19       lcall 0x191f, 0x182
  02342C  2DBC: 8946fa           mov word ptr [bp - 6], ax
  02342F  2DBF: 8956fc           mov word ptr [bp - 4], dx
  023432  2DC2: 0bd0             or dx, ax
  023434  2DC4: 7503             jne 0x2dc9
  023436  2DC6: e93001           jmp 0x2ef9
  023439  2DC9: 837efe00         cmp word ptr [bp - 2], 0
  02343D  2DCD: 7411             je 0x2de0
  02343F  2DCF: 6a01             push 1
  023441  2DD1: ff76fe           push word ptr [bp - 2]
  023444  2DD4: ff76fc           push word ptr [bp - 4]
  023447  2DD7: 50               push ax
  023448  2DD8: 9a3c031f19       lcall 0x191f, 0x33c
  02344D  2DDD: 83c408           add sp, 8
  023450  2DE0: ff76fc           push word ptr [bp - 4]
  023453  2DE3: ff76fa           push word ptr [bp - 6]
  023456  2DE6: 9a6a011f19       lcall 0x191f, 0x16a
  02345B  2DEB: 8946fe           mov word ptr [bp - 2], ax
  02345E  2DEE: ff76fc           push word ptr [bp - 4]
  023461  2DF1: ff76fa           push word ptr [bp - 6]
  023464  2DF4: 9aa8011f19       lcall 0x191f, 0x1a8
  023469  2DF9: 2bc0             sub ax, ax
  02346B  2DFB: 8946fc           mov word ptr [bp - 4], ax
  02346E  2DFE: 8946fa           mov word ptr [bp - 6], ax
  023471  2E01: 3946fe           cmp word ptr [bp - 2], ax
  023474  2E04: 7f03             jg 0x2e09
  023476  2E06: e9f000           jmp 0x2ef9
  023479  2E09: 8b46fe           mov ax, word ptr [bp - 2]
  02347C  2E0C: e9ad00           jmp 0x2ebc
  02347F  2E0F: 90               nop 
  023480  2E10: c746f82000       mov word ptr [bp - 8], 0x20
  023485  2E15: e9d000           jmp 0x2ee8
  023488  2E18: c746f82100       mov word ptr [bp - 8], 0x21
  02348D  2E1D: e9c800           jmp 0x2ee8
  023490  2E20: c746f82200       mov word ptr [bp - 8], 0x22
  023495  2E25: e9c000           jmp 0x2ee8
  023498  2E28: c746f82300       mov word ptr [bp - 8], 0x23
  02349D  2E2D: e9b800           jmp 0x2ee8
  0234A0  2E30: c746f82400       mov word ptr [bp - 8], 0x24
  0234A5  2E35: e9b000           jmp 0x2ee8
  0234A8  2E38: c746f82500       mov word ptr [bp - 8], 0x25
  0234AD  2E3D: e9a800           jmp 0x2ee8
  0234B0  2E40: c746f82600       mov word ptr [bp - 8], 0x26
  0234B5  2E45: e9a000           jmp 0x2ee8
  0234B8  2E48: c746f82700       mov word ptr [bp - 8], 0x27
  0234BD  2E4D: e99800           jmp 0x2ee8
  0234C0  2E50: c746f83900       mov word ptr [bp - 8], 0x39
  0234C5  2E55: e99000           jmp 0x2ee8
  0234C8  2E58: c746f83800       mov word ptr [bp - 8], 0x38
  0234CD  2E5D: e98800           jmp 0x2ee8
  0234D0  2E60: c746f83a00       mov word ptr [bp - 8], 0x3a
  0234D5  2E65: e98000           jmp 0x2ee8
  0234D8  2E68: c746f83b00       mov word ptr [bp - 8], 0x3b
  0234DD  2E6D: eb79             jmp 0x2ee8
  0234DF  2E6F: 90               nop 
  0234E0  2E70: 8d1e920a         lea bx, [0xa92]
  0234E4  2E74: 9afe031f18       lcall 0x181f, 0x3fe
  0234E9  2E79: 8946fe           mov word ptr [bp - 2], ax
  0234EC  2E7C: 0bc0             or ax, ax
  0234EE  2E7E: 7468             je 0x2ee8
  0234F0  2E80: 052800           add ax, 0x28
  0234F3  2E83: 8946f8           mov word ptr [bp - 8], ax
  0234F6  2E86: eb60             jmp 0x2ee8
  0234F8  2E88: 8d1ea30a         lea bx, [0xaa3]
  0234FC  2E8C: 9afe031f18       lcall 0x181f, 0x3fe
  023501  2E91: 8946fe           mov word ptr [bp - 2], ax
  023504  2E94: 0bc0             or ax, ax
  023506  2E96: 7450             je 0x2ee8
  023508  2E98: 052d00           add ax, 0x2d
  02350B  2E9B: ebe6             jmp 0x2e83
  02350D  2E9D: 90               nop 
  02350E  2E9E: 8d1eb00a         lea bx, [0xab0]
  023512  2EA2: 9afe031f18       lcall 0x181f, 0x3fe
  023517  2EA7: 8946fe           mov word ptr [bp - 2], ax
  02351A  2EAA: 3d0200           cmp ax, 2
  02351D  2EAD: 7e04             jle 0x2eb3
  02351F  2EAF: 40               inc ax
  023520  2EB0: 8946fe           mov word ptr [bp - 2], ax
  023523  2EB3: 0bc0             or ax, ax
  023525  2EB5: 7431             je 0x2ee8
  023527  2EB7: 053100           add ax, 0x31
  02352A  2EBA: ebc7             jmp 0x2e83
  02352C  2EBC: 48               dec ax
  02352D  2EBD: 3d0e00           cmp ax, 0xe
  023530  2EC0: 7726             ja 0x2ee8
  023532  2EC2: d1e0             shl ax, 1
  023534  2EC4: 93               xchg bx, ax
  023535  2EC5: 2effa75a26       jmp word ptr cs:[bx + 0x265a]
  02353A  2ECA: a025a8           mov al, byte ptr [0xa825]
  02353D  2ECD: 25b025           and ax, 0x25b0
  023540  2ED0: b825c0           mov ax, 0xc025
  023543  2ED3: 25c825           and ax, 0x25c8
  023546  2ED6: d025             shl byte ptr [di], 1
  023548  2ED8: d825             fsub dword ptr [di]
  02354A  2EDA: e025             loopne 0x2f01
  02354C  2EDC: e825f0           call 0x1f04
  02354F  2EDF: 25f825           and ax, 0x25f8
  023552  2EE2: 00261826         add byte ptr [0x2618], ah
  023556  2EE6: 2e26837ef800     cmp word ptr es:[bp - 8], 0
  02355C  2EEC: 740b             je 0x2ef9
  02355E  2EEE: 8b46f8           mov ax, word ptr [bp - 8]
  023561  2EF1: a39600           mov word ptr [0x96], ax
  023564  2EF4: 9ac0041f18       lcall 0x181f, 0x4c0
  023569  2EF9: c9               leave 
  02356A  2EFA: cb               retf 

; ---- func_02356C  size=105  insns=36  prologue=ENTER 0x0002,0  terminal=RETF ----
  02356C  2EFC: c8020000         enter 2, 0
  023570  2F00: 9a6e021f19       lcall 0x191f, 0x26e
  023575  2F05: c746fe0000       mov word ptr [bp - 2], 0
  02357A  2F0A: 8b46fe           mov ax, word ptr [bp - 2]
  02357D  2F0D: 8bc8             mov cx, ax
  02357F  2F0F: 40               inc ax
  023580  2F10: 2aed             sub ch, ch
  023582  2F12: ba0100           mov dx, 1
  023585  2F15: d3e2             shl dx, cl
  023587  2F17: 23169408         and dx, word ptr [0x894]
  02358B  2F1B: 9a62021f19       lcall 0x191f, 0x262
  023590  2F20: ff46fe           inc word ptr [bp - 2]
  023593  2F23: 837efe07         cmp word ptr [bp - 2], 7
  023597  2F27: 7ce1             jl 0x2f0a
  023599  2F29: 8d1ec30a         lea bx, [0xac3]
  02359D  2F2D: 8d06bb0a         lea ax, [0xabb]
  0235A1  2F31: 2bd2             sub dx, dx
  0235A3  2F33: 9a98091f18       lcall 0x181f, 0x998
  0235A8  2F38: 2bc0             sub ax, ax
  0235AA  2F3A: a39408           mov word ptr [0x894], ax
  0235AD  2F3D: 8946fe           mov word ptr [bp - 2], ax
  0235B0  2F40: eb1b             jmp 0x2f5d
  0235B2  2F42: 8b46fe           mov ax, word ptr [bp - 2]
  0235B5  2F45: 40               inc ax
  0235B6  2F46: 9a06031f19       lcall 0x191f, 0x306
  0235BB  2F4B: 3d0100           cmp ax, 1
  0235BE  2F4E: 1bc0             sbb ax, ax
  0235C0  2F50: 40               inc ax
  0235C1  2F51: 8a4efe           mov cl, byte ptr [bp - 2]
  0235C4  2F54: d3e0             shl ax, cl
  0235C6  2F56: 09069408         or word ptr [0x894], ax
  0235CA  2F5A: ff46fe           inc word ptr [bp - 2]
  0235CD  2F5D: 837efe07         cmp word ptr [bp - 2], 7
  0235D1  2F61: 7cdf             jl 0x2f42
  0235D3  2F63: c9               leave 
  0235D4  2F64: cb               retf 

; ---- func_0235D6  size=2374  insns=818  prologue=ENTER 0x001E,0  terminal=RETF ----
  0235D6  2F66: c81e0000         enter 0x1e, 0
  0235DA  2F6A: 2bc0             sub ax, ax
  0235DC  2F6C: 8946fa           mov word ptr [bp - 6], ax
  0235DF  2F6F: 8946f8           mov word ptr [bp - 8], ax
  0235E2  2F72: 8b4606           mov ax, word ptr [bp + 6]
  0235E5  2F75: 3d1a00           cmp ax, 0x1a
  0235E8  2F78: 7434             je 0x2fae
  0235EA  2F7A: 7e03             jle 0x2f7f
  0235EC  2F7C: e9d907           jmp 0x3758
  0235EF  2F7F: 48               dec ax
  0235F0  2F80: 740c             je 0x2f8e
  0235F2  2F82: 48               dec ax
  0235F3  2F83: 7411             je 0x2f96
  0235F5  2F85: 48               dec ax
  0235F6  2F86: 7416             je 0x2f9e
  0235F8  2F88: 48               dec ax
  0235F9  2F89: 741b             je 0x2fa6
  0235FB  2F8B: e91809           jmp 0x38a6
  0235FE  2F8E: 0e               push cs
  0235FF  2F8F: e8b215           call 0x4544
  023602  2F92: e91109           jmp 0x38a6
  023605  2F95: 90               nop 
  023606  2F96: 0e               push cs
  023607  2F97: e8dc15           call 0x4576
  02360A  2F9A: e90909           jmp 0x38a6
  02360D  2F9D: 90               nop 
  02360E  2F9E: 0e               push cs
  02360F  2F9F: e81615           call 0x44b8
  023612  2FA2: e90109           jmp 0x38a6
  023615  2FA5: 90               nop 
  023616  2FA6: 0e               push cs
  023617  2FA7: e81d15           call 0x44c7
  02361A  2FAA: e9f908           jmp 0x38a6
  02361D  2FAD: 90               nop 
  02361E  2FAE: 9a2e031f19       lcall 0x191f, 0x32e
  023623  2FB3: e9f008           jmp 0x38a6
  023626  2FB6: 9a20031f19       lcall 0x191f, 0x320
  02362B  2FBB: 8946fc           mov word ptr [bp - 4], ax
  02362E  2FBE: 0bc0             or ax, ax
  023630  2FC0: 7503             jne 0x2fc5
  023632  2FC2: e9de02           jmp 0x32a3
  023635  2FC5: 48               dec ax
  023636  2FC6: 48               dec ax
  023637  2FC7: 7403             je 0x2fcc
  023639  2FC9: e9da08           jmp 0x38a6
  02363C  2FCC: c706c2530000     mov word ptr [0x53c2], 0
  023642  2FD2: e9d108           jmp 0x38a6
  023645  2FD5: 90               nop 
  023646  2FD6: 9a12031f19       lcall 0x191f, 0x312
  02364B  2FDB: e9c808           jmp 0x38a6
  02364E  2FDE: 8d1e7c08         lea bx, [0x87c]
  023652  2FE2: 8d06c90a         lea ax, [0xac9]
  023656  2FE6: 2bd2             sub dx, dx
  023658  2FE8: 9a98091f18       lcall 0x181f, 0x998
  02365D  2FED: 48               dec ax
  02365E  2FEE: 7403             je 0x2ff3
  023660  2FF0: e9b308           jmp 0x38a6
  023663  2FF3: f606825310       test byte ptr [0x5382], 0x10
  023668  2FF8: 75d2             jne 0x2fcc
  02366A  2FFA: 9a74051f18       lcall 0x181f, 0x574
  02366F  2FFF: ebcb             jmp 0x2fcc
  023671  3001: 90               nop 
  023672  3002: 8d1e7c08         lea bx, [0x87c]
  023676  3006: 8d06d00a         lea ax, [0xad0]
  02367A  300A: 2bd2             sub dx, dx
  02367C  300C: 9a98091f18       lcall 0x181f, 0x998
  023681  3011: ebb3             jmp 0x2fc6
  023683  3013: 90               nop 
  023684  3014: 833e905300       cmp word ptr [0x5390], 0
  023689  3019: 7515             jne 0x3030
  02368B  301B: 6a01             push 1
  02368D  301D: ff363e85         push word ptr [0x853e]
  023691  3021: ff364085         push word ptr [0x8540]
  023695  3025: 9a080e1f18       lcall 0x181f, 0xe08
  02369A  302A: 83c406           add sp, 6
  02369D  302D: e97608           jmp 0x38a6
  0236A0  3030: 6a00             push 0
  0236A2  3032: 0e               push cs
  0236A3  3033: e8aa14           call 0x44e0
  0236A6  3036: e9b906           jmp 0x36f2
  0236A9  3039: 90               nop 
  0236AA  303A: 0e               push cs
  0236AB  303B: e8f714           call 0x4535
  0236AE  303E: e96508           jmp 0x38a6
  0236B1  3041: 90               nop 
  0236B2  3042: f606825301       test byte ptr [0x5382], 1
  0236B7  3047: 7413             je 0x305c
  0236B9  3049: 833ea25300       cmp word ptr [0x53a2], 0
  0236BE  304E: 750c             jne 0x305c
  0236C0  3050: 8d1ed40a         lea bx, [0xad4]
  0236C4  3054: 9afe031f18       lcall 0x181f, 0x3fe
  0236C9  3059: e94a08           jmp 0x38a6
  0236CC  305C: 833ea25300       cmp word ptr [0x53a2], 0
  0236D1  3061: 7431             je 0x3094
  0236D3  3063: c7065e1f0400     mov word ptr [0x1f5e], 4
  0236D9  3069: 8b169653         mov dx, word ptr [0x5396]
  0236DD  306D: 42               inc dx
  0236DE  306E: 8d1eed0a         lea bx, [0xaed]
  0236E2  3072: 8d06e30a         lea ax, [0xae3]
  0236E6  3076: 9a98091f18       lcall 0x181f, 0x998
  0236EB  307B: 8946fe           mov word ptr [bp - 2], ax
  0236EE  307E: 0bc0             or ax, ax
  0236F0  3080: 7f03             jg 0x3085
  0236F2  3082: e92108           jmp 0x38a6
  0236F5  3085: 6aff             push -1
  0236F7  3087: 48               dec ax
  0236F8  3088: 50               push ax
  0236F9  3089: 9afa051f18       lcall 0x181f, 0x5fa
  0236FE  308E: 83c404           add sp, 4
  023701  3091: e91208           jmp 0x38a6
  023704  3094: 833ea45300       cmp word ptr [0x53a4], 0
  023709  3099: 7c09             jl 0x30a4
  02370B  309B: 6aff             push -1
  02370D  309D: ff36a453         push word ptr [0x53a4]
  023711  30A1: ebe6             jmp 0x3089
  023713  30A3: 90               nop 
  023714  30A4: 6aff             push -1
  023716  30A6: ff369453         push word ptr [0x5394]
  02371A  30AA: ebdd             jmp 0x3089
  02371C  30AC: 0e               push cs
  02371D  30AD: e85814           call 0x4508
  023720  30B0: e9f307           jmp 0x38a6
  023723  30B3: 90               nop 
  023724  30B4: a18401           mov ax, word ptr [0x184]
  023727  30B7: 48               dec ax
  023728  30B8: 50               push ax
  023729  30B9: 0e               push cs
  02372A  30BA: e86e14           call 0x452b
  02372D  30BD: e93206           jmp 0x36f2
  023730  30C0: a18401           mov ax, word ptr [0x184]
  023733  30C3: 40               inc ax
  023734  30C4: ebf2             jmp 0x30b8
  023736  30C6: b82900           mov ax, 0x29
  023739  30C9: 2b4606           sub ax, word ptr [bp + 6]
  02373C  30CC: ebea             jmp 0x30b8
  02373E  30CE: 0e               push cs
  02373F  30CF: e8fa13           call 0x44cc
  023742  30D2: e9d107           jmp 0x38a6
  023745  30D5: 90               nop 
  023746  30D6: ff363e85         push word ptr [0x853e]
  02374A  30DA: ff364085         push word ptr [0x8540]
  02374E  30DE: 0e               push cs
  02374F  30DF: e8f913           call 0x44db
  023752  30E2: ebaa             jmp 0x308e
  023754  30E4: 0e               push cs
  023755  30E5: e8c613           call 0x44ae
  023758  30E8: e9bb07           jmp 0x38a6
  02375B  30EB: 90               nop 
  02375C  30EC: 0e               push cs
  02375D  30ED: e8b913           call 0x44a9
  023760  30F0: e9b307           jmp 0x38a6
  023763  30F3: 90               nop 
  023764  30F4: 0e               push cs
  023765  30F5: e8de13           call 0x44d6
  023768  30F8: e9ab07           jmp 0x38a6
  02376B  30FB: 90               nop 
  02376C  30FC: 0e               push cs
  02376D  30FD: e82114           call 0x4521
  023770  3100: e9a307           jmp 0x38a6
  023773  3103: 90               nop 
  023774  3104: 0e               push cs
  023775  3105: e82814           call 0x4530
  023778  3108: e99b07           jmp 0x38a6
  02377B  310B: 90               nop 
  02377C  310C: 0e               push cs
  02377D  310D: e83914           call 0x4549
  023780  3110: e99307           jmp 0x38a6
  023783  3113: 90               nop 
  023784  3114: 0e               push cs
  023785  3115: e83b14           call 0x4553
  023788  3118: e98b07           jmp 0x38a6
  02378B  311B: 90               nop 
  02378C  311C: 0e               push cs
  02378D  311D: e84214           call 0x4562
  023790  3120: e98307           jmp 0x38a6
  023793  3123: 90               nop 
  023794  3124: 0e               push cs
  023795  3125: e8d613           call 0x44fe
  023798  3128: e97b07           jmp 0x38a6
  02379B  312B: 90               nop 
  02379C  312C: 0e               push cs
  02379D  312D: e8dd13           call 0x450d
  0237A0  3130: e97307           jmp 0x38a6
  0237A3  3133: 90               nop 
  0237A4  3134: 0e               push cs
  0237A5  3135: e84314           call 0x457b
  0237A8  3138: e96b07           jmp 0x38a6
  0237AB  313B: 90               nop 
  0237AC  313C: 0e               push cs
  0237AD  313D: e8aa13           call 0x44ea
  0237B0  3140: e96307           jmp 0x38a6
  0237B3  3143: 90               nop 
  0237B4  3144: 0e               push cs
  0237B5  3145: e82914           call 0x4571
  0237B8  3148: e95b07           jmp 0x38a6
  0237BB  314B: 90               nop 
  0237BC  314C: 0e               push cs
  0237BD  314D: e85413           call 0x44a4
  0237C0  3150: e95307           jmp 0x38a6
  0237C3  3153: 90               nop 
  0237C4  3154: 833e965304       cmp word ptr [0x5396], 4
  0237C9  3159: 7d29             jge 0x3184
  0237CB  315B: ff363e85         push word ptr [0x853e]
  0237CF  315F: ff364085         push word ptr [0x8540]
  0237D3  3163: 9a4a071f18       lcall 0x181f, 0x74a
  0237D8  3168: 83c404           add sp, 4
  0237DB  316B: 2ae4             sub ah, ah
  0237DD  316D: 8a0e9653         mov cl, byte ptr [0x5396]
  0237E1  3171: ba1000           mov dx, 0x10
  0237E4  3174: d3e2             shl dx, cl
  0237E6  3176: 85c2             test dx, ax
  0237E8  3178: 750a             jne 0x3184
  0237EA  317A: 833ea25300       cmp word ptr [0x53a2], 0
  0237EF  317F: 7503             jne 0x3184
  0237F1  3181: e92207           jmp 0x38a6
  0237F4  3184: ff363e85         push word ptr [0x853e]
  0237F8  3188: ff364085         push word ptr [0x8540]
  0237FC  318C: 9a8c071f18       lcall 0x181f, 0x78c
  023801  3191: 83c404           add sp, 4
  023804  3194: 8946ec           mov word ptr [bp - 0x14], ax
  023807  3197: 50               push ax
  023808  3198: 9a28041f19       lcall 0x191f, 0x428
  02380D  319D: e90001           jmp 0x32a0
  023810  31A0: a19653           mov ax, word ptr [0x5396]
  023813  31A3: 8946e4           mov word ptr [bp - 0x1c], ax
  023816  31A6: 833ea25300       cmp word ptr [0x53a2], 0
  02381B  31AB: 741d             je 0x31ca
  02381D  31AD: c7065e1f0500     mov word ptr [0x1f5e], 5
  023823  31B3: 8bd0             mov dx, ax
  023825  31B5: 42               inc dx
  023826  31B6: 8d1efd0a         lea bx, [0xafd]
  02382A  31BA: 8d06f30a         lea ax, [0xaf3]
  02382E  31BE: 9a98091f18       lcall 0x181f, 0x998
  023833  31C3: 8946fe           mov word ptr [bp - 2], ax
  023836  31C6: 48               dec ax
  023837  31C7: 8946e4           mov word ptr [bp - 0x1c], ax
  02383A  31CA: 837ee400         cmp word ptr [bp - 0x1c], 0
  02383E  31CE: 7d03             jge 0x31d3
  023840  31D0: e9d306           jmp 0x38a6
  023843  31D3: 837e0648         cmp word ptr [bp + 6], 0x48
  023847  31D7: 750b             jne 0x31e4
  023849  31D9: ff76e4           push word ptr [bp - 0x1c]
  02384C  31DC: 9a1a041f19       lcall 0x191f, 0x41a
  023851  31E1: 83c402           add sp, 2
  023854  31E4: 837e0641         cmp word ptr [bp + 6], 0x41
  023858  31E8: 750b             jne 0x31f5
  02385A  31EA: ff76e4           push word ptr [bp - 0x1c]
  02385D  31ED: 9a0c041f19       lcall 0x191f, 0x40c
  023862  31F2: 83c402           add sp, 2
  023865  31F5: 837e0642         cmp word ptr [bp + 6], 0x42
  023869  31F9: 750b             jne 0x3206
  02386B  31FB: ff76e4           push word ptr [bp - 0x1c]
  02386E  31FE: 9afe031f19       lcall 0x191f, 0x3fe
  023873  3203: 83c402           add sp, 2
  023876  3206: 837e0643         cmp word ptr [bp + 6], 0x43
  02387A  320A: 750b             jne 0x3217
  02387C  320C: ff76e4           push word ptr [bp - 0x1c]
  02387F  320F: 9af0031f19       lcall 0x191f, 0x3f0
  023884  3214: 83c402           add sp, 2
  023887  3217: 837e0644         cmp word ptr [bp + 6], 0x44
  02388B  321B: 750b             jne 0x3228
  02388D  321D: ff76e4           push word ptr [bp - 0x1c]
  023890  3220: 9ae2031f19       lcall 0x191f, 0x3e2
  023895  3225: 83c402           add sp, 2
  023898  3228: 837e0645         cmp word ptr [bp + 6], 0x45
  02389C  322C: 750b             jne 0x3239
  02389E  322E: ff76e4           push word ptr [bp - 0x1c]
  0238A1  3231: 9ad4031f19       lcall 0x191f, 0x3d4
  0238A6  3236: 83c402           add sp, 2
  0238A9  3239: 837e0646         cmp word ptr [bp + 6], 0x46
  0238AD  323D: 750b             jne 0x324a
  0238AF  323F: ff76e4           push word ptr [bp - 0x1c]
  0238B2  3242: 9ac6031f19       lcall 0x191f, 0x3c6
  0238B7  3247: 83c402           add sp, 2
  0238BA  324A: 837e0647         cmp word ptr [bp + 6], 0x47
  0238BE  324E: 750b             jne 0x325b
  0238C0  3250: ff76e4           push word ptr [bp - 0x1c]
  0238C3  3253: 9ab8031f19       lcall 0x191f, 0x3b8
  0238C8  3258: 83c402           add sp, 2
  0238CB  325B: 837e0649         cmp word ptr [bp + 6], 0x49
  0238CF  325F: 7542             jne 0x32a3
  0238D1  3261: f606835320       test byte ptr [0x5383], 0x20
  0238D6  3266: 7408             je 0x3270
  0238D8  3268: 9a74051f18       lcall 0x181f, 0x574
  0238DD  326D: eb34             jmp 0x32a3
  0238DF  326F: 90               nop 
  0238E0  3270: 6a01             push 1
  0238E2  3272: 9aaa031f19       lcall 0x191f, 0x3aa
  0238E7  3277: eb27             jmp 0x32a0
  0238E9  3279: 90               nop 
  0238EA  327A: 9a9c031f19       lcall 0x191f, 0x39c
  0238EF  327F: e92406           jmp 0x38a6
  0238F2  3282: 6aff             push -1
  0238F4  3284: 9a8e031f19       lcall 0x191f, 0x38e
  0238F9  3289: e96604           jmp 0x36f2
  0238FC  328C: 9a80031f19       lcall 0x191f, 0x380
  023901  3291: e91206           jmp 0x38a6
  023904  3294: 8b4606           mov ax, word ptr [bp + 6]
  023907  3297: 2d7000           sub ax, 0x70
  02390A  329A: 50               push ax
  02390B  329B: 9a72031f19       lcall 0x191f, 0x372
  023910  32A0: 83c402           add sp, 2
  023913  32A3: 9a6a051f18       lcall 0x181f, 0x56a
  023918  32A8: e9fb05           jmp 0x38a6
  02391B  32AB: 90               nop 
  02391C  32AC: 833ed0534b       cmp word ptr [0x53d0], 0x4b
  023921  32B1: 7c07             jl 0x32ba
  023923  32B3: f606815380       test byte ptr [0x5381], 0x80
  023928  32B8: 7418             je 0x32d2
  02392A  32BA: c706d0534b00     mov word ptr [0x53d0], 0x4b
  023930  32C0: 833ed25300       cmp word ptr [0x53d2], 0
  023935  32C5: 7c03             jl 0x32ca
  023937  32C7: e9dc05           jmp 0x38a6
  02393A  32CA: 9a64031f19       lcall 0x191f, 0x364
  02393F  32CF: e9d405           jmp 0x38a6
  023942  32D2: f606825301       test byte ptr [0x5382], 1
  023947  32D7: 7509             jne 0x32e2
  023949  32D9: 9a56031f19       lcall 0x191f, 0x356
  02394E  32DE: e9c505           jmp 0x38a6
  023951  32E1: 90               nop 
  023952  32E2: f606825302       test byte ptr [0x5382], 2
  023957  32E7: 7509             jne 0x32f2
  023959  32E9: 9a48031f19       lcall 0x191f, 0x348
  02395E  32EE: e9b505           jmp 0x38a6
  023961  32F1: 90               nop 
  023962  32F2: 800e825320       or byte ptr [0x5382], 0x20
  023967  32F7: 8d1e0a0b         lea bx, [0xb0a]
  02396B  32FB: 8d06030b         lea ax, [0xb03]
  02396F  32FF: 2bd2             sub dx, dx
  023971  3301: 9a98091f18       lcall 0x181f, 0x998
  023976  3306: e99d05           jmp 0x38a6
  023979  3309: 90               nop 
  02397A  330A: 813e9c532c01     cmp word ptr [0x539c], 0x12c
  023980  3310: 7c03             jl 0x3315
  023982  3312: e99105           jmp 0x38a6
  023985  3315: a19453           mov ax, word ptr [0x5394]
  023988  3318: 8946ea           mov word ptr [bp - 0x16], ax
  02398B  331B: c746e6ffff       mov word ptr [bp - 0x1a], 0xffff
  023990  3320: c7065e1f0100     mov word ptr [0x1f5e], 1
  023996  3326: f606825301       test byte ptr [0x5382], 1
  02399B  332B: 740b             je 0x3338
  02399D  332D: 8d1e180b         lea bx, [0xb18]
  0239A1  3331: 8d06100b         lea ax, [0xb10]
  0239A5  3335: eb09             jmp 0x3340
  0239A7  3337: 90               nop 
  0239A8  3338: 8d1e250b         lea bx, [0xb25]
  0239AC  333C: 8d061e0b         lea ax, [0xb1e]
  0239B0  3340: 2bd2             sub dx, dx
  0239B2  3342: 9a98091f18       lcall 0x181f, 0x998
  0239B7  3347: 8946fe           mov word ptr [bp - 2], ax
  0239BA  334A: e9cf01           jmp 0x351c
  0239BD  334D: 90               nop 
  0239BE  334E: ff363e85         push word ptr [0x853e]
  0239C2  3352: ff364085         push word ptr [0x8540]
  0239C6  3356: ff76ea           push word ptr [bp - 0x16]
  0239C9  3359: 6a00             push 0
  0239CB  335B: 9a5c091f18       lcall 0x181f, 0x95c
  0239D0  3360: 83c408           add sp, 8
  0239D3  3363: 8946e6           mov word ptr [bp - 0x1a], ax
  0239D6  3366: e9dd01           jmp 0x3546
  0239D9  3369: 90               nop 
  0239DA  336A: ff363e85         push word ptr [0x853e]
  0239DE  336E: ff364085         push word ptr [0x8540]
  0239E2  3372: ff76ea           push word ptr [bp - 0x16]
  0239E5  3375: 6a02             push 2
  0239E7  3377: ebe2             jmp 0x335b
  0239E9  3379: 90               nop 
  0239EA  337A: ff363e85         push word ptr [0x853e]
  0239EE  337E: ff364085         push word ptr [0x8540]
  0239F2  3382: ff76ea           push word ptr [bp - 0x16]
  0239F5  3385: 6a01             push 1
  0239F7  3387: ebd2             jmp 0x335b
  0239F9  3389: 90               nop 
  0239FA  338A: ff363e85         push word ptr [0x853e]
  0239FE  338E: ff364085         push word ptr [0x8540]
  023A02  3392: ff76ea           push word ptr [bp - 0x16]
  023A05  3395: 6a03             push 3
  023A07  3397: ebc2             jmp 0x335b
  023A09  3399: 90               nop 
  023A0A  339A: ff363e85         push word ptr [0x853e]
  023A0E  339E: ff364085         push word ptr [0x8540]
  023A12  33A2: ff76ea           push word ptr [bp - 0x16]
  023A15  33A5: 6a05             push 5
  023A17  33A7: ebb2             jmp 0x335b
  023A19  33A9: 90               nop 
  023A1A  33AA: ff363e85         push word ptr [0x853e]
  023A1E  33AE: ff364085         push word ptr [0x8540]
  023A22  33B2: ff76ea           push word ptr [bp - 0x16]
  023A25  33B5: 6a0b             push 0xb
  023A27  33B7: eba2             jmp 0x335b
  023A29  33B9: 90               nop 
  023A2A  33BA: ff363e85         push word ptr [0x853e]
  023A2E  33BE: ff364085         push word ptr [0x8540]
  023A32  33C2: ff76ea           push word ptr [bp - 0x16]
  023A35  33C5: 6a0c             push 0xc
  023A37  33C7: 9a5c091f18       lcall 0x181f, 0x95c
  023A3C  33CC: 83c408           add sp, 8
  023A3F  33CF: 8946e6           mov word ptr [bp - 0x1a], ax
  023A42  33D2: 6aff             push -1
  023A44  33D4: ff76ea           push word ptr [bp - 0x16]
  023A47  33D7: ff363e85         push word ptr [0x853e]
  023A4B  33DB: ff364085         push word ptr [0x8540]
  023A4F  33DF: 9a14061f18       lcall 0x181f, 0x614
  023A54  33E4: 83c408           add sp, 8
  023A57  33E7: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  023A5B  33EB: 88874a31         mov byte ptr [bx + 0x314a], al
  023A5F  33EF: e95401           jmp 0x3546
  023A62  33F2: ff363e85         push word ptr [0x853e]
  023A66  33F6: ff364085         push word ptr [0x8540]
  023A6A  33FA: ff76ea           push word ptr [bp - 0x16]
  023A6D  33FD: 6a0a             push 0xa
  023A6F  33FF: 9a5c091f18       lcall 0x181f, 0x95c
  023A74  3404: 83c408           add sp, 8
  023A77  3407: 8946e6           mov word ptr [bp - 0x1a], ax
  023A7A  340A: 6bd81c           imul bx, ax, 0x1c
  023A7D  340D: c6875b3101       mov byte ptr [bx + 0x315b], 1
  023A82  3412: e93101           jmp 0x3546
  023A85  3415: 90               nop 
  023A86  3416: 2bd2             sub dx, dx
  023A88  3418: 89165e1f         mov word ptr [0x1f5e], dx
  023A8C  341C: 8d1e310b         lea bx, [0xb31]
  023A90  3420: 8d062b0b         lea ax, [0xb2b]
  023A94  3424: 9a98091f18       lcall 0x181f, 0x998
  023A99  3429: 8946fe           mov word ptr [bp - 2], ax
  023A9C  342C: 0bc0             or ax, ax
  023A9E  342E: 7f03             jg 0x3433
  023AA0  3430: e91301           jmp 0x3546
  023AA3  3433: ff363e85         push word ptr [0x853e]
  023AA7  3437: ff364085         push word ptr [0x8540]
  023AAB  343B: ff76ea           push word ptr [bp - 0x16]
  023AAE  343E: 050c00           add ax, 0xc
  023AB1  3441: 50               push ax
  023AB2  3442: e916ff           jmp 0x335b
  023AB5  3445: 90               nop 
  023AB6  3446: f606825301       test byte ptr [0x5382], 1
  023ABB  344B: 7533             jne 0x3480
  023ABD  344D: 6aff             push -1
  023ABF  344F: 6aff             push -1
  023AC1  3451: ff363e85         push word ptr [0x853e]
  023AC5  3455: ff364085         push word ptr [0x8540]
  023AC9  3459: 9a840d1f18       lcall 0x181f, 0xd84
  023ACE  345E: 83c408           add sp, 8
  023AD1  3461: 8946e8           mov word ptr [bp - 0x18], ax
  023AD4  3464: 0bc0             or ax, ax
  023AD6  3466: 7d03             jge 0x346b
  023AD8  3468: e9db00           jmp 0x3546
  023ADB  346B: ff363e85         push word ptr [0x853e]
  023ADF  346F: ff364085         push word ptr [0x8540]
  023AE3  3473: ff36508d         push word ptr [0x8d50]
  023AE7  3477: 8b46fe           mov ax, word ptr [bp - 2]
  023AEA  347A: 050900           add ax, 9
  023AED  347D: ebc2             jmp 0x3441
  023AEF  347F: 90               nop 
  023AF0  3480: 837efe0c         cmp word ptr [bp - 2], 0xc
  023AF4  3484: 7c06             jl 0x348c
  023AF6  3486: a1d253           mov ax, word ptr [0x53d2]
  023AF9  3489: eb04             jmp 0x348f
  023AFB  348B: 90               nop 
  023AFC  348C: a19853           mov ax, word ptr [0x5398]
  023AFF  348F: 8946ea           mov word ptr [bp - 0x16], ax
  023B02  3492: 837efe0a         cmp word ptr [bp - 2], 0xa
  023B06  3496: 7505             jne 0x349d
  023B08  3498: c746f40900       mov word ptr [bp - 0xc], 9
  023B0D  349D: 837efe0b         cmp word ptr [bp - 2], 0xb
  023B11  34A1: 7505             jne 0x34a8
  023B13  34A3: c746f40700       mov word ptr [bp - 0xc], 7
  023B18  34A8: 837efe0c         cmp word ptr [bp - 2], 0xc
  023B1C  34AC: 7505             jne 0x34b3
  023B1E  34AE: c746f40600       mov word ptr [bp - 0xc], 6
  023B23  34B3: 837efe0d         cmp word ptr [bp - 2], 0xd
  023B27  34B7: 7505             jne 0x34be
  023B29  34B9: c746f40800       mov word ptr [bp - 0xc], 8
  023B2E  34BE: ff363e85         push word ptr [0x853e]
  023B32  34C2: ff364085         push word ptr [0x8540]
  023B36  34C6: 50               push ax
  023B37  34C7: ff76f4           push word ptr [bp - 0xc]
  023B3A  34CA: e98efe           jmp 0x335b
  023B3D  34CD: 90               nop 
  023B3E  34CE: c7065e1f0200     mov word ptr [0x1f5e], 2
  023B44  34D4: f606825301       test byte ptr [0x5382], 1
  023B49  34D9: 751f             jne 0x34fa
  023B4B  34DB: 8d1e3f0b         lea bx, [0xb3f]
  023B4F  34DF: 8d06370b         lea ax, [0xb37]
  023B53  34E3: 2bd2             sub dx, dx
  023B55  34E5: 9a98091f18       lcall 0x181f, 0x998
  023B5A  34EA: 48               dec ax
  023B5B  34EB: 8946ea           mov word ptr [bp - 0x16], ax
  023B5E  34EE: 0bc0             or ax, ax
  023B60  34F0: 7d54             jge 0x3546
  023B62  34F2: a19453           mov ax, word ptr [0x5394]
  023B65  34F5: 8946ea           mov word ptr [bp - 0x16], ax
  023B68  34F8: eb4c             jmp 0x3546
  023B6A  34FA: 8d1e4e0b         lea bx, [0xb4e]
  023B6E  34FE: 8d06450b         lea ax, [0xb45]
  023B72  3502: 2bd2             sub dx, dx
  023B74  3504: 9a98091f18       lcall 0x181f, 0x998
  023B79  3509: 48               dec ax
  023B7A  350A: 8946ea           mov word ptr [bp - 0x16], ax
  023B7D  350D: 48               dec ax
  023B7E  350E: 7406             je 0x3516
  023B80  3510: a19853           mov ax, word ptr [0x5398]
  023B83  3513: ebe0             jmp 0x34f5
  023B85  3515: 90               nop 
  023B86  3516: a1d253           mov ax, word ptr [0x53d2]
  023B89  3519: ebda             jmp 0x34f5
  023B8B  351B: 90               nop 
  023B8C  351C: 48               dec ax
  023B8D  351D: 3d0d00           cmp ax, 0xd
  023B90  3520: 7724             ja 0x3546
  023B92  3522: d1e0             shl ax, 1
  023B94  3524: 93               xchg bx, ax
  023B95  3525: 2effa7ba2c       jmp word ptr cs:[bx + 0x2cba]
  023B9A  352A: de2a             fisubr word ptr [bp + si]
  023B9C  352C: fa               cli 
  023B9D  352D: 2a0a             sub cl, byte ptr [bp + si]
  023B9F  352F: 2b1a             sub bx, word ptr [bp + si]
  023BA1  3531: 2b2a             sub bp, word ptr [bp + si]
  023BA3  3533: 2b3a             sub di, word ptr [bp + si]
  023BA5  3535: 2b4a2b           sub cx, word ptr [bp + si + 0x2b]
  023BA8  3538: 822ba6           sub byte ptr [bp + di], 0xa6
  023BAB  353B: 2bd6             sub dx, si
  023BAD  353D: 2bd6             sub dx, si
  023BAF  353F: 2bd6             sub dx, si
  023BB1  3541: 2bd6             sub dx, si
  023BB3  3543: 2b5e2c           sub bx, word ptr [bp + 0x2c]
  023BB6  3546: 837efe0e         cmp word ptr [bp - 2], 0xe
  023BBA  354A: 7503             jne 0x354f
  023BBC  354C: e9d1fd           jmp 0x3320
  023BBF  354F: 837ee600         cmp word ptr [bp - 0x1a], 0
  023BC3  3553: 7d03             jge 0x3558
  023BC5  3555: e99301           jmp 0x36eb
  023BC8  3558: 6b5ee61c         imul bx, word ptr [bp - 0x1a], 0x1c
  023BCC  355C: 808f4731f0       or byte ptr [bx + 0x3147], 0xf0
  023BD1  3561: e98701           jmp 0x36eb
  023BD4  3564: 0e               push cs
  023BD5  3565: e84b0f           call 0x44b3
  023BD8  3568: e93b03           jmp 0x38a6
  023BDB  356B: 90               nop 
  023BDC  356C: 2bc0             sub ax, ax
  023BDE  356E: 8946e2           mov word ptr [bp - 0x1e], ax
  023BE1  3571: 8946ee           mov word ptr [bp - 0x12], ax
  023BE4  3574: eb11             jmp 0x3587
  023BE6  3576: 6b5eee4e         imul bx, word ptr [bp - 0x12], 0x4e
  023BEA  357A: f687d95a80       test byte ptr [bx + 0x5ad9], 0x80
  023BEF  357F: 7403             je 0x3584
  023BF1  3581: ff46e2           inc word ptr [bp - 0x1e]
  023BF4  3584: ff46ee           inc word ptr [bp - 0x12]
  023BF7  3587: 837eee08         cmp word ptr [bp - 0x12], 8
  023BFB  358B: 7ce9             jl 0x3576
  023BFD  358D: 837ee208         cmp word ptr [bp - 0x1e], 8
  023C01  3591: 7c03             jl 0x3596
  023C03  3593: e95501           jmp 0x36eb
  023C06  3596: ff368c26         push word ptr [0x268c]
  023C0A  359A: ff368a26         push word ptr [0x268a]
  023C0E  359E: 680008           push 0x800
  023C11  35A1: 9a3c021f19       lcall 0x191f, 0x23c
  023C16  35A6: 83c406           add sp, 6
  023C19  35A9: 8946f8           mov word ptr [bp - 8], ax
  023C1C  35AC: 8956fa           mov word ptr [bp - 6], dx
  023C1F  35AF: 0bd0             or dx, ax
  023C21  35B1: 7503             jne 0x35b6
  023C23  35B3: e93501           jmp 0x36eb
  023C26  35B6: c746ee0000       mov word ptr [bp - 0x12], 0
  023C2B  35BB: 6b5eee4e         imul bx, word ptr [bp - 0x12], 0x4e
  023C2F  35BF: f687d95a80       test byte ptr [bx + 0x5ad9], 0x80
  023C34  35C4: 752d             jne 0x35f3
  023C36  35C6: 8b46ee           mov ax, word ptr [bp - 0x12]
  023C39  35C9: 40               inc ax
  023C3A  35CA: 50               push ax
  023C3B  35CB: 8b46ee           mov ax, word ptr [bp - 0x12]
  023C3E  35CE: 050400           add ax, 4
  023C41  35D1: 50               push ax
  023C42  35D2: 9a1a0a1f18       lcall 0x181f, 0xa1a
  023C47  35D7: 83c402           add sp, 2
  023C4A  35DA: 50               push ax
  023C4B  35DB: 9a22001f18       lcall 0x181f, 0x22
  023C50  35E0: 83c402           add sp, 2
  023C53  35E3: 52               push dx
  023C54  35E4: 50               push ax
  023C55  35E5: ff76fa           push word ptr [bp - 6]
  023C58  35E8: ff76f8           push word ptr [bp - 8]
  023C5B  35EB: 9a76011f19       lcall 0x191f, 0x176
  023C60  35F0: 83c40a           add sp, 0xa
  023C63  35F3: ff46ee           inc word ptr [bp - 0x12]
  023C66  35F6: 837eee08         cmp word ptr [bp - 0x12], 8
  023C6A  35FA: 7cbf             jl 0x35bb
  023C6C  35FC: ff76fa           push word ptr [bp - 6]
  023C6F  35FF: ff76f8           push word ptr [bp - 8]
  023C72  3602: 9a6a011f19       lcall 0x191f, 0x16a
  023C77  3607: 8946fe           mov word ptr [bp - 2], ax
  023C7A  360A: ff76fa           push word ptr [bp - 6]
  023C7D  360D: ff76f8           push word ptr [bp - 8]
  023C80  3610: 9aa8011f19       lcall 0x191f, 0x1a8
  023C85  3615: 837efe00         cmp word ptr [bp - 2], 0
  023C89  3619: 7f03             jg 0x361e
  023C8B  361B: e9cd00           jmp 0x36eb
  023C8E  361E: 8b46fe           mov ax, word ptr [bp - 2]
  023C91  3621: 48               dec ax
  023C92  3622: 50               push ax
  023C93  3623: 9a42041f19       lcall 0x191f, 0x442
  023C98  3628: 83c402           add sp, 2
  023C9B  362B: e9bd00           jmp 0x36eb
  023C9E  362E: 833ea25300       cmp word ptr [0x53a2], 0
  023CA3  3633: 7507             jne 0x363c
  023CA5  3635: 833ea45300       cmp word ptr [0x53a4], 0
  023CAA  363A: 7c08             jl 0x3644
  023CAC  363C: c746ea0600       mov word ptr [bp - 0x16], 6
  023CB1  3641: eb06             jmp 0x3649
  023CB3  3643: 90               nop 
  023CB4  3644: c746ea0500       mov word ptr [bp - 0x16], 5
  023CB9  3649: c7065e1f0300     mov word ptr [0x1f5e], 3
  023CBF  364F: 8d1e5c0b         lea bx, [0xb5c]
  023CC3  3653: 8d06540b         lea ax, [0xb54]
  023CC7  3657: 8b56ea           mov dx, word ptr [bp - 0x16]
  023CCA  365A: 9a98091f18       lcall 0x181f, 0x998
  023CCF  365F: 8946fe           mov word ptr [bp - 2], ax
  023CD2  3662: 3d0500           cmp ax, 5
  023CD5  3665: 7505             jne 0x366c
  023CD7  3667: b80100           mov ax, 1
  023CDA  366A: eb02             jmp 0x366e
  023CDC  366C: 2bc0             sub ax, ax
  023CDE  366E: a3a253           mov word ptr [0x53a2], ax
  023CE1  3671: 837efe05         cmp word ptr [bp - 2], 5
  023CE5  3675: 7c05             jl 0x367c
  023CE7  3677: b8ffff           mov ax, 0xffff
  023CEA  367A: eb04             jmp 0x3680
  023CEC  367C: 8b46fe           mov ax, word ptr [bp - 2]
  023CEF  367F: 48               dec ax
  023CF0  3680: a3a453           mov word ptr [0x53a4], ax
  023CF3  3683: 833ea25300       cmp word ptr [0x53a2], 0
  023CF8  3688: 7405             je 0x368f
  023CFA  368A: 802683537f       and byte ptr [0x5383], 0x7f
  023CFF  368F: 0bc0             or ax, ax
  023D01  3691: 7c58             jl 0x36eb
  023D03  3693: eb53             jmp 0x36e8
  023D05  3695: 90               nop 
  023D06  3696: c7065e1f0300     mov word ptr [0x1f5e], 3
  023D0C  369C: 8d1e6b0b         lea bx, [0xb6b]
  023D10  36A0: 8d06620b         lea ax, [0xb62]
  023D14  36A4: 2bd2             sub dx, dx
  023D16  36A6: 9a98091f18       lcall 0x181f, 0x998
  023D1B  36AB: 8946fe           mov word ptr [bp - 2], ax
  023D1E  36AE: 0bc0             or ax, ax
  023D20  36B0: 7503             jne 0x36b5
  023D22  36B2: e9f101           jmp 0x38a6
  023D25  36B5: 48               dec ax
  023D26  36B6: 8946fe           mov word ptr [bp - 2], ax
  023D29  36B9: c746f60000       mov word ptr [bp - 0xa], 0
  023D2E  36BE: 6b5ef634         imul bx, word ptr [bp - 0xa], 0x34
  023D32  36C2: c6873f5401       mov byte ptr [bx + 0x543f], 1
  023D37  36C7: ff46f6           inc word ptr [bp - 0xa]
  023D3A  36CA: 837ef604         cmp word ptr [bp - 0xa], 4
  023D3E  36CE: 7cee             jl 0x36be
  023D40  36D0: 837efe04         cmp word ptr [bp - 2], 4
  023D44  36D4: 7d22             jge 0x36f8
  023D46  36D6: 6b5efe34         imul bx, word ptr [bp - 2], 0x34
  023D4A  36DA: c6873f5400       mov byte ptr [bx + 0x543f], 0
  023D4F  36DF: 8b46fe           mov ax, word ptr [bp - 2]
  023D52  36E2: a39853           mov word ptr [0x5398], ax
  023D55  36E5: a39453           mov word ptr [0x5394], ax
  023D58  36E8: a39653           mov word ptr [0x5396], ax
  023D5B  36EB: 6a01             push 1
  023D5D  36ED: 9a1c0e1f18       lcall 0x181f, 0xe1c
  023D62  36F2: 83c402           add sp, 2
  023D65  36F5: e9ae01           jmp 0x38a6
  023D68  36F8: 8d1e790b         lea bx, [0xb79]
  023D6C  36FC: 8d06710b         lea ax, [0xb71]
  023D70  3700: 2bd2             sub dx, dx
  023D72  3702: 9a98091f18       lcall 0x181f, 0x998
  023D77  3707: 48               dec ax
  023D78  3708: 7403             je 0x370d
  023D7A  370A: e99901           jmp 0x38a6
  023D7D  370D: c70626080100     mov word ptr [0x826], 1
  023D83  3713: e99001           jmp 0x38a6
  023D86  3716: 8d1e850b         lea bx, [0xb85]
  023D8A  371A: 8d067f0b         lea ax, [0xb7f]
  023D8E  371E: ba0100           mov dx, 1
  023D91  3721: 9a36041f19       lcall 0x191f, 0x436
  023D96  3726: 0bc0             or ax, ax
  023D98  3728: 7403             je 0x372d
  023D9A  372A: e97901           jmp 0x38a6
  023D9D  372D: a1c89c           mov ax, word ptr [0x9cc8]
  023DA0  3730: 9ac0041f18       lcall 0x181f, 0x4c0
  023DA5  3735: e96e01           jmp 0x38a6
  023DA8  3738: 0e               push cs
  023DA9  3739: e8bd0d           call 0x44f9
  023DAC  373C: e96701           jmp 0x38a6
  023DAF  373F: 90               nop 
  023DB0  3740: 0e               push cs
  023DB1  3741: e8ab0d           call 0x44ef
  023DB4  3744: e95f01           jmp 0x38a6
  023DB7  3747: 90               nop 
  023DB8  3748: 0e               push cs
  023DB9  3749: e8760d           call 0x44c2
  023DBC  374C: e95701           jmp 0x38a6
  023DBF  374F: 90               nop 
  023DC0  3750: 0e               push cs
  023DC1  3751: e8c30d           call 0x4517
  023DC4  3754: e94f01           jmp 0x38a6
  023DC7  3757: 90               nop 
  023DC8  3758: 3d0003           cmp ax, 0x300
  023DCB  375B: 7503             jne 0x3760
  023DCD  375D: e976f9           jmp 0x30d6
  023DD0  3760: 7e03             jle 0x3765
  023DD2  3762: e9cd00           jmp 0x3832
  023DD5  3765: 2d1b00           sub ax, 0x1b
  023DD8  3768: 3d5c00           cmp ax, 0x5c
  023DDB  376B: 7603             jbe 0x3770
  023DDD  376D: e93601           jmp 0x38a6
  023DE0  3770: d1e0             shl ax, 1
  023DE2  3772: 93               xchg bx, ax
  023DE3  3773: 2effa7082f       jmp word ptr cs:[bx + 0x2f08]
  023DE8  3778: 46               inc si
  023DE9  3779: 27               daa 
  023DEA  377A: 6627             daa 
  023DEC  377C: 36306e27         xor byte ptr ss:[bp + 0x27], ch
  023DF0  3780: 92               xchg dx, ax
  023DF1  3781: 27               daa 
  023DF2  3782: a4               movsb byte ptr es:[di], byte ptr [si]
  023DF3  3783: 27               daa 
  023DF4  3784: ca27d2           retf 0xd227
  023DF7  3787: 27               daa 
  023DF8  3788: 3c28             cmp al, 0x28
  023DFA  378A: 44               inc sp
  023DFB  378B: 285028           sub byte ptr [bx + si + 0x28], dl
  023DFE  378E: 56               push si
  023DFF  378F: 285628           sub byte ptr [bp + 0x28], dl
  023E02  3792: 56               push si
  023E03  3793: 285628           sub byte ptr [bp + 0x28], dl
  023E06  3796: 5e               pop si
  023E07  3797: 28ab2736         sub byte ptr [bp + di + 0x3627], ch
  023E0B  379B: 30363036         xor byte ptr [0x3630], dh
  023E0F  379F: 30363036         xor byte ptr [0x3630], dh
  023E13  37A3: 30363036         xor byte ptr [0x3630], dh
  023E17  37A7: 30363036         xor byte ptr [0x3630], dh
  023E1B  37AB: 30363036         xor byte ptr [0x3630], dh
  023E1F  37AF: 30363036         xor byte ptr [0x3630], dh
  023E23  37B3: 30363036         xor byte ptr [0x3630], dh
  023E27  37B7: 30363036         xor byte ptr [0x3630], dh
  023E2B  37BB: 30363036         xor byte ptr [0x3630], dh
  023E2F  37BF: 303630e4         xor byte ptr [0xe430], dh
  023E33  37C3: 2830             sub byte ptr [bx + si], dh
  023E35  37C5: 2930             sub word ptr [bx + si], si
  023E37  37C7: 2930             sub word ptr [bx + si], si
  023E39  37C9: 2930             sub word ptr [bx + si], si
  023E3B  37CB: 2930             sub word ptr [bx + si], si
  023E3D  37CD: 2930             sub word ptr [bx + si], si
  023E3F  37CF: 2930             sub word ptr [bx + si], si
  023E41  37D1: 2930             sub word ptr [bx + si], si
  023E43  37D3: 2930             sub word ptr [bx + si], si
  023E45  37D5: 29363036         sub word ptr [0x3630], si
  023E49  37D9: 30363036         xor byte ptr [0x3630], dh
  023E4D  37DD: 30363036         xor byte ptr [0x3630], dh
  023E51  37E1: 3012             xor byte ptr [bp + si], dl
  023E53  37E3: 2a0a             sub cl, byte ptr [bp + si]
  023E55  37E5: 2a1c             sub bl, byte ptr [si]
  023E57  37E7: 2a363036         sub dh, byte ptr [0x3630]
  023E5B  37EB: 30363036         xor byte ptr [0x3630], dh
  023E5F  37EF: 30363036         xor byte ptr [0x3630], dh
  023E63  37F3: 30363036         xor byte ptr [0x3630], dh
  023E67  37F7: 30363036         xor byte ptr [0x3630], dh
  023E6B  37FB: 30363036         xor byte ptr [0x3630], dh
  023E6F  37FF: 30363036         xor byte ptr [0x3630], dh
  023E73  3803: 3036309a         xor byte ptr [0x9a30], dh
  023E77  3807: 2af4             sub dh, ah
  023E79  3809: 2c36             sub al, 0x36
  023E7B  380B: 30be2d26         xor byte ptr [bp + 0x262d], bh
  023E7F  380F: 2efc             cld 
  023E81  3811: 2c3c             sub al, 0x3c
  023E83  3813: 2aa62ec8         sub ah, byte ptr [bp - 0x37d2]
  023E87  3817: 2ed02ed82e       shr byte ptr cs:[0x2ed8], 1
  023E8C  381C: 36303630e0       xor byte ptr ss:[0xe030], dh
  023E91  3821: 2e242a           and al, 0x2a
  023E94  3824: 242a             and al, 0x2a
  023E96  3826: 242a             and al, 0x2a
  023E98  3828: 242a             and al, 0x2a
  023E9A  382A: 242a             and al, 0x2a
  023E9C  382C: 242a             and al, 0x2a
  023E9E  382E: 242a             and al, 0x2a
  023EA0  3830: 242a             and al, 0x2a
  023EA2  3832: 2d0103           sub ax, 0x301
  023EA5  3835: 3d3100           cmp ax, 0x31
  023EA8  3838: 776c             ja 0x38a6
  023EAA  383A: d1e0             shl ax, 1
  023EAC  383C: 93               xchg bx, ax
  023EAD  383D: 2effa7d22f       jmp word ptr cs:[bx + 0x2fd2]
  023EB2  3842: 94               xchg sp, ax
  023EB3  3843: 287428           sub byte ptr [si + 0x28], dh
  023EB6  3846: 7428             je 0x3870
  023EB8  3848: 7c28             jl 0x3872
  023EBA  384A: 3630363036       xor byte ptr ss:[0x3630], dh
  023EBF  384F: 30363036         xor byte ptr [0x3630], dh
  023EC3  3853: 30363036         xor byte ptr [0x3630], dh
  023EC7  3857: 30363036         xor byte ptr [0x3630], dh
  023ECB  385B: 30363036         xor byte ptr [0x3630], dh
  023ECF  385F: 30b428b4         xor byte ptr [si - 0x4bd8], dh
  023ED3  3863: 28bc28bc         sub byte ptr [si - 0x43d8], bh
  023ED7  3867: 28c4             sub ah, al
  023ED9  3869: 2884288c         sub byte ptr [si - 0x73d8], al
  023EDD  386D: 28363036         sub byte ptr [0x3630], dh
  023EE1  3871: 30363036         xor byte ptr [0x3630], dh
  023EE5  3875: 30363036         xor byte ptr [0x3630], dh
  023EE9  3879: 30363036         xor byte ptr [0x3630], dh
  023EED  387D: 303630d4         xor byte ptr [0xd430], dh
  023EF1  3881: 28d4             sub ah, dl
  023EF3  3883: 28dc             sub ah, bl
  023EF5  3885: 28cc             sub ah, cl
  023EF7  3887: 28363036         sub byte ptr [0x3630], dh
  023EFB  388B: 30363036         xor byte ptr [0x3630], dh
  023EFF  388F: 30363036         xor byte ptr [0x3630], dh
  023F03  3893: 30363036         xor byte ptr [0x3630], dh
  023F07  3897: 30363036         xor byte ptr [0x3630], dh
  023F0B  389B: 30363036         xor byte ptr [0x3630], dh
  023F0F  389F: 309c28a4         xor byte ptr [si - 0x5bd8], bl
  023F13  38A3: 28ac280e         sub byte ptr [si + 0xe28], ch
  023F17  38A7: e8bd0c           call 0x4567
  023F1A  38AA: c9               leave 
  023F1B  38AB: cb               retf 

; ---- func_023F1C  size=689  insns=246  prologue=ENTER 0x0006,0  terminal=RETF ----
  023F1C  38AC: c8060000         enter 6, 0
  023F20  38B0: c746fa0100       mov word ptr [bp - 6], 1
  023F25  38B5: c746feffff       mov word ptr [bp - 2], 0xffff
  023F2A  38BA: c746fc0000       mov word ptr [bp - 4], 0
  023F2F  38BF: a11e98           mov ax, word ptr [0x981e]
  023F32  38C2: 3d1101           cmp ax, 0x111
  023F35  38C5: 743d             je 0x3904
  023F37  38C7: 7e03             jle 0x38cc
  023F39  38C9: e9f601           jmp 0x3ac2
  023F3C  38CC: 3d3300           cmp ax, 0x33
  023F3F  38CF: 7503             jne 0x38d4
  023F41  38D1: e93001           jmp 0x3a04
  023F44  38D4: 7e03             jle 0x38d9
  023F46  38D6: e9b301           jmp 0x3a8c
  023F49  38D9: 3d3200           cmp ax, 0x32
  023F4C  38DC: 7503             jne 0x38e1
  023F4E  38DE: e9cd00           jmp 0x39ae
  023F51  38E1: 7603             jbe 0x38e6
  023F53  38E3: e9bc01           jmp 0x3aa2
  023F56  38E6: 2c11             sub al, 0x11
  023F58  38E8: 7503             jne 0x38ed
  023F5A  38EA: e98700           jmp 0x3974
  023F5D  38ED: 2c07             sub al, 7
  023F5F  38EF: 7503             jne 0x38f4
  023F61  38F1: e98000           jmp 0x3974
  023F64  38F4: 2c03             sub al, 3
  023F66  38F6: 747c             je 0x3974
  023F68  38F8: 2c16             sub al, 0x16
  023F6A  38FA: 7503             jne 0x38ff
  023F6C  38FC: e92f01           jmp 0x3a2e
  023F6F  38FF: e9a001           jmp 0x3aa2
  023F72  3902: 90               nop 
  023F73  3903: 90               nop 
  023F74  3904: 8a268353         mov ah, byte ptr [0x5383]
  023F78  3908: 250020           and ax, 0x2000
  023F7B  390B: 7425             je 0x3932
  023F7D  390D: 50               push ax
  023F7E  390E: 6a06             push 6
  023F80  3910: ff369808         push word ptr [0x898]
  023F84  3914: ff369608         push word ptr [0x896]
  023F88  3918: 9a5c041f19       lcall 0x191f, 0x45c
  023F8D  391D: 83c408           add sp, 8
  023F90  3920: 6a01             push 1
  023F92  3922: 9aea0d1f18       lcall 0x181f, 0xdea
  023F97  3927: 83c402           add sp, 2
  023F9A  392A: 8036835320       xor byte ptr [0x5383], 0x20
  023F9F  392F: e9e001           jmp 0x3b12
  023FA2  3932: 833e920b00       cmp word ptr [0xb92], 0
  023FA7  3937: 7509             jne 0x3942
  023FA9  3939: 813e1e981101     cmp word ptr [0x981e], 0x111
  023FAF  393F: eb0e             jmp 0x394f
  023FB1  3941: 90               nop 
  023FB2  3942: 833e920b01       cmp word ptr [0xb92], 1
  023FB7  3947: 7517             jne 0x3960
  023FB9  3949: 813e1e981701     cmp word ptr [0x981e], 0x117
  023FBF  394F: 7403             je 0x3954
  023FC1  3951: e9be01           jmp 0x3b12
  023FC4  3954: ff06920b         inc word ptr [0xb92]
  023FC8  3958: c746fc0100       mov word ptr [bp - 4], 1
  023FCD  395D: e9b201           jmp 0x3b12
  023FD0  3960: 813e1e983101     cmp word ptr [0x981e], 0x131
  023FD6  3966: 7403             je 0x396b
  023FD8  3968: e9a701           jmp 0x3b12
  023FDB  396B: 8a268353         mov ah, byte ptr [0x5383]
  023FDF  396F: 250020           and ax, 0x2000
  023FE2  3972: eb99             jmp 0x390d
  023FE4  3974: 8d1e8b0b         lea bx, [0xb8b]
  023FE8  3978: 9afe031f18       lcall 0x181f, 0x3fe
  023FED  397D: 48               dec ax
  023FEE  397E: 7403             je 0x3983
  023FF0  3980: e98f01           jmp 0x3b12
  023FF3  3983: c706c2530000     mov word ptr [0x53c2], 0
  023FF9  3989: e98601           jmp 0x3b12
  023FFC  398C: 6a01             push 1
  023FFE  398E: ff0e7e01         dec word ptr [0x17e]
  024002  3992: a17e01           mov ax, word ptr [0x17e]
  024005  3995: 0bc0             or ax, ax
  024007  3997: 7d02             jge 0x399b
  024009  3999: 2bc0             sub ax, ax
  02400B  399B: a37e01           mov word ptr [0x17e], ax
  02400E  399E: 50               push ax
  02400F  399F: ff367c01         push word ptr [0x17c]
  024013  39A3: 9a080e1f18       lcall 0x181f, 0xe08
  024018  39A8: 83c406           add sp, 6
  02401B  39AB: e96401           jmp 0x3b12
  02401E  39AE: 6a01             push 1
  024020  39B0: a13c85           mov ax, word ptr [0x853c]
  024023  39B3: 48               dec ax
  024024  39B4: ff067e01         inc word ptr [0x17e]
  024028  39B8: 3b067e01         cmp ax, word ptr [0x17e]
  02402C  39BC: 7edd             jle 0x399b
  02402E  39BE: a17e01           mov ax, word ptr [0x17e]
  024031  39C1: ebd8             jmp 0x399b
  024033  39C3: 90               nop 
  024034  39C4: 6a01             push 1
  024036  39C6: ff367e01         push word ptr [0x17e]
  02403A  39CA: ff0e7c01         dec word ptr [0x17c]
  02403E  39CE: a17c01           mov ax, word ptr [0x17c]
  024041  39D1: 0bc0             or ax, ax
  024043  39D3: 7d02             jge 0x39d7
  024045  39D5: 2bc0             sub ax, ax
  024047  39D7: a37c01           mov word ptr [0x17c], ax
  02404A  39DA: 50               push ax
  02404B  39DB: ebc6             jmp 0x39a3
  02404D  39DD: 90               nop 
  02404E  39DE: 6a01             push 1
  024050  39E0: ff367e01         push word ptr [0x17e]
  024054  39E4: a13a85           mov ax, word ptr [0x853a]
  024057  39E7: 48               dec ax
  024058  39E8: ff067c01         inc word ptr [0x17c]
  02405C  39EC: 3b067c01         cmp ax, word ptr [0x17c]
  024060  39F0: 7ee5             jle 0x39d7
  024062  39F2: a17c01           mov ax, word ptr [0x17c]
  024065  39F5: ebe0             jmp 0x39d7
  024067  39F7: 90               nop 
  024068  39F8: 6a01             push 1
  02406A  39FA: a18801           mov ax, word ptr [0x188]
  02406D  39FD: 29067e01         sub word ptr [0x17e], ax
  024071  3A01: eb8f             jmp 0x3992
  024073  3A03: 90               nop 
  024074  3A04: 6a01             push 1
  024076  3A06: a18801           mov ax, word ptr [0x188]
  024079  3A09: 01067e01         add word ptr [0x17e], ax
  02407D  3A0D: a17e01           mov ax, word ptr [0x17e]
  024080  3A10: 8b0e3c85         mov cx, word ptr [0x853c]
  024084  3A14: 49               dec cx
  024085  3A15: 3bc1             cmp ax, cx
  024087  3A17: 7e82             jle 0x399b
  024089  3A19: 8bc1             mov ax, cx
  02408B  3A1B: e97dff           jmp 0x399b
  02408E  3A1E: 6a01             push 1
  024090  3A20: ff367e01         push word ptr [0x17e]
  024094  3A24: a18801           mov ax, word ptr [0x188]
  024097  3A27: 29067c01         sub word ptr [0x17c], ax
  02409B  3A2B: eba1             jmp 0x39ce
  02409D  3A2D: 90               nop 
  02409E  3A2E: 6a01             push 1
  0240A0  3A30: ff367e01         push word ptr [0x17e]
  0240A4  3A34: a18801           mov ax, word ptr [0x188]
  0240A7  3A37: 01067c01         add word ptr [0x17c], ax
  0240AB  3A3B: a17c01           mov ax, word ptr [0x17c]
  0240AE  3A3E: 8b0e3a85         mov cx, word ptr [0x853a]
  0240B2  3A42: 49               dec cx
  0240B3  3A43: 3bc1             cmp ax, cx
  0240B5  3A45: 7e90             jle 0x39d7
  0240B7  3A47: 8bc1             mov ax, cx
  0240B9  3A49: eb8c             jmp 0x39d7
  0240BB  3A4B: 90               nop 
  0240BC  3A4C: c746fe0000       mov word ptr [bp - 2], 0
  0240C1  3A51: e9be00           jmp 0x3b12
  0240C4  3A54: c746fe0400       mov word ptr [bp - 2], 4
  0240C9  3A59: e9b600           jmp 0x3b12
  0240CC  3A5C: c746fe0600       mov word ptr [bp - 2], 6
  0240D1  3A61: e9ae00           jmp 0x3b12
  0240D4  3A64: c746fe0200       mov word ptr [bp - 2], 2
  0240D9  3A69: e9a600           jmp 0x3b12
  0240DC  3A6C: c746fe0100       mov word ptr [bp - 2], 1
  0240E1  3A71: e99e00           jmp 0x3b12
  0240E4  3A74: c746fe0300       mov word ptr [bp - 2], 3
  0240E9  3A79: e99600           jmp 0x3b12
  0240EC  3A7C: c746fe0700       mov word ptr [bp - 2], 7
  0240F1  3A81: e98e00           jmp 0x3b12
  0240F4  3A84: c746fe0500       mov word ptr [bp - 2], 5
  0240F9  3A89: e98600           jmp 0x3b12
  0240FC  3A8C: 3d3700           cmp ax, 0x37
  0240FF  3A8F: 748d             je 0x3a1e
  024101  3A91: 7f17             jg 0x3aaa
  024103  3A93: 2d3400           sub ax, 0x34
  024106  3A96: 7503             jne 0x3a9b
  024108  3A98: e929ff           jmp 0x39c4
  02410B  3A9B: 48               dec ax
  02410C  3A9C: 48               dec ax
  02410D  3A9D: 7503             jne 0x3aa2
  02410F  3A9F: e93cff           jmp 0x39de
  024112  3AA2: c746fa0000       mov word ptr [bp - 6], 0
  024117  3AA7: eb69             jmp 0x3b12
  024119  3AA9: 90               nop 
  02411A  3AAA: 2d3800           sub ax, 0x38
  02411D  3AAD: 7503             jne 0x3ab2
  02411F  3AAF: e9dafe           jmp 0x398c
  024122  3AB2: 48               dec ax
  024123  3AB3: 7503             jne 0x3ab8
  024125  3AB5: e940ff           jmp 0x39f8
  024128  3AB8: 2dd700           sub ax, 0xd7
  02412B  3ABB: 7503             jne 0x3ac0
  02412D  3ABD: e9b4fe           jmp 0x3974
  024130  3AC0: ebe0             jmp 0x3aa2
  024132  3AC2: 3d4801           cmp ax, 0x148
  024135  3AC5: 7485             je 0x3a4c
  024137  3AC7: 7f27             jg 0x3af0
  024139  3AC9: 2d1701           sub ax, 0x117
  02413C  3ACC: 7503             jne 0x3ad1
  02413E  3ACE: e933fe           jmp 0x3904
  024141  3AD1: 2d0e00           sub ax, 0xe
  024144  3AD4: 7503             jne 0x3ad9
  024146  3AD6: e92bfe           jmp 0x3904
  024149  3AD9: 2d0800           sub ax, 8
  02414C  3ADC: 7503             jne 0x3ae1
  02414E  3ADE: e993fe           jmp 0x3974
  024151  3AE1: 2d0400           sub ax, 4
  024154  3AE4: 7503             jne 0x3ae9
  024156  3AE6: e91bfe           jmp 0x3904
  024159  3AE9: 2d1600           sub ax, 0x16
  02415C  3AEC: 748e             je 0x3a7c
  02415E  3AEE: ebb2             jmp 0x3aa2
  024160  3AF0: 2d4901           sub ax, 0x149
  024163  3AF3: 3d0800           cmp ax, 8
  024166  3AF6: 77aa             ja 0x3aa2
  024168  3AF8: d1e0             shl ax, 1
  02416A  3AFA: 93               xchg bx, ax
  02416B  3AFB: 2effa79032       jmp word ptr cs:[bx + 0x3290]
  024170  3B00: fc               cld 
  024171  3B01: 3132             xor word ptr [bp + si], si
  024173  3B03: 32ec             xor ch, ah
  024175  3B05: 3132             xor word ptr [bp + si], si
  024177  3B07: 32f4             xor dh, ah
  024179  3B09: 3132             xor word ptr [bp + si], si
  02417B  3B0B: 3214             xor dl, byte ptr [si]
  02417D  3B0D: 32e4             xor ah, ah
  02417F  3B0F: 3104             xor word ptr [si], ax
  024181  3B11: 32837efc         xor al, byte ptr [bp + di - 0x382]
  024185  3B15: 007506           add byte ptr [di + 6], dh
  024188  3B18: c706920b0000     mov word ptr [0xb92], 0
  02418E  3B1E: 837efe00         cmp word ptr [bp - 2], 0
  024192  3B22: 7c30             jl 0x3b54
  024194  3B24: 833e905300       cmp word ptr [0x5390], 0
  024199  3B29: 7519             jne 0x3b44
  02419B  3B2B: 8b5efe           mov bx, word ptr [bp - 2]
  02419E  3B2E: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0241A2  3B32: 98               cwde 
  0241A3  3B33: 50               push ax
  0241A4  3B34: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0241A8  3B38: 98               cwde 
  0241A9  3B39: 50               push ax
  0241AA  3B3A: 9a4e041f19       lcall 0x191f, 0x44e
  0241AF  3B3F: 83c404           add sp, 4
  0241B2  3B42: eb0b             jmp 0x3b4f
  0241B4  3B44: ff76fe           push word ptr [bp - 2]
  0241B7  3B47: 9aa40d1f18       lcall 0x181f, 0xda4
  0241BC  3B4C: 83c402           add sp, 2
  0241BF  3B4F: c746fa0100       mov word ptr [bp - 6], 1
  0241C4  3B54: 0e               push cs
  0241C5  3B55: e80f0a           call 0x4567
  0241C8  3B58: 8b46fa           mov ax, word ptr [bp - 6]
  0241CB  3B5B: c9               leave 
  0241CC  3B5C: cb               retf 

; ---- func_0241CE  size=86  insns=28  prologue=ENTER 0x0004,0  terminal=RETF ----
  0241CE  3B5E: c8040000         enter 4, 0
  0241D2  3B62: c746fc0100       mov word ptr [bp - 4], 1
  0241D7  3B67: a11e98           mov ax, word ptr [0x981e]
  0241DA  3B6A: 2d0d00           sub ax, 0xd
  0241DD  3B6D: 753b             jne 0x3baa
  0241DF  3B6F: ff363e85         push word ptr [0x853e]
  0241E3  3B73: ff364085         push word ptr [0x8540]
  0241E7  3B77: 9abe071f18       lcall 0x181f, 0x7be
  0241EC  3B7C: 83c404           add sp, 4
  0241EF  3B7F: 8946fe           mov word ptr [bp - 2], ax
  0241F2  3B82: 0bc0             or ax, ax
  0241F4  3B84: 7c29             jl 0x3baf
  0241F6  3B86: 69d8ca00         imul bx, ax, 0xca
  0241FA  3B8A: a09653           mov al, byte ptr [0x5396]
  0241FD  3B8D: 3887605d         cmp byte ptr [bx + 0x5d60], al
  024201  3B91: 7407             je 0x3b9a
  024203  3B93: 833ea25300       cmp word ptr [0x53a2], 0
  024208  3B98: 7415             je 0x3baf
  02420A  3B9A: ff76fe           push word ptr [bp - 2]
  02420D  3B9D: 9a08061f18       lcall 0x181f, 0x608
  024212  3BA2: 83c402           add sp, 2
  024215  3BA5: 8b46fc           mov ax, word ptr [bp - 4]
  024218  3BA8: c9               leave 
  024219  3BA9: cb               retf 
  02421A  3BAA: c746fc0000       mov word ptr [bp - 4], 0
  02421F  3BAF: 8b46fc           mov ax, word ptr [bp - 4]
  024222  3BB2: c9               leave 
  024223  3BB3: cb               retf 

; ---- func_024224  size=138  insns=48  prologue=ENTER 0x0004,0  terminal=RETF ----
  024224  3BB4: c8040000         enter 4, 0
  024228  3BB8: c746fc0100       mov word ptr [bp - 4], 1
  02422D  3BBD: a11e98           mov ax, word ptr [0x981e]
  024230  3BC0: 2d0d00           sub ax, 0xd
  024233  3BC3: 7429             je 0x3bee
  024235  3BC5: 2d1300           sub ax, 0x13
  024238  3BC8: 756a             jne 0x3c34
  02423A  3BCA: 833ec65300       cmp word ptr [0x53c6], 0
  02423F  3BCF: 740b             je 0x3bdc
  024241  3BD1: c706c4530000     mov word ptr [0x53c4], 0
  024247  3BD7: 8b46fc           mov ax, word ptr [bp - 4]
  02424A  3BDA: c9               leave 
  02424B  3BDB: cb               retf 
  02424C  3BDC: 6a00             push 0
  02424E  3BDE: 0e               push cs
  02424F  3BDF: e8fe08           call 0x44e0
  024252  3BE2: 83c402           add sp, 2
  024255  3BE5: 833e905301       cmp word ptr [0x5390], 1
  02425A  3BEA: 754d             jne 0x3c39
  02425C  3BEC: ebe3             jmp 0x3bd1
  02425E  3BEE: ff363e85         push word ptr [0x853e]
  024262  3BF2: ff364085         push word ptr [0x8540]
  024266  3BF6: 9abe071f18       lcall 0x181f, 0x7be
  02426B  3BFB: 83c404           add sp, 4
  02426E  3BFE: 8946fe           mov word ptr [bp - 2], ax
  024271  3C01: 0bc0             or ax, ax
  024273  3C03: 7c25             jl 0x3c2a
  024275  3C05: 69d8ca00         imul bx, ax, 0xca
  024279  3C09: a09653           mov al, byte ptr [0x5396]
  02427C  3C0C: 3887605d         cmp byte ptr [bx + 0x5d60], al
  024280  3C10: 7407             je 0x3c19
  024282  3C12: 833ea25300       cmp word ptr [0x53a2], 0
  024287  3C17: 7411             je 0x3c2a
  024289  3C19: ff76fe           push word ptr [bp - 2]
  02428C  3C1C: 9a08061f18       lcall 0x181f, 0x608
  024291  3C21: 83c402           add sp, 2
  024294  3C24: 8b46fc           mov ax, word ptr [bp - 4]
  024297  3C27: c9               leave 
  024298  3C28: cb               retf 
  024299  3C29: 90               nop 
  02429A  3C2A: 833ec65300       cmp word ptr [0x53c6], 0
  02429F  3C2F: 7408             je 0x3c39
  0242A1  3C31: eb9e             jmp 0x3bd1
  0242A3  3C33: 90               nop 
  0242A4  3C34: c746fc0000       mov word ptr [bp - 4], 0
  0242A9  3C39: 8b46fc           mov ax, word ptr [bp - 4]
  0242AC  3C3C: c9               leave 
  0242AD  3C3D: cb               retf 

; ---- func_0242AE  size=116  insns=35  prologue=ENTER 0x0002,0  terminal=RETF ----
  0242AE  3C3E: c8020000         enter 2, 0
  0242B2  3C42: c746fe0000       mov word ptr [bp - 2], 0
  0242B7  3C47: 833ee80700       cmp word ptr [0x7e8], 0
  0242BC  3C4C: 7c21             jl 0x3c6f
  0242BE  3C4E: 833eea0708       cmp word ptr [0x7ea], 8
  0242C3  3C53: 7c1a             jl 0x3c6f
  0242C5  3C55: a15085           mov ax, word ptr [0x8550]
  0242C8  3C58: 3906e807         cmp word ptr [0x7e8], ax
  0242CC  3C5C: 7d11             jge 0x3c6f
  0242CE  3C5E: a15285           mov ax, word ptr [0x8552]
  0242D1  3C61: 050800           add ax, 8
  0242D4  3C64: 3b06ea07         cmp ax, word ptr [0x7ea]
  0242D8  3C68: 7e05             jle 0x3c6f
  0242DA  3C6A: c746fe0100       mov word ptr [bp - 2], 1
  0242DF  3C6F: 813ee807fc00     cmp word ptr [0x7e8], 0xfc
  0242E5  3C75: 7c1b             jl 0x3c92
  0242E7  3C77: 833eea0709       cmp word ptr [0x7ea], 9
  0242EC  3C7C: 7c14             jl 0x3c92
  0242EE  3C7E: 813ee8073401     cmp word ptr [0x7e8], 0x134
  0242F4  3C84: 7d0c             jge 0x3c92
  0242F6  3C86: 833eea0730       cmp word ptr [0x7ea], 0x30
  0242FB  3C8B: 7d05             jge 0x3c92
  0242FD  3C8D: c746fe0200       mov word ptr [bp - 2], 2
  024302  3C92: 689600           push 0x96
  024305  3C95: 6a4f             push 0x4f
  024307  3C97: 6a32             push 0x32
  024309  3C99: 68f100           push 0xf1
  02430C  3C9C: 9aca031f18       lcall 0x181f, 0x3ca
  024311  3CA1: 83c408           add sp, 8
  024314  3CA4: 0bc0             or ax, ax
  024316  3CA6: 7405             je 0x3cad
  024318  3CA8: c746fe0300       mov word ptr [bp - 2], 3
  02431D  3CAD: 8b46fe           mov ax, word ptr [bp - 2]
  024320  3CB0: c9               leave 
  024321  3CB1: cb               retf 

; ---- func_024322  size=32  insns=14  prologue=push bp;mov bp,sp  terminal=RETF ----
  024322  3CB2: 55               push bp
  024323  3CB3: 8bec             mov bp, sp
  024325  3CB5: ff363c08         push word ptr [0x83c]
  024329  3CB9: ff363a08         push word ptr [0x83a]
  02432D  3CBD: 8b4606           mov ax, word ptr [bp + 6]
  024330  3CC0: 9a68041f19       lcall 0x191f, 0x468
  024335  3CC5: c9               leave 
  024336  3CC6: cb               retf 
  024337  3CC7: 90               nop 
  024338  3CC8: 6a01             push 1
  02433A  3CCA: 0e               push cs
  02433B  3CCB: e87108           call 0x453f
  02433E  3CCE: 83c402           add sp, 2
  024341  3CD1: cb               retf 

; ---- func_024342  size=643  insns=215  prologue=ENTER 0x001E,0  terminal=RETF ----
  024342  3CD2: c81e0000         enter 0x1e, 0
  024346  3CD6: c746e60000       mov word ptr [bp - 0x1a], 0
  02434B  3CDB: a12893           mov ax, word ptr [0x9328]
  02434E  3CDE: 39063e93         cmp word ptr [0x933e], ax
  024352  3CE2: 7403             je 0x3ce7
  024354  3CE4: e96902           jmp 0x3f50
  024357  3CE7: 9a06000c0c       lcall 0xc0c, 6
  02435C  3CEC: 8946fa           mov word ptr [bp - 6], ax
  02435F  3CEF: 8956fc           mov word ptr [bp - 4], dx
  024362  3CF2: 833eec0700       cmp word ptr [0x7ec], 0
  024367  3CF7: 7410             je 0x3d09
  024369  3CF9: c606940b00       mov byte ptr [0xb94], 0
  02436E  3CFE: a30a2d           mov word ptr [0x2d0a], ax
  024371  3D01: 89160c2d         mov word ptr [0x2d0c], dx
  024375  3D05: 0e               push cs
  024376  3D06: e84508           call 0x454e
  024379  3D09: 833ef60700       cmp word ptr [0x7f6], 0
  02437E  3D0E: 7503             jne 0x3d13
  024380  3D10: e93902           jmp 0x3f4c
  024383  3D13: 833e905300       cmp word ptr [0x5390], 0
  024388  3D18: 7512             jne 0x3d2c
  02438A  3D1A: 833ee40700       cmp word ptr [0x7e4], 0
  02438F  3D1F: 740b             je 0x3d2c
  024391  3D21: 803e940b00       cmp byte ptr [0xb94], 0
  024396  3D26: 7504             jne 0x3d2c
  024398  3D28: 0e               push cs
  024399  3D29: e80908           call 0x4535
  02439C  3D2C: 833e905300       cmp word ptr [0x5390], 0
  0243A1  3D31: 7527             jne 0x3d5a
  0243A3  3D33: 8b46fa           mov ax, word ptr [bp - 6]
  0243A6  3D36: 8b56fc           mov dx, word ptr [bp - 4]
  0243A9  3D39: 2b060a2d         sub ax, word ptr [0x2d0a]
  0243AD  3D3D: 1b160c2d         sbb dx, word ptr [0x2d0c]
  0243B1  3D41: 0bd2             or dx, dx
  0243B3  3D43: 7c15             jl 0x3d5a
  0243B5  3D45: 7f05             jg 0x3d4c
  0243B7  3D47: 3d1400           cmp ax, 0x14
  0243BA  3D4A: 760e             jbe 0x3d5a
  0243BC  3D4C: c606940b01       mov byte ptr [0xb94], 1
  0243C1  3D51: 6a02             push 2
  0243C3  3D53: 0e               push cs
  0243C4  3D54: e8e807           call 0x453f
  0243C7  3D57: 83c402           add sp, 2
  0243CA  3D5A: a1ea07           mov ax, word ptr [0x7ea]
  0243CD  3D5D: 2d0800           sub ax, 8
  0243D0  3D60: 8946ec           mov word ptr [bp - 0x14], ax
  0243D3  3D63: a1e807           mov ax, word ptr [0x7e8]
  0243D6  3D66: 8a0e8401         mov cl, byte ptr [0x184]
  0243DA  3D6A: bb1000           mov bx, 0x10
  0243DD  3D6D: d3fb             sar bx, cl
  0243DF  3D6F: 99               cdq 
  0243E0  3D70: f7fb             idiv bx
  0243E2  3D72: 8946f4           mov word ptr [bp - 0xc], ax
  0243E5  3D75: 8b46ec           mov ax, word ptr [bp - 0x14]
  0243E8  3D78: 99               cdq 
  0243E9  3D79: f7fb             idiv bx
  0243EB  3D7B: 8b4ef4           mov cx, word ptr [bp - 0xc]
  0243EE  3D7E: 2b0e2a83         sub cx, word ptr [0x832a]
  0243F2  3D82: 030e2883         add cx, word ptr [0x8328]
  0243F6  3D86: 894ef6           mov word ptr [bp - 0xa], cx
  0243F9  3D89: 2b062c83         sub ax, word ptr [0x832c]
  0243FD  3D8D: 03062e83         add ax, word ptr [0x832e]
  024401  3D91: 8946f2           mov word ptr [bp - 0xe], ax
  024404  3D94: 833e905301       cmp word ptr [0x5390], 1
  024409  3D99: 7537             jne 0x3dd2
  02440B  3D9B: 3b0e4085         cmp cx, word ptr [0x8540]
  02440F  3D9F: 7506             jne 0x3da7
  024411  3DA1: 3b063e85         cmp ax, word ptr [0x853e]
  024415  3DA5: 742b             je 0x3dd2
  024417  3DA7: 833e9c9200       cmp word ptr [0x929c], 0
  02441C  3DAC: 7405             je 0x3db3
  02441E  3DAE: 9acc0d1f18       lcall 0x181f, 0xdcc
  024423  3DB3: ff76f2           push word ptr [bp - 0xe]
  024426  3DB6: ff76f6           push word ptr [bp - 0xa]
  024429  3DB9: 9ab80d1f18       lcall 0x181f, 0xdb8
  02442E  3DBE: 83c404           add sp, 4
  024431  3DC1: 9acc0d1f18       lcall 0x181f, 0xdcc
  024436  3DC6: 6a00             push 0
  024438  3DC8: 6a01             push 1
  02443A  3DCA: 9a5e051f18       lcall 0x181f, 0x55e
  02443F  3DCF: 83c404           add sp, 4
  024442  3DD2: 833ef40700       cmp word ptr [0x7f4], 0
  024447  3DD7: 7503             jne 0x3ddc
  024449  3DD9: e9c500           jmp 0x3ea1
  02444C  3DDC: 803e940b00       cmp byte ptr [0xb94], 0
  024451  3DE1: 7503             jne 0x3de6
  024453  3DE3: e9bb00           jmp 0x3ea1
  024456  3DE6: c746e60100       mov word ptr [bp - 0x1a], 1
  02445B  3DEB: a19253           mov ax, word ptr [0x5392]
  02445E  3DEE: 8946e8           mov word ptr [bp - 0x18], ax
  024461  3DF1: 6bd81c           imul bx, ax, 0x1c
  024464  3DF4: 8a874431         mov al, byte ptr [bx + 0x3144]
  024468  3DF8: 2ae4             sub ah, ah
  02446A  3DFA: 2b46f6           sub ax, word ptr [bp - 0xa]
  02446D  3DFD: f7d8             neg ax
  02446F  3DFF: 8946fe           mov word ptr [bp - 2], ax
  024472  3E02: 8a874531         mov al, byte ptr [bx + 0x3145]
  024476  3E06: 2ae4             sub ah, ah
  024478  3E08: 2b46f2           sub ax, word ptr [bp - 0xe]
  02447B  3E0B: f7d8             neg ax
  02447D  3E0D: 8946f8           mov word ptr [bp - 8], ax
  024480  3E10: 0e               push cs
  024481  3E11: e83a07           call 0x454e
  024484  3E14: 837efe00         cmp word ptr [bp - 2], 0
  024488  3E18: 7e06             jle 0x3e20
  02448A  3E1A: 8b46fe           mov ax, word ptr [bp - 2]
  02448D  3E1D: eb07             jmp 0x3e26
  02448F  3E1F: 90               nop 
  024490  3E20: 8b46fe           mov ax, word ptr [bp - 2]
  024493  3E23: f7d0             not ax
  024495  3E25: 40               inc ax
  024496  3E26: 3d0100           cmp ax, 1
  024499  3E29: 7f5f             jg 0x3e8a
  02449B  3E2B: 837ef800         cmp word ptr [bp - 8], 0
  02449F  3E2F: 7e05             jle 0x3e36
  0244A1  3E31: 8b46f8           mov ax, word ptr [bp - 8]
  0244A4  3E34: eb06             jmp 0x3e3c
  0244A6  3E36: 8b46f8           mov ax, word ptr [bp - 8]
  0244A9  3E39: f7d0             not ax
  0244AB  3E3B: 40               inc ax
  0244AC  3E3C: 3d0100           cmp ax, 1
  0244AF  3E3F: 7f49             jg 0x3e8a
  0244B1  3E41: 837efe00         cmp word ptr [bp - 2], 0
  0244B5  3E45: 7506             jne 0x3e4d
  0244B7  3E47: 837ef800         cmp word ptr [bp - 8], 0
  0244BB  3E4B: 743d             je 0x3e8a
  0244BD  3E4D: 837ef800         cmp word ptr [bp - 8], 0
  0244C1  3E51: 7e05             jle 0x3e58
  0244C3  3E53: b80100           mov ax, 1
  0244C6  3E56: eb0d             jmp 0x3e65
  0244C8  3E58: 837ef800         cmp word ptr [bp - 8], 0
  0244CC  3E5C: 7c04             jl 0x3e62
  0244CE  3E5E: 2bc0             sub ax, ax
  0244D0  3E60: eb03             jmp 0x3e65
  0244D2  3E62: b8ffff           mov ax, 0xffff
  0244D5  3E65: 50               push ax
  0244D6  3E66: 837efe00         cmp word ptr [bp - 2], 0
  0244DA  3E6A: 7e06             jle 0x3e72
  0244DC  3E6C: b80100           mov ax, 1
  0244DF  3E6F: eb0e             jmp 0x3e7f
  0244E1  3E71: 90               nop 
  0244E2  3E72: 837efe00         cmp word ptr [bp - 2], 0
  0244E6  3E76: 7c04             jl 0x3e7c
  0244E8  3E78: 2bc0             sub ax, ax
  0244EA  3E7A: eb03             jmp 0x3e7f
  0244EC  3E7C: b8ffff           mov ax, 0xffff
  0244EF  3E7F: 50               push ax
  0244F0  3E80: 9a4e041f19       lcall 0x191f, 0x44e
  0244F5  3E85: 83c404           add sp, 4
  0244F8  3E88: eb17             jmp 0x3ea1
  0244FA  3E8A: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  0244FE  3E8E: c6874c3103       mov byte ptr [bx + 0x314c], 3
  024503  3E93: 8a46f6           mov al, byte ptr [bp - 0xa]
  024506  3E96: 88874d31         mov byte ptr [bx + 0x314d], al
  02450A  3E9A: 8a46f2           mov al, byte ptr [bp - 0xe]
  02450D  3E9D: 88874e31         mov byte ptr [bx + 0x314e], al
  024511  3EA1: 833ef40700       cmp word ptr [0x7f4], 0
  024516  3EA6: 7503             jne 0x3eab
  024518  3EA8: e9a100           jmp 0x3f4c
  02451B  3EAB: 803e940b00       cmp byte ptr [0xb94], 0
  024520  3EB0: 7403             je 0x3eb5
  024522  3EB2: e99700           jmp 0x3f4c
  024525  3EB5: 833e905301       cmp word ptr [0x5390], 1
  02452A  3EBA: 1bc0             sbb ax, ax
  02452C  3EBC: f7d8             neg ax
  02452E  3EBE: 3b069c92         cmp ax, word ptr [0x929c]
  024532  3EC2: 7505             jne 0x3ec9
  024534  3EC4: 9acc0d1f18       lcall 0x181f, 0xdcc
  024539  3EC9: 833ee40700       cmp word ptr [0x7e4], 0
  02453E  3ECE: 7566             jne 0x3f36
  024540  3ED0: ff76f2           push word ptr [bp - 0xe]
  024543  3ED3: ff76f6           push word ptr [bp - 0xa]
  024546  3ED6: 9abe071f18       lcall 0x181f, 0x7be
  02454B  3EDB: 83c404           add sp, 4
  02454E  3EDE: 8946ea           mov word ptr [bp - 0x16], ax
  024551  3EE1: 0bc0             or ax, ax
  024553  3EE3: 7c21             jl 0x3f06
  024555  3EE5: 69d8ca00         imul bx, ax, 0xca
  024559  3EE9: a09653           mov al, byte ptr [0x5396]
  02455C  3EEC: 3887605d         cmp byte ptr [bx + 0x5d60], al
  024560  3EF0: 7407             je 0x3ef9
  024562  3EF2: 833ea25300       cmp word ptr [0x53a2], 0
  024567  3EF7: 740d             je 0x3f06
  024569  3EF9: ff76ea           push word ptr [bp - 0x16]
  02456C  3EFC: 9a08061f18       lcall 0x181f, 0x608
  024571  3F01: 83c402           add sp, 2
  024574  3F04: eb2b             jmp 0x3f31
  024576  3F06: 8b46f6           mov ax, word ptr [bp - 0xa]
  024579  3F09: 8b56f2           mov dx, word ptr [bp - 0xe]
  02457C  3F0C: 9ae0071f18       lcall 0x181f, 0x7e0
  024581  3F11: 0bc0             or ax, ax
  024583  3F13: 7c21             jl 0x3f36
  024585  3F15: 6bd81c           imul bx, ax, 0x1c
  024588  3F18: 8a874731         mov al, byte ptr [bx + 0x3147]
  02458C  3F1C: 240f             and al, 0xf
  02458E  3F1E: 3a069653         cmp al, byte ptr [0x5396]
  024592  3F22: 7512             jne 0x3f36
  024594  3F24: ff76f2           push word ptr [bp - 0xe]
  024597  3F27: ff76f6           push word ptr [bp - 0xa]
  02459A  3F2A: 0e               push cs
  02459B  3F2B: e8ad05           call 0x44db
  02459E  3F2E: 83c404           add sp, 4
  0245A1  3F31: c746e60100       mov word ptr [bp - 0x1a], 1
  0245A6  3F36: 837ee600         cmp word ptr [bp - 0x1a], 0
  0245AA  3F3A: 7510             jne 0x3f4c
  0245AC  3F3C: 6a01             push 1
  0245AE  3F3E: ff76f2           push word ptr [bp - 0xe]
  0245B1  3F41: ff76f6           push word ptr [bp - 0xa]
  0245B4  3F44: 9a080e1f18       lcall 0x181f, 0xe08
  0245B9  3F49: 83c406           add sp, 6
  0245BC  3F4C: 0e               push cs
  0245BD  3F4D: e81706           call 0x4567
  0245C0  3F50: 8b46e6           mov ax, word ptr [bp - 0x1a]
  0245C3  3F53: c9               leave 
  0245C4  3F54: cb               retf 

; ---- func_0245C6  size=107  insns=40  prologue=ENTER 0x0008,0  terminal=RETF ----
  0245C6  3F56: c8080000         enter 8, 0
  0245CA  3F5A: 833ef40700       cmp word ptr [0x7f4], 0
  0245CF  3F5F: 745e             je 0x3fbf
  0245D1  3F61: a1ea07           mov ax, word ptr [0x7ea]
  0245D4  3F64: 2d0900           sub ax, 9
  0245D7  3F67: 0306ca9c         add ax, word ptr [0x9cca]
  0245DB  3F6B: 8946fc           mov word ptr [bp - 4], ax
  0245DE  3F6E: a13a85           mov ax, word ptr [0x853a]
  0245E1  3F71: 48               dec ax
  0245E2  3F72: 48               dec ax
  0245E3  3F73: 50               push ax
  0245E4  3F74: 6a01             push 1
  0245E6  3F76: a1e807           mov ax, word ptr [0x7e8]
  0245E9  3F79: 2dfc00           sub ax, 0xfc
  0245EC  3F7C: 0306cc9c         add ax, word ptr [0x9ccc]
  0245F0  3F80: 50               push ax
  0245F1  3F81: 9a5c031f18       lcall 0x181f, 0x35c
  0245F6  3F86: 83c406           add sp, 6
  0245F9  3F89: 8946fe           mov word ptr [bp - 2], ax
  0245FC  3F8C: a13c85           mov ax, word ptr [0x853c]
  0245FF  3F8F: 48               dec ax
  024600  3F90: 48               dec ax
  024601  3F91: 50               push ax
  024602  3F92: 6a01             push 1
  024604  3F94: ff76fc           push word ptr [bp - 4]
  024607  3F97: 9a5c031f18       lcall 0x181f, 0x35c
  02460C  3F9C: 83c406           add sp, 6
  02460F  3F9F: 8946fc           mov word ptr [bp - 4], ax
  024612  3FA2: a17c01           mov ax, word ptr [0x17c]
  024615  3FA5: 3946fe           cmp word ptr [bp - 2], ax
  024618  3FA8: 7508             jne 0x3fb2
  02461A  3FAA: a17e01           mov ax, word ptr [0x17e]
  02461D  3FAD: 3946fc           cmp word ptr [bp - 4], ax
  024620  3FB0: 740d             je 0x3fbf
  024622  3FB2: 6a01             push 1
  024624  3FB4: ff76fc           push word ptr [bp - 4]
  024627  3FB7: ff76fe           push word ptr [bp - 2]
  02462A  3FBA: 9a080e1f18       lcall 0x181f, 0xe08
  02462F  3FBF: c9               leave 
  024630  3FC0: cb               retf 

; ---- func_024632  size=96  insns=31  prologue=ENTER 0x0002,0  terminal=RETF ----
  024632  3FC2: c8020000         enter 2, 0
  024636  3FC6: c746fe0000       mov word ptr [bp - 2], 0
  02463B  3FCB: a12893           mov ax, word ptr [0x9328]
  02463E  3FCE: 39063e93         cmp word ptr [0x933e], ax
  024642  3FD2: 753e             jne 0x4012
  024644  3FD4: 833ef40700       cmp word ptr [0x7f4], 0
  024649  3FD9: 7437             je 0x4012
  02464B  3FDB: c746fe0100       mov word ptr [bp - 2], 1
  024650  3FE0: 833e9c9200       cmp word ptr [0x929c], 0
  024655  3FE5: 7405             je 0x3fec
  024657  3FE7: 9acc0d1f18       lcall 0x181f, 0xdcc
  02465C  3FEC: 833ec65300       cmp word ptr [0x53c6], 0
  024661  3FF1: 7409             je 0x3ffc
  024663  3FF3: c706c4530000     mov word ptr [0x53c4], 0
  024669  3FF9: eb17             jmp 0x4012
  02466B  3FFB: 90               nop 
  02466C  3FFC: 833e905301       cmp word ptr [0x5390], 1
  024671  4001: 750b             jne 0x400e
  024673  4003: 6a00             push 0
  024675  4005: 0e               push cs
  024676  4006: e8d704           call 0x44e0
  024679  4009: 83c402           add sp, 2
  02467C  400C: eb04             jmp 0x4012
  02467E  400E: 0e               push cs
  02467F  400F: e82305           call 0x4535
  024682  4012: 837efe00         cmp word ptr [bp - 2], 0
  024686  4016: 7405             je 0x401d
  024688  4018: 9acc0d1f18       lcall 0x181f, 0xdcc
  02468D  401D: 8b46fe           mov ax, word ptr [bp - 2]
  024690  4020: c9               leave 
  024691  4021: cb               retf 

; ---- func_024692  size=80  insns=36  prologue=ENTER 0x0002,0  terminal=RETF ----
  024692  4022: c8020000         enter 2, 0
  024696  4026: c746fe0000       mov word ptr [bp - 2], 0
  02469B  402B: 0e               push cs
  02469C  402C: e8f704           call 0x4526
  02469F  402F: a33e93           mov word ptr [0x933e], ax
  0246A2  4032: 833eec0700       cmp word ptr [0x7ec], 0
  0246A7  4037: 7403             je 0x403c
  0246A9  4039: a32893           mov word ptr [0x9328], ax
  0246AC  403C: 833ef60700       cmp word ptr [0x7f6], 0
  0246B1  4041: 742a             je 0x406d
  0246B3  4043: a12893           mov ax, word ptr [0x9328]
  0246B6  4046: eb1c             jmp 0x4064
  0246B8  4048: 0e               push cs
  0246B9  4049: e81105           call 0x455d
  0246BC  404C: 8946fe           mov word ptr [bp - 2], ax
  0246BF  404F: 8b46fe           mov ax, word ptr [bp - 2]
  0246C2  4052: c9               leave 
  0246C3  4053: cb               retf 
  0246C4  4054: 0e               push cs
  0246C5  4055: e89c04           call 0x44f4
  0246C8  4058: 8b46fe           mov ax, word ptr [bp - 2]
  0246CB  405B: c9               leave 
  0246CC  405C: cb               retf 
  0246CD  405D: 90               nop 
  0246CE  405E: 0e               push cs
  0246CF  405F: e8ba04           call 0x451c
  0246D2  4062: ebe8             jmp 0x404c
  0246D4  4064: 48               dec ax
  0246D5  4065: 74e1             je 0x4048
  0246D7  4067: 48               dec ax
  0246D8  4068: 74ea             je 0x4054
  0246DA  406A: 48               dec ax
  0246DB  406B: 74f1             je 0x405e
  0246DD  406D: 8b46fe           mov ax, word ptr [bp - 2]
  0246E0  4070: c9               leave 
  0246E1  4071: cb               retf 

; ---- func_0246E2  size=1294  insns=388  prologue=ENTER 0x0008,0  terminal=page-end ----
  0246E2  4072: c8080000         enter 8, 0
  0246E6  4076: c746fc0000       mov word ptr [bp - 4], 0
  0246EB  407B: 833e905300       cmp word ptr [0x5390], 0
  0246F0  4080: 7506             jne 0x4088
  0246F2  4082: c706b0970100     mov word ptr [0x97b0], 1
  0246F8  4088: 9a06000c0c       lcall 0xc0c, 6
  0246FD  408D: 051400           add ax, 0x14
  024700  4090: 83d200           adc dx, 0
  024703  4093: a3ec97           mov word ptr [0x97ec], ax
  024706  4096: 8916ee97         mov word ptr [0x97ee], dx
  02470A  409A: 833e905301       cmp word ptr [0x5390], 1
  02470F  409F: 1bc0             sbb ax, ax
  024711  40A1: f7d8             neg ax
  024713  40A3: a39c92           mov word ptr [0x929c], ax
  024716  40A6: 9acc0d1f18       lcall 0x181f, 0xdcc
  02471B  40AB: 9a7a041f18       lcall 0x181f, 0x47a
  024720  40B0: bb4000           mov bx, 0x40
  024723  40B3: 8ec3             mov es, bx
  024725  40B5: bb1700           mov bx, 0x17
  024728  40B8: 268a07           mov al, byte ptr es:[bx]
  02472B  40BB: 250800           and ax, 8
  02472E  40BE: 8946fa           mov word ptr [bp - 6], ax
  024731  40C1: 9a70041f18       lcall 0x181f, 0x470
  024736  40C6: 9a06000c0c       lcall 0xc0c, 6
  02473B  40CB: a3e897           mov word ptr [0x97e8], ax
  02473E  40CE: 8916ea97         mov word ptr [0x97ea], dx
  024742  40D2: 2bc0             sub ax, ax
  024744  40D4: 9a66041f18       lcall 0x181f, 0x466
  024749  40D9: 9af6001f18       lcall 0x181f, 0xf6
  02474E  40DE: 8946fe           mov word ptr [bp - 2], ax
  024751  40E1: 0bc0             or ax, ax
  024753  40E3: 7511             jne 0x40f6
  024755  40E5: ff369808         push word ptr [0x898]
  024759  40E9: ff369608         push word ptr [0x896]
  02475D  40ED: 9a7e041f19       lcall 0x191f, 0x47e
  024762  40F2: 0bc0             or ax, ax
  024764  40F4: 7424             je 0x411a
  024766  40F6: 833e9c9200       cmp word ptr [0x929c], 0
  02476B  40FB: 7409             je 0x4106
  02476D  40FD: a1e897           mov ax, word ptr [0x97e8]
  024770  4100: 8b16ea97         mov dx, word ptr [0x97ea]
  024774  4104: eb0d             jmp 0x4113
  024776  4106: a1e897           mov ax, word ptr [0x97e8]
  024779  4109: 8b16ea97         mov dx, word ptr [0x97ea]
  02477D  410D: 051400           add ax, 0x14
  024780  4110: 83d200           adc dx, 0
  024783  4113: a3ec97           mov word ptr [0x97ec], ax
  024786  4116: 8916ee97         mov word ptr [0x97ee], dx
  02478A  411A: a1e897           mov ax, word ptr [0x97e8]
  02478D  411D: 8b16ea97         mov dx, word ptr [0x97ea]
  024791  4121: 3916ee97         cmp word ptr [0x97ee], dx
  024795  4125: 7f21             jg 0x4148
  024797  4127: 7c06             jl 0x412f
  024799  4129: 3906ec97         cmp word ptr [0x97ec], ax
  02479D  412D: 7719             ja 0x4148
  02479F  412F: 9acc0d1f18       lcall 0x181f, 0xdcc
  0247A4  4134: a1e897           mov ax, word ptr [0x97e8]
  0247A7  4137: 8b16ea97         mov dx, word ptr [0x97ea]
  0247AB  413B: 051400           add ax, 0x14
  0247AE  413E: 83d200           adc dx, 0
  0247B1  4141: a3ec97           mov word ptr [0x97ec], ax
  0247B4  4144: 8916ee97         mov word ptr [0x97ee], dx
  0247B8  4148: bb4000           mov bx, 0x40
  0247BB  414B: 8ec3             mov es, bx
  0247BD  414D: bb1700           mov bx, 0x17
  0247C0  4150: 268a07           mov al, byte ptr es:[bx]
  0247C3  4153: 250800           and ax, 8
  0247C6  4156: 8946f8           mov word ptr [bp - 8], ax
  0247C9  4159: 837efe00         cmp word ptr [bp - 2], 0
  0247CD  415D: 7503             jne 0x4162
  0247CF  415F: e9ae00           jmp 0x4210
  0247D2  4162: 9ae0031f18       lcall 0x181f, 0x3e0
  0247D7  4167: a31e98           mov word ptr [0x981e], ax
  0247DA  416A: 2bc0             sub ax, ax
  0247DC  416C: a30a93           mov word ptr [0x930a], ax
  0247DF  416F: a3960b           mov word ptr [0xb96], ax
  0247E2  4172: 833e1e9864       cmp word ptr [0x981e], 0x64
  0247E7  4177: 7506             jne 0x417f
  0247E9  4179: c7060a930100     mov word ptr [0x930a], 1
  0247EF  417F: 39060a93         cmp word ptr [0x930a], ax
  0247F3  4183: 7518             jne 0x419d
  0247F5  4185: 813e1e98ff00     cmp word ptr [0x981e], 0xff
  0247FB  418B: 7d10             jge 0x419d
  0247FD  418D: 8b1e1e98         mov bx, word ptr [0x981e]
  024801  4191: f687ed2702       test byte ptr [bx + 0x27ed], 2
  024806  4196: 7405             je 0x419d
  024808  4198: 832e1e9820       sub word ptr [0x981e], 0x20
  02480D  419D: 39060a93         cmp word ptr [0x930a], ax
  024811  41A1: 7513             jne 0x41b6
  024813  41A3: ff369808         push word ptr [0x898]
  024817  41A7: ff369608         push word ptr [0x896]
  02481B  41AB: a11e98           mov ax, word ptr [0x981e]
  02481E  41AE: 9a96041f19       lcall 0x191f, 0x496
  024823  41B3: a30a93           mov word ptr [0x930a], ax
  024826  41B6: 833e0a9300       cmp word ptr [0x930a], 0
  02482B  41BB: 7513             jne 0x41d0
  02482D  41BD: ff369808         push word ptr [0x898]
  024831  41C1: ff369608         push word ptr [0x896]
  024835  41C5: a11e98           mov ax, word ptr [0x981e]
  024838  41C8: 9a8a041f19       lcall 0x191f, 0x48a
  02483D  41CD: a30a93           mov word ptr [0x930a], ax
  024840  41D0: 833e0a9300       cmp word ptr [0x930a], 0
  024845  41D5: 7507             jne 0x41de
  024847  41D7: 0e               push cs
  024848  41D8: e82803           call 0x4503
  02484B  41DB: a30a93           mov word ptr [0x930a], ax
  02484E  41DE: 833e0a9300       cmp word ptr [0x930a], 0
  024853  41E3: 7514             jne 0x41f9
  024855  41E5: 833e905300       cmp word ptr [0x5390], 0
  02485A  41EA: 7506             jne 0x41f2
  02485C  41EC: 0e               push cs
  02485D  41ED: e8cd02           call 0x44bd
  024860  41F0: eb04             jmp 0x41f6
  024862  41F2: 0e               push cs
  024863  41F3: e8ef02           call 0x44e5
  024866  41F6: a30a93           mov word ptr [0x930a], ax
  024869  41F9: 9a06000c0c       lcall 0xc0c, 6
  02486E  41FE: 051400           add ax, 0x14
  024871  4201: 83d200           adc dx, 0
  024874  4204: a3ec97           mov word ptr [0x97ec], ax
  024877  4207: 8916ee97         mov word ptr [0x97ee], dx
  02487B  420B: c746fc0100       mov word ptr [bp - 4], 1
  024880  4210: 837efe00         cmp word ptr [bp - 2], 0
  024884  4214: 7525             jne 0x423b
  024886  4216: c41e9608         les bx, ptr [0x896]
  02488A  421A: 26833f00         cmp word ptr es:[bx], 0
  02488E  421E: 751b             jne 0x423b
  024890  4220: 06               push es
  024891  4221: 53               push bx
  024892  4222: b80100           mov ax, 1
  024895  4225: 9a7e041f19       lcall 0x191f, 0x47e
  02489A  422A: c41e9608         les bx, ptr [0x896]
  02489E  422E: 26833f00         cmp word ptr es:[bx], 0
  0248A2  4232: 7507             jne 0x423b
  0248A4  4234: 0e               push cs
  0248A5  4235: e80203           call 0x453a
  0248A8  4238: 0946fc           or word ptr [bp - 4], ax
  0248AB  423B: c41e9608         les bx, ptr [0x896]
  0248AF  423F: 26833f00         cmp word ptr es:[bx], 0
  0248B3  4243: 740f             je 0x4254
  0248B5  4245: c746fc0100       mov word ptr [bp - 4], 1
  0248BA  424A: 26ff37           push word ptr es:[bx]
  0248BD  424D: 0e               push cs
  0248BE  424E: e88002           call 0x44d1
  0248C1  4251: 83c402           add sp, 2
  0248C4  4254: 2bc0             sub ax, ax
  0248C6  4256: 8b16c253         mov dx, word ptr [0x53c2]
  0248CA  425A: 9a5c041f18       lcall 0x181f, 0x45c
  0248CF  425F: 833ef40700       cmp word ptr [0x7f4], 0
  0248D4  4264: 7507             jne 0x426d
  0248D6  4266: 833ef60700       cmp word ptr [0x7f6], 0
  0248DB  426B: 7510             jne 0x427d
  0248DD  426D: 803e940b00       cmp byte ptr [0xb94], 0
  0248E2  4272: 7409             je 0x427d
  0248E4  4274: c606940b00       mov byte ptr [0xb94], 0
  0248E9  4279: 0e               push cs
  0248EA  427A: e8d102           call 0x454e
  0248ED  427D: 833ec25300       cmp word ptr [0x53c2], 0
  0248F2  4282: 742a             je 0x42ae
  0248F4  4284: 9a9c001f18       lcall 0x181f, 0x9c
  0248F9  4289: 0bc0             or ax, ax
  0248FB  428B: 750d             jne 0x429a
  0248FD  428D: 3906f007         cmp word ptr [0x7f0], ax
  024901  4291: 741b             je 0x42ae
  024903  4293: 833eea0707       cmp word ptr [0x7ea], 7
  024908  4298: 7d14             jge 0x42ae
  02490A  429A: 6a00             push 0
  02490C  429C: 9a56001f18       lcall 0x181f, 0x56
  024911  42A1: 83c402           add sp, 2
  024914  42A4: 6a01             push 1
  024916  42A6: 9aea0d1f18       lcall 0x181f, 0xdea
  02491B  42AB: 83c402           add sp, 2
  02491E  42AE: 833ec25300       cmp word ptr [0x53c2], 0
  024923  42B3: 7473             je 0x4328
  024925  42B5: 833e960b00       cmp word ptr [0xb96], 0
  02492A  42BA: 7438             je 0x42f4
  02492C  42BC: 837ef800         cmp word ptr [bp - 8], 0
  024930  42C0: 7532             jne 0x42f4
  024932  42C2: 837efc00         cmp word ptr [bp - 4], 0
  024936  42C6: 752c             jne 0x42f4
  024938  42C8: 837efa00         cmp word ptr [bp - 6], 0
  02493C  42CC: 740e             je 0x42dc
  02493E  42CE: c746fa0000       mov word ptr [bp - 6], 0
  024943  42D3: 8b46f8           mov ax, word ptr [bp - 8]
  024946  42D6: a3960b           mov word ptr [0xb96], ax
  024949  42D9: eb4d             jmp 0x4328
  02494B  42DB: 90               nop 
  02494C  42DC: c746fc0100       mov word ptr [bp - 4], 1
  024951  42E1: c41e9608         les bx, ptr [0x896]
  024955  42E5: 26ff773a         push word ptr es:[bx + 0x3a]
  024959  42E9: 26ff7738         push word ptr es:[bx + 0x38]
  02495D  42ED: 9a72041f19       lcall 0x191f, 0x472
  024962  42F2: eb34             jmp 0x4328
  024964  42F4: 837efa00         cmp word ptr [bp - 6], 0
  024968  42F8: 740e             je 0x4308
  02496A  42FA: 837ef800         cmp word ptr [bp - 8], 0
  02496E  42FE: 7408             je 0x4308
  024970  4300: c746fa0100       mov word ptr [bp - 6], 1
  024975  4305: eb06             jmp 0x430d
  024977  4307: 90               nop 
  024978  4308: c746fa0000       mov word ptr [bp - 6], 0
  02497D  430D: 837ef800         cmp word ptr [bp - 8], 0
  024981  4311: 740f             je 0x4322
  024983  4313: 837efe00         cmp word ptr [bp - 2], 0
  024987  4317: 7509             jne 0x4322
  024989  4319: c706960b0100     mov word ptr [0xb96], 1
  02498F  431F: eb07             jmp 0x4328
  024991  4321: 90               nop 
  024992  4322: c706960b0000     mov word ptr [0xb96], 0
  024998  4328: 837efc00         cmp word ptr [bp - 4], 0
  02499C  432C: 7503             jne 0x4331
  02499E  432E: e990fd           jmp 0x40c1
  0249A1  4331: c706960b0000     mov word ptr [0xb96], 0
  0249A7  4337: 833ec25300       cmp word ptr [0x53c2], 0
  0249AC  433C: 7415             je 0x4353
  0249AE  433E: 803e940b00       cmp byte ptr [0xb94], 0
  0249B3  4343: 7409             je 0x434e
  0249B5  4345: c606940b00       mov byte ptr [0xb94], 0
  0249BA  434A: 0e               push cs
  0249BB  434B: e80002           call 0x454e
  0249BE  434E: 9a70041f18       lcall 0x181f, 0x470
  0249C3  4353: c9               leave 
  0249C4  4354: cb               retf 
  0249C5  4355: 90               nop 
  0249C6  4356: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  0249CB  435B: 8a874c31         mov al, byte ptr [bx + 0x314c]
  0249CF  435F: 2ae4             sub ah, ah
  0249D1  4361: eb55             jmp 0x43b8
  0249D3  4363: 90               nop 
  0249D4  4364: ff369253         push word ptr [0x5392]
  0249D8  4368: 9ac2011f19       lcall 0x191f, 0x1c2
  0249DD  436D: 83c402           add sp, 2
  0249E0  4370: cb               retf 
  0249E1  4371: 90               nop 
  0249E2  4372: ff369253         push word ptr [0x5392]
  0249E6  4376: 9a16021f19       lcall 0x191f, 0x216
  0249EB  437B: ebf0             jmp 0x436d
  0249ED  437D: 90               nop 
  0249EE  437E: ff369253         push word ptr [0x5392]
  0249F2  4382: 9aba041f19       lcall 0x191f, 0x4ba
  0249F7  4387: ebe4             jmp 0x436d
  0249F9  4389: 90               nop 
  0249FA  438A: ff369253         push word ptr [0x5392]
  0249FE  438E: 9afa011f19       lcall 0x191f, 0x1fa
  024A03  4393: ebd8             jmp 0x436d
  024A05  4395: 90               nop 
  024A06  4396: 6a00             push 0
  024A08  4398: ff369253         push word ptr [0x5392]
  024A0C  439C: 9ab2021f19       lcall 0x191f, 0x2b2
  024A11  43A1: 83c404           add sp, 4
  024A14  43A4: cb               retf 
  024A15  43A5: 90               nop 
  024A16  43A6: ff369253         push word ptr [0x5392]
  024A1A  43AA: 9aac041f19       lcall 0x191f, 0x4ac
  024A1F  43AF: ebbc             jmp 0x436d
  024A21  43B1: 90               nop 
  024A22  43B2: 0e               push cs
  024A23  43B3: e8b601           call 0x456c
  024A26  43B6: cb               retf 
  024A27  43B7: 90               nop 
  024A28  43B8: 48               dec ax
  024A29  43B9: 48               dec ax
  024A2A  43BA: 3d0700           cmp ax, 7
  024A2D  43BD: 77f3             ja 0x43b2
  024A2F  43BF: d1e0             shl ax, 1
  024A31  43C1: 93               xchg bx, ax
  024A32  43C2: 2effa7583b       jmp word ptr cs:[bx + 0x3b58]
  024A37  43C7: 90               nop 
  024A38  43C8: 263b0e3b42       cmp cx, word ptr es:[0x423b]
  024A3D  43CD: 3b363b42         cmp si, word ptr [0x423b]
  024A41  43D1: 3b1a             cmp bx, word ptr [bp + si]
  024A43  43D3: 3bf4             cmp si, sp
  024A45  43D5: 3a02             cmp al, byte ptr [bp + si]
  024A47  43D7: 3bc8             cmp cx, ax
  024A49  43D9: 06               push es
  024A4A  43DA: 0000             add byte ptr [bx + si], al
  024A4C  43DC: b80100           mov ax, 1
  024A4F  43DF: a3c453           mov word ptr [0x53c4], ax
  024A52  43E2: 50               push ax
  024A53  43E3: 9a1c0e1f18       lcall 0x181f, 0xe1c
  024A58  43E8: 83c402           add sp, 2
  024A5B  43EB: c7069253ffff     mov word ptr [0x5392], 0xffff
  024A61  43F1: 2bc0             sub ax, ax
  024A63  43F3: a3b097           mov word ptr [0x97b0], ax
  024A66  43F6: 50               push ax
  024A67  43F7: 0e               push cs
  024A68  43F8: e8e500           call 0x44e0
  024A6B  43FB: 83c402           add sp, 2
  024A6E  43FE: 9aa2041f19       lcall 0x191f, 0x4a2
  024A73  4403: c746fe0000       mov word ptr [bp - 2], 0
  024A78  4408: 833e905300       cmp word ptr [0x5390], 0
  024A7D  440D: 7551             jne 0x4460
  024A7F  440F: a19253           mov ax, word ptr [0x5392]
  024A82  4412: 9af4071f18       lcall 0x181f, 0x7f4
  024A87  4417: 0bc0             or ax, ax
  024A89  4419: 7545             jne 0x4460
  024A8B  441B: 9a06000c0c       lcall 0xc0c, 6
  024A90  4420: 8946fa           mov word ptr [bp - 6], ax
  024A93  4423: 8956fc           mov word ptr [bp - 4], dx
  024A96  4426: 6a00             push 0
  024A98  4428: 0e               push cs
  024A99  4429: e8b400           call 0x44e0
  024A9C  442C: 83c402           add sp, 2
  024A9F  442F: 8946fe           mov word ptr [bp - 2], ax
  024AA2  4432: 0bc0             or ax, ax
  024AA4  4434: 752a             jne 0x4460
  024AA6  4436: 9a06000c0c       lcall 0xc0c, 6
  024AAB  443B: 8b4efa           mov cx, word ptr [bp - 6]
  024AAE  443E: 8b5efc           mov bx, word ptr [bp - 4]
  024AB1  4441: 83c11e           add cx, 0x1e
  024AB4  4444: 83d300           adc bx, 0
  024AB7  4447: 3bd3             cmp dx, bx
  024AB9  4449: 7f06             jg 0x4451
  024ABB  444B: 7ce9             jl 0x4436
  024ABD  444D: 3bc1             cmp ax, cx
  024ABF  444F: 72e5             jb 0x4436
  024AC1  4451: 9aa2041f19       lcall 0x191f, 0x4a2
  024AC6  4456: f606825380       test byte ptr [0x5382], 0x80
  024ACB  445B: 7403             je 0x4460
  024ACD  445D: e880c4           call 0x8e0
  024AD0  4460: 833ec45300       cmp word ptr [0x53c4], 0
  024AD5  4465: 7423             je 0x448a
  024AD7  4467: 837efe00         cmp word ptr [bp - 2], 0
  024ADB  446B: 750c             jne 0x4479
  024ADD  446D: 6a00             push 0
  024ADF  446F: 6a01             push 1
  024AE1  4471: 9a5e051f18       lcall 0x181f, 0x55e
  024AE6  4476: 83c404           add sp, 4
  024AE9  4479: 833e905300       cmp word ptr [0x5390], 0
  024AEE  447E: 7506             jne 0x4486
  024AF0  4480: 0e               push cs
  024AF1  4481: e88e00           call 0x4512
  024AF4  4484: eb04             jmp 0x448a
  024AF6  4486: 0e               push cs
  024AF7  4487: e8e200           call 0x456c
  024AFA  448A: 833ec25300       cmp word ptr [0x53c2], 0
  024AFF  448F: 7411             je 0x44a2
  024B01  4491: 833ec45300       cmp word ptr [0x53c4], 0
  024B06  4496: 740a             je 0x44a2
  024B08  4498: 833e260800       cmp word ptr [0x826], 0
  024B0D  449D: 7503             jne 0x44a2
  024B0F  449F: e961ff           jmp 0x4403
  024B12  44A2: c9               leave 
  024B13  44A3: cb               retf 
  024B14  44A4: eaf40e1f18       ljmp 0x181f:0xef4
  024B19  44A9: ea000f1f18       ljmp 0x181f:0xf00
  024B1E  44AE: ea0c0f1f18       ljmp 0x181f:0xf0c
  024B23  44B3: ea180f1f18       ljmp 0x181f:0xf18
  024B28  44B8: ea240f1f18       ljmp 0x181f:0xf24
  024B2D  44BD: ea300f1f18       ljmp 0x181f:0xf30
  024B32  44C2: ea480f1f18       ljmp 0x181f:0xf48
  024B37  44C7: ea540f1f18       ljmp 0x181f:0xf54
  024B3C  44CC: ea600f1f18       ljmp 0x181f:0xf60
  024B41  44D1: ea780f1f18       ljmp 0x181f:0xf78
  024B46  44D6: ea840f1f18       ljmp 0x181f:0xf84
  024B4B  44DB: ea900f1f18       ljmp 0x181f:0xf90
  024B50  44E0: ea9c0f1f18       ljmp 0x181f:0xf9c
  024B55  44E5: eaa80f1f18       ljmp 0x181f:0xfa8
  024B5A  44EA: eab40f1f18       ljmp 0x181f:0xfb4
  024B5F  44EF: eac00f1f18       ljmp 0x181f:0xfc0
  024B64  44F4: eacc0f1f18       ljmp 0x181f:0xfcc
  024B69  44F9: ead80f1f18       ljmp 0x181f:0xfd8
  024B6E  44FE: eae40f1f18       ljmp 0x181f:0xfe4
  024B73  4503: eaf00f1f18       ljmp 0x181f:0xff0
  024B78  4508: ea00001f19       ljmp 0x191f:0
  024B7D  450D: ea0c001f19       ljmp 0x191f:0xc
  024B82  4512: ea18001f19       ljmp 0x191f:0x18
  024B87  4517: ea24001f19       ljmp 0x191f:0x24
  024B8C  451C: ea30001f19       ljmp 0x191f:0x30
  024B91  4521: ea3c001f19       ljmp 0x191f:0x3c
  024B96  4526: ea48001f19       ljmp 0x191f:0x48
  024B9B  452B: ea54001f19       ljmp 0x191f:0x54
  024BA0  4530: ea60001f19       ljmp 0x191f:0x60
  024BA5  4535: ea6c001f19       ljmp 0x191f:0x6c
  024BAA  453A: ea78001f19       ljmp 0x191f:0x78
  024BAF  453F: ea84001f19       ljmp 0x191f:0x84
  024BB4  4544: ea90001f19       ljmp 0x191f:0x90
  024BB9  4549: ea9c001f19       ljmp 0x191f:0x9c
  024BBE  454E: eaa8001f19       ljmp 0x191f:0xa8
  024BC3  4553: eab4001f19       ljmp 0x191f:0xb4
  024BC8  4558: eac0001f19       ljmp 0x191f:0xc0
  024BCD  455D: eacc001f19       ljmp 0x191f:0xcc
  024BD2  4562: ead8001f19       ljmp 0x191f:0xd8
  024BD7  4567: eae4001f19       ljmp 0x191f:0xe4
  024BDC  456C: eaf0001f19       ljmp 0x191f:0xf0
  024BE1  4571: eafc001f19       ljmp 0x191f:0xfc
  024BE6  4576: ea08011f19       ljmp 0x191f:0x108
  024BEB  457B: ea14011f19       ljmp 0x191f:0x114
