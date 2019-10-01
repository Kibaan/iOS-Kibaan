Pod::Spec.new do |s|
  s.name             = 'Kibaan'
  s.version          = '0.8.08'
  s.summary          = 'Core classes for transplanting iOS app to Android app easily.'
  s.homepage         = 'https://github.com/Kibaan/iOS-Kibaan'
  s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.author           = { 'altonotes' => 'kibaan@altonotes.co.jp' }
  s.source           = { :git => 'https://github.com/Kibaan/iOS-Kibaan.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'
  s.source_files = 'Kibaan/Kibaan/**/*.{swift,xib}'
end
