require 'spec_helper'

require 'rom/lint/spec'

describe ROM::CSV::Gateway do
  include_context 'database setup'

  let(:gateway) { container.gateways[:default] }

  it_behaves_like 'a rom gateway' do
    let(:uri) { File.expand_path('./spec/fixtures/users.csv') }
    let(:identifier) { :csv }
    let(:gateway) { ROM::CSV::Gateway }
  end
end
