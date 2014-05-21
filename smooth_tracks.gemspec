# coding: utf-8
lib = File.expand_path( '../lib', __FILE__ )
$LOAD_PATH.unshift( lib ) unless $LOAD_PATH.include?( lib )
require 'smooth_tracks/version'

Gem::Specification.new do |spec|
  spec.name          = 'smooth_tracks'
  spec.version       = SmoothTracks::VERSION
  spec.author        = 'Michael Grohn'
  #spec.email         = 'mail@michaelgrohn.de'
  spec.summary       = 'Reusable Convenience Methods for Ruby on Rails.'
  #spec.description   = %q{ TODO: Write a longer description. Optional. }
  #spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split( "\x0" )
  spec.executables   = spec.files.grep( %r{ ^bin/ } ) { |f| File.basename( f ) }
  spec.test_files    = spec.files.grep( %r{ ^(test|spec|features)/ } )
  spec.require_paths = [ 'lib' ]

  spec.required_ruby_version =    '>= 2.0'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_runtime_dependency     'activesupport', [ '>= 4.0' ]
end
