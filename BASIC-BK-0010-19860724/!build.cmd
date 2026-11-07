@echo off
rem Assemble BK-0010 BASIC into build\*.OBJ. BOM is stripped into build\src first.
rem BK.MAC ends inside an open .IF ("continued in another file"); GRAF.MAC closes it
rem and holds .END START, so BK+GRAF is ONE module (like RT-11 "MACRO BK+GRAF").
setlocal
set HERE=%~dp0
set TOOLS=%HERE%..\tools
set BLD=%HERE%build
set SRC=%BLD%\src
if not exist "%SRC%" mkdir "%SRC%"
set ERR=0
for %%M in (BK GRAF COMP FLOAT JMP MONIT TRAP TAIL) do call :strip %%M
call :asm BK BK GRAF
call :asm COMP COMP
call :asm FLOAT FLOAT
call :asm JMP JMP
call :asm MONIT MONIT
call :asm TRAP TRAP
call :asm TAIL TAIL
if %ERR% neq 0 (echo BUILD FAILED & exit /b 1)
echo ASSEMBLY OK
exit /b 0

:strip
powershell -NoProfile -Command "$b=[IO.File]::ReadAllBytes('%HERE%%1.MAC'); if($b.Length -ge 3 -and $b[0] -eq 239 -and $b[1] -eq 187 -and $b[2] -eq 191){$b=$b[3..($b.Length-1)]}; [IO.File]::WriteAllBytes('%SRC%\%1.MAC',$b)"
exit /b 0

:asm
rem %1 = object name, %2.. = source files (assembled together as one module)
set OBJ=%1
set FILES=
:next
shift
if "%~1"=="" goto go
set FILES=%FILES% "%SRC%\%~1.MAC"
goto next
:go
echo == %OBJ%
"%TOOLS%\macro11.exe" -rt11 -o "%BLD%\%OBJ%.OBJ" -l "%BLD%\%OBJ%.LST" %FILES%
if errorlevel 1 set ERR=1
exit /b 0
