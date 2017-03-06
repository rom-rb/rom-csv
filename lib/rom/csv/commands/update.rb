require 'rom/commands'
require 'rom/commands/update'

module ROM
  module CSV
    module Commands
      class Update < ROM::Commands::Update
        adapter :csv

        def execute(tuple)
          attributes = input[tuple]
          tuple = attributes.to_h

          update(tuple)
        end

        private

        def update(tuple)
          original_data = original_dataset.to_a
          output = []

          dataset.each do |dataset_tuple|
            index = original_data.index(dataset_tuple)
            update_dataset(index, tuple)
            output << original_dataset.data[index].to_hash
          end

          original_dataset.sync!
          output
        end

        def update_dataset(index, tuple)
          tuple.each do |key, value|
            original_dataset.data[index][key] = value
          end
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
