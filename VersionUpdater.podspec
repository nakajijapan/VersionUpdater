Pod::Spec.new do |s|
  s.name         = "VersionUpdater"
  s.version      = "2.0.0"
  s.summary      = "Inform users about new app version releases and optionally force updates."
  s.homepage     = "https://github.com/nakajijapan/VersionUpdater"
  s.license      = "MIT"
  s.author       = { "nakajijapan" => "pp.kupepo.gattyanmo@gmail.com" }
  s.source       = { :git => "https://github.com/nakajijapan/VersionUpdater.git", :tag => s.version.to_s }
  s.platform     = :ios, '15.0'
  s.source_files = 'Sources/Classes/**/*.swift'
  s.resources    = 'Sources/Classes/Resources/**/*'
  s.swift_version = '5.9'
  s.requires_arc = true
end
