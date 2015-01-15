require 'rom/repository'
require 'rom/csv/dataset'

module ROM
  module CSV
    class Repository < ROM::Repository
      attr_reader :datasets

      def self.schemes
        [:csv]
      end

      # Expect a path to a single csv file which will be registered by rom to
      # the given name or :default as the repository.
      def setup
        @datasets = {}
        # Uses CSV::table which passes the following csv options:
        #  headers: true
        #  converters: numeric
        #  header_converters: :symbol
        #
        @connection = ::CSV.table("#{uri.host}#{uri.path}").by_row!
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
