@echo off
setlocal
cd /d "%~dp0"
echo === Interactive symptom matcher ===
echo Enter comma-separated terms. An empty line exits.
swipl -q -s "src\symptom_matcher.pl" --
set "CODE=%ERRORLEVEL%"
echo Program exit code: %CODE%
pause
endlocal & exit /b %CODE%
