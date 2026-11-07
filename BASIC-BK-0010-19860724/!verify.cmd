@echo off
rem Cut ROM range out of build\BASIC.SAV and compare with ..\BK\basic10_{1,2,3}.rom.
python "%~dp0x-romcmp.py" %*
exit /b %errorlevel%
