
root    = File.expand_path('../../', __FILE__)
version = File.read("#{root}/RUBY_COMMONS_VERSION").strip
tag     = "v#{version}"

directory 'pkg'

PROJECTS.each do |project|
  namespace project do
    gem_name = "#{project}-#{version}.gem".tr('_','-')
    gem_path = "pkg/#{gem_name}"
    gem_spec = "#{project}.gemspec"

    task :clean do
      rm_f gem_path
    end

    task :update_versions do
      glob =  root.dup
      glob << "/#{project}/lib/*/*/gem_version.rb"

      file = Dir[glob].first
      ruby = File.read(file)

      major, minor, tiny, pre = version.split('.')
      pre = pre ? pre.inspect : 'nil'

      ruby.gsub!(/^(\s*)MAJOR(\s*)= .*?$/, "\\1MAJOR = #{major}")
      raise "Could not insert MAJOR in #{file}" unless $1

      ruby.gsub!(/^(\s*)MINOR(\s*)= .*?$/, "\\1MINOR = #{minor}")
      raise "Could not insert MINOR in #{file}" unless $1

      ruby.gsub!(/^(\s*)TINY(\s*)= .*?$/, "\\1TINY  = #{tiny}")
      raise "Could not insert TINY in #{file}" unless $1

      ruby.gsub!(/^(\s*)PRE(\s*)= .*?$/, "\\1PRE   = #{pre}")
      raise "Could not insert PRE in #{file}" unless $1

      File.open(file, 'w') { |f| f.write ruby }
    end

    task gem_path => %w(update_versions pkg) do
      sh "cd #{project} && gem build #{gem_spec} && mv #{gem_name} #{root}/pkg/"
    end

    task :build => [:clean, gem_path]

    task :install => :build do
      sh "gem install #{gem_path}"
    end

    task :push => :build do
      sh "gem push #{gem_path}"
    end
  end
end

namespace :all do
  task :build           => PROJECTS.map { |f| "#{f}:build"           }
  task :update_versions => PROJECTS.map { |f| "#{f}:update_versions" }
  task :install         => PROJECTS.map { |f| "#{f}:install"         }
  task :push            => PROJECTS.map { |f| "#{f}:push"            }

  task :ensure_clean_state do
    unless `git status -s | grep -v RUBY_COMMONS_VERSION`.strip.empty?
      abort "[ABORTING] `git status` reports a dirty tree. Make sure all changes are committed"
    end

    unless ENV['SKIP_TAG'] || `git tag | grep '^#{tag}$'`.strip.empty?
      abort "[ABORTING] `git tag` shows that [#{tag}] already exists. Has this version already\n" \
            "           been released? Git tagging can be skipped by setting SKIP_TAG=1"
    end
  end

  task :commit do
    File.open('pkg/commit_message.txt', 'w') do |f|
      f.puts "# Preparing for [#{tag}] release.\n"
      f.puts
      f.puts "# UNCOMMENT THE LINE ABOVE TO APPROVE THIS COMMIT"
    end

    sh "git add . && git commit --verbose --template=pkg/commit_message.txt"
    rm_f "pkg/commit_message.txt"
  end

  task :tag do
    sh "git tag -m '#{tag} release' #{tag}"
    sh "git push --tags"
  end

  task :release => %w(ensure_clean_state build commit tag push)
end
