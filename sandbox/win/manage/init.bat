@rem Do not use non-ASCII character and ASCII special character in
@rem VAGRANT_HOME, VBOX_USER_HOME and your project directory.
@rem See https://github.com/mitchellh/vagrant/issues/4966

set VAGRANT_HOME=C:\vagrant
set VBOX_USER_HOME=C:\virtualbox

@rem ssh command required.
set PATH=C:\Program Files\Git\bin;C:\Program Files (x86)\Git\bin;%PATH%

if exist config/vagrant_proxy.bat (
  call config/vagrant_proxy.bat
)
