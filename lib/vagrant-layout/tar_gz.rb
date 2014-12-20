require 'rubygems/package'
require 'zlib'

#
# Extract .tar.gz archive
# http://dracoater.blogspot.jp/2013/10/extracting-files-from-targz-with-ruby.html
#
class TarGz
  TAR_LONGLINK = '././@LongLink'

  def extract(source, destination)
    files = []
    Zlib::GzipReader.open(source) do |gz|
      Gem::Package::TarReader.new(gz) do |tar|
        dest = nil
        tar.each do |entry|
          if entry.full_name == TAR_LONGLINK
            dest = File.join(destination, entry.read.strip)
            next
          end
          dest ||= File.join(destination, entry.full_name)
          files << write_entry(entry, dest, files)
          dest = nil
        end
      end
    end
    files
  end

  def write_entry(entry, dest, files)
    if entry.directory?
      FileUtils.rm_rf(dest) unless File.directory?(dest)
      FileUtils.mkdir_p(dest, mode: entry.header.mode, verbose: false)
      return [:dir, dest]
    elsif entry.file?
      FileUtils.rm_rf(dest) unless File.file?(dest)
      File.open(dest, 'wb') do |f|
        f.print entry.read
      end
      FileUtils.chmod(entry.header.mode, dest, verbose: false)
      return [:file, dest]
    elsif entry.header.typeflag == '2'
      File.symlink(entry.header.linkname, dest)
      return [:symlink, dest]
    end
    [:other, entry]
  end
end
