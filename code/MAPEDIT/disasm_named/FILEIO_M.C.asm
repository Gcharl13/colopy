; MAPEDIT.EXE named disasm — module FILEIO_M.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @fileio_join_path  file 0x00D714..0x00D7A2  seg 0xC11:0x4  (FILEIO_M.C.obj) ----
  00D714  c8540000         enter 0x54, 0
  00D718  56               push si
  00D719  ff760c           push word ptr [bp + 0xc]
  00D71C  ff760a           push word ptr [bp + 0xa]
  00D71F  8d46ac           lea ax, [bp - 0x54]
  00D722  16               push ss
  00D723  50               push ax
  00D724  9aec0d8813       lcall 0x1388, 0xdec
  00D729  83c408           add sp, 8
  00D72C  8d46ac           lea ax, [bp - 0x54]
  00D72F  8bf0             mov si, ax
  00D731  8c56fe           mov word ptr [bp - 2], ss
  00D734  8bd8             mov bx, ax
  00D736  36803f00         cmp byte ptr ss:[bx], 0
  00D73A  740a             je 0xd746
  00D73C  8e46fe           mov es, word ptr [bp - 2]
  00D73F  46               inc si
  00D740  26803c00         cmp byte ptr es:[si], 0
  00D744  75f9             jne 0xd73f
  00D746  8e46fe           mov es, word ptr [bp - 2]
  00D749  8d5cff           lea bx, [si - 1]
  00D74C  26803f5c         cmp byte ptr es:[bx], 0x5c
  00D750  740f             je 0xd761
  00D752  681e07           push 0x71e
  00D755  8d46ac           lea ax, [bp - 0x54]
  00D758  50               push ax
  00D759  9ae6058813       lcall 0x1388, 0x5e6
  00D75E  83c404           add sp, 4
  00D761  8d46ac           lea ax, [bp - 0x54]
  00D764  16               push ss
  00D765  50               push ax
  00D766  ff7610           push word ptr [bp + 0x10]
  00D769  ff760e           push word ptr [bp + 0xe]
  00D76C  9aec0d8813       lcall 0x1388, 0xdec
  00D771  83c408           add sp, 8
  00D774  ff7608           push word ptr [bp + 8]
  00D777  ff7606           push word ptr [bp + 6]
  00D77A  ff7610           push word ptr [bp + 0x10]
  00D77D  ff760e           push word ptr [bp + 0xe]
  00D780  9a220e8813       lcall 0x1388, 0xe22
  00D785  83c408           add sp, 8
  00D788  ff7610           push word ptr [bp + 0x10]
  00D78B  ff760e           push word ptr [bp + 0xe]
  00D78E  9ab00d8813       lcall 0x1388, 0xdb0
  00D793  83c404           add sp, 4
  00D796  8b460e           mov ax, word ptr [bp + 0xe]
  00D799  8b5610           mov dx, word ptr [bp + 0x10]
  00D79C  5e               pop si
  00D79D  c9               leave
  00D79E  ca0c00           retf 0xc
  00D7A1  90               nop
