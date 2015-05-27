require 'csv'

require 'rom'
require 'rom/csv/version'
require 'rom/csv/gateway'
require 'rom/csv/relation'

ROM.register_adapter(:csv, ROM::CSV)
