require 'spec_helper'
require 'rom/adapter/lint/spec'

describe ROM::CSV::Adapter do
  include_examples 'adapter'

  let(:path) { File.expand_path('./spec/fixtures/users.csv') }
  let(:adapter) { ROM::CSV::Adapter }
  let(:adapter_instance) { ROM::Adapter.setup("csv://#{path}") }

  describe ROM::CSV::Adapter::Dataset do
    include_examples 'enumerable dataset'

    let(:data) { [{ id: 1 }, { id: 2 }] }
    let(:dataset) { ROM::CSV::Adapter::Dataset.new(data) }
  end
end
