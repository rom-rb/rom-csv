require 'rom/memory'
require 'rom/plugins/relation/key_inference'

module ROM
  module CSV
    # Relation subclass of CSV adapter
    #
    # @example
    #   class Users < ROM::Relation[:csv]
    #   end
    #
    # @api public
    class Relation < ROM::Memory::Relation
      adapter :csv
      use :key_inference

      def count
        dataset.count
      end
    end
  end
end
