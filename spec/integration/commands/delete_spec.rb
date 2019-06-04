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

  it 'raises error when tuple count does not match expectation' do
    result = users.try { users.delete.call }

    expect(result.value).to be(nil)
    expect(result.error).to be_instance_of(ROM::TupleCountMismatchError)
  end

  it 'deletes all tuples in a restricted relation' do
    result = users.try { users.delete.by_id(1).call }

    expect(result.value)
      .to eql(user_id: 1, name: "Julie", email: "julie.andrews@example.com")

    container.relations[:users].dataset.reload!

    result = container.relations[:users].to_a
    expect(result.count).to eql(2)
  end
end
