require 'spec_helper'
require 'virtus'

require_relative '../../support/user'

describe 'Commands / Create' do
  subject(:rom) { setup.finalize }

  let(:original_path) { File.expand_path('./spec/fixtures/users.csv') }
  let(:path) { File.expand_path('./spec/fixtures/testing.csv') }

  # If :csv is not passed in the gateway is named `:default`
  let(:setup) { ROM.setup(:csv, path) }

  subject(:users) { rom.commands.users }

  context 'when csv file exists' do
    before do
      FileUtils.copy(original_path, path)

      setup.relation(:users)

      setup.mappers do
        define(:users) do
          model User
          register_as :entity
        end
      end

      setup.commands(:users) do
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

      result = rom.relation(:users).as(:entity).to_a
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

      result = rom.relation(:users).as(:entity).to_a
      expect(result.count).to eql(5)
    end
  end

  context "when csv file doesn't exists" do
    before do
      FileUtils.rm(path) if File.exists?(path)
      FileUtils.touch(path)

      setup.relation(:users)

      setup.mappers do
        define(:users) do
          model User
          register_as :entity
        end
      end

      setup.commands(:users) do
        define(:create) do
          result :one
        end
      end
    end

    it 'returns tuples from new generated csv file' do
      result = rom.relation(:users).as(:entity).to_a
      expect(result.count).to eql(0)

      users.try do
        users.create.call(user_id: 4, name: 'John', email: 'john@doe.org')
      end

      result = rom.relation(:users).as(:entity).to_a
      expect(result.count).to eql(1)
    end
  end
end
