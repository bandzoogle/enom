Gem::Specification.new do |s|
  s.name = 'enom'
  s.version = '1.1.2'
  s.authors = ['James Miller']
  s.summary = 'Ruby wrapper for the Enom API'
  s.description = 'Enom is a Ruby wrapper and command line interface for portions of the Enom domain reseller API.'
  s.homepage = 'http://github.com/bensie/enom'
  s.email = 'bensie@gmail.com'
  s.files = %w[README.md Rakefile
               LICENSE] + ['lib/enom.rb'] + Dir.glob('lib/enom/*.rb') + Dir.glob('lib/enom/commands/*.rb') + Dir.glob('test/**/*') + Dir.glob('bin/*')
  s.add_dependency 'multi_xml', '~> 0.7'
  s.add_dependency 'public_suffix', '~> 7.0'
  s.add_development_dependency 'minitest', '~> 5.25'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.executables = %w[enom]
end
