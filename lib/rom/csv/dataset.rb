require 'rom/support/array_dataset'

module ROM
  module CSV
    # Dataset for CSV
    #
    # @api public
    class Dataset
      include ArrayDataset

      # Convert each CSV::Row to a hash
      #
      # @api public
      def self.row_proc
        -> row { row.to_hash }
      end
    end
  end
end
