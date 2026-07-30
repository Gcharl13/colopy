; MAPEDIT.EXE named disasm — module map_2.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _conform_to_view  file 0x009DB4..0x009DFA  seg 0x87B:0x4  (map_2.obj) ----
  009DB4  55               push bp
  009DB5  8bec             mov bp, sp
  009DB7  8b5e06           mov bx, word ptr [bp + 6]
  009DBA  8b07             mov ax, word ptr [bx]
  009DBC  3b06f249         cmp ax, word ptr [0x49f2]
  009DC0  7d03             jge 0x9dc5
  009DC2  a1f249           mov ax, word ptr [0x49f2]
  009DC5  8907             mov word ptr [bx], ax
  009DC7  8b5e08           mov bx, word ptr [bp + 8]
  009DCA  8b07             mov ax, word ptr [bx]
  009DCC  3b06f449         cmp ax, word ptr [0x49f4]
  009DD0  7d03             jge 0x9dd5
  009DD2  a1f449           mov ax, word ptr [0x49f4]
  009DD5  8907             mov word ptr [bx], ax
  009DD7  8b5e0a           mov bx, word ptr [bp + 0xa]
  009DDA  8b07             mov ax, word ptr [bx]
  009DDC  3b062660         cmp ax, word ptr [0x6026]
  009DE0  7e03             jle 0x9de5
  009DE2  a12660           mov ax, word ptr [0x6026]
  009DE5  8907             mov word ptr [bx], ax
  009DE7  8b5e0c           mov bx, word ptr [bp + 0xc]
  009DEA  8b07             mov ax, word ptr [bx]
  009DEC  3b063e60         cmp ax, word ptr [0x603e]
  009DF0  7e03             jle 0x9df5
  009DF2  a13e60           mov ax, word ptr [0x603e]
  009DF5  8907             mov word ptr [bx], ax
  009DF7  c9               leave
  009DF8  cb               retf
  009DF9  90               nop

; ---- _conform_to_view_size  file 0x009DFA..0x009E70  seg 0x87B:0x4a  (map_2.obj) ----
  009DFA  c8040000         enter 4, 0
  009DFE  57               push di
  009DFF  56               push si
  009E00  8b5e0a           mov bx, word ptr [bp + 0xa]
  009E03  8b07             mov ax, word ptr [bx]
  009E05  8b7606           mov si, word ptr [bp + 6]
  009E08  0304             add ax, word ptr [si]
  009E0A  48               dec ax
  009E0B  8946fe           mov word ptr [bp - 2], ax
  009E0E  8b7e0c           mov di, word ptr [bp + 0xc]
  009E11  8b05             mov ax, word ptr [di]
  009E13  8b5e08           mov bx, word ptr [bp + 8]
  009E16  0307             add ax, word ptr [bx]
  009E18  48               dec ax
  009E19  8946fc           mov word ptr [bp - 4], ax
  009E1C  a12660           mov ax, word ptr [0x6026]
  009E1F  3b46fe           cmp ax, word ptr [bp - 2]
  009E22  7e03             jle 0x9e27
  009E24  8b46fe           mov ax, word ptr [bp - 2]
  009E27  8b0c             mov cx, word ptr [si]
  009E29  3b0ef249         cmp cx, word ptr [0x49f2]
  009E2D  7d04             jge 0x9e33
  009E2F  8b0ef249         mov cx, word ptr [0x49f2]
  009E33  890c             mov word ptr [si], cx
  009E35  2bc1             sub ax, cx
  009E37  40               inc ax
  009E38  8b760a           mov si, word ptr [bp + 0xa]
  009E3B  8904             mov word ptr [si], ax
  009E3D  8b0e3e60         mov cx, word ptr [0x603e]
  009E41  3b4efc           cmp cx, word ptr [bp - 4]
  009E44  7e03             jle 0x9e49
  009E46  8b4efc           mov cx, word ptr [bp - 4]
  009E49  8b17             mov dx, word ptr [bx]
  009E4B  3b16f449         cmp dx, word ptr [0x49f4]
  009E4F  7d04             jge 0x9e55
  009E51  8b16f449         mov dx, word ptr [0x49f4]
  009E55  8917             mov word ptr [bx], dx
  009E57  2bca             sub cx, dx
  009E59  41               inc cx
  009E5A  890d             mov word ptr [di], cx
  009E5C  0bc0             or ax, ax
  009E5E  7d02             jge 0x9e62
  009E60  2bc0             sub ax, ax
  009E62  8904             mov word ptr [si], ax
  009E64  0bc9             or cx, cx
  009E66  7d02             jge 0x9e6a
  009E68  2bc9             sub cx, cx
  009E6A  890d             mov word ptr [di], cx
  009E6C  5e               pop si
  009E6D  5f               pop di
  009E6E  c9               leave
  009E6F  cb               retf

