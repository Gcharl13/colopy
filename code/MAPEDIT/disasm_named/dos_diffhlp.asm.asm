; MAPEDIT.EXE named disasm — module dos_diffhlp.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __AHSHIFT  file 0x00160C..0x00160E  seg 0x0:0xc  (dos_diffhlp.asm.obj) ----
  00160C  cb               retf
  00160D  90               nop

; ---- __AHINCR  file 0x002600..0x0026CC  seg 0x0:0x1000  (dos_diffhlp.asm.obj) ----
  002600  c40a             les cx, ptr [bp + si]
  002602  803e5800a0       cmp byte ptr [0x58], 0xa0
  002607  7505             jne 0x260e
  002609  b80100           mov ax, 1
  00260C  eb02             jmp 0x2610
  00260E  2bc0             sub ax, ax
  002610  50               push ax
  002611  6a05             push 5
  002613  6a24             push 0x24
  002615  ff76fa           push word ptr [bp - 6]
  002618  8346fc11         add word ptr [bp - 4], 0x11
  00261C  ff76fc           push word ptr [bp - 4]
  00261F  0e               push cs
  002620  e807fd           call 0x232a
  002623  83c40a           add sp, 0xa
  002626  803e580020       cmp byte ptr [0x58], 0x20
  00262B  7505             jne 0x2632
  00262D  b80100           mov ax, 1
  002630  eb02             jmp 0x2634
  002632  2bc0             sub ax, ax
  002634  50               push ax
  002635  6a06             push 6
  002637  6a34             push 0x34
  002639  ff76fa           push word ptr [bp - 6]
  00263C  8346fc11         add word ptr [bp - 4], 0x11
  002640  ff76fc           push word ptr [bp - 4]
  002643  0e               push cs
  002644  e8e3fc           call 0x232a
  002647  83c40a           add sp, 0xa
  00264A  c746fca000       mov word ptr [bp - 4], 0xa0
  00264F  c746fa0a00       mov word ptr [bp - 6], 0xa
  002654  f606580020       test byte ptr [0x58], 0x20
  002659  741f             je 0x267a
  00265B  f606580080       test byte ptr [0x58], 0x80
  002660  740c             je 0x266e
  002662  8d46fa           lea ax, [bp - 6]
  002665  50               push ax
  002666  8d46fc           lea ax, [bp - 4]
  002669  50               push ax
  00266A  6a1b             push 0x1b
  00266C  eb43             jmp 0x26b1
  00266E  8d46fa           lea ax, [bp - 6]
  002671  50               push ax
  002672  8d46fc           lea ax, [bp - 4]
  002675  50               push ax
  002676  6a1c             push 0x1c
  002678  eb37             jmp 0x26b1
  00267A  f606580040       test byte ptr [0x58], 0x40
  00267F  7423             je 0x26a4
  002681  f606580080       test byte ptr [0x58], 0x80
  002686  740c             je 0x2694
  002688  8d46fa           lea ax, [bp - 6]
  00268B  50               push ax
  00268C  8d46fc           lea ax, [bp - 4]
  00268F  50               push ax
  002690  6a02             push 2
  002692  eb0a             jmp 0x269e
  002694  8d46fa           lea ax, [bp - 6]
  002697  50               push ax
  002698  8d46fc           lea ax, [bp - 4]
  00269B  50               push ax
  00269C  6a03             push 3
  00269E  0e               push cs
  00269F  e840f8           call 0x1ee2
  0026A2  eb11             jmp 0x26b5
  0026A4  8d46fa           lea ax, [bp - 6]
  0026A7  50               push ax
  0026A8  8d46fc           lea ax, [bp - 4]
  0026AB  50               push ax
  0026AC  a05600           mov al, byte ptr [0x56]
  0026AF  98               cwde
  0026B0  50               push ax
  0026B1  0e               push cs
  0026B2  e88df7           call 0x1e42
  0026B5  83c406           add sp, 6
  0026B8  6a00             push 0
  0026BA  684001           push 0x140
  0026BD  68c800           push 0xc8
  0026C0  2bc0             sub ax, ax
  0026C2  99               cdq
  0026C3  2bdb             sub bx, bx
  0026C5  9a4400340c       lcall 0xc34, 0x44
  0026CA  c9               leave
  0026CB  cb               retf
