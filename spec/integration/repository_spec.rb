require 'spec_helper'
require 'virtus'

describe 'CSV repository' do
  subject(:rom) { setup.finalize }

  let(:path) { File.expand_path('./spec/fixtures/users.csv') }

  # If :csv is not passed in the repository is named `:default`
  let(:setup) { ROM.setup(:csv, path) }

  before do
    setup.relation(:users) do
      def by_name(name)
        restrict(name: name)
      end

      def only_name
        project(:name)
      end

      def ordered
        order(:name, :email)
      end
    end

    class User
      include Virtus.model

      attribute :id, Integer
      attribute :name, String
      attribute :email, String
    end

    setup.mappers do
      define(:users) do
        model User
        register_as :entity
      end
    end
  end

  describe 'env#relation' do
    it 'returns restricted and mapped object' do
      jane = rom.relation(:users).as(:entity).by_name('Jane').to_a.first

      expect(jane.id).to eql(3)
      expect(jane.name).to eql('Jane')
      expect(jane.email).to eql('jane@doe.org')
    end

    it 'returns specified attributes in mapped object' do
      jane = rom.relation(:users).as(:entity).only_name.to_a.first

      expect(jane.id).to be_nil
      expect(jane.name).not_to be_nil
      expect(jane.email).to be_nil
    end

    it 'return ordered attributes by name and email' do
      results = rom.relation(:users).as(:entity).ordered.to_a

      expect(results[0].name).to eql('Jane')
      expect(results[0].email).to eq('jane@doe.org')

      expect(results[1].name).to eql('Julie')
      expect(results[1].email).to eq('julie.andrews@example.com')

      expect(results[2].name).to eql('Julie')
      expect(results[2].email).to eq('julie@doe.org')
    end
  end
end
