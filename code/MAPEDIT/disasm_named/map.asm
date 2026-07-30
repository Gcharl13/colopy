; MAPEDIT.EXE named disasm — module map.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _on_map  file 0x0040BE..0x0040F0  seg 0x2AB:0xe  (map.obj) ----
  0040BE  c8020000         enter 2, 0
  0040C2  c746fe0100       mov word ptr [bp - 2], 1
  0040C7  837e0601         cmp word ptr [bp + 6], 1
  0040CB  7c18             jl 0x40e5
  0040CD  837e0801         cmp word ptr [bp + 8], 1
  0040D1  7c12             jl 0x40e5
  0040D3  a1124b           mov ax, word ptr [0x4b12]
  0040D6  48               dec ax
  0040D7  3b4606           cmp ax, word ptr [bp + 6]
  0040DA  7e09             jle 0x40e5
  0040DC  a1144b           mov ax, word ptr [0x4b14]
  0040DF  48               dec ax
  0040E0  3b4608           cmp ax, word ptr [bp + 8]
  0040E3  7f05             jg 0x40ea
  0040E5  c746fe0000       mov word ptr [bp - 2], 0
  0040EA  8b46fe           mov ax, word ptr [bp - 2]
  0040ED  c9               leave
  0040EE  cb               retf
  0040EF  90               nop

; ---- _on_colony_map  file 0x0040F0..0x004174  seg 0x2AB:0x40  (map.obj) ----
  0040F0  c8020000         enter 2, 0
  0040F4  837e0600         cmp word ptr [bp + 6], 0
  0040F8  7f09             jg 0x4103
  0040FA  8b4606           mov ax, word ptr [bp + 6]
  0040FD  f7d0             not ax
  0040FF  40               inc ax
  004100  894606           mov word ptr [bp + 6], ax
  004103  837e0800         cmp word ptr [bp + 8], 0
  004107  7f09             jg 0x4112
  004109  8b4608           mov ax, word ptr [bp + 8]
  00410C  f7d0             not ax
  00410E  40               inc ax
  00410F  894608           mov word ptr [bp + 8], ax
  004112  8b4608           mov ax, word ptr [bp + 8]
  004115  034606           add ax, word ptr [bp + 6]
  004118  3d0100           cmp ax, 1
  00411B  7f05             jg 0x4122
  00411D  b80100           mov ax, 1
  004120  eb02             jmp 0x4124
  004122  2bc0             sub ax, ax
  004124  8946fe           mov word ptr [bp - 2], ax
  004127  837e0a01         cmp word ptr [bp + 0xa], 1
  00412B  7442             je 0x416f
  00412D  837e0602         cmp word ptr [bp + 6], 2
  004131  7d0a             jge 0x413d
  004133  837e0802         cmp word ptr [bp + 8], 2
  004137  7d04             jge 0x413d
  004139  804efe01         or byte ptr [bp - 2], 1
  00413D  837e0a02         cmp word ptr [bp + 0xa], 2
  004141  742c             je 0x416f
  004143  8b4608           mov ax, word ptr [bp + 8]
  004146  034606           add ax, word ptr [bp + 6]
  004149  3d0200           cmp ax, 2
  00414C  7f06             jg 0x4154
  00414E  b80100           mov ax, 1
  004151  eb03             jmp 0x4156
  004153  90               nop
  004154  2bc0             sub ax, ax
  004156  0946fe           or word ptr [bp - 2], ax
  004159  837e0a03         cmp word ptr [bp + 0xa], 3
  00415D  7410             je 0x416f
  00415F  837e0602         cmp word ptr [bp + 6], 2
  004163  7c06             jl 0x416b
  004165  837e0802         cmp word ptr [bp + 8], 2
  004169  7d04             jge 0x416f
  00416B  804efe01         or byte ptr [bp - 2], 1
  00416F  8b46fe           mov ax, word ptr [bp - 2]
  004172  c9               leave
  004173  cb               retf

