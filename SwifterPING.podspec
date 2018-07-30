Pod::Spec.new do |s|
  s.name        = "SwifterPING"
  s.version     = "0.9.0"
  s.summary     = "A very simple swift interface to ping a hostname or address."
  s.homepage    = "https://github.com/rokgregoric/SwifterPING"
  s.license     = { :type => "MIT" }
  s.authors     = { "rokgregoric" => "rok.gregoric@gmail.com" }

  s.requires_arc = true
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source   = { :git => "https://github.com/rokgregoric/SwifterPING.git", :tag => s.version }
  s.source_files = "Source/*"
end