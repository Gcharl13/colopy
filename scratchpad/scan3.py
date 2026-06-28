import capstone
with open('/home/user/colopy/raw/COLONIZE/VICEROY.EXE','rb') as f:
    data = f.read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

# Search a wide region around the evaluator for sub/add [bp-0x26] with the
# claimed immediates -0x14 -0x2d -0xf +0x10, plus any [bx+ index]*table into accumulator.
start, end = 0x051200, 0x051A00
print(f"=== search 0x{start:X}..0x{end:X} for accumulator ops & claimed immediates ===")
for ins in md.disasm(data[start:end], start):
    op = ins.op_str
    if 'bp - 0x26' in op:
        print(f"ACC  {ins.address:06X}  {ins.bytes.hex():<12} {ins.mnemonic} {op}")
# Now look for the immediates 0x14,0x2d,0xf,0x10 as sub/add anywhere in 0x4E2D6..0x051D56
print("\n=== sub/add with imm 0x14/0x2d/0xf/0x10/0x3e7/0xa across 0x4E2D6..0x051D56 ===")
for ins in md.disasm(data[0x04E2D6:0x051D56], 0x04E2D6):
    if ins.mnemonic in ('sub','add') and ('bp - 0x26' in ins.op_str):
        print(f"{ins.address:06X}  {ins.bytes.hex():<12} {ins.mnemonic} {ins.op_str}")
