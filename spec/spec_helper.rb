require 'vcr'

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

def transient_file(path)
  tranny = File.open(path, 'w') do |f|
    yield
    f
  end
  File.delete(tranny)
end



VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.hook_into :webmock
end
