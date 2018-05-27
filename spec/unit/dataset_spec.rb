require 'spec_helper'

require 'rom/lint/spec'

RSpec.describe ROM::CSV::Dataset do
  let(:data) {  [{ id: 1 }, { id: 2 }] }
  let(:options) do
    { path: "foo.csv", file_options: {} }
  end
  let(:dataset) { ROM::CSV::Dataset.new(data, options) }

  it_behaves_like "a rom enumerable dataset"

  it "symbolizes keys" do
    data = ["foo" => 23]
    options = { path: "foo.csv", file_options: {} }
    dataset = ROM::CSV::Dataset.new(data, options)
    expect(dataset.to_a).to eq([{ foo: 23 }])
  end
end
