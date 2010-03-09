# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sbdb}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Denis Knauf"]
  s.date = %q{2010-03-09}
  s.description = %q{Simple Ruby Berkeley DB wrapper library for bdb.}
  s.email = %q{Denis.Knauf@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    "README.md",
     "VERSION",
     "lib/sbdb.rb",
     "lib/sbdb/cursor.rb",
     "lib/sbdb/db.rb",
     "lib/sbdb/environment.rb",
     "lib/sbdb/transaction.rb",
     "lib/sbdb/weakhash.rb"
  ]
  s.homepage = %q{http://github.com/DenisKnauf/bdb}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Simple Ruby Berkeley DB}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bdb>, [">= 0"])
    else
      s.add_dependency(%q<bdb>, [">= 0"])
    end
  else
    s.add_dependency(%q<bdb>, [">= 0"])
  end
end