; ---- _on_screen  file 0x004174..0x0041AA  seg 0x2AB:0xc4  (map.obj) ----
  004174  c8020000         enter 2, 0
  004178  c746fe0100       mov word ptr [bp - 2], 1
  00417D  8b4606           mov ax, word ptr [bp + 6]
  004180  3906f249         cmp word ptr [0x49f2], ax
  004184  7f06             jg 0x418c
  004186  39062660         cmp word ptr [0x6026], ax
  00418A  7d05             jge 0x4191
  00418C  c746fe0000       mov word ptr [bp - 2], 0
  004191  8b4608           mov ax, word ptr [bp + 8]
  004194  3906f449         cmp word ptr [0x49f4], ax
  004198  7f06             jg 0x41a0
  00419A  3b063e60         cmp ax, word ptr [0x603e]
  00419E  7e05             jle 0x41a5
  0041A0  c746fe0000       mov word ptr [bp - 2], 0
  0041A5  8b46fe           mov ax, word ptr [bp - 2]
  0041A8  c9               leave
  0041A9  cb               retf

; ---- _map_loc  file 0x0041AA..0x0041C2  seg 0x2AB:0xfa  (map.obj) ----
  0041AA  c8040000         enter 4, 0
  0041AE  8b4608           mov ax, word ptr [bp + 8]
  0041B1  f72e124b         imul word ptr [0x4b12]
  0041B5  0306a804         add ax, word ptr [0x4a8]
  0041B9  8b16aa04         mov dx, word ptr [0x4aa]
  0041BD  034606           add ax, word ptr [bp + 6]
  0041C0  c9               leave
  0041C1  cb               retf

; ---- _map_get  file 0x0041C2..0x0041DE  seg 0x2AB:0x112  (map.obj) ----
  0041C2  c8040000         enter 4, 0
  0041C6  a1124b           mov ax, word ptr [0x4b12]
  0041C9  f76e08           imul word ptr [bp + 8]
  0041CC  8bd8             mov bx, ax
  0041CE  031ea804         add bx, word ptr [0x4a8]
  0041D2  8e06aa04         mov es, word ptr [0x4aa]
  0041D6  035e06           add bx, word ptr [bp + 6]
  0041D9  268a07           mov al, byte ptr es:[bx]
  0041DC  c9               leave
  0041DD  cb               retf

; ---- _feature_loc  file 0x0041DE..0x0041F6  seg 0x2AB:0x12e  (map.obj) ----
  0041DE  c8040000         enter 4, 0
  0041E2  a1124b           mov ax, word ptr [0x4b12]
  0041E5  f76e08           imul word ptr [bp + 8]
  0041E8  0306ac04         add ax, word ptr [0x4ac]
  0041EC  8b16ae04         mov dx, word ptr [0x4ae]
  0041F0  034606           add ax, word ptr [bp + 6]
  0041F3  c9               leave
  0041F4  cb               retf
  0041F5  90               nop

; ---- _feature_get  file 0x0041F6..0x004212  seg 0x2AB:0x146  (map.obj) ----
  0041F6  c8040000         enter 4, 0
  0041FA  a1124b           mov ax, word ptr [0x4b12]
  0041FD  f76e08           imul word ptr [bp + 8]
  004200  8bd8             mov bx, ax
  004202  031eac04         add bx, word ptr [0x4ac]
  004206  8e06ae04         mov es, word ptr [0x4ae]
  00420A  035e06           add bx, word ptr [bp + 6]
  00420D  268a07           mov al, byte ptr es:[bx]
  004210  c9               leave
  004211  cb               retf

