"""Brute-force link order of build/*.OBJ: print orders sorted by number of differing ROM bytes."""
import itertools, subprocess, pathlib, sys
here = pathlib.Path(__file__).resolve().parent
bld = here / 'build'; tool = here.parent / 'tools' / 'pclink11.exe'
objs = sys.argv[1:] or ['BK', 'COMP', 'FLOAT', 'JMP', 'MONIT', 'TRAP']
rom = b''.join((here.parent / 'BK' / f).read_bytes() for f in ('basic10_1.rom', 'basic10_2.rom', 'basic10_3.rom'))
res = []
for p in itertools.permutations(objs):
    r = subprocess.run([str(tool), *[o + '.OBJ' for o in p], '/EXECUTE:T.SAV', '/NOBITMAP'], cwd=bld, capture_output=True, text=True)
    try: img = (bld / 'T.SAV').read_bytes()
    except OSError: continue
    mine = img[0o120000:0o120000 + len(rom)]
    d = sum(a != b for a, b in zip(mine, rom))
    res.append((d, p))
res.sort()
for d, p in res[:8]: print(d, ' '.join(p))
(bld / 'T.SAV').unlink(missing_ok=True)
