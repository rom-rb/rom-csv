# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Commands / Delete' do
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

  it 'deletes all tuples in a restricted relation' do
    command = relation.command(:delete, result: :one).by_id(1)
    result = command.call

    expect(result)
      .to eql(user_id: 1, name: "Julie", email: "julie.andrews@example.com")

    expect(relation.to_a.size).to eql(2)
  end
end