; ---- _feature_set  file 0x004212..0x004248  seg 0x2AB:0x162  (map.obj) ----
  004212  c8040000         enter 4, 0
  004216  ff7608           push word ptr [bp + 8]
  004219  ff7606           push word ptr [bp + 6]
  00421C  0e               push cs
  00421D  e8beff           call 0x41de
  004220  83c404           add sp, 4
  004223  8946fc           mov word ptr [bp - 4], ax
  004226  8956fe           mov word ptr [bp - 2], dx
  004229  837e0c00         cmp word ptr [bp + 0xc], 0
  00422D  740b             je 0x423a
  00422F  8a460a           mov al, byte ptr [bp + 0xa]
  004232  c45efc           les bx, ptr [bp - 4]
  004235  260807           or byte ptr es:[bx], al
  004238  c9               leave
  004239  cb               retf
  00423A  8a460a           mov al, byte ptr [bp + 0xa]
  00423D  f6d0             not al
  00423F  c45efc           les bx, ptr [bp - 4]
  004242  262007           and byte ptr es:[bx], al
  004245  c9               leave
  004246  cb               retf
  004247  90               nop

; ---- _continent_loc  file 0x004248..0x004260  seg 0x2AB:0x198  (map.obj) ----
  004248  c8040000         enter 4, 0
  00424C  a1124b           mov ax, word ptr [0x4b12]
  00424F  f76e08           imul word ptr [bp + 8]
  004252  0306b004         add ax, word ptr [0x4b0]
  004256  8b16b204         mov dx, word ptr [0x4b2]
  00425A  034606           add ax, word ptr [bp + 6]
  00425D  c9               leave
  00425E  cb               retf
  00425F  90               nop

; ---- _continent_get  file 0x004260..0x00427E  seg 0x2AB:0x1b0  (map.obj) ----
  004260  c8040000         enter 4, 0
  004264  8b4608           mov ax, word ptr [bp + 8]
  004267  f72e124b         imul word ptr [0x4b12]
  00426B  8bd8             mov bx, ax
  00426D  031eb004         add bx, word ptr [0x4b0]
  004271  8e06b204         mov es, word ptr [0x4b2]
  004275  035e06           add bx, word ptr [bp + 6]
  004278  268a07           mov al, byte ptr es:[bx]
  00427B  c9               leave
  00427C  cb               retf
  00427D  90               nop

; ---- _continent_at  file 0x00427E..0x004290  seg 0x2AB:0x1ce  (map.obj) ----
  00427E  55               push bp
  00427F  8bec             mov bp, sp
  004281  ff7608           push word ptr [bp + 8]
  004284  ff7606           push word ptr [bp + 6]
  004287  0e               push cs
  004288  e8d5ff           call 0x4260
  00428B  240f             and al, 0xf
  00428D  c9               leave
  00428E  cb               retf
  00428F  90               nop

; ---- _continent_set  file 0x004290..0x0042B4  seg 0x2AB:0x1e0  (map.obj) ----
  004290  c8040000         enter 4, 0
  004294  ff7608           push word ptr [bp + 8]
  004297  ff7606           push word ptr [bp + 6]
  00429A  0e               push cs
  00429B  e8aaff           call 0x4248
  00429E  8946fc           mov word ptr [bp - 4], ax
  0042A1  8956fe           mov word ptr [bp - 2], dx
  0042A4  c45efc           les bx, ptr [bp - 4]
  0042A7  268a07           mov al, byte ptr es:[bx]
  0042AA  32460a           xor al, byte ptr [bp + 0xa]
  0042AD  240f             and al, 0xf
  0042AF  263007           xor byte ptr es:[bx], al
  0042B2  c9               leave
  0042B3  cb               retf

; ---- _owner_of  file 0x0042B4..0x0042DC  seg 0x2AB:0x204  (map.obj) ----
  0042B4  c8020000         enter 2, 0
  0042B8  ff7608           push word ptr [bp + 8]
  0042BB  ff7606           push word ptr [bp + 6]
  0042BE  0e               push cs
  0042BF  e89eff           call 0x4260
  0042C2  83c404           add sp, 4
  0042C5  c0e804           shr al, 4
  0042C8  2ae4             sub ah, ah
  0042CA  8946fe           mov word ptr [bp - 2], ax
  0042CD  3d0f00           cmp ax, 0xf
  0042D0  7505             jne 0x42d7
  0042D2  c746feffff       mov word ptr [bp - 2], 0xffff
  0042D7  8a46fe           mov al, byte ptr [bp - 2]
  0042DA  c9               leave
  0042DB  cb               retf

