require 'optparse'
require 'fileutils'
require 'tmpdir'
require 'open-uri'
require_relative 'tar_gz'
require_relative 'command_init'

module VagrantPlugins
  module Layout
    #
    # Command implementation
    # https://docs.vagrantup.com/v2/plugins/commands.html
    #
    class Command < Vagrant.plugin(2, :command)
      def self.synopsis
        'TODO: synopsis'
      end

      def execute
        @opts = OptionParser.new do |o|
          o.banner = 'Usage: vagrant layout init [gist-url]'
          o.separator ''
        end

        @argv = parse_options(@opts)
        if @argv.empty?
          puts @opts.help
          return -1
        end

        command = @argv.shift

        result = -1
        if command == 'help'
          puts @opts.help
          result = 0
        elsif command == 'init'
          result = CommandInit.new(@argv).execute
        end

        puts @opts.help unless result == 0

        result
      end
    end
  end
end
