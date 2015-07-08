require 'rom/commands'
require 'rom/commands/delete'

module ROM
  module CSV
    module Commands
      class Delete < ROM::Commands::Delete
        adapter :csv

        def execute
          original_data = original_dataset.to_a

          dataset.each do |dataset_tuple|
            index = original_data.index(dataset_tuple)
            original_dataset.data.delete(index)
          end

          original_dataset.sync!
          dataset.data
        end

        def dataset
          relation.dataset
        end

        def original_dataset
          source.dataset
        end
      end
    end
  end
end
