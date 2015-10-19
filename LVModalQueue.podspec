#
# Be sure to run `pod lib lint LVModalQueue.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = "LVModalQueue"
  s.version          = "0.1.0"
  s.license          = { :type => 'BSD' }
  s.summary          = "Queue presentViewController: and dismissViewController: when called multiple times"
  s.description      = <<-DESC
This fixes 'NSInternalInconsistencyException's when presentViewController: and dismissViewController: are called, while a transition is already in progress.
Transitions are queued for later execution.
                       DESC
  s.homepage         = "https://github.com/Lovoo/LVModalQueue"
  s.author           = { "Michael Berg" => "berg.micha@icloud.com" }
  s.source           = { :git => "https://github.com/Lovoo/LVModalQueue.git", :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
