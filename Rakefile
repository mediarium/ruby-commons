PROJECTS ||= %w( ruby-commons ) # Add all projects

$:.unshift File.expand_path('..', __FILE__)
require 'bundler'
require 'tasks/release'

desc 'Run all tests by default.'
task :default => :test

%w(test package gem).each do |task_name|
  desc "Run ‘#{task_name}’ task for all projects."
  task task_name do
    errors = []
    PROJECTS.each do |project|
      system("cd #{project} && #{$0} #{task_name}") || errors << project
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end
end

desc 'Bump all versions to match RUBY_COMMONS_VERSION.'
task :update_versions => 'all:update_versions'

desc 'Build gem files for all projects.'
task :build => 'all:build'

desc 'Install gems for all projects.'
task :install => 'all:install'

desc 'Clean the whole repository by removing all the generated files.'
task :clear => :clean
task :clean do
  puts 'Deleting pkg directory...'
  FileUtils.rm_rf('pkg')
end

desc 'Release all gems to RubyGems and create a tag.'
task :release => 'all:release'
