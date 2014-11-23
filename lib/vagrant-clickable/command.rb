require 'optparse'
require 'fileutils'

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
        if File.exist?('sandbox')
          puts 'dir already exists.'
          return -1
        end

        return copy_template
      end

      def copy_template
        FileUtils.cp_r(File.join(File.dirname(__FILE__), '../../templates/base/'), 'sandbox/')
        0
      end
    end
  end
end
