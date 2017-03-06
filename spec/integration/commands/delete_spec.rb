require 'spec_helper'

describe 'Commands / Delete' do
  include_context 'database setup'

  subject(:users) { container.commands.users }

  before do
    configuration.relation(:users) do
      def by_id(id)
        restrict(user_id: id)
      end
    end

    configuration.commands(:users) do
      define(:delete) do
        result :one
      end
    end
  end

  it 'deletes all tuples in a restricted relation' do
    result = users.try { users.delete.by_id(1).call }

    expect(result.value)
      .to eql(user_id: 1, name: "Julie", email: "julie.andrews@example.com")

    container.relation(:users).dataset.reload!

    result = container.relation(:users).to_a
    expect(result.count).to eql(2)
  end
end
