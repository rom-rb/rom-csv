require 'csv'

require 'rom'
require 'rom/csv/version'
require 'rom/csv/repository'

ROM.register_adapter(:csv, ROM::CSV)
