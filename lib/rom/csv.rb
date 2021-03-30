# frozen_string_literal: true

require 'csv'

require 'rom-core'

require 'rom/csv/version'
require 'rom/csv/gateway'
require 'rom/csv/relation'

ROM.register_adapter(:csv, ROM::CSV)
