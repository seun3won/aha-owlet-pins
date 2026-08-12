@echo off
setlocal
REM ===========================================================
REM  Aha Owlet pin hosting - push to GitHub Pages
REM  ASCII only on purpose: CMD misreads UTF-8 Korean and
REM  executes every line as a command (observed 2026-08-12).
REM  Korean documentation lives in README.md instead.
REM
REM  Prerequisite (once): create an EMPTY public repo on GitHub
REM  named  aha-owlet-pins   (do NOT add a README)
REM ===========================================================

cd /d "%~dp0"

echo.
echo [1/5] git available?
git --version
if errorlevel 1 goto NOGIT

echo.
echo [2/5] init repo
if not exist ".git" (
    git init
    git branch -M main
    git remote add origin https://github.com/seun3won/aha-owlet-pins.git
) else (
    echo      existing repo reused
    git remote set-url origin https://github.com/seun3won/aha-owlet-pins.git
)

echo.
echo [3/5] stage files
git add -A

echo.
echo [4/5] commit
git commit -m "pins batch" || echo      nothing to commit

echo.
echo [5/5] push
git push -u origin main
if errorlevel 1 goto PUSHFAIL

echo.
echo ===========================================================
echo  SUCCESS
echo  Check: https://seun3won.github.io/aha-owlet-pins/01-tantrum-cheat-sheet.png
echo  (GitHub Pages must be enabled: Settings - Pages - main / root)
echo ===========================================================
goto END

:NOGIT
echo.
echo  ERROR: git is not installed or not on PATH.
goto END

:PUSHFAIL
echo.
echo ===========================================================
echo  PUSH FAILED - most likely one of:
echo   1) repo "aha-owlet-pins" does not exist yet on GitHub
echo   2) not signed in to GitHub in this machine's git
echo  Fix the above and run this file again.
echo ===========================================================

:END
echo.
pause
