
def transient_file(path)
  tranny = File.open(path, 'w') do |f|
    yield
    f
  end
  File.delete(tranny)
end
