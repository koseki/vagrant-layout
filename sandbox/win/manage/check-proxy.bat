cd /d %~dp0..\..

call win\manage\init.bat

dir .
dir config
type config\vagrant_proxy.bat

echo %http_proxy%
echo %https_proxy%
echo %no_proxy%
echo %VAGRANT_HOME%

vagrant plugin list

vagrant halt
set CUSTOM_VAGRANT_LOG=1
vagrant up
set CUSTOM_VAGRANT_LOG=0
vagrant ssh -c 'echo $http_proxy'
vagrant ssh -c 'echo $https_proxy'
vagrant ssh -c 'echo $no_proxy'
vagrant ssh -c 'cat /etc/yum.conf'

curl -I http://www.google.com/
curl -I https://fedoraproject.org/

vagrant halt

pause
