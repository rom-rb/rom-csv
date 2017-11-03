require 'spec_helper'
require 'virtus'

describe 'CSV gateway' do
  before { skip }
  context 'without extra options' do
    include_context 'database setup'

    before do
      configuration.relation(:users) do
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

      configuration.relation(:addresses) do
        gateway :addresses
      end

      class User
        include Virtus.model

        attribute :user_id, Integer
        attribute :name, String
        attribute :email, String
      end

      class UserWithAddress
        include Virtus.model

        attribute :user_id, Integer
        attribute :name, String
        attribute :email, String
        attribute :addresses
      end

      class Address
        include Virtus.model

        attribute :address_id, Integer
        attribute :street, String
      end

      configuration.mappers do
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
    end

    describe 'env#relation' do
      it 'returns restricted and mapped object' do
        jane = container.relation(:users).as(:entity).by_name('Jane').to_a.first

        expect(jane.name).to eql('Jane')
        expect(jane.email).to eql('jane@doe.org')
      end

      it 'returns specified attributes in mapped object' do
        jane = container.relation(:users).as(:entity).only_name.to_a.first

        expect(jane.user_id).to be_nil
        expect(jane.name).not_to be_nil
        expect(jane.email).to be_nil
      end

      it 'return ordered attributes by name and email' do
        results = container.relation(:users).as(:entity).ordered.to_a

        expect(results[0].name).to eql('Jane')
        expect(results[0].email).to eq('jane@doe.org')

        expect(results[1].name).to eql('Julie')
        expect(results[1].email).to eq('julie.andrews@example.com')

        expect(results[2].name).to eql('Julie')
        expect(results[2].email).to eq('julie@doe.org')
      end

      it 'returns joined data' do
        results = container.relation(:users).as(:entity_with_address)
                  .with_addresses.first

        expect(results.attributes.keys.sort)
          .to eq([:user_id, :name, :email, :addresses].sort)

        expect(results.addresses.first.attributes.keys.sort)
          .to eq([:address_id, :street].sort)
      end
    end

    context 'with custom options' do
      before do
        configuration.relation(:users_utf8) do
          gateway :utf8
        end
      end

      it 'allows to force encoding' do
        user = container.relation(:users_utf8).to_a.last

        expect(user[:id]).to eql(4)
        expect(user[:name].bytes.to_a)
          .to eql("\xC5\xBB\xC3\xB3\xC5\x82w".bytes.to_a)
        expect(user[:email]).to eql('zolw@example.com')
      end
    end
  end
end
