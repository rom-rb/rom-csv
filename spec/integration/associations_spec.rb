require 'spec_helper'

RSpec.describe ROM::CSV::Relation do
  let(:configuration) do
    ROM::Configuration.new(:csv, uri)
  end

  let(:rom) { ROM.container(configuration) }

  let(:uri) { File.expand_path('./spec/fixtures/db') }

  before do
    configuration.relation(:products) do
      schema do
        attribute :id, ROM::Types::Int
        attribute :title, ROM::Types::String

        primary_key :id

        associations do
          has_many :variants, combine_key: :product_id,
                              override: true,
                              view: :for_products
        end
      end
    end

    configuration.relation(:variants) do
      schema do
        attribute :id, ROM::Types::Int
        attribute :product_id, ROM::Types::Int
        attribute :sku, ROM::Types::String
        attribute :quantity, ROM::Types::Int
      end

      def for_products(_assoc, products)
        restrict(product_id: products.map { |p| p[:id] })
      end
    end
  end

  let(:products) { rom.relations[:products] }
  let(:variants) { rom.relations[:variants] }

  it 'loads all variants for all products' do
    expect(variants.for_products(variants, products).to_a).to eq [
      { id: 1, product_id: 1, sku: "TSHIRT1010PINK", quantity: 3 },
      { id: 2, product_id: 1, sku: "TSHIRT1020BLUE", quantity: 5 },
      { id: 3, product_id: 1, sku: "TSHIRT1030GREY", quantity: 2 },
      { id: 4, product_id: 2, sku: "MUG2010WHITE", quantity: 15 },
      { id: 5, product_id: 2, sku: "MUG2010GREEN", quantity: 10 }
    ]
  end

  it 'loads variants for particular product' do
    relation = variants.for_products(
      products.associations[:variants],
      products.restrict(title: 'Mug')
    )

    expect(relation.to_a).to eq [
      { id: 4, product_id: 2, sku: "MUG2010WHITE", quantity: 15 },
      { id: 5, product_id: 2, sku: "MUG2010GREEN", quantity: 10 }
    ]
  end

  describe '#combine' do
    it 'allows to combine relations' do
      expect(products.combine(:variants).to_a).to eq [
        { id: 1,
          title: "T-Shirt",
          variants: [
            { id: 1, product_id: 1, sku: "TSHIRT1010PINK", quantity: 3 },
            { id: 2, product_id: 1, sku: "TSHIRT1020BLUE", quantity: 5 },
            { id: 3, product_id: 1, sku: "TSHIRT1030GREY", quantity: 2 }
          ] },
        { id: 2,
          title: "Mug",
          variants: [
            { id: 4, product_id: 2, sku: "MUG2010WHITE", quantity: 15 },
            { id: 5, product_id: 2, sku: "MUG2010GREEN", quantity: 10 }
          ] }
      ]
    end
  end
end
