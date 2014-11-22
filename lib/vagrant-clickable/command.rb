require 'optparse'

module VagrantPlugins
  module Clickable
    class Command < Vagrant.plugin(2, :command)
      def self.synopsis
        'TODO: synopsis'
      end

      def execute
        opts = OptionParser.new do |opts|
          opts.banner = 'Usage: vagrant clickable init'
          opts.separator ''
        end

        argv = parse_options(opts)
        return -1 if !argv

        0
      end
    end
  end
end
