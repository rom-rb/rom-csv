require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
task default: [:spec, :rubocop]

RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end