; ---- _owner_set  file 0x0042DC..0x004354  seg 0x2AB:0x22c  (map.obj) ----
  0042DC  c8040000         enter 4, 0
  0042E0  837e0a04         cmp word ptr [bp + 0xa], 4
  0042E4  7d49             jge 0x432f
  0042E6  ff7608           push word ptr [bp + 8]
  0042E9  ff7606           push word ptr [bp + 6]
  0042EC  0e               push cs
  0042ED  e84001           call 0x4430
  0042F0  83c404           add sp, 4
  0042F3  0bc0             or ax, ax
  0042F5  7c38             jl 0x432f
  0042F7  ff7608           push word ptr [bp + 8]
  0042FA  ff7606           push word ptr [bp + 6]
  0042FD  ff760a           push word ptr [bp + 0xa]
  004300  681805           push 0x518
  004303  9a0c000000       lcall 0, 0xc
  004308  83c408           add sp, 8
  00430B  6a05             push 5
  00430D  9a0e000000       lcall 0, 0xe
  004312  83c402           add sp, 2
  004315  8b4606           mov ax, word ptr [bp + 6]
  004318  99               cdq
  004319  52               push dx
  00431A  50               push ax
  00431B  8b4608           mov ax, word ptr [bp + 8]
  00431E  99               cdq
  00431F  52               push dx
  004320  50               push ax
  004321  b8acff           mov ax, 0xffac
  004324  ba0100           mov dx, 1
  004327  bb2d00           mov bx, 0x2d
  00432A  9ad603d00e       lcall 0xed0, 0x3d6
  00432F  ff7608           push word ptr [bp + 8]
  004332  ff7606           push word ptr [bp + 6]
  004335  0e               push cs
  004336  e80fff           call 0x4248
  004339  8946fc           mov word ptr [bp - 4], ax
  00433C  8956fe           mov word ptr [bp - 2], dx
  00433F  c45efc           les bx, ptr [bp - 4]
  004342  268a07           mov al, byte ptr es:[bx]
  004345  240f             and al, 0xf
  004347  8a4e0a           mov cl, byte ptr [bp + 0xa]
  00434A  c0e104           shl cl, 4
  00434D  0ac1             or al, cl
  00434F  268807           mov byte ptr es:[bx], al
  004352  c9               leave
  004353  cb               retf

; ---- _land_region_at  file 0x004354..0x004394  seg 0x2AB:0x2a4  (map.obj) ----
  004354  c8020000         enter 2, 0
  004358  c746feffff       mov word ptr [bp - 2], 0xffff
  00435D  ff7608           push word ptr [bp + 8]
  004360  ff7606           push word ptr [bp + 6]
  004363  0e               push cs
  004364  e857fd           call 0x40be
  004367  83c404           add sp, 4
  00436A  0bc0             or ax, ax
  00436C  7421             je 0x438f
  00436E  ff7608           push word ptr [bp + 8]
  004371  ff7606           push word ptr [bp + 6]
  004374  9a6c00b709       lcall 0x9b7, 0x6c
  004379  83c404           add sp, 4
  00437C  0bc0             or ax, ax
  00437E  750f             jne 0x438f
  004380  ff7608           push word ptr [bp + 8]
  004383  ff7606           push word ptr [bp + 6]
  004386  0e               push cs
  004387  e8f4fe           call 0x427e
  00438A  2ae4             sub ah, ah
  00438C  8946fe           mov word ptr [bp - 2], ax
  00438F  8b46fe           mov ax, word ptr [bp - 2]
  004392  c9               leave
  004393  cb               retf

; ---- _site_loc  file 0x004394..0x0043AC  seg 0x2AB:0x2e4  (map.obj) ----
  004394  c8040000         enter 4, 0
  004398  a1124b           mov ax, word ptr [0x4b12]
  00439B  f76e08           imul word ptr [bp + 8]
  00439E  0306b404         add ax, word ptr [0x4b4]
  0043A2  8b16b604         mov dx, word ptr [0x4b6]
  0043A6  034606           add ax, word ptr [bp + 6]
  0043A9  c9               leave
  0043AA  cb               retf
  0043AB  90               nop

