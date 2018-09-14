#
# Be sure to run `pod lib lint MMGraphView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MMGraphView'
  s.version          = '1.0.0'
  s.summary          = 'Render Graph on screen using Bezier Path and Bezier Curve'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Simple component to have a graph rendered on screen using bezier path and bezier curve.'

  s.homepage         = 'https://github.com/MuthurajMuthulingam/MMGraphView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muthuraj Muthulingam' => 'muthurajmuthulingam@gmail.com' }
  s.source           = { :git => 'https://github.com/MuthurajMuthulingam/MMGraphView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'MMGraphView/Classes/**/*'
  s.swift_version = '4.1'
  
  # s.resource_bundles = {
  #   'MMGraphView' => ['MMGraphView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
