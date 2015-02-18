require 'rom/repository'
require 'rom/csv/dataset'

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
  # Note: Currently, only read operations are supported.
  #
  # @api public
  module CSV
    # Relation subclass of CSV adapter
    #
    # @example
    #   class Users < ROM::Relation[:csv]
    #   end
    #
    # @api public
    Relation = Class.new(ROM::Relation)

    # CSV repository interface
    #
    # @api public
    class Repository < ROM::Repository
      # Expect a path to a single csv file which will be registered by rom to
      # the given name or :default as the repository.
      #
      # Uses CSV.table which passes the following csv options:
      # * headers: true
      # * converters: numeric
      # * header_converters: :symbol
      #
      # @param path [String] path to csv
      #
      # @api private
      #
      # @see CSV.table
      def initialize(path)
        @datasets = {}
        @connection = ::CSV.table(path).by_row!
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

      # Register a dataset in the repository
      #
      # If dataset already exists it will be returned
      #
      # @param name [String] dataset name
      # @return [Dataset]
      #
      # @api public
      def dataset(name)
        datasets[name] = Dataset.new(connection)
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

      # @api private
      attr_reader :datasets
    end
  end
end