; ---- _site_get  file 0x0043AC..0x0043C8  seg 0x2AB:0x2fc  (map.obj) ----
  0043AC  c8040000         enter 4, 0
  0043B0  a1124b           mov ax, word ptr [0x4b12]
  0043B3  f76e08           imul word ptr [bp + 8]
  0043B6  8bd8             mov bx, ax
  0043B8  031eb404         add bx, word ptr [0x4b4]
  0043BC  8e06b604         mov es, word ptr [0x4b6]
  0043C0  035e06           add bx, word ptr [bp + 6]
  0043C3  268a07           mov al, byte ptr es:[bx]
  0043C6  c9               leave
  0043C7  cb               retf

; ---- _is_unit  file 0x0043C8..0x0043F6  seg 0x2AB:0x318  (map.obj) ----
  0043C8  c8020000         enter 2, 0
  0043CC  c746feffff       mov word ptr [bp - 2], 0xffff
  0043D1  ff7608           push word ptr [bp + 8]
  0043D4  ff7606           push word ptr [bp + 6]
  0043D7  0e               push cs
  0043D8  e81bfe           call 0x41f6
  0043DB  83c404           add sp, 4
  0043DE  a801             test al, 1
  0043E0  740e             je 0x43f0
  0043E2  ff7608           push word ptr [bp + 8]
  0043E5  ff7606           push word ptr [bp + 6]
  0043E8  0e               push cs
  0043E9  e8c8fe           call 0x42b4
  0043EC  98               cwde
  0043ED  8946fe           mov word ptr [bp - 2], ax
  0043F0  8b46fe           mov ax, word ptr [bp - 2]
  0043F3  c9               leave
  0043F4  cb               retf
  0043F5  90               nop

; ---- _is_colony  file 0x0043F6..0x004430  seg 0x2AB:0x346  (map.obj) ----
  0043F6  c8020000         enter 2, 0
  0043FA  c746feffff       mov word ptr [bp - 2], 0xffff
  0043FF  ff7608           push word ptr [bp + 8]
  004402  ff7606           push word ptr [bp + 6]
  004405  0e               push cs
  004406  e8edfd           call 0x41f6
  004409  83c404           add sp, 4
  00440C  a802             test al, 2
  00440E  741b             je 0x442b
  004410  ff7608           push word ptr [bp + 8]
  004413  ff7606           push word ptr [bp + 6]
  004416  0e               push cs
  004417  e89afe           call 0x42b4
  00441A  83c404           add sp, 4
  00441D  98               cwde
  00441E  8946fe           mov word ptr [bp - 2], ax
  004421  3d0400           cmp ax, 4
  004424  7c05             jl 0x442b
  004426  c746feffff       mov word ptr [bp - 2], 0xffff
  00442B  8b46fe           mov ax, word ptr [bp - 2]
  00442E  c9               leave
  00442F  cb               retf

; ---- _is_village  file 0x004430..0x00446A  seg 0x2AB:0x380  (map.obj) ----
  004430  c8020000         enter 2, 0
  004434  c746feffff       mov word ptr [bp - 2], 0xffff
  004439  ff7608           push word ptr [bp + 8]
  00443C  ff7606           push word ptr [bp + 6]
  00443F  0e               push cs
  004440  e8b3fd           call 0x41f6
  004443  83c404           add sp, 4
  004446  a802             test al, 2
  004448  741b             je 0x4465
  00444A  ff7608           push word ptr [bp + 8]
  00444D  ff7606           push word ptr [bp + 6]
  004450  0e               push cs
  004451  e860fe           call 0x42b4
  004454  83c404           add sp, 4
  004457  98               cwde
  004458  8946fe           mov word ptr [bp - 2], ax
  00445B  3d0400           cmp ax, 4
  00445E  7d05             jge 0x4465
  004460  c746feffff       mov word ptr [bp - 2], 0xffff
  004465  8b46fe           mov ax, word ptr [bp - 2]
  004468  c9               leave
  004469  cb               retf

