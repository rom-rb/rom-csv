require 'spec_helper'

describe 'CSV relation' do
  context 'without extra options' do
    include_context 'database setup'

    before do
      module Test
        module RelationPlugin
          # empty plugin for test purposes
        end
      end

      ROM.plugins do
        adapter :csv do
          register :test_plugin, Test::RelationPlugin, type: :relation
        end
      end
    end

    describe 'specify relation with plugin' do
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
end
