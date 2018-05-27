require 'rom-csv'

csv_file = ARGV[0] || File.expand_path("./users.csv", File.dirname(__FILE__))

configuration = ROM::Configuration.new(:csv, csv_file)

configuration.relation(:users) do
  auto_struct true

  def by_name(name)
    restrict(name: name)
  end
end

container = ROM.container(configuration)

user = container.relations[:users].by_name('Jane').one
# => #<ROM::OpenStruct @id=2, @name="Jane", @email="jane@doe.org">

user or abort "user not found"
