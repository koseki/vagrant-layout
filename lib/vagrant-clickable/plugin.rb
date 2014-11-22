require 'vagrant'

module VagrantPlugins
  module Clickable
    class Plugin < Vagrant.plugin('2')
      name 'clickable'
      description <<-DESC
      TODO: description
      DESC

      command('clickable') do
        require File.expand_path('../command', __FILE__)
        Command
      end
    end
  end
end
