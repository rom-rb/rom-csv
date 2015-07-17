require 'spec_helper'
require 'virtus'

require_relative '../../support/user'

describe 'Commands / Updates' do
  subject(:rom) { setup.finalize }

  let(:original_path) { File.expand_path('./spec/fixtures/users.csv') }
  let(:path) { File.expand_path('./spec/fixtures/testing.csv') }

  # If :csv is not passed in the gateway is named `:default`
  let(:setup) { ROM.setup(:csv, path) }

  subject(:users) { rom.commands.users }

  let(:relation) { rom.relations.users }
  let(:first_data) { relation.by_id(1).to_a.first }
  let(:new_data) { { name: 'Peter' } }
  let(:output_data) do
    [{ user_id: 1, name: 'Julie', email: 'tester@example.com' }]
  end

  before do
    FileUtils.copy(original_path, path)

    setup.relation(:users) do
      def by_id(id)
        restrict(user_id: id)
      end
    end

    setup.mappers do
      define(:users) do
        model User
        register_as :entity
      end
    end

    setup.commands(:users) do
      define(:update)
    end
  end

  it 'updates everything when there is no original tuple' do
    result = users.try do
      users.update.by_id(1).call(email: 'tester@example.com')
    end

    expect(result.value.to_a).to match_array(output_data)

    result = rom.relation(:users).as(:entity).by_id(1).to_a.first
    expect(result.email).to eql('tester@example.com')
  end
end
