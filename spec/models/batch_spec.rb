require 'rails_helper'
require 'shared_examples/positive_integer'
require 'shared_examples/monetary_value'
require 'shared_context/elasticsearch_setup'

RSpec.describe Batch, type: :model do
  describe '#validations' do
    subject { build :batch }

    context 'when a new object is created' do
      it 'validates the presence of product' do
        should validate_presence_of :product
      end

      it 'validates the presence of barcode' do
        should validate_presence_of :product
      end

      it 'validates the presence of quantity' do
        should validate_presence_of :quantity
      end

      it 'validates the numericality of quantity' do
        should validate_numericality_of(:quantity).only_integer.
        is_greater_than(0)
      end

      it 'validates the presence of expiration_date' do
        should validate_presence_of :expiration_date
      end

      it 'validates the presence of cost' do
        should validate_presence_of :cost
      end

      it 'validates the numericality of cost' do
        should validate_numericality_of(:cost).is_greater_than_or_equal_to(0)
      end
    end # 'when a new object is created'


    context 'when all field are valid' do
      it 'validates the object' do
        expect(subject).to be_valid
      end
    end

    context 'when the product is nil' do
      it 'includes the product symbol in the error hash' do
        subject.product = nil
        expect {subject.valid?}.to \
          change{subject.errors.include?(:product)}.from(false).to(true)
      end
    end

    context 'when the barcode is nil' do
      it 'includes the barcode symbol in the error hash' do
        subject.barcode = nil
        expect {subject.valid?}.to \
        change{subject.errors.include?(:barcode)}.from(false).to(true)
      end
    end

    context 'when the expiration_date is nil' do
      it 'includes the barcode symbol in the error hash' do
        subject.expiration_date = nil
        expect {subject.valid?}.to \
        change{subject.errors.include?(:expiration_date)}.
        from(false).to(true)
      end
    end

    context '#quantity' do
      it_behaves_like 'a positive integer' do
        let(:field_name){ 'quantity' }
      end
    end

    context '#cost' do
      it_behaves_like 'a non-negative monetary value' do
        let(:field_name){ 'cost' }
      end
    end
  end # describe 'Validations'

  describe '#__elasticsearch__'do
    it "responds to __elasticsearch__ message" do
      expect(subject).to respond_to(:__elasticsearch__)
    end
  end

  describe '#search', elasticsearch: true do
    include_context 'elasticsearch setup', ['Brontek 10ML']

    it 'responds to search call' do
      expect(described_class.respond_to?(:search)).to be true
    end

    context 'when using an empty string as query without limit' do
      it 'returns a response with all records' do
        expect(described_class.search('').records.length).to \
          eq(described_class.count)
      end
    end

    context 'when using an empty string with limit' do
      it 'returns the amount of records in the parameter' do
        expect(described_class.search('', 1).records.length).to eq(1)
      end
    end

    context 'when searching for a complete product name that exists' do
      it 'returns at least one valid record found' do
        expect(Batch.search('Brontek 10ML').results.size).to be > 0
      end
    end

    context 'when searching for a prefix product name that exists' do
      it 'finds at least one valid record' do
        expect(described_class.search('bron').results.size).to be > 0
      end
    end

    context 'when searching for a prefix not in the initial name' do
      it 'finds at least one record' do
        expect(described_class.search('10m').results.size).to be > 0
      end
    end

    context 'when searching using a string with words scrambled' do
      it 'finds at least one record' do
        expect(described_class.search("10ml bronte").results.size).to be > 0
      end
    end

    context 'when searching for a complete barcode' do
      it 'finds a valid record' do
        expect(described_class.search("1234567890123").results.size).to be > 0
      end
    end

    context 'when searching for a partial barcode' do
      it 'finds a valid record' do
        expect(described_class.search("12345").results.size).to be > 0
      end
    end
  end

  describe '#es_query', elasticsearch: true do
    include_context 'elasticsearch setup', ['1_Prod',
      '2_Prod', '3_Prod', '4_Prod', '5_Prod', '6_Prod']

    context 'when there is more records than the per_page value' do
      it 'has the default per_page value in the first page' do
        expect(Batch.es_query('', 1).length).to eq(Batch.default_per_page)
      end

      it 'has some records in the last page' do
        record_count = Batch.count % Batch.default_per_page
        expect(Batch.es_query( '', Batch.page.total_pages).length ).
          to eq(record_count)
      end
    end
  end

  describe '#index_query', elasticsearch: true do
    include_context 'elasticsearch setup', ['1_Prod',
      '2_Prod', '3_Prod', '4_Prod', '5_Prod', '6_Prod']

    context 'when there is no query param' do
      it 'returns all records scoped by page' do
        expect(Batch.index_query( ).length).to eq(Batch.default_per_page)
      end

      it 'orders by product name when no params are given' do
        expect(Batch.index_query( ).first.product_name).to eq('1_Prod')
      end

      it 'returns the records on a diferent page' do
        expect(Batch.index_query('', 2).first.product_name).to eq('6_Prod')
      end

      it 'orders by a given column' do
        expect(Batch.index_query('', 1, 'id', 'desc').first.id).
          to eq(Batch.last.id)
      end
    end
  end
end
