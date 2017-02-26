# encoding: utf-8

require 'bundler'
Bundler.require

if RUBY_ENGINE == 'ruby' && ENV['CI'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'rom'
require 'rom-csv'

SPEC_ROOT = root = Pathname(__FILE__).dirname

RSpec.configure do |config|
  config.before do
    module Test
    end
  end

  config.after do
    Object.send(:remove_const, :Test)
  end

  Dir[root.join('support/*.rb').to_s].each { |f| require f }
end
