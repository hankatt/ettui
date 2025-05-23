# -*- encoding: utf-8 -*-
# stub: fastclick-rails 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "fastclick-rails"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Masaki Komagata"]
  s.date = "2014-04-13"
  s.description = "gem for fastclick.js"
  s.email = ["komagata@gmail.com"]
  s.homepage = "https://github.com/komagata/fastclick-rails"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "gem for fastclick.js"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
  end
end
