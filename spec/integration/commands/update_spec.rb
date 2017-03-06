require 'spec_helper'
require 'dry-struct'

describe 'Commands / Updates' do
  include_context 'database setup'

  subject(:users) { container.commands.users }

  let(:relation) { container.relations.users }
  let(:first_data) { relation.by_id(1).to_a.first }
  let(:new_data) { { name: 'Peter' } }
  let(:output_data) do
    [{ user_id: 1, name: 'Julie', email: 'tester@example.com' }]
  end

  before do
    configuration.relation(:users) do
      def by_id(id)
        restrict(user_id: id)
      end
    end

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
      define(:update)
    end
  end

  it 'updates everything when there is no original tuple' do
    result = users.try do
      users.update.by_id(1).call(email: 'tester@example.com')
    end

    expect(result.value.to_a).to match_array(output_data)

    # FIXME: reload! should not be necessary
    container.relation(:users).dataset.reload!

    result = container.relation(:users).as(:entity).by_id(1).to_a.first
    expect(result.email).to eql('tester@example.com')
  end
end
