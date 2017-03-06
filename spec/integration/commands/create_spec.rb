require 'spec_helper'
require 'dry-struct'

describe 'Commands / Create' do
  include_context 'database setup'

  subject(:users) { container.commands.users }

  before do
    configuration.relation(:users)

    module Test
      class User < Dry::Struct
        attribute :user_id, Types::Strict::Int
        attribute :name, Types::Strict::String
        attribute :email, Types::Strict::String
      end
    end

    configuration.mappers do
      define(:users) do
        model Test::User
        register_as :entity
      end
    end

    configuration.commands(:users) do
      define(:create) do
        result :one
      end

      define(:create_many, type: :create) do
        result :many
      end
    end
  end

  it 'returns a single tuple when result is set to :one' do
    result = users.try do
      users.create.call(user_id: 4, name: 'John', email: 'john@doe.org')
    end
    expect(result.value).to eql(user_id: 4, name: 'John', email: 'john@doe.org')

    result = container.relation(:users).as(:entity).to_a
    expect(result.count).to eql(4)
  end

  it 'returns tuples when result is set to :many' do
    result = users.try do
      users.create_many.call([
        { user_id: 4, name: 'Jane', email: 'jane@doe.org' },
        { user_id: 5, name: 'Jack', email: 'jack@doe.org' }
      ])
    end

    expect(result.value.to_a).to match_array([
      { user_id: 4, name: 'Jane', email: 'jane@doe.org' },
      { user_id: 5, name: 'Jack', email: 'jack@doe.org' }
    ])

    result = container.relation(:users).as(:entity).to_a
    expect(result.count).to eql(5)
  end
end
