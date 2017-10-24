require 'bundler'
Bundler.setup

require 'rom/csv'
require 'ostruct'

csv_file = ARGV[0] || File.expand_path("./users.csv", File.dirname(__FILE__))

configuration = ROM::Configuration.new(:csv, csv_file)

configuration.relation(:users) do
  def by_name(name)
    restrict(name: name)
  end
end

class User < OpenStruct
end

configuration.mappers do
  define(:users) do
    register_as :entity
    model User
  end
end

container = ROM.container(configuration)

user = container.relation(:users).as(:entity).by_name('Jane').one
# => #<User id=2, name="Jane", email="jane@doe.org">

user or abort "user not found"
