Pod::Spec.new do |spec|
  spec.name              = 'LayoutKitObjC'
  spec.version           = '10.1.0'
  spec.license           = { :type => 'Apache License, Version 2.0' }
  spec.homepage          = 'http://layoutkit.org'
  spec.authors           = 'LinkedIn'
  spec.summary           = 'LayoutKit is a fast view layout library for iOS, macOS, and tvOS. Now with Objective-C support.'
  spec.source            = { :git => 'https://github.com/linkedin/LayoutKit.git', :tag => spec.version }
  spec.source_files      = 'Sources/**/*.{swift,h,m}'
  spec.documentation_url = 'http://layoutkit.org'

  spec.ios.deployment_target = '8.0'
  spec.ios.frameworks        = 'Foundation', 'CoreGraphics', 'UIKit'
  spec.ios.exclude_files     = 'Sources/AppKitSupport.swift'

  spec.osx.deployment_target = '10.9'
  spec.osx.frameworks        = 'Foundation', 'CoreGraphics', 'AppKit'
  spec.osx.exclude_files     = [
    'Sources/Internal/CGFloatExtension.swift',
    'Sources/Internal/TextViewDefaultFont.swift',
    'Sources/Internal/NSAttributedStringExtension.swift',
    'Sources/Layouts/ButtonLayout.swift',
    'Sources/Layouts/LabelLayout.swift',
    'Sources/Layouts/TextViewLayout.swift',
    'Sources/ObjCSupport/Builders/LOKButtonLayoutBuilder.*',
    'Sources/ObjCSupport/Builders/LOKLabelLayoutBuilder.*',
    'Sources/ObjCSupport/Builders/LOKTextViewLayoutBuilder.*',
    'Sources/ObjCSupport/LOKBatchUpdates.swift',
    'Sources/ObjCSupport/LOKButtonLayout.swift',
    'Sources/ObjCSupport/LOKButtonLayoutType.swift',
    'Sources/ObjCSupport/LOKLabelLayout.swift',
    'Sources/ObjCSupport/LOKLayoutArrangementSection.swift',
    'Sources/ObjCSupport/LOKLayoutSection.swift',
    'Sources/ObjCSupport/LOKReloadableViewLayoutAdapter.swift',
    'Sources/ObjCSupport/LOKTextViewLayout.swift',
    'Sources/Text.swift',
    'Sources/UIKitSupport.swift',
    'Sources/Views/**'
  ]

  spec.tvos.deployment_target = '9.0'
  spec.tvos.frameworks        = 'Foundation', 'CoreGraphics', 'UIKit'
  spec.tvos.exclude_files     = [
    'Sources/AppKitSupport.swift',

    # Excluded due to "'systemFontSize' is unavailable"
    'Sources/ObjCSupport/Builders/LOKLabelLayoutBuilder.*',
    'Sources/ObjCSupport/LOKLabelLayout.swift' 
  ]

end

