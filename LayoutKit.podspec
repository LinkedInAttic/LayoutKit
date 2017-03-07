Pod::Spec.new do |spec|
  spec.name             = 'LayoutKit'
  spec.version          = '4.0.1'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'http://layoutkit.org'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'LayoutKit is a fast view layout library for iOS, macOS, and tvOS.'
  spec.source           = { :git => 'https://github.com/linkedin/LayoutKit.git', :tag => spec.version }
  spec.source_files     = 'LayoutKit/**/*.swift'

  spec.ios.deployment_target = '8.0'
  spec.ios.frameworks        = 'Foundation', 'CoreGraphics', 'UIKit'
  spec.ios.exclude_files     = 'LayoutKit/AppKitSupport.swift'

  spec.osx.deployment_target = '10.9'
  spec.osx.frameworks        = 'Foundation', 'CoreGraphics', 'AppKit'
  spec.osx.exclude_files     = [
    'LayoutKit/Internal/CGFloatExtension.swift',
    'LayoutKit/Internal/TextViewDefaultFont.swift',
    'LayoutKit/Internal/NSAttributedStringExtension.swift',
    'LayoutKit/Layouts/ButtonLayout.swift',
    'LayoutKit/Layouts/LabelLayout.swift',
    'LayoutKit/Layouts/TextViewLayout.swift',
    'LayoutKit/Text.swift',
    'LayoutKit/UIKitSupport.swift',
    'LayoutKit/Views/**'
  ]

  spec.tvos.deployment_target = '9.0'
  spec.tvos.frameworks        = 'Foundation', 'CoreGraphics', 'UIKit'
  spec.tvos.exclude_files     = 'LayoutKit/AppKitSupport.swift'

end

