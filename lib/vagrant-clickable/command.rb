require 'optparse'
require 'fileutils'
require 'tmpdir'
require 'open-uri'
require_relative 'tar_gz'

module VagrantPlugins
  module Clickable
    class Command < Vagrant.plugin(2, :command)
      def self.synopsis
        'TODO: synopsis'
      end

      def execute
        opts = OptionParser.new do |opts|
          opts.banner = 'Usage: vagrant clickable init [gist-url]'
          opts.separator ''
        end

        argv = parse_options(opts)
        if File.exist?('sandbox')
          puts 'dir already exists.'
          return -1
        end
        if argv.empty?
          puts opts.help
          return -1
        end

        command = argv.shift

        if command == 'init'
          url = argv.shift
          if url
            if url !~ %r{\A(https://gist\.github\.com/[^/]+/[0-9a-f]+)(/(download)?)?}
              puts "Not gist URL: #{ url }"
              puts opts.help
              return -1
            end

            url  = Regexp.last_match[1]
            path = Regexp.last_match[2]
            if path == '/'
              url += 'download'
            elsif path.to_s == ''
              url += '/download'
            else
              url += path
            end
          end

          result = init(url)
          puts opts.help if result != 0
          return result
        end

        puts opts.help
        -1
      end

      def init(url)
        copy_template
        copy_gist(url) if url
        0
      end

      def copy_template
        base = File.join(File.dirname(__FILE__), '../../templates/base/')
        FileUtils.cp_r(base, 'sandbox/')
      end

      def copy_gist(url)
        tmpdir = Dir.mktmpdir do |dir|
          targz = File.join(dir, 'gist.tar.gz')
          dest = File.join(dir, 'gist')
          open(targz, 'wb') do |output|
            open(url) do |data|
              output.write(data.read)
            end
          end
          files = TarGz.new.extract(targz, dest)
          files.each do |file|
            dest_file = File.basename(file)
            dest_file.gsub!('__', '/')
            dest_file = File.join('sandbox', dest_file)
            FileUtils.cp(file, dest_file)
          end
        end
      end
    end
  end
end
