require './lib/blockinfo-ruby/version.rb'
Gem::Specification.new do |s|
  s.authors     = ["Bob Beauregard"]
  s.email       = ["rjbeau@gmail.com"]
  s.name        = 'blockinfo-ruby'
  s.version     = Crypto::VERSION
  s.date        = '2014-01-26'
  s.summary     = 'Simple blockchain balances'
  s.description = 'Simple blockchain balances'
  s.files       = Dir["README.md", "LICENSE", "lib/**/*"]
  s.homepage    = 'http://github.com/rjbeau/blockinfo-ruby'
  s.license     = 'apache2.0'

  s.add_dependency 'faraday', '~> 0.8.9'
  s.add_dependency 'json', '~> 1.8.0'
end
