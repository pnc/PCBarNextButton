Pod::Spec.new do |s|
  s.name         = "PCBarNextButton"
  s.version      = "0.0.1"
  s.summary      = "A forward-pointing UIBarButtonItem subclass, for use in wizards."
  s.homepage     = "http://EXAMPLE/PCBarNextButton"
  s.license      = 'CC BY-SA 3.0'
  s.author       = { "Phil Calvin" => "phil@philcalvin.com" }
  s.source       = { :git => "https://github.com/pnc/PCBarNextButton.git", :branch => 'master' }
  s.platform     = :ios, '4.1'
  s.source_files = '*.{h,m}'
  s.resources    = "Resources/*.png"
  s.requires_arc = true
end
