#
#  Be sure to run `pod spec lint HePaiPay.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LLRoute"
  s.version      = "1.0.0"
  s.summary      = "路径跳转 传值  工程内跳转 多个子工程之间调整 --李龙"
  s.description  = <<-DESC
		   use for LLRoute module.
		   It’s awesome!!
                   DESC

  s.homepage     = "https://github.com/LiGuanWen/LLRoute"
  s.license      = "MIT"
  s.author       = { "Lilong" => "diqidaimu@qq.com" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LiGuanWen/LLRoute.git", :tag => s.version}
  s.source_files = "LLRouteClass/**/*.{h,m}"

end
