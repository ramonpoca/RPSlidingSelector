#
# Be sure to run `pod lib lint RPSlidingSelector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RPSlidingSelector'
  s.version          = '0.1.0'
  s.summary          = 'A horizontal sliding button selector'

  s.description      = <<-DESC
        A horizontal scrollview that you can fill with buttons and auto-centers the selected button, allowing to scroll too.
                       DESC

  s.homepage         = 'https://github.com/ramonpoca/RPSlidingSelector'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ramon.poca@gmail.com' => 'ramon.poca@gmail.com' }
  s.source           = { :git => 'https://github.com/ramonpoca/RPSlidingSelector.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RPSlidingSelector/Classes/**/*'
  
end
