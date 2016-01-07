# encoding: utf-8

require 'bundler'
Bundler.require

if RUBY_ENGINE == 'rbx'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'rom'
require 'rom-csv'

root = Pathname(__FILE__).dirname

Dir[root.join('support/*.rb').to_s].each { |f| require f }
