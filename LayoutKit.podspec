Pod::Spec.new do |spec|
  spec.name             = 'LayoutKit'
  spec.version          = '1.1.0'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://linkedin.github.io/LayoutKit'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'LayoutKit is a fast view layout library for iOS.'
  spec.source           = { :git => 'https://github.com/linkedin/LayoutKit.git', :tag => spec.version }
  spec.source_files     = 'LayoutKit/**/*.swift'

  spec.ios.deployment_target = '8.0'
  spec.ios.frameworks        = 'Foundation', 'CoreGraphics', 'UIKit'
  spec.ios.exclude_files     = 'LayoutKit/AppKitSupport.swift'

  spec.osx.deployment_target = '10.9'
  spec.osx.frameworks        = 'Foundation', 'CoreGraphics', 'AppKit'
  spec.osx.exclude_files     = 'LayoutKit/UIKitSupport.swift', 'LayoutKit/Layouts/LabelLayout.Swift', 'LayoutKit/Views/**'
end