; ---- _is_city  file 0x00446A..0x004498  seg 0x2AB:0x3ba  (map.obj) ----
  00446A  c8020000         enter 2, 0
  00446E  c746feffff       mov word ptr [bp - 2], 0xffff
  004473  ff7608           push word ptr [bp + 8]
  004476  ff7606           push word ptr [bp + 6]
  004479  0e               push cs
  00447A  e879fd           call 0x41f6
  00447D  83c404           add sp, 4
  004480  a802             test al, 2
  004482  740e             je 0x4492
  004484  ff7608           push word ptr [bp + 8]
  004487  ff7606           push word ptr [bp + 6]
  00448A  0e               push cs
  00448B  e826fe           call 0x42b4
  00448E  98               cwde
  00448F  8946fe           mov word ptr [bp - 2], ax
  004492  8b46fe           mov ax, word ptr [bp - 2]
  004495  c9               leave
  004496  cb               retf
  004497  90               nop

; ---- _is_anything  file 0x004498..0x0044BA  seg 0x2AB:0x3e8  (map.obj) ----
  004498  c8020000         enter 2, 0
  00449C  ff7608           push word ptr [bp + 8]
  00449F  ff7606           push word ptr [bp + 6]
  0044A2  0e               push cs
  0044A3  e8c4ff           call 0x446a
  0044A6  83c404           add sp, 4
  0044A9  0bc0             or ax, ax
  0044AB  7d0a             jge 0x44b7
  0044AD  ff7608           push word ptr [bp + 8]
  0044B0  ff7606           push word ptr [bp + 6]
  0044B3  0e               push cs
  0044B4  e811ff           call 0x43c8
  0044B7  c9               leave
  0044B8  cb               retf
  0044B9  90               nop

; ---- _is_hostile  file 0x0044BA..0x004508  seg 0x2AB:0x40a  (map.obj) ----
  0044BA  c8040000         enter 4, 0
  0044BE  56               push si
  0044BF  c746fcffff       mov word ptr [bp - 4], 0xffff
  0044C4  ff7608           push word ptr [bp + 8]
  0044C7  ff7606           push word ptr [bp + 6]
  0044CA  0e               push cs
  0044CB  e828fd           call 0x41f6
  0044CE  83c404           add sp, 4
  0044D1  a848             test al, 0x48
  0044D3  742d             je 0x4502
  0044D5  ff7608           push word ptr [bp + 8]
  0044D8  ff7606           push word ptr [bp + 6]
  0044DB  0e               push cs
  0044DC  e8d5fd           call 0x42b4
  0044DF  83c404           add sp, 4
  0044E2  98               cwde
  0044E3  0bc0             or ax, ax
  0044E5  7c1b             jl 0x4502
  0044E7  3d0400           cmp ax, 4
  0044EA  7d16             jge 0x4502
  0044EC  3b460a           cmp ax, word ptr [bp + 0xa]
  0044EF  7411             je 0x4502
  0044F1  8bf0             mov si, ax
  0044F3  695e0a3c01       imul bx, word ptr [bp + 0xa], 0x13c
  0044F8  f680b44e40       test byte ptr [bx + si + 0x4eb4], 0x40
  0044FD  7403             je 0x4502
  0044FF  8946fc           mov word ptr [bp - 4], ax
  004502  8b46fc           mov ax, word ptr [bp - 4]
  004505  5e               pop si
  004506  c9               leave
  004507  cb               retf

