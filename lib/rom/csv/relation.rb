# frozen_string_literal: true

require 'rom/memory'
require 'rom/csv/schema'

module ROM
  module CSV
    # CSV-specific relation subclass
    #
    # @api private
    class Relation < ROM::Memory::Relation
      adapter :csv

      schema_class CSV::Schema
    end
  end
end
