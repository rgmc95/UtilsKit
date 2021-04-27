Pod::Spec.new do |s|
  s.name = 'UtilsKit'
  s.version = '2.0.8'
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright 2012 - 2019 RGMC . All rights reserved.
      LICENSE
  }
  s.homepage = "https://github.com/rgmc95/UtilsKit"
  s.author = "Romain Gjura & Michael Coqueret & David Douard"
  s.summary = "Swift Utilities"
  s.swift_version = '5.3'
  s.source =  { :git => "https://github.com/rgmc95/UtilsKit.git", :tag => "2.0.8" }
  s.default_subspec = 'Core'

  s.ios.deployment_target = '10.0'

  s.subspec 'Core' do |core|
    core.source_files = 'UtilsKit/Helpers/**/*.{h,m,swift}',  'UtilsKit/UI/**/*.{h,m,swift}'
  end

  s.subspec 'CoreExtension' do |ext|
    ext.dependency "UtilsKit/Core"
    ext.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'APP_EXTENSION' }
  end

end

