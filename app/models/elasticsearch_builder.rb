module ElasticsearchBuilder  
  class EsQuery

    def self.barcode_product_name_query(query, size)
      {query: {
        dis_max: {
          queries: [
            {multi_match: {
              query: query,
              fields: 'barcode',
              zero_terms_query: :all,
              type: 'phrase_prefix',
              slop: 3
              }},
              {nested: {
                path: 'product',
                query: {
                  match_phrase_prefix: {
                    'product.name' => {
                      query: query, slop: 3
                    }
                  }
                }
              }}
              ]
            }
          },
          size: size
        }
    end
  end
end
