Gem::Specification.new do |s|
  s.name = "enom"
  s.version = "1.1.2"
  s.authors = ["James Miller"]
  s.summary = %q{Ruby wrapper for the Enom API}
  s.description = %q{Enom is a Ruby wrapper and command line interface for portions of the Enom domain reseller API.}
  s.homepage = "http://github.com/bensie/enom"
  s.email = "bensie@gmail.com"
  s.files  = %w( README.md Rakefile LICENSE ) + ["lib/enom.rb"] + Dir.glob("lib/enom/*.rb") + Dir.glob("lib/enom/commands/*.rb") + Dir.glob("test/**/*") + Dir.glob("bin/*")
  s.add_dependency "public_suffix", '~> 5.0.0'
  s.add_dependency 'multi_xml'
  s.add_development_dependency "minitest", "~> 5.14.0"
  s.add_development_dependency "minitest-spec-context"
  s.add_development_dependency "shoulda"

  # run fork of fakeweb for now
  # @see https://github.com/chrisk/fakeweb/issues/57#issuecomment-419787124
  s.add_development_dependency "fakeweb-fi"
  s.add_development_dependency "rake", "~> 13.0.0"
  s.executables = %w(enom)
end
