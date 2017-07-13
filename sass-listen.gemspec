# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'listen/version'

Gem::Specification.new do |s|
  s.name        = 'sass-listen'
  s.version     = Listen::VERSION
  s.license     = 'MIT'
  s.author      = 'Thibaud Guillaume-Gentil'
  s.email       = 'thibaud@thibaud.gg'
  s.homepage    = 'https://github.com/sass/listen'
  s.summary     = 'Fork of guard/listen'
  s.description = 'This fork of guard/listen provides a stable API for users of the ruby Sass CLI'

  s.files        = `git ls-files -z`.split("\x0").select do |f|
    /^(?:bin|lib)\// =~ f
  end + %w(CHANGELOG.md CONTRIBUTING.md LICENSE.txt README.md)

  s.test_files   = []
  s.executable   = 'listen'
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'rb-fsevent', '~> 0.9', '>= 0.9.4'
  s.add_dependency 'rb-inotify', '~> 0.9', '>= 0.9.7'

  s.add_development_dependency 'bundler', '>= 1.3.5'
end
