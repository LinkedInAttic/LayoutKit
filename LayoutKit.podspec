Pod::Spec.new do |spec|
  spec.name             = 'LayoutKit'
  spec.version          = '0.3.0'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://linkedin.github.io/LayoutKit'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'TODO'
  spec.source           = { :git => 'https://github.com/linkedin/LayoutKit.git', :tag => spec.version }
  spec.source_files     = '*'
  spec.platform         = :ios, '8.0'
  spec.frameworks       = 'Foundation', 'UIKit'
end

