shared_context 'database setup' do
  let(:configuration) do
    ROM::Configuration.new(
      default: [:csv, path],
      users: [:csv, path],
      addresses: [:csv, addresses_path],
      utf8: [:csv, users_with_utf8_path, { encoding: 'iso-8859-2', col_sep: ';' }]
    ).use(:macros)
  end
  let(:container) { ROM.container(configuration) }

  let(:original_path) { File.expand_path('./spec/fixtures/users.csv') }
  let(:path) { File.expand_path('./spec/fixtures/testing.csv') }
  let(:addresses_path) { File.expand_path('./spec/fixtures/addresses.csv') }
  let(:users_with_utf8_path) { File.expand_path('./spec/fixtures/users.utf-8.csv') }

  before do
    FileUtils.copy(original_path, path)
  end
end
