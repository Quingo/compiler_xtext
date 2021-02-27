from pathlib import Path

dir_path = Path(__file__).parent

str_eqasm_file = dir_path / 'build' / 'debug.eqasm.origin'
cls_eqasm_file = dir_path / 'build' / 'debug.eqasm'

with str_eqasm_file.open('r') as f:
    str_insns = f.readlines()

with cls_eqasm_file.open('r') as f:
    cls_insns = f.readlines()


max_outlines = 5
min_len = min(len(str_insns), len(cls_insns))
num_mismatch = 0
for i in range(min_len):
    if num_mismatch >= max_outlines:
        break
    if str_insns[i] != cls_insns[i]:
        if str_insns[i].lower().startswith('meas') and cls_insns[i][3:] == str_insns[i]:
            # ignore the leading PI before measure instruction
            continue
        print("mismatch at line {}".format(i + 1))
        print("    string-based insn: {}".format(str_insns[i].strip()))
        print("    class-based  insn: {}".format(cls_insns[i].strip()))
        num_mismatch += 1


if len(str_insns) != len(cls_insns):
    print("length does not match!")
