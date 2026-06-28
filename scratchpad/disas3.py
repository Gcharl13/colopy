import capstone
path = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
with open(path, "rb") as f:
    data = f.read()
load_base = 0x2400
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

# wait_keyOrClick target: lcall 0x181f,0x3c0 -> seg=0x181f off=0x3c0
# resident file_off = 0x2400 + seg*16 + off
seg=0x181f; off=0x3c0
foff = 0x2400 + seg*16 + off
print(f"wait_keyOrClick file_off = 0x{foff:X}")
code = data[foff:foff+80]
for insn in md.disasm(code, foff-load_base):
    f = insn.address + load_base
    raw = ' '.join(f'{b:02X}' for b in insn.bytes)
    print(f"file=0x{f:05X}: {raw:<18} {insn.mnemonic} {insn.op_str}")
