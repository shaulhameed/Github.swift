Pod::Spec.new do |s|
  s.name             = "GithubSwift"
  s.summary          = "A short description of GithubSwift."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/onmyway133/GithubSwift"
  s.license          = 'MIT'
  s.author           = { "Khoa Pham" => "onmyway133@gmail.com" }
  s.source           = {
    :git => "https://github.com/onmyway133/GithubSwift.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/onmyway133'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.requires_arc = true
  s.ios.source_files = 'Sources/**/*'
  s.osx.source_files = 'Sources/**/*'

  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.osx.frameworks = 'Cocoa', 'Foundation'

  s.dependency 'Tailor', '~> 0.7'
  s.dependency 'RxSwift', '~> 2.4'
  s.dependency 'Alamofire', '~> 3.3'
  s.dependency 'ISO8601', '~> 0.5'

end
