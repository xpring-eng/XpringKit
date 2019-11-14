Pod::Spec.new do |spec|
  spec.name         = "XpringKit"
  spec.version      = "1.1.3"
  spec.summary      = "XpringKit provides a Swift based SDK for interacting with Xpring Platform (XRP/ILP)"

  spec.description  = "
    XpringKit provides a Swift based SDK for interacting with Xpring Platform (XRP/ILP)

    XpringKit is part of the Xpring SDK. To learn more, visit: http://github.com/xpring-eng/Xpring-SDK.
  "

  spec.homepage     = "http://xpring.io"
  spec.license      = "MIT"
  spec.author       = { "Xpring Engineering" => "xpring@ripple.com" }
  spec.source       = { :git => "https://github.com/xpring-eng/XpringKit.git", :tag => "1.1.3" }

  spec.swift_versions = [4.2]
  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'

  spec.prepare_command = "git submodule update --init --recursive && ./scripts/bundle_js.sh && ./scripts/regenerate_protos.sh"

  spec.source_files  = "XpringKit/**/*.swift"
  spec.resources =     [ "XpringKit/Resources/*" ]

  spec.dependency 'BigInt'
  spec.dependency 'SwiftGRPC'
  spec.dependency 'SwiftProtobuf'

  spec.test_spec "Tests" do |test_spec|
    test_spec.source_files = ["Tests/**/*.swift"]
  end
end
