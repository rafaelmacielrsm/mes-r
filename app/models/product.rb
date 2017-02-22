class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :batches

  # Adds the elasticsearch capabilities
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  # index_name [Rails.env, self.base_class.to_s.pluralize.underscore].join('_')
  #
  # mappings dynamic: 'false' do
  #   indexes :name, type: :text
  # end
end
