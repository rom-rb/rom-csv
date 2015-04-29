require 'spec_helper'

describe 'Commands / Delete' do
  subject(:rom) { setup.finalize }

  let(:original_path) { File.expand_path('./spec/fixtures/users.csv') }
  let(:path) { File.expand_path('./spec/fixtures/testing.csv') }

  # If :csv is not passed in the gateway is named `:default`
  let(:setup) { ROM.setup(:csv, path) }

  subject(:users) { rom.commands.users }

  before do
    FileUtils.copy(original_path, path)

    setup.relation(:users) do
      def by_id(id)
        restrict(user_id: id)
      end
    end

    setup.commands(:users) do
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

    # FIXME: reload! should not be necessary
    rom.relation(:users).relation.dataset.reload!

    result = rom.relation(:users).to_a
    expect(result.count).to eql(2)
  end
end
