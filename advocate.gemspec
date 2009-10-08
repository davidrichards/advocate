# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{advocate}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Richards"]
  s.date = %q{2009-10-08}
  s.default_executable = %q{advocate}
  s.description = %q{A generic recomendation tool using correlation matrices to generate k nearest neighbors.}
  s.email = %q{davidlamontrichards@gmail.com}
  s.executables = ["advocate"]
  s.files = ["README.rdoc", "VERSION.yml", "bin/advocate", "lib/advocate", "lib/advocate/correlation_matrix.rb", "lib/advocate/ext", "lib/advocate/ext/array.rb", "lib/advocate/include_recommender.rb", "lib/advocate/items.rb", "lib/advocate.rb", "spec/advocate", "spec/advocate/correlation_matrix_spec.rb", "spec/advocate/ext", "spec/advocate/ext/array_spec.rb", "spec/advocate/items_spec.rb", "spec/advocate_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/davidrichards/advocate}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A generic recomendation tool using correlation matrices to generate k nearest neighbors.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<facets>, [">= 0"])
      s.add_runtime_dependency(%q<davidrichards-just_enumerable_stats>, [">= 0"])
      s.add_runtime_dependency(%q<davidrichards-data_frame>, [">= 0"])
    else
      s.add_dependency(%q<facets>, [">= 0"])
      s.add_dependency(%q<davidrichards-just_enumerable_stats>, [">= 0"])
      s.add_dependency(%q<davidrichards-data_frame>, [">= 0"])
    end
  else
    s.add_dependency(%q<facets>, [">= 0"])
    s.add_dependency(%q<davidrichards-just_enumerable_stats>, [">= 0"])
    s.add_dependency(%q<davidrichards-data_frame>, [">= 0"])
  end
end
