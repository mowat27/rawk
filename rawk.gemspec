require 'rubygems'

SPEC = Gem::Specification.new do |s|
  s.name = "rawk"
  s.version = '0.1.2'
  s.author = "Adrian Mowat"
  s.homepage = "https://github.com/mowat27/rawk"
  s.summary = "An awk-inspired ruby DSL"
  s.description = <<EOS
An awk-inspired ruby DSL
Provides an awk-like ruby interface for stream procesing
EOS
  s.has_rdoc = false
  
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables     = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib/rawk"]
end
