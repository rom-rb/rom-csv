require 'rom/commands'
require 'rom/commands/create'

module ROM
  module CSV
    module Commands
      class Create < ROM::Commands::Create
        adapter :csv

        def execute(tuples)
          insert_tuples = [tuples].flatten.map do |tuple|
            attributes = input[tuple]
            validator.call(attributes)
            attributes.to_h
          end

          insert(insert_tuples)
          insert_tuples
        end

        def insert(tuples)
          tuples.each { |tuple| dataset << new_row(tuple) }
          dataset.sync!
        end

        def new_row(tuple)
          ::CSV::Row.new(dataset.data.headers, ordered_data(tuple))
        end

        def ordered_data(tuple)
          dataset.data.headers.map { |header| tuple[header] }
        end

        def dataset
          relation.dataset
        end
      end
    end
  end
end
