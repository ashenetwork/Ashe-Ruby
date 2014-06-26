# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = 'ASHE'
  s.version       = '1.0.0'
  s.licenses      = ['MIT']
  s.summary       = 'ASHE Online Payment Ruby Library'
  s.description   = 'ASHE online payment ruby library allows merchants to make server side requests to Ashe.'
  s.authors       = ["Newman Wu"]
  s.email         = 'newman@ashepay.com'
  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.homepage      = 'https://www.ashepay.com'
  s.add_dependency('rest-client', '~> 1.4')
  s.require_paths = %w{lib}
  s.requirements << 'none'
end
