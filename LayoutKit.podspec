Pod::Spec.new do |spec|
  spec.name             = 'LayoutKit'
  spec.version          = '1.0.0'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://linkedin.github.io/LayoutKit'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'LayoutKit is a fast view layout library for iOS.'
  spec.source           = { :git => 'https://github.com/linkedin/LayoutKit.git', :tag => spec.version }
  spec.source_files     = 'LayoutKit/**/*.swift'
  spec.platform         = :ios, '8.0'
  spec.frameworks       = 'Foundation', 'UIKit'
end

