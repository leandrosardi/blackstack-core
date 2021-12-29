Gem::Specification.new do |s|
  s.name        = 'blackstack_commons'
  s.version     = '1.1.46'
  s.date        = '2021-12-29'
  s.summary     = "THIS GEM IS STILL IN DEVELOPMENT STAGE. Commons classes, functions and constants for the BlackStack framework."
  s.description = "THIS GEM IS STILL IN DEVELOPMENT STAGE. Find documentation here: https://github.com/leandrosardi/blackstack_commons."
  s.authors     = ["Leandro Daniel Sardi"]
  s.email       = 'leandro.sardi@expandedventure.com'
  s.files       = [
    "lib/blackstack_commons.rb",
    "lib/extend_datetime.rb",
    "lib/extend_exception.rb",
    "lib/extend_fixnum.rb",
    "lib/extend_float.rb",
    "lib/extend_string.rb",
    "lib/extend_time.rb",
    "lib/functions.rb",
    "examples/example01.rb",
    "examples/example02.rb",    
  ]
  s.homepage    = 'https://rubygems.org/gems/blackstack_commons'
  s.license     = 'MIT'
  s.add_runtime_dependency 'content_spinning', '~> 0.3.1', '>= 0.3.1'
  s.add_runtime_dependency 'json', '~> 1.8.1', '>= 1.8.1'
  s.add_runtime_dependency 'pry', '~> 0.14.1', '>= 0.14.1' # this is used to add breakpoints
end