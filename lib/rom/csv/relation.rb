require 'rom/memory'

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
    end
  end
end
