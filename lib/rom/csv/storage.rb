require 'csv'
require 'rom/initializer'

module ROM
  module CSV
    # CSV file storage for datasets
    #
    # @api private
    class Storage
      extend Initializer

      # Path to the file
      #
      # @return [String]
      #
      # @api private
      param :path,
            type: Types::Strict::String

      # Options for file passed to `CSV`
      #
      # @return [Hash]
      #
      # @api private
      param :csv_options,
            default: proc { {} },
            type: Types::Strict::Hash

      # Dump the data to the file at `path`
      #
      # @return [undefined]
      #
      # @api public
      def dump(data)
        ::CSV.open(path, 'wb', csv_options) do |csv|
          data.to_a.each do |tuple|
            csv << tuple
          end
        end
      end

      # Load the data from the file at `path`
      #
      # @return [CSV::Table]
      #
      # @api public
      def load
        ::CSV.table(path, csv_options).by_row!
      end
    end
  end
end
