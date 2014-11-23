require 'vagrant'

module VagrantPlugins
  module Clickable
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
