cd /d %~dp0..

call win\manage\init.bat
vagrant up
vagrant ssh -c "/vagrant/sandbox/bin/start.sh"
pause
