#
#  Be sure to run `pod spec lint Inchworm.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "Inchworm"
  s.version      = "0.1"
  s.summary      = "A swift slider-style value adjusting tool"

  s.description  = <<-DESC
        A swift value adjusting tool which mimics the slider to set value in Photo.app in iOS 13
                   DESC

  s.homepage     = "https://github.com/guoyingtao/Inchworm"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Yingtao Guo" => "guoyingtao@outlook.com" }
  s.social_media_url   = "http://twitter.com/guoyingtao"
  s.platform     = :ios
  s.swift_version = "5.0"
  s.ios.deployment_target = "11.0"
  s.source       = { :git => "https://github.com/guoyingtao/Inchworm.git", :tag => "#{s.version}" }
  s.source_files  = "Inchworm/**/*.{h,swift}"
  #s.exclude_files = "Inchworm/**/Info.plist"
  
  #  s.info_plist = {
  #   "CFBundleIdentifier" => "com.echo.framework.Inchworm"
  #}

end

