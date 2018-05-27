require 'spec_helper'

require 'rom/lint/spec'

RSpec.describe ROM::CSV::Gateway do
  let(:root) { Pathname(__FILE__).dirname.join('..') }

  it_behaves_like 'a rom gateway' do
    let(:identifier) { :csv }
    let(:gateway) { ROM::CSV::Gateway }
    let(:uri) { "#{root}/fixtures/users.csv" }
  end
end
