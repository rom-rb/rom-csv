require 'spec_helper'

RSpec.describe 'ROM.container' do
  let(:uri) { File.expand_path('./spec/fixtures/users.csv') }

  let(:rom) do
    ROM.container(:csv, uri) do |conf|
      conf.relation(:users) do
      end
    end
  end

  it do
    expect(rom.relations[:users]).to be_kind_of(ROM::CSV::Relation)
  end
end
