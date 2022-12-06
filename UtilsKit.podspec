Pod::Spec.new do |s|
  s.name = 'UtilsKit'
  s.version = '2.7'
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright 2012 - 2022 RGMC . All rights reserved.
      LICENSE
  }
  s.homepage = "https://github.com/rgmc95/UtilsKit"
  s.author = "Romain Gjura & Michael Coqueret & David Douard & Thibaud Lambert"
  s.summary = "Swift Utilities"
  s.swift_version = '5.4'
  s.source =  { :git => "https://github.com/rgmc95/UtilsKit.git", :tag => "2.7.0" }
  s.default_subspec = 'Core'

  s.ios.deployment_target = '12.0'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/**/*.{h,m,swift}'
  end
end

