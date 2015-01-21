@rem Do not use non-ASCII character and ASCII special character in
@rem VAGRANT_HOME, VirtualBox machine folder and your project directory.
@rem See https://github.com/mitchellh/vagrant/issues/4966

set VAGRANT_HOME=C:\vagrant

@rem ssh command required.
set PATH=C:\Program Files\Git\bin;C:\Program Files (x86)\Git\bin;%PATH%

if exist config/vagrant_proxy.bat (
  call config/vagrant_proxy.bat
)
