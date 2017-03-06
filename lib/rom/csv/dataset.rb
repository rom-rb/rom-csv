require 'rom/memory/dataset'
require 'rom/csv/storage'

module ROM
  module CSV
    # Type definition used to constrain the `connection` option
    StorageType = Types.Definition(Storage).constrained(type: Storage)

    # Dataset for CSV
    #
    # @api public
    class Dataset < ROM::Memory::Dataset

      # Connection to the file
      #
      # @return [Storage]
      #
      # @api private
      option :connection,
             optional: true,
             type: StorageType

      # Convert each CSV::Row to a hash
      #
      # @api public
      def self.row_proc
        -> row { row.to_hash }
      end

      def reload!
        @data = connection.load
      end

      def sync!
        connection.dump(data) && reload!
      end

      def count
        data.count
      end
    end
  end
end
