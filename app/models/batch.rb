class Batch < ApplicationRecord

  require_relative 'elasticsearch_builder'

  # Database relations
  belongs_to :product

  # Validations
  validates :barcode, presence: true
  validates :quantity, numericality: { greater_than: 0, only_integer: true  },
                       presence: true
  validates :expiration_date, presence: true
  validates :product, presence: true
  validates :cost, numericality: {greater_than_or_equal_to: 0}, presence: true

  # Adds the elasticsearch capabilities
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name [Rails.env, self.base_class.to_s.pluralize.underscore].join('_')

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
      search(query)
      .records.all
      .joins(:product)
      .select("products.name as product_name", "batches.*")
      .page(page)
  }

  def self.search(query, limit=50)
    self.__elasticsearch__.search(
      ElasticsearchBuilder::EsQuery.barcode_product_name_query(query, limit)
    )
  end
end
