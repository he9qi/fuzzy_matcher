require File.expand_path('../lib/fuzzy_matcher/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'fuzzy-matcher'
  s.version     = FuzzyMatcher::VERSION
  s.date        = '2014-04-18'
  s.summary     = "Fuzzy matches words, digits, etc. in a string of text."
  s.description = <<-DESC
    Fuzzy matcher looks for fuzzy matches such as words, digits, etc. in a string of text using regex or string.
  DESC
  s.authors     = ["Qi He"]
  s.email       = 'qihe229@gmail.com'
  s.files       = ["lib/fuzzy_matcher.rb", "lib/fuzzy_matcher/"]
  s.homepage    = 'http://github.com/he9qi/fuzzy_matcher'
  s.license     = 'MIT'
  
  s.files         = Dir.glob('lib/**/*.rb')
  s.require_paths = ['lib']
  s.test_files    = Dir.glob('spec/**/*.rb')
end