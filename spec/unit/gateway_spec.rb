require 'spec_helper'

require 'rom/lint/spec'

describe ROM::CSV::Gateway do
  let(:gateway) { ROM::CSV::Gateway }
  let(:uri) { File.expand_path('./spec/fixtures/users.csv') }

  it_behaves_like "a rom gateway" do
    let(:identifier) { :csv }
  end
end
