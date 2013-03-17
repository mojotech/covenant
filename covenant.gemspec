# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'covenant/version'

Gem::Specification.new do |s|
  s.name          = "covenant"
  s.version       = Covenant::VERSION
  s.authors       = ["David Leal"]
  s.email         = ["gems@mojotech.com"]
  s.homepage      = "https://github.com/mojotech/covenant"
  s.summary       = "Assertion library for Ruby"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'sourcify', '~> 0.6.0.pre'
  s.add_development_dependency 'rspec', '>= 2.11'
end
