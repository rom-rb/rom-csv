require 'rom/array_dataset'

module ROM
  module CSV
    class Adapter < ROM::Adapter
      def self.schemes
        [:csv]
      end

      class Dataset
        include Charlatan.new(:rows)
        include ROM::ArrayDataset

        def self.row_proc
          -> row { row.to_hash }
        end
      end

      # Expect a path to a single csv file which will be registered by rom to
      # the given name or :default as the repository.
      def initialize(*args)
        super
        # Uses CSV::table which passes the following csv options:
        #  headers: true
        #  converters: numeric
        #  header_converters: :symbol
        @connection = ::CSV.table("#{uri.host}#{uri.path}").by_row!
      end

      def [](_name)
        connection
      end

      def dataset(_name)
        Dataset.new(connection)
      end

      def dataset?(_name)
        connection
      end
    end
  end
end
