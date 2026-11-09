@echo off
setlocal
cd /d "%~dp0"
echo === Running all demonstration cases ===
swipl -q -s "src\symptom_matcher.pl" -- --demo
set "CODE=%ERRORLEVEL%"
echo Exit code: %CODE%
pause
endlocal & exit /b %CODE%
