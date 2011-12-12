# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-googlevoice"
  s.version     = "1.0" 
  s.authors     = ["ian_mcdowell"]
  s.email       = ["mcdow.ian@gmail.com"]
  s.homepage    = ["www.ianmcdowell.net"]
  s.summary     = %q{Siri Google Voice Plugin}
  s.description = %q{This plugin allows you to send Google Voice SMS messages using Siri. }

  s.rubyforge_project = "siriproxy-googlevoice"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
