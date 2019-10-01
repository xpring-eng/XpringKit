Pod::Spec.new do |spec|
  spec.name         = "XpringKit"
  spec.version      = "1.0.3"
  spec.summary      = "XpringKit provides a Swift based SDK for interacting with Xpring Platform (XRP/ILP)"

  spec.description  = "XpringKit provides a Swift based SDK for interacting with Xpring Platform (XRP/ILP)"

  spec.homepage     = "http://xpring.io"
  spec.license      = "MIT"
  spec.author       = { "Xpring Engineering" => "xpring@ripple.com" }
  spec.source       = { :git => "https://github.com/xpring-eng/XpringKit.git", :tag => "1.0.3" }

  spec.swift_versions = [4.2]
  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'

  spec.source_files  = "XpringKit/**/*.swift"
  spec.resources = "XpringKit/Resources/*"

  spec.dependency 'SwiftGRPC'
  spec.dependency 'SwiftProtobuf'

  spec.test_spec "Tests" do |test_spec|
    test_spec.source_files = ["Tests/**/*.swift"]
  end
end
