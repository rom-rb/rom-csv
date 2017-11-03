require 'spec_helper'

RSpec.describe ROM::CSV do
  let(:configuration) do
    ROM::Configuration.new(:csv, uri)
  end

  let(:rom) { ROM.container(configuration) }

  context 'multi-file configuration' do
    let(:uri) { File.expand_path('./spec/fixtures/db') }

    before do
      configuration.relation(:products)
      configuration.relation(:variants)
    end

    it 'uses one file per relation' do
      expect(rom.relations[:products].to_a)
        .to eql([{ id: 1, title: "T-Shirt" }, { id: 2, title: "Mug" }])

      expect(rom.relations[:variants].to_a)
        .to eql([{ id: 1, product_id: 1, sku: "TSHIRT1010PINK", quantity: 3 },
                 { id: 2, product_id: 1, sku: "TSHIRT1020BLUE", quantity: 5 },
                 { id: 3, product_id: 1, sku: "TSHIRT1030GREY", quantity: 2 },
                 { id: 4, product_id: 2, sku: "MUG2010WHITE", quantity: 15 },
                 { id: 5, product_id: 2, sku: "MUG2010GREEN", quantity: 10 },
                 { id: 6, product_id: 3, sku: "MUG2030BROWN", quantity: 12 }])
    end
  end
end
