# Vagrant Layout (Ruby)

**See [plugin branch](https://github.com/koseki/vagrant-layout/tree/plugin) for detail.**

This is Ruby development environment using [Vagrant](https://www.vagrantup.com/). You can overwrite these files using [Gist](https://gist.github.com/) or just fork.

## Installation

```console
$ vagrant plugin install vagrant-layout
$ mkdir your-project-name
$ cd your-project-name
$ vagrant layout init ruby
```

## Start VM

1. Double click `sandbox/osx/start.command` or `sandbox/win/start.bat`
2. Access [http://localhost:8080/](http://localhost:8080/)

## Provisioning

`sandbox/bin/provision.sh` will install:

 * Nginx
 * MySQL
 * Ruby
 * Bundler

## Contributing

1. Fork it ( https://github.com/koseki/vagrant-layout/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
