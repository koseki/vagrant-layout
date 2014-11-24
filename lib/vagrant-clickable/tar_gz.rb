#
# http://dracoater.blogspot.jp/2013/10/extracting-files-from-targz-with-ruby.html
#
require 'rubygems/package'
require 'zlib'

class TarGz
  TAR_LONGLINK = '././@LongLink'

  def extract(source, destination)
    files = []
    Gem::Package::TarReader.new(Zlib::GzipReader.open(source)) do |tar|
      dest = nil
      tar.each do |entry|
        if entry.full_name == TAR_LONGLINK
          dest = File.join(destination, entry.read.strip)
          next
        end
        dest ||= File.join(destination, entry.full_name)
        if entry.directory?
          FileUtils.rm_rf(dest) unless File.directory?(dest)
          FileUtils.mkdir_p(dest, :mode => entry.header.mode, :verbose => false)
        elsif entry.file?
          FileUtils.rm_rf(dest) unless File.file?(dest)
          File.open(dest, 'wb') do |f|
            f.print entry.read
          end
          FileUtils.chmod(entry.header.mode, dest, :verbose => false)
          files << dest
        elsif entry.header.typeflag == '2' #Symlink!
          File.symlink(entry.header.linkname, dest)
        end
        dest = nil
      end
    end
    files
  end
end
