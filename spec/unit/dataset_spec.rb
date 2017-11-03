require 'spec_helper'

require 'rom/lint/spec'

describe ROM::CSV::Dataset do
  let(:data) { [{ id: 1 }, { id: 2 }] }
  let(:dataset) { ROM::CSV::Dataset.new(data) }

  it_behaves_like 'a rom enumerable dataset'
end
