require 'bundler'
Bundler.setup

require 'rom/csv'
require 'ostruct'

csv_file = ARGV[0] || File.expand_path("./users.csv", File.dirname(__FILE__))

ROM.use :auto_registration

setup = ROM.setup(:csv, csv_file)

setup.relation(:users) do
  def by_name(name)
    restrict(name: name)
  end
end

class User < OpenStruct
end

setup.mappers do
  define(:users) do
    register_as :entity
    model User
  end
end

rom = setup.finalize
user = rom.relation(:users).as(:entity).by_name('Jane').one
# => #<User id=2, name="Jane", email="jane@doe.org">

user or abort "user not found"
