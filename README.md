# vagrant-layout plugin

vagrant-layout plugin do:

1. Download files from GitHub repository
2. Patch or overwrite the files using Gist


## Installation

```
$ vagrant plugin install vagrant-layout
$ vagrant layout --help
```

## Plugin Usage

```
$ vagrant layout init [target]
```

The targets can be one of the:

 * GitHub branch name (`ruby`)
 * GitHub user name and branch name (`koseki/ruby`)
 * GitHub user name, repository name and branch name (`koseki/vagrant-layout/ruby`)
 * GitHub tree URL (`https://github.com/koseki/vagrant-layout/tree/e09768d91387ea4465abb8755a3cd2eb011bee9a`)
 * Gist URL (`https://gist.github.com/koseki/37f61d9a02b9a48e6651`)
 * Blank. The default target is `koseki/vagrant-layout/master`

### Examples

At first, create project directory.

```
$ mkdir your_project_name
$ cd your_project_name
```

Download from [master branch](https://github.com/koseki/vagrant-layout/tree/master). This is default layout sample. Install Nginx to CentOS.

```
$ vagrant layout init
```

Download from [php branch](https://github.com/koseki/vagrant-layout/tree/php). Install Nginx, MySQL, PHP, php-fpm and Composer.

```
$ vagrant layout init php
```

Download from [ruby branch](https://github.com/koseki/vagrant-layout/tree/ruby). Install Nginx, MySQL, Ruby and Bundler.

```
$ vagrant layout init ruby
```

Download from specific commit and apply patch using [gist](https://gist.github.com/koseki/efbd631472c932ff2153). Install Laravel.

```
$ vagrant layout init https://gist.github.com/koseki/efbd631472c932ff2153
```

Download from specific commit and apply patch using [gist](https://gist.github.com/koseki/37f61d9a02b9a48e6651). Install Rails.

```
$ vagrant layout init https://gist.github.com/koseki/37f61d9a02b9a48e6651
```

Fork this repository and create your own layout.

```
## default repository is vagrant-layout.
$ vagrant layout init ${github_username}/${branch_name}
$ vagrant layout init ${github_username}/${repository}/${branch_name}
```

Download from specific tree.

```
$ vagrant layout init https://github.com/koseki/vagrant-layout/tree/e73c4b2162a9abe2bbce1bf13a5b6b6ec586593d
```

## Start VM

Doble click `sandbox/osx/start.command` or `sandbox/win/start.command`.

 * You need VirtualBox and Vagrant.

On Windows:

 * ssh command required for `vagrant ssh`. Git includes `ssh.exe`
 * use `LF` to execute shellscript. check `convert-eol.bat`
 * do not include white space and non-ASCII character in your project directory path
 * do not include white space and non-ASCII character in VAGRANT_HOME

If you want to use proxy:

 * execute `sandbox/osx/use-proxy.command` or `use-proxy.bat` and edit generated config file

## Stop VM

Dobule click `sandbox/osx/stop.command` or `stop.bat`.

## Update team member's VM

1. Update `sandbox/bin/provision.sh` and commit, push
2. Ask all team members to pull and execute `sandbox/osx/manage/provision.command` or `provision.bat`

You can't change old provisioning commands. Add new command blocks to `provisioning.sh`.

## Uninstall VM

Double click `sandbox/osx/manage/uninstall.command` or `uninstall.bat`.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vagrant-layout/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
