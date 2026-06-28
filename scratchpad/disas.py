import capstone

path = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
with open(path, "rb") as f:
    data = f.read()

# Cited file offset
file_off = 0x22E50
# The resident mapping: file_off = 0x2400 + seg*16 + off
# So the in-memory linear (CS:IP base) address = file_off - 0x2400
load_base = 0x2400
mem_addr = file_off - load_base  # linear address within the loaded image

md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
md.detail = False

# Disassemble a generous window starting a bit before to confirm alignment
start = file_off
code = data[start:start+120]
print(f"Disassembling file_off=0x{file_off:X}, mem_addr=0x{mem_addr:X}")
for insn in md.disasm(code, mem_addr):
    foff = insn.address + load_base
    raw = ' '.join(f'{b:02X}' for b in insn.bytes)
    print(f"file=0x{foff:05X} mem=0x{insn.address:05X}: {raw:<20} {insn.mnemonic} {insn.op_str}")
