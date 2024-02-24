# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'IMDb' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SnapKit', '~> 5.0.0'
  pod 'Kingfisher', '7.6.1'
  pod 'Moya', '14.0.0'
  pod 'Alamofire', '5.6.2'


post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['VALID_ARCHS'] = 'arm64, arm64e, x86_64'
  end
end

end
