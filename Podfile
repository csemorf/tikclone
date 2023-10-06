# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'TiktokClone' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TiktokClone
pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'FirebaseCore'
pod 'FirebaseStorage'
pod 'FirebaseAnalytics'
pod 'FirebaseDatabase'
pod 'ProgressHUD'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 11.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
end 