; ---- _resource_at  file 0x004508..0x0045F0  seg 0x2AB:0x458  (map.obj) ----
  004508  c80a0000         enter 0xa, 0
  00450C  c746faffff       mov word ptr [bp - 6], 0xffff
  004511  833edc0400       cmp word ptr [0x4dc], 0
  004516  7503             jne 0x451b
  004518  e9d000           jmp 0x45eb
  00451B  ff7608           push word ptr [bp + 8]
  00451E  ff7606           push word ptr [bp + 6]
  004521  0e               push cs
  004522  e80bff           call 0x4430
  004525  83c404           add sp, 4
  004528  0bc0             or ax, ax
  00452A  7c03             jl 0x452f
  00452C  e9bc00           jmp 0x45eb
  00452F  ff7608           push word ptr [bp + 8]
  004532  ff7606           push word ptr [bp + 6]
  004535  0e               push cs
  004536  e889fc           call 0x41c2
  004539  83c404           add sp, 4
  00453C  2ae4             sub ah, ah
  00453E  8946f8           mov word ptr [bp - 8], ax
  004541  8066f83f         and byte ptr [bp - 8], 0x3f
  004545  837ef808         cmp word ptr [bp - 8], 8
  004549  7c06             jl 0x4551
  00454B  837ef810         cmp word ptr [bp - 8], 0x10
  00454F  7c0c             jl 0x455d
  004551  837ef810         cmp word ptr [bp - 8], 0x10
  004555  7c0d             jl 0x4564
  004557  837ef818         cmp word ptr [bp - 8], 0x18
  00455B  7d07             jge 0x4564
  00455D  c746fe0100       mov word ptr [bp - 2], 1
  004562  eb05             jmp 0x4569
  004564  c746fe0000       mov word ptr [bp - 2], 0
  004569  8a4606           mov al, byte ptr [bp + 6]
  00456C  250300           and ax, 3
  00456F  c1e002           shl ax, 2
  004572  8a4e08           mov cl, byte ptr [bp + 8]
  004575  83e103           and cx, 3
  004578  03c1             add ax, cx
  00457A  8b4e08           mov cx, word ptr [bp + 8]
  00457D  c1f902           sar cx, 2
  004580  8bd1             mov dx, cx
  004582  d1e1             shl cx, 1
  004584  03ca             add cx, dx
  004586  8b5606           mov dx, word ptr [bp + 6]
  004589  c1fa02           sar dx, 2
  00458C  02ca             add cl, dl
  00458E  2a4efe           sub cl, byte ptr [bp - 2]
  004591  020edc04         add cl, byte ptr [0x4dc]
  004595  83e10f           and cx, 0xf
  004598  3bc8             cmp cx, ax
  00459A  7407             je 0x45a3
  00459C  80f10a           xor cl, 0xa
  00459F  3bc8             cmp cx, ax
  0045A1  7548             jne 0x45eb
  0045A3  ff7608           push word ptr [bp + 8]
  0045A6  ff7606           push word ptr [bp + 6]
  0045A9  9a3200b709       lcall 0x9b7, 0x32
  0045AE  83c404           add sp, 4
  0045B1  8bd8             mov bx, ax
  0045B3  d1e3             shl bx, 1
  0045B5  8b87de04         mov ax, word ptr [bx + 0x4de]
  0045B9  8946fa           mov word ptr [bp - 6], ax
  0045BC  0bc0             or ax, ax
  0045BE  7505             jne 0x45c5
  0045C0  c746fa0600       mov word ptr [bp - 6], 6
  0045C5  ff7608           push word ptr [bp + 8]
  0045C8  ff7606           push word ptr [bp + 6]
  0045CB  0e               push cs
  0045CC  e827fc           call 0x41f6
  0045CF  83c404           add sp, 4
  0045D2  a804             test al, 4
  0045D4  7415             je 0x45eb
  0045D6  837efa0c         cmp word ptr [bp - 6], 0xc
  0045DA  750a             jne 0x45e6
  0045DC  c746fa0000       mov word ptr [bp - 6], 0
  0045E1  8b46fa           mov ax, word ptr [bp - 6]
  0045E4  c9               leave
  0045E5  cb               retf
  0045E6  c746faffff       mov word ptr [bp - 6], 0xffff
  0045EB  8b46fa           mov ax, word ptr [bp - 6]
  0045EE  c9               leave
  0045EF  cb               retf