; ---- _update_terrain_region  file 0x009E70..0x009EDA  seg 0x87B:0xc0  (map_2.obj) ----
  009E70  c8080000         enter 8, 0
  009E74  a1f45a           mov ax, word ptr [0x5af4]
  009E77  2b06f449         sub ax, word ptr [0x49f4]
  009E7B  034608           add ax, word ptr [bp + 8]
  009E7E  f72e8c4e         imul word ptr [0x4e8c]
  009E82  8bc8             mov cx, ax
  009E84  8b460a           mov ax, word ptr [bp + 0xa]
  009E87  f72e8a4e         imul word ptr [0x4e8a]
  009E8B  8bd0             mov dx, ax
  009E8D  8b460c           mov ax, word ptr [bp + 0xc]
  009E90  8bda             mov bx, dx
  009E92  f72e8c4e         imul word ptr [0x4e8c]
  009E96  ff36023b         push word ptr [0x3b02]
  009E9A  ff36003b         push word ptr [0x3b00]
  009E9E  ff36fe3a         push word ptr [0x3afe]
  009EA2  ff36fc3a         push word ptr [0x3afc]
  009EA6  ff36fa3a         push word ptr [0x3afa]
  009EAA  ff36f83a         push word ptr [0x3af8]
  009EAE  ff36f63a         push word ptr [0x3af6]
  009EB2  ff36f43a         push word ptr [0x3af4]
  009EB6  8bd1             mov dx, cx
  009EB8  83c108           add cx, 8
  009EBB  51               push cx
  009EBC  53               push bx
  009EBD  50               push ax
  009EBE  a1d85a           mov ax, word ptr [0x5ad8]
  009EC1  2b06f249         sub ax, word ptr [0x49f2]
  009EC5  034606           add ax, word ptr [bp + 6]
  009EC8  8bca             mov cx, dx
  009ECA  f72e8a4e         imul word ptr [0x4e8a]
  009ECE  8bd8             mov bx, ax
  009ED0  8bd1             mov dx, cx
  009ED2  9a0000670c       lcall 0xc67, 0
  009ED7  c9               leave
  009ED8  cb               retf
  009ED9  90               nop

; ---- _update_terrain  file 0x009EDA..0x009F10  seg 0x87B:0x12a  (map_2.obj) ----
  009EDA  ff36023b         push word ptr [0x3b02]
  009EDE  ff36003b         push word ptr [0x3b00]
  009EE2  ff36fe3a         push word ptr [0x3afe]
  009EE6  ff36fc3a         push word ptr [0x3afc]
  009EEA  ff36fa3a         push word ptr [0x3afa]
  009EEE  ff36f83a         push word ptr [0x3af8]
  009EF2  ff36f63a         push word ptr [0x3af6]
  009EF6  ff36f43a         push word ptr [0x3af4]
  009EFA  6a08             push 8
  009EFC  ff36ec64         push word ptr [0x64ec]
  009F00  ff36ee64         push word ptr [0x64ee]
  009F04  2bc0             sub ax, ax
  009F06  99               cdq
  009F07  2bdb             sub bx, bx
  009F09  9a0000670c       lcall 0xc67, 0
  009F0E  cb               retf
  009F0F  90               nop

