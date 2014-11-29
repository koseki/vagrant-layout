@rem Do not include space in VAGRANT_HOME. Do not use Japanese(CJK?) account name.
@rem https://github.com/mitchellh/vagrant/issues/4351
set VAGRANT_HOME=C:\vagrant

@rem ssh command required.
set PATH=C:\Program Files\Git\bin;C:\Program Files (x86)\Git\bin;%PATH%

if exist config/vagrant_proxy.bat (
  call config/vagrant_proxy.bat
)
