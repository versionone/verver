require 'vcr'

def transient_file(path)
  tranny = File.open(path, 'w') do |f|
    yield
    f
  end
  File.delete(tranny)
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.hook_into :webmock
end
