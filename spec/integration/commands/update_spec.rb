require 'spec_helper'

RSpec.describe 'Commands / Updates' do
  let(:configuration) do
    ROM::Configuration.new(:csv, path)
  end

  let(:root) { Pathname(__FILE__).dirname.join('../..') }
  let(:container) { ROM.container(configuration) }
  let(:relations) { container[:relations] }

  subject(:relation) { relations[:testing] }

  let(:original_path) { "#{root}/fixtures/users.csv" }
  let(:path) { "#{root}/fixtures/testing.csv" }

  let(:testing_relation) do
    Class.new(ROM::CSV::Relation) do
      schema(:testing) do
        attribute :user_id, ROM::Types::String
        attribute :name, ROM::Types::String
        attribute :email, ROM::Types::String
      end

      def by_id(id)
        restrict(user_id: id)
      end
    end
  end

  before do
    FileUtils.copy(original_path, path)

    configuration.register_relation(testing_relation)
  end

  it 'updates everything when there is no original tuple' do
    command = relation.command(:update)
    result = command.by_id(1).call(email: 'tester@example.com')

    expect(result)
      .to eql(user_id: 1, name: 'Julie', email: 'tester@example.com')

    result = relation.by_id(1).to_a.first
    expect(result[:email]).to eql('tester@example.com')
  end
end
