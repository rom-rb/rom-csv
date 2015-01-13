require 'rom/array_dataset'

module ROM
  module CSV
    class Dataset
      include ArrayDataset

      def self.row_proc
        -> row { row.to_hash }
      end
    end
  end
end
