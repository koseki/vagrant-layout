require 'optparse'
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
        opts = { force: false }
        oparser = OptionParser.new do |o|
          o.banner = 'Usage: vagrant layout init [gist-url]'
          o.on('-f', '--force', 'Overwrite existing files') do |f|
            opts[:force] = f
          end
          o.separator ''
        end

        opts[:argv] = parse_options(oparser)
        if opts[:argv].empty?
          puts oparser.help
          return -1
        end

        command = opts[:argv].shift

        result = -1
        if command == 'help'
          puts oparser.help
          result = 0
        elsif command == 'init'
          result = CommandInit.new(opts).execute
        end

        puts oparser.help unless result == 0

        result
      end
    end
  end
end
