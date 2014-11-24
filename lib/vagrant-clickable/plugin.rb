require 'vagrant'

module VagrantPlugins
  module Clickable
    #
    # Plugin definition
    # https://docs.vagrantup.com/v2/plugins/development-basics.html
    #
    class Plugin < Vagrant.plugin('2')
      name 'clickable'
      description <<-DESC
      TODO: description
      DESC

      command('clickable') do
        require_relative 'command'
        Command
      end
    end
  end
end
