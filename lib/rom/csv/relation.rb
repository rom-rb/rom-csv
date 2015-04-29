require 'rom/relation'

module ROM
  module CSV
    # Relation subclass of CSV adapter
    #
    # @example
    #   class Users < ROM::Relation[:csv]
    #   end
    #
    # @api public
    class Relation < ROM::Relation
      forward :join, :project, :restrict, :order

      def count
        dataset.count
      end
    end
  end
end
