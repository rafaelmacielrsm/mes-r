class Batch < ApplicationRecord
  # Database relations
  belongs_to :product

  # Adds the elasticsearch capabilities
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # ES Mapping - Using a nested Object for the product-batch relationship
  mappings dynamic: 'false' do
    indexes :barcode, type: :text
    indexes :product, type: :nested do
      indexes :name, type: :text
    end
  end
  # Custom Model serialization Method
  def as_indexed_json(options = {})
    as_json(
      only: [:id, :barcode, :quantity, :cost],
      include: { product: {only: [:name, :id, :price]}}
    )
  end

  # Query scopes
  scope :index_query,
    lambda { |query="", page=1, column="products.name", direction="ASC"|
      joins(:product)
      .send(:where, (query.blank? ? "" : ['products.name LIKE ?', "%#{query}%"]))
      .select("products.name as product_name", "batches.*")
      .order("#{column} #{direction}")
      .page(page)
  }

  scope :es_query,
    lambda { |query="", page=1|
      search((query.blank? ? "*" : query))
      .records.all
      .joins(:product)
      .select("products.name as product_name", "batches.*")
      .page(page)
  }

  def self.search(query)
    self.__elasticsearch__.search(
      query: {
        multi_match: {
          query: query,
          fields: ['barcode', 'product.name'],
          type: 'phrase_prefix',
          slop: 3,
          zero_terms_query: :all
        }
      },
      size: 50
    )
  end
end
