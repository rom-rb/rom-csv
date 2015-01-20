require 'spec_helper'

require 'rom/lint/spec'

describe ROM::CSV::Repository do
  let(:repository) { ROM::CSV::Repository }
  let(:path) { File.expand_path('./spec/fixtures/users.csv') }
  let(:uri) { "csv://#{path}" }

  it_behaves_like "a rom repository"
end
