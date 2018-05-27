if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.4.0' && ENV['CI'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'rom-csv'

begin
  require 'byebug'
rescue LoadError
end

module Test
  def self.remove_constants
    constants.each(&method(:remove_const))
  end
end

RSpec.configure do |config|
  config.after do
    Test.remove_constants
  end

  config.disable_monkey_patching!
end
