require 'spec_helper'

RSpec.describe ROM::CSV do
  let(:configuration) do
    ROM::Configuration.new(:csv, uri, csv_options)
  end

  let(:rom) { ROM.container(configuration) }

  context 'when CSV options provided' do
    let(:uri) { File.expand_path('./spec/fixtures/semicolon.csv') }
    let(:csv_options) { { col_sep: ';' } }

    before do
      configuration.relation(:users) do
        schema(:semicolon) do
        end
      end
    end

    it 'uses csv options for load data' do
      expect(rom.relations[:users].to_a).to eql [
        { user_id: 1, name: "Jane", email: "jane@doe.org" },
        { user_id: 2, name: "John", email: "john@doe.org" }
      ]
    end
  end
end
