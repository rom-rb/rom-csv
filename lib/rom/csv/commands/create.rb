# frozen_string_literal: true

module ROM
  module CSV
    module Commands
      class Create < ROM::Memory::Commands::Create
        def execute(tuples)
          super(tuples).tap { relation.dataset.sync! }
        end
      end
    end
  end
end
