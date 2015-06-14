require 'bundler'
Bundler.setup

require 'rom/csv'
require 'ostruct'

users_csv_file = File.expand_path("./users.csv", File.dirname(__FILE__))
addresses_csv_file = File.expand_path("./addresses.csv", File.dirname(__FILE__))

setup = ROM.setup(
  users: [:csv, users_csv_file],
  addresses: [:csv, addresses_csv_file]
)

setup.relation(:users) do
  gateway :users

  def by_name(name)
    restrict(name: name)
  end

  def only_name
    project(:name)
  end

  def ordered
    order(:name, :email)
  end

  def with_addresses
    join(addresses)
  end
end

setup.relation(:addresses) do
  gateway :addresses
end

class User < OpenStruct
end

class UserWithAddress < OpenStruct
end

class Address < OpenStruct
end

setup.mappers do
  define(:users) do
    model User
    register_as :entity
  end

  define(:users_with_address, parent: :users) do
    model UserWithAddress
    register_as :entity_with_address

    group :addresses do
      model Address

      attribute :address_id
      attribute :street
    end
  end
end

rom = setup.finalize
user = rom.relation(:users).as(:entity_with_address).with_addresses.first
# => #<UserWithAddress user_id=1, name="Julie", email="julie.andrews@example.com",
#       addresses=[#<Address address_id=1, street="Cleveland Street">]>

user or abort "user not found"
