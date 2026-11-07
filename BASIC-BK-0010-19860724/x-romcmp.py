"""Compare ROM range of build/BASIC.SAV (flat 64K memory image) with BK/basic10_{1,2,3}.rom."""
import sys, pathlib
here = pathlib.Path(__file__).resolve().parent
img = (here / 'build' / 'BASIC.SAV').read_bytes()
chips = [('basic10_1.rom', 0o120000), ('basic10_2.rom', 0o140000), ('basic10_3.rom', 0o160000)]
total = diffs = 0
first = None
runs = []   # (start_addr, length) of differing byte runs
for name, base in chips:
    rom = (here.parent / 'BK' / name).read_bytes()
    mine = img[base:base + len(rom)]
    d = [i for i in range(len(rom)) if rom[i] != mine[i]]
    print(f'{name}: {len(rom)} bytes, {len(d)} differ')
    total += len(rom); diffs += len(d)
    for i in d:
        a = base + i
        if runs and runs[-1][0] + runs[-1][1] == a: runs[-1][1] += 1
        else: runs.append([a, 1])
print(f'TOTAL: {diffs}/{total} bytes differ, {len(runs)} runs')
for a, n in runs[:int(sys.argv[1]) if len(sys.argv) > 1 else 10]:
    print(f'  {a:06o} len {n}')
sys.exit(0 if diffs == 0 else 1)
