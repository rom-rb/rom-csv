require 'spec_helper'

require 'rom/lint/spec'

describe ROM::CSV::Repository do
  let(:repository) { ROM::CSV::Repository }
  let(:uri) { File.expand_path('./spec/fixtures/users.csv') }

  it_behaves_like "a rom repository" do
    let(:identifier) { :csv }
  end
end
