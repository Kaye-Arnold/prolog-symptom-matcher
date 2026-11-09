@echo off
setlocal
cd /d "%~dp0"
echo === Running all PLUnit tests ===
swipl -q -s "tests\run_tests.pl"
set "CODE=%ERRORLEVEL%"
echo Exit code: %CODE%
if not "%CODE%"=="0" (
  echo RESULT: tests did not pass.
  pause
  endlocal & exit /b %CODE%
)
echo RESULT: test runner reported a verified pass.
pause
endlocal & exit /b 0
