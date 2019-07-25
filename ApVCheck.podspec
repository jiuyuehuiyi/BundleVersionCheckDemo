
Pod::Spec.new do |spec|

  spec.name         = "ApVCheck"
  spec.version      = "0.0.5"
  spec.summary      = "A version check api for App has submited to appstore."
  spec.description  = <<-DESC
A version check api for App has submited to appstore. have fun!
                   DESC

  spec.homepage     = "https://github.com/jiuyuehuiyi/BundleVersionCheckDemo"

  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "踏歌长行" => "1031484446@qq.com" }

  spec.ios.deployment_target = '8.0'
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  spec.requires_arc = true

  spec.source       = { :git => "https://github.com/jiuyuehuiyi/BundleVersionCheckDemo.git", :tag => "#{spec.version}" }
  spec.source_files  = "BundleVersionCheckDemo/Service", "BundleVersionCheckDemo/Model"

  spec.dependency 'HandyJSON', '~> 5.0.0-beta1'
  spec.dependency 'Moya/RxSwift','~> 13.0'
  spec.dependency 'RxCocoa'
  spec.dependency 'YYKit'

end
