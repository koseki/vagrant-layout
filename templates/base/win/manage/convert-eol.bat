@rem VM mounted shell script doesn't work with CRLF newlines.

cd /d %~dp0..\..
call win\manage\init.bat

git config core.eol lf
git config core.autocrlf input

cd ..
git rm --cached -r .
git reset --hard

git config --list
pause
