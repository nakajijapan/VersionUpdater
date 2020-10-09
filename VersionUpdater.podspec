Pod::Spec.new do |s|
  s.name         = "VersionUpdater"
  s.version      = "1.1.0"
  s.summary      = "VersionUpdater inform users about new app version release, and can force users update the application to the version. "
  s.homepage     = "https://github.com/nakajijapan/VersionUpdater"
  s.license      = "MIT"
  s.author       = { "nakajijapan" => "pp.kupepo.gattyanmo@gmail.com" }
  s.source       = { :git => "https://github.com/nakajijapan/VersionUpdater.git", :tag => s.version.to_s }
  s.platform     = :ios, '10.0'
  s.source_files = 'Sources/Classes/**/*'
  s.resources    = 'VersionUpdater.bundle'
  s.swift_version = '5.2'
  s.requires_arc = true
end
