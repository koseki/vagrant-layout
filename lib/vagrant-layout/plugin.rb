require 'vagrant'

module VagrantPlugins
  module Layout
    #
    # Plugin definition
    # https://docs.vagrantup.com/v2/plugins/development-basics.html
    #
    class Plugin < Vagrant.plugin('2')
      name 'layout'
      description <<-DESC
      TODO: description
      DESC

      command('layout') do
        require_relative 'command'
        Command
      end
    end
  end
end
