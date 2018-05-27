require 'rom/memory/dataset'

module ROM
  module CSV
    # CSV in-memory dataset used by CSV gateways
    #
    # @api public
    class Dataset < ROM::Memory::Dataset
      option :path, reader: true
      option :file_options, reader: true

      # Data-row transformation proc
      #
      # @api public
      def self.row_proc
        ->(row) { Transforms[:symbolize_keys].call(row) }
      end

      # Synchronization dataset with file content
      #
      # @api public
      def sync!
        write_data && reload!
      end

      private

      # Write current dataset to file
      #
      # @api private
      def write_data
        ::CSV.open(path, 'wb', file_options) do |csv|
          csv << headers
          data.each do |tuple|
            csv << ordered_data(tuple)
          end
        end
      end

      # Load data to datase
      #
      # @api private
      def reload!
        @data = Gateway.load_file(path, file_options)
      end

      def headers
        data[0].keys
      end

      def ordered_data(tuple)
        headers.map { |header| tuple[header] }
      end
    end

    # @api private
    class Transforms
      extend Transproc::Registry
      import Transproc::HashTransformations
    end
  end
end
