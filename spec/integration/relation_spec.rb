require 'spec_helper'
require 'virtus'

describe 'CSV gateway' do
  context 'without extra options' do
    # If :csv is not passed in the gateway is named `:default`
    let(:users_path) { File.expand_path('./spec/fixtures/users.csv') }
    let(:setup) do
      ROM.setup(
        users: [:csv, users_path]
      )
    end

    before do
      module TestPlugin; end

      ROM.plugins do
        adapter :csv do
          register :test_plugin, TestPlugin, type: :relation
        end
      end
    end

    describe 'specify relation with plugin' do
      it "shouldn't raise error" do
        expect {
          setup.relation(:users) do
            gateway :users
            use :test_plugin
          end
        }.not_to raise_error
      end
    end
  end
end
