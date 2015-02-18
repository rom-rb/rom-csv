require 'bundler'
Bundler.setup

require 'rom/csv'
require 'ostruct'

csv_file = ARGV[0] || File.expand_path("./users.csv", File.dirname(__FILE__))

setup = ROM.setup(:csv, csv_file)
setup.relation(:users) do
  def by_name(name)
    dataset.find_all { |row| row[:name] == name }
  end
end

class User < OpenStruct
end

setup.mappers do
  define(:users) do
    model User
  end
end

rom = setup.finalize
user = rom.read(:users).by_name('Jane').one
# => #<User id=2, name="Jane", email="jane@doe.org">

user or abort "user not found"