; ---- _show_map_gradually  file 0x009F10..0x009FCC  seg 0x87B:0x160  (map_2.obj) ----
  009F10  c8180000         enter 0x18, 0
  009F14  c746f40100       mov word ptr [bp - 0xc], 1
  009F19  c746f00000       mov word ptr [bp - 0x10], 0
  009F1E  2bc0             sub ax, ax
  009F20  8946fc           mov word ptr [bp - 4], ax
  009F23  8946fa           mov word ptr [bp - 6], ax
  009F26  a1d852           mov ax, word ptr [0x52d8]
  009F29  f72ed452         imul word ptr [0x52d4]
  009F2D  8946f6           mov word ptr [bp - 0xa], ax
  009F30  2bc0             sub ax, ax
  009F32  a3b850           mov word ptr [0x50b8], ax
  009F35  a3b650           mov word ptr [0x50b6], ax
  009F38  8b46f4           mov ax, word ptr [bp - 0xc]
  009F3B  d1e8             shr ax, 1
  009F3D  7303             jae 0x9f42
  009F3F  3500b4           xor ax, 0xb400
  009F42  8946f4           mov word ptr [bp - 0xc], ax
  009F45  8b46f4           mov ax, word ptr [bp - 0xc]
  009F48  48               dec ax
  009F49  8946fe           mov word ptr [bp - 2], ax
  009F4C  3b46f6           cmp ax, word ptr [bp - 0xa]
  009F4F  7370             jae 0x9fc1
  009F51  2bd2             sub dx, dx
  009F53  f736d452         div word ptr [0x52d4]
  009F57  8bc8             mov cx, ax
  009F59  8b46fe           mov ax, word ptr [bp - 2]
  009F5C  2bd2             sub dx, dx
  009F5E  f736d452         div word ptr [0x52d4]
  009F62  8bc2             mov ax, dx
  009F64  0306d85a         add ax, word ptr [0x5ad8]
  009F68  f72e8a4e         imul word ptr [0x4e8a]
  009F6C  8bd0             mov dx, ax
  009F6E  8bc1             mov ax, cx
  009F70  0306f45a         add ax, word ptr [0x5af4]
  009F74  8bca             mov cx, dx
  009F76  f72e8c4e         imul word ptr [0x4e8c]
  009F7A  050800           add ax, 8
  009F7D  50               push ax
  009F7E  ff368a4e         push word ptr [0x4e8a]
  009F82  ff368c4e         push word ptr [0x4e8c]
  009F86  8bd0             mov dx, ax
  009F88  8bc1             mov ax, cx
  009F8A  8bd8             mov bx, ax
  009F8C  9a4400340c       lcall 0xc34, 0x44
  009F91  817ef6b400       cmp word ptr [bp - 0xa], 0xb4
  009F96  7729             ja 0x9fc1
  009F98  8b46fc           mov ax, word ptr [bp - 4]
  009F9B  0b46fa           or ax, word ptr [bp - 6]
  009F9E  7416             je 0x9fb6
  009FA0  9a2200180d       lcall 0xd18, 0x22
  009FA5  2b46fa           sub ax, word ptr [bp - 6]
  009FA8  1b56fc           sbb dx, word ptr [bp - 4]
  009FAB  0bd2             or dx, dx
  009FAD  7cf1             jl 0x9fa0
  009FAF  7f05             jg 0x9fb6
  009FB1  3d0100           cmp ax, 1
  009FB4  72ea             jb 0x9fa0
  009FB6  9a2200180d       lcall 0xd18, 0x22
  009FBB  8946fa           mov word ptr [bp - 6], ax
  009FBE  8956fc           mov word ptr [bp - 4], dx
  009FC1  ff46f0           inc word ptr [bp - 0x10]
  009FC4  7403             je 0x9fc9
  009FC6  e96fff           jmp 0x9f38
  009FC9  c9               leave
  009FCA  cb               retf
  009FCB  90               nop

; ---- _show_map  file 0x009FCC..0x009FE4  seg 0x87B:0x21c  (map_2.obj) ----
  009FCC  6a08             push 8
  009FCE  ff36ec64         push word ptr [0x64ec]
  009FD2  ff36ee64         push word ptr [0x64ee]
  009FD6  2bc0             sub ax, ax
  009FD8  ba0800           mov dx, 8
  009FDB  2bdb             sub bx, bx
  009FDD  9a4400340c       lcall 0xc34, 0x44
  009FE2  cb               retf
  009FE3  90               nop

; ---- _show_map_region  file 0x009FE4..0x00A02A  seg 0x87B:0x234  (map_2.obj) ----
  009FE4  c8080000         enter 8, 0
  009FE8  a1f45a           mov ax, word ptr [0x5af4]
  009FEB  2b06f449         sub ax, word ptr [0x49f4]
  009FEF  034608           add ax, word ptr [bp + 8]
  009FF2  f72e8c4e         imul word ptr [0x4e8c]
  009FF6  050800           add ax, 8
  009FF9  8bc8             mov cx, ax
  009FFB  8b460a           mov ax, word ptr [bp + 0xa]
  009FFE  f72e8a4e         imul word ptr [0x4e8a]
  00A002  8bd0             mov dx, ax
  00A004  8b460c           mov ax, word ptr [bp + 0xc]
  00A007  8bda             mov bx, dx
  00A009  f72e8c4e         imul word ptr [0x4e8c]
  00A00D  51               push cx
  00A00E  53               push bx
  00A00F  50               push ax
  00A010  a1d85a           mov ax, word ptr [0x5ad8]
  00A013  2b06f249         sub ax, word ptr [0x49f2]
  00A017  034606           add ax, word ptr [bp + 6]
  00A01A  f72e8a4e         imul word ptr [0x4e8a]
  00A01E  8bd8             mov bx, ax
  00A020  8bd1             mov dx, cx
  00A022  9a4400340c       lcall 0xc34, 0x44
  00A027  c9               leave
  00A028  cb               retf
  00A029  90               nop
