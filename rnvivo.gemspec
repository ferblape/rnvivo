# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'version'))

Gem::Specification.new do |s|
  s.name = 'rnvivo'
  s.homepage = 'http://github.com/ferblape/rnvivo'
  s.description = 'A simple Ruby library for the nvivo API'
  s.summary = 'nvivo API client in Ruby'
  s.require_path = 'lib'
  s.authors = ['Fernando Blat']
  s.email = ['ferblape@gmail.com']
  s.version = Rnvivo::VERSION
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob("{lib,test}/**/*") + %w[MIT-LICENSE README.md]

  s.add_dependency 'httparty'
end
