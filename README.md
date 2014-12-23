# Vagrant::Layout

## Installation

```
$ vagrant plugin install vagrant-layout
$ vagrant layout --help
```

## Plugin Usage

Copy files from [master branch](https://github.com/koseki/vagrant-layout/tree/master). This is very basic Vagrant layout sample. Install Nginx to CentOS.

```
$ mkdir your_project_name
$ cd your_project_name
$ vagrant layout init
```

Copy from [php branch](https://github.com/koseki/vagrant-layout/tree/php). Install Nginx, MySQL, PHP, php-fpm and Composer.

```
$ vagrant layout init php
```

Copy from [ruby branch](https://github.com/koseki/vagrant-layout/tree/ruby). Install Nginx, MySQL, Ruby and Bundler.

```
$ vagrant layout init ruby
```

Copy files from specific commit and apply patch using [gist](https://gist.github.com/koseki/efbd631472c932ff2153). Install Laravel.

```
$ vagrant layout init https://gist.github.com/koseki/efbd631472c932ff2153
```

Copy files from specific commit and apply patch using [gist](https://gist.github.com/koseki/37f61d9a02b9a48e6651). Install Rails.

```
$ vagrant layout init https://gist.github.com/koseki/37f61d9a02b9a48e6651
```

Fork this repository and create your own layout.

```
## default repository is vagrant-layout.
$ vagrant layout init ${github_username}/${branch_name}
$ vagrant layout init ${github_username}/${repository}/${branch_name}
```

Copy files from specific commit.

```
$ vagrant layout init https://github.com/koseki/vagrant-layout/tree/e73c4b2162a9abe2bbce1bf13a5b6b6ec586593d
```

## Start VM

Doble click `sandbox/osx/start.command` or `sandbox/win/start.command`.

 * You need VirtualBox and Vagrant.

If you are using Windows:

 * ssh command required for `vagrant ssh`. Git includes `ssh.exe`
 * use `LF` to execute shellscript. check `convert-eol.bat`
 * do not include white space and CJK character in VAGRANT_HOME and your project root path

If you need to use proxy:

 * execute `sandbox/osx/use-proxy.command` or `use-proxy.bat` and edit config file

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vagrant-layout/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
