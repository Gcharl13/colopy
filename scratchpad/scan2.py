import capstone
with open('/home/user/colopy/raw/COLONIZE/VICEROY.EXE','rb') as f:
    data = f.read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

# Disassemble the whole evaluation region to find all [bp-0x26] modifications
# and check for any [bx+table] indexing of a cost table.
start, end = 0x0516A0, 0x051840
print(f"=== full eval region 0x{start:X}..0x{end:X} ===")
for ins in md.disasm(data[start:end], start):
    s = f"{ins.address:06X}  {ins.bytes.hex():<14} {ins.mnemonic} {ins.op_str}"
    mark = ""
    if '[bp - 0x26]' in ins.op_str or 'bp - 0x26' in ins.op_str:
        mark = "   <<< ACCUMULATOR"
    print(s+mark)
