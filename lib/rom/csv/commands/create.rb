require 'rom/commands'
require 'rom/commands/create'

module ROM
  module CSV
    module Commands
      class Create < ROM::Commands::Create
        adapter :csv

        def execute(tuples)
          insert_tuples =  [tuples].flatten.map do |tuple|
            attributes = input[tuple]
            validator.call(attributes)
            attributes.to_h
          end

          insert(insert_tuples)
          insert_tuples
        end

        def insert(tuples)
          headers = headers_from_csv || headers_from_tuple(tuples.first)
          tuples.each { |tuple| dataset << new_row(headers, tuple) }
          dataset.sync!
        end

        def new_row(headers, tuple)
          ::CSV::Row.new(headers, ordered_data(headers, tuple))
        end

        def ordered_data(headers, tuple)
          headers.map { |header| tuple[header] }
        end

         def dataset
           relation.dataset
         end

        def headers_from_csv
          dataset.data.headers unless dataset.data.headers.empty?
        end

        def headers_from_tuple(tuple)
          tuple.keys
        end
      end
    end
  end
end
