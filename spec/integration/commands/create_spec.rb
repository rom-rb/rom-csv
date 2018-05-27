require 'spec_helper'

RSpec.describe 'Commands / Create' do
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
    end
  end

  before do
    FileUtils.copy(original_path, path)

    configuration.register_relation(testing_relation)
  end

  it 'returns a single tuple when result is set to :one' do
    command = relation.command(:create, result: :one)
    result = command.call(user_id: 4, name: 'John', email: 'john@doe.org')
    expect(result)
      .to eql(user_id: 4, name: 'John', email: 'john@doe.org')

    expect(relation.to_a.size).to eql(4)
  end

  it 'returns tuples when result is set to :many' do
    command = relation.command(:create, result: :many)
    result = command
             .call([
                     { user_id: 4, name: 'Jane', email: 'jane@doe.org' },
                     { user_id: 5, name: 'Jack', email: 'jack@doe.org' }
                   ])

    expect(result)
      .to match_array([
                        { user_id: 4, name: 'Jane', email: 'jane@doe.org' },
                        { user_id: 5, name: 'Jack', email: 'jack@doe.org' }
                      ])

    expect(relation.to_a.size).to eql(5)
  end
end
