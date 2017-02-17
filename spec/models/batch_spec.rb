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
end
