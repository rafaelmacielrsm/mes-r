shared_context "elasticsearch setup" do |prod_array = %w(Acebrofilina Brontek)|
  around(:context, elasticsearch: true) do |example|
    # create indices
    described_class.__elasticsearch__.create_index!
    # instantiate the product dataset through the product factory
    # prod_array.map! {|product| create(:product, name: product)}
    # instantiate the batch dataset through the batch factory
    [3,4,5].sample.times { create(:batch, product: create(:product, name: prod_array.sample)) }
    # refresh the indices
    described_class.__elasticsearch__.refresh_index!
    # yield to the test
    example.run
    # clear the database and index
    Product.destroy_all
    described_class.destroy_all
    described_class.__elasticsearch__.delete_index!
  end
end
