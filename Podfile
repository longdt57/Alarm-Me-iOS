platform :ios, '15.0'
use_frameworks!
inhibit_all_warnings!

def testing_pods
  pod 'Sourcery'
  pod 'SwiftFormat/CLI'
  pod 'OHHTTPStubs/Swift', :configurations => ['Debug Staging', 'Debug Production']
end

target 'iOSApp' do
  # UI
  pod 'Kingfisher'

  # Backend
  pod 'Alamofire'
  
  # DI
  pod 'Resolver'
  
  # Toast
  pod 'AlertToast'

  # Storage
  pod 'KeychainAccess'

  # Tools
  pod 'Firebase/Crashlytics'
  pod 'R.swift'
  pod 'Factory'

  # Development
  pod 'SwiftLint'
  pod 'Wormholy', :configurations => ['Debug Staging', 'Debug Production']
  pod 'xcbeautify'

  target 'iOSAppTests' do
    inherit! :search_paths
    testing_pods
  end

  target 'iOSAppKIFUITests' do
    testing_pods
    pod 'KIF', :configurations => ['Debug Staging', 'Debug Production']
    pod 'KIF/IdentifierTests', :configurations => ['Debug Staging', 'Debug Production']
  end
end

target 'DesignSystem' do
  # Toast
  pod 'AlertToast'
  pod 'R.swift'
  pod 'Alamofire'
  
  target 'DesignSystemTests' do
    testing_pods
  end
end

def data_dependencies
  pod 'Alamofire'
  pod 'RealmSwift'
end

target 'Data' do
  data_dependencies

  target 'DataTests' do
    data_dependencies
    testing_pods
  end
end

target 'GitUserSample' do
  data_dependencies
  pod 'R.swift'
  pod 'Resolver'

  target 'GitUserSampleTests' do
    inherit! :search_paths
    testing_pods
    pod 'AlertToast'
    pod 'R.swift'
    pod 'Resolver'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
    end
  end
end
