cd /d %~dp0..\..

call win\manage\init.bat
vagrant halt
vagrant destroy
pause
