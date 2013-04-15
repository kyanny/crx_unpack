require 'crx_unpack'
require 'tmpdir'
require 'digest/sha1'

shared_context 'Move to temporary directory' do
  before do
    @pwd = Dir.pwd
    @tmpdir = Dir.mktmpdir
    Dir.chdir(@tmpdir)
  end

  after do
    Dir.chdir(@pwd)
    FileUtils.rm_r(@tmpdir)
  end
end

def sha1hex(file)
  Digest::SHA1.hexdigest open(file).read
end

describe CrxUnpack do
  let(:crx_file) do
    File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', 'extension.crx'))
  end

  let(:crx_io) do
    open(crx_file, 'rb')
  end

  let(:crx_data) do
    open(crx_file, 'rb').read
  end

  let(:fixture_files) do
    Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', 'extension', '*')))
  end

  describe '#unpack' do
    it 'unpacks crx data' do
      subject.unpack(crx_data)
      expect(subject.zip[0,2]).to eq("PK")
    end
  end

  describe '#unpack_from_io' do
    it 'unpacks crx data from io' do
      subject.unpack_from_io(crx_io)
      expect(subject.zip[0,2]).to eq("PK")
    end
  end

  describe '#unpack_from_file' do
    it 'unpacks crx data from file' do
      subject.unpack_from_file(crx_file)
      expect(subject.zip[0,2]).to eq("PK")
    end
  end

  describe '.unpack' do
    it 'unpacks crx data' do
      crx = described_class.unpack(crx_data)
      expect(crx.zip[0,2]).to eq("PK")
    end
  end

  describe '.unpack_from_io' do
    it 'unpacks crx data from io' do
      crx = described_class.unpack_from_io(crx_io)
      expect(crx.zip[0,2]).to eq("PK")
    end
  end

  describe '.unpack_from_file' do
    it 'unpacks crx data from file' do
      crx = described_class.unpack_from_file(crx_file)
      expect(crx.zip[0,2]).to eq("PK")
    end
  end

  describe '#unpack_contents' do
    include_context 'Move to temporary directory'

    it 'unpacks crx contents' do
      subject.unpack_contents(crx_data, 'extension')

      Dir.chdir('extension') do
        fixture_files.each do |file|
          expect(sha1hex(File.basename(file))).to eq(sha1hex(file))
        end
      end
    end
  end

  describe '#unpack_contents_from_io' do
    include_context 'Move to temporary directory'

    it 'unpacks crx contents from io' do
      subject.unpack_contents_from_io(crx_io, 'extension')

      Dir.chdir('extension') do
        fixture_files.each do |file|
          expect(sha1hex(File.basename(file))).to eq(sha1hex(file))
        end
      end
    end
  end

  describe '#unpack_contents_from_file' do
    include_context 'Move to temporary directory'

    it 'unpacks crx contents from file' do
      subject.unpack_contents_from_file(crx_file, 'extension')

      Dir.chdir('extension') do
        fixture_files.each do |file|
          expect(sha1hex(File.basename(file))).to eq(sha1hex(file))
        end
      end
    end
  end

  describe '.unpack_contents' do
    include_context 'Move to temporary directory'

    it 'unpacks crx contents' do
      described_class.unpack_contents(crx_data, 'extension')

      Dir.chdir('extension') do
        fixture_files.each do |file|
          expect(sha1hex(File.basename(file))).to eq(sha1hex(file))
        end
      end
    end
  end

  describe '.unpack_contents_from_io' do
    include_context 'Move to temporary directory'

    it 'unpacks crx contents from io' do
      described_class.unpack_contents_from_io(crx_io, 'extension')

      Dir.chdir('extension') do
        fixture_files.each do |file|
          expect(sha1hex(File.basename(file))).to eq(sha1hex(file))
        end
      end
    end
  end

  describe '.unpack_contents_from_file' do
    include_context 'Move to temporary directory'

    it 'unpacks crx contents from file' do
      described_class.unpack_contents_from_file(crx_file, 'extension')

      Dir.chdir('extension') do
        fixture_files.each do |file|
          expect(sha1hex(File.basename(file))).to eq(sha1hex(file))
        end
      end
    end
  end
end
