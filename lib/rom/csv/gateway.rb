require 'csv'

require 'rom/gateway'
require 'rom/csv/dataset'

module ROM
  module CSV
    # CSV gateway
    #
    # Connects to a CSV file and uses it as a data-source
    #
    # @example
    #   rom = ROM.container(:csv, '/path/to/products.scv')
    #   gateway = rom.gateways[:default]
    #   gateway[:products] # => data from the csv file
    #
    # @api public
    class Gateway < ROM::Gateway
      adapter :csv

      # @attr_reader [Hash] sources Data loaded from files
      #
      # @api private
      attr_reader :sources

      # @attr_reader [Hash] datasets CSV datasets
      #
      # @api private
      attr_reader :datasets

      # Create a new CSV gateway from a path to file(s)
      #
      # @example
      #   gateway = ROM::CSV::Gateway.new('/path/to/files')
      #
      # Uses CSV.table which passes the following csv options:
      # * headers: true
      # * converters: numeric
      # * header_converters: :symbol
      #
      # @see CSV.table
      #
      # @param [String, Pathname] path The path to your CSV file(s)
      # @param options [Hash] options passed to CSV.table
      #
      # @return [Gateway]
      #
      # @api public
      def self.new(path, *)
        super(load_from(path))
      end

      # Load data from CSV file(s)
      #
      # @api private
      def self.load_from(path)
        if File.directory?(path)
          load_files(path)
        else
          { source_name(path) => load_file(path) }
        end
      end

      # Load CSV files from a given directory and return a name => data map
      #
      # @api private
      def self.load_files(path)
        Dir["#{path}/*.csv"].each_with_object({}) do |file, h|
          h[source_name(file)] = load_file(file)
        end
      end

      def self.source_name(filename)
        File.basename(filename, '.*')
      end

      # Load CSV file
      #
      # @api private
      def self.load_file(path)
        ::CSV.table(path).map(&:to_h)
      end

      # @api private
      def initialize(sources)
        @sources = sources
        @datasets = {}
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
        datasets[name] = Dataset.new(sources.fetch(name.to_s))
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
