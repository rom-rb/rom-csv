# frozen_string_literal: true

require 'spec_helper'

require 'rom/lint/spec'
require 'rom/repository'

RSpec.describe ROM::CSV do
  let(:configuration) do
    ROM::Configuration.new(:csv, path)
  end

  let(:root) { Pathname(__FILE__).dirname.join('..') }
  let(:container) { ROM.container(configuration) }

  subject(:rom) { container }

  describe "single file configuration" do
    let(:path) { "#{root}/fixtures/users.csv" }

    let(:users_relation) do
      Class.new(ROM::CSV::Relation) do
        schema(:users) do
          attribute :user_id, ROM::Types::String
          attribute :name, ROM::Types::String
          attribute :email, ROM::Types::String
        end

        auto_struct true

        def by_name(name)
          restrict(name: name)
        end
      end
    end

    before do
      configuration.register_relation(users_relation)
    end

    describe 'Relation#first' do
      it 'returns mapped struct' do
        jane = rom.relations[:users].by_name('Jane').first

        expect(jane.user_id).to eql(3)
        expect(jane.name).to eql('Jane')
        expect(jane.email).to eql('jane@doe.org')
      end
    end

    describe 'with a repository' do
      let(:repo) do
        Class.new(ROM::Repository[:users]).new(rom)
      end

      it 'auto-maps to structs' do
        user = repo.users.first

        expect(user.user_id).to eql(1)
        expect(user.name).to eql('Julie')
        expect(user.email).to eql('julie.andrews@example.com')
      end
    end
  end

  describe 'multi-file setup' do
    let(:path) { "#{root}/fixtures" }

    let(:users_relation) do
      Class.new(ROM::CSV::Relation) do
        schema :users do
          attribute :user_id, ROM::Types::String
          attribute :name, ROM::Types::String
          attribute :email, ROM::Types::String
        end
      end
    end

    let(:addresses_relation) do
      Class.new(ROM::CSV::Relation) do
        schema :addresses do
          attribute :address_id, ROM::Types::String
          attribute :user_id, ROM::Types::String
          attribute :street, ROM::Types::String
        end
      end
    end

    before do
      configuration.register_relation(users_relation)
      configuration.register_relation(addresses_relation)
    end

    let(:user_results) do
      [
        { user_id: 1, name: 'Julie', email: 'julie.andrews@example.com' },
        { user_id: 2, name: 'Julie', email: 'julie@doe.org' },
        { user_id: 3, name: 'Jane', email: 'jane@doe.org' }
      ]
    end

    let(:address_results) do
      [
        { address_id: 1, user_id: 1, street: 'Cleveland Street' },
        { address_id: 2, user_id: 2, street: 'East Avenue' },
        { address_id: 3, user_id: 2, street: 'Lantern Lane' },
        { address_id: 4, user_id: 3, street: 'Lantern Street' }
      ]
    end

    it 'uses one-file-per-relation' do
      expect(rom.relations[:users].to_a)
        .to eql(user_results)

      expect(rom.relations[:addresses].to_a)
        .to eql(address_results)
    end
  end
end
