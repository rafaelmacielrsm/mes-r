shared_context "elasticsearch setup" do |prod_array = ['AAS', 'Brontek 10ML']|
  around(:context, elasticsearch: true) do |example|
    # create indices
    Batch.__elasticsearch__.create_index!
    # instantiate the dataset
    prod_array.each do |name|
        create(:batch, product: create(:product, name: name))
    end
    # refresh the indices
    Batch.__elasticsearch__.refresh_index!
    # yield to the test
    example.run
    # clear the database and index
    Product.destroy_all
    Batch.destroy_all
    Batch.__elasticsearch__.delete_index!
  end
end
