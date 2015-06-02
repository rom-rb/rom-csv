require 'rom/gateway'
require 'rom/csv/dataset'
require 'rom/csv/commands'

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
      # Expect a path to a single csv file which will be registered by rom to
      # the given name or :default as the gateway.
      #
      # Uses CSV.table which passes the following csv options:
      # * headers: true
      # * converters: numeric
      # * header_converters: :symbol
      #
      # @param path [String] path to csv
      # @param options [Hash] options passed to CSV.table
      #
      # @api private
      #
      # @see CSV.table
      def initialize(path, options = {})
        @datasets = {}
        @path = path
        @options = options
        @connection = ::CSV.table(path, options).by_row!
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
        datasets[name] = Dataset.new(connection, dataset_options)
      end

      # Check if dataset exists
      #
      # @param name [String] dataset name
      #
      # @api public
      def dataset?(name)
        datasets.key?(name)
      end

      private

      def dataset_options
        { path: path, file_options: options }
      end

      # @api private
      attr_reader :datasets, :path, :options
    end
  end
end
