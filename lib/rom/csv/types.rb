require 'rom/types'

module ROM
  module CSV
    module Types
      include ROM::Types

      def self.Definition(primitive)
        Dry::Types::Definition.new(primitive)
      end
    end
  end
end
