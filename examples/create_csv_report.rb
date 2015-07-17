require 'bundler'
Bundler.setup

require 'rom/csv'
require 'ostruct'

csv_file = File.expand_path("./report.csv", File.dirname(__FILE__))

FileUtils.touch(csv_file)
setup = ROM.setup(:csv, csv_file)

setup.relation(:users)

class User < OpenStruct
end

setup.mappers do
  define(:users) do
    register_as :entity
    model User
  end
end

setup.commands(:users) do
  define(:create) do
    result :one
  end
end

rom = setup.finalize

rom.commands.users.try do
  rom.commands.users.create.call(id: 1, name: 'John', email: 'john@doe.org')
end

data = rom.relation(:users).as(:entity).to_a
# => [#<User id=1, name="John", email="john@doe.org">]

data
