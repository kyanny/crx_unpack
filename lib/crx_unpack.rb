require "crx_unpack/version"
require 'zip'
require 'fileutils'

class CrxUnpack
  attr_reader :magic, :version, :public_key_length, :signature_length, :public_key, :signature, :zip

  def unpack(data)
    @magic = data.slice!(0, 4)
    @version = data.slice!(0, 4)
    case @version
    when "\x02\x00\x00\x00"
      @public_key_length = data.slice!(0, 4).unpack("i*")[0]
      @signature_length = data.slice!(0, 4).unpack("i*")[0]
      @public_key = data.slice!(0, public_key_length)
      @signature = data.slice!(0, signature_length)
      @zip = data
    when "\x03\x00\x00\x00"
      header_length = data.slice!(0, 4).unpack("i*")[0]
      data.slice!(0, header_length)
      @zip = data
    else
      fail "unsupported CRX file format version: #{@version}"
    end
    self
  end

  def unpack_from_io(io)
    io.binmode? || io.binmode
    unpack(io.read)
  end

  def unpack_from_file(file)
    unpack(open(file, 'rb').read)
  end

  def unpack_contents(data, dest, leave_zip_file=false)
    unpack(data)
    dest = File.expand_path(dest)
    unless Dir.exists?(dest)
      Dir.mkdir(dest)
    end

    Dir.chdir(dest) do
      zip_file = 'extension.zip'
      open(zip_file, 'wb'){ |f| f.write zip }
      begin
        zf = Zip::File.new(zip_file)
        zf.each do |entry|
          zf.extract(entry, entry.to_s)
        end
      ensure
        File.unlink(zip_file) unless leave_zip_file
      end
    end
  end

  def unpack_contents_from_io(io, dest, leave_zip_file=false)
    io.binmode? || io.binmode
    unpack_contents(io.read, dest, leave_zip_file)
  end

  def unpack_contents_from_file(file, dest, leave_zip_file=false)
    unpack_contents(open(file, 'rb').read, dest, leave_zip_file)
  end

  class << self
    def unpack(data)
      new.unpack(data)
    end

    def unpack_from_io(io)
      new.unpack_from_io(io)
    end

    def unpack_from_file(file)
      new.unpack_from_file(file)
    end

    def unpack_contents(data, dest, leave_zip_file=false)
      new.unpack_contents(data, dest, leave_zip_file)
    end

    def unpack_contents_from_io(io, dest, leave_zip_file=false)
      new.unpack_contents_from_io(io, dest, leave_zip_file)
    end

    def unpack_contents_from_file(file, dest, leave_zip_file=false)
      new.unpack_contents_from_file(file, dest, leave_zip_file)
    end
  end
end
