require 'rom/gateway'
require 'rom/initializer'
require 'rom/csv/dataset'
require 'rom/csv/commands'
require 'rom/csv/storage'

# Ruby Object Mapper
#
# @see http://rom-rb.org/
module ROM
  # CSV support for ROM
  #
  # @example
  #   require 'rom/csv'
  #   require 'ostruct'
  #
  #   setup = ROM.setup(:csv, "./spec/fixtures/users.csv")
  #   setup.relation(:users) do
  #     def by_name(name)
  #       dataset.find_all { |row| row[:name] == name }
  #     end
  #   end
  #
  #   class User < OpenStruct
  #   end
  #
  #   setup.mappers do
  #     define(:users) do
  #       model User
  #     end
  #   end
  #
  #   rom = setup.finalize
  #   p rom.read(:users).by_name('Jane').one
  #   # => #<User id=2, name="Jane", email="jane@doe.org">
  #
  # **Note: rom-csv is read only at the moment.**
  #
  # @api public
  module CSV
    # CSV gateway interface
    #
    # @api public
    class Gateway < ROM::Gateway
      extend Initializer

      param :path,
            reader: :private,
            type: Types::Strict::String
      param :csv_options,
            default: proc { {} },
            reader: :private,
            type: Types::Strict::Hash

      # @api private
      attr_reader :datasets
      private :datasets

      # Expect a path to a single csv file which will be registered by rom to
      # the given name or :default as the gateway.
      #
      # Uses CSV.table which passes the following csv options:
      # * headers: true
      # * converters: numeric
      # * header_converters: :symbol
      #
      # @param path [String] path to csv
      # @param csv_options [Hash] options passed to CSV.table
      #
      # @api private
      #
      # @see CSV.table
      def initialize(*)
        super
        @datasets = {}
        @connection = Storage.new(path, csv_options)
      end

      # Return dataset with the given name
      #
      # @param name [String] dataset name
      # @return [Dataset]
      #
      # @api public
      def [](name)
        datasets[name]
      end

      # Register a dataset in the gateway
      #
      # If dataset already exists it will be returned
      #
      # @param name [String] dataset name
      # @return [Dataset]
      #
      # @api public
      def dataset(name)
        datasets[name] = Dataset.new(connection.load, connection: connection)
      end

      # Check if dataset exists
      #
      # @param name [String] dataset name
      #
      # @api public
      def dataset?(name)
        datasets.key?(name)
      end
    end
  end
end
