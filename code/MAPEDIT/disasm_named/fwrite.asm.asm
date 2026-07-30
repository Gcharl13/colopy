; MAPEDIT.EXE named disasm — module fwrite.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _fwrite  file 0x015322..0x015428  seg 0x1388:0x4a2  (fwrite.asm.obj) ----
  015322  55               push bp
  015323  8bec             mov bp, sp
  015325  83ec04           sub sp, 4
  015328  56               push si
  015329  57               push di
  01532A  8b4608           mov ax, word ptr [bp + 8]
  01532D  f7660a           mul word ptr [bp + 0xa]
  015330  8bc8             mov cx, ax
  015332  e35d             jcxz 0x15391
  015334  8946fe           mov word ptr [bp - 2], ax
  015337  8b5e06           mov bx, word ptr [bp + 6]
  01533A  8b760c           mov si, word ptr [bp + 0xc]
  01533D  bf6647           mov di, 0x4766
  015340  8bc6             mov ax, si
  015342  2dc646           sub ax, 0x46c6
  015345  03f8             add di, ax
  015347  f644060c         test byte ptr [si + 6], 0xc
  01534B  7505             jne 0x15352
  01534D  f60501           test byte ptr [di], 1
  015350  7405             je 0x15357
  015352  8b4502           mov ax, word ptr [di + 2]
  015355  eb03             jmp 0x1535a
  015357  b80002           mov ax, 0x200
  01535A  8946fc           mov word ptr [bp - 4], ax
  01535D  f6440608         test byte ptr [si + 6], 8
  015361  7505             jne 0x15368
  015363  f60501           test byte ptr [di], 1
  015366  7432             je 0x1539a
  015368  8b4402           mov ax, word ptr [si + 2]
  01536B  0bc0             or ax, ax
  01536D  742b             je 0x1539a
  01536F  3bc1             cmp ax, cx
  015371  7602             jbe 0x15375
  015373  8bc1             mov ax, cx
  015375  50               push ax
  015376  53               push bx
  015377  51               push cx
  015378  50               push ax
  015379  53               push bx
  01537A  ff34             push word ptr [si]
  01537C  0e               push cs
  01537D  e82c1c           call 0x16fac
  015380  83c406           add sp, 6
  015383  59               pop cx
  015384  5b               pop bx
  015385  58               pop ax
  015386  2bc8             sub cx, ax
  015388  294402           sub word ptr [si + 2], ax
  01538B  03d8             add bx, ax
  01538D  0104             add word ptr [si], ax
  01538F  eb03             jmp 0x15394
  015391  e98d00           jmp 0x15421
  015394  0bc9             or cx, cx
  015396  75c5             jne 0x1535d
  015398  eb76             jmp 0x15410
  01539A  3b4efc           cmp cx, word ptr [bp - 4]
  01539D  7248             jb 0x153e7
  01539F  f6440608         test byte ptr [si + 6], 8
  0153A3  7505             jne 0x153aa
  0153A5  f60501           test byte ptr [di], 1
  0153A8  740e             je 0x153b8
  0153AA  53               push bx
  0153AB  51               push cx
  0153AC  56               push si
  0153AD  0e               push cs
  0153AE  e89d10           call 0x1644e
  0153B1  5a               pop dx
  0153B2  59               pop cx
  0153B3  5b               pop bx
  0153B4  0bc0             or ax, ax
  0153B6  7558             jne 0x15410
  0153B8  33d2             xor dx, dx
  0153BA  8bc1             mov ax, cx
  0153BC  f776fc           div word ptr [bp - 4]
  0153BF  8bc1             mov ax, cx
  0153C1  2bc2             sub ax, dx
  0153C3  50               push ax
  0153C4  53               push bx
  0153C5  51               push cx
  0153C6  50               push ax
  0153C7  53               push bx
  0153C8  33c0             xor ax, ax
  0153CA  8a4407           mov al, byte ptr [si + 7]
  0153CD  50               push ax
  0153CE  0e               push cs
  0153CF  e8e417           call 0x16bb6
  0153D2  83c406           add sp, 6
  0153D5  59               pop cx
  0153D6  5b               pop bx
  0153D7  5a               pop dx
  0153D8  3dffff           cmp ax, 0xffff
  0153DB  742f             je 0x1540c
  0153DD  2bc8             sub cx, ax
  0153DF  3bc2             cmp ax, dx
  0153E1  7529             jne 0x1540c
  0153E3  03d8             add bx, ax
  0153E5  ebad             jmp 0x15394
  0153E7  33c0             xor ax, ax
  0153E9  8a07             mov al, byte ptr [bx]
  0153EB  53               push bx
  0153EC  51               push cx
  0153ED  56               push si
  0153EE  50               push ax
  0153EF  0e               push cs
  0153F0  e8b10d           call 0x161a4
  0153F3  83c404           add sp, 4
  0153F6  59               pop cx
  0153F7  5b               pop bx
  0153F8  3dffff           cmp ax, 0xffff
  0153FB  7413             je 0x15410
  0153FD  43               inc bx
  0153FE  49               dec cx
  0153FF  8b4502           mov ax, word ptr [di + 2]
  015402  0bc0             or ax, ax
  015404  7501             jne 0x15407
  015406  40               inc ax
  015407  8946fc           mov word ptr [bp - 4], ax
  01540A  eb88             jmp 0x15394
  01540C  804c0620         or byte ptr [si + 6], 0x20
  015410  e30c             jcxz 0x1541e
  015412  8b46fe           mov ax, word ptr [bp - 2]
  015415  2bc1             sub ax, cx
  015417  33d2             xor dx, dx
  015419  f77608           div word ptr [bp + 8]
  01541C  eb03             jmp 0x15421
  01541E  8b460a           mov ax, word ptr [bp + 0xa]
  015421  5f               pop di
  015422  5e               pop si
  015423  8be5             mov sp, bp
  015425  5d               pop bp
  015426  cb               retf
  015427  00               .byte 0x00
