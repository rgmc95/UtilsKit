Pod::Spec.new do |s|
  s.name = 'UtilsKit'
  s.version = '4.1'
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright 2012 - 2025 RGMC . All rights reserved.
      LICENSE
  }
  s.homepage = "https://github.com/rgmc95/UtilsKit"
  s.author = "Romain Gjura & Michael Coqueret & David Douard & Thibaud Lambert"
  s.summary = "Swift Utilities"
  s.swift_version = '6.0'
  s.source =  { :git => "https://github.com/rgmc95/UtilsKit.git", :tag => "4.1.0" }
  s.default_subspec = 'UtilsKitUI'

  s.ios.deployment_target = '14.0'

  s.subspec 'UtilsKitCore' do |core|
    core.source_files = 'Sources/UtilsKitCore/**/*.{h,m,swift}'
  end

  s.subspec 'UtilsKitHelpers' do |core|
    core.dependency 'UtilsKit/UtilsKitCore'
    core.source_files = 'Sources/UtilsKitHelpers/**/*.{h,m,swift}'
  end

  s.subspec 'UtilsKitUI' do |core|
    core.dependency 'UtilsKit/UtilsKitHelpers'
    core.source_files = 'Sources/UtilsKitUI/**/*.{h,m,swift}'
  end
end