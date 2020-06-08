Pod::Spec.new do |spec|
  spec.name         = "XpringKit"
  spec.version      = "3.2.0"
  spec.summary      = "XpringKit provides a Swift based SDK for interacting with Xpring Platform (XRP/ILP)"

  spec.description  = "
    XpringKit provides a Swift based SDK for interacting with Xpring Platform (XRP/ILP)

    XpringKit is part of the Xpring SDK. To learn more, visit: http://github.com/xpring-eng/Xpring-SDK.
  "

  spec.homepage     = "http://xpring.io"
  spec.license      = "MIT"
  spec.author       = { "Xpring Engineering" => "xpring@ripple.com" }
  spec.source       = { :git => "https://github.com/xpring-eng/XpringKit.git", :tag => "v3.2.0" }

  spec.swift_versions = [5.1]
  spec.requires_arc = true
  spec.ios.deployment_target = '12.0'
  spec.osx.deployment_target = '10.10'

  spec.source_files  = "XpringKit/**/*.swift"
  spec.resources =     [ "XpringKit/Common/Resources/*" ]

  spec.dependency 'Alamofire', '~> 4.9.0'
  spec.dependency 'BigInt', '~> 5.0.0'
  spec.dependency 'SwiftGRPC', '~> 0.9.1'
  spec.dependency 'SwiftProtobuf', '~> 1.5.0'

  spec.frameworks = "Foundation"

  spec.test_spec "Tests" do |test_spec|
    test_spec.source_files = ["Tests/**/*.swift"]

    test_spec.dependency 'BigInt', '~> 5.0.0'

    test_spec.frameworks = "Foundation"
  end
end
