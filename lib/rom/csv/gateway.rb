require 'rom/gateway'
require 'rom/csv/dataset'
require 'rom/csv/commands'

module ROM
  module CSV
    # CSV gateway
    #
    # Connects to a csv file and uses it as a data-source
    #
    # @example
    #   rom = ROM.container(:csv, '/path/to/data.yml')
    #   gateway = rom.gateways[:default]
    #   gateway[:users] # => data under 'users' key from the csv file
    #
    # @api public
    class Gateway < ROM::Gateway
      adapter :csv

      # @attr_reader [Hash] sources Data loaded from files
      #
      # @api private
      attr_reader :sources

      # @attr_reader [Hash] datasets CSV datasets from sources
      #
      # @api private
      attr_reader :datasets

      # Create a new csv gateway from a path to file(s)
      #
      # @example
      #   gateway = ROM::CSV::Gateway.new('/path/to/files')
      #
      # @param [String, Pathname] path The path to your CSV file(s)
      #
      # @return [Gateway]
      #
      # @api public
      def self.new(path, options = {})
        super(load_from(path, options), options)
      end

      # Load data from csv file(s)
      #
      # @api private
      def self.load_from(path, options = {})
        if File.directory?(path)
          load_files(path, options)
        else
          {
            source_name(path) => {
              data: load_file(path, options),
              path: path
            }
          }
        end
      end

      # Load csv files from a given directory and return a name => data map
      #
      # @api private
      def self.load_files(path, options = {})
        Dir["#{path}/*.csv"].each_with_object({}) do |file, h|
          h[source_name(file)] = {
            data: load_file(file, options),
            path: file
          }
        end
      end

      def self.source_name(filename)
        File.basename(filename, '.*')
      end

      # Load csv file
      #
      # Uses CSV.table which passes the following csv options:
      # * headers: true
      # * converters: numeric
      # * header_converters: :symbol
      #
      # @api private
      def self.load_file(path, options = {})
        ::CSV.table(path, options).by_row!.map(&:to_hash)
      end

      # @param [Hash] sources The hashmap containing data loaded from files
      #
      # @api private
      def initialize(sources, options = {})
        @sources = sources
        @options = options
        @datasets = {}
      end

      # Return dataset by its name
      #
      # @param [Symbol]
      #
      # @return [Array<Hash>]
      #
      # @api public
      def [](name)
        datasets.fetch(name)
      end

      # Register a new dataset
      #
      # @param [Symbol]
      #
      # @return [Dataset]
      #
      # @api public
      def dataset(name)
        dataset_source = sources.fetch(name.to_s)

        datasets[name] = Dataset.new(
          dataset_source.fetch(:data),
          path: dataset_source.fetch(:path),
          file_options: options
        )
      end

      # Return if a dataset with provided name exists
      #
      # @api public
      def dataset?(name)
        datasets.key?(name)
      end

      private

      # @api private
      attr_reader :options
    end
  end
end
