
def transient_file(path)
  f = File.open(path, 'w')
  yield
  File.delete(f)
end
