Pod::Spec.new do |spec|
  spec.name              = 'LayoutKit'
  spec.version           = '10.1.0'
  spec.license           = { :type => 'Apache License, Version 2.0' }
  spec.homepage          = 'http://layoutkit.org'
  spec.authors           = 'LinkedIn'
  spec.summary           = 'LayoutKit is a fast view layout library for iOS, macOS, and tvOS.'
  spec.source            = { :git => 'https://github.com/linkedin/LayoutKit.git', :tag => spec.version }
  spec.source_files      = 'Sources/**/*.swift'
  spec.documentation_url = 'http://layoutkit.org'

  spec.ios.deployment_target = '8.0'
  spec.ios.frameworks        = 'Foundation', 'CoreGraphics', 'UIKit'
  spec.ios.exclude_files     = [
    'Sources/AppKitSupport.swift',
    'Sources/ObjCSupport/**',
    'Sources/ObjCSupport/Internal/**'
  ]

  spec.osx.deployment_target = '10.9'
  spec.osx.frameworks        = 'Foundation', 'CoreGraphics', 'AppKit'
  spec.osx.exclude_files     = [
    'Sources/Internal/CGFloatExtension.swift',
    'Sources/Internal/TextViewDefaultFont.swift',
    'Sources/Internal/NSAttributedStringExtension.swift',
    'Sources/Layouts/ButtonLayout.swift',
    'Sources/Layouts/LabelLayout.swift',
    'Sources/Layouts/TextViewLayout.swift',
    'Sources/ObjCSupport/**',
    'Sources/ObjCSupport/Internal/**',
    'Sources/Text.swift',
    'Sources/UIKitSupport.swift',
    'Sources/Views/**'
  ]

  spec.tvos.deployment_target = '9.0'
  spec.tvos.frameworks        = 'Foundation', 'CoreGraphics', 'UIKit'
  spec.tvos.exclude_files     = [
    'Sources/AppKitSupport.swift',
    'Sources/ObjCSupport/**',
    'Sources/ObjCSupport/Internal/**'
  ]

end

