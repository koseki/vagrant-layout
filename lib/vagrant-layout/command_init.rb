require 'yaml'
require 'fileutils'
require 'tmpdir'
require 'open-uri'
require_relative 'tar_gz'

module VagrantPlugins
  module Layout
    #
    # init command
    #
    class CommandInit
      DEFAULT_REPOSITORY = %w{koseki vagrant-layout master}

      def initialize(argv)
        @argv = argv
      end

      def execute
        target = parse_target(@argv.shift)
        return -1 unless target

        Dir.mktmpdir do |root|
          dir = download_layout(root, target)
          copy_layout(dir)
        end

        0
      end

      def parse_target(target)
        return github_target(DEFAULT_REPOSITORY) unless target

        if target =~ %r{\A(https://gist\.github\.com/[^/]+/[0-9a-f]+)(/(download)?)?}
          url  = Regexp.last_match[1]
          path = Regexp.last_match[2]
          if path == '/'
            url += 'download'
          elsif path.to_s == ''
            url += '/download'
          else
            url += path
          end
          return [:gist, url]
        end

        target = target.split('/')
        if target.length == 1
          target = [DEFAULT_REPOSITORY[0], DEFAULT_REPOSITORY[1], target[0]]
        elsif target.length == 2
          target = [target[0], DEFAULT_REPOSITORY[1], target[1]]
        elsif target.length >= 4
          target = target[0..3]
        end

        github_target(target)
      end

      def github_target(target)
        url = "https://github.com/#{ target[0] }/#{ target[1] }/archive/#{ target[2] }.tar.gz"
        [:github, url]
      end

      def download_layout(root, target)
        if target[0] == :github
          return download_github(root, target)
        elsif target[0] == :gist
          dir = download_gist(root, target)
          return merge_gist_to_github(root, dir)
        end
      end

      def download_github(root, target)
        puts "Downloading: #{ target[1] }"
        targz = File.join(root, 'base.tar.gz')
        dest = File.join(root, 'github')
        extract_tgz(target[1], targz, dest)
        first_dir(dest)
      end

      def download_gist(root, target)
        puts "Downloading: #{ target[1] }"
        targz = File.join(root, 'gist.tar.gz')
        dest = File.join(root, 'gist')
        extract_tgz(target[1], targz, dest)
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
            if dot['base'] =~ %r{https://github.com/([-\w]+)/([-\w]+)/tree/([0-9a-f]{40})}
              github_dir = download_github(root, github_target(Regexp.last_match[1..3]))
            else
              msg = 'Illegal base url. Base URL must be like '
              msg += 'https://github.com/{user}/{repos}/tree/[0-9a-f]{40}'
              fail msg
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
          if File.exist?(src)
            overwrite << src
          end
        end

        unless overwrite.empty?
          puts 'File already exists in this directory. Please specify -f to overwrite.'
          overwrite.each { |src| puts "  #{ src }" }
          return false
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
