require 'spec_helper'
require 'anima'

describe 'CSV repository' do
  subject(:rom) { setup.finalize }

  let(:path) { File.expand_path('./spec/fixtures/users.csv') }

  # If :csv is not passed in the repository is named `:default`
  let(:setup) { ROM.setup(:csv, path) }

  before do
    setup.relation(:users) do
      def by_name(name)
        find_all { |row| row[:name] == name }
      end
    end

    class User
      # Anima allows creation of an instance with an attribute hash
      include Anima.new(:id, :name, :email)
    end

    setup.mappers do
      define(:users) do
        model User
      end
    end
  end

  describe 'env#read' do
    it 'returns mapped object' do
      jane = rom.read(:users).by_name('Jane').to_a.first

      expect(jane.id).to eql(2)
      expect(jane.name).to eql('Jane')
      expect(jane.email).to eql('jane@doe.org')
    end
  end
end
