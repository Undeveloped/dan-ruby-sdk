Gem::Specification.new do |s|
  s.name        = 'dan-ruby-sdk'
  s.version     = '0.0.3'
  s.summary     = 'DAN.com Ruby SDK'
  s.description = 'SDK for DAN.com API'
  s.authors     = ['Łukasz Potępa']
  s.email       = 'lukasz@dan.com'
  s.files       = Dir.glob('lib/**/*.rb')
  s.license = 'MIT'

  s.add_dependency('httparty', '~> 0.16')
end
