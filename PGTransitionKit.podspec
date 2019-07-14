#
# Be sure to run `pod lib lint PGTransitionKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PGTransitionKit'
  s.version          = '0.1.2'
  s.summary          = 'Percetage Present Transition Animation Module.'
  s.description      = 'Percetage Present Transition Animation Module with Animator/Interactor.'
  s.homepage         = 'https://github.com/ipagong/PGTransitionKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ipagong' => 'ipagong.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/ipagong/PGTransitionKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'

  s.source_files = 'PGTransitionKit/Classes/**/*'
  s.frameworks = 'UIKit'
  
end
