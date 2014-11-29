cd /d %~dp0..\..

set CONF_FILE=config\vagrant_proxy.bat

@echo off
if not exist %CONF_FILE% (
   echo set http_proxy=http://user:passwd@www.example.com:8080> %CONF_FILE%
   echo set https_proxy=http://user:passwd@www.example.com:8080>> %CONF_FILE%
   echo set no_proxy=localhost,127.0.0.1>> %CONF_FILE%

   @echo ----------------------------------------------------------------
   @echo Sample proxy configuration file created.
   @echo Edit sandbox/config/vagrant_proxy.bat, and press some key.
   @echo vagrant-proxyconf plugin will be installed.
   @echo ----------------------------------------------------------------
   @echo;
   pause
)
@echo on

call win\manage\init.bat

@echo;
@echo Proxy Configuration (sandbox/config/vagrant_proxy.bat)
@echo ----------------------------------------------------------------
@echo HTTP: %http_proxy%
@echo HTTPS: %https_proxy%
@echo NO Proxy: %no_proxy%
@echo ----------------------------------------------------------------
@echo VAGRANT_HOME = %VAGRANT_HOME%
@echo ----------------------------------------------------------------
@echo;
@echo Installing vagrant-proxyconf plugin via proxy.
@echo If installation fails, edit config file and execute use-proxy.bat again.
@echo;

vagrant plugin install vagrant-proxyconf
pause