; ---- _lost_city_at  file 0x0045F0..0x00466C  seg 0x2AB:0x540  (map.obj) ----
  0045F0  c8080000         enter 8, 0
  0045F4  c746fe0000       mov word ptr [bp - 2], 0
  0045F9  833edc0400       cmp word ptr [0x4dc], 0
  0045FE  7467             je 0x4667
  004600  ff7608           push word ptr [bp + 8]
  004603  ff7606           push word ptr [bp + 6]
  004606  9a3200b709       lcall 0x9b7, 0x32
  00460B  83c404           add sp, 4
  00460E  3d1900           cmp ax, 0x19
  004611  7454             je 0x4667
  004613  3d1a00           cmp ax, 0x1a
  004616  744f             je 0x4667
  004618  3d1800           cmp ax, 0x18
  00461B  744a             je 0x4667
  00461D  ff7608           push word ptr [bp + 8]
  004620  ff7606           push word ptr [bp + 6]
  004623  0e               push cs
  004624  e88dfc           call 0x42b4
  004627  83c404           add sp, 4
  00462A  98               cwde
  00462B  0bc0             or ax, ax
  00462D  7d38             jge 0x4667
  00462F  8b4608           mov ax, word ptr [bp + 8]
  004632  250300           and ax, 3
  004635  8b4e08           mov cx, word ptr [bp + 8]
  004638  c1f902           sar cx, 2
  00463B  6bc913           imul cx, cx, 0x13
  00463E  8b5606           mov dx, word ptr [bp + 6]
  004641  c1fa02           sar dx, 2
  004644  6bd211           imul dx, dx, 0x11
  004647  03ca             add cx, dx
  004649  030edc04         add cx, word ptr [0x4dc]
  00464D  83c108           add cx, 8
  004650  83e11f           and cx, 0x1f
  004653  8a5606           mov dl, byte ptr [bp + 6]
  004656  83e203           and dx, 3
  004659  c1e202           shl dx, 2
  00465C  2bca             sub cx, dx
  00465E  3bc8             cmp cx, ax
  004660  7505             jne 0x4667
  004662  c746fe0100       mov word ptr [bp - 2], 1
  004667  8b46fe           mov ax, word ptr [bp - 2]
  00466A  c9               leave
  00466B  cb               retf

; ---- _terrain_fix_2  file 0x00466C..0x0046B6  seg 0x2AB:0x5bc  (map.obj) ----
  00466C  55               push bp
  00466D  8bec             mov bp, sp
  00466F  8a4606           mov al, byte ptr [bp + 6]
  004672  241f             and al, 0x1f
  004674  2ae4             sub ah, ah
  004676  894606           mov word ptr [bp + 6], ax
  004679  a1da04           mov ax, word ptr [0x4da]
  00467C  eb2c             jmp 0x46aa
  00467E  837e0618         cmp word ptr [bp + 6], 0x18
  004682  7d2d             jge 0x46b1
  004684  837e0608         cmp word ptr [bp + 6], 8
  004688  7c27             jl 0x46b1
  00468A  8a4606           mov al, byte ptr [bp + 6]
  00468D  250700           and ax, 7
  004690  0c08             or al, 8
  004692  894606           mov word ptr [bp + 6], ax
  004695  8a4606           mov al, byte ptr [bp + 6]
  004698  c9               leave
  004699  cb               retf
  00469A  837e0618         cmp word ptr [bp + 6], 0x18
  00469E  7d11             jge 0x46b1
  0046A0  83660607         and word ptr [bp + 6], 7
  0046A4  8a4606           mov al, byte ptr [bp + 6]
  0046A7  c9               leave
  0046A8  cb               retf
  0046A9  90               nop
  0046AA  48               dec ax
  0046AB  48               dec ax
  0046AC  74d0             je 0x467e
  0046AE  48               dec ax
  0046AF  74e9             je 0x469a
  0046B1  8a4606           mov al, byte ptr [bp + 6]
  0046B4  c9               leave
  0046B5  cb               retf
