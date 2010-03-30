# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bersalis}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Asa Calow"]
  s.date = %q{2010-03-30}
  s.email = %q{mothership@asacalow.co.uk}
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "test", "lib/bersalis", "lib/bersalis/basics.rb", "lib/bersalis/client.rb", "lib/bersalis/connection.rb", "lib/bersalis/document.rb", "lib/bersalis/node.rb", "lib/bersalis/stanzas", "lib/bersalis/stanzas/auth.rb", "lib/bersalis/stanzas/base", "lib/bersalis/stanzas/base/read_only_stanza.rb", "lib/bersalis/stanzas/base/stanza.rb", "lib/bersalis/stanzas/core.rb", "lib/bersalis/stanzas/disco.rb", "lib/bersalis/stanzas/roster.rb", "lib/bersalis/stanzas/session.rb", "lib/bersalis.rb"]
  s.homepage = %q{http://github.com/asacalow/bersalis}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
