@echo off
rem Link build\*.OBJ into build\BASIC.SAV (+ map, symbol table). Run !build.cmd first.
rem pclink11 breaks on "D:" in paths, so run from build\ with relative names.
setlocal
pushd "%~dp0build"
..\..\tools\pclink11.exe BK.OBJ MONIT.OBJ COMP.OBJ TRAP.OBJ JMP.OBJ FLOAT.OBJ TAIL.OBJ /EXECUTE:BASIC.SAV /MAP /STB /WIDE
set RC=%errorlevel%
popd
exit /b %RC%
