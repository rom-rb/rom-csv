require 'rom/memory/dataset'

module ROM
  module CSV
    # Dataset for CSV
    #
    # @api public
    class Dataset < ROM::Memory::Dataset
      option :path, reader: true, optional: true
      option :file_options, reader: true, optional: true

      # Convert each CSV::Row to a hash
      #
      # @api public
      def self.row_proc
        -> row { row.to_hash }
      end

      def reload!
        @data = load_data
      end

      def sync!
        write_data && reload!
      end

      def write_data
        ::CSV.open(path, 'wb', file_options) do |csv|
          data.to_a.each do |tuple|
            csv << tuple
          end
        end
      end

      def load_data
        ::CSV.table(path, file_options).by_row!
      end

      def count
        data.count
      end
    end
  end
end
