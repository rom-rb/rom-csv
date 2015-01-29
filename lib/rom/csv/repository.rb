require 'rom/repository'
require 'rom/csv/dataset'

module ROM
  module CSV
    Relation = Class.new(ROM::Relation)

    class Repository < ROM::Repository
      attr_reader :datasets

      # Expect a path to a single csv file which will be registered by rom to
      # the given name or :default as the repository.
      #
      # Uses CSV.table which passes the following csv options:
      #  headers: true
      #  converters: numeric
      #  header_converters: :symbol
      def initialize(path)
        @datasets = {}
        @connection = ::CSV.table(path).by_row!
      end

      def [](name)
        datasets[name]
      end

      def dataset(name)
        datasets[name] = Dataset.new(connection)
      end

      def dataset?(name)
        datasets.key?(name)
      end
    end
  end
end
