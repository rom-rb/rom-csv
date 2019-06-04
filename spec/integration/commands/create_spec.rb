# frozen_string_literal: true

require 'spec_helper'
require 'virtus'

describe 'Commands / Create' do
  include_context 'database setup'

  subject(:users) { container.commands.users }

  before do
    configuration.relation(:users)

    class User
      include Virtus.model

      attribute :id, Integer
      attribute :name, String
      attribute :email, String
    end

    configuration.mappers do
      define(:users) do
        model User
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
    result = users.create.call(user_id: 4, name: 'John', email: 'john@doe.org')
    expect(result).to eql(user_id: 4, name: 'John', email: 'john@doe.org')

    result = container.relations[:users].as(:entity).to_a
    expect(result.count).to eql(4)
  end

  it 'returns tuples when result is set to :many' do
    result = users.create_many.call([
      { user_id: 4, name: 'Jane', email: 'jane@doe.org' },
      { user_id: 5, name: 'Jack', email: 'jack@doe.org' }
    ])

    expect(result.to_a).to match_array([
      { user_id: 4, name: 'Jane', email: 'jane@doe.org' },
      { user_id: 5, name: 'Jack', email: 'jack@doe.org' }
    ])

    result = container.relations[:users].as(:entity).to_a
    expect(result.count).to eql(5)
  end
end
