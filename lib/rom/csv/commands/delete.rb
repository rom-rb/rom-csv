# frozen_string_literal: true

module ROM
  module CSV
    module Commands
      class Delete < ROM::Memory::Commands::Delete
        def execute
          super.tap { source.dataset.sync! }
        end
      end
    end
  end
end
