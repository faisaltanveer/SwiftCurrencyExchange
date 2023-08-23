# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'SwiftCurrencyExchange' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire', '~> 4.9'
  pod 'SwiftyJSON'
  pod 'MBProgressHUD'
  pod 'IQKeyboardManagerSwift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
