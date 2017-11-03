shared_context 'database setup' do
  let(:conf) { ROM::Configuration.new(:csv, uri) }
  let(:container) { ROM.container(conf) }

  let(:data_sources) do
    {
      users: File.expand_path('./spec/fixtures/users.csv'),
      addresses: File.expand_path('./spec/fixtures/addresses.csv'),
      utf8: File.expand_path('./spec/fixtures/users.utf-8.csv'),
      database: File.expand_path('./spec/fixtures/db')
    }
  end
end
