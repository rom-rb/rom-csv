require 'spec_helper'

RSpec.describe ROM::CSV::Relation do
  let(:root) { Pathname(__FILE__).dirname.join('..') }
  let(:container) { ROM.container(configuration) }
  subject(:rom) { container }

  context 'without extra options' do
    let(:path) { "#{root}/fixtures/users.csv" }
    let(:configuration) do
      ROM::Configuration.new(:csv, path)
    end

    describe 'specify relation with plugin' do
      before do
        TestPlugin = Module.new

        ROM.plugins do
          adapter :csv do
            register :test_plugin, TestPlugin, type: :relation
          end
        end
      end

      it "shouldn't raise error" do
        expect {
          configuration.relation(:users) do
            gateway :users
            use :test_plugin
          end
        }.not_to raise_error
      end
    end
  end

  context 'with extra options' do
    let(:path) { "#{root}/fixtures/users_utf8.csv" }
    let(:options) do
      { encoding: 'iso-8859-2', col_sep: ';' }
    end
    let(:configuration) do
      ROM::Configuration.new(:csv, path, options)
    end

    let(:users_utf8_relation) do
      Class.new(ROM::CSV::Relation) do
        schema(:users_utf8) do
          attribute :id, ROM::Types::String
          attribute :name, ROM::Types::String
          attribute :email, ROM::Types::String
        end

        auto_struct true
      end
    end

    before do
      configuration.register_relation(users_utf8_relation)
    end

    it 'allows to force encoding' do
      user = rom.relations[:users_utf8].to_a.last

      expect(user[:id]).to eql(4)
      expect(user[:name].bytes.to_a)
        .to eql("\xC5\xBB\xC3\xB3\xC5\x82w".bytes.to_a)
      expect(user[:email]).to eql('zolw@example.com')
    end
  end
end
