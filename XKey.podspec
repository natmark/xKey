Pod::Spec.new do |s|
  s.name         = "xKey"
  s.version      = "0.0.1"
  s.summary      = "Cocoa Key Handler Extension."
  s.description  = <<-DESC
  xKey is a Cocoa key handler extension for OSX written in Swift 🐧
                   DESC
  s.homepage     = "https://github.com/natmark/xKey"
  s.screenshots  = "https://github.com/natmark/xKey/raw/master/Resources/xKey-example.gif?raw=true"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "natmark" => "natmark0918@gmail.com" }
  s.platform     = :osx
  s.source       = { :git => "https://github.com/natmark/xKey.git", :tag => "#{s.version}" }
  s.source_files  = "XKey/**/*.swift"
end
