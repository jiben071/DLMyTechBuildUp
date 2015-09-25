Pod::Spec.new do |s|
  s.name             = "DLMyTechBuildUp"
  s.version          = "1.0.0"
  s.summary          = "My tech build up on iOS."
  s.description      = <<-DESC
                       It is a general tech used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/jiben071/DLMyTechBuildUp"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Deng Long" => "1805549289@qq.com" }
  s.source           = { :git => "https://github.com/jiben071/DLMyTechBuildUp.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'

  s.platform     = :ios, '7.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'GenTechBuildUp/*'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end
