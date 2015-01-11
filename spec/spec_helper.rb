# encoding: utf-8

require 'bundler'
Bundler.require

if RUBY_ENGINE == "rbx"
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

RSpec.configure do |config|
  config.expect_with :rspec, :minitest
end

require "rom-csv"

root = Pathname(__FILE__).dirname

Dir[root.join("shared/*.rb").to_s].each { |f| require f }
