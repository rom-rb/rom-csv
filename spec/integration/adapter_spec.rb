require 'spec_helper'

require 'rom-repository'

RSpec.describe ROM::CSV do
  let(:configuration) do
    ROM::Configuration.new(:csv, uri)
  end

  let(:uri) { File.expand_path('./spec/fixtures/users.csv') }
  let(:rom) { ROM.container(configuration) }

  context 'single file configuration' do
    let(:users_relation) do
      Class.new(ROM::CSV::Relation) do
        schema(:users) do
          attribute :user_id, ROM::Types::Int
          attribute :name,    ROM::Types::String
          attribute :email,   ROM::Types::String
        end

        def by_name(name)
          restrict(name: name)
        end
      end
    end

    before do
      configuration.register_relation(users_relation)
    end

    describe ROM::CSV::Relation do
      describe '#by_name' do
        subject(:jane) { rom.relations[:users].by_name('Jane').one }

        it 'returns object by name' do
          expect(jane[:name]).to eql 'Jane'
          expect(jane[:email]).to eql 'jane@doe.org'
          expect(jane[:user_id]).to eql 3
        end
      end
    end

    describe 'with a repository' do
      let(:repo) do
        Class.new(ROM::Repository[:users]).new(rom)
      end

      it 'auto-maps to structs' do
        user = repo.users.by_name('Jane').one

        expect(user.name).to eql 'Jane'
        expect(user.email).to eql 'jane@doe.org'
        expect(user.user_id).to eql 3
      end
    end
  end
end
