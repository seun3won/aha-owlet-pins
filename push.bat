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
echo [3/6] stage files
git add -A

echo.
echo [4/6] commit
git commit -m "pins batch" || echo      nothing to commit

echo.
echo [5/6] sync with remote (rebase)
REM  2026-09-08: pushes were silently rejected for weeks because this
REM  clone was 1 commit behind origin (the 08-18 noindex fix was pushed
REM  from another clone and never pulled here). The old PUSHFAIL message
REM  blamed "repo missing / not signed in", which hid the real cause.
git fetch origin
git rebase origin/main
if errorlevel 1 goto REBASEFAIL

echo.
echo [6/6] push
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

:REBASEFAIL
echo.
echo ===========================================================
echo  REBASE FAILED - local and remote history conflict.
echo  Do NOT force push. Resolve the conflict first:
echo    git status        (see conflicted files)
echo    git rebase --abort   (to undo and ask for help)
echo ===========================================================
goto END

:PUSHFAIL
echo.
echo ===========================================================
echo  PUSH FAILED - check in this order:
echo   1) rejected / non-fast-forward  -^> remote moved ahead.
echo      step [5/6] should have handled it; read its output.
echo   2) not signed in to GitHub in this machine's git
echo   3) repo "aha-owlet-pins" does not exist yet on GitHub
echo  Fix the above and run this file again.
echo ===========================================================

:END
echo.
pause
