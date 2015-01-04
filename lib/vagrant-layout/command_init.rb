require 'yaml'
require 'fileutils'
require 'tmpdir'
require 'open-uri'
require_relative 'target'
require_relative 'tar_gz'

module VagrantPlugins
  module Layout
    #
    # init command
    #
    class CommandInit
      def initialize(opts)
        @opts = opts
      end

      def execute
        begin
          target = Target.new(@opts[:argv].shift)
        rescue InvalidArgumentException
          return -1
        end

        Dir.mktmpdir do |root|
          dir = download_layout(root, target)
          copy_layout(dir)
        end

        0
      end

      def download_layout(root, target)
        if target.type == :github
          return download_github(root, target)
        elsif target.type == :gist
          dir = download_gist(root, target)
          return merge_gist_to_github(root, dir)
        end
      end

      def download_github(root, target)
        puts "Downloading: #{ target.url }"
        targz = File.join(root, 'base.tar.gz')
        dest = File.join(root, 'github')
        extract_tgz(target.url, targz, dest)
        first_dir(dest)
      end

      def download_gist(root, target)
        puts "Downloading: #{ target.url }"
        targz = File.join(root, 'gist.tar.gz')
        dest = File.join(root, 'gist')
        extract_tgz(target.url, targz, dest)
        first_dir(dest)
      end

      def extract_tgz(url, file, dest_dir)
        open(file, 'wb') do |output|
          open(url) do |data|
            output.write(data.read)
          end
        end
        TarGz.new.extract(file, dest_dir)
      end

      def first_dir(base)
        Dir.open(base).each do |dir|
          next if dir =~ /\A\.\.?\z/
          return File.join(base, dir)
        end
        nil
      end

      def merge_gist_to_github(root, gist_dir)
        dotfile = File.join(gist_dir, '.vagrant-layout')
        github_dir = nil

        if File.file?(dotfile)
          dot = YAML.load(File.read(dotfile))
          if dot['base']
            begin
              target = Target.new(dot['base'])
            rescue ArgumentError
            end

            if target && target.type == :github
              github_dir = download_github(root, target)
            else
              err = 'Illegal base url. Base URL must be like '
              err += 'https://github.com/{user}/{repos}/(tree|commit)/[0-9a-f]+'
              fail err
            end
          end
        end
        unless github_dir
          github_dir = File.join(root, 'github/empty')
          FileUtils.mkdir_p(github_dir)
        end

        copy_gist_files(gist_dir, github_dir)
        github_dir
      end

      def copy_gist_files(gist_dir, github_dir)
        Dir.chdir(gist_dir) do
          files = Dir.glob('*')
          if files.include?('patch')
            apply_patch(File.join(gist_dir, 'patch'), github_dir)
            files.delete('patch')
          end
          files.each do |file|
            dest_path = file.gsub('__', '/').gsub('//', '/')
            next if dest_path =~ /\.\.|\r|\n/
            dest_file = File.join(github_dir, dest_path)
            FileUtils.mkdir_p(File.dirname(dest_file))
            FileUtils.cp(File.join(gist_dir, file), dest_file, preserve: true)
          end
        end
      end

      def copy_layout(source_dir)
        sources = Dir.chdir(source_dir) { Dir.glob('**/*') }
        sources.delete_if { |src| src =~ /\A(README|LICENSE|\.git)/ }

        overwrite = []
        sources.each do |src|
          overwrite << src if File.exist?(src) && !File.directory?(src)
        end

        unless overwrite.empty?
          if @opts[:force]
            overwrite.each { |src| puts "Overwrite: #{ src }" }
          else
            puts 'File already exists in this directory. Please specify -f to overwrite.'
            overwrite.each { |src| puts "  #{ src }" }
            return false
          end
        end

        sources.each do |src|
          src_path = File.join(source_dir, src)
          if File.directory?(src_path)
            FileUtils.mkdir_p(src)
          else
            FileUtils.cp(src_path, src, preserve: true)
          end
        end
        true
      end

      def apply_patch(patch_file, github_dir)
        Dir.chdir(github_dir) do
          puts %x{git apply -v #{patch_file}}
        end
      end
    end
  end
end
